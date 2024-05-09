1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 /**
25  * @dev Required interface of an ERC721 compliant contract.
26  */
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
58      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
59      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
60      *
61      * Requirements:
62      *
63      * - `from` cannot be the zero address.
64      * - `to` cannot be the zero address.
65      * - `tokenId` token must exist and be owned by `from`.
66      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
67      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
68      *
69      * Emits a {Transfer} event.
70      */
71     function safeTransferFrom(
72         address from,
73         address to,
74         uint256 tokenId
75     ) external;
76 
77     /**
78      * @dev Transfers `tokenId` token from `from` to `to`.
79      *
80      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must be owned by `from`.
87      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(
92         address from,
93         address to,
94         uint256 tokenId
95     ) external;
96 
97     /**
98      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
99      * The approval is cleared when the token is transferred.
100      *
101      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
102      *
103      * Requirements:
104      *
105      * - The caller must own the token or be an approved operator.
106      * - `tokenId` must exist.
107      *
108      * Emits an {Approval} event.
109      */
110     function approve(address to, uint256 tokenId) external;
111 
112     /**
113      * @dev Returns the account approved for `tokenId` token.
114      *
115      * Requirements:
116      *
117      * - `tokenId` must exist.
118      */
119     function getApproved(uint256 tokenId) external view returns (address operator);
120 
121     /**
122      * @dev Approve or remove `operator` as an operator for the caller.
123      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
124      *
125      * Requirements:
126      *
127      * - The `operator` cannot be the caller.
128      *
129      * Emits an {ApprovalForAll} event.
130      */
131     function setApprovalForAll(address operator, bool _approved) external;
132 
133     /**
134      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
135      *
136      * See {setApprovalForAll}
137      */
138     function isApprovedForAll(address owner, address operator) external view returns (bool);
139 
140     /**
141      * @dev Safely transfers `tokenId` token from `from` to `to`.
142      *
143      * Requirements:
144      *
145      * - `from` cannot be the zero address.
146      * - `to` cannot be the zero address.
147      * - `tokenId` token must exist and be owned by `from`.
148      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
149      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
150      *
151      * Emits a {Transfer} event.
152      */
153     function safeTransferFrom(
154         address from,
155         address to,
156         uint256 tokenId,
157         bytes calldata data
158     ) external;
159 }
160 
161 interface IERC721Receiver {
162     /**
163      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
164      * by `operator` from `from`, this function is called.
165      *
166      * It must return its Solidity selector to confirm the token transfer.
167      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
168      *
169      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
170      */
171     function onERC721Received(
172         address operator,
173         address from,
174         uint256 tokenId,
175         bytes calldata data
176     ) external returns (bytes4);
177 }
178 
179 interface IERC721Metadata is IERC721 {
180     /**
181      * @dev Returns the token collection name.
182      */
183     function name() external view returns (string memory);
184 
185     /**
186      * @dev Returns the token collection symbol.
187      */
188     function symbol() external view returns (string memory);
189 
190     /**
191      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
192      */
193     function tokenURI(uint256 tokenId) external view returns (string memory);
194 }
195 
196 
197 /**
198  * @dev Collection of functions related to the address type
199  */
200 library Address {
201     /**
202      * @dev Returns true if `account` is a contract.
203      *
204      * [IMPORTANT]
205      * ====
206      * It is unsafe to assume that an address for which this function returns
207      * false is an externally-owned account (EOA) and not a contract.
208      *
209      * Among others, `isContract` will return false for the following
210      * types of addresses:
211      *
212      *  - an externally-owned account
213      *  - a contract in construction
214      *  - an address where a contract will be created
215      *  - an address where a contract lived, but was destroyed
216      * ====
217      *
218      * [IMPORTANT]
219      * ====
220      * You shouldn't rely on `isContract` to protect against flash loan attacks!
221      *
222      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
223      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
224      * constructor.
225      * ====
226      */
227     function isContract(address account) internal view returns (bool) {
228         // This method relies on extcodesize/address.code.length, which returns 0
229         // for contracts in construction, since the code is only stored at the end
230         // of the constructor execution.
231 
232         return account.code.length > 0;
233     }
234 
235     /**
236      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
237      * `recipient`, forwarding all available gas and reverting on errors.
238      *
239      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
240      * of certain opcodes, possibly making contracts go over the 2300 gas limit
241      * imposed by `transfer`, making them unable to receive funds via
242      * `transfer`. {sendValue} removes this limitation.
243      *
244      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
245      *
246      * IMPORTANT: because control is transferred to `recipient`, care must be
247      * taken to not create reentrancy vulnerabilities. Consider using
248      * {ReentrancyGuard} or the
249      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
250      */
251     function sendValue(address payable recipient, uint256 amount) internal {
252         require(address(this).balance >= amount, "Address: insufficient balance");
253 
254         (bool success, ) = recipient.call{value: amount}("");
255         require(success, "Address: unable to send value, recipient may have reverted");
256     }
257 
258     /**
259      * @dev Performs a Solidity function call using a low level `call`. A
260      * plain `call` is an unsafe replacement for a function call: use this
261      * function instead.
262      *
263      * If `target` reverts with a revert reason, it is bubbled up by this
264      * function (like regular Solidity function calls).
265      *
266      * Returns the raw returned data. To convert to the expected return value,
267      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
268      *
269      * Requirements:
270      *
271      * - `target` must be a contract.
272      * - calling `target` with `data` must not revert.
273      *
274      * _Available since v3.1._
275      */
276     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
277         return functionCall(target, data, "Address: low-level call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
282      * `errorMessage` as a fallback revert reason when `target` reverts.
283      *
284      * _Available since v3.1._
285      */
286     function functionCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, 0, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but also transferring `value` wei to `target`.
297      *
298      * Requirements:
299      *
300      * - the calling contract must have an ETH balance of at least `value`.
301      * - the called Solidity function must be `payable`.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
315      * with `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCallWithValue(
320         address target,
321         bytes memory data,
322         uint256 value,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         require(address(this).balance >= value, "Address: insufficient balance for call");
326         require(isContract(target), "Address: call to non-contract");
327 
328         (bool success, bytes memory returndata) = target.call{value: value}(data);
329         return verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
339         return functionStaticCall(target, data, "Address: low-level static call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a static call.
345      *
346      * _Available since v3.3._
347      */
348     function functionStaticCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal view returns (bytes memory) {
353         require(isContract(target), "Address: static call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.staticcall(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a delegate call.
362      *
363      * _Available since v3.4._
364      */
365     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
366         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a delegate call.
372      *
373      * _Available since v3.4._
374      */
375     function functionDelegateCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         require(isContract(target), "Address: delegate call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.delegatecall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
388      * revert reason using the provided one.
389      *
390      * _Available since v4.3._
391      */
392     function verifyCallResult(
393         bool success,
394         bytes memory returndata,
395         string memory errorMessage
396     ) internal pure returns (bytes memory) {
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403 
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 
416 pragma solidity ^0.8.0;
417 
418 /**
419  * @dev Provides information about the current execution context, including the
420  * sender of the transaction and its data. While these are generally available
421  * via msg.sender and msg.data, they should not be accessed in such a direct
422  * manner, since when dealing with meta-transactions the account sending and
423  * paying for execution may not be the actual sender (as far as an application
424  * is concerned).
425  *
426  * This contract is only required for intermediate, library-like contracts.
427  */
428 abstract contract Context {
429     function _msgSender() internal view virtual returns (address) {
430         return msg.sender;
431     }
432 
433     function _msgData() internal view virtual returns (bytes calldata) {
434         return msg.data;
435     }
436 }
437 
438 
439 /**
440  * @dev String operations.
441  */
442 library Strings {
443     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
444 
445     /**
446      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
447      */
448     function toString(uint256 value) internal pure returns (string memory) {
449         // Inspired by OraclizeAPI's implementation - MIT licence
450         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
451 
452         if (value == 0) {
453             return "0";
454         }
455         uint256 temp = value;
456         uint256 digits;
457         while (temp != 0) {
458             digits++;
459             temp /= 10;
460         }
461         bytes memory buffer = new bytes(digits);
462         while (value != 0) {
463             digits -= 1;
464             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
465             value /= 10;
466         }
467         return string(buffer);
468     }
469 
470     /**
471      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
472      */
473     function toHexString(uint256 value) internal pure returns (string memory) {
474         if (value == 0) {
475             return "0x00";
476         }
477         uint256 temp = value;
478         uint256 length = 0;
479         while (temp != 0) {
480             length++;
481             temp >>= 8;
482         }
483         return toHexString(value, length);
484     }
485 
486     /**
487      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
488      */
489     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
490         bytes memory buffer = new bytes(2 * length + 2);
491         buffer[0] = "0";
492         buffer[1] = "x";
493         for (uint256 i = 2 * length + 1; i > 1; --i) {
494             buffer[i] = _HEX_SYMBOLS[value & 0xf];
495             value >>= 4;
496         }
497         require(value == 0, "Strings: hex length insufficient");
498         return string(buffer);
499     }
500 }
501 
502 /**
503  * @dev Implementation of the {IERC165} interface.
504  *
505  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
506  * for the additional interface id that will be supported. For example:
507  *
508  * ```solidity
509  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
510  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
511  * }
512  * ```
513  *
514  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
515  */
516 abstract contract ERC165 is IERC165 {
517     /**
518      * @dev See {IERC165-supportsInterface}.
519      */
520     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
521         return interfaceId == type(IERC165).interfaceId;
522     }
523 }
524 
525 /**
526  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
527  * the Metadata extension, but not including the Enumerable extension, which is available separately as
528  * {ERC721Enumerable}.
529  */
530 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
531     using Address for address;
532     using Strings for uint256;
533 
534     // Token name
535     string private _name;
536 
537     // Token symbol
538     string private _symbol;
539 
540     string private baseURI = "";
541 
542     // Mapping from token ID to owner address
543     mapping(uint256 => address) private _owners;
544 
545     // Mapping owner address to token count
546     mapping(address => uint256) private _balances;
547 
548     // Mapping from token ID to approved address
549     mapping(uint256 => address) private _tokenApprovals;
550 
551     // Mapping from owner to operator approvals
552     mapping(address => mapping(address => bool)) private _operatorApprovals;
553 
554     /**
555      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
556      */
557     constructor(string memory name_, string memory symbol_) {
558         _name = name_;
559         _symbol = symbol_;
560     }
561 
562     /**
563      * @dev See {IERC165-supportsInterface}.
564      */
565     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
566         return
567             interfaceId == type(IERC721).interfaceId ||
568             interfaceId == type(IERC721Metadata).interfaceId ||
569             super.supportsInterface(interfaceId);
570     }
571 
572     /**
573      * @dev See {IERC721-balanceOf}.
574      */
575     function balanceOf(address owner) public view virtual override returns (uint256) {
576         require(owner != address(0), "ERC721: balance query for the zero address");
577         return _balances[owner];
578     }
579 
580     /**
581      * @dev See {IERC721-ownerOf}.
582      */
583     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
584         address owner = _owners[tokenId];
585         require(owner != address(0), "ERC721: owner query for nonexistent token");
586         return owner;
587     }
588 
589     /**
590      * @dev See {IERC721Metadata-name}.
591      */
592     function name() public view virtual override returns (string memory) {
593         return _name;
594     }
595 
596     /**
597      * @dev See {IERC721Metadata-symbol}.
598      */
599     function symbol() public view virtual override returns (string memory) {
600         return _symbol;
601     }
602 
603     /**
604      * @dev See {IERC721Metadata-tokenURI}.
605      */
606     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
607         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
608 
609         string memory _baseURI = baseURI;
610         return bytes(_baseURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenId.toString())) : "";
611     }
612 
613     /**
614      * @dev See {IERC721-approve}.
615      */
616     function approve(address to, uint256 tokenId) public virtual override {
617         address owner = ERC721.ownerOf(tokenId);
618         require(to != owner, "ERC721: approval to current owner");
619 
620         require(
621             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
622             "ERC721: approve caller is not owner nor approved for all"
623         );
624 
625         _approve(to, tokenId);
626     }
627 
628     /**
629      * @dev See {IERC721-getApproved}.
630      */
631     function getApproved(uint256 tokenId) public view virtual override returns (address) {
632         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
633 
634         return _tokenApprovals[tokenId];
635     }
636 
637     /**
638      * @dev See {IERC721-setApprovalForAll}.
639      */
640     function setApprovalForAll(address operator, bool approved) public virtual override {
641         _setApprovalForAll(_msgSender(), operator, approved);
642     }
643 
644     /**
645      * @dev See {IERC721-isApprovedForAll}.
646      */
647     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
648         return _operatorApprovals[owner][operator];
649     }
650 
651     /**
652      * @dev See {IERC721-transferFrom}.
653      */
654     function transferFrom(
655         address from,
656         address to,
657         uint256 tokenId
658     ) public virtual override {
659         //solhint-disable-next-line max-line-length
660         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
661 
662         _transfer(from, to, tokenId);
663     }
664 
665     /**
666      * @dev See {IERC721-safeTransferFrom}.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) public virtual override {
673         safeTransferFrom(from, to, tokenId, "");
674     }
675 
676     /**
677      * @dev See {IERC721-safeTransferFrom}.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId,
683         bytes memory _data
684     ) public virtual override {
685         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
686         _safeTransfer(from, to, tokenId, _data);
687     }
688 
689     /**
690      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
691      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
692      *
693      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
694      *
695      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
696      * implement alternative mechanisms to perform token transfer, such as signature-based.
697      *
698      * Requirements:
699      *
700      * - `from` cannot be the zero address.
701      * - `to` cannot be the zero address.
702      * - `tokenId` token must exist and be owned by `from`.
703      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
704      *
705      * Emits a {Transfer} event.
706      */
707     function _safeTransfer(
708         address from,
709         address to,
710         uint256 tokenId,
711         bytes memory _data
712     ) internal virtual {
713         _transfer(from, to, tokenId);
714         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
715     }
716 
717     /**
718      * @dev Returns whether `tokenId` exists.
719      *
720      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
721      *
722      * Tokens start existing when they are minted (`_mint`),
723      * and stop existing when they are burned (`_burn`).
724      */
725     function _exists(uint256 tokenId) internal view virtual returns (bool) {
726         return _owners[tokenId] != address(0);
727     }
728 
729     /**
730      * @dev Returns whether `spender` is allowed to manage `tokenId`.
731      *
732      * Requirements:
733      *
734      * - `tokenId` must exist.
735      */
736     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
737         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
738         address owner = ERC721.ownerOf(tokenId);
739         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
740     }
741 
742     /**
743      * @dev Safely mints `tokenId` and transfers it to `to`.
744      *
745      * Requirements:
746      *
747      * - `tokenId` must not exist.
748      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
749      *
750      * Emits a {Transfer} event.
751      */
752     function _safeMint(address to, uint256 tokenId) internal virtual {
753         _safeMint(to, tokenId, "");
754     }
755 
756     /**
757      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
758      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
759      */
760     function _safeMint(
761         address to,
762         uint256 tokenId,
763         bytes memory _data
764     ) internal virtual {
765         _mint(to, tokenId);
766         require(
767             _checkOnERC721Received(address(0), to, tokenId, _data),
768             "ERC721: transfer to non ERC721Receiver implementer"
769         );
770     }
771 
772     /**
773      * @dev Mints `tokenId` and transfers it to `to`.
774      *
775      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
776      *
777      * Requirements:
778      *
779      * - `tokenId` must not exist.
780      * - `to` cannot be the zero address.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _mint(address to, uint256 tokenId) internal virtual {
785         require(to != address(0), "ERC721: mint to the zero address");
786         require(!_exists(tokenId), "ERC721: token already minted");
787 
788         _beforeTokenTransfer(address(0), to, tokenId);
789 
790         _balances[to] += 1;
791         _owners[tokenId] = to;
792 
793         emit Transfer(address(0), to, tokenId);
794 
795         _afterTokenTransfer(address(0), to, tokenId);
796     }
797 
798     /**
799      * @dev Destroys `tokenId`.
800      * The approval is cleared when the token is burned.
801      *
802      * Requirements:
803      *
804      * - `tokenId` must exist.
805      *
806      * Emits a {Transfer} event.
807      */
808     function _burn(uint256 tokenId) internal virtual {
809         address owner = ERC721.ownerOf(tokenId);
810 
811         _beforeTokenTransfer(owner, address(0), tokenId);
812 
813         // Clear approvals
814         _approve(address(0), tokenId);
815 
816         _balances[owner] -= 1;
817         delete _owners[tokenId];
818 
819         emit Transfer(owner, address(0), tokenId);
820 
821         _afterTokenTransfer(owner, address(0), tokenId);
822     }
823 
824     /**
825      * @dev Transfers `tokenId` from `from` to `to`.
826      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
827      *
828      * Requirements:
829      *
830      * - `to` cannot be the zero address.
831      * - `tokenId` token must be owned by `from`.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _transfer(
836         address from,
837         address to,
838         uint256 tokenId
839     ) internal virtual {
840         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
841         require(to != address(0), "ERC721: transfer to the zero address");
842 
843         _beforeTokenTransfer(from, to, tokenId);
844 
845         // Clear approvals from the previous owner
846         _approve(address(0), tokenId);
847 
848         _balances[from] -= 1;
849         _balances[to] += 1;
850         _owners[tokenId] = to;
851 
852         emit Transfer(from, to, tokenId);
853 
854         _afterTokenTransfer(from, to, tokenId);
855     }
856 
857     /**
858      * @dev Approve `to` to operate on `tokenId`
859      *
860      * Emits a {Approval} event.
861      */
862     function _approve(address to, uint256 tokenId) internal virtual {
863         _tokenApprovals[tokenId] = to;
864         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
865     }
866 
867     /**
868      * @dev Approve `operator` to operate on all of `owner` tokens
869      *
870      * Emits a {ApprovalForAll} event.
871      */
872     function _setApprovalForAll(
873         address owner,
874         address operator,
875         bool approved
876     ) internal virtual {
877         require(owner != operator, "ERC721: approve to caller");
878         _operatorApprovals[owner][operator] = approved;
879         emit ApprovalForAll(owner, operator, approved);
880     }
881 
882     /**
883      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
884      * The call is not executed if the target address is not a contract.
885      *
886      * @param from address representing the previous owner of the given token ID
887      * @param to target address that will receive the tokens
888      * @param tokenId uint256 ID of the token to be transferred
889      * @param _data bytes optional data to send along with the call
890      * @return bool whether the call correctly returned the expected magic value
891      */
892     function _checkOnERC721Received(
893         address from,
894         address to,
895         uint256 tokenId,
896         bytes memory _data
897     ) private returns (bool) {
898         if (to.isContract()) {
899             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
900                 return retval == IERC721Receiver.onERC721Received.selector;
901             } catch (bytes memory reason) {
902                 if (reason.length == 0) {
903                     revert("ERC721: transfer to non ERC721Receiver implementer");
904                 } else {
905                     assembly {
906                         revert(add(32, reason), mload(reason))
907                     }
908                 }
909             }
910         } else {
911             return true;
912         }
913     }
914 
915     /**
916      * @dev Hook that is called before any token transfer. This includes minting
917      * and burning.
918      *
919      * Calling conditions:
920      *
921      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
922      * transferred to `to`.
923      * - When `from` is zero, `tokenId` will be minted for `to`.
924      * - When `to` is zero, ``from``'s `tokenId` will be burned.
925      * - `from` and `to` are never both zero.
926      *
927      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
928      */
929     function _beforeTokenTransfer(
930         address from,
931         address to,
932         uint256 tokenId
933     ) internal virtual {}
934 
935     /**
936      * @dev Hook that is called after any transfer of tokens. This includes
937      * minting and burning.
938      *
939      * Calling conditions:
940      *
941      * - when `from` and `to` are both non-zero.
942      * - `from` and `to` are never both zero.
943      *
944      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
945      */
946     function _afterTokenTransfer(
947         address from,
948         address to,
949         uint256 tokenId
950     ) internal virtual {}
951 
952 
953     function _setBaseURI(string memory baseURI_) internal {
954         baseURI = baseURI_;
955     }
956 }
957 
958 
959 /**
960  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
961  * @dev See https://eips.ethereum.org/EIPS/eip-721
962  */
963 interface IERC721Enumerable is IERC721 {
964     /**
965      * @dev Returns the total amount of tokens stored by the contract.
966      */
967     function totalSupply() external view returns (uint256);
968 
969     /**
970      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
971      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
972      */
973     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
974 
975     /**
976      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
977      * Use along with {totalSupply} to enumerate all tokens.
978      */
979     function tokenByIndex(uint256 index) external view returns (uint256);
980 }
981 
982 
983 
984 /**
985  * @title ERC721 Burnable Token
986  * @dev ERC721 Token that can be irreversibly burned (destroyed).
987  */
988 abstract contract ERC721Burnable is Context, ERC721 {
989     /**
990      * @dev Burns `tokenId`. See {ERC721-_burn}.
991      *
992      * Requirements:
993      *
994      * - The caller must own `tokenId` or be an approved operator.
995      */
996     function burn(uint256 tokenId) public virtual {
997         //solhint-disable-next-line max-line-length
998         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
999         _burn(tokenId);
1000     }
1001 }
1002 
1003 /**
1004  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1005  * enumerability of all the token ids in the contract as well as all token ids owned by each
1006  * account.
1007  */
1008 abstract contract ERC721Enumerable is ERC721Burnable, IERC721Enumerable {
1009     // Mapping from owner to list of owned token IDs
1010     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1011 
1012     // Mapping from token ID to index of the owner tokens list
1013     mapping(uint256 => uint256) private _ownedTokensIndex;
1014 
1015     // Array with all token ids, used for enumeration
1016     uint256[] private _allTokens;
1017 
1018     // Mapping from token id to position in the allTokens array
1019     mapping(uint256 => uint256) private _allTokensIndex;
1020 
1021     /**
1022      * @dev See {IERC165-supportsInterface}.
1023      */
1024     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1025         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1030      */
1031     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1032         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1033         return _ownedTokens[owner][index];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Enumerable-totalSupply}.
1038      */
1039     function totalSupply() public view virtual override returns (uint256) {
1040         return _allTokens.length;
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Enumerable-tokenByIndex}.
1045      */
1046     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1047         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1048         return _allTokens[index];
1049     }
1050 
1051     /**
1052      * @dev Hook that is called before any token transfer. This includes minting
1053      * and burning.
1054      *
1055      * Calling conditions:
1056      *
1057      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1058      * transferred to `to`.
1059      * - When `from` is zero, `tokenId` will be minted for `to`.
1060      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1061      * - `from` cannot be the zero address.
1062      * - `to` cannot be the zero address.
1063      *
1064      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1065      */
1066     function _beforeTokenTransfer(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) internal virtual override {
1071         super._beforeTokenTransfer(from, to, tokenId);
1072 
1073         if (from == address(0)) {
1074             _addTokenToAllTokensEnumeration(tokenId);
1075         } else if (from != to) {
1076             _removeTokenFromOwnerEnumeration(from, tokenId);
1077         }
1078         if (to == address(0)) {
1079             _removeTokenFromAllTokensEnumeration(tokenId);
1080         } else if (to != from) {
1081             _addTokenToOwnerEnumeration(to, tokenId);
1082         }
1083     }
1084 
1085     /**
1086      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1087      * @param to address representing the new owner of the given token ID
1088      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1089      */
1090     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1091         uint256 length = ERC721.balanceOf(to);
1092         _ownedTokens[to][length] = tokenId;
1093         _ownedTokensIndex[tokenId] = length;
1094     }
1095 
1096     /**
1097      * @dev Private function to add a token to this extension's token tracking data structures.
1098      * @param tokenId uint256 ID of the token to be added to the tokens list
1099      */
1100     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1101         _allTokensIndex[tokenId] = _allTokens.length;
1102         _allTokens.push(tokenId);
1103     }
1104 
1105     /**
1106      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1107      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1108      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1109      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1110      * @param from address representing the previous owner of the given token ID
1111      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1112      */
1113     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1114         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1115         // then delete the last slot (swap and pop).
1116 
1117         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1118         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1119 
1120         // When the token to delete is the last token, the swap operation is unnecessary
1121         if (tokenIndex != lastTokenIndex) {
1122             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1123 
1124             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1125             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1126         }
1127 
1128         // This also deletes the contents at the last position of the array
1129         delete _ownedTokensIndex[tokenId];
1130         delete _ownedTokens[from][lastTokenIndex];
1131     }
1132 
1133     /**
1134      * @dev Private function to remove a token from this extension's token tracking data structures.
1135      * This has O(1) time complexity, but alters the order of the _allTokens array.
1136      * @param tokenId uint256 ID of the token to be removed from the tokens list
1137      */
1138     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1139         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1140         // then delete the last slot (swap and pop).
1141 
1142         uint256 lastTokenIndex = _allTokens.length - 1;
1143         uint256 tokenIndex = _allTokensIndex[tokenId];
1144 
1145         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1146         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1147         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1148         uint256 lastTokenId = _allTokens[lastTokenIndex];
1149 
1150         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1151         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1152 
1153         // This also deletes the contents at the last position of the array
1154         delete _allTokensIndex[tokenId];
1155         _allTokens.pop();
1156     }
1157 }
1158 
1159 /**
1160  * @dev Contract module which provides a basic access control mechanism, where
1161  * there is an account (an owner) that can be granted exclusive access to
1162  * specific functions.
1163  *
1164  * By default, the owner account will be the one that deploys the contract. This
1165  * can later be changed with {transferOwnership}.
1166  *
1167  * This module is used through inheritance. It will make available the modifier
1168  * `onlyOwner`, which can be applied to your functions to restrict their use to
1169  * the owner.
1170  */
1171 abstract contract Ownable is Context {
1172     address private _owner;
1173 
1174     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1175 
1176     /**
1177      * @dev Initializes the contract setting the deployer as the initial owner.
1178      */
1179     constructor() {
1180         _transferOwnership(_msgSender());
1181     }
1182 
1183     /**
1184      * @dev Returns the address of the current owner.
1185      */
1186     function owner() public view virtual returns (address) {
1187         return _owner;
1188     }
1189 
1190     /**
1191      * @dev Throws if called by any account other than the owner.
1192      */
1193     modifier onlyOwner() {
1194         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1195         _;
1196     }
1197 
1198     /**
1199      * @dev Leaves the contract without owner. It will not be possible to call
1200      * `onlyOwner` functions anymore. Can only be called by the current owner.
1201      *
1202      * NOTE: Renouncing ownership will leave the contract without an owner,
1203      * thereby removing any functionality that is only available to the owner.
1204      */
1205     function renounceOwnership() public virtual onlyOwner {
1206         _transferOwnership(address(0));
1207     }
1208 
1209     /**
1210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1211      * Can only be called by the current owner.
1212      */
1213     function transferOwnership(address newOwner) public virtual onlyOwner {
1214         require(newOwner != address(0), "Ownable: new owner is the zero address");
1215         _transferOwnership(newOwner);
1216     }
1217 
1218     /**
1219      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1220      * Internal function without access restriction.
1221      */
1222     function _transferOwnership(address newOwner) internal virtual {
1223         address oldOwner = _owner;
1224         _owner = newOwner;
1225         emit OwnershipTransferred(oldOwner, newOwner);
1226     }
1227 }
1228 
1229 /**
1230  * @dev Wrappers over Solidity's arithmetic operations.
1231  *
1232  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1233  * now has built in overflow checking.
1234  */
1235  library SafeMath {
1236     /**
1237      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1238      *
1239      * _Available since v3.4._
1240      */
1241     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1242         unchecked {
1243             uint256 c = a + b;
1244             if (c < a) return (false, 0);
1245             return (true, c);
1246         }
1247     }
1248 
1249     /**
1250      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1251      *
1252      * _Available since v3.4._
1253      */
1254     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1255         unchecked {
1256             if (b > a) return (false, 0);
1257             return (true, a - b);
1258         }
1259     }
1260 
1261     /**
1262      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1263      *
1264      * _Available since v3.4._
1265      */
1266     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1267         unchecked {
1268             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1269             // benefit is lost if 'b' is also tested.
1270             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1271             if (a == 0) return (true, 0);
1272             uint256 c = a * b;
1273             if (c / a != b) return (false, 0);
1274             return (true, c);
1275         }
1276     }
1277 
1278     /**
1279      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1280      *
1281      * _Available since v3.4._
1282      */
1283     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1284         unchecked {
1285             if (b == 0) return (false, 0);
1286             return (true, a / b);
1287         }
1288     }
1289 
1290     /**
1291      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1292      *
1293      * _Available since v3.4._
1294      */
1295     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1296         unchecked {
1297             if (b == 0) return (false, 0);
1298             return (true, a % b);
1299         }
1300     }
1301 
1302     /**
1303      * @dev Returns the addition of two unsigned integers, reverting on
1304      * overflow.
1305      *
1306      * Counterpart to Solidity's `+` operator.
1307      *
1308      * Requirements:
1309      *
1310      * - Addition cannot overflow.
1311      */
1312     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1313         return a + b;
1314     }
1315 
1316     /**
1317      * @dev Returns the subtraction of two unsigned integers, reverting on
1318      * overflow (when the result is negative).
1319      *
1320      * Counterpart to Solidity's `-` operator.
1321      *
1322      * Requirements:
1323      *
1324      * - Subtraction cannot overflow.
1325      */
1326     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1327         return a - b;
1328     }
1329 
1330     /**
1331      * @dev Returns the multiplication of two unsigned integers, reverting on
1332      * overflow.
1333      *
1334      * Counterpart to Solidity's `*` operator.
1335      *
1336      * Requirements:
1337      *
1338      * - Multiplication cannot overflow.
1339      */
1340     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1341         return a * b;
1342     }
1343 
1344     /**
1345      * @dev Returns the integer division of two unsigned integers, reverting on
1346      * division by zero. The result is rounded towards zero.
1347      *
1348      * Counterpart to Solidity's `/` operator.
1349      *
1350      * Requirements:
1351      *
1352      * - The divisor cannot be zero.
1353      */
1354     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1355         return a / b;
1356     }
1357 
1358     /**
1359      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1360      * reverting when dividing by zero.
1361      *
1362      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1363      * opcode (which leaves remaining gas untouched) while Solidity uses an
1364      * invalid opcode to revert (consuming all remaining gas).
1365      *
1366      * Requirements:
1367      *
1368      * - The divisor cannot be zero.
1369      */
1370     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1371         return a % b;
1372     }
1373 
1374     /**
1375      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1376      * overflow (when the result is negative).
1377      *
1378      * CAUTION: This function is deprecated because it requires allocating memory for the error
1379      * message unnecessarily. For custom revert reasons use {trySub}.
1380      *
1381      * Counterpart to Solidity's `-` operator.
1382      *
1383      * Requirements:
1384      *
1385      * - Subtraction cannot overflow.
1386      */
1387     function sub(
1388         uint256 a,
1389         uint256 b,
1390         string memory errorMessage
1391     ) internal pure returns (uint256) {
1392         unchecked {
1393             require(b <= a, errorMessage);
1394             return a - b;
1395         }
1396     }
1397 
1398     /**
1399      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1400      * division by zero. The result is rounded towards zero.
1401      *
1402      * Counterpart to Solidity's `/` operator. Note: this function uses a
1403      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1404      * uses an invalid opcode to revert (consuming all remaining gas).
1405      *
1406      * Requirements:
1407      *
1408      * - The divisor cannot be zero.
1409      */
1410     function div(
1411         uint256 a,
1412         uint256 b,
1413         string memory errorMessage
1414     ) internal pure returns (uint256) {
1415         unchecked {
1416             require(b > 0, errorMessage);
1417             return a / b;
1418         }
1419     }
1420 
1421     /**
1422      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1423      * reverting with custom message when dividing by zero.
1424      *
1425      * CAUTION: This function is deprecated because it requires allocating memory for the error
1426      * message unnecessarily. For custom revert reasons use {tryMod}.
1427      *
1428      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1429      * opcode (which leaves remaining gas untouched) while Solidity uses an
1430      * invalid opcode to revert (consuming all remaining gas).
1431      *
1432      * Requirements:
1433      *
1434      * - The divisor cannot be zero.
1435      */
1436     function mod(
1437         uint256 a,
1438         uint256 b,
1439         string memory errorMessage
1440     ) internal pure returns (uint256) {
1441         unchecked {
1442             require(b > 0, errorMessage);
1443             return a % b;
1444         }
1445     }
1446 }
1447 
1448 contract TheWombats is Context, ERC721Enumerable, Ownable {
1449 
1450     using SafeMath for uint256;
1451  
1452     uint256 public PRICE = 0.07 ether;
1453 
1454     uint256 public MAX_PURCHASE = 20;
1455 
1456     uint256 public constant MAX_TOKENS = 3000;
1457 
1458     mapping (address => uint256) public whitelistMinted;
1459 
1460     address public WHITELIST_SIGNER;
1461 
1462     bool public saleIsActive = false;
1463 
1464     constructor () ERC721("The Wombats", "TW") {}
1465 
1466     /* function to change de price */ 
1467     function changePrice(uint256 price) public onlyOwner {
1468         PRICE = price;
1469     }
1470 
1471     /* function to change the max quantity to mint in one transaction */
1472     function changeMaxPurchase(uint256 max) public onlyOwner {
1473         MAX_PURCHASE = max;
1474     }
1475 
1476     function withdraw() public onlyOwner {
1477         address payable sender = payable(_msgSender());
1478         uint balance = address(this).balance;
1479         sender.transfer(balance);
1480     }
1481 
1482     function setWhiteListSigner(address signer) public onlyOwner {
1483         WHITELIST_SIGNER = signer;
1484     }
1485 
1486     function toggleSale() public onlyOwner {
1487         saleIsActive = !saleIsActive;
1488     }
1489 
1490     /**
1491      * Set some Wombats
1492      */
1493     function reserve() public onlyOwner {     
1494         require(saleIsActive == false, "Impossible reserve a Wombat when sale is active");   
1495         uint supply = totalSupply();
1496         for (uint i = 0; i < 20; i++) {
1497             _safeMint(_msgSender(), supply + i);
1498         }
1499     }
1500 
1501 
1502     /**
1503     * Whitelist Mint
1504     */
1505     function preMint(uint256 numberOfTokens, uint max, bytes memory signature) public payable {
1506         bytes32 hash;
1507         require(WHITELIST_SIGNER != address(0), "Pre-Mint is not available yet");
1508         require(saleIsActive == false, "Impossible Pre-Mint a Wombat when sale is active");   
1509         require(numberOfTokens <= MAX_PURCHASE, "Exceed the number of tokens able to mint");
1510         require(totalSupply() < MAX_TOKENS, "Sold Out");
1511         require(PRICE.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1512 
1513         /*
1514          * keccak256(address,number);
1515          */
1516         hash = keccak256(abi.encodePacked(_msgSender(), max));
1517 
1518         /*
1519          * Check Signature
1520          */ 
1521         require(recover(hash,signature) == WHITELIST_SIGNER, "Invalid Signature");
1522 
1523         /*
1524          * Check max min reached
1525          */ 
1526         require(whitelistMinted[_msgSender()].add(numberOfTokens) <= max, "Max mint reached");
1527 
1528         /*
1529          * Update total minted in preMint state
1530          */
1531         whitelistMinted[_msgSender()] = whitelistMinted[_msgSender()].add(numberOfTokens);
1532 
1533         uint supply = totalSupply();
1534         for(uint i = 0; i < numberOfTokens; i++) {
1535             _safeMint(_msgSender(), supply+i);
1536         }
1537     }
1538 
1539 
1540     /**
1541     * Mint Wombat
1542     */
1543     function mint(uint256 numberOfTokens) public payable {
1544         uint256 ret;
1545         require(saleIsActive, "Sale must be active to mint The Wombat");
1546         require(numberOfTokens <= MAX_PURCHASE, "Exceed the number of tokens able to mint");
1547         require(PRICE.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1548         require(totalSupply() < MAX_TOKENS, "Sold out");
1549         
1550         for(uint i = 0; i < numberOfTokens; i++) {
1551             uint mintIndex = totalSupply();
1552             if (totalSupply() < MAX_TOKENS) {
1553                 _safeMint(_msgSender(), mintIndex);
1554             } else {
1555                 ret = ret.add(1);
1556             }
1557         }
1558         if (ret > 0) {
1559             address payable sender = payable(_msgSender());
1560             sender.transfer(PRICE.mul(ret));
1561         }
1562     }
1563 
1564 
1565 
1566     function setBaseURI(string memory baseURI) public onlyOwner {
1567         _setBaseURI(baseURI);
1568     }
1569 
1570 
1571     function recover(bytes32 _hash, bytes memory _signed) internal pure returns(address) {
1572         bytes32 r;
1573         bytes32 s;
1574         uint8 v;
1575         
1576         assembly {
1577             r:= mload(add(_signed,32))
1578             s:= mload(add(_signed,64))
1579             v:= and(mload(add(_signed,65)) ,255)
1580         }
1581         return ecrecover(_hash,v,r,s);
1582     } 
1583 }