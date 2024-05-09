1 pragma solidity >=0.4.24 <0.7.0;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor () internal { }
18     // solhint-disable-previous-line no-empty-blocks
19 
20     function _msgSender() internal view returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @title Roles
32  * @dev Library for managing addresses assigned to a Role.
33  */
34 library Roles {
35     struct Role {
36         mapping (address => bool) bearer;
37     }
38 
39     /**
40      * @dev Give an account access to this role.
41      */
42     function add(Role storage role, address account) internal {
43         require(!has(role, account), "Roles: account already has role");
44         role.bearer[account] = true;
45     }
46 
47     /**
48      * @dev Remove an account's access to this role.
49      */
50     function remove(Role storage role, address account) internal {
51         require(has(role, account), "Roles: account does not have role");
52         role.bearer[account] = false;
53     }
54 
55     /**
56      * @dev Check if an account has this role.
57      * @return bool
58      */
59     function has(Role storage role, address account) internal view returns (bool) {
60         require(account != address(0), "Roles: account is the zero address");
61         return role.bearer[account];
62     }
63 }
64 
65 contract PauserRole is Context {
66     using Roles for Roles.Role;
67 
68     event PauserAdded(address indexed account);
69     event PauserRemoved(address indexed account);
70 
71     Roles.Role private _pausers;
72 
73     constructor () internal {
74         _addPauser(_msgSender());
75     }
76 
77     modifier onlyPauser() {
78         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
79         _;
80     }
81 
82     function isPauser(address account) public view returns (bool) {
83         return _pausers.has(account);
84     }
85 
86     function addPauser(address account) public onlyPauser {
87         _addPauser(account);
88     }
89 
90     function renouncePauser() public {
91         _removePauser(_msgSender());
92     }
93 
94     function _addPauser(address account) internal {
95         _pausers.add(account);
96         emit PauserAdded(account);
97     }
98 
99     function _removePauser(address account) internal {
100         _pausers.remove(account);
101         emit PauserRemoved(account);
102     }
103 }
104 
105 /**
106  * @dev Contract module which allows children to implement an emergency stop
107  * mechanism that can be triggered by an authorized account.
108  *
109  * This module is used through inheritance. It will make available the
110  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
111  * the functions of your contract. Note that they will not be pausable by
112  * simply including this module, only once the modifiers are put in place.
113  */
114 contract Pausable is Context, PauserRole {
115     /**
116      * @dev Emitted when the pause is triggered by a pauser (`account`).
117      */
118     event Paused(address account);
119 
120     /**
121      * @dev Emitted when the pause is lifted by a pauser (`account`).
122      */
123     event Unpaused(address account);
124 
125     bool private _paused;
126 
127     /**
128      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
129      * to the deployer.
130      */
131     constructor () internal {
132         _paused = false;
133     }
134 
135     /**
136      * @dev Returns true if the contract is paused, and false otherwise.
137      */
138     function paused() public view returns (bool) {
139         return _paused;
140     }
141 
142     /**
143      * @dev Modifier to make a function callable only when the contract is not paused.
144      */
145     modifier whenNotPaused() {
146         require(!_paused, "Pausable: paused");
147         _;
148     }
149 
150     /**
151      * @dev Modifier to make a function callable only when the contract is paused.
152      */
153     modifier whenPaused() {
154         require(_paused, "Pausable: not paused");
155         _;
156     }
157 
158     /**
159      * @dev Called by a pauser to pause, triggers stopped state.
160      */
161     function pause() public onlyPauser whenNotPaused {
162         _paused = true;
163         emit Paused(_msgSender());
164     }
165 
166     /**
167      * @dev Called by a pauser to unpause, returns to normal state.
168      */
169     function unpause() public onlyPauser whenPaused {
170         _paused = false;
171         emit Unpaused(_msgSender());
172     }
173 }
174 
175 /**
176  * @dev Contract module that helps prevent reentrant calls to a function.
177  *
178  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
179  * available, which can be applied to functions to make sure there are no nested
180  * (reentrant) calls to them.
181  *
182  * Note that because there is a single `nonReentrant` guard, functions marked as
183  * `nonReentrant` may not call one another. This can be worked around by making
184  * those functions `private`, and then adding `external` `nonReentrant` entry
185  * points to them.
186  *
187  * TIP: If you would like to learn more about reentrancy and alternative ways
188  * to protect against it, check out our blog post
189  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
190  *
191  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
192  * metering changes introduced in the Istanbul hardfork.
193  */
194 contract ReentrancyGuard {
195     bool private _notEntered;
196 
197     constructor () internal {
198         // Storing an initial non-zero value makes deployment a bit more
199         // expensive, but in exchange the refund on every call to nonReentrant
200         // will be lower in amount. Since refunds are capped to a percetange of
201         // the total transaction's gas, it is best to keep them low in cases
202         // like this one, to increase the likelihood of the full refund coming
203         // into effect.
204         _notEntered = true;
205     }
206 
207     /**
208      * @dev Prevents a contract from calling itself, directly or indirectly.
209      * Calling a `nonReentrant` function from another `nonReentrant`
210      * function is not supported. It is possible to prevent this from happening
211      * by making the `nonReentrant` function external, and make it call a
212      * `private` function that does the actual work.
213      */
214     modifier nonReentrant() {
215         // On the first call to nonReentrant, _notEntered will be true
216         require(_notEntered, "ReentrancyGuard: reentrant call");
217 
218         // Any calls to nonReentrant after this point will fail
219         _notEntered = false;
220 
221         _;
222 
223         // By storing the original value once again, a refund is triggered (see
224         // https://eips.ethereum.org/EIPS/eip-2200)
225         _notEntered = true;
226     }
227 }
228 
229 /**
230  * @dev Wrappers over Solidity's arithmetic operations with added overflow
231  * checks.
232  *
233  * Arithmetic operations in Solidity wrap on overflow. This can easily result
234  * in bugs, because programmers usually assume that an overflow raises an
235  * error, which is the standard behavior in high level programming languages.
236  * `SafeMath` restores this intuition by reverting the transaction when an
237  * operation overflows.
238  *
239  * Using this library instead of the unchecked operations eliminates an entire
240  * class of bugs, so it's recommended to use it always.
241  */
242 library SafeMath {
243     /**
244      * @dev Returns the addition of two unsigned integers, reverting on
245      * overflow.
246      *
247      * Counterpart to Solidity's `+` operator.
248      *
249      * Requirements:
250      * - Addition cannot overflow.
251      */
252     function add(uint256 a, uint256 b) internal pure returns (uint256) {
253         uint256 c = a + b;
254         require(c >= a, "SafeMath: addition overflow");
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the subtraction of two unsigned integers, reverting on
261      * overflow (when the result is negative).
262      *
263      * Counterpart to Solidity's `-` operator.
264      *
265      * Requirements:
266      * - Subtraction cannot overflow.
267      */
268     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
269         return sub(a, b, "SafeMath: subtraction overflow");
270     }
271 
272     /**
273      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
274      * overflow (when the result is negative).
275      *
276      * Counterpart to Solidity's `-` operator.
277      *
278      * Requirements:
279      * - Subtraction cannot overflow.
280      *
281      * _Available since v2.4.0._
282      */
283     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         require(b <= a, errorMessage);
285         uint256 c = a - b;
286 
287         return c;
288     }
289 
290     /**
291      * @dev Returns the multiplication of two unsigned integers, reverting on
292      * overflow.
293      *
294      * Counterpart to Solidity's `*` operator.
295      *
296      * Requirements:
297      * - Multiplication cannot overflow.
298      */
299     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
300         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
301         // benefit is lost if 'b' is also tested.
302         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
303         if (a == 0) {
304             return 0;
305         }
306 
307         uint256 c = a * b;
308         require(c / a == b, "SafeMath: multiplication overflow");
309 
310         return c;
311     }
312 
313     /**
314      * @dev Returns the integer division of two unsigned integers. Reverts on
315      * division by zero. The result is rounded towards zero.
316      *
317      * Counterpart to Solidity's `/` operator. Note: this function uses a
318      * `revert` opcode (which leaves remaining gas untouched) while Solidity
319      * uses an invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      * - The divisor cannot be zero.
323      */
324     function div(uint256 a, uint256 b) internal pure returns (uint256) {
325         return div(a, b, "SafeMath: division by zero");
326     }
327 
328     /**
329      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
330      * division by zero. The result is rounded towards zero.
331      *
332      * Counterpart to Solidity's `/` operator. Note: this function uses a
333      * `revert` opcode (which leaves remaining gas untouched) while Solidity
334      * uses an invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      * - The divisor cannot be zero.
338      *
339      * _Available since v2.4.0._
340      */
341     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
342         // Solidity only automatically asserts when dividing by 0
343         require(b > 0, errorMessage);
344         uint256 c = a / b;
345         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
346 
347         return c;
348     }
349 
350     /**
351      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
352      * Reverts when dividing by zero.
353      *
354      * Counterpart to Solidity's `%` operator. This function uses a `revert`
355      * opcode (which leaves remaining gas untouched) while Solidity uses an
356      * invalid opcode to revert (consuming all remaining gas).
357      *
358      * Requirements:
359      * - The divisor cannot be zero.
360      */
361     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
362         return mod(a, b, "SafeMath: modulo by zero");
363     }
364 
365     /**
366      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
367      * Reverts with custom message when dividing by zero.
368      *
369      * Counterpart to Solidity's `%` operator. This function uses a `revert`
370      * opcode (which leaves remaining gas untouched) while Solidity uses an
371      * invalid opcode to revert (consuming all remaining gas).
372      *
373      * Requirements:
374      * - The divisor cannot be zero.
375      *
376      * _Available since v2.4.0._
377      */
378     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
379         require(b != 0, errorMessage);
380         return a % b;
381     }
382 }
383 
384 /**
385  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
386  * the optional functions; to access them see {ERC20Detailed}.
387  */
388 interface IERC20 {
389     /**
390      * @dev Returns the amount of tokens in existence.
391      */
392     function totalSupply() external view returns (uint256);
393 
394     /**
395      * @dev Returns the amount of tokens owned by `account`.
396      */
397     function balanceOf(address account) external view returns (uint256);
398 
399     /**
400      * @dev Moves `amount` tokens from the caller's account to `recipient`.
401      *
402      * Returns a boolean value indicating whether the operation succeeded.
403      *
404      * Emits a {Transfer} event.
405      */
406     function transfer(address recipient, uint256 amount) external returns (bool);
407 
408     /**
409      * @dev Returns the remaining number of tokens that `spender` will be
410      * allowed to spend on behalf of `owner` through {transferFrom}. This is
411      * zero by default.
412      *
413      * This value changes when {approve} or {transferFrom} are called.
414      */
415     function allowance(address owner, address spender) external view returns (uint256);
416 
417     /**
418      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
419      *
420      * Returns a boolean value indicating whether the operation succeeded.
421      *
422      * IMPORTANT: Beware that changing an allowance with this method brings the risk
423      * that someone may use both the old and the new allowance by unfortunate
424      * transaction ordering. One possible solution to mitigate this race
425      * condition is to first reduce the spender's allowance to 0 and set the
426      * desired value afterwards:
427      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
428      *
429      * Emits an {Approval} event.
430      */
431     function approve(address spender, uint256 amount) external returns (bool);
432 
433     /**
434      * @dev Moves `amount` tokens from `sender` to `recipient` using the
435      * allowance mechanism. `amount` is then deducted from the caller's
436      * allowance.
437      *
438      * Returns a boolean value indicating whether the operation succeeded.
439      *
440      * Emits a {Transfer} event.
441      */
442     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
443 
444     /**
445      * @dev Emitted when `value` tokens are moved from one account (`from`) to
446      * another (`to`).
447      *
448      * Note that `value` may be zero.
449      */
450     event Transfer(address indexed from, address indexed to, uint256 value);
451 
452     /**
453      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
454      * a call to {approve}. `value` is the new allowance.
455      */
456     event Approval(address indexed owner, address indexed spender, uint256 value);
457 }
458 
459 /**
460  * @dev Collection of functions related to the address type
461  */
462 library Address {
463     /**
464      * @dev Returns true if `account` is a contract.
465      *
466      * [IMPORTANT]
467      * ====
468      * It is unsafe to assume that an address for which this function returns
469      * false is an externally-owned account (EOA) and not a contract.
470      *
471      * Among others, `isContract` will return false for the following 
472      * types of addresses:
473      *
474      *  - an externally-owned account
475      *  - a contract in construction
476      *  - an address where a contract will be created
477      *  - an address where a contract lived, but was destroyed
478      * ====
479      */
480     function isContract(address account) internal view returns (bool) {
481         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
482         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
483         // for accounts without code, i.e. `keccak256('')`
484         bytes32 codehash;
485         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
486         // solhint-disable-next-line no-inline-assembly
487         assembly { codehash := extcodehash(account) }
488         return (codehash != accountHash && codehash != 0x0);
489     }
490 
491     /**
492      * @dev Converts an `address` into `address payable`. Note that this is
493      * simply a type cast: the actual underlying value is not changed.
494      *
495      * _Available since v2.4.0._
496      */
497     function toPayable(address account) internal pure returns (address payable) {
498         return address(uint160(account));
499     }
500 
501     /**
502      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
503      * `recipient`, forwarding all available gas and reverting on errors.
504      *
505      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
506      * of certain opcodes, possibly making contracts go over the 2300 gas limit
507      * imposed by `transfer`, making them unable to receive funds via
508      * `transfer`. {sendValue} removes this limitation.
509      *
510      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
511      *
512      * IMPORTANT: because control is transferred to `recipient`, care must be
513      * taken to not create reentrancy vulnerabilities. Consider using
514      * {ReentrancyGuard} or the
515      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
516      *
517      * _Available since v2.4.0._
518      */
519     function sendValue(address payable recipient, uint256 amount) internal {
520         require(address(this).balance >= amount, "Address: insufficient balance");
521 
522         // solhint-disable-next-line avoid-call-value
523         (bool success, ) = recipient.call.value(amount)("");
524         require(success, "Address: unable to send value, recipient may have reverted");
525     }
526 }
527 
528 /**
529  * @title SafeERC20
530  * @dev Wrappers around ERC20 operations that throw on failure (when the token
531  * contract returns false). Tokens that return no value (and instead revert or
532  * throw on failure) are also supported, non-reverting calls are assumed to be
533  * successful.
534  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
535  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
536  */
537 library SafeERC20 {
538     using SafeMath for uint256;
539     using Address for address;
540 
541     function safeTransfer(IERC20 token, address to, uint256 value) internal {
542         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
543     }
544 
545     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
546         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
547     }
548 
549     function safeApprove(IERC20 token, address spender, uint256 value) internal {
550         // safeApprove should only be called when setting an initial allowance,
551         // or when resetting it to zero. To increase and decrease it, use
552         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
553         // solhint-disable-next-line max-line-length
554         require((value == 0) || (token.allowance(address(this), spender) == 0),
555             "SafeERC20: approve from non-zero to non-zero allowance"
556         );
557         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
558     }
559 
560     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
561         uint256 newAllowance = token.allowance(address(this), spender).add(value);
562         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
563     }
564 
565     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
566         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
567         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
568     }
569 
570     /**
571      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
572      * on the return value: the return value is optional (but if data is returned, it must not be false).
573      * @param token The token targeted by the call.
574      * @param data The call data (encoded using abi.encode or one of its variants).
575      */
576     function callOptionalReturn(IERC20 token, bytes memory data) private {
577         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
578         // we're implementing it ourselves.
579 
580         // A Solidity high level call has three parts:
581         //  1. The target address is checked to verify it contains contract code
582         //  2. The call itself is made, and success asserted
583         //  3. The return value is decoded, which in turn checks the size of the returned data.
584         // solhint-disable-next-line max-line-length
585         require(address(token).isContract(), "SafeERC20: call to non-contract");
586 
587         // solhint-disable-next-line avoid-low-level-calls
588         (bool success, bytes memory returndata) = address(token).call(data);
589         require(success, "SafeERC20: low-level call failed");
590 
591         if (returndata.length > 0) { // Return data is optional
592             // solhint-disable-next-line max-line-length
593             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
594         }
595     }
596 }
597 
598 /**
599  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
600  *
601  * These functions can be used to verify that a message was signed by the holder
602  * of the private keys of a given address.
603  */
604 library ECDSA {
605 	/**
606 	 * @dev Returns the address that signed a hashed message (`hash`) with
607 	 * `signature`. This address can then be used for verification purposes.
608 	 *
609 	 * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
610 	 * this function rejects them by requiring the `s` value to be in the lower
611 	 * half order, and the `v` value to be either 27 or 28.
612 	 *
613 	 * NOTE: This call _does not revert_ if the signature is invalid, or
614 	 * if the signer is otherwise unable to be retrieved. In those scenarios,
615 	 * the zero address is returned.
616 	 *
617 	 * IMPORTANT: `hash` _must_ be the result of a hash operation for the
618 	 * verification to be secure: it is possible to craft signatures that
619 	 * recover to arbitrary addresses for non-hashed data. A safe way to ensure
620 	 * this is by receiving a hash of the original message (which may otherwise
621 	 * be too long), and then calling {toEthSignedMessageHash} on it.
622 	 */
623 	function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
624 		// Check the signature length
625 		if (signature.length != 65) {
626 			return (address(0));
627 		}
628 
629 		// Divide the signature in r, s and v variables
630 		bytes32 r;
631 		bytes32 s;
632 		uint8 v;
633 
634 		// ecrecover takes the signature parameters, and the only way to get them
635 		// currently is to use assembly.
636 		// solhint-disable-next-line no-inline-assembly
637 		assembly {
638 			r := mload(add(signature, 0x20))
639 			s := mload(add(signature, 0x40))
640 			v := byte(0, mload(add(signature, 0x60)))
641 		}
642 
643 		// EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
644 		// unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
645 		// the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
646 		// signatures from current libraries generate a unique signature with an s-value in the lower half order.
647 		//
648 		// If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
649 		// with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
650 		// vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
651 		// these malleable signatures as well.
652 		if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
653 			return address(0);
654 		}
655 
656 		v = v + 27;
657 		if (v != 27 && v != 28) {
658 			return address(0);
659 		}
660 
661 		// If the signature is valid (and not malleable), return the signer address
662 		return ecrecover(hash, v, r, s);
663 	}
664 
665 	/**
666 	 * @dev Returns an Ethereum Signed Message, created from a `hash`. This
667 	 * replicates the behavior of the
668 	 * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
669 	 * JSON-RPC method.
670 	 *
671 	 * See {recover}.
672 	 */
673 	function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
674 		// 32 is the length in bytes of hash,
675 		// enforced by the type signature above
676 		return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
677 	}
678 }
679 
680 contract MatterTransfer is Pausable, ReentrancyGuard {
681 	using ECDSA for bytes32;
682 	using SafeMath for uint256;
683 	using SafeERC20 for IERC20;
684 
685 	IERC20 public mtrToken;
686 	uint256 private _totalSupply;
687 	uint256 private _totalWithdrawn;
688 	address public withdrawSigner;
689 	address public denMultiSig;
690 
691 	mapping(uint256 => bool) usedNonces;
692 
693 	event Deposit(address indexed user, uint256 amount);
694 	event Withdrawn(address indexed user, uint256 nonce, uint256 amount);
695 
696 	constructor(address _withdrawSigner, address _mtrToken) public {
697 		mtrToken = IERC20(_mtrToken);
698 		withdrawSigner = _withdrawSigner;
699 		denMultiSig = msg.sender;
700 	}
701 
702 	modifier onlyDenMultiSig {
703 		require(msg.sender == denMultiSig, "not owner");
704 		_;
705 	}
706 
707 	function totalWithdrawn() public view returns (uint256) {
708 		return _totalWithdrawn;
709 	}
710 
711 	function totalSupply() public view returns (uint256) {
712 		return _totalSupply;
713 	}
714 
715 	function withdraw(
716 		uint256 amount,
717 		uint256 timestamp,
718 		uint256 nonce,
719 		bytes memory sig
720 	) public nonReentrant whenNotPaused() {
721 		require(!usedNonces[nonce], "duplicate transaction found, start new request from Den");
722 		require(now < timestamp, "withdraw period expired");
723 		require(totalSupply() >= amount, "withdraw request exceeds balance, notify den");
724 		usedNonces[nonce] = true;
725 
726 		// this recreates the message that was signed on the client
727 		bytes32 message = keccak256(abi.encodePacked(msg.sender, amount, timestamp, nonce, address(this)))
728 			.toEthSignedMessageHash();
729 		require(message.recover(sig) == withdrawSigner, "request not signed by den");
730 
731 		_totalSupply = _totalSupply.sub(amount);
732 		_totalWithdrawn = _totalWithdrawn.add(amount);
733 		mtrToken.safeTransfer(msg.sender, amount);
734 
735 		emit Withdrawn(msg.sender, nonce, amount);
736 	}
737 
738 	function setWithdrawSigner(address account) public onlyDenMultiSig {
739 		withdrawSigner = account;
740 	}
741 
742 	function deposit(uint256 amount) public whenNotPaused() {
743 		_totalSupply = _totalSupply.add(amount);
744 		mtrToken.safeTransferFrom(msg.sender, address(this), amount);
745 
746 		emit Deposit(msg.sender, amount);
747 	}
748 
749 	function kill() public onlyDenMultiSig {
750 		pause();
751 		uint256 amount = totalSupply();
752 
753 		_totalSupply = _totalSupply.sub(amount);
754 		_totalWithdrawn = _totalWithdrawn.add(amount);
755 		mtrToken.safeTransfer(denMultiSig, amount);
756 
757 		emit Withdrawn(denMultiSig, 0, amount);
758 	}
759 
760 	function changeMultiSig(address _denMultiSig) external onlyDenMultiSig {
761 		denMultiSig = _denMultiSig;
762 	}
763 }