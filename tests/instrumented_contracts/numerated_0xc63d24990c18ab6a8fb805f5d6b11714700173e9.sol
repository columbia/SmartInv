1 // Should be compiled with v0.5.16+commit.9c3226ce and no optimizations to match Etherscan verification.
2 
3 
4 // File: @openzeppelin/contracts/GSN/Context.sol
5 
6 pragma solidity ^0.5.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 contract Context {
19     // Empty internal constructor, to prevent people from mistakenly deploying
20     // an instance of this contract, which should be used via inheritance.
21     constructor () internal { }
22     // solhint-disable-previous-line no-empty-blocks
23 
24     function _msgSender() internal view returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 // File: @openzeppelin/contracts/ownership/Ownable.sol
35 
36 pragma solidity ^0.5.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor () internal {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(isOwner(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Returns true if the caller is the current owner.
78      */
79     function isOwner() public view returns (bool) {
80         return _msgSender() == _owner;
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public onlyOwner {
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      */
106     function _transferOwnership(address newOwner) internal {
107         require(newOwner != address(0), "Ownable: new owner is the zero address");
108         emit OwnershipTransferred(_owner, newOwner);
109         _owner = newOwner;
110     }
111 }
112 
113 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
114 
115 pragma solidity ^0.5.0;
116 
117 /**
118  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
119  * the optional functions; to access them see {ERC20Detailed}.
120  */
121 interface IERC20 {
122     /**
123      * @dev Returns the amount of tokens in existence.
124      */
125     function totalSupply() external view returns (uint256);
126 
127     /**
128      * @dev Returns the amount of tokens owned by `account`.
129      */
130     function balanceOf(address account) external view returns (uint256);
131 
132     /**
133      * @dev Moves `amount` tokens from the caller's account to `recipient`.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transfer(address recipient, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Returns the remaining number of tokens that `spender` will be
143      * allowed to spend on behalf of `owner` through {transferFrom}. This is
144      * zero by default.
145      *
146      * This value changes when {approve} or {transferFrom} are called.
147      */
148     function allowance(address owner, address spender) external view returns (uint256);
149 
150     /**
151      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * IMPORTANT: Beware that changing an allowance with this method brings the risk
156      * that someone may use both the old and the new allowance by unfortunate
157      * transaction ordering. One possible solution to mitigate this race
158      * condition is to first reduce the spender's allowance to 0 and set the
159      * desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      *
162      * Emits an {Approval} event.
163      */
164     function approve(address spender, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Moves `amount` tokens from `sender` to `recipient` using the
168      * allowance mechanism. `amount` is then deducted from the caller's
169      * allowance.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
176 
177     /**
178      * @dev Emitted when `value` tokens are moved from one account (`from`) to
179      * another (`to`).
180      *
181      * Note that `value` may be zero.
182      */
183     event Transfer(address indexed from, address indexed to, uint256 value);
184 
185     /**
186      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
187      * a call to {approve}. `value` is the new allowance.
188      */
189     event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
191 
192 // File: @openzeppelin/contracts/math/SafeMath.sol
193 
194 pragma solidity ^0.5.0;
195 
196 /**
197  * @dev Wrappers over Solidity's arithmetic operations with added overflow
198  * checks.
199  *
200  * Arithmetic operations in Solidity wrap on overflow. This can easily result
201  * in bugs, because programmers usually assume that an overflow raises an
202  * error, which is the standard behavior in high level programming languages.
203  * `SafeMath` restores this intuition by reverting the transaction when an
204  * operation overflows.
205  *
206  * Using this library instead of the unchecked operations eliminates an entire
207  * class of bugs, so it's recommended to use it always.
208  */
209 library SafeMath {
210     /**
211      * @dev Returns the addition of two unsigned integers, reverting on
212      * overflow.
213      *
214      * Counterpart to Solidity's `+` operator.
215      *
216      * Requirements:
217      * - Addition cannot overflow.
218      */
219     function add(uint256 a, uint256 b) internal pure returns (uint256) {
220         uint256 c = a + b;
221         require(c >= a, "SafeMath: addition overflow");
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the subtraction of two unsigned integers, reverting on
228      * overflow (when the result is negative).
229      *
230      * Counterpart to Solidity's `-` operator.
231      *
232      * Requirements:
233      * - Subtraction cannot overflow.
234      */
235     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
236         return sub(a, b, "SafeMath: subtraction overflow");
237     }
238 
239     /**
240      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
241      * overflow (when the result is negative).
242      *
243      * Counterpart to Solidity's `-` operator.
244      *
245      * Requirements:
246      * - Subtraction cannot overflow.
247      *
248      * _Available since v2.4.0._
249      */
250     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b <= a, errorMessage);
252         uint256 c = a - b;
253 
254         return c;
255     }
256 
257     /**
258      * @dev Returns the multiplication of two unsigned integers, reverting on
259      * overflow.
260      *
261      * Counterpart to Solidity's `*` operator.
262      *
263      * Requirements:
264      * - Multiplication cannot overflow.
265      */
266     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
267         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
268         // benefit is lost if 'b' is also tested.
269         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
270         if (a == 0) {
271             return 0;
272         }
273 
274         uint256 c = a * b;
275         require(c / a == b, "SafeMath: multiplication overflow");
276 
277         return c;
278     }
279 
280     /**
281      * @dev Returns the integer division of two unsigned integers. Reverts on
282      * division by zero. The result is rounded towards zero.
283      *
284      * Counterpart to Solidity's `/` operator. Note: this function uses a
285      * `revert` opcode (which leaves remaining gas untouched) while Solidity
286      * uses an invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      * - The divisor cannot be zero.
290      */
291     function div(uint256 a, uint256 b) internal pure returns (uint256) {
292         return div(a, b, "SafeMath: division by zero");
293     }
294 
295     /**
296      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
297      * division by zero. The result is rounded towards zero.
298      *
299      * Counterpart to Solidity's `/` operator. Note: this function uses a
300      * `revert` opcode (which leaves remaining gas untouched) while Solidity
301      * uses an invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      * - The divisor cannot be zero.
305      *
306      * _Available since v2.4.0._
307      */
308     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
309         // Solidity only automatically asserts when dividing by 0
310         require(b > 0, errorMessage);
311         uint256 c = a / b;
312         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
313 
314         return c;
315     }
316 
317     /**
318      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
319      * Reverts when dividing by zero.
320      *
321      * Counterpart to Solidity's `%` operator. This function uses a `revert`
322      * opcode (which leaves remaining gas untouched) while Solidity uses an
323      * invalid opcode to revert (consuming all remaining gas).
324      *
325      * Requirements:
326      * - The divisor cannot be zero.
327      */
328     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
329         return mod(a, b, "SafeMath: modulo by zero");
330     }
331 
332     /**
333      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
334      * Reverts with custom message when dividing by zero.
335      *
336      * Counterpart to Solidity's `%` operator. This function uses a `revert`
337      * opcode (which leaves remaining gas untouched) while Solidity uses an
338      * invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      * - The divisor cannot be zero.
342      *
343      * _Available since v2.4.0._
344      */
345     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
346         require(b != 0, errorMessage);
347         return a % b;
348     }
349 }
350 
351 // File: @openzeppelin/contracts/utils/Address.sol
352 
353 pragma solidity ^0.5.5;
354 
355 /**
356  * @dev Collection of functions related to the address type
357  */
358 library Address {
359     /**
360      * @dev Returns true if `account` is a contract.
361      *
362      * [IMPORTANT]
363      * ====
364      * It is unsafe to assume that an address for which this function returns
365      * false is an externally-owned account (EOA) and not a contract.
366      *
367      * Among others, `isContract` will return false for the following 
368      * types of addresses:
369      *
370      *  - an externally-owned account
371      *  - a contract in construction
372      *  - an address where a contract will be created
373      *  - an address where a contract lived, but was destroyed
374      * ====
375      */
376     function isContract(address account) internal view returns (bool) {
377         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
378         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
379         // for accounts without code, i.e. `keccak256('')`
380         bytes32 codehash;
381         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
382         // solhint-disable-next-line no-inline-assembly
383         assembly { codehash := extcodehash(account) }
384         return (codehash != accountHash && codehash != 0x0);
385     }
386 
387     /**
388      * @dev Converts an `address` into `address payable`. Note that this is
389      * simply a type cast: the actual underlying value is not changed.
390      *
391      * _Available since v2.4.0._
392      */
393     function toPayable(address account) internal pure returns (address payable) {
394         return address(uint160(account));
395     }
396 
397     /**
398      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
399      * `recipient`, forwarding all available gas and reverting on errors.
400      *
401      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
402      * of certain opcodes, possibly making contracts go over the 2300 gas limit
403      * imposed by `transfer`, making them unable to receive funds via
404      * `transfer`. {sendValue} removes this limitation.
405      *
406      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
407      *
408      * IMPORTANT: because control is transferred to `recipient`, care must be
409      * taken to not create reentrancy vulnerabilities. Consider using
410      * {ReentrancyGuard} or the
411      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
412      *
413      * _Available since v2.4.0._
414      */
415     function sendValue(address payable recipient, uint256 amount) internal {
416         require(address(this).balance >= amount, "Address: insufficient balance");
417 
418         // solhint-disable-next-line avoid-call-value
419         (bool success, ) = recipient.call.value(amount)("");
420         require(success, "Address: unable to send value, recipient may have reverted");
421     }
422 }
423 
424 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
425 
426 pragma solidity ^0.5.0;
427 
428 
429 
430 
431 /**
432  * @title SafeERC20
433  * @dev Wrappers around ERC20 operations that throw on failure (when the token
434  * contract returns false). Tokens that return no value (and instead revert or
435  * throw on failure) are also supported, non-reverting calls are assumed to be
436  * successful.
437  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
438  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
439  */
440 library SafeERC20 {
441     using SafeMath for uint256;
442     using Address for address;
443 
444     function safeTransfer(IERC20 token, address to, uint256 value) internal {
445         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
446     }
447 
448     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
449         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
450     }
451 
452     function safeApprove(IERC20 token, address spender, uint256 value) internal {
453         // safeApprove should only be called when setting an initial allowance,
454         // or when resetting it to zero. To increase and decrease it, use
455         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
456         // solhint-disable-next-line max-line-length
457         require((value == 0) || (token.allowance(address(this), spender) == 0),
458             "SafeERC20: approve from non-zero to non-zero allowance"
459         );
460         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
461     }
462 
463     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
464         uint256 newAllowance = token.allowance(address(this), spender).add(value);
465         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
466     }
467 
468     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
469         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
470         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
471     }
472 
473     /**
474      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
475      * on the return value: the return value is optional (but if data is returned, it must not be false).
476      * @param token The token targeted by the call.
477      * @param data The call data (encoded using abi.encode or one of its variants).
478      */
479     function callOptionalReturn(IERC20 token, bytes memory data) private {
480         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
481         // we're implementing it ourselves.
482 
483         // A Solidity high level call has three parts:
484         //  1. The target address is checked to verify it contains contract code
485         //  2. The call itself is made, and success asserted
486         //  3. The return value is decoded, which in turn checks the size of the returned data.
487         // solhint-disable-next-line max-line-length
488         require(address(token).isContract(), "SafeERC20: call to non-contract");
489 
490         // solhint-disable-next-line avoid-low-level-calls
491         (bool success, bytes memory returndata) = address(token).call(data);
492         require(success, "SafeERC20: low-level call failed");
493 
494         if (returndata.length > 0) { // Return data is optional
495             // solhint-disable-next-line max-line-length
496             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
497         }
498     }
499 }
500 
501 // File: contracts/PaymentHandler.sol
502 
503 pragma solidity 0.5.16;
504 
505 // import "./PaymentMaster.sol";
506 
507 
508 
509 
510 /**
511  * The payment handler is responsible for receiving payments.
512  * If the payment is in ETH, it auto forwards to its parent master's owner.
513  * If the payment is in ERC20, it holds the tokens until it is asked to sweep.
514  * It can only sweep ERC20s to the parent master's owner.
515  */
516 contract PaymentHandler {
517 	using SafeERC20 for IERC20;
518 
519 	// a boolean to track whether a Proxied instance of this contract has been initialized
520 	bool public initialized = false;
521 
522 	// Keep track of the parent master contract - cannot be changed once set
523 	PaymentMaster public master;
524 
525 	/**
526 	 * General constructor called by the master
527 	 */
528 	function initialize(PaymentMaster _master) public {
529 		require(initialized == false, 'Contract is already initialized');
530 		initialized = true;
531 		master = _master;
532 	}
533 
534 	/**
535 	 * Helper function to return the parent master's address
536 	 */
537 	function getMasterAddress() public view returns (address) {
538 		return address(master);
539 	}
540 
541 	/**
542 	 * Default payable function - forwards to the owner and triggers event
543 	 */
544 	function() external payable {
545 		// Get the parent master's owner address - explicity convert to payable
546 		address payable ownerAddress = address(uint160(master.owner()));
547 
548 		// Forward the funds to the owner
549 		Address.sendValue(ownerAddress, msg.value);
550 
551 		// Trigger the event notification in the parent master
552 		master.firePaymentReceivedEvent(address(this), msg.sender, msg.value);
553 	}
554 
555 	/**
556 	 * Sweep any tokens to the owner of the master
557 	 */
558 	function sweepTokens(IERC20 token) public {
559 		// Get the owner address
560 		address ownerAddress = master.owner();
561 
562 		// Get the current balance
563 		uint balance = token.balanceOf(address(this));
564 
565 		// Transfer to the owner
566 		token.safeTransfer(ownerAddress, balance);
567 	}
568 
569 }
570 
571 // File: contracts/Proxy.sol
572 
573 pragma solidity 0.5.16;
574 
575 contract Proxy {
576     // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
577     // constructor(bytes memory constructData, address contractLogic) public {
578     constructor(address contractLogic) public {
579         // save the code address
580         assembly { // solium-disable-line
581             sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, contractLogic)
582         }
583     }
584 
585     function() external payable {
586         assembly { // solium-disable-line
587             let contractLogic := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
588             let ptr := mload(0x40)
589             calldatacopy(ptr, 0x0, calldatasize)
590             let success := delegatecall(gas, contractLogic, ptr, calldatasize, 0, 0)
591             let retSz := returndatasize
592             returndatacopy(ptr, 0, retSz)
593             switch success
594             case 0 {
595                 revert(ptr, retSz)
596             }
597             default {
598                 return(ptr, retSz)
599             }
600         }
601     }
602 }
603 
604 // File: contracts/PaymentMaster.sol
605 
606 pragma solidity 0.5.16;
607 
608 
609 
610 
611 
612 
613 /**
614  * The PaymentMaster sits above the payment handler contracts.
615  * It deploys and keeps track of all the handlers.
616  * It can trigger events by child handlers when they receive ETH.
617  * It allows ERC20 tokens to be swept in bulk to the owner account.
618  */
619 contract PaymentMaster is Ownable {
620 	using SafeERC20 for IERC20;
621 
622 	// payment handler logic contract address
623 	address public handlerLogicAddress ;
624 
625 	// A list of handler addresses for retrieval
626   address[] public handlerList;
627 
628 	// A mapping of handler addresses for lookups
629 	mapping(address => bool) public handlerMap;
630 
631 	// Events triggered for listeners
632 	event HandlerCreated(address indexed _addr);
633 	event EthPaymentReceived(address indexed _to, address indexed _from, uint256 _amount);
634 
635 	/** Deploy the payment handler logic contract */
636 	constructor() public {
637 		deployHandlerLogic();
638 	}
639 
640 	/**
641 	 * Called by the constructor this function deploys an instance of the PaymentHandler
642 	 * that can be used by subsequent handler deployments via Proxy
643 	 */
644 	function deployHandlerLogic() internal {
645 		// Deploy the new contract
646 		PaymentHandler createdHandler = new PaymentHandler();
647 
648 		// initialize the deployed PaymentHandler
649 		createdHandler.initialize(this);
650 
651 		// set the paymentHandlerLogicAddress
652 		handlerLogicAddress = address(createdHandler);
653 	}
654 
655 	/**
656 	 * Anyone can call the function to deploy a new payment handler.
657 	 * The new contract will be created, added to the list, and an event fired.
658 	 */
659 	function deployNewHandler() public {
660 		// Deploy the new Proxy contract with the handler logic address
661 		Proxy createdProxy = new Proxy(handlerLogicAddress);
662 
663 		// instantiate a PaymentHandler contract at the created Proxy address
664 		PaymentHandler proxyHandler = PaymentHandler(address(createdProxy));
665 
666 		// initialize the Proxy with this contract's address
667 		proxyHandler.initialize(this);
668 
669 		// Add it to the list and the mapping
670 		handlerList.push(address(createdProxy));
671 		handlerMap[address(createdProxy)] = true;
672 
673 		// Emit event to let watchers know that a new handler was created
674 		emit HandlerCreated(address(createdProxy));
675 	}
676 
677 	/**
678 	 * Allows caller to determine how long the handler list is for convenience
679 	 */
680 	function getHandlerListLength() public view returns (uint) {
681 		return handlerList.length;
682 	}
683 
684 	/**
685 	 * This function is called by handlers when they receive ETH payments.
686 	 */
687 	function firePaymentReceivedEvent(address to, address from, uint256 amount) public {
688 		// Verify the call is coming from a handler
689 		require(handlerMap[msg.sender], "Only payment handlers are allowed to trigger payment events.");
690 
691 		// Emit the event
692 		emit EthPaymentReceived(to, from, amount);
693 	}
694 
695 	/**
696 	 * Allows a caller to sweep multiple handlers in one transaction
697 	 */
698 	function multiHandlerSweep(address[] memory handlers, IERC20 tokenContract) public {
699 		for (uint i = 0; i < handlers.length; i++) {
700 
701 			// Whitelist calls to only handlers
702 			require(handlerMap[handlers[i]], "Only payment handlers are valid sweep targets.");
703 
704 			// Trigger sweep
705 			PaymentHandler(address(uint160(handlers[i]))).sweepTokens(tokenContract);
706 		}
707 	}
708 
709 	/**
710 	 * Safety function to allow sweep of ERC20s if accidentally sent to this contract
711 	 */
712 	function sweepTokens(IERC20 token) public {
713 		// Get the current balance
714 		uint balance = token.balanceOf(address(this));
715 
716 		// Transfer to the owner
717 		token.safeTransfer(this.owner(), balance);
718 	}
719 }