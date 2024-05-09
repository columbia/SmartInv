1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 pragma solidity ^0.4.15;
35 
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner {
69     require(newOwner != address(0));
70     owner = newOwner;
71   }
72 
73 }
74 
75 pragma solidity ^0.4.15;
76 
77 
78 
79 
80 /**
81  * @title Pausable
82  * @dev Base contract which allows children to implement an emergency stop mechanism.
83  */
84 contract Pausable is Ownable {
85   event Pause();
86   event Unpause();
87 
88   bool public paused = false;
89 
90 
91   /**
92    * @dev modifier to allow actions only when the contract IS paused
93    */
94   modifier whenNotPaused() {
95     require(!paused);
96     _;
97   }
98 
99   /**
100    * @dev modifier to allow actions only when the contract IS NOT paused
101    */
102   modifier whenPaused() {
103     require(paused);
104     _;
105   }
106 
107   /**
108    * @dev called by the owner to pause, triggers stopped state
109    */
110   function pause() onlyOwner whenNotPaused {
111     paused = true;
112     Pause();
113   }
114 
115   /**
116    * @dev called by the owner to unpause, returns to normal state
117    */
118   function unpause() onlyOwner whenPaused {
119     paused = false;
120     Unpause();
121   }
122 }
123 
124 pragma solidity ^0.4.15;
125 
126 
127 /**
128  * @title Whitelistable
129  * @dev Base contract which allows children to implement action for a whitelist or for everyone.
130  */
131 contract Whitelistable is Ownable {
132   event AllowEveryone();
133   event AllowWhiteList();
134 
135   // Flag to turn of the whitelist restriction
136   bool public everyoneDisabled = true;
137 
138 
139   /**
140    * @dev modifier to allow actions only for whitelisted users
141    */
142   modifier whenNotEveryone() {
143     require(everyoneDisabled);
144     _;
145   }
146 
147   /**
148    * @dev modifier to allow actions for everybody
149    */
150   modifier whenEveryone() {
151     require(!everyoneDisabled);
152     _;
153   }
154 
155   /**
156    * @dev called by the owner to allow everyone
157    */
158   function allowEveryone() onlyOwner whenNotEveryone {
159     everyoneDisabled = false;
160     AllowEveryone();
161   }
162 
163   /**
164    * @dev called by the owner to limit to whitelist users
165    */
166   function allowWhiteList() onlyOwner whenEveryone {
167     everyoneDisabled = true;
168     AllowWhiteList();
169   }
170 }
171 
172 pragma solidity ^0.4.15;
173 
174 
175 contract FundRequestPublicSeed is Pausable, Whitelistable {
176   using SafeMath for uint;
177 
178   // address where funds are collected
179   address public wallet;
180   // how many token units a buyer gets per wei
181   uint public rate;
182   // Max amount of ETH that can be raised (in wei)
183   uint256 public weiMaxCap;
184   // amount of raised money in wei
185   uint256 public weiRaised;
186   // max amount of ETH that is allowed to deposit when whitelist is active
187   uint256 public maxPurchaseSize;
188   
189   mapping(address => uint) public deposits;
190   mapping(address => uint) public balances;
191   address[] public investors;
192   uint public investorCount;
193   mapping(address => bool) public allowed;
194   /**
195    * event for token purchase logging
196    * @param purchaser who paid for the tokens
197    * @param beneficiary who got the tokens
198    * @param value weis paid for purchase
199    * @param amount amount of tokens purchased
200    */
201   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);
202 
203   function FundRequestPublicSeed(uint _rate, uint256 _maxCap, address _wallet) {
204     require(_rate > 0);
205     require(_maxCap > 0);
206     require(_wallet != 0x0);
207 
208     rate = _rate;
209     weiMaxCap = SafeMath.mul(_maxCap, 1 ether);
210     wallet = _wallet;
211     maxPurchaseSize = 25 ether;
212   }
213   
214   // low level token purchase function
215   function buyTokens(address beneficiary) payable whenNotPaused {
216     require(validPurchase());
217     require(maxCapNotReached());
218     if (everyoneDisabled) {
219       require(validBeneficiary(beneficiary));
220       require(validPurchaseSize(beneficiary));  
221     }
222     
223     bool existing = deposits[beneficiary] > 0;  
224     uint weiAmount = msg.value;
225     uint updatedWeiRaised = weiRaised.add(weiAmount);
226     // calculate token amount to be created
227     uint tokens = weiAmount.mul(rate);
228     weiRaised = updatedWeiRaised;
229     deposits[beneficiary] = deposits[beneficiary].add(msg.value);
230     balances[beneficiary] = balances[beneficiary].add(tokens);
231     if(!existing) {
232       investors.push(beneficiary);
233       investorCount++;
234     }
235     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
236     forwardFunds();
237   }
238   // send ether to the fund collection wallet
239   // override to create custom fund forwarding mechanisms
240   function forwardFunds() internal {
241     wallet.transfer(msg.value);
242   }
243   function validBeneficiary(address beneficiary) internal constant returns (bool) {
244     return allowed[beneficiary] == true;
245   }
246   // @return true if the transaction can buy tokens
247   function validPurchase() internal constant returns (bool) {
248     return msg.value != 0;
249   }
250   // @return true if the amount is lower then 20ETH
251   function validPurchaseSize(address beneficiary) internal constant returns (bool) {
252     return msg.value.add(deposits[beneficiary]) <= maxPurchaseSize;
253   }
254   function maxCapNotReached() internal constant returns (bool) {
255     return SafeMath.add(weiRaised, msg.value) <= weiMaxCap;
256   }
257   function balanceOf(address _owner) constant returns (uint balance) {
258     return balances[_owner];
259   }
260   function depositsOf(address _owner) constant returns (uint deposit) {
261     return deposits[_owner];
262   }
263   function allow(address beneficiary) onlyOwner {
264     allowed[beneficiary] = true;
265   }
266   function updateRate(uint _rate) onlyOwner whenPaused {
267     rate = _rate;
268   }
269 
270   function updateWallet(address _wallet) onlyOwner whenPaused {
271     require(_wallet != address(0));
272     wallet = _wallet;
273   }
274 
275   function updateMaxCap(uint _maxCap) onlyOwner whenPaused {
276     require(_maxCap != 0);
277     weiMaxCap = SafeMath.mul(_maxCap, 1 ether);
278   }
279 
280   function updatePurchaseSize(uint _purchaseSize) onlyOwner whenPaused {
281     require(_purchaseSize != 0);
282     maxPurchaseSize = _purchaseSize;
283   }
284 
285   // fallback function can be used to buy tokens
286   function () payable {
287     buyTokens(msg.sender);
288   }
289 }