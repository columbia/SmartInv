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
13     /**
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
716 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
717 
718 
719 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
720 
721 pragma solidity ^0.8.0;
722 
723 /**
724  * @title ERC721 token receiver interface
725  * @dev Interface for any contract that wants to support safeTransfers
726  * from ERC721 asset contracts.
727  */
728 interface IERC721Receiver {
729     /**
730      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
731      * by `operator` from `from`, this function is called.
732      *
733      * It must return its Solidity selector to confirm the token transfer.
734      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
735      *
736      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
737      */
738     function onERC721Received(
739         address operator,
740         address from,
741         uint256 tokenId,
742         bytes calldata data
743     ) external returns (bytes4);
744 }
745 
746 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
747 
748 
749 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
750 
751 pragma solidity ^0.8.0;
752 
753 /**
754  * @dev Interface of the ERC165 standard, as defined in the
755  * https://eips.ethereum.org/EIPS/eip-165[EIP].
756  *
757  * Implementers can declare support of contract interfaces, which can then be
758  * queried by others ({ERC165Checker}).
759  *
760  * For an implementation, see {ERC165}.
761  */
762 interface IERC165 {
763     /**
764      * @dev Returns true if this contract implements the interface defined by
765      * `interfaceId`. See the corresponding
766      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
767      * to learn more about how these ids are created.
768      *
769      * This function call must use less than 30 000 gas.
770      */
771     function supportsInterface(bytes4 interfaceId) external view returns (bool);
772 }
773 
774 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
775 
776 
777 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
778 
779 pragma solidity ^0.8.0;
780 
781 
782 /**
783  * @dev Implementation of the {IERC165} interface.
784  *
785  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
786  * for the additional interface id that will be supported. For example:
787  *
788  * ```solidity
789  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
790  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
791  * }
792  * ```
793  *
794  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
795  */
796 abstract contract ERC165 is IERC165 {
797     /**
798      * @dev See {IERC165-supportsInterface}.
799      */
800     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
801         return interfaceId == type(IERC165).interfaceId;
802     }
803 }
804 
805 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
806 
807 
808 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
809 
810 pragma solidity ^0.8.0;
811 
812 
813 /**
814  * @dev Required interface of an ERC721 compliant contract.
815  */
816 interface IERC721 is IERC165 {
817     /**
818      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
819      */
820     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
821 
822     /**
823      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
824      */
825     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
826 
827     /**
828      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
829      */
830     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
831 
832     /**
833      * @dev Returns the number of tokens in ``owner``'s account.
834      */
835     function balanceOf(address owner) external view returns (uint256 balance);
836 
837     /**
838      * @dev Returns the owner of the `tokenId` token.
839      *
840      * Requirements:
841      *
842      * - `tokenId` must exist.
843      */
844     function ownerOf(uint256 tokenId) external view returns (address owner);
845 
846     /**
847      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
848      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
849      *
850      * Requirements:
851      *
852      * - `from` cannot be the zero address.
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must exist and be owned by `from`.
855      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
856      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
857      *
858      * Emits a {Transfer} event.
859      */
860     function safeTransferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) external;
865 
866     /**
867      * @dev Transfers `tokenId` token from `from` to `to`.
868      *
869      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
870      *
871      * Requirements:
872      *
873      * - `from` cannot be the zero address.
874      * - `to` cannot be the zero address.
875      * - `tokenId` token must be owned by `from`.
876      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
877      *
878      * Emits a {Transfer} event.
879      */
880     function transferFrom(
881         address from,
882         address to,
883         uint256 tokenId
884     ) external;
885 
886     /**
887      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
888      * The approval is cleared when the token is transferred.
889      *
890      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
891      *
892      * Requirements:
893      *
894      * - The caller must own the token or be an approved operator.
895      * - `tokenId` must exist.
896      *
897      * Emits an {Approval} event.
898      */
899     function approve(address to, uint256 tokenId) external;
900 
901     /**
902      * @dev Returns the account approved for `tokenId` token.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must exist.
907      */
908     function getApproved(uint256 tokenId) external view returns (address operator);
909 
910     /**
911      * @dev Approve or remove `operator` as an operator for the caller.
912      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
913      *
914      * Requirements:
915      *
916      * - The `operator` cannot be the caller.
917      *
918      * Emits an {ApprovalForAll} event.
919      */
920     function setApprovalForAll(address operator, bool _approved) external;
921 
922     /**
923      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
924      *
925      * See {setApprovalForAll}
926      */
927     function isApprovedForAll(address owner, address operator) external view returns (bool);
928 
929     /**
930      * @dev Safely transfers `tokenId` token from `from` to `to`.
931      *
932      * Requirements:
933      *
934      * - `from` cannot be the zero address.
935      * - `to` cannot be the zero address.
936      * - `tokenId` token must exist and be owned by `from`.
937      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
938      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
939      *
940      * Emits a {Transfer} event.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes calldata data
947     ) external;
948 }
949 
950 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
951 
952 
953 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
954 
955 pragma solidity ^0.8.0;
956 
957 
958 /**
959  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
960  * @dev See https://eips.ethereum.org/EIPS/eip-721
961  */
962 interface IERC721Enumerable is IERC721 {
963     /**
964      * @dev Returns the total amount of tokens stored by the contract.
965      */
966     function totalSupply() external view returns (uint256);
967 
968     /**
969      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
970      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
971      */
972     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
973 
974     /**
975      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
976      * Use along with {totalSupply} to enumerate all tokens.
977      */
978     function tokenByIndex(uint256 index) external view returns (uint256);
979 }
980 
981 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
982 
983 
984 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
985 
986 pragma solidity ^0.8.0;
987 
988 
989 /**
990  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
991  * @dev See https://eips.ethereum.org/EIPS/eip-721
992  */
993 interface IERC721Metadata is IERC721 {
994     /**
995      * @dev Returns the token collection name.
996      */
997     function name() external view returns (string memory);
998 
999     /**
1000      * @dev Returns the token collection symbol.
1001      */
1002     function symbol() external view returns (string memory);
1003 
1004     /**
1005      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1006      */
1007     function tokenURI(uint256 tokenId) external view returns (string memory);
1008 }
1009 
1010 // File: erc721a/contracts/ERC721A.sol
1011 
1012 
1013 // Creator: Chiru Labs
1014 
1015 pragma solidity ^0.8.4;
1016 
1017 
1018 
1019 
1020 
1021 
1022 
1023 
1024 
1025 error ApprovalCallerNotOwnerNorApproved();
1026 error ApprovalQueryForNonexistentToken();
1027 error ApproveToCaller();
1028 error ApprovalToCurrentOwner();
1029 error BalanceQueryForZeroAddress();
1030 error MintedQueryForZeroAddress();
1031 error BurnedQueryForZeroAddress();
1032 error AuxQueryForZeroAddress();
1033 error MintToZeroAddress();
1034 error MintZeroQuantity();
1035 error OwnerIndexOutOfBounds();
1036 error OwnerQueryForNonexistentToken();
1037 error TokenIndexOutOfBounds();
1038 error TransferCallerNotOwnerNorApproved();
1039 error TransferFromIncorrectOwner();
1040 error TransferToNonERC721ReceiverImplementer();
1041 error TransferToZeroAddress();
1042 error URIQueryForNonexistentToken();
1043 
1044 /**
1045  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1046  * the Metadata extension. Built to optimize for lower gas during batch mints.
1047  *
1048  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1049  *
1050  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1051  *
1052  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1053  */
1054 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1055     using Address for address;
1056     using Strings for uint256;
1057 
1058     // Compiler will pack this into a single 256bit word.
1059     struct TokenOwnership {
1060         // The address of the owner.
1061         address addr;
1062         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1063         uint64 startTimestamp;
1064         // Whether the token has been burned.
1065         bool burned;
1066     }
1067 
1068     // Compiler will pack this into a single 256bit word.
1069     struct AddressData {
1070         // Realistically, 2**64-1 is more than enough.
1071         uint64 balance;
1072         // Keeps track of mint count with minimal overhead for tokenomics.
1073         uint64 numberMinted;
1074         // Keeps track of burn count with minimal overhead for tokenomics.
1075         uint64 numberBurned;
1076         // For miscellaneous variable(s) pertaining to the address
1077         // (e.g. number of whitelist mint slots used).
1078         // If there are multiple variables, please pack them into a uint64.
1079         uint64 aux;
1080     }
1081 
1082     // The tokenId of the next token to be minted.
1083     uint256 internal _currentIndex;
1084 
1085     // The number of tokens burned.
1086     uint256 internal _burnCounter;
1087 
1088     // Token name
1089     string private _name;
1090 
1091     // Token symbol
1092     string private _symbol;
1093 
1094     // Mapping from token ID to ownership details
1095     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1096     mapping(uint256 => TokenOwnership) internal _ownerships;
1097 
1098     // Mapping owner address to address data
1099     mapping(address => AddressData) private _addressData;
1100 
1101     // Mapping from token ID to approved address
1102     mapping(uint256 => address) private _tokenApprovals;
1103 
1104     // Mapping from owner to operator approvals
1105     mapping(address => mapping(address => bool)) private _operatorApprovals;
1106 
1107     constructor(string memory name_, string memory symbol_) {
1108         _name = name_;
1109         _symbol = symbol_;
1110         _currentIndex = _startTokenId();
1111     }
1112 
1113     /**
1114      * To change the starting tokenId, please override this function.
1115      */
1116     function _startTokenId() internal view virtual returns (uint256) {
1117         return 0;
1118     }
1119 
1120     /**
1121      * @dev See {IERC721Enumerable-totalSupply}.
1122      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1123      */
1124     function totalSupply() public view returns (uint256) {
1125         // Counter underflow is impossible as _burnCounter cannot be incremented
1126         // more than _currentIndex - _startTokenId() times
1127         unchecked {
1128             return _currentIndex - _burnCounter - _startTokenId();
1129         }
1130     }
1131 
1132     /**
1133      * Returns the total amount of tokens minted in the contract.
1134      */
1135     function _totalMinted() internal view returns (uint256) {
1136         // Counter underflow is impossible as _currentIndex does not decrement,
1137         // and it is initialized to _startTokenId()
1138         unchecked {
1139             return _currentIndex - _startTokenId();
1140         }
1141     }
1142 
1143     /**
1144      * @dev See {IERC165-supportsInterface}.
1145      */
1146     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1147         return
1148             interfaceId == type(IERC721).interfaceId ||
1149             interfaceId == type(IERC721Metadata).interfaceId ||
1150             super.supportsInterface(interfaceId);
1151     }
1152 
1153     /**
1154      * @dev See {IERC721-balanceOf}.
1155      */
1156     function balanceOf(address owner) public view override returns (uint256) {
1157         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1158         return uint256(_addressData[owner].balance);
1159     }
1160 
1161     /**
1162      * Returns the number of tokens minted by `owner`.
1163      */
1164     function _numberMinted(address owner) internal view returns (uint256) {
1165         if (owner == address(0)) revert MintedQueryForZeroAddress();
1166         return uint256(_addressData[owner].numberMinted);
1167     }
1168 
1169     /**
1170      * Returns the number of tokens burned by or on behalf of `owner`.
1171      */
1172     function _numberBurned(address owner) internal view returns (uint256) {
1173         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1174         return uint256(_addressData[owner].numberBurned);
1175     }
1176 
1177     /**
1178      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1179      */
1180     function _getAux(address owner) internal view returns (uint64) {
1181         if (owner == address(0)) revert AuxQueryForZeroAddress();
1182         return _addressData[owner].aux;
1183     }
1184 
1185     /**
1186      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1187      * If there are multiple variables, please pack them into a uint64.
1188      */
1189     function _setAux(address owner, uint64 aux) internal {
1190         if (owner == address(0)) revert AuxQueryForZeroAddress();
1191         _addressData[owner].aux = aux;
1192     }
1193 
1194     /**
1195      * Gas spent here starts off proportional to the maximum mint batch size.
1196      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1197      */
1198     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1199         uint256 curr = tokenId;
1200 
1201         unchecked {
1202             if (_startTokenId() <= curr && curr < _currentIndex) {
1203                 TokenOwnership memory ownership = _ownerships[curr];
1204                 if (!ownership.burned) {
1205                     if (ownership.addr != address(0)) {
1206                         return ownership;
1207                     }
1208                     // Invariant:
1209                     // There will always be an ownership that has an address and is not burned
1210                     // before an ownership that does not have an address and is not burned.
1211                     // Hence, curr will not underflow.
1212                     while (true) {
1213                         curr--;
1214                         ownership = _ownerships[curr];
1215                         if (ownership.addr != address(0)) {
1216                             return ownership;
1217                         }
1218                     }
1219                 }
1220             }
1221         }
1222         revert OwnerQueryForNonexistentToken();
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-ownerOf}.
1227      */
1228     function ownerOf(uint256 tokenId) public view override returns (address) {
1229         return ownershipOf(tokenId).addr;
1230     }
1231 
1232     /**
1233      * @dev See {IERC721Metadata-name}.
1234      */
1235     function name() public view virtual override returns (string memory) {
1236         return _name;
1237     }
1238 
1239     /**
1240      * @dev See {IERC721Metadata-symbol}.
1241      */
1242     function symbol() public view virtual override returns (string memory) {
1243         return _symbol;
1244     }
1245 
1246     /**
1247      * @dev See {IERC721Metadata-tokenURI}.
1248      */
1249     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1250         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1251 
1252         string memory baseURI = _baseURI();
1253         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1254     }
1255 
1256     /**
1257      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1258      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1259      * by default, can be overriden in child contracts.
1260      */
1261     function _baseURI() internal view virtual returns (string memory) {
1262         return '';
1263     }
1264 
1265     /**
1266      * @dev See {IERC721-approve}.
1267      */
1268     function approve(address to, uint256 tokenId) public override {
1269         address owner = ERC721A.ownerOf(tokenId);
1270         if (to == owner) revert ApprovalToCurrentOwner();
1271 
1272         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1273             revert ApprovalCallerNotOwnerNorApproved();
1274         }
1275 
1276         _approve(to, tokenId, owner);
1277     }
1278 
1279     /**
1280      * @dev See {IERC721-getApproved}.
1281      */
1282     function getApproved(uint256 tokenId) public view override returns (address) {
1283         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1284 
1285         return _tokenApprovals[tokenId];
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-setApprovalForAll}.
1290      */
1291     function setApprovalForAll(address operator, bool approved) public override {
1292         if (operator == _msgSender()) revert ApproveToCaller();
1293 
1294         _operatorApprovals[_msgSender()][operator] = approved;
1295         emit ApprovalForAll(_msgSender(), operator, approved);
1296     }
1297 
1298     /**
1299      * @dev See {IERC721-isApprovedForAll}.
1300      */
1301     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1302         return _operatorApprovals[owner][operator];
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-transferFrom}.
1307      */
1308     function transferFrom(
1309         address from,
1310         address to,
1311         uint256 tokenId
1312     ) public virtual override {
1313         _transfer(from, to, tokenId);
1314     }
1315 
1316     /**
1317      * @dev See {IERC721-safeTransferFrom}.
1318      */
1319     function safeTransferFrom(
1320         address from,
1321         address to,
1322         uint256 tokenId
1323     ) public virtual override {
1324         safeTransferFrom(from, to, tokenId, '');
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-safeTransferFrom}.
1329      */
1330     function safeTransferFrom(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) public virtual override {
1336         _transfer(from, to, tokenId);
1337         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1338             revert TransferToNonERC721ReceiverImplementer();
1339         }
1340     }
1341 
1342     /**
1343      * @dev Returns whether `tokenId` exists.
1344      *
1345      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1346      *
1347      * Tokens start existing when they are minted (`_mint`),
1348      */
1349     function _exists(uint256 tokenId) internal view returns (bool) {
1350         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1351             !_ownerships[tokenId].burned;
1352     }
1353 
1354     function _safeMint(address to, uint256 quantity) internal {
1355         _safeMint(to, quantity, '');
1356     }
1357 
1358     /**
1359      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1360      *
1361      * Requirements:
1362      *
1363      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1364      * - `quantity` must be greater than 0.
1365      *
1366      * Emits a {Transfer} event.
1367      */
1368     function _safeMint(
1369         address to,
1370         uint256 quantity,
1371         bytes memory _data
1372     ) internal {
1373         _mint(to, quantity, _data, true);
1374     }
1375 
1376     /**
1377      * @dev Mints `quantity` tokens and transfers them to `to`.
1378      *
1379      * Requirements:
1380      *
1381      * - `to` cannot be the zero address.
1382      * - `quantity` must be greater than 0.
1383      *
1384      * Emits a {Transfer} event.
1385      */
1386     function _mint(
1387         address to,
1388         uint256 quantity,
1389         bytes memory _data,
1390         bool safe
1391     ) internal {
1392         uint256 startTokenId = _currentIndex;
1393         if (to == address(0)) revert MintToZeroAddress();
1394         if (quantity == 0) revert MintZeroQuantity();
1395 
1396         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1397 
1398         // Overflows are incredibly unrealistic.
1399         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1400         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1401         unchecked {
1402             _addressData[to].balance += uint64(quantity);
1403             _addressData[to].numberMinted += uint64(quantity);
1404 
1405             _ownerships[startTokenId].addr = to;
1406             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1407 
1408             uint256 updatedIndex = startTokenId;
1409             uint256 end = updatedIndex + quantity;
1410 
1411             if (safe && to.isContract()) {
1412                 do {
1413                     emit Transfer(address(0), to, updatedIndex);
1414                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1415                         revert TransferToNonERC721ReceiverImplementer();
1416                     }
1417                 } while (updatedIndex != end);
1418                 // Reentrancy protection
1419                 if (_currentIndex != startTokenId) revert();
1420             } else {
1421                 do {
1422                     emit Transfer(address(0), to, updatedIndex++);
1423                 } while (updatedIndex != end);
1424             }
1425             _currentIndex = updatedIndex;
1426         }
1427         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1428     }
1429  
1430     /**
1431      * @dev Transfers `tokenId` from `from` to `to`.
1432      *
1433      * Requirements:
1434      *
1435      * - `to` cannot be the zero address.
1436      * - `tokenId` token must be owned by `from`.
1437      *
1438      * Emits a {Transfer} event.
1439      */
1440     function _transfer(
1441         address from,
1442         address to,
1443         uint256 tokenId
1444     ) private {
1445         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1446 
1447         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1448             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1449             getApproved(tokenId) == _msgSender());
1450 
1451         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1452         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1453         if (to == address(0)) revert TransferToZeroAddress();
1454 
1455         _beforeTokenTransfers(from, to, tokenId, 1);
1456 
1457         // Clear approvals from the previous owner
1458         _approve(address(0), tokenId, prevOwnership.addr);
1459 
1460         // Underflow of the sender's balance is impossible because we check for
1461         // ownership above and the recipient's balance can't realistically overflow.
1462         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1463         unchecked {
1464             _addressData[from].balance -= 1;
1465             _addressData[to].balance += 1;
1466 
1467             _ownerships[tokenId].addr = to;
1468             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1469 
1470             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1471             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1472             uint256 nextTokenId = tokenId + 1;
1473             if (_ownerships[nextTokenId].addr == address(0)) {
1474                 // This will suffice for checking _exists(nextTokenId),
1475                 // as a burned slot cannot contain the zero address.
1476                 if (nextTokenId < _currentIndex) {
1477                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1478                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1479                 }
1480             }
1481         }
1482 
1483         emit Transfer(from, to, tokenId);
1484         _afterTokenTransfers(from, to, tokenId, 1);
1485     }
1486 
1487     /**
1488      * @dev Destroys `tokenId`.
1489      * The approval is cleared when the token is burned.
1490      *
1491      * Requirements:
1492      *
1493      * - `tokenId` must exist.
1494      *
1495      * Emits a {Transfer} event.
1496      */
1497     function _burn(uint256 tokenId) internal virtual {
1498         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1499 
1500         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1501 
1502         // Clear approvals from the previous owner
1503         _approve(address(0), tokenId, prevOwnership.addr);
1504 
1505         // Underflow of the sender's balance is impossible because we check for
1506         // ownership above and the recipient's balance can't realistically overflow.
1507         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1508         unchecked {
1509             _addressData[prevOwnership.addr].balance -= 1;
1510             _addressData[prevOwnership.addr].numberBurned += 1;
1511 
1512             // Keep track of who burned the token, and the timestamp of burning.
1513             _ownerships[tokenId].addr = prevOwnership.addr;
1514             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1515             _ownerships[tokenId].burned = true;
1516 
1517             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1518             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1519             uint256 nextTokenId = tokenId + 1;
1520             if (_ownerships[nextTokenId].addr == address(0)) {
1521                 // This will suffice for checking _exists(nextTokenId),
1522                 // as a burned slot cannot contain the zero address.
1523                 if (nextTokenId < _currentIndex) {
1524                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1525                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1526                 }
1527             }
1528         }
1529 
1530         emit Transfer(prevOwnership.addr, address(0), tokenId);
1531         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1532 
1533         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1534         unchecked {
1535             _burnCounter++;
1536         }
1537     }
1538 
1539     /**
1540      * @dev Approve `to` to operate on `tokenId`
1541      *
1542      * Emits a {Approval} event.
1543      */
1544     function _approve(
1545         address to,
1546         uint256 tokenId,
1547         address owner
1548     ) private {
1549         _tokenApprovals[tokenId] = to;
1550         emit Approval(owner, to, tokenId);
1551     }
1552 
1553     /**
1554      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1555      *
1556      * @param from address representing the previous owner of the given token ID
1557      * @param to target address that will receive the tokens
1558      * @param tokenId uint256 ID of the token to be transferred
1559      * @param _data bytes optional data to send along with the call
1560      * @return bool whether the call correctly returned the expected magic value
1561      */
1562     function _checkContractOnERC721Received(
1563         address from,
1564         address to,
1565         uint256 tokenId,
1566         bytes memory _data
1567     ) private returns (bool) {
1568         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1569             return retval == IERC721Receiver(to).onERC721Received.selector;
1570         } catch (bytes memory reason) {
1571             if (reason.length == 0) {
1572                 revert TransferToNonERC721ReceiverImplementer();
1573             } else {
1574                 assembly {
1575                     revert(add(32, reason), mload(reason))
1576                 }
1577             }
1578         }
1579     }
1580 
1581     /**
1582      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1583      * And also called before burning one token.
1584      *
1585      * startTokenId - the first token id to be transferred
1586      * quantity - the amount to be transferred
1587      *
1588      * Calling conditions:
1589      *
1590      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1591      * transferred to `to`.
1592      * - When `from` is zero, `tokenId` will be minted for `to`.
1593      * - When `to` is zero, `tokenId` will be burned by `from`.
1594      * - `from` and `to` are never both zero.
1595      */
1596     function _beforeTokenTransfers(
1597         address from,
1598         address to,
1599         uint256 startTokenId,
1600         uint256 quantity
1601     ) internal virtual {}
1602 
1603     /**
1604      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1605      * minting.
1606      * And also called after one token has been burned.
1607      *
1608      * startTokenId - the first token id to be transferred
1609      * quantity - the amount to be transferred
1610      *
1611      * Calling conditions:
1612      *
1613      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1614      * transferred to `to`.
1615      * - When `from` is zero, `tokenId` has been minted for `to`.
1616      * - When `to` is zero, `tokenId` has been burned by `from`.
1617      * - `from` and `to` are never both zero.
1618      */
1619     function _afterTokenTransfers(
1620         address from,
1621         address to,
1622         uint256 startTokenId,
1623         uint256 quantity
1624     ) internal virtual {}
1625 }
1626 
1627 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
1628 
1629 
1630 // Creator: Chiru Labs
1631 
1632 pragma solidity ^0.8.4;
1633 
1634 
1635 
1636 /**
1637  * @title ERC721A Burnable Token
1638  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1639  */
1640 abstract contract ERC721ABurnable is Context, ERC721A {
1641 
1642     /**
1643      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1644      *
1645      * Requirements:
1646      *
1647      * - The caller must own `tokenId` or be an approved operator.
1648      */
1649     function burn(uint256 tokenId) public virtual {
1650         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1651 
1652         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1653             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1654             getApproved(tokenId) == _msgSender());
1655 
1656         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1657 
1658         _burn(tokenId);
1659     }
1660 }
1661 // File: contracts/Element.sol
1662 
1663 
1664 pragma solidity ^0.8.4;
1665 
1666 
1667 
1668 
1669 //AE THER   
1670 
1671 contract LegionX  is ERC721A, Ownable, ReentrancyGuard , ERC721ABurnable {
1672 
1673   using Strings for uint256;
1674   uint256 public constant  maxSupply = 7070; 
1675   bytes32 public merkleRoot;
1676   string public  baseUri; 
1677   // base uri is public since it will remain unset until reveal 
1678   string public  obscurumuri;
1679   string constant  public provenance = "08fe1a985744ad03cb27f0a806f6a333dc1eb5167ae7e741ebba0a8fc503ed18"; 
1680   uint256 public cost;  
1681   uint256 public whitelistTag = 0;
1682 
1683     // max per address in premium whitelisting 
1684   uint256 public maxperaddress; 
1685   uint256 public limitTokens = 500; 
1686   
1687 
1688 
1689   //  @dev starting index of NFT file sequence ensuring randomness     
1690   uint256 public startingIndex;
1691   bool public paused = true;
1692   bool public whitelistMintEnabled = true;
1693   bool public revealed = false;
1694 
1695   mapping(uint256 => mapping(address => uint256)) public addresstxs;
1696   
1697   constructor(
1698     string memory _tokenName,
1699     string memory _tokenSymbol,
1700     uint256 _cost,
1701 	uint256 _maxperaddress,
1702 	
1703 	bytes32 _merkleRoot,
1704     string memory _obscurumUri
1705   ) ERC721A(_tokenName, _tokenSymbol){
1706 	// deploy the contract with the PWL parameters
1707     cost = _cost;
1708 	maxperaddress = _maxperaddress;
1709     obscurumuri = _obscurumUri;
1710     merkleRoot = _merkleRoot; //provide a default merkle root of owner before contract unpause
1711 	
1712 
1713   }
1714     
1715     
1716 
1717   modifier mintCompliance(uint256 _mintAmount) {
1718   
1719     require(_totalMinted() + _mintAmount <= limitTokens, 'Max supply exceeded!'); // use total minted since at burn total supply decrements 
1720     _;
1721   }
1722     
1723   modifier mintPriceCompliance(uint256 _mintAmount) {
1724     require(msg.value == cost * _mintAmount, 'Incorrect amount ');
1725     _;
1726   }
1727 
1728 
1729   function setWhitelistPhase(uint256 _cost, bytes32 _merkleRoot, uint256 _maxperaddress) external onlyOwner {
1730       cost = _cost;
1731 	  merkleRoot = _merkleRoot;
1732 	  maxperaddress = _maxperaddress;
1733 	  whitelistTag = 1;
1734 	  limitTokens = maxSupply;
1735 	  paused = true;
1736   }
1737   
1738     function setPublicSalePhase(uint256 _cost) external onlyOwner {
1739       cost = _cost;
1740 	  whitelistMintEnabled = false;
1741       limitTokens = maxSupply;
1742 	  paused = true;
1743   }
1744 
1745   function Presalemint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) nonReentrant mintPriceCompliance(_mintAmount) {
1746     // Verify whitelist requirements dont allow mints when public sale starts
1747     require(whitelistMintEnabled, "Not in presale phase");
1748     require(!paused  , 'Presale is paused');
1749     require(addresstxs[whitelistTag][msg.sender] + _mintAmount <= maxperaddress, 'wallet limit exceeded ');
1750     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1751     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1752 
1753    
1754   
1755     _safeMint(msg.sender, _mintAmount);
1756     addresstxs[whitelistTag][msg.sender] += _mintAmount;
1757 
1758   
1759   }
1760 
1761   function mint(uint256 _mintAmount) public payable  nonReentrant mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1762     require(!paused, 'Minting is paused');
1763     require(!whitelistMintEnabled, "Not in public sale phase");
1764 	
1765     _safeMint(msg.sender, _mintAmount);
1766 
1767   } 
1768   
1769     // airdrop 
1770   function Airdrop(uint256[] memory  _mintAmount, address[] memory   _receivers) public nonReentrant  onlyOwner {
1771       require(_mintAmount.length == _receivers.length, "Arrays need to be equal and respective");
1772 
1773     
1774    for(uint i = 0; i < _mintAmount.length; i++ ) {
1775           require(_totalMinted() + _mintAmount[i] <= maxSupply, 'Max supply exceeded!');
1776           _safeMint(_receivers[i], _mintAmount[i]);
1777       }
1778     
1779   }
1780 
1781 
1782  
1783  // get multiple ids that a owner owns  excluding burned tokens  this function is for future off or on chain data gathering 
1784   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1785     uint256 ownerTokenCount = balanceOf(_owner);
1786     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1787     uint256 currentTokenId = _startTokenId();
1788     uint256 ownedTokenIndex = 0;
1789     address latestOwnerAddress;
1790 
1791     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= _totalMinted() ) {
1792       TokenOwnership memory ownership = _ownerships[currentTokenId];
1793        
1794       if (!ownership.burned && ownership.addr != address(0)) {
1795         latestOwnerAddress = ownership.addr; 
1796       }
1797 
1798       if (latestOwnerAddress == _owner &&  !ownership.burned )  {
1799         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1800 
1801         ownedTokenIndex++;
1802       }
1803 
1804       currentTokenId++;
1805     }
1806 
1807     return ownedTokenIds;
1808   }
1809 
1810    function _startTokenId() internal pure override returns (uint256){
1811     return 1;
1812   }
1813 
1814   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1815     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1816 
1817     if (revealed == false) {
1818       return obscurumuri;
1819     }
1820 
1821     string memory currentBaseURI = baseUri;
1822     return bytes(currentBaseURI).length > 0
1823         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1824         : '';
1825   }
1826   // function set revealed once invoked will be final 
1827   function setRevealed() public onlyOwner  nonReentrant {
1828     revealed = true;
1829   }
1830      // function set cost is variable (notify me if you need it to be immutable) however it needs to stay variable due to possibly OG buying at different price
1831   function setCost(uint256 _cost) public onlyOwner nonReentrant {
1832     cost = _cost;
1833   } 
1834   // setting maximum of nfts per wallet address
1835   function setMaxPerAddress(uint256 _maxperaddress) public onlyOwner nonReentrant {
1836 	maxperaddress = _maxperaddress;
1837   }
1838   
1839  //no problem keaping a revealed image mutable in this case 
1840   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner nonReentrant {
1841     obscurumuri = _hiddenMetadataUri;
1842   }
1843 
1844   function setUri(string memory _uri) public onlyOwner nonReentrant {
1845     baseUri = _uri;
1846   }
1847   // locking provenance once set (should be set before any minting starts ) 
1848 
1849 
1850 
1851   
1852   
1853   function setPaused(bool choice) public onlyOwner nonReentrant {
1854       
1855     paused = choice;
1856   }
1857  // for OG and whitelisting  merkle root  enabling whitelist 
1858   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner nonReentrant {
1859     merkleRoot = _merkleRoot;
1860   }
1861 
1862   
1863 
1864     /**
1865     
1866      * setting starting index for the collection. Pseudo - Random number between index and max supply  using unpredictable values of the block 
1867      */
1868     function setStartingIndex() public  nonReentrant onlyOwner {
1869         require(startingIndex == 0, "Starting index is already set");
1870         
1871          startingIndex = uint256(keccak256(abi.encodePacked( 
1872             block.timestamp + block.difficulty + block.gaslimit + block.number +
1873             uint256(keccak256(abi.encodePacked(block.coinbase))) / block.timestamp
1874         ))) % maxSupply;
1875 
1876     }
1877 
1878   function withdrawEth() external onlyOwner nonReentrant {
1879     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1880     require(success, "Transfer failed.");
1881   }
1882   
1883 }