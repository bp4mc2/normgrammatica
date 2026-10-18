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

# Convert BWB turtle to html
java -jar libs/rdf2xml.jar examples/BWBR0015703.ttl dist/BWBR0015703.html scripts/bwb2html.xsl
