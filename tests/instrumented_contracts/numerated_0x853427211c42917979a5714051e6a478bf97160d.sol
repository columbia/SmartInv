1 /** 
2  *  SourceUnit: /home/clayrisser/Desktop/Outlaw.sol
3 */
4 
5 
6 /** 
7  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
8 */
9             
10 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
11 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Interface of the ERC165 standard, as defined in the
17  * https://eips.ethereum.org/EIPS/eip-165[EIP].
18  *
19  * Implementers can declare support of contract interfaces, which can then be
20  * queried by others ({ERC165Checker}).
21  *
22  * For an implementation, see {ERC165}.
23  */
24 interface IERC165 {
25     /**
26      * @dev Returns true if this contract implements the interface defined by
27      * `interfaceId`. See the corresponding
28      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
29      * to learn more about how these ids are created.
30      *
31      * This function call must use less than 30 000 gas.
32      */
33     function supportsInterface(bytes4 interfaceId) external view returns (bool);
34 }
35 
36 
37 
38 
39 /** 
40  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
41 */
42             
43 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
44 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
45 
46 pragma solidity ^0.8.0;
47 
48 ////////import "../../utils/introspection/IERC165.sol";
49 
50 /**
51  * @dev Required interface of an ERC721 compliant contract.
52  */
53 interface IERC721 is IERC165 {
54     /**
55      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
56      */
57     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
58 
59     /**
60      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
61      */
62     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
63 
64     /**
65      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
66      */
67     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
68 
69     /**
70      * @dev Returns the number of tokens in ``owner``'s account.
71      */
72     function balanceOf(address owner) external view returns (uint256 balance);
73 
74     /**
75      * @dev Returns the owner of the `tokenId` token.
76      *
77      * Requirements:
78      *
79      * - `tokenId` must exist.
80      */
81     function ownerOf(uint256 tokenId) external view returns (address owner);
82 
83     /**
84      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
85      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must exist and be owned by `from`.
92      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
93      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
94      *
95      * Emits a {Transfer} event.
96      */
97     function safeTransferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     /**
104      * @dev Transfers `tokenId` token from `from` to `to`.
105      *
106      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must be owned by `from`.
113      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(
118         address from,
119         address to,
120         uint256 tokenId
121     ) external;
122 
123     /**
124      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
125      * The approval is cleared when the token is transferred.
126      *
127      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
128      *
129      * Requirements:
130      *
131      * - The caller must own the token or be an approved operator.
132      * - `tokenId` must exist.
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address to, uint256 tokenId) external;
137 
138     /**
139      * @dev Returns the account approved for `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function getApproved(uint256 tokenId) external view returns (address operator);
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
161      *
162      * See {setApprovalForAll}
163      */
164     function isApprovedForAll(address owner, address operator) external view returns (bool);
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId,
183         bytes calldata data
184     ) external;
185 }
186 
187 
188 
189 
190 /** 
191  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
192 */
193             
194 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
195 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 ////////import "./IERC165.sol";
200 
201 /**
202  * @dev Implementation of the {IERC165} interface.
203  *
204  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
205  * for the additional interface id that will be supported. For example:
206  *
207  * ```solidity
208  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
209  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
210  * }
211  * ```
212  *
213  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
214  */
215 abstract contract ERC165 is IERC165 {
216     /**
217      * @dev See {IERC165-supportsInterface}.
218      */
219     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
220         return interfaceId == type(IERC165).interfaceId;
221     }
222 }
223 
224 
225 
226 
227 /** 
228  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
229 */
230             
231 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
232 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev String operations.
238  */
239 library Strings {
240     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
241 
242     /**
243      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
244      */
245     function toString(uint256 value) internal pure returns (string memory) {
246         // Inspired by OraclizeAPI's implementation - MIT licence
247         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
248 
249         if (value == 0) {
250             return "0";
251         }
252         uint256 temp = value;
253         uint256 digits;
254         while (temp != 0) {
255             digits++;
256             temp /= 10;
257         }
258         bytes memory buffer = new bytes(digits);
259         while (value != 0) {
260             digits -= 1;
261             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
262             value /= 10;
263         }
264         return string(buffer);
265     }
266 
267     /**
268      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
269      */
270     function toHexString(uint256 value) internal pure returns (string memory) {
271         if (value == 0) {
272             return "0x00";
273         }
274         uint256 temp = value;
275         uint256 length = 0;
276         while (temp != 0) {
277             length++;
278             temp >>= 8;
279         }
280         return toHexString(value, length);
281     }
282 
283     /**
284      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
285      */
286     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
287         bytes memory buffer = new bytes(2 * length + 2);
288         buffer[0] = "0";
289         buffer[1] = "x";
290         for (uint256 i = 2 * length + 1; i > 1; --i) {
291             buffer[i] = _HEX_SYMBOLS[value & 0xf];
292             value >>= 4;
293         }
294         require(value == 0, "Strings: hex length insufficient");
295         return string(buffer);
296     }
297 }
298 
299 
300 
301 
302 /** 
303  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
304 */
305             
306 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
307 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @dev Provides information about the current execution context, including the
313  * sender of the transaction and its data. While these are generally available
314  * via msg.sender and msg.data, they should not be accessed in such a direct
315  * manner, since when dealing with meta-transactions the account sending and
316  * paying for execution may not be the actual sender (as far as an application
317  * is concerned).
318  *
319  * This contract is only required for intermediate, library-like contracts.
320  */
321 abstract contract Context {
322     function _msgSender() internal view virtual returns (address) {
323         return msg.sender;
324     }
325 
326     function _msgData() internal view virtual returns (bytes calldata) {
327         return msg.data;
328     }
329 }
330 
331 
332 
333 
334 /** 
335  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
336 */
337             
338 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
339 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
340 
341 pragma solidity ^0.8.1;
342 
343 /**
344  * @dev Collection of functions related to the address type
345  */
346 library Address {
347     /**
348      * @dev Returns true if `account` is a contract.
349      *
350      * [////////IMPORTANT]
351      * ====
352      * It is unsafe to assume that an address for which this function returns
353      * false is an externally-owned account (EOA) and not a contract.
354      *
355      * Among others, `isContract` will return false for the following
356      * types of addresses:
357      *
358      *  - an externally-owned account
359      *  - a contract in construction
360      *  - an address where a contract will be created
361      *  - an address where a contract lived, but was destroyed
362      * ====
363      *
364      * [IMPORTANT]
365      * ====
366      * You shouldn't rely on `isContract` to protect against flash loan attacks!
367      *
368      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
369      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
370      * constructor.
371      * ====
372      */
373     function isContract(address account) internal view returns (bool) {
374         // This method relies on extcodesize/address.code.length, which returns 0
375         // for contracts in construction, since the code is only stored at the end
376         // of the constructor execution.
377 
378         return account.code.length > 0;
379     }
380 
381     /**
382      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
383      * `recipient`, forwarding all available gas and reverting on errors.
384      *
385      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
386      * of certain opcodes, possibly making contracts go over the 2300 gas limit
387      * imposed by `transfer`, making them unable to receive funds via
388      * `transfer`. {sendValue} removes this limitation.
389      *
390      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
391      *
392      * ////////IMPORTANT: because control is transferred to `recipient`, care must be
393      * taken to not create reentrancy vulnerabilities. Consider using
394      * {ReentrancyGuard} or the
395      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
396      */
397     function sendValue(address payable recipient, uint256 amount) internal {
398         require(address(this).balance >= amount, "Address: insufficient balance");
399 
400         (bool success, ) = recipient.call{value: amount}("");
401         require(success, "Address: unable to send value, recipient may have reverted");
402     }
403 
404     /**
405      * @dev Performs a Solidity function call using a low level `call`. A
406      * plain `call` is an unsafe replacement for a function call: use this
407      * function instead.
408      *
409      * If `target` reverts with a revert reason, it is bubbled up by this
410      * function (like regular Solidity function calls).
411      *
412      * Returns the raw returned data. To convert to the expected return value,
413      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
414      *
415      * Requirements:
416      *
417      * - `target` must be a contract.
418      * - calling `target` with `data` must not revert.
419      *
420      * _Available since v3.1._
421      */
422     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
423         return functionCall(target, data, "Address: low-level call failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
428      * `errorMessage` as a fallback revert reason when `target` reverts.
429      *
430      * _Available since v3.1._
431      */
432     function functionCall(
433         address target,
434         bytes memory data,
435         string memory errorMessage
436     ) internal returns (bytes memory) {
437         return functionCallWithValue(target, data, 0, errorMessage);
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442      * but also transferring `value` wei to `target`.
443      *
444      * Requirements:
445      *
446      * - the calling contract must have an ETH balance of at least `value`.
447      * - the called Solidity function must be `payable`.
448      *
449      * _Available since v3.1._
450      */
451     function functionCallWithValue(
452         address target,
453         bytes memory data,
454         uint256 value
455     ) internal returns (bytes memory) {
456         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
461      * with `errorMessage` as a fallback revert reason when `target` reverts.
462      *
463      * _Available since v3.1._
464      */
465     function functionCallWithValue(
466         address target,
467         bytes memory data,
468         uint256 value,
469         string memory errorMessage
470     ) internal returns (bytes memory) {
471         require(address(this).balance >= value, "Address: insufficient balance for call");
472         require(isContract(target), "Address: call to non-contract");
473 
474         (bool success, bytes memory returndata) = target.call{value: value}(data);
475         return verifyCallResult(success, returndata, errorMessage);
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
480      * but performing a static call.
481      *
482      * _Available since v3.3._
483      */
484     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
485         return functionStaticCall(target, data, "Address: low-level static call failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
490      * but performing a static call.
491      *
492      * _Available since v3.3._
493      */
494     function functionStaticCall(
495         address target,
496         bytes memory data,
497         string memory errorMessage
498     ) internal view returns (bytes memory) {
499         require(isContract(target), "Address: static call to non-contract");
500 
501         (bool success, bytes memory returndata) = target.staticcall(data);
502         return verifyCallResult(success, returndata, errorMessage);
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
507      * but performing a delegate call.
508      *
509      * _Available since v3.4._
510      */
511     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
512         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
517      * but performing a delegate call.
518      *
519      * _Available since v3.4._
520      */
521     function functionDelegateCall(
522         address target,
523         bytes memory data,
524         string memory errorMessage
525     ) internal returns (bytes memory) {
526         require(isContract(target), "Address: delegate call to non-contract");
527 
528         (bool success, bytes memory returndata) = target.delegatecall(data);
529         return verifyCallResult(success, returndata, errorMessage);
530     }
531 
532     /**
533      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
534      * revert reason using the provided one.
535      *
536      * _Available since v4.3._
537      */
538     function verifyCallResult(
539         bool success,
540         bytes memory returndata,
541         string memory errorMessage
542     ) internal pure returns (bytes memory) {
543         if (success) {
544             return returndata;
545         } else {
546             // Look for revert reason and bubble it up if present
547             if (returndata.length > 0) {
548                 // The easiest way to bubble the revert reason is using memory via assembly
549 
550                 assembly {
551                     let returndata_size := mload(returndata)
552                     revert(add(32, returndata), returndata_size)
553                 }
554             } else {
555                 revert(errorMessage);
556             }
557         }
558     }
559 }
560 
561 
562 
563 
564 /** 
565  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
566 */
567             
568 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
569 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 ////////import "../IERC721.sol";
574 
575 /**
576  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
577  * @dev See https://eips.ethereum.org/EIPS/eip-721
578  */
579 interface IERC721Metadata is IERC721 {
580     /**
581      * @dev Returns the token collection name.
582      */
583     function name() external view returns (string memory);
584 
585     /**
586      * @dev Returns the token collection symbol.
587      */
588     function symbol() external view returns (string memory);
589 
590     /**
591      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
592      */
593     function tokenURI(uint256 tokenId) external view returns (string memory);
594 }
595 
596 
597 
598 
599 /** 
600  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
601 */
602             
603 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
604 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 /**
609  * @title ERC721 token receiver interface
610  * @dev Interface for any contract that wants to support safeTransfers
611  * from ERC721 asset contracts.
612  */
613 interface IERC721Receiver {
614     /**
615      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
616      * by `operator` from `from`, this function is called.
617      *
618      * It must return its Solidity selector to confirm the token transfer.
619      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
620      *
621      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
622      */
623     function onERC721Received(
624         address operator,
625         address from,
626         uint256 tokenId,
627         bytes calldata data
628     ) external returns (bytes4);
629 }
630 
631 
632 
633 
634 /** 
635  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
636 */
637             
638 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
639 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 ////////import "./IERC721.sol";
644 ////////import "./IERC721Receiver.sol";
645 ////////import "./extensions/IERC721Metadata.sol";
646 ////////import "../../utils/Address.sol";
647 ////////import "../../utils/Context.sol";
648 ////////import "../../utils/Strings.sol";
649 ////////import "../../utils/introspection/ERC165.sol";
650 
651 /**
652  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
653  * the Metadata extension, but not including the Enumerable extension, which is available separately as
654  * {ERC721Enumerable}.
655  */
656 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
657     using Address for address;
658     using Strings for uint256;
659 
660     // Token name
661     string private _name;
662 
663     // Token symbol
664     string private _symbol;
665 
666     // Mapping from token ID to owner address
667     mapping(uint256 => address) private _owners;
668 
669     // Mapping owner address to token count
670     mapping(address => uint256) private _balances;
671 
672     // Mapping from token ID to approved address
673     mapping(uint256 => address) private _tokenApprovals;
674 
675     // Mapping from owner to operator approvals
676     mapping(address => mapping(address => bool)) private _operatorApprovals;
677 
678     /**
679      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
680      */
681     constructor(string memory name_, string memory symbol_) {
682         _name = name_;
683         _symbol = symbol_;
684     }
685 
686     /**
687      * @dev See {IERC165-supportsInterface}.
688      */
689     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
690         return
691             interfaceId == type(IERC721).interfaceId ||
692             interfaceId == type(IERC721Metadata).interfaceId ||
693             super.supportsInterface(interfaceId);
694     }
695 
696     /**
697      * @dev See {IERC721-balanceOf}.
698      */
699     function balanceOf(address owner) public view virtual override returns (uint256) {
700         require(owner != address(0), "ERC721: balance query for the zero address");
701         return _balances[owner];
702     }
703 
704     /**
705      * @dev See {IERC721-ownerOf}.
706      */
707     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
708         address owner = _owners[tokenId];
709         require(owner != address(0), "ERC721: owner query for nonexistent token");
710         return owner;
711     }
712 
713     /**
714      * @dev See {IERC721Metadata-name}.
715      */
716     function name() public view virtual override returns (string memory) {
717         return _name;
718     }
719 
720     /**
721      * @dev See {IERC721Metadata-symbol}.
722      */
723     function symbol() public view virtual override returns (string memory) {
724         return _symbol;
725     }
726 
727     /**
728      * @dev See {IERC721Metadata-tokenURI}.
729      */
730     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
731         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
732 
733         string memory baseURI = _baseURI();
734         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
735     }
736 
737     /**
738      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
739      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
740      * by default, can be overriden in child contracts.
741      */
742     function _baseURI() internal view virtual returns (string memory) {
743         return "";
744     }
745 
746     /**
747      * @dev See {IERC721-approve}.
748      */
749     function approve(address to, uint256 tokenId) public virtual override {
750         address owner = ERC721.ownerOf(tokenId);
751         require(to != owner, "ERC721: approval to current owner");
752 
753         require(
754             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
755             "ERC721: approve caller is not owner nor approved for all"
756         );
757 
758         _approve(to, tokenId);
759     }
760 
761     /**
762      * @dev See {IERC721-getApproved}.
763      */
764     function getApproved(uint256 tokenId) public view virtual override returns (address) {
765         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
766 
767         return _tokenApprovals[tokenId];
768     }
769 
770     /**
771      * @dev See {IERC721-setApprovalForAll}.
772      */
773     function setApprovalForAll(address operator, bool approved) public virtual override {
774         _setApprovalForAll(_msgSender(), operator, approved);
775     }
776 
777     /**
778      * @dev See {IERC721-isApprovedForAll}.
779      */
780     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
781         return _operatorApprovals[owner][operator];
782     }
783 
784     /**
785      * @dev See {IERC721-transferFrom}.
786      */
787     function transferFrom(
788         address from,
789         address to,
790         uint256 tokenId
791     ) public virtual override {
792         //solhint-disable-next-line max-line-length
793         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
794 
795         _transfer(from, to, tokenId);
796     }
797 
798     /**
799      * @dev See {IERC721-safeTransferFrom}.
800      */
801     function safeTransferFrom(
802         address from,
803         address to,
804         uint256 tokenId
805     ) public virtual override {
806         safeTransferFrom(from, to, tokenId, "");
807     }
808 
809     /**
810      * @dev See {IERC721-safeTransferFrom}.
811      */
812     function safeTransferFrom(
813         address from,
814         address to,
815         uint256 tokenId,
816         bytes memory _data
817     ) public virtual override {
818         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
819         _safeTransfer(from, to, tokenId, _data);
820     }
821 
822     /**
823      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
824      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
825      *
826      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
827      *
828      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
829      * implement alternative mechanisms to perform token transfer, such as signature-based.
830      *
831      * Requirements:
832      *
833      * - `from` cannot be the zero address.
834      * - `to` cannot be the zero address.
835      * - `tokenId` token must exist and be owned by `from`.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _safeTransfer(
841         address from,
842         address to,
843         uint256 tokenId,
844         bytes memory _data
845     ) internal virtual {
846         _transfer(from, to, tokenId);
847         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
848     }
849 
850     /**
851      * @dev Returns whether `tokenId` exists.
852      *
853      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
854      *
855      * Tokens start existing when they are minted (`_mint`),
856      * and stop existing when they are burned (`_burn`).
857      */
858     function _exists(uint256 tokenId) internal view virtual returns (bool) {
859         return _owners[tokenId] != address(0);
860     }
861 
862     /**
863      * @dev Returns whether `spender` is allowed to manage `tokenId`.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must exist.
868      */
869     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
870         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
871         address owner = ERC721.ownerOf(tokenId);
872         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
873     }
874 
875     /**
876      * @dev Safely mints `tokenId` and transfers it to `to`.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must not exist.
881      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _safeMint(address to, uint256 tokenId) internal virtual {
886         _safeMint(to, tokenId, "");
887     }
888 
889     /**
890      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
891      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
892      */
893     function _safeMint(
894         address to,
895         uint256 tokenId,
896         bytes memory _data
897     ) internal virtual {
898         _mint(to, tokenId);
899         require(
900             _checkOnERC721Received(address(0), to, tokenId, _data),
901             "ERC721: transfer to non ERC721Receiver implementer"
902         );
903     }
904 
905     /**
906      * @dev Mints `tokenId` and transfers it to `to`.
907      *
908      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
909      *
910      * Requirements:
911      *
912      * - `tokenId` must not exist.
913      * - `to` cannot be the zero address.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _mint(address to, uint256 tokenId) internal virtual {
918         require(to != address(0), "ERC721: mint to the zero address");
919         require(!_exists(tokenId), "ERC721: token already minted");
920 
921         _beforeTokenTransfer(address(0), to, tokenId);
922 
923         _balances[to] += 1;
924         _owners[tokenId] = to;
925 
926         emit Transfer(address(0), to, tokenId);
927 
928         _afterTokenTransfer(address(0), to, tokenId);
929     }
930 
931     /**
932      * @dev Destroys `tokenId`.
933      * The approval is cleared when the token is burned.
934      *
935      * Requirements:
936      *
937      * - `tokenId` must exist.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _burn(uint256 tokenId) internal virtual {
942         address owner = ERC721.ownerOf(tokenId);
943 
944         _beforeTokenTransfer(owner, address(0), tokenId);
945 
946         // Clear approvals
947         _approve(address(0), tokenId);
948 
949         _balances[owner] -= 1;
950         delete _owners[tokenId];
951 
952         emit Transfer(owner, address(0), tokenId);
953 
954         _afterTokenTransfer(owner, address(0), tokenId);
955     }
956 
957     /**
958      * @dev Transfers `tokenId` from `from` to `to`.
959      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
960      *
961      * Requirements:
962      *
963      * - `to` cannot be the zero address.
964      * - `tokenId` token must be owned by `from`.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _transfer(
969         address from,
970         address to,
971         uint256 tokenId
972     ) internal virtual {
973         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
974         require(to != address(0), "ERC721: transfer to the zero address");
975 
976         _beforeTokenTransfer(from, to, tokenId);
977 
978         // Clear approvals from the previous owner
979         _approve(address(0), tokenId);
980 
981         _balances[from] -= 1;
982         _balances[to] += 1;
983         _owners[tokenId] = to;
984 
985         emit Transfer(from, to, tokenId);
986 
987         _afterTokenTransfer(from, to, tokenId);
988     }
989 
990     /**
991      * @dev Approve `to` to operate on `tokenId`
992      *
993      * Emits a {Approval} event.
994      */
995     function _approve(address to, uint256 tokenId) internal virtual {
996         _tokenApprovals[tokenId] = to;
997         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
998     }
999 
1000     /**
1001      * @dev Approve `operator` to operate on all of `owner` tokens
1002      *
1003      * Emits a {ApprovalForAll} event.
1004      */
1005     function _setApprovalForAll(
1006         address owner,
1007         address operator,
1008         bool approved
1009     ) internal virtual {
1010         require(owner != operator, "ERC721: approve to caller");
1011         _operatorApprovals[owner][operator] = approved;
1012         emit ApprovalForAll(owner, operator, approved);
1013     }
1014 
1015     /**
1016      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1017      * The call is not executed if the target address is not a contract.
1018      *
1019      * @param from address representing the previous owner of the given token ID
1020      * @param to target address that will receive the tokens
1021      * @param tokenId uint256 ID of the token to be transferred
1022      * @param _data bytes optional data to send along with the call
1023      * @return bool whether the call correctly returned the expected magic value
1024      */
1025     function _checkOnERC721Received(
1026         address from,
1027         address to,
1028         uint256 tokenId,
1029         bytes memory _data
1030     ) private returns (bool) {
1031         if (to.isContract()) {
1032             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1033                 return retval == IERC721Receiver.onERC721Received.selector;
1034             } catch (bytes memory reason) {
1035                 if (reason.length == 0) {
1036                     revert("ERC721: transfer to non ERC721Receiver implementer");
1037                 } else {
1038                     assembly {
1039                         revert(add(32, reason), mload(reason))
1040                     }
1041                 }
1042             }
1043         } else {
1044             return true;
1045         }
1046     }
1047 
1048     /**
1049      * @dev Hook that is called before any token transfer. This includes minting
1050      * and burning.
1051      *
1052      * Calling conditions:
1053      *
1054      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1055      * transferred to `to`.
1056      * - When `from` is zero, `tokenId` will be minted for `to`.
1057      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1058      * - `from` and `to` are never both zero.
1059      *
1060      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1061      */
1062     function _beforeTokenTransfer(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) internal virtual {}
1067 
1068     /**
1069      * @dev Hook that is called after any transfer of tokens. This includes
1070      * minting and burning.
1071      *
1072      * Calling conditions:
1073      *
1074      * - when `from` and `to` are both non-zero.
1075      * - `from` and `to` are never both zero.
1076      *
1077      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1078      */
1079     function _afterTokenTransfer(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) internal virtual {}
1084 }
1085 
1086 
1087 
1088 
1089 /** 
1090  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
1091 */
1092             
1093 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
1094 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1095 
1096 pragma solidity ^0.8.0;
1097 
1098 ////////import "../IERC721.sol";
1099 
1100 /**
1101  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1102  * @dev See https://eips.ethereum.org/EIPS/eip-721
1103  */
1104 interface IERC721Enumerable is IERC721 {
1105     /**
1106      * @dev Returns the total amount of tokens stored by the contract.
1107      */
1108     function totalSupply() external view returns (uint256);
1109 
1110     /**
1111      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1112      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1113      */
1114     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1115 
1116     /**
1117      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1118      * Use along with {totalSupply} to enumerate all tokens.
1119      */
1120     function tokenByIndex(uint256 index) external view returns (uint256);
1121 }
1122 
1123 
1124 
1125 
1126 /** 
1127  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
1128 */
1129             
1130 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
1131 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1132 
1133 pragma solidity ^0.8.0;
1134 
1135 /**
1136  * @dev External interface of AccessControl declared to support ERC165 detection.
1137  */
1138 interface IAccessControl {
1139     /**
1140      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1141      *
1142      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1143      * {RoleAdminChanged} not being emitted signaling this.
1144      *
1145      * _Available since v3.1._
1146      */
1147     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1148 
1149     /**
1150      * @dev Emitted when `account` is granted `role`.
1151      *
1152      * `sender` is the account that originated the contract call, an admin role
1153      * bearer except when using {AccessControl-_setupRole}.
1154      */
1155     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1156 
1157     /**
1158      * @dev Emitted when `account` is revoked `role`.
1159      *
1160      * `sender` is the account that originated the contract call:
1161      *   - if using `revokeRole`, it is the admin role bearer
1162      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1163      */
1164     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1165 
1166     /**
1167      * @dev Returns `true` if `account` has been granted `role`.
1168      */
1169     function hasRole(bytes32 role, address account) external view returns (bool);
1170 
1171     /**
1172      * @dev Returns the admin role that controls `role`. See {grantRole} and
1173      * {revokeRole}.
1174      *
1175      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1176      */
1177     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1178 
1179     /**
1180      * @dev Grants `role` to `account`.
1181      *
1182      * If `account` had not been already granted `role`, emits a {RoleGranted}
1183      * event.
1184      *
1185      * Requirements:
1186      *
1187      * - the caller must have ``role``'s admin role.
1188      */
1189     function grantRole(bytes32 role, address account) external;
1190 
1191     /**
1192      * @dev Revokes `role` from `account`.
1193      *
1194      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1195      *
1196      * Requirements:
1197      *
1198      * - the caller must have ``role``'s admin role.
1199      */
1200     function revokeRole(bytes32 role, address account) external;
1201 
1202     /**
1203      * @dev Revokes `role` from the calling account.
1204      *
1205      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1206      * purpose is to provide a mechanism for accounts to lose their privileges
1207      * if they are compromised (such as when a trusted device is misplaced).
1208      *
1209      * If the calling account had been granted `role`, emits a {RoleRevoked}
1210      * event.
1211      *
1212      * Requirements:
1213      *
1214      * - the caller must be `account`.
1215      */
1216     function renounceRole(bytes32 role, address account) external;
1217 }
1218 
1219 
1220 
1221 
1222 /** 
1223  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
1224 */
1225             
1226 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
1227 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1228 
1229 pragma solidity ^0.8.0;
1230 
1231 /**
1232  * @title Counters
1233  * @author Matt Condon (@shrugs)
1234  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1235  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1236  *
1237  * Include with `using Counters for Counters.Counter;`
1238  */
1239 library Counters {
1240     struct Counter {
1241         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1242         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1243         // this feature: see https://github.com/ethereum/solidity/issues/4637
1244         uint256 _value; // default: 0
1245     }
1246 
1247     function current(Counter storage counter) internal view returns (uint256) {
1248         return counter._value;
1249     }
1250 
1251     function increment(Counter storage counter) internal {
1252         unchecked {
1253             counter._value += 1;
1254         }
1255     }
1256 
1257     function decrement(Counter storage counter) internal {
1258         uint256 value = counter._value;
1259         require(value > 0, "Counter: decrement overflow");
1260         unchecked {
1261             counter._value = value - 1;
1262         }
1263     }
1264 
1265     function reset(Counter storage counter) internal {
1266         counter._value = 0;
1267     }
1268 }
1269 
1270 
1271 
1272 
1273 /** 
1274  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
1275 */
1276             
1277 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
1278 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1279 
1280 pragma solidity ^0.8.0;
1281 
1282 ////////import "../ERC721.sol";
1283 
1284 /**
1285  * @dev ERC721 token with storage based token URI management.
1286  */
1287 abstract contract ERC721URIStorage is ERC721 {
1288     using Strings for uint256;
1289 
1290     // Optional mapping for token URIs
1291     mapping(uint256 => string) private _tokenURIs;
1292 
1293     /**
1294      * @dev See {IERC721Metadata-tokenURI}.
1295      */
1296     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1297         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1298 
1299         string memory _tokenURI = _tokenURIs[tokenId];
1300         string memory base = _baseURI();
1301 
1302         // If there is no base URI, return the token URI.
1303         if (bytes(base).length == 0) {
1304             return _tokenURI;
1305         }
1306         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1307         if (bytes(_tokenURI).length > 0) {
1308             return string(abi.encodePacked(base, _tokenURI));
1309         }
1310 
1311         return super.tokenURI(tokenId);
1312     }
1313 
1314     /**
1315      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1316      *
1317      * Requirements:
1318      *
1319      * - `tokenId` must exist.
1320      */
1321     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1322         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1323         _tokenURIs[tokenId] = _tokenURI;
1324     }
1325 
1326     /**
1327      * @dev Destroys `tokenId`.
1328      * The approval is cleared when the token is burned.
1329      *
1330      * Requirements:
1331      *
1332      * - `tokenId` must exist.
1333      *
1334      * Emits a {Transfer} event.
1335      */
1336     function _burn(uint256 tokenId) internal virtual override {
1337         super._burn(tokenId);
1338 
1339         if (bytes(_tokenURIs[tokenId]).length != 0) {
1340             delete _tokenURIs[tokenId];
1341         }
1342     }
1343 }
1344 
1345 
1346 
1347 
1348 /** 
1349  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
1350 */
1351             
1352 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
1353 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1354 
1355 pragma solidity ^0.8.0;
1356 
1357 ////////import "../ERC721.sol";
1358 ////////import "./IERC721Enumerable.sol";
1359 
1360 /**
1361  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1362  * enumerability of all the token ids in the contract as well as all token ids owned by each
1363  * account.
1364  */
1365 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1366     // Mapping from owner to list of owned token IDs
1367     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1368 
1369     // Mapping from token ID to index of the owner tokens list
1370     mapping(uint256 => uint256) private _ownedTokensIndex;
1371 
1372     // Array with all token ids, used for enumeration
1373     uint256[] private _allTokens;
1374 
1375     // Mapping from token id to position in the allTokens array
1376     mapping(uint256 => uint256) private _allTokensIndex;
1377 
1378     /**
1379      * @dev See {IERC165-supportsInterface}.
1380      */
1381     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1382         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1383     }
1384 
1385     /**
1386      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1387      */
1388     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1389         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1390         return _ownedTokens[owner][index];
1391     }
1392 
1393     /**
1394      * @dev See {IERC721Enumerable-totalSupply}.
1395      */
1396     function totalSupply() public view virtual override returns (uint256) {
1397         return _allTokens.length;
1398     }
1399 
1400     /**
1401      * @dev See {IERC721Enumerable-tokenByIndex}.
1402      */
1403     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1404         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1405         return _allTokens[index];
1406     }
1407 
1408     /**
1409      * @dev Hook that is called before any token transfer. This includes minting
1410      * and burning.
1411      *
1412      * Calling conditions:
1413      *
1414      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1415      * transferred to `to`.
1416      * - When `from` is zero, `tokenId` will be minted for `to`.
1417      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1418      * - `from` cannot be the zero address.
1419      * - `to` cannot be the zero address.
1420      *
1421      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1422      */
1423     function _beforeTokenTransfer(
1424         address from,
1425         address to,
1426         uint256 tokenId
1427     ) internal virtual override {
1428         super._beforeTokenTransfer(from, to, tokenId);
1429 
1430         if (from == address(0)) {
1431             _addTokenToAllTokensEnumeration(tokenId);
1432         } else if (from != to) {
1433             _removeTokenFromOwnerEnumeration(from, tokenId);
1434         }
1435         if (to == address(0)) {
1436             _removeTokenFromAllTokensEnumeration(tokenId);
1437         } else if (to != from) {
1438             _addTokenToOwnerEnumeration(to, tokenId);
1439         }
1440     }
1441 
1442     /**
1443      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1444      * @param to address representing the new owner of the given token ID
1445      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1446      */
1447     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1448         uint256 length = ERC721.balanceOf(to);
1449         _ownedTokens[to][length] = tokenId;
1450         _ownedTokensIndex[tokenId] = length;
1451     }
1452 
1453     /**
1454      * @dev Private function to add a token to this extension's token tracking data structures.
1455      * @param tokenId uint256 ID of the token to be added to the tokens list
1456      */
1457     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1458         _allTokensIndex[tokenId] = _allTokens.length;
1459         _allTokens.push(tokenId);
1460     }
1461 
1462     /**
1463      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1464      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1465      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1466      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1467      * @param from address representing the previous owner of the given token ID
1468      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1469      */
1470     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1471         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1472         // then delete the last slot (swap and pop).
1473 
1474         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1475         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1476 
1477         // When the token to delete is the last token, the swap operation is unnecessary
1478         if (tokenIndex != lastTokenIndex) {
1479             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1480 
1481             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1482             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1483         }
1484 
1485         // This also deletes the contents at the last position of the array
1486         delete _ownedTokensIndex[tokenId];
1487         delete _ownedTokens[from][lastTokenIndex];
1488     }
1489 
1490     /**
1491      * @dev Private function to remove a token from this extension's token tracking data structures.
1492      * This has O(1) time complexity, but alters the order of the _allTokens array.
1493      * @param tokenId uint256 ID of the token to be removed from the tokens list
1494      */
1495     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1496         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1497         // then delete the last slot (swap and pop).
1498 
1499         uint256 lastTokenIndex = _allTokens.length - 1;
1500         uint256 tokenIndex = _allTokensIndex[tokenId];
1501 
1502         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1503         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1504         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1505         uint256 lastTokenId = _allTokens[lastTokenIndex];
1506 
1507         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1508         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1509 
1510         // This also deletes the contents at the last position of the array
1511         delete _allTokensIndex[tokenId];
1512         _allTokens.pop();
1513     }
1514 }
1515 
1516 
1517 
1518 
1519 /** 
1520  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
1521 */
1522             
1523 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
1524 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1525 
1526 pragma solidity ^0.8.0;
1527 
1528 ////////import "../ERC721.sol";
1529 ////////import "../../../utils/Context.sol";
1530 
1531 /**
1532  * @title ERC721 Burnable Token
1533  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1534  */
1535 abstract contract ERC721Burnable is Context, ERC721 {
1536     /**
1537      * @dev Burns `tokenId`. See {ERC721-_burn}.
1538      *
1539      * Requirements:
1540      *
1541      * - The caller must own `tokenId` or be an approved operator.
1542      */
1543     function burn(uint256 tokenId) public virtual {
1544         //solhint-disable-next-line max-line-length
1545         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1546         _burn(tokenId);
1547     }
1548 }
1549 
1550 
1551 
1552 
1553 /** 
1554  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
1555 */
1556             
1557 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
1558 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1559 
1560 pragma solidity ^0.8.0;
1561 
1562 /**
1563  * @dev Contract module that helps prevent reentrant calls to a function.
1564  *
1565  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1566  * available, which can be applied to functions to make sure there are no nested
1567  * (reentrant) calls to them.
1568  *
1569  * Note that because there is a single `nonReentrant` guard, functions marked as
1570  * `nonReentrant` may not call one another. This can be worked around by making
1571  * those functions `private`, and then adding `external` `nonReentrant` entry
1572  * points to them.
1573  *
1574  * TIP: If you would like to learn more about reentrancy and alternative ways
1575  * to protect against it, check out our blog post
1576  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1577  */
1578 abstract contract ReentrancyGuard {
1579     // Booleans are more expensive than uint256 or any type that takes up a full
1580     // word because each write operation emits an extra SLOAD to first read the
1581     // slot's contents, replace the bits taken up by the boolean, and then write
1582     // back. This is the compiler's defense against contract upgrades and
1583     // pointer aliasing, and it cannot be disabled.
1584 
1585     // The values being non-zero value makes deployment a bit more expensive,
1586     // but in exchange the refund on every call to nonReentrant will be lower in
1587     // amount. Since refunds are capped to a percentage of the total
1588     // transaction's gas, it is best to keep them low in cases like this one, to
1589     // increase the likelihood of the full refund coming into effect.
1590     uint256 private constant _NOT_ENTERED = 1;
1591     uint256 private constant _ENTERED = 2;
1592 
1593     uint256 private _status;
1594 
1595     constructor() {
1596         _status = _NOT_ENTERED;
1597     }
1598 
1599     /**
1600      * @dev Prevents a contract from calling itself, directly or indirectly.
1601      * Calling a `nonReentrant` function from another `nonReentrant`
1602      * function is not supported. It is possible to prevent this from happening
1603      * by making the `nonReentrant` function external, and making it call a
1604      * `private` function that does the actual work.
1605      */
1606     modifier nonReentrant() {
1607         // On the first call to nonReentrant, _notEntered will be true
1608         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1609 
1610         // Any calls to nonReentrant after this point will fail
1611         _status = _ENTERED;
1612 
1613         _;
1614 
1615         // By storing the original value once again, a refund is triggered (see
1616         // https://eips.ethereum.org/EIPS/eip-2200)
1617         _status = _NOT_ENTERED;
1618     }
1619 }
1620 
1621 
1622 
1623 
1624 /** 
1625  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
1626 */
1627             
1628 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
1629 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1630 
1631 pragma solidity ^0.8.0;
1632 
1633 ////////import "../utils/Context.sol";
1634 
1635 /**
1636  * @dev Contract module which allows children to implement an emergency stop
1637  * mechanism that can be triggered by an authorized account.
1638  *
1639  * This module is used through inheritance. It will make available the
1640  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1641  * the functions of your contract. Note that they will not be pausable by
1642  * simply including this module, only once the modifiers are put in place.
1643  */
1644 abstract contract Pausable is Context {
1645     /**
1646      * @dev Emitted when the pause is triggered by `account`.
1647      */
1648     event Paused(address account);
1649 
1650     /**
1651      * @dev Emitted when the pause is lifted by `account`.
1652      */
1653     event Unpaused(address account);
1654 
1655     bool private _paused;
1656 
1657     /**
1658      * @dev Initializes the contract in unpaused state.
1659      */
1660     constructor() {
1661         _paused = false;
1662     }
1663 
1664     /**
1665      * @dev Returns true if the contract is paused, and false otherwise.
1666      */
1667     function paused() public view virtual returns (bool) {
1668         return _paused;
1669     }
1670 
1671     /**
1672      * @dev Modifier to make a function callable only when the contract is not paused.
1673      *
1674      * Requirements:
1675      *
1676      * - The contract must not be paused.
1677      */
1678     modifier whenNotPaused() {
1679         require(!paused(), "Pausable: paused");
1680         _;
1681     }
1682 
1683     /**
1684      * @dev Modifier to make a function callable only when the contract is paused.
1685      *
1686      * Requirements:
1687      *
1688      * - The contract must be paused.
1689      */
1690     modifier whenPaused() {
1691         require(paused(), "Pausable: not paused");
1692         _;
1693     }
1694 
1695     /**
1696      * @dev Triggers stopped state.
1697      *
1698      * Requirements:
1699      *
1700      * - The contract must not be paused.
1701      */
1702     function _pause() internal virtual whenNotPaused {
1703         _paused = true;
1704         emit Paused(_msgSender());
1705     }
1706 
1707     /**
1708      * @dev Returns to normal state.
1709      *
1710      * Requirements:
1711      *
1712      * - The contract must be paused.
1713      */
1714     function _unpause() internal virtual whenPaused {
1715         _paused = false;
1716         emit Unpaused(_msgSender());
1717     }
1718 }
1719 
1720 
1721 
1722 
1723 /** 
1724  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
1725 */
1726             
1727 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
1728 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1729 
1730 pragma solidity ^0.8.0;
1731 
1732 ////////import "../utils/Context.sol";
1733 
1734 /**
1735  * @dev Contract module which provides a basic access control mechanism, where
1736  * there is an account (an owner) that can be granted exclusive access to
1737  * specific functions.
1738  *
1739  * By default, the owner account will be the one that deploys the contract. This
1740  * can later be changed with {transferOwnership}.
1741  *
1742  * This module is used through inheritance. It will make available the modifier
1743  * `onlyOwner`, which can be applied to your functions to restrict their use to
1744  * the owner.
1745  */
1746 abstract contract Ownable is Context {
1747     address private _owner;
1748 
1749     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1750 
1751     /**
1752      * @dev Initializes the contract setting the deployer as the initial owner.
1753      */
1754     constructor() {
1755         _transferOwnership(_msgSender());
1756     }
1757 
1758     /**
1759      * @dev Returns the address of the current owner.
1760      */
1761     function owner() public view virtual returns (address) {
1762         return _owner;
1763     }
1764 
1765     /**
1766      * @dev Throws if called by any account other than the owner.
1767      */
1768     modifier onlyOwner() {
1769         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1770         _;
1771     }
1772 
1773     /**
1774      * @dev Leaves the contract without owner. It will not be possible to call
1775      * `onlyOwner` functions anymore. Can only be called by the current owner.
1776      *
1777      * NOTE: Renouncing ownership will leave the contract without an owner,
1778      * thereby removing any functionality that is only available to the owner.
1779      */
1780     function renounceOwnership() public virtual onlyOwner {
1781         _transferOwnership(address(0));
1782     }
1783 
1784     /**
1785      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1786      * Can only be called by the current owner.
1787      */
1788     function transferOwnership(address newOwner) public virtual onlyOwner {
1789         require(newOwner != address(0), "Ownable: new owner is the zero address");
1790         _transferOwnership(newOwner);
1791     }
1792 
1793     /**
1794      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1795      * Internal function without access restriction.
1796      */
1797     function _transferOwnership(address newOwner) internal virtual {
1798         address oldOwner = _owner;
1799         _owner = newOwner;
1800         emit OwnershipTransferred(oldOwner, newOwner);
1801     }
1802 }
1803 
1804 
1805 
1806 
1807 /** 
1808  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
1809 */
1810             
1811 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: MIT
1812 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
1813 
1814 pragma solidity ^0.8.0;
1815 
1816 ////////import "./IAccessControl.sol";
1817 ////////import "../utils/Context.sol";
1818 ////////import "../utils/Strings.sol";
1819 ////////import "../utils/introspection/ERC165.sol";
1820 
1821 /**
1822  * @dev Contract module that allows children to implement role-based access
1823  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1824  * members except through off-chain means by accessing the contract event logs. Some
1825  * applications may benefit from on-chain enumerability, for those cases see
1826  * {AccessControlEnumerable}.
1827  *
1828  * Roles are referred to by their `bytes32` identifier. These should be exposed
1829  * in the external API and be unique. The best way to achieve this is by
1830  * using `public constant` hash digests:
1831  *
1832  * ```
1833  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1834  * ```
1835  *
1836  * Roles can be used to represent a set of permissions. To restrict access to a
1837  * function call, use {hasRole}:
1838  *
1839  * ```
1840  * function foo() public {
1841  *     require(hasRole(MY_ROLE, msg.sender));
1842  *     ...
1843  * }
1844  * ```
1845  *
1846  * Roles can be granted and revoked dynamically via the {grantRole} and
1847  * {revokeRole} functions. Each role has an associated admin role, and only
1848  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1849  *
1850  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1851  * that only accounts with this role will be able to grant or revoke other
1852  * roles. More complex role relationships can be created by using
1853  * {_setRoleAdmin}.
1854  *
1855  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1856  * grant and revoke this role. Extra precautions should be taken to secure
1857  * accounts that have been granted it.
1858  */
1859 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1860     struct RoleData {
1861         mapping(address => bool) members;
1862         bytes32 adminRole;
1863     }
1864 
1865     mapping(bytes32 => RoleData) private _roles;
1866 
1867     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1868 
1869     /**
1870      * @dev Modifier that checks that an account has a specific role. Reverts
1871      * with a standardized message including the required role.
1872      *
1873      * The format of the revert reason is given by the following regular expression:
1874      *
1875      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1876      *
1877      * _Available since v4.1._
1878      */
1879     modifier onlyRole(bytes32 role) {
1880         _checkRole(role, _msgSender());
1881         _;
1882     }
1883 
1884     /**
1885      * @dev See {IERC165-supportsInterface}.
1886      */
1887     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1888         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1889     }
1890 
1891     /**
1892      * @dev Returns `true` if `account` has been granted `role`.
1893      */
1894     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1895         return _roles[role].members[account];
1896     }
1897 
1898     /**
1899      * @dev Revert with a standard message if `account` is missing `role`.
1900      *
1901      * The format of the revert reason is given by the following regular expression:
1902      *
1903      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1904      */
1905     function _checkRole(bytes32 role, address account) internal view virtual {
1906         if (!hasRole(role, account)) {
1907             revert(
1908                 string(
1909                     abi.encodePacked(
1910                         "AccessControl: account ",
1911                         Strings.toHexString(uint160(account), 20),
1912                         " is missing role ",
1913                         Strings.toHexString(uint256(role), 32)
1914                     )
1915                 )
1916             );
1917         }
1918     }
1919 
1920     /**
1921      * @dev Returns the admin role that controls `role`. See {grantRole} and
1922      * {revokeRole}.
1923      *
1924      * To change a role's admin, use {_setRoleAdmin}.
1925      */
1926     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1927         return _roles[role].adminRole;
1928     }
1929 
1930     /**
1931      * @dev Grants `role` to `account`.
1932      *
1933      * If `account` had not been already granted `role`, emits a {RoleGranted}
1934      * event.
1935      *
1936      * Requirements:
1937      *
1938      * - the caller must have ``role``'s admin role.
1939      */
1940     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1941         _grantRole(role, account);
1942     }
1943 
1944     /**
1945      * @dev Revokes `role` from `account`.
1946      *
1947      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1948      *
1949      * Requirements:
1950      *
1951      * - the caller must have ``role``'s admin role.
1952      */
1953     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1954         _revokeRole(role, account);
1955     }
1956 
1957     /**
1958      * @dev Revokes `role` from the calling account.
1959      *
1960      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1961      * purpose is to provide a mechanism for accounts to lose their privileges
1962      * if they are compromised (such as when a trusted device is misplaced).
1963      *
1964      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1965      * event.
1966      *
1967      * Requirements:
1968      *
1969      * - the caller must be `account`.
1970      */
1971     function renounceRole(bytes32 role, address account) public virtual override {
1972         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1973 
1974         _revokeRole(role, account);
1975     }
1976 
1977     /**
1978      * @dev Grants `role` to `account`.
1979      *
1980      * If `account` had not been already granted `role`, emits a {RoleGranted}
1981      * event. Note that unlike {grantRole}, this function doesn't perform any
1982      * checks on the calling account.
1983      *
1984      * [WARNING]
1985      * ====
1986      * This function should only be called from the constructor when setting
1987      * up the initial roles for the system.
1988      *
1989      * Using this function in any other way is effectively circumventing the admin
1990      * system imposed by {AccessControl}.
1991      * ====
1992      *
1993      * NOTE: This function is deprecated in favor of {_grantRole}.
1994      */
1995     function _setupRole(bytes32 role, address account) internal virtual {
1996         _grantRole(role, account);
1997     }
1998 
1999     /**
2000      * @dev Sets `adminRole` as ``role``'s admin role.
2001      *
2002      * Emits a {RoleAdminChanged} event.
2003      */
2004     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2005         bytes32 previousAdminRole = getRoleAdmin(role);
2006         _roles[role].adminRole = adminRole;
2007         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2008     }
2009 
2010     /**
2011      * @dev Grants `role` to `account`.
2012      *
2013      * Internal function without access restriction.
2014      */
2015     function _grantRole(bytes32 role, address account) internal virtual {
2016         if (!hasRole(role, account)) {
2017             _roles[role].members[account] = true;
2018             emit RoleGranted(role, account, _msgSender());
2019         }
2020     }
2021 
2022     /**
2023      * @dev Revokes `role` from `account`.
2024      *
2025      * Internal function without access restriction.
2026      */
2027     function _revokeRole(bytes32 role, address account) internal virtual {
2028         if (hasRole(role, account)) {
2029             _roles[role].members[account] = false;
2030             emit RoleRevoked(role, account, _msgSender());
2031         }
2032     }
2033 }
2034 
2035 
2036 /** 
2037  *  SourceUnit: /home/clayrisser/Projects/crypto-outlaws/ethereum-nft/contracts/Outlaw.sol
2038 */
2039 
2040 ////////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING-FLATTEN-SUPPRESS-WARNING: UNLICENSED
2041 pragma solidity ^0.8.0;
2042 
2043 ////////import "@openzeppelin/contracts/access/AccessControl.sol";
2044 ////////import "@openzeppelin/contracts/access/Ownable.sol";
2045 ////////import "@openzeppelin/contracts/security/Pausable.sol";
2046 ////////import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
2047 ////////import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
2048 ////////import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
2049 ////////import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
2050 ////////import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
2051 ////////import "@openzeppelin/contracts/utils/Counters.sol";
2052 
2053 // @custom:security-contact zach@outlawsnft.io
2054 contract Outlaw is
2055     ERC721,
2056     ERC721Enumerable,
2057     ERC721URIStorage,
2058     Pausable,
2059     Ownable,
2060     AccessControl,
2061     ERC721Burnable,
2062     ReentrancyGuard
2063 {
2064     using Counters for Counters.Counter;
2065 
2066     uint96 private constant _ROYALTIES_PERCENTAGE_BASIS_POINTS = 777; // 100 is 1%
2067     Counters.Counter private _tokenIdCounter;
2068     address payable private _royaltiesReceipientAddress;
2069     mapping(uint256 => uint256) private _tokenIdsByImageId;
2070     mapping(uint256 => uint256) private _imageIdsByTokenId;
2071 
2072     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2073     bytes32 public constant WHITELIST_ROLE = keccak256("WHITELIST_ROLE");
2074     string public constant LICENSE = "https://olw.outlawsnft.io/license";
2075     uint256 public constant MAX_BATCH_MINT = 10;
2076     uint256 public constant MAX_SUPPLY = 7777;
2077     uint256 public constant MAX_WHITELIST_SUPPLY = 777;
2078     uint256 public constant PUBLIC_COST = 0.077 ether;
2079     uint256 public constant REMINT_COST = 0.00 ether;
2080     uint256 public constant WHITELIST_COST = 0.05 ether;
2081 
2082     bool public publicSale = false;
2083     uint256 public whitelistMaxMint = 0;
2084 
2085     constructor() ERC721("Outlaws", "OLW") ReentrancyGuard() {
2086         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
2087         _grantRole(MINTER_ROLE, msg.sender);
2088         _royaltiesReceipientAddress = payable(msg.sender);
2089         _tokenIdCounter.increment(); // start at 1
2090     }
2091 
2092     /// @notice mint an nft
2093     /// @param uris ipfs uris of the metadata
2094     function mint(string[] memory uris, uint256[] memory imageIds)
2095         public
2096         payable
2097     {
2098         require(
2099             uris.length == imageIds.length,
2100             "uris and image ids must be the same length"
2101         );
2102         uint256 mintAmount = uris.length;
2103         require(mintAmount > 0, "cannot mint 0 tokens");
2104         require(mintAmount <= MAX_BATCH_MINT, "minting too many tokens");
2105         if (hasRole(MINTER_ROLE, msg.sender)) {
2106             _increMint(msg.sender, uris, imageIds);
2107             return;
2108         } else if (_canWhitelist(mintAmount)) {
2109             require(
2110                 msg.value >= (WHITELIST_COST * mintAmount),
2111                 "not enough ether supplied"
2112             );
2113             _increMint(msg.sender, uris, imageIds);
2114             return;
2115         }
2116         require(publicSale, "public sale has not started yet");
2117         require(
2118             msg.value >= (PUBLIC_COST * mintAmount),
2119             "not enough ether supplied"
2120         );
2121         _increMint(msg.sender, uris, imageIds);
2122     }
2123 
2124     function mintCost(uint256 mintAmount) public view returns (uint256) {
2125         if (hasRole(MINTER_ROLE, msg.sender)) {
2126             return 0;
2127         } else if (_canWhitelist(mintAmount)) {
2128             return WHITELIST_COST * mintAmount;
2129         }
2130         return PUBLIC_COST * mintAmount;
2131     }
2132 
2133     /// @notice remint an nft
2134     function remint(
2135         uint256 tokenId,
2136         string memory uri,
2137         uint256 imageId
2138     ) public payable {
2139         address tokenOwner = ownerOf(tokenId);
2140         require(
2141             owner() == msg.sender || msg.sender == tokenOwner,
2142             "must own the token to remint"
2143         );
2144         if (owner() != msg.sender) {
2145             require(msg.value >= REMINT_COST, "not enough ether supplied");
2146         }
2147         require(
2148             _tokenIdsByImageId[imageId] <= 0 ||
2149                 _tokenIdsByImageId[imageId] == tokenId,
2150             string("image id already minted")
2151         );
2152         _burn(tokenId);
2153         _safeMint(tokenOwner, tokenId);
2154         _associateImageIdWithTokenId(imageId, tokenId);
2155         _setTokenURI(tokenId, uri);
2156     }
2157 
2158     function tokenIdFromImageId(uint256 imageId) public view returns (uint256) {
2159         return _tokenIdsByImageId[imageId];
2160     }
2161 
2162     function imageIdFromTokenId(uint256 tokenId) public view returns (uint256) {
2163         return _imageIdsByTokenId[tokenId];
2164     }
2165 
2166     function walletOf(address tokenOwner)
2167         public
2168         view
2169         returns (uint256[] memory)
2170     {
2171         uint256 tokenCount = balanceOf(tokenOwner);
2172         uint256[] memory tokenIds = new uint256[](tokenCount);
2173         for (uint256 i; i < tokenCount; i++) {
2174             tokenIds[i] = tokenOfOwnerByIndex(tokenOwner, i);
2175         }
2176         return tokenIds;
2177     }
2178 
2179     function tokenURI(uint256 tokenId)
2180         public
2181         view
2182         override(ERC721, ERC721URIStorage)
2183         returns (string memory)
2184     {
2185         return super.tokenURI(tokenId);
2186     }
2187 
2188     function supportsInterface(bytes4 interfaceId)
2189         public
2190         view
2191         override(ERC721, ERC721Enumerable, AccessControl)
2192         returns (bool)
2193     {
2194         return super.supportsInterface(interfaceId);
2195     }
2196 
2197     /// @notice withdraw funds from contract
2198     function withdraw() external nonReentrant onlyOwner {
2199         (bool success, ) = payable(msg.sender).call{
2200             value: address(this).balance
2201         }("");
2202         require(success);
2203     }
2204 
2205     function contractBalance() external view onlyOwner returns (uint256) {
2206         return address(this).balance;
2207     }
2208 
2209     function addToWhitelist(address[] calldata addresses) public onlyOwner {
2210         for (uint256 i = 0; i < addresses.length; i++) {
2211             _grantRole(WHITELIST_ROLE, addresses[i]);
2212         }
2213     }
2214 
2215     function removeFromWhitelist(address[] calldata addresses)
2216         public
2217         onlyOwner
2218     {
2219         for (uint256 i = 0; i < addresses.length; i++) {
2220             _revokeRole(WHITELIST_ROLE, addresses[i]);
2221         }
2222     }
2223 
2224     function pause() public onlyOwner {
2225         _pause();
2226     }
2227 
2228     function unpause() public onlyOwner {
2229         _unpause();
2230     }
2231 
2232     function flipPublicSale() public onlyOwner {
2233         publicSale = !publicSale;
2234     }
2235 
2236     function setWhitelistMaxMint(uint256 _whitelistMaxMint) public onlyOwner {
2237         whitelistMaxMint = _whitelistMaxMint;
2238     }
2239 
2240     function burn(uint256 tokenId) public override onlyOwner {
2241         super.burn(tokenId);
2242     }
2243 
2244     function _beforeTokenTransfer(
2245         address from,
2246         address to,
2247         uint256 tokenId
2248     ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
2249         super._beforeTokenTransfer(from, to, tokenId);
2250     }
2251 
2252     function _increMint(
2253         address tokenOwner,
2254         string[] memory uris,
2255         uint256[] memory imageIds
2256     ) private {
2257         uint256 mintAmount = uris.length;
2258         require(
2259             (_tokenIdCounter.current() + mintAmount) <= MAX_SUPPLY,
2260             "all 7777 tokens have been minted"
2261         );
2262         for (uint256 i = 0; i < mintAmount; i++) {
2263             _mintOne(tokenOwner, uris[i], imageIds[i]);
2264         }
2265     }
2266 
2267     function _mintOne(
2268         address tokenOwner,
2269         string memory uri,
2270         uint256 imageId
2271     ) private {
2272         require(
2273             (_tokenIdCounter.current() + 1) <= MAX_SUPPLY,
2274             "all 7777 tokens have been minted"
2275         );
2276         require(
2277             _tokenIdsByImageId[imageId] <= 0,
2278             string("image id already minted")
2279         );
2280         uint256 tokenId = _tokenIdCounter.current();
2281         _tokenIdCounter.increment();
2282         _safeMint(tokenOwner, tokenId);
2283         _associateImageIdWithTokenId(imageId, tokenId);
2284         _setTokenURI(tokenId, uri);
2285     }
2286 
2287     function _canWhitelist(uint256 mintAmount) private view returns (bool) {
2288         return
2289             hasRole(WHITELIST_ROLE, msg.sender) &&
2290             ((balanceOf(msg.sender) + mintAmount) <= whitelistMaxMint) &&
2291             ((_tokenIdCounter.current() + mintAmount) <= MAX_WHITELIST_SUPPLY ||
2292                 whitelistMaxMint == 1);
2293     }
2294 
2295     function _burn(uint256 tokenId)
2296         internal
2297         override(ERC721, ERC721URIStorage)
2298     {
2299         _tokenIdsByImageId[_imageIdsByTokenId[tokenId]] = 0;
2300         _imageIdsByTokenId[tokenId] = 0;
2301         super._burn(tokenId);
2302     }
2303 
2304     function _baseURI() internal pure override returns (string memory) {
2305         return "ipfs://";
2306     }
2307 
2308     function _associateImageIdWithTokenId(uint256 imageId, uint256 tokenId)
2309         private
2310     {
2311         _tokenIdsByImageId[imageId] = tokenId;
2312         _imageIdsByTokenId[tokenId] = imageId;
2313     }
2314 }