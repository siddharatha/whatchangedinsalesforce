beforedate=$(date +%s)
echo 'identify metadata available'
ant describeMetadata > output.log
echo '<project name="salesforceant" default="listMetadata" basedir="." xmlns:sf="antlib:com.salesforce"><property file="build.properties"/><property environment="env"/><target name="listMetadata"><mkdir dir="listMetadata" />' > build_temp.xml
grep 'XMLName:' describe.log | sed 's/XMLName: /<sf:listMetadata username="${sf.username}" password="${sf.password}" serverurl="${sf.serverurl}" metadataType="/g' | sed 's/$/" trace="true" resultFilePath="listMetadata\/lists.log"\/>/g' >> build_temp.xml
echo '</target></project>' >> build_temp.xml
echo 'started identifying changes'
ant listMetadata -f build_temp.xml> output.log
echo 'downloaded changes , filtering out what has changed recently'
rm -Rf listMetadata
rm build_temp.xml describe.log
echo '<root>' > modified.xml
grep -B 9 -A 3 'lastModifiedDate>'$(date -v-1d +"%F")'\|lastModifiedDate>'$(date +"%F")  output.log | sed 's/\[sf:listMetadata\]//g' | sed 's/--//g' >> modified.xml
echo '</root>' >> modified.xml
echo 'the package xml for the extraction is'
echo '<?xml version="1.0" encoding="UTF-8"?><Package xmlns="http://soap.sforce.com/2006/04/metadata">' > package.xml
grep 'type\|fullName' modified.xml | sed 's/<fullName>/<types><members>/g' | sed 's/<\/fullName>/<\/members>/g' | sed 's/<type>/<name>/g'| sed 's/<\/type>/<\/name><\/types>/g' >> package.xml
echo '</Package>' >> package.xml
echo 'prepared package xml'
rm modified.xml
cat package.xml
ant retrieve
cd retrieve
git add -A
git commit -m "Incremental backup on `date +'%Y-%m-%d %H:%M:%S'`"
git show --name-only $( git cherry -v  HEAD~ HEAD| grep '^+' | awk '{ print($2) }' ) | egrep -v '^(commit |Author:|Date:|\s|$)' | sort -u > ../git_modifiedfiles
afterdate=$(date +%s)
echo $((afterdate-beforedate)) 'seconds'