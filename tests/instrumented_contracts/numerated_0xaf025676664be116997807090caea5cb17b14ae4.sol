1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
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
26 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
27 
28 pragma solidity ^0.8.0;
29 
30 
31 /**
32  * @dev Required interface of an ERC721 compliant contract.
33  */
34 interface IERC721 is IERC165 {
35     /**
36      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
37      */
38     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
47      */
48     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
49 
50     /**
51      * @dev Returns the number of tokens in ``owner``'s account.
52      */
53     function balanceOf(address owner) external view returns (uint256 balance);
54 
55     /**
56      * @dev Returns the owner of the `tokenId` token.
57      *
58      * Requirements:
59      *
60      * - `tokenId` must exist.
61      */
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId
82     ) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
106      * The approval is cleared when the token is transferred.
107      *
108      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
109      *
110      * Requirements:
111      *
112      * - The caller must own the token or be an approved operator.
113      * - `tokenId` must exist.
114      *
115      * Emits an {Approval} event.
116      */
117     function approve(address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Returns the account approved for `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function getApproved(uint256 tokenId) external view returns (address operator);
127 
128     /**
129      * @dev Approve or remove `operator` as an operator for the caller.
130      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
131      *
132      * Requirements:
133      *
134      * - The `operator` cannot be the caller.
135      *
136      * Emits an {ApprovalForAll} event.
137      */
138     function setApprovalForAll(address operator, bool _approved) external;
139 
140     /**
141      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
142      *
143      * See {setApprovalForAll}
144      */
145     function isApprovedForAll(address owner, address operator) external view returns (bool);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId,
164         bytes calldata data
165     ) external;
166 }
167 
168 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @title ERC721 token receiver interface
174  * @dev Interface for any contract that wants to support safeTransfers
175  * from ERC721 asset contracts.
176  */
177 interface IERC721Receiver {
178     /**
179      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
180      * by `operator` from `from`, this function is called.
181      *
182      * It must return its Solidity selector to confirm the token transfer.
183      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
184      *
185      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
186      */
187     function onERC721Received(
188         address operator,
189         address from,
190         uint256 tokenId,
191         bytes calldata data
192     ) external returns (bytes4);
193 }
194 
195 pragma solidity ^0.8.0;
196 
197 
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
200  * @dev See https://eips.ethereum.org/EIPS/eip-721
201  */
202 interface IERC721Metadata is IERC721 {
203     /**
204      * @dev Returns the token collection name.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the token collection symbol.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
215      */
216     function tokenURI(uint256 tokenId) external view returns (string memory);
217 }
218 
219 // File: @openzeppelin/contracts/utils/Address.sol
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Collection of functions related to the address type
225  */
226 library Address {
227     /**
228      * @dev Returns true if `account` is a contract.
229      *
230      * [IMPORTANT]
231      * ====
232      * It is unsafe to assume that an address for which this function returns
233      * false is an externally-owned account (EOA) and not a contract.
234      *
235      * Among others, `isContract` will return false for the following
236      * types of addresses:
237      *
238      *  - an externally-owned account
239      *  - a contract in construction
240      *  - an address where a contract will be created
241      *  - an address where a contract lived, but was destroyed
242      * ====
243      */
244     function isContract(address account) internal view returns (bool) {
245         // This method relies on extcodesize, which returns 0 for contracts in
246         // construction, since the code is only stored at the end of the
247         // constructor execution.
248 
249         uint256 size;
250         assembly {
251             size := extcodesize(account)
252         }
253         return size > 0;
254     }
255 
256     /**
257      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
258      * `recipient`, forwarding all available gas and reverting on errors.
259      *
260      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
261      * of certain opcodes, possibly making contracts go over the 2300 gas limit
262      * imposed by `transfer`, making them unable to receive funds via
263      * `transfer`. {sendValue} removes this limitation.
264      *
265      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
266      *
267      * IMPORTANT: because control is transferred to `recipient`, care must be
268      * taken to not create reentrancy vulnerabilities. Consider using
269      * {ReentrancyGuard} or the
270      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
271      */
272     function sendValue(address payable recipient, uint256 amount) internal {
273         require(address(this).balance >= amount, "Address: insufficient balance");
274 
275         (bool success, ) = recipient.call{value: amount}("");
276         require(success, "Address: unable to send value, recipient may have reverted");
277     }
278 
279     /**
280      * @dev Performs a Solidity function call using a low level `call`. A
281      * plain `call` is an unsafe replacement for a function call: use this
282      * function instead.
283      *
284      * If `target` reverts with a revert reason, it is bubbled up by this
285      * function (like regular Solidity function calls).
286      *
287      * Returns the raw returned data. To convert to the expected return value,
288      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
289      *
290      * Requirements:
291      *
292      * - `target` must be a contract.
293      * - calling `target` with `data` must not revert.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
298         return functionCall(target, data, "Address: low-level call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
303      * `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(
308         address target,
309         bytes memory data,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, 0, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but also transferring `value` wei to `target`.
318      *
319      * Requirements:
320      *
321      * - the calling contract must have an ETH balance of at least `value`.
322      * - the called Solidity function must be `payable`.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value
330     ) internal returns (bytes memory) {
331         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
336      * with `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(
341         address target,
342         bytes memory data,
343         uint256 value,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         require(address(this).balance >= value, "Address: insufficient balance for call");
347         require(isContract(target), "Address: call to non-contract");
348 
349         (bool success, bytes memory returndata) = target.call{value: value}(data);
350         return verifyCallResult(success, returndata, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
360         return functionStaticCall(target, data, "Address: low-level static call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
365      * but performing a static call.
366      *
367      * _Available since v3.3._
368      */
369     function functionStaticCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal view returns (bytes memory) {
374         require(isContract(target), "Address: static call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.staticcall(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
387         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a delegate call.
393      *
394      * _Available since v3.4._
395      */
396     function functionDelegateCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         require(isContract(target), "Address: delegate call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.delegatecall(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
409      * revert reason using the provided one.
410      *
411      * _Available since v4.3._
412      */
413     function verifyCallResult(
414         bool success,
415         bytes memory returndata,
416         string memory errorMessage
417     ) internal pure returns (bytes memory) {
418         if (success) {
419             return returndata;
420         } else {
421             // Look for revert reason and bubble it up if present
422             if (returndata.length > 0) {
423                 // The easiest way to bubble the revert reason is using memory via assembly
424 
425                 assembly {
426                     let returndata_size := mload(returndata)
427                     revert(add(32, returndata), returndata_size)
428                 }
429             } else {
430                 revert(errorMessage);
431             }
432         }
433     }
434 }
435 
436 // File: @openzeppelin/contracts/utils/Context.sol
437 
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @dev Provides information about the current execution context, including the
442  * sender of the transaction and its data. While these are generally available
443  * via msg.sender and msg.data, they should not be accessed in such a direct
444  * manner, since when dealing with meta-transactions the account sending and
445  * paying for execution may not be the actual sender (as far as an application
446  * is concerned).
447  *
448  * This contract is only required for intermediate, library-like contracts.
449  */
450 abstract contract Context {
451     function _msgSender() internal view virtual returns (address) {
452         return msg.sender;
453     }
454 
455     function _msgData() internal view virtual returns (bytes calldata) {
456         return msg.data;
457     }
458 }
459 
460 // File: @openzeppelin/contracts/utils/Strings.sol
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @dev String operations.
466  */
467 library Strings {
468     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
469 
470     /**
471      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
472      */
473     function toString(uint256 value) internal pure returns (string memory) {
474         // Inspired by OraclizeAPI's implementation - MIT licence
475         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
476 
477         if (value == 0) {
478             return "0";
479         }
480         uint256 temp = value;
481         uint256 digits;
482         while (temp != 0) {
483             digits++;
484             temp /= 10;
485         }
486         bytes memory buffer = new bytes(digits);
487         while (value != 0) {
488             digits -= 1;
489             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
490             value /= 10;
491         }
492         return string(buffer);
493     }
494 
495     /**
496      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
497      */
498     function toHexString(uint256 value) internal pure returns (string memory) {
499         if (value == 0) {
500             return "0x00";
501         }
502         uint256 temp = value;
503         uint256 length = 0;
504         while (temp != 0) {
505             length++;
506             temp >>= 8;
507         }
508         return toHexString(value, length);
509     }
510 
511     /**
512      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
513      */
514     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
515         bytes memory buffer = new bytes(2 * length + 2);
516         buffer[0] = "0";
517         buffer[1] = "x";
518         for (uint256 i = 2 * length + 1; i > 1; --i) {
519             buffer[i] = _HEX_SYMBOLS[value & 0xf];
520             value >>= 4;
521         }
522         require(value == 0, "Strings: hex length insufficient");
523         return string(buffer);
524     }
525 }
526 
527 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
528 
529 pragma solidity ^0.8.0;
530 
531 
532 /**
533  * @dev Implementation of the {IERC165} interface.
534  *
535  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
536  * for the additional interface id that will be supported. For example:
537  *
538  * ```solidity
539  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
540  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
541  * }
542  * ```
543  *
544  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
545  */
546 abstract contract ERC165 is IERC165 {
547     /**
548      * @dev See {IERC165-supportsInterface}.
549      */
550     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551         return interfaceId == type(IERC165).interfaceId;
552     }
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
556 
557 pragma solidity ^0.8.0;
558 
559 
560 
561 
562 
563 
564 
565 
566 /**
567  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
568  * the Metadata extension, but not including the Enumerable extension, which is available separately as
569  * {ERC721Enumerable}.
570  */
571 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
572     using Address for address;
573     using Strings for uint256;
574 
575     // Token name
576     string private _name;
577 
578     // Token symbol
579     string private _symbol;
580 
581     // Mapping from token ID to owner address
582     mapping(uint256 => address) private _owners;
583 
584     // Mapping owner address to token count
585     mapping(address => uint256) private _balances;
586 
587     // Mapping from token ID to approved address
588     mapping(uint256 => address) private _tokenApprovals;
589 
590     // Mapping from owner to operator approvals
591     mapping(address => mapping(address => bool)) private _operatorApprovals;
592 
593     /**
594      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
595      */
596     constructor(string memory name_, string memory symbol_) {
597         _name = name_;
598         _symbol = symbol_;
599     }
600 
601     /**
602      * @dev See {IERC165-supportsInterface}.
603      */
604     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
605         return
606             interfaceId == type(IERC721).interfaceId ||
607             interfaceId == type(IERC721Metadata).interfaceId ||
608             super.supportsInterface(interfaceId);
609     }
610 
611     /**
612      * @dev See {IERC721-balanceOf}.
613      */
614     function balanceOf(address owner) public view virtual override returns (uint256) {
615         require(owner != address(0), "ERC721: balance query for the zero address");
616         return _balances[owner];
617     }
618 
619     /**
620      * @dev See {IERC721-ownerOf}.
621      */
622     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
623         address owner = _owners[tokenId];
624         require(owner != address(0), "ERC721: owner query for nonexistent token");
625         return owner;
626     }
627 
628     /**
629      * @dev See {IERC721Metadata-name}.
630      */
631     function name() public view virtual override returns (string memory) {
632         return _name;
633     }
634 
635     /**
636      * @dev See {IERC721Metadata-symbol}.
637      */
638     function symbol() public view virtual override returns (string memory) {
639         return _symbol;
640     }
641 
642     /**
643      * @dev See {IERC721Metadata-tokenURI}.
644      */
645     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
646         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
647 
648         string memory baseURI = _baseURI();
649         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
650     }
651 
652     /**
653      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
654      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
655      * by default, can be overriden in child contracts.
656      */
657     function _baseURI() internal view virtual returns (string memory) {
658         return "";
659     }
660 
661     /**
662      * @dev See {IERC721-approve}.
663      */
664     function approve(address to, uint256 tokenId) public virtual override {
665         address owner = ERC721.ownerOf(tokenId);
666         require(to != owner, "ERC721: approval to current owner");
667 
668         require(
669             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
670             "ERC721: approve caller is not owner nor approved for all"
671         );
672 
673         _approve(to, tokenId);
674     }
675 
676     /**
677      * @dev See {IERC721-getApproved}.
678      */
679     function getApproved(uint256 tokenId) public view virtual override returns (address) {
680         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
681 
682         return _tokenApprovals[tokenId];
683     }
684 
685     /**
686      * @dev See {IERC721-setApprovalForAll}.
687      */
688     function setApprovalForAll(address operator, bool approved) public virtual override {
689         require(operator != _msgSender(), "ERC721: approve to caller");
690 
691         _operatorApprovals[_msgSender()][operator] = approved;
692         emit ApprovalForAll(_msgSender(), operator, approved);
693     }
694 
695     /**
696      * @dev See {IERC721-isApprovedForAll}.
697      */
698     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
699         return _operatorApprovals[owner][operator];
700     }
701 
702     /**
703      * @dev See {IERC721-transferFrom}.
704      */
705     function transferFrom(
706         address from,
707         address to,
708         uint256 tokenId
709     ) public virtual override {
710         //solhint-disable-next-line max-line-length
711         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
712 
713         _transfer(from, to, tokenId);
714     }
715 
716     /**
717      * @dev See {IERC721-safeTransferFrom}.
718      */
719     function safeTransferFrom(
720         address from,
721         address to,
722         uint256 tokenId
723     ) public virtual override {
724         safeTransferFrom(from, to, tokenId, "");
725     }
726 
727     /**
728      * @dev See {IERC721-safeTransferFrom}.
729      */
730     function safeTransferFrom(
731         address from,
732         address to,
733         uint256 tokenId,
734         bytes memory _data
735     ) public virtual override {
736         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
737         _safeTransfer(from, to, tokenId, _data);
738     }
739 
740     /**
741      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
742      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
743      *
744      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
745      *
746      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
747      * implement alternative mechanisms to perform token transfer, such as signature-based.
748      *
749      * Requirements:
750      *
751      * - `from` cannot be the zero address.
752      * - `to` cannot be the zero address.
753      * - `tokenId` token must exist and be owned by `from`.
754      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
755      *
756      * Emits a {Transfer} event.
757      */
758     function _safeTransfer(
759         address from,
760         address to,
761         uint256 tokenId,
762         bytes memory _data
763     ) internal virtual {
764         _transfer(from, to, tokenId);
765         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
766     }
767 
768     /**
769      * @dev Returns whether `tokenId` exists.
770      *
771      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
772      *
773      * Tokens start existing when they are minted (`_mint`),
774      * and stop existing when they are burned (`_burn`).
775      */
776     function _exists(uint256 tokenId) internal view virtual returns (bool) {
777         return _owners[tokenId] != address(0);
778     }
779 
780     /**
781      * @dev Returns whether `spender` is allowed to manage `tokenId`.
782      *
783      * Requirements:
784      *
785      * - `tokenId` must exist.
786      */
787     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
788         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
789         address owner = ERC721.ownerOf(tokenId);
790         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
791     }
792 
793     /**
794      * @dev Safely mints `tokenId` and transfers it to `to`.
795      *
796      * Requirements:
797      *
798      * - `tokenId` must not exist.
799      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
800      *
801      * Emits a {Transfer} event.
802      */
803     function _safeMint(address to, uint256 tokenId) internal virtual {
804         _safeMint(to, tokenId, "");
805     }
806 
807     /**
808      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
809      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
810      */
811     function _safeMint(
812         address to,
813         uint256 tokenId,
814         bytes memory _data
815     ) internal virtual {
816         _mint(to, tokenId);
817         require(
818             _checkOnERC721Received(address(0), to, tokenId, _data),
819             "ERC721: transfer to non ERC721Receiver implementer"
820         );
821     }
822 
823     /**
824      * @dev Mints `tokenId` and transfers it to `to`.
825      *
826      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
827      *
828      * Requirements:
829      *
830      * - `tokenId` must not exist.
831      * - `to` cannot be the zero address.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _mint(address to, uint256 tokenId) internal virtual {
836         require(to != address(0), "ERC721: mint to the zero address");
837         require(!_exists(tokenId), "ERC721: token already minted");
838 
839         _beforeTokenTransfer(address(0), to, tokenId);
840 
841         _balances[to] += 1;
842         _owners[tokenId] = to;
843 
844         emit Transfer(address(0), to, tokenId);
845     }
846 
847     /**
848      * @dev Destroys `tokenId`.
849      * The approval is cleared when the token is burned.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _burn(uint256 tokenId) internal virtual {
858         address owner = ERC721.ownerOf(tokenId);
859 
860         _beforeTokenTransfer(owner, address(0), tokenId);
861 
862         // Clear approvals
863         _approve(address(0), tokenId);
864 
865         _balances[owner] -= 1;
866         delete _owners[tokenId];
867 
868         emit Transfer(owner, address(0), tokenId);
869     }
870 
871     /**
872      * @dev Transfers `tokenId` from `from` to `to`.
873      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
874      *
875      * Requirements:
876      *
877      * - `to` cannot be the zero address.
878      * - `tokenId` token must be owned by `from`.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _transfer(
883         address from,
884         address to,
885         uint256 tokenId
886     ) internal virtual {
887         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
888         require(to != address(0), "ERC721: transfer to the zero address");
889 
890         _beforeTokenTransfer(from, to, tokenId);
891 
892         // Clear approvals from the previous owner
893         _approve(address(0), tokenId);
894 
895         _balances[from] -= 1;
896         _balances[to] += 1;
897         _owners[tokenId] = to;
898 
899         emit Transfer(from, to, tokenId);
900     }
901 
902     /**
903      * @dev Approve `to` to operate on `tokenId`
904      *
905      * Emits a {Approval} event.
906      */
907     function _approve(address to, uint256 tokenId) internal virtual {
908         _tokenApprovals[tokenId] = to;
909         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
910     }
911 
912     /**
913      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
914      * The call is not executed if the target address is not a contract.
915      *
916      * @param from address representing the previous owner of the given token ID
917      * @param to target address that will receive the tokens
918      * @param tokenId uint256 ID of the token to be transferred
919      * @param _data bytes optional data to send along with the call
920      * @return bool whether the call correctly returned the expected magic value
921      */
922     function _checkOnERC721Received(
923         address from,
924         address to,
925         uint256 tokenId,
926         bytes memory _data
927     ) private returns (bool) {
928         if (to.isContract()) {
929             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
930                 return retval == IERC721Receiver.onERC721Received.selector;
931             } catch (bytes memory reason) {
932                 if (reason.length == 0) {
933                     revert("ERC721: transfer to non ERC721Receiver implementer");
934                 } else {
935                     assembly {
936                         revert(add(32, reason), mload(reason))
937                     }
938                 }
939             }
940         } else {
941             return true;
942         }
943     }
944 
945     /**
946      * @dev Hook that is called before any token transfer. This includes minting
947      * and burning.
948      *
949      * Calling conditions:
950      *
951      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
952      * transferred to `to`.
953      * - When `from` is zero, `tokenId` will be minted for `to`.
954      * - When `to` is zero, ``from``'s `tokenId` will be burned.
955      * - `from` and `to` are never both zero.
956      *
957      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
958      */
959     function _beforeTokenTransfer(
960         address from,
961         address to,
962         uint256 tokenId
963     ) internal virtual {}
964 }
965 
966 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
967 
968 pragma solidity ^0.8.0;
969 
970 
971 /**
972  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
973  * @dev See https://eips.ethereum.org/EIPS/eip-721
974  */
975 interface IERC721Enumerable is IERC721 {
976     /**
977      * @dev Returns the total amount of tokens stored by the contract.
978      */
979     function totalSupply() external view returns (uint256);
980 
981     /**
982      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
983      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
984      */
985     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
986 
987     /**
988      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
989      * Use along with {totalSupply} to enumerate all tokens.
990      */
991     function tokenByIndex(uint256 index) external view returns (uint256);
992 }
993 
994 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
995 
996 pragma solidity ^0.8.0;
997 
998 
999 
1000 /**
1001  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1002  * enumerability of all the token ids in the contract as well as all token ids owned by each
1003  * account.
1004  */
1005 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1006     // Mapping from owner to list of owned token IDs
1007     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1008 
1009     // Mapping from token ID to index of the owner tokens list
1010     mapping(uint256 => uint256) private _ownedTokensIndex;
1011 
1012     // Array with all token ids, used for enumeration
1013     uint256[] private _allTokens;
1014 
1015     // Mapping from token id to position in the allTokens array
1016     mapping(uint256 => uint256) private _allTokensIndex;
1017 
1018     /**
1019      * @dev See {IERC165-supportsInterface}.
1020      */
1021     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1022         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1027      */
1028     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1029         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1030         return _ownedTokens[owner][index];
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Enumerable-totalSupply}.
1035      */
1036     function totalSupply() public view virtual override returns (uint256) {
1037         return _allTokens.length;
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-tokenByIndex}.
1042      */
1043     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1044         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1045         return _allTokens[index];
1046     }
1047 
1048     /**
1049      * @dev Hook that is called before any token transfer. This includes minting
1050      * and burning.
1051      *
1052      * Calling conditions:
1053      *
1054      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1055      * transferred to `to`.
1056      * - When `from` is zero, `tokenId` will be minted for `to`.
1057      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1058      * - `from` cannot be the zero address.
1059      * - `to` cannot be the zero address.
1060      *
1061      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1062      */
1063     function _beforeTokenTransfer(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) internal virtual override {
1068         super._beforeTokenTransfer(from, to, tokenId);
1069 
1070         if (from == address(0)) {
1071             _addTokenToAllTokensEnumeration(tokenId);
1072         } else if (from != to) {
1073             _removeTokenFromOwnerEnumeration(from, tokenId);
1074         }
1075         if (to == address(0)) {
1076             _removeTokenFromAllTokensEnumeration(tokenId);
1077         } else if (to != from) {
1078             _addTokenToOwnerEnumeration(to, tokenId);
1079         }
1080     }
1081 
1082     /**
1083      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1084      * @param to address representing the new owner of the given token ID
1085      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1086      */
1087     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1088         uint256 length = ERC721.balanceOf(to);
1089         _ownedTokens[to][length] = tokenId;
1090         _ownedTokensIndex[tokenId] = length;
1091     }
1092 
1093     /**
1094      * @dev Private function to add a token to this extension's token tracking data structures.
1095      * @param tokenId uint256 ID of the token to be added to the tokens list
1096      */
1097     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1098         _allTokensIndex[tokenId] = _allTokens.length;
1099         _allTokens.push(tokenId);
1100     }
1101 
1102     /**
1103      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1104      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1105      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1106      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1107      * @param from address representing the previous owner of the given token ID
1108      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1109      */
1110     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1111         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1112         // then delete the last slot (swap and pop).
1113 
1114         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1115         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1116 
1117         // When the token to delete is the last token, the swap operation is unnecessary
1118         if (tokenIndex != lastTokenIndex) {
1119             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1120 
1121             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1122             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1123         }
1124 
1125         // This also deletes the contents at the last position of the array
1126         delete _ownedTokensIndex[tokenId];
1127         delete _ownedTokens[from][lastTokenIndex];
1128     }
1129 
1130     /**
1131      * @dev Private function to remove a token from this extension's token tracking data structures.
1132      * This has O(1) time complexity, but alters the order of the _allTokens array.
1133      * @param tokenId uint256 ID of the token to be removed from the tokens list
1134      */
1135     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1136         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1137         // then delete the last slot (swap and pop).
1138 
1139         uint256 lastTokenIndex = _allTokens.length - 1;
1140         uint256 tokenIndex = _allTokensIndex[tokenId];
1141 
1142         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1143         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1144         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1145         uint256 lastTokenId = _allTokens[lastTokenIndex];
1146 
1147         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1148         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1149 
1150         // This also deletes the contents at the last position of the array
1151         delete _allTokensIndex[tokenId];
1152         _allTokens.pop();
1153     }
1154 }
1155 
1156 // File: @openzeppelin/contracts/access/Ownable.sol
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 
1161 /**
1162  * @dev Contract module which provides a basic access control mechanism, where
1163  * there is an account (an owner) that can be granted exclusive access to
1164  * specific functions.
1165  *
1166  * By default, the owner account will be the one that deploys the contract. This
1167  * can later be changed with {transferOwnership}.
1168  *
1169  * This module is used through inheritance. It will make available the modifier
1170  * `onlyOwner`, which can be applied to your functions to restrict their use to
1171  * the owner.
1172  */
1173 abstract contract Ownable is Context {
1174     address private _owner;
1175 
1176     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1177 
1178     /**
1179      * @dev Initializes the contract setting the deployer as the initial owner.
1180      */
1181     constructor() {
1182         _setOwner(_msgSender());
1183     }
1184 
1185     /**
1186      * @dev Returns the address of the current owner.
1187      */
1188     function owner() public view virtual returns (address) {
1189         return _owner;
1190     }
1191 
1192     /**
1193      * @dev Throws if called by any account other than the owner.
1194      */
1195     modifier onlyOwner() {
1196         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1197         _;
1198     }
1199 
1200     /**
1201      * @dev Leaves the contract without owner. It will not be possible to call
1202      * `onlyOwner` functions anymore. Can only be called by the current owner.
1203      *
1204      * NOTE: Renouncing ownership will leave the contract without an owner,
1205      * thereby removing any functionality that is only available to the owner.
1206      */
1207     function renounceOwnership() public virtual onlyOwner {
1208         _setOwner(address(0));
1209     }
1210 
1211     /**
1212      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1213      * Can only be called by the current owner.
1214      */
1215     function transferOwnership(address newOwner) public virtual onlyOwner {
1216         require(newOwner != address(0), "Ownable: new owner is the zero address");
1217         _setOwner(newOwner);
1218     }
1219 
1220     function _setOwner(address newOwner) private {
1221         address oldOwner = _owner;
1222         _owner = newOwner;
1223         emit OwnershipTransferred(oldOwner, newOwner);
1224     }
1225 }
1226 
1227 // File: contracts/BabyToadz.sol
1228 
1229 /**
1230   SPDX-License-Identifier: GPL-3.0
1231   BABYTOADZ   
1232   Designer: skirano.eth
1233   Developer: jabeo.eth
1234  */          
1235 
1236 //################################################################################
1237 //################################################################################
1238 //###################################          ###################################
1239 //##############################     **********     ##############################
1240 //############################  ********************   ###########################
1241 //############################  ********************   ###########################
1242 //#########################   *************************  #########################
1243 //#########################   *************************  #########################
1244 //###############             *************************            ###############
1245 //#############  **********   *************************  **********   ############
1246 //##########   ***************  *************@@*****   ***************  ##########
1247 //########  ***************@@@@@@@@@@*****@@@**@@@@@@@@@@***************   #######
1248 //#####   ***************@@        ##@@@@@@@@@@###       @@@***************  #####
1249 //#####   ************@@@  @@@@@     ///,,,,,,,     @@@@@   @@*************  #####
1250 //#####   ************@@@  @@@     ##,*,,,,,,,,###     @@   @@*************  #####
1251 //#####   **@@@*******@@@##########,*,,,,,,,,,,**,##########@@***@@********  #####
1252 //#####   *****@@***@@(((#######,,,@@,,,,,,,,,,@@@,,########((@@@**********  #####
1253 //########  *****@@@((///,,(####,,,,*@@@@@@@@@@,,*,,#####*,,//(((@@*****   #######
1254 //##########   **@@@((**///,,,,,,,,,,##########,,,,,,,,,,/////(((@@***  ##########
1255 //#############  @@@((***/**/*,,,,,,,,,,,,,,,,*,,,,,,,***//*//(((@@   ############
1256 //#############  @@@(((((////*****/*,,,,,,,,,,,,,,****/***/*(((((@@   ############
1257 //##########   **@@@(((((((/*////*///**********/**/*////*((((((((@@***  ##########
1258 //########  *****@@@((((((((((((//*//          **///(((((((((((((@@**/@@   #######
1259 //#####   @@***@@@@@@@((((((((//*//               /**/*(((((((@@@@@@@@*****  #####
1260 //#####   **@@@(((((##@@@(((((##*//**          ****/###(((((@@###((*//@@***  #####
1261 //#####   **@@@#######@@@#######//*##**/     **###*/########@@#####(##@@***  #####
1262 //#####   *****@@########@@###@@,,,@@#(########@@@,,@@@##@@@#######@@@*****  #####
1263 //#####   ##@@@((@@@((#####(((,*,,**/@@@@@@@@@@(((,,**,//#####(((@@(((@@###  #####
1264 //########@@@@@@@@@@@@@@@((@@@((//*@@**/@@@@@((@@@((///@@*//@@@@@@@@@@@@@@@#######
1265 //##########   **********@@@@@@@@@@@@@@@#####@@@@@@@@@@@@@@@*********/  ##########
1266 //#############            #################################          ############
1267 //################################################################################  
1268 
1269 pragma solidity ^0.8.0;
1270 
1271 
1272 
1273 contract BabyToadz is ERC721Enumerable, Ownable {
1274   using Strings for uint256;
1275 
1276   struct Parents {
1277     uint256 top;
1278     uint256 bottom;
1279   }
1280 
1281   // --- Constants ---
1282   
1283   address creaturetoadz_addr = 0xA4631A191044096834Ce65d1EE86b16b171D8080;
1284 
1285   // --- Variables ---
1286 
1287   uint256 public constant maxSupply = 4444;
1288 
1289   bool public isMintingOpen = false;
1290   bool public isBurningAllowed = false;
1291 
1292   string public baseURI;
1293 
1294   mapping(uint256 => uint256) public babyOfParent;
1295   mapping(uint256 => Parents) public parentsOfBaby;
1296 
1297   // --- Intialization ---
1298 
1299   constructor(string memory _initBaseURI) ERC721("BabyToadz", "SMOLCROAK") {
1300     setBaseURI(_initBaseURI);
1301   }
1302 
1303   // --- Internal ---
1304 
1305   function _baseURI() internal view virtual override returns (string memory) {
1306     return baseURI;
1307   }
1308 
1309   // --- Public ---
1310 
1311   function toggleMinting(bool isOpen) public onlyOwner {
1312     isMintingOpen = isOpen;
1313   }
1314 
1315   function toggleBurning(bool isAllowed) public onlyOwner {
1316     isBurningAllowed = isAllowed;
1317   }
1318 
1319   function burnBaby(uint256 baby) public {
1320     require(isBurningAllowed, "Burning is not allowed.");
1321     require(ownerOf(baby) == msg.sender, "You don't own this baby.");
1322     _burn(baby);
1323   }
1324 
1325   function devMint(uint256 _toad1, uint256 _toad2) public onlyOwner {
1326     require(_toad1 >= 0 && _toad1 <= 8888, "Toad 1 is not valid.");
1327     require(_toad2 >= 0 && _toad2 <= 8888, "Toad 2 is not valid.");
1328 
1329     require(babyOfParent[_toad1] <= 0, "Toad 1 has already been bred.");
1330     require(babyOfParent[_toad2] <= 0, "Toad 2 has already been bred.");
1331 
1332     uint256 toadId = totalSupply() + 1;
1333 
1334     require(toadId <= maxSupply, "Max supply of BabyToadz already minted!");
1335     
1336     babyOfParent[_toad1] = toadId;
1337     babyOfParent[_toad2] = toadId;
1338 
1339     parentsOfBaby[toadId] = Parents(_toad1, _toad2);
1340 
1341     _safeMint(msg.sender, toadId);
1342   }
1343 
1344   function mint(uint256 _toad1, uint256 _toad2) public {
1345     require(isMintingOpen, "Minting is not open.");
1346     
1347     ERC721Enumerable creatureToadzToken = ERC721Enumerable(creaturetoadz_addr);
1348 
1349     require(creatureToadzToken.ownerOf(_toad1) == msg.sender, "You don't own toad 1.");
1350     require(creatureToadzToken.ownerOf(_toad2) == msg.sender, "You don't own toad 2.");
1351 
1352     require(babyOfParent[_toad1] <= 0, "Toad 1 has already been bred.");
1353     require(babyOfParent[_toad2] <= 0, "Toad 2 has already been bred.");
1354 
1355     uint256 toadId = totalSupply() + 1;
1356 
1357     require(toadId <= maxSupply, "Max supply of BabyToadz already minted!");
1358     
1359     babyOfParent[_toad1] = toadId;
1360     babyOfParent[_toad2] = toadId;
1361 
1362     parentsOfBaby[toadId] = Parents(_toad1, _toad2);
1363 
1364     _safeMint(msg.sender, toadId);
1365   }
1366 
1367   function hasBeenBred(uint256 toad) public view returns (bool) {
1368     return babyOfParent[toad] > 0;
1369   }
1370 
1371   function walletOfOwner(address _owner)
1372     public
1373     view
1374     returns (uint256[] memory)
1375   {
1376     uint256 ownerTokenCount = balanceOf(_owner);
1377     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1378     for (uint256 i; i < ownerTokenCount; i++) {
1379       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1380     }
1381     return tokenIds;
1382   }
1383 
1384   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1385     baseURI = _newBaseURI;
1386   }
1387 
1388 }