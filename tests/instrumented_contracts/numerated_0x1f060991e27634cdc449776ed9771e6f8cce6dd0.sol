1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * See https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender)
68     public view returns (uint256);
69 
70   function transferFrom(address from, address to, uint256 value)
71     public returns (bool);
72 
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(
75     address indexed owner,
76     address indexed spender,
77     uint256 value
78   );
79 }
80 
81 
82 /**
83  * @title SafeERC20
84  * @dev Wrappers around ERC20 operations that throw on failure.
85  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
86  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
87  */
88 library SafeERC20 {
89   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
90     require(token.transfer(to, value));
91   }
92 
93   function safeTransferFrom(
94     ERC20 token,
95     address from,
96     address to,
97     uint256 value
98   )
99     internal
100   {
101     require(token.transferFrom(from, to, value));
102   }
103 
104   function safeApprove(ERC20 token, address spender, uint256 value) internal {
105     require(token.approve(spender, value));
106   }
107 }
108 
109 
110 /**
111  * @title Crowdsale
112  * @dev Crowdsale is a base contract for managing a token crowdsale,
113  * allowing investors to purchase tokens with ether. This contract implements
114  * such functionality in its most fundamental form and can be extended to provide additional
115  * functionality and/or custom behavior.
116  * The external interface represents the basic interface for purchasing tokens, and conform
117  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
118  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
119  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
120  * behavior.
121  */
122 contract Crowdsale {
123   using SafeMath for uint256;
124   using SafeERC20 for ERC20;
125 
126   // The token being sold
127   ERC20 public token;
128 
129   // Address where funds are collected
130   address public wallet;
131 
132   // How many token units a buyer gets per wei.
133   // The rate is the conversion between wei and the smallest and indivisible token unit.
134   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
135   // 1 wei will give you 1 unit, or 0.001 TOK.
136   uint256 public rate;
137 
138   // Amount of wei raised
139   uint256 public weiRaised;
140 
141   /**
142    * Event for token purchase logging
143    * @param purchaser who paid for the tokens
144    * @param beneficiary who got the tokens
145    * @param value weis paid for purchase
146    * @param amount amount of tokens purchased
147    */
148   event TokenPurchase(
149     address indexed purchaser,
150     address indexed beneficiary,
151     uint256 value,
152     uint256 amount
153   );
154 
155   /**
156    * @param _rate Number of token units a buyer gets per wei
157    * @param _wallet Address where collected funds will be forwarded to
158    * @param _token Address of the token being sold
159    */
160   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
161     require(_rate > 0);
162     require(_wallet != address(0));
163     require(_token != address(0));
164 
165     rate = _rate;
166     wallet = _wallet;
167     token = _token;
168   }
169 
170   // -----------------------------------------
171   // Crowdsale external interface
172   // -----------------------------------------
173 
174   /**
175    * @dev fallback function ***DO NOT OVERRIDE***
176    */
177   function () external payable {
178     buyTokens(msg.sender);
179   }
180 
181   /**
182    * @dev low level token purchase ***DO NOT OVERRIDE***
183    * @param _beneficiary Address performing the token purchase
184    */
185   function buyTokens(address _beneficiary) public payable {
186 
187     uint256 weiAmount = msg.value;
188     _preValidatePurchase(_beneficiary, weiAmount);
189 
190     // calculate token amount to be created
191     uint256 tokens = _getTokenAmount(weiAmount);
192 
193     // update state
194     weiRaised = weiRaised.add(weiAmount);
195 
196     _processPurchase(_beneficiary, tokens);
197     emit TokenPurchase(
198       msg.sender,
199       _beneficiary,
200       weiAmount,
201       tokens
202     );
203 
204     _updatePurchasingState(_beneficiary, weiAmount);
205 
206     _forwardFunds();
207     _postValidatePurchase(_beneficiary, weiAmount);
208   }
209 
210   // -----------------------------------------
211   // Internal interface (extensible)
212   // -----------------------------------------
213 
214   /**
215    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
216    * @param _beneficiary Address performing the token purchase
217    * @param _weiAmount Value in wei involved in the purchase
218    */
219   function _preValidatePurchase(
220     address _beneficiary,
221     uint256 _weiAmount
222   )
223     internal
224   {
225     require(_beneficiary != address(0));
226     require(_weiAmount != 0);
227   }
228 
229   /**
230    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
231    * @param _beneficiary Address performing the token purchase
232    * @param _weiAmount Value in wei involved in the purchase
233    */
234   function _postValidatePurchase(
235     address _beneficiary,
236     uint256 _weiAmount
237   )
238     internal
239   {
240     // optional override
241   }
242 
243   /**
244    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
245    * @param _beneficiary Address performing the token purchase
246    * @param _tokenAmount Number of tokens to be emitted
247    */
248   function _deliverTokens(
249     address _beneficiary,
250     uint256 _tokenAmount
251   )
252     internal
253   {
254     token.safeTransfer(_beneficiary, _tokenAmount);
255   }
256 
257   /**
258    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
259    * @param _beneficiary Address receiving the tokens
260    * @param _tokenAmount Number of tokens to be purchased
261    */
262   function _processPurchase(
263     address _beneficiary,
264     uint256 _tokenAmount
265   )
266     internal
267   {
268     _deliverTokens(_beneficiary, _tokenAmount);
269   }
270 
271   /**
272    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
273    * @param _beneficiary Address receiving the tokens
274    * @param _weiAmount Value in wei involved in the purchase
275    */
276   function _updatePurchasingState(
277     address _beneficiary,
278     uint256 _weiAmount
279   )
280     internal
281   {
282     // optional override
283   }
284 
285   /**
286    * @dev Override to extend the way in which ether is converted to tokens.
287    * @param _weiAmount Value in wei to be converted into tokens
288    * @return Number of tokens that can be purchased with the specified _weiAmount
289    */
290   function _getTokenAmount(uint256 _weiAmount)
291     internal view returns (uint256)
292   {
293     return _weiAmount.mul(rate);
294   }
295 
296   /**
297    * @dev Determines how ETH is stored/forwarded on purchases.
298    */
299   function _forwardFunds() internal {
300     wallet.transfer(msg.value);
301   }
302 }
303 /**
304  * @title Ownable
305  * @dev The Ownable contract has an owner address, and provides basic authorization control
306  * functions, this simplifies the implementation of "user permissions".
307  */
308 contract Ownable {
309   address public owner;
310 
311 
312   event OwnershipRenounced(address indexed previousOwner);
313   event OwnershipTransferred(
314     address indexed previousOwner,
315     address indexed newOwner
316   );
317 
318 
319   /**
320    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
321    * account.
322    */
323   constructor() public {
324     owner = msg.sender;
325   }
326 
327   /**
328    * @dev Throws if called by any account other than the owner.
329    */
330   modifier onlyOwner() {
331     require(msg.sender == owner);
332     _;
333   }
334 
335   /**
336    * @dev Allows the current owner to relinquish control of the contract.
337    * @notice Renouncing to ownership will leave the contract without an owner.
338    * It will not be possible to call the functions with the `onlyOwner`
339    * modifier anymore.
340    */
341   function renounceOwnership() public onlyOwner {
342     emit OwnershipRenounced(owner);
343     owner = address(0);
344   }
345 
346   /**
347    * @dev Allows the current owner to transfer control of the contract to a newOwner.
348    * @param _newOwner The address to transfer ownership to.
349    */
350   function transferOwnership(address _newOwner) public onlyOwner {
351     _transferOwnership(_newOwner);
352   }
353 
354   /**
355    * @dev Transfers control of the contract to a newOwner.
356    * @param _newOwner The address to transfer ownership to.
357    */
358   function _transferOwnership(address _newOwner) internal {
359     require(_newOwner != address(0));
360     emit OwnershipTransferred(owner, _newOwner);
361     owner = _newOwner;
362   }
363 }
364 /**
365  * @title Roles
366  * @author Francisco Giordano (@frangio)
367  * @dev Library for managing addresses assigned to a Role.
368  * See RBAC.sol for example usage.
369  */
370 library Roles {
371   struct Role {
372     mapping (address => bool) bearer;
373   }
374 
375   /**
376    * @dev give an address access to this role
377    */
378   function add(Role storage role, address addr)
379     internal
380   {
381     role.bearer[addr] = true;
382   }
383 
384   /**
385    * @dev remove an address' access to this role
386    */
387   function remove(Role storage role, address addr)
388     internal
389   {
390     role.bearer[addr] = false;
391   }
392 
393   /**
394    * @dev check if an address has this role
395    * // reverts
396    */
397   function check(Role storage role, address addr)
398     view
399     internal
400   {
401     require(has(role, addr));
402   }
403 
404   /**
405    * @dev check if an address has this role
406    * @return bool
407    */
408   function has(Role storage role, address addr)
409     view
410     internal
411     returns (bool)
412   {
413     return role.bearer[addr];
414   }
415 }
416 
417 
418 /**
419  * @title RBAC (Role-Based Access Control)
420  * @author Matt Condon (@Shrugs)
421  * @dev Stores and provides setters and getters for roles and addresses.
422  * Supports unlimited numbers of roles and addresses.
423  * See //contracts/mocks/RBACMock.sol for an example of usage.
424  * This RBAC method uses strings to key roles. It may be beneficial
425  * for you to write your own implementation of this interface using Enums or similar.
426  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
427  * to avoid typos.
428  */
429 contract RBAC {
430   using Roles for Roles.Role;
431 
432   mapping (string => Roles.Role) private roles;
433 
434   event RoleAdded(address indexed operator, string role);
435   event RoleRemoved(address indexed operator, string role);
436 
437   /**
438    * @dev reverts if addr does not have role
439    * @param _operator address
440    * @param _role the name of the role
441    * // reverts
442    */
443   function checkRole(address _operator, string _role)
444     view
445     public
446   {
447     roles[_role].check(_operator);
448   }
449 
450   /**
451    * @dev determine if addr has role
452    * @param _operator address
453    * @param _role the name of the role
454    * @return bool
455    */
456   function hasRole(address _operator, string _role)
457     view
458     public
459     returns (bool)
460   {
461     return roles[_role].has(_operator);
462   }
463 
464   /**
465    * @dev add a role to an address
466    * @param _operator address
467    * @param _role the name of the role
468    */
469   function addRole(address _operator, string _role)
470     internal
471   {
472     roles[_role].add(_operator);
473     emit RoleAdded(_operator, _role);
474   }
475 
476   /**
477    * @dev remove a role from an address
478    * @param _operator address
479    * @param _role the name of the role
480    */
481   function removeRole(address _operator, string _role)
482     internal
483   {
484     roles[_role].remove(_operator);
485     emit RoleRemoved(_operator, _role);
486   }
487 
488   /**
489    * @dev modifier to scope access to a single role (uses msg.sender as addr)
490    * @param _role the name of the role
491    * // reverts
492    */
493   modifier onlyRole(string _role)
494   {
495     checkRole(msg.sender, _role);
496     _;
497   }
498 
499   /**
500    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
501    * @param _roles the names of the roles to scope access to
502    * // reverts
503    *
504    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
505    *  see: https://github.com/ethereum/solidity/issues/2467
506    */
507   // modifier onlyRoles(string[] _roles) {
508   //     bool hasAnyRole = false;
509   //     for (uint8 i = 0; i < _roles.length; i++) {
510   //         if (hasRole(msg.sender, _roles[i])) {
511   //             hasAnyRole = true;
512   //             break;
513   //         }
514   //     }
515 
516   //     require(hasAnyRole);
517 
518   //     _;
519   // }
520 }
521 
522 /**
523  * @title Superuser
524  * @dev The Superuser contract defines a single superuser who can transfer the ownership 
525  * of a contract to a new address, even if he is not the owner. 
526  * A superuser can transfer his role to a new address. 
527  */
528 contract Superuser is Ownable, RBAC {
529   string public constant ROLE_SUPERUSER = "superuser";
530 
531   constructor () public {
532     addRole(msg.sender, ROLE_SUPERUSER);
533   }
534 
535   /**
536    * @dev Throws if called by any account that's not a superuser.
537    */
538   modifier onlySuperuser() {
539     checkRole(msg.sender, ROLE_SUPERUSER);
540     _;
541   }
542 
543   modifier onlyOwnerOrSuperuser() {
544     require(msg.sender == owner || isSuperuser(msg.sender));
545     _;
546   }
547 
548   /**
549    * @dev getter to determine if address has superuser role
550    */
551   function isSuperuser(address _addr)
552     public
553     view
554     returns (bool)
555   {
556     return hasRole(_addr, ROLE_SUPERUSER);
557   }
558 
559   /**
560    * @dev Allows the current superuser to transfer his role to a newSuperuser.
561    * @param _newSuperuser The address to transfer ownership to.
562    */
563   function transferSuperuser(address _newSuperuser) public onlySuperuser {
564     require(_newSuperuser != address(0));
565     removeRole(msg.sender, ROLE_SUPERUSER);
566     addRole(_newSuperuser, ROLE_SUPERUSER);
567   }
568 
569   /**
570    * @dev Allows the current superuser or owner to transfer control of the contract to a newOwner.
571    * @param _newOwner The address to transfer ownership to.
572    */
573   function transferOwnership(address _newOwner) public onlyOwnerOrSuperuser {
574     _transferOwnership(_newOwner);
575   }
576 }
577 
578 
579 /**
580  * @title TimedCrowdsale
581  * @dev Crowdsale accepting contributions only within a time frame.
582  */
583 contract TimedCrowdsale is Crowdsale {
584   using SafeMath for uint256;
585 
586   uint256 public openingTime;
587   uint256 public closingTime;
588 
589   /**
590    * @dev Reverts if not in crowdsale time range.
591    */
592   modifier onlyWhileOpen {
593     // solium-disable-next-line security/no-block-members
594     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
595     _;
596   }
597 
598   /**
599    * @dev Constructor, takes crowdsale opening and closing times.
600    * @param _openingTime Crowdsale opening time
601    * @param _closingTime Crowdsale closing time
602    */
603   constructor(uint256 _openingTime, uint256 _closingTime) public {
604     // solium-disable-next-line security/no-block-members
605     require(_openingTime >= block.timestamp);
606     require(_closingTime >= _openingTime);
607 
608     openingTime = _openingTime;
609     closingTime = _closingTime;
610   }
611 
612   /**
613    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
614    * @return Whether crowdsale period has elapsed
615    */
616   function hasClosed() public view returns (bool) {
617     // solium-disable-next-line security/no-block-members
618     return block.timestamp > closingTime;
619   }
620 
621   /**
622    * @dev Extend parent behavior requiring to be within contributing period
623    * @param _beneficiary Token purchaser
624    * @param _weiAmount Amount of wei contributed
625    */
626   function _preValidatePurchase(
627     address _beneficiary,
628     uint256 _weiAmount
629   )
630     internal
631     onlyWhileOpen
632   {
633     super._preValidatePurchase(_beneficiary, _weiAmount);
634   }
635 
636 }
637 
638 /**
639  * @title Whitelist
640  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
641  * This simplifies the implementation of "user permissions".
642  */
643 contract Whitelist is Ownable, RBAC {
644   string public constant ROLE_WHITELISTED = "whitelist";
645 
646   /**
647    * @dev Throws if operator is not whitelisted.
648    * @param _operator address
649    */
650   modifier onlyIfWhitelisted(address _operator) {
651     checkRole(_operator, ROLE_WHITELISTED);
652     _;
653   }
654 
655   /**
656    * @dev add an address to the whitelist
657    * @param _operator address
658    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
659    */
660   function addAddressToWhitelist(address _operator)
661     onlyOwner
662     public
663   {
664     addRole(_operator, ROLE_WHITELISTED);
665   }
666 
667   /**
668    * @dev getter to determine if address is in whitelist
669    */
670   function whitelist(address _operator)
671     public
672     view
673     returns (bool)
674   {
675     return hasRole(_operator, ROLE_WHITELISTED);
676   }
677 
678   /**
679    * @dev add addresses to the whitelist
680    * @param _operators addresses
681    * @return true if at least one address was added to the whitelist,
682    * false if all addresses were already in the whitelist
683    */
684   function addAddressesToWhitelist(address[] _operators)
685     onlyOwner
686     public
687   {
688     for (uint256 i = 0; i < _operators.length; i++) {
689       addAddressToWhitelist(_operators[i]);
690     }
691   }
692 
693   /**
694    * @dev remove an address from the whitelist
695    * @param _operator address
696    * @return true if the address was removed from the whitelist,
697    * false if the address wasn't in the whitelist in the first place
698    */
699   function removeAddressFromWhitelist(address _operator)
700     onlyOwner
701     public
702   {
703     removeRole(_operator, ROLE_WHITELISTED);
704   }
705 
706   /**
707    * @dev remove addresses from the whitelist
708    * @param _operators addresses
709    * @return true if at least one address was removed from the whitelist,
710    * false if all addresses weren't in the whitelist in the first place
711    */
712   function removeAddressesFromWhitelist(address[] _operators)
713     onlyOwner
714     public
715   {
716     for (uint256 i = 0; i < _operators.length; i++) {
717       removeAddressFromWhitelist(_operators[i]);
718     }
719   }
720 
721 }
722 
723 
724 /**
725  * @title WhitelistedCrowdsale
726  * @dev Crowdsale in which only whitelisted users can contribute.
727  */
728 contract WhitelistedCrowdsale is Whitelist, Crowdsale {
729   /**
730    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
731    * @param _beneficiary Token beneficiary
732    * @param _weiAmount Amount of wei contributed
733    */
734   function _preValidatePurchase(
735     address _beneficiary,
736     uint256 _weiAmount
737   )
738     onlyIfWhitelisted(_beneficiary)
739     internal
740   {
741     super._preValidatePurchase(_beneficiary, _weiAmount);
742   }
743 
744 }
745 /**
746  * @title CappedCrowdsale
747  * @dev Crowdsale with a limit for total contributions.
748  */
749 contract CappedCrowdsale is Crowdsale {
750   using SafeMath for uint256;
751 
752   uint256 public cap;
753 
754   /**
755    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
756    * @param _cap Max amount of wei to be contributed
757    */
758   constructor(uint256 _cap) public {
759     require(_cap > 0);
760     cap = _cap;
761   }
762 
763   /**
764    * @dev Checks whether the cap has been reached.
765    * @return Whether the cap was reached
766    */
767   function capReached() public view returns (bool) {
768     return weiRaised >= cap;
769   }
770 
771   /**
772    * @dev Extend parent behavior requiring purchase to respect the funding cap.
773    * @param _beneficiary Token purchaser
774    * @param _weiAmount Amount of wei contributed
775    */
776   function _preValidatePurchase(
777     address _beneficiary,
778     uint256 _weiAmount
779   )
780     internal
781   {
782     super._preValidatePurchase(_beneficiary, _weiAmount);
783     require(weiRaised.add(_weiAmount) <= cap);
784   }
785 
786 }
787 /**
788  * @title Basic token
789  * @dev Basic version of StandardToken, with no allowances.
790  */
791 contract BasicToken is ERC20Basic {
792   using SafeMath for uint256;
793 
794   mapping(address => uint256) balances;
795 
796   uint256 totalSupply_;
797 
798   /**
799   * @dev Total number of tokens in existence
800   */
801   function totalSupply() public view returns (uint256) {
802     return totalSupply_;
803   }
804 
805   /**
806   * @dev Transfer token for a specified address
807   * @param _to The address to transfer to.
808   * @param _value The amount to be transferred.
809   */
810   function transfer(address _to, uint256 _value) public returns (bool) {
811     require(_to != address(0));
812     require(_value <= balances[msg.sender]);
813 
814     balances[msg.sender] = balances[msg.sender].sub(_value);
815     balances[_to] = balances[_to].add(_value);
816     emit Transfer(msg.sender, _to, _value);
817     return true;
818   }
819 
820   /**
821   * @dev Gets the balance of the specified address.
822   * @param _owner The address to query the the balance of.
823   * @return An uint256 representing the amount owned by the passed address.
824   */
825   function balanceOf(address _owner) public view returns (uint256) {
826     return balances[_owner];
827   }
828 
829 }
830 
831 
832 
833 /**
834  * @title Standard ERC20 token
835  *
836  * @dev Implementation of the basic standard token.
837  * https://github.com/ethereum/EIPs/issues/20
838  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
839  */
840 contract StandardToken is ERC20, BasicToken {
841 
842   mapping (address => mapping (address => uint256)) internal allowed;
843 
844 
845   /**
846    * @dev Transfer tokens from one address to another
847    * @param _from address The address which you want to send tokens from
848    * @param _to address The address which you want to transfer to
849    * @param _value uint256 the amount of tokens to be transferred
850    */
851   function transferFrom(
852     address _from,
853     address _to,
854     uint256 _value
855   )
856     public
857     returns (bool)
858   {
859     require(_to != address(0));
860     require(_value <= balances[_from]);
861     require(_value <= allowed[_from][msg.sender]);
862 
863     balances[_from] = balances[_from].sub(_value);
864     balances[_to] = balances[_to].add(_value);
865     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
866     emit Transfer(_from, _to, _value);
867     return true;
868   }
869 
870   /**
871    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
872    * Beware that changing an allowance with this method brings the risk that someone may use both the old
873    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
874    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
875    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
876    * @param _spender The address which will spend the funds.
877    * @param _value The amount of tokens to be spent.
878    */
879   function approve(address _spender, uint256 _value) public returns (bool) {
880     allowed[msg.sender][_spender] = _value;
881     emit Approval(msg.sender, _spender, _value);
882     return true;
883   }
884 
885   /**
886    * @dev Function to check the amount of tokens that an owner allowed to a spender.
887    * @param _owner address The address which owns the funds.
888    * @param _spender address The address which will spend the funds.
889    * @return A uint256 specifying the amount of tokens still available for the spender.
890    */
891   function allowance(
892     address _owner,
893     address _spender
894    )
895     public
896     view
897     returns (uint256)
898   {
899     return allowed[_owner][_spender];
900   }
901 
902   /**
903    * @dev Increase the amount of tokens that an owner allowed to a spender.
904    * approve should be called when allowed[_spender] == 0. To increment
905    * allowed value is better to use this function to avoid 2 calls (and wait until
906    * the first transaction is mined)
907    * From MonolithDAO Token.sol
908    * @param _spender The address which will spend the funds.
909    * @param _addedValue The amount of tokens to increase the allowance by.
910    */
911   function increaseApproval(
912     address _spender,
913     uint256 _addedValue
914   )
915     public
916     returns (bool)
917   {
918     allowed[msg.sender][_spender] = (
919       allowed[msg.sender][_spender].add(_addedValue));
920     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
921     return true;
922   }
923 
924   /**
925    * @dev Decrease the amount of tokens that an owner allowed to a spender.
926    * approve should be called when allowed[_spender] == 0. To decrement
927    * allowed value is better to use this function to avoid 2 calls (and wait until
928    * the first transaction is mined)
929    * From MonolithDAO Token.sol
930    * @param _spender The address which will spend the funds.
931    * @param _subtractedValue The amount of tokens to decrease the allowance by.
932    */
933   function decreaseApproval(
934     address _spender,
935     uint256 _subtractedValue
936   )
937     public
938     returns (bool)
939   {
940     uint256 oldValue = allowed[msg.sender][_spender];
941     if (_subtractedValue > oldValue) {
942       allowed[msg.sender][_spender] = 0;
943     } else {
944       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
945     }
946     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
947     return true;
948   }
949 
950 }
951 
952 
953 
954 /**
955  * @title Mintable token
956  * @dev Simple ERC20 Token example, with mintable token creation
957  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
958  */
959 contract MintableToken is StandardToken, Ownable {
960   event Mint(address indexed to, uint256 amount);
961   event MintFinished();
962 
963   bool public mintingFinished = false;
964 
965 
966   modifier canMint() {
967     require(!mintingFinished);
968     _;
969   }
970 
971   modifier hasMintPermission() {
972     require(msg.sender == owner);
973     _;
974   }
975 
976   /**
977    * @dev Function to mint tokens
978    * @param _to The address that will receive the minted tokens.
979    * @param _amount The amount of tokens to mint.
980    * @return A boolean that indicates if the operation was successful.
981    */
982   function mint(
983     address _to,
984     uint256 _amount
985   )
986     hasMintPermission
987     canMint
988     public
989     returns (bool)
990   {
991     totalSupply_ = totalSupply_.add(_amount);
992     balances[_to] = balances[_to].add(_amount);
993     emit Mint(_to, _amount);
994     emit Transfer(address(0), _to, _amount);
995     return true;
996   }
997 
998   /**
999    * @dev Function to stop minting new tokens.
1000    * @return True if the operation was successful.
1001    */
1002   function finishMinting() onlyOwner canMint public returns (bool) {
1003     mintingFinished = true;
1004     emit MintFinished();
1005     return true;
1006   }
1007 }
1008 
1009 
1010 /**
1011  * @title MintedCrowdsale
1012  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
1013  * Token ownership should be transferred to MintedCrowdsale for minting.
1014  */
1015 contract MintedCrowdsale is Crowdsale {
1016 
1017   /**
1018    * @dev Overrides delivery by minting tokens upon purchase.
1019    * @param _beneficiary Token purchaser
1020    * @param _tokenAmount Number of tokens to be minted
1021    */
1022   function _deliverTokens(
1023     address _beneficiary,
1024     uint256 _tokenAmount
1025   )
1026     internal
1027   {
1028     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
1029   }
1030 }
1031 
1032 
1033 
1034 contract CoinSmarttICO is TimedCrowdsale, WhitelistedCrowdsale, MintedCrowdsale, Superuser {
1035 
1036   uint256 public round;
1037   uint256 public lastRound;
1038 
1039 	function CoinSmarttICO(uint256 _rate, 
1040     address _wallet, 
1041     ERC20 _token, 
1042     uint256 _openingTime, 
1043     uint256 _closingTime)
1044   TimedCrowdsale(_openingTime, _closingTime)
1045 	Crowdsale(_rate, _wallet, _token)
1046 
1047 	{
1048     round = 1;
1049     lastRound = 0;
1050 	}
1051 
1052   function changeRound(uint256 deadline, uint256 cap, uint256 _rate, uint256 _newAmount) internal {
1053     // uint256 supplied = token.totalSupply();
1054     if (now >= deadline || (_newAmount.sub(lastRound) >= cap)) {
1055       round += 1;
1056       lastRound = token.totalSupply();
1057       rate = _rate;
1058     }
1059   }
1060 
1061   function getRate(uint256 _newAmount) internal {
1062     if(round == 4) {
1063       //Final round, do nothing
1064       //check cap
1065     } else if (round == 3) {
1066       //round 3
1067       changeRound(1547596800, 666666667 ether, 32481, _newAmount);
1068     } else if (round == 2) {
1069       changeRound(1543622400, 333333333 ether, 38977, _newAmount);
1070     } else if (round == 1) {
1071       changeRound(1539648000, 250000000 ether, 48721, _newAmount);
1072     }
1073   }
1074   function _preValidatePurchase(
1075     address _beneficiary,
1076     uint256 _weiAmount
1077   )
1078     internal
1079   {
1080     require(_getTokenAmount(_weiAmount).add(token.totalSupply()) < 3138888888 ether);
1081     getRate(_getTokenAmount(_weiAmount).add(token.totalSupply()));
1082     super._preValidatePurchase(_beneficiary, _weiAmount);
1083   }
1084 
1085   function bumpRound(uint256 _rate)
1086   onlyOwner
1087   {
1088     //getRate(token.totalSupply());
1089     round += 1;
1090     lastRound = token.totalSupply();
1091     rate = _rate;
1092   }
1093 }