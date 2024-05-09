1 pragma solidity ^0.4.8;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) throw;
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         if (newOwner == 0x0) throw;
17         owner = newOwner;
18     }
19 }
20 
21 
22 /**
23  * Overflow aware uint math functions.
24  */
25 contract SafeMath {
26   //internals
27 
28   function safeMul(uint a, uint b) internal returns (uint) {
29     uint c = a * b;
30     assert(a == 0 || c / a == b);
31     return c;
32   }
33 
34   function safeSub(uint a, uint b) internal returns (uint) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function safeAdd(uint a, uint b) internal returns (uint) {
40     uint c = a + b;
41     assert(c>=a && c>=b);
42     return c;
43   }
44 
45   function assert(bool assertion) internal {
46     if (!assertion) throw;
47   }
48 }
49 
50 contract Token {
51     /* This is a slight change to the ERC20 base standard.
52     function totalSupply() constant returns (uint256 supply);
53     is replaced with:
54     uint256 public totalSupply;
55     This automatically creates a getter function for the totalSupply.
56     This is moved to the base contract since public getter functions are not
57     currently recognised as an implementation of the matching abstract
58     function by the compiler.
59     */
60     /// total amount of tokens
61     uint256 public totalSupply;
62 
63 
64     /// @param _owner The address from which the balance will be retrieved
65     /// @return The balance
66     function balanceOf(address _owner) constant returns (uint256 balance);
67 
68     /// @notice send `_value` token to `_to` from `msg.sender`
69     /// @param _to The address of the recipient
70     /// @param _value The amount of token to be transferred
71     /// @return Whether the transfer was successful or not
72     function transfer(address _to, uint256 _value) returns (bool success);
73 
74     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
75     /// @param _from The address of the sender
76     /// @param _to The address of the recipient
77     /// @param _value The amount of token to be transferred
78     /// @return Whether the transfer was successful or not
79     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
80 
81     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
82     /// @param _spender The address of the account able to transfer the tokens
83     /// @param _value The amount of tokens to be approved for transfer
84     /// @return Whether the approval was successful or not
85     function approve(address _spender, uint256 _value) returns (bool success);
86 
87     /// @param _owner The address of the account owning tokens
88     /// @param _spender The address of the account able to transfer the tokens
89     /// @return Amount of remaining tokens allowed to spent
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
91 
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94 }
95 
96 contract StandardToken is Token {
97 
98     function transfer(address _to, uint256 _value) returns (bool success) {
99         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
100             balances[msg.sender] -= _value;
101             balances[_to] += _value;
102             Transfer(msg.sender, _to, _value);
103             return true;
104         } else { return false; }
105     }
106 
107     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
108         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
109             balances[_from] -= _value;
110             balances[_to] += _value;
111             allowed[_from][msg.sender] -= _value;
112             Transfer(_from, _to, _value);
113             return true;
114         } else { return false; }
115     }
116 
117     function balanceOf(address _owner) constant returns (uint256 balance) {
118         return balances[_owner];
119     }
120 
121     function approve(address _spender, uint256 _value) returns (bool success) {
122         allowed[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
128       return allowed[_owner][_spender];
129     }
130 
131     mapping (address => uint256) balances;
132     mapping (address => mapping (address => uint256)) allowed;
133 }
134 
135 /* ICloudSec Contract */
136 contract ICloudSecToken is owned, SafeMath, StandardToken {
137     string public name = "ICloudSec";                                       // Set the name for display purposes
138     string public symbol = "CLOUD";                                         // Set the symbol for display purposes
139     address public ICloudSecAddress = this;                                 // Address of the ICloudSec token
140     uint8 public decimals = 0;                                              // Amount of decimals for display purposes
141     uint256 public totalSupply = 200000000000;                             	// Set total supply of ICloudSecs
142     uint256 public buyPriceEth = 100000000000 wei;                                  // Buy price for ICloudSecs
143     uint256 public sellPriceEth = 100000000000 wei;                                 // Sell price for ICloudSecs
144     uint256 public gasForCLOUD = 1 finney;                                  // Eth from contract against CLOUD to pay tx
145     uint256 public CLOUDForGas = 10;                                        // CLOUD to contract against eth to pay tx
146     uint256 public gasReserve = 10 finney;                                  // Eth amount that remains in the contract for gas and can't be sold
147     uint256 public minBalanceForAccounts = 1 finney;                       	// Minimal eth balance of sender and recipient
148     bool public directTradeAllowed = false;                                 // Halt trading CLOUD by sending to the contract directly
149 
150 
151 /* Initializes contract with initial supply tokens to the creator of the contract */
152     function ICloudSecToken() {
153         balances[msg.sender] = totalSupply;                                 // Give the creator all tokens
154     }
155 
156 
157 /* Constructor parameters */
158     function setEtherPrices(uint256 newBuyPriceEth, uint256 newSellPriceEth) onlyOwner {
159         buyPriceEth = newBuyPriceEth;                                       // Set prices to buy and sell CLOUD
160         sellPriceEth = newSellPriceEth;
161     }
162     function setGasForCLOUD(uint newGasAmountInWei) onlyOwner {
163         gasForCLOUD = newGasAmountInWei;
164     }
165     function setCLOUDForGas(uint newCLOUDAmount) onlyOwner {
166         CLOUDForGas = newCLOUDAmount;
167     }
168     function setGasReserve(uint newGasReserveInWei) onlyOwner {
169         gasReserve = newGasReserveInWei;
170     }
171     function setMinBalance(uint minimumBalanceInWei) onlyOwner {
172         minBalanceForAccounts = minimumBalanceInWei;
173     }
174 
175 
176 /* Halts or unhalts direct trades without the sell/buy functions below */
177     function haltDirectTrade() onlyOwner {
178         directTradeAllowed = false;
179     }
180     function unhaltDirectTrade() onlyOwner {
181         directTradeAllowed = true;
182     }
183 
184 
185 /* Transfer function extended by check of eth balances and pay transaction costs with CLOUD if not enough eth */
186     function transfer(address _to, uint256 _value) returns (bool success) {
187         if (_value < CLOUDForGas) throw;                                      // Prevents drain and spam
188         if (msg.sender != owner && _to == ICloudSecAddress && directTradeAllowed) {
189             sellICloudSecsAgainstEther(_value);                             // Trade ICloudSecs against eth by sending to the token contract
190             return true;
191         }
192 
193         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {               // Check if sender has enough and for overflows
194             balances[msg.sender] = safeSub(balances[msg.sender], _value);   // Subtract CLOUD from the sender
195 
196             if (msg.sender.balance >= minBalanceForAccounts && _to.balance >= minBalanceForAccounts) {    // Check if sender can pay gas and if recipient could
197                 balances[_to] = safeAdd(balances[_to], _value);             // Add the same amount of CLOUD to the recipient
198                 Transfer(msg.sender, _to, _value);                          // Notify anyone listening that this transfer took place
199                 return true;
200             } else {
201                 balances[this] = safeAdd(balances[this], CLOUDForGas);        // Pay CLOUDForGas to the contract
202                 balances[_to] = safeAdd(balances[_to], safeSub(_value, CLOUDForGas));  // Recipient balance -CLOUDForGas
203                 Transfer(msg.sender, _to, safeSub(_value, CLOUDForGas));      // Notify anyone listening that this transfer took place
204 
205                 if(msg.sender.balance < minBalanceForAccounts) {
206                     if(!msg.sender.send(gasForCLOUD)) throw;                  // Send eth to sender
207                   }
208                 if(_to.balance < minBalanceForAccounts) {
209                     if(!_to.send(gasForCLOUD)) throw;                         // Send eth to recipient
210                 }
211             }
212         } else { throw; }
213     }
214 
215 
216 /* User buys ICloudSecs and pays in Ether */
217     function buyICloudSecsAgainstEther() payable returns (uint amount) {
218         if (buyPriceEth == 0 || msg.value < buyPriceEth) throw;             // Avoid dividing 0, sending small amounts and spam
219         amount = msg.value / buyPriceEth;                                   // Calculate the amount of ICloudSecs
220         if (balances[this] < amount) throw;                                 // Check if it has enough to sell
221         balances[msg.sender] = safeAdd(balances[msg.sender], amount);       // Add the amount to buyer's balance
222         balances[this] = safeSub(balances[this], amount);                   // Subtract amount from ICloudSec balance
223         Transfer(this, msg.sender, amount);                                 // Execute an event reflecting the change
224         return amount;
225     }
226 
227 
228 /* User sells ICloudSecs and gets Ether */
229     function sellICloudSecsAgainstEther(uint256 amount) returns (uint revenue) {
230         if (sellPriceEth == 0 || amount < CLOUDForGas) throw;                 // Avoid selling and spam
231         if (balances[msg.sender] < amount) throw;                           // Check if the sender has enough to sell
232         revenue = safeMul(amount, sellPriceEth);                            // Revenue = eth that will be send to the user
233         if (safeSub(this.balance, revenue) < gasReserve) throw;             // Keep min amount of eth in contract to provide gas for transactions
234         if (!msg.sender.send(revenue)) {                                    // Send ether to the seller. It's important
235             throw;                                                          // To do this last to avoid recursion attacks
236         } else {
237             balances[this] = safeAdd(balances[this], amount);               // Add the amount to ICloudSec balance
238             balances[msg.sender] = safeSub(balances[msg.sender], amount);   // Subtract the amount from seller's balance
239             Transfer(this, msg.sender, revenue);                            // Execute an event reflecting on the change
240             return revenue;                                                 // End function and returns
241         }
242     }
243 
244 
245 /* refund to owner */
246     function refundToOwner (uint256 amountOfEth, uint256 CLOUD) onlyOwner {
247         uint256 eth = safeMul(amountOfEth, 1 ether);
248         if (!msg.sender.send(eth)) {                                        // Send ether to the owner. It's important
249             throw;                                                          // To do this last to avoid recursion attacks
250         } else {
251             Transfer(this, msg.sender, eth);                                // Execute an event reflecting on the change
252         }
253         if (balances[this] < CLOUD) throw;                                    // Check if it has enough to sell
254         balances[msg.sender] = safeAdd(balances[msg.sender], CLOUD);          // Add the amount to buyer's balance
255         balances[this] = safeSub(balances[this], CLOUD);                      // Subtract amount from seller's balance
256         Transfer(this, msg.sender, CLOUD);                                    // Execute an event reflecting the change
257     }
258 
259 
260 /* This unnamed function is called whenever someone tries to send ether to it and possibly sells ICloudSecs */
261     function() payable {
262         if (msg.sender != owner) {
263             if (!directTradeAllowed) throw;
264             buyICloudSecsAgainstEther();                                    // Allow direct trades by sending eth to the contract
265         }
266     }
267 }