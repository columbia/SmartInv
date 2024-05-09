1 pragma solidity ^0.4.24;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
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
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title SafeERC20
55  * @dev Wrappers around ERC20 operations that throw on failure.
56  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
57  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
58  */
59 library SafeERC20 {
60   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
61     require(token.transfer(to, value));
62   }
63 
64   function safeTransferFrom(
65     ERC20 token,
66     address from,
67     address to,
68     uint256 value
69   )
70     internal
71   {
72     require(token.transferFrom(from, to, value));
73   }
74 
75   function safeApprove(ERC20 token, address spender, uint256 value) internal {
76     require(token.approve(spender, value));
77   }
78 }
79 
80 /**
81  * @title Ownable
82  * @dev The Ownable contract has an owner address, and provides basic authorization control
83  * functions, this simplifies the implementation of "user permissions".
84  */
85 contract Ownable {
86   address public owner;
87 
88 
89   event OwnershipRenounced(address indexed previousOwner);
90   event OwnershipTransferred(
91     address indexed previousOwner,
92     address indexed newOwner
93   );
94 
95 
96   /**
97    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
98    * account.
99    */
100   constructor() public {
101     owner = msg.sender;
102   }
103 
104   /**
105    * @dev Throws if called by any account other than the owner.
106    */
107   modifier onlyOwner() {
108     require(msg.sender == owner);
109     _;
110   }
111 
112   /**
113    * @dev Allows the current owner to relinquish control of the contract.
114    * @notice Renouncing to ownership will leave the contract without an owner.
115    * It will not be possible to call the functions with the `onlyOwner`
116    * modifier anymore.
117    */
118   function renounceOwnership() public onlyOwner {
119     emit OwnershipRenounced(owner);
120     owner = address(0);
121   }
122 
123   /**
124    * @dev Allows the current owner to transfer control of the contract to a newOwner.
125    * @param _newOwner The address to transfer ownership to.
126    */
127   function transferOwnership(address _newOwner) public onlyOwner {
128     _transferOwnership(_newOwner);
129   }
130 
131   /**
132    * @dev Transfers control of the contract to a newOwner.
133    * @param _newOwner The address to transfer ownership to.
134    */
135   function _transferOwnership(address _newOwner) internal {
136     require(_newOwner != address(0));
137     emit OwnershipTransferred(owner, _newOwner);
138     owner = _newOwner;
139   }
140 }
141 
142 /**
143  * @title ERC20Basic
144  * @dev Simpler version of ERC20 interface
145  * See https://github.com/ethereum/EIPs/issues/179
146  */
147 contract ERC20Basic {
148   function totalSupply() public view returns (uint256);
149   function balanceOf(address who) public view returns (uint256);
150   function transfer(address to, uint256 value) public returns (bool);
151   event Transfer(address indexed from, address indexed to, uint256 value);
152 }
153 
154 /**
155  * @title ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/20
157  */
158 contract ERC20 is ERC20Basic {
159   function allowance(address owner, address spender)
160     public view returns (uint256);
161 
162   function transferFrom(address from, address to, uint256 value)
163     public returns (bool);
164 
165   function approve(address spender, uint256 value) public returns (bool);
166   event Approval(
167     address indexed owner,
168     address indexed spender,
169     uint256 value
170   );
171 }
172 
173 /**
174  * @title Crowdsale
175  * @dev Crowdsale is a base contract for managing a token crowdsale,
176  * allowing investors to purchase tokens with ether. This contract implements
177  * such functionality in its most fundamental form and can be extended to provide additional
178  * functionality and/or custom behavior.
179  * The external interface represents the basic interface for purchasing tokens, and conform
180  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
181  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
182  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
183  * behavior.
184  */
185 contract Crowdsale {
186   using SafeMath for uint256;
187   using SafeERC20 for ERC20;
188 
189   // The token being sold
190   ERC20 public token;
191 
192   // Address where funds are collected
193   address public wallet;
194 
195   // How many token units a buyer gets per wei.
196   // The rate is the conversion between wei and the smallest and indivisible token unit.
197   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
198   // 1 wei will give you 1 unit, or 0.001 TOK.
199   uint256 public rate;
200 
201   // Amount of wei raised
202   uint256 public weiRaised;
203 
204   /**
205    * Event for token purchase logging
206    * @param purchaser who paid for the tokens
207    * @param beneficiary who got the tokens
208    * @param value weis paid for purchase
209    * @param amount amount of tokens purchased
210    */
211   event TokenPurchase(
212     address indexed purchaser,
213     address indexed beneficiary,
214     uint256 value,
215     uint256 amount
216   );
217 
218   /**
219    * @param _rate Number of token units a buyer gets per wei
220    * @param _wallet Address where collected funds will be forwarded to
221    * @param _token Address of the token being sold
222    */
223   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
224     require(_rate > 0);
225     require(_wallet != address(0));
226     require(_token != address(0));
227 
228     rate = _rate;
229     wallet = _wallet;
230     token = _token;
231   }
232 
233   // -----------------------------------------
234   // Crowdsale external interface
235   // -----------------------------------------
236 
237   /**
238    * @dev fallback function ***DO NOT OVERRIDE***
239    */
240   function () external payable {
241     buyTokens(msg.sender);
242   }
243 
244   /**
245    * @dev low level token purchase ***DO NOT OVERRIDE***
246    * @param _beneficiary Address performing the token purchase
247    */
248   function buyTokens(address _beneficiary) public payable {
249 
250     uint256 weiAmount = msg.value;
251     _preValidatePurchase(_beneficiary, weiAmount);
252 
253     // calculate token amount to be created
254     uint256 tokens = _getTokenAmount(weiAmount);
255 
256     // update state
257     weiRaised = weiRaised.add(weiAmount);
258 
259     _processPurchase(_beneficiary, tokens);
260     emit TokenPurchase(
261       msg.sender,
262       _beneficiary,
263       weiAmount,
264       tokens
265     );
266 
267     _updatePurchasingState(_beneficiary, weiAmount);
268 
269     _forwardFunds();
270     _postValidatePurchase(_beneficiary, weiAmount);
271   }
272 
273   // -----------------------------------------
274   // Internal interface (extensible)
275   // -----------------------------------------
276 
277   /**
278    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
279    * @param _beneficiary Address performing the token purchase
280    * @param _weiAmount Value in wei involved in the purchase
281    */
282   function _preValidatePurchase(
283     address _beneficiary,
284     uint256 _weiAmount
285   )
286     internal
287   {
288     require(_beneficiary != address(0));
289     require(_weiAmount != 0);
290   }
291 
292   /**
293    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
294    * @param _beneficiary Address performing the token purchase
295    * @param _weiAmount Value in wei involved in the purchase
296    */
297   function _postValidatePurchase(
298     address _beneficiary,
299     uint256 _weiAmount
300   )
301     internal
302   {
303     // optional override
304   }
305 
306   /**
307    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
308    * @param _beneficiary Address performing the token purchase
309    * @param _tokenAmount Number of tokens to be emitted
310    */
311   function _deliverTokens(
312     address _beneficiary,
313     uint256 _tokenAmount
314   )
315     internal
316   {
317     token.safeTransfer(_beneficiary, _tokenAmount);
318   }
319 
320   /**
321    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
322    * @param _beneficiary Address receiving the tokens
323    * @param _tokenAmount Number of tokens to be purchased
324    */
325   function _processPurchase(
326     address _beneficiary,
327     uint256 _tokenAmount
328   )
329     internal
330   {
331     _deliverTokens(_beneficiary, _tokenAmount);
332   }
333 
334   /**
335    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
336    * @param _beneficiary Address receiving the tokens
337    * @param _weiAmount Value in wei involved in the purchase
338    */
339   function _updatePurchasingState(
340     address _beneficiary,
341     uint256 _weiAmount
342   )
343     internal
344   {
345     // optional override
346   }
347 
348   /**
349    * @dev Override to extend the way in which ether is converted to tokens.
350    * @param _weiAmount Value in wei to be converted into tokens
351    * @return Number of tokens that can be purchased with the specified _weiAmount
352    */
353   function _getTokenAmount(uint256 _weiAmount)
354     internal view returns (uint256)
355   {
356     return _weiAmount.mul(rate);
357   }
358 
359   /**
360    * @dev Determines how ETH is stored/forwarded on purchases.
361    */
362   function _forwardFunds() internal {
363     wallet.transfer(msg.value);
364   }
365 }
366 
367 /**
368  * @title TimedCrowdsale
369  * @dev Crowdsale accepting contributions only within a time frame.
370  */
371 contract TimedCrowdsale is Crowdsale {
372   using SafeMath for uint256;
373 
374   uint256 public openingTime;
375   uint256 public closingTime;
376 
377   /**
378    * @dev Reverts if not in crowdsale time range.
379    */
380   modifier onlyWhileOpen {
381     // solium-disable-next-line security/no-block-members
382     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
383     _;
384   }
385 
386   /**
387    * @dev Constructor, takes crowdsale opening and closing times.
388    * @param _openingTime Crowdsale opening time
389    * @param _closingTime Crowdsale closing time
390    */
391   constructor(uint256 _openingTime, uint256 _closingTime) public {
392     // solium-disable-next-line security/no-block-members
393     require(_openingTime >= block.timestamp);
394     require(_closingTime >= _openingTime);
395 
396     openingTime = _openingTime;
397     closingTime = _closingTime;
398   }
399 
400   /**
401    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
402    * @return Whether crowdsale period has elapsed
403    */
404   function hasClosed() public view returns (bool) {
405     // solium-disable-next-line security/no-block-members
406     return block.timestamp > closingTime;
407   }
408 
409   /**
410    * @dev Extend parent behavior requiring to be within contributing period
411    * @param _beneficiary Token purchaser
412    * @param _weiAmount Amount of wei contributed
413    */
414   function _preValidatePurchase(
415     address _beneficiary,
416     uint256 _weiAmount
417   )
418     internal
419     onlyWhileOpen
420   {
421     super._preValidatePurchase(_beneficiary, _weiAmount);
422   }
423 
424 }
425 
426 /**
427  * @title AllowanceCrowdsale
428  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
429  */
430 contract AllowanceCrowdsale is Crowdsale {
431   using SafeMath for uint256;
432   using SafeERC20 for ERC20;
433 
434   address public tokenWallet;
435 
436   /**
437    * @dev Constructor, takes token wallet address.
438    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
439    */
440   constructor(address _tokenWallet) public {
441     require(_tokenWallet != address(0));
442     tokenWallet = _tokenWallet;
443   }
444 
445   /**
446    * @dev Checks the amount of tokens left in the allowance.
447    * @return Amount of tokens left in the allowance
448    */
449   function remainingTokens() public view returns (uint256) {
450     return token.allowance(tokenWallet, this);
451   }
452 
453   /**
454    * @dev Overrides parent behavior by transferring tokens from wallet.
455    * @param _beneficiary Token purchaser
456    * @param _tokenAmount Amount of tokens purchased
457    */
458   function _deliverTokens(
459     address _beneficiary,
460     uint256 _tokenAmount
461   )
462     internal
463   {
464     token.safeTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
465   }
466 }
467 
468 /**
469  * @title IncreasingPriceCrowdsale
470  * @dev Extension of Crowdsale contract that increases the price of tokens linearly in time.
471  * Note that what should be provided to the constructor is the initial and final _rates_, that is,
472  * the amount of tokens per wei contributed. Thus, the initial rate must be greater than the final rate.
473  */
474 contract IncreasingPriceCrowdsale is TimedCrowdsale {
475   using SafeMath for uint256;
476 
477   uint256 public initialRate;
478   uint256 public finalRate;
479 
480   /**
481    * @dev Constructor, takes intial and final rates of tokens received per wei contributed.
482    * @param _initialRate Number of tokens a buyer gets per wei at the start of the crowdsale
483    * @param _finalRate Number of tokens a buyer gets per wei at the end of the crowdsale
484    */
485   constructor(uint256 _initialRate, uint256 _finalRate) public {
486     require(_initialRate >= _finalRate);
487     require(_finalRate > 0);
488     initialRate = _initialRate;
489     finalRate = _finalRate;
490   }
491 
492   /**
493    * @dev Returns the rate of tokens per wei at the present time.
494    * Note that, as price _increases_ with time, the rate _decreases_.
495    * @return The number of tokens a buyer gets per wei at a given time
496    */
497   function getCurrentRate() public view returns (uint256) {
498     // solium-disable-next-line security/no-block-members
499     uint256 elapsedTime = block.timestamp.sub(openingTime);
500     uint256 timeRange = closingTime.sub(openingTime);
501     uint256 rateRange = initialRate.sub(finalRate);
502     return initialRate.sub(elapsedTime.mul(rateRange).div(timeRange));
503   }
504 
505   /**
506    * @dev Overrides parent method taking into account variable rate.
507    * @param _weiAmount The value in wei to be converted into tokens
508    * @return The number of tokens _weiAmount wei will buy at present time
509    */
510   function _getTokenAmount(uint256 _weiAmount)
511     internal view returns (uint256)
512   {
513     uint256 currentRate = getCurrentRate();
514     return currentRate.mul(_weiAmount);
515   }
516 
517 }
518 
519 /**
520  * @title Contracts that should be able to recover tokens
521  * @author SylTi
522  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
523  * This will prevent any accidental loss of tokens.
524  */
525 contract CanReclaimToken is Ownable {
526   using SafeERC20 for ERC20Basic;
527 
528   /**
529    * @dev Reclaim all ERC20Basic compatible tokens
530    * @param token ERC20Basic The address of the token contract
531    */
532   function reclaimToken(ERC20Basic token) external onlyOwner {
533     uint256 balance = token.balanceOf(this);
534     token.safeTransfer(owner, balance);
535   }
536 
537 }
538 
539 
540 contract ConferenceCoinCrowdsale is AllowanceCrowdsale, IncreasingPriceCrowdsale, CanReclaimToken {
541 
542   constructor (
543     uint _openingTime,
544     uint _closingTime,
545     uint _initialRate,
546     uint _finalRate,
547     address _wallet, // collecting eth
548     address _tokenWallet, // that approved tokens
549     ERC20 _token) // adress of token contract
550     public 
551     Crowdsale(_finalRate, _wallet, _token)
552     AllowanceCrowdsale(_tokenWallet) 
553     TimedCrowdsale(_openingTime, _closingTime)
554     IncreasingPriceCrowdsale(_initialRate, _finalRate)
555   {
556 
557   }
558 
559 }