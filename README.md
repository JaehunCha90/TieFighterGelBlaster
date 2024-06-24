# TEAM3_TIE_FIGHTER_GEL_BLASTER

## **Getting source code**
* git clone this repository

---

## **Prerequisites**
### opencv
* Copy opencv/ to this repository.
* It must exist in the same level of directory as LgCannonDemoCodeDist/.
* opencv/ can be obtained by decompressing the LgCannonDemoCodeDistv3.4.zip file that can be downloaded from canvas.
### setup.bat
* Go to the prerequisite/ folder and run the setup.bat script.
* It will install certificates, drivers, dlls on your PC.

---

## **Getting started**
### How to build and run a remote UI interface application (client)
* Use Official version of Microsoft Visual Studio 2022 Community IDE to open & build LgClientDisplay project.
* Go to the Build Output folder and run LgClientDisplayExecutable.

### How to build and run Cannon service (server)
* It's already located in the sub-directory of home in the lg account, and it automatically starts when the system starts up.
* How to run Cannon service automatically/manually
   ```
	1. enable Cannon auto restart (default)
	$ su
	(type password)
	$ systemctl enable lgcannon
	$ reboot -f
	(cannon service will be started automatically after boot)

	2. disable Cannon auto restart
	$ su
	(type password)
	$ systemctl disable lgcannon
	$ reboot -f
	(after reboot Cannon service should be started manually before connect)
    ```

### For Two factor authentication of User (Normal User)
* User ID: teamx
* User Password: teamx123!@#
* Certificate needed

### For Two factor authentication of Administrator
	1. Install Google Authentication application on your mobile.
	2. Execute Google Authentication application, and select '+' button(Bottom right of the screen).
	3. Select 'QR code scan' menu.
	4. Scanning QR code which Team3 shared with README.txt
	5. New account will be added in your Google application by QR code.
	6. Turn on wifi tethering in your cellphone, and then connect your cellphone to Router.
      (It is for connecting between google server and the target.)

### QR_CODE
![alt](https://github.com/JaehunCha90/TieFighterGelBlaster/blob/main/QR_CODE.png?raw=true)

