1 /**
2 *  @author everest
3 **/
4 
5 
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity ^0.8.15;
9 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
33 
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(
82         address from,
83         address to,
84         uint256 tokenId,
85         bytes calldata data
86     ) external;
87 
88     /**
89      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
90      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must exist and be owned by `from`.
97      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
98      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
99      *
100      * Emits a {Transfer} event.
101      */
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Transfers `tokenId` token from `from` to `to`.
110      *
111      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must be owned by `from`.
118      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(
123         address from,
124         address to,
125         uint256 tokenId
126     ) external;
127 
128     /**
129      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
130      * The approval is cleared when the token is transferred.
131      *
132      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
133      *
134      * Requirements:
135      *
136      * - The caller must own the token or be an approved operator.
137      * - `tokenId` must exist.
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address to, uint256 tokenId) external;
142 
143     /**
144      * @dev Approve or remove `operator` as an operator for the caller.
145      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
146      *
147      * Requirements:
148      *
149      * - The `operator` cannot be the caller.
150      *
151      * Emits an {ApprovalForAll} event.
152      */
153     function setApprovalForAll(address operator, bool _approved) external;
154 
155     /**
156      * @dev Returns the account approved for `tokenId` token.
157      *
158      * Requirements:
159      *
160      * - `tokenId` must exist.
161      */
162     function getApproved(uint256 tokenId) external view returns (address operator);
163 
164     /**
165      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
166      *
167      * See {setApprovalForAll}
168      */
169     function isApprovedForAll(address owner, address operator) external view returns (bool);
170 }
171 
172 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
173 
174 
175 
176 /**
177  * @title ERC721 token receiver interface
178  * @dev Interface for any contract that wants to support safeTransfers
179  * from ERC721 asset contracts.
180  */
181 interface IERC721Receiver {
182     /**
183      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
184      * by `operator` from `from`, this function is called.
185      *
186      * It must return its Solidity selector to confirm the token transfer.
187      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
188      *
189      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
190      */
191     function onERC721Received(
192         address operator,
193         address from,
194         uint256 tokenId,
195         bytes calldata data
196     ) external returns (bytes4);
197 }
198 
199 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
200 
201 
202 /**
203  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
204  * @dev See https://eips.ethereum.org/EIPS/eip-721
205  */
206 interface IERC721Metadata is IERC721 {
207     /**
208      * @dev Returns the token collection name.
209      */
210     function name() external view returns (string memory);
211 
212     /**
213      * @dev Returns the token collection symbol.
214      */
215     function symbol() external view returns (string memory);
216 
217     /**
218      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
219      */
220     function tokenURI(uint256 tokenId) external view returns (string memory);
221 }
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
239      *
240      * [IMPORTANT]
241      * ====
242      * You shouldn't rely on `isContract` to protect against flash loan attacks!
243      *
244      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
245      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
246      * constructor.
247      * ====
248      */
249     function isContract(address account) internal view returns (bool) {
250         // This method relies on extcodesize/address.code.length, which returns 0
251         // for contracts in construction, since the code is only stored at the end
252         // of the constructor execution.
253 
254         return account.code.length > 0;
255     }
256 
257     /**
258      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
259      * `recipient`, forwarding all available gas and reverting on errors.
260      *
261      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
262      * of certain opcodes, possibly making contracts go over the 2300 gas limit
263      * imposed by `transfer`, making them unable to receive funds via
264      * `transfer`. {sendValue} removes this limitation.
265      *
266      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
267      *
268      * IMPORTANT: because control is transferred to `recipient`, care must be
269      * taken to not create reentrancy vulnerabilities. Consider using
270      * {ReentrancyGuard} or the
271      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
272      */
273     function sendValue(address payable recipient, uint256 amount) internal {
274         require(address(this).balance >= amount, "Address: insufficient balance");
275 
276         (bool success, ) = recipient.call{value: amount}("");
277         require(success, "Address: unable to send value, recipient may have reverted");
278     }
279 
280     /**
281      * @dev Performs a Solidity function call using a low level `call`. A
282      * plain `call` is an unsafe replacement for a function call: use this
283      * function instead.
284      *
285      * If `target` reverts with a revert reason, it is bubbled up by this
286      * function (like regular Solidity function calls).
287      *
288      * Returns the raw returned data. To convert to the expected return value,
289      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
290      *
291      * Requirements:
292      *
293      * - `target` must be a contract.
294      * - calling `target` with `data` must not revert.
295      *
296      * _Available since v3.1._
297      */
298     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
299         return functionCall(target, data, "Address: low-level call failed");
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
304      * `errorMessage` as a fallback revert reason when `target` reverts.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(
309         address target,
310         bytes memory data,
311         string memory errorMessage
312     ) internal returns (bytes memory) {
313         return functionCallWithValue(target, data, 0, errorMessage);
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318      * but also transferring `value` wei to `target`.
319      *
320      * Requirements:
321      *
322      * - the calling contract must have an ETH balance of at least `value`.
323      * - the called Solidity function must be `payable`.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(
328         address target,
329         bytes memory data,
330         uint256 value
331     ) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
337      * with `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value,
345         string memory errorMessage
346     ) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         require(isContract(target), "Address: call to non-contract");
349 
350         (bool success, bytes memory returndata) = target.call{value: value}(data);
351         return verifyCallResult(success, returndata, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but performing a static call.
357      *
358      * _Available since v3.3._
359      */
360     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
361         return functionStaticCall(target, data, "Address: low-level static call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal view returns (bytes memory) {
375         require(isContract(target), "Address: static call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.staticcall(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but performing a delegate call.
384      *
385      * _Available since v3.4._
386      */
387     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
388         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
393      * but performing a delegate call.
394      *
395      * _Available since v3.4._
396      */
397     function functionDelegateCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         require(isContract(target), "Address: delegate call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.delegatecall(data);
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
410      * revert reason using the provided one.
411      *
412      * _Available since v4.3._
413      */
414     function verifyCallResult(
415         bool success,
416         bytes memory returndata,
417         string memory errorMessage
418     ) internal pure returns (bytes memory) {
419         if (success) {
420             return returndata;
421         } else {
422             // Look for revert reason and bubble it up if present
423             if (returndata.length > 0) {
424                 // The easiest way to bubble the revert reason is using memory via assembly
425 
426                 assembly {
427                     let returndata_size := mload(returndata)
428                     revert(add(32, returndata), returndata_size)
429                 }
430             } else {
431                 revert(errorMessage);
432             }
433         }
434     }
435 }
436 abstract contract Context {
437     function _msgSender() internal view virtual returns (address) {
438         return msg.sender;
439     }
440 
441     function _msgData() internal view virtual returns (bytes calldata) {
442         return msg.data;
443     }
444 }
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
504 abstract contract ERC165 is IERC165 {
505     /**
506      * @dev See {IERC165-supportsInterface}.
507      */
508     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
509         return interfaceId == type(IERC165).interfaceId;
510     }
511 }
512 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
513     using Address for address;
514     using Strings for uint256;
515 
516     // Token name
517     string private _name;
518 
519     // Token symbol
520     string private _symbol;
521 
522     // Mapping from token ID to owner address
523     mapping(uint256 => address) private _owners;
524 
525     // Mapping owner address to token count
526     mapping(address => uint256) private _balances;
527 
528     // Mapping from token ID to approved address
529     mapping(uint256 => address) private _tokenApprovals;
530 
531     // Mapping from owner to operator approvals
532     mapping(address => mapping(address => bool)) private _operatorApprovals;
533 
534     /**
535      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
536      */
537     constructor(string memory name_, string memory symbol_) {
538         _name = name_;
539         _symbol = symbol_;
540     }
541 
542     /**
543      * @dev See {IERC165-supportsInterface}.
544      */
545     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
546         return
547         interfaceId == type(IERC721).interfaceId ||
548         interfaceId == type(IERC721Metadata).interfaceId ||
549         super.supportsInterface(interfaceId);
550     }
551 
552     /**
553      * @dev See {IERC721-balanceOf}.
554      */
555     function balanceOf(address owner) public view virtual override returns (uint256) {
556         require(owner != address(0), "ERC721: balance query for the zero address");
557         return _balances[owner];
558     }
559 
560     /**
561      * @dev See {IERC721-ownerOf}.
562      */
563     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
564         address owner = _owners[tokenId];
565         require(owner != address(0), "ERC721: owner query for nonexistent token");
566         return owner;
567     }
568 
569     /**
570      * @dev See {IERC721Metadata-name}.
571      */
572     function name() public view virtual override returns (string memory) {
573         return _name;
574     }
575 
576     /**
577      * @dev See {IERC721Metadata-symbol}.
578      */
579     function symbol() public view virtual override returns (string memory) {
580         return _symbol;
581     }
582 
583     /**
584      * @dev See {IERC721Metadata-tokenURI}.
585      */
586     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
587         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
588 
589         string memory baseURI = _baseURI();
590         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
591     }
592 
593     /**
594      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
595      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
596      * by default, can be overridden in child contracts.
597      */
598     function _baseURI() internal view virtual returns (string memory) {
599         return "";
600     }
601 
602     /**
603      * @dev See {IERC721-approve}.
604      */
605     function approve(address to, uint256 tokenId) public virtual override {
606         address owner = ERC721.ownerOf(tokenId);
607         require(to != owner, "ERC721: approval to current owner");
608 
609         require(
610             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
611             "ERC721: approve caller is not owner nor approved for all"
612         );
613 
614         _approve(to, tokenId);
615     }
616 
617     /**
618      * @dev See {IERC721-getApproved}.
619      */
620     function getApproved(uint256 tokenId) public view virtual override returns (address) {
621         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
622 
623         return _tokenApprovals[tokenId];
624     }
625 
626     /**
627      * @dev See {IERC721-setApprovalForAll}.
628      */
629     function setApprovalForAll(address operator, bool approved) public virtual override {
630         _setApprovalForAll(_msgSender(), operator, approved);
631     }
632 
633     /**
634      * @dev See {IERC721-isApprovedForAll}.
635      */
636     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
637         return _operatorApprovals[owner][operator];
638     }
639 
640     /**
641      * @dev See {IERC721-transferFrom}.
642      */
643     function transferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) public virtual override {
648         //solhint-disable-next-line max-line-length
649         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
650 
651         _transfer(from, to, tokenId);
652     }
653 
654     /**
655      * @dev See {IERC721-safeTransferFrom}.
656      */
657     function safeTransferFrom(
658         address from,
659         address to,
660         uint256 tokenId
661     ) public virtual override {
662         safeTransferFrom(from, to, tokenId, "");
663     }
664 
665     /**
666      * @dev See {IERC721-safeTransferFrom}.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId,
672         bytes memory _data
673     ) public virtual override {
674         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
675         _safeTransfer(from, to, tokenId, _data);
676     }
677 
678     /**
679      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
680      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
681      *
682      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
683      *
684      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
685      * implement alternative mechanisms to perform token transfer, such as signature-based.
686      *
687      * Requirements:
688      *
689      * - `from` cannot be the zero address.
690      * - `to` cannot be the zero address.
691      * - `tokenId` token must exist and be owned by `from`.
692      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
693      *
694      * Emits a {Transfer} event.
695      */
696     function _safeTransfer(
697         address from,
698         address to,
699         uint256 tokenId,
700         bytes memory _data
701     ) internal virtual {
702         _transfer(from, to, tokenId);
703         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
704     }
705 
706     /**
707      * @dev Returns whether `tokenId` exists.
708      *
709      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
710      *
711      * Tokens start existing when they are minted (`_mint`),
712      * and stop existing when they are burned (`_burn`).
713      */
714     function _exists(uint256 tokenId) internal view virtual returns (bool) {
715         return _owners[tokenId] != address(0);
716     }
717 
718     /**
719      * @dev Returns whether `spender` is allowed to manage `tokenId`.
720      *
721      * Requirements:
722      *
723      * - `tokenId` must exist.
724      */
725     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
726         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
727         address owner = ERC721.ownerOf(tokenId);
728         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
729     }
730 
731     /**
732      * @dev Safely mints `tokenId` and transfers it to `to`.
733      *
734      * Requirements:
735      *
736      * - `tokenId` must not exist.
737      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
738      *
739      * Emits a {Transfer} event.
740      */
741     function _safeMint(address to, uint256 tokenId) internal virtual {
742         _safeMint(to, tokenId, "");
743     }
744 
745     /**
746      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
747      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
748      */
749     function _safeMint(
750         address to,
751         uint256 tokenId,
752         bytes memory _data
753     ) internal virtual {
754         _mint(to, tokenId);
755         require(
756             _checkOnERC721Received(address(0), to, tokenId, _data),
757             "ERC721: transfer to non ERC721Receiver implementer"
758         );
759     }
760 
761     /**
762      * @dev Mints `tokenId` and transfers it to `to`.
763      *
764      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
765      *
766      * Requirements:
767      *
768      * - `tokenId` must not exist.
769      * - `to` cannot be the zero address.
770      *
771      * Emits a {Transfer} event.
772      */
773     function _mint(address to, uint256 tokenId) internal virtual {
774         require(to != address(0), "ERC721: mint to the zero address");
775         require(!_exists(tokenId), "ERC721: token already minted");
776 
777         _beforeTokenTransfer(address(0), to, tokenId);
778 
779         _balances[to] += 1;
780         _owners[tokenId] = to;
781 
782         emit Transfer(address(0), to, tokenId);
783 
784         _afterTokenTransfer(address(0), to, tokenId);
785     }
786 
787     /**
788      * @dev Destroys `tokenId`.
789      * The approval is cleared when the token is burned.
790      *
791      * Requirements:
792      *
793      * - `tokenId` must exist.
794      *
795      * Emits a {Transfer} event.
796      */
797     function _burn(uint256 tokenId) internal virtual {
798         address owner = ERC721.ownerOf(tokenId);
799 
800         _beforeTokenTransfer(owner, address(0), tokenId);
801 
802         // Clear approvals
803         _approve(address(0), tokenId);
804 
805         _balances[owner] -= 1;
806         delete _owners[tokenId];
807 
808         emit Transfer(owner, address(0), tokenId);
809 
810         _afterTokenTransfer(owner, address(0), tokenId);
811     }
812 
813     /**
814      * @dev Transfers `tokenId` from `from` to `to`.
815      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
816      *
817      * Requirements:
818      *
819      * - `to` cannot be the zero address.
820      * - `tokenId` token must be owned by `from`.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _transfer(
825         address from,
826         address to,
827         uint256 tokenId
828     ) internal virtual {
829         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
830         require(to != address(0), "ERC721: transfer to the zero address");
831 
832         _beforeTokenTransfer(from, to, tokenId);
833 
834         // Clear approvals from the previous owner
835         _approve(address(0), tokenId);
836 
837         _balances[from] -= 1;
838         _balances[to] += 1;
839         _owners[tokenId] = to;
840 
841         emit Transfer(from, to, tokenId);
842 
843         _afterTokenTransfer(from, to, tokenId);
844     }
845 
846     /**
847      * @dev Approve `to` to operate on `tokenId`
848      *
849      * Emits a {Approval} event.
850      */
851     function _approve(address to, uint256 tokenId) internal virtual {
852         _tokenApprovals[tokenId] = to;
853         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
854     }
855 
856     /**
857      * @dev Approve `operator` to operate on all of `owner` tokens
858      *
859      * Emits a {ApprovalForAll} event.
860      */
861     function _setApprovalForAll(
862         address owner,
863         address operator,
864         bool approved
865     ) internal virtual {
866         require(owner != operator, "ERC721: approve to caller");
867         _operatorApprovals[owner][operator] = approved;
868         emit ApprovalForAll(owner, operator, approved);
869     }
870 
871     /**
872      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
873      * The call is not executed if the target address is not a contract.
874      *
875      * @param from address representing the previous owner of the given token ID
876      * @param to target address that will receive the tokens
877      * @param tokenId uint256 ID of the token to be transferred
878      * @param _data bytes optional data to send along with the call
879      * @return bool whether the call correctly returned the expected magic value
880      */
881     function _checkOnERC721Received(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes memory _data
886     ) private returns (bool) {
887         if (to.isContract()) {
888             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
889                 return retval == IERC721Receiver.onERC721Received.selector;
890             } catch (bytes memory reason) {
891                 if (reason.length == 0) {
892                     revert("ERC721: transfer to non ERC721Receiver implementer");
893                 } else {
894                     assembly {
895                         revert(add(32, reason), mload(reason))
896                     }
897                 }
898             }
899         } else {
900             return true;
901         }
902     }
903 
904     /**
905      * @dev Hook that is called before any token transfer. This includes minting
906      * and burning.
907      *
908      * Calling conditions:
909      *
910      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
911      * transferred to `to`.
912      * - When `from` is zero, `tokenId` will be minted for `to`.
913      * - When `to` is zero, ``from``'s `tokenId` will be burned.
914      * - `from` and `to` are never both zero.
915      *
916      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
917      */
918     function _beforeTokenTransfer(
919         address from,
920         address to,
921         uint256 tokenId
922     ) internal virtual {}
923 
924     /**
925      * @dev Hook that is called after any transfer of tokens. This includes
926      * minting and burning.
927      *
928      * Calling conditions:
929      *
930      * - when `from` and `to` are both non-zero.
931      * - `from` and `to` are never both zero.
932      *
933      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
934      */
935     function _afterTokenTransfer(
936         address from,
937         address to,
938         uint256 tokenId
939     ) internal virtual {}
940 }
941 abstract contract Ownable is Context {
942     address private _owner;
943 
944     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
945 
946     /**
947      * @dev Initializes the contract setting the deployer as the initial owner.
948      */
949     constructor() {
950         _transferOwnership(_msgSender());
951     }
952 
953     /**
954      * @dev Returns the address of the current owner.
955      */
956     function owner() public view virtual returns (address) {
957         return _owner;
958     }
959 
960     /**
961      * @dev Throws if called by any account other than the owner.
962      */
963     modifier onlyOwner() {
964         require(owner() == _msgSender(), "Ownable: caller is not the owner");
965         _;
966     }
967 
968     /**
969      * @dev Leaves the contract without owner. It will not be possible to call
970      * `onlyOwner` functions anymore. Can only be called by the current owner.
971      *
972      * NOTE: Renouncing ownership will leave the contract without an owner,
973      * thereby removing any functionality that is only available to the owner.
974      */
975     function renounceOwnership() public virtual onlyOwner {
976         _transferOwnership(address(0));
977     }
978 
979     /**
980      * @dev Transfers ownership of the contract to a new account (`newOwner`).
981      * Can only be called by the current owner.
982      */
983     function transferOwnership(address newOwner) public virtual onlyOwner {
984         require(newOwner != address(0), "Ownable: new owner is the zero address");
985         _transferOwnership(newOwner);
986     }
987 
988     /**
989      * @dev Transfers ownership of the contract to a new account (`newOwner`).
990      * Internal function without access restriction.
991      */
992     function _transferOwnership(address newOwner) internal virtual {
993         address oldOwner = _owner;
994         _owner = newOwner;
995         emit OwnershipTransferred(oldOwner, newOwner);
996     }
997 }
998 library Counters {
999     struct Counter {
1000         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1001         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1002         // this feature: see https://github.com/ethereum/solidity/issues/4637
1003         uint256 _value; // default: 0
1004     }
1005 
1006     function current(Counter storage counter) internal view returns (uint256) {
1007         return counter._value;
1008     }
1009 
1010     function increment(Counter storage counter) internal {
1011     unchecked {
1012         counter._value += 1;
1013     }
1014     }
1015 
1016     function decrement(Counter storage counter) internal {
1017         uint256 value = counter._value;
1018         require(value > 0, "Counter: decrement overflow");
1019     unchecked {
1020         counter._value = value - 1;
1021     }
1022     }
1023 
1024     function reset(Counter storage counter) internal {
1025         counter._value = 0;
1026     }
1027 }
1028 abstract contract ReentrancyGuard {
1029     // Booleans are more expensive than uint256 or any type that takes up a full
1030     // word because each write operation emits an extra SLOAD to first read the
1031     // slot's contents, replace the bits taken up by the boolean, and then write
1032     // back. This is the compiler's defense against contract upgrades and
1033     // pointer aliasing, and it cannot be disabled.
1034 
1035     // The values being non-zero value makes deployment a bit more expensive,
1036     // but in exchange the refund on every call to nonReentrant will be lower in
1037     // amount. Since refunds are capped to a percentage of the total
1038     // transaction's gas, it is best to keep them low in cases like this one, to
1039     // increase the likelihood of the full refund coming into effect.
1040     uint256 private constant _NOT_ENTERED = 1;
1041     uint256 private constant _ENTERED = 2;
1042 
1043     uint256 private _status;
1044 
1045     constructor() {
1046         _status = _NOT_ENTERED;
1047     }
1048 
1049     /**
1050      * @dev Prevents a contract from calling itself, directly or indirectly.
1051      * Calling a `nonReentrant` function from another `nonReentrant`
1052      * function is not supported. It is possible to prevent this from happening
1053      * by making the `nonReentrant` function external, and making it call a
1054      * `private` function that does the actual work.
1055      */
1056     modifier nonReentrant() {
1057         // On the first call to nonReentrant, _notEntered will be true
1058         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1059 
1060         // Any calls to nonReentrant after this point will fail
1061         _status = _ENTERED;
1062 
1063         _;
1064 
1065         // By storing the original value once again, a refund is triggered (see
1066         // https://eips.ethereum.org/EIPS/eip-2200)
1067         _status = _NOT_ENTERED;
1068     }
1069 }
1070 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1071 
1072 /**
1073  * @dev These functions deal with verification of Merkle Tree proofs.
1074  *
1075  * The proofs can be generated using the JavaScript library
1076  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1077  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1078  *
1079  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1080  *
1081  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1082  * hashing, or use a hash function other than keccak256 for hashing leaves.
1083  * This is because the concatenation of a sorted pair of internal nodes in
1084  * the merkle tree could be reinterpreted as a leaf value.
1085  */
1086 library MerkleProof {
1087     /**
1088      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1089      * defined by `root`. For this, a `proof` must be provided, containing
1090      * sibling hashes on the branch from the leaf to the root of the tree. Each
1091      * pair of leaves and each pair of pre-images are assumed to be sorted.
1092      */
1093     function verify(
1094         bytes32[] memory proof,
1095         bytes32 root,
1096         bytes32 leaf
1097     ) internal pure returns (bool) {
1098         return processProof(proof, leaf) == root;
1099     }
1100 
1101     /**
1102      * @dev Calldata version of {verify}
1103      *
1104      * _Available since v4.7._
1105      */
1106     function verifyCalldata(
1107         bytes32[] calldata proof,
1108         bytes32 root,
1109         bytes32 leaf
1110     ) internal pure returns (bool) {
1111         return processProofCalldata(proof, leaf) == root;
1112     }
1113 
1114     /**
1115      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1116      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1117      * hash matches the root of the tree. When processing the proof, the pairs
1118      * of leafs & pre-images are assumed to be sorted.
1119      *
1120      * _Available since v4.4._
1121      */
1122     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1123         bytes32 computedHash = leaf;
1124         for (uint256 i = 0; i < proof.length; i++) {
1125             computedHash = _hashPair(computedHash, proof[i]);
1126         }
1127         return computedHash;
1128     }
1129 
1130     /**
1131      * @dev Calldata version of {processProof}
1132      *
1133      * _Available since v4.7._
1134      */
1135     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1136         bytes32 computedHash = leaf;
1137         for (uint256 i = 0; i < proof.length; i++) {
1138             computedHash = _hashPair(computedHash, proof[i]);
1139         }
1140         return computedHash;
1141     }
1142 
1143     /**
1144      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1145      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1146      *
1147      * _Available since v4.7._
1148      */
1149     function multiProofVerify(
1150         bytes32[] memory proof,
1151         bool[] memory proofFlags,
1152         bytes32 root,
1153         bytes32[] memory leaves
1154     ) internal pure returns (bool) {
1155         return processMultiProof(proof, proofFlags, leaves) == root;
1156     }
1157 
1158     /**
1159      * @dev Calldata version of {multiProofVerify}
1160      *
1161      * _Available since v4.7._
1162      */
1163     function multiProofVerifyCalldata(
1164         bytes32[] calldata proof,
1165         bool[] calldata proofFlags,
1166         bytes32 root,
1167         bytes32[] memory leaves
1168     ) internal pure returns (bool) {
1169         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1170     }
1171 
1172     /**
1173      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1174      * consuming from one or the other at each step according to the instructions given by
1175      * `proofFlags`.
1176      *
1177      * _Available since v4.7._
1178      */
1179     function processMultiProof(
1180         bytes32[] memory proof,
1181         bool[] memory proofFlags,
1182         bytes32[] memory leaves
1183     ) internal pure returns (bytes32 merkleRoot) {
1184         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1185         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1186         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1187         // the merkle tree.
1188         uint256 leavesLen = leaves.length;
1189         uint256 totalHashes = proofFlags.length;
1190 
1191         // Check proof validity.
1192         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1193 
1194         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1195         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1196         bytes32[] memory hashes = new bytes32[](totalHashes);
1197         uint256 leafPos = 0;
1198         uint256 hashPos = 0;
1199         uint256 proofPos = 0;
1200         // At each step, we compute the next hash using two values:
1201         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1202         //   get the next hash.
1203         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1204         //   `proof` array.
1205         for (uint256 i = 0; i < totalHashes; i++) {
1206             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1207             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1208             hashes[i] = _hashPair(a, b);
1209         }
1210 
1211         if (totalHashes > 0) {
1212             return hashes[totalHashes - 1];
1213         } else if (leavesLen > 0) {
1214             return leaves[0];
1215         } else {
1216             return proof[0];
1217         }
1218     }
1219 
1220     /**
1221      * @dev Calldata version of {processMultiProof}
1222      *
1223      * _Available since v4.7._
1224      */
1225     function processMultiProofCalldata(
1226         bytes32[] calldata proof,
1227         bool[] calldata proofFlags,
1228         bytes32[] memory leaves
1229     ) internal pure returns (bytes32 merkleRoot) {
1230         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1231         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1232         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1233         // the merkle tree.
1234         uint256 leavesLen = leaves.length;
1235         uint256 totalHashes = proofFlags.length;
1236 
1237         // Check proof validity.
1238         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1239 
1240         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1241         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1242         bytes32[] memory hashes = new bytes32[](totalHashes);
1243         uint256 leafPos = 0;
1244         uint256 hashPos = 0;
1245         uint256 proofPos = 0;
1246         // At each step, we compute the next hash using two values:
1247         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1248         //   get the next hash.
1249         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1250         //   `proof` array.
1251         for (uint256 i = 0; i < totalHashes; i++) {
1252             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1253             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1254             hashes[i] = _hashPair(a, b);
1255         }
1256 
1257         if (totalHashes > 0) {
1258             return hashes[totalHashes - 1];
1259         } else if (leavesLen > 0) {
1260             return leaves[0];
1261         } else {
1262             return proof[0];
1263         }
1264     }
1265 
1266     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1267         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1268     }
1269 
1270     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1271         /// @solidity memory-safe-assembly
1272         assembly {
1273             mstore(0x00, a)
1274             mstore(0x20, b)
1275             value := keccak256(0x00, 0x40)
1276         }
1277     }
1278 }
1279 // YetiLand Star Here
1280 //
1281 contract YetiLand is ERC721, Ownable, ReentrancyGuard {
1282     using Strings for uint;
1283     using Counters for Counters.Counter;
1284 
1285     struct Sale {
1286         uint maxTokensPerAddress;
1287         uint maxTokensPerTransaction;
1288         uint price;
1289         uint holderPrice;
1290     }
1291     bytes32 public holderMerkleRoot;
1292     bytes32 public claimableMerkleRoot;
1293     string public _provenance;
1294     bool public isClaimLandActive;
1295     bool public isPublicSaleActive;
1296     bool public isHolderSaleActive;
1297     string private baseURI;
1298     // this will change based on snapshot taken
1299     uint public maxClaimLandSupply = 2204;
1300     
1301     uint public maxSupply = 10000;
1302     uint public _reserveTokenId = maxClaimLandSupply;
1303     Sale public sale;
1304     mapping(address => uint8) public alreadyClaimed;
1305     mapping(address => uint8) public claimLandAllowance;
1306     mapping(address => uint) public tokensMintedByAddress;
1307     Counters.Counter private _tokenId;
1308     constructor() ERC721("YetiLand", "YLAND") {}
1309 
1310     function totalSupply() public view returns(uint) {
1311         return _tokenId.current() + _reserveTokenId - maxClaimLandSupply;
1312     }
1313     function mint(uint _mintAmount) public payable {
1314         require(isPublicSaleActive, "Public Sale is not active");
1315         require(_mintAmount > 0, "You must mint at least 1 NFT");
1316         require(sale.maxTokensPerTransaction >= _mintAmount, "Mint per transaction exceeded");
1317         require(tokensMintedByAddress[msg.sender] + _mintAmount <= sale.maxTokensPerAddress, "Max tokens minted for this address");
1318         require(_reserveTokenId + _mintAmount <= maxSupply, "Max supply exceeded");
1319         require(msg.value >= sale.price * _mintAmount, "Please send the correct amount of ETH");
1320         for (uint i = 0; i < _mintAmount; i++) {
1321             _safeMint(msg.sender, _reserveTokenId);
1322             _reserveTokenId++;
1323         }
1324         tokensMintedByAddress[msg.sender] += _mintAmount;
1325     }
1326     function mintHolder(uint _mintAmount, bytes32[] memory merkleProof) public payable {
1327         require(isHolderSaleActive, "Holder Sale is not active");
1328         require(_mintAmount > 0, "You must mint at least 1 NFT");
1329         require(sale.maxTokensPerTransaction >= _mintAmount, "Mint per transaction exceeded");
1330         require(isSYHolder(msg.sender, merkleProof), "Please use correct Holder address");
1331         require(tokensMintedByAddress[msg.sender] + _mintAmount <= sale.maxTokensPerAddress, "Max tokens minted for this address");
1332         require(_reserveTokenId + _mintAmount <= maxSupply, "Max supply exceeded");
1333         require(msg.value >= sale.holderPrice * _mintAmount, "Please send the correct amount of ETH");
1334         for (uint i = 0; i < _mintAmount; i++) {
1335             _safeMint(msg.sender, _reserveTokenId);
1336             _reserveTokenId++;
1337         }
1338         tokensMintedByAddress[msg.sender] += _mintAmount;
1339     }
1340     // Will be used for pair that have more that 50 claim
1341     function claimLandChunk(uint _claimAmount) public {
1342         require(isClaimLandActive, "Claim land is inactive");
1343         uint _allowance = claimLandAllowance[msg.sender];
1344         require(_allowance >= _claimAmount, "You have no land to claim");
1345         require(_tokenId.current()  + _allowance <= maxSupply, "Max supply exceeded");
1346         for (uint i = 0; i < _claimAmount; i++) {
1347             _safeMint(msg.sender, _tokenId.current());
1348             _tokenId.increment();
1349             claimLandAllowance[msg.sender]--;
1350             alreadyClaimed[msg.sender]++;
1351         }
1352     }
1353     // use merkle proof for claim
1354     function claimLand(uint8 _claimAmount, bytes32[] calldata merkleProof) public {
1355         require(isClaimLandActive, "Claim land is inactive");
1356         require(alreadyClaimed[msg.sender] == 0, "Already Claimed");
1357         require(isClaimable(_claimAmount, msg.sender, merkleProof), "Please use correct Claimable address");
1358         require(_tokenId.current()  + _claimAmount <= maxSupply, "Max supply exceeded");
1359         for (uint i = 0; i < _claimAmount; i++) {
1360             _safeMint(msg.sender, _tokenId.current());
1361             _tokenId.increment();
1362         }
1363         alreadyClaimed[msg.sender]=_claimAmount;
1364     }
1365     function isSYHolder(address claimer, bytes32[] memory _merkleProof) public view returns (bool){
1366         bytes32 leaf = keccak256(abi.encodePacked(claimer));
1367         return MerkleProof.verify(_merkleProof, holderMerkleRoot, leaf);
1368     }
1369     function setHolderList(bytes32 _merkleRoot) public onlyOwner {
1370         holderMerkleRoot = _merkleRoot;
1371     }
1372     function isClaimable(uint _claimAmount, address _claimer, bytes32[] memory _merkleProof) public view returns (bool){
1373         bytes32 leaf = keccak256(abi.encodePacked(_claimer, _claimAmount));
1374         return MerkleProof.verify(_merkleProof,claimableMerkleRoot, leaf);
1375     }
1376     function setClaimableList(bytes32 _merkleRoot) public onlyOwner {
1377         claimableMerkleRoot = _merkleRoot;
1378     }
1379     function _baseURI() internal view override returns (string memory) {
1380         return baseURI;
1381     }
1382     function setBaseURI(string memory uri) public onlyOwner {
1383         baseURI = uri;
1384     }
1385     function setSaleDetails(
1386         uint _maxTokensPerAddress,
1387         uint _maxTokensPerTransaction,
1388         uint _price,
1389         uint _holderPrice
1390     ) public onlyOwner {
1391         sale.maxTokensPerAddress = _maxTokensPerAddress;
1392         sale.maxTokensPerTransaction = _maxTokensPerTransaction;
1393         sale.price = _price;
1394         sale.holderPrice = _holderPrice;
1395     }
1396     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1397         _provenance = provenanceHash;
1398     }
1399     function setMaxClaimLandSupply(uint _maxClaimLandSupply) public onlyOwner {
1400         maxClaimLandSupply = _maxClaimLandSupply;
1401     }
1402     // if need incase when the max claim supply changes
1403     function setReserveTokenId(uint changereserveTokenId) public onlyOwner {
1404         _reserveTokenId = changereserveTokenId;
1405     }
1406     
1407     function setClaimLandActive(bool _state) public onlyOwner {
1408         isClaimLandActive = _state;
1409     }
1410     function setPublicSaleActive(bool _state) public onlyOwner {
1411         isPublicSaleActive = _state;
1412     }
1413     function setHolderSaleActive(bool _state) public onlyOwner {
1414         isHolderSaleActive = _state;
1415     }
1416     function setClaimLandAllowance(address[] calldata _users, uint8[] calldata _allowances) public onlyOwner {
1417         require(_users.length == _allowances.length, "Length mismatch");
1418         for(uint i = 0; i < _users.length; i++) {
1419             claimLandAllowance[_users[i]] = _allowances[i];
1420         }
1421     }
1422     function withdraw() public payable onlyOwner {
1423         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1424         require(success, "Withdrawal of funds failed");
1425     }
1426 }