1 pragma solidity ^0.4.25;
2 
3 interface tokenRecipient 
4 { 
5 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
6 }
7 //contrato para definir quien es el administrador central del token
8 contract owned 
9 {    
10   	address public owner;
11 
12     constructor() public    
13     {        
14     	owner = msg.sender;
15 
16     }    
17     modifier onlyOwner     
18     {        
19     	require(msg.sender == owner);
20         _;
21 
22     }
23 
24     function transferOwnership(address newOwner) onlyOwner public     
25     {        
26     	owner = newOwner;
27 
28     }
29 }
30 
31 contract TokenPrueba1 is owned
32 {    
33     //Variables publicas del token    
34    	string public name;
35 
36     string public symbol;
37 
38     //18 decimales es el parametro por defecto, evitar cambiarlo    
39     uint8 public decimals = 8;
40 
41     //cantidad total de la moneda
42     uint256 public totalSupply;
43 
44     //Crea un arreglo para llevar los balances de las cuentas    
45     mapping (address => uint256) public balanceOf;
46 
47     //Arreglo que guarda la "toleracia" de las cuentas con otras, cuanto pueden "tomar" estas    
48     mapping (address => mapping (address => uint256)) public allowance;
49 
50     //cuentas congeladas    
51     mapping (address => bool) public frozenAccount;
52 
53     // Crea un evento en la blockchain que notifica a los clientes de la transferencia    
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56     // Crea un evento en la blockchain que notifica a los clientes de la aprobación    
57     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58 
59     // Notifica a los clientes de la cantidad quemada    
60     event Burn(uint256 value);
61 
62     // Crea un evento que notifica sobre las cuentas congeladas    
63     event FrozenFunds(address target, bool frozen);
64 
65     /**
66     * Funcion constructora     
67     * Le da todos los tokens al creador del contrato      
68     *     
69     *@param initialSupply La cantidad inicial del token     
70     *@param tokenName El nombre del token     
71     *@param tokenSymbol El símbolo a usar por parte del token     
72     *@param centralMinter La direccion del creador     
73     **/    
74     constructor(uint256 initialSupply,string tokenName,string tokenSymbol, address centralMinter) public     
75     {        
76     	//Le damos valor al totalSupply y le damos decimales        
77     	totalSupply = initialSupply * 10 ** uint256(decimals);
78 
79         //al sender del contrato, le damos todos los tokens al principio        
80         balanceOf[msg.sender] = totalSupply;
81 
82         //nombre del token        
83         name = tokenName;
84 
85         //simbolo del token        
86         symbol = tokenSymbol;
87 
88         //administrador de la moneda que puede cambiar la cantidad disponible (minter)       
89         if(centralMinter != 0 ) owner = centralMinter;
90 
91     }        
92     /**     
93     *Funcion para cambiar el numero de tokens disponibles, solo el owner puede cambiarlos     
94     *     
95     *@param target direccion a la que se le cambiará el número de tokens     
96     *@param mintedAmount cantidad que se desea añadir     
97     **/    
98     function mintToken(address target, uint256 mintedAmount) onlyOwner public    
99     {        
100     	balanceOf[target] += mintedAmount;
101 
102         totalSupply += mintedAmount;
103 
104         emit Transfer(0, owner, mintedAmount);
105 
106         emit Transfer(owner, target, mintedAmount);
107 
108     }     
109     /**     
110     * Destruye tokens (quema dinero), solo el propietario puede     
111     *     
112     * Remueve la cantidad de tokens en '_value' del sistema de forma irreversible     
113     *     
114     * @param _value La cantidad de dinero a quemar     
115     */    
116     function burn(uint256 _value) onlyOwner public returns (bool success)    
117     {        
118     // Actualiza el totalSupply        
119     	totalSupply -= _value;
120 
121         emit Burn(_value);
122 
123         return true;
124 
125     }    
126     /**    
127     *Congela una cuenta    
128     *    
129     *@param target direccion de la cuenta que se desea congelar    
130     *@param freeze booleano que decide si se desea congelar la cuenta (true) o descongelar (false)    
131     **/    
132     function freezeAccount(address target, bool freeze) onlyOwner public    
133     {        
134     	frozenAccount[target] = freeze;
135 
136         emit FrozenFunds(target, freeze);
137 
138     }    
139     /**     
140     * Transferencia interna, solo puede ser llamada por este contrato     
141     *      
142     *@param _from direccion de la cuenta desde donde se envian los tokens     
143     *@param _to direccion de la cuenta a la que van los tokens     
144     *@param _value Número de tokens a enviar     
145     */    
146     function _transfer(address _from, address _to, uint _value) internal {        
147     // Previene la transferencia a una cuenta 0x0. Para destruir tokens es mejor usar burn()        
148     	require(_to != 0x0);
149 
150         // Verificamos si el que envia tiene suficiente diner        
151         require(balanceOf[_from] >= _value);
152 
153         // Verificamos si existe o no un overflow        
154         require(balanceOf[_to] + _value >= balanceOf[_to]);
155 
156         // Guardamos esta asercion en el futuro        
157         uint previousBalances = balanceOf[_from] + balanceOf[_to];
158 
159         // Le quitamos tokens al que envia        
160         balanceOf[_from] -= _value;
161 
162         // Le añadimos esa cantidad al que envia        
163         balanceOf[_to] += _value;
164 
165         emit Transfer(_from, _to, _value);
166 
167         // asercion para encontrar bugs        
168         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
169 
170     }    
171     /**     
172     * Transferir tokens     
173     *     
174     * Envia '_value' de tokens a '_to' desde tu cuenta     
175     *     
176     * @param _to La dirección del receptor     
177     * @param _value La cantidad a enviar     
178     */    
179     function transfer(address _to, uint256 _value) public returns (bool success)    
180     {        
181     	require(!frozenAccount[msg.sender]);
182 
183         _transfer(msg.sender, _to, _value);
184 
185         return true;
186 
187     }    
188     /**     
189     * Transferir tokens desde otra dirección     
190     *     
191     * Enviar la cantidad de tokens '_value' hacia la cuenta '_to' desde la cuenta '_from'     
192     * Esta es una función que podria usarse para operaciones de caja     
193     *     
194     * @param _from la dirección de quien envia     
195     * @param _to La dirección del receptor     
196     * @param _value La cantidad de tokens a enviar     
197     */    
198     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)    {        
199     	require(_value <= allowance[_from][msg.sender]);
200 
201      // Check allowance        
202     	allowance[_from][msg.sender] -= _value;
203 
204         _transfer(_from, _to, _value);
205 
206         return true;
207 
208     }    
209     /**     
210     * Coloca la toleracia para otras direcciones     
211     *     
212     * Permite que el '_spender' no gaste mas que la cantidad de '_value' de tokens por parte tuya     
213     *     
214     * @param _spender La dirección a la que se autoriza gastar     
215     * @param _value La cantidad máxima que pueden gastar     
216     */    
217     function approve(address _spender, uint256 _value) public returns (bool success)    {        
218     	allowance[msg.sender][_spender] = _value;
219 
220         emit Approval(msg.sender, _spender, _value);
221 
222         return true;
223 
224     }    
225     /**     
226     * Para funcionar con otros contratos     
227     * En prueba     
228     *     
229     * Coloca la toleracia para otras direcciones y notificar     
230     *     
231     * Permite al '_spender' a gastar no mas de la cantidad de tokens de '_value' de tu cuenta y luego notificar al contrato     
232     *     * @param _spender La dirección autorizada a gastar     * @param _value La cantidad máxima que pueden gastar     
233     * @param _extraData Informacion extra a enviar al contrato     
234     */    
235     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success)    {        
236     	tokenRecipient spender = tokenRecipient(_spender);
237 
238         if (approve(_spender, _value))        
239         {            
240         	spender.receiveApproval(msg.sender, _value, this, _extraData);
241 
242             return true;
243 
244         }    
245     }
246 }