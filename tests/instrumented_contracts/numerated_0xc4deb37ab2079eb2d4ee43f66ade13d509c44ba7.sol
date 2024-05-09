1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-14
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.7;
8 
9 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.0
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
32 
33 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.0
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
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been whiteed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
110      * The approval is cleared when the token is transferred.
111      *
112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
113      *
114      * Requirements:
115      *
116      * - The caller must own the token or be an approved operator.
117      * - `tokenId` must exist.
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Returns the account approved for `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function getApproved(uint256 tokenId) external view returns (address operator);
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
145      * @dev Returns if the `operator` is whiteed to manage all of the assets of `owner`.
146      *
147      * See {setApprovalForAll}
148      */
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 }
171 
172 
173 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.0
174 
175 /**
176  * @title ERC721 token receiver interface
177  * @dev Interface for any contract that wants to support safeTransfers
178  * from ERC721 asset contracts.
179  */
180 interface IERC721Receiver {
181     /**
182      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
183      * by `operator` from `from`, this function is called.
184      *
185      * It must return its Solidity selector to confirm the token transfer.
186      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
187      *
188      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
189      */
190     function onERC721Received(
191         address operator,
192         address from,
193         uint256 tokenId,
194         bytes calldata data
195     ) external returns (bytes4);
196 }
197 
198 
199 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.0
200 
201 /**
202  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
203  * @dev See https://eips.ethereum.org/EIPS/eip-721
204  */
205 interface IERC721Metadata is IERC721 {
206     /**
207      * @dev Returns the token collection name.
208      */
209     function name() external view returns (string memory);
210 
211     /**
212      * @dev Returns the token collection symbol.
213      */
214     function symbol() external view returns (string memory);
215 
216     /**
217      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
218      */
219     function tokenURI(uint256 tokenId) external view returns (string memory);
220 }
221 
222 
223 // File @openzeppelin/contracts/utils/Address.sol@v4.3.0
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
352         return verifyCallResult(success, returndata, errorMessage);
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
379         return verifyCallResult(success, returndata, errorMessage);
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
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
411      * revert reason using the provided one.
412      *
413      * _Available since v4.3._
414      */
415     function verifyCallResult(
416         bool success,
417         bytes memory returndata,
418         string memory errorMessage
419     ) internal pure returns (bytes memory) {
420         if (success) {
421             return returndata;
422         } else {
423             // Look for revert reason and bubble it up if present
424             if (returndata.length > 0) {
425                 // The easiest way to bubble the revert reason is using memory via assembly
426 
427                 assembly {
428                     let returndata_size := mload(returndata)
429                     revert(add(32, returndata), returndata_size)
430                 }
431             } else {
432                 revert(errorMessage);
433             }
434         }
435     }
436 }
437 
438 
439 // File @openzeppelin/contracts/utils/Context.sol@v4.3.0
440 
441 /**
442  * @dev Provides information about the current execution context, including the
443  * sender of the transaction and its data. While these are generally available
444  * via msg.sender and msg.data, they should not be accessed in such a direct
445  * manner, since when dealing with meta-transactions the account sending and
446  * paying for execution may not be the actual sender (as far as an application
447  * is concerned).
448  *
449  * This contract is only required for intermediate, library-like contracts.
450  */
451 abstract contract Context {
452     function _msgSender() internal view virtual returns (address) {
453         return msg.sender;
454     }
455 
456     function _msgData() internal view virtual returns (bytes calldata) {
457         return msg.data;
458     }
459 }
460 
461 
462 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.0
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
527 
528 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.0
529 
530 /**
531  * @dev Implementation of the {IERC165} interface.
532  *
533  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
534  * for the additional interface id that will be supported. For example:
535  *
536  * ```solidity
537  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
539  * }
540  * ```
541  *
542  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
543  */
544 abstract contract ERC165 is IERC165 {
545     /**
546      * @dev See {IERC165-supportsInterface}.
547      */
548     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549         return interfaceId == type(IERC165).interfaceId;
550     }
551 }
552 
553 
554 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.0
555 
556 /**
557  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
558  * the Metadata extension, but not including the Enumerable extension, which is available separately as
559  * {ERC721Enumerable}.
560  */
561 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
562     using Address for address;
563     using Strings for uint256;
564 
565     // Token name
566     string private _name;
567 
568     // Token symbol
569     string private _symbol;
570 
571     // Mapping from token ID to owner address
572     mapping(uint256 => address) private _owners;
573 
574     // Mapping owner address to token count
575     mapping(address => uint256) private _balances;
576 
577     // Mapping from token ID to approved address
578     mapping(uint256 => address) private _tokenApprovals;
579 
580     // Mapping from owner to operator approvals
581     mapping(address => mapping(address => bool)) private _operatorApprovals;
582 
583     /**
584      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
585      */
586     constructor(string memory name_, string memory symbol_) {
587         _name = name_;
588         _symbol = symbol_;
589     }
590 
591     /**
592      * @dev See {IERC165-supportsInterface}.
593      */
594     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
595         return
596             interfaceId == type(IERC721).interfaceId ||
597             interfaceId == type(IERC721Metadata).interfaceId ||
598             super.supportsInterface(interfaceId);
599     }
600 
601     /**
602      * @dev See {IERC721-balanceOf}.
603      */
604     function balanceOf(address owner) public view virtual override returns (uint256) {
605         require(owner != address(0), "ERC721: balance query for the zero address");
606         return _balances[owner];
607     }
608 
609     /**
610      * @dev See {IERC721-ownerOf}.
611      */
612     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
613         address owner = _owners[tokenId];
614         require(owner != address(0), "ERC721: owner query for nonexistent token");
615         return owner;
616     }
617 
618     /**
619      * @dev See {IERC721Metadata-name}.
620      */
621     function name() public view virtual override returns (string memory) {
622         return _name;
623     }
624 
625     /**
626      * @dev See {IERC721Metadata-symbol}.
627      */
628     function symbol() public view virtual override returns (string memory) {
629         return _symbol;
630     }
631 
632     /**
633      * @dev See {IERC721Metadata-tokenURI}.
634      */
635     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
636         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
637 
638         string memory baseURI = _baseURI();
639         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
640     }
641 
642     /**
643      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
644      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
645      * by default, can be overriden in child contracts.
646      */
647     function _baseURI() internal view virtual returns (string memory) {
648         return "";
649     }
650 
651     /**
652      * @dev See {IERC721-approve}.
653      */
654     function approve(address to, uint256 tokenId) public virtual override {
655         address owner = ERC721.ownerOf(tokenId);
656         require(to != owner, "ERC721: approval to current owner");
657 
658         require(
659             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
660             "ERC721: approve caller is not owner nor approved for all"
661         );
662 
663         _approve(to, tokenId);
664     }
665 
666     /**
667      * @dev See {IERC721-getApproved}.
668      */
669     function getApproved(uint256 tokenId) public view virtual override returns (address) {
670         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
671 
672         return _tokenApprovals[tokenId];
673     }
674 
675     /**
676      * @dev See {IERC721-setApprovalForAll}.
677      */
678     function setApprovalForAll(address operator, bool approved) public virtual override {
679         require(operator != _msgSender(), "ERC721: approve to caller");
680 
681         _operatorApprovals[_msgSender()][operator] = approved;
682         emit ApprovalForAll(_msgSender(), operator, approved);
683     }
684 
685     /**
686      * @dev See {IERC721-isApprovedForAll}.
687      */
688     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
689         return _operatorApprovals[owner][operator];
690     }
691 
692     /**
693      * @dev See {IERC721-transferFrom}.
694      */
695     function transferFrom(
696         address from,
697         address to,
698         uint256 tokenId
699     ) public virtual override {
700         //solhint-disable-next-line max-line-length
701         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
702 
703         _transfer(from, to, tokenId);
704     }
705 
706     /**
707      * @dev See {IERC721-safeTransferFrom}.
708      */
709     function safeTransferFrom(
710         address from,
711         address to,
712         uint256 tokenId
713     ) public virtual override {
714         safeTransferFrom(from, to, tokenId, "");
715     }
716 
717     /**
718      * @dev See {IERC721-safeTransferFrom}.
719      */
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 tokenId,
724         bytes memory _data
725     ) public virtual override {
726         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
727         _safeTransfer(from, to, tokenId, _data);
728     }
729 
730     /**
731      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
732      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
733      *
734      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
735      *
736      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
737      * implement alternative mechanisms to perform token transfer, such as signature-based.
738      *
739      * Requirements:
740      *
741      * - `from` cannot be the zero address.
742      * - `to` cannot be the zero address.
743      * - `tokenId` token must exist and be owned by `from`.
744      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
745      *
746      * Emits a {Transfer} event.
747      */
748     function _safeTransfer(
749         address from,
750         address to,
751         uint256 tokenId,
752         bytes memory _data
753     ) internal virtual {
754         _transfer(from, to, tokenId);
755         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
756     }
757 
758     /**
759      * @dev Returns whether `tokenId` exists.
760      *
761      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
762      *
763      * Tokens start existing when they are minted (`_mint`),
764      * and stop existing when they are burned (`_burn`).
765      */
766     function _exists(uint256 tokenId) internal view virtual returns (bool) {
767         return _owners[tokenId] != address(0);
768     }
769 
770     /**
771      * @dev Returns whether `spender` is whiteed to manage `tokenId`.
772      *
773      * Requirements:
774      *
775      * - `tokenId` must exist.
776      */
777     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
778         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
779         address owner = ERC721.ownerOf(tokenId);
780         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
781     }
782 
783     /**
784      * @dev Safely mints `tokenId` and transfers it to `to`.
785      *
786      * Requirements:
787      *
788      * - `tokenId` must not exist.
789      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
790      *
791      * Emits a {Transfer} event.
792      */
793     function _safeMint(address to, uint256 tokenId) internal virtual {
794         _safeMint(to, tokenId, "");
795     }
796 
797     /**
798      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
799      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
800      */
801     function _safeMint(
802         address to,
803         uint256 tokenId,
804         bytes memory _data
805     ) internal virtual {
806         _mint(to, tokenId);
807         require(
808             _checkOnERC721Received(address(0), to, tokenId, _data),
809             "ERC721: transfer to non ERC721Receiver implementer"
810         );
811     }
812 
813     /**
814      * @dev Mints `tokenId` and transfers it to `to`.
815      *
816      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
817      *
818      * Requirements:
819      *
820      * - `tokenId` must not exist.
821      * - `to` cannot be the zero address.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _mint(address to, uint256 tokenId) internal virtual {
826         require(to != address(0), "ERC721: mint to the zero address");
827         require(!_exists(tokenId), "ERC721: token already minted");
828 
829         _beforeTokenTransfer(address(0), to, tokenId);
830 
831         _balances[to] += 1;
832         _owners[tokenId] = to;
833 
834         emit Transfer(address(0), to, tokenId);
835     }
836 
837     /**
838      * @dev Destroys `tokenId`.
839      * The approval is cleared when the token is burned.
840      *
841      * Requirements:
842      *
843      * - `tokenId` must exist.
844      *
845      * Emits a {Transfer} event.
846      */
847     function _burn(uint256 tokenId) internal virtual {
848         address owner = ERC721.ownerOf(tokenId);
849 
850         _beforeTokenTransfer(owner, address(0), tokenId);
851 
852         // Clear approvals
853         _approve(address(0), tokenId);
854 
855         _balances[owner] -= 1;
856         delete _owners[tokenId];
857 
858         emit Transfer(owner, address(0), tokenId);
859     }
860 
861     /**
862      * @dev Transfers `tokenId` from `from` to `to`.
863      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
864      *
865      * Requirements:
866      *
867      * - `to` cannot be the zero address.
868      * - `tokenId` token must be owned by `from`.
869      *
870      * Emits a {Transfer} event.
871      */
872     function _transfer(
873         address from,
874         address to,
875         uint256 tokenId
876     ) internal virtual {
877         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
878         require(to != address(0), "ERC721: transfer to the zero address");
879 
880         _beforeTokenTransfer(from, to, tokenId);
881 
882         // Clear approvals from the previous owner
883         _approve(address(0), tokenId);
884 
885         _balances[from] -= 1;
886         _balances[to] += 1;
887         _owners[tokenId] = to;
888 
889         emit Transfer(from, to, tokenId);
890     }
891 
892     /**
893      * @dev Approve `to` to operate on `tokenId`
894      *
895      * Emits a {Approval} event.
896      */
897     function _approve(address to, uint256 tokenId) internal virtual {
898         _tokenApprovals[tokenId] = to;
899         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
900     }
901 
902     /**
903      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
904      * The call is not executed if the target address is not a contract.
905      *
906      * @param from address representing the previous owner of the given token ID
907      * @param to target address that will receive the tokens
908      * @param tokenId uint256 ID of the token to be transferred
909      * @param _data bytes optional data to send along with the call
910      * @return bool whether the call correctly returned the expected magic value
911      */
912     function _checkOnERC721Received(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) private returns (bool) {
918         if (to.isContract()) {
919             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
920                 return retval == IERC721Receiver.onERC721Received.selector;
921             } catch (bytes memory reason) {
922                 if (reason.length == 0) {
923                     revert("ERC721: transfer to non ERC721Receiver implementer");
924                 } else {
925                     assembly {
926                         revert(add(32, reason), mload(reason))
927                     }
928                 }
929             }
930         } else {
931             return true;
932         }
933     }
934 
935     /**
936      * @dev Hook that is called before any token transfer. This includes minting
937      * and burning.
938      *
939      * Calling conditions:
940      *
941      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
942      * transferred to `to`.
943      * - When `from` is zero, `tokenId` will be minted for `to`.
944      * - When `to` is zero, ``from``'s `tokenId` will be burned.
945      * - `from` and `to` are never both zero.
946      *
947      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
948      */
949     function _beforeTokenTransfer(
950         address from,
951         address to,
952         uint256 tokenId
953     ) internal virtual {}
954 }
955 
956 
957 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.0
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
983 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.0
984 
985 
986 /**
987  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
988  * enumerability of all the token ids in the contract as well as all token ids owned by each
989  * account.
990  */
991 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
992     // Mapping from owner to list of owned token IDs
993     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
994 
995     // Mapping from token ID to index of the owner tokens list
996     mapping(uint256 => uint256) private _ownedTokensIndex;
997 
998     // Array with all token ids, used for enumeration
999     uint256[] private _allTokens;
1000 
1001     // Mapping from token id to position in the allTokens array
1002     mapping(uint256 => uint256) private _allTokensIndex;
1003 
1004     /**
1005      * @dev See {IERC165-supportsInterface}.
1006      */
1007     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1008         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1013      */
1014     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1015         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1016         return _ownedTokens[owner][index];
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Enumerable-totalSupply}.
1021      */
1022     function totalSupply() public view virtual override returns (uint256) {
1023         return _allTokens.length;
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Enumerable-tokenByIndex}.
1028      */
1029     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1030         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1031         return _allTokens[index];
1032     }
1033 
1034     /**
1035      * @dev Hook that is called before any token transfer. This includes minting
1036      * and burning.
1037      *
1038      * Calling conditions:
1039      *
1040      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1041      * transferred to `to`.
1042      * - When `from` is zero, `tokenId` will be minted for `to`.
1043      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1044      * - `from` cannot be the zero address.
1045      * - `to` cannot be the zero address.
1046      *
1047      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1048      */
1049     function _beforeTokenTransfer(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) internal virtual override {
1054         super._beforeTokenTransfer(from, to, tokenId);
1055 
1056         if (from == address(0)) {
1057             _addTokenToAllTokensEnumeration(tokenId);
1058         } else if (from != to) {
1059             _removeTokenFromOwnerEnumeration(from, tokenId);
1060         }
1061         if (to == address(0)) {
1062             _removeTokenFromAllTokensEnumeration(tokenId);
1063         } else if (to != from) {
1064             _addTokenToOwnerEnumeration(to, tokenId);
1065         }
1066     }
1067 
1068     /**
1069      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1070      * @param to address representing the new owner of the given token ID
1071      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1072      */
1073     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1074         uint256 length = ERC721.balanceOf(to);
1075         _ownedTokens[to][length] = tokenId;
1076         _ownedTokensIndex[tokenId] = length;
1077     }
1078 
1079     /**
1080      * @dev Private function to add a token to this extension's token tracking data structures.
1081      * @param tokenId uint256 ID of the token to be added to the tokens list
1082      */
1083     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1084         _allTokensIndex[tokenId] = _allTokens.length;
1085         _allTokens.push(tokenId);
1086     }
1087 
1088     /**
1089      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1090      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this whites for
1091      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1092      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1093      * @param from address representing the previous owner of the given token ID
1094      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1095      */
1096     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1097         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1098         // then delete the last slot (swap and pop).
1099 
1100         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1101         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1102 
1103         // When the token to delete is the last token, the swap operation is unnecessary
1104         if (tokenIndex != lastTokenIndex) {
1105             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1106 
1107             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1108             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1109         }
1110 
1111         // This also deletes the contents at the last position of the array
1112         delete _ownedTokensIndex[tokenId];
1113         delete _ownedTokens[from][lastTokenIndex];
1114     }
1115 
1116     /**
1117      * @dev Private function to remove a token from this extension's token tracking data structures.
1118      * This has O(1) time complexity, but alters the order of the _allTokens array.
1119      * @param tokenId uint256 ID of the token to be removed from the tokens list
1120      */
1121     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1122         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1123         // then delete the last slot (swap and pop).
1124 
1125         uint256 lastTokenIndex = _allTokens.length - 1;
1126         uint256 tokenIndex = _allTokensIndex[tokenId];
1127 
1128         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1129         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1130         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1131         uint256 lastTokenId = _allTokens[lastTokenIndex];
1132 
1133         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1134         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1135 
1136         // This also deletes the contents at the last position of the array
1137         delete _allTokensIndex[tokenId];
1138         _allTokens.pop();
1139     }
1140 }
1141 
1142 
1143 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.0
1144 
1145 
1146 // CAUTION
1147 // This version of SafeMath should only be used with Solidity 0.8 or later,
1148 // because it relies on the compiler's built in overflow checks.
1149 
1150 /**
1151  * @dev Wrappers over Solidity's arithmetic operations.
1152  *
1153  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1154  * now has built in overflow checking.
1155  */
1156 library SafeMath {
1157     /**
1158      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1159      *
1160      * _Available since v3.4._
1161      */
1162     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1163         unchecked {
1164             uint256 c = a + b;
1165             if (c < a) return (false, 0);
1166             return (true, c);
1167         }
1168     }
1169 
1170     /**
1171      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1172      *
1173      * _Available since v3.4._
1174      */
1175     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1176         unchecked {
1177             if (b > a) return (false, 0);
1178             return (true, a - b);
1179         }
1180     }
1181 
1182     /**
1183      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1184      *
1185      * _Available since v3.4._
1186      */
1187     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1188         unchecked {
1189             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1190             // benefit is lost if 'b' is also tested.
1191             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1192             if (a == 0) return (true, 0);
1193             uint256 c = a * b;
1194             if (c / a != b) return (false, 0);
1195             return (true, c);
1196         }
1197     }
1198 
1199     /**
1200      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1201      *
1202      * _Available since v3.4._
1203      */
1204     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1205         unchecked {
1206             if (b == 0) return (false, 0);
1207             return (true, a / b);
1208         }
1209     }
1210 
1211     /**
1212      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1213      *
1214      * _Available since v3.4._
1215      */
1216     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1217         unchecked {
1218             if (b == 0) return (false, 0);
1219             return (true, a % b);
1220         }
1221     }
1222 
1223     /**
1224      * @dev Returns the addition of two unsigned integers, reverting on
1225      * overflow.
1226      *
1227      * Counterpart to Solidity's `+` operator.
1228      *
1229      * Requirements:
1230      *
1231      * - Addition cannot overflow.
1232      */
1233     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1234         return a + b;
1235     }
1236 
1237     /**
1238      * @dev Returns the subtraction of two unsigned integers, reverting on
1239      * overflow (when the result is negative).
1240      *
1241      * Counterpart to Solidity's `-` operator.
1242      *
1243      * Requirements:
1244      *
1245      * - Subtraction cannot overflow.
1246      */
1247     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1248         return a - b;
1249     }
1250 
1251     /**
1252      * @dev Returns the multiplication of two unsigned integers, reverting on
1253      * overflow.
1254      *
1255      * Counterpart to Solidity's `*` operator.
1256      *
1257      * Requirements:
1258      *
1259      * - Multiplication cannot overflow.
1260      */
1261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1262         return a * b;
1263     }
1264 
1265     /**
1266      * @dev Returns the integer division of two unsigned integers, reverting on
1267      * division by zero. The result is rounded towards zero.
1268      *
1269      * Counterpart to Solidity's `/` operator.
1270      *
1271      * Requirements:
1272      *
1273      * - The divisor cannot be zero.
1274      */
1275     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1276         return a / b;
1277     }
1278 
1279     /**
1280      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1281      * reverting when dividing by zero.
1282      *
1283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1284      * opcode (which leaves remaining gas untouched) while Solidity uses an
1285      * invalid opcode to revert (consuming all remaining gas).
1286      *
1287      * Requirements:
1288      *
1289      * - The divisor cannot be zero.
1290      */
1291     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1292         return a % b;
1293     }
1294 
1295     /**
1296      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1297      * overflow (when the result is negative).
1298      *
1299      * CAUTION: This function is deprecated because it requires allocating memory for the error
1300      * message unnecessarily. For custom revert reasons use {trySub}.
1301      *
1302      * Counterpart to Solidity's `-` operator.
1303      *
1304      * Requirements:
1305      *
1306      * - Subtraction cannot overflow.
1307      */
1308     function sub(
1309         uint256 a,
1310         uint256 b,
1311         string memory errorMessage
1312     ) internal pure returns (uint256) {
1313         unchecked {
1314             require(b <= a, errorMessage);
1315             return a - b;
1316         }
1317     }
1318 
1319     /**
1320      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1321      * division by zero. The result is rounded towards zero.
1322      *
1323      * Counterpart to Solidity's `/` operator. Note: this function uses a
1324      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1325      * uses an invalid opcode to revert (consuming all remaining gas).
1326      *
1327      * Requirements:
1328      *
1329      * - The divisor cannot be zero.
1330      */
1331     function div(
1332         uint256 a,
1333         uint256 b,
1334         string memory errorMessage
1335     ) internal pure returns (uint256) {
1336         unchecked {
1337             require(b > 0, errorMessage);
1338             return a / b;
1339         }
1340     }
1341 
1342     /**
1343      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1344      * reverting with custom message when dividing by zero.
1345      *
1346      * CAUTION: This function is deprecated because it requires allocating memory for the error
1347      * message unnecessarily. For custom revert reasons use {tryMod}.
1348      *
1349      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1350      * opcode (which leaves remaining gas untouched) while Solidity uses an
1351      * invalid opcode to revert (consuming all remaining gas).
1352      *
1353      * Requirements:
1354      *
1355      * - The divisor cannot be zero.
1356      */
1357     function mod(
1358         uint256 a,
1359         uint256 b,
1360         string memory errorMessage
1361     ) internal pure returns (uint256) {
1362         unchecked {
1363             require(b > 0, errorMessage);
1364             return a % b;
1365         }
1366     }
1367 }
1368 
1369 
1370 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.0
1371 
1372 /**
1373  * @dev Contract module which provides a basic access control mechanism, where
1374  * there is an account (an owner) that can be granted exclusive access to
1375  * specific functions.
1376  *
1377  * By default, the owner account will be the one that deploys the contract. This
1378  * can later be changed with {transferOwnership}.
1379  *
1380  * This module is used through inheritance. It will make available the modifier
1381  * `onlyOwner`, which can be applied to your functions to restrict their use to
1382  * the owner.
1383  */
1384 abstract contract Ownable is Context {
1385     address private _owner;
1386 
1387     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1388 
1389     /**
1390      * @dev Initializes the contract setting the deployer as the initial owner.
1391      */
1392     constructor() {
1393         _setOwner(_msgSender());
1394     }
1395 
1396     /**
1397      * @dev Returns the address of the current owner.
1398      */
1399     function owner() public view virtual returns (address) {
1400         return _owner;
1401     }
1402 
1403     /**
1404      * @dev Throws if called by any account other than the owner.
1405      */
1406     modifier onlyOwner() {
1407         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1408         _;
1409     }
1410 
1411     /**
1412      * @dev Leaves the contract without owner. It will not be possible to call
1413      * `onlyOwner` functions anymore. Can only be called by the current owner.
1414      *
1415      * NOTE: Renouncing ownership will leave the contract without an owner,
1416      * thereby removing any functionality that is only available to the owner.
1417      */
1418     function renounceOwnership() public virtual onlyOwner {
1419         _setOwner(address(0));
1420     }
1421 
1422     /**
1423      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1424      * Can only be called by the current owner.
1425      */
1426     function transferOwnership(address newOwner) public virtual onlyOwner {
1427         require(newOwner != address(0), "Ownable: new owner is the zero address");
1428         _setOwner(newOwner);
1429     }
1430 
1431     function _setOwner(address newOwner) private {
1432         address oldOwner = _owner;
1433         _owner = newOwner;
1434         emit OwnershipTransferred(oldOwner, newOwner);
1435     }
1436 }
1437 
1438 
1439 contract ExoGensprojectReal is ERC721("ExoGens Official Collection", "ExoGens"), ERC721Enumerable, Ownable {
1440     using SafeMath for uint256;
1441     using Strings for uint256;
1442 
1443     string private baseURI;
1444     string private blindURI;
1445     string private jsonparam = '.json';
1446     uint256 public constant BUY_LIMIT_PER_TX = 3;
1447     uint256 public constant MAX_NFT_PUBLIC = 9900;
1448     uint256 private constant MAX_NFT = 10001;
1449     uint256 public Price = 110000000000000000;  // 0.11 ETH
1450     bool public reveal;
1451     bool public isActive;
1452     bool public isPresaleActive;
1453     bool private freeMintActive;
1454     mapping(address => uint256) public whiteListClaimed;
1455     mapping(address => bool) private giveawayMintClaimed;
1456     uint256 public giveawayCount;
1457 
1458 
1459     /*
1460      * Function to reveal all ExoGens
1461     */
1462     function revealNow() 
1463         external 
1464         onlyOwner 
1465     {
1466         reveal = true;
1467     }
1468     
1469     
1470     /*
1471      * Function setIsActive to activate/desactivate the smart contract
1472     */
1473     function setIsActive(
1474         bool _isActive
1475     ) 
1476         external 
1477         onlyOwner 
1478     {
1479         isActive = _isActive;
1480     }
1481     
1482     /*
1483      * Function setPresaleActive to activate/desactivate the whitelist/raffle presale  
1484     */
1485     function setPresaleActive(
1486         bool _isActive
1487     ) 
1488         external 
1489         onlyOwner 
1490     {
1491         isPresaleActive = _isActive;
1492     }
1493 
1494     /*
1495      * Function setFreeMintActive to activate/desactivate the free mint capability  
1496     */
1497     function setFreeMintActive(
1498         bool _isActive
1499     ) 
1500         external 
1501         onlyOwner 
1502     {
1503         freeMintActive = _isActive;
1504     }
1505     
1506     /*
1507      * Function to set Base and Blind URI 
1508     */
1509     function setURIs(
1510         string memory _blindURI, 
1511         string memory _URI
1512     ) 
1513         external 
1514         onlyOwner 
1515     {
1516         blindURI = _blindURI;
1517         baseURI = _URI;
1518     }
1519     
1520     /*
1521      * Function to withdraw collected amount during minting by the owner
1522     */
1523     function withdraw(
1524     ) 
1525         public 
1526         onlyOwner 
1527     {
1528         uint balance = address(this).balance;
1529         require(balance > 0, "Balance should be more then zero");
1530         payable(address(0x75bbAbD451E7BadcF3569F4Df8BA0bE52b7a911F)).transfer(balance);
1531     }
1532     
1533 
1534     /*
1535      * Function to mint new NFTs during the presale
1536      * It is payable. Amount is calculated as per (Price.mul(_numOfTokens))
1537     */ 
1538     function mintNFT(
1539         uint256 _numOfTokens
1540     ) 
1541         public 
1542         payable
1543     {
1544         require(isActive, 'Sale is not active');
1545         require(isPresaleActive, 'Whitelist is not active');
1546         require(totalSupply() < MAX_NFT_PUBLIC, 'All public tokens have been minted');
1547         require(_numOfTokens <= BUY_LIMIT_PER_TX, 'Cannot purchase this many tokens');
1548         require(totalSupply().add(_numOfTokens).sub(giveawayCount) <= MAX_NFT_PUBLIC, 'Purchase would exceed max public supply of NFTs');
1549         require(whiteListClaimed[msg.sender].add(_numOfTokens) <= BUY_LIMIT_PER_TX, 'Purchase exceeds max whiteed');
1550         require(Price.mul(_numOfTokens) == msg.value, "Ether value sent is not correct");
1551         for (uint256 i = 1; i <= _numOfTokens; i++) {
1552                 whiteListClaimed[msg.sender] += 1;
1553                 _safeMint(msg.sender, totalSupply().sub(giveawayCount));
1554         }
1555     }
1556     
1557     /*
1558      * Function to mint NFTs for giveaway and partnerships
1559     */
1560     function mintByOwner(
1561         address _to, 
1562         uint256 _tokenId
1563     )
1564         public 
1565         onlyOwner
1566     {
1567         require(_tokenId < MAX_NFT, "Tokens number to mint cannot exceed number of MAX tokens");
1568         _safeMint(_to, _tokenId);
1569     }
1570     
1571     /*
1572      * Function to mint all NFTs for giveaway and partnerships
1573     */
1574     function mintMultipleByOwner(
1575         address[] memory _to, 
1576         uint256[] memory _tokenId
1577     )
1578         public
1579         onlyOwner
1580     {
1581         require(_to.length == _tokenId.length, "Should have same length");
1582         for(uint256 i = 0; i < _to.length; i++){
1583             require(_tokenId[i] >= MAX_NFT_PUBLIC, "Tokens number to mint must exceed number of public tokens");
1584             require(_tokenId[i] < MAX_NFT, "Tokens number to mint cannot exceed number of MAX tokens");
1585             _safeMint(_to[i], _tokenId[i]);
1586             giveawayCount = giveawayCount.add(1);
1587         }
1588     }
1589 
1590     /*
1591      * Function to get token URI of given token ID
1592      * URI will be blank untill totalSupply reaches MAX_NFT_PUBLIC
1593     */
1594     function tokenURI(
1595         uint256 _tokenId
1596     )
1597         public 
1598         view 
1599         virtual 
1600         override 
1601         returns (string memory) 
1602     {
1603         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1604         if (!reveal) {
1605             return string(abi.encodePacked(blindURI, _tokenId.toString(), jsonparam));
1606         } else {
1607             return string(abi.encodePacked(baseURI, _tokenId.toString(), jsonparam));
1608         }
1609     }
1610 
1611 
1612     // Standard functions to be overridden in ERC721Enumerable
1613     function supportsInterface(
1614         bytes4 _interfaceId
1615     ) 
1616         public
1617         view 
1618         override (ERC721, ERC721Enumerable) 
1619         returns (bool) 
1620     {
1621         return super.supportsInterface(_interfaceId);
1622     }
1623 
1624    
1625     function _beforeTokenTransfer(
1626         address _from, 
1627         address _to, 
1628         uint256 _tokenId
1629     ) 
1630         internal 
1631         override(ERC721, ERC721Enumerable) 
1632     {
1633         super._beforeTokenTransfer(_from, _to, _tokenId);
1634     }
1635 
1636 }