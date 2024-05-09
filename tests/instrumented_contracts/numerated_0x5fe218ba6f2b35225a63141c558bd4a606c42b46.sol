1 // SPDX-License-Identifier: MIT
2 
3 /*
4     ██████╗ ███████╗
5     ██╔══██╗██╔════╝
6     ██████╔╝█████╗  
7     ██╔══██╗██╔══╝  
8     ██████╔╝██║     
9     ╚═════╝ ╚═╝                                                                                                                                                                          
10 */
11 
12 pragma solidity ^0.8.0;
13 
14 
15 /// @title Base64
16 /// @notice Provides a function for encoding some bytes in base64
17 /// @author Brecht Devos <brecht@loopring.org>
18 library Base64 {
19     bytes internal constant TABLE =
20         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
21 
22     /// @notice Encodes some bytes to the base64 representation
23     function encode(bytes memory data) internal pure returns (string memory) {
24         uint256 len = data.length;
25         if (len == 0) return "";
26 
27         // multiply by 4/3 rounded up
28         uint256 encodedLen = 4 * ((len + 2) / 3);
29 
30         // Add some extra buffer at the end
31         bytes memory result = new bytes(encodedLen + 32);
32 
33         bytes memory table = TABLE;
34 
35         assembly {
36             let tablePtr := add(table, 1)
37             let resultPtr := add(result, 32)
38 
39             for {
40                 let i := 0
41             } lt(i, len) {
42 
43             } {
44                 i := add(i, 3)
45                 let input := and(mload(add(data, i)), 0xffffff)
46 
47                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
48                 out := shl(8, out)
49                 out := add(
50                     out,
51                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
52                 )
53                 out := shl(8, out)
54                 out := add(
55                     out,
56                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
57                 )
58                 out := shl(8, out)
59                 out := add(
60                     out,
61                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
62                 )
63                 out := shl(224, out)
64 
65                 mstore(resultPtr, out)
66 
67                 resultPtr := add(resultPtr, 4)
68             }
69 
70             switch mod(len, 3)
71             case 1 {
72                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
73             }
74             case 2 {
75                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
76             }
77 
78             mstore(result, encodedLen)
79         }
80 
81         return string(result);
82     }
83 
84     function decode(bytes memory data) internal pure returns (bytes memory) {
85         uint8[128] memory toInt;
86 
87         for (uint8 i = 0; i < bytes(TABLE).length; i++) {
88             toInt[uint8(bytes(TABLE)[i])] = i;
89         }
90 
91         uint256 delta;
92         uint256 len = data.length;
93         if (data[len - 2] == "=" && data[len - 1] == "=") {
94             delta = 2;
95         } else if (data[len - 1] == "=") {
96             delta = 1;
97         } else {
98             delta = 0;
99         }
100         uint256 decodedLen = (len * 3) / 4 - delta;
101         bytes memory buffer = new bytes(decodedLen);
102         uint256 index;
103         uint8 mask = 0xFF;
104 
105         for (uint256 i = 0; i < len; i += 4) {
106             uint8 c0 = toInt[uint8(data[i])];
107             uint8 c1 = toInt[uint8(data[i + 1])];
108             buffer[index++] = (bytes1)(((c0 << 2) | (c1 >> 4)) & mask);
109             if (index >= buffer.length) {
110                 return buffer;
111             }
112             uint8 c2 = toInt[uint8(data[i + 2])];
113             buffer[index++] = (bytes1)(((c1 << 4) | (c2 >> 2)) & mask);
114             if (index >= buffer.length) {
115                 return buffer;
116             }
117             uint8 c3 = toInt[uint8(data[i + 3])];
118             buffer[index++] = (bytes1)(((c2 << 6) | c3) & mask);
119         }
120         return buffer;
121     }
122 }
123 
124 
125 /**
126  * @dev Interface of the ERC165 standard, as defined in the
127  * https://eips.ethereum.org/EIPS/eip-165[EIP].
128  *
129  * Implementers can declare support of contract interfaces, which can then be
130  * queried by others ({ERC165Checker}).
131  *
132  * For an implementation, see {ERC165}.
133  */
134 interface IERC165 {
135     /**
136      * @dev Returns true if this contract implements the interface defined by
137      * `interfaceId`. See the corresponding
138      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
139      * to learn more about how these ids are created.
140      *
141      * This function call must use less than 30 000 gas.
142      */
143     function supportsInterface(bytes4 interfaceId) external view returns (bool);
144 }
145 
146 
147 ///
148 /// @dev Interface for the NFT Royalty Standard
149 ///
150 interface IERC2981 is IERC165 {
151     /// ERC165 bytes to add to interface array - set in parent contract
152     /// implementing this standard
153     ///
154     /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
155     /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
156     /// _registerInterface(_INTERFACE_ID_ERC2981);
157 
158     /// @notice Called with the sale price to determine how much royalty
159     //          is owed and to whom.
160     /// @param _tokenId - the NFT asset queried for royalty information
161     /// @param _salePrice - the sale price of the NFT asset specified by _tokenId
162     /// @return receiver - address of who should be sent the royalty payment
163     /// @return royaltyAmount - the royalty payment amount for _salePrice
164     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
165         external
166         view
167         returns (address receiver, uint256 royaltyAmount);
168 }
169 
170 
171 
172 /**
173  * @dev Required interface of an ERC721 compliant contract.
174  */
175 interface IERC721 is IERC165 {
176     /**
177      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
180 
181     /**
182      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
183      */
184     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
185 
186     /**
187      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
188      */
189     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
190 
191     /**
192      * @dev Returns the number of tokens in ``owner``'s account.
193      */
194     function balanceOf(address owner) external view returns (uint256 balance);
195 
196     /**
197      * @dev Returns the owner of the `tokenId` token.
198      *
199      * Requirements:
200      *
201      * - `tokenId` must exist.
202      */
203     function ownerOf(uint256 tokenId) external view returns (address owner);
204 
205     /**
206      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
207      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
208      *
209      * Requirements:
210      *
211      * - `from` cannot be the zero address.
212      * - `to` cannot be the zero address.
213      * - `tokenId` token must exist and be owned by `from`.
214      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
215      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
216      *
217      * Emits a {Transfer} event.
218      */
219     function safeTransferFrom(
220         address from,
221         address to,
222         uint256 tokenId
223     ) external;
224 
225     /**
226      * @dev Transfers `tokenId` token from `from` to `to`.
227      *
228      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
229      *
230      * Requirements:
231      *
232      * - `from` cannot be the zero address.
233      * - `to` cannot be the zero address.
234      * - `tokenId` token must be owned by `from`.
235      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
236      *
237      * Emits a {Transfer} event.
238      */
239     function transferFrom(
240         address from,
241         address to,
242         uint256 tokenId
243     ) external;
244 
245     /**
246      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
247      * The approval is cleared when the token is transferred.
248      *
249      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
250      *
251      * Requirements:
252      *
253      * - The caller must own the token or be an approved operator.
254      * - `tokenId` must exist.
255      *
256      * Emits an {Approval} event.
257      */
258     function approve(address to, uint256 tokenId) external;
259 
260     /**
261      * @dev Returns the account approved for `tokenId` token.
262      *
263      * Requirements:
264      *
265      * - `tokenId` must exist.
266      */
267     function getApproved(uint256 tokenId) external view returns (address operator);
268 
269     /**
270      * @dev Approve or remove `operator` as an operator for the caller.
271      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
272      *
273      * Requirements:
274      *
275      * - The `operator` cannot be the caller.
276      *
277      * Emits an {ApprovalForAll} event.
278      */
279     function setApprovalForAll(address operator, bool _approved) external;
280 
281     /**
282      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
283      *
284      * See {setApprovalForAll}
285      */
286     function isApprovedForAll(address owner, address operator) external view returns (bool);
287 
288     /**
289      * @dev Safely transfers `tokenId` token from `from` to `to`.
290      *
291      * Requirements:
292      *
293      * - `from` cannot be the zero address.
294      * - `to` cannot be the zero address.
295      * - `tokenId` token must exist and be owned by `from`.
296      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
297      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
298      *
299      * Emits a {Transfer} event.
300      */
301     function safeTransferFrom(
302         address from,
303         address to,
304         uint256 tokenId,
305         bytes calldata data
306     ) external;
307 }
308 
309 
310 /**
311  * @title ERC721 token receiver interface
312  * @dev Interface for any contract that wants to support safeTransfers
313  * from ERC721 asset contracts.
314  */
315 interface IERC721Receiver {
316     /**
317      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
318      * by `operator` from `from`, this function is called.
319      *
320      * It must return its Solidity selector to confirm the token transfer.
321      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
322      *
323      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
324      */
325     function onERC721Received(
326         address operator,
327         address from,
328         uint256 tokenId,
329         bytes calldata data
330     ) external returns (bytes4);
331 }
332 
333 
334 
335 /**
336  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
337  * @dev See https://eips.ethereum.org/EIPS/eip-721
338  */
339 interface IERC721Metadata is IERC721 {
340     /**
341      * @dev Returns the token collection name.
342      */
343     function name() external view returns (string memory);
344 
345     /**
346      * @dev Returns the token collection symbol.
347      */
348     function symbol() external view returns (string memory);
349 
350     /**
351      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
352      */
353     function tokenURI(uint256 tokenId) external view returns (string memory);
354 }
355 
356 /**
357  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
358  * @dev See https://eips.ethereum.org/EIPS/eip-721
359  */
360 interface IERC721Enumerable is IERC721 {
361     /**
362      * @dev Returns the total amount of tokens stored by the contract.
363      */
364     function totalSupply() external view returns (uint256);
365 
366     /**
367      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
368      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
369      */
370     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
371 
372     /**
373      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
374      * Use along with {totalSupply} to enumerate all tokens.
375      */
376     function tokenByIndex(uint256 index) external view returns (uint256);
377 }
378 
379 /**
380  * @dev Collection of functions related to the address type
381  */
382 library Address {
383     /**
384      * @dev Returns true if `account` is a contract.
385      *
386      * [IMPORTANT]
387      * ====
388      * It is unsafe to assume that an address for which this function returns
389      * false is an externally-owned account (EOA) and not a contract.
390      *
391      * Among others, `isContract` will return false for the following
392      * types of addresses:
393      *
394      *  - an externally-owned account
395      *  - a contract in construction
396      *  - an address where a contract will be created
397      *  - an address where a contract lived, but was destroyed
398      * ====
399      *
400      * [IMPORTANT]
401      * ====
402      * You shouldn't rely on `isContract` to protect against flash loan attacks!
403      *
404      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
405      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
406      * constructor.
407      * ====
408      */
409     function isContract(address account) internal view returns (bool) {
410         // This method relies on extcodesize/address.code.length, which returns 0
411         // for contracts in construction, since the code is only stored at the end
412         // of the constructor execution.
413 
414         return account.code.length > 0;
415     }
416 
417     /**
418      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
419      * `recipient`, forwarding all available gas and reverting on errors.
420      *
421      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
422      * of certain opcodes, possibly making contracts go over the 2300 gas limit
423      * imposed by `transfer`, making them unable to receive funds via
424      * `transfer`. {sendValue} removes this limitation.
425      *
426      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
427      *
428      * IMPORTANT: because control is transferred to `recipient`, care must be
429      * taken to not create reentrancy vulnerabilities. Consider using
430      * {ReentrancyGuard} or the
431      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
432      */
433     function sendValue(address payable recipient, uint256 amount) internal {
434         require(address(this).balance >= amount, "Address: insufficient balance");
435 
436         (bool success, ) = recipient.call{value: amount}("");
437         require(success, "Address: unable to send value, recipient may have reverted");
438     }
439 
440     /**
441      * @dev Performs a Solidity function call using a low level `call`. A
442      * plain `call` is an unsafe replacement for a function call: use this
443      * function instead.
444      *
445      * If `target` reverts with a revert reason, it is bubbled up by this
446      * function (like regular Solidity function calls).
447      *
448      * Returns the raw returned data. To convert to the expected return value,
449      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
450      *
451      * Requirements:
452      *
453      * - `target` must be a contract.
454      * - calling `target` with `data` must not revert.
455      *
456      * _Available since v3.1._
457      */
458     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
459         return functionCall(target, data, "Address: low-level call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
464      * `errorMessage` as a fallback revert reason when `target` reverts.
465      *
466      * _Available since v3.1._
467      */
468     function functionCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         return functionCallWithValue(target, data, 0, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but also transferring `value` wei to `target`.
479      *
480      * Requirements:
481      *
482      * - the calling contract must have an ETH balance of at least `value`.
483      * - the called Solidity function must be `payable`.
484      *
485      * _Available since v3.1._
486      */
487     function functionCallWithValue(
488         address target,
489         bytes memory data,
490         uint256 value
491     ) internal returns (bytes memory) {
492         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
497      * with `errorMessage` as a fallback revert reason when `target` reverts.
498      *
499      * _Available since v3.1._
500      */
501     function functionCallWithValue(
502         address target,
503         bytes memory data,
504         uint256 value,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         require(address(this).balance >= value, "Address: insufficient balance for call");
508         require(isContract(target), "Address: call to non-contract");
509 
510         (bool success, bytes memory returndata) = target.call{value: value}(data);
511         return verifyCallResult(success, returndata, errorMessage);
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
516      * but performing a static call.
517      *
518      * _Available since v3.3._
519      */
520     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
521         return functionStaticCall(target, data, "Address: low-level static call failed");
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
526      * but performing a static call.
527      *
528      * _Available since v3.3._
529      */
530     function functionStaticCall(
531         address target,
532         bytes memory data,
533         string memory errorMessage
534     ) internal view returns (bytes memory) {
535         require(isContract(target), "Address: static call to non-contract");
536 
537         (bool success, bytes memory returndata) = target.staticcall(data);
538         return verifyCallResult(success, returndata, errorMessage);
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
543      * but performing a delegate call.
544      *
545      * _Available since v3.4._
546      */
547     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
548         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
553      * but performing a delegate call.
554      *
555      * _Available since v3.4._
556      */
557     function functionDelegateCall(
558         address target,
559         bytes memory data,
560         string memory errorMessage
561     ) internal returns (bytes memory) {
562         require(isContract(target), "Address: delegate call to non-contract");
563 
564         (bool success, bytes memory returndata) = target.delegatecall(data);
565         return verifyCallResult(success, returndata, errorMessage);
566     }
567 
568     /**
569      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
570      * revert reason using the provided one.
571      *
572      * _Available since v4.3._
573      */
574     function verifyCallResult(
575         bool success,
576         bytes memory returndata,
577         string memory errorMessage
578     ) internal pure returns (bytes memory) {
579         if (success) {
580             return returndata;
581         } else {
582             // Look for revert reason and bubble it up if present
583             if (returndata.length > 0) {
584                 // The easiest way to bubble the revert reason is using memory via assembly
585 
586                 assembly {
587                     let returndata_size := mload(returndata)
588                     revert(add(32, returndata), returndata_size)
589                 }
590             } else {
591                 revert(errorMessage);
592             }
593         }
594     }
595 }
596 
597 
598 /**
599  * @dev Provides information about the current execution context, including the
600  * sender of the transaction and its data. While these are generally available
601  * via msg.sender and msg.data, they should not be accessed in such a direct
602  * manner, since when dealing with meta-transactions the account sending and
603  * paying for execution may not be the actual sender (as far as an application
604  * is concerned).
605  *
606  * This contract is only required for intermediate, library-like contracts.
607  */
608 abstract contract Context {
609     function _msgSender() internal view virtual returns (address) {
610         return msg.sender;
611     }
612 
613     function _msgData() internal view virtual returns (bytes calldata) {
614         return msg.data;
615     }
616 }
617 
618 
619 /**
620  * @dev Implementation of the {IERC165} interface.
621  *
622  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
623  * for the additional interface id that will be supported. For example:
624  *
625  * ```solidity
626  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
627  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
628  * }
629  * ```
630  *
631  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
632  */
633 abstract contract ERC165 is IERC165 {
634     /**
635      * @dev See {IERC165-supportsInterface}.
636      */
637     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
638         return interfaceId == type(IERC165).interfaceId;
639     }
640 }
641 
642 
643 /**
644  * @dev String operations.
645  */
646 library Strings {
647     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
648 
649     /**
650      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
651      */
652     function toString(uint256 value) internal pure returns (string memory) {
653         // Inspired by OraclizeAPI's implementation - MIT licence
654         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
655 
656         if (value == 0) {
657             return "0";
658         }
659         uint256 temp = value;
660         uint256 digits;
661         while (temp != 0) {
662             digits++;
663             temp /= 10;
664         }
665         bytes memory buffer = new bytes(digits);
666         while (value != 0) {
667             digits -= 1;
668             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
669             value /= 10;
670         }
671         return string(buffer);
672     }
673 
674     /**
675      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
676      */
677     function toHexString(uint256 value) internal pure returns (string memory) {
678         if (value == 0) {
679             return "0x00";
680         }
681         uint256 temp = value;
682         uint256 length = 0;
683         while (temp != 0) {
684             length++;
685             temp >>= 8;
686         }
687         return toHexString(value, length);
688     }
689 
690     /**
691      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
692      */
693     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
694         bytes memory buffer = new bytes(2 * length + 2);
695         buffer[0] = "0";
696         buffer[1] = "x";
697         for (uint256 i = 2 * length + 1; i > 1; --i) {
698             buffer[i] = _HEX_SYMBOLS[value & 0xf];
699             value >>= 4;
700         }
701         require(value == 0, "Strings: hex length insufficient");
702         return string(buffer);
703     }
704 }
705 
706 
707 error ApprovalCallerNotOwnerNorApproved();
708 error ApprovalQueryForNonexistentToken();
709 error ApproveToCaller();
710 error ApprovalToCurrentOwner();
711 error BalanceQueryForZeroAddress();
712 error MintToZeroAddress();
713 error MintZeroQuantity();
714 error OwnerQueryForNonexistentToken();
715 error TransferCallerNotOwnerNorApproved();
716 error TransferFromIncorrectOwner();
717 error TransferToNonERC721ReceiverImplementer();
718 error TransferToZeroAddress();
719 error URIQueryForNonexistentToken();
720 
721 /**
722  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
723  * the Metadata extension. Built to optimize for lower gas during batch mints.
724  *
725  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
726  *
727  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
728  *
729  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
730  */
731 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
732     using Address for address;
733     using Strings for uint256;
734 
735     // Compiler will pack this into a single 256bit word.
736     struct TokenOwnership {
737         // The address of the owner.
738         address addr;
739         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
740         uint64 startTimestamp;
741         // Whether the token has been burned.
742         bool burned;
743     }
744 
745     // Compiler will pack this into a single 256bit word.
746     struct AddressData {
747         // Realistically, 2**64-1 is more than enough.
748         uint64 balance;
749         // Keeps track of mint count with minimal overhead for tokenomics.
750         uint64 numberMinted;
751         // Keeps track of burn count with minimal overhead for tokenomics.
752         uint64 numberBurned;
753         // For miscellaneous variable(s) pertaining to the address
754         // (e.g. number of whitelist mint slots used).
755         // If there are multiple variables, please pack them into a uint64.
756         uint64 aux;
757     }
758 
759     // The tokenId of the next token to be minted.
760     uint256 internal _currentIndex;
761 
762     // The number of tokens burned.
763     uint256 internal _burnCounter;
764 
765     // Token name
766     string private _name;
767 
768     // Token symbol
769     string private _symbol;
770 
771     // Mapping from token ID to ownership details
772     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
773     mapping(uint256 => TokenOwnership) internal _ownerships;
774 
775     // Mapping owner address to address data
776     mapping(address => AddressData) private _addressData;
777 
778     // Mapping from token ID to approved address
779     mapping(uint256 => address) private _tokenApprovals;
780 
781     // Mapping from owner to operator approvals
782     mapping(address => mapping(address => bool)) private _operatorApprovals;
783 
784     constructor(string memory name_, string memory symbol_) {
785         _name = name_;
786         _symbol = symbol_;
787         _currentIndex = _startTokenId();
788     }
789 
790     /**
791      * To change the starting tokenId, please override this function.
792      */
793     function _startTokenId() internal view virtual returns (uint256) {
794         return 0;
795     }
796 
797     /**
798      * @dev See {IERC721Enumerable-totalSupply}.
799      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
800      */
801     function totalSupply() public view returns (uint256) {
802         // Counter underflow is impossible as _burnCounter cannot be incremented
803         // more than _currentIndex - _startTokenId() times
804         unchecked {
805             return _currentIndex - _burnCounter - _startTokenId();
806         }
807     }
808 
809     /**
810      * Returns the total amount of tokens minted in the contract.
811      */
812     function _totalMinted() internal view returns (uint256) {
813         // Counter underflow is impossible as _currentIndex does not decrement,
814         // and it is initialized to _startTokenId()
815         unchecked {
816             return _currentIndex - _startTokenId();
817         }
818     }
819 
820     /**
821      * @dev See {IERC165-supportsInterface}.
822      */
823     function supportsInterface(bytes4 interfaceId)
824         public
825         view
826         virtual
827         override(ERC165, IERC165)
828         returns (bool)
829     {
830         return
831             interfaceId == type(IERC721).interfaceId ||
832             interfaceId == type(IERC721Metadata).interfaceId ||
833             super.supportsInterface(interfaceId);
834     }
835 
836     /**
837      * @dev See {IERC721-balanceOf}.
838      */
839     function balanceOf(address owner) public view override returns (uint256) {
840         if (owner == address(0)) revert BalanceQueryForZeroAddress();
841         return uint256(_addressData[owner].balance);
842     }
843 
844     /**
845      * Returns the number of tokens minted by `owner`.
846      */
847     function _numberMinted(address owner) internal view returns (uint256) {
848         return uint256(_addressData[owner].numberMinted);
849     }
850 
851     /**
852      * Returns the number of tokens burned by or on behalf of `owner`.
853      */
854     function _numberBurned(address owner) internal view returns (uint256) {
855         return uint256(_addressData[owner].numberBurned);
856     }
857 
858     /**
859      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
860      */
861     function _getAux(address owner) internal view returns (uint64) {
862         return _addressData[owner].aux;
863     }
864 
865     /**
866      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
867      * If there are multiple variables, please pack them into a uint64.
868      */
869     function _setAux(address owner, uint64 aux) internal {
870         _addressData[owner].aux = aux;
871     }
872 
873     /**
874      * Gas spent here starts off proportional to the maximum mint batch size.
875      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
876      */
877     function _ownershipOf(uint256 tokenId)
878         internal
879         view
880         returns (TokenOwnership memory)
881     {
882         uint256 curr = tokenId;
883 
884         unchecked {
885             if (_startTokenId() <= curr && curr < _currentIndex) {
886                 TokenOwnership memory ownership = _ownerships[curr];
887                 if (!ownership.burned) {
888                     if (ownership.addr != address(0)) {
889                         return ownership;
890                     }
891                     // Invariant:
892                     // There will always be an ownership that has an address and is not burned
893                     // before an ownership that does not have an address and is not burned.
894                     // Hence, curr will not underflow.
895                     while (true) {
896                         curr--;
897                         ownership = _ownerships[curr];
898                         if (ownership.addr != address(0)) {
899                             return ownership;
900                         }
901                     }
902                 }
903             }
904         }
905         revert OwnerQueryForNonexistentToken();
906     }
907 
908     /**
909      * @dev See {IERC721-ownerOf}.
910      */
911     function ownerOf(uint256 tokenId) public view override returns (address) {
912         return _ownershipOf(tokenId).addr;
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
932     function tokenURI(uint256 tokenId)
933         public
934         view
935         virtual
936         override
937         returns (string memory)
938     {
939         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
940 
941         string memory baseURI = _baseURI();
942         return
943             bytes(baseURI).length != 0
944                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
945                 : "";
946     }
947 
948     /**
949      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
950      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
951      * by default, can be overriden in child contracts.
952      */
953     function _baseURI() internal view virtual returns (string memory) {
954         return "";
955     }
956 
957     /**
958      * @dev See {IERC721-approve}.
959      */
960     function approve(address to, uint256 tokenId) public override {
961         address owner = ERC721A.ownerOf(tokenId);
962         if (to == owner) revert ApprovalToCurrentOwner();
963 
964         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
965             revert ApprovalCallerNotOwnerNorApproved();
966         }
967 
968         _approve(to, tokenId, owner);
969     }
970 
971     /**
972      * @dev See {IERC721-getApproved}.
973      */
974     function getApproved(uint256 tokenId)
975         public
976         view
977         override
978         returns (address)
979     {
980         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
981 
982         return _tokenApprovals[tokenId];
983     }
984 
985     /**
986      * @dev See {IERC721-setApprovalForAll}.
987      */
988     function setApprovalForAll(address operator, bool approved)
989         public
990         virtual
991         override
992     {
993         if (operator == _msgSender()) revert ApproveToCaller();
994 
995         _operatorApprovals[_msgSender()][operator] = approved;
996         emit ApprovalForAll(_msgSender(), operator, approved);
997     }
998 
999     /**
1000      * @dev See {IERC721-isApprovedForAll}.
1001      */
1002     function isApprovedForAll(address owner, address operator)
1003         public
1004         view
1005         virtual
1006         override
1007         returns (bool)
1008     {
1009         return _operatorApprovals[owner][operator];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-transferFrom}.
1014      */
1015     function transferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         _transfer(from, to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-safeTransferFrom}.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         safeTransferFrom(from, to, tokenId, "");
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-safeTransferFrom}.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) public virtual override {
1043         _transfer(from, to, tokenId);
1044         if (
1045             to.isContract() &&
1046             !_checkContractOnERC721Received(from, to, tokenId, _data)
1047         ) {
1048             revert TransferToNonERC721ReceiverImplementer();
1049         }
1050     }
1051 
1052     /**
1053      * @dev Returns whether `tokenId` exists.
1054      *
1055      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1056      *
1057      * Tokens start existing when they are minted (`_mint`),
1058      */
1059     function _exists(uint256 tokenId) internal view returns (bool) {
1060         return
1061             _startTokenId() <= tokenId &&
1062             tokenId < _currentIndex &&
1063             !_ownerships[tokenId].burned;
1064     }
1065 
1066     function _safeMint(address to, uint256 quantity) internal {
1067         _safeMint(to, quantity, "");
1068     }
1069 
1070     /**
1071      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1072      *
1073      * Requirements:
1074      *
1075      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1076      * - `quantity` must be greater than 0.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _safeMint(
1081         address to,
1082         uint256 quantity,
1083         bytes memory _data
1084     ) internal {
1085         _mint(to, quantity, _data, true);
1086     }
1087 
1088     /**
1089      * @dev Mints `quantity` tokens and transfers them to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - `to` cannot be the zero address.
1094      * - `quantity` must be greater than 0.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _mint(
1099         address to,
1100         uint256 quantity,
1101         bytes memory _data,
1102         bool safe
1103     ) internal {
1104         uint256 startTokenId = _currentIndex;
1105         if (to == address(0)) revert MintToZeroAddress();
1106         if (quantity == 0) revert MintZeroQuantity();
1107 
1108         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1109 
1110         // Overflows are incredibly unrealistic.
1111         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1112         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1113         unchecked {
1114             _addressData[to].balance += uint64(quantity);
1115             _addressData[to].numberMinted += uint64(quantity);
1116 
1117             _ownerships[startTokenId].addr = to;
1118             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1119 
1120             uint256 updatedIndex = startTokenId;
1121             uint256 end = updatedIndex + quantity;
1122 
1123             if (safe && to.isContract()) {
1124                 do {
1125                     emit Transfer(address(0), to, updatedIndex);
1126                     if (
1127                         !_checkContractOnERC721Received(
1128                             address(0),
1129                             to,
1130                             updatedIndex++,
1131                             _data
1132                         )
1133                     ) {
1134                         revert TransferToNonERC721ReceiverImplementer();
1135                     }
1136                 } while (updatedIndex != end);
1137                 // Reentrancy protection
1138                 if (_currentIndex != startTokenId) revert();
1139             } else {
1140                 do {
1141                     emit Transfer(address(0), to, updatedIndex++);
1142                 } while (updatedIndex != end);
1143             }
1144             _currentIndex = updatedIndex;
1145         }
1146         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1147     }
1148 
1149     /**
1150      * @dev Transfers `tokenId` from `from` to `to`.
1151      *
1152      * Requirements:
1153      *
1154      * - `to` cannot be the zero address.
1155      * - `tokenId` token must be owned by `from`.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _transfer(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) private {
1164         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1165 
1166         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1167 
1168         bool isApprovedOrOwner = (_msgSender() == from ||
1169             isApprovedForAll(from, _msgSender()) ||
1170             getApproved(tokenId) == _msgSender());
1171 
1172         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1173         if (to == address(0)) revert TransferToZeroAddress();
1174 
1175         _beforeTokenTransfers(from, to, tokenId, 1);
1176 
1177         // Clear approvals from the previous owner
1178         _approve(address(0), tokenId, from);
1179 
1180         // Underflow of the sender's balance is impossible because we check for
1181         // ownership above and the recipient's balance can't realistically overflow.
1182         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1183         unchecked {
1184             _addressData[from].balance -= 1;
1185             _addressData[to].balance += 1;
1186 
1187             TokenOwnership storage currSlot = _ownerships[tokenId];
1188             currSlot.addr = to;
1189             currSlot.startTimestamp = uint64(block.timestamp);
1190 
1191             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1192             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1193             uint256 nextTokenId = tokenId + 1;
1194             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1195             if (nextSlot.addr == address(0)) {
1196                 // This will suffice for checking _exists(nextTokenId),
1197                 // as a burned slot cannot contain the zero address.
1198                 if (nextTokenId != _currentIndex) {
1199                     nextSlot.addr = from;
1200                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1201                 }
1202             }
1203         }
1204 
1205         emit Transfer(from, to, tokenId);
1206         _afterTokenTransfers(from, to, tokenId, 1);
1207     }
1208 
1209     /**
1210      * @dev This is equivalent to _burn(tokenId, false)
1211      */
1212     function _burn(uint256 tokenId) internal virtual {
1213         _burn(tokenId, false);
1214     }
1215 
1216     /**
1217      * @dev Destroys `tokenId`.
1218      * The approval is cleared when the token is burned.
1219      *
1220      * Requirements:
1221      *
1222      * - `tokenId` must exist.
1223      *
1224      * Emits a {Transfer} event.
1225      */
1226     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1227         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1228 
1229         address from = prevOwnership.addr;
1230 
1231         if (approvalCheck) {
1232             bool isApprovedOrOwner = (_msgSender() == from ||
1233                 isApprovedForAll(from, _msgSender()) ||
1234                 getApproved(tokenId) == _msgSender());
1235 
1236             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1237         }
1238 
1239         _beforeTokenTransfers(from, address(0), tokenId, 1);
1240 
1241         // Clear approvals from the previous owner
1242         _approve(address(0), tokenId, from);
1243 
1244         // Underflow of the sender's balance is impossible because we check for
1245         // ownership above and the recipient's balance can't realistically overflow.
1246         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1247         unchecked {
1248             AddressData storage addressData = _addressData[from];
1249             addressData.balance -= 1;
1250             addressData.numberBurned += 1;
1251 
1252             // Keep track of who burned the token, and the timestamp of burning.
1253             TokenOwnership storage currSlot = _ownerships[tokenId];
1254             currSlot.addr = from;
1255             currSlot.startTimestamp = uint64(block.timestamp);
1256             currSlot.burned = true;
1257 
1258             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1259             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1260             uint256 nextTokenId = tokenId + 1;
1261             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1262             if (nextSlot.addr == address(0)) {
1263                 // This will suffice for checking _exists(nextTokenId),
1264                 // as a burned slot cannot contain the zero address.
1265                 if (nextTokenId != _currentIndex) {
1266                     nextSlot.addr = from;
1267                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1268                 }
1269             }
1270         }
1271 
1272         emit Transfer(from, address(0), tokenId);
1273         _afterTokenTransfers(from, address(0), tokenId, 1);
1274 
1275         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1276         unchecked {
1277             _burnCounter++;
1278         }
1279     }
1280 
1281     /**
1282      * @dev Approve `to` to operate on `tokenId`
1283      *
1284      * Emits a {Approval} event.
1285      */
1286     function _approve(
1287         address to,
1288         uint256 tokenId,
1289         address owner
1290     ) private {
1291         _tokenApprovals[tokenId] = to;
1292         emit Approval(owner, to, tokenId);
1293     }
1294 
1295     /**
1296      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1297      *
1298      * @param from address representing the previous owner of the given token ID
1299      * @param to target address that will receive the tokens
1300      * @param tokenId uint256 ID of the token to be transferred
1301      * @param _data bytes optional data to send along with the call
1302      * @return bool whether the call correctly returned the expected magic value
1303      */
1304     function _checkContractOnERC721Received(
1305         address from,
1306         address to,
1307         uint256 tokenId,
1308         bytes memory _data
1309     ) private returns (bool) {
1310         try
1311             IERC721Receiver(to).onERC721Received(
1312                 _msgSender(),
1313                 from,
1314                 tokenId,
1315                 _data
1316             )
1317         returns (bytes4 retval) {
1318             return retval == IERC721Receiver(to).onERC721Received.selector;
1319         } catch (bytes memory reason) {
1320             if (reason.length == 0) {
1321                 revert TransferToNonERC721ReceiverImplementer();
1322             } else {
1323                 assembly {
1324                     revert(add(32, reason), mload(reason))
1325                 }
1326             }
1327         }
1328     }
1329 
1330     /**
1331      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1332      * And also called before burning one token.
1333      *
1334      * startTokenId - the first token id to be transferred
1335      * quantity - the amount to be transferred
1336      *
1337      * Calling conditions:
1338      *
1339      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1340      * transferred to `to`.
1341      * - When `from` is zero, `tokenId` will be minted for `to`.
1342      * - When `to` is zero, `tokenId` will be burned by `from`.
1343      * - `from` and `to` are never both zero.
1344      */
1345     function _beforeTokenTransfers(
1346         address from,
1347         address to,
1348         uint256 startTokenId,
1349         uint256 quantity
1350     ) internal virtual {}
1351 
1352     /**
1353      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1354      * minting.
1355      * And also called after one token has been burned.
1356      *
1357      * startTokenId - the first token id to be transferred
1358      * quantity - the amount to be transferred
1359      *
1360      * Calling conditions:
1361      *
1362      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1363      * transferred to `to`.
1364      * - When `from` is zero, `tokenId` has been minted for `to`.
1365      * - When `to` is zero, `tokenId` has been burned by `from`.
1366      * - `from` and `to` are never both zero.
1367      */
1368     function _afterTokenTransfers(
1369         address from,
1370         address to,
1371         uint256 startTokenId,
1372         uint256 quantity
1373     ) internal virtual {}
1374 }
1375 
1376 
1377 /**
1378  * @dev Interface of the ERC20 standard as defined in the EIP.
1379  */
1380 interface IERC20 {
1381     /**
1382      * @dev Returns the amount of tokens in existence.
1383      */
1384     function totalSupply() external view returns (uint256);
1385 
1386     /**
1387      * @dev Returns the amount of tokens owned by `account`.
1388      */
1389     function balanceOf(address account) external view returns (uint256);
1390 
1391     /**
1392      * @dev Moves `amount` tokens from the caller's account to `to`.
1393      *
1394      * Returns a boolean value indicating whether the operation succeeded.
1395      *
1396      * Emits a {Transfer} event.
1397      */
1398     function transfer(address to, uint256 amount) external returns (bool);
1399 
1400     /**
1401      * @dev Returns the remaining number of tokens that `spender` will be
1402      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1403      * zero by default.
1404      *
1405      * This value changes when {approve} or {transferFrom} are called.
1406      */
1407     function allowance(address owner, address spender) external view returns (uint256);
1408 
1409     /**
1410      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1411      *
1412      * Returns a boolean value indicating whether the operation succeeded.
1413      *
1414      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1415      * that someone may use both the old and the new allowance by unfortunate
1416      * transaction ordering. One possible solution to mitigate this race
1417      * condition is to first reduce the spender's allowance to 0 and set the
1418      * desired value afterwards:
1419      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1420      *
1421      * Emits an {Approval} event.
1422      */
1423     function approve(address spender, uint256 amount) external returns (bool);
1424 
1425     /**
1426      * @dev Moves `amount` tokens from `from` to `to` using the
1427      * allowance mechanism. `amount` is then deducted from the caller's
1428      * allowance.
1429      *
1430      * Returns a boolean value indicating whether the operation succeeded.
1431      *
1432      * Emits a {Transfer} event.
1433      */
1434     function transferFrom(
1435         address from,
1436         address to,
1437         uint256 amount
1438     ) external returns (bool);
1439 
1440     /**
1441      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1442      * another (`to`).
1443      *
1444      * Note that `value` may be zero.
1445      */
1446     event Transfer(address indexed from, address indexed to, uint256 value);
1447 
1448     /**
1449      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1450      * a call to {approve}. `value` is the new allowance.
1451      */
1452     event Approval(address indexed owner, address indexed spender, uint256 value);
1453 }
1454 
1455 
1456 
1457 
1458 /**
1459  * @title SafeERC20
1460  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1461  * contract returns false). Tokens that return no value (and instead revert or
1462  * throw on failure) are also supported, non-reverting calls are assumed to be
1463  * successful.
1464  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1465  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1466  */
1467 library SafeERC20 {
1468     using Address for address;
1469 
1470     function safeTransfer(
1471         IERC20 token,
1472         address to,
1473         uint256 value
1474     ) internal {
1475         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1476     }
1477 
1478     function safeTransferFrom(
1479         IERC20 token,
1480         address from,
1481         address to,
1482         uint256 value
1483     ) internal {
1484         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1485     }
1486 
1487     /**
1488      * @dev Deprecated. This function has issues similar to the ones found in
1489      * {IERC20-approve}, and its usage is discouraged.
1490      *
1491      * Whenever possible, use {safeIncreaseAllowance} and
1492      * {safeDecreaseAllowance} instead.
1493      */
1494     function safeApprove(
1495         IERC20 token,
1496         address spender,
1497         uint256 value
1498     ) internal {
1499         // safeApprove should only be called when setting an initial allowance,
1500         // or when resetting it to zero. To increase and decrease it, use
1501         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1502         require(
1503             (value == 0) || (token.allowance(address(this), spender) == 0),
1504             "SafeERC20: approve from non-zero to non-zero allowance"
1505         );
1506         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1507     }
1508 
1509     function safeIncreaseAllowance(
1510         IERC20 token,
1511         address spender,
1512         uint256 value
1513     ) internal {
1514         uint256 newAllowance = token.allowance(address(this), spender) + value;
1515         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1516     }
1517 
1518     function safeDecreaseAllowance(
1519         IERC20 token,
1520         address spender,
1521         uint256 value
1522     ) internal {
1523         unchecked {
1524             uint256 oldAllowance = token.allowance(address(this), spender);
1525             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1526             uint256 newAllowance = oldAllowance - value;
1527             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1528         }
1529     }
1530 
1531     /**
1532      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1533      * on the return value: the return value is optional (but if data is returned, it must not be false).
1534      * @param token The token targeted by the call.
1535      * @param data The call data (encoded using abi.encode or one of its variants).
1536      */
1537     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1538         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1539         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1540         // the target address contains contract code and also asserts for success in the low-level call.
1541 
1542         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1543         if (returndata.length > 0) {
1544             // Return data is optional
1545             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1546         }
1547     }
1548 }
1549 
1550 /**
1551  * Slightly adjusted version of PaymentSplitter by OpenZeppelin
1552  *
1553  * @title PaymentSplitter
1554  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1555  * that the Ether will be split in this way, since it is handled transparently by the contract.
1556  *
1557  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1558  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1559  * an amount proportional to the percentage of total shares they were assigned.
1560  *
1561  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1562  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1563  * function.
1564  *
1565  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1566  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1567  * to run tests before sending real value to this contract.
1568  */
1569 contract PaymentSplitter is Context {
1570     event PayeeAdded(address account, uint256 shares);
1571     event PaymentReleased(address to, uint256 amount);
1572     event ERC20PaymentReleased(
1573         IERC20 indexed token,
1574         address to,
1575         uint256 amount
1576     );
1577     event PaymentReceived(address from, uint256 amount);
1578 
1579     uint256 private _totalShares;
1580     uint256 private _totalReleased;
1581 
1582     mapping(address => uint256) private _shares;
1583     mapping(address => uint256) private _released;
1584     address[] private _payees;
1585 
1586     mapping(IERC20 => uint256) private _erc20TotalReleased;
1587     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1588 
1589     /**
1590      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1591      * the matching position in the `shares` array.
1592      *
1593      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1594      * duplicates in `payees`.
1595      */
1596     constructor(address[] memory payees, uint256[] memory shares_) payable {
1597         require(
1598             payees.length == shares_.length,
1599             "PaymentSplitter: payees and shares length mismatch"
1600         );
1601         require(payees.length > 0, "PaymentSplitter: no payees");
1602 
1603         for (uint256 i = 0; i < payees.length; i++) {
1604             _addPayee(payees[i], shares_[i]);
1605         }
1606     }
1607 
1608     /**
1609      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1610      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1611      * reliability of the events, and not the actual splitting of Ether.
1612      *
1613      * To learn more about this see the Solidity documentation for
1614      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1615      * functions].
1616      */
1617     receive() external payable virtual {
1618         emit PaymentReceived(_msgSender(), msg.value);
1619     }
1620 
1621     /**
1622      * @dev Getter for the total shares held by payees.
1623      */
1624     function totalShares() public view returns (uint256) {
1625         return _totalShares;
1626     }
1627 
1628     /**
1629      * @dev Getter for the total amount of Ether already released.
1630      */
1631     function totalReleased() public view returns (uint256) {
1632         return _totalReleased;
1633     }
1634 
1635     /**
1636      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1637      * contract.
1638      */
1639     function totalReleased(IERC20 token) public view returns (uint256) {
1640         return _erc20TotalReleased[token];
1641     }
1642 
1643     /**
1644      * @dev Getter for the amount of shares held by an account.
1645      */
1646     function shares(address account) public view returns (uint256) {
1647         return _shares[account];
1648     }
1649 
1650     /**
1651      * @dev Getter for the amount of Ether already released to a payee.
1652      */
1653     function released(address account) public view returns (uint256) {
1654         return _released[account];
1655     }
1656 
1657     /**
1658      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1659      * IERC20 contract.
1660      */
1661     function released(IERC20 token, address account)
1662         public
1663         view
1664         returns (uint256)
1665     {
1666         return _erc20Released[token][account];
1667     }
1668 
1669     /**
1670      * @dev Getter for the address of the payee number `index`.
1671      */
1672     function payee(uint256 index) public view returns (address) {
1673         return _payees[index];
1674     }
1675 
1676     /**
1677      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1678      * total shares and their previous withdrawals.
1679      */
1680     function release(address payable account) public virtual {
1681         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1682 
1683         uint256 totalReceived = address(this).balance + totalReleased();
1684         uint256 payment = _pendingPayment(
1685             account,
1686             totalReceived,
1687             released(account)
1688         );
1689 
1690         require(payment != 0, "PaymentSplitter: account is not due payment");
1691 
1692         _released[account] += payment;
1693         _totalReleased += payment;
1694 
1695         Address.sendValue(account, payment);
1696         emit PaymentReleased(account, payment);
1697     }
1698 
1699     /**
1700      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1701      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1702      * contract.
1703      */
1704     function release(IERC20 token, address account) public virtual {
1705         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1706 
1707         uint256 totalReceived = token.balanceOf(address(this)) +
1708             totalReleased(token);
1709         uint256 payment = _pendingPayment(
1710             account,
1711             totalReceived,
1712             released(token, account)
1713         );
1714 
1715         require(payment != 0, "PaymentSplitter: account is not due payment");
1716 
1717         _erc20Released[token][account] += payment;
1718         _erc20TotalReleased[token] += payment;
1719 
1720         SafeERC20.safeTransfer(token, account, payment);
1721         emit ERC20PaymentReleased(token, account, payment);
1722     }
1723 
1724     /**
1725      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1726      * already released amounts.
1727      */
1728     function _pendingPayment(
1729         address account,
1730         uint256 totalReceived,
1731         uint256 alreadyReleased
1732     ) private view returns (uint256) {
1733         return
1734             (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1735     }
1736 
1737     /**
1738      * @dev Add a new payee to the contract.
1739      * @param account The address of the payee to add.
1740      * @param shares_ The number of shares owned by the payee.
1741      */
1742     function _addPayee(address account, uint256 shares_) internal {
1743         require(
1744             account != address(0),
1745             "PaymentSplitter: account is the zero address"
1746         );
1747         require(shares_ > 0, "PaymentSplitter: shares are 0");
1748         require(
1749             _shares[account] == 0,
1750             "PaymentSplitter: account already has shares"
1751         );
1752 
1753         _payees.push(account);
1754         _shares[account] = shares_;
1755         _totalShares = _totalShares + shares_;
1756         emit PayeeAdded(account, shares_);
1757     }
1758 
1759     /**
1760      * @dev Update a payee on the contract.
1761      * @param index The array index of the payee to update.
1762      * @param shares_ The number of shares owned by the payee.
1763      */
1764     function _updatePayee(uint256 index, uint256 shares_) internal {
1765         require(shares_ > 0, "PaymentSplitter: shares are 0");
1766         uint256 temp = _shares[payee(index)];
1767         _shares[payee(index)] = shares_;
1768         _totalShares = _totalShares - temp + shares_;
1769     }
1770 
1771     /**
1772      * @dev Remove a payee from the contract.
1773      * @param index The array index of the payee to update.
1774      */
1775     function _removePayee(uint256 index) internal {
1776         uint256 temp = _shares[payee(index)];
1777         _shares[payee(index)] = 0;
1778         _payees[index] = _payees[_payees.length - 1];
1779         _payees.pop();
1780         _totalShares = _totalShares - temp;
1781     }
1782 }
1783 
1784 
1785 /**
1786  * @dev Contract module which provides a basic access control mechanism, where
1787  * there is an account (an owner) that can be granted exclusive access to
1788  * specific functions.
1789  *
1790  * By default, the owner account will be the one that deploys the contract. This
1791  * can later be changed with {transferOwnership}.
1792  *
1793  * This module is used through inheritance. It will make available the modifier
1794  * `onlyOwner`, which can be applied to your functions to restrict their use to
1795  * the owner.
1796  */
1797 abstract contract Ownable is Context {
1798     address private _owner;
1799 
1800     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1801 
1802     /**
1803      * @dev Initializes the contract setting the deployer as the initial owner.
1804      */
1805     constructor() {
1806         _transferOwnership(_msgSender());
1807     }
1808 
1809     /**
1810      * @dev Returns the address of the current owner.
1811      */
1812     function owner() public view virtual returns (address) {
1813         return _owner;
1814     }
1815 
1816     /**
1817      * @dev Throws if called by any account other than the owner.
1818      */
1819     modifier onlyOwner() {
1820         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1821         _;
1822     }
1823 
1824     /**
1825      * @dev Leaves the contract without owner. It will not be possible to call
1826      * `onlyOwner` functions anymore. Can only be called by the current owner.
1827      *
1828      * NOTE: Renouncing ownership will leave the contract without an owner,
1829      * thereby removing any functionality that is only available to the owner.
1830      */
1831     function renounceOwnership() public virtual onlyOwner {
1832         _transferOwnership(address(0));
1833     }
1834 
1835     /**
1836      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1837      * Can only be called by the current owner.
1838      */
1839     function transferOwnership(address newOwner) public virtual onlyOwner {
1840         require(newOwner != address(0), "Ownable: new owner is the zero address");
1841         _transferOwnership(newOwner);
1842     }
1843 
1844     /**
1845      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1846      * Internal function without access restriction.
1847      */
1848     function _transferOwnership(address newOwner) internal virtual {
1849         address oldOwner = _owner;
1850         _owner = newOwner;
1851         emit OwnershipTransferred(oldOwner, newOwner);
1852     }
1853 }
1854 
1855 contract Royalties_V1 is PaymentSplitter, Ownable {
1856     constructor(
1857         address[] memory payees_,
1858         uint256[] memory shares_,
1859         address owner_
1860     ) PaymentSplitter(payees_, shares_) {
1861         transferOwnership(owner_);
1862     }
1863 
1864     function addPayee(address payee, uint256 shares) public onlyOwner {
1865         _addPayee(payee, shares);
1866     }
1867 
1868     function updatePayee(uint256 payeeIndex, uint256 shares) public onlyOwner {
1869         _updatePayee(payeeIndex, shares);
1870     }
1871 
1872     function removePayee(uint256 payeeIndex) public onlyOwner {
1873         _removePayee(payeeIndex);
1874     }
1875 }
1876 
1877 
1878 
1879 
1880 /**
1881  * @dev These functions deal with verification of Merkle Trees proofs.
1882  *
1883  * The proofs can be generated using the JavaScript library
1884  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1885  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1886  *
1887  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1888  */
1889 library MerkleProof {
1890     /**
1891      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1892      * defined by `root`. For this, a `proof` must be provided, containing
1893      * sibling hashes on the branch from the leaf to the root of the tree. Each
1894      * pair of leaves and each pair of pre-images are assumed to be sorted.
1895      */
1896     function verify(
1897         bytes32[] memory proof,
1898         bytes32 root,
1899         bytes32 leaf
1900     ) internal pure returns (bool) {
1901         return processProof(proof, leaf) == root;
1902     }
1903 
1904     /**
1905      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1906      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1907      * hash matches the root of the tree. When processing the proof, the pairs
1908      * of leafs & pre-images are assumed to be sorted.
1909      *
1910      * _Available since v4.4._
1911      */
1912     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1913         bytes32 computedHash = leaf;
1914         for (uint256 i = 0; i < proof.length; i++) {
1915             bytes32 proofElement = proof[i];
1916             if (computedHash <= proofElement) {
1917                 // Hash(current computed hash + current element of the proof)
1918                 computedHash = _efficientHash(computedHash, proofElement);
1919             } else {
1920                 // Hash(current element of the proof + current computed hash)
1921                 computedHash = _efficientHash(proofElement, computedHash);
1922             }
1923         }
1924         return computedHash;
1925     }
1926 
1927     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1928         assembly {
1929             mstore(0x00, a)
1930             mstore(0x20, b)
1931             value := keccak256(0x00, 0x40)
1932         }
1933     }
1934 }
1935 
1936 
1937 
1938 
1939 library Bytecode {
1940   error InvalidCodeAtRange(uint256 _size, uint256 _start, uint256 _end);
1941 
1942   /**
1943     @notice Generate a creation code that results on a contract with `_code` as bytecode
1944     @param _code The returning value of the resulting `creationCode`
1945     @return creationCode (constructor) for new contract
1946   */
1947   function creationCodeFor(bytes memory _code) internal pure returns (bytes memory) {
1948     /*
1949       0x00    0x63         0x63XXXXXX  PUSH4 _code.length  size
1950       0x01    0x80         0x80        DUP1                size size
1951       0x02    0x60         0x600e      PUSH1 14            14 size size
1952       0x03    0x60         0x6000      PUSH1 00            0 14 size size
1953       0x04    0x39         0x39        CODECOPY            size
1954       0x05    0x60         0x6000      PUSH1 00            0 size
1955       0x06    0xf3         0xf3        RETURN
1956       <CODE>
1957     */
1958 
1959     return abi.encodePacked(
1960       hex"63",
1961       uint32(_code.length),
1962       hex"80_60_0E_60_00_39_60_00_F3",
1963       _code
1964     );
1965   }
1966 
1967   /**
1968     @notice Returns the size of the code on a given address
1969     @param _addr Address that may or may not contain code
1970     @return size of the code on the given `_addr`
1971   */
1972   function codeSize(address _addr) internal view returns (uint256 size) {
1973     assembly { size := extcodesize(_addr) }
1974   }
1975 
1976   /**
1977     @notice Returns the code of a given address
1978     @dev It will fail if `_end < _start`
1979     @param _addr Address that may or may not contain code
1980     @param _start number of bytes of code to skip on read
1981     @param _end index before which to end extraction
1982     @return oCode read from `_addr` deployed bytecode
1983 
1984     Forked from: https://gist.github.com/KardanovIR/fe98661df9338c842b4a30306d507fbd
1985   */
1986   function codeAt(address _addr, uint256 _start, uint256 _end) internal view returns (bytes memory oCode) {
1987     uint256 csize = codeSize(_addr);
1988     if (csize == 0) return bytes("");
1989 
1990     if (_start > csize) return bytes("");
1991     if (_end < _start) revert InvalidCodeAtRange(csize, _start, _end); 
1992 
1993     unchecked {
1994       uint256 reqSize = _end - _start;
1995       uint256 maxSize = csize - _start;
1996 
1997       uint256 size = maxSize < reqSize ? maxSize : reqSize;
1998 
1999       assembly {
2000         // allocate output byte array - this could also be done without assembly
2001         // by using o_code = new bytes(size)
2002         oCode := mload(0x40)
2003         // new "memory end" including padding
2004         mstore(0x40, add(oCode, and(add(add(size, 0x20), 0x1f), not(0x1f))))
2005         // store length in memory
2006         mstore(oCode, size)
2007         // actually retrieve the code, this needs assembly
2008         extcodecopy(_addr, add(oCode, 0x20), _start, size)
2009       }
2010     }
2011   }
2012 }
2013 
2014 
2015 /**
2016   @title A key-value storage with auto-generated keys for storing chunks of data with a lower write & read cost.
2017   @author Agustin Aguilar <aa@horizon.io>
2018 
2019   Readme: https://github.com/0xsequence/sstore2#readme
2020 */
2021 library SSTORE2 {
2022   error WriteError();
2023 
2024   /**
2025     @notice Stores `_data` and returns `pointer` as key for later retrieval
2026     @dev The pointer is a contract address with `_data` as code
2027     @param _data to be written
2028     @return pointer Pointer to the written `_data`
2029   */
2030   function write(bytes memory _data) internal returns (address pointer) {
2031     // Append 00 to _data so contract can't be called
2032     // Build init code
2033     bytes memory code = Bytecode.creationCodeFor(
2034       abi.encodePacked(
2035         hex'00',
2036         _data
2037       )
2038     );
2039 
2040     // Deploy contract using create
2041     assembly { pointer := create(0, add(code, 32), mload(code)) }
2042 
2043     // Address MUST be non-zero
2044     if (pointer == address(0)) revert WriteError();
2045   }
2046 
2047   /**
2048     @notice Reads the contents of the `_pointer` code as data, skips the first byte 
2049     @dev The function is intended for reading pointers generated by `write`
2050     @param _pointer to be read
2051     @return data read from `_pointer` contract
2052   */
2053   function read(address _pointer) internal view returns (bytes memory) {
2054     return Bytecode.codeAt(_pointer, 1, type(uint256).max);
2055   }
2056 
2057   /**
2058     @notice Reads the contents of the `_pointer` code as data, skips the first byte 
2059     @dev The function is intended for reading pointers generated by `write`
2060     @param _pointer to be read
2061     @param _start number of bytes to skip
2062     @return data read from `_pointer` contract
2063   */
2064   function read(address _pointer, uint256 _start) internal view returns (bytes memory) {
2065     return Bytecode.codeAt(_pointer, _start + 1, type(uint256).max);
2066   }
2067 
2068   /**
2069     @notice Reads the contents of the `_pointer` code as data, skips the first byte 
2070     @dev The function is intended for reading pointers generated by `write`
2071     @param _pointer to be read
2072     @param _start number of bytes to skip
2073     @param _end index before which to end extraction
2074     @return data read from `_pointer` contract
2075   */
2076   function read(address _pointer, uint256 _start, uint256 _end) internal view returns (bytes memory) {
2077     return Bytecode.codeAt(_pointer, _start + 1, _end + 1);
2078   }
2079 }
2080 
2081 error MintingLimitReached();
2082 error SeedAlreadyUsed();
2083 error InvalidProof();
2084 error InsufficientBalance(uint256 balance);
2085 error NotAllowlisted();
2086 error SameLengthRequired();
2087 
2088 contract MixedStems_V1 is ERC721A, IERC2981, Ownable {
2089     using Strings for uint256;
2090     using Address for address payable;
2091 
2092     type SongID is uint256;
2093     type TrackID is uint256;
2094 
2095     enum Phase {
2096         INIT,
2097         ALLOWLIST,
2098         PUBLIC,
2099         RESERVE
2100     }
2101 
2102     Royalties_V1 public immutable royaltyContract;
2103     uint256 public royaltyPercent;
2104 
2105     string public baseURI;
2106 
2107     uint256 public numVariableTracks;
2108     uint256 public mintPrice;
2109     uint256 public maxSupply;
2110 
2111     // metadata values
2112     string public composer;
2113     string private _singular;
2114     string public description;
2115 
2116     // song ID -> track ID -> array of pointers to SSTORE2 MIDI data
2117     mapping(SongID => mapping(TrackID => address[])) private _tracks;
2118     // song ID -> array of pointers to SSTORE2 MIDI data
2119     mapping(SongID => address[]) private _staticTracks;
2120     // song ID -> time division
2121     mapping(SongID => bytes2) private _timeDivisions;
2122     // tokenID -> variant ID
2123     mapping(uint256 => uint256) private _variants;
2124     // song ID -> song name
2125     mapping(SongID => string) private _songNames;
2126 
2127     Phase public mintingPhase;
2128 
2129     bytes32 private _allSeedsMerkleRoot;
2130     // tokenID -> seed
2131     mapping(uint256 => bytes32) private _seeds;
2132     // seed -> used
2133     mapping(bytes32 => bool) private _seedUsed;
2134     // seed -> tokenID
2135     mapping(bytes32 => uint256) private _seedTokenID;
2136 
2137     bytes32 private _allowlistMerkleRoot;
2138 
2139     // MODIFIERS -----------------------------------------------------
2140 
2141     modifier onlyPhase(Phase _phase) {
2142         require(mintingPhase == _phase, "Wrong phase");
2143         _;
2144     }
2145 
2146     modifier mustPrice(uint256 _price) {
2147         require(msg.value == _price, "Wrong price");
2148         _;
2149     }
2150 
2151     // CONSTRUCTOR ---------------------------------------------------
2152 
2153     constructor(
2154         string memory baseURI_,
2155         string memory name_,
2156         string memory singular_,
2157         string memory description_,
2158         string memory symbol_,
2159         string memory composer_,
2160         uint256 numVariableTracks_,
2161         address[] memory royaltyReceivers_,
2162         uint256[] memory royaltyShares_,
2163         uint256 royaltyPercent_
2164     ) ERC721A(name_, symbol_) {
2165         baseURI = baseURI_;
2166         _singular = singular_;
2167         description = description_;
2168         numVariableTracks = numVariableTracks_;
2169         composer = composer_;
2170         Royalties_V1 p = new Royalties_V1(
2171             royaltyReceivers_,
2172             royaltyShares_,
2173             msg.sender
2174         );
2175         royaltyContract = p;
2176         royaltyPercent = royaltyPercent_;
2177     }
2178 
2179     // ADMIN FUNCTIONS ---------------------------------------------------
2180 
2181     function withdraw(address payable to, uint256 amount) public onlyOwner {
2182         if (address(this).balance < amount) {
2183             revert InsufficientBalance(address(this).balance);
2184         }
2185 
2186         if (amount == 0) {
2187             amount = address(this).balance;
2188         }
2189         if (to == address(0)) {
2190             to = payable(owner());
2191         }
2192         to.sendValue(amount);
2193     }
2194 
2195     function setBaseURI(string memory _baseURI) public onlyOwner {
2196         baseURI = _baseURI;
2197     }
2198 
2199     function setComposer(string memory composer_) public onlyOwner {
2200         composer = composer_;
2201     }
2202 
2203     function setDescription(string memory description_) public onlyOwner {
2204         description = description_;
2205     }
2206     
2207     function startAllowlistMint(uint256 supply) public onlyOwner {
2208         mintingPhase = Phase.ALLOWLIST;
2209         maxSupply = supply;
2210     }
2211 
2212     function startPublicMint(uint256 supply) public onlyOwner {
2213         mintingPhase = Phase.PUBLIC;
2214         maxSupply = supply;
2215     }
2216 
2217     function startReserveMint(uint256 supply) public onlyOwner {
2218         mintingPhase = Phase.RESERVE;
2219         maxSupply = supply;
2220     }
2221 
2222     function disableMint() public onlyOwner {
2223         mintingPhase = Phase.INIT;
2224     }
2225 
2226     function setMintPrice(uint256 value) public onlyOwner {
2227         mintPrice = value;
2228     }
2229 
2230     function setAllSeedsMerkleRoot(bytes32 value) public onlyOwner {
2231         _allSeedsMerkleRoot = value;
2232     }
2233 
2234     function setAllowlistMerkleRoot(bytes32 value) public onlyOwner {
2235         _allowlistMerkleRoot = value;
2236     }
2237 
2238     function setRoyaltyPercentage(uint256 percent) public onlyOwner {
2239         royaltyPercent = percent;
2240     }
2241 
2242     function setSongNames(SongID[] memory songs, string[] memory songNames)
2243         public
2244         onlyOwner
2245     {
2246         require(songs.length == songNames.length);
2247         for (uint256 i = 0; i < songNames.length; i++) {
2248             _songNames[songs[i]] = songNames[i];
2249         }
2250     }
2251 
2252     function addVariableTrack(
2253         SongID song,
2254         TrackID trackNum,
2255         bytes calldata track
2256     ) external onlyOwner {
2257         require(TrackID.unwrap(trackNum) < numVariableTracks);
2258         address pointer = SSTORE2.write(track);
2259         _tracks[song][trackNum].push(pointer);
2260     }
2261 
2262     function removeVariableTrack(
2263         SongID song,
2264         TrackID trackNum,
2265         uint256 index
2266     ) external onlyOwner {
2267          _tracks[song][trackNum][index] = _tracks[song][trackNum][_tracks[song][trackNum].length - 1];
2268          _tracks[song][trackNum].pop();
2269     }
2270 
2271     function resetVariableTracks(
2272         SongID song,
2273         TrackID trackNum
2274     )
2275         external
2276         onlyOwner
2277     {
2278         delete _tracks[song][trackNum];
2279     }
2280 
2281     function addStaticTrack(SongID song, bytes calldata track)
2282         external
2283         onlyOwner
2284     {
2285         address pointer = SSTORE2.write(track);
2286         _staticTracks[song].push(pointer);
2287     }
2288 
2289     function removeStaticTrack(SongID song, uint256 index)
2290         external
2291         onlyOwner
2292     {
2293         _staticTracks[song][index] = _staticTracks[song][_staticTracks[song].length - 1];
2294         _staticTracks[song].pop();
2295     }
2296 
2297     function resetStaticTracks(SongID song) external onlyOwner {
2298         delete _staticTracks[song];
2299     }
2300 
2301     function setTimeDivision(SongID song, bytes2 timeDivision)
2302         public
2303         onlyOwner
2304     {
2305         _timeDivisions[song] = timeDivision;
2306     }
2307 
2308     // ERC-721 FUNCTIONS ---------------------------------------------------
2309 
2310     function tokenURI(uint256 tokenId)
2311         public
2312         view
2313         override
2314         returns (string memory)
2315     {
2316         if (!_exists(tokenId)) {
2317             revert URIQueryForNonexistentToken();
2318         }
2319         bytes32 seed = _seeds[tokenId];
2320 
2321         SongID song = SongID.wrap(uint8(seed[0]));
2322 
2323         string memory mid = midi(tokenId);
2324 
2325         bytes memory json = abi.encodePacked(
2326             '{"name":"',
2327             _singular,
2328             " #",
2329             tokenId.toString(),
2330             '", "description": "',
2331             description,
2332             '", "image": "',
2333             baseURI,
2334             "/image/",
2335             uint256(seed).toHexString(),
2336             '", "animation_url": "',
2337             baseURI,
2338             "/animation/",
2339             uint256(seed).toHexString()
2340         );
2341         json = abi.encodePacked(
2342             json,
2343             '", "midi": "data:audio/midi;base64,',
2344             mid,
2345             '", "external_url": "https://beatfoundry.xyz", "composer": "',
2346             composer,
2347             '", "attributes": [{"trait_type": "Song", "value": '
2348         );
2349         if (bytes(_songNames[song]).length > 0) {
2350             json = abi.encodePacked(json, '"', _songNames[song], '"}');
2351         } else {
2352             json = abi.encodePacked(json, '"',SongID.unwrap(song).toString(), '"}');
2353         }
2354 
2355         json = abi.encodePacked(
2356             json,
2357             ', {"trait_type": "Cover", "value": "',
2358             _variants[tokenId].toString(),
2359             '"}'
2360         );
2361         
2362         for (uint256 i = 0; i < numVariableTracks; i++) {
2363             json = abi.encodePacked(
2364                 json,
2365                 ', {"trait_type": "Stem ',
2366                 (i + 1).toString(),
2367                 '", "value": "',
2368                 uint256(uint8(seed[i + 1])).toString(),
2369                 '"}'
2370             );
2371         }
2372         json = abi.encodePacked(json, "]}");
2373         return
2374             string(
2375                 abi.encodePacked(
2376                     "data:application/json;base64,",
2377                     Base64.encode(json)
2378                 )
2379             );
2380     }
2381 
2382     function midi(uint256 tokenId) public view returns (string memory) {
2383         if (!_exists(tokenId)) {
2384             revert URIQueryForNonexistentToken();
2385         }
2386         bytes32 seed = _seeds[tokenId];
2387 
2388         SongID song = SongID.wrap(uint8(seed[0]));
2389 
2390         bytes memory mid = newMidi(6, song);
2391 
2392         uint256 lenStatic = _staticTracks[song].length;
2393 
2394         for (uint256 i = 0; i < numVariableTracks; i++) {
2395             bytes memory track = SSTORE2.read(
2396                 _tracks[song][TrackID.wrap(i)][uint8(seed[i + 1])]
2397             );
2398             mid = bytes.concat(mid, newTrack(track));
2399         }
2400 
2401         for (uint256 i = 0; i < lenStatic; i++) {
2402             bytes memory track = SSTORE2.read(_staticTracks[song][i]);
2403             mid = bytes.concat(mid, newTrack(track));
2404         }
2405 
2406         return Base64.encode(mid);
2407     }
2408 
2409     function getSeedTokenID(bytes32 seed) public view returns (uint256) {
2410         return _seedTokenID[seed];
2411     }
2412 
2413     function getVariant(uint256 tokenId) public view returns (uint256) {
2414         if (!_exists(tokenId)) {
2415             revert URIQueryForNonexistentToken();
2416         }
2417         return _variants[tokenId];
2418     }
2419 
2420     // MINTING FUNCTIONS ---------------------------------------------------
2421 
2422     function mint(
2423         address to,
2424         bytes32 seed,
2425         uint256 variant,
2426         bytes calldata pass,
2427         bytes32[] calldata seedProof
2428     ) external payable onlyPhase(Phase.PUBLIC) mustPrice(mintPrice) {
2429       
2430         if (_currentIndex >= maxSupply) {
2431             revert MintingLimitReached();
2432         }
2433 
2434         if (_seedUsed[seed]) {
2435             revert SeedAlreadyUsed();
2436         } 
2437 
2438         if (!isValidSeedPassCombo(seed, variant, pass, seedProof)) {
2439             revert InvalidProof();
2440         }
2441         _seeds[_currentIndex] = seed;
2442         _variants[_currentIndex] = variant;
2443         _seedTokenID[seed] = _currentIndex;
2444         _seedUsed[seed] = true; 
2445 
2446         _mint(to, 1, bytes(""), true);
2447     }
2448 
2449     function mintReserve(address to, bytes32[] calldata seeds, uint256[] calldata variants)
2450         external
2451         virtual
2452         onlyOwner
2453         onlyPhase(Phase.RESERVE)
2454     {
2455         if (_currentIndex >= maxSupply) {
2456             revert MintingLimitReached();
2457         }
2458         if (seeds.length != variants.length) {
2459             revert SameLengthRequired();
2460         }
2461         for (uint256 i = 0; i < seeds.length; i++) {
2462             bytes32 seed = seeds[i];
2463             if (_seedUsed[seed]) {
2464                 revert SeedAlreadyUsed();
2465             }
2466             _seeds[_currentIndex + i] = seed;
2467              _seedTokenID[seed] = _currentIndex + i;
2468             _seedUsed[seed] = true;
2469         }
2470         _mint(to, seeds.length, bytes(""), true);
2471     }
2472 
2473     function mintAllowlist(
2474         address to,
2475         bytes32[] calldata seeds,
2476         uint256[] calldata variants,
2477         bytes32[][] calldata allowlistProofs
2478     )
2479         external
2480         payable
2481         onlyPhase(Phase.ALLOWLIST)
2482         mustPrice(mintPrice * seeds.length)
2483     {
2484         if (_currentIndex >= maxSupply) {
2485             revert MintingLimitReached();
2486         }
2487         if (seeds.length != allowlistProofs.length || seeds.length != variants.length) {
2488             revert SameLengthRequired();
2489         }
2490         for (uint256 i = 0; i < seeds.length; i++) {
2491             bytes32 seed = seeds[i];
2492             if (!isAllowlistedFor(to, seed, variants[i], allowlistProofs[i])) {
2493                 revert NotAllowlisted();
2494             }
2495             if (_seedUsed[seed]) {
2496                 revert SeedAlreadyUsed();
2497             }
2498             _seeds[_currentIndex + i] = seed;
2499             _seedTokenID[seed] = _currentIndex + i;
2500             _variants[_currentIndex + i] = variants[i];
2501             _seedUsed[seed] = true;
2502         }
2503 
2504         _mint(to, seeds.length, bytes(""), true);
2505     }
2506 
2507     // MIDI FUNCTIONS ---------------------------------------------------
2508 
2509     function newMidi(uint8 numTracks, SongID song)
2510         private
2511         view
2512         returns (bytes memory)
2513     {
2514         bytes2 timeDivision = _timeDivisions[song];
2515         if (uint16(timeDivision) == 0) {
2516             timeDivision = bytes2(uint16(256));
2517         }
2518         bytes memory data = new bytes(14);
2519         data[0] = bytes1(0x4D);
2520         data[1] = bytes1(0x54);
2521         data[2] = bytes1(0x68);
2522         data[3] = bytes1(0x64);
2523         data[4] = bytes1(0x00);
2524         data[5] = bytes1(0x00);
2525         data[6] = bytes1(0x00);
2526         data[7] = bytes1(0x06);
2527         data[8] = bytes1(0x00);
2528         if (numTracks == 1) {
2529             data[9] = bytes1(0x00);
2530         } else {
2531             data[9] = bytes1(0x01);
2532         }
2533         data[10] = bytes1(0x00);
2534         data[11] = bytes1(numTracks);
2535         data[12] = timeDivision[0];
2536         data[13] = timeDivision[1];
2537         return data;
2538     }
2539 
2540     function newTrack(bytes memory data) private pure returns (bytes memory) {
2541         bytes memory it = new bytes(8);
2542         it[0] = bytes1(0x4D);
2543         it[1] = bytes1(0x54);
2544         it[2] = bytes1(0x72);
2545         it[3] = bytes1(0x6b);
2546         bytes memory asBytes = abi.encodePacked(data.length);
2547         it[4] = asBytes[asBytes.length - 4];
2548         it[5] = asBytes[asBytes.length - 3];
2549         it[6] = asBytes[asBytes.length - 2];
2550         it[7] = asBytes[asBytes.length - 1];
2551         return bytes.concat(it, data);
2552     }
2553 
2554     // ROYALTIES ---------------------------------------------------------------
2555     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
2556         external
2557         view
2558         override
2559         returns (address receiver, uint256 royaltyAmount)
2560     {
2561         return (address(royaltyContract), (_salePrice / 100) * royaltyPercent);
2562     }
2563 
2564     // HELPERS ------------------------------------------------------------------
2565 
2566     function isAllowlistedFor(
2567         address _allowlistee,
2568         bytes32 _seed,
2569         uint256 _variant,
2570         bytes32[] calldata _proof
2571     ) private view returns (bool) {
2572         return
2573             MerkleProof.verify(
2574                 _proof,
2575                 _allowlistMerkleRoot,
2576                 keccak256(abi.encodePacked(_allowlistee, _seed, _variant))
2577             );
2578     }
2579 
2580     function isValidSeedPassCombo(
2581         bytes32 _seed,
2582         uint256 _variant,
2583         bytes calldata _pass,
2584         bytes32[] calldata _proof
2585     ) private view returns (bool) {
2586         return
2587             MerkleProof.verify(
2588                 _proof,
2589                 _allSeedsMerkleRoot,
2590                 keccak256(abi.encodePacked(keccak256(_pass), _seed, _variant))
2591             );
2592     }
2593 }