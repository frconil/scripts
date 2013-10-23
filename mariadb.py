#!/usr/bin/python

# A quick script to automate what https://downloads.mariadb.org/mariadb/repositories/ does
# v0.1 centos 6 Proof of concept
# Author: Francois Conil

from sys import argv
from subprocess import Popen, PIPE
import platform

ver = "5.5 or 10.0"

if not len(argv) == 2:
    print "Usage: python mariadb.py <version> %s" % ver
    exit(1)
else:
    script, version = argv
    if version == "10" or version == "10.0":    
        version = "10.0"
    elif not version == "5.5":
        print "version expected to be %s" % ver
        exit(1)

    arch = platform.architecture()[0]
    dist = platform.linux_distribution()
    
    repo_dist = dist[0].lower()  
    if repo_dist in ("centos","redhat", "fedora"):
        repo_dist = repo_dist + dist[1][0]
        if arch == "64bit":
            repo_arch = "amd64"
        else:
            repo_arch = "x86"
   
        print  
        f = open("/etc/yum.repos.d/MariaDB.repo",'w') 
        
        f.write("[mariadb]")
        f.write("\n")
        f.write("name = MariaDB")
        f.write("\n")
        f.write("baseurl = http://yum.mariadb.org/%s/%s-%s" % (version, repo_dist, repo_arch))
        f.write("\n")
        f.write("gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB")
        f.write("\n")
        f.write("gpgcheck=1")
        f.write("\n")
        f.close()
        
        #import GPG key
        Popen(["rpm", "--import", "http://yum.mariadb.org/RPM-GPG-KEY-MariaDB"])
 
    elif repo_dist in ("ubuntu", "debian"):
        #not tested yet
        #using australian mirror
	if "jessie" in dist[1]:
		dist_version = "wheezy"
	elif "sid" in dist[1]:
		dist_version = "wheezy"
	else:
		dist_version = dist[1]
	
	 
        f = open("/etc/apt/sources.list.d/MariaDB.list","w") 
        f.write("\n")
        f.write("deb http://mirror.aarnet.edu.au/pub/MariaDB/repo/%s/%s %s main" % (version, repo_dist, dist_version))
        f.write("\n")
        f.write("deb-src http://mirror.aarnet.edu.au/pub/MariaDB/repo/%s/%s %s main" % (version, repo_dist, dist_version))
        f.write("\n")
        f.close()
        
        #import GPG key
	Popen(["/usr/bin/apt-key", "adv", "--recv-keys", "--keyserver", "keyserver.ubuntu.com", "0xcbcb082a1bb943db"])

 
    
    
