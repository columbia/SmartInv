1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity ^0.8.0;
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
27 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Required interface of an ERC721 compliant contract.
32  */
33 interface IERC721 is IERC165 {
34     /**
35      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
36      */
37     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
41      */
42     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
46      */
47     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
48 
49     /**
50      * @dev Returns the number of tokens in ``owner``'s account.
51      */
52     function balanceOf(address owner) external view returns (uint256 balance);
53 
54     /**
55      * @dev Returns the owner of the `tokenId` token.
56      *
57      * Requirements:
58      *
59      * - `tokenId` must exist.
60      */
61     function ownerOf(uint256 tokenId) external view returns (address owner);
62 
63     /**
64      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
65      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
66      *
67      * Requirements:
68      *
69      * - `from` cannot be the zero address.
70      * - `to` cannot be the zero address.
71      * - `tokenId` token must exist and be owned by `from`.
72      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
73      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
74      *
75      * Emits a {Transfer} event.
76      */
77     function safeTransferFrom(address from, address to, uint256 tokenId) external;
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
93     function transferFrom(address from, address to, uint256 tokenId) external;
94 
95     /**
96      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
97      * The approval is cleared when the token is transferred.
98      *
99      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
100      *
101      * Requirements:
102      *
103      * - The caller must own the token or be an approved operator.
104      * - `tokenId` must exist.
105      *
106      * Emits an {Approval} event.
107      */
108     function approve(address to, uint256 tokenId) external;
109 
110     /**
111      * @dev Returns the account approved for `tokenId` token.
112      *
113      * Requirements:
114      *
115      * - `tokenId` must exist.
116      */
117     function getApproved(uint256 tokenId) external view returns (address operator);
118 
119     /**
120      * @dev Approve or remove `operator` as an operator for the caller.
121      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
122      *
123      * Requirements:
124      *
125      * - The `operator` cannot be the caller.
126      *
127      * Emits an {ApprovalForAll} event.
128      */
129     function setApprovalForAll(address operator, bool _approved) external;
130 
131     /**
132      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
133      *
134      * See {setApprovalForAll}
135      */
136     function isApprovedForAll(address owner, address operator) external view returns (bool);
137 
138     /**
139       * @dev Safely transfers `tokenId` token from `from` to `to`.
140       *
141       * Requirements:
142       *
143       * - `from` cannot be the zero address.
144       * - `to` cannot be the zero address.
145       * - `tokenId` token must exist and be owned by `from`.
146       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
147       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
148       *
149       * Emits a {Transfer} event.
150       */
151     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
152 }
153 
154 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
155 pragma solidity ^0.8.0;
156 
157 /**
158  * @title ERC721 token receiver interface
159  * @dev Interface for any contract that wants to support safeTransfers
160  * from ERC721 asset contracts.
161  */
162 interface IERC721Receiver {
163     /**
164      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
165      * by `operator` from `from`, this function is called.
166      *
167      * It must return its Solidity selector to confirm the token transfer.
168      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
169      *
170      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
171      */
172     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
173 }
174 
175 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
180  * @dev See https://eips.ethereum.org/EIPS/eip-721
181  */
182 interface IERC721Metadata is IERC721 {
183 
184     /**
185      * @dev Returns the token collection name.
186      */
187     function name() external view returns (string memory);
188 
189     /**
190      * @dev Returns the token collection symbol.
191      */
192     function symbol() external view returns (string memory);
193 
194     /**
195      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
196      */
197     function tokenURI(uint256 tokenId) external view returns (string memory);
198 }
199 
200 // File: @openzeppelin/contracts/utils/Address.sol
201 pragma solidity ^0.8.0;
202 
203 /**
204  * @dev Collection of functions related to the address type
205  */
206 library Address {
207     /**
208      * @dev Returns true if `account` is a contract.
209      *
210      * [IMPORTANT]
211      * ====
212      * It is unsafe to assume that an address for which this function returns
213      * false is an externally-owned account (EOA) and not a contract.
214      *
215      * Among others, `isContract` will return false for the following
216      * types of addresses:
217      *
218      *  - an externally-owned account
219      *  - a contract in construction
220      *  - an address where a contract will be created
221      *  - an address where a contract lived, but was destroyed
222      * ====
223      */
224     function isContract(address account) internal view returns (bool) {
225         // This method relies on extcodesize, which returns 0 for contracts in
226         // construction, since the code is only stored at the end of the
227         // constructor execution.
228 
229         uint256 size;
230         // solhint-disable-next-line no-inline-assembly
231         assembly { size := extcodesize(account) }
232         return size > 0;
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
254         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
255         (bool success, ) = recipient.call{ value: amount }("");
256         require(success, "Address: unable to send value, recipient may have reverted");
257     }
258 
259     /**
260      * @dev Performs a Solidity function call using a low level `call`. A
261      * plain`call` is an unsafe replacement for a function call: use this
262      * function instead.
263      *
264      * If `target` reverts with a revert reason, it is bubbled up by this
265      * function (like regular Solidity function calls).
266      *
267      * Returns the raw returned data. To convert to the expected return value,
268      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
269      *
270      * Requirements:
271      *
272      * - `target` must be a contract.
273      * - calling `target` with `data` must not revert.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
278       return functionCall(target, data, "Address: low-level call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
283      * `errorMessage` as a fallback revert reason when `target` reverts.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
288         return functionCallWithValue(target, data, 0, errorMessage);
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
293      * but also transferring `value` wei to `target`.
294      *
295      * Requirements:
296      *
297      * - the calling contract must have an ETH balance of at least `value`.
298      * - the called Solidity function must be `payable`.
299      *
300      * _Available since v3.1._
301      */
302     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
303         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
308      * with `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._
311      */
312     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
313         require(address(this).balance >= value, "Address: insufficient balance for call");
314         require(isContract(target), "Address: call to non-contract");
315 
316         // solhint-disable-next-line avoid-low-level-calls
317         (bool success, bytes memory returndata) = target.call{ value: value }(data);
318         return _verifyCallResult(success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but performing a static call.
324      *
325      * _Available since v3.3._
326      */
327     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
328         return functionStaticCall(target, data, "Address: low-level static call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
333      * but performing a static call.
334      *
335      * _Available since v3.3._
336      */
337     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
338         require(isContract(target), "Address: static call to non-contract");
339 
340         // solhint-disable-next-line avoid-low-level-calls
341         (bool success, bytes memory returndata) = target.staticcall(data);
342         return _verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
362         require(isContract(target), "Address: delegate call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = target.delegatecall(data);
366         return _verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
370         if (success) {
371             return returndata;
372         } else {
373             // Look for revert reason and bubble it up if present
374             if (returndata.length > 0) {
375                 // The easiest way to bubble the revert reason is using memory via assembly
376 
377                 // solhint-disable-next-line no-inline-assembly
378                 assembly {
379                     let returndata_size := mload(returndata)
380                     revert(add(32, returndata), returndata_size)
381                 }
382             } else {
383                 revert(errorMessage);
384             }
385         }
386     }
387 }
388 
389 // File: @openzeppelin/contracts/utils/Context.sol
390 pragma solidity ^0.8.0;
391 
392 /*
393  * @dev Provides information about the current execution context, including the
394  * sender of the transaction and its data. While these are generally available
395  * via msg.sender and msg.data, they should not be accessed in such a direct
396  * manner, since when dealing with meta-transactions the account sending and
397  * paying for execution may not be the actual sender (as far as an application
398  * is concerned).
399  *
400  * This contract is only required for intermediate, library-like contracts.
401  */
402 abstract contract Context {
403     function _msgSender() internal view virtual returns (address) {
404         return msg.sender;
405     }
406 
407     function _msgData() internal view virtual returns (bytes calldata) {
408         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
409         return msg.data;
410     }
411 }
412 
413 // File: @openzeppelin/contracts/utils/Strings.sol
414 pragma solidity ^0.8.0;
415 
416 /**
417  * @dev String operations.
418  */
419 library Strings {
420     bytes16 private constant alphabet = "0123456789abcdef";
421 
422     /**
423      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
424      */
425     function toString(uint256 value) internal pure returns (string memory) {
426         // Inspired by OraclizeAPI's implementation - MIT licence
427         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
428 
429         if (value == 0) {
430             return "0";
431         }
432         uint256 temp = value;
433         uint256 digits;
434         while (temp != 0) {
435             digits++;
436             temp /= 10;
437         }
438         bytes memory buffer = new bytes(digits);
439         while (value != 0) {
440             digits -= 1;
441             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
442             value /= 10;
443         }
444         return string(buffer);
445     }
446 
447     /**
448      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
449      */
450     function toHexString(uint256 value) internal pure returns (string memory) {
451         if (value == 0) {
452             return "0x00";
453         }
454         uint256 temp = value;
455         uint256 length = 0;
456         while (temp != 0) {
457             length++;
458             temp >>= 8;
459         }
460         return toHexString(value, length);
461     }
462 
463     /**
464      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
465      */
466     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
467         bytes memory buffer = new bytes(2 * length + 2);
468         buffer[0] = "0";
469         buffer[1] = "x";
470         for (uint256 i = 2 * length + 1; i > 1; --i) {
471             buffer[i] = alphabet[value & 0xf];
472             value >>= 4;
473         }
474         require(value == 0, "Strings: hex length insufficient");
475         return string(buffer);
476     }
477 
478 }
479 
480 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
481 pragma solidity ^0.8.0;
482 
483 
484 /**
485  * @dev Implementation of the {IERC165} interface.
486  *
487  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
488  * for the additional interface id that will be supported. For example:
489  *
490  * ```solidity
491  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
492  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
493  * }
494  * ```
495  *
496  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
497  */
498 abstract contract ERC165 is IERC165 {
499     /**
500      * @dev See {IERC165-supportsInterface}.
501      */
502     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
503         return interfaceId == type(IERC165).interfaceId;
504     }
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
508 pragma solidity ^0.8.0;
509 
510 /**
511  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
512  * the Metadata extension, but not including the Enumerable extension, which is available separately as
513  * {ERC721Enumerable}.
514  */
515 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
516     using Address for address;
517     using Strings for uint256;
518 
519     // Token name
520     string private _name;
521 
522     // Token symbol
523     string private _symbol;
524 
525     // Mapping from token ID to owner address
526     mapping (uint256 => address) private _owners;
527 
528     // Mapping owner address to token count
529     mapping (address => uint256) private _balances;
530 
531     // Mapping from token ID to approved address
532     mapping (uint256 => address) private _tokenApprovals;
533 
534     // Mapping from owner to operator approvals
535     mapping (address => mapping (address => bool)) private _operatorApprovals;
536 
537     /**
538      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
539      */
540     constructor (string memory name_, string memory symbol_) {
541         _name = name_;
542         _symbol = symbol_;
543     }
544 
545     /**
546      * @dev See {IERC165-supportsInterface}.
547      */
548     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
549         return interfaceId == type(IERC721).interfaceId
550             || interfaceId == type(IERC721Metadata).interfaceId
551             || super.supportsInterface(interfaceId);
552     }
553 
554     /**
555      * @dev See {IERC721-balanceOf}.
556      */
557     function balanceOf(address owner) public view virtual override returns (uint256) {
558         require(owner != address(0), "ERC721: balance query for the zero address");
559         return _balances[owner];
560     }
561 
562     /**
563      * @dev See {IERC721-ownerOf}.
564      */
565     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
566         address owner = _owners[tokenId];
567         require(owner != address(0), "ERC721: owner query for nonexistent token");
568         return owner;
569     }
570 
571     /**
572      * @dev See {IERC721Metadata-name}.
573      */
574     function name() public view virtual override returns (string memory) {
575         return _name;
576     }
577 
578     /**
579      * @dev See {IERC721Metadata-symbol}.
580      */
581     function symbol() public view virtual override returns (string memory) {
582         return _symbol;
583     }
584 
585     /**
586      * @dev See {IERC721Metadata-tokenURI}.
587      */
588     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
589         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
590 
591         string memory baseURI = _baseURI();
592         return bytes(baseURI).length > 0
593             ? string(abi.encodePacked(baseURI, tokenId.toString()))
594             : '';
595     }
596 
597     /**
598      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
599      * in child contracts.
600      */
601     function _baseURI() internal view virtual returns (string memory) {
602         return "";
603     }
604 
605     /**
606      * @dev See {IERC721-approve}.
607      */
608     function approve(address to, uint256 tokenId) public virtual override {
609         address owner = ERC721.ownerOf(tokenId);
610         require(to != owner, "ERC721: approval to current owner");
611 
612         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
613             "ERC721: approve caller is not owner nor approved for all"
614         );
615 
616         _approve(to, tokenId);
617     }
618 
619     /**
620      * @dev See {IERC721-getApproved}.
621      */
622     function getApproved(uint256 tokenId) public view virtual override returns (address) {
623         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
624 
625         return _tokenApprovals[tokenId];
626     }
627 
628     /**
629      * @dev See {IERC721-setApprovalForAll}.
630      */
631     function setApprovalForAll(address operator, bool approved) public virtual override {
632         require(operator != _msgSender(), "ERC721: approve to caller");
633 
634         _operatorApprovals[_msgSender()][operator] = approved;
635         emit ApprovalForAll(_msgSender(), operator, approved);
636     }
637 
638     /**
639      * @dev See {IERC721-isApprovedForAll}.
640      */
641     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
642         return _operatorApprovals[owner][operator];
643     }
644 
645     /**
646      * @dev See {IERC721-transferFrom}.
647      */
648     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
649         //solhint-disable-next-line max-line-length
650         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
651 
652         _transfer(from, to, tokenId);
653     }
654 
655     /**
656      * @dev See {IERC721-safeTransferFrom}.
657      */
658     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
659         safeTransferFrom(from, to, tokenId, "");
660     }
661 
662     /**
663      * @dev See {IERC721-safeTransferFrom}.
664      */
665     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
666         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
667         _safeTransfer(from, to, tokenId, _data);
668     }
669 
670     /**
671      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
672      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
673      *
674      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
675      *
676      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
677      * implement alternative mechanisms to perform token transfer, such as signature-based.
678      *
679      * Requirements:
680      *
681      * - `from` cannot be the zero address.
682      * - `to` cannot be the zero address.
683      * - `tokenId` token must exist and be owned by `from`.
684      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
685      *
686      * Emits a {Transfer} event.
687      */
688     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
689         _transfer(from, to, tokenId);
690         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
691     }
692 
693     /**
694      * @dev Returns whether `tokenId` exists.
695      *
696      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
697      *
698      * Tokens start existing when they are minted (`_mint`),
699      * and stop existing when they are burned (`_burn`).
700      */
701     function _exists(uint256 tokenId) internal view virtual returns (bool) {
702         return _owners[tokenId] != address(0);
703     }
704 
705     /**
706      * @dev Returns whether `spender` is allowed to manage `tokenId`.
707      *
708      * Requirements:
709      *
710      * - `tokenId` must exist.
711      */
712     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
713         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
714         address owner = ERC721.ownerOf(tokenId);
715         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
716     }
717 
718     /**
719      * @dev Safely mints `tokenId` and transfers it to `to`.
720      *
721      * Requirements:
722      *
723      * - `tokenId` must not exist.
724      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
725      *
726      * Emits a {Transfer} event.
727      */
728     function _safeMint(address to, uint256 tokenId) internal virtual {
729         _safeMint(to, tokenId, "");
730     }
731 
732     /**
733      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
734      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
735      */
736     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
737         _mint(to, tokenId);
738         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
739     }
740 
741     /**
742      * @dev Mints `tokenId` and transfers it to `to`.
743      *
744      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
745      *
746      * Requirements:
747      *
748      * - `tokenId` must not exist.
749      * - `to` cannot be the zero address.
750      *
751      * Emits a {Transfer} event.
752      */
753     function _mint(address to, uint256 tokenId) internal virtual {
754         require(to != address(0), "ERC721: mint to the zero address");
755         require(!_exists(tokenId), "ERC721: token already minted");
756 
757         _beforeTokenTransfer(address(0), to, tokenId);
758 
759         _balances[to] += 1;
760         _owners[tokenId] = to;
761 
762         emit Transfer(address(0), to, tokenId);
763     }
764 
765     /**
766      * @dev Destroys `tokenId`.
767      * The approval is cleared when the token is burned.
768      *
769      * Requirements:
770      *
771      * - `tokenId` must exist.
772      *
773      * Emits a {Transfer} event.
774      */
775     function _burn(uint256 tokenId) internal virtual {
776         address owner = ERC721.ownerOf(tokenId);
777 
778         _beforeTokenTransfer(owner, address(0), tokenId);
779 
780         // Clear approvals
781         _approve(address(0), tokenId);
782 
783         _balances[owner] -= 1;
784         delete _owners[tokenId];
785 
786         emit Transfer(owner, address(0), tokenId);
787     }
788 
789     /**
790      * @dev Transfers `tokenId` from `from` to `to`.
791      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
792      *
793      * Requirements:
794      *
795      * - `to` cannot be the zero address.
796      * - `tokenId` token must be owned by `from`.
797      *
798      * Emits a {Transfer} event.
799      */
800     function _transfer(address from, address to, uint256 tokenId) internal virtual {
801         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
802         require(to != address(0), "ERC721: transfer to the zero address");
803 
804         _beforeTokenTransfer(from, to, tokenId);
805 
806         // Clear approvals from the previous owner
807         _approve(address(0), tokenId);
808 
809         _balances[from] -= 1;
810         _balances[to] += 1;
811         _owners[tokenId] = to;
812 
813         emit Transfer(from, to, tokenId);
814     }
815 
816     /**
817      * @dev Approve `to` to operate on `tokenId`
818      *
819      * Emits a {Approval} event.
820      */
821     function _approve(address to, uint256 tokenId) internal virtual {
822         _tokenApprovals[tokenId] = to;
823         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
824     }
825 
826     /**
827      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
828      * The call is not executed if the target address is not a contract.
829      *
830      * @param from address representing the previous owner of the given token ID
831      * @param to target address that will receive the tokens
832      * @param tokenId uint256 ID of the token to be transferred
833      * @param _data bytes optional data to send along with the call
834      * @return bool whether the call correctly returned the expected magic value
835      */
836     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
837         private returns (bool)
838     {
839         if (to.isContract()) {
840             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
841                 return retval == IERC721Receiver(to).onERC721Received.selector;
842             } catch (bytes memory reason) {
843                 if (reason.length == 0) {
844                     revert("ERC721: transfer to non ERC721Receiver implementer");
845                 } else {
846                     // solhint-disable-next-line no-inline-assembly
847                     assembly {
848                         revert(add(32, reason), mload(reason))
849                     }
850                 }
851             }
852         } else {
853             return true;
854         }
855     }
856 
857     /**
858      * @dev Hook that is called before any token transfer. This includes minting
859      * and burning.
860      *
861      * Calling conditions:
862      *
863      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
864      * transferred to `to`.
865      * - When `from` is zero, `tokenId` will be minted for `to`.
866      * - When `to` is zero, ``from``'s `tokenId` will be burned.
867      * - `from` cannot be the zero address.
868      * - `to` cannot be the zero address.
869      *
870      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
871      */
872     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
873 }
874 
875 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
876 
877 
878 
879 pragma solidity ^0.8.0;
880 
881 
882 /**
883  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
884  * @dev See https://eips.ethereum.org/EIPS/eip-721
885  */
886 interface IERC721Enumerable is IERC721 {
887 
888     /**
889      * @dev Returns the total amount of tokens stored by the contract.
890      */
891     function totalSupply() external view returns (uint256);
892 
893     /**
894      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
895      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
896      */
897     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
898 
899     /**
900      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
901      * Use along with {totalSupply} to enumerate all tokens.
902      */
903     function tokenByIndex(uint256 index) external view returns (uint256);
904 }
905 
906 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
907 
908 
909 
910 pragma solidity ^0.8.0;
911 
912 
913 
914 /**
915  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
916  * enumerability of all the token ids in the contract as well as all token ids owned by each
917  * account.
918  */
919 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
920     // Mapping from owner to list of owned token IDs
921     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
922 
923     // Mapping from token ID to index of the owner tokens list
924     mapping(uint256 => uint256) private _ownedTokensIndex;
925 
926     // Array with all token ids, used for enumeration
927     uint256[] private _allTokens;
928 
929     // Mapping from token id to position in the allTokens array
930     mapping(uint256 => uint256) private _allTokensIndex;
931 
932     /**
933      * @dev See {IERC165-supportsInterface}.
934      */
935     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
936         return interfaceId == type(IERC721Enumerable).interfaceId
937             || super.supportsInterface(interfaceId);
938     }
939 
940     /**
941      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
942      */
943     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
944         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
945         return _ownedTokens[owner][index];
946     }
947 
948     /**
949      * @dev See {IERC721Enumerable-totalSupply}.
950      */
951     function totalSupply() public view virtual override returns (uint256) {
952         return _allTokens.length;
953     }
954 
955     /**
956      * @dev See {IERC721Enumerable-tokenByIndex}.
957      */
958     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
959         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
960         return _allTokens[index];
961     }
962 
963     /**
964      * @dev Hook that is called before any token transfer. This includes minting
965      * and burning.
966      *
967      * Calling conditions:
968      *
969      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
970      * transferred to `to`.
971      * - When `from` is zero, `tokenId` will be minted for `to`.
972      * - When `to` is zero, ``from``'s `tokenId` will be burned.
973      * - `from` cannot be the zero address.
974      * - `to` cannot be the zero address.
975      *
976      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
977      */
978     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
979         super._beforeTokenTransfer(from, to, tokenId);
980 
981         if (from == address(0)) {
982             _addTokenToAllTokensEnumeration(tokenId);
983         } else if (from != to) {
984             _removeTokenFromOwnerEnumeration(from, tokenId);
985         }
986         if (to == address(0)) {
987             _removeTokenFromAllTokensEnumeration(tokenId);
988         } else if (to != from) {
989             _addTokenToOwnerEnumeration(to, tokenId);
990         }
991     }
992 
993     /**
994      * @dev Private function to add a token to this extension's ownership-tracking data structures.
995      * @param to address representing the new owner of the given token ID
996      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
997      */
998     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
999         uint256 length = ERC721.balanceOf(to);
1000         _ownedTokens[to][length] = tokenId;
1001         _ownedTokensIndex[tokenId] = length;
1002     }
1003 
1004     /**
1005      * @dev Private function to add a token to this extension's token tracking data structures.
1006      * @param tokenId uint256 ID of the token to be added to the tokens list
1007      */
1008     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1009         _allTokensIndex[tokenId] = _allTokens.length;
1010         _allTokens.push(tokenId);
1011     }
1012 
1013     /**
1014      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1015      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1016      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1017      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1018      * @param from address representing the previous owner of the given token ID
1019      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1020      */
1021     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1022         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1023         // then delete the last slot (swap and pop).
1024 
1025         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1026         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1027 
1028         // When the token to delete is the last token, the swap operation is unnecessary
1029         if (tokenIndex != lastTokenIndex) {
1030             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1031 
1032             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1033             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1034         }
1035 
1036         // This also deletes the contents at the last position of the array
1037         delete _ownedTokensIndex[tokenId];
1038         delete _ownedTokens[from][lastTokenIndex];
1039     }
1040 
1041     /**
1042      * @dev Private function to remove a token from this extension's token tracking data structures.
1043      * This has O(1) time complexity, but alters the order of the _allTokens array.
1044      * @param tokenId uint256 ID of the token to be removed from the tokens list
1045      */
1046     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1047         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1048         // then delete the last slot (swap and pop).
1049 
1050         uint256 lastTokenIndex = _allTokens.length - 1;
1051         uint256 tokenIndex = _allTokensIndex[tokenId];
1052 
1053         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1054         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1055         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1056         uint256 lastTokenId = _allTokens[lastTokenIndex];
1057 
1058         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1059         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1060 
1061         // This also deletes the contents at the last position of the array
1062         delete _allTokensIndex[tokenId];
1063         _allTokens.pop();
1064     }
1065 }
1066 
1067 // File: @openzeppelin/contracts/access/Ownable.sol
1068 
1069 
1070 
1071 pragma solidity ^0.8.0;
1072 
1073 /**
1074  * @dev Contract module which provides a basic access control mechanism, where
1075  * there is an account (an owner) that can be granted exclusive access to
1076  * specific functions.
1077  *
1078  * By default, the owner account will be the one that deploys the contract. This
1079  * can later be changed with {transferOwnership}.
1080  *
1081  * This module is used through inheritance. It will make available the modifier
1082  * `onlyOwner`, which can be applied to your functions to restrict their use to
1083  * the owner.
1084  */
1085 abstract contract Ownable is Context {
1086     address private _owner;
1087 
1088     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1089 
1090     /**
1091      * @dev Initializes the contract setting the deployer as the initial owner.
1092      */
1093     constructor () {
1094         address msgSender = _msgSender();
1095         _owner = msgSender;
1096         emit OwnershipTransferred(address(0), msgSender);
1097     }
1098 
1099     /**
1100      * @dev Returns the address of the current owner.
1101      */
1102     function owner() public view virtual returns (address) {
1103         return _owner;
1104     }
1105 
1106     /**
1107      * @dev Throws if called by any account other than the owner.
1108      */
1109     modifier onlyOwner() {
1110         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1111         _;
1112     }
1113 
1114     /**
1115      * @dev Leaves the contract without owner. It will not be possible to call
1116      * `onlyOwner` functions anymore. Can only be called by the current owner.
1117      *
1118      * NOTE: Renouncing ownership will leave the contract without an owner,
1119      * thereby removing any functionality that is only available to the owner.
1120      */
1121     function renounceOwnership() public virtual onlyOwner {
1122         emit OwnershipTransferred(_owner, address(0));
1123         _owner = address(0);
1124     }
1125 
1126     /**
1127      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1128      * Can only be called by the current owner.
1129      */
1130     function transferOwnership(address newOwner) public virtual onlyOwner {
1131         require(newOwner != address(0), "Ownable: new owner is the zero address");
1132         emit OwnershipTransferred(_owner, newOwner);
1133         _owner = newOwner;
1134     }
1135 }
1136 
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 // CAUTION
1141 // This version of SafeMath should only be used with Solidity 0.8 or later,
1142 // because it relies on the compiler's built in overflow checks.
1143 
1144 /**
1145  * @dev Wrappers over Solidity's arithmetic operations.
1146  *
1147  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1148  * now has built in overflow checking.
1149  */
1150 library SafeMath {
1151     /**
1152      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1153      *
1154      * _Available since v3.4._
1155      */
1156     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1157         unchecked {
1158             uint256 c = a + b;
1159             if (c < a) return (false, 0);
1160             return (true, c);
1161         }
1162     }
1163 
1164     /**
1165      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1166      *
1167      * _Available since v3.4._
1168      */
1169     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1170         unchecked {
1171             if (b > a) return (false, 0);
1172             return (true, a - b);
1173         }
1174     }
1175 
1176     /**
1177      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1178      *
1179      * _Available since v3.4._
1180      */
1181     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1182         unchecked {
1183             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1184             // benefit is lost if 'b' is also tested.
1185             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1186             if (a == 0) return (true, 0);
1187             uint256 c = a * b;
1188             if (c / a != b) return (false, 0);
1189             return (true, c);
1190         }
1191     }
1192 
1193     /**
1194      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1195      *
1196      * _Available since v3.4._
1197      */
1198     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1199         unchecked {
1200             if (b == 0) return (false, 0);
1201             return (true, a / b);
1202         }
1203     }
1204 
1205     /**
1206      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1207      *
1208      * _Available since v3.4._
1209      */
1210     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1211         unchecked {
1212             if (b == 0) return (false, 0);
1213             return (true, a % b);
1214         }
1215     }
1216 
1217     /**
1218      * @dev Returns the addition of two unsigned integers, reverting on
1219      * overflow.
1220      *
1221      * Counterpart to Solidity's `+` operator.
1222      *
1223      * Requirements:
1224      *
1225      * - Addition cannot overflow.
1226      */
1227     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1228         return a + b;
1229     }
1230 
1231     /**
1232      * @dev Returns the subtraction of two unsigned integers, reverting on
1233      * overflow (when the result is negative).
1234      *
1235      * Counterpart to Solidity's `-` operator.
1236      *
1237      * Requirements:
1238      *
1239      * - Subtraction cannot overflow.
1240      */
1241     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1242         return a - b;
1243     }
1244 
1245     /**
1246      * @dev Returns the multiplication of two unsigned integers, reverting on
1247      * overflow.
1248      *
1249      * Counterpart to Solidity's `*` operator.
1250      *
1251      * Requirements:
1252      *
1253      * - Multiplication cannot overflow.
1254      */
1255     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1256         return a * b;
1257     }
1258 
1259     /**
1260      * @dev Returns the integer division of two unsigned integers, reverting on
1261      * division by zero. The result is rounded towards zero.
1262      *
1263      * Counterpart to Solidity's `/` operator.
1264      *
1265      * Requirements:
1266      *
1267      * - The divisor cannot be zero.
1268      */
1269     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1270         return a / b;
1271     }
1272 
1273     /**
1274      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1275      * reverting when dividing by zero.
1276      *
1277      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1278      * opcode (which leaves remaining gas untouched) while Solidity uses an
1279      * invalid opcode to revert (consuming all remaining gas).
1280      *
1281      * Requirements:
1282      *
1283      * - The divisor cannot be zero.
1284      */
1285     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1286         return a % b;
1287     }
1288 
1289     /**
1290      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1291      * overflow (when the result is negative).
1292      *
1293      * CAUTION: This function is deprecated because it requires allocating memory for the error
1294      * message unnecessarily. For custom revert reasons use {trySub}.
1295      *
1296      * Counterpart to Solidity's `-` operator.
1297      *
1298      * Requirements:
1299      *
1300      * - Subtraction cannot overflow.
1301      */
1302     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1303         unchecked {
1304             require(b <= a, errorMessage);
1305             return a - b;
1306         }
1307     }
1308 
1309     /**
1310      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1311      * division by zero. The result is rounded towards zero.
1312      *
1313      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1314      * opcode (which leaves remaining gas untouched) while Solidity uses an
1315      * invalid opcode to revert (consuming all remaining gas).
1316      *
1317      * Counterpart to Solidity's `/` operator. Note: this function uses a
1318      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1319      * uses an invalid opcode to revert (consuming all remaining gas).
1320      *
1321      * Requirements:
1322      *
1323      * - The divisor cannot be zero.
1324      */
1325     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1326         unchecked {
1327             require(b > 0, errorMessage);
1328             return a / b;
1329         }
1330     }
1331 
1332     /**
1333      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1334      * reverting with custom message when dividing by zero.
1335      *
1336      * CAUTION: This function is deprecated because it requires allocating memory for the error
1337      * message unnecessarily. For custom revert reasons use {tryMod}.
1338      *
1339      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1340      * opcode (which leaves remaining gas untouched) while Solidity uses an
1341      * invalid opcode to revert (consuming all remaining gas).
1342      *
1343      * Requirements:
1344      *
1345      * - The divisor cannot be zero.
1346      */
1347     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1348         unchecked {
1349             require(b > 0, errorMessage);
1350             return a % b;
1351         }
1352     }
1353 }
1354 
1355 // File: Magnum.sol
1356 pragma solidity ^0.8.0;
1357 
1358 contract Magnum is ERC721Enumerable, Ownable {
1359     using SafeMath for uint256;
1360     using Strings for uint256;
1361 
1362     uint256 public constant MAX_SUPPLY = 10000;
1363 
1364     // Pre-Presale
1365     bool public claimActive = true;
1366     uint256 public constant PRE_PRESALE_START_TIME = 1638297020; // 1:30pm EST November 30th 2021
1367 
1368     // Presale
1369     uint256 public constant PRESALE_START_TIME = 1638302400; // 3pm EST November 30th 2021
1370     uint256 public constant PRESALE_MINT_PRICE = 100000000000000000; // 0.1 ETH
1371     uint256 public constant PRESALE_SUPPLY = 3333;
1372     
1373     // Public Sale 1
1374     bool public firstPublicSaleStarted = false;
1375     uint256 public constant PUBLIC_SALE_1_MINT_PRICE = 150000000000000000; // 0.15 ETH
1376     uint256 public constant PUBLIC_SALE_1_SUPPLY = 6666;
1377     
1378     // Public Sale 2
1379     bool public secondPublicSaleStarted = false;
1380     uint256 public PUBLIC_SALE_2_MINT_PRICE = 200000000000000000; // 0.2 ETH
1381 
1382     // Team can emergency start/pause sale
1383     bool public saleStarted = true;
1384 
1385     // Base URI
1386     string private _baseURIextended;
1387 
1388     struct PreviousHolders {
1389         uint256 amtPrePresaleMints;
1390         uint256 amtPrePresaleMinted;
1391         uint256 amtClaimable;
1392         uint256 amtClaimed;
1393     }
1394 
1395     struct WhitelistedUser {
1396         uint256 amtMinted;
1397         bool exists;
1398     }
1399 
1400     mapping(address => PreviousHolders) prevHolders;
1401     mapping(address => WhitelistedUser) whitelistedUsers;
1402 
1403     constructor() ERC721("Magnum", "MAGNUM") {
1404     }
1405  
1406     function batchAddPrevHolders(address[] memory _addresses, uint256 amtPrePresaleMints, uint256 amtClaimable) public onlyOwner {
1407        uint size = _addresses.length;
1408        for (uint256 i = 0; i < size; i++){
1409           prevHolders[_addresses[i]].amtPrePresaleMints = amtPrePresaleMints;
1410           prevHolders[_addresses[i]].amtClaimable = amtClaimable;
1411        }
1412     }
1413 
1414     function batchAddToWhitelist(address[] memory _addresses) public onlyOwner {
1415         uint size = _addresses.length;
1416         for (uint256 i = 0; i < size; i++){
1417             whitelistedUsers[_addresses[i]].amtMinted = 0;
1418             whitelistedUsers[_addresses[i]].exists = true;
1419         }
1420     }
1421 
1422     function _baseURI() internal view virtual override returns (string memory) {
1423         return _baseURIextended;
1424     }
1425 
1426     function setBaseURI(string memory baseURI_) external onlyOwner {
1427         _baseURIextended = baseURI_;
1428     }
1429 
1430     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1431         string memory baseURI = _baseURI();
1432         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1433     }
1434 
1435     function getClaimAmount(address _addr) public view returns (uint256) {
1436         return prevHolders[_addr].amtClaimable;
1437     }
1438 
1439     function getAmountClaimed(address _addr) public view returns (uint256) {
1440         return prevHolders[_addr].amtClaimed;
1441     }
1442 
1443     function getPrePresaleAmount(address _addr) public view returns (uint256) {
1444         return prevHolders[_addr].amtPrePresaleMints;
1445     }
1446 
1447     function getPrePresaleMintedAmount(address _addr) public view returns (uint256) {
1448         return prevHolders[_addr].amtPrePresaleMinted;
1449     }
1450 
1451     function claim(uint256 amountToClaim) public {
1452         require(prevHolders[msg.sender].amtClaimable != 0, "You cannot claim.");
1453 
1454         uint256 maxClaimable = prevHolders[msg.sender].amtClaimable;
1455 
1456         require(claimActive == true, "Claiming is closed.");
1457         require(block.timestamp >= PRE_PRESALE_START_TIME, "Presale has not started.");
1458         require(saleStarted == true, "Sale is not active.");
1459         require(maxClaimable != 0, "Max claimable must be set.");
1460         require(amountToClaim > 0, "Must mint 1.");
1461         require(amountToClaim <= maxClaimable, "Exceeds max mintable.");
1462         require(prevHolders[msg.sender].amtClaimed + amountToClaim <= maxClaimable, "You cannot claim this many.");
1463         require(totalSupply() + amountToClaim <= MAX_SUPPLY, "Exceeds max supply.");
1464 
1465         for (uint256 i = 0; i < amountToClaim; i++) {
1466             uint256 mintIndex = totalSupply();
1467             prevHolders[msg.sender].amtClaimed += 1;
1468             _safeMint(msg.sender, mintIndex);
1469         }
1470     }
1471 
1472     function mintPrePresale(uint256 amountToMint) public payable {
1473         uint256 maxMintable = prevHolders[msg.sender].amtPrePresaleMints;
1474 
1475         require(saleStarted == true, "Sale is not active.");
1476         require(amountToMint > 0, "Must mint 1.");
1477         require(maxMintable > 0, "Must be able to mint more than one.");
1478         require(block.timestamp >= PRE_PRESALE_START_TIME, "Presale has not started.");
1479         require(prevHolders[msg.sender].amtPrePresaleMinted + amountToMint <= maxMintable, "You cannot mint this many.");
1480 
1481         require(PRESALE_MINT_PRICE.mul(amountToMint) == msg.value, "Incorrect Ether value.");
1482 
1483         for (uint256 i = 0; i < amountToMint; i++) {
1484             uint256 mintIndex = totalSupply();
1485             prevHolders[msg.sender].amtPrePresaleMinted += 1;
1486             _safeMint(msg.sender, mintIndex);
1487         }
1488     }
1489 
1490     function mintPresale(uint256 amountToMint) public payable {
1491         require(saleStarted == true, "Sale is not active.");
1492         require(whitelistedUsers[msg.sender].exists == true, "Must be on the whitelist.");
1493         require(amountToMint > 0, "Must mint 1.");
1494         require(amountToMint <= 2, "Exceeds max mintable.");
1495         require(whitelistedUsers[msg.sender].amtMinted + amountToMint <= 2, "You cannot mint this many.");
1496         require(block.timestamp >= PRESALE_START_TIME, "Presale has not started.");
1497         require(firstPublicSaleStarted == false, "Presale has ended.");
1498         require(totalSupply() + amountToMint <= PRESALE_SUPPLY, "Max supply for the presale is 3333.");
1499 
1500         require(PRESALE_MINT_PRICE.mul(amountToMint) == msg.value, "Incorrect Ether value.");
1501 
1502         for (uint256 i = 0; i < amountToMint; i++) {
1503             uint256 mintIndex = totalSupply();
1504             whitelistedUsers[msg.sender].amtMinted += 1;
1505             _safeMint(msg.sender, mintIndex);
1506         }
1507     }
1508 
1509     function mintPublicSale1(uint256 amountToMint) public payable {
1510         require(saleStarted == true, "Sale is not active.");
1511         require(amountToMint > 0, "Must mint 1.");
1512         require(amountToMint <= 10, "Max mint is 10 per transaction.");
1513         require(firstPublicSaleStarted == true, "The first public sale has not started.");
1514         require(secondPublicSaleStarted == false, "You cannot mint during this time.");
1515         require(totalSupply() + amountToMint <= PUBLIC_SALE_1_SUPPLY, "Max supply for this part of the sale is 6666.");
1516 
1517         require(PUBLIC_SALE_1_MINT_PRICE.mul(amountToMint) == msg.value, "Incorrect Ether value.");
1518 
1519         for (uint256 i = 0; i < amountToMint; i++) {
1520             uint256 mintIndex = totalSupply();
1521             _safeMint(msg.sender, mintIndex);
1522         }
1523     }
1524 
1525     function mintPublicSale2(uint256 amountToMint) public payable {
1526         require(saleStarted == true, "Sale is not active.");
1527         require(secondPublicSaleStarted == true, "Sale has not started.");
1528         require(totalSupply() < MAX_SUPPLY, "All NFTs have been minted.");
1529         require(totalSupply() + amountToMint <= MAX_SUPPLY, "Transaction exceeds max supply.");
1530         require(amountToMint > 0, "Must mint 1.");
1531         require(amountToMint <= 10, "Max mint is 10 per transaction.");
1532         
1533         require(PUBLIC_SALE_2_MINT_PRICE.mul(amountToMint) == msg.value, "Incorrect Ether value.");
1534 
1535         for (uint256 i = 0; i < amountToMint; i++) {
1536             uint256 mintIndex = totalSupply();
1537             _safeMint(msg.sender, mintIndex);
1538         }
1539     }
1540 
1541     function flipSaleState() public onlyOwner {
1542         saleStarted = !saleStarted;
1543     }
1544 
1545     function flipClaimState() public onlyOwner {
1546         claimActive = !claimActive;
1547     }
1548 
1549     function flipFirstPublicSaleState() public onlyOwner {
1550         firstPublicSaleStarted = !firstPublicSaleStarted;
1551     }
1552 
1553     function flipSecondPublicSaleState() public onlyOwner {
1554         secondPublicSaleStarted = !secondPublicSaleStarted;
1555     }
1556 
1557     function setSecondPublicSaleMintPrice(uint256 newPrice) public onlyOwner {
1558         PUBLIC_SALE_2_MINT_PRICE = newPrice;
1559     }
1560 
1561     function withdraw() public payable onlyOwner {
1562         require(payable(msg.sender).send(address(this).balance));
1563     }
1564 }