#!/bin/bash

#+ Automate PKG build

WORKING_DIR=$(/usr/bin/dirname "${0}")

pushd ${WORKING_DIR}

for PKG_POSTFLIGHT in `/usr/bin/find -L ${WORKING_DIR} -name "*.sh" | /usr/bin/grep -v "config.sh" | /usr/bin/grep -v "REDUNDANT" | /usr/bin/grep -v "PAYLOAD" | /usr/bin/grep -v "SOURCE" | /usr/bin/grep -v "TEMPLATES"`
do
 /bin/echo "${0} Packaging ${PKG_POSTFLIGHT}"
 
 ROOT=$(/usr/bin/dirname "${PKG_POSTFLIGHT}")
 IDENTIFIER=$(/usr/bin/basename "${PKG_POSTFLIGHT}" | sed 's/.sh//g')
 DESCRIPTION=$(cat "${PKG_POSTFLIGHT}" | grep "Description:" | sed "s/#+ Description: //g")
 VERSION=$(cat "${PKG_POSTFLIGHT}" | grep "Version:" | sed 's/#+ Version: //g')
 
 /bin/echo "${0} Root: ${ROOT}"
 /bin/echo "${0} Identifier: ${IDENTIFIER}"
 /bin/echo "${0} Description: ${DESCRIPTION}"
 /bin/echo "${0} Version: ${VERSION}"
 
 /bin/mkdir -p ./RESOURCES
 /bin/mkdir -p ./ROOT/Library
 /bin/mkdir -p ./SCRIPTS
 
 /bin/echo "${0} making ./RESOURCES"
 /bin/echo "${0} making ./ROOT/Library"
 /bin/echo "${0} making ./SCRIPTS"
 
 /bin/cp -f "${PKG_POSTFLIGHT}" ./SCRIPTS/postflight
 
 /bin/echo "${0} Copying ${PKG_POSTFLIGHT} to ./SCRIPTS/postflight"
 
 "/Applications/PackageMaker.app/Contents/MacOS/PackageMaker" --id "com.chrisgerke.${IDENTIFIER}" --title "${IDENTIFIER}" --version "${VERSION}" --resources ./RESOURCES --scripts ./SCRIPTS --root ./ROOT --out ./${IDENTIFIER}.pkg --verbose
 
 /bin/echo "${0} Hopefully Building com.chrisgerke.${IDENTIFIER} to ./${IDENTIFIER}.pkg"
 
 /usr/bin/defaults write ./${IDENTIFIER}.pkg/Contents/Resources/en.lproj/Description IFPkgDescriptionDescription "${DESCRIPTION}"
 
 /bin/echo "${0} writing Description: ${DESCRIPTION} to ./${IDENTIFIER}.pkg/Contents/Resources/en.lproj/Description IFPkgDescriptionDescription"

 
 #+ Payload?
 if [ -r "${ROOT}/PAYLOAD" ]; then
  /bin/cp -R "${ROOT}/PAYLOAD" ./${IDENTIFIER}.pkg/Contents/Resources/
 fi
 
 #+ Readme
 if [ -r "${ROOT}/README.md" ]; then
  /bin/cp -f "${ROOT}/README.md" ./${IDENTIFIER}.pkg/Contents/Resources/
 fi
 
 /bin/rm -Rf ./RESOURCES
 /bin/rm -Rf ./ROOT
 /bin/rm -Rf ./SCRIPTS
 
 /bin/echo "${0} cleaning ./RESOURCES"
 /bin/echo "${0} cleaning ./ROOT"
 /bin/echo "${0} cleaning ./SCRIPTS"

done

popd

exit 0