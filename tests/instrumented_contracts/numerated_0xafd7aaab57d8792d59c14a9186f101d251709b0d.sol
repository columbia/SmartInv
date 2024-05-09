1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return cantidad total de tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner La dirección desde la cual se recuperara el saldo
9     /// @return El balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice envia `_value` del token a `_to` de `msg.sender`
13     /// @param _to La direccion del destinatario
14     /// @param _value La cantidad de token que se transferira
15     /// @return Si la transferencia fue exitosa o no
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice envia `_value` del token a `_to` de `_from` con la condicion de que sea aprobado por `_from`
19     /// @param _from La direccion del remitente
20     /// @param _to La direccion del destinatario
21     /// @param _value La cantidad de token que se transferira
22     /// @return Si la transferencia fue exitosa o no
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender La direccion de la cuenta capaz de transferir los tokens
27     /// @param _value La cantidad de wei que se aprobará para la transferencia
28     /// @return Si la transferencia fue exitosa o no
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner La direccion de la cuenta que posee los tokens
32     /// @param _spender La direccion de la cuenta capaz de transferir los tokens
33     /// @return Cantidad de tokens restantes permitidos gastar
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38     
39 }
40 
41 
42 
43 contract StandardToken is Token {
44 
45     function transfer(address _to, uint256 _value) returns (bool success) {
46         //El valor predeterminado asume que TotalSupply no puede exceder el máximo (2 ^ 256 - 1).
47         //Si tu token omite la oferta total y puede emitir más tokens a medida que pasa el tiempo, debes comprobar si no se ajusta.
48         //Reemplace el si con este en su lugar.
49         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
50         if (balances[msg.sender] >= _value && _value > 0) {
51             balances[msg.sender] -= _value;
52             balances[_to] += _value;
53             Transfer(msg.sender, _to, _value);
54             return true;
55         } else { return false; }
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
59         //lo mismo que arriba. Reemplace esta línea con lo siguiente si desea protegerse contra envoltorios uints.
60         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
61         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
62             balances[_to] += _value;
63             balances[_from] -= _value;
64             allowed[_from][msg.sender] -= _value;
65             Transfer(_from, _to, _value);
66             return true;
67         } else { return false; }
68     }
69 
70     function balanceOf(address _owner) constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
81       return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86     uint256 public totalSupply;
87 }
88 
89 
90 //nombre de este contrato
91 contract TecnonucleousCoin is StandardToken {
92 
93     function () {
94         //if ether is sent to this address, send it back.
95         throw;
96     }
97 
98     /* Variables publicas del token */
99 
100     /*
101     NOTA:
102      Las siguientes variables son vanidades OPCIONALES. Uno no tiene que incluirlos.
103      Permiten personalizar el contrato de token y de ninguna manera influye en la funcionalidad principal.
104      Algunas billeteras / interfaces pueden no molestarse en mirar esta información.
105     */
106     string public name;                   //nombre elegante: por ejemplo, TecnonucleousCoin
107     uint8 public decimals;                //Cuantos decimales mostrar es decir. Podría haber 1000 unidades base con 3 decimales. Significado 0.980 TEC = 980 unidades base Es como comparar 1 wei con 1 éter.
108     string public symbol;                 //Un identificador: por ejemplo, TEC
109     string public version = 'H1.0';       //humano 0.1 estándar. Solo un esquema de control de versiones arbitrario.
110 
111 //
112 // CAMBIE ESTOS VALORES PARA SU TOKEN
113 //
114 
115 //Asegurese de que el nombre de esta funcion coincida con el nombre del contrato anterior. Entonces, si su token se llama TecnonucleousCoin, asegurese de que // el nombre del contrato anterior tambien sea TecnonucleousCoin en lugar de ERC20Token
116 
117     function TecnonucleousCoin(
118         ) {
119         balances[msg.sender] = 100000000000000000000000000;               // Dale al creador todos los tokens iniciales (100000, por ejemplo)
120         totalSupply = 100000000000000000000000000;                        // Actualizar el suministro total (100000, por ejemplo)
121         name = "Tecnonucleous Coin";                                   // Establecer el nombre para fines de visualización
122         decimals = 18;                            // Cantidad de decimales para fines de visualización
123         symbol = "TEC";                               // Establecer el simbolo para fines de visualizacion
124     }
125 
126     /* Aprueba y luego llama al contrato de recepcion */
127     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
128         allowed[msg.sender][_spender] = _value;
129         Approval(msg.sender, _spender, _value);
130 
131         //llame a la funcion receiveApproval en el contrato que desea que se le notifique. Esto crea la firma de la funcion manualmente, por lo que no es necesario incluir un contrato aqui solo para esto.
132         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
133         //se supone que cuando hace esto la llamada * deberia * tener exito, de lo contrario uno usaria vainilla aprobar en su lugar.
134         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
135         return true;
136     }
137 }