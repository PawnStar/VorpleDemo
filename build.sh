#Builds the inform demo - depends on a Windows installation of Inform 7
#(Mostly copied straight from https://github.com/i7/kerkerkruip/blob/master/tools/build-i7-project)

INFORM_DIR="/c/Program Files (x86)/Inform 7"
PROJECT="TombDemo"

function checkExit(){
  if [ "$1" != 0 ] ; then
    echo "Build failed."
    exit 1
  fi
}

function prependOutput(){
  while read line; do
    if [ "$line" == "Build failed." ]; then
      exit 1
    fi
    echo "$1 $line";
  done
}

# Read our options
while getopts ":r" opt; do
  case $opt in
    r)
      RELEASE=true
      ;;
  esac
done

# Set build options
if [ "$RELEASE" = true ] ; then
    NI_OPTS="--release"
    INFORM6_OPTS="-E2w~S~DG"
    echo "<== Starting release build of $PROJECT"
else
    INFORM6_OPTS="-E2w~SDG"
    echo "<== Starting development build of $PROJECT"
fi
echo

# Prep commands
function inf7Build(){
  "$INFORM_DIR/Compilers/ni.exe" --format=ulx --noprogress --internal "$INFORM_DIR/Internal/" --project ./$PROJECT.inform $NI_OPTS
  return $?
}

function inf6Build(){
  "$INFORM_DIR/Compilers/inform6.exe" $INFORM6_OPTS ./$PROJECT.inform/Build/auto.inf -o ./$PROJECT.inform/Build/output.ulx
  return $?
}

function gblorbBuild(){
  "$INFORM_DIR/Compilers/cBlorb.exe" -windows ./$PROJECT.inform/Release.blurb ./$PROJECT.materials/Release/$PROJECT.gblorb
  return $?
}

# Prep our md5sum directory
mkdir -p .md5

function rebuildInform(){
  PREVBUILD=$(cat ./.md5/inform-resources)
  CURBUILD=$(find ./TombDemo.inform/Source -type f -exec md5sum {} \; | md5sum | cut -c 1-32)
  if [ "$PREVBUILD" != "$CURBUILD" ]; then
    echo "<== Rebuilding inform code."

    # Compile Inform 7 to Inform 6
    (inf7Build; checkExit $?) | prependOutput "[Inform7]"
    checkExit $?

    # Compile Inform 6
    (inf6Build; checkExit $?) | prependOutput "[Inform6]"
    checkExit $?

    # Bundle Gblorb
    (gblorbBuild; checkExit $?) | prependOutput "[Gblorb]"
    checkExit $?

    echo "$CURBUILD" > ./.md5/inform-resources
  else
    echo "<== Skipping inform code."
  fi
}

function rebuildJavascript(){
  PREVBUILD=$(cat ./.md5/external-resources)
  CURBUILD=$(find ./TombDemo.materials -type f -iname '*.js' -exec md5sum {} \; -o -iname '*.html' -exec md5sum {} \; | md5sum | cut -c 1-32)
  if [ "$PREVBUILD" != "$CURBUILD" ]; then
    echo "<== Rebuilding javascript resources."
    echo "$CURBUILD" > ./.md5/external-resources
  else
    echo "<== Skipping javascript resources."
  fi
}


rebuildInform

rebuildJavascript
