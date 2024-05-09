1 pragma solidity ^0.4.19;
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
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender)
77     public view returns (uint256);
78 
79   function transferFrom(address from, address to, uint256 value)
80     public returns (bool);
81 
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
91 
92 /**
93  * @title SafeERC20
94  * @dev Wrappers around ERC20 operations that throw on failure.
95  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
96  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
97  */
98 library SafeERC20 {
99   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
100     require(token.transfer(to, value));
101   }
102 
103   function safeTransferFrom(
104     ERC20 token,
105     address from,
106     address to,
107     uint256 value
108   )
109     internal
110   {
111     require(token.transferFrom(from, to, value));
112   }
113 
114   function safeApprove(ERC20 token, address spender, uint256 value) internal {
115     require(token.approve(spender, value));
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
120 
121 /**
122  * @title Crowdsale
123  * @dev Crowdsale is a base contract for managing a token crowdsale,
124  * allowing investors to purchase tokens with ether. This contract implements
125  * such functionality in its most fundamental form and can be extended to provide additional
126  * functionality and/or custom behavior.
127  * The external interface represents the basic interface for purchasing tokens, and conform
128  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
129  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
130  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
131  * behavior.
132  */
133 contract Crowdsale {
134   using SafeMath for uint256;
135   using SafeERC20 for ERC20;
136 
137   // The token being sold
138   ERC20 public token;
139 
140   // Address where funds are collected
141   address public wallet;
142 
143   // How many token units a buyer gets per wei.
144   // The rate is the conversion between wei and the smallest and indivisible token unit.
145   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
146   // 1 wei will give you 1 unit, or 0.001 TOK.
147   uint256 public rate;
148 
149   // Amount of wei raised
150   uint256 public weiRaised;
151 
152   /**
153    * Event for token purchase logging
154    * @param purchaser who paid for the tokens
155    * @param beneficiary who got the tokens
156    * @param value weis paid for purchase
157    * @param amount amount of tokens purchased
158    */
159   event TokenPurchase(
160     address indexed purchaser,
161     address indexed beneficiary,
162     uint256 value,
163     uint256 amount
164   );
165 
166   /**
167    * @param _rate Number of token units a buyer gets per wei
168    * @param _wallet Address where collected funds will be forwarded to
169    * @param _token Address of the token being sold
170    */
171   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
172     require(_rate > 0);
173     require(_wallet != address(0));
174     require(_token != address(0));
175 
176     rate = _rate;
177     wallet = _wallet;
178     token = _token;
179   }
180 
181   // -----------------------------------------
182   // Crowdsale external interface
183   // -----------------------------------------
184 
185   /**
186    * @dev fallback function ***DO NOT OVERRIDE***
187    */
188   function () external payable {
189     buyTokens(msg.sender);
190   }
191 
192   /**
193    * @dev low level token purchase ***DO NOT OVERRIDE***
194    * @param _beneficiary Address performing the token purchase
195    */
196   function buyTokens(address _beneficiary) public payable {
197 
198     uint256 weiAmount = msg.value;
199     _preValidatePurchase(_beneficiary, weiAmount);
200 
201     // calculate token amount to be created
202     uint256 tokens = _getTokenAmount(weiAmount);
203 
204     // update state
205     weiRaised = weiRaised.add(weiAmount);
206 
207     _processPurchase(_beneficiary, tokens);
208     emit TokenPurchase(
209       msg.sender,
210       _beneficiary,
211       weiAmount,
212       tokens
213     );
214 
215     _updatePurchasingState(_beneficiary, weiAmount);
216 
217     _forwardFunds();
218     _postValidatePurchase(_beneficiary, weiAmount);
219   }
220 
221   // -----------------------------------------
222   // Internal interface (extensible)
223   // -----------------------------------------
224 
225   /**
226    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
227    * @param _beneficiary Address performing the token purchase
228    * @param _weiAmount Value in wei involved in the purchase
229    */
230   function _preValidatePurchase(
231     address _beneficiary,
232     uint256 _weiAmount
233   )
234     internal
235   {
236     require(_beneficiary != address(0));
237     require(_weiAmount != 0);
238   }
239 
240   /**
241    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
242    * @param _beneficiary Address performing the token purchase
243    * @param _weiAmount Value in wei involved in the purchase
244    */
245   function _postValidatePurchase(
246     address _beneficiary,
247     uint256 _weiAmount
248   )
249     internal
250   {
251     // optional override
252   }
253 
254   /**
255    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
256    * @param _beneficiary Address performing the token purchase
257    * @param _tokenAmount Number of tokens to be emitted
258    */
259   function _deliverTokens(
260     address _beneficiary,
261     uint256 _tokenAmount
262   )
263     internal
264   {
265     token.safeTransfer(_beneficiary, _tokenAmount);
266   }
267 
268   /**
269    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
270    * @param _beneficiary Address receiving the tokens
271    * @param _tokenAmount Number of tokens to be purchased
272    */
273   function _processPurchase(
274     address _beneficiary,
275     uint256 _tokenAmount
276   )
277     internal
278   {
279     _deliverTokens(_beneficiary, _tokenAmount);
280   }
281 
282   /**
283    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
284    * @param _beneficiary Address receiving the tokens
285    * @param _weiAmount Value in wei involved in the purchase
286    */
287   function _updatePurchasingState(
288     address _beneficiary,
289     uint256 _weiAmount
290   )
291     internal
292   {
293     // optional override
294   }
295 
296   /**
297    * @dev Override to extend the way in which ether is converted to tokens.
298    * @param _weiAmount Value in wei to be converted into tokens
299    * @return Number of tokens that can be purchased with the specified _weiAmount
300    */
301   function _getTokenAmount(uint256 _weiAmount)
302     internal view returns (uint256)
303   {
304     return _weiAmount.mul(rate);
305   }
306 
307   /**
308    * @dev Determines how ETH is stored/forwarded on purchases.
309    */
310   function _forwardFunds() internal {
311     wallet.transfer(msg.value);
312   }
313 }
314 
315 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
316 
317 /**
318  * @title Ownable
319  * @dev The Ownable contract has an owner address, and provides basic authorization control
320  * functions, this simplifies the implementation of "user permissions".
321  */
322 contract Ownable {
323   address public owner;
324 
325 
326   event OwnershipRenounced(address indexed previousOwner);
327   event OwnershipTransferred(
328     address indexed previousOwner,
329     address indexed newOwner
330   );
331 
332 
333   /**
334    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
335    * account.
336    */
337   constructor() public {
338     owner = msg.sender;
339   }
340 
341   /**
342    * @dev Throws if called by any account other than the owner.
343    */
344   modifier onlyOwner() {
345     require(msg.sender == owner);
346     _;
347   }
348 
349   /**
350    * @dev Allows the current owner to relinquish control of the contract.
351    * @notice Renouncing to ownership will leave the contract without an owner.
352    * It will not be possible to call the functions with the `onlyOwner`
353    * modifier anymore.
354    */
355   function renounceOwnership() public onlyOwner {
356     emit OwnershipRenounced(owner);
357     owner = address(0);
358   }
359 
360   /**
361    * @dev Allows the current owner to transfer control of the contract to a newOwner.
362    * @param _newOwner The address to transfer ownership to.
363    */
364   function transferOwnership(address _newOwner) public onlyOwner {
365     _transferOwnership(_newOwner);
366   }
367 
368   /**
369    * @dev Transfers control of the contract to a newOwner.
370    * @param _newOwner The address to transfer ownership to.
371    */
372   function _transferOwnership(address _newOwner) internal {
373     require(_newOwner != address(0));
374     emit OwnershipTransferred(owner, _newOwner);
375     owner = _newOwner;
376   }
377 }
378 
379 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
380 
381 /**
382  * @title Roles
383  * @author Francisco Giordano (@frangio)
384  * @dev Library for managing addresses assigned to a Role.
385  * See RBAC.sol for example usage.
386  */
387 library Roles {
388   struct Role {
389     mapping (address => bool) bearer;
390   }
391 
392   /**
393    * @dev give an address access to this role
394    */
395   function add(Role storage role, address addr)
396     internal
397   {
398     role.bearer[addr] = true;
399   }
400 
401   /**
402    * @dev remove an address' access to this role
403    */
404   function remove(Role storage role, address addr)
405     internal
406   {
407     role.bearer[addr] = false;
408   }
409 
410   /**
411    * @dev check if an address has this role
412    * // reverts
413    */
414   function check(Role storage role, address addr)
415     view
416     internal
417   {
418     require(has(role, addr));
419   }
420 
421   /**
422    * @dev check if an address has this role
423    * @return bool
424    */
425   function has(Role storage role, address addr)
426     view
427     internal
428     returns (bool)
429   {
430     return role.bearer[addr];
431   }
432 }
433 
434 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
435 
436 /**
437  * @title RBAC (Role-Based Access Control)
438  * @author Matt Condon (@Shrugs)
439  * @dev Stores and provides setters and getters for roles and addresses.
440  * Supports unlimited numbers of roles and addresses.
441  * See //contracts/mocks/RBACMock.sol for an example of usage.
442  * This RBAC method uses strings to key roles. It may be beneficial
443  * for you to write your own implementation of this interface using Enums or similar.
444  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
445  * to avoid typos.
446  */
447 contract RBAC {
448   using Roles for Roles.Role;
449 
450   mapping (string => Roles.Role) private roles;
451 
452   event RoleAdded(address indexed operator, string role);
453   event RoleRemoved(address indexed operator, string role);
454 
455   /**
456    * @dev reverts if addr does not have role
457    * @param _operator address
458    * @param _role the name of the role
459    * // reverts
460    */
461   function checkRole(address _operator, string _role)
462     view
463     public
464   {
465     roles[_role].check(_operator);
466   }
467 
468   /**
469    * @dev determine if addr has role
470    * @param _operator address
471    * @param _role the name of the role
472    * @return bool
473    */
474   function hasRole(address _operator, string _role)
475     view
476     public
477     returns (bool)
478   {
479     return roles[_role].has(_operator);
480   }
481 
482   /**
483    * @dev add a role to an address
484    * @param _operator address
485    * @param _role the name of the role
486    */
487   function addRole(address _operator, string _role)
488     internal
489   {
490     roles[_role].add(_operator);
491     emit RoleAdded(_operator, _role);
492   }
493 
494   /**
495    * @dev remove a role from an address
496    * @param _operator address
497    * @param _role the name of the role
498    */
499   function removeRole(address _operator, string _role)
500     internal
501   {
502     roles[_role].remove(_operator);
503     emit RoleRemoved(_operator, _role);
504   }
505 
506   /**
507    * @dev modifier to scope access to a single role (uses msg.sender as addr)
508    * @param _role the name of the role
509    * // reverts
510    */
511   modifier onlyRole(string _role)
512   {
513     checkRole(msg.sender, _role);
514     _;
515   }
516 
517   /**
518    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
519    * @param _roles the names of the roles to scope access to
520    * // reverts
521    *
522    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
523    *  see: https://github.com/ethereum/solidity/issues/2467
524    */
525   // modifier onlyRoles(string[] _roles) {
526   //     bool hasAnyRole = false;
527   //     for (uint8 i = 0; i < _roles.length; i++) {
528   //         if (hasRole(msg.sender, _roles[i])) {
529   //             hasAnyRole = true;
530   //             break;
531   //         }
532   //     }
533 
534   //     require(hasAnyRole);
535 
536   //     _;
537   // }
538 }
539 
540 // File: openzeppelin-solidity/contracts/access/Whitelist.sol
541 
542 /**
543  * @title Whitelist
544  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
545  * This simplifies the implementation of "user permissions".
546  */
547 contract Whitelist is Ownable, RBAC {
548   string public constant ROLE_WHITELISTED = "whitelist";
549 
550   /**
551    * @dev Throws if operator is not whitelisted.
552    * @param _operator address
553    */
554   modifier onlyIfWhitelisted(address _operator) {
555     checkRole(_operator, ROLE_WHITELISTED);
556     _;
557   }
558 
559   /**
560    * @dev add an address to the whitelist
561    * @param _operator address
562    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
563    */
564   function addAddressToWhitelist(address _operator)
565     onlyOwner
566     public
567   {
568     addRole(_operator, ROLE_WHITELISTED);
569   }
570 
571   /**
572    * @dev getter to determine if address is in whitelist
573    */
574   function whitelist(address _operator)
575     public
576     view
577     returns (bool)
578   {
579     return hasRole(_operator, ROLE_WHITELISTED);
580   }
581 
582   /**
583    * @dev add addresses to the whitelist
584    * @param _operators addresses
585    * @return true if at least one address was added to the whitelist,
586    * false if all addresses were already in the whitelist
587    */
588   function addAddressesToWhitelist(address[] _operators)
589     onlyOwner
590     public
591   {
592     for (uint256 i = 0; i < _operators.length; i++) {
593       addAddressToWhitelist(_operators[i]);
594     }
595   }
596 
597   /**
598    * @dev remove an address from the whitelist
599    * @param _operator address
600    * @return true if the address was removed from the whitelist,
601    * false if the address wasn't in the whitelist in the first place
602    */
603   function removeAddressFromWhitelist(address _operator)
604     onlyOwner
605     public
606   {
607     removeRole(_operator, ROLE_WHITELISTED);
608   }
609 
610   /**
611    * @dev remove addresses from the whitelist
612    * @param _operators addresses
613    * @return true if at least one address was removed from the whitelist,
614    * false if all addresses weren't in the whitelist in the first place
615    */
616   function removeAddressesFromWhitelist(address[] _operators)
617     onlyOwner
618     public
619   {
620     for (uint256 i = 0; i < _operators.length; i++) {
621       removeAddressFromWhitelist(_operators[i]);
622     }
623   }
624 
625 }
626 
627 // File: openzeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol
628 
629 /**
630  * @title WhitelistedCrowdsale
631  * @dev Crowdsale in which only whitelisted users can contribute.
632  */
633 contract WhitelistedCrowdsale is Whitelist, Crowdsale {
634   /**
635    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
636    * @param _beneficiary Token beneficiary
637    * @param _weiAmount Amount of wei contributed
638    */
639   function _preValidatePurchase(
640     address _beneficiary,
641     uint256 _weiAmount
642   )
643     onlyIfWhitelisted(_beneficiary)
644     internal
645   {
646     super._preValidatePurchase(_beneficiary, _weiAmount);
647   }
648 
649 }
650 
651 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
652 
653 /**
654  * @title Pausable
655  * @dev Base contract which allows children to implement an emergency stop mechanism.
656  */
657 contract Pausable is Ownable {
658   event Pause();
659   event Unpause();
660 
661   bool public paused = false;
662 
663 
664   /**
665    * @dev Modifier to make a function callable only when the contract is not paused.
666    */
667   modifier whenNotPaused() {
668     require(!paused);
669     _;
670   }
671 
672   /**
673    * @dev Modifier to make a function callable only when the contract is paused.
674    */
675   modifier whenPaused() {
676     require(paused);
677     _;
678   }
679 
680   /**
681    * @dev called by the owner to pause, triggers stopped state
682    */
683   function pause() onlyOwner whenNotPaused public {
684     paused = true;
685     emit Pause();
686   }
687 
688   /**
689    * @dev called by the owner to unpause, returns to normal state
690    */
691   function unpause() onlyOwner whenPaused public {
692     paused = false;
693     emit Unpause();
694   }
695 }
696 
697 // File: contracts/WhitelistedPausableCrowdsale.sol
698 
699 contract WhitelistedPausableCrowdsale is WhitelistedCrowdsale, Pausable
700 {
701 
702     constructor() public
703     {}
704 
705     function _preValidatePurchase(
706         address _beneficiary,
707         uint256 _weiAmount
708     )
709     internal
710     whenNotPaused
711     {
712         super._preValidatePurchase(_beneficiary, _weiAmount);
713     }
714 
715 }
716 
717 // File: contracts/BonusCrowdsale.sol
718 
719 /**
720  * @dev Allows better rates for tokens, based on Ether amounts.
721  * Thresholds must be in decending order.
722  */
723 contract BonusCrowdsale is WhitelistedPausableCrowdsale
724 {
725     uint256[] public bonuses;
726     uint256[] public thresholds;
727 
728     constructor(uint256[] _thresholds, uint256[] _bonuses) public
729     {
730         setBonusThresholds(_thresholds, _bonuses);
731     }
732 
733     function setBonusThresholds(uint256[] _thresholds, uint256[] _bonuses) onlyOwner public
734     {
735         require(_thresholds.length == _bonuses.length);
736 
737         thresholds = _thresholds;
738         bonuses = _bonuses;
739     }
740 
741     function getBonusCount() view public returns(uint256)
742     {
743         return bonuses.length;
744     }
745 
746     /**
747      * @dev Overrides parent method taking into account variable rate.
748      * @param _weiAmount The value in wei to be converted into tokens
749      * @return The number of tokens _weiAmount wei will buy at present time
750      */
751     function _getTokenAmount(uint256 _weiAmount)
752     internal view returns(uint256)
753     {
754         for (uint i = 0; i < thresholds.length; i++)
755         {
756             if (_weiAmount >= thresholds[i])
757             {
758                 return _weiAmount.mul(rate.mul(100 + bonuses[i]).div(100));
759             }
760         }
761 
762         return _weiAmount.mul(rate);
763     }
764 }
765 
766 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
767 
768 /**
769  * @title CappedCrowdsale
770  * @dev Crowdsale with a limit for total contributions.
771  */
772 contract CappedCrowdsale is Crowdsale {
773   using SafeMath for uint256;
774 
775   uint256 public cap;
776 
777   /**
778    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
779    * @param _cap Max amount of wei to be contributed
780    */
781   constructor(uint256 _cap) public {
782     require(_cap > 0);
783     cap = _cap;
784   }
785 
786   /**
787    * @dev Checks whether the cap has been reached.
788    * @return Whether the cap was reached
789    */
790   function capReached() public view returns (bool) {
791     return weiRaised >= cap;
792   }
793 
794   /**
795    * @dev Extend parent behavior requiring purchase to respect the funding cap.
796    * @param _beneficiary Token purchaser
797    * @param _weiAmount Amount of wei contributed
798    */
799   function _preValidatePurchase(
800     address _beneficiary,
801     uint256 _weiAmount
802   )
803     internal
804   {
805     super._preValidatePurchase(_beneficiary, _weiAmount);
806     require(weiRaised.add(_weiAmount) <= cap);
807   }
808 
809 }
810 
811 // File: openzeppelin-solidity/contracts/lifecycle/TokenDestructible.sol
812 
813 /**
814  * @title TokenDestructible:
815  * @author Remco Bloemen <remco@2π.com>
816  * @dev Base contract that can be destroyed by owner. All funds in contract including
817  * listed tokens will be sent to the owner.
818  */
819 contract TokenDestructible is Ownable {
820 
821   constructor() public payable { }
822 
823   /**
824    * @notice Terminate contract and refund to owner
825    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
826    refund.
827    * @notice The called token contracts could try to re-enter this contract. Only
828    supply token contracts you trust.
829    */
830   function destroy(address[] tokens) onlyOwner public {
831 
832     // Transfer tokens to owner
833     for (uint256 i = 0; i < tokens.length; i++) {
834       ERC20Basic token = ERC20Basic(tokens[i]);
835       uint256 balance = token.balanceOf(this);
836       token.transfer(owner, balance);
837     }
838 
839     // Transfer Eth to owner and terminate contract
840     selfdestruct(owner);
841   }
842 }
843 
844 // File: contracts/EctoCrowdsale.sol
845 
846 //contract EctoCrowdsale is WhitelistedCrowdsale, CappedCrowdsale, BonusTokenSale, PausableTokenSale, TokenDestructible
847 
848 
849 //BonusTokenSale, TokenDestructible
850 contract EctoCrowdsale is BonusCrowdsale, CappedCrowdsale, TokenDestructible  
851  {
852 
853     constructor(uint256 _cap, uint256 _rate, address _wallet, ERC20 _token, uint256[] _thresholds, uint256[] _bonuses) public
854 
855     CappedCrowdsale(_cap)
856     BonusCrowdsale(_thresholds, _bonuses)
857     Crowdsale(_rate, _wallet, _token)
858     {
859     }
860 }
861 
862 /*
863 PausableTokenSale 				= Crowdsale, Pausable, Ownable
864 WhitelistedCrowdsale 			= Ownable, RBAC, Crowdsale
865 
866 */