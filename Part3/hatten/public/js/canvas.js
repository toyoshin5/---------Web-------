//コンストラクタの引数：手書きキャンバスのId名,手書きキャンバスのクリアボタンのId名
//使用例  drawcan1=new TMamHandwritten("canvasID1","clearButtonId1");
//        drawcan2=new TMamHandwritten("canvasID2","clearButtonId2");

function TMamHandwritten(drawCanvasId) {
  "use strict";
  this.drawCanvasId = drawCanvasId; //"canvas"+id
  this.isMouseDown = false;
  //マウス、タップの座標
  this.position = [];
  this.position.x = 0;
  this.position.y = 0;
  this.position.px = 0;
  this.position.py = 0;
  //横比率,縦比率
  this.rate = [];
  this.rate.x = 0;
  this.rate.y = 0;
  this.can = null;
  this.ctx = null;
  this.clearButton = null;
  this.eraserButton = null;

  window.addEventListener(
    "DOMContentLoaded",
    function () {
      this.can = document.getElementById(this.drawCanvasId);
      //イベントの設定
      this.can.addEventListener("touchstart", this.onDown.bind(this), {
        passive: false,
      });
      this.can.addEventListener("touchmove", this.onMove.bind(this), {
        passive: false,
      });
      this.can.addEventListener("touchend", this.onUp.bind(this));
      this.can.addEventListener("mousedown", this.onMouseDown.bind(this));
      this.can.addEventListener("mousemove", this.onMouseMove.bind(this));
      this.can.addEventListener("mouseup", this.onMouseUp.bind(this));
      window.addEventListener("mousemove", this.stopShake.bind(this));
      this.ctx = this.can.getContext("2d");
      this.ctx.strokeStyle = "#000000"; //線の色
      this.ctx.fillStyle = "rgb(255,255,255)";
      this.ctx.fillRect(
        0,
        0,
        this.can.getBoundingClientRect().width * this.rate.x,
        this.can.getBoundingClientRect().height * this.rate.y
      );
      this.ctx.lineWidth = 5; //線の太さ
      console.log(this.ctx);
      //初期化
      // Image オブジェクトを生成
      var img = new Image();

      function drawToCanvas(ct, img) {
        return function () {
          console.log(ct);
          ct.drawImage(img, 10, 10);
        };
      }
      function whiteToCanvas(self) {
        return function () {
          self.ctx.fillStyle = "rgb(255,255,255)";
          self.ctx.fillRect(
            0,
            0,
            self.can.getBoundingClientRect().width * self.rate.x,
            self.can.getBoundingClientRect().height * self.rate.y
          );
        };
      }
      img.src = "../img/" + this.drawCanvasId.split("canvas").join("") + ".png";
      console.log(img.src);
      img.onload = drawToCanvas(this.ctx, img);
      img.onerror = whiteToCanvas(this);

      //クリアボタンの設定
      if (document.getElementById("clear")) {
        this.clearButton = document.getElementById("clear");
        this.clearButton.addEventListener(
          "click",
          function () {
            img.src =
              "../img/" + this.drawCanvasId.split("canvas").join("") + ".png";
            img.onload = drawToCanvas(this.ctx, img);
            img.onerror = whiteToCanvas(this);
          }.bind(this)
        );
      }
      //消しゴムボタンの設定
      if (document.getElementById("eraser")) {
        this.clearButton = document.getElementById("eraser");
        this.clearButton.addEventListener(
          "click",
          function () {
            this.ctx.strokeStyle = "#FFFFFF"; //線の色
            this.ctx.lineWidth = 20;
          }.bind(this)
        );
      }
      //鉛筆ボタンの設定
      if (document.getElementById("color")) {
        this.clearButton = document.getElementById("color");
        this.clearButton.addEventListener(
          "click",
          function () {
            this.ctx.strokeStyle = "#000000"; //線の色
            this.ctx.lineWidth = 5;
          }.bind(this)
        );
      }
      //スタイルシート
      let style = document.createElement("style");
      document.head.appendChild(style);
      style.sheet.insertRule(
        "canvas#canvas" +
          this.drawCanvasId +
          "{-ms-touch-action:none;touch-action:none;}",
        0
      );
      let s = window.getComputedStyle(this.can);
      //canvas.widthとcanvas.style.widthの比率を取得する
      this.rate.x = parseInt(this.can.width) / parseInt(s.width);
      //canvas.heightとcanvas.style.heightの比率を取得する
      this.rate.y = parseInt(this.can.height) / parseInt(s.height);
    }.bind(this)
  );
  //キャンバスの初期化

  //TouchStart時
  this.onDown = function (event) {
    this.isMouseDown = true;
    this.position.px =
      event.touches[0].pageX -
      event.target.getBoundingClientRect().left -
      this.getScrollPosition().x;
    this.position.py =
      event.touches[0].pageY -
      event.target.getBoundingClientRect().top -
      this.getScrollPosition().y;
    this.position.x = this.position.px;
    this.position.y = this.position.py;
    this.drawLine();
    event.preventDefault();
    event.stopPropagation();
  };
  //TouchMove時
  this.onMove = function (event) {
    if (this.isMouseDown) {
      this.position.x =
        event.touches[0].pageX -
        event.target.getBoundingClientRect().left -
        this.getScrollPosition().x;
      this.position.y =
        event.touches[0].pageY -
        event.target.getBoundingClientRect().top -
        this.getScrollPosition().y;
      this.drawLine();
      this.position.px = this.position.x;
      this.position.py = this.position.y;
      event.stopPropagation();
    }
  };
  //TouchEnd時
  this.onUp = function (event) {
    this.isMouseDown = false;
    event.stopPropagation();
  };
  //MouseDown時
  this.onMouseDown = function (event) {
    this.position.px =
      event.clientX - event.target.getBoundingClientRect().left;
    this.position.py = event.clientY - event.target.getBoundingClientRect().top;
    this.position.x = this.position.px;
    this.position.y = this.position.py;
    this.drawLine();
    this.isMouseDown = true;
    event.stopPropagation();
  };
  //MouseMove時
  this.onMouseMove = function (event) {
    if (this.isMouseDown) {
      this.position.x =
        event.clientX - event.target.getBoundingClientRect().left;
      this.position.y =
        event.clientY - event.target.getBoundingClientRect().top;
      this.drawLine();
      this.position.px = this.position.x;
      this.position.py = this.position.y;
      event.stopPropagation();
    }
  };
  //MouseUp時
  this.onMouseUp = function (event) {
    this.isMouseDown = false;
    event.stopPropagation();
  };
  this.stopShake = function (event) {
    this.isMouseDown = false;
    event.stopPropagation();
  };
  this.drawLine = function () {
    this.ctx.lineJoin = "round";
    this.ctx.lineCap = "round";
    this.ctx.beginPath();
    this.ctx.moveTo(
      this.position.px * this.rate.x,
      this.position.py * this.rate.y
    );
    this.ctx.lineTo(
      this.position.x * this.rate.x,
      this.position.y * this.rate.y
    );
    this.ctx.stroke();
  };
  //スクロール位置を取得する
  this.getScrollPosition = function () {
    return {
      x: document.documentElement.scrollLeft || document.body.scrollLeft,
      y: document.documentElement.scrollTop || document.body.scrollTop,
    };
  };
  //手書き画像をPNG形式でData URIスキーム(base64)を使って文字列に変換してPOSTする
  this.savePicture = function (postURL) {
    let imgPng = this.can.toDataURL("image/png");
    //imgPng=imgPng.replace(/^data:image\/png;base64,/,'');
    let fm = document.createElement("form");
    fm.setAttribute("method", "post"); //メソッド
    fm.setAttribute("action", postURL); //POST先
    let h = document.createElement("input");
    h.setAttribute("type", "hidden");
    h.setAttribute("value", imgPng);
    h.setAttribute("name", "imgpng");
    let h2 = document.createElement("input");
    h2.setAttribute("type", "hidden");
    h2.setAttribute("value", this.drawCanvasId.split("canvas").join("")); //canvasidからcanvasを取り除いたものを送信
    h2.setAttribute("name", "projectID");
    fm.appendChild(h);
    fm.appendChild(h2);
    document.body.appendChild(fm);
    fm.submit();
  };
}
