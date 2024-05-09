1 pragma solidity ^0.5.1;
2 library MatematicaSegura {
3     
4     function multiplicar (uint256 p, uint256 s) internal pure returns(uint256){
5         if(p == 0  || s == 0) return 0;
6         uint256 c = p*s;
7         require (c/p == s);
8         return c;
9     }
10     
11     function dividir (uint256 v, uint256 d) internal pure returns(uint256){
12         require(d>0);
13         uint256 r = v / d;
14         require(v == r*d + v % d);
15         return r;
16     }
17     
18     function sumar(uint256 s1, uint256 s2) internal pure returns(uint256){
19         uint256 r = s1 + s2;
20         require ( r >= s1);
21         return r;
22     }
23     
24     function restar (uint256 m, uint256 s) internal pure returns(uint256) {
25         require (m > s);
26         return m-s;
27     }
28 }
29 
30 interface IERC20 {
31     //funciones basicas
32     function totalSupply() external returns(uint256);
33     function balanceOf(address sujeto) external returns(uint256);
34         
35     //funciones para transferencia
36     function transfer (address destinatario, uint256 value) external returns (bool);
37     function transferFrom(address enviador, address destinatario, uint256 value) external returns (bool);
38     
39     //funciones para exchange
40     function approve(address autorizado, uint256 cantidad) external returns (bool);
41     function allowance (address propietario, address autorizado) external view returns (uint256);
42     
43     //eventos
44     event Transfer (address remitente, address destinatario, uint256 cantidad);
45     event Approval (address indexed propietario, address indexed autorizado, uint256 cantidad);
46 }
47 
48 contract Payer is IERC20{
49     
50     using MatematicaSegura for uint256;
51     
52     // variables ERC20 tradicionales
53     uint256 constant private MAX_UINT256 = 2**256 - 1;
54     mapping (address => uint256) public balances;
55     mapping (address => mapping (address => uint256)) public autorizado;
56     address public propietario;    
57 
58     //caracteristicas de la moneda
59     uint256 public decimals = 8;
60     string public name = "Payer";
61     string public symbol = "Payer";
62     uint256 public totalSupply;
63 
64     // variables para contrato limitado
65     mapping (address => bool) public administradores;
66     mapping (address => bool) public notransferible;
67     mapping (address => uint256) public gastable;
68     uint256 public plimitacion;
69     bool public state;
70 
71     constructor(uint256 _totalSupply) public {
72         state = false;
73         plimitacion = 100;
74         totalSupply = _totalSupply;
75         propietario = msg.sender;
76         balances[propietario] = totalSupply;
77         administradores[propietario] = true;
78     }
79     
80     modifier OnlyOwner(){
81         require(msg.sender == propietario, "No es el propietario");
82         _;
83     }
84    
85     //funciones propias
86     function isAdmin(address _direccion) public view OnlyOwner returns(bool){
87         return administradores[_direccion];
88     }
89     function setNewAdmin(address _postulante) public OnlyOwner returns(bool){
90         require(_postulante != address(0), "Dirección No Válida");
91         administradores[_postulante] = true;
92     }
93     
94     function setNoTransferible(address _admin, address _sujeto, bool _state) public returns (bool) {
95         require(administradores[_admin], "Dirección no autorizada");
96         notransferible[_sujeto] = _state;
97         return true;
98     }
99     
100     function setState (bool _state) public OnlyOwner{
101         state = _state;
102     }
103 
104     // ========== FUNCIONES ESTANDAR ERC20    
105     function balanceOf(address _sujeto) public returns (uint256){
106         require(_sujeto != address(0),"Dirección No Válida");
107         return balances[_sujeto];
108     }
109 
110     //funciones de transferencia
111     function transfer(address _destinatario, uint256 _cantidad) public returns(bool){
112 
113         _transfer(msg.sender, _destinatario, _cantidad);
114         return true;
115     }
116     function transferFrom(address _remitente, address _destinatario, uint256 _cantidad) public returns(bool){
117         _transfer(_remitente, _destinatario, _cantidad);
118         return true;
119     }
120 
121     function _transfer (address _remitente, address _destinatario, uint256 _cantidad) internal{
122         if(state){
123             if(administradores[_remitente]){
124                 setNoTransferible(_remitente, _destinatario, state);
125             }
126         }
127         require(verificaTransferibilidad(_remitente, _cantidad), "Saldo transferible insuficiente");
128         balances[_remitente] = balances[_remitente].restar(_cantidad);
129         balances[_destinatario] = balances[_destinatario].sumar(_cantidad);
130         emit Transfer(_remitente, _destinatario, _cantidad);
131     }
132 
133     function verificaTransferibilidad(address _sujeto, uint256 _montoSolicitado) internal returns(bool) {
134         if(notransferible[_sujeto]) {
135             require(gastable[_sujeto].sumar(_montoSolicitado) <= balances[_sujeto].multiplicar(plimitacion).dividir(100), "Saldo gastable insuficiente");
136             gastable[_sujeto] = gastable[_sujeto].sumar(_montoSolicitado);
137             return true;
138         }else{
139             return true;
140         }
141     }
142 
143 
144     function setGastable (uint256 _plimitacion) public OnlyOwner returns(bool){
145         require(_plimitacion != 0, "Tasa no válida");
146         plimitacion = _plimitacion;
147         return true;
148     }
149 
150    //funciones para exchange
151     function allowance (address _propietario, address _autorizado) public view returns(uint256){
152         return autorizado[_propietario][_autorizado];
153     }
154 
155     /** funcion que autoriza la nueva cantidad a transferir */
156     function approve( address _autorizado, uint256 _cantidad) public returns(bool) {
157         _approve(msg.sender, _autorizado, _cantidad);
158         return true;
159     }
160     
161     function _approve (address _propietario, address _autorizado, uint256 _cantidad) internal {
162         require (_propietario != address(0), "Dirección No Válida");
163         require (_autorizado != address(0), "Dirección No Válida");
164 
165         autorizado[_propietario][_autorizado] = _cantidad;
166         emit Approval(_propietario, _autorizado, _cantidad);
167     }
168 
169     function increaseAllowance (uint256 _adicional, address _autorizado) private OnlyOwner returns (bool){
170         require(_autorizado != address(0), "Dirección No Válida");
171         autorizado[msg.sender][_autorizado] = autorizado[msg.sender][_autorizado].sumar(_adicional);
172         emit Approval(msg.sender, _autorizado, _adicional);
173         return true;
174     }
175     function decreaseAllowance (uint256 _reduccion, address _autorizado) private OnlyOwner returns (bool){
176         require(_autorizado != address(0), "Dirección No Válida");
177         autorizado[msg.sender][_autorizado] = autorizado[msg.sender][_autorizado].restar(_reduccion);
178         emit Approval(msg.sender, _autorizado, _reduccion);
179         return true;
180     }
181 
182     //funciones adicionales ERC20
183     function burn(address _cuenta, uint256 _cantidad) internal{
184         require(_cuenta != address(0), "Dirección No Válida");
185         require(balances[_cuenta] >= _cantidad, "Saldo insuficiente para quemar");
186         balances[_cuenta] = balances[_cuenta].restar(_cantidad);
187         totalSupply = totalSupply.restar(_cantidad);
188         emit Transfer(_cuenta, address(0), _cantidad);
189     }
190     function burnFrom(address _cuenta, uint256 _cantidad) internal{
191         require (_cuenta != address(0), "Dirección No Valida");
192         require (autorizado[_cuenta][msg.sender] >= _cantidad, "Saldo insuficiente para quemar");
193         autorizado[_cuenta][msg.sender] = autorizado[_cuenta][msg.sender].restar(_cantidad);
194         burn(_cuenta, _cantidad);
195     }
196 
197     event Transfer(address enviante, address destinatario, uint256 cantidad);
198     event Approval(address propietario, address autorizado, uint256 cantidad);
199 }