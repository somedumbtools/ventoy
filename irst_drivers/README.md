(note: this guide will me updated asap)
# irst_drivers
how to automate the process of loading irst drivers with ventoy's auto-injection feature

## disclaimer (read it please)
> [!warning]
> - **this method only works with ventoy 1.0.55 or later and is limited to windows isos[^1]. <br> standard windows iso and most winpe iso types are supported, but some specific winpe versions may not be compatible.**
> - **to install other operating systems or launch any live cds, you may switch your disk to ahci mode or disable vmd (depending on your disk type)[^2]. <ins>be sure to back up your files before proceeding[^3].</ins>**

## prerequisites

- **ventoy version**: ventoy 1.0.55 or later.
- **windows iso**: a valid windows 10 or 11 iso file.
- **rst drivers**: download the rst drivers from intel’s website.
- **ventoyautorun template**: download the template from the [ventoy github repository](https://github.com/ventoy/WinInjection).

## step 1: prepare the rst drivers

1. **download the setuprst.exe**:
   - visit the [intel download center](https://downloadcenter.intel.com/).
   - download the latest version of setuprst.exe. (example version: 20.0.0.1038.3).

2. **extract the drivers**:
   - open a command prompt and run the following command to extract the drivers:
     ```sh
     SetupRST.exe -extractdrivers RST
     ```
   - the drivers will be extracted to `RST\production\Windows10-x64\15063\Drivers\VMD`.

### step 2: create the ventoyautorun script

1. **write the ventoyautorun.bat file**:
   - create a new file named `VentoyAutoRun.bat`.
   - add the following line to the file:
     ```bat
     if "%PROCESSOR_ARCHITECTURE%"=="AMD64" drvload "X:\VMD\iaStorVD.inf"
     ```
   - this script loads the vmd driver automatically during the windows installation process.

2. **create an archive with the drivers and script**:
   - place the `VMD` folder (containing the extracted drivers) and `VentoyAutoRun.bat` in a single directory.
   - compress these files into a `.7z` archive named `IRST-VMD-19.7z`.

### step 3: configure ventoy for driver injection

1. **copy the archive to ventoy**:
   - connect your ventoy usb drive to your computer.
   - copy the `IRST-VMD-19.7z` archive to the root of the ventoy usb drive.

2. **create/edit the ventoy.json configuration file**:
   - in the root of the ventoy usb drive, locate or create a `ventoy` folder.
   - inside the `ventoy` folder, create or edit the `ventoy.json` file.
   - add the following json configuration:
     ```json
     {
       "injection": [
         {
           "parent": "/win1011",
           "archive": "/IRST-VMD-19.7z"
         }
       ]
     }
     ```
   - this configuration tells ventoy to inject the `IRST-VMD-19.7z` archive when booting a windows 10/11 iso located in the `/win1011` directory on the usb drive.

### step 4: boot windows iso with injected drivers

1. **boot from ventoy**:
   - insert the ventoy usb drive into the target machine.
   - select the windows iso from the ventoy boot menu. ensure the iso is located in the `/win1011` directory on the usb.

2. **automatic driver injection**:
   - ventoy will automatically run the `VentoyAutoRun.bat` script, injecting the rst drivers needed for the installation process.

3. **proceed with windows installation**:
   - the rst drivers should now be loaded, allowing windows to recognize the storage devices.

### acknowledgements
- ventoy (his creator), for the utility itself, for the injection guide and for the wininjection example.
- @gumanzoy (on habr), for his post about loading rst vmd drivers on ventoy[^6].

[^1]: https://www.ventoy.net/en/doc_inject_autorun.html  
[^2]: https://www.intel.com/content/www/us/en/support/articles/000037220/technologies/intel-rapid-storage-technology-intel-rst.html  
[^3]: https://help.ubuntu.com/rst/  
[^4]: https://www.ventoy.net/  
[^5]: https://github.com/ventoy/wininjection.git  
[^6]: https://habr.com/en/posts/776310  