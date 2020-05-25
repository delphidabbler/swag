# SWAG Data Structure

This document describes the structure of the data in the DelphiDabbler version of the _SWAG_ collection.


## Original data structure

The files and directories described in this section are all part of the original SWAG collection.

There is sufficient information here to entirely describe the collection. _In theory_ the data could be read programmatically, but in practise it is extremely difficult because of inconsistencies in the data. An alternative approach is described below.


### Packet files

Each separate piece of Pascal code, program example or tutorial document with the _SWAG_ collection is known as a _packet_.

Each packet is contained in a single plain text file. Most packet files contain Pascal code and have a `.pas` extension. Other packets that contain certain examples or tutorials usually have a different file extension: usually, but not always.


### Category directories

The _SWAG_ collection is organised into categories, with each packet being in exactly one category.

There is a sub-directory for each category that contains a packet file for each packet in the category.


### Directory meta data

Every category directory has an additional plain text file named `dir.txt`. This file contains information about the contents of the category.

The first line contains a brief description of the category, preceded by the text `SWAG Title:` (without quotes) and a space.

There then follows a separate line for each packet in the category. The line contains the following information, in columns:

1. Packet file name, without path information. The file must be in the same category as `dir.txt`.
2. Date & time of the packet. The date comes first in US format with a two digit year representing years in the 20th century. Next comes a space followed by the time in HH:MM 24 hour format.
3. The final column contains a brief description of the packet and the names of the author(s). The column has the following content, from left to right:
    1. the description enclosed in double quotes
    2. white space
    3. the word `by`
    4. white space
    5. author information (terminated by the end of the line)

Here is a example packet line (taken from an actual `dir.txt` file):

~~~
0024.PAS      01-27-94  13:34  "File Finder" by ROBERT ROTHENBURG
~~~


#### Problems with `dir.txt` files

In theory, the directory structure and the `dir.txt` files, taken together, entirely describe the SWAG collection in a format that is sufficiently structured to be machine readable.

In practise there are sufficient errors and deviations in `dir.txt` files to make machine reading difficult and error prone.

While it _would_ have been possible to correct the errors in `dir.txt` files the decision was taken to use an alternative approach to providing the collection's meta data.

> **Warning:** Implementors of software that accesses the collection are **strongly advised** to ignore `dir.txt` files and use the alternative data described below. The only reason the files have not been removed is because they provide helpful information to people browsing the collection by eye.


## Alternative meta data

After giving some thought to correcting and tidying up the `dir.txt` files it was decided to ignore them and instead use a single XML file to describe the whole collection. This file is `swag.xml` and it resides in the same directory as the category sub-directories.

This file is in UTF-8 format and is structured as follows.


### Processing instruction

In common with all XML files, this one starts with the obligatory processing instruction:

    <?xml version="1.0" encoding="utf-8"?>


### XML tags


#### `swag`

This is the top level tag that identifies the document's purpose. The whole document is contained within this single `swag` container.

_Attribute:_

* `version` - the file version. **Must** have value `1`.

The `swag` tag contains two sub-tags: `categories` and `packets`, both of which must occur exactly once.


#### `swag/categories`

There is a single `categories` tag that is a container for a list of the categories in the SWAG collection.

_Attributes:_

* none

This tag contains multiple `category` sub-tags, one for each category, and nothing else.


#### `swag/categories/category`

The `category` tag is a container for data that defines a single category.

_Attribute:_

* `id` - a positive integer identifier. Identifies the category uniquely within the whole SWAG collection.

This tag must contain exactly one `title` sub-tag, and nothing else.


#### `swag/categories/category/title`

The `title` tag specifies a brief, descriptive, title of the category identified by the enclosing `category` tag.

_Attributes:_

* none

The content of this tag must be a non-empty string of text. It has no sub-tags.


#### `swag/packets`

There is a single `packets` tag that is a container for a list of the packets in the SWAG collection.

_Attributes:_

* none

This tag contains multiple `packet` sub-tags, one for each packet, and nothing else.


#### `swag/packets/packet`

The `packet` tag is a container for data that defines a single SWAG packet.

_Attribute:_

* `id` - a positive integer identifier. Identifies the packet uniquely within the whole SWAG collection.

This tag must contain exactly one each of the `category-id`, `file-name`, `date`, `title`, `author` and `is-document` sub-tags, and nothing else.


#### `swag/packets/packet/category-id`

The `category-id` tag specifies the id of the category that contains the packet identified by the enclosing `packet` tag.

_Attributes:_

* none

The content of this tag must be a valid category id. There are no sub-tags.


#### `swag/packets/packet/file-name`

The `file-name` tag specifies the path to a file containing the content of the packet identified by the enclosing `packet` tag.

_Attributes:_

* none

The packet file name must be prefixed with the path to the file relative to the location of the XML file. There is no restriction on the depth of the path and the path may be empty if the packet file is in the same directory as the XML file. The file must exist.

This tag has no sub-tags.


#### `swag/packets/packet/date`

The `date` tag specifies the date and time of release of the packet identified by the enclosing `packet` tag.

_Attributes:_

* none

This tag must contain only a date in YYYY-MM-DD format followed by a space and then the time in HH:MM:SS format. The date and time separators must not be localised.

This tag had no sub-tags.


#### `swag/packets/packet/title`

The `title` tag specifies a brief, descriptive, title of the packet identified by the enclosing `packet` tag.

_Attributes:_

* none

The content of this tag must be a non-empty string of text. There are no sub-tags.


#### `swag/packets/packet/author`

The `author` tag specifies the name(s) of the author(s) of the packet identified by the enclosing `packet` tag.

_Attributes:_

* none

The content of this tag must be a non-empty string of text. There are no sub-tags.


#### `swag/packets/packet/is-document`

The `is-document` tag indicates whether or not the packet identified by the enclosing `packet` tag is a plain text document or not. Packets that are not plain text documents are considered to be Pascal code.

_Attributes:_

* none

The value of the `is-document` tag must either be `0` indicate the packet is Pascal or `1` to indicate a plain text document.

This tag has no sub-tags.


## Version information

The collection's release version is recorded in a `VERSION` file in the same directory as `swag.xml`. The file is in plain UTF-8 format, without BOM.

There is just a single line of text in the file which comprises a version number in the form `x.y.z` or `x.y.z-<prerel>`, where `x`, `y` and `z` are the major, minor and patch version numbers and `<prerel>` specifies a pre-release version. Examples are `1.0.0`, `1.1.0-beta.1`, `2.0.0-alpha` and `2.2.0-rc.1`.
