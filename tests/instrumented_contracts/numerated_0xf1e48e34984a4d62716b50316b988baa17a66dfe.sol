1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 library TiposCompartidos {
21     enum TipoPremio {none,free,x2,x3,x5, surprise }
22 
23     struct Celda {
24         address creador;
25         uint polenPositivos;
26         uint polenNegativos;
27         uint256 fechaCreacion;
28         uint primeraPosicion;
29         uint segundaPosicion;
30         uint terceraPosicion;
31         uint cuartaPosicion;
32         uint quintaPosicion;
33         uint sextaPosicion;
34         TipoPremio tipo;
35         bool premio;
36     }
37     
38 }
39 
40 contract BeeGame is owned {
41     
42     uint256 internal sellPrice;
43     uint256 internal buyPrice;
44     uint internal numeroCeldas;
45     string internal name;
46     string internal symbol;
47     uint8 internal decimals;
48     uint internal numeroUsuarios;
49     uint fechaTax;
50 
51     mapping (address => uint) balanceOf;
52 
53     address[] indiceUsuarios;
54     
55     mapping (uint256 => TiposCompartidos.Celda) celdas;
56     
57     uint256[] indiceCeldas;
58 
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 
61     event TransferKO(address indexed from, address indexed to, uint256 value);
62     
63     function BeeGame (
64         uint256 initialSupply,
65         uint256 newSellPrice,
66         uint256 newBuyPrice,
67         uint _fechaTax) {
68         fechaTax = _fechaTax;
69         balanceOf[owner] = initialSupply;
70         setPrices(newSellPrice,newBuyPrice);
71         numeroCeldas = 0;
72         name = "Beether";
73         symbol = "beeth"; 
74         decimals = 2;
75         TiposCompartidos.Celda memory celda = TiposCompartidos.Celda({
76             creador:msg.sender,
77             polenPositivos : 0, 
78             polenNegativos : 3,
79             fechaCreacion: 1509302402021,
80             primeraPosicion : 0,
81             segundaPosicion : 0,
82             terceraPosicion : 0,
83             cuartaPosicion : 0,
84             quintaPosicion : 0,
85             sextaPosicion : 0,
86             tipo:TiposCompartidos.TipoPremio.none,
87             premio:false
88         });
89         indiceCeldas.push(1509302402021);
90         numeroCeldas = numeroCeldas + 1;
91         celdas[1509302402021] = celda;
92     }
93 
94     function buy() payable returns (uint amount) {
95         amount = msg.value / buyPrice;         
96         require(balanceOf[owner] >= amount); 
97         _transfer(owner, msg.sender, amount);
98         incluirUsuario(msg.sender);
99         Transfer(owner, msg.sender, amount); 
100         return amount;                         
101     }
102 
103     function incluirUsuario(address usuario){
104         bool encontrado = false;
105         for (uint i = 0; i < numeroUsuarios; i++) {
106             address usuarioT = indiceUsuarios[i];
107             if (usuarioT == usuario){
108                 encontrado = true;
109             }
110         }
111         if(!encontrado){
112             indiceUsuarios.push(usuario);
113             numeroUsuarios++;
114         }
115     }
116 
117     function cobrarImpuesto(uint _fechaTax) onlyOwner {
118         for (uint i = 0; i < numeroUsuarios; i++) {
119             address usuario = indiceUsuarios[i];
120             if (balanceOf[usuario] > 0){
121                 _transfer(usuario, owner, 1);
122             }
123         }
124         fechaTax = _fechaTax;
125     }
126 
127     function crearCelda(uint _polenes, uint256 _fechaCreacion, uint posicion, uint _celdaPadre, uint _celdaAbuelo, TiposCompartidos.TipoPremio tipo) {
128         require(balanceOf[msg.sender]>=3);
129         require(_polenes == 3);
130         require(_celdaPadre != 0);
131         require((posicion >= 0 && posicion < 7) || (posicion == 0 && msg.sender == owner));
132         require(((tipo == TiposCompartidos.TipoPremio.free || tipo == TiposCompartidos.TipoPremio.x2 || tipo == TiposCompartidos.TipoPremio.x3 || tipo == TiposCompartidos.TipoPremio.x5 || tipo == TiposCompartidos.TipoPremio.surprise) && msg.sender == owner) || tipo == TiposCompartidos.TipoPremio.none);
133         TiposCompartidos.Celda memory celdaPadre = celdas[_celdaPadre];
134         require(
135             ((posicion == 1 && celdaPadre.primeraPosicion == 0) || celdas[celdaPadre.primeraPosicion].tipo != TiposCompartidos.TipoPremio.none ) || 
136             ((posicion == 2 && celdaPadre.segundaPosicion == 0) || celdas[celdaPadre.segundaPosicion].tipo != TiposCompartidos.TipoPremio.none ) || 
137             ((posicion == 3 && celdaPadre.terceraPosicion == 0) || celdas[celdaPadre.terceraPosicion].tipo != TiposCompartidos.TipoPremio.none ) || 
138             ((posicion == 4 && celdaPadre.cuartaPosicion == 0)  || celdas[celdaPadre.cuartaPosicion].tipo != TiposCompartidos.TipoPremio.none ) || 
139             ((posicion == 5 && celdaPadre.quintaPosicion == 0)  || celdas[celdaPadre.quintaPosicion].tipo != TiposCompartidos.TipoPremio.none ) || 
140             ((posicion == 6 && celdaPadre.sextaPosicion == 0) || celdas[celdaPadre.sextaPosicion].tipo != TiposCompartidos.TipoPremio.none )
141         );
142         TiposCompartidos.Celda memory celda;
143         TiposCompartidos.TipoPremio tipoPremio;
144         if (celdas[_fechaCreacion].fechaCreacion == _fechaCreacion) {
145             celda = celdas[_fechaCreacion];
146             celda.creador = msg.sender;
147             celda.premio = false;
148             tipoPremio = celda.tipo;
149             celda.tipo = TiposCompartidos.TipoPremio.none;
150         } else {
151             if (msg.sender != owner) {
152                 celda = TiposCompartidos.Celda({
153                     creador:msg.sender,
154                     polenPositivos : 0, 
155                     polenNegativos : _polenes,
156                     fechaCreacion: _fechaCreacion,
157                     primeraPosicion : 0,
158                     segundaPosicion : 0,
159                     terceraPosicion : 0,
160                     cuartaPosicion : 0,
161                     quintaPosicion : 0,
162                     sextaPosicion : 0,
163                     tipo:tipo,
164                     premio:false
165                 });
166             }else {
167                 celda = TiposCompartidos.Celda({
168                     creador:msg.sender,
169                     polenPositivos : 0, 
170                     polenNegativos : _polenes,
171                     fechaCreacion: _fechaCreacion,
172                     primeraPosicion : 0,
173                     segundaPosicion : 0,
174                     terceraPosicion : 0,
175                     cuartaPosicion : 0,
176                     quintaPosicion : 0,
177                     sextaPosicion : 0,
178                     tipo:tipo,
179                     premio:true
180                 });
181             }
182             indiceCeldas.push(_fechaCreacion);
183             numeroCeldas = numeroCeldas + 1;
184         }
185         celdas[_fechaCreacion] = celda;
186         TiposCompartidos.Celda memory celdaAbuelo = celdas[_celdaAbuelo];
187         uint multiplicador = 1;
188         address repartidor = msg.sender;
189         if (tipoPremio == TiposCompartidos.TipoPremio.x2 && !celda.premio) {
190             multiplicador = 2;
191             repartidor = owner;
192         } else if (tipoPremio == TiposCompartidos.TipoPremio.x3 && !celda.premio) {
193             multiplicador = 3;
194             repartidor = owner;
195         } else if (tipoPremio == TiposCompartidos.TipoPremio.x5 && !celda.premio) {
196             multiplicador = 5;
197             repartidor = owner;
198         }  else if (tipoPremio == TiposCompartidos.TipoPremio.free && !celda.premio) {
199             repartidor = owner;
200         }
201         if (posicion == 1 && celdaPadre.primeraPosicion == 0) {
202             celdaPadre.primeraPosicion = _fechaCreacion;   
203         }else if (posicion == 2 && celdaPadre.segundaPosicion == 0 ) {
204             celdaPadre.segundaPosicion = _fechaCreacion;
205         }else if (posicion == 3 && celdaPadre.terceraPosicion == 0) {
206             celdaPadre.terceraPosicion = _fechaCreacion;
207         }else if (posicion == 4 && celdaPadre.cuartaPosicion == 0) {
208             celdaPadre.cuartaPosicion = _fechaCreacion;
209         }else if (posicion == 5 && celdaPadre.quintaPosicion == 0) {
210             celdaPadre.quintaPosicion = _fechaCreacion;
211         }else if (posicion == 6 && celdaPadre.sextaPosicion == 0) {
212             celdaPadre.sextaPosicion = _fechaCreacion;
213         }
214         if (_celdaAbuelo != 0 && !celda.premio) {
215             _transfer(repartidor,celdaPadre.creador,2 * multiplicador);
216             celdaPadre.polenPositivos = celdaPadre.polenPositivos + (2 * multiplicador);
217             celdaAbuelo.polenPositivos = celdaAbuelo.polenPositivos + (1 * multiplicador);
218             _transfer(repartidor,celdaAbuelo.creador,1 * multiplicador);
219             celdas[celdaAbuelo.fechaCreacion] = celdaAbuelo;
220         }else if (!celda.premio) {
221             _transfer(repartidor,celdaPadre.creador,3 * multiplicador);
222             celdaPadre.polenPositivos = celdaPadre.polenPositivos + ( 3 * multiplicador);
223         }
224         celdas[celdaPadre.fechaCreacion] = celdaPadre;
225     }
226 
227     function getCelda(uint index) returns (address creador, uint polenPositivos, uint polenNegativos, uint fechaCreacion, 
228                                             uint primeraPosicion, uint segundaPosicion, uint terceraPosicion,
229                                             uint cuartaPosicion, uint quintaPosicion, uint sextaPosicion, TiposCompartidos.TipoPremio tipo, bool premio) {
230         uint256 indexA = indiceCeldas[index];
231         TiposCompartidos.Celda memory  celda = celdas[indexA];
232         return (celda.creador,celda.polenPositivos,celda.polenNegativos,celda.fechaCreacion,
233         celda.primeraPosicion, celda.segundaPosicion, celda.terceraPosicion, celda.cuartaPosicion, 
234         celda.quintaPosicion, celda.sextaPosicion, celda.tipo, celda.premio);
235     }
236 
237     function getBalance(address addr) returns(uint) {
238 		return balanceOf[addr];
239 	}
240 
241     function getFechaTax() returns(uint) {
242         return fechaTax;
243     }
244 
245     function getNumeroCeldas() returns(uint) {
246         return numeroCeldas;
247     }
248 
249     function getOwner() returns(address) {
250         return owner;
251     }
252 
253     function getRevenue(uint amount) onlyOwner {
254         owner.transfer(amount);
255     }
256 
257     function sell(uint amount){
258         require(balanceOf[msg.sender] >= amount);         
259         _transfer(msg.sender, owner, amount);
260         uint revenue = amount * sellPrice;
261         if (msg.sender.send (revenue)) {                
262             Transfer(msg.sender, owner, revenue);  
263         }else {
264             _transfer(owner, msg.sender, amount);
265             TransferKO(msg.sender, this, revenue);
266         }                                   
267     }
268 
269     function setFechaTax(uint _fechaTax) onlyOwner {
270         fechaTax = _fechaTax;
271     }
272 
273     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
274         sellPrice = newSellPrice * 1 finney;
275         buyPrice = newBuyPrice * 1 finney;
276     }
277 
278     function transfer(address _to, uint _value){
279         _transfer(msg.sender, _to, _value);
280         incluirUsuario(_to);
281     }
282 
283     function _transfer(address _from, address _to, uint _value) internal {
284         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
285         require(balanceOf[_from] >= _value);                // Check if the sender has enough
286         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
287         balanceOf[_from] = balanceOf[_from] - _value;                         
288         balanceOf[_to] = balanceOf[_to] + _value;                           
289         Transfer(_from, _to, _value);
290     }
291 }