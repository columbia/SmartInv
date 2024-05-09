1 pragma solidity ^0.4.24;
2 contract owned {
3     address public owner;
4 constructor() public {
5         owner = msg.sender;
6     }
7 modifier onlyOwner {
8         require(msg.sender == owner);
9         _;
10     }
11 function transferOwnership(address newOwner) onlyOwner public {
12         owner = newOwner;
13     }
14 }
15 
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
17 contract TokenERC20 {
18     // Variables públicos del token (hey, por ahora)
19     string public name;
20     string public symbol;
21     uint8 public decimals = 18;
22     uint256 public totalSupply;
23     // esto crea un array con todos los balances
24     mapping (address => uint256) public balanceOf;
25     mapping (address => mapping (address => uint256)) public allowance;
26     // estas dos lineas generan un evento público que notificará a todos los clientes
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29     // quemamos?
30     event Burn(address indexed from, uint256 value);
31      /**
32      * 
33      * Funcion constructor
34      *
35      **/
36     constructor(
37         uint256 initialSupply,
38         string tokenName,
39         string tokenSymbol
40     ) public {
41         totalSupply = initialSupply * 10 ** uint256(decimals);  //le da los 18 decimales
42         balanceOf[msg.sender] = totalSupply;                    // le da al creador toodo los tokens iniciales
43         name = tokenName;                                       // nombre del token
44         symbol = tokenSymbol;                                   // simbolo del token
45     }
46 
47      /**
48      * transferencia interna, solo puede ser llamado desde este contrato
49      **/
50     function _transfer(address _from, address _to, uint _value) internal {
51         // previene la transferencia al address 0x0, las quema
52         require(_to != 0x0);
53         // chequear si el usuario tiene suficientes monedas
54         require(balanceOf[_from] >= _value);
55         // Chequear  por overflows
56         require(balanceOf[_to] + _value > balanceOf[_to]);
57         uint previousBalances = balanceOf[_from] + balanceOf[_to];
58         // Restarle al vendedor
59         balanceOf[_from] -= _value;
60         // Agregarle al comprador
61         balanceOf[_to] += _value;
62 	// se genera la transferencia
63         emit Transfer(_from, _to, _value);
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
65     }
66 /**
67      * Transferir monedas
68      *
69      * mandar `_value` tokens to `_to` desde tu cuenta
70      *
71      * @param _to el address del comprador
72      * @param _value la cantidad a vender
73 **/
74     function transfer(address _to, uint256 _value) public returns (bool success) {
75         _transfer(msg.sender, _to, _value);
76         return true;
77     }
78 /**
79      * transferir cuentas desde otro adress
80      *
81      * mandar `_value` tokens a `_to` desde el address `_from`
82      *
83      * @param _from el address del vendedor
84      * @param _to el address del comprador
85      * @param _value la cantidad a vender
86      */
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         require(_value <= allowance[_from][msg.sender]);     // Check allowance
89         allowance[_from][msg.sender] -= _value;
90         _transfer(_from, _to, _value);
91         return true;
92     }
93 /**
94      * permitir para otros address
95      *
96      * permite al `_spender` a vender no mas `_value` tokens de los que tiene
97      *
98      * @param _spender el address autorizado a vender
99      * @param _value la cantidad máxima autorizada a vender
100 **/
101     function approve(address _spender, uint256 _value) public
102         returns (bool success) {
103         allowance[msg.sender][_spender] = _value;
104         emit Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 /**
108      * permitir a otros otros address y notificar
109      *
110      * permite al `_spender` a vender no mas `_value` tokens de los que tiene, y después genera un ping al contrato
111      *
112      * @param _spender el address autorizado a vender
113      * @param _value la cantidad máxima que puede vender
114      * @param _extraData algo de informacio extra para mandar el contrato aprobado
115 **/
116     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
117         public
118         returns (bool success) {
119         tokenRecipient spender = tokenRecipient(_spender);
120         if (approve(_spender, _value)) {
121             spender.receiveApproval(msg.sender, _value, this, _extraData);
122             return true;
123         }
124     }
125 /**
126      * Destruir tokens
127      *
128      * destruye `_value` tokens del sistema irreversiblemente
129      *
130      * @param _value la cantidad de monedas a quemar
131  **/
132     function burn(uint256 _value) public returns (bool success) {
133         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
134         balanceOf[msg.sender] -= _value;            // Subtract from the sender
135         totalSupply -= _value;                      // Updates totalSupply
136         emit Burn(msg.sender, _value);
137         return true;
138     }
139 /**
140      * destruye tokens de otra cuenta
141      *
142      * destruye `_value` tokens del sistema irreversiblemente desde la cuenta `_from`.
143      *
144      * @param _from el address del usuario 
145      * @param _value la cantidad de monedas a quemar
146 **/
147     function burnFrom(address _from, uint256 _value) public returns (bool success) {
148         require(balanceOf[_from] >= _value);                // checkea si la cantidad a quemar es menor al address
149         require(_value <= allowance[_from][msg.sender]);    // checkea permisos
150         balanceOf[_from] -= _value;                         // resta del balarce
151         allowance[_from][msg.sender] -= _value;             // sustrae del que permite la quema
152         totalSupply -= _value;                              // Update totalSupply
153         emit Burn(_from, _value);
154         return true;
155     }
156 }
157 
158 contract YamanaNetwork is owned, TokenERC20 {
159 uint256 public sellPrice;
160     uint256 public buyPrice;
161 mapping (address => bool) public frozenAccount;
162 /* Esto generea un evento publico en la blockchain que notifica clientes*/
163     event FrozenFunds(address target, bool frozen);
164 /* inicia el contrato en el address del creador del contrato */
165     constructor(
166         uint256 initialSupply,
167         string tokenName,
168         string tokenSymbol
169     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
170 /* solo puede ser llamado desde este contrato */
171     function _transfer(address _from, address _to, uint _value) internal {
172         require (_to != 0x0);                               
173         require (balanceOf[_from] >= _value);               
174         require (balanceOf[_to] + _value >= balanceOf[_to]); 
175         require(!frozenAccount[_from]);                     
176         require(!frozenAccount[_to]);                      
177         balanceOf[_from] -= _value;                        
178         balanceOf[_to] += _value;                          
179         emit Transfer(_from, _to, _value);
180     }
181 
182     /// @notice Create `mintedAmount` tokens and send it to `target`
183     /// @param target Address to receive the tokens
184     /// @param mintedAmount the amount of tokens it will receive
185     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
186         balanceOf[target] += mintedAmount;
187         totalSupply += mintedAmount;
188         emit Transfer(0, this, mintedAmount);
189         emit Transfer(this, target, mintedAmount);
190     }
191 /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
192     /// @param target Address to be frozen
193     /// @param freeze either to freeze it or not
194     function freezeAccount(address target, bool freeze) onlyOwner public {
195         frozenAccount[target] = freeze;
196         emit FrozenFunds(target, freeze);
197     }
198 /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
199     /// @param newSellPrice Price the users can sell to the contract
200     /// @param newBuyPrice Price users can buy from the contract
201     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
202         sellPrice = newSellPrice;
203         buyPrice = newBuyPrice;
204     }
205 /// @notice Buy tokens from contract by sending ether
206     function buy() payable public {
207         uint amount = msg.value / buyPrice;               // calculates the amount
208         _transfer(this, msg.sender, amount);              // makes the transfers
209     }
210 /// @notice Sell `amount` tokens to contract
211     /// @param amount amount of tokens to be sold
212     function sell(uint256 amount) public {
213         address myAddress = this;
214         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
215         _transfer(msg.sender, this, amount);              // makes the transfers
216         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
217     }
218 }