1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-11
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-05-09
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-04-29
11 */
12 // SPDX-License-Identifier: MIT
13 pragma solidity ^0.8.7; 
14 
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 interface IERC721 is IERC165 {
28     /**
29      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
30      */
31     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
32 
33     /**
34      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
35      */
36     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
40      */
41     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
42 
43     /**
44      * @dev Returns the number of tokens in ``owner``'s account.
45      */
46     function balanceOf(address owner) external view returns (uint256 balance);
47 
48     /**
49      * @dev Returns the owner of the `tokenId` token.
50      *
51      * Requirements:
52      *
53      * - `tokenId` must exist.
54      */
55     function ownerOf(uint256 tokenId) external view returns (address owner);
56 
57     /**
58      * @dev Safely transfers `tokenId` token from `from` to `to`.
59      *
60      * Requirements:
61      *
62      * - `from` cannot be the zero address.
63      * - `to` cannot be the zero address.
64      * - `tokenId` token must exist and be owned by `from`.
65      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
66      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
67      *
68      * Emits a {Transfer} event.
69      */
70     function safeTransferFrom(
71         address from,
72         address to,
73         uint256 tokenId,
74         bytes calldata data
75     ) external;
76 
77     /**
78      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
79      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
80      *
81      * Requirements:
82      *
83      * - `from` cannot be the zero address.
84      * - `to` cannot be the zero address.
85      * - `tokenId` token must exist and be owned by `from`.
86      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
87      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
88      *
89      * Emits a {Transfer} event.
90      */
91     function safeTransferFrom(
92         address from,
93         address to,
94         uint256 tokenId
95     ) external;
96 
97     /**
98      * @dev Transfers `tokenId` token from `from` to `to`.
99      *
100      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must be owned by `from`.
107      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(
112         address from,
113         address to,
114         uint256 tokenId
115     ) external;
116 
117     /**
118      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
119      * The approval is cleared when the token is transferred.
120      *
121      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
122      *
123      * Requirements:
124      *
125      * - The caller must own the token or be an approved operator.
126      * - `tokenId` must exist.
127      *
128      * Emits an {Approval} event.
129      */
130     function approve(address to, uint256 tokenId) external;
131 
132     /**
133      * @dev Approve or remove `operator` as an operator for the caller.
134      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
135      *
136      * Requirements:
137      *
138      * - The `operator` cannot be the caller.
139      *
140      * Emits an {ApprovalForAll} event.
141      */
142     function setApprovalForAll(address operator, bool _approved) external;
143 
144     /**
145      * @dev Returns the account approved for `tokenId` token.
146      *
147      * Requirements:
148      *
149      * - `tokenId` must exist.
150      */
151     function getApproved(uint256 tokenId) external view returns (address operator);
152 
153     /**
154      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
155      *
156      * See {setApprovalForAll}
157      */
158     function isApprovedForAll(address owner, address operator) external view returns (bool);
159 }
160 
161 interface IERC721Metadata is IERC721 {
162     /**
163      * @dev Returns the token collection name.
164      */
165     function name() external view returns (string memory);
166 
167     /**
168      * @dev Returns the token collection symbol.
169      */
170     function symbol() external view returns (string memory);
171 
172     /**
173      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
174      */
175     function tokenURI(uint256 tokenId) external view returns (string memory);
176 }
177 
178 
179 interface IERC721A is IERC721, IERC721Metadata {
180     /**
181      * The caller must own the token or be an approved operator.
182      */
183     error ApprovalCallerNotOwnerNorApproved();
184 
185     /**
186      * The token does not exist.
187      */
188     error ApprovalQueryForNonexistentToken();
189 
190     /**
191      * The caller cannot approve to their own address.
192      */
193     error ApproveToCaller();
194 
195     /**
196      * The caller cannot approve to the current owner.
197      */
198     error ApprovalToCurrentOwner();
199 
200     /**
201      * Cannot query the balance for the zero address.
202      */
203     error BalanceQueryForZeroAddress();
204 
205     /**
206      * Cannot mint to the zero address.
207      */
208     error MintToZeroAddress();
209 
210     /**
211      * The quantity of tokens minted must be more than zero.
212      */
213     error MintZeroQuantity();
214 
215     /**
216      * The token does not exist.
217      */
218     error OwnerQueryForNonexistentToken();
219 
220     /**
221      * The caller must own the token or be an approved operator.
222      */
223     error TransferCallerNotOwnerNorApproved();
224 
225     /**
226      * The token must be owned by `from`.
227      */
228     error TransferFromIncorrectOwner();
229 
230     /**
231      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
232      */
233     error TransferToNonERC721ReceiverImplementer();
234 
235     /**
236      * Cannot transfer to the zero address.
237      */
238     error TransferToZeroAddress();
239 
240     /**
241      * The token does not exist.
242      */
243     error URIQueryForNonexistentToken();
244 
245     // Compiler will pack this into a single 256bit word.
246     struct TokenOwnership {
247         // The address of the owner.
248         address addr;
249         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
250         uint64 startTimestamp;
251         // Whether the token has been burned.
252         bool burned;
253     }
254 
255     // Compiler will pack this into a single 256bit word.
256     struct AddressData {
257         // Realistically, 2**64-1 is more than enough.
258         uint64 balance;
259         // Keeps track of mint count with minimal overhead for tokenomics.
260         uint64 numberMinted;
261         // Keeps track of burn count with minimal overhead for tokenomics.
262         uint64 numberBurned;
263         // For miscellaneous variable(s) pertaining to the address
264         // (e.g. number of whitelist mint slots used).
265         // If there are multiple variables, please pack them into a uint64.
266         uint64 aux;
267     }
268 
269     /**
270      * @dev Returns the total amount of tokens stored by the contract.
271      * 
272      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
273      */
274     function totalSupply() external view returns (uint256);
275 }
276 
277 interface IERC721Receiver {
278     /**
279      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
280      * by `operator` from `from`, this function is called.
281      *
282      * It must return its Solidity selector to confirm the token transfer.
283      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
284      *
285      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
286      */
287     function onERC721Received(
288         address operator,
289         address from,
290         uint256 tokenId,
291         bytes calldata data
292     ) external returns (bytes4);
293 }
294 
295 library Address {
296     /**
297      * @dev Returns true if `account` is a contract.
298      *
299      * [IMPORTANT]
300      * ====
301      * It is unsafe to assume that an address for which this function returns
302      * false is an externally-owned account (EOA) and not a contract.
303      *
304      * Among others, `isContract` will return false for the following
305      * types of addresses:
306      *
307      *  - an externally-owned account
308      *  - a contract in construction
309      *  - an address where a contract will be created
310      *  - an address where a contract lived, but was destroyed
311      * ====
312      *
313      * [IMPORTANT]
314      * ====
315      * You shouldn't rely on `isContract` to protect against flash loan attacks!
316      *
317      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
318      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
319      * constructor.
320      * ====
321      */
322     function isContract(address account) internal view returns (bool) {
323         // This method relies on extcodesize/address.code.length, which returns 0
324         // for contracts in construction, since the code is only stored at the end
325         // of the constructor execution.
326 
327         return account.code.length > 0;
328     }
329 
330     /**
331      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
332      * `recipient`, forwarding all available gas and reverting on errors.
333      *
334      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
335      * of certain opcodes, possibly making contracts go over the 2300 gas limit
336      * imposed by `transfer`, making them unable to receive funds via
337      * `transfer`. {sendValue} removes this limitation.
338      *
339      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
340      *
341      * IMPORTANT: because control is transferred to `recipient`, care must be
342      * taken to not create reentrancy vulnerabilities. Consider using
343      * {ReentrancyGuard} or the
344      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
345      */
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(address(this).balance >= amount, "Address: insufficient balance");
348 
349         (bool success, ) = recipient.call{value: amount}("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 
353     /**
354      * @dev Performs a Solidity function call using a low level `call`. A
355      * plain `call` is an unsafe replacement for a function call: use this
356      * function instead.
357      *
358      * If `target` reverts with a revert reason, it is bubbled up by this
359      * function (like regular Solidity function calls).
360      *
361      * Returns the raw returned data. To convert to the expected return value,
362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
363      *
364      * Requirements:
365      *
366      * - `target` must be a contract.
367      * - calling `target` with `data` must not revert.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
372         return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal returns (bytes memory) {
386         return functionCallWithValue(target, data, 0, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but also transferring `value` wei to `target`.
392      *
393      * Requirements:
394      *
395      * - the calling contract must have an ETH balance of at least `value`.
396      * - the called Solidity function must be `payable`.
397      *
398      * _Available since v3.1._
399      */
400     function functionCallWithValue(
401         address target,
402         bytes memory data,
403         uint256 value
404     ) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
410      * with `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         require(address(this).balance >= value, "Address: insufficient balance for call");
421         require(isContract(target), "Address: call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.call{value: value}(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but performing a static call.
430      *
431      * _Available since v3.3._
432      */
433     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
434         return functionStaticCall(target, data, "Address: low-level static call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(
444         address target,
445         bytes memory data,
446         string memory errorMessage
447     ) internal view returns (bytes memory) {
448         require(isContract(target), "Address: static call to non-contract");
449 
450         (bool success, bytes memory returndata) = target.staticcall(data);
451         return verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
456      * but performing a delegate call.
457      *
458      * _Available since v3.4._
459      */
460     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
461         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(
471         address target,
472         bytes memory data,
473         string memory errorMessage
474     ) internal returns (bytes memory) {
475         require(isContract(target), "Address: delegate call to non-contract");
476 
477         (bool success, bytes memory returndata) = target.delegatecall(data);
478         return verifyCallResult(success, returndata, errorMessage);
479     }
480 
481     /**
482      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
483      * revert reason using the provided one.
484      *
485      * _Available since v4.3._
486      */
487     function verifyCallResult(
488         bool success,
489         bytes memory returndata,
490         string memory errorMessage
491     ) internal pure returns (bytes memory) {
492         if (success) {
493             return returndata;
494         } else {
495             // Look for revert reason and bubble it up if present
496             if (returndata.length > 0) {
497                 // The easiest way to bubble the revert reason is using memory via assembly
498 
499                 assembly {
500                     let returndata_size := mload(returndata)
501                     revert(add(32, returndata), returndata_size)
502                 }
503             } else {
504                 revert(errorMessage);
505             }
506         }
507     }
508 }
509 
510 abstract contract Context {
511     function _msgSender() internal view virtual returns (address) {
512         return msg.sender;
513     }
514 
515     function _msgData() internal view virtual returns (bytes calldata) {
516         return msg.data;
517     }
518 }
519 
520 library Strings {
521     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
522 
523     /**
524      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
525      */
526     function toString(uint256 value) internal pure returns (string memory) {
527         // Inspired by OraclizeAPI's implementation - MIT licence
528         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
529 
530         if (value == 0) {
531             return "0";
532         }
533         uint256 temp = value;
534         uint256 digits;
535         while (temp != 0) {
536             digits++;
537             temp /= 10;
538         }
539         bytes memory buffer = new bytes(digits);
540         while (value != 0) {
541             digits -= 1;
542             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
543             value /= 10;
544         }
545         return string(buffer);
546     }
547 
548     /**
549      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
550      */
551     function toHexString(uint256 value) internal pure returns (string memory) {
552         if (value == 0) {
553             return "0x00";
554         }
555         uint256 temp = value;
556         uint256 length = 0;
557         while (temp != 0) {
558             length++;
559             temp >>= 8;
560         }
561         return toHexString(value, length);
562     }
563 
564     /**
565      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
566      */
567     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
568         bytes memory buffer = new bytes(2 * length + 2);
569         buffer[0] = "0";
570         buffer[1] = "x";
571         for (uint256 i = 2 * length + 1; i > 1; --i) {
572             buffer[i] = _HEX_SYMBOLS[value & 0xf];
573             value >>= 4;
574         }
575         require(value == 0, "Strings: hex length insufficient");
576         return string(buffer);
577     }
578 } 
579 
580 abstract contract ERC165 is IERC165 {
581     /**
582      * @dev See {IERC165-supportsInterface}.
583      */
584     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585         return interfaceId == type(IERC165).interfaceId;
586     }
587 }
588 
589 contract ERC721A is Context, ERC165, IERC721A {
590     using Address for address;
591     using Strings for uint256;
592 
593     // The tokenId of the next token to be minted.
594     uint256 internal _currentIndex;
595 
596     // The number of tokens burned.
597     uint256 internal _burnCounter;
598 
599     // Token name
600     string private _name;
601 
602     // Token symbol
603     string private _symbol;
604 
605     // Mapping from token ID to ownership details
606     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
607     mapping(uint256 => TokenOwnership) internal _ownerships;
608 
609     // Mapping owner address to address data
610     mapping(address => AddressData) private _addressData;
611 
612     // Mapping from token ID to approved address
613     mapping(uint256 => address) private _tokenApprovals;
614 
615     // Mapping from owner to operator approvals
616     mapping(address => mapping(address => bool)) private _operatorApprovals;
617 
618     constructor(string memory name_, string memory symbol_) {
619         _name = name_;
620         _symbol = symbol_;
621         _currentIndex = _startTokenId();
622     }
623 
624     /**
625      * To change the starting tokenId, please override this function.
626      */
627     function _startTokenId() internal view virtual returns (uint256) {
628         return 0;
629     }
630 
631     /**
632      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
633      */
634     function totalSupply() public view override returns (uint256) {
635         // Counter underflow is impossible as _burnCounter cannot be incremented
636         // more than _currentIndex - _startTokenId() times
637         unchecked {
638             return _currentIndex - _burnCounter - _startTokenId();
639         }
640     }
641 
642     /**
643      * Returns the total amount of tokens minted in the contract.
644      */
645     function _totalMinted() internal view returns (uint256) {
646         // Counter underflow is impossible as _currentIndex does not decrement,
647         // and it is initialized to _startTokenId()
648         unchecked {
649             return _currentIndex - _startTokenId();
650         }
651     }
652 
653     /**
654      * @dev See {IERC165-supportsInterface}.
655      */
656     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
657         return
658             interfaceId == type(IERC721).interfaceId ||
659             interfaceId == type(IERC721Metadata).interfaceId ||
660             super.supportsInterface(interfaceId);
661     }
662 
663     /**
664      * @dev See {IERC721-balanceOf}.
665      */
666     function balanceOf(address owner) public view override returns (uint256) {
667         if (owner == address(0)) revert BalanceQueryForZeroAddress();
668         return uint256(_addressData[owner].balance);
669     }
670 
671     /**
672      * Returns the number of tokens minted by `owner`.
673      */
674     function _numberMinted(address owner) internal view returns (uint256) {
675         return uint256(_addressData[owner].numberMinted);
676     }
677 
678     /**
679      * Returns the number of tokens burned by or on behalf of `owner`.
680      */
681     function _numberBurned(address owner) internal view returns (uint256) {
682         return uint256(_addressData[owner].numberBurned);
683     }
684 
685     /**
686      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
687      */
688     function _getAux(address owner) internal view returns (uint64) {
689         return _addressData[owner].aux;
690     }
691 
692     /**
693      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
694      * If there are multiple variables, please pack them into a uint64.
695      */
696     function _setAux(address owner, uint64 aux) internal {
697         _addressData[owner].aux = aux;
698     }
699 
700     /**
701      * Gas spent here starts off proportional to the maximum mint batch size.
702      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
703      */
704     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
705         uint256 curr = tokenId;
706 
707         unchecked {
708             if (_startTokenId() <= curr) if (curr < _currentIndex) {
709                 TokenOwnership memory ownership = _ownerships[curr];
710                 if (!ownership.burned) {
711                     if (ownership.addr != address(0)) {
712                         return ownership;
713                     }
714                     // Invariant:
715                     // There will always be an ownership that has an address and is not burned
716                     // before an ownership that does not have an address and is not burned.
717                     // Hence, curr will not underflow.
718                     while (true) {
719                         curr--;
720                         ownership = _ownerships[curr];
721                         if (ownership.addr != address(0)) {
722                             return ownership;
723                         }
724                     }
725                 }
726             }
727         }
728         revert OwnerQueryForNonexistentToken();
729     }
730 
731     /**
732      * @dev See {IERC721-ownerOf}.
733      */
734     function ownerOf(uint256 tokenId) public view override returns (address) {
735         return _ownershipOf(tokenId).addr;
736     }
737 
738     /**
739      * @dev See {IERC721Metadata-name}.
740      */
741     function name() public view virtual override returns (string memory) {
742         return _name;
743     }
744 
745     /**
746      * @dev See {IERC721Metadata-symbol}.
747      */
748     function symbol() public view virtual override returns (string memory) {
749         return _symbol;
750     }
751 
752     /**
753      * @dev See {IERC721Metadata-tokenURI}.
754      */
755     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
756         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
757 
758         string memory baseURI = _baseURI();
759         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
760     }
761 
762     /**
763      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
764      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
765      * by default, can be overriden in child contracts.
766      */
767     function _baseURI() internal view virtual returns (string memory) {
768         return '';
769     }
770 
771     /**
772      * @dev See {IERC721-approve}.
773      */
774     function approve(address to, uint256 tokenId) public override {
775         address owner = ERC721A.ownerOf(tokenId);
776         if (to == owner) revert ApprovalToCurrentOwner();
777 
778         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
779             revert ApprovalCallerNotOwnerNorApproved();
780         }
781 
782         _tokenApprovals[tokenId] = to;
783         emit Approval(owner, to, tokenId);
784     }
785 
786     /**
787      * @dev See {IERC721-getApproved}.
788      */
789     function getApproved(uint256 tokenId) public view override returns (address) {
790         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
791 
792         return _tokenApprovals[tokenId];
793     }
794 
795     /**
796      * @dev See {IERC721-setApprovalForAll}.
797      */
798     function setApprovalForAll(address operator, bool approved) public virtual override {
799         if (operator == _msgSender()) revert ApproveToCaller();
800 
801         _operatorApprovals[_msgSender()][operator] = approved;
802         emit ApprovalForAll(_msgSender(), operator, approved);
803     }
804 
805     /**
806      * @dev See {IERC721-isApprovedForAll}.
807      */
808     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
809         return _operatorApprovals[owner][operator];
810     }
811 
812     /**
813      * @dev See {IERC721-transferFrom}.
814      */
815     function transferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) public virtual override {
820         _transfer(from, to, tokenId);
821     }
822 
823     /**
824      * @dev See {IERC721-safeTransferFrom}.
825      */
826     function safeTransferFrom(
827         address from,
828         address to,
829         uint256 tokenId
830     ) public virtual override {
831         safeTransferFrom(from, to, tokenId, '');
832     }
833 
834     /**
835      * @dev See {IERC721-safeTransferFrom}.
836      */
837     function safeTransferFrom(
838         address from,
839         address to,
840         uint256 tokenId,
841         bytes memory _data
842     ) public virtual override {
843         _transfer(from, to, tokenId);
844         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
845             revert TransferToNonERC721ReceiverImplementer();
846         }
847     }
848 
849     /**
850      * @dev Returns whether `tokenId` exists.
851      *
852      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
853      *
854      * Tokens start existing when they are minted (`_mint`),
855      */
856     function _exists(uint256 tokenId) internal view returns (bool) {
857         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
858     }
859 
860     /**
861      * @dev Equivalent to `_safeMint(to, quantity, '')`.
862      */
863     function _safeMint(address to, uint256 quantity) internal {
864         _safeMint(to, quantity, '');
865     }
866 
867     /**
868      * @dev Safely mints `quantity` tokens and transfers them to `to`.
869      *
870      * Requirements:
871      *
872      * - If `to` refers to a smart contract, it must implement
873      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
874      * - `quantity` must be greater than 0.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _safeMint(
879         address to,
880         uint256 quantity,
881         bytes memory _data
882     ) internal {
883         uint256 startTokenId = _currentIndex;
884         if (to == address(0)) revert MintToZeroAddress();
885         if (quantity == 0) revert MintZeroQuantity();
886 
887         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
888 
889         // Overflows are incredibly unrealistic.
890         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
891         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
892         unchecked {
893             _addressData[to].balance += uint64(quantity);
894             _addressData[to].numberMinted += uint64(quantity);
895 
896             _ownerships[startTokenId].addr = to;
897             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
898 
899             uint256 updatedIndex = startTokenId;
900             uint256 end = updatedIndex + quantity;
901 
902             if (to.isContract()) {
903                 do {
904                     emit Transfer(address(0), to, updatedIndex);
905                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
906                         revert TransferToNonERC721ReceiverImplementer();
907                     }
908                 } while (updatedIndex < end);
909                 // Reentrancy protection
910                 if (_currentIndex != startTokenId) revert();
911             } else {
912                 do {
913                     emit Transfer(address(0), to, updatedIndex++);
914                 } while (updatedIndex < end);
915             }
916             _currentIndex = updatedIndex;
917         }
918         _afterTokenTransfers(address(0), to, startTokenId, quantity);
919     }
920 
921     /**
922      * @dev Mints `quantity` tokens and transfers them to `to`.
923      *
924      * Requirements:
925      *
926      * - `to` cannot be the zero address.
927      * - `quantity` must be greater than 0.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _mint(address to, uint256 quantity) internal {
932         uint256 startTokenId = _currentIndex;
933         if (to == address(0)) revert MintToZeroAddress();
934         if (quantity == 0) revert MintZeroQuantity();
935 
936         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
937 
938         // Overflows are incredibly unrealistic.
939         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
940         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
941         unchecked {
942             _addressData[to].balance += uint64(quantity);
943             _addressData[to].numberMinted += uint64(quantity);
944 
945             _ownerships[startTokenId].addr = to;
946             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
947 
948             uint256 updatedIndex = startTokenId;
949             uint256 end = updatedIndex + quantity;
950 
951             do {
952                 emit Transfer(address(0), to, updatedIndex++);
953             } while (updatedIndex < end);
954 
955             _currentIndex = updatedIndex;
956         }
957         _afterTokenTransfers(address(0), to, startTokenId, quantity);
958     }
959 
960     /**
961      * @dev Transfers `tokenId` from `from` to `to`.
962      *
963      * Requirements:
964      *
965      * - `to` cannot be the zero address.
966      * - `tokenId` token must be owned by `from`.
967      *
968      * Emits a {Transfer} event.
969      */
970     function _transfer(
971         address from,
972         address to,
973         uint256 tokenId
974     ) private {
975         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
976 
977         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
978 
979         bool isApprovedOrOwner = (_msgSender() == from ||
980             isApprovedForAll(from, _msgSender()) ||
981             getApproved(tokenId) == _msgSender());
982 
983         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
984         if (to == address(0)) revert TransferToZeroAddress();
985 
986         _beforeTokenTransfers(from, to, tokenId, 1);
987 
988         // Clear approvals from the previous owner.
989         delete _tokenApprovals[tokenId];
990 
991         // Underflow of the sender's balance is impossible because we check for
992         // ownership above and the recipient's balance can't realistically overflow.
993         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
994         unchecked {
995             _addressData[from].balance -= 1;
996             _addressData[to].balance += 1;
997 
998             TokenOwnership storage currSlot = _ownerships[tokenId];
999             currSlot.addr = to;
1000             currSlot.startTimestamp = uint64(block.timestamp);
1001 
1002             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1003             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1004             uint256 nextTokenId = tokenId + 1;
1005             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1006             if (nextSlot.addr == address(0)) {
1007                 // This will suffice for checking _exists(nextTokenId),
1008                 // as a burned slot cannot contain the zero address.
1009                 if (nextTokenId != _currentIndex) {
1010                     nextSlot.addr = from;
1011                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1012                 }
1013             }
1014         }
1015 
1016         emit Transfer(from, to, tokenId);
1017         _afterTokenTransfers(from, to, tokenId, 1);
1018     }
1019 
1020     /**
1021      * @dev Equivalent to `_burn(tokenId, false)`.
1022      */
1023     function _burn(uint256 tokenId) internal virtual {
1024         _burn(tokenId, false);
1025     }
1026 
1027     /**
1028      * @dev Destroys `tokenId`.
1029      * The approval is cleared when the token is burned.
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must exist.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1038         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1039 
1040         address from = prevOwnership.addr;
1041 
1042         if (approvalCheck) {
1043             bool isApprovedOrOwner = (_msgSender() == from ||
1044                 isApprovedForAll(from, _msgSender()) ||
1045                 getApproved(tokenId) == _msgSender());
1046 
1047             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1048         }
1049 
1050         _beforeTokenTransfers(from, address(0), tokenId, 1);
1051 
1052         // Clear approvals from the previous owner.
1053         delete _tokenApprovals[tokenId];
1054 
1055         // Underflow of the sender's balance is impossible because we check for
1056         // ownership above and the recipient's balance can't realistically overflow.
1057         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1058         unchecked {
1059             AddressData storage addressData = _addressData[from];
1060             addressData.balance -= 1;
1061             addressData.numberBurned += 1;
1062 
1063             // Keep track of who burned the token, and the timestamp of burning.
1064             TokenOwnership storage currSlot = _ownerships[tokenId];
1065             currSlot.addr = from;
1066             currSlot.startTimestamp = uint64(block.timestamp);
1067             currSlot.burned = true;
1068 
1069             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1070             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1071             uint256 nextTokenId = tokenId + 1;
1072             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1073             if (nextSlot.addr == address(0)) {
1074                 // This will suffice for checking _exists(nextTokenId),
1075                 // as a burned slot cannot contain the zero address.
1076                 if (nextTokenId != _currentIndex) {
1077                     nextSlot.addr = from;
1078                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1079                 }
1080             }
1081         }
1082 
1083         emit Transfer(from, address(0), tokenId);
1084         _afterTokenTransfers(from, address(0), tokenId, 1);
1085 
1086         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1087         unchecked {
1088             _burnCounter++;
1089         }
1090     }
1091 
1092     /**
1093      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1094      *
1095      * @param from address representing the previous owner of the given token ID
1096      * @param to target address that will receive the tokens
1097      * @param tokenId uint256 ID of the token to be transferred
1098      * @param _data bytes optional data to send along with the call
1099      * @return bool whether the call correctly returned the expected magic value
1100      */
1101     function _checkContractOnERC721Received(
1102         address from,
1103         address to,
1104         uint256 tokenId,
1105         bytes memory _data
1106     ) private returns (bool) {
1107         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1108             return retval == IERC721Receiver(to).onERC721Received.selector;
1109         } catch (bytes memory reason) {
1110             if (reason.length == 0) {
1111                 revert TransferToNonERC721ReceiverImplementer();
1112             } else {
1113                 assembly {
1114                     revert(add(32, reason), mload(reason))
1115                 }
1116             }
1117         }
1118     }
1119 
1120     /**
1121      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1122      * And also called before burning one token.
1123      *
1124      * startTokenId - the first token id to be transferred
1125      * quantity - the amount to be transferred
1126      *
1127      * Calling conditions:
1128      *
1129      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1130      * transferred to `to`.
1131      * - When `from` is zero, `tokenId` will be minted for `to`.
1132      * - When `to` is zero, `tokenId` will be burned by `from`.
1133      * - `from` and `to` are never both zero.
1134      */
1135     function _beforeTokenTransfers(
1136         address from,
1137         address to,
1138         uint256 startTokenId,
1139         uint256 quantity
1140     ) internal virtual {}
1141 
1142     /**
1143      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1144      * minting.
1145      * And also called after one token has been burned.
1146      *
1147      * startTokenId - the first token id to be transferred
1148      * quantity - the amount to be transferred
1149      *
1150      * Calling conditions:
1151      *
1152      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1153      * transferred to `to`.
1154      * - When `from` is zero, `tokenId` has been minted for `to`.
1155      * - When `to` is zero, `tokenId` has been burned by `from`.
1156      * - `from` and `to` are never both zero.
1157      */
1158     function _afterTokenTransfers(
1159         address from,
1160         address to,
1161         uint256 startTokenId,
1162         uint256 quantity
1163     ) internal virtual {}
1164 }
1165 
1166 abstract contract ReentrancyGuard {
1167     // Booleans are more expensive than uint256 or any type that takes up a full
1168     // word because each write operation emits an extra SLOAD to first read the
1169     // slot's contents, replace the bits taken up by the boolean, and then write
1170     // back. This is the compiler's defense against contract upgrades and
1171     // pointer aliasing, and it cannot be disabled.
1172 
1173     // The values being non-zero value makes deployment a bit more expensive,
1174     // but in exchange the refund on every call to nonReentrant will be lower in
1175     // amount. Since refunds are capped to a percentage of the total
1176     // transaction's gas, it is best to keep them low in cases like this one, to
1177     // increase the likelihood of the full refund coming into effect.
1178     uint256 private constant _NOT_ENTERED = 1;
1179     uint256 private constant _ENTERED = 2;
1180 
1181     uint256 private _status;
1182 
1183     constructor() {
1184         _status = _NOT_ENTERED;
1185     }
1186 
1187     /**
1188      * @dev Prevents a contract from calling itself, directly or indirectly.
1189      * Calling a `nonReentrant` function from another `nonReentrant`
1190      * function is not supported. It is possible to prevent this from happening
1191      * by making the `nonReentrant` function external, and making it call a
1192      * `private` function that does the actual work.
1193      */
1194     modifier nonReentrant() {
1195         // On the first call to nonReentrant, _notEntered will be true
1196         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1197 
1198         // Any calls to nonReentrant after this point will fail
1199         _status = _ENTERED;
1200 
1201         _;
1202 
1203         // By storing the original value once again, a refund is triggered (see
1204         // https://eips.ethereum.org/EIPS/eip-2200)
1205         _status = _NOT_ENTERED;
1206     }
1207 }
1208 
1209 abstract contract Ownable is Context {
1210     address private _owner;
1211 
1212     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1213 
1214     /**
1215      * @dev Initializes the contract setting the deployer as the initial owner.
1216      */
1217     constructor() {
1218         _transferOwnership(_msgSender());
1219     }
1220 
1221     /**
1222      * @dev Returns the address of the current owner.
1223      */
1224     function owner() public view virtual returns (address) {
1225         return _owner;
1226     }
1227 
1228     /**
1229      * @dev Throws if called by any account other than the owner.
1230      */
1231     modifier onlyOwner() {
1232         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1233         _;
1234     }
1235 
1236     /**
1237      * @dev Leaves the contract without owner. It will not be possible to call
1238      * `onlyOwner` functions anymore. Can only be called by the current owner.
1239      *
1240      * NOTE: Renouncing ownership will leave the contract without an owner,
1241      * thereby removing any functionality that is only available to the owner.
1242      */
1243     function renounceOwnership() public virtual onlyOwner {
1244         _transferOwnership(address(0));
1245     }
1246 
1247     /**
1248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1249      * Can only be called by the current owner.
1250      */
1251     function transferOwnership(address newOwner) public virtual onlyOwner {
1252         require(newOwner != address(0), "Ownable: new owner is the zero address");
1253         _transferOwnership(newOwner);
1254     }
1255 
1256     /**
1257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1258      * Internal function without access restriction.
1259      */
1260     function _transferOwnership(address newOwner) internal virtual {
1261         address oldOwner = _owner;
1262         _owner = newOwner;
1263         emit OwnershipTransferred(oldOwner, newOwner);
1264     }
1265 }
1266 
1267 interface IERC721ABurnable is IERC721A {
1268     /**
1269      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1270      *
1271      * Requirements:
1272      *
1273      * - The caller must own `tokenId` or be an approved operator.
1274      */
1275     function burn(uint256 tokenId) external;
1276 }
1277 
1278 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1279     /**
1280      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1281      *
1282      * Requirements:
1283      *
1284      * - The caller must own `tokenId` or be an approved operator.
1285      */
1286     function burn(uint256 tokenId) public virtual override {
1287         _burn(tokenId, true);
1288     }
1289 }
1290 // --------------------------------------------------//
1291 
1292 contract Jeremy is Ownable, ERC721A, ReentrancyGuard, ERC721ABurnable {
1293   using Strings for uint256;
1294 
1295   uint256 public  PRICE = 0.075 ether;
1296   uint256 private constant TotalCollectionSize_ = 100000; // total number of nfts
1297   string private _baseTokenURI;
1298   uint public status = 2; //0-pause 2-public
1299   bool singleURI = true;
1300 
1301   constructor() ERC721A("Jeremy Knows","JK") {
1302     _baseTokenURI = "ipfs://QmdDoX1g8YFRGmes8aJFqtPxqZKqAFxZQtpRdzWWLVwa8j";
1303   }
1304 
1305   modifier callerIsUser() {
1306     require(tx.origin == msg.sender, "The caller is another contract");
1307     _;
1308   }
1309   function mint(uint256 quantity) external payable callerIsUser {
1310     require(status == 2 , "Public Sale is not Active");
1311     require(totalSupply() + quantity <= TotalCollectionSize_ , "reached max supply");
1312     require(msg.value >= PRICE * quantity, "Need to send more ETH.");
1313     _safeMint(msg.sender, quantity);  
1314   }
1315 
1316    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1317     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1318     string memory baseURI = _baseURI();
1319     if(singleURI)
1320     return
1321       bytes(baseURI).length > 0 ? baseURI : "";
1322     else
1323     return
1324       bytes(baseURI).length > 0
1325         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1326         : "";
1327   }
1328   function setBaseURI(string memory baseURI) external onlyOwner {
1329     _baseTokenURI = baseURI;
1330   }
1331   function _baseURI() internal view virtual override returns (string memory) {
1332     return _baseTokenURI;
1333   }
1334   function numberMinted(address owner) public view returns (uint256) {
1335     return _numberMinted(owner);
1336   }
1337   function getOwnershipData(uint256 tokenId)
1338     external
1339     view
1340     returns (TokenOwnership memory)
1341   {
1342     return _ownershipOf(tokenId);
1343   }
1344   function withdrawMoney() external onlyOwner nonReentrant {
1345     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1346     require(success, "Transfer failed.");
1347   }
1348   function changeMintPrice(uint256 _newPrice) external onlyOwner
1349   {
1350       PRICE = _newPrice;
1351   }
1352   function setStatus(uint256 status_)external onlyOwner{
1353       status = status_;
1354   }
1355   function giveaway(address address_, uint quantity_)public onlyOwner{
1356     // require(totalSupply() + quantity_ <= collectionSize, "reached max supply");
1357     _safeMint(address_, quantity_);
1358   }
1359   function _startTokenId() internal view override returns (uint256){
1360     return 1;
1361   }
1362   function setsingleURI(bool s) public onlyOwner{
1363       singleURI = s;
1364   }
1365 }