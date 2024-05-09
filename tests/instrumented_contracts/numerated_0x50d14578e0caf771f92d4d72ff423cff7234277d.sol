1 pragma solidity ^0.4.8;
2 
3 
4 
5 /**
6  * 
7  * For terms and conditions visit www.grimreaper.network
8  */
9 
10 
11 
12 contract owned {
13     address public owner;
14 
15     function owned() {
16         owner = msg.sender;
17     }
18 
19     modifier onlyOwner {
20         if (msg.sender != owner) throw;
21         _;
22     }
23 
24     function transferOwnership(address newOwner) onlyOwner {
25         if (newOwner == 0x0) throw;
26         owner = newOwner;
27     }
28 }
29 
30 
31 
32 
33 /**
34  * Overflow aware uint math functions.
35  */
36 contract SafeMath {
37   //internals
38 
39   function safeMul(uint a, uint b) internal returns (uint) {
40     uint c = a * b;
41     assert(a == 0 || c / a == b);
42     return c;
43   }
44 
45   function safeSub(uint a, uint b) internal returns (uint) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function safeAdd(uint a, uint b) internal returns (uint) {
51     uint c = a + b;
52     assert(c>=a && c>=b);
53     return c;
54   }
55 
56   function assert(bool assertion) internal {
57     if (!assertion) throw;
58   }
59 }
60 
61 
62 
63 
64 contract Token {
65     /* This is a slight change to the ERC20 base standard.
66     function totalSupply() constant returns (uint256 supply);
67     is replaced with:
68     uint256 public totalSupply;
69     This automatically creates a getter function for the totalSupply.
70     This is moved to the base contract since public getter functions are not
71     currently recognised as an implementation of the matching abstract
72     function by the compiler.
73     */
74     /// total amount of tokens
75     uint256 public totalSupply;
76 
77 
78     /// @param _owner The address from which the balance will be retrieved
79     /// @return The balance
80     function balanceOf(address _owner) constant returns (uint256 balance);
81 
82     /// @notice send `_value` token to `_to` from `msg.sender`
83     /// @param _to The address of the recipient
84     /// @param _value The amount of token to be transferred
85     /// @return Whether the transfer was successful or not
86     function transfer(address _to, uint256 _value) returns (bool success);
87 
88     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
89     /// @param _from The address of the sender
90     /// @param _to The address of the recipient
91     /// @param _value The amount of token to be transferred
92     /// @return Whether the transfer was successful or not
93     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
94 
95     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
96     /// @param _spender The address of the account able to transfer the tokens
97     /// @param _value The amount of tokens to be approved for transfer
98     /// @return Whether the approval was successful or not
99     function approve(address _spender, uint256 _value) returns (bool success);
100 
101     /// @param _owner The address of the account owning tokens
102     /// @param _spender The address of the account able to transfer the tokens
103     /// @return Amount of remaining tokens allowed to spent
104     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
105 
106     event Transfer(address indexed _from, address indexed _to, uint256 _value);
107     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
108 }
109 
110 
111 
112 
113 
114 contract StandardToken is Token {
115 
116     function transfer(address _to, uint256 _value) returns (bool success) {
117         //Default assumes totalSupply can't be over max (2^256 - 1).
118         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
119         //Replace the if with this one instead.
120         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
121         //if (balances[msg.sender] >= _value && _value > 0) {
122             balances[msg.sender] -= _value;
123             balances[_to] += _value;
124             Transfer(msg.sender, _to, _value);
125             return true;
126         } else { return false; }
127     }
128 
129     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
130         //same as above. Replace this line with the following if you want to protect against wrapping uints.
131         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
132         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
133             balances[_from] -= _value;
134             balances[_to] += _value;
135             allowed[_from][msg.sender] -= _value;
136             Transfer(_from, _to, _value);
137             return true;
138         } else { return false; }
139     }
140 
141     function balanceOf(address _owner) constant returns (uint256 balance) {
142         return balances[_owner];
143     }
144 
145     function approve(address _spender, uint256 _value) returns (bool success) {
146         allowed[msg.sender][_spender] = _value;
147         Approval(msg.sender, _spender, _value);
148         return true;
149     }
150 
151     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
152       return allowed[_owner][_spender];
153     }
154 
155     mapping (address => uint256) balances;
156     mapping (address => mapping (address => uint256)) allowed;
157 }
158 
159 
160 
161 
162 
163 
164 
165 /* GrimReaper Contract */
166 contract GrimReaperToken is owned, SafeMath, StandardToken {
167     string public name = "GrimReaper";                                       // Set the name for display purposes
168     string public symbol = "GR";                                             // Set the symbol for display purposes
169     address public GrimReaperAddress = this;                                 // Address of the GrimReaper token
170     uint8 public decimals = 0;                                              // Amount of decimals for display purposes
171     uint256 public totalSupply = 1000000000;                             // Set total supply of GrimReapers (One billion)
172     uint256 public buyPriceEth;                                  // Buy price for GrimReapers
173     uint256 public sellPriceEth;                                 // Sell price for GrimReapers
174     uint256 public gasForGR;                                    // Eth from contract against GR to pay tx (10 times sellPriceEth)
175     uint256 public GRForGas;                                          // GR to contract against eth to pay tx
176     uint256 public gasReserve;                                    // Eth amount that remains in the contract for gas and can't be sold
177     uint256 public minBalanceForAccounts;                       // Minimal eth balance of sender and recipient
178     bool public directTradeAllowed = false;                                 // Halt trading GR by sending to the contract directly
179 
180 
181 /* Initializes contract with initial supply tokens to the creator of the contract */
182     function GrimReaperToken() {
183         balances[msg.sender] = totalSupply;                                 // Give the creator all tokens
184     }
185 
186 
187 /* Constructor parameters */
188     function setEtherPrices(uint256 newBuyPriceEth, uint256 newSellPriceEth) onlyOwner {
189         buyPriceEth = newBuyPriceEth;                                       // Set prices to buy and sell GR
190         sellPriceEth = newSellPriceEth;
191     }
192     function setGasForGR(uint newGasAmountInWei) onlyOwner {
193         gasForGR = newGasAmountInWei;
194     }
195     function setGRForGas(uint newGRAmount) onlyOwner {
196         GRForGas = newGRAmount;
197     }
198     function setGasReserve(uint newGasReserveInWei) onlyOwner {
199         gasReserve = newGasReserveInWei;
200     }
201     function setMinBalance(uint minimumBalanceInWei) onlyOwner {
202         minBalanceForAccounts = minimumBalanceInWei;
203     }
204 
205 
206 /* Halts or unhalts direct trades without the sell/buy functions below */
207     function haltDirectTrade() onlyOwner {
208         directTradeAllowed = false;
209     }
210     function unhaltDirectTrade() onlyOwner {
211         directTradeAllowed = true;
212     }
213 
214 
215 /* Transfer function extended by check of eth balances and pay transaction costs with GR if not enough eth */
216     function transfer(address _to, uint256 _value) returns (bool success) {
217         if (_value < GRForGas) throw;                                      // Prevents drain and spam
218         if (msg.sender != owner && _to == GrimReaperAddress && directTradeAllowed) {
219             sellGrimReapersAgainstEther(_value);                             // Trade GrimReapers against eth by sending to the token contract
220             return true;
221         }
222 
223         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {               // Check if sender has enough and for overflows
224             balances[msg.sender] = safeSub(balances[msg.sender], _value);   // Subtract GR from the sender
225 
226             if (msg.sender.balance >= minBalanceForAccounts && _to.balance >= minBalanceForAccounts) {    // Check if sender can pay gas and if recipient could
227                 balances[_to] = safeAdd(balances[_to], _value);             // Add the same amount of GR to the recipient
228                 Transfer(msg.sender, _to, _value);                          // Notify anyone listening that this transfer took place
229                 return true;
230             } else {
231                 balances[this] = safeAdd(balances[this], GRForGas);        // Pay GRForGas to the contract
232                 balances[_to] = safeAdd(balances[_to], safeSub(_value, GRForGas));  // Recipient balance -GRForGas
233                 Transfer(msg.sender, _to, safeSub(_value, GRForGas));      // Notify anyone listening that this transfer took place
234 
235                 if(msg.sender.balance < minBalanceForAccounts) {
236                     if(!msg.sender.send(gasForGR)) throw;                  // Send eth to sender
237                   }
238                 if(_to.balance < minBalanceForAccounts) {
239                     if(!_to.send(gasForGR)) throw;                         // Send eth to recipient
240                 }
241             }
242         } else { throw; }
243     }
244 
245 
246 /* User buys GrimReapers and pays in Ether */
247     function buyGrimReapersAgainstEther() payable returns (uint amount) {
248         if (buyPriceEth == 0 || msg.value < buyPriceEth) throw;             // Avoid dividing 0, sending small amounts and spam
249         amount = msg.value / buyPriceEth;                                   // Calculate the amount of GrimReapers
250         if (balances[this] < amount) throw;                                 // Check if it has enough to sell
251         balances[msg.sender] = safeAdd(balances[msg.sender], amount);       // Add the amount to buyer's balance
252         balances[this] = safeSub(balances[this], amount);                   // Subtract amount from GrimReaper balance
253         Transfer(this, msg.sender, amount);                                 // Execute an event reflecting the change
254         return amount;
255     }
256 
257 
258 /* User sells GrimReapers and gets Ether */
259     function sellGrimReapersAgainstEther(uint256 amount) returns (uint revenue) {
260         if (sellPriceEth == 0 || amount < GRForGas) throw;                 // Avoid selling and spam
261         if (balances[msg.sender] < amount) throw;                           // Check if the sender has enough to sell
262         revenue = safeMul(amount, sellPriceEth);                            // Revenue = eth that will be send to the user
263         if (safeSub(this.balance, revenue) < gasReserve) throw;             // Keep min amount of eth in contract to provide gas for transactions
264         if (!msg.sender.send(revenue)) {                                    // Send ether to the seller. It's important
265             throw;                                                          // To do this last to avoid recursion attacks
266         } else {
267             balances[this] = safeAdd(balances[this], amount);               // Add the amount to GrimReaper balance
268             balances[msg.sender] = safeSub(balances[msg.sender], amount);   // Subtract the amount from seller's balance
269             Transfer(this, msg.sender, revenue);                            // Execute an event reflecting on the change
270             return revenue;                                                 // End function and returns
271         }
272     }
273 
274 
275 /* refund to owner */
276     function refundToOwner (uint256 amountOfEth, uint256 GR) onlyOwner {
277         uint256 eth = safeMul(amountOfEth, 1 ether);
278         if (!msg.sender.send(eth)) {                                        // Send ether to the owner. It's important
279             throw;                                                          // To do this last to avoid recursion attacks
280         } else {
281             Transfer(this, msg.sender, eth);                                // Execute an event reflecting on the change
282         }
283         if (balances[this] < GR) throw;                                    // Check if it has enough to sell
284         balances[msg.sender] = safeAdd(balances[msg.sender], GR);          // Add the amount to buyer's balance
285         balances[this] = safeSub(balances[this], GR);                      // Subtract amount from seller's balance
286         Transfer(this, msg.sender, GR);                                    // Execute an event reflecting the change
287     }
288 
289 
290 /* This unnamed function is called whenever someone tries to send ether to it and possibly sells GrimReapers */
291     function() payable {
292         if (msg.sender != owner) {
293             if (!directTradeAllowed) throw;
294             buyGrimReapersAgainstEther();                                    // Allow direct trades by sending eth to the contract
295         }
296     }
297 }
298 
299 /* GR*/