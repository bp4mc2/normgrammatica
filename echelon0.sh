# Fetch libraries
if [ ! -d "libs" ]; then
  mkdir -v libs
fi
if [ ! -f "libs/rdf2rdf.jar" ]; then
  curl -L -k https://github.com/architolk/rdf2rdf/releases/download/v1.6.0/rdf2rdf.jar -o libs/rdf2rdf.jar
fi
if [ ! -f "libs/rdf2xml.jar" ]; then
  curl -L -k https://github.com/architolk/rdf2xml/releases/download/v1.2.1/rdf2xml.jar -o libs/rdf2xml.jar
fi
if [ ! -f "libs/rdf2graphml.xsl" ]; then
  curl -L -k https://raw.githubusercontent.com/architolk/rdf2xml/refs/heads/main/rdf2graphml.xsl -o libs/rdf2graphml.xsl
fi

# Create temporary folder
if [ ! -d "pipeline" ]; then
  mkdir -v pipeline
fi

# Convert eli.xml to eli.ttl (just a little bit nicer)
#java -jar libs/rdf2rdf.jar -i includes/eli.xml -o includes/eli.ttl

# Clean, copy and merge
rm -f pipeline/*.*
cp includes/eli.ttl pipeline
cp includes/oa.ttl pipeline
cp model/echelon0.ttl pipeline
java -jar libs/rdf2rdf.jar -p pipeline -i "*.ttl" -o pipeline/total.ttl
java -jar libs/rdf2rdf.jar -i pipeline/total.ttl -o pipeline/total-nl.ttl -c scripts/to-nl.yaml
java -jar libs/rdf2rdf.jar -i pipeline/total.ttl -o pipeline/total-en.ttl -c scripts/to-en.yaml

# Create diagrams
java -jar libs/rdf2xml.jar pipeline/total-en.ttl media/echelon0.graphml libs/rdf2graphml.xsl add media/echelon0-edited.graphml
java -jar libs/rdf2xml.jar pipeline/total-nl.ttl media/echelon0-nl.graphml libs/rdf2graphml.xsl add media/echelon0-edited.graphml
