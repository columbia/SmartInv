1 pragma solidity ^0.4.8;
2 
3 /**
4  * Climatecoin extended ERC20 token contract created on February the 17th, 2018 by Rincker Productions in the Netherlands 
5  *
6  * For terms and conditions visit https://climatecoin.eu
7  */
8 
9 contract owned {
10     address public owner;
11 
12     function owned() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         if (msg.sender != owner) revert();
18         _;
19     }
20 
21     function transferOwnership(address newOwner) public onlyOwner {
22         if (newOwner == 0x0) revert();
23         owner = newOwner;
24     }
25 }
26 
27 /**
28  * Overflow aware uint math functions.
29  */
30 contract SafeMath {
31   //internals
32 
33   function safeMul(uint a, uint b) internal pure returns (uint) {
34     uint c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function safeSub(uint a, uint b) internal pure returns (uint) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function safeAdd(uint a, uint b) internal pure returns (uint) {
45     uint c = a + b;
46     assert(c>=a && c>=b);
47     return c;
48   }
49 
50   /*function assert(bool assertion) internal {
51     if (!assertion) revert();
52   }*/
53 }
54 
55 contract Token {
56     /* This is a slight change to the ERC20 base standard.
57     function totalSupply() constant returns (uint256 supply);
58     is replaced with:
59     uint256 public totalSupply;
60     This automatically creates a getter function for the totalSupply.
61     This is moved to the base contract since public getter functions are not
62     currently recognised as an implementation of the matching abstract
63     function by the compiler.
64     */
65     /// total amount of tokens
66     uint256 public totalSupply;
67 
68 
69     /// @param _owner The address from which the balance will be retrieved
70     /// @return The balance
71     function balanceOf(address _owner) public constant returns (uint256 balance);
72 
73     /// @notice send `_value` token to `_to` from `msg.sender`
74     /// @param _to The address of the recipient
75     /// @param _value The amount of token to be transferred
76     /// @return Whether the transfer was successful or not
77     function transfer(address _to, uint256 _value) public returns (bool success);
78 
79     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
80     /// @param _from The address of the sender
81     /// @param _to The address of the recipient
82     /// @param _value The amount of token to be transferred
83     /// @return Whether the transfer was successful or not
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
85 
86     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
87     /// @param _spender The address of the account able to transfer the tokens
88     /// @param _value The amount of tokens to be approved for transfer
89     /// @return Whether the approval was successful or not
90     function approve(address _spender, uint256 _value) public returns (bool success);
91 
92     /// @param _owner The address of the account owning tokens
93     /// @param _spender The address of the account able to transfer the tokens
94     /// @return Amount of remaining tokens allowed to spent
95     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
96 
97     event Transfer(address indexed _from, address indexed _to, uint256 _value);
98     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
99 }
100 
101 contract StandardToken is Token {
102 
103     function transfer(address _to, uint256 _value) public returns (bool success) {
104         //Default assumes totalSupply can't be over max (2^256 - 1).
105         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
106         //Replace the if with this one instead.
107         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
108         //if (balances[msg.sender] >= _value && _value > 0) {
109             balances[msg.sender] -= _value;
110             balances[_to] += _value;
111             Transfer(msg.sender, _to, _value);
112             return true;
113         } else { return false; }
114     }
115 
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117         //same as above. Replace this line with the following if you want to protect against wrapping uints.
118         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
119         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
120             balances[_from] -= _value;
121             balances[_to] += _value;
122             allowed[_from][msg.sender] -= _value;
123             Transfer(_from, _to, _value);
124             return true;
125         } else { return false; }
126     }
127 
128     function balanceOf(address _owner) public constant returns (uint256 balance) {
129         return balances[_owner];
130     }
131 
132     function approve(address _spender, uint256 _value) public returns (bool success) {
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
139       return allowed[_owner][_spender];
140     }
141 
142     mapping (address => uint256) balances;
143     mapping (address => mapping (address => uint256)) allowed;
144 }
145 
146 /* ClimateCoin Contract */
147 contract ClimateCoinToken is owned, SafeMath, StandardToken {
148     string public code = "CLI";                                     // Set the name for display purposes
149     string public name = "ClimateCoin";                                     // Set the name for display purposes
150     string public symbol = "К";                                             // Set the symbol for display purposes U+041A HTML-code: &#1050;
151     address public ClimateCoinAddress = this;                               // Address of the ClimateCoin token
152     uint8 public decimals = 2;                                              // Amount of decimals for display purposes
153     uint256 public totalSupply = 10000000;                                  // Set total supply of ClimateCoins (eight trillion)
154     uint256 public buyPriceEth = 1 finney;                                  // Buy price for ClimateCoins
155     uint256 public sellPriceEth = 1 finney;                                 // Sell price for ClimateCoins
156     uint256 public gasForCLI = 5 finney;                                    // Eth from contract against CLI to pay tx (10 times sellPriceEth)
157     uint256 public CLIForGas = 10;                                          // CLI to contract against eth to pay tx
158     uint256 public gasReserve = 0.2 ether;                                    // Eth amount that remains in the contract for gas and can't be sold
159     uint256 public minBalanceForAccounts = 10 finney;                       // Minimal eth balance of sender and recipient
160     bool public directTradeAllowed = false;                                 // Halt trading CLI by sending to the contract directly
161     
162     /* include mintable */
163     
164     event Mint(address indexed to, uint value);
165     event MintFinished();
166 
167     bool public mintingFinished = false;
168     
169      modifier canMint() {
170     if(mintingFinished) revert();
171     _;
172   }
173 
174   /**
175    * @dev Function to mint tokens
176    * @param _to The address that will recieve the minted tokens.
177    * @param _amount The amount of tokens to mint.
178    * @return A boolean that indicates if the operation was successful.
179    */
180   function mint(address _to, uint _amount) public onlyOwner canMint returns (bool) {
181     totalSupply = safeAdd(totalSupply,_amount);
182     balances[_to] = safeAdd(balances[_to],_amount);
183     Mint(_to, _amount);
184     return true;
185   }
186 
187   /**
188    * @dev Function to stop minting new tokens.
189    * @return True if the operation was successful.
190    */
191   function finishMinting() public onlyOwner returns (bool) {
192     mintingFinished = true;
193     MintFinished();
194     return true;
195   }
196   
197   /* end mintable */
198 
199 
200 /* Initializes contract with initial supply tokens to the creator of the contract */
201     function ClimateCoinToken() public {
202         balances[msg.sender] = totalSupply;                                 // Give the creator all tokens
203     }
204 
205 
206 /* Constructor parameters */
207     function setEtherPrices(uint256 newBuyPriceEth, uint256 newSellPriceEth) onlyOwner public {
208         buyPriceEth = newBuyPriceEth;                                       // Set prices to buy and sell CLI
209         sellPriceEth = newSellPriceEth;
210     }
211     function setGasForCLI(uint newGasAmountInWei) onlyOwner public {
212         gasForCLI = newGasAmountInWei;
213     }
214     function setCLIForGas(uint newCLIAmount) onlyOwner public {
215         CLIForGas = newCLIAmount;
216     }
217     function setGasReserve(uint newGasReserveInWei) onlyOwner public {
218         gasReserve = newGasReserveInWei;
219     }
220     function setMinBalance(uint minimumBalanceInWei) onlyOwner public {
221         minBalanceForAccounts = minimumBalanceInWei;
222     }
223 
224 
225 /* Halts or unhalts direct trades without the sell/buy functions below */
226     function haltDirectTrade() onlyOwner public {
227         directTradeAllowed = false;
228     }
229     function unhaltDirectTrade() onlyOwner public {
230         directTradeAllowed = true;
231     }
232 
233 
234 /* Transfer function extended by check of eth balances and pay transaction costs with CLI if not enough eth */
235     function transfer(address _to, uint256 _value) public returns (bool success) {
236         if (_value < CLIForGas) revert();                                      // Prevents drain and spam
237         if (msg.sender != owner && _to == ClimateCoinAddress && directTradeAllowed) {
238             sellClimateCoinsAgainstEther(_value);                             // Trade ClimateCoins against eth by sending to the token contract
239             return true;
240         }
241 
242         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {               // Check if sender has enough and for overflows
243             balances[msg.sender] = safeSub(balances[msg.sender], _value);   // Subtract CLI from the sender
244 
245             if (msg.sender.balance >= minBalanceForAccounts && _to.balance >= minBalanceForAccounts) {    // Check if sender can pay gas and if recipient could
246                 balances[_to] = safeAdd(balances[_to], _value);             // Add the same amount of CLI to the recipient
247                 Transfer(msg.sender, _to, _value);                          // Notify anyone listening that this transfer took place
248                 return true;
249             } else {
250                 balances[this] = safeAdd(balances[this], CLIForGas);        // Pay CLIForGas to the contract
251                 balances[_to] = safeAdd(balances[_to], safeSub(_value, CLIForGas));  // Recipient balance -CLIForGas
252                 Transfer(msg.sender, _to, safeSub(_value, CLIForGas));      // Notify anyone listening that this transfer took place
253 
254                 if(msg.sender.balance < minBalanceForAccounts) {
255                     if(!msg.sender.send(gasForCLI)) revert();                  // Send eth to sender
256                   }
257                 if(_to.balance < minBalanceForAccounts) {
258                     if(!_to.send(gasForCLI)) revert();                         // Send eth to recipient
259                 }
260             }
261         } else { revert(); }
262     }
263 
264 
265 /* User buys ClimateCoins and pays in Ether */
266     function buyClimateCoinsAgainstEther() public payable returns (uint amount) {
267         if (buyPriceEth == 0 || msg.value < buyPriceEth) revert();             // Avoid dividing 0, sending small amounts and spam
268         amount = msg.value / buyPriceEth;                                   // Calculate the amount of ClimateCoins
269         if (balances[this] < amount) revert();                                 // Check if it has enough to sell
270         balances[msg.sender] = safeAdd(balances[msg.sender], amount);       // Add the amount to buyer's balance
271         balances[this] = safeSub(balances[this], amount);                   // Subtract amount from ClimateCoin balance
272         Transfer(this, msg.sender, amount);                                 // Execute an event reflecting the change
273         return amount;
274     }
275 
276 
277 /* User sells ClimateCoins and gets Ether */
278     function sellClimateCoinsAgainstEther(uint256 amount) public returns (uint revenue) {
279         if (sellPriceEth == 0 || amount < CLIForGas) revert();                // Avoid selling and spam
280         if (balances[msg.sender] < amount) revert();                           // Check if the sender has enough to sell
281         revenue = safeMul(amount, sellPriceEth);                            // Revenue = eth that will be send to the user
282         if (safeSub(this.balance, revenue) < gasReserve) revert();             // Keep min amount of eth in contract to provide gas for transactions
283         if (!msg.sender.send(revenue)) {                                    // Send ether to the seller. It's important
284             revert();                                                          // To do this last to avoid recursion attacks
285         } else {
286             balances[this] = safeAdd(balances[this], amount);               // Add the amount to ClimateCoin balance
287             balances[msg.sender] = safeSub(balances[msg.sender], amount);   // Subtract the amount from seller's balance
288             Transfer(this, msg.sender, revenue);                            // Execute an event reflecting on the change
289             return revenue;                                                 // End function and returns
290         }
291     }
292 
293 
294 /* refund to owner */
295     function refundToOwner (uint256 amountOfEth, uint256 cli) public onlyOwner {
296         uint256 eth = safeMul(amountOfEth, 1 ether);
297         if (!msg.sender.send(eth)) {                                        // Send ether to the owner. It's important
298             revert();                                                          // To do this last to avoid recursion attacks
299         } else {
300             Transfer(this, msg.sender, eth);                                // Execute an event reflecting on the change
301         }
302         if (balances[this] < cli) revert();                                    // Check if it has enough to sell
303         balances[msg.sender] = safeAdd(balances[msg.sender], cli);          // Add the amount to buyer's balance
304         balances[this] = safeSub(balances[this], cli);                      // Subtract amount from seller's balance
305         Transfer(this, msg.sender, cli);                                    // Execute an event reflecting the change
306     }
307 
308 /* This unnamed function is called whenever someone tries to send ether to it and possibly sells ClimateCoins */
309     function() public payable {
310         if (msg.sender != owner) {
311             if (!directTradeAllowed) revert();
312             buyClimateCoinsAgainstEther();                                    // Allow direct trades by sending eth to the contract
313         }
314     }
315 }