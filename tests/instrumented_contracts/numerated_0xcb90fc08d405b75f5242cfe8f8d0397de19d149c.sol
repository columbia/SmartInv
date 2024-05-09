1 pragma solidity ^0.5.0;
2 
3 
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 
32 /**
33  * @title Roles
34  * @dev Library for managing addresses assigned to a Role.
35  */
36 library Roles {
37     struct Role {
38         mapping (address => bool) bearer;
39     }
40 
41     /**
42      * @dev Give an account access to this role.
43      */
44     function add(Role storage role, address account) internal {
45         require(!has(role, account), "Roles: account already has role");
46         role.bearer[account] = true;
47     }
48 
49     /**
50      * @dev Remove an account's access to this role.
51      */
52     function remove(Role storage role, address account) internal {
53         require(has(role, account), "Roles: account does not have role");
54         role.bearer[account] = false;
55     }
56 
57     /**
58      * @dev Check if an account has this role.
59      * @return bool
60      */
61     function has(Role storage role, address account) internal view returns (bool) {
62         require(account != address(0), "Roles: account is the zero address");
63         return role.bearer[account];
64     }
65 }
66 
67 contract PauserRole is Context {
68     using Roles for Roles.Role;
69 
70     event PauserAdded(address indexed account);
71     event PauserRemoved(address indexed account);
72 
73     Roles.Role private _pausers;
74 
75     constructor () internal {
76         _addPauser(_msgSender());
77     }
78 
79     modifier onlyPauser() {
80         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
81         _;
82     }
83 
84     function isPauser(address account) public view returns (bool) {
85         return _pausers.has(account);
86     }
87 
88     function addPauser(address account) public onlyPauser {
89         _addPauser(account);
90     }
91 
92     function renouncePauser() public {
93         _removePauser(_msgSender());
94     }
95 
96     function _addPauser(address account) internal {
97         _pausers.add(account);
98         emit PauserAdded(account);
99     }
100 
101     function _removePauser(address account) internal {
102         _pausers.remove(account);
103         emit PauserRemoved(account);
104     }
105 }
106 
107 /**
108  * @dev Contract module which allows children to implement an emergency stop
109  * mechanism that can be triggered by an authorized account.
110  *
111  * This module is used through inheritance. It will make available the
112  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
113  * the functions of your contract. Note that they will not be pausable by
114  * simply including this module, only once the modifiers are put in place.
115  */
116 contract Pausable is Context, PauserRole {
117     /**
118      * @dev Emitted when the pause is triggered by a pauser (`account`).
119      */
120     event Paused(address account);
121 
122     /**
123      * @dev Emitted when the pause is lifted by a pauser (`account`).
124      */
125     event Unpaused(address account);
126 
127     bool private _paused;
128 
129     /**
130      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
131      * to the deployer.
132      */
133     constructor () internal {
134         _paused = false;
135     }
136 
137     /**
138      * @dev Returns true if the contract is paused, and false otherwise.
139      */
140     function paused() public view returns (bool) {
141         return _paused;
142     }
143 
144     /**
145      * @dev Modifier to make a function callable only when the contract is not paused.
146      */
147     modifier whenNotPaused() {
148         require(!_paused, "Pausable: paused");
149         _;
150     }
151 
152     /**
153      * @dev Modifier to make a function callable only when the contract is paused.
154      */
155     modifier whenPaused() {
156         require(_paused, "Pausable: not paused");
157         _;
158     }
159 
160     /**
161      * @dev Called by a pauser to pause, triggers stopped state.
162      */
163     function pause() public onlyPauser whenNotPaused {
164         _paused = true;
165         emit Paused(_msgSender());
166     }
167 
168     /**
169      * @dev Called by a pauser to unpause, returns to normal state.
170      */
171     function unpause() public onlyPauser whenPaused {
172         _paused = false;
173         emit Unpaused(_msgSender());
174     }
175 }
176 
177 
178 contract Killable {
179 	address payable public _owner;
180 
181 	constructor() internal {
182 		_owner = msg.sender;
183 	}
184 
185 	function kill() public {
186 		require(msg.sender == _owner, "only owner method");
187 		selfdestruct(_owner);
188 	}
189 }
190 
191 
192 
193 /**
194  * @dev Contract module which provides a basic access control mechanism, where
195  * there is an account (an owner) that can be granted exclusive access to
196  * specific functions.
197  *
198  * This module is used through inheritance. It will make available the modifier
199  * `onlyOwner`, which can be applied to your functions to restrict their use to
200  * the owner.
201  */
202 contract Ownable is Context {
203     address private _owner;
204 
205     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
206 
207     /**
208      * @dev Initializes the contract setting the deployer as the initial owner.
209      */
210     constructor () internal {
211         _owner = _msgSender();
212         emit OwnershipTransferred(address(0), _owner);
213     }
214 
215     /**
216      * @dev Returns the address of the current owner.
217      */
218     function owner() public view returns (address) {
219         return _owner;
220     }
221 
222     /**
223      * @dev Throws if called by any account other than the owner.
224      */
225     modifier onlyOwner() {
226         require(isOwner(), "Ownable: caller is not the owner");
227         _;
228     }
229 
230     /**
231      * @dev Returns true if the caller is the current owner.
232      */
233     function isOwner() public view returns (bool) {
234         return _msgSender() == _owner;
235     }
236 
237     /**
238      * @dev Leaves the contract without owner. It will not be possible to call
239      * `onlyOwner` functions anymore. Can only be called by the current owner.
240      *
241      * NOTE: Renouncing ownership will leave the contract without an owner,
242      * thereby removing any functionality that is only available to the owner.
243      */
244     function renounceOwnership() public onlyOwner {
245         emit OwnershipTransferred(_owner, address(0));
246         _owner = address(0);
247     }
248 
249     /**
250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
251      * Can only be called by the current owner.
252      */
253     function transferOwnership(address newOwner) public onlyOwner {
254         _transferOwnership(newOwner);
255     }
256 
257     /**
258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
259      */
260     function _transferOwnership(address newOwner) internal {
261         require(newOwner != address(0), "Ownable: new owner is the zero address");
262         emit OwnershipTransferred(_owner, newOwner);
263         _owner = newOwner;
264     }
265 }
266 
267 // prettier-ignore
268 
269 
270 
271 contract IGroup {
272 	function isGroup(address _addr) public view returns (bool);
273 
274 	function addGroup(address _addr) external;
275 
276 	function getGroupKey(address _addr) internal pure returns (bytes32) {
277 		return keccak256(abi.encodePacked("_group", _addr));
278 	}
279 }
280 
281 
282 contract AddressValidator {
283 	string constant errorMessage = "this is illegal address";
284 
285 	function validateIllegalAddress(address _addr) external pure {
286 		require(_addr != address(0), errorMessage);
287 	}
288 
289 	function validateGroup(address _addr, address _groupAddr) external view {
290 		require(IGroup(_groupAddr).isGroup(_addr), errorMessage);
291 	}
292 
293 	function validateGroups(
294 		address _addr,
295 		address _groupAddr1,
296 		address _groupAddr2
297 	) external view {
298 		if (IGroup(_groupAddr1).isGroup(_addr)) {
299 			return;
300 		}
301 		require(IGroup(_groupAddr2).isGroup(_addr), errorMessage);
302 	}
303 
304 	function validateAddress(address _addr, address _target) external pure {
305 		require(_addr == _target, errorMessage);
306 	}
307 
308 	function validateAddresses(
309 		address _addr,
310 		address _target1,
311 		address _target2
312 	) external pure {
313 		if (_addr == _target1) {
314 			return;
315 		}
316 		require(_addr == _target2, errorMessage);
317 	}
318 }
319 
320 
321 contract UsingValidator {
322 	AddressValidator private _validator;
323 
324 	constructor() public {
325 		_validator = new AddressValidator();
326 	}
327 
328 	function addressValidator() internal view returns (AddressValidator) {
329 		return _validator;
330 	}
331 }
332 
333 
334 contract AddressConfig is Ownable, UsingValidator, Killable {
335 	address public token = 0x98626E2C9231f03504273d55f397409deFD4a093;
336 	address public allocator;
337 	address public allocatorStorage;
338 	address public withdraw;
339 	address public withdrawStorage;
340 	address public marketFactory;
341 	address public marketGroup;
342 	address public propertyFactory;
343 	address public propertyGroup;
344 	address public metricsGroup;
345 	address public metricsFactory;
346 	address public policy;
347 	address public policyFactory;
348 	address public policySet;
349 	address public policyGroup;
350 	address public lockup;
351 	address public lockupStorage;
352 	address public voteTimes;
353 	address public voteTimesStorage;
354 	address public voteCounter;
355 	address public voteCounterStorage;
356 
357 	function setAllocator(address _addr) external onlyOwner {
358 		allocator = _addr;
359 	}
360 
361 	function setAllocatorStorage(address _addr) external onlyOwner {
362 		allocatorStorage = _addr;
363 	}
364 
365 	function setWithdraw(address _addr) external onlyOwner {
366 		withdraw = _addr;
367 	}
368 
369 	function setWithdrawStorage(address _addr) external onlyOwner {
370 		withdrawStorage = _addr;
371 	}
372 
373 	function setMarketFactory(address _addr) external onlyOwner {
374 		marketFactory = _addr;
375 	}
376 
377 	function setMarketGroup(address _addr) external onlyOwner {
378 		marketGroup = _addr;
379 	}
380 
381 	function setPropertyFactory(address _addr) external onlyOwner {
382 		propertyFactory = _addr;
383 	}
384 
385 	function setPropertyGroup(address _addr) external onlyOwner {
386 		propertyGroup = _addr;
387 	}
388 
389 	function setMetricsFactory(address _addr) external onlyOwner {
390 		metricsFactory = _addr;
391 	}
392 
393 	function setMetricsGroup(address _addr) external onlyOwner {
394 		metricsGroup = _addr;
395 	}
396 
397 	function setPolicyFactory(address _addr) external onlyOwner {
398 		policyFactory = _addr;
399 	}
400 
401 	function setPolicyGroup(address _addr) external onlyOwner {
402 		policyGroup = _addr;
403 	}
404 
405 	function setPolicySet(address _addr) external onlyOwner {
406 		policySet = _addr;
407 	}
408 
409 	function setPolicy(address _addr) external {
410 		addressValidator().validateAddress(msg.sender, policyFactory);
411 		policy = _addr;
412 	}
413 
414 	function setToken(address _addr) external onlyOwner {
415 		token = _addr;
416 	}
417 
418 	function setLockup(address _addr) external onlyOwner {
419 		lockup = _addr;
420 	}
421 
422 	function setLockupStorage(address _addr) external onlyOwner {
423 		lockupStorage = _addr;
424 	}
425 
426 	function setVoteTimes(address _addr) external onlyOwner {
427 		voteTimes = _addr;
428 	}
429 
430 	function setVoteTimesStorage(address _addr) external onlyOwner {
431 		voteTimesStorage = _addr;
432 	}
433 
434 	function setVoteCounter(address _addr) external onlyOwner {
435 		voteCounter = _addr;
436 	}
437 
438 	function setVoteCounterStorage(address _addr) external onlyOwner {
439 		voteCounterStorage = _addr;
440 	}
441 }
442 
443 
444 contract UsingConfig {
445 	AddressConfig private _config;
446 
447 	constructor(address _addressConfig) public {
448 		_config = AddressConfig(_addressConfig);
449 	}
450 
451 	function config() internal view returns (AddressConfig) {
452 		return _config;
453 	}
454 
455 	function configAddress() external view returns (address) {
456 		return address(_config);
457 	}
458 }
459 
460 
461 /**
462  * @dev Wrappers over Solidity's arithmetic operations with added overflow
463  * checks.
464  *
465  * Arithmetic operations in Solidity wrap on overflow. This can easily result
466  * in bugs, because programmers usually assume that an overflow raises an
467  * error, which is the standard behavior in high level programming languages.
468  * `SafeMath` restores this intuition by reverting the transaction when an
469  * operation overflows.
470  *
471  * Using this library instead of the unchecked operations eliminates an entire
472  * class of bugs, so it's recommended to use it always.
473  */
474 library SafeMath {
475     /**
476      * @dev Returns the addition of two unsigned integers, reverting on
477      * overflow.
478      *
479      * Counterpart to Solidity's `+` operator.
480      *
481      * Requirements:
482      * - Addition cannot overflow.
483      */
484     function add(uint256 a, uint256 b) internal pure returns (uint256) {
485         uint256 c = a + b;
486         require(c >= a, "SafeMath: addition overflow");
487 
488         return c;
489     }
490 
491     /**
492      * @dev Returns the subtraction of two unsigned integers, reverting on
493      * overflow (when the result is negative).
494      *
495      * Counterpart to Solidity's `-` operator.
496      *
497      * Requirements:
498      * - Subtraction cannot overflow.
499      */
500     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
501         return sub(a, b, "SafeMath: subtraction overflow");
502     }
503 
504     /**
505      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
506      * overflow (when the result is negative).
507      *
508      * Counterpart to Solidity's `-` operator.
509      *
510      * Requirements:
511      * - Subtraction cannot overflow.
512      *
513      * _Available since v2.4.0._
514      */
515     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
516         require(b <= a, errorMessage);
517         uint256 c = a - b;
518 
519         return c;
520     }
521 
522     /**
523      * @dev Returns the multiplication of two unsigned integers, reverting on
524      * overflow.
525      *
526      * Counterpart to Solidity's `*` operator.
527      *
528      * Requirements:
529      * - Multiplication cannot overflow.
530      */
531     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
532         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
533         // benefit is lost if 'b' is also tested.
534         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
535         if (a == 0) {
536             return 0;
537         }
538 
539         uint256 c = a * b;
540         require(c / a == b, "SafeMath: multiplication overflow");
541 
542         return c;
543     }
544 
545     /**
546      * @dev Returns the integer division of two unsigned integers. Reverts on
547      * division by zero. The result is rounded towards zero.
548      *
549      * Counterpart to Solidity's `/` operator. Note: this function uses a
550      * `revert` opcode (which leaves remaining gas untouched) while Solidity
551      * uses an invalid opcode to revert (consuming all remaining gas).
552      *
553      * Requirements:
554      * - The divisor cannot be zero.
555      */
556     function div(uint256 a, uint256 b) internal pure returns (uint256) {
557         return div(a, b, "SafeMath: division by zero");
558     }
559 
560     /**
561      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
562      * division by zero. The result is rounded towards zero.
563      *
564      * Counterpart to Solidity's `/` operator. Note: this function uses a
565      * `revert` opcode (which leaves remaining gas untouched) while Solidity
566      * uses an invalid opcode to revert (consuming all remaining gas).
567      *
568      * Requirements:
569      * - The divisor cannot be zero.
570      *
571      * _Available since v2.4.0._
572      */
573     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
574         // Solidity only automatically asserts when dividing by 0
575         require(b > 0, errorMessage);
576         uint256 c = a / b;
577         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
578 
579         return c;
580     }
581 
582     /**
583      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
584      * Reverts when dividing by zero.
585      *
586      * Counterpart to Solidity's `%` operator. This function uses a `revert`
587      * opcode (which leaves remaining gas untouched) while Solidity uses an
588      * invalid opcode to revert (consuming all remaining gas).
589      *
590      * Requirements:
591      * - The divisor cannot be zero.
592      */
593     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
594         return mod(a, b, "SafeMath: modulo by zero");
595     }
596 
597     /**
598      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
599      * Reverts with custom message when dividing by zero.
600      *
601      * Counterpart to Solidity's `%` operator. This function uses a `revert`
602      * opcode (which leaves remaining gas untouched) while Solidity uses an
603      * invalid opcode to revert (consuming all remaining gas).
604      *
605      * Requirements:
606      * - The divisor cannot be zero.
607      *
608      * _Available since v2.4.0._
609      */
610     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
611         require(b != 0, errorMessage);
612         return a % b;
613     }
614 }
615 
616 
617 
618 contract EternalStorage {
619 	address private currentOwner = msg.sender;
620 
621 	mapping(bytes32 => uint256) private uIntStorage;
622 	mapping(bytes32 => string) private stringStorage;
623 	mapping(bytes32 => address) private addressStorage;
624 	mapping(bytes32 => bytes32) private bytesStorage;
625 	mapping(bytes32 => bool) private boolStorage;
626 	mapping(bytes32 => int256) private intStorage;
627 
628 	modifier onlyCurrentOwner() {
629 		require(msg.sender == currentOwner, "not current owner");
630 		_;
631 	}
632 
633 	function changeOwner(address _newOwner) external {
634 		require(msg.sender == currentOwner, "not current owner");
635 		currentOwner = _newOwner;
636 	}
637 
638 	// *** Getter Methods ***
639 	function getUint(bytes32 _key) external view returns (uint256) {
640 		return uIntStorage[_key];
641 	}
642 
643 	function getString(bytes32 _key) external view returns (string memory) {
644 		return stringStorage[_key];
645 	}
646 
647 	function getAddress(bytes32 _key) external view returns (address) {
648 		return addressStorage[_key];
649 	}
650 
651 	function getBytes(bytes32 _key) external view returns (bytes32) {
652 		return bytesStorage[_key];
653 	}
654 
655 	function getBool(bytes32 _key) external view returns (bool) {
656 		return boolStorage[_key];
657 	}
658 
659 	function getInt(bytes32 _key) external view returns (int256) {
660 		return intStorage[_key];
661 	}
662 
663 	// *** Setter Methods ***
664 	function setUint(bytes32 _key, uint256 _value) external onlyCurrentOwner {
665 		uIntStorage[_key] = _value;
666 	}
667 
668 	function setString(bytes32 _key, string calldata _value)
669 		external
670 		onlyCurrentOwner
671 	{
672 		stringStorage[_key] = _value;
673 	}
674 
675 	function setAddress(bytes32 _key, address _value)
676 		external
677 		onlyCurrentOwner
678 	{
679 		addressStorage[_key] = _value;
680 	}
681 
682 	function setBytes(bytes32 _key, bytes32 _value) external onlyCurrentOwner {
683 		bytesStorage[_key] = _value;
684 	}
685 
686 	function setBool(bytes32 _key, bool _value) external onlyCurrentOwner {
687 		boolStorage[_key] = _value;
688 	}
689 
690 	function setInt(bytes32 _key, int256 _value) external onlyCurrentOwner {
691 		intStorage[_key] = _value;
692 	}
693 
694 	// *** Delete Methods ***
695 	function deleteUint(bytes32 _key) external onlyCurrentOwner {
696 		delete uIntStorage[_key];
697 	}
698 
699 	function deleteString(bytes32 _key) external onlyCurrentOwner {
700 		delete stringStorage[_key];
701 	}
702 
703 	function deleteAddress(bytes32 _key) external onlyCurrentOwner {
704 		delete addressStorage[_key];
705 	}
706 
707 	function deleteBytes(bytes32 _key) external onlyCurrentOwner {
708 		delete bytesStorage[_key];
709 	}
710 
711 	function deleteBool(bytes32 _key) external onlyCurrentOwner {
712 		delete boolStorage[_key];
713 	}
714 
715 	function deleteInt(bytes32 _key) external onlyCurrentOwner {
716 		delete intStorage[_key];
717 	}
718 }
719 
720 
721 contract UsingStorage is Ownable {
722 	address private _storage;
723 
724 	modifier hasStorage() {
725 		require(_storage != address(0), "storage is not setted");
726 		_;
727 	}
728 
729 	function eternalStorage()
730 		internal
731 		view
732 		hasStorage
733 		returns (EternalStorage)
734 	{
735 		return EternalStorage(_storage);
736 	}
737 
738 	function getStorageAddress() external view hasStorage returns (address) {
739 		return _storage;
740 	}
741 
742 	function createStorage() external onlyOwner {
743 		require(_storage == address(0), "storage is setted");
744 		EternalStorage tmp = new EternalStorage();
745 		_storage = address(tmp);
746 	}
747 
748 	function setStorage(address _storageAddress) external onlyOwner {
749 		_storage = _storageAddress;
750 	}
751 
752 	function changeOwner(address newOwner) external onlyOwner {
753 		EternalStorage(_storage).changeOwner(newOwner);
754 	}
755 }
756 
757 
758 
759 contract VoteTimesStorage is
760 	UsingStorage,
761 	UsingConfig,
762 	UsingValidator,
763 	Killable
764 {
765 	// solium-disable-next-line no-empty-blocks
766 	constructor(address _config) public UsingConfig(_config) {}
767 
768 	// Vote Times
769 	function getVoteTimes() external view returns (uint256) {
770 		return eternalStorage().getUint(getVoteTimesKey());
771 	}
772 
773 	function setVoteTimes(uint256 times) external {
774 		addressValidator().validateAddress(msg.sender, config().voteTimes());
775 
776 		return eternalStorage().setUint(getVoteTimesKey(), times);
777 	}
778 
779 	function getVoteTimesKey() private pure returns (bytes32) {
780 		return keccak256(abi.encodePacked("_voteTimes"));
781 	}
782 
783 	//Vote Times By Property
784 	function getVoteTimesByProperty(address _property)
785 		external
786 		view
787 		returns (uint256)
788 	{
789 		return eternalStorage().getUint(getVoteTimesByPropertyKey(_property));
790 	}
791 
792 	function setVoteTimesByProperty(address _property, uint256 times) external {
793 		addressValidator().validateAddress(msg.sender, config().voteTimes());
794 
795 		return
796 			eternalStorage().setUint(
797 				getVoteTimesByPropertyKey(_property),
798 				times
799 			);
800 	}
801 
802 	function getVoteTimesByPropertyKey(address _property)
803 		private
804 		pure
805 		returns (bytes32)
806 	{
807 		return keccak256(abi.encodePacked("_voteTimesByProperty", _property));
808 	}
809 }
810 
811 
812 contract VoteTimes is UsingConfig, UsingValidator, Killable {
813 	using SafeMath for uint256;
814 
815 	// solium-disable-next-line no-empty-blocks
816 	constructor(address _config) public UsingConfig(_config) {}
817 
818 	function addVoteTime() external {
819 		addressValidator().validateAddresses(
820 			msg.sender,
821 			config().marketFactory(),
822 			config().policyFactory()
823 		);
824 
825 		uint256 voteTimes = getStorage().getVoteTimes();
826 		voteTimes = voteTimes.add(1);
827 		getStorage().setVoteTimes(voteTimes);
828 	}
829 
830 	function addVoteTimesByProperty(address _property) external {
831 		addressValidator().validateAddress(msg.sender, config().voteCounter());
832 
833 		uint256 voteTimesByProperty = getStorage().getVoteTimesByProperty(
834 			_property
835 		);
836 		voteTimesByProperty = voteTimesByProperty.add(1);
837 		getStorage().setVoteTimesByProperty(_property, voteTimesByProperty);
838 	}
839 
840 	function resetVoteTimesByProperty(address _property) external {
841 		addressValidator().validateAddresses(
842 			msg.sender,
843 			config().allocator(),
844 			config().propertyFactory()
845 		);
846 
847 		uint256 voteTimes = getStorage().getVoteTimes();
848 		getStorage().setVoteTimesByProperty(_property, voteTimes);
849 	}
850 
851 	function getAbstentionTimes(address _property)
852 		external
853 		view
854 		returns (uint256)
855 	{
856 		uint256 voteTimes = getStorage().getVoteTimes();
857 		uint256 voteTimesByProperty = getStorage().getVoteTimesByProperty(
858 			_property
859 		);
860 		return voteTimes.sub(voteTimesByProperty);
861 	}
862 
863 	function getStorage() private view returns (VoteTimesStorage) {
864 		return VoteTimesStorage(config().voteTimesStorage());
865 	}
866 }
867 
868 
869 
870 /**
871  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
872  * the optional functions; to access them see {ERC20Detailed}.
873  */
874 interface IERC20 {
875     /**
876      * @dev Returns the amount of tokens in existence.
877      */
878     function totalSupply() external view returns (uint256);
879 
880     /**
881      * @dev Returns the amount of tokens owned by `account`.
882      */
883     function balanceOf(address account) external view returns (uint256);
884 
885     /**
886      * @dev Moves `amount` tokens from the caller's account to `recipient`.
887      *
888      * Returns a boolean value indicating whether the operation succeeded.
889      *
890      * Emits a {Transfer} event.
891      */
892     function transfer(address recipient, uint256 amount) external returns (bool);
893 
894     /**
895      * @dev Returns the remaining number of tokens that `spender` will be
896      * allowed to spend on behalf of `owner` through {transferFrom}. This is
897      * zero by default.
898      *
899      * This value changes when {approve} or {transferFrom} are called.
900      */
901     function allowance(address owner, address spender) external view returns (uint256);
902 
903     /**
904      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
905      *
906      * Returns a boolean value indicating whether the operation succeeded.
907      *
908      * IMPORTANT: Beware that changing an allowance with this method brings the risk
909      * that someone may use both the old and the new allowance by unfortunate
910      * transaction ordering. One possible solution to mitigate this race
911      * condition is to first reduce the spender's allowance to 0 and set the
912      * desired value afterwards:
913      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
914      *
915      * Emits an {Approval} event.
916      */
917     function approve(address spender, uint256 amount) external returns (bool);
918 
919     /**
920      * @dev Moves `amount` tokens from `sender` to `recipient` using the
921      * allowance mechanism. `amount` is then deducted from the caller's
922      * allowance.
923      *
924      * Returns a boolean value indicating whether the operation succeeded.
925      *
926      * Emits a {Transfer} event.
927      */
928     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
929 
930     /**
931      * @dev Emitted when `value` tokens are moved from one account (`from`) to
932      * another (`to`).
933      *
934      * Note that `value` may be zero.
935      */
936     event Transfer(address indexed from, address indexed to, uint256 value);
937 
938     /**
939      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
940      * a call to {approve}. `value` is the new allowance.
941      */
942     event Approval(address indexed owner, address indexed spender, uint256 value);
943 }
944 
945 /**
946  * @dev Implementation of the {IERC20} interface.
947  *
948  * This implementation is agnostic to the way tokens are created. This means
949  * that a supply mechanism has to be added in a derived contract using {_mint}.
950  * For a generic mechanism see {ERC20Mintable}.
951  *
952  * TIP: For a detailed writeup see our guide
953  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
954  * to implement supply mechanisms].
955  *
956  * We have followed general OpenZeppelin guidelines: functions revert instead
957  * of returning `false` on failure. This behavior is nonetheless conventional
958  * and does not conflict with the expectations of ERC20 applications.
959  *
960  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
961  * This allows applications to reconstruct the allowance for all accounts just
962  * by listening to said events. Other implementations of the EIP may not emit
963  * these events, as it isn't required by the specification.
964  *
965  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
966  * functions have been added to mitigate the well-known issues around setting
967  * allowances. See {IERC20-approve}.
968  */
969 contract ERC20 is Context, IERC20 {
970     using SafeMath for uint256;
971 
972     mapping (address => uint256) private _balances;
973 
974     mapping (address => mapping (address => uint256)) private _allowances;
975 
976     uint256 private _totalSupply;
977 
978     /**
979      * @dev See {IERC20-totalSupply}.
980      */
981     function totalSupply() public view returns (uint256) {
982         return _totalSupply;
983     }
984 
985     /**
986      * @dev See {IERC20-balanceOf}.
987      */
988     function balanceOf(address account) public view returns (uint256) {
989         return _balances[account];
990     }
991 
992     /**
993      * @dev See {IERC20-transfer}.
994      *
995      * Requirements:
996      *
997      * - `recipient` cannot be the zero address.
998      * - the caller must have a balance of at least `amount`.
999      */
1000     function transfer(address recipient, uint256 amount) public returns (bool) {
1001         _transfer(_msgSender(), recipient, amount);
1002         return true;
1003     }
1004 
1005     /**
1006      * @dev See {IERC20-allowance}.
1007      */
1008     function allowance(address owner, address spender) public view returns (uint256) {
1009         return _allowances[owner][spender];
1010     }
1011 
1012     /**
1013      * @dev See {IERC20-approve}.
1014      *
1015      * Requirements:
1016      *
1017      * - `spender` cannot be the zero address.
1018      */
1019     function approve(address spender, uint256 amount) public returns (bool) {
1020         _approve(_msgSender(), spender, amount);
1021         return true;
1022     }
1023 
1024     /**
1025      * @dev See {IERC20-transferFrom}.
1026      *
1027      * Emits an {Approval} event indicating the updated allowance. This is not
1028      * required by the EIP. See the note at the beginning of {ERC20};
1029      *
1030      * Requirements:
1031      * - `sender` and `recipient` cannot be the zero address.
1032      * - `sender` must have a balance of at least `amount`.
1033      * - the caller must have allowance for `sender`'s tokens of at least
1034      * `amount`.
1035      */
1036     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1037         _transfer(sender, recipient, amount);
1038         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1039         return true;
1040     }
1041 
1042     /**
1043      * @dev Atomically increases the allowance granted to `spender` by the caller.
1044      *
1045      * This is an alternative to {approve} that can be used as a mitigation for
1046      * problems described in {IERC20-approve}.
1047      *
1048      * Emits an {Approval} event indicating the updated allowance.
1049      *
1050      * Requirements:
1051      *
1052      * - `spender` cannot be the zero address.
1053      */
1054     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
1055         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1056         return true;
1057     }
1058 
1059     /**
1060      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1061      *
1062      * This is an alternative to {approve} that can be used as a mitigation for
1063      * problems described in {IERC20-approve}.
1064      *
1065      * Emits an {Approval} event indicating the updated allowance.
1066      *
1067      * Requirements:
1068      *
1069      * - `spender` cannot be the zero address.
1070      * - `spender` must have allowance for the caller of at least
1071      * `subtractedValue`.
1072      */
1073     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1074         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1075         return true;
1076     }
1077 
1078     /**
1079      * @dev Moves tokens `amount` from `sender` to `recipient`.
1080      *
1081      * This is internal function is equivalent to {transfer}, and can be used to
1082      * e.g. implement automatic token fees, slashing mechanisms, etc.
1083      *
1084      * Emits a {Transfer} event.
1085      *
1086      * Requirements:
1087      *
1088      * - `sender` cannot be the zero address.
1089      * - `recipient` cannot be the zero address.
1090      * - `sender` must have a balance of at least `amount`.
1091      */
1092     function _transfer(address sender, address recipient, uint256 amount) internal {
1093         require(sender != address(0), "ERC20: transfer from the zero address");
1094         require(recipient != address(0), "ERC20: transfer to the zero address");
1095 
1096         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1097         _balances[recipient] = _balances[recipient].add(amount);
1098         emit Transfer(sender, recipient, amount);
1099     }
1100 
1101     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1102      * the total supply.
1103      *
1104      * Emits a {Transfer} event with `from` set to the zero address.
1105      *
1106      * Requirements
1107      *
1108      * - `to` cannot be the zero address.
1109      */
1110     function _mint(address account, uint256 amount) internal {
1111         require(account != address(0), "ERC20: mint to the zero address");
1112 
1113         _totalSupply = _totalSupply.add(amount);
1114         _balances[account] = _balances[account].add(amount);
1115         emit Transfer(address(0), account, amount);
1116     }
1117 
1118      /**
1119      * @dev Destroys `amount` tokens from `account`, reducing the
1120      * total supply.
1121      *
1122      * Emits a {Transfer} event with `to` set to the zero address.
1123      *
1124      * Requirements
1125      *
1126      * - `account` cannot be the zero address.
1127      * - `account` must have at least `amount` tokens.
1128      */
1129     function _burn(address account, uint256 amount) internal {
1130         require(account != address(0), "ERC20: burn from the zero address");
1131 
1132         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1133         _totalSupply = _totalSupply.sub(amount);
1134         emit Transfer(account, address(0), amount);
1135     }
1136 
1137     /**
1138      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1139      *
1140      * This is internal function is equivalent to `approve`, and can be used to
1141      * e.g. set automatic allowances for certain subsystems, etc.
1142      *
1143      * Emits an {Approval} event.
1144      *
1145      * Requirements:
1146      *
1147      * - `owner` cannot be the zero address.
1148      * - `spender` cannot be the zero address.
1149      */
1150     function _approve(address owner, address spender, uint256 amount) internal {
1151         require(owner != address(0), "ERC20: approve from the zero address");
1152         require(spender != address(0), "ERC20: approve to the zero address");
1153 
1154         _allowances[owner][spender] = amount;
1155         emit Approval(owner, spender, amount);
1156     }
1157 
1158     /**
1159      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
1160      * from the caller's allowance.
1161      *
1162      * See {_burn} and {_approve}.
1163      */
1164     function _burnFrom(address account, uint256 amount) internal {
1165         _burn(account, amount);
1166         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
1167     }
1168 }
1169 // prettier-ignore
1170 
1171 
1172 /**
1173  * @dev Optional functions from the ERC20 standard.
1174  */
1175 contract ERC20Detailed is IERC20 {
1176     string private _name;
1177     string private _symbol;
1178     uint8 private _decimals;
1179 
1180     /**
1181      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1182      * these values are immutable: they can only be set once during
1183      * construction.
1184      */
1185     constructor (string memory name, string memory symbol, uint8 decimals) public {
1186         _name = name;
1187         _symbol = symbol;
1188         _decimals = decimals;
1189     }
1190 
1191     /**
1192      * @dev Returns the name of the token.
1193      */
1194     function name() public view returns (string memory) {
1195         return _name;
1196     }
1197 
1198     /**
1199      * @dev Returns the symbol of the token, usually a shorter version of the
1200      * name.
1201      */
1202     function symbol() public view returns (string memory) {
1203         return _symbol;
1204     }
1205 
1206     /**
1207      * @dev Returns the number of decimals used to get its user representation.
1208      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1209      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1210      *
1211      * Tokens usually opt for a value of 18, imitating the relationship between
1212      * Ether and Wei.
1213      *
1214      * NOTE: This information is only used for _display_ purposes: it in
1215      * no way affects any of the arithmetic of the contract, including
1216      * {IERC20-balanceOf} and {IERC20-transfer}.
1217      */
1218     function decimals() public view returns (uint8) {
1219         return _decimals;
1220     }
1221 }
1222 
1223 
1224 
1225 contract IAllocator {
1226 	function allocate(address _metrics) external;
1227 
1228 	function calculatedCallback(address _metrics, uint256 _value) external;
1229 
1230 	function beforeBalanceChange(address _property, address _from, address _to)
1231 		external;
1232 
1233 	function getRewardsAmount(address _property)
1234 		external
1235 		view
1236 		returns (uint256);
1237 
1238 	function allocation(
1239 		uint256 _blocks,
1240 		uint256 _mint,
1241 		uint256 _value,
1242 		uint256 _marketValue,
1243 		uint256 _assets,
1244 		uint256 _totalAssets
1245 	)
1246 		public
1247 		pure
1248 		returns (
1249 			// solium-disable-next-line indentation
1250 			uint256
1251 		);
1252 }
1253 
1254 
1255 
1256 library Decimals {
1257 	using SafeMath for uint256;
1258 	uint120 private constant basisValue = 1000000000000000000;
1259 
1260 	function outOf(uint256 _a, uint256 _b)
1261 		internal
1262 		pure
1263 		returns (uint256 result)
1264 	{
1265 		if (_a == 0) {
1266 			return 0;
1267 		}
1268 		uint256 a = _a.mul(basisValue);
1269 		require(a > _b, "the denominator is too big");
1270 		return (a.div(_b));
1271 	}
1272 
1273 	function basis() external pure returns (uint120) {
1274 		return basisValue;
1275 	}
1276 }
1277 
1278 
1279 
1280 // prettier-ignore
1281 
1282 
1283 
1284 contract MinterRole is Context {
1285     using Roles for Roles.Role;
1286 
1287     event MinterAdded(address indexed account);
1288     event MinterRemoved(address indexed account);
1289 
1290     Roles.Role private _minters;
1291 
1292     constructor () internal {
1293         _addMinter(_msgSender());
1294     }
1295 
1296     modifier onlyMinter() {
1297         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1298         _;
1299     }
1300 
1301     function isMinter(address account) public view returns (bool) {
1302         return _minters.has(account);
1303     }
1304 
1305     function addMinter(address account) public onlyMinter {
1306         _addMinter(account);
1307     }
1308 
1309     function renounceMinter() public {
1310         _removeMinter(_msgSender());
1311     }
1312 
1313     function _addMinter(address account) internal {
1314         _minters.add(account);
1315         emit MinterAdded(account);
1316     }
1317 
1318     function _removeMinter(address account) internal {
1319         _minters.remove(account);
1320         emit MinterRemoved(account);
1321     }
1322 }
1323 
1324 /**
1325  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
1326  * which have permission to mint (create) new tokens as they see fit.
1327  *
1328  * At construction, the deployer of the contract is the only minter.
1329  */
1330 contract ERC20Mintable is ERC20, MinterRole {
1331     /**
1332      * @dev See {ERC20-_mint}.
1333      *
1334      * Requirements:
1335      *
1336      * - the caller must have the {MinterRole}.
1337      */
1338     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1339         _mint(account, amount);
1340         return true;
1341     }
1342 }
1343 
1344 
1345 
1346 contract PropertyGroup is
1347 	UsingConfig,
1348 	UsingStorage,
1349 	UsingValidator,
1350 	IGroup,
1351 	Killable
1352 {
1353 	// solium-disable-next-line no-empty-blocks
1354 	constructor(address _config) public UsingConfig(_config) {}
1355 
1356 	function addGroup(address _addr) external {
1357 		addressValidator().validateAddress(
1358 			msg.sender,
1359 			config().propertyFactory()
1360 		);
1361 
1362 		require(isGroup(_addr) == false, "already enabled");
1363 		eternalStorage().setBool(getGroupKey(_addr), true);
1364 	}
1365 
1366 	function isGroup(address _addr) public view returns (bool) {
1367 		return eternalStorage().getBool(getGroupKey(_addr));
1368 	}
1369 }
1370 
1371 
1372 
1373 contract LockupStorage is UsingConfig, UsingStorage, UsingValidator, Killable {
1374 	// solium-disable-next-line no-empty-blocks
1375 	constructor(address _config) public UsingConfig(_config) {}
1376 
1377 	//Value
1378 	function setValue(address _property, address _sender, uint256 _value)
1379 		external
1380 		returns (uint256)
1381 	{
1382 		addressValidator().validateAddress(msg.sender, config().lockup());
1383 
1384 		bytes32 key = getValueKey(_property, _sender);
1385 		eternalStorage().setUint(key, _value);
1386 	}
1387 
1388 	function getValue(address _property, address _sender)
1389 		external
1390 		view
1391 		returns (uint256)
1392 	{
1393 		bytes32 key = getValueKey(_property, _sender);
1394 		return eternalStorage().getUint(key);
1395 	}
1396 
1397 	function getValueKey(address _property, address _sender)
1398 		private
1399 		pure
1400 		returns (bytes32)
1401 	{
1402 		return keccak256(abi.encodePacked("_value", _property, _sender));
1403 	}
1404 
1405 	//PropertyValue
1406 	function setPropertyValue(address _property, uint256 _value)
1407 		external
1408 		returns (uint256)
1409 	{
1410 		addressValidator().validateAddress(msg.sender, config().lockup());
1411 
1412 		bytes32 key = getPropertyValueKey(_property);
1413 		eternalStorage().setUint(key, _value);
1414 	}
1415 
1416 	function getPropertyValue(address _property)
1417 		external
1418 		view
1419 		returns (uint256)
1420 	{
1421 		bytes32 key = getPropertyValueKey(_property);
1422 		return eternalStorage().getUint(key);
1423 	}
1424 
1425 	function getPropertyValueKey(address _property)
1426 		private
1427 		pure
1428 		returns (bytes32)
1429 	{
1430 		return keccak256(abi.encodePacked("_propertyValue", _property));
1431 	}
1432 
1433 	//WithdrawalStatus
1434 	function setWithdrawalStatus(
1435 		address _property,
1436 		address _from,
1437 		uint256 _value
1438 	) external {
1439 		addressValidator().validateAddress(msg.sender, config().lockup());
1440 
1441 		bytes32 key = getWithdrawalStatusKey(_property, _from);
1442 		eternalStorage().setUint(key, _value);
1443 	}
1444 
1445 	function getWithdrawalStatus(address _property, address _from)
1446 		external
1447 		view
1448 		returns (uint256)
1449 	{
1450 		bytes32 key = getWithdrawalStatusKey(_property, _from);
1451 		return eternalStorage().getUint(key);
1452 	}
1453 
1454 	function getWithdrawalStatusKey(address _property, address _sender)
1455 		private
1456 		pure
1457 		returns (bytes32)
1458 	{
1459 		return
1460 			keccak256(
1461 				abi.encodePacked("_withdrawalStatus", _property, _sender)
1462 			);
1463 	}
1464 
1465 	//InterestPrice
1466 	function setInterestPrice(address _property, uint256 _value)
1467 		external
1468 		returns (uint256)
1469 	{
1470 		addressValidator().validateAddress(msg.sender, config().lockup());
1471 
1472 		eternalStorage().setUint(getInterestPriceKey(_property), _value);
1473 	}
1474 
1475 	function getInterestPrice(address _property)
1476 		external
1477 		view
1478 		returns (uint256)
1479 	{
1480 		return eternalStorage().getUint(getInterestPriceKey(_property));
1481 	}
1482 
1483 	function getInterestPriceKey(address _property)
1484 		private
1485 		pure
1486 		returns (bytes32)
1487 	{
1488 		return keccak256(abi.encodePacked("_interestTotals", _property));
1489 	}
1490 
1491 	//LastInterestPrice
1492 	function setLastInterestPrice(
1493 		address _property,
1494 		address _user,
1495 		uint256 _value
1496 	) external {
1497 		addressValidator().validateAddress(msg.sender, config().lockup());
1498 
1499 		eternalStorage().setUint(
1500 			getLastInterestPriceKey(_property, _user),
1501 			_value
1502 		);
1503 	}
1504 
1505 	function getLastInterestPrice(address _property, address _user)
1506 		external
1507 		view
1508 		returns (uint256)
1509 	{
1510 		return
1511 			eternalStorage().getUint(getLastInterestPriceKey(_property, _user));
1512 	}
1513 
1514 	function getLastInterestPriceKey(address _property, address _user)
1515 		private
1516 		pure
1517 		returns (bytes32)
1518 	{
1519 		return
1520 			keccak256(
1521 				abi.encodePacked("_lastLastInterestPrice", _property, _user)
1522 			);
1523 	}
1524 
1525 	//PendingWithdrawal
1526 	function setPendingInterestWithdrawal(
1527 		address _property,
1528 		address _user,
1529 		uint256 _value
1530 	) external {
1531 		addressValidator().validateAddress(msg.sender, config().lockup());
1532 
1533 		eternalStorage().setUint(
1534 			getPendingInterestWithdrawalKey(_property, _user),
1535 			_value
1536 		);
1537 	}
1538 
1539 	function getPendingInterestWithdrawal(address _property, address _user)
1540 		external
1541 		view
1542 		returns (uint256)
1543 	{
1544 		return
1545 			eternalStorage().getUint(
1546 				getPendingInterestWithdrawalKey(_property, _user)
1547 			);
1548 	}
1549 
1550 	function getPendingInterestWithdrawalKey(address _property, address _user)
1551 		private
1552 		pure
1553 		returns (bytes32)
1554 	{
1555 		return
1556 			keccak256(
1557 				abi.encodePacked("_pendingInterestWithdrawal", _property, _user)
1558 			);
1559 	}
1560 }
1561 
1562 
1563 
1564 contract IPolicy {
1565 	function rewards(uint256 _lockups, uint256 _assets)
1566 		external
1567 		view
1568 		returns (uint256);
1569 
1570 	function holdersShare(uint256 _amount, uint256 _lockups)
1571 		external
1572 		view
1573 		returns (uint256);
1574 
1575 	function assetValue(uint256 _value, uint256 _lockups)
1576 		external
1577 		view
1578 		returns (uint256);
1579 
1580 	function authenticationFee(uint256 _assets, uint256 _propertyAssets)
1581 		external
1582 		view
1583 		returns (uint256);
1584 
1585 	function marketApproval(uint256 _agree, uint256 _opposite)
1586 		external
1587 		view
1588 		returns (bool);
1589 
1590 	function policyApproval(uint256 _agree, uint256 _opposite)
1591 		external
1592 		view
1593 		returns (bool);
1594 
1595 	function marketVotingBlocks() external view returns (uint256);
1596 
1597 	function policyVotingBlocks() external view returns (uint256);
1598 
1599 	function abstentionPenalty(uint256 _count) external view returns (uint256);
1600 
1601 	function lockUpBlocks() external view returns (uint256);
1602 }
1603 
1604 
1605 
1606 
1607 
1608 contract MarketGroup is
1609 	UsingConfig,
1610 	UsingStorage,
1611 	IGroup,
1612 	UsingValidator,
1613 	Killable
1614 {
1615 	using SafeMath for uint256;
1616 
1617 	// solium-disable-next-line no-empty-blocks
1618 	constructor(address _config) public UsingConfig(_config) UsingStorage() {}
1619 
1620 	function addGroup(address _addr) external {
1621 		addressValidator().validateAddress(
1622 			msg.sender,
1623 			config().marketFactory()
1624 		);
1625 
1626 		require(isGroup(_addr) == false, "already enabled");
1627 		eternalStorage().setBool(getGroupKey(_addr), true);
1628 		addCount();
1629 	}
1630 
1631 	function isGroup(address _addr) public view returns (bool) {
1632 		return eternalStorage().getBool(getGroupKey(_addr));
1633 	}
1634 
1635 	function addCount() private {
1636 		bytes32 key = getCountKey();
1637 		uint256 number = eternalStorage().getUint(key);
1638 		number = number.add(1);
1639 		eternalStorage().setUint(key, number);
1640 	}
1641 
1642 	function getCount() external view returns (uint256) {
1643 		bytes32 key = getCountKey();
1644 		return eternalStorage().getUint(key);
1645 	}
1646 
1647 	function getCountKey() private pure returns (bytes32) {
1648 		return keccak256(abi.encodePacked("_count"));
1649 	}
1650 }
1651 
1652 
1653 contract PolicySet is UsingConfig, UsingStorage, UsingValidator, Killable {
1654 	using SafeMath for uint256;
1655 
1656 	// solium-disable-next-line no-empty-blocks
1657 	constructor(address _config) public UsingConfig(_config) {}
1658 
1659 	function addSet(address _addr) external {
1660 		addressValidator().validateAddress(
1661 			msg.sender,
1662 			config().policyFactory()
1663 		);
1664 
1665 		uint256 index = eternalStorage().getUint(getPlicySetIndexKey());
1666 		bytes32 key = getIndexKey(index);
1667 		eternalStorage().setAddress(key, _addr);
1668 		index = index.add(1);
1669 		eternalStorage().setUint(getPlicySetIndexKey(), index);
1670 	}
1671 
1672 	function deleteAll() external {
1673 		addressValidator().validateAddress(
1674 			msg.sender,
1675 			config().policyFactory()
1676 		);
1677 
1678 		uint256 index = eternalStorage().getUint(getPlicySetIndexKey());
1679 		for (uint256 i = 0; i < index; i++) {
1680 			bytes32 key = getIndexKey(i);
1681 			eternalStorage().setAddress(key, address(0));
1682 		}
1683 		eternalStorage().setUint(getPlicySetIndexKey(), 0);
1684 	}
1685 
1686 	function count() external view returns (uint256) {
1687 		return eternalStorage().getUint(getPlicySetIndexKey());
1688 	}
1689 
1690 	function get(uint256 _index) external view returns (address) {
1691 		bytes32 key = getIndexKey(_index);
1692 		return eternalStorage().getAddress(key);
1693 	}
1694 
1695 	function getIndexKey(uint256 _index) private pure returns (bytes32) {
1696 		return keccak256(abi.encodePacked("_index", _index));
1697 	}
1698 
1699 	function getPlicySetIndexKey() private pure returns (bytes32) {
1700 		return keccak256(abi.encodePacked("_policySetIndex"));
1701 	}
1702 }
1703 
1704 
1705 
1706 contract PolicyGroup is
1707 	UsingConfig,
1708 	UsingStorage,
1709 	UsingValidator,
1710 	IGroup,
1711 	Killable
1712 {
1713 	// solium-disable-next-line no-empty-blocks
1714 	constructor(address _config) public UsingConfig(_config) {}
1715 
1716 	function addGroup(address _addr) external {
1717 		addressValidator().validateAddress(
1718 			msg.sender,
1719 			config().policyFactory()
1720 		);
1721 
1722 		require(isGroup(_addr) == false, "already enabled");
1723 		eternalStorage().setBool(getGroupKey(_addr), true);
1724 	}
1725 
1726 	function deleteGroup(address _addr) external {
1727 		addressValidator().validateAddress(
1728 			msg.sender,
1729 			config().policyFactory()
1730 		);
1731 
1732 		require(isGroup(_addr), "not enabled");
1733 		return eternalStorage().setBool(getGroupKey(_addr), false);
1734 	}
1735 
1736 	function isGroup(address _addr) public view returns (bool) {
1737 		return eternalStorage().getBool(getGroupKey(_addr));
1738 	}
1739 }
1740 
1741 
1742 contract PolicyFactory is Pausable, UsingConfig, UsingValidator, Killable {
1743 	event Create(address indexed _from, address _policy, address _innerPolicy);
1744 
1745 	// solium-disable-next-line no-empty-blocks
1746 	constructor(address _config) public UsingConfig(_config) {}
1747 
1748 	function create(address _newPolicyAddress) external returns (address) {
1749 		require(paused() == false, "You cannot use that");
1750 		addressValidator().validateIllegalAddress(_newPolicyAddress);
1751 
1752 		Policy policy = new Policy(address(config()), _newPolicyAddress);
1753 		address policyAddress = address(policy);
1754 		emit Create(msg.sender, policyAddress, _newPolicyAddress);
1755 		if (config().policy() == address(0)) {
1756 			config().setPolicy(policyAddress);
1757 		} else {
1758 			VoteTimes(config().voteTimes()).addVoteTime();
1759 		}
1760 		PolicyGroup policyGroup = PolicyGroup(config().policyGroup());
1761 		policyGroup.addGroup(policyAddress);
1762 		PolicySet policySet = PolicySet(config().policySet());
1763 		policySet.addSet(policyAddress);
1764 		return policyAddress;
1765 	}
1766 
1767 	function convergePolicy(address _currentPolicyAddress) external {
1768 		addressValidator().validateGroup(msg.sender, config().policyGroup());
1769 
1770 		config().setPolicy(_currentPolicyAddress);
1771 		PolicySet policySet = PolicySet(config().policySet());
1772 		PolicyGroup policyGroup = PolicyGroup(config().policyGroup());
1773 		for (uint256 i = 0; i < policySet.count(); i++) {
1774 			address policyAddress = policySet.get(i);
1775 			if (policyAddress == _currentPolicyAddress) {
1776 				continue;
1777 			}
1778 			Policy(policyAddress).kill();
1779 			policyGroup.deleteGroup(policyAddress);
1780 		}
1781 		policySet.deleteAll();
1782 		policySet.addSet(_currentPolicyAddress);
1783 	}
1784 }
1785 
1786 
1787 contract Policy is Killable, UsingConfig, UsingValidator {
1788 	using SafeMath for uint256;
1789 	IPolicy private _policy;
1790 	uint256 private _votingEndBlockNumber;
1791 
1792 	constructor(address _config, address _innerPolicyAddress)
1793 		public
1794 		UsingConfig(_config)
1795 	{
1796 		addressValidator().validateAddress(
1797 			msg.sender,
1798 			config().policyFactory()
1799 		);
1800 
1801 		_policy = IPolicy(_innerPolicyAddress);
1802 		setVotingEndBlockNumber();
1803 	}
1804 
1805 	function voting() public view returns (bool) {
1806 		return block.number <= _votingEndBlockNumber;
1807 	}
1808 
1809 	function rewards(uint256 _lockups, uint256 _assets)
1810 		external
1811 		view
1812 		returns (uint256)
1813 	{
1814 		return _policy.rewards(_lockups, _assets);
1815 	}
1816 
1817 	function holdersShare(uint256 _amount, uint256 _lockups)
1818 		external
1819 		view
1820 		returns (uint256)
1821 	{
1822 		return _policy.holdersShare(_amount, _lockups);
1823 	}
1824 
1825 	function assetValue(uint256 _value, uint256 _lockups)
1826 		external
1827 		view
1828 		returns (uint256)
1829 	{
1830 		return _policy.assetValue(_value, _lockups);
1831 	}
1832 
1833 	function authenticationFee(uint256 _assets, uint256 _propertyAssets)
1834 		external
1835 		view
1836 		returns (uint256)
1837 	{
1838 		return _policy.authenticationFee(_assets, _propertyAssets);
1839 	}
1840 
1841 	function marketApproval(uint256 _agree, uint256 _opposite)
1842 		external
1843 		view
1844 		returns (bool)
1845 	{
1846 		return _policy.marketApproval(_agree, _opposite);
1847 	}
1848 
1849 	function policyApproval(uint256 _agree, uint256 _opposite)
1850 		external
1851 		view
1852 		returns (bool)
1853 	{
1854 		return _policy.policyApproval(_agree, _opposite);
1855 	}
1856 
1857 	function marketVotingBlocks() external view returns (uint256) {
1858 		return _policy.marketVotingBlocks();
1859 	}
1860 
1861 	function policyVotingBlocks() external view returns (uint256) {
1862 		return _policy.policyVotingBlocks();
1863 	}
1864 
1865 	function abstentionPenalty(uint256 _count) external view returns (uint256) {
1866 		return _policy.abstentionPenalty(_count);
1867 	}
1868 
1869 	function lockUpBlocks() external view returns (uint256) {
1870 		return _policy.lockUpBlocks();
1871 	}
1872 
1873 	function vote(address _property, bool _agree) external {
1874 		addressValidator().validateGroup(_property, config().propertyGroup());
1875 
1876 		require(config().policy() != address(this), "this policy is current");
1877 		require(voting(), "voting deadline is over");
1878 		VoteCounter voteCounter = VoteCounter(config().voteCounter());
1879 		voteCounter.addVoteCount(msg.sender, _property, _agree);
1880 		bool result = Policy(config().policy()).policyApproval(
1881 			voteCounter.getAgreeCount(address(this)),
1882 			voteCounter.getOppositeCount(address(this))
1883 		);
1884 		if (result == false) {
1885 			return;
1886 		}
1887 		PolicyFactory(config().policyFactory()).convergePolicy(address(this));
1888 		_votingEndBlockNumber = 0;
1889 	}
1890 
1891 	function setVotingEndBlockNumber() private {
1892 		if (config().policy() == address(0)) {
1893 			return;
1894 		}
1895 		uint256 tmp = Policy(config().policy()).policyVotingBlocks();
1896 		_votingEndBlockNumber = block.number.add(tmp);
1897 	}
1898 }
1899 
1900 
1901 contract Lockup is Pausable, UsingConfig, UsingValidator, Killable {
1902 	using SafeMath for uint256;
1903 	using Decimals for uint256;
1904 	event Lockedup(address _from, address _property, uint256 _value);
1905 
1906 	// solium-disable-next-line no-empty-blocks
1907 	constructor(address _config) public UsingConfig(_config) {}
1908 
1909 	function lockup(address _from, address _property, uint256 _value) external {
1910 		require(paused() == false, "You cannot use that");
1911 		addressValidator().validateAddress(msg.sender, config().token());
1912 		addressValidator().validateGroup(_property, config().propertyGroup());
1913 		require(_value != 0, "illegal lockup value");
1914 
1915 		bool isWaiting = getStorage().getWithdrawalStatus(_property, _from) !=
1916 			0;
1917 		require(isWaiting == false, "lockup is already canceled");
1918 		updatePendingInterestWithdrawal(_property, _from);
1919 		addValue(_property, _from, _value);
1920 		addPropertyValue(_property, _value);
1921 		getStorage().setLastInterestPrice(
1922 			_property,
1923 			_from,
1924 			getStorage().getInterestPrice(_property)
1925 		);
1926 		emit Lockedup(_from, _property, _value);
1927 	}
1928 
1929 	function cancel(address _property) external {
1930 		addressValidator().validateGroup(_property, config().propertyGroup());
1931 
1932 		require(hasValue(_property, msg.sender), "dev token is not locked");
1933 		bool isWaiting = getStorage().getWithdrawalStatus(
1934 			_property,
1935 			msg.sender
1936 		) !=
1937 			0;
1938 		require(isWaiting == false, "lockup is already canceled");
1939 		uint256 blockNumber = Policy(config().policy()).lockUpBlocks();
1940 		blockNumber = blockNumber.add(block.number);
1941 		getStorage().setWithdrawalStatus(_property, msg.sender, blockNumber);
1942 	}
1943 
1944 	function withdraw(address _property) external {
1945 		addressValidator().validateGroup(_property, config().propertyGroup());
1946 
1947 		require(possible(_property, msg.sender), "waiting for release");
1948 		uint256 lockupedValue = getStorage().getValue(_property, msg.sender);
1949 		require(lockupedValue != 0, "dev token is not locked");
1950 		updatePendingInterestWithdrawal(_property, msg.sender);
1951 		Property(_property).withdraw(msg.sender, lockupedValue);
1952 		getStorage().setValue(_property, msg.sender, 0);
1953 		subPropertyValue(_property, lockupedValue);
1954 		getStorage().setWithdrawalStatus(_property, msg.sender, 0);
1955 	}
1956 
1957 	function increment(address _property, uint256 _interestResult) external {
1958 		addressValidator().validateAddress(msg.sender, config().allocator());
1959 		uint256 priceValue = _interestResult.outOf(
1960 			getStorage().getPropertyValue(_property)
1961 		);
1962 		incrementInterest(_property, priceValue);
1963 	}
1964 
1965 	function _calculateInterestAmount(address _property, address _user)
1966 		private
1967 		view
1968 		returns (uint256)
1969 	{
1970 		uint256 _last = getStorage().getLastInterestPrice(_property, _user);
1971 		uint256 price = getStorage().getInterestPrice(_property);
1972 		uint256 priceGap = price.sub(_last);
1973 		uint256 lockupedValue = getStorage().getValue(_property, _user);
1974 		uint256 value = priceGap.mul(lockupedValue);
1975 		return value.div(Decimals.basis());
1976 	}
1977 
1978 	function calculateInterestAmount(address _property, address _user)
1979 		external
1980 		view
1981 		returns (uint256)
1982 	{
1983 		return _calculateInterestAmount(_property, _user);
1984 	}
1985 
1986 	function _calculateWithdrawableInterestAmount(
1987 		address _property,
1988 		address _user
1989 	) private view returns (uint256) {
1990 		uint256 pending = getStorage().getPendingInterestWithdrawal(
1991 			_property,
1992 			_user
1993 		);
1994 		return _calculateInterestAmount(_property, _user).add(pending);
1995 	}
1996 
1997 	function calculateWithdrawableInterestAmount(
1998 		address _property,
1999 		address _user
2000 	) external view returns (uint256) {
2001 		return _calculateWithdrawableInterestAmount(_property, _user);
2002 	}
2003 
2004 	function withdrawInterest(address _property) external {
2005 		addressValidator().validateGroup(_property, config().propertyGroup());
2006 
2007 		uint256 value = _calculateWithdrawableInterestAmount(
2008 			_property,
2009 			msg.sender
2010 		);
2011 		require(value > 0, "your interest amount is 0");
2012 		getStorage().setLastInterestPrice(
2013 			_property,
2014 			msg.sender,
2015 			getStorage().getInterestPrice(_property)
2016 		);
2017 		getStorage().setPendingInterestWithdrawal(_property, msg.sender, 0);
2018 		ERC20Mintable erc20 = ERC20Mintable(config().token());
2019 		require(erc20.mint(msg.sender, value), "dev mint failed");
2020 	}
2021 
2022 	function getPropertyValue(address _property)
2023 		external
2024 		view
2025 		returns (uint256)
2026 	{
2027 		return getStorage().getPropertyValue(_property);
2028 	}
2029 
2030 	function getValue(address _property, address _sender)
2031 		external
2032 		view
2033 		returns (uint256)
2034 	{
2035 		return getStorage().getValue(_property, _sender);
2036 	}
2037 
2038 	function addValue(address _property, address _sender, uint256 _value)
2039 		private
2040 	{
2041 		uint256 value = getStorage().getValue(_property, _sender);
2042 		value = value.add(_value);
2043 		getStorage().setValue(_property, _sender, value);
2044 	}
2045 
2046 	function hasValue(address _property, address _sender)
2047 		private
2048 		view
2049 		returns (bool)
2050 	{
2051 		uint256 value = getStorage().getValue(_property, _sender);
2052 		return value != 0;
2053 	}
2054 
2055 	function addPropertyValue(address _property, uint256 _value) private {
2056 		uint256 value = getStorage().getPropertyValue(_property);
2057 		value = value.add(_value);
2058 		getStorage().setPropertyValue(_property, value);
2059 	}
2060 
2061 	function subPropertyValue(address _property, uint256 _value) private {
2062 		uint256 value = getStorage().getPropertyValue(_property);
2063 		value = value.sub(_value);
2064 		getStorage().setPropertyValue(_property, value);
2065 	}
2066 
2067 	function incrementInterest(address _property, uint256 _priceValue) private {
2068 		uint256 price = getStorage().getInterestPrice(_property);
2069 		getStorage().setInterestPrice(_property, price.add(_priceValue));
2070 	}
2071 
2072 	function updatePendingInterestWithdrawal(address _property, address _user)
2073 		private
2074 	{
2075 		uint256 pending = getStorage().getPendingInterestWithdrawal(
2076 			_property,
2077 			_user
2078 		);
2079 		getStorage().setPendingInterestWithdrawal(
2080 			_property,
2081 			_user,
2082 			_calculateInterestAmount(_property, _user).add(pending)
2083 		);
2084 	}
2085 
2086 	function possible(address _property, address _from)
2087 		private
2088 		view
2089 		returns (bool)
2090 	{
2091 		uint256 blockNumber = getStorage().getWithdrawalStatus(
2092 			_property,
2093 			_from
2094 		);
2095 		if (blockNumber == 0) {
2096 			return false;
2097 		}
2098 		return blockNumber <= block.number;
2099 	}
2100 
2101 	function getStorage() private view returns (LockupStorage) {
2102 		return LockupStorage(config().lockupStorage());
2103 	}
2104 }
2105 // prettier-ignore
2106 
2107 
2108 
2109 contract VoteCounterStorage is
2110 	UsingStorage,
2111 	UsingConfig,
2112 	UsingValidator,
2113 	Killable
2114 {
2115 	// solium-disable-next-line no-empty-blocks
2116 	constructor(address _config) public UsingConfig(_config) {}
2117 
2118 	// Already Vote Flg
2119 	function setAlreadyVoteFlg(
2120 		address _user,
2121 		address _sender,
2122 		address _property
2123 	) external {
2124 		addressValidator().validateAddress(msg.sender, config().voteCounter());
2125 
2126 		bytes32 alreadyVoteKey = getAlreadyVoteKey(_user, _sender, _property);
2127 		return eternalStorage().setBool(alreadyVoteKey, true);
2128 	}
2129 
2130 	function getAlreadyVoteFlg(
2131 		address _user,
2132 		address _sender,
2133 		address _property
2134 	) external view returns (bool) {
2135 		bytes32 alreadyVoteKey = getAlreadyVoteKey(_user, _sender, _property);
2136 		return eternalStorage().getBool(alreadyVoteKey);
2137 	}
2138 
2139 	function getAlreadyVoteKey(
2140 		address _sender,
2141 		address _target,
2142 		address _property
2143 	) private pure returns (bytes32) {
2144 		return
2145 			keccak256(
2146 				abi.encodePacked("_alreadyVote", _sender, _target, _property)
2147 			);
2148 	}
2149 
2150 	// Agree Count
2151 	function getAgreeCount(address _sender) external view returns (uint256) {
2152 		return eternalStorage().getUint(getAgreeVoteCountKey(_sender));
2153 	}
2154 
2155 	function setAgreeCount(address _sender, uint256 count)
2156 		external
2157 		returns (uint256)
2158 	{
2159 		addressValidator().validateAddress(msg.sender, config().voteCounter());
2160 
2161 		eternalStorage().setUint(getAgreeVoteCountKey(_sender), count);
2162 	}
2163 
2164 	function getAgreeVoteCountKey(address _sender)
2165 		private
2166 		pure
2167 		returns (bytes32)
2168 	{
2169 		return keccak256(abi.encodePacked(_sender, "_agreeVoteCount"));
2170 	}
2171 
2172 	// Opposite Count
2173 	function getOppositeCount(address _sender) external view returns (uint256) {
2174 		return eternalStorage().getUint(getOppositeVoteCountKey(_sender));
2175 	}
2176 
2177 	function setOppositeCount(address _sender, uint256 count)
2178 		external
2179 		returns (uint256)
2180 	{
2181 		addressValidator().validateAddress(msg.sender, config().voteCounter());
2182 
2183 		eternalStorage().setUint(getOppositeVoteCountKey(_sender), count);
2184 	}
2185 
2186 	function getOppositeVoteCountKey(address _sender)
2187 		private
2188 		pure
2189 		returns (bytes32)
2190 	{
2191 		return keccak256(abi.encodePacked(_sender, "_oppositeVoteCount"));
2192 	}
2193 }
2194 
2195 
2196 contract VoteCounter is UsingConfig, UsingValidator, Killable {
2197 	using SafeMath for uint256;
2198 
2199 	// solium-disable-next-line no-empty-blocks
2200 	constructor(address _config) public UsingConfig(_config) {}
2201 
2202 	function addVoteCount(address _user, address _property, bool _agree)
2203 		external
2204 	{
2205 		addressValidator().validateGroups(
2206 			msg.sender,
2207 			config().marketGroup(),
2208 			config().policyGroup()
2209 		);
2210 
2211 		bool alreadyVote = getStorage().getAlreadyVoteFlg(
2212 			_user,
2213 			msg.sender,
2214 			_property
2215 		);
2216 		require(alreadyVote == false, "already vote");
2217 		uint256 voteCount = getVoteCount(_user, _property);
2218 		require(voteCount != 0, "vote count is 0");
2219 		getStorage().setAlreadyVoteFlg(_user, msg.sender, _property);
2220 		if (_agree) {
2221 			addAgreeCount(msg.sender, voteCount);
2222 		} else {
2223 			addOppositeCount(msg.sender, voteCount);
2224 		}
2225 	}
2226 
2227 	function getAgreeCount(address _sender) external view returns (uint256) {
2228 		return getStorage().getAgreeCount(_sender);
2229 	}
2230 
2231 	function getOppositeCount(address _sender) external view returns (uint256) {
2232 		return getStorage().getOppositeCount(_sender);
2233 	}
2234 
2235 	function getVoteCount(address _sender, address _property)
2236 		private
2237 		returns (uint256)
2238 	{
2239 		uint256 voteCount;
2240 		if (Property(_property).author() == _sender) {
2241 			// solium-disable-next-line operator-whitespace
2242 			voteCount = Lockup(config().lockup())
2243 				.getPropertyValue(_property)
2244 				.add(
2245 				Allocator(config().allocator()).getRewardsAmount(_property)
2246 			);
2247 			VoteTimes(config().voteTimes()).addVoteTimesByProperty(_property);
2248 		} else {
2249 			voteCount = Lockup(config().lockup()).getValue(_property, _sender);
2250 		}
2251 		return voteCount;
2252 	}
2253 
2254 	function addAgreeCount(address _target, uint256 _voteCount) private {
2255 		uint256 agreeCount = getStorage().getAgreeCount(_target);
2256 		agreeCount = agreeCount.add(_voteCount);
2257 		getStorage().setAgreeCount(_target, agreeCount);
2258 	}
2259 
2260 	function addOppositeCount(address _target, uint256 _voteCount) private {
2261 		uint256 oppositeCount = getStorage().getOppositeCount(_target);
2262 		oppositeCount = oppositeCount.add(_voteCount);
2263 		getStorage().setOppositeCount(_target, oppositeCount);
2264 	}
2265 
2266 	function getStorage() private view returns (VoteCounterStorage) {
2267 		return VoteCounterStorage(config().voteCounterStorage());
2268 	}
2269 }
2270 
2271 
2272 contract IMarket {
2273 	function calculate(address _metrics, uint256 _start, uint256 _end)
2274 		external
2275 		returns (bool);
2276 
2277 	function authenticate(
2278 		address _prop,
2279 		string memory _args1,
2280 		string memory _args2,
2281 		string memory _args3,
2282 		string memory _args4,
2283 		string memory _args5
2284 	)
2285 		public
2286 		returns (
2287 			// solium-disable-next-line indentation
2288 			address
2289 		);
2290 
2291 	function getAuthenticationFee(address _property)
2292 		private
2293 		view
2294 		returns (uint256);
2295 
2296 	function authenticatedCallback(address _property, bytes32 _idHash)
2297 		external
2298 		returns (address);
2299 
2300 	function vote(address _property, bool _agree) external;
2301 
2302 	function schema() external view returns (string memory);
2303 }
2304 
2305 
2306 contract IMarketBehavior {
2307 	string public schema;
2308 
2309 	function authenticate(
2310 		address _prop,
2311 		string calldata _args1,
2312 		string calldata _args2,
2313 		string calldata _args3,
2314 		string calldata _args4,
2315 		string calldata _args5,
2316 		address market
2317 	)
2318 		external
2319 		returns (
2320 			// solium-disable-next-line indentation
2321 			address
2322 		);
2323 
2324 	function calculate(address _metrics, uint256 _start, uint256 _end)
2325 		external
2326 		returns (bool);
2327 }
2328 
2329 
2330 
2331 contract Metrics {
2332 	address public market;
2333 	address public property;
2334 
2335 	constructor(address _market, address _property) public {
2336 		//Do not validate because there is no AddressConfig
2337 		market = _market;
2338 		property = _property;
2339 	}
2340 }
2341 
2342 
2343 
2344 contract MetricsGroup is
2345 	UsingConfig,
2346 	UsingStorage,
2347 	UsingValidator,
2348 	IGroup,
2349 	Killable
2350 {
2351 	using SafeMath for uint256;
2352 
2353 	// solium-disable-next-line no-empty-blocks
2354 	constructor(address _config) public UsingConfig(_config) {}
2355 
2356 	function addGroup(address _addr) external {
2357 		addressValidator().validateAddress(
2358 			msg.sender,
2359 			config().metricsFactory()
2360 		);
2361 
2362 		require(isGroup(_addr) == false, "already enabled");
2363 		eternalStorage().setBool(getGroupKey(_addr), true);
2364 		uint256 totalCount = eternalStorage().getUint(getTotalCountKey());
2365 		totalCount = totalCount.add(1);
2366 		eternalStorage().setUint(getTotalCountKey(), totalCount);
2367 	}
2368 
2369 	function isGroup(address _addr) public view returns (bool) {
2370 		return eternalStorage().getBool(getGroupKey(_addr));
2371 	}
2372 
2373 	function totalIssuedMetrics() external view returns (uint256) {
2374 		return eternalStorage().getUint(getTotalCountKey());
2375 	}
2376 
2377 	function getTotalCountKey() private pure returns (bytes32) {
2378 		return keccak256(abi.encodePacked("_totalCount"));
2379 	}
2380 }
2381 
2382 
2383 contract MetricsFactory is Pausable, UsingConfig, UsingValidator, Killable {
2384 	event Create(address indexed _from, address _metrics);
2385 
2386 	// solium-disable-next-line no-empty-blocks
2387 	constructor(address _config) public UsingConfig(_config) {}
2388 
2389 	function create(address _property) external returns (address) {
2390 		require(paused() == false, "You cannot use that");
2391 		addressValidator().validateGroup(msg.sender, config().marketGroup());
2392 
2393 		Metrics metrics = new Metrics(msg.sender, _property);
2394 		MetricsGroup metricsGroup = MetricsGroup(config().metricsGroup());
2395 		address metricsAddress = address(metrics);
2396 		metricsGroup.addGroup(metricsAddress);
2397 		emit Create(msg.sender, metricsAddress);
2398 		return metricsAddress;
2399 	}
2400 }
2401 
2402 // prettier-ignore
2403 // prettier-ignore
2404 // prettier-ignore
2405 
2406 
2407 /**
2408  * @dev Extension of {ERC20} that allows token holders to destroy both their own
2409  * tokens and those that they have an allowance for, in a way that can be
2410  * recognized off-chain (via event analysis).
2411  */
2412 contract ERC20Burnable is Context, ERC20 {
2413     /**
2414      * @dev Destroys `amount` tokens from the caller.
2415      *
2416      * See {ERC20-_burn}.
2417      */
2418     function burn(uint256 amount) public {
2419         _burn(_msgSender(), amount);
2420     }
2421 
2422     /**
2423      * @dev See {ERC20-_burnFrom}.
2424      */
2425     function burnFrom(address account, uint256 amount) public {
2426         _burnFrom(account, amount);
2427     }
2428 }
2429 
2430 
2431 contract Dev is
2432 	ERC20Detailed,
2433 	ERC20Mintable,
2434 	ERC20Burnable,
2435 	UsingConfig,
2436 	UsingValidator
2437 {
2438 	constructor(address _config)
2439 		public
2440 		ERC20Detailed("Dev", "DEV", 18)
2441 		UsingConfig(_config)
2442 	{}
2443 
2444 	function deposit(address _to, uint256 _amount) external returns (bool) {
2445 		require(transfer(_to, _amount), "dev transfer failed");
2446 		lock(msg.sender, _to, _amount);
2447 		return true;
2448 	}
2449 
2450 	function depositFrom(address _from, address _to, uint256 _amount)
2451 		external
2452 		returns (bool)
2453 	{
2454 		require(transferFrom(_from, _to, _amount), "dev transferFrom failed");
2455 		lock(_from, _to, _amount);
2456 		return true;
2457 	}
2458 
2459 	function fee(address _from, uint256 _amount) external returns (bool) {
2460 		addressValidator().validateGroup(msg.sender, config().marketGroup());
2461 		_burn(_from, _amount);
2462 		return true;
2463 	}
2464 
2465 	function lock(address _from, address _to, uint256 _amount) private {
2466 		Lockup(config().lockup()).lockup(_from, _to, _amount);
2467 	}
2468 }
2469 
2470 
2471 contract Market is UsingConfig, IMarket, UsingValidator {
2472 	using SafeMath for uint256;
2473 	bool public enabled;
2474 	address public behavior;
2475 	uint256 private _votingEndBlockNumber;
2476 	uint256 public issuedMetrics;
2477 	mapping(bytes32 => bool) private idMap;
2478 
2479 	constructor(address _config, address _behavior)
2480 		public
2481 		UsingConfig(_config)
2482 	{
2483 		addressValidator().validateAddress(
2484 			msg.sender,
2485 			config().marketFactory()
2486 		);
2487 
2488 		behavior = _behavior;
2489 		enabled = false;
2490 		uint256 marketVotingBlocks = Policy(config().policy())
2491 			.marketVotingBlocks();
2492 		_votingEndBlockNumber = block.number.add(marketVotingBlocks);
2493 	}
2494 
2495 	function toEnable() external {
2496 		addressValidator().validateAddress(
2497 			msg.sender,
2498 			config().marketFactory()
2499 		);
2500 		enabled = true;
2501 	}
2502 
2503 	function calculate(address _metrics, uint256 _start, uint256 _end)
2504 		external
2505 		returns (bool)
2506 	{
2507 		addressValidator().validateAddress(msg.sender, config().allocator());
2508 
2509 		return IMarketBehavior(behavior).calculate(_metrics, _start, _end);
2510 	}
2511 
2512 	function authenticate(
2513 		address _prop,
2514 		string memory _args1,
2515 		string memory _args2,
2516 		string memory _args3,
2517 		string memory _args4,
2518 		string memory _args5
2519 	) public returns (address) {
2520 		addressValidator().validateAddress(
2521 			msg.sender,
2522 			Property(_prop).author()
2523 		);
2524 		require(enabled, "market is not enabled");
2525 
2526 		uint256 len = bytes(_args1).length;
2527 		require(len > 0, "id is required");
2528 
2529 		return
2530 			IMarketBehavior(behavior).authenticate(
2531 				_prop,
2532 				_args1,
2533 				_args2,
2534 				_args3,
2535 				_args4,
2536 				_args5,
2537 				address(this)
2538 			);
2539 	}
2540 
2541 	function getAuthenticationFee(address _property)
2542 		private
2543 		view
2544 		returns (uint256)
2545 	{
2546 		uint256 tokenValue = Lockup(config().lockup()).getPropertyValue(
2547 			_property
2548 		);
2549 		Policy policy = Policy(config().policy());
2550 		MetricsGroup metricsGroup = MetricsGroup(config().metricsGroup());
2551 		return
2552 			policy.authenticationFee(
2553 				metricsGroup.totalIssuedMetrics(),
2554 				tokenValue
2555 			);
2556 	}
2557 
2558 	function authenticatedCallback(address _property, bytes32 _idHash)
2559 		external
2560 		returns (address)
2561 	{
2562 		addressValidator().validateAddress(msg.sender, behavior);
2563 		require(enabled, "market is not enabled");
2564 
2565 		require(idMap[_idHash] == false, "id is duplicated");
2566 		idMap[_idHash] = true;
2567 		address sender = Property(_property).author();
2568 		MetricsFactory metricsFactory = MetricsFactory(
2569 			config().metricsFactory()
2570 		);
2571 		address metrics = metricsFactory.create(_property);
2572 		uint256 authenticationFee = getAuthenticationFee(_property);
2573 		require(
2574 			Dev(config().token()).fee(sender, authenticationFee),
2575 			"dev fee failed"
2576 		);
2577 		issuedMetrics = issuedMetrics.add(1);
2578 		return metrics;
2579 	}
2580 
2581 	function vote(address _property, bool _agree) external {
2582 		addressValidator().validateGroup(_property, config().propertyGroup());
2583 		require(enabled == false, "market is already enabled");
2584 		require(
2585 			block.number <= _votingEndBlockNumber,
2586 			"voting deadline is over"
2587 		);
2588 
2589 		VoteCounter voteCounter = VoteCounter(config().voteCounter());
2590 		voteCounter.addVoteCount(msg.sender, _property, _agree);
2591 		enabled = Policy(config().policy()).marketApproval(
2592 			voteCounter.getAgreeCount(address(this)),
2593 			voteCounter.getOppositeCount(address(this))
2594 		);
2595 	}
2596 
2597 	function schema() external view returns (string memory) {
2598 		return IMarketBehavior(behavior).schema();
2599 	}
2600 }
2601 
2602 // prettier-ignore
2603 
2604 
2605 
2606 contract WithdrawStorage is
2607 	UsingStorage,
2608 	UsingConfig,
2609 	UsingValidator,
2610 	Killable
2611 {
2612 	// solium-disable-next-line no-empty-blocks
2613 	constructor(address _config) public UsingConfig(_config) {}
2614 
2615 	// RewardsAmount
2616 	function setRewardsAmount(address _property, uint256 _value) external {
2617 		addressValidator().validateAddress(msg.sender, config().withdraw());
2618 
2619 		eternalStorage().setUint(getRewardsAmountKey(_property), _value);
2620 	}
2621 
2622 	function getRewardsAmount(address _property)
2623 		external
2624 		view
2625 		returns (uint256)
2626 	{
2627 		return eternalStorage().getUint(getRewardsAmountKey(_property));
2628 	}
2629 
2630 	function getRewardsAmountKey(address _property)
2631 		private
2632 		pure
2633 		returns (bytes32)
2634 	{
2635 		return keccak256(abi.encodePacked("_rewardsAmount", _property));
2636 	}
2637 
2638 	// CumulativePrice
2639 	function setCumulativePrice(address _property, uint256 _value)
2640 		external
2641 		returns (uint256)
2642 	{
2643 		addressValidator().validateAddress(msg.sender, config().withdraw());
2644 
2645 		eternalStorage().setUint(getCumulativePriceKey(_property), _value);
2646 	}
2647 
2648 	function getCumulativePrice(address _property)
2649 		external
2650 		view
2651 		returns (uint256)
2652 	{
2653 		return eternalStorage().getUint(getCumulativePriceKey(_property));
2654 	}
2655 
2656 	function getCumulativePriceKey(address _property)
2657 		private
2658 		pure
2659 		returns (bytes32)
2660 	{
2661 		return keccak256(abi.encodePacked("_cumulativePrice", _property));
2662 	}
2663 
2664 	// WithdrawalLimitTotal
2665 	function setWithdrawalLimitTotal(
2666 		address _property,
2667 		address _user,
2668 		uint256 _value
2669 	) external {
2670 		addressValidator().validateAddress(msg.sender, config().withdraw());
2671 
2672 		eternalStorage().setUint(
2673 			getWithdrawalLimitTotalKey(_property, _user),
2674 			_value
2675 		);
2676 	}
2677 
2678 	function getWithdrawalLimitTotal(address _property, address _user)
2679 		external
2680 		view
2681 		returns (uint256)
2682 	{
2683 		return
2684 			eternalStorage().getUint(
2685 				getWithdrawalLimitTotalKey(_property, _user)
2686 			);
2687 	}
2688 
2689 	function getWithdrawalLimitTotalKey(address _property, address _user)
2690 		private
2691 		pure
2692 		returns (bytes32)
2693 	{
2694 		return
2695 			keccak256(
2696 				abi.encodePacked("_withdrawalLimitTotal", _property, _user)
2697 			);
2698 	}
2699 
2700 	// WithdrawalLimitBalance
2701 	function setWithdrawalLimitBalance(
2702 		address _property,
2703 		address _user,
2704 		uint256 _value
2705 	) external {
2706 		addressValidator().validateAddress(msg.sender, config().withdraw());
2707 
2708 		eternalStorage().setUint(
2709 			getWithdrawalLimitBalanceKey(_property, _user),
2710 			_value
2711 		);
2712 	}
2713 
2714 	function getWithdrawalLimitBalance(address _property, address _user)
2715 		external
2716 		view
2717 		returns (uint256)
2718 	{
2719 		return
2720 			eternalStorage().getUint(
2721 				getWithdrawalLimitBalanceKey(_property, _user)
2722 			);
2723 	}
2724 
2725 	function getWithdrawalLimitBalanceKey(address _property, address _user)
2726 		private
2727 		pure
2728 		returns (bytes32)
2729 	{
2730 		return
2731 			keccak256(
2732 				abi.encodePacked("_withdrawalLimitBalance", _property, _user)
2733 			);
2734 	}
2735 
2736 	//LastWithdrawalPrice
2737 	function setLastWithdrawalPrice(
2738 		address _property,
2739 		address _user,
2740 		uint256 _value
2741 	) external {
2742 		addressValidator().validateAddress(msg.sender, config().withdraw());
2743 
2744 		eternalStorage().setUint(
2745 			getLastWithdrawalPriceKey(_property, _user),
2746 			_value
2747 		);
2748 	}
2749 
2750 	function getLastWithdrawalPrice(address _property, address _user)
2751 		external
2752 		view
2753 		returns (uint256)
2754 	{
2755 		return
2756 			eternalStorage().getUint(
2757 				getLastWithdrawalPriceKey(_property, _user)
2758 			);
2759 	}
2760 
2761 	function getLastWithdrawalPriceKey(address _property, address _user)
2762 		private
2763 		pure
2764 		returns (bytes32)
2765 	{
2766 		return
2767 			keccak256(
2768 				abi.encodePacked("_lastWithdrawalPrice", _property, _user)
2769 			);
2770 	}
2771 
2772 	//PendingWithdrawal
2773 	function setPendingWithdrawal(
2774 		address _property,
2775 		address _user,
2776 		uint256 _value
2777 	) external {
2778 		addressValidator().validateAddress(msg.sender, config().withdraw());
2779 
2780 		eternalStorage().setUint(
2781 			getPendingWithdrawalKey(_property, _user),
2782 			_value
2783 		);
2784 	}
2785 
2786 	function getPendingWithdrawal(address _property, address _user)
2787 		external
2788 		view
2789 		returns (uint256)
2790 	{
2791 		return
2792 			eternalStorage().getUint(getPendingWithdrawalKey(_property, _user));
2793 	}
2794 
2795 	function getPendingWithdrawalKey(address _property, address _user)
2796 		private
2797 		pure
2798 		returns (bytes32)
2799 	{
2800 		return
2801 			keccak256(abi.encodePacked("_pendingWithdrawal", _property, _user));
2802 	}
2803 }
2804 
2805 
2806 contract Withdraw is Pausable, UsingConfig, UsingValidator, Killable {
2807 	using SafeMath for uint256;
2808 	using Decimals for uint256;
2809 
2810 	// solium-disable-next-line no-empty-blocks
2811 	constructor(address _config) public UsingConfig(_config) {}
2812 
2813 	function withdraw(address _property) external {
2814 		require(paused() == false, "You cannot use that");
2815 		addressValidator().validateGroup(_property, config().propertyGroup());
2816 
2817 		uint256 value = _calculateWithdrawableAmount(_property, msg.sender);
2818 		require(value != 0, "withdraw value is 0");
2819 		uint256 price = getStorage().getCumulativePrice(_property);
2820 		getStorage().setLastWithdrawalPrice(_property, msg.sender, price);
2821 		getStorage().setPendingWithdrawal(_property, msg.sender, 0);
2822 		ERC20Mintable erc20 = ERC20Mintable(config().token());
2823 		require(erc20.mint(msg.sender, value), "dev mint failed");
2824 	}
2825 
2826 	function beforeBalanceChange(address _property, address _from, address _to)
2827 		external
2828 	{
2829 		addressValidator().validateAddress(msg.sender, config().allocator());
2830 
2831 		uint256 price = getStorage().getCumulativePrice(_property);
2832 		uint256 amountFrom = _calculateAmount(_property, _from);
2833 		uint256 amountTo = _calculateAmount(_property, _to);
2834 		getStorage().setLastWithdrawalPrice(_property, _from, price);
2835 		getStorage().setLastWithdrawalPrice(_property, _to, price);
2836 		uint256 pendFrom = getStorage().getPendingWithdrawal(_property, _from);
2837 		uint256 pendTo = getStorage().getPendingWithdrawal(_property, _to);
2838 		getStorage().setPendingWithdrawal(
2839 			_property,
2840 			_from,
2841 			pendFrom.add(amountFrom)
2842 		);
2843 		getStorage().setPendingWithdrawal(_property, _to, pendTo.add(amountTo));
2844 		uint256 totalLimit = getStorage().getWithdrawalLimitTotal(
2845 			_property,
2846 			_to
2847 		);
2848 		uint256 total = getStorage().getRewardsAmount(_property);
2849 		if (totalLimit != total) {
2850 			getStorage().setWithdrawalLimitTotal(_property, _to, total);
2851 			getStorage().setWithdrawalLimitBalance(
2852 				_property,
2853 				_to,
2854 				ERC20(_property).balanceOf(_to)
2855 			);
2856 		}
2857 	}
2858 
2859 	function increment(address _property, uint256 _allocationResult) external {
2860 		addressValidator().validateAddress(msg.sender, config().allocator());
2861 		uint256 priceValue = _allocationResult.outOf(
2862 			ERC20(_property).totalSupply()
2863 		);
2864 		uint256 total = getStorage().getRewardsAmount(_property);
2865 		getStorage().setRewardsAmount(_property, total.add(_allocationResult));
2866 		uint256 price = getStorage().getCumulativePrice(_property);
2867 		getStorage().setCumulativePrice(_property, price.add(priceValue));
2868 	}
2869 
2870 	function getRewardsAmount(address _property)
2871 		external
2872 		view
2873 		returns (uint256)
2874 	{
2875 		return getStorage().getRewardsAmount(_property);
2876 	}
2877 
2878 	function _calculateAmount(address _property, address _user)
2879 		private
2880 		view
2881 		returns (uint256)
2882 	{
2883 		uint256 _last = getStorage().getLastWithdrawalPrice(_property, _user);
2884 		uint256 totalLimit = getStorage().getWithdrawalLimitTotal(
2885 			_property,
2886 			_user
2887 		);
2888 		uint256 balanceLimit = getStorage().getWithdrawalLimitBalance(
2889 			_property,
2890 			_user
2891 		);
2892 		uint256 price = getStorage().getCumulativePrice(_property);
2893 		uint256 priceGap = price.sub(_last);
2894 		uint256 balance = ERC20(_property).balanceOf(_user);
2895 		uint256 total = getStorage().getRewardsAmount(_property);
2896 		if (totalLimit == total) {
2897 			balance = balanceLimit;
2898 		}
2899 		uint256 value = priceGap.mul(balance);
2900 		return value.div(Decimals.basis());
2901 	}
2902 
2903 	function calculateAmount(address _property, address _user)
2904 		external
2905 		view
2906 		returns (uint256)
2907 	{
2908 		return _calculateAmount(_property, _user);
2909 	}
2910 
2911 	function _calculateWithdrawableAmount(address _property, address _user)
2912 		private
2913 		view
2914 		returns (uint256)
2915 	{
2916 		uint256 _value = _calculateAmount(_property, _user);
2917 		uint256 value = _value.add(
2918 			getStorage().getPendingWithdrawal(_property, _user)
2919 		);
2920 		return value;
2921 	}
2922 
2923 	function calculateWithdrawableAmount(address _property, address _user)
2924 		external
2925 		view
2926 		returns (uint256)
2927 	{
2928 		return _calculateWithdrawableAmount(_property, _user);
2929 	}
2930 
2931 	function getStorage() private view returns (WithdrawStorage) {
2932 		return WithdrawStorage(config().withdrawStorage());
2933 	}
2934 }
2935 
2936 
2937 
2938 contract AllocatorStorage is
2939 	UsingStorage,
2940 	UsingConfig,
2941 	UsingValidator,
2942 	Killable
2943 {
2944 	constructor(address _config) public UsingConfig(_config) UsingStorage() {}
2945 
2946 	// Last Block Number
2947 	function setLastBlockNumber(address _metrics, uint256 _blocks) external {
2948 		addressValidator().validateAddress(msg.sender, config().allocator());
2949 
2950 		eternalStorage().setUint(getLastBlockNumberKey(_metrics), _blocks);
2951 	}
2952 
2953 	function getLastBlockNumber(address _metrics)
2954 		external
2955 		view
2956 		returns (uint256)
2957 	{
2958 		return eternalStorage().getUint(getLastBlockNumberKey(_metrics));
2959 	}
2960 
2961 	function getLastBlockNumberKey(address _metrics)
2962 		private
2963 		pure
2964 		returns (bytes32)
2965 	{
2966 		return keccak256(abi.encodePacked("_lastBlockNumber", _metrics));
2967 	}
2968 
2969 	// Base Block Number
2970 	function setBaseBlockNumber(uint256 _blockNumber) external {
2971 		addressValidator().validateAddress(msg.sender, config().allocator());
2972 
2973 		eternalStorage().setUint(getBaseBlockNumberKey(), _blockNumber);
2974 	}
2975 
2976 	function getBaseBlockNumber() external view returns (uint256) {
2977 		return eternalStorage().getUint(getBaseBlockNumberKey());
2978 	}
2979 
2980 	function getBaseBlockNumberKey() private pure returns (bytes32) {
2981 		return keccak256(abi.encodePacked("_baseBlockNumber"));
2982 	}
2983 
2984 	// PendingIncrement
2985 	function setPendingIncrement(address _metrics, bool value) external {
2986 		addressValidator().validateAddress(msg.sender, config().allocator());
2987 
2988 		eternalStorage().setBool(getPendingIncrementKey(_metrics), value);
2989 	}
2990 
2991 	function getPendingIncrement(address _metrics)
2992 		external
2993 		view
2994 		returns (bool)
2995 	{
2996 		return eternalStorage().getBool(getPendingIncrementKey(_metrics));
2997 	}
2998 
2999 	function getPendingIncrementKey(address _metrics)
3000 		private
3001 		pure
3002 		returns (bytes32)
3003 	{
3004 		return keccak256(abi.encodePacked("_pendingIncrement", _metrics));
3005 	}
3006 
3007 	// LastAllocationBlockEachMetrics
3008 	function setLastAllocationBlockEachMetrics(
3009 		address _metrics,
3010 		uint256 blockNumber
3011 	) external {
3012 		addressValidator().validateAddress(msg.sender, config().allocator());
3013 
3014 		eternalStorage().setUint(
3015 			getLastAllocationBlockEachMetricsKey(_metrics),
3016 			blockNumber
3017 		);
3018 	}
3019 
3020 	function getLastAllocationBlockEachMetrics(address _metrics)
3021 		external
3022 		view
3023 		returns (uint256)
3024 	{
3025 		return
3026 			eternalStorage().getUint(
3027 				getLastAllocationBlockEachMetricsKey(_metrics)
3028 			);
3029 	}
3030 
3031 	function getLastAllocationBlockEachMetricsKey(address _addr)
3032 		private
3033 		pure
3034 		returns (bytes32)
3035 	{
3036 		return
3037 			keccak256(
3038 				abi.encodePacked("_lastAllocationBlockEachMetrics", _addr)
3039 			);
3040 	}
3041 
3042 	// LastAssetValueEachMetrics
3043 	function setLastAssetValueEachMetrics(address _metrics, uint256 value)
3044 		external
3045 	{
3046 		addressValidator().validateAddress(msg.sender, config().allocator());
3047 
3048 		eternalStorage().setUint(
3049 			getLastAssetValueEachMetricsKey(_metrics),
3050 			value
3051 		);
3052 	}
3053 
3054 	function getLastAssetValueEachMetrics(address _metrics)
3055 		external
3056 		view
3057 		returns (uint256)
3058 	{
3059 		return
3060 			eternalStorage().getUint(getLastAssetValueEachMetricsKey(_metrics));
3061 	}
3062 
3063 	function getLastAssetValueEachMetricsKey(address _addr)
3064 		private
3065 		pure
3066 		returns (bytes32)
3067 	{
3068 		return keccak256(abi.encodePacked("_lastAssetValueEachMetrics", _addr));
3069 	}
3070 
3071 	// lastAssetValueEachMarketPerBlock
3072 	function setLastAssetValueEachMarketPerBlock(address _market, uint256 value)
3073 		external
3074 	{
3075 		addressValidator().validateAddress(msg.sender, config().allocator());
3076 
3077 		eternalStorage().setUint(
3078 			getLastAssetValueEachMarketPerBlockKey(_market),
3079 			value
3080 		);
3081 	}
3082 
3083 	function getLastAssetValueEachMarketPerBlock(address _market)
3084 		external
3085 		view
3086 		returns (uint256)
3087 	{
3088 		return
3089 			eternalStorage().getUint(
3090 				getLastAssetValueEachMarketPerBlockKey(_market)
3091 			);
3092 	}
3093 
3094 	function getLastAssetValueEachMarketPerBlockKey(address _addr)
3095 		private
3096 		pure
3097 		returns (bytes32)
3098 	{
3099 		return
3100 			keccak256(
3101 				abi.encodePacked("_lastAssetValueEachMarketPerBlock", _addr)
3102 			);
3103 	}
3104 }
3105 
3106 
3107 contract Allocator is
3108 	Killable,
3109 	Ownable,
3110 	UsingConfig,
3111 	IAllocator,
3112 	UsingValidator
3113 {
3114 	using SafeMath for uint256;
3115 	using Decimals for uint256;
3116 	event BeforeAllocation(
3117 		uint256 _blocks,
3118 		uint256 _mint,
3119 		uint256 _value,
3120 		uint256 _marketValue,
3121 		uint256 _assets,
3122 		uint256 _totalAssets
3123 	);
3124 
3125 	uint64 public constant basis = 1000000000000000000;
3126 
3127 	// solium-disable-next-line no-empty-blocks
3128 	constructor(address _config) public UsingConfig(_config) {}
3129 
3130 	function allocate(address _metrics) external {
3131 		addressValidator().validateGroup(_metrics, config().metricsGroup());
3132 
3133 		validateTargetPeriod(_metrics);
3134 		address market = Metrics(_metrics).market();
3135 		getStorage().setPendingIncrement(_metrics, true);
3136 		Market(market).calculate(
3137 			_metrics,
3138 			getLastAllocationBlockNumber(_metrics),
3139 			block.number
3140 		);
3141 		getStorage().setLastBlockNumber(_metrics, block.number);
3142 	}
3143 
3144 	function calculatedCallback(address _metrics, uint256 _value) external {
3145 		addressValidator().validateGroup(_metrics, config().metricsGroup());
3146 
3147 		Metrics metrics = Metrics(_metrics);
3148 		Market market = Market(metrics.market());
3149 		require(
3150 			msg.sender == market.behavior(),
3151 			"don't call from other than market behavior"
3152 		);
3153 		require(
3154 			getStorage().getPendingIncrement(_metrics),
3155 			"not asking for an indicator"
3156 		);
3157 		Policy policy = Policy(config().policy());
3158 		uint256 totalAssets = MetricsGroup(config().metricsGroup())
3159 			.totalIssuedMetrics();
3160 		uint256 lockupValue = Lockup(config().lockup()).getPropertyValue(
3161 			metrics.property()
3162 		);
3163 		uint256 blocks = block.number.sub(
3164 			getStorage().getLastAllocationBlockEachMetrics(_metrics)
3165 		);
3166 		uint256 mint = policy.rewards(lockupValue, totalAssets);
3167 		uint256 value = (policy.assetValue(_value, lockupValue).mul(basis)).div(
3168 			blocks
3169 		);
3170 		uint256 marketValue = getStorage()
3171 			.getLastAssetValueEachMarketPerBlock(metrics.market())
3172 			.sub(getStorage().getLastAssetValueEachMetrics(_metrics))
3173 			.add(value);
3174 		uint256 assets = market.issuedMetrics();
3175 		getStorage().setLastAllocationBlockEachMetrics(_metrics, block.number);
3176 		getStorage().setLastAssetValueEachMetrics(_metrics, value);
3177 		getStorage().setLastAssetValueEachMarketPerBlock(
3178 			metrics.market(),
3179 			marketValue
3180 		);
3181 		emit BeforeAllocation(
3182 			blocks,
3183 			mint,
3184 			value,
3185 			marketValue,
3186 			assets,
3187 			totalAssets
3188 		);
3189 		uint256 result = allocation(
3190 			blocks,
3191 			mint,
3192 			value,
3193 			marketValue,
3194 			assets,
3195 			totalAssets
3196 		);
3197 		increment(metrics.property(), result, lockupValue);
3198 		getStorage().setPendingIncrement(_metrics, false);
3199 	}
3200 
3201 	function increment(address _property, uint256 _reward, uint256 _lockup)
3202 		private
3203 	{
3204 		uint256 holders = Policy(config().policy()).holdersShare(
3205 			_reward,
3206 			_lockup
3207 		);
3208 		uint256 interest = _reward.sub(holders);
3209 		Withdraw(config().withdraw()).increment(_property, holders);
3210 		Lockup(config().lockup()).increment(_property, interest);
3211 	}
3212 
3213 	function beforeBalanceChange(address _property, address _from, address _to)
3214 		external
3215 	{
3216 		addressValidator().validateGroup(msg.sender, config().propertyGroup());
3217 
3218 		Withdraw(config().withdraw()).beforeBalanceChange(
3219 			_property,
3220 			_from,
3221 			_to
3222 		);
3223 	}
3224 
3225 	function getRewardsAmount(address _property)
3226 		external
3227 		view
3228 		returns (uint256)
3229 	{
3230 		return Withdraw(config().withdraw()).getRewardsAmount(_property);
3231 	}
3232 
3233 	function allocation(
3234 		uint256 _blocks,
3235 		uint256 _mint,
3236 		uint256 _value,
3237 		uint256 _marketValue,
3238 		uint256 _assets,
3239 		uint256 _totalAssets
3240 	) public pure returns (uint256) {
3241 		uint256 aShare = _totalAssets > 0
3242 			? _assets.outOf(_totalAssets)
3243 			: Decimals.basis();
3244 		uint256 vShare = _marketValue > 0
3245 			? _value.outOf(_marketValue)
3246 			: Decimals.basis();
3247 		uint256 mint = _mint.mul(_blocks);
3248 		return
3249 			mint.mul(aShare).mul(vShare).div(Decimals.basis()).div(
3250 				Decimals.basis()
3251 			);
3252 	}
3253 
3254 	function validateTargetPeriod(address _metrics) private {
3255 		address property = Metrics(_metrics).property();
3256 		VoteTimes voteTimes = VoteTimes(config().voteTimes());
3257 		uint256 abstentionCount = voteTimes.getAbstentionTimes(property);
3258 		uint256 notTargetPeriod = Policy(config().policy()).abstentionPenalty(
3259 			abstentionCount
3260 		);
3261 		if (notTargetPeriod == 0) {
3262 			return;
3263 		}
3264 		uint256 blockNumber = getLastAllocationBlockNumber(_metrics);
3265 		uint256 notTargetBlockNumber = blockNumber.add(notTargetPeriod);
3266 		require(
3267 			notTargetBlockNumber < block.number,
3268 			"outside the target period"
3269 		);
3270 		getStorage().setLastBlockNumber(_metrics, notTargetBlockNumber);
3271 		voteTimes.resetVoteTimesByProperty(property);
3272 	}
3273 
3274 	function getLastAllocationBlockNumber(address _metrics)
3275 		private
3276 		returns (uint256)
3277 	{
3278 		uint256 blockNumber = getStorage().getLastBlockNumber(_metrics);
3279 		uint256 baseBlockNumber = getStorage().getBaseBlockNumber();
3280 		if (baseBlockNumber == 0) {
3281 			getStorage().setBaseBlockNumber(block.number);
3282 		}
3283 		uint256 lastAllocationBlockNumber = blockNumber > 0
3284 			? blockNumber
3285 			: getStorage().getBaseBlockNumber();
3286 		return lastAllocationBlockNumber;
3287 	}
3288 
3289 	function getStorage() private view returns (AllocatorStorage) {
3290 		return AllocatorStorage(config().allocatorStorage());
3291 	}
3292 }
3293 
3294 
3295 contract Property is ERC20, ERC20Detailed, UsingConfig, UsingValidator {
3296 	uint8 private constant _decimals = 18;
3297 	uint256 private constant _supply = 10000000;
3298 	address public author;
3299 
3300 	constructor(
3301 		address _config,
3302 		address _own,
3303 		string memory _name,
3304 		string memory _symbol
3305 	) public UsingConfig(_config) ERC20Detailed(_name, _symbol, _decimals) {
3306 		addressValidator().validateAddress(
3307 			msg.sender,
3308 			config().propertyFactory()
3309 		);
3310 
3311 		author = _own;
3312 		_mint(author, _supply);
3313 	}
3314 
3315 	function transfer(address _to, uint256 _value) public returns (bool) {
3316 		addressValidator().validateIllegalAddress(_to);
3317 		require(_value != 0, "illegal transfer value");
3318 
3319 		Allocator(config().allocator()).beforeBalanceChange(
3320 			address(this),
3321 			msg.sender,
3322 			_to
3323 		);
3324 		_transfer(msg.sender, _to, _value);
3325 	}
3326 
3327 	function withdraw(address _sender, uint256 _value) external {
3328 		addressValidator().validateAddress(msg.sender, config().lockup());
3329 
3330 		ERC20 devToken = ERC20(config().token());
3331 		devToken.transfer(_sender, _value);
3332 	}
3333 }
3334 
3335 
3336 contract PropertyFactory is Pausable, UsingConfig, Killable {
3337 	event Create(address indexed _from, address _property);
3338 
3339 	// solium-disable-next-line no-empty-blocks
3340 	constructor(address _config) public UsingConfig(_config) {}
3341 
3342 	function create(
3343 		string calldata _name,
3344 		string calldata _symbol,
3345 		address _author
3346 	) external returns (address) {
3347 		require(paused() == false, "You cannot use that");
3348 		validatePropertyName(_name);
3349 		validatePropertySymbol(_symbol);
3350 
3351 		Property property = new Property(
3352 			address(config()),
3353 			_author,
3354 			_name,
3355 			_symbol
3356 		);
3357 		PropertyGroup(config().propertyGroup()).addGroup(address(property));
3358 		emit Create(msg.sender, address(property));
3359 		VoteTimes(config().voteTimes()).resetVoteTimesByProperty(
3360 			address(property)
3361 		);
3362 		return address(property);
3363 	}
3364 
3365 	function validatePropertyName(string memory _name) private pure {
3366 		uint256 len = bytes(_name).length;
3367 		require(
3368 			len >= 3,
3369 			"name must be at least 3 and no more than 10 characters"
3370 		);
3371 		require(
3372 			len <= 10,
3373 			"name must be at least 3 and no more than 10 characters"
3374 		);
3375 	}
3376 
3377 	function validatePropertySymbol(string memory _symbol) private pure {
3378 		uint256 len = bytes(_symbol).length;
3379 		require(
3380 			len >= 3,
3381 			"symbol must be at least 3 and no more than 10 characters"
3382 		);
3383 		require(
3384 			len <= 10,
3385 			"symbol must be at least 3 and no more than 10 characters"
3386 		);
3387 	}
3388 }