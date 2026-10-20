# Fetch libraries
if [ ! -d "libs" ]; then
  mkdir -v libs
fi
if [ ! -f "libs/rdf2xml.jar" ]; then
  curl -L -k https://github.com/architolk/rdf2xml/releases/download/v1.2.1/rdf2xml.jar -o libs/rdf2xml.jar
fi

# Create distribution directory
if [ ! -d "dist" ]; then
  mkdir -v dist
fi

# Create temporary folder
if [ ! -d "pipeline" ]; then
  mkdir -v pipeline
fi

# Clean, copy and merge
rm -f pipeline/*.*
cp examples/BWBR0015703.ttl pipeline
cp examples/echelon0.ttl pipeline
cp examples/echelon1.ttl pipeline
java -jar libs/rdf2rdf.jar -p pipeline -i "*.ttl" -o pipeline/total.ttl

# Convert BWB turtle to html
java -jar libs/rdf2xml.jar pipeline/total.ttl media/echelon1.html scripts/lomo2html.xsl
