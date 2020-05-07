# SWAG Data Structure

This document describes the structure of the data in the DelphiDabbler version of the _SWAG_ collection.


## Original data structure

The files and directories described in this section are all part of the original SWAG collection.

There is sufficient information here to entirely describe the collection. The data _could_ be read programatically, but it can be fiddly. An alternative approach is described below.


### Packet files

Each separate piece of Pascal code, program example or tutorial document with the _SWAG_ collection is known as a _packet_.

Each packet is contained in a single plain text file. Most packet files contain Pascal code and have a `.pas` extension. Other packets that contain certain examlles or tutorials have a different file extension: usually, but not always.


### Category directories

The _SWAG_ collection is organised into categories, with each packet being in exactly one category.

There is a sub-directory for each category that contains packet files for each packet in the category.


### Directory meta data

Every category directory has an additional plain text file named `dir.txt`. This file contains information about the contents of the category.

The first line contains a brief description of the category, preceded by the text "SWAG Title:" (without quotes) and a space.

There then follows a separate line for eack packet in the category. The line contains the following information, in columns:

1. Packet file name, without path information. The file must be in the same category as `dir.txt`.
2. Date & time of the packet. The date comes first in US format and two digit year (20th century). Next comes a space followed by the time in HH:MM 24 hour format.
3. The final column contains a brief description of the packet enclosed in double quotes. This is followed by a space, the word "by" (without quotes) and another space. Finally comes the name of the author(s).


#### Problems with `dir.txt` files

In theory, the directory structure and the `dir.txt` files, taken together, entirely describe the SWAG collection in a format that is sufficiently structured to be machine readable.

In practise there are sufficient errors and deviations in `dir.txt` files to make machine reading difficult and error prone.

While it _would_ have been possible to correct the errors in `dir.txt` files the decision was taken to use an alternative approach to providing the collection's meta data.

> **Warning:** Implementors of software that accesses the collection are **strongly advised** to ignore `dir.txt` files and use the alternative data described below. The only reason the files have not been removed is because they provide helpful information to people browsing the collection in a human-readable format.


## Alternative meta data

After giving some thought to correcting and tidying up the `dir.txt` it was decided to replace them with a single XML file for the whole collection. This file is `swag.xml` and it resides in the same directory as the category sub-directories.

This file is in UTF-8 format and is structured as follows.


### Processing instruction

In common with all XML files, this one starts with the obligatory processing instruction:

    <?xml version="1.0" encoding="utf-8"?>


### XML tags


#### `swag`

This is the top level tag that identifies the document's purpose. The whole document is contained within this single `swag` container.

_Attribute:_

* `version` - the file version. **Must** have value `1`.

The `swag` tag contains two tags: `categories` and `snippets`, both of which myst occur exactly once.


#### `swag/categories`

There is a single `categories` tag that is a container for a list of the categories in the SWAG collection.

_Attributes:_

* none

This tag contains multiple `category` tags, one for each category, and nothing else.


#### `swag/categories/category`

The `category` tag is a container for data that defines a single category.

_Attribute:_

* `id` - the unique identifier of the category within the SWAG collection. **Note:** this identifier is also the (case sensitive) name of the category's sub-directory. It's not the best of design choices to make this assumption!

This tag must contain exactly one `title` tag, and nothing else.


#### `swag/categories/category/title`

The `title` tag specifies a brief, descriptive, title of the category identified by the enclosing `category` tag.

_Attributes:_

* none

The content of this tag must be a non-empty string of text and nothing else.


#### `swag/snippets`

There is a single `snippets` tag that is a container for a list of the packets in the SWAG collection.

_Attributes:_

* none

This tag contains multiple `snippet` tags, one for each packet, and nothing else.

> **Note:** a better name for this tag would be _packets_.


#### `swag/snippets/snippet`

The `snippet` tag is a container for data that defines a single SWAG packet.

_Attribute:_

* `id` - an integer identifier. Identifies the packet uniquely within the whole SWAG collection.

This tag must contain exactly one each of the `category-id`, `file-name`, `date`, `title`, `author` and `is-document` tags, and nothing else.

> **Note:** a better name for this tag would be _packet_.


#### `swag/snippets/snippet/category-id`

The `category-id` tag specifies the id of the category that contains the packet identified by the enclosing `snippet` tag.

_Attributes:_

* none

The content of this tag must be a valid category id and nothing else.


#### `swag/snippets/snippet/file-name`

The `file-name` tag specifies the name of the file containing the content of the packet identified by the enclosing `snippet` tag.

_Attributes:_

* none

This tag must contain only the base file name of the packet file, without any path information. The specified file must exist within the directory of the associated category.


#### `swag/snippets/snippet/date`

The `date` tag specifies the date and time of release of the packet identified by the enclosing `snippet` tag.

_Attributes:_

* none

This tag must contain only a date in YYYY-MM-DD format followed by a space and then the time in HH:MM:SS format. The date and time separators must not be localised.


#### `swag/snippets/snippet/title`

The `title` tag specifies a brief, descriptive, title of the packet identified by the enclosing `snippet` tag.

_Attributes:_

* none

The content of this tag must be a non-empty string of text and nothing else.


#### `swag/snippets/snippet/author`

The `author` tag specifies the name(s) of the author(s) of the packet identified by the enclosing `snippet` tag.

_Attributes:_

* none

The content of this tag must be a non-empty string of text and nothing else.


#### `swag/snippets/snippet/is-document`

The `is-document` tag indicates whether or not the packet identified by the enclosing `snippet` tag is a plain text document or not. Packets that are not plain text documents are considered to be Pascal code.!

_Attributes:_

* none

The value of the `is-document` tag must either be `0` indicate the packet is Pascal or `1` to indicate a plain text document.
