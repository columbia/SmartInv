1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 Hello degen! 
6 
7 It's time for Beanie Giving Back to the community.
8 
9 Mint your part of NFT history. 4269 pieces to collect.
10 
11 First 269 are free to claim, after that it wil cost you 0.02 ETH.
12 
13 But, BEANIE IS GIVNG BACK 20% of all the sales directly from the contract to random minters! 
14 
15 So time to APE in!
16 
17 */
18 
19 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
20 pragma solidity ^0.8.0;
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
42 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
43 pragma solidity ^0.8.0;
44 /**
45  * @dev Required interface of an ERC721 compliant contract.
46  */
47 interface IERC721 is IERC165 {
48     /**
49      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
50      */
51     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
55      */
56     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
57 
58     /**
59      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
60      */
61     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
62 
63     /**
64      * @dev Returns the number of tokens in ``owner``'s account.
65      */
66     function balanceOf(address owner) external view returns (uint256 balance);
67 
68     /**
69      * @dev Returns the owner of the `tokenId` token.
70      *
71      * Requirements:
72      *
73      * - `tokenId` must exist.
74      */
75     function ownerOf(uint256 tokenId) external view returns (address owner);
76 
77     /**
78      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
79      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
80      *
81      * Requirements:
82      *
83      * - `from` cannot be the zero address.
84      * - `to` cannot be the zero address.
85      * - `tokenId` token must exist and be owned by `from`.
86      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
87      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
88      *
89      * Emits a {Transfer} event.
90      */
91     function safeTransferFrom(
92         address from,
93         address to,
94         uint256 tokenId
95     ) external;
96 
97     /**
98      * @dev Transfers `tokenId` token from `from` to `to`.
99      *
100      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must be owned by `from`.
107      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(
112         address from,
113         address to,
114         uint256 tokenId
115     ) external;
116 
117     /**
118      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
119      * The approval is cleared when the token is transferred.
120      *
121      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
122      *
123      * Requirements:
124      *
125      * - The caller must own the token or be an approved operator.
126      * - `tokenId` must exist.
127      *
128      * Emits an {Approval} event.
129      */
130     function approve(address to, uint256 tokenId) external;
131 
132     /**
133      * @dev Returns the account approved for `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function getApproved(uint256 tokenId) external view returns (address operator);
140 
141     /**
142      * @dev Approve or remove `operator` as an operator for the caller.
143      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
144      *
145      * Requirements:
146      *
147      * - The `operator` cannot be the caller.
148      *
149      * Emits an {ApprovalForAll} event.
150      */
151     function setApprovalForAll(address operator, bool _approved) external;
152 
153     /**
154      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
155      *
156      * See {setApprovalForAll}
157      */
158     function isApprovedForAll(address owner, address operator) external view returns (bool);
159 
160     /**
161      * @dev Safely transfers `tokenId` token from `from` to `to`.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must exist and be owned by `from`.
168      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
169      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
170      *
171      * Emits a {Transfer} event.
172      */
173     function safeTransferFrom(
174         address from,
175         address to,
176         uint256 tokenId,
177         bytes calldata data
178     ) external;
179 }
180 
181 
182 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
183 pragma solidity ^0.8.0;
184 /**
185  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
186  * @dev See https://eips.ethereum.org/EIPS/eip-721
187  */
188 interface IERC721Enumerable is IERC721 {
189     /**
190      * @dev Returns the total amount of tokens stored by the contract.
191      */
192     function totalSupply() external view returns (uint256);
193 
194     /**
195      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
196      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
197      */
198     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
199 
200     /**
201      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
202      * Use along with {totalSupply} to enumerate all tokens.
203      */
204     function tokenByIndex(uint256 index) external view returns (uint256);
205 }
206 
207 
208 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
209 pragma solidity ^0.8.0;
210 /**
211  * @dev Implementation of the {IERC165} interface.
212  *
213  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
214  * for the additional interface id that will be supported. For example:
215  *
216  * ```solidity
217  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
218  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
219  * }
220  * ```
221  *
222  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
223  */
224 abstract contract ERC165 is IERC165 {
225     /**
226      * @dev See {IERC165-supportsInterface}.
227      */
228     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
229         return interfaceId == type(IERC165).interfaceId;
230     }
231 }
232 
233 // File: @openzeppelin/contracts/utils/Strings.sol
234 
235 
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev String operations.
241  */
242 library Strings {
243     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
244 
245     /**
246      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
247      */
248     function toString(uint256 value) internal pure returns (string memory) {
249         // Inspired by OraclizeAPI's implementation - MIT licence
250         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
251 
252         if (value == 0) {
253             return "0";
254         }
255         uint256 temp = value;
256         uint256 digits;
257         while (temp != 0) {
258             digits++;
259             temp /= 10;
260         }
261         bytes memory buffer = new bytes(digits);
262         while (value != 0) {
263             digits -= 1;
264             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
265             value /= 10;
266         }
267         return string(buffer);
268     }
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
272      */
273     function toHexString(uint256 value) internal pure returns (string memory) {
274         if (value == 0) {
275             return "0x00";
276         }
277         uint256 temp = value;
278         uint256 length = 0;
279         while (temp != 0) {
280             length++;
281             temp >>= 8;
282         }
283         return toHexString(value, length);
284     }
285 
286     /**
287      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
288      */
289     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
290         bytes memory buffer = new bytes(2 * length + 2);
291         buffer[0] = "0";
292         buffer[1] = "x";
293         for (uint256 i = 2 * length + 1; i > 1; --i) {
294             buffer[i] = _HEX_SYMBOLS[value & 0xf];
295             value >>= 4;
296         }
297         require(value == 0, "Strings: hex length insufficient");
298         return string(buffer);
299     }
300 }
301 
302 // File: @openzeppelin/contracts/utils/Address.sol
303 
304 
305 
306 pragma solidity ^0.8.0;
307 
308 /**
309  * @dev Collection of functions related to the address type
310  */
311 library Address {
312     /**
313      * @dev Returns true if `account` is a contract.
314      *
315      * [IMPORTANT]
316      * ====
317      * It is unsafe to assume that an address for which this function returns
318      * false is an externally-owned account (EOA) and not a contract.
319      *
320      * Among others, `isContract` will return false for the following
321      * types of addresses:
322      *
323      *  - an externally-owned account
324      *  - a contract in construction
325      *  - an address where a contract will be created
326      *  - an address where a contract lived, but was destroyed
327      * ====
328      */
329     function isContract(address account) internal view returns (bool) {
330         // This method relies on extcodesize, which returns 0 for contracts in
331         // construction, since the code is only stored at the end of the
332         // constructor execution.
333 
334         uint256 size;
335         assembly {
336             size := extcodesize(account)
337         }
338         return size > 0;
339     }
340 
341     /**
342      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
343      * `recipient`, forwarding all available gas and reverting on errors.
344      *
345      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
346      * of certain opcodes, possibly making contracts go over the 2300 gas limit
347      * imposed by `transfer`, making them unable to receive funds via
348      * `transfer`. {sendValue} removes this limitation.
349      *
350      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
351      *
352      * IMPORTANT: because control is transferred to `recipient`, care must be
353      * taken to not create reentrancy vulnerabilities. Consider using
354      * {ReentrancyGuard} or the
355      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
356      */
357     function sendValue(address payable recipient, uint256 amount) internal {
358         require(address(this).balance >= amount, "Address: insufficient balance");
359 
360         (bool success, ) = recipient.call{value: amount}("");
361         require(success, "Address: unable to send value, recipient may have reverted");
362     }
363 
364     /**
365      * @dev Performs a Solidity function call using a low level `call`. A
366      * plain `call` is an unsafe replacement for a function call: use this
367      * function instead.
368      *
369      * If `target` reverts with a revert reason, it is bubbled up by this
370      * function (like regular Solidity function calls).
371      *
372      * Returns the raw returned data. To convert to the expected return value,
373      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
374      *
375      * Requirements:
376      *
377      * - `target` must be a contract.
378      * - calling `target` with `data` must not revert.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
383         return functionCall(target, data, "Address: low-level call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
388      * `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, 0, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but also transferring `value` wei to `target`.
403      *
404      * Requirements:
405      *
406      * - the calling contract must have an ETH balance of at least `value`.
407      * - the called Solidity function must be `payable`.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(
412         address target,
413         bytes memory data,
414         uint256 value
415     ) internal returns (bytes memory) {
416         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
421      * with `errorMessage` as a fallback revert reason when `target` reverts.
422      *
423      * _Available since v3.1._
424      */
425     function functionCallWithValue(
426         address target,
427         bytes memory data,
428         uint256 value,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         require(address(this).balance >= value, "Address: insufficient balance for call");
432         require(isContract(target), "Address: call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.call{value: value}(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a static call.
441      *
442      * _Available since v3.3._
443      */
444     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
445         return functionStaticCall(target, data, "Address: low-level static call failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a static call.
451      *
452      * _Available since v3.3._
453      */
454     function functionStaticCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal view returns (bytes memory) {
459         require(isContract(target), "Address: static call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.staticcall(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
467      * but performing a delegate call.
468      *
469      * _Available since v3.4._
470      */
471     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
472         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
477      * but performing a delegate call.
478      *
479      * _Available since v3.4._
480      */
481     function functionDelegateCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal returns (bytes memory) {
486         require(isContract(target), "Address: delegate call to non-contract");
487 
488         (bool success, bytes memory returndata) = target.delegatecall(data);
489         return verifyCallResult(success, returndata, errorMessage);
490     }
491 
492     /**
493      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
494      * revert reason using the provided one.
495      *
496      * _Available since v4.3._
497      */
498     function verifyCallResult(
499         bool success,
500         bytes memory returndata,
501         string memory errorMessage
502     ) internal pure returns (bytes memory) {
503         if (success) {
504             return returndata;
505         } else {
506             // Look for revert reason and bubble it up if present
507             if (returndata.length > 0) {
508                 // The easiest way to bubble the revert reason is using memory via assembly
509 
510                 assembly {
511                     let returndata_size := mload(returndata)
512                     revert(add(32, returndata), returndata_size)
513                 }
514             } else {
515                 revert(errorMessage);
516             }
517         }
518     }
519 }
520 
521 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
522 
523 
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
530  * @dev See https://eips.ethereum.org/EIPS/eip-721
531  */
532 interface IERC721Metadata is IERC721 {
533     /**
534      * @dev Returns the token collection name.
535      */
536     function name() external view returns (string memory);
537 
538     /**
539      * @dev Returns the token collection symbol.
540      */
541     function symbol() external view returns (string memory);
542 
543     /**
544      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
545      */
546     function tokenURI(uint256 tokenId) external view returns (string memory);
547 }
548 
549 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
550 
551 
552 
553 pragma solidity ^0.8.0;
554 
555 /**
556  * @title ERC721 token receiver interface
557  * @dev Interface for any contract that wants to support safeTransfers
558  * from ERC721 asset contracts.
559  */
560 interface IERC721Receiver {
561     /**
562      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
563      * by `operator` from `from`, this function is called.
564      *
565      * It must return its Solidity selector to confirm the token transfer.
566      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
567      *
568      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
569      */
570     function onERC721Received(
571         address operator,
572         address from,
573         uint256 tokenId,
574         bytes calldata data
575     ) external returns (bytes4);
576 }
577 
578 // File: @openzeppelin/contracts/utils/Context.sol
579 pragma solidity ^0.8.0;
580 /**
581  * @dev Provides information about the current execution context, including the
582  * sender of the transaction and its data. While these are generally available
583  * via msg.sender and msg.data, they should not be accessed in such a direct
584  * manner, since when dealing with meta-transactions the account sending and
585  * paying for execution may not be the actual sender (as far as an application
586  * is concerned).
587  *
588  * This contract is only required for intermediate, library-like contracts.
589  */
590 abstract contract Context {
591     function _msgSender() internal view virtual returns (address) {
592         return msg.sender;
593     }
594 
595     function _msgData() internal view virtual returns (bytes calldata) {
596         return msg.data;
597     }
598 }
599 
600 
601 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
602 pragma solidity ^0.8.0;
603 /**
604  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
605  * the Metadata extension, but not including the Enumerable extension, which is available separately as
606  * {ERC721Enumerable}.
607  */
608 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
609     using Address for address;
610     using Strings for uint256;
611 
612     // Token name
613     string private _name;
614 
615     // Token symbol
616     string private _symbol;
617 
618     // Mapping from token ID to owner address
619     mapping(uint256 => address) private _owners;
620 
621     // Mapping owner address to token count
622     mapping(address => uint256) private _balances;
623 
624     // Mapping from token ID to approved address
625     mapping(uint256 => address) private _tokenApprovals;
626 
627     // Mapping from owner to operator approvals
628     mapping(address => mapping(address => bool)) private _operatorApprovals;
629 
630     /**
631      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
632      */
633     constructor(string memory name_, string memory symbol_) {
634         _name = name_;
635         _symbol = symbol_;
636     }
637 
638     /**
639      * @dev See {IERC165-supportsInterface}.
640      */
641     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
642         return
643             interfaceId == type(IERC721).interfaceId ||
644             interfaceId == type(IERC721Metadata).interfaceId ||
645             super.supportsInterface(interfaceId);
646     }
647 
648     /**
649      * @dev See {IERC721-balanceOf}.
650      */
651     function balanceOf(address owner) public view virtual override returns (uint256) {
652         require(owner != address(0), "ERC721: balance query for the zero address");
653         return _balances[owner];
654     }
655 
656     /**
657      * @dev See {IERC721-ownerOf}.
658      */
659     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
660         address owner = _owners[tokenId];
661         require(owner != address(0), "ERC721: owner query for nonexistent token");
662         return owner;
663     }
664 
665     /**
666      * @dev See {IERC721Metadata-name}.
667      */
668     function name() public view virtual override returns (string memory) {
669         return _name;
670     }
671 
672     /**
673      * @dev See {IERC721Metadata-symbol}.
674      */
675     function symbol() public view virtual override returns (string memory) {
676         return _symbol;
677     }
678 
679     /**
680      * @dev See {IERC721Metadata-tokenURI}.
681      */
682     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
683         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
684 
685         string memory baseURI = _baseURI();
686         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
687     }
688 
689     /**
690      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
691      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
692      * by default, can be overriden in child contracts.
693      */
694     function _baseURI() internal view virtual returns (string memory) {
695         return "";
696     }
697 
698     /**
699      * @dev See {IERC721-approve}.
700      */
701     function approve(address to, uint256 tokenId) public virtual override {
702         address owner = ERC721.ownerOf(tokenId);
703         require(to != owner, "ERC721: approval to current owner");
704 
705         require(
706             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
707             "ERC721: approve caller is not owner nor approved for all"
708         );
709 
710         _approve(to, tokenId);
711     }
712 
713     /**
714      * @dev See {IERC721-getApproved}.
715      */
716     function getApproved(uint256 tokenId) public view virtual override returns (address) {
717         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
718 
719         return _tokenApprovals[tokenId];
720     }
721 
722     /**
723      * @dev See {IERC721-setApprovalForAll}.
724      */
725     function setApprovalForAll(address operator, bool approved) public virtual override {
726         require(operator != _msgSender(), "ERC721: approve to caller");
727 
728         _operatorApprovals[_msgSender()][operator] = approved;
729         emit ApprovalForAll(_msgSender(), operator, approved);
730     }
731 
732     /**
733      * @dev See {IERC721-isApprovedForAll}.
734      */
735     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
736         return _operatorApprovals[owner][operator];
737     }
738 
739     /**
740      * @dev See {IERC721-transferFrom}.
741      */
742     function transferFrom(
743         address from,
744         address to,
745         uint256 tokenId
746     ) public virtual override {
747         //solhint-disable-next-line max-line-length
748         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
749 
750         _transfer(from, to, tokenId);
751     }
752 
753     /**
754      * @dev See {IERC721-safeTransferFrom}.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId
760     ) public virtual override {
761         safeTransferFrom(from, to, tokenId, "");
762     }
763 
764     /**
765      * @dev See {IERC721-safeTransferFrom}.
766      */
767     function safeTransferFrom(
768         address from,
769         address to,
770         uint256 tokenId,
771         bytes memory _data
772     ) public virtual override {
773         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
774         _safeTransfer(from, to, tokenId, _data);
775     }
776 
777     /**
778      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
779      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
780      *
781      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
782      *
783      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
784      * implement alternative mechanisms to perform token transfer, such as signature-based.
785      *
786      * Requirements:
787      *
788      * - `from` cannot be the zero address.
789      * - `to` cannot be the zero address.
790      * - `tokenId` token must exist and be owned by `from`.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function _safeTransfer(
796         address from,
797         address to,
798         uint256 tokenId,
799         bytes memory _data
800     ) internal virtual {
801         _transfer(from, to, tokenId);
802         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
803     }
804 
805     /**
806      * @dev Returns whether `tokenId` exists.
807      *
808      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
809      *
810      * Tokens start existing when they are minted (`_mint`),
811      * and stop existing when they are burned (`_burn`).
812      */
813     function _exists(uint256 tokenId) internal view virtual returns (bool) {
814         return _owners[tokenId] != address(0);
815     }
816 
817     /**
818      * @dev Returns whether `spender` is allowed to manage `tokenId`.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must exist.
823      */
824     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
825         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
826         address owner = ERC721.ownerOf(tokenId);
827         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
828     }
829 
830     /**
831      * @dev Safely mints `tokenId` and transfers it to `to`.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must not exist.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _safeMint(address to, uint256 tokenId) internal virtual {
841         _safeMint(to, tokenId, "");
842     }
843 
844     /**
845      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
846      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
847      */
848     function _safeMint(
849         address to,
850         uint256 tokenId,
851         bytes memory _data
852     ) internal virtual {
853         _mint(to, tokenId);
854         require(
855             _checkOnERC721Received(address(0), to, tokenId, _data),
856             "ERC721: transfer to non ERC721Receiver implementer"
857         );
858     }
859 
860     /**
861      * @dev Mints `tokenId` and transfers it to `to`.
862      *
863      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
864      *
865      * Requirements:
866      *
867      * - `tokenId` must not exist.
868      * - `to` cannot be the zero address.
869      *
870      * Emits a {Transfer} event.
871      */
872     function _mint(address to, uint256 tokenId) internal virtual {
873         require(to != address(0), "ERC721: mint to the zero address");
874         require(!_exists(tokenId), "ERC721: token already minted");
875 
876         _beforeTokenTransfer(address(0), to, tokenId);
877 
878         _balances[to] += 1;
879         _owners[tokenId] = to;
880 
881         emit Transfer(address(0), to, tokenId);
882     }
883 
884     /**
885      * @dev Destroys `tokenId`.
886      * The approval is cleared when the token is burned.
887      *
888      * Requirements:
889      *
890      * - `tokenId` must exist.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _burn(uint256 tokenId) internal virtual {
895         address owner = ERC721.ownerOf(tokenId);
896 
897         _beforeTokenTransfer(owner, address(0), tokenId);
898 
899         // Clear approvals
900         _approve(address(0), tokenId);
901 
902         _balances[owner] -= 1;
903         delete _owners[tokenId];
904 
905         emit Transfer(owner, address(0), tokenId);
906     }
907 
908     /**
909      * @dev Transfers `tokenId` from `from` to `to`.
910      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
911      *
912      * Requirements:
913      *
914      * - `to` cannot be the zero address.
915      * - `tokenId` token must be owned by `from`.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _transfer(
920         address from,
921         address to,
922         uint256 tokenId
923     ) internal virtual {
924         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
925         require(to != address(0), "ERC721: transfer to the zero address");
926 
927         _beforeTokenTransfer(from, to, tokenId);
928 
929         // Clear approvals from the previous owner
930         _approve(address(0), tokenId);
931 
932         _balances[from] -= 1;
933         _balances[to] += 1;
934         _owners[tokenId] = to;
935 
936         emit Transfer(from, to, tokenId);
937     }
938 
939     /**
940      * @dev Approve `to` to operate on `tokenId`
941      *
942      * Emits a {Approval} event.
943      */
944     function _approve(address to, uint256 tokenId) internal virtual {
945         _tokenApprovals[tokenId] = to;
946         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
947     }
948 
949     /**
950      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
951      * The call is not executed if the target address is not a contract.
952      *
953      * @param from address representing the previous owner of the given token ID
954      * @param to target address that will receive the tokens
955      * @param tokenId uint256 ID of the token to be transferred
956      * @param _data bytes optional data to send along with the call
957      * @return bool whether the call correctly returned the expected magic value
958      */
959     function _checkOnERC721Received(
960         address from,
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) private returns (bool) {
965         if (to.isContract()) {
966             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
967                 return retval == IERC721Receiver.onERC721Received.selector;
968             } catch (bytes memory reason) {
969                 if (reason.length == 0) {
970                     revert("ERC721: transfer to non ERC721Receiver implementer");
971                 } else {
972                     assembly {
973                         revert(add(32, reason), mload(reason))
974                     }
975                 }
976             }
977         } else {
978             return true;
979         }
980     }
981 
982     /**
983      * @dev Hook that is called before any token transfer. This includes minting
984      * and burning.
985      *
986      * Calling conditions:
987      *
988      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
989      * transferred to `to`.
990      * - When `from` is zero, `tokenId` will be minted for `to`.
991      * - When `to` is zero, ``from``'s `tokenId` will be burned.
992      * - `from` and `to` are never both zero.
993      *
994      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
995      */
996     function _beforeTokenTransfer(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) internal virtual {}
1001 }
1002 
1003 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1004 
1005 
1006 
1007 pragma solidity ^0.8.0;
1008 
1009 
1010 
1011 /**
1012  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1013  * enumerability of all the token ids in the contract as well as all token ids owned by each
1014  * account.
1015  */
1016 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1017     // Mapping from owner to list of owned token IDs
1018     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1019 
1020     // Mapping from token ID to index of the owner tokens list
1021     mapping(uint256 => uint256) private _ownedTokensIndex;
1022 
1023     // Array with all token ids, used for enumeration
1024     uint256[] private _allTokens;
1025 
1026     // Mapping from token id to position in the allTokens array
1027     mapping(uint256 => uint256) private _allTokensIndex;
1028 
1029     /**
1030      * @dev See {IERC165-supportsInterface}.
1031      */
1032     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1033         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1038      */
1039     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1040         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1041         return _ownedTokens[owner][index];
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Enumerable-totalSupply}.
1046      */
1047     function totalSupply() public view virtual override returns (uint256) {
1048         return _allTokens.length;
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Enumerable-tokenByIndex}.
1053      */
1054     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1055         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1056         return _allTokens[index];
1057     }
1058 
1059     /**
1060      * @dev Hook that is called before any token transfer. This includes minting
1061      * and burning.
1062      *
1063      * Calling conditions:
1064      *
1065      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1066      * transferred to `to`.
1067      * - When `from` is zero, `tokenId` will be minted for `to`.
1068      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1069      * - `from` cannot be the zero address.
1070      * - `to` cannot be the zero address.
1071      *
1072      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1073      */
1074     function _beforeTokenTransfer(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) internal virtual override {
1079         super._beforeTokenTransfer(from, to, tokenId);
1080 
1081         if (from == address(0)) {
1082             _addTokenToAllTokensEnumeration(tokenId);
1083         } else if (from != to) {
1084             _removeTokenFromOwnerEnumeration(from, tokenId);
1085         }
1086         if (to == address(0)) {
1087             _removeTokenFromAllTokensEnumeration(tokenId);
1088         } else if (to != from) {
1089             _addTokenToOwnerEnumeration(to, tokenId);
1090         }
1091     }
1092 
1093     /**
1094      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1095      * @param to address representing the new owner of the given token ID
1096      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1097      */
1098     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1099         uint256 length = ERC721.balanceOf(to);
1100         _ownedTokens[to][length] = tokenId;
1101         _ownedTokensIndex[tokenId] = length;
1102     }
1103 
1104     /**
1105      * @dev Private function to add a token to this extension's token tracking data structures.
1106      * @param tokenId uint256 ID of the token to be added to the tokens list
1107      */
1108     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1109         _allTokensIndex[tokenId] = _allTokens.length;
1110         _allTokens.push(tokenId);
1111     }
1112 
1113     /**
1114      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1115      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1116      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1117      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1118      * @param from address representing the previous owner of the given token ID
1119      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1120      */
1121     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1122         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1123         // then delete the last slot (swap and pop).
1124 
1125         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1126         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1127 
1128         // When the token to delete is the last token, the swap operation is unnecessary
1129         if (tokenIndex != lastTokenIndex) {
1130             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1131 
1132             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1133             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1134         }
1135 
1136         // This also deletes the contents at the last position of the array
1137         delete _ownedTokensIndex[tokenId];
1138         delete _ownedTokens[from][lastTokenIndex];
1139     }
1140 
1141     /**
1142      * @dev Private function to remove a token from this extension's token tracking data structures.
1143      * This has O(1) time complexity, but alters the order of the _allTokens array.
1144      * @param tokenId uint256 ID of the token to be removed from the tokens list
1145      */
1146     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1147         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1148         // then delete the last slot (swap and pop).
1149 
1150         uint256 lastTokenIndex = _allTokens.length - 1;
1151         uint256 tokenIndex = _allTokensIndex[tokenId];
1152 
1153         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1154         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1155         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1156         uint256 lastTokenId = _allTokens[lastTokenIndex];
1157 
1158         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1159         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1160 
1161         // This also deletes the contents at the last position of the array
1162         delete _allTokensIndex[tokenId];
1163         _allTokens.pop();
1164     }
1165 }
1166 
1167 
1168 // File: @openzeppelin/contracts/access/Ownable.sol
1169 pragma solidity ^0.8.0;
1170 /**
1171  * @dev Contract module which provides a basic access control mechanism, where
1172  * there is an account (an owner) that can be granted exclusive access to
1173  * specific functions.
1174  *
1175  * By default, the owner account will be the one that deploys the contract. This
1176  * can later be changed with {transferOwnership}.
1177  *
1178  * This module is used through inheritance. It will make available the modifier
1179  * `onlyOwner`, which can be applied to your functions to restrict their use to
1180  * the owner.
1181  */
1182 abstract contract Ownable is Context {
1183     address private _owner;
1184 
1185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1186 
1187     /**
1188      * @dev Initializes the contract setting the deployer as the initial owner.
1189      */
1190     constructor() {
1191         _setOwner(_msgSender());
1192     }
1193 
1194     /**
1195      * @dev Returns the address of the current owner.
1196      */
1197     function owner() public view virtual returns (address) {
1198         return _owner;
1199     }
1200 
1201     /**
1202      * @dev Throws if called by any account other than the owner.
1203      */
1204     modifier onlyOwner() {
1205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1206         _;
1207     }
1208 
1209     /**
1210      * @dev Leaves the contract without owner. It will not be possible to call
1211      * `onlyOwner` functions anymore. Can only be called by the current owner.
1212      *
1213      * NOTE: Renouncing ownership will leave the contract without an owner,
1214      * thereby removing any functionality that is only available to the owner.
1215      */
1216     function renounceOwnership() public virtual onlyOwner {
1217         _setOwner(address(0));
1218     }
1219 
1220     /**
1221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1222      * Can only be called by the current owner.
1223      */
1224     function transferOwnership(address newOwner) public virtual onlyOwner {
1225         require(newOwner != address(0), "Ownable: new owner is the zero address");
1226         _setOwner(newOwner);
1227     }
1228 
1229     function _setOwner(address newOwner) private {
1230         address oldOwner = _owner;
1231         _owner = newOwner;
1232         emit OwnershipTransferred(oldOwner, newOwner);
1233     }
1234 }
1235 
1236 pragma solidity >=0.7.0 <0.9.0;
1237 
1238 contract BeanieGivesBack is ERC721Enumerable, Ownable {
1239   using Strings for uint256;
1240 
1241   string baseURI;
1242   string public baseExtension           = ".json";
1243   uint256 public discountSupply         = 4;
1244   uint256 public costDiscount           = 0 ether;
1245   uint256 public costNormal             = 0.02 ether;
1246   uint256 public maxSupply              = 4269;
1247   bool    public paused                 = false;  
1248 
1249   constructor(
1250     string memory _initBaseURI
1251   ) ERC721("BeanieGivesBack", "BGB") {
1252     setBaseURI(_initBaseURI);
1253   }
1254 
1255   // internal
1256   function _baseURI() internal view virtual override returns (string memory) {
1257     return baseURI;
1258   }
1259 
1260   // public
1261   function mint() public payable {
1262     uint256 supply = totalSupply();
1263     require(!paused, "Contract is paused!");
1264     require(supply + 1 <= maxSupply, "Max supply reached!");
1265     
1266     
1267      if(supply < discountSupply){
1268           require(msg.value >= costDiscount);
1269         }
1270         else{
1271           require(msg.value >= costNormal);
1272         }
1273     
1274     address payable giftAddress = payable(msg.sender);
1275     uint256 giftValue;
1276     
1277     if(supply > 0) {
1278         giftAddress = payable(ownerOf(randomNum(supply, block.timestamp, supply + 1) + 1));
1279         giftValue = supply + 1 == maxSupply ? address(this).balance * 10 / 100 : msg.value * 10 / 100;
1280     }
1281     
1282     _safeMint(msg.sender, supply + 1);
1283 
1284     if(supply > 0) {
1285         (bool success, ) = payable(giftAddress).call{value: giftValue}("");
1286         require(success, "Could not send value!");
1287     }
1288   }
1289 
1290   function walletOfOwner(address _owner)
1291     public
1292     view
1293     returns (uint256[] memory)
1294   {
1295     uint256 ownerTokenCount = balanceOf(_owner);
1296     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1297     for (uint256 i; i < ownerTokenCount; i++) {
1298       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1299     }
1300     return tokenIds;
1301   }
1302   
1303   function randomNum(uint256 _mod, uint256 _seed, uint256 _salt) public view returns(uint256) {
1304       uint256 num = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, _seed, _salt))) % _mod;
1305       return num;
1306   }
1307 
1308   function tokenURI(uint256 tokenId)
1309     public
1310     view
1311     virtual
1312     override
1313     returns (string memory)
1314   {
1315     require(
1316       _exists(tokenId),
1317       "ERC721Metadata: URI query for nonexistent token"
1318     );
1319     
1320     string memory currentBaseURI = _baseURI();
1321     return bytes(currentBaseURI).length > 0
1322         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1323         : "";
1324   }
1325 
1326   //only owner
1327   
1328   function setCost(uint256 _newCost) public onlyOwner() {
1329     costNormal = _newCost;
1330   }
1331 
1332 
1333   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1334     baseURI = _newBaseURI;
1335   }
1336 
1337   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1338     baseExtension = _newBaseExtension;
1339   }
1340 
1341   function pause(bool _state) public onlyOwner {
1342     paused = _state;
1343   }
1344   
1345   function withdraw() public payable onlyOwner {
1346     (bool s, ) = payable(msg.sender).call{value: address(this).balance}("");
1347     require(s);
1348   }
1349 }