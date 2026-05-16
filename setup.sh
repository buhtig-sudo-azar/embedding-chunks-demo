#!/usr/bin/env bash
set -e

mkdir -p public js css

# index.html
cat > index.html << 'HTML'
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8" />
  <title>Embedding Chunks Demo</title>
  <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
  <header class="page-header">
    <h1>Embedding Chunks Demo</h1>
    <p class="subtitle">
      Наглядно показываем, почему нельзя пихать 150 страниц документации в один эмбеддинг
      и как правильный чанкинг делает поиск точным и быстрым.
    </p>
    <a class="btn-primary" href="public/visualization.html">Перейти к визуализации</a>
  </header>

  <main class="content">
    <section>
      <h2>Как ИИ видит текст</h2>
      <p>
        Люди читают текст глазами. Модели так не умеют: им нужно превратить текст в набор чисел — представление или эмбеддинг.
        Можно думать так: у каждого кусочка текста есть свои координаты в воображаемом пространстве.
        Похожие кусочки оказываются рядом, разные — далеко.
      </p>
    </section>

    <section>
      <h2>Что происходит, если скормить 150 страниц одним куском</h2>
      <p>
        Если взять 150 страниц документации Kubernetes — про pods, volumes, RBAC, readiness probe, network policies — и
        превратить всё это в один эмбеддинг, получится усреднённая каша. Этот вектор уже не представляет readiness probe,
        или RBAC, или сеть — он представляет всё сразу и ничего конкретно.
      </p>
      <p>
        Запрос «Как настроить readiness probe?» превращается в аккуратный вектор про readiness, а гигантский эмбеддинг —
        в усреднённый вектор про «всё про Kubernetes». Совпадение получается слабым, даже если ответ внутри текста есть.
      </p>
      <p>
        Это как смешать в блендере суп, пиццу, десерт и кофе и попросить описать вкус кофе — он там есть, но его не слышно.
      </p>
    </section>

    <section>
      <h2>Правильный подход: один чанк = одна мысль</h2>
      <p>
        Вместо одного огромного куска мы разбиваем документацию на маленькие осмысленные части: отдельная секция про
        readiness probe, отдельная — про volumes, отдельная — про безопасность и так далее. Каждый такой чанк получает
        свой эмбеддинг, который указывает на одну конкретную тему.
      </p>
      <p>
        Тогда запрос «Как настроить readiness probe?» оказывается близок именно к чанку про readiness, а не к каше из 150 страниц.
        Модель может выбрать несколько самых подходящих чанков и отдать их в контекст — без лишнего шума.
      </p>
    </section>

    <section>
      <h2>Почему это ещё и быстрее</h2>
      <p>
        Когда мы работаем с маленькими чанками, модель не тянет в контекст десятки тысяч лишних символов. Это значит:
      </p>
      <ul>
        <li>меньше мусора в контексте — меньше шансов на галлюцинации;</li>
        <li>быстрее ответы — меньше текста нужно обработать;</li>
        <li>лучше масштабируемость — можно обслуживать большие объёмы документации, не упираясь в размер окна.</li>
      </ul>
    </section>
  </main>
</body>
</html>
HTML

# public/visualization.html
cat > public/visualization.html << 'HTML'
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8" />
  <title>Визуализация чанков и эмбеддингов</title>
  <link rel="stylesheet" href="../css/styles.css" />
