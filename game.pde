// 円
int circleX, circleY;
float circleSize = 80;
boolean hasCircle = false;
boolean leftHolding = false;

// 四角形
int x1, y1;
int x2, y2;
boolean rightDragging = false;

// 点の定義
final int MAX_POINTS = 200;
float[] px  = new float[MAX_POINTS];
float[] py  = new float[MAX_POINTS];
boolean[] alive = new boolean[MAX_POINTS];
boolean[] isRed = new boolean[MAX_POINTS]; // true: 赤, false: 緑
int pointCount = 0;

// スコア
int score = 0;

// 追加用タイマー
int lastSpawnFrame = 0;
int spawnIntervalFrames = 60; // 60フレームごと（約1秒ごと）に追加

void setup() {
  size(600, 400);
  rectMode(CORNER);

  // 最初に少しだけ点を出しておく
  for (int i = 0; i < 10; i++) {
    spawnPoint();
  }
}

void draw() {
  background(255);

  // 一定間隔ごとに新しい点を追加
  if (frameCount - lastSpawnFrame >= spawnIntervalFrames) {
    spawnPoint();
    lastSpawnFrame = frameCount;
  }

  // 点の描画
  noStroke();
  for (int i = 0; i < pointCount; i++) {
    if (!alive[i]) continue;
    if (isRed[i]) {
      fill(255, 0, 0);
    } else {
      fill(0, 200, 0);
    }
    ellipse(px[i], py[i], 8, 8);
  }

  // 四角形描画
  int rx = 0, ry = 0, rw = 0, rh = 0;
  boolean rectActive = false;

  if (!rightDragging && x1 != x2 && y1 != y2) {
    rx = min(x1, x2);
    ry = min(y1, y2);
    rw = abs(x2 - x1);
    rh = abs(y2 - y1);
    noFill();
    stroke(0, 200, 0);
    rect(rx, ry, rw, rh);
    rectActive = true;
  }

  if (rightDragging) {
    rx = min(x1, mouseX);
    ry = min(y1, mouseY);
    rw = abs(mouseX - x1);
    rh = abs(mouseY - y1);
    noFill();
    stroke(0, 200, 0, 80);
    rect(rx, ry, rw, rh);
    rectActive = true;
  }

  // 円描画
  if (leftHolding) {
    noFill();
    stroke(255, 0, 0, 80);
    ellipse(mouseX, mouseY, circleSize, circleSize);
  } else if (hasCircle) {
    noFill();
    stroke(255, 0, 0);
    ellipse(circleX, circleY, circleSize, circleSize);
  }

  // スコア表示
  fill(0);
  textSize(20);
  text("Score: " + score, 20, 30);
}

// ランダムな点を1つ追加
void spawnPoint() {
  if (pointCount >= MAX_POINTS) return;
  px[pointCount] = random(width);
  py[pointCount] = random(height);
  alive[pointCount] = true;
  isRed[pointCount] = random(1) < 0.5; // 半々で赤/緑
  pointCount++;
}

// 左クリック：円
void mousePressed() {
  if (mouseButton == LEFT) {
    leftHolding = true;
  } else if (mouseButton == RIGHT) {
    x1 = mouseX;
    y1 = mouseY;
    rightDragging = true;
  }
}

void mouseReleased() {
  // 円を確定 → 円に入っている点だけ消してスコア処理（赤: +100, 緑: -200）
  if (mouseButton == LEFT && leftHolding) {
    circleX = mouseX;
    circleY = mouseY;
    hasCircle = true;
    leftHolding = false;

    float r = circleSize / 2.0;
    for (int i = 0; i < pointCount; i++) {
      if (!alive[i]) continue;
      float d = dist(circleX, circleY, px[i], py[i]);
      if (d <= r) {
        // 赤点を赤い円で → +100, 緑点を赤い円で → -200
        if (isRed[i]) {
          score += 100;
        } else {
          score -= 200;
        }
        alive[i] = false;
      }
    }

  // 四角形を確定 → 四角形に入っている点だけ消してスコア処理（緑: +100, 赤: -200）
  } else if (mouseButton == RIGHT && rightDragging) {
    x2 = mouseX;
    y2 = mouseY;
    rightDragging = false;

    int rx = min(x1, x2);
    int ry = min(y1, y2);
    int rw = abs(x2 - x1);
    int rh = abs(y2 - y1);

    for (int i = 0; i < pointCount; i++) {
      if (!alive[i]) continue;
      if (px[i] >= rx && px[i] <= rx + rw &&
          py[i] >= ry && py[i] <= ry + rh) {
        // 緑点を緑の四角形で → +100, 赤点を緑の四角形で → -200
        if (!isRed[i]) {
          score += 100;
        } else {
          score -= 200;
        }
        alive[i] = false;
      }
    }
  }
}

// ホイール：円サイズ（確定後は変えない）
void mouseWheel(processing.event.MouseEvent event) {
  if (leftHolding) {
    float e = event.getCount();
    circleSize -= e * 20;
    circleSize = max(10, circleSize);
  }
}
