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
70 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
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
82  *
83  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
84  * hashing, or use a hash function other than keccak256 for hashing leaves.
85  * This is because the concatenation of a sorted pair of internal nodes in
86  * the merkle tree could be reinterpreted as a leaf value.
87  */
88 library MerkleProof {
89     /**
90      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
91      * defined by `root`. For this, a `proof` must be provided, containing
92      * sibling hashes on the branch from the leaf to the root of the tree. Each
93      * pair of leaves and each pair of pre-images are assumed to be sorted.
94      */
95     function verify(
96         bytes32[] memory proof,
97         bytes32 root,
98         bytes32 leaf
99     ) internal pure returns (bool) {
100         return processProof(proof, leaf) == root;
101     }
102 
103     /**
104      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
105      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
106      * hash matches the root of the tree. When processing the proof, the pairs
107      * of leafs & pre-images are assumed to be sorted.
108      *
109      * _Available since v4.4._
110      */
111     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
112         bytes32 computedHash = leaf;
113         for (uint256 i = 0; i < proof.length; i++) {
114             bytes32 proofElement = proof[i];
115             if (computedHash <= proofElement) {
116                 // Hash(current computed hash + current element of the proof)
117                 computedHash = _efficientHash(computedHash, proofElement);
118             } else {
119                 // Hash(current element of the proof + current computed hash)
120                 computedHash = _efficientHash(proofElement, computedHash);
121             }
122         }
123         return computedHash;
124     }
125 
126     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
127         assembly {
128             mstore(0x00, a)
129             mstore(0x20, b)
130             value := keccak256(0x00, 0x40)
131         }
132     }
133 }
134 
135 // File: @openzeppelin/contracts/utils/Strings.sol
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev String operations.
144  */
145 library Strings {
146     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
147 
148     /**
149      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
150      */
151     function toString(uint256 value) internal pure returns (string memory) {
152         // Inspired by OraclizeAPI's implementation - MIT licence
153         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
154 
155         if (value == 0) {
156             return "0";
157         }
158         uint256 temp = value;
159         uint256 digits;
160         while (temp != 0) {
161             digits++;
162             temp /= 10;
163         }
164         bytes memory buffer = new bytes(digits);
165         while (value != 0) {
166             digits -= 1;
167             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
168             value /= 10;
169         }
170         return string(buffer);
171     }
172 
173     /**
174      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
175      */
176     function toHexString(uint256 value) internal pure returns (string memory) {
177         if (value == 0) {
178             return "0x00";
179         }
180         uint256 temp = value;
181         uint256 length = 0;
182         while (temp != 0) {
183             length++;
184             temp >>= 8;
185         }
186         return toHexString(value, length);
187     }
188 
189     /**
190      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
191      */
192     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
193         bytes memory buffer = new bytes(2 * length + 2);
194         buffer[0] = "0";
195         buffer[1] = "x";
196         for (uint256 i = 2 * length + 1; i > 1; --i) {
197             buffer[i] = _HEX_SYMBOLS[value & 0xf];
198             value >>= 4;
199         }
200         require(value == 0, "Strings: hex length insufficient");
201         return string(buffer);
202     }
203 }
204 
205 // File: @openzeppelin/contracts/utils/Context.sol
206 
207 
208 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @dev Provides information about the current execution context, including the
214  * sender of the transaction and its data. While these are generally available
215  * via msg.sender and msg.data, they should not be accessed in such a direct
216  * manner, since when dealing with meta-transactions the account sending and
217  * paying for execution may not be the actual sender (as far as an application
218  * is concerned).
219  *
220  * This contract is only required for intermediate, library-like contracts.
221  */
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes calldata) {
228         return msg.data;
229     }
230 }
231 
232 // File: @openzeppelin/contracts/access/Ownable.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 
240 /**
241  * @dev Contract module which provides a basic access control mechanism, where
242  * there is an account (an owner) that can be granted exclusive access to
243  * specific functions.
244  *
245  * By default, the owner account will be the one that deploys the contract. This
246  * can later be changed with {transferOwnership}.
247  *
248  * This module is used through inheritance. It will make available the modifier
249  * `onlyOwner`, which can be applied to your functions to restrict their use to
250  * the owner.
251  */
252 abstract contract Ownable is Context {
253     address private _owner;
254 
255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
256 
257     /**
258      * @dev Initializes the contract setting the deployer as the initial owner.
259      */
260     constructor() {
261         _transferOwnership(_msgSender());
262     }
263 
264     /**
265      * @dev Returns the address of the current owner.
266      */
267     function owner() public view virtual returns (address) {
268         return _owner;
269     }
270 
271     /**
272      * @dev Throws if called by any account other than the owner.
273      */
274     modifier onlyOwner() {
275         require(owner() == _msgSender(), "Ownable: caller is not the owner");
276         _;
277     }
278 
279     /**
280      * @dev Leaves the contract without owner. It will not be possible to call
281      * `onlyOwner` functions anymore. Can only be called by the current owner.
282      *
283      * NOTE: Renouncing ownership will leave the contract without an owner,
284      * thereby removing any functionality that is only available to the owner.
285      */
286     function renounceOwnership() public virtual onlyOwner {
287         _transferOwnership(address(0));
288     }
289 
290     /**
291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
292      * Can only be called by the current owner.
293      */
294     function transferOwnership(address newOwner) public virtual onlyOwner {
295         require(newOwner != address(0), "Ownable: new owner is the zero address");
296         _transferOwnership(newOwner);
297     }
298 
299     /**
300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
301      * Internal function without access restriction.
302      */
303     function _transferOwnership(address newOwner) internal virtual {
304         address oldOwner = _owner;
305         _owner = newOwner;
306         emit OwnershipTransferred(oldOwner, newOwner);
307     }
308 }
309 
310 // File: @openzeppelin/contracts/utils/Address.sol
311 
312 
313 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
314 
315 pragma solidity ^0.8.1;
316 
317 /**
318  * @dev Collection of functions related to the address type
319  */
320 library Address {
321     /**
322      * @dev Returns true if `account` is a contract.
323      *
324      * [IMPORTANT]
325      * ====
326      * It is unsafe to assume that an address for which this function returns
327      * false is an externally-owned account (EOA) and not a contract.
328      *
329      * Among others, `isContract` will return false for the following
330      * types of addresses:
331      *
332      *  - an externally-owned account
333      *  - a contract in construction
334      *  - an address where a contract will be created
335      *  - an address where a contract lived, but was destroyed
336      * ====
337      *
338      * [IMPORTANT]
339      * ====
340      * You shouldn't rely on `isContract` to protect against flash loan attacks!
341      *
342      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
343      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
344      * constructor.
345      * ====
346      */
347     function isContract(address account) internal view returns (bool) {
348         // This method relies on extcodesize/address.code.length, which returns 0
349         // for contracts in construction, since the code is only stored at the end
350         // of the constructor execution.
351 
352         return account.code.length > 0;
353     }
354 
355     /**
356      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
357      * `recipient`, forwarding all available gas and reverting on errors.
358      *
359      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
360      * of certain opcodes, possibly making contracts go over the 2300 gas limit
361      * imposed by `transfer`, making them unable to receive funds via
362      * `transfer`. {sendValue} removes this limitation.
363      *
364      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
365      *
366      * IMPORTANT: because control is transferred to `recipient`, care must be
367      * taken to not create reentrancy vulnerabilities. Consider using
368      * {ReentrancyGuard} or the
369      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
370      */
371     function sendValue(address payable recipient, uint256 amount) internal {
372         require(address(this).balance >= amount, "Address: insufficient balance");
373 
374         (bool success, ) = recipient.call{value: amount}("");
375         require(success, "Address: unable to send value, recipient may have reverted");
376     }
377 
378     /**
379      * @dev Performs a Solidity function call using a low level `call`. A
380      * plain `call` is an unsafe replacement for a function call: use this
381      * function instead.
382      *
383      * If `target` reverts with a revert reason, it is bubbled up by this
384      * function (like regular Solidity function calls).
385      *
386      * Returns the raw returned data. To convert to the expected return value,
387      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
388      *
389      * Requirements:
390      *
391      * - `target` must be a contract.
392      * - calling `target` with `data` must not revert.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
397         return functionCall(target, data, "Address: low-level call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
402      * `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         return functionCallWithValue(target, data, 0, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but also transferring `value` wei to `target`.
417      *
418      * Requirements:
419      *
420      * - the calling contract must have an ETH balance of at least `value`.
421      * - the called Solidity function must be `payable`.
422      *
423      * _Available since v3.1._
424      */
425     function functionCallWithValue(
426         address target,
427         bytes memory data,
428         uint256 value
429     ) internal returns (bytes memory) {
430         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
435      * with `errorMessage` as a fallback revert reason when `target` reverts.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(
440         address target,
441         bytes memory data,
442         uint256 value,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(address(this).balance >= value, "Address: insufficient balance for call");
446         require(isContract(target), "Address: call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.call{value: value}(data);
449         return verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but performing a static call.
455      *
456      * _Available since v3.3._
457      */
458     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
459         return functionStaticCall(target, data, "Address: low-level static call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
464      * but performing a static call.
465      *
466      * _Available since v3.3._
467      */
468     function functionStaticCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal view returns (bytes memory) {
473         require(isContract(target), "Address: static call to non-contract");
474 
475         (bool success, bytes memory returndata) = target.staticcall(data);
476         return verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but performing a delegate call.
482      *
483      * _Available since v3.4._
484      */
485     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
486         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
491      * but performing a delegate call.
492      *
493      * _Available since v3.4._
494      */
495     function functionDelegateCall(
496         address target,
497         bytes memory data,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         require(isContract(target), "Address: delegate call to non-contract");
501 
502         (bool success, bytes memory returndata) = target.delegatecall(data);
503         return verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     /**
507      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
508      * revert reason using the provided one.
509      *
510      * _Available since v4.3._
511      */
512     function verifyCallResult(
513         bool success,
514         bytes memory returndata,
515         string memory errorMessage
516     ) internal pure returns (bytes memory) {
517         if (success) {
518             return returndata;
519         } else {
520             // Look for revert reason and bubble it up if present
521             if (returndata.length > 0) {
522                 // The easiest way to bubble the revert reason is using memory via assembly
523 
524                 assembly {
525                     let returndata_size := mload(returndata)
526                     revert(add(32, returndata), returndata_size)
527                 }
528             } else {
529                 revert(errorMessage);
530             }
531         }
532     }
533 }
534 
535 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
536 
537 
538 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @title ERC721 token receiver interface
544  * @dev Interface for any contract that wants to support safeTransfers
545  * from ERC721 asset contracts.
546  */
547 interface IERC721Receiver {
548     /**
549      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
550      * by `operator` from `from`, this function is called.
551      *
552      * It must return its Solidity selector to confirm the token transfer.
553      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
554      *
555      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
556      */
557     function onERC721Received(
558         address operator,
559         address from,
560         uint256 tokenId,
561         bytes calldata data
562     ) external returns (bytes4);
563 }
564 
565 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
566 
567 
568 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 /**
573  * @dev Interface of the ERC165 standard, as defined in the
574  * https://eips.ethereum.org/EIPS/eip-165[EIP].
575  *
576  * Implementers can declare support of contract interfaces, which can then be
577  * queried by others ({ERC165Checker}).
578  *
579  * For an implementation, see {ERC165}.
580  */
581 interface IERC165 {
582     /**
583      * @dev Returns true if this contract implements the interface defined by
584      * `interfaceId`. See the corresponding
585      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
586      * to learn more about how these ids are created.
587      *
588      * This function call must use less than 30 000 gas.
589      */
590     function supportsInterface(bytes4 interfaceId) external view returns (bool);
591 }
592 
593 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @dev Implementation of the {IERC165} interface.
603  *
604  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
605  * for the additional interface id that will be supported. For example:
606  *
607  * ```solidity
608  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
609  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
610  * }
611  * ```
612  *
613  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
614  */
615 abstract contract ERC165 is IERC165 {
616     /**
617      * @dev See {IERC165-supportsInterface}.
618      */
619     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
620         return interfaceId == type(IERC165).interfaceId;
621     }
622 }
623 
624 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
625 
626 
627 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
628 
629 pragma solidity ^0.8.0;
630 
631 
632 /**
633  * @dev Required interface of an ERC721 compliant contract.
634  */
635 interface IERC721 is IERC165 {
636     /**
637      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
638      */
639     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
640 
641     /**
642      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
643      */
644     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
645 
646     /**
647      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
648      */
649     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
650 
651     /**
652      * @dev Returns the number of tokens in ``owner``'s account.
653      */
654     function balanceOf(address owner) external view returns (uint256 balance);
655 
656     /**
657      * @dev Returns the owner of the `tokenId` token.
658      *
659      * Requirements:
660      *
661      * - `tokenId` must exist.
662      */
663     function ownerOf(uint256 tokenId) external view returns (address owner);
664 
665     /**
666      * @dev Safely transfers `tokenId` token from `from` to `to`.
667      *
668      * Requirements:
669      *
670      * - `from` cannot be the zero address.
671      * - `to` cannot be the zero address.
672      * - `tokenId` token must exist and be owned by `from`.
673      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
674      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
675      *
676      * Emits a {Transfer} event.
677      */
678     function safeTransferFrom(
679         address from,
680         address to,
681         uint256 tokenId,
682         bytes calldata data
683     ) external;
684 
685     /**
686      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
687      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
688      *
689      * Requirements:
690      *
691      * - `from` cannot be the zero address.
692      * - `to` cannot be the zero address.
693      * - `tokenId` token must exist and be owned by `from`.
694      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
695      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
696      *
697      * Emits a {Transfer} event.
698      */
699     function safeTransferFrom(
700         address from,
701         address to,
702         uint256 tokenId
703     ) external;
704 
705     /**
706      * @dev Transfers `tokenId` token from `from` to `to`.
707      *
708      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
709      *
710      * Requirements:
711      *
712      * - `from` cannot be the zero address.
713      * - `to` cannot be the zero address.
714      * - `tokenId` token must be owned by `from`.
715      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
716      *
717      * Emits a {Transfer} event.
718      */
719     function transferFrom(
720         address from,
721         address to,
722         uint256 tokenId
723     ) external;
724 
725     /**
726      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
727      * The approval is cleared when the token is transferred.
728      *
729      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
730      *
731      * Requirements:
732      *
733      * - The caller must own the token or be an approved operator.
734      * - `tokenId` must exist.
735      *
736      * Emits an {Approval} event.
737      */
738     function approve(address to, uint256 tokenId) external;
739 
740     /**
741      * @dev Approve or remove `operator` as an operator for the caller.
742      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
743      *
744      * Requirements:
745      *
746      * - The `operator` cannot be the caller.
747      *
748      * Emits an {ApprovalForAll} event.
749      */
750     function setApprovalForAll(address operator, bool _approved) external;
751 
752     /**
753      * @dev Returns the account approved for `tokenId` token.
754      *
755      * Requirements:
756      *
757      * - `tokenId` must exist.
758      */
759     function getApproved(uint256 tokenId) external view returns (address operator);
760 
761     /**
762      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
763      *
764      * See {setApprovalForAll}
765      */
766     function isApprovedForAll(address owner, address operator) external view returns (bool);
767 }
768 
769 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
770 
771 
772 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
773 
774 pragma solidity ^0.8.0;
775 
776 
777 /**
778  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
779  * @dev See https://eips.ethereum.org/EIPS/eip-721
780  */
781 interface IERC721Metadata is IERC721 {
782     /**
783      * @dev Returns the token collection name.
784      */
785     function name() external view returns (string memory);
786 
787     /**
788      * @dev Returns the token collection symbol.
789      */
790     function symbol() external view returns (string memory);
791 
792     /**
793      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
794      */
795     function tokenURI(uint256 tokenId) external view returns (string memory);
796 }
797 
798 // File: erc721a/contracts/IERC721A.sol
799 
800 
801 // ERC721A Contracts v3.3.0
802 // Creator: Chiru Labs
803 
804 pragma solidity ^0.8.4;
805 
806 
807 
808 /**
809  * @dev Interface of an ERC721A compliant contract.
810  */
811 interface IERC721A is IERC721, IERC721Metadata {
812     /**
813      * The caller must own the token or be an approved operator.
814      */
815     error ApprovalCallerNotOwnerNorApproved();
816 
817     /**
818      * The token does not exist.
819      */
820     error ApprovalQueryForNonexistentToken();
821 
822     /**
823      * The caller cannot approve to their own address.
824      */
825     error ApproveToCaller();
826 
827     /**
828      * The caller cannot approve to the current owner.
829      */
830     error ApprovalToCurrentOwner();
831 
832     /**
833      * Cannot query the balance for the zero address.
834      */
835     error BalanceQueryForZeroAddress();
836 
837     /**
838      * Cannot mint to the zero address.
839      */
840     error MintToZeroAddress();
841 
842     /**
843      * The quantity of tokens minted must be more than zero.
844      */
845     error MintZeroQuantity();
846 
847     /**
848      * The token does not exist.
849      */
850     error OwnerQueryForNonexistentToken();
851 
852     /**
853      * The caller must own the token or be an approved operator.
854      */
855     error TransferCallerNotOwnerNorApproved();
856 
857     /**
858      * The token must be owned by `from`.
859      */
860     error TransferFromIncorrectOwner();
861 
862     /**
863      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
864      */
865     error TransferToNonERC721ReceiverImplementer();
866 
867     /**
868      * Cannot transfer to the zero address.
869      */
870     error TransferToZeroAddress();
871 
872     /**
873      * The token does not exist.
874      */
875     error URIQueryForNonexistentToken();
876 
877     // Compiler will pack this into a single 256bit word.
878     struct TokenOwnership {
879         // The address of the owner.
880         address addr;
881         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
882         uint64 startTimestamp;
883         // Whether the token has been burned.
884         bool burned;
885     }
886 
887     // Compiler will pack this into a single 256bit word.
888     struct AddressData {
889         // Realistically, 2**64-1 is more than enough.
890         uint64 balance;
891         // Keeps track of mint count with minimal overhead for tokenomics.
892         uint64 numberMinted;
893         // Keeps track of burn count with minimal overhead for tokenomics.
894         uint64 numberBurned;
895         // For miscellaneous variable(s) pertaining to the address
896         // (e.g. number of whitelist mint slots used).
897         // If there are multiple variables, please pack them into a uint64.
898         uint64 aux;
899     }
900 
901     /**
902      * @dev Returns the total amount of tokens stored by the contract.
903      * 
904      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
905      */
906     function totalSupply() external view returns (uint256);
907 }
908 
909 // File: erc721a/contracts/ERC721A.sol
910 
911 
912 // ERC721A Contracts v3.3.0
913 // Creator: Chiru Labs
914 
915 pragma solidity ^0.8.4;
916 
917 
918 
919 
920 
921 
922 
923 /**
924  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
925  * the Metadata extension. Built to optimize for lower gas during batch mints.
926  *
927  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
928  *
929  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
930  *
931  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
932  */
933 contract ERC721A is Context, ERC165, IERC721A {
934     using Address for address;
935     using Strings for uint256;
936 
937     // The tokenId of the next token to be minted.
938     uint256 internal _currentIndex;
939 
940     // The number of tokens burned.
941     uint256 internal _burnCounter;
942 
943     // Token name
944     string private _name;
945 
946     // Token symbol
947     string private _symbol;
948 
949     // Mapping from token ID to ownership details
950     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
951     mapping(uint256 => TokenOwnership) internal _ownerships;
952 
953     // Mapping owner address to address data
954     mapping(address => AddressData) private _addressData;
955 
956     // Mapping from token ID to approved address
957     mapping(uint256 => address) private _tokenApprovals;
958 
959     // Mapping from owner to operator approvals
960     mapping(address => mapping(address => bool)) private _operatorApprovals;
961 
962     constructor(string memory name_, string memory symbol_) {
963         _name = name_;
964         _symbol = symbol_;
965         _currentIndex = _startTokenId();
966     }
967 
968     /**
969      * To change the starting tokenId, please override this function.
970      */
971     function _startTokenId() internal view virtual returns (uint256) {
972         return 0;
973     }
974 
975     /**
976      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
977      */
978     function totalSupply() public view override returns (uint256) {
979         // Counter underflow is impossible as _burnCounter cannot be incremented
980         // more than _currentIndex - _startTokenId() times
981         unchecked {
982             return _currentIndex - _burnCounter - _startTokenId();
983         }
984     }
985 
986     /**
987      * Returns the total amount of tokens minted in the contract.
988      */
989     function _totalMinted() internal view returns (uint256) {
990         // Counter underflow is impossible as _currentIndex does not decrement,
991         // and it is initialized to _startTokenId()
992         unchecked {
993             return _currentIndex - _startTokenId();
994         }
995     }
996 
997     /**
998      * @dev See {IERC165-supportsInterface}.
999      */
1000     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1001         return
1002             interfaceId == type(IERC721).interfaceId ||
1003             interfaceId == type(IERC721Metadata).interfaceId ||
1004             super.supportsInterface(interfaceId);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-balanceOf}.
1009      */
1010     function balanceOf(address owner) public view override returns (uint256) {
1011         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1012         return uint256(_addressData[owner].balance);
1013     }
1014 
1015     /**
1016      * Returns the number of tokens minted by `owner`.
1017      */
1018     function _numberMinted(address owner) internal view returns (uint256) {
1019         return uint256(_addressData[owner].numberMinted);
1020     }
1021 
1022     /**
1023      * Returns the number of tokens burned by or on behalf of `owner`.
1024      */
1025     function _numberBurned(address owner) internal view returns (uint256) {
1026         return uint256(_addressData[owner].numberBurned);
1027     }
1028 
1029     /**
1030      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1031      */
1032     function _getAux(address owner) internal view returns (uint64) {
1033         return _addressData[owner].aux;
1034     }
1035 
1036     /**
1037      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1038      * If there are multiple variables, please pack them into a uint64.
1039      */
1040     function _setAux(address owner, uint64 aux) internal {
1041         _addressData[owner].aux = aux;
1042     }
1043 
1044     /**
1045      * Gas spent here starts off proportional to the maximum mint batch size.
1046      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1047      */
1048     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1049         uint256 curr = tokenId;
1050 
1051         unchecked {
1052             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1053                 TokenOwnership memory ownership = _ownerships[curr];
1054                 if (!ownership.burned) {
1055                     if (ownership.addr != address(0)) {
1056                         return ownership;
1057                     }
1058                     // Invariant:
1059                     // There will always be an ownership that has an address and is not burned
1060                     // before an ownership that does not have an address and is not burned.
1061                     // Hence, curr will not underflow.
1062                     while (true) {
1063                         curr--;
1064                         ownership = _ownerships[curr];
1065                         if (ownership.addr != address(0)) {
1066                             return ownership;
1067                         }
1068                     }
1069                 }
1070             }
1071         }
1072         revert OwnerQueryForNonexistentToken();
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-ownerOf}.
1077      */
1078     function ownerOf(uint256 tokenId) public view override returns (address) {
1079         return _ownershipOf(tokenId).addr;
1080     }
1081 
1082     /**
1083      * @dev See {IERC721Metadata-name}.
1084      */
1085     function name() public view virtual override returns (string memory) {
1086         return _name;
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Metadata-symbol}.
1091      */
1092     function symbol() public view virtual override returns (string memory) {
1093         return _symbol;
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Metadata-tokenURI}.
1098      */
1099     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1100         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1101 
1102         string memory baseURI = _baseURI();
1103         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1104     }
1105 
1106     /**
1107      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1108      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1109      * by default, can be overriden in child contracts.
1110      */
1111     function _baseURI() internal view virtual returns (string memory) {
1112         return '';
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-approve}.
1117      */
1118     function approve(address to, uint256 tokenId) public override {
1119         address owner = ERC721A.ownerOf(tokenId);
1120         if (to == owner) revert ApprovalToCurrentOwner();
1121 
1122         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1123             revert ApprovalCallerNotOwnerNorApproved();
1124         }
1125 
1126         _approve(to, tokenId, owner);
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-getApproved}.
1131      */
1132     function getApproved(uint256 tokenId) public view override returns (address) {
1133         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1134 
1135         return _tokenApprovals[tokenId];
1136     }
1137 
1138     /**
1139      * @dev See {IERC721-setApprovalForAll}.
1140      */
1141     function setApprovalForAll(address operator, bool approved) public virtual override {
1142         if (operator == _msgSender()) revert ApproveToCaller();
1143 
1144         _operatorApprovals[_msgSender()][operator] = approved;
1145         emit ApprovalForAll(_msgSender(), operator, approved);
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-isApprovedForAll}.
1150      */
1151     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1152         return _operatorApprovals[owner][operator];
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-transferFrom}.
1157      */
1158     function transferFrom(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) public virtual override {
1163         _transfer(from, to, tokenId);
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-safeTransferFrom}.
1168      */
1169     function safeTransferFrom(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) public virtual override {
1174         safeTransferFrom(from, to, tokenId, '');
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-safeTransferFrom}.
1179      */
1180     function safeTransferFrom(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) public virtual override {
1186         _transfer(from, to, tokenId);
1187         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1188             revert TransferToNonERC721ReceiverImplementer();
1189         }
1190     }
1191 
1192     /**
1193      * @dev Returns whether `tokenId` exists.
1194      *
1195      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1196      *
1197      * Tokens start existing when they are minted (`_mint`),
1198      */
1199     function _exists(uint256 tokenId) internal view returns (bool) {
1200         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1201     }
1202 
1203     /**
1204      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1205      */
1206     function _safeMint(address to, uint256 quantity) internal {
1207         _safeMint(to, quantity, '');
1208     }
1209 
1210     /**
1211      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1212      *
1213      * Requirements:
1214      *
1215      * - If `to` refers to a smart contract, it must implement
1216      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1217      * - `quantity` must be greater than 0.
1218      *
1219      * Emits a {Transfer} event.
1220      */
1221     function _safeMint(
1222         address to,
1223         uint256 quantity,
1224         bytes memory _data
1225     ) internal {
1226         uint256 startTokenId = _currentIndex;
1227         if (to == address(0)) revert MintToZeroAddress();
1228         if (quantity == 0) revert MintZeroQuantity();
1229 
1230         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1231 
1232         // Overflows are incredibly unrealistic.
1233         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1234         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1235         unchecked {
1236             _addressData[to].balance += uint64(quantity);
1237             _addressData[to].numberMinted += uint64(quantity);
1238 
1239             _ownerships[startTokenId].addr = to;
1240             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1241 
1242             uint256 updatedIndex = startTokenId;
1243             uint256 end = updatedIndex + quantity;
1244 
1245             if (to.isContract()) {
1246                 do {
1247                     emit Transfer(address(0), to, updatedIndex);
1248                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1249                         revert TransferToNonERC721ReceiverImplementer();
1250                     }
1251                 } while (updatedIndex < end);
1252                 // Reentrancy protection
1253                 if (_currentIndex != startTokenId) revert();
1254             } else {
1255                 do {
1256                     emit Transfer(address(0), to, updatedIndex++);
1257                 } while (updatedIndex < end);
1258             }
1259             _currentIndex = updatedIndex;
1260         }
1261         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1262     }
1263 
1264     /**
1265      * @dev Mints `quantity` tokens and transfers them to `to`.
1266      *
1267      * Requirements:
1268      *
1269      * - `to` cannot be the zero address.
1270      * - `quantity` must be greater than 0.
1271      *
1272      * Emits a {Transfer} event.
1273      */
1274     function _mint(address to, uint256 quantity) internal {
1275         uint256 startTokenId = _currentIndex;
1276         if (to == address(0)) revert MintToZeroAddress();
1277         if (quantity == 0) revert MintZeroQuantity();
1278 
1279         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1280 
1281         // Overflows are incredibly unrealistic.
1282         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1283         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1284         unchecked {
1285             _addressData[to].balance += uint64(quantity);
1286             _addressData[to].numberMinted += uint64(quantity);
1287 
1288             _ownerships[startTokenId].addr = to;
1289             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1290 
1291             uint256 updatedIndex = startTokenId;
1292             uint256 end = updatedIndex + quantity;
1293 
1294             do {
1295                 emit Transfer(address(0), to, updatedIndex++);
1296             } while (updatedIndex < end);
1297 
1298             _currentIndex = updatedIndex;
1299         }
1300         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1301     }
1302 
1303     /**
1304      * @dev Transfers `tokenId` from `from` to `to`.
1305      *
1306      * Requirements:
1307      *
1308      * - `to` cannot be the zero address.
1309      * - `tokenId` token must be owned by `from`.
1310      *
1311      * Emits a {Transfer} event.
1312      */
1313     function _transfer(
1314         address from,
1315         address to,
1316         uint256 tokenId
1317     ) private {
1318         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1319 
1320         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1321 
1322         bool isApprovedOrOwner = (_msgSender() == from ||
1323             isApprovedForAll(from, _msgSender()) ||
1324             getApproved(tokenId) == _msgSender());
1325 
1326         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1327         if (to == address(0)) revert TransferToZeroAddress();
1328 
1329         _beforeTokenTransfers(from, to, tokenId, 1);
1330 
1331         // Clear approvals from the previous owner
1332         _approve(address(0), tokenId, from);
1333 
1334         // Underflow of the sender's balance is impossible because we check for
1335         // ownership above and the recipient's balance can't realistically overflow.
1336         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1337         unchecked {
1338             _addressData[from].balance -= 1;
1339             _addressData[to].balance += 1;
1340 
1341             TokenOwnership storage currSlot = _ownerships[tokenId];
1342             currSlot.addr = to;
1343             currSlot.startTimestamp = uint64(block.timestamp);
1344 
1345             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1346             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1347             uint256 nextTokenId = tokenId + 1;
1348             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1349             if (nextSlot.addr == address(0)) {
1350                 // This will suffice for checking _exists(nextTokenId),
1351                 // as a burned slot cannot contain the zero address.
1352                 if (nextTokenId != _currentIndex) {
1353                     nextSlot.addr = from;
1354                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1355                 }
1356             }
1357         }
1358 
1359         emit Transfer(from, to, tokenId);
1360         _afterTokenTransfers(from, to, tokenId, 1);
1361     }
1362 
1363     /**
1364      * @dev Equivalent to `_burn(tokenId, false)`.
1365      */
1366     function _burn(uint256 tokenId) internal virtual {
1367         _burn(tokenId, false);
1368     }
1369 
1370     /**
1371      * @dev Destroys `tokenId`.
1372      * The approval is cleared when the token is burned.
1373      *
1374      * Requirements:
1375      *
1376      * - `tokenId` must exist.
1377      *
1378      * Emits a {Transfer} event.
1379      */
1380     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1381         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1382 
1383         address from = prevOwnership.addr;
1384 
1385         if (approvalCheck) {
1386             bool isApprovedOrOwner = (_msgSender() == from ||
1387                 isApprovedForAll(from, _msgSender()) ||
1388                 getApproved(tokenId) == _msgSender());
1389 
1390             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1391         }
1392 
1393         _beforeTokenTransfers(from, address(0), tokenId, 1);
1394 
1395         // Clear approvals from the previous owner
1396         _approve(address(0), tokenId, from);
1397 
1398         // Underflow of the sender's balance is impossible because we check for
1399         // ownership above and the recipient's balance can't realistically overflow.
1400         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1401         unchecked {
1402             AddressData storage addressData = _addressData[from];
1403             addressData.balance -= 1;
1404             addressData.numberBurned += 1;
1405 
1406             // Keep track of who burned the token, and the timestamp of burning.
1407             TokenOwnership storage currSlot = _ownerships[tokenId];
1408             currSlot.addr = from;
1409             currSlot.startTimestamp = uint64(block.timestamp);
1410             currSlot.burned = true;
1411 
1412             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1413             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1414             uint256 nextTokenId = tokenId + 1;
1415             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1416             if (nextSlot.addr == address(0)) {
1417                 // This will suffice for checking _exists(nextTokenId),
1418                 // as a burned slot cannot contain the zero address.
1419                 if (nextTokenId != _currentIndex) {
1420                     nextSlot.addr = from;
1421                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1422                 }
1423             }
1424         }
1425 
1426         emit Transfer(from, address(0), tokenId);
1427         _afterTokenTransfers(from, address(0), tokenId, 1);
1428 
1429         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1430         unchecked {
1431             _burnCounter++;
1432         }
1433     }
1434 
1435     /**
1436      * @dev Approve `to` to operate on `tokenId`
1437      *
1438      * Emits a {Approval} event.
1439      */
1440     function _approve(
1441         address to,
1442         uint256 tokenId,
1443         address owner
1444     ) private {
1445         _tokenApprovals[tokenId] = to;
1446         emit Approval(owner, to, tokenId);
1447     }
1448 
1449     /**
1450      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1451      *
1452      * @param from address representing the previous owner of the given token ID
1453      * @param to target address that will receive the tokens
1454      * @param tokenId uint256 ID of the token to be transferred
1455      * @param _data bytes optional data to send along with the call
1456      * @return bool whether the call correctly returned the expected magic value
1457      */
1458     function _checkContractOnERC721Received(
1459         address from,
1460         address to,
1461         uint256 tokenId,
1462         bytes memory _data
1463     ) private returns (bool) {
1464         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1465             return retval == IERC721Receiver(to).onERC721Received.selector;
1466         } catch (bytes memory reason) {
1467             if (reason.length == 0) {
1468                 revert TransferToNonERC721ReceiverImplementer();
1469             } else {
1470                 assembly {
1471                     revert(add(32, reason), mload(reason))
1472                 }
1473             }
1474         }
1475     }
1476 
1477     /**
1478      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1479      * And also called before burning one token.
1480      *
1481      * startTokenId - the first token id to be transferred
1482      * quantity - the amount to be transferred
1483      *
1484      * Calling conditions:
1485      *
1486      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1487      * transferred to `to`.
1488      * - When `from` is zero, `tokenId` will be minted for `to`.
1489      * - When `to` is zero, `tokenId` will be burned by `from`.
1490      * - `from` and `to` are never both zero.
1491      */
1492     function _beforeTokenTransfers(
1493         address from,
1494         address to,
1495         uint256 startTokenId,
1496         uint256 quantity
1497     ) internal virtual {}
1498 
1499     /**
1500      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1501      * minting.
1502      * And also called after one token has been burned.
1503      *
1504      * startTokenId - the first token id to be transferred
1505      * quantity - the amount to be transferred
1506      *
1507      * Calling conditions:
1508      *
1509      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1510      * transferred to `to`.
1511      * - When `from` is zero, `tokenId` has been minted for `to`.
1512      * - When `to` is zero, `tokenId` has been burned by `from`.
1513      * - `from` and `to` are never both zero.
1514      */
1515     function _afterTokenTransfers(
1516         address from,
1517         address to,
1518         uint256 startTokenId,
1519         uint256 quantity
1520     ) internal virtual {}
1521 }
1522 
1523 // File: contracts/weare.sol
1524 
1525 
1526 
1527 pragma solidity >=0.8.9 <0.9.0;
1528 
1529 
1530 
1531 
1532 
1533 contract WeAre is ERC721A, Ownable, ReentrancyGuard {
1534 
1535   using Strings for uint256;
1536 
1537   bytes32 public merkleRoot;
1538   mapping(address => bool) public whitelistAddressClaimed;
1539   mapping(address => bool) public addressClaimed;
1540 
1541   string public contractURi = "https://gateway.pinata.cloud/ipfs/QmQLTacNdjPWeCKZknda58J7PFfF45ejKnhbv1wCFTB2nG";
1542   string public uriPrefix = '';
1543   string public uriSuffix = '.json';
1544   string public hiddenMetadataUri = "ipfs://QmVJB8B1aSgHoC3Fuerg5eiTrSAN8VJRfwpwLj2tqaBCJJ";
1545   
1546   uint256 public cost = 0 ether;
1547   uint256 public maxSupply = 5000;
1548   uint256 public maxMintAmountPerTx = 1;
1549 
1550   bool public paused = true;
1551   bool public whitelistMintEnabled = false;
1552   bool public revealed = false;
1553 
1554   event minted(address indexed _from, uint256 indexed _amount);
1555   event whitelist(bool _state);
1556   event pause(bool _state);
1557 
1558   constructor(
1559     string memory _tokenName,
1560     string memory _tokenSymbol
1561   ) ERC721A(_tokenName, _tokenSymbol) {
1562   }
1563 
1564   modifier mintCompliance(uint256 _mintAmount) {
1565     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1566     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1567     _;
1568   }
1569 
1570   modifier mintPriceCompliance(uint256 _mintAmount) {
1571     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1572     _;
1573   }
1574 
1575   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount){
1576     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
1577     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1578     require(!whitelistAddressClaimed[_msgSender()], 'Address already claimed!');
1579     
1580     // Verify whitelist requirements
1581     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1582     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'You are not in Whitelist!');
1583 
1584     whitelistAddressClaimed[_msgSender()] = true;
1585     _safeMint(_msgSender(), _mintAmount);
1586     emit minted(msg.sender, _mintAmount);
1587   }
1588 
1589   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount){
1590     require(!paused, 'The contract is paused!');
1591     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1592     require(!addressClaimed[_msgSender()], 'Address already claimed!');
1593 
1594     addressClaimed[_msgSender()] = true;
1595     _safeMint(_msgSender(), _mintAmount);
1596     emit minted(msg.sender, _mintAmount);
1597   }
1598   
1599   // For marketing etc.
1600   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1601     require(_mintAmount > 0 , 'Invalid mint amount!');
1602     _safeMint(_receiver, _mintAmount);
1603   }
1604 
1605   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1606     uint256 ownerTokenCount = balanceOf(_owner);
1607     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1608     uint256 currentTokenId = _startTokenId();
1609     uint256 ownedTokenIndex = 0;
1610     address latestOwnerAddress;
1611 
1612     while (ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex) {
1613       TokenOwnership memory ownership = _ownerships[currentTokenId];
1614 
1615       if (!ownership.burned) {
1616         if (ownership.addr != address(0)) {
1617           latestOwnerAddress = ownership.addr;
1618         }
1619 
1620         if (latestOwnerAddress == _owner) {
1621           ownedTokenIds[ownedTokenIndex] = currentTokenId;
1622 
1623           ownedTokenIndex++;
1624         }
1625       }
1626 
1627       currentTokenId++;
1628     }
1629 
1630     return ownedTokenIds;
1631   }
1632 
1633   function burn(uint256 tokenId) public {
1634     _burn(tokenId, true);
1635   }
1636 
1637   function _startTokenId() internal view virtual override returns (uint256) {
1638     return 1;
1639   }
1640 
1641   function contractURI() public view returns (string memory) {
1642         return contractURi;
1643     }
1644 
1645   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1646     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1647 
1648     if (revealed == false) {
1649       return hiddenMetadataUri;
1650     }
1651 
1652     string memory currentBaseURI = _baseURI();
1653     return bytes(currentBaseURI).length > 0
1654         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1655         : '';
1656   }
1657 
1658   function setContractURI(string memory _newContractURI) public onlyOwner {
1659     contractURi = _newContractURI;
1660   }
1661 
1662   function setRevealed(bool _state) public onlyOwner {
1663     revealed = _state;
1664   }
1665 
1666   function setCost(uint256 _cost) public onlyOwner {
1667     cost = _cost;
1668   }
1669 
1670   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1671     maxMintAmountPerTx = _maxMintAmountPerTx;
1672   }
1673 
1674   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1675     hiddenMetadataUri = _hiddenMetadataUri;
1676   }
1677 
1678   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1679     uriPrefix = _uriPrefix;
1680   }
1681 
1682   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1683     uriSuffix = _uriSuffix;
1684   }
1685 
1686   function setPaused(bool _state) public onlyOwner {
1687     paused = _state;
1688     emit pause(_state);
1689   }
1690 
1691   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1692     merkleRoot = _merkleRoot;
1693   }
1694 
1695   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1696     whitelistMintEnabled = _state;
1697     emit whitelist(_state);
1698   }
1699 
1700   function withdraw() public onlyOwner nonReentrant {
1701     
1702     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1703     require(os);
1704     
1705   }
1706 
1707   function _baseURI() internal view virtual override returns (string memory) {
1708     return uriPrefix;
1709   }
1710 }