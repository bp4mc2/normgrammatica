# Fetch libraries
if [ ! -d "libs" ]; then
  mkdir -v libs
fi
if [ ! -f "libs/rdf2xml.jar" ]; then
  curl -L -k https://github.com/architolk/rdf2xml/releases/download/v1.2.1/rdf2xml.jar -o libs/rdf2xml.jar
fi
if [ ! -f "libs/rdf2xml.jar" ]; then
  curl -L -k https://github.com/architolk/rdf2xml/releases/download/v1.2.1/rdf2xml.jar -o libs/rdf2xml.jar
fi

# Create distribution directory
if [ ! -d "dist" ]; then
  mkdir -v dist
fi

# Fetch BWB
curl https://repository.officiele-overheidspublicaties.nl/bwb/BWBR0011823/2026-10-16_0/xml/BWBR0011823_2026-10-16_0.xml -o examples/BWBR0011823.xml

# Convert BWB XML to turtle
java -jar libs/rdf2xml.jar -xml examples/BWBR0011823.xml examples/BWBR0011823.rdf scripts/bwb2rdf.xsl
java -jar libs/rdf2rdf.jar -i examples/BWBR0011823.rdf -o examples/BWBR0011823.ttl
rm examples/BWBR0011823.rdf
rm examples/BWBR0011823.xml

# Convert BWB turtle to html
java -jar libs/rdf2xml.jar examples/BWBR0011823.ttl media/BWBR0011823.html scripts/bwb2html.xsl
