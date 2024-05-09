1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract ERC223 {
50   uint public totalSupply;
51   function balanceOf(address who) constant returns (uint);
52 
53   function name() constant returns (string _name);
54   function symbol() constant returns (string _symbol);
55   function decimals() constant returns (uint8 _decimals);
56   function totalSupply() constant returns (uint256 _supply);
57 
58   function transfer(address to, uint value) returns (bool ok);
59   function transfer(address to, uint value, bytes data) returns (bool ok);
60   event Transfer(address indexed _from, address indexed _to, uint256 _value);
61   event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
62 }
63 
64 contract ContractReceiver {
65   function tokenFallback(address _from, uint _value, bytes _data);
66 }
67 
68 contract ERC223Token is ERC223 {
69   using SafeMath for uint;
70 
71   mapping(address => uint) balances;
72 
73   string public name;
74   string public symbol;
75   uint8 public decimals;
76   uint256 public totalSupply;
77 
78 
79   // Function to access name of token .
80   function name() constant returns (string _name) {
81       return name;
82   }
83   // Function to access symbol of token .
84   function symbol() constant returns (string _symbol) {
85       return symbol;
86   }
87   // Function to access decimals of token .
88   function decimals() constant returns (uint8 _decimals) {
89       return decimals;
90   }
91   // Function to access total supply of tokens .
92   function totalSupply() constant returns (uint256 _totalSupply) {
93       return totalSupply;
94   }
95 
96   // Function that is called when a user or another contract wants to transfer funds .
97   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
98     if(isContract(_to)) {
99         return transferToContract(_to, _value, _data);
100     }
101     else {
102         return transferToAddress(_to, _value, _data);
103     }
104 }
105 
106   // Standard function transfer similar to ERC20 transfer with no _data .
107   // Added due to backwards compatibility reasons .
108   function transfer(address _to, uint _value) returns (bool success) {
109 
110     //standard function transfer similar to ERC20 transfer with no _data
111     //added due to backwards compatibility reasons
112     bytes memory empty;
113     if(isContract(_to)) {
114         return transferToContract(_to, _value, empty);
115     }
116     else {
117         return transferToAddress(_to, _value, empty);
118     }
119 }
120 
121 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
122   function isContract(address _addr) private returns (bool is_contract) {
123       uint length;
124       assembly {
125             //retrieve the size of the code on target address, this needs assembly
126             length := extcodesize(_addr)
127         }
128         if(length>0) {
129             return true;
130         }
131         else {
132             return false;
133         }
134     }
135 
136   //function that is called when transaction target is an address
137   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
138     if (balanceOf(msg.sender) < _value) revert();
139     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
140     balances[_to] = balanceOf(_to).add(_value);
141     Transfer(msg.sender, _to, _value);
142     ERC223Transfer(msg.sender, _to, _value, _data);
143     return true;
144   }
145 
146   //function that is called when transaction target is a contract
147   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
148     if (balanceOf(msg.sender) < _value) revert();
149     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
150     balances[_to] = balanceOf(_to).add(_value);
151     ContractReceiver reciever = ContractReceiver(_to);
152     reciever.tokenFallback(msg.sender, _value, _data);
153     Transfer(msg.sender, _to, _value);
154     ERC223Transfer(msg.sender, _to, _value, _data);
155     return true;
156   }
157 
158 
159   function balanceOf(address _owner) constant returns (uint balance) {
160     return balances[_owner];
161   }
162 }
163 
164 contract SaturnPresale is ContractReceiver {
165   using SafeMath for uint256;
166 
167   bool public active = false;
168   mapping(address=>uint256) private purchased;
169   mapping(address=>uint256) private lockup;
170 
171   address public tokenAddress;
172 
173   uint256 private priceDiv;
174   uint256 private purchaseLimit;
175   uint256 public hardCap;
176   uint256 public sold;
177 
178   address private owner;
179   address private treasury;
180 
181   event Activated(uint256 time);
182   event Finished(uint256 time);
183   event Purchase(address indexed purchaser, uint256 amount, uint256 purchasedAt, uint256 redeemAt);
184 
185   function SaturnPresale(address token, address ethRecepient, uint256 minPurchase, uint256 presaleHardCap, uint256 price) public {
186     tokenAddress  = token;
187     priceDiv      = price;
188     owner         = msg.sender;
189     purchaseLimit = minPurchase;
190     treasury      = ethRecepient;
191     hardCap       = presaleHardCap;
192   }
193 
194   function tokenFallback(address /* _from */, uint _value, bytes /* _data */) public {
195     // Accept only SATURN ERC223 token
196     if (msg.sender != tokenAddress) { revert(); }
197     // If the Presale is active do not accept incoming transactions
198     if (active) { revert(); }
199     // Only accept one transaction in the amount of
200     if (_value != hardCap) { revert(); }
201 
202     active = true;
203     Activated(now);
204   }
205 
206   function balanceOf(address person) constant public returns (uint balance) {
207     return purchased[person];
208   }
209 
210   function lockupOf(address person) constant public returns (uint timestamp) {
211     return lockup[person];
212   }
213 
214   function () external payable {
215     buyTokens();
216   }
217 
218   function buyTokens() payable public {
219     if (!active) { revert(); }
220     if (msg.value < purchaseLimit) { revert(); }
221 
222     uint256 purchasedAmount = msg.value.div(priceDiv);
223     if (purchasedAmount == 0) { revert(); }
224     if (purchasedAmount > hardCap - sold) { revert(); }
225 
226     if (lockup[msg.sender] == 0) {
227       lockup[msg.sender] = now + 1 years;
228     }
229     purchased[msg.sender] = purchased[msg.sender] + purchasedAmount;
230     sold = sold + purchasedAmount;
231     treasury.transfer(msg.value);
232     Purchase(msg.sender, purchasedAmount, now, lockup[msg.sender]);
233   }
234 
235   function endPresale() public {
236     // only the creator of the smart contract
237     // can end the crowdsale prematurely
238     if (msg.sender != owner) { revert(); }
239     // can only stop an active crowdsale
240     if (!active) { revert(); }
241     _end();
242   }
243 
244   function redeem() public {
245     if (purchased[msg.sender] == 0) { revert(); }
246     if (now < lockup[msg.sender]) { revert(); }
247 
248     uint256 withdrawal = purchased[msg.sender];
249     purchased[msg.sender] = 0;
250 
251     ERC223 token = ERC223(tokenAddress);
252     token.transfer(msg.sender, withdrawal);
253   }
254 
255   function _end() private {
256     // if there are any tokens remaining - return them to the owner
257     if (sold < hardCap) {
258       ERC223 token = ERC223(tokenAddress);
259       token.transfer(treasury, hardCap.sub(sold));
260     }
261     active = false;
262     Finished(now);
263   }
264 }