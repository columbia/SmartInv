1 pragma solidity ^0.4.18;
2 
3 // SATURN strategic exchange program
4 
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract ERC223 {
48   uint public totalSupply;
49   function balanceOf(address who) constant returns (uint);
50 
51   function name() constant returns (string _name);
52   function symbol() constant returns (string _symbol);
53   function decimals() constant returns (uint8 _decimals);
54   function totalSupply() constant returns (uint256 _supply);
55 
56   function transfer(address to, uint value) returns (bool ok);
57   function transfer(address to, uint value, bytes data) returns (bool ok);
58   event Transfer(address indexed _from, address indexed _to, uint256 _value);
59   event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
60 }
61 
62 contract ContractReceiver {
63   function tokenFallback(address _from, uint _value, bytes _data);
64 }
65 
66 contract ERC223Token is ERC223 {
67   using SafeMath for uint;
68 
69   mapping(address => uint) balances;
70 
71   string public name;
72   string public symbol;
73   uint8 public decimals;
74   uint256 public totalSupply;
75 
76 
77   // Function to access name of token .
78   function name() constant returns (string _name) {
79       return name;
80   }
81   // Function to access symbol of token .
82   function symbol() constant returns (string _symbol) {
83       return symbol;
84   }
85   // Function to access decimals of token .
86   function decimals() constant returns (uint8 _decimals) {
87       return decimals;
88   }
89   // Function to access total supply of tokens .
90   function totalSupply() constant returns (uint256 _totalSupply) {
91       return totalSupply;
92   }
93 
94   // Function that is called when a user or another contract wants to transfer funds .
95   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
96     if(isContract(_to)) {
97         return transferToContract(_to, _value, _data);
98     }
99     else {
100         return transferToAddress(_to, _value, _data);
101     }
102 }
103 
104   // Standard function transfer similar to ERC20 transfer with no _data .
105   // Added due to backwards compatibility reasons .
106   function transfer(address _to, uint _value) returns (bool success) {
107 
108     //standard function transfer similar to ERC20 transfer with no _data
109     //added due to backwards compatibility reasons
110     bytes memory empty;
111     if(isContract(_to)) {
112         return transferToContract(_to, _value, empty);
113     }
114     else {
115         return transferToAddress(_to, _value, empty);
116     }
117 }
118 
119 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
120   function isContract(address _addr) private returns (bool is_contract) {
121       uint length;
122       assembly {
123             //retrieve the size of the code on target address, this needs assembly
124             length := extcodesize(_addr)
125         }
126         if(length>0) {
127             return true;
128         }
129         else {
130             return false;
131         }
132     }
133 
134   //function that is called when transaction target is an address
135   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
136     if (balanceOf(msg.sender) < _value) revert();
137     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
138     balances[_to] = balanceOf(_to).add(_value);
139     Transfer(msg.sender, _to, _value);
140     ERC223Transfer(msg.sender, _to, _value, _data);
141     return true;
142   }
143 
144   //function that is called when transaction target is a contract
145   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
146     if (balanceOf(msg.sender) < _value) revert();
147     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
148     balances[_to] = balanceOf(_to).add(_value);
149     ContractReceiver reciever = ContractReceiver(_to);
150     reciever.tokenFallback(msg.sender, _value, _data);
151     Transfer(msg.sender, _to, _value);
152     ERC223Transfer(msg.sender, _to, _value, _data);
153     return true;
154   }
155 
156 
157   function balanceOf(address _owner) constant returns (uint balance) {
158     return balances[_owner];
159   }
160 }
161 
162 contract SaturnPresale is ContractReceiver {
163   using SafeMath for uint256;
164 
165   bool    public active = false;
166   address public tokenAddress;
167   uint256 public hardCap;
168   uint256 public sold;
169 
170   struct Order {
171     address owner;
172     uint256 amount;
173     uint256 lockup;
174     bool    claimed;
175   }
176 
177   mapping(uint256 => Order) private orders;
178   uint256 private latestOrderId = 0;
179   address private owner;
180   address private treasury;
181 
182   event Activated(uint256 time);
183   event Finished(uint256 time);
184   event Purchase(address indexed purchaser, uint256 id, uint256 amount, uint256 purchasedAt, uint256 redeemAt);
185   event Claim(address indexed purchaser, uint256 id, uint256 amount);
186 
187   function SaturnPresale(address token, address ethRecepient, uint256 presaleHardCap) public {
188     tokenAddress  = token;
189     owner         = msg.sender;
190     treasury      = ethRecepient;
191     hardCap       = presaleHardCap;
192   }
193 
194   function tokenFallback(address /* _from */, uint _value, bytes /* _data */) public {
195     // Accept only SATURN ERC223 token
196     if (msg.sender != tokenAddress) { revert(); }
197     // If the Presale is active do not accept incoming transactions
198     if (active) { revert(); }
199     // Only accept one transaction of the right amount
200     if (_value != hardCap) { revert(); }
201 
202     active = true;
203     Activated(now);
204   }
205 
206   function amountOf(uint256 orderId) constant public returns (uint256 amount) {
207     return orders[orderId].amount;
208   }
209 
210   function lockupOf(uint256 orderId) constant public returns (uint256 timestamp) {
211     return orders[orderId].lockup;
212   }
213 
214   function ownerOf(uint256 orderId) constant public returns (address orderOwner) {
215     return orders[orderId].owner;
216   }
217 
218   function isClaimed(uint256 orderId) constant public returns (bool claimed) {
219     return orders[orderId].claimed;
220   }
221 
222   function () external payable {
223     revert();
224   }
225 
226   function shortBuy() public payable {
227     // 10% bonus
228     uint256 lockup = now + 12 weeks;
229     uint256 priceDiv = 1818181818;
230     processPurchase(priceDiv, lockup);
231   }
232 
233   function mediumBuy() public payable {
234     // 25% bonus
235     uint256 lockup = now + 24 weeks;
236     uint256 priceDiv = 1600000000;
237     processPurchase(priceDiv, lockup);
238   }
239 
240   function longBuy() public payable {
241     // 50% bonus
242     uint256 lockup = now + 52 weeks;
243     uint256 priceDiv = 1333333333;
244     processPurchase(priceDiv, lockup);
245   }
246 
247   function processPurchase(uint256 priceDiv, uint256 lockup) private {
248     if (!active) { revert(); }
249     if (msg.value == 0) { revert(); }
250     ++latestOrderId;
251 
252     uint256 purchasedAmount = msg.value.div(priceDiv);
253     if (purchasedAmount == 0) { revert(); } // not enough ETH sent
254     if (purchasedAmount > hardCap - sold) { revert(); } // too much ETH sent
255 
256     orders[latestOrderId] = Order(msg.sender, purchasedAmount, lockup, false);
257     sold += purchasedAmount;
258 
259     treasury.transfer(msg.value);
260     Purchase(msg.sender, latestOrderId, purchasedAmount, now, lockup);
261   }
262 
263   function redeem(uint256 orderId) public {
264     if (orderId > latestOrderId) { revert(); }
265     Order storage order = orders[orderId];
266 
267     // only owner can withdraw
268     if (msg.sender != order.owner) { revert(); }
269     if (now < order.lockup) { revert(); }
270     if (order.claimed) { revert(); }
271     order.claimed = true;
272 
273     ERC223 token = ERC223(tokenAddress);
274     token.transfer(order.owner, order.amount);
275 
276     Claim(order.owner, orderId, order.amount);
277   }
278 
279   function endPresale() public {
280     // only the creator of the smart contract
281     // can end the crowdsale prematurely
282     if (msg.sender != owner) { revert(); }
283     // can only stop an active crowdsale
284     if (!active) { revert(); }
285     _end();
286   }
287 
288   function _end() private {
289     // if there are any tokens remaining - return them to the owner
290     if (sold < hardCap) {
291       ERC223 token = ERC223(tokenAddress);
292       token.transfer(treasury, hardCap.sub(sold));
293     }
294     active = false;
295     Finished(now);
296   }
297 }