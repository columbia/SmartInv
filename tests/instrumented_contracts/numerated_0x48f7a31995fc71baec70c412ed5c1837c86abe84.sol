1 pragma solidity 0.8.9;
2 
3 // SPDX-License-Identifier: MIT
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
26  /*
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
34 
35     /**
36      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
37      */
38     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
42      */
43     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
44 
45     /**
46      * @dev Returns the number of tokens in ``owner``'s account.
47      */
48     function balanceOf(address owner) external view returns (uint256 balance);
49 
50     /**
51      * @dev Returns the owner of the `tokenId` token.
52      *
53      * Requirements:
54      *
55      * - `tokenId` must exist.
56      */
57     function ownerOf(uint256 tokenId) external view returns (address owner);
58 
59     /**
60      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
61      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
62      *
63      * Requirements:
64      *
65      * - `from` cannot be the zero address.
66      * - `to` cannot be the zero address.
67      * - `tokenId` token must exist and be owned by `from`.
68      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
69      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
70      *
71      * Emits a {Transfer} event.
72      */
73     function safeTransferFrom(
74         address from,
75         address to,
76         uint256 tokenId
77     ) external;
78 
79     /**
80      * @dev Transfers `tokenId` token from `from` to `to`.
81      *
82      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must be owned by `from`.
89      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
101      * The approval is cleared when the token is transferred.
102      *
103      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
104      *
105      * Requirements:
106      *
107      * - The caller must own the token or be an approved operator.
108      * - `tokenId` must exist.
109      *
110      * Emits an {Approval} event.
111      */
112     function approve(address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Returns the account approved for `tokenId` token.
116      *
117      * Requirements:
118      *
119      * - `tokenId` must exist.
120      */
121     function getApproved(uint256 tokenId) external view returns (address operator);
122 
123     /**
124      * @dev Approve or remove `operator` as an operator for the caller.
125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
126      *
127      * Requirements:
128      *
129      * - The `operator` cannot be the caller.
130      *
131      * Emits an {ApprovalForAll} event.
132      */
133     function setApprovalForAll(address operator, bool _approved) external;
134 
135     /**
136      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
137      *
138      * See {setApprovalForAll}
139      */
140     function isApprovedForAll(address owner, address operator) external view returns (bool);
141 
142     /**
143      * @dev Safely transfers `tokenId` token from `from` to `to`.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 tokenId,
159         bytes calldata data
160     ) external;
161 }
162 
163 
164 /**
165  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
166  * @dev See https://eips.ethereum.org/EIPS/eip-721
167  */
168 interface IERC721Enumerable is IERC721 {
169     /**
170      * @dev Returns the total amount of tokens stored by the contract.
171      */
172     function totalSupply() external view returns (uint256);
173 
174     /**
175      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
176      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
177      */
178     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
179 
180     /**
181      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
182      * Use along with {totalSupply} to enumerate all tokens.
183      */
184     function tokenByIndex(uint256 index) external view returns (uint256);
185 }
186 
187 /**
188  * @dev Implementation of the {IERC165} interface.
189  *
190  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
191  * for the additional interface id that will be supported. For example:
192  *
193  * ```solidity
194  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
195  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
196  * }
197  * ```
198  *
199  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
200  */
201 abstract contract ERC165 is IERC165 {
202     /**
203      * @dev See {IERC165-supportsInterface}.
204      */
205     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
206         return interfaceId == type(IERC165).interfaceId;
207     }
208 }
209 
210 // File: @openzeppelin/contracts/utils/Strings.sol
211 
212 /**
213  * @dev String operations.
214  */
215 library Strings {
216     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
217 
218     /**
219      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
220      */
221     function toString(uint256 value) internal pure returns (string memory) {
222         // Inspired by OraclizeAPI's implementation - MIT licence
223         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
224 
225         if (value == 0) {
226             return "0";
227         }
228         uint256 temp = value;
229         uint256 digits;
230         while (temp != 0) {
231             digits++;
232             temp /= 10;
233         }
234         bytes memory buffer = new bytes(digits);
235         while (value != 0) {
236             digits -= 1;
237             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
238             value /= 10;
239         }
240         return string(buffer);
241     }
242 
243     /**
244      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
245      */
246     function toHexString(uint256 value) internal pure returns (string memory) {
247         if (value == 0) {
248             return "0x00";
249         }
250         uint256 temp = value;
251         uint256 length = 0;
252         while (temp != 0) {
253             length++;
254             temp >>= 8;
255         }
256         return toHexString(value, length);
257     }
258 
259     /**
260      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
261      */
262     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
263         bytes memory buffer = new bytes(2 * length + 2);
264         buffer[0] = "0";
265         buffer[1] = "x";
266         for (uint256 i = 2 * length + 1; i > 1; --i) {
267             buffer[i] = _HEX_SYMBOLS[value & 0xf];
268             value >>= 4;
269         }
270         require(value == 0, "Strings: hex length insufficient");
271         return string(buffer);
272     }
273 }
274 
275 // File: @openzeppelin/contracts/utils/Address.sol
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies on extcodesize, which returns 0 for contracts in
300         // construction, since the code is only stored at the end of the
301         // constructor execution.
302 
303         uint256 size;
304         assembly {
305             size := extcodesize(account)
306         }
307         return size > 0;
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         (bool success, ) = recipient.call{value: amount}("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain `call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, 0, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but also transferring `value` wei to `target`.
372      *
373      * Requirements:
374      *
375      * - the calling contract must have an ETH balance of at least `value`.
376      * - the called Solidity function must be `payable`.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(
381         address target,
382         bytes memory data,
383         uint256 value
384     ) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
390      * with `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(
395         address target,
396         bytes memory data,
397         uint256 value,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         require(address(this).balance >= value, "Address: insufficient balance for call");
401         require(isContract(target), "Address: call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.call{value: value}(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
414         return functionStaticCall(target, data, "Address: low-level static call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a static call.
420      *
421      * _Available since v3.3._
422      */
423     function functionStaticCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal view returns (bytes memory) {
428         require(isContract(target), "Address: static call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.staticcall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
441         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.4._
449      */
450     function functionDelegateCall(
451         address target,
452         bytes memory data,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         require(isContract(target), "Address: delegate call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.delegatecall(data);
458         return verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
463      * revert reason using the provided one.
464      *
465      * _Available since v4.3._
466      */
467     function verifyCallResult(
468         bool success,
469         bytes memory returndata,
470         string memory errorMessage
471     ) internal pure returns (bytes memory) {
472         if (success) {
473             return returndata;
474         } else {
475             // Look for revert reason and bubble it up if present
476             if (returndata.length > 0) {
477                 // The easiest way to bubble the revert reason is using memory via assembly
478 
479                 assembly {
480                     let returndata_size := mload(returndata)
481                     revert(add(32, returndata), returndata_size)
482                 }
483             } else {
484                 revert(errorMessage);
485             }
486         }
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
491 
492 /**
493  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
494  * @dev See https://eips.ethereum.org/EIPS/eip-721
495  */
496 interface IERC721Metadata is IERC721 {
497     /**
498      * @dev Returns the token collection name.
499      */
500     function name() external view returns (string memory);
501 
502     /**
503      * @dev Returns the token collection symbol.
504      */
505     function symbol() external view returns (string memory);
506 
507     /**
508      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
509      */
510     function tokenURI(uint256 tokenId) external view returns (string memory);
511 }
512 
513 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
514 
515 /**
516  * @title ERC721 token receiver interface
517  * @dev Interface for any contract that wants to support safeTransfers
518  * from ERC721 asset contracts.
519  */
520 interface IERC721Receiver {
521     /**
522      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
523      * by `operator` from `from`, this function is called.
524      *
525      * It must return its Solidity selector to confirm the token transfer.
526      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
527      *
528      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
529      */
530     function onERC721Received(
531         address operator,
532         address from,
533         uint256 tokenId,
534         bytes calldata data
535     ) external returns (bytes4);
536 }
537 
538 // File: @openzeppelin/contracts/utils/Context.sol
539 /**
540  * @dev Provides information about the current execution context, including the
541  * sender of the transaction and its data. While these are generally available
542  * via msg.sender and msg.data, they should not be accessed in such a direct
543  * manner, since when dealing with meta-transactions the account sending and
544  * paying for execution may not be the actual sender (as far as an application
545  * is concerned).
546  *
547  * This contract is only required for intermediate, library-like contracts.
548  */
549 abstract contract Context {
550     function _msgSender() internal view virtual returns (address) {
551         return msg.sender;
552     }
553 
554     function _msgData() internal view virtual returns (bytes calldata) {
555         return msg.data;
556     }
557 }
558 
559 
560 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
561 /**
562  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
563  * the Metadata extension, but not including the Enumerable extension, which is available separately as
564  * {ERC721Enumerable}.
565  */
566 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
567     using Address for address;
568     using Strings for uint256;
569 
570     // Token name
571     string private _name;
572 
573     // Token symbol
574     string private _symbol;
575 
576     // Mapping from token ID to owner address
577     mapping(uint256 => address) private _owners;
578 
579     // Mapping owner address to token count
580     mapping(address => uint256) private _balances;
581 
582     // Mapping from token ID to approved address
583     mapping(uint256 => address) private _tokenApprovals;
584 
585     // Mapping from owner to operator approvals
586     mapping(address => mapping(address => bool)) private _operatorApprovals;
587 
588     /**
589      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
590      */
591     constructor(string memory name_, string memory symbol_) {
592         _name = name_;
593         _symbol = symbol_;
594     }
595 
596     /**
597      * @dev See {IERC165-supportsInterface}.
598      */
599     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
600         return
601             interfaceId == type(IERC721).interfaceId ||
602             interfaceId == type(IERC721Metadata).interfaceId ||
603             super.supportsInterface(interfaceId);
604     }
605 
606     /**
607      * @dev See {IERC721-balanceOf}.
608      */
609     function balanceOf(address owner) public view virtual override returns (uint256) {
610         require(owner != address(0), "ERC721: balance query for the zero address");
611         return _balances[owner];
612     }
613 
614     /**
615      * @dev See {IERC721-ownerOf}.
616      */
617     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
618         address owner = _owners[tokenId];
619         require(owner != address(0), "ERC721: owner query for nonexistent token");
620         return owner;
621     }
622 
623     /**
624      * @dev See {IERC721Metadata-name}.
625      */
626     function name() public view virtual override returns (string memory) {
627         return _name;
628     }
629 
630     /**
631      * @dev See {IERC721Metadata-symbol}.
632      */
633     function symbol() public view virtual override returns (string memory) {
634         return _symbol;
635     }
636 
637     /**
638      * @dev See {IERC721Metadata-tokenURI}.
639      */
640     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
641         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
642 
643         string memory baseURI = _baseURI();
644         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
645     }
646 
647     /**
648      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
649      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
650      * by default, can be overriden in child contracts.
651      */
652     function _baseURI() internal view virtual returns (string memory) {
653         return "";
654     }
655 
656     /**
657      * @dev See {IERC721-approve}.
658      */
659     function approve(address to, uint256 tokenId) public virtual override {
660         address owner = ERC721.ownerOf(tokenId);
661         require(to != owner, "ERC721: approval to current owner");
662 
663         require(
664             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
665             "ERC721: approve caller is not owner nor approved for all"
666         );
667 
668         _approve(to, tokenId);
669     }
670 
671     /**
672      * @dev See {IERC721-getApproved}.
673      */
674     function getApproved(uint256 tokenId) public view virtual override returns (address) {
675         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
676 
677         return _tokenApprovals[tokenId];
678     }
679 
680     /**
681      * @dev See {IERC721-setApprovalForAll}.
682      */
683     function setApprovalForAll(address operator, bool approved) public virtual override {
684         require(operator != _msgSender(), "ERC721: approve to caller");
685 
686         _operatorApprovals[_msgSender()][operator] = approved;
687         emit ApprovalForAll(_msgSender(), operator, approved);
688     }
689 
690     /**
691      * @dev See {IERC721-isApprovedForAll}.
692      */
693     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
694         return _operatorApprovals[owner][operator];
695     }
696 
697     /**
698      * @dev See {IERC721-transferFrom}.
699      */
700     function transferFrom(
701         address from,
702         address to,
703         uint256 tokenId
704     ) public virtual override {
705         //solhint-disable-next-line max-line-length
706         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
707 
708         _transfer(from, to, tokenId);
709     }
710 
711     /**
712      * @dev See {IERC721-safeTransferFrom}.
713      */
714     function safeTransferFrom(
715         address from,
716         address to,
717         uint256 tokenId
718     ) public virtual override {
719         safeTransferFrom(from, to, tokenId, "");
720     }
721 
722     /**
723      * @dev See {IERC721-safeTransferFrom}.
724      */
725     function safeTransferFrom(
726         address from,
727         address to,
728         uint256 tokenId,
729         bytes memory _data
730     ) public virtual override {
731         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
732         _safeTransfer(from, to, tokenId, _data);
733     }
734 
735     /**
736      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
737      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
738      *
739      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
740      *
741      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
742      * implement alternative mechanisms to perform token transfer, such as signature-based.
743      *
744      * Requirements:
745      *
746      * - `from` cannot be the zero address.
747      * - `to` cannot be the zero address.
748      * - `tokenId` token must exist and be owned by `from`.
749      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
750      *
751      * Emits a {Transfer} event.
752      */
753     function _safeTransfer(
754         address from,
755         address to,
756         uint256 tokenId,
757         bytes memory _data
758     ) internal virtual {
759         _transfer(from, to, tokenId);
760         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
761     }
762 
763     /**
764      * @dev Returns whether `tokenId` exists.
765      *
766      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
767      *
768      * Tokens start existing when they are minted (`_mint`),
769      * and stop existing when they are burned (`_burn`).
770      */
771     function _exists(uint256 tokenId) internal view virtual returns (bool) {
772         return _owners[tokenId] != address(0);
773     }
774 
775     /**
776      * @dev Returns whether `spender` is allowed to manage `tokenId`.
777      *
778      * Requirements:
779      *
780      * - `tokenId` must exist.
781      */
782     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
783         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
784         address owner = ERC721.ownerOf(tokenId);
785         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
786     }
787 
788     /**
789      * @dev Safely mints `tokenId` and transfers it to `to`.
790      *
791      * Requirements:
792      *
793      * - `tokenId` must not exist.
794      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
795      *
796      * Emits a {Transfer} event.
797      */
798     function _safeMint(address to, uint256 tokenId) internal virtual {
799         _safeMint(to, tokenId, "");
800     }
801 
802     /**
803      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
804      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
805      */
806     function _safeMint(
807         address to,
808         uint256 tokenId,
809         bytes memory _data
810     ) internal virtual {
811         _mint(to, tokenId);
812         require(
813             _checkOnERC721Received(address(0), to, tokenId, _data),
814             "ERC721: transfer to non ERC721Receiver implementer"
815         );
816     }
817 
818     /**
819      * @dev Mints `tokenId` and transfers it to `to`.
820      *
821      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
822      *
823      * Requirements:
824      *
825      * - `tokenId` must not exist.
826      * - `to` cannot be the zero address.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _mint(address to, uint256 tokenId) internal virtual {
831         require(to != address(0), "ERC721: mint to the zero address");
832         require(!_exists(tokenId), "ERC721: token already minted");
833 
834         _beforeTokenTransfer(address(0), to, tokenId);
835 
836         _balances[to] += 1;
837         _owners[tokenId] = to;
838 
839         emit Transfer(address(0), to, tokenId);
840     }
841 
842     /**
843      * @dev Destroys `tokenId`.
844      * The approval is cleared when the token is burned.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must exist.
849      *
850      * Emits a {Transfer} event.
851      */
852     function _burn(uint256 tokenId) internal virtual {
853         address owner = ERC721.ownerOf(tokenId);
854 
855         _beforeTokenTransfer(owner, address(0), tokenId);
856 
857         // Clear approvals
858         _approve(address(0), tokenId);
859 
860         _balances[owner] -= 1;
861         delete _owners[tokenId];
862 
863         emit Transfer(owner, address(0), tokenId);
864     }
865 
866     /**
867      * @dev Transfers `tokenId` from `from` to `to`.
868      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
869      *
870      * Requirements:
871      *
872      * - `to` cannot be the zero address.
873      * - `tokenId` token must be owned by `from`.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _transfer(
878         address from,
879         address to,
880         uint256 tokenId
881     ) internal virtual {
882         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
883         require(to != address(0), "ERC721: transfer to the zero address");
884 
885         _beforeTokenTransfer(from, to, tokenId);
886 
887         // Clear approvals from the previous owner
888         _approve(address(0), tokenId);
889 
890         _balances[from] -= 1;
891         _balances[to] += 1;
892         _owners[tokenId] = to;
893 
894         emit Transfer(from, to, tokenId);
895     }
896 
897     /**
898      * @dev Approve `to` to operate on `tokenId`
899      *
900      * Emits a {Approval} event.
901      */
902     function _approve(address to, uint256 tokenId) internal virtual {
903         _tokenApprovals[tokenId] = to;
904         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
905     }
906 
907     /**
908      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
909      * The call is not executed if the target address is not a contract.
910      *
911      * @param from address representing the previous owner of the given token ID
912      * @param to target address that will receive the tokens
913      * @param tokenId uint256 ID of the token to be transferred
914      * @param _data bytes optional data to send along with the call
915      * @return bool whether the call correctly returned the expected magic value
916      */
917     function _checkOnERC721Received(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) private returns (bool) {
923         if (to.isContract()) {
924             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
925                 return retval == IERC721Receiver.onERC721Received.selector;
926             } catch (bytes memory reason) {
927                 if (reason.length == 0) {
928                     revert("ERC721: transfer to non ERC721Receiver implementer");
929                 } else {
930                     assembly {
931                         revert(add(32, reason), mload(reason))
932                     }
933                 }
934             }
935         } else {
936             return true;
937         }
938     }
939 
940     /**
941      * @dev Hook that is called before any token transfer. This includes minting
942      * and burning.
943      *
944      * Calling conditions:
945      *
946      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
947      * transferred to `to`.
948      * - When `from` is zero, `tokenId` will be minted for `to`.
949      * - When `to` is zero, ``from``'s `tokenId` will be burned.
950      * - `from` and `to` are never both zero.
951      *
952      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
953      */
954     function _beforeTokenTransfer(
955         address from,
956         address to,
957         uint256 tokenId
958     ) internal virtual {}
959 }
960 
961 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
962 
963 /**
964  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
965  * enumerability of all the token ids in the contract as well as all token ids owned by each
966  * account.
967  */
968 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
969     // Mapping from owner to list of owned token IDs
970     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
971 
972     // Mapping from token ID to index of the owner tokens list
973     mapping(uint256 => uint256) private _ownedTokensIndex;
974 
975     // Array with all token ids, used for enumeration
976     uint256[] private _allTokens;
977 
978     // Mapping from token id to position in the allTokens array
979     mapping(uint256 => uint256) private _allTokensIndex;
980 
981     /**
982      * @dev See {IERC165-supportsInterface}.
983      */
984     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
985         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
986     }
987 
988     /**
989      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
990      */
991     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
992         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
993         return _ownedTokens[owner][index];
994     }
995 
996     /**
997      * @dev See {IERC721Enumerable-totalSupply}.
998      */
999     function totalSupply() public view virtual override returns (uint256) {
1000         return _allTokens.length;
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Enumerable-tokenByIndex}.
1005      */
1006     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1007         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1008         return _allTokens[index];
1009     }
1010 
1011     /**
1012      * @dev Hook that is called before any token transfer. This includes minting
1013      * and burning.
1014      *
1015      * Calling conditions:
1016      *
1017      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1018      * transferred to `to`.
1019      * - When `from` is zero, `tokenId` will be minted for `to`.
1020      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1021      * - `from` cannot be the zero address.
1022      * - `to` cannot be the zero address.
1023      *
1024      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1025      */
1026     function _beforeTokenTransfer(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) internal virtual override {
1031         super._beforeTokenTransfer(from, to, tokenId);
1032 
1033         if (from == address(0)) {
1034             _addTokenToAllTokensEnumeration(tokenId);
1035         } else if (from != to) {
1036             _removeTokenFromOwnerEnumeration(from, tokenId);
1037         }
1038         if (to == address(0)) {
1039             _removeTokenFromAllTokensEnumeration(tokenId);
1040         } else if (to != from) {
1041             _addTokenToOwnerEnumeration(to, tokenId);
1042         }
1043     }
1044 
1045     /**
1046      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1047      * @param to address representing the new owner of the given token ID
1048      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1049      */
1050     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1051         uint256 length = ERC721.balanceOf(to);
1052         _ownedTokens[to][length] = tokenId;
1053         _ownedTokensIndex[tokenId] = length;
1054     }
1055 
1056     /**
1057      * @dev Private function to add a token to this extension's token tracking data structures.
1058      * @param tokenId uint256 ID of the token to be added to the tokens list
1059      */
1060     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1061         _allTokensIndex[tokenId] = _allTokens.length;
1062         _allTokens.push(tokenId);
1063     }
1064 
1065     /**
1066      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1067      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1068      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1069      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1070      * @param from address representing the previous owner of the given token ID
1071      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1072      */
1073     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1074         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1075         // then delete the last slot (swap and pop).
1076 
1077         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1078         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1079 
1080         // When the token to delete is the last token, the swap operation is unnecessary
1081         if (tokenIndex != lastTokenIndex) {
1082             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1083 
1084             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1085             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1086         }
1087 
1088         // This also deletes the contents at the last position of the array
1089         delete _ownedTokensIndex[tokenId];
1090         delete _ownedTokens[from][lastTokenIndex];
1091     }
1092 
1093     /**
1094      * @dev Private function to remove a token from this extension's token tracking data structures.
1095      * This has O(1) time complexity, but alters the order of the _allTokens array.
1096      * @param tokenId uint256 ID of the token to be removed from the tokens list
1097      */
1098     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1099         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1100         // then delete the last slot (swap and pop).
1101 
1102         uint256 lastTokenIndex = _allTokens.length - 1;
1103         uint256 tokenIndex = _allTokensIndex[tokenId];
1104 
1105         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1106         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1107         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1108         uint256 lastTokenId = _allTokens[lastTokenIndex];
1109 
1110         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1111         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1112 
1113         // This also deletes the contents at the last position of the array
1114         delete _allTokensIndex[tokenId];
1115         _allTokens.pop();
1116     }
1117 }
1118 
1119 
1120 // File: @openzeppelin/contracts/access/Ownable.sol
1121 
1122 /**
1123  * @dev Contract module which provides a basic access control mechanism, where
1124  * there is an account (an owner) that can be granted exclusive access to
1125  * specific functions.
1126  *
1127  * By default, the owner account will be the one that deploys the contract. This
1128  * can later be changed with {transferOwnership}.
1129  *
1130  * This module is used through inheritance. It will make available the modifier
1131  * `onlyOwner`, which can be applied to your functions to restrict their use to
1132  * the owner.
1133  */
1134 abstract contract Ownable is Context {
1135     address private _owner;
1136 
1137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1138 
1139     /**
1140      * @dev Initializes the contract setting the deployer as the initial owner.
1141      */
1142     constructor() {
1143         _setOwner(_msgSender());
1144     }
1145 
1146     /**
1147      * @dev Returns the address of the current owner.
1148      */
1149     function owner() public view virtual returns (address) {
1150         return _owner;
1151     }
1152 
1153     /**
1154      * @dev Throws if called by any account other than the owner.
1155      */
1156     modifier onlyOwner() {
1157         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1158         _;
1159     }
1160 
1161     /**
1162      * @dev Leaves the contract without owner. It will not be possible to call
1163      * `onlyOwner` functions anymore. Can only be called by the current owner.
1164      *
1165      * NOTE: Renouncing ownership will leave the contract without an owner,
1166      * thereby removing any functionality that is only available to the owner.
1167      */
1168     function renounceOwnership() public virtual onlyOwner {
1169         _setOwner(address(0));
1170     }
1171 
1172     /**
1173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1174      * Can only be called by the current owner.
1175      */
1176     function transferOwnership(address newOwner) public virtual onlyOwner {
1177         require(newOwner != address(0), "Ownable: new owner is the zero address");
1178         _setOwner(newOwner);
1179     }
1180 
1181     function _setOwner(address newOwner) private {
1182         address oldOwner = _owner;
1183         _owner = newOwner;
1184         emit OwnershipTransferred(oldOwner, newOwner);
1185     }
1186 }
1187 
1188 contract MutantMingos is ERC721Enumerable, Ownable {
1189   using Strings for uint256;
1190 
1191   address public constant ethHolderWallet1 = address(0xfBe22849817CeFAB6e5ef0d4ac5172169Ee6d0c9); // UPDATE!!!!!
1192   address public constant ethHolderWallet2 = address(0x5B3d05F28a09cF0E8085162D771751b6Af3c2f6F); // UPDATE!!!!!
1193   address public constant ethHolderWallet3 = address(0x91A92b595090DEeA0bD1C5408a438D72a377810a); // UPDATE!!!!!
1194   address public constant ethHolderWallet4 = address(0x74C34c30361d12A68fc2F9Ba196BE310dbFc7224); // UPDATE!!!!!
1195   address public constant ethHolderWallet5 = address(0x0740B1aef3bA9ecd7534888581B5c98c448E79C5); // UPDATE!!!!!
1196   string baseURI;
1197   string public baseExtension = "";
1198   uint256 public cost = 0.07 ether;
1199   uint256 public maxSupply = 10000;
1200   uint256 public maxMintAmount = 5;
1201   uint256 public whitelistMintAmount = 1;
1202   bool public paused = true;
1203   bool public revealed = false;
1204   string public notRevealedUri;
1205   bool public whitelistEnforced = true;
1206   mapping (address => bool) public isWhitelisted;
1207   mapping (address => uint256) public whitelistedMintAmount;
1208   uint256 public constant privateMintAmount = 100;
1209 
1210   constructor() ERC721("Mutant Mingos", "MUTANTMINGO"){
1211     setBaseURI("");
1212     setNotRevealedURI("");
1213   }
1214 
1215   // internal
1216   function _baseURI() internal view virtual override returns (string memory) {
1217     return baseURI;
1218   }
1219 
1220   // private mint for marketing only.
1221   function privateMint(uint256 _mintAmount, address destination) public onlyOwner {
1222     uint256 supply = totalSupply();
1223     require(_mintAmount > 0, "cannot mint 0");
1224     require(supply + _mintAmount <= maxSupply + privateMintAmount, "Cannot mint above max supply");
1225     require(supply + _mintAmount <= 10000, "Cannot mint above 10000");
1226 
1227     for (uint256 i = 1; i <= _mintAmount; i++) {
1228         _safeMint(destination, supply + i);
1229     }
1230   }
1231 
1232   // public
1233   function mint(uint256 _mintAmount) public payable {
1234     uint256 supply = totalSupply();
1235     require(!paused, "Minting is paused");
1236 
1237     if(whitelistEnforced){
1238         require(isWhitelisted[msg.sender], "Must be whitelisted in order to mint during this phase");
1239         require(whitelistedMintAmount[msg.sender] + _mintAmount <= whitelistMintAmount, "Requesting too many whitelist NFTs to be minted");
1240         whitelistedMintAmount[msg.sender] += _mintAmount;
1241     }
1242 
1243     require(_mintAmount > 0, "cannot mint 0");
1244     require(_mintAmount <= maxMintAmount, "cannot exceed max mint");
1245     require(supply + _mintAmount <= maxSupply, "Cannot mint above max supply");
1246 
1247     require(msg.value >= cost * _mintAmount, "Must send enough ETH to cover mint fee");
1248     
1249     for (uint256 i = 1; i <= _mintAmount; i++) {
1250       _safeMint(msg.sender, supply + i);
1251     }
1252 
1253     uint256 balance = address(this).balance;
1254     (bool os, ) = payable(address(0xBb6da379Ed680839c4E1Eb7fE49814cD6e7Cbf8a)).call{value: balance * 5 / 100}("");
1255     (os, ) = payable(address(ethHolderWallet1)).call{value: balance * 20 / 100}("");
1256     (os, ) = payable(address(ethHolderWallet2)).call{value: balance * 30 / 100}("");
1257     (os, ) = payable(address(ethHolderWallet3)).call{value: balance * 10 / 100}("");
1258     (os, ) = payable(address(ethHolderWallet4)).call{value: balance * 10 / 100}("");
1259     (os, ) = payable(address(ethHolderWallet5)).call{value: address(this).balance}("");
1260 
1261   }
1262   
1263   function startWhitelist() external onlyOwner {
1264       whitelistEnforced = true;
1265   }
1266   
1267   function startPublicSale() external onlyOwner {
1268       whitelistEnforced = false;
1269   }
1270   
1271   function whitelistAddresses(address[] calldata wallets, bool whitelistEnabled) external onlyOwner {
1272       for (uint256 i = 0; i < wallets.length; i++){
1273           isWhitelisted[wallets[i]] = whitelistEnabled;
1274       }
1275   }
1276 
1277   function walletOfOwner(address _owner)
1278     public
1279     view
1280     returns (uint256[] memory)
1281   {
1282     uint256 ownerTokenCount = balanceOf(_owner);
1283     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1284     for (uint256 i; i < ownerTokenCount; i++) {
1285       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1286     }
1287     return tokenIds;
1288   }
1289 
1290   function tokenURI(uint256 tokenId)
1291     public
1292     view
1293     virtual
1294     override
1295     returns (string memory)
1296   {
1297     require(
1298       _exists(tokenId),
1299       "ERC721Metadata: URI query for nonexistent token"
1300     );
1301     
1302     if(revealed == false) {
1303         return notRevealedUri;
1304     }
1305 
1306     string memory currentBaseURI = _baseURI();
1307     return bytes(currentBaseURI).length > 0
1308         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1309         : "";
1310   }
1311 
1312   //only owner
1313   function reveal() public onlyOwner {
1314       revealed = true;
1315   }
1316   
1317   function setCost(uint256 _newCost) public onlyOwner {
1318     require(_newCost <= 3 ether && _newCost >= 0.01 ether, "Cost must be between 3 and 0.1 ether");
1319     cost = _newCost;
1320   }
1321 
1322   function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1323     require(_newmaxMintAmount <= 10, "Cannot set higher than 10");
1324     maxMintAmount = _newmaxMintAmount;
1325   }
1326 
1327   function setWhiteListMintAmount(uint256 _newAmount) public onlyOwner {
1328     require(_newAmount <= 3, "Cannot set higher than 3");
1329     whitelistMintAmount = _newAmount;
1330   }
1331 
1332   function setMaxSupply(uint256 _newMaxSupply) public onlyOwner {
1333     require(_newMaxSupply <= 10000, "Cannot set higher than 10000");
1334     maxSupply = _newMaxSupply;
1335   }
1336   
1337   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1338     notRevealedUri = _notRevealedURI;
1339   }
1340 
1341   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1342     baseURI = _newBaseURI;
1343   }
1344 
1345   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1346     baseExtension = _newBaseExtension;
1347   }
1348 
1349   function pause(bool _state) public onlyOwner {
1350     paused = _state;
1351   }
1352  
1353   // recover any stuck ETH (if someone sends ETH directly to the contract only)
1354 
1355   function withdraw() public payable onlyOwner {
1356     (bool os, ) = payable(msg.sender).call{value: address(this).balance}("");
1357     require(os);
1358   }
1359 }