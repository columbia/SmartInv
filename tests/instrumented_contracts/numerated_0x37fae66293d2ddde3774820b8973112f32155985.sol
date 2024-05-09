1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (_a == 0) {
54       return 0;
55     }
56 
57     c = _a * _b;
58     assert(c / _a == _b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
66     // assert(_b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = _a / _b;
68     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
69     return _a / _b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     assert(_b <= _a);
77     return _a - _b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
84     c = _a + _b;
85     assert(c >= _a);
86     return c;
87   }
88 }
89 
90 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
91 
92 /**
93  * @title Ownable
94  * @dev The Ownable contract has an owner address, and provides basic authorization control
95  * functions, this simplifies the implementation of "user permissions".
96  */
97 contract Ownable {
98   address public owner;
99 
100 
101   event OwnershipRenounced(address indexed previousOwner);
102   event OwnershipTransferred(
103     address indexed previousOwner,
104     address indexed newOwner
105   );
106 
107 
108   /**
109    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
110    * account.
111    */
112   constructor() public {
113     owner = msg.sender;
114   }
115 
116   /**
117    * @dev Throws if called by any account other than the owner.
118    */
119   modifier onlyOwner() {
120     require(msg.sender == owner);
121     _;
122   }
123 
124   /**
125    * @dev Allows the current owner to relinquish control of the contract.
126    * @notice Renouncing to ownership will leave the contract without an owner.
127    * It will not be possible to call the functions with the `onlyOwner`
128    * modifier anymore.
129    */
130   function renounceOwnership() public onlyOwner {
131     emit OwnershipRenounced(owner);
132     owner = address(0);
133   }
134 
135   /**
136    * @dev Allows the current owner to transfer control of the contract to a newOwner.
137    * @param _newOwner The address to transfer ownership to.
138    */
139   function transferOwnership(address _newOwner) public onlyOwner {
140     _transferOwnership(_newOwner);
141   }
142 
143   /**
144    * @dev Transfers control of the contract to a newOwner.
145    * @param _newOwner The address to transfer ownership to.
146    */
147   function _transferOwnership(address _newOwner) internal {
148     require(_newOwner != address(0));
149     emit OwnershipTransferred(owner, _newOwner);
150     owner = _newOwner;
151   }
152 }
153 
154 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
155 
156 /**
157  * @title SafeERC20
158  * @dev Wrappers around ERC20 operations that throw on failure.
159  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
160  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
161  */
162 library SafeERC20 {
163   function safeTransfer(
164     ERC20Basic _token,
165     address _to,
166     uint256 _value
167   )
168     internal
169   {
170     require(_token.transfer(_to, _value));
171   }
172 
173   function safeTransferFrom(
174     ERC20 _token,
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     internal
180   {
181     require(_token.transferFrom(_from, _to, _value));
182   }
183 
184   function safeApprove(
185     ERC20 _token,
186     address _spender,
187     uint256 _value
188   )
189     internal
190   {
191     require(_token.approve(_spender, _value));
192   }
193 }
194 
195 // File: contracts/crowdsale/Crowdsale.sol
196 
197 /**
198  * @title Crowdsale
199  * @dev Crowdsale is a base contract for managing a token crowdsale,
200  * allowing investors to purchase tokens with ether. This contract implements
201  * such functionality in its most fundamental form and can be extended to provide additional
202  * functionality and/or custom behavior.
203  * The external interface represents the basic interface for purchasing tokens, and conform
204  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
205  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
206  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
207  * behavior.
208  */
209 contract Crowdsale {
210     using SafeMath for uint256;
211     using SafeERC20 for ERC20;
212 
213     // The token being sold
214     ERC20 public token;
215 
216     // Address where funds are collected
217     address public wallet;
218 
219     // How many token units a buyer gets per wei.
220     // The rate is the conversion between wei and the smallest and indivisible token unit.
221     // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
222     // 1 wei will give you 1 unit, or 0.001 TOK.
223     uint256 public rate;
224 
225     // Amount of wei raised
226     uint256 public weiRaised;
227 
228     // Amount tokens Sold
229     uint256 public tokensSold;
230     
231     /**
232     * Event for token purchase logging
233     * @param purchaser who paid for the tokens
234     * @param beneficiary who got the tokens
235     * @param value weis paid for purchase
236     * @param amount amount of tokens purchased
237     */
238     event TokenPurchase(
239         address indexed purchaser,
240         address indexed beneficiary,
241         uint256 value,
242         uint256 amount
243     );
244 
245     /**
246     * @param _rate Number of token units a buyer gets per wei
247     * @param _wallet Address where collected funds will be forwarded to
248     * @param _token Address of the token being sold
249     */
250     constructor(uint256 _rate, address _wallet, ERC20 _token) public {
251         require(_rate > 0);
252         require(_wallet != address(0));
253         require(_token != address(0));
254 
255         rate = _rate;
256         wallet = _wallet;
257         token = _token;
258     }
259 
260     // -----------------------------------------
261     // Crowdsale external interface
262     // -----------------------------------------
263 
264     /**
265     * @dev fallback function ***DO NOT OVERRIDE***
266     */
267     function () external payable {
268         buyTokens(msg.sender);
269     }
270 
271     /**
272     * @dev low level token purchase ***DO NOT OVERRIDE***
273     * @param _beneficiary Address performing the token purchase
274     */
275     function buyTokens(address _beneficiary) public payable {
276 
277         uint256 weiAmount = msg.value;
278 
279         // calculate token amount to be created
280         uint256 tokens = _getTokenAmount(weiAmount);
281 
282         _preValidatePurchase(_beneficiary, weiAmount, tokens);
283 
284         // update state
285         weiRaised = weiRaised.add(weiAmount);
286         tokensSold = tokensSold.add(tokens);
287 
288         _processPurchase(_beneficiary, tokens);
289         emit TokenPurchase(
290             msg.sender,
291             _beneficiary,
292             weiAmount,
293             tokens
294         );
295 
296         _updatePurchasingState(_beneficiary, weiAmount, tokens);
297 
298         _forwardFunds();
299         _postValidatePurchase(_beneficiary, weiAmount, tokens);
300     }
301 
302     // -----------------------------------------
303     // Internal interface (extensible)
304     // -----------------------------------------
305 
306     /**
307     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
308     * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
309     *   super._preValidatePurchase(_beneficiary, _weiAmount);
310     *   require(weiRaised.add(_weiAmount) <= cap);
311     * @param _beneficiary Address performing the token purchase
312     * @param _weiAmount Value in wei involved in the purchase
313     * @param _tokenAmount Value in token involved in the purchase
314     */
315     function _preValidatePurchase(
316         address _beneficiary,
317         uint256 _weiAmount,
318         uint256 _tokenAmount
319     )
320         internal
321     {
322         require(_beneficiary != address(0));
323         require(_weiAmount != 0);
324     }
325 
326     /**
327     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
328     * @param _beneficiary Address performing the token purchase
329     * @param _weiAmount Value in wei involved in the purchase
330     * @param _tokenAmount Value in token involved in the purchase
331     */
332     function _postValidatePurchase(
333         address _beneficiary,
334         uint256 _weiAmount,
335         uint256 _tokenAmount
336     )
337         internal
338     {
339         // optional override
340     }
341 
342     /**
343     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
344     * @param _beneficiary Address performing the token purchase
345     * @param _tokenAmount Number of tokens to be emitted
346     */
347     function _deliverTokens(
348         address _beneficiary,
349         uint256 _tokenAmount
350     )
351         internal
352     {
353         token.safeTransfer(_beneficiary, _tokenAmount);
354     }
355 
356     /**
357     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
358     * @param _beneficiary Address receiving the tokens
359     * @param _tokenAmount Number of tokens to be purchased
360     */
361     function _processPurchase(
362         address _beneficiary,
363         uint256 _tokenAmount
364     )
365         internal
366     {
367         _deliverTokens(_beneficiary, _tokenAmount);
368     }
369 
370     /**
371     * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
372     * @param _beneficiary Address receiving the tokens
373     * @param _weiAmount Value in wei involved in the purchase
374     * @param _tokenAmount Value in token involved in the purchase
375     */
376     function _updatePurchasingState(
377         address _beneficiary,
378         uint256 _weiAmount,
379         uint256 _tokenAmount
380     )
381         internal
382     {
383         // optional override
384     }
385 
386     /**
387     * @dev Override to extend the way in which ether is converted to tokens.
388     * @param _weiAmount Value in wei to be converted into tokens
389     * @return Number of tokens that can be purchased with the specified _weiAmount
390     */
391     function _getTokenAmount(uint256 _weiAmount)
392         internal view returns (uint256)
393     {
394         return _weiAmount.mul(rate);
395     }
396 
397     /**
398     * @dev Determines how ETH is stored/forwarded on purchases.
399     */
400     function _forwardFunds() internal {
401         wallet.transfer(msg.value);
402     }
403 }
404 
405 // File: contracts/crowdsale/validation/TimedCrowdsale.sol
406 
407 /**
408  * @title TimedCrowdsale
409  * @dev Crowdsale accepting contributions only within a time frame.
410  */
411 contract TimedCrowdsale is Crowdsale {
412     using SafeMath for uint256;
413 
414     uint256 public openingTime;
415     uint256 public closingTime;
416 
417     /**
418     * @dev Reverts if not in crowdsale time range.
419     */
420     modifier onlyWhileOpen {
421         // solium-disable-next-line security/no-block-members
422         require(block.timestamp >= openingTime && block.timestamp <= closingTime);
423         _;
424     }
425 
426     /**
427     * @dev Constructor, takes crowdsale opening and closing times.
428     * @param _openingTime Crowdsale opening time
429     * @param _closingTime Crowdsale closing time
430     */
431     constructor(uint256 _openingTime, uint256 _closingTime) public {
432         // solium-disable-next-line security/no-block-members
433         require(_openingTime >= block.timestamp);
434         require(_closingTime > _openingTime);
435 
436         openingTime = _openingTime;
437         closingTime = _closingTime;
438     }
439 
440     /**
441     * @dev Checks whether the period in which the crowdsale is open has already elapsed.
442     * @return Whether crowdsale period has elapsed
443     */
444     function hasClosed() public view returns (bool) {
445         // solium-disable-next-line security/no-block-members
446         return block.timestamp > closingTime;
447     }
448 
449     /**
450     * @dev Extend parent behavior requiring to be within contributing period
451     * @param _beneficiary Token purchaser
452     * @param _weiAmount Amount of wei contributed
453     * @param _tokenAmount Amount of token purchased
454     */
455     function _preValidatePurchase(
456         address _beneficiary,
457         uint256 _weiAmount,
458         uint256 _tokenAmount
459     )
460         internal
461         onlyWhileOpen
462     {
463         super._preValidatePurchase(_beneficiary, _weiAmount, _tokenAmount);
464     }
465 
466 }
467 
468 // File: contracts/crowdsale/validation/MilestoneCrowdsale.sol
469 
470 /**
471  * @title MilestoneCrowdsale
472  * @dev Crowdsale with multiple milestones separated by time and cap
473  * @author Nikola Wyatt <nikola.wyatt@foodnation.io>
474  */
475 contract MilestoneCrowdsale is TimedCrowdsale {
476     using SafeMath for uint256;
477 
478     uint256 public constant MAX_MILESTONE = 10;
479 
480     /**
481     * Define pricing schedule using milestones.
482     */
483     struct Milestone {
484 
485         // Milestone index in array
486         uint256 index;
487 
488         // UNIX timestamp when this milestone starts
489         uint256 startTime;
490 
491         // Amount of tokens sold in milestone
492         uint256 tokensSold;
493 
494         // Maximum amount of Tokens accepted in the current Milestone.
495         uint256 cap;
496 
497         // How many tokens per wei you will get after this milestone has been passed
498         uint256 rate;
499 
500     }
501 
502     /**
503     * Store milestones in a fixed array, so that it can be seen in a blockchain explorer
504     * Milestone 0 is always (0, 0)
505     * (TODO: change this when we confirm dynamic arrays are explorable)
506     */
507     Milestone[10] public milestones;
508 
509     // How many active milestones have been created
510     uint256 public milestoneCount = 0;
511 
512 
513     bool public milestoningFinished = false;
514 
515     constructor(        
516         uint256 _openingTime,
517         uint256 _closingTime
518         ) 
519         TimedCrowdsale(_openingTime, _closingTime)
520         public 
521         {
522         }
523 
524     /**
525     * @dev Contruction, setting a list of milestones
526     * @param _milestoneStartTime uint[] milestones start time 
527     * @param _milestoneCap uint[] milestones cap 
528     * @param _milestoneRate uint[] milestones price 
529     */
530     function setMilestonesList(uint256[] _milestoneStartTime, uint256[] _milestoneCap, uint256[] _milestoneRate) public {
531         // Need to have tuples, length check
532         require(!milestoningFinished);
533         require(_milestoneStartTime.length > 0);
534         require(_milestoneStartTime.length == _milestoneCap.length && _milestoneCap.length == _milestoneRate.length);
535         require(_milestoneStartTime[0] == openingTime);
536         require(_milestoneStartTime[_milestoneStartTime.length-1] < closingTime);
537 
538         for (uint iterator = 0; iterator < _milestoneStartTime.length; iterator++) {
539             if (iterator > 0) {
540                 assert(_milestoneStartTime[iterator] > milestones[iterator-1].startTime);
541             }
542             milestones[iterator] = Milestone({
543                 index: iterator,
544                 startTime: _milestoneStartTime[iterator],
545                 tokensSold: 0,
546                 cap: _milestoneCap[iterator],
547                 rate: _milestoneRate[iterator]
548             });
549             milestoneCount++;
550         }
551         milestoningFinished = true;
552     }
553 
554     /**
555     * @dev Iterate through milestones. You reach end of milestones when rate = 0
556     * @return tuple (time, rate)
557     */
558     function getMilestoneTimeAndRate(uint256 n) public view returns (uint256, uint256) {
559         return (milestones[n].startTime, milestones[n].rate);
560     }
561 
562     /**
563     * @dev Checks whether the cap of a milestone has been reached.
564     * @return Whether the cap was reached
565     */
566     function capReached(uint256 n) public view returns (bool) {
567         return milestones[n].tokensSold >= milestones[n].cap;
568     }
569 
570     /**
571     * @dev Checks amount of tokens sold in milestone.
572     * @return Amount of tokens sold in milestone
573     */
574     function getTokensSold(uint256 n) public view returns (uint256) {
575         return milestones[n].tokensSold;
576     }
577 
578     function getFirstMilestone() private view returns (Milestone) {
579         return milestones[0];
580     }
581 
582     function getLastMilestone() private view returns (Milestone) {
583         return milestones[milestoneCount-1];
584     }
585 
586     function getFirstMilestoneStartsAt() public view returns (uint256) {
587         return getFirstMilestone().startTime;
588     }
589 
590     function getLastMilestoneStartsAt() public view returns (uint256) {
591         return getLastMilestone().startTime;
592     }
593 
594     /**
595     * @dev Get the current milestone or bail out if we are not in the milestone periods.
596     * @return {[type]} [description]
597     */
598     function getCurrentMilestoneIndex() internal view onlyWhileOpen returns  (uint256) {
599         uint256 index;
600 
601         // Found the current milestone by evaluating time. 
602         // If (now < next start) the current milestone is the previous
603         // Stops loop if finds current
604         for(uint i = 0; i < milestoneCount; i++) {
605             index = i;
606             // solium-disable-next-line security/no-block-members
607             if(block.timestamp < milestones[i].startTime) {
608                 index = i - 1;
609                 break;
610             }
611         }
612 
613         // For the next code, you may ask why not assert if last milestone surpass cap...
614         // Because if its last and it is capped we would like to finish not sell any more tokens 
615         // Check if the current milestone has reached it's cap
616         if (milestones[index].tokensSold > milestones[index].cap) {
617             index = index + 1;
618         }
619 
620         return index;
621     }
622 
623     /**
624     * @dev Extend parent behavior requiring purchase to respect the funding cap from the currentMilestone.
625     * @param _beneficiary Token purchaser
626     * @param _weiAmount Amount of wei contributed
627     * @param _tokenAmount Amount of token purchased
628     
629     */
630     function _preValidatePurchase(
631         address _beneficiary,
632         uint256 _weiAmount,
633         uint256 _tokenAmount
634     )
635         internal
636     {
637         super._preValidatePurchase(_beneficiary, _weiAmount, _tokenAmount);
638         require(milestones[getCurrentMilestoneIndex()].tokensSold.add(_tokenAmount) <= milestones[getCurrentMilestoneIndex()].cap);
639     }
640 
641     /**
642     * @dev Extend parent behavior to update current milestone state and index
643     * @param _beneficiary Token purchaser
644     * @param _weiAmount Amount of wei contributed
645     * @param _tokenAmount Amount of token purchased
646     */
647     function _updatePurchasingState(
648         address _beneficiary,
649         uint256 _weiAmount,
650         uint256 _tokenAmount
651     )
652         internal
653     {
654         super._updatePurchasingState(_beneficiary, _weiAmount, _tokenAmount);
655         milestones[getCurrentMilestoneIndex()].tokensSold = milestones[getCurrentMilestoneIndex()].tokensSold.add(_tokenAmount);
656     }
657 
658     /**
659     * @dev Get the current price.
660     * @return The current price or 0 if we are outside milestone period
661     */
662     function getCurrentRate() internal view returns (uint result) {
663         return milestones[getCurrentMilestoneIndex()].rate;
664     }
665 
666     /**
667     * @dev Override to extend the way in which ether is converted to tokens.
668     * @param _weiAmount Value in wei to be converted into tokens
669     * @return Number of tokens that can be purchased with the specified _weiAmount
670     */
671     function _getTokenAmount(uint256 _weiAmount)
672         internal view returns (uint256)
673     {
674         return _weiAmount.mul(getCurrentRate());
675     }
676 
677 }
678 
679 // File: contracts/price/USDPrice.sol
680 
681 /**
682 * @title USDPrice
683 * @dev Contract that calculates the price of tokens in USD cents.
684 * Note that this contracts needs to be updated
685 */
686 contract USDPrice is Ownable {
687 
688     using SafeMath for uint256;
689 
690     // PRICE of 1 ETHER in USD in cents
691     // So, if price is: $271.90, the value in variable will be: 27190
692     uint256 public ETHUSD;
693 
694     // Time of Last Updated Price
695     uint256 public updatedTime;
696 
697     // Historic price of ETH in USD in cents
698     mapping (uint256 => uint256) public priceHistory;
699 
700     event PriceUpdated(uint256 price);
701 
702     constructor() public {
703     }
704 
705     function getHistoricPrice(uint256 time) public view returns (uint256) {
706         return priceHistory[time];
707     } 
708 
709     function updatePrice(uint256 price) public onlyOwner {
710         require(price > 0);
711 
712         priceHistory[updatedTime] = ETHUSD;
713 
714         ETHUSD = price;
715         // solium-disable-next-line security/no-block-members
716         updatedTime = block.timestamp;
717 
718         emit PriceUpdated(ETHUSD);
719     }
720 
721     /**
722     * @dev Override to extend the way in which ether is converted to USD.
723     * @param _weiAmount Value in wei to be converted into tokens
724     * @return The value of wei amount in USD cents
725     */
726     function getPrice(uint256 _weiAmount)
727         public view returns (uint256)
728     {
729         return _weiAmount.mul(ETHUSD);
730     }
731     
732 }
733 
734 // File: contracts/Sale.sol
735 
736 interface MintableERC20 {
737     function mint(address _to, uint256 _amount) public returns (bool);
738 }
739 /**
740  * @title PreSale
741  * @dev Crowdsale accepting contributions only within a time frame, 
742  * having milestones defined, the price is defined in USD
743  * having a mechanism to refund sales if soft cap not capReached();
744  */
745 contract PreSale is Ownable, Crowdsale, MilestoneCrowdsale {
746     using SafeMath for uint256;
747 
748     /// Max amount of tokens to be contributed
749     uint256 public cap;
750 
751     /// Minimum amount of wei per contribution
752     uint256 public minimumContribution;
753     
754     bool public isFinalized = false;
755 
756     USDPrice private usdPrice; 
757 
758     event Finalized();
759 
760     constructor(
761         uint256 _rate,
762         address _wallet,
763         ERC20 _token,
764         uint256 _openingTime,
765         uint256 _closingTime,
766         uint256 _cap,
767         uint256 _minimumContribution,
768         USDPrice _usdPrice
769     )
770         Crowdsale(_rate, _wallet, _token)
771         MilestoneCrowdsale(_openingTime, _closingTime)
772         public
773     {  
774         require(_cap > 0);
775         require(_minimumContribution > 0);
776         
777         cap = _cap;
778         minimumContribution = _minimumContribution;
779 
780         usdPrice = _usdPrice;
781     }
782 
783 
784     /**
785     * @dev Checks whether the cap has been reached.
786     * @return Whether the cap was reached
787     */
788     function capReached() public view returns (bool) {
789         return tokensSold >= cap;
790     }
791 
792     /**
793     * @dev Must be called after crowdsale ends, to do some extra finalization
794     * work. Calls the contract's finalization function.
795     */
796     function finalize() public onlyOwner {
797         require(!isFinalized);
798         require(hasClosed());
799 
800         emit Finalized();
801 
802         isFinalized = true;
803     }
804 
805     /**
806     * @dev Override to extend the way in which ether is converted to tokens.
807     * @param _weiAmount Value in wei to be converted into tokens
808     * @return Number of tokens that can be purchased with the specified _weiAmount
809     */
810     function _getTokenAmount(uint256 _weiAmount)
811         internal view returns (uint256)
812     {
813         return usdPrice.getPrice(_weiAmount).div(getCurrentRate());
814     }
815 
816     /**
817     * @dev Extend parent behavior sending heartbeat to token.
818     * @param _beneficiary Address receiving the tokens
819     * @param _weiAmount Value in wei involved in the purchase
820     * @param _tokenAmount Value in token involved in the purchase
821     */
822     function _updatePurchasingState(
823         address _beneficiary,
824         uint256 _weiAmount,
825         uint256 _tokenAmount
826     )
827         internal
828     {
829         super._updatePurchasingState(_beneficiary, _weiAmount, _tokenAmount);
830     }
831     
832     /**
833     * @dev Overrides delivery by minting tokens upon purchase. - MINTED Crowdsale
834     * @param _beneficiary Token purchaser
835     * @param _tokenAmount Number of tokens to be minted
836     */
837     function _deliverTokens(
838         address _beneficiary,
839         uint256 _tokenAmount
840     )
841         internal
842     {
843         // Potentially dangerous assumption about the type of the token.
844         require(MintableERC20(address(token)).mint(_beneficiary, _tokenAmount));
845     }
846 
847 
848     /**
849     * @dev Extend parent behavior requiring purchase to respect the funding cap.
850     * @param _beneficiary Token purchaser
851     * @param _weiAmount Amount of wei contributed
852     * @param _tokenAmount Amount of token purchased
853     */
854     function _preValidatePurchase(
855         address _beneficiary,
856         uint256 _weiAmount,
857         uint256 _tokenAmount
858     )
859         internal
860     {
861         super._preValidatePurchase(_beneficiary, _weiAmount, _tokenAmount);
862         require(_weiAmount >= minimumContribution);
863         require(tokensSold.add(_tokenAmount) <= cap);
864     }
865 
866 }