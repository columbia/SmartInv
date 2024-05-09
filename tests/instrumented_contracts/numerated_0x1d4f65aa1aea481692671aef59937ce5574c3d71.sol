1 pragma solidity 0.4.24;
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
38 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipRenounced(address indexed previousOwner);
50   event OwnershipTransferred(
51     address indexed previousOwner,
52     address indexed newOwner
53   );
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   constructor() public {
61     owner = msg.sender;
62   }
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   /**
73    * @dev Allows the current owner to relinquish control of the contract.
74    * @notice Renouncing to ownership will leave the contract without an owner.
75    * It will not be possible to call the functions with the `onlyOwner`
76    * modifier anymore.
77    */
78   function renounceOwnership() public onlyOwner {
79     emit OwnershipRenounced(owner);
80     owner = address(0);
81   }
82 
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param _newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address _newOwner) public onlyOwner {
88     _transferOwnership(_newOwner);
89   }
90 
91   /**
92    * @dev Transfers control of the contract to a newOwner.
93    * @param _newOwner The address to transfer ownership to.
94    */
95   function _transferOwnership(address _newOwner) internal {
96     require(_newOwner != address(0));
97     emit OwnershipTransferred(owner, _newOwner);
98     owner = _newOwner;
99   }
100 }
101 
102 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
103 
104 /**
105  * @title SafeERC20
106  * @dev Wrappers around ERC20 operations that throw on failure.
107  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
108  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
109  */
110 library SafeERC20 {
111   function safeTransfer(
112     ERC20Basic _token,
113     address _to,
114     uint256 _value
115   )
116     internal
117   {
118     require(_token.transfer(_to, _value));
119   }
120 
121   function safeTransferFrom(
122     ERC20 _token,
123     address _from,
124     address _to,
125     uint256 _value
126   )
127     internal
128   {
129     require(_token.transferFrom(_from, _to, _value));
130   }
131 
132   function safeApprove(
133     ERC20 _token,
134     address _spender,
135     uint256 _value
136   )
137     internal
138   {
139     require(_token.approve(_spender, _value));
140   }
141 }
142 
143 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
144 
145 /**
146  * @title Contracts that should be able to recover tokens
147  * @author SylTi
148  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
149  * This will prevent any accidental loss of tokens.
150  */
151 contract CanReclaimToken is Ownable {
152   using SafeERC20 for ERC20Basic;
153 
154   /**
155    * @dev Reclaim all ERC20Basic compatible tokens
156    * @param _token ERC20Basic The address of the token contract
157    */
158   function reclaimToken(ERC20Basic _token) external onlyOwner {
159     uint256 balance = _token.balanceOf(this);
160     _token.safeTransfer(owner, balance);
161   }
162 
163 }
164 
165 // File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol
166 
167 /**
168  * @title Contracts that should not own Tokens
169  * @author Remco Bloemen <remco@2π.com>
170  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
171  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
172  * owner to reclaim the tokens.
173  */
174 contract HasNoTokens is CanReclaimToken {
175 
176  /**
177   * @dev Reject all ERC223 compatible tokens
178   * @param _from address The address that is transferring the tokens
179   * @param _value uint256 the amount of the specified token
180   * @param _data Bytes The data passed from the caller.
181   */
182   function tokenFallback(
183     address _from,
184     uint256 _value,
185     bytes _data
186   )
187     external
188     pure
189   {
190     _from;
191     _value;
192     _data;
193     revert();
194   }
195 
196 }
197 
198 // File: openzeppelin-solidity/contracts/ownership/HasNoContracts.sol
199 
200 /**
201  * @title Contracts that should not own Contracts
202  * @author Remco Bloemen <remco@2π.com>
203  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
204  * of this contract to reclaim ownership of the contracts.
205  */
206 contract HasNoContracts is Ownable {
207 
208   /**
209    * @dev Reclaim ownership of Ownable contracts
210    * @param _contractAddr The address of the Ownable to be reclaimed.
211    */
212   function reclaimContract(address _contractAddr) external onlyOwner {
213     Ownable contractInst = Ownable(_contractAddr);
214     contractInst.transferOwnership(owner);
215   }
216 }
217 
218 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
219 
220 /**
221  * @title SafeMath
222  * @dev Math operations with safety checks that throw on error
223  */
224 library SafeMath {
225 
226   /**
227   * @dev Multiplies two numbers, throws on overflow.
228   */
229   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
230     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
231     // benefit is lost if 'b' is also tested.
232     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
233     if (_a == 0) {
234       return 0;
235     }
236 
237     c = _a * _b;
238     assert(c / _a == _b);
239     return c;
240   }
241 
242   /**
243   * @dev Integer division of two numbers, truncating the quotient.
244   */
245   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
246     // assert(_b > 0); // Solidity automatically throws when dividing by 0
247     // uint256 c = _a / _b;
248     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
249     return _a / _b;
250   }
251 
252   /**
253   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
254   */
255   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
256     assert(_b <= _a);
257     return _a - _b;
258   }
259 
260   /**
261   * @dev Adds two numbers, throws on overflow.
262   */
263   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
264     c = _a + _b;
265     assert(c >= _a);
266     return c;
267   }
268 }
269 
270 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
271 
272 /**
273  * @title Crowdsale
274  * @dev Crowdsale is a base contract for managing a token crowdsale,
275  * allowing investors to purchase tokens with ether. This contract implements
276  * such functionality in its most fundamental form and can be extended to provide additional
277  * functionality and/or custom behavior.
278  * The external interface represents the basic interface for purchasing tokens, and conform
279  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
280  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
281  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
282  * behavior.
283  */
284 contract Crowdsale {
285   using SafeMath for uint256;
286   using SafeERC20 for ERC20;
287 
288   // The token being sold
289   ERC20 public token;
290 
291   // Address where funds are collected
292   address public wallet;
293 
294   // How many token units a buyer gets per wei.
295   // The rate is the conversion between wei and the smallest and indivisible token unit.
296   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
297   // 1 wei will give you 1 unit, or 0.001 TOK.
298   uint256 public rate;
299 
300   // Amount of wei raised
301   uint256 public weiRaised;
302 
303   /**
304    * Event for token purchase logging
305    * @param purchaser who paid for the tokens
306    * @param beneficiary who got the tokens
307    * @param value weis paid for purchase
308    * @param amount amount of tokens purchased
309    */
310   event TokenPurchase(
311     address indexed purchaser,
312     address indexed beneficiary,
313     uint256 value,
314     uint256 amount
315   );
316 
317   /**
318    * @param _rate Number of token units a buyer gets per wei
319    * @param _wallet Address where collected funds will be forwarded to
320    * @param _token Address of the token being sold
321    */
322   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
323     require(_rate > 0);
324     require(_wallet != address(0));
325     require(_token != address(0));
326 
327     rate = _rate;
328     wallet = _wallet;
329     token = _token;
330   }
331 
332   // -----------------------------------------
333   // Crowdsale external interface
334   // -----------------------------------------
335 
336   /**
337    * @dev fallback function ***DO NOT OVERRIDE***
338    */
339   function () external payable {
340     buyTokens(msg.sender);
341   }
342 
343   /**
344    * @dev low level token purchase ***DO NOT OVERRIDE***
345    * @param _beneficiary Address performing the token purchase
346    */
347   function buyTokens(address _beneficiary) public payable {
348 
349     uint256 weiAmount = msg.value;
350     _preValidatePurchase(_beneficiary, weiAmount);
351 
352     // calculate token amount to be created
353     uint256 tokens = _getTokenAmount(weiAmount);
354 
355     // update state
356     weiRaised = weiRaised.add(weiAmount);
357 
358     _processPurchase(_beneficiary, tokens);
359     emit TokenPurchase(
360       msg.sender,
361       _beneficiary,
362       weiAmount,
363       tokens
364     );
365 
366     _updatePurchasingState(_beneficiary, weiAmount);
367 
368     _forwardFunds();
369     _postValidatePurchase(_beneficiary, weiAmount);
370   }
371 
372   // -----------------------------------------
373   // Internal interface (extensible)
374   // -----------------------------------------
375 
376   /**
377    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
378    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
379    *   super._preValidatePurchase(_beneficiary, _weiAmount);
380    *   require(weiRaised.add(_weiAmount) <= cap);
381    * @param _beneficiary Address performing the token purchase
382    * @param _weiAmount Value in wei involved in the purchase
383    */
384   function _preValidatePurchase(
385     address _beneficiary,
386     uint256 _weiAmount
387   )
388     internal
389   {
390     require(_beneficiary != address(0));
391     require(_weiAmount != 0);
392   }
393 
394   /**
395    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
396    * @param _beneficiary Address performing the token purchase
397    * @param _weiAmount Value in wei involved in the purchase
398    */
399   function _postValidatePurchase(
400     address _beneficiary,
401     uint256 _weiAmount
402   )
403     internal
404   {
405     // optional override
406   }
407 
408   /**
409    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
410    * @param _beneficiary Address performing the token purchase
411    * @param _tokenAmount Number of tokens to be emitted
412    */
413   function _deliverTokens(
414     address _beneficiary,
415     uint256 _tokenAmount
416   )
417     internal
418   {
419     token.safeTransfer(_beneficiary, _tokenAmount);
420   }
421 
422   /**
423    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
424    * @param _beneficiary Address receiving the tokens
425    * @param _tokenAmount Number of tokens to be purchased
426    */
427   function _processPurchase(
428     address _beneficiary,
429     uint256 _tokenAmount
430   )
431     internal
432   {
433     _deliverTokens(_beneficiary, _tokenAmount);
434   }
435 
436   /**
437    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
438    * @param _beneficiary Address receiving the tokens
439    * @param _weiAmount Value in wei involved in the purchase
440    */
441   function _updatePurchasingState(
442     address _beneficiary,
443     uint256 _weiAmount
444   )
445     internal
446   {
447     // optional override
448   }
449 
450   /**
451    * @dev Override to extend the way in which ether is converted to tokens.
452    * @param _weiAmount Value in wei to be converted into tokens
453    * @return Number of tokens that can be purchased with the specified _weiAmount
454    */
455   function _getTokenAmount(uint256 _weiAmount)
456     internal view returns (uint256)
457   {
458     return _weiAmount.mul(rate);
459   }
460 
461   /**
462    * @dev Determines how ETH is stored/forwarded on purchases.
463    */
464   function _forwardFunds() internal {
465     wallet.transfer(msg.value);
466   }
467 }
468 
469 // File: openzeppelin-solidity/contracts/crowdsale/validation/IndividuallyCappedCrowdsale.sol
470 
471 /**
472  * @title IndividuallyCappedCrowdsale
473  * @dev Crowdsale with per-user caps.
474  */
475 contract IndividuallyCappedCrowdsale is Ownable, Crowdsale {
476   using SafeMath for uint256;
477 
478   mapping(address => uint256) public contributions;
479   mapping(address => uint256) public caps;
480 
481   /**
482    * @dev Sets a specific user's maximum contribution.
483    * @param _beneficiary Address to be capped
484    * @param _cap Wei limit for individual contribution
485    */
486   function setUserCap(address _beneficiary, uint256 _cap) external onlyOwner {
487     caps[_beneficiary] = _cap;
488   }
489 
490   /**
491    * @dev Sets a group of users' maximum contribution.
492    * @param _beneficiaries List of addresses to be capped
493    * @param _cap Wei limit for individual contribution
494    */
495   function setGroupCap(
496     address[] _beneficiaries,
497     uint256 _cap
498   )
499     external
500     onlyOwner
501   {
502     for (uint256 i = 0; i < _beneficiaries.length; i++) {
503       caps[_beneficiaries[i]] = _cap;
504     }
505   }
506 
507   /**
508    * @dev Returns the cap of a specific user.
509    * @param _beneficiary Address whose cap is to be checked
510    * @return Current cap for individual user
511    */
512   function getUserCap(address _beneficiary) public view returns (uint256) {
513     return caps[_beneficiary];
514   }
515 
516   /**
517    * @dev Returns the amount contributed so far by a sepecific user.
518    * @param _beneficiary Address of contributor
519    * @return User contribution so far
520    */
521   function getUserContribution(address _beneficiary)
522     public view returns (uint256)
523   {
524     return contributions[_beneficiary];
525   }
526 
527   /**
528    * @dev Extend parent behavior requiring purchase to respect the user's funding cap.
529    * @param _beneficiary Token purchaser
530    * @param _weiAmount Amount of wei contributed
531    */
532   function _preValidatePurchase(
533     address _beneficiary,
534     uint256 _weiAmount
535   )
536     internal
537   {
538     super._preValidatePurchase(_beneficiary, _weiAmount);
539     require(contributions[_beneficiary].add(_weiAmount) <= caps[_beneficiary]);
540   }
541 
542   /**
543    * @dev Extend parent behavior to update user contributions
544    * @param _beneficiary Token purchaser
545    * @param _weiAmount Amount of wei contributed
546    */
547   function _updatePurchasingState(
548     address _beneficiary,
549     uint256 _weiAmount
550   )
551     internal
552   {
553     super._updatePurchasingState(_beneficiary, _weiAmount);
554     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
555   }
556 
557 }
558 
559 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
560 
561 /**
562  * @title CappedCrowdsale
563  * @dev Crowdsale with a limit for total contributions.
564  */
565 contract CappedCrowdsale is Crowdsale {
566   using SafeMath for uint256;
567 
568   uint256 public cap;
569 
570   /**
571    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
572    * @param _cap Max amount of wei to be contributed
573    */
574   constructor(uint256 _cap) public {
575     require(_cap > 0);
576     cap = _cap;
577   }
578 
579   /**
580    * @dev Checks whether the cap has been reached.
581    * @return Whether the cap was reached
582    */
583   function capReached() public view returns (bool) {
584     return weiRaised >= cap;
585   }
586 
587   /**
588    * @dev Extend parent behavior requiring purchase to respect the funding cap.
589    * @param _beneficiary Token purchaser
590    * @param _weiAmount Amount of wei contributed
591    */
592   function _preValidatePurchase(
593     address _beneficiary,
594     uint256 _weiAmount
595   )
596     internal
597   {
598     super._preValidatePurchase(_beneficiary, _weiAmount);
599     require(weiRaised.add(_weiAmount) <= cap);
600   }
601 
602 }
603 
604 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
605 
606 /**
607  * @title TimedCrowdsale
608  * @dev Crowdsale accepting contributions only within a time frame.
609  */
610 contract TimedCrowdsale is Crowdsale {
611   using SafeMath for uint256;
612 
613   uint256 public openingTime;
614   uint256 public closingTime;
615 
616   /**
617    * @dev Reverts if not in crowdsale time range.
618    */
619   modifier onlyWhileOpen {
620     // solium-disable-next-line security/no-block-members
621     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
622     _;
623   }
624 
625   /**
626    * @dev Constructor, takes crowdsale opening and closing times.
627    * @param _openingTime Crowdsale opening time
628    * @param _closingTime Crowdsale closing time
629    */
630   constructor(uint256 _openingTime, uint256 _closingTime) public {
631     // solium-disable-next-line security/no-block-members
632     require(_openingTime >= block.timestamp);
633     require(_closingTime >= _openingTime);
634 
635     openingTime = _openingTime;
636     closingTime = _closingTime;
637   }
638 
639   /**
640    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
641    * @return Whether crowdsale period has elapsed
642    */
643   function hasClosed() public view returns (bool) {
644     // solium-disable-next-line security/no-block-members
645     return block.timestamp > closingTime;
646   }
647 
648   /**
649    * @dev Extend parent behavior requiring to be within contributing period
650    * @param _beneficiary Token purchaser
651    * @param _weiAmount Amount of wei contributed
652    */
653   function _preValidatePurchase(
654     address _beneficiary,
655     uint256 _weiAmount
656   )
657     internal
658     onlyWhileOpen
659   {
660     super._preValidatePurchase(_beneficiary, _weiAmount);
661   }
662 
663 }
664 
665 // File: openzeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol
666 
667 /**
668  * @title AllowanceCrowdsale
669  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
670  */
671 contract AllowanceCrowdsale is Crowdsale {
672   using SafeMath for uint256;
673   using SafeERC20 for ERC20;
674 
675   address public tokenWallet;
676 
677   /**
678    * @dev Constructor, takes token wallet address.
679    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
680    */
681   constructor(address _tokenWallet) public {
682     require(_tokenWallet != address(0));
683     tokenWallet = _tokenWallet;
684   }
685 
686   /**
687    * @dev Checks the amount of tokens left in the allowance.
688    * @return Amount of tokens left in the allowance
689    */
690   function remainingTokens() public view returns (uint256) {
691     return token.allowance(tokenWallet, this);
692   }
693 
694   /**
695    * @dev Overrides parent behavior by transferring tokens from wallet.
696    * @param _beneficiary Token purchaser
697    * @param _tokenAmount Amount of tokens purchased
698    */
699   function _deliverTokens(
700     address _beneficiary,
701     uint256 _tokenAmount
702   )
703     internal
704   {
705     token.safeTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
706   }
707 }
708 
709 // File: contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
710 
711 /**
712  * @title PostDeliveryCrowdsale
713  * @dev Crowdsale that locks tokens from withdrawal until it ends.
714  */
715 contract PostDeliveryCrowdsale is TimedCrowdsale {
716   using SafeMath for uint256;
717 
718   mapping(address => uint256) public balances;
719 
720   /// @dev Withdraw tokens only after crowdsale ends.
721   function withdrawTokens() public {
722     _withdrawTokens(msg.sender);
723   }
724 
725   /**
726    * @dev Withdraw tokens only after crowdsale ends.
727    * @param _beneficiary Token purchaser
728    */
729   function _withdrawTokens(address _beneficiary) internal {
730     require(hasClosed(), "Crowdsale not closed.");
731     uint256 amount = balances[_beneficiary];
732     require(amount > 0, "Beneficiary has zero balance.");
733     balances[_beneficiary] = 0;
734     _deliverTokens(_beneficiary, amount);
735   }
736 
737   /**
738    * @dev Overrides parent by storing balances instead of issuing tokens right away.
739    * @param _beneficiary Token purchaser
740    * @param _tokenAmount Amount of tokens purchased
741    */
742   function _processPurchase(
743     address _beneficiary,
744     uint256 _tokenAmount
745   )
746     internal
747   {
748     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
749   }
750 
751 }
752 
753 // File: contracts/TokenCrowdsale.sol
754 
755 /**
756  * @title TokenCrowdsale
757  * @dev This is a ERC20 token crowdsale that will sell tokens util
758  * the cap is reached, time expired or the allowance is spent.
759  */
760 // solium-disable-next-line
761 contract TokenCrowdsale
762   is
763     HasNoTokens,
764     HasNoContracts,
765     TimedCrowdsale,
766     CappedCrowdsale,
767     IndividuallyCappedCrowdsale,
768     PostDeliveryCrowdsale,
769     AllowanceCrowdsale
770 {
771 
772   // When withdrawals open
773   uint256 public withdrawTime;
774 
775   // Amount of tokens sold
776   uint256 public tokensSold;
777 
778   // Amount of tokens delivered
779   uint256 public tokensDelivered;
780 
781   constructor(
782     uint256 _rate,
783     address _wallet,
784     ERC20 _token,
785     address _tokenWallet,
786     uint256 _cap,
787     uint256 _openingTime,
788     uint256 _closingTime,
789     uint256 _withdrawTime
790   )
791     public
792     Crowdsale(_rate, _wallet, _token)
793     TimedCrowdsale(_openingTime, _closingTime)
794     CappedCrowdsale(_cap)
795     AllowanceCrowdsale(_tokenWallet)
796   {
797     require(_withdrawTime >= _closingTime, "Withdrawals should open after crowdsale closes.");
798     withdrawTime = _withdrawTime;
799   }
800 
801   /**
802    * @dev Checks whether the period in which the crowdsale is open
803    * has already elapsed or cap was reached.
804    * @return Whether crowdsale has ended
805    */
806   function hasEnded() public view returns (bool) {
807     return hasClosed() || capReached();
808   }
809 
810   /**
811    * @dev Withdraw tokens only after crowdsale ends.
812    * @param _beneficiary Token purchaser
813    */
814   function withdrawTokens(address _beneficiary) public {
815     _withdrawTokens(_beneficiary);
816   }
817 
818   /**
819    * @dev Withdraw tokens only after crowdsale ends.
820    * @param _beneficiaries List of token purchasers
821    */
822   function withdrawTokens(address[] _beneficiaries) public {
823     for (uint32 i = 0; i < _beneficiaries.length; i ++) {
824       _withdrawTokens(_beneficiaries[i]);
825     }
826   }
827 
828   /**
829    * @dev We use this function to store the total amount of tokens sold
830    * @param _beneficiary Token purchaser
831    * @param _tokenAmount Amount of tokens purchased
832    */
833   function _processPurchase(
834     address _beneficiary,
835     uint256 _tokenAmount
836   )
837     internal
838   {
839     super._processPurchase(_beneficiary, _tokenAmount);
840     tokensSold = tokensSold.add(_tokenAmount);
841   }
842 
843   /**
844    * @dev We use this function to store the total amount of tokens delivered
845    * @param _beneficiary Address performing the token purchase
846    * @param _tokenAmount Number of tokens to be emitted
847    */
848   function _deliverTokens(
849     address _beneficiary,
850     uint256 _tokenAmount
851   )
852     internal
853   {
854     super._deliverTokens(_beneficiary, _tokenAmount);
855     tokensDelivered = tokensDelivered.add(_tokenAmount);
856   }
857 
858   /**
859    * @dev Withdraw tokens only after crowdsale ends.
860    * @param _beneficiary Token purchaser
861    */
862   function _withdrawTokens(address _beneficiary) internal {
863     // solium-disable-next-line security/no-block-members
864     require(block.timestamp > withdrawTime, "Withdrawals not open.");
865     super._withdrawTokens(_beneficiary);
866   }
867 
868 }