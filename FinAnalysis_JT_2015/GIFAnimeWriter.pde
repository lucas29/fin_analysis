import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.lang.CloneNotSupportedException;
import java.lang.Throwable;
import java.util.Iterator;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageTypeSpecifier;
import javax.imageio.ImageWriter;
import javax.imageio.metadata.IIOInvalidTreeException;
import javax.imageio.metadata.IIOMetadata;
import javax.imageio.metadata.IIOMetadataNode;
import javax.imageio.stream.ImageOutputStream;

class GIFAnimeWriter {
  static final int LOOP = 0;
  static final int NO_LOOP = -1;

  int loopCount;
  float GIFframeRate;
  ArrayList<PImage> imgList;
  BufferedImage bfImg;
  File outFile;
  ImageWriter imgWriter;
  ImageOutputStream stream;

  GIFAnimeWriter(String filePath) {
    this(filePath, NO_LOOP);
  }
  
  GIFAnimeWriter(String filePath, int _loopCount) {
    this(filePath, _loopCount, frameRate);
  }

  GIFAnimeWriter(String filePath, int _loopCount, float _frameRate) {
    filePath = sketchPath(filePath);
    loopCount = (_loopCount > 65535)?0:_loopCount;
    GIFframeRate = _frameRate;
    imgList = new ArrayList<PImage>();

    Iterator it = ImageIO.getImageWritersByFormatName("gif");
    imgWriter = (it.hasNext())?(ImageWriter)it.next():null;
    outFile = new File(filePath);
    try {
      stream = ImageIO.createImageOutputStream(outFile);
      imgWriter.setOutput(stream);
      imgWriter.prepareWriteSequence(null);
    } catch (IOException ex) {
      ex.printStackTrace();
    }
  }
  
  void stock(PImage img) {
    try {
      imgList.add((PImage)img.clone());
    } catch (CloneNotSupportedException ex) {
      ex.printStackTrace();
    }
  }

  private void write(PImage img) {
    img.loadPixels();
    bfImg = new BufferedImage(img.width, img.height, BufferedImage.TYPE_INT_RGB);
    bfImg.setRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);

    IIOMetadata meta = createMetaData();
        
    try {
      imgWriter.writeToSequence(new IIOImage(bfImg, null, meta), null);
    } catch (IOException ex) {
      ex.printStackTrace();
    }
  }

  void write() {
    float percent;
    for (int cnt = 0; cnt < imgList.size(); cnt++) {
      this.write(imgList.get(cnt));
      percent = (cnt+1)*100f/imgList.size();
      print("\n\n\nwriting GIF...\n"+percentageString(percent,20));
    }
    try {
      imgWriter.endWriteSequence();
      stream.close();
    } catch (IOException ex) {
      ex.printStackTrace();
    }
    try {
      this.finalize();
    } catch (Throwable ex) {
      ex.printStackTrace();
    }
  }
  
  private IIOMetadata createMetaData() {
    IIOMetadata meta = imgWriter.getDefaultImageMetadata(
      ImageTypeSpecifier.createFromRenderedImage(bfImg), null);
    String format = meta.getNativeMetadataFormatName();
    IIOMetadataNode root = (IIOMetadataNode)meta.getAsTree(format);
    
    root.appendChild(frameRateMetaNode());
    if (loopCount >= 0) root.appendChild(loopMetaNode());
    
    try {
      meta.setFromTree(format, root);
    } catch (IIOInvalidTreeException ex) {
      ex.printStackTrace();
    }
    return meta;
  }
  
  private IIOMetadataNode frameRateMetaNode() {
    IIOMetadataNode node = new IIOMetadataNode("GraphicControlExtension");
    node.setAttribute("disposalMethod", "none");
    node.setAttribute("userInputFlag", "FALSE");
    node.setAttribute("transparentColorFlag", "FALSE");
    node.setAttribute("delayTime", Integer.toString(ceil(100f/GIFframeRate)));
    node.setAttribute("transparentColorIndex", "0");
    return node;
  }

  private IIOMetadataNode loopMetaNode() {
    byte[] data = {
      0x01, 
      (byte)((loopCount >> 0) & 0xFF), 
      (byte)((loopCount >> 8) & 0xFF)
    };
    IIOMetadataNode list = new IIOMetadataNode("ApplicationExtensions");
    IIOMetadataNode node = new IIOMetadataNode("ApplicationExtension");
    node.setAttribute("applicationID", "NETSCAPE");
    node.setAttribute("authenticationCode", "2.0");
    node.setUserObject(data);
    list.appendChild(node);
    return list;
  }
  
  private String percentageString(float percent, int charCount) {
    String percentStr = ((percent >= 100)?"":(percent >= 10)?" ":"  ");
    percentStr = percentStr + Integer.toString(int(percent)) + "% [";
    for (int cnt=0; cnt < charCount; cnt++) {
      percentStr = percentStr + (((cnt+1)*100f/charCount <= percent)?"|":" ");
    }
    percentStr = percentStr + "]";
    return percentStr; 
  }
}