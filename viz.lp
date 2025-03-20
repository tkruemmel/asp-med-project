% Define nodes for each formula component
node(F) :- for(F,_,_).

% Define edges between formulas to represent the nested structure
edge((F,G)) :- for(F,and,G).
edge((F,G+1)) :- for(F,and,G).
edge((F,G)) :- for(F,or,G).
edge((F,G+1)) :- for(F,or,G).
edge((F,G)) :- for(F,neg,G).

% Define node shapes based on type
attr(node,F,shape,rectangle) :- for(F,(and;or;neg),_).
attr(node,F,shape,circle) :- for(F,atom,_).

% Node labels with ID and type/value
attr(node,F,label,@concat(F," : ",T)) :- for(F,T,_), not for(F,atom,_).
attr(node,F,label,@concat(F," : ",A)) :- for(F,atom,A).

% Node styling
attr(node,F,style,"filled") :- node(F).
attr(node,F,color,"blue") :- node(F).
attr(node,F,fontcolor,"blue") :- node(F).

% Different background colors for different node types
attr(node,F,fillcolor,"lightskyblue") :- for(F,atom,_).
attr(node,F,fillcolor,"lightsteelblue") :- for(F,neg,_).
attr(node,F,fillcolor,"lightcyan") :- for(F,and,_).
attr(node,F,fillcolor,"lavender") :- for(F,or,_).

% Node sizing
attr(node,F,width,"0.7") :- node(F).
attr(node,F,height,"0.5") :- node(F).
attr(node,F,margin,"0.1") :- node(F).

% Edge styling
attr(edge,((X,Y)),color,"blue") :- edge((X,Y)).
attr(edge,((X,Y)),penwidth,"1.5") :- edge((X,Y)).

% Graph layout
attr(graph,default,layout,"dot").
attr(graph,default,rankdir,"TB").
attr(graph,default,splines,"true").
attr(graph,default,nodesep,"0.5").
attr(graph,default,ranksep,"0.5").
attr(graph,default,fontsize,"14").
attr(graph,default,label,"Propositional Formula Visualization").