/* @pjs preload="images/cookie.png, images/corrupcion.png, images/fondo.jpg, images/gameover.jpg, images/menem.png, images/spaceship.png, images/win.jpg"; 
 */

PImage imagenFondo;
PImage gameover;
PImage win;
///Jugador

  //Posicion
float jX = 0;
float jY = 0;
int jVelocidad = 10;

int maxVida = 3;
int jVida = maxVida;
  // imagen
PImage jSprite;

  //el maximo de balas (jose) a la vez
int jMaxBalas = 2;



//Balas

// imagenes de las balas
PImage bSprite;
float bVelocidad = 5;

//arreglos (arrays) de posicion
float bX[] = new float[jMaxBalas];
float bY[] = new float[jMaxBalas];

//arreglo (array) de su vicibilidad
boolean bVisible[] = new boolean[jMaxBalas];


//ENEMIGOS == CORRUPCION

PImage eSprite;
int eMax = 27;
int eDistancia = 80;
int eVivos = eMax;

//arreglos (arrays) de posicion
float eX[] = new float[eMax];
float eY[] = new float[eMax];

//arreglo (array) de su vicibilidad
boolean eVisible[] = new boolean[eMax];

PImage beSprite;
int beMax = 10;

float beX[] = new float[beMax];
float beY[] = new float[beMax];

//arreglo (array) de su vicibilidad
boolean beVisible[] = new boolean[beMax];

float beIntervalo;
int beTiempo = 0;
int beEnemigo = 0;
float beVelocidad = 2;

void setup(){
  //se inicia la ventana en 800x600
  size(800,600); 
  

  //se carga la imagen de fondo
  imagenFondo = loadImage("images/fondo.jpg");
  bSprite = loadImage("images/cookie.png");
  jSprite = loadImage("images/spaceship.png");
  eSprite = loadImage("images/menem.png");
  beSprite = loadImage("images/corrupcion.png");
  gameover = loadImage("images/gameover.jpg");
  win = loadImage("images/win.jpg");

  
  //se imprime la imagen
  image(imagenFondo, width / 2, height /2);
  
  // Se inicializa el tamañao del texto
  textSize(20);
  //Se inicializa el jugador
  
  jY = height - 50;
  jX = width / 2;
  
  // se inicializan las balas
  
  for(int i = 0;  i < jMaxBalas; i++) {
    bVisible[i] = false;
  }
  
  // se inicializan los menems
  
  int tX = 0, tY = 1;
  for(int i = 0;  i < eMax; i++) {
    
    eVisible[i] = true;
    
    //se posiciona en reticula los menems
    int x = tX * eDistancia;  
        tX ++;
    
    if(x > width - eDistancia * 2) {
      tX = 1;
      tY ++;
    }
    
    eX[i] = tX * eDistancia;
    eY[i] = tY * eDistancia;


  }
  
  //se incializa el intervalo por disparo
  beIntervalo = random(0, 100);

  //forzamos a que se dibujen las imagenes en el medio
  imageMode(CENTER);
}

