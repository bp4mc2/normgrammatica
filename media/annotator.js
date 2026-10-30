document.addEventListener("DOMContentLoaded", () => {

  let currentType = "primarysubject";
  const annotations = [];

  const types = [
    ["primarysubject", "#ffff00"],
    ["normexpression", "#ff66ff"],
    ["secondarysubject", "#eeee33"],
    ["object", "#ff6666"],
    ["condition", "#33ff33"],
    ["legaleffect", "#00ffff"]
  ];

  document.querySelectorAll(".legislation").forEach(legislation => {

    const toolbar = document.createElement("div");
    toolbar.className = "annotation-toolbar";

    const turtlePane = document.createElement("pre");
    turtlePane.className = "annotation-turtle";

    types.forEach(([type, color]) => {

      const btn = document.createElement("button");

      btn.textContent = type;
      btn.style.backgroundColor = color;

      btn.addEventListener("click", () => {
        currentType = type;
      });

      toolbar.appendChild(btn);
    });

    const turtleButton = document.createElement("button");
    turtleButton.textContent = "Show Turtle";

    turtleButton.addEventListener("click", () => {

      turtlePane.style.display =
        turtlePane.style.display === "block"
          ? "none"
          : "block";

      turtlePane.textContent =
        generateTurtle(annotations);
    });

    toolbar.appendChild(turtleButton);

    legislation.after(toolbar);
    toolbar.after(turtlePane);

    legislation.addEventListener(
      "mouseup",
      event => annotateSelection(
        legislation,
        currentType,
        annotations,
        turtlePane
      )
    );
  });
});

function getTextOffsets(container, range) {

  const preRange = document.createRange();

  preRange.selectNodeContents(container);
  preRange.setEnd(
    range.startContainer,
    range.startOffset
  );

  const start = preRange.toString().length;

  const end =
    start + range.toString().length;

  return { start, end };
}

function annotateSelection(
  legislation,
  type,
  annotations,
  turtlePane
) {
  const selection = window.getSelection();

  if (
    selection.rangeCount === 0 ||
    selection.isCollapsed
  ) {
    return;
  }

  const range = selection.getRangeAt(0);

  if (
    !legislation.contains(
      range.commonAncestorContainer
    )
  ) {
    return;
  }

  const text = selection.toString();

  const span = document.createElement("span");

  const id = crypto.randomUUID();

  span.className = `${type}`;
  span.dataset.annotationId = id;

  const fragment = range.extractContents();

  span.appendChild(fragment);

  range.insertNode(span);

  const offsets =
    getTextOffsets(legislation, range);

  annotations.push({
    id,
    type,
    exact: text,
    start: offsets.start + 1,
    end: offsets.end
  });

  turtlePane.textContent =
    generateTurtle(annotations);

  selection.removeAllRanges();
}

function generateTurtle(annotations) {

  let ttl = `
@prefix oa: &lt;http://www.w3.org/ns/oa#> .
@prefix ex: &lt;https://example.org/> .

`;

  annotations.forEach(a => {

    ttl += `
ex:${a.id}
    a oa:Annotation ;
    oa:motivatedBy oa:tagging ;
    oa:hasBody "${a.type}" ;
    oa:hasTarget [
        a oa:SpecificResource ;
        oa:hasSelector [
            a oa:TextQuoteSelector ;
            oa:exact """${a.exact}"""
        ];
        oa:selector [oa:start ${a.start}; oa:end ${a.end}]
    ] .

`;
  });

  return ttl;
}
