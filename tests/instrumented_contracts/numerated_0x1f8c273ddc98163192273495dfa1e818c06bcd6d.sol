1 // SPDX-License-Identifier: MIT
2 
3 /*
4                                                                                                                                     
5       _/_/_/  _/                  _/              _/                                          _/_/_/                                
6    _/        _/  _/      _/_/    _/    _/_/    _/_/_/_/    _/_/    _/_/_/    _/_/_/_/      _/          _/_/_/  _/_/_/      _/_/_/   
7     _/_/    _/_/      _/_/_/_/  _/  _/_/_/_/    _/      _/    _/  _/    _/      _/        _/  _/_/  _/    _/  _/    _/  _/    _/    
8        _/  _/  _/    _/        _/  _/          _/      _/    _/  _/    _/    _/          _/    _/  _/    _/  _/    _/  _/    _/     
9 _/_/_/    _/    _/    _/_/_/  _/    _/_/_/      _/_/    _/_/    _/    _/  _/_/_/_/        _/_/_/    _/_/_/  _/    _/    _/_/_/      
10                                                                                                                            _/       
11                                                                                                                       _/_/          
12 */
13 
14 // File: @openzeppelin/contracts/utils/Strings.sol
15 
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev String operations.
23  */
24 library Strings {
25     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26 
27     /**
28      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
29      */
30     function toString(uint256 value) internal pure returns (string memory) {
31         // Inspired by OraclizeAPI's implementation - MIT licence
32         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
33 
34         if (value == 0) {
35             return "0";
36         }
37         uint256 temp = value;
38         uint256 digits;
39         while (temp != 0) {
40             digits++;
41             temp /= 10;
42         }
43         bytes memory buffer = new bytes(digits);
44         while (value != 0) {
45             digits -= 1;
46             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
47             value /= 10;
48         }
49         return string(buffer);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
54      */
55     function toHexString(uint256 value) internal pure returns (string memory) {
56         if (value == 0) {
57             return "0x00";
58         }
59         uint256 temp = value;
60         uint256 length = 0;
61         while (temp != 0) {
62             length++;
63             temp >>= 8;
64         }
65         return toHexString(value, length);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
70      */
71     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
72         bytes memory buffer = new bytes(2 * length + 2);
73         buffer[0] = "0";
74         buffer[1] = "x";
75         for (uint256 i = 2 * length + 1; i > 1; --i) {
76             buffer[i] = _HEX_SYMBOLS[value & 0xf];
77             value >>= 4;
78         }
79         require(value == 0, "Strings: hex length insufficient");
80         return string(buffer);
81     }
82 }
83 
84 // File: @openzeppelin/contracts/utils/Context.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Provides information about the current execution context, including the
93  * sender of the transaction and its data. While these are generally available
94  * via msg.sender and msg.data, they should not be accessed in such a direct
95  * manner, since when dealing with meta-transactions the account sending and
96  * paying for execution may not be the actual sender (as far as an application
97  * is concerned).
98  *
99  * This contract is only required for intermediate, library-like contracts.
100  */
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/utils/Address.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
115 
116 pragma solidity ^0.8.1;
117 
118 /**
119  * @dev Collection of functions related to the address type
120  */
121 library Address {
122     /**
123      * @dev Returns true if `account` is a contract.
124      *
125      * [IMPORTANT]
126      * ====
127      * It is unsafe to assume that an address for which this function returns
128      * false is an externally-owned account (EOA) and not a contract.
129      *
130      * Among others, `isContract` will return false for the following
131      * types of addresses:
132      *
133      *  - an externally-owned account
134      *  - a contract in construction
135      *  - an address where a contract will be created
136      *  - an address where a contract lived, but was destroyed
137      * ====
138      *
139      * [IMPORTANT]
140      * ====
141      * You shouldn't rely on `isContract` to protect against flash loan attacks!
142      *
143      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
144      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
145      * constructor.
146      * ====
147      */
148     function isContract(address account) internal view returns (bool) {
149         // This method relies on extcodesize/address.code.length, which returns 0
150         // for contracts in construction, since the code is only stored at the end
151         // of the constructor execution.
152 
153         return account.code.length > 0;
154     }
155 
156     /**
157      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
158      * `recipient`, forwarding all available gas and reverting on errors.
159      *
160      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
161      * of certain opcodes, possibly making contracts go over the 2300 gas limit
162      * imposed by `transfer`, making them unable to receive funds via
163      * `transfer`. {sendValue} removes this limitation.
164      *
165      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
166      *
167      * IMPORTANT: because control is transferred to `recipient`, care must be
168      * taken to not create reentrancy vulnerabilities. Consider using
169      * {ReentrancyGuard} or the
170      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
171      */
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(address(this).balance >= amount, "Address: insufficient balance");
174 
175         (bool success, ) = recipient.call{value: amount}("");
176         require(success, "Address: unable to send value, recipient may have reverted");
177     }
178 
179     /**
180      * @dev Performs a Solidity function call using a low level `call`. A
181      * plain `call` is an unsafe replacement for a function call: use this
182      * function instead.
183      *
184      * If `target` reverts with a revert reason, it is bubbled up by this
185      * function (like regular Solidity function calls).
186      *
187      * Returns the raw returned data. To convert to the expected return value,
188      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
189      *
190      * Requirements:
191      *
192      * - `target` must be a contract.
193      * - calling `target` with `data` must not revert.
194      *
195      * _Available since v3.1._
196      */
197     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
198         return functionCall(target, data, "Address: low-level call failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
203      * `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCall(
208         address target,
209         bytes memory data,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         return functionCallWithValue(target, data, 0, errorMessage);
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
217      * but also transferring `value` wei to `target`.
218      *
219      * Requirements:
220      *
221      * - the calling contract must have an ETH balance of at least `value`.
222      * - the called Solidity function must be `payable`.
223      *
224      * _Available since v3.1._
225      */
226     function functionCallWithValue(
227         address target,
228         bytes memory data,
229         uint256 value
230     ) internal returns (bytes memory) {
231         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
236      * with `errorMessage` as a fallback revert reason when `target` reverts.
237      *
238      * _Available since v3.1._
239      */
240     function functionCallWithValue(
241         address target,
242         bytes memory data,
243         uint256 value,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         require(address(this).balance >= value, "Address: insufficient balance for call");
247         require(isContract(target), "Address: call to non-contract");
248 
249         (bool success, bytes memory returndata) = target.call{value: value}(data);
250         return verifyCallResult(success, returndata, errorMessage);
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
255      * but performing a static call.
256      *
257      * _Available since v3.3._
258      */
259     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
260         return functionStaticCall(target, data, "Address: low-level static call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
265      * but performing a static call.
266      *
267      * _Available since v3.3._
268      */
269     function functionStaticCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal view returns (bytes memory) {
274         require(isContract(target), "Address: static call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.staticcall(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but performing a delegate call.
283      *
284      * _Available since v3.4._
285      */
286     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
287         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
292      * but performing a delegate call.
293      *
294      * _Available since v3.4._
295      */
296     function functionDelegateCall(
297         address target,
298         bytes memory data,
299         string memory errorMessage
300     ) internal returns (bytes memory) {
301         require(isContract(target), "Address: delegate call to non-contract");
302 
303         (bool success, bytes memory returndata) = target.delegatecall(data);
304         return verifyCallResult(success, returndata, errorMessage);
305     }
306 
307     /**
308      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
309      * revert reason using the provided one.
310      *
311      * _Available since v4.3._
312      */
313     function verifyCallResult(
314         bool success,
315         bytes memory returndata,
316         string memory errorMessage
317     ) internal pure returns (bytes memory) {
318         if (success) {
319             return returndata;
320         } else {
321             // Look for revert reason and bubble it up if present
322             if (returndata.length > 0) {
323                 // The easiest way to bubble the revert reason is using memory via assembly
324 
325                 assembly {
326                     let returndata_size := mload(returndata)
327                     revert(add(32, returndata), returndata_size)
328                 }
329             } else {
330                 revert(errorMessage);
331             }
332         }
333     }
334 }
335 
336 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @title ERC721 token receiver interface
345  * @dev Interface for any contract that wants to support safeTransfers
346  * from ERC721 asset contracts.
347  */
348 interface IERC721Receiver {
349     /**
350      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
351      * by `operator` from `from`, this function is called.
352      *
353      * It must return its Solidity selector to confirm the token transfer.
354      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
355      *
356      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
357      */
358     function onERC721Received(
359         address operator,
360         address from,
361         uint256 tokenId,
362         bytes calldata data
363     ) external returns (bytes4);
364 }
365 
366 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
367 
368 
369 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
370 
371 pragma solidity ^0.8.0;
372 
373 /**
374  * @dev Interface of the ERC165 standard, as defined in the
375  * https://eips.ethereum.org/EIPS/eip-165[EIP].
376  *
377  * Implementers can declare support of contract interfaces, which can then be
378  * queried by others ({ERC165Checker}).
379  *
380  * For an implementation, see {ERC165}.
381  */
382 interface IERC165 {
383     /**
384      * @dev Returns true if this contract implements the interface defined by
385      * `interfaceId`. See the corresponding
386      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
387      * to learn more about how these ids are created.
388      *
389      * This function call must use less than 30 000 gas.
390      */
391     function supportsInterface(bytes4 interfaceId) external view returns (bool);
392 }
393 
394 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 
402 /**
403  * @dev Implementation of the {IERC165} interface.
404  *
405  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
406  * for the additional interface id that will be supported. For example:
407  *
408  * ```solidity
409  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
410  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
411  * }
412  * ```
413  *
414  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
415  */
416 abstract contract ERC165 is IERC165 {
417     /**
418      * @dev See {IERC165-supportsInterface}.
419      */
420     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
421         return interfaceId == type(IERC165).interfaceId;
422     }
423 }
424 
425 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
426 
427 
428 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 
433 /**
434  * @dev Required interface of an ERC721 compliant contract.
435  */
436 interface IERC721 is IERC165 {
437     /**
438      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
439      */
440     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
441 
442     /**
443      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
444      */
445     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
446 
447     /**
448      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
449      */
450     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
451 
452     /**
453      * @dev Returns the number of tokens in ``owner``'s account.
454      */
455     function balanceOf(address owner) external view returns (uint256 balance);
456 
457     /**
458      * @dev Returns the owner of the `tokenId` token.
459      *
460      * Requirements:
461      *
462      * - `tokenId` must exist.
463      */
464     function ownerOf(uint256 tokenId) external view returns (address owner);
465 
466     /**
467      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
468      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
469      *
470      * Requirements:
471      *
472      * - `from` cannot be the zero address.
473      * - `to` cannot be the zero address.
474      * - `tokenId` token must exist and be owned by `from`.
475      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
476      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
477      *
478      * Emits a {Transfer} event.
479      */
480     function safeTransferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) external;
485 
486     /**
487      * @dev Transfers `tokenId` token from `from` to `to`.
488      *
489      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
490      *
491      * Requirements:
492      *
493      * - `from` cannot be the zero address.
494      * - `to` cannot be the zero address.
495      * - `tokenId` token must be owned by `from`.
496      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
497      *
498      * Emits a {Transfer} event.
499      */
500     function transferFrom(
501         address from,
502         address to,
503         uint256 tokenId
504     ) external;
505 
506     /**
507      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
508      * The approval is cleared when the token is transferred.
509      *
510      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
511      *
512      * Requirements:
513      *
514      * - The caller must own the token or be an approved operator.
515      * - `tokenId` must exist.
516      *
517      * Emits an {Approval} event.
518      */
519     function approve(address to, uint256 tokenId) external;
520 
521     /**
522      * @dev Returns the account approved for `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function getApproved(uint256 tokenId) external view returns (address operator);
529 
530     /**
531      * @dev Approve or remove `operator` as an operator for the caller.
532      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
533      *
534      * Requirements:
535      *
536      * - The `operator` cannot be the caller.
537      *
538      * Emits an {ApprovalForAll} event.
539      */
540     function setApprovalForAll(address operator, bool _approved) external;
541 
542     /**
543      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
544      *
545      * See {setApprovalForAll}
546      */
547     function isApprovedForAll(address owner, address operator) external view returns (bool);
548 
549     /**
550      * @dev Safely transfers `tokenId` token from `from` to `to`.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must exist and be owned by `from`.
557      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
558      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
559      *
560      * Emits a {Transfer} event.
561      */
562     function safeTransferFrom(
563         address from,
564         address to,
565         uint256 tokenId,
566         bytes calldata data
567     ) external;
568 }
569 
570 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
571 
572 
573 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 
578 /**
579  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
580  * @dev See https://eips.ethereum.org/EIPS/eip-721
581  */
582 interface IERC721Enumerable is IERC721 {
583     /**
584      * @dev Returns the total amount of tokens stored by the contract.
585      */
586     function totalSupply() external view returns (uint256);
587 
588     /**
589      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
590      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
591      */
592     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
593 
594     /**
595      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
596      * Use along with {totalSupply} to enumerate all tokens.
597      */
598     function tokenByIndex(uint256 index) external view returns (uint256);
599 }
600 
601 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
602 
603 
604 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 
609 /**
610  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
611  * @dev See https://eips.ethereum.org/EIPS/eip-721
612  */
613 interface IERC721Metadata is IERC721 {
614     /**
615      * @dev Returns the token collection name.
616      */
617     function name() external view returns (string memory);
618 
619     /**
620      * @dev Returns the token collection symbol.
621      */
622     function symbol() external view returns (string memory);
623 
624     /**
625      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
626      */
627     function tokenURI(uint256 tokenId) external view returns (string memory);
628 }
629 
630 // File: skeletonz.sol
631 
632 
633 
634 pragma solidity ^0.8.4;
635 
636 
637 
638 
639 
640 
641 
642 
643 
644 error ApprovalCallerNotOwnerNorApproved();
645 error ApprovalQueryForNonexistentToken();
646 error ApproveToCaller();
647 error ApprovalToCurrentOwner();
648 error BalanceQueryForZeroAddress();
649 error MintedQueryForZeroAddress();
650 error BurnedQueryForZeroAddress();
651 error AuxQueryForZeroAddress();
652 error MintToZeroAddress();
653 error MintZeroQuantity();
654 error OwnerIndexOutOfBounds();
655 error OwnerQueryForNonexistentToken();
656 error TokenIndexOutOfBounds();
657 error TransferCallerNotOwnerNorApproved();
658 error TransferFromIncorrectOwner();
659 error TransferToNonERC721ReceiverImplementer();
660 error TransferToZeroAddress();
661 error URIQueryForNonexistentToken();
662 
663 /**
664  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
665  * the Metadata extension. Built to optimize for lower gas during batch mints.
666  *
667  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
668  *
669  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
670  *
671  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
672  */
673 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
674     using Address for address;
675     using Strings for uint256;
676 
677     // Compiler will pack this into a single 256bit word.
678     struct TokenOwnership {
679         // The address of the owner.
680         address addr;
681         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
682         uint64 startTimestamp;
683         // Whether the token has been burned.
684         bool burned;
685     }
686 
687     // Compiler will pack this into a single 256bit word.
688     struct AddressData {
689         // Realistically, 2**64-1 is more than enough.
690         uint64 balance;
691         // Keeps track of mint count with minimal overhead for tokenomics.
692         uint64 numberMinted;
693         // Keeps track of burn count with minimal overhead for tokenomics.
694         uint64 numberBurned;
695         // For miscellaneous variable(s) pertaining to the address
696         // (e.g. number of whitelist mint slots used). 
697         // If there are multiple variables, please pack them into a uint64.
698         uint64 aux;
699     }
700 
701     // The tokenId of the next token to be minted.
702     uint256 internal _currentIndex;
703 
704     // The number of tokens burned.
705     uint256 internal _burnCounter;
706 
707     // Token name
708     string private _name;
709 
710     // Token symbol
711     string private _symbol;
712 
713     // Mapping from token ID to ownership details
714     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
715     mapping(uint256 => TokenOwnership) internal _ownerships;
716 
717     // Mapping owner address to address data
718     mapping(address => AddressData) private _addressData;
719 
720     // Mapping from token ID to approved address
721     mapping(uint256 => address) private _tokenApprovals;
722 
723     // Mapping from owner to operator approvals
724     mapping(address => mapping(address => bool)) private _operatorApprovals;
725 
726     constructor(string memory name_, string memory symbol_) {
727         _name = name_;
728         _symbol = symbol_;
729     }
730 
731     /**
732      * @dev See {IERC721Enumerable-totalSupply}.
733      */
734     function totalSupply() public view returns (uint256) {
735         // Counter underflow is impossible as _burnCounter cannot be incremented
736         // more than _currentIndex times
737         unchecked {
738             return _currentIndex - _burnCounter;    
739         }
740     }
741 
742     /**
743      * @dev See {IERC165-supportsInterface}.
744      */
745     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
746         return
747             interfaceId == type(IERC721).interfaceId ||
748             interfaceId == type(IERC721Metadata).interfaceId ||
749             super.supportsInterface(interfaceId);
750     }
751 
752     /**
753      * @dev See {IERC721-balanceOf}.
754      */
755     function balanceOf(address owner) public view override returns (uint256) {
756         if (owner == address(0)) revert BalanceQueryForZeroAddress();
757         return uint256(_addressData[owner].balance);
758     }
759 
760     /**
761      * Returns the number of tokens minted by `owner`.
762      */
763     function _numberMinted(address owner) internal view returns (uint256) {
764         if (owner == address(0)) revert MintedQueryForZeroAddress();
765         return uint256(_addressData[owner].numberMinted);
766     }
767 
768     /**
769      * Returns the number of tokens burned by or on behalf of `owner`.
770      */
771     function _numberBurned(address owner) internal view returns (uint256) {
772         if (owner == address(0)) revert BurnedQueryForZeroAddress();
773         return uint256(_addressData[owner].numberBurned);
774     }
775 
776     /**
777      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
778      */
779     function _getAux(address owner) internal view returns (uint64) {
780         if (owner == address(0)) revert AuxQueryForZeroAddress();
781         return _addressData[owner].aux;
782     }
783 
784     /**
785      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
786      * If there are multiple variables, please pack them into a uint64.
787      */
788     function _setAux(address owner, uint64 aux) internal {
789         if (owner == address(0)) revert AuxQueryForZeroAddress();
790         _addressData[owner].aux = aux;
791     }
792 
793     /**
794      * Gas spent here starts off proportional to the maximum mint batch size.
795      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
796      */
797     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
798         uint256 curr = tokenId;
799 
800         unchecked {
801             if (curr < _currentIndex) {
802                 TokenOwnership memory ownership = _ownerships[curr];
803                 if (!ownership.burned) {
804                     if (ownership.addr != address(0)) {
805                         return ownership;
806                     }
807                     // Invariant: 
808                     // There will always be an ownership that has an address and is not burned 
809                     // before an ownership that does not have an address and is not burned.
810                     // Hence, curr will not underflow.
811                     while (true) {
812                         curr--;
813                         ownership = _ownerships[curr];
814                         if (ownership.addr != address(0)) {
815                             return ownership;
816                         }
817                     }
818                 }
819             }
820         }
821         revert OwnerQueryForNonexistentToken();
822     }
823 
824     /**
825      * @dev See {IERC721-ownerOf}.
826      */
827     function ownerOf(uint256 tokenId) public view override returns (address) {
828         return ownershipOf(tokenId).addr;
829     }
830 
831     /**
832      * @dev See {IERC721Metadata-name}.
833      */
834     function name() public view virtual override returns (string memory) {
835         return _name;
836     }
837 
838     /**
839      * @dev See {IERC721Metadata-symbol}.
840      */
841     function symbol() public view virtual override returns (string memory) {
842         return _symbol;
843     }
844 
845     /**
846      * @dev See {IERC721Metadata-tokenURI}.
847      */
848     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
849         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
850 
851         string memory baseURI = _baseURI();
852         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
853     }
854 
855     /**
856      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
857      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
858      * by default, can be overriden in child contracts.
859      */
860     function _baseURI() internal view virtual returns (string memory) {
861         return '';
862     }
863 
864     /**
865      * @dev See {IERC721-approve}.
866      */
867     function approve(address to, uint256 tokenId) public override {
868         address owner = ERC721A.ownerOf(tokenId);
869         if (to == owner) revert ApprovalToCurrentOwner();
870 
871         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
872             revert ApprovalCallerNotOwnerNorApproved();
873         }
874 
875         _approve(to, tokenId, owner);
876     }
877 
878     /**
879      * @dev See {IERC721-getApproved}.
880      */
881     function getApproved(uint256 tokenId) public view override returns (address) {
882         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
883 
884         return _tokenApprovals[tokenId];
885     }
886 
887     /**
888      * @dev See {IERC721-setApprovalForAll}.
889      */
890     function setApprovalForAll(address operator, bool approved) public override {
891         if (operator == _msgSender()) revert ApproveToCaller();
892 
893         _operatorApprovals[_msgSender()][operator] = approved;
894         emit ApprovalForAll(_msgSender(), operator, approved);
895     }
896 
897     /**
898      * @dev See {IERC721-isApprovedForAll}.
899      */
900     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
901         return _operatorApprovals[owner][operator];
902     }
903 
904     /**
905      * @dev See {IERC721-transferFrom}.
906      */
907     function transferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public virtual override {
912         _transfer(from, to, tokenId);
913     }
914 
915     /**
916      * @dev See {IERC721-safeTransferFrom}.
917      */
918     function safeTransferFrom(
919         address from,
920         address to,
921         uint256 tokenId
922     ) public virtual override {
923         safeTransferFrom(from, to, tokenId, '');
924     }
925 
926     /**
927      * @dev See {IERC721-safeTransferFrom}.
928      */
929     function safeTransferFrom(
930         address from,
931         address to,
932         uint256 tokenId,
933         bytes memory _data
934     ) public virtual override {
935         _transfer(from, to, tokenId);
936         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
937             revert TransferToNonERC721ReceiverImplementer();
938         }
939     }
940 
941     /**
942      * @dev Returns whether `tokenId` exists.
943      *
944      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
945      *
946      * Tokens start existing when they are minted (`_mint`),
947      */
948     function _exists(uint256 tokenId) internal view returns (bool) {
949         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
950     }
951 
952     function _safeMint(address to, uint256 quantity) internal {
953         _safeMint(to, quantity, '');
954     }
955 
956     /**
957      * @dev Safely mints `quantity` tokens and transfers them to `to`.
958      *
959      * Requirements:
960      *
961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
962      * - `quantity` must be greater than 0.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _safeMint(
967         address to,
968         uint256 quantity,
969         bytes memory _data
970     ) internal {
971         _mint(to, quantity, _data, true);
972     }
973 
974     /**
975      * @dev Mints `quantity` tokens and transfers them to `to`.
976      *
977      * Requirements:
978      *
979      * - `to` cannot be the zero address.
980      * - `quantity` must be greater than 0.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _mint(
985         address to,
986         uint256 quantity,
987         bytes memory _data,
988         bool safe
989     ) internal {
990         uint256 startTokenId = _currentIndex;
991         if (to == address(0)) revert MintToZeroAddress();
992         if (quantity == 0) revert MintZeroQuantity();
993 
994         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
995 
996         // Overflows are incredibly unrealistic.
997         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
998         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
999         unchecked {
1000             _addressData[to].balance += uint64(quantity);
1001             _addressData[to].numberMinted += uint64(quantity);
1002 
1003             _ownerships[startTokenId].addr = to;
1004             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1005 
1006             uint256 updatedIndex = startTokenId;
1007 
1008             for (uint256 i; i < quantity; i++) {
1009                 emit Transfer(address(0), to, updatedIndex);
1010                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1011                     revert TransferToNonERC721ReceiverImplementer();
1012                 }
1013                 updatedIndex++;
1014             }
1015 
1016             _currentIndex = updatedIndex;
1017         }
1018         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1019     }
1020 
1021     /**
1022      * @dev Transfers `tokenId` from `from` to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must be owned by `from`.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _transfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) private {
1036         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1037 
1038         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1039             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1040             getApproved(tokenId) == _msgSender());
1041 
1042         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1043         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1044         if (to == address(0)) revert TransferToZeroAddress();
1045 
1046         _beforeTokenTransfers(from, to, tokenId, 1);
1047 
1048         // Clear approvals from the previous owner
1049         _approve(address(0), tokenId, prevOwnership.addr);
1050 
1051         // Underflow of the sender's balance is impossible because we check for
1052         // ownership above and the recipient's balance can't realistically overflow.
1053         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1054         unchecked {
1055             _addressData[from].balance -= 1;
1056             _addressData[to].balance += 1;
1057 
1058             _ownerships[tokenId].addr = to;
1059             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1060 
1061             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1062             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1063             uint256 nextTokenId = tokenId + 1;
1064             if (_ownerships[nextTokenId].addr == address(0)) {
1065                 // This will suffice for checking _exists(nextTokenId),
1066                 // as a burned slot cannot contain the zero address.
1067                 if (nextTokenId < _currentIndex) {
1068                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1069                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1070                 }
1071             }
1072         }
1073 
1074         emit Transfer(from, to, tokenId);
1075         _afterTokenTransfers(from, to, tokenId, 1);
1076     }
1077 
1078     /**
1079      * @dev Destroys `tokenId`.
1080      * The approval is cleared when the token is burned.
1081      *
1082      * Requirements:
1083      *
1084      * - `tokenId` must exist.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _burn(uint256 tokenId) internal virtual {
1089         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1090 
1091         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1092 
1093         // Clear approvals from the previous owner
1094         _approve(address(0), tokenId, prevOwnership.addr);
1095 
1096         // Underflow of the sender's balance is impossible because we check for
1097         // ownership above and the recipient's balance can't realistically overflow.
1098         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1099         unchecked {
1100             _addressData[prevOwnership.addr].balance -= 1;
1101             _addressData[prevOwnership.addr].numberBurned += 1;
1102 
1103             // Keep track of who burned the token, and the timestamp of burning.
1104             _ownerships[tokenId].addr = prevOwnership.addr;
1105             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1106             _ownerships[tokenId].burned = true;
1107 
1108             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1109             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1110             uint256 nextTokenId = tokenId + 1;
1111             if (_ownerships[nextTokenId].addr == address(0)) {
1112                 // This will suffice for checking _exists(nextTokenId),
1113                 // as a burned slot cannot contain the zero address.
1114                 if (nextTokenId < _currentIndex) {
1115                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1116                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1117                 }
1118             }
1119         }
1120 
1121         emit Transfer(prevOwnership.addr, address(0), tokenId);
1122         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1123 
1124         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1125         unchecked { 
1126             _burnCounter++;
1127         }
1128     }
1129 
1130     /**
1131      * @dev Approve `to` to operate on `tokenId`
1132      *
1133      * Emits a {Approval} event.
1134      */
1135     function _approve(
1136         address to,
1137         uint256 tokenId,
1138         address owner
1139     ) private {
1140         _tokenApprovals[tokenId] = to;
1141         emit Approval(owner, to, tokenId);
1142     }
1143 
1144     /**
1145      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1146      * The call is not executed if the target address is not a contract.
1147      *
1148      * @param from address representing the previous owner of the given token ID
1149      * @param to target address that will receive the tokens
1150      * @param tokenId uint256 ID of the token to be transferred
1151      * @param _data bytes optional data to send along with the call
1152      * @return bool whether the call correctly returned the expected magic value
1153      */
1154     function _checkOnERC721Received(
1155         address from,
1156         address to,
1157         uint256 tokenId,
1158         bytes memory _data
1159     ) private returns (bool) {
1160         if (to.isContract()) {
1161             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1162                 return retval == IERC721Receiver(to).onERC721Received.selector;
1163             } catch (bytes memory reason) {
1164                 if (reason.length == 0) {
1165                     revert TransferToNonERC721ReceiverImplementer();
1166                 } else {
1167                     assembly {
1168                         revert(add(32, reason), mload(reason))
1169                     }
1170                 }
1171             }
1172         } else {
1173             return true;
1174         }
1175     }
1176 
1177     /**
1178      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1179      * And also called before burning one token.
1180      *
1181      * startTokenId - the first token id to be transferred
1182      * quantity - the amount to be transferred
1183      *
1184      * Calling conditions:
1185      *
1186      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1187      * transferred to `to`.
1188      * - When `from` is zero, `tokenId` will be minted for `to`.
1189      * - When `to` is zero, `tokenId` will be burned by `from`.
1190      * - `from` and `to` are never both zero.
1191      */
1192     function _beforeTokenTransfers(
1193         address from,
1194         address to,
1195         uint256 startTokenId,
1196         uint256 quantity
1197     ) internal virtual {}
1198 
1199     /**
1200      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1201      * minting.
1202      * And also called after one token has been burned.
1203      *
1204      * startTokenId - the first token id to be transferred
1205      * quantity - the amount to be transferred
1206      *
1207      * Calling conditions:
1208      *
1209      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1210      * transferred to `to`.
1211      * - When `from` is zero, `tokenId` has been minted for `to`.
1212      * - When `to` is zero, `tokenId` has been burned by `from`.
1213      * - `from` and `to` are never both zero.
1214      */
1215     function _afterTokenTransfers(
1216         address from,
1217         address to,
1218         uint256 startTokenId,
1219         uint256 quantity
1220     ) internal virtual {}
1221 }
1222 
1223 
1224 
1225 /**
1226  * @dev Contract module which provides a basic access control mechanism, where
1227  * there is an account (an owner) that can be granted exclusive access to
1228  * specific functions.
1229  *
1230  * By default, the owner account will be the one that deploys the contract. This
1231  * can later be changed with {transferOwnership}.
1232  *
1233  * This module is used through inheritance. It will make available the modifier
1234  * `onlyOwner`, which can be applied to your functions to restrict their use to
1235  * the owner.
1236  */
1237 abstract contract Ownable is Context {
1238     address private _owner;
1239 
1240     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1241 
1242     /**
1243      * @dev Initializes the contract setting the deployer as the initial owner.
1244      */
1245     constructor() {
1246         _setOwner(_msgSender());
1247     }
1248 
1249     /**
1250      * @dev Returns the address of the current owner.
1251      */
1252     function owner() public view virtual returns (address) {
1253         return _owner;
1254     }
1255 
1256     /**
1257      * @dev Throws if called by any account other than the owner.
1258      */
1259     modifier onlyOwner() {
1260         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1261         _;
1262     }
1263 
1264     /**
1265      * @dev Leaves the contract without owner. It will not be possible to call
1266      * `onlyOwner` functions anymore. Can only be called by the current owner.
1267      *
1268      * NOTE: Renouncing ownership will leave the contract without an owner,
1269      * thereby removing any functionality that is only available to the owner.
1270      */
1271     function renounceOwnership() public virtual onlyOwner {
1272         _setOwner(address(0));
1273     }
1274 
1275     /**
1276      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1277      * Can only be called by the current owner.
1278      */
1279     function transferOwnership(address newOwner) public virtual onlyOwner {
1280         require(newOwner != address(0), "Ownable: new owner is the zero address");
1281         _setOwner(newOwner);
1282     }
1283 
1284     function _setOwner(address newOwner) private {
1285         address oldOwner = _owner;
1286         _owner = newOwner;
1287         emit OwnershipTransferred(oldOwner, newOwner);
1288     }
1289 }
1290 
1291 
1292 /**
1293  * @dev Contract module that helps prevent reentrant calls to a function.
1294  *
1295  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1296  * available, which can be applied to functions to make sure there are no nested
1297  * (reentrant) calls to them.
1298  *
1299  * Note that because there is a single `nonReentrant` guard, functions marked as
1300  * `nonReentrant` may not call one another. This can be worked around by making
1301  * those functions `private`, and then adding `external` `nonReentrant` entry
1302  * points to them.
1303  *
1304  * TIP: If you would like to learn more about reentrancy and alternative ways
1305  * to protect against it, check out our blog post
1306  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1307  */
1308 abstract contract ReentrancyGuard {
1309     // Booleans are more expensive than uint256 or any type that takes up a full
1310     // word because each write operation emits an extra SLOAD to first read the
1311     // slot's contents, replace the bits taken up by the boolean, and then write
1312     // back. This is the compiler's defense against contract upgrades and
1313     // pointer aliasing, and it cannot be disabled.
1314 
1315     // The values being non-zero value makes deployment a bit more expensive,
1316     // but in exchange the refund on every call to nonReentrant will be lower in
1317     // amount. Since refunds are capped to a percentage of the total
1318     // transaction's gas, it is best to keep them low in cases like this one, to
1319     // increase the likelihood of the full refund coming into effect.
1320     uint256 private constant _NOT_ENTERED = 1;
1321     uint256 private constant _ENTERED = 2;
1322 
1323     uint256 private _status;
1324 
1325     constructor() {
1326         _status = _NOT_ENTERED;
1327     }
1328 
1329     /**
1330      * @dev Prevents a contract from calling itself, directly or indirectly.
1331      * Calling a `nonReentrant` function from another `nonReentrant`
1332      * function is not supported. It is possible to prevent this from happening
1333      * by making the `nonReentrant` function external, and make it call a
1334      * `private` function that does the actual work.
1335      */
1336     modifier nonReentrant() {
1337         // On the first call to nonReentrant, _notEntered will be true
1338         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1339 
1340         // Any calls to nonReentrant after this point will fail
1341         _status = _ENTERED;
1342 
1343         _;
1344 
1345         // By storing the original value once again, a refund is triggered (see
1346         // https://eips.ethereum.org/EIPS/eip-2200)
1347         _status = _NOT_ENTERED;
1348     }
1349 }
1350 
1351 
1352 /**
1353  * @dev These functions deal with verification of Merkle Trees proofs.
1354  *
1355  * The proofs can be generated using the JavaScript library
1356  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1357  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1358  *
1359  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1360  */
1361 library MerkleProof {
1362     /**
1363      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1364      * defined by `root`. For this, a `proof` must be provided, containing
1365      * sibling hashes on the branch from the leaf to the root of the tree. Each
1366      * pair of leaves and each pair of pre-images are assumed to be sorted.
1367      */
1368     function verify(
1369         bytes32[] memory proof,
1370         bytes32 root,
1371         bytes32 leaf
1372     ) internal pure returns (bool) {
1373         return processProof(proof, leaf) == root;
1374     }
1375 
1376     /**
1377      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1378      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1379      * hash matches the root of the tree. When processing the proof, the pairs
1380      * of leafs & pre-images are assumed to be sorted.
1381      *
1382      * _Available since v4.4._
1383      */
1384     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1385         bytes32 computedHash = leaf;
1386         for (uint256 i = 0; i < proof.length; i++) {
1387             bytes32 proofElement = proof[i];
1388             if (computedHash <= proofElement) {
1389                 // Hash(current computed hash + current element of the proof)
1390                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1391             } else {
1392                 // Hash(current element of the proof + current computed hash)
1393                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1394             }
1395         }
1396         return computedHash;
1397     }
1398 }
1399 
1400 contract Skeletonz is ERC721A, ReentrancyGuard, Ownable {
1401 	
1402 	uint public constant maxTokens = 1500;
1403     uint public total = 0;
1404 	
1405 	uint whitelistMintCost = 0.075 ether;
1406 	uint publicMintCost = 0.08 ether;
1407 
1408     uint public whitelistMintStart;
1409     uint public publicMintStart;
1410 	
1411 	string internal baseTokenURI;
1412 	string baseTokenURI_extension = ".json";
1413 	
1414 	// Mapping for wallet addresses that have previously minted
1415     mapping(address => uint256) private _whitelistMinters;
1416 
1417 	bytes32 _rootHash;
1418 	
1419 	bool ownerMinted;
1420 	
1421 	constructor() ERC721A("Skeletonz", "Skeleton") Ownable() {
1422 
1423         whitelistMintStart = 1647181800; // 13. March 2022 - 14:30 UTC
1424         publicMintStart = 1647196200; // 13. March 2022 - 18:30 UTC (+4 hours)
1425 		
1426 	}
1427 
1428     function checkTotal() public view returns (uint) {
1429         return total;
1430     }
1431 	
1432     function checkUserStatus(address _address) public view returns (uint) {
1433         return _whitelistMinters[_address];
1434     }
1435 
1436 	// Setters
1437     function setWhitelistMintStart(uint _timestamp) external onlyOwner {
1438         whitelistMintStart = _timestamp;
1439     }
1440 	
1441     function setPublicMintStart(uint _timestamp) external onlyOwner {
1442         publicMintStart = _timestamp;
1443     }
1444 
1445 	function setBaseTokenURI(string memory _uri) external onlyOwner {
1446         baseTokenURI = _uri;
1447     }
1448 	
1449 	function setBaseTokenURI_extension(string memory _ext) external onlyOwner {
1450         baseTokenURI_extension = _ext;
1451     }
1452 	
1453 	function tokenURI(uint tokenId_) public view override returns (string memory) {
1454         require(_exists(tokenId_), "Query for non-existent token!");
1455         return string(abi.encodePacked(baseTokenURI, Strings.toString(tokenId_), baseTokenURI_extension));
1456     }
1457 	
1458 	function setRootHash(bytes32 rootHash) external onlyOwner {
1459         _rootHash = rootHash;
1460     }
1461 	
1462 	// Claim
1463 	function ownerMint() public onlyOwner nonReentrant {
1464 		require(ownerMinted == false, "Already minted!");
1465 		
1466 		ownerMinted = true;
1467         total += 50;
1468         _safeMint(0x57cC2Cd9beF932da7Ec9ca33C0aA80041482283B, 50);
1469     }
1470 
1471 	function whitelistMint(bytes32[] memory proof, uint256 quantity) public nonReentrant payable {
1472         require(whitelistMintStart < block.timestamp, "Whitelist mint not started yet");
1473         require(publicMintStart > block.timestamp, "Whitelist mint is over");
1474 		require(quantity <= 2, "Maximum number of tokens is 2");
1475         require(total + quantity < maxTokens, "Mint over the max tokens limit"); // This will never happen, remove?
1476 		require(msg.value == whitelistMintCost * quantity, "Incorrect mint cost value");
1477 		
1478 		// Merkle tree validation
1479 		bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1480 		require(MerkleProof.verify(proof, _rootHash, leaf), "Invalid proof");
1481 		
1482         require(_whitelistMinters[_msgSender()] < 1, "You've already minted");
1483 		
1484         total += quantity;
1485 
1486         // Set the _whitelistMinters to 1 as it has already minted
1487         _whitelistMinters[_msgSender()] = 1;
1488 
1489         _safeMint(_msgSender(), quantity);
1490     }
1491 
1492 	function publicMint(uint256 quantity) external nonReentrant payable {
1493 		require(publicMintStart < block.timestamp, "Public mint not started yet");
1494         require(total + quantity < maxTokens, "Mint over the max tokens limit");
1495         require(quantity <= 5, "Maximum number of tokens is 5");
1496         require(msg.value == publicMintCost * quantity, "Incorrect mint cost value");
1497 		
1498         total += quantity;
1499 
1500         _safeMint(_msgSender(), quantity);
1501 	}
1502   
1503   
1504   	// Withdraw Ether
1505     function withdrawEther() public onlyOwner {
1506         
1507         uint remainingValue = address(this).balance;
1508 
1509         address community = 0x57cC2Cd9beF932da7Ec9ca33C0aA80041482283B;
1510         address wallet_1 = 0x46619B41C15E92D4dc24094aBaD304F10Bd730dB;
1511         address wallet_2 = 0x59f1AFBD895eFF95d0D61824C16287597AF2D0E7;
1512 
1513         uint communityValue = remainingValue * 50 / 100;
1514         remainingValue = remainingValue - communityValue;
1515 
1516         uint wallet1Value = remainingValue * 90 / 100;
1517         remainingValue = remainingValue - wallet1Value;
1518 
1519         uint wallet2Value = remainingValue;
1520 
1521         payable(community).transfer(communityValue); 
1522         payable(wallet_1).transfer(wallet1Value); 
1523         payable(wallet_2).transfer(wallet2Value); 
1524 
1525     }
1526   
1527   
1528 }