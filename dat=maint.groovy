import groovy.json.JsonSlurper
import groovy.time.TimeCategory

def js 		= new JsonSlurper()
Date cutOff	= new Date() - 180
println "*** DBB WebApp Collection Age Report for items `Where lastUpdated > 180 Days`  ***"  

command 	= "curl --insecure --user ADMIN:ADMIN https://dbbdev.rtp.raleigh.ibm.com:9443/dbb/rest/collection/minimal"
apiOut 		= command.execute().text 
def collections	= js.parseText(command.execute().text)
collections.each { collection ->
	Date pDate= Date.parse("yyyy-MM-dd", collection.lastUpdated)
	if (pDate < cutOff) println "** Delete: " + collection.name.padRight(55,".") + " lastUpdated=" +collection.lastUpdated.take(10)     
}
