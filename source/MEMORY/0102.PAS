{*******************************}
{*         Модуль простого     *}
{*  многопроцессного монитора  *}
{*          VSTasks v 1.01     *}
{*   для Turbo Pascal ver 7.0  *}
{* (c) Copyright VVSsoft Group *}
{*******************************}
{$F+$S-}

{  v.1.01  ---  по сравнению с версией 1.0 исправлен выход из процесса- }
{               процедуры по достижению  END. В предыдущей версии нужно }
{               было обязательно перед END-ом ставить  HaltCurrentTask, }
{               иначе  система "висла".  Теперь  при  достижении  конца }
{               процесса-процедуры автоматом процесс закрывается ...    }
{                                                                       }
{                               (c) VVSsoft Group.  Кононов Владимир.   }

Unit VSTasks;

interface {--------------------------------------------}

Type

 PTaskRec =^TTaskRec;  { ---- описатель процесса -----}
 TTaskRec =
  record
   NumProc  : word;        { уникальный номер процесса }
   Next     : PTaskRec;    { следующий описатель процесса }
   OrignSP,                { значение SP для возврата }
   OrignSS  : word;        { значение SS для возврата }
   Stack    : pointer;     { указатель на стек процесса }
   SSize    : word;        { размер стека процесса }
  end;

Const

  CountTask   : word = 0;       { всего зарегистрированно процессов }
  PCurTask    : PTaskRec = Nil; { указатель на текущую выполняемую задачу }
  HeadStack   : PTaskRec = Nil; { указатель на голову стека }
  UniNumber   : word = 1;       { уникальный номер для создаваемого процесса }
  CurTask     : word = 0;       { номер текущего процесса }

{----------------- коды ошибок регистрации процесса --------------}

  vstMemoryLow       = 1;   { нет памяти для создания стека процесса }
  vstEmptyStackTask  = 2;   { нет зарегистрированных процессов }
  vstMAXLimitProc    = 3;   { слишком много процессов }

Var
  TaskError     : byte;     { последняя ошибка }


procedure StartTasks;
{--- запуск процессов на выполнение ---}

procedure SwithTasks; far;
{--- переключение между задачами ---}

function RegisterTask(TaskPoint : pointer; SizeStack: word): word;
{--- регистрация задачи если - 0, то ошибка в переменной TaskError ---}
{--- возвращает номер зарегистрированного процесса ---}

procedure HaltCurrentTask;
{--- снятие текущей задачи ---}

procedure HaltAllTasks;
{--- снятие всех задач ---}

implementation
{----------------------------------------------------------------}

Var
    OriginalSS,                { адрес оригинального стека программы     }
    OriginalSP     : word;     { указатель оригинального стека программы }
    PDopPoint      : PTaskRec; { дополнительный указатель }

{------- переопределенные функции для работы с BASMом ---------}

function mMemAvail: word;
Var M: longint;
    T: record
        L,H: word;
       end;
begin
 M:=MaxAvail;
 If M>$FFFF then mMemAvail:=$FFFF
  else
   begin
    Move(M,T,SizeOf(longint));
    mMemAvail:=T.L;
   end;
end;

function mGetMem(S:word): pointer;
Var P:pointer;
begin
 GetMem(P,S);
 mGetMem:=P;
end;

procedure mFreeMem(P: pointer;S: word);
Var D: pointer;
begin
 D:=P;
 FreeMem(P,S);
end;

