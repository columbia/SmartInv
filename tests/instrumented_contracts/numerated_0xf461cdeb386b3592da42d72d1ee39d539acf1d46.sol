1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-08
3 */
4 
5 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 pragma solidity ^0.5.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
11  * the optional functions; to access them see {ERC20Detailed}.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 // File: @openzeppelin/contracts/math/SafeMath.sol
85 
86 pragma solidity ^0.5.0;
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      * - Subtraction cannot overflow.
139      *
140      * _Available since v2.4.0._
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      * - The divisor cannot be zero.
197      *
198      * _Available since v2.4.0._
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         // Solidity only automatically asserts when dividing by 0
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      * - The divisor cannot be zero.
234      *
235      * _Available since v2.4.0._
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 pragma solidity ^0.5.5;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following 
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
270         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
271         // for accounts without code, i.e. `keccak256('')`
272         bytes32 codehash;
273         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { codehash := extcodehash(account) }
276         return (codehash != accountHash && codehash != 0x0);
277     }
278 
279     /**
280      * @dev Converts an `address` into `address payable`. Note that this is
281      * simply a type cast: the actual underlying value is not changed.
282      *
283      * _Available since v2.4.0._
284      */
285     function toPayable(address account) internal pure returns (address payable) {
286         return address(uint160(account));
287     }
288 
289     /**
290      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291      * `recipient`, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by `transfer`, making them unable to receive funds via
296      * `transfer`. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to `recipient`, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      *
305      * _Available since v2.4.0._
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         // solhint-disable-next-line avoid-call-value
311         (bool success, ) = recipient.call.value(amount)("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 }
315 
316 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
317 
318 pragma solidity ^0.5.0;
319 
320 
321 
322 
323 /**
324  * @title SafeERC20
325  * @dev Wrappers around ERC20 operations that throw on failure (when the token
326  * contract returns false). Tokens that return no value (and instead revert or
327  * throw on failure) are also supported, non-reverting calls are assumed to be
328  * successful.
329  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
330  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
331  */
332 library SafeERC20 {
333     using SafeMath for uint256;
334     using Address for address;
335 
336     function safeTransfer(IERC20 token, address to, uint256 value) internal {
337         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
338     }
339 
340     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
341         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
342     }
343 
344     function safeApprove(IERC20 token, address spender, uint256 value) internal {
345         // safeApprove should only be called when setting an initial allowance,
346         // or when resetting it to zero. To increase and decrease it, use
347         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
348         // solhint-disable-next-line max-line-length
349         require((value == 0) || (token.allowance(address(this), spender) == 0),
350             "SafeERC20: approve from non-zero to non-zero allowance"
351         );
352         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
353     }
354 
355     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
356         uint256 newAllowance = token.allowance(address(this), spender).add(value);
357         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
358     }
359 
360     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
361         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
362         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
363     }
364 
365     /**
366      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
367      * on the return value: the return value is optional (but if data is returned, it must not be false).
368      * @param token The token targeted by the call.
369      * @param data The call data (encoded using abi.encode or one of its variants).
370      */
371     function callOptionalReturn(IERC20 token, bytes memory data) private {
372         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
373         // we're implementing it ourselves.
374 
375         // A Solidity high level call has three parts:
376         //  1. The target address is checked to verify it contains contract code
377         //  2. The call itself is made, and success asserted
378         //  3. The return value is decoded, which in turn checks the size of the returned data.
379         // solhint-disable-next-line max-line-length
380         require(address(token).isContract(), "SafeERC20: call to non-contract");
381 
382         // solhint-disable-next-line avoid-low-level-calls
383         (bool success, bytes memory returndata) = address(token).call(data);
384         require(success, "SafeERC20: low-level call failed");
385 
386         if (returndata.length > 0) { // Return data is optional
387             // solhint-disable-next-line max-line-length
388             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
389         }
390     }
391 }
392 
393 // File: contracts/PaymentHandler.sol
394 
395 pragma solidity 0.5.16;
396 
397 // import "./PaymentMaster.sol";
398 
399 
400 
401 
402 /**
403  * The payment handler is responsible for receiving payments.
404  * If the payment is in ETH, it auto forwards to its parent master's owner.
405  * If the payment is in ERC20, it holds the tokens until it is asked to sweep.
406  * It can only sweep ERC20s to the parent master's owner.
407  */
408 contract PaymentHandler {
409 	using SafeERC20 for IERC20;
410 
411 	// a boolean to track whether a Proxied instance of this contract has been initialized
412 	bool public initialized = false;
413 
414 	// Keep track of the parent master contract - cannot be changed once set
415 	PaymentMaster public master;
416 
417 	/**
418 	 * General constructor called by the master
419 	 */
420 	function initialize(PaymentMaster _master) public {
421 		require(initialized == false, 'Contract is already initialized');
422 		initialized = true;
423 		master = _master;
424 	}
425 
426 	/**
427 	 * Helper function to return the parent master's address
428 	 */
429 	function getMasterAddress() public view returns (address) {
430 		return address(master);
431 	}
432 
433 	/**
434 	 * Default payable function - forwards to the owner and triggers event
435 	 */
436 	function() external payable {
437 		// Get the parent master's owner address - explicity convert to payable
438 		address payable ownerAddress = address(uint160(master.owner()));
439 
440 		// Forward the funds to the owner
441 		Address.sendValue(ownerAddress, msg.value);
442 
443 		// Trigger the event notification in the parent master
444 		master.firePaymentReceivedEvent(address(this), msg.sender, msg.value);
445 	}
446 
447 	/**
448 	 * Sweep any tokens to the owner of the master
449 	 */
450 	function sweepTokens(IERC20 token) public {
451 		// Get the owner address
452 		address ownerAddress = master.owner();
453 
454 		// Get the current balance
455 		uint balance = token.balanceOf(address(this));
456 
457 		// Transfer to the owner
458 		token.safeTransfer(ownerAddress, balance);
459 	}
460 
461 }
462 
463 // File: contracts/Proxy.sol
464 
465 pragma solidity 0.5.16;
466 
467 contract Proxy {
468     // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
469     // constructor(bytes memory constructData, address contractLogic) public {
470     constructor(address contractLogic) public {
471         // save the code address
472         assembly { // solium-disable-line
473             sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, contractLogic)
474         }
475     }
476 
477     function() external payable {
478         assembly { // solium-disable-line
479             let contractLogic := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
480             let ptr := mload(0x40)
481             calldatacopy(ptr, 0x0, calldatasize)
482             let success := delegatecall(gas, contractLogic, ptr, calldatasize, 0, 0)
483             let retSz := returndatasize
484             returndatacopy(ptr, 0, retSz)
485             switch success
486             case 0 {
487                 revert(ptr, retSz)
488             }
489             default {
490                 return(ptr, retSz)
491             }
492         }
493     }
494 }
495 
496 // File: contracts/PaymentMaster.sol
497 
498 pragma solidity 0.5.16;
499 
500 
501 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
502 // import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
503 
504 /**
505  * The PaymentMaster sits above the payment handler contracts.
506  * It deploys and keeps track of all the handlers.
507  * It can trigger events by child handlers when they receive ETH.
508  * It allows ERC20 tokens to be swept in bulk to the owner account.
509  */
510 contract PaymentMaster {
511 	using SafeERC20 for IERC20;
512 
513 	address public owner;
514 
515 	// payment handler logic contract address
516 	address public handlerLogicAddress ;
517 
518 	// A list of handler addresses for retrieval
519   address[] public handlerList;
520 
521 	// A mapping of handler addresses for lookups
522 	mapping(address => bool) public handlerMap;
523 
524 	// Events triggered for listeners
525 	event HandlerCreated(address indexed _addr);
526 	event EthPaymentReceived(address indexed _to, address indexed _from, uint256 _amount);
527 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
528 
529 	bool initialized = false;
530 
531 	function initialize(address _owner, address _handlerLogicAddress) public {
532 		require(initialized == false, "Already initialized");
533 		initialized = true;
534 
535 		handlerLogicAddress = _handlerLogicAddress;
536 		owner = _owner;
537 	}
538 
539 	/**
540 	 * Anyone can call the function to deploy a new payment handler.
541 	 * The new contract will be created, added to the list, and an event fired.
542 	 */
543 	function deployNewHandler() public {
544 		// Deploy the new Proxy contract with the handler logic address
545 		Proxy createdProxy = new Proxy(handlerLogicAddress);
546 
547 		// instantiate a PaymentHandler contract at the created Proxy address
548 		PaymentHandler proxyHandler = PaymentHandler(address(createdProxy));
549 
550 		// initialize the Proxy with this contract's address
551 		proxyHandler.initialize(this);
552 
553 		// Add it to the list and the mapping
554 		handlerList.push(address(createdProxy));
555 		handlerMap[address(createdProxy)] = true;
556 
557 		// Emit event to let watchers know that a new handler was created
558 		emit HandlerCreated(address(createdProxy));
559 	}
560 
561 	/**
562 	 * Allows caller to determine how long the handler list is for convenience
563 	 */
564 	function getHandlerListLength() public view returns (uint) {
565 		return handlerList.length;
566 	}
567 
568 	/**
569 	 * This function is called by handlers when they receive ETH payments.
570 	 */
571 	function firePaymentReceivedEvent(address to, address from, uint256 amount) public {
572 		// Verify the call is coming from a handler
573 		require(handlerMap[msg.sender], "Only payment handlers are allowed to trigger payment events.");
574 
575 		// Emit the event
576 		emit EthPaymentReceived(to, from, amount);
577 	}
578 
579 	/**
580 	 * Allows a caller to sweep multiple handlers in one transaction
581 	 */
582 	function multiHandlerSweep(address[] memory handlers, IERC20 tokenContract) public {
583 		for (uint i = 0; i < handlers.length; i++) {
584 
585 			// Whitelist calls to only handlers
586 			require(handlerMap[handlers[i]], "Only payment handlers are valid sweep targets.");
587 
588 			// Trigger sweep
589 			PaymentHandler(address(uint160(handlers[i]))).sweepTokens(tokenContract);
590 		}
591 	}
592 
593 	/**
594 	 * Safety function to allow sweep of ERC20s if accidentally sent to this contract
595 	 */
596 	function sweepTokens(IERC20 token) public {
597 		// Get the current balance
598 		uint balance = token.balanceOf(address(this));
599 
600 		// Transfer to the owner
601 		token.safeTransfer(owner, balance);
602 	}
603 
604 	function transferOwnership(address newOwner) public {
605 		require(msg.sender == owner, "Not owner");
606 		owner = newOwner;
607 		emit OwnershipTransferred(msg.sender, newOwner);
608 	}
609 }
610 
611 // File: contracts/PaymentMasterFactory.sol
612 
613 pragma solidity 0.5.16;
614 
615 // import "./Proxy.sol";
616 
617 /**
618 Deploys new instances of the Payment Master
619  */
620 contract PaymentMasterFactory {
621 
622 	// payment master logic contract address
623 	address public masterLogicAddress ;
624 	address public handlerLogicAddress;
625 
626 	// Events triggered for listeners
627 	event MasterCreated(address indexed _addr);
628 
629 	/** Deploy the payment handler logic contract */
630 	constructor() public {
631 		deployLogic();
632 	}
633 
634 	/**
635 	 * Called by the constructor this function deploys impl contracts
636 	 */
637 	function deployLogic() internal {
638 		// Deploy the new master contract
639 		PaymentMaster createdMaster = new PaymentMaster();
640 		masterLogicAddress = address(createdMaster);
641 
642 		// Deploy the new handler contract
643 		PaymentHandler createdHandler = new PaymentHandler();
644 		handlerLogicAddress = address(createdHandler);
645 
646 		// initialize the deployed contracts - not needed but just in case
647 		createdHandler.initialize(createdMaster);
648 		createdMaster.initialize(msg.sender, address(handlerLogicAddress));
649 	}
650 
651 	/**
652 	Called to create a new payment master and emit an event
653 	 */
654 	function deployNewMaster(address owner) public {
655 		// Deploy the new Proxy contract with the handler logic address
656 		Proxy createdProxy = new Proxy(masterLogicAddress);
657 
658 		// instantiate a PaymentMaster contract at the created Proxy address
659 		PaymentMaster proxyMaster = PaymentMaster(address(createdProxy));
660 
661 		// Initialize with the owner address and logic impl address
662 		proxyMaster.initialize(owner, address(handlerLogicAddress));
663 
664 		// Emit the event that a new master was deployed
665 		emit MasterCreated(address(proxyMaster));
666 	}
667 }