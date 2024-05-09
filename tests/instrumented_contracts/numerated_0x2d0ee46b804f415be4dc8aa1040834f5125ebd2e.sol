1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 
28 
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
64      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must exist and be owned by `from`.
71      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
72      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
73      *
74      * Emits a {Transfer} event.
75      */
76     function safeTransferFrom(
77         address from,
78         address to,
79         uint256 tokenId
80     ) external;
81 
82     /**
83      * @dev Transfers `tokenId` token from `from` to `to`.
84      *
85      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
104      * The approval is cleared when the token is transferred.
105      *
106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
107      *
108      * Requirements:
109      *
110      * - The caller must own the token or be an approved operator.
111      * - `tokenId` must exist.
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Returns the account approved for `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function getApproved(uint256 tokenId) external view returns (address operator);
125 
126     /**
127      * @dev Approve or remove `operator` as an operator for the caller.
128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
129      *
130      * Requirements:
131      *
132      * - The `operator` cannot be the caller.
133      *
134      * Emits an {ApprovalForAll} event.
135      */
136     function setApprovalForAll(address operator, bool _approved) external;
137 
138     /**
139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
140      *
141      * See {setApprovalForAll}
142      */
143     function isApprovedForAll(address owner, address operator) external view returns (bool);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId,
162         bytes calldata data
163     ) external;
164 }
165 
166 
167 
168 
169 /**
170  * @title ERC721 token receiver interface
171  * @dev Interface for any contract that wants to support safeTransfers
172  * from ERC721 asset contracts.
173  */
174 interface IERC721Receiver {
175     /**
176      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
177      * by `operator` from `from`, this function is called.
178      *
179      * It must return its Solidity selector to confirm the token transfer.
180      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
181      *
182      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
183      */
184     function onERC721Received(
185         address operator,
186         address from,
187         uint256 tokenId,
188         bytes calldata data
189     ) external returns (bytes4);
190 }
191 
192 
193 
194 
195 
196 /**
197  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
198  * @dev See https://eips.ethereum.org/EIPS/eip-721
199  */
200 interface IERC721Metadata is IERC721 {
201     /**
202      * @dev Returns the token collection name.
203      */
204     function name() external view returns (string memory);
205 
206     /**
207      * @dev Returns the token collection symbol.
208      */
209     function symbol() external view returns (string memory);
210 
211     /**
212      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
213      */
214     function tokenURI(uint256 tokenId) external view returns (string memory);
215 }
216 
217 
218 
219 /**
220  * @dev Collection of functions related to the address type
221  */
222 library Address {
223     /**
224      * @dev Returns true if `account` is a contract.
225      *
226      * [IMPORTANT]
227      * ====
228      * It is unsafe to assume that an address for which this function returns
229      * false is an externally-owned account (EOA) and not a contract.
230      *
231      * Among others, `isContract` will return false for the following
232      * types of addresses:
233      *
234      *  - an externally-owned account
235      *  - a contract in construction
236      *  - an address where a contract will be created
237      *  - an address where a contract lived, but was destroyed
238      * ====
239      */
240     function isContract(address account) internal view returns (bool) {
241         // This method relies on extcodesize, which returns 0 for contracts in
242         // construction, since the code is only stored at the end of the
243         // constructor execution.
244 
245         uint256 size;
246         assembly {
247             size := extcodesize(account)
248         }
249         return size > 0;
250     }
251 
252     /**
253      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
254      * `recipient`, forwarding all available gas and reverting on errors.
255      *
256      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
257      * of certain opcodes, possibly making contracts go over the 2300 gas limit
258      * imposed by `transfer`, making them unable to receive funds via
259      * `transfer`. {sendValue} removes this limitation.
260      *
261      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
262      *
263      * IMPORTANT: because control is transferred to `recipient`, care must be
264      * taken to not create reentrancy vulnerabilities. Consider using
265      * {ReentrancyGuard} or the
266      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
267      */
268     function sendValue(address payable recipient, uint256 amount) internal {
269         require(address(this).balance >= amount, "Address: insufficient balance");
270 
271         (bool success, ) = recipient.call{value: amount}("");
272         require(success, "Address: unable to send value, recipient may have reverted");
273     }
274 
275     /**
276      * @dev Performs a Solidity function call using a low level `call`. A
277      * plain `call` is an unsafe replacement for a function call: use this
278      * function instead.
279      *
280      * If `target` reverts with a revert reason, it is bubbled up by this
281      * function (like regular Solidity function calls).
282      *
283      * Returns the raw returned data. To convert to the expected return value,
284      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
285      *
286      * Requirements:
287      *
288      * - `target` must be a contract.
289      * - calling `target` with `data` must not revert.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
294         return functionCall(target, data, "Address: low-level call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
299      * `errorMessage` as a fallback revert reason when `target` reverts.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal returns (bytes memory) {
308         return functionCallWithValue(target, data, 0, errorMessage);
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
313      * but also transferring `value` wei to `target`.
314      *
315      * Requirements:
316      *
317      * - the calling contract must have an ETH balance of at least `value`.
318      * - the called Solidity function must be `payable`.
319      *
320      * _Available since v3.1._
321      */
322     function functionCallWithValue(
323         address target,
324         bytes memory data,
325         uint256 value
326     ) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
332      * with `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(
337         address target,
338         bytes memory data,
339         uint256 value,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         require(address(this).balance >= value, "Address: insufficient balance for call");
343         require(isContract(target), "Address: call to non-contract");
344 
345         (bool success, bytes memory returndata) = target.call{value: value}(data);
346         return _verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
356         return functionStaticCall(target, data, "Address: low-level static call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal view returns (bytes memory) {
370         require(isContract(target), "Address: static call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.staticcall(data);
373         return _verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
383         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         require(isContract(target), "Address: delegate call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.delegatecall(data);
400         return _verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     function _verifyCallResult(
404         bool success,
405         bytes memory returndata,
406         string memory errorMessage
407     ) private pure returns (bytes memory) {
408         if (success) {
409             return returndata;
410         } else {
411             // Look for revert reason and bubble it up if present
412             if (returndata.length > 0) {
413                 // The easiest way to bubble the revert reason is using memory via assembly
414 
415                 assembly {
416                     let returndata_size := mload(returndata)
417                     revert(add(32, returndata), returndata_size)
418                 }
419             } else {
420                 revert(errorMessage);
421             }
422         }
423     }
424 }
425 
426 
427 
428 
429 /*
430  * @dev Provides information about the current execution context, including the
431  * sender of the transaction and its data. While these are generally available
432  * via msg.sender and msg.data, they should not be accessed in such a direct
433  * manner, since when dealing with meta-transactions the account sending and
434  * paying for execution may not be the actual sender (as far as an application
435  * is concerned).
436  *
437  * This contract is only required for intermediate, library-like contracts.
438  */
439 abstract contract Context {
440     function _msgSender() internal view virtual returns (address) {
441         return msg.sender;
442     }
443 
444     function _msgData() internal view virtual returns (bytes calldata) {
445         return msg.data;
446     }
447 }
448 
449 
450 
451 /**
452  * @dev String operations.
453  */
454 library Strings {
455     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
456 
457     /**
458      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
459      */
460     function toString(uint256 value) internal pure returns (string memory) {
461         // Inspired by OraclizeAPI's implementation - MIT licence
462         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
463 
464         if (value == 0) {
465             return "0";
466         }
467         uint256 temp = value;
468         uint256 digits;
469         while (temp != 0) {
470             digits++;
471             temp /= 10;
472         }
473         bytes memory buffer = new bytes(digits);
474         while (value != 0) {
475             digits -= 1;
476             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
477             value /= 10;
478         }
479         return string(buffer);
480     }
481 
482     /**
483      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
484      */
485     function toHexString(uint256 value) internal pure returns (string memory) {
486         if (value == 0) {
487             return "0x00";
488         }
489         uint256 temp = value;
490         uint256 length = 0;
491         while (temp != 0) {
492             length++;
493             temp >>= 8;
494         }
495         return toHexString(value, length);
496     }
497 
498     /**
499      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
500      */
501     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
502         bytes memory buffer = new bytes(2 * length + 2);
503         buffer[0] = "0";
504         buffer[1] = "x";
505         for (uint256 i = 2 * length + 1; i > 1; --i) {
506             buffer[i] = _HEX_SYMBOLS[value & 0xf];
507             value >>= 4;
508         }
509         require(value == 0, "Strings: hex length insufficient");
510         return string(buffer);
511     }
512 }
513 
514 
515 
516 
517 
518 /**
519  * @dev Implementation of the {IERC165} interface.
520  *
521  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
522  * for the additional interface id that will be supported. For example:
523  *
524  * ```solidity
525  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
526  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
527  * }
528  * ```
529  *
530  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
531  */
532 abstract contract ERC165 is IERC165 {
533     /**
534      * @dev See {IERC165-supportsInterface}.
535      */
536     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537         return interfaceId == type(IERC165).interfaceId;
538     }
539 }
540 
541 
542 
543 
544 /**
545  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
546  * the Metadata extension, but not including the Enumerable extension, which is available separately as
547  * {ERC721Enumerable}.
548  */
549 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
550     using Address for address;
551     using Strings for uint256;
552 
553     // Token name
554     string private _name;
555 
556     // Token symbol
557     string private _symbol;
558 
559     // Mapping from token ID to owner address
560     mapping(uint256 => address) private _owners;
561 
562     // Mapping owner address to token count
563     mapping(address => uint256) private _balances;
564 
565     // Mapping from token ID to approved address
566     mapping(uint256 => address) private _tokenApprovals;
567 
568     // Mapping from owner to operator approvals
569     mapping(address => mapping(address => bool)) private _operatorApprovals;
570 
571     /**
572      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
573      */
574     constructor(string memory name_, string memory symbol_) {
575         _name = name_;
576         _symbol = symbol_;
577     }
578 
579     /**
580      * @dev See {IERC165-supportsInterface}.
581      */
582     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
583         return
584             interfaceId == type(IERC721).interfaceId ||
585             interfaceId == type(IERC721Metadata).interfaceId ||
586             super.supportsInterface(interfaceId);
587     }
588 
589     /**
590      * @dev See {IERC721-balanceOf}.
591      */
592     function balanceOf(address owner) public view virtual override returns (uint256) {
593         require(owner != address(0), "ERC721: balance query for the zero address");
594         return _balances[owner];
595     }
596 
597     /**
598      * @dev See {IERC721-ownerOf}.
599      */
600     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
601         address owner = _owners[tokenId];
602         require(owner != address(0), "ERC721: owner query for nonexistent token");
603         return owner;
604     }
605 
606     /**
607      * @dev See {IERC721Metadata-name}.
608      */
609     function name() public view virtual override returns (string memory) {
610         return _name;
611     }
612 
613     /**
614      * @dev See {IERC721Metadata-symbol}.
615      */
616     function symbol() public view virtual override returns (string memory) {
617         return _symbol;
618     }
619 
620     /**
621      * @dev See {IERC721Metadata-tokenURI}.
622      */
623     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
624         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
625 
626         string memory baseURI = _baseURI();
627         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
628     }
629 
630     /**
631      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
632      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
633      * by default, can be overriden in child contracts.
634      */
635     function _baseURI() internal view virtual returns (string memory) {
636         return "";
637     }
638 
639     /**
640      * @dev See {IERC721-approve}.
641      */
642     function approve(address to, uint256 tokenId) public virtual override {
643         address owner = ERC721.ownerOf(tokenId);
644         require(to != owner, "ERC721: approval to current owner");
645 
646         require(
647             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
648             "ERC721: approve caller is not owner nor approved for all"
649         );
650 
651         _approve(to, tokenId);
652     }
653 
654     /**
655      * @dev See {IERC721-getApproved}.
656      */
657     function getApproved(uint256 tokenId) public view virtual override returns (address) {
658         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
659 
660         return _tokenApprovals[tokenId];
661     }
662 
663     /**
664      * @dev See {IERC721-setApprovalForAll}.
665      */
666     function setApprovalForAll(address operator, bool approved) public virtual override {
667         require(operator != _msgSender(), "ERC721: approve to caller");
668 
669         _operatorApprovals[_msgSender()][operator] = approved;
670         emit ApprovalForAll(_msgSender(), operator, approved);
671     }
672 
673     /**
674      * @dev See {IERC721-isApprovedForAll}.
675      */
676     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
677         return _operatorApprovals[owner][operator];
678     }
679 
680     /**
681      * @dev See {IERC721-transferFrom}.
682      */
683     function transferFrom(
684         address from,
685         address to,
686         uint256 tokenId
687     ) public virtual override {
688         //solhint-disable-next-line max-line-length
689         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
690 
691         _transfer(from, to, tokenId);
692     }
693 
694     /**
695      * @dev See {IERC721-safeTransferFrom}.
696      */
697     function safeTransferFrom(
698         address from,
699         address to,
700         uint256 tokenId
701     ) public virtual override {
702         safeTransferFrom(from, to, tokenId, "");
703     }
704 
705     /**
706      * @dev See {IERC721-safeTransferFrom}.
707      */
708     function safeTransferFrom(
709         address from,
710         address to,
711         uint256 tokenId,
712         bytes memory _data
713     ) public virtual override {
714         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
715         _safeTransfer(from, to, tokenId, _data);
716     }
717 
718     /**
719      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
720      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
721      *
722      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
723      *
724      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
725      * implement alternative mechanisms to perform token transfer, such as signature-based.
726      *
727      * Requirements:
728      *
729      * - `from` cannot be the zero address.
730      * - `to` cannot be the zero address.
731      * - `tokenId` token must exist and be owned by `from`.
732      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
733      *
734      * Emits a {Transfer} event.
735      */
736     function _safeTransfer(
737         address from,
738         address to,
739         uint256 tokenId,
740         bytes memory _data
741     ) internal virtual {
742         _transfer(from, to, tokenId);
743         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
744     }
745 
746     /**
747      * @dev Returns whether `tokenId` exists.
748      *
749      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
750      *
751      * Tokens start existing when they are minted (`_mint`),
752      * and stop existing when they are burned (`_burn`).
753      */
754     function _exists(uint256 tokenId) internal view virtual returns (bool) {
755         return _owners[tokenId] != address(0);
756     }
757 
758     /**
759      * @dev Returns whether `spender` is allowed to manage `tokenId`.
760      *
761      * Requirements:
762      *
763      * - `tokenId` must exist.
764      */
765     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
766         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
767         address owner = ERC721.ownerOf(tokenId);
768         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
769     }
770 
771     /**
772      * @dev Safely mints `tokenId` and transfers it to `to`.
773      *
774      * Requirements:
775      *
776      * - `tokenId` must not exist.
777      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
778      *
779      * Emits a {Transfer} event.
780      */
781     function _safeMint(address to, uint256 tokenId) internal virtual {
782         _safeMint(to, tokenId, "");
783     }
784 
785     /**
786      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
787      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
788      */
789     function _safeMint(
790         address to,
791         uint256 tokenId,
792         bytes memory _data
793     ) internal virtual {
794         _mint(to, tokenId);
795         require(
796             _checkOnERC721Received(address(0), to, tokenId, _data),
797             "ERC721: transfer to non ERC721Receiver implementer"
798         );
799     }
800 
801     /**
802      * @dev Mints `tokenId` and transfers it to `to`.
803      *
804      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
805      *
806      * Requirements:
807      *
808      * - `tokenId` must not exist.
809      * - `to` cannot be the zero address.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _mint(address to, uint256 tokenId) internal virtual {
814         require(to != address(0), "ERC721: mint to the zero address");
815         require(!_exists(tokenId), "ERC721: token already minted");
816 
817         _beforeTokenTransfer(address(0), to, tokenId);
818 
819         _balances[to] += 1;
820         _owners[tokenId] = to;
821 
822         emit Transfer(address(0), to, tokenId);
823     }
824 
825     /**
826      * @dev Destroys `tokenId`.
827      * The approval is cleared when the token is burned.
828      *
829      * Requirements:
830      *
831      * - `tokenId` must exist.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _burn(uint256 tokenId) internal virtual {
836         address owner = ERC721.ownerOf(tokenId);
837 
838         _beforeTokenTransfer(owner, address(0), tokenId);
839 
840         // Clear approvals
841         _approve(address(0), tokenId);
842 
843         _balances[owner] -= 1;
844         delete _owners[tokenId];
845 
846         emit Transfer(owner, address(0), tokenId);
847     }
848 
849     /**
850      * @dev Transfers `tokenId` from `from` to `to`.
851      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
852      *
853      * Requirements:
854      *
855      * - `to` cannot be the zero address.
856      * - `tokenId` token must be owned by `from`.
857      *
858      * Emits a {Transfer} event.
859      */
860     function _transfer(
861         address from,
862         address to,
863         uint256 tokenId
864     ) internal virtual {
865         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
866         require(to != address(0), "ERC721: transfer to the zero address");
867 
868         _beforeTokenTransfer(from, to, tokenId);
869 
870         // Clear approvals from the previous owner
871         _approve(address(0), tokenId);
872 
873         _balances[from] -= 1;
874         _balances[to] += 1;
875         _owners[tokenId] = to;
876 
877         emit Transfer(from, to, tokenId);
878     }
879 
880     /**
881      * @dev Approve `to` to operate on `tokenId`
882      *
883      * Emits a {Approval} event.
884      */
885     function _approve(address to, uint256 tokenId) internal virtual {
886         _tokenApprovals[tokenId] = to;
887         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
888     }
889 
890     /**
891      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
892      * The call is not executed if the target address is not a contract.
893      *
894      * @param from address representing the previous owner of the given token ID
895      * @param to target address that will receive the tokens
896      * @param tokenId uint256 ID of the token to be transferred
897      * @param _data bytes optional data to send along with the call
898      * @return bool whether the call correctly returned the expected magic value
899      */
900     function _checkOnERC721Received(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes memory _data
905     ) private returns (bool) {
906         if (to.isContract()) {
907             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
908                 return retval == IERC721Receiver(to).onERC721Received.selector;
909             } catch (bytes memory reason) {
910                 if (reason.length == 0) {
911                     revert("ERC721: transfer to non ERC721Receiver implementer");
912                 } else {
913                     assembly {
914                         revert(add(32, reason), mload(reason))
915                     }
916                 }
917             }
918         } else {
919             return true;
920         }
921     }
922 
923     /**
924      * @dev Hook that is called before any token transfer. This includes minting
925      * and burning.
926      *
927      * Calling conditions:
928      *
929      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
930      * transferred to `to`.
931      * - When `from` is zero, `tokenId` will be minted for `to`.
932      * - When `to` is zero, ``from``'s `tokenId` will be burned.
933      * - `from` and `to` are never both zero.
934      *
935      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
936      */
937     function _beforeTokenTransfer(
938         address from,
939         address to,
940         uint256 tokenId
941     ) internal virtual {}
942 }
943 
944 
945 
946 
947 /**
948  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
949  * @dev See https://eips.ethereum.org/EIPS/eip-721
950  */
951 interface IERC721Enumerable is IERC721 {
952     /**
953      * @dev Returns the total amount of tokens stored by the contract.
954      */
955     function totalSupply() external view returns (uint256);
956 
957     /**
958      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
959      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
960      */
961     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
962 
963     /**
964      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
965      * Use along with {totalSupply} to enumerate all tokens.
966      */
967     function tokenByIndex(uint256 index) external view returns (uint256);
968 }
969 
970 
971 
972 
973 
974 /**
975  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
976  * enumerability of all the token ids in the contract as well as all token ids owned by each
977  * account.
978  */
979 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
980     // Mapping from owner to list of owned token IDs
981     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
982 
983     // Mapping from token ID to index of the owner tokens list
984     mapping(uint256 => uint256) private _ownedTokensIndex;
985 
986     // Array with all token ids, used for enumeration
987     uint256[] private _allTokens;
988 
989     // Mapping from token id to position in the allTokens array
990     mapping(uint256 => uint256) private _allTokensIndex;
991 
992     /**
993      * @dev See {IERC165-supportsInterface}.
994      */
995     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
996         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
997     }
998 
999     /**
1000      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1001      */
1002     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1003         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1004         return _ownedTokens[owner][index];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Enumerable-totalSupply}.
1009      */
1010     function totalSupply() public view virtual override returns (uint256) {
1011         return _allTokens.length;
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Enumerable-tokenByIndex}.
1016      */
1017     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1018         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1019         return _allTokens[index];
1020     }
1021 
1022     /**
1023      * @dev Hook that is called before any token transfer. This includes minting
1024      * and burning.
1025      *
1026      * Calling conditions:
1027      *
1028      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1029      * transferred to `to`.
1030      * - When `from` is zero, `tokenId` will be minted for `to`.
1031      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1032      * - `from` cannot be the zero address.
1033      * - `to` cannot be the zero address.
1034      *
1035      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1036      */
1037     function _beforeTokenTransfer(
1038         address from,
1039         address to,
1040         uint256 tokenId
1041     ) internal virtual override {
1042         super._beforeTokenTransfer(from, to, tokenId);
1043 
1044         if (from == address(0)) {
1045             _addTokenToAllTokensEnumeration(tokenId);
1046         } else if (from != to) {
1047             _removeTokenFromOwnerEnumeration(from, tokenId);
1048         }
1049         if (to == address(0)) {
1050             _removeTokenFromAllTokensEnumeration(tokenId);
1051         } else if (to != from) {
1052             _addTokenToOwnerEnumeration(to, tokenId);
1053         }
1054     }
1055 
1056     /**
1057      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1058      * @param to address representing the new owner of the given token ID
1059      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1060      */
1061     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1062         uint256 length = ERC721.balanceOf(to);
1063         _ownedTokens[to][length] = tokenId;
1064         _ownedTokensIndex[tokenId] = length;
1065     }
1066 
1067     /**
1068      * @dev Private function to add a token to this extension's token tracking data structures.
1069      * @param tokenId uint256 ID of the token to be added to the tokens list
1070      */
1071     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1072         _allTokensIndex[tokenId] = _allTokens.length;
1073         _allTokens.push(tokenId);
1074     }
1075 
1076     /**
1077      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1078      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1079      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1080      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1081      * @param from address representing the previous owner of the given token ID
1082      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1083      */
1084     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1085         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1086         // then delete the last slot (swap and pop).
1087 
1088         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1089         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1090 
1091         // When the token to delete is the last token, the swap operation is unnecessary
1092         if (tokenIndex != lastTokenIndex) {
1093             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1094 
1095             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1096             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1097         }
1098 
1099         // This also deletes the contents at the last position of the array
1100         delete _ownedTokensIndex[tokenId];
1101         delete _ownedTokens[from][lastTokenIndex];
1102     }
1103 
1104     /**
1105      * @dev Private function to remove a token from this extension's token tracking data structures.
1106      * This has O(1) time complexity, but alters the order of the _allTokens array.
1107      * @param tokenId uint256 ID of the token to be removed from the tokens list
1108      */
1109     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1110         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1111         // then delete the last slot (swap and pop).
1112 
1113         uint256 lastTokenIndex = _allTokens.length - 1;
1114         uint256 tokenIndex = _allTokensIndex[tokenId];
1115 
1116         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1117         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1118         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1119         uint256 lastTokenId = _allTokens[lastTokenIndex];
1120 
1121         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1122         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1123 
1124         // This also deletes the contents at the last position of the array
1125         delete _allTokensIndex[tokenId];
1126         _allTokens.pop();
1127     }
1128 }
1129 
1130 
1131 /**
1132  * @dev Contract module which provides a basic access control mechanism, where
1133  * there is an account (an owner) that can be granted exclusive access to
1134  * specific functions.
1135  *
1136  * By default, the owner account will be the one that deploys the contract. This
1137  * can later be changed with {transferOwnership}.
1138  *
1139  * This module is used through inheritance. It will make available the modifier
1140  * `onlyOwner`, which can be applied to your functions to restrict their use to
1141  * the owner.
1142  */
1143 abstract contract Ownable is Context {
1144     address private _owner;
1145 
1146     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1147 
1148     /**
1149      * @dev Initializes the contract setting the deployer as the initial owner.
1150      */
1151     constructor() {
1152         _setOwner(_msgSender());
1153     }
1154 
1155     /**
1156      * @dev Returns the address of the current owner.
1157      */
1158     function owner() public view virtual returns (address) {
1159         return _owner;
1160     }
1161 
1162     /**
1163      * @dev Throws if called by any account other than the owner.
1164      */
1165     modifier onlyOwner() {
1166         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1167         _;
1168     }
1169 
1170     /**
1171      * @dev Leaves the contract without owner. It will not be possible to call
1172      * `onlyOwner` functions anymore. Can only be called by the current owner.
1173      *
1174      * NOTE: Renouncing ownership will leave the contract without an owner,
1175      * thereby removing any functionality that is only available to the owner.
1176      */
1177     function renounceOwnership() public virtual onlyOwner {
1178         _setOwner(address(0));
1179     }
1180 
1181     /**
1182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1183      * Can only be called by the current owner.
1184      */
1185     function transferOwnership(address newOwner) public virtual onlyOwner {
1186         require(newOwner != address(0), "Ownable: new owner is the zero address");
1187         _setOwner(newOwner);
1188     }
1189 
1190     function _setOwner(address newOwner) private {
1191         address oldOwner = _owner;
1192         _owner = newOwner;
1193         emit OwnershipTransferred(oldOwner, newOwner);
1194     }
1195 }
1196 
1197 
1198 
1199 
1200 contract DINO is ERC721Enumerable, Ownable {
1201 
1202     using Strings for uint256;
1203 
1204     string _baseTokenURI;
1205     uint256 public _reserved = 3000;
1206     uint256 private _price = 0.0555 ether;
1207     bool public _paused = true;
1208 
1209     // withdraw addresses
1210     address t1 = 0x07858bf9D66a43B63521Ab4DEFDb7B4d0Ec658Ed;
1211 
1212 
1213     constructor(string memory baseURI) ERC721("Dapper Dinos", "DINO")  {
1214         setBaseURI(baseURI);
1215 
1216         //mint to team
1217         _safeMint(t1, 0);
1218         _safeMint(t1, 1);
1219         _safeMint(t1, 2);
1220         _safeMint(t1, 3);
1221 
1222     }
1223 
1224     function mint(uint256 num) public payable {
1225         uint256 supply = totalSupply();
1226         require( !_paused,                            "Sale paused" );
1227         require( num < 21,                            "You can mint a maximum of 20" );
1228         require(balanceOf(msg.sender) < 101, "Too many tokens owned to mint more");
1229         require( supply + num < 10000 - _reserved,     "Exceeds maximum supply" );
1230         require( msg.value >= _price * num,           "Ether sent is not correct" );
1231 
1232         for(uint256 i; i < num; i++){
1233             _safeMint( msg.sender, supply + i );
1234         }
1235     }
1236 
1237     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1238         uint256 tokenCount = balanceOf(_owner);
1239 
1240         uint256[] memory tokensId = new uint256[](tokenCount);
1241         for(uint256 i; i < tokenCount; i++){
1242             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1243         }
1244         return tokensId;
1245     }
1246 
1247     // Just in case Eth does some crazy stuff
1248     function setPrice(uint256 _newPrice) public onlyOwner() {
1249         _price = _newPrice;
1250     }
1251 
1252     function _baseURI() internal view virtual override returns (string memory) {
1253         return _baseTokenURI;
1254     }
1255 
1256     function setBaseURI(string memory baseURI) public onlyOwner {
1257         _baseTokenURI = baseURI;
1258     }
1259 
1260     function getPrice() public view returns (uint256){
1261         return _price;
1262     }
1263 
1264     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1265         require( _amount <= _reserved, "Exceeds reserved supply" );
1266 
1267         uint256 supply = totalSupply();
1268         for(uint256 i; i < _amount; i++){
1269             _safeMint( _to, supply + i );
1270         }
1271 
1272         _reserved -= _amount;
1273     }
1274 
1275     function pause(bool val) public onlyOwner {
1276         _paused = val;
1277     }
1278     
1279    function setReserved(uint256 _newReserved) public onlyOwner {
1280         _reserved = _newReserved;
1281     }
1282     
1283 
1284     function withdrawAll() public payable onlyOwner {
1285         uint256 _each = address(this).balance;
1286         require(payable(t1).send(_each));
1287     }
1288 }