procedure StartTasks; assembler;
{ --- запуск процессов на выполнение --- }
asm
    { 1) Запомнить в стеке регистры;
      2) Запомнить в стеке точку выхода из менеджера процессов;
      3) Сохранить регистры SS и SP для основной программы;
      4) Найти первый процесс для запуска;
      5) Переустановить все текущие переменные;
      6) Переустановить SS:SP и восстановить регистры;
      7) Произвести "длинный выход" (читай вход) RETF в процесс;
      8) После возврата в точку выхода из процесса, восстановить
         регистры. }
   {----------------------------------------------------}
                 PUSH BP                    { сохраняем регистры            }
                 PUSH DI                    {}
                 PUSH SI                    {}
                 PUSH DS                    {}
                 PUSH ES                    {}
                 LEA  DI, @ExitPoint        { в DI смещение выхода          }
                 PUSH CS                    { сохраняем точку выхода из     }
                 PUSH DI                    { процессов                     }
                 MOV  OriginalSS, SS        { сохраняем SS:SP               }
                 MOV  OriginalSP, SP        {}
                 MOV  AX, CountTask         { если нет зарегистриров. задач }
                 XOR  BX, BX                {}
                 CMP  AX, BX                {}
                 JE   @Exit                 { очередь процессов пуста       }
                 MOV  DI, HeadStack.word[0] { в ES:DI указатель на          }
                 MOV  ES, HeadStack.word[2] { описатель процесса            }
                 MOV  AX, ES:[DI]           { номер текущего процесса       }
                 MOV  CurTask, AX           {}
                 MOV  PCurTask.word[0], DI  { PCurTask равно первому        }
                 MOV  PCurTask.word[2], ES  { процессу                      }
                 CLI                        {}
                 MOV  SS, ES:[DI+8]         { переустановка стека           }
                 MOV  SP, ES:[DI+6]         {}
                 STI                        {}
                 POP  BP                    { востанавливаем регистры       }
                 POP  ES                    { процесса                      }
                 POP  DS                    {}
                 RETF                       { "выход" в процесс             }
 @Exit:          POP  AX                    { достаем из стека ненужное     }
                 POP  AX                    {}
                 MOV  AL, vstEmptyStackTask {}
                 MOV  TaskError, AL         {}
 @ExitPoint:     POP  ES                    { восстанавливаем регистры      }
                 POP  DS                    {}
                 POP  SI                    {}
                 POP  DI                    {}
                 POP  BP                    {}
end;

procedure SwithTasks; assembler;
{ --- переключение между задачами --- }
asm
    { 1) Cохранение всех регистров текущего процесса [DS,ES,BP];
      2) Нахождение следующего процесса для исполнения;
      3) Cохранение указателей SS:SP на стек текущего процесса;
      4) Изменение указателей SS:SP на стек для последующего процесса;
      5) Изменение всех текущих переменных;
      6) Восстановление регистров для нового процесса [BP,ES,DS]; }
   {-----------------------------------------------------------------}
                 PUSH DS                    { сохранение регистров старого  }
                 PUSH ES                    { процесса                      }
                 PUSH BP                    {}
                 MOV  AX, SEG @Data         { установка сегмента данных     }
                 MOV  DS, AX                {}
                 MOV  ES, PCurTask.word[2]  { в ES:DI указатель на описатель}
                 MOV  DI, PCurTask.word[0]  { текущего процесса             }
                 MOV  ES:[DI+8], SS         { сохраняем SS:SP в текущем     }
                 MOV  ES:[DI+6], SP         { описателе процесса            }
                 MOV  BX, ES:[DI+4]         { в BX:SI указатель на следующий}
                 MOV  SI, ES:[DI+2]         { процесс                       }
                 MOV  ES, BX                { уже в ES:SI                   }
                 XOR  AX, AX                { проверка на Nil               }
                 CMP  BX, AX                {}
                 JNE  @Next                 { если не Nil-к обработке       }
                 CMP  SI, AX                {}
                 JNE  @Next                 {}
                 MOV  ES, HeadStack.word[2] { иначе следующий - начальный   }
                 MOV  SI, HeadStack.word[0] { описатель HeadStack           }
 @Next:          MOV  PCurTask.word[2], ES  { меняем указатель на текущий   }
                 MOV  PCurTask.word[0], SI  { описатель                     }
                 MOV  AX, ES:[SI]           { меняем номер текущего процесса}
                 MOV  CurTask, AX           {}
                 CLI                        {}
                 MOV  SS, ES:[SI+8]         { меняем указатели стека        }
                 MOV  SP, ES:[SI+6]         { под новый процесс             }
                 STI                        {}
                 POP  BP                    { восстановление регистров      }
                 POP  ES                    { нового процесса               }
                 POP  DS                    {}
end;

