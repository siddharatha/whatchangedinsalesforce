Complete backup + Change tracking scripts
=========================================

Why ?
------------
I loved the way StratoSource was written. I wanted to use the concept of StratoSource , but my users are more used to the salesforce UI , so why not use the salesforce database to store metadata information that changed of all sandboxes.
I can generate reports like , 
	what did person x do this week.
	I want to track everything I did in the last 1 month.

Since we are linking with a git repository, (which can be on the cloud like github/teamforge , or we have to maintain it in local repositories)

It might not be a good idea, if your organization is not having a lot of space for records.


How it works (now)
----------------------
1.works on Mac kernel , should work on unix systems too. had some problems with windows cygwin .
2.Download and install apache ant, Force.com migration toolkit and save the ant-salesforce.jar in the ant lib folder.
3.update the build properties file with username , password and serverurl.
4.Run the firstfullbackup.sh script (sh firstfullbackup.sh)
5.Its gonna take a while , will download all the metadata in your org , creates a folder, adds all your files, initializes the repository. its gonna take approximately 2.5 hrs depending on the size of your org.
6.You can skip the step 5 if you want an incremental tracking.
7.Run the dailychanges.sh to know what changed today, it will push the changes to the same folder as mentioned in step 5 , but will have only the files that are changed today. , you can run this for every 30 mins.


Road Map
--------
1.Create salesforce objects to store release and environment information.
2.Configure and prepare jenkins to run the above 2 scripts with parameters
3.Use the jenkins remote access API and call the jobs and monitor then from visualforce pages. (https://wiki.jenkins-ci.org/display/JENKINS/Remote+access+API)
4.Once the items are downloaded , update the tables in salesforce prod with the lastmodified information. (curl is preferable)

