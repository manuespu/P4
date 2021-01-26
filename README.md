PAV - P4: reconocimiento y verificación del locutor
===================================================

Obtenga su copia del repositorio de la práctica accediendo a [Práctica 4](https://github.com/albino-pav/P4)
y pulsando sobre el botón `Fork` situado en la esquina superior derecha. A continuación, siga las
instrucciones de la [Práctica 2](https://github.com/albino-pav/P2) para crear una rama con el apellido de
los integrantes del grupo de prácticas, dar de alta al resto de integrantes como colaboradores del proyecto
y crear la copias locales del repositorio.

También debe descomprimir, en el directorio `PAV/P4`, el fichero [db_8mu.tgz](https://atenea.upc.edu/pluginfile.php/3145524/mod_assign/introattachment/0/spk_8mu.tgz?forcedownload=1)
con la base de datos oral que se utilizará en la parte experimental de la práctica.

Como entrega deberá realizar un *pull request* con el contenido de su copia del repositorio. Recuerde
que los ficheros entregados deberán estar en condiciones de ser ejecutados con sólo ejecutar:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.sh
  make release
  run_spkid mfcc train test classerr verify verifyerr
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Recuerde que, además de los trabajos indicados en esta parte básica, también deberá realizar un proyecto
de ampliación, del cual deberá subir una memoria explicativa a Atenea y los ficheros correspondientes al
repositorio de la práctica.

A modo de memoria de la parte básica, complete, en este mismo documento y usando el formato *markdown*, los
ejercicios indicados.

## Ejercicios.

### SPTK, Sox y los scripts de extracción de características.

- Analice el script `wav2lp.sh` y explique la misión de los distintos comandos involucrados en el *pipeline*
  principal (`sox`, `$X2X`, `$FRAME`, `$WINDOW` y `$LPC`). Explique el significado de cada una de las 
  opciones empleadas y de sus valores.
  sox: Transforma el fichero de entrada WAVE a formato raw (sin cabecera).

    x2x: Programa sptk que permite la conversión entre distintos formatos de datos, convierte la señal de entrada a reales con coma flotante de 32 bits sin cabecera.

    FRAME: Divide la señal de entrada en tramas de 240 muestras (30ms) con desplazamientos de 80 muestras (10ms).

    WINDOW: Ventana de Blackman por defecto. Multiplica cada trama.

    LPC: Calcula los "lpc_order" (8 en nuestro caso) primeros coeficientes de predicción linial de todas las tramas.


- Explique el procedimiento seguido para obtener un fichero de formato *fmatrix* a partir de los ficheros de
  salida de SPTK (líneas 45 a 47 del script `wav2lp.sh`).
    
     ,,,
       cmd:
       /scripts/run_spkid lp
       fmatrix_show work/lp/BLOCK01/SES017/*.lp | egrep '^\[' | cut -f3,4 > lp_2_3.txt
       cp lp_2_3.txt /mnt/c/Users/manue/Desktop         Moure el .txt al directori on tenim representaciones.m

       matlab : 
       >>representaciones

       Repetim per lpcc i mfcc

  * ¿Por qué es conveniente usar este formato (u otro parecido)? Tenga en cuenta cuál es el formato de
    entrada y cuál es el de resultado.
    
      - Permite tener los datos más ordenados y que sea más facil por tanto acceder a ellos.

- Escriba el *pipeline* principal usado para calcular los coeficientes cepstrales de predicción lineal
  (LPCC) en su fichero <code>scripts/wav2lpcc.sh</code>:
     ```
      sox $inputfile -t raw -e signed -b 16 - | $X2X +sf | $FRAME -l 240 -p 80 | $WINDOW -l 240 -L 240 |
      $LPC -l 240 -m $lpc_order | $LPCC -m $lpc_order -M $cepstrum_order > $base.lpcc

- Escriba el *pipeline* principal usado para calcular los coeficientes cepstrales en escala Mel (MFCC) en su
  fichero <code>scripts/wav2mfcc.sh</code>:
     ```
        sox $inputfile -t raw -e signed -b 16 - | $X2X +sf | $FRAME -l 240 -p 80 | $WINDOW -l 240 -L 240 |
        $MFCC -l 240 -m $mfcc_order -n $num_filters -s $freq > $base.mfcc

### Extracción de características.

- Inserte una imagen mostrando la dependencia entre los coeficientes 2 y 3 de las tres parametrizaciones
  para todas las señales de un locutor.

  - lp 2,3
  <img src="lp_2_3.png" width="320">

  - lpcc 2,3
  <img src="lpcc_2_3.png" width="320">

  - mfcc 2,3
  <img src="mfcc_2_3.png" width="320">
  
  + Indique **todas** las órdenes necesarias para obtener las gráficas a partir de las señales 
    parametrizadas.
    
      ```
         cmd:
         /scripts/run_spkid lp
         fmatrix_show work/lp/BLOCK01/SES017/*.lp | egrep '^\[' | cut -f3,4 >>
         cp lp_2_3.txt /mnt/c/Users/manue/Desktop         Moure el .txt al di>

         matlab :
         >>representaciones

         Repetim per lpcc i mfcc

  + ¿Cuál de ellas le parece que contiene más información?

La lpcc contiene más información

- Usando el programa <code>pearson</code>, obtenga los coeficientes de correlación normalizada entre los
  parámetros 2 y 3 para un locutor, y rellene la tabla siguiente con los valores obtenidos.

  |                        | LP   | LPCC | MFCC |
  |------------------------|:----:|:----:|:----:|
  | &rho;<sub>x</sub>[2,3] |-0.872284|0.184235|-0.198242|
  
  + Compare los resultados de <code>pearson</code> con los obtenidos gráficamente.

  Los resultados son consecuentes con las gráficas. Porque los coeficientes LPCC y MFCC tienen menos correlación conjunta, lo que se traduce y en una mayor dispersión de los puntos. Los coeficientes LPCC están más correlados y se aprecia con cierto grado de linealidad en la gráfica.
  
- Según la teoría, ¿qué parámetros considera adecuados para el cálculo de los coeficientes LPCC y MFCC?
El número de coeficientes LPCC debería estar entre 8 y 12. Y el número de coeficientes LPCC debería estar entre 14 y 18.


### Entrenamiento y visualización de los GMM.

Complete el código necesario para entrenar modelos GMM.

- Inserte una gráfica que muestre la función de densidad de probabilidad modelada por el GMM de un locutor para sus dos primeros coeficientes de MFCC.
         
 <img src="gmm1.png" width="320">

- Inserte una gráfica que permita comparar los modelos y poblaciones de dos locutores distintos (la gŕafica de la página 20 del enunciado puede servirle de referencia del resultado deseado). Analice la capacidad del modelado GMM para diferenciar las señales de uno y otro.

  <img src="gmm2.png" width="320">
  
  <img src="gmm3.png" width="320">

### Reconocimiento del locutor.

Complete el código necesario para realizar reconociminto del locutor y optimice sus parámetros.

- Inserte una tabla con la tasa de error obtenida en el reconocimiento de los locutores de la base de datos
  SPEECON usando su mejor sistema de reconocimiento para los parámetros LP, LPCC y MFCC.
  | Parametrización | nErrores | nTotal | Tasa Error |
  |------------------------|:----:|:----:|:----:|
  | LP | 84 | 785 | 10.7% |
  | LPCC | 12 | 784 | 1.53% |
  | MFCC | 6 | 749 | 0.80% |

Valores óptimos encontrados y usados para la tabla:
  LP: Orden LP=14, Ngaussianas=8
  LPCC: Ncoeficientes=14, Orden LP=14, Ngaussianas=8
  MFCC: Ncoeficientes=16, Nfiltros=20, Ngaussianas=20

  Hemos decido además reducir el umbral de log. prob. a la mitad (-T 0.0005) y el Num. Iteraciones está a -N 40.  

  Concluimos que nuestro mejor sistema corresponde con MFCC con 16 coeficientes MFCC, 20 filtros, gaussianas cada GMM y 100 gaussianas para gmmWorld. Obtenemos los siguientes resultados en clasificación al ejecutar:
  
  run_spkid mfcc train test classerr trainworld verify verifyerr
  
### Verificación del locutor.

Complete el código necesario para realizar verificación del locutor y optimice sus parámetros.

- Inserte una tabla con el *score* obtenido con su mejor sistema de verificación del locutor en la tarea
  de verificación de SPEECON. La tabla debe incluir el umbral óptimo, el número de falsas alarmas y de
  pérdidas, y el score obtenido usando la parametrización que mejor resultado le hubiera dado en la tarea
  de reconocimiento.

  Con datos óptimos verificación:

  |  Missed  | False Alarm   | Cost detection | Threshold |
  |------------------------|:----:|:----:|:----:|
  | 42/250 | 0/1000 | 16.8 | 0.326770288423101 |


  Con datos óptimos reconocimiento:

  |  Missed | False Alarma   | Cost detection | Threshold |
  |------------------------|:----:|:----:|:----:|
  | 93/250 | 0/1000 | 47.1 | 0.318673595056289 |

   
 
### Test final

- Adjunte, en el repositorio de la práctica, los ficheros `class_test.log` y `verif_test.log` 
  correspondientes a la evaluación *ciega* final.

Ficheros generados y añadidos al repositorio usando:
    FEAT=mfcc run_spkid finalclass finalverif


### Trabajo de ampliación.

- Recuerde enviar a Atenea un fichero en formato zip o tgz con la memoria (en formato PDF) con el trabajo 
  realizado como ampliación, así como los ficheros `class_ampl.log` y/o `verif_ampl.log`, obtenidos como 
  resultado del mismo.


    - Mejoras en lpcc:
      - error_rate de 1.53% a 0.28%. Ahora es más bajo incluso que mfcc (0.54%)
      - THR: 0,152118729152205
      - C.detect: 12.4 (Más bajo que 16.8 de mfcc)


    - Tabla Resum Resultados con parámetros optimos:

	  <img src="tabla_final.png" width="320">

								