function RegisterTask(TaskPoint: pointer; SizeStack: word): word; assembler;
{ --- регистрация задачи --- }
{ если вощзвращен 0, то ошибка в переменной TaskError }
asm
    { 1) Создание в памяти описателя процесса;
      2) Выделение памяти под стек процесса;
      3) Нахождение уникального описателя процесса;
      4) Увязка описателя нового процесса в цепочку процессов;
      5) Сохранение в стеке процесса адреса входа в процесс и регистров;
      6) Выход в основную программу. }
    {---------------------------------------------------------}
                 XOR  AX, AX                {}
                 NOT  AX                    {}
                 CMP  AX, UniNumber         {}
                 JE   @TooManyProc          { слишком много процессов       }
                 CALL mMemAvail             { проверка наличия памяти       }
                 MOV  BX, SizeStack         {}
                 CMP  AX, BX                {}
                 JB   @LowMem               { если памяти нет               }
                 PUSH BX                    {}
                 CALL mGetMem               { в DX:AX указатель на стек     }
                 PUSH DX                    {}
                 PUSH AX                    {}
                 CALL mMemAvail             { память для TTaskRec           }
                 MOV  CX, TYPE TTaskRec     {}
                 CMP  AX, CX                {}
                 JB   @LowMemAndFree        { если не хватит                }
                 PUSH CX                    { готовим параметры             }
                 CALL mGetMem               { выделяем память               }
                 PUSH ES                    {}
                 MOV  ES, DX                { ES:DI указывает на описатель  }
                 MOV  DI, AX                { нового процесса               }
                 MOV  AX, UniNumber         { присваиваем уникальный номер  }
                 MOV  ES:[DI], AX           {}
                 INC  AX                    { инкремент UniNumber           }
                 MOV  UniNumber, AX         {}
                 MOV  BX, HeadStack.word[0] { указатель на следующий        }
                 MOV  CX, HeadStack.word[2] { описатель = HeadStack         }
                 MOV  ES:[DI+2], BX         {}
                 MOV  ES:[DI+4], CX         {}
                 POP  CX                    { в CX  значение ES             }
                 POP  AX                    { в AX смещение стека           }
                 MOV  ES:[DI+10], AX        { смещение указателя Stack      }
                 MOV  BX, SizeStack         { сохраняем размер стека в      }
                 MOV  ES:[DI+14], BX        { SSize текущего описателя      }
                 ADD  AX, BX                { вычисляем значение SP         }
                 JNC  @NotCorrect           { если коррекция не нужна       }
                 XOR  AX, AX                {}
                 NOT  AX                    { AX=$FFFF                      }
 @NotCorrect:    SUB  AX, $01               {}
                 POP  BX                    { в BX сегмент стека            }
                 MOV  ES:[DI+12], BX        { сегмент указателя Stack       }
                 MOV  ES:[DI+8], BX         { OrignSS=BX                    }
                 PUSH ES                    { сохраняем сегмент указателя   }
                 MOV  ES, CX                { восстановили ES               }
                 MOV  CX, TaskPoint.WORD[0] { смещение начала задачи        }
                 MOV  DX, TaskPoint.WORD[2] { сегмент начала задачи         }
                 PUSH BP
                 CLI                        {}
                 MOV  SI, SS                { сохраняем SS в SI             }
                 MOV  BP, SP                { сохраняем SP в BP             }
                 MOV  SS, BX                { переустанавливаем стек        }
                 MOV  SP, AX                {}
                 MOV  BX,SEG    HaltCurrentTask { автоматический выход в    }
                 MOV  AX,OFFSet HaltCurrentTask { процедуру HaltCurrentTask }
                 PUSH BX                    { по достижению оператора END   }
                 PUSH AX                    { текущей процедуры-процесса    }
                 PUSH DX                    { сохраняем точку входа в       }
                 PUSH CX                    { процесс                       }
                 PUSH DS                    { сохраняем в нем DS            }
                 PUSH ES                    { -\\- ES                       }
                 MOV  DX, SP                { готовим псевдо BP             }
                 ADD  DX, $02               { заталкиваем его в стек        }
                 PUSH DX                    {}
                 MOV  CX, SP                {}
                 MOV  SS, SI                { восстанавливаем стек          }
                 MOV  SP, BP                {}
                 STI                        {}
                 POP  BP                    { восстанавливаем BP            }
                 MOV  AX, ES                {}
                 POP  ES                    {}
                 MOV  ES:[DI+6], CX         { OrignSP=CX                    }
                 PUSH ES                    {}
                 MOV  ES, AX                {}
                 POP  AX                    {}
                 MOV  HeadStack.WORD[0], DI { переустанавливаем указатель   }
                 MOV  HeadStack.WORD[2], AX { HeadStack                     }
                 MOV  AX, CountTask         { инкрементируем CountTask      }
                 INC  AX                    {}
                 MOV  CountTask, AX         {}
                 MOV  AX, UniNumber         { возвращаемый номер процесса   }
                 DEC  AX                    {}
                 JMP  @Exit                 { выход из процедуры            }
 @TooManyProc:   MOV  AL, vstMAXLimitProc   {}
                 MOV  TaskError, AL         {}
                 JMP  @ErrExit              {}
 @LowMemAndFree: MOV  BX, SizeStack         {}
                 PUSH BX                    {}
                 CALL mFreeMem              {}
 @LowMem:        MOV  AL, vstMemoryLow      {}
                 MOV  TaskError, AL         {}
 @ErrExit:       XOR  AX, AX                {}
 @Exit:
