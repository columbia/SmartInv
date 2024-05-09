1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
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
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
105 
106 /**
107  * @title SafeERC20
108  * @dev Wrappers around ERC20 operations that throw on failure.
109  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
110  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
111  */
112 library SafeERC20 {
113   function safeTransfer(
114     IERC20 token,
115     address to,
116     uint256 value
117   )
118     internal
119   {
120     require(token.transfer(to, value));
121   }
122 
123   function safeTransferFrom(
124     IERC20 token,
125     address from,
126     address to,
127     uint256 value
128   )
129     internal
130   {
131     require(token.transferFrom(from, to, value));
132   }
133 
134   function safeApprove(
135     IERC20 token,
136     address spender,
137     uint256 value
138   )
139     internal
140   {
141     require(token.approve(spender, value));
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
146 
147 /**
148  * @title Crowdsale
149  * @dev Crowdsale is a base contract for managing a token crowdsale,
150  * allowing investors to purchase tokens with ether. This contract implements
151  * such functionality in its most fundamental form and can be extended to provide additional
152  * functionality and/or custom behavior.
153  * The external interface represents the basic interface for purchasing tokens, and conform
154  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
155  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
156  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
157  * behavior.
158  */
159 contract Crowdsale {
160   using SafeMath for uint256;
161   using SafeERC20 for IERC20;
162 
163   // The token being sold
164   IERC20 private _token;
165 
166   // Address where funds are collected
167   address private _wallet;
168 
169   // How many token units a buyer gets per wei.
170   // The rate is the conversion between wei and the smallest and indivisible token unit.
171   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
172   // 1 wei will give you 1 unit, or 0.001 TOK.
173   uint256 private _rate;
174 
175   // Amount of wei raised
176   uint256 private _weiRaised;
177 
178   /**
179    * Event for token purchase logging
180    * @param purchaser who paid for the tokens
181    * @param beneficiary who got the tokens
182    * @param value weis paid for purchase
183    * @param amount amount of tokens purchased
184    */
185   event TokensPurchased(
186     address indexed purchaser,
187     address indexed beneficiary,
188     uint256 value,
189     uint256 amount
190   );
191 
192   /**
193    * @param rate Number of token units a buyer gets per wei
194    * @dev The rate is the conversion between wei and the smallest and indivisible
195    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
196    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
197    * @param wallet Address where collected funds will be forwarded to
198    * @param token Address of the token being sold
199    */
200   constructor(uint256 rate, address wallet, IERC20 token) public {
201     require(rate > 0);
202     require(wallet != address(0));
203     require(token != address(0));
204 
205     _rate = rate;
206     _wallet = wallet;
207     _token = token;
208   }
209 
210   // -----------------------------------------
211   // Crowdsale external interface
212   // -----------------------------------------
213 
214   /**
215    * @dev fallback function ***DO NOT OVERRIDE***
216    */
217   function () external payable {
218     buyTokens(msg.sender);
219   }
220 
221   /**
222    * @return the token being sold.
223    */
224   function token() public view returns(IERC20) {
225     return _token;
226   }
227 
228   /**
229    * @return the address where funds are collected.
230    */
231   function wallet() public view returns(address) {
232     return _wallet;
233   }
234 
235   /**
236    * @return the number of token units a buyer gets per wei.
237    */
238   function rate() public view returns(uint256) {
239     return _rate;
240   }
241 
242   /**
243    * @return the mount of wei raised.
244    */
245   function weiRaised() public view returns (uint256) {
246     return _weiRaised;
247   }
248 
249   /**
250    * @dev low level token purchase ***DO NOT OVERRIDE***
251    * @param beneficiary Address performing the token purchase
252    */
253   function buyTokens(address beneficiary) public payable {
254 
255     uint256 weiAmount = msg.value;
256     _preValidatePurchase(beneficiary, weiAmount);
257 
258     // calculate token amount to be created
259     uint256 tokens = _getTokenAmount(weiAmount);
260 
261     // update state
262     _weiRaised = _weiRaised.add(weiAmount);
263 
264     _processPurchase(beneficiary, tokens);
265     emit TokensPurchased(
266       msg.sender,
267       beneficiary,
268       weiAmount,
269       tokens
270     );
271 
272     _updatePurchasingState(beneficiary, weiAmount);
273 
274     _forwardFunds();
275     _postValidatePurchase(beneficiary, weiAmount);
276   }
277 
278   // -----------------------------------------
279   // Internal interface (extensible)
280   // -----------------------------------------
281 
282   /**
283    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
284    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
285    *   super._preValidatePurchase(beneficiary, weiAmount);
286    *   require(weiRaised().add(weiAmount) <= cap);
287    * @param beneficiary Address performing the token purchase
288    * @param weiAmount Value in wei involved in the purchase
289    */
290   function _preValidatePurchase(
291     address beneficiary,
292     uint256 weiAmount
293   )
294     internal
295   {
296     require(beneficiary != address(0));
297     require(weiAmount != 0);
298   }
299 
300   /**
301    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
302    * @param beneficiary Address performing the token purchase
303    * @param weiAmount Value in wei involved in the purchase
304    */
305   function _postValidatePurchase(
306     address beneficiary,
307     uint256 weiAmount
308   )
309     internal
310   {
311     // optional override
312   }
313 
314   /**
315    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
316    * @param beneficiary Address performing the token purchase
317    * @param tokenAmount Number of tokens to be emitted
318    */
319   function _deliverTokens(
320     address beneficiary,
321     uint256 tokenAmount
322   )
323     internal
324   {
325     _token.safeTransfer(beneficiary, tokenAmount);
326   }
327 
328   /**
329    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
330    * @param beneficiary Address receiving the tokens
331    * @param tokenAmount Number of tokens to be purchased
332    */
333   function _processPurchase(
334     address beneficiary,
335     uint256 tokenAmount
336   )
337     internal
338   {
339     _deliverTokens(beneficiary, tokenAmount);
340   }
341 
342   /**
343    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
344    * @param beneficiary Address receiving the tokens
345    * @param weiAmount Value in wei involved in the purchase
346    */
347   function _updatePurchasingState(
348     address beneficiary,
349     uint256 weiAmount
350   )
351     internal
352   {
353     // optional override
354   }
355 
356   /**
357    * @dev Override to extend the way in which ether is converted to tokens.
358    * @param weiAmount Value in wei to be converted into tokens
359    * @return Number of tokens that can be purchased with the specified _weiAmount
360    */
361   function _getTokenAmount(uint256 weiAmount)
362     internal view returns (uint256)
363   {
364     return weiAmount.mul(_rate);
365   }
366 
367   /**
368    * @dev Determines how ETH is stored/forwarded on purchases.
369    */
370   function _forwardFunds() internal {
371     _wallet.transfer(msg.value);
372   }
373 }
374 
375 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
376 
377 /**
378  * @title TimedCrowdsale
379  * @dev Crowdsale accepting contributions only within a time frame.
380  */
381 contract TimedCrowdsale is Crowdsale {
382   using SafeMath for uint256;
383 
384   uint256 private _openingTime;
385   uint256 private _closingTime;
386 
387   /**
388    * @dev Reverts if not in crowdsale time range.
389    */
390   modifier onlyWhileOpen {
391     require(isOpen());
392     _;
393   }
394 
395   /**
396    * @dev Constructor, takes crowdsale opening and closing times.
397    * @param openingTime Crowdsale opening time
398    * @param closingTime Crowdsale closing time
399    */
400   constructor(uint256 openingTime, uint256 closingTime) public {
401     // solium-disable-next-line security/no-block-members
402     require(openingTime >= block.timestamp);
403     require(closingTime >= openingTime);
404 
405     _openingTime = openingTime;
406     _closingTime = closingTime;
407   }
408 
409   /**
410    * @return the crowdsale opening time.
411    */
412   function openingTime() public view returns(uint256) {
413     return _openingTime;
414   }
415 
416   /**
417    * @return the crowdsale closing time.
418    */
419   function closingTime() public view returns(uint256) {
420     return _closingTime;
421   }
422 
423   /**
424    * @return true if the crowdsale is open, false otherwise.
425    */
426   function isOpen() public view returns (bool) {
427     // solium-disable-next-line security/no-block-members
428     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
429   }
430 
431   /**
432    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
433    * @return Whether crowdsale period has elapsed
434    */
435   function hasClosed() public view returns (bool) {
436     // solium-disable-next-line security/no-block-members
437     return block.timestamp > _closingTime;
438   }
439 
440   /**
441    * @dev Extend parent behavior requiring to be within contributing period
442    * @param beneficiary Token purchaser
443    * @param weiAmount Amount of wei contributed
444    */
445   function _preValidatePurchase(
446     address beneficiary,
447     uint256 weiAmount
448   )
449     internal
450     onlyWhileOpen
451   {
452     super._preValidatePurchase(beneficiary, weiAmount);
453   }
454 
455 }
456 
457 // File: openzeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
458 
459 /**
460  * @title PostDeliveryCrowdsale
461  * @dev Crowdsale that locks tokens from withdrawal until it ends.
462  */
463 contract PostDeliveryCrowdsale is TimedCrowdsale {
464   using SafeMath for uint256;
465 
466   mapping(address => uint256) private _balances;
467 
468   /**
469    * @dev Withdraw tokens only after crowdsale ends.
470    * @param beneficiary Whose tokens will be withdrawn.
471    */
472   function withdrawTokens(address beneficiary) public {
473     require(hasClosed());
474     uint256 amount = _balances[beneficiary];
475     require(amount > 0);
476     _balances[beneficiary] = 0;
477     _deliverTokens(beneficiary, amount);
478   }
479 
480   /**
481    * @return the balance of an account.
482    */
483   function balanceOf(address account) public view returns(uint256) {
484     return _balances[account];
485   }
486 
487   /**
488    * @dev Overrides parent by storing balances instead of issuing tokens right away.
489    * @param beneficiary Token purchaser
490    * @param tokenAmount Amount of tokens purchased
491    */
492   function _processPurchase(
493     address beneficiary,
494     uint256 tokenAmount
495   )
496     internal
497   {
498     _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
499   }
500 
501 }
502 
503 // File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
504 
505 /**
506  * @title FinalizableCrowdsale
507  * @dev Extension of Crowdsale with a one-off finalization action, where one
508  * can do extra work after finishing.
509  */
510 contract FinalizableCrowdsale is TimedCrowdsale {
511   using SafeMath for uint256;
512 
513   bool private _finalized = false;
514 
515   event CrowdsaleFinalized();
516 
517   /**
518    * @return true if the crowdsale is finalized, false otherwise.
519    */
520   function finalized() public view returns (bool) {
521     return _finalized;
522   }
523 
524   /**
525    * @dev Must be called after crowdsale ends, to do some extra finalization
526    * work. Calls the contract's finalization function.
527    */
528   function finalize() public {
529     require(!_finalized);
530     require(hasClosed());
531 
532     _finalization();
533     emit CrowdsaleFinalized();
534 
535     _finalized = true;
536   }
537 
538   /**
539    * @dev Can be overridden to add finalization logic. The overriding function
540    * should call super._finalization() to ensure the chain of finalization is
541    * executed entirely.
542    */
543   function _finalization() internal {
544   }
545 
546 }
547 
548 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
549 
550 /**
551  * @title Ownable
552  * @dev The Ownable contract has an owner address, and provides basic authorization control
553  * functions, this simplifies the implementation of "user permissions".
554  */
555 contract Ownable {
556   address private _owner;
557 
558 
559   event OwnershipRenounced(address indexed previousOwner);
560   event OwnershipTransferred(
561     address indexed previousOwner,
562     address indexed newOwner
563   );
564 
565 
566   /**
567    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
568    * account.
569    */
570   constructor() public {
571     _owner = msg.sender;
572   }
573 
574   /**
575    * @return the address of the owner.
576    */
577   function owner() public view returns(address) {
578     return _owner;
579   }
580 
581   /**
582    * @dev Throws if called by any account other than the owner.
583    */
584   modifier onlyOwner() {
585     require(isOwner());
586     _;
587   }
588 
589   /**
590    * @return true if `msg.sender` is the owner of the contract.
591    */
592   function isOwner() public view returns(bool) {
593     return msg.sender == _owner;
594   }
595 
596   /**
597    * @dev Allows the current owner to relinquish control of the contract.
598    * @notice Renouncing to ownership will leave the contract without an owner.
599    * It will not be possible to call the functions with the `onlyOwner`
600    * modifier anymore.
601    */
602   function renounceOwnership() public onlyOwner {
603     emit OwnershipRenounced(_owner);
604     _owner = address(0);
605   }
606 
607   /**
608    * @dev Allows the current owner to transfer control of the contract to a newOwner.
609    * @param newOwner The address to transfer ownership to.
610    */
611   function transferOwnership(address newOwner) public onlyOwner {
612     _transferOwnership(newOwner);
613   }
614 
615   /**
616    * @dev Transfers control of the contract to a newOwner.
617    * @param newOwner The address to transfer ownership to.
618    */
619   function _transferOwnership(address newOwner) internal {
620     require(newOwner != address(0));
621     emit OwnershipTransferred(_owner, newOwner);
622     _owner = newOwner;
623   }
624 }
625 
626 // File: contracts/Whitelist.sol
627 
628 contract Whitelist is Ownable {
629 
630   mapping (address => bool) private whitelistedAddresses;
631 
632   mapping (address => bool) private admins;
633 
634   modifier onlyIfWhitelisted(address _addr) {
635     require(whitelistedAddresses[_addr] == true, "Address not on the whitelist!");
636     _;
637   }
638 
639   modifier onlyAdmins() {
640     require(admins[msg.sender] == true || isOwner(), "Not an admin!");
641     _;
642   }
643 
644   function addAdmin(address _addr)
645     external
646     onlyOwner
647   {
648     admins[_addr] = true;
649   }
650 
651   function removeAdmin(address _addr)
652     external
653     onlyOwner
654   {
655     admins[_addr] = false;
656   }
657 
658   function isAdmin(address _addr)
659     public
660     view
661     returns(bool)
662   {
663     return admins[_addr];
664   }
665 
666   function addAddressToWhitelist(address _addr)
667     public
668     onlyAdmins
669   {
670     whitelistedAddresses[_addr] = true;
671   }
672 
673   function whitelist(address _addr)
674     public
675     view
676     returns(bool)
677   {
678     return whitelistedAddresses[_addr];
679   }
680 
681   function addAddressesToWhitelist(address[] _addrs)
682     public
683     onlyAdmins
684   {
685     for (uint256 i = 0; i < _addrs.length; i++) {
686       addAddressToWhitelist(_addrs[i]);
687     }
688   }
689 
690   function removeAddressFromWhitelist(address _addr)
691     public
692     onlyAdmins
693   {
694     whitelistedAddresses[_addr] = false;
695   }
696 
697   function removeAddressesFromWhitelist(address[] _addrs)
698     public
699     onlyAdmins
700   {
701     for (uint256 i = 0; i < _addrs.length; i++) {
702       removeAddressFromWhitelist(_addrs[i]);
703     }
704   }
705 }
706 
707 // File: contracts/ClarityCrowdsale.sol
708 
709 contract ClarityCrowdsale is
710   Crowdsale,
711   TimedCrowdsale,
712   PostDeliveryCrowdsale,
713   FinalizableCrowdsale,
714   Whitelist
715 {
716 
717   address private advisorWallet; // forward all phase one funds here
718 
719   uint256 private phaseOneRate; // rate for phase one
720 
721   uint256 private phaseTwoRate; // rate for phase teo
722 
723   uint256 private phaseOneTokens = 10000000 * 10**18; // tokens available in phase one
724 
725   uint256 private phaseTwoTokens = 30000000 * 10**18; // tokens available in phase two
726 
727   mapping  (address => address) referrals; // Keep track of referrals for bonuses
728 
729   modifier onlyFounders() {
730     require(msg.sender == super.wallet() || isOwner(), "Not a founder!");
731     _;
732   }
733 
734   constructor(
735     uint256 _phaseOneRate,
736     uint256 _phaseTwoRate,
737     address _advisorWallet,
738     address _founderWallet,
739     uint256 _openingTime,
740     uint256 _closingTime,
741     IERC20 _token
742   )
743     Crowdsale(_phaseTwoRate, _founderWallet, _token)
744     TimedCrowdsale(_openingTime, _closingTime)
745     public
746   {
747       advisorWallet = _advisorWallet;
748       phaseOneRate = _phaseOneRate;
749       phaseTwoRate = _phaseTwoRate;
750   }
751 
752   // overridden from Crowdsale parent contract
753   function _getTokenAmount(uint256 weiAmount)
754     internal view returns (uint256)
755   {
756     if (phaseOneTokens > 0) {
757       uint256 tokens = weiAmount.mul(phaseOneRate);
758       if (tokens > phaseOneTokens) {
759         uint256 weiRemaining = tokens.sub(phaseOneTokens).div(phaseOneRate);
760         tokens = phaseOneTokens.add(super._getTokenAmount(weiRemaining));
761       }
762       return tokens;
763     }
764 
765     return super._getTokenAmount(weiAmount);
766   }
767 
768   // overridden from Crowdsale parent contract
769   function _forwardFunds()
770     internal
771   {
772     uint256 tokens;
773     if (phaseOneTokens > 0) {
774       tokens = msg.value.mul(phaseOneRate);
775       if (tokens > phaseOneTokens) {
776         uint256 weiRemaining = tokens.sub(phaseOneTokens).div(phaseOneRate);
777         phaseOneTokens = 0;
778         advisorWallet.transfer(msg.value.sub(weiRemaining));
779         tokens = weiRemaining.mul(phaseTwoRate);
780         phaseTwoTokens = phaseTwoTokens.sub(tokens);
781         super.wallet().transfer(weiRemaining);
782       } else {
783         phaseOneTokens = phaseOneTokens.sub(tokens);
784         advisorWallet.transfer(msg.value);
785       }
786       return;
787     }
788 
789     tokens = msg.value.mul(phaseTwoRate);
790     phaseTwoTokens = phaseTwoTokens.sub(tokens);
791     super._forwardFunds();
792   }
793 
794   // overridden from Crowdsale parent contract
795   function _preValidatePurchase(
796     address beneficiary,
797     uint256 weiAmount
798   )
799     internal
800     onlyIfWhitelisted(beneficiary)
801   {
802     require(tokensLeft() >= _getTokenAmount(weiAmount), "Insufficient number of tokens to complete purchase!");
803     super._preValidatePurchase(beneficiary, weiAmount);
804   }
805 
806   // overridden from Crowdsale parent contract
807   function _finalization()
808     internal
809     onlyFounders
810   {
811     super.token().safeTransfer(super.wallet(), tokensLeft());
812     super._finalization();
813   }
814 
815   function tokensLeft()
816     public
817     view
818     returns (uint256)
819   {
820     return phaseOneTokens + phaseTwoTokens;
821   }
822 
823   function addReferral(address beneficiary, address referrer)
824     external
825     onlyAdmins
826     onlyIfWhitelisted(referrer)
827     onlyIfWhitelisted(beneficiary)
828   {
829     referrals[beneficiary] = referrer;
830   }
831 
832   // overridden from Crowdsale parent contract
833   function _processPurchase(
834     address beneficiary,
835     uint256 tokenAmount
836   )
837     internal
838   {
839     if (referrals[beneficiary] != 0) {
840       uint256 tokensAvailable = tokensLeft().sub(tokenAmount);
841       uint256 bonus = tokenAmount.mul(15).div(100);
842       if (bonus >= tokensAvailable) {
843         bonus = tokensAvailable;
844         phaseTwoTokens = phaseTwoTokens.sub(tokensAvailable);
845       } else {
846         phaseTwoTokens = phaseTwoTokens.sub(bonus);
847       }
848 
849       if (bonus > 0) {
850         super._processPurchase(referrals[beneficiary], bonus);
851       }
852     }
853 
854     super._processPurchase(beneficiary, tokenAmount);
855   }
856 }