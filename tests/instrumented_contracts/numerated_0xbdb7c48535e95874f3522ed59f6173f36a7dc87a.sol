1 pragma solidity ^0.5.12;
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
261  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
262  * the optional functions; to access them see {ERC20Detailed}.
263  */
264 interface IERC20 {
265     /**
266      * @dev Returns the amount of tokens in existence.
267      */
268     function totalSupply() external view returns (uint256);
269 
270     /**
271      * @dev Returns the amount of tokens owned by `account`.
272      */
273     function balanceOf(address account) external view returns (uint256);
274 
275     /**
276      * @dev Moves `amount` tokens from the caller's account to `recipient`.
277      *
278      * Returns a boolean value indicating whether the operation succeeded.
279      *
280      * Emits a {Transfer} event.
281      */
282     function transfer(address recipient, uint256 amount) external returns (bool);
283 
284     /**
285      * @dev Returns the remaining number of tokens that `spender` will be
286      * allowed to spend on behalf of `owner` through {transferFrom}. This is
287      * zero by default.
288      *
289      * This value changes when {approve} or {transferFrom} are called.
290      */
291     function allowance(address owner, address spender) external view returns (uint256);
292 
293     /**
294      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
295      *
296      * Returns a boolean value indicating whether the operation succeeded.
297      *
298      * IMPORTANT: Beware that changing an allowance with this method brings the risk
299      * that someone may use both the old and the new allowance by unfortunate
300      * transaction ordering. One possible solution to mitigate this race
301      * condition is to first reduce the spender's allowance to 0 and set the
302      * desired value afterwards:
303      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
304      *
305      * Emits an {Approval} event.
306      */
307     function approve(address spender, uint256 amount) external returns (bool);
308 
309     /**
310      * @dev Moves `amount` tokens from `sender` to `recipient` using the
311      * allowance mechanism. `amount` is then deducted from the caller's
312      * allowance.
313      *
314      * Returns a boolean value indicating whether the operation succeeded.
315      *
316      * Emits a {Transfer} event.
317      */
318     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
319 
320     /**
321      * @dev Emitted when `value` tokens are moved from one account (`from`) to
322      * another (`to`).
323      *
324      * Note that `value` may be zero.
325      */
326     event Transfer(address indexed from, address indexed to, uint256 value);
327 
328     /**
329      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
330      * a call to {approve}. `value` is the new allowance.
331      */
332     event Approval(address indexed owner, address indexed spender, uint256 value);
333 }
334 
335 /**
336  * @dev Contract module that helps prevent reentrant calls to a function.
337  *
338  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
339  * available, which can be applied to functions to make sure there are no nested
340  * (reentrant) calls to them.
341  *
342  * Note that because there is a single `nonReentrant` guard, functions marked as
343  * `nonReentrant` may not call one another. This can be worked around by making
344  * those functions `private`, and then adding `external` `nonReentrant` entry
345  * points to them.
346  *
347  * TIP: If you would like to learn more about reentrancy and alternative ways
348  * to protect against it, check out our blog post
349  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
350  *
351  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
352  * metering changes introduced in the Istanbul hardfork.
353  */
354 contract ReentrancyGuard {
355     bool private _notEntered;
356 
357     constructor () internal {
358         // Storing an initial non-zero value makes deployment a bit more
359         // expensive, but in exchange the refund on every call to nonReentrant
360         // will be lower in amount. Since refunds are capped to a percetange of
361         // the total transaction's gas, it is best to keep them low in cases
362         // like this one, to increase the likelihood of the full refund coming
363         // into effect.
364         _notEntered = true;
365     }
366 
367     /**
368      * @dev Prevents a contract from calling itself, directly or indirectly.
369      * Calling a `nonReentrant` function from another `nonReentrant`
370      * function is not supported. It is possible to prevent this from happening
371      * by making the `nonReentrant` function external, and make it call a
372      * `private` function that does the actual work.
373      */
374     modifier nonReentrant() {
375         // On the first call to nonReentrant, _notEntered will be true
376         require(_notEntered, "ReentrancyGuard: reentrant call");
377 
378         // Any calls to nonReentrant after this point will fail
379         _notEntered = false;
380 
381         _;
382 
383         // By storing the original value once again, a refund is triggered (see
384         // https://eips.ethereum.org/EIPS/eip-2200)
385         _notEntered = true;
386     }
387 }
388 
389 /**
390  * @title ERC165
391  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
392  */
393 interface IERC165 {
394 
395     /**
396      * @notice Query if a contract implements an interface
397      * @dev Interface identification is specified in ERC-165. This function
398      * uses less than 30,000 gas
399      * @param _interfaceId The interface identifier, as specified in ERC-165
400      */
401     function supportsInterface(bytes4 _interfaceId)
402     external
403     view
404     returns (bool);
405 }
406 
407 /**
408  * @dev ERC-1155 interface for accepting safe transfers.
409  */
410 interface IERC1155TokenReceiver {
411 
412   /**
413    * @notice Handle the receipt of a single ERC1155 token type
414    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
415    * This function MAY throw to revert and reject the transfer
416    * Return of other amount than the magic value MUST result in the transaction being reverted
417    * Note: The token contract address is always the message sender
418    * @param _operator  The address which called the `safeTransferFrom` function
419    * @param _from      The address which previously owned the token
420    * @param _id        The id of the token being transferred
421    * @param _amount    The amount of tokens being transferred
422    * @param _data      Additional data with no specified format
423    * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
424    */
425   function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
426 
427   /**
428    * @notice Handle the receipt of multiple ERC1155 token types
429    * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
430    * This function MAY throw to revert and reject the transfer
431    * Return of other amount than the magic value WILL result in the transaction being reverted
432    * Note: The token contract address is always the message sender
433    * @param _operator  The address which called the `safeBatchTransferFrom` function
434    * @param _from      The address which previously owned the token
435    * @param _ids       An array containing ids of each token being transferred
436    * @param _amounts   An array containing amounts of each token being transferred
437    * @param _data      Additional data with no specified format
438    * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
439    */
440   function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
441 
442   /**
443    * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
444    * @param  interfaceID The ERC-165 interface ID that is queried for support.s
445    * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
446    *      This function MUST NOT consume more than 5,000 gas.
447    * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
448    */
449   function supportsInterface(bytes4 interfaceID) external view returns (bool);
450 
451 }
452 
453 contract MemeTokenWrapper {
454 	using SafeMath for uint256;
455 	IERC20 public meme;
456 
457 	constructor(address _memeAddress) public {
458 		meme = IERC20(_memeAddress);
459 	}
460 
461 	uint256 private _totalSupply;
462 	// Objects balances [id][address] => balance
463 	mapping(uint256 => mapping(address => uint256)) internal _balances;
464 	mapping(uint256 => uint256) private _totalDeposits;
465 
466 	function totalSupply() public view returns (uint256) {
467 		return _totalSupply;
468 	}
469 
470 	function totalDeposits(uint256 id) public view returns (uint256) {
471 		return _totalDeposits[id];
472 	}
473 
474 	function balanceOf(address account, uint256 id) public view returns (uint256) {
475 		return _balances[id][account];
476 	}
477 
478 	function bid(uint256 id, uint256 amount) public {
479 		_totalSupply = _totalSupply.add(amount);
480 		_totalDeposits[id] = _totalDeposits[id].add(amount);
481 		_balances[id][msg.sender] = _balances[id][msg.sender].add(amount);
482 		meme.transferFrom(msg.sender, address(this), amount);
483 	}
484 
485 	function withdraw(uint256 id) public {
486 		uint256 amount = balanceOf(msg.sender, id);
487 		_totalSupply = _totalSupply.sub(amount);
488 		_totalDeposits[id] = _totalDeposits[id].sub(amount);
489 		_balances[id][msg.sender] = _balances[id][msg.sender].sub(amount);
490 		meme.transfer(msg.sender, amount);
491 	}
492 
493 	function _emergencyWithdraw(address account, uint256 id) internal {
494 		uint256 amount = _balances[id][account];
495 
496 		_totalSupply = _totalSupply.sub(amount);
497 		_totalDeposits[id] = _totalDeposits[id].sub(amount);
498 		_balances[id][account] = _balances[id][account].sub(amount);
499 		meme.transfer(account, amount);
500 	}
501 
502 	function _end(
503 		uint256 id,
504 		address highestBidder,
505 		address beneficiary,
506 		address runner,
507 		uint256 fee,
508 		uint256 amount
509 	) internal {
510 		uint256 accountDeposits = _balances[id][highestBidder];
511 		require(accountDeposits == amount);
512 
513 		_totalSupply = _totalSupply.sub(amount);
514 		uint256 memeFee = (amount.mul(fee)).div(100);
515 
516 		_totalDeposits[id] = _totalDeposits[id].sub(amount);
517 		_balances[id][highestBidder] = _balances[id][highestBidder].sub(amount);
518 		meme.transfer(beneficiary, amount.sub(memeFee));
519 		meme.transfer(runner, memeFee);
520 	}
521 }
522 
523 interface IERC1155 {
524 	function create(
525 		uint256 _maxSupply,
526 		uint256 _initialSupply,
527 		string calldata _uri,
528 		bytes calldata _data
529 	) external returns (uint256 tokenId);
530 
531 	function safeTransferFrom(
532 		address _from,
533 		address _to,
534 		uint256 _id,
535 		uint256 _amount,
536 		bytes calldata _data
537 	) external;
538 
539 	function safeBatchTransferFrom(
540 		address _from,
541 		address _to,
542 		uint256[] calldata _ids,
543 		uint256[] calldata _amounts,
544 		bytes calldata _data
545 	) external;
546 
547 	function balanceOf(address _owner, uint256 _id) external view returns (uint256);
548 
549 	function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids)
550 		external
551 		view
552 		returns (uint256[] memory);
553 
554 	function setApprovalForAll(address _operator, bool _approved) external;
555 
556 	function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
557 
558 	event TransferSingle(
559 		address indexed _operator,
560 		address indexed _from,
561 		address indexed _to,
562 		uint256 _id,
563 		uint256 _amount
564 	);
565 
566 	event TransferBatch(
567 		address indexed _operator,
568 		address indexed _from,
569 		address indexed _to,
570 		uint256[] _ids,
571 		uint256[] _amounts
572 	);
573 
574 	event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
575 
576 	event URI(string _amount, uint256 indexed _id);
577 }
578 
579 contract MEMEAuctionExtending is Ownable, ReentrancyGuard, MemeTokenWrapper, IERC1155TokenReceiver {
580 	using SafeMath for uint256;
581 
582 	address public memeLtdAddress;
583 	address public runner;
584 
585 	// info about a particular auction
586 	struct AuctionInfo {
587 		address beneficiary;
588 		uint256 fee;
589 		uint256 auctionStart;
590 		uint256 auctionEnd;
591 		uint256 originalAuctionEnd;
592 		uint256 extension;
593 		uint256 nft;
594 		address highestBidder;
595 		uint256 highestBid;
596 		bool auctionEnded;
597 	}
598 
599 	mapping(uint256 => AuctionInfo) public auctionsById;
600 	uint256[] public auctions;
601 
602 	// Events that will be fired on changes.
603 	event BidPlaced(address indexed user, uint256 indexed id, uint256 amount);
604 	event Withdrawn(address indexed user, uint256 indexed id, uint256 amount);
605 	event Ended(address indexed user, uint256 indexed id, uint256 amount);
606 
607 	constructor(
608 		address _runner,
609 		address _memeAddress,
610 		address _memeLtdAddress
611 	) public MemeTokenWrapper(_memeAddress) {
612 		runner = _runner;
613 		memeLtdAddress = _memeLtdAddress;
614 	}
615 
616 	function auctionStart(uint256 id) public view returns (uint256) {
617 		return auctionsById[id].auctionStart;
618 	}
619 
620 	function beneficiary(uint256 id) public view returns (address) {
621 		return auctionsById[id].beneficiary;
622 	}
623 
624 	function auctionEnd(uint256 id) public view returns (uint256) {
625 		return auctionsById[id].auctionEnd;
626 	}
627 
628 	function memeLtdNft(uint256 id) public view returns (uint256) {
629 		return auctionsById[id].nft;
630 	}
631 
632 	function highestBidder(uint256 id) public view returns (address) {
633 		return auctionsById[id].highestBidder;
634 	}
635 
636 	function highestBid(uint256 id) public view returns (uint256) {
637 		return auctionsById[id].highestBid;
638 	}
639 
640 	function ended(uint256 id) public view returns (bool) {
641 		return now >= auctionsById[id].auctionEnd;
642 	}
643 
644 	function runnerFee(uint256 id) public view returns (uint256) {
645 		return auctionsById[id].fee;
646 	}
647 
648 	function setRunnerAddress(address account) public onlyOwner {
649 		runner = account;
650 	}
651 
652 	function create(
653 		uint256 id,
654 		address beneficiaryAddress,
655 		uint256 fee,
656 		uint256 start,
657 		uint256 duration,
658 		uint256 extension // in minutes
659 	) public onlyOwner {
660 		AuctionInfo storage auction = auctionsById[id];
661 		require(auction.beneficiary == address(0), "MEMEAuction::create: auction already created");
662 
663 		auction.beneficiary = beneficiaryAddress;
664 		auction.fee = fee;
665 		auction.auctionStart = start;
666 		auction.auctionEnd = start.add(duration * 1 days);
667 		auction.originalAuctionEnd = start.add(duration * 1 days);
668 		auction.extension = extension * 60;
669 
670 		auctions.push(id);
671 
672 		uint256 tokenId = IERC1155(memeLtdAddress).create(1, 1, "", "");
673 		require(tokenId > 0, "MEMEAuction::create: ERC1155 create did not succeed");
674 		auction.nft = tokenId;
675 	}
676 
677 	function bid(uint256 id, uint256 amount) public nonReentrant {
678 		AuctionInfo storage auction = auctionsById[id];
679 		require(auction.beneficiary != address(0), "MEMEAuction::bid: auction does not exist");
680 		require(now >= auction.auctionStart, "MEMEAuction::bid: auction has not started");
681 		require(now <= auction.auctionEnd, "MEMEAuction::bid: auction has ended");
682 
683 		uint256 newAmount = amount.add(balanceOf(msg.sender, id));
684 		require(newAmount > auction.highestBid, "MEMEAuction::bid: bid is less than highest bid");
685 
686 		auction.highestBidder = msg.sender;
687 		auction.highestBid = newAmount;
688 
689 		if (auction.extension > 0 && auction.auctionEnd.sub(now) <= auction.extension) {
690 			auction.auctionEnd = now.add(auction.extension);
691 		}
692 
693 		super.bid(id, amount);
694 		emit BidPlaced(msg.sender, id, amount);
695 	}
696 
697 	function withdraw(uint256 id) public nonReentrant {
698 		AuctionInfo storage auction = auctionsById[id];
699 		uint256 amount = balanceOf(msg.sender, id);
700 		require(auction.beneficiary != address(0), "MEMEAuction::withdraw: auction does not exist");
701 		require(amount > 0, "MEMEAuction::withdraw: cannot withdraw 0");
702 
703 		require(
704 			auction.highestBidder != msg.sender,
705 			"MEMEAuction::withdraw: you are the highest bidder and cannot withdraw"
706 		);
707 
708 		super.withdraw(id);
709 		emit Withdrawn(msg.sender, id, amount);
710 	}
711 
712 	function emergencyWithdraw(uint256 id) public onlyOwner {
713 		AuctionInfo storage auction = auctionsById[id];
714 		require(auction.beneficiary != address(0), "MEMEAuction::create: auction does not exist");
715 		require(now >= auction.auctionEnd, "MEMEAuction::emergencyWithdraw: the auction has not ended");
716 		require(!auction.auctionEnded, "MEMEAuction::emergencyWithdraw: auction ended and item sent");
717 
718 		_emergencyWithdraw(auction.highestBidder, id);
719 		emit Withdrawn(auction.highestBidder, id, auction.highestBid);
720 	}
721 
722 	function end(uint256 id) public nonReentrant {
723 		AuctionInfo storage auction = auctionsById[id];
724 		require(auction.beneficiary != address(0), "MEMEAuction::end: auction does not exist");
725 		require(now >= auction.auctionEnd, "MEMEAuction::end: the auction has not ended");
726 		require(!auction.auctionEnded, "MEMEAuction::end: auction already ended");
727 
728 		auction.auctionEnded = true;
729 		_end(id, auction.highestBidder, auction.beneficiary, runner, auction.fee, auction.highestBid);
730 		IERC1155(memeLtdAddress).safeTransferFrom(address(this), auction.highestBidder, auction.nft, 1, "");
731 		emit Ended(auction.highestBidder, id, auction.highestBid);
732 	}
733 
734 	function onERC1155Received(
735 		address _operator,
736 		address, // _from
737 		uint256, // _id
738 		uint256, // _amount
739 		bytes memory // _data
740 	) public returns (bytes4) {
741 		require(msg.sender == address(memeLtdAddress), "MEMEAuction::onERC1155BatchReceived:: invalid token address");
742 		require(_operator == address(this), "MEMEAuction::onERC1155BatchReceived:: operator must be auction contract");
743 
744 		// Return success
745 		return this.onERC1155Received.selector;
746 	}
747 
748 	function onERC1155BatchReceived(
749 		address _operator,
750 		address, // _from,
751 		uint256[] memory, // _ids,
752 		uint256[] memory, // _amounts,
753 		bytes memory // _data
754 	) public returns (bytes4) {
755 		require(msg.sender == address(memeLtdAddress), "MEMEAuction::onERC1155BatchReceived:: invalid token address");
756 		require(_operator == address(this), "MEMEAuction::onERC1155BatchReceived:: operator must be auction contract");
757 
758 		// Return success
759 		return this.onERC1155BatchReceived.selector;
760 	}
761 
762 	function supportsInterface(bytes4 interfaceID) external view returns (bool) {
763 		return
764 			interfaceID == 0x01ffc9a7 || // ERC-165 support
765 			interfaceID == 0x4e2312e0; // ERC-1155 `ERC1155TokenReceiver` support
766 	}
767 }