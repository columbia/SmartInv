1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev These functions deal with verification of Merkle Trees proofs.
76  *
77  * The proofs can be generated using the JavaScript library
78  * https://github.com/miguelmota/merkletreejs[merkletreejs].
79  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
80  *
81  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
82  */
83 library MerkleProof {
84     /**
85      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
86      * defined by `root`. For this, a `proof` must be provided, containing
87      * sibling hashes on the branch from the leaf to the root of the tree. Each
88      * pair of leaves and each pair of pre-images are assumed to be sorted.
89      */
90     function verify(
91         bytes32[] memory proof,
92         bytes32 root,
93         bytes32 leaf
94     ) internal pure returns (bool) {
95         return processProof(proof, leaf) == root;
96     }
97 
98     /**
99      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
100      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
101      * hash matches the root of the tree. When processing the proof, the pairs
102      * of leafs & pre-images are assumed to be sorted.
103      *
104      * _Available since v4.4._
105      */
106     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
107         bytes32 computedHash = leaf;
108         for (uint256 i = 0; i < proof.length; i++) {
109             bytes32 proofElement = proof[i];
110             if (computedHash <= proofElement) {
111                 // Hash(current computed hash + current element of the proof)
112                 computedHash = _efficientHash(computedHash, proofElement);
113             } else {
114                 // Hash(current element of the proof + current computed hash)
115                 computedHash = _efficientHash(proofElement, computedHash);
116             }
117         }
118         return computedHash;
119     }
120 
121     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
122         assembly {
123             mstore(0x00, a)
124             mstore(0x20, b)
125             value := keccak256(0x00, 0x40)
126         }
127     }
128 }
129 
130 // File: @openzeppelin/contracts/utils/Counters.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @title Counters
139  * @author Matt Condon (@shrugs)
140  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
141  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
142  *
143  * Include with `using Counters for Counters.Counter;`
144  */
145 library Counters {
146     struct Counter {
147         // This variable should never be directly accessed by users of the library: interactions must be restricted to
148         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
149         // this feature: see https://github.com/ethereum/solidity/issues/4637
150         uint256 _value; // default: 0
151     }
152 
153     function current(Counter storage counter) internal view returns (uint256) {
154         return counter._value;
155     }
156 
157     function increment(Counter storage counter) internal {
158         unchecked {
159             counter._value += 1;
160         }
161     }
162 
163     function decrement(Counter storage counter) internal {
164         uint256 value = counter._value;
165         require(value > 0, "Counter: decrement overflow");
166         unchecked {
167             counter._value = value - 1;
168         }
169     }
170 
171     function reset(Counter storage counter) internal {
172         counter._value = 0;
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Strings.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @dev String operations.
185  */
186 library Strings {
187     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
188 
189     /**
190      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
191      */
192     function toString(uint256 value) internal pure returns (string memory) {
193         // Inspired by OraclizeAPI's implementation - MIT licence
194         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
195 
196         if (value == 0) {
197             return "0";
198         }
199         uint256 temp = value;
200         uint256 digits;
201         while (temp != 0) {
202             digits++;
203             temp /= 10;
204         }
205         bytes memory buffer = new bytes(digits);
206         while (value != 0) {
207             digits -= 1;
208             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
209             value /= 10;
210         }
211         return string(buffer);
212     }
213 
214     /**
215      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
216      */
217     function toHexString(uint256 value) internal pure returns (string memory) {
218         if (value == 0) {
219             return "0x00";
220         }
221         uint256 temp = value;
222         uint256 length = 0;
223         while (temp != 0) {
224             length++;
225             temp >>= 8;
226         }
227         return toHexString(value, length);
228     }
229 
230     /**
231      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
232      */
233     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
234         bytes memory buffer = new bytes(2 * length + 2);
235         buffer[0] = "0";
236         buffer[1] = "x";
237         for (uint256 i = 2 * length + 1; i > 1; --i) {
238             buffer[i] = _HEX_SYMBOLS[value & 0xf];
239             value >>= 4;
240         }
241         require(value == 0, "Strings: hex length insufficient");
242         return string(buffer);
243     }
244 }
245 
246 // File: @openzeppelin/contracts/utils/Context.sol
247 
248 
249 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
250 
251 pragma solidity ^0.8.0;
252 
253 /**
254  * @dev Provides information about the current execution context, including the
255  * sender of the transaction and its data. While these are generally available
256  * via msg.sender and msg.data, they should not be accessed in such a direct
257  * manner, since when dealing with meta-transactions the account sending and
258  * paying for execution may not be the actual sender (as far as an application
259  * is concerned).
260  *
261  * This contract is only required for intermediate, library-like contracts.
262  */
263 abstract contract Context {
264     function _msgSender() internal view virtual returns (address) {
265         return msg.sender;
266     }
267 
268     function _msgData() internal view virtual returns (bytes calldata) {
269         return msg.data;
270     }
271 }
272 
273 // File: @openzeppelin/contracts/access/Ownable.sol
274 
275 
276 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
277 
278 pragma solidity ^0.8.0;
279 
280 
281 /**
282  * @dev Contract module which provides a basic access control mechanism, where
283  * there is an account (an owner) that can be granted exclusive access to
284  * specific functions.
285  *
286  * By default, the owner account will be the one that deploys the contract. This
287  * can later be changed with {transferOwnership}.
288  *
289  * This module is used through inheritance. It will make available the modifier
290  * `onlyOwner`, which can be applied to your functions to restrict their use to
291  * the owner.
292  */
293 abstract contract Ownable is Context {
294     address private _owner;
295 
296     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
297 
298     /**
299      * @dev Initializes the contract setting the deployer as the initial owner.
300      */
301     constructor() {
302         _transferOwnership(_msgSender());
303     }
304 
305     /**
306      * @dev Returns the address of the current owner.
307      */
308     function owner() public view virtual returns (address) {
309         return _owner;
310     }
311 
312     /**
313      * @dev Throws if called by any account other than the owner.
314      */
315     modifier onlyOwner() {
316         require(owner() == _msgSender(), "Ownable: caller is not the owner");
317         _;
318     }
319 
320     /**
321      * @dev Leaves the contract without owner. It will not be possible to call
322      * `onlyOwner` functions anymore. Can only be called by the current owner.
323      *
324      * NOTE: Renouncing ownership will leave the contract without an owner,
325      * thereby removing any functionality that is only available to the owner.
326      */
327     function renounceOwnership() public virtual onlyOwner {
328         _transferOwnership(address(0));
329     }
330 
331     /**
332      * @dev Transfers ownership of the contract to a new account (`newOwner`).
333      * Can only be called by the current owner.
334      */
335     function transferOwnership(address newOwner) public virtual onlyOwner {
336         require(newOwner != address(0), "Ownable: new owner is the zero address");
337         _transferOwnership(newOwner);
338     }
339 
340     /**
341      * @dev Transfers ownership of the contract to a new account (`newOwner`).
342      * Internal function without access restriction.
343      */
344     function _transferOwnership(address newOwner) internal virtual {
345         address oldOwner = _owner;
346         _owner = newOwner;
347         emit OwnershipTransferred(oldOwner, newOwner);
348     }
349 }
350 
351 // File: @openzeppelin/contracts/utils/Address.sol
352 
353 
354 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
355 
356 pragma solidity ^0.8.1;
357 
358 /**
359  * @dev Collection of functions related to the address type
360  */
361 library Address {
362     /**
363      * @dev Returns true if `account` is a contract.
364      *
365      * [IMPORTANT]
366      * ====
367      * It is unsafe to assume that an address for which this function returns
368      * false is an externally-owned account (EOA) and not a contract.
369      *
370      * Among others, `isContract` will return false for the following
371      * types of addresses:
372      *
373      *  - an externally-owned account
374      *  - a contract in construction
375      *  - an address where a contract will be created
376      *  - an address where a contract lived, but was destroyed
377      * ====
378      *
379      * [IMPORTANT]
380      * ====
381      * You shouldn't rely on `isContract` to protect against flash loan attacks!
382      *
383      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
384      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
385      * constructor.
386      * ====
387      */
388     function isContract(address account) internal view returns (bool) {
389         // This method relies on extcodesize/address.code.length, which returns 0
390         // for contracts in construction, since the code is only stored at the end
391         // of the constructor execution.
392 
393         return account.code.length > 0;
394     }
395 
396     /**
397      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
398      * `recipient`, forwarding all available gas and reverting on errors.
399      *
400      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
401      * of certain opcodes, possibly making contracts go over the 2300 gas limit
402      * imposed by `transfer`, making them unable to receive funds via
403      * `transfer`. {sendValue} removes this limitation.
404      *
405      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
406      *
407      * IMPORTANT: because control is transferred to `recipient`, care must be
408      * taken to not create reentrancy vulnerabilities. Consider using
409      * {ReentrancyGuard} or the
410      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
411      */
412     function sendValue(address payable recipient, uint256 amount) internal {
413         require(address(this).balance >= amount, "Address: insufficient balance");
414 
415         (bool success, ) = recipient.call{value: amount}("");
416         require(success, "Address: unable to send value, recipient may have reverted");
417     }
418 
419     /**
420      * @dev Performs a Solidity function call using a low level `call`. A
421      * plain `call` is an unsafe replacement for a function call: use this
422      * function instead.
423      *
424      * If `target` reverts with a revert reason, it is bubbled up by this
425      * function (like regular Solidity function calls).
426      *
427      * Returns the raw returned data. To convert to the expected return value,
428      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
429      *
430      * Requirements:
431      *
432      * - `target` must be a contract.
433      * - calling `target` with `data` must not revert.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
438         return functionCall(target, data, "Address: low-level call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
443      * `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal returns (bytes memory) {
452         return functionCallWithValue(target, data, 0, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but also transferring `value` wei to `target`.
458      *
459      * Requirements:
460      *
461      * - the calling contract must have an ETH balance of at least `value`.
462      * - the called Solidity function must be `payable`.
463      *
464      * _Available since v3.1._
465      */
466     function functionCallWithValue(
467         address target,
468         bytes memory data,
469         uint256 value
470     ) internal returns (bytes memory) {
471         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
476      * with `errorMessage` as a fallback revert reason when `target` reverts.
477      *
478      * _Available since v3.1._
479      */
480     function functionCallWithValue(
481         address target,
482         bytes memory data,
483         uint256 value,
484         string memory errorMessage
485     ) internal returns (bytes memory) {
486         require(address(this).balance >= value, "Address: insufficient balance for call");
487         require(isContract(target), "Address: call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.call{value: value}(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
500         return functionStaticCall(target, data, "Address: low-level static call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a static call.
506      *
507      * _Available since v3.3._
508      */
509     function functionStaticCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal view returns (bytes memory) {
514         require(isContract(target), "Address: static call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.staticcall(data);
517         return verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
527         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
532      * but performing a delegate call.
533      *
534      * _Available since v3.4._
535      */
536     function functionDelegateCall(
537         address target,
538         bytes memory data,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         require(isContract(target), "Address: delegate call to non-contract");
542 
543         (bool success, bytes memory returndata) = target.delegatecall(data);
544         return verifyCallResult(success, returndata, errorMessage);
545     }
546 
547     /**
548      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
549      * revert reason using the provided one.
550      *
551      * _Available since v4.3._
552      */
553     function verifyCallResult(
554         bool success,
555         bytes memory returndata,
556         string memory errorMessage
557     ) internal pure returns (bytes memory) {
558         if (success) {
559             return returndata;
560         } else {
561             // Look for revert reason and bubble it up if present
562             if (returndata.length > 0) {
563                 // The easiest way to bubble the revert reason is using memory via assembly
564 
565                 assembly {
566                     let returndata_size := mload(returndata)
567                     revert(add(32, returndata), returndata_size)
568                 }
569             } else {
570                 revert(errorMessage);
571             }
572         }
573     }
574 }
575 
576 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
577 
578 
579 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @title ERC721 token receiver interface
585  * @dev Interface for any contract that wants to support safeTransfers
586  * from ERC721 asset contracts.
587  */
588 interface IERC721Receiver {
589     /**
590      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
591      * by `operator` from `from`, this function is called.
592      *
593      * It must return its Solidity selector to confirm the token transfer.
594      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
595      *
596      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
597      */
598     function onERC721Received(
599         address operator,
600         address from,
601         uint256 tokenId,
602         bytes calldata data
603     ) external returns (bytes4);
604 }
605 
606 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 /**
614  * @dev Interface of the ERC165 standard, as defined in the
615  * https://eips.ethereum.org/EIPS/eip-165[EIP].
616  *
617  * Implementers can declare support of contract interfaces, which can then be
618  * queried by others ({ERC165Checker}).
619  *
620  * For an implementation, see {ERC165}.
621  */
622 interface IERC165 {
623     /**
624      * @dev Returns true if this contract implements the interface defined by
625      * `interfaceId`. See the corresponding
626      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
627      * to learn more about how these ids are created.
628      *
629      * This function call must use less than 30 000 gas.
630      */
631     function supportsInterface(bytes4 interfaceId) external view returns (bool);
632 }
633 
634 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
635 
636 
637 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 
642 /**
643  * @dev Implementation of the {IERC165} interface.
644  *
645  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
646  * for the additional interface id that will be supported. For example:
647  *
648  * ```solidity
649  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
650  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
651  * }
652  * ```
653  *
654  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
655  */
656 abstract contract ERC165 is IERC165 {
657     /**
658      * @dev See {IERC165-supportsInterface}.
659      */
660     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
661         return interfaceId == type(IERC165).interfaceId;
662     }
663 }
664 
665 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
666 
667 
668 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 
673 /**
674  * @dev Required interface of an ERC721 compliant contract.
675  */
676 interface IERC721 is IERC165 {
677     /**
678      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
679      */
680     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
681 
682     /**
683      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
684      */
685     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
686 
687     /**
688      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
689      */
690     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
691 
692     /**
693      * @dev Returns the number of tokens in ``owner``'s account.
694      */
695     function balanceOf(address owner) external view returns (uint256 balance);
696 
697     /**
698      * @dev Returns the owner of the `tokenId` token.
699      *
700      * Requirements:
701      *
702      * - `tokenId` must exist.
703      */
704     function ownerOf(uint256 tokenId) external view returns (address owner);
705 
706     /**
707      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
708      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
709      *
710      * Requirements:
711      *
712      * - `from` cannot be the zero address.
713      * - `to` cannot be the zero address.
714      * - `tokenId` token must exist and be owned by `from`.
715      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
716      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
717      *
718      * Emits a {Transfer} event.
719      */
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 tokenId
724     ) external;
725 
726     /**
727      * @dev Transfers `tokenId` token from `from` to `to`.
728      *
729      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
730      *
731      * Requirements:
732      *
733      * - `from` cannot be the zero address.
734      * - `to` cannot be the zero address.
735      * - `tokenId` token must be owned by `from`.
736      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
737      *
738      * Emits a {Transfer} event.
739      */
740     function transferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) external;
745 
746     /**
747      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
748      * The approval is cleared when the token is transferred.
749      *
750      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
751      *
752      * Requirements:
753      *
754      * - The caller must own the token or be an approved operator.
755      * - `tokenId` must exist.
756      *
757      * Emits an {Approval} event.
758      */
759     function approve(address to, uint256 tokenId) external;
760 
761     /**
762      * @dev Returns the account approved for `tokenId` token.
763      *
764      * Requirements:
765      *
766      * - `tokenId` must exist.
767      */
768     function getApproved(uint256 tokenId) external view returns (address operator);
769 
770     /**
771      * @dev Approve or remove `operator` as an operator for the caller.
772      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
773      *
774      * Requirements:
775      *
776      * - The `operator` cannot be the caller.
777      *
778      * Emits an {ApprovalForAll} event.
779      */
780     function setApprovalForAll(address operator, bool _approved) external;
781 
782     /**
783      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
784      *
785      * See {setApprovalForAll}
786      */
787     function isApprovedForAll(address owner, address operator) external view returns (bool);
788 
789     /**
790      * @dev Safely transfers `tokenId` token from `from` to `to`.
791      *
792      * Requirements:
793      *
794      * - `from` cannot be the zero address.
795      * - `to` cannot be the zero address.
796      * - `tokenId` token must exist and be owned by `from`.
797      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
798      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
799      *
800      * Emits a {Transfer} event.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId,
806         bytes calldata data
807     ) external;
808 }
809 
810 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
811 
812 
813 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
814 
815 pragma solidity ^0.8.0;
816 
817 
818 /**
819  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
820  * @dev See https://eips.ethereum.org/EIPS/eip-721
821  */
822 interface IERC721Metadata is IERC721 {
823     /**
824      * @dev Returns the token collection name.
825      */
826     function name() external view returns (string memory);
827 
828     /**
829      * @dev Returns the token collection symbol.
830      */
831     function symbol() external view returns (string memory);
832 
833     /**
834      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
835      */
836     function tokenURI(uint256 tokenId) external view returns (string memory);
837 }
838 
839 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
840 
841 
842 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
843 
844 pragma solidity ^0.8.0;
845 
846 
847 
848 
849 
850 
851 
852 
853 /**
854  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
855  * the Metadata extension, but not including the Enumerable extension, which is available separately as
856  * {ERC721Enumerable}.
857  */
858 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
859     using Address for address;
860     using Strings for uint256;
861 
862     // Token name
863     string private _name;
864 
865     // Token symbol
866     string private _symbol;
867 
868     // Mapping from token ID to owner address
869     mapping(uint256 => address) private _owners;
870 
871     // Mapping owner address to token count
872     mapping(address => uint256) private _balances;
873 
874     // Mapping from token ID to approved address
875     mapping(uint256 => address) private _tokenApprovals;
876 
877     // Mapping from owner to operator approvals
878     mapping(address => mapping(address => bool)) private _operatorApprovals;
879 
880     /**
881      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
882      */
883     constructor(string memory name_, string memory symbol_) {
884         _name = name_;
885         _symbol = symbol_;
886     }
887 
888     /**
889      * @dev See {IERC165-supportsInterface}.
890      */
891     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
892         return
893             interfaceId == type(IERC721).interfaceId ||
894             interfaceId == type(IERC721Metadata).interfaceId ||
895             super.supportsInterface(interfaceId);
896     }
897 
898     /**
899      * @dev See {IERC721-balanceOf}.
900      */
901     function balanceOf(address owner) public view virtual override returns (uint256) {
902         require(owner != address(0), "ERC721: balance query for the zero address");
903         return _balances[owner];
904     }
905 
906     /**
907      * @dev See {IERC721-ownerOf}.
908      */
909     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
910         address owner = _owners[tokenId];
911         require(owner != address(0), "ERC721: owner query for nonexistent token");
912         return owner;
913     }
914 
915     /**
916      * @dev See {IERC721Metadata-name}.
917      */
918     function name() public view virtual override returns (string memory) {
919         return _name;
920     }
921 
922     /**
923      * @dev See {IERC721Metadata-symbol}.
924      */
925     function symbol() public view virtual override returns (string memory) {
926         return _symbol;
927     }
928 
929     /**
930      * @dev See {IERC721Metadata-tokenURI}.
931      */
932     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
933         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
934 
935         string memory baseURI = _baseURI();
936         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
937     }
938 
939     /**
940      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
941      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
942      * by default, can be overriden in child contracts.
943      */
944     function _baseURI() internal view virtual returns (string memory) {
945         return "";
946     }
947 
948     /**
949      * @dev See {IERC721-approve}.
950      */
951     function approve(address to, uint256 tokenId) public virtual override {
952         address owner = ERC721.ownerOf(tokenId);
953         require(to != owner, "ERC721: approval to current owner");
954 
955         require(
956             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
957             "ERC721: approve caller is not owner nor approved for all"
958         );
959 
960         _approve(to, tokenId);
961     }
962 
963     /**
964      * @dev See {IERC721-getApproved}.
965      */
966     function getApproved(uint256 tokenId) public view virtual override returns (address) {
967         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
968 
969         return _tokenApprovals[tokenId];
970     }
971 
972     /**
973      * @dev See {IERC721-setApprovalForAll}.
974      */
975     function setApprovalForAll(address operator, bool approved) public virtual override {
976         _setApprovalForAll(_msgSender(), operator, approved);
977     }
978 
979     /**
980      * @dev See {IERC721-isApprovedForAll}.
981      */
982     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
983         return _operatorApprovals[owner][operator];
984     }
985 
986     /**
987      * @dev See {IERC721-transferFrom}.
988      */
989     function transferFrom(
990         address from,
991         address to,
992         uint256 tokenId
993     ) public virtual override {
994         //solhint-disable-next-line max-line-length
995         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
996 
997         _transfer(from, to, tokenId);
998     }
999 
1000     /**
1001      * @dev See {IERC721-safeTransferFrom}.
1002      */
1003     function safeTransferFrom(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) public virtual override {
1008         safeTransferFrom(from, to, tokenId, "");
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-safeTransferFrom}.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId,
1018         bytes memory _data
1019     ) public virtual override {
1020         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1021         _safeTransfer(from, to, tokenId, _data);
1022     }
1023 
1024     /**
1025      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1026      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1027      *
1028      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1029      *
1030      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1031      * implement alternative mechanisms to perform token transfer, such as signature-based.
1032      *
1033      * Requirements:
1034      *
1035      * - `from` cannot be the zero address.
1036      * - `to` cannot be the zero address.
1037      * - `tokenId` token must exist and be owned by `from`.
1038      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _safeTransfer(
1043         address from,
1044         address to,
1045         uint256 tokenId,
1046         bytes memory _data
1047     ) internal virtual {
1048         _transfer(from, to, tokenId);
1049         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1050     }
1051 
1052     /**
1053      * @dev Returns whether `tokenId` exists.
1054      *
1055      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1056      *
1057      * Tokens start existing when they are minted (`_mint`),
1058      * and stop existing when they are burned (`_burn`).
1059      */
1060     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1061         return _owners[tokenId] != address(0);
1062     }
1063 
1064     /**
1065      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1066      *
1067      * Requirements:
1068      *
1069      * - `tokenId` must exist.
1070      */
1071     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1072         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1073         address owner = ERC721.ownerOf(tokenId);
1074         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1075     }
1076 
1077     /**
1078      * @dev Safely mints `tokenId` and transfers it to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - `tokenId` must not exist.
1083      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _safeMint(address to, uint256 tokenId) internal virtual {
1088         _safeMint(to, tokenId, "");
1089     }
1090 
1091     /**
1092      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1093      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1094      */
1095     function _safeMint(
1096         address to,
1097         uint256 tokenId,
1098         bytes memory _data
1099     ) internal virtual {
1100         _mint(to, tokenId);
1101         require(
1102             _checkOnERC721Received(address(0), to, tokenId, _data),
1103             "ERC721: transfer to non ERC721Receiver implementer"
1104         );
1105     }
1106 
1107     /**
1108      * @dev Mints `tokenId` and transfers it to `to`.
1109      *
1110      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1111      *
1112      * Requirements:
1113      *
1114      * - `tokenId` must not exist.
1115      * - `to` cannot be the zero address.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _mint(address to, uint256 tokenId) internal virtual {
1120         require(to != address(0), "ERC721: mint to the zero address");
1121         require(!_exists(tokenId), "ERC721: token already minted");
1122 
1123         _beforeTokenTransfer(address(0), to, tokenId);
1124 
1125         _balances[to] += 1;
1126         _owners[tokenId] = to;
1127 
1128         emit Transfer(address(0), to, tokenId);
1129 
1130         _afterTokenTransfer(address(0), to, tokenId);
1131     }
1132 
1133     /**
1134      * @dev Destroys `tokenId`.
1135      * The approval is cleared when the token is burned.
1136      *
1137      * Requirements:
1138      *
1139      * - `tokenId` must exist.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _burn(uint256 tokenId) internal virtual {
1144         address owner = ERC721.ownerOf(tokenId);
1145 
1146         _beforeTokenTransfer(owner, address(0), tokenId);
1147 
1148         // Clear approvals
1149         _approve(address(0), tokenId);
1150 
1151         _balances[owner] -= 1;
1152         delete _owners[tokenId];
1153 
1154         emit Transfer(owner, address(0), tokenId);
1155 
1156         _afterTokenTransfer(owner, address(0), tokenId);
1157     }
1158 
1159     /**
1160      * @dev Transfers `tokenId` from `from` to `to`.
1161      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1162      *
1163      * Requirements:
1164      *
1165      * - `to` cannot be the zero address.
1166      * - `tokenId` token must be owned by `from`.
1167      *
1168      * Emits a {Transfer} event.
1169      */
1170     function _transfer(
1171         address from,
1172         address to,
1173         uint256 tokenId
1174     ) internal virtual {
1175         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1176         require(to != address(0), "ERC721: transfer to the zero address");
1177 
1178         _beforeTokenTransfer(from, to, tokenId);
1179 
1180         // Clear approvals from the previous owner
1181         _approve(address(0), tokenId);
1182 
1183         _balances[from] -= 1;
1184         _balances[to] += 1;
1185         _owners[tokenId] = to;
1186 
1187         emit Transfer(from, to, tokenId);
1188 
1189         _afterTokenTransfer(from, to, tokenId);
1190     }
1191 
1192     /**
1193      * @dev Approve `to` to operate on `tokenId`
1194      *
1195      * Emits a {Approval} event.
1196      */
1197     function _approve(address to, uint256 tokenId) internal virtual {
1198         _tokenApprovals[tokenId] = to;
1199         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1200     }
1201 
1202     /**
1203      * @dev Approve `operator` to operate on all of `owner` tokens
1204      *
1205      * Emits a {ApprovalForAll} event.
1206      */
1207     function _setApprovalForAll(
1208         address owner,
1209         address operator,
1210         bool approved
1211     ) internal virtual {
1212         require(owner != operator, "ERC721: approve to caller");
1213         _operatorApprovals[owner][operator] = approved;
1214         emit ApprovalForAll(owner, operator, approved);
1215     }
1216 
1217     /**
1218      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1219      * The call is not executed if the target address is not a contract.
1220      *
1221      * @param from address representing the previous owner of the given token ID
1222      * @param to target address that will receive the tokens
1223      * @param tokenId uint256 ID of the token to be transferred
1224      * @param _data bytes optional data to send along with the call
1225      * @return bool whether the call correctly returned the expected magic value
1226      */
1227     function _checkOnERC721Received(
1228         address from,
1229         address to,
1230         uint256 tokenId,
1231         bytes memory _data
1232     ) private returns (bool) {
1233         if (to.isContract()) {
1234             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1235                 return retval == IERC721Receiver.onERC721Received.selector;
1236             } catch (bytes memory reason) {
1237                 if (reason.length == 0) {
1238                     revert("ERC721: transfer to non ERC721Receiver implementer");
1239                 } else {
1240                     assembly {
1241                         revert(add(32, reason), mload(reason))
1242                     }
1243                 }
1244             }
1245         } else {
1246             return true;
1247         }
1248     }
1249 
1250     /**
1251      * @dev Hook that is called before any token transfer. This includes minting
1252      * and burning.
1253      *
1254      * Calling conditions:
1255      *
1256      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1257      * transferred to `to`.
1258      * - When `from` is zero, `tokenId` will be minted for `to`.
1259      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1260      * - `from` and `to` are never both zero.
1261      *
1262      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1263      */
1264     function _beforeTokenTransfer(
1265         address from,
1266         address to,
1267         uint256 tokenId
1268     ) internal virtual {}
1269 
1270     /**
1271      * @dev Hook that is called after any transfer of tokens. This includes
1272      * minting and burning.
1273      *
1274      * Calling conditions:
1275      *
1276      * - when `from` and `to` are both non-zero.
1277      * - `from` and `to` are never both zero.
1278      *
1279      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1280      */
1281     function _afterTokenTransfer(
1282         address from,
1283         address to,
1284         uint256 tokenId
1285     ) internal virtual {}
1286 }
1287 
1288 // File: contracts/Womanoid.sol
1289 
1290 
1291 pragma solidity >=0.8.0;
1292 
1293 
1294 
1295 
1296 
1297 
1298 
1299 /**
1300  * @title WOMANOID ERC-721 Contract
1301  * @author DegenDeveloper.eth
1302  *
1303  * The contract owner has the following permissions:
1304  * - Toggle whitelist minting
1305  * - Toggle public minting
1306  * - Set the URI for the revealed tokens
1307  * - Set the merkle root for the whitelist
1308  * - Withdraw the funds from the contract
1309  * - Mint tokens for giveaways/airdrops
1310  */
1311 contract Womanoid is ERC721, Ownable, ReentrancyGuard {
1312   /// ============ SETUP ============ ///
1313 
1314   using Counters for Counters.Counter;
1315   using Strings for uint256;
1316 
1317   Counters.Counter private tokensMinted;
1318 
1319   string private URI;
1320 
1321   bytes32 private merkleRoot;
1322 
1323   bool private WHITELIST_SALE_ACTIVE = false;
1324   bool private PUBLIC_SALE_ACTIVE = false;
1325   bool private REVEALED = false;
1326 
1327   /// mapping from each address to number of white list claims minted
1328   mapping(address => Counters.Counter) private whitelistClaims;
1329 
1330   uint256 private constant WL_PRICE = 40000000000000000; // 0.04 ETH
1331   uint256 private constant P_PRICE = 45000000000000000; // 0.045 ETH
1332   uint256 private constant MAXSUPPLY = 8888;
1333   uint256 private constant MAXMINT = 10;
1334 
1335   /// ============ CONSTRUCTOR ============ ///
1336 
1337   /**
1338    * @param _URI The ipfs hash for unrevealed tokens
1339    * @param _merkleRoot The root hash of the whitelist merkle tree
1340    */
1341   constructor(string memory _URI, bytes32 _merkleRoot)
1342     ERC721("Womanoid", "WND")
1343   {
1344     URI = _URI;
1345     merkleRoot = _merkleRoot;
1346   }
1347 
1348   /// ============ PUBLIC ============ ///
1349 
1350   /**
1351    * @param _minting The number of tokens to mint
1352    */
1353   function publicMint(uint256 _minting) public payable nonReentrant {
1354     require(PUBLIC_SALE_ACTIVE, "WND: public minting not active");
1355     require(_minting > 0, "WND: cannot mint 0 tokens");
1356     require(_minting <= MAXMINT, "WND: too many mints per txn");
1357     require(
1358       _minting + tokensMinted.current() <= MAXSUPPLY,
1359       "WND: would exceed MAXSUPPLY"
1360     );
1361     require(msg.value >= P_PRICE * _minting, "WND: insufficient funds");
1362 
1363     for (uint256 i = 0; i < _minting; ++i) {
1364       tokensMinted.increment();
1365       _safeMint(msg.sender, tokensMinted.current());
1366     }
1367   }
1368 
1369   /**
1370    * @param _merkleProof The first part of caller's proof
1371    * @param _allowed The max number of tokens caller is allowed to mint
1372    * @param _minting The number of tokens caller is trying to mint
1373    */
1374   function whiteListMint(
1375     bytes32[] calldata _merkleProof,
1376     uint256 _allowed,
1377     uint256 _minting
1378   ) public payable nonReentrant {
1379     require(WHITELIST_SALE_ACTIVE, "WND: whitelist minting not active");
1380     require(_minting > 0, "WND: cannot mint 0 tokens");
1381     require(
1382       _verifyProof(msg.sender, _merkleProof, _allowed),
1383       "WND: invalid proof"
1384     );
1385     require(
1386       _minting + whitelistClaims[msg.sender].current() <= _allowed,
1387       "WND: not enough claims left"
1388     );
1389     require(
1390       _minting + tokensMinted.current() <= MAXSUPPLY,
1391       "WND: would exceed MAXSUPPLY"
1392     );
1393     require(msg.value >= WL_PRICE * _minting, "WND: insufficient funds");
1394 
1395     for (uint256 i = 0; i < _minting; ++i) {
1396       whitelistClaims[msg.sender].increment();
1397       tokensMinted.increment();
1398       _safeMint(msg.sender, tokensMinted.current());
1399     }
1400   }
1401 
1402   /// ============ OWNER ============ ///
1403 
1404   /**
1405    * For minting giveaway/airdrop tokens
1406    * @param _minting The number of tokens to mint
1407    */
1408   function ownerMint(uint256 _minting) public onlyOwner {
1409     require(_minting > 0, "WND: cannot mint 0 tokens");
1410     require(
1411       _minting + tokensMinted.current() <= MAXSUPPLY,
1412       "WND: would exceed MAXSUPPLY"
1413     );
1414 
1415     for (uint256 i = 0; i < _minting; ++i) {
1416       tokensMinted.increment();
1417       _safeMint(msg.sender, tokensMinted.current());
1418     }
1419   }
1420 
1421   /**
1422    * Open/close whitelist minting
1423    */
1424   function toggleWhiteListMint() public onlyOwner {
1425     WHITELIST_SALE_ACTIVE = !WHITELIST_SALE_ACTIVE;
1426   }
1427 
1428   /**
1429    * Open/close public minting
1430    */
1431   function togglePublicMint() public onlyOwner {
1432     PUBLIC_SALE_ACTIVE = !PUBLIC_SALE_ACTIVE;
1433   }
1434 
1435   /**
1436    * Reveal tokens with new baseURI
1437    * @param _newURI The ipfs folder of collection URIs
1438    */
1439   function toggleReveal(string memory _newURI) public onlyOwner {
1440     REVEALED = true;
1441     URI = _newURI;
1442   }
1443 
1444   /**
1445    * Change URI if needed
1446    */
1447   function setURI(string memory _newURI) public onlyOwner {
1448     URI = _newURI;
1449   }
1450 
1451   /**
1452    * Set new root hash for merkle tree if whitelist changes after deployment
1453    * @param _merkleRoot New root hash of whitelist merkle tree
1454    */
1455   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1456     merkleRoot = _merkleRoot;
1457   }
1458 
1459   /**
1460    * Withdraw contract balance to contract owner
1461    */
1462   function withdrawFunds() public onlyOwner {
1463     payable(owner()).transfer(address(this).balance);
1464   }
1465 
1466   /// ============ PRIVATE ============ ///
1467 
1468   /**
1469    * Determines if _whitelister can prove whitelist placement
1470    * @param _whitelister The address proving
1471    * @param _merkleProof The _whitelisters proof
1472    * @param _allowed The number of whitelist claims _whitelister has
1473    * @return _b If _whitelister's proof is true
1474    */
1475   function _verifyProof(
1476     address _whitelister,
1477     bytes32[] calldata _merkleProof,
1478     uint256 _allowed
1479   ) private view returns (bool _b) {
1480     _b = MerkleProof.verify(
1481       _merkleProof,
1482       merkleRoot,
1483       keccak256(abi.encodePacked(_whitelister, _allowed))
1484     );
1485   }
1486 
1487   /// ============ PUBLIC ============ ///
1488 
1489   /**
1490    * @param _tokenId The token id to lookup
1491    * @return _uri The URI for _tokenId
1492    */
1493   function tokenURI(uint256 _tokenId)
1494     public
1495     view
1496     override
1497     returns (string memory _uri)
1498   {
1499     _uri = string(abi.encodePacked(URI, _tokenId.toString(), ".json"));
1500   }
1501 
1502   /**
1503    * @return _b If whitelist minting is active
1504    */
1505   function isWhitelistMint() public view returns (bool _b) {
1506     _b = WHITELIST_SALE_ACTIVE;
1507   }
1508 
1509   /**
1510    * @return _b If public minting is active
1511    */
1512   function isPublicMint() public view returns (bool _b) {
1513     _b = PUBLIC_SALE_ACTIVE;
1514   }
1515 
1516   /**
1517    * @return _b If tokens are revealed
1518    */
1519   function isRevealed() public view returns (bool _b) {
1520     _b = REVEALED;
1521   }
1522 
1523   /**
1524    * @return _s The base URI of tokens
1525    */
1526   function getURI() public view returns (string memory _s) {
1527     _s = URI;
1528   }
1529 
1530   /**
1531    * @return _i The price to mint 1 token (in wei) for a whitelister
1532    */
1533   function getWhiteListPrice() public pure returns (uint256 _i) {
1534     _i = WL_PRICE;
1535   }
1536 
1537   /**
1538    * @return _i The price to mint 1 token (in wei) for public
1539    */
1540   function getPublicMintPrice() public pure returns (uint256 _i) {
1541     _i = P_PRICE;
1542   }
1543 
1544   /**
1545    * @return _i The max supply of the collection
1546    */
1547   function tokenSupply() public pure returns (uint256 _i) {
1548     _i = MAXSUPPLY;
1549   }
1550 
1551   /**
1552    * @return _i The max number of tokens to mint per txn
1553    */
1554   function getMaxMint() public pure returns (uint256 _i) {
1555     _i = MAXMINT;
1556   }
1557 
1558   /**
1559    * @return _i The number of tokens that have currently been minted
1560    */
1561   function totalMinted() public view returns (uint256 _i) {
1562     _i = tokensMinted.current();
1563   }
1564 
1565   /**
1566    * @return _b The merkle root of the whitelist
1567    */
1568   function getMerkleRoot() public view returns (bytes32 _b) {
1569     _b = merkleRoot;
1570   }
1571 
1572   /**
1573    * @param _operator The address to lookup
1574    * @return _i Then number of whitelist claims _operator has used
1575    */
1576   function getWhiteListClaims(address _operator)
1577     public
1578     view
1579     returns (uint256 _i)
1580   {
1581     _i = whitelistClaims[_operator].current();
1582   }
1583 }