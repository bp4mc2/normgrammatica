function markupDefTables() {
  const tables = document.getElementsByTagName("table");
  for (const table of tables) {
    table.classList.add('simple');
    if (table.rows[0].cells[0].innerHTML=='{: .def}') {
      table.classList.add('def');
      table.deleteRow(0);
      for (const row of table.rows) {
        const thcell = document.createElement("th");
        var tdcell = row.cells[0];
        thcell.innerHTML = tdcell.innerHTML;
        row.replaceChild(thcell,tdcell);
      }
    } else {
      table.classList.add('data');
    }
  }
  return
}
function markupNotes() {
  const blockquotes = document.getElementsByTagName("blockquote");
  for (const blockquote of blockquotes) {
    if (blockquote.children.length>0) {
      if (blockquote.children[0].innerHTML.startsWith("[!NOTE]\n")) {
        blockquote.classList.add('note');
        blockquote.children[0].innerHTML = blockquote.children[0].innerHTML.substring(8);
        noteP = document.createElement("p");
        noteP.innerHTML="NOTE";
        blockquote.insertBefore(noteP,blockquote.children[0])
      }
    }
  }
}

async function legislationPostProcessor(conf, doc) {
  const blocks = doc.querySelectorAll("pre.legislation");

  for (const block of blocks) {
    const container = doc.createElement("div");
    container.className = "legislation";

    const lines = block.textContent
      .replace(/\r\n/g, "\n")
      .split("\n")
      .filter(line => line.trim());

    for (const line of lines) {
      let match;

      // lid: 1. ... or 1 ...
      if ((match = line.match(/^(\d+)\.?\s+(.*)$/))) {
        const p = doc.createElement("p");
        p.className = "lid";

        const nr = doc.createElement("span");
        nr.className = "nr";
        nr.textContent = `${match[1]}.`;

        p.append(nr, document.createTextNode(match[2]));
        container.append(p);
        continue;
      }

      // onderdeel: "  a. ..."
      if ((match = line.match(/^\s+([a-z])\.\s+(.*)$/i))) {
        const p = doc.createElement("p");
        p.className = "onderdeel";

        const nr = doc.createElement("span");
        nr.className = "nr";
        nr.textContent = `${match[1]}.`;

        p.append(nr, document.createTextNode(match[2]));
        container.append(p);
        continue;
      }

      // Everything else is considered none numbered item (typically: the preamble)
      const p = doc.createElement("p");
      p.className = "preamble";
      p.textContent = line.trim();
      container.append(p);

      // continuation line
      const last = container.lastElementChild;
      if (last) {
        last.append(
          document.createTextNode(` ${line.trim()}`)
        );
      }
    }

    block.replaceWith(container);
  }
}
