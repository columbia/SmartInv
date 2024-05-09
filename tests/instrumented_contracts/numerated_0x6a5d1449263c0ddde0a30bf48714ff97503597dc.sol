1 // File: contracts/AnonymiceLibrary.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 library AnonymiceLibrary {
7     string internal constant TABLE =
8         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
9 
10     function encode(bytes memory data) internal pure returns (string memory) {
11         if (data.length == 0) return "";
12 
13         // load the table into memory
14         string memory table = TABLE;
15 
16         // multiply by 4/3 rounded up
17         uint256 encodedLen = 4 * ((data.length + 2) / 3);
18 
19         // add some extra buffer at the end required for the writing
20         string memory result = new string(encodedLen + 32);
21 
22         assembly {
23             // set the actual output length
24             mstore(result, encodedLen)
25 
26             // prepare the lookup table
27             let tablePtr := add(table, 1)
28 
29             // input ptr
30             let dataPtr := data
31             let endPtr := add(dataPtr, mload(data))
32 
33             // result ptr, jump over length
34             let resultPtr := add(result, 32)
35 
36             // run over the input, 3 bytes at a time
37             for {
38 
39             } lt(dataPtr, endPtr) {
40 
41             } {
42                 dataPtr := add(dataPtr, 3)
43 
44                 // read 3 bytes
45                 let input := mload(dataPtr)
46 
47                 // write 4 characters
48                 mstore(
49                     resultPtr,
50                     shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F))))
51                 )
52                 resultPtr := add(resultPtr, 1)
53                 mstore(
54                     resultPtr,
55                     shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F))))
56                 )
57                 resultPtr := add(resultPtr, 1)
58                 mstore(
59                     resultPtr,
60                     shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F))))
61                 )
62                 resultPtr := add(resultPtr, 1)
63                 mstore(
64                     resultPtr,
65                     shl(248, mload(add(tablePtr, and(input, 0x3F))))
66                 )
67                 resultPtr := add(resultPtr, 1)
68             }
69 
70             // padding with '='
71             switch mod(mload(data), 3)
72             case 1 {
73                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
74             }
75             case 2 {
76                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
77             }
78         }
79 
80         return result;
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
85      */
86     function toString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     function parseInt(string memory _a)
106         internal
107         pure
108         returns (uint8 _parsedInt)
109     {
110         bytes memory bresult = bytes(_a);
111         uint8 mint = 0;
112         for (uint8 i = 0; i < bresult.length; i++) {
113             if (
114                 (uint8(uint8(bresult[i])) >= 48) &&
115                 (uint8(uint8(bresult[i])) <= 57)
116             ) {
117                 mint *= 10;
118                 mint += uint8(bresult[i]) - 48;
119             }
120         }
121         return mint;
122     }
123 
124     function substring(
125         string memory str,
126         uint256 startIndex,
127         uint256 endIndex
128     ) internal pure returns (string memory) {
129         bytes memory strBytes = bytes(str);
130         bytes memory result = new bytes(endIndex - startIndex);
131         for (uint256 i = startIndex; i < endIndex; i++) {
132             result[i - startIndex] = strBytes[i];
133         }
134         return string(result);
135     }
136 
137     function isContract(address account) internal view returns (bool) {
138         // This method relies on extcodesize, which returns 0 for contracts in
139         // construction, since the code is only stored at the end of the
140         // constructor execution.
141 
142         uint256 size;
143         assembly {
144             size := extcodesize(account)
145         }
146         return size > 0;
147     }
148 }
149 // File: contracts/interfaces/IBlueprintsData.sol
150 
151 
152 
153 /// @title Interface for BlueprintsData
154 
155 pragma solidity ^0.8.0;
156 
157 interface IBlueprintsData {
158     function partialBlueprintsCode() external view returns (string memory);
159 }
160 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
161 
162 
163 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
164 
165 pragma solidity ^0.8.0;
166 
167 /**
168  * @dev These functions deal with verification of Merkle Trees proofs.
169  *
170  * The proofs can be generated using the JavaScript library
171  * https://github.com/miguelmota/merkletreejs[merkletreejs].
172  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
173  *
174  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
175  */
176 library MerkleProof {
177     /**
178      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
179      * defined by `root`. For this, a `proof` must be provided, containing
180      * sibling hashes on the branch from the leaf to the root of the tree. Each
181      * pair of leaves and each pair of pre-images are assumed to be sorted.
182      */
183     function verify(
184         bytes32[] memory proof,
185         bytes32 root,
186         bytes32 leaf
187     ) internal pure returns (bool) {
188         return processProof(proof, leaf) == root;
189     }
190 
191     /**
192      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
193      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
194      * hash matches the root of the tree. When processing the proof, the pairs
195      * of leafs & pre-images are assumed to be sorted.
196      *
197      * _Available since v4.4._
198      */
199     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
200         bytes32 computedHash = leaf;
201         for (uint256 i = 0; i < proof.length; i++) {
202             bytes32 proofElement = proof[i];
203             if (computedHash <= proofElement) {
204                 // Hash(current computed hash + current element of the proof)
205                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
206             } else {
207                 // Hash(current element of the proof + current computed hash)
208                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
209             }
210         }
211         return computedHash;
212     }
213 }
214 
215 // File: @openzeppelin/contracts/utils/Strings.sol
216 
217 
218 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 /**
223  * @dev String operations.
224  */
225 library Strings {
226     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
227 
228     /**
229      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
230      */
231     function toString(uint256 value) internal pure returns (string memory) {
232         // Inspired by OraclizeAPI's implementation - MIT licence
233         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
234 
235         if (value == 0) {
236             return "0";
237         }
238         uint256 temp = value;
239         uint256 digits;
240         while (temp != 0) {
241             digits++;
242             temp /= 10;
243         }
244         bytes memory buffer = new bytes(digits);
245         while (value != 0) {
246             digits -= 1;
247             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
248             value /= 10;
249         }
250         return string(buffer);
251     }
252 
253     /**
254      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
255      */
256     function toHexString(uint256 value) internal pure returns (string memory) {
257         if (value == 0) {
258             return "0x00";
259         }
260         uint256 temp = value;
261         uint256 length = 0;
262         while (temp != 0) {
263             length++;
264             temp >>= 8;
265         }
266         return toHexString(value, length);
267     }
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
271      */
272     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
273         bytes memory buffer = new bytes(2 * length + 2);
274         buffer[0] = "0";
275         buffer[1] = "x";
276         for (uint256 i = 2 * length + 1; i > 1; --i) {
277             buffer[i] = _HEX_SYMBOLS[value & 0xf];
278             value >>= 4;
279         }
280         require(value == 0, "Strings: hex length insufficient");
281         return string(buffer);
282     }
283 }
284 
285 // File: @openzeppelin/contracts/utils/Context.sol
286 
287 
288 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
289 
290 pragma solidity ^0.8.0;
291 
292 /**
293  * @dev Provides information about the current execution context, including the
294  * sender of the transaction and its data. While these are generally available
295  * via msg.sender and msg.data, they should not be accessed in such a direct
296  * manner, since when dealing with meta-transactions the account sending and
297  * paying for execution may not be the actual sender (as far as an application
298  * is concerned).
299  *
300  * This contract is only required for intermediate, library-like contracts.
301  */
302 abstract contract Context {
303     function _msgSender() internal view virtual returns (address) {
304         return msg.sender;
305     }
306 
307     function _msgData() internal view virtual returns (bytes calldata) {
308         return msg.data;
309     }
310 }
311 
312 // File: @openzeppelin/contracts/access/Ownable.sol
313 
314 
315 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 
320 /**
321  * @dev Contract module which provides a basic access control mechanism, where
322  * there is an account (an owner) that can be granted exclusive access to
323  * specific functions.
324  *
325  * By default, the owner account will be the one that deploys the contract. This
326  * can later be changed with {transferOwnership}.
327  *
328  * This module is used through inheritance. It will make available the modifier
329  * `onlyOwner`, which can be applied to your functions to restrict their use to
330  * the owner.
331  */
332 abstract contract Ownable is Context {
333     address private _owner;
334 
335     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
336 
337     /**
338      * @dev Initializes the contract setting the deployer as the initial owner.
339      */
340     constructor() {
341         _transferOwnership(_msgSender());
342     }
343 
344     /**
345      * @dev Returns the address of the current owner.
346      */
347     function owner() public view virtual returns (address) {
348         return _owner;
349     }
350 
351     /**
352      * @dev Throws if called by any account other than the owner.
353      */
354     modifier onlyOwner() {
355         require(owner() == _msgSender(), "Ownable: caller is not the owner");
356         _;
357     }
358 
359     /**
360      * @dev Leaves the contract without owner. It will not be possible to call
361      * `onlyOwner` functions anymore. Can only be called by the current owner.
362      *
363      * NOTE: Renouncing ownership will leave the contract without an owner,
364      * thereby removing any functionality that is only available to the owner.
365      */
366     function renounceOwnership() public virtual onlyOwner {
367         _transferOwnership(address(0));
368     }
369 
370     /**
371      * @dev Transfers ownership of the contract to a new account (`newOwner`).
372      * Can only be called by the current owner.
373      */
374     function transferOwnership(address newOwner) public virtual onlyOwner {
375         require(newOwner != address(0), "Ownable: new owner is the zero address");
376         _transferOwnership(newOwner);
377     }
378 
379     /**
380      * @dev Transfers ownership of the contract to a new account (`newOwner`).
381      * Internal function without access restriction.
382      */
383     function _transferOwnership(address newOwner) internal virtual {
384         address oldOwner = _owner;
385         _owner = newOwner;
386         emit OwnershipTransferred(oldOwner, newOwner);
387     }
388 }
389 
390 // File: @openzeppelin/contracts/utils/Address.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @dev Collection of functions related to the address type
399  */
400 library Address {
401     /**
402      * @dev Returns true if `account` is a contract.
403      *
404      * [IMPORTANT]
405      * ====
406      * It is unsafe to assume that an address for which this function returns
407      * false is an externally-owned account (EOA) and not a contract.
408      *
409      * Among others, `isContract` will return false for the following
410      * types of addresses:
411      *
412      *  - an externally-owned account
413      *  - a contract in construction
414      *  - an address where a contract will be created
415      *  - an address where a contract lived, but was destroyed
416      * ====
417      */
418     function isContract(address account) internal view returns (bool) {
419         // This method relies on extcodesize, which returns 0 for contracts in
420         // construction, since the code is only stored at the end of the
421         // constructor execution.
422 
423         uint256 size;
424         assembly {
425             size := extcodesize(account)
426         }
427         return size > 0;
428     }
429 
430     /**
431      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
432      * `recipient`, forwarding all available gas and reverting on errors.
433      *
434      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
435      * of certain opcodes, possibly making contracts go over the 2300 gas limit
436      * imposed by `transfer`, making them unable to receive funds via
437      * `transfer`. {sendValue} removes this limitation.
438      *
439      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
440      *
441      * IMPORTANT: because control is transferred to `recipient`, care must be
442      * taken to not create reentrancy vulnerabilities. Consider using
443      * {ReentrancyGuard} or the
444      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
445      */
446     function sendValue(address payable recipient, uint256 amount) internal {
447         require(address(this).balance >= amount, "Address: insufficient balance");
448 
449         (bool success, ) = recipient.call{value: amount}("");
450         require(success, "Address: unable to send value, recipient may have reverted");
451     }
452 
453     /**
454      * @dev Performs a Solidity function call using a low level `call`. A
455      * plain `call` is an unsafe replacement for a function call: use this
456      * function instead.
457      *
458      * If `target` reverts with a revert reason, it is bubbled up by this
459      * function (like regular Solidity function calls).
460      *
461      * Returns the raw returned data. To convert to the expected return value,
462      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
463      *
464      * Requirements:
465      *
466      * - `target` must be a contract.
467      * - calling `target` with `data` must not revert.
468      *
469      * _Available since v3.1._
470      */
471     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
472         return functionCall(target, data, "Address: low-level call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
477      * `errorMessage` as a fallback revert reason when `target` reverts.
478      *
479      * _Available since v3.1._
480      */
481     function functionCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal returns (bytes memory) {
486         return functionCallWithValue(target, data, 0, errorMessage);
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
491      * but also transferring `value` wei to `target`.
492      *
493      * Requirements:
494      *
495      * - the calling contract must have an ETH balance of at least `value`.
496      * - the called Solidity function must be `payable`.
497      *
498      * _Available since v3.1._
499      */
500     function functionCallWithValue(
501         address target,
502         bytes memory data,
503         uint256 value
504     ) internal returns (bytes memory) {
505         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
510      * with `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(
515         address target,
516         bytes memory data,
517         uint256 value,
518         string memory errorMessage
519     ) internal returns (bytes memory) {
520         require(address(this).balance >= value, "Address: insufficient balance for call");
521         require(isContract(target), "Address: call to non-contract");
522 
523         (bool success, bytes memory returndata) = target.call{value: value}(data);
524         return verifyCallResult(success, returndata, errorMessage);
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
529      * but performing a static call.
530      *
531      * _Available since v3.3._
532      */
533     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
534         return functionStaticCall(target, data, "Address: low-level static call failed");
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
539      * but performing a static call.
540      *
541      * _Available since v3.3._
542      */
543     function functionStaticCall(
544         address target,
545         bytes memory data,
546         string memory errorMessage
547     ) internal view returns (bytes memory) {
548         require(isContract(target), "Address: static call to non-contract");
549 
550         (bool success, bytes memory returndata) = target.staticcall(data);
551         return verifyCallResult(success, returndata, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but performing a delegate call.
557      *
558      * _Available since v3.4._
559      */
560     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
561         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a delegate call.
567      *
568      * _Available since v3.4._
569      */
570     function functionDelegateCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal returns (bytes memory) {
575         require(isContract(target), "Address: delegate call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.delegatecall(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
583      * revert reason using the provided one.
584      *
585      * _Available since v4.3._
586      */
587     function verifyCallResult(
588         bool success,
589         bytes memory returndata,
590         string memory errorMessage
591     ) internal pure returns (bytes memory) {
592         if (success) {
593             return returndata;
594         } else {
595             // Look for revert reason and bubble it up if present
596             if (returndata.length > 0) {
597                 // The easiest way to bubble the revert reason is using memory via assembly
598 
599                 assembly {
600                     let returndata_size := mload(returndata)
601                     revert(add(32, returndata), returndata_size)
602                 }
603             } else {
604                 revert(errorMessage);
605             }
606         }
607     }
608 }
609 
610 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
611 
612 
613 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @title ERC721 token receiver interface
619  * @dev Interface for any contract that wants to support safeTransfers
620  * from ERC721 asset contracts.
621  */
622 interface IERC721Receiver {
623     /**
624      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
625      * by `operator` from `from`, this function is called.
626      *
627      * It must return its Solidity selector to confirm the token transfer.
628      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
629      *
630      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
631      */
632     function onERC721Received(
633         address operator,
634         address from,
635         uint256 tokenId,
636         bytes calldata data
637     ) external returns (bytes4);
638 }
639 
640 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
641 
642 
643 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 /**
648  * @dev Interface of the ERC165 standard, as defined in the
649  * https://eips.ethereum.org/EIPS/eip-165[EIP].
650  *
651  * Implementers can declare support of contract interfaces, which can then be
652  * queried by others ({ERC165Checker}).
653  *
654  * For an implementation, see {ERC165}.
655  */
656 interface IERC165 {
657     /**
658      * @dev Returns true if this contract implements the interface defined by
659      * `interfaceId`. See the corresponding
660      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
661      * to learn more about how these ids are created.
662      *
663      * This function call must use less than 30 000 gas.
664      */
665     function supportsInterface(bytes4 interfaceId) external view returns (bool);
666 }
667 
668 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 
676 /**
677  * @dev Implementation of the {IERC165} interface.
678  *
679  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
680  * for the additional interface id that will be supported. For example:
681  *
682  * ```solidity
683  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
684  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
685  * }
686  * ```
687  *
688  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
689  */
690 abstract contract ERC165 is IERC165 {
691     /**
692      * @dev See {IERC165-supportsInterface}.
693      */
694     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
695         return interfaceId == type(IERC165).interfaceId;
696     }
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @dev Required interface of an ERC721 compliant contract.
709  */
710 interface IERC721 is IERC165 {
711     /**
712      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
713      */
714     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
715 
716     /**
717      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
718      */
719     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
720 
721     /**
722      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
723      */
724     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
725 
726     /**
727      * @dev Returns the number of tokens in ``owner``'s account.
728      */
729     function balanceOf(address owner) external view returns (uint256 balance);
730 
731     /**
732      * @dev Returns the owner of the `tokenId` token.
733      *
734      * Requirements:
735      *
736      * - `tokenId` must exist.
737      */
738     function ownerOf(uint256 tokenId) external view returns (address owner);
739 
740     /**
741      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
742      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
743      *
744      * Requirements:
745      *
746      * - `from` cannot be the zero address.
747      * - `to` cannot be the zero address.
748      * - `tokenId` token must exist and be owned by `from`.
749      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
750      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
751      *
752      * Emits a {Transfer} event.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) external;
759 
760     /**
761      * @dev Transfers `tokenId` token from `from` to `to`.
762      *
763      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
764      *
765      * Requirements:
766      *
767      * - `from` cannot be the zero address.
768      * - `to` cannot be the zero address.
769      * - `tokenId` token must be owned by `from`.
770      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
771      *
772      * Emits a {Transfer} event.
773      */
774     function transferFrom(
775         address from,
776         address to,
777         uint256 tokenId
778     ) external;
779 
780     /**
781      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
782      * The approval is cleared when the token is transferred.
783      *
784      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
785      *
786      * Requirements:
787      *
788      * - The caller must own the token or be an approved operator.
789      * - `tokenId` must exist.
790      *
791      * Emits an {Approval} event.
792      */
793     function approve(address to, uint256 tokenId) external;
794 
795     /**
796      * @dev Returns the account approved for `tokenId` token.
797      *
798      * Requirements:
799      *
800      * - `tokenId` must exist.
801      */
802     function getApproved(uint256 tokenId) external view returns (address operator);
803 
804     /**
805      * @dev Approve or remove `operator` as an operator for the caller.
806      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
807      *
808      * Requirements:
809      *
810      * - The `operator` cannot be the caller.
811      *
812      * Emits an {ApprovalForAll} event.
813      */
814     function setApprovalForAll(address operator, bool _approved) external;
815 
816     /**
817      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
818      *
819      * See {setApprovalForAll}
820      */
821     function isApprovedForAll(address owner, address operator) external view returns (bool);
822 
823     /**
824      * @dev Safely transfers `tokenId` token from `from` to `to`.
825      *
826      * Requirements:
827      *
828      * - `from` cannot be the zero address.
829      * - `to` cannot be the zero address.
830      * - `tokenId` token must exist and be owned by `from`.
831      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
832      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
833      *
834      * Emits a {Transfer} event.
835      */
836     function safeTransferFrom(
837         address from,
838         address to,
839         uint256 tokenId,
840         bytes calldata data
841     ) external;
842 }
843 
844 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
845 
846 
847 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
848 
849 pragma solidity ^0.8.0;
850 
851 
852 /**
853  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
854  * @dev See https://eips.ethereum.org/EIPS/eip-721
855  */
856 interface IERC721Enumerable is IERC721 {
857     /**
858      * @dev Returns the total amount of tokens stored by the contract.
859      */
860     function totalSupply() external view returns (uint256);
861 
862     /**
863      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
864      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
865      */
866     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
867 
868     /**
869      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
870      * Use along with {totalSupply} to enumerate all tokens.
871      */
872     function tokenByIndex(uint256 index) external view returns (uint256);
873 }
874 
875 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
876 
877 
878 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
879 
880 pragma solidity ^0.8.0;
881 
882 
883 /**
884  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
885  * @dev See https://eips.ethereum.org/EIPS/eip-721
886  */
887 interface IERC721Metadata is IERC721 {
888     /**
889      * @dev Returns the token collection name.
890      */
891     function name() external view returns (string memory);
892 
893     /**
894      * @dev Returns the token collection symbol.
895      */
896     function symbol() external view returns (string memory);
897 
898     /**
899      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
900      */
901     function tokenURI(uint256 tokenId) external view returns (string memory);
902 }
903 
904 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
905 
906 
907 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
908 
909 pragma solidity ^0.8.0;
910 
911 
912 
913 
914 
915 
916 
917 
918 /**
919  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
920  * the Metadata extension, but not including the Enumerable extension, which is available separately as
921  * {ERC721Enumerable}.
922  */
923 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
924     using Address for address;
925     using Strings for uint256;
926 
927     // Token name
928     string private _name;
929 
930     // Token symbol
931     string private _symbol;
932 
933     // Mapping from token ID to owner address
934     mapping(uint256 => address) private _owners;
935 
936     // Mapping owner address to token count
937     mapping(address => uint256) private _balances;
938 
939     // Mapping from token ID to approved address
940     mapping(uint256 => address) private _tokenApprovals;
941 
942     // Mapping from owner to operator approvals
943     mapping(address => mapping(address => bool)) private _operatorApprovals;
944 
945     /**
946      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
947      */
948     constructor(string memory name_, string memory symbol_) {
949         _name = name_;
950         _symbol = symbol_;
951     }
952 
953     /**
954      * @dev See {IERC165-supportsInterface}.
955      */
956     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
957         return
958             interfaceId == type(IERC721).interfaceId ||
959             interfaceId == type(IERC721Metadata).interfaceId ||
960             super.supportsInterface(interfaceId);
961     }
962 
963     /**
964      * @dev See {IERC721-balanceOf}.
965      */
966     function balanceOf(address owner) public view virtual override returns (uint256) {
967         require(owner != address(0), "ERC721: balance query for the zero address");
968         return _balances[owner];
969     }
970 
971     /**
972      * @dev See {IERC721-ownerOf}.
973      */
974     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
975         address owner = _owners[tokenId];
976         require(owner != address(0), "ERC721: owner query for nonexistent token");
977         return owner;
978     }
979 
980     /**
981      * @dev See {IERC721Metadata-name}.
982      */
983     function name() public view virtual override returns (string memory) {
984         return _name;
985     }
986 
987     /**
988      * @dev See {IERC721Metadata-symbol}.
989      */
990     function symbol() public view virtual override returns (string memory) {
991         return _symbol;
992     }
993 
994     /**
995      * @dev See {IERC721Metadata-tokenURI}.
996      */
997     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
998         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
999 
1000         string memory baseURI = _baseURI();
1001         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1002     }
1003 
1004     /**
1005      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1006      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1007      * by default, can be overriden in child contracts.
1008      */
1009     function _baseURI() internal view virtual returns (string memory) {
1010         return "";
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-approve}.
1015      */
1016     function approve(address to, uint256 tokenId) public virtual override {
1017         address owner = ERC721.ownerOf(tokenId);
1018         require(to != owner, "ERC721: approval to current owner");
1019 
1020         require(
1021             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1022             "ERC721: approve caller is not owner nor approved for all"
1023         );
1024 
1025         _approve(to, tokenId);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-getApproved}.
1030      */
1031     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1032         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1033 
1034         return _tokenApprovals[tokenId];
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-setApprovalForAll}.
1039      */
1040     function setApprovalForAll(address operator, bool approved) public virtual override {
1041         _setApprovalForAll(_msgSender(), operator, approved);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-isApprovedForAll}.
1046      */
1047     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1048         return _operatorApprovals[owner][operator];
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-transferFrom}.
1053      */
1054     function transferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) public virtual override {
1059         //solhint-disable-next-line max-line-length
1060         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1061 
1062         _transfer(from, to, tokenId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-safeTransferFrom}.
1067      */
1068     function safeTransferFrom(
1069         address from,
1070         address to,
1071         uint256 tokenId
1072     ) public virtual override {
1073         safeTransferFrom(from, to, tokenId, "");
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-safeTransferFrom}.
1078      */
1079     function safeTransferFrom(
1080         address from,
1081         address to,
1082         uint256 tokenId,
1083         bytes memory _data
1084     ) public virtual override {
1085         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1086         _safeTransfer(from, to, tokenId, _data);
1087     }
1088 
1089     /**
1090      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1091      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1092      *
1093      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1094      *
1095      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1096      * implement alternative mechanisms to perform token transfer, such as signature-based.
1097      *
1098      * Requirements:
1099      *
1100      * - `from` cannot be the zero address.
1101      * - `to` cannot be the zero address.
1102      * - `tokenId` token must exist and be owned by `from`.
1103      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _safeTransfer(
1108         address from,
1109         address to,
1110         uint256 tokenId,
1111         bytes memory _data
1112     ) internal virtual {
1113         _transfer(from, to, tokenId);
1114         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1115     }
1116 
1117     /**
1118      * @dev Returns whether `tokenId` exists.
1119      *
1120      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1121      *
1122      * Tokens start existing when they are minted (`_mint`),
1123      * and stop existing when they are burned (`_burn`).
1124      */
1125     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1126         return _owners[tokenId] != address(0);
1127     }
1128 
1129     /**
1130      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1131      *
1132      * Requirements:
1133      *
1134      * - `tokenId` must exist.
1135      */
1136     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1137         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1138         address owner = ERC721.ownerOf(tokenId);
1139         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1140     }
1141 
1142     /**
1143      * @dev Safely mints `tokenId` and transfers it to `to`.
1144      *
1145      * Requirements:
1146      *
1147      * - `tokenId` must not exist.
1148      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _safeMint(address to, uint256 tokenId) internal virtual {
1153         _safeMint(to, tokenId, "");
1154     }
1155 
1156     /**
1157      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1158      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1159      */
1160     function _safeMint(
1161         address to,
1162         uint256 tokenId,
1163         bytes memory _data
1164     ) internal virtual {
1165         _mint(to, tokenId);
1166         require(
1167             _checkOnERC721Received(address(0), to, tokenId, _data),
1168             "ERC721: transfer to non ERC721Receiver implementer"
1169         );
1170     }
1171 
1172     /**
1173      * @dev Mints `tokenId` and transfers it to `to`.
1174      *
1175      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1176      *
1177      * Requirements:
1178      *
1179      * - `tokenId` must not exist.
1180      * - `to` cannot be the zero address.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function _mint(address to, uint256 tokenId) internal virtual {
1185         require(to != address(0), "ERC721: mint to the zero address");
1186         require(!_exists(tokenId), "ERC721: token already minted");
1187 
1188         _beforeTokenTransfer(address(0), to, tokenId);
1189 
1190         _balances[to] += 1;
1191         _owners[tokenId] = to;
1192 
1193         emit Transfer(address(0), to, tokenId);
1194     }
1195 
1196     /**
1197      * @dev Destroys `tokenId`.
1198      * The approval is cleared when the token is burned.
1199      *
1200      * Requirements:
1201      *
1202      * - `tokenId` must exist.
1203      *
1204      * Emits a {Transfer} event.
1205      */
1206     function _burn(uint256 tokenId) internal virtual {
1207         address owner = ERC721.ownerOf(tokenId);
1208 
1209         _beforeTokenTransfer(owner, address(0), tokenId);
1210 
1211         // Clear approvals
1212         _approve(address(0), tokenId);
1213 
1214         _balances[owner] -= 1;
1215         delete _owners[tokenId];
1216 
1217         emit Transfer(owner, address(0), tokenId);
1218     }
1219 
1220     /**
1221      * @dev Transfers `tokenId` from `from` to `to`.
1222      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1223      *
1224      * Requirements:
1225      *
1226      * - `to` cannot be the zero address.
1227      * - `tokenId` token must be owned by `from`.
1228      *
1229      * Emits a {Transfer} event.
1230      */
1231     function _transfer(
1232         address from,
1233         address to,
1234         uint256 tokenId
1235     ) internal virtual {
1236         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1237         require(to != address(0), "ERC721: transfer to the zero address");
1238 
1239         _beforeTokenTransfer(from, to, tokenId);
1240 
1241         // Clear approvals from the previous owner
1242         _approve(address(0), tokenId);
1243 
1244         _balances[from] -= 1;
1245         _balances[to] += 1;
1246         _owners[tokenId] = to;
1247 
1248         emit Transfer(from, to, tokenId);
1249     }
1250 
1251     /**
1252      * @dev Approve `to` to operate on `tokenId`
1253      *
1254      * Emits a {Approval} event.
1255      */
1256     function _approve(address to, uint256 tokenId) internal virtual {
1257         _tokenApprovals[tokenId] = to;
1258         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1259     }
1260 
1261     /**
1262      * @dev Approve `operator` to operate on all of `owner` tokens
1263      *
1264      * Emits a {ApprovalForAll} event.
1265      */
1266     function _setApprovalForAll(
1267         address owner,
1268         address operator,
1269         bool approved
1270     ) internal virtual {
1271         require(owner != operator, "ERC721: approve to caller");
1272         _operatorApprovals[owner][operator] = approved;
1273         emit ApprovalForAll(owner, operator, approved);
1274     }
1275 
1276     /**
1277      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1278      * The call is not executed if the target address is not a contract.
1279      *
1280      * @param from address representing the previous owner of the given token ID
1281      * @param to target address that will receive the tokens
1282      * @param tokenId uint256 ID of the token to be transferred
1283      * @param _data bytes optional data to send along with the call
1284      * @return bool whether the call correctly returned the expected magic value
1285      */
1286     function _checkOnERC721Received(
1287         address from,
1288         address to,
1289         uint256 tokenId,
1290         bytes memory _data
1291     ) private returns (bool) {
1292         if (to.isContract()) {
1293             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1294                 return retval == IERC721Receiver.onERC721Received.selector;
1295             } catch (bytes memory reason) {
1296                 if (reason.length == 0) {
1297                     revert("ERC721: transfer to non ERC721Receiver implementer");
1298                 } else {
1299                     assembly {
1300                         revert(add(32, reason), mload(reason))
1301                     }
1302                 }
1303             }
1304         } else {
1305             return true;
1306         }
1307     }
1308 
1309     /**
1310      * @dev Hook that is called before any token transfer. This includes minting
1311      * and burning.
1312      *
1313      * Calling conditions:
1314      *
1315      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1316      * transferred to `to`.
1317      * - When `from` is zero, `tokenId` will be minted for `to`.
1318      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1319      * - `from` and `to` are never both zero.
1320      *
1321      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1322      */
1323     function _beforeTokenTransfer(
1324         address from,
1325         address to,
1326         uint256 tokenId
1327     ) internal virtual {}
1328 }
1329 
1330 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1331 
1332 
1333 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1334 
1335 pragma solidity ^0.8.0;
1336 
1337 
1338 
1339 /**
1340  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1341  * enumerability of all the token ids in the contract as well as all token ids owned by each
1342  * account.
1343  */
1344 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1345     // Mapping from owner to list of owned token IDs
1346     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1347 
1348     // Mapping from token ID to index of the owner tokens list
1349     mapping(uint256 => uint256) private _ownedTokensIndex;
1350 
1351     // Array with all token ids, used for enumeration
1352     uint256[] private _allTokens;
1353 
1354     // Mapping from token id to position in the allTokens array
1355     mapping(uint256 => uint256) private _allTokensIndex;
1356 
1357     /**
1358      * @dev See {IERC165-supportsInterface}.
1359      */
1360     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1361         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1362     }
1363 
1364     /**
1365      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1366      */
1367     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1368         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1369         return _ownedTokens[owner][index];
1370     }
1371 
1372     /**
1373      * @dev See {IERC721Enumerable-totalSupply}.
1374      */
1375     function totalSupply() public view virtual override returns (uint256) {
1376         return _allTokens.length;
1377     }
1378 
1379     /**
1380      * @dev See {IERC721Enumerable-tokenByIndex}.
1381      */
1382     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1383         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1384         return _allTokens[index];
1385     }
1386 
1387     /**
1388      * @dev Hook that is called before any token transfer. This includes minting
1389      * and burning.
1390      *
1391      * Calling conditions:
1392      *
1393      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1394      * transferred to `to`.
1395      * - When `from` is zero, `tokenId` will be minted for `to`.
1396      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1397      * - `from` cannot be the zero address.
1398      * - `to` cannot be the zero address.
1399      *
1400      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1401      */
1402     function _beforeTokenTransfer(
1403         address from,
1404         address to,
1405         uint256 tokenId
1406     ) internal virtual override {
1407         super._beforeTokenTransfer(from, to, tokenId);
1408 
1409         if (from == address(0)) {
1410             _addTokenToAllTokensEnumeration(tokenId);
1411         } else if (from != to) {
1412             _removeTokenFromOwnerEnumeration(from, tokenId);
1413         }
1414         if (to == address(0)) {
1415             _removeTokenFromAllTokensEnumeration(tokenId);
1416         } else if (to != from) {
1417             _addTokenToOwnerEnumeration(to, tokenId);
1418         }
1419     }
1420 
1421     /**
1422      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1423      * @param to address representing the new owner of the given token ID
1424      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1425      */
1426     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1427         uint256 length = ERC721.balanceOf(to);
1428         _ownedTokens[to][length] = tokenId;
1429         _ownedTokensIndex[tokenId] = length;
1430     }
1431 
1432     /**
1433      * @dev Private function to add a token to this extension's token tracking data structures.
1434      * @param tokenId uint256 ID of the token to be added to the tokens list
1435      */
1436     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1437         _allTokensIndex[tokenId] = _allTokens.length;
1438         _allTokens.push(tokenId);
1439     }
1440 
1441     /**
1442      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1443      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1444      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1445      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1446      * @param from address representing the previous owner of the given token ID
1447      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1448      */
1449     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1450         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1451         // then delete the last slot (swap and pop).
1452 
1453         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1454         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1455 
1456         // When the token to delete is the last token, the swap operation is unnecessary
1457         if (tokenIndex != lastTokenIndex) {
1458             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1459 
1460             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1461             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1462         }
1463 
1464         // This also deletes the contents at the last position of the array
1465         delete _ownedTokensIndex[tokenId];
1466         delete _ownedTokens[from][lastTokenIndex];
1467     }
1468 
1469     /**
1470      * @dev Private function to remove a token from this extension's token tracking data structures.
1471      * This has O(1) time complexity, but alters the order of the _allTokens array.
1472      * @param tokenId uint256 ID of the token to be removed from the tokens list
1473      */
1474     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1475         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1476         // then delete the last slot (swap and pop).
1477 
1478         uint256 lastTokenIndex = _allTokens.length - 1;
1479         uint256 tokenIndex = _allTokensIndex[tokenId];
1480 
1481         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1482         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1483         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1484         uint256 lastTokenId = _allTokens[lastTokenIndex];
1485 
1486         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1487         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1488 
1489         // This also deletes the contents at the last position of the array
1490         delete _allTokensIndex[tokenId];
1491         _allTokens.pop();
1492     }
1493 }
1494 
1495 // File: contracts/Blueprints.sol
1496 
1497 // contracts/Blueprints.sol
1498 
1499 pragma solidity ^0.8.0;
1500 
1501 
1502 
1503 
1504 
1505 
1506 contract Blueprints is ERC721Enumerable, Ownable {
1507     /*
1508   _   _   _   _   _   _   _   _   _   _
1509  / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ 
1510 ( B | L | U | 3 | P | R | I | N | T | S )
1511  \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ 
1512 
1513 credit to mouse dev and 0xinuarashi for making amazing on chain project with Anonymice
1514 that was used as the basis for Filaments, Axons, and this contract
1515 */
1516     using AnonymiceLibrary for uint8;
1517 
1518     bytes32 public immutable dayOneMerkleRoot;
1519     bytes32 public immutable eightsMerkleRoot;
1520     bytes32 public immutable sevensMerkleRoot;
1521 
1522     // Data contract
1523     address public blueprintsData;
1524 
1525     struct Trait {
1526         string traitName;
1527         string traitType;
1528     }
1529 
1530     //Mappings
1531     mapping(uint256 => Trait[]) public traitTypes;
1532     mapping(string => bool) hashToMinted;
1533     mapping(uint256 => string) internal tokenIdToHash;
1534     mapping(uint256 => bool) internal tokenIdToLandscape;
1535 
1536     //uint256s
1537     uint256 MAX_SUPPLY = 1489;
1538     uint256 SEED_NONCE = 0;
1539     
1540     //minting flag
1541     bool public MINTING_LIVE = false;
1542     uint256 public BLOCKS_IN_A_DAY = 6400;
1543 
1544     uint256 public mintStartBlock = 0;
1545     bool public didShuffleGroups = false;
1546     uint256[] public groups = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
1547 
1548     //uint arrays
1549     uint16[][16] TIERS;
1550     
1551     //allowlist
1552     mapping (address => bool) public addressToMinted;
1553     mapping (address => bool) public communityMints;
1554     uint256 communityCounter = 0;
1555     uint256 ownerCounter = 0;
1556     uint256 publicCounter = 0;
1557 
1558     //p5js url
1559     string p5jsUrl = 'https%3A%2F%2Fcdnjs.cloudflare.com%2Fajax%2Flibs%2Fp5.js%2F1.4.0%2Fp5.js';
1560     string p5jsIntegrity = 'sha256-maU2GxaUCz5WChkAGR40nt9sbWRPEfF8qo%2FprxhoKPQ%3D';
1561     string imageUrl = 'https://axons.art/api/blu3prints/image/';
1562     string externalUrl = 'https://ipfs.io/ipfs/QmNVdU7qTpZzm7Es2ZQ1ShmWDKQmJFAr4dsz5qZRovCozS?x=';
1563     string otherTraits = '';
1564 
1565     constructor(address _blueprintsData, bytes32 _dayOneMerkleRoot, bytes32 _eightsMerkleRoot, bytes32 _sevensMerkleRoot) ERC721("BLU3PRINTS", "BLU3PRINTS") {
1566         blueprintsData = _blueprintsData;
1567         dayOneMerkleRoot = _dayOneMerkleRoot;
1568         eightsMerkleRoot = _eightsMerkleRoot;
1569         sevensMerkleRoot = _sevensMerkleRoot;
1570 
1571         //Declare all the rarity tiers
1572 
1573         // Palette
1574         TIERS[0] = [900,900,900,800,300,300,300,700,100,100,400,100,3600,600];
1575         // Form
1576         TIERS[1] = [50, 300, 1000, 8650]; // blossom, axon, spiral, normal
1577         // Size
1578         TIERS[2] = [100, 3000, 5000, 1000, 900]; // micro, mini, normal, mega, ultra
1579         // Scale
1580         TIERS[3] = [100, 800, 4100, 5000];
1581         // Strength
1582         TIERS[4] = [100, 400, 1300, 2100, 6100];
1583         // Twist
1584         TIERS[5] = [1250, 2000, 3250, 3500];
1585         // Spacing
1586         TIERS[6] = [100, 500, 9400];
1587         // Special Sizing
1588         TIERS[7] = [1000,400,400,400,400,7400]; // uniform, size grads, normal
1589         // Rigid
1590         TIERS[8] = [3000, 7000];
1591         // Color Gradient
1592         TIERS[9] = [1000,9000];
1593         // Lonely
1594         TIERS[10] = [100,9900];
1595         // No collisions
1596         TIERS[11] = [25,9975];
1597         // Spine
1598         TIERS[12] = [300,9700];
1599         // Lines
1600         TIERS[13] = [100,100,100,200,1000,2000,50,6450];
1601         // Side borders
1602         TIERS[14] = [3500,6500];
1603         // Tightly packed
1604         TIERS[15] = [900,9100];
1605     }
1606 
1607     /*
1608   __  __ _     _   _             ___             _   _             
1609  |  \/  (_)_ _| |_(_)_ _  __ _  | __|  _ _ _  __| |_(_)___ _ _  ___
1610  | |\/| | | ' \  _| | ' \/ _` | | _| || | ' \/ _|  _| / _ \ ' \(_-<
1611  |_|  |_|_|_||_\__|_|_||_\__, | |_| \_,_|_||_\__|\__|_\___/_||_/__/
1612                          |___/                                     
1613    */
1614 
1615     /**
1616      * @dev Converts a digit from 0 - 10000 into its corresponding rarity based on the given rarity tier.
1617      * @param _randinput The input from 0 - 10000 to use for rarity gen.
1618      * @param _rarityTier The tier to use.
1619      */
1620     function rarityGen(uint256 _randinput, uint8 _rarityTier)
1621         internal
1622         view
1623         returns (uint8)
1624     {
1625         uint16 currentLowerBound = 0;
1626         for (uint8 i = 0; i < TIERS[_rarityTier].length; i++) {
1627             uint16 thisPercentage = TIERS[_rarityTier][i];
1628             if (
1629                 _randinput >= currentLowerBound &&
1630                 _randinput < currentLowerBound + thisPercentage
1631             ) return i;
1632             currentLowerBound = currentLowerBound + thisPercentage;
1633         }
1634 
1635         revert();
1636     }
1637 
1638     /**
1639      * @dev Generates a 11 digit hash from a tokenId, address, and random number.
1640      * @param _t The token id to be used within the hash.
1641      * @param _a The address to be used within the hash.
1642      * @param _c The custom nonce to be used within the hash.
1643      */
1644     function hash(
1645         uint256 _t,
1646         address _a,
1647         uint256 _c
1648     ) internal returns (string memory) {
1649         require(_c < 11);
1650 
1651         // This will generate a 11 character string.
1652         // The first 2 digits are the palette.
1653         string memory currentHash = "";
1654 
1655         for (uint8 i = 0; i < 16; i++) {
1656             SEED_NONCE++;
1657             uint16 _randinput = uint16(
1658                 uint256(
1659                     keccak256(
1660                         abi.encodePacked(
1661                             block.timestamp,
1662                             block.difficulty,
1663                             _t,
1664                             _a,
1665                             _c,
1666                             SEED_NONCE
1667                         )
1668                     )
1669                 ) % 10000
1670             );
1671             
1672             if (i == 0) {
1673                 uint8 rar = rarityGen(_randinput, i);
1674                 if (rar > 9) {
1675                     currentHash = string(
1676                         abi.encodePacked(currentHash, rar.toString())
1677                     );
1678                 } else {
1679                     currentHash = string(
1680                         abi.encodePacked(currentHash, "0", rar.toString())
1681                     );
1682                 }
1683             } else {
1684                 currentHash = string(
1685                     abi.encodePacked(currentHash, rarityGen(_randinput, i).toString())
1686                 );
1687             }
1688         }
1689 
1690         if (hashToMinted[currentHash]) return hash(_t, _a, _c + 1);
1691 
1692         return currentHash;
1693     }
1694 
1695     function addCommunityMint(address _account) public onlyOwner {
1696         communityMints[_account] = true;
1697     }
1698 
1699     function ownerMintReserve() public onlyOwner {
1700         require(ownerCounter < 15);
1701         ownerCounter++;
1702 
1703         mintBlueprint();
1704     }
1705 
1706     function mintCommunityReserve() public {
1707         require(communityMints[msg.sender] == true);
1708         require(communityCounter < 15);
1709 
1710         communityMints[msg.sender] = false;
1711         communityCounter++;
1712 
1713         mintBlueprint();
1714     }
1715 
1716     /**
1717      * @dev Mint internal
1718      */
1719     function mintBlueprint() internal {
1720         require(MINTING_LIVE == true || msg.sender == owner(), "Minting is not live.");
1721         require(addressToMinted[msg.sender] == false || msg.sender == owner(), "Can only mint 1.");
1722         require(!AnonymiceLibrary.isContract(msg.sender));
1723         
1724         uint256 _totalSupply = totalSupply();
1725         require(_totalSupply < MAX_SUPPLY);
1726 
1727         uint256 thisTokenId = _totalSupply;
1728 
1729         tokenIdToHash[thisTokenId] = hash(thisTokenId, msg.sender, 0);
1730 
1731         hashToMinted[tokenIdToHash[thisTokenId]] = true;
1732 
1733         addressToMinted[msg.sender] = true;
1734 
1735         _mint(msg.sender, thisTokenId);
1736 
1737         updateGroupEight();
1738     }
1739 
1740     function mintWithMerkleScoreNineAndTen(
1741         address account,
1742         bytes32[] calldata merkleProof
1743     ) public {
1744         // Verify the merkle proof.
1745         bytes32 node = keccak256(abi.encodePacked(account));
1746 
1747         require(
1748             MerkleProof.verify(merkleProof, dayOneMerkleRoot, node),
1749             "Invalid proof."
1750         );
1751 
1752         require(msg.sender == account, "Must be you");
1753 
1754         require(publicCounter < 1459);
1755         publicCounter++;
1756 
1757         mintBlueprint();
1758     }
1759 
1760     function updateGroupEight() internal {
1761         if (didShuffleGroups) {
1762             return;
1763         }
1764         if (mintStartBlock == 0) {
1765             return;
1766         }
1767         if (block.number < (BLOCKS_IN_A_DAY + mintStartBlock)) {
1768             return;
1769         }
1770 
1771         didShuffleGroups = true;
1772 
1773         // Shuffle the groups
1774         for (uint256 i = 0; i < groups.length; i++) {
1775             uint256 n = i + uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % (groups.length - i);
1776             uint256 temp = groups[n];
1777             groups[n] = groups[i];
1778             groups[i] = temp;
1779         }
1780     }
1781 
1782     function getIndexOfGroup(uint256 groupId) public view returns (uint256) {
1783         for (uint256 i = 0; i < groups.length; i++) {
1784             if (groups[i] == groupId) {
1785                 return i;
1786             }
1787         }
1788         require(false); // error
1789         return 10000;
1790     }
1791 
1792     function getCurrentGroupIndex() public view returns (uint256) {
1793         require(block.number >= (BLOCKS_IN_A_DAY + mintStartBlock));
1794         require(mintStartBlock > 0);
1795 
1796         uint256 numBlocksPassed = block.number - (BLOCKS_IN_A_DAY + mintStartBlock);
1797         uint256 currentGroup = numBlocksPassed / BLOCKS_IN_A_DAY;
1798 
1799         return currentGroup;
1800     }
1801 
1802     function mintWithMerkleScoreEight(
1803         address account,
1804         uint256 group,
1805         bytes32[] calldata merkleProof
1806     ) public {
1807         // Verify the merkle proof.
1808         bytes32 node = keccak256(abi.encodePacked(account, group));
1809 
1810         require(
1811             MerkleProof.verify(merkleProof, eightsMerkleRoot, node),
1812             "Invalid proof."
1813         );
1814 
1815         // Check current group
1816         require(msg.sender == account, "Must be you");
1817         require(didShuffleGroups == true);
1818         uint256 yourGroupIndex = getIndexOfGroup(group);
1819         require(getCurrentGroupIndex() >= yourGroupIndex); // Can only mint if you're the current group
1820 
1821         require(publicCounter < 1459);
1822         publicCounter++;
1823 
1824         mintBlueprint();
1825     }
1826 
1827     function mintWithMerkleScoreSeven(address account, bytes32[] calldata merkleProof) public {
1828         // Verify the merkle proof.
1829         bytes32 node = keccak256(abi.encodePacked(account));
1830 
1831         require(
1832             MerkleProof.verify(merkleProof, sevensMerkleRoot, node),
1833             "Invalid proof."
1834         );
1835 
1836         require(msg.sender == account, "Must be you");
1837         require(didShuffleGroups == true);
1838         require(getCurrentGroupIndex() > 29, "Not time yet");
1839 
1840         require(publicCounter < 1459);
1841         publicCounter++;
1842 
1843         mintBlueprint();
1844     }
1845 
1846     /*
1847  ____     ___   ____  ___        _____  __ __  ____     __ ______  ____  ___   ____   _____
1848 |    \   /  _] /    ||   \      |     ||  |  ||    \   /  ]      ||    |/   \ |    \ / ___/
1849 |  D  ) /  [_ |  o  ||    \     |   __||  |  ||  _  | /  /|      | |  ||     ||  _  (   \_ 
1850 |    / |    _]|     ||  D  |    |  |_  |  |  ||  |  |/  / |_|  |_| |  ||  O  ||  |  |\__  |
1851 |    \ |   [_ |  _  ||     |    |   _] |  :  ||  |  /   \_  |  |   |  ||     ||  |  |/  \ |
1852 |  .  \|     ||  |  ||     |    |  |   |     ||  |  \     | |  |   |  ||     ||  |  |\    |
1853 |__|\_||_____||__|__||_____|    |__|    \__,_||__|__|\____| |__|  |____|\___/ |__|__| \___|
1854                                                                                            
1855 */
1856 
1857     /**
1858      * @dev Hash to HTML function
1859      */
1860     function hashToHTML(string memory _hash, uint256 _tokenId)
1861         public
1862         view
1863         returns (string memory)
1864     {
1865         string memory htmlString = string(
1866             abi.encodePacked(
1867                 'data:text/html,%3Chtml%3E%3Chead%3E%3Cscript%20src%3D%22',
1868                 p5jsUrl,
1869                 '%22%20integrity%3D%22',
1870                 p5jsIntegrity,
1871                 '%22%20crossorigin%3D%22anonymous%22%3E%3C%2Fscript%3E%3C%2Fhead%3E%3Cbody%3E%3Cscript%3Evar%20seed%3D',
1872                 AnonymiceLibrary.toString(_tokenId),
1873                 '%3Bvar%20ts%3D%22',
1874                 _hash
1875             )
1876         );
1877 
1878         string memory dataString = IBlueprintsData(blueprintsData).partialBlueprintsCode();
1879 
1880         htmlString = string(
1881             abi.encodePacked(
1882                 htmlString,
1883                 dataString
1884             )
1885         );
1886 
1887         return htmlString;
1888     }
1889 
1890     /**
1891      * @dev Hash to metadata function
1892      */
1893     function hashToMetadata(string memory _hash)
1894         public
1895         view
1896         returns (string memory)
1897     {
1898         string memory metadataString;
1899         
1900         uint8 paletteTraitIndex = AnonymiceLibrary.parseInt(
1901             AnonymiceLibrary.substring(_hash, 0, 2)
1902         );
1903 
1904         metadataString = string(
1905             abi.encodePacked(
1906                 metadataString,
1907                 '{"trait_type":"',
1908                 traitTypes[0][paletteTraitIndex].traitType,
1909                 '","value":"',
1910                 traitTypes[0][paletteTraitIndex].traitName,
1911                 '"},'
1912             )
1913         );
1914 
1915         for (uint8 i = 2; i < 18; i++) {
1916             uint8 thisTraitIndex = AnonymiceLibrary.parseInt(
1917                 AnonymiceLibrary.substring(_hash, i, i + 1)
1918             );
1919 
1920             string memory traitType = traitTypes[i][thisTraitIndex].traitType;
1921 
1922             if (bytes(traitType).length > 0) {
1923                 metadataString = string(
1924                     abi.encodePacked(
1925                         metadataString,
1926                         '{"trait_type":"',
1927                         traitType,
1928                         '","value":"',
1929                         traitTypes[i][thisTraitIndex].traitName,
1930                         '"}'
1931                     )
1932                 );
1933 
1934                 if (i != 17) {
1935                     metadataString = string(abi.encodePacked(metadataString, ","));
1936                 }
1937             }
1938         }
1939 
1940         return string(abi.encodePacked("[", metadataString, "]"));
1941     }
1942 
1943     /**
1944      * @dev Returns the SVG and metadata for a token Id
1945      * @param _tokenId The tokenId to return the SVG and metadata for.
1946      */
1947     function tokenURI(uint256 _tokenId)
1948         public
1949         view
1950         override
1951         returns (string memory)
1952     {
1953         require(_exists(_tokenId));
1954 
1955         string memory tokenHash = _tokenIdToHash(_tokenId);
1956         
1957         string memory description = '", "description": "1489 forgotten BLU3PRINTS were found, left behind by a distant civilization. Traits generated on-chain. Metadata and BLU3PRINTS are mirrored permanently on-chain. Owners can swap between portrait and landscape on-chain.",';
1958 
1959         string memory encodedTokenId = AnonymiceLibrary.encode(bytes(string(abi.encodePacked(AnonymiceLibrary.toString(_tokenId)))));
1960         string memory encodedHash = AnonymiceLibrary.encode(bytes(string(abi.encodePacked(tokenHash))));
1961         
1962         return
1963             string(
1964                 abi.encodePacked(
1965                     "data:application/json;base64,",
1966                     AnonymiceLibrary.encode(
1967                         bytes(
1968                             string(
1969                                 abi.encodePacked(
1970                                     '{"name": "BLU3PRINTS #',
1971                                     AnonymiceLibrary.toString(_tokenId),
1972                                     description,
1973                                     '"external_url":"',
1974                                     externalUrl,
1975                                     encodedTokenId,
1976                                     '&t=',
1977                                     encodedHash,
1978                                     '","image":"',
1979                                     imageUrl,
1980                                     AnonymiceLibrary.toString(_tokenId),
1981                                     '/',
1982                                     tokenHash,
1983                                     '","attributes":',
1984                                     hashToMetadata(tokenHash),
1985                                     '}'
1986                                 )
1987                             )
1988                         )
1989                     )
1990                 )
1991             );
1992     }
1993 
1994     /**
1995      * @dev Returns a hash for a given tokenId
1996      * @param _tokenId The tokenId to return the hash for.
1997      */
1998     function _tokenIdToHash(uint256 _tokenId)
1999         public
2000         view
2001         returns (string memory)
2002     {
2003         string memory tokenHash = tokenIdToHash[_tokenId];
2004         if (tokenIdToLandscape[_tokenId]) {
2005             tokenHash = string(abi.encodePacked(tokenHash,"0"));
2006         } else {
2007             tokenHash = string(abi.encodePacked(tokenHash,"1"));
2008         }
2009 
2010         return tokenHash;
2011     }
2012 
2013     /*
2014 
2015   ___   __    __  ____     ___  ____       _____  __ __  ____     __ ______  ____  ___   ____   _____
2016  /   \ |  |__|  ||    \   /  _]|    \     |     ||  |  ||    \   /  ]      ||    |/   \ |    \ / ___/
2017 |     ||  |  |  ||  _  | /  [_ |  D  )    |   __||  |  ||  _  | /  /|      | |  ||     ||  _  (   \_ 
2018 |  O  ||  |  |  ||  |  ||    _]|    /     |  |_  |  |  ||  |  |/  / |_|  |_| |  ||  O  ||  |  |\__  |
2019 |     ||  `  '  ||  |  ||   [_ |    \     |   _] |  :  ||  |  /   \_  |  |   |  ||     ||  |  |/  \ |
2020 |     | \      / |  |  ||     ||  .  \    |  |   |     ||  |  \     | |  |   |  ||     ||  |  |\    |
2021  \___/   \_/\_/  |__|__||_____||__|\_|    |__|    \__,_||__|__|\____| |__|  |____|\___/ |__|__| \___|
2022                                                                                                      
2023 
2024 
2025     */
2026     
2027     /**
2028      * @dev Clears the traits.
2029      */
2030     function clearTraits() public onlyOwner {
2031         for (uint256 i = 0; i < 18; i++) {
2032             delete traitTypes[i];
2033         }
2034     }
2035 
2036     /**
2037      * @dev Add a trait type
2038      * @param _traitTypeIndex The trait type index
2039      * @param traits Array of traits to add
2040      */
2041 
2042     function addTraitType(uint256 _traitTypeIndex, Trait[] memory traits)
2043         public
2044         onlyOwner
2045     {
2046         for (uint256 i = 0; i < traits.length; i++) {
2047             traitTypes[_traitTypeIndex].push(
2048                 Trait(
2049                     traits[i].traitName,
2050                     traits[i].traitType
2051                 )
2052             );
2053         }
2054 
2055         return;
2056     }
2057     
2058     function flipMintingSwitch() public onlyOwner {
2059         if (mintStartBlock == 0) {
2060             mintStartBlock = block.number;
2061         }
2062         MINTING_LIVE = !MINTING_LIVE;
2063     }
2064 
2065     function changeOrientation(uint256 tokenId) public {
2066         require(ownerOf(tokenId) == msg.sender, "Only owner of token can modify it");
2067         tokenIdToLandscape[tokenId] = !tokenIdToLandscape[tokenId];
2068     }
2069 
2070     /**
2071      * @dev Sets the p5js url
2072      * @param _p5jsUrl The address of the p5js file hosted on CDN
2073      */
2074 
2075     function setJsAddress(string memory _p5jsUrl) public onlyOwner {
2076         p5jsUrl = _p5jsUrl;
2077     }
2078 
2079     /**
2080      * @dev Sets the p5js resource integrity
2081      * @param _p5jsIntegrity The hash of the p5js file (to protect w subresource integrity)
2082      */
2083 
2084     function setJsIntegrity(string memory _p5jsIntegrity) public onlyOwner {
2085         p5jsIntegrity = _p5jsIntegrity;
2086     }
2087     
2088     /**
2089      * @dev Sets the base image url
2090      * @param _imageUrl The base url for image field
2091      */
2092 
2093     function setImageUrl(string memory _imageUrl) public onlyOwner {
2094         imageUrl = _imageUrl;
2095     }
2096 
2097     /**
2098      * @dev Used to add additional static traits if needed later on
2099      * @param _otherTraits The other traits string
2100      */
2101 
2102     function setOtherTraits(string memory _otherTraits) public onlyOwner {
2103         otherTraits = _otherTraits;
2104     }
2105 
2106     /**
2107      * @dev Used to update the external image url
2108      * @param _externalUrl The external url string
2109      */
2110 
2111     function setExternalUrl(string memory _externalUrl) public onlyOwner {
2112         externalUrl = _externalUrl;
2113     }
2114 }