1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v3.4.1
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.1
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
168 
169 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.4.1
170 
171 pragma solidity ^0.8.0;
172 
173 /**
174  * @title ERC721 token receiver interface
175  * @dev Interface for any contract that wants to support safeTransfers
176  * from ERC721 asset contracts.
177  */
178 interface IERC721Receiver {
179     /**
180      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
181      * by `operator` from `from`, this function is called.
182      *
183      * It must return its Solidity selector to confirm the token transfer.
184      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
185      *
186      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
187      */
188     function onERC721Received(
189         address operator,
190         address from,
191         uint256 tokenId,
192         bytes calldata data
193     ) external returns (bytes4);
194 }
195 
196 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v3.4.1
197 
198 pragma solidity ^0.8.0;
199 
200 /**
201  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
202  * @dev See https://eips.ethereum.org/EIPS/eip-721
203  */
204 interface IERC721Metadata is IERC721 {
205     /**
206      * @dev Returns the token collection name.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the token collection symbol.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
217      */
218     function tokenURI(uint256 tokenId) external view returns (string memory);
219 }
220 
221 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
222 
223 pragma solidity ^0.8.0;
224 
225 /**
226  * @dev Collection of functions related to the address type
227  */
228 library Address {
229     /**
230      * @dev Returns true if `account` is a contract.
231      *
232      * [IMPORTANT]
233      * ====
234      * It is unsafe to assume that an address for which this function returns
235      * false is an externally-owned account (EOA) and not a contract.
236      *
237      * Among others, `isContract` will return false for the following
238      * types of addresses:
239      *
240      *  - an externally-owned account
241      *  - a contract in construction
242      *  - an address where a contract will be created
243      *  - an address where a contract lived, but was destroyed
244      * ====
245      */
246     function isContract(address account) internal view returns (bool) {
247         // This method relies on extcodesize, which returns 0 for contracts in
248         // construction, since the code is only stored at the end of the
249         // constructor execution.
250 
251         uint256 size;
252         assembly {
253             size := extcodesize(account)
254         }
255         return size > 0;
256     }
257 
258     /**
259      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
260      * `recipient`, forwarding all available gas and reverting on errors.
261      *
262      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
263      * of certain opcodes, possibly making contracts go over the 2300 gas limit
264      * imposed by `transfer`, making them unable to receive funds via
265      * `transfer`. {sendValue} removes this limitation.
266      *
267      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
268      *
269      * IMPORTANT: because control is transferred to `recipient`, care must be
270      * taken to not create reentrancy vulnerabilities. Consider using
271      * {ReentrancyGuard} or the
272      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
273      */
274     function sendValue(address payable recipient, uint256 amount) internal {
275         require(address(this).balance >= amount, "Address: insufficient balance");
276 
277         (bool success, ) = recipient.call{value: amount}("");
278         require(success, "Address: unable to send value, recipient may have reverted");
279     }
280 
281     /**
282      * @dev Performs a Solidity function call using a low level `call`. A
283      * plain `call` is an unsafe replacement for a function call: use this
284      * function instead.
285      *
286      * If `target` reverts with a revert reason, it is bubbled up by this
287      * function (like regular Solidity function calls).
288      *
289      * Returns the raw returned data. To convert to the expected return value,
290      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
291      *
292      * Requirements:
293      *
294      * - `target` must be a contract.
295      * - calling `target` with `data` must not revert.
296      *
297      * _Available since v3.1._
298      */
299     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
300         return functionCall(target, data, "Address: low-level call failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
305      * `errorMessage` as a fallback revert reason when `target` reverts.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(
310         address target,
311         bytes memory data,
312         string memory errorMessage
313     ) internal returns (bytes memory) {
314         return functionCallWithValue(target, data, 0, errorMessage);
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
319      * but also transferring `value` wei to `target`.
320      *
321      * Requirements:
322      *
323      * - the calling contract must have an ETH balance of at least `value`.
324      * - the called Solidity function must be `payable`.
325      *
326      * _Available since v3.1._
327      */
328     function functionCallWithValue(
329         address target,
330         bytes memory data,
331         uint256 value
332     ) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
338      * with `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value,
346         string memory errorMessage
347     ) internal returns (bytes memory) {
348         require(address(this).balance >= value, "Address: insufficient balance for call");
349         require(isContract(target), "Address: call to non-contract");
350 
351         (bool success, bytes memory returndata) = target.call{value: value}(data);
352         return _verifyCallResult(success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but performing a static call.
358      *
359      * _Available since v3.3._
360      */
361     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
362         return functionStaticCall(target, data, "Address: low-level static call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(
372         address target,
373         bytes memory data,
374         string memory errorMessage
375     ) internal view returns (bytes memory) {
376         require(isContract(target), "Address: static call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.staticcall(data);
379         return _verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a delegate call.
385      *
386      * _Available since v3.4._
387      */
388     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
389         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         require(isContract(target), "Address: delegate call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.delegatecall(data);
406         return _verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     function _verifyCallResult(
410         bool success,
411         bytes memory returndata,
412         string memory errorMessage
413     ) private pure returns (bytes memory) {
414         if (success) {
415             return returndata;
416         } else {
417             // Look for revert reason and bubble it up if present
418             if (returndata.length > 0) {
419                 // The easiest way to bubble the revert reason is using memory via assembly
420 
421                 assembly {
422                     let returndata_size := mload(returndata)
423                     revert(add(32, returndata), returndata_size)
424                 }
425             } else {
426                 revert(errorMessage);
427             }
428         }
429     }
430 }
431 
432 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
433 
434 pragma solidity ^0.8.0;
435 
436 /*
437  * @dev Provides information about the current execution context, including the
438  * sender of the transaction and its data. While these are generally available
439  * via msg.sender and msg.data, they should not be accessed in such a direct
440  * manner, since when dealing with meta-transactions the account sending and
441  * paying for execution may not be the actual sender (as far as an application
442  * is concerned).
443  *
444  * This contract is only required for intermediate, library-like contracts.
445  */
446 abstract contract Context {
447     function _msgSender() internal view virtual returns (address) {
448         return msg.sender;
449     }
450 
451     function _msgData() internal view virtual returns (bytes calldata) {
452         return msg.data;
453     }
454 }
455 
456 // File @openzeppelin/contracts/utils/Strings.sol@v3.4.1
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @dev String operations.
462  */
463 library Strings {
464     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
465 
466     /**
467      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
468      */
469     function toString(uint256 value) internal pure returns (string memory) {
470         // Inspired by OraclizeAPI's implementation - MIT licence
471         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
472 
473         if (value == 0) {
474             return "0";
475         }
476         uint256 temp = value;
477         uint256 digits;
478         while (temp != 0) {
479             digits++;
480             temp /= 10;
481         }
482         bytes memory buffer = new bytes(digits);
483         while (value != 0) {
484             digits -= 1;
485             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
486             value /= 10;
487         }
488         return string(buffer);
489     }
490 
491     /**
492      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
493      */
494     function toHexString(uint256 value) internal pure returns (string memory) {
495         if (value == 0) {
496             return "0x00";
497         }
498         uint256 temp = value;
499         uint256 length = 0;
500         while (temp != 0) {
501             length++;
502             temp >>= 8;
503         }
504         return toHexString(value, length);
505     }
506 
507     /**
508      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
509      */
510     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
511         bytes memory buffer = new bytes(2 * length + 2);
512         buffer[0] = "0";
513         buffer[1] = "x";
514         for (uint256 i = 2 * length + 1; i > 1; --i) {
515             buffer[i] = _HEX_SYMBOLS[value & 0xf];
516             value >>= 4;
517         }
518         require(value == 0, "Strings: hex length insufficient");
519         return string(buffer);
520     }
521 }
522 
523 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v3.4.1
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Implementation of the {IERC165} interface.
529  *
530  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
531  * for the additional interface id that will be supported. For example:
532  *
533  * ```solidity
534  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
536  * }
537  * ```
538  *
539  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
540  */
541 abstract contract ERC165 is IERC165 {
542     /**
543      * @dev See {IERC165-supportsInterface}.
544      */
545     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
546         return interfaceId == type(IERC165).interfaceId;
547     }
548 }
549 
550 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.4.1
551 
552 pragma solidity ^0.8.0;
553 
554 /**
555  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
556  * the Metadata extension, but not including the Enumerable extension, which is available separately as
557  * {ERC721Enumerable}.
558  */
559 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
560     using Address for address;
561     using Strings for uint256;
562 
563     // Token name
564     string private _name;
565 
566     // Token symbol
567     string private _symbol;
568 
569     // Mapping from token ID to owner address
570     mapping(uint256 => address) private _owners;
571 
572     // Mapping owner address to token count
573     mapping(address => uint256) private _balances;
574 
575     // Mapping from token ID to approved address
576     mapping(uint256 => address) private _tokenApprovals;
577 
578     // Mapping from owner to operator approvals
579     mapping(address => mapping(address => bool)) private _operatorApprovals;
580 
581     /**
582      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
583      */
584     constructor(string memory name_, string memory symbol_) {
585         _name = name_;
586         _symbol = symbol_;
587     }
588 
589     /**
590      * @dev See {IERC165-supportsInterface}.
591      */
592     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
593         return
594             interfaceId == type(IERC721).interfaceId ||
595             interfaceId == type(IERC721Metadata).interfaceId ||
596             super.supportsInterface(interfaceId);
597     }
598 
599     /**
600      * @dev See {IERC721-balanceOf}.
601      */
602     function balanceOf(address owner) public view virtual override returns (uint256) {
603         require(owner != address(0), "ERC721: balance query for the zero address");
604         return _balances[owner];
605     }
606 
607     /**
608      * @dev See {IERC721-ownerOf}.
609      */
610     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
611         address owner = _owners[tokenId];
612         require(owner != address(0), "ERC721: owner query for nonexistent token");
613         return owner;
614     }
615 
616     /**
617      * @dev See {IERC721Metadata-name}.
618      */
619     function name() public view virtual override returns (string memory) {
620         return _name;
621     }
622 
623     /**
624      * @dev See {IERC721Metadata-symbol}.
625      */
626     function symbol() public view virtual override returns (string memory) {
627         return _symbol;
628     }
629 
630     /**
631      * @dev See {IERC721Metadata-tokenURI}.
632      */
633     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
634         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
635 
636         string memory baseURI = _baseURI();
637         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
638     }
639 
640     /**
641      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
642      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
643      * by default, can be overriden in child contracts.
644      */
645     function _baseURI() internal view virtual returns (string memory) {
646         return "";
647     }
648 
649     /**
650      * @dev See {IERC721-approve}.
651      */
652     function approve(address to, uint256 tokenId) public virtual override {
653         address owner = ERC721.ownerOf(tokenId);
654         require(to != owner, "ERC721: approval to current owner");
655 
656         require(
657             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
658             "ERC721: approve caller is not owner nor approved for all"
659         );
660 
661         _approve(to, tokenId);
662     }
663 
664     /**
665      * @dev See {IERC721-getApproved}.
666      */
667     function getApproved(uint256 tokenId) public view virtual override returns (address) {
668         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
669 
670         return _tokenApprovals[tokenId];
671     }
672 
673     /**
674      * @dev See {IERC721-setApprovalForAll}.
675      */
676     function setApprovalForAll(address operator, bool approved) public virtual override {
677         require(operator != _msgSender(), "ERC721: approve to caller");
678 
679         _operatorApprovals[_msgSender()][operator] = approved;
680         emit ApprovalForAll(_msgSender(), operator, approved);
681     }
682 
683     /**
684      * @dev See {IERC721-isApprovedForAll}.
685      */
686     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
687         return _operatorApprovals[owner][operator];
688     }
689 
690     /**
691      * @dev See {IERC721-transferFrom}.
692      */
693     function transferFrom(
694         address from,
695         address to,
696         uint256 tokenId
697     ) public virtual override {
698         //solhint-disable-next-line max-line-length
699         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
700 
701         _transfer(from, to, tokenId);
702     }
703 
704     /**
705      * @dev See {IERC721-safeTransferFrom}.
706      */
707     function safeTransferFrom(
708         address from,
709         address to,
710         uint256 tokenId
711     ) public virtual override {
712         safeTransferFrom(from, to, tokenId, "");
713     }
714 
715     /**
716      * @dev See {IERC721-safeTransferFrom}.
717      */
718     function safeTransferFrom(
719         address from,
720         address to,
721         uint256 tokenId,
722         bytes memory _data
723     ) public virtual override {
724         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
725         _safeTransfer(from, to, tokenId, _data);
726     }
727 
728     /**
729      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
730      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
731      *
732      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
733      *
734      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
735      * implement alternative mechanisms to perform token transfer, such as signature-based.
736      *
737      * Requirements:
738      *
739      * - `from` cannot be the zero address.
740      * - `to` cannot be the zero address.
741      * - `tokenId` token must exist and be owned by `from`.
742      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743      *
744      * Emits a {Transfer} event.
745      */
746     function _safeTransfer(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes memory _data
751     ) internal virtual {
752         _transfer(from, to, tokenId);
753         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
754     }
755 
756     /**
757      * @dev Returns whether `tokenId` exists.
758      *
759      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
760      *
761      * Tokens start existing when they are minted (`_mint`),
762      * and stop existing when they are burned (`_burn`).
763      */
764     function _exists(uint256 tokenId) internal view virtual returns (bool) {
765         return _owners[tokenId] != address(0);
766     }
767 
768     /**
769      * @dev Returns whether `spender` is allowed to manage `tokenId`.
770      *
771      * Requirements:
772      *
773      * - `tokenId` must exist.
774      */
775     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
776         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
777         address owner = ERC721.ownerOf(tokenId);
778         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
779     }
780 
781     /**
782      * @dev Safely mints `tokenId` and transfers it to `to`.
783      *
784      * Requirements:
785      *
786      * - `tokenId` must not exist.
787      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
788      *
789      * Emits a {Transfer} event.
790      */
791     function _safeMint(address to, uint256 tokenId) internal virtual {
792         _safeMint(to, tokenId, "");
793     }
794 
795     /**
796      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
797      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
798      */
799     function _safeMint(
800         address to,
801         uint256 tokenId,
802         bytes memory _data
803     ) internal virtual {
804         _mint(to, tokenId);
805         require(
806             _checkOnERC721Received(address(0), to, tokenId, _data),
807             "ERC721: transfer to non ERC721Receiver implementer"
808         );
809     }
810 
811     /**
812      * @dev Mints `tokenId` and transfers it to `to`.
813      *
814      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
815      *
816      * Requirements:
817      *
818      * - `tokenId` must not exist.
819      * - `to` cannot be the zero address.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _mint(address to, uint256 tokenId) internal virtual {
824         require(to != address(0), "ERC721: mint to the zero address");
825         require(!_exists(tokenId), "ERC721: token already minted");
826 
827         _beforeTokenTransfer(address(0), to, tokenId);
828 
829         _balances[to] += 1;
830         _owners[tokenId] = to;
831 
832         emit Transfer(address(0), to, tokenId);
833     }
834 
835     /**
836      * @dev Destroys `tokenId`.
837      * The approval is cleared when the token is burned.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must exist.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _burn(uint256 tokenId) internal virtual {
846         address owner = ERC721.ownerOf(tokenId);
847 
848         _beforeTokenTransfer(owner, address(0), tokenId);
849 
850         // Clear approvals
851         _approve(address(0), tokenId);
852 
853         _balances[owner] -= 1;
854         delete _owners[tokenId];
855 
856         emit Transfer(owner, address(0), tokenId);
857     }
858 
859     /**
860      * @dev Transfers `tokenId` from `from` to `to`.
861      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
862      *
863      * Requirements:
864      *
865      * - `to` cannot be the zero address.
866      * - `tokenId` token must be owned by `from`.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _transfer(
871         address from,
872         address to,
873         uint256 tokenId
874     ) internal virtual {
875         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
876         require(to != address(0), "ERC721: transfer to the zero address");
877 
878         _beforeTokenTransfer(from, to, tokenId);
879 
880         // Clear approvals from the previous owner
881         _approve(address(0), tokenId);
882 
883         _balances[from] -= 1;
884         _balances[to] += 1;
885         _owners[tokenId] = to;
886 
887         emit Transfer(from, to, tokenId);
888     }
889 
890     /**
891      * @dev Approve `to` to operate on `tokenId`
892      *
893      * Emits a {Approval} event.
894      */
895     function _approve(address to, uint256 tokenId) internal virtual {
896         _tokenApprovals[tokenId] = to;
897         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
898     }
899 
900     /**
901      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
902      * The call is not executed if the target address is not a contract.
903      *
904      * @param from address representing the previous owner of the given token ID
905      * @param to target address that will receive the tokens
906      * @param tokenId uint256 ID of the token to be transferred
907      * @param _data bytes optional data to send along with the call
908      * @return bool whether the call correctly returned the expected magic value
909      */
910     function _checkOnERC721Received(
911         address from,
912         address to,
913         uint256 tokenId,
914         bytes memory _data
915     ) private returns (bool) {
916         if (to.isContract()) {
917             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
918                 return retval == IERC721Receiver(to).onERC721Received.selector;
919             } catch (bytes memory reason) {
920                 if (reason.length == 0) {
921                     revert("ERC721: transfer to non ERC721Receiver implementer");
922                 } else {
923                     assembly {
924                         revert(add(32, reason), mload(reason))
925                     }
926                 }
927             }
928         } else {
929             return true;
930         }
931     }
932 
933     /**
934      * @dev Hook that is called before any token transfer. This includes minting
935      * and burning.
936      *
937      * Calling conditions:
938      *
939      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
940      * transferred to `to`.
941      * - When `from` is zero, `tokenId` will be minted for `to`.
942      * - When `to` is zero, ``from``'s `tokenId` will be burned.
943      * - `from` and `to` are never both zero.
944      *
945      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
946      */
947     function _beforeTokenTransfer(
948         address from,
949         address to,
950         uint256 tokenId
951     ) internal virtual {}
952 }
953 
954 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v3.4.1
955 
956 pragma solidity ^0.8.0;
957 
958 /**
959  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
960  * @dev See https://eips.ethereum.org/EIPS/eip-721
961  */
962 interface IERC721Enumerable is IERC721 {
963     /**
964      * @dev Returns the total amount of tokens stored by the contract.
965      */
966     function totalSupply() external view returns (uint256);
967 
968     /**
969      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
970      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
971      */
972     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
973 
974     /**
975      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
976      * Use along with {totalSupply} to enumerate all tokens.
977      */
978     function tokenByIndex(uint256 index) external view returns (uint256);
979 }
980 
981 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v3.4.1
982 
983 pragma solidity ^0.8.0;
984 
985 /**
986  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
987  * enumerability of all the token ids in the contract as well as all token ids owned by each
988  * account.
989  */
990 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
991     // Mapping from owner to list of owned token IDs
992     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
993 
994     // Mapping from token ID to index of the owner tokens list
995     mapping(uint256 => uint256) private _ownedTokensIndex;
996 
997     // Array with all token ids, used for enumeration
998     uint256[] private _allTokens;
999 
1000     // Mapping from token id to position in the allTokens array
1001     mapping(uint256 => uint256) private _allTokensIndex;
1002 
1003     /**
1004      * @dev See {IERC165-supportsInterface}.
1005      */
1006     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1007         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1012      */
1013     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1014         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1015         return _ownedTokens[owner][index];
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Enumerable-totalSupply}.
1020      */
1021     function totalSupply() public view virtual override returns (uint256) {
1022         return _allTokens.length;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Enumerable-tokenByIndex}.
1027      */
1028     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1029         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1030         return _allTokens[index];
1031     }
1032 
1033     /**
1034      * @dev Hook that is called before any token transfer. This includes minting
1035      * and burning.
1036      *
1037      * Calling conditions:
1038      *
1039      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1040      * transferred to `to`.
1041      * - When `from` is zero, `tokenId` will be minted for `to`.
1042      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1043      * - `from` cannot be the zero address.
1044      * - `to` cannot be the zero address.
1045      *
1046      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1047      */
1048     function _beforeTokenTransfer(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) internal virtual override {
1053         super._beforeTokenTransfer(from, to, tokenId);
1054 
1055         if (from == address(0)) {
1056             _addTokenToAllTokensEnumeration(tokenId);
1057         } else if (from != to) {
1058             _removeTokenFromOwnerEnumeration(from, tokenId);
1059         }
1060         if (to == address(0)) {
1061             _removeTokenFromAllTokensEnumeration(tokenId);
1062         } else if (to != from) {
1063             _addTokenToOwnerEnumeration(to, tokenId);
1064         }
1065     }
1066 
1067     /**
1068      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1069      * @param to address representing the new owner of the given token ID
1070      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1071      */
1072     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1073         uint256 length = ERC721.balanceOf(to);
1074         _ownedTokens[to][length] = tokenId;
1075         _ownedTokensIndex[tokenId] = length;
1076     }
1077 
1078     /**
1079      * @dev Private function to add a token to this extension's token tracking data structures.
1080      * @param tokenId uint256 ID of the token to be added to the tokens list
1081      */
1082     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1083         _allTokensIndex[tokenId] = _allTokens.length;
1084         _allTokens.push(tokenId);
1085     }
1086 
1087     /**
1088      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1089      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1090      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1091      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1092      * @param from address representing the previous owner of the given token ID
1093      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1094      */
1095     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1096         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1097         // then delete the last slot (swap and pop).
1098 
1099         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1100         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1101 
1102         // When the token to delete is the last token, the swap operation is unnecessary
1103         if (tokenIndex != lastTokenIndex) {
1104             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1105 
1106             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1107             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1108         }
1109 
1110         // This also deletes the contents at the last position of the array
1111         delete _ownedTokensIndex[tokenId];
1112         delete _ownedTokens[from][lastTokenIndex];
1113     }
1114 
1115     /**
1116      * @dev Private function to remove a token from this extension's token tracking data structures.
1117      * This has O(1) time complexity, but alters the order of the _allTokens array.
1118      * @param tokenId uint256 ID of the token to be removed from the tokens list
1119      */
1120     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1121         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1122         // then delete the last slot (swap and pop).
1123 
1124         uint256 lastTokenIndex = _allTokens.length - 1;
1125         uint256 tokenIndex = _allTokensIndex[tokenId];
1126 
1127         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1128         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1129         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1130         uint256 lastTokenId = _allTokens[lastTokenIndex];
1131 
1132         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1133         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1134 
1135         // This also deletes the contents at the last position of the array
1136         delete _allTokensIndex[tokenId];
1137         _allTokens.pop();
1138     }
1139 }
1140 
1141 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v3.4.1
1142 
1143 pragma solidity ^0.8.0;
1144 
1145 /**
1146  * @title ERC721 Burnable Token
1147  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1148  */
1149 abstract contract ERC721Burnable is Context, ERC721 {
1150     /**
1151      * @dev Burns `tokenId`. See {ERC721-_burn}.
1152      *
1153      * Requirements:
1154      *
1155      * - The caller must own `tokenId` or be an approved operator.
1156      */
1157     function burn(uint256 tokenId) public virtual {
1158         //solhint-disable-next-line max-line-length
1159         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1160         _burn(tokenId);
1161     }
1162 }
1163 
1164 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
1165 
1166 pragma solidity ^0.8.0;
1167 
1168 /**
1169  * @dev Contract module which provides a basic access control mechanism, where
1170  * there is an account (an owner) that can be granted exclusive access to
1171  * specific functions.
1172  *
1173  * By default, the owner account will be the one that deploys the contract. This
1174  * can later be changed with {transferOwnership}.
1175  *
1176  * This module is used through inheritance. It will make available the modifier
1177  * `onlyOwner`, which can be applied to your functions to restrict their use to
1178  * the owner.
1179  */
1180 abstract contract Ownable is Context {
1181     address private _owner;
1182 
1183     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1184 
1185     /**
1186      * @dev Initializes the contract setting the deployer as the initial owner.
1187      */
1188     constructor() {
1189         _setOwner(_msgSender());
1190     }
1191 
1192     /**
1193      * @dev Returns the address of the current owner.
1194      */
1195     function owner() public view virtual returns (address) {
1196         return _owner;
1197     }
1198 
1199     /**
1200      * @dev Throws if called by any account other than the owner.
1201      */
1202     modifier onlyOwner() {
1203         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1204         _;
1205     }
1206 
1207     /**
1208      * @dev Leaves the contract without owner. It will not be possible to call
1209      * `onlyOwner` functions anymore. Can only be called by the current owner.
1210      *
1211      * NOTE: Renouncing ownership will leave the contract without an owner,
1212      * thereby removing any functionality that is only available to the owner.
1213      */
1214     function renounceOwnership() public virtual onlyOwner {
1215         _setOwner(address(0));
1216     }
1217 
1218     /**
1219      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1220      * Can only be called by the current owner.
1221      */
1222     function transferOwnership(address newOwner) public virtual onlyOwner {
1223         require(newOwner != address(0), "Ownable: new owner is the zero address");
1224         _setOwner(newOwner);
1225     }
1226 
1227     function _setOwner(address newOwner) private {
1228         address oldOwner = _owner;
1229         _owner = newOwner;
1230         emit OwnershipTransferred(oldOwner, newOwner);
1231     }
1232 }
1233 
1234 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v3.4.1
1235 
1236 pragma solidity ^0.8.0;
1237 
1238 // CAUTION
1239 // This version of SafeMath should only be used with Solidity 0.8 or later,
1240 // because it relies on the compiler's built in overflow checks.
1241 
1242 /**
1243  * @dev Wrappers over Solidity's arithmetic operations.
1244  *
1245  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1246  * now has built in overflow checking.
1247  */
1248 library SafeMath {
1249     /**
1250      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1251      *
1252      * _Available since v3.4._
1253      */
1254     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1255         unchecked {
1256             uint256 c = a + b;
1257             if (c < a) return (false, 0);
1258             return (true, c);
1259         }
1260     }
1261 
1262     /**
1263      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1264      *
1265      * _Available since v3.4._
1266      */
1267     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1268         unchecked {
1269             if (b > a) return (false, 0);
1270             return (true, a - b);
1271         }
1272     }
1273 
1274     /**
1275      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1276      *
1277      * _Available since v3.4._
1278      */
1279     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1280         unchecked {
1281             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1282             // benefit is lost if 'b' is also tested.
1283             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1284             if (a == 0) return (true, 0);
1285             uint256 c = a * b;
1286             if (c / a != b) return (false, 0);
1287             return (true, c);
1288         }
1289     }
1290 
1291     /**
1292      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1293      *
1294      * _Available since v3.4._
1295      */
1296     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1297         unchecked {
1298             if (b == 0) return (false, 0);
1299             return (true, a / b);
1300         }
1301     }
1302 
1303     /**
1304      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1305      *
1306      * _Available since v3.4._
1307      */
1308     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1309         unchecked {
1310             if (b == 0) return (false, 0);
1311             return (true, a % b);
1312         }
1313     }
1314 
1315     /**
1316      * @dev Returns the addition of two unsigned integers, reverting on
1317      * overflow.
1318      *
1319      * Counterpart to Solidity's `+` operator.
1320      *
1321      * Requirements:
1322      *
1323      * - Addition cannot overflow.
1324      */
1325     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1326         return a + b;
1327     }
1328 
1329     /**
1330      * @dev Returns the subtraction of two unsigned integers, reverting on
1331      * overflow (when the result is negative).
1332      *
1333      * Counterpart to Solidity's `-` operator.
1334      *
1335      * Requirements:
1336      *
1337      * - Subtraction cannot overflow.
1338      */
1339     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1340         return a - b;
1341     }
1342 
1343     /**
1344      * @dev Returns the multiplication of two unsigned integers, reverting on
1345      * overflow.
1346      *
1347      * Counterpart to Solidity's `*` operator.
1348      *
1349      * Requirements:
1350      *
1351      * - Multiplication cannot overflow.
1352      */
1353     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1354         return a * b;
1355     }
1356 
1357     /**
1358      * @dev Returns the integer division of two unsigned integers, reverting on
1359      * division by zero. The result is rounded towards zero.
1360      *
1361      * Counterpart to Solidity's `/` operator.
1362      *
1363      * Requirements:
1364      *
1365      * - The divisor cannot be zero.
1366      */
1367     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1368         return a / b;
1369     }
1370 
1371     /**
1372      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1373      * reverting when dividing by zero.
1374      *
1375      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1376      * opcode (which leaves remaining gas untouched) while Solidity uses an
1377      * invalid opcode to revert (consuming all remaining gas).
1378      *
1379      * Requirements:
1380      *
1381      * - The divisor cannot be zero.
1382      */
1383     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1384         return a % b;
1385     }
1386 
1387     /**
1388      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1389      * overflow (when the result is negative).
1390      *
1391      * CAUTION: This function is deprecated because it requires allocating memory for the error
1392      * message unnecessarily. For custom revert reasons use {trySub}.
1393      *
1394      * Counterpart to Solidity's `-` operator.
1395      *
1396      * Requirements:
1397      *
1398      * - Subtraction cannot overflow.
1399      */
1400     function sub(
1401         uint256 a,
1402         uint256 b,
1403         string memory errorMessage
1404     ) internal pure returns (uint256) {
1405         unchecked {
1406             require(b <= a, errorMessage);
1407             return a - b;
1408         }
1409     }
1410 
1411     /**
1412      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1413      * division by zero. The result is rounded towards zero.
1414      *
1415      * Counterpart to Solidity's `/` operator. Note: this function uses a
1416      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1417      * uses an invalid opcode to revert (consuming all remaining gas).
1418      *
1419      * Requirements:
1420      *
1421      * - The divisor cannot be zero.
1422      */
1423     function div(
1424         uint256 a,
1425         uint256 b,
1426         string memory errorMessage
1427     ) internal pure returns (uint256) {
1428         unchecked {
1429             require(b > 0, errorMessage);
1430             return a / b;
1431         }
1432     }
1433 
1434     /**
1435      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1436      * reverting with custom message when dividing by zero.
1437      *
1438      * CAUTION: This function is deprecated because it requires allocating memory for the error
1439      * message unnecessarily. For custom revert reasons use {tryMod}.
1440      *
1441      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1442      * opcode (which leaves remaining gas untouched) while Solidity uses an
1443      * invalid opcode to revert (consuming all remaining gas).
1444      *
1445      * Requirements:
1446      *
1447      * - The divisor cannot be zero.
1448      */
1449     function mod(
1450         uint256 a,
1451         uint256 b,
1452         string memory errorMessage
1453     ) internal pure returns (uint256) {
1454         unchecked {
1455             require(b > 0, errorMessage);
1456             return a % b;
1457         }
1458     }
1459 }
1460 
1461 // File @openzeppelin/contracts/utils/Counters.sol@v3.4.1
1462 
1463 pragma solidity ^0.8.0;
1464 
1465 /**
1466  * @title Counters
1467  * @author Matt Condon (@shrugs)
1468  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1469  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1470  *
1471  * Include with `using Counters for Counters.Counter;`
1472  */
1473 library Counters {
1474     struct Counter {
1475         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1476         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1477         // this feature: see https://github.com/ethereum/solidity/issues/4637
1478         uint256 _value; // default: 0
1479     }
1480 
1481     function current(Counter storage counter) internal view returns (uint256) {
1482         return counter._value;
1483     }
1484 
1485     function increment(Counter storage counter) internal {
1486         unchecked {
1487             counter._value += 1;
1488         }
1489     }
1490 
1491     function decrement(Counter storage counter) internal {
1492         uint256 value = counter._value;
1493         require(value > 0, "Counter: decrement overflow");
1494         unchecked {
1495             counter._value = value - 1;
1496         }
1497     }
1498 
1499     function reset(Counter storage counter) internal {
1500         counter._value = 0;
1501     }
1502 }
1503 
1504 // File @openzeppelin/contracts/security/Pausable.sol@v3.4.1
1505 
1506 pragma solidity ^0.8.0;
1507 
1508 /**
1509  * @dev Contract module which allows children to implement an emergency stop
1510  * mechanism that can be triggered by an authorized account.
1511  *
1512  * This module is used through inheritance. It will make available the
1513  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1514  * the functions of your contract. Note that they will not be pausable by
1515  * simply including this module, only once the modifiers are put in place.
1516  */
1517 abstract contract Pausable is Context {
1518     /**
1519      * @dev Emitted when the pause is triggered by `account`.
1520      */
1521     event Paused(address account);
1522 
1523     /**
1524      * @dev Emitted when the pause is lifted by `account`.
1525      */
1526     event Unpaused(address account);
1527 
1528     bool private _paused;
1529 
1530     /**
1531      * @dev Initializes the contract in unpaused state.
1532      */
1533     constructor() {
1534         _paused = false;
1535     }
1536 
1537     /**
1538      * @dev Returns true if the contract is paused, and false otherwise.
1539      */
1540     function paused() public view virtual returns (bool) {
1541         return _paused;
1542     }
1543 
1544     /**
1545      * @dev Modifier to make a function callable only when the contract is not paused.
1546      *
1547      * Requirements:
1548      *
1549      * - The contract must not be paused.
1550      */
1551     modifier whenNotPaused() {
1552         require(!paused(), "Pausable: paused");
1553         _;
1554     }
1555 
1556     /**
1557      * @dev Modifier to make a function callable only when the contract is paused.
1558      *
1559      * Requirements:
1560      *
1561      * - The contract must be paused.
1562      */
1563     modifier whenPaused() {
1564         require(paused(), "Pausable: not paused");
1565         _;
1566     }
1567 
1568     /**
1569      * @dev Triggers stopped state.
1570      *
1571      * Requirements:
1572      *
1573      * - The contract must not be paused.
1574      */
1575     function _pause() internal virtual whenNotPaused {
1576         _paused = true;
1577         emit Paused(_msgSender());
1578     }
1579 
1580     /**
1581      * @dev Returns to normal state.
1582      *
1583      * Requirements:
1584      *
1585      * - The contract must be paused.
1586      */
1587     function _unpause() internal virtual whenPaused {
1588         _paused = false;
1589         emit Unpaused(_msgSender());
1590     }
1591 }
1592 
1593 // File contracts/ERC721Pausable.sol
1594 
1595 pragma solidity ^0.8.0;
1596 
1597 /**
1598  * @dev ERC721 token with pausable token transfers, minting and burning.
1599  *
1600  * Useful for scenarios such as preventing trades until the end of an evaluation
1601  * period, or having an emergency switch for freezing all token transfers in the
1602  * event of a large bug.
1603  */
1604 abstract contract ERC721Pausable is ERC721, Ownable, Pausable {
1605     /**
1606      * @dev See {ERC721-_beforeTokenTransfer}.
1607      *
1608      * Requirements:
1609      *
1610      * - the contract must not be paused.
1611      */
1612     function _beforeTokenTransfer(
1613         address from,
1614         address to,
1615         uint256 tokenId
1616     ) internal virtual override {
1617         super._beforeTokenTransfer(from, to, tokenId);
1618         if (_msgSender() != owner()) {
1619             require(!paused(), "ERC721Pausable: token transfer while paused");
1620         }
1621     }
1622 }
1623 
1624 // File contracts/MemberCard.sol
1625 
1626 pragma solidity ^0.8.0;
1627 
1628 contract MemberCard is ERC721Enumerable, Ownable, ERC721Burnable, ERC721Pausable {
1629     using SafeMath for uint256;
1630     using Counters for Counters.Counter;
1631 
1632     Counters.Counter private _tokenIdTracker;
1633 
1634     uint256 public constant MAX_ELEMENTS = 10000;
1635     uint256 public constant PRICE = 888 * 10**14;
1636     uint256 public constant MAX_BY_MINT = 20;
1637     uint256 public constant RESERVE = 175;
1638     address public constant treasuryAddress = 0xf7Fe522a09af80e04F8340f7D9B4641814b510C2;
1639     string public baseTokenURI;
1640 
1641     event CreateMembership(uint256 indexed id);
1642 
1643     constructor(string memory baseURI) ERC721("NFTG Opus Guild", "NFTG OG") {
1644         setBaseURI(baseURI);
1645         pause(true);
1646     }
1647 
1648     modifier saleIsOpen {
1649         require(_totalSupply() <= MAX_ELEMENTS, "Sale end");
1650         if (_msgSender() != owner()) {
1651             require(!paused(), "Pausable: paused");
1652         }
1653         _;
1654     }
1655 
1656     function _totalSupply() internal view returns (uint256) {
1657         return _tokenIdTracker.current();
1658     }
1659 
1660     function totalMint() public view returns (uint256) {
1661         return _totalSupply();
1662     }
1663 
1664     function mint(address _to, uint256 _count) public payable saleIsOpen {
1665         uint256 total = _totalSupply() + RESERVE;
1666 
1667         if (_msgSender() == owner()) {
1668             total = _totalSupply();
1669         }
1670 
1671         require(total + _count <= MAX_ELEMENTS, "Max limit");
1672         require(total <= MAX_ELEMENTS, "Sale end");
1673         require(_count <= MAX_BY_MINT, "Exceeds number");
1674         require(msg.value >= price(_count), "Value below price");
1675 
1676         for (uint256 i = 0; i < _count; i++) {
1677             _mintAnElement(_to);
1678         }
1679     }
1680 
1681     function _mintAnElement(address _to) private {
1682         uint256 id = _totalSupply();
1683         _tokenIdTracker.increment();
1684         _safeMint(_to, id);
1685         emit CreateMembership(id);
1686     }
1687 
1688     function price(uint256 _count) public pure returns (uint256) {
1689         return PRICE.mul(_count);
1690     }
1691 
1692     function _baseURI() internal view virtual override returns (string memory) {
1693         return baseTokenURI;
1694     }
1695 
1696     function setBaseURI(string memory baseURI) public onlyOwner {
1697         baseTokenURI = baseURI;
1698     }
1699 
1700     function walletOfOwner(address _owner) external view returns (uint256[] memory) {
1701         uint256 tokenCount = balanceOf(_owner);
1702 
1703         uint256[] memory tokenIds = new uint256[](tokenCount);
1704         for (uint256 i = 0; i < tokenCount; i++) {
1705             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1706         }
1707 
1708         return tokenIds;
1709     }
1710 
1711     function pause(bool val) public onlyOwner {
1712         if (val == true) {
1713             _pause();
1714             return;
1715         }
1716         _unpause();
1717     }
1718 
1719     function withdrawAll() public payable onlyOwner {
1720         uint256 balance = address(this).balance;
1721         require(balance > 0);
1722         _withdraw(treasuryAddress, address(this).balance);
1723     }
1724 
1725     function _withdraw(address _address, uint256 _amount) private {
1726         (bool success, ) = _address.call{value: _amount}("");
1727         require(success, "Transfer failed.");
1728     }
1729 
1730     function _beforeTokenTransfer(
1731         address from,
1732         address to,
1733         uint256 tokenId
1734     ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
1735         super._beforeTokenTransfer(from, to, tokenId);
1736     }
1737 
1738     function supportsInterface(bytes4 interfaceId)
1739         public
1740         view
1741         virtual
1742         override(ERC721, ERC721Enumerable)
1743         returns (bool)
1744     {
1745         return super.supportsInterface(interfaceId);
1746     }
1747 }