end;

procedure HaltCurrentTask; assembler;
{ --- снятие текущей задачи --- }
asm
    { 1) Нахождение в очереди процессов следующего процесса;
      2) Переключение на его SS и SP;
      3) Переустановка всех переменных;
      4) Уничтожение стека предыдущего процесса;
      5) Удаление из очереди процессов описателя процесса;
      6) Удаление из памяти описателя процесса;
      7a) Если был найден следующий процесс - то восстановление
          его регистров и RETF;
      7b) Если больше процессов нет, то установка SS:SP основной
          программы и RETF в нее. }
   {--------------------------------------------------------------}
                 MOV  AX, SEG @Data         { переустановка сегмента DS     }
                 MOV  ES, PCurTask.word[2]  { в ES:DI указатель на текущий  }
                 MOV  DI, PCurTask.word[0]  { описатель                     }
                 XOR  AX, AX                { обнуление дополнительного     }
                 MOV  PDopPoint.word[0], AX { указателя                     }
                 MOV  PDopPoint.word[2], AX {}
                 MOV  AX, ES                { AX:DI                         }
                 MOV  DX, HeadStack.word[2] { в DX:BX значение начала стека }
                 MOV  BX, HeadStack.word[0] { процессов                     }
 @Loop:          CMP  DX, AX                { проверка равенства указателей }
                 JNE  @NextProc             { AX:DI и DX:BX                 }
                 CMP  BX, DI                { если не равны, то поиск равных}
                 JNE  @NextProc             {}
                 JMP  @DelProcess           { к удалению процесса           }
 @NextProc:      MOV  ES, DX                { строим регистровую пару       }
                 MOV  SI, BX                { ES:SI - указатель             }
                 MOV  PDopPoint.word[0], BX { сохраняем указатель на        }
                 MOV  PDopPoint.word[2], DX { предыдущий элемент описатель  }
                 MOV  DX, ES:[SI+4]         { в DX:BX указатель на следующий}
                 MOV  BX, ES:[SI+2]         { элемент стека описателей      }
                 JMP  @Loop                 {}
 @DelProcess:    MOV  ES, AX                { ES:DI                         }
                 MOV  BX, ES:[DI+2]         { в BX смещение следующего      }
                 MOV  PCurTask.word[0], BX  { элемента                      }
                 MOV  DX, ES:[DI+4]         { тоже с сегментом              }
                 MOV  PCurTask.word[2], DX  {}
                 XOR  CX, CX                { проверяем PDopPoint на Nil    }
                 CMP  CX, PDopPoint.word[0] {}
                 JNE  @NotNil               { если не Nil                   }
                 CMP  CX, PDopPoint.word[2] {}
                 JNE  @NotNil               {}
                 MOV  HeadStack.word[0], BX { переставляем указатель на     }
                 MOV  HeadStack.word[2], DX { начало стека                  }
                 JMP  @FreeMem              {}
 @NotNil:        PUSH ES                    {}
                 PUSH DI                    {}
                 MOV  ES, PDopPoint.word[2] { в ES:DI указатель на          }
                 MOV  DI, PDopPoint.word[0] { предыдущий элемент            }
                 MOV  ES:[DI+2], BX         { переставляем указатель Next у }
                 MOV  ES:[DI+4], DX         { предыдущего элемента          }
                 POP  DI                    { в ES:DI указатель на удаляемый}
                 POP  ES                    { элемент                       }
 @FreeMem:       CLI                        {}
                 MOV  SS, OriginalSS        { восстанавливаем стек          }
                 MOV  SP, OriginalSP        { основной программы            }
                 STI                        {}
                 MOV  DX, ES:[DI+12]        { в DX:BX указатель на  стек    }
                 MOV  BX, ES:[DI+10]        { удаляемого процесса           }
                 MOV  CX, ES:[DI+14]        { в CX размер стека             }
                 PUSH ES                    {}
                 PUSH DI
                 PUSH DX                    { готовим стек и освобождаем    }
                 PUSH BX                    { память стека удаляемого       }
                 PUSH CX                    { процесса                      }
                 CALL mFreeMem              {}
                 POP  DI                    {}
                 POP  ES                    {}
                 MOV  CX, TYPE TTaskRec     { размер записи TTaskRec -> CX  }
                 PUSH ES                    { удаляем описатель процесса из }
                 PUSH DI                    { памяти                        }
                 PUSH CX                    {}
                 CALL mFreeMem              {}
                 XOR  AX, AX                { обнулить номер теущего процесса}
                 MOV  CurTask, AX           {}
                 MOV  AX, CountTask         { декремент CountTask           }
                 DEC  AX                    {}
                 MOV  CountTask, AX         {}
                 JZ   @Exit                 { процессов больше нет          }
                 MOV  ES, PCurTask.word[2]  { PCurTask -> ES:DI             }
                 MOV  DI, PCurTask.word[0]  {}
                 MOV  BX, ES                {}
                 XOR  AX, AX                {}
                 CMP  AX, BX                { если PCurTask не равен        }
                 JNE  @SetProcess           { Nil, то переустановить        }
                 CMP  AX, DI                { текущий процесс               }
                 JNE  @SetProcess           {}
                 MOV  ES, HeadStack.word[2] { HeadStack -> ES:DI            }
                 MOV  DI, HeadStack.word[0] {}
                 MOV  PCurTask.word[2], ES  { ES:DI -> PCurTask             }
                 MOV  PCurTask.word[0], DI  {}
 @SetProcess:    MOV  AX, ES:[DI]           { NumProc -> AX                 }
                 MOV  CurTask, AX           {}
                 CLI                        {}
                 MOV  SS, ES:[DI+8]         { переустановка стека           }
                 MOV  SP, ES:[DI+6]         {}
                 STI                        {}
                 POP  BP                    { восстановление регистров      }
                 POP  ES                    { процесса                      }
                 POP  DS                    {}
 @Exit:
