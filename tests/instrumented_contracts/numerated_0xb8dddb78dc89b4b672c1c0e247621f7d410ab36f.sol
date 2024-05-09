1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
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
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45 
46     /**
47      * @dev Returns the number of tokens in ``owner``'s account.
48      */
49     function balanceOf(address owner) external view returns (uint256 balance);
50 
51     /**
52      * @dev Returns the owner of the `tokenId` token.
53      *
54      * Requirements:
55      *
56      * - `tokenId` must exist.
57      */
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59 
60     /**
61      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
62      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
63      *
64      * Requirements:
65      *
66      * - `from` cannot be the zero address.
67      * - `to` cannot be the zero address.
68      * - `tokenId` token must exist and be owned by `from`.
69      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
70      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
71      *
72      * Emits a {Transfer} event.
73      */
74     function safeTransferFrom(
75         address from,
76         address to,
77         uint256 tokenId
78     ) external;
79 
80     /**
81      * @dev Transfers `tokenId` token from `from` to `to`.
82      *
83      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must be owned by `from`.
90      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(
95         address from,
96         address to,
97         uint256 tokenId
98     ) external;
99 
100     /**
101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
102      * The approval is cleared when the token is transferred.
103      *
104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
105      *
106      * Requirements:
107      *
108      * - The caller must own the token or be an approved operator.
109      * - `tokenId` must exist.
110      *
111      * Emits an {Approval} event.
112      */
113     function approve(address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Returns the account approved for `tokenId` token.
117      *
118      * Requirements:
119      *
120      * - `tokenId` must exist.
121      */
122     function getApproved(uint256 tokenId) external view returns (address operator);
123 
124     /**
125      * @dev Approve or remove `operator` as an operator for the caller.
126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
127      *
128      * Requirements:
129      *
130      * - The `operator` cannot be the caller.
131      *
132      * Emits an {ApprovalForAll} event.
133      */
134     function setApprovalForAll(address operator, bool _approved) external;
135 
136     /**
137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
138      *
139      * See {setApprovalForAll}
140      */
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143     /**
144      * @dev Safely transfers `tokenId` token from `from` to `to`.
145      *
146      * Requirements:
147      *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150      * - `tokenId` token must exist and be owned by `from`.
151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153      *
154      * Emits a {Transfer} event.
155      */
156     function safeTransferFrom(
157         address from,
158         address to,
159         uint256 tokenId,
160         bytes calldata data
161     ) external;
162 }
163 
164 /**
165  * @title ERC721 token receiver interface
166  * @dev Interface for any contract that wants to support safeTransfers
167  * from ERC721 asset contracts.
168  */
169 interface IERC721Receiver {
170     /**
171      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
172      * by `operator` from `from`, this function is called.
173      *
174      * It must return its Solidity selector to confirm the token transfer.
175      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
176      *
177      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
178      */
179     function onERC721Received(
180         address operator,
181         address from,
182         uint256 tokenId,
183         bytes calldata data
184     ) external returns (bytes4);
185 }
186 
187 
188 /**
189  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
190  * @dev See https://eips.ethereum.org/EIPS/eip-721
191  */
192 interface IERC721Metadata is IERC721 {
193     /**
194      * @dev Returns the token collection name.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the token collection symbol.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
205      */
206     function tokenURI(uint256 tokenId) external view returns (string memory);
207 }
208 
209 /**
210  * @dev Collection of functions related to the address type
211  */
212 library Address {
213     /**
214      * @dev Returns true if `account` is a contract.
215      *
216      * [IMPORTANT]
217      * ====
218      * It is unsafe to assume that an address for which this function returns
219      * false is an externally-owned account (EOA) and not a contract.
220      *
221      * Among others, `isContract` will return false for the following
222      * types of addresses:
223      *
224      *  - an externally-owned account
225      *  - a contract in construction
226      *  - an address where a contract will be created
227      *  - an address where a contract lived, but was destroyed
228      * ====
229      */
230     function isContract(address account) internal view returns (bool) {
231         // This method relies on extcodesize, which returns 0 for contracts in
232         // construction, since the code is only stored at the end of the
233         // constructor execution.
234 
235         uint256 size;
236         assembly {
237             size := extcodesize(account)
238         }
239         return size > 0;
240     }
241 
242     /**
243      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
244      * `recipient`, forwarding all available gas and reverting on errors.
245      *
246      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
247      * of certain opcodes, possibly making contracts go over the 2300 gas limit
248      * imposed by `transfer`, making them unable to receive funds via
249      * `transfer`. {sendValue} removes this limitation.
250      *
251      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
252      *
253      * IMPORTANT: because control is transferred to `recipient`, care must be
254      * taken to not create reentrancy vulnerabilities. Consider using
255      * {ReentrancyGuard} or the
256      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
257      */
258     function sendValue(address payable recipient, uint256 amount) internal {
259         require(address(this).balance >= amount, "Address: insufficient balance");
260 
261         (bool success, ) = recipient.call{value: amount}("");
262         require(success, "Address: unable to send value, recipient may have reverted");
263     }
264 
265     /**
266      * @dev Performs a Solidity function call using a low level `call`. A
267      * plain `call` is an unsafe replacement for a function call: use this
268      * function instead.
269      *
270      * If `target` reverts with a revert reason, it is bubbled up by this
271      * function (like regular Solidity function calls).
272      *
273      * Returns the raw returned data. To convert to the expected return value,
274      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
275      *
276      * Requirements:
277      *
278      * - `target` must be a contract.
279      * - calling `target` with `data` must not revert.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
284         return functionCall(target, data, "Address: low-level call failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
289      * `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(
294         address target,
295         bytes memory data,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, 0, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but also transferring `value` wei to `target`.
304      *
305      * Requirements:
306      *
307      * - the calling contract must have an ETH balance of at least `value`.
308      * - the called Solidity function must be `payable`.
309      *
310      * _Available since v3.1._
311      */
312     function functionCallWithValue(
313         address target,
314         bytes memory data,
315         uint256 value
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
322      * with `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         require(address(this).balance >= value, "Address: insufficient balance for call");
333         require(isContract(target), "Address: call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.call{value: value}(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a static call.
342      *
343      * _Available since v3.3._
344      */
345     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
346         return functionStaticCall(target, data, "Address: low-level static call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal view returns (bytes memory) {
360         require(isContract(target), "Address: static call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.staticcall(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
373         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         require(isContract(target), "Address: delegate call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.delegatecall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
395      * revert reason using the provided one.
396      *
397      * _Available since v4.3._
398      */
399     function verifyCallResult(
400         bool success,
401         bytes memory returndata,
402         string memory errorMessage
403     ) internal pure returns (bytes memory) {
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410 
411                 assembly {
412                     let returndata_size := mload(returndata)
413                     revert(add(32, returndata), returndata_size)
414                 }
415             } else {
416                 revert(errorMessage);
417             }
418         }
419     }
420 }
421 
422 /**
423  * @dev Provides information about the current execution context, including the
424  * sender of the transaction and its data. While these are generally available
425  * via msg.sender and msg.data, they should not be accessed in such a direct
426  * manner, since when dealing with meta-transactions the account sending and
427  * paying for execution may not be the actual sender (as far as an application
428  * is concerned).
429  *
430  * This contract is only required for intermediate, library-like contracts.
431  */
432 abstract contract Context {
433     function _msgSender() internal view virtual returns (address) {
434         return msg.sender;
435     }
436 
437     function _msgData() internal view virtual returns (bytes calldata) {
438         return msg.data;
439     }
440 }
441 
442 /**
443  * @dev String operations.
444  */
445 library Strings {
446     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
447 
448     /**
449      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
450      */
451     function toString(uint256 value) internal pure returns (string memory) {
452         // Inspired by OraclizeAPI's implementation - MIT licence
453         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
454 
455         if (value == 0) {
456             return "0";
457         }
458         uint256 temp = value;
459         uint256 digits;
460         while (temp != 0) {
461             digits++;
462             temp /= 10;
463         }
464         bytes memory buffer = new bytes(digits);
465         while (value != 0) {
466             digits -= 1;
467             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
468             value /= 10;
469         }
470         return string(buffer);
471     }
472 
473     /**
474      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
475      */
476     function toHexString(uint256 value) internal pure returns (string memory) {
477         if (value == 0) {
478             return "0x00";
479         }
480         uint256 temp = value;
481         uint256 length = 0;
482         while (temp != 0) {
483             length++;
484             temp >>= 8;
485         }
486         return toHexString(value, length);
487     }
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
491      */
492     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
493         bytes memory buffer = new bytes(2 * length + 2);
494         buffer[0] = "0";
495         buffer[1] = "x";
496         for (uint256 i = 2 * length + 1; i > 1; --i) {
497             buffer[i] = _HEX_SYMBOLS[value & 0xf];
498             value >>= 4;
499         }
500         require(value == 0, "Strings: hex length insufficient");
501         return string(buffer);
502     }
503 }
504 
505 /**
506  * @dev Implementation of the {IERC165} interface.
507  *
508  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
509  * for the additional interface id that will be supported. For example:
510  *
511  * ```solidity
512  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
513  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
514  * }
515  * ```
516  *
517  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
518  */
519 abstract contract ERC165 is IERC165 {
520     /**
521      * @dev See {IERC165-supportsInterface}.
522      */
523     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
524         return interfaceId == type(IERC165).interfaceId;
525     }
526 }
527 
528 /**
529  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
530  * the Metadata extension, but not including the Enumerable extension, which is available separately as
531  * {ERC721Enumerable}.
532  */
533 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
534     using Address for address;
535     using Strings for uint256;
536 
537     // Token name
538     string private _name;
539 
540     // Token symbol
541     string private _symbol;
542 
543     // Mapping from token ID to owner address
544     mapping(uint256 => address) private _owners;
545 
546     // Mapping owner address to token count
547     mapping(address => uint256) private _balances;
548 
549     // Mapping from token ID to approved address
550     mapping(uint256 => address) private _tokenApprovals;
551 
552     // Mapping from owner to operator approvals
553     mapping(address => mapping(address => bool)) private _operatorApprovals;
554 
555     /**
556      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
557      */
558     constructor(string memory name_, string memory symbol_) {
559         _name = name_;
560         _symbol = symbol_;
561     }
562 
563     /**
564      * @dev See {IERC165-supportsInterface}.
565      */
566     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
567         return
568         interfaceId == type(IERC721).interfaceId ||
569         interfaceId == type(IERC721Metadata).interfaceId ||
570         super.supportsInterface(interfaceId);
571     }
572 
573     /**
574      * @dev See {IERC721-balanceOf}.
575      */
576     function balanceOf(address owner) public view virtual override returns (uint256) {
577         require(owner != address(0), "ERC721: balance query for the zero address");
578         return _balances[owner];
579     }
580 
581     /**
582      * @dev See {IERC721-ownerOf}.
583      */
584     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
585         address owner = _owners[tokenId];
586         require(owner != address(0), "ERC721: owner query for nonexistent token");
587         return owner;
588     }
589 
590     /**
591      * @dev See {IERC721Metadata-name}.
592      */
593     function name() public view virtual override returns (string memory) {
594         return _name;
595     }
596 
597     /**
598      * @dev See {IERC721Metadata-symbol}.
599      */
600     function symbol() public view virtual override returns (string memory) {
601         return _symbol;
602     }
603 
604     /**
605      * @dev See {IERC721Metadata-tokenURI}.
606      */
607     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
608         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
609 
610         string memory baseURI = _baseURI();
611         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
612     }
613 
614     /**
615      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
616      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
617      * by default, can be overriden in child contracts.
618      */
619     function _baseURI() internal view virtual returns (string memory) {
620         return "";
621     }
622 
623     /**
624      * @dev See {IERC721-approve}.
625      */
626     function approve(address to, uint256 tokenId) public virtual override {
627         address owner = ERC721.ownerOf(tokenId);
628         require(to != owner, "ERC721: approval to current owner");
629 
630         require(
631             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
632             "ERC721: approve caller is not owner nor approved for all"
633         );
634 
635         _approve(to, tokenId);
636     }
637 
638     /**
639      * @dev See {IERC721-getApproved}.
640      */
641     function getApproved(uint256 tokenId) public view virtual override returns (address) {
642         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
643 
644         return _tokenApprovals[tokenId];
645     }
646 
647     /**
648      * @dev See {IERC721-setApprovalForAll}.
649      */
650     function setApprovalForAll(address operator, bool approved) public virtual override {
651         require(operator != _msgSender(), "ERC721: approve to caller");
652 
653         _operatorApprovals[_msgSender()][operator] = approved;
654         emit ApprovalForAll(_msgSender(), operator, approved);
655     }
656 
657     /**
658      * @dev See {IERC721-isApprovedForAll}.
659      */
660     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
661         return _operatorApprovals[owner][operator];
662     }
663 
664     /**
665      * @dev See {IERC721-transferFrom}.
666      */
667     function transferFrom(
668         address from,
669         address to,
670         uint256 tokenId
671     ) public virtual override {
672         //solhint-disable-next-line max-line-length
673         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
674 
675         _transfer(from, to, tokenId);
676     }
677 
678     /**
679      * @dev See {IERC721-safeTransferFrom}.
680      */
681     function safeTransferFrom(
682         address from,
683         address to,
684         uint256 tokenId
685     ) public virtual override {
686         safeTransferFrom(from, to, tokenId, "");
687     }
688 
689     /**
690      * @dev See {IERC721-safeTransferFrom}.
691      */
692     function safeTransferFrom(
693         address from,
694         address to,
695         uint256 tokenId,
696         bytes memory _data
697     ) public virtual override {
698         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
699         _safeTransfer(from, to, tokenId, _data);
700     }
701 
702     /**
703      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
704      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
705      *
706      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
707      *
708      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
709      * implement alternative mechanisms to perform token transfer, such as signature-based.
710      *
711      * Requirements:
712      *
713      * - `from` cannot be the zero address.
714      * - `to` cannot be the zero address.
715      * - `tokenId` token must exist and be owned by `from`.
716      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
717      *
718      * Emits a {Transfer} event.
719      */
720     function _safeTransfer(
721         address from,
722         address to,
723         uint256 tokenId,
724         bytes memory _data
725     ) internal virtual {
726         _transfer(from, to, tokenId);
727         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
728     }
729 
730     /**
731      * @dev Returns whether `tokenId` exists.
732      *
733      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
734      *
735      * Tokens start existing when they are minted (`_mint`),
736      * and stop existing when they are burned (`_burn`).
737      */
738     function _exists(uint256 tokenId) internal view virtual returns (bool) {
739         return _owners[tokenId] != address(0);
740     }
741 
742     /**
743      * @dev Returns whether `spender` is allowed to manage `tokenId`.
744      *
745      * Requirements:
746      *
747      * - `tokenId` must exist.
748      */
749     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
750         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
751         address owner = ERC721.ownerOf(tokenId);
752         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
753     }
754 
755     /**
756      * @dev Safely mints `tokenId` and transfers it to `to`.
757      *
758      * Requirements:
759      *
760      * - `tokenId` must not exist.
761      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
762      *
763      * Emits a {Transfer} event.
764      */
765     function _safeMint(address to, uint256 tokenId) internal virtual {
766         _safeMint(to, tokenId, "");
767     }
768 
769     /**
770      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
771      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
772      */
773     function _safeMint(
774         address to,
775         uint256 tokenId,
776         bytes memory _data
777     ) internal virtual {
778         _mint(to, tokenId);
779         require(
780             _checkOnERC721Received(address(0), to, tokenId, _data),
781             "ERC721: transfer to non ERC721Receiver implementer"
782         );
783     }
784 
785     /**
786      * @dev Mints `tokenId` and transfers it to `to`.
787      *
788      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
789      *
790      * Requirements:
791      *
792      * - `tokenId` must not exist.
793      * - `to` cannot be the zero address.
794      *
795      * Emits a {Transfer} event.
796      */
797     function _mint(address to, uint256 tokenId) internal virtual {
798         require(to != address(0), "ERC721: mint to the zero address");
799         require(!_exists(tokenId), "ERC721: token already minted");
800 
801         _beforeTokenTransfer(address(0), to, tokenId);
802 
803         _balances[to] += 1;
804         _owners[tokenId] = to;
805 
806         emit Transfer(address(0), to, tokenId);
807     }
808 
809     /**
810      * @dev Destroys `tokenId`.
811      * The approval is cleared when the token is burned.
812      *
813      * Requirements:
814      *
815      * - `tokenId` must exist.
816      *
817      * Emits a {Transfer} event.
818      */
819     function _burn(uint256 tokenId) internal virtual {
820         address owner = ERC721.ownerOf(tokenId);
821 
822         _beforeTokenTransfer(owner, address(0), tokenId);
823 
824         // Clear approvals
825         _approve(address(0), tokenId);
826 
827         _balances[owner] -= 1;
828         delete _owners[tokenId];
829 
830         emit Transfer(owner, address(0), tokenId);
831     }
832 
833     /**
834      * @dev Transfers `tokenId` from `from` to `to`.
835      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
836      *
837      * Requirements:
838      *
839      * - `to` cannot be the zero address.
840      * - `tokenId` token must be owned by `from`.
841      *
842      * Emits a {Transfer} event.
843      */
844     function _transfer(
845         address from,
846         address to,
847         uint256 tokenId
848     ) internal virtual {
849         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
850         require(to != address(0), "ERC721: transfer to the zero address");
851 
852         _beforeTokenTransfer(from, to, tokenId);
853 
854         // Clear approvals from the previous owner
855         _approve(address(0), tokenId);
856 
857         _balances[from] -= 1;
858         _balances[to] += 1;
859         _owners[tokenId] = to;
860 
861         emit Transfer(from, to, tokenId);
862     }
863 
864     /**
865      * @dev Approve `to` to operate on `tokenId`
866      *
867      * Emits a {Approval} event.
868      */
869     function _approve(address to, uint256 tokenId) internal virtual {
870         _tokenApprovals[tokenId] = to;
871         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
872     }
873 
874     /**
875      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
876      * The call is not executed if the target address is not a contract.
877      *
878      * @param from address representing the previous owner of the given token ID
879      * @param to target address that will receive the tokens
880      * @param tokenId uint256 ID of the token to be transferred
881      * @param _data bytes optional data to send along with the call
882      * @return bool whether the call correctly returned the expected magic value
883      */
884     function _checkOnERC721Received(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes memory _data
889     ) private returns (bool) {
890         if (to.isContract()) {
891             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
892                 return retval == IERC721Receiver.onERC721Received.selector;
893             } catch (bytes memory reason) {
894                 if (reason.length == 0) {
895                     revert("ERC721: transfer to non ERC721Receiver implementer");
896                 } else {
897                     assembly {
898                         revert(add(32, reason), mload(reason))
899                     }
900                 }
901             }
902         } else {
903             return true;
904         }
905     }
906 
907     /**
908      * @dev Hook that is called before any token transfer. This includes minting
909      * and burning.
910      *
911      * Calling conditions:
912      *
913      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
914      * transferred to `to`.
915      * - When `from` is zero, `tokenId` will be minted for `to`.
916      * - When `to` is zero, ``from``'s `tokenId` will be burned.
917      * - `from` and `to` are never both zero.
918      *
919      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
920      */
921     function _beforeTokenTransfer(
922         address from,
923         address to,
924         uint256 tokenId
925     ) internal virtual {}
926 }
927 
928 /**
929  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
930  * @dev See https://eips.ethereum.org/EIPS/eip-721
931  */
932 interface IERC721Enumerable is IERC721 {
933     /**
934      * @dev Returns the total amount of tokens stored by the contract.
935      */
936     function totalSupply() external view returns (uint256);
937 
938     /**
939      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
940      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
941      */
942     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
943 
944     /**
945      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
946      * Use along with {totalSupply} to enumerate all tokens.
947      */
948     function tokenByIndex(uint256 index) external view returns (uint256);
949 }
950 
951 /**
952  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
953  * enumerability of all the token ids in the contract as well as all token ids owned by each
954  * account.
955  */
956 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
957     // Mapping from owner to list of owned token IDs
958     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
959 
960     // Mapping from token ID to index of the owner tokens list
961     mapping(uint256 => uint256) private _ownedTokensIndex;
962 
963     // Array with all token ids, used for enumeration
964     uint256[] private _allTokens;
965 
966     // Mapping from token id to position in the allTokens array
967     mapping(uint256 => uint256) private _allTokensIndex;
968 
969     /**
970      * @dev See {IERC165-supportsInterface}.
971      */
972     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
973         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
974     }
975 
976     /**
977      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
978      */
979     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
980         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
981         return _ownedTokens[owner][index];
982     }
983 
984     /**
985      * @dev See {IERC721Enumerable-totalSupply}.
986      */
987     function totalSupply() public view virtual override returns (uint256) {
988         return _allTokens.length;
989     }
990 
991     /**
992      * @dev See {IERC721Enumerable-tokenByIndex}.
993      */
994     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
995         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
996         return _allTokens[index];
997     }
998 
999     /**
1000      * @dev Hook that is called before any token transfer. This includes minting
1001      * and burning.
1002      *
1003      * Calling conditions:
1004      *
1005      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1006      * transferred to `to`.
1007      * - When `from` is zero, `tokenId` will be minted for `to`.
1008      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1009      * - `from` cannot be the zero address.
1010      * - `to` cannot be the zero address.
1011      *
1012      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1013      */
1014     function _beforeTokenTransfer(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) internal virtual override {
1019         super._beforeTokenTransfer(from, to, tokenId);
1020 
1021         if (from == address(0)) {
1022             _addTokenToAllTokensEnumeration(tokenId);
1023         } else if (from != to) {
1024             _removeTokenFromOwnerEnumeration(from, tokenId);
1025         }
1026         if (to == address(0)) {
1027             _removeTokenFromAllTokensEnumeration(tokenId);
1028         } else if (to != from) {
1029             _addTokenToOwnerEnumeration(to, tokenId);
1030         }
1031     }
1032 
1033     /**
1034      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1035      * @param to address representing the new owner of the given token ID
1036      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1037      */
1038     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1039         uint256 length = ERC721.balanceOf(to);
1040         _ownedTokens[to][length] = tokenId;
1041         _ownedTokensIndex[tokenId] = length;
1042     }
1043 
1044     /**
1045      * @dev Private function to add a token to this extension's token tracking data structures.
1046      * @param tokenId uint256 ID of the token to be added to the tokens list
1047      */
1048     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1049         _allTokensIndex[tokenId] = _allTokens.length;
1050         _allTokens.push(tokenId);
1051     }
1052 
1053     /**
1054      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1055      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1056      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1057      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1058      * @param from address representing the previous owner of the given token ID
1059      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1060      */
1061     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1062         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1063         // then delete the last slot (swap and pop).
1064 
1065         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1066         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1067 
1068         // When the token to delete is the last token, the swap operation is unnecessary
1069         if (tokenIndex != lastTokenIndex) {
1070             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1071 
1072             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1073             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1074         }
1075 
1076         // This also deletes the contents at the last position of the array
1077         delete _ownedTokensIndex[tokenId];
1078         delete _ownedTokens[from][lastTokenIndex];
1079     }
1080 
1081     /**
1082      * @dev Private function to remove a token from this extension's token tracking data structures.
1083      * This has O(1) time complexity, but alters the order of the _allTokens array.
1084      * @param tokenId uint256 ID of the token to be removed from the tokens list
1085      */
1086     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1087         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1088         // then delete the last slot (swap and pop).
1089 
1090         uint256 lastTokenIndex = _allTokens.length - 1;
1091         uint256 tokenIndex = _allTokensIndex[tokenId];
1092 
1093         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1094         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1095         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1096         uint256 lastTokenId = _allTokens[lastTokenIndex];
1097 
1098         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1099         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1100 
1101         // This also deletes the contents at the last position of the array
1102         delete _allTokensIndex[tokenId];
1103         _allTokens.pop();
1104     }
1105 }
1106 
1107 /**
1108  * @dev Contract module which provides a basic access control mechanism, where
1109  * there is an account (an owner) that can be granted exclusive access to
1110  * specific functions.
1111  *
1112  * By default, the owner account will be the one that deploys the contract. This
1113  * can later be changed with {transferOwnership}.
1114  *
1115  * This module is used through inheritance. It will make available the modifier
1116  * `onlyOwner`, which can be applied to your functions to restrict their use to
1117  * the owner.
1118  */
1119 abstract contract Ownable is Context {
1120     address private _owner;
1121 
1122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1123 
1124     /**
1125      * @dev Initializes the contract setting the deployer as the initial owner.
1126      */
1127     constructor() {
1128         _setOwner(_msgSender());
1129     }
1130 
1131     /**
1132      * @dev Returns the address of the current owner.
1133      */
1134     function owner() public view virtual returns (address) {
1135         return _owner;
1136     }
1137 
1138     /**
1139      * @dev Throws if called by any account other than the owner.
1140      */
1141     modifier onlyOwner() {
1142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1143         _;
1144     }
1145 
1146     /**
1147      * @dev Leaves the contract without owner. It will not be possible to call
1148      * `onlyOwner` functions anymore. Can only be called by the current owner.
1149      *
1150      * NOTE: Renouncing ownership will leave the contract without an owner,
1151      * thereby removing any functionality that is only available to the owner.
1152      */
1153     function renounceOwnership() public virtual onlyOwner {
1154         _setOwner(address(0));
1155     }
1156 
1157     /**
1158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1159      * Can only be called by the current owner.
1160      */
1161     function transferOwnership(address newOwner) public virtual onlyOwner {
1162         require(newOwner != address(0), "Ownable: new owner is the zero address");
1163         _setOwner(newOwner);
1164     }
1165 
1166     function _setOwner(address newOwner) private {
1167         address oldOwner = _owner;
1168         _owner = newOwner;
1169         emit OwnershipTransferred(oldOwner, newOwner);
1170     }
1171 }
1172 
1173 // CAUTION
1174 // This version of SafeMath should only be used with Solidity 0.8 or later,
1175 // because it relies on the compiler's built in overflow checks.
1176 
1177 /**
1178  * @dev Wrappers over Solidity's arithmetic operations.
1179  *
1180  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1181  * now has built in overflow checking.
1182  */
1183 library SafeMath {
1184     /**
1185      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1186      *
1187      * _Available since v3.4._
1188      */
1189     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1190     unchecked {
1191         uint256 c = a + b;
1192         if (c < a) return (false, 0);
1193         return (true, c);
1194     }
1195     }
1196 
1197     /**
1198      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1199      *
1200      * _Available since v3.4._
1201      */
1202     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1203     unchecked {
1204         if (b > a) return (false, 0);
1205         return (true, a - b);
1206     }
1207     }
1208 
1209     /**
1210      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1211      *
1212      * _Available since v3.4._
1213      */
1214     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1215     unchecked {
1216         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1217         // benefit is lost if 'b' is also tested.
1218         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1219         if (a == 0) return (true, 0);
1220         uint256 c = a * b;
1221         if (c / a != b) return (false, 0);
1222         return (true, c);
1223     }
1224     }
1225 
1226     /**
1227      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1228      *
1229      * _Available since v3.4._
1230      */
1231     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1232     unchecked {
1233         if (b == 0) return (false, 0);
1234         return (true, a / b);
1235     }
1236     }
1237 
1238     /**
1239      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1240      *
1241      * _Available since v3.4._
1242      */
1243     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1244     unchecked {
1245         if (b == 0) return (false, 0);
1246         return (true, a % b);
1247     }
1248     }
1249 
1250     /**
1251      * @dev Returns the addition of two unsigned integers, reverting on
1252      * overflow.
1253      *
1254      * Counterpart to Solidity's `+` operator.
1255      *
1256      * Requirements:
1257      *
1258      * - Addition cannot overflow.
1259      */
1260     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1261         return a + b;
1262     }
1263 
1264     /**
1265      * @dev Returns the subtraction of two unsigned integers, reverting on
1266      * overflow (when the result is negative).
1267      *
1268      * Counterpart to Solidity's `-` operator.
1269      *
1270      * Requirements:
1271      *
1272      * - Subtraction cannot overflow.
1273      */
1274     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1275         return a - b;
1276     }
1277 
1278     /**
1279      * @dev Returns the multiplication of two unsigned integers, reverting on
1280      * overflow.
1281      *
1282      * Counterpart to Solidity's `*` operator.
1283      *
1284      * Requirements:
1285      *
1286      * - Multiplication cannot overflow.
1287      */
1288     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1289         return a * b;
1290     }
1291 
1292     /**
1293      * @dev Returns the integer division of two unsigned integers, reverting on
1294      * division by zero. The result is rounded towards zero.
1295      *
1296      * Counterpart to Solidity's `/` operator.
1297      *
1298      * Requirements:
1299      *
1300      * - The divisor cannot be zero.
1301      */
1302     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1303         return a / b;
1304     }
1305 
1306     /**
1307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1308      * reverting when dividing by zero.
1309      *
1310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1311      * opcode (which leaves remaining gas untouched) while Solidity uses an
1312      * invalid opcode to revert (consuming all remaining gas).
1313      *
1314      * Requirements:
1315      *
1316      * - The divisor cannot be zero.
1317      */
1318     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1319         return a % b;
1320     }
1321 
1322     /**
1323      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1324      * overflow (when the result is negative).
1325      *
1326      * CAUTION: This function is deprecated because it requires allocating memory for the error
1327      * message unnecessarily. For custom revert reasons use {trySub}.
1328      *
1329      * Counterpart to Solidity's `-` operator.
1330      *
1331      * Requirements:
1332      *
1333      * - Subtraction cannot overflow.
1334      */
1335     function sub(
1336         uint256 a,
1337         uint256 b,
1338         string memory errorMessage
1339     ) internal pure returns (uint256) {
1340     unchecked {
1341         require(b <= a, errorMessage);
1342         return a - b;
1343     }
1344     }
1345 
1346     /**
1347      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1348      * division by zero. The result is rounded towards zero.
1349      *
1350      * Counterpart to Solidity's `/` operator. Note: this function uses a
1351      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1352      * uses an invalid opcode to revert (consuming all remaining gas).
1353      *
1354      * Requirements:
1355      *
1356      * - The divisor cannot be zero.
1357      */
1358     function div(
1359         uint256 a,
1360         uint256 b,
1361         string memory errorMessage
1362     ) internal pure returns (uint256) {
1363     unchecked {
1364         require(b > 0, errorMessage);
1365         return a / b;
1366     }
1367     }
1368 
1369     /**
1370      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1371      * reverting with custom message when dividing by zero.
1372      *
1373      * CAUTION: This function is deprecated because it requires allocating memory for the error
1374      * message unnecessarily. For custom revert reasons use {tryMod}.
1375      *
1376      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1377      * opcode (which leaves remaining gas untouched) while Solidity uses an
1378      * invalid opcode to revert (consuming all remaining gas).
1379      *
1380      * Requirements:
1381      *
1382      * - The divisor cannot be zero.
1383      */
1384     function mod(
1385         uint256 a,
1386         uint256 b,
1387         string memory errorMessage
1388     ) internal pure returns (uint256) {
1389     unchecked {
1390         require(b > 0, errorMessage);
1391         return a % b;
1392     }
1393     }
1394 }
1395 
1396 contract Gromlins is ERC721Enumerable, Ownable {
1397     using SafeMath for uint256;
1398     using Address for address;
1399 
1400     uint256 public maxMintPerTx = 20;
1401     uint256 public maxPublicMintPerWallet = 1;
1402 
1403     bool public revealed = false;
1404     string private baseURI;
1405     string public suffixURI;
1406 
1407     uint256 public maxSupply;
1408     uint256 public priceForPrivate = 0 ether;
1409     uint256 public priceForPublic = 0 ether;
1410 
1411     bool public privateSaleActive = false;
1412     bool public publicSaleActive = false;
1413 
1414     mapping (address => uint256) public whitelistForPrivate;
1415 
1416     mapping (address => uint256) public publicMinted;
1417 
1418 
1419     constructor() ERC721("Gromlins", "GRMLNS") {
1420         maxSupply = 10000;
1421     }
1422 
1423     function airdrop(uint256 numberOfMints, address wallet) public onlyOwner {
1424         uint256 supply = totalSupply();
1425         require(supply.add(numberOfMints) <= maxSupply, "Airdrop would exceed max supply of tokens");
1426         for (uint256 i = 0; i < numberOfMints; i++) {
1427             _safeMint(wallet, supply + 1 + i);
1428         }
1429     }
1430 
1431     function airdrops(uint256 numberOfMints, address[] calldata wallets) public onlyOwner {
1432         uint256 supply = totalSupply();
1433         require(supply.add(numberOfMints.mul(wallets.length)) <= maxSupply, "Airdrop would exceed max supply of tokens");
1434         for (uint256 j = 0; j < wallets.length; j++) {
1435             for (uint256 i = 0; i < numberOfMints; i++) {
1436                 _safeMint(wallets[j], supply + 1 + i + j * numberOfMints);
1437             }
1438         }
1439     }
1440 
1441     function mintForMarketing(uint256 numberOfMints) public onlyOwner {
1442         uint256 supply = totalSupply();
1443         require(supply.add(numberOfMints) <= maxSupply, "Mint would exceed max supply of tokens");
1444         for (uint256 i = 0; i < numberOfMints; i++) {
1445             _safeMint(msg.sender, supply + 1 + i);
1446         }
1447     }
1448 
1449     function mintPrivate(uint256 numberOfMints) public payable {
1450         uint256 supply = totalSupply();
1451         uint256 reserved = whitelistForPrivate[msg.sender];
1452         require(privateSaleActive, "Private sale must be active to mint");
1453         require(numberOfMints > 0 && numberOfMints <= maxMintPerTx, "Invalid purchase amount");
1454         require(reserved > 0, "No tokens reserved for this address");
1455         require(numberOfMints <= reserved, "Can't mint more than reserved");
1456         require(supply.add(numberOfMints) <= maxSupply, "Purchase would exceed max supply of tokens");
1457         require(priceForPrivate.mul(numberOfMints) <= msg.value, "Ether value sent is not correct");
1458         whitelistForPrivate[msg.sender] = reserved - numberOfMints;
1459 
1460         for(uint256 i; i < numberOfMints; i++) {
1461             _safeMint(msg.sender, supply + 1 + i);
1462         }
1463     }
1464 
1465     function mintPublic(uint256 numberOfMints) public payable {
1466         uint256 supply = totalSupply();
1467         require(publicSaleActive, "Public sale must be active to mint");
1468         require(numberOfMints > 0 && numberOfMints <= maxMintPerTx, "Invalid purchase amount");
1469         require(supply.add(numberOfMints) <= maxSupply, "Purchase would exceed max supply of tokens");
1470         require(priceForPublic.mul(numberOfMints) <= msg.value, "Ether value sent is not correct");
1471         require(publicMinted[msg.sender] + numberOfMints <= maxPublicMintPerWallet, "Too many mint for this wallet");
1472 
1473         publicMinted[msg.sender] += numberOfMints;
1474 
1475         for(uint256 i; i < numberOfMints; i++) {
1476             _safeMint(msg.sender, supply + 1 + i);
1477         }
1478 
1479     }
1480 
1481     function maxMintForAddress(address wallet) public view returns (uint256) {
1482         if (publicSaleActive) {
1483             if (maxPublicMintPerWallet >= publicMinted[wallet]) {
1484                 return maxPublicMintPerWallet - publicMinted[wallet];
1485             }
1486             return 0;
1487         }
1488         return privateSaleActive ? whitelistForPrivate[wallet] : 0;
1489     }
1490 
1491     function setWhitelistForPrivate(address[] calldata addresses, uint256[] calldata amountToMint) public onlyOwner {
1492         require(addresses.length == amountToMint.length, "Invalid parameters");
1493         for (uint256 i; i < addresses.length; i++) {
1494             whitelistForPrivate[addresses[i]] = amountToMint[i];
1495         }
1496     }
1497 
1498     function walletOfOwner(address owner) external view returns(uint256[] memory) {
1499         uint256 tokenCount = balanceOf(owner);
1500 
1501         uint256[] memory tokensId = new uint256[](tokenCount);
1502         for (uint256 i; i < tokenCount; i++) {
1503             tokensId[i] = tokenOfOwnerByIndex(owner, i);
1504         }
1505         return tokensId;
1506     }
1507 
1508     function withdraw() public onlyOwner {
1509         payable(msg.sender).transfer(address(this).balance);
1510     }
1511 
1512     function setPrivateSale(bool active) public onlyOwner {
1513         privateSaleActive = active;
1514     }
1515 
1516     function setPublicSale(bool active) public onlyOwner {
1517         publicSaleActive = active;
1518     }
1519 
1520     function setPriceForPublic(uint256 newPrice) public onlyOwner {
1521         priceForPublic = newPrice;
1522     }
1523 
1524     function setPriceForPrivate(uint256 newPrice) public onlyOwner {
1525         priceForPrivate = newPrice;
1526     }
1527 
1528     function setMaxPublicMintPerWallet(uint256 newMaxPublicMintPerWallet) public onlyOwner {
1529         maxPublicMintPerWallet = newMaxPublicMintPerWallet;
1530     }
1531 
1532     function setBaseURI(string memory uri) public onlyOwner {
1533         baseURI = uri;
1534     }
1535 
1536     function setSuffixURI(string memory suffixUri) public onlyOwner {
1537         suffixURI = suffixUri;
1538     }
1539 
1540     function setRevealed(bool newRevealed) public onlyOwner {
1541         revealed = newRevealed;
1542     }
1543 
1544     function setMaxMintPerTx(uint256 newMaxMintPerTx) public onlyOwner {
1545         maxMintPerTx = newMaxMintPerTx;
1546     }
1547 
1548     function _baseURI() internal view override returns (string memory) {
1549         return baseURI;
1550     }
1551 
1552     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1553         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1554 
1555         string memory base = _baseURI();
1556         if(!revealed){
1557             return bytes(base).length > 0 ? string(abi.encodePacked(base)) : "";
1558         }
1559         return bytes(base).length > 0 ? string(abi.encodePacked(base, uint2str(tokenId), suffixURI)) : "";
1560     }
1561 
1562     function uint2str(uint _i) private pure returns (string memory _uintAsString) {
1563         if (_i == 0) {
1564             return "0";
1565         }
1566         uint j = _i;
1567         uint len;
1568         while (j != 0) {
1569             len++;
1570             j /= 10;
1571         }
1572         bytes memory bstr = new bytes(len);
1573         uint k = len;
1574         while (_i != 0) {
1575             k = k-1;
1576             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1577             bytes1 b1 = bytes1(temp);
1578             bstr[k] = b1;
1579             _i /= 10;
1580         }
1581         return string(bstr);
1582     }
1583 
1584 }