# Overview
- Basically, it's set to setup its services automatically, I guess through polling or something. But you need to have each repo cloned on your local machine...or something like that?

## You also need all the .xar files you want put in
The dockerfile for exist db will do this for you - you just need a 

## Repos you'll need:
- git@github.com:RyanQuey/Ethiopic-DillmannData.git

### If you want the home page...:
- git@github.com:RyanQuey/BetMas.git

    Not sure if this works or not, still experimenting. But I'm guessing you do, if you want the home page
Nov 2026 update: still not working. They haven't updated this in a year also. But Dillmann lexicon is working


### What about gez-en?

Well that's in the apps folder, so according to this (https://exist-db.org/exist/apps/doc/using-collections) it should be one of my apps... (i.e., .xar files). 
- It's found in BetMasWeb repo, so I'm trying that.


Apps seem to be created from .xar files. 

Maybe also...:
- git@github.com:RyanQuey/Ethiopic-BetMasApi.git

# Setup Data
- As stated near end of README.md, the Dillmann repo is just files, without data.

> The code is provided without data for documentation purposes and for reuse of parts for other dictionary projects. Where possible documentation has also been provided in the code.


To get data, try https://github.com/BetaMasaheft/DillmannData



# Access end user UI: 

(not sure yet...)
Should be up at http://localhost:80

- However, it keeps erroring out


# Access Exist Data
Takes a bit. Have to wait for it to all get initialized. 

```
docker logs -f exist
```

Then wait for something like this: 

```
10 Oct 2025 06:07:21,507 [main] INFO  (JettyStart.java [lifeCycleStarting]:635) - Jetty server starting...
10 Oct 2025 06:07:22,325 [main] INFO  (AbstractExistHttpServlet.java [getOrCreateBrokerPool]:101) - Database already started. Skipping configuration ...
10 Oct 2025 06:07:22,327 [main] INFO  (AbstractExistHttpServlet.java [doGeneralExistServletConfig]:189) - Using default user guest for all unauthorized requests.
10 Oct 2025 06:07:22,344 [main] INFO  (XmlLibraryChecker.java [check]:149) - Looking for a valid Parser...
Checking for Xerces, found version Xerces-J 2.12.2-xml-schema-1.1
OK!

10 Oct 2025 06:07:22,411 [main] INFO  (XmlLibraryChecker.java [check]:171) - Looking for a valid Transformer...
Checking for Saxon, found version 9.9.1.8
OK!

10 Oct 2025 06:07:22,411 [main] INFO  (XmlLibraryChecker.java [check]:183) - Looking for a valid Resolver...
Checking for Resolver, found version XmlResolver 1.2
OK!

10 Oct 2025 06:07:22,416 [main] INFO  (XmlLibraryChecker.java [check]:189) - Using parser org.apache.xerces.jaxp.SAXParserImpl$JAXPSAXParser
10 Oct 2025 06:07:22,417 [main] INFO  (XmlLibraryChecker.java [check]:190) - Using transformer org.apache.xalan.transformer.TransformerIdentityImpl
10 Oct 2025 06:07:23,042 [main] INFO  (JettyStart.java [lifeCycleStarted]:644) - Jetty server started.
10 Oct 2025 06:07:23,054 [main] INFO  (JettyStart.java [run]:288) - -----------------------------------------------------
10 Oct 2025 06:07:23,055 [main] INFO  (JettyStart.java [run]:289) - Server has started, listening on:
10 Oct 2025 06:07:23,056 [main] INFO  (JettyStart.java [run]:291) - http://172.18.0.2:8080/
10 Oct 2025 06:07:23,056 [main] INFO  (JettyStart.java [run]:291) - https://172.18.0.2:8443/
10 Oct 2025 06:07:23,056 [main] INFO  (JettyStart.java [run]:294) - Configured contexts:
10 Oct 2025 06:07:23,058 [main] INFO  (JettyStart.java [run]:300) - /exist (eXist XML Database)
10 Oct 2025 06:07:23,077 [main] INFO  (JettyStart.java [run]:316) - /exist/iprange (IPrange filter)
10 Oct 2025 06:07:23,081 [main] INFO  (JettyStart.java [run]:300) - / (eXist-db portal)
10 Oct 2025 06:07:23,085 [main] INFO  (JettyStart.java [run]:316) - /iprange (IPrange filter)
10 Oct 2025 06:07:23,086 [main] INFO  (JettyStart.java [run]:324) - -----------------------------------------------------
10 Oct 2025 06:07:24,709 [qtp1161267215-44] INFO  (TemporaryFileManager.java [<init>]:109) - Temporary folder is: /tmp/exist-db-temp-file-manager-3714857440836938109
```

## Then access at localhost:8080

http://localhost:8080

### App itself:
- http://localhost:8080/exist/apps/gez-en/


### Access WebDav DB in Exist DB
### WebDav DB in Exist DB Username and Pass:

user: admin
pass: 

(pass is blank, as is default for exist db)
https://exist-db.org/exist/apps/doc/security

#### You can then access in your finder
- https://support.apple.com/en-mo/guide/mac-help/mchlp1546/mac

- TLDR: cmd+K in MacOS finder, then put in password (see above), and it should just start going. 

## Run commands against Exist DB in Docker
https://exist-db.org/exist/apps/doc/docker



# Access dataset

http://localhost:3030

## Apache Jena Fuseki (Graph) Username and pass:
user: admin
pass: admin

# Guide to Infrastructure
- The main UI is controlled by a controller, dictated by `./local.nginx.conf`. This is what gets passed into the nginx server in Docker.
- This redirects stuff to the Server found at localhost:8080. E.g.,

    (code from local.nginx.conf)
    ```
        location /Dillmann/ {
            proxy_pass http://exist:8080/exist/apps/gez-en/ ;
            proxy_redirect    off;
                add_header Pragma "no-cache";
                add_header Cache-Control "no-cache";
            }
    ```



# Debugging
## Terminating due to java.lang.OutOfMemoryError: Java heap space

This is a common issue. 

Can probably override the var, see base Dockerfile:
- https://github.com/eXist-db/exist/blob/develop/exist-docker/src/main/resources-filtered/Dockerfile
    - So Probably MaxRAMPercentage

But better, I would think, is changing the RAM allotted to the container itself, so the max grows like that. 
- Putting less .xar files in works as well...when I removed guidelines*.xar, that solved it for me. 


## Apps in `./build` folder not showing up
- [ ] Check to make sure you rebuild the image AFTER the .xar file was put in there
- [ ] Double check the Dockerfile to make sure that you really are copying stuff in...
