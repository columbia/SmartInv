1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 
84 pragma solidity >=0.6.0 <0.8.0;
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
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
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
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
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
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
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 pragma solidity >=0.6.2 <0.8.0;
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
269         // This method relies on extcodesize, which returns 0 for contracts in
270         // construction, since the code is only stored at the end of the
271         // constructor execution.
272 
273         uint256 size;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { size := extcodesize(account) }
276         return size > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         // solhint-disable-next-line avoid-low-level-calls
361         (bool success, bytes memory returndata) = target.call{ value: value }(data);
362         return _verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
382         require(isContract(target), "Address: static call to non-contract");
383 
384         // solhint-disable-next-line avoid-low-level-calls
385         (bool success, bytes memory returndata) = target.staticcall(data);
386         return _verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 // solhint-disable-next-line no-inline-assembly
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
410 
411 
412 pragma solidity >=0.6.0 <0.8.0;
413 
414 
415 
416 
417 /**
418  * @title SafeERC20
419  * @dev Wrappers around ERC20 operations that throw on failure (when the token
420  * contract returns false). Tokens that return no value (and instead revert or
421  * throw on failure) are also supported, non-reverting calls are assumed to be
422  * successful.
423  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
424  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
425  */
426 library SafeERC20 {
427     using SafeMath for uint256;
428     using Address for address;
429 
430     function safeTransfer(IERC20 token, address to, uint256 value) internal {
431         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
432     }
433 
434     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
435         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
436     }
437 
438     /**
439      * @dev Deprecated. This function has issues similar to the ones found in
440      * {IERC20-approve}, and its usage is discouraged.
441      *
442      * Whenever possible, use {safeIncreaseAllowance} and
443      * {safeDecreaseAllowance} instead.
444      */
445     function safeApprove(IERC20 token, address spender, uint256 value) internal {
446         // safeApprove should only be called when setting an initial allowance,
447         // or when resetting it to zero. To increase and decrease it, use
448         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
449         // solhint-disable-next-line max-line-length
450         require((value == 0) || (token.allowance(address(this), spender) == 0),
451             "SafeERC20: approve from non-zero to non-zero allowance"
452         );
453         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
454     }
455 
456     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
457         uint256 newAllowance = token.allowance(address(this), spender).add(value);
458         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
459     }
460 
461     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
462         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
463         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
464     }
465 
466     /**
467      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
468      * on the return value: the return value is optional (but if data is returned, it must not be false).
469      * @param token The token targeted by the call.
470      * @param data The call data (encoded using abi.encode or one of its variants).
471      */
472     function _callOptionalReturn(IERC20 token, bytes memory data) private {
473         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
474         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
475         // the target address contains contract code and also asserts for success in the low-level call.
476 
477         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
478         if (returndata.length > 0) { // Return data is optional
479             // solhint-disable-next-line max-line-length
480             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
481         }
482     }
483 }
484 
485 // File: @openzeppelin/contracts/cryptography/ECDSA.sol
486 
487 
488 pragma solidity >=0.6.0 <0.8.0;
489 
490 /**
491  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
492  *
493  * These functions can be used to verify that a message was signed by the holder
494  * of the private keys of a given address.
495  */
496 library ECDSA {
497     /**
498      * @dev Returns the address that signed a hashed message (`hash`) with
499      * `signature`. This address can then be used for verification purposes.
500      *
501      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
502      * this function rejects them by requiring the `s` value to be in the lower
503      * half order, and the `v` value to be either 27 or 28.
504      *
505      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
506      * verification to be secure: it is possible to craft signatures that
507      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
508      * this is by receiving a hash of the original message (which may otherwise
509      * be too long), and then calling {toEthSignedMessageHash} on it.
510      */
511     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
512         // Check the signature length
513         if (signature.length != 65) {
514             revert("ECDSA: invalid signature length");
515         }
516 
517         // Divide the signature in r, s and v variables
518         bytes32 r;
519         bytes32 s;
520         uint8 v;
521 
522         // ecrecover takes the signature parameters, and the only way to get them
523         // currently is to use assembly.
524         // solhint-disable-next-line no-inline-assembly
525         assembly {
526             r := mload(add(signature, 0x20))
527             s := mload(add(signature, 0x40))
528             v := byte(0, mload(add(signature, 0x60)))
529         }
530 
531         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
532         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
533         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
534         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
535         //
536         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
537         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
538         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
539         // these malleable signatures as well.
540         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
541         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
542 
543         // If the signature is valid (and not malleable), return the signer address
544         address signer = ecrecover(hash, v, r, s);
545         require(signer != address(0), "ECDSA: invalid signature");
546 
547         return signer;
548     }
549 
550     /**
551      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
552      * replicates the behavior of the
553      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
554      * JSON-RPC method.
555      *
556      * See {recover}.
557      */
558     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
559         // 32 is the length in bytes of hash,
560         // enforced by the type signature above
561         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
562     }
563 }
564 
565 // File: @openzeppelin/contracts/GSN/Context.sol
566 
567 
568 pragma solidity >=0.6.0 <0.8.0;
569 
570 /*
571  * @dev Provides information about the current execution context, including the
572  * sender of the transaction and its data. While these are generally available
573  * via msg.sender and msg.data, they should not be accessed in such a direct
574  * manner, since when dealing with GSN meta-transactions the account sending and
575  * paying for execution may not be the actual sender (as far as an application
576  * is concerned).
577  *
578  * This contract is only required for intermediate, library-like contracts.
579  */
580 abstract contract Context {
581     function _msgSender() internal view virtual returns (address payable) {
582         return msg.sender;
583     }
584 
585     function _msgData() internal view virtual returns (bytes memory) {
586         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
587         return msg.data;
588     }
589 }
590 
591 // File: @openzeppelin/contracts/access/Ownable.sol
592 
593 
594 pragma solidity >=0.6.0 <0.8.0;
595 
596 /**
597  * @dev Contract module which provides a basic access control mechanism, where
598  * there is an account (an owner) that can be granted exclusive access to
599  * specific functions.
600  *
601  * By default, the owner account will be the one that deploys the contract. This
602  * can later be changed with {transferOwnership}.
603  *
604  * This module is used through inheritance. It will make available the modifier
605  * `onlyOwner`, which can be applied to your functions to restrict their use to
606  * the owner.
607  */
608 abstract contract Ownable is Context {
609     address private _owner;
610 
611     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
612 
613     /**
614      * @dev Initializes the contract setting the deployer as the initial owner.
615      */
616     constructor () internal {
617         address msgSender = _msgSender();
618         _owner = msgSender;
619         emit OwnershipTransferred(address(0), msgSender);
620     }
621 
622     /**
623      * @dev Returns the address of the current owner.
624      */
625     function owner() public view returns (address) {
626         return _owner;
627     }
628 
629     /**
630      * @dev Throws if called by any account other than the owner.
631      */
632     modifier onlyOwner() {
633         require(_owner == _msgSender(), "Ownable: caller is not the owner");
634         _;
635     }
636 
637     /**
638      * @dev Leaves the contract without owner. It will not be possible to call
639      * `onlyOwner` functions anymore. Can only be called by the current owner.
640      *
641      * NOTE: Renouncing ownership will leave the contract without an owner,
642      * thereby removing any functionality that is only available to the owner.
643      */
644     function renounceOwnership() public virtual onlyOwner {
645         emit OwnershipTransferred(_owner, address(0));
646         _owner = address(0);
647     }
648 
649     /**
650      * @dev Transfers ownership of the contract to a new account (`newOwner`).
651      * Can only be called by the current owner.
652      */
653     function transferOwnership(address newOwner) public virtual onlyOwner {
654         require(newOwner != address(0), "Ownable: new owner is the zero address");
655         emit OwnershipTransferred(_owner, newOwner);
656         _owner = newOwner;
657     }
658 }
659 
660 // File: contracts/SIRewardDistributor.sol
661 
662 pragma solidity 0.6.12;
663 pragma experimental ABIEncoderV2;
664 
665 
666 
667 
668 
669 contract SIRewardDistributor is Ownable {
670     using ECDSA for bytes32;
671     using SafeERC20 for IERC20;
672 
673     event SignerSet(address newSigner);
674     event Claimed(uint256 nonce, address recipient, uint256 amount);
675 
676     struct EIP712Domain {
677         string name;
678         string version;
679         uint256 chainId;
680         address verifyingContract;
681     }
682 
683     struct Recipient {
684         uint256 nonce;
685         address wallet;
686         uint256 amount;
687     }
688 
689     bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(
690         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
691     );
692 
693     bytes32 private constant RECIPIENT_TYPEHASH = keccak256(
694         "Recipient(uint256 nonce,address wallet,uint256 amount)"
695     );
696 
697     bytes32 private immutable DOMAIN_SEPARATOR;
698 
699     IERC20 public immutable siToken;
700     mapping(address => uint256) public accountNonces;
701     address public signer;
702 
703     constructor(IERC20 token, address signerAddress) public {
704         require(address(token) != address(0), "Invalid SI Address");
705         require(signerAddress != address(0), "Invalid Signer Address");
706         siToken = token;
707         signer = signerAddress;
708 
709         DOMAIN_SEPARATOR = _hashDomain(
710             EIP712Domain({
711                 name: "SI Distribution",
712                 version: "1",
713                 chainId: _getChainID(),
714                 verifyingContract: address(this)
715             })
716         );
717     }
718 
719     function _hashDomain(EIP712Domain memory eip712Domain)
720         private
721         pure
722         returns (bytes32)
723     {
724         return
725             keccak256(
726                 abi.encode(
727                     EIP712_DOMAIN_TYPEHASH,
728                     keccak256(bytes(eip712Domain.name)),
729                     keccak256(bytes(eip712Domain.version)),
730                     eip712Domain.chainId,
731                     eip712Domain.verifyingContract
732                 )
733             );
734     }
735 
736     function _hashRecipient(Recipient memory recipient)
737         private
738         pure
739         returns (bytes32)
740     {
741         return
742             keccak256(
743                 abi.encode(
744                     RECIPIENT_TYPEHASH,
745                     recipient.nonce,
746                     recipient.wallet,
747                     recipient.amount
748                 )
749             );
750     }
751 
752     function _hash(Recipient memory recipient) private view returns (bytes32) {
753         return
754             keccak256(
755                 abi.encodePacked(
756                     "\x19\x01",
757                     DOMAIN_SEPARATOR,
758                     _hashRecipient(recipient)
759                 )
760             );
761     }
762 
763     function _getChainID() private pure returns (uint256) {
764         uint256 id;
765         // no-inline-assembly
766         assembly {
767             id := chainid()
768         }
769         return id;
770     }
771 
772     function setSigner(address newSigner) external onlyOwner {
773         signer = newSigner;
774 
775         emit SignerSet(newSigner);
776     }
777 
778     function claim(
779         Recipient calldata recipient,
780         uint8 v,
781         bytes32 r,
782         bytes32 s // bytes calldata signature
783     ) external {
784 
785         bytes32 prefixedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash(recipient)));
786 
787         address signatureSigner = ecrecover(prefixedHash, v, r, s);
788         require(signatureSigner == signer, "Invalid Signature");
789 
790         require(
791             recipient.nonce == accountNonces[recipient.wallet],
792             "Nonce Mismatch"
793         );
794         require(
795             siToken.balanceOf(address(this)) >= recipient.amount,
796             "Insufficient Funds"
797         );
798 
799         accountNonces[recipient.wallet] += 1;
800         siToken.safeTransfer(recipient.wallet, recipient.amount);
801 
802         emit Claimed(recipient.nonce, recipient.wallet, recipient.amount);
803     }
804 }