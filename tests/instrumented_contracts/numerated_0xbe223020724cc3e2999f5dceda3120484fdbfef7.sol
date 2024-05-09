1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/utils/Address.sol
99 
100 
101 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
102 
103 pragma solidity ^0.8.1;
104 
105 /**
106  * @dev Collection of functions related to the address type
107  */
108 library Address {
109     /**
110      * @dev Returns true if `account` is a contract.
111      *
112      * [IMPORTANT]
113      * ====
114      * It is unsafe to assume that an address for which this function returns
115      * false is an externally-owned account (EOA) and not a contract.
116      *
117      * Among others, `isContract` will return false for the following
118      * types of addresses:
119      *
120      *  - an externally-owned account
121      *  - a contract in construction
122      *  - an address where a contract will be created
123      *  - an address where a contract lived, but was destroyed
124      * ====
125      *
126      * [IMPORTANT]
127      * ====
128      * You shouldn't rely on `isContract` to protect against flash loan attacks!
129      *
130      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
131      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
132      * constructor.
133      * ====
134      */
135     function isContract(address account) internal view returns (bool) {
136         // This method relies on extcodesize/address.code.length, which returns 0
137         // for contracts in construction, since the code is only stored at the end
138         // of the constructor execution.
139 
140         return account.code.length > 0;
141     }
142 
143     /**
144      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
145      * `recipient`, forwarding all available gas and reverting on errors.
146      *
147      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
148      * of certain opcodes, possibly making contracts go over the 2300 gas limit
149      * imposed by `transfer`, making them unable to receive funds via
150      * `transfer`. {sendValue} removes this limitation.
151      *
152      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
153      *
154      * IMPORTANT: because control is transferred to `recipient`, care must be
155      * taken to not create reentrancy vulnerabilities. Consider using
156      * {ReentrancyGuard} or the
157      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
158      */
159     function sendValue(address payable recipient, uint256 amount) internal {
160         require(address(this).balance >= amount, "Address: insufficient balance");
161 
162         (bool success, ) = recipient.call{value: amount}("");
163         require(success, "Address: unable to send value, recipient may have reverted");
164     }
165 
166     /**
167      * @dev Performs a Solidity function call using a low level `call`. A
168      * plain `call` is an unsafe replacement for a function call: use this
169      * function instead.
170      *
171      * If `target` reverts with a revert reason, it is bubbled up by this
172      * function (like regular Solidity function calls).
173      *
174      * Returns the raw returned data. To convert to the expected return value,
175      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
176      *
177      * Requirements:
178      *
179      * - `target` must be a contract.
180      * - calling `target` with `data` must not revert.
181      *
182      * _Available since v3.1._
183      */
184     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
185         return functionCall(target, data, "Address: low-level call failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
190      * `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, 0, errorMessage);
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
204      * but also transferring `value` wei to `target`.
205      *
206      * Requirements:
207      *
208      * - the calling contract must have an ETH balance of at least `value`.
209      * - the called Solidity function must be `payable`.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(
214         address target,
215         bytes memory data,
216         uint256 value
217     ) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
223      * with `errorMessage` as a fallback revert reason when `target` reverts.
224      *
225      * _Available since v3.1._
226      */
227     function functionCallWithValue(
228         address target,
229         bytes memory data,
230         uint256 value,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         require(address(this).balance >= value, "Address: insufficient balance for call");
234         require(isContract(target), "Address: call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.call{value: value}(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a static call.
243      *
244      * _Available since v3.3._
245      */
246     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
247         return functionStaticCall(target, data, "Address: low-level static call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a static call.
253      *
254      * _Available since v3.3._
255      */
256     function functionStaticCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal view returns (bytes memory) {
261         require(isContract(target), "Address: static call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.staticcall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
274         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
279      * but performing a delegate call.
280      *
281      * _Available since v3.4._
282      */
283     function functionDelegateCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         require(isContract(target), "Address: delegate call to non-contract");
289 
290         (bool success, bytes memory returndata) = target.delegatecall(data);
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
296      * revert reason using the provided one.
297      *
298      * _Available since v4.3._
299      */
300     function verifyCallResult(
301         bool success,
302         bytes memory returndata,
303         string memory errorMessage
304     ) internal pure returns (bytes memory) {
305         if (success) {
306             return returndata;
307         } else {
308             // Look for revert reason and bubble it up if present
309             if (returndata.length > 0) {
310                 // The easiest way to bubble the revert reason is using memory via assembly
311 
312                 assembly {
313                     let returndata_size := mload(returndata)
314                     revert(add(32, returndata), returndata_size)
315                 }
316             } else {
317                 revert(errorMessage);
318             }
319         }
320     }
321 }
322 
323 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
324 
325 
326 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @title ERC721 token receiver interface
332  * @dev Interface for any contract that wants to support safeTransfers
333  * from ERC721 asset contracts.
334  */
335 interface IERC721Receiver {
336     /**
337      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
338      * by `operator` from `from`, this function is called.
339      *
340      * It must return its Solidity selector to confirm the token transfer.
341      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
342      *
343      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
344      */
345     function onERC721Received(
346         address operator,
347         address from,
348         uint256 tokenId,
349         bytes calldata data
350     ) external returns (bytes4);
351 }
352 
353 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Interface of the ERC165 standard, as defined in the
362  * https://eips.ethereum.org/EIPS/eip-165[EIP].
363  *
364  * Implementers can declare support of contract interfaces, which can then be
365  * queried by others ({ERC165Checker}).
366  *
367  * For an implementation, see {ERC165}.
368  */
369 interface IERC165 {
370     /**
371      * @dev Returns true if this contract implements the interface defined by
372      * `interfaceId`. See the corresponding
373      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
374      * to learn more about how these ids are created.
375      *
376      * This function call must use less than 30 000 gas.
377      */
378     function supportsInterface(bytes4 interfaceId) external view returns (bool);
379 }
380 
381 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 
389 /**
390  * @dev Implementation of the {IERC165} interface.
391  *
392  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
393  * for the additional interface id that will be supported. For example:
394  *
395  * ```solidity
396  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
397  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
398  * }
399  * ```
400  *
401  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
402  */
403 abstract contract ERC165 is IERC165 {
404     /**
405      * @dev See {IERC165-supportsInterface}.
406      */
407     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
408         return interfaceId == type(IERC165).interfaceId;
409     }
410 }
411 
412 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
413 
414 
415 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 
420 /**
421  * @dev Required interface of an ERC721 compliant contract.
422  */
423 interface IERC721 is IERC165 {
424     /**
425      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
426      */
427     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
428 
429     /**
430      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
431      */
432     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
433 
434     /**
435      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
436      */
437     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
438 
439     /**
440      * @dev Returns the number of tokens in ``owner``'s account.
441      */
442     function balanceOf(address owner) external view returns (uint256 balance);
443 
444     /**
445      * @dev Returns the owner of the `tokenId` token.
446      *
447      * Requirements:
448      *
449      * - `tokenId` must exist.
450      */
451     function ownerOf(uint256 tokenId) external view returns (address owner);
452 
453     /**
454      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
455      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `tokenId` token must exist and be owned by `from`.
462      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
463      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
464      *
465      * Emits a {Transfer} event.
466      */
467     function safeTransferFrom(
468         address from,
469         address to,
470         uint256 tokenId
471     ) external;
472 
473     /**
474      * @dev Transfers `tokenId` token from `from` to `to`.
475      *
476      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
477      *
478      * Requirements:
479      *
480      * - `from` cannot be the zero address.
481      * - `to` cannot be the zero address.
482      * - `tokenId` token must be owned by `from`.
483      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
484      *
485      * Emits a {Transfer} event.
486      */
487     function transferFrom(
488         address from,
489         address to,
490         uint256 tokenId
491     ) external;
492 
493     /**
494      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
495      * The approval is cleared when the token is transferred.
496      *
497      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
498      *
499      * Requirements:
500      *
501      * - The caller must own the token or be an approved operator.
502      * - `tokenId` must exist.
503      *
504      * Emits an {Approval} event.
505      */
506     function approve(address to, uint256 tokenId) external;
507 
508     /**
509      * @dev Returns the account approved for `tokenId` token.
510      *
511      * Requirements:
512      *
513      * - `tokenId` must exist.
514      */
515     function getApproved(uint256 tokenId) external view returns (address operator);
516 
517     /**
518      * @dev Approve or remove `operator` as an operator for the caller.
519      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
520      *
521      * Requirements:
522      *
523      * - The `operator` cannot be the caller.
524      *
525      * Emits an {ApprovalForAll} event.
526      */
527     function setApprovalForAll(address operator, bool _approved) external;
528 
529     /**
530      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
531      *
532      * See {setApprovalForAll}
533      */
534     function isApprovedForAll(address owner, address operator) external view returns (bool);
535 
536     /**
537      * @dev Safely transfers `tokenId` token from `from` to `to`.
538      *
539      * Requirements:
540      *
541      * - `from` cannot be the zero address.
542      * - `to` cannot be the zero address.
543      * - `tokenId` token must exist and be owned by `from`.
544      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
545      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
546      *
547      * Emits a {Transfer} event.
548      */
549     function safeTransferFrom(
550         address from,
551         address to,
552         uint256 tokenId,
553         bytes calldata data
554     ) external;
555 }
556 
557 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
558 
559 
560 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
567  * @dev See https://eips.ethereum.org/EIPS/eip-721
568  */
569 interface IERC721Enumerable is IERC721 {
570     /**
571      * @dev Returns the total amount of tokens stored by the contract.
572      */
573     function totalSupply() external view returns (uint256);
574 
575     /**
576      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
577      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
578      */
579     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
580 
581     /**
582      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
583      * Use along with {totalSupply} to enumerate all tokens.
584      */
585     function tokenByIndex(uint256 index) external view returns (uint256);
586 }
587 
588 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 
596 /**
597  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
598  * @dev See https://eips.ethereum.org/EIPS/eip-721
599  */
600 interface IERC721Metadata is IERC721 {
601     /**
602      * @dev Returns the token collection name.
603      */
604     function name() external view returns (string memory);
605 
606     /**
607      * @dev Returns the token collection symbol.
608      */
609     function symbol() external view returns (string memory);
610 
611     /**
612      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
613      */
614     function tokenURI(uint256 tokenId) external view returns (string memory);
615 }
616 
617 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
618 
619 
620 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
621 
622 pragma solidity ^0.8.0;
623 
624 
625 
626 
627 
628 
629 
630 
631 /**
632  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
633  * the Metadata extension, but not including the Enumerable extension, which is available separately as
634  * {ERC721Enumerable}.
635  */
636 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
637     using Address for address;
638     using Strings for uint256;
639 
640     // Token name
641     string private _name;
642 
643     // Token symbol
644     string private _symbol;
645 
646     // Mapping from token ID to owner address
647     mapping(uint256 => address) private _owners;
648 
649     // Mapping owner address to token count
650     mapping(address => uint256) private _balances;
651 
652     // Mapping from token ID to approved address
653     mapping(uint256 => address) private _tokenApprovals;
654 
655     // Mapping from owner to operator approvals
656     mapping(address => mapping(address => bool)) private _operatorApprovals;
657 
658     /**
659      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
660      */
661     constructor(string memory name_, string memory symbol_) {
662         _name = name_;
663         _symbol = symbol_;
664     }
665 
666     /**
667      * @dev See {IERC165-supportsInterface}.
668      */
669     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
670         return
671             interfaceId == type(IERC721).interfaceId ||
672             interfaceId == type(IERC721Metadata).interfaceId ||
673             super.supportsInterface(interfaceId);
674     }
675 
676     /**
677      * @dev See {IERC721-balanceOf}.
678      */
679     function balanceOf(address owner) public view virtual override returns (uint256) {
680         require(owner != address(0), "ERC721: balance query for the zero address");
681         return _balances[owner];
682     }
683 
684     /**
685      * @dev See {IERC721-ownerOf}.
686      */
687     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
688         address owner = _owners[tokenId];
689         require(owner != address(0), "ERC721: owner query for nonexistent token");
690         return owner;
691     }
692 
693     /**
694      * @dev See {IERC721Metadata-name}.
695      */
696     function name() public view virtual override returns (string memory) {
697         return _name;
698     }
699 
700     /**
701      * @dev See {IERC721Metadata-symbol}.
702      */
703     function symbol() public view virtual override returns (string memory) {
704         return _symbol;
705     }
706 
707     /**
708      * @dev See {IERC721Metadata-tokenURI}.
709      */
710     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
711         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
712 
713         string memory baseURI = _baseURI();
714         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
715     }
716 
717     /**
718      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
719      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
720      * by default, can be overriden in child contracts.
721      */
722     function _baseURI() internal view virtual returns (string memory) {
723         return "";
724     }
725 
726     /**
727      * @dev See {IERC721-approve}.
728      */
729     function approve(address to, uint256 tokenId) public virtual override {
730         address owner = ERC721.ownerOf(tokenId);
731         require(to != owner, "ERC721: approval to current owner");
732 
733         require(
734             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
735             "ERC721: approve caller is not owner nor approved for all"
736         );
737 
738         _approve(to, tokenId);
739     }
740 
741     /**
742      * @dev See {IERC721-getApproved}.
743      */
744     function getApproved(uint256 tokenId) public view virtual override returns (address) {
745         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
746 
747         return _tokenApprovals[tokenId];
748     }
749 
750     /**
751      * @dev See {IERC721-setApprovalForAll}.
752      */
753     function setApprovalForAll(address operator, bool approved) public virtual override {
754         _setApprovalForAll(_msgSender(), operator, approved);
755     }
756 
757     /**
758      * @dev See {IERC721-isApprovedForAll}.
759      */
760     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
761         return _operatorApprovals[owner][operator];
762     }
763 
764     /**
765      * @dev See {IERC721-transferFrom}.
766      */
767     function transferFrom(
768         address from,
769         address to,
770         uint256 tokenId
771     ) public virtual override {
772         //solhint-disable-next-line max-line-length
773         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
774 
775         _transfer(from, to, tokenId);
776     }
777 
778     /**
779      * @dev See {IERC721-safeTransferFrom}.
780      */
781     function safeTransferFrom(
782         address from,
783         address to,
784         uint256 tokenId
785     ) public virtual override {
786         safeTransferFrom(from, to, tokenId, "");
787     }
788 
789     /**
790      * @dev See {IERC721-safeTransferFrom}.
791      */
792     function safeTransferFrom(
793         address from,
794         address to,
795         uint256 tokenId,
796         bytes memory _data
797     ) public virtual override {
798         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
799         _safeTransfer(from, to, tokenId, _data);
800     }
801 
802     /**
803      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
804      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
805      *
806      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
807      *
808      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
809      * implement alternative mechanisms to perform token transfer, such as signature-based.
810      *
811      * Requirements:
812      *
813      * - `from` cannot be the zero address.
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must exist and be owned by `from`.
816      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
817      *
818      * Emits a {Transfer} event.
819      */
820     function _safeTransfer(
821         address from,
822         address to,
823         uint256 tokenId,
824         bytes memory _data
825     ) internal virtual {
826         _transfer(from, to, tokenId);
827         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
828     }
829 
830     /**
831      * @dev Returns whether `tokenId` exists.
832      *
833      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
834      *
835      * Tokens start existing when they are minted (`_mint`),
836      * and stop existing when they are burned (`_burn`).
837      */
838     function _exists(uint256 tokenId) internal view virtual returns (bool) {
839         return _owners[tokenId] != address(0);
840     }
841 
842     /**
843      * @dev Returns whether `spender` is allowed to manage `tokenId`.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must exist.
848      */
849     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
850         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
851         address owner = ERC721.ownerOf(tokenId);
852         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
853     }
854 
855     /**
856      * @dev Safely mints `tokenId` and transfers it to `to`.
857      *
858      * Requirements:
859      *
860      * - `tokenId` must not exist.
861      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
862      *
863      * Emits a {Transfer} event.
864      */
865     function _safeMint(address to, uint256 tokenId) internal virtual {
866         _safeMint(to, tokenId, "");
867     }
868 
869     /**
870      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
871      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
872      */
873     function _safeMint(
874         address to,
875         uint256 tokenId,
876         bytes memory _data
877     ) internal virtual {
878         _mint(to, tokenId);
879         require(
880             _checkOnERC721Received(address(0), to, tokenId, _data),
881             "ERC721: transfer to non ERC721Receiver implementer"
882         );
883     }
884 
885     /**
886      * @dev Mints `tokenId` and transfers it to `to`.
887      *
888      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
889      *
890      * Requirements:
891      *
892      * - `tokenId` must not exist.
893      * - `to` cannot be the zero address.
894      *
895      * Emits a {Transfer} event.
896      */
897     function _mint(address to, uint256 tokenId) internal virtual {
898         require(to != address(0), "ERC721: mint to the zero address");
899         require(!_exists(tokenId), "ERC721: token already minted");
900 
901         _beforeTokenTransfer(address(0), to, tokenId);
902 
903         _balances[to] += 1;
904         _owners[tokenId] = to;
905 
906         emit Transfer(address(0), to, tokenId);
907 
908         _afterTokenTransfer(address(0), to, tokenId);
909     }
910 
911     /**
912      * @dev Destroys `tokenId`.
913      * The approval is cleared when the token is burned.
914      *
915      * Requirements:
916      *
917      * - `tokenId` must exist.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _burn(uint256 tokenId) internal virtual {
922         address owner = ERC721.ownerOf(tokenId);
923 
924         _beforeTokenTransfer(owner, address(0), tokenId);
925 
926         // Clear approvals
927         _approve(address(0), tokenId);
928 
929         _balances[owner] -= 1;
930         delete _owners[tokenId];
931 
932         emit Transfer(owner, address(0), tokenId);
933 
934         _afterTokenTransfer(owner, address(0), tokenId);
935     }
936 
937     /**
938      * @dev Transfers `tokenId` from `from` to `to`.
939      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
940      *
941      * Requirements:
942      *
943      * - `to` cannot be the zero address.
944      * - `tokenId` token must be owned by `from`.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _transfer(
949         address from,
950         address to,
951         uint256 tokenId
952     ) internal virtual {
953         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
954         require(to != address(0), "ERC721: transfer to the zero address");
955 
956         _beforeTokenTransfer(from, to, tokenId);
957 
958         // Clear approvals from the previous owner
959         _approve(address(0), tokenId);
960 
961         _balances[from] -= 1;
962         _balances[to] += 1;
963         _owners[tokenId] = to;
964 
965         emit Transfer(from, to, tokenId);
966 
967         _afterTokenTransfer(from, to, tokenId);
968     }
969 
970     /**
971      * @dev Approve `to` to operate on `tokenId`
972      *
973      * Emits a {Approval} event.
974      */
975     function _approve(address to, uint256 tokenId) internal virtual {
976         _tokenApprovals[tokenId] = to;
977         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
978     }
979 
980     /**
981      * @dev Approve `operator` to operate on all of `owner` tokens
982      *
983      * Emits a {ApprovalForAll} event.
984      */
985     function _setApprovalForAll(
986         address owner,
987         address operator,
988         bool approved
989     ) internal virtual {
990         require(owner != operator, "ERC721: approve to caller");
991         _operatorApprovals[owner][operator] = approved;
992         emit ApprovalForAll(owner, operator, approved);
993     }
994 
995     /**
996      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
997      * The call is not executed if the target address is not a contract.
998      *
999      * @param from address representing the previous owner of the given token ID
1000      * @param to target address that will receive the tokens
1001      * @param tokenId uint256 ID of the token to be transferred
1002      * @param _data bytes optional data to send along with the call
1003      * @return bool whether the call correctly returned the expected magic value
1004      */
1005     function _checkOnERC721Received(
1006         address from,
1007         address to,
1008         uint256 tokenId,
1009         bytes memory _data
1010     ) private returns (bool) {
1011         if (to.isContract()) {
1012             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1013                 return retval == IERC721Receiver.onERC721Received.selector;
1014             } catch (bytes memory reason) {
1015                 if (reason.length == 0) {
1016                     revert("ERC721: transfer to non ERC721Receiver implementer");
1017                 } else {
1018                     assembly {
1019                         revert(add(32, reason), mload(reason))
1020                     }
1021                 }
1022             }
1023         } else {
1024             return true;
1025         }
1026     }
1027 
1028     /**
1029      * @dev Hook that is called before any token transfer. This includes minting
1030      * and burning.
1031      *
1032      * Calling conditions:
1033      *
1034      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1035      * transferred to `to`.
1036      * - When `from` is zero, `tokenId` will be minted for `to`.
1037      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1038      * - `from` and `to` are never both zero.
1039      *
1040      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1041      */
1042     function _beforeTokenTransfer(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) internal virtual {}
1047 
1048     /**
1049      * @dev Hook that is called after any transfer of tokens. This includes
1050      * minting and burning.
1051      *
1052      * Calling conditions:
1053      *
1054      * - when `from` and `to` are both non-zero.
1055      * - `from` and `to` are never both zero.
1056      *
1057      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1058      */
1059     function _afterTokenTransfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) internal virtual {}
1064 }
1065 
1066 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1067 
1068 
1069 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1070 
1071 pragma solidity ^0.8.0;
1072 
1073 
1074 
1075 /**
1076  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1077  * enumerability of all the token ids in the contract as well as all token ids owned by each
1078  * account.
1079  */
1080 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1081     // Mapping from owner to list of owned token IDs
1082     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1083 
1084     // Mapping from token ID to index of the owner tokens list
1085     mapping(uint256 => uint256) private _ownedTokensIndex;
1086 
1087     // Array with all token ids, used for enumeration
1088     uint256[] private _allTokens;
1089 
1090     // Mapping from token id to position in the allTokens array
1091     mapping(uint256 => uint256) private _allTokensIndex;
1092 
1093     /**
1094      * @dev See {IERC165-supportsInterface}.
1095      */
1096     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1097         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1102      */
1103     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1104         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1105         return _ownedTokens[owner][index];
1106     }
1107 
1108     /**
1109      * @dev See {IERC721Enumerable-totalSupply}.
1110      */
1111     function totalSupply() public view virtual override returns (uint256) {
1112         return _allTokens.length;
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Enumerable-tokenByIndex}.
1117      */
1118     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1119         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1120         return _allTokens[index];
1121     }
1122 
1123     /**
1124      * @dev Hook that is called before any token transfer. This includes minting
1125      * and burning.
1126      *
1127      * Calling conditions:
1128      *
1129      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1130      * transferred to `to`.
1131      * - When `from` is zero, `tokenId` will be minted for `to`.
1132      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1133      * - `from` cannot be the zero address.
1134      * - `to` cannot be the zero address.
1135      *
1136      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1137      */
1138     function _beforeTokenTransfer(
1139         address from,
1140         address to,
1141         uint256 tokenId
1142     ) internal virtual override {
1143         super._beforeTokenTransfer(from, to, tokenId);
1144 
1145         if (from == address(0)) {
1146             _addTokenToAllTokensEnumeration(tokenId);
1147         } else if (from != to) {
1148             _removeTokenFromOwnerEnumeration(from, tokenId);
1149         }
1150         if (to == address(0)) {
1151             _removeTokenFromAllTokensEnumeration(tokenId);
1152         } else if (to != from) {
1153             _addTokenToOwnerEnumeration(to, tokenId);
1154         }
1155     }
1156 
1157     /**
1158      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1159      * @param to address representing the new owner of the given token ID
1160      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1161      */
1162     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1163         uint256 length = ERC721.balanceOf(to);
1164         _ownedTokens[to][length] = tokenId;
1165         _ownedTokensIndex[tokenId] = length;
1166     }
1167 
1168     /**
1169      * @dev Private function to add a token to this extension's token tracking data structures.
1170      * @param tokenId uint256 ID of the token to be added to the tokens list
1171      */
1172     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1173         _allTokensIndex[tokenId] = _allTokens.length;
1174         _allTokens.push(tokenId);
1175     }
1176 
1177     /**
1178      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1179      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1180      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1181      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1182      * @param from address representing the previous owner of the given token ID
1183      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1184      */
1185     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1186         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1187         // then delete the last slot (swap and pop).
1188 
1189         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1190         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1191 
1192         // When the token to delete is the last token, the swap operation is unnecessary
1193         if (tokenIndex != lastTokenIndex) {
1194             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1195 
1196             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1197             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1198         }
1199 
1200         // This also deletes the contents at the last position of the array
1201         delete _ownedTokensIndex[tokenId];
1202         delete _ownedTokens[from][lastTokenIndex];
1203     }
1204 
1205     /**
1206      * @dev Private function to remove a token from this extension's token tracking data structures.
1207      * This has O(1) time complexity, but alters the order of the _allTokens array.
1208      * @param tokenId uint256 ID of the token to be removed from the tokens list
1209      */
1210     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1211         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1212         // then delete the last slot (swap and pop).
1213 
1214         uint256 lastTokenIndex = _allTokens.length - 1;
1215         uint256 tokenIndex = _allTokensIndex[tokenId];
1216 
1217         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1218         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1219         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1220         uint256 lastTokenId = _allTokens[lastTokenIndex];
1221 
1222         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1223         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1224 
1225         // This also deletes the contents at the last position of the array
1226         delete _allTokensIndex[tokenId];
1227         _allTokens.pop();
1228     }
1229 }
1230 
1231 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1232 
1233 
1234 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1235 
1236 pragma solidity ^0.8.0;
1237 
1238 /**
1239  * @dev These functions deal with verification of Merkle Trees proofs.
1240  *
1241  * The proofs can be generated using the JavaScript library
1242  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1243  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1244  *
1245  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1246  */
1247 library MerkleProof {
1248     /**
1249      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1250      * defined by `root`. For this, a `proof` must be provided, containing
1251      * sibling hashes on the branch from the leaf to the root of the tree. Each
1252      * pair of leaves and each pair of pre-images are assumed to be sorted.
1253      */
1254     function verify(
1255         bytes32[] memory proof,
1256         bytes32 root,
1257         bytes32 leaf
1258     ) internal pure returns (bool) {
1259         return processProof(proof, leaf) == root;
1260     }
1261 
1262     /**
1263      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1264      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1265      * hash matches the root of the tree. When processing the proof, the pairs
1266      * of leafs & pre-images are assumed to be sorted.
1267      *
1268      * _Available since v4.4._
1269      */
1270     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1271         bytes32 computedHash = leaf;
1272         for (uint256 i = 0; i < proof.length; i++) {
1273             bytes32 proofElement = proof[i];
1274             if (computedHash <= proofElement) {
1275                 // Hash(current computed hash + current element of the proof)
1276                 computedHash = _efficientHash(computedHash, proofElement);
1277             } else {
1278                 // Hash(current element of the proof + current computed hash)
1279                 computedHash = _efficientHash(proofElement, computedHash);
1280             }
1281         }
1282         return computedHash;
1283     }
1284 
1285     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1286         assembly {
1287             mstore(0x00, a)
1288             mstore(0x20, b)
1289             value := keccak256(0x00, 0x40)
1290         }
1291     }
1292 }
1293 
1294 // File: contracts/DEXGuruPreDAONFT.sol
1295 
1296 
1297 pragma solidity ^0.8.7;
1298 
1299 
1300 
1301 contract DEXGuruPreDAONFT is ERC721Enumerable {
1302     using Strings for uint256;
1303     using MerkleProof for bytes32[];
1304 
1305     /*
1306 	 * Private Variables
1307      */               
1308     uint256 private constant MINTING_START_TIME = 1648656000;      // 03/30/2022 @ 9:00am (PST)
1309     uint256 private constant MINTING_END_TIME = 1648828800;     // 04/01/2022 @ 9:00am (PST)
1310     uint256 private constant NFT_PER_ADDRESS_LIMIT = 1;
1311     bytes32 private constant MERKLE_ROOT = 0x5e415461ec43bd5b7f1cf388e448ad2af72a11d9dc824967ab3c2b5a8e6f587b;
1312 
1313     string public baseURI;
1314     /*
1315 	 * Public Variables
1316 	 */
1317     mapping(address => uint256) public addressMintedBalance;
1318 
1319 	/*
1320 	 * Constructor
1321 	 */
1322     constructor(
1323     ) ERC721('GURU Season Pass NFT', 'SeasonPass') {}
1324 
1325     /**
1326      * @dev Base URI for computing {tokenURI}. The resulting URI for each
1327      * token will be the concatenation of the `baseURI` and the `tokenId`. Overriddes ERC721 implementation.
1328      */
1329     function _baseURI() internal view virtual override returns (string memory) {
1330         return "https://api.dex.guru/v1/assets/nft/pre-dao/";
1331     }
1332 
1333 
1334     /// Mint NFT with checking against whitelist
1335     /// @dev fn called externally, to verify account(msg.sender) eligibility/Mint/Check if max NFTs per account minted
1336 	/// @param merkleProof Merkle proof
1337     function mint(bytes32[] memory merkleProof) public payable {
1338         uint256 supply = totalSupply();
1339         require(block.timestamp >= MINTING_START_TIME && block.timestamp <= MINTING_END_TIME);
1340         bool isUserWhitelisted = checkWhitelistUser(msg.sender, merkleProof);
1341         if (isUserWhitelisted) {
1342             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1343             require(ownerMintedCount + 1 <= NFT_PER_ADDRESS_LIMIT, "max NFT mints per account exceeded");
1344             _safeMint(msg.sender, supply + 1);
1345             addressMintedBalance[msg.sender]++;
1346         } else {
1347             revert("account is not eligable for minting");
1348         }
1349     }
1350 
1351     /// Check if account is able to Mint
1352 	/// @dev fn called internaly and externally, to verify account eligibility to Mint
1353 	/// @param account number of tokens to claim in transaction
1354 	/// @param merkleProof Merkle proof
1355     function checkWhitelistUser(address account, bytes32[] memory merkleProof) public pure returns (bool) {
1356         if (merkleProof.length != 0) {
1357             bytes32 leaf = keccak256(abi.encodePacked(account));
1358             if (merkleProof.verify(MERKLE_ROOT, leaf) == true) {
1359                 return true;
1360             }
1361         }
1362         return false;
1363     }
1364 } // End of Contract