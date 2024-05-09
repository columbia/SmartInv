1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.19;
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         _checkOwner();
58         _;
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if the sender is not the owner.
70      */
71     function _checkOwner() internal view virtual {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
107 
108 /**
109  * @dev Interface of the ERC20 standard as defined in the EIP.
110  */
111 interface IERC20 {
112     /**
113      * @dev Emitted when `value` tokens are moved from one account (`from`) to
114      * another (`to`).
115      *
116      * Note that `value` may be zero.
117      */
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 
120     /**
121      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
122      * a call to {approve}. `value` is the new allowance.
123      */
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 
126     /**
127      * @dev Returns the amount of tokens in existence.
128      */
129     function totalSupply() external view returns (uint256);
130 
131     /**
132      * @dev Returns the amount of tokens owned by `account`.
133      */
134     function balanceOf(address account) external view returns (uint256);
135 
136     /**
137      * @dev Moves `amount` tokens from the caller's account to `to`.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transfer(address to, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Returns the remaining number of tokens that `spender` will be
147      * allowed to spend on behalf of `owner` through {transferFrom}. This is
148      * zero by default.
149      *
150      * This value changes when {approve} or {transferFrom} are called.
151      */
152     function allowance(address owner, address spender) external view returns (uint256);
153 
154     /**
155      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * IMPORTANT: Beware that changing an allowance with this method brings the risk
160      * that someone may use both the old and the new allowance by unfortunate
161      * transaction ordering. One possible solution to mitigate this race
162      * condition is to first reduce the spender's allowance to 0 and set the
163      * desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      *
166      * Emits an {Approval} event.
167      */
168     function approve(address spender, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Moves `amount` tokens from `from` to `to` using the
172      * allowance mechanism. `amount` is then deducted from the caller's
173      * allowance.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transferFrom(
180         address from,
181         address to,
182         uint256 amount
183     ) external returns (bool);
184 }
185 
186 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
187 
188 /**
189  * @dev Collection of functions related to the address type
190  */
191 library Address {
192     /**
193      * @dev Returns true if `account` is a contract.
194      *
195      * [IMPORTANT]
196      * ====
197      * It is unsafe to assume that an address for which this function returns
198      * false is an externally-owned account (EOA) and not a contract.
199      *
200      * Among others, `isContract` will return false for the following
201      * types of addresses:
202      *
203      *  - an externally-owned account
204      *  - a contract in construction
205      *  - an address where a contract will be created
206      *  - an address where a contract lived, but was destroyed
207      * ====
208      *
209      * [IMPORTANT]
210      * ====
211      * You shouldn't rely on `isContract` to protect against flash loan attacks!
212      *
213      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
214      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
215      * constructor.
216      * ====
217      */
218     function isContract(address account) internal view returns (bool) {
219         // This method relies on extcodesize/address.code.length, which returns 0
220         // for contracts in construction, since the code is only stored at the end
221         // of the constructor execution.
222 
223         return account.code.length > 0;
224     }
225 
226     /**
227      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
228      * `recipient`, forwarding all available gas and reverting on errors.
229      *
230      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
231      * of certain opcodes, possibly making contracts go over the 2300 gas limit
232      * imposed by `transfer`, making them unable to receive funds via
233      * `transfer`. {sendValue} removes this limitation.
234      *
235      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
236      *
237      * IMPORTANT: because control is transferred to `recipient`, care must be
238      * taken to not create reentrancy vulnerabilities. Consider using
239      * {ReentrancyGuard} or the
240      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
241      */
242     function sendValue(address payable recipient, uint256 amount) internal {
243         require(address(this).balance >= amount, "Address: insufficient balance");
244 
245         (bool success, ) = recipient.call{value: amount}("");
246         require(success, "Address: unable to send value, recipient may have reverted");
247     }
248 
249     /**
250      * @dev Performs a Solidity function call using a low level `call`. A
251      * plain `call` is an unsafe replacement for a function call: use this
252      * function instead.
253      *
254      * If `target` reverts with a revert reason, it is bubbled up by this
255      * function (like regular Solidity function calls).
256      *
257      * Returns the raw returned data. To convert to the expected return value,
258      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
259      *
260      * Requirements:
261      *
262      * - `target` must be a contract.
263      * - calling `target` with `data` must not revert.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
268         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
273      * `errorMessage` as a fallback revert reason when `target` reverts.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         return functionCallWithValue(target, data, 0, errorMessage);
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
287      * but also transferring `value` wei to `target`.
288      *
289      * Requirements:
290      *
291      * - the calling contract must have an ETH balance of at least `value`.
292      * - the called Solidity function must be `payable`.
293      *
294      * _Available since v3.1._
295      */
296     function functionCallWithValue(
297         address target,
298         bytes memory data,
299         uint256 value
300     ) internal returns (bytes memory) {
301         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
306      * with `errorMessage` as a fallback revert reason when `target` reverts.
307      *
308      * _Available since v3.1._
309      */
310     function functionCallWithValue(
311         address target,
312         bytes memory data,
313         uint256 value,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         require(address(this).balance >= value, "Address: insufficient balance for call");
317         (bool success, bytes memory returndata) = target.call{value: value}(data);
318         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but performing a static call.
324      *
325      * _Available since v3.3._
326      */
327     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
328         return functionStaticCall(target, data, "Address: low-level static call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
333      * but performing a static call.
334      *
335      * _Available since v3.3._
336      */
337     function functionStaticCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal view returns (bytes memory) {
342         (bool success, bytes memory returndata) = target.staticcall(data);
343         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but performing a delegate call.
349      *
350      * _Available since v3.4._
351      */
352     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         (bool success, bytes memory returndata) = target.delegatecall(data);
368         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
373      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
374      *
375      * _Available since v4.8._
376      */
377     function verifyCallResultFromTarget(
378         address target,
379         bool success,
380         bytes memory returndata,
381         string memory errorMessage
382     ) internal view returns (bytes memory) {
383         if (success) {
384             if (returndata.length == 0) {
385                 // only check isContract if the call was successful and the return data is empty
386                 // otherwise we already know that it was a contract
387                 require(isContract(target), "Address: call to non-contract");
388             }
389             return returndata;
390         } else {
391             _revert(returndata, errorMessage);
392         }
393     }
394 
395     /**
396      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
397      * revert reason or using the provided one.
398      *
399      * _Available since v4.3._
400      */
401     function verifyCallResult(
402         bool success,
403         bytes memory returndata,
404         string memory errorMessage
405     ) internal pure returns (bytes memory) {
406         if (success) {
407             return returndata;
408         } else {
409             _revert(returndata, errorMessage);
410         }
411     }
412 
413     function _revert(bytes memory returndata, string memory errorMessage) private pure {
414         // Look for revert reason and bubble it up if present
415         if (returndata.length > 0) {
416             // The easiest way to bubble the revert reason is using memory via assembly
417             /// @solidity memory-safe-assembly
418             assembly {
419                 let returndata_size := mload(returndata)
420                 revert(add(32, returndata), returndata_size)
421             }
422         } else {
423             revert(errorMessage);
424         }
425     }
426 }
427 
428 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
429 
430 /**
431  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
432  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
433  *
434  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
435  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
436  * need to send a transaction, and thus is not required to hold Ether at all.
437  */
438 interface IERC20Permit {
439     /**
440      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
441      * given ``owner``'s signed approval.
442      *
443      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
444      * ordering also apply here.
445      *
446      * Emits an {Approval} event.
447      *
448      * Requirements:
449      *
450      * - `spender` cannot be the zero address.
451      * - `deadline` must be a timestamp in the future.
452      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
453      * over the EIP712-formatted function arguments.
454      * - the signature must use ``owner``'s current nonce (see {nonces}).
455      *
456      * For more information on the signature format, see the
457      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
458      * section].
459      */
460     function permit(
461         address owner,
462         address spender,
463         uint256 value,
464         uint256 deadline,
465         uint8 v,
466         bytes32 r,
467         bytes32 s
468     ) external;
469 
470     /**
471      * @dev Returns the current nonce for `owner`. This value must be
472      * included whenever a signature is generated for {permit}.
473      *
474      * Every successful call to {permit} increases ``owner``'s nonce by one. This
475      * prevents a signature from being used multiple times.
476      */
477     function nonces(address owner) external view returns (uint256);
478 
479     /**
480      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
481      */
482     // solhint-disable-next-line func-name-mixedcase
483     function DOMAIN_SEPARATOR() external view returns (bytes32);
484 }
485 
486 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
487 
488 /**
489  * @title SafeERC20
490  * @dev Wrappers around ERC20 operations that throw on failure (when the token
491  * contract returns false). Tokens that return no value (and instead revert or
492  * throw on failure) are also supported, non-reverting calls are assumed to be
493  * successful.
494  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
495  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
496  */
497 library SafeERC20 {
498     using Address for address;
499 
500     function safeTransfer(
501         IERC20 token,
502         address to,
503         uint256 value
504     ) internal {
505         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
506     }
507 
508     function safeTransferFrom(
509         IERC20 token,
510         address from,
511         address to,
512         uint256 value
513     ) internal {
514         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
515     }
516 
517     /**
518      * @dev Deprecated. This function has issues similar to the ones found in
519      * {IERC20-approve}, and its usage is discouraged.
520      *
521      * Whenever possible, use {safeIncreaseAllowance} and
522      * {safeDecreaseAllowance} instead.
523      */
524     function safeApprove(
525         IERC20 token,
526         address spender,
527         uint256 value
528     ) internal {
529         // safeApprove should only be called when setting an initial allowance,
530         // or when resetting it to zero. To increase and decrease it, use
531         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
532         require(
533             (value == 0) || (token.allowance(address(this), spender) == 0),
534             "SafeERC20: approve from non-zero to non-zero allowance"
535         );
536         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
537     }
538 
539     function safeIncreaseAllowance(
540         IERC20 token,
541         address spender,
542         uint256 value
543     ) internal {
544         uint256 newAllowance = token.allowance(address(this), spender) + value;
545         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
546     }
547 
548     function safeDecreaseAllowance(
549         IERC20 token,
550         address spender,
551         uint256 value
552     ) internal {
553         unchecked {
554             uint256 oldAllowance = token.allowance(address(this), spender);
555             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
556             uint256 newAllowance = oldAllowance - value;
557             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
558         }
559     }
560 
561     function safePermit(
562         IERC20Permit token,
563         address owner,
564         address spender,
565         uint256 value,
566         uint256 deadline,
567         uint8 v,
568         bytes32 r,
569         bytes32 s
570     ) internal {
571         uint256 nonceBefore = token.nonces(owner);
572         token.permit(owner, spender, value, deadline, v, r, s);
573         uint256 nonceAfter = token.nonces(owner);
574         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
575     }
576 
577     /**
578      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
579      * on the return value: the return value is optional (but if data is returned, it must not be false).
580      * @param token The token targeted by the call.
581      * @param data The call data (encoded using abi.encode or one of its variants).
582      */
583     function _callOptionalReturn(IERC20 token, bytes memory data) private {
584         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
585         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
586         // the target address contains contract code and also asserts for success in the low-level call.
587 
588         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
589         if (returndata.length > 0) {
590             // Return data is optional
591             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
592         }
593     }
594 }
595 
596 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
597 
598 /**
599  * @dev Standard math utilities missing in the Solidity language.
600  */
601 library Math {
602     enum Rounding {
603         Down, // Toward negative infinity
604         Up, // Toward infinity
605         Zero // Toward zero
606     }
607 
608     /**
609      * @dev Returns the largest of two numbers.
610      */
611     function max(uint256 a, uint256 b) internal pure returns (uint256) {
612         return a > b ? a : b;
613     }
614 
615     /**
616      * @dev Returns the smallest of two numbers.
617      */
618     function min(uint256 a, uint256 b) internal pure returns (uint256) {
619         return a < b ? a : b;
620     }
621 
622     /**
623      * @dev Returns the average of two numbers. The result is rounded towards
624      * zero.
625      */
626     function average(uint256 a, uint256 b) internal pure returns (uint256) {
627         // (a + b) / 2 can overflow.
628         return (a & b) + (a ^ b) / 2;
629     }
630 
631     /**
632      * @dev Returns the ceiling of the division of two numbers.
633      *
634      * This differs from standard division with `/` in that it rounds up instead
635      * of rounding down.
636      */
637     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
638         // (a + b - 1) / b can overflow on addition, so we distribute.
639         return a == 0 ? 0 : (a - 1) / b + 1;
640     }
641 
642     /**
643      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
644      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
645      * with further edits by Uniswap Labs also under MIT license.
646      */
647     function mulDiv(
648         uint256 x,
649         uint256 y,
650         uint256 denominator
651     ) internal pure returns (uint256 result) {
652         unchecked {
653             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
654             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
655             // variables such that product = prod1 * 2^256 + prod0.
656             uint256 prod0; // Least significant 256 bits of the product
657             uint256 prod1; // Most significant 256 bits of the product
658             assembly {
659                 let mm := mulmod(x, y, not(0))
660                 prod0 := mul(x, y)
661                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
662             }
663 
664             // Handle non-overflow cases, 256 by 256 division.
665             if (prod1 == 0) {
666                 return prod0 / denominator;
667             }
668 
669             // Make sure the result is less than 2^256. Also prevents denominator == 0.
670             require(denominator > prod1);
671 
672             ///////////////////////////////////////////////
673             // 512 by 256 division.
674             ///////////////////////////////////////////////
675 
676             // Make division exact by subtracting the remainder from [prod1 prod0].
677             uint256 remainder;
678             assembly {
679                 // Compute remainder using mulmod.
680                 remainder := mulmod(x, y, denominator)
681 
682                 // Subtract 256 bit number from 512 bit number.
683                 prod1 := sub(prod1, gt(remainder, prod0))
684                 prod0 := sub(prod0, remainder)
685             }
686 
687             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
688             // See https://cs.stackexchange.com/q/138556/92363.
689 
690             // Does not overflow because the denominator cannot be zero at this stage in the function.
691             uint256 twos = denominator & (~denominator + 1);
692             assembly {
693                 // Divide denominator by twos.
694                 denominator := div(denominator, twos)
695 
696                 // Divide [prod1 prod0] by twos.
697                 prod0 := div(prod0, twos)
698 
699                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
700                 twos := add(div(sub(0, twos), twos), 1)
701             }
702 
703             // Shift in bits from prod1 into prod0.
704             prod0 |= prod1 * twos;
705 
706             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
707             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
708             // four bits. That is, denominator * inv = 1 mod 2^4.
709             uint256 inverse = (3 * denominator) ^ 2;
710 
711             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
712             // in modular arithmetic, doubling the correct bits in each step.
713             inverse *= 2 - denominator * inverse; // inverse mod 2^8
714             inverse *= 2 - denominator * inverse; // inverse mod 2^16
715             inverse *= 2 - denominator * inverse; // inverse mod 2^32
716             inverse *= 2 - denominator * inverse; // inverse mod 2^64
717             inverse *= 2 - denominator * inverse; // inverse mod 2^128
718             inverse *= 2 - denominator * inverse; // inverse mod 2^256
719 
720             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
721             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
722             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
723             // is no longer required.
724             result = prod0 * inverse;
725             return result;
726         }
727     }
728 
729     /**
730      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
731      */
732     function mulDiv(
733         uint256 x,
734         uint256 y,
735         uint256 denominator,
736         Rounding rounding
737     ) internal pure returns (uint256) {
738         uint256 result = mulDiv(x, y, denominator);
739         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
740             result += 1;
741         }
742         return result;
743     }
744 
745     /**
746      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
747      *
748      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
749      */
750     function sqrt(uint256 a) internal pure returns (uint256) {
751         if (a == 0) {
752             return 0;
753         }
754 
755         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
756         //
757         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
758         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
759         //
760         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
761         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
762         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
763         //
764         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
765         uint256 result = 1 << (log2(a) >> 1);
766 
767         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
768         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
769         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
770         // into the expected uint128 result.
771         unchecked {
772             result = (result + a / result) >> 1;
773             result = (result + a / result) >> 1;
774             result = (result + a / result) >> 1;
775             result = (result + a / result) >> 1;
776             result = (result + a / result) >> 1;
777             result = (result + a / result) >> 1;
778             result = (result + a / result) >> 1;
779             return min(result, a / result);
780         }
781     }
782 
783     /**
784      * @notice Calculates sqrt(a), following the selected rounding direction.
785      */
786     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
787         unchecked {
788             uint256 result = sqrt(a);
789             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
790         }
791     }
792 
793     /**
794      * @dev Return the log in base 2, rounded down, of a positive value.
795      * Returns 0 if given 0.
796      */
797     function log2(uint256 value) internal pure returns (uint256) {
798         uint256 result = 0;
799         unchecked {
800             if (value >> 128 > 0) {
801                 value >>= 128;
802                 result += 128;
803             }
804             if (value >> 64 > 0) {
805                 value >>= 64;
806                 result += 64;
807             }
808             if (value >> 32 > 0) {
809                 value >>= 32;
810                 result += 32;
811             }
812             if (value >> 16 > 0) {
813                 value >>= 16;
814                 result += 16;
815             }
816             if (value >> 8 > 0) {
817                 value >>= 8;
818                 result += 8;
819             }
820             if (value >> 4 > 0) {
821                 value >>= 4;
822                 result += 4;
823             }
824             if (value >> 2 > 0) {
825                 value >>= 2;
826                 result += 2;
827             }
828             if (value >> 1 > 0) {
829                 result += 1;
830             }
831         }
832         return result;
833     }
834 
835     /**
836      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
837      * Returns 0 if given 0.
838      */
839     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
840         unchecked {
841             uint256 result = log2(value);
842             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
843         }
844     }
845 
846     /**
847      * @dev Return the log in base 10, rounded down, of a positive value.
848      * Returns 0 if given 0.
849      */
850     function log10(uint256 value) internal pure returns (uint256) {
851         uint256 result = 0;
852         unchecked {
853             if (value >= 10**64) {
854                 value /= 10**64;
855                 result += 64;
856             }
857             if (value >= 10**32) {
858                 value /= 10**32;
859                 result += 32;
860             }
861             if (value >= 10**16) {
862                 value /= 10**16;
863                 result += 16;
864             }
865             if (value >= 10**8) {
866                 value /= 10**8;
867                 result += 8;
868             }
869             if (value >= 10**4) {
870                 value /= 10**4;
871                 result += 4;
872             }
873             if (value >= 10**2) {
874                 value /= 10**2;
875                 result += 2;
876             }
877             if (value >= 10**1) {
878                 result += 1;
879             }
880         }
881         return result;
882     }
883 
884     /**
885      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
886      * Returns 0 if given 0.
887      */
888     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
889         unchecked {
890             uint256 result = log10(value);
891             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
892         }
893     }
894 
895     /**
896      * @dev Return the log in base 256, rounded down, of a positive value.
897      * Returns 0 if given 0.
898      *
899      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
900      */
901     function log256(uint256 value) internal pure returns (uint256) {
902         uint256 result = 0;
903         unchecked {
904             if (value >> 128 > 0) {
905                 value >>= 128;
906                 result += 16;
907             }
908             if (value >> 64 > 0) {
909                 value >>= 64;
910                 result += 8;
911             }
912             if (value >> 32 > 0) {
913                 value >>= 32;
914                 result += 4;
915             }
916             if (value >> 16 > 0) {
917                 value >>= 16;
918                 result += 2;
919             }
920             if (value >> 8 > 0) {
921                 result += 1;
922             }
923         }
924         return result;
925     }
926 
927     /**
928      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
929      * Returns 0 if given 0.
930      */
931     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
932         unchecked {
933             uint256 result = log256(value);
934             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
935         }
936     }
937 }
938 
939 
940 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
941 
942 
943 /**
944  * @dev String operations.
945  */
946 library Strings {
947     bytes16 private constant _SYMBOLS = "0123456789abcdef";
948     uint8 private constant _ADDRESS_LENGTH = 20;
949 
950     /**
951      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
952      */
953     function toString(uint256 value) internal pure returns (string memory) {
954         unchecked {
955             uint256 length = Math.log10(value) + 1;
956             string memory buffer = new string(length);
957             uint256 ptr;
958             /// @solidity memory-safe-assembly
959             assembly {
960                 ptr := add(buffer, add(32, length))
961             }
962             while (true) {
963                 ptr--;
964                 /// @solidity memory-safe-assembly
965                 assembly {
966                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
967                 }
968                 value /= 10;
969                 if (value == 0) break;
970             }
971             return buffer;
972         }
973     }
974 
975     /**
976      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
977      */
978     function toHexString(uint256 value) internal pure returns (string memory) {
979         unchecked {
980             return toHexString(value, Math.log256(value) + 1);
981         }
982     }
983 
984     /**
985      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
986      */
987     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
988         bytes memory buffer = new bytes(2 * length + 2);
989         buffer[0] = "0";
990         buffer[1] = "x";
991         for (uint256 i = 2 * length + 1; i > 1; --i) {
992             buffer[i] = _SYMBOLS[value & 0xf];
993             value >>= 4;
994         }
995         require(value == 0, "Strings: hex length insufficient");
996         return string(buffer);
997     }
998 
999     /**
1000      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1001      */
1002     function toHexString(address addr) internal pure returns (string memory) {
1003         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1004     }
1005 }
1006 
1007 
1008 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
1009 
1010 
1011 /**
1012  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1013  *
1014  * These functions can be used to verify that a message was signed by the holder
1015  * of the private keys of a given address.
1016  */
1017 library ECDSA {
1018     enum RecoverError {
1019         NoError,
1020         InvalidSignature,
1021         InvalidSignatureLength,
1022         InvalidSignatureS,
1023         InvalidSignatureV // Deprecated in v4.8
1024     }
1025 
1026     function _throwError(RecoverError error) private pure {
1027         if (error == RecoverError.NoError) {
1028             return; // no error: do nothing
1029         } else if (error == RecoverError.InvalidSignature) {
1030             revert("ECDSA: invalid signature");
1031         } else if (error == RecoverError.InvalidSignatureLength) {
1032             revert("ECDSA: invalid signature length");
1033         } else if (error == RecoverError.InvalidSignatureS) {
1034             revert("ECDSA: invalid signature 's' value");
1035         }
1036     }
1037 
1038     /**
1039      * @dev Returns the address that signed a hashed message (`hash`) with
1040      * `signature` or error string. This address can then be used for verification purposes.
1041      *
1042      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1043      * this function rejects them by requiring the `s` value to be in the lower
1044      * half order, and the `v` value to be either 27 or 28.
1045      *
1046      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1047      * verification to be secure: it is possible to craft signatures that
1048      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1049      * this is by receiving a hash of the original message (which may otherwise
1050      * be too long), and then calling {toEthSignedMessageHash} on it.
1051      *
1052      * Documentation for signature generation:
1053      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1054      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1055      *
1056      * _Available since v4.3._
1057      */
1058     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1059         if (signature.length == 65) {
1060             bytes32 r;
1061             bytes32 s;
1062             uint8 v;
1063             // ecrecover takes the signature parameters, and the only way to get them
1064             // currently is to use assembly.
1065             /// @solidity memory-safe-assembly
1066             assembly {
1067                 r := mload(add(signature, 0x20))
1068                 s := mload(add(signature, 0x40))
1069                 v := byte(0, mload(add(signature, 0x60)))
1070             }
1071             return tryRecover(hash, v, r, s);
1072         } else {
1073             return (address(0), RecoverError.InvalidSignatureLength);
1074         }
1075     }
1076 
1077     /**
1078      * @dev Returns the address that signed a hashed message (`hash`) with
1079      * `signature`. This address can then be used for verification purposes.
1080      *
1081      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1082      * this function rejects them by requiring the `s` value to be in the lower
1083      * half order, and the `v` value to be either 27 or 28.
1084      *
1085      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1086      * verification to be secure: it is possible to craft signatures that
1087      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1088      * this is by receiving a hash of the original message (which may otherwise
1089      * be too long), and then calling {toEthSignedMessageHash} on it.
1090      */
1091     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1092         (address recovered, RecoverError error) = tryRecover(hash, signature);
1093         _throwError(error);
1094         return recovered;
1095     }
1096 
1097     /**
1098      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1099      *
1100      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1101      *
1102      * _Available since v4.3._
1103      */
1104     function tryRecover(
1105         bytes32 hash,
1106         bytes32 r,
1107         bytes32 vs
1108     ) internal pure returns (address, RecoverError) {
1109         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1110         uint8 v = uint8((uint256(vs) >> 255) + 27);
1111         return tryRecover(hash, v, r, s);
1112     }
1113 
1114     /**
1115      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1116      *
1117      * _Available since v4.2._
1118      */
1119     function recover(
1120         bytes32 hash,
1121         bytes32 r,
1122         bytes32 vs
1123     ) internal pure returns (address) {
1124         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1125         _throwError(error);
1126         return recovered;
1127     }
1128 
1129     /**
1130      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1131      * `r` and `s` signature fields separately.
1132      *
1133      * _Available since v4.3._
1134      */
1135     function tryRecover(
1136         bytes32 hash,
1137         uint8 v,
1138         bytes32 r,
1139         bytes32 s
1140     ) internal pure returns (address, RecoverError) {
1141         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1142         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1143         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1144         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1145         //
1146         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1147         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1148         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1149         // these malleable signatures as well.
1150         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1151             return (address(0), RecoverError.InvalidSignatureS);
1152         }
1153 
1154         // If the signature is valid (and not malleable), return the signer address
1155         address signer = ecrecover(hash, v, r, s);
1156         if (signer == address(0)) {
1157             return (address(0), RecoverError.InvalidSignature);
1158         }
1159 
1160         return (signer, RecoverError.NoError);
1161     }
1162 
1163     /**
1164      * @dev Overload of {ECDSA-recover} that receives the `v`,
1165      * `r` and `s` signature fields separately.
1166      */
1167     function recover(
1168         bytes32 hash,
1169         uint8 v,
1170         bytes32 r,
1171         bytes32 s
1172     ) internal pure returns (address) {
1173         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1174         _throwError(error);
1175         return recovered;
1176     }
1177 
1178     /**
1179      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1180      * produces hash corresponding to the one signed with the
1181      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1182      * JSON-RPC method as part of EIP-191.
1183      *
1184      * See {recover}.
1185      */
1186     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1187         // 32 is the length in bytes of hash,
1188         // enforced by the type signature above
1189         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1190     }
1191 
1192     /**
1193      * @dev Returns an Ethereum Signed Message, created from `s`. This
1194      * produces hash corresponding to the one signed with the
1195      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1196      * JSON-RPC method as part of EIP-191.
1197      *
1198      * See {recover}.
1199      */
1200     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1201         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1202     }
1203 
1204     /**
1205      * @dev Returns an Ethereum Signed Typed Data, created from a
1206      * `domainSeparator` and a `structHash`. This produces hash corresponding
1207      * to the one signed with the
1208      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1209      * JSON-RPC method as part of EIP-712.
1210      *
1211      * See {recover}.
1212      */
1213     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1214         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1215     }
1216 }
1217 
1218 
1219 struct TokenInfo {
1220     uint256 minAmount;
1221     uint256 redeemDelay;
1222     bool bridgeable;
1223     bool redeemable;
1224     bool owned; // whether or not the bridge has mint rights on the token
1225 }
1226 
1227 struct RedeemInfo {
1228     uint256 blockNumber;
1229     bytes32 paramsHash;
1230 }
1231 
1232 // When calling mint / burn, we assume that the token is a representation of a wrapped asset and is deployed and / or audited by the admin
1233 interface IToken {
1234     function mint(address,uint256) external;
1235     function burn(uint256) external;
1236 }
1237 
1238 contract Bridge is Context {
1239     using ECDSA for bytes32;
1240     using SafeERC20 for IERC20;
1241 
1242     event RegisteredRedeem(uint256 indexed nonce, address indexed to, address indexed token, uint256 amount);
1243     event Redeemed(uint256 indexed nonce, address indexed to, address indexed token, uint256 amount);
1244     event Unwrapped(address indexed from, address indexed token, string to, uint256 amount);
1245     event Halted();
1246     event Unhalted();
1247     event PendingTokenInfo(address indexed token);
1248     event SetTokenInfo(address indexed token);
1249     event RevokedRedeem(uint256 indexed nonce);
1250     event PendingAdministrator(address indexed newAdministrator);
1251     event SetAdministrator(address indexed newAdministrator, address oldAdministrator);
1252     event PendingTss(address indexed newTss);
1253     event SetTss(address indexed newTss, address oldTss);
1254     event PendingGuardians();
1255     event SetGuardians();
1256     event SetAdministratorDelay(uint256);
1257     event SetSoftDelay(uint256);
1258     event SetUnhaltDuration(uint256);
1259     event SetEstimatedBlockTime(uint64);
1260     event SetAllowKeyGen(bool);
1261     event SetConfirmationsToFinality(uint64);
1262 
1263     uint256 private constant uint256max = type(uint256).max;
1264     uint32 private constant networkClass = 2;
1265     uint8 private constant  minNominatedGuardians = 5;
1266 
1267     uint64 public estimatedBlockTime;
1268     uint64 public confirmationsToFinality;
1269     bool public halted;
1270     bool public allowKeyGen;
1271 
1272     address public administrator;
1273     // Should be set greater than 72h
1274     uint256 public administratorDelay;
1275     uint256 public immutable minAdministratorDelay;
1276 
1277     address public tss;
1278     // Should be set greater than 72h
1279     uint256 public softDelay;
1280     uint256 public immutable minSoftDelay;
1281 
1282     address[] public guardians;
1283     address[] public guardiansVotes;
1284     mapping(address => uint) public votesCount;
1285     // same delay as set administrator
1286 
1287     uint256 public unhaltedAt;
1288     uint256 public unhaltDuration;
1289     uint256 public immutable minUnhaltDuration;
1290     uint256 public actionsNonce;
1291     uint256 public immutable contractDeploymentHeight;
1292 
1293     mapping(uint256 => RedeemInfo) public redeemsInfo;
1294     mapping(address => TokenInfo) public tokensInfo;
1295     mapping(string => RedeemInfo) public timeChallengesInfo;
1296 
1297     modifier isNotHalted() {
1298         require(!isHalted(), "bridge: Is halted");
1299         _;
1300     }
1301 
1302     modifier onlyAdministrator() {
1303         require(_msgSender() == administrator, "bridge: Caller not administrator");
1304         _;
1305     }
1306 
1307     constructor(uint256 unhaltDurationParam, uint256 administratorDelayParam, uint256 softDelayParam, uint64 blockTime, uint64 confirmations, address[] memory initialGuardians) {
1308         require(blockTime > 0, "BlockTime is less than minimum");
1309         require(confirmations > 1, "Confirmations is less than minimum");
1310 
1311         administrator = _msgSender();
1312         emit SetAdministrator(administrator, address(0));
1313 
1314         minUnhaltDuration = unhaltDurationParam;
1315         unhaltDuration = unhaltDurationParam;
1316 
1317         minAdministratorDelay = administratorDelayParam;
1318         administratorDelay = administratorDelayParam;
1319 
1320         minSoftDelay = softDelayParam;
1321         softDelay = softDelayParam;
1322 
1323         for(uint i = 0; i < initialGuardians.length; i++) {
1324             for(uint j = i + 1; j < initialGuardians.length; j++) {
1325                 if(initialGuardians[i] == initialGuardians[j]) {
1326                     revert("Found duplicated guardian");
1327                 }
1328             }
1329             guardians.push(initialGuardians[i]);
1330             guardiansVotes.push(address(0));
1331         }
1332 
1333         estimatedBlockTime = blockTime;
1334         confirmationsToFinality = confirmations;
1335         contractDeploymentHeight = block.number;
1336     }
1337 
1338     function isHalted() public view returns (bool) {
1339         return halted || (unhaltedAt + unhaltDuration >= block.number);
1340     }
1341 
1342     // implement restrictions for amount
1343     function redeem(address to, address token, uint256 amount, uint256 nonce, bytes memory signature) external isNotHalted {
1344         // We use local variables for gas optimisation and also we don't use the redeemInfo variable anymore after updating the mapping entry
1345         RedeemInfo memory redeemInfo = redeemsInfo[nonce];
1346         TokenInfo memory tokenInfo = tokensInfo[token];
1347         require(tokenInfo.redeemable, "redeem: Token not redeemable");
1348         require(redeemInfo.blockNumber != uint256max, "redeem: Nonce already redeemed");
1349         require((redeemInfo.blockNumber + tokenInfo.redeemDelay) < block.number, "redeem: Not redeemable yet");
1350 
1351         if (redeemInfo.blockNumber == 0) {
1352             // We only check the signature at the first redeem, on the second one we have only a check for the same parameters
1353             // In case the tss key is changed, we don't need to resign the transaction for the second redeem
1354             bytes32 messageHash = keccak256(abi.encode(networkClass, block.chainid, address(this), nonce, to, token, amount));
1355             messageHash = messageHash.toEthSignedMessageHash();
1356             address signer = messageHash.recover(signature);
1357             require(signer == tss, "redeem: Wrong signature");
1358 
1359             redeemsInfo[nonce].blockNumber = block.number;
1360             redeemsInfo[nonce].paramsHash = keccak256(abi.encode(to, token, amount));
1361             emit RegisteredRedeem(nonce, to, token, amount);
1362         } else {
1363             require(redeemsInfo[nonce].paramsHash == keccak256(abi.encode(to, token, amount)), "redeem: Second redeem has different params than the first one");
1364 
1365             // it cannot be uint256max or in delay
1366             redeemsInfo[nonce].blockNumber = uint256max;
1367             // if the bridge has ownership of the token then it means that this token is wrapped and it should have mint rights on it
1368             if (tokenInfo.owned) {
1369                 // bridge should have 0 balance of this wrapped token unless someone sent to this contract
1370                 // mint the needed amount
1371                 IToken(token).mint(to, amount);
1372             } else {
1373                 // if we do not own the token it means it is probably originating from this network so we should have locked tokens here
1374                 IERC20(token).safeTransfer(to, amount);
1375             }
1376             emit Redeemed(nonce, to, token, amount);
1377         }
1378     }
1379 
1380     function unwrap(address token, uint256 amount, string memory to) external isNotHalted {
1381         require(tokensInfo[token].bridgeable, "unwrap: Token not bridgeable");
1382         require(amount >= tokensInfo[token].minAmount, "unwrap: Amount has to be greater then the token minAmount");
1383 
1384         uint256 oldBalance = IERC20(token).balanceOf(address(this));
1385         IERC20(token).safeTransferFrom(_msgSender(), address(this), amount);
1386         uint256 newBalance = IERC20(token).balanceOf(address(this));
1387         require(amount <= newBalance, "unwrap: Amount bigger than the new balance");
1388         require(newBalance - amount == oldBalance, "unwrap: Tokens not sent");
1389 
1390         // if we have ownership to this token, we will burn because we can mint on redeem, otherwise we just keep the tokens
1391         if (tokensInfo[token].owned) {
1392             IToken(token).burn(amount);
1393         }
1394         emit Unwrapped(_msgSender(), token, to, amount);
1395     }
1396 
1397     function timeChallenge(string memory methodName, bytes32 paramsHash, uint256 challengeDelay) internal {
1398         if (timeChallengesInfo[methodName].paramsHash == paramsHash) {
1399             if (timeChallengesInfo[methodName].blockNumber + challengeDelay >= block.number) {
1400                 revert("challenge not due");
1401             }
1402             // otherwise the challenge is due and we reset it
1403             delete timeChallengesInfo[methodName].paramsHash;
1404         } else {
1405             // we start a new challenge
1406             timeChallengesInfo[methodName].paramsHash = paramsHash;
1407             timeChallengesInfo[methodName].blockNumber = block.number;
1408         }
1409     }
1410 
1411     function setTokenInfo(address token, uint256 minAmount, uint256 redeemDelay, bool bridgeable, bool redeemable, bool isOwned) external onlyAdministrator {
1412         require(redeemDelay > 2, "setTokenInfo: RedeemDelay is less than minimum");
1413 
1414         bytes32 paramsHash = keccak256(abi.encode(token, minAmount, redeemDelay, bridgeable, redeemable, isOwned));
1415         timeChallenge("setTokenInfo", paramsHash, softDelay);
1416         // early return for when we have a new challenge
1417         if (timeChallengesInfo["setTokenInfo"].paramsHash != bytes32(0)) {
1418             emit PendingTokenInfo(token);
1419             return;
1420         }
1421 
1422         tokensInfo[token].minAmount = minAmount;
1423         tokensInfo[token].redeemDelay = redeemDelay;
1424         tokensInfo[token].bridgeable = bridgeable;
1425         tokensInfo[token].redeemable = redeemable;
1426         tokensInfo[token].owned = isOwned;
1427         emit SetTokenInfo(token);
1428     }
1429 
1430     function halt(bytes memory signature) external {
1431         if (_msgSender() != administrator) {
1432             bytes32 messageHash = keccak256(abi.encode("halt", networkClass, block.chainid, address(this), actionsNonce));
1433             messageHash = messageHash.toEthSignedMessageHash();
1434             address signer = messageHash.recover(signature);
1435             require(signer == tss, "halt: Wrong signature");
1436             actionsNonce += 1;
1437         }
1438 
1439         halted = true;
1440         emit Halted();
1441     }
1442 
1443     function unhalt() external onlyAdministrator {
1444         require(halted, "unhalt: halted is false");
1445 
1446         halted = false;
1447         unhaltedAt = block.number;
1448         emit Unhalted();
1449     }
1450 
1451     // This method would be called if we detect a redeem transaction that did not originated from a user embedded bridge call on the znn network
1452     function revokeRedeems(uint256[] memory nonces) external onlyAdministrator {
1453         for(uint i = 0; i < nonces.length; i++) {
1454             redeemsInfo[nonces[i]].blockNumber = uint256max;
1455             emit RevokedRedeem(nonces[i]);
1456         }
1457     }
1458 
1459     function setAdministrator(address newAdministrator) external onlyAdministrator {
1460         require(newAdministrator != address(0), "setAdministrator: Invalid administrator address");
1461 
1462         bytes32 paramsHash = keccak256(abi.encode(newAdministrator));
1463         timeChallenge("setAdministrator", paramsHash, administratorDelay);
1464         // early return for when we have a new challenge
1465         if (timeChallengesInfo["setAdministrator"].paramsHash != bytes32(0)) {
1466             emit PendingAdministrator(newAdministrator);
1467             return;
1468         }
1469 
1470         emit SetAdministrator(newAdministrator, administrator);
1471         administrator = newAdministrator;
1472     }
1473 
1474     function setTss(address newTss, bytes memory oldSignature, bytes memory newSignature) external  {
1475         require(newTss != address(0), "setTss: Invalid newTss");
1476 
1477         if (_msgSender() != administrator) {
1478             // this only applies for non administrator calls
1479             require(allowKeyGen, "setTss: KeyGen is not allowed");
1480             require(!isHalted(), "setTss: Bridge halted");
1481             allowKeyGen = false;
1482 
1483             bytes32 messageHash = keccak256(abi.encode("setTss", networkClass, block.chainid, address(this), actionsNonce, newTss));
1484             messageHash = messageHash.toEthSignedMessageHash();
1485             address signer = messageHash.recover(oldSignature);
1486             require(signer == tss, "setTss: Wrong old signature");
1487 
1488             signer = messageHash.recover(newSignature);
1489             require(signer == newTss, "setTss: Wrong new signature");
1490 
1491             actionsNonce += 1;
1492         } else {
1493             bytes32 paramsHash = keccak256(abi.encode(newTss));
1494             timeChallenge("setTss", paramsHash, softDelay);
1495             // early return for when we have a new challenge
1496             if (timeChallengesInfo["setTss"].paramsHash != bytes32(0)) {
1497                 emit PendingTss(newTss);
1498                 return;
1499             }
1500         }
1501 
1502         emit SetTss(newTss, tss);
1503         tss = newTss;
1504     }
1505 
1506     function emergency() external onlyAdministrator {
1507         emit SetAdministrator(address(0), administrator);
1508         administrator = address(0);
1509 
1510         emit SetTss(address(0), tss);
1511         tss = address(0);
1512 
1513         halted = true;
1514         emit Halted();
1515     }
1516 
1517     function nominateGuardians(address[] memory newGuardians) external onlyAdministrator {
1518         require(newGuardians.length >= minNominatedGuardians, "nominateGuardians: Length less than minimum");
1519         require(newGuardians.length < 30, "nominateGuardians: Length bigger than maximum");
1520 
1521         bytes32 paramsHash = keccak256(abi.encode(newGuardians));
1522         timeChallenge("nominateGuardians", paramsHash, administratorDelay);
1523         // early return for when we have a new challenge
1524         if (timeChallengesInfo["nominateGuardians"].paramsHash != bytes32(0)) {
1525             // we check for duplicates only on new challenges
1526             for (uint i = 0; i < newGuardians.length; i++) {
1527                 if(newGuardians[i] == address(0)) {
1528                     revert("nominateGuardians: Found zero address");
1529                 }
1530                 for(uint j = i + 1; j < newGuardians.length; j++) {
1531                     if(newGuardians[i] == newGuardians[j]) {
1532                         revert("nominateGuardians: Found duplicated guardian");
1533                     }
1534                 }
1535             }
1536             emit PendingGuardians();
1537             return;
1538         }
1539 
1540         for (uint i = 0; i < guardians.length; i++) {
1541             delete votesCount[guardiansVotes[i]];
1542         }
1543         delete guardiansVotes;
1544         delete guardians;
1545         for (uint i = 0; i < newGuardians.length; i++) {
1546             guardians.push(newGuardians[i]);
1547             guardiansVotes.push(address(0));
1548         }
1549         emit SetGuardians();
1550     }
1551 
1552     function proposeAdministrator(address newAdministrator) external {
1553         require(administrator == address(0), "proposeAdministrator: Bridge not in emergency");
1554         require(newAdministrator != address(0), "proposeAdministrator: Invalid new address");
1555 
1556         for(uint i = 0; i < guardians.length; i++) {
1557             if (guardians[i] == _msgSender()) {
1558                 if (guardiansVotes[i] != address(0)) {
1559                     votesCount[guardiansVotes[i]] -= 1;
1560                 }
1561                 guardiansVotes[i] = newAdministrator;
1562                 votesCount[newAdministrator] += 1;
1563                 uint threshold = guardians.length / 2;
1564                 if (votesCount[newAdministrator] > threshold) {
1565                     for(uint j = 0; j < guardiansVotes.length; j++) {
1566                         delete votesCount[guardiansVotes[j]];
1567                         guardiansVotes[j] = address(0);
1568                     }
1569                     administrator = newAdministrator;
1570                     emit SetAdministrator(newAdministrator, address(0));
1571                 }
1572                 break;
1573             }
1574         }
1575     }
1576 
1577     function setAdministratorDelay(uint256 delay) external onlyAdministrator {
1578         require(delay >= minAdministratorDelay, "setAdministratorDelay: Delay is less than minimum");
1579         administratorDelay = delay;
1580         emit SetAdministratorDelay(delay);
1581     }
1582 
1583     function setSoftDelay(uint256 delay) external onlyAdministrator {
1584         require(delay >= minSoftDelay, "setSoftDelay: Delay is less than minimum");
1585         softDelay = delay;
1586         emit SetSoftDelay(delay);
1587     }
1588 
1589     function setUnhaltDuration(uint256 duration) external onlyAdministrator {
1590         require(duration >= minUnhaltDuration, "setUnhaltDuration: Duration is less than minimum");
1591         unhaltDuration = duration;
1592         emit SetUnhaltDuration(duration);
1593     }
1594 
1595     function setEstimatedBlockTime(uint64 blockTime) external onlyAdministrator {
1596         require(blockTime > 0, "setEstimatedBlockTime: BlockTime is less than minimum");
1597         estimatedBlockTime = blockTime;
1598         emit SetEstimatedBlockTime(blockTime);
1599     }
1600 
1601     function setAllowKeyGen(bool value) external onlyAdministrator {
1602         allowKeyGen = value;
1603         emit SetAllowKeyGen(value);
1604     }
1605 
1606     function setConfirmationsToFinality(uint64 confirmations) external onlyAdministrator {
1607         require(confirmations > 1, "setConfirmationsToFinality: Confirmations is less than minimum");
1608         confirmationsToFinality = confirmations;
1609         emit SetConfirmationsToFinality(confirmations);
1610     }
1611 }