1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, throws on overflow.
49   */
50   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
51     if (a == 0) {
52       return 0;
53     }
54     c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers, truncating the quotient.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     // uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return a / b;
67   }
68 
69   /**
70   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
71   */
72   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73     assert(b <= a);
74     return a - b;
75   }
76 
77   /**
78   * @dev Adds two numbers, throws on overflow.
79   */
80   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
81     c = a + b;
82     assert(c >= a);
83     return c;
84   }
85 }
86 
87 
88 /**
89  * @title ERC20Basic
90  * @dev Simpler version of ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/179
92  */
93 contract ERC20Basic {
94   function totalSupply() public view returns (uint256);
95   function balanceOf(address who) public view returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public view returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 /**
113  * @title Crowdsale
114  * @dev Crowdsale is a base contract for managing a token crowdsale,
115  * allowing investors to purchase tokens with ether. This contract implements
116  * such functionality in its most fundamental form and can be extended to provide additional
117  * functionality and/or custom behavior.
118  * The external interface represents the basic interface for purchasing tokens, and conform
119  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
120  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
121  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
122  * behavior.
123  */
124 contract Crowdsale {
125   using SafeMath for uint256;
126 
127   // The token being sold
128   ERC20 public token;
129 
130   // Address where funds are collected
131   address public wallet;
132 
133   // How many token units a buyer gets per wei
134   uint256 public rate;
135 
136   // Amount of wei raised
137   uint256 public weiRaised;
138 
139   /**
140    * Event for token purchase logging
141    * @param purchaser who paid for the tokens
142    * @param beneficiary who got the tokens
143    * @param value weis paid for purchase
144    * @param amount amount of tokens purchased
145    */
146   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
147 
148   /**
149    * @param _rate Number of token units a buyer gets per wei
150    * @param _wallet Address where collected funds will be forwarded to
151    * @param _token Address of the token being sold
152    */
153   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
154     require(_rate > 0);
155     require(_wallet != address(0));
156     require(_token != address(0));
157 
158     rate = _rate;
159     wallet = _wallet;
160     token = _token;
161   }
162 
163   // -----------------------------------------
164   // Crowdsale external interface
165   // -----------------------------------------
166 
167   /**
168    * @dev fallback function ***DO NOT OVERRIDE***
169    */
170   function () external payable {
171     buyTokens(msg.sender);
172   }
173 
174   /**
175    * @dev low level token purchase ***DO NOT OVERRIDE***
176    * @param _beneficiary Address performing the token purchase
177    */
178   function buyTokens(address _beneficiary) public payable {
179 
180     uint256 weiAmount = msg.value;
181     _preValidatePurchase(_beneficiary, weiAmount);
182 
183     // calculate token amount to be created
184     uint256 tokens = _getTokenAmount(weiAmount);
185 
186     // update state
187     weiRaised = weiRaised.add(weiAmount);
188 
189     _processPurchase(_beneficiary, tokens);
190     emit TokenPurchase(
191       msg.sender,
192       _beneficiary,
193       weiAmount,
194       tokens
195     );
196 
197     _updatePurchasingState(_beneficiary, weiAmount);
198 
199     _forwardFunds();
200     _postValidatePurchase(_beneficiary, weiAmount);
201   }
202 
203   // -----------------------------------------
204   // Internal interface (extensible)
205   // -----------------------------------------
206 
207   /**
208    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
209    * @param _beneficiary Address performing the token purchase
210    * @param _weiAmount Value in wei involved in the purchase
211    */
212   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
213     require(_beneficiary != address(0));
214     require(_weiAmount != 0);
215   }
216 
217   /**
218    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
219    * @param _beneficiary Address performing the token purchase
220    * @param _weiAmount Value in wei involved in the purchase
221    */
222   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
223     // optional override
224   }
225 
226   /**
227    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
228    * @param _beneficiary Address performing the token purchase
229    * @param _tokenAmount Number of tokens to be emitted
230    */
231   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
232     token.transfer(_beneficiary, _tokenAmount);
233   }
234 
235   /**
236    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
237    * @param _beneficiary Address receiving the tokens
238    * @param _tokenAmount Number of tokens to be purchased
239    */
240   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
241     _deliverTokens(_beneficiary, _tokenAmount);
242   }
243 
244   /**
245    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
246    * @param _beneficiary Address receiving the tokens
247    * @param _weiAmount Value in wei involved in the purchase
248    */
249   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
250     // optional override
251   }
252 
253   /**
254    * @dev Override to extend the way in which ether is converted to tokens.
255    * @param _weiAmount Value in wei to be converted into tokens
256    * @return Number of tokens that can be purchased with the specified _weiAmount
257    */
258   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
259     return _weiAmount.mul(rate);
260   }
261 
262   /**
263    * @dev Determines how ETH is stored/forwarded on purchases.
264    */
265   function _forwardFunds() internal {
266     wallet.transfer(msg.value);
267   }
268 }
269 
270 
271 /**
272  * @title AllowanceCrowdsale
273  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
274  */
275 contract AllowanceCrowdsale is Crowdsale {
276   using SafeMath for uint256;
277 
278   address public tokenWallet;
279 
280   /**
281    * @dev Constructor, takes token wallet address.
282    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
283    */
284   function AllowanceCrowdsale(address _tokenWallet) public {
285     require(_tokenWallet != address(0));
286     tokenWallet = _tokenWallet;
287   }
288 
289   /**
290    * @dev Checks the amount of tokens left in the allowance.
291    * @return Amount of tokens left in the allowance
292    */
293   function remainingTokens() public view returns (uint256) {
294     return token.allowance(tokenWallet, this);
295   }
296 
297   /**
298    * @dev Overrides parent behavior by transferring tokens from wallet.
299    * @param _beneficiary Token purchaser
300    * @param _tokenAmount Amount of tokens purchased
301    */
302   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
303     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
304   }
305 }
306 
307 
308 
309 /**
310  * @title TimedCrowdsale
311  * @dev Crowdsale accepting contributions only within a time frame.
312  */
313 contract TimedCrowdsale is Crowdsale {
314   using SafeMath for uint256;
315 
316   uint256 public openingTime;
317   uint256 public closingTime;
318 
319   /**
320    * @dev Reverts if not in crowdsale time range.
321    */
322   modifier onlyWhileOpen {
323     // solium-disable-next-line security/no-block-members
324     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
325     _;
326   }
327 
328   /**
329    * @dev Constructor, takes crowdsale opening and closing times.
330    * @param _openingTime Crowdsale opening time
331    * @param _closingTime Crowdsale closing time
332    */
333   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
334     // solium-disable-next-line security/no-block-members
335     require(_openingTime >= block.timestamp);
336     require(_closingTime >= _openingTime);
337 
338     openingTime = _openingTime;
339     closingTime = _closingTime;
340   }
341 
342   /**
343    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
344    * @return Whether crowdsale period has elapsed
345    */
346   function hasClosed() public view returns (bool) {
347     // solium-disable-next-line security/no-block-members
348     return block.timestamp > closingTime;
349   }
350 
351   /**
352    * @dev Extend parent behavior requiring to be within contributing period
353    * @param _beneficiary Token purchaser
354    * @param _weiAmount Amount of wei contributed
355    */
356   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
357     super._preValidatePurchase(_beneficiary, _weiAmount);
358   }
359 
360 }
361 
362 
363 
364 /**
365  * @title CappedCrowdsale
366  * @dev Crowdsale with a limit for total contributions.
367  */
368 contract CappedCrowdsale is Crowdsale {
369   using SafeMath for uint256;
370 
371   uint256 public cap;
372 
373   /**
374    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
375    * @param _cap Max amount of wei to be contributed
376    */
377   function CappedCrowdsale(uint256 _cap) public {
378     require(_cap > 0);
379     cap = _cap;
380   }
381 
382   /**
383    * @dev Checks whether the cap has been reached.
384    * @return Whether the cap was reached
385    */
386   function capReached() public view returns (bool) {
387     return weiRaised >= cap;
388   }
389 
390   /**
391    * @dev Extend parent behavior requiring purchase to respect the funding cap.
392    * @param _beneficiary Token purchaser
393    * @param _weiAmount Amount of wei contributed
394    */
395   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
396     super._preValidatePurchase(_beneficiary, _weiAmount);
397     require(weiRaised.add(_weiAmount) <= cap);
398   }
399 
400 }
401 
402 
403 /**
404  * @title WhitelistedCrowdsale
405  * @dev Crowdsale in which only whitelisted users can contribute.
406  */
407 contract WhitelistedCrowdsale is Crowdsale, Ownable {
408 
409   mapping(address => bool) public whitelist;
410 
411   /**
412    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
413    */
414   modifier isWhitelisted(address _beneficiary) {
415     require(whitelist[_beneficiary]);
416     _;
417   }
418 
419   /**
420    * @dev Adds single address to whitelist.
421    * @param _beneficiary Address to be added to the whitelist
422    */
423   function addToWhitelist(address _beneficiary) external onlyOwner {
424     whitelist[_beneficiary] = true;
425   }
426 
427   /**
428    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
429    * @param _beneficiaries Addresses to be added to the whitelist
430    */
431   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
432     for (uint256 i = 0; i < _beneficiaries.length; i++) {
433       whitelist[_beneficiaries[i]] = true;
434     }
435   }
436 
437   /**
438    * @dev Removes single address from whitelist.
439    * @param _beneficiary Address to be removed to the whitelist
440    */
441   function removeFromWhitelist(address _beneficiary) external onlyOwner {
442     whitelist[_beneficiary] = false;
443   }
444 
445   /**
446    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
447    * @param _beneficiary Token beneficiary
448    * @param _weiAmount Amount of wei contributed
449    */
450   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
451     super._preValidatePurchase(_beneficiary, _weiAmount);
452   }
453 
454 }
455 
456 
457 contract OSNPresaleCrowdsale is WhitelistedCrowdsale, CappedCrowdsale, TimedCrowdsale, AllowanceCrowdsale {
458 
459   function OSNPresaleCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, ERC20 _token) public
460     AllowanceCrowdsale(_wallet)
461     CappedCrowdsale(_cap)
462     TimedCrowdsale(_startTime, _endTime)
463     Crowdsale(_rate, _wallet, _token)
464   {
465 
466   }
467 }