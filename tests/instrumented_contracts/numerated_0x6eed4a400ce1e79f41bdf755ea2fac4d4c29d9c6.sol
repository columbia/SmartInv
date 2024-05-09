1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 
118 /**
119  * @title Crowdsale
120  * @dev Crowdsale is a base contract for managing a token crowdsale,
121  * allowing investors to purchase tokens with ether. This contract implements
122  * such functionality in its most fundamental form and can be extended to provide additional
123  * functionality and/or custom behavior.
124  * The external interface represents the basic interface for purchasing tokens, and conform
125  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
126  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
127  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
128  * behavior.
129  */
130 
131 contract Crowdsale {
132   using SafeMath for uint256;
133 
134   // The token being sold
135   ERC20 public token;
136 
137   // Address where funds are collected
138   address public wallet;
139 
140   // How many token units a buyer gets per wei
141   uint256 public rate;
142 
143   // Amount of wei raised
144   uint256 public weiRaised;
145 
146   /**
147    * Event for token purchase logging
148    * @param purchaser who paid for the tokens
149    * @param beneficiary who got the tokens
150    * @param value weis paid for purchase
151    * @param amount amount of tokens purchased
152    */
153   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
154 
155   /**
156    * @param _rate Number of token units a buyer gets per wei
157    * @param _wallet Address where collected funds will be forwarded to
158    * @param _token Address of the token being sold
159    */
160   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
161     require(_rate > 0);
162     require(_wallet != address(0));
163     require(_token != address(0));
164 
165     rate = _rate;
166     wallet = _wallet;
167     token = _token;
168   }
169 
170   // -----------------------------------------
171   // Crowdsale external interface
172   // -----------------------------------------
173 
174   /**
175    * @dev fallback function ***DO NOT OVERRIDE***
176    */
177   function () external payable {
178     buyTokens(msg.sender);
179   }
180 
181   /**
182    * @dev low level token purchase ***DO NOT OVERRIDE***
183    * @param _beneficiary Address performing the token purchase
184    */
185   function buyTokens(address _beneficiary) public payable {
186 
187     uint256 weiAmount = msg.value;
188     _preValidatePurchase(_beneficiary, weiAmount);
189 
190     // calculate token amount to be created
191     uint256 tokens = _getTokenAmount(weiAmount);
192 
193     // update state
194     weiRaised = weiRaised.add(weiAmount);
195 
196     _processPurchase(_beneficiary, tokens);
197     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
198 
199     _updatePurchasingState(_beneficiary, weiAmount);
200 
201     _forwardFunds();
202     _postValidatePurchase(_beneficiary, weiAmount);
203   }
204 
205   // -----------------------------------------
206   // Internal interface (extensible)
207   // -----------------------------------------
208 
209   /**
210    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
211    * @param _beneficiary Address performing the token purchase
212    * @param _weiAmount Value in wei involved in the purchase
213    */
214   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
215     require(_beneficiary != address(0));
216     require(_weiAmount != 0);
217   }
218 
219   /**
220    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
221    * @param _beneficiary Address performing the token purchase
222    * @param _weiAmount Value in wei involved in the purchase
223    */
224   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
225     // optional override
226   }
227 
228   /**
229    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
230    * @param _beneficiary Address performing the token purchase
231    * @param _tokenAmount Number of tokens to be emitted
232    */
233   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
234     token.transfer(_beneficiary, _tokenAmount);
235   }
236 
237   /**
238    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
239    * @param _beneficiary Address receiving the tokens
240    * @param _tokenAmount Number of tokens to be purchased
241    */
242   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
243     _deliverTokens(_beneficiary, _tokenAmount);
244   }
245 
246   /**
247    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
248    * @param _beneficiary Address receiving the tokens
249    * @param _weiAmount Value in wei involved in the purchase
250    */
251   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
252     // optional override
253   }
254 
255   /**
256    * @dev Override to extend the way in which ether is converted to tokens.
257    * @param _weiAmount Value in wei to be converted into tokens
258    * @return Number of tokens that can be purchased with the specified _weiAmount
259    */
260   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
261     return _weiAmount.mul(rate);
262   }
263 
264   /**
265    * @dev Determines how ETH is stored/forwarded on purchases.
266    */
267   function _forwardFunds() internal {
268     wallet.transfer(msg.value);
269   }
270 }
271 
272 
273 /**
274  * @title AllowanceCrowdsale
275  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
276  */
277 contract AllowanceCrowdsale is Crowdsale {
278   using SafeMath for uint256;
279 
280   address public tokenWallet;
281 
282   /**
283    * @dev Constructor, takes token wallet address.
284    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
285    */
286   function AllowanceCrowdsale(address _tokenWallet) public {
287     require(_tokenWallet != address(0));
288     tokenWallet = _tokenWallet;
289   }
290 
291   /**
292    * @dev Checks the amount of tokens left in the allowance.
293    * @return Amount of tokens left in the allowance
294    */
295   function remainingTokens() public view returns (uint256) {
296     return token.allowance(tokenWallet, this);
297   }
298 
299   /**
300    * @dev Overrides parent behavior by transferring tokens from wallet.
301    * @param _beneficiary Token purchaser
302    * @param _tokenAmount Amount of tokens purchased
303    */
304   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
305     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
306   }
307 }
308 
309 
310 
311 /**
312  * @title TimedCrowdsale
313  * @dev Crowdsale accepting contributions only within a time frame.
314  */
315 contract TimedCrowdsale is Crowdsale {
316   using SafeMath for uint256;
317 
318   uint256 public openingTime;
319   uint256 public closingTime;
320 
321   /**
322    * @dev Reverts if not in crowdsale time range.
323    */
324   modifier onlyWhileOpen {
325     require(now >= openingTime && now <= closingTime);
326     _;
327   }
328 
329   /**
330    * @dev Constructor, takes crowdsale opening and closing times.
331    * @param _openingTime Crowdsale opening time
332    * @param _closingTime Crowdsale closing time
333    */
334   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
335     require(_openingTime >= now);
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
347     return now > closingTime;
348   }
349 
350   /**
351    * @dev Extend parent behavior requiring to be within contributing period
352    * @param _beneficiary Token purchaser
353    * @param _weiAmount Amount of wei contributed
354    */
355   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
356     super._preValidatePurchase(_beneficiary, _weiAmount);
357   }
358 
359 }
360 
361 
362 /**
363  * @title IncreasingPriceCrowdsale
364  * @dev Extension of Crowdsale contract that increases the price of tokens linearly in time.
365  * Note that what should be provided to the constructor is the initial and final _rates_, that is,
366  * the amount of tokens per wei contributed. Thus, the initial rate must be greater than the final rate.
367  */
368 contract IncreasingPriceCrowdsale is TimedCrowdsale {
369   using SafeMath for uint256;
370 
371   uint256 public initialRate;
372   uint256 public finalRate;
373 
374   /**
375    * @dev Constructor, takes intial and final rates of tokens received per wei contributed.
376    * @param _initialRate Number of tokens a buyer gets per wei at the start of the crowdsale
377    * @param _finalRate Number of tokens a buyer gets per wei at the end of the crowdsale
378    */
379   function IncreasingPriceCrowdsale(uint256 _initialRate, uint256 _finalRate) public {
380     require(_initialRate >= _finalRate);
381     require(_finalRate > 0);
382     initialRate = _initialRate;
383     finalRate = _finalRate;
384   }
385 
386   /**
387    * @dev Returns the rate of tokens per wei at the present time.
388    * Note that, as price _increases_ with time, the rate _decreases_.
389    * @return The number of tokens a buyer gets per wei at a given time
390    */
391   function getCurrentRate() public view returns (uint256) {
392     uint256 elapsedTime = now.sub(openingTime);
393     uint256 timeRange = closingTime.sub(openingTime);
394     uint256 rateRange = initialRate.sub(finalRate);
395     return initialRate.sub(elapsedTime.mul(rateRange).div(timeRange));
396   }
397 
398   /**
399    * @dev Overrides parent method taking into account variable rate.
400    * @param _weiAmount The value in wei to be converted into tokens
401    * @return The number of tokens _weiAmount wei will buy at present time
402    */
403   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
404     uint256 currentRate = getCurrentRate();
405     return currentRate.mul(_weiAmount);
406   }
407 
408 }
409 
410 
411 contract HawkTokenCrowdsale is IncreasingPriceCrowdsale, AllowanceCrowdsale, Ownable {
412     // init vars
413     using SafeMath for uint256;
414     uint256 public minwei;
415     // constructor
416     function HawkTokenCrowdsale
417        (
418           uint256 _openingTime,
419           uint256 _closingTime,
420           uint256 _initialRate,
421           uint256 _finalRate,
422 	  uint256 _minwei,
423           address _wallet,
424 	  address _tokenWallet,
425 	  ERC20 _token
426        )
427        public
428        Crowdsale(_initialRate, _wallet, _token)
429        AllowanceCrowdsale(_tokenWallet)
430        TimedCrowdsale(_openingTime, _closingTime)
431        IncreasingPriceCrowdsale(_initialRate, _finalRate)
432        {
433           minwei = _minwei;
434        }
435 
436     // overriding from crowdsale.sol to add a minimum wei per transaction
437     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
438 	      require(_beneficiary != address(0));
439 	      require(_weiAmount >= minwei);
440     }
441 
442     // setter function for minwei
443     function setMinWei(uint256 newMinWei) public onlyOwner {
444 	      require(newMinWei != 0);
445 	      minwei = newMinWei;
446     }
447 
448     // setter function for wallet
449     function setWallet(address newWallet) public onlyOwner {
450 	      require(newWallet != address(0));
451 	      wallet = newWallet;
452     }
453 
454     // setter function for token wallet
455     function setTokenWallet(address newTokenWallet) public onlyOwner {
456 	      require(newTokenWallet != address(0));
457 	      tokenWallet = newTokenWallet;
458     }
459 
460 }