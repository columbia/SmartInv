1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      *
56      * _Available since v2.4.0._
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      * - Multiplication cannot overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      * - The divisor cannot be zero.
113      *
114      * _Available since v2.4.0._
115      */
116     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         // Solidity only automatically asserts when dividing by 0
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         return mod(a, b, "SafeMath: modulo by zero");
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts with custom message when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      *
151      * _Available since v2.4.0._
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 /*
160  * @dev Provides information about the current execution context, including the
161  * sender of the transaction and its data. While these are generally available
162  * via msg.sender and msg.data, they should not be accessed in such a direct
163  * manner, since when dealing with GSN meta-transactions the account sending and
164  * paying for execution may not be the actual sender (as far as an application
165  * is concerned).
166  *
167  * This contract is only required for intermediate, library-like contracts.
168  */
169 contract Context {
170     // Empty internal constructor, to prevent people from mistakenly deploying
171     // an instance of this contract, which should be used via inheritance.
172     constructor () internal { }
173     // solhint-disable-previous-line no-empty-blocks
174 
175     function _msgSender() internal view returns (address payable) {
176         return msg.sender;
177     }
178 
179     function _msgData() internal view returns (bytes memory) {
180         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
181         return msg.data;
182     }
183 }
184 
185 /**
186  * @dev Contract module which provides a basic access control mechanism, where
187  * there is an account (an owner) that can be granted exclusive access to
188  * specific functions.
189  *
190  * This module is used through inheritance. It will make available the modifier
191  * `onlyOwner`, which can be applied to your functions to restrict their use to
192  * the owner.
193  */
194 contract Ownable is Context {
195     address private _owner;
196 
197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199     /**
200      * @dev Initializes the contract setting the deployer as the initial owner.
201      */
202     constructor () internal {
203         address msgSender = _msgSender();
204         _owner = msgSender;
205         emit OwnershipTransferred(address(0), msgSender);
206     }
207 
208     /**
209      * @dev Returns the address of the current owner.
210      */
211     function owner() public view returns (address) {
212         return _owner;
213     }
214 
215     /**
216      * @dev Throws if called by any account other than the owner.
217      */
218     modifier onlyOwner() {
219         require(isOwner(), "Ownable: caller is not the owner");
220         _;
221     }
222 
223     /**
224      * @dev Returns true if the caller is the current owner.
225      */
226     function isOwner() public view returns (bool) {
227         return _msgSender() == _owner;
228     }
229 
230     /**
231      * @dev Leaves the contract without owner. It will not be possible to call
232      * `onlyOwner` functions anymore. Can only be called by the current owner.
233      *
234      * NOTE: Renouncing ownership will leave the contract without an owner,
235      * thereby removing any functionality that is only available to the owner.
236      */
237     function renounceOwnership() public onlyOwner {
238         emit OwnershipTransferred(_owner, address(0));
239         _owner = address(0);
240     }
241 
242     /**
243      * @dev Transfers ownership of the contract to a new account (`newOwner`).
244      * Can only be called by the current owner.
245      */
246     function transferOwnership(address newOwner) public onlyOwner {
247         _transferOwnership(newOwner);
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      */
253     function _transferOwnership(address newOwner) internal {
254         require(newOwner != address(0), "Ownable: new owner is the zero address");
255         emit OwnershipTransferred(_owner, newOwner);
256         _owner = newOwner;
257     }
258 }
259 
260 /**
261  * @title Roles
262  * @dev Library for managing addresses assigned to a Role.
263  */
264 library Roles {
265     struct Role {
266         mapping (address => bool) bearer;
267     }
268 
269     /**
270      * @dev Give an account access to this role.
271      */
272     function add(Role storage role, address account) internal {
273         require(!has(role, account), "Roles: account already has role");
274         role.bearer[account] = true;
275     }
276 
277     /**
278      * @dev Remove an account's access to this role.
279      */
280     function remove(Role storage role, address account) internal {
281         require(has(role, account), "Roles: account does not have role");
282         role.bearer[account] = false;
283     }
284 
285     /**
286      * @dev Check if an account has this role.
287      * @return bool
288      */
289     function has(Role storage role, address account) internal view returns (bool) {
290         require(account != address(0), "Roles: account is the zero address");
291         return role.bearer[account];
292     }
293 }
294 
295 contract PauserRole is Context {
296     using Roles for Roles.Role;
297 
298     event PauserAdded(address indexed account);
299     event PauserRemoved(address indexed account);
300 
301     Roles.Role private _pausers;
302 
303     constructor () internal {
304         _addPauser(_msgSender());
305     }
306 
307     modifier onlyPauser() {
308         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
309         _;
310     }
311 
312     function isPauser(address account) public view returns (bool) {
313         return _pausers.has(account);
314     }
315 
316     function addPauser(address account) public onlyPauser {
317         _addPauser(account);
318     }
319 
320     function renouncePauser() public {
321         _removePauser(_msgSender());
322     }
323 
324     function _addPauser(address account) internal {
325         _pausers.add(account);
326         emit PauserAdded(account);
327     }
328 
329     function _removePauser(address account) internal {
330         _pausers.remove(account);
331         emit PauserRemoved(account);
332     }
333 }
334 
335 /**
336  * @dev Contract module which allows children to implement an emergency stop
337  * mechanism that can be triggered by an authorized account.
338  *
339  * This module is used through inheritance. It will make available the
340  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
341  * the functions of your contract. Note that they will not be pausable by
342  * simply including this module, only once the modifiers are put in place.
343  */
344 contract Pausable is Context, PauserRole {
345     /**
346      * @dev Emitted when the pause is triggered by a pauser (`account`).
347      */
348     event Paused(address account);
349 
350     /**
351      * @dev Emitted when the pause is lifted by a pauser (`account`).
352      */
353     event Unpaused(address account);
354 
355     bool private _paused;
356 
357     /**
358      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
359      * to the deployer.
360      */
361     constructor () internal {
362         _paused = false;
363     }
364 
365     /**
366      * @dev Returns true if the contract is paused, and false otherwise.
367      */
368     function paused() public view returns (bool) {
369         return _paused;
370     }
371 
372     /**
373      * @dev Modifier to make a function callable only when the contract is not paused.
374      */
375     modifier whenNotPaused() {
376         require(!_paused, "Pausable: paused");
377         _;
378     }
379 
380     /**
381      * @dev Modifier to make a function callable only when the contract is paused.
382      */
383     modifier whenPaused() {
384         require(_paused, "Pausable: not paused");
385         _;
386     }
387 
388     /**
389      * @dev Called by a pauser to pause, triggers stopped state.
390      */
391     function pause() public onlyPauser whenNotPaused {
392         _paused = true;
393         emit Paused(_msgSender());
394     }
395 
396     /**
397      * @dev Called by a pauser to unpause, returns to normal state.
398      */
399     function unpause() public onlyPauser whenPaused {
400         _paused = false;
401         emit Unpaused(_msgSender());
402     }
403 }
404 
405 interface IERC1155 {
406 	event TransferSingle(
407 		address indexed _operator,
408 		address indexed _from,
409 		address indexed _to,
410 		uint256 _id,
411 		uint256 _amount
412 	);
413 
414 	event TransferBatch(
415 		address indexed _operator,
416 		address indexed _from,
417 		address indexed _to,
418 		uint256[] _ids,
419 		uint256[] _amounts
420 	);
421 
422 	event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
423 
424 	event URI(string _amount, uint256 indexed _id);
425 
426 	function mint(
427 		address _to,
428 		uint256 _id,
429 		uint256 _quantity,
430 		bytes calldata _data
431 	) external;
432 
433 	function create(
434 		uint256 _maxSupply,
435 		uint256 _initialSupply,
436 		string calldata _uri,
437 		bytes calldata _data
438 	) external returns (uint256 tokenId);
439 
440 	function safeTransferFrom(
441 		address _from,
442 		address _to,
443 		uint256 _id,
444 		uint256 _amount,
445 		bytes calldata _data
446 	) external;
447 
448 	function safeBatchTransferFrom(
449 		address _from,
450 		address _to,
451 		uint256[] calldata _ids,
452 		uint256[] calldata _amounts,
453 		bytes calldata _data
454 	) external;
455 
456 	function balanceOf(address _owner, uint256 _id) external view returns (uint256);
457 
458 	function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids)
459 		external
460 		view
461 		returns (uint256[] memory);
462 
463 	function setApprovalForAll(address _operator, bool _approved) external;
464 
465 	function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
466 }
467 
468 /**
469  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
470  * the optional functions; to access them see {ERC20Detailed}.
471  */
472 interface IERC20 {
473     /**
474      * @dev Returns the amount of tokens in existence.
475      */
476     function totalSupply() external view returns (uint256);
477 
478     /**
479      * @dev Returns the amount of tokens owned by `account`.
480      */
481     function balanceOf(address account) external view returns (uint256);
482 
483     /**
484      * @dev Moves `amount` tokens from the caller's account to `recipient`.
485      *
486      * Returns a boolean value indicating whether the operation succeeded.
487      *
488      * Emits a {Transfer} event.
489      */
490     function transfer(address recipient, uint256 amount) external returns (bool);
491 
492     /**
493      * @dev Returns the remaining number of tokens that `spender` will be
494      * allowed to spend on behalf of `owner` through {transferFrom}. This is
495      * zero by default.
496      *
497      * This value changes when {approve} or {transferFrom} are called.
498      */
499     function allowance(address owner, address spender) external view returns (uint256);
500 
501     /**
502      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
503      *
504      * Returns a boolean value indicating whether the operation succeeded.
505      *
506      * IMPORTANT: Beware that changing an allowance with this method brings the risk
507      * that someone may use both the old and the new allowance by unfortunate
508      * transaction ordering. One possible solution to mitigate this race
509      * condition is to first reduce the spender's allowance to 0 and set the
510      * desired value afterwards:
511      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
512      *
513      * Emits an {Approval} event.
514      */
515     function approve(address spender, uint256 amount) external returns (bool);
516 
517     /**
518      * @dev Moves `amount` tokens from `sender` to `recipient` using the
519      * allowance mechanism. `amount` is then deducted from the caller's
520      * allowance.
521      *
522      * Returns a boolean value indicating whether the operation succeeded.
523      *
524      * Emits a {Transfer} event.
525      */
526     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
527 
528     /**
529      * @dev Emitted when `value` tokens are moved from one account (`from`) to
530      * another (`to`).
531      *
532      * Note that `value` may be zero.
533      */
534     event Transfer(address indexed from, address indexed to, uint256 value);
535 
536     /**
537      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
538      * a call to {approve}. `value` is the new allowance.
539      */
540     event Approval(address indexed owner, address indexed spender, uint256 value);
541 }
542 
543 contract PoolTokenWrapper {
544 	using SafeMath for uint256;
545 	IERC20 public token;
546 
547 	constructor(IERC20 _erc20Address) public {
548 		token = IERC20(_erc20Address);
549 	}
550 
551 	uint256 private _totalSupply;
552 	// Objects balances [id][address] => balance
553 	mapping(uint256 => mapping(address => uint256)) internal _balances;
554 	mapping(uint256 => uint256) private _poolBalances;
555 
556 	function totalSupply() public view returns (uint256) {
557 		return _totalSupply;
558 	}
559 
560 	function balanceOfPool(uint256 id) public view returns (uint256) {
561 		return _poolBalances[id];
562 	}
563 
564 	function balanceOf(address account, uint256 id) public view returns (uint256) {
565 		return _balances[id][account];
566 	}
567 
568 	function stake(uint256 id, uint256 amount) public {
569 		_totalSupply = _totalSupply.add(amount);
570 		_poolBalances[id] = _poolBalances[id].add(amount);
571 		_balances[id][msg.sender] = _balances[id][msg.sender].add(amount);
572 		token.transferFrom(msg.sender, address(this), amount);
573 	}
574 
575 	function withdraw(uint256 id, uint256 amount) public {
576 		_totalSupply = _totalSupply.sub(amount);
577 		_poolBalances[id] = _poolBalances[id].sub(amount);
578 		_balances[id][msg.sender] = _balances[id][msg.sender].sub(amount);
579 		token.transfer(msg.sender, amount);
580 	}
581 
582 	function transfer(
583 		uint256 fromId,
584 		uint256 toId,
585 		uint256 amount
586 	) public {
587 		_poolBalances[fromId] = _poolBalances[fromId].sub(amount);
588 		_balances[fromId][msg.sender] = _balances[fromId][msg.sender].sub(amount);
589 
590 		_poolBalances[toId] = _poolBalances[toId].add(amount);
591 		_balances[toId][msg.sender] = _balances[toId][msg.sender].add(amount);
592 	}
593 
594 	function _rescuePineapples(address account, uint256 id) internal {
595 		uint256 amount = _balances[id][account];
596 
597 		_totalSupply = _totalSupply.sub(amount);
598 		_poolBalances[id] = _poolBalances[id].sub(amount);
599 		_balances[id][account] = _balances[id][account].sub(amount);
600 		token.transfer(account, amount);
601 	}
602 }
603 
604 /**
605  * FractionalExponents
606  * Copied and modified from: 
607  *  https://github.com/bancorprotocol/contracts/blob/master/solidity/contracts/converter/BancorFormula.sol#L289
608  * Redistributed Under Apache License 2.0: 
609  *  https://github.com/bancorprotocol/contracts/blob/master/LICENSE
610  * Provided as an answer to:
611  *  https://ethereum.stackexchange.com/questions/50527/is-there-any-efficient-way-to-compute-the-exponentiation-of-an-fractional-base-a
612  */
613 contract FractionalExponents {
614 
615     uint256 private constant ONE = 1;
616     uint32 private constant MAX_WEIGHT = 1000000;
617     uint8 private constant MIN_PRECISION = 32;
618     uint8 private constant MAX_PRECISION = 127;
619 
620     uint256 private constant FIXED_1 = 0x080000000000000000000000000000000;
621     uint256 private constant FIXED_2 = 0x100000000000000000000000000000000;
622     uint256 private constant MAX_NUM = 0x200000000000000000000000000000000;
623 
624     uint256 private constant LN2_NUMERATOR   = 0x3f80fe03f80fe03f80fe03f80fe03f8;
625     uint256 private constant LN2_DENOMINATOR = 0x5b9de1d10bf4103d647b0955897ba80;
626 
627     uint256 private constant OPT_LOG_MAX_VAL = 0x15bf0a8b1457695355fb8ac404e7a79e3;
628     uint256 private constant OPT_EXP_MAX_VAL = 0x800000000000000000000000000000000;
629 
630     uint256[128] private maxExpArray;
631     function BancorFormula() public {
632         maxExpArray[ 32] = 0x1c35fedd14ffffffffffffffffffffffff;
633         maxExpArray[ 33] = 0x1b0ce43b323fffffffffffffffffffffff;
634         maxExpArray[ 34] = 0x19f0028ec1ffffffffffffffffffffffff;
635         maxExpArray[ 35] = 0x18ded91f0e7fffffffffffffffffffffff;
636         maxExpArray[ 36] = 0x17d8ec7f0417ffffffffffffffffffffff;
637         maxExpArray[ 37] = 0x16ddc6556cdbffffffffffffffffffffff;
638         maxExpArray[ 38] = 0x15ecf52776a1ffffffffffffffffffffff;
639         maxExpArray[ 39] = 0x15060c256cb2ffffffffffffffffffffff;
640         maxExpArray[ 40] = 0x1428a2f98d72ffffffffffffffffffffff;
641         maxExpArray[ 41] = 0x13545598e5c23fffffffffffffffffffff;
642         maxExpArray[ 42] = 0x1288c4161ce1dfffffffffffffffffffff;
643         maxExpArray[ 43] = 0x11c592761c666fffffffffffffffffffff;
644         maxExpArray[ 44] = 0x110a688680a757ffffffffffffffffffff;
645         maxExpArray[ 45] = 0x1056f1b5bedf77ffffffffffffffffffff;
646         maxExpArray[ 46] = 0x0faadceceeff8bffffffffffffffffffff;
647         maxExpArray[ 47] = 0x0f05dc6b27edadffffffffffffffffffff;
648         maxExpArray[ 48] = 0x0e67a5a25da4107fffffffffffffffffff;
649         maxExpArray[ 49] = 0x0dcff115b14eedffffffffffffffffffff;
650         maxExpArray[ 50] = 0x0d3e7a392431239fffffffffffffffffff;
651         maxExpArray[ 51] = 0x0cb2ff529eb71e4fffffffffffffffffff;
652         maxExpArray[ 52] = 0x0c2d415c3db974afffffffffffffffffff;
653         maxExpArray[ 53] = 0x0bad03e7d883f69bffffffffffffffffff;
654         maxExpArray[ 54] = 0x0b320d03b2c343d5ffffffffffffffffff;
655         maxExpArray[ 55] = 0x0abc25204e02828dffffffffffffffffff;
656         maxExpArray[ 56] = 0x0a4b16f74ee4bb207fffffffffffffffff;
657         maxExpArray[ 57] = 0x09deaf736ac1f569ffffffffffffffffff;
658         maxExpArray[ 58] = 0x0976bd9952c7aa957fffffffffffffffff;
659         maxExpArray[ 59] = 0x09131271922eaa606fffffffffffffffff;
660         maxExpArray[ 60] = 0x08b380f3558668c46fffffffffffffffff;
661         maxExpArray[ 61] = 0x0857ddf0117efa215bffffffffffffffff;
662         maxExpArray[ 62] = 0x07ffffffffffffffffffffffffffffffff;
663         maxExpArray[ 63] = 0x07abbf6f6abb9d087fffffffffffffffff;
664         maxExpArray[ 64] = 0x075af62cbac95f7dfa7fffffffffffffff;
665         maxExpArray[ 65] = 0x070d7fb7452e187ac13fffffffffffffff;
666         maxExpArray[ 66] = 0x06c3390ecc8af379295fffffffffffffff;
667         maxExpArray[ 67] = 0x067c00a3b07ffc01fd6fffffffffffffff;
668         maxExpArray[ 68] = 0x0637b647c39cbb9d3d27ffffffffffffff;
669         maxExpArray[ 69] = 0x05f63b1fc104dbd39587ffffffffffffff;
670         maxExpArray[ 70] = 0x05b771955b36e12f7235ffffffffffffff;
671         maxExpArray[ 71] = 0x057b3d49dda84556d6f6ffffffffffffff;
672         maxExpArray[ 72] = 0x054183095b2c8ececf30ffffffffffffff;
673         maxExpArray[ 73] = 0x050a28be635ca2b888f77fffffffffffff;
674         maxExpArray[ 74] = 0x04d5156639708c9db33c3fffffffffffff;
675         maxExpArray[ 75] = 0x04a23105873875bd52dfdfffffffffffff;
676         maxExpArray[ 76] = 0x0471649d87199aa990756fffffffffffff;
677         maxExpArray[ 77] = 0x04429a21a029d4c1457cfbffffffffffff;
678         maxExpArray[ 78] = 0x0415bc6d6fb7dd71af2cb3ffffffffffff;
679         maxExpArray[ 79] = 0x03eab73b3bbfe282243ce1ffffffffffff;
680         maxExpArray[ 80] = 0x03c1771ac9fb6b4c18e229ffffffffffff;
681         maxExpArray[ 81] = 0x0399e96897690418f785257fffffffffff;
682         maxExpArray[ 82] = 0x0373fc456c53bb779bf0ea9fffffffffff;
683         maxExpArray[ 83] = 0x034f9e8e490c48e67e6ab8bfffffffffff;
684         maxExpArray[ 84] = 0x032cbfd4a7adc790560b3337ffffffffff;
685         maxExpArray[ 85] = 0x030b50570f6e5d2acca94613ffffffffff;
686         maxExpArray[ 86] = 0x02eb40f9f620fda6b56c2861ffffffffff;
687         maxExpArray[ 87] = 0x02cc8340ecb0d0f520a6af58ffffffffff;
688         maxExpArray[ 88] = 0x02af09481380a0a35cf1ba02ffffffffff;
689         maxExpArray[ 89] = 0x0292c5bdd3b92ec810287b1b3fffffffff;
690         maxExpArray[ 90] = 0x0277abdcdab07d5a77ac6d6b9fffffffff;
691         maxExpArray[ 91] = 0x025daf6654b1eaa55fd64df5efffffffff;
692         maxExpArray[ 92] = 0x0244c49c648baa98192dce88b7ffffffff;
693         maxExpArray[ 93] = 0x022ce03cd5619a311b2471268bffffffff;
694         maxExpArray[ 94] = 0x0215f77c045fbe885654a44a0fffffffff;
695         maxExpArray[ 95] = 0x01ffffffffffffffffffffffffffffffff;
696         maxExpArray[ 96] = 0x01eaefdbdaaee7421fc4d3ede5ffffffff;
697         maxExpArray[ 97] = 0x01d6bd8b2eb257df7e8ca57b09bfffffff;
698         maxExpArray[ 98] = 0x01c35fedd14b861eb0443f7f133fffffff;
699         maxExpArray[ 99] = 0x01b0ce43b322bcde4a56e8ada5afffffff;
700         maxExpArray[100] = 0x019f0028ec1fff007f5a195a39dfffffff;
701         maxExpArray[101] = 0x018ded91f0e72ee74f49b15ba527ffffff;
702         maxExpArray[102] = 0x017d8ec7f04136f4e5615fd41a63ffffff;
703         maxExpArray[103] = 0x016ddc6556cdb84bdc8d12d22e6fffffff;
704         maxExpArray[104] = 0x015ecf52776a1155b5bd8395814f7fffff;
705         maxExpArray[105] = 0x015060c256cb23b3b3cc3754cf40ffffff;
706         maxExpArray[106] = 0x01428a2f98d728ae223ddab715be3fffff;
707         maxExpArray[107] = 0x013545598e5c23276ccf0ede68034fffff;
708         maxExpArray[108] = 0x01288c4161ce1d6f54b7f61081194fffff;
709         maxExpArray[109] = 0x011c592761c666aa641d5a01a40f17ffff;
710         maxExpArray[110] = 0x0110a688680a7530515f3e6e6cfdcdffff;
711         maxExpArray[111] = 0x01056f1b5bedf75c6bcb2ce8aed428ffff;
712         maxExpArray[112] = 0x00faadceceeff8a0890f3875f008277fff;
713         maxExpArray[113] = 0x00f05dc6b27edad306388a600f6ba0bfff;
714         maxExpArray[114] = 0x00e67a5a25da41063de1495d5b18cdbfff;
715         maxExpArray[115] = 0x00dcff115b14eedde6fc3aa5353f2e4fff;
716         maxExpArray[116] = 0x00d3e7a3924312399f9aae2e0f868f8fff;
717         maxExpArray[117] = 0x00cb2ff529eb71e41582cccd5a1ee26fff;
718         maxExpArray[118] = 0x00c2d415c3db974ab32a51840c0b67edff;
719         maxExpArray[119] = 0x00bad03e7d883f69ad5b0a186184e06bff;
720         maxExpArray[120] = 0x00b320d03b2c343d4829abd6075f0cc5ff;
721         maxExpArray[121] = 0x00abc25204e02828d73c6e80bcdb1a95bf;
722         maxExpArray[122] = 0x00a4b16f74ee4bb2040a1ec6c15fbbf2df;
723         maxExpArray[123] = 0x009deaf736ac1f569deb1b5ae3f36c130f;
724         maxExpArray[124] = 0x00976bd9952c7aa957f5937d790ef65037;
725         maxExpArray[125] = 0x009131271922eaa6064b73a22d0bd4f2bf;
726         maxExpArray[126] = 0x008b380f3558668c46c91c49a2f8e967b9;
727         maxExpArray[127] = 0x00857ddf0117efa215952912839f6473e6;
728     }
729 
730 
731 
732     /**
733         General Description:
734             Determine a value of precision.
735             Calculate an integer approximation of (_baseN / _baseD) ^ (_expN / _expD) * 2 ^ precision.
736             Return the result along with the precision used.
737 
738         Detailed Description:
739             Instead of calculating "base ^ exp", we calculate "e ^ (log(base) * exp)".
740             The value of "log(base)" is represented with an integer slightly smaller than "log(base) * 2 ^ precision".
741             The larger "precision" is, the more accurately this value represents the real value.
742             However, the larger "precision" is, the more bits are required in order to store this value.
743             And the exponentiation function, which takes "x" and calculates "e ^ x", is limited to a maximum exponent (maximum value of "x").
744             This maximum exponent depends on the "precision" used, and it is given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
745             Hence we need to determine the highest precision which can be used for the given input, before calling the exponentiation function.
746             This allows us to compute "base ^ exp" with maximum accuracy and without exceeding 256 bits in any of the intermediate computations.
747             This functions assumes that "_expN < 2 ^ 256 / log(MAX_NUM - 1)", otherwise the multiplication should be replaced with a "safeMul".
748     */
749     function power(uint256 _baseN, uint256 _baseD, uint32 _expN, uint32 _expD) public view returns (uint256, uint8) {
750         assert(_baseN < MAX_NUM);
751 
752         uint256 baseLog;
753         uint256 base = _baseN * FIXED_1 / _baseD;
754         if (base < OPT_LOG_MAX_VAL) {
755             baseLog = optimalLog(base);
756         }
757         else {
758             baseLog = generalLog(base);
759         }
760 
761         uint256 baseLogTimesExp = baseLog * _expN / _expD;
762         if (baseLogTimesExp < OPT_EXP_MAX_VAL) {
763             return (optimalExp(baseLogTimesExp), MAX_PRECISION);
764         }
765         else {
766             uint8 precision = findPositionInMaxExpArray(baseLogTimesExp);
767             return (generalExp(baseLogTimesExp >> (MAX_PRECISION - precision), precision), precision);
768         }
769     }
770 
771     /**
772         Compute log(x / FIXED_1) * FIXED_1.
773         This functions assumes that "x >= FIXED_1", because the output would be negative otherwise.
774     */
775     function generalLog(uint256 x) internal pure returns (uint256) {
776         uint256 res = 0;
777 
778         // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
779         if (x >= FIXED_2) {
780             uint8 count = floorLog2(x / FIXED_1);
781             x >>= count; // now x < 2
782             res = count * FIXED_1;
783         }
784 
785         // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
786         if (x > FIXED_1) {
787             for (uint8 i = MAX_PRECISION; i > 0; --i) {
788                 x = (x * x) / FIXED_1; // now 1 < x < 4
789                 if (x >= FIXED_2) {
790                     x >>= 1; // now 1 < x < 2
791                     res += ONE << (i - 1);
792                 }
793             }
794         }
795 
796         return res * LN2_NUMERATOR / LN2_DENOMINATOR;
797     }
798 
799     /**
800         Compute the largest integer smaller than or equal to the binary logarithm of the input.
801     */
802     function floorLog2(uint256 _n) internal pure returns (uint8) {
803         uint8 res = 0;
804 
805         if (_n < 256) {
806             // At most 8 iterations
807             while (_n > 1) {
808                 _n >>= 1;
809                 res += 1;
810             }
811         }
812         else {
813             // Exactly 8 iterations
814             for (uint8 s = 128; s > 0; s >>= 1) {
815                 if (_n >= (ONE << s)) {
816                     _n >>= s;
817                     res |= s;
818                 }
819             }
820         }
821 
822         return res;
823     }
824 
825     /**
826         The global "maxExpArray" is sorted in descending order, and therefore the following statements are equivalent:
827         - This function finds the position of [the smallest value in "maxExpArray" larger than or equal to "x"]
828         - This function finds the highest position of [a value in "maxExpArray" larger than or equal to "x"]
829     */
830     function findPositionInMaxExpArray(uint256 _x) internal view returns (uint8) {
831         uint8 lo = MIN_PRECISION;
832         uint8 hi = MAX_PRECISION;
833 
834         while (lo + 1 < hi) {
835             uint8 mid = (lo + hi) / 2;
836             if (maxExpArray[mid] >= _x)
837                 lo = mid;
838             else
839                 hi = mid;
840         }
841 
842         if (maxExpArray[hi] >= _x)
843             return hi;
844         if (maxExpArray[lo] >= _x)
845             return lo;
846 
847         assert(false);
848         return 0;
849     }
850 
851     /**
852         This function can be auto-generated by the script 'PrintFunctionGeneralExp.py'.
853         It approximates "e ^ x" via maclaurin summation: "(x^0)/0! + (x^1)/1! + ... + (x^n)/n!".
854         It returns "e ^ (x / 2 ^ precision) * 2 ^ precision", that is, the result is upshifted for accuracy.
855         The global "maxExpArray" maps each "precision" to "((maximumExponent + 1) << (MAX_PRECISION - precision)) - 1".
856         The maximum permitted value for "x" is therefore given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
857     */
858     function generalExp(uint256 _x, uint8 _precision) internal pure returns (uint256) {
859         uint256 xi = _x;
860         uint256 res = 0;
861 
862         xi = (xi * _x) >> _precision; res += xi * 0x3442c4e6074a82f1797f72ac0000000; // add x^02 * (33! / 02!)
863         xi = (xi * _x) >> _precision; res += xi * 0x116b96f757c380fb287fd0e40000000; // add x^03 * (33! / 03!)
864         xi = (xi * _x) >> _precision; res += xi * 0x045ae5bdd5f0e03eca1ff4390000000; // add x^04 * (33! / 04!)
865         xi = (xi * _x) >> _precision; res += xi * 0x00defabf91302cd95b9ffda50000000; // add x^05 * (33! / 05!)
866         xi = (xi * _x) >> _precision; res += xi * 0x002529ca9832b22439efff9b8000000; // add x^06 * (33! / 06!)
867         xi = (xi * _x) >> _precision; res += xi * 0x00054f1cf12bd04e516b6da88000000; // add x^07 * (33! / 07!)
868         xi = (xi * _x) >> _precision; res += xi * 0x0000a9e39e257a09ca2d6db51000000; // add x^08 * (33! / 08!)
869         xi = (xi * _x) >> _precision; res += xi * 0x000012e066e7b839fa050c309000000; // add x^09 * (33! / 09!)
870         xi = (xi * _x) >> _precision; res += xi * 0x000001e33d7d926c329a1ad1a800000; // add x^10 * (33! / 10!)
871         xi = (xi * _x) >> _precision; res += xi * 0x0000002bee513bdb4a6b19b5f800000; // add x^11 * (33! / 11!)
872         xi = (xi * _x) >> _precision; res += xi * 0x00000003a9316fa79b88eccf2a00000; // add x^12 * (33! / 12!)
873         xi = (xi * _x) >> _precision; res += xi * 0x0000000048177ebe1fa812375200000; // add x^13 * (33! / 13!)
874         xi = (xi * _x) >> _precision; res += xi * 0x0000000005263fe90242dcbacf00000; // add x^14 * (33! / 14!)
875         xi = (xi * _x) >> _precision; res += xi * 0x000000000057e22099c030d94100000; // add x^15 * (33! / 15!)
876         xi = (xi * _x) >> _precision; res += xi * 0x0000000000057e22099c030d9410000; // add x^16 * (33! / 16!)
877         xi = (xi * _x) >> _precision; res += xi * 0x00000000000052b6b54569976310000; // add x^17 * (33! / 17!)
878         xi = (xi * _x) >> _precision; res += xi * 0x00000000000004985f67696bf748000; // add x^18 * (33! / 18!)
879         xi = (xi * _x) >> _precision; res += xi * 0x000000000000003dea12ea99e498000; // add x^19 * (33! / 19!)
880         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000031880f2214b6e000; // add x^20 * (33! / 20!)
881         xi = (xi * _x) >> _precision; res += xi * 0x000000000000000025bcff56eb36000; // add x^21 * (33! / 21!)
882         xi = (xi * _x) >> _precision; res += xi * 0x000000000000000001b722e10ab1000; // add x^22 * (33! / 22!)
883         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000001317c70077000; // add x^23 * (33! / 23!)
884         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000cba84aafa00; // add x^24 * (33! / 24!)
885         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000082573a0a00; // add x^25 * (33! / 25!)
886         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000005035ad900; // add x^26 * (33! / 26!)
887         xi = (xi * _x) >> _precision; res += xi * 0x000000000000000000000002f881b00; // add x^27 * (33! / 27!)
888         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000001b29340; // add x^28 * (33! / 28!)
889         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000000000efc40; // add x^29 * (33! / 29!)
890         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000007fe0; // add x^30 * (33! / 30!)
891         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000420; // add x^31 * (33! / 31!)
892         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000021; // add x^32 * (33! / 32!)
893         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000001; // add x^33 * (33! / 33!)
894 
895         return res / 0x688589cc0e9505e2f2fee5580000000 + _x + (ONE << _precision); // divide by 33! and then add x^1 / 1! + x^0 / 0!
896     }
897 
898     /**
899         Return log(x / FIXED_1) * FIXED_1
900         Input range: FIXED_1 <= x <= LOG_EXP_MAX_VAL - 1
901     */
902     function optimalLog(uint256 x) internal pure returns (uint256) {
903         uint256 res = 0;
904 
905         uint256 y;
906         uint256 z;
907         uint256 w;
908 
909         if (x >= 0xd3094c70f034de4b96ff7d5b6f99fcd8) {res += 0x40000000000000000000000000000000; x = x * FIXED_1 / 0xd3094c70f034de4b96ff7d5b6f99fcd8;}
910         if (x >= 0xa45af1e1f40c333b3de1db4dd55f29a7) {res += 0x20000000000000000000000000000000; x = x * FIXED_1 / 0xa45af1e1f40c333b3de1db4dd55f29a7;}
911         if (x >= 0x910b022db7ae67ce76b441c27035c6a1) {res += 0x10000000000000000000000000000000; x = x * FIXED_1 / 0x910b022db7ae67ce76b441c27035c6a1;}
912         if (x >= 0x88415abbe9a76bead8d00cf112e4d4a8) {res += 0x08000000000000000000000000000000; x = x * FIXED_1 / 0x88415abbe9a76bead8d00cf112e4d4a8;}
913         if (x >= 0x84102b00893f64c705e841d5d4064bd3) {res += 0x04000000000000000000000000000000; x = x * FIXED_1 / 0x84102b00893f64c705e841d5d4064bd3;}
914         if (x >= 0x8204055aaef1c8bd5c3259f4822735a2) {res += 0x02000000000000000000000000000000; x = x * FIXED_1 / 0x8204055aaef1c8bd5c3259f4822735a2;}
915         if (x >= 0x810100ab00222d861931c15e39b44e99) {res += 0x01000000000000000000000000000000; x = x * FIXED_1 / 0x810100ab00222d861931c15e39b44e99;}
916         if (x >= 0x808040155aabbbe9451521693554f733) {res += 0x00800000000000000000000000000000; x = x * FIXED_1 / 0x808040155aabbbe9451521693554f733;}
917 
918         z = y = x - FIXED_1;
919         w = y * y / FIXED_1;
920         res += z * (0x100000000000000000000000000000000 - y) / 0x100000000000000000000000000000000; z = z * w / FIXED_1;
921         res += z * (0x0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa - y) / 0x200000000000000000000000000000000; z = z * w / FIXED_1;
922         res += z * (0x099999999999999999999999999999999 - y) / 0x300000000000000000000000000000000; z = z * w / FIXED_1;
923         res += z * (0x092492492492492492492492492492492 - y) / 0x400000000000000000000000000000000; z = z * w / FIXED_1;
924         res += z * (0x08e38e38e38e38e38e38e38e38e38e38e - y) / 0x500000000000000000000000000000000; z = z * w / FIXED_1;
925         res += z * (0x08ba2e8ba2e8ba2e8ba2e8ba2e8ba2e8b - y) / 0x600000000000000000000000000000000; z = z * w / FIXED_1;
926         res += z * (0x089d89d89d89d89d89d89d89d89d89d89 - y) / 0x700000000000000000000000000000000; z = z * w / FIXED_1;
927         res += z * (0x088888888888888888888888888888888 - y) / 0x800000000000000000000000000000000;
928 
929         return res;
930     }
931 
932     /**
933         Return e ^ (x / FIXED_1) * FIXED_1
934         Input range: 0 <= x <= OPT_EXP_MAX_VAL - 1
935     */
936     function optimalExp(uint256 x) internal pure returns (uint256) {
937         uint256 res = 0;
938 
939         uint256 y;
940         uint256 z;
941 
942         z = y = x % 0x10000000000000000000000000000000;
943         z = z * y / FIXED_1; res += z * 0x10e1b3be415a0000; // add y^02 * (20! / 02!)
944         z = z * y / FIXED_1; res += z * 0x05a0913f6b1e0000; // add y^03 * (20! / 03!)
945         z = z * y / FIXED_1; res += z * 0x0168244fdac78000; // add y^04 * (20! / 04!)
946         z = z * y / FIXED_1; res += z * 0x004807432bc18000; // add y^05 * (20! / 05!)
947         z = z * y / FIXED_1; res += z * 0x000c0135dca04000; // add y^06 * (20! / 06!)
948         z = z * y / FIXED_1; res += z * 0x0001b707b1cdc000; // add y^07 * (20! / 07!)
949         z = z * y / FIXED_1; res += z * 0x000036e0f639b800; // add y^08 * (20! / 08!)
950         z = z * y / FIXED_1; res += z * 0x00000618fee9f800; // add y^09 * (20! / 09!)
951         z = z * y / FIXED_1; res += z * 0x0000009c197dcc00; // add y^10 * (20! / 10!)
952         z = z * y / FIXED_1; res += z * 0x0000000e30dce400; // add y^11 * (20! / 11!)
953         z = z * y / FIXED_1; res += z * 0x000000012ebd1300; // add y^12 * (20! / 12!)
954         z = z * y / FIXED_1; res += z * 0x0000000017499f00; // add y^13 * (20! / 13!)
955         z = z * y / FIXED_1; res += z * 0x0000000001a9d480; // add y^14 * (20! / 14!)
956         z = z * y / FIXED_1; res += z * 0x00000000001c6380; // add y^15 * (20! / 15!)
957         z = z * y / FIXED_1; res += z * 0x000000000001c638; // add y^16 * (20! / 16!)
958         z = z * y / FIXED_1; res += z * 0x0000000000001ab8; // add y^17 * (20! / 17!)
959         z = z * y / FIXED_1; res += z * 0x000000000000017c; // add y^18 * (20! / 18!)
960         z = z * y / FIXED_1; res += z * 0x0000000000000014; // add y^19 * (20! / 19!)
961         z = z * y / FIXED_1; res += z * 0x0000000000000001; // add y^20 * (20! / 20!)
962         res = res / 0x21c3677c82b40000 + y + FIXED_1; // divide by 20! and then add y^1 / 1! + y^0 / 0!
963 
964         if ((x & 0x010000000000000000000000000000000) != 0) res = res * 0x1c3d6a24ed82218787d624d3e5eba95f9 / 0x18ebef9eac820ae8682b9793ac6d1e776;
965         if ((x & 0x020000000000000000000000000000000) != 0) res = res * 0x18ebef9eac820ae8682b9793ac6d1e778 / 0x1368b2fc6f9609fe7aceb46aa619baed4;
966         if ((x & 0x040000000000000000000000000000000) != 0) res = res * 0x1368b2fc6f9609fe7aceb46aa619baed5 / 0x0bc5ab1b16779be3575bd8f0520a9f21f;
967         if ((x & 0x080000000000000000000000000000000) != 0) res = res * 0x0bc5ab1b16779be3575bd8f0520a9f21e / 0x0454aaa8efe072e7f6ddbab84b40a55c9;
968         if ((x & 0x100000000000000000000000000000000) != 0) res = res * 0x0454aaa8efe072e7f6ddbab84b40a55c5 / 0x00960aadc109e7a3bf4578099615711ea;
969         if ((x & 0x200000000000000000000000000000000) != 0) res = res * 0x00960aadc109e7a3bf4578099615711d7 / 0x0002bf84208204f5977f9a8cf01fdce3d;
970         if ((x & 0x400000000000000000000000000000000) != 0) res = res * 0x0002bf84208204f5977f9a8cf01fdc307 / 0x0000003c6ab775dd0b95b4cbee7e65d11;
971 
972         return res;
973     }
974 }
975 
976 contract DiggCollection is PoolTokenWrapper, Ownable, Pausable, FractionalExponents {
977 	using SafeMath for uint256;
978 	IERC1155 public memeLtd;
979 
980 	uint256 constant multiplyer = 1000;
981 	uint256 constant min = 1e15;
982 
983 	struct Card {
984 		uint256 points;
985 		uint256 releaseTime;
986 		uint256 mintFee;
987 	}
988 
989 	struct Pool {
990 		uint256 periodStart;
991 		uint256 feesCollected;
992 		uint256 spentPineapples;
993 		uint256 controllerShare;
994 		address artist;
995 		mapping(address => uint256) lastUpdateTime;
996 		mapping(address => uint256) points;
997 		mapping(uint256 => Card) cards;
998 	}
999 
1000 	address public controller;
1001 	address public rescuer;
1002 	mapping(address => uint256) public pendingWithdrawals;
1003 	mapping(uint256 => Pool) public pools;
1004 
1005 	event UpdatedArtist(uint256 poolId, address artist);
1006 	event PoolAdded(uint256 poolId, address artist, uint256 periodStart);
1007 	event CardAdded(uint256 poolId, uint256 cardId, uint256 points, uint256 mintFee, uint256 releaseTime);
1008 	event Staked(address indexed user, uint256 poolId, uint256 amount);
1009 	event Withdrawn(address indexed user, uint256 poolId, uint256 amount);
1010 	event Transferred(address indexed user, uint256 fromPoolId, uint256 toPoolId, uint256 amount);
1011 	event Redeemed(address indexed user, uint256 poolId, uint256 amount);
1012 
1013 	modifier updateReward(address account, uint256 id) {
1014 		if (account != address(0)) {
1015 			pools[id].points[account] = earned(account, id);
1016 			pools[id].lastUpdateTime[account] = block.timestamp;
1017 		}
1018 		_;
1019 	}
1020 
1021 	modifier poolExists(uint256 id) {
1022 		require(pools[id].periodStart > 0, "pool does not exists");
1023 		_;
1024 	}
1025 
1026 	modifier cardExists(uint256 pool, uint256 card) {
1027 		require(pools[pool].cards[card].points > 0, "card does not exists");
1028 		_;
1029 	}
1030 
1031 	constructor(
1032 		address _controller,
1033 		IERC1155 _memeLtdAddress,
1034 		IERC20 _tokenAddress
1035 	) public PoolTokenWrapper(_tokenAddress) {
1036 		controller = _controller;
1037 		memeLtd = _memeLtdAddress;
1038 	}
1039 
1040 	function cardMintFee(uint256 pool, uint256 card) public view returns (uint256) {
1041 		return pools[pool].cards[card].mintFee;
1042 	}
1043 
1044 	function cardReleaseTime(uint256 pool, uint256 card) public view returns (uint256) {
1045 		return pools[pool].cards[card].releaseTime;
1046 	}
1047 
1048 	function cardPoints(uint256 pool, uint256 card) public view returns (uint256) {
1049 		return pools[pool].cards[card].points;
1050 	}
1051 
1052 	function timeElapsed(address account, uint256 pool) public view returns (uint256) {
1053 		return block.timestamp.sub(pools[pool].lastUpdateTime[account]);
1054 	}
1055 
1056 	function earned(address account, uint256 pool) public view returns (uint256) {
1057 		Pool storage p = pools[pool];
1058 		uint256 blockTime = block.timestamp;
1059 		uint256 poolBalance = balanceOf(account, pool);
1060 
1061 		if (poolBalance < min) return p.points[account];
1062 
1063 		// psuedomath: rewardRate = (1.35 * (balance * 1000)^(1/4)) / 86400
1064 		(uint256 mantissa, uint8 exponent) = power(multiplyer.mul(poolBalance), uint256(1e18), 1, 4);
1065 		uint256 noCoefficient = mantissa.mul(uint256(1 ether)).div(uint256(1) << uint256(exponent));
1066 		uint256 rewardRate = noCoefficient.mul(135).div(8640000);
1067 
1068 		return rewardRate.mul(blockTime.sub(p.lastUpdateTime[account])).add(p.points[account]);
1069 	}
1070 
1071 	// override PoolTokenWrapper's stake() function
1072 	function stake(uint256 pool, uint256 amount)
1073 		public
1074 		poolExists(pool)
1075 		updateReward(msg.sender, pool)
1076 		whenNotPaused()
1077 	{
1078 		Pool memory p = pools[pool];
1079 
1080 		require(block.timestamp >= p.periodStart, "pool not open");
1081 		require(amount.add(balanceOf(msg.sender, pool)) >= min, "must stake min");
1082 
1083 		super.stake(pool, amount);
1084 		emit Staked(msg.sender, pool, amount);
1085 	}
1086 
1087 	// override PoolTokenWrapper's withdraw() function
1088 	function withdraw(uint256 pool, uint256 amount) public poolExists(pool) updateReward(msg.sender, pool) {
1089 		require(amount > 0, "cannot withdraw 0");
1090 
1091 		super.withdraw(pool, amount);
1092 		emit Withdrawn(msg.sender, pool, amount);
1093 	}
1094 
1095 	// override PoolTokenWrapper's transfer() function
1096 	function transfer(
1097 		uint256 fromPool,
1098 		uint256 toPool,
1099 		uint256 amount
1100 	)
1101 		public
1102 		poolExists(fromPool)
1103 		poolExists(toPool)
1104 		updateReward(msg.sender, fromPool)
1105 		updateReward(msg.sender, toPool)
1106 		whenNotPaused()
1107 	{
1108 		Pool memory toP = pools[toPool];
1109 
1110 		require(block.timestamp >= toP.periodStart, "pool not open");
1111 
1112 		super.transfer(fromPool, toPool, amount);
1113 		emit Transferred(msg.sender, fromPool, toPool, amount);
1114 	}
1115 
1116 	function transferAll(uint256 fromPool, uint256 toPool) external {
1117 		transfer(fromPool, toPool, balanceOf(msg.sender, fromPool));
1118 	}
1119 
1120 	function exit(uint256 pool) external {
1121 		withdraw(pool, balanceOf(msg.sender, pool));
1122 	}
1123 
1124 	function redeem(uint256 pool, uint256 card)
1125 		public
1126 		payable
1127 		poolExists(pool)
1128 		cardExists(pool, card)
1129 		updateReward(msg.sender, pool)
1130 	{
1131 		Pool storage p = pools[pool];
1132 		Card memory c = p.cards[card];
1133 		require(block.timestamp >= c.releaseTime, "card not released");
1134 		require(p.points[msg.sender] >= c.points, "not enough pineapples");
1135 		require(msg.value == c.mintFee, "support our artists, send eth");
1136 
1137 		if (c.mintFee > 0) {
1138 			uint256 _controllerShare = msg.value.mul(p.controllerShare).div(1000);
1139 			uint256 _artistRoyalty = msg.value.sub(_controllerShare);
1140 			require(_artistRoyalty.add(_controllerShare) == msg.value, "problem with fee");
1141 
1142 			p.feesCollected = p.feesCollected.add(c.mintFee);
1143 			pendingWithdrawals[controller] = pendingWithdrawals[controller].add(_controllerShare);
1144 			pendingWithdrawals[p.artist] = pendingWithdrawals[p.artist].add(_artistRoyalty);
1145 		}
1146 
1147 		p.points[msg.sender] = p.points[msg.sender].sub(c.points);
1148 		p.spentPineapples = p.spentPineapples.add(c.points);
1149 		memeLtd.mint(msg.sender, card, 1, "");
1150 		emit Redeemed(msg.sender, pool, c.points);
1151 	}
1152 
1153 	function rescuePineapples(address account, uint256 pool)
1154 		public
1155 		poolExists(pool)
1156 		updateReward(account, pool)
1157 		returns (uint256)
1158 	{
1159 		require(msg.sender == rescuer, "!rescuer");
1160 		Pool storage p = pools[pool];
1161 
1162 		uint256 earnedPoints = p.points[account];
1163 		p.spentPineapples = p.spentPineapples.add(earnedPoints);
1164 		p.points[account] = 0;
1165 
1166 		// transfer remaining MEME to the account
1167 		if (balanceOf(account, pool) > 0) {
1168 			_rescuePineapples(account, pool);
1169 		}
1170 
1171 		emit Redeemed(account, pool, earnedPoints);
1172 		return earnedPoints;
1173 	}
1174 
1175 	function setArtist(uint256 pool, address artist) public onlyOwner {
1176 		uint256 amount = pendingWithdrawals[artist];
1177 		pendingWithdrawals[artist] = 0;
1178 		pendingWithdrawals[artist] = pendingWithdrawals[artist].add(amount);
1179 		pools[pool].artist = artist;
1180 
1181 		emit UpdatedArtist(pool, artist);
1182 	}
1183 
1184 	function setController(address _controller) public onlyOwner {
1185 		uint256 amount = pendingWithdrawals[controller];
1186 		pendingWithdrawals[controller] = 0;
1187 		pendingWithdrawals[_controller] = pendingWithdrawals[_controller].add(amount);
1188 		controller = _controller;
1189 	}
1190 
1191 	function setRescuer(address _rescuer) public onlyOwner {
1192 		rescuer = _rescuer;
1193 	}
1194 
1195 	function setControllerShare(uint256 pool, uint256 _controllerShare) public onlyOwner poolExists(pool) {
1196 		pools[pool].controllerShare = _controllerShare;
1197 	}
1198 
1199 	function addCard(
1200 		uint256 pool,
1201 		uint256 id,
1202 		uint256 points,
1203 		uint256 mintFee,
1204 		uint256 releaseTime
1205 	) public onlyOwner poolExists(pool) {
1206 		Card storage c = pools[pool].cards[id];
1207 		c.points = points;
1208 		c.releaseTime = releaseTime;
1209 		c.mintFee = mintFee;
1210 		emit CardAdded(pool, id, points, mintFee, releaseTime);
1211 	}
1212 
1213 	function createCard(
1214 		uint256 pool,
1215 		uint256 supply,
1216 		uint256 points,
1217 		uint256 mintFee,
1218 		uint256 releaseTime
1219 	) public onlyOwner poolExists(pool) returns (uint256) {
1220 		uint256 tokenId = memeLtd.create(supply, 0, "", "");
1221 		require(tokenId > 0, "ERC1155 create did not succeed");
1222 
1223 		Card storage c = pools[pool].cards[tokenId];
1224 		c.points = points;
1225 		c.releaseTime = releaseTime;
1226 		c.mintFee = mintFee;
1227 		emit CardAdded(pool, tokenId, points, mintFee, releaseTime);
1228 		return tokenId;
1229 	}
1230 
1231 	function createPool(
1232 		uint256 id,
1233 		uint256 periodStart,
1234 		uint256 controllerShare,
1235 		address artist
1236 	) public onlyOwner returns (uint256) {
1237 		require(pools[id].periodStart == 0, "pool exists");
1238 
1239 		Pool storage p = pools[id];
1240 
1241 		p.periodStart = periodStart;
1242 		p.controllerShare = controllerShare;
1243 		p.artist = artist;
1244 
1245 		emit PoolAdded(id, artist, periodStart);
1246 	}
1247 
1248 	function withdrawFee() public {
1249 		uint256 amount = pendingWithdrawals[msg.sender];
1250 		require(amount > 0, "nothing to withdraw");
1251 		pendingWithdrawals[msg.sender] = 0;
1252 		msg.sender.transfer(amount);
1253 	}
1254 }