1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address _newOwner) public onlyOwner {
98     _transferOwnership(_newOwner);
99   }
100 
101   /**
102    * @dev Transfers control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function _transferOwnership(address _newOwner) internal {
106     require(_newOwner != address(0));
107     emit OwnershipTransferred(owner, _newOwner);
108     owner = _newOwner;
109   }
110 }
111 
112 /**
113  * @title ERC20Basic
114  * @dev Simpler version of ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/179
116  */
117 contract ERC20Basic {
118   function totalSupply() public view returns (uint256);
119   function balanceOf(address who) public view returns (uint256);
120   function transfer(address to, uint256 value) public returns (bool);
121   event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender)
130     public view returns (uint256);
131 
132   function transferFrom(address from, address to, uint256 value)
133     public returns (bool);
134 
135   function approve(address spender, uint256 value) public returns (bool);
136   event Approval(
137     address indexed owner,
138     address indexed spender,
139     uint256 value
140   );
141 }
142 
143 /**
144  * @title Crowdsale
145  * @dev Crowdsale is a base contract for managing a token crowdsale,
146  * allowing investors to purchase tokens with ether. This contract implements
147  * such functionality in its most fundamental form and can be extended to provide additional
148  * functionality and/or custom behavior.
149  * The external interface represents the basic interface for purchasing tokens, and conform
150  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
151  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
152  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
153  * behavior.
154  */
155 contract Crowdsale {
156   using SafeMath for uint256;
157 
158   // The token being sold
159   ERC20 public token;
160 
161   // Address where funds are collected
162   address public wallet;
163 
164   // How many token units a buyer gets per wei.
165   // The rate is the conversion between wei and the smallest and indivisible token unit.
166   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
167   // 1 wei will give you 1 unit, or 0.001 TOK.
168   uint256 public rate;
169 
170   // Amount of wei raised
171   uint256 public weiRaised;
172 
173   /**
174    * Event for token purchase logging
175    * @param purchaser who paid for the tokens
176    * @param beneficiary who got the tokens
177    * @param value weis paid for purchase
178    * @param amount amount of tokens purchased
179    */
180   event TokenPurchase(
181     address indexed purchaser,
182     address indexed beneficiary,
183     uint256 value,
184     uint256 amount
185   );
186 
187   /**
188    * @param _rate Number of token units a buyer gets per wei
189    * @param _wallet Address where collected funds will be forwarded to
190    * @param _token Address of the token being sold
191    */
192   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
193     require(_rate > 0);
194     require(_wallet != address(0));
195     require(_token != address(0));
196 
197     rate = _rate;
198     wallet = _wallet;
199     token = _token;
200   }
201 
202   // -----------------------------------------
203   // Crowdsale external interface
204   // -----------------------------------------
205 
206   /**
207    * @dev fallback function ***DO NOT OVERRIDE***
208    */
209   function () external payable {
210     buyTokens(msg.sender);
211   }
212 
213   /**
214    * @dev low level token purchase ***DO NOT OVERRIDE***
215    * @param _beneficiary Address performing the token purchase
216    */
217   function buyTokens(address _beneficiary) public payable {
218 
219     uint256 weiAmount = msg.value;
220     _preValidatePurchase(_beneficiary, weiAmount);
221 
222     // calculate token amount to be created
223     uint256 tokens = _getTokenAmount(weiAmount);
224 
225     // update state
226     weiRaised = weiRaised.add(weiAmount);
227 
228     _processPurchase(_beneficiary, tokens);
229     emit TokenPurchase(
230       msg.sender,
231       _beneficiary,
232       weiAmount,
233       tokens
234     );
235 
236     _updatePurchasingState(_beneficiary, weiAmount);
237 
238     _forwardFunds();
239     _postValidatePurchase(_beneficiary, weiAmount);
240   }
241 
242   // -----------------------------------------
243   // Internal interface (extensible)
244   // -----------------------------------------
245 
246   /**
247    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
248    * @param _beneficiary Address performing the token purchase
249    * @param _weiAmount Value in wei involved in the purchase
250    */
251   function _preValidatePurchase(
252     address _beneficiary,
253     uint256 _weiAmount
254   )
255     internal
256   {
257     require(_beneficiary != address(0));
258     require(_weiAmount != 0);
259   }
260 
261   /**
262    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
263    * @param _beneficiary Address performing the token purchase
264    * @param _weiAmount Value in wei involved in the purchase
265    */
266   function _postValidatePurchase(
267     address _beneficiary,
268     uint256 _weiAmount
269   )
270     internal
271   {
272     // optional override
273   }
274 
275   /**
276    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
277    * @param _beneficiary Address performing the token purchase
278    * @param _tokenAmount Number of tokens to be emitted
279    */
280   function _deliverTokens(
281     address _beneficiary,
282     uint256 _tokenAmount
283   )
284     internal
285   {
286     token.transfer(_beneficiary, _tokenAmount);
287   }
288 
289   /**
290    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
291    * @param _beneficiary Address receiving the tokens
292    * @param _tokenAmount Number of tokens to be purchased
293    */
294   function _processPurchase(
295     address _beneficiary,
296     uint256 _tokenAmount
297   )
298     internal
299   {
300     _deliverTokens(_beneficiary, _tokenAmount);
301   }
302 
303   /**
304    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
305    * @param _beneficiary Address receiving the tokens
306    * @param _weiAmount Value in wei involved in the purchase
307    */
308   function _updatePurchasingState(
309     address _beneficiary,
310     uint256 _weiAmount
311   )
312     internal
313   {
314     // optional override
315   }
316 
317   /**
318    * @dev Override to extend the way in which ether is converted to tokens.
319    * @param _weiAmount Value in wei to be converted into tokens
320    * @return Number of tokens that can be purchased with the specified _weiAmount
321    */
322   function _getTokenAmount(uint256 _weiAmount)
323     internal view returns (uint256)
324   {
325     return _weiAmount.mul(rate);
326   }
327 
328   /**
329    * @dev Determines how ETH is stored/forwarded on purchases.
330    */
331   function _forwardFunds() internal {
332     wallet.transfer(msg.value);
333   }
334 }
335 
336 /**
337  * @title TimedCrowdsale
338  * @dev Crowdsale accepting contributions only within a time frame.
339  */
340 contract TimedCrowdsale is Crowdsale {
341   using SafeMath for uint256;
342 
343   uint256 public openingTime;
344   uint256 public closingTime;
345 
346   /**
347    * @dev Reverts if not in crowdsale time range.
348    */
349   modifier onlyWhileOpen {
350     // solium-disable-next-line security/no-block-members
351     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
352     _;
353   }
354 
355   /**
356    * @dev Constructor, takes crowdsale opening and closing times.
357    * @param _openingTime Crowdsale opening time
358    * @param _closingTime Crowdsale closing time
359    */
360   constructor(uint256 _openingTime, uint256 _closingTime) public {
361     // solium-disable-next-line security/no-block-members
362     require(_openingTime >= block.timestamp);
363     require(_closingTime >= _openingTime);
364 
365     openingTime = _openingTime;
366     closingTime = _closingTime;
367   }
368 
369   /**
370    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
371    * @return Whether crowdsale period has elapsed
372    */
373   function hasClosed() public view returns (bool) {
374     // solium-disable-next-line security/no-block-members
375     return block.timestamp > closingTime;
376   }
377 
378   /**
379    * @dev Extend parent behavior requiring to be within contributing period
380    * @param _beneficiary Token purchaser
381    * @param _weiAmount Amount of wei contributed
382    */
383   function _preValidatePurchase(
384     address _beneficiary,
385     uint256 _weiAmount
386   )
387     internal
388     onlyWhileOpen
389   {
390     super._preValidatePurchase(_beneficiary, _weiAmount);
391   }
392 
393 }
394 
395 /**
396  * @title FinalizableCrowdsale
397  * @dev Extension of Crowdsale where an owner can do extra work
398  * after finishing.
399  */
400 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
401   using SafeMath for uint256;
402 
403   bool public isFinalized = false;
404 
405   event Finalized();
406 
407   /**
408    * @dev Must be called after crowdsale ends, to do some extra finalization
409    * work. Calls the contract's finalization function.
410    */
411   function finalize() onlyOwner public {
412     require(!isFinalized);
413     require(hasClosed());
414 
415     finalization();
416     emit Finalized();
417 
418     isFinalized = true;
419   }
420 
421   /**
422    * @dev Can be overridden to add finalization logic. The overriding function
423    * should call super.finalization() to ensure the chain of finalization is
424    * executed entirely.
425    */
426   function finalization() internal {
427   }
428 
429 }
430 
431 /**
432  * @title CappedCrowdsale
433  * @dev Crowdsale with a limit for total contributions.
434  */
435 contract CappedCrowdsale is Crowdsale {
436   using SafeMath for uint256;
437 
438   uint256 public cap;
439 
440   /**
441    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
442    * @param _cap Max amount of wei to be contributed
443    */
444   constructor(uint256 _cap) public {
445     require(_cap > 0);
446     cap = _cap;
447   }
448 
449   /**
450    * @dev Checks whether the cap has been reached.
451    * @return Whether the cap was reached
452    */
453   function capReached() public view returns (bool) {
454     return weiRaised >= cap;
455   }
456 
457   /**
458    * @dev Extend parent behavior requiring purchase to respect the funding cap.
459    * @param _beneficiary Token purchaser
460    * @param _weiAmount Amount of wei contributed
461    */
462   function _preValidatePurchase(
463     address _beneficiary,
464     uint256 _weiAmount
465   )
466     internal
467   {
468     super._preValidatePurchase(_beneficiary, _weiAmount);
469     require(weiRaised.add(_weiAmount) <= cap);
470   }
471 
472 }
473 
474 /**
475  * @title Roles
476  * @author Francisco Giordano (@frangio)
477  * @dev Library for managing addresses assigned to a Role.
478  *      See RBAC.sol for example usage.
479  */
480 library Roles {
481   struct Role {
482     mapping (address => bool) bearer;
483   }
484 
485   /**
486    * @dev give an address access to this role
487    */
488   function add(Role storage role, address addr)
489     internal
490   {
491     role.bearer[addr] = true;
492   }
493 
494   /**
495    * @dev remove an address' access to this role
496    */
497   function remove(Role storage role, address addr)
498     internal
499   {
500     role.bearer[addr] = false;
501   }
502 
503   /**
504    * @dev check if an address has this role
505    * // reverts
506    */
507   function check(Role storage role, address addr)
508     view
509     internal
510   {
511     require(has(role, addr));
512   }
513 
514   /**
515    * @dev check if an address has this role
516    * @return bool
517    */
518   function has(Role storage role, address addr)
519     view
520     internal
521     returns (bool)
522   {
523     return role.bearer[addr];
524   }
525 }
526 
527 /**
528  * @title RBAC (Role-Based Access Control)
529  * @author Matt Condon (@Shrugs)
530  * @dev Stores and provides setters and getters for roles and addresses.
531  * @dev Supports unlimited numbers of roles and addresses.
532  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
533  * This RBAC method uses strings to key roles. It may be beneficial
534  *  for you to write your own implementation of this interface using Enums or similar.
535  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
536  *  to avoid typos.
537  */
538 contract RBAC {
539   using Roles for Roles.Role;
540 
541   mapping (string => Roles.Role) private roles;
542 
543   event RoleAdded(address addr, string roleName);
544   event RoleRemoved(address addr, string roleName);
545 
546   /**
547    * @dev reverts if addr does not have role
548    * @param addr address
549    * @param roleName the name of the role
550    * // reverts
551    */
552   function checkRole(address addr, string roleName)
553     view
554     public
555   {
556     roles[roleName].check(addr);
557   }
558 
559   /**
560    * @dev determine if addr has role
561    * @param addr address
562    * @param roleName the name of the role
563    * @return bool
564    */
565   function hasRole(address addr, string roleName)
566     view
567     public
568     returns (bool)
569   {
570     return roles[roleName].has(addr);
571   }
572 
573   /**
574    * @dev add a role to an address
575    * @param addr address
576    * @param roleName the name of the role
577    */
578   function addRole(address addr, string roleName)
579     internal
580   {
581     roles[roleName].add(addr);
582     emit RoleAdded(addr, roleName);
583   }
584 
585   /**
586    * @dev remove a role from an address
587    * @param addr address
588    * @param roleName the name of the role
589    */
590   function removeRole(address addr, string roleName)
591     internal
592   {
593     roles[roleName].remove(addr);
594     emit RoleRemoved(addr, roleName);
595   }
596 
597   /**
598    * @dev modifier to scope access to a single role (uses msg.sender as addr)
599    * @param roleName the name of the role
600    * // reverts
601    */
602   modifier onlyRole(string roleName)
603   {
604     checkRole(msg.sender, roleName);
605     _;
606   }
607 
608   /**
609    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
610    * @param roleNames the names of the roles to scope access to
611    * // reverts
612    *
613    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
614    *  see: https://github.com/ethereum/solidity/issues/2467
615    */
616   // modifier onlyRoles(string[] roleNames) {
617   //     bool hasAnyRole = false;
618   //     for (uint8 i = 0; i < roleNames.length; i++) {
619   //         if (hasRole(msg.sender, roleNames[i])) {
620   //             hasAnyRole = true;
621   //             break;
622   //         }
623   //     }
624 
625   //     require(hasAnyRole);
626 
627   //     _;
628   // }
629 }
630 
631 /**
632  * @title Whitelist
633  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
634  * @dev This simplifies the implementation of "user permissions".
635  */
636 contract Whitelist is Ownable, RBAC {
637   event WhitelistedAddressAdded(address addr);
638   event WhitelistedAddressRemoved(address addr);
639 
640   string public constant ROLE_WHITELISTED = "whitelist";
641 
642   /**
643    * @dev Throws if called by any account that's not whitelisted.
644    */
645   modifier onlyWhitelisted() {
646     checkRole(msg.sender, ROLE_WHITELISTED);
647     _;
648   }
649 
650   /**
651    * @dev add an address to the whitelist
652    * @param addr address
653    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
654    */
655   function addAddressToWhitelist(address addr)
656     onlyOwner
657     public
658   {
659     addRole(addr, ROLE_WHITELISTED);
660     emit WhitelistedAddressAdded(addr);
661   }
662 
663   /**
664    * @dev getter to determine if address is in whitelist
665    */
666   function whitelist(address addr)
667     public
668     view
669     returns (bool)
670   {
671     return hasRole(addr, ROLE_WHITELISTED);
672   }
673 
674   /**
675    * @dev add addresses to the whitelist
676    * @param addrs addresses
677    * @return true if at least one address was added to the whitelist,
678    * false if all addresses were already in the whitelist
679    */
680   function addAddressesToWhitelist(address[] addrs)
681     onlyOwner
682     public
683   {
684     for (uint256 i = 0; i < addrs.length; i++) {
685       addAddressToWhitelist(addrs[i]);
686     }
687   }
688 
689   /**
690    * @dev remove an address from the whitelist
691    * @param addr address
692    * @return true if the address was removed from the whitelist,
693    * false if the address wasn't in the whitelist in the first place
694    */
695   function removeAddressFromWhitelist(address addr)
696     onlyOwner
697     public
698   {
699     removeRole(addr, ROLE_WHITELISTED);
700     emit WhitelistedAddressRemoved(addr);
701   }
702 
703   /**
704    * @dev remove addresses from the whitelist
705    * @param addrs addresses
706    * @return true if at least one address was removed from the whitelist,
707    * false if all addresses weren't in the whitelist in the first place
708    */
709   function removeAddressesFromWhitelist(address[] addrs)
710     onlyOwner
711     public
712   {
713     for (uint256 i = 0; i < addrs.length; i++) {
714       removeAddressFromWhitelist(addrs[i]);
715     }
716   }
717 
718 }
719 
720 /**
721  * @title SafeERC20
722  * @dev Wrappers around ERC20 operations that throw on failure.
723  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
724  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
725  */
726 library SafeERC20 {
727   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
728     require(token.transfer(to, value));
729   }
730 
731   function safeTransferFrom(
732     ERC20 token,
733     address from,
734     address to,
735     uint256 value
736   )
737     internal
738   {
739     require(token.transferFrom(from, to, value));
740   }
741 
742   function safeApprove(ERC20 token, address spender, uint256 value) internal {
743     require(token.approve(spender, value));
744   }
745 }
746 
747 /**
748  * @title Contracts that should be able to recover tokens
749  * @author SylTi
750  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
751  * This will prevent any accidental loss of tokens.
752  */
753 contract CanReclaimToken is Ownable {
754   using SafeERC20 for ERC20Basic;
755 
756   /**
757    * @dev Reclaim all ERC20Basic compatible tokens
758    * @param token ERC20Basic The address of the token contract
759    */
760   function reclaimToken(ERC20Basic token) external onlyOwner {
761     uint256 balance = token.balanceOf(this);
762     token.safeTransfer(owner, balance);
763   }
764 
765 }
766 
767 /**
768  * @title Pausable
769  * @dev Base contract which allows children to implement an emergency stop mechanism.
770  */
771 contract Pausable is Ownable {
772   event Pause();
773   event Unpause();
774 
775   bool public paused = false;
776 
777 
778   /**
779    * @dev Modifier to make a function callable only when the contract is not paused.
780    */
781   modifier whenNotPaused() {
782     require(!paused);
783     _;
784   }
785 
786   /**
787    * @dev Modifier to make a function callable only when the contract is paused.
788    */
789   modifier whenPaused() {
790     require(paused);
791     _;
792   }
793 
794   /**
795    * @dev called by the owner to pause, triggers stopped state
796    */
797   function pause() onlyOwner whenNotPaused public {
798     paused = true;
799     emit Pause();
800   }
801 
802   /**
803    * @dev called by the owner to unpause, returns to normal state
804    */
805   function unpause() onlyOwner whenPaused public {
806     paused = false;
807     emit Unpause();
808   }
809 }
810 
811 contract BonusHolder is Pausable {
812   using SafeMath for uint256;
813   uint public withdrawTime;
814   ERC20 public token;
815 
816   mapping(address => uint) public bonus;
817 
818 
819   modifier afterClose() {
820     if(now < withdrawTime) {
821       revert();
822     } else {
823       _;
824     }
825   }
826 
827 
828   constructor(ERC20 _token, uint _withdrawTime) {
829     require(_withdrawTime > 0);
830     require(_withdrawTime > now);
831     withdrawTime = _withdrawTime;
832     token = _token;
833   }
834 
835   function addBonus(address beneficiary, uint tokenAmount) internal {
836     bonus[beneficiary] = bonus[beneficiary].add(tokenAmount);
837   }
838 
839 
840   function withdrawToken() public afterClose whenNotPaused {
841     require(bonus[msg.sender] > 0);
842     uint tokenAmount = bonus[msg.sender];
843     bonus[msg.sender] = 0;
844     token.transfer(msg.sender, tokenAmount);
845   }
846 
847 }
848 
849 contract SeedRound is CappedCrowdsale, FinalizableCrowdsale, Whitelist, Pausable, CanReclaimToken, BonusHolder {
850 
851   uint public minContribution;
852   uint public bonusRate;
853 
854   constructor(uint256 _openingTime, uint256 _closingTime, uint _minContribution,uint256 _bonusRate, uint256 _rate, uint256 _cap, address _wallet, ERC20 _token, uint _bonusWithdrawTime)
855   CappedCrowdsale(_cap) TimedCrowdsale(_openingTime, _closingTime) Crowdsale(_rate, _wallet, _token) BonusHolder(_token, _bonusWithdrawTime) {
856     require(_minContribution > 0);
857     require(_bonusRate > 0);
858     minContribution = _minContribution;
859     bonusRate = _bonusRate;
860     super.addAddressToWhitelist(msg.sender);
861   }
862 
863   function _forwardFunds() internal {
864 
865   }
866 
867   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
868     require(_weiAmount >= minContribution);
869     super._preValidatePurchase(_beneficiary, _weiAmount);
870   }
871 
872   function changeMinContribution(uint _minContribution) public onlyWhitelisted whenNotPaused {
873     require(_minContribution > 0);
874     minContribution = _minContribution;
875   }
876 
877   function changeBonusRate(uint _bonusRate) public onlyWhitelisted whenNotPaused {
878     require(_bonusRate > 0);
879     bonusRate = _bonusRate;
880   }
881 
882   function withdrawFunds(uint amount) public onlyWhitelisted whenNotPaused {
883     require(address(this).balance >= amount);
884     msg.sender.transfer(amount);
885   }
886 
887   function changeTokenRate(uint _rate) public onlyWhitelisted whenNotPaused {
888     require(_rate > 0);
889     rate = _rate;
890   }
891 
892   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
893     uint bonusTokens = _tokenAmount.mul(bonusRate).div(100);
894     super.addBonus(_beneficiary, bonusTokens);
895     super._deliverTokens(_beneficiary, _tokenAmount);
896   }
897 
898   function finalization() internal {
899     token.transfer(msg.sender, token.balanceOf(this));
900   }
901 }