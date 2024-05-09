1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
39      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
40      * hash matches the root of the tree. When processing the proof, the pairs
41      * of leafs & pre-images are assumed to be sorted.
42      *
43      * _Available since v4.4._
44      */
45     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
46         bytes32 computedHash = leaf;
47         for (uint256 i = 0; i < proof.length; i++) {
48             bytes32 proofElement = proof[i];
49             if (computedHash <= proofElement) {
50                 // Hash(current computed hash + current element of the proof)
51                 computedHash = _efficientHash(computedHash, proofElement);
52             } else {
53                 // Hash(current element of the proof + current computed hash)
54                 computedHash = _efficientHash(proofElement, computedHash);
55             }
56         }
57         return computedHash;
58     }
59 
60     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
61         assembly {
62             mstore(0x00, a)
63             mstore(0x20, b)
64             value := keccak256(0x00, 0x40)
65         }
66     }
67 }
68 
69 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Contract module that helps prevent reentrant calls to a function.
78  *
79  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
80  * available, which can be applied to functions to make sure there are no nested
81  * (reentrant) calls to them.
82  *
83  * Note that because there is a single `nonReentrant` guard, functions marked as
84  * `nonReentrant` may not call one another. This can be worked around by making
85  * those functions `private`, and then adding `external` `nonReentrant` entry
86  * points to them.
87  *
88  * TIP: If you would like to learn more about reentrancy and alternative ways
89  * to protect against it, check out our blog post
90  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
91  */
92 abstract contract ReentrancyGuard {
93     // Booleans are more expensive than uint256 or any type that takes up a full
94     // word because each write operation emits an extra SLOAD to first read the
95     // slot's contents, replace the bits taken up by the boolean, and then write
96     // back. This is the compiler's defense against contract upgrades and
97     // pointer aliasing, and it cannot be disabled.
98 
99     // The values being non-zero value makes deployment a bit more expensive,
100     // but in exchange the refund on every call to nonReentrant will be lower in
101     // amount. Since refunds are capped to a percentage of the total
102     // transaction's gas, it is best to keep them low in cases like this one, to
103     // increase the likelihood of the full refund coming into effect.
104     uint256 private constant _NOT_ENTERED = 1;
105     uint256 private constant _ENTERED = 2;
106 
107     uint256 private _status;
108 
109     constructor() {
110         _status = _NOT_ENTERED;
111     }
112 
113     /**
114      * @dev Prevents a contract from calling itself, directly or indirectly.
115      * Calling a `nonReentrant` function from another `nonReentrant`
116      * function is not supported. It is possible to prevent this from happening
117      * by making the `nonReentrant` function external, and making it call a
118      * `private` function that does the actual work.
119      */
120     modifier nonReentrant() {
121         // On the first call to nonReentrant, _notEntered will be true
122         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
123 
124         // Any calls to nonReentrant after this point will fail
125         _status = _ENTERED;
126 
127         _;
128 
129         // By storing the original value once again, a refund is triggered (see
130         // https://eips.ethereum.org/EIPS/eip-2200)
131         _status = _NOT_ENTERED;
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
769 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
770 
771 
772 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
773 
774 pragma solidity ^0.8.0;
775 
776 
777 /**
778  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
779  * @dev See https://eips.ethereum.org/EIPS/eip-721
780  */
781 interface IERC721Enumerable is IERC721 {
782     /**
783      * @dev Returns the total amount of tokens stored by the contract.
784      */
785     function totalSupply() external view returns (uint256);
786 
787     /**
788      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
789      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
790      */
791     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
792 
793     /**
794      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
795      * Use along with {totalSupply} to enumerate all tokens.
796      */
797     function tokenByIndex(uint256 index) external view returns (uint256);
798 }
799 
800 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
801 
802 
803 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
804 
805 pragma solidity ^0.8.0;
806 
807 
808 /**
809  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
810  * @dev See https://eips.ethereum.org/EIPS/eip-721
811  */
812 interface IERC721Metadata is IERC721 {
813     /**
814      * @dev Returns the token collection name.
815      */
816     function name() external view returns (string memory);
817 
818     /**
819      * @dev Returns the token collection symbol.
820      */
821     function symbol() external view returns (string memory);
822 
823     /**
824      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
825      */
826     function tokenURI(uint256 tokenId) external view returns (string memory);
827 }
828 
829 // File: ERC721A.sol
830 
831 
832 // Creator: Chiru Labs
833 
834 pragma solidity ^0.8.4;
835 
836 
837 
838 
839 
840 
841 
842 
843 
844 error ApprovalCallerNotOwnerNorApproved();
845 error ApprovalQueryForNonexistentToken();
846 error ApproveToCaller();
847 error ApprovalToCurrentOwner();
848 error BalanceQueryForZeroAddress();
849 error MintedQueryForZeroAddress();
850 error MintToZeroAddress();
851 error MintZeroQuantity();
852 error OwnerIndexOutOfBounds();
853 error OwnerQueryForNonexistentToken();
854 error TokenIndexOutOfBounds();
855 error TransferCallerNotOwnerNorApproved();
856 error TransferFromIncorrectOwner();
857 error TransferToNonERC721ReceiverImplementer();
858 error TransferToZeroAddress();
859 error UnableDetermineTokenOwner();
860 error URIQueryForNonexistentToken();
861 
862 /**
863  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
864  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
865  *
866  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
867  *
868  * Does not support burning tokens to address(0).
869  *
870  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
871  */
872 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
873     using Address for address;
874     using Strings for uint256;
875 
876     struct TokenOwnership {
877         address addr;
878         uint64 startTimestamp;
879     }
880 
881     struct AddressData {
882         uint128 balance;
883         uint128 numberMinted;
884     }
885 
886     uint256 internal _currentIndex;
887 
888     // Token name
889     string private _name;
890 
891     // Token symbol
892     string private _symbol;
893 
894     // Mapping from token ID to ownership details
895     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
896     mapping(uint256 => TokenOwnership) internal _ownerships;
897 
898     // Mapping owner address to address data
899     mapping(address => AddressData) private _addressData;
900 
901     // Mapping from token ID to approved address
902     mapping(uint256 => address) private _tokenApprovals;
903 
904     // Mapping from owner to operator approvals
905     mapping(address => mapping(address => bool)) private _operatorApprovals;
906 
907     constructor(string memory name_, string memory symbol_) {
908         _name = name_;
909         _symbol = symbol_;
910     }
911 
912     /**
913      * @dev See {IERC721Enumerable-totalSupply}.
914      */
915     function totalSupply() public view override returns (uint256) {
916         return _currentIndex;
917     }
918 
919     /**
920      * @dev See {IERC721Enumerable-tokenByIndex}.
921      */
922     function tokenByIndex(uint256 index) public view override returns (uint256) {
923         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
924         return index;
925     }
926 
927     /**
928      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
929      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
930      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
931      */
932     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
933         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
934         uint256 numMintedSoFar = totalSupply();
935         uint256 tokenIdsIdx;
936         address currOwnershipAddr;
937 
938         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
939         unchecked {
940             for (uint256 i; i < numMintedSoFar; i++) {
941                 TokenOwnership memory ownership = _ownerships[i];
942                 if (ownership.addr != address(0)) {
943                     currOwnershipAddr = ownership.addr;
944                 }
945                 if (currOwnershipAddr == owner) {
946                     if (tokenIdsIdx == index) {
947                         return i;
948                     }
949                     tokenIdsIdx++;
950                 }
951             }
952         }
953 
954         // Execution should never reach this point.
955         assert(false);
956     }
957 
958     /**
959      * @dev See {IERC165-supportsInterface}.
960      */
961     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
962         return
963             interfaceId == type(IERC721).interfaceId ||
964             interfaceId == type(IERC721Metadata).interfaceId ||
965             interfaceId == type(IERC721Enumerable).interfaceId ||
966             super.supportsInterface(interfaceId);
967     }
968 
969     /**
970      * @dev See {IERC721-balanceOf}.
971      */
972     function balanceOf(address owner) public view override returns (uint256) {
973         if (owner == address(0)) revert BalanceQueryForZeroAddress();
974         return uint256(_addressData[owner].balance);
975     }
976 
977     function _numberMinted(address owner) internal view returns (uint256) {
978         if (owner == address(0)) revert MintedQueryForZeroAddress();
979         return uint256(_addressData[owner].numberMinted);
980     }
981 
982     /**
983      * Gas spent here starts off proportional to the maximum mint batch size.
984      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
985      */
986     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
987         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
988 
989         unchecked {
990             for (uint256 curr = tokenId;; curr--) {
991                 TokenOwnership memory ownership = _ownerships[curr];
992                 if (ownership.addr != address(0)) {
993                     return ownership;
994                 }
995             }
996         }
997     }
998 
999     /**
1000      * @dev See {IERC721-ownerOf}.
1001      */
1002     function ownerOf(uint256 tokenId) public view override returns (address) {
1003         return ownershipOf(tokenId).addr;
1004     }
1005 
1006     /**
1007      * @dev See {IERC721Metadata-name}.
1008      */
1009     function name() public view virtual override returns (string memory) {
1010         return _name;
1011     }
1012 
1013     /**
1014      * @dev See {IERC721Metadata-symbol}.
1015      */
1016     function symbol() public view virtual override returns (string memory) {
1017         return _symbol;
1018     }
1019 
1020     /**
1021      * @dev See {IERC721Metadata-tokenURI}.
1022      */
1023     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1024         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1025 
1026         string memory baseURI = _baseURI();
1027         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1028     }
1029 
1030     /**
1031      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1032      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1033      * by default, can be overriden in child contracts.
1034      */
1035     function _baseURI() internal view virtual returns (string memory) {
1036         return '';
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-approve}.
1041      */
1042     function approve(address to, uint256 tokenId) public override {
1043         address owner = ERC721A.ownerOf(tokenId);
1044         if (to == owner) revert ApprovalToCurrentOwner();
1045 
1046         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) revert ApprovalCallerNotOwnerNorApproved();
1047 
1048         _approve(to, tokenId, owner);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-getApproved}.
1053      */
1054     function getApproved(uint256 tokenId) public view override returns (address) {
1055         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1056 
1057         return _tokenApprovals[tokenId];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-setApprovalForAll}.
1062      */
1063     function setApprovalForAll(address operator, bool approved) public override {
1064         if (operator == _msgSender()) revert ApproveToCaller();
1065 
1066         _operatorApprovals[_msgSender()][operator] = approved;
1067         emit ApprovalForAll(_msgSender(), operator, approved);
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-isApprovedForAll}.
1072      */
1073     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1074         return _operatorApprovals[owner][operator];
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-transferFrom}.
1079      */
1080     function transferFrom(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) public virtual override {
1085         _transfer(from, to, tokenId);
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-safeTransferFrom}.
1090      */
1091     function safeTransferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) public virtual override {
1096         safeTransferFrom(from, to, tokenId, '');
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-safeTransferFrom}.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes memory _data
1107     ) public override {
1108         _transfer(from, to, tokenId);
1109         if (!_checkOnERC721Received(from, to, tokenId, _data)) revert TransferToNonERC721ReceiverImplementer();
1110     }
1111 
1112     /**
1113      * @dev Returns whether `tokenId` exists.
1114      *
1115      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1116      *
1117      * Tokens start existing when they are minted (`_mint`),
1118      */
1119     function _exists(uint256 tokenId) internal view returns (bool) {
1120         return tokenId < _currentIndex;
1121     }
1122 
1123     function _safeMint(address to, uint256 quantity) internal {
1124         _safeMint(to, quantity, '');
1125     }
1126 
1127     /**
1128      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1129      *
1130      * Requirements:
1131      *
1132      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1133      * - `quantity` must be greater than 0.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function _safeMint(
1138         address to,
1139         uint256 quantity,
1140         bytes memory _data
1141     ) internal {
1142         _mint(to, quantity, _data, true);
1143     }
1144 
1145     /**
1146      * @dev Mints `quantity` tokens and transfers them to `to`.
1147      *
1148      * Requirements:
1149      *
1150      * - `to` cannot be the zero address.
1151      * - `quantity` must be greater than 0.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _mint(
1156         address to,
1157         uint256 quantity,
1158         bytes memory _data,
1159         bool safe
1160     ) internal {
1161         uint256 startTokenId = _currentIndex;
1162         if (to == address(0)) revert MintToZeroAddress();
1163         if (quantity == 0) revert MintZeroQuantity();
1164 
1165         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1166 
1167         // Overflows are incredibly unrealistic.
1168         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1169         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
1170         unchecked {
1171             _addressData[to].balance += uint128(quantity);
1172             _addressData[to].numberMinted += uint128(quantity);
1173 
1174             _ownerships[startTokenId].addr = to;
1175             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1176 
1177             uint256 updatedIndex = startTokenId;
1178 
1179             for (uint256 i; i < quantity; i++) {
1180                 emit Transfer(address(0), to, updatedIndex);
1181                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1182                     revert TransferToNonERC721ReceiverImplementer();
1183                 }
1184 
1185                 updatedIndex++;
1186             }
1187 
1188             _currentIndex = updatedIndex;
1189         }
1190 
1191         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1192     }
1193 
1194     /**
1195      * @dev Transfers `tokenId` from `from` to `to`.
1196      *
1197      * Requirements:
1198      *
1199      * - `to` cannot be the zero address.
1200      * - `tokenId` token must be owned by `from`.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function _transfer(
1205         address from,
1206         address to,
1207         uint256 tokenId
1208     ) private {
1209         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1210 
1211         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1212             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1213             getApproved(tokenId) == _msgSender());
1214 
1215         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1216         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1217         if (to == address(0)) revert TransferToZeroAddress();
1218 
1219         _beforeTokenTransfers(from, to, tokenId, 1);
1220 
1221         // Clear approvals from the previous owner
1222         _approve(address(0), tokenId, prevOwnership.addr);
1223 
1224         // Underflow of the sender's balance is impossible because we check for
1225         // ownership above and the recipient's balance can't realistically overflow.
1226         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1227         unchecked {
1228             _addressData[from].balance -= 1;
1229             _addressData[to].balance += 1;
1230 
1231             _ownerships[tokenId].addr = to;
1232             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1233 
1234             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1235             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1236             uint256 nextTokenId = tokenId + 1;
1237             if (_ownerships[nextTokenId].addr == address(0)) {
1238                 if (_exists(nextTokenId)) {
1239                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1240                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1241                 }
1242             }
1243         }
1244 
1245         emit Transfer(from, to, tokenId);
1246         _afterTokenTransfers(from, to, tokenId, 1);
1247     }
1248 
1249     /**
1250      * @dev Approve `to` to operate on `tokenId`
1251      *
1252      * Emits a {Approval} event.
1253      */
1254     function _approve(
1255         address to,
1256         uint256 tokenId,
1257         address owner
1258     ) private {
1259         _tokenApprovals[tokenId] = to;
1260         emit Approval(owner, to, tokenId);
1261     }
1262 
1263     /**
1264      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1265      * The call is not executed if the target address is not a contract.
1266      *
1267      * @param from address representing the previous owner of the given token ID
1268      * @param to target address that will receive the tokens
1269      * @param tokenId uint256 ID of the token to be transferred
1270      * @param _data bytes optional data to send along with the call
1271      * @return bool whether the call correctly returned the expected magic value
1272      */
1273     function _checkOnERC721Received(
1274         address from,
1275         address to,
1276         uint256 tokenId,
1277         bytes memory _data
1278     ) private returns (bool) {
1279         if (to.isContract()) {
1280             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1281                 return retval == IERC721Receiver(to).onERC721Received.selector;
1282             } catch (bytes memory reason) {
1283                 if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
1284                 else {
1285                     assembly {
1286                         revert(add(32, reason), mload(reason))
1287                     }
1288                 }
1289             }
1290         } else {
1291             return true;
1292         }
1293     }
1294 
1295     /**
1296      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1297      *
1298      * startTokenId - the first token id to be transferred
1299      * quantity - the amount to be transferred
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` will be minted for `to`.
1306      */
1307     function _beforeTokenTransfers(
1308         address from,
1309         address to,
1310         uint256 startTokenId,
1311         uint256 quantity
1312     ) internal virtual {}
1313 
1314     /**
1315      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1316      * minting.
1317      *
1318      * startTokenId - the first token id to be transferred
1319      * quantity - the amount to be transferred
1320      *
1321      * Calling conditions:
1322      *
1323      * - when `from` and `to` are both non-zero.
1324      * - `from` and `to` are never both zero.
1325      */
1326     function _afterTokenTransfers(
1327         address from,
1328         address to,
1329         uint256 startTokenId,
1330         uint256 quantity
1331     ) internal virtual {}
1332 }
1333 // File: ComicCover.sol
1334 
1335 
1336 // Creator: ZombieDaoDev
1337 
1338 pragma solidity ^0.8.4;
1339 
1340 
1341 
1342 
1343 
1344 contract IERC20 {
1345     function transferFrom(
1346         address sender,
1347         address recipient,
1348         uint256 amount
1349     ) public returns (bool) {}
1350 
1351     function transfer(address recipient, uint256 amount)
1352         public
1353         returns (bool)
1354     {}
1355 
1356     function balanceOf(address account) public view returns (uint256) {}
1357 }
1358 
1359 contract ComicCover is ERC721A, Ownable, ReentrancyGuard {
1360     uint256 public nftPrice = 0.02 ether;
1361     uint256 public tknPrice = 500 ether;
1362 
1363     uint256 public nftLimit = 999;
1364     uint256 public reserved = 99;
1365     uint256 public capPublic = 4;
1366     uint256 public capToken = 4;
1367 
1368     uint256 public freeMultiple = 2;
1369     address public tokenAddress;
1370 
1371     bool public saleOpen = false;
1372     bool public saleToken = false;
1373 
1374     bool public whitelistLimit = true;
1375 
1376     bytes32 public merkleRoot;
1377 
1378     string public baseURI = "";
1379 
1380     mapping(address => uint256) public whitelistAddresses;
1381 
1382     constructor(
1383         string memory _name,
1384         string memory _symbol,
1385         string memory _initURI,
1386         bytes32 _merkleRoot,
1387         address _tokenAddress
1388     ) ERC721A(_name, _symbol) {
1389         baseURI = _initURI;
1390         merkleRoot = _merkleRoot;
1391         tokenAddress = _tokenAddress;
1392     }
1393 
1394     function _mint(address _to, uint256 _amount) internal {
1395         require(tx.origin == msg.sender, "ComicCover: Self Mint Only");
1396         uint256 _mintAmount = _amount + (_amount / freeMultiple);
1397         require(
1398             totalSupply() + _mintAmount <= (nftLimit - reserved),
1399             "ComicCover: Sold Out"
1400         );
1401         _safeMint(_to, _mintAmount);
1402     }
1403 
1404     function mint(address _to, uint256 _amount) public payable {
1405         require(saleOpen == true, "ComicCover: Not Started");
1406         require(_amount <= capPublic, "ComicCover: Amount Limit");
1407         require(msg.value == nftPrice * _amount, "ComicCover: Incorrect Value");
1408         _mint(_to, _amount);
1409     }
1410 
1411     function mintToken(uint256 _amount, bytes32[] calldata proof) public {
1412         require(saleToken == true, "ComicCover: Not Started");
1413         require(_amount <= capToken, "ComicCover: Amount Limit");
1414         if (whitelistLimit) {
1415             require(
1416                 MerkleProof.verify(
1417                     proof,
1418                     merkleRoot,
1419                     keccak256(abi.encodePacked(_msgSender()))
1420                 ),
1421                 "ComicCover: Not Whitelisted"
1422             );
1423             require(
1424                 whitelistAddresses[_msgSender()] + _amount <= capToken,
1425                 "ComicCover: Token Limit"
1426             );
1427         }
1428         IERC20(tokenAddress).transferFrom(
1429             _msgSender(),
1430             address(this),
1431             tknPrice * _amount
1432         );
1433         _mint(_msgSender(), _amount);
1434         whitelistAddresses[_msgSender()] += _amount;
1435     }
1436 
1437     function airdrop(address[] memory _to, uint256[] memory _amount)
1438         public
1439         onlyOwner
1440     {
1441         require(_to.length == _amount.length, "ComicCover: Length Missmatch");
1442         for (uint256 i = 0; i < _to.length; i++) {
1443             require(
1444                 totalSupply() + _amount[i] <= nftLimit,
1445                 "ComicCover: Sold Out"
1446             );
1447             _safeMint(_to[i], _amount[i]);
1448 
1449             if (reserved > 0 && reserved >= _amount[i]) {
1450                 reserved -= _amount[i];
1451             } else {
1452                 reserved = 0;
1453             }
1454         }
1455     }
1456 
1457     function tokensOfOwnerByIndex(address _owner, uint256 _index)
1458         public
1459         view
1460         returns (uint256)
1461     {
1462         return tokensOfOwner(_owner)[_index];
1463     }
1464 
1465     function tokensOfOwner(address _owner)
1466         public
1467         view
1468         returns (uint256[] memory)
1469     {
1470         uint256 _tokenCount = balanceOf(_owner);
1471         uint256[] memory _tokenIds = new uint256[](_tokenCount);
1472         uint256 _tokenIndex = 0;
1473         for (uint256 i = 0; i < totalSupply(); i++) {
1474             if (ownerOf(i) == _owner) {
1475                 _tokenIds[_tokenIndex] = i;
1476                 _tokenIndex++;
1477             }
1478         }
1479         return _tokenIds;
1480     }
1481 
1482     function toggleSaleOpen() public onlyOwner {
1483         saleOpen = !saleOpen;
1484     }
1485 
1486     function toggleSaleToken() public onlyOwner {
1487         saleToken = !saleToken;
1488     }
1489 
1490     function toggleWhitelistLimit() public onlyOwner {
1491         whitelistLimit = !whitelistLimit;
1492     }
1493 
1494     function setNftPrice(uint256 _nftPrice) public onlyOwner {
1495         nftPrice = _nftPrice;
1496     }
1497 
1498     function setTknPrice(uint256 _tknPrice) public onlyOwner {
1499         tknPrice = _tknPrice;
1500     }
1501 
1502     function withdraw() public onlyOwner {
1503         (bool transfer, ) = payable(_msgSender()).call{
1504             value: address(this).balance
1505         }("");
1506         require(transfer, "ComicCover: Transfer Failed");
1507         IERC20(tokenAddress).transfer(
1508             _msgSender(),
1509             IERC20(tokenAddress).balanceOf(address(this))
1510         );
1511     }
1512 
1513     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1514         baseURI = _newBaseURI;
1515     }
1516 
1517     function _baseURI() internal view virtual override returns (string memory) {
1518         return baseURI;
1519     }
1520 
1521     function contractURI() public view returns (string memory) {
1522         return string(abi.encodePacked(baseURI, "contract"));
1523     }
1524 
1525     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1526         merkleRoot = _merkleRoot;
1527     }
1528 }