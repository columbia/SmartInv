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
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Ownable
74  * @dev The Ownable contract has an owner address, and provides basic authorization control
75  * functions, this simplifies the implementation of "user permissions".
76  */
77 contract Ownable {
78   address public owner;
79 
80 
81   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   function Ownable() public {
89     owner = msg.sender;
90   }
91 
92   /**
93    * @dev Throws if called by any account other than the owner.
94    */
95   modifier onlyOwner() {
96     require(msg.sender == owner);
97     _;
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address newOwner) public onlyOwner {
105     require(newOwner != address(0));
106     emit OwnershipTransferred(owner, newOwner);
107     owner = newOwner;
108   }
109 
110 }
111 
112 /**
113  * @title Pausable
114  * @dev Base contract which allows children to implement an emergency stop mechanism.
115  */
116 contract Pausable is Ownable {
117   event Pause();
118   event Unpause();
119 
120   bool public paused = false;
121 
122 
123   /**
124    * @dev Modifier to make a function callable only when the contract is not paused.
125    */
126   modifier whenNotPaused() {
127     require(!paused);
128     _;
129   }
130 
131   /**
132    * @dev Modifier to make a function callable only when the contract is paused.
133    */
134   modifier whenPaused() {
135     require(paused);
136     _;
137   }
138 
139   /**
140    * @dev called by the owner to pause, triggers stopped state
141    */
142   function pause() onlyOwner whenNotPaused public {
143     paused = true;
144     emit Pause();
145   }
146 
147   /**
148    * @dev called by the owner to unpause, returns to normal state
149    */
150   function unpause() onlyOwner whenPaused public {
151     paused = false;
152     emit Unpause();
153   }
154 }
155 
156 contract Crowdsale is Pausable {
157   using SafeMath for uint256;
158 
159   // The token being sold
160   ERC20 public token;
161 
162   // Address where funds are collected
163   address public wallet;
164 
165   // How many token units a buyer gets per wei
166   uint256 public rate;
167 
168   // Amount of wei raised
169   uint256 public weiRaised;
170   
171   // Crowdsale opening time
172   uint256 public openingTime;
173   
174   // Crowdsale closing time
175   uint256 public closingTime;
176 
177   // Crowdsale duration in days
178   uint256 public duration;
179 
180   /**
181    * Event for token purchase logging
182    * @param purchaser who paid for the tokens
183    * @param beneficiary who got the tokens
184    * @param value weis paid for purchase
185    * @param amount amount of tokens purchased
186    */
187   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
188 
189   constructor() public {
190     rate = 4000;
191     wallet = 0x3CB0F6d4Fc022348Cf75Cdb2C2E04492975e4d30;
192     token = ERC20(0x0c537C661B28a4EF16AB27BEd46111473a6bd08d);
193     duration = 120 days;
194     openingTime = now;  // Determined by start()
195     closingTime = openingTime + duration;  // Determined by start()
196   }
197 
198   /**
199    * @dev Returns the rate of tokens per wei at the present time.
200    * Note that, as price _increases_ with time, the rate _decreases_.
201    * @return The number of tokens a buyer gets per wei at a given time
202    */
203   function getCurrentRate() public view returns (uint256) {
204         if (now <= openingTime.add(30 days)) return rate.add(rate*4/10);   // bonus 40% first 30 days
205         if (now > openingTime.add(30 days) && now <= openingTime.add(60 days)) return rate.add(rate/5);   // bonus 20% first 30 days
206         if (now > openingTime.add(60 days) && now <= openingTime.add(90 days)) return rate.add(rate/2);   // bonus 10% first 30 days
207   }
208 
209   // -----------------------------------------
210   // Crowdsale external interface
211   // -----------------------------------------
212 
213   /**
214    * @dev fallback function ***DO NOT OVERRIDE***
215    */
216   function () external payable {
217     buyTokens(msg.sender);
218   }
219 
220   /**
221    * @dev low level token purchase ***DO NOT OVERRIDE***
222    * @param _beneficiary Address performing the token purchase
223    */
224   function buyTokens(address _beneficiary) public payable {
225 
226     uint256 weiAmount = msg.value;
227     _preValidatePurchase(_beneficiary, weiAmount);
228 
229     // calculate token amount to be created
230     uint256 tokens = _getTokenAmount(weiAmount);
231 
232     // update state
233     weiRaised = weiRaised.add(weiAmount);
234 
235     _processPurchase(_beneficiary, tokens);
236     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
237 
238     _forwardFunds();
239   }
240 
241   // -----------------------------------------
242   // Internal interface (extensible)
243   // -----------------------------------------
244 
245   /**
246    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
247    * @param _beneficiary Address performing the token purchase
248    * @param _weiAmount Value in wei involved in the purchase
249    */
250   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
251     require(_beneficiary != address(0));
252     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
253   }
254 
255   /**
256    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
257    * @param _beneficiary Address performing the token purchase
258    * @param _tokenAmount Number of tokens to be emitted
259    */
260   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
261     token.transfer(_beneficiary, _tokenAmount);
262   }
263 
264   /**
265    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
266    * @param _beneficiary Address receiving the tokens
267    * @param _tokenAmount Number of tokens to be purchased
268    */
269   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
270     _deliverTokens(_beneficiary, _tokenAmount);
271   }
272 
273   /**
274    * @dev Override to extend the way in which ether is converted to tokens.
275    * @param _weiAmount Value in wei to be converted into tokens
276    * @return Number of tokens that can be purchased with the specified _weiAmount
277    */
278   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
279     uint256 currentRate = getCurrentRate();
280     return currentRate.mul(_weiAmount);
281   }
282 
283   /**
284    * @dev Determines how ETH is stored/forwarded on purchases.
285    */
286   function _forwardFunds() internal {
287     wallet.transfer(msg.value);
288   }
289   
290   /**
291    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
292    * @return Whether crowdsale period has elapsed
293    */
294   function hasClosed() public view returns (bool) {
295     return block.timestamp > closingTime;
296   }
297 
298   /**
299    * @dev called by the owner to withdraw unsold tokens
300    */
301   function unsoldTokens() public onlyOwner {
302     uint256 unsold = token.balanceOf(this);
303     token.transfer(owner, unsold);
304   }
305 
306 }
307 
308 contract PostDeliveryCrowdsale is Crowdsale {
309   using SafeMath for uint256;
310 
311   mapping(address => uint256) public balances;
312 
313   /**
314    * @dev Withdraw tokens only after crowdsale ends.
315    */
316   function withdrawTokens() public {
317     require(hasClosed());
318     uint256 amount = balances[msg.sender];
319     require(amount > 0);
320     balances[msg.sender] = 0;
321     _deliverTokens(msg.sender, amount);
322   }
323 
324   /**
325    * @dev Overrides parent by storing balances instead of issuing tokens right away.
326    * @param _beneficiary Token purchaser
327    * @param _tokenAmount Amount of tokens purchased
328    */
329   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
330     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
331   }
332 
333 }