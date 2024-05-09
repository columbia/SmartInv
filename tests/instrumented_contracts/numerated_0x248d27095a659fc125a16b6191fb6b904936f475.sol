1 pragma solidity ^0.4.24;
2 
3 contract Crowdsale {
4   using SafeMath for uint256;
5   using SafeERC20 for ERC20;
6 
7   // The token being sold
8   ERC20 public token;
9 
10   // Address where funds are collected
11   address public wallet;
12 
13   // How many token units a buyer gets per wei.
14   // The rate is the conversion between wei and the smallest and indivisible token unit.
15   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
16   // 1 wei will give you 1 unit, or 0.001 TOK.
17   uint256 public rate;
18 
19   // Amount of wei raised
20   uint256 public weiRaised;
21 
22   /**
23    * Event for token purchase logging
24    * @param purchaser who paid for the tokens
25    * @param beneficiary who got the tokens
26    * @param value weis paid for purchase
27    * @param amount amount of tokens purchased
28    */
29   event TokenPurchase(
30     address indexed purchaser,
31     address indexed beneficiary,
32     uint256 value,
33     uint256 amount
34   );
35 
36   /**
37    * @param _rate Number of token units a buyer gets per wei
38    * @param _wallet Address where collected funds will be forwarded to
39    * @param _token Address of the token being sold
40    */
41   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
42     require(_rate > 0);
43     require(_wallet != address(0));
44     require(_token != address(0));
45 
46     rate = _rate;
47     wallet = _wallet;
48     token = _token;
49   }
50 
51   // -----------------------------------------
52   // Crowdsale external interface
53   // -----------------------------------------
54 
55   /**
56    * @dev fallback function ***DO NOT OVERRIDE***
57    */
58   function () external payable {
59     buyTokens(msg.sender);
60   }
61 
62   /**
63    * @dev low level token purchase ***DO NOT OVERRIDE***
64    * @param _beneficiary Address performing the token purchase
65    */
66   function buyTokens(address _beneficiary) public payable {
67 
68     uint256 weiAmount = msg.value;
69     _preValidatePurchase(_beneficiary, weiAmount);
70 
71     // calculate token amount to be created
72     uint256 tokens = _getTokenAmount(weiAmount);
73 
74     // update state
75     weiRaised = weiRaised.add(weiAmount);
76 
77     _processPurchase(_beneficiary, tokens);
78     emit TokenPurchase(
79       msg.sender,
80       _beneficiary,
81       weiAmount,
82       tokens
83     );
84 
85     _updatePurchasingState(_beneficiary, weiAmount);
86 
87     _forwardFunds();
88     _postValidatePurchase(_beneficiary, weiAmount);
89   }
90 
91   // -----------------------------------------
92   // Internal interface (extensible)
93   // -----------------------------------------
94 
95   /**
96    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
97    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
98    *   super._preValidatePurchase(_beneficiary, _weiAmount);
99    *   require(weiRaised.add(_weiAmount) <= cap);
100    * @param _beneficiary Address performing the token purchase
101    * @param _weiAmount Value in wei involved in the purchase
102    */
103   function _preValidatePurchase(
104     address _beneficiary,
105     uint256 _weiAmount
106   )
107     internal
108   {
109     require(_beneficiary != address(0));
110     require(_weiAmount != 0);
111   }
112 
113   /**
114    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
115    * @param _beneficiary Address performing the token purchase
116    * @param _weiAmount Value in wei involved in the purchase
117    */
118   function _postValidatePurchase(
119     address _beneficiary,
120     uint256 _weiAmount
121   )
122     internal
123   {
124     // optional override
125   }
126 
127   /**
128    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
129    * @param _beneficiary Address performing the token purchase
130    * @param _tokenAmount Number of tokens to be emitted
131    */
132   function _deliverTokens(
133     address _beneficiary,
134     uint256 _tokenAmount
135   )
136     internal
137   {
138     token.safeTransfer(_beneficiary, _tokenAmount);
139   }
140 
141   /**
142    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
143    * @param _beneficiary Address receiving the tokens
144    * @param _tokenAmount Number of tokens to be purchased
145    */
146   function _processPurchase(
147     address _beneficiary,
148     uint256 _tokenAmount
149   )
150     internal
151   {
152     _deliverTokens(_beneficiary, _tokenAmount);
153   }
154 
155   /**
156    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
157    * @param _beneficiary Address receiving the tokens
158    * @param _weiAmount Value in wei involved in the purchase
159    */
160   function _updatePurchasingState(
161     address _beneficiary,
162     uint256 _weiAmount
163   )
164     internal
165   {
166     // optional override
167   }
168 
169   /**
170    * @dev Override to extend the way in which ether is converted to tokens.
171    * @param _weiAmount Value in wei to be converted into tokens
172    * @return Number of tokens that can be purchased with the specified _weiAmount
173    */
174   function _getTokenAmount(uint256 _weiAmount)
175     internal view returns (uint256)
176   {
177     return _weiAmount.mul(rate);
178   }
179 
180   /**
181    * @dev Determines how ETH is stored/forwarded on purchases.
182    */
183   function _forwardFunds() internal {
184     wallet.transfer(msg.value);
185   }
186 }
187 
188 contract TimedCrowdsale is Crowdsale {
189   using SafeMath for uint256;
190 
191   uint256 public openingTime;
192   uint256 public closingTime;
193 
194   /**
195    * @dev Reverts if not in crowdsale time range.
196    */
197   modifier onlyWhileOpen {
198     // solium-disable-next-line security/no-block-members
199     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
200     _;
201   }
202 
203   /**
204    * @dev Constructor, takes crowdsale opening and closing times.
205    * @param _openingTime Crowdsale opening time
206    * @param _closingTime Crowdsale closing time
207    */
208   constructor(uint256 _openingTime, uint256 _closingTime) public {
209     // solium-disable-next-line security/no-block-members
210     require(_openingTime >= block.timestamp);
211     require(_closingTime >= _openingTime);
212 
213     openingTime = _openingTime;
214     closingTime = _closingTime;
215   }
216 
217   /**
218    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
219    * @return Whether crowdsale period has elapsed
220    */
221   function hasClosed() public view returns (bool) {
222     // solium-disable-next-line security/no-block-members
223     return block.timestamp > closingTime;
224   }
225 
226   /**
227    * @dev Extend parent behavior requiring to be within contributing period
228    * @param _beneficiary Token purchaser
229    * @param _weiAmount Amount of wei contributed
230    */
231   function _preValidatePurchase(
232     address _beneficiary,
233     uint256 _weiAmount
234   )
235     internal
236     onlyWhileOpen
237   {
238     super._preValidatePurchase(_beneficiary, _weiAmount);
239   }
240 
241 }
242 
243 contract PostDeliveryCrowdsale is TimedCrowdsale {
244   using SafeMath for uint256;
245 
246   mapping(address => uint256) public balances;
247 
248   /**
249    * @dev Withdraw tokens only after crowdsale ends.
250    */
251   function withdrawTokens() public {
252     require(hasClosed());
253     uint256 amount = balances[msg.sender];
254     require(amount > 0);
255     balances[msg.sender] = 0;
256     _deliverTokens(msg.sender, amount);
257   }
258 
259   /**
260    * @dev Overrides parent by storing balances instead of issuing tokens right away.
261    * @param _beneficiary Token purchaser
262    * @param _tokenAmount Amount of tokens purchased
263    */
264   function _processPurchase(
265     address _beneficiary,
266     uint256 _tokenAmount
267   )
268     internal
269   {
270     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
271   }
272 
273 }
274 
275 library SafeMath {
276 
277   /**
278   * @dev Multiplies two numbers, throws on overflow.
279   */
280   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
281     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
282     // benefit is lost if 'b' is also tested.
283     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
284     if (_a == 0) {
285       return 0;
286     }
287 
288     c = _a * _b;
289     assert(c / _a == _b);
290     return c;
291   }
292 
293   /**
294   * @dev Integer division of two numbers, truncating the quotient.
295   */
296   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
297     // assert(_b > 0); // Solidity automatically throws when dividing by 0
298     // uint256 c = _a / _b;
299     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
300     return _a / _b;
301   }
302 
303   /**
304   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
305   */
306   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
307     assert(_b <= _a);
308     return _a - _b;
309   }
310 
311   /**
312   * @dev Adds two numbers, throws on overflow.
313   */
314   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
315     c = _a + _b;
316     assert(c >= _a);
317     return c;
318   }
319 }
320 
321 contract Ownable {
322   address public owner;
323 
324 
325   event OwnershipRenounced(address indexed previousOwner);
326   event OwnershipTransferred(
327     address indexed previousOwner,
328     address indexed newOwner
329   );
330 
331 
332   /**
333    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
334    * account.
335    */
336   constructor() public {
337     owner = msg.sender;
338   }
339 
340   /**
341    * @dev Throws if called by any account other than the owner.
342    */
343   modifier onlyOwner() {
344     require(msg.sender == owner);
345     _;
346   }
347 
348   /**
349    * @dev Allows the current owner to relinquish control of the contract.
350    * @notice Renouncing to ownership will leave the contract without an owner.
351    * It will not be possible to call the functions with the `onlyOwner`
352    * modifier anymore.
353    */
354   function renounceOwnership() public onlyOwner {
355     emit OwnershipRenounced(owner);
356     owner = address(0);
357   }
358 
359   /**
360    * @dev Allows the current owner to transfer control of the contract to a newOwner.
361    * @param _newOwner The address to transfer ownership to.
362    */
363   function transferOwnership(address _newOwner) public onlyOwner {
364     _transferOwnership(_newOwner);
365   }
366 
367   /**
368    * @dev Transfers control of the contract to a newOwner.
369    * @param _newOwner The address to transfer ownership to.
370    */
371   function _transferOwnership(address _newOwner) internal {
372     require(_newOwner != address(0));
373     emit OwnershipTransferred(owner, _newOwner);
374     owner = _newOwner;
375   }
376 }
377 
378 contract ERC20Basic {
379   function totalSupply() public view returns (uint256);
380   function balanceOf(address _who) public view returns (uint256);
381   function transfer(address _to, uint256 _value) public returns (bool);
382   event Transfer(address indexed from, address indexed to, uint256 value);
383 }
384 
385 contract ERC20 is ERC20Basic {
386   function allowance(address _owner, address _spender)
387     public view returns (uint256);
388 
389   function transferFrom(address _from, address _to, uint256 _value)
390     public returns (bool);
391 
392   function approve(address _spender, uint256 _value) public returns (bool);
393   event Approval(
394     address indexed owner,
395     address indexed spender,
396     uint256 value
397   );
398 }
399 
400 library SafeERC20 {
401   function safeTransfer(
402     ERC20Basic _token,
403     address _to,
404     uint256 _value
405   )
406     internal
407   {
408     require(_token.transfer(_to, _value));
409   }
410 
411   function safeTransferFrom(
412     ERC20 _token,
413     address _from,
414     address _to,
415     uint256 _value
416   )
417     internal
418   {
419     require(_token.transferFrom(_from, _to, _value));
420   }
421 
422   function safeApprove(
423     ERC20 _token,
424     address _spender,
425     uint256 _value
426   )
427     internal
428   {
429     require(_token.approve(_spender, _value));
430   }
431 }
432 
433 contract Oraclized is Ownable {
434 
435     address public oracle;
436 
437     constructor(address _oracle) public {
438         oracle = _oracle;
439     }
440 
441     /**
442      * @dev Change oracle address
443      * @param _oracle Oracle address
444      */
445     function setOracle(address _oracle) public onlyOwner {
446         oracle = _oracle;
447     }
448 
449     /**
450      * @dev Modifier to allow access only by oracle
451      */
452     modifier onlyOracle() {
453         require(msg.sender == oracle);
454         _;
455     }
456 
457     /**
458      * @dev Modifier to allow access only by oracle or owner
459      */
460     modifier onlyOwnerOrOracle() {
461         require((msg.sender == oracle) || (msg.sender == owner));
462         _;
463     }
464 }
465 
466 contract KYCCrowdsale is Oraclized, PostDeliveryCrowdsale {
467     using SafeMath for uint256;
468 
469     /**
470      * @dev etherPriceInUsd Ether price in cents
471      * @dev usdRaised Total USD raised while ICO in cents
472      * @dev weiInvested Stores amount of wei invested by each user
473      * @dev usdInvested Stores amount of USD invested by each user in cents
474      */
475     uint256 public etherPriceInUsd;
476     uint256 public usdRaised;
477     mapping (address => uint256) public weiInvested;
478     mapping (address => uint256) public usdInvested;
479 
480     /**
481      * @dev KYCPassed Registry of users who passed KYC
482      * @dev KYCRequired Registry of users who has to passed KYC
483      */
484     mapping (address => bool) public KYCPassed;
485     mapping (address => bool) public KYCRequired;
486 
487     /**
488      * @dev KYCRequiredAmountInUsd Amount in cents invested starting from which user must pass KYC
489      */
490     uint256 public KYCRequiredAmountInUsd;
491 
492     event EtherPriceUpdated(uint256 _cents);
493 
494     /**
495      * @param _kycAmountInUsd Amount in cents invested starting from which user must pass KYC
496      */
497     constructor(uint256 _kycAmountInUsd, uint256 _etherPrice) public {
498         require(_etherPrice > 0);
499 
500         KYCRequiredAmountInUsd = _kycAmountInUsd;
501         etherPriceInUsd = _etherPrice;
502     }
503 
504     /**
505      * @dev Update amount required to pass KYC
506      * @param _cents Amount in cents invested starting from which user must pass KYC
507      */
508     function setKYCRequiredAmount(uint256 _cents) external onlyOwnerOrOracle {
509         require(_cents > 0);
510 
511         KYCRequiredAmountInUsd = _cents;
512     }
513 
514     /**
515      * @dev Set ether conversion rate
516      * @param _cents Price of 1 ETH in cents
517      */
518     function setEtherPrice(uint256 _cents) public onlyOwnerOrOracle {
519         require(_cents > 0);
520 
521         etherPriceInUsd = _cents;
522 
523         emit EtherPriceUpdated(_cents);
524     }
525 
526     /**
527      * @dev Check if KYC is required for address
528      * @param _address Address to check
529      */
530     function isKYCRequired(address _address) external view returns(bool) {
531         return KYCRequired[_address];
532     }
533 
534     /**
535      * @dev Check if KYC is passed by address
536      * @param _address Address to check
537      */
538     function isKYCPassed(address _address) external view returns(bool) {
539         return KYCPassed[_address];
540     }
541 
542     /**
543      * @dev Check if KYC is not required or passed
544      * @param _address Address to check
545      */
546     function isKYCSatisfied(address _address) public view returns(bool) {
547         return !KYCRequired[_address] || KYCPassed[_address];
548     }
549 
550     /**
551      * @dev Returns wei invested by specific amount
552      * @param _account Account you would like to get wei for
553      */
554     function weiInvestedOf(address _account) external view returns (uint256) {
555         return weiInvested[_account];
556     }
557 
558     /**
559      * @dev Returns cents invested by specific amount
560      * @param _account Account you would like to get cents for
561      */
562     function usdInvestedOf(address _account) external view returns (uint256) {
563         return usdInvested[_account];
564     }
565 
566     /**
567      * @dev Update KYC status for set of addresses
568      * @param _addresses Addresses to update
569      * @param _completed Is KYC passed or not
570      */
571     function updateKYCStatus(address[] _addresses, bool _completed) public onlyOwnerOrOracle {
572         for (uint16 index = 0; index < _addresses.length; index++) {
573             KYCPassed[_addresses[index]] = _completed;
574         }
575     }
576 
577     /**
578      * @dev Override update purchasing state
579      *      - update sum of funds invested
580      *      - if total amount invested higher than KYC amount set KYC required to true
581      */
582     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
583         super._updatePurchasingState(_beneficiary, _weiAmount);
584 
585         uint256 usdAmount = _weiToUsd(_weiAmount);
586         usdRaised = usdRaised.add(usdAmount);
587         usdInvested[_beneficiary] = usdInvested[_beneficiary].add(usdAmount);
588         weiInvested[_beneficiary] = weiInvested[_beneficiary].add(_weiAmount);
589 
590         if (usdInvested[_beneficiary] >= KYCRequiredAmountInUsd) {
591             KYCRequired[_beneficiary] = true;
592         }
593     }
594 
595     /**
596      * @dev Override token withdraw
597      *      - do not allow token withdraw in case KYC required but not passed
598      */
599     function withdrawTokens() public {
600         require(isKYCSatisfied(msg.sender));
601 
602         super.withdrawTokens();
603     }
604 
605     /**
606      * @dev Converts wei to cents
607      * @param _wei Wei amount
608      */
609     function _weiToUsd(uint256 _wei) internal view returns (uint256) {
610         return _wei.mul(etherPriceInUsd).div(1e18);
611     }
612 
613     /**
614      * @dev Converts cents to wei
615      * @param _cents Cents amount
616      */
617     function _usdToWei(uint256 _cents) internal view returns (uint256) {
618         return _cents.mul(1e18).div(etherPriceInUsd);
619     }
620 }
621 
622 contract KYCRefundableCrowdsale is KYCCrowdsale {
623     using SafeMath for uint256;
624 
625     /**
626      * @dev percentage multiplier to present percentage as decimals. 5 decimal by default
627      * @dev weiOnFinalize ether balance which was on finalize & will be returned to users in case of failed crowdsale
628      */
629     uint256 private percentage = 100 * 1000;
630     uint256 private weiOnFinalize;
631 
632     /**
633      * @dev goalReached specifies if crowdsale goal is reached
634      * @dev isFinalized is crowdsale finished
635      * @dev tokensWithdrawn total amount of tokens already withdrawn
636      */
637     bool public goalReached = false;
638     bool public isFinalized = false;
639     uint256 public tokensWithdrawn;
640 
641     event Refund(address indexed _account, uint256 _amountInvested, uint256 _amountRefunded);
642     event Finalized();
643     event OwnerWithdraw(uint256 _amount);
644 
645     /**
646      * @dev Set is goal reached or not
647      * @param _success Is goal reached or not
648      */
649     function setGoalReached(bool _success) external onlyOwner {
650         require(!isFinalized);
651         goalReached = _success;
652     }
653 
654     /**
655      * @dev Investors can claim refunds here if crowdsale is unsuccessful
656      */
657     function claimRefund() public {
658         require(isFinalized);
659         require(!goalReached);
660 
661         uint256 refundPercentage = _refundPercentage();
662         uint256 amountInvested = weiInvested[msg.sender];
663         uint256 amountRefunded = amountInvested.mul(refundPercentage).div(percentage);
664         weiInvested[msg.sender] = 0;
665         usdInvested[msg.sender] = 0;
666         msg.sender.transfer(amountRefunded);
667 
668         emit Refund(msg.sender, amountInvested, amountRefunded);
669     }
670 
671     /**
672      * @dev Must be called after crowdsale ends, to do some extra finalization works.
673      */
674     function finalize() public onlyOwner {
675         require(!isFinalized);
676 
677         // NOTE: We do this because we would like to allow withdrawals earlier than closing time in case of crowdsale success
678         closingTime = block.timestamp;
679         weiOnFinalize = address(this).balance;
680         isFinalized = true;
681 
682         emit Finalized();
683     }
684 
685     /**
686      * @dev Override. Withdraw tokens only after crowdsale ends.
687      * Make sure crowdsale is successful & finalized
688      */
689     function withdrawTokens() public {
690         require(isFinalized);
691         require(goalReached);
692 
693         tokensWithdrawn = tokensWithdrawn.add(balances[msg.sender]);
694 
695         super.withdrawTokens();
696     }
697 
698     /**
699      * @dev Is called by owner to send funds to ICO wallet.
700      * params _amount Amount to be sent.
701      */
702     function ownerWithdraw(uint256 _amount) external onlyOwner {
703         require(_amount > 0);
704 
705         wallet.transfer(_amount);
706 
707         emit OwnerWithdraw(_amount);
708     }
709 
710     /**
711      * @dev Override. Determines how ETH is stored/forwarded on purchases.
712      */
713     function _forwardFunds() internal {
714         // NOTE: Do nothing here. Keep funds in contract by default
715     }
716 
717     /**
718      * @dev Calculates refund percentage in case some funds will be used by dev team on crowdsale needs
719      */
720     function _refundPercentage() internal view returns (uint256) {
721         return weiOnFinalize.mul(percentage).div(weiRaised);
722     }
723 }
724 
725 contract AerumCrowdsale is KYCRefundableCrowdsale {
726     using SafeMath for uint256;
727 
728     /**
729      * @dev minInvestmentInUsd Minimal investment allowed in cents
730      */
731     uint256 public minInvestmentInUsd;
732 
733     /**
734      * @dev tokensSold Amount of tokens sold by this time
735      */
736     uint256 public tokensSold;
737 
738     /**
739      * @dev pledgeTotal Total pledge collected from all investors
740      * @dev pledgeClosingTime Time when pledge is closed & it's not possible to pledge more or use pledge more
741      * @dev pledges Mapping of all pledges done by investors
742      */
743     uint256 public pledgeTotal;
744     uint256 public pledgeClosingTime;
745     mapping (address => uint256) public pledges;
746 
747     /**
748      * @dev whitelistedRate Rate which is used while whitelisted sale (XRM to ETH)
749      * @dev publicRate Rate which is used white public crowdsale (XRM to ETH)
750      */
751     uint256 public whitelistedRate;
752     uint256 public publicRate;
753 
754 
755     event AirDrop(address indexed _account, uint256 _amount);
756     event MinInvestmentUpdated(uint256 _cents);
757     event RateUpdated(uint256 _whitelistedRate, uint256 _publicRate);
758     event Withdraw(address indexed _account, uint256 _amount);
759 
760     /**
761      * @param _token ERC20 compatible token on which crowdsale is done
762      * @param _wallet Address where all ETH funded will be sent after ICO finishes
763      * @param _whitelistedRate Rate which is used while whitelisted sale
764      * @param _publicRate Rate which is used white public crowdsale
765      * @param _openingTime Crowdsale open time
766      * @param _closingTime Crowdsale close time
767      * @param _pledgeClosingTime Time when pledge is closed & no more active
768 \\
769      * @param _kycAmountInUsd Amount on which KYC will be required in cents
770      * @param _etherPriceInUsd ETH price in cents
771      */
772     constructor(
773         ERC20 _token, address _wallet,
774         uint256 _whitelistedRate, uint256 _publicRate,
775         uint256 _openingTime, uint256 _closingTime,
776         uint256 _pledgeClosingTime,
777         uint256 _kycAmountInUsd, uint256 _etherPriceInUsd)
778     Oraclized(msg.sender)
779     Crowdsale(_whitelistedRate, _wallet, _token)
780     TimedCrowdsale(_openingTime, _closingTime)
781     KYCCrowdsale(_kycAmountInUsd, _etherPriceInUsd)
782     KYCRefundableCrowdsale()
783     public {
784         require(_openingTime < _pledgeClosingTime && _pledgeClosingTime < _closingTime);
785         pledgeClosingTime = _pledgeClosingTime;
786 
787         whitelistedRate = _whitelistedRate;
788         publicRate = _publicRate;
789 
790         minInvestmentInUsd = 25 * 100;
791     }
792 
793     /**
794      * @dev Update minimal allowed investment
795      */
796     function setMinInvestment(uint256 _cents) external onlyOwnerOrOracle {
797         minInvestmentInUsd = _cents;
798 
799         emit MinInvestmentUpdated(_cents);
800     }
801 
802     /**
803      * @dev Update closing time
804      * @param _closingTime Closing time
805      */
806     function setClosingTime(uint256 _closingTime) external onlyOwner {
807         require(_closingTime >= openingTime);
808 
809         closingTime = _closingTime;
810     }
811 
812     /**
813      * @dev Update pledge closing time
814      * @param _pledgeClosingTime Pledge closing time
815      */
816     function setPledgeClosingTime(uint256 _pledgeClosingTime) external onlyOwner {
817         require(_pledgeClosingTime >= openingTime && _pledgeClosingTime <= closingTime);
818 
819         pledgeClosingTime = _pledgeClosingTime;
820     }
821 
822     /**
823      * @dev Update rates
824      * @param _whitelistedRate Rate which is used while whitelisted sale (XRM to ETH)
825      * @param _publicRate Rate which is used white public crowdsale (XRM to ETH)
826      */
827     function setRate(uint256 _whitelistedRate, uint256 _publicRate) public onlyOwnerOrOracle {
828         require(_whitelistedRate > 0);
829         require(_publicRate > 0);
830 
831         whitelistedRate = _whitelistedRate;
832         publicRate = _publicRate;
833 
834         emit RateUpdated(_whitelistedRate, _publicRate);
835     }
836 
837     /**
838      * @dev Update rates & ether price. Done to not make 2 requests from oracle.
839      * @param _whitelistedRate Rate which is used while whitelisted sale
840      * @param _publicRate Rate which is used white public crowdsale
841      * @param _cents Price of 1 ETH in cents
842      */
843     function setRateAndEtherPrice(uint256 _whitelistedRate, uint256 _publicRate, uint256 _cents) external onlyOwnerOrOracle {
844         setRate(_whitelistedRate, _publicRate);
845         setEtherPrice(_cents);
846     }
847 
848     /**
849      * @dev Send remaining tokens back
850      * @param _to Address to send
851      * @param _amount Amount to send
852      */
853     function sendTokens(address _to, uint256 _amount) external onlyOwner {
854         if (!isFinalized || goalReached) {
855             // NOTE: if crowdsale not finished or successful we should keep at least tokens sold
856             _ensureTokensAvailable(_amount);
857         }
858 
859         token.transfer(_to, _amount);
860     }
861 
862     /**
863      * @dev Get balance fo tokens bought
864      * @param _address Address of investor
865      */
866     function balanceOf(address _address) external view returns (uint256) {
867         return balances[_address];
868     }
869 
870     /**
871      * @dev Check if all tokens were sold
872      */
873     function capReached() public view returns (bool) {
874         return tokensSold >= token.balanceOf(this);
875     }
876 
877     /**
878      * @dev Returns percentage of tokens sold
879      */
880     function completionPercentage() external view returns (uint256) {
881         uint256 balance = token.balanceOf(this);
882         if (balance == 0) {
883             return 0;
884         }
885 
886         return tokensSold.mul(100).div(balance);
887     }
888 
889     /**
890      * @dev Returns remaining tokens based on stage
891      */
892     function tokensRemaining() external view returns(uint256) {
893         return token.balanceOf(this).sub(_tokensLocked());
894     }
895 
896     /**
897      * @dev Override. Withdraw tokens only after crowdsale ends.
898      * Adding withdraw event
899      */
900     function withdrawTokens() public {
901         uint256 amount = balances[msg.sender];
902         super.withdrawTokens();
903 
904         emit Withdraw(msg.sender, amount);
905     }
906 
907     /**
908      * @dev Override crowdsale pre validate. Check:
909      *      - is amount invested larger than minimal
910      *      - there is enough tokens on balance of contract to proceed
911      *      - check if pledges amount are not more than total coins (in case of pledge period)
912      */
913     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
914         super._preValidatePurchase(_beneficiary, _weiAmount);
915 
916         require(_totalInvestmentInUsd(_beneficiary, _weiAmount) >= minInvestmentInUsd);
917         _ensureTokensAvailableExcludingPledge(_beneficiary, _getTokenAmount(_weiAmount));
918     }
919 
920     /**
921      * @dev Returns total investment of beneficiary including current one in cents
922      * @param _beneficiary Address to check
923      * @param _weiAmount Current amount being invested in wei
924      */
925     function _totalInvestmentInUsd(address _beneficiary, uint256 _weiAmount) internal view returns(uint256) {
926         return usdInvested[_beneficiary].add(_weiToUsd(_weiAmount));
927     }
928 
929     /**
930      * @dev Override process purchase
931      *      - additionally sum tokens sold
932      */
933     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
934         super._processPurchase(_beneficiary, _tokenAmount);
935 
936         tokensSold = tokensSold.add(_tokenAmount);
937 
938         if (pledgeOpen()) {
939             // NOTE: In case of buying tokens inside pledge it doesn't matter how we decrease pledge as we change it anyway
940             _decreasePledge(_beneficiary, _tokenAmount);
941         }
942     }
943 
944     /**
945      * @dev Decrease pledge of account by specific token amount
946      * @param _beneficiary Account to increase pledge
947      * @param _tokenAmount Amount of tokens to decrease pledge
948      */
949     function _decreasePledge(address _beneficiary, uint256 _tokenAmount) internal {
950         if (pledgeOf(_beneficiary) <= _tokenAmount) {
951             pledgeTotal = pledgeTotal.sub(pledgeOf(_beneficiary));
952             pledges[_beneficiary] = 0;
953         } else {
954             pledgeTotal = pledgeTotal.sub(_tokenAmount);
955             pledges[_beneficiary] = pledges[_beneficiary].sub(_tokenAmount);
956         }
957     }
958 
959     /**
960      * @dev Override to use whitelisted or public crowdsale rates
961      */
962     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
963         uint256 currentRate = getCurrentRate();
964         return _weiAmount.mul(currentRate);
965     }
966 
967     /**
968      * @dev Returns current XRM to ETH rate based on stage
969      */
970     function getCurrentRate() public view returns (uint256) {
971         if (pledgeOpen()) {
972             return whitelistedRate;
973         }
974         return publicRate;
975     }
976 
977     /**
978      * @dev Check if pledge period is still open
979      */
980     function pledgeOpen() public view returns (bool) {
981         return (openingTime <= block.timestamp) && (block.timestamp <= pledgeClosingTime);
982     }
983 
984     /**
985      * @dev Returns amount of pledge for account
986      */
987     function pledgeOf(address _address) public view returns (uint256) {
988         return pledges[_address];
989     }
990 
991     /**
992      * @dev Check if all tokens were pledged
993      */
994     function pledgeCapReached() public view returns (bool) {
995         return pledgeTotal.add(tokensSold) >= token.balanceOf(this);
996     }
997 
998     /**
999      * @dev Returns percentage of tokens pledged
1000      */
1001     function pledgeCompletionPercentage() external view returns (uint256) {
1002         uint256 balance = token.balanceOf(this);
1003         if (balance == 0) {
1004             return 0;
1005         }
1006 
1007         return pledgeTotal.add(tokensSold).mul(100).div(balance);
1008     }
1009 
1010     /**
1011      * @dev Pledges
1012      * @param _addresses list of addresses
1013      * @param _tokens List of tokens to drop
1014      */
1015     function pledge(address[] _addresses, uint256[] _tokens) external onlyOwnerOrOracle {
1016         require(_addresses.length == _tokens.length);
1017         _ensureTokensListAvailable(_tokens);
1018 
1019         for (uint16 index = 0; index < _addresses.length; index++) {
1020             pledgeTotal = pledgeTotal.sub(pledges[_addresses[index]]).add(_tokens[index]);
1021             pledges[_addresses[index]] = _tokens[index];
1022         }
1023     }
1024 
1025     /**
1026      * @dev Air drops tokens to users
1027      * @param _addresses list of addresses
1028      * @param _tokens List of tokens to drop
1029      */
1030     function airDropTokens(address[] _addresses, uint256[] _tokens) external onlyOwnerOrOracle {
1031         require(_addresses.length == _tokens.length);
1032         _ensureTokensListAvailable(_tokens);
1033 
1034         for (uint16 index = 0; index < _addresses.length; index++) {
1035             tokensSold = tokensSold.add(_tokens[index]);
1036             balances[_addresses[index]] = balances[_addresses[index]].add(_tokens[index]);
1037 
1038             emit AirDrop(_addresses[index], _tokens[index]);
1039         }
1040     }
1041 
1042     /**
1043      * @dev Ensure token list total is available
1044      * @param _tokens list of tokens amount
1045      */
1046     function _ensureTokensListAvailable(uint256[] _tokens) internal {
1047         uint256 total;
1048         for (uint16 index = 0; index < _tokens.length; index++) {
1049             total = total.add(_tokens[index]);
1050         }
1051 
1052         _ensureTokensAvailable(total);
1053     }
1054 
1055     /**
1056      * @dev Ensure amount of tokens you would like to buy or pledge is available
1057      * @param _tokens Amount of tokens to buy or pledge
1058      */
1059     function _ensureTokensAvailable(uint256 _tokens) internal view {
1060         require(_tokens.add(_tokensLocked()) <= token.balanceOf(this));
1061     }
1062 
1063     /**
1064      * @dev Ensure amount of tokens you would like to buy or pledge is available excluding pledged for account
1065      * @param _account Account which is checked for pledge
1066      * @param _tokens Amount of tokens to buy or pledge
1067      */
1068     function _ensureTokensAvailableExcludingPledge(address _account, uint256 _tokens) internal view {
1069         require(_tokens.add(_tokensLockedExcludingPledge(_account)) <= token.balanceOf(this));
1070     }
1071 
1072     /**
1073      * @dev Returns locked or sold tokens based on stage
1074      */
1075     function _tokensLocked() internal view returns(uint256) {
1076         uint256 locked = tokensSold.sub(tokensWithdrawn);
1077 
1078         if (pledgeOpen()) {
1079             locked = locked.add(pledgeTotal);
1080         }
1081 
1082         return locked;
1083     }
1084 
1085     /**
1086      * @dev Returns locked or sold tokens based on stage excluding pledged for account
1087      * @param _account Account which is checked for pledge
1088      */
1089     function _tokensLockedExcludingPledge(address _account) internal view returns(uint256) {
1090         uint256 locked = _tokensLocked();
1091 
1092         if (pledgeOpen()) {
1093             locked = locked.sub(pledgeOf(_account));
1094         }
1095 
1096         return locked;
1097     }
1098 }