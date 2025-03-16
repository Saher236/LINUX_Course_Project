import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import javax.imageio.ImageIO;

public class Watermark {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Usage: java Watermark <input_folder> <students_file>");
            System.exit(1);
        }

        String inputFolder = args[0];
        String studentsFile = args[1];

        // קריאת השמות מתוך הקובץ
        StringBuilder studentInfo = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new FileReader(studentsFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                studentInfo.append(line).append(" | ");
            }
        } catch (IOException e) {
            System.out.println("Error reading students file.");
            System.exit(1);
        }

        File folder = new File(inputFolder);
        File[] files = folder.listFiles((dir, name) -> name.toLowerCase().endsWith(".png"));

        if (files == null) {
            System.out.println("No images found in the specified folder.");
            return;
        }

        for (File file : files) {
            try {
                BufferedImage image = ImageIO.read(file);
                Graphics2D g2d = (Graphics2D) image.getGraphics();
                g2d.setFont(new Font("Arial", Font.BOLD, 25));
                g2d.setColor(new Color(255, 0, 0, 150)); // צבע אדום חצי שקוף
                g2d.drawString(studentInfo.toString(), 20, image.getHeight() - 20);
                g2d.dispose();
                
                ImageIO.write(image, "png", new File(file.getAbsolutePath().replace(".png", "_watermarked.png")));
                System.out.println("Watermarked: " + file.getName());
            } catch (Exception e) {
                System.out.println("Error processing file: " + file.getName());
            }
        }
    }
}
