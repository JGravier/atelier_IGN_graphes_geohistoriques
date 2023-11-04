### Objectives
Specific elements for IGN week datathon on geohistorical graphs constructions and analysis from city directories of Paris

### Silk: command elements
#### silk-workbench
```
cd /Espacedisque/silk/silk-workbench/bin
export JAVA_HOME='/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home'
./silk-workbench
```
Open in web browser: localhost:9000

#### silk-single-machine
```
cd /Espacedisque/silk/silk-single-machine/
export JAVA_HOME='/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home'
java -DconfigFile=monFichierDeConfig.xml -jar silk.jar
```

#### documentation
* [documentation](https://github.com/silk-framework/silk/tree/master/doc)
* [reprise de documentation](https://phobyjun.github.io/2019/07/07/Silk-book.html)

### GraphDB
#### Construction (for local)
``` sparql
construct { ?s ?p ?o} 
where {graph <http://rdf.geohistoricaldata.org/id/directories/monGraphPostgreSQL> 
    {?s ?p ?o}
}
```

#### Example of filtering: extacting IDs
``` sparql
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
select * from <http://rdf.geohistoricaldata.org/id/directories/nourrisseurs/> where {
    ?s ?p ?o
    filter(?p = <http://rdf.geohistoricaldata.org/def/directory#numEntry>)
}
order by ?o
```