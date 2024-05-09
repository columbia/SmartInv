1 pragma solidity ^0.4.24; 
2 
3 interface IToken {
4   function name() external view returns(string);
5 
6   function symbol() external view returns(string);
7 
8   function decimals() external view returns(uint8);
9 
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender) external view returns (uint256);
15 
16   function transfer(address to, uint256 value) external returns (bool);
17 
18   function approve(address spender, uint256 value) external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value) external returns (bool);
21 
22   function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
23 
24   function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
25 
26   function mint(address to, uint256 value) external returns (bool);
27 
28   function burn(address from, uint256 value) external returns (bool);
29 
30   function isMinter(address account) external returns (bool);
31 
32   event Transfer(
33     address indexed from,
34     address indexed to,
35     uint256 value
36   );
37 
38   event Approval(
39     address indexed owner,
40     address indexed spender,
41     uint256 value
42   );
43 
44   event Paused(address account);
45   event Unpaused(address account);
46 }
47  /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that revert on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, reverts on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
58     // benefit is lost if 'b' is also tested.
59     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
60     if (a == 0) {
61       return 0;
62     }
63 
64     uint256 c = a * b;
65     require(c / a == b);
66 
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
72   */
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b > 0); // Solidity only automatically asserts when dividing by 0
75     uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77 
78     return c;
79   }
80 
81   /**
82   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
83   */
84   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85     require(b <= a);
86     uint256 c = a - b;
87 
88     return c;
89   }
90 
91   /**
92   * @dev Adds two numbers, reverts on overflow.
93   */
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     require(c >= a);
97 
98     return c;
99   }
100 
101   /**
102   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
103   * reverts when dividing by zero.
104   */
105   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106     require(b != 0);
107     return a % b;
108   }
109 }
110 
111 library SafeERC20 {
112 
113   using SafeMath for uint256;
114 
115   function safeTransfer(
116     IToken token,
117     address to,
118     uint256 value
119   )
120     internal
121   {
122     require(token.transfer(to, value));
123   }
124 
125   function safeTransferFrom(
126     IToken token,
127     address from,
128     address to,
129     uint256 value
130   )
131     internal
132   {
133     require(token.transferFrom(from, to, value));
134   }
135 
136   function safeApprove(
137     IToken token,
138     address spender,
139     uint256 value
140   )
141     internal
142   {
143     // safeApprove should only be called when setting an initial allowance,
144     // or when resetting it to zero. To increase and decrease it, use
145     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
146     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
147     require(token.approve(spender, value));
148   }
149 
150   function safeIncreaseAllowance(
151     IToken token,
152     address spender,
153     uint256 value
154   )
155     internal
156   {
157     uint256 newAllowance = token.allowance(address(this), spender).add(value);
158     require(token.approve(spender, newAllowance));
159   }
160 
161   function safeDecreaseAllowance(
162     IToken token,
163     address spender,
164     uint256 value
165   )
166     internal
167   {
168     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
169     require(token.approve(spender, newAllowance));
170   }
171 }
172 
173 
174 
175 contract ReentrancyGuard {
176 
177   /// @dev counter to allow mutex lock with only one SSTORE operation
178   uint256 private _guardCounter;
179 
180   constructor() internal {
181     // The counter starts at one to prevent changing it from zero to a non-zero
182     // value, which is a more expensive operation.
183     _guardCounter = 1;
184   }
185 
186   /**
187    * @dev Prevents a contract from calling itself, directly or indirectly.
188    * Calling a `nonReentrant` function from another `nonReentrant`
189    * function is not supported. It is possible to prevent this from happening
190    * by making the `nonReentrant` function external, and make it call a
191    * `private` function that does the actual work.
192    */
193   modifier nonReentrant() {
194     _guardCounter += 1;
195     uint256 localCounter = _guardCounter;
196     _;
197     require(localCounter == _guardCounter);
198   }
199 
200 }
201 
202 contract Crowdsale is ReentrancyGuard {
203   using SafeMath for uint256;
204   using SafeERC20 for IToken;
205 
206   // The token being sold
207   IToken private _token;
208 
209   // Address where funds are collected
210   address private _wallet;
211 
212   // How many token units a buyer gets per wei.
213   // The rate is the conversion between wei and the smallest and indivisible token unit.
214   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
215   // 1 wei will give you 1 unit, or 0.001 TOK.
216   uint256 private _rate;
217 
218   // Amount of wei raised
219   uint256 private _weiRaised;
220 
221   /**
222    * Event for token purchase logging
223    * @param purchaser who paid for the tokens
224    * @param beneficiary who got the tokens
225    * @param value weis paid for purchase
226    * @param amount amount of tokens purchased
227    */
228   event TokensPurchased(
229     address indexed purchaser,
230     address indexed beneficiary,
231     uint256 value,
232     uint256 amount
233   );
234 
235   /**
236    * @param rate Number of token units a buyer gets per wei
237    * @dev The rate is the conversion between wei and the smallest and indivisible
238    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
239    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
240    * @param wallet Address where collected funds will be forwarded to
241    * @param token Address of the token being sold
242    */
243   constructor(uint256 rate, address wallet, IToken token) internal {
244     require(rate > 0);
245     require(wallet != address(0));
246     require(token != address(0));
247 
248     _rate = rate;
249     _wallet = wallet;
250     _token = token;
251   }
252 
253   // -----------------------------------------
254   // Crowdsale external interface
255   // -----------------------------------------
256 
257   /**
258    * @dev fallback function ***DO NOT OVERRIDE***
259    * Note that other contracts will transfer fund with a base gas stipend
260    * of 2300, which is not enough to call buyTokens. Consider calling
261    * buyTokens directly when purchasing tokens from a contract.
262    */
263   function () external payable {
264     buyTokens(msg.sender);
265   }
266 
267   /**
268    * @return the token being sold.
269    */
270   function token() public view returns(IToken) {
271     return _token;
272   }
273 
274   /**
275    * @return the address where funds are collected.
276    */
277   function wallet() public view returns(address) {
278     return _wallet;
279   }
280 
281   /**
282    * @return the number of token units a buyer gets per wei.
283    */
284   function rate() public view returns(uint256) {
285     return _rate;
286   }
287 
288   /**
289    * @return the amount of wei raised.
290    */
291   function weiRaised() public view returns (uint256) {
292     return _weiRaised;
293   }
294 
295   /**
296    * @dev low level token purchase ***DO NOT OVERRIDE***
297    * This function has a non-reentrancy guard, so it shouldn't be called by
298    * another `nonReentrant` function.
299    * @param beneficiary Recipient of the token purchase
300    */
301   function buyTokens(address beneficiary) public nonReentrant payable {
302 
303     uint256 weiAmount = msg.value;
304     _preValidatePurchase(beneficiary, weiAmount);
305 
306     // calculate token amount to be created
307     uint256 tokens = _getTokenAmount(weiAmount);
308 
309     // update state
310     _weiRaised = _weiRaised.add(weiAmount);
311 
312     _processPurchase(beneficiary, tokens);
313     emit TokensPurchased(
314       msg.sender,
315       beneficiary,
316       weiAmount,
317       tokens
318     );
319 
320     _updatePurchasingState(beneficiary, weiAmount);
321 
322     _forwardFunds();
323     _postValidatePurchase(beneficiary, weiAmount);
324   }
325 
326   // -----------------------------------------
327   // Internal interface (extensible)
328   // -----------------------------------------
329 
330   /**
331    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
332    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
333    *   super._preValidatePurchase(beneficiary, weiAmount);
334    *   require(weiRaised().add(weiAmount) <= cap);
335    * @param beneficiary Address performing the token purchase
336    * @param weiAmount Value in wei involved in the purchase
337    */
338   function _preValidatePurchase(
339     address beneficiary,
340     uint256 weiAmount
341   )
342     internal
343     view
344   {
345     require(beneficiary != address(0));
346     require(weiAmount != 0);
347   }
348 
349   /**
350    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
351    * @param beneficiary Address performing the token purchase
352    * @param weiAmount Value in wei involved in the purchase
353    */
354   function _postValidatePurchase(
355     address beneficiary,
356     uint256 weiAmount
357   )
358     internal
359     view
360   {
361     // optional override
362   }
363 
364   /**
365    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
366    * @param beneficiary Address performing the token purchase
367    * @param tokenAmount Number of tokens to be emitted
368    */
369   function _deliverTokens(
370     address beneficiary,
371     uint256 tokenAmount
372   )
373     internal
374   {
375     _token.safeTransfer(beneficiary, tokenAmount);
376   }
377 
378   /**
379    * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
380    * @param beneficiary Address receiving the tokens
381    * @param tokenAmount Number of tokens to be purchased
382    */
383   function _processPurchase(
384     address beneficiary,
385     uint256 tokenAmount
386   )
387     internal
388   {
389     _deliverTokens(beneficiary, tokenAmount);
390   }
391 
392   /**
393    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
394    * @param beneficiary Address receiving the tokens
395    * @param weiAmount Value in wei involved in the purchase
396    */
397   function _updatePurchasingState(
398     address beneficiary,
399     uint256 weiAmount
400   )
401     internal
402   {
403     // optional override
404   }
405 
406   /**
407    * @dev Override to extend the way in which ether is converted to tokens.
408    * @param weiAmount Value in wei to be converted into tokens
409    * @return Number of tokens that can be purchased with the specified _weiAmount
410    */
411   function _getTokenAmount(uint256 weiAmount)
412     internal view returns (uint256)
413   {
414     return weiAmount.mul(_rate);
415   }
416 
417   /**
418    * @dev Determines how ETH is stored/forwarded on purchases.
419    */
420   function _forwardFunds() internal {
421     _wallet.transfer(msg.value);
422   }
423 }
424 
425 contract CappedCrowdsale is Crowdsale {
426   using SafeMath for uint256;
427 
428   uint256 private _cap;
429 
430   /**
431    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
432    * @param cap Max amount of wei to be contributed
433    */
434   constructor(uint256 cap) internal {
435     require(cap > 0);
436     _cap = cap;
437   }
438 
439   /**
440    * @return the cap of the crowdsale.
441    */
442   function cap() public view returns(uint256) {
443     return _cap;
444   }
445 
446   /**
447    * @dev Checks whether the cap has been reached.
448    * @return Whether the cap was reached
449    */
450   function capReached() public view returns (bool) {
451     return weiRaised() >= _cap;
452   }
453 
454   /**
455    * @dev Extend parent behavior requiring purchase to respect the funding cap.
456    * @param beneficiary Token purchaser
457    * @param weiAmount Amount of wei contributed
458    */
459   function _preValidatePurchase(
460     address beneficiary,
461     uint256 weiAmount
462   )
463     internal
464     view
465   {
466     super._preValidatePurchase(beneficiary, weiAmount);
467     require(weiRaised().add(weiAmount) <= _cap);
468   }
469 
470 }
471 
472 contract TimedCrowdsale is Crowdsale {
473   using SafeMath for uint256;
474 
475   uint256 private _openingTime;
476   uint256 private _closingTime;
477 
478   /**
479    * @dev Reverts if not in crowdsale time range.
480    */
481   modifier onlyWhileOpen {
482     require(isOpen());
483     _;
484   }
485 
486   /**
487    * @dev Constructor, takes crowdsale opening and closing times.
488    * @param openingTime Crowdsale opening time
489    * @param closingTime Crowdsale closing time
490    */
491   constructor(uint256 openingTime, uint256 closingTime) internal {
492     // solium-disable-next-line security/no-block-members
493     require(openingTime >= block.timestamp);
494     require(closingTime > openingTime);
495 
496     _openingTime = openingTime;
497     _closingTime = closingTime;
498   }
499 
500   /**
501    * @return the crowdsale opening time.
502    */
503   function openingTime() public view returns(uint256) {
504     return _openingTime;
505   }
506 
507   /**
508    * @return the crowdsale closing time.
509    */
510   function closingTime() public view returns(uint256) {
511     return _closingTime;
512   }
513 
514   /**
515    * @return true if the crowdsale is open, false otherwise.
516    */
517   function isOpen() public view returns (bool) {
518     // solium-disable-next-line security/no-block-members
519     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
520   }
521 
522   /**
523    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
524    * @return Whether crowdsale period has elapsed
525    */
526   function hasClosed() public view returns (bool) {
527     // solium-disable-next-line security/no-block-members
528     return block.timestamp > _closingTime;
529   }
530 
531   /**
532    * @dev Extend parent behavior requiring to be within contributing period
533    * @param beneficiary Token purchaser
534    * @param weiAmount Amount of wei contributed
535    */
536   function _preValidatePurchase(
537     address beneficiary,
538     uint256 weiAmount
539   )
540     internal
541     onlyWhileOpen
542     view
543   {
544     super._preValidatePurchase(beneficiary, weiAmount);
545   }
546 
547 }
548 
549 contract MintedCrowdsale is Crowdsale {
550   constructor() internal {}
551 
552   /**
553    * @dev Overrides delivery by minting tokens upon purchase.
554    * @param beneficiary Token purchaser
555    * @param tokenAmount Number of tokens to be minted
556    */
557   function _deliverTokens(
558     address beneficiary,
559     uint256 tokenAmount
560   )
561     internal
562   {
563     require(token().mint(beneficiary, tokenAmount));
564   }
565 }
566 
567 contract SharesCrowdsale is Crowdsale {
568   address[] public wallets;
569 
570   constructor(
571     address[] _wallets
572   ) internal {
573     wallets = _wallets;
574   }
575 
576   /**
577    * @dev Reverts if payment amount is less than limit.
578    */
579   modifier canBuyOneToken() {
580     uint256 calculatedRate = rate() + increaseRateValue - decreaseRateValue;
581     uint256 priceOfTokenInWei = 1 ether / calculatedRate;
582     require(msg.value >= priceOfTokenInWei);
583     _;
584   }
585 
586   event IncreaseRate(
587     uint256 change,
588     uint256 rate
589   );
590 
591   event DecreaseRate(
592     uint256 change,
593     uint256 rate
594   );
595 
596   uint256 public increaseRateValue = 0;
597   uint256 public decreaseRateValue = 0;
598 
599   /**
600    * @dev Call this method when price of ether increased
601    * @param value Change in USD from start price
602    * @return How much tokens investor will receive per 1 ether
603    */
604   function increaseRateBy(uint256 value)
605     external returns (uint256)
606   {
607     require(token().isMinter(msg.sender));
608 
609     increaseRateValue = value;
610     decreaseRateValue = 0;
611 
612     uint256 calculatedRate = rate() + increaseRateValue;
613 
614     emit IncreaseRate(value, calculatedRate);
615 
616     return calculatedRate;
617   }
618 
619   /**
620    * @dev Call this method when price of ether decreased
621    * @param value Change in USD from start price
622    * @return How much tokens investor will receive per 1 ether
623    */
624   function decreaseRateBy(uint256 value)
625     external returns (uint256)
626   {
627     require(token().isMinter(msg.sender));
628 
629     increaseRateValue = 0;
630     decreaseRateValue = value;
631 
632     uint256 calculatedRate = rate() - decreaseRateValue;
633 
634     emit DecreaseRate(value, calculatedRate);
635 
636     return calculatedRate;
637   }
638 
639   /**
640    * @param weiAmount Value in wei to be converted into tokens
641    * @return Number of tokens that can be purchased with the specified _weiAmount
642    */
643   function _getTokenAmount(uint256 weiAmount)
644     internal view returns (uint256)
645   {
646     uint256 calculatedRate = rate() + increaseRateValue - decreaseRateValue;
647     uint256 tokensAmount = weiAmount.mul(calculatedRate).div(1 ether);
648 
649     uint256 charge = weiAmount.mul(calculatedRate).mod(1 ether);
650     if (charge > 0) {
651         tokensAmount += 1;
652     }
653 
654     return tokensAmount;
655   }
656 
657   /**
658    * @dev Determines how ETH is stored/forwarded on purchases.
659    */
660   function _forwardFunds() internal {
661     if (weiRaised() > 100 ether) {
662         wallet().transfer(msg.value);
663     } else {
664         uint256 walletsNumber = wallets.length;
665         uint256 amountPerWallet = msg.value.div(walletsNumber);
666 
667         for (uint256 i = 0; i < walletsNumber; i++) {
668             wallets[i].transfer(amountPerWallet);
669         }
670 
671         uint256 charge = msg.value.mod(walletsNumber);
672         if (charge > 0) {
673             wallets[0].transfer(charge);
674         }
675     }
676   }
677 
678   function _preValidatePurchase(
679     address beneficiary,
680     uint256 weiAmount
681   )
682     internal
683     canBuyOneToken()
684     view
685   {
686     super._preValidatePurchase(beneficiary, weiAmount);
687   }
688 }
689 
690 contract Tokensale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, SharesCrowdsale {
691   constructor(
692     uint256 rate,
693     address finalWallet,
694     address token,
695     uint256 cap,
696     uint256 openingTime,
697     uint256 closingTime,
698     address[] wallets
699   )
700     public
701     Crowdsale(rate, finalWallet, IToken(token))
702     CappedCrowdsale(cap)
703     TimedCrowdsale(openingTime, closingTime)
704     SharesCrowdsale(wallets)
705   {
706   }
707 }