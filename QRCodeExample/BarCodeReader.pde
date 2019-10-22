import java.util.Map;
import java.util.EnumMap;
import java.util.EnumSet;
import java.awt.image.BufferedImage;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.NotFoundException;

class BarCodeReader 
{
  private final BarcodeFormat DEFAULT_BARCODE_FORMAT = BarcodeFormat.CODE_128;
  private BufferedImage barcodeImage;


  BarCodeReader(PImage p) {
    barcodeImage = (BufferedImage) p.getNative();
  }

  public String decode() {
    Map<DecodeHintType, Object> whatHints = new EnumMap<DecodeHintType, Object>(DecodeHintType.class);
    whatHints.put(DecodeHintType.TRY_HARDER, Boolean.TRUE);
    whatHints.put(DecodeHintType.POSSIBLE_FORMATS, EnumSet.allOf(BarcodeFormat.class));

    LuminanceSource tmpSource = new BufferedImageLuminanceSource(barcodeImage);
    BinaryBitmap tmpBitmap = new BinaryBitmap(new HybridBinarizer(tmpSource));
    MultiFormatReader tmpBarcodeReader = new MultiFormatReader();

    Result tmpResult;
    String tmpFinalResult = "Error: No Barcode";
    
    try {
      tmpResult = tmpBarcodeReader.decode(tmpBitmap, whatHints);
      tmpFinalResult = String.valueOf(tmpResult.getText());
    }
    catch (NotFoundException e) {
      tmpFinalResult = "Error: No Barcode";
    }

    return tmpFinalResult;
  }
}
