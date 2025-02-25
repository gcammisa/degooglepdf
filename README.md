# degooglepdf
Download **view only protected** PDF files from Google Drive. Optimized for **large** and **high quality** files.

## Howto
1. Open the desired file at Google Drive in your web browser
2. Open the browser's JS console and copy-paste the script from `downloader.js`
3. Watch the script scroll through the document and wait for the download
4. Run `mkpdf.sh [file]` to create a PDF file

## Hint
Do you need to fix up the pages before creating a PDF?

5. Manipulate the images in the folder named after your file
6. Run `mkpdf.sh [file]` again and press "y" when asked to use those existing files

## Technical details
The browser part `downloader.js` first simulates a high DPI display to request high resolution pages (you may vary the devicePixelRatio).
It then automatically scrolls the displayed PDF to make sure all pages are being loaded.
Then the pages (stored as JPEGs in base64-encoded format) will be archived and provided as download.

The bash script `mkpdf.sh` extracts all images from the archive, processes and then combines them to a proper PDF file.

## Application
Someone may have uploaded a PDF file to their Google Drive, but set it to view-only mode. This is problematic in several totally legitimate situations:
* Offline viewing
* Viewing without Google tracking
* Permanent archival
* Uploader is gatekeeping content they didn't create

## Inspiration
* Original idea: https://codingcat.codes/2019/01/09/download-view-protected-pdf-google-drive-js-code/
* Browser part based on: https://github.com/zeltox/Google-Drive-PDF-Downloader

## Requirements
* Webbrowser with JS console
* Unix-like system (`bash`, `sed`)
* ImageMagick (`convert`)
Hint: GNU/Linux users have that, Mac users just need to install ImageMagick via MacPorts or Homebrew.

### Requirements for windows users
On windows you need to manually install all the required dependecies:
* ImageMagick: https://imagemagick.org/script/download.php#windows
* sed: https://gnuwin32.sourceforge.net/packages/sed.htm
* base64: https://www.di-mgt.com.au/base64-for-windows.html#downloads

If you're on windows, you should run `mkpdf.ps1` in a Powershell console instead of `mkpdf.sh`