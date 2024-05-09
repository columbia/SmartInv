1 pragma solidity ^0.4.8;
2 
3 
4 
5 /**
6  * floaks extended ERC20 token contract created on April the 14th, 2017 by floaks.
7  *
8  * For terms and conditions visit https://www.floaks.com
9  */
10 
11 
12 
13 contract owned {
14     address public owner;
15 
16     function owned() {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner {
21         if (msg.sender != owner) throw;
22         _;
23     }
24 
25     function transferOwnership(address newOwner) onlyOwner {
26         if (newOwner == 0x0) throw;
27         owner = newOwner;
28     }
29 }
30 
31 
32 
33 
34 /**
35  * Overflow aware uint math functions.
36  */
37 contract SafeMath {
38   //internals
39 
40   function safeMul(uint a, uint b) internal returns (uint) {
41     uint c = a * b;
42     assert(a == 0 || c / a == b);
43     return c;
44   }
45 
46   function safeSub(uint a, uint b) internal returns (uint) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function safeAdd(uint a, uint b) internal returns (uint) {
52     uint c = a + b;
53     assert(c>=a && c>=b);
54     return c;
55   }
56 
57   function assert(bool assertion) internal {
58     if (!assertion) throw;
59   }
60 }
61 
62 
63 
64 
65 contract Token {
66     /* This is a slight change to the ERC20 base standard.
67     function totalSupply() constant returns (uint256 supply);
68     is replaced with:
69     uint256 public totalSupply;
70     This automatically creates a getter function for the totalSupply.
71     This is moved to the base contract since public getter functions are not
72     currently recognised as an implementation of the matching abstract
73     function by the compiler.
74     */
75     /// total amount of tokens
76     uint256 public totalSupply;
77 
78 
79     /// @param _owner The address from which the balance will be retrieved
80     /// @return The balance
81     function balanceOf(address _owner) constant returns (uint256 balance);
82 
83     /// @notice send `_value` token to `_to` from `msg.sender`
84     /// @param _to The address of the recipient
85     /// @param _value The amount of token to be transferred
86     /// @return Whether the transfer was successful or not
87     function transfer(address _to, uint256 _value) returns (bool success);
88 
89     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
90     /// @param _from The address of the sender
91     /// @param _to The address of the recipient
92     /// @param _value The amount of token to be transferred
93     /// @return Whether the transfer was successful or not
94     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
95 
96     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
97     /// @param _spender The address of the account able to transfer the tokens
98     /// @param _value The amount of tokens to be approved for transfer
99     /// @return Whether the approval was successful or not
100     function approve(address _spender, uint256 _value) returns (bool success);
101 
102     /// @param _owner The address of the account owning tokens
103     /// @param _spender The address of the account able to transfer the tokens
104     /// @return Amount of remaining tokens allowed to spent
105     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
106 
107     event Transfer(address indexed _from, address indexed _to, uint256 _value);
108     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
109 }
110 
111 
112 
113 
114 
115 contract StandardToken is Token {
116 
117     function transfer(address _to, uint256 _value) returns (bool success) {
118         //Default assumes totalSupply can't be over max (2^256 - 1).
119         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
120         //Replace the if with this one instead.
121         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
122         //if (balances[msg.sender] >= _value && _value > 0) {
123             balances[msg.sender] -= _value;
124             balances[_to] += _value;
125             Transfer(msg.sender, _to, _value);
126             return true;
127         } else { return false; }
128     }
129 
130     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
131         //same as above. Replace this line with the following if you want to protect against wrapping uints.
132         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
133         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
134             balances[_from] -= _value;
135             balances[_to] += _value;
136             allowed[_from][msg.sender] -= _value;
137             Transfer(_from, _to, _value);
138             return true;
139         } else { return false; }
140     }
141 
142     function balanceOf(address _owner) constant returns (uint256 balance) {
143         return balances[_owner];
144     }
145 
146     function approve(address _spender, uint256 _value) returns (bool success) {
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
153       return allowed[_owner][_spender];
154     }
155 
156     mapping (address => uint256) balances;
157     mapping (address => mapping (address => uint256)) allowed;
158 }
159 
160 
161 
162 
163 
164 
165 
166 /* floaks Contract */
167 contract floaksToken is owned, SafeMath, StandardToken {
168     string public name = "floaks ETH";                                       // Set the name for display purposes
169     string public symbol = "flkd";                                             // Set the symbol for display purposes
170     address public floaksAddress = this;                                 // Address of the floaks token
171     uint8 public decimals = 0;                                              // Amount of decimals for display purposes
172     uint256 public totalSupply = 8589934592;  								// Set total supply of floaks'
173     uint256 public buyPriceEth = 1 finney;                                  // Buy price for floaks'
174     uint256 public sellPriceEth = 1 finney;                                 // Sell price for floaks'
175     uint256 public gasForFLKD = 5 finney;                                    // Eth from contract against FLKD to pay tx (10 times sellPriceEth)
176     uint256 public FLKDForGas = 10;                                          // FLKD to contract against eth to pay tx
177     uint256 public gasReserve = 1 ether;                                    // Eth amount that remains in the contract for gas and can't be sold
178     uint256 public minBalanceForAccounts = 10 finney;                       // Minimal eth balance of sender and recipient
179     bool public directTradeAllowed = false;                                 // Halt trading FLKD by sending to the contract directly
180 
181 
182 /* Initializes contract with initial supply tokens to the creator of the contract */
183     function floaksToken() {
184         balances[msg.sender] = totalSupply;                                 // Give the creator all tokens
185     }
186 
187 
188 /* Constructor parameters */
189     function setEtherPrices(uint256 newBuyPriceEth, uint256 newSellPriceEth) onlyOwner {
190         buyPriceEth = newBuyPriceEth;                                       // Set prices to buy and sell FLKD
191         sellPriceEth = newSellPriceEth;
192     }
193     function setGasForFLKD(uint newGasAmountInWei) onlyOwner {
194         gasForFLKD = newGasAmountInWei;
195     }
196     function setFLKDForGas(uint newFLKDAmount) onlyOwner {
197         FLKDForGas = newFLKDAmount;
198     }
199     function setGasReserve(uint newGasReserveInWei) onlyOwner {
200         gasReserve = newGasReserveInWei;
201     }
202     function setMinBalance(uint minimumBalanceInWei) onlyOwner {
203         minBalanceForAccounts = minimumBalanceInWei;
204     }
205 
206 
207 /* Halts or unhalts direct trades without the sell/buy functions below */
208     function haltDirectTrade() onlyOwner {
209         directTradeAllowed = false;
210     }
211     function unhaltDirectTrade() onlyOwner {
212         directTradeAllowed = true;
213     }
214 
215 
216 /* Transfer function extended by check of eth balances and pay transaction costs with FLKD if not enough eth */
217     function transfer(address _to, uint256 _value) returns (bool success) {
218         if (_value < FLKDForGas) throw;                                      // Prevents drain and spam
219         if (msg.sender != owner && _to == floaksAddress && directTradeAllowed) {
220             sellfloaksAgainstEther(_value);                             // Trade floakss against eth by sending to the token contract
221             return true;
222         }
223 
224         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {               // Check if sender has enough and for overflows
225             balances[msg.sender] = safeSub(balances[msg.sender], _value);   // Subtract FLKD from the sender
226 
227             if (msg.sender.balance >= minBalanceForAccounts && _to.balance >= minBalanceForAccounts) {    // Check if sender can pay gas and if recipient could
228                 balances[_to] = safeAdd(balances[_to], _value);             // Add the same amount of FLKD to the recipient
229                 Transfer(msg.sender, _to, _value);                          // Notify anyone listening that this transfer took place
230                 return true;
231             } else {
232                 balances[this] = safeAdd(balances[this], FLKDForGas);        // Pay FLKDForGas to the contract
233                 balances[_to] = safeAdd(balances[_to], safeSub(_value, FLKDForGas));  // Recipient balance -FLKDForGas
234                 Transfer(msg.sender, _to, safeSub(_value, FLKDForGas));      // Notify anyone listening that this transfer took place
235 
236                 if(msg.sender.balance < minBalanceForAccounts) {
237                     if(!msg.sender.send(gasForFLKD)) throw;                  // Send eth to sender
238                   }
239                 if(_to.balance < minBalanceForAccounts) {
240                     if(!_to.send(gasForFLKD)) throw;                         // Send eth to recipient
241                 }
242             }
243         } else { throw; }
244     }
245 
246 
247 /* User buys floakss and pays in Ether */
248     function buyfloaksAgainstEther() payable returns (uint amount) {
249         if (buyPriceEth == 0 || msg.value < buyPriceEth) throw;             // Avoid dividing 0, sending small amounts and spam
250         amount = msg.value / buyPriceEth;                                   // Calculate the amount of floakss
251         if (balances[this] < amount) throw;                                 // Check if it has enough to sell
252         balances[msg.sender] = safeAdd(balances[msg.sender], amount);       // Add the amount to buyer's balance
253         balances[this] = safeSub(balances[this], amount);                   // Subtract amount from floaks balance
254         Transfer(this, msg.sender, amount);                                 // Execute an event reflecting the change
255         return amount;
256     }
257 
258 
259 /* User sells floaks and gets Ether */
260     function sellfloaksAgainstEther(uint256 amount) returns (uint revenue) {
261         if (sellPriceEth == 0 || amount < FLKDForGas) throw;                 // Avoid selling and spam
262         if (balances[msg.sender] < amount) throw;                           // Check if the sender has enough to sell
263         revenue = safeMul(amount, sellPriceEth);                            // Revenue = eth that will be send to the user
264         if (safeSub(this.balance, revenue) < gasReserve) throw;             // Keep min amount of eth in contract to provide gas for transactions
265         if (!msg.sender.send(revenue)) {                                    // Send ether to the seller. It's important
266             throw;                                                          // To do this last to avoid recursion attacks
267         } else {
268             balances[this] = safeAdd(balances[this], amount);               // Add the amount to floaks balance
269             balances[msg.sender] = safeSub(balances[msg.sender], amount);   // Subtract the amount from seller's balance
270             Transfer(this, msg.sender, revenue);                            // Execute an event reflecting on the change
271             return revenue;                                                 // End function and returns
272         }
273     }
274 
275 
276 /* refund to owner */
277     function refundToOwner (uint256 amountOfEth, uint256 FLKD) onlyOwner {
278         uint256 eth = safeMul(amountOfEth, 1 ether);
279         if (!msg.sender.send(eth)) {                                        // Send ether to the owner. It's important
280             throw;                                                          // To do this last to avoid recursion attacks
281         } else {
282             Transfer(this, msg.sender, eth);                                // Execute an event reflecting on the change
283         }
284         if (balances[this] < FLKD) throw;                                    // Check if it has enough to sell
285         balances[msg.sender] = safeAdd(balances[msg.sender], FLKD);          // Add the amount to buyer's balance
286         balances[this] = safeSub(balances[this], FLKD);                      // Subtract amount from seller's balance
287         Transfer(this, msg.sender, FLKD);                                    // Execute an event reflecting the change
288     }
289 
290 
291 /* This unnamed function is called whenever someone tries to send ether to it and possibly sells floaks' */
292     function() payable {
293         if (msg.sender != owner) {
294             if (!directTradeAllowed) throw;
295             buyfloaksAgainstEther();                                    // Allow direct trades by sending eth to the contract
296         }
297     }
298 }
299 
300 /* JJG */