;; Static fact (Grid X Y Warehouse X Y) 
;; Static fact (MaxDepth ?maxDepth) (Max depth in graph)
;; Dynamic fact (Robot X Y BULBS Lamp X X BURNED_OUT_BULBS Lamp.. Level LEVEL)

(deffacts facts
	(Grid 5 4 Warehouse 2 3)
)

(defglobal ?*nod-gen* = 0)
(defglobal ?*f* = 1)
	
(deffunction control (?rX ?rY ?b ?lamps ?wX ?wY ?n)
    (bind ?*f* (+ ?n 1 (h ?rX ?rY ?b ?lamps ?wX ?wY))))

(deffunction h (?rX ?rY ?b ?lamps ?wX ?wY)
        //for each lamp
	//if robot has bulbs: go to the warehouse, charge, go to lamp, repair lamp
	//else only: go to lamp, repair lamp
)

(deffunction init () 
	(reset)
	(printout t "Max depth? " crlf)
	(bind ?maxDepth (read))
	(printout t "Type search " crlf "    1.- Breadth" crlf "    2.- Depth" crlf )
	(bind ?a (read))
	(if (= ?a 1)
	       then   (set-strategy breadth)
	       else   (set-strategy depth))
	(assert (Robot 1 3 0 Lamp 3 4 3 Lamp 5 4 2 Lamp 4 2 2 Level 0))
	(assert (MaxDepth ?maxDepth))
)	
	
(defrule move-right
	(Grid ?mX ?mY $?)
	(Robot ?x $?aux Level ?n)
	(MaxDepth ?maxDepth)
	(test (< ?n ?maxDepth))
	(test (< ?x ?mX))
=> 
	(assert (Robot (+ ?x 1) $?aux Level (+ ?n 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule move-left
	(Grid ?mX ?mY $?)
	(Robot ?x $?aux Level ?n)
	(MaxDepth ?maxDepth)
	(test (< ?n ?maxDepth))
	(test (> ?x 1))
=>
	(assert (Robot (- ?x 1) $?aux Level (+ ?n 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule move-up
	(Grid ?mX ?mY $?)
	(Robot ?x ?y $?aux Level ?n)
	(MaxDepth ?maxDepth)
	(test (< ?n ?maxDepth))
	(test (< ?y ?mY))
=>
	(assert (Robot ?x (+ ?y 1) $?aux Level (+ ?n 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule move-down
	(Grid ?mX ?mY $?)
	(Robot ?x ?y $?aux Level ?n)
	(MaxDepth ?maxDepth)
	(test (< ?n ?maxDepth))
	(test (> ?y 1))
=>
	(assert (Robot ?x (- ?y 1) $?aux Level (+ ?n 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule repair
	(Robot ?x ?y ?bulb $?aux Lamp ?x ?y ?lBulb $?aux1 Level ?n)
	(MaxDepth ?maxDepth)
	(test (< ?n ?maxDepth))
	(test (>= ?bulb ?lBulb))
=> 
	(assert (Robot ?x ?y (- ?bulb ?lBulb) $?aux $?aux1 Level (+ ?n 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule charge 
	(Grid $? Warehouse ?x ?y)
	(Robot ?x ?y ?bulb $?aux Lamp ?lX ?lY ?lBulb $?aux1 Level ?n)
	(MaxDepth ?maxDepth)
	(test (< ?n ?maxDepth))
	(test (< ?bulb ?lBulb))
=> 
	(assert (Robot ?x ?y (+ ?bulb (- ?lBulb ?bulb)) $?aux Lamp ?lX ?lY ?lBulb $?aux1 Level (+ ?n 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule bad-gameover
	(declare (salience -99))
=>
	(halt)
	(printout t "****  NOT SOLUTION :/ **** " crlf)
)

(defrule gameover
	(declare (salience 100))
	(Robot ?x ?y ?bulb Level ?n)
	(test (= ?bulb 0))
=> 
	(halt)
	(printout t "****  GAME OVER **** " crlf)
	(printout t "Level : " ?n " Nodes : " ?*nod-gen* crlf)
)
