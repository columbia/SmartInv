1 pragma solidity ^0.4.24;
2 
3 // File: contracts/MintableERC20.sol
4 
5 interface MintableERC20 {
6 
7     function mint(address _to, uint256 _value) public;
8 }
9 
10 // File: openzeppelin-solidity/contracts/AddressUtils.sol
11 
12 /**
13  * Utility library of inline functions on addresses
14  */
15 library AddressUtils {
16 
17   /**
18    * Returns whether the target address is a contract
19    * @dev This function will return false if invoked during the constructor of a contract,
20    * as the code is not actually created until after the constructor finishes.
21    * @param addr address to check
22    * @return whether the target address is a contract
23    */
24   function isContract(address addr) internal view returns (bool) {
25     uint256 size;
26     // XXX Currently there is no better way to check if there is a contract in an address
27     // than to check the size of the code at that address.
28     // See https://ethereum.stackexchange.com/a/14016/36603
29     // for more details about how this works.
30     // TODO Check this again before the Serenity release, because all addresses will be
31     // contracts then.
32     // solium-disable-next-line security/no-inline-assembly
33     assembly { size := extcodesize(addr) }
34     return size > 0;
35   }
36 
37 }
38 
39 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
40 
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization control
44  * functions, this simplifies the implementation of "user permissions".
45  */
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipRenounced(address indexed previousOwner);
51   event OwnershipTransferred(
52     address indexed previousOwner,
53     address indexed newOwner
54   );
55 
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   constructor() public {
62     owner = msg.sender;
63   }
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73   /**
74    * @dev Allows the current owner to relinquish control of the contract.
75    * @notice Renouncing to ownership will leave the contract without an owner.
76    * It will not be possible to call the functions with the `onlyOwner`
77    * modifier anymore.
78    */
79   function renounceOwnership() public onlyOwner {
80     emit OwnershipRenounced(owner);
81     owner = address(0);
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address _newOwner) public onlyOwner {
89     _transferOwnership(_newOwner);
90   }
91 
92   /**
93    * @dev Transfers control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function _transferOwnership(address _newOwner) internal {
97     require(_newOwner != address(0));
98     emit OwnershipTransferred(owner, _newOwner);
99     owner = _newOwner;
100   }
101 }
102 
103 // File: openzeppelin-solidity/contracts/ownership/rbac/Roles.sol
104 
105 /**
106  * @title Roles
107  * @author Francisco Giordano (@frangio)
108  * @dev Library for managing addresses assigned to a Role.
109  * See RBAC.sol for example usage.
110  */
111 library Roles {
112   struct Role {
113     mapping (address => bool) bearer;
114   }
115 
116   /**
117    * @dev give an address access to this role
118    */
119   function add(Role storage role, address addr)
120     internal
121   {
122     role.bearer[addr] = true;
123   }
124 
125   /**
126    * @dev remove an address' access to this role
127    */
128   function remove(Role storage role, address addr)
129     internal
130   {
131     role.bearer[addr] = false;
132   }
133 
134   /**
135    * @dev check if an address has this role
136    * // reverts
137    */
138   function check(Role storage role, address addr)
139     view
140     internal
141   {
142     require(has(role, addr));
143   }
144 
145   /**
146    * @dev check if an address has this role
147    * @return bool
148    */
149   function has(Role storage role, address addr)
150     view
151     internal
152     returns (bool)
153   {
154     return role.bearer[addr];
155   }
156 }
157 
158 // File: openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol
159 
160 /**
161  * @title RBAC (Role-Based Access Control)
162  * @author Matt Condon (@Shrugs)
163  * @dev Stores and provides setters and getters for roles and addresses.
164  * Supports unlimited numbers of roles and addresses.
165  * See //contracts/mocks/RBACMock.sol for an example of usage.
166  * This RBAC method uses strings to key roles. It may be beneficial
167  * for you to write your own implementation of this interface using Enums or similar.
168  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
169  * to avoid typos.
170  */
171 contract RBAC {
172   using Roles for Roles.Role;
173 
174   mapping (string => Roles.Role) private roles;
175 
176   event RoleAdded(address indexed operator, string role);
177   event RoleRemoved(address indexed operator, string role);
178 
179   /**
180    * @dev reverts if addr does not have role
181    * @param _operator address
182    * @param _role the name of the role
183    * // reverts
184    */
185   function checkRole(address _operator, string _role)
186     view
187     public
188   {
189     roles[_role].check(_operator);
190   }
191 
192   /**
193    * @dev determine if addr has role
194    * @param _operator address
195    * @param _role the name of the role
196    * @return bool
197    */
198   function hasRole(address _operator, string _role)
199     view
200     public
201     returns (bool)
202   {
203     return roles[_role].has(_operator);
204   }
205 
206   /**
207    * @dev add a role to an address
208    * @param _operator address
209    * @param _role the name of the role
210    */
211   function addRole(address _operator, string _role)
212     internal
213   {
214     roles[_role].add(_operator);
215     emit RoleAdded(_operator, _role);
216   }
217 
218   /**
219    * @dev remove a role from an address
220    * @param _operator address
221    * @param _role the name of the role
222    */
223   function removeRole(address _operator, string _role)
224     internal
225   {
226     roles[_role].remove(_operator);
227     emit RoleRemoved(_operator, _role);
228   }
229 
230   /**
231    * @dev modifier to scope access to a single role (uses msg.sender as addr)
232    * @param _role the name of the role
233    * // reverts
234    */
235   modifier onlyRole(string _role)
236   {
237     checkRole(msg.sender, _role);
238     _;
239   }
240 
241   /**
242    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
243    * @param _roles the names of the roles to scope access to
244    * // reverts
245    *
246    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
247    *  see: https://github.com/ethereum/solidity/issues/2467
248    */
249   // modifier onlyRoles(string[] _roles) {
250   //     bool hasAnyRole = false;
251   //     for (uint8 i = 0; i < _roles.length; i++) {
252   //         if (hasRole(msg.sender, _roles[i])) {
253   //             hasAnyRole = true;
254   //             break;
255   //         }
256   //     }
257 
258   //     require(hasAnyRole);
259 
260   //     _;
261   // }
262 }
263 
264 // File: openzeppelin-solidity/contracts/access/Whitelist.sol
265 
266 /**
267  * @title Whitelist
268  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
269  * This simplifies the implementation of "user permissions".
270  */
271 contract Whitelist is Ownable, RBAC {
272   string public constant ROLE_WHITELISTED = "whitelist";
273 
274   /**
275    * @dev Throws if operator is not whitelisted.
276    * @param _operator address
277    */
278   modifier onlyIfWhitelisted(address _operator) {
279     checkRole(_operator, ROLE_WHITELISTED);
280     _;
281   }
282 
283   /**
284    * @dev add an address to the whitelist
285    * @param _operator address
286    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
287    */
288   function addAddressToWhitelist(address _operator)
289     onlyOwner
290     public
291   {
292     addRole(_operator, ROLE_WHITELISTED);
293   }
294 
295   /**
296    * @dev getter to determine if address is in whitelist
297    */
298   function whitelist(address _operator)
299     public
300     view
301     returns (bool)
302   {
303     return hasRole(_operator, ROLE_WHITELISTED);
304   }
305 
306   /**
307    * @dev add addresses to the whitelist
308    * @param _operators addresses
309    * @return true if at least one address was added to the whitelist,
310    * false if all addresses were already in the whitelist
311    */
312   function addAddressesToWhitelist(address[] _operators)
313     onlyOwner
314     public
315   {
316     for (uint256 i = 0; i < _operators.length; i++) {
317       addAddressToWhitelist(_operators[i]);
318     }
319   }
320 
321   /**
322    * @dev remove an address from the whitelist
323    * @param _operator address
324    * @return true if the address was removed from the whitelist,
325    * false if the address wasn't in the whitelist in the first place
326    */
327   function removeAddressFromWhitelist(address _operator)
328     onlyOwner
329     public
330   {
331     removeRole(_operator, ROLE_WHITELISTED);
332   }
333 
334   /**
335    * @dev remove addresses from the whitelist
336    * @param _operators addresses
337    * @return true if at least one address was removed from the whitelist,
338    * false if all addresses weren't in the whitelist in the first place
339    */
340   function removeAddressesFromWhitelist(address[] _operators)
341     onlyOwner
342     public
343   {
344     for (uint256 i = 0; i < _operators.length; i++) {
345       removeAddressFromWhitelist(_operators[i]);
346     }
347   }
348 
349 }
350 
351 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
352 
353 /**
354  * @title Pausable
355  * @dev Base contract which allows children to implement an emergency stop mechanism.
356  */
357 contract Pausable is Ownable {
358   event Pause();
359   event Unpause();
360 
361   bool public paused = false;
362 
363 
364   /**
365    * @dev Modifier to make a function callable only when the contract is not paused.
366    */
367   modifier whenNotPaused() {
368     require(!paused);
369     _;
370   }
371 
372   /**
373    * @dev Modifier to make a function callable only when the contract is paused.
374    */
375   modifier whenPaused() {
376     require(paused);
377     _;
378   }
379 
380   /**
381    * @dev called by the owner to pause, triggers stopped state
382    */
383   function pause() onlyOwner whenNotPaused public {
384     paused = true;
385     emit Pause();
386   }
387 
388   /**
389    * @dev called by the owner to unpause, returns to normal state
390    */
391   function unpause() onlyOwner whenPaused public {
392     paused = false;
393     emit Unpause();
394   }
395 }
396 
397 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
398 
399 /**
400  * @title SafeMath
401  * @dev Math operations with safety checks that throw on error
402  */
403 library SafeMath {
404 
405   /**
406   * @dev Multiplies two numbers, throws on overflow.
407   */
408   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
409     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
410     // benefit is lost if 'b' is also tested.
411     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
412     if (a == 0) {
413       return 0;
414     }
415 
416     c = a * b;
417     assert(c / a == b);
418     return c;
419   }
420 
421   /**
422   * @dev Integer division of two numbers, truncating the quotient.
423   */
424   function div(uint256 a, uint256 b) internal pure returns (uint256) {
425     // assert(b > 0); // Solidity automatically throws when dividing by 0
426     // uint256 c = a / b;
427     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
428     return a / b;
429   }
430 
431   /**
432   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
433   */
434   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
435     assert(b <= a);
436     return a - b;
437   }
438 
439   /**
440   * @dev Adds two numbers, throws on overflow.
441   */
442   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
443     c = a + b;
444     assert(c >= a);
445     return c;
446   }
447 }
448 
449 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
450 
451 /**
452  * @title ERC20Basic
453  * @dev Simpler version of ERC20 interface
454  * See https://github.com/ethereum/EIPs/issues/179
455  */
456 contract ERC20Basic {
457   function totalSupply() public view returns (uint256);
458   function balanceOf(address who) public view returns (uint256);
459   function transfer(address to, uint256 value) public returns (bool);
460   event Transfer(address indexed from, address indexed to, uint256 value);
461 }
462 
463 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
464 
465 /**
466  * @title ERC20 interface
467  * @dev see https://github.com/ethereum/EIPs/issues/20
468  */
469 contract ERC20 is ERC20Basic {
470   function allowance(address owner, address spender)
471     public view returns (uint256);
472 
473   function transferFrom(address from, address to, uint256 value)
474     public returns (bool);
475 
476   function approve(address spender, uint256 value) public returns (bool);
477   event Approval(
478     address indexed owner,
479     address indexed spender,
480     uint256 value
481   );
482 }
483 
484 // File: contracts/FanCrowdsale.sol
485 
486 contract FanCrowdsale is Pausable {
487   using SafeMath for uint256;
488   using AddressUtils for address;
489 
490   // helper with wei
491   uint256 constant COIN = 1 ether;
492 
493   // token
494   MintableERC20 public mintableToken;
495 
496   // wallet to hold funds
497   address public wallet;
498 
499   Whitelist public whitelist;
500 
501   // Stage
502   // ============
503   struct Stage {
504     uint tokenAllocated;
505     uint rate;
506   }
507 
508   uint8 public currentStage;
509   mapping (uint8 => Stage) public stages;
510   uint8 public totalStages; //stages count
511 
512   // Amount raised
513   // ==================
514   uint256 public totalTokensSold;
515   uint256 public totalWeiRaised;
516 
517   // timed
518   // ======
519   uint256 public openingTime;
520   uint256 public closingTime;
521 
522   /**
523    * @dev Reverts if not in crowdsale time range.
524    */
525   modifier onlyWhileOpen {
526     require(block.timestamp >= openingTime && !hasClosed());
527     _;
528   }
529 
530   // Token Cap
531   // =============================
532   uint256 public totalTokensForSale; // = 424000000 * COIN; // tokens be sold in Crowdsale
533 
534   // Finalize
535   // =============================
536   bool public isFinalized = false;
537 
538 
539   // Constructor
540   // ============
541   /**
542    * @dev constructor
543    * @param _token token contract address
544    * @param _startTime start time of crowdscale
545    * @param _endTime end time of crowdsale
546    * @param _wallet foundation/multi-sig wallet to store raised eth
547    * @param _cap max eth to raise in wei
548    */
549   constructor(
550     address _token,
551     uint256 _startTime,
552     uint256 _endTime,
553     address _wallet,
554     uint256 _cap) public
555   {
556     require(_wallet != address(0), "need a good wallet to store fund");
557     require(_token != address(0), "token is not deployed?");
558     // require(_startTime > block.timestamp, "startTime must be in future");
559     require(_endTime > _startTime, "endTime must be greater than startTime");
560 
561     // make sure this crowdsale contract has ability to mint or make sure token's mint authority has me
562     // yet fan token contract doesn't expose a public check func must manually make sure crowdsale contract address is added to authorities of token contract
563     mintableToken  = MintableERC20(_token);
564     wallet = _wallet;
565 
566     openingTime = _startTime;
567     closingTime = _endTime;
568 
569     totalTokensForSale  = _cap;
570 
571     _initStages();
572     _setCrowdsaleStage(0);
573 
574     // require that the sum of the stages is equal to the totalTokensForSale, _cap is for double check
575     require(stages[totalStages - 1].tokenAllocated == totalTokensForSale);
576     
577   }
578   // =============
579 
580   // fallback
581   function () external payable {
582     purchase(msg.sender);
583   }
584 
585   function purchase(address _buyer) public payable whenNotPaused onlyWhileOpen {
586     contribute(_buyer, msg.value);
587   }
588   
589   // Token Purchase
590   // =========================
591 
592   /**
593    * @dev crowdsale must be open and we do not accept contribution sent from contract
594    * because we credit tokens back it might trigger problem, eg, from exchange withdraw contract
595    */
596   function contribute(address _buyer, uint256 _weiAmount) internal {
597     require(_buyer != address(0));
598     require(!_buyer.isContract());
599     require(whitelist.whitelist(_buyer));
600 
601     if (_weiAmount == 0) {
602       return;
603     }
604 
605     // double check not to over sell
606     require(totalTokensSold < totalTokensForSale);
607 
608     uint currentRate = stages[currentStage].rate;
609     uint256 tokensToMint = _weiAmount.mul(currentRate);
610 
611     // refund excess
612     uint256 saleableTokens;
613     uint256 acceptedWei;
614     if (currentStage == (totalStages - 1) && totalTokensSold.add(tokensToMint) > totalTokensForSale) {
615       saleableTokens = totalTokensForSale - totalTokensSold;
616       acceptedWei = saleableTokens.div(currentRate);
617 
618       _buyTokensInCurrentStage(_buyer, acceptedWei, saleableTokens);
619 
620       // return the excess
621       uint256 weiToRefund = _weiAmount.sub(acceptedWei);
622       _buyer.transfer(weiToRefund);
623       emit EthRefunded(_buyer, weiToRefund);
624     } else if (totalTokensSold.add(tokensToMint) < stages[currentStage].tokenAllocated) {
625       _buyTokensInCurrentStage(_buyer, _weiAmount, tokensToMint);
626     } else {
627       // cross stage yet within cap
628       saleableTokens = stages[currentStage].tokenAllocated.sub(totalTokensSold);
629       acceptedWei = saleableTokens.div(currentRate);
630 
631       // buy first stage partial
632       _buyTokensInCurrentStage(_buyer, acceptedWei, saleableTokens);
633 
634       // update stage
635       if (totalTokensSold >= stages[currentStage].tokenAllocated && currentStage + 1 < totalStages) {
636         _setCrowdsaleStage(currentStage + 1);
637       }
638 
639       // buy next stage for the rest
640       if ( _weiAmount.sub(acceptedWei) > 0)
641       {
642         contribute(_buyer, _weiAmount.sub(acceptedWei));
643       }
644     }
645   }
646 
647   function changeWhitelist(address _newWhitelist) public onlyOwner {
648     require(_newWhitelist != address(0));
649     emit WhitelistTransferred(whitelist, _newWhitelist);
650     whitelist = Whitelist(_newWhitelist);
651   }
652 
653   /**
654    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
655    * @return Whether crowdsale period has elapsed
656    */
657   function hasClosed() public view returns (bool) {
658     // solium-disable-next-line security/no-block-members
659     return block.timestamp > closingTime || totalTokensSold >= totalTokensForSale;
660   }
661 
662   /**
663    * @dev extend closing time to a future time
664    */
665   function extendClosingTime(uint256 _extendToTime) public onlyOwner onlyWhileOpen {
666     closingTime = _extendToTime;
667   }
668 
669   // ===========================
670 
671   // Finalize Crowdsale
672   // ====================================================================
673 
674   function finalize() public onlyOwner {
675     require(!isFinalized);
676     require(hasClosed());
677 
678     emit Finalized();
679 
680     isFinalized = true;
681   }
682 
683 
684   // -----------------------------------------
685   // Internal interface (extensible)
686   // -----------------------------------------
687 
688   // Crowdsale Stage Management
689   // =========================================================
690   // Change Crowdsale Stage. Available Options: 0..4
691   function _setCrowdsaleStage(uint8 _stageId) internal {
692     require(_stageId >= 0 && _stageId < totalStages);
693 
694     currentStage = _stageId;
695 
696     emit StageUp(_stageId);
697   }
698 
699   function _initStages() internal {
700     // production setting
701     stages[0] = Stage(25000000 * COIN, 12500);
702     stages[1] = Stage(stages[0].tokenAllocated + 46000000 * COIN, 11500);
703     stages[2] = Stage(stages[1].tokenAllocated + 88000000 * COIN, 11000);
704     stages[3] = Stage(stages[2].tokenAllocated + 105000000 * COIN, 10500);
705     stages[4] = Stage(stages[3].tokenAllocated + 160000000 * COIN, 10000);
706 
707     // development setting
708     // 0.1 ETH allocation per stage for faster forward test
709     // stages[0] = Stage(1250 * COIN,                            12500);    // 1 Ether(wei) = 12500 Coin(wei)
710     // stages[1] = Stage(stages[0].tokenAllocated + 1150 * COIN, 11500);
711     // stages[2] = Stage(stages[1].tokenAllocated + 1100 * COIN, 11000);
712     // stages[3] = Stage(stages[2].tokenAllocated + 1050 * COIN, 10500);
713     // stages[4] = Stage(stages[3].tokenAllocated + 1000 * COIN, 10000);
714 
715     totalStages = 5;
716   }
717 
718   /**
719    * @dev perform buyTokens action for buyer
720    * @param _buyer Address performing the token purchase
721    * @param _weiAmount Value in wei involved in the purchase
722    */
723   function _buyTokensInCurrentStage(address _buyer, uint _weiAmount, uint _tokenAmount) internal {
724     totalWeiRaised = totalWeiRaised.add(_weiAmount);
725     totalTokensSold = totalTokensSold.add(_tokenAmount);
726 
727     // mint tokens to buyer's account
728     mintableToken.mint(_buyer, _tokenAmount);
729     wallet.transfer(_weiAmount);
730 
731     emit TokenPurchase(_buyer, _weiAmount, _tokenAmount);
732   }
733 
734 
735 //////////
736 // Safety Methods
737 //////////
738 
739     /// @notice This method can be used by the controller to extract mistakenly
740     ///  sent tokens to this contract.
741     /// @param _token The address of the token contract that you want to recover
742     ///  set to 0 in case you want to extract ether.
743   function claimTokens(address _token) onlyOwner public {
744       if (_token == 0x0) {
745           owner.transfer(address(this).balance);
746           return;
747       }
748 
749       ERC20 token = ERC20(_token);
750       uint balance = token.balanceOf(this);
751       token.transfer(owner, balance);
752 
753       emit ClaimedTokens(_token, owner, balance);
754   }
755 
756 ////////////////
757 // Events
758 ////////////////
759   event StageUp(uint8 stageId);
760 
761   event EthRefunded(address indexed buyer, uint256 value);
762 
763   event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
764 
765   event WhitelistTransferred(address indexed previousWhitelist, address indexed newWhitelist);
766 
767   event ClaimedTokens(address indexed _token, address indexed _to, uint _amount);
768 
769   event Finalized();
770 
771   // debug log event
772   event DLog(uint num, string msg);
773 }