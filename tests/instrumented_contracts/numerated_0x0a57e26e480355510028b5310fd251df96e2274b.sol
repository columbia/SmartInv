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
149 // File: @openzeppelin/contracts/utils/Strings.sol
150 
151 
152 
153 pragma solidity ^0.8.0;
154 
155 /**
156  * @dev String operations.
157  */
158 library Strings {
159     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
160 
161     /**
162      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
163      */
164     function toString(uint256 value) internal pure returns (string memory) {
165         // Inspired by OraclizeAPI's implementation - MIT licence
166         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
167 
168         if (value == 0) {
169             return "0";
170         }
171         uint256 temp = value;
172         uint256 digits;
173         while (temp != 0) {
174             digits++;
175             temp /= 10;
176         }
177         bytes memory buffer = new bytes(digits);
178         while (value != 0) {
179             digits -= 1;
180             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
181             value /= 10;
182         }
183         return string(buffer);
184     }
185 
186     /**
187      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
188      */
189     function toHexString(uint256 value) internal pure returns (string memory) {
190         if (value == 0) {
191             return "0x00";
192         }
193         uint256 temp = value;
194         uint256 length = 0;
195         while (temp != 0) {
196             length++;
197             temp >>= 8;
198         }
199         return toHexString(value, length);
200     }
201 
202     /**
203      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
204      */
205     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
206         bytes memory buffer = new bytes(2 * length + 2);
207         buffer[0] = "0";
208         buffer[1] = "x";
209         for (uint256 i = 2 * length + 1; i > 1; --i) {
210             buffer[i] = _HEX_SYMBOLS[value & 0xf];
211             value >>= 4;
212         }
213         require(value == 0, "Strings: hex length insufficient");
214         return string(buffer);
215     }
216 }
217 
218 // File: @openzeppelin/contracts/utils/Context.sol
219 
220 
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev Provides information about the current execution context, including the
226  * sender of the transaction and its data. While these are generally available
227  * via msg.sender and msg.data, they should not be accessed in such a direct
228  * manner, since when dealing with meta-transactions the account sending and
229  * paying for execution may not be the actual sender (as far as an application
230  * is concerned).
231  *
232  * This contract is only required for intermediate, library-like contracts.
233  */
234 abstract contract Context {
235     function _msgSender() internal view virtual returns (address) {
236         return msg.sender;
237     }
238 
239     function _msgData() internal view virtual returns (bytes calldata) {
240         return msg.data;
241     }
242 }
243 
244 // File: @openzeppelin/contracts/access/Ownable.sol
245 
246 
247 
248 pragma solidity ^0.8.0;
249 
250 
251 /**
252  * @dev Contract module which provides a basic access control mechanism, where
253  * there is an account (an owner) that can be granted exclusive access to
254  * specific functions.
255  *
256  * By default, the owner account will be the one that deploys the contract. This
257  * can later be changed with {transferOwnership}.
258  *
259  * This module is used through inheritance. It will make available the modifier
260  * `onlyOwner`, which can be applied to your functions to restrict their use to
261  * the owner.
262  */
263 abstract contract Ownable is Context {
264     address private _owner;
265 
266     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
267 
268     /**
269      * @dev Initializes the contract setting the deployer as the initial owner.
270      */
271     constructor() {
272         _setOwner(_msgSender());
273     }
274 
275     /**
276      * @dev Returns the address of the current owner.
277      */
278     function owner() public view virtual returns (address) {
279         return _owner;
280     }
281 
282     /**
283      * @dev Throws if called by any account other than the owner.
284      */
285     modifier onlyOwner() {
286         require(owner() == _msgSender(), "Ownable: caller is not the owner");
287         _;
288     }
289 
290     /**
291      * @dev Leaves the contract without owner. It will not be possible to call
292      * `onlyOwner` functions anymore. Can only be called by the current owner.
293      *
294      * NOTE: Renouncing ownership will leave the contract without an owner,
295      * thereby removing any functionality that is only available to the owner.
296      */
297     function renounceOwnership() public virtual onlyOwner {
298         _setOwner(address(0));
299     }
300 
301     /**
302      * @dev Transfers ownership of the contract to a new account (`newOwner`).
303      * Can only be called by the current owner.
304      */
305     function transferOwnership(address newOwner) public virtual onlyOwner {
306         require(newOwner != address(0), "Ownable: new owner is the zero address");
307         _setOwner(newOwner);
308     }
309 
310     function _setOwner(address newOwner) private {
311         address oldOwner = _owner;
312         _owner = newOwner;
313         emit OwnershipTransferred(oldOwner, newOwner);
314     }
315 }
316 
317 // File: @openzeppelin/contracts/utils/Address.sol
318 
319 
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev Collection of functions related to the address type
325  */
326 library Address {
327     /**
328      * @dev Returns true if `account` is a contract.
329      *
330      * [IMPORTANT]
331      * ====
332      * It is unsafe to assume that an address for which this function returns
333      * false is an externally-owned account (EOA) and not a contract.
334      *
335      * Among others, `isContract` will return false for the following
336      * types of addresses:
337      *
338      *  - an externally-owned account
339      *  - a contract in construction
340      *  - an address where a contract will be created
341      *  - an address where a contract lived, but was destroyed
342      * ====
343      */
344     function isContract(address account) internal view returns (bool) {
345         // This method relies on extcodesize, which returns 0 for contracts in
346         // construction, since the code is only stored at the end of the
347         // constructor execution.
348 
349         uint256 size;
350         assembly {
351             size := extcodesize(account)
352         }
353         return size > 0;
354     }
355 
356     /**
357      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
358      * `recipient`, forwarding all available gas and reverting on errors.
359      *
360      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
361      * of certain opcodes, possibly making contracts go over the 2300 gas limit
362      * imposed by `transfer`, making them unable to receive funds via
363      * `transfer`. {sendValue} removes this limitation.
364      *
365      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
366      *
367      * IMPORTANT: because control is transferred to `recipient`, care must be
368      * taken to not create reentrancy vulnerabilities. Consider using
369      * {ReentrancyGuard} or the
370      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
371      */
372     function sendValue(address payable recipient, uint256 amount) internal {
373         require(address(this).balance >= amount, "Address: insufficient balance");
374 
375         (bool success, ) = recipient.call{value: amount}("");
376         require(success, "Address: unable to send value, recipient may have reverted");
377     }
378 
379     /**
380      * @dev Performs a Solidity function call using a low level `call`. A
381      * plain `call` is an unsafe replacement for a function call: use this
382      * function instead.
383      *
384      * If `target` reverts with a revert reason, it is bubbled up by this
385      * function (like regular Solidity function calls).
386      *
387      * Returns the raw returned data. To convert to the expected return value,
388      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
389      *
390      * Requirements:
391      *
392      * - `target` must be a contract.
393      * - calling `target` with `data` must not revert.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
398         return functionCall(target, data, "Address: low-level call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
403      * `errorMessage` as a fallback revert reason when `target` reverts.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         return functionCallWithValue(target, data, 0, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but also transferring `value` wei to `target`.
418      *
419      * Requirements:
420      *
421      * - the calling contract must have an ETH balance of at least `value`.
422      * - the called Solidity function must be `payable`.
423      *
424      * _Available since v3.1._
425      */
426     function functionCallWithValue(
427         address target,
428         bytes memory data,
429         uint256 value
430     ) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
436      * with `errorMessage` as a fallback revert reason when `target` reverts.
437      *
438      * _Available since v3.1._
439      */
440     function functionCallWithValue(
441         address target,
442         bytes memory data,
443         uint256 value,
444         string memory errorMessage
445     ) internal returns (bytes memory) {
446         require(address(this).balance >= value, "Address: insufficient balance for call");
447         require(isContract(target), "Address: call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.call{value: value}(data);
450         return verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455      * but performing a static call.
456      *
457      * _Available since v3.3._
458      */
459     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
460         return functionStaticCall(target, data, "Address: low-level static call failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
465      * but performing a static call.
466      *
467      * _Available since v3.3._
468      */
469     function functionStaticCall(
470         address target,
471         bytes memory data,
472         string memory errorMessage
473     ) internal view returns (bytes memory) {
474         require(isContract(target), "Address: static call to non-contract");
475 
476         (bool success, bytes memory returndata) = target.staticcall(data);
477         return verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
482      * but performing a delegate call.
483      *
484      * _Available since v3.4._
485      */
486     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
487         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
492      * but performing a delegate call.
493      *
494      * _Available since v3.4._
495      */
496     function functionDelegateCall(
497         address target,
498         bytes memory data,
499         string memory errorMessage
500     ) internal returns (bytes memory) {
501         require(isContract(target), "Address: delegate call to non-contract");
502 
503         (bool success, bytes memory returndata) = target.delegatecall(data);
504         return verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     /**
508      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
509      * revert reason using the provided one.
510      *
511      * _Available since v4.3._
512      */
513     function verifyCallResult(
514         bool success,
515         bytes memory returndata,
516         string memory errorMessage
517     ) internal pure returns (bytes memory) {
518         if (success) {
519             return returndata;
520         } else {
521             // Look for revert reason and bubble it up if present
522             if (returndata.length > 0) {
523                 // The easiest way to bubble the revert reason is using memory via assembly
524 
525                 assembly {
526                     let returndata_size := mload(returndata)
527                     revert(add(32, returndata), returndata_size)
528                 }
529             } else {
530                 revert(errorMessage);
531             }
532         }
533     }
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
537 
538 
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
555      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
568 
569 pragma solidity ^0.8.0;
570 
571 /**
572  * @dev Interface of the ERC165 standard, as defined in the
573  * https://eips.ethereum.org/EIPS/eip-165[EIP].
574  *
575  * Implementers can declare support of contract interfaces, which can then be
576  * queried by others ({ERC165Checker}).
577  *
578  * For an implementation, see {ERC165}.
579  */
580 interface IERC165 {
581     /**
582      * @dev Returns true if this contract implements the interface defined by
583      * `interfaceId`. See the corresponding
584      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
585      * to learn more about how these ids are created.
586      *
587      * This function call must use less than 30 000 gas.
588      */
589     function supportsInterface(bytes4 interfaceId) external view returns (bool);
590 }
591 
592 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
593 
594 
595 
596 pragma solidity ^0.8.0;
597 
598 
599 /**
600  * @dev Implementation of the {IERC165} interface.
601  *
602  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
603  * for the additional interface id that will be supported. For example:
604  *
605  * ```solidity
606  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
607  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
608  * }
609  * ```
610  *
611  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
612  */
613 abstract contract ERC165 is IERC165 {
614     /**
615      * @dev See {IERC165-supportsInterface}.
616      */
617     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
618         return interfaceId == type(IERC165).interfaceId;
619     }
620 }
621 
622 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
623 
624 
625 
626 pragma solidity ^0.8.0;
627 
628 
629 /**
630  * @dev Required interface of an ERC721 compliant contract.
631  */
632 interface IERC721 is IERC165 {
633     /**
634      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
635      */
636     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
637 
638     /**
639      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
640      */
641     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
642 
643     /**
644      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
645      */
646     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
647 
648     /**
649      * @dev Returns the number of tokens in ``owner``'s account.
650      */
651     function balanceOf(address owner) external view returns (uint256 balance);
652 
653     /**
654      * @dev Returns the owner of the `tokenId` token.
655      *
656      * Requirements:
657      *
658      * - `tokenId` must exist.
659      */
660     function ownerOf(uint256 tokenId) external view returns (address owner);
661 
662     /**
663      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
664      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `tokenId` token must exist and be owned by `from`.
671      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
672      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
673      *
674      * Emits a {Transfer} event.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 tokenId
680     ) external;
681 
682     /**
683      * @dev Transfers `tokenId` token from `from` to `to`.
684      *
685      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
686      *
687      * Requirements:
688      *
689      * - `from` cannot be the zero address.
690      * - `to` cannot be the zero address.
691      * - `tokenId` token must be owned by `from`.
692      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
693      *
694      * Emits a {Transfer} event.
695      */
696     function transferFrom(
697         address from,
698         address to,
699         uint256 tokenId
700     ) external;
701 
702     /**
703      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
704      * The approval is cleared when the token is transferred.
705      *
706      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
707      *
708      * Requirements:
709      *
710      * - The caller must own the token or be an approved operator.
711      * - `tokenId` must exist.
712      *
713      * Emits an {Approval} event.
714      */
715     function approve(address to, uint256 tokenId) external;
716 
717     /**
718      * @dev Returns the account approved for `tokenId` token.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function getApproved(uint256 tokenId) external view returns (address operator);
725 
726     /**
727      * @dev Approve or remove `operator` as an operator for the caller.
728      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
729      *
730      * Requirements:
731      *
732      * - The `operator` cannot be the caller.
733      *
734      * Emits an {ApprovalForAll} event.
735      */
736     function setApprovalForAll(address operator, bool _approved) external;
737 
738     /**
739      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
740      *
741      * See {setApprovalForAll}
742      */
743     function isApprovedForAll(address owner, address operator) external view returns (bool);
744 
745     /**
746      * @dev Safely transfers `tokenId` token from `from` to `to`.
747      *
748      * Requirements:
749      *
750      * - `from` cannot be the zero address.
751      * - `to` cannot be the zero address.
752      * - `tokenId` token must exist and be owned by `from`.
753      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
754      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
755      *
756      * Emits a {Transfer} event.
757      */
758     function safeTransferFrom(
759         address from,
760         address to,
761         uint256 tokenId,
762         bytes calldata data
763     ) external;
764 }
765 
766 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
767 
768 
769 
770 pragma solidity ^0.8.0;
771 
772 
773 /**
774  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
775  * @dev See https://eips.ethereum.org/EIPS/eip-721
776  */
777 interface IERC721Enumerable is IERC721 {
778     /**
779      * @dev Returns the total amount of tokens stored by the contract.
780      */
781     function totalSupply() external view returns (uint256);
782 
783     /**
784      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
785      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
786      */
787     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
788 
789     /**
790      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
791      * Use along with {totalSupply} to enumerate all tokens.
792      */
793     function tokenByIndex(uint256 index) external view returns (uint256);
794 }
795 
796 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
797 
798 
799 
800 pragma solidity ^0.8.0;
801 
802 
803 /**
804  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
805  * @dev See https://eips.ethereum.org/EIPS/eip-721
806  */
807 interface IERC721Metadata is IERC721 {
808     /**
809      * @dev Returns the token collection name.
810      */
811     function name() external view returns (string memory);
812 
813     /**
814      * @dev Returns the token collection symbol.
815      */
816     function symbol() external view returns (string memory);
817 
818     /**
819      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
820      */
821     function tokenURI(uint256 tokenId) external view returns (string memory);
822 }
823 
824 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
825 
826 
827 
828 pragma solidity ^0.8.0;
829 
830 
831 
832 
833 
834 
835 
836 
837 /**
838  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
839  * the Metadata extension, but not including the Enumerable extension, which is available separately as
840  * {ERC721Enumerable}.
841  */
842 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
843     using Address for address;
844     using Strings for uint256;
845 
846     // Token name
847     string private _name;
848 
849     // Token symbol
850     string private _symbol;
851 
852     // Mapping from token ID to owner address
853     mapping(uint256 => address) private _owners;
854 
855     // Mapping owner address to token count
856     mapping(address => uint256) private _balances;
857 
858     // Mapping from token ID to approved address
859     mapping(uint256 => address) private _tokenApprovals;
860 
861     // Mapping from owner to operator approvals
862     mapping(address => mapping(address => bool)) private _operatorApprovals;
863 
864     /**
865      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
866      */
867     constructor(string memory name_, string memory symbol_) {
868         _name = name_;
869         _symbol = symbol_;
870     }
871 
872     /**
873      * @dev See {IERC165-supportsInterface}.
874      */
875     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
876         return
877             interfaceId == type(IERC721).interfaceId ||
878             interfaceId == type(IERC721Metadata).interfaceId ||
879             super.supportsInterface(interfaceId);
880     }
881 
882     /**
883      * @dev See {IERC721-balanceOf}.
884      */
885     function balanceOf(address owner) public view virtual override returns (uint256) {
886         require(owner != address(0), "ERC721: balance query for the zero address");
887         return _balances[owner];
888     }
889 
890     /**
891      * @dev See {IERC721-ownerOf}.
892      */
893     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
894         address owner = _owners[tokenId];
895         require(owner != address(0), "ERC721: owner query for nonexistent token");
896         return owner;
897     }
898 
899     /**
900      * @dev See {IERC721Metadata-name}.
901      */
902     function name() public view virtual override returns (string memory) {
903         return _name;
904     }
905 
906     /**
907      * @dev See {IERC721Metadata-symbol}.
908      */
909     function symbol() public view virtual override returns (string memory) {
910         return _symbol;
911     }
912 
913     /**
914      * @dev See {IERC721Metadata-tokenURI}.
915      */
916     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
917         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
918 
919         string memory baseURI = _baseURI();
920         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
921     }
922 
923     /**
924      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
925      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
926      * by default, can be overriden in child contracts.
927      */
928     function _baseURI() internal view virtual returns (string memory) {
929         return "";
930     }
931 
932     /**
933      * @dev See {IERC721-approve}.
934      */
935     function approve(address to, uint256 tokenId) public virtual override {
936         address owner = ERC721.ownerOf(tokenId);
937         require(to != owner, "ERC721: approval to current owner");
938 
939         require(
940             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
941             "ERC721: approve caller is not owner nor approved for all"
942         );
943 
944         _approve(to, tokenId);
945     }
946 
947     /**
948      * @dev See {IERC721-getApproved}.
949      */
950     function getApproved(uint256 tokenId) public view virtual override returns (address) {
951         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
952 
953         return _tokenApprovals[tokenId];
954     }
955 
956     /**
957      * @dev See {IERC721-setApprovalForAll}.
958      */
959     function setApprovalForAll(address operator, bool approved) public virtual override {
960         require(operator != _msgSender(), "ERC721: approve to caller");
961 
962         _operatorApprovals[_msgSender()][operator] = approved;
963         emit ApprovalForAll(_msgSender(), operator, approved);
964     }
965 
966     /**
967      * @dev See {IERC721-isApprovedForAll}.
968      */
969     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
970         return _operatorApprovals[owner][operator];
971     }
972 
973     /**
974      * @dev See {IERC721-transferFrom}.
975      */
976     function transferFrom(
977         address from,
978         address to,
979         uint256 tokenId
980     ) public virtual override {
981         //solhint-disable-next-line max-line-length
982         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
983 
984         _transfer(from, to, tokenId);
985     }
986 
987     /**
988      * @dev See {IERC721-safeTransferFrom}.
989      */
990     function safeTransferFrom(
991         address from,
992         address to,
993         uint256 tokenId
994     ) public virtual override {
995         safeTransferFrom(from, to, tokenId, "");
996     }
997 
998     /**
999      * @dev See {IERC721-safeTransferFrom}.
1000      */
1001     function safeTransferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId,
1005         bytes memory _data
1006     ) public virtual override {
1007         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1008         _safeTransfer(from, to, tokenId, _data);
1009     }
1010 
1011     /**
1012      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1013      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1014      *
1015      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1016      *
1017      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1018      * implement alternative mechanisms to perform token transfer, such as signature-based.
1019      *
1020      * Requirements:
1021      *
1022      * - `from` cannot be the zero address.
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must exist and be owned by `from`.
1025      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _safeTransfer(
1030         address from,
1031         address to,
1032         uint256 tokenId,
1033         bytes memory _data
1034     ) internal virtual {
1035         _transfer(from, to, tokenId);
1036         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1037     }
1038 
1039     /**
1040      * @dev Returns whether `tokenId` exists.
1041      *
1042      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1043      *
1044      * Tokens start existing when they are minted (`_mint`),
1045      * and stop existing when they are burned (`_burn`).
1046      */
1047     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1048         return _owners[tokenId] != address(0);
1049     }
1050 
1051     /**
1052      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1053      *
1054      * Requirements:
1055      *
1056      * - `tokenId` must exist.
1057      */
1058     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1059         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1060         address owner = ERC721.ownerOf(tokenId);
1061         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1062     }
1063 
1064     /**
1065      * @dev Safely mints `tokenId` and transfers it to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - `tokenId` must not exist.
1070      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _safeMint(address to, uint256 tokenId) internal virtual {
1075         _safeMint(to, tokenId, "");
1076     }
1077 
1078     /**
1079      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1080      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1081      */
1082     function _safeMint(
1083         address to,
1084         uint256 tokenId,
1085         bytes memory _data
1086     ) internal virtual {
1087         _mint(to, tokenId);
1088         require(
1089             _checkOnERC721Received(address(0), to, tokenId, _data),
1090             "ERC721: transfer to non ERC721Receiver implementer"
1091         );
1092     }
1093 
1094     /**
1095      * @dev Mints `tokenId` and transfers it to `to`.
1096      *
1097      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1098      *
1099      * Requirements:
1100      *
1101      * - `tokenId` must not exist.
1102      * - `to` cannot be the zero address.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function _mint(address to, uint256 tokenId) internal virtual {
1107         require(to != address(0), "ERC721: mint to the zero address");
1108         require(!_exists(tokenId), "ERC721: token already minted");
1109 
1110         _beforeTokenTransfer(address(0), to, tokenId);
1111 
1112         _balances[to] += 1;
1113         _owners[tokenId] = to;
1114 
1115         emit Transfer(address(0), to, tokenId);
1116     }
1117 
1118     /**
1119      * @dev Destroys `tokenId`.
1120      * The approval is cleared when the token is burned.
1121      *
1122      * Requirements:
1123      *
1124      * - `tokenId` must exist.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _burn(uint256 tokenId) internal virtual {
1129         address owner = ERC721.ownerOf(tokenId);
1130 
1131         _beforeTokenTransfer(owner, address(0), tokenId);
1132 
1133         // Clear approvals
1134         _approve(address(0), tokenId);
1135 
1136         _balances[owner] -= 1;
1137         delete _owners[tokenId];
1138 
1139         emit Transfer(owner, address(0), tokenId);
1140     }
1141 
1142     /**
1143      * @dev Transfers `tokenId` from `from` to `to`.
1144      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1145      *
1146      * Requirements:
1147      *
1148      * - `to` cannot be the zero address.
1149      * - `tokenId` token must be owned by `from`.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function _transfer(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) internal virtual {
1158         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1159         require(to != address(0), "ERC721: transfer to the zero address");
1160 
1161         _beforeTokenTransfer(from, to, tokenId);
1162 
1163         // Clear approvals from the previous owner
1164         _approve(address(0), tokenId);
1165 
1166         _balances[from] -= 1;
1167         _balances[to] += 1;
1168         _owners[tokenId] = to;
1169 
1170         emit Transfer(from, to, tokenId);
1171     }
1172 
1173     /**
1174      * @dev Approve `to` to operate on `tokenId`
1175      *
1176      * Emits a {Approval} event.
1177      */
1178     function _approve(address to, uint256 tokenId) internal virtual {
1179         _tokenApprovals[tokenId] = to;
1180         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1181     }
1182 
1183     /**
1184      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1185      * The call is not executed if the target address is not a contract.
1186      *
1187      * @param from address representing the previous owner of the given token ID
1188      * @param to target address that will receive the tokens
1189      * @param tokenId uint256 ID of the token to be transferred
1190      * @param _data bytes optional data to send along with the call
1191      * @return bool whether the call correctly returned the expected magic value
1192      */
1193     function _checkOnERC721Received(
1194         address from,
1195         address to,
1196         uint256 tokenId,
1197         bytes memory _data
1198     ) private returns (bool) {
1199         if (to.isContract()) {
1200             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1201                 return retval == IERC721Receiver.onERC721Received.selector;
1202             } catch (bytes memory reason) {
1203                 if (reason.length == 0) {
1204                     revert("ERC721: transfer to non ERC721Receiver implementer");
1205                 } else {
1206                     assembly {
1207                         revert(add(32, reason), mload(reason))
1208                     }
1209                 }
1210             }
1211         } else {
1212             return true;
1213         }
1214     }
1215 
1216     /**
1217      * @dev Hook that is called before any token transfer. This includes minting
1218      * and burning.
1219      *
1220      * Calling conditions:
1221      *
1222      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1223      * transferred to `to`.
1224      * - When `from` is zero, `tokenId` will be minted for `to`.
1225      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1226      * - `from` and `to` are never both zero.
1227      *
1228      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1229      */
1230     function _beforeTokenTransfer(
1231         address from,
1232         address to,
1233         uint256 tokenId
1234     ) internal virtual {}
1235 }
1236 
1237 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1238 
1239 
1240 
1241 pragma solidity ^0.8.0;
1242 
1243 
1244 
1245 /**
1246  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1247  * enumerability of all the token ids in the contract as well as all token ids owned by each
1248  * account.
1249  */
1250 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1251     // Mapping from owner to list of owned token IDs
1252     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1253 
1254     // Mapping from token ID to index of the owner tokens list
1255     mapping(uint256 => uint256) private _ownedTokensIndex;
1256 
1257     // Array with all token ids, used for enumeration
1258     uint256[] private _allTokens;
1259 
1260     // Mapping from token id to position in the allTokens array
1261     mapping(uint256 => uint256) private _allTokensIndex;
1262 
1263     /**
1264      * @dev See {IERC165-supportsInterface}.
1265      */
1266     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1267         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1268     }
1269 
1270     /**
1271      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1272      */
1273     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1274         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1275         return _ownedTokens[owner][index];
1276     }
1277 
1278     /**
1279      * @dev See {IERC721Enumerable-totalSupply}.
1280      */
1281     function totalSupply() public view virtual override returns (uint256) {
1282         return _allTokens.length;
1283     }
1284 
1285     /**
1286      * @dev See {IERC721Enumerable-tokenByIndex}.
1287      */
1288     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1289         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1290         return _allTokens[index];
1291     }
1292 
1293     /**
1294      * @dev Hook that is called before any token transfer. This includes minting
1295      * and burning.
1296      *
1297      * Calling conditions:
1298      *
1299      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1300      * transferred to `to`.
1301      * - When `from` is zero, `tokenId` will be minted for `to`.
1302      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1303      * - `from` cannot be the zero address.
1304      * - `to` cannot be the zero address.
1305      *
1306      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1307      */
1308     function _beforeTokenTransfer(
1309         address from,
1310         address to,
1311         uint256 tokenId
1312     ) internal virtual override {
1313         super._beforeTokenTransfer(from, to, tokenId);
1314 
1315         if (from == address(0)) {
1316             _addTokenToAllTokensEnumeration(tokenId);
1317         } else if (from != to) {
1318             _removeTokenFromOwnerEnumeration(from, tokenId);
1319         }
1320         if (to == address(0)) {
1321             _removeTokenFromAllTokensEnumeration(tokenId);
1322         } else if (to != from) {
1323             _addTokenToOwnerEnumeration(to, tokenId);
1324         }
1325     }
1326 
1327     /**
1328      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1329      * @param to address representing the new owner of the given token ID
1330      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1331      */
1332     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1333         uint256 length = ERC721.balanceOf(to);
1334         _ownedTokens[to][length] = tokenId;
1335         _ownedTokensIndex[tokenId] = length;
1336     }
1337 
1338     /**
1339      * @dev Private function to add a token to this extension's token tracking data structures.
1340      * @param tokenId uint256 ID of the token to be added to the tokens list
1341      */
1342     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1343         _allTokensIndex[tokenId] = _allTokens.length;
1344         _allTokens.push(tokenId);
1345     }
1346 
1347     /**
1348      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1349      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1350      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1351      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1352      * @param from address representing the previous owner of the given token ID
1353      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1354      */
1355     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1356         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1357         // then delete the last slot (swap and pop).
1358 
1359         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1360         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1361 
1362         // When the token to delete is the last token, the swap operation is unnecessary
1363         if (tokenIndex != lastTokenIndex) {
1364             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1365 
1366             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1367             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1368         }
1369 
1370         // This also deletes the contents at the last position of the array
1371         delete _ownedTokensIndex[tokenId];
1372         delete _ownedTokens[from][lastTokenIndex];
1373     }
1374 
1375     /**
1376      * @dev Private function to remove a token from this extension's token tracking data structures.
1377      * This has O(1) time complexity, but alters the order of the _allTokens array.
1378      * @param tokenId uint256 ID of the token to be removed from the tokens list
1379      */
1380     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1381         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1382         // then delete the last slot (swap and pop).
1383 
1384         uint256 lastTokenIndex = _allTokens.length - 1;
1385         uint256 tokenIndex = _allTokensIndex[tokenId];
1386 
1387         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1388         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1389         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1390         uint256 lastTokenId = _allTokens[lastTokenIndex];
1391 
1392         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1393         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1394 
1395         // This also deletes the contents at the last position of the array
1396         delete _allTokensIndex[tokenId];
1397         _allTokens.pop();
1398     }
1399 }
1400 
1401 // File: contracts/Filaments.sol
1402 
1403 // contracts/Filaments.sol
1404 
1405 pragma solidity ^0.8.0;
1406 
1407 
1408 
1409 
1410 contract Filaments is ERC721Enumerable, Ownable {
1411     /*
1412   _   _   _   _   _   _   _   _   _  
1413  / \ / \ / \ / \ / \ / \ / \ / \ / \ 
1414 ( F | I | L | A | M | E | N | T | S )
1415  \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ 
1416 
1417 credit 2 my mouse dev and 0xinuarashi for making amazing on chain project
1418 that was used as the basis for this contract
1419 */
1420     using AnonymiceLibrary for uint8;
1421 
1422     struct Trait {
1423         string traitName;
1424         string traitType;
1425     }
1426 
1427 
1428     //Mappings
1429     mapping(uint256 => Trait[]) public traitTypes;
1430     mapping(string => bool) hashToMinted;
1431     mapping(uint256 => string) internal tokenIdToHash;
1432 
1433     //uint256s
1434     uint256 MAX_SUPPLY = 500;
1435     uint256 SEED_NONCE = 0;
1436     
1437     //minting flag
1438     bool public MINTING_LIVE = false;
1439     uint256 public finalBlock;
1440 
1441     //uint arrays
1442     uint16[][10] TIERS;
1443     
1444     //whitelist
1445     mapping (address => bool) public whitelist;
1446     uint256 public numWhitelisted;
1447 
1448     //p5js url
1449     string p5jsUrl;
1450     string p5jsIntegrity;
1451     string imageUrl;
1452     string animationUrl;
1453 
1454     constructor() ERC721("Filaments", "FLMTS") {
1455         //Declare all the rarity tiers
1456 
1457         //Palette
1458         TIERS[0] = [100, 100, 100, 100, 100, 600, 600, 600, 600, 600, 600, 1000, 1000, 1000, 1300, 1600];
1459         //Border
1460         TIERS[1] = [2000, 8000];
1461         //Number of lines
1462         TIERS[2] = [1000, 1000, 1000, 7000];
1463         //Thickness of lines
1464         TIERS[3] = [100, 400, 500, 9000];
1465         //Pixel size
1466         TIERS[4] = [100, 9900];
1467         //Noise scale
1468         TIERS[5] = [100, 400, 500, 9000];
1469         //Noise strength
1470         TIERS[6] = [100, 400, 500, 9000];
1471         //Left or right
1472         TIERS[7] = [5000, 5000];
1473         //Speed
1474         TIERS[8] = [1000, 9000];
1475         //Number of pre-iterations
1476         TIERS[9] = [500, 500, 1000, 1000, 7000];
1477         
1478         numWhitelisted = 0;
1479         
1480         finalBlock = block.number + 192000;
1481     }
1482 
1483     /*
1484   __  __ _     _   _             ___             _   _             
1485  |  \/  (_)_ _| |_(_)_ _  __ _  | __|  _ _ _  __| |_(_)___ _ _  ___
1486  | |\/| | | ' \  _| | ' \/ _` | | _| || | ' \/ _|  _| / _ \ ' \(_-<
1487  |_|  |_|_|_||_\__|_|_||_\__, | |_| \_,_|_||_\__|\__|_\___/_||_/__/
1488                          |___/                                     
1489    */
1490 
1491     /**
1492      * @dev Converts a digit from 0 - 10000 into its corresponding rarity based on the given rarity tier.
1493      * @param _randinput The input from 0 - 10000 to use for rarity gen.
1494      * @param _rarityTier The tier to use.
1495      */
1496     function rarityGen(uint256 _randinput, uint8 _rarityTier)
1497         internal
1498         view
1499         returns (uint8)
1500     {
1501         uint16 currentLowerBound = 0;
1502         for (uint8 i = 0; i < TIERS[_rarityTier].length; i++) {
1503             uint16 thisPercentage = TIERS[_rarityTier][i];
1504             if (
1505                 _randinput >= currentLowerBound &&
1506                 _randinput < currentLowerBound + thisPercentage
1507             ) return i;
1508             currentLowerBound = currentLowerBound + thisPercentage;
1509         }
1510 
1511         revert();
1512     }
1513 
1514     /**
1515      * @dev Generates a 11 digit hash from a tokenId, address, and random number.
1516      * @param _t The token id to be used within the hash.
1517      * @param _a The address to be used within the hash.
1518      * @param _c The custom nonce to be used within the hash.
1519      */
1520     function hash(
1521         uint256 _t,
1522         address _a,
1523         uint256 _c
1524     ) internal returns (string memory) {
1525         require(_c < 11);
1526 
1527         // This will generate a 11 character string.
1528         // The first 2 digits are the palette.
1529         string memory currentHash = "";
1530 
1531         for (uint8 i = 0; i < 10; i++) {
1532             SEED_NONCE++;
1533             uint16 _randinput = uint16(
1534                 uint256(
1535                     keccak256(
1536                         abi.encodePacked(
1537                             block.timestamp,
1538                             block.difficulty,
1539                             _t,
1540                             _a,
1541                             _c,
1542                             SEED_NONCE
1543                         )
1544                     )
1545                 ) % 10000
1546             );
1547             
1548             if (i == 0) {
1549                 uint8 rar = rarityGen(_randinput, i);
1550                 if (rar > 9) {
1551                     currentHash = string(
1552                         abi.encodePacked(currentHash, rar.toString())
1553                     );
1554                 } else {
1555                     currentHash = string(
1556                         abi.encodePacked(currentHash, "0", rar.toString())
1557                     );
1558                 }
1559             } else {
1560                 currentHash = string(
1561                     abi.encodePacked(currentHash, rarityGen(_randinput, i).toString())
1562                 );
1563             }
1564         }
1565 
1566         if (hashToMinted[currentHash]) return hash(_t, _a, _c + 1);
1567 
1568         return currentHash;
1569     }
1570 
1571     /**
1572      * @dev Mint internal, this is to avoid code duplication.
1573      */
1574     function mintInternal() internal {
1575         require(MINTING_LIVE == true || msg.sender == owner(), "Minting is not live.");
1576         require(isWhitelisted(msg.sender), "Must be whitelisted and can only mint 1");
1577         uint256 _totalSupply = totalSupply();
1578         require(_totalSupply < MAX_SUPPLY);
1579         require(block.number < finalBlock);
1580         require(!AnonymiceLibrary.isContract(msg.sender));
1581         
1582         whitelist[msg.sender] = false;
1583 
1584         uint256 thisTokenId = _totalSupply;
1585 
1586         tokenIdToHash[thisTokenId] = hash(thisTokenId, msg.sender, 0);
1587 
1588         hashToMinted[tokenIdToHash[thisTokenId]] = true;
1589 
1590         _mint(msg.sender, thisTokenId);
1591     }
1592 
1593     /**
1594      * @dev Mints new tokens.
1595      */
1596     function mintFilament() public {
1597         return mintInternal();
1598     }
1599 
1600     /*
1601  ____     ___   ____  ___        _____  __ __  ____     __ ______  ____  ___   ____   _____
1602 |    \   /  _] /    ||   \      |     ||  |  ||    \   /  ]      ||    |/   \ |    \ / ___/
1603 |  D  ) /  [_ |  o  ||    \     |   __||  |  ||  _  | /  /|      | |  ||     ||  _  (   \_ 
1604 |    / |    _]|     ||  D  |    |  |_  |  |  ||  |  |/  / |_|  |_| |  ||  O  ||  |  |\__  |
1605 |    \ |   [_ |  _  ||     |    |   _] |  :  ||  |  /   \_  |  |   |  ||     ||  |  |/  \ |
1606 |  .  \|     ||  |  ||     |    |  |   |     ||  |  \     | |  |   |  ||     ||  |  |\    |
1607 |__|\_||_____||__|__||_____|    |__|    \__,_||__|__|\____| |__|  |____|\___/ |__|__| \___|
1608                                                                                            
1609 */
1610     
1611     /**
1612      * @dev Helper function to see if whitelisted
1613      */
1614     function isWhitelisted(address _wallet) public view returns (bool) {
1615         if (_wallet == owner()) {
1616             return true; // Owner
1617         }
1618         
1619         return whitelist[_wallet];
1620     }
1621 
1622     /**
1623      * @dev Hash to HTML function
1624      */
1625     function hashToHTML(string memory _hash, uint256 _tokenId)
1626         public
1627         view
1628         returns (string memory)
1629     {
1630         string memory htmlString = string(
1631             abi.encodePacked(
1632                 'data:text/html,%3Chtml%3E%3Chead%3E%3Cscript%20src%3D%22',
1633                 p5jsUrl,
1634                 '%22%20integrity%3D%22',
1635                 p5jsIntegrity,
1636                 '%22%20crossorigin%3D%22anonymous%22%3E%3C%2Fscript%3E%3C%2Fhead%3E%3Cbody%3E%3Cscript%3Evar%20tokenId%3D',
1637                 AnonymiceLibrary.toString(_tokenId),
1638                 '%3Bvar%20hash%3D%22',
1639                 _hash
1640             )
1641         );
1642 
1643         htmlString = string(
1644             abi.encodePacked(
1645                 htmlString,
1646                 '%22%3Bfunction%20sdfsd%28t%29%7Breturn%20function%28%29%7Bvar%20e%3Dt%2B%3D1831565813%3Breturn%20e%3DMath.imul%28e%5Ee%3E%3E%3E15%2C1%7Ce%29%2C%28%28%28e%5E%3De%2BMath.imul%28e%5Ee%3E%3E%3E7%2C61%7Ce%29%29%5Ee%3E%3E%3E14%29%3E%3E%3E0%29%2F4294967296%7D%7Dfunction%20wraw%28t%29%7Bvar%20e%2Cr%3D%5B%5D%3Bfor%28e%3D0%3Be%3Ct.length%3Be%2B%2B%29r%5Be%5D%3Dt%5Be%5D.w1%2B%28r%5Be-1%5D%7C%7C0%29%3Bvar%20i%3Drand%28%29%2Ar%5Br.length-1%5D%3Bfor%28e%3D0%3Be%3Cr.length%26%26%21%28r%5Be%5D%3Ei%29%3Be%2B%2B%29%3Breturn%20t%5Be%5D%7Dfunction%20wrnd%28t%29%7Breturn%20wraw%28t%29.a1%7Dfunction%20gRI%28t%29%7Breturn%20Math.floor%28rand%28%29%2At%29%7Dfunction%20traitRaw%28t%2Ce%29%7Breturn%20e%3E%3Dt.length%3Ft%5Bt.length-1%5D%3At%5Be%5D%7Dfunction%20trait%28t%2Ce%29%7Breturn%20traitRaw%28t%2Ce%29.a1%7Dvar%20colors%2Cbgc%2Cc%2CdidStart%2Cimg%2Cwd%2Chei%2Cseed%2Crand%2Ctz0%2Ctz1%2Ctz2%2Ctz3%2Ctz4%2Ctz5%2Ctz6%2Ctz7%2Ctz8%2Ctz9%2Ctz10%2Cborder%2Cnum%2ClnThk%2CpxSz%2CnsScl%2CnsStr%2ClOr%2CnnUniS%2CisSUni%2Cspeed%2Czz%2Cptks%2CrunCount%2Ccanvas%2ColdWd%2ColdHei%3Bfunction%20hashToTraits%28t%29%7Bt%26%26%28tz0%3Dt.charAt%280%29%2Ctz1%3Dt.charAt%281%29%2Ctz2%3Dt.charAt%282%29%2Ctz3%3Dt.charAt%283%29%2Ctz4%3Dt.charAt%284%29%2Ctz5%3Dt.charAt%285%29%2Ctz6%3Dt.charAt%286%29%2Ctz7%3Dt.charAt%287%29%2Ctz8%3Dt.charAt%288%29%2Ctz9%3Dt.charAt%289%29%2Ctz10%3Dt.charAt%2810%29%2Ctz1%3DNumber%28tz0.toString%28%29%2Btz1.toString%28%29%29%29%7Dfunction%20setup%28%29%7Bseed%3DtokenId%2Ctz0%3D0%2Ctz1%3D7%2Ctz2%3D7%2Ctz3%3D7%2Ctz4%3D7%2Ctz5%3D7%2Ctz6%3D7%2Ctz7%3D7%2Ctz8%3D7%2Ctz9%3D7%2Ctz10%3D7%2Ctz1%3DNumber%28tz0.toString%28%29%2Btz1.toString%28%29%29%2ChashToTraits%28hash%29%2Crand%3Dsdfsd%28seed%29%2Cborder%3D0%3D%3Dtz2%3F20%3A0%3Bnum%3Dtrait%28%5B%7Ba1%3A1e3%2Cw1%3A10%7D%2C%7Ba1%3A500%2Cw1%3A10%7D%2C%7Ba1%3A250%2Cw1%3A10%7D%2C%7Ba1%3A100%2Cw1%3A70%7D%5D%2Ctz3%29%3BlnThk%3Dtrait%28%5B%7Ba1%3A40%2Cw1%3A1%7D%2C%7Ba1%3A30%2Cw1%3A4%7D%2C%7Ba1%3A10%2Cw1%3A5%7D%2C%7Ba1%3A20%2Cw1%3A90%7D%5D%2Ctz4%29%2CpxSz%3D0%3D%3Dtz5%3F20%3A10%3BnsScl%3Dtrait%28%5B%7Ba1%3A1e4%2Cw1%3A1%7D%2C%7Ba1%3A250%2Cw1%3A4%7D%2C%7Ba1%3A50%2Cw1%3A5%7D%2C%7Ba1%3A500%2Cw1%3A90%7D%5D%2Ctz6%29%3BnsStr%3Dtrait%28%5B%7Ba1%3A10%2Cw1%3A1%7D%2C%7Ba1%3A5%2Cw1%3A4%7D%2C%7Ba1%3A2%2Cw1%3A5%7D%2C%7Ba1%3A1%2Cw1%3A90%7D%5D%2Ctz7%29%2ClOr%3D0%3D%3Dtz8%3F-1%3A1%2CnnUniS%3Dfunction%28%29%7Breturn%20lOr%2A%283%2BgRI%283%29%29%7D%2Cspeed%3D%28isSUni%3D1%3D%3Dtz9%29%3F10%2AlOr%3AnnUniS%28%29%3Bzz%3Dtrait%28%5B%7Ba1%3A0%2Cw1%3A5%7D%2C%7Ba1%3A250%2Cw1%3A5%7D%2C%7Ba1%3A300%2Cw1%3A10%7D%2C%7Ba1%3A400%2Cw1%3A10%7D%2C%7Ba1%3A500%2Cw1%3A70%7D%5D%2Ctz10%29%2Cptks%3D%5Bnum%5D%2CrunCount%3D0%2Cwd%3DMath.min%28800%2CwindowWidth%29%2Chei%3DMath.min%28960%2CwindowHeight%29%2Cwd%3DMath.ceil%28wd%2FpxSz%29%2ApxSz%2Chei%3DMath.ceil%28hei%2FpxSz%29%2ApxSz%2CdidStart%3D%211%2CnoiseSeed%28seed%29%3Bvar%20t%3DtraitRaw%28%5B%7Ba1%3A%5B%28c%3Dcolor%29%28%22%23ffa4d5%22%29%2Cc%28%22%2383ffc1%22%29%2Cc%28%22%23ffe780%22%29%2Cc%28%22%2399e2ff%22%29%5D%2CbgColor%3Ac%28%22%23ffffff%22%29%2Cw1%3A1%7D%2C%7Ba1%3A%5Bc%28%22%23ffffff%22%29%2Cc%28%22%23000000%22%29%5D%2Cw1%3A1%7D%2C%7Ba1%3A%5Bc%28%22%23305e90%22%29%2Cc%28%22%23db4e54%22%29%2Cc%28%22%234f3c2d%22%29%2Cc%28%22%23ffbb12%22%29%2Cc%28%22%23389894%22%29%2Cc%28%22%23e0d8c5%22%29%2Cc%28%22%23c7e3d4%22%29%5D%2Cw1%3A1%2CbgColor%3Ac%28%22%23ffffff%22%29%7D%2C%7Ba1%3A%5Bc%28%22%230827f5%22%29%2Cc%28%22%233751f7%22%29%2Cc%28%22%238493fa%22%29%5D%2Cw1%3A1%7D%2C%7Ba1%3A%5Bc%28%22%2300c1ff%22%29%2Cc%28%22%230023ff%22%29%2Cc%28%22%237215ff%22%29%2Cc%28%22%23ff03fc%22%29%2Cc%28%22%23ff000a%22%29%2Cc%28%22%23ff8700%22%29%2Cc%28%22%23fff700%22%29%2Cc%28%22%235fff00%22%29%2Cc%28%22%2300ff2e%22%29%5D%2Cw1%3A1%2CbgColor%3Ac%28%22%23ffffff%22%29%7D%2C%7Ba1%3A%5Bc%28%22%2300e000%22%29%2Cc%28%22%23005900%22%29%2Cc%28%22%23000000%22%29%5D%2Cw1%3A5%7D%2C%7Ba1%3A%5Bc%28%22%239d0208%22%29%2Cc%28%22%23d00000%22%29%2Cc%28%22%23e85d04%22%29%2Cc%28%22%23faa307%22%29%5D%2Cw1%3A5%7D%2C%7Ba1%3A%5Bc%28%22%23fff69f%22%29%2Cc%28%22%23fdd870%22%29%2Cc%28%22%23d0902f%22%29%2Cc%28%22%23a15501%22%29%2Cc%28%22%23351409%22%29%5D%2Cw1%3A5%7D%2C%7Ba1%3A%5Bc%28%22%23a0ffe3%22%29%2Cc%28%22%2365dc98%22%29%2Cc%28%22%238d8980%22%29%2Cc%28%22%23575267%22%29%2Cc%28%22%23222035%22%29%5D%2Cw1%3A5%7D%2C%7Ba1%3A%5Bc%28%22%230099ff%22%29%2Cc%28%22%235655dd%22%29%2Cc%28%22%238822ff%22%29%2Cc%28%22%23aa99ff%22%29%5D%2Cw1%3A5%7D%2C%7Ba1%3A%5Bc%28%22%237700a6%22%29%2Cc%28%22%23fe00fe%22%29%2Cc%28%22%23defe47%22%29%2Cc%28%22%2300b3fe%22%29%2Cc%28%22%230016ee%22%29%5D%2Cw1%3A5%7D%2C%7Ba1%3A%5Bc%28%22%23c4ffff%22%29%2Cc%28%22%2308deea%22%29%2Cc%28%22%231261d1%22%29%5D%2Cw1%3A10%7D%2C%7Ba1%3A%5Bc%28%22%23ff124f%22%29%2Cc%28%22%23ff00a0%22%29%2Cc%28%22%23fe75fe%22%29%2Cc%28%22%237a04eb%22%29%2Cc%28%22%23120458%22%29%5D%2Cw1%3A10%7D%2C%7Ba1%3A%5Bc%28%22%23111111%22%29%2Cc%28%22%23222222%22%29%2Cc%28%22%23333333%22%29%2Cc%28%22%23444444%22%29%2Cc%28%22%23666666%22%29%5D%2Cw1%3A10%7D%2C%7Ba1%3A%5Bc%28%22%23f887ff%22%29%2Cc%28%22%23de004e%22%29%2Cc%28%22%23860029%22%29%2Cc%28%22%23321450%22%29%2Cc%28%22%2329132e%22%29%5D%2Cw1%3A15%7D%2C%7Ba1%3A%5Bc%28%22%238386f5%22%29%2Cc%28%22%233d43b4%22%29%2Cc%28%22%23041348%22%29%2Cc%28%22%23083e12%22%29%2Cc%28%22%231afe49%22%29%5D%2Cw1%3A20%7D%5D%2Ctz1%29%3Bcolors%3Dt.a1%2Cbgc%3Dc%28%22%23000000%22%29%2Ct.bgColor%26%26%28bgc%3Dt.bgColor%29%2C%28canvas%3DcreateCanvas%28wd%2Chei%29%29.doubleClicked%28toggleFullscreen%29%2CnoStroke%28%29%3Bfor%28let%20t%3D0%3Bt%3Cnum%3Bt%2B%2B%29%7Bvar%20e%3DcreateVector%28border%2BgRI%281.2%2A%28width-2%2Aborder%29%29%2Cborder%2BgRI%28height-2%2Aborder%29%2C2%29%2Cr%3DcreateVector%28cos%280%29%2Csin%280%29%29%3Bspeed%3DisSUni%3Fspeed%3AnnUniS%28%29%2Cptks%5Bt%5D%3Dnew%20Ptk%28e%2Cr%2Cspeed%29%7DframeRate%2810%29%7Dfunction%20remake%28t%2Ce%29%7Bt%3DMath.ceil%28t%2FpxSz%29%2ApxSz%2Ce%3DMath.ceil%28e%2FpxSz%29%2ApxSz%2Cwd%3Dt%2Chei%3De%2Cwidth%3Dt%2Cheight%3De%2C%28img%3DcreateImage%28Math.floor%28wd%2FpxSz%29%2CMath.floor%28hei%2FpxSz%29%29%29.loadPixels%28%29%2CresizeCanvas%28t%2Ce%29%3Bfor%28let%20t%3D0%3Bt%3Czz%3Bt%2B%2B%29%7Bfor%28let%20t%3D0%3Bt%3Cptks.length%3Bt%2B%2B%29ptks%5Bt%5D.run%28%29%3BrunCount%2B%2B%7D%7Dfunction%20toggleFullscreen%28%29%7Blet%20t%3Ddocument.querySelector%28%22canvas%22%29%3Bdocument.fullscreenElement%3Fdocument.exitFullscreen%28%29%3A%28oldWd%3Dwd%2ColdHei%3Dhei%2Cremake%28800%2C960%29%2Ct.requestFullscreen%28%29.catch%28t%3D%3E%7Balert%28%60Error%3A%20%24%7Bt.message%7D%20%28%24%7Bt.name%7D%29%60%29%7D%29%29%7Dfunction%20keyPressed%28%29%7Breturn%2070%3D%3D%3DkeyCode%3F%28remake%281500%2C500%29%2C%211%29%3A88%3D%3D%3DkeyCode%3F%28remake%28prompt%28%22Enter%20width%20in%20pixels%22%2C%22500%22%29%2Cprompt%28%22Height%3F%22%2C%22500%22%29%29%2C%211%29%3A79%3D%3D%3DkeyCode%3F%28toggleFullscreen%28%29%2C%211%29%3Avoid%200%7Dfunction%20draw%28%29%7Bif%28%21didStart%29%7Bfor%28let%20t%3D0%3Bt%3Czz%3Bt%2B%2B%29%7Bfor%28let%20t%3D0%3Bt%3Cptks.length%3Bt%2B%2B%29ptks%5Bt%5D.run%28%29%3BrunCount%2B%2B%7DdidStart%3D%210%7Dfor%28let%20t%3D0%3Bt%3Cptks.length%3Bt%2B%2B%29ptks%5Bt%5D.run%28%29%3BrunCount%2B%2B%2C%28img%3DcreateImage%28wd%2FpxSz%2Chei%2FpxSz%29%29.loadPixels%28%29%3Bfor%28var%20t%3D0%3Bt%3Cimg.height%3Bt%2B%2B%29for%28var%20e%3D0%3Be%3Cimg.width%3Be%2B%2B%29%7Blet%20r%3Dget%28e%2ApxSz%2Ct%2ApxSz%29%2Ci%3D4%2A%28e%2Bt%2Aimg.width%29%3Bimg.pixels%5Bi%5D%3Dred%28r%29%2Cimg.pixels%5Bi%2B1%5D%3Dgreen%28r%29%2Cimg.pixels%5Bi%2B2%5D%3Dblue%28r%29%2Cimg.pixels%5Bi%2B3%5D%3Dalpha%28r%29%7Dfill%28bgc%29%2Crect%280%2C0%2Cwidth%2Cheight%29%2Cimg.updatePixels%28%29%2CnoSmooth%28%29%2Cimage%28img%2C0%2C0%2Cwidth%2Cheight%29%2Cfill%28bgc%29%2Crect%280%2C0%2Cborder%2Cheight%29%2Crect%280%2C0%2Cwidth%2Cborder%29%2Crect%28width-border%2C0%2Cborder%2Cheight%29%2Crect%280%2Cheight-border%2Cwidth%2Cborder%29%7Dclass%20Ptk%7Bconstructor%28t%2Ce%2Cr%29%7Bthis.loc%3Dt%2Cthis.dir%3De%2Cthis.speed%3Dr%2Cthis.c%3Dcolors%5BgRI%28colors.length%29%5D%2Cthis.lineSize%3DlnThk%7Drun%28%29%7Bthis.move%28%29%2Cthis.checkEdges%28%29%2Cthis.update%28%29%7Dmove%28%29%7Blet%20t%3Dnoise%28this.loc.x%2FnsScl%2Cthis.loc.y%2FnsScl%2CrunCount%2FnsScl%29%2ATWO_PI%2AnsStr%3Bthis.dir.x%3Dcos%28t%29%2Cthis.dir.y%3Dsin%28t%29%3Bvar%20e%3Dthis.dir.copy%28%29%3Be.mult%281%2Athis.speed%29%2Cthis.loc.add%28e%29%7DcheckEdges%28%29%7B%28this.loc.x%3Cborder%7C%7Cthis.loc.x%3Ewidth-border%7C%7Cthis.loc.y%3Cborder%7C%7Cthis.loc.y%3Eheight-border%29%26%26%28this.loc.x%3Dborder%2BgRI%28width-2%2Aborder%29%2Cthis.loc.y%3Dborder%2BgRI%28height-2%2Aborder%29%29%7Dupdate%28%29%7Bfill%28this.c%29%2Cellipse%28this.loc.x%2Cthis.loc.y%2Cthis.lineSize%2Cthis.lineSize%29%7D%7D%3C%2Fscript%3E%3C%2Fbody%3E%3C%2Fhtml%3E'
1647             )
1648         );
1649 
1650         return htmlString;
1651     }
1652 
1653     /**
1654      * @dev Hash to metadata function
1655      */
1656     function hashToMetadata(string memory _hash)
1657         public
1658         view
1659         returns (string memory)
1660     {
1661         string memory metadataString;
1662         
1663         uint8 paletteTraitIndex = AnonymiceLibrary.parseInt(
1664             AnonymiceLibrary.substring(_hash, 0, 2)
1665         );
1666 
1667         metadataString = string(
1668             abi.encodePacked(
1669                 metadataString,
1670                 '{"trait_type":"',
1671                 traitTypes[0][paletteTraitIndex].traitType,
1672                 '","value":"',
1673                 traitTypes[0][paletteTraitIndex].traitName,
1674                 '"},'
1675             )
1676         );
1677 
1678         for (uint8 i = 2; i < 11; i++) {
1679             uint8 thisTraitIndex = AnonymiceLibrary.parseInt(
1680                 AnonymiceLibrary.substring(_hash, i, i + 1)
1681             );
1682 
1683             metadataString = string(
1684                 abi.encodePacked(
1685                     metadataString,
1686                     '{"trait_type":"',
1687                     traitTypes[i][thisTraitIndex].traitType,
1688                     '","value":"',
1689                     traitTypes[i][thisTraitIndex].traitName,
1690                     '"}'
1691                 )
1692             );
1693 
1694             if (i != 10)
1695                 metadataString = string(abi.encodePacked(metadataString, ","));
1696         }
1697 
1698         return string(abi.encodePacked("[", metadataString, "]"));
1699     }
1700 
1701     /**
1702      * @dev Returns the SVG and metadata for a token Id
1703      * @param _tokenId The tokenId to return the SVG and metadata for.
1704      */
1705     function tokenURI(uint256 _tokenId)
1706         public
1707         view
1708         override
1709         returns (string memory)
1710     {
1711         require(_exists(_tokenId));
1712 
1713         string memory tokenHash = _tokenIdToHash(_tokenId);
1714         
1715         string memory description = '", "description": "Filaments is a collection of 500 unique pieces of generative pixel art. Metadata and art is mirrored permanently on-chain. Double click to full screen. Press F then right-click and save as a banner.",';
1716         
1717         return
1718             string(
1719                 abi.encodePacked(
1720                     "data:application/json;base64,",
1721                     AnonymiceLibrary.encode(
1722                         bytes(
1723                             string(
1724                                 abi.encodePacked(
1725                                     '{"name": "Filaments #',
1726                                     AnonymiceLibrary.toString(_tokenId),
1727                                     description,
1728                                     '"animation_url": "',
1729                                     animationUrl,
1730                                     AnonymiceLibrary.toString(_tokenId),
1731                                     '","image":"',
1732                                     imageUrl,
1733                                     AnonymiceLibrary.toString(_tokenId),
1734                                     '","attributes":',
1735                                     hashToMetadata(tokenHash),
1736                                     "}"
1737                                 )
1738                             )
1739                         )
1740                     )
1741                 )
1742             );
1743     }
1744 
1745     /**
1746      * @dev Returns a hash for a given tokenId
1747      * @param _tokenId The tokenId to return the hash for.
1748      */
1749     function _tokenIdToHash(uint256 _tokenId)
1750         public
1751         view
1752         returns (string memory)
1753     {
1754         string memory tokenHash = tokenIdToHash[_tokenId];
1755 
1756         return tokenHash;
1757     }
1758 
1759     /*
1760 
1761   ___   __    __  ____     ___  ____       _____  __ __  ____     __ ______  ____  ___   ____   _____
1762  /   \ |  |__|  ||    \   /  _]|    \     |     ||  |  ||    \   /  ]      ||    |/   \ |    \ / ___/
1763 |     ||  |  |  ||  _  | /  [_ |  D  )    |   __||  |  ||  _  | /  /|      | |  ||     ||  _  (   \_ 
1764 |  O  ||  |  |  ||  |  ||    _]|    /     |  |_  |  |  ||  |  |/  / |_|  |_| |  ||  O  ||  |  |\__  |
1765 |     ||  `  '  ||  |  ||   [_ |    \     |   _] |  :  ||  |  /   \_  |  |   |  ||     ||  |  |/  \ |
1766 |     | \      / |  |  ||     ||  .  \    |  |   |     ||  |  \     | |  |   |  ||     ||  |  |\    |
1767  \___/   \_/\_/  |__|__||_____||__|\_|    |__|    \__,_||__|__|\____| |__|  |____|\___/ |__|__| \___|
1768                                                                                                      
1769 
1770 
1771     */
1772     
1773     /**
1774      * @dev Clears the traits.
1775      */
1776     function clearTraits() public onlyOwner {
1777         for (uint256 i = 0; i < 11; i++) {
1778             delete traitTypes[i];
1779         }
1780     }
1781     
1782     /**
1783      * @dev Batch adds addresses to whitelist
1784      */
1785     function batchWhitelist(address[] memory _users) public onlyOwner {
1786         uint size = _users.length;
1787         
1788         for (uint256 i=0; i< size; i++){
1789           address user = _users[i];
1790           whitelist[user] = true;
1791         }
1792         
1793         numWhitelisted += _users.length;
1794     }
1795 
1796     /**
1797      * @dev Add a trait type
1798      * @param _traitTypeIndex The trait type index
1799      * @param traits Array of traits to add
1800      */
1801 
1802     function addTraitType(uint256 _traitTypeIndex, Trait[] memory traits)
1803         public
1804         onlyOwner
1805     {
1806         for (uint256 i = 0; i < traits.length; i++) {
1807             traitTypes[_traitTypeIndex].push(
1808                 Trait(
1809                     traits[i].traitName,
1810                     traits[i].traitType
1811                 )
1812             );
1813         }
1814 
1815         return;
1816     }
1817     
1818     /**
1819      * @dev Mint for burn
1820      */
1821     function ownerMintForBurn() public onlyOwner {
1822         uint256 _totalSupply = totalSupply();
1823         require(_totalSupply < MAX_SUPPLY);
1824         require(!AnonymiceLibrary.isContract(msg.sender));
1825 
1826         uint256 thisTokenId = _totalSupply;
1827 
1828         tokenIdToHash[thisTokenId] = hash(thisTokenId, msg.sender, 0);
1829 
1830         hashToMinted[tokenIdToHash[thisTokenId]] = true;
1831 
1832         _mint(0x000000000000000000000000000000000000dEaD, thisTokenId);
1833     }
1834     
1835     function flipMintingSwitch() public onlyOwner {
1836         MINTING_LIVE = !MINTING_LIVE;
1837     }
1838 
1839     /**
1840      * @dev Sets the p5js url
1841      * @param _p5jsUrl The address of the p5js file hosted on CDN
1842      */
1843 
1844     function setJsAddress(string memory _p5jsUrl) public onlyOwner {
1845         p5jsUrl = _p5jsUrl;
1846     }
1847 
1848     /**
1849      * @dev Sets the p5js resource integrity
1850      * @param _p5jsIntegrity The hash of the p5js file (to protect w subresource integrity)
1851      */
1852 
1853     function setJsIntegrity(string memory _p5jsIntegrity) public onlyOwner {
1854         p5jsIntegrity = _p5jsIntegrity;
1855     }
1856     
1857     /**
1858      * @dev Sets the base image url
1859      * @param _imageUrl The base url for image field
1860      */
1861 
1862     function setImageUrl(string memory _imageUrl) public onlyOwner {
1863         imageUrl = _imageUrl;
1864     }
1865     
1866     /**
1867      * @dev Sets the base animation url
1868      * @param _animationUrl The base url for animations
1869      */
1870 
1871     function setAnimationUrl(string memory _animationUrl) public onlyOwner {
1872         animationUrl = _animationUrl;
1873     }
1874 }