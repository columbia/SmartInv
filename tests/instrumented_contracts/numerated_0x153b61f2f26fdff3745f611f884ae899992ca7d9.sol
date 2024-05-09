1 pragma solidity ^0.4.24;
2 
3 contract RBAC {
4   using Roles for Roles.Role;
5 
6   mapping (string => Roles.Role) private roles;
7 
8   event RoleAdded(address indexed operator, string role);
9   event RoleRemoved(address indexed operator, string role);
10 
11   /**
12    * @dev reverts if addr does not have role
13    * @param _operator address
14    * @param _role the name of the role
15    * // reverts
16    */
17   function checkRole(address _operator, string _role)
18     public
19     view
20   {
21     roles[_role].check(_operator);
22   }
23 
24   /**
25    * @dev determine if addr has role
26    * @param _operator address
27    * @param _role the name of the role
28    * @return bool
29    */
30   function hasRole(address _operator, string _role)
31     public
32     view
33     returns (bool)
34   {
35     return roles[_role].has(_operator);
36   }
37 
38   /**
39    * @dev add a role to an address
40    * @param _operator address
41    * @param _role the name of the role
42    */
43   function addRole(address _operator, string _role)
44     internal
45   {
46     roles[_role].add(_operator);
47     emit RoleAdded(_operator, _role);
48   }
49 
50   /**
51    * @dev remove a role from an address
52    * @param _operator address
53    * @param _role the name of the role
54    */
55   function removeRole(address _operator, string _role)
56     internal
57   {
58     roles[_role].remove(_operator);
59     emit RoleRemoved(_operator, _role);
60   }
61 
62   /**
63    * @dev modifier to scope access to a single role (uses msg.sender as addr)
64    * @param _role the name of the role
65    * // reverts
66    */
67   modifier onlyRole(string _role)
68   {
69     checkRole(msg.sender, _role);
70     _;
71   }
72 
73   /**
74    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
75    * @param _roles the names of the roles to scope access to
76    * // reverts
77    *
78    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
79    *  see: https://github.com/ethereum/solidity/issues/2467
80    */
81   // modifier onlyRoles(string[] _roles) {
82   //     bool hasAnyRole = false;
83   //     for (uint8 i = 0; i < _roles.length; i++) {
84   //         if (hasRole(msg.sender, _roles[i])) {
85   //             hasAnyRole = true;
86   //             break;
87   //         }
88   //     }
89 
90   //     require(hasAnyRole);
91 
92   //     _;
93   // }
94 }
95 
96 library Roles {
97   struct Role {
98     mapping (address => bool) bearer;
99   }
100 
101   /**
102    * @dev give an address access to this role
103    */
104   function add(Role storage _role, address _addr)
105     internal
106   {
107     _role.bearer[_addr] = true;
108   }
109 
110   /**
111    * @dev remove an address' access to this role
112    */
113   function remove(Role storage _role, address _addr)
114     internal
115   {
116     _role.bearer[_addr] = false;
117   }
118 
119   /**
120    * @dev check if an address has this role
121    * // reverts
122    */
123   function check(Role storage _role, address _addr)
124     internal
125     view
126   {
127     require(has(_role, _addr));
128   }
129 
130   /**
131    * @dev check if an address has this role
132    * @return bool
133    */
134   function has(Role storage _role, address _addr)
135     internal
136     view
137     returns (bool)
138   {
139     return _role.bearer[_addr];
140   }
141 }
142 
143 contract Crowdsale {
144   using SafeMath for uint256;
145   using SafeERC20 for ERC20;
146 
147   // The token being sold
148   ERC20 public token;
149 
150   // Address where funds are collected
151   address public wallet;
152 
153   // How many token units a buyer gets per wei.
154   // The rate is the conversion between wei and the smallest and indivisible token unit.
155   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
156   // 1 wei will give you 1 unit, or 0.001 TOK.
157   uint256 public rate;
158 
159   // Amount of wei raised
160   uint256 public weiRaised;
161 
162   /**
163    * Event for token purchase logging
164    * @param purchaser who paid for the tokens
165    * @param beneficiary who got the tokens
166    * @param value weis paid for purchase
167    * @param amount amount of tokens purchased
168    */
169   event TokenPurchase(
170     address indexed purchaser,
171     address indexed beneficiary,
172     uint256 value,
173     uint256 amount
174   );
175 
176   /**
177    * @param _rate Number of token units a buyer gets per wei
178    * @param _wallet Address where collected funds will be forwarded to
179    * @param _token Address of the token being sold
180    */
181   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
182     require(_rate > 0);
183     require(_wallet != address(0));
184     require(_token != address(0));
185 
186     rate = _rate;
187     wallet = _wallet;
188     token = _token;
189   }
190 
191   // -----------------------------------------
192   // Crowdsale external interface
193   // -----------------------------------------
194 
195   /**
196    * @dev fallback function ***DO NOT OVERRIDE***
197    */
198   function () external payable {
199     buyTokens(msg.sender);
200   }
201 
202   /**
203    * @dev low level token purchase ***DO NOT OVERRIDE***
204    * @param _beneficiary Address performing the token purchase
205    */
206   function buyTokens(address _beneficiary) public payable {
207 
208     uint256 weiAmount = msg.value;
209     _preValidatePurchase(_beneficiary, weiAmount);
210 
211     // calculate token amount to be created
212     uint256 tokens = _getTokenAmount(weiAmount);
213 
214     // update state
215     weiRaised = weiRaised.add(weiAmount);
216 
217     _processPurchase(_beneficiary, tokens);
218     emit TokenPurchase(
219       msg.sender,
220       _beneficiary,
221       weiAmount,
222       tokens
223     );
224 
225     _updatePurchasingState(_beneficiary, weiAmount);
226 
227     _forwardFunds();
228     _postValidatePurchase(_beneficiary, weiAmount);
229   }
230 
231   // -----------------------------------------
232   // Internal interface (extensible)
233   // -----------------------------------------
234 
235   /**
236    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
237    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
238    *   super._preValidatePurchase(_beneficiary, _weiAmount);
239    *   require(weiRaised.add(_weiAmount) <= cap);
240    * @param _beneficiary Address performing the token purchase
241    * @param _weiAmount Value in wei involved in the purchase
242    */
243   function _preValidatePurchase(
244     address _beneficiary,
245     uint256 _weiAmount
246   )
247     internal
248   {
249     require(_beneficiary != address(0));
250     require(_weiAmount != 0);
251   }
252 
253   /**
254    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
255    * @param _beneficiary Address performing the token purchase
256    * @param _weiAmount Value in wei involved in the purchase
257    */
258   function _postValidatePurchase(
259     address _beneficiary,
260     uint256 _weiAmount
261   )
262     internal
263   {
264     // optional override
265   }
266 
267   /**
268    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
269    * @param _beneficiary Address performing the token purchase
270    * @param _tokenAmount Number of tokens to be emitted
271    */
272   function _deliverTokens(
273     address _beneficiary,
274     uint256 _tokenAmount
275   )
276     internal
277   {
278     token.safeTransfer(_beneficiary, _tokenAmount);
279   }
280 
281   /**
282    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
283    * @param _beneficiary Address receiving the tokens
284    * @param _tokenAmount Number of tokens to be purchased
285    */
286   function _processPurchase(
287     address _beneficiary,
288     uint256 _tokenAmount
289   )
290     internal
291   {
292     _deliverTokens(_beneficiary, _tokenAmount);
293   }
294 
295   /**
296    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
297    * @param _beneficiary Address receiving the tokens
298    * @param _weiAmount Value in wei involved in the purchase
299    */
300   function _updatePurchasingState(
301     address _beneficiary,
302     uint256 _weiAmount
303   )
304     internal
305   {
306     // optional override
307   }
308 
309   /**
310    * @dev Override to extend the way in which ether is converted to tokens.
311    * @param _weiAmount Value in wei to be converted into tokens
312    * @return Number of tokens that can be purchased with the specified _weiAmount
313    */
314   function _getTokenAmount(uint256 _weiAmount)
315     internal view returns (uint256)
316   {
317     return _weiAmount.mul(rate);
318   }
319 
320   /**
321    * @dev Determines how ETH is stored/forwarded on purchases.
322    */
323   function _forwardFunds() internal {
324     wallet.transfer(msg.value);
325   }
326 }
327 
328 contract TimedCrowdsale is Crowdsale {
329   using SafeMath for uint256;
330 
331   uint256 public openingTime;
332   uint256 public closingTime;
333 
334   /**
335    * @dev Reverts if not in crowdsale time range.
336    */
337   modifier onlyWhileOpen {
338     // solium-disable-next-line security/no-block-members
339     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
340     _;
341   }
342 
343   /**
344    * @dev Constructor, takes crowdsale opening and closing times.
345    * @param _openingTime Crowdsale opening time
346    * @param _closingTime Crowdsale closing time
347    */
348   constructor(uint256 _openingTime, uint256 _closingTime) public {
349     // solium-disable-next-line security/no-block-members
350     require(_openingTime >= block.timestamp);
351     require(_closingTime >= _openingTime);
352 
353     openingTime = _openingTime;
354     closingTime = _closingTime;
355   }
356 
357   /**
358    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
359    * @return Whether crowdsale period has elapsed
360    */
361   function hasClosed() public view returns (bool) {
362     // solium-disable-next-line security/no-block-members
363     return block.timestamp > closingTime;
364   }
365 
366   /**
367    * @dev Extend parent behavior requiring to be within contributing period
368    * @param _beneficiary Token purchaser
369    * @param _weiAmount Amount of wei contributed
370    */
371   function _preValidatePurchase(
372     address _beneficiary,
373     uint256 _weiAmount
374   )
375     internal
376     onlyWhileOpen
377   {
378     super._preValidatePurchase(_beneficiary, _weiAmount);
379   }
380 
381 }
382 
383 library SafeMath {
384 
385   /**
386   * @dev Multiplies two numbers, throws on overflow.
387   */
388   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
389     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
390     // benefit is lost if 'b' is also tested.
391     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
392     if (_a == 0) {
393       return 0;
394     }
395 
396     c = _a * _b;
397     assert(c / _a == _b);
398     return c;
399   }
400 
401   /**
402   * @dev Integer division of two numbers, truncating the quotient.
403   */
404   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
405     // assert(_b > 0); // Solidity automatically throws when dividing by 0
406     // uint256 c = _a / _b;
407     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
408     return _a / _b;
409   }
410 
411   /**
412   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
413   */
414   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
415     assert(_b <= _a);
416     return _a - _b;
417   }
418 
419   /**
420   * @dev Adds two numbers, throws on overflow.
421   */
422   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
423     c = _a + _b;
424     assert(c >= _a);
425     return c;
426   }
427 }
428 
429 contract Ownable {
430   address public owner;
431 
432 
433   event OwnershipRenounced(address indexed previousOwner);
434   event OwnershipTransferred(
435     address indexed previousOwner,
436     address indexed newOwner
437   );
438 
439 
440   /**
441    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
442    * account.
443    */
444   constructor() public {
445     owner = msg.sender;
446   }
447 
448   /**
449    * @dev Throws if called by any account other than the owner.
450    */
451   modifier onlyOwner() {
452     require(msg.sender == owner);
453     _;
454   }
455 
456   /**
457    * @dev Allows the current owner to relinquish control of the contract.
458    * @notice Renouncing to ownership will leave the contract without an owner.
459    * It will not be possible to call the functions with the `onlyOwner`
460    * modifier anymore.
461    */
462   function renounceOwnership() public onlyOwner {
463     emit OwnershipRenounced(owner);
464     owner = address(0);
465   }
466 
467   /**
468    * @dev Allows the current owner to transfer control of the contract to a newOwner.
469    * @param _newOwner The address to transfer ownership to.
470    */
471   function transferOwnership(address _newOwner) public onlyOwner {
472     _transferOwnership(_newOwner);
473   }
474 
475   /**
476    * @dev Transfers control of the contract to a newOwner.
477    * @param _newOwner The address to transfer ownership to.
478    */
479   function _transferOwnership(address _newOwner) internal {
480     require(_newOwner != address(0));
481     emit OwnershipTransferred(owner, _newOwner);
482     owner = _newOwner;
483   }
484 }
485 
486 contract Whitelist is Ownable, RBAC {
487   string public constant ROLE_WHITELISTED = "whitelist";
488 
489   /**
490    * @dev Throws if operator is not whitelisted.
491    * @param _operator address
492    */
493   modifier onlyIfWhitelisted(address _operator) {
494     checkRole(_operator, ROLE_WHITELISTED);
495     _;
496   }
497 
498   /**
499    * @dev add an address to the whitelist
500    * @param _operator address
501    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
502    */
503   function addAddressToWhitelist(address _operator)
504     public
505     onlyOwner
506   {
507     addRole(_operator, ROLE_WHITELISTED);
508   }
509 
510   /**
511    * @dev getter to determine if address is in whitelist
512    */
513   function whitelist(address _operator)
514     public
515     view
516     returns (bool)
517   {
518     return hasRole(_operator, ROLE_WHITELISTED);
519   }
520 
521   /**
522    * @dev add addresses to the whitelist
523    * @param _operators addresses
524    * @return true if at least one address was added to the whitelist,
525    * false if all addresses were already in the whitelist
526    */
527   function addAddressesToWhitelist(address[] _operators)
528     public
529     onlyOwner
530   {
531     for (uint256 i = 0; i < _operators.length; i++) {
532       addAddressToWhitelist(_operators[i]);
533     }
534   }
535 
536   /**
537    * @dev remove an address from the whitelist
538    * @param _operator address
539    * @return true if the address was removed from the whitelist,
540    * false if the address wasn't in the whitelist in the first place
541    */
542   function removeAddressFromWhitelist(address _operator)
543     public
544     onlyOwner
545   {
546     removeRole(_operator, ROLE_WHITELISTED);
547   }
548 
549   /**
550    * @dev remove addresses from the whitelist
551    * @param _operators addresses
552    * @return true if at least one address was removed from the whitelist,
553    * false if all addresses weren't in the whitelist in the first place
554    */
555   function removeAddressesFromWhitelist(address[] _operators)
556     public
557     onlyOwner
558   {
559     for (uint256 i = 0; i < _operators.length; i++) {
560       removeAddressFromWhitelist(_operators[i]);
561     }
562   }
563 
564 }
565 
566 contract Pausable is Ownable {
567   event Pause();
568   event Unpause();
569 
570   bool public paused = false;
571 
572 
573   /**
574    * @dev Modifier to make a function callable only when the contract is not paused.
575    */
576   modifier whenNotPaused() {
577     require(!paused);
578     _;
579   }
580 
581   /**
582    * @dev Modifier to make a function callable only when the contract is paused.
583    */
584   modifier whenPaused() {
585     require(paused);
586     _;
587   }
588 
589   /**
590    * @dev called by the owner to pause, triggers stopped state
591    */
592   function pause() public onlyOwner whenNotPaused {
593     paused = true;
594     emit Pause();
595   }
596 
597   /**
598    * @dev called by the owner to unpause, returns to normal state
599    */
600   function unpause() public onlyOwner whenPaused {
601     paused = false;
602     emit Unpause();
603   }
604 }
605 
606 contract TokenDestructible is Ownable {
607 
608   constructor() public payable { }
609 
610   /**
611    * @notice Terminate contract and refund to owner
612    * @param _tokens List of addresses of ERC20 or ERC20Basic token contracts to
613    refund.
614    * @notice The called token contracts could try to re-enter this contract. Only
615    supply token contracts you trust.
616    */
617   function destroy(address[] _tokens) public onlyOwner {
618 
619     // Transfer tokens to owner
620     for (uint256 i = 0; i < _tokens.length; i++) {
621       ERC20Basic token = ERC20Basic(_tokens[i]);
622       uint256 balance = token.balanceOf(this);
623       token.transfer(owner, balance);
624     }
625 
626     // Transfer Eth to owner and terminate contract
627     selfdestruct(owner);
628   }
629 }
630 
631 contract VictorTokenSale is TimedCrowdsale, Ownable, Whitelist, TokenDestructible {
632 
633   using SafeMath for uint256;
634 
635 
636 
637   // stage bonus
638 
639   uint256 public constant STAGE_1_BONUS_RT = 35;
640 
641   uint256 public constant STAGE_2_BONUS_RT = 30;
642 
643   uint256 public constant STAGE_3_BONUS_RT = 25;
644 
645   uint256 public constant STAGE_4_BONUS_RT = 20;
646 
647   uint256 public constant STAGE_5_BONUS_RT = 15;
648 
649   uint256 public constant STAGE_6_BONUS_RT = 10;
650 
651   uint256 public constant STAGE_7_BONUS_RT =  5;
652 
653 
654 
655   // BOUNDARY ethereum conv:  22000 / 44000 / 66000 / 88000 / 110000 / 132000 / 154000
656 
657   // This is wei * 25000 limit.
658 
659   uint256 public constant BOUNDARY_1 =  550000000000000000000000000;
660 
661   uint256 public constant BOUNDARY_2 = 1100000000000000000000000000;
662 
663   uint256 public constant BOUNDARY_3 = 1650000000000000000000000000;
664 
665   uint256 public constant BOUNDARY_4 = 2200000000000000000000000000;
666 
667   uint256 public constant BOUNDARY_5 = 2750000000000000000000000000;
668 
669   uint256 public constant BOUNDARY_6 = 3300000000000000000000000000;
670 
671   uint256 public constant BOUNDARY_7 = 3850000000000000000000000000; // End of Sales amount
672 
673 
674 
675   VictorToken _token;
676 
677 
678 
679   uint256 public bonusRate;
680 
681   uint256 public calcAdditionalRatio;
682 
683   uint256 public cumulativeSumofToken = 0;
684 
685 
686 
687   uint256 public minimum_buy_limit = 0.1 ether;
688 
689   uint256 public maximum_buy_limit = 1000 ether;
690 
691 
692 
693   event SetPeriod(uint256 _openingTime, uint256 _closingTime);
694 
695   event SetBuyLimit(uint256 _minLimit, uint256 _maxLimit);
696 
697 
698 
699   // ----------------------------------------------------------------------------------- 
700 
701   // Constructor
702 
703   // ----------------------------------------------------------------------------------- 
704 
705   // Fixed exchange ratio: 25000 (FIXED!)
706 
707   // Fixed period of sale: 16 weeks from now set as sales period (changeable)
708 
709   constructor(
710 
711     VictorToken _token_,
712 
713     address _wallet
714 
715   )
716 
717     public
718 
719     Crowdsale(25000, _wallet, _token_)
720 
721     TimedCrowdsale(block.timestamp, block.timestamp + 16 weeks)
722 
723   {
724 
725     _token = _token_;
726 
727 
728 
729     emit SetPeriod(openingTime, closingTime);
730 
731 
732 
733     calcBonusRate();
734 
735   }
736 
737 
738 
739   // -----------------------------------------------------------------------------------
740 
741   // override fuction.
742 
743   // -----------------------------------------------------------------------------------
744 
745   function _preValidatePurchase(
746 
747     address _beneficiary,
748 
749     uint256 _weiAmount
750 
751   )
752 
753     onlyWhileOpen
754 
755     onlyIfWhitelisted(_beneficiary)
756 
757     internal
758 
759   {
760 
761     require(_beneficiary != address(0));
762 
763     require(_weiAmount >= minimum_buy_limit);
764 
765     require(_weiAmount <= maximum_buy_limit);
766 
767     require(BOUNDARY_7 >= (cumulativeSumofToken + _weiAmount));
768 
769   }
770 
771 
772 
773   // override fuction. default + bonus token
774 
775   function _getTokenAmount(
776 
777     uint256 _weiAmount
778 
779   )
780 
781     internal
782 
783     view
784 
785     returns (uint256)
786 
787   {
788 
789     return (_weiAmount.mul(rate)).add(_weiAmount.mul(calcAdditionalRatio)) ;
790 
791   }
792 
793 
794 
795   // override fuction.
796 
797   // bonus token locking
798 
799   // stage bonus boundary check and change.
800 
801   function _updatePurchasingState(
802 
803     address _beneficiary,
804 
805     uint256 _weiAmount
806 
807   )
808 
809     internal
810 
811   {
812 
813     uint256 lockBalance = _weiAmount.mul(calcAdditionalRatio);
814 
815 
816 
817     _token.increaseLockBalance(_beneficiary, lockBalance);
818 
819     
820 
821     cumulativeSumofToken = cumulativeSumofToken.add(_weiAmount.mul(rate));
822 
823 
824 
825     calcBonusRate();
826 
827 
828 
829     return;
830 
831   }
832 
833 
834 
835   // -----------------------------------------------------------------------------------
836 
837   // Utility function
838 
839   // -----------------------------------------------------------------------------------
840 
841   // Bonus rate calcuration.
842 
843   function calcBonusRate()
844 
845     public
846 
847   {
848 
849     if      (cumulativeSumofToken >=          0 && cumulativeSumofToken < BOUNDARY_1 && bonusRate != STAGE_1_BONUS_RT)
850 
851     {
852 
853       bonusRate = STAGE_1_BONUS_RT;
854 
855       calcAdditionalRatio = (rate.mul(bonusRate)).div(100);
856 
857     }
858 
859     else if (cumulativeSumofToken >= BOUNDARY_1 && cumulativeSumofToken < BOUNDARY_2 && bonusRate != STAGE_2_BONUS_RT)
860 
861     {
862 
863       bonusRate = STAGE_2_BONUS_RT;
864 
865       calcAdditionalRatio = (rate.mul(bonusRate)).div(100);
866 
867     }
868 
869     else if (cumulativeSumofToken >= BOUNDARY_2 && cumulativeSumofToken < BOUNDARY_3 && bonusRate != STAGE_3_BONUS_RT)
870 
871     {
872 
873       bonusRate = STAGE_3_BONUS_RT;
874 
875       calcAdditionalRatio = (rate.mul(bonusRate)).div(100);
876 
877     }
878 
879     else if (cumulativeSumofToken >= BOUNDARY_3 && cumulativeSumofToken < BOUNDARY_4 && bonusRate != STAGE_4_BONUS_RT)
880 
881     {
882 
883       bonusRate = STAGE_4_BONUS_RT;
884 
885       calcAdditionalRatio = (rate.mul(bonusRate)).div(100);
886 
887     }
888 
889     else if (cumulativeSumofToken >= BOUNDARY_4 && cumulativeSumofToken < BOUNDARY_5 && bonusRate != STAGE_5_BONUS_RT)
890 
891     {
892 
893       bonusRate = STAGE_5_BONUS_RT;
894 
895       calcAdditionalRatio = (rate.mul(bonusRate)).div(100);
896 
897     }
898 
899     else if (cumulativeSumofToken >= BOUNDARY_5 && cumulativeSumofToken < BOUNDARY_6 && bonusRate != STAGE_6_BONUS_RT)
900 
901     {
902 
903       bonusRate = STAGE_6_BONUS_RT;
904 
905       calcAdditionalRatio = (rate.mul(bonusRate)).div(100);
906 
907     }
908 
909     else if (cumulativeSumofToken >= BOUNDARY_6 && cumulativeSumofToken < BOUNDARY_7 && bonusRate != STAGE_7_BONUS_RT)
910 
911     {
912 
913       bonusRate = STAGE_7_BONUS_RT;
914 
915       calcAdditionalRatio = (rate.mul(bonusRate)).div(100);
916 
917     }
918 
919     else if (cumulativeSumofToken >= BOUNDARY_7)
920 
921     {
922 
923       bonusRate = 0;
924 
925       calcAdditionalRatio = (rate.mul(bonusRate)).div(100);
926 
927     }
928 
929     
930 
931     return;
932 
933   }
934 
935 
936 
937   // Change open, close time and bonus rate. _openingTime, _closingTime is epoch (like 1532919600)
938 
939   function changePeriod(
940 
941     uint256 _openingTime,
942 
943     uint256 _closingTime
944 
945   )
946 
947     onlyOwner
948 
949     external
950 
951     returns (bool)
952 
953   {
954 
955     require(_openingTime >= block.timestamp);
956 
957     require(_closingTime >= _openingTime);
958 
959 
960 
961     openingTime = _openingTime;
962 
963     closingTime = _closingTime;
964 
965 
966 
967     calcAdditionalRatio = (rate.mul(bonusRate)).div(100);
968 
969 
970 
971     emit SetPeriod(openingTime, closingTime);
972 
973 
974 
975     return true;
976 
977   }
978 
979 
980 
981   // Buyer limit change
982 
983   function changeLimit(
984 
985     uint256 _minLimit,
986 
987     uint256 _maxLimit
988 
989   )
990 
991     onlyOwner
992 
993     external
994 
995     returns (bool)
996 
997   {
998 
999     require(_minLimit >= 0 ether);
1000 
1001     require(_maxLimit >= 3 ether);
1002 
1003 
1004 
1005     minimum_buy_limit = _minLimit;
1006 
1007     maximum_buy_limit = _maxLimit;
1008 
1009 
1010 
1011     emit SetBuyLimit(minimum_buy_limit, maximum_buy_limit);
1012 
1013 
1014 
1015     return true;
1016 
1017   }
1018 
1019 
1020 
1021   // bonus drop. Bonus tokens take a lock.
1022 
1023   function bonusDrop(
1024 
1025     address _beneficiary,
1026 
1027     uint256 _tokenAmount
1028 
1029   )
1030 
1031     onlyOwner
1032 
1033     external
1034 
1035     returns (bool)
1036 
1037   {
1038 
1039     _processPurchase(_beneficiary, _tokenAmount);
1040 
1041 
1042 
1043     emit TokenPurchase(
1044 
1045       msg.sender,
1046 
1047       _beneficiary,
1048 
1049       0,
1050 
1051       _tokenAmount
1052 
1053     );
1054 
1055 
1056 
1057     _token.increaseLockBalance(_beneficiary, _tokenAmount);
1058 
1059 
1060 
1061     return true;
1062 
1063   }
1064 
1065 
1066 
1067   // bonus drop. Bonus tokens are not locked !!!
1068 
1069   function unlockBonusDrop(
1070 
1071     address _beneficiary,
1072 
1073     uint256 _tokenAmount
1074 
1075   )
1076 
1077     onlyOwner
1078 
1079     external
1080 
1081     returns (bool)
1082 
1083   {
1084 
1085     _processPurchase(_beneficiary, _tokenAmount);
1086 
1087 
1088 
1089     emit TokenPurchase(
1090 
1091       msg.sender,
1092 
1093       _beneficiary,
1094 
1095       0,
1096 
1097       _tokenAmount
1098 
1099     );
1100 
1101 
1102 
1103     return true;
1104 
1105   }
1106 
1107 
1108 
1109   // -----------------------------------------------------------------------------------
1110 
1111   // Token Interface
1112 
1113   // -----------------------------------------------------------------------------------
1114 
1115   // Increases the lock on the balance at a specific address.
1116 
1117   function increaseTokenLock(
1118 
1119     address _beneficiary,
1120 
1121     uint256 _tokenAmount
1122 
1123   )
1124 
1125     onlyOwner
1126 
1127     external
1128 
1129     returns (bool)
1130 
1131   {
1132 
1133     return(_token.increaseLockBalance(_beneficiary, _tokenAmount));
1134 
1135   }
1136 
1137 
1138 
1139   // Decreases the lock on the balance at a specific address.
1140 
1141   function decreaseTokenLock(
1142 
1143     address _beneficiary,
1144 
1145     uint256 _tokenAmount
1146 
1147   )
1148 
1149     onlyOwner
1150 
1151     external
1152 
1153     returns (bool)
1154 
1155   {
1156 
1157     return(_token.decreaseLockBalance(_beneficiary, _tokenAmount));
1158 
1159   }
1160 
1161 
1162 
1163   // It completely unlocks a specific address.
1164 
1165   function clearTokenLock(
1166 
1167     address _beneficiary
1168 
1169   )
1170 
1171     onlyOwner
1172 
1173     external
1174 
1175     returns (bool)
1176 
1177   {
1178 
1179     return(_token.clearLock(_beneficiary));
1180 
1181   }
1182 
1183 
1184 
1185   // Redefine the point at which a lock that affects the whole is released.
1186 
1187   function resetLockReleaseTime(
1188 
1189     address _beneficiary,
1190 
1191     uint256 _releaseTime
1192 
1193   )
1194 
1195     onlyOwner
1196 
1197     external
1198 
1199     returns (bool)
1200 
1201   {
1202 
1203     return(_token.setReleaseTime(_beneficiary, _releaseTime));
1204 
1205   }
1206 
1207 
1208 
1209   // Attention of administrator is required!! Migrate the owner of the token.
1210 
1211   function transferTokenOwnership(
1212 
1213     address _newOwner
1214 
1215   )
1216 
1217     onlyOwner
1218 
1219     external
1220 
1221     returns (bool)
1222 
1223   {
1224 
1225     _token.transferOwnership(_newOwner);
1226 
1227     return true;
1228 
1229   }
1230 
1231 
1232 
1233   // Stops the entire transaction of the token completely.
1234 
1235   function pauseToken()
1236 
1237     onlyOwner
1238 
1239     external
1240 
1241     returns (bool)
1242 
1243   {
1244 
1245     _token.pause();
1246 
1247     return true;
1248 
1249   }
1250 
1251 
1252 
1253   // Resume a suspended transaction.
1254 
1255   function unpauseToken()
1256 
1257     onlyOwner
1258 
1259     external
1260 
1261     returns (bool)
1262 
1263   {
1264 
1265     _token.unpause();
1266 
1267     return true;
1268 
1269   }
1270 
1271 }
1272 
1273 contract ERC20Basic {
1274   function totalSupply() public view returns (uint256);
1275   function balanceOf(address _who) public view returns (uint256);
1276   function transfer(address _to, uint256 _value) public returns (bool);
1277   event Transfer(address indexed from, address indexed to, uint256 value);
1278 }
1279 
1280 contract BasicToken is ERC20Basic {
1281   using SafeMath for uint256;
1282 
1283   mapping(address => uint256) internal balances;
1284 
1285   uint256 internal totalSupply_;
1286 
1287   /**
1288   * @dev Total number of tokens in existence
1289   */
1290   function totalSupply() public view returns (uint256) {
1291     return totalSupply_;
1292   }
1293 
1294   /**
1295   * @dev Transfer token for a specified address
1296   * @param _to The address to transfer to.
1297   * @param _value The amount to be transferred.
1298   */
1299   function transfer(address _to, uint256 _value) public returns (bool) {
1300     require(_value <= balances[msg.sender]);
1301     require(_to != address(0));
1302 
1303     balances[msg.sender] = balances[msg.sender].sub(_value);
1304     balances[_to] = balances[_to].add(_value);
1305     emit Transfer(msg.sender, _to, _value);
1306     return true;
1307   }
1308 
1309   /**
1310   * @dev Gets the balance of the specified address.
1311   * @param _owner The address to query the the balance of.
1312   * @return An uint256 representing the amount owned by the passed address.
1313   */
1314   function balanceOf(address _owner) public view returns (uint256) {
1315     return balances[_owner];
1316   }
1317 
1318 }
1319 
1320 contract ERC20 is ERC20Basic {
1321   function allowance(address _owner, address _spender)
1322     public view returns (uint256);
1323 
1324   function transferFrom(address _from, address _to, uint256 _value)
1325     public returns (bool);
1326 
1327   function approve(address _spender, uint256 _value) public returns (bool);
1328   event Approval(
1329     address indexed owner,
1330     address indexed spender,
1331     uint256 value
1332   );
1333 }
1334 
1335 library SafeERC20 {
1336   function safeTransfer(
1337     ERC20Basic _token,
1338     address _to,
1339     uint256 _value
1340   )
1341     internal
1342   {
1343     require(_token.transfer(_to, _value));
1344   }
1345 
1346   function safeTransferFrom(
1347     ERC20 _token,
1348     address _from,
1349     address _to,
1350     uint256 _value
1351   )
1352     internal
1353   {
1354     require(_token.transferFrom(_from, _to, _value));
1355   }
1356 
1357   function safeApprove(
1358     ERC20 _token,
1359     address _spender,
1360     uint256 _value
1361   )
1362     internal
1363   {
1364     require(_token.approve(_spender, _value));
1365   }
1366 }
1367 
1368 contract StandardToken is ERC20, BasicToken {
1369 
1370   mapping (address => mapping (address => uint256)) internal allowed;
1371 
1372 
1373   /**
1374    * @dev Transfer tokens from one address to another
1375    * @param _from address The address which you want to send tokens from
1376    * @param _to address The address which you want to transfer to
1377    * @param _value uint256 the amount of tokens to be transferred
1378    */
1379   function transferFrom(
1380     address _from,
1381     address _to,
1382     uint256 _value
1383   )
1384     public
1385     returns (bool)
1386   {
1387     require(_value <= balances[_from]);
1388     require(_value <= allowed[_from][msg.sender]);
1389     require(_to != address(0));
1390 
1391     balances[_from] = balances[_from].sub(_value);
1392     balances[_to] = balances[_to].add(_value);
1393     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1394     emit Transfer(_from, _to, _value);
1395     return true;
1396   }
1397 
1398   /**
1399    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1400    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1401    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1402    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1403    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1404    * @param _spender The address which will spend the funds.
1405    * @param _value The amount of tokens to be spent.
1406    */
1407   function approve(address _spender, uint256 _value) public returns (bool) {
1408     allowed[msg.sender][_spender] = _value;
1409     emit Approval(msg.sender, _spender, _value);
1410     return true;
1411   }
1412 
1413   /**
1414    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1415    * @param _owner address The address which owns the funds.
1416    * @param _spender address The address which will spend the funds.
1417    * @return A uint256 specifying the amount of tokens still available for the spender.
1418    */
1419   function allowance(
1420     address _owner,
1421     address _spender
1422    )
1423     public
1424     view
1425     returns (uint256)
1426   {
1427     return allowed[_owner][_spender];
1428   }
1429 
1430   /**
1431    * @dev Increase the amount of tokens that an owner allowed to a spender.
1432    * approve should be called when allowed[_spender] == 0. To increment
1433    * allowed value is better to use this function to avoid 2 calls (and wait until
1434    * the first transaction is mined)
1435    * From MonolithDAO Token.sol
1436    * @param _spender The address which will spend the funds.
1437    * @param _addedValue The amount of tokens to increase the allowance by.
1438    */
1439   function increaseApproval(
1440     address _spender,
1441     uint256 _addedValue
1442   )
1443     public
1444     returns (bool)
1445   {
1446     allowed[msg.sender][_spender] = (
1447       allowed[msg.sender][_spender].add(_addedValue));
1448     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1449     return true;
1450   }
1451 
1452   /**
1453    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1454    * approve should be called when allowed[_spender] == 0. To decrement
1455    * allowed value is better to use this function to avoid 2 calls (and wait until
1456    * the first transaction is mined)
1457    * From MonolithDAO Token.sol
1458    * @param _spender The address which will spend the funds.
1459    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1460    */
1461   function decreaseApproval(
1462     address _spender,
1463     uint256 _subtractedValue
1464   )
1465     public
1466     returns (bool)
1467   {
1468     uint256 oldValue = allowed[msg.sender][_spender];
1469     if (_subtractedValue >= oldValue) {
1470       allowed[msg.sender][_spender] = 0;
1471     } else {
1472       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1473     }
1474     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1475     return true;
1476   }
1477 
1478 }
1479 
1480 contract PausableToken is StandardToken, Pausable {
1481 
1482   function transfer(
1483     address _to,
1484     uint256 _value
1485   )
1486     public
1487     whenNotPaused
1488     returns (bool)
1489   {
1490     return super.transfer(_to, _value);
1491   }
1492 
1493   function transferFrom(
1494     address _from,
1495     address _to,
1496     uint256 _value
1497   )
1498     public
1499     whenNotPaused
1500     returns (bool)
1501   {
1502     return super.transferFrom(_from, _to, _value);
1503   }
1504 
1505   function approve(
1506     address _spender,
1507     uint256 _value
1508   )
1509     public
1510     whenNotPaused
1511     returns (bool)
1512   {
1513     return super.approve(_spender, _value);
1514   }
1515 
1516   function increaseApproval(
1517     address _spender,
1518     uint _addedValue
1519   )
1520     public
1521     whenNotPaused
1522     returns (bool success)
1523   {
1524     return super.increaseApproval(_spender, _addedValue);
1525   }
1526 
1527   function decreaseApproval(
1528     address _spender,
1529     uint _subtractedValue
1530   )
1531     public
1532     whenNotPaused
1533     returns (bool success)
1534   {
1535     return super.decreaseApproval(_spender, _subtractedValue);
1536   }
1537 }
1538 
1539 contract IndividualLockableToken is PausableToken{
1540 
1541   using SafeMath for uint256;
1542 
1543 
1544 
1545   event LockTimeSetted(address indexed holder, uint256 old_release_time, uint256 new_release_time);
1546 
1547   event Locked(address indexed holder, uint256 locked_balance_change, uint256 total_locked_balance, uint256 release_time);
1548 
1549 
1550 
1551   struct lockState {
1552 
1553     uint256 locked_balance;
1554 
1555     uint256 release_time;
1556 
1557   }
1558 
1559 
1560 
1561   // default lock period
1562 
1563   uint256 public lock_period = 24 weeks;
1564 
1565 
1566 
1567   mapping(address => lockState) internal userLock;
1568 
1569 
1570 
1571   // Specify the time that a particular person's lock will be released
1572 
1573   function setReleaseTime(address _holder, uint256 _release_time)
1574 
1575     public
1576 
1577     onlyOwner
1578 
1579     returns (bool)
1580 
1581   {
1582 
1583     require(_holder != address(0));
1584 
1585 	require(_release_time >= block.timestamp);
1586 
1587 
1588 
1589 	uint256 old_release_time = userLock[_holder].release_time;
1590 
1591 
1592 
1593 	userLock[_holder].release_time = _release_time;
1594 
1595 	emit LockTimeSetted(_holder, old_release_time, userLock[_holder].release_time);
1596 
1597 	return true;
1598 
1599   }
1600 
1601   
1602 
1603   // Returns the point at which token holder's lock is released
1604 
1605   function getReleaseTime(address _holder)
1606 
1607     public
1608 
1609     view
1610 
1611     returns (uint256)
1612 
1613   {
1614 
1615     require(_holder != address(0));
1616 
1617 
1618 
1619 	return userLock[_holder].release_time;
1620 
1621   }
1622 
1623 
1624 
1625   // Unlock a specific person. Free trading even with a lock balance
1626 
1627   function clearReleaseTime(address _holder)
1628 
1629     public
1630 
1631     onlyOwner
1632 
1633     returns (bool)
1634 
1635   {
1636 
1637     require(_holder != address(0));
1638 
1639     require(userLock[_holder].release_time > 0);
1640 
1641 
1642 
1643 	uint256 old_release_time = userLock[_holder].release_time;
1644 
1645 
1646 
1647 	userLock[_holder].release_time = 0;
1648 
1649 	emit LockTimeSetted(_holder, old_release_time, userLock[_holder].release_time);
1650 
1651 	return true;
1652 
1653   }
1654 
1655 
1656 
1657   // Increase the lock balance of a specific person.
1658 
1659   // If you only want to increase the balance, the release_time must be specified in advance.
1660 
1661   function increaseLockBalance(address _holder, uint256 _value)
1662 
1663     public
1664 
1665     onlyOwner
1666 
1667     returns (bool)
1668 
1669   {
1670 
1671 	require(_holder != address(0));
1672 
1673 	require(_value > 0);
1674 
1675 	require(balances[_holder] >= _value);
1676 
1677 	
1678 
1679 	if (userLock[_holder].release_time == 0) {
1680 
1681 		userLock[_holder].release_time = block.timestamp + lock_period;
1682 
1683 	}
1684 
1685 	
1686 
1687 	userLock[_holder].locked_balance = (userLock[_holder].locked_balance).add(_value);
1688 
1689 	emit Locked(_holder, _value, userLock[_holder].locked_balance, userLock[_holder].release_time);
1690 
1691 	return true;
1692 
1693   }
1694 
1695 
1696 
1697   // Decrease the lock balance of a specific person.
1698 
1699   function decreaseLockBalance(address _holder, uint256 _value)
1700 
1701     public
1702 
1703     onlyOwner
1704 
1705     returns (bool)
1706 
1707   {
1708 
1709 	require(_holder != address(0));
1710 
1711 	require(_value > 0);
1712 
1713 	require(userLock[_holder].locked_balance >= _value);
1714 
1715 
1716 
1717 	userLock[_holder].locked_balance = (userLock[_holder].locked_balance).sub(_value);
1718 
1719 	emit Locked(_holder, _value, userLock[_holder].locked_balance, userLock[_holder].release_time);
1720 
1721 	return true;
1722 
1723   }
1724 
1725 
1726 
1727   // Clear the lock.
1728 
1729   function clearLock(address _holder)
1730 
1731     public
1732 
1733     onlyOwner
1734 
1735     returns (bool)
1736 
1737   {
1738 
1739 	require(_holder != address(0));
1740 
1741 	require(userLock[_holder].release_time > 0);
1742 
1743 
1744 
1745 	userLock[_holder].locked_balance = 0;
1746 
1747 	userLock[_holder].release_time = 0;
1748 
1749 	emit Locked(_holder, 0, userLock[_holder].locked_balance, userLock[_holder].release_time);
1750 
1751 	return true;
1752 
1753   }
1754 
1755 
1756 
1757   // Check the amount of the lock
1758 
1759   function getLockedBalance(address _holder)
1760 
1761     public
1762 
1763     view
1764 
1765     returns (uint256)
1766 
1767   {
1768 
1769     if(block.timestamp >= userLock[_holder].release_time) return uint256(0);
1770 
1771     return userLock[_holder].locked_balance;
1772 
1773   }
1774 
1775 
1776 
1777   // Check your remaining balance
1778 
1779   function getFreeBalance(address _holder)
1780 
1781     public
1782 
1783     view
1784 
1785     returns (uint256)
1786 
1787   {
1788 
1789     if(block.timestamp >= userLock[_holder].release_time) return balances[_holder];
1790 
1791     return balances[_holder].sub(userLock[_holder].locked_balance);
1792 
1793   }
1794 
1795 
1796 
1797   // transfer overrride
1798 
1799   function transfer(
1800 
1801     address _to,
1802 
1803     uint256 _value
1804 
1805   )
1806 
1807     public
1808 
1809     returns (bool)
1810 
1811   {
1812 
1813     require(getFreeBalance(msg.sender) >= _value);
1814 
1815     return super.transfer(_to, _value);
1816 
1817   }
1818 
1819 
1820 
1821   // transferFrom overrride
1822 
1823   function transferFrom(
1824 
1825     address _from,
1826 
1827     address _to,
1828 
1829     uint256 _value
1830 
1831   )
1832 
1833     public
1834 
1835     returns (bool)
1836 
1837   {
1838 
1839     require(getFreeBalance(_from) >= _value);
1840 
1841     return super.transferFrom(_from, _to, _value);
1842 
1843   }
1844 
1845 
1846 
1847   // approve overrride
1848 
1849   function approve(
1850 
1851     address _spender,
1852 
1853     uint256 _value
1854 
1855   )
1856 
1857     public
1858 
1859     returns (bool)
1860 
1861   {
1862 
1863     require(getFreeBalance(msg.sender) >= _value);
1864 
1865     return super.approve(_spender, _value);
1866 
1867   }
1868 
1869 
1870 
1871   // increaseApproval overrride
1872 
1873   function increaseApproval(
1874 
1875     address _spender,
1876 
1877     uint _addedValue
1878 
1879   )
1880 
1881     public
1882 
1883     returns (bool success)
1884 
1885   {
1886 
1887     require(getFreeBalance(msg.sender) >= allowed[msg.sender][_spender].add(_addedValue));
1888 
1889     return super.increaseApproval(_spender, _addedValue);
1890 
1891   }
1892 
1893   
1894 
1895   // decreaseApproval overrride
1896 
1897   function decreaseApproval(
1898 
1899     address _spender,
1900 
1901     uint _subtractedValue
1902 
1903   )
1904 
1905     public
1906 
1907     returns (bool success)
1908 
1909   {
1910 
1911 	uint256 oldValue = allowed[msg.sender][_spender];
1912 
1913 	
1914 
1915     if (_subtractedValue < oldValue) {
1916 
1917       require(getFreeBalance(msg.sender) >= oldValue.sub(_subtractedValue));	  
1918 
1919     }    
1920 
1921     return super.decreaseApproval(_spender, _subtractedValue);
1922 
1923   }
1924 
1925 }
1926 
1927 contract VictorToken is IndividualLockableToken, TokenDestructible {
1928 
1929   using SafeMath for uint256;
1930 
1931 
1932 
1933   string public constant name = "VictorToken";
1934 
1935   string public constant symbol = "VIC";
1936 
1937   uint8  public constant decimals = 18;
1938 
1939 
1940 
1941   // 10,000,000,000 10 billion
1942 
1943   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
1944 
1945 
1946 
1947   constructor()
1948 
1949     public
1950 
1951   {
1952 
1953     totalSupply_ = INITIAL_SUPPLY;
1954 
1955     balances[msg.sender] = totalSupply_;
1956 
1957   }
1958 
1959 }