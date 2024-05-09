1 // Made in the Cloud by Tokensoft Inc
2 
3 // Should be compiled with v0.5.16+commit.9c3226ce and no optimizations to match Etherscan verification.
4 
5 
6 // File: @openzeppelin/contracts/GSN/Context.sol
7 
8 pragma solidity ^0.5.0;
9 
10 /*
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with GSN meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 contract Context {
21     // Empty internal constructor, to prevent people from mistakenly deploying
22     // an instance of this contract, which should be used via inheritance.
23     constructor () internal { }
24     // solhint-disable-previous-line no-empty-blocks
25 
26     function _msgSender() internal view returns (address payable) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 // File: @openzeppelin/contracts/ownership/Ownable.sol
37 
38 pragma solidity ^0.5.0;
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor () internal {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(isOwner(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Returns true if the caller is the current owner.
80      */
81     function isOwner() public view returns (bool) {
82         return _msgSender() == _owner;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public onlyOwner {
93         emit OwnershipTransferred(_owner, address(0));
94         _owner = address(0);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public onlyOwner {
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      */
108     function _transferOwnership(address newOwner) internal {
109         require(newOwner != address(0), "Ownable: new owner is the zero address");
110         emit OwnershipTransferred(_owner, newOwner);
111         _owner = newOwner;
112     }
113 }
114 
115 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
116 
117 pragma solidity ^0.5.0;
118 
119 /**
120  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
121  * the optional functions; to access them see {ERC20Detailed}.
122  */
123 interface IERC20 {
124     /**
125      * @dev Returns the amount of tokens in existence.
126      */
127     function totalSupply() external view returns (uint256);
128 
129     /**
130      * @dev Returns the amount of tokens owned by `account`.
131      */
132     function balanceOf(address account) external view returns (uint256);
133 
134     /**
135      * @dev Moves `amount` tokens from the caller's account to `recipient`.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transfer(address recipient, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Returns the remaining number of tokens that `spender` will be
145      * allowed to spend on behalf of `owner` through {transferFrom}. This is
146      * zero by default.
147      *
148      * This value changes when {approve} or {transferFrom} are called.
149      */
150     function allowance(address owner, address spender) external view returns (uint256);
151 
152     /**
153      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * IMPORTANT: Beware that changing an allowance with this method brings the risk
158      * that someone may use both the old and the new allowance by unfortunate
159      * transaction ordering. One possible solution to mitigate this race
160      * condition is to first reduce the spender's allowance to 0 and set the
161      * desired value afterwards:
162      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163      *
164      * Emits an {Approval} event.
165      */
166     function approve(address spender, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Moves `amount` tokens from `sender` to `recipient` using the
170      * allowance mechanism. `amount` is then deducted from the caller's
171      * allowance.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * Emits a {Transfer} event.
176      */
177     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
178 
179     /**
180      * @dev Emitted when `value` tokens are moved from one account (`from`) to
181      * another (`to`).
182      *
183      * Note that `value` may be zero.
184      */
185     event Transfer(address indexed from, address indexed to, uint256 value);
186 
187     /**
188      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
189      * a call to {approve}. `value` is the new allowance.
190      */
191     event Approval(address indexed owner, address indexed spender, uint256 value);
192 }
193 
194 // File: @openzeppelin/contracts/math/SafeMath.sol
195 
196 pragma solidity ^0.5.0;
197 
198 /**
199  * @dev Wrappers over Solidity's arithmetic operations with added overflow
200  * checks.
201  *
202  * Arithmetic operations in Solidity wrap on overflow. This can easily result
203  * in bugs, because programmers usually assume that an overflow raises an
204  * error, which is the standard behavior in high level programming languages.
205  * `SafeMath` restores this intuition by reverting the transaction when an
206  * operation overflows.
207  *
208  * Using this library instead of the unchecked operations eliminates an entire
209  * class of bugs, so it's recommended to use it always.
210  */
211 library SafeMath {
212     /**
213      * @dev Returns the addition of two unsigned integers, reverting on
214      * overflow.
215      *
216      * Counterpart to Solidity's `+` operator.
217      *
218      * Requirements:
219      * - Addition cannot overflow.
220      */
221     function add(uint256 a, uint256 b) internal pure returns (uint256) {
222         uint256 c = a + b;
223         require(c >= a, "SafeMath: addition overflow");
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the subtraction of two unsigned integers, reverting on
230      * overflow (when the result is negative).
231      *
232      * Counterpart to Solidity's `-` operator.
233      *
234      * Requirements:
235      * - Subtraction cannot overflow.
236      */
237     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
238         return sub(a, b, "SafeMath: subtraction overflow");
239     }
240 
241     /**
242      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
243      * overflow (when the result is negative).
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      * - Subtraction cannot overflow.
249      *
250      * _Available since v2.4.0._
251      */
252     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b <= a, errorMessage);
254         uint256 c = a - b;
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the multiplication of two unsigned integers, reverting on
261      * overflow.
262      *
263      * Counterpart to Solidity's `*` operator.
264      *
265      * Requirements:
266      * - Multiplication cannot overflow.
267      */
268     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
269         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
270         // benefit is lost if 'b' is also tested.
271         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
272         if (a == 0) {
273             return 0;
274         }
275 
276         uint256 c = a * b;
277         require(c / a == b, "SafeMath: multiplication overflow");
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the integer division of two unsigned integers. Reverts on
284      * division by zero. The result is rounded towards zero.
285      *
286      * Counterpart to Solidity's `/` operator. Note: this function uses a
287      * `revert` opcode (which leaves remaining gas untouched) while Solidity
288      * uses an invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      * - The divisor cannot be zero.
292      */
293     function div(uint256 a, uint256 b) internal pure returns (uint256) {
294         return div(a, b, "SafeMath: division by zero");
295     }
296 
297     /**
298      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
299      * division by zero. The result is rounded towards zero.
300      *
301      * Counterpart to Solidity's `/` operator. Note: this function uses a
302      * `revert` opcode (which leaves remaining gas untouched) while Solidity
303      * uses an invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      * - The divisor cannot be zero.
307      *
308      * _Available since v2.4.0._
309      */
310     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
311         // Solidity only automatically asserts when dividing by 0
312         require(b > 0, errorMessage);
313         uint256 c = a / b;
314         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
315 
316         return c;
317     }
318 
319     /**
320      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
321      * Reverts when dividing by zero.
322      *
323      * Counterpart to Solidity's `%` operator. This function uses a `revert`
324      * opcode (which leaves remaining gas untouched) while Solidity uses an
325      * invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      * - The divisor cannot be zero.
329      */
330     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
331         return mod(a, b, "SafeMath: modulo by zero");
332     }
333 
334     /**
335      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
336      * Reverts with custom message when dividing by zero.
337      *
338      * Counterpart to Solidity's `%` operator. This function uses a `revert`
339      * opcode (which leaves remaining gas untouched) while Solidity uses an
340      * invalid opcode to revert (consuming all remaining gas).
341      *
342      * Requirements:
343      * - The divisor cannot be zero.
344      *
345      * _Available since v2.4.0._
346      */
347     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
348         require(b != 0, errorMessage);
349         return a % b;
350     }
351 }
352 
353 // File: @openzeppelin/contracts/utils/Address.sol
354 
355 pragma solidity ^0.5.5;
356 
357 /**
358  * @dev Collection of functions related to the address type
359  */
360 library Address {
361     /**
362      * @dev Returns true if `account` is a contract.
363      *
364      * [IMPORTANT]
365      * ====
366      * It is unsafe to assume that an address for which this function returns
367      * false is an externally-owned account (EOA) and not a contract.
368      *
369      * Among others, `isContract` will return false for the following 
370      * types of addresses:
371      *
372      *  - an externally-owned account
373      *  - a contract in construction
374      *  - an address where a contract will be created
375      *  - an address where a contract lived, but was destroyed
376      * ====
377      */
378     function isContract(address account) internal view returns (bool) {
379         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
380         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
381         // for accounts without code, i.e. `keccak256('')`
382         bytes32 codehash;
383         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
384         // solhint-disable-next-line no-inline-assembly
385         assembly { codehash := extcodehash(account) }
386         return (codehash != accountHash && codehash != 0x0);
387     }
388 
389     /**
390      * @dev Converts an `address` into `address payable`. Note that this is
391      * simply a type cast: the actual underlying value is not changed.
392      *
393      * _Available since v2.4.0._
394      */
395     function toPayable(address account) internal pure returns (address payable) {
396         return address(uint160(account));
397     }
398 
399     /**
400      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
401      * `recipient`, forwarding all available gas and reverting on errors.
402      *
403      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
404      * of certain opcodes, possibly making contracts go over the 2300 gas limit
405      * imposed by `transfer`, making them unable to receive funds via
406      * `transfer`. {sendValue} removes this limitation.
407      *
408      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
409      *
410      * IMPORTANT: because control is transferred to `recipient`, care must be
411      * taken to not create reentrancy vulnerabilities. Consider using
412      * {ReentrancyGuard} or the
413      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
414      *
415      * _Available since v2.4.0._
416      */
417     function sendValue(address payable recipient, uint256 amount) internal {
418         require(address(this).balance >= amount, "Address: insufficient balance");
419 
420         // solhint-disable-next-line avoid-call-value
421         (bool success, ) = recipient.call.value(amount)("");
422         require(success, "Address: unable to send value, recipient may have reverted");
423     }
424 }
425 
426 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
427 
428 pragma solidity ^0.5.0;
429 
430 
431 
432 
433 /**
434  * @title SafeERC20
435  * @dev Wrappers around ERC20 operations that throw on failure (when the token
436  * contract returns false). Tokens that return no value (and instead revert or
437  * throw on failure) are also supported, non-reverting calls are assumed to be
438  * successful.
439  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
440  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
441  */
442 library SafeERC20 {
443     using SafeMath for uint256;
444     using Address for address;
445 
446     function safeTransfer(IERC20 token, address to, uint256 value) internal {
447         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
448     }
449 
450     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
451         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
452     }
453 
454     function safeApprove(IERC20 token, address spender, uint256 value) internal {
455         // safeApprove should only be called when setting an initial allowance,
456         // or when resetting it to zero. To increase and decrease it, use
457         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
458         // solhint-disable-next-line max-line-length
459         require((value == 0) || (token.allowance(address(this), spender) == 0),
460             "SafeERC20: approve from non-zero to non-zero allowance"
461         );
462         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
463     }
464 
465     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
466         uint256 newAllowance = token.allowance(address(this), spender).add(value);
467         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
468     }
469 
470     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
471         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
472         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
473     }
474 
475     /**
476      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
477      * on the return value: the return value is optional (but if data is returned, it must not be false).
478      * @param token The token targeted by the call.
479      * @param data The call data (encoded using abi.encode or one of its variants).
480      */
481     function callOptionalReturn(IERC20 token, bytes memory data) private {
482         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
483         // we're implementing it ourselves.
484 
485         // A Solidity high level call has three parts:
486         //  1. The target address is checked to verify it contains contract code
487         //  2. The call itself is made, and success asserted
488         //  3. The return value is decoded, which in turn checks the size of the returned data.
489         // solhint-disable-next-line max-line-length
490         require(address(token).isContract(), "SafeERC20: call to non-contract");
491 
492         // solhint-disable-next-line avoid-low-level-calls
493         (bool success, bytes memory returndata) = address(token).call(data);
494         require(success, "SafeERC20: low-level call failed");
495 
496         if (returndata.length > 0) { // Return data is optional
497             // solhint-disable-next-line max-line-length
498             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
499         }
500     }
501 }
502 
503 // File: contracts/PaymentHandler.sol
504 
505 pragma solidity 0.5.16;
506 
507 // import "./PaymentMaster.sol";
508 
509 
510 
511 
512 /**
513  * The payment handler is responsible for receiving payments.
514  * If the payment is in ETH, it auto forwards to its parent master's owner.
515  * If the payment is in ERC20, it holds the tokens until it is asked to sweep.
516  * It can only sweep ERC20s to the parent master's owner.
517  */
518 contract PaymentHandler {
519 	using SafeERC20 for IERC20;
520 
521 	// a boolean to track whether a Proxied instance of this contract has been initialized
522 	bool public initialized = false;
523 
524 	// Keep track of the parent master contract - cannot be changed once set
525 	PaymentMaster public master;
526 
527 	/**
528 	 * General constructor called by the master
529 	 */
530 	function initialize(PaymentMaster _master) public {
531 		require(initialized == false, 'Contract is already initialized');
532 		initialized = true;
533 		master = _master;
534 	}
535 
536 	/**
537 	 * Helper function to return the parent master's address
538 	 */
539 	function getMasterAddress() public view returns (address) {
540 		return address(master);
541 	}
542 
543 	/**
544 	 * Default payable function - forwards to the owner and triggers event
545 	 */
546 	function() external payable {
547 		// Get the parent master's owner address - explicity convert to payable
548 		address payable ownerAddress = address(uint160(master.owner()));
549 
550 		// Forward the funds to the owner
551 		Address.sendValue(ownerAddress, msg.value);
552 
553 		// Trigger the event notification in the parent master
554 		master.firePaymentReceivedEvent(address(this), msg.sender, msg.value);
555 	}
556 
557 	/**
558 	 * Sweep any tokens to the owner of the master
559 	 */
560 	function sweepTokens(IERC20 token) public {
561 		// Get the owner address
562 		address ownerAddress = master.owner();
563 
564 		// Get the current balance
565 		uint balance = token.balanceOf(address(this));
566 
567 		// Transfer to the owner
568 		token.safeTransfer(ownerAddress, balance);
569 	}
570 
571 }
572 
573 // File: contracts/Proxy.sol
574 
575 pragma solidity 0.5.16;
576 
577 contract Proxy {
578     // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
579     // constructor(bytes memory constructData, address contractLogic) public {
580     constructor(address contractLogic) public {
581         // save the code address
582         assembly { // solium-disable-line
583             sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, contractLogic)
584         }
585     }
586 
587     function() external payable {
588         assembly { // solium-disable-line
589             let contractLogic := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
590             let ptr := mload(0x40)
591             calldatacopy(ptr, 0x0, calldatasize)
592             let success := delegatecall(gas, contractLogic, ptr, calldatasize, 0, 0)
593             let retSz := returndatasize
594             returndatacopy(ptr, 0, retSz)
595             switch success
596             case 0 {
597                 revert(ptr, retSz)
598             }
599             default {
600                 return(ptr, retSz)
601             }
602         }
603     }
604 }
605 
606 // File: contracts/PaymentMaster.sol
607 
608 pragma solidity 0.5.16;
609 
610 
611 
612 
613 
614 
615 /**
616  * The PaymentMaster sits above the payment handler contracts.
617  * It deploys and keeps track of all the handlers.
618  * It can trigger events by child handlers when they receive ETH.
619  * It allows ERC20 tokens to be swept in bulk to the owner account.
620  */
621 contract PaymentMaster is Ownable {
622 	using SafeERC20 for IERC20;
623 
624 	// payment handler logic contract address
625 	address public handlerLogicAddress ;
626 
627 	// A list of handler addresses for retrieval
628   address[] public handlerList;
629 
630 	// A mapping of handler addresses for lookups
631 	mapping(address => bool) public handlerMap;
632 
633 	// Events triggered for listeners
634 	event HandlerCreated(address indexed _addr);
635 	event EthPaymentReceived(address indexed _to, address indexed _from, uint256 _amount);
636 
637 	/** Deploy the payment handler logic contract */
638 	constructor() public {
639 		deployHandlerLogic();
640 	}
641 
642 	/**
643 	 * Called by the constructor this function deploys an instance of the PaymentHandler
644 	 * that can be used by subsequent handler deployments via Proxy
645 	 */
646 	function deployHandlerLogic() internal {
647 		// Deploy the new contract
648 		PaymentHandler createdHandler = new PaymentHandler();
649 
650 		// initialize the deployed PaymentHandler
651 		createdHandler.initialize(this);
652 
653 		// set the paymentHandlerLogicAddress
654 		handlerLogicAddress = address(createdHandler);
655 	}
656 
657 	/**
658 	 * Anyone can call the function to deploy a new payment handler.
659 	 * The new contract will be created, added to the list, and an event fired.
660 	 */
661 	function deployNewHandler() public {
662 		// Deploy the new Proxy contract with the handler logic address
663 		Proxy createdProxy = new Proxy(handlerLogicAddress);
664 
665 		// instantiate a PaymentHandler contract at the created Proxy address
666 		PaymentHandler proxyHandler = PaymentHandler(address(createdProxy));
667 
668 		// initialize the Proxy with this contract's address
669 		proxyHandler.initialize(this);
670 
671 		// Add it to the list and the mapping
672 		handlerList.push(address(createdProxy));
673 		handlerMap[address(createdProxy)] = true;
674 
675 		// Emit event to let watchers know that a new handler was created
676 		emit HandlerCreated(address(createdProxy));
677 	}
678 
679 	/**
680 	 * Allows caller to determine how long the handler list is for convenience
681 	 */
682 	function getHandlerListLength() public view returns (uint) {
683 		return handlerList.length;
684 	}
685 
686 	/**
687 	 * This function is called by handlers when they receive ETH payments.
688 	 */
689 	function firePaymentReceivedEvent(address to, address from, uint256 amount) public {
690 		// Verify the call is coming from a handler
691 		require(handlerMap[msg.sender], "Only payment handlers are allowed to trigger payment events.");
692 
693 		// Emit the event
694 		emit EthPaymentReceived(to, from, amount);
695 	}
696 
697 	/**
698 	 * Allows a caller to sweep multiple handlers in one transaction
699 	 */
700 	function multiHandlerSweep(address[] memory handlers, IERC20 tokenContract) public {
701 		for (uint i = 0; i < handlers.length; i++) {
702 
703 			// Whitelist calls to only handlers
704 			require(handlerMap[handlers[i]], "Only payment handlers are valid sweep targets.");
705 
706 			// Trigger sweep
707 			PaymentHandler(address(uint160(handlers[i]))).sweepTokens(tokenContract);
708 		}
709 	}
710 
711 	/**
712 	 * Safety function to allow sweep of ERC20s if accidentally sent to this contract
713 	 */
714 	function sweepTokens(IERC20 token) public {
715 		// Get the current balance
716 		uint balance = token.balanceOf(address(this));
717 
718 		// Transfer to the owner
719 		token.safeTransfer(this.owner(), balance);
720 	}
721 }
722 
723 
724 // MIT License
725 
726 // Copyright (c) 2020 Tokensoft
727 
728 // Permission is hereby granted, free of charge, to any person obtaining a copy
729 // of this software and associated documentation files (the "Software"), to deal
730 // in the Software without restriction, including without limitation the rights
731 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
732 // copies of the Software, and to permit persons to whom the Software is
733 // furnished to do so, subject to the following conditions:
734 
735 // The above copyright notice and this permission notice shall be included in all
736 // copies or substantial portions of the Software.
737 
738 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
739 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
740 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
741 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
742 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
743 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
744 // SOFTWARE.