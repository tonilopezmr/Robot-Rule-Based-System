
(defglobal ?*nod-gen* = 0)
(defglobal ?*f* = 1)


(deffacts bases 		
     (bases A B H J K M N R)
)	    

(deffacts caminos
   
	(camino A B 10 con bici)
	(camino A C 8 sin bici)
	(camino A E 10 con bici)
	
	(camino B A 10 con bici)
	(camino B C 5 sin bici)
	(camino B F 6 sin bici)
	
	(camino C A 8 sin bici)
	(camino C B 5 sin bici)
	(camino C G 6 sin bici)
	(camino C D 6 sin bici)
	(camino C H 6 sin bici)
	
	(camino D C 6 sin bici)
	(camino D H 14 con bici)
	
	(camino E A 10 con bici)
	(camino E I 20 sin bici)
	(camino E J 9 con bici)
	
	(camino F B 6 sin bici)
	(camino F K 10 sin bici)
	(camino F L 6 sin bici)
	
	(camino G C 6 sin bici)
	(camino G H 8 sin bici)
	(camino G L 9 sin bici)
	(camino G M 12 sin bici)
	
	(camino H C 6 sin bici)
	(camino H G 8 sin bici)
	(camino H D 14 con bici)
	(camino H I 12 con bici)
	
	(camino I H 12 con bici)
	(camino I E 20 sin bici)
	(camino I O 2 sin bici)
		
	(camino J E 9 con bici)
	(camino J O 7 con bici)
	
	(camino K F 10 sin bici)
	(camino K L 2 con bici)
	
	(camino L F 6 sin bici)
	(camino L K 2 con bici)
	(camino L P 6 con bici)
	(camino L M 7 con bici)
	(camino L G 9 sin bici)
	
	(camino M G 12 sin bici)
	(camino M Q 2 sin bici)
	(camino M L 7 con bici)

	(camino N Q 6 sin bici)
	(camino N O 8 con bici)
	
	(camino O I 2 sin bici)
	(camino O J 7 con bici)
	(camino O N 8 con bici)
	
	(camino P L 6 con bici)
	(camino P Q 2 sin bici)
	(camino P R 4 con bici)
	
	(camino Q N 6 sin bici)
	(camino Q M 2 sin bici)
	(camino Q P 2 sin bici)
	(camino Q R 3 sin bici)
	
	(camino R P 4 con bici)
	(camino R Q 3 sin bici)
)

;;rules

;; Ir a pie: acción para moverse de un punto a otro contiguo conectados por un
;; camino. El coste de esta operación será el indicado por el camino. 

(defrule apie
  ?f <- (ciudad $?x sin bici actual ?nodo coste ?c nivel ?nivel)
  (camino ?nodo ?dest ?coste $?y) 
  (profundidad-maxima ?prof)
  (test (<= ?nivel ?prof))
  =>
  (assert (ciudad $?x sin bici actual ?dest coste (+ ?c ?coste) nivel (+ ?nivel 1) ))
  (bind ?*nod-gen* (+ ?*nod-gen* 1)))

;; Ir en bicicleta: acción para desplazarse en bicicleta de un punto a otro contiguo que
;; se encuentran conectados por un camino apto para ir en bicicleta. El coste de esta
;; operación será la mitad del indicado por el camino (división entera por 2).g 

(defrule abici
  ?f <- (ciudad $?x con bici actual ?nodo coste ?c nivel ?nivel)
  (camino ?nodo ?dest ?coste con bici)
  (profundidad-maxima ?prof)
  (test (<= ?nivel ?prof))
  =>
  (assert (ciudad $?x con bici actual ?dest coste (+ ?c (/ ?coste 2)) nivel (+ ?nivel 1) ))
  (bind ?*nod-gen* (+ ?*nod-gen* 1)))

;; Coger bici: acción que permite coger una bici en uno de los puntos marcados como
;; base (talksi no lleva ya bici). El coste será 1. 

(defrule cogerbici
  ?f <- (ciudad $?x sin bici actual ?nodo coste ?c nivel ?nivel)
  (bases $?y ?nodo $?z)
  (profundidad-maxima ?prof)
  (test (<= ?nivel ?prof))
  =>
  (assert (ciudad $?x con bici actual ?nodo coste (+ ?c 1) nivel (+ ?nivel 1) ))
  (bind ?*nod-gen* (+ ?*nod-gen* 1)))

;; Dejar bici: acción que permite dejar una bici en uno de los puntos marcados como
;; base (solo si lleva bici). El coste será 1. 

(defrule dejarbici
  ?f <- (ciudad $?x con bici actual ?nodo coste ?c nivel ?nivel)
  (bases $?y ?nodo $?z)
  (profundidad-maxima ?prof)
  (test (<= ?nivel ?prof))
  =>
  (assert (ciudad $?x sin bici actual ?nodo coste (+ ?c 1) nivel (+ ?nivel 1) ))
  (bind ?*nod-gen* (+ ?*nod-gen* 1)))
  
;;Parada: acción para detectar que se ha llegado al destino y no está montado en bici.   

(defrule parada
  (declare (salience 100))
  ?f <- (ciudad ?origen ?destino sin bici actual ?destino coste ?c nivel ?nivel) 
  (profundidad-maxima ?prof)
  (test (<= ?nivel ?prof))
  =>
    (printout t "SOLUCION ENCONTRADA EN EL NIVEL " ?nivel crlf)
    (printout t "NUMERO DE NODOS EXPANDIDOS O REGLAS DISPARADAS " ?*nod-gen* crlf)
    (printout t "COSTE TOTAL DESDE " ?origen " HASTA DESTINO " ?destino " es: " ?c crlf) 
    (halt)
)

(defrule no-solucion
	(declare (salience -99))
	(profundidad-maxima ?prof)
=>
	(halt)
	(printout t "**** NO HAY SOLUCION ENCONTRADA PARA PROFUNDIDAD  " ?prof " :/ **** "crlf)
)

(deffunction inicio ()
     (set-salience-evaluation when-activated)
     (reset)
	 (printout t "Profundidad Maxima:= " )
	 (bind ?prof (read))
	 (printout t "Desde:= " )
	 (bind ?origen (read))
	 (printout t "Hasta:= " )
	 (bind ?destino (read))
	 (printout t "Tipo de busqueda " crlf "    1.- Anchura" crlf "    2.- Profundidad" crlf "Opción : ")
  	 (bind ?a (read))
	 (if (= ?a 1)
	       then   (set-strategy breadth)
	       else   (set-strategy depth))
	 (printout t " Ejecuta run para poner en marcha el programa " crlf)
	 (assert (ciudad ?origen ?destino sin bici actual ?origen coste 0 nivel 0))
	 (assert (profundidad-maxima ?prof))
)

