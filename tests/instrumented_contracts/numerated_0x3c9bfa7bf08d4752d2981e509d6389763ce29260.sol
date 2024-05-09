1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.6;
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
26 
27 
28 
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
37      */
38     function toString(uint256 value) internal pure returns (string memory) {
39         // Inspired by OraclizeAPI's implementation - MIT licence
40         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
41 
42         if (value == 0) {
43             return "0";
44         }
45         uint256 temp = value;
46         uint256 digits;
47         while (temp != 0) {
48             digits++;
49             temp /= 10;
50         }
51         bytes memory buffer = new bytes(digits);
52         while (value != 0) {
53             digits -= 1;
54             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
55             value /= 10;
56         }
57         return string(buffer);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
62      */
63     function toHexString(uint256 value) internal pure returns (string memory) {
64         if (value == 0) {
65             return "0x00";
66         }
67         uint256 temp = value;
68         uint256 length = 0;
69         while (temp != 0) {
70             length++;
71             temp >>= 8;
72         }
73         return toHexString(value, length);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
78      */
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 }
91 
92 
93 
94 
95 /*
96  * @dev Provides information about the current execution context, including the
97  * sender of the transaction and its data. While these are generally available
98  * via msg.sender and msg.data, they should not be accessed in such a direct
99  * manner, since when dealing with meta-transactions the account sending and
100  * paying for execution may not be the actual sender (as far as an application
101  * is concerned).
102  *
103  * This contract is only required for intermediate, library-like contracts.
104  */
105 abstract contract Context {
106     function _msgSender() internal view virtual returns (address) {
107         return msg.sender;
108     }
109 
110     function _msgData() internal view virtual returns (bytes calldata) {
111         return msg.data;
112     }
113 }
114 
115 
116 
117 
118 
119 
120 /**
121  * @dev Contract module which provides a basic access control mechanism, where
122  * there is an account (an owner) that can be granted exclusive access to
123  * specific functions.
124  *
125  * By default, the owner account will be the one that deploys the contract. This
126  * can later be changed with {transferOwnership}.
127  *
128  * This module is used through inheritance. It will make available the modifier
129  * `onlyOwner`, which can be applied to your functions to restrict their use to
130  * the owner.
131  */
132 abstract contract Ownable is Context {
133     address private _owner;
134 
135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137     /**
138      * @dev Initializes the contract setting the deployer as the initial owner.
139      */
140     constructor() {
141         _transferOwnership(_msgSender());
142     }
143 
144     /**
145      * @dev Returns the address of the current owner.
146      */
147     function owner() public view virtual returns (address) {
148         return _owner;
149     }
150 
151     /**
152      * @dev Throws if called by any account other than the owner.
153      */
154     modifier onlyOwner() {
155         require(owner() == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * NOTE: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public virtual onlyOwner {
167         _transferOwnership(address(0));
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Can only be called by the current owner.
173      */
174     function transferOwnership(address newOwner) public virtual onlyOwner {
175         require(newOwner != address(0), "Ownable: new owner is the zero address");
176         _transferOwnership(newOwner);
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Internal function without access restriction.
182      */
183     function _transferOwnership(address newOwner) internal virtual {
184         address oldOwner = _owner;
185         _owner = newOwner;
186         emit OwnershipTransferred(oldOwner, newOwner);
187     }
188 }
189 
190 
191 
192 
193 
194 
195 
196 
197 
198 
199 
200 /**
201  * @dev Required interface of an ERC721 compliant contract.
202  */
203 interface IERC721 is IERC165 {
204     /**
205      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
206      */
207     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
208 
209     /**
210      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
211      */
212     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
213 
214     /**
215      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
216      */
217     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
218 
219     /**
220      * @dev Returns the number of tokens in ``owner``'s account.
221      */
222     function balanceOf(address owner) external view returns (uint256 balance);
223 
224     /**
225      * @dev Returns the owner of the `tokenId` token.
226      *
227      * Requirements:
228      *
229      * - `tokenId` must exist.
230      */
231     function ownerOf(uint256 tokenId) external view returns (address owner);
232 
233     /**
234      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
235      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
236      *
237      * Requirements:
238      *
239      * - `from` cannot be the zero address.
240      * - `to` cannot be the zero address.
241      * - `tokenId` token must exist and be owned by `from`.
242      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
243      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
244      *
245      * Emits a {Transfer} event.
246      */
247     function safeTransferFrom(
248         address from,
249         address to,
250         uint256 tokenId
251     ) external;
252 
253     /**
254      * @dev Transfers `tokenId` token from `from` to `to`.
255      *
256      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
257      *
258      * Requirements:
259      *
260      * - `from` cannot be the zero address.
261      * - `to` cannot be the zero address.
262      * - `tokenId` token must be owned by `from`.
263      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
264      *
265      * Emits a {Transfer} event.
266      */
267     function transferFrom(
268         address from,
269         address to,
270         uint256 tokenId
271     ) external;
272 
273     /**
274      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
275      * The approval is cleared when the token is transferred.
276      *
277      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
278      *
279      * Requirements:
280      *
281      * - The caller must own the token or be an approved operator.
282      * - `tokenId` must exist.
283      *
284      * Emits an {Approval} event.
285      */
286     function approve(address to, uint256 tokenId) external;
287 
288     /**
289      * @dev Returns the account approved for `tokenId` token.
290      *
291      * Requirements:
292      *
293      * - `tokenId` must exist.
294      */
295     function getApproved(uint256 tokenId) external view returns (address operator);
296 
297     /**
298      * @dev Approve or remove `operator` as an operator for the caller.
299      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
300      *
301      * Requirements:
302      *
303      * - The `operator` cannot be the caller.
304      *
305      * Emits an {ApprovalForAll} event.
306      */
307     function setApprovalForAll(address operator, bool _approved) external;
308 
309     /**
310      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
311      *
312      * See {setApprovalForAll}
313      */
314     function isApprovedForAll(address owner, address operator) external view returns (bool);
315 
316     /**
317      * @dev Safely transfers `tokenId` token from `from` to `to`.
318      *
319      * Requirements:
320      *
321      * - `from` cannot be the zero address.
322      * - `to` cannot be the zero address.
323      * - `tokenId` token must exist and be owned by `from`.
324      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
325      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
326      *
327      * Emits a {Transfer} event.
328      */
329     function safeTransferFrom(
330         address from,
331         address to,
332         uint256 tokenId,
333         bytes calldata data
334     ) external;
335 }
336 
337 
338 
339 
340 
341 /**
342  * @title ERC721 token receiver interface
343  * @dev Interface for any contract that wants to support safeTransfers
344  * from ERC721 asset contracts.
345  */
346 interface IERC721Receiver {
347     /**
348      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
349      * by `operator` from `from`, this function is called.
350      *
351      * It must return its Solidity selector to confirm the token transfer.
352      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
353      *
354      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
355      */
356     function onERC721Received(
357         address operator,
358         address from,
359         uint256 tokenId,
360         bytes calldata data
361     ) external returns (bytes4);
362 }
363 
364 
365 
366 
367 
368 
369 
370 /**
371  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
372  * @dev See https://eips.ethereum.org/EIPS/eip-721
373  */
374 interface IERC721Metadata is IERC721 {
375     /**
376      * @dev Returns the token collection name.
377      */
378     function name() external view returns (string memory);
379 
380     /**
381      * @dev Returns the token collection symbol.
382      */
383     function symbol() external view returns (string memory);
384 
385     /**
386      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
387      */
388     function tokenURI(uint256 tokenId) external view returns (string memory);
389 }
390 
391 
392 
393 
394 
395 /**
396  * @dev Collection of functions related to the address type
397  */
398 library Address {
399     /**
400      * @dev Returns true if `account` is a contract.
401      *
402      * [IMPORTANT]
403      * ====
404      * It is unsafe to assume that an address for which this function returns
405      * false is an externally-owned account (EOA) and not a contract.
406      *
407      * Among others, `isContract` will return false for the following
408      * types of addresses:
409      *
410      *  - an externally-owned account
411      *  - a contract in construction
412      *  - an address where a contract will be created
413      *  - an address where a contract lived, but was destroyed
414      * ====
415      */
416     function isContract(address account) internal view returns (bool) {
417         // This method relies on extcodesize, which returns 0 for contracts in
418         // construction, since the code is only stored at the end of the
419         // constructor execution.
420 
421         uint256 size;
422         assembly {
423             size := extcodesize(account)
424         }
425         return size > 0;
426     }
427 
428     /**
429      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
430      * `recipient`, forwarding all available gas and reverting on errors.
431      *
432      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
433      * of certain opcodes, possibly making contracts go over the 2300 gas limit
434      * imposed by `transfer`, making them unable to receive funds via
435      * `transfer`. {sendValue} removes this limitation.
436      *
437      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
438      *
439      * IMPORTANT: because control is transferred to `recipient`, care must be
440      * taken to not create reentrancy vulnerabilities. Consider using
441      * {ReentrancyGuard} or the
442      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
443      */
444     function sendValue(address payable recipient, uint256 amount) internal {
445         require(address(this).balance >= amount, "Address: insufficient balance");
446 
447         (bool success, ) = recipient.call{value: amount}("");
448         require(success, "Address: unable to send value, recipient may have reverted");
449     }
450 
451     /**
452      * @dev Performs a Solidity function call using a low level `call`. A
453      * plain `call` is an unsafe replacement for a function call: use this
454      * function instead.
455      *
456      * If `target` reverts with a revert reason, it is bubbled up by this
457      * function (like regular Solidity function calls).
458      *
459      * Returns the raw returned data. To convert to the expected return value,
460      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
461      *
462      * Requirements:
463      *
464      * - `target` must be a contract.
465      * - calling `target` with `data` must not revert.
466      *
467      * _Available since v3.1._
468      */
469     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
470         return functionCall(target, data, "Address: low-level call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
475      * `errorMessage` as a fallback revert reason when `target` reverts.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(
480         address target,
481         bytes memory data,
482         string memory errorMessage
483     ) internal returns (bytes memory) {
484         return functionCallWithValue(target, data, 0, errorMessage);
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
489      * but also transferring `value` wei to `target`.
490      *
491      * Requirements:
492      *
493      * - the calling contract must have an ETH balance of at least `value`.
494      * - the called Solidity function must be `payable`.
495      *
496      * _Available since v3.1._
497      */
498     function functionCallWithValue(
499         address target,
500         bytes memory data,
501         uint256 value
502     ) internal returns (bytes memory) {
503         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
508      * with `errorMessage` as a fallback revert reason when `target` reverts.
509      *
510      * _Available since v3.1._
511      */
512     function functionCallWithValue(
513         address target,
514         bytes memory data,
515         uint256 value,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         require(address(this).balance >= value, "Address: insufficient balance for call");
519         require(isContract(target), "Address: call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.call{value: value}(data);
522         return _verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
527      * but performing a static call.
528      *
529      * _Available since v3.3._
530      */
531     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
532         return functionStaticCall(target, data, "Address: low-level static call failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
537      * but performing a static call.
538      *
539      * _Available since v3.3._
540      */
541     function functionStaticCall(
542         address target,
543         bytes memory data,
544         string memory errorMessage
545     ) internal view returns (bytes memory) {
546         require(isContract(target), "Address: static call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.staticcall(data);
549         return _verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but performing a delegate call.
555      *
556      * _Available since v3.4._
557      */
558     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
559         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
564      * but performing a delegate call.
565      *
566      * _Available since v3.4._
567      */
568     function functionDelegateCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal returns (bytes memory) {
573         require(isContract(target), "Address: delegate call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.delegatecall(data);
576         return _verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     function _verifyCallResult(
580         bool success,
581         bytes memory returndata,
582         string memory errorMessage
583     ) private pure returns (bytes memory) {
584         if (success) {
585             return returndata;
586         } else {
587             // Look for revert reason and bubble it up if present
588             if (returndata.length > 0) {
589                 // The easiest way to bubble the revert reason is using memory via assembly
590 
591                 assembly {
592                     let returndata_size := mload(returndata)
593                     revert(add(32, returndata), returndata_size)
594                 }
595             } else {
596                 revert(errorMessage);
597             }
598         }
599     }
600 }
601 
602 
603 
604 
605 
606 
607 
608 
609 
610 /**
611  * @dev Implementation of the {IERC165} interface.
612  *
613  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
614  * for the additional interface id that will be supported. For example:
615  *
616  * ```solidity
617  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
618  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
619  * }
620  * ```
621  *
622  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
623  */
624 abstract contract ERC165 is IERC165 {
625     /**
626      * @dev See {IERC165-supportsInterface}.
627      */
628     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
629         return interfaceId == type(IERC165).interfaceId;
630     }
631 }
632 
633 
634 /**
635  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
636  * the Metadata extension, but not including the Enumerable extension, which is available separately as
637  * {ERC721Enumerable}.
638  */
639 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
640     using Address for address;
641     using Strings for uint256;
642 
643     // Token name
644     string private _name;
645 
646     // Token symbol
647     string private _symbol;
648 
649     // Mapping from token ID to owner address
650     mapping(uint256 => address) private _owners;
651 
652     // Mapping owner address to token count
653     mapping(address => uint256) private _balances;
654 
655     // Mapping from token ID to approved address
656     mapping(uint256 => address) private _tokenApprovals;
657 
658     // Mapping from owner to operator approvals
659     mapping(address => mapping(address => bool)) private _operatorApprovals;
660 
661     /**
662      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
663      */
664     constructor(string memory name_, string memory symbol_) {
665         _name = name_;
666         _symbol = symbol_;
667     }
668 
669     /**
670      * @dev See {IERC165-supportsInterface}.
671      */
672     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
673         return
674             interfaceId == type(IERC721).interfaceId ||
675             interfaceId == type(IERC721Metadata).interfaceId ||
676             super.supportsInterface(interfaceId);
677     }
678 
679     /**
680      * @dev See {IERC721-balanceOf}.
681      */
682     function balanceOf(address owner) public view virtual override returns (uint256) {
683         require(owner != address(0), "ERC721: balance query for the zero address");
684         return _balances[owner];
685     }
686 
687     /**
688      * @dev See {IERC721-ownerOf}.
689      */
690     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
691         address owner = _owners[tokenId];
692         require(owner != address(0), "ERC721: owner query for nonexistent token");
693         return owner;
694     }
695 
696     /**
697      * @dev See {IERC721Metadata-name}.
698      */
699     function name() public view virtual override returns (string memory) {
700         return _name;
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-symbol}.
705      */
706     function symbol() public view virtual override returns (string memory) {
707         return _symbol;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-tokenURI}.
712      */
713     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
714         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
715 
716         string memory baseURI = _baseURI();
717         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
718     }
719 
720     /**
721      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
722      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
723      * by default, can be overriden in child contracts.
724      */
725     function _baseURI() internal view virtual returns (string memory) {
726         return "";
727     }
728 
729     /**
730      * @dev See {IERC721-approve}.
731      */
732     function approve(address to, uint256 tokenId) public virtual override {
733         address owner = ERC721.ownerOf(tokenId);
734         require(to != owner, "ERC721: approval to current owner");
735 
736         require(
737             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
738             "ERC721: approve caller is not owner nor approved for all"
739         );
740 
741         _approve(to, tokenId);
742     }
743 
744     /**
745      * @dev See {IERC721-getApproved}.
746      */
747     function getApproved(uint256 tokenId) public view virtual override returns (address) {
748         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
749 
750         return _tokenApprovals[tokenId];
751     }
752 
753     /**
754      * @dev See {IERC721-setApprovalForAll}.
755      */
756     function setApprovalForAll(address operator, bool approved) public virtual override {
757         require(operator != _msgSender(), "ERC721: approve to caller");
758 
759         _operatorApprovals[_msgSender()][operator] = approved;
760         emit ApprovalForAll(_msgSender(), operator, approved);
761     }
762 
763     /**
764      * @dev See {IERC721-isApprovedForAll}.
765      */
766     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
767         return _operatorApprovals[owner][operator];
768     }
769 
770     /**
771      * @dev See {IERC721-transferFrom}.
772      */
773     function transferFrom(
774         address from,
775         address to,
776         uint256 tokenId
777     ) public virtual override {
778         //solhint-disable-next-line max-line-length
779         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
780 
781         _transfer(from, to, tokenId);
782     }
783 
784     /**
785      * @dev See {IERC721-safeTransferFrom}.
786      */
787     function safeTransferFrom(
788         address from,
789         address to,
790         uint256 tokenId
791     ) public virtual override {
792         safeTransferFrom(from, to, tokenId, "");
793     }
794 
795     /**
796      * @dev See {IERC721-safeTransferFrom}.
797      */
798     function safeTransferFrom(
799         address from,
800         address to,
801         uint256 tokenId,
802         bytes memory _data
803     ) public virtual override {
804         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
805         _safeTransfer(from, to, tokenId, _data);
806     }
807 
808     /**
809      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
810      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
811      *
812      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
813      *
814      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
815      * implement alternative mechanisms to perform token transfer, such as signature-based.
816      *
817      * Requirements:
818      *
819      * - `from` cannot be the zero address.
820      * - `to` cannot be the zero address.
821      * - `tokenId` token must exist and be owned by `from`.
822      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _safeTransfer(
827         address from,
828         address to,
829         uint256 tokenId,
830         bytes memory _data
831     ) internal virtual {
832         _transfer(from, to, tokenId);
833         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
834     }
835 
836     /**
837      * @dev Returns whether `tokenId` exists.
838      *
839      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
840      *
841      * Tokens start existing when they are minted (`_mint`),
842      * and stop existing when they are burned (`_burn`).
843      */
844     function _exists(uint256 tokenId) internal view virtual returns (bool) {
845         return _owners[tokenId] != address(0);
846     }
847 
848     /**
849      * @dev Returns whether `spender` is allowed to manage `tokenId`.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      */
855     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
856         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
857         address owner = ERC721.ownerOf(tokenId);
858         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
859     }
860 
861     /**
862      * @dev Safely mints `tokenId` and transfers it to `to`.
863      *
864      * Requirements:
865      *
866      * - `tokenId` must not exist.
867      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
868      *
869      * Emits a {Transfer} event.
870      */
871     function _safeMint(address to, uint256 tokenId) internal virtual {
872         _safeMint(to, tokenId, "");
873     }
874 
875     /**
876      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
877      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
878      */
879     function _safeMint(
880         address to,
881         uint256 tokenId,
882         bytes memory _data
883     ) internal virtual {
884         _mint(to, tokenId);
885         require(
886             _checkOnERC721Received(address(0), to, tokenId, _data),
887             "ERC721: transfer to non ERC721Receiver implementer"
888         );
889     }
890 
891     /**
892      * @dev Mints `tokenId` and transfers it to `to`.
893      *
894      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
895      *
896      * Requirements:
897      *
898      * - `tokenId` must not exist.
899      * - `to` cannot be the zero address.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _mint(address to, uint256 tokenId) internal virtual {
904         require(to != address(0), "ERC721: mint to the zero address");
905         require(!_exists(tokenId), "ERC721: token already minted");
906 
907         _beforeTokenTransfer(address(0), to, tokenId);
908 
909         _balances[to] += 1;
910         _owners[tokenId] = to;
911 
912         emit Transfer(address(0), to, tokenId);
913     }
914 
915     /**
916      * @dev Destroys `tokenId`.
917      * The approval is cleared when the token is burned.
918      *
919      * Requirements:
920      *
921      * - `tokenId` must exist.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _burn(uint256 tokenId) internal virtual {
926         address owner = ERC721.ownerOf(tokenId);
927 
928         _beforeTokenTransfer(owner, address(0), tokenId);
929 
930         // Clear approvals
931         _approve(address(0), tokenId);
932 
933         _balances[owner] -= 1;
934         delete _owners[tokenId];
935 
936         emit Transfer(owner, address(0), tokenId);
937     }
938 
939     /**
940      * @dev Transfers `tokenId` from `from` to `to`.
941      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
942      *
943      * Requirements:
944      *
945      * - `to` cannot be the zero address.
946      * - `tokenId` token must be owned by `from`.
947      *
948      * Emits a {Transfer} event.
949      */
950     function _transfer(
951         address from,
952         address to,
953         uint256 tokenId
954     ) internal virtual {
955         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
956         require(to != address(0), "ERC721: transfer to the zero address");
957 
958         _beforeTokenTransfer(from, to, tokenId);
959 
960         // Clear approvals from the previous owner
961         _approve(address(0), tokenId);
962 
963         _balances[from] -= 1;
964         _balances[to] += 1;
965         _owners[tokenId] = to;
966 
967         emit Transfer(from, to, tokenId);
968     }
969 
970     /**
971      * @dev Approve `to` to operate on `tokenId`
972      *
973      * Emits a {Approval} event.
974      */
975     function _approve(address to, uint256 tokenId) internal virtual {
976         _tokenApprovals[tokenId] = to;
977         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
978     }
979 
980     /**
981      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
982      * The call is not executed if the target address is not a contract.
983      *
984      * @param from address representing the previous owner of the given token ID
985      * @param to target address that will receive the tokens
986      * @param tokenId uint256 ID of the token to be transferred
987      * @param _data bytes optional data to send along with the call
988      * @return bool whether the call correctly returned the expected magic value
989      */
990     function _checkOnERC721Received(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) private returns (bool) {
996         if (to.isContract()) {
997             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
998                 return retval == IERC721Receiver(to).onERC721Received.selector;
999             } catch (bytes memory reason) {
1000                 if (reason.length == 0) {
1001                     revert("ERC721: transfer to non ERC721Receiver implementer");
1002                 } else {
1003                     assembly {
1004                         revert(add(32, reason), mload(reason))
1005                     }
1006                 }
1007             }
1008         } else {
1009             return true;
1010         }
1011     }
1012 
1013     /**
1014      * @dev Hook that is called before any token transfer. This includes minting
1015      * and burning.
1016      *
1017      * Calling conditions:
1018      *
1019      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1020      * transferred to `to`.
1021      * - When `from` is zero, `tokenId` will be minted for `to`.
1022      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1023      * - `from` and `to` are never both zero.
1024      *
1025      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1026      */
1027     function _beforeTokenTransfer(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) internal virtual {}
1032 }
1033 
1034 
1035 
1036 
1037 
1038 //  __  __      _           _____ _      _  __      _                _     
1039 // |  \/  |    | |         / ____(_)    | |/ _|    (_)              | |    
1040 // | \  / | ___| |_ __ _  | |  __ _ _ __| | |_ _ __ _  ___ _ __   __| |___ 
1041 // | |\/| |/ _ \ __/ _` | | | |_ | | '__| |  _| '__| |/ _ \ '_ \ / _` / __|
1042 // | |  | |  __/ || (_| | | |__| | | |  | | | | |  | |  __/ | | | (_| \__ \
1043 // |_|  |_|\___|\__\__,_|  \_____|_|_|  |_|_| |_|  |_|\___|_| |_|\__,_|___/                                                                         
1044 //
1045 // Meta Girlfriends / 2021 
1046 
1047 
1048 
1049 
1050 
1051 
1052 contract MetaGirlfriends is ERC721, Ownable {
1053     using Strings for uint;
1054 
1055     event PriceChanged(uint256 newPrice);
1056     event BaseURIChanged(string newUriPrefix, string newUriSuffix);
1057     event TokenCombined( uint256 tokenId, uint256 newtraits, uint256 parent1, uint256 parent2);
1058 
1059     uint public price = 0.08 ether;
1060     uint public constant maxSupply = 10000;
1061     uint public constant giveAwayCount = 200;    
1062     bool public mintingEnabled = true;
1063     bool public whitelistEnabled = true;
1064     uint public buyLimit = 10;
1065     uint256 public giveAwaysReserved;
1066     uint256 public tokensReserved;
1067     uint256 public tokensMinted;
1068     uint256 public tokensBurnt;
1069 
1070     mapping(address => uint256) public reservedCount;
1071     mapping(uint256 => uint16) private levels;
1072 
1073     bool public combineEnabled;
1074 
1075     string private _baseURIPrefix = "https://metagirlfriends.com/api/metadata/";
1076     string private _baseURISuffix = "";
1077     address private signerAddress = 0x77bFCca6F45B07047a34A31885Af86F11033665B;
1078     address private treasury = 0xAb22AD2eDF9774C4aAe550165397Ebc6050a1f4E;
1079     address private dev1 = 0xDB4AAC095f709a62Ec24479404fAE45D24ade34b;
1080     address private dev2 = 0x353d285681458962eD5830672cbDeFcBB9b888A7;
1081 
1082     constructor () ERC721('Meta Girlfriends', 'MG') {
1083     }
1084 
1085     function totalSupply() external view returns (uint256){
1086         return tokensMinted - tokensBurnt;
1087     }
1088 
1089     // ========================== Girlfriends   ==============================    
1090 
1091     function getLevel(uint256 tokenId) external view returns (uint16){
1092         require(_exists(tokenId), 'MG: non existent tokenId');        
1093         return levels[tokenId];
1094     }
1095 
1096     function _hashCombine(address sender, uint256 gfId1, uint256 gfId2, uint256 newId, uint256 newtraits, string memory nonce) internal pure returns(bytes32) {
1097         return keccak256(abi.encodePacked( "\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(sender, gfId1, gfId2, newId, newtraits, nonce))));         
1098     }
1099 
1100     function combineGirlfriends(uint256 gfId1, uint256 gfId2, uint256 newId, uint256 newtraits, uint8 v, bytes32 r, bytes32 s, string memory nonce) external {
1101         require(combineEnabled, "MG: Combining GirlFriends is not enabled");
1102         require( ownerOf(gfId1) == _msgSender() && ownerOf(gfId2) == _msgSender(), "MG: Must own these GirlFriends");
1103 
1104         require(gfId1 == newId || gfId2 == newId, "MG: Invalid ID");
1105 
1106         require(signerAddress == ecrecover( _hashCombine( _msgSender(), gfId1, gfId2, newId, newtraits, nonce) , v, r, s), "MG: invalid hash or signature");
1107 
1108         levels[newId] = levels[gfId1] > levels[gfId2] ? levels[gfId1] + 1 : levels[gfId2] + 1;
1109 
1110         emit TokenCombined( newId, newtraits, gfId1, gfId2 );
1111 
1112         _burn( (newId == gfId1)? gfId2: gfId1 );
1113         tokensBurnt++;
1114     }  
1115 
1116     // ========================== Minting ==============================
1117 
1118     function _mintQuantity(uint256 quantity) internal {
1119         for (uint i = 0; i < quantity; i++) {
1120             levels[tokensMinted+i+1]=1;
1121             _safeMint(_msgSender(), tokensMinted+i+1);
1122         }
1123         tokensMinted += quantity;
1124     }
1125 
1126     // owner can mint up to giveAwayCount tokens for giveaways
1127     function mintForGiveaways(uint256 quantity) external onlyOwner {
1128         require(quantity > 0, "MG: Invalid quantity");
1129         require(tokensMinted+quantity <= maxSupply - tokensReserved, "MG: Max supply exceeded");
1130         require(giveAwaysReserved+quantity <= giveAwayCount, "MG: givaway count exceeded");
1131         giveAwaysReserved += quantity;            
1132 
1133         _mintQuantity(quantity);
1134     }
1135 
1136     function _mint(uint256 quantity) internal {
1137         require(quantity > 0, "MG: Invalid quantity");        
1138 
1139         require(tokensMinted+quantity <= maxSupply - tokensReserved, "MG: Max supply exceeded");
1140         require(quantity <= buyLimit, "MG: Buy limit per txn exceeded");
1141         require(price*quantity == msg.value, "MG: invalid price");
1142 
1143         // No eth stays on contract, they go directly to treasury
1144         payable(treasury).transfer(msg.value);
1145 
1146         _mintQuantity(quantity);
1147     }  
1148 
1149     function _hashMaxCount(address sender, uint8 maxCount, string memory nonce) internal pure returns(bytes32) {
1150         return keccak256(abi.encodePacked( "\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(sender, maxCount, nonce))));         
1151     }
1152 
1153     function presaleMint( uint256 quantity, uint8 v, bytes32 r, bytes32 s, uint8 maxCount, string memory nonce) external payable {
1154 
1155         require(mintingEnabled && whitelistEnabled, "MG: Presale minting disabled"); 
1156 
1157         // verify ECDSA signature for parameters maxCount
1158         require(signerAddress == ecrecover( _hashMaxCount( _msgSender(), maxCount, nonce) , v, r, s), "MG: invalid hash or signature");
1159         require(maxCount <= 10, "MG: maxCount must be <= 10");
1160 
1161         require( balanceOf(_msgSender())+quantity <= uint256(maxCount), "MG: White list count exceeded");
1162         _mint(quantity);
1163     }
1164 
1165     function publicMint(uint256 quantity) external payable {
1166         require(mintingEnabled && !whitelistEnabled, "MG: Public minting disabled"); 
1167         // Prevent minting from smart contract
1168         require(_msgSender() == tx.origin, "MG: not EOA");
1169         _mint(quantity);
1170     }  
1171 
1172     function reserve(uint256 quantity) external payable {
1173         require(mintingEnabled && !whitelistEnabled, "MG: Public minting disabled"); 
1174         require(quantity > 0, "MG: Invalid quantity");
1175 
1176         require(tokensMinted+quantity <= maxSupply - tokensReserved, "MG: Max supply exceeded");
1177         require(reservedCount[_msgSender()]+quantity <= buyLimit, "MG: Maximum reservations exceeded");        
1178         require(price*quantity == msg.value, "MG: invalid price");
1179 
1180         // Prevent minting from smart contract
1181         require(_msgSender() == tx.origin, "MG: not EOA");
1182 
1183         // No eth stays on contract, they go directly to treasury
1184         payable(treasury).transfer(msg.value);        
1185 
1186         tokensReserved += quantity;
1187         reservedCount[_msgSender()] += uint16(quantity);
1188     }
1189 
1190 
1191     function claim() external {
1192         require(reservedCount[_msgSender()]>0, "MG: Nothing to claim");
1193 
1194         _mintQuantity(reservedCount[_msgSender()]);
1195         tokensReserved -= reservedCount[_msgSender()];
1196         reservedCount[_msgSender()] = 0;
1197     }
1198 
1199 
1200     // ========================== Other ==============================
1201 
1202     function withdraw() external onlyOwner{
1203         payable(_msgSender()).transfer(address(this).balance);
1204     }
1205 
1206     /*
1207     * @dev Gives access to dev or owner only
1208     */
1209     modifier devOrOwner() {
1210         _devOrOwner();
1211         _;
1212     }
1213 
1214     function _devOrOwner() internal view {
1215         require( (owner()==_msgSender())||(dev1==_msgSender())||(dev2==_msgSender()), "MG: Signer is not dev nor owner");
1216     }
1217 
1218     function setDevs(address newDev1, address newDev2) external onlyOwner{
1219         dev1 = newDev1;
1220         dev2 = newDev2;
1221     } 
1222 
1223     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1224         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1225         return bytes(_baseURIPrefix).length > 0 ? string(abi.encodePacked(_baseURIPrefix, tokenId.toString(), _baseURISuffix)) : "";
1226     }
1227 
1228     function setBaseURI(string memory newUriPrefix, string memory newUriSuffix) external devOrOwner{
1229         _baseURIPrefix = newUriPrefix;
1230         _baseURISuffix = newUriSuffix;
1231         emit BaseURIChanged(newUriPrefix, newUriSuffix);
1232     }
1233 
1234     function toggleWhitelist() external devOrOwner{
1235         whitelistEnabled = !whitelistEnabled;
1236     }  
1237 
1238     function setPrice(uint256 newPrice) external devOrOwner{
1239         price = newPrice;
1240         emit PriceChanged(newPrice);
1241     } 
1242 
1243     function setBuyLimit(uint256 newBuyLimit) external devOrOwner{
1244         buyLimit = newBuyLimit;
1245     }
1246 
1247     function setSigner(address newSigner) external devOrOwner{
1248         signerAddress = newSigner;
1249     }
1250 
1251     function toggleMinting() external devOrOwner{
1252         mintingEnabled = !mintingEnabled;
1253     }
1254 
1255     function toggleCombining() external devOrOwner{
1256         combineEnabled = !combineEnabled;
1257     } 
1258 }