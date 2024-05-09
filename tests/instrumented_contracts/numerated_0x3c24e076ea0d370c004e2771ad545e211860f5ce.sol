1 pragma solidity 0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: contracts/MultiOwnable.sol
80 
81 /**
82  * @title MultiOwnable.sol
83  * @dev Provide multi-ownable functionality to a smart contract.
84  * @dev Note this contract preserves the idea of a master owner where this owner
85  * cannot be removed or deleted. Master owner's are the only owner's who can add
86  * and remove other owner's. Transfer of master ownership is supported and can 
87  * also only be transferred by the current master owner
88  * @dev When master ownership is transferred the original master owner is not
89  * removed from the additional owners list
90  */
91 pragma solidity 0.4.25;
92 
93 /**
94  * @dev OpenZeppelin Solidity v2.0.0 imports (Using: npm openzeppelin-solidity@2.0.0)
95  */
96 
97 
98 contract MultiOwnable is Ownable {
99 	/**
100 	 * @dev Mapping of additional addresses that are considered owners
101 	 */
102 	mapping (address => bool) additionalOwners;
103 
104 	/**
105 	 * @dev Modifier that overrides 'Ownable' to support multiple owners
106 	 */
107 	modifier onlyOwner() {
108 		// Ensure that msg.sender is an owner or revert
109 		require(isOwner(msg.sender), "Permission denied [owner].");
110 		_;
111 	}
112 
113 	/**
114 	 * @dev Modifier that provides additional testing to ensure msg.sender
115 	 * is master owner, or first address to deploy contract
116 	 */
117 	modifier onlyMaster() {
118 		// Ensure that msg.sender is the master user
119 		require(super.isOwner(), "Permission denied [master].");
120 		_;
121 	}
122 
123 	/**
124 	 * @dev Ownership added event for Dapps interested in this event
125 	 */
126 	event OwnershipAdded (
127 		address indexed addedOwner
128 	);
129 	
130 	/**
131 	 * @dev Ownership removed event for Dapps interested in this event
132 	 */
133 	event OwnershipRemoved (
134 		address indexed removedOwner
135 	);
136 
137   	/**
138 	 * @dev MultiOwnable .cTor responsible for initialising the masterOwner
139 	 * or contract super-user
140 	 * @dev The super user cannot be deleted from the ownership mapping and
141 	 * can only be transferred
142 	 */
143 	constructor() 
144 	Ownable()
145 	public
146 	{
147 		// Obtain owner of the contract (msg.sender)
148 		address masterOwner = owner();
149 		// Add the master owner to the additional owners list
150 		additionalOwners[masterOwner] = true;
151 	}
152 
153 	/**
154 	 * @dev Returns the owner status of the specified address
155 	 */
156 	function isOwner(address _ownerAddressToLookup)
157 	public
158 	view
159 	returns (bool)
160 	{
161 		// Return the ownership state of the specified owner address
162 		return additionalOwners[_ownerAddressToLookup];
163 	}
164 
165 	/**
166 	 * @dev Returns the master status of the specfied address
167 	 */
168 	function isMaster(address _masterAddressToLookup)
169 	public
170 	view
171 	returns (bool)
172 	{
173 		return (super.owner() == _masterAddressToLookup);
174 	}
175 
176 	/**
177 	 * @dev Add a new owner address to additional owners mapping
178 	 * @dev Only the master owner can add additional owner addresses
179 	 */
180 	function addOwner(address _ownerToAdd)
181 	onlyMaster
182 	public
183 	returns (bool)
184 	{
185 		// Ensure the new owner address is not address(0)
186 		require(_ownerToAdd != address(0), "Invalid address specified (0x0)");
187 		// Ensure that new owner address is not already in the owners list
188 		require(!isOwner(_ownerToAdd), "Address specified already in owners list.");
189 		// Add new owner to additional owners mapping
190 		additionalOwners[_ownerToAdd] = true;
191 		emit OwnershipAdded(_ownerToAdd);
192 		return true;
193 	}
194 
195 	/**
196 	 * @dev Add a new owner address to additional owners mapping
197 	 * @dev Only the master owner can add additional owner addresses
198 	 */
199 	function removeOwner(address _ownerToRemove)
200 	onlyMaster
201 	public
202 	returns (bool)
203 	{
204 		// Ensure that the address to remove is not the master owner
205 		require(_ownerToRemove != super.owner(), "Permission denied [master].");
206 		// Ensure that owner address to remove is actually an owner
207 		require(isOwner(_ownerToRemove), "Address specified not found in owners list.");
208 		// Add remove ownership from address in the additional owners mapping
209 		additionalOwners[_ownerToRemove] = false;
210 		emit OwnershipRemoved(_ownerToRemove);
211 		return true;
212 	}
213 
214 	/**
215 	 * @dev Transfer ownership of this contract to another address
216 	 * @dev Only the master owner can transfer ownership to another address
217 	 * @dev Only existing owners can have ownership transferred to them
218 	 */
219 	function transferOwnership(address _newOwnership) 
220 	onlyMaster 
221 	public 
222 	{
223 		// Ensure the new ownership is not address(0)
224 		require(_newOwnership != address(0), "Invalid address specified (0x0)");
225 		// Ensure the new ownership address is not the current ownership addressess
226 		require(_newOwnership != owner(), "Address specified must not match current owner address.");		
227 		// Ensure that the new ownership is promoted from existing owners
228 		require(isOwner(_newOwnership), "Master ownership can only be transferred to an existing owner address.");
229 		// Call into the parent class and transfer ownership
230 		super.transferOwnership(_newOwnership);
231 		// If we get here, then add the new ownership address to the additional owners mapping
232 		// Note that the original master owner address was not removed and is still an owner until removed
233 		additionalOwners[_newOwnership] = true;
234 	}
235 
236 }
237 
238 // File: openzeppelin-solidity/contracts/access/Roles.sol
239 
240 /**
241  * @title Roles
242  * @dev Library for managing addresses assigned to a Role.
243  */
244 library Roles {
245   struct Role {
246     mapping (address => bool) bearer;
247   }
248 
249   /**
250    * @dev give an account access to this role
251    */
252   function add(Role storage role, address account) internal {
253     require(account != address(0));
254     require(!has(role, account));
255 
256     role.bearer[account] = true;
257   }
258 
259   /**
260    * @dev remove an account's access to this role
261    */
262   function remove(Role storage role, address account) internal {
263     require(account != address(0));
264     require(has(role, account));
265 
266     role.bearer[account] = false;
267   }
268 
269   /**
270    * @dev check if an account has this role
271    * @return bool
272    */
273   function has(Role storage role, address account)
274     internal
275     view
276     returns (bool)
277   {
278     require(account != address(0));
279     return role.bearer[account];
280   }
281 }
282 
283 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
284 
285 contract PauserRole {
286   using Roles for Roles.Role;
287 
288   event PauserAdded(address indexed account);
289   event PauserRemoved(address indexed account);
290 
291   Roles.Role private pausers;
292 
293   constructor() internal {
294     _addPauser(msg.sender);
295   }
296 
297   modifier onlyPauser() {
298     require(isPauser(msg.sender));
299     _;
300   }
301 
302   function isPauser(address account) public view returns (bool) {
303     return pausers.has(account);
304   }
305 
306   function addPauser(address account) public onlyPauser {
307     _addPauser(account);
308   }
309 
310   function renouncePauser() public {
311     _removePauser(msg.sender);
312   }
313 
314   function _addPauser(address account) internal {
315     pausers.add(account);
316     emit PauserAdded(account);
317   }
318 
319   function _removePauser(address account) internal {
320     pausers.remove(account);
321     emit PauserRemoved(account);
322   }
323 }
324 
325 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
326 
327 /**
328  * @title Pausable
329  * @dev Base contract which allows children to implement an emergency stop mechanism.
330  */
331 contract Pausable is PauserRole {
332   event Paused(address account);
333   event Unpaused(address account);
334 
335   bool private _paused;
336 
337   constructor() internal {
338     _paused = false;
339   }
340 
341   /**
342    * @return true if the contract is paused, false otherwise.
343    */
344   function paused() public view returns(bool) {
345     return _paused;
346   }
347 
348   /**
349    * @dev Modifier to make a function callable only when the contract is not paused.
350    */
351   modifier whenNotPaused() {
352     require(!_paused);
353     _;
354   }
355 
356   /**
357    * @dev Modifier to make a function callable only when the contract is paused.
358    */
359   modifier whenPaused() {
360     require(_paused);
361     _;
362   }
363 
364   /**
365    * @dev called by the owner to pause, triggers stopped state
366    */
367   function pause() public onlyPauser whenNotPaused {
368     _paused = true;
369     emit Paused(msg.sender);
370   }
371 
372   /**
373    * @dev called by the owner to unpause, returns to normal state
374    */
375   function unpause() public onlyPauser whenPaused {
376     _paused = false;
377     emit Unpaused(msg.sender);
378   }
379 }
380 
381 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
382 
383 /**
384  * @title ERC20 interface
385  * @dev see https://github.com/ethereum/EIPs/issues/20
386  */
387 interface IERC20 {
388   function totalSupply() external view returns (uint256);
389 
390   function balanceOf(address who) external view returns (uint256);
391 
392   function allowance(address owner, address spender)
393     external view returns (uint256);
394 
395   function transfer(address to, uint256 value) external returns (bool);
396 
397   function approve(address spender, uint256 value)
398     external returns (bool);
399 
400   function transferFrom(address from, address to, uint256 value)
401     external returns (bool);
402 
403   event Transfer(
404     address indexed from,
405     address indexed to,
406     uint256 value
407   );
408 
409   event Approval(
410     address indexed owner,
411     address indexed spender,
412     uint256 value
413   );
414 }
415 
416 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
417 
418 /**
419  * @title SafeMath
420  * @dev Math operations with safety checks that revert on error
421  */
422 library SafeMath {
423 
424   /**
425   * @dev Multiplies two numbers, reverts on overflow.
426   */
427   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
428     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
429     // benefit is lost if 'b' is also tested.
430     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
431     if (a == 0) {
432       return 0;
433     }
434 
435     uint256 c = a * b;
436     require(c / a == b);
437 
438     return c;
439   }
440 
441   /**
442   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
443   */
444   function div(uint256 a, uint256 b) internal pure returns (uint256) {
445     require(b > 0); // Solidity only automatically asserts when dividing by 0
446     uint256 c = a / b;
447     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
448 
449     return c;
450   }
451 
452   /**
453   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
454   */
455   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
456     require(b <= a);
457     uint256 c = a - b;
458 
459     return c;
460   }
461 
462   /**
463   * @dev Adds two numbers, reverts on overflow.
464   */
465   function add(uint256 a, uint256 b) internal pure returns (uint256) {
466     uint256 c = a + b;
467     require(c >= a);
468 
469     return c;
470   }
471 
472   /**
473   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
474   * reverts when dividing by zero.
475   */
476   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
477     require(b != 0);
478     return a % b;
479   }
480 }
481 
482 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
483 
484 /**
485  * @title Standard ERC20 token
486  *
487  * @dev Implementation of the basic standard token.
488  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
489  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
490  */
491 contract ERC20 is IERC20 {
492   using SafeMath for uint256;
493 
494   mapping (address => uint256) private _balances;
495 
496   mapping (address => mapping (address => uint256)) private _allowed;
497 
498   uint256 private _totalSupply;
499 
500   /**
501   * @dev Total number of tokens in existence
502   */
503   function totalSupply() public view returns (uint256) {
504     return _totalSupply;
505   }
506 
507   /**
508   * @dev Gets the balance of the specified address.
509   * @param owner The address to query the balance of.
510   * @return An uint256 representing the amount owned by the passed address.
511   */
512   function balanceOf(address owner) public view returns (uint256) {
513     return _balances[owner];
514   }
515 
516   /**
517    * @dev Function to check the amount of tokens that an owner allowed to a spender.
518    * @param owner address The address which owns the funds.
519    * @param spender address The address which will spend the funds.
520    * @return A uint256 specifying the amount of tokens still available for the spender.
521    */
522   function allowance(
523     address owner,
524     address spender
525    )
526     public
527     view
528     returns (uint256)
529   {
530     return _allowed[owner][spender];
531   }
532 
533   /**
534   * @dev Transfer token for a specified address
535   * @param to The address to transfer to.
536   * @param value The amount to be transferred.
537   */
538   function transfer(address to, uint256 value) public returns (bool) {
539     _transfer(msg.sender, to, value);
540     return true;
541   }
542 
543   /**
544    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
545    * Beware that changing an allowance with this method brings the risk that someone may use both the old
546    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
547    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
548    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
549    * @param spender The address which will spend the funds.
550    * @param value The amount of tokens to be spent.
551    */
552   function approve(address spender, uint256 value) public returns (bool) {
553     require(spender != address(0));
554 
555     _allowed[msg.sender][spender] = value;
556     emit Approval(msg.sender, spender, value);
557     return true;
558   }
559 
560   /**
561    * @dev Transfer tokens from one address to another
562    * @param from address The address which you want to send tokens from
563    * @param to address The address which you want to transfer to
564    * @param value uint256 the amount of tokens to be transferred
565    */
566   function transferFrom(
567     address from,
568     address to,
569     uint256 value
570   )
571     public
572     returns (bool)
573   {
574     require(value <= _allowed[from][msg.sender]);
575 
576     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
577     _transfer(from, to, value);
578     return true;
579   }
580 
581   /**
582    * @dev Increase the amount of tokens that an owner allowed to a spender.
583    * approve should be called when allowed_[_spender] == 0. To increment
584    * allowed value is better to use this function to avoid 2 calls (and wait until
585    * the first transaction is mined)
586    * From MonolithDAO Token.sol
587    * @param spender The address which will spend the funds.
588    * @param addedValue The amount of tokens to increase the allowance by.
589    */
590   function increaseAllowance(
591     address spender,
592     uint256 addedValue
593   )
594     public
595     returns (bool)
596   {
597     require(spender != address(0));
598 
599     _allowed[msg.sender][spender] = (
600       _allowed[msg.sender][spender].add(addedValue));
601     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
602     return true;
603   }
604 
605   /**
606    * @dev Decrease the amount of tokens that an owner allowed to a spender.
607    * approve should be called when allowed_[_spender] == 0. To decrement
608    * allowed value is better to use this function to avoid 2 calls (and wait until
609    * the first transaction is mined)
610    * From MonolithDAO Token.sol
611    * @param spender The address which will spend the funds.
612    * @param subtractedValue The amount of tokens to decrease the allowance by.
613    */
614   function decreaseAllowance(
615     address spender,
616     uint256 subtractedValue
617   )
618     public
619     returns (bool)
620   {
621     require(spender != address(0));
622 
623     _allowed[msg.sender][spender] = (
624       _allowed[msg.sender][spender].sub(subtractedValue));
625     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
626     return true;
627   }
628 
629   /**
630   * @dev Transfer token for a specified addresses
631   * @param from The address to transfer from.
632   * @param to The address to transfer to.
633   * @param value The amount to be transferred.
634   */
635   function _transfer(address from, address to, uint256 value) internal {
636     require(value <= _balances[from]);
637     require(to != address(0));
638 
639     _balances[from] = _balances[from].sub(value);
640     _balances[to] = _balances[to].add(value);
641     emit Transfer(from, to, value);
642   }
643 
644   /**
645    * @dev Internal function that mints an amount of the token and assigns it to
646    * an account. This encapsulates the modification of balances such that the
647    * proper events are emitted.
648    * @param account The account that will receive the created tokens.
649    * @param value The amount that will be created.
650    */
651   function _mint(address account, uint256 value) internal {
652     require(account != 0);
653     _totalSupply = _totalSupply.add(value);
654     _balances[account] = _balances[account].add(value);
655     emit Transfer(address(0), account, value);
656   }
657 
658   /**
659    * @dev Internal function that burns an amount of the token of a given
660    * account.
661    * @param account The account whose tokens will be burnt.
662    * @param value The amount that will be burnt.
663    */
664   function _burn(address account, uint256 value) internal {
665     require(account != 0);
666     require(value <= _balances[account]);
667 
668     _totalSupply = _totalSupply.sub(value);
669     _balances[account] = _balances[account].sub(value);
670     emit Transfer(account, address(0), value);
671   }
672 
673   /**
674    * @dev Internal function that burns an amount of the token of a given
675    * account, deducting from the sender's allowance for said account. Uses the
676    * internal burn function.
677    * @param account The account whose tokens will be burnt.
678    * @param value The amount that will be burnt.
679    */
680   function _burnFrom(address account, uint256 value) internal {
681     require(value <= _allowed[account][msg.sender]);
682 
683     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
684     // this function needs to emit an event with the updated approval.
685     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
686       value);
687     _burn(account, value);
688   }
689 }
690 
691 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
692 
693 /**
694  * @title SafeERC20
695  * @dev Wrappers around ERC20 operations that throw on failure.
696  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
697  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
698  */
699 library SafeERC20 {
700 
701   using SafeMath for uint256;
702 
703   function safeTransfer(
704     IERC20 token,
705     address to,
706     uint256 value
707   )
708     internal
709   {
710     require(token.transfer(to, value));
711   }
712 
713   function safeTransferFrom(
714     IERC20 token,
715     address from,
716     address to,
717     uint256 value
718   )
719     internal
720   {
721     require(token.transferFrom(from, to, value));
722   }
723 
724   function safeApprove(
725     IERC20 token,
726     address spender,
727     uint256 value
728   )
729     internal
730   {
731     // safeApprove should only be called when setting an initial allowance, 
732     // or when resetting it to zero. To increase and decrease it, use 
733     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
734     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
735     require(token.approve(spender, value));
736   }
737 
738   function safeIncreaseAllowance(
739     IERC20 token,
740     address spender,
741     uint256 value
742   )
743     internal
744   {
745     uint256 newAllowance = token.allowance(address(this), spender).add(value);
746     require(token.approve(spender, newAllowance));
747   }
748 
749   function safeDecreaseAllowance(
750     IERC20 token,
751     address spender,
752     uint256 value
753   )
754     internal
755   {
756     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
757     require(token.approve(spender, newAllowance));
758   }
759 }
760 
761 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
762 
763 /**
764  * @title Helps contracts guard against reentrancy attacks.
765  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
766  * @dev If you mark a function `nonReentrant`, you should also
767  * mark it `external`.
768  */
769 contract ReentrancyGuard {
770 
771   /// @dev counter to allow mutex lock with only one SSTORE operation
772   uint256 private _guardCounter;
773 
774   constructor() internal {
775     // The counter starts at one to prevent changing it from zero to a non-zero
776     // value, which is a more expensive operation.
777     _guardCounter = 1;
778   }
779 
780   /**
781    * @dev Prevents a contract from calling itself, directly or indirectly.
782    * Calling a `nonReentrant` function from another `nonReentrant`
783    * function is not supported. It is possible to prevent this from happening
784    * by making the `nonReentrant` function external, and make it call a
785    * `private` function that does the actual work.
786    */
787   modifier nonReentrant() {
788     _guardCounter += 1;
789     uint256 localCounter = _guardCounter;
790     _;
791     require(localCounter == _guardCounter);
792   }
793 
794 }
795 
796 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
797 
798 /**
799  * @title Crowdsale
800  * @dev Crowdsale is a base contract for managing a token crowdsale,
801  * allowing investors to purchase tokens with ether. This contract implements
802  * such functionality in its most fundamental form and can be extended to provide additional
803  * functionality and/or custom behavior.
804  * The external interface represents the basic interface for purchasing tokens, and conform
805  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
806  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
807  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
808  * behavior.
809  */
810 contract Crowdsale is ReentrancyGuard {
811   using SafeMath for uint256;
812   using SafeERC20 for IERC20;
813 
814   // The token being sold
815   IERC20 private _token;
816 
817   // Address where funds are collected
818   address private _wallet;
819 
820   // How many token units a buyer gets per wei.
821   // The rate is the conversion between wei and the smallest and indivisible token unit.
822   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
823   // 1 wei will give you 1 unit, or 0.001 TOK.
824   uint256 private _rate;
825 
826   // Amount of wei raised
827   uint256 private _weiRaised;
828 
829   /**
830    * Event for token purchase logging
831    * @param purchaser who paid for the tokens
832    * @param beneficiary who got the tokens
833    * @param value weis paid for purchase
834    * @param amount amount of tokens purchased
835    */
836   event TokensPurchased(
837     address indexed purchaser,
838     address indexed beneficiary,
839     uint256 value,
840     uint256 amount
841   );
842 
843   /**
844    * @param rate Number of token units a buyer gets per wei
845    * @dev The rate is the conversion between wei and the smallest and indivisible
846    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
847    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
848    * @param wallet Address where collected funds will be forwarded to
849    * @param token Address of the token being sold
850    */
851   constructor(uint256 rate, address wallet, IERC20 token) internal {
852     require(rate > 0);
853     require(wallet != address(0));
854     require(token != address(0));
855 
856     _rate = rate;
857     _wallet = wallet;
858     _token = token;
859   }
860 
861   // -----------------------------------------
862   // Crowdsale external interface
863   // -----------------------------------------
864 
865   /**
866    * @dev fallback function ***DO NOT OVERRIDE***
867    * Note that other contracts will transfer fund with a base gas stipend
868    * of 2300, which is not enough to call buyTokens. Consider calling
869    * buyTokens directly when purchasing tokens from a contract.
870    */
871   function () external payable {
872     buyTokens(msg.sender);
873   }
874 
875   /**
876    * @return the token being sold.
877    */
878   function token() public view returns(IERC20) {
879     return _token;
880   }
881 
882   /**
883    * @return the address where funds are collected.
884    */
885   function wallet() public view returns(address) {
886     return _wallet;
887   }
888 
889   /**
890    * @return the number of token units a buyer gets per wei.
891    */
892   function rate() public view returns(uint256) {
893     return _rate;
894   }
895 
896   /**
897    * @return the amount of wei raised.
898    */
899   function weiRaised() public view returns (uint256) {
900     return _weiRaised;
901   }
902 
903   /**
904    * @dev low level token purchase ***DO NOT OVERRIDE***
905    * This function has a non-reentrancy guard, so it shouldn't be called by
906    * another `nonReentrant` function.
907    * @param beneficiary Recipient of the token purchase
908    */
909   function buyTokens(address beneficiary) public nonReentrant payable {
910 
911     uint256 weiAmount = msg.value;
912     _preValidatePurchase(beneficiary, weiAmount);
913 
914     // calculate token amount to be created
915     uint256 tokens = _getTokenAmount(weiAmount);
916 
917     // update state
918     _weiRaised = _weiRaised.add(weiAmount);
919 
920     _processPurchase(beneficiary, tokens);
921     emit TokensPurchased(
922       msg.sender,
923       beneficiary,
924       weiAmount,
925       tokens
926     );
927 
928     _updatePurchasingState(beneficiary, weiAmount);
929 
930     _forwardFunds();
931     _postValidatePurchase(beneficiary, weiAmount);
932   }
933 
934   // -----------------------------------------
935   // Internal interface (extensible)
936   // -----------------------------------------
937 
938   /**
939    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
940    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
941    *   super._preValidatePurchase(beneficiary, weiAmount);
942    *   require(weiRaised().add(weiAmount) <= cap);
943    * @param beneficiary Address performing the token purchase
944    * @param weiAmount Value in wei involved in the purchase
945    */
946   function _preValidatePurchase(
947     address beneficiary,
948     uint256 weiAmount
949   )
950     internal
951     view
952   {
953     require(beneficiary != address(0));
954     require(weiAmount != 0);
955   }
956 
957   /**
958    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
959    * @param beneficiary Address performing the token purchase
960    * @param weiAmount Value in wei involved in the purchase
961    */
962   function _postValidatePurchase(
963     address beneficiary,
964     uint256 weiAmount
965   )
966     internal
967     view
968   {
969     // optional override
970   }
971 
972   /**
973    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
974    * @param beneficiary Address performing the token purchase
975    * @param tokenAmount Number of tokens to be emitted
976    */
977   function _deliverTokens(
978     address beneficiary,
979     uint256 tokenAmount
980   )
981     internal
982   {
983     _token.safeTransfer(beneficiary, tokenAmount);
984   }
985 
986   /**
987    * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
988    * @param beneficiary Address receiving the tokens
989    * @param tokenAmount Number of tokens to be purchased
990    */
991   function _processPurchase(
992     address beneficiary,
993     uint256 tokenAmount
994   )
995     internal
996   {
997     _deliverTokens(beneficiary, tokenAmount);
998   }
999 
1000   /**
1001    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
1002    * @param beneficiary Address receiving the tokens
1003    * @param weiAmount Value in wei involved in the purchase
1004    */
1005   function _updatePurchasingState(
1006     address beneficiary,
1007     uint256 weiAmount
1008   )
1009     internal
1010   {
1011     // optional override
1012   }
1013 
1014   /**
1015    * @dev Override to extend the way in which ether is converted to tokens.
1016    * @param weiAmount Value in wei to be converted into tokens
1017    * @return Number of tokens that can be purchased with the specified _weiAmount
1018    */
1019   function _getTokenAmount(uint256 weiAmount)
1020     internal view returns (uint256)
1021   {
1022     return weiAmount.mul(_rate);
1023   }
1024 
1025   /**
1026    * @dev Determines how ETH is stored/forwarded on purchases.
1027    */
1028   function _forwardFunds() internal {
1029     _wallet.transfer(msg.value);
1030   }
1031 }
1032 
1033 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
1034 
1035 /**
1036  * @title TimedCrowdsale
1037  * @dev Crowdsale accepting contributions only within a time frame.
1038  */
1039 contract TimedCrowdsale is Crowdsale {
1040   using SafeMath for uint256;
1041 
1042   uint256 private _openingTime;
1043   uint256 private _closingTime;
1044 
1045   /**
1046    * @dev Reverts if not in crowdsale time range.
1047    */
1048   modifier onlyWhileOpen {
1049     require(isOpen());
1050     _;
1051   }
1052 
1053   /**
1054    * @dev Constructor, takes crowdsale opening and closing times.
1055    * @param openingTime Crowdsale opening time
1056    * @param closingTime Crowdsale closing time
1057    */
1058   constructor(uint256 openingTime, uint256 closingTime) internal {
1059     // solium-disable-next-line security/no-block-members
1060     require(openingTime >= block.timestamp);
1061     require(closingTime > openingTime);
1062 
1063     _openingTime = openingTime;
1064     _closingTime = closingTime;
1065   }
1066 
1067   /**
1068    * @return the crowdsale opening time.
1069    */
1070   function openingTime() public view returns(uint256) {
1071     return _openingTime;
1072   }
1073 
1074   /**
1075    * @return the crowdsale closing time.
1076    */
1077   function closingTime() public view returns(uint256) {
1078     return _closingTime;
1079   }
1080 
1081   /**
1082    * @return true if the crowdsale is open, false otherwise.
1083    */
1084   function isOpen() public view returns (bool) {
1085     // solium-disable-next-line security/no-block-members
1086     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
1087   }
1088 
1089   /**
1090    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1091    * @return Whether crowdsale period has elapsed
1092    */
1093   function hasClosed() public view returns (bool) {
1094     // solium-disable-next-line security/no-block-members
1095     return block.timestamp > _closingTime;
1096   }
1097 
1098   /**
1099    * @dev Extend parent behavior requiring to be within contributing period
1100    * @param beneficiary Token purchaser
1101    * @param weiAmount Amount of wei contributed
1102    */
1103   function _preValidatePurchase(
1104     address beneficiary,
1105     uint256 weiAmount
1106   )
1107     internal
1108     onlyWhileOpen
1109     view
1110   {
1111     super._preValidatePurchase(beneficiary, weiAmount);
1112   }
1113 
1114 }
1115 
1116 // File: contracts/SparkleBaseCrowdsale.sol
1117 
1118 /**
1119  * @dev SparkelBaseCrowdsale: Core crowdsale functionality
1120  */
1121 contract SparkleBaseCrowdsale is MultiOwnable, Pausable, TimedCrowdsale {
1122 	using SafeMath for uint256;
1123 
1124 	/**
1125 	 * @dev CrowdsaleStage enumeration indicating which operational stage this contract is running
1126 	 */
1127 	enum CrowdsaleStage { 
1128 		preICO, 
1129 		bonusICO, 
1130 		mainICO
1131 	}
1132 
1133  	/**
1134  	 * @dev Internal contract variable stored
1135  	 */
1136 	ERC20   public tokenAddress;
1137 	uint256 public tokenRate;
1138 	uint256 public tokenCap;
1139 	uint256 public startTime;
1140 	uint256 public endTime;
1141 	address public depositWallet;
1142 	bool    public kycRequired;	
1143 	bool	public refundRemainingOk;
1144 
1145 	uint256 public tokensSold;
1146 
1147 	/**
1148 	 * @dev Contribution structure representing a token purchase 
1149 	 */
1150 	struct OrderBook {
1151 		uint256 weiAmount;   // Amount of Wei that has been contributed towards tokens by this address
1152 		uint256 pendingTokens; // Total pending tokens held by this address waiting for KYC verification, and user to claim their tokens(pending restrictions)
1153 		bool    kycVerified;   // Has this address been kyc validated
1154 	}
1155 
1156 	// Contributions mapping to user addresses
1157 	mapping(address => OrderBook) private orders;
1158 
1159 	// Initialize the crowdsale stage to preICO (this stage will change)
1160 	CrowdsaleStage public crowdsaleStage = CrowdsaleStage.preICO;
1161 
1162 	/**
1163 	 * @dev Event signaling that a number of addresses have been approved for KYC
1164 	 */
1165 	event ApprovedKYCAddresses (address indexed _appovedByAddress, uint256 _numberOfApprovals);
1166 
1167 	/**
1168 	 * @dev Event signaling that a number of addresses have been revoked from KYC
1169 	 */
1170 	event RevokedKYCAddresses (address indexed _revokedByAddress, uint256 _numberOfRevokals);
1171 
1172 	/**
1173 	 * @dev Event signalling that tokens have been claimed from the crowdsale
1174 	 */
1175 	event TokensClaimed (address indexed _claimingAddress, uint256 _tokensClaimed);
1176 
1177 	/**
1178 	 * @dev Event signaling that tokens were sold and how many were sold
1179 	 */
1180 	event TokensSold(address indexed _beneficiary, uint256 _tokensSold);
1181 
1182 	/**
1183 	 * @dev Event signaling that toke burn approval has been changed
1184 	 */
1185 	event TokenRefundApprovalChanged(address indexed _approvingAddress, bool tokenBurnApproved);
1186 
1187 	/**
1188 	 * @dev Event signaling that token burn approval has been changed
1189 	 */
1190 	event CrowdsaleStageChanged(address indexed _changingAddress, uint _newStageValue);
1191 
1192 	/**
1193 	 * @dev Event signaling that crowdsale tokens have been burned
1194 	 */
1195 	event CrowdsaleTokensRefunded(address indexed _refundingToAddress, uint256 _numberOfTokensBurned);
1196 
1197 	/**
1198 	 * @dev SparkleTokenCrowdsale Contract contructor
1199 	 */
1200 	constructor(ERC20 _tokenAddress, uint256 _tokenRate, uint256 _tokenCap, uint256 _startTime, uint256 _endTime, address _depositWallet, bool _kycRequired)
1201 	public
1202 	Crowdsale(_tokenRate, _depositWallet, _tokenAddress)
1203 	TimedCrowdsale(_startTime, _endTime)
1204 	MultiOwnable()
1205 	Pausable()
1206 	{ 
1207 		tokenAddress      = _tokenAddress;
1208 		tokenRate         = _tokenRate;
1209 		tokenCap          = _tokenCap;
1210 		startTime         = _startTime;
1211 		endTime           = _endTime;
1212 		depositWallet     = _depositWallet;
1213 		kycRequired       = _kycRequired;
1214 		refundRemainingOk = false;
1215 	}
1216 
1217 	/**
1218 	 * @dev claimPendingTokens() provides users with a function to receive their purchase tokens
1219 	 * after their KYC Verification
1220 	 */
1221 	function claimTokens()
1222 	whenNotPaused
1223 	onlyWhileOpen
1224 	public
1225 	{
1226 		// Ensure calling address is not address(0)
1227 		require(msg.sender != address(0), "Invalid address specified: address(0)");
1228 		// Obtain a copy of the caller's order record
1229 		OrderBook storage order = orders[msg.sender];
1230 		// Ensure caller has been KYC Verified
1231 		require(order.kycVerified, "Address attempting to claim tokens is not KYC Verified.");
1232 		// Ensure caller has pending tokens to claim
1233 		require(order.pendingTokens > 0, "Address does not have any pending tokens to claim.");
1234 		// For security sake grab the pending token value
1235 		uint256 localPendingTokens = order.pendingTokens;
1236 		// zero out pendingTokens to prevent potential re-entrancy vulnverability
1237 		order.pendingTokens = 0;
1238 		// Deliver the callers tokens
1239 		_deliverTokens(msg.sender, localPendingTokens);
1240 		// Emit event
1241 		emit TokensClaimed(msg.sender, localPendingTokens);
1242 	}
1243 
1244 	/**
1245 	 * @dev getExchangeRate() provides a public facing manner in which to 
1246 	 * determine the current rate of exchange in the crowdsale
1247 	 * @param _weiAmount is the amount of wei to purchase tokens with
1248 	 * @return number of tokens the specified wei amount would purchase
1249 	 */
1250 	function getExchangeRate(uint256 _weiAmount)
1251 	whenNotPaused
1252 	onlyWhileOpen
1253 	public
1254 	view
1255 	returns (uint256)
1256 	{
1257 		if (crowdsaleStage == CrowdsaleStage.preICO) {
1258 			// Ensure _weiAmount is > than current stage minimum
1259 			require(_weiAmount >= 1 ether, "PreICO minimum ether required: 1 ETH.");
1260 		}
1261 		else if (crowdsaleStage == CrowdsaleStage.bonusICO || crowdsaleStage == CrowdsaleStage.mainICO) {
1262 			// Ensure _weiAmount is > than current stage minimum
1263 			require(_weiAmount >= 500 finney, "bonusICO/mainICO minimum ether required: 0.5 ETH.");
1264 		}
1265 
1266 		// Calculate the number of tokens this amount of wei is worth
1267 		uint256 tokenAmount = _getTokenAmount(_weiAmount);
1268 		// Ensure the number of tokens requests will not exceed available tokens
1269 		require(getRemainingTokens() >= tokenAmount, "Specified wei value woudld exceed amount of tokens remaining.");
1270 		// Calculate and return the token amount this amount of wei is worth (includes bonus factor)
1271 		return tokenAmount;
1272 	}
1273 
1274 	/**
1275 	 * @dev getRemainingTokens() provides function to return the current remaining token count
1276 	 * @return number of tokens remaining in the crowdsale to be sold
1277 	 */
1278 	function getRemainingTokens()
1279 	whenNotPaused
1280 	public
1281 	view
1282 	returns (uint256)
1283 	{
1284 		// Return the balance of the contract (IE: tokenCap - tokensSold)
1285 		return tokenCap.sub(tokensSold);
1286 	}
1287 
1288 	/**
1289 	 * @dev refundRemainingTokens provides functionn to refund remaining tokens to the specified address
1290 	 * @param _addressToRefund is the address in which the remaining tokens will be refunded to
1291 	 */
1292 	function refundRemainingTokens(address _addressToRefund)
1293 	onlyOwner
1294 	whenNotPaused
1295 	public
1296 	{
1297 		// Ensure the specified address is not address(0)
1298 		require(_addressToRefund != address(0), "Specified address is invalid [0x0]");
1299 		// Ensure the crowdsale has closed before burning tokens
1300 		require(hasClosed(), "Crowdsale must be finished to burn tokens.");
1301 		// Ensure that step-1 of the burning process is satisfied (owner set to true)
1302 		require(refundRemainingOk, "Crowdsale remaining token refund is disabled.");
1303 		uint256 tempBalance = token().balanceOf(this);
1304 		// Transfer the remaining tokens to specified address
1305 		_deliverTokens(_addressToRefund, tempBalance);
1306 		// Emit event
1307 		emit CrowdsaleTokensRefunded(_addressToRefund, tempBalance);
1308 	}
1309 
1310 	/**
1311 	 * @dev approveRemainingTokenRefund approves the function to withdraw any remaining tokens
1312 	 * after the crowdsale ends
1313 	 * @dev This was put in place as a two-step process to burn tokens so burning was secure
1314 	 */
1315 	function approveRemainingTokenRefund()
1316 	onlyOwner
1317 	whenNotPaused
1318 	public
1319 	{
1320 		// Ensure calling address is not address(0)
1321 		require(msg.sender != address(0), "Calling address invalid [0x0]");
1322 		// Ensure the crowdsale has closed before approving token burning
1323 		require(hasClosed(), "Token burn approval can only be set after crowdsale closes");
1324 		refundRemainingOk = true;
1325 		emit TokenRefundApprovalChanged(msg.sender, refundRemainingOk);
1326 	}
1327 
1328 	/**
1329 	 * @dev setStage() sets the current crowdsale stage to the specified value
1330 	 * @param _newStageValue is the new stage to be changed to
1331 	 */
1332 	function changeCrowdsaleStage(uint _newStageValue)
1333 	onlyOwner
1334 	whenNotPaused
1335 	onlyWhileOpen
1336 	public
1337 	{
1338 		// Create temporary stage variable
1339 		CrowdsaleStage _stage;
1340 		// Determine if caller is trying to set: preICO
1341 		if (uint(CrowdsaleStage.preICO) == _newStageValue) {
1342 			// Set the internal stage to the new value
1343 			_stage = CrowdsaleStage.preICO;
1344 		}
1345 		// Determine if caller is trying to set: bonusICO
1346 		else if (uint(CrowdsaleStage.bonusICO) == _newStageValue) {
1347 			// Set the internal stage to the new value
1348 			_stage = CrowdsaleStage.bonusICO;
1349 		}
1350 		// Determine if caller is trying to set: mainICO
1351 		else if (uint(CrowdsaleStage.mainICO) == _newStageValue) {
1352 			// Set the internal stage to the new value
1353 			_stage = CrowdsaleStage.mainICO;
1354 		}
1355 		else {
1356 			revert("Invalid stage selected");
1357 		}
1358 
1359 		// Update the internal crowdsale stage to the new stage
1360 		crowdsaleStage = _stage;
1361 		// Emit event
1362 		emit CrowdsaleStageChanged(msg.sender, uint(_stage));
1363 	}
1364 
1365 	/**
1366 	 * @dev isAddressKYCVerified() checks the KYV Verification status of the specified address
1367 	 * @param _addressToLookuo address to check status of KYC Verification
1368 	 * @return kyc status of the specified address 
1369 	 */
1370 	function isKYCVerified(address _addressToLookuo) 
1371 	whenNotPaused
1372 	onlyWhileOpen
1373 	public
1374 	view
1375 	returns (bool)
1376 	{
1377 		// Ensure _addressToLookuo is not address(0)
1378 		require(_addressToLookuo != address(0), "Invalid address specified: address(0)");
1379 		// Obtain the addresses order record
1380 		OrderBook storage order = orders[_addressToLookuo];
1381 		// Return the JYC Verification status for the specified address
1382 		return order.kycVerified;
1383 	}
1384 
1385 	/**
1386 	 * @dev Approve in bulk the specified addfresses indicating they were KYC Verified
1387 	 * @param _addressesForApproval is a list of addresses that are to be KYC Verified
1388 	 */
1389 	function bulkApproveKYCAddresses(address[] _addressesForApproval) 
1390 	onlyOwner
1391 	whenNotPaused
1392 	onlyWhileOpen
1393 	public
1394 	{
1395 
1396 		// Ensure that there are any address(es) in the provided array
1397 		require(_addressesForApproval.length > 0, "Specified address array is empty");
1398 		// Interate through all addresses provided
1399 		for (uint i = 0; i <_addressesForApproval.length; i++) {
1400 			// Approve this address using the internal function
1401 			_approveKYCAddress(_addressesForApproval[i]);
1402 		}
1403 
1404 		// Emit event indicating address(es) have been approved for KYC Verification
1405 		emit ApprovedKYCAddresses(msg.sender, _addressesForApproval.length);
1406 	}
1407 
1408 	/**
1409 	 * @dev Revoke in bulk the specified addfresses indicating they were denied KYC Verified
1410 	 * @param _addressesToRevoke is a list of addresses that are to be KYC Verified
1411 	 */
1412 	function bulkRevokeKYCAddresses(address[] _addressesToRevoke) 
1413 	onlyOwner
1414 	whenNotPaused
1415 	onlyWhileOpen
1416 	public
1417 	{
1418 		// Ensure that there are any address(es) in the provided array
1419 		require(_addressesToRevoke.length > 0, "Specified address array is empty");
1420 		// Interate through all addresses provided
1421 		for (uint i = 0; i <_addressesToRevoke.length; i++) {
1422 			// Approve this address using the internal function
1423 			_revokeKYCAddress(_addressesToRevoke[i]);
1424 		}
1425 
1426 		// Emit event indicating address(es) have been revoked for KYC Verification
1427 		emit RevokedKYCAddresses(msg.sender, _addressesToRevoke.length);
1428 	}
1429 
1430 	/**
1431 	 * @dev tokensPending() provides owners the function to retrieve an addresses pending
1432 	 * token amount
1433 	 * @param _addressToLookup is the address to return the pending token value for
1434 	 * @return the number of pending tokens waiting to be claimed from specified address
1435 	 */
1436 	function tokensPending(address _addressToLookup)
1437 	onlyOwner
1438 	whenNotPaused
1439 	onlyWhileOpen
1440 	public
1441 	view
1442 	returns (uint256)
1443 	{
1444 		// Ensure specified address is not address(0)
1445 		require(_addressToLookup != address(0), "Specified address is invalid [0x0]");
1446 		// Obtain the order for specified address
1447 		OrderBook storage order = orders[_addressToLookup];
1448 		// Return the pendingTokens amount
1449 		return order.pendingTokens;
1450 	}
1451 
1452 	/**
1453 	 * @dev contributionAmount() provides owners the function to retrieve an addresses total
1454 	 * contribution amount in eth
1455 	 * @param _addressToLookup is the address to return the contribution amount value for
1456 	 * @return the number of ether contribured to the crowdsale by specified address
1457 	 */
1458 	function contributionAmount(address _addressToLookup)
1459 	onlyOwner
1460 	whenNotPaused
1461 	onlyWhileOpen
1462 	public
1463 	view
1464 	returns (uint256)
1465 	{
1466 		// Ensure specified address is not address(0)
1467 		require(_addressToLookup != address(0), "Specified address is Invalid [0x0]");
1468 		// Obtain the order for specified address
1469 		OrderBook storage order = orders[_addressToLookup];
1470 		// Return the contribution amount in wei
1471 		return order.weiAmount;
1472 	}
1473 
1474 	/**
1475 	 * @dev _approveKYCAddress provides the function to approve the specified address 
1476 	 * indicating KYC Verified
1477 	 * @param _addressToApprove of the user that is being verified
1478 	 */
1479 	function _approveKYCAddress(address _addressToApprove) 
1480 	onlyOwner
1481 	internal
1482 	{
1483 		// Ensure that _addressToApprove is not address(0)
1484 		require(_addressToApprove != address(0), "Invalid address specified: address(0)");
1485 		// Get this addesses contribution record
1486 		OrderBook storage order = orders[_addressToApprove];
1487 		// Set the contribution record to indicate address has been kyc verified
1488 		order.kycVerified = true;
1489 	}
1490 
1491 	/**
1492 	 * @dev _revokeKYCAddress() provides the function to revoke previously
1493 	 * granted KYC verification in cases of fraud or false/invalid KYC data
1494 	 * @param _addressToRevoke is the address to remove KYC verification from
1495 	 */
1496 	function _revokeKYCAddress(address _addressToRevoke)
1497 	onlyOwner
1498 	internal
1499 	{
1500 		// Ensure address is not address(0)
1501 		require(_addressToRevoke != address(0), "Invalid address specified: address(0)");
1502 		// Obtain a copy of this addresses contribution record
1503 		OrderBook storage order = orders[_addressToRevoke];
1504 		// Revoke this addresses KYC verification
1505 		order.kycVerified = false;
1506 	}
1507 
1508 	/**
1509 	 * @dev _rate() provides the function of calcualting the rate based on crowdsale stage
1510 	 * @param _weiAmount indicated the amount of ether intended to use for purchase
1511 	 * @return number of tokens worth based on specified Wei value
1512 	 */
1513 	function _rate(uint _weiAmount)
1514 	internal
1515 	view
1516 	returns (uint256)
1517 	{
1518 		require(_weiAmount > 0, "Specified wei amoount must be > 0");
1519 
1520 		// Determine if the current operation stage of the crowdsale is preICO
1521 		if (crowdsaleStage == CrowdsaleStage.preICO)
1522 		{
1523 			// Determine if the purchase is >= 21 ether
1524 			if (_weiAmount >= 21 ether) { // 20% bonus
1525 				return 480e8;
1526 			}
1527 			
1528 			// Determine if the purchase is >= 11 ether
1529 			if (_weiAmount >= 11 ether) { // 15% bonus
1530 				return 460e8;
1531 			}
1532 			
1533 			// Determine if the purchase is >= 5 ether
1534 			if (_weiAmount >= 5 ether) { // 10% bonus
1535 				return 440e8;
1536 			}
1537 
1538 		}
1539 		else
1540 		// Determine if the current operation stage of the crowdsale is bonusICO
1541 		if (crowdsaleStage == CrowdsaleStage.bonusICO)
1542 		{
1543 			// Determine if the purchase is >= 21 ether
1544 			if (_weiAmount >= 21 ether) { // 10% bonus
1545 				return 440e8;
1546 			}
1547 			else if (_weiAmount >= 11 ether) { // 7% bonus
1548 				return 428e8;
1549 			}
1550 			else
1551 			if (_weiAmount >= 5 ether) { // 5% bonus
1552 				return 420e8;
1553 			}
1554 
1555 		}
1556 
1557 		// Rate is either < bounus or is main sale so return base rate only
1558 		return rate();
1559 	}
1560 
1561 	/**
1562 	 * @dev Performs token to wei converstion calculations based on crowdsale specification
1563 	 * @param _weiAmount to spend
1564 	 * @return number of tokens purchasable for the specified _weiAmount at crowdsale stage rates
1565 	 */
1566 	function _getTokenAmount(uint256 _weiAmount)
1567 	whenNotPaused
1568 	internal
1569 	view
1570 	returns (uint256)
1571 	{
1572 		// Get the current rate set in the constructor and calculate token units per wei
1573 		uint256 currentRate = _rate(_weiAmount);
1574 		// Calculate the total number of tokens buyable at based rate (before adding bonus)
1575 		uint256 sparkleToBuy = currentRate.mul(_weiAmount).div(10e17);
1576 		// Return proposed token amount
1577 		return sparkleToBuy;
1578 	}
1579 
1580 	/**
1581 	 * @dev _preValidatePurchase provides the functionality of pre validating a potential purchase
1582 	 * @param _beneficiary is the address that is currently purchasing tokens
1583 	 * @param _weiAmount is the number of tokens this address is attempting to purchase
1584 	 */
1585 	function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) 
1586 	whenNotPaused
1587 	internal
1588 	view
1589 	{
1590 		// Call into the parent validation to ensure _beneficiary and _weiAmount are valid
1591 		super._preValidatePurchase(_beneficiary, _weiAmount);
1592 		// Calculate amount of tokens for the specified _weiAmount
1593 		uint256 requestedTokens = getExchangeRate(_weiAmount);
1594 		// Calculate the currently sold tokens
1595 		uint256 tempTotalTokensSold = tokensSold;
1596 		// Incrememt total tokens		
1597 		tempTotalTokensSold.add(requestedTokens);
1598 		// Ensure total max token cap is > tempTotalTokensSold
1599 		require(tempTotalTokensSold <= tokenCap, "Requested wei amount will exceed the max token cap and was not accepted.");
1600 		// Ensure that requested tokens will not go over the remaining token balance
1601 		require(requestedTokens <= getRemainingTokens(), "Requested tokens would exceed tokens available and was not accepted.");
1602 		// Obtain the order record for _beneficiary if one exists
1603 		OrderBook storage order = orders[_beneficiary];
1604 		// Ensure this address has been kyc validated
1605 		require(order.kycVerified, "Address attempting to purchase is not KYC Verified.");
1606 		// Update this addresses order to reflect the purchase and ether spent
1607 		order.weiAmount = order.weiAmount.add(_weiAmount);
1608 		order.pendingTokens = order.pendingTokens.add(requestedTokens);
1609 		// increment totalTokens sold
1610 		tokensSold = tokensSold.add(requestedTokens);
1611 		// Emit event
1612 		emit TokensSold(_beneficiary, requestedTokens);
1613 	}
1614 
1615 	/**
1616 	 * @dev _processPurchase() is overridden and will be called by OpenZep v2.0 internally
1617 	 * @param _beneficiary is the address that is currently purchasing tokens
1618 	 * @param _tokenAmount is the number of tokens this address is attempting to purchase
1619 	 */
1620 	function _processPurchase(address _beneficiary, uint256 _tokenAmount)
1621 	whenNotPaused
1622 	internal
1623 	{
1624 		// We do not call the base class _processPurchase() functions. This is needed here or the base
1625 		// classes function will be called.
1626 	}
1627 
1628 }
1629 
1630 
1631 // File: contracts/SparkleCrowdsale.sol
1632 
1633 contract SparkleCrowdsale is SparkleBaseCrowdsale {
1634 
1635   // Token contract address 
1636   address public initTokenAddress = 0x4b7aD3a56810032782Afce12d7d27122bDb96efF;
1637   // Crowdsale specification
1638   uint256 public initTokenRate     = 400e8;
1639   uint256 public initTokenCap      = 19698000e8;
1640   uint256 public initStartTime     = now;
1641   uint256 public initEndTime       = now + 12 weeks; // Set this accordingly as it cannot be changed
1642   address public initDepositWallet = 0x0926a84C83d7B88338588Dca2729b590D787FA34;
1643   bool public initKYCRequired      = true;
1644 
1645   constructor() 
1646 	SparkleBaseCrowdsale(ERC20(initTokenAddress), initTokenRate, initTokenCap, initStartTime, initEndTime, initDepositWallet, initKYCRequired)
1647 	public
1648 	{
1649 	}
1650 
1651 }