</head>
<body>
  <header class="page-header">
    <h1>Визуализация чанков и эмбеддингов</h1>
    <p class="subtitle">
      Слева — один огромный чанк, справа — много маленьких. Посмотри, как меняется качество поиска.
    </p>
    <a class="btn-secondary" href="../index.html">← Назад на описание</a>
  </header>

  <main class="content">
    <section class="controls">
      <label for="query-select">Запрос:</label>
      <select id="query-select">
        <option value="readiness">Как настроить readiness probe?</option>
        <option value="rbac">Как настроить RBAC?</option>
        <option value="network">Как настроить network policy?</option>
      </select>
      <button id="run-search">Искать</button>
    </section>

    <section class="viz-wrapper">
      <div class="viz-column">
        <h2>Плохо: один огромный чанк</h2>
        <div id="bad-chunk" class="chunk-box">
          150 страниц документации<br/>в одном куске
        </div>
        <canvas id="bad-canvas" width="320" height="220"></canvas>
        <p class="viz-note">
          Эмбеддинг размытый: запросу трудно «зацепиться» за конкретную тему.
        </p>
      </div>

      <div class="viz-column">
        <h2>Хорошо: много маленьких чанков</h2>
        <div class="good-chunks">
          <div class="chunk-box" data-topic="pods">Pods</div>
          <div class="chunk-box" data-topic="volumes">Volumes</div>
          <div class="chunk-box" data-topic="readiness">Readiness probes</div>
          <div class="chunk-box" data-topic="rbac">RBAC</div>
          <div class="chunk-box" data-topic="network">Network policies</div>
        </div>
        <canvas id="good-canvas" width="320" height="220"></canvas>
        <p class="viz-note">
          Каждый чанк имеет свой эмбеддинг. Запрос попадает в нужный кластер.
        </p>
      </div>
    </section>
  </main>

  <script src="../js/main.js"></script>
</body>
</html>
HTML

# css/styles.css
cat > css/styles.css << 'CSS'
* {
  box-sizing: border-box;
}

body {
  margin: 0;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  background: #050814;
  color: #f5f7ff;
}

.page-header {
  padding: 24px 16px;
  text-align: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
}

.page-header h1 {
  margin: 0 0 8px;
  font-size: 28px;
}

.subtitle {
  margin: 0 0 16px;
  color: #9ca3af;
  max-width: 720px;
  margin-left: auto;
  margin-right: auto;
}

.btn-primary,
.btn-secondary {
  display: inline-block;
  padding: 8px 16px;
  border-radius: 6px;
  text-decoration: none;
  font-size: 14px;
}

.btn-primary {
  background: #3b82f6;
  color: white;
}

.btn-secondary {
  border: 1px solid #4b5563;
  color: #e5e7eb;
}

.content {
  max-width: 960px;
  margin: 24px auto 40px;
  padding: 0 16px;
}

.content h2 {
  margin-top: 24px;
  margin-bottom: 8px;
}

.content p {
  line-height: 1.6;
  margin-bottom: 12px;
}

.content ul {
  padding-left: 20px;
}

.controls {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  align-items: center;
  margin-bottom: 24px;
}

.controls select,
.controls button {
  padding: 6px 10px;
  border-radius: 4px;
  border: 1px solid #4b5563;
  background: #111827;
  color: #e5e7eb;
}

.controls button {
  cursor: pointer;
  background: #3b82f6;
  border-color: transparent;
}

.viz-wrapper {
  display: flex;
  flex-wrap: wrap;
  gap: 24px;
}

.viz-column {
  flex: 1 1 280px;
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 8px;
  padding: 16px;
  background: radial-gradient(circle at top, #111827, #020617);
}

.chunk-box {
  border-radius: 6px;
  border: 1px solid #4b5563;
  padding: 8px;
  font-size: 13px;
  text-align: center;
  margin-bottom: 8px;
}

.chunk-box[data-topic="readiness"],
.chunk-box[data-topic="rbac"],
.chunk-box[data-topic="network"] {
  cursor: pointer;
}

.chunk-box.highlighted {
  border-color: #facc15;
  box-shadow: 0 0 0 1px rgba(250, 204, 21, 0.5);
}

.good-chunks {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 8px;
}

.viz-note {
  margin-top: 8px;
  font-size: 12px;
  color: #9ca3af;
}
CSS

# js/main.js
cat > js/main.js << 'JS'
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
JS

echo "Файлы созданы. Открой index.html и public/visualization.html в предпросмотре."