end;

procedure HaltAllTasks; assembler;
{ --- снятие всех задач --- }
asm
    { 1) Обнуление всех переменных;
      2) Удаление очереди процессов со стеками;
      3) Установка SS:SP основной программы и RETF в нее. }
                 MOV  AX, SEG @Data         { восстанавливаем сегмент DS    }
                 MOV  DS, AX                {}
                 XOR  AX, AX                { PCurTask=Nil                  }
                 MOV  PCurTask.word[0], AX  {}
                 MOV  PCurTask.word[2], AX  {}
                 CLI                        {}
                 MOV  SS, OriginalSS        { восстанавливаем стек программы}
                 MOV  SP, OriginalSP        {}
                 STI                        {}
 @Loop:          XOR  AX, AX                {}
                 CMP  AX, CountTask         { смотрим есть ли процессы      }
                 JE   @StackEmpty           { если нет выход                }
                 MOV  ES, HeadStack.word[2] { в ES:DI указатель на первый   }
                 MOV  DI, HeadStack.word[0] { элемент очереди процессов     }
                 MOV  DX, ES:[DI+4]         { DX:BX указатель на следующий  }
                 MOV  BX, ES:[DI+2]         { элемент стека или Nil         }
                 MOV  HeadStack.word[2], DX { HeadStack = DX:BX             }
                 MOV  HeadStack.word[0], BX {}
                 MOV  AX, ES:[DI+12]        { в AX:CX указатель на стек     }
                 MOV  CX, ES:[DI+10]        { процесса                      }
                 PUSH ES                    { готовим стек для вызова проце-}
                 PUSH DI                    { дуры очистки памяти           }
                 PUSH AX                    { AX:CX - указатель на стек     }
                 PUSH CX                    { процесса                      }
                 MOV  AX, ES:[DI+14]        { в AX размер стека             }
                 PUSH AX                    {}
                 CALL mFreeMem              { уничтожаем стек процесса      }
                 MOV  AX, TYPE TTaskRec     { в AX размер описателя процесса}
                 PUSH AX                    {}
                 CALL mFreeMem              { уничтожаем описатель процесса }
                 MOV  AX, CountTask         { декрементируем CountTask      }
                 DEC  AX                    {}
                 MOV  CountTask, AX         {}
                 JMP  @Loop                 { уничтожать следующий процесс  }
 @StackEmpty:    MOV  CurTask, AX           { CurTask=0                     }
end;

{----------------------------------------------------------------}
end.
