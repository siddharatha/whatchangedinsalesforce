beforedate=$(date +%s)
echo 'identify metadata available'
ant describeMetadata
echo '<project name="salesforceant" default="bulkRetrieve" basedir="." xmlns:sf="antlib:com.salesforce"><property file="build.properties"/><property environment="env"/><target name="bulkRetrieve"><mkdir dir="retrieve" />' > build_fullretrieve.xml
grep 'XMLName:' describe.log | sed 's/XMLName: /<sf:bulkRetrieve username="${sf.username}" password="${sf.password}" serverurl="${sf.serverurl}" metadataType="/g' | sed 's/$/" trace="true" retrieveTarget="retrieve"\/>/g' >> build_fullretrieve.xml
echo '</target></project>' >> build_fullretrieve.xml
echo 'started identifying changes'
ant bulkRetrieve -f build_fullretrieve.xml
echo 'downloaded changes , filtering out what has changed recently'
cd retrieve
git add -A
git commit -m "Incremental backup on `date +'%Y-%m-%d %H:%M:%S'`"
git show --name-only $( git cherry -v  HEAD~ HEAD| grep '^+' | awk '{ print($2) }' ) | egrep -v '^(commit |Author:|Date:|\s|$)' | sort -u > ../git_modifiedfiles
afterdate=$(date +%s)
echo $((afterdate-beforedate)) 'seconds'