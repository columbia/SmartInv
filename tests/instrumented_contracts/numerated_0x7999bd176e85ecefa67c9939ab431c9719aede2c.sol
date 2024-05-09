1 // File: @openzeppelin/contracts/utils/Base64.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Base64.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides a set of functions to operate with Base64 strings.
10  *
11  * _Available since v4.5._
12  */
13 library Base64 {
14     /**
15      * @dev Base64 Encoding/Decoding Table
16      */
17     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
18 
19     /**
20      * @dev Converts a `bytes` to its Bytes64 `string` representation.
21      */
22     function encode(bytes memory data) internal pure returns (string memory) {
23         /**
24          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
25          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
26          */
27         if (data.length == 0) return "";
28 
29         // Loads the table into memory
30         string memory table = _TABLE;
31 
32         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
33         // and split into 4 numbers of 6 bits.
34         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
35         // - `data.length + 2`  -> Round up
36         // - `/ 3`              -> Number of 3-bytes chunks
37         // - `4 *`              -> 4 characters for each chunk
38         string memory result = new string(4 * ((data.length + 2) / 3));
39 
40         assembly {
41             // Prepare the lookup table (skip the first "length" byte)
42             let tablePtr := add(table, 1)
43 
44             // Prepare result pointer, jump over length
45             let resultPtr := add(result, 32)
46 
47             // Run over the input, 3 bytes at a time
48             for {
49                 let dataPtr := data
50                 let endPtr := add(data, mload(data))
51             } lt(dataPtr, endPtr) {
52 
53             } {
54                 // Advance 3 bytes
55                 dataPtr := add(dataPtr, 3)
56                 let input := mload(dataPtr)
57 
58                 // To write each character, shift the 3 bytes (18 bits) chunk
59                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
60                 // and apply logical AND with 0x3F which is the number of
61                 // the previous character in the ASCII table prior to the Base64 Table
62                 // The result is then added to the table to get the character to write,
63                 // and finally write it in the result pointer but with a left shift
64                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
65 
66                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
67                 resultPtr := add(resultPtr, 1) // Advance
68 
69                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
70                 resultPtr := add(resultPtr, 1) // Advance
71 
72                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
73                 resultPtr := add(resultPtr, 1) // Advance
74 
75                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
76                 resultPtr := add(resultPtr, 1) // Advance
77             }
78 
79             // When data `bytes` is not exactly 3 bytes long
80             // it is padded with `=` characters at the end
81             switch mod(mload(data), 3)
82             case 1 {
83                 mstore8(sub(resultPtr, 1), 0x3d)
84                 mstore8(sub(resultPtr, 2), 0x3d)
85             }
86             case 2 {
87                 mstore8(sub(resultPtr, 1), 0x3d)
88             }
89         }
90 
91         return result;
92     }
93 }
94 
95 // File: @openzeppelin/contracts/utils/Strings.sol
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev String operations.
104  */
105 library Strings {
106     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
110      */
111     function toString(uint256 value) internal pure returns (string memory) {
112         // Inspired by OraclizeAPI's implementation - MIT licence
113         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
114 
115         if (value == 0) {
116             return "0";
117         }
118         uint256 temp = value;
119         uint256 digits;
120         while (temp != 0) {
121             digits++;
122             temp /= 10;
123         }
124         bytes memory buffer = new bytes(digits);
125         while (value != 0) {
126             digits -= 1;
127             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
128             value /= 10;
129         }
130         return string(buffer);
131     }
132 
133     /**
134      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
135      */
136     function toHexString(uint256 value) internal pure returns (string memory) {
137         if (value == 0) {
138             return "0x00";
139         }
140         uint256 temp = value;
141         uint256 length = 0;
142         while (temp != 0) {
143             length++;
144             temp >>= 8;
145         }
146         return toHexString(value, length);
147     }
148 
149     /**
150      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
151      */
152     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
153         bytes memory buffer = new bytes(2 * length + 2);
154         buffer[0] = "0";
155         buffer[1] = "x";
156         for (uint256 i = 2 * length + 1; i > 1; --i) {
157             buffer[i] = _HEX_SYMBOLS[value & 0xf];
158             value >>= 4;
159         }
160         require(value == 0, "Strings: hex length insufficient");
161         return string(buffer);
162     }
163 }
164 
165 // File: @openzeppelin/contracts/utils/Context.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @dev Provides information about the current execution context, including the
174  * sender of the transaction and its data. While these are generally available
175  * via msg.sender and msg.data, they should not be accessed in such a direct
176  * manner, since when dealing with meta-transactions the account sending and
177  * paying for execution may not be the actual sender (as far as an application
178  * is concerned).
179  *
180  * This contract is only required for intermediate, library-like contracts.
181  */
182 abstract contract Context {
183     function _msgSender() internal view virtual returns (address) {
184         return msg.sender;
185     }
186 
187     function _msgData() internal view virtual returns (bytes calldata) {
188         return msg.data;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Address.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Collection of functions related to the address type
201  */
202 library Address {
203     /**
204      * @dev Returns true if `account` is a contract.
205      *
206      * [IMPORTANT]
207      * ====
208      * It is unsafe to assume that an address for which this function returns
209      * false is an externally-owned account (EOA) and not a contract.
210      *
211      * Among others, `isContract` will return false for the following
212      * types of addresses:
213      *
214      *  - an externally-owned account
215      *  - a contract in construction
216      *  - an address where a contract will be created
217      *  - an address where a contract lived, but was destroyed
218      * ====
219      */
220     function isContract(address account) internal view returns (bool) {
221         // This method relies on extcodesize, which returns 0 for contracts in
222         // construction, since the code is only stored at the end of the
223         // constructor execution.
224 
225         uint256 size;
226         assembly {
227             size := extcodesize(account)
228         }
229         return size > 0;
230     }
231 
232     /**
233      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
234      * `recipient`, forwarding all available gas and reverting on errors.
235      *
236      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
237      * of certain opcodes, possibly making contracts go over the 2300 gas limit
238      * imposed by `transfer`, making them unable to receive funds via
239      * `transfer`. {sendValue} removes this limitation.
240      *
241      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
242      *
243      * IMPORTANT: because control is transferred to `recipient`, care must be
244      * taken to not create reentrancy vulnerabilities. Consider using
245      * {ReentrancyGuard} or the
246      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
247      */
248     function sendValue(address payable recipient, uint256 amount) internal {
249         require(address(this).balance >= amount, "Address: insufficient balance");
250 
251         (bool success, ) = recipient.call{value: amount}("");
252         require(success, "Address: unable to send value, recipient may have reverted");
253     }
254 
255     /**
256      * @dev Performs a Solidity function call using a low level `call`. A
257      * plain `call` is an unsafe replacement for a function call: use this
258      * function instead.
259      *
260      * If `target` reverts with a revert reason, it is bubbled up by this
261      * function (like regular Solidity function calls).
262      *
263      * Returns the raw returned data. To convert to the expected return value,
264      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
265      *
266      * Requirements:
267      *
268      * - `target` must be a contract.
269      * - calling `target` with `data` must not revert.
270      *
271      * _Available since v3.1._
272      */
273     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
274         return functionCall(target, data, "Address: low-level call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
279      * `errorMessage` as a fallback revert reason when `target` reverts.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         return functionCallWithValue(target, data, 0, errorMessage);
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
293      * but also transferring `value` wei to `target`.
294      *
295      * Requirements:
296      *
297      * - the calling contract must have an ETH balance of at least `value`.
298      * - the called Solidity function must be `payable`.
299      *
300      * _Available since v3.1._
301      */
302     function functionCallWithValue(
303         address target,
304         bytes memory data,
305         uint256 value
306     ) internal returns (bytes memory) {
307         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
312      * with `errorMessage` as a fallback revert reason when `target` reverts.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(
317         address target,
318         bytes memory data,
319         uint256 value,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         require(address(this).balance >= value, "Address: insufficient balance for call");
323         require(isContract(target), "Address: call to non-contract");
324 
325         (bool success, bytes memory returndata) = target.call{value: value}(data);
326         return verifyCallResult(success, returndata, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but performing a static call.
332      *
333      * _Available since v3.3._
334      */
335     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
336         return functionStaticCall(target, data, "Address: low-level static call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
341      * but performing a static call.
342      *
343      * _Available since v3.3._
344      */
345     function functionStaticCall(
346         address target,
347         bytes memory data,
348         string memory errorMessage
349     ) internal view returns (bytes memory) {
350         require(isContract(target), "Address: static call to non-contract");
351 
352         (bool success, bytes memory returndata) = target.staticcall(data);
353         return verifyCallResult(success, returndata, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
363         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(
373         address target,
374         bytes memory data,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(isContract(target), "Address: delegate call to non-contract");
378 
379         (bool success, bytes memory returndata) = target.delegatecall(data);
380         return verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     /**
384      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
385      * revert reason using the provided one.
386      *
387      * _Available since v4.3._
388      */
389     function verifyCallResult(
390         bool success,
391         bytes memory returndata,
392         string memory errorMessage
393     ) internal pure returns (bytes memory) {
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400 
401                 assembly {
402                     let returndata_size := mload(returndata)
403                     revert(add(32, returndata), returndata_size)
404                 }
405             } else {
406                 revert(errorMessage);
407             }
408         }
409     }
410 }
411 
412 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
413 
414 
415 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 /**
420  * @title ERC721 token receiver interface
421  * @dev Interface for any contract that wants to support safeTransfers
422  * from ERC721 asset contracts.
423  */
424 interface IERC721Receiver {
425     /**
426      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
427      * by `operator` from `from`, this function is called.
428      *
429      * It must return its Solidity selector to confirm the token transfer.
430      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
431      *
432      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
433      */
434     function onERC721Received(
435         address operator,
436         address from,
437         uint256 tokenId,
438         bytes calldata data
439     ) external returns (bytes4);
440 }
441 
442 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
443 
444 
445 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Interface of the ERC165 standard, as defined in the
451  * https://eips.ethereum.org/EIPS/eip-165[EIP].
452  *
453  * Implementers can declare support of contract interfaces, which can then be
454  * queried by others ({ERC165Checker}).
455  *
456  * For an implementation, see {ERC165}.
457  */
458 interface IERC165 {
459     /**
460      * @dev Returns true if this contract implements the interface defined by
461      * `interfaceId`. See the corresponding
462      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
463      * to learn more about how these ids are created.
464      *
465      * This function call must use less than 30 000 gas.
466      */
467     function supportsInterface(bytes4 interfaceId) external view returns (bool);
468 }
469 
470 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 
478 /**
479  * @dev Implementation of the {IERC165} interface.
480  *
481  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
482  * for the additional interface id that will be supported. For example:
483  *
484  * ```solidity
485  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
487  * }
488  * ```
489  *
490  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
491  */
492 abstract contract ERC165 is IERC165 {
493     /**
494      * @dev See {IERC165-supportsInterface}.
495      */
496     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
497         return interfaceId == type(IERC165).interfaceId;
498     }
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @dev Required interface of an ERC721 compliant contract.
511  */
512 interface IERC721 is IERC165 {
513     /**
514      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
515      */
516     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
517 
518     /**
519      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
520      */
521     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
522 
523     /**
524      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
525      */
526     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
527 
528     /**
529      * @dev Returns the number of tokens in ``owner``'s account.
530      */
531     function balanceOf(address owner) external view returns (uint256 balance);
532 
533     /**
534      * @dev Returns the owner of the `tokenId` token.
535      *
536      * Requirements:
537      *
538      * - `tokenId` must exist.
539      */
540     function ownerOf(uint256 tokenId) external view returns (address owner);
541 
542     /**
543      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
544      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
545      *
546      * Requirements:
547      *
548      * - `from` cannot be the zero address.
549      * - `to` cannot be the zero address.
550      * - `tokenId` token must exist and be owned by `from`.
551      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
552      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
553      *
554      * Emits a {Transfer} event.
555      */
556     function safeTransferFrom(
557         address from,
558         address to,
559         uint256 tokenId
560     ) external;
561 
562     /**
563      * @dev Transfers `tokenId` token from `from` to `to`.
564      *
565      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must be owned by `from`.
572      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
573      *
574      * Emits a {Transfer} event.
575      */
576     function transferFrom(
577         address from,
578         address to,
579         uint256 tokenId
580     ) external;
581 
582     /**
583      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
584      * The approval is cleared when the token is transferred.
585      *
586      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
587      *
588      * Requirements:
589      *
590      * - The caller must own the token or be an approved operator.
591      * - `tokenId` must exist.
592      *
593      * Emits an {Approval} event.
594      */
595     function approve(address to, uint256 tokenId) external;
596 
597     /**
598      * @dev Returns the account approved for `tokenId` token.
599      *
600      * Requirements:
601      *
602      * - `tokenId` must exist.
603      */
604     function getApproved(uint256 tokenId) external view returns (address operator);
605 
606     /**
607      * @dev Approve or remove `operator` as an operator for the caller.
608      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
609      *
610      * Requirements:
611      *
612      * - The `operator` cannot be the caller.
613      *
614      * Emits an {ApprovalForAll} event.
615      */
616     function setApprovalForAll(address operator, bool _approved) external;
617 
618     /**
619      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
620      *
621      * See {setApprovalForAll}
622      */
623     function isApprovedForAll(address owner, address operator) external view returns (bool);
624 
625     /**
626      * @dev Safely transfers `tokenId` token from `from` to `to`.
627      *
628      * Requirements:
629      *
630      * - `from` cannot be the zero address.
631      * - `to` cannot be the zero address.
632      * - `tokenId` token must exist and be owned by `from`.
633      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
634      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
635      *
636      * Emits a {Transfer} event.
637      */
638     function safeTransferFrom(
639         address from,
640         address to,
641         uint256 tokenId,
642         bytes calldata data
643     ) external;
644 }
645 
646 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
647 
648 
649 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
650 
651 pragma solidity ^0.8.0;
652 
653 
654 /**
655  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
656  * @dev See https://eips.ethereum.org/EIPS/eip-721
657  */
658 interface IERC721Metadata is IERC721 {
659     /**
660      * @dev Returns the token collection name.
661      */
662     function name() external view returns (string memory);
663 
664     /**
665      * @dev Returns the token collection symbol.
666      */
667     function symbol() external view returns (string memory);
668 
669     /**
670      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
671      */
672     function tokenURI(uint256 tokenId) external view returns (string memory);
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 
683 
684 
685 
686 
687 
688 
689 /**
690  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
691  * the Metadata extension, but not including the Enumerable extension, which is available separately as
692  * {ERC721Enumerable}.
693  */
694 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
695     using Address for address;
696     using Strings for uint256;
697 
698     // Token name
699     string private _name;
700 
701     // Token symbol
702     string private _symbol;
703 
704     // Mapping from token ID to owner address
705     mapping(uint256 => address) private _owners;
706 
707     // Mapping owner address to token count
708     mapping(address => uint256) private _balances;
709 
710     // Mapping from token ID to approved address
711     mapping(uint256 => address) private _tokenApprovals;
712 
713     // Mapping from owner to operator approvals
714     mapping(address => mapping(address => bool)) private _operatorApprovals;
715 
716     /**
717      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
718      */
719     constructor(string memory name_, string memory symbol_) {
720         _name = name_;
721         _symbol = symbol_;
722     }
723 
724     /**
725      * @dev See {IERC165-supportsInterface}.
726      */
727     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
728         return
729             interfaceId == type(IERC721).interfaceId ||
730             interfaceId == type(IERC721Metadata).interfaceId ||
731             super.supportsInterface(interfaceId);
732     }
733 
734     /**
735      * @dev See {IERC721-balanceOf}.
736      */
737     function balanceOf(address owner) public view virtual override returns (uint256) {
738         require(owner != address(0), "ERC721: balance query for the zero address");
739         return _balances[owner];
740     }
741 
742     /**
743      * @dev See {IERC721-ownerOf}.
744      */
745     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
746         address owner = _owners[tokenId];
747         require(owner != address(0), "ERC721: owner query for nonexistent token");
748         return owner;
749     }
750 
751     /**
752      * @dev See {IERC721Metadata-name}.
753      */
754     function name() public view virtual override returns (string memory) {
755         return _name;
756     }
757 
758     /**
759      * @dev See {IERC721Metadata-symbol}.
760      */
761     function symbol() public view virtual override returns (string memory) {
762         return _symbol;
763     }
764 
765     /**
766      * @dev See {IERC721Metadata-tokenURI}.
767      */
768     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
769         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
770 
771         string memory baseURI = _baseURI();
772         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
773     }
774 
775     /**
776      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
777      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
778      * by default, can be overriden in child contracts.
779      */
780     function _baseURI() internal view virtual returns (string memory) {
781         return "";
782     }
783 
784     /**
785      * @dev See {IERC721-approve}.
786      */
787     function approve(address to, uint256 tokenId) public virtual override {
788         address owner = ERC721.ownerOf(tokenId);
789         require(to != owner, "ERC721: approval to current owner");
790 
791         require(
792             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
793             "ERC721: approve caller is not owner nor approved for all"
794         );
795 
796         _approve(to, tokenId);
797     }
798 
799     /**
800      * @dev See {IERC721-getApproved}.
801      */
802     function getApproved(uint256 tokenId) public view virtual override returns (address) {
803         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
804 
805         return _tokenApprovals[tokenId];
806     }
807 
808     /**
809      * @dev See {IERC721-setApprovalForAll}.
810      */
811     function setApprovalForAll(address operator, bool approved) public virtual override {
812         _setApprovalForAll(_msgSender(), operator, approved);
813     }
814 
815     /**
816      * @dev See {IERC721-isApprovedForAll}.
817      */
818     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
819         return _operatorApprovals[owner][operator];
820     }
821 
822     /**
823      * @dev See {IERC721-transferFrom}.
824      */
825     function transferFrom(
826         address from,
827         address to,
828         uint256 tokenId
829     ) public virtual override {
830         //solhint-disable-next-line max-line-length
831         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
832 
833         _transfer(from, to, tokenId);
834     }
835 
836     /**
837      * @dev See {IERC721-safeTransferFrom}.
838      */
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) public virtual override {
844         safeTransferFrom(from, to, tokenId, "");
845     }
846 
847     /**
848      * @dev See {IERC721-safeTransferFrom}.
849      */
850     function safeTransferFrom(
851         address from,
852         address to,
853         uint256 tokenId,
854         bytes memory _data
855     ) public virtual override {
856         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
857         _safeTransfer(from, to, tokenId, _data);
858     }
859 
860     /**
861      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
862      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
863      *
864      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
865      *
866      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
867      * implement alternative mechanisms to perform token transfer, such as signature-based.
868      *
869      * Requirements:
870      *
871      * - `from` cannot be the zero address.
872      * - `to` cannot be the zero address.
873      * - `tokenId` token must exist and be owned by `from`.
874      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _safeTransfer(
879         address from,
880         address to,
881         uint256 tokenId,
882         bytes memory _data
883     ) internal virtual {
884         _transfer(from, to, tokenId);
885         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
886     }
887 
888     /**
889      * @dev Returns whether `tokenId` exists.
890      *
891      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
892      *
893      * Tokens start existing when they are minted (`_mint`),
894      * and stop existing when they are burned (`_burn`).
895      */
896     function _exists(uint256 tokenId) internal view virtual returns (bool) {
897         return _owners[tokenId] != address(0);
898     }
899 
900     /**
901      * @dev Returns whether `spender` is allowed to manage `tokenId`.
902      *
903      * Requirements:
904      *
905      * - `tokenId` must exist.
906      */
907     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
908         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
909         address owner = ERC721.ownerOf(tokenId);
910         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
911     }
912 
913     /**
914      * @dev Safely mints `tokenId` and transfers it to `to`.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must not exist.
919      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _safeMint(address to, uint256 tokenId) internal virtual {
924         _safeMint(to, tokenId, "");
925     }
926 
927     /**
928      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
929      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
930      */
931     function _safeMint(
932         address to,
933         uint256 tokenId,
934         bytes memory _data
935     ) internal virtual {
936         _mint(to, tokenId);
937         require(
938             _checkOnERC721Received(address(0), to, tokenId, _data),
939             "ERC721: transfer to non ERC721Receiver implementer"
940         );
941     }
942 
943     /**
944      * @dev Mints `tokenId` and transfers it to `to`.
945      *
946      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
947      *
948      * Requirements:
949      *
950      * - `tokenId` must not exist.
951      * - `to` cannot be the zero address.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _mint(address to, uint256 tokenId) internal virtual {
956         require(to != address(0), "ERC721: mint to the zero address");
957         require(!_exists(tokenId), "ERC721: token already minted");
958 
959         _beforeTokenTransfer(address(0), to, tokenId);
960 
961         _balances[to] += 1;
962         _owners[tokenId] = to;
963 
964         emit Transfer(address(0), to, tokenId);
965     }
966 
967     /**
968      * @dev Destroys `tokenId`.
969      * The approval is cleared when the token is burned.
970      *
971      * Requirements:
972      *
973      * - `tokenId` must exist.
974      *
975      * Emits a {Transfer} event.
976      */
977     function _burn(uint256 tokenId) internal virtual {
978         address owner = ERC721.ownerOf(tokenId);
979 
980         _beforeTokenTransfer(owner, address(0), tokenId);
981 
982         // Clear approvals
983         _approve(address(0), tokenId);
984 
985         _balances[owner] -= 1;
986         delete _owners[tokenId];
987 
988         emit Transfer(owner, address(0), tokenId);
989     }
990 
991     /**
992      * @dev Transfers `tokenId` from `from` to `to`.
993      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
994      *
995      * Requirements:
996      *
997      * - `to` cannot be the zero address.
998      * - `tokenId` token must be owned by `from`.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _transfer(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) internal virtual {
1007         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1008         require(to != address(0), "ERC721: transfer to the zero address");
1009 
1010         _beforeTokenTransfer(from, to, tokenId);
1011 
1012         // Clear approvals from the previous owner
1013         _approve(address(0), tokenId);
1014 
1015         _balances[from] -= 1;
1016         _balances[to] += 1;
1017         _owners[tokenId] = to;
1018 
1019         emit Transfer(from, to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev Approve `to` to operate on `tokenId`
1024      *
1025      * Emits a {Approval} event.
1026      */
1027     function _approve(address to, uint256 tokenId) internal virtual {
1028         _tokenApprovals[tokenId] = to;
1029         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1030     }
1031 
1032     /**
1033      * @dev Approve `operator` to operate on all of `owner` tokens
1034      *
1035      * Emits a {ApprovalForAll} event.
1036      */
1037     function _setApprovalForAll(
1038         address owner,
1039         address operator,
1040         bool approved
1041     ) internal virtual {
1042         require(owner != operator, "ERC721: approve to caller");
1043         _operatorApprovals[owner][operator] = approved;
1044         emit ApprovalForAll(owner, operator, approved);
1045     }
1046 
1047     /**
1048      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1049      * The call is not executed if the target address is not a contract.
1050      *
1051      * @param from address representing the previous owner of the given token ID
1052      * @param to target address that will receive the tokens
1053      * @param tokenId uint256 ID of the token to be transferred
1054      * @param _data bytes optional data to send along with the call
1055      * @return bool whether the call correctly returned the expected magic value
1056      */
1057     function _checkOnERC721Received(
1058         address from,
1059         address to,
1060         uint256 tokenId,
1061         bytes memory _data
1062     ) private returns (bool) {
1063         if (to.isContract()) {
1064             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1065                 return retval == IERC721Receiver.onERC721Received.selector;
1066             } catch (bytes memory reason) {
1067                 if (reason.length == 0) {
1068                     revert("ERC721: transfer to non ERC721Receiver implementer");
1069                 } else {
1070                     assembly {
1071                         revert(add(32, reason), mload(reason))
1072                     }
1073                 }
1074             }
1075         } else {
1076             return true;
1077         }
1078     }
1079 
1080     /**
1081      * @dev Hook that is called before any token transfer. This includes minting
1082      * and burning.
1083      *
1084      * Calling conditions:
1085      *
1086      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1087      * transferred to `to`.
1088      * - When `from` is zero, `tokenId` will be minted for `to`.
1089      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1090      * - `from` and `to` are never both zero.
1091      *
1092      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1093      */
1094     function _beforeTokenTransfer(
1095         address from,
1096         address to,
1097         uint256 tokenId
1098     ) internal virtual {}
1099 }
1100 
1101 // File: contracts/primitives.sol
1102 
1103 
1104 
1105 pragma solidity >=0.8.13;
1106 
1107 
1108 
1109 
1110 contract RawPrimitives is ERC721
1111 {    
1112     uint public constant COLLECION_SIZE = 6969;
1113 
1114     uint public totalSupply;
1115 
1116     constructor() ERC721("Raw Primitives", "RAWP")
1117     {
1118         for (uint i = 0; i < 69; ++i)
1119         {
1120             mint();
1121         }                
1122     }
1123 
1124     function mint() public 
1125     {
1126         require(totalSupply < COLLECION_SIZE, "Can't exceed the collection size");
1127 
1128         _mint(msg.sender, ++totalSupply);
1129     }
1130 
1131     function tokenURI(uint token) public pure override(ERC721) returns(string memory encoded_metadata)
1132     {
1133         encoded_metadata = string(abi.encodePacked("data:application/json;base64,", metadataJson(token)));
1134     }
1135 
1136     function metadataJson(uint token) public pure returns(string memory metadata)
1137     {
1138         string memory image;
1139         string[] memory attributes;
1140 
1141         (image, attributes) = getImage(token);
1142 
1143         string[] memory entries = new string[](attributes.length);
1144 
1145         for (uint i = 0; i < attributes.length; ++i)
1146         {
1147             entries[i] = string(abi.encodePacked("{\"trait_type\":\"element\",\"value\":\"",attributes[i],"\"}"));            
1148         }
1149 
1150         string memory attributesJson = "[";
1151         for (uint i = 0; i < entries.length; ++i)
1152         {
1153             if (i == 0)
1154             {
1155                 attributesJson = string(abi.encodePacked(attributesJson,entries[i]));
1156             }
1157             else 
1158             {
1159                 attributesJson = string(abi.encodePacked(attributesJson,",",entries[i]));
1160             }
1161         }
1162         attributesJson = string(abi.encodePacked(attributesJson,"]"));
1163 
1164         metadata = Base64.encode(
1165             abi.encodePacked(
1166                 "{\"image\": \"", image, "\", \"name\":\"Primitive #", Strings.toString(token) ,"\", \"description\":\"Fully onchain generative art in raster(BMP) format.\",\"attributes\":",attributesJson,"}"));
1167     }
1168 
1169     function getImage(uint token) public pure returns(string memory image, string[] memory attributes)
1170     {        
1171         bytes memory header = hex""
1172         hex"424D"
1173         hex"00000000" 
1174         hex"00000000"
1175         hex"36000000"
1176 
1177         hex"28000000"
1178         hex"ff000000"
1179         hex"ff000000"
1180         hex"0100"
1181         hex"1000"
1182         hex"00000000"
1183         hex"00000000"
1184         hex"00000000"
1185         hex"00000000"
1186         hex"00000000"
1187         hex"00000000"
1188         hex""; 
1189 
1190         bytes memory imageBytes;        
1191 
1192         (imageBytes, attributes) = getContentBytes(token);
1193         image = string(abi.encodePacked("data:image/bmp;base64,", Base64.encode(abi.encodePacked(header, imageBytes))));
1194     }
1195 
1196     function getContentBytes(uint token) public pure returns(bytes memory content, string[] memory attributes)
1197     {
1198         content = new bytes(256 * 256 * 2);                
1199 
1200         bytes1 c1;
1201         bytes1 c2;
1202         string memory color;
1203 
1204         uint seed = uint(keccak256(abi.encodePacked(token)));     
1205 
1206         (c1, c2, color) = getColorBytes(seed);
1207         setBackground(content, c1, c2);
1208 
1209         seed = seed >> 2;                
1210 
1211         uint n  = seed % 10;
1212 
1213         attributes = new string[](n+1);
1214         attributes[0] = string(abi.encodePacked(color, " background"));
1215 
1216         for (uint i = 0; i < n; ++i)
1217         {
1218             seed = seed >> 1;
1219 
1220             uint choice = seed % 4;                   
1221 
1222             (c1, c2, color) = getColorBytes(seed);
1223 
1224             if (choice < 1) 
1225             {                
1226                 attributes[i+1] = string(abi.encodePacked(color, " noise"));
1227                 addNoise(content, seed, c1, c2);
1228             }
1229             else if (choice < 2)
1230             {
1231                 attributes[i+1] = string(abi.encodePacked(color, " rectangle"));
1232                 addRectangle(content, seed, c1, c2);
1233             }
1234             else if (choice < 3)
1235             {
1236                 attributes[i+1] = string(abi.encodePacked(color, " vertical"));
1237                 addVertical(content, seed, c1, c2);
1238             }
1239             else if (choice < 4)
1240             {
1241                 attributes[i+1] = string(abi.encodePacked(color, " horizontal"));
1242                 addHorizontal(content, seed, c1, c2);
1243             }
1244         }
1245     }
1246 
1247     function addHorizontal(bytes memory content, uint seed, bytes1 c1, bytes1 c2) private pure
1248     {
1249         bytes32 params = keccak256(abi.encodePacked("rect", seed));
1250 
1251         uint8 y = uint8(params[0]);
1252         uint8 w = (uint8(params[1]) % 5) + 1;
1253         
1254         uint8 bottomBorder = y > w ? y - w : 0;
1255         uint8 topBorder = 255 - y > w? y + w : 255;
1256         
1257         for (uint16 xi = 0; xi < 256; ++xi)
1258         {
1259             for (uint8 yi = bottomBorder; yi <= topBorder; ++yi)
1260             {
1261                 uint flat = centricToFlat(xi,yi);
1262                 content[flat] = c1;
1263                 content[flat+1] = c2;
1264             }
1265         }
1266     }
1267 
1268     function addVertical(bytes memory content, uint seed, bytes1 c1, bytes1 c2) private pure
1269     {
1270         bytes32 params = keccak256(abi.encodePacked("rect", seed));
1271 
1272         uint8 x = uint8(params[0]);
1273         uint8 w = (uint8(params[1]) % 5) + 1;
1274         
1275         uint8 leftBorder = x > w ? x - w : 0;
1276         uint8 rightBorder = 255 - x > w? x + w : 255;
1277         
1278         for (uint16 yi = 0; yi < 256; ++yi)
1279         {
1280             for (uint8 xi = leftBorder; xi <= rightBorder; ++xi)
1281             {
1282                 uint flat = centricToFlat(xi,yi);
1283                 content[flat] = c1;
1284                 content[flat+1] = c2;
1285             }
1286         }
1287     }
1288 
1289     function addRectangle(bytes memory content, uint seed, bytes1 c1, bytes1 c2) private pure
1290     {
1291         bytes32 params = keccak256(abi.encodePacked("rect", seed));
1292 
1293         uint8 x = uint8(params[0]);
1294         uint8 y = uint8(params[1]);
1295         uint8 w = uint8(params[2]);
1296         uint8 h = uint8(params[3]);
1297 
1298         for (uint yi = 0; yi < h; ++yi)
1299         {
1300             if (yi + y > 255) break;
1301 
1302             for (uint xi = 0; xi < w; ++xi)
1303             {
1304                 if (x + xi > 255) break;
1305 
1306                 uint flat = centricToFlat(xi,yi);
1307                 content[flat] = c1;
1308                 content[flat+1] = c2;
1309             }
1310 
1311         }
1312     }
1313 
1314     function addNoise(bytes memory content, uint seed, bytes1 c1, bytes1 c2) private pure
1315     {
1316         bytes32 xs = keccak256(abi.encodePacked("xs", seed));
1317         bytes32 ys = keccak256(abi.encodePacked("ys", seed));
1318 
1319         for (uint i = 0; i < 31; ++i)
1320         {
1321             uint8 x = uint8(xs[i]);
1322             uint8 y = uint8(ys[i]);
1323 
1324             uint flat = centricToFlat(x,y);
1325             content[flat] = c1;
1326             content[flat+1] = c2;
1327         }
1328     }
1329 
1330     function setBackground(bytes memory content, bytes1 c1, bytes1 c2) private pure
1331     {
1332         for (uint i = 0; i < content.length / 2; ++i)
1333         {
1334             content[2*i] = c1;
1335             content[2*i+1] = c2;            
1336         }
1337     }
1338 
1339     function getColorBytes(uint seed) private pure returns(bytes1 c1, bytes1 c2, string memory name)
1340     {   
1341         uint choice = seed % 100;        
1342 
1343         if (choice < 1)
1344         {
1345             name = "yellow";            
1346             (c2,c1) = (0x7f, 0x6e);
1347         }
1348         else if (choice < 5)
1349         {
1350             name = "orange";
1351             (c2,c1) = (0x7e, 0xce);
1352         }
1353         else if (choice < 10)
1354         {
1355             name = "green";
1356             (c2,c1) = (0x63, 0xef);         
1357         }        
1358         else if (choice < 20)
1359         {
1360             name = "red";
1361             (c2,c1) = (0x79, 0xef);
1362         }
1363         else if (choice < 35)
1364         {
1365             name = "blue";
1366             (c2,c1) = (0x3f, 0x3f);        
1367         }
1368         else if (choice < 60)
1369         {
1370             name = "gray";
1371             (c2,c1) = (0x3d, 0xef);          
1372         }
1373         else 
1374         {
1375             name = "white";
1376             (c2,c1) = (0xff, 0xff);            
1377         }                
1378     }
1379 
1380     function centricToFlat(uint x, uint y) public pure returns(uint flat) 
1381     {
1382         flat = (256 * y + x)*2;
1383     }            
1384 }