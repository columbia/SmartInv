1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 library TiposCompartidos {
21     enum TipoPremio {none,free,x2,x3,x5, surprise }
22 
23     enum EstadoMensaje{pendiente,aprobado,rechazado}
24 
25     struct Celda {
26         address creador;
27         uint polenPositivos;
28         uint polenNegativos;
29         uint256 fechaCreacion;
30         uint primeraPosicion;
31         uint segundaPosicion;
32         uint terceraPosicion;
33         uint cuartaPosicion;
34         uint quintaPosicion;
35         uint sextaPosicion;
36         TipoPremio tipo;
37         bool premio;
38     }
39 
40     struct Mensaje {
41         address creador;
42         string apodo;
43         uint256 fechaCreacion;
44         string mensaje;
45         TiposCompartidos.EstadoMensaje estado;
46         string motivo;
47     }
48     
49 }
50 
51 contract BeeGame is owned {
52     
53     uint256 internal sellPrice;
54     uint256 internal buyPrice;
55     uint internal numeroCeldas;
56     uint internal numeroMensajes;
57     string internal name;
58     string internal symbol;
59     uint8 internal decimals;
60     uint internal numeroUsuarios;
61     uint fechaTax;
62 
63     mapping (address => uint) balanceOf;
64 
65     address[] indiceUsuarios;
66     
67     mapping (uint256 => TiposCompartidos.Celda) celdas;
68     mapping (uint256 => TiposCompartidos.Mensaje) mensajes;
69     
70     uint256[] indiceCeldas;
71     uint256[] indiceMensajes;
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     event TransferKO(address indexed from, address indexed to, uint256 value);
76     
77     function BeeGame (
78         uint256 initialSupply,
79         uint256 newSellPrice,
80         uint256 newBuyPrice,
81         uint _fechaTax) public {
82         fechaTax = _fechaTax;
83         balanceOf[owner] = initialSupply;
84         setPrices(newSellPrice,newBuyPrice);
85         numeroCeldas = 0;
86         name = "Beether";
87         symbol = "beeth"; 
88         decimals = 2;
89         TiposCompartidos.Celda memory celda = TiposCompartidos.Celda({
90             creador:msg.sender,
91             polenPositivos : 0, 
92             polenNegativos : 3,
93             fechaCreacion: 1509302402021,
94             primeraPosicion : 0,
95             segundaPosicion : 0,
96             terceraPosicion : 0,
97             cuartaPosicion : 0,
98             quintaPosicion : 0,
99             sextaPosicion : 0,
100             tipo:TiposCompartidos.TipoPremio.none,
101             premio:false
102         });
103         indiceCeldas.push(1509302402021);
104         numeroCeldas = numeroCeldas + 1;
105         numeroUsuarios = numeroUsuarios + 1;
106         indiceUsuarios.push(msg.sender);
107         celdas[1509302402021] = celda;
108     }
109 
110     function buy() public payable returns (uint amount) {
111         amount = msg.value / buyPrice;         
112         require(balanceOf[owner] >= amount); 
113         _transfer(owner, msg.sender, amount);
114         incluirUsuario(msg.sender);
115         Transfer(owner, msg.sender, amount); 
116         return amount;                         
117     }
118 
119     function incluirUsuario(address usuario) public {
120         bool encontrado = false;
121         for (uint i = 0; i < numeroUsuarios; i++) {
122             address usuarioT = indiceUsuarios[i];
123             if (usuarioT == usuario){
124                 encontrado = true;
125             }
126         }
127         if(!encontrado){
128             indiceUsuarios.push(usuario);
129             numeroUsuarios++;
130         }
131     }
132 
133     function cobrarImpuesto(uint _fechaTax) public onlyOwner {
134         for (uint i = 0; i < numeroUsuarios; i++) {
135             address usuario = indiceUsuarios[i];
136             if (balanceOf[usuario] > 0){
137                 _transfer(usuario, owner, 1);
138             }
139         }
140         fechaTax = _fechaTax;
141     }
142 
143     function crearCelda(uint _polenes, uint256 _fechaCreacion, uint posicion, uint _celdaPadre, uint _celdaAbuelo, TiposCompartidos.TipoPremio tipo) public {
144         require(balanceOf[msg.sender]>=3);
145         require(_polenes == 3);
146         require(_celdaPadre != 0);
147         require((posicion >= 0 && posicion < 7) || (posicion == 0 && msg.sender == owner));
148         require(((tipo == TiposCompartidos.TipoPremio.free || tipo == TiposCompartidos.TipoPremio.x2 || tipo == TiposCompartidos.TipoPremio.x3 || tipo == TiposCompartidos.TipoPremio.x5 || tipo == TiposCompartidos.TipoPremio.surprise) && msg.sender == owner) || tipo == TiposCompartidos.TipoPremio.none);
149         TiposCompartidos.Celda memory celdaPadre = celdas[_celdaPadre];
150         require(
151             ((posicion == 1 && celdaPadre.primeraPosicion == 0) || celdas[celdaPadre.primeraPosicion].tipo != TiposCompartidos.TipoPremio.none ) || 
152             ((posicion == 2 && celdaPadre.segundaPosicion == 0) || celdas[celdaPadre.segundaPosicion].tipo != TiposCompartidos.TipoPremio.none ) || 
153             ((posicion == 3 && celdaPadre.terceraPosicion == 0) || celdas[celdaPadre.terceraPosicion].tipo != TiposCompartidos.TipoPremio.none ) || 
154             ((posicion == 4 && celdaPadre.cuartaPosicion == 0)  || celdas[celdaPadre.cuartaPosicion].tipo != TiposCompartidos.TipoPremio.none ) || 
155             ((posicion == 5 && celdaPadre.quintaPosicion == 0)  || celdas[celdaPadre.quintaPosicion].tipo != TiposCompartidos.TipoPremio.none ) || 
156             ((posicion == 6 && celdaPadre.sextaPosicion == 0) || celdas[celdaPadre.sextaPosicion].tipo != TiposCompartidos.TipoPremio.none )
157         );
158         TiposCompartidos.Celda memory celda;
159         TiposCompartidos.TipoPremio tipoPremio;
160         if (celdas[_fechaCreacion].fechaCreacion == _fechaCreacion) {
161             celda = celdas[_fechaCreacion];
162             celda.creador = msg.sender;
163             celda.premio = false;
164             tipoPremio = celda.tipo;
165             celda.tipo = TiposCompartidos.TipoPremio.none;
166         } else {
167             if (msg.sender != owner) {
168                 celda = TiposCompartidos.Celda({
169                     creador:msg.sender,
170                     polenPositivos : 0, 
171                     polenNegativos : _polenes,
172                     fechaCreacion: _fechaCreacion,
173                     primeraPosicion : 0,
174                     segundaPosicion : 0,
175                     terceraPosicion : 0,
176                     cuartaPosicion : 0,
177                     quintaPosicion : 0,
178                     sextaPosicion : 0,
179                     tipo:tipo,
180                     premio:false
181                 });
182             }else {
183                 celda = TiposCompartidos.Celda({
184                     creador:msg.sender,
185                     polenPositivos : 0, 
186                     polenNegativos : _polenes,
187                     fechaCreacion: _fechaCreacion,
188                     primeraPosicion : 0,
189                     segundaPosicion : 0,
190                     terceraPosicion : 0,
191                     cuartaPosicion : 0,
192                     quintaPosicion : 0,
193                     sextaPosicion : 0,
194                     tipo:tipo,
195                     premio:true
196                 });
197             }
198             indiceCeldas.push(_fechaCreacion);
199             numeroCeldas = numeroCeldas + 1;
200         }
201         celdas[_fechaCreacion] = celda;
202         TiposCompartidos.Celda memory celdaAbuelo = celdas[_celdaAbuelo];
203         uint multiplicador = 1;
204         address repartidor = msg.sender;
205         if (tipoPremio == TiposCompartidos.TipoPremio.x2 && !celda.premio) {
206             multiplicador = 2;
207             repartidor = owner;
208         } else if (tipoPremio == TiposCompartidos.TipoPremio.x3 && !celda.premio) {
209             multiplicador = 3;
210             repartidor = owner;
211         } else if (tipoPremio == TiposCompartidos.TipoPremio.x5 && !celda.premio) {
212             multiplicador = 5;
213             repartidor = owner;
214         }  else if (tipoPremio == TiposCompartidos.TipoPremio.free && !celda.premio) {
215             repartidor = owner;
216         }
217         if (posicion == 1 && celdaPadre.primeraPosicion == 0) {
218             celdaPadre.primeraPosicion = _fechaCreacion;   
219         }else if (posicion == 2 && celdaPadre.segundaPosicion == 0 ) {
220             celdaPadre.segundaPosicion = _fechaCreacion;
221         }else if (posicion == 3 && celdaPadre.terceraPosicion == 0) {
222             celdaPadre.terceraPosicion = _fechaCreacion;
223         }else if (posicion == 4 && celdaPadre.cuartaPosicion == 0) {
224             celdaPadre.cuartaPosicion = _fechaCreacion;
225         }else if (posicion == 5 && celdaPadre.quintaPosicion == 0) {
226             celdaPadre.quintaPosicion = _fechaCreacion;
227         }else if (posicion == 6 && celdaPadre.sextaPosicion == 0) {
228             celdaPadre.sextaPosicion = _fechaCreacion;
229         }
230         if (_celdaAbuelo != 0 && !celda.premio) {
231             _transfer(repartidor,celdaPadre.creador,2 * multiplicador);
232             celdaPadre.polenPositivos = celdaPadre.polenPositivos + (2 * multiplicador);
233             celdaAbuelo.polenPositivos = celdaAbuelo.polenPositivos + (1 * multiplicador);
234             _transfer(repartidor,celdaAbuelo.creador,1 * multiplicador);
235             celdas[celdaAbuelo.fechaCreacion] = celdaAbuelo;
236         }else if (!celda.premio) {
237             _transfer(repartidor,celdaPadre.creador,3 * multiplicador);
238             celdaPadre.polenPositivos = celdaPadre.polenPositivos + ( 3 * multiplicador);
239         }
240         celdas[celdaPadre.fechaCreacion] = celdaPadre;
241     }
242 
243     function getCelda(uint index) public view returns (address creador, uint polenPositivos, uint polenNegativos, uint fechaCreacion, 
244                                             uint primeraPosicion, uint segundaPosicion, uint terceraPosicion,
245                                             uint cuartaPosicion, uint quintaPosicion, uint sextaPosicion, TiposCompartidos.TipoPremio tipo, bool premio) {
246         uint256 indexA = indiceCeldas[index];
247         TiposCompartidos.Celda memory  celda = celdas[indexA];
248         return (celda.creador,celda.polenPositivos,celda.polenNegativos,celda.fechaCreacion,
249         celda.primeraPosicion, celda.segundaPosicion, celda.terceraPosicion, celda.cuartaPosicion, 
250         celda.quintaPosicion, celda.sextaPosicion, celda.tipo, celda.premio);
251     }
252 
253     function getMensaje(uint index) public view returns(address creador,uint fechaCreacion,string _mensaje,string apodo, TiposCompartidos.EstadoMensaje estado, string motivo){
254         uint256 indexA = indiceMensajes[index];
255         TiposCompartidos.Mensaje memory mensaje = mensajes[indexA];
256         return (mensaje.creador,mensaje.fechaCreacion,mensaje.mensaje,mensaje.apodo,mensaje.estado,mensaje.motivo);
257     }
258 
259     function insertarMensaje(uint256 _fechaCreacion, string _apodo,string _mensaje) public {
260         bool encontrado = false;
261         for (uint i = 0; i < numeroUsuarios && !encontrado; i++) {
262             address usuarioT = indiceUsuarios[i];
263             if (usuarioT == msg.sender) {
264                 encontrado = true;
265             }
266         }
267         require(encontrado);
268         indiceMensajes.push(_fechaCreacion);
269         numeroMensajes = numeroMensajes + 1;
270         TiposCompartidos.Mensaje memory mensaje = TiposCompartidos.Mensaje({
271             creador:msg.sender,
272             apodo:_apodo,
273             fechaCreacion:_fechaCreacion,
274             mensaje:_mensaje,
275             estado:TiposCompartidos.EstadoMensaje.aprobado,
276             motivo:""
277         });
278         mensajes[_fechaCreacion] = mensaje;
279     }
280 
281     function aprobarMensaje(uint256 _fechaCreacion,TiposCompartidos.EstadoMensaje _estado,string _motivo) public onlyOwner {
282         TiposCompartidos.Mensaje memory mensaje = mensajes[_fechaCreacion];
283         mensaje.estado = _estado;
284         mensaje.motivo = _motivo;
285         mensajes[_fechaCreacion] = mensaje;
286     }
287 
288     function getBalance(address addr) public view returns(uint) {
289 		return balanceOf[addr];
290 	}
291 
292     function getFechaTax() public view returns(uint) {
293         return fechaTax;
294     }
295 
296     function getNumeroCeldas() public view returns(uint) {
297         return numeroCeldas;
298     }
299 
300     function getNumeroMensajes() public view returns(uint) {
301         return numeroMensajes;
302     }
303 
304     function getOwner() public view returns(address) {
305         return owner;
306     }
307 
308     function getRevenue(uint amount) public onlyOwner {
309         owner.transfer(amount);
310     }
311 
312     function sell(uint amount) public {
313         require(balanceOf[msg.sender] >= amount);         
314         _transfer(msg.sender, owner, amount);
315         uint revenue = amount * sellPrice;
316         if (msg.sender.send (revenue)) {                
317             Transfer(msg.sender, owner, revenue);  
318         }else {
319             _transfer(owner, msg.sender, amount);
320             TransferKO(msg.sender, this, revenue);
321         }                                   
322     }
323 
324     function setFechaTax(uint _fechaTax) public onlyOwner {
325         fechaTax = _fechaTax;
326     }
327 
328     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
329         sellPrice = newSellPrice * 1 finney;
330         buyPrice = newBuyPrice * 1 finney;
331     }
332 
333     function transfer(address _to, uint _value) public {
334         _transfer(msg.sender, _to, _value);
335         incluirUsuario(_to);
336     }
337 
338     function _transfer(address _from, address _to, uint _value) internal {
339         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
340         require(balanceOf[_from] >= _value);                // Check if the sender has enough
341         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
342         balanceOf[_from] = balanceOf[_from] - _value;                         
343         balanceOf[_to] = balanceOf[_to] + _value;                           
344         Transfer(_from, _to, _value);
345     }
346 }