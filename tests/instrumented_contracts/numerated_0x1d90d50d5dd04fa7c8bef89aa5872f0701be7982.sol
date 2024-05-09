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
554 	mapping(address => uint256) private _accountBalances;
555 	mapping(uint256 => uint256) private _poolBalances;
556 
557 	function totalSupply() public view returns (uint256) {
558 		return _totalSupply;
559 	}
560 
561 	function balanceOfAccount(address account) public view returns (uint256) {
562 		return _accountBalances[account];
563 	}
564 
565 	function balanceOfPool(uint256 id) public view returns (uint256) {
566 		return _poolBalances[id];
567 	}
568 
569 	function balanceOf(address account, uint256 id) public view returns (uint256) {
570 		return _balances[id][account];
571 	}
572 
573 	function stake(uint256 id, uint256 amount) public {
574 		_totalSupply = _totalSupply.add(amount);
575 		_poolBalances[id] = _poolBalances[id].add(amount);
576 		_accountBalances[msg.sender] = _accountBalances[msg.sender].add(amount);
577 		_balances[id][msg.sender] = _balances[id][msg.sender].add(amount);
578 		token.transferFrom(msg.sender, address(this), amount);
579 	}
580 
581 	function withdraw(uint256 id, uint256 amount) public {
582 		_totalSupply = _totalSupply.sub(amount);
583 		_poolBalances[id] = _poolBalances[id].sub(amount);
584 		_accountBalances[msg.sender] = _accountBalances[msg.sender].sub(amount);
585 		_balances[id][msg.sender] = _balances[id][msg.sender].sub(amount);
586 		token.transfer(msg.sender, amount);
587 	}
588 
589 	function transfer(
590 		uint256 fromId,
591 		uint256 toId,
592 		uint256 amount
593 	) public {
594 		_poolBalances[fromId] = _poolBalances[fromId].sub(amount);
595 		_balances[fromId][msg.sender] = _balances[fromId][msg.sender].sub(amount);
596 
597 		_poolBalances[toId] = _poolBalances[toId].add(amount);
598 		_balances[toId][msg.sender] = _balances[toId][msg.sender].add(amount);
599 	}
600 
601 	function _rescuePineapples(address account, uint256 id) internal {
602 		uint256 amount = _balances[id][account];
603 
604 		_totalSupply = _totalSupply.sub(amount);
605 		_poolBalances[id] = _poolBalances[id].sub(amount);
606 		_accountBalances[msg.sender] = _accountBalances[msg.sender].sub(amount);
607 		_balances[id][account] = _balances[id][account].sub(amount);
608 		token.transfer(account, amount);
609 	}
610 }
611 
612 contract MemeLimitedCollections is PoolTokenWrapper, Ownable, Pausable {
613 	using SafeMath for uint256;
614 	IERC1155 public memeLtd;
615 
616 	struct Card {
617 		uint256 points;
618 		uint256 releaseTime;
619 		uint256 mintFee;
620 	}
621 
622 	struct Pool {
623 		uint256 periodStart;
624 		uint256 maxStake;
625 		uint256 rewardRate; // 11574074074000, 1 point per day per staked MEME
626 		uint256 feesCollected;
627 		uint256 spentPineapples;
628 		uint256 controllerShare;
629 		address artist;
630 		mapping(address => uint256) lastUpdateTime;
631 		mapping(address => uint256) points;
632 		mapping(uint256 => Card) cards;
633 	}
634 
635 	address public controller;
636 	address public rescuer;
637 	mapping(address => uint256) public pendingWithdrawals;
638 	mapping(uint256 => Pool) public pools;
639 
640 	event UpdatedArtist(uint256 poolId, address artist);
641 	event PoolAdded(uint256 poolId, address artist, uint256 periodStart, uint256 rewardRate, uint256 maxStake);
642 	event CardAdded(uint256 poolId, uint256 cardId, uint256 points, uint256 mintFee, uint256 releaseTime);
643 	event Staked(address indexed user, uint256 poolId, uint256 amount);
644 	event Withdrawn(address indexed user, uint256 poolId, uint256 amount);
645 	event Transferred(address indexed user, uint256 fromPoolId, uint256 toPoolId, uint256 amount);
646 	event Redeemed(address indexed user, uint256 poolId, uint256 amount);
647 
648 	modifier updateReward(address account, uint256 id) {
649 		if (account != address(0)) {
650 			pools[id].points[account] = earned(account, id);
651 			pools[id].lastUpdateTime[account] = block.timestamp;
652 		}
653 		_;
654 	}
655 
656 	modifier poolExists(uint256 id) {
657 		require(pools[id].rewardRate > 0, "pool does not exists");
658 		_;
659 	}
660 
661 	modifier cardExists(uint256 pool, uint256 card) {
662 		require(pools[pool].cards[card].points > 0, "card does not exists");
663 		_;
664 	}
665 
666 	constructor(
667 		address _controller,
668 		IERC1155 _memeLtdAddress,
669 		IERC20 _tokenAddress
670 	) public PoolTokenWrapper(_tokenAddress) {
671 		controller = _controller;
672 		memeLtd = _memeLtdAddress;
673 	}
674 
675 	function cardMintFee(uint256 pool, uint256 card) public view returns (uint256) {
676 		return pools[pool].cards[card].mintFee;
677 	}
678 
679 	function cardReleaseTime(uint256 pool, uint256 card) public view returns (uint256) {
680 		return pools[pool].cards[card].releaseTime;
681 	}
682 
683 	function cardPoints(uint256 pool, uint256 card) public view returns (uint256) {
684 		return pools[pool].cards[card].points;
685 	}
686 
687 	function earned(address account, uint256 pool) public view returns (uint256) {
688 		Pool storage p = pools[pool];
689 		uint256 blockTime = block.timestamp;
690 		return
691 			balanceOf(account, pool).mul(blockTime.sub(p.lastUpdateTime[account]).mul(p.rewardRate)).div(1e8).add(
692 				p.points[account]
693 			);
694 	}
695 
696 	// override PoolTokenWrapper's stake() function
697 	function stake(uint256 pool, uint256 amount)
698 		public
699 		poolExists(pool)
700 		updateReward(msg.sender, pool)
701 		whenNotPaused()
702 	{
703 		Pool memory p = pools[pool];
704 
705 		require(block.timestamp >= p.periodStart, "pool not open");
706 		require(amount.add(balanceOf(msg.sender, pool)) <= p.maxStake, "stake exceeds max");
707 
708 		super.stake(pool, amount);
709 		emit Staked(msg.sender, pool, amount);
710 	}
711 
712 	// override PoolTokenWrapper's withdraw() function
713 	function withdraw(uint256 pool, uint256 amount) public poolExists(pool) updateReward(msg.sender, pool) {
714 		require(amount > 0, "cannot withdraw 0");
715 
716 		super.withdraw(pool, amount);
717 		emit Withdrawn(msg.sender, pool, amount);
718 	}
719 
720 	// override PoolTokenWrapper's transfer() function
721 	function transfer(
722 		uint256 fromPool,
723 		uint256 toPool,
724 		uint256 amount
725 	)
726 		public
727 		poolExists(fromPool)
728 		poolExists(toPool)
729 		updateReward(msg.sender, fromPool)
730 		updateReward(msg.sender, toPool)
731 		whenNotPaused()
732 	{
733 		Pool memory toP = pools[toPool];
734 
735 		require(block.timestamp >= toP.periodStart, "pool not open");
736 		require(amount.add(balanceOf(msg.sender, toPool)) <= toP.maxStake, "stake exceeds max");
737 
738 		super.transfer(fromPool, toPool, amount);
739 		emit Transferred(msg.sender, fromPool, toPool, amount);
740 	}
741 
742 	function transferAll(uint256 fromPool, uint256 toPool) external {
743 		transfer(fromPool, toPool, balanceOf(msg.sender, fromPool));
744 	}
745 
746 	function exit(uint256 pool) external {
747 		withdraw(pool, balanceOf(msg.sender, pool));
748 	}
749 
750 	function redeem(uint256 pool, uint256 card)
751 		public
752 		payable
753 		poolExists(pool)
754 		cardExists(pool, card)
755 		updateReward(msg.sender, pool)
756 	{
757 		Pool storage p = pools[pool];
758 		Card memory c = p.cards[card];
759 		require(block.timestamp >= c.releaseTime, "card not released");
760 		require(p.points[msg.sender] >= c.points, "not enough pineapples");
761 		require(msg.value == c.mintFee, "support our artists, send eth");
762 
763 		if (c.mintFee > 0) {
764 			uint256 _controllerShare = msg.value.mul(p.controllerShare).div(1000);
765 			uint256 _artistRoyalty = msg.value.sub(_controllerShare);
766 			require(_artistRoyalty.add(_controllerShare) == msg.value, "problem with fee");
767 
768 			p.feesCollected = p.feesCollected.add(c.mintFee);
769 			pendingWithdrawals[controller] = pendingWithdrawals[controller].add(_controllerShare);
770 			pendingWithdrawals[p.artist] = pendingWithdrawals[p.artist].add(_artistRoyalty);
771 		}
772 
773 		p.points[msg.sender] = p.points[msg.sender].sub(c.points);
774 		p.spentPineapples = p.spentPineapples.add(c.points);
775 		memeLtd.mint(msg.sender, card, 1, "");
776 		emit Redeemed(msg.sender, pool, c.points);
777 	}
778 
779 	function rescuePineapples(address account, uint256 pool)
780 		public
781 		poolExists(pool)
782 		updateReward(account, pool)
783 		returns (uint256)
784 	{
785 		require(msg.sender == rescuer, "!rescuer");
786 		Pool storage p = pools[pool];
787 
788 		uint256 earnedPoints = p.points[account];
789 		p.spentPineapples = p.spentPineapples.add(earnedPoints);
790 		p.points[account] = 0;
791 
792 		// transfer remaining MEME to the account
793 		if (balanceOf(account, pool) > 0) {
794 			_rescuePineapples(account, pool);
795 		}
796 
797 		emit Redeemed(account, pool, earnedPoints);
798 		return earnedPoints;
799 	}
800 
801 	function setArtist(uint256 pool, address artist) public onlyOwner {
802 		uint256 amount = pendingWithdrawals[artist];
803 		pendingWithdrawals[artist] = 0;
804 		pendingWithdrawals[artist] = pendingWithdrawals[artist].add(amount);
805 		pools[pool].artist = artist;
806 
807 		emit UpdatedArtist(pool, artist);
808 	}
809 
810 	function setController(address _controller) public onlyOwner {
811 		uint256 amount = pendingWithdrawals[controller];
812 		pendingWithdrawals[controller] = 0;
813 		pendingWithdrawals[_controller] = pendingWithdrawals[_controller].add(amount);
814 		controller = _controller;
815 	}
816 
817 	function setRescuer(address _rescuer) public onlyOwner {
818 		rescuer = _rescuer;
819 	}
820 
821 	function setControllerShare(uint256 pool, uint256 _controllerShare) public onlyOwner poolExists(pool) {
822 		pools[pool].controllerShare = _controllerShare;
823 	}
824 
825 	function addCard(
826 		uint256 pool,
827 		uint256 id,
828 		uint256 points,
829 		uint256 mintFee,
830 		uint256 releaseTime
831 	) public onlyOwner poolExists(pool) {
832 		Card storage c = pools[pool].cards[id];
833 		c.points = points;
834 		c.releaseTime = releaseTime;
835 		c.mintFee = mintFee;
836 		emit CardAdded(pool, id, points, mintFee, releaseTime);
837 	}
838 
839 	function createCard(
840 		uint256 pool,
841 		uint256 supply,
842 		uint256 points,
843 		uint256 mintFee,
844 		uint256 releaseTime
845 	) public onlyOwner poolExists(pool) returns (uint256) {
846 		uint256 tokenId = memeLtd.create(supply, 0, "", "");
847 		require(tokenId > 0, "ERC1155 create did not succeed");
848 
849 		Card storage c = pools[pool].cards[tokenId];
850 		c.points = points;
851 		c.releaseTime = releaseTime;
852 		c.mintFee = mintFee;
853 		emit CardAdded(pool, tokenId, points, mintFee, releaseTime);
854 		return tokenId;
855 	}
856 
857 	function createPool(
858 		uint256 id,
859 		uint256 periodStart,
860 		uint256 maxStake,
861 		uint256 rewardRate,
862 		uint256 controllerShare,
863 		address artist
864 	) public onlyOwner returns (uint256) {
865 		require(pools[id].rewardRate == 0, "pool exists");
866 
867 		Pool storage p = pools[id];
868 
869 		p.periodStart = periodStart;
870 		p.maxStake = maxStake;
871 		p.rewardRate = rewardRate;
872 		p.controllerShare = controllerShare;
873 		p.artist = artist;
874 
875 		emit PoolAdded(id, artist, periodStart, rewardRate, maxStake);
876 	}
877 
878 	function withdrawFee() public {
879 		uint256 amount = pendingWithdrawals[msg.sender];
880 		require(amount > 0, "nothing to withdraw");
881 		pendingWithdrawals[msg.sender] = 0;
882 		msg.sender.transfer(amount);
883 	}
884 }