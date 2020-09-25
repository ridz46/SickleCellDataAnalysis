macro "macroSickle" {
  run("Crop");
  run("8-bit");
  run("Subtract Background...", "rolling=50 light");
  setAutoThreshold("Default dark");
  setAutoThreshold("Default");
  setOption("BlackBackground", true);
  run("Make Binary");
  run("Convert to Mask");
  run("Fill Holes");
  run("Erode");
  run("Set Measurements...", "area perimeter bounding shape limit redirect=None decimal=3");
  run("Analyze Particles...", "size=500-7500 show=Outlines display exclude summarize");
  saveAs("Results", "PathToSave/Results.csv");
  saveAs("PNG", "PathToSave/Drawing.png");
  list = getList("window.titles");
       for (i=0; i<list.length; i++){
       winame = list[i];
       	selectWindow(winame);
       run("Close");
       }
  run("Close All");
}
