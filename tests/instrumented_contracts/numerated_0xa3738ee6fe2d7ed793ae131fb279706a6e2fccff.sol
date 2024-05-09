1 // SPDX-License-Identifier: MIT
2 //
3 //░██▄▒▄▀▄▒█▀▄░▀█▀░▀░▄▀▀░░▒█▀▒▄▀▄▒█▀▄░█▄▒▄█░░▒█▀▒█▀▄▒██▀░█▄░█░▄▀▀
4 //▒█▄█░█▀█░█▀▄░▒█▒░░▒▄██▒░░█▀░█▀█░█▀▄░█▒▀▒█▒░░█▀░█▀▄░█▄▄░█▒▀█▒▄██
5                   
6 
7 //******************************************************************@@@***********
8 //***********************************@@@@@@@@@&******************@@,  @***********
9 //****************************#@@@@@@@@@@@@@@@@@,/@@@@/******&@@.    @@***********
10 //******@@@@***************@@@@@@@@@@@@@@@@@@@@%       @@@@@        @@************
11 //******@@   @@@@*******@@@@@@@@@@&,,%@@@@@@@%            @@&      @@*************
12 //*******@@        @@@@@(                                   @@*.#@@***************
13 //********&@(        @@                                   @@@@@@@@@@@@@***********
14 //**********(@@     @@.                             @@@(   (@@@@@       @@********
15 //**************@@@@@.    .@@@@@@     @@@ @@      &@@@&@@    @@@@%@@@@@@**********
16 //**********@@@.   @@.   @@@@@@@@     @@@@@@       #@@@@     .@@@*****************
17 //*******@@%     @@@@   %@@@@@@@@@              ,/(((*          @*****************
18 //*********%@@@@***@@    @@@@@@@@@@     @@@@@,,,,,,,,,,,,(@@@@ /@*****************
19 //******************@%.      @@@@&  (@@,,,,,,,,,,,,,,,,,,,,,,,(@@/****************
20 //******************#@            @@*,,,,,,,(@,,,,,,,,@@@@,,,,,,*@(***************
21 //*******************(@* .       @@,,,,,,,,&@@@,,,,,,,,(#,,,,,,,,@@***************
22 //********************/@@.       @@,,,,,*,,,,,,,,,,,,,,,,,,,,,,,,@@***************
23 //***********************@@@     @@,,,,,@@@@@@@@@@@@,,,,,,,,,,,(@@****************
24 //***************************@@@@@@@%,,,*@@@@@@@@@@,,,,,,,,,@@@*******************
25 //***********************************@@@@#,,,,,,,,,(&@@@@@%***********************
26 
27 // contract by @ZombieBitsNFT
28 
29 //https://bartsfarmfrens.com
30 
31 
32 // File: @openzeppelin/contracts/utils/Address.sol
33 
34 
35 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
36 
37 pragma solidity ^0.8.1;
38 
39 /**
40  * @dev Collection of functions related to the address type
41  */
42 library Address {
43     /**
44      * @dev Returns true if `account` is a contract.
45      *
46      * [IMPORTANT]
47      * ====
48      * It is unsafe to assume that an address for which this function returns
49      * false is an externally-owned account (EOA) and not a contract.
50      *
51      * Among others, `isContract` will return false for the following
52      * types of addresses:
53      *
54      *  - an externally-owned account
55      *  - a contract in construction
56      *  - an address where a contract will be created
57      *  - an address where a contract lived, but was destroyed
58      * ====
59      *
60      * [IMPORTANT]
61      * ====
62      * You shouldn't rely on `isContract` to protect against flash loan attacks!
63      *
64      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
65      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
66      * constructor.
67      * ====
68      */
69     function isContract(address account) internal view returns (bool) {
70         // This method relies on extcodesize/address.code.length, which returns 0
71         // for contracts in construction, since the code is only stored at the end
72         // of the constructor execution.
73 
74         return account.code.length > 0;
75     }
76 
77     /**
78      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
79      * `recipient`, forwarding all available gas and reverting on errors.
80      *
81      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
82      * of certain opcodes, possibly making contracts go over the 2300 gas limit
83      * imposed by `transfer`, making them unable to receive funds via
84      * `transfer`. {sendValue} removes this limitation.
85      *
86      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
87      *
88      * IMPORTANT: because control is transferred to `recipient`, care must be
89      * taken to not create reentrancy vulnerabilities. Consider using
90      * {ReentrancyGuard} or the
91      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
92      */
93     function sendValue(address payable recipient, uint256 amount) internal {
94         require(address(this).balance >= amount, "Address: insufficient balance");
95 
96         (bool success, ) = recipient.call{value: amount}("");
97         require(success, "Address: unable to send value, recipient may have reverted");
98     }
99 
100     /**
101      * @dev Performs a Solidity function call using a low level `call`. A
102      * plain `call` is an unsafe replacement for a function call: use this
103      * function instead.
104      *
105      * If `target` reverts with a revert reason, it is bubbled up by this
106      * function (like regular Solidity function calls).
107      *
108      * Returns the raw returned data. To convert to the expected return value,
109      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
110      *
111      * Requirements:
112      *
113      * - `target` must be a contract.
114      * - calling `target` with `data` must not revert.
115      *
116      * _Available since v3.1._
117      */
118     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
119         return functionCall(target, data, "Address: low-level call failed");
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
124      * `errorMessage` as a fallback revert reason when `target` reverts.
125      *
126      * _Available since v3.1._
127      */
128     function functionCall(
129         address target,
130         bytes memory data,
131         string memory errorMessage
132     ) internal returns (bytes memory) {
133         return functionCallWithValue(target, data, 0, errorMessage);
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
138      * but also transferring `value` wei to `target`.
139      *
140      * Requirements:
141      *
142      * - the calling contract must have an ETH balance of at least `value`.
143      * - the called Solidity function must be `payable`.
144      *
145      * _Available since v3.1._
146      */
147     function functionCallWithValue(
148         address target,
149         bytes memory data,
150         uint256 value
151     ) internal returns (bytes memory) {
152         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
157      * with `errorMessage` as a fallback revert reason when `target` reverts.
158      *
159      * _Available since v3.1._
160      */
161     function functionCallWithValue(
162         address target,
163         bytes memory data,
164         uint256 value,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         require(address(this).balance >= value, "Address: insufficient balance for call");
168         require(isContract(target), "Address: call to non-contract");
169 
170         (bool success, bytes memory returndata) = target.call{value: value}(data);
171         return verifyCallResult(success, returndata, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but performing a static call.
177      *
178      * _Available since v3.3._
179      */
180     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
181         return functionStaticCall(target, data, "Address: low-level static call failed");
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
186      * but performing a static call.
187      *
188      * _Available since v3.3._
189      */
190     function functionStaticCall(
191         address target,
192         bytes memory data,
193         string memory errorMessage
194     ) internal view returns (bytes memory) {
195         require(isContract(target), "Address: static call to non-contract");
196 
197         (bool success, bytes memory returndata) = target.staticcall(data);
198         return verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
203      * but performing a delegate call.
204      *
205      * _Available since v3.4._
206      */
207     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
208         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
213      * but performing a delegate call.
214      *
215      * _Available since v3.4._
216      */
217     function functionDelegateCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(isContract(target), "Address: delegate call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.delegatecall(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
230      * revert reason using the provided one.
231      *
232      * _Available since v4.3._
233      */
234     function verifyCallResult(
235         bool success,
236         bytes memory returndata,
237         string memory errorMessage
238     ) internal pure returns (bytes memory) {
239         if (success) {
240             return returndata;
241         } else {
242             // Look for revert reason and bubble it up if present
243             if (returndata.length > 0) {
244                 // The easiest way to bubble the revert reason is using memory via assembly
245 
246                 assembly {
247                     let returndata_size := mload(returndata)
248                     revert(add(32, returndata), returndata_size)
249                 }
250             } else {
251                 revert(errorMessage);
252             }
253         }
254     }
255 }
256 
257 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
258 
259 
260 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @title ERC721 token receiver interface
266  * @dev Interface for any contract that wants to support safeTransfers
267  * from ERC721 asset contracts.
268  */
269 interface IERC721Receiver {
270     /**
271      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
272      * by `operator` from `from`, this function is called.
273      *
274      * It must return its Solidity selector to confirm the token transfer.
275      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
276      *
277      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
278      */
279     function onERC721Received(
280         address operator,
281         address from,
282         uint256 tokenId,
283         bytes calldata data
284     ) external returns (bytes4);
285 }
286 
287 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
288 
289 
290 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @dev Interface of the ERC165 standard, as defined in the
296  * https://eips.ethereum.org/EIPS/eip-165[EIP].
297  *
298  * Implementers can declare support of contract interfaces, which can then be
299  * queried by others ({ERC165Checker}).
300  *
301  * For an implementation, see {ERC165}.
302  */
303 interface IERC165 {
304     /**
305      * @dev Returns true if this contract implements the interface defined by
306      * `interfaceId`. See the corresponding
307      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
308      * to learn more about how these ids are created.
309      *
310      * This function call must use less than 30 000 gas.
311      */
312     function supportsInterface(bytes4 interfaceId) external view returns (bool);
313 }
314 
315 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Implementation of the {IERC165} interface.
325  *
326  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
327  * for the additional interface id that will be supported. For example:
328  *
329  * ```solidity
330  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
331  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
332  * }
333  * ```
334  *
335  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
336  */
337 abstract contract ERC165 is IERC165 {
338     /**
339      * @dev See {IERC165-supportsInterface}.
340      */
341     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
342         return interfaceId == type(IERC165).interfaceId;
343     }
344 }
345 
346 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 
354 /**
355  * @dev Required interface of an ERC721 compliant contract.
356  */
357 interface IERC721 is IERC165 {
358     /**
359      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
360      */
361     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
362 
363     /**
364      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
365      */
366     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
367 
368     /**
369      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
370      */
371     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
372 
373     /**
374      * @dev Returns the number of tokens in ``owner``'s account.
375      */
376     function balanceOf(address owner) external view returns (uint256 balance);
377 
378     /**
379      * @dev Returns the owner of the `tokenId` token.
380      *
381      * Requirements:
382      *
383      * - `tokenId` must exist.
384      */
385     function ownerOf(uint256 tokenId) external view returns (address owner);
386 
387     /**
388      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
389      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
390      *
391      * Requirements:
392      *
393      * - `from` cannot be the zero address.
394      * - `to` cannot be the zero address.
395      * - `tokenId` token must exist and be owned by `from`.
396      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
397      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
398      *
399      * Emits a {Transfer} event.
400      */
401     function safeTransferFrom(
402         address from,
403         address to,
404         uint256 tokenId
405     ) external;
406 
407     /**
408      * @dev Transfers `tokenId` token from `from` to `to`.
409      *
410      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
411      *
412      * Requirements:
413      *
414      * - `from` cannot be the zero address.
415      * - `to` cannot be the zero address.
416      * - `tokenId` token must be owned by `from`.
417      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transferFrom(
422         address from,
423         address to,
424         uint256 tokenId
425     ) external;
426 
427     /**
428      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
429      * The approval is cleared when the token is transferred.
430      *
431      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
432      *
433      * Requirements:
434      *
435      * - The caller must own the token or be an approved operator.
436      * - `tokenId` must exist.
437      *
438      * Emits an {Approval} event.
439      */
440     function approve(address to, uint256 tokenId) external;
441 
442     /**
443      * @dev Returns the account approved for `tokenId` token.
444      *
445      * Requirements:
446      *
447      * - `tokenId` must exist.
448      */
449     function getApproved(uint256 tokenId) external view returns (address operator);
450 
451     /**
452      * @dev Approve or remove `operator` as an operator for the caller.
453      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
454      *
455      * Requirements:
456      *
457      * - The `operator` cannot be the caller.
458      *
459      * Emits an {ApprovalForAll} event.
460      */
461     function setApprovalForAll(address operator, bool _approved) external;
462 
463     /**
464      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
465      *
466      * See {setApprovalForAll}
467      */
468     function isApprovedForAll(address owner, address operator) external view returns (bool);
469 
470     /**
471      * @dev Safely transfers `tokenId` token from `from` to `to`.
472      *
473      * Requirements:
474      *
475      * - `from` cannot be the zero address.
476      * - `to` cannot be the zero address.
477      * - `tokenId` token must exist and be owned by `from`.
478      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
479      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
480      *
481      * Emits a {Transfer} event.
482      */
483     function safeTransferFrom(
484         address from,
485         address to,
486         uint256 tokenId,
487         bytes calldata data
488     ) external;
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
492 
493 
494 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Enumerable is IERC721 {
504     /**
505      * @dev Returns the total amount of tokens stored by the contract.
506      */
507     function totalSupply() external view returns (uint256);
508 
509     /**
510      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
511      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
512      */
513     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
514 
515     /**
516      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
517      * Use along with {totalSupply} to enumerate all tokens.
518      */
519     function tokenByIndex(uint256 index) external view returns (uint256);
520 }
521 
522 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
532  * @dev See https://eips.ethereum.org/EIPS/eip-721
533  */
534 interface IERC721Metadata is IERC721 {
535     /**
536      * @dev Returns the token collection name.
537      */
538     function name() external view returns (string memory);
539 
540     /**
541      * @dev Returns the token collection symbol.
542      */
543     function symbol() external view returns (string memory);
544 
545     /**
546      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
547      */
548     function tokenURI(uint256 tokenId) external view returns (string memory);
549 }
550 
551 // File: @openzeppelin/contracts/utils/Strings.sol
552 
553 
554 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 /**
559  * @dev String operations.
560  */
561 library Strings {
562     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
563 
564     /**
565      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
566      */
567     function toString(uint256 value) internal pure returns (string memory) {
568         // Inspired by OraclizeAPI's implementation - MIT licence
569         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
570 
571         if (value == 0) {
572             return "0";
573         }
574         uint256 temp = value;
575         uint256 digits;
576         while (temp != 0) {
577             digits++;
578             temp /= 10;
579         }
580         bytes memory buffer = new bytes(digits);
581         while (value != 0) {
582             digits -= 1;
583             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
584             value /= 10;
585         }
586         return string(buffer);
587     }
588 
589     /**
590      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
591      */
592     function toHexString(uint256 value) internal pure returns (string memory) {
593         if (value == 0) {
594             return "0x00";
595         }
596         uint256 temp = value;
597         uint256 length = 0;
598         while (temp != 0) {
599             length++;
600             temp >>= 8;
601         }
602         return toHexString(value, length);
603     }
604 
605     /**
606      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
607      */
608     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
609         bytes memory buffer = new bytes(2 * length + 2);
610         buffer[0] = "0";
611         buffer[1] = "x";
612         for (uint256 i = 2 * length + 1; i > 1; --i) {
613             buffer[i] = _HEX_SYMBOLS[value & 0xf];
614             value >>= 4;
615         }
616         require(value == 0, "Strings: hex length insufficient");
617         return string(buffer);
618     }
619 }
620 
621 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
622 
623 
624 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 /**
629  * @dev These functions deal with verification of Merkle Trees proofs.
630  *
631  * The proofs can be generated using the JavaScript library
632  * https://github.com/miguelmota/merkletreejs[merkletreejs].
633  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
634  *
635  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
636  */
637 library MerkleProof {
638     /**
639      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
640      * defined by `root`. For this, a `proof` must be provided, containing
641      * sibling hashes on the branch from the leaf to the root of the tree. Each
642      * pair of leaves and each pair of pre-images are assumed to be sorted.
643      */
644     function verify(
645         bytes32[] memory proof,
646         bytes32 root,
647         bytes32 leaf
648     ) internal pure returns (bool) {
649         return processProof(proof, leaf) == root;
650     }
651 
652     /**
653      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
654      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
655      * hash matches the root of the tree. When processing the proof, the pairs
656      * of leafs & pre-images are assumed to be sorted.
657      *
658      * _Available since v4.4._
659      */
660     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
661         bytes32 computedHash = leaf;
662         for (uint256 i = 0; i < proof.length; i++) {
663             bytes32 proofElement = proof[i];
664             if (computedHash <= proofElement) {
665                 // Hash(current computed hash + current element of the proof)
666                 computedHash = _efficientHash(computedHash, proofElement);
667             } else {
668                 // Hash(current element of the proof + current computed hash)
669                 computedHash = _efficientHash(proofElement, computedHash);
670             }
671         }
672         return computedHash;
673     }
674 
675     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
676         assembly {
677             mstore(0x00, a)
678             mstore(0x20, b)
679             value := keccak256(0x00, 0x40)
680         }
681     }
682 }
683 
684 // File: @openzeppelin/contracts/utils/Context.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 /**
692  * @dev Provides information about the current execution context, including the
693  * sender of the transaction and its data. While these are generally available
694  * via msg.sender and msg.data, they should not be accessed in such a direct
695  * manner, since when dealing with meta-transactions the account sending and
696  * paying for execution may not be the actual sender (as far as an application
697  * is concerned).
698  *
699  * This contract is only required for intermediate, library-like contracts.
700  */
701 abstract contract Context {
702     function _msgSender() internal view virtual returns (address) {
703         return msg.sender;
704     }
705 
706     function _msgData() internal view virtual returns (bytes calldata) {
707         return msg.data;
708     }
709 }
710 
711 // File: @openzeppelin/contracts/access/Ownable.sol
712 
713 
714 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 /**
720  * @dev Contract module which provides a basic access control mechanism, where
721  * there is an account (an owner) that can be granted exclusive access to
722  * specific functions.
723  *
724  * By default, the owner account will be the one that deploys the contract. This
725  * can later be changed with {transferOwnership}.
726  *
727  * This module is used through inheritance. It will make available the modifier
728  * `onlyOwner`, which can be applied to your functions to restrict their use to
729  * the owner.
730  */
731 abstract contract Ownable is Context {
732     address private _owner;
733 
734     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
735 
736     /**
737      * @dev Initializes the contract setting the deployer as the initial owner.
738      */
739     constructor() {
740         _transferOwnership(_msgSender());
741     }
742 
743     /**
744      * @dev Returns the address of the current owner.
745      */
746     function owner() public view virtual returns (address) {
747         return _owner;
748     }
749 
750     /**
751      * @dev Throws if called by any account other than the owner.
752      */
753     modifier onlyOwner() {
754         require(owner() == _msgSender(), "Ownable: caller is not the owner");
755         _;
756     }
757 
758     /**
759      * @dev Leaves the contract without owner. It will not be possible to call
760      * `onlyOwner` functions anymore. Can only be called by the current owner.
761      *
762      * NOTE: Renouncing ownership will leave the contract without an owner,
763      * thereby removing any functionality that is only available to the owner.
764      */
765     function renounceOwnership() public virtual onlyOwner {
766         _transferOwnership(address(0));
767     }
768 
769     /**
770      * @dev Transfers ownership of the contract to a new account (`newOwner`).
771      * Can only be called by the current owner.
772      */
773     function transferOwnership(address newOwner) public virtual onlyOwner {
774         require(newOwner != address(0), "Ownable: new owner is the zero address");
775         _transferOwnership(newOwner);
776     }
777 
778     /**
779      * @dev Transfers ownership of the contract to a new account (`newOwner`).
780      * Internal function without access restriction.
781      */
782     function _transferOwnership(address newOwner) internal virtual {
783         address oldOwner = _owner;
784         _owner = newOwner;
785         emit OwnershipTransferred(oldOwner, newOwner);
786     }
787 }
788 
789 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
790 
791 
792 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
793 
794 pragma solidity ^0.8.0;
795 
796 /**
797  * @dev Contract module that helps prevent reentrant calls to a function.
798  *
799  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
800  * available, which can be applied to functions to make sure there are no nested
801  * (reentrant) calls to them.
802  *
803  * Note that because there is a single `nonReentrant` guard, functions marked as
804  * `nonReentrant` may not call one another. This can be worked around by making
805  * those functions `private`, and then adding `external` `nonReentrant` entry
806  * points to them.
807  *
808  * TIP: If you would like to learn more about reentrancy and alternative ways
809  * to protect against it, check out our blog post
810  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
811  */
812 abstract contract ReentrancyGuard {
813     // Booleans are more expensive than uint256 or any type that takes up a full
814     // word because each write operation emits an extra SLOAD to first read the
815     // slot's contents, replace the bits taken up by the boolean, and then write
816     // back. This is the compiler's defense against contract upgrades and
817     // pointer aliasing, and it cannot be disabled.
818 
819     // The values being non-zero value makes deployment a bit more expensive,
820     // but in exchange the refund on every call to nonReentrant will be lower in
821     // amount. Since refunds are capped to a percentage of the total
822     // transaction's gas, it is best to keep them low in cases like this one, to
823     // increase the likelihood of the full refund coming into effect.
824     uint256 private constant _NOT_ENTERED = 1;
825     uint256 private constant _ENTERED = 2;
826 
827     uint256 private _status;
828 
829     constructor() {
830         _status = _NOT_ENTERED;
831     }
832 
833     /**
834      * @dev Prevents a contract from calling itself, directly or indirectly.
835      * Calling a `nonReentrant` function from another `nonReentrant`
836      * function is not supported. It is possible to prevent this from happening
837      * by making the `nonReentrant` function external, and making it call a
838      * `private` function that does the actual work.
839      */
840     modifier nonReentrant() {
841         // On the first call to nonReentrant, _notEntered will be true
842         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
843 
844         // Any calls to nonReentrant after this point will fail
845         _status = _ENTERED;
846 
847         _;
848 
849         // By storing the original value once again, a refund is triggered (see
850         // https://eips.ethereum.org/EIPS/eip-2200)
851         _status = _NOT_ENTERED;
852     }
853 }
854 
855 
856 pragma solidity ^0.8.0;
857 
858 
859 /**ERC721A import
860  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
861  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
862  *
863  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
864  *
865  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
866  *
867  * Does not support burning tokens to address(0).
868  */
869 contract ERC721A is
870   Context,
871   ERC165,
872   IERC721,
873   IERC721Metadata,
874   IERC721Enumerable
875 {
876   using Address for address;
877   using Strings for uint256;
878 
879   struct TokenOwnership {
880     address addr;
881     uint64 startTimestamp;
882   }
883 
884   struct AddressData {
885     uint128 balance;
886     uint128 numberMinted;
887   }
888 
889   uint256 private currentIndex = 0;
890 
891   uint256 internal immutable collectionSize;
892   uint256 internal immutable maxBatchSize;
893 
894   // Token name
895   string private _name;
896 
897   // Token symbol
898   string private _symbol;
899 
900   // Mapping from token ID to ownership details
901   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
902   mapping(uint256 => TokenOwnership) private _ownerships;
903 
904   // Mapping owner address to address data
905   mapping(address => AddressData) private _addressData;
906 
907   // Mapping from token ID to approved address
908   mapping(uint256 => address) private _tokenApprovals;
909 
910   // Mapping from owner to operator approvals
911   mapping(address => mapping(address => bool)) private _operatorApprovals;
912 
913   /**
914    * @dev
915    * `maxBatchSize` refers to how much a minter can mint at a time.
916    * `collectionSize_` refers to how many tokens are in the collection.
917    */
918   constructor(
919     string memory name_,
920     string memory symbol_,
921     uint256 maxBatchSize_,
922     uint256 collectionSize_
923   ) {
924     require(
925       collectionSize_ > 0,
926       "ERC721A: collection must have a nonzero supply"
927     );
928     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
929     _name = name_;
930     _symbol = symbol_;
931     maxBatchSize = maxBatchSize_;
932     collectionSize = collectionSize_;
933   }
934 
935   /**
936    * @dev See {IERC721Enumerable-totalSupply}.
937    */
938   function totalSupply() public view override returns (uint256) {
939     return currentIndex;
940   }
941 
942   /**
943    * @dev See {IERC721Enumerable-tokenByIndex}.
944    */
945   function tokenByIndex(uint256 index) public view override returns (uint256) {
946     require(index < totalSupply(), "ERC721A: global index out of bounds");
947     return index;
948   }
949 
950   /**
951    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
952    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
953    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
954    */
955   function tokenOfOwnerByIndex(address owner, uint256 index)
956     public
957     view
958     override
959     returns (uint256)
960   {
961     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
962     uint256 numMintedSoFar = totalSupply();
963     uint256 tokenIdsIdx = 0;
964     address currOwnershipAddr = address(0);
965     for (uint256 i = 0; i < numMintedSoFar; i++) {
966       TokenOwnership memory ownership = _ownerships[i];
967       if (ownership.addr != address(0)) {
968         currOwnershipAddr = ownership.addr;
969       }
970       if (currOwnershipAddr == owner) {
971         if (tokenIdsIdx == index) {
972           return i;
973         }
974         tokenIdsIdx++;
975       }
976     }
977     revert("ERC721A: unable to get token of owner by index");
978   }
979 
980   /**
981    * @dev See {IERC165-supportsInterface}.
982    */
983   function supportsInterface(bytes4 interfaceId)
984     public
985     view
986     virtual
987     override(ERC165, IERC165)
988     returns (bool)
989   {
990     return
991       interfaceId == type(IERC721).interfaceId ||
992       interfaceId == type(IERC721Metadata).interfaceId ||
993       interfaceId == type(IERC721Enumerable).interfaceId ||
994       super.supportsInterface(interfaceId);
995   }
996 
997   /**
998    * @dev See {IERC721-balanceOf}.
999    */
1000   function balanceOf(address owner) public view override returns (uint256) {
1001     require(owner != address(0), "ERC721A: balance query for the zero address");
1002     return uint256(_addressData[owner].balance);
1003   }
1004 
1005   function _numberMinted(address owner) internal view returns (uint256) {
1006     require(
1007       owner != address(0),
1008       "ERC721A: number minted query for the zero address"
1009     );
1010     return uint256(_addressData[owner].numberMinted);
1011   }
1012 
1013   function ownershipOf(uint256 tokenId)
1014     internal
1015     view
1016     returns (TokenOwnership memory)
1017   {
1018     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1019 
1020     uint256 lowestTokenToCheck;
1021     if (tokenId >= maxBatchSize) {
1022       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1023     }
1024 
1025     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1026       TokenOwnership memory ownership = _ownerships[curr];
1027       if (ownership.addr != address(0)) {
1028         return ownership;
1029       }
1030     }
1031 
1032     revert("ERC721A: unable to determine the owner of token");
1033   }
1034 
1035   /**
1036    * @dev See {IERC721-ownerOf}.
1037    */
1038   function ownerOf(uint256 tokenId) public view override returns (address) {
1039     return ownershipOf(tokenId).addr;
1040   }
1041 
1042   /**
1043    * @dev See {IERC721Metadata-name}.
1044    */
1045   function name() public view virtual override returns (string memory) {
1046     return _name;
1047   }
1048 
1049   /**
1050    * @dev See {IERC721Metadata-symbol}.
1051    */
1052   function symbol() public view virtual override returns (string memory) {
1053     return _symbol;
1054   }
1055 
1056   /**
1057    * @dev See {IERC721Metadata-tokenURI}.
1058    */
1059   function tokenURI(uint256 tokenId)
1060     public
1061     view
1062     virtual
1063     override
1064     returns (string memory)
1065   {
1066     require(
1067       _exists(tokenId),
1068       "ERC721Metadata: URI query for nonexistent token"
1069     );
1070 
1071     string memory baseURI = _baseURI();
1072     return
1073       bytes(baseURI).length > 0
1074         ? string(abi.encodePacked(baseURI, tokenId.toString(),".json"))
1075         : "";
1076   }
1077 
1078   /**
1079    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1080    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1081    * by default, can be overriden in child contracts.
1082    */
1083   function _baseURI() internal view virtual returns (string memory) {
1084     return "";
1085   }
1086 
1087   /**
1088    * @dev See {IERC721-approve}.
1089    */
1090   function approve(address to, uint256 tokenId) public override {
1091     address owner = ERC721A.ownerOf(tokenId);
1092     require(to != owner, "ERC721A: approval to current owner");
1093 
1094     require(
1095       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1096       "ERC721A: approve caller is not owner nor approved for all"
1097     );
1098 
1099     _approve(to, tokenId, owner);
1100   }
1101 
1102   /**
1103    * @dev See {IERC721-getApproved}.
1104    */
1105   function getApproved(uint256 tokenId) public view override returns (address) {
1106     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1107 
1108     return _tokenApprovals[tokenId];
1109   }
1110 
1111   /**
1112    * @dev See {IERC721-setApprovalForAll}.
1113    */
1114   function setApprovalForAll(address operator, bool approved) public override {
1115     require(operator != _msgSender(), "ERC721A: approve to caller");
1116 
1117     _operatorApprovals[_msgSender()][operator] = approved;
1118     emit ApprovalForAll(_msgSender(), operator, approved);
1119   }
1120 
1121   /**
1122    * @dev See {IERC721-isApprovedForAll}.
1123    */
1124   function isApprovedForAll(address owner, address operator)
1125     public
1126     view
1127     virtual
1128     override
1129     returns (bool)
1130   {
1131     return _operatorApprovals[owner][operator];
1132   }
1133 
1134   /**
1135    * @dev See {IERC721-transferFrom}.
1136    */
1137   function transferFrom(
1138     address from,
1139     address to,
1140     uint256 tokenId
1141   ) public override {
1142     _transfer(from, to, tokenId);
1143   }
1144 
1145   /**
1146    * @dev See {IERC721-safeTransferFrom}.
1147    */
1148   function safeTransferFrom(
1149     address from,
1150     address to,
1151     uint256 tokenId
1152   ) public override {
1153     safeTransferFrom(from, to, tokenId, "");
1154   }
1155 
1156   /**
1157    * @dev See {IERC721-safeTransferFrom}.
1158    */
1159   function safeTransferFrom(
1160     address from,
1161     address to,
1162     uint256 tokenId,
1163     bytes memory _data
1164   ) public override {
1165     _transfer(from, to, tokenId);
1166     require(
1167       _checkOnERC721Received(from, to, tokenId, _data),
1168       "ERC721A: transfer to non ERC721Receiver implementer"
1169     );
1170   }
1171 
1172   /**
1173    * @dev Returns whether `tokenId` exists.
1174    *
1175    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1176    *
1177    * Tokens start existing when they are minted (`_mint`),
1178    */
1179   function _exists(uint256 tokenId) internal view returns (bool) {
1180     return tokenId < currentIndex;
1181   }
1182 
1183   function _safeMint(address to, uint256 quantity) internal {
1184     _safeMint(to, quantity, "");
1185   }
1186 
1187   /**
1188    * @dev Mints `quantity` tokens and transfers them to `to`.
1189    *
1190    * Requirements:
1191    *
1192    * - there must be `quantity` tokens remaining unminted in the total collection.
1193    * - `to` cannot be the zero address.
1194    * - `quantity` cannot be larger than the max batch size.
1195    *
1196    * Emits a {Transfer} event.
1197    */
1198   function _safeMint(
1199     address to,
1200     uint256 quantity,
1201     bytes memory _data
1202   ) internal {
1203     uint256 startTokenId = currentIndex;
1204     require(to != address(0), "ERC721A: mint to the zero address");
1205     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1206     require(!_exists(startTokenId), "ERC721A: token already minted");
1207     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1208 
1209     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1210 
1211     AddressData memory addressData = _addressData[to];
1212     _addressData[to] = AddressData(
1213       addressData.balance + uint128(quantity),
1214       addressData.numberMinted + uint128(quantity)
1215     );
1216     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1217 
1218     uint256 updatedIndex = startTokenId;
1219 
1220     for (uint256 i = 0; i < quantity; i++) {
1221       emit Transfer(address(0), to, updatedIndex);
1222       require(
1223         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1224         "ERC721A: transfer to non ERC721Receiver implementer"
1225       );
1226       updatedIndex++;
1227     }
1228 
1229     currentIndex = updatedIndex;
1230     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1231   }
1232 
1233   /**
1234    * @dev Transfers `tokenId` from `from` to `to`.
1235    *
1236    * Requirements:
1237    *
1238    * - `to` cannot be the zero address.
1239    * - `tokenId` token must be owned by `from`.
1240    *
1241    * Emits a {Transfer} event.
1242    */
1243   function _transfer(
1244     address from,
1245     address to,
1246     uint256 tokenId
1247   ) private {
1248     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1249 
1250     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1251       getApproved(tokenId) == _msgSender() ||
1252       isApprovedForAll(prevOwnership.addr, _msgSender()));
1253 
1254     require(
1255       isApprovedOrOwner,
1256       "ERC721A: transfer caller is not owner nor approved"
1257     );
1258 
1259     require(
1260       prevOwnership.addr == from,
1261       "ERC721A: transfer from incorrect owner"
1262     );
1263     require(to != address(0), "ERC721A: transfer to the zero address");
1264 
1265     _beforeTokenTransfers(from, to, tokenId, 1);
1266 
1267     // Clear approvals from the previous owner
1268     _approve(address(0), tokenId, prevOwnership.addr);
1269 
1270     _addressData[from].balance -= 1;
1271     _addressData[to].balance += 1;
1272     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1273 
1274     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1275     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1276     uint256 nextTokenId = tokenId + 1;
1277     if (_ownerships[nextTokenId].addr == address(0)) {
1278       if (_exists(nextTokenId)) {
1279         _ownerships[nextTokenId] = TokenOwnership(
1280           prevOwnership.addr,
1281           prevOwnership.startTimestamp
1282         );
1283       }
1284     }
1285 
1286     emit Transfer(from, to, tokenId);
1287     _afterTokenTransfers(from, to, tokenId, 1);
1288   }
1289 
1290   /**
1291    * @dev Approve `to` to operate on `tokenId`
1292    *
1293    * Emits a {Approval} event.
1294    */
1295   function _approve(
1296     address to,
1297     uint256 tokenId,
1298     address owner
1299   ) private {
1300     _tokenApprovals[tokenId] = to;
1301     emit Approval(owner, to, tokenId);
1302   }
1303 
1304   uint256 public nextOwnerToExplicitlySet = 0;
1305 
1306   /**
1307    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1308    */
1309   function _setOwnersExplicit(uint256 quantity) internal {
1310     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1311     require(quantity > 0, "quantity must be nonzero");
1312     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1313     if (endIndex > collectionSize - 1) {
1314       endIndex = collectionSize - 1;
1315     }
1316     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1317     require(_exists(endIndex), "not enough minted yet for this cleanup");
1318     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1319       if (_ownerships[i].addr == address(0)) {
1320         TokenOwnership memory ownership = ownershipOf(i);
1321         _ownerships[i] = TokenOwnership(
1322           ownership.addr,
1323           ownership.startTimestamp
1324         );
1325       }
1326     }
1327     nextOwnerToExplicitlySet = endIndex + 1;
1328   }
1329 
1330   /**
1331    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1332    * The call is not executed if the target address is not a contract.
1333    *
1334    * @param from address representing the previous owner of the given token ID
1335    * @param to target address that will receive the tokens
1336    * @param tokenId uint256 ID of the token to be transferred
1337    * @param _data bytes optional data to send along with the call
1338    * @return bool whether the call correctly returned the expected magic value
1339    */
1340   function _checkOnERC721Received(
1341     address from,
1342     address to,
1343     uint256 tokenId,
1344     bytes memory _data
1345   ) private returns (bool) {
1346     if (to.isContract()) {
1347       try
1348         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1349       returns (bytes4 retval) {
1350         return retval == IERC721Receiver(to).onERC721Received.selector;
1351       } catch (bytes memory reason) {
1352         if (reason.length == 0) {
1353           revert("ERC721A: transfer to non ERC721Receiver implementer");
1354         } else {
1355           assembly {
1356             revert(add(32, reason), mload(reason))
1357           }
1358         }
1359       }
1360     } else {
1361       return true;
1362     }
1363   }
1364 
1365   /**
1366    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1367    *
1368    * startTokenId - the first token id to be transferred
1369    * quantity - the amount to be transferred
1370    *
1371    * Calling conditions:
1372    *
1373    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1374    * transferred to `to`.
1375    * - When `from` is zero, `tokenId` will be minted for `to`.
1376    */
1377   function _beforeTokenTransfers(
1378     address from,
1379     address to,
1380     uint256 startTokenId,
1381     uint256 quantity
1382   ) internal virtual {}
1383 
1384   /**
1385    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1386    * minting.
1387    *
1388    * startTokenId - the first token id to be transferred
1389    * quantity - the amount to be transferred
1390    *
1391    * Calling conditions:
1392    *
1393    * - when `from` and `to` are both non-zero.
1394    * - `from` and `to` are never both zero.
1395    */
1396   function _afterTokenTransfers(
1397     address from,
1398     address to,
1399     uint256 startTokenId,
1400     uint256 quantity
1401   ) internal virtual {}
1402 }
1403 //
1404 //░██▄▒▄▀▄▒█▀▄░▀█▀░▀░▄▀▀░░▒█▀▒▄▀▄▒█▀▄░█▄▒▄█░░▒█▀▒█▀▄▒██▀░█▄░█░▄▀▀
1405 //▒█▄█░█▀█░█▀▄░▒█▒░░▒▄██▒░░█▀░█▀█░█▀▄░█▒▀▒█▒░░█▀░█▀▄░█▄▄░█▒▀█▒▄██
1406 
1407 
1408 library OpenSeaGasFreeListing {
1409     /**
1410     @notice Returns whether the operator is an OpenSea proxy for the owner, thus
1411     allowing it to list without the token owner paying gas.
1412     @dev ERC{721,1155}.isApprovedForAll should be overriden to also check if
1413     this function returns true.
1414      */
1415     function isApprovedForAll(address owner, address operator) internal view returns (bool) {
1416         ProxyRegistry registry;
1417         assembly {
1418             switch chainid()
1419             case 1 {
1420                 // mainnet
1421                 registry := 0xa5409ec958c83c3f309868babaca7c86dcb077c1
1422             }
1423             case 4 {
1424                 // rinkeby
1425                 registry := 0xf57b2c51ded3a29e6891aba85459d600256cf317
1426             }
1427         }
1428 
1429         return address(registry) != address(0) && (address(registry.proxies(owner)) == operator);
1430     }
1431 }
1432 
1433 contract OwnableDelegateProxy {}
1434 
1435 contract ProxyRegistry {
1436     mapping(address => OwnableDelegateProxy) public proxies;
1437 }
1438 
1439 
1440 contract BartsFarmFrens is Ownable, ERC721A, ReentrancyGuard {
1441 
1442     using Address for address;
1443     using Strings for uint256;
1444 
1445     //allows for 104 tokens to be minted for (0,1,2 team owner tokens)+ 101 reserved for giveaways, contest, etc. 
1446     uint256 public MAX_TEAM_RESERVES_PRESALE = 104;
1447     //allows for 84 to be minted for team owners personal from randomized main batch (28 each)
1448     uint256 public MAX_TEAM_PERSONAL_RESERVES_PRESALE = 84;
1449     //sets immutable value for total collection of 8888 which includes 8700 non-team/public tokens
1450     uint256 public immutable MAX_TOKENS;
1451     //limits the number of tokens during team personal reserves presale per address
1452     uint256 public MAX_TEAM_PERSONAL_TOKENS_PER_ADDRESS = 28;
1453     //limits the number of tokens during OG presale per address
1454     uint256 public MAX_OG_TOKENS_PER_ADDRESS = 1;
1455     //limits the number of tokens during presale per address
1456     uint256 public MAX_PRESALE_TOKENS_PER_ADDRESS = 3;
1457     //OG presale token price
1458     uint256 public OG_PRESALE_TOKEN_PRICE = 0.00 ether;
1459     //public token price
1460     uint256 public TOKEN_PRICE = 0.04 ether;
1461     //max mints per tx during the public mint
1462     uint256 public MAX_MINTS_PER_TX = 50;
1463 
1464     bool public preSale = false;
1465     bool public OGpreSale = false;
1466     bool public TEAMpreSale = false;
1467     bool public publicSale = false;
1468     string public BFFsProvenance;
1469 
1470         // whitelist merkle root
1471     bytes32 public TEAMmerkleroot;
1472 
1473         // whitelist merkle root
1474     bytes32 public OGmerkleroot;
1475 
1476         // whitelist merkle root
1477     bytes32 public PREmerkleroot;
1478 
1479     //tracks number a user has minted during team personal presale
1480     mapping (address => uint) public TEAMpresaleNumMinted;
1481 
1482     //tracks number a user has minted during OG presale
1483     mapping (address => uint) public OGpresaleNumMinted;
1484 
1485     //tracks number a user has minted during presale
1486     mapping (address => uint) public presaleNumMinted;
1487 
1488     constructor(
1489     uint256 maxBatchSize_,
1490     uint256 collectionSize_,
1491     uint256 maxTOKENS_
1492   ) ERC721A("Barts Farm Frens","BFFs", maxBatchSize_,collectionSize_) {
1493     MAX_MINTS_PER_TX = maxBatchSize_;
1494     MAX_TOKENS = maxTOKENS_;
1495     require(
1496         maxTOKENS_ <= collectionSize_,
1497         "larger collection size needed"
1498     );   
1499   }
1500 
1501   modifier callerIsUser() {
1502     require(tx.origin == msg.sender, "The caller is another contract");
1503     _;
1504   }
1505 
1506 //minting function for personal team presale
1507     function TEAMpresaleMint(uint256 quantity, bytes32[] calldata TEAMPresaleMerkleProof) external payable callerIsUser nonReentrant {
1508         require(TEAMpreSale, "team pre sale is not live");
1509         require(totalSupply() + quantity <= MAX_TOKENS, "minting this many would exceed supply");
1510         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1511         require(MerkleProof.verify(TEAMPresaleMerkleProof, TEAMmerkleroot, leaf), "Invalid proof.");
1512         _checkTEAMPreMintRequirements(quantity);
1513         _safeMint(msg.sender, quantity);
1514     }
1515 
1516     function _checkTEAMPreMintRequirements(uint256 quantity) internal {
1517         require(quantity > 0 && quantity <= MAX_TEAM_PERSONAL_TOKENS_PER_ADDRESS, "invalid quantity: zero or greater than mint allowance");
1518         require(msg.value == OG_PRESALE_TOKEN_PRICE * quantity, "wrong amount of ether sent");
1519         TEAMpresaleNumMinted[msg.sender] = TEAMpresaleNumMinted[msg.sender] + quantity;
1520         require(TEAMpresaleNumMinted[msg.sender] <= MAX_TEAM_PERSONAL_TOKENS_PER_ADDRESS, "Cannot mint more than 28 per address in this phase");
1521     }  
1522 
1523 //minting function for the OG presale
1524     function OGpresaleMint(uint256 quantity, bytes32[] calldata OGPresaleMerkleProof) external payable callerIsUser nonReentrant {
1525         require(OGpreSale, "pre sale is not live");
1526         require(totalSupply() + quantity <= MAX_TOKENS, "minting this many would exceed supply");
1527         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1528         require(MerkleProof.verify(OGPresaleMerkleProof, OGmerkleroot, leaf), "Invalid proof.");
1529         _checkOGPreMintRequirements(quantity);
1530         _safeMint(msg.sender, quantity);
1531     }
1532 
1533     function _checkOGPreMintRequirements(uint256 quantity) internal {
1534         require(quantity > 0 && quantity <= MAX_OG_TOKENS_PER_ADDRESS, "invalid quantity: zero or greater than mint allowance");
1535         require(msg.value == OG_PRESALE_TOKEN_PRICE * quantity, "wrong amount of ether sent");
1536         OGpresaleNumMinted[msg.sender] = OGpresaleNumMinted[msg.sender] + quantity;
1537         require(OGpresaleNumMinted[msg.sender] <= MAX_OG_TOKENS_PER_ADDRESS, "Cannot mint more than 1 per address in this phase");
1538     }
1539 //minting function for the presale
1540     function presaleMint(uint256 quantity, bytes32[] calldata PresaleMerkleProof) external payable callerIsUser nonReentrant {
1541         require(preSale, "pre sale is not live");
1542         require(totalSupply() + quantity <= MAX_TOKENS, "minting this many would exceed supply");
1543         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1544         require(MerkleProof.verify(PresaleMerkleProof, PREmerkleroot, leaf), "Invalid proof.");
1545         _checkPreMintRequirements(quantity);
1546         _safeMint(msg.sender, quantity);
1547     }
1548 
1549     function _checkPreMintRequirements(uint256 quantity) internal {
1550         require(quantity > 0 && quantity <= MAX_PRESALE_TOKENS_PER_ADDRESS, "invalid quantity: zero or greater than mint allowance");
1551         require(msg.value == TOKEN_PRICE * quantity, "wrong amount of ether sent");
1552         presaleNumMinted[msg.sender] = presaleNumMinted[msg.sender] + quantity;
1553         require(presaleNumMinted[msg.sender] <= MAX_PRESALE_TOKENS_PER_ADDRESS, "Cannot mint more than 3 per address in this phase");
1554     }
1555 
1556 //public mint function
1557     function mint(uint256 quantity) external payable callerIsUser nonReentrant {
1558         require(publicSale, "public sale is not live");
1559         require(totalSupply() + quantity <= MAX_TOKENS, "invalid quantity: would exceed max supply");
1560         _checkMintRequirements(quantity);
1561         _safeMint(msg.sender, quantity);
1562     }
1563 
1564     function _checkMintRequirements(uint256 quantity) internal {
1565         require(quantity > 0 && quantity <= MAX_MINTS_PER_TX, "invalid quantity: zero or greater than mint allowance");
1566         require(msg.value == TOKEN_PRICE * quantity, "wrong amount of ether sent");
1567 
1568     }
1569 //admin minting function for team tokens
1570     function teamReservesPreSaleMint(uint256 quantity) public onlyOwner {
1571         require(quantity <= MAX_TEAM_RESERVES_PRESALE, "Can't reserve more than set amount" );
1572         MAX_TEAM_RESERVES_PRESALE -= quantity;
1573         require(totalSupply() + quantity <= MAX_TOKENS, "invalid quantity: would exceed max supply");
1574         _safeMint(msg.sender, quantity);
1575     }
1576 
1577     function toggleOGpreSale() public onlyOwner {
1578         OGpreSale = !OGpreSale;
1579     }
1580 
1581     function toggleTEAMpreSale() public onlyOwner {
1582         TEAMpreSale = !TEAMpreSale;
1583     }
1584 
1585     function togglePreSale() public onlyOwner {
1586         preSale = !preSale;
1587     }
1588 
1589     function togglePublicSale() public onlyOwner {
1590         publicSale = !publicSale;
1591     }
1592 
1593     function numberMinted(address owner) public view returns (uint256) {
1594     return _numberMinted(owner);
1595   }
1596 
1597     function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1598     _setOwnersExplicit(quantity);
1599   }
1600 
1601     // // metadata URI
1602     string private _baseTokenURI;
1603 
1604     function _baseURI() internal view virtual override returns (string memory) {
1605     return _baseTokenURI;
1606   }
1607 
1608     function setBaseURI(string calldata baseURI) external onlyOwner {
1609     _baseTokenURI = baseURI;
1610   } 
1611 
1612     function setTEAMmerkleroot(bytes32 newTEAMmerkle) public onlyOwner {
1613     TEAMmerkleroot = newTEAMmerkle;
1614     }
1615 
1616     function setOGmerkleroot(bytes32 newOGmerkle) public onlyOwner {
1617     OGmerkleroot = newOGmerkle;
1618     }
1619 
1620     function setPREmerkleroot(bytes32 newPREmerkle) public onlyOwner {
1621     PREmerkleroot = newPREmerkle;
1622     }
1623 
1624     function setMAX_PRESALE_TOKENS_PER_ADDRESS(uint256 _MAX_PRESALE_TOKENS_PER_ADDRESS) public onlyOwner() {
1625     MAX_PRESALE_TOKENS_PER_ADDRESS = _MAX_PRESALE_TOKENS_PER_ADDRESS;
1626     }
1627 
1628     function setMAX_OG_TOKENS_PER_ADDRESS(uint256 _MAX_OG_TOKENS_PER_ADDRESS) public onlyOwner() {
1629     MAX_OG_TOKENS_PER_ADDRESS = _MAX_OG_TOKENS_PER_ADDRESS;
1630     }
1631 
1632     function setMAX_MINTS_PER_TX(uint256 _MAX_MINTS_PER_TX) public onlyOwner() {
1633     MAX_MINTS_PER_TX = _MAX_MINTS_PER_TX;
1634     }
1635 
1636     function setTOKEN_PRICE(uint256 _TOKEN_PRICE) public onlyOwner() {
1637     TOKEN_PRICE = _TOKEN_PRICE;
1638     }
1639 
1640     function setProvenanceHash(string memory provenanceHash) external onlyOwner {
1641         BFFsProvenance = provenanceHash;
1642     }
1643 
1644     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1645         return OpenSeaGasFreeListing.isApprovedForAll(owner, operator) || super.isApprovedForAll(owner, operator);
1646     }
1647 
1648     function getOwnershipData(uint256 tokenId)
1649     external
1650     view
1651     returns (TokenOwnership memory)
1652   {
1653     return ownershipOf(tokenId);
1654   }
1655 
1656   function withdrawMoney() external onlyOwner nonReentrant {
1657     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1658     require(success, "Transfer failed.");
1659   }
1660 
1661 }