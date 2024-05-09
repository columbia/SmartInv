1 pragma solidity ^0.4.13;
2 
3 /*
4 *
5 *  /$$       /$$$$$$$$ /$$   /$$ /$$$$$$$  /$$   /$$  /$$$$$$   /$$$$$$  /$$$$$$ /$$   /$$
6 * | $$      | $$_____/| $$$ | $$| $$__  $$| $$  / $$ /$$__  $$ /$$__  $$|_  $$_/| $$$ | $$
7 * | $$      | $$      | $$$$| $$| $$  \ $$|  $$/ $$/| $$  \__/| $$  \ $$  | $$  | $$$$| $$
8 * | $$      | $$$$$   | $$ $$ $$| $$  | $$ \  $$$$/ | $$      | $$  | $$  | $$  | $$ $$ $$
9 * | $$      | $$__/   | $$  $$$$| $$  | $$  >$$  $$ | $$      | $$  | $$  | $$  | $$  $$$$
10 * | $$      | $$      | $$\  $$$| $$  | $$ /$$/\  $$| $$    $$| $$  | $$  | $$  | $$\  $$$
11 * | $$$$$$$$| $$$$$$$$| $$ \  $$| $$$$$$$/| $$  \ $$|  $$$$$$/|  $$$$$$/ /$$$$$$| $$ \  $$
12 * |________/|________/|__/  \__/|_______/ |__/  |__/ \______/  \______/ |______/|__/  \__/
13 */
14 
15 
16 contract Crowdsale {
17   using SafeMath for uint256;
18   using SafeERC20 for ERC20;
19 
20   // The token being sold
21   ERC20 public token;
22 
23   // Address where funds are collected
24   address public wallet;
25 
26   // How many token units a buyer gets per wei.
27   // The rate is the conversion between wei and the smallest and indivisible token unit.
28   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
29   // 1 wei will give you 1 unit, or 0.001 TOK.
30   uint256 public rate;
31 
32   // Amount of wei raised
33   uint256 public weiRaised;
34 
35   /**
36    * Event for token purchase logging
37    * @param purchaser who paid for the tokens
38    * @param beneficiary who got the tokens
39    * @param value weis paid for purchase
40    * @param amount amount of tokens purchased
41    */
42   event TokenPurchase(
43     address indexed purchaser,
44     address indexed beneficiary,
45     uint256 value,
46     uint256 amount
47   );
48 
49   /**
50    * @param _rate Number of token units a buyer gets per wei
51    * @param _wallet Address where collected funds will be forwarded to
52    * @param _token Address of the token being sold
53    */
54   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
55     require(_rate > 0);
56     require(_wallet != address(0));
57     require(_token != address(0));
58 
59     rate = _rate;
60     wallet = _wallet;
61     token = _token;
62   }
63 
64   // -----------------------------------------
65   // Crowdsale external interface
66   // -----------------------------------------
67 
68   /**
69    * @dev fallback function ***DO NOT OVERRIDE***
70    */
71   function () external payable {
72     buyTokens(msg.sender);
73   }
74 
75   /**
76    * @dev low level token purchase ***DO NOT OVERRIDE***
77    * @param _beneficiary Address performing the token purchase
78    */
79   function buyTokens(address _beneficiary) public payable {
80 
81     uint256 weiAmount = msg.value;
82     _preValidatePurchase(_beneficiary, weiAmount);
83 
84     // calculate token amount to be created
85     uint256 tokens = _getTokenAmount(weiAmount);
86 
87     // update state
88     weiRaised = weiRaised.add(weiAmount);
89 
90     _processPurchase(_beneficiary, tokens);
91     emit TokenPurchase(
92       msg.sender,
93       _beneficiary,
94       weiAmount,
95       tokens
96     );
97 
98     _updatePurchasingState(_beneficiary, weiAmount);
99 
100     _forwardFunds();
101     _postValidatePurchase(_beneficiary, weiAmount);
102   }
103 
104   // -----------------------------------------
105   // Internal interface (extensible)
106   // -----------------------------------------
107 
108   /**
109    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
110    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
111    *   super._preValidatePurchase(_beneficiary, _weiAmount);
112    *   require(weiRaised.add(_weiAmount) <= cap);
113    * @param _beneficiary Address performing the token purchase
114    * @param _weiAmount Value in wei involved in the purchase
115    */
116   function _preValidatePurchase(
117     address _beneficiary,
118     uint256 _weiAmount
119   )
120     internal
121   {
122     require(_beneficiary != address(0));
123     require(_weiAmount != 0);
124   }
125 
126   /**
127    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
128    * @param _beneficiary Address performing the token purchase
129    * @param _weiAmount Value in wei involved in the purchase
130    */
131   function _postValidatePurchase(
132     address _beneficiary,
133     uint256 _weiAmount
134   )
135     internal
136   {
137     // optional override
138   }
139 
140   /**
141    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
142    * @param _beneficiary Address performing the token purchase
143    * @param _tokenAmount Number of tokens to be emitted
144    */
145   function _deliverTokens(
146     address _beneficiary,
147     uint256 _tokenAmount
148   )
149     internal
150   {
151     token.safeTransfer(_beneficiary, _tokenAmount);
152   }
153 
154   /**
155    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
156    * @param _beneficiary Address receiving the tokens
157    * @param _tokenAmount Number of tokens to be purchased
158    */
159   function _processPurchase(
160     address _beneficiary,
161     uint256 _tokenAmount
162   )
163     internal
164   {
165     _deliverTokens(_beneficiary, _tokenAmount);
166   }
167 
168   /**
169    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
170    * @param _beneficiary Address receiving the tokens
171    * @param _weiAmount Value in wei involved in the purchase
172    */
173   function _updatePurchasingState(
174     address _beneficiary,
175     uint256 _weiAmount
176   )
177     internal
178   {
179     // optional override
180   }
181 
182   /**
183    * @dev Override to extend the way in which ether is converted to tokens.
184    * @param _weiAmount Value in wei to be converted into tokens
185    * @return Number of tokens that can be purchased with the specified _weiAmount
186    */
187   function _getTokenAmount(uint256 _weiAmount)
188     internal view returns (uint256)
189   {
190     return _weiAmount.mul(rate);
191   }
192 
193   /**
194    * @dev Determines how ETH is stored/forwarded on purchases.
195    */
196   function _forwardFunds() internal {
197     wallet.transfer(msg.value);
198   }
199 }
200 
201 contract MintedCrowdsale is Crowdsale {
202 
203   /**
204    * @dev Overrides delivery by minting tokens upon purchase.
205    * @param _beneficiary Token purchaser
206    * @param _tokenAmount Number of tokens to be minted
207    */
208   function _deliverTokens(
209     address _beneficiary,
210     uint256 _tokenAmount
211   )
212     internal
213   {
214     // Potentially dangerous assumption about the type of the token.
215     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
216   }
217 }
218 
219 contract CappedCrowdsale is Crowdsale {
220   using SafeMath for uint256;
221 
222   uint256 public cap;
223 
224   /**
225    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
226    * @param _cap Max amount of wei to be contributed
227    */
228   constructor(uint256 _cap) public {
229     require(_cap > 0);
230     cap = _cap;
231   }
232 
233   /**
234    * @dev Checks whether the cap has been reached.
235    * @return Whether the cap was reached
236    */
237   function capReached() public view returns (bool) {
238     return weiRaised >= cap;
239   }
240 
241   /**
242    * @dev Extend parent behavior requiring purchase to respect the funding cap.
243    * @param _beneficiary Token purchaser
244    * @param _weiAmount Amount of wei contributed
245    */
246   function _preValidatePurchase(
247     address _beneficiary,
248     uint256 _weiAmount
249   )
250     internal
251   {
252     super._preValidatePurchase(_beneficiary, _weiAmount);
253     require(weiRaised.add(_weiAmount) <= cap);
254   }
255 
256 }
257 
258 contract TimedCrowdsale is Crowdsale {
259   using SafeMath for uint256;
260 
261   uint256 public openingTime;
262   uint256 public closingTime;
263 
264   /**
265    * @dev Reverts if not in crowdsale time range.
266    */
267   modifier onlyWhileOpen {
268     // solium-disable-next-line security/no-block-members
269     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
270     _;
271   }
272 
273   /**
274    * @dev Constructor, takes crowdsale opening and closing times.
275    * @param _openingTime Crowdsale opening time
276    * @param _closingTime Crowdsale closing time
277    */
278   constructor(uint256 _openingTime, uint256 _closingTime) public {
279     // solium-disable-next-line security/no-block-members
280     require(_openingTime >= block.timestamp);
281     require(_closingTime >= _openingTime);
282 
283     openingTime = _openingTime;
284     closingTime = _closingTime;
285   }
286 
287   /**
288    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
289    * @return Whether crowdsale period has elapsed
290    */
291   function hasClosed() public view returns (bool) {
292     // solium-disable-next-line security/no-block-members
293     return block.timestamp > closingTime;
294   }
295 
296   /**
297    * @dev Extend parent behavior requiring to be within contributing period
298    * @param _beneficiary Token purchaser
299    * @param _weiAmount Amount of wei contributed
300    */
301   function _preValidatePurchase(
302     address _beneficiary,
303     uint256 _weiAmount
304   )
305     internal
306     onlyWhileOpen
307   {
308     super._preValidatePurchase(_beneficiary, _weiAmount);
309   }
310 
311 }
312 
313 library SafeMath {
314 
315   /**
316   * @dev Multiplies two numbers, throws on overflow.
317   */
318   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
319     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
320     // benefit is lost if 'b' is also tested.
321     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
322     if (_a == 0) {
323       return 0;
324     }
325 
326     c = _a * _b;
327     assert(c / _a == _b);
328     return c;
329   }
330 
331   /**
332   * @dev Integer division of two numbers, truncating the quotient.
333   */
334   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
335     // assert(_b > 0); // Solidity automatically throws when dividing by 0
336     // uint256 c = _a / _b;
337     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
338     return _a / _b;
339   }
340 
341   /**
342   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
343   */
344   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
345     assert(_b <= _a);
346     return _a - _b;
347   }
348 
349   /**
350   * @dev Adds two numbers, throws on overflow.
351   */
352   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
353     c = _a + _b;
354     assert(c >= _a);
355     return c;
356   }
357 }
358 
359 contract Ownable {
360   address public owner;
361 
362 
363   event OwnershipRenounced(address indexed previousOwner);
364   event OwnershipTransferred(
365     address indexed previousOwner,
366     address indexed newOwner
367   );
368 
369 
370   /**
371    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
372    * account.
373    */
374   constructor() public {
375     owner = msg.sender;
376   }
377 
378   /**
379    * @dev Throws if called by any account other than the owner.
380    */
381   modifier onlyOwner() {
382     require(msg.sender == owner);
383     _;
384   }
385 
386   /**
387    * @dev Allows the current owner to relinquish control of the contract.
388    * @notice Renouncing to ownership will leave the contract without an owner.
389    * It will not be possible to call the functions with the `onlyOwner`
390    * modifier anymore.
391    */
392   function renounceOwnership() public onlyOwner {
393     emit OwnershipRenounced(owner);
394     owner = address(0);
395   }
396 
397   /**
398    * @dev Allows the current owner to transfer control of the contract to a newOwner.
399    * @param _newOwner The address to transfer ownership to.
400    */
401   function transferOwnership(address _newOwner) public onlyOwner {
402     _transferOwnership(_newOwner);
403   }
404 
405   /**
406    * @dev Transfers control of the contract to a newOwner.
407    * @param _newOwner The address to transfer ownership to.
408    */
409   function _transferOwnership(address _newOwner) internal {
410     require(_newOwner != address(0));
411     emit OwnershipTransferred(owner, _newOwner);
412     owner = _newOwner;
413   }
414 }
415 
416 contract DailyLimitCrowdsale is TimedCrowdsale, Ownable {
417 
418     uint256 public dailyLimit; // all users
419     uint256 public stageLimit; // all users
420     uint256 public minDailyPerUser;
421     uint256 public maxDailyPerUser;
422 
423     // today's index => who => value
424     mapping(uint256 => mapping(address => uint256)) public userSpending;
425     // all users
426     mapping(uint256 => uint256) public totalSpending;
427 
428     uint256 public stageSpending;
429     /**
430      * @dev Constructor that sets the passed value as a dailyLimit.
431      * @param _minDailyPerUser uint256 to represent the min cap / day / user.
432      * @param _maxDailyPerUser uint256 to represent the max cap / day/ user.
433      * @param _dailyLimit uint256 to represent the daily limit of all users.
434      * @param _stageLimit uint256 to represent the stage limit of all users.
435      */
436     constructor(uint256 _minDailyPerUser, uint256 _maxDailyPerUser, uint256 _dailyLimit, uint256 _stageLimit)
437     public {
438         minDailyPerUser = _minDailyPerUser;
439         maxDailyPerUser = _maxDailyPerUser;
440         dailyLimit = _dailyLimit;
441         stageLimit = _stageLimit;
442         stageSpending = 0;
443     }
444 
445     function setTime(uint256 _openingTime, uint256 _closingTime)
446     onlyOwner
447     public {
448         require(_closingTime >= _openingTime);
449         openingTime = _openingTime;
450         closingTime = _closingTime;
451     }
452 
453     /**
454      * @dev sets the daily limit. Does not alter the amount already spent today.
455      * @param _value uint256 to represent the new limit.
456      */
457     function _setDailyLimit(uint256 _value) internal {
458         dailyLimit = _value;
459     }
460 
461     function _setMinDailyPerUser(uint256 _value) internal {
462         minDailyPerUser = _value;
463     }
464 
465     function _setMaxDailyPerUser(uint256 _value) internal {
466         maxDailyPerUser = _value;
467     }
468 
469     function _setStageLimit(uint256 _value) internal {
470         stageLimit = _value;
471     }
472 
473 
474     /**
475      * @dev Checks to see if there is enough resource to spend today. If true, the resource may be expended.
476      * @param _value uint256 representing the amount of resource to spend.
477      * @return A boolean that is True if the resource was spent and false otherwise.
478      */
479 
480     function underLimit(address who, uint256 _value) internal returns (bool) {
481         require(stageLimit > 0);
482         require(minDailyPerUser > 0);
483         require(maxDailyPerUser > 0);
484         require(_value >= minDailyPerUser);
485         require(_value <= maxDailyPerUser);
486         uint256 _key = today();
487         require(userSpending[_key][who] + _value >= userSpending[_key][who] && userSpending[_key][who] + _value <= maxDailyPerUser);
488         if (dailyLimit > 0) {
489             require(totalSpending[_key] + _value >= totalSpending[_key] && totalSpending[_key] + _value <= dailyLimit);
490         }
491         require(stageSpending + _value >= stageSpending && stageSpending + _value <= stageLimit);
492         totalSpending[_key] += _value;
493         userSpending[_key][who] += _value;
494         stageSpending += _value;
495         return true;
496     }
497 
498     /**
499      * @dev Private function to determine today's index
500      * @return uint256 of today's index.
501      */
502     function today() private view returns (uint256) {
503         return now / 1 days;
504     }
505 
506     modifier limitedDaily(address who, uint256 _value) {
507         require(underLimit(who, _value));
508         _;
509     }
510     // ===============================
511     function _preValidatePurchase(
512         address _beneficiary,
513         uint256 _weiAmount
514     )
515     limitedDaily(_beneficiary, _weiAmount)
516     internal
517     {
518         super._preValidatePurchase(_beneficiary, _weiAmount);
519     }
520 
521     function _deliverTokens(
522         address _beneficiary,
523         uint256 _tokenAmount
524     )
525     internal
526     {
527         require(LendToken(token).deliver(_beneficiary, _tokenAmount));
528     }
529 }
530 
531 contract LendContract is MintedCrowdsale, DailyLimitCrowdsale {
532 
533     // Fields:
534     enum CrowdsaleStage {
535         BT,         // Bounty
536         PS,         // Pre sale
537         TS_R1,      // Token sale round 1
538         TS_R2,      // Token sale round 2
539         TS_R3,      // Token sale round 3
540         EX,         // Exchange
541         P2P_EX      // P2P Exchange
542     }
543 
544     CrowdsaleStage public stage = CrowdsaleStage.PS; // By default it's Presale
545     // =============
546 
547     // Token Distribution
548     // =============================
549     uint256 public maxTokens = 120 * 1e6 * 1e18; // There will be total 120 million Tokens available for sale
550     uint256 public tokensForReserve = 50 * 1e6 * 1e18; // 50 million for the eco system reserve
551     uint256 public tokensForBounty = 1 * 1e6 * 1e18; // 1 million for token bounty will send from fund deposit address
552     uint256 public totalTokensForTokenSale = 49 * 1e6 * 1e18; // 49 million Tokens will be sold in Crowdsale
553     uint256 public totalTokensForSaleDuringPreSale = 20 * 1e6 * 1e18; // 20 million out of 6 million will be sold during PreSale
554     // ==============================
555     // Token Funding Rates
556     // ==============================
557     uint256 public constant PRESALE_RATE = 1070; // 1 ETH = 1070 xcoin
558     uint256 public constant ROUND_1_TOKENSALE_RATE = 535; // 1 ETH = 535 xcoin
559     uint256 public constant ROUND_2_TOKENSALE_RATE = 389; // 1 ETH = 389 xcoin
560     uint256 public constant ROUND_3_TOKENSALE_RATE = 306; // 1 ETH = 306 xcoin
561 
562     // ==============================
563     // Token Limit
564     // ==============================
565 
566     uint256 public constant PRESALE_MIN_DAILY_PER_USER = 5 * 1e18; // 5 ETH / user / day
567     uint256 public constant PRESALE_MAX_DAILY_PER_USER = 100 * 1e18; // 100 ETH / user / day
568 
569     uint256 public constant TOKENSALE_MIN_DAILY_PER_USER = 0.1 * 1e18; // 0.1 ETH / user / day
570     uint256 public constant TOKENSALE_MAX_DAILY_PER_USER = 10 * 1e18; // 10 ETH / user / day
571 
572 
573     uint256 public constant ROUND_1_TOKENSALE_LIMIT_PER_DAY = 1.5 * 1e6 * 1e18; //1.5M xcoin all users
574     uint256 public constant ROUND_1_TOKENSALE_LIMIT = 15 * 1e6 * 1e18; //15M xcoin all users
575 
576     uint256 public constant ROUND_2_TOKENSALE_LIMIT_PER_DAY = 1.5 * 1e6 * 1e18; //1.5M xcoin all users
577     uint256 public constant ROUND_2_TOKENSALE_LIMIT = 15 * 1e6 * 1e18; //15M xcoin all users
578 
579     uint256 public constant ROUND_3_TOKENSALE_LIMIT_PER_DAY = 1.9 * 1e6 * 1e18; //1.9M xcoin all users
580     uint256 public constant ROUND_3_TOKENSALE_LIMIT = 19 * 1e6 * 1e18; //19M xcoin all users
581 
582     // ===================
583     bool public crowdsaleStarted = true;
584     bool public crowdsalePaused = false;
585     // Events
586     event EthTransferred(string text);
587     event EthRefunded(string text);
588 
589     function LendContract
590     (
591         uint256 _openingTime,
592         uint256 _closingTime,
593         uint256 _rate,
594         address _wallet,
595         uint256 _minDailyPerUser,
596         uint256 _maxDailyPerUser,
597         uint256 _dailyLimit,
598         uint256 _stageLimit,
599         MintableToken _token
600     )
601     public
602     DailyLimitCrowdsale(_minDailyPerUser, _maxDailyPerUser, _dailyLimit, _stageLimit)
603     Crowdsale(_rate, _wallet, _token)
604     TimedCrowdsale(_openingTime, _closingTime) {
605 
606     }
607     function setCrowdsaleStage(uint value) public onlyOwner {
608         require(value > uint(CrowdsaleStage.BT) && value < uint(CrowdsaleStage.EX));
609         CrowdsaleStage _stage;
610         if (uint(CrowdsaleStage.PS) == value) {
611             _stage = CrowdsaleStage.PS;
612             setCurrentRate(PRESALE_RATE);
613             setMinDailyPerUser(PRESALE_MIN_DAILY_PER_USER);
614             setMaxDailyPerUser(PRESALE_MAX_DAILY_PER_USER);
615             setStageLimit(totalTokensForSaleDuringPreSale);
616         } else if (uint(CrowdsaleStage.TS_R1) == value) {
617             _stage = CrowdsaleStage.TS_R2;
618             setCurrentRate(ROUND_1_TOKENSALE_RATE);
619             // update limit
620             setDailyLimit(ROUND_1_TOKENSALE_LIMIT_PER_DAY);
621             setMinDailyPerUser(TOKENSALE_MIN_DAILY_PER_USER);
622             setMaxDailyPerUser(TOKENSALE_MAX_DAILY_PER_USER);
623             setStageLimit(ROUND_1_TOKENSALE_LIMIT);
624         } else if (uint(CrowdsaleStage.TS_R2) == value) {
625             _stage = CrowdsaleStage.TS_R2;
626             setCurrentRate(ROUND_2_TOKENSALE_RATE);
627             // update limit
628             setDailyLimit(ROUND_2_TOKENSALE_LIMIT_PER_DAY);
629             setMinDailyPerUser(TOKENSALE_MIN_DAILY_PER_USER);
630             setMaxDailyPerUser(TOKENSALE_MAX_DAILY_PER_USER);
631             setStageLimit(ROUND_2_TOKENSALE_LIMIT);
632         } else if (uint(CrowdsaleStage.TS_R3) == value) {
633             _stage = CrowdsaleStage.TS_R3;
634             setCurrentRate(ROUND_2_TOKENSALE_RATE);
635             // update limit
636             setDailyLimit(ROUND_2_TOKENSALE_LIMIT_PER_DAY);
637             setMinDailyPerUser(TOKENSALE_MIN_DAILY_PER_USER);
638             setMaxDailyPerUser(TOKENSALE_MAX_DAILY_PER_USER);
639             setStageLimit(ROUND_3_TOKENSALE_LIMIT);
640         }
641         stage = _stage;
642     }
643 
644     // Change the current rate
645     function setCurrentRate(uint256 _rate) private {
646         rate = _rate;
647     }
648 
649     function setRate(uint256 _rate) public onlyOwner {
650         setCurrentRate(_rate);
651     }
652 
653     function setCrowdSale(bool _started) public onlyOwner {
654         crowdsaleStarted = _started;
655     }
656     // limit by user
657     function setDailyLimit(uint256 _value) public onlyOwner {
658         _setDailyLimit(_value);
659     }
660     function setMinDailyPerUser(uint256 _value) public onlyOwner {
661         _setMinDailyPerUser(_value);
662     }
663 
664     function setMaxDailyPerUser(uint256 _value) public onlyOwner {
665         _setMaxDailyPerUser(_value);
666     }
667     function setStageLimit(uint256 _value) public onlyOwner {
668         _setStageLimit(_value);
669     }
670     function pauseCrowdsale() public onlyOwner {
671         crowdsalePaused = true;
672     }
673 
674     function unPauseCrowdsale() public onlyOwner {
675         crowdsalePaused = false;
676     }
677     // ===========================
678     // Finish: Mint Extra Tokens as needed before finalizing the Crowdsale.
679     // ====================================================================
680 
681     function finish(address _reserveFund) public onlyOwner {
682         if (crowdsaleStarted) {
683             uint256 alreadyMinted = token.totalSupply();
684             require(alreadyMinted < maxTokens);
685 
686             uint256 unsoldTokens = totalTokensForTokenSale - alreadyMinted;
687             if (unsoldTokens > 0) {
688                 tokensForReserve = tokensForReserve + unsoldTokens;
689             }
690             MintableToken(token).mint(_reserveFund, tokensForReserve);
691             crowdsaleStarted = false;
692         }
693     }
694 
695 }
696 
697 contract ERC20Basic {
698   function totalSupply() public view returns (uint256);
699   function balanceOf(address _who) public view returns (uint256);
700   function transfer(address _to, uint256 _value) public returns (bool);
701   event Transfer(address indexed from, address indexed to, uint256 value);
702 }
703 
704 contract BasicToken is ERC20Basic {
705   using SafeMath for uint256;
706 
707   mapping(address => uint256) internal balances;
708 
709   uint256 internal totalSupply_;
710 
711   /**
712   * @dev Total number of tokens in existence
713   */
714   function totalSupply() public view returns (uint256) {
715     return totalSupply_;
716   }
717 
718   /**
719   * @dev Transfer token for a specified address
720   * @param _to The address to transfer to.
721   * @param _value The amount to be transferred.
722   */
723   function transfer(address _to, uint256 _value) public returns (bool) {
724     require(_value <= balances[msg.sender]);
725     require(_to != address(0));
726 
727     balances[msg.sender] = balances[msg.sender].sub(_value);
728     balances[_to] = balances[_to].add(_value);
729     emit Transfer(msg.sender, _to, _value);
730     return true;
731   }
732 
733   /**
734   * @dev Gets the balance of the specified address.
735   * @param _owner The address to query the the balance of.
736   * @return An uint256 representing the amount owned by the passed address.
737   */
738   function balanceOf(address _owner) public view returns (uint256) {
739     return balances[_owner];
740   }
741 
742 }
743 
744 contract ERC20 is ERC20Basic {
745   function allowance(address _owner, address _spender)
746     public view returns (uint256);
747 
748   function transferFrom(address _from, address _to, uint256 _value)
749     public returns (bool);
750 
751   function approve(address _spender, uint256 _value) public returns (bool);
752   event Approval(
753     address indexed owner,
754     address indexed spender,
755     uint256 value
756   );
757 }
758 
759 library SafeERC20 {
760   function safeTransfer(
761     ERC20Basic _token,
762     address _to,
763     uint256 _value
764   )
765     internal
766   {
767     require(_token.transfer(_to, _value));
768   }
769 
770   function safeTransferFrom(
771     ERC20 _token,
772     address _from,
773     address _to,
774     uint256 _value
775   )
776     internal
777   {
778     require(_token.transferFrom(_from, _to, _value));
779   }
780 
781   function safeApprove(
782     ERC20 _token,
783     address _spender,
784     uint256 _value
785   )
786     internal
787   {
788     require(_token.approve(_spender, _value));
789   }
790 }
791 
792 contract StandardToken is ERC20, BasicToken {
793 
794   mapping (address => mapping (address => uint256)) internal allowed;
795 
796 
797   /**
798    * @dev Transfer tokens from one address to another
799    * @param _from address The address which you want to send tokens from
800    * @param _to address The address which you want to transfer to
801    * @param _value uint256 the amount of tokens to be transferred
802    */
803   function transferFrom(
804     address _from,
805     address _to,
806     uint256 _value
807   )
808     public
809     returns (bool)
810   {
811     require(_value <= balances[_from]);
812     require(_value <= allowed[_from][msg.sender]);
813     require(_to != address(0));
814 
815     balances[_from] = balances[_from].sub(_value);
816     balances[_to] = balances[_to].add(_value);
817     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
818     emit Transfer(_from, _to, _value);
819     return true;
820   }
821 
822   /**
823    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
824    * Beware that changing an allowance with this method brings the risk that someone may use both the old
825    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
826    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
827    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
828    * @param _spender The address which will spend the funds.
829    * @param _value The amount of tokens to be spent.
830    */
831   function approve(address _spender, uint256 _value) public returns (bool) {
832     allowed[msg.sender][_spender] = _value;
833     emit Approval(msg.sender, _spender, _value);
834     return true;
835   }
836 
837   /**
838    * @dev Function to check the amount of tokens that an owner allowed to a spender.
839    * @param _owner address The address which owns the funds.
840    * @param _spender address The address which will spend the funds.
841    * @return A uint256 specifying the amount of tokens still available for the spender.
842    */
843   function allowance(
844     address _owner,
845     address _spender
846    )
847     public
848     view
849     returns (uint256)
850   {
851     return allowed[_owner][_spender];
852   }
853 
854   /**
855    * @dev Increase the amount of tokens that an owner allowed to a spender.
856    * approve should be called when allowed[_spender] == 0. To increment
857    * allowed value is better to use this function to avoid 2 calls (and wait until
858    * the first transaction is mined)
859    * From MonolithDAO Token.sol
860    * @param _spender The address which will spend the funds.
861    * @param _addedValue The amount of tokens to increase the allowance by.
862    */
863   function increaseApproval(
864     address _spender,
865     uint256 _addedValue
866   )
867     public
868     returns (bool)
869   {
870     allowed[msg.sender][_spender] = (
871       allowed[msg.sender][_spender].add(_addedValue));
872     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
873     return true;
874   }
875 
876   /**
877    * @dev Decrease the amount of tokens that an owner allowed to a spender.
878    * approve should be called when allowed[_spender] == 0. To decrement
879    * allowed value is better to use this function to avoid 2 calls (and wait until
880    * the first transaction is mined)
881    * From MonolithDAO Token.sol
882    * @param _spender The address which will spend the funds.
883    * @param _subtractedValue The amount of tokens to decrease the allowance by.
884    */
885   function decreaseApproval(
886     address _spender,
887     uint256 _subtractedValue
888   )
889     public
890     returns (bool)
891   {
892     uint256 oldValue = allowed[msg.sender][_spender];
893     if (_subtractedValue >= oldValue) {
894       allowed[msg.sender][_spender] = 0;
895     } else {
896       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
897     }
898     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
899     return true;
900   }
901 
902 }
903 
904 contract MintableToken is StandardToken, Ownable {
905   event Mint(address indexed to, uint256 amount);
906   event MintFinished();
907 
908   bool public mintingFinished = false;
909 
910 
911   modifier canMint() {
912     require(!mintingFinished);
913     _;
914   }
915 
916   modifier hasMintPermission() {
917     require(msg.sender == owner);
918     _;
919   }
920 
921   /**
922    * @dev Function to mint tokens
923    * @param _to The address that will receive the minted tokens.
924    * @param _amount The amount of tokens to mint.
925    * @return A boolean that indicates if the operation was successful.
926    */
927   function mint(
928     address _to,
929     uint256 _amount
930   )
931     public
932     hasMintPermission
933     canMint
934     returns (bool)
935   {
936     totalSupply_ = totalSupply_.add(_amount);
937     balances[_to] = balances[_to].add(_amount);
938     emit Mint(_to, _amount);
939     emit Transfer(address(0), _to, _amount);
940     return true;
941   }
942 
943   /**
944    * @dev Function to stop minting new tokens.
945    * @return True if the operation was successful.
946    */
947   function finishMinting() public onlyOwner canMint returns (bool) {
948     mintingFinished = true;
949     emit MintFinished();
950     return true;
951   }
952 }
953 
954 contract LendToken is MintableToken {
955     string public name = "LENDXCOIN";
956     string public symbol = "XCOIN";
957     uint8 public decimals = 18;
958     address public contractAddress;
959     uint256 public fee;
960 
961     uint256 public constant FEE_TRANSFER = 5 * 1e15; // 0.005 xcoin
962 
963     uint256 public constant INITIAL_SUPPLY = 51 * 1e6 * (10 ** uint256(decimals)); // 50M + 1M bounty
964 
965     // Events
966     event ChangedFee(address who, uint256 newFee);
967 
968     /**
969      * @dev Constructor that gives msg.sender all of existing tokens.
970      */
971     function LendToken() public {
972         totalSupply_ = INITIAL_SUPPLY;
973         balances[msg.sender] = INITIAL_SUPPLY;
974         fee = FEE_TRANSFER;
975     }
976 
977     function setContractAddress(address _contractAddress) external onlyOwner {
978         if (_contractAddress != address(0)) {
979             contractAddress = _contractAddress;
980         }
981     }
982 
983     function deliver(
984         address _beneficiary,
985         uint256 _tokenAmount
986     )
987     public
988     returns (bool success)
989     {
990         require(_tokenAmount > 0);
991         require(msg.sender == contractAddress);
992         balances[_beneficiary] += _tokenAmount;
993         totalSupply_ += _tokenAmount;
994         return true;
995     }
996 
997     function transfer(address _to, uint256 _value) public returns (bool) {
998         if (msg.sender == owner) {
999             return super.transfer(_to, _value);
1000         } else {
1001             require(fee <= balances[msg.sender]);
1002             balances[owner] = balances[owner].add(fee);
1003             balances[msg.sender] = balances[msg.sender].sub(fee);
1004             return super.transfer(_to, _value - fee);
1005         }
1006     }
1007 
1008     function setFee(uint256 _fee)
1009     onlyOwner
1010     public
1011     {
1012         fee = _fee;
1013         emit ChangedFee(msg.sender, _fee);
1014     }
1015 
1016 }