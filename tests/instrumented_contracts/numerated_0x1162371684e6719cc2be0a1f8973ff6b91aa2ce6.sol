1 /*
2 
3 ▄▄▄█████▓ ██░ ██ ▓█████     ▄████▄   ██░ ██  ▒█████    ██████ ▓█████  ███▄    █   ██████ 
4 ▓  ██▒ ▓▒▓██░ ██▒▓█   ▀    ▒██▀ ▀█  ▓██░ ██▒▒██▒  ██▒▒██    ▒ ▓█   ▀  ██ ▀█   █ ▒██    ▒ 
5 ▒ ▓██░ ▒░▒██▀▀██░▒███      ▒▓█    ▄ ▒██▀▀██░▒██░  ██▒░ ▓██▄   ▒███   ▓██  ▀█ ██▒░ ▓██▄   
6 ░ ▓██▓ ░ ░▓█ ░██ ▒▓█  ▄    ▒▓▓▄ ▄██▒░▓█ ░██ ▒██   ██░  ▒   ██▒▒▓█  ▄ ▓██▒  ▐▌██▒  ▒   ██▒
7   ▒██▒ ░ ░▓█▒░██▓░▒████▒   ▒ ▓███▀ ░░▓█▒░██▓░ ████▓▒░▒██████▒▒░▒████▒▒██░   ▓██░▒██████▒▒
8   ▒ ░░    ▒ ░░▒░▒░░ ▒░ ░   ░ ░▒ ▒  ░ ▒ ░░▒░▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░░░ ▒░ ░░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░
9     ░     ▒ ░▒░ ░ ░ ░  ░     ░  ▒    ▒ ░▒░ ░  ░ ▒ ▒░ ░ ░▒  ░ ░ ░ ░  ░░ ░░   ░ ▒░░ ░▒  ░ ░
10   ░       ░  ░░ ░   ░      ░         ░  ░░ ░░ ░ ░ ▒  ░  ░  ░     ░      ░   ░ ░ ░  ░  ░  
11           ░  ░  ░   ░  ░   ░ ░       ░  ░  ░    ░ ░        ░     ░  ░         ░       ░  
12                            ░                                                             
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev String operations.
21  */
22 library Strings {
23     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
24 
25     /**
26      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
27      */
28     function toString(uint256 value) internal pure returns (string memory) {
29         // Inspired by OraclizeAPI's implementation - MIT licence
30         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
31 
32         if (value == 0) {
33             return "0";
34         }
35         uint256 temp = value;
36         uint256 digits;
37         while (temp != 0) {
38             digits++;
39             temp /= 10;
40         }
41         bytes memory buffer = new bytes(digits);
42         while (value != 0) {
43             digits -= 1;
44             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
45             value /= 10;
46         }
47         return string(buffer);
48     }
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
52      */
53     function toHexString(uint256 value) internal pure returns (string memory) {
54         if (value == 0) {
55             return "0x00";
56         }
57         uint256 temp = value;
58         uint256 length = 0;
59         while (temp != 0) {
60             length++;
61             temp >>= 8;
62         }
63         return toHexString(value, length);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
68      */
69     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
70         bytes memory buffer = new bytes(2 * length + 2);
71         buffer[0] = "0";
72         buffer[1] = "x";
73         for (uint256 i = 2 * length + 1; i > 1; --i) {
74             buffer[i] = _HEX_SYMBOLS[value & 0xf];
75             value >>= 4;
76         }
77         require(value == 0, "Strings: hex length insufficient");
78         return string(buffer);
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/Context.sol
83 
84 
85 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
86 
87 pragma solidity ^0.8.0;
88 
89 /**
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes calldata) {
105         return msg.data;
106     }
107 }
108 
109 // File: @openzeppelin/contracts/utils/Address.sol
110 
111 
112 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
113 
114 pragma solidity ^0.8.1;
115 
116 /**
117  * @dev Collection of functions related to the address type
118  */
119 library Address {
120     /**
121      * @dev Returns true if `account` is a contract.
122      *
123      * [IMPORTANT]
124      * ====
125      * It is unsafe to assume that an address for which this function returns
126      * false is an externally-owned account (EOA) and not a contract.
127      *
128      * Among others, `isContract` will return false for the following
129      * types of addresses:
130      *
131      *  - an externally-owned account
132      *  - a contract in construction
133      *  - an address where a contract will be created
134      *  - an address where a contract lived, but was destroyed
135      * ====
136      *
137      * [IMPORTANT]
138      * ====
139      * You shouldn't rely on `isContract` to protect against flash loan attacks!
140      *
141      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
142      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
143      * constructor.
144      * ====
145      */
146     function isContract(address account) internal view returns (bool) {
147         // This method relies on extcodesize/address.code.length, which returns 0
148         // for contracts in construction, since the code is only stored at the end
149         // of the constructor execution.
150 
151         return account.code.length > 0;
152     }
153 
154     /**
155      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
156      * `recipient`, forwarding all available gas and reverting on errors.
157      *
158      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
159      * of certain opcodes, possibly making contracts go over the 2300 gas limit
160      * imposed by `transfer`, making them unable to receive funds via
161      * `transfer`. {sendValue} removes this limitation.
162      *
163      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
164      *
165      * IMPORTANT: because control is transferred to `recipient`, care must be
166      * taken to not create reentrancy vulnerabilities. Consider using
167      * {ReentrancyGuard} or the
168      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
169      */
170     function sendValue(address payable recipient, uint256 amount) internal {
171         require(address(this).balance >= amount, "Address: insufficient balance");
172 
173         (bool success, ) = recipient.call{value: amount}("");
174         require(success, "Address: unable to send value, recipient may have reverted");
175     }
176 
177     /**
178      * @dev Performs a Solidity function call using a low level `call`. A
179      * plain `call` is an unsafe replacement for a function call: use this
180      * function instead.
181      *
182      * If `target` reverts with a revert reason, it is bubbled up by this
183      * function (like regular Solidity function calls).
184      *
185      * Returns the raw returned data. To convert to the expected return value,
186      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
187      *
188      * Requirements:
189      *
190      * - `target` must be a contract.
191      * - calling `target` with `data` must not revert.
192      *
193      * _Available since v3.1._
194      */
195     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
196         return functionCall(target, data, "Address: low-level call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
201      * `errorMessage` as a fallback revert reason when `target` reverts.
202      *
203      * _Available since v3.1._
204      */
205     function functionCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         return functionCallWithValue(target, data, 0, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but also transferring `value` wei to `target`.
216      *
217      * Requirements:
218      *
219      * - the calling contract must have an ETH balance of at least `value`.
220      * - the called Solidity function must be `payable`.
221      *
222      * _Available since v3.1._
223      */
224     function functionCallWithValue(
225         address target,
226         bytes memory data,
227         uint256 value
228     ) internal returns (bytes memory) {
229         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
234      * with `errorMessage` as a fallback revert reason when `target` reverts.
235      *
236      * _Available since v3.1._
237      */
238     function functionCallWithValue(
239         address target,
240         bytes memory data,
241         uint256 value,
242         string memory errorMessage
243     ) internal returns (bytes memory) {
244         require(address(this).balance >= value, "Address: insufficient balance for call");
245         require(isContract(target), "Address: call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.call{value: value}(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a static call.
254      *
255      * _Available since v3.3._
256      */
257     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
258         return functionStaticCall(target, data, "Address: low-level static call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
263      * but performing a static call.
264      *
265      * _Available since v3.3._
266      */
267     function functionStaticCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal view returns (bytes memory) {
272         require(isContract(target), "Address: static call to non-contract");
273 
274         (bool success, bytes memory returndata) = target.staticcall(data);
275         return verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
285         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
290      * but performing a delegate call.
291      *
292      * _Available since v3.4._
293      */
294     function functionDelegateCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         require(isContract(target), "Address: delegate call to non-contract");
300 
301         (bool success, bytes memory returndata) = target.delegatecall(data);
302         return verifyCallResult(success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
307      * revert reason using the provided one.
308      *
309      * _Available since v4.3._
310      */
311     function verifyCallResult(
312         bool success,
313         bytes memory returndata,
314         string memory errorMessage
315     ) internal pure returns (bytes memory) {
316         if (success) {
317             return returndata;
318         } else {
319             // Look for revert reason and bubble it up if present
320             if (returndata.length > 0) {
321                 // The easiest way to bubble the revert reason is using memory via assembly
322 
323                 assembly {
324                     let returndata_size := mload(returndata)
325                     revert(add(32, returndata), returndata_size)
326                 }
327             } else {
328                 revert(errorMessage);
329             }
330         }
331     }
332 }
333 
334 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
335 
336 
337 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @title ERC721 token receiver interface
343  * @dev Interface for any contract that wants to support safeTransfers
344  * from ERC721 asset contracts.
345  */
346 interface IERC721Receiver {
347     /**
348      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
349      * by `operator` from `from`, this function is called.
350      *
351      * It must return its Solidity selector to confirm the token transfer.
352      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
353      *
354      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
355      */
356     function onERC721Received(
357         address operator,
358         address from,
359         uint256 tokenId,
360         bytes calldata data
361     ) external returns (bytes4);
362 }
363 
364 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
365 
366 
367 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
368 
369 pragma solidity ^0.8.0;
370 
371 /**
372  * @dev Interface of the ERC165 standard, as defined in the
373  * https://eips.ethereum.org/EIPS/eip-165[EIP].
374  *
375  * Implementers can declare support of contract interfaces, which can then be
376  * queried by others ({ERC165Checker}).
377  *
378  * For an implementation, see {ERC165}.
379  */
380 interface IERC165 {
381     /**
382      * @dev Returns true if this contract implements the interface defined by
383      * `interfaceId`. See the corresponding
384      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
385      * to learn more about how these ids are created.
386      *
387      * This function call must use less than 30 000 gas.
388      */
389     function supportsInterface(bytes4 interfaceId) external view returns (bool);
390 }
391 
392 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
393 
394 
395 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 
400 /**
401  * @dev Implementation of the {IERC165} interface.
402  *
403  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
404  * for the additional interface id that will be supported. For example:
405  *
406  * ```solidity
407  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
408  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
409  * }
410  * ```
411  *
412  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
413  */
414 abstract contract ERC165 is IERC165 {
415     /**
416      * @dev See {IERC165-supportsInterface}.
417      */
418     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
419         return interfaceId == type(IERC165).interfaceId;
420     }
421 }
422 
423 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
424 
425 
426 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 
431 /**
432  * @dev Required interface of an ERC721 compliant contract.
433  */
434 interface IERC721 is IERC165 {
435     /**
436      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
437      */
438     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
439 
440     /**
441      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
442      */
443     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
444 
445     /**
446      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
447      */
448     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
449 
450     /**
451      * @dev Returns the number of tokens in ``owner``'s account.
452      */
453     function balanceOf(address owner) external view returns (uint256 balance);
454 
455     /**
456      * @dev Returns the owner of the `tokenId` token.
457      *
458      * Requirements:
459      *
460      * - `tokenId` must exist.
461      */
462     function ownerOf(uint256 tokenId) external view returns (address owner);
463 
464     /**
465      * @dev Safely transfers `tokenId` token from `from` to `to`.
466      *
467      * Requirements:
468      *
469      * - `from` cannot be the zero address.
470      * - `to` cannot be the zero address.
471      * - `tokenId` token must exist and be owned by `from`.
472      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
473      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
474      *
475      * Emits a {Transfer} event.
476      */
477     function safeTransferFrom(
478         address from,
479         address to,
480         uint256 tokenId,
481         bytes calldata data
482     ) external;
483 
484     /**
485      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
486      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
487      *
488      * Requirements:
489      *
490      * - `from` cannot be the zero address.
491      * - `to` cannot be the zero address.
492      * - `tokenId` token must exist and be owned by `from`.
493      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
494      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
495      *
496      * Emits a {Transfer} event.
497      */
498     function safeTransferFrom(
499         address from,
500         address to,
501         uint256 tokenId
502     ) external;
503 
504     /**
505      * @dev Transfers `tokenId` token from `from` to `to`.
506      *
507      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
508      *
509      * Requirements:
510      *
511      * - `from` cannot be the zero address.
512      * - `to` cannot be the zero address.
513      * - `tokenId` token must be owned by `from`.
514      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
515      *
516      * Emits a {Transfer} event.
517      */
518     function transferFrom(
519         address from,
520         address to,
521         uint256 tokenId
522     ) external;
523 
524     /**
525      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
526      * The approval is cleared when the token is transferred.
527      *
528      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
529      *
530      * Requirements:
531      *
532      * - The caller must own the token or be an approved operator.
533      * - `tokenId` must exist.
534      *
535      * Emits an {Approval} event.
536      */
537     function approve(address to, uint256 tokenId) external;
538 
539     /**
540      * @dev Approve or remove `operator` as an operator for the caller.
541      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
542      *
543      * Requirements:
544      *
545      * - The `operator` cannot be the caller.
546      *
547      * Emits an {ApprovalForAll} event.
548      */
549     function setApprovalForAll(address operator, bool _approved) external;
550 
551     /**
552      * @dev Returns the account approved for `tokenId` token.
553      *
554      * Requirements:
555      *
556      * - `tokenId` must exist.
557      */
558     function getApproved(uint256 tokenId) external view returns (address operator);
559 
560     /**
561      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
562      *
563      * See {setApprovalForAll}
564      */
565     function isApprovedForAll(address owner, address operator) external view returns (bool);
566 }
567 
568 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
569 
570 
571 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 /**
577  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
578  * @dev See https://eips.ethereum.org/EIPS/eip-721
579  */
580 interface IERC721Enumerable is IERC721 {
581     /**
582      * @dev Returns the total amount of tokens stored by the contract.
583      */
584     function totalSupply() external view returns (uint256);
585 
586     /**
587      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
588      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
589      */
590     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
591 
592     /**
593      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
594      * Use along with {totalSupply} to enumerate all tokens.
595      */
596     function tokenByIndex(uint256 index) external view returns (uint256);
597 }
598 
599 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
600 
601 
602 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 
607 /**
608  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
609  * @dev See https://eips.ethereum.org/EIPS/eip-721
610  */
611 interface IERC721Metadata is IERC721 {
612     /**
613      * @dev Returns the token collection name.
614      */
615     function name() external view returns (string memory);
616 
617     /**
618      * @dev Returns the token collection symbol.
619      */
620     function symbol() external view returns (string memory);
621 
622     /**
623      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
624      */
625     function tokenURI(uint256 tokenId) external view returns (string memory);
626 }
627 
628 // File: ERC721A.sol
629 
630 
631 // Creator: Chiru Labs
632 
633 pragma solidity ^0.8.0;
634 
635 
636 
637 
638 
639 
640 
641 
642 
643 /**
644  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
645  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
646  *
647  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
648  *
649  * Does not support burning tokens to address(0).
650  *
651  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
652  */
653 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
654     using Address for address;
655     using Strings for uint256;
656 
657     struct TokenOwnership {
658         address addr;
659         uint64 startTimestamp;
660     }
661 
662     struct AddressData {
663         uint128 balance;
664         uint128 numberMinted;
665     }
666 
667     uint256 internal currentIndex;
668 
669     // Token name
670     string private _name;
671 
672     // Token symbol
673     string private _symbol;
674 
675     // Mapping from token ID to ownership details
676     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
677     mapping(uint256 => TokenOwnership) internal _ownerships;
678 
679     // Mapping owner address to address data
680     mapping(address => AddressData) private _addressData;
681 
682     // Mapping from token ID to approved address
683     mapping(uint256 => address) private _tokenApprovals;
684 
685     // Mapping from owner to operator approvals
686     mapping(address => mapping(address => bool)) private _operatorApprovals;
687 
688     constructor(string memory name_, string memory symbol_) {
689         _name = name_;
690         _symbol = symbol_;
691     }
692 
693     /**
694      * @dev See {IERC721Enumerable-totalSupply}.
695      */
696     function totalSupply() public view override returns (uint256) {
697         return currentIndex;
698     }
699 
700     /**
701      * @dev See {IERC721Enumerable-tokenByIndex}.
702      */
703     function tokenByIndex(uint256 index) public view override returns (uint256) {
704         require(index < totalSupply(), 'ERC721A: global index out of bounds');
705         return index;
706     }
707 
708     /**
709      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
710      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
711      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
712      */
713     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
714         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
715         uint256 numMintedSoFar = totalSupply();
716         uint256 tokenIdsIdx;
717         address currOwnershipAddr;
718 
719         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
720         unchecked {
721             for (uint256 i; i < numMintedSoFar; i++) {
722                 TokenOwnership memory ownership = _ownerships[i];
723                 if (ownership.addr != address(0)) {
724                     currOwnershipAddr = ownership.addr;
725                 }
726                 if (currOwnershipAddr == owner) {
727                     if (tokenIdsIdx == index) {
728                         return i;
729                     }
730                     tokenIdsIdx++;
731                 }
732             }
733         }
734 
735         revert('ERC721A: unable to get token of owner by index');
736     }
737 
738     /**
739      * @dev See {IERC165-supportsInterface}.
740      */
741     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
742         return
743             interfaceId == type(IERC721).interfaceId ||
744             interfaceId == type(IERC721Metadata).interfaceId ||
745             interfaceId == type(IERC721Enumerable).interfaceId ||
746             super.supportsInterface(interfaceId);
747     }
748 
749     /**
750      * @dev See {IERC721-balanceOf}.
751      */
752     function balanceOf(address owner) public view override returns (uint256) {
753         require(owner != address(0), 'ERC721A: balance query for the zero address');
754         return uint256(_addressData[owner].balance);
755     }
756 
757     function _numberMinted(address owner) internal view returns (uint256) {
758         require(owner != address(0), 'ERC721A: number minted query for the zero address');
759         return uint256(_addressData[owner].numberMinted);
760     }
761 
762     /**
763      * Gas spent here starts off proportional to the maximum mint batch size.
764      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
765      */
766     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
767         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
768 
769         unchecked {
770             for (uint256 curr = tokenId; curr >= 0; curr--) {
771                 TokenOwnership memory ownership = _ownerships[curr];
772                 if (ownership.addr != address(0)) {
773                     return ownership;
774                 }
775             }
776         }
777 
778         revert('ERC721A: unable to determine the owner of token');
779     }
780 
781     /**
782      * @dev See {IERC721-ownerOf}.
783      */
784     function ownerOf(uint256 tokenId) public view override returns (address) {
785         return ownershipOf(tokenId).addr;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-name}.
790      */
791     function name() public view virtual override returns (string memory) {
792         return _name;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-symbol}.
797      */
798     function symbol() public view virtual override returns (string memory) {
799         return _symbol;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-tokenURI}.
804      */
805     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
806         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
807 
808         string memory baseURI = _baseURI();
809         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
810     }
811 
812     /**
813      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
814      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
815      * by default, can be overriden in child contracts.
816      */
817     function _baseURI() internal view virtual returns (string memory) {
818         return '';
819     }
820 
821     /**
822      * @dev See {IERC721-approve}.
823      */
824     function approve(address to, uint256 tokenId) public override {
825         address owner = ERC721A.ownerOf(tokenId);
826         require(to != owner, 'ERC721A: approval to current owner');
827 
828         require(
829             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
830             'ERC721A: approve caller is not owner nor approved for all'
831         );
832 
833         _approve(to, tokenId, owner);
834     }
835 
836     /**
837      * @dev See {IERC721-getApproved}.
838      */
839     function getApproved(uint256 tokenId) public view override returns (address) {
840         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
841 
842         return _tokenApprovals[tokenId];
843     }
844 
845     /**
846      * @dev See {IERC721-setApprovalForAll}.
847      */
848     function setApprovalForAll(address operator, bool approved) public override {
849         require(operator != _msgSender(), 'ERC721A: approve to caller');
850 
851         _operatorApprovals[_msgSender()][operator] = approved;
852         emit ApprovalForAll(_msgSender(), operator, approved);
853     }
854 
855     /**
856      * @dev See {IERC721-isApprovedForAll}.
857      */
858     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
859         return _operatorApprovals[owner][operator];
860     }
861 
862     /**
863      * @dev See {IERC721-transferFrom}.
864      */
865     function transferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) public override {
870         _transfer(from, to, tokenId);
871     }
872 
873     /**
874      * @dev See {IERC721-safeTransferFrom}.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public override {
881         safeTransferFrom(from, to, tokenId, '');
882     }
883 
884     /**
885      * @dev See {IERC721-safeTransferFrom}.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId,
891         bytes memory _data
892     ) public override {
893         _transfer(from, to, tokenId);
894         require(
895             _checkOnERC721Received(from, to, tokenId, _data),
896             'ERC721A: transfer to non ERC721Receiver implementer'
897         );
898     }
899 
900     /**
901      * @dev Returns whether `tokenId` exists.
902      *
903      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
904      *
905      * Tokens start existing when they are minted (`_mint`),
906      */
907     function _exists(uint256 tokenId) internal view returns (bool) {
908         return tokenId < currentIndex;
909     }
910 
911     function _safeMint(address to, uint256 quantity) internal {
912         _safeMint(to, quantity, '');
913     }
914 
915     /**
916      * @dev Safely mints `quantity` tokens and transfers them to `to`.
917      *
918      * Requirements:
919      *
920      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
921      * - `quantity` must be greater than 0.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _safeMint(
926         address to,
927         uint256 quantity,
928         bytes memory _data
929     ) internal {
930         _mint(to, quantity, _data, true);
931     }
932 
933     /**
934      * @dev Mints `quantity` tokens and transfers them to `to`.
935      *
936      * Requirements:
937      *
938      * - `to` cannot be the zero address.
939      * - `quantity` must be greater than 0.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _mint(
944         address to,
945         uint256 quantity,
946         bytes memory _data,
947         bool safe
948     ) internal {
949         uint256 startTokenId = currentIndex;
950         require(to != address(0), 'ERC721A: mint to the zero address');
951         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
952 
953         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
954 
955         // Overflows are incredibly unrealistic.
956         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
957         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
958         unchecked {
959             _addressData[to].balance += uint128(quantity);
960             _addressData[to].numberMinted += uint128(quantity);
961 
962             _ownerships[startTokenId].addr = to;
963             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
964 
965             uint256 updatedIndex = startTokenId;
966 
967             for (uint256 i; i < quantity; i++) {
968                 emit Transfer(address(0), to, updatedIndex);
969                 if (safe) {
970                     require(
971                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
972                         'ERC721A: transfer to non ERC721Receiver implementer'
973                     );
974                 }
975 
976                 updatedIndex++;
977             }
978 
979             currentIndex = updatedIndex;
980         }
981 
982         _afterTokenTransfers(address(0), to, startTokenId, quantity);
983     }
984 
985     /**
986      * @dev Transfers `tokenId` from `from` to `to`.
987      *
988      * Requirements:
989      *
990      * - `to` cannot be the zero address.
991      * - `tokenId` token must be owned by `from`.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _transfer(
996         address from,
997         address to,
998         uint256 tokenId
999     ) private {
1000         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1001 
1002         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1003             getApproved(tokenId) == _msgSender() ||
1004             isApprovedForAll(prevOwnership.addr, _msgSender()));
1005 
1006         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1007 
1008         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1009         require(to != address(0), 'ERC721A: transfer to the zero address');
1010 
1011         _beforeTokenTransfers(from, to, tokenId, 1);
1012 
1013         // Clear approvals from the previous owner
1014         _approve(address(0), tokenId, prevOwnership.addr);
1015 
1016         // Underflow of the sender's balance is impossible because we check for
1017         // ownership above and the recipient's balance can't realistically overflow.
1018         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1019         unchecked {
1020             _addressData[from].balance -= 1;
1021             _addressData[to].balance += 1;
1022 
1023             _ownerships[tokenId].addr = to;
1024             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1025 
1026             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1027             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1028             uint256 nextTokenId = tokenId + 1;
1029             if (_ownerships[nextTokenId].addr == address(0)) {
1030                 if (_exists(nextTokenId)) {
1031                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1032                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1033                 }
1034             }
1035         }
1036 
1037         emit Transfer(from, to, tokenId);
1038         _afterTokenTransfers(from, to, tokenId, 1);
1039     }
1040 
1041     /**
1042      * @dev Approve `to` to operate on `tokenId`
1043      *
1044      * Emits a {Approval} event.
1045      */
1046     function _approve(
1047         address to,
1048         uint256 tokenId,
1049         address owner
1050     ) private {
1051         _tokenApprovals[tokenId] = to;
1052         emit Approval(owner, to, tokenId);
1053     }
1054 
1055     /**
1056      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1057      * The call is not executed if the target address is not a contract.
1058      *
1059      * @param from address representing the previous owner of the given token ID
1060      * @param to target address that will receive the tokens
1061      * @param tokenId uint256 ID of the token to be transferred
1062      * @param _data bytes optional data to send along with the call
1063      * @return bool whether the call correctly returned the expected magic value
1064      */
1065     function _checkOnERC721Received(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes memory _data
1070     ) private returns (bool) {
1071         if (to.isContract()) {
1072             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1073                 return retval == IERC721Receiver(to).onERC721Received.selector;
1074             } catch (bytes memory reason) {
1075                 if (reason.length == 0) {
1076                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1077                 } else {
1078                     assembly {
1079                         revert(add(32, reason), mload(reason))
1080                     }
1081                 }
1082             }
1083         } else {
1084             return true;
1085         }
1086     }
1087 
1088     /**
1089      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1090      *
1091      * startTokenId - the first token id to be transferred
1092      * quantity - the amount to be transferred
1093      *
1094      * Calling conditions:
1095      *
1096      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1097      * transferred to `to`.
1098      * - When `from` is zero, `tokenId` will be minted for `to`.
1099      */
1100     function _beforeTokenTransfers(
1101         address from,
1102         address to,
1103         uint256 startTokenId,
1104         uint256 quantity
1105     ) internal virtual {}
1106 
1107     /**
1108      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1109      * minting.
1110      *
1111      * startTokenId - the first token id to be transferred
1112      * quantity - the amount to be transferred
1113      *
1114      * Calling conditions:
1115      *
1116      * - when `from` and `to` are both non-zero.
1117      * - `from` and `to` are never both zero.
1118      */
1119     function _afterTokenTransfers(
1120         address from,
1121         address to,
1122         uint256 startTokenId,
1123         uint256 quantity
1124     ) internal virtual {}
1125 }
1126 // File: MutantAIYachtClub.sol
1127 
1128 
1129 
1130 pragma solidity ^0.8.0;
1131 
1132 /**
1133  * @dev Contract module which allows children to implement an emergency stop
1134  * mechanism that can be triggered by an authorized account.
1135  *
1136  * This module is used through inheritance. It will make available the
1137  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1138  * the functions of your contract. Note that they will not be pausable by
1139  * simply including this module, only once the modifiers are put in place.
1140  */
1141 abstract contract Pausable is Context {
1142     /**
1143      * @dev Emitted when the pause is triggered by `account`.
1144      */
1145     event Paused(address account);
1146 
1147     /**
1148      * @dev Emitted when the pause is lifted by `account`.
1149      */
1150     event Unpaused(address account);
1151 
1152     bool private _paused;
1153 
1154     /**
1155      * @dev Initializes the contract in unpaused state.
1156      */
1157     constructor() {
1158         _paused = false;
1159     }
1160 
1161     /**
1162      * @dev Returns true if the contract is paused, and false otherwise.
1163      */
1164     function paused() public view virtual returns (bool) {
1165         return _paused;
1166     }
1167 
1168     /**
1169      * @dev Modifier to make a function callable only when the contract is not paused.
1170      *
1171      * Requirements:
1172      *
1173      * - The contract must not be paused.
1174      */
1175     modifier whenNotPaused() {
1176         require(!paused(), "Pausable: paused");
1177         _;
1178     }
1179 
1180     /**
1181      * @dev Modifier to make a function callable only when the contract is paused.
1182      *
1183      * Requirements:
1184      *
1185      * - The contract must be paused.
1186      */
1187     modifier whenPaused() {
1188         require(paused(), "Pausable: not paused");
1189         _;
1190     }
1191 
1192     /**
1193      * @dev Triggers stopped state.
1194      *
1195      * Requirements:
1196      *
1197      * - The contract must not be paused.
1198      */
1199     function _pause() internal virtual whenNotPaused {
1200         _paused = true;
1201         emit Paused(_msgSender());
1202     }
1203 
1204     /**
1205      * @dev Returns to normal state.
1206      *
1207      * Requirements:
1208      *
1209      * - The contract must be paused.
1210      */
1211     function _unpause() internal virtual whenPaused {
1212         _paused = false;
1213         emit Unpaused(_msgSender());
1214     }
1215 }
1216 
1217 // Ownable.sol
1218 
1219 pragma solidity ^0.8.0;
1220 
1221 /**
1222  * @dev Contract module which provides a basic access control mechanism, where
1223  * there is an account (an owner) that can be granted exclusive access to
1224  * specific functions.
1225  *
1226  * By default, the owner account will be the one that deploys the contract. This
1227  * can later be changed with {transferOwnership}.
1228  *
1229  * This module is used through inheritance. It will make available the modifier
1230  * `onlyOwner`, which can be applied to your functions to restrict their use to
1231  * the owner.
1232  */
1233 abstract contract Ownable is Context {
1234     address private _owner;
1235 
1236     event OwnershipTransferred(
1237         address indexed previousOwner,
1238         address indexed newOwner
1239     );
1240 
1241     /**
1242      * @dev Initializes the contract setting the deployer as the initial owner.
1243      */
1244     constructor() {
1245         _setOwner(_msgSender());
1246     }
1247 
1248     /**
1249      * @dev Returns the address of the current owner.
1250      */
1251     function owner() public view virtual returns (address) {
1252         return _owner;
1253     }
1254 
1255     /**
1256      * @dev Throws if called by any account other than the owner.
1257      */
1258     modifier onlyOwner() {
1259         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1260         _;
1261     }
1262 
1263     /**
1264      * @dev Leaves the contract without owner. It will not be possible to call
1265      * `onlyOwner` functions anymore. Can only be called by the current owner.
1266      *
1267      * NOTE: Renouncing ownership will leave the contract without an owner,
1268      * thereby removing any functionality that is only available to the owner.
1269      */
1270     function renounceOwnership() public virtual onlyOwner {
1271         _setOwner(address(0));
1272     }
1273 
1274     /**
1275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1276      * Can only be called by the current owner.
1277      */
1278     function transferOwnership(address newOwner) public virtual onlyOwner {
1279         require(
1280             newOwner != address(0),
1281             "Ownable: new owner is the zero address"
1282         );
1283         _setOwner(newOwner);
1284     }
1285 
1286     function _setOwner(address newOwner) private {
1287         address oldOwner = _owner;
1288         _owner = newOwner;
1289         emit OwnershipTransferred(oldOwner, newOwner);
1290     }
1291 }
1292 
1293 pragma solidity ^0.8.0;
1294 
1295 /**
1296  * @dev Contract module that helps prevent reentrant calls to a function.
1297  *
1298  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1299  * available, which can be applied to functions to make sure there are no nested
1300  * (reentrant) calls to them.
1301  *
1302  * Note that because there is a single `nonReentrant` guard, functions marked as
1303  * `nonReentrant` may not call one another. This can be worked around by making
1304  * those functions `private`, and then adding `external` `nonReentrant` entry
1305  * points to them.
1306  *
1307  * TIP: If you would like to learn more about reentrancy and alternative ways
1308  * to protect against it, check out our blog post
1309  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1310  */
1311 abstract contract ReentrancyGuard {
1312     // Booleans are more expensive than uint256 or any type that takes up a full
1313     // word because each write operation emits an extra SLOAD to first read the
1314     // slot's contents, replace the bits taken up by the boolean, and then write
1315     // back. This is the compiler's defense against contract upgrades and
1316     // pointer aliasing, and it cannot be disabled.
1317 
1318     // The values being non-zero value makes deployment a bit more expensive,
1319     // but in exchange the refund on every call to nonReentrant will be lower in
1320     // amount. Since refunds are capped to a percentage of the total
1321     // transaction's gas, it is best to keep them low in cases like this one, to
1322     // increase the likelihood of the full refund coming into effect.
1323     uint256 private constant _NOT_ENTERED = 1;
1324     uint256 private constant _ENTERED = 2;
1325 
1326     uint256 private _status;
1327 
1328     constructor() {
1329         _status = _NOT_ENTERED;
1330     }
1331 
1332     /**
1333      * @dev Prevents a contract from calling itself, directly or indirectly.
1334      * Calling a `nonReentrant` function from another `nonReentrant`
1335      * function is not supported. It is possible to prevent this from happening
1336      * by making the `nonReentrant` function external, and make it call a
1337      * `private` function that does the actual work.
1338      */
1339     modifier nonReentrant() {
1340         // On the first call to nonReentrant, _notEntered will be true
1341         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1342 
1343         // Any calls to nonReentrant after this point will fail
1344         _status = _ENTERED;
1345 
1346         _;
1347 
1348         // By storing the original value once again, a refund is triggered (see
1349         // https://eips.ethereum.org/EIPS/eip-2200)
1350         _status = _NOT_ENTERED;
1351     }
1352 }
1353 
1354 //newerc.sol
1355 pragma solidity ^0.8.0;
1356 
1357 
1358 contract TheChosens is ERC721A, Ownable, Pausable, ReentrancyGuard {
1359     using Strings for uint256;
1360     string public baseURI;
1361     string public baseExtension = "";
1362     string public notRevealedUri;
1363     bool public revealed = true;
1364     uint   public maxPerTx          = 100;
1365     uint   public maxPerFree        = 1;
1366     uint   public totalFree         = 2000;
1367     uint256 public price = 0.0022 ether;
1368     uint256 public maxSupply = 10000;
1369     uint256 public maxperAddressPublicMint = 100;
1370     bool  public mintEnabled = true;
1371     uint   public totalFreeMinted = 0;
1372 
1373     mapping(address => uint256) public _mintedFreeAmount;
1374 
1375     constructor(
1376         string memory _name,
1377         string memory _symbol,
1378         string memory _initBaseURI,
1379         string memory _initNotRevealedUri
1380         ) 
1381         ERC721A(_name, _symbol) {
1382         _safeMint(msg.sender, 50);
1383         setBaseURI(_initBaseURI);
1384         setNotRevealedURI(_initNotRevealedUri);
1385     }
1386 
1387 
1388     function mint(uint256 count) external payable {
1389         uint256 cost = price;
1390         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1391             (_mintedFreeAmount[msg.sender] < maxPerFree));
1392 
1393         if (isFree) { 
1394             require(mintEnabled, "Mint is not live yet");
1395             require(totalSupply() + count <= maxSupply, "No more");
1396             require(count <= maxPerTx, "Max per TX reached.");
1397             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1398             {
1399              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1400              _mintedFreeAmount[msg.sender] = maxPerFree;
1401              totalFreeMinted += maxPerFree;
1402             }
1403             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1404             {
1405              require(msg.value >= 0, "Please send the exact ETH amount");
1406              _mintedFreeAmount[msg.sender] += count;
1407              totalFreeMinted += count;
1408             }
1409         }
1410         else{
1411         require(mintEnabled, "Mint is not live yet");
1412         require(msg.value >= count * cost, "Please send the exact ETH amount");
1413         require(totalSupply() + count <= maxSupply, "No more");
1414         require(count <= maxPerTx, "Max per TX reached.");
1415         }
1416 
1417         _safeMint(msg.sender, count);
1418     }
1419 
1420     function _baseURI() internal view virtual override returns (string memory) {
1421         return baseURI;
1422     }
1423 
1424     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1425         totalFree = MaxTotalFree_;
1426     }
1427 
1428     function maxFreePerWallet() public view returns (uint256) {
1429       return maxPerFree;
1430     }
1431 
1432     function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1433         maxPerFree = MaxPerFree_;
1434     }
1435 
1436     function tokenURI(uint256 tokenId)
1437     public
1438     view
1439     virtual
1440     override
1441     returns (string memory)
1442    {
1443     require(
1444       _exists(tokenId),
1445       "ERC721Metadata: URI query for nonexistent token"
1446     );
1447     
1448     if(revealed == false) {
1449         return notRevealedUri;
1450     }
1451 
1452     string memory currentBaseURI = _baseURI();
1453     return bytes(currentBaseURI).length > 0
1454         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1455         : "";
1456     }  
1457 
1458     function reveal() public onlyOwner() {
1459       revealed = true;
1460     }
1461 
1462     function setPrice(uint256 price_) external onlyOwner {
1463         price = price_;
1464     }
1465     
1466     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1467         baseURI = _newBaseURI;
1468     }
1469   
1470     function withdraw() public payable onlyOwner {
1471         (bool success, ) = payable(msg.sender).call{
1472             value: address(this).balance
1473         }("");
1474         require(success);
1475     }
1476 
1477     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1478     baseExtension = _newBaseExtension;
1479   }
1480   
1481 
1482   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1483     notRevealedUri = _notRevealedURI;
1484   }
1485 
1486 
1487   
1488 }