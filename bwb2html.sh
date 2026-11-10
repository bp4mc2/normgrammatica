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
if [ ! -d "downloads" ]; then
  mkdir -v downloads
fi

# Fetch BWB
rm -f downloads/*.xml
rm -f downloads/*.rdf
curl https://repository.officiele-overheidspublicaties.nl/bwb/BWBR0004581/2026-09-01_0/xml/BWBR0004581_2026-09-01_0.xml -o downloads/BWBR0004581.xml
curl https://repository.officiele-overheidspublicaties.nl/bwb/BWBR0004825/2026-07-01_0/xml/BWBR0004825_2026-07-01_0.xml -o downloads/BWBR0004825.xml
curl https://repository.officiele-overheidspublicaties.nl/bwb/BWBR0006622/2026-09-01_0/xml/BWBR0006622_2026-09-01_0.xml -o downloads/BWBR0006622.xml
#curl https://repository.officiele-overheidspublicaties.nl/bwb/BWBR0011823/2026-10-16_0/xml/BWBR0011823_2026-10-16_0.xml -o downloads/BWBR0011823.xml
curl https://repository.officiele-overheidspublicaties.nl/bwb/BWBR0011825/2026-09-25_0/xml/BWBR0011825_2026-09-25_0.xml -o downloads/BWBR0011825.xml
curl https://repository.officiele-overheidspublicaties.nl/bwb/BWBR0015703/2026-07-01_0/xml/BWBR0015703_2026-07-01_0.xml -o downloads/BWBR0015703.xml

# For any downloaded file
shopt -s nullglob
for xml in downloads/*.xml; do
    base=$(basename "$xml" .xml)

    # Convert BWB XML to turtle
    java -jar libs/rdf2xml.jar -xml "$xml" "downloads/${base}.rdf" scripts/bwb2rdf.xsl
    java -jar libs/rdf2rdf.jar -i "downloads/${base}.rdf" -i2 examples/afkortingen.ttl -o "examples/${base}.ttl" -c scripts/cleanup.yaml

    # Convert BWB turtle to html
    java -jar libs/rdf2xml.jar "examples/${base}.ttl" "media/${base}.html" scripts/bwb2html.xsl
done
