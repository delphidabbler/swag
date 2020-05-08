# SWAG Pascal Code Collection (DelphiDabbler Edition)


This project is based on the last ever release of a large collection of Pascal code and program examples collected by _SWAG_ (the SourceWare Archive Group). This final release came out on 29 November 1997.


## What is SWAG?

This quote from the original SWAG website should explain:

> "SWAG is a collection of source code and program examples for the Pascal programming language. The material has been donated by various Pascal programmers from around the world who desire to contribute to the advancement of one of the greatest programming languages there is. SWAG packets are available in 57 _[sic: now 60]_ different categories covering EVERY aspect of the Pascal language and ALL ABSOLUTELY FREE! The material contained in SWAG is intended to be a teaching and learning aid for users of the Pascal language. Whether you are a beginner or experienced programmer, you'll find SWAG to be an invaluable source of ideas and information."


## Why this repo?

While the SWAG collection is old, and much of the code is probably obsolete, there are three reasons to preserve it here:

1. For purely historical or nostalgic reasons. For some time the collectikn has been disappearing from the web. In fact even my last attempt to preserve it in 2013 is now in danger of being lost.
2. Although the code is old _some_ of it _is_ still usable or of practical interest.
3. My _[CodeSnip](https://github.com/delphidabbler/codesnip)_ program provides the ability to import code from the collection. Due to some possible changes to my web server, hinted at above, a new way of accessing the collection may be needed. This project solves that problem.


## About The Collection

The SWAG collection comprises over 4000 pieces of Pascal code and examples. Each one of these is known as a _packet_ in SWAG speak. Each packet is stored in its own file.

Packets are grouped into categories. There is a directory for each category that contains the related packet files. These directories can be found in the `source` directory.

Finally, there is an XML file that provides meta-data that describes the packets and categories and the relationship between them. This file is named `swag.xml` and is in the `source` directory.

A comprehensive explanation of the data structure and the XML file's tags can be found in the file `swag-data-structure.md` in the `docs` directory.


## Releases and Installation

The latest release can be found in the _release_ tab of the GitHub `delphidabbler/swag` project.

Releases are provided in zip files. Simply extract the zip file into a suitable folder on your computer.


## Contributing

You are welcome to contribute updates and fixes to the new code added in this version of the collection.

The GitFlow methodology is used in developing the project, so please fork the repo and create a feature branch off the `develop` branch and create your contribution there. Open a pull request when ready.

> **Note:** Please do not submit any changes to the original SWAG collection: it is frozen. The purpose of this project is only to provide access to the existing collection.


## Licensing

Licensing is a little complicated. For full details see the file `LICENSE.md`. The following is a brief summary:

* Code and examples from the original SWAG database are licensed under whichever is the most appropriate of the GNU Lesser General Purpose License or the GNU Free Documentation License, unless the code or example has a statement to the contrary.
* Any code or documenation added the DelphiDabbler version of the collection is licensed under the MIT License.


## Acknowledgements

Thanks are due to the following:

* Gayle Davis, the original keeper of the SWAG.
* Jim McKeeth, who created a website version of the collection around 2001. The original SWAG code used here was obtained from Jim's site.
* The [Boise Software Developer's Group](http://www.bsdg.org/), who hosted the original SWAG collection. 


## Change Log

Changes are documented in the file `CHANGELOG.md`.
