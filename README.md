# **winstaller app installer**
```
part 1 : lign 10-25
part 2 : lign 34-35
part 3 : lign 44-47
part 4 : lign 56-57
```
mistakes are in the app, this is not fully wanned but please do with it

**I - Informations**
  Winstaller is a tool to create app installers that are automated, it will not use existing ones and will not auto-package your app
  - adding files :
    put them in the zip archive at
    ```software\archive.zip```.
  - adding registry tweaks :
    write them to
    ```software\registery-add.reg```
    and allow registry modifications while building
    only allowed registry paths are modifyable but by default are
    ```HKEY_CURRENT_USER\Software\%appname%\```
    (with ```%appname``` being set and being your app's name)
  - building installer :
    run
    ```build.bat```
    and follow the on-screen instructions, if the file is missing, the readmes are here to help, you see a filename prefic followed by a readme suffix for each file.








**II - custom banners**
  custom banners aren't easy to setup, but will be made easier later. the banner is replacable but long to be replaced, so it is not recommended








**III - msdefender flagging**
  By default, msdefender flags the app as malicious, to fix that, open  the windows defender and go to 
  ```protection history```
  and allow the "malicious" app. it should be the zip archive, or else you have been infected. if you have gotten a malware, since the app doesn't checksum itself, it can still run after infected. this is not intentionnal if you get infected.








**IV - finish up**
  put your app installer in a brand-new archive, NOT THE FOLDER WITH THE APP INSTALLER, since shortcuts will break with so.




Have a nice day. Your installer should work by now!

[Q&A](https://github.com/userdev265scratchandpython/winstaller/raw/refs/heads/english/README-2.md)
