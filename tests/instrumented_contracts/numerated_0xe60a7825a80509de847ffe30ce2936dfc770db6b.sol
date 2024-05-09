1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
5 
6 
7 // Part: Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         assembly {
37             size := extcodesize(account)
38         }
39         return size > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         (bool success, ) = recipient.call{value: amount}("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain `call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but also transferring `value` wei to `target`.
104      *
105      * Requirements:
106      *
107      * - the calling contract must have an ETH balance of at least `value`.
108      * - the called Solidity function must be `payable`.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
122      * with `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         require(isContract(target), "Address: call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.call{value: value}(data);
136         return _verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return _verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(isContract(target), "Address: delegate call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return _verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     function _verifyCallResult(
194         bool success,
195         bytes memory returndata,
196         string memory errorMessage
197     ) private pure returns (bytes memory) {
198         if (success) {
199             return returndata;
200         } else {
201             // Look for revert reason and bubble it up if present
202             if (returndata.length > 0) {
203                 // The easiest way to bubble the revert reason is using memory via assembly
204 
205                 assembly {
206                     let returndata_size := mload(returndata)
207                     revert(add(32, returndata), returndata_size)
208                 }
209             } else {
210                 revert(errorMessage);
211             }
212         }
213     }
214 }
215 
216 // Part: Context
217 
218 /*
219  * @dev Provides information about the current execution context, including the
220  * sender of the transaction and its data. While these are generally available
221  * via msg.sender and msg.data, they should not be accessed in such a direct
222  * manner, since when dealing with meta-transactions the account sending and
223  * paying for execution may not be the actual sender (as far as an application
224  * is concerned).
225  *
226  * This contract is only required for intermediate, library-like contracts.
227  */
228 abstract contract Context {
229     function _msgSender() internal view virtual returns (address) {
230         return msg.sender;
231     }
232 
233     function _msgData() internal view virtual returns (bytes calldata) {
234         return msg.data;
235     }
236 }
237 
238 // Part: IERC165
239 
240 /**
241  * @dev Interface of the ERC165 standard, as defined in the
242  * https://eips.ethereum.org/EIPS/eip-165[EIP].
243  *
244  * Implementers can declare support of contract interfaces, which can then be
245  * queried by others ({ERC165Checker}).
246  *
247  * For an implementation, see {ERC165}.
248  */
249 interface IERC165 {
250     /**
251      * @dev Returns true if this contract implements the interface defined by
252      * `interfaceId`. See the corresponding
253      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
254      * to learn more about how these ids are created.
255      *
256      * This function call must use less than 30 000 gas.
257      */
258     function supportsInterface(bytes4 interfaceId) external view returns (bool);
259 }
260 
261 // Part: IERC721Receiver
262 
263 /**
264  * @title ERC721 token receiver interface
265  * @dev Interface for any contract that wants to support safeTransfers
266  * from ERC721 asset contracts.
267  */
268 interface IERC721Receiver {
269     /**
270      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
271      * by `operator` from `from`, this function is called.
272      *
273      * It must return its Solidity selector to confirm the token transfer.
274      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
275      *
276      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
277      */
278     function onERC721Received(
279         address operator,
280         address from,
281         uint256 tokenId,
282         bytes calldata data
283     ) external returns (bytes4);
284 }
285 
286 // Part: Strings
287 
288 /**
289  * @dev String operations.
290  */
291 library Strings {
292     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
293 
294     /**
295      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
296      */
297     function toString(uint256 value) internal pure returns (string memory) {
298         // Inspired by OraclizeAPI's implementation - MIT licence
299         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
300 
301         if (value == 0) {
302             return "0";
303         }
304         uint256 temp = value;
305         uint256 digits;
306         while (temp != 0) {
307             digits++;
308             temp /= 10;
309         }
310         bytes memory buffer = new bytes(digits);
311         while (value != 0) {
312             digits -= 1;
313             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
314             value /= 10;
315         }
316         return string(buffer);
317     }
318 
319     /**
320      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
321      */
322     function toHexString(uint256 value) internal pure returns (string memory) {
323         if (value == 0) {
324             return "0x00";
325         }
326         uint256 temp = value;
327         uint256 length = 0;
328         while (temp != 0) {
329             length++;
330             temp >>= 8;
331         }
332         return toHexString(value, length);
333     }
334 
335     /**
336      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
337      */
338     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
339         bytes memory buffer = new bytes(2 * length + 2);
340         buffer[0] = "0";
341         buffer[1] = "x";
342         for (uint256 i = 2 * length + 1; i > 1; --i) {
343             buffer[i] = _HEX_SYMBOLS[value & 0xf];
344             value >>= 4;
345         }
346         require(value == 0, "Strings: hex length insufficient");
347         return string(buffer);
348     }
349 }
350 
351 // Part: ERC165
352 
353 /**
354  * @dev Implementation of the {IERC165} interface.
355  *
356  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
357  * for the additional interface id that will be supported. For example:
358  *
359  * ```solidity
360  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
361  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
362  * }
363  * ```
364  *
365  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
366  */
367 abstract contract ERC165 is IERC165 {
368     /**
369      * @dev See {IERC165-supportsInterface}.
370      */
371     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
372         return interfaceId == type(IERC165).interfaceId;
373     }
374 }
375 
376 // Part: IERC721
377 
378 /**
379  * @dev Required interface of an ERC721 compliant contract.
380  */
381 interface IERC721 is IERC165 {
382     /**
383      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
384      */
385     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
386 
387     /**
388      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
389      */
390     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
391 
392     /**
393      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
394      */
395     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
396 
397     /**
398      * @dev Returns the number of tokens in ``owner``'s account.
399      */
400     function balanceOf(address owner) external view returns (uint256 balance);
401 
402     /**
403      * @dev Returns the owner of the `tokenId` token.
404      *
405      * Requirements:
406      *
407      * - `tokenId` must exist.
408      */
409     function ownerOf(uint256 tokenId) external view returns (address owner);
410 
411     /**
412      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
413      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
414      *
415      * Requirements:
416      *
417      * - `from` cannot be the zero address.
418      * - `to` cannot be the zero address.
419      * - `tokenId` token must exist and be owned by `from`.
420      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
421      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
422      *
423      * Emits a {Transfer} event.
424      */
425     function safeTransferFrom(
426         address from,
427         address to,
428         uint256 tokenId
429     ) external;
430 
431     /**
432      * @dev Transfers `tokenId` token from `from` to `to`.
433      *
434      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
435      *
436      * Requirements:
437      *
438      * - `from` cannot be the zero address.
439      * - `to` cannot be the zero address.
440      * - `tokenId` token must be owned by `from`.
441      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
442      *
443      * Emits a {Transfer} event.
444      */
445     function transferFrom(
446         address from,
447         address to,
448         uint256 tokenId
449     ) external;
450 
451     /**
452      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
453      * The approval is cleared when the token is transferred.
454      *
455      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
456      *
457      * Requirements:
458      *
459      * - The caller must own the token or be an approved operator.
460      * - `tokenId` must exist.
461      *
462      * Emits an {Approval} event.
463      */
464     function approve(address to, uint256 tokenId) external;
465 
466     /**
467      * @dev Returns the account approved for `tokenId` token.
468      *
469      * Requirements:
470      *
471      * - `tokenId` must exist.
472      */
473     function getApproved(uint256 tokenId) external view returns (address operator);
474 
475     /**
476      * @dev Approve or remove `operator` as an operator for the caller.
477      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
478      *
479      * Requirements:
480      *
481      * - The `operator` cannot be the caller.
482      *
483      * Emits an {ApprovalForAll} event.
484      */
485     function setApprovalForAll(address operator, bool _approved) external;
486 
487     /**
488      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
489      *
490      * See {setApprovalForAll}
491      */
492     function isApprovedForAll(address owner, address operator) external view returns (bool);
493 
494     /**
495      * @dev Safely transfers `tokenId` token from `from` to `to`.
496      *
497      * Requirements:
498      *
499      * - `from` cannot be the zero address.
500      * - `to` cannot be the zero address.
501      * - `tokenId` token must exist and be owned by `from`.
502      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
503      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
504      *
505      * Emits a {Transfer} event.
506      */
507     function safeTransferFrom(
508         address from,
509         address to,
510         uint256 tokenId,
511         bytes calldata data
512     ) external;
513 }
514 
515 // Part: IERC721Enumerable
516 
517 /**
518  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
519  * @dev See https://eips.ethereum.org/EIPS/eip-721
520  */
521 interface IERC721Enumerable is IERC721 {
522     /**
523      * @dev Returns the total amount of tokens stored by the contract.
524      */
525     function totalSupply() external view returns (uint256);
526 
527     /**
528      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
529      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
530      */
531     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
532 
533     /**
534      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
535      * Use along with {totalSupply} to enumerate all tokens.
536      */
537     function tokenByIndex(uint256 index) external view returns (uint256);
538 }
539 
540 // Part: IERC721Metadata
541 
542 /**
543  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
544  * @dev See https://eips.ethereum.org/EIPS/eip-721
545  */
546 interface IERC721Metadata is IERC721 {
547     /**
548      * @dev Returns the token collection name.
549      */
550     function name() external view returns (string memory);
551 
552     /**
553      * @dev Returns the token collection symbol.
554      */
555     function symbol() external view returns (string memory);
556 
557     /**
558      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
559      */
560     function tokenURI(uint256 tokenId) external view returns (string memory);
561 }
562 
563 // Part: ERC721
564 
565 /**
566  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
567  * the Metadata extension, but not including the Enumerable extension, which is available separately as
568  * {ERC721Enumerable}.
569  */
570 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
571     using Address for address;
572     using Strings for uint256;
573 
574     // Token name
575     string private _name;
576 
577     // Token symbol
578     string private _symbol;
579 
580     // Mapping from token ID to owner address
581     mapping(uint256 => address) private _owners;
582 
583     // Mapping owner address to token count
584     mapping(address => uint256) private _balances;
585 
586     // Mapping from token ID to approved address
587     mapping(uint256 => address) private _tokenApprovals;
588 
589     // Mapping from owner to operator approvals
590     mapping(address => mapping(address => bool)) private _operatorApprovals;
591 
592     /**
593      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
594      */
595     constructor(string memory name_, string memory symbol_) {
596         _name = name_;
597         _symbol = symbol_;
598     }
599 
600     /**
601      * @dev See {IERC165-supportsInterface}.
602      */
603     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
604         return
605             interfaceId == type(IERC721).interfaceId ||
606             interfaceId == type(IERC721Metadata).interfaceId ||
607             super.supportsInterface(interfaceId);
608     }
609 
610     /**
611      * @dev See {IERC721-balanceOf}.
612      */
613     function balanceOf(address owner) public view virtual override returns (uint256) {
614         require(owner != address(0), "ERC721: balance query for the zero address");
615         return _balances[owner];
616     }
617 
618     /**
619      * @dev See {IERC721-ownerOf}.
620      */
621     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
622         address owner = _owners[tokenId];
623         require(owner != address(0), "ERC721: owner query for nonexistent token");
624         return owner;
625     }
626 
627     /**
628      * @dev See {IERC721Metadata-name}.
629      */
630     function name() public view virtual override returns (string memory) {
631         return _name;
632     }
633 
634     /**
635      * @dev See {IERC721Metadata-symbol}.
636      */
637     function symbol() public view virtual override returns (string memory) {
638         return _symbol;
639     }
640 
641     /**
642      * @dev See {IERC721Metadata-tokenURI}.
643      */
644     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
645         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
646 
647         string memory baseURI = _baseURI();
648         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
649     }
650 
651     /**
652      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
653      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
654      * by default, can be overriden in child contracts.
655      */
656     function _baseURI() internal view virtual returns (string memory) {
657         return "";
658     }
659 
660     /**
661      * @dev See {IERC721-approve}.
662      */
663     function approve(address to, uint256 tokenId) public virtual override {
664         address owner = ERC721.ownerOf(tokenId);
665         require(to != owner, "ERC721: approval to current owner");
666 
667         require(
668             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
669             "ERC721: approve caller is not owner nor approved for all"
670         );
671 
672         _approve(to, tokenId);
673     }
674 
675     /**
676      * @dev See {IERC721-getApproved}.
677      */
678     function getApproved(uint256 tokenId) public view virtual override returns (address) {
679         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
680 
681         return _tokenApprovals[tokenId];
682     }
683 
684     /**
685      * @dev See {IERC721-setApprovalForAll}.
686      */
687     function setApprovalForAll(address operator, bool approved) public virtual override {
688         require(operator != _msgSender(), "ERC721: approve to caller");
689 
690         _operatorApprovals[_msgSender()][operator] = approved;
691         emit ApprovalForAll(_msgSender(), operator, approved);
692     }
693 
694     /**
695      * @dev See {IERC721-isApprovedForAll}.
696      */
697     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
698         return _operatorApprovals[owner][operator];
699     }
700 
701     /**
702      * @dev See {IERC721-transferFrom}.
703      */
704     function transferFrom(
705         address from,
706         address to,
707         uint256 tokenId
708     ) public virtual override {
709         //solhint-disable-next-line max-line-length
710         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
711 
712         _transfer(from, to, tokenId);
713     }
714 
715     /**
716      * @dev See {IERC721-safeTransferFrom}.
717      */
718     function safeTransferFrom(
719         address from,
720         address to,
721         uint256 tokenId
722     ) public virtual override {
723         safeTransferFrom(from, to, tokenId, "");
724     }
725 
726     /**
727      * @dev See {IERC721-safeTransferFrom}.
728      */
729     function safeTransferFrom(
730         address from,
731         address to,
732         uint256 tokenId,
733         bytes memory _data
734     ) public virtual override {
735         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
736         _safeTransfer(from, to, tokenId, _data);
737     }
738 
739     /**
740      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
741      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
742      *
743      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
744      *
745      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
746      * implement alternative mechanisms to perform token transfer, such as signature-based.
747      *
748      * Requirements:
749      *
750      * - `from` cannot be the zero address.
751      * - `to` cannot be the zero address.
752      * - `tokenId` token must exist and be owned by `from`.
753      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
754      *
755      * Emits a {Transfer} event.
756      */
757     function _safeTransfer(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes memory _data
762     ) internal virtual {
763         _transfer(from, to, tokenId);
764         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
765     }
766 
767     /**
768      * @dev Returns whether `tokenId` exists.
769      *
770      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
771      *
772      * Tokens start existing when they are minted (`_mint`),
773      * and stop existing when they are burned (`_burn`).
774      */
775     function _exists(uint256 tokenId) internal view virtual returns (bool) {
776         return _owners[tokenId] != address(0);
777     }
778 
779     /**
780      * @dev Returns whether `spender` is allowed to manage `tokenId`.
781      *
782      * Requirements:
783      *
784      * - `tokenId` must exist.
785      */
786     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
787         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
788         address owner = ERC721.ownerOf(tokenId);
789         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
790     }
791 
792     /**
793      * @dev Safely mints `tokenId` and transfers it to `to`.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must not exist.
798      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
799      *
800      * Emits a {Transfer} event.
801      */
802     function _safeMint(address to, uint256 tokenId) internal virtual {
803         _safeMint(to, tokenId, "");
804     }
805 
806     /**
807      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
808      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
809      */
810     function _safeMint(
811         address to,
812         uint256 tokenId,
813         bytes memory _data
814     ) internal virtual {
815         _mint(to, tokenId);
816         require(
817             _checkOnERC721Received(address(0), to, tokenId, _data),
818             "ERC721: transfer to non ERC721Receiver implementer"
819         );
820     }
821 
822     /**
823      * @dev Mints `tokenId` and transfers it to `to`.
824      *
825      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
826      *
827      * Requirements:
828      *
829      * - `tokenId` must not exist.
830      * - `to` cannot be the zero address.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _mint(address to, uint256 tokenId) internal virtual {
835         require(to != address(0), "ERC721: mint to the zero address");
836         require(!_exists(tokenId), "ERC721: token already minted");
837 
838         _beforeTokenTransfer(address(0), to, tokenId);
839 
840         _balances[to] += 1;
841         _owners[tokenId] = to;
842 
843         emit Transfer(address(0), to, tokenId);
844     }
845 
846     /**
847      * @dev Destroys `tokenId`.
848      * The approval is cleared when the token is burned.
849      *
850      * Requirements:
851      *
852      * - `tokenId` must exist.
853      *
854      * Emits a {Transfer} event.
855      */
856     function _burn(uint256 tokenId) internal virtual {
857         address owner = ERC721.ownerOf(tokenId);
858 
859         _beforeTokenTransfer(owner, address(0), tokenId);
860 
861         // Clear approvals
862         _approve(address(0), tokenId);
863 
864         _balances[owner] -= 1;
865         delete _owners[tokenId];
866 
867         emit Transfer(owner, address(0), tokenId);
868     }
869 
870     /**
871      * @dev Transfers `tokenId` from `from` to `to`.
872      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
873      *
874      * Requirements:
875      *
876      * - `to` cannot be the zero address.
877      * - `tokenId` token must be owned by `from`.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _transfer(
882         address from,
883         address to,
884         uint256 tokenId
885     ) internal virtual {
886         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
887         require(to != address(0), "ERC721: transfer to the zero address");
888 
889         _beforeTokenTransfer(from, to, tokenId);
890 
891         // Clear approvals from the previous owner
892         _approve(address(0), tokenId);
893 
894         _balances[from] -= 1;
895         _balances[to] += 1;
896         _owners[tokenId] = to;
897 
898         emit Transfer(from, to, tokenId);
899     }
900 
901     /**
902      * @dev Approve `to` to operate on `tokenId`
903      *
904      * Emits a {Approval} event.
905      */
906     function _approve(address to, uint256 tokenId) internal virtual {
907         _tokenApprovals[tokenId] = to;
908         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
909     }
910 
911     /**
912      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
913      * The call is not executed if the target address is not a contract.
914      *
915      * @param from address representing the previous owner of the given token ID
916      * @param to target address that will receive the tokens
917      * @param tokenId uint256 ID of the token to be transferred
918      * @param _data bytes optional data to send along with the call
919      * @return bool whether the call correctly returned the expected magic value
920      */
921     function _checkOnERC721Received(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) private returns (bool) {
927         if (to.isContract()) {
928             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
929                 return retval == IERC721Receiver(to).onERC721Received.selector;
930             } catch (bytes memory reason) {
931                 if (reason.length == 0) {
932                     revert("ERC721: transfer to non ERC721Receiver implementer");
933                 } else {
934                     assembly {
935                         revert(add(32, reason), mload(reason))
936                     }
937                 }
938             }
939         } else {
940             return true;
941         }
942     }
943 
944     /**
945      * @dev Hook that is called before any token transfer. This includes minting
946      * and burning.
947      *
948      * Calling conditions:
949      *
950      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
951      * transferred to `to`.
952      * - When `from` is zero, `tokenId` will be minted for `to`.
953      * - When `to` is zero, ``from``'s `tokenId` will be burned.
954      * - `from` and `to` are never both zero.
955      *
956      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
957      */
958     function _beforeTokenTransfer(
959         address from,
960         address to,
961         uint256 tokenId
962     ) internal virtual {}
963 }
964 
965 // Part: ERC721Enumerable
966 
967 /**
968  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
969  * enumerability of all the token ids in the contract as well as all token ids owned by each
970  * account.
971  */
972 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
973     // Mapping from owner to list of owned token IDs
974     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
975 
976     // Mapping from token ID to index of the owner tokens list
977     mapping(uint256 => uint256) private _ownedTokensIndex;
978 
979     // Array with all token ids, used for enumeration
980     uint256[] private _allTokens;
981 
982     // Mapping from token id to position in the allTokens array
983     mapping(uint256 => uint256) private _allTokensIndex;
984 
985     /**
986      * @dev See {IERC165-supportsInterface}.
987      */
988     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
989         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
990     }
991 
992     /**
993      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
994      */
995     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
996         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
997         return _ownedTokens[owner][index];
998     }
999 
1000     /**
1001      * @dev See {IERC721Enumerable-totalSupply}.
1002      */
1003     function totalSupply() public view virtual override returns (uint256) {
1004         return _allTokens.length;
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Enumerable-tokenByIndex}.
1009      */
1010     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1011         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1012         return _allTokens[index];
1013     }
1014 
1015     /**
1016      * @dev Hook that is called before any token transfer. This includes minting
1017      * and burning.
1018      *
1019      * Calling conditions:
1020      *
1021      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1022      * transferred to `to`.
1023      * - When `from` is zero, `tokenId` will be minted for `to`.
1024      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1025      * - `from` cannot be the zero address.
1026      * - `to` cannot be the zero address.
1027      *
1028      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1029      */
1030     function _beforeTokenTransfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) internal virtual override {
1035         super._beforeTokenTransfer(from, to, tokenId);
1036 
1037         if (from == address(0)) {
1038             _addTokenToAllTokensEnumeration(tokenId);
1039         } else if (from != to) {
1040             _removeTokenFromOwnerEnumeration(from, tokenId);
1041         }
1042         if (to == address(0)) {
1043             _removeTokenFromAllTokensEnumeration(tokenId);
1044         } else if (to != from) {
1045             _addTokenToOwnerEnumeration(to, tokenId);
1046         }
1047     }
1048 
1049     /**
1050      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1051      * @param to address representing the new owner of the given token ID
1052      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1053      */
1054     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1055         uint256 length = ERC721.balanceOf(to);
1056         _ownedTokens[to][length] = tokenId;
1057         _ownedTokensIndex[tokenId] = length;
1058     }
1059 
1060     /**
1061      * @dev Private function to add a token to this extension's token tracking data structures.
1062      * @param tokenId uint256 ID of the token to be added to the tokens list
1063      */
1064     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1065         _allTokensIndex[tokenId] = _allTokens.length;
1066         _allTokens.push(tokenId);
1067     }
1068 
1069     /**
1070      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1071      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1072      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1073      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1074      * @param from address representing the previous owner of the given token ID
1075      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1076      */
1077     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1078         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1079         // then delete the last slot (swap and pop).
1080 
1081         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1082         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1083 
1084         // When the token to delete is the last token, the swap operation is unnecessary
1085         if (tokenIndex != lastTokenIndex) {
1086             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1087 
1088             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1089             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1090         }
1091 
1092         // This also deletes the contents at the last position of the array
1093         delete _ownedTokensIndex[tokenId];
1094         delete _ownedTokens[from][lastTokenIndex];
1095     }
1096 
1097     /**
1098      * @dev Private function to remove a token from this extension's token tracking data structures.
1099      * This has O(1) time complexity, but alters the order of the _allTokens array.
1100      * @param tokenId uint256 ID of the token to be removed from the tokens list
1101      */
1102     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1103         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1104         // then delete the last slot (swap and pop).
1105 
1106         uint256 lastTokenIndex = _allTokens.length - 1;
1107         uint256 tokenIndex = _allTokensIndex[tokenId];
1108 
1109         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1110         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1111         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1112         uint256 lastTokenId = _allTokens[lastTokenIndex];
1113 
1114         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1115         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1116 
1117         // This also deletes the contents at the last position of the array
1118         delete _allTokensIndex[tokenId];
1119         _allTokens.pop();
1120     }
1121 }
1122 
1123 // File: ActionNFT.sol
1124 
1125 contract ActionNFT is ERC721Enumerable {
1126   /* Variables */
1127   address payable private beneficiary;
1128 
1129   /* Common NFT */
1130   uint256 public currentId;
1131   uint256 public rampRate = 10**14;
1132   uint256 public commonPrice;
1133   mapping(address => uint256) public originalMintCount;
1134 
1135   /* Accounting Data */
1136   //uint256 public treasuryBalance;
1137   mapping(address => uint256) public withdrawableBalance;
1138 
1139   /* Mint Data */
1140   bool public canMint = true;
1141   uint256 public mintCap = 3000;
1142 
1143   /* Withdraw Data */
1144   uint256 public adminClaimTime;
1145   uint256 public withdrawWindow = 24 * 60 * 60 * 30;
1146 
1147   string public commonUrl = 'ipfs://QmTFMJ17s35Y2fHSomdTh29m8CdBPK8Cv8trXnAWTVJ1hc';
1148 
1149   constructor(address payable _beneficiary, uint256 _minPrice)
1150     public
1151     ERC721('PACDAO ACTION', 'PAC-A1')
1152   {
1153     beneficiary = _beneficiary;
1154     commonPrice = _minPrice;
1155 
1156   }
1157 
1158   function store_withdrawable(address username, uint256 value) internal {
1159     uint256 _withdraw = (msg.value * 90) / 100;
1160     withdrawableBalance[msg.sender] += _withdraw;
1161   }
1162 
1163   /* Payable Functions */
1164   function mintCommon() public payable canMintQuantity(1) {
1165     require(msg.value >= commonPrice, "Underpriced");
1166     _processMint();
1167     commonPrice = nextPrice(commonPrice);
1168     store_withdrawable(msg.sender, msg.value);
1169     originalMintCount[msg.sender]++;
1170   }
1171 
1172   function mintMany(uint256 _mint_count)
1173     public
1174     payable
1175     canMintQuantity(_mint_count)
1176   {
1177     (uint256 _expectedTotal, uint256 _expectedFinal) = getCostMany(_mint_count);
1178     require(msg.value >= _expectedTotal, "Underpriced");
1179     for (uint256 _i = 0; _i < _mint_count; _i++) {
1180       _processMint();
1181     }
1182     originalMintCount[msg.sender] += _mint_count;
1183     commonPrice = _expectedFinal;
1184     store_withdrawable(msg.sender, msg.value);
1185   }
1186 
1187   /* Internal */
1188   function _processMint() internal {
1189     currentId += 1;
1190     _safeMint(msg.sender, currentId);
1191   }
1192 
1193   function getCostMany(uint256 mint_count)
1194     public
1195     view
1196     returns (uint256, uint256)
1197   {
1198     uint256 _run_tot = 0;
1199     uint256 _cur_val = commonPrice;
1200     for (uint256 _i = 0; _i < mint_count; _i++) {
1201       _run_tot = _run_tot + _cur_val;
1202       _cur_val = nextPrice(_cur_val);
1203     }
1204     return (_run_tot, _cur_val);
1205   }
1206 
1207   function nextPrice(uint256 start_price) public view returns (uint256) {
1208     return start_price + rampRate;
1209   }
1210 
1211   /* Withdraw Functions */
1212 
1213   function withdrawTreasury() public saleEnded {
1214     require(block.timestamp >= adminClaimTime, "Admin cannot claim");
1215 
1216     beneficiary.transfer(address(this).balance);
1217   }
1218 
1219   function refundAll() public saleEnded {
1220     require(block.timestamp < adminClaimTime, "Withdraw Period Ended");
1221     require(balanceOf(msg.sender) >= originalMintCount[msg.sender], "Must have original");
1222     require(withdrawableBalance[msg.sender] > 0, "No balance to withdraw");
1223 
1224     uint256 _burnCount = originalMintCount[msg.sender];
1225     uint256[] memory _ownedTokens = new uint256[](_burnCount);
1226 
1227     for (uint256 _i = 0; _i < _burnCount; _i++) {
1228       _ownedTokens[_i] = tokenOfOwnerByIndex(msg.sender, _i);
1229     }
1230     for (uint256 _i = 0; _i < _burnCount; _i++) {
1231       _burn(_ownedTokens[_i]);
1232     }
1233 
1234     uint256 _val = withdrawableBalance[msg.sender];
1235 
1236     withdrawableBalance[msg.sender] = 0;
1237     payable(msg.sender).transfer(_val);
1238   }
1239 
1240 
1241   function tokenURI(uint256 tokenId) public view override returns (string memory) {
1242         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1243 	return(commonUrl);
1244   }
1245 
1246 
1247 
1248   /* Admin Functions */
1249   function signResolution(bool _resolution) public onlyAdmin {
1250     canMint = false;
1251 
1252     // Floor Vote Successful
1253     if (_resolution == true) {
1254       // Admin can claim immediately
1255       adminClaimTime = block.timestamp;
1256 
1257       // Floor Vote Unsuccessful
1258     } else {
1259       // Withdraw period is active
1260       adminClaimTime = block.timestamp + withdrawWindow;
1261     }
1262   }
1263 
1264   function updateBeneficiary(address payable _newBeneficiary) public onlyAdmin {
1265     beneficiary = _newBeneficiary;
1266   }
1267 
1268   function setTokenUri(string memory _newUri)
1269     public
1270     onlyAdmin
1271   {
1272     commonUrl = _newUri;
1273   }
1274 
1275   /* Fallback Functions */
1276   receive() external payable {}
1277 
1278   fallback() external payable {}
1279 
1280   /* Modifiers */
1281   modifier onlyAdmin() {
1282     require(msg.sender == beneficiary, "Only Admin");
1283     _;
1284   }
1285   modifier saleEnded() {
1286     require(canMint == false, "Sale ongoing");
1287     _;
1288   }
1289   modifier canMintQuantity(uint256 _quantity) {
1290     require(canMint == true, 'Minting period over');
1291     require(totalSupply() + _quantity <= mintCap, 'Insufficient Quantity');
1292     _;
1293   }
1294 }
