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
604 contract YopCollection is PoolTokenWrapper, Ownable, Pausable {
605 	using SafeMath for uint256;
606 	IERC1155 public memeLtd;
607 
608 	struct Card {
609 		uint256 points;
610 		uint256 releaseTime;
611 		uint256 mintFee;
612 	}
613 
614 	struct Pool {
615 		uint256 periodStart;
616 		uint256 maxStake;
617 		uint256 rewardRate;
618 		uint256 feesCollected;
619 		uint256 spentPineapples;
620 		uint256 controllerShare;
621 		address artist;
622 		uint256 boostCardId;
623 		uint256 boostAmount;
624 		mapping(address => uint256) lastUpdateTime;
625 		mapping(address => uint256) points;
626 		mapping(uint256 => Card) cards;
627 	}
628 
629 	address public controller;
630 	address public rescuer;
631 	mapping(address => uint256) public pendingWithdrawals;
632 	mapping(uint256 => Pool) public pools;
633 
634 	event UpdatedArtist(uint256 poolId, address artist);
635 	event PoolAdded(uint256 poolId, address artist, uint256 periodStart, uint256 rewardRate, uint256 maxStake);
636 	event CardAdded(uint256 poolId, uint256 cardId, uint256 points, uint256 mintFee, uint256 releaseTime);
637 	event Staked(address indexed user, uint256 poolId, uint256 amount);
638 	event Withdrawn(address indexed user, uint256 poolId, uint256 amount);
639 	event Transferred(address indexed user, uint256 fromPoolId, uint256 toPoolId, uint256 amount);
640 	event Redeemed(address indexed user, uint256 poolId, uint256 amount);
641 
642 	modifier updateReward(address account, uint256 id) {
643 		if (account != address(0)) {
644 			pools[id].points[account] = earned(account, id);
645 			pools[id].lastUpdateTime[account] = block.timestamp;
646 		}
647 		_;
648 	}
649 
650 	modifier poolExists(uint256 id) {
651 		require(pools[id].rewardRate > 0, "pool does not exists");
652 		_;
653 	}
654 
655 	modifier cardExists(uint256 pool, uint256 card) {
656 		require(pools[pool].cards[card].points > 0, "card does not exists");
657 		_;
658 	}
659 
660 	constructor(
661 		address _controller,
662 		IERC1155 _memeLtdAddress,
663 		IERC20 _tokenAddress
664 	) public PoolTokenWrapper(_tokenAddress) {
665 		controller = _controller;
666 		memeLtd = _memeLtdAddress;
667 	}
668 
669 	function cardMintFee(uint256 pool, uint256 card) public view returns (uint256) {
670 		return pools[pool].cards[card].mintFee;
671 	}
672 
673 	function cardReleaseTime(uint256 pool, uint256 card) public view returns (uint256) {
674 		return pools[pool].cards[card].releaseTime;
675 	}
676 
677 	function cardPoints(uint256 pool, uint256 card) public view returns (uint256) {
678 		return pools[pool].cards[card].points;
679 	}
680 
681 	function boost(address account, uint256 pool) public view returns (uint256) {
682 		Pool storage p = pools[pool];
683 		if (p.boostCardId > 0 && memeLtd.balanceOf(account, p.boostCardId) >= 1) {
684 			return p.boostAmount;
685 		}
686 		return 100;
687 	}
688 
689 	function earned(address account, uint256 pool) public view returns (uint256) {
690 		Pool storage p = pools[pool];
691 		uint256 blockTime = block.timestamp;
692 		uint256 rewardRate = p.rewardRate.mul(boost(account, pool)).div(100);
693 
694 		return
695 			balanceOf(account, pool).mul(blockTime.sub(p.lastUpdateTime[account]).mul(rewardRate)).div(1e8).add(
696 				p.points[account]
697 			);
698 	}
699 
700 	// override PoolTokenWrapper's stake() function
701 	function stake(uint256 pool, uint256 amount)
702 		public
703 		poolExists(pool)
704 		updateReward(msg.sender, pool)
705 		whenNotPaused()
706 	{
707 		Pool memory p = pools[pool];
708 
709 		require(block.timestamp >= p.periodStart, "pool not open");
710 		require(amount.add(balanceOf(msg.sender, pool)) <= p.maxStake, "stake exceeds max");
711 
712 		super.stake(pool, amount);
713 		emit Staked(msg.sender, pool, amount);
714 	}
715 
716 	// override PoolTokenWrapper's withdraw() function
717 	function withdraw(uint256 pool, uint256 amount) public poolExists(pool) updateReward(msg.sender, pool) {
718 		require(amount > 0, "cannot withdraw 0");
719 
720 		super.withdraw(pool, amount);
721 		emit Withdrawn(msg.sender, pool, amount);
722 	}
723 
724 	// override PoolTokenWrapper's transfer() function
725 	function transfer(
726 		uint256 fromPool,
727 		uint256 toPool,
728 		uint256 amount
729 	)
730 		public
731 		poolExists(fromPool)
732 		poolExists(toPool)
733 		updateReward(msg.sender, fromPool)
734 		updateReward(msg.sender, toPool)
735 		whenNotPaused()
736 	{
737 		Pool memory toP = pools[toPool];
738 
739 		require(block.timestamp >= toP.periodStart, "pool not open");
740 		require(amount.add(balanceOf(msg.sender, toPool)) <= toP.maxStake, "stake exceeds max");
741 
742 		super.transfer(fromPool, toPool, amount);
743 		emit Transferred(msg.sender, fromPool, toPool, amount);
744 	}
745 
746 	function transferAll(uint256 fromPool, uint256 toPool) external {
747 		transfer(fromPool, toPool, balanceOf(msg.sender, fromPool));
748 	}
749 
750 	function exit(uint256 pool) external {
751 		withdraw(pool, balanceOf(msg.sender, pool));
752 	}
753 
754 	function redeem(uint256 pool, uint256 card)
755 		public
756 		payable
757 		poolExists(pool)
758 		cardExists(pool, card)
759 		updateReward(msg.sender, pool)
760 	{
761 		Pool storage p = pools[pool];
762 		Card memory c = p.cards[card];
763 		require(block.timestamp >= c.releaseTime, "card not released");
764 		require(p.points[msg.sender] >= c.points, "not enough pineapples");
765 		require(msg.value == c.mintFee, "support our artists, send eth");
766 
767 		if (c.mintFee > 0) {
768 			uint256 _controllerShare = msg.value.mul(p.controllerShare).div(1000);
769 			uint256 _artistRoyalty = msg.value.sub(_controllerShare);
770 			require(_artistRoyalty.add(_controllerShare) == msg.value, "problem with fee");
771 
772 			p.feesCollected = p.feesCollected.add(c.mintFee);
773 			pendingWithdrawals[controller] = pendingWithdrawals[controller].add(_controllerShare);
774 			pendingWithdrawals[p.artist] = pendingWithdrawals[p.artist].add(_artistRoyalty);
775 		}
776 
777 		p.points[msg.sender] = p.points[msg.sender].sub(c.points);
778 		p.spentPineapples = p.spentPineapples.add(c.points);
779 		memeLtd.mint(msg.sender, card, 1, "");
780 		emit Redeemed(msg.sender, pool, c.points);
781 	}
782 
783 	function rescuePineapples(address account, uint256 pool)
784 		public
785 		poolExists(pool)
786 		updateReward(account, pool)
787 		returns (uint256)
788 	{
789 		require(msg.sender == rescuer, "!rescuer");
790 		Pool storage p = pools[pool];
791 
792 		uint256 earnedPoints = p.points[account];
793 		p.spentPineapples = p.spentPineapples.add(earnedPoints);
794 		p.points[account] = 0;
795 
796 		// transfer remaining MEME to the account
797 		if (balanceOf(account, pool) > 0) {
798 			_rescuePineapples(account, pool);
799 		}
800 
801 		emit Redeemed(account, pool, earnedPoints);
802 		return earnedPoints;
803 	}
804 
805 	function setArtist(uint256 pool, address artist) public onlyOwner {
806 		uint256 amount = pendingWithdrawals[artist];
807 		pendingWithdrawals[artist] = 0;
808 		pendingWithdrawals[artist] = pendingWithdrawals[artist].add(amount);
809 		pools[pool].artist = artist;
810 
811 		emit UpdatedArtist(pool, artist);
812 	}
813 
814 	function setController(address _controller) public onlyOwner {
815 		uint256 amount = pendingWithdrawals[controller];
816 		pendingWithdrawals[controller] = 0;
817 		pendingWithdrawals[_controller] = pendingWithdrawals[_controller].add(amount);
818 		controller = _controller;
819 	}
820 
821 	function setRescuer(address _rescuer) public onlyOwner {
822 		rescuer = _rescuer;
823 	}
824 
825 	function setControllerShare(uint256 pool, uint256 _controllerShare) public onlyOwner poolExists(pool) {
826 		pools[pool].controllerShare = _controllerShare;
827 	}
828 
829 	function addCard(
830 		uint256 pool,
831 		uint256 id,
832 		uint256 points,
833 		uint256 mintFee,
834 		uint256 releaseTime
835 	) public onlyOwner poolExists(pool) {
836 		Card storage c = pools[pool].cards[id];
837 		c.points = points;
838 		c.releaseTime = releaseTime;
839 		c.mintFee = mintFee;
840 		emit CardAdded(pool, id, points, mintFee, releaseTime);
841 	}
842 
843 	function createCard(
844 		uint256 pool,
845 		uint256 supply,
846 		uint256 points,
847 		uint256 mintFee,
848 		uint256 releaseTime
849 	) public onlyOwner poolExists(pool) returns (uint256) {
850 		uint256 tokenId = memeLtd.create(supply, 0, "", "");
851 		require(tokenId > 0, "ERC1155 create did not succeed");
852 
853 		Card storage c = pools[pool].cards[tokenId];
854 		c.points = points;
855 		c.releaseTime = releaseTime;
856 		c.mintFee = mintFee;
857 		emit CardAdded(pool, tokenId, points, mintFee, releaseTime);
858 		return tokenId;
859 	}
860 
861 	function createPool(
862 		uint256 id,
863 		uint256 periodStart,
864 		uint256 maxStake,
865 		uint256 rewardRate,
866 		uint256 controllerShare,
867 		address artist,
868 		uint256 boostCardId,
869 		uint256 boostAmount
870 	) public onlyOwner returns (uint256) {
871 		require(pools[id].rewardRate == 0, "pool exists");
872 
873 		Pool storage p = pools[id];
874 
875 		p.periodStart = periodStart;
876 		p.maxStake = maxStake;
877 		p.rewardRate = rewardRate;
878 		p.controllerShare = controllerShare;
879 		p.artist = artist;
880 		p.boostCardId = boostCardId;
881 		p.boostAmount = boostAmount;
882 
883 		emit PoolAdded(id, artist, periodStart, rewardRate, maxStake);
884 	}
885 
886 	function withdrawFee() public {
887 		uint256 amount = pendingWithdrawals[msg.sender];
888 		require(amount > 0, "nothing to withdraw");
889 		pendingWithdrawals[msg.sender] = 0;
890 		msg.sender.transfer(amount);
891 	}
892 }