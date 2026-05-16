function drawBadEmbedding(ctx, queryTopic) {
  ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);

  const baseColor = "#4b5563";
  const highlightColor = "#f97316";

  for (let i = 0; i < 80; i++) {
    const x = Math.random() * ctx.canvas.width;
    const y = Math.random() * ctx.canvas.height;
    const r = 2 + Math.random() * 2;

    ctx.beginPath();
    ctx.arc(x, y, r, 0, Math.PI * 2);
    ctx.fillStyle = baseColor;
    ctx.fill();
  }

  ctx.beginPath();
  ctx.arc(ctx.canvas.width / 2, ctx.canvas.height / 2, 50, 0, Math.PI * 2);
  ctx.strokeStyle = queryTopic ? highlightColor : "#6b7280";
  ctx.lineWidth = 2;
  ctx.stroke();
}

function drawGoodEmbedding(ctx, queryTopic) {
  ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);

  const clusters = [
    { topic: "pods", x: 60, y: 60, color: "#3b82f6" },
    { topic: "volumes", x: 240, y: 70, color: "#10b981" },
    { topic: "readiness", x: 70, y: 160, color: "#f97316" },
    { topic: "rbac", x: 240, y: 160, color: "#a855f7" },
    { topic: "network", x: 150, y: 110, color: "#ec4899" }
  ];

  clusters.forEach((cluster) => {
    for (let i = 0; i < 25; i++) {
      const angle = Math.random() * Math.PI * 2;
      const radius = 12 + Math.random() * 8;
      const x = cluster.x + Math.cos(angle) * radius;
      const y = cluster.y + Math.sin(angle) * radius;
      const r = 2;

      ctx.beginPath();
      ctx.arc(x, y, r, 0, Math.PI * 2);
      ctx.fillStyle =
        queryTopic && cluster.topic === queryTopic
          ? cluster.color
          : "#4b5563";
      ctx.fill();
    }
  });

  const highlight = clusters.find((c) => c.topic === queryTopic);
  if (highlight) {
    ctx.beginPath();
    ctx.arc(highlight.x, highlight.y, 28, 0, Math.PI * 2);
    ctx.strokeStyle = highlight.color;
    ctx.lineWidth = 2;
    ctx.stroke();
  }
}

function setHighlightedChunk(queryTopic) {
  const boxes = document.querySelectorAll(".good-chunks .chunk-box");
  boxes.forEach((box) => {
    const topic = box.getAttribute("data-topic");
    if (
      (queryTopic === "readiness" && topic === "readiness") ||
      (queryTopic === "rbac" && topic === "rbac") ||
      (queryTopic === "network" && topic === "network")
    ) {
      box.classList.add("highlighted");
    } else {
      box.classList.remove("highlighted");
    }
  });
}

document.addEventListener("DOMContentLoaded", () => {
  const badCanvas = document.getElementById("bad-canvas");
  const goodCanvas = document.getElementById("good-canvas");
  const querySelect = document.getElementById("query-select");
  const runSearch = document.getElementById("run-search");

  if (!badCanvas || !goodCanvas || !querySelect || !runSearch) return;

  const badCtx = badCanvas.getContext("2d");
  const goodCtx = goodCanvas.getContext("2d");

  drawBadEmbedding(badCtx, null);
  drawGoodEmbedding(goodCtx, "readiness");
  setHighlightedChunk("readiness");

  runSearch.addEventListener("click", () => {
    const value = querySelect.value;
    drawBadEmbedding(badCtx, value);
    drawGoodEmbedding(goodCtx, value);
    setHighlightedChunk(value);
  });
});
