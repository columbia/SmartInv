1 pragma solidity ^0.4.16;
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
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 /**
21  * Math operations with safety checks
22  */
23 contract SafeMath {
24   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b > 0);
32     uint256 c = a / b;
33     assert(a == b * c + a % b);
34     return c;
35   }
36 
37   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c>=a && c>=b);
45     return c;
46   }
47 }
48 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external ; }
49 
50 contract TokenERC20 is SafeMath {
51     // Public variables of the token
52     string public name = "World Trading Unit";
53     string public symbol = "WTU";
54     uint8 public decimals = 8;
55     // 18 decimals is the strongly suggested default, avoid changing it
56     uint256 public TotalToken = 21000000;
57     uint256 public RemainingTokenStockForSale;
58 
59     // This creates an array with all balances
60     mapping (address => uint256) public balanceOf;
61     mapping (address => mapping (address => uint256)) public allowance;
62 
63     // This generates a public event on the blockchain that will notify clients
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     // This notifies clients about the amount burnt
67     event Burn(address indexed from, uint256 value);
68 
69     /**
70      * Constructor function
71      *
72      * Initializes contract with initial supply tokens to the creator of the contract
73      */
74     function TokenERC20() public {
75         RemainingTokenStockForSale = safeMul(TotalToken,10 ** uint256(decimals));  // Update total supply with the decimal amount
76         balanceOf[msg.sender] = RemainingTokenStockForSale;                    // Give the creator all initial tokens
77     }
78 
79     /**
80      * Internal transfer, only can be called by this contract
81      */
82     function _transfer(address _from, address _to, uint _value) internal {
83         // Prevent transfer to 0x0 address. Use burn() instead
84         require(_to != 0x0);
85         // Check if the sender has enough
86         require(balanceOf[_from] >= _value);
87         // Save this for an assertion in the future
88         uint previousBalances = safeAdd(balanceOf[_from],balanceOf[_to]);
89         // Subtract from the sender
90         balanceOf[_from] =  safeSub(balanceOf[_from], _value);
91         // Add the same to the recipient
92         balanceOf[_to] = safeAdd(balanceOf[_to],_value);
93         Transfer(_from, _to, _value);
94         // Asserts are used to use static analysis to find bugs in your code. They should never fail
95         assert(safeAdd(balanceOf[_from],balanceOf[_to]) == previousBalances);
96     }
97 
98     /**
99      * Transfer tokens
100      *
101      * Send `_value` tokens to `_to` from your account
102      *
103      * @param _to The address of the recipient
104      * @param _value the amount to send
105      */
106     function transfer(address _to, uint256 _value) public {
107         _transfer(msg.sender, _to, _value);
108     }
109 
110     /**
111      * Transfer tokens from other address
112      *
113      * Send `_value` tokens to `_to` in behalf of `_from`
114      *
115      * @param _from The address of the sender
116      * @param _to The address of the recipient
117      * @param _value the amount to send
118      */
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
120         require(_value <= allowance[_from][msg.sender]);     // Check allowance
121         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender],_value);
122         _transfer(_from, _to, _value);
123         return true;
124     }
125 
126     /**
127      * Set allowance for other address
128      *
129      * Allows `_spender` to spend no more than `_value` tokens in your behalf
130      *
131      * @param _spender The address authorized to spend
132      * @param _value the max amount they can spend
133      */
134     function approve(address _spender, uint256 _value) public
135         returns (bool success) {
136         allowance[msg.sender][_spender] = _value;
137         return true;
138     }
139 
140     /**
141      * Set allowance for other address and notify
142      *
143      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
144      *
145      * @param _spender The address authorized to spend
146      * @param _value the max amount they can spend
147      * @param _extraData some extra information to send to the approved contract
148      */
149     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
150         public
151         returns (bool success) {
152         tokenRecipient spender = tokenRecipient(_spender);
153         if (approve(_spender, _value)) {
154             spender.receiveApproval(msg.sender, _value, this, _extraData);
155             return true;
156         }
157     }
158 
159     /**
160      * Destroy tokens
161      *
162      * Remove `_value` tokens from the system irreversibly
163      *
164      * @param _value the amount of money to burn
165      */
166     function burn(uint256 _value) public returns (bool success) {
167         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
168         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender],_value);      // Subtract from the sender
169         RemainingTokenStockForSale = safeSub(RemainingTokenStockForSale,_value);                // Updates RemainingTokenStockForSale
170         Burn(msg.sender, _value);
171         return true;
172     }
173 
174     /**
175      * Destroy tokens from other account
176      *
177      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
178      *
179      * @param _from the address of the sender
180      * @param _value the amount of money to burn
181      */
182     function burnFrom(address _from, uint256 _value) public returns (bool success) {
183         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
184         require(_value <= allowance[_from][msg.sender]);    // Check allowance
185         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
186         allowance[_from][msg.sender]  = safeSub(allowance[_from][msg.sender],_value);             // Subtract from the sender's allowance
187         RemainingTokenStockForSale = safeSub(RemainingTokenStockForSale,_value);                              // Update RemainingTokenStockForSale
188         Burn(_from, _value);
189         return true;
190     }
191 }
192 
193 /******************************************/
194 /*       ADVANCED TOKEN STARTS HERE       */
195 /******************************************/
196 
197 contract MyAdvancedToken is owned, TokenERC20 {
198 
199     uint256 public sellPrice = 0.001 ether;
200     uint256 public buyPrice = 0.001 ether;
201 
202     mapping (address => bool) public frozenAccount;
203 
204     /* This generates a public event on the blockchain that will notify clients */
205     event FrozenFunds(address target, bool frozen);
206 
207     /* Internal transfer, only can be called by this contract */
208     function _transfer(address _from, address _to, uint _value) internal {
209         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
210         require (balanceOf[_from] >= _value);               // Check if the sender has enough
211         require (safeAdd(balanceOf[_to],_value) > balanceOf[_to]); // Check for overflows
212         require(!frozenAccount[_from]);                     // Check if sender is frozen
213         require(!frozenAccount[_to]);                       // Check if recipient is frozen
214         balanceOf[_from] = safeSub(balanceOf[_from],_value);                         // Subtract from the sender
215         balanceOf[_to] = safeAdd(balanceOf[_to], _value);                           // Add the same to the recipient
216         Transfer(_from, _to, _value);
217     }
218 
219     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
220     /// @param target Address to be frozen
221     /// @param freeze either to freeze it or not
222     function freezeAccount(address target, bool freeze) onlyOwner public {
223         frozenAccount[target] = freeze;
224         FrozenFunds(target, freeze);
225     }
226 
227     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
228     /// @param newSellPrice Price the users can sell to the contract
229     /// @param newBuyPrice Price users can buy from the contract
230     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
231         sellPrice = newSellPrice;
232         buyPrice = newBuyPrice;
233     }
234 
235     /// @notice Buy tokens from contract by sending ether
236     function buy() payable public {
237         uint amount = safeDiv(msg.value, buyPrice);               // calculates the amount
238         _transfer(this, msg.sender, amount);              // makes the transfers
239     }
240 
241     /// @notice Sell `amount` tokens to contract
242     /// @param amount amount of tokens to be sold
243     function sell(uint256 amount) public {
244         require(this.balance >= safeMul(amount,sellPrice));      // checks if the contract has enough ether to buy
245         _transfer(msg.sender, this, amount);              // makes the transfers
246         msg.sender.transfer(safeMul(amount, sellPrice));          // sends ether to the seller. It's important to do this last to avoid recursion attacks
247     }
248     //FallBack 
249     function () payable public {
250         
251     }
252 /*
253 Fonction de repli FallBack (fonction sans nom)
254 Un contrat peut avoir exactement une fonction sans nom. Cette fonction ne peut pas avoir d'arguments et ne peut rien retourner. Il est exécuté sur un appel au contrat si aucune des autres fonctions ne correspond à l'identificateur de fonction donné (ou si aucune donnée n'a été fournie).
255 
256 De plus, cette fonction est exécutée chaque fois que le contrat reçoit un Ether (sans données). De plus, afin de recevoir Ether, la fonction de repli doit être marquée payable. Si aucune fonction n'existe, le contrat ne peut pas recevoir Ether via des transactions régulières.
257 
258 Dans le pire des cas, la fonction de repli ne peut compter que sur 2300 gaz disponibles (par exemple lorsque l'envoi ou le transfert est utilisé), ne laissant pas beaucoup de place pour effectuer d'autres opérations sauf la journalisation de base.
259 Les opérations suivantes consomment plus de gaz que l'allocation de gaz 2300:
260 
261  - Ecrire dans le stockage
262  - Créer un contrat
263  - Appel d'une fonction externe qui consomme une grande quantité de gaz
264  - Envoyer Ether
265  
266 Comme toute fonction, la fonction de repli peut exécuter des opérations complexes tant qu'il y a suffisamment de gaz.
267 
268 Remarque
269  Même si la fonction de remplacement ne peut pas avoir d'arguments, vous pouvez toujours utiliser msg.data pour récupérer les données utiles fournies avec l'appel.
270 
271 Attention
272  Les contrats qui reçoivent directement Ether 
273  (sans appel de fonction, c'est-à-dire en utilisant send ou transfer)
274  mais ne définissent pas de fonction de repli jettent une exception,
275  renvoyant l'Ether (ceci était différent avant Solidity v0.4.0).
276  Donc, si vous voulez que votre contrat reçoive Ether, 
277  vous devez implémenter une fonction de repli.
278  
279 
280 Attention
281  Un contrat sans fonction de repli payable peut recevoir Ether 
282  en tant que destinataire d'une transaction coinbase 
283  (récompense de bloc minier) 
284  ou en tant que destination d'un selfdestruct.
285 
286 Un contrat ne peut pas réagir à ces transferts Ether et ne peut donc pas les rejeter.
287 C'est un choix de conception de l'EVM et Solidity ne peut pas contourner ce problème.
288 
289 Cela signifie également que cette valeur peut être supérieure à la somme de certains comptes manuels implémentés dans un contrat (c'est-à-dire avoir un compteur mis à jour dans la fonction de repli).
290 */
291 
292 
293 }