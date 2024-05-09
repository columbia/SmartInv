1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender)
138     public view returns (uint256);
139 
140   function transferFrom(address from, address to, uint256 value)
141     public returns (bool);
142 
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(
145     address indexed owner,
146     address indexed spender,
147     uint256 value
148   );
149 }
150 
151 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
152 
153 /**
154  * @title Crowdsale
155  * @dev Crowdsale is a base contract for managing a token crowdsale,
156  * allowing investors to purchase tokens with ether. This contract implements
157  * such functionality in its most fundamental form and can be extended to provide additional
158  * functionality and/or custom behavior.
159  * The external interface represents the basic interface for purchasing tokens, and conform
160  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
161  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
162  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
163  * behavior.
164  */
165 contract Crowdsale {
166   using SafeMath for uint256;
167 
168   // The token being sold
169   ERC20 public token;
170 
171   // Address where funds are collected
172   address public wallet;
173 
174   // How many token units a buyer gets per wei.
175   // The rate is the conversion between wei and the smallest and indivisible token unit.
176   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
177   // 1 wei will give you 1 unit, or 0.001 TOK.
178   uint256 public rate;
179 
180   // Amount of wei raised
181   uint256 public weiRaised;
182 
183   /**
184    * Event for token purchase logging
185    * @param purchaser who paid for the tokens
186    * @param beneficiary who got the tokens
187    * @param value weis paid for purchase
188    * @param amount amount of tokens purchased
189    */
190   event TokenPurchase(
191     address indexed purchaser,
192     address indexed beneficiary,
193     uint256 value,
194     uint256 amount
195   );
196 
197   /**
198    * @param _rate Number of token units a buyer gets per wei
199    * @param _wallet Address where collected funds will be forwarded to
200    * @param _token Address of the token being sold
201    */
202   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
203     require(_rate > 0);
204     require(_wallet != address(0));
205     require(_token != address(0));
206 
207     rate = _rate;
208     wallet = _wallet;
209     token = _token;
210   }
211 
212   // -----------------------------------------
213   // Crowdsale external interface
214   // -----------------------------------------
215 
216   /**
217    * @dev fallback function ***DO NOT OVERRIDE***
218    */
219   function () external payable {
220     buyTokens(msg.sender);
221   }
222 
223   /**
224    * @dev low level token purchase ***DO NOT OVERRIDE***
225    * @param _beneficiary Address performing the token purchase
226    */
227   function buyTokens(address _beneficiary) public payable {
228 
229     uint256 weiAmount = msg.value;
230     _preValidatePurchase(_beneficiary, weiAmount);
231 
232     // calculate token amount to be created
233     uint256 tokens = _getTokenAmount(weiAmount);
234 
235     // update state
236     weiRaised = weiRaised.add(weiAmount);
237 
238     _processPurchase(_beneficiary, tokens);
239     emit TokenPurchase(
240       msg.sender,
241       _beneficiary,
242       weiAmount,
243       tokens
244     );
245 
246     _updatePurchasingState(_beneficiary, weiAmount);
247 
248     _forwardFunds();
249     _postValidatePurchase(_beneficiary, weiAmount);
250   }
251 
252   // -----------------------------------------
253   // Internal interface (extensible)
254   // -----------------------------------------
255 
256   /**
257    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
258    * @param _beneficiary Address performing the token purchase
259    * @param _weiAmount Value in wei involved in the purchase
260    */
261   function _preValidatePurchase(
262     address _beneficiary,
263     uint256 _weiAmount
264   )
265     internal
266   {
267     require(_beneficiary != address(0));
268     require(_weiAmount != 0);
269   }
270 
271   /**
272    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
273    * @param _beneficiary Address performing the token purchase
274    * @param _weiAmount Value in wei involved in the purchase
275    */
276   function _postValidatePurchase(
277     address _beneficiary,
278     uint256 _weiAmount
279   )
280     internal
281   {
282     // optional override
283   }
284 
285   /**
286    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
287    * @param _beneficiary Address performing the token purchase
288    * @param _tokenAmount Number of tokens to be emitted
289    */
290   function _deliverTokens(
291     address _beneficiary,
292     uint256 _tokenAmount
293   )
294     internal
295   {
296     token.transfer(_beneficiary, _tokenAmount);
297   }
298 
299   /**
300    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
301    * @param _beneficiary Address receiving the tokens
302    * @param _tokenAmount Number of tokens to be purchased
303    */
304   function _processPurchase(
305     address _beneficiary,
306     uint256 _tokenAmount
307   )
308     internal
309   {
310     _deliverTokens(_beneficiary, _tokenAmount);
311   }
312 
313   /**
314    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
315    * @param _beneficiary Address receiving the tokens
316    * @param _weiAmount Value in wei involved in the purchase
317    */
318   function _updatePurchasingState(
319     address _beneficiary,
320     uint256 _weiAmount
321   )
322     internal
323   {
324     // optional override
325   }
326 
327   /**
328    * @dev Override to extend the way in which ether is converted to tokens.
329    * @param _weiAmount Value in wei to be converted into tokens
330    * @return Number of tokens that can be purchased with the specified _weiAmount
331    */
332   function _getTokenAmount(uint256 _weiAmount)
333     internal view returns (uint256)
334   {
335     return _weiAmount.mul(rate);
336   }
337 
338   /**
339    * @dev Determines how ETH is stored/forwarded on purchases.
340    */
341   function _forwardFunds() internal {
342     wallet.transfer(msg.value);
343   }
344 }
345 
346 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
347 
348 /**
349  * @title TimedCrowdsale
350  * @dev Crowdsale accepting contributions only within a time frame.
351  */
352 contract TimedCrowdsale is Crowdsale {
353   using SafeMath for uint256;
354 
355   uint256 public openingTime;
356   uint256 public closingTime;
357 
358   /**
359    * @dev Reverts if not in crowdsale time range.
360    */
361   modifier onlyWhileOpen {
362     // solium-disable-next-line security/no-block-members
363     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
364     _;
365   }
366 
367   /**
368    * @dev Constructor, takes crowdsale opening and closing times.
369    * @param _openingTime Crowdsale opening time
370    * @param _closingTime Crowdsale closing time
371    */
372   constructor(uint256 _openingTime, uint256 _closingTime) public {
373     // solium-disable-next-line security/no-block-members
374     require(_openingTime >= block.timestamp);
375     require(_closingTime >= _openingTime);
376 
377     openingTime = _openingTime;
378     closingTime = _closingTime;
379   }
380 
381   /**
382    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
383    * @return Whether crowdsale period has elapsed
384    */
385   function hasClosed() public view returns (bool) {
386     // solium-disable-next-line security/no-block-members
387     return block.timestamp > closingTime;
388   }
389 
390   /**
391    * @dev Extend parent behavior requiring to be within contributing period
392    * @param _beneficiary Token purchaser
393    * @param _weiAmount Amount of wei contributed
394    */
395   function _preValidatePurchase(
396     address _beneficiary,
397     uint256 _weiAmount
398   )
399     internal
400     onlyWhileOpen
401   {
402     super._preValidatePurchase(_beneficiary, _weiAmount);
403   }
404 
405 }
406 
407 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
408 
409 /**
410  * @title FinalizableCrowdsale
411  * @dev Extension of Crowdsale where an owner can do extra work
412  * after finishing.
413  */
414 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
415   using SafeMath for uint256;
416 
417   bool public isFinalized = false;
418 
419   event Finalized();
420 
421   /**
422    * @dev Must be called after crowdsale ends, to do some extra finalization
423    * work. Calls the contract's finalization function.
424    */
425   function finalize() onlyOwner public {
426     require(!isFinalized);
427     require(hasClosed());
428 
429     finalization();
430     emit Finalized();
431 
432     isFinalized = true;
433   }
434 
435   /**
436    * @dev Can be overridden to add finalization logic. The overriding function
437    * should call super.finalization() to ensure the chain of finalization is
438    * executed entirely.
439    */
440   function finalization() internal {
441   }
442 
443 }
444 
445 // File: contracts/crowdsale/StageCrowdsale.sol
446 
447 contract StageCrowdsale is FinalizableCrowdsale {
448     bool public previousStageIsFinalized = false;
449     StageCrowdsale public previousStage;
450 
451     constructor(
452         uint256 _rate,
453         address _wallet,
454         ERC20 _token,
455         uint256 _openingTime,
456         uint256 _closingTime,
457         StageCrowdsale _previousStage
458     )
459         public
460         Crowdsale(_rate, _wallet, _token)
461         TimedCrowdsale(_openingTime, _closingTime)
462     {
463         previousStage = _previousStage;
464         if (_previousStage == address(0)) {
465             previousStageIsFinalized = true;
466         }
467     }
468 
469     modifier isNotFinalized() {
470         require(!isFinalized, "Call on finalized.");
471         _;
472     }
473 
474     modifier previousIsFinalized() {
475         require(isPreviousStageFinalized(), "Call on previous stage finalized.");
476         _;
477     }
478 
479     function finalizeStage() public onlyOwner isNotFinalized {
480         _finalizeStage();
481     }
482 
483     function proxyBuyTokens(address _beneficiary) public payable {
484         uint256 weiAmount = msg.value;
485         _preValidatePurchase(_beneficiary, weiAmount);
486 
487         // calculate token amount to be created
488         uint256 tokens = _getTokenAmount(weiAmount);
489 
490         // update state
491         weiRaised = weiRaised.add(weiAmount);
492 
493         _processPurchase(_beneficiary, tokens);
494         // solium-disable-next-line security/no-tx-origin
495         emit TokenPurchase(tx.origin, _beneficiary, weiAmount, tokens);
496 
497         _updatePurchasingState(_beneficiary, weiAmount);
498 
499         _forwardFunds();
500         _postValidatePurchase(_beneficiary, weiAmount);
501     }
502 
503     function isPreviousStageFinalized() public returns (bool) {
504         if (previousStageIsFinalized) {
505             return true;
506         }
507         if (previousStage.isFinalized()) {
508             previousStageIsFinalized = true;
509         }
510         return previousStageIsFinalized;
511     }
512 
513     function _finalizeStage() internal isNotFinalized {
514         finalization();
515         emit Finalized();
516         isFinalized = true;
517     }
518 
519     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isNotFinalized previousIsFinalized {
520         super._preValidatePurchase(_beneficiary, _weiAmount);
521     }
522 }
523 
524 // File: contracts/crowdsale/MultiStageCrowdsale.sol
525 
526 contract MultiStageCrowdsale is Ownable {
527 
528     uint256 public currentStageIndex = 0;
529     StageCrowdsale[] public stages;
530 
531     event StageAdded();
532 
533     function () external payable {
534         buyTokens(msg.sender);
535     }
536 
537     modifier hasCurrentStage() {
538         require(currentStageIndex < stages.length);
539         _;
540     }
541 
542     modifier validBuyCall(address _beneficiary) {
543         require(_beneficiary != address(0));
544         require(msg.value != 0);
545         _;
546     }
547 
548     function addStageCrowdsale(address _stageCrowdsaleAddress) public onlyOwner {
549         require(_stageCrowdsaleAddress != address(0));
550         StageCrowdsale stageToBeAdded = StageCrowdsale(_stageCrowdsaleAddress);
551         if (stages.length > 0) {
552             require(stageToBeAdded.previousStage() != address(0));
553             StageCrowdsale lastStage = stages[stages.length - 1];
554             require(stageToBeAdded.openingTime() >= lastStage.closingTime());
555         }
556         stages.push(stageToBeAdded);
557         emit StageAdded();
558     }
559 
560     function buyTokens(address _beneficiary) public payable validBuyCall(_beneficiary) hasCurrentStage {
561         StageCrowdsale stage = updateCurrentStage();
562         stage.proxyBuyTokens.value(msg.value)(_beneficiary);
563         updateCurrentStage();
564     }
565 
566     function getCurrentStage() public view returns (StageCrowdsale) {
567         if (stages.length > 0) {
568             return stages[currentStageIndex];
569         }
570     }
571 
572     function updateCurrentStage() public returns (StageCrowdsale currentStage) {
573         if (currentStageIndex < stages.length) {
574             currentStage = stages[currentStageIndex];
575             while (currentStage.isFinalized() && currentStageIndex + 1 < stages.length) {
576                 currentStage = stages[++currentStageIndex];
577             }
578         }
579     }
580 }