<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte General de Asociados</title>
    <?php if($formato == "landscape") {  ?> 
        <style>
            /* referencia: https://ourcodeworld.co/articulos/leer/687/como-configurar-un-encabezado-y-pie-de-pagina-en-dompdf */
            @page {
                margin: 0cm 0cm;
                size: landscape;
            }
        </style>
    <?php } else { ?>
        <style>
            /* referencia: https://ourcodeworld.co/articulos/leer/687/como-configurar-un-encabezado-y-pie-de-pagina-en-dompdf */
            @page {
                margin: 0cm 0cm;
                size: portrait;
            }
        </style>
    <?php } ?>
    <style>

        

        /** Defina ahora los márgenes reales de cada página en el PDF **/
        body {
            margin-top: 3.3cm;
            /* margin-left: 2cm;
            margin-right: 2cm;
            margin-bottom: 2cm; */
        }
            
        header {
            position: fixed;
            top: 0.9cm;
            left: 2cm;
            right: 2cm;
            height: 2.5cm;
            text-align: center;
            line-height: 0.8cm;
            font-family: 'Times New Roman' !important;
        }
        * {
            font-family: 'Roboto', sans-serif;
            box-sizing: border-box;
            /* font-weight: bold; */
            font-size: 11px;
        }
		

        /* #contenido {
            
            width: 696px; */
            /* border: 1px solid gray */
					
        /* } */

        /* #logo img {
		
            width: 100%;
        }

        #empresa, #documento {
            padding: 1%;
        }

        #cliente {
            border-radius: 5px; 
            border: 1px solid gray; 
            padding: 1%;
            height: 70px;

        }
     */


        .row {
            width: 100%;
            height: 30px;
            /* margin-top: 15px; */
            /* clear: both; */
        }

        .row-sm {
            width: 100%;
            height: 20px;
            /* margin-top: 15px; */
            /* clear: both; */
        }
        .clear {
            clear: both; 
        }
        .col {
            float: left;
            /* border: 1px solid black; */
        }
        

        h2, h3, h4, h5 {
            /* text-align: center !important; */
            margin: 2px 0;
            /* padding-botton: 2px; */
			
        }
    </style>
   
</head>
<body>
    @include("layouts.cabecera")
    <main>
        
        
        <div class="row" style="margin-top: 160px; margin-bottom: 10px; text-align: center; font-size: 25px !important;">
            <div class="col" style="width: 100%;">
                <h3><?php echo mayusculas(traducir("traductor.titulo_reporte_general_asociados")); ?></h3>
            </div>
        </div>
        <div class="clear"></div>
        <div class="row" style="">
            <div class="col" style="width: 100%;">
                <table border="1">
                    <thead>
                        <tr>
                        <?php 
                            $headers = (array)$miembros[0];
                            $keys = array_keys($headers);
                            // print_r($keys); exit;
                            for ($i=0; $i < count($keys) ; $i++) { 
                                echo '<th>'.traducir("traductor.".$keys[$i]).'</th>';
                            }
                        ?>
                        </tr>
                    </thead>
                    <tbody>
                        <?php 
                            foreach($miembros as $miembro) {
                                echo '<tr>';
                                    foreach($miembro as $value) {
                                        echo '<td>'.$value.'</td>';
                                    }
                                echo '</tr>';
                            }
                        ?>
                    </tbody>
                </table>
            </div>
          
        </div>
        
      
    

    </main>
    
    
</body>
</html>

<script>

    window.print();
</script>