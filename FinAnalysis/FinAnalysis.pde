//JT 2015
String company = "softbank2015.csv";

GIFAnimeWriter gif;

Table table;

private Plot[] earning_plots;
private Plot[] operatingProfit_plots;
private Plot[] netProfit_plots;

float total_asset;
float net_profit;
float operatingProfit;
float earning;
float liquid_assets;
float liquid_dept;
float net_asset;
float debt_with_interest;

float leverage_ratio;

void setup() {

  table = loadTable(company);
    total_asset = table.getInt(1,2);
    earning = table.getInt(2,2);
    operatingProfit = table.getInt(3,2);
    net_profit = table.getInt(4,2);
    liquid_assets = table.getInt(5,2);
    liquid_dept = table.getInt(6,2);
    net_asset = table.getInt(7,2);
    debt_with_interest = table.getInt(8,2);

  //size of circle : Earning, operating profit, net profit(bottom line)
  float magnifying_ratio = 15;
  float earning_radius = magnifying_ratio*pow(earning, (1.0/3.0));
  float operatingProfit_radius = magnifying_ratio*pow(operatingProfit, (1.0/3.0));
  float netProfit_radius = magnifying_ratio*pow(net_profit, (1.0/3.0));

  //standardize ROA by deviding by sqrt(net_profit) which is in proportion to surface area of the core sphere
  int roa = int((net_profit*800000/total_asset)/sqrt(net_profit)); //about 1000-3000

  //if ratio > 1.2, it is safe (blue) / if ratio < 0.8 it is dangerous (red).
  //bigger the liquid_ratio, the safer it gets
  float liquid_ratio = liquid_assets/liquid_dept;
  int blue = 0;
  int red = 0;

  //leverage ratio
  leverage_ratio = debt_with_interest / net_asset;

  earning_plots = new Plot[roa];
  operatingProfit_plots = new Plot[roa];
  netProfit_plots = new Plot[roa];
  
  gif = new GIFAnimeWriter("test.gif",GIFAnimeWriter.LOOP);
  size(800, 800, P3D);
  frameRate(20);

  for (int i = 0; i < roa; i++) {
    earning_plots[i] = new Plot(earning_radius);
    operatingProfit_plots[i] = new Plot(operatingProfit_radius);
    netProfit_plots[i] = new Plot(netProfit_radius);
  }

  // plot color and plot size
  if(liquid_ratio > 1.2){
    red = 30;
    blue = int(1000*(liquid_ratio-1.2));
  }
  if(liquid_ratio < 1.2){
    blue = 30;
    red = int(1000*(1.2-liquid_ratio));
  }
  stroke(100+red, 150, 100+blue, 255);
  strokeWeight(2);
}

void draw() {
  background(0);
  // move the center point
  translate(width/2, height/2, 0);

  //rotationSpeed = Leverage Ratio (about 0.002)
  float rotationSpeed = leverage_ratio/80;

  rotateY(frameCount*rotationSpeed);
  rotateZ(frameCount*rotationSpeed);
  for (Plot earning_p : earning_plots) {
    point(earning_p.x, earning_p.y, earning_p.z);
  }
  
  rotateY(frameCount*-rotationSpeed);
  rotateZ(frameCount*-rotationSpeed);
  for (Plot operatingProfit_p : operatingProfit_plots) {
    point(operatingProfit_p.x, operatingProfit_p.y, operatingProfit_p.z);
  }

  rotateY(frameCount*rotationSpeed);
  rotateZ(frameCount*rotationSpeed);
  for (Plot netProfit_p : netProfit_plots) {
    point(netProfit_p.x, netProfit_p.y, netProfit_p.z);
  }
  
  gif.stock(g);
  if (frameCount >= 100) exit();  
}


private class Plot {
  final float x, y, z;
  Plot(float radius) {
    // randomly calculate position on sphere
    float unitZ = random(-1, 1);
    float radianT = radians(random(360));
    x = radius * sqrt(1 - unitZ * unitZ) * cos(radianT);
    y = radius * sqrt(1 - unitZ * unitZ) * sin(radianT);
    z = radius * unitZ;
  }
}

void exit() {
  gif.write();
  super.exit();
}