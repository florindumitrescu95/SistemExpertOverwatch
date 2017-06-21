/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package exempluinterfataprolog;

import java.awt.Desktop;
import java.awt.FlowLayout;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.io.IOException;
import java.io.PipedOutputStream;
import java.io.PrintStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

/**
 *
 * @author Irina
 */
public class Fereastra extends javax.swing.JFrame {

    /**
     * Creates new form Fereastra
     * @param titlu
     */
    ConexiuneProlog conexiune;
    panou_intrebare panou_intrebari;
    public Fereastra(String titlu) {
        super(titlu);
        initComponents();
        panou_intrebari = new panou_intrebare();       
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        grupBtn = new javax.swing.ButtonGroup();
        incarcaButton = new javax.swing.JButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        textAreaDebug = new javax.swing.JTextArea();
        startButton = new javax.swing.JButton();
        reinitiazaButton = new javax.swing.JButton();
        afisare_fapteButton = new javax.swing.JButton();
        cumButton = new javax.swing.JButton();
        buttonIesire = new javax.swing.JButton();
        background = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setPreferredSize(new java.awt.Dimension(1000, 500));
        getContentPane().setLayout(null);

        incarcaButton.setText("Incarca");
        incarcaButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                incarcaButtonActionPerformed(evt);
            }
        });
        getContentPane().add(incarcaButton);
        incarcaButton.setBounds(30, 100, 100, 23);

        textAreaDebug.setColumns(20);
        textAreaDebug.setRows(5);
        jScrollPane1.setViewportView(textAreaDebug);

        getContentPane().add(jScrollPane1);
        jScrollPane1.setBounds(20, 260, 200, 120);

        startButton.setText("START");
        startButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                startButtonActionPerformed(evt);
            }
        });
        getContentPane().add(startButton);
        startButton.setBounds(470, 200, 90, 23);

        reinitiazaButton.setText("Reintiaza");
        reinitiazaButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                reinitiazaButtonActionPerformed(evt);
            }
        });
        getContentPane().add(reinitiazaButton);
        reinitiazaButton.setBounds(30, 190, 120, 23);

        afisare_fapteButton.setText("Afisare_fapte");
        afisare_fapteButton.setToolTipText("");
        afisare_fapteButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                afisare_fapteButtonActionPerformed(evt);
            }
        });
        getContentPane().add(afisare_fapteButton);
        afisare_fapteButton.setBounds(30, 160, 150, 23);

        cumButton.setText("Cum");
        cumButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                cumButtonActionPerformed(evt);
            }
        });
        getContentPane().add(cumButton);
        cumButton.setBounds(30, 130, 80, 23);

        buttonIesire.setText("Iesire");
        buttonIesire.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                buttonIesireActionPerformed(evt);
            }
        });
        getContentPane().add(buttonIesire);
        buttonIesire.setBounds(30, 220, 80, 23);

        background.setIcon(new javax.swing.ImageIcon(getClass().getResource("/imagini/overwatch-reflections.jpg"))); // NOI18N
        getContentPane().add(background);
        background.setBounds(-5, 0, 1000, 500);

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void incarcaButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_incarcaButtonActionPerformed
        //okButton.setEnabled(false);
        Fereastra.AFISAT_SOLUTII=false;
        
        String valoareparam = "OverwatchReguli.txt";
        String dir=System.getProperty("user.dir").replace("\\", "/");
        try {
            conexiune.expeditor.trimiteMesajSicstus("director('"+dir+"')");
            conexiune.expeditor.trimiteMesajSicstus("incarca('"+valoareparam+"')");
        } catch (Exception ex) {
            Logger.getLogger(Fereastra.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_incarcaButtonActionPerformed

    private void startButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_startButtonActionPerformed

        this.startButton.setVisible(false);
        this.setLayout(new FlowLayout());
        this.add(this.panou_intrebari);
        this.panou_intrebari.paint(null);
        this.panou_intrebari.revalidate();
        this.repaint();
        this.revalidate();
        try {
            conexiune.expeditor.trimiteMesajSicstus("comanda(consulta)");
            
        } catch (Exception ex) {
            Logger.getLogger(Fereastra.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }//GEN-LAST:event_startButtonActionPerformed

    private void reinitiazaButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_reinitiazaButtonActionPerformed
        this.getContentPane().removeAll();
        this.panou_intrebari.removeAll();
        this.panou_intrebari.revalidate();
        this.panou_intrebari.repaint();
            
        this.panou_intrebari = new panou_intrebare();
        this.initComponents();
        
        
        try {
            conexiune.expeditor.trimiteSirSicstus("reinitiaza");
            
            
        } catch (Exception ex) {
            Logger.getLogger(Fereastra.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_reinitiazaButtonActionPerformed

    private void cumButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_cumButtonActionPerformed
       String s = (String)JOptionPane.showInputDialog(
                    this,
                    "Introduceti scopul:\n",
                    "Customized Dialog",
                    JOptionPane.PLAIN_MESSAGE,
                    null,
                    null,
                    "");

        if ((s != null) && (s.length() > 0)) {
           String cale = "output_overwatch";
           Fi = new File(cale);
           File[] listaFisiere = Fi.listFiles();

           if(listaFisiere != null)
            for(int i =0;i<listaFisiere.length;i++)
            {
                String numeFisier = listaFisiere[i].getName();
                if(numeFisier.toLowerCase().contains(s.toLowerCase())){ 
                    Fi = new File(cale + "/" + listaFisiere[i].getName());
                    try {
                        Desktop.getDesktop().open(Fi);
                    } catch (IOException ex) {
                        Logger.getLogger(Fereastra.class.getName()).log(Level.SEVERE, null, ex);}
                    break;
                }
            }
            else 
                    JOptionPane.showMessageDialog(null, "No solutions boss", "Error", JOptionPane.ERROR_MESSAGE);
            return;

        }
    }//GEN-LAST:event_cumButtonActionPerformed

    private void buttonIesireActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_buttonIesireActionPerformed
        
    }//GEN-LAST:event_buttonIesireActionPerformed

    private void afisare_fapteButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_afisare_fapteButtonActionPerformed
        
        
    }//GEN-LAST:event_afisare_fapteButtonActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(Fereastra.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Fereastra.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Fereastra.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Fereastra.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new Fereastra("Verificare").setVisible(true);
            }
        });
    }
    public void optiuneOK(java.awt.event.ActionEvent evt){
        
        String raspuns= ((JButton)(evt.getSource())).getText();
        try {
            conexiune.expeditor.trimiteSirSicstus(raspuns);
            
        
        } catch (Exception ex) {
            Logger.getLogger(Fereastra.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    public javax.swing.JTextArea getDebugTextArea(){
        return textAreaDebug;
    }
    
    
    public void setConexiune(ConexiuneProlog _conexiune){
        conexiune=_conexiune;
    }
    
    public void seteazaIntrebare(String intrebare)
    {
        this.panou_intrebari.jLabel1.setText(intrebare);
        this.panou_intrebari.repaint();
    }
    
    public void seteazaRaspunsuri(String optiuni)
    {
        this.panou_intrebari.jPanel1.removeAll();
        this.panou_intrebari.jPanel1.setLayout(new FlowLayout());
        
        optiuni = optiuni.trim();
        optiuni = optiuni.substring(1,optiuni.length()-1);
        optiuni = optiuni.trim();
        
        String[] optiuniVector = optiuni.split(" ");
        
        for(int i=0;i<optiuniVector.length;i++)
        {
            JButton b=new JButton(optiuniVector[i]);
            b.addActionListener(new java.awt.event.ActionListener() {
                public void actionPerformed(java.awt.event.ActionEvent evt) {
                    optiuneOK(evt);
                }
            });
            this.panou_intrebari.jPanel1.add(b);
        }
        
        this.panou_intrebari.jPanel1.repaint();
        this.panou_intrebari.jPanel1.revalidate();
    }
    
    public void setSolutie(String raspuns){
        if(!Fereastra.AFISAT_SOLUTII)
        {
            this.panou_intrebari.removeAll();
            this.panou_intrebari.setLayout(new BoxLayout(this.panou_intrebari, BoxLayout.PAGE_AXIS));
            Fereastra.AFISAT_SOLUTII=true;
        }
        raspuns=raspuns.trim();
        raspuns=raspuns.substring(2,raspuns.length()-1);
        raspuns=raspuns.trim();
        JLabel jsol=new JLabel(raspuns);
        this.panou_intrebari.add(jsol);
        
       

        this.panou_intrebari.repaint();
        this.panou_intrebari.revalidate();
    }
    
    
    File Fi;
    public static boolean AFISAT_SOLUTII=false;
    private JComboBox patternList;
    JButton okButton = new JButton("OK");
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton afisare_fapteButton;
    private javax.swing.JLabel background;
    private javax.swing.JButton buttonIesire;
    private javax.swing.JButton cumButton;
    private javax.swing.ButtonGroup grupBtn;
    private javax.swing.JButton incarcaButton;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JButton reinitiazaButton;
    private javax.swing.JButton startButton;
    private javax.swing.JTextArea textAreaDebug;
    // End of variables declaration//GEN-END:variables
}
