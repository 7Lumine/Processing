int circleX, circleY;     // 円の中心（確定位置）
float circleSize = 80;
boolean hasCircle = false;

boolean leftHolding = false;   // 左クリック押しっぱなし

int x1, y1;
int x2, y2;
boolean rightDragging = false; // 四角形用ドラッグフラグ

void setup() {
  size(400, 400);
  rectMode(CORNER);
}

void draw() {
  background(255);
  // タイム表示
  fill(0);
  textSize(32);
  text(frameCount/60, 180, 50);

  // 四角形の描画（右ドラッグ用）
  if (!rightDragging && x1 != x2 && y1 != y2) {
    int rx = min(x1, x2);
    int ry = min(y1, y2);
    int rw = abs(x2 - x1);
    int rh = abs(y2 - y1);
    fill(200, 220, 255);
    stroke(0);
    rect(rx, ry, rw, rh);
  }

  if (rightDragging) {
    int rx = min(x1, mouseX);
    int ry = min(y1, mouseY);
    int rw = abs(mouseX - x1);
    int rh = abs(mouseY - y1);
    noFill();
    stroke(255, 0, 0);
    rect(rx, ry, rw, rh);
  }

  // 円の描画（左クリックで操作）
  if (leftHolding) {
    // 左クリック中はカーソル追従のプレビュー
    noFill();
    stroke(0, 0, 255, 50);
    ellipse(mouseX, mouseY, circleSize, circleSize);
  } else if (hasCircle) {
    // 左クリックを離した後は、確定位置で描画
    noFill();
    stroke(0);
    ellipse(circleX, circleY, circleSize, circleSize);
  }
}

// 円・四角形の座標処理
void mousePressed() {
  if (mouseButton == LEFT) {
    // 円モード：左クリック押しっぱなしでプレビュー
    leftHolding = true;
  } else if (mouseButton == RIGHT) {
    // 四角形モード：右ドラッグで対角を指定
    x1 = mouseX;
    y1 = mouseY;
    rightDragging = true;
  }
}

void mouseReleased() {
  if (mouseButton == LEFT && leftHolding) {
    // 円を確定
    circleX = mouseX;
    circleY = mouseY;
    hasCircle = true;
    leftHolding = false;
  } else if (mouseButton == RIGHT) {
    // 四角形を確定
    x2 = mouseX;
    y2 = mouseY;
    rightDragging = false;
  }
}

void mouseWheel(processing.event.MouseEvent event) {
  if (leftHolding) {
    float e = event.getCount();
    circleSize -= e * 20;   //この係数で円の大きさを変える感度変更可能
    circleSize = max(10, circleSize);
  }
}


