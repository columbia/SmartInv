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
88   constructor() public {
89     owner = 0x96edbD4356309e21b72fA307BC7f20c7Aa30aA51;
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
156 contract PTG_Crowdsale is Pausable {
157   using SafeMath for uint256;
158 
159   // The token being sold
160   ERC20 public token;
161 
162   // Address where funds are collected
163   address public wallet;
164 
165   // Max supply of tokens offered in the crowdsale
166   uint256 public supply;
167 
168   // How many token units a buyer gets per wei
169   uint256 public rate;
170 
171   // Amount of wei raised
172   uint256 public weiRaised;
173   
174   // Min amount of wei an investor can send
175   uint256 public minInvest;
176   
177   // Max amount of wei an investor can send
178   uint256 public maxInvest;
179   
180   // Crowdsale opening time
181   uint256 public openingTime;
182   
183   // Crowdsale closing time
184   uint256 public closingTime;
185 
186   // Crowdsale duration in days
187   uint256 public duration;
188 
189   /**
190    * Event for token purchase logging
191    * @param purchaser who paid for the tokens
192    * @param beneficiary who got the tokens
193    * @param value weis paid for purchase
194    * @param amount amount of tokens purchased
195    */
196   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
197 
198   constructor() public {
199     rate = 20;
200     wallet = owner;
201     token = ERC20(0x7C2C75adcEE243e3874938aE8a71fA08020088a3);
202     minInvest = 0.1 * 1 ether;
203     maxInvest = 20 * 1 ether;
204     duration = 60 days;
205     openingTime = 1529035200;  // Determined by start()
206     closingTime = openingTime + duration;  // Determined by start()
207   }
208   
209   /**
210    * @dev called by the owner to start the crowdsale
211    */
212   function start() public onlyOwner {
213     openingTime = now;       
214     closingTime =  now + duration;
215   }
216 
217   /**
218    * @dev Returns the rate of tokens per wei at the present time.
219    * Note that, as price _increases_ with time, the rate _decreases_.
220    * @return The number of tokens a buyer gets per wei at a given time
221    */
222   function getCurrentRate() public view returns (uint256) {
223     if (now <= openingTime.add(14 days)) return rate.add(rate/5);   // bonus 20% first two weeks
224     if (now > openingTime.add(14 days) && now <= openingTime.add(28 days)) return rate.add(rate*3/20);   // bonus 15% second two weeks
225     if (now > openingTime.add(28 days) && now <= openingTime.add(42 days)) return rate.add(rate/10);   // bonus 10% third two weeks
226   }
227 
228   // -----------------------------------------
229   // Crowdsale external interface
230   // -----------------------------------------
231 
232   /**
233    * @dev fallback function ***DO NOT OVERRIDE***
234    */
235   function () external payable {
236     buyTokens(msg.sender);
237   }
238 
239   /**
240    * @dev low level token purchase ***DO NOT OVERRIDE***
241    * @param _beneficiary Address performing the token purchase
242    */
243   function buyTokens(address _beneficiary) public payable {
244 
245     uint256 weiAmount = msg.value;
246     _preValidatePurchase(_beneficiary, weiAmount);
247 
248     // calculate token amount to be created
249     uint256 tokens = _getTokenAmount(weiAmount);
250 
251     // update state
252     weiRaised = weiRaised.add(weiAmount);
253 
254     _processPurchase(_beneficiary, tokens);
255     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
256 
257     _forwardFunds();
258   }
259 
260   // -----------------------------------------
261   // Internal interface (extensible)
262   // -----------------------------------------
263 
264   /**
265    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
266    * @param _beneficiary Address performing the token purchase
267    * @param _weiAmount Value in wei involved in the purchase
268    */
269   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
270     require(_beneficiary != address(0));
271     require(_weiAmount >= minInvest && _weiAmount <= maxInvest);
272     require(now >= openingTime && now <= closingTime);
273   }
274 
275   /**
276    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
277    * @param _beneficiary Address performing the token purchase
278    * @param _tokenAmount Number of tokens to be emitted
279    */
280   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
281     token.transfer(_beneficiary, _tokenAmount);
282   }
283 
284   /**
285    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
286    * @param _beneficiary Address receiving the tokens
287    * @param _tokenAmount Number of tokens to be purchased
288    */
289   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
290     _deliverTokens(_beneficiary, _tokenAmount);
291   }
292 
293   /**
294    * @dev Override to extend the way in which ether is converted to tokens.
295    * @param _weiAmount Value in wei to be converted into tokens
296    * @return Number of tokens that can be purchased with the specified _weiAmount
297    */
298   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
299     uint256 currentRate = getCurrentRate();
300     return currentRate.mul(_weiAmount);
301   }
302 
303   /**
304    * @dev Determines how ETH is stored/forwarded on purchases.
305    */
306   function _forwardFunds() internal {
307     wallet.transfer(msg.value);
308   }
309   
310   /**
311    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
312    * @return Whether crowdsale period has elapsed
313    */
314   function hasClosed() public view returns (bool) {
315     return now > closingTime;
316   }
317 
318   /**
319    * @dev called by the owner to withdraw unsold tokens
320    */
321   function withdrawTokens() public onlyOwner {
322     uint256 unsold = token.balanceOf(this);
323     token.transfer(owner, unsold);
324   }
325     
326 }