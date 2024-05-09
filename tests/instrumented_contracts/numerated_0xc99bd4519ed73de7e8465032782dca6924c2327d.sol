1 /* file: openzeppelin-solidity/contracts/ownership/Ownable.sol */
2 pragma solidity ^0.4.24;
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 /* eof (openzeppelin-solidity/contracts/ownership/Ownable.sol) */
68 /* file: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol */
69 pragma solidity ^0.4.24;
70 
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * See https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   function totalSupply() public view returns (uint256);
79   function balanceOf(address _who) public view returns (uint256);
80   function transfer(address _to, uint256 _value) public returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 /* eof (openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol) */
85 /* file: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol */
86 pragma solidity ^0.4.24;
87 
88 
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address _owner, address _spender)
96     public view returns (uint256);
97 
98   function transferFrom(address _from, address _to, uint256 _value)
99     public returns (bool);
100 
101   function approve(address _spender, uint256 _value) public returns (bool);
102   event Approval(
103     address indexed owner,
104     address indexed spender,
105     uint256 value
106   );
107 }
108 
109 /* eof (openzeppelin-solidity/contracts/token/ERC20/ERC20.sol) */
110 /* file: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol */
111 pragma solidity ^0.4.24;
112 
113 
114 
115 /**
116  * @title SafeERC20
117  * @dev Wrappers around ERC20 operations that throw on failure.
118  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
119  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
120  */
121 library SafeERC20 {
122   function safeTransfer(
123     ERC20Basic _token,
124     address _to,
125     uint256 _value
126   )
127     internal
128   {
129     require(_token.transfer(_to, _value));
130   }
131 
132   function safeTransferFrom(
133     ERC20 _token,
134     address _from,
135     address _to,
136     uint256 _value
137   )
138     internal
139   {
140     require(_token.transferFrom(_from, _to, _value));
141   }
142 
143   function safeApprove(
144     ERC20 _token,
145     address _spender,
146     uint256 _value
147   )
148     internal
149   {
150     require(_token.approve(_spender, _value));
151   }
152 }
153 
154 /* eof (openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol) */
155 /* file: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol */
156 pragma solidity ^0.4.24;
157 
158 
159 
160 /**
161  * @title Contracts that should be able to recover tokens
162  * @author SylTi
163  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
164  * This will prevent any accidental loss of tokens.
165  */
166 contract CanReclaimToken is Ownable {
167   using SafeERC20 for ERC20Basic;
168 
169   /**
170    * @dev Reclaim all ERC20Basic compatible tokens
171    * @param _token ERC20Basic The address of the token contract
172    */
173   function reclaimToken(ERC20Basic _token) external onlyOwner {
174     uint256 balance = _token.balanceOf(this);
175     _token.safeTransfer(owner, balance);
176   }
177 
178 }
179 
180 /* eof (openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol) */
181 /* file: openzeppelin-solidity/contracts/math/SafeMath.sol */
182 pragma solidity ^0.4.24;
183 
184 
185 /**
186  * @title SafeMath
187  * @dev Math operations with safety checks that throw on error
188  */
189 library SafeMath {
190 
191   /**
192   * @dev Multiplies two numbers, throws on overflow.
193   */
194   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
195     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
196     // benefit is lost if 'b' is also tested.
197     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
198     if (_a == 0) {
199       return 0;
200     }
201 
202     c = _a * _b;
203     assert(c / _a == _b);
204     return c;
205   }
206 
207   /**
208   * @dev Integer division of two numbers, truncating the quotient.
209   */
210   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
211     // assert(_b > 0); // Solidity automatically throws when dividing by 0
212     // uint256 c = _a / _b;
213     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
214     return _a / _b;
215   }
216 
217   /**
218   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
219   */
220   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
221     assert(_b <= _a);
222     return _a - _b;
223   }
224 
225   /**
226   * @dev Adds two numbers, throws on overflow.
227   */
228   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
229     c = _a + _b;
230     assert(c >= _a);
231     return c;
232   }
233 }
234 
235 /* eof (openzeppelin-solidity/contracts/math/SafeMath.sol) */
236 /* file: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol */
237 pragma solidity ^0.4.24;
238 
239 
240 
241 /**
242  * @title Crowdsale
243  * @dev Crowdsale is a base contract for managing a token crowdsale,
244  * allowing investors to purchase tokens with ether. This contract implements
245  * such functionality in its most fundamental form and can be extended to provide additional
246  * functionality and/or custom behavior.
247  * The external interface represents the basic interface for purchasing tokens, and conform
248  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
249  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
250  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
251  * behavior.
252  */
253 contract Crowdsale {
254   using SafeMath for uint256;
255   using SafeERC20 for ERC20;
256 
257   // The token being sold
258   ERC20 public token;
259 
260   // Address where funds are collected
261   address public wallet;
262 
263   // How many token units a buyer gets per wei.
264   // The rate is the conversion between wei and the smallest and indivisible token unit.
265   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
266   // 1 wei will give you 1 unit, or 0.001 TOK.
267   uint256 public rate;
268 
269   // Amount of wei raised
270   uint256 public weiRaised;
271 
272   /**
273    * Event for token purchase logging
274    * @param purchaser who paid for the tokens
275    * @param beneficiary who got the tokens
276    * @param value weis paid for purchase
277    * @param amount amount of tokens purchased
278    */
279   event TokenPurchase(
280     address indexed purchaser,
281     address indexed beneficiary,
282     uint256 value,
283     uint256 amount
284   );
285 
286   /**
287    * @param _rate Number of token units a buyer gets per wei
288    * @param _wallet Address where collected funds will be forwarded to
289    * @param _token Address of the token being sold
290    */
291   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
292     require(_rate > 0);
293     require(_wallet != address(0));
294     require(_token != address(0));
295 
296     rate = _rate;
297     wallet = _wallet;
298     token = _token;
299   }
300 
301   // -----------------------------------------
302   // Crowdsale external interface
303   // -----------------------------------------
304 
305   /**
306    * @dev fallback function ***DO NOT OVERRIDE***
307    */
308   function () external payable {
309     buyTokens(msg.sender);
310   }
311 
312   /**
313    * @dev low level token purchase ***DO NOT OVERRIDE***
314    * @param _beneficiary Address performing the token purchase
315    */
316   function buyTokens(address _beneficiary) public payable {
317 
318     uint256 weiAmount = msg.value;
319     _preValidatePurchase(_beneficiary, weiAmount);
320 
321     // calculate token amount to be created
322     uint256 tokens = _getTokenAmount(weiAmount);
323 
324     // update state
325     weiRaised = weiRaised.add(weiAmount);
326 
327     _processPurchase(_beneficiary, tokens);
328     emit TokenPurchase(
329       msg.sender,
330       _beneficiary,
331       weiAmount,
332       tokens
333     );
334 
335     _updatePurchasingState(_beneficiary, weiAmount);
336 
337     _forwardFunds();
338     _postValidatePurchase(_beneficiary, weiAmount);
339   }
340 
341   // -----------------------------------------
342   // Internal interface (extensible)
343   // -----------------------------------------
344 
345   /**
346    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
347    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
348    *   super._preValidatePurchase(_beneficiary, _weiAmount);
349    *   require(weiRaised.add(_weiAmount) <= cap);
350    * @param _beneficiary Address performing the token purchase
351    * @param _weiAmount Value in wei involved in the purchase
352    */
353   function _preValidatePurchase(
354     address _beneficiary,
355     uint256 _weiAmount
356   )
357     internal
358   {
359     require(_beneficiary != address(0));
360     require(_weiAmount != 0);
361   }
362 
363   /**
364    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
365    * @param _beneficiary Address performing the token purchase
366    * @param _weiAmount Value in wei involved in the purchase
367    */
368   function _postValidatePurchase(
369     address _beneficiary,
370     uint256 _weiAmount
371   )
372     internal
373   {
374     // optional override
375   }
376 
377   /**
378    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
379    * @param _beneficiary Address performing the token purchase
380    * @param _tokenAmount Number of tokens to be emitted
381    */
382   function _deliverTokens(
383     address _beneficiary,
384     uint256 _tokenAmount
385   )
386     internal
387   {
388     token.safeTransfer(_beneficiary, _tokenAmount);
389   }
390 
391   /**
392    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
393    * @param _beneficiary Address receiving the tokens
394    * @param _tokenAmount Number of tokens to be purchased
395    */
396   function _processPurchase(
397     address _beneficiary,
398     uint256 _tokenAmount
399   )
400     internal
401   {
402     _deliverTokens(_beneficiary, _tokenAmount);
403   }
404 
405   /**
406    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
407    * @param _beneficiary Address receiving the tokens
408    * @param _weiAmount Value in wei involved in the purchase
409    */
410   function _updatePurchasingState(
411     address _beneficiary,
412     uint256 _weiAmount
413   )
414     internal
415   {
416     // optional override
417   }
418 
419   /**
420    * @dev Override to extend the way in which ether is converted to tokens.
421    * @param _weiAmount Value in wei to be converted into tokens
422    * @return Number of tokens that can be purchased with the specified _weiAmount
423    */
424   function _getTokenAmount(uint256 _weiAmount)
425     internal view returns (uint256)
426   {
427     return _weiAmount.mul(rate);
428   }
429 
430   /**
431    * @dev Determines how ETH is stored/forwarded on purchases.
432    */
433   function _forwardFunds() internal {
434     wallet.transfer(msg.value);
435   }
436 }
437 
438 /* eof (openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol) */
439 /* file: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol */
440 pragma solidity ^0.4.24;
441 
442 
443 
444 /**
445  * @title TimedCrowdsale
446  * @dev Crowdsale accepting contributions only within a time frame.
447  */
448 contract TimedCrowdsale is Crowdsale {
449   using SafeMath for uint256;
450 
451   uint256 public openingTime;
452   uint256 public closingTime;
453 
454   /**
455    * @dev Reverts if not in crowdsale time range.
456    */
457   modifier onlyWhileOpen {
458     // solium-disable-next-line security/no-block-members
459     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
460     _;
461   }
462 
463   /**
464    * @dev Constructor, takes crowdsale opening and closing times.
465    * @param _openingTime Crowdsale opening time
466    * @param _closingTime Crowdsale closing time
467    */
468   constructor(uint256 _openingTime, uint256 _closingTime) public {
469     // solium-disable-next-line security/no-block-members
470     require(_openingTime >= block.timestamp);
471     require(_closingTime >= _openingTime);
472 
473     openingTime = _openingTime;
474     closingTime = _closingTime;
475   }
476 
477   /**
478    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
479    * @return Whether crowdsale period has elapsed
480    */
481   function hasClosed() public view returns (bool) {
482     // solium-disable-next-line security/no-block-members
483     return block.timestamp > closingTime;
484   }
485 
486   /**
487    * @dev Extend parent behavior requiring to be within contributing period
488    * @param _beneficiary Token purchaser
489    * @param _weiAmount Amount of wei contributed
490    */
491   function _preValidatePurchase(
492     address _beneficiary,
493     uint256 _weiAmount
494   )
495     internal
496     onlyWhileOpen
497   {
498     super._preValidatePurchase(_beneficiary, _weiAmount);
499   }
500 
501 }
502 
503 /* eof (openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol) */
504 /* file: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol */
505 pragma solidity ^0.4.24;
506 
507 
508 
509 /**
510  * @title FinalizableCrowdsale
511  * @dev Extension of Crowdsale where an owner can do extra work
512  * after finishing.
513  */
514 contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
515   using SafeMath for uint256;
516 
517   bool public isFinalized = false;
518 
519   event Finalized();
520 
521   /**
522    * @dev Must be called after crowdsale ends, to do some extra finalization
523    * work. Calls the contract's finalization function.
524    */
525   function finalize() public onlyOwner {
526     require(!isFinalized);
527     require(hasClosed());
528 
529     finalization();
530     emit Finalized();
531 
532     isFinalized = true;
533   }
534 
535   /**
536    * @dev Can be overridden to add finalization logic. The overriding function
537    * should call super.finalization() to ensure the chain of finalization is
538    * executed entirely.
539    */
540   function finalization() internal {
541   }
542 
543 }
544 
545 /* eof (openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol) */
546 /* file: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol */
547 pragma solidity ^0.4.24;
548 
549 
550 
551 /**
552  * @title CappedCrowdsale
553  * @dev Crowdsale with a limit for total contributions.
554  */
555 contract CappedCrowdsale is Crowdsale {
556   using SafeMath for uint256;
557 
558   uint256 public cap;
559 
560   /**
561    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
562    * @param _cap Max amount of wei to be contributed
563    */
564   constructor(uint256 _cap) public {
565     require(_cap > 0);
566     cap = _cap;
567   }
568 
569   /**
570    * @dev Checks whether the cap has been reached.
571    * @return Whether the cap was reached
572    */
573   function capReached() public view returns (bool) {
574     return weiRaised >= cap;
575   }
576 
577   /**
578    * @dev Extend parent behavior requiring purchase to respect the funding cap.
579    * @param _beneficiary Token purchaser
580    * @param _weiAmount Amount of wei contributed
581    */
582   function _preValidatePurchase(
583     address _beneficiary,
584     uint256 _weiAmount
585   )
586     internal
587   {
588     super._preValidatePurchase(_beneficiary, _weiAmount);
589     require(weiRaised.add(_weiAmount) <= cap);
590   }
591 
592 }
593 
594 /* eof (openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol) */
595 /* file: openzeppelin-solidity/contracts/access/rbac/Roles.sol */
596 pragma solidity ^0.4.24;
597 
598 
599 /**
600  * @title Roles
601  * @author Francisco Giordano (@frangio)
602  * @dev Library for managing addresses assigned to a Role.
603  * See RBAC.sol for example usage.
604  */
605 library Roles {
606   struct Role {
607     mapping (address => bool) bearer;
608   }
609 
610   /**
611    * @dev give an address access to this role
612    */
613   function add(Role storage _role, address _addr)
614     internal
615   {
616     _role.bearer[_addr] = true;
617   }
618 
619   /**
620    * @dev remove an address' access to this role
621    */
622   function remove(Role storage _role, address _addr)
623     internal
624   {
625     _role.bearer[_addr] = false;
626   }
627 
628   /**
629    * @dev check if an address has this role
630    * // reverts
631    */
632   function check(Role storage _role, address _addr)
633     internal
634     view
635   {
636     require(has(_role, _addr));
637   }
638 
639   /**
640    * @dev check if an address has this role
641    * @return bool
642    */
643   function has(Role storage _role, address _addr)
644     internal
645     view
646     returns (bool)
647   {
648     return _role.bearer[_addr];
649   }
650 }
651 
652 /* eof (openzeppelin-solidity/contracts/access/rbac/Roles.sol) */
653 /* file: openzeppelin-solidity/contracts/access/rbac/RBAC.sol */
654 pragma solidity ^0.4.24;
655 
656 
657 
658 /**
659  * @title RBAC (Role-Based Access Control)
660  * @author Matt Condon (@Shrugs)
661  * @dev Stores and provides setters and getters for roles and addresses.
662  * Supports unlimited numbers of roles and addresses.
663  * See //contracts/mocks/RBACMock.sol for an example of usage.
664  * This RBAC method uses strings to key roles. It may be beneficial
665  * for you to write your own implementation of this interface using Enums or similar.
666  */
667 contract RBAC {
668   using Roles for Roles.Role;
669 
670   mapping (string => Roles.Role) private roles;
671 
672   event RoleAdded(address indexed operator, string role);
673   event RoleRemoved(address indexed operator, string role);
674 
675   /**
676    * @dev reverts if addr does not have role
677    * @param _operator address
678    * @param _role the name of the role
679    * // reverts
680    */
681   function checkRole(address _operator, string _role)
682     public
683     view
684   {
685     roles[_role].check(_operator);
686   }
687 
688   /**
689    * @dev determine if addr has role
690    * @param _operator address
691    * @param _role the name of the role
692    * @return bool
693    */
694   function hasRole(address _operator, string _role)
695     public
696     view
697     returns (bool)
698   {
699     return roles[_role].has(_operator);
700   }
701 
702   /**
703    * @dev add a role to an address
704    * @param _operator address
705    * @param _role the name of the role
706    */
707   function addRole(address _operator, string _role)
708     internal
709   {
710     roles[_role].add(_operator);
711     emit RoleAdded(_operator, _role);
712   }
713 
714   /**
715    * @dev remove a role from an address
716    * @param _operator address
717    * @param _role the name of the role
718    */
719   function removeRole(address _operator, string _role)
720     internal
721   {
722     roles[_role].remove(_operator);
723     emit RoleRemoved(_operator, _role);
724   }
725 
726   /**
727    * @dev modifier to scope access to a single role (uses msg.sender as addr)
728    * @param _role the name of the role
729    * // reverts
730    */
731   modifier onlyRole(string _role)
732   {
733     checkRole(msg.sender, _role);
734     _;
735   }
736 
737   /**
738    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
739    * @param _roles the names of the roles to scope access to
740    * // reverts
741    *
742    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
743    *  see: https://github.com/ethereum/solidity/issues/2467
744    */
745   // modifier onlyRoles(string[] _roles) {
746   //     bool hasAnyRole = false;
747   //     for (uint8 i = 0; i < _roles.length; i++) {
748   //         if (hasRole(msg.sender, _roles[i])) {
749   //             hasAnyRole = true;
750   //             break;
751   //         }
752   //     }
753 
754   //     require(hasAnyRole);
755 
756   //     _;
757   // }
758 }
759 
760 /* eof (openzeppelin-solidity/contracts/access/rbac/RBAC.sol) */
761 /* file: openzeppelin-solidity/contracts/access/Whitelist.sol */
762 pragma solidity ^0.4.24;
763 
764 
765 
766 
767 /**
768  * @title Whitelist
769  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
770  * This simplifies the implementation of "user permissions".
771  */
772 contract Whitelist is Ownable, RBAC {
773   string public constant ROLE_WHITELISTED = "whitelist";
774 
775   /**
776    * @dev Throws if operator is not whitelisted.
777    * @param _operator address
778    */
779   modifier onlyIfWhitelisted(address _operator) {
780     checkRole(_operator, ROLE_WHITELISTED);
781     _;
782   }
783 
784   /**
785    * @dev add an address to the whitelist
786    * @param _operator address
787    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
788    */
789   function addAddressToWhitelist(address _operator)
790     public
791     onlyOwner
792   {
793     addRole(_operator, ROLE_WHITELISTED);
794   }
795 
796   /**
797    * @dev getter to determine if address is in whitelist
798    */
799   function whitelist(address _operator)
800     public
801     view
802     returns (bool)
803   {
804     return hasRole(_operator, ROLE_WHITELISTED);
805   }
806 
807   /**
808    * @dev add addresses to the whitelist
809    * @param _operators addresses
810    * @return true if at least one address was added to the whitelist,
811    * false if all addresses were already in the whitelist
812    */
813   function addAddressesToWhitelist(address[] _operators)
814     public
815     onlyOwner
816   {
817     for (uint256 i = 0; i < _operators.length; i++) {
818       addAddressToWhitelist(_operators[i]);
819     }
820   }
821 
822   /**
823    * @dev remove an address from the whitelist
824    * @param _operator address
825    * @return true if the address was removed from the whitelist,
826    * false if the address wasn't in the whitelist in the first place
827    */
828   function removeAddressFromWhitelist(address _operator)
829     public
830     onlyOwner
831   {
832     removeRole(_operator, ROLE_WHITELISTED);
833   }
834 
835   /**
836    * @dev remove addresses from the whitelist
837    * @param _operators addresses
838    * @return true if at least one address was removed from the whitelist,
839    * false if all addresses weren't in the whitelist in the first place
840    */
841   function removeAddressesFromWhitelist(address[] _operators)
842     public
843     onlyOwner
844   {
845     for (uint256 i = 0; i < _operators.length; i++) {
846       removeAddressFromWhitelist(_operators[i]);
847     }
848   }
849 
850 }
851 
852 /* eof (openzeppelin-solidity/contracts/access/Whitelist.sol) */
853 /* file: openzeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol */
854 pragma solidity ^0.4.24;
855 
856 
857 
858 /**
859  * @title WhitelistedCrowdsale
860  * @dev Crowdsale in which only whitelisted users can contribute.
861  */
862 contract WhitelistedCrowdsale is Whitelist, Crowdsale {
863   /**
864    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
865    * @param _beneficiary Token beneficiary
866    * @param _weiAmount Amount of wei contributed
867    */
868   function _preValidatePurchase(
869     address _beneficiary,
870     uint256 _weiAmount
871   )
872     internal
873     onlyIfWhitelisted(_beneficiary)
874   {
875     super._preValidatePurchase(_beneficiary, _weiAmount);
876   }
877 
878 }
879 
880 /* eof (openzeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol) */
881 /* file: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol */
882 pragma solidity ^0.4.24;
883 
884 
885 
886 
887 /**
888  * @title Basic token
889  * @dev Basic version of StandardToken, with no allowances.
890  */
891 contract BasicToken is ERC20Basic {
892   using SafeMath for uint256;
893 
894   mapping(address => uint256) internal balances;
895 
896   uint256 internal totalSupply_;
897 
898   /**
899   * @dev Total number of tokens in existence
900   */
901   function totalSupply() public view returns (uint256) {
902     return totalSupply_;
903   }
904 
905   /**
906   * @dev Transfer token for a specified address
907   * @param _to The address to transfer to.
908   * @param _value The amount to be transferred.
909   */
910   function transfer(address _to, uint256 _value) public returns (bool) {
911     require(_value <= balances[msg.sender]);
912     require(_to != address(0));
913 
914     balances[msg.sender] = balances[msg.sender].sub(_value);
915     balances[_to] = balances[_to].add(_value);
916     emit Transfer(msg.sender, _to, _value);
917     return true;
918   }
919 
920   /**
921   * @dev Gets the balance of the specified address.
922   * @param _owner The address to query the the balance of.
923   * @return An uint256 representing the amount owned by the passed address.
924   */
925   function balanceOf(address _owner) public view returns (uint256) {
926     return balances[_owner];
927   }
928 
929 }
930 
931 /* eof (openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol) */
932 /* file: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol */
933 pragma solidity ^0.4.24;
934 
935 
936 
937 /**
938  * @title Standard ERC20 token
939  *
940  * @dev Implementation of the basic standard token.
941  * https://github.com/ethereum/EIPs/issues/20
942  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
943  */
944 contract StandardToken is ERC20, BasicToken {
945 
946   mapping (address => mapping (address => uint256)) internal allowed;
947 
948 
949   /**
950    * @dev Transfer tokens from one address to another
951    * @param _from address The address which you want to send tokens from
952    * @param _to address The address which you want to transfer to
953    * @param _value uint256 the amount of tokens to be transferred
954    */
955   function transferFrom(
956     address _from,
957     address _to,
958     uint256 _value
959   )
960     public
961     returns (bool)
962   {
963     require(_value <= balances[_from]);
964     require(_value <= allowed[_from][msg.sender]);
965     require(_to != address(0));
966 
967     balances[_from] = balances[_from].sub(_value);
968     balances[_to] = balances[_to].add(_value);
969     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
970     emit Transfer(_from, _to, _value);
971     return true;
972   }
973 
974   /**
975    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
976    * Beware that changing an allowance with this method brings the risk that someone may use both the old
977    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
978    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
979    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
980    * @param _spender The address which will spend the funds.
981    * @param _value The amount of tokens to be spent.
982    */
983   function approve(address _spender, uint256 _value) public returns (bool) {
984     allowed[msg.sender][_spender] = _value;
985     emit Approval(msg.sender, _spender, _value);
986     return true;
987   }
988 
989   /**
990    * @dev Function to check the amount of tokens that an owner allowed to a spender.
991    * @param _owner address The address which owns the funds.
992    * @param _spender address The address which will spend the funds.
993    * @return A uint256 specifying the amount of tokens still available for the spender.
994    */
995   function allowance(
996     address _owner,
997     address _spender
998    )
999     public
1000     view
1001     returns (uint256)
1002   {
1003     return allowed[_owner][_spender];
1004   }
1005 
1006   /**
1007    * @dev Increase the amount of tokens that an owner allowed to a spender.
1008    * approve should be called when allowed[_spender] == 0. To increment
1009    * allowed value is better to use this function to avoid 2 calls (and wait until
1010    * the first transaction is mined)
1011    * From MonolithDAO Token.sol
1012    * @param _spender The address which will spend the funds.
1013    * @param _addedValue The amount of tokens to increase the allowance by.
1014    */
1015   function increaseApproval(
1016     address _spender,
1017     uint256 _addedValue
1018   )
1019     public
1020     returns (bool)
1021   {
1022     allowed[msg.sender][_spender] = (
1023       allowed[msg.sender][_spender].add(_addedValue));
1024     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1025     return true;
1026   }
1027 
1028   /**
1029    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1030    * approve should be called when allowed[_spender] == 0. To decrement
1031    * allowed value is better to use this function to avoid 2 calls (and wait until
1032    * the first transaction is mined)
1033    * From MonolithDAO Token.sol
1034    * @param _spender The address which will spend the funds.
1035    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1036    */
1037   function decreaseApproval(
1038     address _spender,
1039     uint256 _subtractedValue
1040   )
1041     public
1042     returns (bool)
1043   {
1044     uint256 oldValue = allowed[msg.sender][_spender];
1045     if (_subtractedValue >= oldValue) {
1046       allowed[msg.sender][_spender] = 0;
1047     } else {
1048       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1049     }
1050     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1051     return true;
1052   }
1053 
1054 }
1055 
1056 /* eof (openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol) */
1057 /* file: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol */
1058 pragma solidity ^0.4.24;
1059 
1060 
1061 
1062 /**
1063  * @title Mintable token
1064  * @dev Simple ERC20 Token example, with mintable token creation
1065  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
1066  */
1067 contract MintableToken is StandardToken, Ownable {
1068   event Mint(address indexed to, uint256 amount);
1069   event MintFinished();
1070 
1071   bool public mintingFinished = false;
1072 
1073 
1074   modifier canMint() {
1075     require(!mintingFinished);
1076     _;
1077   }
1078 
1079   modifier hasMintPermission() {
1080     require(msg.sender == owner);
1081     _;
1082   }
1083 
1084   /**
1085    * @dev Function to mint tokens
1086    * @param _to The address that will receive the minted tokens.
1087    * @param _amount The amount of tokens to mint.
1088    * @return A boolean that indicates if the operation was successful.
1089    */
1090   function mint(
1091     address _to,
1092     uint256 _amount
1093   )
1094     public
1095     hasMintPermission
1096     canMint
1097     returns (bool)
1098   {
1099     totalSupply_ = totalSupply_.add(_amount);
1100     balances[_to] = balances[_to].add(_amount);
1101     emit Mint(_to, _amount);
1102     emit Transfer(address(0), _to, _amount);
1103     return true;
1104   }
1105 
1106   /**
1107    * @dev Function to stop minting new tokens.
1108    * @return True if the operation was successful.
1109    */
1110   function finishMinting() public onlyOwner canMint returns (bool) {
1111     mintingFinished = true;
1112     emit MintFinished();
1113     return true;
1114   }
1115 }
1116 
1117 /* eof (openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol) */
1118 /* file: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol */
1119 pragma solidity ^0.4.24;
1120 
1121 
1122 
1123 /**
1124  * @title MintedCrowdsale
1125  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1126  * Token ownership should be transferred to MintedCrowdsale for minting.
1127  */
1128 contract MintedCrowdsale is Crowdsale {
1129 
1130   /**
1131    * @dev Overrides delivery by minting tokens upon purchase.
1132    * @param _beneficiary Token purchaser
1133    * @param _tokenAmount Number of tokens to be minted
1134    */
1135   function _deliverTokens(
1136     address _beneficiary,
1137     uint256 _tokenAmount
1138   )
1139     internal
1140   {
1141     // Potentially dangerous assumption about the type of the token.
1142     require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
1143   }
1144 }
1145 
1146 /* eof (openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol) */
1147 /* file: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol */
1148 pragma solidity ^0.4.24;
1149 
1150 
1151 
1152 /**
1153  * @title TokenTimelock
1154  * @dev TokenTimelock is a token holder contract that will allow a
1155  * beneficiary to extract the tokens after a given release time
1156  */
1157 contract TokenTimelock {
1158   using SafeERC20 for ERC20Basic;
1159 
1160   // ERC20 basic token contract being held
1161   ERC20Basic public token;
1162 
1163   // beneficiary of tokens after they are released
1164   address public beneficiary;
1165 
1166   // timestamp when token release is enabled
1167   uint256 public releaseTime;
1168 
1169   constructor(
1170     ERC20Basic _token,
1171     address _beneficiary,
1172     uint256 _releaseTime
1173   )
1174     public
1175   {
1176     // solium-disable-next-line security/no-block-members
1177     require(_releaseTime > block.timestamp);
1178     token = _token;
1179     beneficiary = _beneficiary;
1180     releaseTime = _releaseTime;
1181   }
1182 
1183   /**
1184    * @notice Transfers tokens held by timelock to beneficiary.
1185    */
1186   function release() public {
1187     // solium-disable-next-line security/no-block-members
1188     require(block.timestamp >= releaseTime);
1189 
1190     uint256 amount = token.balanceOf(address(this));
1191     require(amount > 0);
1192 
1193     token.safeTransfer(beneficiary, amount);
1194   }
1195 }
1196 
1197 /* eof (openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol) */
1198 /* file: openzeppelin-solidity/contracts/lifecycle/Pausable.sol */
1199 pragma solidity ^0.4.24;
1200 
1201 
1202 
1203 
1204 /**
1205  * @title Pausable
1206  * @dev Base contract which allows children to implement an emergency stop mechanism.
1207  */
1208 contract Pausable is Ownable {
1209   event Pause();
1210   event Unpause();
1211 
1212   bool public paused = false;
1213 
1214 
1215   /**
1216    * @dev Modifier to make a function callable only when the contract is not paused.
1217    */
1218   modifier whenNotPaused() {
1219     require(!paused);
1220     _;
1221   }
1222 
1223   /**
1224    * @dev Modifier to make a function callable only when the contract is paused.
1225    */
1226   modifier whenPaused() {
1227     require(paused);
1228     _;
1229   }
1230 
1231   /**
1232    * @dev called by the owner to pause, triggers stopped state
1233    */
1234   function pause() public onlyOwner whenNotPaused {
1235     paused = true;
1236     emit Pause();
1237   }
1238 
1239   /**
1240    * @dev called by the owner to unpause, returns to normal state
1241    */
1242   function unpause() public onlyOwner whenPaused {
1243     paused = false;
1244     emit Unpause();
1245   }
1246 }
1247 
1248 /* eof (openzeppelin-solidity/contracts/lifecycle/Pausable.sol) */
1249 /* file: ./contracts/ico/HbeCrowdsale.sol */
1250 /**
1251  * @title HBE Crowdsale
1252  * @author Validity Labs AG <info@validitylabs.org>
1253  */
1254 pragma solidity 0.4.24;
1255 
1256 
1257 
1258 // solhint-disable-next-line
1259 contract HbeCrowdsale is CanReclaimToken, CappedCrowdsale, MintedCrowdsale, WhitelistedCrowdsale, FinalizableCrowdsale, Pausable {
1260     /*** PRE-DEPLOYMENT CONFIGURED CONSTANTS */
1261     address public constant ETH_WALLET = 0x9E35Ee118D9B305F27AE1234BF5c035c1860989C;
1262     address public constant TEAM_WALLET = 0x992CEad41b885Dc90Ef82673c3c211Efa1Ef1AE2;
1263     uint256 public constant START_EASTER_BONUS = 1555668000; // Friday, 19 April 2019 12:00:00 GMT+02:00
1264     uint256 public constant END_EASTER_BONUS = 1555970399;   // Monday, 22 April 2019 23:59:59 GMT+02:00
1265     /*** CONSTANTS ***/
1266     uint256 public constant ICO_HARD_CAP = 22e8;             // 2,200,000,000 tokens, 0 decimals spec v1.7
1267     uint256 public constant CHF_HBE_RATE = 0.0143 * 1e4;    // 0.0143 (.10/7) CHF per HBE Token
1268     uint256 public constant TEAM_HBE_AMOUNT = 200e6;        // spec v1.7 200,000,000 team tokens
1269     uint256 public constant FOUR = 4;            // 25%
1270     uint256 public constant TWO = 2;             // 50%
1271     uint256 public constant HUNDRED = 100;
1272     uint256 public constant ONE_YEAR = 365 days;
1273     uint256 public constant BONUS_DURATION = 14 days;   // two weeks
1274     uint256 public constant BONUS_1 = 15;   // set 1 - 15% bonus
1275     uint256 public constant BONUS_2 = 10;   // set 2 and Easter Bonus - 10% bonus
1276     uint256 public constant BONUS_3 = 5;    // set 3 - 5% bonus
1277     uint256 public constant PRECISION = 1e6; // precision to account for none decimals
1278 
1279     /*** VARIABLES ***/
1280     // marks team allocation as minted
1281     bool public isTeamTokensMinted;
1282     address[3] public teamTokensLocked;
1283 
1284     // allow managers to whitelist and confirm contributions by manager accounts
1285     // managers can be set and altered by owner, multiple manager accounts are possible
1286     mapping(address => bool) public isManager;
1287 
1288     uint256 public tokensMinted;    // total token supply that has been minted and sold. does not include team tokens
1289     uint256 public rateDecimals;    // # of decimals that the CHF/ETH rate came in as
1290 
1291     /*** EVENTS  ***/
1292     event ChangedManager(address indexed manager, bool active);
1293     event NonEthTokenPurchase(uint256 investmentType, address indexed beneficiary, uint256 tokenAmount);
1294     event RefundAmount(address indexed beneficiary, uint256 refundAmount);
1295     event UpdatedFiatRate(uint256 fiatRate, uint256 rateDecimals);
1296 
1297     /*** MODIFIERS ***/
1298     modifier onlyManager() {
1299         require(isManager[msg.sender], "not manager");
1300         _;
1301     }
1302 
1303     modifier onlyValidAddress(address _address) {
1304         require(_address != address(0), "invalid address");
1305         _;
1306     }
1307 
1308     modifier onlyNoneZero(address _to, uint256 _amount) {
1309         require(_to != address(0), "invalid address");
1310         require(_amount > 0, "invalid amount");
1311         _;
1312     }
1313 
1314     /**
1315      * @dev constructor Deploy HBE Token Crowdsale
1316      * @param _startTime uint256 Start time of the crowdsale
1317      * @param _endTime uint256 End time of the crowdsale
1318      * @param _token ERC20 token address
1319      * @param _rate current CHF per ETH rate
1320      * @param _rateDecimals the # of decimals contained in the _rate variable
1321      */
1322     constructor(
1323         uint256 _startTime,
1324         uint256 _endTime,
1325         address _token,
1326         uint256 _rate,
1327         uint256 _rateDecimals
1328         )
1329         public
1330         Crowdsale(_rate, ETH_WALLET, ERC20(_token))
1331         TimedCrowdsale(_startTime, _endTime)
1332         CappedCrowdsale(ICO_HARD_CAP) {
1333             setManager(msg.sender, true);
1334             _updateRate(_rate, _rateDecimals);
1335         }
1336 
1337     /**
1338      * @dev Allow manager to update the exchange rate when necessary.
1339      * @param _rate uint256 current CHF per ETH rate
1340      * @param _rateDecimals the # of decimals contained in the _rate variable
1341      */
1342     function updateRate(uint256 _rate, uint256 _rateDecimals) external onlyManager {
1343         _updateRate(_rate, _rateDecimals);
1344     }
1345 
1346     /**
1347     * @dev create 3 token lockup contracts for X years to be released to the TEAM_WALLET
1348     */
1349     function mintTeamTokens() external onlyManager {
1350         require(!isTeamTokensMinted, "team tokens already minted");
1351 
1352         isTeamTokensMinted = true;
1353 
1354         TokenTimelock team1 = new TokenTimelock(ERC20Basic(token), TEAM_WALLET, openingTime.add(ONE_YEAR));
1355         TokenTimelock team2 = new TokenTimelock(ERC20Basic(token), TEAM_WALLET, openingTime.add(2 * ONE_YEAR));
1356         TokenTimelock team3 = new TokenTimelock(ERC20Basic(token), TEAM_WALLET, openingTime.add(3 * ONE_YEAR));
1357 
1358         teamTokensLocked[0] = address(team1);
1359         teamTokensLocked[1] = address(team2);
1360         teamTokensLocked[2] = address(team3);
1361 
1362         _deliverTokens(address(team1), TEAM_HBE_AMOUNT.div(FOUR));
1363         _deliverTokens(address(team2), TEAM_HBE_AMOUNT.div(FOUR));
1364         _deliverTokens(address(team3), TEAM_HBE_AMOUNT.div(TWO));
1365     }
1366 
1367     /**
1368     * @dev onlyManager allowed to handle batches of non-ETH investments
1369     * @param _investmentTypes uint256[] array of ids to identify investment types IE: BTC, CHF, EUR, etc...
1370     * @param _beneficiaries address[]
1371     * @param _amounts uint256[]
1372     */
1373     function batchNonEthPurchase(uint256[] _investmentTypes, address[] _beneficiaries, uint256[] _amounts) external {
1374         require(_beneficiaries.length == _amounts.length && _investmentTypes.length == _amounts.length, "length !=");
1375 
1376         for (uint256 i; i < _beneficiaries.length; i = i.add(1)) {
1377             nonEthPurchase(_investmentTypes[i], _beneficiaries[i], _amounts[i]);
1378         }
1379     }
1380 
1381     /**
1382     * @dev return the array of 3 token lock contracts for the HBE Team
1383     */
1384     function getTeamLockedContracts() external view returns (address[3]) {
1385         return teamTokensLocked;
1386     }
1387 
1388     /** OVERRIDE
1389     * @dev low level token purchase
1390     * @param _beneficiary Address performing the token purchase
1391     */
1392     function buyTokens(address _beneficiary) public payable {
1393         uint256 weiAmount = msg.value;
1394 
1395         _preValidatePurchase(_beneficiary, weiAmount);
1396 
1397         // calculate token amount to be created
1398         uint256 tokens = _getTokenAmount(weiAmount);
1399 
1400         // calculate a wei refund, if any, since decimal place is 0
1401         // update weiAmount if refund is > 0
1402         weiAmount = weiAmount.sub(refundLeftOverWei(weiAmount, tokens));
1403 
1404         // calculate bonus, if in bonus time period(s)
1405         tokens = tokens.add(_calcBonusAmount(tokens));
1406 
1407         // update state
1408         weiRaised = weiRaised.add(weiAmount);
1409         //push to investments array
1410         _processPurchase(_beneficiary, tokens);
1411         // throw event
1412         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
1413 
1414         // forward wei to the wallet
1415         _forwardFunds(weiAmount);
1416     }
1417 
1418     /** OVERRIDE - change to tokensMinted from weiRaised
1419     * @dev Checks whether the cap has been reached.
1420     * only active if a cap has been set
1421     * @return Whether the cap was reached
1422     */
1423     function capReached() public view returns (bool) {
1424         return tokensMinted >= cap;
1425     }
1426 
1427     /**
1428      * @dev Set / alter manager / whitelister "account". This can be done from owner only
1429      * @param _manager address address of the manager to create/alter
1430      * @param _active bool flag that shows if the manager account is active
1431      */
1432     function setManager(address _manager, bool _active) public onlyOwner onlyValidAddress(_manager) {
1433         isManager[_manager] = _active;
1434         emit ChangedManager(_manager, _active);
1435     }
1436 
1437     /** OVERRIDE
1438     * @dev add an address to the whitelist
1439     * @param _address address
1440     * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1441     */
1442     function addAddressToWhitelist(address _address)
1443         public
1444         onlyManager
1445     {
1446         addRole(_address, ROLE_WHITELISTED);
1447     }
1448 
1449     /** OVERRIDE
1450     * @dev remove an address from the whitelist
1451     * @param _address address
1452     * @return true if the address was removed from the whitelist,
1453     * false if the address wasn't in the whitelist in the first place
1454     */
1455     function removeAddressFromWhitelist(address _address)
1456         public
1457         onlyManager
1458     {
1459         removeRole(_address, ROLE_WHITELISTED);
1460     }
1461 
1462     /** OVERRIDE
1463     * @dev remove addresses from the whitelist
1464     * @param _addresses addresses
1465     * @return true if at least one address was removed from the whitelist,
1466     * false if all addresses weren't in the whitelist in the first place
1467     */
1468     function removeAddressesFromWhitelist(address[] _addresses)
1469         public
1470         onlyManager
1471     {
1472         for (uint256 i = 0; i < _addresses.length; i++) {
1473             removeAddressFromWhitelist(_addresses[i]);
1474         }
1475     }
1476 
1477     /** OVERRIDE
1478     * @dev add addresses to the whitelist
1479     * @param _addresses addresses
1480     * @return true if at least one address was added to the whitelist,
1481     * false if all addresses were already in the whitelist
1482     */
1483     function addAddressesToWhitelist(address[] _addresses)
1484         public
1485         onlyManager
1486     {
1487         for (uint256 i = 0; i < _addresses.length; i++) {
1488             addAddressToWhitelist(_addresses[i]);
1489         }
1490     }
1491 
1492     /**
1493     * @dev onlyManager allowed to allocate non-ETH investments during the crowdsale
1494     * @param _investmentType uint256
1495     * @param _beneficiary address
1496     * @param _tokenAmount uint256
1497     */
1498     function nonEthPurchase(uint256 _investmentType, address _beneficiary, uint256 _tokenAmount) public
1499         onlyManager
1500         onlyWhileOpen
1501         onlyNoneZero(_beneficiary, _tokenAmount)
1502     {
1503         _processPurchase(_beneficiary, _tokenAmount);
1504         emit NonEthTokenPurchase(_investmentType, _beneficiary, _tokenAmount);
1505     }
1506 
1507     /** OVERRIDE
1508     * @dev called by the manager to pause, triggers stopped state
1509     */
1510     function pause() public onlyManager whenNotPaused onlyWhileOpen {
1511         paused = true;
1512         emit Pause();
1513     }
1514 
1515     /** OVERRIDE
1516     * @dev called by the manager to unpause, returns to normal state
1517     */
1518     function unpause() public onlyManager whenPaused {
1519         paused = false;
1520         emit Unpause();
1521     }
1522 
1523     /** OVERRIDE
1524     * @dev onlyManager allows tokens to be tradeable transfers HBE Token ownership back to owner
1525     */
1526     function finalize() public onlyManager {
1527         Pausable(address(token)).unpause();
1528         Ownable(address(token)).transferOwnership(owner);
1529 
1530         super.finalize();
1531     }
1532 
1533     /*** INTERNAL/PRIVATE FUNCTIONS ***/
1534     /** OVERRIDE - do not call super.METHOD
1535     * @dev Validation of an incoming purchase. Use require statements to revert
1536     * state when conditions are not met. Use super to concatenate validations.
1537     * @param _beneficiary Address performing the token purchase
1538     * @param _weiAmount Value in wei involved in the purchase
1539     */
1540     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)
1541         internal
1542         onlyWhileOpen
1543         whenNotPaused
1544         onlyIfWhitelisted(_beneficiary) {
1545             require(_weiAmount != 0, "invalid amount");
1546             require(!capReached(), "cap has been reached");
1547         }
1548 
1549     /** OVERRIDE
1550     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
1551     * @param _beneficiary Address receiving the tokens
1552     * @param _tokenAmount Number of tokens to be purchased
1553     */
1554     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
1555         tokensMinted = tokensMinted.add(_tokenAmount);
1556         // respect the token cap
1557         require(tokensMinted <= cap, "tokensMinted > cap");
1558         _deliverTokens(_beneficiary, _tokenAmount);
1559     }
1560 
1561     /** OVERRIDE
1562     * @dev Override to extend the way in which ether is converted to tokens.
1563     * @param _weiAmount Value in wei to be converted into tokens
1564     * @return Number of tokens that can be purchased with the specified _weiAmount
1565     */
1566     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1567         return _weiAmount.mul(rate).div(rateDecimals).div(1e18).div(PRECISION);
1568     }
1569 
1570     /**
1571     * @dev calculate the bonus amount pending on time
1572     */
1573     function _calcBonusAmount(uint256 _tokenAmount) internal view returns (uint256) {
1574         uint256 currentBonus;
1575 
1576         /* solhint-disable */
1577         if (block.timestamp < openingTime.add(BONUS_DURATION)) {
1578             currentBonus = BONUS_1;
1579         } else if (block.timestamp < openingTime.add(BONUS_DURATION.mul(2))) {
1580             currentBonus = BONUS_2;
1581         } else if (block.timestamp < openingTime.add(BONUS_DURATION.mul(3))) {
1582             currentBonus = BONUS_3;
1583         } else if (block.timestamp >= START_EASTER_BONUS && block.timestamp < END_EASTER_BONUS) {
1584             currentBonus = BONUS_2;
1585         }
1586         /* solhint-enable */
1587 
1588         return _tokenAmount.mul(currentBonus).div(HUNDRED);
1589     }
1590 
1591     /**
1592      * @dev calculate wei refund to investor, if any. This handles rounding errors
1593      * which are important here due to the 0 decimals
1594      * @param _weiReceived uint256 wei received from the investor
1595      * @param _tokenAmount uint256 HBE tokens minted for investor
1596      */
1597     function refundLeftOverWei(uint256 _weiReceived, uint256 _tokenAmount) internal returns (uint256 refundAmount) {
1598         uint256 weiInvested = _tokenAmount.mul(1e18).mul(PRECISION).mul(rateDecimals).div(rate);
1599 
1600         if (weiInvested < _weiReceived) {
1601             refundAmount = _weiReceived.sub(weiInvested);
1602         }
1603 
1604         if (refundAmount > 0) {
1605             msg.sender.transfer(refundAmount);
1606             emit RefundAmount(msg.sender, refundAmount);
1607         }
1608 
1609         return refundAmount;
1610     }
1611 
1612     /** OVERRIDE
1613     * @dev Determines how ETH is stored/forwarded on purchases.
1614     * @param _weiAmount uint256
1615     */
1616     function _forwardFunds(uint256 _weiAmount) internal {
1617         wallet.transfer(_weiAmount);
1618     }
1619 
1620     /**
1621      * @dev Allow manager to update the exchange rate when necessary.
1622      * @param _rate uint256
1623      * @param _rateDecimals the # of decimals contained in the _rate variable
1624      */
1625     function _updateRate(uint256 _rate, uint256 _rateDecimals) internal {
1626         require(_rateDecimals <= 18);
1627 
1628         rateDecimals = 10**_rateDecimals;
1629         rate = (_rate.mul(1e4).mul(PRECISION).div(CHF_HBE_RATE));
1630 
1631         emit UpdatedFiatRate(_rate, _rateDecimals);
1632     }
1633 }
1634 
1635 /* eof (./contracts/ico/HbeCrowdsale.sol) */