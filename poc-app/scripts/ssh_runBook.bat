echo off
REM Desc: This is a sample cli ssh script for the poc-app
REM Purpose: Show who to script CI/CD
REM Nlopez  v1-q1'2022
REM CLI: C:\zBuildHost_RunBoook\ssh_RunBook.bat
REM Chglog: added quick Clone/Pull
cls
echo Windows SSH Runbook - CI/CD with DBB on Z (NLopez) -  %DATE% %TIME%

@REM Init +++++++++++++++++++++++++++
	set /a buildID=%random% %%10000 +1
	
	@REM HARDCODE FOR UNIT TESTING WITH PRIOR RUN
	@REM set buildID=60

REM Section for various env vars
	set appWorkSpace=poc-workspace
	set appRepoUrl=git@github.com:nlopez1-ibm/%appWorkSpace%.git
	set appName=poc-app
	set appRef=develop

	set commonWorkSpace=common
	set commonRepoUrl=git@github.com:nlopez1-ibm/%commonWorkSpace%.git
	set commonRef=main

	set scriptsHome=All-pipeline-scripts

	set zBuildHost=nlopez@zos.dev -p 2022
	set CI_workDir=/u/nlopez/tmp/ssh_RunBook/CI


	@rem deploy host is TVT6031 - CHECK VPN/FIREWALL BEFORE RUNNING
	set zDeployHost=nlopez@tvt6031.svl.ibm.com
	set CD_workDir=/u/nlopez/tmp/ssh_RunBook/CD


REM ++++++++++++++++++++++++++++++

REM Section for unit testing this script:
	rem echo Unit Test enabled
	rem goto deployPackage

echo on


@REM Section CI/CD Jobs
@REM ++++++++++++++++++++++++++++++
@REM CI Job Steps Pull or Clone:
	:cloneMe
	    ssh %zBuildHost% %scriptsHome%/CI/Clone2.sh    %CI_workDir%                 %appWorkSpace%    %appRepoUrl%    %appRef%
	    @IF %ERRORLEVEL% NEQ 0 GOTO trapme
echo TESTING gitIgnore in doc folder
@goto EXITOK
	    ssh %zBuildHost% %scriptsHome%/CI/Clone2.sh    %CI_workDir%/%appWorkSpace%  %commonWorkSpace% %commonRepoUrl% %commonRef%
	    @IF %ERRORLEVEL% NEQ 0 GOTO trapme



above passed now point below to new path
@goto EXITOK

	:buildMe
	    ssh %zBuildHost% %scriptsHome%/CI/Build.sh    %CI_workDir% %appRepo%  %appName% --impactBuild -buildID %buildID%

	    @REM ssh %zBuildHost% %scriptsHome%/CI/Build.sh    %CI_workDir% %appRepo%  %appName% poc-app/bms/datmapm.bms
	    @REM ssh %zBuildHost% %scriptsHome%/CI/Build.sh    %CI_workDir% %appRepo%  %appName%  -buildID %buildID% poc-app/cobol/datdemo.cbl
	    @IF %ERRORLEVEL% NEQ 0 GOTO trapme

	:packageMe
	    ssh %zBuildHost% %scriptsHome%/CI/Package_Create.sh  %CI_workDir% %appRepo%  %appName%

	:publishMe
	    ssh %zBuildHost% %scriptsHome%/CI/Package_Publish.sh  %CI_workDir%/%workSpace%/%appName%.tar
	    @IF %ERRORLEVEL% NEQ 0 GOTO trapme


REM ++++++++++++++++++++++++++




@REM CD Job Steps:
	:downLoadPackage
    		ssh %zDeployHost% %scriptsHome%/CD/Package_Download.sh   %CI_workDir%/%workSpace%/%appName%.tar %CD_workDir%
    		@IF %ERRORLEVEL% NEQ 0 GOTO trapme

	:unTarPackage
		ssh %zDeployHost% %scriptsHome%/CD/Package_untar.sh     %CD_workDir% mypackage.tar


	:deployPackage 		
		ssh %zDeployHost% %scriptsHome%/CD/Deploy.sh     %CD_workDir%

	@goto EXITOK



	:testDeployment
	    @REM ssh %zDeployHost% %scriptsHome%/?

REM ++++++++++++++++++++++++++




@goto EXITOK




:trapme
@echo Error trapped RC=%ERRORLEVEL%



:EXITOK
@pause

