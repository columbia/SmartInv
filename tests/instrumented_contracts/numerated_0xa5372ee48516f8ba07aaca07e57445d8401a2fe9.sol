1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 /**
27  * @dev Implementation of the {IERC165} interface.
28  *
29  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
30  * for the additional interface id that will be supported. For example:
31  *
32  * ```solidity
33  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
34  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
35  * }
36  * ```
37  *
38  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
39  */
40 abstract contract ERC165 is IERC165 {
41     /**
42      * @dev See {IERC165-supportsInterface}.
43      */
44     function supportsInterface(bytes4 interfaceId)
45         public
46         view
47         virtual
48         override
49         returns (bool)
50     {
51         return interfaceId == type(IERC165).interfaceId;
52     }
53 }
54 
55 /// @title Base64
56 /// @notice Provides a function for encoding some bytes in base64
57 /// @author Brecht Devos <brecht@loopring.org>
58 library Base64 {
59     bytes internal constant TABLE =
60         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
61 
62     /// @notice Encodes some bytes to the base64 representation
63     function encode(bytes memory data) internal pure returns (string memory) {
64         uint256 len = data.length;
65         if (len == 0) return "";
66 
67         // multiply by 4/3 rounded up
68         uint256 encodedLen = 4 * ((len + 2) / 3);
69 
70         // Add some extra buffer at the end
71         bytes memory result = new bytes(encodedLen + 32);
72 
73         bytes memory table = TABLE;
74 
75         assembly {
76             let tablePtr := add(table, 1)
77             let resultPtr := add(result, 32)
78 
79             for {
80                 let i := 0
81             } lt(i, len) {
82 
83             } {
84                 i := add(i, 3)
85                 let input := and(mload(add(data, i)), 0xffffff)
86 
87                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
88                 out := shl(8, out)
89                 out := add(
90                     out,
91                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
92                 )
93                 out := shl(8, out)
94                 out := add(
95                     out,
96                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
97                 )
98                 out := shl(8, out)
99                 out := add(
100                     out,
101                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
102                 )
103                 out := shl(224, out)
104 
105                 mstore(resultPtr, out)
106 
107                 resultPtr := add(resultPtr, 4)
108             }
109 
110             switch mod(len, 3)
111             case 1 {
112                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
113             }
114             case 2 {
115                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
116             }
117 
118             mstore(result, encodedLen)
119         }
120 
121         return string(result);
122     }
123 
124     function decode(bytes memory data) internal pure returns (bytes memory) {
125         uint8[128] memory toInt;
126 
127         for (uint8 i = 0; i < bytes(TABLE).length; i++) {
128             toInt[uint8(bytes(TABLE)[i])] = i;
129         }
130 
131         uint256 delta;
132         uint256 len = data.length;
133         if (data[len - 2] == "=" && data[len - 1] == "=") {
134             delta = 2;
135         } else if (data[len - 1] == "=") {
136             delta = 1;
137         } else {
138             delta = 0;
139         }
140         uint256 decodedLen = (len * 3) / 4 - delta;
141         bytes memory buffer = new bytes(decodedLen);
142         uint256 index;
143         uint8 mask = 0xFF;
144 
145         for (uint256 i = 0; i < len; i += 4) {
146             uint8 c0 = toInt[uint8(data[i])];
147             uint8 c1 = toInt[uint8(data[i + 1])];
148             buffer[index++] = (bytes1)(((c0 << 2) | (c1 >> 4)) & mask);
149             if (index >= buffer.length) {
150                 return buffer;
151             }
152             uint8 c2 = toInt[uint8(data[i + 2])];
153             buffer[index++] = (bytes1)(((c1 << 4) | (c2 >> 2)) & mask);
154             if (index >= buffer.length) {
155                 return buffer;
156             }
157             uint8 c3 = toInt[uint8(data[i + 3])];
158             buffer[index++] = (bytes1)(((c2 << 6) | c3) & mask);
159         }
160         return buffer;
161     }
162 }
163 
164 /**
165  * @dev These functions deal with verification of Merkle Trees proofs.
166  *
167  * The proofs can be generated using the JavaScript library
168  * https://github.com/miguelmota/merkletreejs[merkletreejs].
169  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
170  *
171  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
172  */
173 library MerkleProof {
174     /**
175      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
176      * defined by `root`. For this, a `proof` must be provided, containing
177      * sibling hashes on the branch from the leaf to the root of the tree. Each
178      * pair of leaves and each pair of pre-images are assumed to be sorted.
179      */
180     function verify(
181         bytes32[] memory proof,
182         bytes32 root,
183         bytes32 leaf
184     ) internal pure returns (bool) {
185         bytes32 computedHash = leaf;
186 
187         for (uint256 i = 0; i < proof.length; i++) {
188             bytes32 proofElement = proof[i];
189 
190             if (computedHash <= proofElement) {
191                 // Hash(current computed hash + current element of the proof)
192                 computedHash = keccak256(
193                     abi.encodePacked(computedHash, proofElement)
194                 );
195             } else {
196                 // Hash(current element of the proof + current computed hash)
197                 computedHash = keccak256(
198                     abi.encodePacked(proofElement, computedHash)
199                 );
200             }
201         }
202 
203         // Check if the computed hash (root) is equal to the provided root
204         return computedHash == root;
205     }
206 }
207 
208 /**
209  * @dev Collection of functions related to the address type
210  */
211 library Address {
212     /**
213      * @dev Returns true if `account` is a contract.
214      *
215      * [IMPORTANT]
216      * ====
217      * It is unsafe to assume that an address for which this function returns
218      * false is an externally-owned account (EOA) and not a contract.
219      *
220      * Among others, `isContract` will return false for the following
221      * types of addresses:
222      *
223      *  - an externally-owned account
224      *  - a contract in construction
225      *  - an address where a contract will be created
226      *  - an address where a contract lived, but was destroyed
227      * ====
228      */
229     function isContract(address account) internal view returns (bool) {
230         // This method relies on extcodesize, which returns 0 for contracts in
231         // construction, since the code is only stored at the end of the
232         // constructor execution.
233 
234         uint256 size;
235         assembly {
236             size := extcodesize(account)
237         }
238         return size > 0;
239     }
240 
241     /**
242      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
243      * `recipient`, forwarding all available gas and reverting on errors.
244      *
245      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
246      * of certain opcodes, possibly making contracts go over the 2300 gas limit
247      * imposed by `transfer`, making them unable to receive funds via
248      * `transfer`. {sendValue} removes this limitation.
249      *
250      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
251      *
252      * IMPORTANT: because control is transferred to `recipient`, care must be
253      * taken to not create reentrancy vulnerabilities. Consider using
254      * {ReentrancyGuard} or the
255      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
256      */
257     function sendValue(address payable recipient, uint256 amount) internal {
258         require(
259             address(this).balance >= amount,
260             "Address: insufficient balance"
261         );
262 
263         (bool success, ) = recipient.call{value: amount}("");
264         require(
265             success,
266             "Address: unable to send value, recipient may have reverted"
267         );
268     }
269 
270     /**
271      * @dev Performs a Solidity function call using a low level `call`. A
272      * plain `call` is an unsafe replacement for a function call: use this
273      * function instead.
274      *
275      * If `target` reverts with a revert reason, it is bubbled up by this
276      * function (like regular Solidity function calls).
277      *
278      * Returns the raw returned data. To convert to the expected return value,
279      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
280      *
281      * Requirements:
282      *
283      * - `target` must be a contract.
284      * - calling `target` with `data` must not revert.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(address target, bytes memory data)
289         internal
290         returns (bytes memory)
291     {
292         return functionCall(target, data, "Address: low-level call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
297      * `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(
302         address target,
303         bytes memory data,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         return functionCallWithValue(target, data, 0, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but also transferring `value` wei to `target`.
312      *
313      * Requirements:
314      *
315      * - the calling contract must have an ETH balance of at least `value`.
316      * - the called Solidity function must be `payable`.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value
324     ) internal returns (bytes memory) {
325         return
326             functionCallWithValue(
327                 target,
328                 data,
329                 value,
330                 "Address: low-level call with value failed"
331             );
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
336      * with `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(
341         address target,
342         bytes memory data,
343         uint256 value,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         require(
347             address(this).balance >= value,
348             "Address: insufficient balance for call"
349         );
350         require(isContract(target), "Address: call to non-contract");
351 
352         (bool success, bytes memory returndata) = target.call{value: value}(
353             data
354         );
355         return verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(address target, bytes memory data)
365         internal
366         view
367         returns (bytes memory)
368     {
369         return
370             functionStaticCall(
371                 target,
372                 data,
373                 "Address: low-level static call failed"
374             );
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a static call.
380      *
381      * _Available since v3.3._
382      */
383     function functionStaticCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal view returns (bytes memory) {
388         require(isContract(target), "Address: static call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.staticcall(data);
391         return verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(address target, bytes memory data)
401         internal
402         returns (bytes memory)
403     {
404         return
405             functionDelegateCall(
406                 target,
407                 data,
408                 "Address: low-level delegate call failed"
409             );
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
414      * but performing a delegate call.
415      *
416      * _Available since v3.4._
417      */
418     function functionDelegateCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         require(isContract(target), "Address: delegate call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.delegatecall(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
431      * revert reason using the provided one.
432      *
433      * _Available since v4.3._
434      */
435     function verifyCallResult(
436         bool success,
437         bytes memory returndata,
438         string memory errorMessage
439     ) internal pure returns (bytes memory) {
440         if (success) {
441             return returndata;
442         } else {
443             // Look for revert reason and bubble it up if present
444             if (returndata.length > 0) {
445                 // The easiest way to bubble the revert reason is using memory via assembly
446 
447                 assembly {
448                     let returndata_size := mload(returndata)
449                     revert(add(32, returndata), returndata_size)
450                 }
451             } else {
452                 revert(errorMessage);
453             }
454         }
455     }
456 }
457 
458 /**
459  * @dev String operations.
460  */
461 library Strings {
462     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
463 
464     /**
465      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
466      */
467     function toString(uint256 value) internal pure returns (string memory) {
468         // Inspired by OraclizeAPI's implementation - MIT licence
469         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
470 
471         if (value == 0) {
472             return "0";
473         }
474         uint256 temp = value;
475         uint256 digits;
476         while (temp != 0) {
477             digits++;
478             temp /= 10;
479         }
480         bytes memory buffer = new bytes(digits);
481         while (value != 0) {
482             digits -= 1;
483             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
484             value /= 10;
485         }
486         return string(buffer);
487     }
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
491      */
492     function toHexString(uint256 value) internal pure returns (string memory) {
493         if (value == 0) {
494             return "0x00";
495         }
496         uint256 temp = value;
497         uint256 length = 0;
498         while (temp != 0) {
499             length++;
500             temp >>= 8;
501         }
502         return toHexString(value, length);
503     }
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
507      */
508     function toHexString(uint256 value, uint256 length)
509         internal
510         pure
511         returns (string memory)
512     {
513         bytes memory buffer = new bytes(2 * length + 2);
514         buffer[0] = "0";
515         buffer[1] = "x";
516         for (uint256 i = 2 * length + 1; i > 1; --i) {
517             buffer[i] = _HEX_SYMBOLS[value & 0xf];
518             value >>= 4;
519         }
520         require(value == 0, "Strings: hex length insufficient");
521         return string(buffer);
522     }
523 }
524 
525 /**
526  * @title Counters
527  * @author Matt Condon (@shrugs)
528  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
529  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
530  *
531  * Include with `using Counters for Counters.Counter;`
532  */
533 library Counters {
534     struct Counter {
535         // This variable should never be directly accessed by users of the library: interactions must be restricted to
536         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
537         // this feature: see https://github.com/ethereum/solidity/issues/4637
538         uint256 _value; // default: 0
539     }
540 
541     function current(Counter storage counter) internal view returns (uint256) {
542         return counter._value;
543     }
544 
545     function increment(Counter storage counter) internal {
546         unchecked {
547             counter._value += 1;
548         }
549     }
550 
551     function decrement(Counter storage counter) internal {
552         uint256 value = counter._value;
553         require(value > 0, "Counter: decrement overflow");
554         unchecked {
555             counter._value = value - 1;
556         }
557     }
558 
559     function reset(Counter storage counter) internal {
560         counter._value = 0;
561     }
562 }
563 
564 /**
565  * @dev Provides information about the current execution context, including the
566  * sender of the transaction and its data. While these are generally available
567  * via msg.sender and msg.data, they should not be accessed in such a direct
568  * manner, since when dealing with meta-transactions the account sending and
569  * paying for execution may not be the actual sender (as far as an application
570  * is concerned).
571  *
572  * This contract is only required for intermediate, library-like contracts.
573  */
574 abstract contract Context {
575     function _msgSender() internal view virtual returns (address) {
576         return msg.sender;
577     }
578 
579     function _msgData() internal view virtual returns (bytes calldata) {
580         return msg.data;
581     }
582 }
583 
584 /**
585  * @dev Contract module which provides a basic access control mechanism, where
586  * there is an account (an owner) that can be granted exclusive access to
587  * specific functions.
588  *
589  * By default, the owner account will be the one that deploys the contract. This
590  * can later be changed with {transferOwnership}.
591  *
592  * This module is used through inheritance. It will make available the modifier
593  * `onlyOwner`, which can be applied to your functions to restrict their use to
594  * the owner.
595  */
596 abstract contract Ownable is Context {
597     address private _owner;
598 
599     event OwnershipTransferred(
600         address indexed previousOwner,
601         address indexed newOwner
602     );
603 
604     /**
605      * @dev Initializes the contract setting the deployer as the initial owner.
606      */
607     constructor() {
608         _setOwner(_msgSender());
609     }
610 
611     /**
612      * @dev Returns the address of the current owner.
613      */
614     function owner() public view virtual returns (address) {
615         return _owner;
616     }
617 
618     /**
619      * @dev Throws if called by any account other than the owner.
620      */
621     modifier onlyOwner() {
622         require(owner() == _msgSender(), "Ownable: caller is not the owner");
623         _;
624     }
625 
626     /**
627      * @dev Leaves the contract without owner. It will not be possible to call
628      * `onlyOwner` functions anymore. Can only be called by the current owner.
629      *
630      * NOTE: Renouncing ownership will leave the contract without an owner,
631      * thereby removing any functionality that is only available to the owner.
632      */
633     function renounceOwnership() public virtual onlyOwner {
634         _setOwner(address(0));
635     }
636 
637     /**
638      * @dev Transfers ownership of the contract to a new account (`newOwner`).
639      * Can only be called by the current owner.
640      */
641     function transferOwnership(address newOwner) public virtual onlyOwner {
642         require(
643             newOwner != address(0),
644             "Ownable: new owner is the zero address"
645         );
646         _setOwner(newOwner);
647     }
648 
649     function _setOwner(address newOwner) private {
650         address oldOwner = _owner;
651         _owner = newOwner;
652         emit OwnershipTransferred(oldOwner, newOwner);
653     }
654 }
655 
656 /**
657  * @dev Required interface of an ERC721 compliant contract.
658  */
659 interface IERC721 is IERC165 {
660     /**
661      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
662      */
663     event Transfer(
664         address indexed from,
665         address indexed to,
666         uint256 indexed tokenId
667     );
668 
669     /**
670      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
671      */
672     event Approval(
673         address indexed owner,
674         address indexed approved,
675         uint256 indexed tokenId
676     );
677 
678     /**
679      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
680      */
681     event ApprovalForAll(
682         address indexed owner,
683         address indexed operator,
684         bool approved
685     );
686 
687     /**
688      * @dev Returns the number of tokens in ``owner``'s account.
689      */
690     function balanceOf(address owner) external view returns (uint256 balance);
691 
692     /**
693      * @dev Returns the owner of the `tokenId` token.
694      *
695      * Requirements:
696      *
697      * - `tokenId` must exist.
698      */
699     function ownerOf(uint256 tokenId) external view returns (address owner);
700 
701     /**
702      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
703      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must exist and be owned by `from`.
710      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
711      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
712      *
713      * Emits a {Transfer} event.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId
719     ) external;
720 
721     /**
722      * @dev Transfers `tokenId` token from `from` to `to`.
723      *
724      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
725      *
726      * Requirements:
727      *
728      * - `from` cannot be the zero address.
729      * - `to` cannot be the zero address.
730      * - `tokenId` token must be owned by `from`.
731      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
732      *
733      * Emits a {Transfer} event.
734      */
735     function transferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) external;
740 
741     /**
742      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
743      * The approval is cleared when the token is transferred.
744      *
745      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
746      *
747      * Requirements:
748      *
749      * - The caller must own the token or be an approved operator.
750      * - `tokenId` must exist.
751      *
752      * Emits an {Approval} event.
753      */
754     function approve(address to, uint256 tokenId) external;
755 
756     /**
757      * @dev Returns the account approved for `tokenId` token.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function getApproved(uint256 tokenId)
764         external
765         view
766         returns (address operator);
767 
768     /**
769      * @dev Approve or remove `operator` as an operator for the caller.
770      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
771      *
772      * Requirements:
773      *
774      * - The `operator` cannot be the caller.
775      *
776      * Emits an {ApprovalForAll} event.
777      */
778     function setApprovalForAll(address operator, bool _approved) external;
779 
780     /**
781      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
782      *
783      * See {setApprovalForAll}
784      */
785     function isApprovedForAll(address owner, address operator)
786         external
787         view
788         returns (bool);
789 
790     /**
791      * @dev Safely transfers `tokenId` token from `from` to `to`.
792      *
793      * Requirements:
794      *
795      * - `from` cannot be the zero address.
796      * - `to` cannot be the zero address.
797      * - `tokenId` token must exist and be owned by `from`.
798      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
799      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
800      *
801      * Emits a {Transfer} event.
802      */
803     function safeTransferFrom(
804         address from,
805         address to,
806         uint256 tokenId,
807         bytes calldata data
808     ) external;
809 }
810 
811 /**
812  * @title ERC721 token receiver interface
813  * @dev Interface for any contract that wants to support safeTransfers
814  * from ERC721 asset contracts.
815  */
816 interface IERC721Receiver {
817     /**
818      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
819      * by `operator` from `from`, this function is called.
820      *
821      * It must return its Solidity selector to confirm the token transfer.
822      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
823      *
824      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
825      */
826     function onERC721Received(
827         address operator,
828         address from,
829         uint256 tokenId,
830         bytes calldata data
831     ) external returns (bytes4);
832 }
833 
834 /**
835  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
836  * @dev See https://eips.ethereum.org/EIPS/eip-721
837  */
838 interface IERC721Metadata is IERC721 {
839     /**
840      * @dev Returns the token collection name.
841      */
842     function name() external view returns (string memory);
843 
844     /**
845      * @dev Returns the token collection symbol.
846      */
847     function symbol() external view returns (string memory);
848 
849     /**
850      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
851      */
852     function tokenURI(uint256 tokenId) external view returns (string memory);
853 }
854 
855 /**
856  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
857  * the Metadata extension, but not including the Enumerable extension, which is available separately as
858  * {ERC721Enumerable}.
859  */
860 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
861     using Address for address;
862     using Strings for uint256;
863 
864     // Token name
865     string private _name;
866 
867     // Token symbol
868     string private _symbol;
869 
870     // Mapping from token ID to owner address
871     mapping(uint256 => address) private _owners;
872 
873     // Mapping owner address to token count
874     mapping(address => uint256) private _balances;
875 
876     // Mapping from token ID to approved address
877     mapping(uint256 => address) private _tokenApprovals;
878 
879     // Mapping from owner to operator approvals
880     mapping(address => mapping(address => bool)) private _operatorApprovals;
881 
882     /**
883      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
884      */
885     constructor(string memory name_, string memory symbol_) {
886         _name = name_;
887         _symbol = symbol_;
888     }
889 
890     /**
891      * @dev See {IERC165-supportsInterface}.
892      */
893     function supportsInterface(bytes4 interfaceId)
894         public
895         view
896         virtual
897         override(ERC165, IERC165)
898         returns (bool)
899     {
900         return
901             interfaceId == type(IERC721).interfaceId ||
902             interfaceId == type(IERC721Metadata).interfaceId ||
903             super.supportsInterface(interfaceId);
904     }
905 
906     /**
907      * @dev See {IERC721-balanceOf}.
908      */
909     function balanceOf(address owner)
910         public
911         view
912         virtual
913         override
914         returns (uint256)
915     {
916         require(
917             owner != address(0),
918             "ERC721: balance query for the zero address"
919         );
920         return _balances[owner];
921     }
922 
923     /**
924      * @dev See {IERC721-ownerOf}.
925      */
926     function ownerOf(uint256 tokenId)
927         public
928         view
929         virtual
930         override
931         returns (address)
932     {
933         address owner = _owners[tokenId];
934         require(
935             owner != address(0),
936             "ERC721: owner query for nonexistent token"
937         );
938         return owner;
939     }
940 
941     /**
942      * @dev See {IERC721Metadata-name}.
943      */
944     function name() public view virtual override returns (string memory) {
945         return _name;
946     }
947 
948     /**
949      * @dev See {IERC721Metadata-symbol}.
950      */
951     function symbol() public view virtual override returns (string memory) {
952         return _symbol;
953     }
954 
955     /**
956      * @dev See {IERC721Metadata-tokenURI}.
957      */
958     function tokenURI(uint256 tokenId)
959         public
960         view
961         virtual
962         override
963         returns (string memory)
964     {
965         require(
966             _exists(tokenId),
967             "ERC721Metadata: URI query for nonexistent token"
968         );
969 
970         string memory baseURI = _baseURI();
971         return
972             bytes(baseURI).length > 0
973                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
974                 : "";
975     }
976 
977     /**
978      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
979      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
980      * by default, can be overriden in child contracts.
981      */
982     function _baseURI() internal view virtual returns (string memory) {
983         return "";
984     }
985 
986     /**
987      * @dev See {IERC721-approve}.
988      */
989     function approve(address to, uint256 tokenId) public virtual override {
990         address owner = ERC721.ownerOf(tokenId);
991         require(to != owner, "ERC721: approval to current owner");
992 
993         require(
994             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
995             "ERC721: approve caller is not owner nor approved for all"
996         );
997 
998         _approve(to, tokenId);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-getApproved}.
1003      */
1004     function getApproved(uint256 tokenId)
1005         public
1006         view
1007         virtual
1008         override
1009         returns (address)
1010     {
1011         require(
1012             _exists(tokenId),
1013             "ERC721: approved query for nonexistent token"
1014         );
1015 
1016         return _tokenApprovals[tokenId];
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-setApprovalForAll}.
1021      */
1022     function setApprovalForAll(address operator, bool approved)
1023         public
1024         virtual
1025         override
1026     {
1027         require(operator != _msgSender(), "ERC721: approve to caller");
1028 
1029         _operatorApprovals[_msgSender()][operator] = approved;
1030         emit ApprovalForAll(_msgSender(), operator, approved);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-isApprovedForAll}.
1035      */
1036     function isApprovedForAll(address owner, address operator)
1037         public
1038         view
1039         virtual
1040         override
1041         returns (bool)
1042     {
1043         return _operatorApprovals[owner][operator];
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-transferFrom}.
1048      */
1049     function transferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) public virtual override {
1054         //solhint-disable-next-line max-line-length
1055         require(
1056             _isApprovedOrOwner(_msgSender(), tokenId),
1057             "ERC721: transfer caller is not owner nor approved"
1058         );
1059 
1060         _transfer(from, to, tokenId);
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-safeTransferFrom}.
1065      */
1066     function safeTransferFrom(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) public virtual override {
1071         safeTransferFrom(from, to, tokenId, "");
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-safeTransferFrom}.
1076      */
1077     function safeTransferFrom(
1078         address from,
1079         address to,
1080         uint256 tokenId,
1081         bytes memory _data
1082     ) public virtual override {
1083         require(
1084             _isApprovedOrOwner(_msgSender(), tokenId),
1085             "ERC721: transfer caller is not owner nor approved"
1086         );
1087         _safeTransfer(from, to, tokenId, _data);
1088     }
1089 
1090     /**
1091      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1092      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1093      *
1094      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1095      *
1096      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1097      * implement alternative mechanisms to perform token transfer, such as signature-based.
1098      *
1099      * Requirements:
1100      *
1101      * - `from` cannot be the zero address.
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must exist and be owned by `from`.
1104      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _safeTransfer(
1109         address from,
1110         address to,
1111         uint256 tokenId,
1112         bytes memory _data
1113     ) internal virtual {
1114         _transfer(from, to, tokenId);
1115         require(
1116             _checkOnERC721Received(from, to, tokenId, _data),
1117             "ERC721: transfer to non ERC721Receiver implementer"
1118         );
1119     }
1120 
1121     /**
1122      * @dev Returns whether `tokenId` exists.
1123      *
1124      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1125      *
1126      * Tokens start existing when they are minted (`_mint`),
1127      * and stop existing when they are burned (`_burn`).
1128      */
1129     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1130         return _owners[tokenId] != address(0);
1131     }
1132 
1133     /**
1134      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1135      *
1136      * Requirements:
1137      *
1138      * - `tokenId` must exist.
1139      */
1140     function _isApprovedOrOwner(address spender, uint256 tokenId)
1141         internal
1142         view
1143         virtual
1144         returns (bool)
1145     {
1146         require(
1147             _exists(tokenId),
1148             "ERC721: operator query for nonexistent token"
1149         );
1150         address owner = ERC721.ownerOf(tokenId);
1151         return (spender == owner ||
1152             getApproved(tokenId) == spender ||
1153             isApprovedForAll(owner, spender));
1154     }
1155 
1156     /**
1157      * @dev Safely mints `tokenId` and transfers it to `to`.
1158      *
1159      * Requirements:
1160      *
1161      * - `tokenId` must not exist.
1162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1163      *
1164      * Emits a {Transfer} event.
1165      */
1166     function _safeMint(address to, uint256 tokenId) internal virtual {
1167         _safeMint(to, tokenId, "");
1168     }
1169 
1170     /**
1171      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1172      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1173      */
1174     function _safeMint(
1175         address to,
1176         uint256 tokenId,
1177         bytes memory _data
1178     ) internal virtual {
1179         _mint(to, tokenId);
1180         require(
1181             _checkOnERC721Received(address(0), to, tokenId, _data),
1182             "ERC721: transfer to non ERC721Receiver implementer"
1183         );
1184     }
1185 
1186     /**
1187      * @dev Mints `tokenId` and transfers it to `to`.
1188      *
1189      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1190      *
1191      * Requirements:
1192      *
1193      * - `tokenId` must not exist.
1194      * - `to` cannot be the zero address.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function _mint(address to, uint256 tokenId) internal virtual {
1199         require(to != address(0), "ERC721: mint to the zero address");
1200         require(!_exists(tokenId), "ERC721: token already minted");
1201 
1202         _beforeTokenTransfer(address(0), to, tokenId);
1203 
1204         _balances[to] += 1;
1205         _owners[tokenId] = to;
1206 
1207         emit Transfer(address(0), to, tokenId);
1208     }
1209 
1210     /**
1211      * @dev Destroys `tokenId`.
1212      * The approval is cleared when the token is burned.
1213      *
1214      * Requirements:
1215      *
1216      * - `tokenId` must exist.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function _burn(uint256 tokenId) internal virtual {
1221         address owner = ERC721.ownerOf(tokenId);
1222 
1223         _beforeTokenTransfer(owner, address(0), tokenId);
1224 
1225         // Clear approvals
1226         _approve(address(0), tokenId);
1227 
1228         _balances[owner] -= 1;
1229         delete _owners[tokenId];
1230 
1231         emit Transfer(owner, address(0), tokenId);
1232     }
1233 
1234     /**
1235      * @dev Transfers `tokenId` from `from` to `to`.
1236      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1237      *
1238      * Requirements:
1239      *
1240      * - `to` cannot be the zero address.
1241      * - `tokenId` token must be owned by `from`.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function _transfer(
1246         address from,
1247         address to,
1248         uint256 tokenId
1249     ) internal virtual {
1250         require(
1251             ERC721.ownerOf(tokenId) == from,
1252             "ERC721: transfer of token that is not own"
1253         );
1254         require(to != address(0), "ERC721: transfer to the zero address");
1255 
1256         _beforeTokenTransfer(from, to, tokenId);
1257 
1258         // Clear approvals from the previous owner
1259         _approve(address(0), tokenId);
1260 
1261         _balances[from] -= 1;
1262         _balances[to] += 1;
1263         _owners[tokenId] = to;
1264 
1265         emit Transfer(from, to, tokenId);
1266     }
1267 
1268     /**
1269      * @dev Approve `to` to operate on `tokenId`
1270      *
1271      * Emits a {Approval} event.
1272      */
1273     function _approve(address to, uint256 tokenId) internal virtual {
1274         _tokenApprovals[tokenId] = to;
1275         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1276     }
1277 
1278     /**
1279      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1280      * The call is not executed if the target address is not a contract.
1281      *
1282      * @param from address representing the previous owner of the given token ID
1283      * @param to target address that will receive the tokens
1284      * @param tokenId uint256 ID of the token to be transferred
1285      * @param _data bytes optional data to send along with the call
1286      * @return bool whether the call correctly returned the expected magic value
1287      */
1288     function _checkOnERC721Received(
1289         address from,
1290         address to,
1291         uint256 tokenId,
1292         bytes memory _data
1293     ) private returns (bool) {
1294         if (to.isContract()) {
1295             try
1296                 IERC721Receiver(to).onERC721Received(
1297                     _msgSender(),
1298                     from,
1299                     tokenId,
1300                     _data
1301                 )
1302             returns (bytes4 retval) {
1303                 return retval == IERC721Receiver.onERC721Received.selector;
1304             } catch (bytes memory reason) {
1305                 if (reason.length == 0) {
1306                     revert(
1307                         "ERC721: transfer to non ERC721Receiver implementer"
1308                     );
1309                 } else {
1310                     assembly {
1311                         revert(add(32, reason), mload(reason))
1312                     }
1313                 }
1314             }
1315         } else {
1316             return true;
1317         }
1318     }
1319 
1320     /**
1321      * @dev Hook that is called before any token transfer. This includes minting
1322      * and burning.
1323      *
1324      * Calling conditions:
1325      *
1326      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1327      * transferred to `to`.
1328      * - When `from` is zero, `tokenId` will be minted for `to`.
1329      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1330      * - `from` and `to` are never both zero.
1331      *
1332      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1333      */
1334     function _beforeTokenTransfer(
1335         address from,
1336         address to,
1337         uint256 tokenId
1338     ) internal virtual {}
1339 }
1340 
1341 contract Ocarinas is ERC721, Ownable {
1342     using Counters for Counters.Counter;
1343     using Strings for uint256;
1344     using Address for address payable;
1345 
1346     struct Slice {
1347         uint256 start;
1348         uint256 length;
1349     }
1350 
1351     uint256 public numChordProgressions;
1352     uint256 public mintPrice;
1353     uint256 public totalSupply;
1354     uint256 private _royaltyDivisor = 20;
1355     // Melodies and drums are mappings of chord progression number => array of tracks
1356     // a track being an array of bytes representing the MIDI data.
1357     // Bass and chords do not have multiple variations per chord progression and therefore is just
1358     // a single track.
1359     mapping(uint256 => bytes[]) private _firstMelodyParts;
1360     mapping(uint256 => bytes[]) private _secondMelodyParts;
1361     mapping(uint256 => bytes[]) private _thirdMelodyParts;
1362     mapping(uint256 => bytes[]) private _drums;
1363     mapping(uint256 => bytes) private _bass;
1364     mapping(uint256 => bytes) private _chords;
1365     mapping(uint256 => bytes2) private _timeDivisions;
1366 
1367     bool public mintingEnabled;
1368 
1369     bytes32 private _allSeedsMerkleRoot;
1370 
1371     mapping(uint256 => bytes5) private _seeds;
1372     mapping(bytes5 => bool) private _seedUsed;
1373 
1374     Counters.Counter private _tokenIdTracker;
1375 
1376     string private baseURI;
1377 
1378     string public composer = "Shaw Avery @ShawAverySongs";
1379 
1380     // CONSTRUCTOR ---------------------------------------------------
1381 
1382     constructor(
1383         string memory baseURI_,
1384         uint256 numChordProgressions_,
1385         uint256 mintPrice_
1386     ) ERC721("Ocarinas", "OC") {
1387         baseURI = baseURI_;
1388         numChordProgressions = numChordProgressions_;
1389         mintPrice = mintPrice_;
1390     }
1391 
1392     // ADMIN FUNCTIONS ---------------------------------------------------
1393 
1394     function setBaseURI(string memory baseURI_) public onlyOwner {
1395         baseURI = baseURI_;
1396     }
1397 
1398     function setMintingEnabled(bool value, uint256 supply) public onlyOwner {
1399         mintingEnabled = value;
1400         totalSupply = supply;
1401     }
1402 
1403     function setMintPrice(uint256 value) public onlyOwner {
1404         mintPrice = value;
1405     }
1406 
1407     function setComposer(string memory _composer) public onlyOwner {
1408         composer = _composer;
1409     }
1410 
1411     function setRoyaltyDivisor(uint256 value) public onlyOwner {
1412         _royaltyDivisor = value;
1413     }
1414 
1415     function setNumChordProgressions(uint256 value) public onlyOwner {
1416         numChordProgressions = value;
1417     }
1418 
1419     function setAllSeedsMerkleRoot(bytes32 value) public onlyOwner {
1420         _allSeedsMerkleRoot = value;
1421     }
1422 
1423     function withdraw(address payable to, uint256 amount) public onlyOwner {
1424         require(
1425             address(this).balance >= amount,
1426             "Ocarinas: Insufficient balance to withdraw"
1427         );
1428         if (amount == 0) {
1429             amount = address(this).balance;
1430         }
1431         if (to == address(0)) {
1432             to = payable(owner());
1433         }
1434         to.sendValue(amount);
1435     }
1436 
1437     function addFirstMelodyPart(uint256 chordProgessions, bytes calldata melody)
1438         external
1439         onlyOwner
1440     {
1441         _firstMelodyParts[chordProgessions].push(melody);
1442     }
1443 
1444     function removeFirstMelodyPart(uint256 chordProgessions, uint256 index)
1445         external
1446         onlyOwner
1447     {
1448         _firstMelodyParts[chordProgessions][index] = _firstMelodyParts[
1449             chordProgessions
1450         ][_firstMelodyParts[chordProgessions].length - 1];
1451         _firstMelodyParts[chordProgessions].pop();
1452     }
1453 
1454     function addSecondMelodyPart(uint256 chordProgessions, bytes calldata bass)
1455         external
1456         onlyOwner
1457     {
1458         _secondMelodyParts[chordProgessions].push(bass);
1459     }
1460 
1461     function removeSecondMelodyPart(uint256 chordProgessions, uint256 index)
1462         external
1463         onlyOwner
1464     {
1465         _secondMelodyParts[chordProgessions][index] = _secondMelodyParts[
1466             chordProgessions
1467         ][_secondMelodyParts[chordProgessions].length - 1];
1468         _secondMelodyParts[chordProgessions].pop();
1469     }
1470 
1471     function addThirdMelodyPart(uint256 chordProgessions, bytes calldata solo)
1472         external
1473         onlyOwner
1474     {
1475         _thirdMelodyParts[chordProgessions].push(solo);
1476     }
1477 
1478     function removeThirdMelodyPart(uint256 chordProgessions, uint256 index)
1479         external
1480         onlyOwner
1481     {
1482         _thirdMelodyParts[chordProgessions][index] = _thirdMelodyParts[
1483             chordProgessions
1484         ][_thirdMelodyParts[chordProgessions].length - 1];
1485         _thirdMelodyParts[chordProgessions].pop();
1486     }
1487 
1488     function addDrums(uint256 chordProgessions, bytes calldata drums)
1489         external
1490         onlyOwner
1491     {
1492         _drums[chordProgessions].push(drums);
1493     }
1494 
1495     function removeDrums(uint256 chordProgessions, uint256 index)
1496         external
1497         onlyOwner
1498     {
1499         _drums[chordProgessions][index] = _drums[chordProgessions][
1500             _drums[chordProgessions].length - 1
1501         ];
1502         _drums[chordProgessions].pop();
1503     }
1504 
1505     function setBass(uint256 chordProgessions, bytes calldata bass)
1506         external
1507         onlyOwner
1508     {
1509         _bass[chordProgessions] = bass;
1510     }
1511 
1512     function setChords(uint256 chordProgessions, bytes calldata chords)
1513         external
1514         onlyOwner
1515     {
1516         _chords[chordProgessions] = chords;
1517     }
1518 
1519     function setTimeDivision(uint256 chordProgessions, bytes2 timeDivision)
1520         external
1521         onlyOwner
1522     {
1523         _timeDivisions[chordProgessions] = timeDivision;
1524     }
1525 
1526     // ERC-721 FUNCTIONS ---------------------------------------------------
1527 
1528     function tokenURI(uint256 tokenId)
1529         public
1530         view
1531         virtual
1532         override
1533         returns (string memory)
1534     {
1535         require(_exists(tokenId), "Ocarinas: nonexistent token");
1536         bytes5 seed = _seeds[tokenId];
1537 
1538         string memory mid = Base64.encode(
1539             bytes.concat(
1540                 newMidi(6, uint8(seed[0])),
1541                 newTrack(_firstMelodyParts[uint8(seed[0])][uint8(seed[1])]),
1542                 newTrack(_secondMelodyParts[uint8(seed[0])][uint8(seed[2])]),
1543                 newTrack(_thirdMelodyParts[uint8(seed[0])][uint8(seed[3])]),
1544                 newTrack(_drums[uint8(seed[0])][uint8(seed[4])]),
1545                 newTrack(_bass[uint8(seed[0])]),
1546                 newTrack(_chords[uint8(seed[0])])
1547             )
1548         );
1549 
1550         bytes memory json = abi.encodePacked(
1551             '{"name": "Ocarina #',
1552             tokenId.toString(),
1553             '", "description": "A unique piece of music represented entirely on-chain in the MIDI format with inspiration from the musical themes and motifs of video games.", "image": "',
1554             baseURI,
1555             "/image/",
1556             uint256(uint40(seed)).toHexString(),
1557             '", "animation_url": "',
1558             baseURI
1559         );
1560         json = abi.encodePacked(
1561             json,
1562             "/animation/",
1563             uint256(uint40(seed)).toHexString(),
1564             '", "audio": "data:audio/midi;base64,',
1565             mid,
1566             '", "external_url": "http://beatfoundry.xyz", "attributes": [{"trait_type": "Chord Progression", "value": "',
1567             uint256(uint8(seed[0]) + 1).toString(),
1568             '"}, {"trait_type": "First Melody", "value": "',
1569             uint256(uint8(seed[1]) + 1).toString(),
1570             '"}, {"trait_type": "Second Melody", "value": "'
1571         );
1572         json = abi.encodePacked(
1573             json,
1574             uint256(uint8(seed[2]) + 1).toString(),
1575             '"}, {"trait_type": "Third Melody", "value": "',
1576             uint256(uint8(seed[3]) + 1).toString(),
1577             '"}, {"trait_type": "Drums", "value": "',
1578             uint256(uint8(seed[4]) + 1).toString(),
1579             '"}], "composer": "',
1580             composer,
1581             '"}'
1582         );
1583         return
1584             string(
1585                 abi.encodePacked(
1586                     "data:application/json;base64,",
1587                     Base64.encode(json)
1588                 )
1589             );
1590     }
1591 
1592     function midi(uint256 tokenId)
1593         external
1594         view
1595         virtual
1596         returns (string memory)
1597     {
1598         require(_exists(tokenId), "Ocarinas: nonexistent token");
1599         bytes5 seed = _seeds[tokenId];
1600         bytes memory drums = newTrack(_drums[uint8(seed[0])][uint8(seed[4])]);
1601         bytes memory fmp = newTrack(
1602             _firstMelodyParts[uint8(seed[0])][uint8(seed[1])]
1603         );
1604         bytes memory smp = newTrack(
1605             _secondMelodyParts[uint8(seed[0])][uint8(seed[2])]
1606         );
1607         bytes memory tmp = newTrack(
1608             _thirdMelodyParts[uint8(seed[0])][uint8(seed[3])]
1609         );
1610         bytes memory bass = newTrack(_bass[uint8(seed[0])]);
1611         bytes memory chords = newTrack(_chords[uint8(seed[0])]);
1612 
1613         bytes memory mid = bytes.concat(
1614             newMidi(6, uint8(seed[0])),
1615             fmp,
1616             smp,
1617             tmp,
1618             drums,
1619             bass,
1620             chords
1621         );
1622 
1623         string memory output = string(Base64.encode(mid));
1624         return output;
1625     }
1626 
1627     function _beforeTokenTransfer(
1628         address from,
1629         address to,
1630         uint256 tokenId
1631     ) internal virtual override {
1632         super._beforeTokenTransfer(from, to, tokenId);
1633     }
1634 
1635     function _baseURI() internal view virtual override returns (string memory) {
1636         return baseURI;
1637     }
1638 
1639     // MINTING FUNCTIONS ---------------------------------------------------
1640 
1641     function mint(
1642         address to,
1643         bytes5 seed,
1644         bytes calldata pass,
1645         bytes32[] calldata seedProof
1646     ) external payable virtual {
1647         require(mintingEnabled, "Ocarinas: minting disabled");
1648         require(msg.value == mintPrice, "Ocarinas: incorrect minting price");
1649         uint256 tokenID = _tokenIdTracker.current();
1650 
1651         require(tokenID < totalSupply, "Ocarinas: minting limit reached");
1652         require(!_seedUsed[seed], "Ocarinas: seed already used");
1653 
1654         bytes32 hashedPass = keccak256(pass);
1655         require(
1656             MerkleProof.verify(
1657                 seedProof,
1658                 _allSeedsMerkleRoot,
1659                 keccak256(abi.encodePacked(hashedPass, seed))
1660             ),
1661             "Ocarinas: invalid seed proof"
1662         );
1663 
1664         _seeds[tokenID] = seed;
1665         _seedUsed[seed] = true;
1666 
1667         _mint(to, tokenID);
1668         _tokenIdTracker.increment();
1669     }
1670 
1671     // MIDI FUNCTIONS ---------------------------------------------------
1672 
1673     function newMidi(uint8 numTracks, uint8 chordProgression)
1674         internal
1675         view
1676         returns (bytes memory)
1677     {
1678         bytes2 timeDivision = _timeDivisions[chordProgression];
1679         if (uint16(timeDivision) == 0) {
1680             timeDivision = bytes2(uint16(256));
1681         }
1682         bytes memory data = new bytes(14);
1683         data[0] = bytes1(0x4D);
1684         data[1] = bytes1(0x54);
1685         data[2] = bytes1(0x68);
1686         data[3] = bytes1(0x64);
1687         data[4] = bytes1(0x00);
1688         data[5] = bytes1(0x00);
1689         data[6] = bytes1(0x00);
1690         data[7] = bytes1(0x06);
1691         data[8] = bytes1(0x00);
1692         if (numTracks == 1) {
1693             data[9] = bytes1(0x00);
1694         } else {
1695             data[9] = bytes1(0x01);
1696         }
1697         data[10] = bytes1(0x00);
1698         data[11] = bytes1(numTracks);
1699         data[12] = timeDivision[0];
1700         data[13] = timeDivision[1];
1701         return data;
1702     }
1703 
1704     function newTrack(bytes memory data) internal pure returns (bytes memory) {
1705         bytes memory it = new bytes(8);
1706         it[0] = bytes1(0x4D);
1707         it[1] = bytes1(0x54);
1708         it[2] = bytes1(0x72);
1709         it[3] = bytes1(0x6b);
1710         bytes memory asBytes = abi.encodePacked(data.length);
1711         it[4] = asBytes[asBytes.length - 4];
1712         it[5] = asBytes[asBytes.length - 3];
1713         it[6] = asBytes[asBytes.length - 2];
1714         it[7] = asBytes[asBytes.length - 1];
1715         return bytes.concat(it, data);
1716     }
1717 
1718     // EXTRA FUNCTIONS ---------------------------------------------------
1719 
1720     function usedSupply() external view returns (uint256) {
1721         return _tokenIdTracker.current();
1722     }
1723 }