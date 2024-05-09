1 pragma solidity ^0.4.18;
2 
3 /**************************
4  * SATURN ICO smart contract *
5  **************************/
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 
54 contract ERC223 {
55   uint public totalSupply;
56   function balanceOf(address who) constant returns (uint);
57 
58   function name() constant returns (string _name);
59   function symbol() constant returns (string _symbol);
60   function decimals() constant returns (uint8 _decimals);
61   function totalSupply() constant returns (uint256 _supply);
62 
63   function transfer(address to, uint value) returns (bool ok);
64   function transfer(address to, uint value, bytes data) returns (bool ok);
65   event Transfer(address indexed _from, address indexed _to, uint256 _value);
66   event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
67 }
68 
69 contract ContractReceiver {
70   function tokenFallback(address _from, uint _value, bytes _data);
71 }
72 
73 contract ERC223Token is ERC223 {
74   using SafeMath for uint;
75 
76   mapping(address => uint) balances;
77 
78   string public name;
79   string public symbol;
80   uint8 public decimals;
81   uint256 public totalSupply;
82 
83 
84   // Function to access name of token .
85   function name() constant returns (string _name) {
86       return name;
87   }
88   // Function to access symbol of token .
89   function symbol() constant returns (string _symbol) {
90       return symbol;
91   }
92   // Function to access decimals of token .
93   function decimals() constant returns (uint8 _decimals) {
94       return decimals;
95   }
96   // Function to access total supply of tokens .
97   function totalSupply() constant returns (uint256 _totalSupply) {
98       return totalSupply;
99   }
100 
101   // Function that is called when a user or another contract wants to transfer funds .
102   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
103     if(isContract(_to)) {
104         return transferToContract(_to, _value, _data);
105     }
106     else {
107         return transferToAddress(_to, _value, _data);
108     }
109 }
110 
111   // Standard function transfer similar to ERC20 transfer with no _data .
112   // Added due to backwards compatibility reasons .
113   function transfer(address _to, uint _value) returns (bool success) {
114 
115     //standard function transfer similar to ERC20 transfer with no _data
116     //added due to backwards compatibility reasons
117     bytes memory empty;
118     if(isContract(_to)) {
119         return transferToContract(_to, _value, empty);
120     }
121     else {
122         return transferToAddress(_to, _value, empty);
123     }
124 }
125 
126 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
127   function isContract(address _addr) private returns (bool is_contract) {
128       uint length;
129       assembly {
130             //retrieve the size of the code on target address, this needs assembly
131             length := extcodesize(_addr)
132         }
133         if(length>0) {
134             return true;
135         }
136         else {
137             return false;
138         }
139     }
140 
141   //function that is called when transaction target is an address
142   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
143     if (balanceOf(msg.sender) < _value) revert();
144     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
145     balances[_to] = balanceOf(_to).add(_value);
146     Transfer(msg.sender, _to, _value);
147     ERC223Transfer(msg.sender, _to, _value, _data);
148     return true;
149   }
150 
151   //function that is called when transaction target is a contract
152   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
153     if (balanceOf(msg.sender) < _value) revert();
154     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
155     balances[_to] = balanceOf(_to).add(_value);
156     ContractReceiver reciever = ContractReceiver(_to);
157     reciever.tokenFallback(msg.sender, _value, _data);
158     Transfer(msg.sender, _to, _value);
159     ERC223Transfer(msg.sender, _to, _value, _data);
160     return true;
161   }
162 
163 
164   function balanceOf(address _owner) constant returns (uint balance) {
165     return balances[_owner];
166   }
167 }
168 
169 contract TokenSale is ContractReceiver {
170   using SafeMath for uint256;
171 
172   bool    public active = false;
173   address public tokenAddress;
174   uint256 public hardCap;
175   uint256 public sold;
176 
177   // 1 eth = 50,000 SATURN
178   uint256 private priceDiv = 2000000000;
179   address private stn;
180   address private owner;
181   address private treasury;
182 
183   struct Ref {
184     uint256 amount;
185     uint256 rewardDiv;
186     uint256 etherAmount;
187   }
188 
189   mapping(address => Ref) private referrals;
190 
191   event Activated(uint256 time);
192   event Finished(uint256 time);
193   event Purchase(address indexed purchaser, uint256 amount);
194   event Referral(address indexed referrer, uint256 amount);
195 
196   function TokenSale(address token, address presaleToken, address ethRecepient, uint256 cap) public {
197     tokenAddress  = token;
198     stn           = presaleToken;
199     owner         = msg.sender;
200     treasury      = ethRecepient;
201     hardCap       = cap;
202   }
203 
204   function tokenFallback(address _from, uint _value, bytes /* _data */) public {
205     if (active && msg.sender == stn) {
206       stnExchange(_from, _value);
207     } else {
208       if (msg.sender != tokenAddress) { revert(); }
209       if (active) { revert(); }
210       if (_value != hardCap) { revert(); }
211 
212       active = true;
213       Activated(now);
214     }
215   }
216 
217   function stnExchange(address buyer, uint256 value) private {
218     uint256 purchasedAmount = value.mul(50000);
219     if (purchasedAmount == 0) { revert(); } // not enough STN sent
220     if (purchasedAmount > hardCap - sold) { revert(); } // too much STN sent
221 
222     sold += purchasedAmount;
223 
224     ERC223 token = ERC223(tokenAddress);
225     token.transfer(buyer, purchasedAmount);
226     Purchase(buyer, purchasedAmount);
227   }
228 
229   function refAmount(address user) constant public returns (uint256 amount) {
230     return referrals[user].amount;
231   }
232 
233   function refPercentage(address user) constant public returns (uint256 percentage) {
234     uint256 rewardDiv = referrals[user].rewardDiv;
235     if (rewardDiv == 0)   { return 1; }
236     if (rewardDiv == 100) { return 1; }
237     if (rewardDiv == 50)  { return 2; }
238     if (rewardDiv == 20)  { return 5; }
239     if (rewardDiv == 10)  { return 10; }
240   }
241 
242   function () external payable {
243     processPurchase(0x0);
244   }
245 
246   function processPurchase(address referrer) payable public {
247     if (!active) { revert(); }
248     if (msg.value == 0) { revert(); }
249 
250     uint256 purchasedAmount = msg.value.div(priceDiv);
251     if (purchasedAmount == 0) { revert(); } // not enough ETH sent
252     if (purchasedAmount > hardCap - sold) { revert(); } // too much ETH sent
253 
254     sold += purchasedAmount;
255     treasury.transfer(msg.value);
256 
257     ERC223 token = ERC223(tokenAddress);
258     token.transfer(msg.sender, purchasedAmount);
259     Purchase(msg.sender, purchasedAmount);
260     processReferral(referrer, purchasedAmount, msg.value);
261   }
262 
263   function processReferral(address referrer, uint256 tokenAmount, uint256 etherAmount) private returns (bool success) {
264     if (referrer == 0x0) { return true; }
265     Ref memory ref = referrals[referrer];
266     if (ref.rewardDiv == 0) { ref.rewardDiv = 100; } // on your first referral you get 1%
267     uint256 referralAmount = tokenAmount.div(ref.rewardDiv);
268     if (referralAmount == 0) { return true; }
269     // cannot pay more than the contract has itself
270     if (referralAmount > hardCap - sold) { referralAmount = hardCap - sold; }
271     ref.amount = ref.amount.add(referralAmount);
272     ref.etherAmount = ref.etherAmount.add(etherAmount);
273 
274     // ugly block of code that handles variable referral commisions
275     if (ref.etherAmount > 5 ether)   { ref.rewardDiv = 50; } // 2% from 5 eth
276     if (ref.etherAmount > 10 ether)  { ref.rewardDiv = 20; } // 5% from 10 eth
277     if (ref.etherAmount > 100 ether) { ref.rewardDiv = 10; } // 10% from 100 eth
278     // end referral updates
279 
280     sold += referralAmount;
281     referrals[referrer] = ref; // update the mapping and store our changes
282     ERC223 token = ERC223(tokenAddress);
283     token.transfer(referrer, referralAmount);
284     Referral(referrer, referralAmount);
285     return true;
286   }
287 
288   function endSale() public {
289     // only the creator of the smart contract can end the crowdsale
290     if (msg.sender != owner) { revert(); }
291     // can only stop an active crowdsale
292     if (!active) { revert(); }
293     _end();
294   }
295 
296   function _end() private {
297     // if there are any tokens remaining - return them to the treasury
298     if (sold < hardCap) {
299       ERC223 token = ERC223(tokenAddress);
300       token.transfer(treasury, hardCap.sub(sold));
301     }
302     active = false;
303     Finished(now);
304   }
305 }