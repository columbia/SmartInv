1 /**
2                                      ____
3                               __,---'     `--.__
4                            ,-'                ; `.
5                           ,'                  `--.`--.
6                          ,'                       `._ `-.
7                          ;                     ;     `-- ;
8                        ,-'-_       _,-~~-.      ,--      `.
9                        ;;   `-,;    ,'~`.__    ,;;;    ;  ;
10                        ;;    ;,'  ,;;      `,  ;;;     `. ;
11                        `:   ,'    `:;     __/  `.;      ; ;
12                         ;~~^.   `.   `---'~~    ;;      ; ;
13                         `,' `.   `.            .;;;     ;'
14                         ,',^. `.  `._    __    `:;     ,'
15                         `-' `--'    ~`--'~~`--.  ~    ,'
16                        /;`-;_ ; ;. /. /   ; ~~`-.     ;
17 -._                   ; ;  ; `,;`-;__;---;      `----'
18    `--.__             ``-`-;__;:  ;  ;__;
19  ...     `--.__                `-- `-'
20 `--.:::...     `--.__                ____
21     `--:::::--.      `--.__    __,--'    `.
22         `--:::`;....       `--'       ___  `.
23             `--`-:::...     __           )  ;
24                   ~`-:::...   `---.      ( ,'
25                       ~`-:::::::::`--.   `-.
26                           ~`-::::::::`.    ;
27                               ~`--:::,'   ,'
28                                    ~~`--'~
29  */
30 
31 // SPDX-License-Identifier: MIT
32 
33 // File: @openzeppelin/contracts/utils/Strings.sol
34 
35 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev String operations.
41  */
42 library Strings {
43     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
47      */
48     function toString(uint256 value) internal pure returns (string memory) {
49         // Inspired by OraclizeAPI's implementation - MIT licence
50         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
51 
52         if (value == 0) {
53             return "0";
54         }
55         uint256 temp = value;
56         uint256 digits;
57         while (temp != 0) {
58             digits++;
59             temp /= 10;
60         }
61         bytes memory buffer = new bytes(digits);
62         while (value != 0) {
63             digits -= 1;
64             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
65             value /= 10;
66         }
67         return string(buffer);
68     }
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
72      */
73     function toHexString(uint256 value) internal pure returns (string memory) {
74         if (value == 0) {
75             return "0x00";
76         }
77         uint256 temp = value;
78         uint256 length = 0;
79         while (temp != 0) {
80             length++;
81             temp >>= 8;
82         }
83         return toHexString(value, length);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
88      */
89     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
90         bytes memory buffer = new bytes(2 * length + 2);
91         buffer[0] = "0";
92         buffer[1] = "x";
93         for (uint256 i = 2 * length + 1; i > 1; --i) {
94             buffer[i] = _HEX_SYMBOLS[value & 0xf];
95             value >>= 4;
96         }
97         require(value == 0, "Strings: hex length insufficient");
98         return string(buffer);
99     }
100 }
101 
102 // File: @openzeppelin/contracts/utils/Context.sol
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev Provides information about the current execution context, including the
111  * sender of the transaction and its data. While these are generally available
112  * via msg.sender and msg.data, they should not be accessed in such a direct
113  * manner, since when dealing with meta-transactions the account sending and
114  * paying for execution may not be the actual sender (as far as an application
115  * is concerned).
116  *
117  * This contract is only required for intermediate, library-like contracts.
118  */
119 abstract contract Context {
120     function _msgSender() internal view virtual returns (address) {
121         return msg.sender;
122     }
123 
124     function _msgData() internal view virtual returns (bytes calldata) {
125         return msg.data;
126     }
127 }
128 
129 // File: @openzeppelin/contracts/utils/Address.sol
130 
131 
132 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
133 
134 pragma solidity ^0.8.1;
135 
136 /**
137  * @dev Collection of functions related to the address type
138  */
139 library Address {
140     /**
141      * @dev Returns true if `account` is a contract.
142      *
143      * [IMPORTANT]
144      * ====
145      * It is unsafe to assume that an address for which this function returns
146      * false is an externally-owned account (EOA) and not a contract.
147      *
148      * Among others, `isContract` will return false for the following
149      * types of addresses:
150      *
151      *  - an externally-owned account
152      *  - a contract in construction
153      *  - an address where a contract will be created
154      *  - an address where a contract lived, but was destroyed
155      * ====
156      *
157      * [IMPORTANT]
158      * ====
159      * You shouldn't rely on `isContract` to protect against flash loan attacks!
160      *
161      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
162      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
163      * constructor.
164      * ====
165      */
166     function isContract(address account) internal view returns (bool) {
167         // This method relies on extcodesize/address.code.length, which returns 0
168         // for contracts in construction, since the code is only stored at the end
169         // of the constructor execution.
170 
171         return account.code.length > 0;
172     }
173 
174     /**
175      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
176      * `recipient`, forwarding all available gas and reverting on errors.
177      *
178      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
179      * of certain opcodes, possibly making contracts go over the 2300 gas limit
180      * imposed by `transfer`, making them unable to receive funds via
181      * `transfer`. {sendValue} removes this limitation.
182      *
183      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
184      *
185      * IMPORTANT: because control is transferred to `recipient`, care must be
186      * taken to not create reentrancy vulnerabilities. Consider using
187      * {ReentrancyGuard} or the
188      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
189      */
190     function sendValue(address payable recipient, uint256 amount) internal {
191         require(address(this).balance >= amount, "Address: insufficient balance");
192 
193         (bool success, ) = recipient.call{value: amount}("");
194         require(success, "Address: unable to send value, recipient may have reverted");
195     }
196 
197     /**
198      * @dev Performs a Solidity function call using a low level `call`. A
199      * plain `call` is an unsafe replacement for a function call: use this
200      * function instead.
201      *
202      * If `target` reverts with a revert reason, it is bubbled up by this
203      * function (like regular Solidity function calls).
204      *
205      * Returns the raw returned data. To convert to the expected return value,
206      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
207      *
208      * Requirements:
209      *
210      * - `target` must be a contract.
211      * - calling `target` with `data` must not revert.
212      *
213      * _Available since v3.1._
214      */
215     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
216         return functionCall(target, data, "Address: low-level call failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
221      * `errorMessage` as a fallback revert reason when `target` reverts.
222      *
223      * _Available since v3.1._
224      */
225     function functionCall(
226         address target,
227         bytes memory data,
228         string memory errorMessage
229     ) internal returns (bytes memory) {
230         return functionCallWithValue(target, data, 0, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but also transferring `value` wei to `target`.
236      *
237      * Requirements:
238      *
239      * - the calling contract must have an ETH balance of at least `value`.
240      * - the called Solidity function must be `payable`.
241      *
242      * _Available since v3.1._
243      */
244     function functionCallWithValue(
245         address target,
246         bytes memory data,
247         uint256 value
248     ) internal returns (bytes memory) {
249         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
254      * with `errorMessage` as a fallback revert reason when `target` reverts.
255      *
256      * _Available since v3.1._
257      */
258     function functionCallWithValue(
259         address target,
260         bytes memory data,
261         uint256 value,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         require(address(this).balance >= value, "Address: insufficient balance for call");
265         require(isContract(target), "Address: call to non-contract");
266 
267         (bool success, bytes memory returndata) = target.call{value: value}(data);
268         return verifyCallResult(success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but performing a static call.
274      *
275      * _Available since v3.3._
276      */
277     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
278         return functionStaticCall(target, data, "Address: low-level static call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
283      * but performing a static call.
284      *
285      * _Available since v3.3._
286      */
287     function functionStaticCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal view returns (bytes memory) {
292         require(isContract(target), "Address: static call to non-contract");
293 
294         (bool success, bytes memory returndata) = target.staticcall(data);
295         return verifyCallResult(success, returndata, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but performing a delegate call.
301      *
302      * _Available since v3.4._
303      */
304     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
310      * but performing a delegate call.
311      *
312      * _Available since v3.4._
313      */
314     function functionDelegateCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         require(isContract(target), "Address: delegate call to non-contract");
320 
321         (bool success, bytes memory returndata) = target.delegatecall(data);
322         return verifyCallResult(success, returndata, errorMessage);
323     }
324 
325     /**
326      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
327      * revert reason using the provided one.
328      *
329      * _Available since v4.3._
330      */
331     function verifyCallResult(
332         bool success,
333         bytes memory returndata,
334         string memory errorMessage
335     ) internal pure returns (bytes memory) {
336         if (success) {
337             return returndata;
338         } else {
339             // Look for revert reason and bubble it up if present
340             if (returndata.length > 0) {
341                 // The easiest way to bubble the revert reason is using memory via assembly
342 
343                 assembly {
344                     let returndata_size := mload(returndata)
345                     revert(add(32, returndata), returndata_size)
346                 }
347             } else {
348                 revert(errorMessage);
349             }
350         }
351     }
352 }
353 
354 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 /**
362  * @title ERC721 token receiver interface
363  * @dev Interface for any contract that wants to support safeTransfers
364  * from ERC721 asset contracts.
365  */
366 interface IERC721Receiver {
367     /**
368      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
369      * by `operator` from `from`, this function is called.
370      *
371      * It must return its Solidity selector to confirm the token transfer.
372      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
373      *
374      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
375      */
376     function onERC721Received(
377         address operator,
378         address from,
379         uint256 tokenId,
380         bytes calldata data
381     ) external returns (bytes4);
382 }
383 
384 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
385 
386 
387 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 /**
392  * @dev Interface of the ERC165 standard, as defined in the
393  * https://eips.ethereum.org/EIPS/eip-165[EIP].
394  *
395  * Implementers can declare support of contract interfaces, which can then be
396  * queried by others ({ERC165Checker}).
397  *
398  * For an implementation, see {ERC165}.
399  */
400 interface IERC165 {
401     /**
402      * @dev Returns true if this contract implements the interface defined by
403      * `interfaceId`. See the corresponding
404      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
405      * to learn more about how these ids are created.
406      *
407      * This function call must use less than 30 000 gas.
408      */
409     function supportsInterface(bytes4 interfaceId) external view returns (bool);
410 }
411 
412 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
413 
414 
415 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 
420 /**
421  * @dev Implementation of the {IERC165} interface.
422  *
423  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
424  * for the additional interface id that will be supported. For example:
425  *
426  * ```solidity
427  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
428  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
429  * }
430  * ```
431  *
432  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
433  */
434 abstract contract ERC165 is IERC165 {
435     /**
436      * @dev See {IERC165-supportsInterface}.
437      */
438     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
439         return interfaceId == type(IERC165).interfaceId;
440     }
441 }
442 
443 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 
451 /**
452  * @dev Required interface of an ERC721 compliant contract.
453  */
454 interface IERC721 is IERC165 {
455     /**
456      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
457      */
458     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
459 
460     /**
461      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
462      */
463     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
464 
465     /**
466      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
467      */
468     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
469 
470     /**
471      * @dev Returns the number of tokens in ``owner``'s account.
472      */
473     function balanceOf(address owner) external view returns (uint256 balance);
474 
475     /**
476      * @dev Returns the owner of the `tokenId` token.
477      *
478      * Requirements:
479      *
480      * - `tokenId` must exist.
481      */
482     function ownerOf(uint256 tokenId) external view returns (address owner);
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
540      * @dev Returns the account approved for `tokenId` token.
541      *
542      * Requirements:
543      *
544      * - `tokenId` must exist.
545      */
546     function getApproved(uint256 tokenId) external view returns (address operator);
547 
548     /**
549      * @dev Approve or remove `operator` as an operator for the caller.
550      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
551      *
552      * Requirements:
553      *
554      * - The `operator` cannot be the caller.
555      *
556      * Emits an {ApprovalForAll} event.
557      */
558     function setApprovalForAll(address operator, bool _approved) external;
559 
560     /**
561      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
562      *
563      * See {setApprovalForAll}
564      */
565     function isApprovedForAll(address owner, address operator) external view returns (bool);
566 
567     /**
568      * @dev Safely transfers `tokenId` token from `from` to `to`.
569      *
570      * Requirements:
571      *
572      * - `from` cannot be the zero address.
573      * - `to` cannot be the zero address.
574      * - `tokenId` token must exist and be owned by `from`.
575      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
576      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
577      *
578      * Emits a {Transfer} event.
579      */
580     function safeTransferFrom(
581         address from,
582         address to,
583         uint256 tokenId,
584         bytes calldata data
585     ) external;
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
617 // File: contracts/new.sol
618 
619 
620 
621 
622 pragma solidity ^0.8.4;
623 
624 
625 
626 
627 
628 
629 
630 
631 error ApprovalCallerNotOwnerNorApproved();
632 error ApprovalQueryForNonexistentToken();
633 error ApproveToCaller();
634 error ApprovalToCurrentOwner();
635 error BalanceQueryForZeroAddress();
636 error MintToZeroAddress();
637 error MintZeroQuantity();
638 error OwnerQueryForNonexistentToken();
639 error TransferCallerNotOwnerNorApproved();
640 error TransferFromIncorrectOwner();
641 error TransferToNonERC721ReceiverImplementer();
642 error TransferToZeroAddress();
643 error URIQueryForNonexistentToken();
644 
645 /**
646  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
647  * the Metadata extension. Built to optimize for lower gas during batch mints.
648  *
649  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
650  *
651  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
652  *
653  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
654  */
655 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
656     using Address for address;
657     using Strings for uint256;
658 
659     // Compiler will pack this into a single 256bit word.
660     struct TokenOwnership {
661         // The address of the owner.
662         address addr;
663         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
664         uint64 startTimestamp;
665         // Whether the token has been burned.
666         bool burned;
667     }
668 
669     // Compiler will pack this into a single 256bit word.
670     struct AddressData {
671         // Realistically, 2**64-1 is more than enough.
672         uint64 balance;
673         // Keeps track of mint count with minimal overhead for tokenomics.
674         uint64 numberMinted;
675         // Keeps track of burn count with minimal overhead for tokenomics.
676         uint64 numberBurned;
677         // For miscellaneous variable(s) pertaining to the address
678         // (e.g. number of whitelist mint slots used).
679         // If there are multiple variables, please pack them into a uint64.
680         uint64 aux;
681     }
682 
683     // The tokenId of the next token to be minted.
684     uint256 internal _currentIndex;
685 
686     // The number of tokens burned.
687     uint256 internal _burnCounter;
688 
689     // Token name
690     string private _name;
691 
692     // Token symbol
693     string private _symbol;
694 
695     // Mapping from token ID to ownership details
696     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
697     mapping(uint256 => TokenOwnership) internal _ownerships;
698 
699     // Mapping owner address to address data
700     mapping(address => AddressData) private _addressData;
701 
702     // Mapping from token ID to approved address
703     mapping(uint256 => address) private _tokenApprovals;
704 
705     // Mapping from owner to operator approvals
706     mapping(address => mapping(address => bool)) private _operatorApprovals;
707 
708     constructor(string memory name_, string memory symbol_) {
709         _name = name_;
710         _symbol = symbol_;
711         _currentIndex = _startTokenId();
712     }
713 
714     /**
715      * To change the starting tokenId, please override this function.
716      */
717     function _startTokenId() internal view virtual returns (uint256) {
718         return 0;
719     }
720 
721     /**
722      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
723      */
724     function totalSupply() public view returns (uint256) {
725         // Counter underflow is impossible as _burnCounter cannot be incremented
726         // more than _currentIndex - _startTokenId() times
727         unchecked {
728             return _currentIndex - _burnCounter - _startTokenId();
729         }
730     }
731 
732     /**
733      * Returns the total amount of tokens minted in the contract.
734      */
735     function _totalMinted() internal view returns (uint256) {
736         // Counter underflow is impossible as _currentIndex does not decrement,
737         // and it is initialized to _startTokenId()
738         unchecked {
739             return _currentIndex - _startTokenId();
740         }
741     }
742 
743     /**
744      * @dev See {IERC165-supportsInterface}.
745      */
746     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
747         return
748             interfaceId == type(IERC721).interfaceId ||
749             interfaceId == type(IERC721Metadata).interfaceId ||
750             super.supportsInterface(interfaceId);
751     }
752 
753     /**
754      * @dev See {IERC721-balanceOf}.
755      */
756     function balanceOf(address owner) public view override returns (uint256) {
757         if (owner == address(0)) revert BalanceQueryForZeroAddress();
758         return uint256(_addressData[owner].balance);
759     }
760 
761     /**
762      * Returns the number of tokens minted by `owner`.
763      */
764     function _numberMinted(address owner) internal view returns (uint256) {
765         return uint256(_addressData[owner].numberMinted);
766     }
767 
768     /**
769      * Returns the number of tokens burned by or on behalf of `owner`.
770      */
771     function _numberBurned(address owner) internal view returns (uint256) {
772         return uint256(_addressData[owner].numberBurned);
773     }
774 
775     /**
776      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
777      */
778     function _getAux(address owner) internal view returns (uint64) {
779         return _addressData[owner].aux;
780     }
781 
782     /**
783      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
784      * If there are multiple variables, please pack them into a uint64.
785      */
786     function _setAux(address owner, uint64 aux) internal {
787         _addressData[owner].aux = aux;
788     }
789 
790     /**
791      * Gas spent here starts off proportional to the maximum mint batch size.
792      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
793      */
794     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
795         uint256 curr = tokenId;
796 
797         unchecked {
798             if (_startTokenId() <= curr && curr < _currentIndex) {
799                 TokenOwnership memory ownership = _ownerships[curr];
800                 if (!ownership.burned) {
801                     if (ownership.addr != address(0)) {
802                         return ownership;
803                     }
804                     // Invariant:
805                     // There will always be an ownership that has an address and is not burned
806                     // before an ownership that does not have an address and is not burned.
807                     // Hence, curr will not underflow.
808                     while (true) {
809                         curr--;
810                         ownership = _ownerships[curr];
811                         if (ownership.addr != address(0)) {
812                             return ownership;
813                         }
814                     }
815                 }
816             }
817         }
818         revert OwnerQueryForNonexistentToken();
819     }
820 
821     /**
822      * @dev See {IERC721-ownerOf}.
823      */
824     function ownerOf(uint256 tokenId) public view override returns (address) {
825         return _ownershipOf(tokenId).addr;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-name}.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-symbol}.
837      */
838     function symbol() public view virtual override returns (string memory) {
839         return _symbol;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-tokenURI}.
844      */
845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
846         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
847 
848         string memory baseURI = _baseURI();
849         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, can be overriden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return '';
859     }
860 
861     /**
862      * @dev See {IERC721-approve}.
863      */
864     function approve(address to, uint256 tokenId) public override {
865         address owner = ERC721A.ownerOf(tokenId);
866         if (to == owner) revert ApprovalToCurrentOwner();
867 
868         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
869             revert ApprovalCallerNotOwnerNorApproved();
870         }
871 
872         _approve(to, tokenId, owner);
873     }
874 
875     /**
876      * @dev See {IERC721-getApproved}.
877      */
878     function getApproved(uint256 tokenId) public view override returns (address) {
879         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
880 
881         return _tokenApprovals[tokenId];
882     }
883 
884     /**
885      * @dev See {IERC721-setApprovalForAll}.
886      */
887     function setApprovalForAll(address operator, bool approved) public virtual override {
888         if (operator == _msgSender()) revert ApproveToCaller();
889 
890         _operatorApprovals[_msgSender()][operator] = approved;
891         emit ApprovalForAll(_msgSender(), operator, approved);
892     }
893 
894     /**
895      * @dev See {IERC721-isApprovedForAll}.
896      */
897     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
898         return _operatorApprovals[owner][operator];
899     }
900 
901     /**
902      * @dev See {IERC721-transferFrom}.
903      */
904     function transferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) public virtual override {
909         _transfer(from, to, tokenId);
910     }
911 
912     /**
913      * @dev See {IERC721-safeTransferFrom}.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         safeTransferFrom(from, to, tokenId, '');
921     }
922 
923     /**
924      * @dev See {IERC721-safeTransferFrom}.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId,
930         bytes memory _data
931     ) public virtual override {
932         _transfer(from, to, tokenId);
933         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
934             revert TransferToNonERC721ReceiverImplementer();
935         }
936     }
937 
938     /**
939      * @dev Returns whether `tokenId` exists.
940      *
941      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
942      *
943      * Tokens start existing when they are minted (`_mint`),
944      */
945     function _exists(uint256 tokenId) internal view returns (bool) {
946         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
947             !_ownerships[tokenId].burned;
948     }
949 
950     function _safeMint(address to, uint256 quantity) internal {
951         _safeMint(to, quantity, '');
952     }
953 
954     /**
955      * @dev Safely mints `quantity` tokens and transfers them to `to`.
956      *
957      * Requirements:
958      *
959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
960      * - `quantity` must be greater than 0.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _safeMint(
965         address to,
966         uint256 quantity,
967         bytes memory _data
968     ) internal {
969         _mint(to, quantity, _data, true);
970     }
971 
972     /**
973      * @dev Mints `quantity` tokens and transfers them to `to`.
974      *
975      * Requirements:
976      *
977      * - `to` cannot be the zero address.
978      * - `quantity` must be greater than 0.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _mint(
983         address to,
984         uint256 quantity,
985         bytes memory _data,
986         bool safe
987     ) internal {
988         uint256 startTokenId = _currentIndex;
989         if (to == address(0)) revert MintToZeroAddress();
990         if (quantity == 0) revert MintZeroQuantity();
991 
992         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
993 
994         // Overflows are incredibly unrealistic.
995         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
996         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
997         unchecked {
998             _addressData[to].balance += uint64(quantity);
999             _addressData[to].numberMinted += uint64(quantity);
1000 
1001             _ownerships[startTokenId].addr = to;
1002             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1003 
1004             uint256 updatedIndex = startTokenId;
1005             uint256 end = updatedIndex + quantity;
1006 
1007             if (safe && to.isContract()) {
1008                 do {
1009                     emit Transfer(address(0), to, updatedIndex);
1010                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1011                         revert TransferToNonERC721ReceiverImplementer();
1012                     }
1013                 } while (updatedIndex != end);
1014                 // Reentrancy protection
1015                 if (_currentIndex != startTokenId) revert();
1016             } else {
1017                 do {
1018                     emit Transfer(address(0), to, updatedIndex++);
1019                 } while (updatedIndex != end);
1020             }
1021             _currentIndex = updatedIndex;
1022         }
1023         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1024     }
1025 
1026     /**
1027      * @dev Transfers `tokenId` from `from` to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must be owned by `from`.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _transfer(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) private {
1041         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1042 
1043         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1044 
1045         bool isApprovedOrOwner = (_msgSender() == from ||
1046             isApprovedForAll(from, _msgSender()) ||
1047             getApproved(tokenId) == _msgSender());
1048 
1049         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1050         if (to == address(0)) revert TransferToZeroAddress();
1051 
1052         _beforeTokenTransfers(from, to, tokenId, 1);
1053 
1054         // Clear approvals from the previous owner
1055         _approve(address(0), tokenId, from);
1056 
1057         // Underflow of the sender's balance is impossible because we check for
1058         // ownership above and the recipient's balance can't realistically overflow.
1059         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1060         unchecked {
1061             _addressData[from].balance -= 1;
1062             _addressData[to].balance += 1;
1063 
1064             TokenOwnership storage currSlot = _ownerships[tokenId];
1065             currSlot.addr = to;
1066             currSlot.startTimestamp = uint64(block.timestamp);
1067 
1068             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1069             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1070             uint256 nextTokenId = tokenId + 1;
1071             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1072             if (nextSlot.addr == address(0)) {
1073                 // This will suffice for checking _exists(nextTokenId),
1074                 // as a burned slot cannot contain the zero address.
1075                 if (nextTokenId != _currentIndex) {
1076                     nextSlot.addr = from;
1077                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1078                 }
1079             }
1080         }
1081 
1082         emit Transfer(from, to, tokenId);
1083         _afterTokenTransfers(from, to, tokenId, 1);
1084     }
1085 
1086     /**
1087      * @dev This is equivalent to _burn(tokenId, false)
1088      */
1089     function _burn(uint256 tokenId) internal virtual {
1090         _burn(tokenId, false);
1091     }
1092 
1093     /**
1094      * @dev Destroys `tokenId`.
1095      * The approval is cleared when the token is burned.
1096      *
1097      * Requirements:
1098      *
1099      * - `tokenId` must exist.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1104         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1105 
1106         address from = prevOwnership.addr;
1107 
1108         if (approvalCheck) {
1109             bool isApprovedOrOwner = (_msgSender() == from ||
1110                 isApprovedForAll(from, _msgSender()) ||
1111                 getApproved(tokenId) == _msgSender());
1112 
1113             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1114         }
1115 
1116         _beforeTokenTransfers(from, address(0), tokenId, 1);
1117 
1118         // Clear approvals from the previous owner
1119         _approve(address(0), tokenId, from);
1120 
1121         // Underflow of the sender's balance is impossible because we check for
1122         // ownership above and the recipient's balance can't realistically overflow.
1123         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1124         unchecked {
1125             AddressData storage addressData = _addressData[from];
1126             addressData.balance -= 1;
1127             addressData.numberBurned += 1;
1128 
1129             // Keep track of who burned the token, and the timestamp of burning.
1130             TokenOwnership storage currSlot = _ownerships[tokenId];
1131             currSlot.addr = from;
1132             currSlot.startTimestamp = uint64(block.timestamp);
1133             currSlot.burned = true;
1134 
1135             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1136             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1137             uint256 nextTokenId = tokenId + 1;
1138             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1139             if (nextSlot.addr == address(0)) {
1140                 // This will suffice for checking _exists(nextTokenId),
1141                 // as a burned slot cannot contain the zero address.
1142                 if (nextTokenId != _currentIndex) {
1143                     nextSlot.addr = from;
1144                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1145                 }
1146             }
1147         }
1148 
1149         emit Transfer(from, address(0), tokenId);
1150         _afterTokenTransfers(from, address(0), tokenId, 1);
1151 
1152         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1153         unchecked {
1154             _burnCounter++;
1155         }
1156     }
1157 
1158     /**
1159      * @dev Approve `to` to operate on `tokenId`
1160      *
1161      * Emits a {Approval} event.
1162      */
1163     function _approve(
1164         address to,
1165         uint256 tokenId,
1166         address owner
1167     ) private {
1168         _tokenApprovals[tokenId] = to;
1169         emit Approval(owner, to, tokenId);
1170     }
1171 
1172     /**
1173      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1174      *
1175      * @param from address representing the previous owner of the given token ID
1176      * @param to target address that will receive the tokens
1177      * @param tokenId uint256 ID of the token to be transferred
1178      * @param _data bytes optional data to send along with the call
1179      * @return bool whether the call correctly returned the expected magic value
1180      */
1181     function _checkContractOnERC721Received(
1182         address from,
1183         address to,
1184         uint256 tokenId,
1185         bytes memory _data
1186     ) private returns (bool) {
1187         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1188             return retval == IERC721Receiver(to).onERC721Received.selector;
1189         } catch (bytes memory reason) {
1190             if (reason.length == 0) {
1191                 revert TransferToNonERC721ReceiverImplementer();
1192             } else {
1193                 assembly {
1194                     revert(add(32, reason), mload(reason))
1195                 }
1196             }
1197         }
1198     }
1199 
1200     /**
1201      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1202      * And also called before burning one token.
1203      *
1204      * startTokenId - the first token id to be transferred
1205      * quantity - the amount to be transferred
1206      *
1207      * Calling conditions:
1208      *
1209      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1210      * transferred to `to`.
1211      * - When `from` is zero, `tokenId` will be minted for `to`.
1212      * - When `to` is zero, `tokenId` will be burned by `from`.
1213      * - `from` and `to` are never both zero.
1214      */
1215     function _beforeTokenTransfers(
1216         address from,
1217         address to,
1218         uint256 startTokenId,
1219         uint256 quantity
1220     ) internal virtual {}
1221 
1222     /**
1223      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1224      * minting.
1225      * And also called after one token has been burned.
1226      *
1227      * startTokenId - the first token id to be transferred
1228      * quantity - the amount to be transferred
1229      *
1230      * Calling conditions:
1231      *
1232      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1233      * transferred to `to`.
1234      * - When `from` is zero, `tokenId` has been minted for `to`.
1235      * - When `to` is zero, `tokenId` has been burned by `from`.
1236      * - `from` and `to` are never both zero.
1237      */
1238     function _afterTokenTransfers(
1239         address from,
1240         address to,
1241         uint256 startTokenId,
1242         uint256 quantity
1243     ) internal virtual {}
1244 }
1245 
1246 abstract contract Ownable is Context {
1247     address private _owner;
1248 
1249     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1250 
1251     /**
1252      * @dev Initializes the contract setting the deployer as the initial owner.
1253      */
1254     constructor() {
1255         _transferOwnership(_msgSender());
1256     }
1257 
1258     /**
1259      * @dev Returns the address of the current owner.
1260      */
1261     function owner() public view virtual returns (address) {
1262         return _owner;
1263     }
1264 
1265     /**
1266      * @dev Throws if called by any account other than the owner.
1267      */
1268     modifier onlyOwner() {
1269         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1270         _;
1271     }
1272 
1273     /**
1274      * @dev Leaves the contract without owner. It will not be possible to call
1275      * `onlyOwner` functions anymore. Can only be called by the current owner.
1276      *
1277      * NOTE: Renouncing ownership will leave the contract without an owner,
1278      * thereby removing any functionality that is only available to the owner.
1279      */
1280     function renounceOwnership() public virtual onlyOwner {
1281         _transferOwnership(address(0));
1282     }
1283 
1284     /**
1285      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1286      * Can only be called by the current owner.
1287      */
1288     function transferOwnership(address newOwner) public virtual onlyOwner {
1289         require(newOwner != address(0), "Ownable: new owner is the zero address");
1290         _transferOwnership(newOwner);
1291     }
1292 
1293     /**
1294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1295      * Internal function without access restriction.
1296      */
1297     function _transferOwnership(address newOwner) internal virtual {
1298         address oldOwner = _owner;
1299         _owner = newOwner;
1300         emit OwnershipTransferred(oldOwner, newOwner);
1301     }
1302 }
1303     pragma solidity ^0.8.7;
1304     
1305     contract SSKULLSS is ERC721A, Ownable {
1306     using Strings for uint256;
1307 
1308 
1309   string private uriPrefix ;
1310   string private uriSuffix = ".json";
1311   string public hiddenURL;
1312 
1313   
1314   
1315 
1316   uint256 public cost = 0.006 ether;
1317   uint256 public whiteListCost = 0 ;
1318   
1319 
1320   uint16 public maxSupply = 3500;
1321   uint8 public maxMintAmountPerTx = 6;
1322     uint8 public maxFreeMintAmountPerWallet = 1;
1323                                                              
1324   bool public WLpaused = true;
1325   bool public paused = true;
1326   bool public reveal =false;
1327   mapping (address => uint8) public NFTPerWLAddress;
1328    mapping (address => uint8) public NFTPerPublicAddress;
1329   mapping (address => bool) public isWhitelisted;
1330  
1331   
1332   
1333  
1334   
1335 
1336   constructor() ERC721A("SSKULLSS", "SSYSTEMSS") {
1337   }
1338 
1339  function SSAYGOODBYESS(uint[] calldata token) external onlyOwner{
1340      for(uint i ; i <token.length ; i ++)
1341    _burn(token[i]);
1342  }
1343   
1344 
1345   
1346  
1347   function SSPAWNSSSSKULLSS(uint8 _mintAmount) external payable  {
1348      uint16 totalSupply = uint16(totalSupply());
1349      uint8 nft = NFTPerPublicAddress[msg.sender];
1350     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1351     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1352 
1353     require(!paused, "The contract is paused!");
1354     
1355       if(nft >= maxFreeMintAmountPerWallet)
1356     {
1357     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1358     }
1359     else {
1360          uint8 costAmount = _mintAmount + nft;
1361         if(costAmount > maxFreeMintAmountPerWallet)
1362        {
1363         costAmount = costAmount - maxFreeMintAmountPerWallet;
1364         require(msg.value >= cost * costAmount, "Insufficient funds!");
1365        }
1366        
1367          
1368     }
1369     
1370 
1371 
1372     _safeMint(msg.sender , _mintAmount);
1373 
1374     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1375      
1376      delete totalSupply;
1377      delete _mintAmount;
1378   }
1379   
1380   function SSKULLSS_SSUMMONSS(uint16 _mintAmount, address _receiver) external onlyOwner {
1381      uint16 totalSupply = uint16(totalSupply());
1382     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1383      _safeMint(_receiver , _mintAmount);
1384      delete _mintAmount;
1385      delete _receiver;
1386      delete totalSupply;
1387   }
1388 
1389   function  SSENDSS_HACKSS(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1390      uint16 totalSupply = uint16(totalSupply());
1391      uint totalAmount =   _amountPerAddress * addresses.length;
1392     require(totalSupply + totalAmount <= maxSupply, "Excedes max supply.");
1393      for (uint256 i = 0; i < addresses.length; i++) {
1394             _safeMint(addresses[i], _amountPerAddress);
1395         }
1396 
1397      delete _amountPerAddress;
1398      delete totalSupply;
1399   }
1400 
1401  
1402 
1403   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1404       maxSupply = _maxSupply;
1405   }
1406 
1407 
1408 
1409    
1410   function tokenURI(uint256 _tokenId)
1411     public
1412     view
1413     virtual
1414     override
1415     returns (string memory)
1416   {
1417     require(
1418       _exists(_tokenId),
1419       "ERC721Metadata: URI query for nonexistent token"
1420     );
1421     
1422   
1423 if ( reveal == false)
1424 {
1425     return hiddenURL;
1426 }
1427     
1428 
1429     string memory currentBaseURI = _baseURI();
1430     return bytes(currentBaseURI).length > 0
1431         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1432         : "";
1433   }
1434  
1435    function setWLPaused() external onlyOwner {
1436     WLpaused = !WLpaused;
1437   }
1438   function setWLCost(uint256 _cost) external onlyOwner {
1439     whiteListCost = _cost;
1440     delete _cost;
1441   }
1442 
1443 
1444 
1445  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1446     maxFreeMintAmountPerWallet = _limit;
1447    delete _limit;
1448 
1449 }
1450 
1451     
1452   function SSKULLSS_SSYSTEMSS_FULLY_ACTIVE(address[] calldata entries) external onlyOwner {
1453         for(uint8 i = 0; i < entries.length; i++) {
1454             isWhitelisted[entries[i]] = true;
1455         }   
1456     }
1457 
1458     function ENTER_THE_MATRIX(address[] calldata entries) external onlyOwner {
1459         for(uint8 i = 0; i < entries.length; i++) {
1460              isWhitelisted[entries[i]] = false;
1461         }
1462     }
1463 
1464 function whitelistMint(uint8 _mintAmount) external payable {
1465         
1466     
1467         uint8 nft = NFTPerWLAddress[msg.sender];
1468        require(isWhitelisted[msg.sender],  "You are not whitelisted");
1469 
1470        require (nft + _mintAmount <= maxMintAmountPerTx, "Exceeds max  limit  per address");
1471       
1472 
1473 
1474     require(!WLpaused, "Whitelist minting is over!");
1475          if(nft >= maxFreeMintAmountPerWallet)
1476     {
1477     require(msg.value >= whiteListCost * _mintAmount, "Insufficient funds!");
1478     }
1479     else {
1480          uint8 costAmount = _mintAmount + nft;
1481         if(costAmount > maxFreeMintAmountPerWallet)
1482        {
1483         costAmount = costAmount - maxFreeMintAmountPerWallet;
1484         require(msg.value >= whiteListCost * costAmount, "Insufficient funds!");
1485        }
1486        
1487          
1488     }
1489     
1490     
1491 
1492      _safeMint(msg.sender , _mintAmount);
1493       NFTPerWLAddress[msg.sender] =nft + _mintAmount;
1494      
1495       delete _mintAmount;
1496        delete nft;
1497     
1498     }
1499 
1500   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1501     uriPrefix = _uriPrefix;
1502   }
1503    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1504     hiddenURL = _uriPrefix;
1505   }
1506 
1507 
1508   function setPaused() external onlyOwner {
1509     paused = !paused;
1510     WLpaused = true;
1511   }
1512 
1513   function setCost(uint _cost) external onlyOwner{
1514       cost = _cost;
1515 
1516   }
1517 
1518  function setRevealed() external onlyOwner{
1519      reveal = !reveal;
1520  }
1521 
1522   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1523       maxMintAmountPerTx = _maxtx;
1524 
1525   }
1526 
1527  
1528 
1529   function withdraw() external onlyOwner {
1530   uint _balance = address(this).balance;
1531      payable(msg.sender).transfer(_balance ); 
1532        
1533   }
1534 
1535 
1536   function _baseURI() internal view  override returns (string memory) {
1537     return uriPrefix;
1538   }
1539 }