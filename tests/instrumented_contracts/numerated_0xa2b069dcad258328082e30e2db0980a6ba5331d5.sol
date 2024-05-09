1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 // █████╗ ██╗    ███████╗██████╗ ███████╗███╗   ██╗███████╗
5 //██╔══██╗██║    ██╔════╝██╔══██╗██╔════╝████╗  ██║╚══███╔╝
6 //███████║██║    █████╗  ██████╔╝█████╗  ██╔██╗ ██║  ███╔╝ 
7 //██╔══██║██║    ██╔══╝  ██╔══██╗██╔══╝  ██║╚██╗██║ ███╔╝  
8 //██║  ██║██║    ██║     ██║  ██║███████╗██║ ╚████║███████╗
9 //╚═╝  ╚═╝╚═╝    ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚══════╝
10                                                          
11 
12 
13 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Contract module that helps prevent reentrant calls to a function.
19  *
20  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
21  * available, which can be applied to functions to make sure there are no nested
22  * (reentrant) calls to them.
23  *
24  * Note that because there is a single `nonReentrant` guard, functions marked as
25  * `nonReentrant` may not call one another. This can be worked around by making
26  * those functions `private`, and then adding `external` `nonReentrant` entry
27  * points to them.
28  *
29  * TIP: If you would like to learn more about reentrancy and alternative ways
30  * to protect against it, check out our blog post
31  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
32  */
33 abstract contract ReentrancyGuard {
34     // Booleans are more expensive than uint256 or any type that takes up a full
35     // word because each write operation emits an extra SLOAD to first read the
36     // slot's contents, replace the bits taken up by the boolean, and then write
37     // back. This is the compiler's defense against contract upgrades and
38     // pointer aliasing, and it cannot be disabled.
39 
40     // The values being non-zero value makes deployment a bit more expensive,
41     // but in exchange the refund on every call to nonReentrant will be lower in
42     // amount. Since refunds are capped to a percentage of the total
43     // transaction's gas, it is best to keep them low in cases like this one, to
44     // increase the likelihood of the full refund coming into effect.
45     uint256 private constant _NOT_ENTERED = 1;
46     uint256 private constant _ENTERED = 2;
47 
48     uint256 private _status;
49 
50     constructor() {
51         _status = _NOT_ENTERED;
52     }
53 
54     /**
55      * @dev Prevents a contract from calling itself, directly or indirectly.
56      * Calling a `nonReentrant` function from another `nonReentrant`
57      * function is not supported. It is possible to prevent this from happening
58      * by making the `nonReentrant` function external, and making it call a
59      * `private` function that does the actual work.
60      */
61     modifier nonReentrant() {
62         // On the first call to nonReentrant, _notEntered will be true
63         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
64 
65         // Any calls to nonReentrant after this point will fail
66         _status = _ENTERED;
67 
68         _;
69 
70         // By storing the original value once again, a refund is triggered (see
71         // https://eips.ethereum.org/EIPS/eip-2200)
72         _status = _NOT_ENTERED;
73     }
74 }
75 
76 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
77 
78 
79 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Interface of the ERC20 standard as defined in the EIP.
85  */
86 interface IERC20 {
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 
101     /**
102      * @dev Returns the amount of tokens in existence.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     /**
107      * @dev Returns the amount of tokens owned by `account`.
108      */
109     function balanceOf(address account) external view returns (uint256);
110 
111     /**
112      * @dev Moves `amount` tokens from the caller's account to `to`.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transfer(address to, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Returns the remaining number of tokens that `spender` will be
122      * allowed to spend on behalf of `owner` through {transferFrom}. This is
123      * zero by default.
124      *
125      * This value changes when {approve} or {transferFrom} are called.
126      */
127     function allowance(address owner, address spender) external view returns (uint256);
128 
129     /**
130      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * IMPORTANT: Beware that changing an allowance with this method brings the risk
135      * that someone may use both the old and the new allowance by unfortunate
136      * transaction ordering. One possible solution to mitigate this race
137      * condition is to first reduce the spender's allowance to 0 and set the
138      * desired value afterwards:
139      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address spender, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Moves `amount` tokens from `from` to `to` using the
147      * allowance mechanism. `amount` is then deducted from the caller's
148      * allowance.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transferFrom(
155         address from,
156         address to,
157         uint256 amount
158     ) external returns (bool);
159 }
160 
161 // File: @openzeppelin/contracts/utils/Counters.sol
162 
163 
164 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
165 
166 pragma solidity ^0.8.0;
167 
168 /**
169  * @title Counters
170  * @author Matt Condon (@shrugs)
171  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
172  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
173  *
174  * Include with `using Counters for Counters.Counter;`
175  */
176 library Counters {
177     struct Counter {
178         // This variable should never be directly accessed by users of the library: interactions must be restricted to
179         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
180         // this feature: see https://github.com/ethereum/solidity/issues/4637
181         uint256 _value; // default: 0
182     }
183 
184     function current(Counter storage counter) internal view returns (uint256) {
185         return counter._value;
186     }
187 
188     function increment(Counter storage counter) internal {
189         unchecked {
190             counter._value += 1;
191         }
192     }
193 
194     function decrement(Counter storage counter) internal {
195         uint256 value = counter._value;
196         require(value > 0, "Counter: decrement overflow");
197         unchecked {
198             counter._value = value - 1;
199         }
200     }
201 
202     function reset(Counter storage counter) internal {
203         counter._value = 0;
204     }
205 }
206 
207 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
208 
209 
210 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
211 
212 pragma solidity ^0.8.0;
213 
214 /**
215  * @dev These functions deal with verification of Merkle Trees proofs.
216  *
217  * The proofs can be generated using the JavaScript library
218  * https://github.com/miguelmota/merkletreejs[merkletreejs].
219  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
220  *
221  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
222  *
223  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
224  * hashing, or use a hash function other than keccak256 for hashing leaves.
225  * This is because the concatenation of a sorted pair of internal nodes in
226  * the merkle tree could be reinterpreted as a leaf value.
227  */
228 library MerkleProof {
229     /**
230      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
231      * defined by `root`. For this, a `proof` must be provided, containing
232      * sibling hashes on the branch from the leaf to the root of the tree. Each
233      * pair of leaves and each pair of pre-images are assumed to be sorted.
234      */
235     function verify(
236         bytes32[] memory proof,
237         bytes32 root,
238         bytes32 leaf
239     ) internal pure returns (bool) {
240         return processProof(proof, leaf) == root;
241     }
242 
243     /**
244      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
245      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
246      * hash matches the root of the tree. When processing the proof, the pairs
247      * of leafs & pre-images are assumed to be sorted.
248      *
249      * _Available since v4.4._
250      */
251     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
252         bytes32 computedHash = leaf;
253         for (uint256 i = 0; i < proof.length; i++) {
254             bytes32 proofElement = proof[i];
255             if (computedHash <= proofElement) {
256                 // Hash(current computed hash + current element of the proof)
257                 computedHash = _efficientHash(computedHash, proofElement);
258             } else {
259                 // Hash(current element of the proof + current computed hash)
260                 computedHash = _efficientHash(proofElement, computedHash);
261             }
262         }
263         return computedHash;
264     }
265 
266     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
267         assembly {
268             mstore(0x00, a)
269             mstore(0x20, b)
270             value := keccak256(0x00, 0x40)
271         }
272     }
273 }
274 
275 // File: @openzeppelin/contracts/utils/Strings.sol
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @dev String operations.
284  */
285 library Strings {
286     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
287 
288     /**
289      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
290      */
291     function toString(uint256 value) internal pure returns (string memory) {
292         // Inspired by OraclizeAPI's implementation - MIT licence
293         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
294 
295         if (value == 0) {
296             return "0";
297         }
298         uint256 temp = value;
299         uint256 digits;
300         while (temp != 0) {
301             digits++;
302             temp /= 10;
303         }
304         bytes memory buffer = new bytes(digits);
305         while (value != 0) {
306             digits -= 1;
307             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
308             value /= 10;
309         }
310         return string(buffer);
311     }
312 
313     /**
314      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
315      */
316     function toHexString(uint256 value) internal pure returns (string memory) {
317         if (value == 0) {
318             return "0x00";
319         }
320         uint256 temp = value;
321         uint256 length = 0;
322         while (temp != 0) {
323             length++;
324             temp >>= 8;
325         }
326         return toHexString(value, length);
327     }
328 
329     /**
330      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
331      */
332     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
333         bytes memory buffer = new bytes(2 * length + 2);
334         buffer[0] = "0";
335         buffer[1] = "x";
336         for (uint256 i = 2 * length + 1; i > 1; --i) {
337             buffer[i] = _HEX_SYMBOLS[value & 0xf];
338             value >>= 4;
339         }
340         require(value == 0, "Strings: hex length insufficient");
341         return string(buffer);
342     }
343 }
344 
345 // File: @openzeppelin/contracts/utils/Context.sol
346 
347 
348 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
349 
350 pragma solidity ^0.8.0;
351 
352 /**
353  * @dev Provides information about the current execution context, including the
354  * sender of the transaction and its data. While these are generally available
355  * via msg.sender and msg.data, they should not be accessed in such a direct
356  * manner, since when dealing with meta-transactions the account sending and
357  * paying for execution may not be the actual sender (as far as an application
358  * is concerned).
359  *
360  * This contract is only required for intermediate, library-like contracts.
361  */
362 abstract contract Context {
363     function _msgSender() internal view virtual returns (address) {
364         return msg.sender;
365     }
366 
367     function _msgData() internal view virtual returns (bytes calldata) {
368         return msg.data;
369     }
370 }
371 
372 // File: @openzeppelin/contracts/access/Ownable.sol
373 
374 
375 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 
380 /**
381  * @dev Contract module which provides a basic access control mechanism, where
382  * there is an account (an owner) that can be granted exclusive access to
383  * specific functions.
384  *
385  * By default, the owner account will be the one that deploys the contract. This
386  * can later be changed with {transferOwnership}.
387  *
388  * This module is used through inheritance. It will make available the modifier
389  * `onlyOwner`, which can be applied to your functions to restrict their use to
390  * the owner.
391  */
392 abstract contract Ownable is Context {
393     address private _owner;
394 
395     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
396 
397     /**
398      * @dev Initializes the contract setting the deployer as the initial owner.
399      */
400     constructor() {
401         _transferOwnership(_msgSender());
402     }
403 
404     /**
405      * @dev Returns the address of the current owner.
406      */
407     function owner() public view virtual returns (address) {
408         return _owner;
409     }
410 
411     /**
412      * @dev Throws if called by any account other than the owner.
413      */
414     modifier onlyOwner() {
415         require(owner() == _msgSender(), "Ownable: caller is not the owner");
416         _;
417     }
418 
419     /**
420      * @dev Leaves the contract without owner. It will not be possible to call
421      * `onlyOwner` functions anymore. Can only be called by the current owner.
422      *
423      * NOTE: Renouncing ownership will leave the contract without an owner,
424      * thereby removing any functionality that is only available to the owner.
425      */
426     function renounceOwnership() public virtual onlyOwner {
427         _transferOwnership(address(0));
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Can only be called by the current owner.
433      */
434     function transferOwnership(address newOwner) public virtual onlyOwner {
435         require(newOwner != address(0), "Ownable: new owner is the zero address");
436         _transferOwnership(newOwner);
437     }
438 
439     /**
440      * @dev Transfers ownership of the contract to a new account (`newOwner`).
441      * Internal function without access restriction.
442      */
443     function _transferOwnership(address newOwner) internal virtual {
444         address oldOwner = _owner;
445         _owner = newOwner;
446         emit OwnershipTransferred(oldOwner, newOwner);
447     }
448 }
449 
450 // File: @openzeppelin/contracts/utils/Address.sol
451 
452 
453 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
454 
455 pragma solidity ^0.8.1;
456 
457 /**
458  * @dev Collection of functions related to the address type
459  */
460 library Address {
461     /**
462      * @dev Returns true if `account` is a contract.
463      *
464      * [IMPORTANT]
465      * ====
466      * It is unsafe to assume that an address for which this function returns
467      * false is an externally-owned account (EOA) and not a contract.
468      *
469      * Among others, `isContract` will return false for the following
470      * types of addresses:
471      *
472      *  - an externally-owned account
473      *  - a contract in construction
474      *  - an address where a contract will be created
475      *  - an address where a contract lived, but was destroyed
476      * ====
477      *
478      * [IMPORTANT]
479      * ====
480      * You shouldn't rely on `isContract` to protect against flash loan attacks!
481      *
482      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
483      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
484      * constructor.
485      * ====
486      */
487     function isContract(address account) internal view returns (bool) {
488         // This method relies on extcodesize/address.code.length, which returns 0
489         // for contracts in construction, since the code is only stored at the end
490         // of the constructor execution.
491 
492         return account.code.length > 0;
493     }
494 
495     /**
496      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
497      * `recipient`, forwarding all available gas and reverting on errors.
498      *
499      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
500      * of certain opcodes, possibly making contracts go over the 2300 gas limit
501      * imposed by `transfer`, making them unable to receive funds via
502      * `transfer`. {sendValue} removes this limitation.
503      *
504      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
505      *
506      * IMPORTANT: because control is transferred to `recipient`, care must be
507      * taken to not create reentrancy vulnerabilities. Consider using
508      * {ReentrancyGuard} or the
509      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
510      */
511     function sendValue(address payable recipient, uint256 amount) internal {
512         require(address(this).balance >= amount, "Address: insufficient balance");
513 
514         (bool success, ) = recipient.call{value: amount}("");
515         require(success, "Address: unable to send value, recipient may have reverted");
516     }
517 
518     /**
519      * @dev Performs a Solidity function call using a low level `call`. A
520      * plain `call` is an unsafe replacement for a function call: use this
521      * function instead.
522      *
523      * If `target` reverts with a revert reason, it is bubbled up by this
524      * function (like regular Solidity function calls).
525      *
526      * Returns the raw returned data. To convert to the expected return value,
527      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
528      *
529      * Requirements:
530      *
531      * - `target` must be a contract.
532      * - calling `target` with `data` must not revert.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
537         return functionCall(target, data, "Address: low-level call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
542      * `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal returns (bytes memory) {
551         return functionCallWithValue(target, data, 0, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but also transferring `value` wei to `target`.
557      *
558      * Requirements:
559      *
560      * - the calling contract must have an ETH balance of at least `value`.
561      * - the called Solidity function must be `payable`.
562      *
563      * _Available since v3.1._
564      */
565     function functionCallWithValue(
566         address target,
567         bytes memory data,
568         uint256 value
569     ) internal returns (bytes memory) {
570         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
575      * with `errorMessage` as a fallback revert reason when `target` reverts.
576      *
577      * _Available since v3.1._
578      */
579     function functionCallWithValue(
580         address target,
581         bytes memory data,
582         uint256 value,
583         string memory errorMessage
584     ) internal returns (bytes memory) {
585         require(address(this).balance >= value, "Address: insufficient balance for call");
586         require(isContract(target), "Address: call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.call{value: value}(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
594      * but performing a static call.
595      *
596      * _Available since v3.3._
597      */
598     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
599         return functionStaticCall(target, data, "Address: low-level static call failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
604      * but performing a static call.
605      *
606      * _Available since v3.3._
607      */
608     function functionStaticCall(
609         address target,
610         bytes memory data,
611         string memory errorMessage
612     ) internal view returns (bytes memory) {
613         require(isContract(target), "Address: static call to non-contract");
614 
615         (bool success, bytes memory returndata) = target.staticcall(data);
616         return verifyCallResult(success, returndata, errorMessage);
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
621      * but performing a delegate call.
622      *
623      * _Available since v3.4._
624      */
625     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
626         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
631      * but performing a delegate call.
632      *
633      * _Available since v3.4._
634      */
635     function functionDelegateCall(
636         address target,
637         bytes memory data,
638         string memory errorMessage
639     ) internal returns (bytes memory) {
640         require(isContract(target), "Address: delegate call to non-contract");
641 
642         (bool success, bytes memory returndata) = target.delegatecall(data);
643         return verifyCallResult(success, returndata, errorMessage);
644     }
645 
646     /**
647      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
648      * revert reason using the provided one.
649      *
650      * _Available since v4.3._
651      */
652     function verifyCallResult(
653         bool success,
654         bytes memory returndata,
655         string memory errorMessage
656     ) internal pure returns (bytes memory) {
657         if (success) {
658             return returndata;
659         } else {
660             // Look for revert reason and bubble it up if present
661             if (returndata.length > 0) {
662                 // The easiest way to bubble the revert reason is using memory via assembly
663 
664                 assembly {
665                     let returndata_size := mload(returndata)
666                     revert(add(32, returndata), returndata_size)
667                 }
668             } else {
669                 revert(errorMessage);
670             }
671         }
672     }
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 
683 
684 /**
685  * @title SafeERC20
686  * @dev Wrappers around ERC20 operations that throw on failure (when the token
687  * contract returns false). Tokens that return no value (and instead revert or
688  * throw on failure) are also supported, non-reverting calls are assumed to be
689  * successful.
690  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
691  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
692  */
693 library SafeERC20 {
694     using Address for address;
695 
696     function safeTransfer(
697         IERC20 token,
698         address to,
699         uint256 value
700     ) internal {
701         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
702     }
703 
704     function safeTransferFrom(
705         IERC20 token,
706         address from,
707         address to,
708         uint256 value
709     ) internal {
710         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
711     }
712 
713     /**
714      * @dev Deprecated. This function has issues similar to the ones found in
715      * {IERC20-approve}, and its usage is discouraged.
716      *
717      * Whenever possible, use {safeIncreaseAllowance} and
718      * {safeDecreaseAllowance} instead.
719      */
720     function safeApprove(
721         IERC20 token,
722         address spender,
723         uint256 value
724     ) internal {
725         // safeApprove should only be called when setting an initial allowance,
726         // or when resetting it to zero. To increase and decrease it, use
727         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
728         require(
729             (value == 0) || (token.allowance(address(this), spender) == 0),
730             "SafeERC20: approve from non-zero to non-zero allowance"
731         );
732         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
733     }
734 
735     function safeIncreaseAllowance(
736         IERC20 token,
737         address spender,
738         uint256 value
739     ) internal {
740         uint256 newAllowance = token.allowance(address(this), spender) + value;
741         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
742     }
743 
744     function safeDecreaseAllowance(
745         IERC20 token,
746         address spender,
747         uint256 value
748     ) internal {
749         unchecked {
750             uint256 oldAllowance = token.allowance(address(this), spender);
751             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
752             uint256 newAllowance = oldAllowance - value;
753             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
754         }
755     }
756 
757     /**
758      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
759      * on the return value: the return value is optional (but if data is returned, it must not be false).
760      * @param token The token targeted by the call.
761      * @param data The call data (encoded using abi.encode or one of its variants).
762      */
763     function _callOptionalReturn(IERC20 token, bytes memory data) private {
764         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
765         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
766         // the target address contains contract code and also asserts for success in the low-level call.
767 
768         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
769         if (returndata.length > 0) {
770             // Return data is optional
771             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
772         }
773     }
774 }
775 
776 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
777 
778 
779 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
780 
781 pragma solidity ^0.8.0;
782 
783 
784 
785 
786 /**
787  * @title PaymentSplitter
788  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
789  * that the Ether will be split in this way, since it is handled transparently by the contract.
790  *
791  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
792  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
793  * an amount proportional to the percentage of total shares they were assigned.
794  *
795  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
796  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
797  * function.
798  *
799  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
800  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
801  * to run tests before sending real value to this contract.
802  */
803 contract PaymentSplitter is Context {
804     event PayeeAdded(address account, uint256 shares);
805     event PaymentReleased(address to, uint256 amount);
806     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
807     event PaymentReceived(address from, uint256 amount);
808 
809     uint256 private _totalShares;
810     uint256 private _totalReleased;
811 
812     mapping(address => uint256) private _shares;
813     mapping(address => uint256) private _released;
814     address[] private _payees;
815 
816     mapping(IERC20 => uint256) private _erc20TotalReleased;
817     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
818 
819     /**
820      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
821      * the matching position in the `shares` array.
822      *
823      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
824      * duplicates in `payees`.
825      */
826     constructor(address[] memory payees, uint256[] memory shares_) payable {
827         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
828         require(payees.length > 0, "PaymentSplitter: no payees");
829 
830         for (uint256 i = 0; i < payees.length; i++) {
831             _addPayee(payees[i], shares_[i]);
832         }
833     }
834 
835     /**
836      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
837      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
838      * reliability of the events, and not the actual splitting of Ether.
839      *
840      * To learn more about this see the Solidity documentation for
841      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
842      * functions].
843      */
844     receive() external payable virtual {
845         emit PaymentReceived(_msgSender(), msg.value);
846     }
847 
848     /**
849      * @dev Getter for the total shares held by payees.
850      */
851     function totalShares() public view returns (uint256) {
852         return _totalShares;
853     }
854 
855     /**
856      * @dev Getter for the total amount of Ether already released.
857      */
858     function totalReleased() public view returns (uint256) {
859         return _totalReleased;
860     }
861 
862     /**
863      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
864      * contract.
865      */
866     function totalReleased(IERC20 token) public view returns (uint256) {
867         return _erc20TotalReleased[token];
868     }
869 
870     /**
871      * @dev Getter for the amount of shares held by an account.
872      */
873     function shares(address account) public view returns (uint256) {
874         return _shares[account];
875     }
876 
877     /**
878      * @dev Getter for the amount of Ether already released to a payee.
879      */
880     function released(address account) public view returns (uint256) {
881         return _released[account];
882     }
883 
884     /**
885      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
886      * IERC20 contract.
887      */
888     function released(IERC20 token, address account) public view returns (uint256) {
889         return _erc20Released[token][account];
890     }
891 
892     /**
893      * @dev Getter for the address of the payee number `index`.
894      */
895     function payee(uint256 index) public view returns (address) {
896         return _payees[index];
897     }
898 
899     /**
900      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
901      * total shares and their previous withdrawals.
902      */
903     function release(address payable account) public virtual {
904         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
905 
906         uint256 totalReceived = address(this).balance + totalReleased();
907         uint256 payment = _pendingPayment(account, totalReceived, released(account));
908 
909         require(payment != 0, "PaymentSplitter: account is not due payment");
910 
911         _released[account] += payment;
912         _totalReleased += payment;
913 
914         Address.sendValue(account, payment);
915         emit PaymentReleased(account, payment);
916     }
917 
918     /**
919      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
920      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
921      * contract.
922      */
923     function release(IERC20 token, address account) public virtual {
924         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
925 
926         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
927         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
928 
929         require(payment != 0, "PaymentSplitter: account is not due payment");
930 
931         _erc20Released[token][account] += payment;
932         _erc20TotalReleased[token] += payment;
933 
934         SafeERC20.safeTransfer(token, account, payment);
935         emit ERC20PaymentReleased(token, account, payment);
936     }
937 
938     /**
939      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
940      * already released amounts.
941      */
942     function _pendingPayment(
943         address account,
944         uint256 totalReceived,
945         uint256 alreadyReleased
946     ) private view returns (uint256) {
947         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
948     }
949 
950     /**
951      * @dev Add a new payee to the contract.
952      * @param account The address of the payee to add.
953      * @param shares_ The number of shares owned by the payee.
954      */
955     function _addPayee(address account, uint256 shares_) private {
956         require(account != address(0), "PaymentSplitter: account is the zero address");
957         require(shares_ > 0, "PaymentSplitter: shares are 0");
958         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
959 
960         _payees.push(account);
961         _shares[account] = shares_;
962         _totalShares = _totalShares + shares_;
963         emit PayeeAdded(account, shares_);
964     }
965 }
966 
967 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
968 
969 
970 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
971 
972 pragma solidity ^0.8.0;
973 
974 /**
975  * @title ERC721 token receiver interface
976  * @dev Interface for any contract that wants to support safeTransfers
977  * from ERC721 asset contracts.
978  */
979 interface IERC721Receiver {
980     /**
981      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
982      * by `operator` from `from`, this function is called.
983      *
984      * It must return its Solidity selector to confirm the token transfer.
985      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
986      *
987      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
988      */
989     function onERC721Received(
990         address operator,
991         address from,
992         uint256 tokenId,
993         bytes calldata data
994     ) external returns (bytes4);
995 }
996 
997 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
998 
999 
1000 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1001 
1002 pragma solidity ^0.8.0;
1003 
1004 /**
1005  * @dev Interface of the ERC165 standard, as defined in the
1006  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1007  *
1008  * Implementers can declare support of contract interfaces, which can then be
1009  * queried by others ({ERC165Checker}).
1010  *
1011  * For an implementation, see {ERC165}.
1012  */
1013 interface IERC165 {
1014     /**
1015      * @dev Returns true if this contract implements the interface defined by
1016      * `interfaceId`. See the corresponding
1017      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1018      * to learn more about how these ids are created.
1019      *
1020      * This function call must use less than 30 000 gas.
1021      */
1022     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1023 }
1024 
1025 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1026 
1027 
1028 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1029 
1030 pragma solidity ^0.8.0;
1031 
1032 
1033 /**
1034  * @dev Implementation of the {IERC165} interface.
1035  *
1036  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1037  * for the additional interface id that will be supported. For example:
1038  *
1039  * ```solidity
1040  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1041  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1042  * }
1043  * ```
1044  *
1045  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1046  */
1047 abstract contract ERC165 is IERC165 {
1048     /**
1049      * @dev See {IERC165-supportsInterface}.
1050      */
1051     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1052         return interfaceId == type(IERC165).interfaceId;
1053     }
1054 }
1055 
1056 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1057 
1058 
1059 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1060 
1061 pragma solidity ^0.8.0;
1062 
1063 
1064 /**
1065  * @dev Required interface of an ERC721 compliant contract.
1066  */
1067 interface IERC721 is IERC165 {
1068     /**
1069      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1070      */
1071     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1072 
1073     /**
1074      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1075      */
1076     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1077 
1078     /**
1079      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1080      */
1081     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1082 
1083     /**
1084      * @dev Returns the number of tokens in ``owner``'s account.
1085      */
1086     function balanceOf(address owner) external view returns (uint256 balance);
1087 
1088     /**
1089      * @dev Returns the owner of the `tokenId` token.
1090      *
1091      * Requirements:
1092      *
1093      * - `tokenId` must exist.
1094      */
1095     function ownerOf(uint256 tokenId) external view returns (address owner);
1096 
1097     /**
1098      * @dev Safely transfers `tokenId` token from `from` to `to`.
1099      *
1100      * Requirements:
1101      *
1102      * - `from` cannot be the zero address.
1103      * - `to` cannot be the zero address.
1104      * - `tokenId` token must exist and be owned by `from`.
1105      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1106      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function safeTransferFrom(
1111         address from,
1112         address to,
1113         uint256 tokenId,
1114         bytes calldata data
1115     ) external;
1116 
1117     /**
1118      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1119      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1120      *
1121      * Requirements:
1122      *
1123      * - `from` cannot be the zero address.
1124      * - `to` cannot be the zero address.
1125      * - `tokenId` token must exist and be owned by `from`.
1126      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1127      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function safeTransferFrom(
1132         address from,
1133         address to,
1134         uint256 tokenId
1135     ) external;
1136 
1137     /**
1138      * @dev Transfers `tokenId` token from `from` to `to`.
1139      *
1140      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1141      *
1142      * Requirements:
1143      *
1144      * - `from` cannot be the zero address.
1145      * - `to` cannot be the zero address.
1146      * - `tokenId` token must be owned by `from`.
1147      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function transferFrom(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) external;
1156 
1157     /**
1158      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1159      * The approval is cleared when the token is transferred.
1160      *
1161      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1162      *
1163      * Requirements:
1164      *
1165      * - The caller must own the token or be an approved operator.
1166      * - `tokenId` must exist.
1167      *
1168      * Emits an {Approval} event.
1169      */
1170     function approve(address to, uint256 tokenId) external;
1171 
1172     /**
1173      * @dev Approve or remove `operator` as an operator for the caller.
1174      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1175      *
1176      * Requirements:
1177      *
1178      * - The `operator` cannot be the caller.
1179      *
1180      * Emits an {ApprovalForAll} event.
1181      */
1182     function setApprovalForAll(address operator, bool _approved) external;
1183 
1184     /**
1185      * @dev Returns the account approved for `tokenId` token.
1186      *
1187      * Requirements:
1188      *
1189      * - `tokenId` must exist.
1190      */
1191     function getApproved(uint256 tokenId) external view returns (address operator);
1192 
1193     /**
1194      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1195      *
1196      * See {setApprovalForAll}
1197      */
1198     function isApprovedForAll(address owner, address operator) external view returns (bool);
1199 }
1200 
1201 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1202 
1203 
1204 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1205 
1206 pragma solidity ^0.8.0;
1207 
1208 
1209 /**
1210  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1211  * @dev See https://eips.ethereum.org/EIPS/eip-721
1212  */
1213 interface IERC721Enumerable is IERC721 {
1214     /**
1215      * @dev Returns the total amount of tokens stored by the contract.
1216      */
1217     function totalSupply() external view returns (uint256);
1218 
1219     /**
1220      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1221      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1222      */
1223     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1224 
1225     /**
1226      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1227      * Use along with {totalSupply} to enumerate all tokens.
1228      */
1229     function tokenByIndex(uint256 index) external view returns (uint256);
1230 }
1231 
1232 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1233 
1234 
1235 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1236 
1237 pragma solidity ^0.8.0;
1238 
1239 
1240 /**
1241  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1242  * @dev See https://eips.ethereum.org/EIPS/eip-721
1243  */
1244 interface IERC721Metadata is IERC721 {
1245     /**
1246      * @dev Returns the token collection name.
1247      */
1248     function name() external view returns (string memory);
1249 
1250     /**
1251      * @dev Returns the token collection symbol.
1252      */
1253     function symbol() external view returns (string memory);
1254 
1255     /**
1256      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1257      */
1258     function tokenURI(uint256 tokenId) external view returns (string memory);
1259 }
1260 
1261 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1262 
1263 
1264 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1265 
1266 pragma solidity ^0.8.0;
1267 
1268 
1269 
1270 
1271 
1272 
1273 
1274 
1275 /**
1276  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1277  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1278  * {ERC721Enumerable}.
1279  */
1280 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1281     using Address for address;
1282     using Strings for uint256;
1283 
1284     // Token name
1285     string private _name;
1286 
1287     // Token symbol
1288     string private _symbol;
1289 
1290     // Mapping from token ID to owner address
1291     mapping(uint256 => address) private _owners;
1292 
1293     // Mapping owner address to token count
1294     mapping(address => uint256) private _balances;
1295 
1296     // Mapping from token ID to approved address
1297     mapping(uint256 => address) private _tokenApprovals;
1298 
1299     // Mapping from owner to operator approvals
1300     mapping(address => mapping(address => bool)) private _operatorApprovals;
1301 
1302     /**
1303      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1304      */
1305     constructor(string memory name_, string memory symbol_) {
1306         _name = name_;
1307         _symbol = symbol_;
1308     }
1309 
1310     /**
1311      * @dev See {IERC165-supportsInterface}.
1312      */
1313     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1314         return
1315             interfaceId == type(IERC721).interfaceId ||
1316             interfaceId == type(IERC721Metadata).interfaceId ||
1317             super.supportsInterface(interfaceId);
1318     }
1319 
1320     /**
1321      * @dev See {IERC721-balanceOf}.
1322      */
1323     function balanceOf(address owner) public view virtual override returns (uint256) {
1324         require(owner != address(0), "ERC721: balance query for the zero address");
1325         return _balances[owner];
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-ownerOf}.
1330      */
1331     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1332         address owner = _owners[tokenId];
1333         require(owner != address(0), "ERC721: owner query for nonexistent token");
1334         return owner;
1335     }
1336 
1337     /**
1338      * @dev See {IERC721Metadata-name}.
1339      */
1340     function name() public view virtual override returns (string memory) {
1341         return _name;
1342     }
1343 
1344     /**
1345      * @dev See {IERC721Metadata-symbol}.
1346      */
1347     function symbol() public view virtual override returns (string memory) {
1348         return _symbol;
1349     }
1350 
1351     /**
1352      * @dev See {IERC721Metadata-tokenURI}.
1353      */
1354     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1355         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1356 
1357         string memory baseURI = _baseURI();
1358         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1359     }
1360 
1361     /**
1362      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1363      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1364      * by default, can be overridden in child contracts.
1365      */
1366     function _baseURI() internal view virtual returns (string memory) {
1367         return "";
1368     }
1369 
1370     /**
1371      * @dev See {IERC721-approve}.
1372      */
1373     function approve(address to, uint256 tokenId) public virtual override {
1374         address owner = ERC721.ownerOf(tokenId);
1375         require(to != owner, "ERC721: approval to current owner");
1376 
1377         require(
1378             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1379             "ERC721: approve caller is not owner nor approved for all"
1380         );
1381 
1382         _approve(to, tokenId);
1383     }
1384 
1385     /**
1386      * @dev See {IERC721-getApproved}.
1387      */
1388     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1389         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1390 
1391         return _tokenApprovals[tokenId];
1392     }
1393 
1394     /**
1395      * @dev See {IERC721-setApprovalForAll}.
1396      */
1397     function setApprovalForAll(address operator, bool approved) public virtual override {
1398         _setApprovalForAll(_msgSender(), operator, approved);
1399     }
1400 
1401     /**
1402      * @dev See {IERC721-isApprovedForAll}.
1403      */
1404     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1405         return _operatorApprovals[owner][operator];
1406     }
1407 
1408     /**
1409      * @dev See {IERC721-transferFrom}.
1410      */
1411     function transferFrom(
1412         address from,
1413         address to,
1414         uint256 tokenId
1415     ) public virtual override {
1416         //solhint-disable-next-line max-line-length
1417         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1418 
1419         _transfer(from, to, tokenId);
1420     }
1421 
1422     /**
1423      * @dev See {IERC721-safeTransferFrom}.
1424      */
1425     function safeTransferFrom(
1426         address from,
1427         address to,
1428         uint256 tokenId
1429     ) public virtual override {
1430         safeTransferFrom(from, to, tokenId, "");
1431     }
1432 
1433     /**
1434      * @dev See {IERC721-safeTransferFrom}.
1435      */
1436     function safeTransferFrom(
1437         address from,
1438         address to,
1439         uint256 tokenId,
1440         bytes memory _data
1441     ) public virtual override {
1442         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1443         _safeTransfer(from, to, tokenId, _data);
1444     }
1445 
1446     /**
1447      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1448      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1449      *
1450      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1451      *
1452      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1453      * implement alternative mechanisms to perform token transfer, such as signature-based.
1454      *
1455      * Requirements:
1456      *
1457      * - `from` cannot be the zero address.
1458      * - `to` cannot be the zero address.
1459      * - `tokenId` token must exist and be owned by `from`.
1460      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1461      *
1462      * Emits a {Transfer} event.
1463      */
1464     function _safeTransfer(
1465         address from,
1466         address to,
1467         uint256 tokenId,
1468         bytes memory _data
1469     ) internal virtual {
1470         _transfer(from, to, tokenId);
1471         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1472     }
1473 
1474     /**
1475      * @dev Returns whether `tokenId` exists.
1476      *
1477      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1478      *
1479      * Tokens start existing when they are minted (`_mint`),
1480      * and stop existing when they are burned (`_burn`).
1481      */
1482     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1483         return _owners[tokenId] != address(0);
1484     }
1485 
1486     /**
1487      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1488      *
1489      * Requirements:
1490      *
1491      * - `tokenId` must exist.
1492      */
1493     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1494         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1495         address owner = ERC721.ownerOf(tokenId);
1496         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1497     }
1498 
1499     /**
1500      * @dev Safely mints `tokenId` and transfers it to `to`.
1501      *
1502      * Requirements:
1503      *
1504      * - `tokenId` must not exist.
1505      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1506      *
1507      * Emits a {Transfer} event.
1508      */
1509     function _safeMint(address to, uint256 tokenId) internal virtual {
1510         _safeMint(to, tokenId, "");
1511     }
1512 
1513     /**
1514      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1515      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1516      */
1517     function _safeMint(
1518         address to,
1519         uint256 tokenId,
1520         bytes memory _data
1521     ) internal virtual {
1522         _mint(to, tokenId);
1523         require(
1524             _checkOnERC721Received(address(0), to, tokenId, _data),
1525             "ERC721: transfer to non ERC721Receiver implementer"
1526         );
1527     }
1528 
1529     /**
1530      * @dev Mints `tokenId` and transfers it to `to`.
1531      *
1532      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1533      *
1534      * Requirements:
1535      *
1536      * - `tokenId` must not exist.
1537      * - `to` cannot be the zero address.
1538      *
1539      * Emits a {Transfer} event.
1540      */
1541     function _mint(address to, uint256 tokenId) internal virtual {
1542         require(to != address(0), "ERC721: mint to the zero address");
1543         require(!_exists(tokenId), "ERC721: token already minted");
1544 
1545         _beforeTokenTransfer(address(0), to, tokenId);
1546 
1547         _balances[to] += 1;
1548         _owners[tokenId] = to;
1549 
1550         emit Transfer(address(0), to, tokenId);
1551 
1552         _afterTokenTransfer(address(0), to, tokenId);
1553     }
1554 
1555     /**
1556      * @dev Destroys `tokenId`.
1557      * The approval is cleared when the token is burned.
1558      *
1559      * Requirements:
1560      *
1561      * - `tokenId` must exist.
1562      *
1563      * Emits a {Transfer} event.
1564      */
1565     function _burn(uint256 tokenId) internal virtual {
1566         address owner = ERC721.ownerOf(tokenId);
1567 
1568         _beforeTokenTransfer(owner, address(0), tokenId);
1569 
1570         // Clear approvals
1571         _approve(address(0), tokenId);
1572 
1573         _balances[owner] -= 1;
1574         delete _owners[tokenId];
1575 
1576         emit Transfer(owner, address(0), tokenId);
1577 
1578         _afterTokenTransfer(owner, address(0), tokenId);
1579     }
1580 
1581     /**
1582      * @dev Transfers `tokenId` from `from` to `to`.
1583      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1584      *
1585      * Requirements:
1586      *
1587      * - `to` cannot be the zero address.
1588      * - `tokenId` token must be owned by `from`.
1589      *
1590      * Emits a {Transfer} event.
1591      */
1592     function _transfer(
1593         address from,
1594         address to,
1595         uint256 tokenId
1596     ) internal virtual {
1597         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1598         require(to != address(0), "ERC721: transfer to the zero address");
1599 
1600         _beforeTokenTransfer(from, to, tokenId);
1601 
1602         // Clear approvals from the previous owner
1603         _approve(address(0), tokenId);
1604 
1605         _balances[from] -= 1;
1606         _balances[to] += 1;
1607         _owners[tokenId] = to;
1608 
1609         emit Transfer(from, to, tokenId);
1610 
1611         _afterTokenTransfer(from, to, tokenId);
1612     }
1613 
1614     /**
1615      * @dev Approve `to` to operate on `tokenId`
1616      *
1617      * Emits a {Approval} event.
1618      */
1619     function _approve(address to, uint256 tokenId) internal virtual {
1620         _tokenApprovals[tokenId] = to;
1621         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1622     }
1623 
1624     /**
1625      * @dev Approve `operator` to operate on all of `owner` tokens
1626      *
1627      * Emits a {ApprovalForAll} event.
1628      */
1629     function _setApprovalForAll(
1630         address owner,
1631         address operator,
1632         bool approved
1633     ) internal virtual {
1634         require(owner != operator, "ERC721: approve to caller");
1635         _operatorApprovals[owner][operator] = approved;
1636         emit ApprovalForAll(owner, operator, approved);
1637     }
1638 
1639     /**
1640      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1641      * The call is not executed if the target address is not a contract.
1642      *
1643      * @param from address representing the previous owner of the given token ID
1644      * @param to target address that will receive the tokens
1645      * @param tokenId uint256 ID of the token to be transferred
1646      * @param _data bytes optional data to send along with the call
1647      * @return bool whether the call correctly returned the expected magic value
1648      */
1649     function _checkOnERC721Received(
1650         address from,
1651         address to,
1652         uint256 tokenId,
1653         bytes memory _data
1654     ) private returns (bool) {
1655         if (to.isContract()) {
1656             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1657                 return retval == IERC721Receiver.onERC721Received.selector;
1658             } catch (bytes memory reason) {
1659                 if (reason.length == 0) {
1660                     revert("ERC721: transfer to non ERC721Receiver implementer");
1661                 } else {
1662                     assembly {
1663                         revert(add(32, reason), mload(reason))
1664                     }
1665                 }
1666             }
1667         } else {
1668             return true;
1669         }
1670     }
1671 
1672     /**
1673      * @dev Hook that is called before any token transfer. This includes minting
1674      * and burning.
1675      *
1676      * Calling conditions:
1677      *
1678      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1679      * transferred to `to`.
1680      * - When `from` is zero, `tokenId` will be minted for `to`.
1681      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1682      * - `from` and `to` are never both zero.
1683      *
1684      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1685      */
1686     function _beforeTokenTransfer(
1687         address from,
1688         address to,
1689         uint256 tokenId
1690     ) internal virtual {}
1691 
1692     /**
1693      * @dev Hook that is called after any transfer of tokens. This includes
1694      * minting and burning.
1695      *
1696      * Calling conditions:
1697      *
1698      * - when `from` and `to` are both non-zero.
1699      * - `from` and `to` are never both zero.
1700      *
1701      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1702      */
1703     function _afterTokenTransfer(
1704         address from,
1705         address to,
1706         uint256 tokenId
1707     ) internal virtual {}
1708 }
1709 
1710 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1711 
1712 
1713 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1714 
1715 pragma solidity ^0.8.0;
1716 
1717 
1718 
1719 /**
1720  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1721  * enumerability of all the token ids in the contract as well as all token ids owned by each
1722  * account.
1723  */
1724 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1725     // Mapping from owner to list of owned token IDs
1726     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1727 
1728     // Mapping from token ID to index of the owner tokens list
1729     mapping(uint256 => uint256) private _ownedTokensIndex;
1730 
1731     // Array with all token ids, used for enumeration
1732     uint256[] private _allTokens;
1733 
1734     // Mapping from token id to position in the allTokens array
1735     mapping(uint256 => uint256) private _allTokensIndex;
1736 
1737     /**
1738      * @dev See {IERC165-supportsInterface}.
1739      */
1740     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1741         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1742     }
1743 
1744     /**
1745      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1746      */
1747     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1748         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1749         return _ownedTokens[owner][index];
1750     }
1751 
1752     /**
1753      * @dev See {IERC721Enumerable-totalSupply}.
1754      */
1755     function totalSupply() public view virtual override returns (uint256) {
1756         return _allTokens.length;
1757     }
1758 
1759     /**
1760      * @dev See {IERC721Enumerable-tokenByIndex}.
1761      */
1762     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1763         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1764         return _allTokens[index];
1765     }
1766 
1767     /**
1768      * @dev Hook that is called before any token transfer. This includes minting
1769      * and burning.
1770      *
1771      * Calling conditions:
1772      *
1773      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1774      * transferred to `to`.
1775      * - When `from` is zero, `tokenId` will be minted for `to`.
1776      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1777      * - `from` cannot be the zero address.
1778      * - `to` cannot be the zero address.
1779      *
1780      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1781      */
1782     function _beforeTokenTransfer(
1783         address from,
1784         address to,
1785         uint256 tokenId
1786     ) internal virtual override {
1787         super._beforeTokenTransfer(from, to, tokenId);
1788 
1789         if (from == address(0)) {
1790             _addTokenToAllTokensEnumeration(tokenId);
1791         } else if (from != to) {
1792             _removeTokenFromOwnerEnumeration(from, tokenId);
1793         }
1794         if (to == address(0)) {
1795             _removeTokenFromAllTokensEnumeration(tokenId);
1796         } else if (to != from) {
1797             _addTokenToOwnerEnumeration(to, tokenId);
1798         }
1799     }
1800 
1801     /**
1802      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1803      * @param to address representing the new owner of the given token ID
1804      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1805      */
1806     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1807         uint256 length = ERC721.balanceOf(to);
1808         _ownedTokens[to][length] = tokenId;
1809         _ownedTokensIndex[tokenId] = length;
1810     }
1811 
1812     /**
1813      * @dev Private function to add a token to this extension's token tracking data structures.
1814      * @param tokenId uint256 ID of the token to be added to the tokens list
1815      */
1816     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1817         _allTokensIndex[tokenId] = _allTokens.length;
1818         _allTokens.push(tokenId);
1819     }
1820 
1821     /**
1822      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1823      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1824      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1825      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1826      * @param from address representing the previous owner of the given token ID
1827      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1828      */
1829     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1830         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1831         // then delete the last slot (swap and pop).
1832 
1833         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1834         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1835 
1836         // When the token to delete is the last token, the swap operation is unnecessary
1837         if (tokenIndex != lastTokenIndex) {
1838             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1839 
1840             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1841             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1842         }
1843 
1844         // This also deletes the contents at the last position of the array
1845         delete _ownedTokensIndex[tokenId];
1846         delete _ownedTokens[from][lastTokenIndex];
1847     }
1848 
1849     /**
1850      * @dev Private function to remove a token from this extension's token tracking data structures.
1851      * This has O(1) time complexity, but alters the order of the _allTokens array.
1852      * @param tokenId uint256 ID of the token to be removed from the tokens list
1853      */
1854     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1855         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1856         // then delete the last slot (swap and pop).
1857 
1858         uint256 lastTokenIndex = _allTokens.length - 1;
1859         uint256 tokenIndex = _allTokensIndex[tokenId];
1860 
1861         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1862         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1863         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1864         uint256 lastTokenId = _allTokens[lastTokenIndex];
1865 
1866         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1867         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1868 
1869         // This also deletes the contents at the last position of the array
1870         delete _allTokensIndex[tokenId];
1871         _allTokens.pop();
1872     }
1873 }
1874 
1875 // File: contracts/contract.sol
1876 
1877 
1878 pragma solidity ^0.8.7;
1879 
1880 /// @title Contract of your NFTs collection
1881 /// @author AiFrenz
1882 
1883 
1884 // █████╗ ██╗    ███████╗██████╗ ███████╗███╗   ██╗███████╗
1885 //██╔══██╗██║    ██╔════╝██╔══██╗██╔════╝████╗  ██║╚══███╔╝
1886 //███████║██║    █████╗  ██████╔╝█████╗  ██╔██╗ ██║  ███╔╝ 
1887 //██╔══██║██║    ██╔══╝  ██╔══██╗██╔══╝  ██║╚██╗██║ ███╔╝  
1888 //██║  ██║██║    ██║     ██║  ██║███████╗██║ ╚████║███████╗
1889 //╚═╝  ╚═╝╚═╝    ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚══════╝
1890                                                          
1891 contract AiFrenz is ERC721Enumerable, Ownable, ReentrancyGuard {
1892 
1893     //To increment the id of the NFTs
1894     using Counters for Counters.Counter;
1895 
1896     //To concatenate the URL of an NFT
1897     using Strings for uint256;
1898 
1899     //To check the addresses in the whitelist
1900     bytes32 public merkleRoot;
1901 
1902     //Id of the next NFT to mint
1903     Counters.Counter private _nftIdCounter;
1904 
1905     //Number of NFTs in the collection
1906     uint public constant MAX_SUPPLY = 10000;
1907 
1908      uint public constant FREE_SUPPLY = 3500;
1909     //Maximum number of NFTs an address can mint
1910     uint public max_mint_allowed = 3;
1911     //Price of one NFT in presale
1912     uint public pricePresale = 0.006 ether;
1913     //Price of one NFT in sale
1914     uint public priceSale = 0.00001 ether;
1915 
1916     //URI of the NFTs when revealed
1917     string public baseURI;
1918     //URI of the NFTs when not revealed
1919     string public notRevealedURI;
1920     //The extension of the file containing the Metadatas of the NFTs
1921     string public baseExtension = ".json";
1922 
1923     //Are the NFTs revealed yet ?
1924     bool public revealed = false;
1925 
1926     //Is the contract paused ?
1927     bool public paused = false;
1928 
1929     //The different stages of selling the collection
1930     enum Steps {
1931         Before,
1932         Freemint,
1933         Whitelist,
1934         Presale,
1935         Sale,
1936         SoldOut,
1937         Reveal
1938     }
1939 
1940     Steps public sellingStep;
1941     
1942     //Owner of the smart contract
1943     address private _owner;
1944 
1945     //Keep a track of the number of tokens per address
1946     mapping(address => uint) nftsPerWallet;
1947     
1948   mapping(address => bool) public isWhitelisted;
1949   mapping(address => uint) public tokensMintedByAddress;
1950 
1951     //Constructor of the collection
1952     constructor(string memory _theBaseURI, string memory _notRevealedURI, bytes32 _merkleRoot) ERC721("Aifrenz", "Aifrenz"){
1953         _nftIdCounter.increment();
1954         transferOwnership(msg.sender);
1955         sellingStep = Steps.Before;
1956         baseURI = _theBaseURI;
1957         notRevealedURI = _notRevealedURI;
1958         merkleRoot = _merkleRoot;
1959     }
1960 
1961     /**
1962     * @notice Edit the Merkle Root 
1963     *
1964     * @param _newMerkleRoot The new Merkle Root
1965     **/
1966     function changeMerkleRoot(bytes32 _newMerkleRoot) external onlyOwner {
1967         merkleRoot = _newMerkleRoot;
1968     }
1969 
1970     /** 
1971     * @notice Set pause to true or false
1972     *
1973     * @param _paused True or false if you want the contract to be paused or not
1974     **/
1975     function setPaused(bool _paused) external onlyOwner {
1976         paused = _paused;
1977     }
1978 
1979     /** 
1980     * @notice Change the number of NFTs that an address can mint
1981     *
1982     * @param _maxMintAllowed The number of NFTs that an address can mint
1983     **/
1984     function changeMaxMintAllowed(uint _maxMintAllowed) external onlyOwner {
1985         max_mint_allowed = _maxMintAllowed;
1986     }
1987 
1988     /**
1989     * @notice Change the price of one NFT for the presale
1990     *
1991     * @param _pricePresale The new price of one NFT for the presale
1992     **/
1993     function changePricePresale(uint _pricePresale) external onlyOwner {
1994         pricePresale = _pricePresale;
1995     }
1996 
1997   
1998     /**
1999     * @notice Change the base URI
2000     *
2001     * @param _newBaseURI The new base URI
2002     **/
2003     function setBaseUri(string memory _newBaseURI) external onlyOwner {
2004         baseURI = _newBaseURI;
2005     }
2006 
2007     /**
2008     * @notice Change the not revealed URI
2009     *
2010     * @param _notRevealedURI The new not revealed URI
2011     **/
2012     function setNotRevealURI(string memory _notRevealedURI) external onlyOwner {
2013         notRevealedURI = _notRevealedURI;
2014     }
2015 
2016     /**
2017     * @notice Allows to set the revealed variable to true
2018     **/
2019     function reveal() external onlyOwner{
2020         revealed = true;
2021     }
2022 
2023     /**
2024     * @notice Return URI of the NFTs when revealed
2025     *
2026     * @return The URI of the NFTs when revealed
2027     **/
2028     function _baseURI() internal view virtual override returns (string memory) {
2029         return baseURI;
2030     }
2031 
2032     /**
2033     * @notice Allows to change the base extension of the metadatas files
2034     *
2035     * @param _baseExtension the new extension of the metadatas files
2036     **/
2037     function setBaseExtension(string memory _baseExtension) external onlyOwner {
2038         baseExtension = _baseExtension;
2039     }
2040 
2041     function setUpWhitelistFreemint() external onlyOwner {
2042         sellingStep = Steps.Freemint;
2043     }
2044 
2045     function setUpPresale() external onlyOwner {
2046         sellingStep = Steps.Presale;
2047     }
2048 
2049   function WhitelistFreemint(uint256 _ammount) external payable nonReentrant {
2050         //Get the number of NFT sold
2051         uint numberNftSold = totalSupply();
2052         //Get the price of one NFT in Sale
2053         uint price = priceSale;
2054           //The user can only mint max 3 NFTs
2055         require(_ammount <= max_mint_allowed, "You can't mint more than 3 tokens");
2056         //If Sale didn't start yet
2057         require(sellingStep == Steps.Freemint, "Sorry, sale has not started yet.");
2058         //Did the user then enought Ethers to buy ammount NFTs ?
2059         require(msg.value >= price * _ammount, "Not enought funds.");
2060         //If the user try to mint any non-existent token
2061         require(numberNftSold + _ammount <= FREE_SUPPLY, "Freeminting is almost done and we don't have enought NFTs left.");
2062         //Add the ammount of NFTs minted by the user to the total he minted
2063         nftsPerWallet[msg.sender] += _ammount;
2064         //If this account minted the last NFTs available
2065         if(numberNftSold + _ammount == FREE_SUPPLY) {
2066             sellingStep = Steps.SoldOut;   
2067         }
2068         //Minting all the account NFTs
2069         for(uint i = 1 ; i <= _ammount ; i++) {
2070             _safeMint(msg.sender, numberNftSold + i);
2071         }
2072     }
2073 
2074 
2075 
2076     
2077 
2078     function PresaleMint(uint256 _ammount) external payable nonReentrant {
2079         //Get the number of NFT sold
2080         uint numberNftSold = totalSupply();
2081         //Get the price of one NFT in Sale
2082         uint price = pricePresale;
2083         //If everything has been bought
2084         require(sellingStep != Steps.SoldOut, "Sorry, no NFTs left.");
2085         //If Sale didn't start yet
2086         require(sellingStep == Steps.Presale, "Sorry, sale has not started yet.");
2087         //Did the user then enought Ethers to buy ammount NFTs ?
2088         require(msg.value >= price * _ammount, "Not enought funds.");
2089         //The user can only mint max 3 NFTs
2090         require(_ammount <= max_mint_allowed, "You can't mint more than 3 tokens");
2091         //If the user try to mint any non-existent token
2092         require(numberNftSold + FREE_SUPPLY + _ammount <= MAX_SUPPLY, "Sale is almost done and we don't have enought NFTs left.");
2093         //Add the ammount of NFTs minted by the user to the total he minted
2094         nftsPerWallet[msg.sender] += _ammount;
2095         //If this account minted the last NFTs available
2096         if(numberNftSold + FREE_SUPPLY + _ammount <= MAX_SUPPLY) {
2097             sellingStep = Steps.SoldOut;   
2098         }
2099         //Minting all the account NFTs
2100         for(uint i = 1 ; i <= _ammount ; i++) {
2101             _safeMint(msg.sender, numberNftSold + i);
2102         }
2103     }
2104 
2105     
2106 
2107  
2108 
2109     /**
2110     * @notice Return true or false if the account is whitelisted or not
2111     *
2112     * @param account The account of the user
2113     * @param proof The Merkle Proof
2114     *
2115     * @return true or false if the account is whitelisted or not
2116     **/
2117     function isWhiteListed(address account, bytes32[] calldata proof) internal view returns(bool) {
2118         return _verify(_leaf(account), proof);
2119     }
2120 
2121 
2122  function whitelist(address[] calldata _users) public onlyOwner {
2123       for (uint i = 0; i < _users.length; i++) {
2124           isWhitelisted[_users[i]] = true;
2125       }
2126   }
2127   
2128   function unWhitelist(address[] calldata _users) public onlyOwner {
2129      for(uint i = 0; i < _users.length; i++) {
2130           isWhitelisted[_users[i]] = false;
2131      }
2132   }
2133 
2134 
2135     /**
2136     * @notice Return the account hashed
2137     *
2138     * @param account The account to hash
2139     *
2140     * @return The account hashed
2141     **/
2142     function _leaf(address account) internal pure returns(bytes32) {
2143         return keccak256(abi.encodePacked(account));
2144     }
2145 
2146     /** 
2147     * @notice Returns true if a leaf can be proved to be a part of a Merkle tree defined by root
2148     *
2149     * @param leaf The leaf
2150     * @param proof The Merkle Proof
2151     *
2152     * @return True if a leaf can be provded to be a part of a Merkle tree defined by root
2153     **/
2154     function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
2155         return MerkleProof.verify(proof, merkleRoot, leaf);
2156     }
2157 
2158     /**
2159     * @notice Allows to get the complete URI of a specific NFT by his ID
2160     *
2161     * @param _nftId The id of the NFT
2162     *
2163     * @return The token URI of the NFT which has _nftId Id
2164     **/
2165     function tokenURI(uint _nftId) public view override(ERC721) returns (string memory) {
2166         require(_exists(_nftId), "This NFT doesn't exist.");
2167         if(revealed == false) {
2168             return notRevealedURI;
2169         }
2170         
2171         string memory currentBaseURI = _baseURI();
2172         return 
2173             bytes(currentBaseURI).length > 0 
2174             ? string(abi.encodePacked(currentBaseURI, _nftId.toString(), baseExtension))
2175             : "";
2176     }
2177 
2178       function withdraw() public payable onlyOwner {
2179     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
2180     require(success, "Withdrawal of funds failed");
2181   }
2182 
2183 }