void draw() {
  // En cada cuadro por imagen, se imprime el fondo, evita el efecto "paint"
  image(imagenFondo, width / 2, height /2);
  
  //se escribe la cantidad de enemigos y vidas
  text("Corruptos: " + eVivos, 10, 30); 
  text("Vidas: " + jVida, 10, height - 10); 

  // se dibuja el jugador en la posicion q corresponde
  image(jSprite,jX,jY);
  
  //por cada enemigo que este visible
  for(int i = 0;  i < eMax; i++) {
    if(eVisible[i] == true){
      
      //se calcula la distancia de cada bala
      for(int a = 0;  a < jMaxBalas; a++) {
        
        if(bVisible[a] == true){
          
          float distancia = dist(bX[a], bY[a], eX[i], eY[i]);
           
           //si la distancia es menor a 30, colisiona y explota menem         
          if(distancia < 30){
            eVisible[i] = false;
            bVisible[a] = false;
            
            //se restan la cantidad de enemigos vivos
            eVivos --;
          }
        }
      }  
      
      //se dibuja cada enemigo visible
      image(eSprite, eX[i], eY[i]);
    }
  }
  
  
  //se inicializa el contador
  beTiempo ++ ;
  
  
  //si el tiempo llega al intervalo
  if(beTiempo > beIntervalo){
    // se reinicia el tiempo
    beTiempo = 0;
    
    //se crea un nuevo intervalo con random
    beIntervalo = random(0, 100);
    
    //por cada bala enemiga no visible
      for(int i = 0;  i < beMax; i++) {
          // captura la posicion de un enemigo visibnle
          for(int a = 0;  a < eMax; a++) {
            beEnemigo = int(random(0, eMax));
            if(eVisible[beEnemigo] == true){              
              break;
            }
          }
        
      // si la bala esta oculta
      if(beVisible[i] == false){
        
        //muestra la bala
        beVisible[i] = true;
        //posiciona la salida de la bala sobre la posicion del jugador
        beX[i] = eX[beEnemigo];
        beY[i] = eY[beEnemigo];
        break;
      }
    }
  }
  
  
  // se dibujan las balas enemigas solo si no hay enemigos
  
  if(eVivos > 0) {
  
    
    //por cada bala enemiga visible
    for(int i = 0;  i < beMax; i++) {
      
      if(beVisible[i] == true){
        
        //se suma la posicion, haciendo q las balas bajen
        beY[i] = beY[i] + beVelocidad;
        
        //si la posicion esta fuera de la pantalla se oculta
        if(beY[i] > height){
          beVisible[i] = false;
        }
        
        // si las balas estan cerca del jugador
        if(dist(beX[i], beY[i], jX, jY) < 50){
          
          //resta vida y oculta la bala
          jVida--;
          beVisible[i] = false;
        }
        
        // muestra la imagen
        image(beSprite, beX[i], beY[i]);
      }
    }
  
  }
  
  // recorre todas las balas
  for(int i = 0;  i < jMaxBalas; i++) {
    
    // la bala actual esta visible?
    if(bVisible[i] == true){
      
      
      //si la bala se ve, se resta laposición para irse para arriba
      bY[i] = bY[i] - bVelocidad;
            
      //si la bala se va afuera de la pantalla, se oculta
      if(bY[i] < 0){
        bVisible[i] = false;
      }
      
      //se dibuja la bala en su corresponidente posición
      image(bSprite, bX[i], bY[i]);
    }
  }
  
  // si no hay vidas, mostrar la imagen de perder
  if ( jVida < 1) {
    image(gameover, width / 2, height /2);
  }

  // si no hay enemigos vivos, mostrar la imagen de ganar  
  if (eVivos < 1) {
      image(win, width / 2, height /2);
  }
}

void keyPressed() {

  //si presionas una tecla y perdiste o ganaste, reiniciar el juego
  if ( jVida < 1 || eVivos < 1) {
    jVida = maxVida;
    eVivos = eMax;
    
    jY = height - 50;
    jX = width / 2;
  
    
    for(int i = 0;  i < jMaxBalas; i++) {
      bVisible[i] = false;
    }
    
    
    for(int i = 0;  i < beMax; i++) {
      beVisible[i] = false;
    }
    

    for(int i = 0;  i < eMax; i++) {
      eVisible[i] = true;
    }
    
  }
  //empiezan los eventos del teclado
  
    //cuando el chango presiona la tecla CONTROL, dispara la primera bala disponible
  if(keyCode == CONTROL){
    
    // recorre las balas
    for(int i = 0;  i < jMaxBalas; i++) {
      
      // si la bala esta oculta
      if(bVisible[i] == false){
        
        //muestra la bala
        bVisible[i] = true;
        
        //posiciona la salida de la bala sobre la posicion del jugador
        bX[i] = jX;
        bY[i] = jY;
        break;
      }
    }
    
  }
    
  if (keyCode == LEFT){
    jX = jX - jVelocidad;
    
    //limita el movimiento hasta la posición de 0
    if(jX < 0) {
      jX = 0;
    }
  }

    //cuando el chango presiona la telca de DERECHA suma la posicion  
  if (keyCode == RIGHT){
    jX = jX + jVelocidad;
    
    //limita el movimiento hasta el ancho de la pantalla

    if(jX > width) {
      jX = width;
    }
  }
  
  
}

