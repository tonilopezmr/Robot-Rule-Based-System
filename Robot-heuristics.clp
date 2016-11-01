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

;;for each lamp
;;if robot has bulbs: go to the warehouse, charge, go to lamp, repair lamp
;;else only: go to lamp, repair lamp
(deffunction h (?rX ?rY ?b ?lamps ?wX ?wY)
    
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
    (declare (salience (- 0 ?*f*)))
	(Grid ?mX ?mY Warehouse ?wX ?wY)
	(Robot ?x ?y ?b $?aux Level ?n)
	(MaxDepth ?maxDepth)
	(test (< ?n ?maxDepth))
	(test (< ?x ?mX))
	(test (control (+ ?x 1) ?y ?b (create$ $?aux) ?wX ?wY ?n))
=> 
	(assert (Robot (+ ?x 1) $?aux Level (+ ?n 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule move-left
    (declare (salience (- 0 ?*f*)))
	(Grid ?mX ?mY $?)
	(Robot ?x ?y ?b $?aux Level ?n)
	(MaxDepth ?maxDepth)
	(test (< ?n ?maxDepth))
	(test (> ?x 1))
    (test (control (- ?x 1) ?y ?b (create$ $?aux) ?wX ?wY ?n))
=>
	(assert (Robot (- ?x 1) $?aux Level (+ ?n 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule move-up
    (declare (salience (- 0 ?*f*)))
	(Grid ?mX ?mY $?)
	(Robot ?x ?y ?b $?aux Level ?n)
	(MaxDepth ?maxDepth)
	(test (< ?n ?maxDepth))
	(test (< ?y ?mY))
	(test (control ?x (+ ?y 1) ?b (create$ $?aux) ?wX ?wY ?n))
=>
	(assert (Robot ?x (+ ?y 1) $?aux Level (+ ?n 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule move-down
    (declare (salience (- 0 ?*f*)))
	(Grid ?mX ?mY $?)
	(Robot ?x ?y ?b $?aux Level ?n)
	(MaxDepth ?maxDepth)
	(test (< ?n ?maxDepth))
	(test (> ?y 1))
	(test (control ?x (- ?y 1) ?b (create$ $?aux) ?wX ?wY ?n))
=>
	(assert (Robot ?x (- ?y 1) $?aux Level (+ ?n 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule repair
    (declare (salience (- 0 ?*f*)))
	(Robot ?x ?y ?bulb $?aux Lamp ?x ?y ?lBulb $?aux1 Level ?n)
	(MaxDepth ?maxDepth)
	(test (< ?n ?maxDepth))
	(test (>= ?bulb ?lBulb))
	(test (control ?x ?y (- ?blub ?lBulb) (create$ $?aux $aux1) ?wX ?wY ?n))
=> 
	(assert (Robot ?x ?y (- ?bulb ?lBulb) $?aux $?aux1 Level (+ ?n 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule charge 
    (declare (salience (- 0 ?*f*)))
	(Grid $? Warehouse ?x ?y)
	(Robot ?x ?y ?bulb $?aux Lamp ?lX ?lY ?lBulb $?aux1 Level ?n)
	(MaxDepth ?maxDepth)
	(test (< ?n ?maxDepth))
	(test (< ?bulb ?lBulb))
	(test (control ?x ?y (+ ?bulb (- ?lBulb ?bulb)) (create$ $?aux Lamp ?lX ?lY ?lBulb $?aux1) ?wX ?wY ?n))
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
