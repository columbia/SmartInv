1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
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
31 // File: @openzeppelin/contracts/ownership/Ownable.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(isOwner(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Returns true if the caller is the current owner.
75      */
76     function isOwner() public view returns (bool) {
77         return _msgSender() == _owner;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public onlyOwner {
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      */
103     function _transferOwnership(address newOwner) internal {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 }
109 
110 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
116  * the optional functions; to access them see {ERC20Detailed}.
117  */
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `recipient`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `sender` to `recipient` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 // File: @openzeppelin/contracts/math/SafeMath.sol
190 
191 pragma solidity ^0.5.0;
192 
193 /**
194  * @dev Wrappers over Solidity's arithmetic operations with added overflow
195  * checks.
196  *
197  * Arithmetic operations in Solidity wrap on overflow. This can easily result
198  * in bugs, because programmers usually assume that an overflow raises an
199  * error, which is the standard behavior in high level programming languages.
200  * `SafeMath` restores this intuition by reverting the transaction when an
201  * operation overflows.
202  *
203  * Using this library instead of the unchecked operations eliminates an entire
204  * class of bugs, so it's recommended to use it always.
205  */
206 library SafeMath {
207     /**
208      * @dev Returns the addition of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `+` operator.
212      *
213      * Requirements:
214      * - Addition cannot overflow.
215      */
216     function add(uint256 a, uint256 b) internal pure returns (uint256) {
217         uint256 c = a + b;
218         require(c >= a, "SafeMath: addition overflow");
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting on
225      * overflow (when the result is negative).
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233         return sub(a, b, "SafeMath: subtraction overflow");
234     }
235 
236     /**
237      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
238      * overflow (when the result is negative).
239      *
240      * Counterpart to Solidity's `-` operator.
241      *
242      * Requirements:
243      * - Subtraction cannot overflow.
244      *
245      * _Available since v2.4.0._
246      */
247     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b <= a, errorMessage);
249         uint256 c = a - b;
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the multiplication of two unsigned integers, reverting on
256      * overflow.
257      *
258      * Counterpart to Solidity's `*` operator.
259      *
260      * Requirements:
261      * - Multiplication cannot overflow.
262      */
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
265         // benefit is lost if 'b' is also tested.
266         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
267         if (a == 0) {
268             return 0;
269         }
270 
271         uint256 c = a * b;
272         require(c / a == b, "SafeMath: multiplication overflow");
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers. Reverts on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      * - The divisor cannot be zero.
287      */
288     function div(uint256 a, uint256 b) internal pure returns (uint256) {
289         return div(a, b, "SafeMath: division by zero");
290     }
291 
292     /**
293      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
294      * division by zero. The result is rounded towards zero.
295      *
296      * Counterpart to Solidity's `/` operator. Note: this function uses a
297      * `revert` opcode (which leaves remaining gas untouched) while Solidity
298      * uses an invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      * - The divisor cannot be zero.
302      *
303      * _Available since v2.4.0._
304      */
305     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
306         // Solidity only automatically asserts when dividing by 0
307         require(b > 0, errorMessage);
308         uint256 c = a / b;
309         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
310 
311         return c;
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * Reverts when dividing by zero.
317      *
318      * Counterpart to Solidity's `%` operator. This function uses a `revert`
319      * opcode (which leaves remaining gas untouched) while Solidity uses an
320      * invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      * - The divisor cannot be zero.
324      */
325     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
326         return mod(a, b, "SafeMath: modulo by zero");
327     }
328 
329     /**
330      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
331      * Reverts with custom message when dividing by zero.
332      *
333      * Counterpart to Solidity's `%` operator. This function uses a `revert`
334      * opcode (which leaves remaining gas untouched) while Solidity uses an
335      * invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      * - The divisor cannot be zero.
339      *
340      * _Available since v2.4.0._
341      */
342     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
343         require(b != 0, errorMessage);
344         return a % b;
345     }
346 }
347 
348 // File: @openzeppelin/contracts/utils/Address.sol
349 
350 pragma solidity ^0.5.5;
351 
352 /**
353  * @dev Collection of functions related to the address type
354  */
355 library Address {
356     /**
357      * @dev Returns true if `account` is a contract.
358      *
359      * [IMPORTANT]
360      * ====
361      * It is unsafe to assume that an address for which this function returns
362      * false is an externally-owned account (EOA) and not a contract.
363      *
364      * Among others, `isContract` will return false for the following 
365      * types of addresses:
366      *
367      *  - an externally-owned account
368      *  - a contract in construction
369      *  - an address where a contract will be created
370      *  - an address where a contract lived, but was destroyed
371      * ====
372      */
373     function isContract(address account) internal view returns (bool) {
374         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
375         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
376         // for accounts without code, i.e. `keccak256('')`
377         bytes32 codehash;
378         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
379         // solhint-disable-next-line no-inline-assembly
380         assembly { codehash := extcodehash(account) }
381         return (codehash != accountHash && codehash != 0x0);
382     }
383 
384     /**
385      * @dev Converts an `address` into `address payable`. Note that this is
386      * simply a type cast: the actual underlying value is not changed.
387      *
388      * _Available since v2.4.0._
389      */
390     function toPayable(address account) internal pure returns (address payable) {
391         return address(uint160(account));
392     }
393 
394     /**
395      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
396      * `recipient`, forwarding all available gas and reverting on errors.
397      *
398      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
399      * of certain opcodes, possibly making contracts go over the 2300 gas limit
400      * imposed by `transfer`, making them unable to receive funds via
401      * `transfer`. {sendValue} removes this limitation.
402      *
403      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
404      *
405      * IMPORTANT: because control is transferred to `recipient`, care must be
406      * taken to not create reentrancy vulnerabilities. Consider using
407      * {ReentrancyGuard} or the
408      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
409      *
410      * _Available since v2.4.0._
411      */
412     function sendValue(address payable recipient, uint256 amount) internal {
413         require(address(this).balance >= amount, "Address: insufficient balance");
414 
415         // solhint-disable-next-line avoid-call-value
416         (bool success, ) = recipient.call.value(amount)("");
417         require(success, "Address: unable to send value, recipient may have reverted");
418     }
419 }
420 
421 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
422 
423 pragma solidity ^0.5.0;
424 
425 
426 
427 
428 /**
429  * @title SafeERC20
430  * @dev Wrappers around ERC20 operations that throw on failure (when the token
431  * contract returns false). Tokens that return no value (and instead revert or
432  * throw on failure) are also supported, non-reverting calls are assumed to be
433  * successful.
434  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
435  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
436  */
437 library SafeERC20 {
438     using SafeMath for uint256;
439     using Address for address;
440 
441     function safeTransfer(IERC20 token, address to, uint256 value) internal {
442         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
443     }
444 
445     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
446         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
447     }
448 
449     function safeApprove(IERC20 token, address spender, uint256 value) internal {
450         // safeApprove should only be called when setting an initial allowance,
451         // or when resetting it to zero. To increase and decrease it, use
452         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
453         // solhint-disable-next-line max-line-length
454         require((value == 0) || (token.allowance(address(this), spender) == 0),
455             "SafeERC20: approve from non-zero to non-zero allowance"
456         );
457         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
458     }
459 
460     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
461         uint256 newAllowance = token.allowance(address(this), spender).add(value);
462         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
463     }
464 
465     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
466         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
467         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
468     }
469 
470     /**
471      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
472      * on the return value: the return value is optional (but if data is returned, it must not be false).
473      * @param token The token targeted by the call.
474      * @param data The call data (encoded using abi.encode or one of its variants).
475      */
476     function callOptionalReturn(IERC20 token, bytes memory data) private {
477         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
478         // we're implementing it ourselves.
479 
480         // A Solidity high level call has three parts:
481         //  1. The target address is checked to verify it contains contract code
482         //  2. The call itself is made, and success asserted
483         //  3. The return value is decoded, which in turn checks the size of the returned data.
484         // solhint-disable-next-line max-line-length
485         require(address(token).isContract(), "SafeERC20: call to non-contract");
486 
487         // solhint-disable-next-line avoid-low-level-calls
488         (bool success, bytes memory returndata) = address(token).call(data);
489         require(success, "SafeERC20: low-level call failed");
490 
491         if (returndata.length > 0) { // Return data is optional
492             // solhint-disable-next-line max-line-length
493             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
494         }
495     }
496 }
497 
498 // File: contracts/PaymentHandler.sol
499 
500 pragma solidity ^0.5.0;
501 
502 
503 
504 /**
505  * The payment handler is responsible for receiving payments.
506  * If the payment is in ETH, it auto forwards to its parent master's owner.
507  * If the payment is in ERC20, it holds the tokens until it is asked to sweep.
508  * It can only sweep ERC20s to the parent master's owner.
509  */
510 contract PaymentHandler {
511 	using SafeERC20 for IERC20;
512 
513 	// Keep track of the parent master contract - cannot be changed once set
514 	PaymentMaster public master;
515 
516 	/**
517 	 * General constructor called by the master
518 	 */
519 	constructor(PaymentMaster _master) public {
520 		master = _master;
521 	}
522 
523 	/**
524 	 * Helper function to return the parent master's address
525 	 */
526 	function getMasterAddress() public view returns (address) {
527 		return address(master);
528 	}
529 
530 	/**
531 	 * Default payable function - forwards to the owner and triggers event
532 	 */
533 	function() external payable {
534 		// Get the parent master's owner address - explicity convert to payable
535 		address payable ownerAddress = address(uint160(master.owner()));
536 
537 		// Forward the funds to the owner
538 		ownerAddress.transfer(msg.value);
539 
540 		// Trigger the event notification in the parent master
541 		master.firePaymentReceivedEvent(address(this), msg.sender, msg.value);
542 	}
543 
544 	/**
545 	 * Sweep any tokens to the owner of the master
546 	 */
547 	function sweepTokens(IERC20 token) public {
548 		// Get the owner address
549 		address ownerAddress = master.owner();
550 
551 		// Get the current balance
552 		uint balance = token.balanceOf(address(this));
553 
554 		// Transfer to the owner
555 		token.safeTransfer(ownerAddress, balance);
556 	}
557 
558 }
559 
560 // File: contracts/PaymentMaster.sol
561 
562 pragma solidity ^0.5.0;
563 
564 
565 
566 
567 
568 /**
569  * The PaymentMaster sits above the payment handler contracts.
570  * It deploys and keeps track of all the handlers.
571  * It can trigger events by child handlers when they receive ETH.
572  * It allows ERC20 tokens to be swept in bulk to the owner account.
573  */
574 contract PaymentMaster is Ownable {
575 	using SafeERC20 for IERC20;
576 
577 	// A list of handler addresses for retrieval
578   address[] public handlerList;
579 
580 	// A mapping of handler addresses for lookups
581 	mapping(address => bool) public handlerMap;
582 
583 	// Events triggered for listeners
584 	event HandlerCreated(address indexed _addr);
585 	event EthPaymentReceived(address indexed _to, address indexed _from, uint256 _amount);
586 
587 	/**
588 	 * Anyone can call the function to deploy a new payment handler.
589 	 * The new contract will be created, added to the list, and an event fired.
590 	 */
591 	function deployNewHandler() public {
592 		// Deploy the new contract
593 		PaymentHandler createdHandler = new PaymentHandler(this);
594 
595 		// Add it to the list and the mapping
596 		handlerList.push(address(createdHandler));
597 		handlerMap[address(createdHandler)] = true;
598 
599 		// Emit event to let watchers know that a new handler was created
600 		emit HandlerCreated(address(createdHandler));
601 	}
602 
603 	/**
604 	 * This is a convenience method to allow watchers to get the entire list
605 	 */
606 	function getHandlerList() public view returns (address[] memory) {
607 			// Return the entire list
608       return handlerList;
609   }
610 
611 	/**
612 	 * Allows caller to determine how long the handler list is for convenience
613 	 */
614 	function getHandlerListLength() public view returns (uint) {
615 		return handlerList.length;
616 	}
617 
618 	/**
619 	 * This function is called by handlers when they receive ETH payments.
620 	 */
621 	function firePaymentReceivedEvent(address to, address from, uint256 amount) public {
622 		// Verify the call is coming from a handler
623 		require(handlerMap[msg.sender], "Only payment handlers are allowed to trigger payment events.");
624 
625 		// Emit the event
626 		emit EthPaymentReceived(to, from, amount);
627 	}
628 
629 	/**
630 	 * Allows a caller to sweep multiple handlers in one transaction
631 	 */
632 	function multiHandlerSweep(address[] memory handlers, IERC20 tokenContract) public {
633 		for (uint i = 0; i < handlers.length; i++) {
634 
635 			// Whitelist calls to only handlers
636 			require(handlerMap[handlers[i]], "Only payment handlers are valid sweep targets.");
637 
638 			// Trigger sweep
639 			PaymentHandler(address(uint160(handlers[i]))).sweepTokens(tokenContract);
640 		}
641 	}
642 
643 	/**
644 	 * Safety function to allow sweep of ERC20s if accidentally sent to this contract
645 	 */
646 	function sweepTokens(IERC20 token) public {
647 		// Get the current balance
648 		uint balance = token.balanceOf(address(this));
649 
650 		// Transfer to the owner
651 		token.safeTransfer(this.owner(), balance);
652 	}
653 }