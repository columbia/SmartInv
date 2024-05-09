1 pragma solidity ^0.4.24;
2 
3 contract MemoContract {
4 
5    //evento para avisar que se agrego una jugada
6   event addedJugada (
7       uint jugadanro
8   );  
9 
10   // contador de jugadas
11   uint contadorjugadas = 0;
12   
13 
14   //Dueño del contrato
15   address owner;
16 
17   // Representa una jugada realizada
18   struct Jugada {
19       uint idjugada;
20       uint fecha; // timestamp
21       string nombre; // nombre de la persona
22       string mail; // mail de la persona
23       uint intentos; // cantidad de intentos en los que gano
24       uint tiempo; // tiempo que demoró en terminar la partida
25       bool valida; //jugada válida
26   }
27 
28   // Colección de jugadas  
29   Jugada[] public jugadas;
30 
31 
32   // map para direcciones activas para informar jugadas
33   mapping( address => bool) public direcciones;
34 
35 
36 
37   //Constructor del contrato
38   constructor() public {
39 
40     //Registrar el propietario y que quede habilitado para enviar jugadas
41     owner = msg.sender;
42     direcciones[owner] = true;
43 
44    
45   }
46 
47 
48  function updateDireccion ( address _direccion , bool _estado)  {
49      // Solo el dueño puede habilitar o deshabilitar direcciones que pueden escribir la jugada
50      require(msg.sender == owner);
51 
52      // Evitar que se quiera modificar el estado del owner
53      require(_direccion != owner);
54 
55      direcciones[_direccion] = _estado;
56  } 
57 
58 function updateJugada( uint _idjugada, bool _valida ) {
59     
60     //Validar que envía el dueño del contrato
61     require(direcciones[msg.sender] );
62     
63     //Modificar la jugada
64     jugadas[_idjugada -1].valida = _valida;
65     
66 }
67  
68 
69   // Agregar una jugada
70   function addJugada ( uint _fecha , string _nombre , string _mail , uint _intentos , uint _tiempo ) public {
71       
72       require(direcciones[msg.sender] );
73 
74       contadorjugadas = contadorjugadas + 1;
75       
76       jugadas.push (
77             Jugada ({
78                 
79                 idjugada:contadorjugadas,
80                 fecha: _fecha,
81                 nombre:_nombre,
82                 mail: _mail,
83                 intentos: _intentos,
84                 tiempo: _tiempo,
85                 valida: true
86             }));
87 
88         // Llamar al evento para informar que se agrego la jugada
89         addedJugada( contadorjugadas );
90 
91         }
92 
93 
94 
95     // Devolver todas las jugadas
96     function fetchJugadas() constant public returns(uint[], uint[], bytes32[], bytes32[], uint[], uint[], bool[]) {
97         
98 
99 
100 
101             
102             
103             uint[] memory _idjugadas = new uint[](contadorjugadas);
104             uint[] memory _fechas = new uint[](contadorjugadas);
105             bytes32[] memory _nombres = new bytes32[](contadorjugadas);
106             bytes32[] memory _mails = new bytes32[](contadorjugadas);
107             uint[] memory _intentos = new uint[](contadorjugadas);
108             uint[] memory _tiempos = new uint[](contadorjugadas);
109             bool[] memory _valida = new bool[](contadorjugadas);
110         
111             for (uint8 i = 0; i < jugadas.length; i++) {
112 
113                 
114                  _idjugadas[i] = jugadas[i].idjugada;
115                 _fechas[i] = jugadas[i].fecha;
116                 _nombres[i] = stringToBytes32( jugadas[i].nombre );
117                 _mails[i] = stringToBytes32( jugadas[i].mail );
118                 _intentos[i] = jugadas[i].intentos;
119                 _tiempos[i] = jugadas[i].tiempo;
120                 _valida[i] = jugadas[i].valida;
121                 
122             }
123             
124             return ( _idjugadas, _fechas, _nombres, _mails, _intentos, _tiempos, _valida);
125         
126     }
127     
128     
129     function stringToBytes32(string memory source)  returns (bytes32 result)  {
130     bytes memory tempEmptyStringTest = bytes(source);
131     if (tempEmptyStringTest.length == 0) {
132         return 0x0;
133     }
134 
135     assembly {
136         result := mload(add(source, 32))
137     }
138 }
139     
140 }