1 // Sources flattened with hardhat v2.7.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
32 
33 // 
34 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 
109 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.1
110 
111 // 
112 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 /**
117  * @dev Contract module that helps prevent reentrant calls to a function.
118  *
119  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
120  * available, which can be applied to functions to make sure there are no nested
121  * (reentrant) calls to them.
122  *
123  * Note that because there is a single `nonReentrant` guard, functions marked as
124  * `nonReentrant` may not call one another. This can be worked around by making
125  * those functions `private`, and then adding `external` `nonReentrant` entry
126  * points to them.
127  *
128  * TIP: If you would like to learn more about reentrancy and alternative ways
129  * to protect against it, check out our blog post
130  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
131  */
132 abstract contract ReentrancyGuard {
133     // Booleans are more expensive than uint256 or any type that takes up a full
134     // word because each write operation emits an extra SLOAD to first read the
135     // slot's contents, replace the bits taken up by the boolean, and then write
136     // back. This is the compiler's defense against contract upgrades and
137     // pointer aliasing, and it cannot be disabled.
138 
139     // The values being non-zero value makes deployment a bit more expensive,
140     // but in exchange the refund on every call to nonReentrant will be lower in
141     // amount. Since refunds are capped to a percentage of the total
142     // transaction's gas, it is best to keep them low in cases like this one, to
143     // increase the likelihood of the full refund coming into effect.
144     uint256 private constant _NOT_ENTERED = 1;
145     uint256 private constant _ENTERED = 2;
146 
147     uint256 private _status;
148 
149     constructor() {
150         _status = _NOT_ENTERED;
151     }
152 
153     /**
154      * @dev Prevents a contract from calling itself, directly or indirectly.
155      * Calling a `nonReentrant` function from another `nonReentrant`
156      * function is not supported. It is possible to prevent this from happening
157      * by making the `nonReentrant` function external, and making it call a
158      * `private` function that does the actual work.
159      */
160     modifier nonReentrant() {
161         // On the first call to nonReentrant, _notEntered will be true
162         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
163 
164         // Any calls to nonReentrant after this point will fail
165         _status = _ENTERED;
166 
167         _;
168 
169         // By storing the original value once again, a refund is triggered (see
170         // https://eips.ethereum.org/EIPS/eip-2200)
171         _status = _NOT_ENTERED;
172     }
173 }
174 
175 
176 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.4.1
177 
178 // 
179 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @dev These functions deal with verification of Merkle Trees proofs.
185  *
186  * The proofs can be generated using the JavaScript library
187  * https://github.com/miguelmota/merkletreejs[merkletreejs].
188  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
189  *
190  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
191  */
192 library MerkleProof {
193     /**
194      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
195      * defined by `root`. For this, a `proof` must be provided, containing
196      * sibling hashes on the branch from the leaf to the root of the tree. Each
197      * pair of leaves and each pair of pre-images are assumed to be sorted.
198      */
199     function verify(
200         bytes32[] memory proof,
201         bytes32 root,
202         bytes32 leaf
203     ) internal pure returns (bool) {
204         return processProof(proof, leaf) == root;
205     }
206 
207     /**
208      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
209      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
210      * hash matches the root of the tree. When processing the proof, the pairs
211      * of leafs & pre-images are assumed to be sorted.
212      *
213      * _Available since v4.4._
214      */
215     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
216         bytes32 computedHash = leaf;
217         for (uint256 i = 0; i < proof.length; i++) {
218             bytes32 proofElement = proof[i];
219             if (computedHash <= proofElement) {
220                 // Hash(current computed hash + current element of the proof)
221                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
222             } else {
223                 // Hash(current element of the proof + current computed hash)
224                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
225             }
226         }
227         return computedHash;
228     }
229 }
230 
231 
232 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.1
233 
234 // 
235 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev String operations.
241  */
242 library Strings {
243     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
244 
245     /**
246      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
247      */
248     function toString(uint256 value) internal pure returns (string memory) {
249         // Inspired by OraclizeAPI's implementation - MIT licence
250         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
251 
252         if (value == 0) {
253             return "0";
254         }
255         uint256 temp = value;
256         uint256 digits;
257         while (temp != 0) {
258             digits++;
259             temp /= 10;
260         }
261         bytes memory buffer = new bytes(digits);
262         while (value != 0) {
263             digits -= 1;
264             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
265             value /= 10;
266         }
267         return string(buffer);
268     }
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
272      */
273     function toHexString(uint256 value) internal pure returns (string memory) {
274         if (value == 0) {
275             return "0x00";
276         }
277         uint256 temp = value;
278         uint256 length = 0;
279         while (temp != 0) {
280             length++;
281             temp >>= 8;
282         }
283         return toHexString(value, length);
284     }
285 
286     /**
287      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
288      */
289     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
290         bytes memory buffer = new bytes(2 * length + 2);
291         buffer[0] = "0";
292         buffer[1] = "x";
293         for (uint256 i = 2 * length + 1; i > 1; --i) {
294             buffer[i] = _HEX_SYMBOLS[value & 0xf];
295             value >>= 4;
296         }
297         require(value == 0, "Strings: hex length insufficient");
298         return string(buffer);
299     }
300 }
301 
302 
303 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.1
304 
305 // 
306 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @dev Interface of the ERC165 standard, as defined in the
312  * https://eips.ethereum.org/EIPS/eip-165[EIP].
313  *
314  * Implementers can declare support of contract interfaces, which can then be
315  * queried by others ({ERC165Checker}).
316  *
317  * For an implementation, see {ERC165}.
318  */
319 interface IERC165 {
320     /**
321      * @dev Returns true if this contract implements the interface defined by
322      * `interfaceId`. See the corresponding
323      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
324      * to learn more about how these ids are created.
325      *
326      * This function call must use less than 30 000 gas.
327      */
328     function supportsInterface(bytes4 interfaceId) external view returns (bool);
329 }
330 
331 
332 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.1
333 
334 // 
335 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Required interface of an ERC721 compliant contract.
341  */
342 interface IERC721 is IERC165 {
343     /**
344      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
345      */
346     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
347 
348     /**
349      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
350      */
351     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
352 
353     /**
354      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
355      */
356     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
357 
358     /**
359      * @dev Returns the number of tokens in ``owner``'s account.
360      */
361     function balanceOf(address owner) external view returns (uint256 balance);
362 
363     /**
364      * @dev Returns the owner of the `tokenId` token.
365      *
366      * Requirements:
367      *
368      * - `tokenId` must exist.
369      */
370     function ownerOf(uint256 tokenId) external view returns (address owner);
371 
372     /**
373      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
374      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
375      *
376      * Requirements:
377      *
378      * - `from` cannot be the zero address.
379      * - `to` cannot be the zero address.
380      * - `tokenId` token must exist and be owned by `from`.
381      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
382      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
383      *
384      * Emits a {Transfer} event.
385      */
386     function safeTransferFrom(
387         address from,
388         address to,
389         uint256 tokenId
390     ) external;
391 
392     /**
393      * @dev Transfers `tokenId` token from `from` to `to`.
394      *
395      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
396      *
397      * Requirements:
398      *
399      * - `from` cannot be the zero address.
400      * - `to` cannot be the zero address.
401      * - `tokenId` token must be owned by `from`.
402      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
403      *
404      * Emits a {Transfer} event.
405      */
406     function transferFrom(
407         address from,
408         address to,
409         uint256 tokenId
410     ) external;
411 
412     /**
413      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
414      * The approval is cleared when the token is transferred.
415      *
416      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
417      *
418      * Requirements:
419      *
420      * - The caller must own the token or be an approved operator.
421      * - `tokenId` must exist.
422      *
423      * Emits an {Approval} event.
424      */
425     function approve(address to, uint256 tokenId) external;
426 
427     /**
428      * @dev Returns the account approved for `tokenId` token.
429      *
430      * Requirements:
431      *
432      * - `tokenId` must exist.
433      */
434     function getApproved(uint256 tokenId) external view returns (address operator);
435 
436     /**
437      * @dev Approve or remove `operator` as an operator for the caller.
438      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
439      *
440      * Requirements:
441      *
442      * - The `operator` cannot be the caller.
443      *
444      * Emits an {ApprovalForAll} event.
445      */
446     function setApprovalForAll(address operator, bool _approved) external;
447 
448     /**
449      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
450      *
451      * See {setApprovalForAll}
452      */
453     function isApprovedForAll(address owner, address operator) external view returns (bool);
454 
455     /**
456      * @dev Safely transfers `tokenId` token from `from` to `to`.
457      *
458      * Requirements:
459      *
460      * - `from` cannot be the zero address.
461      * - `to` cannot be the zero address.
462      * - `tokenId` token must exist and be owned by `from`.
463      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
464      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId,
472         bytes calldata data
473     ) external;
474 }
475 
476 
477 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.1
478 
479 // 
480 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @title ERC721 token receiver interface
486  * @dev Interface for any contract that wants to support safeTransfers
487  * from ERC721 asset contracts.
488  */
489 interface IERC721Receiver {
490     /**
491      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
492      * by `operator` from `from`, this function is called.
493      *
494      * It must return its Solidity selector to confirm the token transfer.
495      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
496      *
497      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
498      */
499     function onERC721Received(
500         address operator,
501         address from,
502         uint256 tokenId,
503         bytes calldata data
504     ) external returns (bytes4);
505 }
506 
507 
508 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.1
509 
510 // 
511 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
517  * @dev See https://eips.ethereum.org/EIPS/eip-721
518  */
519 interface IERC721Metadata is IERC721 {
520     /**
521      * @dev Returns the token collection name.
522      */
523     function name() external view returns (string memory);
524 
525     /**
526      * @dev Returns the token collection symbol.
527      */
528     function symbol() external view returns (string memory);
529 
530     /**
531      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
532      */
533     function tokenURI(uint256 tokenId) external view returns (string memory);
534 }
535 
536 
537 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.1
538 
539 // 
540 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
546  * @dev See https://eips.ethereum.org/EIPS/eip-721
547  */
548 interface IERC721Enumerable is IERC721 {
549     /**
550      * @dev Returns the total amount of tokens stored by the contract.
551      */
552     function totalSupply() external view returns (uint256);
553 
554     /**
555      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
556      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
557      */
558     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
559 
560     /**
561      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
562      * Use along with {totalSupply} to enumerate all tokens.
563      */
564     function tokenByIndex(uint256 index) external view returns (uint256);
565 }
566 
567 
568 // File @openzeppelin/contracts/utils/Address.sol@v4.4.1
569 
570 // 
571 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @dev Collection of functions related to the address type
577  */
578 library Address {
579     /**
580      * @dev Returns true if `account` is a contract.
581      *
582      * [IMPORTANT]
583      * ====
584      * It is unsafe to assume that an address for which this function returns
585      * false is an externally-owned account (EOA) and not a contract.
586      *
587      * Among others, `isContract` will return false for the following
588      * types of addresses:
589      *
590      *  - an externally-owned account
591      *  - a contract in construction
592      *  - an address where a contract will be created
593      *  - an address where a contract lived, but was destroyed
594      * ====
595      */
596     function isContract(address account) internal view returns (bool) {
597         // This method relies on extcodesize, which returns 0 for contracts in
598         // construction, since the code is only stored at the end of the
599         // constructor execution.
600 
601         uint256 size;
602         assembly {
603             size := extcodesize(account)
604         }
605         return size > 0;
606     }
607 
608     /**
609      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
610      * `recipient`, forwarding all available gas and reverting on errors.
611      *
612      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
613      * of certain opcodes, possibly making contracts go over the 2300 gas limit
614      * imposed by `transfer`, making them unable to receive funds via
615      * `transfer`. {sendValue} removes this limitation.
616      *
617      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
618      *
619      * IMPORTANT: because control is transferred to `recipient`, care must be
620      * taken to not create reentrancy vulnerabilities. Consider using
621      * {ReentrancyGuard} or the
622      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
623      */
624     function sendValue(address payable recipient, uint256 amount) internal {
625         require(address(this).balance >= amount, "Address: insufficient balance");
626 
627         (bool success, ) = recipient.call{value: amount}("");
628         require(success, "Address: unable to send value, recipient may have reverted");
629     }
630 
631     /**
632      * @dev Performs a Solidity function call using a low level `call`. A
633      * plain `call` is an unsafe replacement for a function call: use this
634      * function instead.
635      *
636      * If `target` reverts with a revert reason, it is bubbled up by this
637      * function (like regular Solidity function calls).
638      *
639      * Returns the raw returned data. To convert to the expected return value,
640      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
641      *
642      * Requirements:
643      *
644      * - `target` must be a contract.
645      * - calling `target` with `data` must not revert.
646      *
647      * _Available since v3.1._
648      */
649     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
650         return functionCall(target, data, "Address: low-level call failed");
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
655      * `errorMessage` as a fallback revert reason when `target` reverts.
656      *
657      * _Available since v3.1._
658      */
659     function functionCall(
660         address target,
661         bytes memory data,
662         string memory errorMessage
663     ) internal returns (bytes memory) {
664         return functionCallWithValue(target, data, 0, errorMessage);
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
669      * but also transferring `value` wei to `target`.
670      *
671      * Requirements:
672      *
673      * - the calling contract must have an ETH balance of at least `value`.
674      * - the called Solidity function must be `payable`.
675      *
676      * _Available since v3.1._
677      */
678     function functionCallWithValue(
679         address target,
680         bytes memory data,
681         uint256 value
682     ) internal returns (bytes memory) {
683         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
684     }
685 
686     /**
687      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
688      * with `errorMessage` as a fallback revert reason when `target` reverts.
689      *
690      * _Available since v3.1._
691      */
692     function functionCallWithValue(
693         address target,
694         bytes memory data,
695         uint256 value,
696         string memory errorMessage
697     ) internal returns (bytes memory) {
698         require(address(this).balance >= value, "Address: insufficient balance for call");
699         require(isContract(target), "Address: call to non-contract");
700 
701         (bool success, bytes memory returndata) = target.call{value: value}(data);
702         return verifyCallResult(success, returndata, errorMessage);
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
707      * but performing a static call.
708      *
709      * _Available since v3.3._
710      */
711     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
712         return functionStaticCall(target, data, "Address: low-level static call failed");
713     }
714 
715     /**
716      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
717      * but performing a static call.
718      *
719      * _Available since v3.3._
720      */
721     function functionStaticCall(
722         address target,
723         bytes memory data,
724         string memory errorMessage
725     ) internal view returns (bytes memory) {
726         require(isContract(target), "Address: static call to non-contract");
727 
728         (bool success, bytes memory returndata) = target.staticcall(data);
729         return verifyCallResult(success, returndata, errorMessage);
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
734      * but performing a delegate call.
735      *
736      * _Available since v3.4._
737      */
738     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
739         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
744      * but performing a delegate call.
745      *
746      * _Available since v3.4._
747      */
748     function functionDelegateCall(
749         address target,
750         bytes memory data,
751         string memory errorMessage
752     ) internal returns (bytes memory) {
753         require(isContract(target), "Address: delegate call to non-contract");
754 
755         (bool success, bytes memory returndata) = target.delegatecall(data);
756         return verifyCallResult(success, returndata, errorMessage);
757     }
758 
759     /**
760      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
761      * revert reason using the provided one.
762      *
763      * _Available since v4.3._
764      */
765     function verifyCallResult(
766         bool success,
767         bytes memory returndata,
768         string memory errorMessage
769     ) internal pure returns (bytes memory) {
770         if (success) {
771             return returndata;
772         } else {
773             // Look for revert reason and bubble it up if present
774             if (returndata.length > 0) {
775                 // The easiest way to bubble the revert reason is using memory via assembly
776 
777                 assembly {
778                     let returndata_size := mload(returndata)
779                     revert(add(32, returndata), returndata_size)
780                 }
781             } else {
782                 revert(errorMessage);
783             }
784         }
785     }
786 }
787 
788 
789 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.1
790 
791 // 
792 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
793 
794 pragma solidity ^0.8.0;
795 
796 /**
797  * @dev Implementation of the {IERC165} interface.
798  *
799  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
800  * for the additional interface id that will be supported. For example:
801  *
802  * ```solidity
803  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
804  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
805  * }
806  * ```
807  *
808  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
809  */
810 abstract contract ERC165 is IERC165 {
811     /**
812      * @dev See {IERC165-supportsInterface}.
813      */
814     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
815         return interfaceId == type(IERC165).interfaceId;
816     }
817 }
818 
819 
820 // File contracts/utils/ERC721A.sol
821 
822 // 
823 // Creators: locationtba.eth, 2pmflow.eth
824 
825 pragma solidity ^0.8.0;
826 
827 
828 
829 
830 
831 
832 
833 
834 /**
835  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
836  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
837  *
838  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
839  *
840  * Does not support burning tokens to address(0).
841  */
842 contract ERC721A is
843   Context,
844   ERC165,
845   IERC721,
846   IERC721Metadata,
847   IERC721Enumerable
848 {
849   using Address for address;
850   using Strings for uint256;
851 
852   struct TokenOwnership {
853     address addr;
854     uint64 startTimestamp;
855   }
856 
857   struct AddressData {
858     uint128 balance;
859     uint128 numberMinted;
860   }
861 
862   uint256 private currentIndex = 0;
863 
864   uint256 internal immutable maxBatchSize;
865 
866   // Token name
867   string private _name;
868 
869   // Token symbol
870   string private _symbol;
871 
872   // Mapping from token ID to ownership details
873   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
874   mapping(uint256 => TokenOwnership) private _ownerships;
875 
876   // Mapping owner address to address data
877   mapping(address => AddressData) private _addressData;
878 
879   // Mapping from token ID to approved address
880   mapping(uint256 => address) private _tokenApprovals;
881 
882   // Mapping from owner to operator approvals
883   mapping(address => mapping(address => bool)) private _operatorApprovals;
884 
885   /**
886    * @dev
887    * `maxBatchSize` refers to how much a minter can mint at a time.
888    */
889   constructor(
890     string memory name_,
891     string memory symbol_,
892     uint256 maxBatchSize_
893   ) {
894     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
895     _name = name_;
896     _symbol = symbol_;
897     maxBatchSize = maxBatchSize_;
898   }
899 
900   /**
901    * @dev See {IERC721Enumerable-totalSupply}.
902    */
903   function totalSupply() public view override returns (uint256) {
904     return currentIndex;
905   }
906 
907   /**
908    * @dev See {IERC721Enumerable-tokenByIndex}.
909    */
910   function tokenByIndex(uint256 index) public view override returns (uint256) {
911     require(index < totalSupply(), "ERC721A: global index out of bounds");
912     return index;
913   }
914 
915   /**
916    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
917    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
918    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
919    */
920   function tokenOfOwnerByIndex(address owner, uint256 index)
921     public
922     view
923     override
924     returns (uint256)
925   {
926     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
927     uint256 numMintedSoFar = totalSupply();
928     uint256 tokenIdsIdx = 0;
929     address currOwnershipAddr = address(0);
930     for (uint256 i = 0; i < numMintedSoFar; i++) {
931       TokenOwnership memory ownership = _ownerships[i];
932       if (ownership.addr != address(0)) {
933         currOwnershipAddr = ownership.addr;
934       }
935       if (currOwnershipAddr == owner) {
936         if (tokenIdsIdx == index) {
937           return i;
938         }
939         tokenIdsIdx++;
940       }
941     }
942     revert("ERC721A: unable to get token of owner by index");
943   }
944 
945   /**
946    * @dev See {IERC165-supportsInterface}.
947    */
948   function supportsInterface(bytes4 interfaceId)
949     public
950     view
951     virtual
952     override(ERC165, IERC165)
953     returns (bool)
954   {
955     return
956       interfaceId == type(IERC721).interfaceId ||
957       interfaceId == type(IERC721Metadata).interfaceId ||
958       interfaceId == type(IERC721Enumerable).interfaceId ||
959       super.supportsInterface(interfaceId);
960   }
961 
962   /**
963    * @dev See {IERC721-balanceOf}.
964    */
965   function balanceOf(address owner) public view override returns (uint256) {
966     require(owner != address(0), "ERC721A: balance query for the zero address");
967     return uint256(_addressData[owner].balance);
968   }
969 
970   function _numberMinted(address owner) internal view returns (uint256) {
971     require(
972       owner != address(0),
973       "ERC721A: number minted query for the zero address"
974     );
975     return uint256(_addressData[owner].numberMinted);
976   }
977 
978   function ownershipOf(uint256 tokenId)
979     internal
980     view
981     returns (TokenOwnership memory)
982   {
983     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
984 
985     uint256 lowestTokenToCheck;
986     if (tokenId >= maxBatchSize) {
987       lowestTokenToCheck = tokenId - maxBatchSize + 1;
988     }
989 
990     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
991       TokenOwnership memory ownership = _ownerships[curr];
992       if (ownership.addr != address(0)) {
993         return ownership;
994       }
995     }
996 
997     revert("ERC721A: unable to determine the owner of token");
998   }
999 
1000   /**
1001    * @dev See {IERC721-ownerOf}.
1002    */
1003   function ownerOf(uint256 tokenId) public view override returns (address) {
1004     return ownershipOf(tokenId).addr;
1005   }
1006 
1007   /**
1008    * @dev See {IERC721Metadata-name}.
1009    */
1010   function name() public view virtual override returns (string memory) {
1011     return _name;
1012   }
1013 
1014   /**
1015    * @dev See {IERC721Metadata-symbol}.
1016    */
1017   function symbol() public view virtual override returns (string memory) {
1018     return _symbol;
1019   }
1020 
1021   /**
1022    * @dev See {IERC721Metadata-tokenURI}.
1023    */
1024   function tokenURI(uint256 tokenId)
1025     public
1026     view
1027     virtual
1028     override
1029     returns (string memory)
1030   {
1031     require(
1032       _exists(tokenId),
1033       "ERC721Metadata: URI query for nonexistent token"
1034     );
1035 
1036     string memory baseURI = _baseURI();
1037     return
1038       bytes(baseURI).length > 0
1039         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1040         : "";
1041   }
1042 
1043   /**
1044    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1045    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1046    * by default, can be overriden in child contracts.
1047    */
1048   function _baseURI() internal view virtual returns (string memory) {
1049     return "";
1050   }
1051 
1052   /**
1053    * @dev See {IERC721-approve}.
1054    */
1055   function approve(address to, uint256 tokenId) public override {
1056     address owner = ERC721A.ownerOf(tokenId);
1057     require(to != owner, "ERC721A: approval to current owner");
1058 
1059     require(
1060       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1061       "ERC721A: approve caller is not owner nor approved for all"
1062     );
1063 
1064     _approve(to, tokenId, owner);
1065   }
1066 
1067   /**
1068    * @dev See {IERC721-getApproved}.
1069    */
1070   function getApproved(uint256 tokenId) public view override returns (address) {
1071     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1072 
1073     return _tokenApprovals[tokenId];
1074   }
1075 
1076   /**
1077    * @dev See {IERC721-setApprovalForAll}.
1078    */
1079   function setApprovalForAll(address operator, bool approved) public override {
1080     require(operator != _msgSender(), "ERC721A: approve to caller");
1081 
1082     _operatorApprovals[_msgSender()][operator] = approved;
1083     emit ApprovalForAll(_msgSender(), operator, approved);
1084   }
1085 
1086   /**
1087    * @dev See {IERC721-isApprovedForAll}.
1088    */
1089   function isApprovedForAll(address owner, address operator)
1090     public
1091     view
1092     virtual
1093     override
1094     returns (bool)
1095   {
1096     return _operatorApprovals[owner][operator];
1097   }
1098 
1099   /**
1100    * @dev See {IERC721-transferFrom}.
1101    */
1102   function transferFrom(
1103     address from,
1104     address to,
1105     uint256 tokenId
1106   ) public override {
1107     _transfer(from, to, tokenId);
1108   }
1109 
1110   /**
1111    * @dev See {IERC721-safeTransferFrom}.
1112    */
1113   function safeTransferFrom(
1114     address from,
1115     address to,
1116     uint256 tokenId
1117   ) public override {
1118     safeTransferFrom(from, to, tokenId, "");
1119   }
1120 
1121   /**
1122    * @dev See {IERC721-safeTransferFrom}.
1123    */
1124   function safeTransferFrom(
1125     address from,
1126     address to,
1127     uint256 tokenId,
1128     bytes memory _data
1129   ) public override {
1130     _transfer(from, to, tokenId);
1131     require(
1132       _checkOnERC721Received(from, to, tokenId, _data),
1133       "ERC721A: transfer to non ERC721Receiver implementer"
1134     );
1135   }
1136 
1137   /**
1138    * @dev Returns whether `tokenId` exists.
1139    *
1140    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1141    *
1142    * Tokens start existing when they are minted (`_mint`),
1143    */
1144   function _exists(uint256 tokenId) internal view returns (bool) {
1145     return tokenId < currentIndex;
1146   }
1147 
1148   function _safeMint(address to, uint256 quantity) internal {
1149     _safeMint(to, quantity, "");
1150   }
1151 
1152   /**
1153    * @dev Mints `quantity` tokens and transfers them to `to`.
1154    *
1155    * Requirements:
1156    *
1157    * - `to` cannot be the zero address.
1158    * - `quantity` cannot be larger than the max batch size.
1159    *
1160    * Emits a {Transfer} event.
1161    */
1162   function _safeMint(
1163     address to,
1164     uint256 quantity,
1165     bytes memory _data
1166   ) internal {
1167     uint256 startTokenId = currentIndex;
1168     require(to != address(0), "ERC721A: mint to the zero address");
1169     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1170     require(!_exists(startTokenId), "ERC721A: token already minted");
1171     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1172 
1173     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1174 
1175     AddressData memory addressData = _addressData[to];
1176     _addressData[to] = AddressData(
1177       addressData.balance + uint128(quantity),
1178       addressData.numberMinted + uint128(quantity)
1179     );
1180     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1181 
1182     uint256 updatedIndex = startTokenId;
1183 
1184     for (uint256 i = 0; i < quantity; i++) {
1185       emit Transfer(address(0), to, updatedIndex);
1186       require(
1187         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1188         "ERC721A: transfer to non ERC721Receiver implementer"
1189       );
1190       updatedIndex++;
1191     }
1192 
1193     currentIndex = updatedIndex;
1194     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1195   }
1196 
1197   /**
1198    * @dev Transfers `tokenId` from `from` to `to`.
1199    *
1200    * Requirements:
1201    *
1202    * - `to` cannot be the zero address.
1203    * - `tokenId` token must be owned by `from`.
1204    *
1205    * Emits a {Transfer} event.
1206    */
1207   function _transfer(
1208     address from,
1209     address to,
1210     uint256 tokenId
1211   ) private {
1212     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1213 
1214     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1215       getApproved(tokenId) == _msgSender() ||
1216       isApprovedForAll(prevOwnership.addr, _msgSender()));
1217 
1218     require(
1219       isApprovedOrOwner,
1220       "ERC721A: transfer caller is not owner nor approved"
1221     );
1222 
1223     require(
1224       prevOwnership.addr == from,
1225       "ERC721A: transfer from incorrect owner"
1226     );
1227     require(to != address(0), "ERC721A: transfer to the zero address");
1228 
1229     _beforeTokenTransfers(from, to, tokenId, 1);
1230 
1231     // Clear approvals from the previous owner
1232     _approve(address(0), tokenId, prevOwnership.addr);
1233 
1234     _addressData[from].balance -= 1;
1235     _addressData[to].balance += 1;
1236     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1237 
1238     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1239     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1240     uint256 nextTokenId = tokenId + 1;
1241     if (_ownerships[nextTokenId].addr == address(0)) {
1242       if (_exists(nextTokenId)) {
1243         _ownerships[nextTokenId] = TokenOwnership(
1244           prevOwnership.addr,
1245           prevOwnership.startTimestamp
1246         );
1247       }
1248     }
1249 
1250     emit Transfer(from, to, tokenId);
1251     _afterTokenTransfers(from, to, tokenId, 1);
1252   }
1253 
1254   /**
1255    * @dev Approve `to` to operate on `tokenId`
1256    *
1257    * Emits a {Approval} event.
1258    */
1259   function _approve(
1260     address to,
1261     uint256 tokenId,
1262     address owner
1263   ) private {
1264     _tokenApprovals[tokenId] = to;
1265     emit Approval(owner, to, tokenId);
1266   }
1267 
1268   uint256 public nextOwnerToExplicitlySet = 0;
1269 
1270   /**
1271    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1272    */
1273   function _setOwnersExplicit(uint256 quantity) internal {
1274     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1275     require(quantity > 0, "quantity must be nonzero");
1276     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1277     if (endIndex > currentIndex - 1) {
1278       endIndex = currentIndex - 1;
1279     }
1280     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1281     require(_exists(endIndex), "not enough minted yet for this cleanup");
1282     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1283       if (_ownerships[i].addr == address(0)) {
1284         TokenOwnership memory ownership = ownershipOf(i);
1285         _ownerships[i] = TokenOwnership(
1286           ownership.addr,
1287           ownership.startTimestamp
1288         );
1289       }
1290     }
1291     nextOwnerToExplicitlySet = endIndex + 1;
1292   }
1293 
1294   /**
1295    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1296    * The call is not executed if the target address is not a contract.
1297    *
1298    * @param from address representing the previous owner of the given token ID
1299    * @param to target address that will receive the tokens
1300    * @param tokenId uint256 ID of the token to be transferred
1301    * @param _data bytes optional data to send along with the call
1302    * @return bool whether the call correctly returned the expected magic value
1303    */
1304   function _checkOnERC721Received(
1305     address from,
1306     address to,
1307     uint256 tokenId,
1308     bytes memory _data
1309   ) private returns (bool) {
1310     if (to.isContract()) {
1311       try
1312         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1313       returns (bytes4 retval) {
1314         return retval == IERC721Receiver(to).onERC721Received.selector;
1315       } catch (bytes memory reason) {
1316         if (reason.length == 0) {
1317           revert("ERC721A: transfer to non ERC721Receiver implementer");
1318         } else {
1319           assembly {
1320             revert(add(32, reason), mload(reason))
1321           }
1322         }
1323       }
1324     } else {
1325       return true;
1326     }
1327   }
1328 
1329   /**
1330    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1331    *
1332    * startTokenId - the first token id to be transferred
1333    * quantity - the amount to be transferred
1334    *
1335    * Calling conditions:
1336    *
1337    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1338    * transferred to `to`.
1339    * - When `from` is zero, `tokenId` will be minted for `to`.
1340    */
1341   function _beforeTokenTransfers(
1342     address from,
1343     address to,
1344     uint256 startTokenId,
1345     uint256 quantity
1346   ) internal virtual {}
1347 
1348   /**
1349    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1350    * minting.
1351    *
1352    * startTokenId - the first token id to be transferred
1353    * quantity - the amount to be transferred
1354    *
1355    * Calling conditions:
1356    *
1357    * - when `from` and `to` are both non-zero.
1358    * - `from` and `to` are never both zero.
1359    */
1360   function _afterTokenTransfers(
1361     address from,
1362     address to,
1363     uint256 startTokenId,
1364     uint256 quantity
1365   ) internal virtual {}
1366 }
1367 
1368 
1369 // File contracts/utils/Pausable.sol
1370 
1371 // 
1372 // Creators: ngenator.eth
1373 
1374 pragma solidity ^0.8.0;
1375 
1376 // a basic contract to provide modifiers and functions and enable pausing of an inheriting contract
1377 abstract contract Pausable {
1378 	bool private _paused;
1379 
1380 	constructor() {
1381 		_paused = true;
1382 	}
1383 
1384 	function paused() public view virtual returns (bool) {
1385 		return _paused;
1386 	}
1387 
1388 	modifier whenNotPaused() {
1389 		require(!paused(), "Pausable: contract is paused");
1390 		_;
1391 	}
1392 
1393 	modifier whenPaused() {
1394 		require(paused(), "Pausable: contract is not paused");
1395 		_;
1396 	}
1397 
1398 	function _pause() internal virtual whenNotPaused {
1399 		_paused = true;
1400 	}
1401 
1402 	function _resume() internal virtual whenPaused {
1403 		_paused = false;
1404 	}
1405 }
1406 
1407 
1408 // File contracts/utils/PreSaleAware.sol
1409 
1410 // 
1411 // Creators: ngenator.eth
1412 
1413 pragma solidity ^0.8.0;
1414 
1415 abstract contract PreSaleAware {
1416 	bool private _presale;
1417 
1418 	constructor() {
1419 		_presale = true;
1420 	}
1421 
1422 	function preSale() public view virtual returns (bool) {
1423 		return _presale;
1424 	}
1425 
1426 	modifier whenNotPreSale() {
1427 		require(!preSale(), "PreSaleAware: presale must not be active");
1428 		_;
1429 	}
1430 
1431 	modifier whenPreSale() {
1432 		require(preSale(), "PreSaleAware: presale must be active");
1433 		_;
1434 	}
1435 
1436 	function _enablePreSale() internal virtual whenNotPreSale {
1437 		_presale = true;
1438 	}
1439 
1440 	function _disablePreSale() internal virtual whenPreSale {
1441 		_presale = false;
1442 	}
1443 }
1444 
1445 
1446 // File contracts/Doggo.sol
1447 
1448 // 
1449 // Creators: ngenator.eth
1450 
1451 pragma solidity ^0.8.0;
1452 
1453 
1454 
1455 
1456 
1457 
1458 /*
1459                                                   `..:`.
1460                                               ``.-/.::/..```.-----:-`
1461                                   ```....````.-.`    `...-:+------..:.
1462                                 `.:-..``..---`             ./+//-`./`+
1463                                `/.      ```                  :: /-`+`+
1464                               `+`      .::+                   /. :+::`
1465                               .:      `/ -+                   `+
1466                               `/      /. `o                    /.`
1467                                ::`    +  `o                    `:-:`
1468                                 `:---:- `+:                      ``::`
1469                                  ````` `o.                          `+
1470                                        -:                            :-
1471                                        +`                            :-
1472                                        -:                           `+`
1473                                        `/-                        `-:`
1474                                         `::.         `..-:---...-:-.`
1475                                           `-:-.....-+-..//`.....`
1476                                              `......+  -/
1477                                                `.::-.  .:-`
1478                                              `-:-`       .::`
1479                                            `./-            `:-`
1480                                           `://`             `+/`
1481                                          `/:/`               .++`
1482                                         `+-/                  .+/
1483 
1484  ________  ________  ________  ________  ________          ___      ___ _______   ________  ________  _______
1485 |\   ___ \|\   __  \|\   ____\|\   ____\|\   __  \        |\  \    /  /|\  ___ \ |\   __  \|\   ____\|\  ___ \
1486 \ \  \_|\ \ \  \|\  \ \  \___|\ \  \___|\ \  \|\  \       \ \  \  /  / | \   __/|\ \  \|\  \ \  \___|\ \   __/|
1487  \ \  \ \\ \ \  \\\  \ \  \  __\ \  \  __\ \  \\\  \       \ \  \/  / / \ \  \_|/_\ \   _  _\ \_____  \ \  \_|/__
1488   \ \  \_\\ \ \  \\\  \ \  \|\  \ \  \|\  \ \  \\\  \       \ \    / /   \ \  \_|\ \ \  \\  \\|____|\  \ \  \_|\ \
1489    \ \_______\ \_______\ \_______\ \_______\ \_______\       \ \__/ /     \ \_______\ \__\\ _\ ____\_\  \ \_______\
1490     \|_______|\|_______|\|_______|\|_______|\|_______|        \|__|/       \|_______|\|__|\|__|\_________\|_______|
1491                                                                                               \|_________|
1492 */
1493 contract Doggo is ERC721A, Ownable, Pausable, PreSaleAware, ReentrancyGuard {
1494 	using Strings for uint256;
1495 
1496 	uint256 public constant COST = 0.08 ether; // the cost per doggo
1497 
1498 	// the merkle root used for verifying proofs during presale
1499 	bytes32 public constant PRE_SALE_MERKLE_ROOT = 0x9f93df4f70710b1cc9fa86ee3c87cc30f77a6709363ccd6bdddeae109330be37;
1500 
1501 	// packing the next variables as uint16 (max 65535, 2 bytes each, less than 32 bytes = 1 slot)
1502 	uint16 public constant MAX_SUPPLY = 8888; // the max total supply
1503 	uint16 public constant MAX_PUBLIC_SUPPLY = 8388; // the max public supply
1504 	uint16 public constant MAX_MINT_AMOUNT = 10; // the max amount an address can mint
1505 	uint16 public constant PRE_SALE_MAX_MINT_AMOUNT = 5; // the max amount an address can mint during presale
1506 
1507 	// the address of the DAO treasury that will receive percentage of all withdrawls
1508 	address public constant DAO_TREASURY_ADDRESS = 0x8C3b934E904b25455F53eFC2beCA8693406E15b1;
1509 
1510 	string public hiddenMetadataUri;
1511 	string public uriPrefix = "";
1512 
1513 	bool public revealed = false; // determines whether the artwork is revealed
1514 
1515 	constructor() ERC721A("Doggo Verse", "DV", 500) {
1516 		setHiddenMetadataUri("ipfs://QmU3iVT84VGGY5T2jDfgTzqG8VtcRPdtND5Ma6568Pgfhs/unreaveled");
1517 	}
1518 
1519 	/*
1520 	 * Base URI for computing {tokenURI}. The resulting URI for each token will be
1521 	 * the concatenation of the `baseURI` and the `tokenId`.
1522 	 */
1523 	function _baseURI() internal view override(ERC721A) returns (string memory) {
1524 		return uriPrefix;
1525 	}
1526 
1527 	function tokenURI(uint256 _tokenId) public view override(ERC721A) returns (string memory) {
1528 		require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1529 
1530 		if (revealed == false) {
1531 			return hiddenMetadataUri;
1532 		}
1533 
1534 		string memory currentBaseURI = _baseURI();
1535 		return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString())) : "";
1536 	}
1537 
1538 	// The following functions are available only to the owner
1539 
1540 	/*
1541 	 * @dev Pauses the contract.
1542 	 */
1543 	function pause() public onlyOwner {
1544 		_pause();
1545 	}
1546 
1547 	/*
1548 	 * @dev Resumes the contract.
1549 	 */
1550 	function resume() public onlyOwner {
1551 		_resume();
1552 	}
1553 
1554 	/*
1555 	 * @dev Disables presale.
1556 	 */
1557 	function disablePreSale() public onlyOwner {
1558 		_disablePreSale();
1559 	}
1560 
1561 	/*
1562 	 * @dev Enables presale.
1563 	 */
1564 	function enablePreSale() public onlyOwner {
1565 		_enablePreSale();
1566 	}
1567 
1568 	/*
1569 	 * @dev Withdraws the contracts balance to owner and DAO.
1570 	 */
1571 	function withdraw() public onlyOwner {
1572 		// Reserve 30% for DAO treasury
1573 		(bool hs, ) = payable(DAO_TREASURY_ADDRESS).call{ value: (address(this).balance * 30) / 100 }("");
1574 		require(hs, "DAO tranfer failed");
1575 
1576 		// owner only
1577 		(bool os, ) = payable(owner()).call{ value: address(this).balance }("");
1578 		require(os, "owner transfer failed");
1579 	}
1580 
1581 	/*
1582 	 * @dev Reveals the artwork.
1583 	 */
1584 	function reveal() public onlyOwner {
1585 		revealed = true;
1586 	}
1587 
1588 	/*
1589 	 * @dev Hides the artwork.
1590 	 */
1591 	function hide() public onlyOwner {
1592 		revealed = false;
1593 	}
1594 
1595 	/*
1596 	 * @dev Sets uri prefix for revealed tokens
1597 	 */
1598 	function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1599 		uriPrefix = _uriPrefix;
1600 	}
1601 
1602 	/*
1603 	 * @dev Sets uri prefix for hidden tokens
1604 	 */
1605 	function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1606 		hiddenMetadataUri = _hiddenMetadataUri;
1607 	}
1608 
1609 	/*
1610 	 * @dev Mints a doggo to an address
1611 	 */
1612 	function _mintDoggo(address to, uint256 quantity) private {
1613 		_safeMint(to, quantity);
1614 	}
1615 
1616 	/*
1617 	 * @dev Mints doggos when presale is enabled.
1618 	 */
1619 	function presaleMintDoggo(uint256 quantity, bytes32[] calldata merkleProof)
1620 		external
1621 		payable
1622 		whenNotPaused
1623 		whenPreSale
1624 		nonReentrant
1625 	{
1626 		require(totalSupply() + quantity < MAX_SUPPLY, "max supply reached");
1627 
1628 		if (_msgSender() != owner()) {
1629 			require(totalSupply() + quantity < MAX_PUBLIC_SUPPLY, "max public supply reached");
1630 			require(
1631 				MerkleProof.verify(merkleProof, PRE_SALE_MERKLE_ROOT, keccak256(abi.encodePacked(_msgSender()))),
1632 				"Address not on the list"
1633 			);
1634 			require(_numberMinted(_msgSender()) + quantity <= PRE_SALE_MAX_MINT_AMOUNT, "presale mint limit reached");
1635 			require(msg.value >= COST * quantity, "incorrect ether value");
1636 		}
1637 
1638 		_mintDoggo(_msgSender(), quantity);
1639 	}
1640 
1641 	/*
1642 	 * @dev Mints doggos when presale is disabled.
1643 	 */
1644 	function mintDoggo(uint256 quantity) external payable whenNotPaused whenNotPreSale nonReentrant {
1645 		require(totalSupply() + quantity < MAX_SUPPLY, "max supply reached");
1646 
1647 		if (_msgSender() != owner()) {
1648 			require(totalSupply() + quantity < MAX_PUBLIC_SUPPLY, "max public supply reached");
1649 			require(_numberMinted(_msgSender()) + quantity <= MAX_MINT_AMOUNT, "mint limit reached");
1650 			require(msg.value >= COST * quantity, "incorrect ether value");
1651 		}
1652 
1653 		_mintDoggo(_msgSender(), quantity);
1654 	}
1655 
1656 	/*
1657 	 * @dev Returns the number of tokens minted by an address
1658 	 */
1659 	function numberMinted(address _owner) public view returns (uint256) {
1660 		return _numberMinted(_owner);
1661 	}
1662 
1663 	// The following functions are overrides required by Solidity.
1664 
1665 	function supportsInterface(bytes4 interfaceId) public view override(ERC721A) returns (bool) {
1666 		return super.supportsInterface(interfaceId);
1667 	}
1668 }