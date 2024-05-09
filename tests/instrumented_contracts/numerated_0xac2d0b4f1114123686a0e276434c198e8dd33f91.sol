1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 //AE THER 
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**t
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `to`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address to, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `from` to `to` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address from,
68         address to,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Contract module that helps prevent reentrant calls to a function.
96  *
97  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
98  * available, which can be applied to functions to make sure there are no nested
99  * (reentrant) calls to them.
100  *
101  * Note that because there is a single `nonReentrant` guard, functions marked as
102  * `nonReentrant` may not call one another. This can be worked around by making
103  * those functions `private`, and then adding `external` `nonReentrant` entry
104  * points to them.
105  *
106  * TIP: If you would like to learn more about reentrancy and alternative ways
107  * to protect against it, check out our blog post
108  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
109  */
110 abstract contract ReentrancyGuard {
111     // Booleans are more expensive than uint256 or any type that takes up a full
112     // word because each write operation emits an extra SLOAD to first read the
113     // slot's contents, replace the bits taken up by the boolean, and then write
114     // back. This is the compiler's defense against contract upgrades and
115     // pointer aliasing, and it cannot be disabled.
116 
117     // The values being non-zero value makes deployment a bit more expensive,
118     // but in exchange the refund on every call to nonReentrant will be lower in
119     // amount. Since refunds are capped to a percentage of the total
120     // transaction's gas, it is best to keep them low in cases like this one, to
121     // increase the likelihood of the full refund coming into effect.
122     uint256 private constant _NOT_ENTERED = 1;
123     uint256 private constant _ENTERED = 2;
124 
125     uint256 private _status;
126 
127     constructor() {
128         _status = _NOT_ENTERED;
129     }
130 
131     /**
132      * @dev Prevents a contract from calling itself, directly or indirectly.
133      * Calling a `nonReentrant` function from another `nonReentrant`
134      * function is not supported. It is possible to prevent this from happening
135      * by making the `nonReentrant` function external, and making it call a
136      * `private` function that does the actual work.
137      */
138     modifier nonReentrant() {
139         // On the first call to nonReentrant, _notEntered will be true
140         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
141 
142         // Any calls to nonReentrant after this point will fail
143         _status = _ENTERED;
144 
145         _;
146 
147         // By storing the original value once again, a refund is triggered (see
148         // https://eips.ethereum.org/EIPS/eip-2200)
149         _status = _NOT_ENTERED;
150     }
151 }
152 
153 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
154 
155 
156 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 /**
161  * @dev These functions deal with verification of Merkle Trees proofs.
162  *
163  * The proofs can be generated using the JavaScript library
164  * https://github.com/miguelmota/merkletreejs[merkletreejs].
165  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
166  *
167  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
168  */
169 library MerkleProof {
170     /**
171      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
172      * defined by `root`. For this, a `proof` must be provided, containing
173      * sibling hashes on the branch from the leaf to the root of the tree. Each
174      * pair of leaves and each pair of pre-images are assumed to be sorted.
175      */
176     function verify(
177         bytes32[] memory proof,
178         bytes32 root,
179         bytes32 leaf
180     ) internal pure returns (bool) {
181         return processProof(proof, leaf) == root;
182     }
183 
184     /**
185      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
186      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
187      * hash matches the root of the tree. When processing the proof, the pairs
188      * of leafs & pre-images are assumed to be sorted.
189      *
190      * _Available since v4.4._
191      */
192     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
193         bytes32 computedHash = leaf;
194         for (uint256 i = 0; i < proof.length; i++) {
195             bytes32 proofElement = proof[i];
196             if (computedHash <= proofElement) {
197                 // Hash(current computed hash + current element of the proof)
198                 computedHash = _efficientHash(computedHash, proofElement);
199             } else {
200                 // Hash(current element of the proof + current computed hash)
201                 computedHash = _efficientHash(proofElement, computedHash);
202             }
203         }
204         return computedHash;
205     }
206 
207     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
208         assembly {
209             mstore(0x00, a)
210             mstore(0x20, b)
211             value := keccak256(0x00, 0x40)
212         }
213     }
214 }
215 
216 // File: @openzeppelin/contracts/utils/Strings.sol
217 
218 
219 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev String operations.
225  */
226 library Strings {
227     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
228 
229     /**
230      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
231      */
232     function toString(uint256 value) internal pure returns (string memory) {
233         // Inspired by OraclizeAPI's implementation - MIT licence
234         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
235 
236         if (value == 0) {
237             return "0";
238         }
239         uint256 temp = value;
240         uint256 digits;
241         while (temp != 0) {
242             digits++;
243             temp /= 10;
244         }
245         bytes memory buffer = new bytes(digits);
246         while (value != 0) {
247             digits -= 1;
248             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
249             value /= 10;
250         }
251         return string(buffer);
252     }
253 
254     /**
255      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
256      */
257     function toHexString(uint256 value) internal pure returns (string memory) {
258         if (value == 0) {
259             return "0x00";
260         }
261         uint256 temp = value;
262         uint256 length = 0;
263         while (temp != 0) {
264             length++;
265             temp >>= 8;
266         }
267         return toHexString(value, length);
268     }
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
272      */
273     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
274         bytes memory buffer = new bytes(2 * length + 2);
275         buffer[0] = "0";
276         buffer[1] = "x";
277         for (uint256 i = 2 * length + 1; i > 1; --i) {
278             buffer[i] = _HEX_SYMBOLS[value & 0xf];
279             value >>= 4;
280         }
281         require(value == 0, "Strings: hex length insufficient");
282         return string(buffer);
283     }
284 }
285 
286 // File: @openzeppelin/contracts/utils/Context.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Provides information about the current execution context, including the
295  * sender of the transaction and its data. While these are generally available
296  * via msg.sender and msg.data, they should not be accessed in such a direct
297  * manner, since when dealing with meta-transactions the account sending and
298  * paying for execution may not be the actual sender (as far as an application
299  * is concerned).
300  *
301  * This contract is only required for intermediate, library-like contracts.
302  */
303 abstract contract Context {
304     function _msgSender() internal view virtual returns (address) {
305         return msg.sender;
306     }
307 
308     function _msgData() internal view virtual returns (bytes calldata) {
309         return msg.data;
310     }
311 }
312 
313 // File: @openzeppelin/contracts/access/Ownable.sol
314 
315 
316 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 
321 /**
322  * @dev Contract module which provides a basic access control mechanism, where
323  * there is an account (an owner) that can be granted exclusive access to
324  * specific functions.
325  *
326  * By default, the owner account will be the one that deploys the contract. This
327  * can later be changed with {transferOwnership}.
328  *
329  * This module is used through inheritance. It will make available the modifier
330  * `onlyOwner`, which can be applied to your functions to restrict their use to
331  * the owner.
332  */
333 abstract contract Ownable is Context {
334     address private _owner;
335 
336     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
337 
338     /**
339      * @dev Initializes the contract setting the deployer as the initial owner.
340      */
341     constructor() {
342         _transferOwnership(_msgSender());
343     }
344 
345     /**
346      * @dev Returns the address of the current owner.
347      */
348     function owner() public view virtual returns (address) {
349         return _owner;
350     }
351 
352     /**
353      * @dev Throws if called by any account other than the owner.
354      */
355     modifier onlyOwner() {
356         require(owner() == _msgSender(), "Ownable: caller is not the owner");
357         _;
358     }
359 
360     /**
361      * @dev Leaves the contract without owner. It will not be possible to call
362      * `onlyOwner` functions anymore. Can only be called by the current owner.
363      *
364      * NOTE: Renouncing ownership will leave the contract without an owner,
365      * thereby removing any functionality that is only available to the owner.
366      */
367     function renounceOwnership() public virtual onlyOwner {
368         _transferOwnership(address(0));
369     }
370 
371     /**
372      * @dev Transfers ownership of the contract to a new account (`newOwner`).
373      * Can only be called by the current owner.
374      */
375     function transferOwnership(address newOwner) public virtual onlyOwner {
376         require(newOwner != address(0), "Ownable: new owner is the zero address");
377         _transferOwnership(newOwner);
378     }
379 
380     /**
381      * @dev Transfers ownership of the contract to a new account (`newOwner`).
382      * Internal function without access restriction.
383      */
384     function _transferOwnership(address newOwner) internal virtual {
385         address oldOwner = _owner;
386         _owner = newOwner;
387         emit OwnershipTransferred(oldOwner, newOwner);
388     }
389 } 
390 
391 // File: @openzeppelin/contracts/utils/Address.sol
392 
393 
394 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
395 
396 pragma solidity ^0.8.1;
397 
398 /**
399  * @dev Collection of functions related to the address type
400  */
401 library Address {
402     /**
403      * @dev Returns true if `account` is a contract.
404      *
405      * [IMPORTANT]
406      * ====
407      * It is unsafe to assume that an address for which this function returns
408      * false is an externally-owned account (EOA) and not a contract.
409      *
410      * Among others, `isContract` will return false for the following
411      * types of addresses:
412      *
413      *  - an externally-owned account
414      *  - a contract in construction
415      *  - an address where a contract will be created
416      *  - an address where a contract lived, but was destroyed
417      * ====
418      *
419      * [IMPORTANT]
420      * ====
421      * You shouldn't rely on `isContract` to protect against flash loan attacks!
422      *
423      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
424      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
425      * constructor.
426      * ====
427      */
428     function isContract(address account) internal view returns (bool) {
429         // This method relies on extcodesize/address.code.length, which returns 0
430         // for contracts in construction, since the code is only stored at the end
431         // of the constructor execution.
432 
433         return account.code.length > 0;
434     }
435 
436     /**
437      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
438      * `recipient`, forwarding all available gas and reverting on errors.
439      *
440      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
441      * of certain opcodes, possibly making contracts go over the 2300 gas limit
442      * imposed by `transfer`, making them unable to receive funds via
443      * `transfer`. {sendValue} removes this limitation.
444      *
445      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
446      *
447      * IMPORTANT: because control is transferred to `recipient`, care must be
448      * taken to not create reentrancy vulnerabilities. Consider using
449      * {ReentrancyGuard} or the
450      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
451      */
452     function sendValue(address payable recipient, uint256 amount) internal {
453         require(address(this).balance >= amount, "Address: insufficient balance");
454 
455         (bool success, ) = recipient.call{value: amount}("");
456         require(success, "Address: unable to send value, recipient may have reverted");
457     }
458 
459     /**
460      * @dev Performs a Solidity function call using a low level `call`. A
461      * plain `call` is an unsafe replacement for a function call: use this
462      * function instead.
463      *
464      * If `target` reverts with a revert reason, it is bubbled up by this
465      * function (like regular Solidity function calls).
466      *
467      * Returns the raw returned data. To convert to the expected return value,
468      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
469      *
470      * Requirements:
471      *
472      * - `target` must be a contract.
473      * - calling `target` with `data` must not revert.
474      *
475      * _Available since v3.1._
476      */
477     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
478         return functionCall(target, data, "Address: low-level call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
483      * `errorMessage` as a fallback revert reason when `target` reverts.
484      *
485      * _Available since v3.1._
486      */
487     function functionCall(
488         address target,
489         bytes memory data,
490         string memory errorMessage
491     ) internal returns (bytes memory) {
492         return functionCallWithValue(target, data, 0, errorMessage);
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
497      * but also transferring `value` wei to `target`.
498      *
499      * Requirements:
500      *
501      * - the calling contract must have an ETH balance of at least `value`.
502      * - the called Solidity function must be `payable`.
503      *
504      * _Available since v3.1._
505      */
506     function functionCallWithValue(
507         address target,
508         bytes memory data,
509         uint256 value
510     ) internal returns (bytes memory) {
511         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
516      * with `errorMessage` as a fallback revert reason when `target` reverts.
517      *
518      * _Available since v3.1._
519      */
520     function functionCallWithValue(
521         address target,
522         bytes memory data,
523         uint256 value,
524         string memory errorMessage
525     ) internal returns (bytes memory) {
526         require(address(this).balance >= value, "Address: insufficient balance for call");
527         require(isContract(target), "Address: call to non-contract");
528 
529         (bool success, bytes memory returndata) = target.call{value: value}(data);
530         return verifyCallResult(success, returndata, errorMessage);
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
535      * but performing a static call.
536      *
537      * _Available since v3.3._
538      */
539     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
540         return functionStaticCall(target, data, "Address: low-level static call failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
545      * but performing a static call.
546      *
547      * _Available since v3.3._
548      */
549     function functionStaticCall(
550         address target,
551         bytes memory data,
552         string memory errorMessage
553     ) internal view returns (bytes memory) {
554         require(isContract(target), "Address: static call to non-contract");
555 
556         (bool success, bytes memory returndata) = target.staticcall(data);
557         return verifyCallResult(success, returndata, errorMessage);
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
562      * but performing a delegate call.
563      *
564      * _Available since v3.4._
565      */
566     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
567         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
572      * but performing a delegate call.
573      *
574      * _Available since v3.4._
575      */
576     function functionDelegateCall(
577         address target,
578         bytes memory data,
579         string memory errorMessage
580     ) internal returns (bytes memory) {
581         require(isContract(target), "Address: delegate call to non-contract");
582 
583         (bool success, bytes memory returndata) = target.delegatecall(data);
584         return verifyCallResult(success, returndata, errorMessage);
585     }
586 
587     /**
588      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
589      * revert reason using the provided one.
590      *
591      * _Available since v4.3._
592      */
593     function verifyCallResult(
594         bool success,
595         bytes memory returndata,
596         string memory errorMessage
597     ) internal pure returns (bytes memory) {
598         if (success) {
599             return returndata;
600         } else {
601             // Look for revert reason and bubble it up if present
602             if (returndata.length > 0) {
603                 // The easiest way to bubble the revert reason is using memory via assembly
604 
605                 assembly {
606                     let returndata_size := mload(returndata)
607                     revert(add(32, returndata), returndata_size)
608                 }
609             } else {
610                 revert(errorMessage);
611             }
612         }
613     }
614 }
615 
616 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
617 
618 
619 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
620 
621 pragma solidity ^0.8.0;
622 
623 
624 
625 /**
626  * @title SafeERC20
627  * @dev Wrappers around ERC20 operations that throw on failure (when the token
628  * contract returns false). Tokens that return no value (and instead revert or
629  * throw on failure) are also supported, non-reverting calls are assumed to be
630  * successful.
631  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
632  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
633  */
634 library SafeERC20 {
635     using Address for address;
636 
637     function safeTransfer(
638         IERC20 token,
639         address to,
640         uint256 value
641     ) internal {
642         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
643     }
644 
645     function safeTransferFrom(
646         IERC20 token,
647         address from,
648         address to,
649         uint256 value
650     ) internal {
651         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
652     }
653 
654     /**
655      * @dev Deprecated. This function has issues similar to the ones found in
656      * {IERC20-approve}, and its usage is discouraged.
657      *
658      * Whenever possible, use {safeIncreaseAllowance} and
659      * {safeDecreaseAllowance} instead.
660      */
661     function safeApprove(
662         IERC20 token,
663         address spender,
664         uint256 value
665     ) internal {
666         // safeApprove should only be called when setting an initial allowance,
667         // or when resetting it to zero. To increase and decrease it, use
668         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
669         require(
670             (value == 0) || (token.allowance(address(this), spender) == 0),
671             "SafeERC20: approve from non-zero to non-zero allowance"
672         );
673         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
674     }
675 
676     function safeIncreaseAllowance(
677         IERC20 token,
678         address spender,
679         uint256 value
680     ) internal {
681         uint256 newAllowance = token.allowance(address(this), spender) + value;
682         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
683     }
684 
685     function safeDecreaseAllowance(
686         IERC20 token,
687         address spender,
688         uint256 value
689     ) internal {
690         unchecked {
691             uint256 oldAllowance = token.allowance(address(this), spender);
692             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
693             uint256 newAllowance = oldAllowance - value;
694             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
695         }
696     }
697 
698     /**
699      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
700      * on the return value: the return value is optional (but if data is returned, it must not be false).
701      * @param token The token targeted by the call.
702      * @param data The call data (encoded using abi.encode or one of its variants).
703      */
704     function _callOptionalReturn(IERC20 token, bytes memory data) private {
705         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
706         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
707         // the target address contains contract code and also asserts for success in the low-level call.
708 
709         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
710         if (returndata.length > 0) {
711             // Return data is optional
712             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
713         }
714     }
715 }
716 
717 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
718 
719 
720 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
721 
722 
723 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 /**
731  * @title ERC721 token receiver interface
732  * @dev Interface for any contract that wants to support safeTransfers
733  * from ERC721 asset contracts.
734  */
735 interface IERC721Receiver {
736     /**
737      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
738      * by `operator` from `from`, this function is called.
739      *
740      * It must return its Solidity selector to confirm the token transfer.
741      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
742      *
743      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
744      */
745     function onERC721Received(
746         address operator,
747         address from,
748         uint256 tokenId,
749         bytes calldata data
750     ) external returns (bytes4);
751 }
752 
753 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
754 
755 
756 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
757 
758 pragma solidity ^0.8.0;
759 
760 /**
761  * @dev Interface of the ERC165 standard, as defined in the
762  * https://eips.ethereum.org/EIPS/eip-165[EIP].
763  *
764  * Implementers can declare support of contract interfaces, which can then be
765  * queried by others ({ERC165Checker}).
766  *
767  * For an implementation, see {ERC165}.
768  */
769 interface IERC165 {
770     /**
771      * @dev Returns true if this contract implements the interface defined by
772      * `interfaceId`. See the corresponding
773      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
774      * to learn more about how these ids are created.
775      *
776      * This function call must use less than 30 000 gas.
777      */
778     function supportsInterface(bytes4 interfaceId) external view returns (bool);
779 }
780 
781 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
782 
783 
784 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
785 
786 pragma solidity ^0.8.0;
787 
788 
789 /**
790  * @dev Implementation of the {IERC165} interface.
791  *
792  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
793  * for the additional interface id that will be supported. For example:
794  *
795  * ```solidity
796  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
797  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
798  * }
799  * ```
800  *
801  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
802  */
803 abstract contract ERC165 is IERC165 {
804     /**
805      * @dev See {IERC165-supportsInterface}.
806      */
807     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
808         return interfaceId == type(IERC165).interfaceId;
809     }
810 }
811 
812 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
813 
814 
815 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
816 
817 pragma solidity ^0.8.0;
818 
819 
820 /**
821  * @dev Required interface of an ERC721 compliant contract.
822  */
823 interface IERC721 is IERC165 {
824     /**
825      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
826      */
827     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
828 
829     /**
830      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
831      */
832     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
833 
834     /**
835      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
836      */
837     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
838 
839     /**
840      * @dev Returns the number of tokens in ``owner``'s account.
841      */
842     function balanceOf(address owner) external view returns (uint256 balance);
843 
844     /**
845      * @dev Returns the owner of the `tokenId` token.
846      *
847      * Requirements:
848      *
849      * - `tokenId` must exist.
850      */
851     function ownerOf(uint256 tokenId) external view returns (address owner);
852 
853     /**
854      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
855      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
856      *
857      * Requirements:
858      *
859      * - `from` cannot be the zero address.
860      * - `to` cannot be the zero address.
861      * - `tokenId` token must exist and be owned by `from`.
862      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
863      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
864      *
865      * Emits a {Transfer} event.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId
871     ) external;
872 
873     /**
874      * @dev Transfers `tokenId` token from `from` to `to`.
875      *
876      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
877      *
878      * Requirements:
879      *
880      * - `from` cannot be the zero address.
881      * - `to` cannot be the zero address.
882      * - `tokenId` token must be owned by `from`.
883      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
884      *
885      * Emits a {Transfer} event.
886      */
887     function transferFrom(
888         address from,
889         address to,
890         uint256 tokenId
891     ) external;
892 
893     /**
894      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
895      * The approval is cleared when the token is transferred.
896      *
897      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
898      *
899      * Requirements:
900      *
901      * - The caller must own the token or be an approved operator.
902      * - `tokenId` must exist.
903      *
904      * Emits an {Approval} event.
905      */
906     function approve(address to, uint256 tokenId) external;
907 
908     /**
909      * @dev Returns the account approved for `tokenId` token.
910      *
911      * Requirements:
912      *
913      * - `tokenId` must exist.
914      */
915     function getApproved(uint256 tokenId) external view returns (address operator);
916 
917     /**
918      * @dev Approve or remove `operator` as an operator for the caller.
919      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
920      *
921      * Requirements:
922      *
923      * - The `operator` cannot be the caller.
924      *
925      * Emits an {ApprovalForAll} event.
926      */
927     function setApprovalForAll(address operator, bool _approved) external;
928 
929     /**
930      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
931      *
932      * See {setApprovalForAll}
933      */
934     function isApprovedForAll(address owner, address operator) external view returns (bool);
935 
936     /**
937      * @dev Safely transfers `tokenId` token from `from` to `to`.
938      *
939      * Requirements:
940      *
941      * - `from` cannot be the zero address.
942      * - `to` cannot be the zero address.
943      * - `tokenId` token must exist and be owned by `from`.
944      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
946      *
947      * Emits a {Transfer} event.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes calldata data
954     ) external;
955 }
956 
957 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
958 
959 
960 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
961 
962 pragma solidity ^0.8.0;
963 
964 
965 /**
966  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
967  * @dev See https://eips.ethereum.org/EIPS/eip-721
968  */
969 interface IERC721Enumerable is IERC721 {
970     /**
971      * @dev Returns the total amount of tokens stored by the contract.
972      */
973     function totalSupply() external view returns (uint256);
974 
975     /**
976      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
977      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
978      */
979     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
980 
981     /**
982      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
983      * Use along with {totalSupply} to enumerate all tokens.
984      */
985     function tokenByIndex(uint256 index) external view returns (uint256);
986 }
987 
988 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
989 
990 
991 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
992 
993 pragma solidity ^0.8.0;
994 
995 
996 /**
997  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
998  * @dev See https://eips.ethereum.org/EIPS/eip-721
999  */
1000 interface IERC721Metadata is IERC721 {
1001     /**
1002      * @dev Returns the token collection name.
1003      */
1004     function name() external view returns (string memory);
1005 
1006     /**
1007      * @dev Returns the token collection symbol.
1008      */
1009     function symbol() external view returns (string memory);
1010 
1011     /**
1012      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1013      */
1014     function tokenURI(uint256 tokenId) external view returns (string memory);
1015 }
1016 
1017 // File: erc721a/contracts/ERC721A.sol
1018 
1019 
1020 // Creator: Chiru Labs
1021 
1022 pragma solidity ^0.8.4;
1023 
1024 
1025 
1026 
1027 
1028 
1029 
1030 
1031 
1032 error ApprovalCallerNotOwnerNorApproved();
1033 error ApprovalQueryForNonexistentToken();
1034 error ApproveToCaller();
1035 error ApprovalToCurrentOwner();
1036 error BalanceQueryForZeroAddress();
1037 error MintedQueryForZeroAddress();
1038 error BurnedQueryForZeroAddress();
1039 error AuxQueryForZeroAddress();
1040 error MintToZeroAddress();
1041 error MintZeroQuantity();
1042 error OwnerIndexOutOfBounds();
1043 error OwnerQueryForNonexistentToken();
1044 error TokenIndexOutOfBounds();
1045 error TransferCallerNotOwnerNorApproved();
1046 error TransferFromIncorrectOwner();
1047 error TransferToNonERC721ReceiverImplementer();
1048 error TransferToZeroAddress();
1049 error URIQueryForNonexistentToken();
1050 
1051 /**
1052  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1053  * the Metadata extension. Built to optimize for lower gas during batch mints.
1054  *
1055  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1056  *
1057  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1058  *
1059  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1060  */
1061 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1062     using Address for address;
1063     using Strings for uint256;
1064 
1065     // Compiler will pack this into a single 256bit word.
1066     struct TokenOwnership {
1067         // The address of the owner.
1068         address addr;
1069         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1070         uint64 startTimestamp;
1071         // Whether the token has been burned.
1072         bool burned;
1073     }
1074 
1075     // Compiler will pack this into a single 256bit word.
1076     struct AddressData {
1077         // Realistically, 2**64-1 is more than enough.
1078         uint64 balance;
1079         // Keeps track of mint count with minimal overhead for tokenomics.
1080         uint64 numberMinted;
1081         // Keeps track of burn count with minimal overhead for tokenomics.
1082         uint64 numberBurned;
1083         // For miscellaneous variable(s) pertaining to the address
1084         // (e.g. number of whitelist mint slots used).
1085         // If there are multiple variables, please pack them into a uint64.
1086         uint64 aux;
1087     }
1088 
1089     // The tokenId of the next token to be minted.
1090     uint256 internal _currentIndex;
1091 
1092     // The number of tokens burned.
1093     uint256 internal _burnCounter;
1094 
1095     // Token name
1096     string private _name;
1097 
1098     // Token symbol
1099     string private _symbol;
1100 
1101     // Mapping from token ID to ownership details
1102     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1103     mapping(uint256 => TokenOwnership) internal _ownerships;
1104 
1105     // Mapping owner address to address data
1106     mapping(address => AddressData) private _addressData;
1107 
1108     // Mapping from token ID to approved address
1109     mapping(uint256 => address) private _tokenApprovals;
1110 
1111     // Mapping from owner to operator approvals
1112     mapping(address => mapping(address => bool)) private _operatorApprovals;
1113 
1114     constructor(string memory name_, string memory symbol_) {
1115         _name = name_;
1116         _symbol = symbol_;
1117         _currentIndex = _startTokenId();
1118     }
1119 
1120     /**
1121      * To change the starting tokenId, please override this function.
1122      */
1123     function _startTokenId() internal view virtual returns (uint256) {
1124         return 0;
1125     }
1126 
1127     /**
1128      * @dev See {IERC721Enumerable-totalSupply}.
1129      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1130      */
1131     function totalSupply() public view returns (uint256) {
1132         // Counter underflow is impossible as _burnCounter cannot be incremented
1133         // more than _currentIndex - _startTokenId() times
1134         unchecked {
1135             return _currentIndex - _burnCounter - _startTokenId();
1136         }
1137     }
1138 
1139     /**
1140      * Returns the total amount of tokens minted in the contract.
1141      */
1142     function _totalMinted() internal view returns (uint256) {
1143         // Counter underflow is impossible as _currentIndex does not decrement,
1144         // and it is initialized to _startTokenId()
1145         unchecked {
1146             return _currentIndex - _startTokenId();
1147         }
1148     }
1149 
1150     /**
1151      * @dev See {IERC165-supportsInterface}.
1152      */
1153     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1154         return
1155             interfaceId == type(IERC721).interfaceId ||
1156             interfaceId == type(IERC721Metadata).interfaceId ||
1157             super.supportsInterface(interfaceId);
1158     }
1159 
1160     /**
1161      * @dev See {IERC721-balanceOf}.
1162      */
1163     function balanceOf(address owner) public view override returns (uint256) {
1164         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1165         return uint256(_addressData[owner].balance);
1166     }
1167 
1168     /**
1169      * Returns the number of tokens minted by `owner`.
1170      */
1171     function _numberMinted(address owner) internal view returns (uint256) {
1172         if (owner == address(0)) revert MintedQueryForZeroAddress();
1173         return uint256(_addressData[owner].numberMinted);
1174     }
1175 
1176     /**
1177      * Returns the number of tokens burned by or on behalf of `owner`.
1178      */
1179     function _numberBurned(address owner) internal view returns (uint256) {
1180         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1181         return uint256(_addressData[owner].numberBurned);
1182     }
1183 
1184     /**
1185      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1186      */
1187     function _getAux(address owner) internal view returns (uint64) {
1188         if (owner == address(0)) revert AuxQueryForZeroAddress();
1189         return _addressData[owner].aux;
1190     }
1191 
1192     /**
1193      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1194      * If there are multiple variables, please pack them into a uint64.
1195      */
1196     function _setAux(address owner, uint64 aux) internal {
1197         if (owner == address(0)) revert AuxQueryForZeroAddress();
1198         _addressData[owner].aux = aux;
1199     }
1200 
1201     /**
1202      * Gas spent here starts off proportional to the maximum mint batch size.
1203      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1204      */
1205     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1206         uint256 curr = tokenId;
1207 
1208         unchecked {
1209             if (_startTokenId() <= curr && curr < _currentIndex) {
1210                 TokenOwnership memory ownership = _ownerships[curr];
1211                 if (!ownership.burned) {
1212                     if (ownership.addr != address(0)) {
1213                         return ownership;
1214                     }
1215                     // Invariant:
1216                     // There will always be an ownership that has an address and is not burned
1217                     // before an ownership that does not have an address and is not burned.
1218                     // Hence, curr will not underflow.
1219                     while (true) {
1220                         curr--;
1221                         ownership = _ownerships[curr];
1222                         if (ownership.addr != address(0)) {
1223                             return ownership;
1224                         }
1225                     }
1226                 }
1227             }
1228         }
1229         revert OwnerQueryForNonexistentToken();
1230     }
1231 
1232     /**
1233      * @dev See {IERC721-ownerOf}.
1234      */
1235     function ownerOf(uint256 tokenId) public view override returns (address) {
1236         return ownershipOf(tokenId).addr;
1237     }
1238 
1239     /**
1240      * @dev See {IERC721Metadata-name}.
1241      */
1242     function name() public view virtual override returns (string memory) {
1243         return _name;
1244     }
1245 
1246     /**
1247      * @dev See {IERC721Metadata-symbol}.
1248      */
1249     function symbol() public view virtual override returns (string memory) {
1250         return _symbol;
1251     }
1252 
1253     /**
1254      * @dev See {IERC721Metadata-tokenURI}.
1255      */
1256     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1257         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1258 
1259         string memory baseURI = _baseURI();
1260         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1261     }
1262 
1263     /**
1264      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1265      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1266      * by default, can be overriden in child contracts.
1267      */
1268     function _baseURI() internal view virtual returns (string memory) {
1269         return '';
1270     }
1271 
1272     /**
1273      * @dev See {IERC721-approve}.
1274      */
1275     function approve(address to, uint256 tokenId) public override {
1276         address owner = ERC721A.ownerOf(tokenId);
1277         if (to == owner) revert ApprovalToCurrentOwner();
1278 
1279         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1280             revert ApprovalCallerNotOwnerNorApproved();
1281         }
1282 
1283         _approve(to, tokenId, owner);
1284     }
1285 
1286     /**
1287      * @dev See {IERC721-getApproved}.
1288      */
1289     function getApproved(uint256 tokenId) public view override returns (address) {
1290         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1291 
1292         return _tokenApprovals[tokenId];
1293     }
1294 
1295     /**
1296      * @dev See {IERC721-setApprovalForAll}.
1297      */
1298     function setApprovalForAll(address operator, bool approved) public override {
1299         if (operator == _msgSender()) revert ApproveToCaller();
1300 
1301         _operatorApprovals[_msgSender()][operator] = approved;
1302         emit ApprovalForAll(_msgSender(), operator, approved);
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-isApprovedForAll}.
1307      */
1308     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1309         return _operatorApprovals[owner][operator];
1310     }
1311 
1312     /**
1313      * @dev See {IERC721-transferFrom}.
1314      */
1315     function transferFrom(
1316         address from,
1317         address to,
1318         uint256 tokenId
1319     ) public virtual override {
1320         _transfer(from, to, tokenId);
1321     }
1322 
1323     /**
1324      * @dev See {IERC721-safeTransferFrom}.
1325      */
1326     function safeTransferFrom(
1327         address from,
1328         address to,
1329         uint256 tokenId
1330     ) public virtual override {
1331         safeTransferFrom(from, to, tokenId, '');
1332     }
1333     
1334     /**
1335      * @dev See {IERC721-safeTransferFrom}.
1336      */
1337     function safeTransferFrom(
1338         address from,
1339         address to,
1340         uint256 tokenId,
1341         bytes memory _data
1342     ) public virtual override {
1343         _transfer(from, to, tokenId);
1344         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1345             revert TransferToNonERC721ReceiverImplementer();
1346         }
1347     }
1348 
1349     /**
1350      * @dev Returns whether `tokenId` exists.
1351      *
1352      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1353      *
1354      * Tokens start existing when they are minted (`_mint`),
1355      */
1356     function _exists(uint256 tokenId) internal view returns (bool) {
1357         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1358             !_ownerships[tokenId].burned;
1359     }
1360 
1361     function _safeMint(address to, uint256 quantity) internal {
1362         _safeMint(to, quantity, '');
1363     }
1364 
1365     /**
1366      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1367      *
1368      * Requirements:
1369      *
1370      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1371      * - `quantity` must be greater than 0.
1372      *
1373      * Emits a {Transfer} event.
1374      */
1375     function _safeMint(
1376         address to,
1377         uint256 quantity,
1378         bytes memory _data
1379     ) internal {
1380         _mint(to, quantity, _data, true);
1381     }
1382 
1383     /**
1384      * @dev Mints `quantity` tokens and transfers them to `to`.
1385      *
1386      * Requirements:
1387      *
1388      * - `to` cannot be the zero address.
1389      * - `quantity` must be greater than 0.
1390      *
1391      * Emits a {Transfer} event.
1392      */
1393     function _mint(
1394         address to,
1395         uint256 quantity,
1396         bytes memory _data,
1397         bool safe
1398     ) internal {
1399         uint256 startTokenId = _currentIndex;
1400         if (to == address(0)) revert MintToZeroAddress();
1401         if (quantity == 0) revert MintZeroQuantity();
1402 
1403         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1404 
1405         // Overflows are incredibly unrealistic.
1406         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1407         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1408         unchecked {
1409             _addressData[to].balance += uint64(quantity);
1410             _addressData[to].numberMinted += uint64(quantity);
1411 
1412             _ownerships[startTokenId].addr = to;
1413             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1414 
1415             uint256 updatedIndex = startTokenId;
1416             uint256 end = updatedIndex + quantity;
1417 
1418             if (safe && to.isContract()) {
1419                 do {
1420                     emit Transfer(address(0), to, updatedIndex);
1421                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1422                         revert TransferToNonERC721ReceiverImplementer();
1423                     }
1424                 } while (updatedIndex != end);
1425                 // Reentrancy protection
1426                 if (_currentIndex != startTokenId) revert();
1427             } else {
1428                 do {
1429                     emit Transfer(address(0), to, updatedIndex++);
1430                 } while (updatedIndex != end);
1431             }
1432             _currentIndex = updatedIndex;
1433         }
1434         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1435     }
1436  
1437     /**
1438      * @dev Transfers `tokenId` from `from` to `to`.
1439      *
1440      * Requirements:
1441      *
1442      * - `to` cannot be the zero address.
1443      * - `tokenId` token must be owned by `from`.
1444      *
1445      * Emits a {Transfer} event.
1446      */
1447     function _transfer(
1448         address from,
1449         address to,
1450         uint256 tokenId
1451     ) private {
1452         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1453 
1454         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1455             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1456             getApproved(tokenId) == _msgSender());
1457 
1458         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1459         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1460         if (to == address(0)) revert TransferToZeroAddress();
1461 
1462         _beforeTokenTransfers(from, to, tokenId, 1);
1463 
1464         // Clear approvals from the previous owner
1465         _approve(address(0), tokenId, prevOwnership.addr);
1466 
1467         // Underflow of the sender's balance is impossible because we check for
1468         // ownership above and the recipient's balance can't realistically overflow.
1469         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1470         unchecked {
1471             _addressData[from].balance -= 1;
1472             _addressData[to].balance += 1;
1473 
1474             _ownerships[tokenId].addr = to;
1475             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1476 
1477             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1478             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1479             uint256 nextTokenId = tokenId + 1;
1480             if (_ownerships[nextTokenId].addr == address(0)) {
1481                 // This will suffice for checking _exists(nextTokenId),
1482                 // as a burned slot cannot contain the zero address.
1483                 if (nextTokenId < _currentIndex) {
1484                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1485                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1486                 }
1487             }
1488         }
1489 
1490         emit Transfer(from, to, tokenId);
1491         _afterTokenTransfers(from, to, tokenId, 1);
1492     }
1493 
1494     /**
1495      * @dev Destroys `tokenId`.
1496      * The approval is cleared when the token is burned.
1497      *
1498      * Requirements:
1499      *
1500      * - `tokenId` must exist.
1501      *
1502      * Emits a {Transfer} event.
1503      */
1504     function _burn(uint256 tokenId) internal virtual {
1505         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1506 
1507         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1508 
1509         // Clear approvals from the previous owner
1510         _approve(address(0), tokenId, prevOwnership.addr);
1511 
1512         // Underflow of the sender's balance is impossible because we check for
1513         // ownership above and the recipient's balance can't realistically overflow.
1514         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1515         unchecked {
1516             _addressData[prevOwnership.addr].balance -= 1;
1517             _addressData[prevOwnership.addr].numberBurned += 1;
1518 
1519             // Keep track of who burned the token, and the timestamp of burning.
1520             _ownerships[tokenId].addr = prevOwnership.addr;
1521             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1522             _ownerships[tokenId].burned = true;
1523 
1524             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1525             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1526             uint256 nextTokenId = tokenId + 1;
1527             if (_ownerships[nextTokenId].addr == address(0)) {
1528                 // This will suffice for checking _exists(nextTokenId),
1529                 // as a burned slot cannot contain the zero address.
1530                 if (nextTokenId < _currentIndex) {
1531                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1532                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1533                 }
1534             }
1535         }
1536 
1537         emit Transfer(prevOwnership.addr, address(0), tokenId);
1538         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1539 
1540         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1541         unchecked {
1542             _burnCounter++;
1543         }
1544     }
1545 
1546     /**
1547      * @dev Approve `to` to operate on `tokenId`
1548      *
1549      * Emits a {Approval} event.
1550      */
1551     function _approve(
1552         address to,
1553         uint256 tokenId,
1554         address owner
1555     ) private {
1556         _tokenApprovals[tokenId] = to;
1557         emit Approval(owner, to, tokenId);
1558     }
1559 
1560     /**
1561      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1562      *
1563      * @param from address representing the previous owner of the given token ID
1564      * @param to target address that will receive the tokens
1565      * @param tokenId uint256 ID of the token to be transferred
1566      * @param _data bytes optional data to send along with the call
1567      * @return bool whether the call correctly returned the expected magic value
1568      */
1569     function _checkContractOnERC721Received(
1570         address from,
1571         address to,
1572         uint256 tokenId,
1573         bytes memory _data
1574     ) private returns (bool) {
1575         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1576             return retval == IERC721Receiver(to).onERC721Received.selector;
1577         } catch (bytes memory reason) {
1578             if (reason.length == 0) {
1579                 revert TransferToNonERC721ReceiverImplementer();
1580             } else {
1581                 assembly {
1582                     revert(add(32, reason), mload(reason))
1583                 }
1584             }
1585         }
1586     }
1587 
1588     /**
1589      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1590      * And also called before burning one token.
1591      *
1592      * startTokenId - the first token id to be transferred
1593      * quantity - the amount to be transferred
1594      *
1595      * Calling conditions:
1596      *
1597      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1598      * transferred to `to`.
1599      * - When `from` is zero, `tokenId` will be minted for `to`.
1600      * - When `to` is zero, `tokenId` will be burned by `from`.
1601      * - `from` and `to` are never both zero.
1602      */
1603     function _beforeTokenTransfers(
1604         address from,
1605         address to,
1606         uint256 startTokenId,
1607         uint256 quantity
1608     ) internal virtual {}
1609 
1610     /**
1611      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1612      * minting.
1613      * And also called after one token has been burned.
1614      *
1615      * startTokenId - the first token id to be transferred
1616      * quantity - the amount to be transferred
1617      *
1618      * Calling conditions:
1619      *
1620      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1621      * transferred to `to`.
1622      * - When `from` is zero, `tokenId` has been minted for `to`.
1623      * - When `to` is zero, `tokenId` has been burned by `from`.
1624      * - `from` and `to` are never both zero.
1625      */
1626     function _afterTokenTransfers(
1627         address from,
1628         address to,
1629         uint256 startTokenId,
1630         uint256 quantity
1631     ) internal virtual {}
1632 }
1633 
1634 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
1635 
1636 
1637 // Creator: Chiru Labs
1638 
1639 pragma solidity ^0.8.4;
1640 
1641 
1642 
1643 /**
1644  * @title ERC721A Burnable Token
1645  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1646  */
1647 abstract contract ERC721ABurnable is Context, ERC721A {
1648 
1649     /**
1650      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1651      *
1652      * Requirements:
1653      *
1654      * - The caller must own `tokenId` or be an approved operator.
1655      */
1656     function burn(uint256 tokenId) public virtual {
1657         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1658 
1659         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1660             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1661             getApproved(tokenId) == _msgSender());
1662 
1663         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1664 
1665         _burn(tokenId);
1666     }
1667 }
1668 // File: contracts/MDMA.sol
1669 
1670 
1671 pragma solidity ^0.8.4;
1672 
1673 
1674 
1675 
1676 //AE THER   
1677 
1678 contract MDMA is ERC721A, Ownable, ReentrancyGuard , ERC721ABurnable {
1679 
1680   using Strings for uint256;
1681   uint256 public constant  maxSupply = 3333; 
1682   bytes32 public merkleRoot;
1683   string public  baseUri; 
1684   
1685 
1686   string public extension;
1687   uint256 public cost = 9900000000000000 ;  
1688 
1689   uint256 public maxperaddress = 2; 
1690  
1691   bool public publicEnabled = false;
1692   bool public whitelistMintEnabled = false;
1693   
1694   //mapping ID=>address => number of minted nfts  
1695   mapping(address => uint256) public addresstxs;
1696   
1697   constructor(
1698     string memory _Name,
1699     string memory _Symbol,
1700 	uint256 _maxperaddress,
1701 	bytes32 _merkleRoot,
1702  
1703     string memory _extension
1704   
1705   ) ERC721A(_Name, _Symbol) {
1706 	// deploy the contract with the PWL parameters
1707     
1708 	maxperaddress = _maxperaddress;
1709    
1710     extension = _extension;  
1711     merkleRoot = _merkleRoot;
1712   
1713 	
1714   }
1715   //Modifiers
1716   //resets the amount of nft bought from whitelisted suer if the phase changes
1717       function _startTokenId() internal pure override returns (uint256){
1718     return 1;
1719   }
1720 
1721   //sets the maximum supply of nft that can be minted per phase 
1722   modifier mintCompliance(uint256 _mintAmount) {
1723     require(_totalMinted() + _mintAmount <= maxSupply, 'Max supply in this phase exceeded');  
1724     
1725     _;
1726   }
1727   //enough funds to buy NFTS
1728  
1729 
1730   function Presalemint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable nonReentrant mintCompliance(_mintAmount)  {
1731     // Verify whitelist requirements dont allow mints when public sale starts
1732     require(addresstxs[msg.sender] + _mintAmount <= maxperaddress, "max per address exceeded ");
1733     require(whitelistMintEnabled, "Not in presale phase"); 
1734     //verify not that minting is not paused
1735     
1736     require(MerkleProof.verify(_merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), 'Invalid proof!');
1737     // minting
1738     addresstxs[msg.sender] += _mintAmount;
1739     _safeMint(msg.sender, _mintAmount);
1740     
1741   
1742     
1743   }
1744 
1745 
1746 
1747    function publicMint(uint256 _mintAmount) public payable nonReentrant mintCompliance(_mintAmount)  {
1748     // Verify whitelist requirements dont allow mints when public sale starts
1749     require(_mintAmount > 0 , "invalid mint amount");
1750     require(msg.value >= cost * _mintAmount , "not enough price " );
1751    require(publicEnabled  , 'Still In paused phase'); 
1752     
1753     _safeMint(msg.sender, _mintAmount);
1754     
1755   
1756     
1757   }
1758   //Normal minting allows minting on public sale satisfyign the necessary conditions
1759  
1760 
1761   
1762   
1763   function Airdrop(uint256[] memory  _mintAmount, address[] memory   _receivers) public nonReentrant  onlyOwner {
1764        require(_mintAmount.length == _receivers.length, "Arrays need to be equal and respective");
1765     for(uint i = 0; i < _mintAmount.length;) {
1766         require(_totalMinted() + _mintAmount[i] <= maxSupply, 'Max supply exceeded!');
1767           _safeMint(_receivers[i], _mintAmount[i]);
1768           unchecked{i++;}
1769       }
1770   }
1771 
1772  // get multiple ids that a owner owns  excluding burned tokens  this function is for future off or on chain data gathering 
1773   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1774     uint256 ownerTokenCount = balanceOf(_owner);
1775     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1776     uint256 currentTokenId = _startTokenId();
1777     uint256 ownedTokenIndex = 0;
1778     address latestOwnerAddress;
1779     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= _totalMinted() ) {
1780       TokenOwnership memory ownership = _ownerships[currentTokenId]; 
1781       if (!ownership.burned && ownership.addr != address(0)) {
1782         latestOwnerAddress = ownership.addr; 
1783       }
1784       if (latestOwnerAddress == _owner &&  !ownership.burned )  {
1785         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1786         ownedTokenIndex++;
1787       }
1788       currentTokenId++;
1789     }
1790     return ownedTokenIds;
1791   }
1792 
1793   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1794     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1795    
1796     return bytes(baseUri).length > 0 ? string(abi.encodePacked(baseUri, _tokenId.toString(), extension)) : '';
1797   }
1798 
1799 // SETTERS DONE BY OWNER ONLY
1800 
1801  function setWLphase(uint256 _maxperaddress, bytes32 _merkleRoot) public onlyOwner {
1802 setMaxPerAddress( _maxperaddress);
1803 setMerkleRoot(_merkleRoot);
1804  }
1805   
1806 
1807      
1808   function setCost(uint256 _cost) public onlyOwner nonReentrant {
1809     cost = _cost;
1810   } 
1811 
1812   function setMaxPerAddress(uint256 _maxperaddress) public onlyOwner nonReentrant {
1813 	maxperaddress = _maxperaddress;
1814   }
1815   
1816  
1817 
1818   function setUri(string memory _uri) public onlyOwner nonReentrant {
1819     baseUri = _uri;
1820   }
1821   // should be set before any minting starts 
1822   function setpublicEnabled (bool choice) public onlyOwner nonReentrant { 
1823     publicEnabled = choice;
1824   }
1825  
1826   function setwlEnabled(bool choice) public onlyOwner nonReentrant { 
1827     whitelistMintEnabled = choice;
1828   }
1829  
1830   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner nonReentrant {
1831     merkleRoot = _merkleRoot;
1832   }
1833 
1834  
1835  
1836      // release address based on shares.
1837    function withdrawEth() external onlyOwner nonReentrant {
1838     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1839     require(success, "Transfer failed.");
1840   }
1841 }