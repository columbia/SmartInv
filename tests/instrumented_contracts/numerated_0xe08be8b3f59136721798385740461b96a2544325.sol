1 // SPDX-License-Identifier: MIT
2 //
3 
4 //-__ /\\              ,,         -__ /\                                       ,    /\ 
5 //  ||  \\             ||           || \,                  ' ,        ;       ||   ||  
6 // /||__|| \\ \\ \\/\\ ||/\  _-_,  /|| /    _-_  \\/\\/\\ \\ \\ /`    \\/\/\ =||= =||= 
7 // \||__|| || || || || ||_< ||_.   \||/-   || \\ || || || ||  \\      || | |  ||   ||  
8 //  ||  |, || || || || || |  ~ ||   ||  \  ||/   || || || ||  /\\     || | |  ||   ||  
9 //_-||-_/  \\/\\ \\ \\ \\,\ ,-_-  _---_-|, \\,/  \\ \\ \\ \\ /  \; <> \\/\\/  \\,  \\, 
10 //  ||
11 
12 //2022
13 
14 // File: @openzeppelin/contracts/utils/Address.sol
15 
16 
17 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
18 
19 pragma solidity ^0.8.1;
20 
21 /**
22  * @dev Collection of functions related to the address type
23  */
24 library Address {
25     /**
26      * @dev Returns true if `account` is a contract.
27      *
28      * [IMPORTANT]
29      * ====
30      * It is unsafe to assume that an address for which this function returns
31      * false is an externally-owned account (EOA) and not a contract.
32      *
33      * Among others, `isContract` will return false for the following
34      * types of addresses:
35      *
36      *  - an externally-owned account
37      *  - a contract in construction
38      *  - an address where a contract will be created
39      *  - an address where a contract lived, but was destroyed
40      * ====
41      *
42      * [IMPORTANT]
43      * ====
44      * You shouldn't rely on `isContract` to protect against flash loan attacks!
45      *
46      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
47      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
48      * constructor.
49      * ====
50      */
51     function isContract(address account) internal view returns (bool) {
52         // This method relies on extcodesize/address.code.length, which returns 0
53         // for contracts in construction, since the code is only stored at the end
54         // of the constructor execution.
55 
56         return account.code.length > 0;
57     }
58 
59     /**
60      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
61      * `recipient`, forwarding all available gas and reverting on errors.
62      *
63      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
64      * of certain opcodes, possibly making contracts go over the 2300 gas limit
65      * imposed by `transfer`, making them unable to receive funds via
66      * `transfer`. {sendValue} removes this limitation.
67      *
68      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
69      *
70      * IMPORTANT: because control is transferred to `recipient`, care must be
71      * taken to not create reentrancy vulnerabilities. Consider using
72      * {ReentrancyGuard} or the
73      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
74      */
75     function sendValue(address payable recipient, uint256 amount) internal {
76         require(address(this).balance >= amount, "Address: insufficient balance");
77 
78         (bool success, ) = recipient.call{value: amount}("");
79         require(success, "Address: unable to send value, recipient may have reverted");
80     }
81 
82     /**
83      * @dev Performs a Solidity function call using a low level `call`. A
84      * plain `call` is an unsafe replacement for a function call: use this
85      * function instead.
86      *
87      * If `target` reverts with a revert reason, it is bubbled up by this
88      * function (like regular Solidity function calls).
89      *
90      * Returns the raw returned data. To convert to the expected return value,
91      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
92      *
93      * Requirements:
94      *
95      * - `target` must be a contract.
96      * - calling `target` with `data` must not revert.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
101         return functionCall(target, data, "Address: low-level call failed");
102     }
103 
104     /**
105      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
106      * `errorMessage` as a fallback revert reason when `target` reverts.
107      *
108      * _Available since v3.1._
109      */
110     function functionCall(
111         address target,
112         bytes memory data,
113         string memory errorMessage
114     ) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
120      * but also transferring `value` wei to `target`.
121      *
122      * Requirements:
123      *
124      * - the calling contract must have an ETH balance of at least `value`.
125      * - the called Solidity function must be `payable`.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(
130         address target,
131         bytes memory data,
132         uint256 value
133     ) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
139      * with `errorMessage` as a fallback revert reason when `target` reverts.
140      *
141      * _Available since v3.1._
142      */
143     function functionCallWithValue(
144         address target,
145         bytes memory data,
146         uint256 value,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         require(address(this).balance >= value, "Address: insufficient balance for call");
150         require(isContract(target), "Address: call to non-contract");
151 
152         (bool success, bytes memory returndata) = target.call{value: value}(data);
153         return verifyCallResult(success, returndata, errorMessage);
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
163         return functionStaticCall(target, data, "Address: low-level static call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
168      * but performing a static call.
169      *
170      * _Available since v3.3._
171      */
172     function functionStaticCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal view returns (bytes memory) {
177         require(isContract(target), "Address: static call to non-contract");
178 
179         (bool success, bytes memory returndata) = target.staticcall(data);
180         return verifyCallResult(success, returndata, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
190         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
195      * but performing a delegate call.
196      *
197      * _Available since v3.4._
198      */
199     function functionDelegateCall(
200         address target,
201         bytes memory data,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         require(isContract(target), "Address: delegate call to non-contract");
205 
206         (bool success, bytes memory returndata) = target.delegatecall(data);
207         return verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
212      * revert reason using the provided one.
213      *
214      * _Available since v4.3._
215      */
216     function verifyCallResult(
217         bool success,
218         bytes memory returndata,
219         string memory errorMessage
220     ) internal pure returns (bytes memory) {
221         if (success) {
222             return returndata;
223         } else {
224             // Look for revert reason and bubble it up if present
225             if (returndata.length > 0) {
226                 // The easiest way to bubble the revert reason is using memory via assembly
227 
228                 assembly {
229                     let returndata_size := mload(returndata)
230                     revert(add(32, returndata), returndata_size)
231                 }
232             } else {
233                 revert(errorMessage);
234             }
235         }
236     }
237 }
238 
239 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
240 
241 
242 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @title ERC721 token receiver interface
248  * @dev Interface for any contract that wants to support safeTransfers
249  * from ERC721 asset contracts.
250  */
251 interface IERC721Receiver {
252     /**
253      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
254      * by `operator` from `from`, this function is called.
255      *
256      * It must return its Solidity selector to confirm the token transfer.
257      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
258      *
259      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
260      */
261     function onERC721Received(
262         address operator,
263         address from,
264         uint256 tokenId,
265         bytes calldata data
266     ) external returns (bytes4);
267 }
268 
269 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
270 
271 
272 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @dev Interface of the ERC165 standard, as defined in the
278  * https://eips.ethereum.org/EIPS/eip-165[EIP].
279  *
280  * Implementers can declare support of contract interfaces, which can then be
281  * queried by others ({ERC165Checker}).
282  *
283  * For an implementation, see {ERC165}.
284  */
285 interface IERC165 {
286     /**
287      * @dev Returns true if this contract implements the interface defined by
288      * `interfaceId`. See the corresponding
289      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
290      * to learn more about how these ids are created.
291      *
292      * This function call must use less than 30 000 gas.
293      */
294     function supportsInterface(bytes4 interfaceId) external view returns (bool);
295 }
296 
297 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 
305 /**
306  * @dev Implementation of the {IERC165} interface.
307  *
308  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
309  * for the additional interface id that will be supported. For example:
310  *
311  * ```solidity
312  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
314  * }
315  * ```
316  *
317  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
318  */
319 abstract contract ERC165 is IERC165 {
320     /**
321      * @dev See {IERC165-supportsInterface}.
322      */
323     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
324         return interfaceId == type(IERC165).interfaceId;
325     }
326 }
327 
328 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
329 
330 
331 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 
336 /**
337  * @dev Required interface of an ERC721 compliant contract.
338  */
339 interface IERC721 is IERC165 {
340     /**
341      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
342      */
343     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
344 
345     /**
346      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
347      */
348     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
349 
350     /**
351      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
352      */
353     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
354 
355     /**
356      * @dev Returns the number of tokens in ``owner``'s account.
357      */
358     function balanceOf(address owner) external view returns (uint256 balance);
359 
360     /**
361      * @dev Returns the owner of the `tokenId` token.
362      *
363      * Requirements:
364      *
365      * - `tokenId` must exist.
366      */
367     function ownerOf(uint256 tokenId) external view returns (address owner);
368 
369     /**
370      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
371      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
372      *
373      * Requirements:
374      *
375      * - `from` cannot be the zero address.
376      * - `to` cannot be the zero address.
377      * - `tokenId` token must exist and be owned by `from`.
378      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
379      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
380      *
381      * Emits a {Transfer} event.
382      */
383     function safeTransferFrom(
384         address from,
385         address to,
386         uint256 tokenId
387     ) external;
388 
389     /**
390      * @dev Transfers `tokenId` token from `from` to `to`.
391      *
392      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
393      *
394      * Requirements:
395      *
396      * - `from` cannot be the zero address.
397      * - `to` cannot be the zero address.
398      * - `tokenId` token must be owned by `from`.
399      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
400      *
401      * Emits a {Transfer} event.
402      */
403     function transferFrom(
404         address from,
405         address to,
406         uint256 tokenId
407     ) external;
408 
409     /**
410      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
411      * The approval is cleared when the token is transferred.
412      *
413      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
414      *
415      * Requirements:
416      *
417      * - The caller must own the token or be an approved operator.
418      * - `tokenId` must exist.
419      *
420      * Emits an {Approval} event.
421      */
422     function approve(address to, uint256 tokenId) external;
423 
424     /**
425      * @dev Returns the account approved for `tokenId` token.
426      *
427      * Requirements:
428      *
429      * - `tokenId` must exist.
430      */
431     function getApproved(uint256 tokenId) external view returns (address operator);
432 
433     /**
434      * @dev Approve or remove `operator` as an operator for the caller.
435      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
436      *
437      * Requirements:
438      *
439      * - The `operator` cannot be the caller.
440      *
441      * Emits an {ApprovalForAll} event.
442      */
443     function setApprovalForAll(address operator, bool _approved) external;
444 
445     /**
446      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
447      *
448      * See {setApprovalForAll}
449      */
450     function isApprovedForAll(address owner, address operator) external view returns (bool);
451 
452     /**
453      * @dev Safely transfers `tokenId` token from `from` to `to`.
454      *
455      * Requirements:
456      *
457      * - `from` cannot be the zero address.
458      * - `to` cannot be the zero address.
459      * - `tokenId` token must exist and be owned by `from`.
460      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
461      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
462      *
463      * Emits a {Transfer} event.
464      */
465     function safeTransferFrom(
466         address from,
467         address to,
468         uint256 tokenId,
469         bytes calldata data
470     ) external;
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
474 
475 
476 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 
481 /**
482  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
483  * @dev See https://eips.ethereum.org/EIPS/eip-721
484  */
485 interface IERC721Enumerable is IERC721 {
486     /**
487      * @dev Returns the total amount of tokens stored by the contract.
488      */
489     function totalSupply() external view returns (uint256);
490 
491     /**
492      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
493      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
494      */
495     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
496 
497     /**
498      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
499      * Use along with {totalSupply} to enumerate all tokens.
500      */
501     function tokenByIndex(uint256 index) external view returns (uint256);
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
514  * @dev See https://eips.ethereum.org/EIPS/eip-721
515  */
516 interface IERC721Metadata is IERC721 {
517     /**
518      * @dev Returns the token collection name.
519      */
520     function name() external view returns (string memory);
521 
522     /**
523      * @dev Returns the token collection symbol.
524      */
525     function symbol() external view returns (string memory);
526 
527     /**
528      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
529      */
530     function tokenURI(uint256 tokenId) external view returns (string memory);
531 }
532 
533 // File: @openzeppelin/contracts/utils/Strings.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @dev String operations.
542  */
543 library Strings {
544     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
548      */
549     function toString(uint256 value) internal pure returns (string memory) {
550         // Inspired by OraclizeAPI's implementation - MIT licence
551         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
552 
553         if (value == 0) {
554             return "0";
555         }
556         uint256 temp = value;
557         uint256 digits;
558         while (temp != 0) {
559             digits++;
560             temp /= 10;
561         }
562         bytes memory buffer = new bytes(digits);
563         while (value != 0) {
564             digits -= 1;
565             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
566             value /= 10;
567         }
568         return string(buffer);
569     }
570 
571     /**
572      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
573      */
574     function toHexString(uint256 value) internal pure returns (string memory) {
575         if (value == 0) {
576             return "0x00";
577         }
578         uint256 temp = value;
579         uint256 length = 0;
580         while (temp != 0) {
581             length++;
582             temp >>= 8;
583         }
584         return toHexString(value, length);
585     }
586 
587     /**
588      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
589      */
590     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
591         bytes memory buffer = new bytes(2 * length + 2);
592         buffer[0] = "0";
593         buffer[1] = "x";
594         for (uint256 i = 2 * length + 1; i > 1; --i) {
595             buffer[i] = _HEX_SYMBOLS[value & 0xf];
596             value >>= 4;
597         }
598         require(value == 0, "Strings: hex length insufficient");
599         return string(buffer);
600     }
601 }
602 
603 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
604 
605 
606 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 /**
611  * @dev These functions deal with verification of Merkle Trees proofs.
612  *
613  * The proofs can be generated using the JavaScript library
614  * https://github.com/miguelmota/merkletreejs[merkletreejs].
615  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
616  *
617  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
618  */
619 library MerkleProof {
620     /**
621      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
622      * defined by `root`. For this, a `proof` must be provided, containing
623      * sibling hashes on the branch from the leaf to the root of the tree. Each
624      * pair of leaves and each pair of pre-images are assumed to be sorted.
625      */
626     function verify(
627         bytes32[] memory proof,
628         bytes32 root,
629         bytes32 leaf
630     ) internal pure returns (bool) {
631         return processProof(proof, leaf) == root;
632     }
633 
634     /**
635      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
636      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
637      * hash matches the root of the tree. When processing the proof, the pairs
638      * of leafs & pre-images are assumed to be sorted.
639      *
640      * _Available since v4.4._
641      */
642     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
643         bytes32 computedHash = leaf;
644         for (uint256 i = 0; i < proof.length; i++) {
645             bytes32 proofElement = proof[i];
646             if (computedHash <= proofElement) {
647                 // Hash(current computed hash + current element of the proof)
648                 computedHash = _efficientHash(computedHash, proofElement);
649             } else {
650                 // Hash(current element of the proof + current computed hash)
651                 computedHash = _efficientHash(proofElement, computedHash);
652             }
653         }
654         return computedHash;
655     }
656 
657     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
658         assembly {
659             mstore(0x00, a)
660             mstore(0x20, b)
661             value := keccak256(0x00, 0x40)
662         }
663     }
664 }
665 
666 // File: @openzeppelin/contracts/utils/Context.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @dev Provides information about the current execution context, including the
675  * sender of the transaction and its data. While these are generally available
676  * via msg.sender and msg.data, they should not be accessed in such a direct
677  * manner, since when dealing with meta-transactions the account sending and
678  * paying for execution may not be the actual sender (as far as an application
679  * is concerned).
680  *
681  * This contract is only required for intermediate, library-like contracts.
682  */
683 abstract contract Context {
684     function _msgSender() internal view virtual returns (address) {
685         return msg.sender;
686     }
687 
688     function _msgData() internal view virtual returns (bytes calldata) {
689         return msg.data;
690     }
691 }
692 
693 // File: @openzeppelin/contracts/access/Ownable.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @dev Contract module which provides a basic access control mechanism, where
703  * there is an account (an owner) that can be granted exclusive access to
704  * specific functions.
705  *
706  * By default, the owner account will be the one that deploys the contract. This
707  * can later be changed with {transferOwnership}.
708  *
709  * This module is used through inheritance. It will make available the modifier
710  * `onlyOwner`, which can be applied to your functions to restrict their use to
711  * the owner.
712  */
713 abstract contract Ownable is Context {
714     address private _owner;
715 
716     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
717 
718     /**
719      * @dev Initializes the contract setting the deployer as the initial owner.
720      */
721     constructor() {
722         _transferOwnership(_msgSender());
723     }
724 
725     /**
726      * @dev Returns the address of the current owner.
727      */
728     function owner() public view virtual returns (address) {
729         return _owner;
730     }
731 
732     /**
733      * @dev Throws if called by any account other than the owner.
734      */
735     modifier onlyOwner() {
736         require(owner() == _msgSender(), "Ownable: caller is not the owner");
737         _;
738     }
739 
740     /**
741      * @dev Leaves the contract without owner. It will not be possible to call
742      * `onlyOwner` functions anymore. Can only be called by the current owner.
743      *
744      * NOTE: Renouncing ownership will leave the contract without an owner,
745      * thereby removing any functionality that is only available to the owner.
746      */
747     function renounceOwnership() public virtual onlyOwner {
748         _transferOwnership(address(0));
749     }
750 
751     /**
752      * @dev Transfers ownership of the contract to a new account (`newOwner`).
753      * Can only be called by the current owner.
754      */
755     function transferOwnership(address newOwner) public virtual onlyOwner {
756         require(newOwner != address(0), "Ownable: new owner is the zero address");
757         _transferOwnership(newOwner);
758     }
759 
760     /**
761      * @dev Transfers ownership of the contract to a new account (`newOwner`).
762      * Internal function without access restriction.
763      */
764     function _transferOwnership(address newOwner) internal virtual {
765         address oldOwner = _owner;
766         _owner = newOwner;
767         emit OwnershipTransferred(oldOwner, newOwner);
768     }
769 }
770 
771 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
772 
773 
774 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
775 
776 pragma solidity ^0.8.0;
777 
778 /**
779  * @dev Contract module that helps prevent reentrant calls to a function.
780  *
781  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
782  * available, which can be applied to functions to make sure there are no nested
783  * (reentrant) calls to them.
784  *
785  * Note that because there is a single `nonReentrant` guard, functions marked as
786  * `nonReentrant` may not call one another. This can be worked around by making
787  * those functions `private`, and then adding `external` `nonReentrant` entry
788  * points to them.
789  *
790  * TIP: If you would like to learn more about reentrancy and alternative ways
791  * to protect against it, check out our blog post
792  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
793  */
794 abstract contract ReentrancyGuard {
795     // Booleans are more expensive than uint256 or any type that takes up a full
796     // word because each write operation emits an extra SLOAD to first read the
797     // slot's contents, replace the bits taken up by the boolean, and then write
798     // back. This is the compiler's defense against contract upgrades and
799     // pointer aliasing, and it cannot be disabled.
800 
801     // The values being non-zero value makes deployment a bit more expensive,
802     // but in exchange the refund on every call to nonReentrant will be lower in
803     // amount. Since refunds are capped to a percentage of the total
804     // transaction's gas, it is best to keep them low in cases like this one, to
805     // increase the likelihood of the full refund coming into effect.
806     uint256 private constant _NOT_ENTERED = 1;
807     uint256 private constant _ENTERED = 2;
808 
809     uint256 private _status;
810 
811     constructor() {
812         _status = _NOT_ENTERED;
813     }
814 
815     /**
816      * @dev Prevents a contract from calling itself, directly or indirectly.
817      * Calling a `nonReentrant` function from another `nonReentrant`
818      * function is not supported. It is possible to prevent this from happening
819      * by making the `nonReentrant` function external, and making it call a
820      * `private` function that does the actual work.
821      */
822     modifier nonReentrant() {
823         // On the first call to nonReentrant, _notEntered will be true
824         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
825 
826         // Any calls to nonReentrant after this point will fail
827         _status = _ENTERED;
828 
829         _;
830 
831         // By storing the original value once again, a refund is triggered (see
832         // https://eips.ethereum.org/EIPS/eip-2200)
833         _status = _NOT_ENTERED;
834     }
835 }
836 
837 
838 pragma solidity ^0.8.0;
839 
840 
841 /**ERC721A import
842  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
843  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
844  *
845  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
846  *
847  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
848  *
849  * Does not support burning tokens to address(0).
850  */
851 contract ERC721A is
852   Context,
853   ERC165,
854   IERC721,
855   IERC721Metadata,
856   IERC721Enumerable
857 {
858   using Address for address;
859   using Strings for uint256;
860 
861   struct TokenOwnership {
862     address addr;
863     uint64 startTimestamp;
864   }
865 
866   struct AddressData {
867     uint128 balance;
868     uint128 numberMinted;
869   }
870 
871   uint256 private currentIndex = 0;
872 
873   uint256 internal immutable collectionSize;
874   uint256 internal immutable maxBatchSize;
875 
876   // Token name
877   string private _name;
878 
879   // Token symbol
880   string private _symbol;
881 
882   // Mapping from token ID to ownership details
883   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
884   mapping(uint256 => TokenOwnership) private _ownerships;
885 
886   // Mapping owner address to address data
887   mapping(address => AddressData) private _addressData;
888 
889   // Mapping from token ID to approved address
890   mapping(uint256 => address) private _tokenApprovals;
891 
892   // Mapping from owner to operator approvals
893   mapping(address => mapping(address => bool)) private _operatorApprovals;
894 
895   /**
896    * @dev
897    * `maxBatchSize` refers to how much a minter can mint at a time.
898    * `collectionSize_` refers to how many tokens are in the collection.
899    */
900   constructor(
901     string memory name_,
902     string memory symbol_,
903     uint256 maxBatchSize_,
904     uint256 collectionSize_
905   ) {
906     require(
907       collectionSize_ > 0,
908       "ERC721A: collection must have a nonzero supply"
909     );
910     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
911     _name = name_;
912     _symbol = symbol_;
913     maxBatchSize = maxBatchSize_;
914     collectionSize = collectionSize_;
915   }
916 
917   /**
918    * @dev See {IERC721Enumerable-totalSupply}.
919    */
920   function totalSupply() public view override returns (uint256) {
921     return currentIndex;
922   }
923 
924   /**
925    * @dev See {IERC721Enumerable-tokenByIndex}.
926    */
927   function tokenByIndex(uint256 index) public view override returns (uint256) {
928     require(index < totalSupply(), "ERC721A: global index out of bounds");
929     return index;
930   }
931 
932   /**
933    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
934    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
935    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
936    */
937   function tokenOfOwnerByIndex(address owner, uint256 index)
938     public
939     view
940     override
941     returns (uint256)
942   {
943     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
944     uint256 numMintedSoFar = totalSupply();
945     uint256 tokenIdsIdx = 0;
946     address currOwnershipAddr = address(0);
947     for (uint256 i = 0; i < numMintedSoFar; i++) {
948       TokenOwnership memory ownership = _ownerships[i];
949       if (ownership.addr != address(0)) {
950         currOwnershipAddr = ownership.addr;
951       }
952       if (currOwnershipAddr == owner) {
953         if (tokenIdsIdx == index) {
954           return i;
955         }
956         tokenIdsIdx++;
957       }
958     }
959     revert("ERC721A: unable to get token of owner by index");
960   }
961 
962   /**
963    * @dev See {IERC165-supportsInterface}.
964    */
965   function supportsInterface(bytes4 interfaceId)
966     public
967     view
968     virtual
969     override(ERC165, IERC165)
970     returns (bool)
971   {
972     return
973       interfaceId == type(IERC721).interfaceId ||
974       interfaceId == type(IERC721Metadata).interfaceId ||
975       interfaceId == type(IERC721Enumerable).interfaceId ||
976       super.supportsInterface(interfaceId);
977   }
978 
979   /**
980    * @dev See {IERC721-balanceOf}.
981    */
982   function balanceOf(address owner) public view override returns (uint256) {
983     require(owner != address(0), "ERC721A: balance query for the zero address");
984     return uint256(_addressData[owner].balance);
985   }
986 
987   function _numberMinted(address owner) internal view returns (uint256) {
988     require(
989       owner != address(0),
990       "ERC721A: number minted query for the zero address"
991     );
992     return uint256(_addressData[owner].numberMinted);
993   }
994 
995   function ownershipOf(uint256 tokenId)
996     internal
997     view
998     returns (TokenOwnership memory)
999   {
1000     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1001 
1002     uint256 lowestTokenToCheck;
1003     if (tokenId >= maxBatchSize) {
1004       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1005     }
1006 
1007     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1008       TokenOwnership memory ownership = _ownerships[curr];
1009       if (ownership.addr != address(0)) {
1010         return ownership;
1011       }
1012     }
1013 
1014     revert("ERC721A: unable to determine the owner of token");
1015   }
1016 
1017   /**
1018    * @dev See {IERC721-ownerOf}.
1019    */
1020   function ownerOf(uint256 tokenId) public view override returns (address) {
1021     return ownershipOf(tokenId).addr;
1022   }
1023 
1024   /**
1025    * @dev See {IERC721Metadata-name}.
1026    */
1027   function name() public view virtual override returns (string memory) {
1028     return _name;
1029   }
1030 
1031   /**
1032    * @dev See {IERC721Metadata-symbol}.
1033    */
1034   function symbol() public view virtual override returns (string memory) {
1035     return _symbol;
1036   }
1037 
1038   /**
1039    * @dev See {IERC721Metadata-tokenURI}.
1040    */
1041   function tokenURI(uint256 tokenId)
1042     public
1043     view
1044     virtual
1045     override
1046     returns (string memory)
1047   {
1048     require(
1049       _exists(tokenId),
1050       "ERC721Metadata: URI query for nonexistent token"
1051     );
1052 
1053     string memory baseURI = _baseURI();
1054     return
1055       bytes(baseURI).length > 0
1056         ? string(abi.encodePacked(baseURI, tokenId.toString(),".json"))
1057         : "";
1058   }
1059 
1060   /**
1061    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1062    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1063    * by default, can be overriden in child contracts.
1064    */
1065   function _baseURI() internal view virtual returns (string memory) {
1066     return "";
1067   }
1068 
1069   /**
1070    * @dev See {IERC721-approve}.
1071    */
1072   function approve(address to, uint256 tokenId) public override {
1073     address owner = ERC721A.ownerOf(tokenId);
1074     require(to != owner, "ERC721A: approval to current owner");
1075 
1076     require(
1077       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1078       "ERC721A: approve caller is not owner nor approved for all"
1079     );
1080 
1081     _approve(to, tokenId, owner);
1082   }
1083 
1084   /**
1085    * @dev See {IERC721-getApproved}.
1086    */
1087   function getApproved(uint256 tokenId) public view override returns (address) {
1088     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1089 
1090     return _tokenApprovals[tokenId];
1091   }
1092 
1093   /**
1094    * @dev See {IERC721-setApprovalForAll}.
1095    */
1096   function setApprovalForAll(address operator, bool approved) public override {
1097     require(operator != _msgSender(), "ERC721A: approve to caller");
1098 
1099     _operatorApprovals[_msgSender()][operator] = approved;
1100     emit ApprovalForAll(_msgSender(), operator, approved);
1101   }
1102 
1103   /**
1104    * @dev See {IERC721-isApprovedForAll}.
1105    */
1106   function isApprovedForAll(address owner, address operator)
1107     public
1108     view
1109     virtual
1110     override
1111     returns (bool)
1112   {
1113     return _operatorApprovals[owner][operator];
1114   }
1115 
1116   /**
1117    * @dev See {IERC721-transferFrom}.
1118    */
1119   function transferFrom(
1120     address from,
1121     address to,
1122     uint256 tokenId
1123   ) public override {
1124     _transfer(from, to, tokenId);
1125   }
1126 
1127   /**
1128    * @dev See {IERC721-safeTransferFrom}.
1129    */
1130   function safeTransferFrom(
1131     address from,
1132     address to,
1133     uint256 tokenId
1134   ) public override {
1135     safeTransferFrom(from, to, tokenId, "");
1136   }
1137 
1138   /**
1139    * @dev See {IERC721-safeTransferFrom}.
1140    */
1141   function safeTransferFrom(
1142     address from,
1143     address to,
1144     uint256 tokenId,
1145     bytes memory _data
1146   ) public override {
1147     _transfer(from, to, tokenId);
1148     require(
1149       _checkOnERC721Received(from, to, tokenId, _data),
1150       "ERC721A: transfer to non ERC721Receiver implementer"
1151     );
1152   }
1153 
1154   /**
1155    * @dev Returns whether `tokenId` exists.
1156    *
1157    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1158    *
1159    * Tokens start existing when they are minted (`_mint`),
1160    */
1161   function _exists(uint256 tokenId) internal view returns (bool) {
1162     return tokenId < currentIndex;
1163   }
1164 
1165   function _safeMint(address to, uint256 quantity) internal {
1166     _safeMint(to, quantity, "");
1167   }
1168 
1169   /**
1170    * @dev Mints `quantity` tokens and transfers them to `to`.
1171    *
1172    * Requirements:
1173    *
1174    * - there must be `quantity` tokens remaining unminted in the total collection.
1175    * - `to` cannot be the zero address.
1176    * - `quantity` cannot be larger than the max batch size.
1177    *
1178    * Emits a {Transfer} event.
1179    */
1180   function _safeMint(
1181     address to,
1182     uint256 quantity,
1183     bytes memory _data
1184   ) internal {
1185     uint256 startTokenId = currentIndex;
1186     require(to != address(0), "ERC721A: mint to the zero address");
1187     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1188     require(!_exists(startTokenId), "ERC721A: token already minted");
1189     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1190 
1191     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1192 
1193     AddressData memory addressData = _addressData[to];
1194     _addressData[to] = AddressData(
1195       addressData.balance + uint128(quantity),
1196       addressData.numberMinted + uint128(quantity)
1197     );
1198     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1199 
1200     uint256 updatedIndex = startTokenId;
1201 
1202     for (uint256 i = 0; i < quantity; i++) {
1203       emit Transfer(address(0), to, updatedIndex);
1204       require(
1205         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1206         "ERC721A: transfer to non ERC721Receiver implementer"
1207       );
1208       updatedIndex++;
1209     }
1210 
1211     currentIndex = updatedIndex;
1212     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1213   }
1214 
1215   /**
1216    * @dev Transfers `tokenId` from `from` to `to`.
1217    *
1218    * Requirements:
1219    *
1220    * - `to` cannot be the zero address.
1221    * - `tokenId` token must be owned by `from`.
1222    *
1223    * Emits a {Transfer} event.
1224    */
1225   function _transfer(
1226     address from,
1227     address to,
1228     uint256 tokenId
1229   ) private {
1230     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1231 
1232     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1233       getApproved(tokenId) == _msgSender() ||
1234       isApprovedForAll(prevOwnership.addr, _msgSender()));
1235 
1236     require(
1237       isApprovedOrOwner,
1238       "ERC721A: transfer caller is not owner nor approved"
1239     );
1240 
1241     require(
1242       prevOwnership.addr == from,
1243       "ERC721A: transfer from incorrect owner"
1244     );
1245     require(to != address(0), "ERC721A: transfer to the zero address");
1246 
1247     _beforeTokenTransfers(from, to, tokenId, 1);
1248 
1249     // Clear approvals from the previous owner
1250     _approve(address(0), tokenId, prevOwnership.addr);
1251 
1252     _addressData[from].balance -= 1;
1253     _addressData[to].balance += 1;
1254     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1255 
1256     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1257     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1258     uint256 nextTokenId = tokenId + 1;
1259     if (_ownerships[nextTokenId].addr == address(0)) {
1260       if (_exists(nextTokenId)) {
1261         _ownerships[nextTokenId] = TokenOwnership(
1262           prevOwnership.addr,
1263           prevOwnership.startTimestamp
1264         );
1265       }
1266     }
1267 
1268     emit Transfer(from, to, tokenId);
1269     _afterTokenTransfers(from, to, tokenId, 1);
1270   }
1271 
1272   /**
1273    * @dev Approve `to` to operate on `tokenId`
1274    *
1275    * Emits a {Approval} event.
1276    */
1277   function _approve(
1278     address to,
1279     uint256 tokenId,
1280     address owner
1281   ) private {
1282     _tokenApprovals[tokenId] = to;
1283     emit Approval(owner, to, tokenId);
1284   }
1285 
1286   uint256 public nextOwnerToExplicitlySet = 0;
1287 
1288   /**
1289    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1290    */
1291   function _setOwnersExplicit(uint256 quantity) internal {
1292     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1293     require(quantity > 0, "quantity must be nonzero");
1294     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1295     if (endIndex > collectionSize - 1) {
1296       endIndex = collectionSize - 1;
1297     }
1298     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1299     require(_exists(endIndex), "not enough minted yet for this cleanup");
1300     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1301       if (_ownerships[i].addr == address(0)) {
1302         TokenOwnership memory ownership = ownershipOf(i);
1303         _ownerships[i] = TokenOwnership(
1304           ownership.addr,
1305           ownership.startTimestamp
1306         );
1307       }
1308     }
1309     nextOwnerToExplicitlySet = endIndex + 1;
1310   }
1311 
1312   /**
1313    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1314    * The call is not executed if the target address is not a contract.
1315    *
1316    * @param from address representing the previous owner of the given token ID
1317    * @param to target address that will receive the tokens
1318    * @param tokenId uint256 ID of the token to be transferred
1319    * @param _data bytes optional data to send along with the call
1320    * @return bool whether the call correctly returned the expected magic value
1321    */
1322   function _checkOnERC721Received(
1323     address from,
1324     address to,
1325     uint256 tokenId,
1326     bytes memory _data
1327   ) private returns (bool) {
1328     if (to.isContract()) {
1329       try
1330         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1331       returns (bytes4 retval) {
1332         return retval == IERC721Receiver(to).onERC721Received.selector;
1333       } catch (bytes memory reason) {
1334         if (reason.length == 0) {
1335           revert("ERC721A: transfer to non ERC721Receiver implementer");
1336         } else {
1337           assembly {
1338             revert(add(32, reason), mload(reason))
1339           }
1340         }
1341       }
1342     } else {
1343       return true;
1344     }
1345   }
1346 
1347   /**
1348    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1349    *
1350    * startTokenId - the first token id to be transferred
1351    * quantity - the amount to be transferred
1352    *
1353    * Calling conditions:
1354    *
1355    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1356    * transferred to `to`.
1357    * - When `from` is zero, `tokenId` will be minted for `to`.
1358    */
1359   function _beforeTokenTransfers(
1360     address from,
1361     address to,
1362     uint256 startTokenId,
1363     uint256 quantity
1364   ) internal virtual {}
1365 
1366   /**
1367    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1368    * minting.
1369    *
1370    * startTokenId - the first token id to be transferred
1371    * quantity - the amount to be transferred
1372    *
1373    * Calling conditions:
1374    *
1375    * - when `from` and `to` are both non-zero.
1376    * - `from` and `to` are never both zero.
1377    */
1378   function _afterTokenTransfers(
1379     address from,
1380     address to,
1381     uint256 startTokenId,
1382     uint256 quantity
1383   ) internal virtual {}
1384 }
1385 
1386 library OpenSeaGasFreeListing {
1387     /**
1388     @notice Returns whether the operator is an OpenSea proxy for the owner, thus
1389     allowing it to list without the token owner paying gas.
1390     @dev ERC{721,1155}.isApprovedForAll should be overriden to also check if
1391     this function returns true.
1392      */
1393     function isApprovedForAll(address owner, address operator) internal view returns (bool) {
1394         ProxyRegistry registry;
1395         assembly {
1396             switch chainid()
1397             case 1 {
1398                 // mainnet
1399                 registry := 0xa5409ec958c83c3f309868babaca7c86dcb077c1
1400             }
1401             case 4 {
1402                 // rinkeby
1403                 registry := 0xf57b2c51ded3a29e6891aba85459d600256cf317
1404             }
1405         }
1406 
1407         return address(registry) != address(0) && (address(registry.proxies(owner)) == operator);
1408     }
1409 }
1410 
1411 contract OwnableDelegateProxy {}
1412 
1413 contract ProxyRegistry {
1414     mapping(address => OwnableDelegateProxy) public proxies;
1415 }
1416 
1417 
1418 contract punksremix is Ownable, ERC721A, ReentrancyGuard {
1419 
1420     using Address for address;
1421     using Strings for uint256;
1422 
1423     //punks team need punks
1424     uint256 public max_punks_team = 150;
1425     //only 10k punks
1426     uint256 public immutable max_punks;
1427     //limits the number of punks per punk address
1428     uint256 public max_punks_per_owner = 20;
1429     //token price
1430     uint256 public TOKEN_PRICE = 0.00 ether;
1431     //max mints per tx
1432     uint256 public MAX_MINTS_PER_TX = 10;
1433 
1434     bool public punksale = false;
1435 
1436     string public punkyprovenance;
1437 
1438     //tracks number of punks per owner
1439     mapping (address => uint) public PunksMinted;
1440 
1441     constructor(
1442     uint256 maxBatchSize_,
1443     uint256 collectionSize_,
1444     uint256 maxTOKENS_
1445   ) ERC721A("punk remix wtf","PUNX", maxBatchSize_,collectionSize_) {
1446     MAX_MINTS_PER_TX = maxBatchSize_;
1447     max_punks = maxTOKENS_;
1448     require(
1449         maxTOKENS_ <= collectionSize_,
1450         "larger collection size needed"
1451     );   
1452   }
1453 
1454   modifier callerIsUser() {
1455     require(tx.origin == msg.sender, "The caller is another contract");
1456     _;
1457   }
1458 
1459 //mint punks
1460     function mint_punks(uint256 quantity) external payable callerIsUser nonReentrant {
1461         require(punksale, "public sale is not live");
1462         require(totalSupply() + quantity <= max_punks, "invalid quantity: would exceed max supply");
1463         _checkMintRequirements(quantity);
1464         _safeMint(msg.sender, quantity);
1465     }
1466 
1467     function _checkMintRequirements(uint256 quantity) internal {
1468         require(quantity > 0 && quantity <= max_punks_per_owner, "invalid quantity: too many punks");
1469         require(quantity > 0 && quantity <= MAX_MINTS_PER_TX, "invalid quantity: too many punks");
1470         require(msg.value == TOKEN_PRICE * quantity, "wrong amount of ether sent");
1471         PunksMinted[msg.sender] = PunksMinted[msg.sender] + quantity;
1472         require(PunksMinted[msg.sender] <= max_punks_per_owner, "you trying to mint too many punks");
1473 
1474     }
1475 //admin minting function for team tokens
1476     function teamMint(uint256 quantity) public onlyOwner {
1477         require(quantity <= max_punks_team, "Can't reserve more than set amount" );
1478         max_punks_team -= quantity;
1479         require(totalSupply() + quantity <= max_punks, "invalid quantity: would exceed max supply");
1480         _safeMint(msg.sender, quantity);
1481     }
1482 
1483     function togglepunksale() public onlyOwner {
1484         punksale = !punksale;
1485     }
1486 
1487     function numberMinted(address owner) public view returns (uint256) {
1488     return _numberMinted(owner);
1489   }
1490 
1491     function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1492     _setOwnersExplicit(quantity);
1493   }
1494 
1495     // // metadata URI
1496     string private _baseTokenURI;
1497 
1498     function _baseURI() internal view virtual override returns (string memory) {
1499     return _baseTokenURI;
1500   }
1501 
1502     function setBaseURI(string calldata baseURI) external onlyOwner {
1503     _baseTokenURI = baseURI;
1504   } 
1505 
1506     function set_max_punks_per_owner(uint256 _max_punks_per_owner) public onlyOwner() {
1507     max_punks_per_owner = _max_punks_per_owner;
1508     }
1509 
1510     function setMAX_MINTS_PER_TX(uint256 _MAX_MINTS_PER_TX) public onlyOwner() {
1511     MAX_MINTS_PER_TX = _MAX_MINTS_PER_TX;
1512     }
1513 
1514     function setTOKEN_PRICE(uint256 _TOKEN_PRICE) public onlyOwner() {
1515     TOKEN_PRICE = _TOKEN_PRICE;
1516     }
1517 
1518     function set_punky_provenance(string memory provenanceHash) external onlyOwner {
1519         punkyprovenance = provenanceHash;
1520     }
1521 
1522     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1523         return OpenSeaGasFreeListing.isApprovedForAll(owner, operator) || super.isApprovedForAll(owner, operator);
1524     }
1525 
1526     function getOwnershipData(uint256 tokenId)
1527     external
1528     view
1529     returns (TokenOwnership memory)
1530   {
1531     return ownershipOf(tokenId);
1532   }
1533 
1534   function withdrawMoney() external onlyOwner nonReentrant {
1535     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1536     require(success, "Transfer failed.");
1537   }
1538 
1539 }