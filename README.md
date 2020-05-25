# SWAG Pascal Code Collection (DelphiDabbler Edition)


This project is based on the last ever release of a large collection of Pascal code and program examples collected by _SWAG_ (the SourceWare Archive Group). This final release came out on 29 November 1997.


## What is SWAG?

This quote from the original SWAG website should explain:

> "SWAG is a collection of source code and program examples for the Pascal programming language. The material has been donated by various Pascal programmers from around the world who desire to contribute to the advancement of one of the greatest programming languages there is. SWAG packets are available in 57 _[sic: now 60]_ different categories covering EVERY aspect of the Pascal language and ALL ABSOLUTELY FREE! The material contained in SWAG is intended to be a teaching and learning aid for users of the Pascal language. Whether you are a beginner or experienced programmer, you'll find SWAG to be an invaluable source of ideas and information."


## Why this version?

While the SWAG collection is old, and much of the code is probably obsolete, there are three reasons to preserve it here:

1. For purely historical or nostalgic reasons. For some time the collection has been disappearing from the web. In fact even my last attempt to preserve it in 2013 is now in danger of being lost.
2. Although the code is old _some_ of it _is_ still usable or of practical interest.
3. My _[CodeSnip](https://github.com/delphidabbler/codesnip)_ program provides the ability to import code from the collection. Due to some changes to web server hosting, a new way of accessing the collection was needed. This project solves that problem.


## About The Collection

The SWAG collection comprises over 4000 pieces of Pascal code and examples. Each one of these is known as a _packet_ in SWAG speak. Each packet is stored in its own file.

This version of the collection is hosted in the [`delphidabbler/swag`](https://github.com/delphidabbler/swag) repository on GitHub.

As in the original, packets are grouped into categories. There is a sub-directory for each category that contains the related packet files, along with a `dir.txt` file that describes the category and the packets.


### What's different with this version?

The collection now has an XML file that provides meta-data that describes the packets and categories and the relationships between them. This file is named `swag.xml`. In a sense this file duplicates information in the `dir.txt` files, **but** those files contain some inconsistencies and are hard to parse from code. `swag.xml` does have some information that is not in the original `dir.txt` files.

> I _know_ those `dir.txt` files are hard to parse because `swag.xml` was generated from them. I had to spend hours hand correcting errors and inconsistencies before I had workable code. To be accurate I actually created an SQL database from the `dir.txt` files and then created `swag.xml` from exported SQL, again with many tucks and tweaks!

A `VERSION` file has also been added to enable applications that access the collection to discover which version of SWAG they are dealing with.

A comprehensive explanation of the collection's data structure and the XML file's tags can be found in the file `swag-data-structure.md`. If you're intending to write code that accesses the data you need to read this.


### The repo

The GitHub repository has the following structure:

~~~
./                        - Repo root: read-me, change log, licenses & release script
  docs/                   - SWAG data structure documentation
  source/                 - Meta data - xml and version information files
    <category-sub-dirs>/  - One sub-directory for each SWAG category, each of which
                            contains the associated packet files and `dir.txt` file.
~~~


## Releases


### Get the latest release

The latest release can be found in the [_releases_ section](https://github.com/delphidabbler/swag/releases) of the GitHub project. Release files are zip files named `dd-swag-<version>.zip`, where `<version>` is the release version number.


### Installing SWAG

Simply extract the zip file into a suitable folder on your computer. The resultant directory structure differs from that in the repository. It is:

~~~
./                        - Contains documentation
  swag/                   - "Root" of swag data. Contains `swag.xml` and `VERSION`
                            files.
    <category-sub-dirs>   - One sub-directory for each SWAG category each of which
                            contains the associated packet files and `dir.txt` file.
~~~

Applications that access the SWAG collection need only the contents of the `swag` directory. The contents of `swag` can be copied anywhere you need it.


### Using SWAG

Their are two ways you can use the release: manually examine the files or use/create a viewer application.


#### Manual browsing

Simply browse the category directories and examine the `package` files. The `dir.txt` files provide the name of the category and, for packages, the description, last update date and author(s).

Use any of the code in the packets as you wish, providing you abide by the relevant license.


#### Viewer application

I don't know of any specialised SWAG viewers that are available right now.

[DelphiDabbler CodeSnip](https://github.com/delphidabbler/codesnip) is a code snippets management program. While not specifically designed for viewing SWAG packets, it can import them as snippets. In fact its import dialogue box provides a self-contained SWAG viewer. From v4.16.0, CodeSnip can be used to access the current release of SWAG.

The other option is to write a viewer. To start from scratch you will need to study `swag-data-structure.md` in the `docs` directory.

CodeSnip's Delphi Pascal source code is available at the above address. The units with a `SWAG` prefix, and the dialogue box code in `FmSWAGImportDlg.pas`, contain the main logic. They depend on other code to read the XML etc., but that's all there too.

> I did have a JavaScript web application that was a SWAG viewer, but it depended on getting SWAG from a REST service that is no longer available. Maybe one day I'll modify that app to get its data from this version of SWAG ... Maybe!



### Redistributing

You can redistribute the whole release as you wish in accordance with the various licenses. You **must** include the license information in any distribution.

The easiest way is simply to redistribute the existing release zip file.

If you want to change the distribution you can meet the requirement to include license information by including the `LICENSE.md`, `gnu-fdl.txt`, `lgpl.txt` and `mit-license.txt` files.


## Building a release

There is a single bash script named `MakeRelease.sh` in the root of the repository. Change into the repository root directory and run the script without parameters.

A zip file named `dd-swag-<version>.zip` (where `<version>` is the release version number) will be created in a `_release` sub-directory of the repository root. The zip file will have the folder structure described in the previous section.

> Note that the `_release` folder is ignored by Git.


### Prerequisites

`MakeRelease.sh` requires the following utilities:

* Info-ZIP's `zip.exe` or compatible.
* The GNU coreutils version of `cp` or compatible.


#### Windows

The bash shell of MINGW32 or similar is recommended for Windows users. MINGW32 comes with the correct version of `cp` pre-installed (v8.31 was used to build the release).

MINGW32 does not come with Info-ZIP `zip.exe` by default. However it can be downloaded from the _Files_ section of the [GNUWin32 project](https://sourceforge.net/projects/gnuwin32/) on SourceForge. You need Zip v3 which also requires the BZip2 library. Get these as follows.

1. Go to the [`zip/3.0/`](https://sourceforge.net/projects/gnuwin32/files/zip/3.0/) directory and download `zip-3.0-bin.zip`. Unzip the downloaded file, navigate to the `bin` directory and copy `zip.exe` to the `.\bin` folder of the MINGW32 installation.
2. Go to the [`bzip2/1.0.5`](https://sourceforge.net/projects/gnuwin32/files/bzip2/1.0.5/) directory and download `bzip2-1.0.5-bin.zip`. Unzip it, move into the `bin` directory and copy `bzip2.dll` to the same directory as `zip.exe`.

MINGW32 will now be able to use `zip.exe`. You may need to restart your terminal for changes to take effect.


## Contributing

You are welcome to contribute updates and fixes to the code used to manage the SWAG collection.

> **Note:** Please do not submit any changes to the original SWAG package files: they are frozen. The purpose of this project is simply to provide developers with easy programmatic access to the existing collection.

The GitFlow methodology is used in developing the project, so please fork the repo and create a feature branch off the `develop` branch and create your contribution there. Open a pull request when done.


## Licensing

Licensing is a little complicated. For full details see the file `LICENSE.md`. The following is a brief summary:

* Code and examples from the original SWAG database are licensed under whichever is the most appropriate of the GNU Lesser General Purpose License or the GNU Free Documentation License, unless the package file has a statement to the contrary.
* Any code or documentation added to the DelphiDabbler version of the collection is licensed under the MIT License.


## Acknowledgements

Thanks are due to the following:

* Gayle Davis, the original keeper of the SWAG collection.
* Jim McKeeth, who created a website version of the collection around 2001. The original SWAG code used here was obtained from Jim's site.
* The [Boise Software Developer's Group](http://www.bsdg.org/), who hosted the original SWAG collection.


## Change Log

Changes are documented in the file `CHANGELOG.md`.
