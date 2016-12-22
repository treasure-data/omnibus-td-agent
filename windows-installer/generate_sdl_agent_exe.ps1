<#
 Script to pull down all needed dependencies and generate an unsigned 
 Stackdriver Logging Agent installer.

 This should be run on a clean GCE windows instance.

 The installer assumes that all NSIS files (.nsi, .nsh, and needed image files)
 are in the same folder as the installer script.  The script will output the
 complete Stackdriver Logging Agent Installer named StackdriverLoggingAgent_unsigned.exe.
#>

##############################
#  VARIABLES - DIRECTORIES
##############################

# Just install into 'C:' for simplicity.
$BASE_INSTALLER_DIR = "C:"

# The path of where ruby and all gems will be.  This is the portion that will be
# packaged and zipped up.
$SD_LOGGING_AGENT_DIR = $BASE_INSTALLER_DIR + "\StackdriverLoggingAgent"

# The ruby dev kit location.  This will add to the ruby install.
$RUBY_DEV_DIR = $BASE_INSTALLER_DIR + "\rubydevkit"

# The NSIS location.  Used to comiple the Stackdriver Logging Agent installer. 
$NSIS_DIR = $BASE_INSTALLER_DIR + "\NSIS"

# The location of the NSIS plugin to unzip files.
$NSIS_UNZU_DIR = $BASE_INSTALLER_DIR + "\NSISunzU"

# The location for unicode plugins for NSIS.
$NSIS_UNICODE_PLUGIN_DIR = $NSIS_DIR + "\Plugins\x86-unicode"


##############################
#  VARIABLES - INSTALLERS
##############################

# Locations of the needed installers and dependencies.
$RUBY_INSTALLER = $SD_LOGGING_AGENT_DIR + "\rubyinstaller.exe"
$RUBY_DEV_INSTALLER = $RUBY_DEV_DIR + "\rubydevinstaller.exe"
$NSIS_INSTALLER = $BASE_INSTALLER_DIR + "\nsisinstaller.exe"
$NSIS_UNZU_ZIP = $BASE_INSTALLER_DIR + "\NSISunzU.zip"


# Links for each installer.
$RUBY_INSTALLER_LINK = "http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.9.exe"
$RUBY_DEV_INSTALLER_LINK = "http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe"
$NSIS_INSTALLER_LINK = "http://downloads.sourceforge.net/project/nsis/NSIS%203/3.0/nsis-3.0-setup.exe"
$NSIS_UNZU_INSTALLER_LINK = "http://nsis.sourceforge.net/mediawiki/images/5/5a/NSISunzU.zip"


##############################
#  VARIABLES - FILE LOCATIONS
##############################

# The locaiton of the ruby executable, used to set up the ruby dev kit.
$RUBY_EXE = $SD_LOGGING_AGENT_DIR + "\bin\ruby.exe"

# The locaiton of the gem batch file, used to download gems.
$GEM_BAT = $SD_LOGGING_AGENT_DIR + "\bin\gem.bat"

# The location of the ruby dev kit.
$RUBY_DEV_KIT = $RUBY_DEV_DIR + "\dk.rb"

# The location of the executable to compile an NSIS installer.
$NSIS_MAKE = $NSIS_DIR + "\makensis.exe"

# The location of the dll of the plugin to unzip files in an NSIS installer.
$NSIS_UNZU_DLL = $NSIS_UNZU_DIR + "\NSISunzU\Plugin unicode\nsisunz.dll"

# Output location of the zip compliled into the installer. It will place where ever
# this script it run from.
$STACKDRIVER_ZIP = $PSScriptRoot + "\StackdriverLoggingAgent.zip"

# The location of the Stackdriver Logging Agent installer script. It will look
# where ever this script is run from.
$STACKDRIVER_NSI = $PSScriptRoot + "\setup.nsi"


##############################
#  STEP 1 - CREATE THE NEEDED DIRECTORIES.
##############################

mkdir $SD_LOGGING_AGENT_DIR 
mkdir $RUBY_DEV_DIR 
mkdir $NSIS_UNZU_DIR


##############################
#  STEP 2 - DOWNLOAD THE NEEDED DEPENDENCIES.
##############################

$webClient = new-object System.Net.WebClient
$webClient.DownloadFile($RUBY_INSTALLER_LINK, $RUBY_INSTALLER)
$webClient.DownloadFile($RUBY_DEV_INSTALLER_LINK, $RUBY_DEV_INSTALLER)
$webClient.DownloadFile($NSIS_INSTALLER_LINK, $NSIS_INSTALLER)
$webClient.DownloadFile($NSIS_UNZU_INSTALLER_LINK, $NSIS_UNZU_ZIP)


##############################
#  STEP 3 - INSTALL RUBY.
##############################

# Install ruby to the main install location and wait for it to finish.
& $RUBY_INSTALLER /verysilent /tasks="assocfiles,modpath" /dir=$SD_LOGGING_AGENT_DIR | Out-Null

# Remove the ruby uninstallers and the installer.
rm $SD_LOGGING_AGENT_DIR\unins*
rm $RUBY_INSTALLER


##############################
#  STEP 4 - INSTALL THE RUBY DEV KIT.
##############################

# Install ruby dev kit and wait for it to finish.
& $RUBY_DEV_INSTALLER -o $RUBY_DEV_DIR   -y | Out-Null

# Remove the ruby dev kit installer.
rm $RUBY_DEV_INSTALLER

# Initialize and install the ruby dev kit.
& $RUBY_EXE $RUBY_DEV_KIT init 
& $RUBY_EXE $RUBY_DEV_KIT install


# Update the environment paths.
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")


##############################
#  STEP 5 - INSTALL THE GEMS
##############################
#
# Install the needed gems for google fleuntd to works.
#
# These are all a known set of versions which work together. Be sure things work if you
# update any of them.
#
# We install all gems with '--no-ri --no-rdoc --no-document' so we don't pull in
# unneeded docs that bloat the file size (and also seem to cause issues with unzipping).
###############################

& $GEM_BAT update --system 2.4.8
& $GEM_BAT install fluentd:0.14.1 --no-ri --no-rdoc --no-document
& $GEM_BAT install windows-pr:1.2.5 win32-ipc:0.7.0 win32-event:0.6.3 win32-eventlog:0.6.6 win32-service:0.8.9 fluent-plugin-winevtlog:0.0.4 --no-ri --no-rdoc --no-document
& $GEM_BAT install fluent-plugin-google-cloud:0.5.3 --no-ri --no-rdoc --no-document


##############################
#  STEP 6 - ZIP THE FILES.
##############################

Add-Type -Assembly System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($SD_LOGGING_AGENT_DIR, $STACKDRIVER_ZIP)


##############################
#  STEP 7 - INSTALL NSIS.
##############################

# Install SISI and wait for it to finish.
& $NSIS_INSTALLER /S /D=$NSIS_DIR | Out-Null

# Unpack the nsis unzip plugin.
[System.IO.Compression.ZipFile]::ExtractToDirectory($NSIS_UNZU_ZIP, $NSIS_UNZU_DIR)

# Copy the needed DLL from the NSIS plugin into the NSIS pluging directory.
cp $NSIS_UNZU_DLL $NSIS_UNICODE_PLUGIN_DIR


##############################
#  STEP 8 - COMPILE THE NSIS SCRIPT.
##############################

& $NSIS_MAKE $STACKDRIVER_NSI
