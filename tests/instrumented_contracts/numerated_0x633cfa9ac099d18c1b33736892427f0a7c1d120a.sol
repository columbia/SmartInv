1 pragma solidity ^0.8.0;
2 
3 /**
4 * The J. Pierce & Friends contract was deployed by Ownerfy Inc. of Ownerfy.com
5 * https://ownerfy.com/jpandfriends
6 * Visit Ownerfy.com for exclusive NFT drops or inquiries for your project.
7 *
8 * This contract is not a proxy.
9 * This contract is not pausable.
10 * This contract is not lockable.
11 * This contract cannot be rug pulled.
12 * The URIs are not changeable after mint.
13 * This contract uses IPFS
14 * This contract puts SHA256 media hash into the Update event for permanent on-chain documentation
15 * The NFT Owners and only the NFT Owners have complete control over their NFTs
16 */
17 
18 // SPDX-License-Identifier: UNLICENSED
19 
20 
21 /**
22  * @dev Interface of the ERC165 standard, as defined in the
23  * https://eips.ethereum.org/EIPS/eip-165[EIP].
24  *
25  * Implementers can declare support of contract interfaces, which can then be
26  * queried by others ({ERC165Checker}).
27  *
28  * For an implementation, see {ERC165}.
29  */
30 interface IERC165 {
31     /**
32      * @dev Returns true if this contract implements the interface defined by
33      * `interfaceId`. See the corresponding
34      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
35      * to learn more about how these ids are created.
36      *
37      * This function call must use less than 30 000 gas.
38      */
39     function supportsInterface(bytes4 interfaceId) external view returns (bool);
40 }
41 
42 /**
43  * @dev Required interface of an ERC721 compliant contract.
44  */
45 interface IERC721 is IERC165 {
46     /**
47      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
48      */
49     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
53      */
54     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
55 
56     /**
57      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
58      */
59     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
60 
61     /**
62      * @dev Returns the number of tokens in ``owner``'s account.
63      */
64     function balanceOf(address owner) external view returns (uint256 balance);
65 
66     /**
67      * @dev Returns the owner of the `tokenId` token.
68      *
69      * Requirements:
70      *
71      * - `tokenId` must exist.
72      */
73     function ownerOf(uint256 tokenId) external view returns (address owner);
74 
75     /**
76      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
77      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
78      *
79      * Requirements:
80      *
81      * - `from` cannot be the zero address.
82      * - `to` cannot be the zero address.
83      * - `tokenId` token must exist and be owned by `from`.
84      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
85      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
86      *
87      * Emits a {Transfer} event.
88      */
89     function safeTransferFrom(
90         address from,
91         address to,
92         uint256 tokenId
93     ) external;
94 
95     /**
96      * @dev Transfers `tokenId` token from `from` to `to`.
97      *
98      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
99      *
100      * Requirements:
101      *
102      * - `from` cannot be the zero address.
103      * - `to` cannot be the zero address.
104      * - `tokenId` token must be owned by `from`.
105      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(
110         address from,
111         address to,
112         uint256 tokenId
113     ) external;
114 
115     /**
116      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
117      * The approval is cleared when the token is transferred.
118      *
119      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
120      *
121      * Requirements:
122      *
123      * - The caller must own the token or be an approved operator.
124      * - `tokenId` must exist.
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address to, uint256 tokenId) external;
129 
130     /**
131      * @dev Returns the account approved for `tokenId` token.
132      *
133      * Requirements:
134      *
135      * - `tokenId` must exist.
136      */
137     function getApproved(uint256 tokenId) external view returns (address operator);
138 
139     /**
140      * @dev Approve or remove `operator` as an operator for the caller.
141      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
142      *
143      * Requirements:
144      *
145      * - The `operator` cannot be the caller.
146      *
147      * Emits an {ApprovalForAll} event.
148      */
149     function setApprovalForAll(address operator, bool _approved) external;
150 
151     /**
152      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
153      *
154      * See {setApprovalForAll}
155      */
156     function isApprovedForAll(address owner, address operator) external view returns (bool);
157 
158     /**
159      * @dev Safely transfers `tokenId` token from `from` to `to`.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must exist and be owned by `from`.
166      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
167      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168      *
169      * Emits a {Transfer} event.
170      */
171     function safeTransferFrom(
172         address from,
173         address to,
174         uint256 tokenId,
175         bytes calldata data
176     ) external;
177 }
178 
179 
180 
181 /**
182  * @title ERC721 token receiver interface
183  * @dev Interface for any contract that wants to support safeTransfers
184  * from ERC721 asset contracts.
185  */
186 interface IERC721Receiver {
187     /**
188      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
189      * by `operator` from `from`, this function is called.
190      *
191      * It must return its Solidity selector to confirm the token transfer.
192      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
193      *
194      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
195      */
196     function onERC721Received(
197         address operator,
198         address from,
199         uint256 tokenId,
200         bytes calldata data
201     ) external returns (bytes4);
202 }
203 
204 
205 
206 /**
207  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
208  * @dev See https://eips.ethereum.org/EIPS/eip-721
209  */
210 interface IERC721Metadata is IERC721 {
211     /**
212      * @dev Returns the token collection name.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the token collection symbol.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
223      */
224     function tokenURI(uint256 tokenId) external view returns (string memory);
225 }
226 
227 
228 
229 /**
230  * @dev Collection of functions related to the address type
231  */
232 library Address {
233     /**
234      * @dev Returns true if `account` is a contract.
235      *
236      * [IMPORTANT]
237      * ====
238      * It is unsafe to assume that an address for which this function returns
239      * false is an externally-owned account (EOA) and not a contract.
240      *
241      * Among others, `isContract` will return false for the following
242      * types of addresses:
243      *
244      *  - an externally-owned account
245      *  - a contract in construction
246      *  - an address where a contract will be created
247      *  - an address where a contract lived, but was destroyed
248      * ====
249      */
250     function isContract(address account) internal view returns (bool) {
251         // This method relies on extcodesize, which returns 0 for contracts in
252         // construction, since the code is only stored at the end of the
253         // constructor execution.
254 
255         uint256 size;
256         assembly {
257             size := extcodesize(account)
258         }
259         return size > 0;
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         (bool success, ) = recipient.call{value: amount}("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain `call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionCall(target, data, "Address: low-level call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
309      * `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         require(isContract(target), "Address: call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.call{value: value}(data);
356         return _verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
366         return functionStaticCall(target, data, "Address: low-level static call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal view returns (bytes memory) {
380         require(isContract(target), "Address: static call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.staticcall(data);
383         return _verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(isContract(target), "Address: delegate call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return _verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     function _verifyCallResult(
414         bool success,
415         bytes memory returndata,
416         string memory errorMessage
417     ) private pure returns (bytes memory) {
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
436 
437 
438 /*
439  * @dev Provides information about the current execution context, including the
440  * sender of the transaction and its data. While these are generally available
441  * via msg.sender and msg.data, they should not be accessed in such a direct
442  * manner, since when dealing with meta-transactions the account sending and
443  * paying for execution may not be the actual sender (as far as an application
444  * is concerned).
445  *
446  * This contract is only required for intermediate, library-like contracts.
447  */
448 abstract contract Context {
449     function _msgSender() internal view virtual returns (address) {
450         return msg.sender;
451     }
452 
453     function _msgData() internal view virtual returns (bytes calldata) {
454         return msg.data;
455     }
456 }
457 
458 
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
523 
524 
525 /**
526  * @dev Implementation of the {IERC165} interface.
527  *
528  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
529  * for the additional interface id that will be supported. For example:
530  *
531  * ```solidity
532  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
534  * }
535  * ```
536  *
537  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
538  */
539 abstract contract ERC165 is IERC165 {
540     /**
541      * @dev See {IERC165-supportsInterface}.
542      */
543     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544         return interfaceId == type(IERC165).interfaceId;
545     }
546 }
547 
548 /**
549  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
550  * the Metadata extension, but not including the Enumerable extension, which is available separately as
551  * {ERC721Enumerable}.
552  */
553 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
554     using Address for address;
555     using Strings for uint256;
556 
557     // Token name
558     string private _name;
559 
560     // Token symbol
561     string private _symbol;
562 
563     // Mapping from token ID to owner address
564     mapping(uint256 => address) private _owners;
565 
566     // Mapping owner address to token count
567     mapping(address => uint256) private _balances;
568 
569     // Mapping from token ID to approved address
570     mapping(uint256 => address) private _tokenApprovals;
571 
572     // Mapping from owner to operator approvals
573     mapping(address => mapping(address => bool)) private _operatorApprovals;
574 
575     /**
576      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
577      */
578     constructor(string memory name_, string memory symbol_) {
579         _name = name_;
580         _symbol = symbol_;
581     }
582 
583     /**
584      * @dev See {IERC165-supportsInterface}.
585      */
586     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
587         return
588             interfaceId == type(IERC721).interfaceId ||
589             interfaceId == type(IERC721Metadata).interfaceId ||
590             super.supportsInterface(interfaceId);
591     }
592 
593     /**
594      * @dev See {IERC721-balanceOf}.
595      */
596     function balanceOf(address owner) public view virtual override returns (uint256) {
597         require(owner != address(0), "ERC721: balance query for the zero address");
598         return _balances[owner];
599     }
600 
601     /**
602      * @dev See {IERC721-ownerOf}.
603      */
604     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
605         address owner = _owners[tokenId];
606         require(owner != address(0), "ERC721: owner query for nonexistent token");
607         return owner;
608     }
609 
610     /**
611      * @dev See {IERC721Metadata-name}.
612      */
613     function name() public view virtual override returns (string memory) {
614         return _name;
615     }
616 
617     /**
618      * @dev See {IERC721Metadata-symbol}.
619      */
620     function symbol() public view virtual override returns (string memory) {
621         return _symbol;
622     }
623 
624     /**
625      * @dev See {IERC721Metadata-tokenURI}.
626      */
627     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
628         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
629 
630         string memory baseURI = _baseURI();
631         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
632     }
633 
634     /**
635      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
636      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
637      * by default, can be overriden in child contracts.
638      */
639     function _baseURI() internal view virtual returns (string memory) {
640         return "";
641     }
642 
643     /**
644      * @dev See {IERC721-approve}.
645      */
646     function approve(address to, uint256 tokenId) public virtual override {
647         address owner = ERC721.ownerOf(tokenId);
648         require(to != owner, "ERC721: approval to current owner");
649 
650         require(
651             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
652             "ERC721: approve caller is not owner nor approved for all"
653         );
654 
655         _approve(to, tokenId);
656     }
657 
658     /**
659      * @dev See {IERC721-getApproved}.
660      */
661     function getApproved(uint256 tokenId) public view virtual override returns (address) {
662         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
663 
664         return _tokenApprovals[tokenId];
665     }
666 
667     /**
668      * @dev See {IERC721-setApprovalForAll}.
669      */
670     function setApprovalForAll(address operator, bool approved) public virtual override {
671         require(operator != _msgSender(), "ERC721: approve to caller");
672 
673         _operatorApprovals[_msgSender()][operator] = approved;
674         emit ApprovalForAll(_msgSender(), operator, approved);
675     }
676 
677     /**
678      * @dev See {IERC721-isApprovedForAll}.
679      */
680     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
681         return _operatorApprovals[owner][operator];
682     }
683 
684     /**
685      * @dev See {IERC721-transferFrom}.
686      */
687     function transferFrom(
688         address from,
689         address to,
690         uint256 tokenId
691     ) public virtual override {
692         //solhint-disable-next-line max-line-length
693         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
694 
695         _transfer(from, to, tokenId);
696     }
697 
698     /**
699      * @dev See {IERC721-safeTransferFrom}.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId
705     ) public virtual override {
706         safeTransferFrom(from, to, tokenId, "");
707     }
708 
709     /**
710      * @dev See {IERC721-safeTransferFrom}.
711      */
712     function safeTransferFrom(
713         address from,
714         address to,
715         uint256 tokenId,
716         bytes memory _data
717     ) public virtual override {
718         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
719         _safeTransfer(from, to, tokenId, _data);
720     }
721 
722     /**
723      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
724      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
725      *
726      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
727      *
728      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
729      * implement alternative mechanisms to perform token transfer, such as signature-based.
730      *
731      * Requirements:
732      *
733      * - `from` cannot be the zero address.
734      * - `to` cannot be the zero address.
735      * - `tokenId` token must exist and be owned by `from`.
736      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
737      *
738      * Emits a {Transfer} event.
739      */
740     function _safeTransfer(
741         address from,
742         address to,
743         uint256 tokenId,
744         bytes memory _data
745     ) internal virtual {
746         _transfer(from, to, tokenId);
747         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
748     }
749 
750     /**
751      * @dev Returns whether `tokenId` exists.
752      *
753      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
754      *
755      * Tokens start existing when they are minted (`_mint`),
756      * and stop existing when they are burned (`_burn`).
757      */
758     function _exists(uint256 tokenId) internal view virtual returns (bool) {
759         return _owners[tokenId] != address(0);
760     }
761 
762     /**
763      * @dev Returns whether `spender` is allowed to manage `tokenId`.
764      *
765      * Requirements:
766      *
767      * - `tokenId` must exist.
768      */
769     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
770         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
771         address owner = ERC721.ownerOf(tokenId);
772         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
773     }
774 
775     /**
776      * @dev Safely mints `tokenId` and transfers it to `to`.
777      *
778      * Requirements:
779      *
780      * - `tokenId` must not exist.
781      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _safeMint(address to, uint256 tokenId) internal virtual {
786         _safeMint(to, tokenId, "");
787     }
788 
789     /**
790      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
791      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
792      */
793     function _safeMint(
794         address to,
795         uint256 tokenId,
796         bytes memory _data
797     ) internal virtual {
798         _mint(to, tokenId);
799         require(
800             _checkOnERC721Received(address(0), to, tokenId, _data),
801             "ERC721: transfer to non ERC721Receiver implementer"
802         );
803     }
804 
805     /**
806      * @dev Mints `tokenId` and transfers it to `to`.
807      *
808      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
809      *
810      * Requirements:
811      *
812      * - `tokenId` must not exist.
813      * - `to` cannot be the zero address.
814      *
815      * Emits a {Transfer} event.
816      */
817     function _mint(address to, uint256 tokenId) internal virtual {
818         require(to != address(0), "ERC721: mint to the zero address");
819         require(!_exists(tokenId), "ERC721: token already minted");
820 
821         _beforeTokenTransfer(address(0), to, tokenId);
822 
823         _balances[to] += 1;
824         _owners[tokenId] = to;
825 
826         emit Transfer(address(0), to, tokenId);
827     }
828 
829     /**
830      * @dev Destroys `tokenId`.
831      * The approval is cleared when the token is burned.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must exist.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _burn(uint256 tokenId) internal virtual {
840         address owner = ERC721.ownerOf(tokenId);
841 
842         _beforeTokenTransfer(owner, address(0), tokenId);
843 
844         // Clear approvals
845         _approve(address(0), tokenId);
846 
847         _balances[owner] -= 1;
848         delete _owners[tokenId];
849 
850         emit Transfer(owner, address(0), tokenId);
851     }
852 
853     /**
854      * @dev Transfers `tokenId` from `from` to `to`.
855      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
856      *
857      * Requirements:
858      *
859      * - `to` cannot be the zero address.
860      * - `tokenId` token must be owned by `from`.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _transfer(
865         address from,
866         address to,
867         uint256 tokenId
868     ) internal virtual {
869         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
870         require(to != address(0), "ERC721: transfer to the zero address");
871 
872         _beforeTokenTransfer(from, to, tokenId);
873 
874         // Clear approvals from the previous owner
875         _approve(address(0), tokenId);
876 
877         _balances[from] -= 1;
878         _balances[to] += 1;
879         _owners[tokenId] = to;
880 
881         emit Transfer(from, to, tokenId);
882     }
883 
884     /**
885      * @dev Approve `to` to operate on `tokenId`
886      *
887      * Emits a {Approval} event.
888      */
889     function _approve(address to, uint256 tokenId) internal virtual {
890         _tokenApprovals[tokenId] = to;
891         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
892     }
893 
894     /**
895      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
896      * The call is not executed if the target address is not a contract.
897      *
898      * @param from address representing the previous owner of the given token ID
899      * @param to target address that will receive the tokens
900      * @param tokenId uint256 ID of the token to be transferred
901      * @param _data bytes optional data to send along with the call
902      * @return bool whether the call correctly returned the expected magic value
903      */
904     function _checkOnERC721Received(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes memory _data
909     ) private returns (bool) {
910         if (to.isContract()) {
911             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
912                 return retval == IERC721Receiver(to).onERC721Received.selector;
913             } catch (bytes memory reason) {
914                 if (reason.length == 0) {
915                     revert("ERC721: transfer to non ERC721Receiver implementer");
916                 } else {
917                     assembly {
918                         revert(add(32, reason), mload(reason))
919                     }
920                 }
921             }
922         } else {
923             return true;
924         }
925     }
926 
927     /**
928      * @dev Hook that is called before any token transfer. This includes minting
929      * and burning.
930      *
931      * Calling conditions:
932      *
933      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
934      * transferred to `to`.
935      * - When `from` is zero, `tokenId` will be minted for `to`.
936      * - When `to` is zero, ``from``'s `tokenId` will be burned.
937      * - `from` and `to` are never both zero.
938      *
939      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
940      */
941     function _beforeTokenTransfer(
942         address from,
943         address to,
944         uint256 tokenId
945     ) internal virtual {}
946 }
947 
948 
949 
950 /**
951  * @dev Contract module which provides a basic access control mechanism, where
952  * there is an account (an owner) that can be granted exclusive access to
953  * specific functions.
954  *
955  * By default, the owner account will be the one that deploys the contract. This
956  * can later be changed with {transferOwnership}.
957  *
958  * This module is used through inheritance. It will make available the modifier
959  * `onlyOwner`, which can be applied to your functions to restrict their use to
960  * the owner.
961  */
962 abstract contract Ownable is Context {
963     address private _owner;
964 
965     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
966 
967     /**
968      * @dev Initializes the contract setting the deployer as the initial owner.
969      */
970     constructor() {
971         _setOwner(_msgSender());
972     }
973 
974     /**
975      * @dev Returns the address of the current owner.
976      */
977     function owner() public view virtual returns (address) {
978         return _owner;
979     }
980 
981     /**
982      * @dev Throws if called by any account other than the owner.
983      */
984     modifier onlyOwner() {
985         require(owner() == _msgSender(), "Ownable: caller is not the owner");
986         _;
987     }
988 
989     /**
990      * @dev Leaves the contract without owner. It will not be possible to call
991      * `onlyOwner` functions anymore. Can only be called by the current owner.
992      *
993      * NOTE: Renouncing ownership will leave the contract without an owner,
994      * thereby removing any functionality that is only available to the owner.
995      */
996     function renounceOwnership() public virtual onlyOwner {
997         _setOwner(address(0));
998     }
999 
1000     /**
1001      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1002      * Can only be called by the current owner.
1003      */
1004     function transferOwnership(address newOwner) public virtual onlyOwner {
1005         require(newOwner != address(0), "Ownable: new owner is the zero address");
1006         _setOwner(newOwner);
1007     }
1008 
1009     function _setOwner(address newOwner) private {
1010         address oldOwner = _owner;
1011         _owner = newOwner;
1012         emit OwnershipTransferred(oldOwner, newOwner);
1013     }
1014 }
1015 
1016 
1017 
1018 // CAUTION
1019 // This version of SafeMath should only be used with Solidity 0.8 or later,
1020 // because it relies on the compiler's built in overflow checks.
1021 
1022 /**
1023  * @dev Wrappers over Solidity's arithmetic operations.
1024  *
1025  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1026  * now has built in overflow checking.
1027  */
1028 library SafeMath {
1029     /**
1030      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1031      *
1032      * _Available since v3.4._
1033      */
1034     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1035         unchecked {
1036             uint256 c = a + b;
1037             if (c < a) return (false, 0);
1038             return (true, c);
1039         }
1040     }
1041 
1042     /**
1043      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1044      *
1045      * _Available since v3.4._
1046      */
1047     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1048         unchecked {
1049             if (b > a) return (false, 0);
1050             return (true, a - b);
1051         }
1052     }
1053 
1054     /**
1055      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1056      *
1057      * _Available since v3.4._
1058      */
1059     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1060         unchecked {
1061             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1062             // benefit is lost if 'b' is also tested.
1063             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1064             if (a == 0) return (true, 0);
1065             uint256 c = a * b;
1066             if (c / a != b) return (false, 0);
1067             return (true, c);
1068         }
1069     }
1070 
1071     /**
1072      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1073      *
1074      * _Available since v3.4._
1075      */
1076     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1077         unchecked {
1078             if (b == 0) return (false, 0);
1079             return (true, a / b);
1080         }
1081     }
1082 
1083     /**
1084      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1085      *
1086      * _Available since v3.4._
1087      */
1088     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1089         unchecked {
1090             if (b == 0) return (false, 0);
1091             return (true, a % b);
1092         }
1093     }
1094 
1095     /**
1096      * @dev Returns the addition of two unsigned integers, reverting on
1097      * overflow.
1098      *
1099      * Counterpart to Solidity's `+` operator.
1100      *
1101      * Requirements:
1102      *
1103      * - Addition cannot overflow.
1104      */
1105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1106         return a + b;
1107     }
1108 
1109     /**
1110      * @dev Returns the subtraction of two unsigned integers, reverting on
1111      * overflow (when the result is negative).
1112      *
1113      * Counterpart to Solidity's `-` operator.
1114      *
1115      * Requirements:
1116      *
1117      * - Subtraction cannot overflow.
1118      */
1119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1120         return a - b;
1121     }
1122 
1123     /**
1124      * @dev Returns the multiplication of two unsigned integers, reverting on
1125      * overflow.
1126      *
1127      * Counterpart to Solidity's `*` operator.
1128      *
1129      * Requirements:
1130      *
1131      * - Multiplication cannot overflow.
1132      */
1133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1134         return a * b;
1135     }
1136 
1137     /**
1138      * @dev Returns the integer division of two unsigned integers, reverting on
1139      * division by zero. The result is rounded towards zero.
1140      *
1141      * Counterpart to Solidity's `/` operator.
1142      *
1143      * Requirements:
1144      *
1145      * - The divisor cannot be zero.
1146      */
1147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1148         return a / b;
1149     }
1150 
1151     /**
1152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1153      * reverting when dividing by zero.
1154      *
1155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1156      * opcode (which leaves remaining gas untouched) while Solidity uses an
1157      * invalid opcode to revert (consuming all remaining gas).
1158      *
1159      * Requirements:
1160      *
1161      * - The divisor cannot be zero.
1162      */
1163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1164         return a % b;
1165     }
1166 
1167     /**
1168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1169      * overflow (when the result is negative).
1170      *
1171      * CAUTION: This function is deprecated because it requires allocating memory for the error
1172      * message unnecessarily. For custom revert reasons use {trySub}.
1173      *
1174      * Counterpart to Solidity's `-` operator.
1175      *
1176      * Requirements:
1177      *
1178      * - Subtraction cannot overflow.
1179      */
1180     function sub(
1181         uint256 a,
1182         uint256 b,
1183         string memory errorMessage
1184     ) internal pure returns (uint256) {
1185         unchecked {
1186             require(b <= a, errorMessage);
1187             return a - b;
1188         }
1189     }
1190 
1191     /**
1192      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1193      * division by zero. The result is rounded towards zero.
1194      *
1195      * Counterpart to Solidity's `/` operator. Note: this function uses a
1196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1197      * uses an invalid opcode to revert (consuming all remaining gas).
1198      *
1199      * Requirements:
1200      *
1201      * - The divisor cannot be zero.
1202      */
1203     function div(
1204         uint256 a,
1205         uint256 b,
1206         string memory errorMessage
1207     ) internal pure returns (uint256) {
1208         unchecked {
1209             require(b > 0, errorMessage);
1210             return a / b;
1211         }
1212     }
1213 
1214     /**
1215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1216      * reverting with custom message when dividing by zero.
1217      *
1218      * CAUTION: This function is deprecated because it requires allocating memory for the error
1219      * message unnecessarily. For custom revert reasons use {tryMod}.
1220      *
1221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1222      * opcode (which leaves remaining gas untouched) while Solidity uses an
1223      * invalid opcode to revert (consuming all remaining gas).
1224      *
1225      * Requirements:
1226      *
1227      * - The divisor cannot be zero.
1228      */
1229     function mod(
1230         uint256 a,
1231         uint256 b,
1232         string memory errorMessage
1233     ) internal pure returns (uint256) {
1234         unchecked {
1235             require(b > 0, errorMessage);
1236             return a % b;
1237         }
1238     }
1239 }
1240 
1241 
1242 
1243 /**
1244  * @title Counters
1245  * @author Matt Condon (@shrugs)
1246  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1247  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1248  *
1249  * Include with `using Counters for Counters.Counter;`
1250  */
1251 library Counters {
1252     struct Counter {
1253         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1254         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1255         // this feature: see https://github.com/ethereum/solidity/issues/4637
1256         uint256 _value; // default: 0
1257     }
1258 
1259     function current(Counter storage counter) internal view returns (uint256) {
1260         return counter._value;
1261     }
1262 
1263     function increment(Counter storage counter) internal {
1264         unchecked {
1265             counter._value += 1;
1266         }
1267     }
1268 
1269     function decrement(Counter storage counter) internal {
1270         uint256 value = counter._value;
1271         require(value > 0, "Counter: decrement overflow");
1272         unchecked {
1273             counter._value = value - 1;
1274         }
1275     }
1276 
1277     function reset(Counter storage counter) internal {
1278         counter._value = 0;
1279     }
1280 }
1281 
1282 
1283 
1284 /**
1285  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1286  *
1287  * These functions can be used to verify that a message was signed by the holder
1288  * of the private keys of a given address.
1289  */
1290 library ECDSA {
1291     /**
1292      * @dev Returns the address that signed a hashed message (`hash`) with
1293      * `signature`. This address can then be used for verification purposes.
1294      *
1295      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1296      * this function rejects them by requiring the `s` value to be in the lower
1297      * half order, and the `v` value to be either 27 or 28.
1298      *
1299      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1300      * verification to be secure: it is possible to craft signatures that
1301      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1302      * this is by receiving a hash of the original message (which may otherwise
1303      * be too long), and then calling {toEthSignedMessageHash} on it.
1304      *
1305      * Documentation for signature generation:
1306      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1307      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1308      */
1309     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1310         // Check the signature length
1311         // - case 65: r,s,v signature (standard)
1312         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1313         if (signature.length == 65) {
1314             bytes32 r;
1315             bytes32 s;
1316             uint8 v;
1317             // ecrecover takes the signature parameters, and the only way to get them
1318             // currently is to use assembly.
1319             assembly {
1320                 r := mload(add(signature, 0x20))
1321                 s := mload(add(signature, 0x40))
1322                 v := byte(0, mload(add(signature, 0x60)))
1323             }
1324             return recover(hash, v, r, s);
1325         } else if (signature.length == 64) {
1326             bytes32 r;
1327             bytes32 vs;
1328             // ecrecover takes the signature parameters, and the only way to get them
1329             // currently is to use assembly.
1330             assembly {
1331                 r := mload(add(signature, 0x20))
1332                 vs := mload(add(signature, 0x40))
1333             }
1334             return recover(hash, r, vs);
1335         } else {
1336             revert("ECDSA: invalid signature length");
1337         }
1338     }
1339 
1340     /**
1341      * @dev Overload of {ECDSA-recover} that receives the `r` and `vs` short-signature fields separately.
1342      *
1343      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1344      *
1345      * _Available since v4.2._
1346      */
1347     function recover(
1348         bytes32 hash,
1349         bytes32 r,
1350         bytes32 vs
1351     ) internal pure returns (address) {
1352         bytes32 s;
1353         uint8 v;
1354         assembly {
1355             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1356             v := add(shr(255, vs), 27)
1357         }
1358         return recover(hash, v, r, s);
1359     }
1360 
1361     /**
1362      * @dev Overload of {ECDSA-recover} that receives the `v`, `r` and `s` signature fields separately.
1363      */
1364     function recover(
1365         bytes32 hash,
1366         uint8 v,
1367         bytes32 r,
1368         bytes32 s
1369     ) internal pure returns (address) {
1370         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1371         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1372         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1373         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1374         //
1375         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1376         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1377         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1378         // these malleable signatures as well.
1379         require(
1380             uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
1381             "ECDSA: invalid signature 's' value"
1382         );
1383         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
1384 
1385         // If the signature is valid (and not malleable), return the signer address
1386         address signer = ecrecover(hash, v, r, s);
1387         require(signer != address(0), "ECDSA: invalid signature");
1388 
1389         return signer;
1390     }
1391 
1392     /**
1393      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1394      * produces hash corresponding to the one signed with the
1395      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1396      * JSON-RPC method as part of EIP-191.
1397      *
1398      * See {recover}.
1399      */
1400     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1401         // 32 is the length in bytes of hash,
1402         // enforced by the type signature above
1403         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1404     }
1405 
1406     /**
1407      * @dev Returns an Ethereum Signed Typed Data, created from a
1408      * `domainSeparator` and a `structHash`. This produces hash corresponding
1409      * to the one signed with the
1410      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1411      * JSON-RPC method as part of EIP-712.
1412      *
1413      * See {recover}.
1414      */
1415     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1416         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1417     }
1418 }
1419 
1420 contract JPandFriends is Context, ERC721, Ownable {
1421 
1422   using SafeMath for uint256;
1423   using Counters for Counters.Counter;
1424 
1425   Counters.Counter private _tokenIdTracker;
1426   Counters.Counter private _whiteListCount;
1427 
1428   uint256 public salePrice = 37 * 10**15;
1429   uint256 public constant MAX_ELEMENTS = 4000;
1430   address public constant creatorAddress = 0x6c474099ad6d9Af49201a38b9842111d4ACd10BC;
1431   string public baseTokenURI;
1432   bool public placeHolder = true;
1433   bool public saleOn = true;
1434   bool public listOnly = true;
1435   uint256 wlc = 4000;
1436 
1437   uint256 private _royaltyBps = 500;
1438   address payable private _royaltyRecipient;
1439 
1440   bytes4 private constant _INTERFACE_ID_ROYALTIES_CREATORCORE = 0xbb3bafd6;
1441   bytes4 private constant _INTERFACE_ID_ROYALTIES_EIP2981 = 0x2a55205a;
1442   bytes4 private constant _INTERFACE_ID_ROYALTIES_RARIBLE = 0xb7799584;
1443 
1444   mapping (address => bool) public whitelist;
1445   mapping (address => uint8) public totalBought;
1446 
1447   event Mint(address indexed sender, uint256 count, uint256 paid, uint256 price);
1448   event UpdateRoyalty(address indexed _address, uint256 _bps);
1449 
1450     /**
1451      * deploys the contract.
1452      */
1453     constructor(string memory _uri) payable ERC721("J. Pierce & Friends", "JPF") {
1454       _royaltyRecipient = payable(msg.sender);
1455       baseTokenURI = _uri;
1456     }
1457 
1458     function _totalSupply() internal view returns (uint) {
1459         return _tokenIdTracker.current();
1460     }
1461 
1462     modifier saleIsOpen {
1463         require(_totalSupply() <= MAX_ELEMENTS, "Sale end");
1464         require(saleOn, "Sale hasnt started");
1465 
1466         _;
1467     }
1468 
1469     function totalSupply() public view returns (uint256) {
1470         return _totalSupply();
1471     }
1472 
1473     function mint(uint8 _count, address _to, uint256 code) public payable saleIsOpen {
1474         uint256 total = _totalSupply();
1475         uint256 cost = salePrice.mul(_count);
1476         require(total + _count <= MAX_ELEMENTS, "Max limit");
1477         require(msg.value >= price(_count), "Value below price");
1478 
1479         if(listOnly) {
1480 
1481           require(code == wlc, "Sender not on whitelist");
1482           require(totalBought[_to] + _count < 5, "MAX WHITELIST AMOUNT PURCHASED");
1483 
1484           totalBought[_to] = totalBought[_to] + _count;
1485 
1486           _mintElements(_count, _to);
1487           Mint(_to, _count, cost, salePrice);
1488 
1489         } else {
1490 
1491           require(totalBought[_to] + _count < 13, "MAX GENERAL SALE AMOUNT PURCHASED");
1492           totalBought[_to] = totalBought[_to] + _count;
1493           _mintElements(_count, _to);
1494           Mint(_to, _count, cost, salePrice);
1495         }
1496     }
1497 
1498     function creditCardMint(uint8 _count, address _to) public saleIsOpen onlyOwner {
1499         uint256 total = _totalSupply();
1500         uint256 cost = salePrice.mul(_count);
1501         require(total + _count <= MAX_ELEMENTS, "Max limit");
1502         Mint(_to, _count, cost, salePrice);
1503         _mintElements(_count, _to);
1504     }
1505 
1506     function _mintElements(uint256 _count, address _to) private {
1507         for (uint256 i = 0; i < _count; i++) {
1508           _tokenIdTracker.increment();
1509           _safeMint(_to, _tokenIdTracker.current());
1510         }
1511     }
1512 
1513     function price(uint256 _count) public view returns (uint256) {
1514         return salePrice.mul(_count);
1515     }
1516 
1517     // Set price
1518     function setPrice(uint256 _price) public onlyOwner{
1519         salePrice = _price;
1520     }
1521 
1522     function setWlc(uint256 _wlc) public onlyOwner{
1523         wlc = _wlc;
1524     }
1525 
1526     // Function to withdraw all Ether and tokens from this contract.
1527     function withdraw() public onlyOwner{
1528         uint amount = address(this).balance;
1529 
1530         // send all Ether to owner
1531         // Owner can receive Ether since the address of owner is payable
1532         (bool success, ) = owner().call{value: amount}("");
1533         require(success, "Failed to send Ether");
1534 
1535     }
1536 
1537     function setBaseURI(string memory baseURI) public onlyOwner {
1538         baseTokenURI = baseURI;
1539     }
1540 
1541     function setPlaceHolder(bool isOn) public onlyOwner {
1542         placeHolder = isOn;
1543     }
1544 
1545     function setSaleOn(bool isOn) public onlyOwner {
1546         saleOn = isOn;
1547     }
1548 
1549     function setListOnly(bool isOn) public onlyOwner {
1550         listOnly = isOn;
1551     }
1552 
1553     function tokenURI(uint256 _id) public view virtual override returns (string memory) {
1554         if(placeHolder) {
1555           return baseTokenURI;
1556         } else {
1557           return string(abi.encodePacked(baseTokenURI, uint2str(_id), ".json"));
1558         }
1559     }
1560 
1561     /**
1562     * @dev Update royalties
1563     */
1564     function updateRoyalties(address payable recipient, uint256 bps) external onlyOwner {
1565         _royaltyRecipient = recipient;
1566         _royaltyBps = bps;
1567         emit UpdateRoyalty(recipient, bps);
1568     }
1569 
1570     /**
1571       * ROYALTY FUNCTIONS
1572       */
1573     function getRoyalties(uint256) external view returns (address payable[] memory recipients, uint256[] memory bps) {
1574         if (_royaltyRecipient != address(0x0)) {
1575             recipients = new address payable[](1);
1576             recipients[0] = _royaltyRecipient;
1577             bps = new uint256[](1);
1578             bps[0] = _royaltyBps;
1579         }
1580         return (recipients, bps);
1581     }
1582 
1583     function getFeeRecipients(uint256) external view returns (address payable[] memory recipients) {
1584         if (_royaltyRecipient != address(0x0)) {
1585             recipients = new address payable[](1);
1586             recipients[0] = _royaltyRecipient;
1587         }
1588         return recipients;
1589     }
1590 
1591     function getFeeBps(uint256) external view returns (uint[] memory bps) {
1592         if (_royaltyRecipient != address(0x0)) {
1593             bps = new uint256[](1);
1594             bps[0] = _royaltyBps;
1595         }
1596         return bps;
1597     }
1598 
1599     function royaltyInfo(uint256, uint256 value) external view returns (address, uint256) {
1600         return (_royaltyRecipient, value*_royaltyBps/10000);
1601     }
1602 
1603     /**
1604      * @dev See {IERC165-supportsInterface}.
1605      */
1606     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
1607         return ERC721.supportsInterface(interfaceId) || interfaceId == _INTERFACE_ID_ROYALTIES_CREATORCORE
1608                || interfaceId == _INTERFACE_ID_ROYALTIES_EIP2981 || interfaceId == _INTERFACE_ID_ROYALTIES_RARIBLE;
1609     }
1610 
1611      function uint2str(
1612       uint256 _i
1613     )
1614       internal
1615       pure
1616       returns (string memory str)
1617     {
1618       if (_i == 0)
1619       {
1620         return "0";
1621       }
1622       uint256 j = _i;
1623       uint256 length;
1624       while (j != 0)
1625       {
1626         length++;
1627         j /= 10;
1628       }
1629       bytes memory bstr = new bytes(length);
1630       uint256 k = length;
1631       j = _i;
1632       while (j != 0)
1633       {
1634         bstr[--k] = bytes1(uint8(48 + j % 10));
1635         j /= 10;
1636       }
1637       str = string(bstr);
1638     }
1639 
1640 }