1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 
28 
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor() {
51         _setOwner(_msgSender());
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view virtual returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(owner() == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Leaves the contract without owner. It will not be possible to call
71      * `onlyOwner` functions anymore. Can only be called by the current owner.
72      *
73      * NOTE: Renouncing ownership will leave the contract without an owner,
74      * thereby removing any functionality that is only available to the owner.
75      */
76     function renounceOwnership() public virtual onlyOwner {
77         _setOwner(address(0));
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         _setOwner(newOwner);
87     }
88 
89     function _setOwner(address newOwner) private {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 
97 
98 /**
99  * @dev Interface of the ERC165 standard, as defined in the
100  * https://eips.ethereum.org/EIPS/eip-165[EIP].
101  *
102  * Implementers can declare support of contract interfaces, which can then be
103  * queried by others ({ERC165Checker}).
104  *
105  * For an implementation, see {ERC165}.
106  */
107 interface IERC165 {
108     /**
109      * @dev Returns true if this contract implements the interface defined by
110      * `interfaceId`. See the corresponding
111      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
112      * to learn more about how these ids are created.
113      *
114      * This function call must use less than 30 000 gas.
115      */
116     function supportsInterface(bytes4 interfaceId) external view returns (bool);
117 }
118 
119 
120 
121 
122 
123 /**
124  * @dev Required interface of an ERC721 compliant contract.
125  */
126 interface IERC721 is IERC165 {
127     /**
128      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
134      */
135     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
139      */
140     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
141 
142     /**
143      * @dev Returns the number of tokens in ``owner``'s account.
144      */
145     function balanceOf(address owner) external view returns (uint256 balance);
146 
147     /**
148      * @dev Returns the owner of the `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function ownerOf(uint256 tokenId) external view returns (address owner);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
158      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId
174     ) external;
175 
176     /**
177      * @dev Transfers `tokenId` token from `from` to `to`.
178      *
179      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must be owned by `from`.
186      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
198      * The approval is cleared when the token is transferred.
199      *
200      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
201      *
202      * Requirements:
203      *
204      * - The caller must own the token or be an approved operator.
205      * - `tokenId` must exist.
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address to, uint256 tokenId) external;
210 
211     /**
212      * @dev Returns the account approved for `tokenId` token.
213      *
214      * Requirements:
215      *
216      * - `tokenId` must exist.
217      */
218     function getApproved(uint256 tokenId) external view returns (address operator);
219 
220     /**
221      * @dev Approve or remove `operator` as an operator for the caller.
222      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
223      *
224      * Requirements:
225      *
226      * - The `operator` cannot be the caller.
227      *
228      * Emits an {ApprovalForAll} event.
229      */
230     function setApprovalForAll(address operator, bool _approved) external;
231 
232     /**
233      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
234      *
235      * See {setApprovalForAll}
236      */
237     function isApprovedForAll(address owner, address operator) external view returns (bool);
238 
239     /**
240      * @dev Safely transfers `tokenId` token from `from` to `to`.
241      *
242      * Requirements:
243      *
244      * - `from` cannot be the zero address.
245      * - `to` cannot be the zero address.
246      * - `tokenId` token must exist and be owned by `from`.
247      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
248      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
249      *
250      * Emits a {Transfer} event.
251      */
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 tokenId,
256         bytes calldata data
257     ) external;
258 }
259 
260 
261 
262 /**
263  * @title ERC721 token receiver interface
264  * @dev Interface for any contract that wants to support safeTransfers
265  * from ERC721 asset contracts.
266  */
267 interface IERC721Receiver {
268     /**
269      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
270      * by `operator` from `from`, this function is called.
271      *
272      * It must return its Solidity selector to confirm the token transfer.
273      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
274      *
275      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
276      */
277     function onERC721Received(
278         address operator,
279         address from,
280         uint256 tokenId,
281         bytes calldata data
282     ) external returns (bytes4);
283 }
284 
285 
286 
287 
288 
289 /**
290  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
291  * @dev See https://eips.ethereum.org/EIPS/eip-721
292  */
293 interface IERC721Metadata is IERC721 {
294     /**
295      * @dev Returns the token collection name.
296      */
297     function name() external view returns (string memory);
298 
299     /**
300      * @dev Returns the token collection symbol.
301      */
302     function symbol() external view returns (string memory);
303 
304     /**
305      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
306      */
307     function tokenURI(uint256 tokenId) external view returns (string memory);
308 }
309 
310 
311 
312 /**
313  * @dev Collection of functions related to the address type
314  */
315 library Address {
316     /**
317      * @dev Returns true if `account` is a contract.
318      *
319      * [IMPORTANT]
320      * ====
321      * It is unsafe to assume that an address for which this function returns
322      * false is an externally-owned account (EOA) and not a contract.
323      *
324      * Among others, `isContract` will return false for the following
325      * types of addresses:
326      *
327      *  - an externally-owned account
328      *  - a contract in construction
329      *  - an address where a contract will be created
330      *  - an address where a contract lived, but was destroyed
331      * ====
332      */
333     function isContract(address account) internal view returns (bool) {
334         // This method relies on extcodesize, which returns 0 for contracts in
335         // construction, since the code is only stored at the end of the
336         // constructor execution.
337 
338         uint256 size;
339         assembly {
340             size := extcodesize(account)
341         }
342         return size > 0;
343     }
344 
345     /**
346      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
347      * `recipient`, forwarding all available gas and reverting on errors.
348      *
349      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
350      * of certain opcodes, possibly making contracts go over the 2300 gas limit
351      * imposed by `transfer`, making them unable to receive funds via
352      * `transfer`. {sendValue} removes this limitation.
353      *
354      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
355      *
356      * IMPORTANT: because control is transferred to `recipient`, care must be
357      * taken to not create reentrancy vulnerabilities. Consider using
358      * {ReentrancyGuard} or the
359      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
360      */
361     function sendValue(address payable recipient, uint256 amount) internal {
362         require(address(this).balance >= amount, "Address: insufficient balance");
363 
364         (bool success, ) = recipient.call{value: amount}("");
365         require(success, "Address: unable to send value, recipient may have reverted");
366     }
367 
368     /**
369      * @dev Performs a Solidity function call using a low level `call`. A
370      * plain `call` is an unsafe replacement for a function call: use this
371      * function instead.
372      *
373      * If `target` reverts with a revert reason, it is bubbled up by this
374      * function (like regular Solidity function calls).
375      *
376      * Returns the raw returned data. To convert to the expected return value,
377      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
378      *
379      * Requirements:
380      *
381      * - `target` must be a contract.
382      * - calling `target` with `data` must not revert.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
387         return functionCall(target, data, "Address: low-level call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
392      * `errorMessage` as a fallback revert reason when `target` reverts.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, 0, errorMessage);
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
406      * but also transferring `value` wei to `target`.
407      *
408      * Requirements:
409      *
410      * - the calling contract must have an ETH balance of at least `value`.
411      * - the called Solidity function must be `payable`.
412      *
413      * _Available since v3.1._
414      */
415     function functionCallWithValue(
416         address target,
417         bytes memory data,
418         uint256 value
419     ) internal returns (bytes memory) {
420         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
425      * with `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCallWithValue(
430         address target,
431         bytes memory data,
432         uint256 value,
433         string memory errorMessage
434     ) internal returns (bytes memory) {
435         require(address(this).balance >= value, "Address: insufficient balance for call");
436         require(isContract(target), "Address: call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.call{value: value}(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a static call.
445      *
446      * _Available since v3.3._
447      */
448     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
449         return functionStaticCall(target, data, "Address: low-level static call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a static call.
455      *
456      * _Available since v3.3._
457      */
458     function functionStaticCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal view returns (bytes memory) {
463         require(isContract(target), "Address: static call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.staticcall(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a delegate call.
472      *
473      * _Available since v3.4._
474      */
475     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
476         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a delegate call.
482      *
483      * _Available since v3.4._
484      */
485     function functionDelegateCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal returns (bytes memory) {
490         require(isContract(target), "Address: delegate call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.delegatecall(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
498      * revert reason using the provided one.
499      *
500      * _Available since v4.3._
501      */
502     function verifyCallResult(
503         bool success,
504         bytes memory returndata,
505         string memory errorMessage
506     ) internal pure returns (bytes memory) {
507         if (success) {
508             return returndata;
509         } else {
510             // Look for revert reason and bubble it up if present
511             if (returndata.length > 0) {
512                 // The easiest way to bubble the revert reason is using memory via assembly
513 
514                 assembly {
515                     let returndata_size := mload(returndata)
516                     revert(add(32, returndata), returndata_size)
517                 }
518             } else {
519                 revert(errorMessage);
520             }
521         }
522     }
523 }
524 
525 
526 
527 /**
528  * @dev String operations.
529  */
530 library Strings {
531     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
532 
533     /**
534      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
535      */
536     function toString(uint256 value) internal pure returns (string memory) {
537         // Inspired by OraclizeAPI's implementation - MIT licence
538         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
539 
540         if (value == 0) {
541             return "0";
542         }
543         uint256 temp = value;
544         uint256 digits;
545         while (temp != 0) {
546             digits++;
547             temp /= 10;
548         }
549         bytes memory buffer = new bytes(digits);
550         while (value != 0) {
551             digits -= 1;
552             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
553             value /= 10;
554         }
555         return string(buffer);
556     }
557 
558     /**
559      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
560      */
561     function toHexString(uint256 value) internal pure returns (string memory) {
562         if (value == 0) {
563             return "0x00";
564         }
565         uint256 temp = value;
566         uint256 length = 0;
567         while (temp != 0) {
568             length++;
569             temp >>= 8;
570         }
571         return toHexString(value, length);
572     }
573 
574     /**
575      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
576      */
577     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
578         bytes memory buffer = new bytes(2 * length + 2);
579         buffer[0] = "0";
580         buffer[1] = "x";
581         for (uint256 i = 2 * length + 1; i > 1; --i) {
582             buffer[i] = _HEX_SYMBOLS[value & 0xf];
583             value >>= 4;
584         }
585         require(value == 0, "Strings: hex length insufficient");
586         return string(buffer);
587     }
588 }
589 
590 
591 
592 
593 
594 /**
595  * @dev Implementation of the {IERC165} interface.
596  *
597  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
598  * for the additional interface id that will be supported. For example:
599  *
600  * ```solidity
601  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
602  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
603  * }
604  * ```
605  *
606  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
607  */
608 abstract contract ERC165 is IERC165 {
609     /**
610      * @dev See {IERC165-supportsInterface}.
611      */
612     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
613         return interfaceId == type(IERC165).interfaceId;
614     }
615 }
616 
617 
618 
619 
620 
621 
622 
623 
624 
625 
626 
627 /**
628  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
629  * the Metadata extension, but not including the Enumerable extension, which is available separately as
630  * {ERC721Enumerable}.
631  */
632 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
633     using Address for address;
634     using Strings for uint256;
635 
636     // Token name
637     string private _name;
638 
639     // Token symbol
640     string private _symbol;
641 
642     // Mapping from token ID to owner address
643     mapping(uint256 => address) private _owners;
644 
645     // Mapping owner address to token count
646     mapping(address => uint256) private _balances;
647 
648     // Mapping from token ID to approved address
649     mapping(uint256 => address) private _tokenApprovals;
650 
651     // Mapping from owner to operator approvals
652     mapping(address => mapping(address => bool)) private _operatorApprovals;
653 
654     /**
655      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
656      */
657     constructor(string memory name_, string memory symbol_) {
658         _name = name_;
659         _symbol = symbol_;
660     }
661 
662     /**
663      * @dev See {IERC165-supportsInterface}.
664      */
665     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
666         return
667             interfaceId == type(IERC721).interfaceId ||
668             interfaceId == type(IERC721Metadata).interfaceId ||
669             super.supportsInterface(interfaceId);
670     }
671 
672     /**
673      * @dev See {IERC721-balanceOf}.
674      */
675     function balanceOf(address owner) public view virtual override returns (uint256) {
676         require(owner != address(0), "ERC721: balance query for the zero address");
677         return _balances[owner];
678     }
679 
680     /**
681      * @dev See {IERC721-ownerOf}.
682      */
683     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
684         address owner = _owners[tokenId];
685         require(owner != address(0), "ERC721: owner query for nonexistent token");
686         return owner;
687     }
688 
689     /**
690      * @dev See {IERC721Metadata-name}.
691      */
692     function name() public view virtual override returns (string memory) {
693         return _name;
694     }
695 
696     /**
697      * @dev See {IERC721Metadata-symbol}.
698      */
699     function symbol() public view virtual override returns (string memory) {
700         return _symbol;
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-tokenURI}.
705      */
706     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
707         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
708 
709         string memory baseURI = _baseURI();
710         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
711     }
712 
713     /**
714      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
715      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
716      * by default, can be overriden in child contracts.
717      */
718     function _baseURI() internal view virtual returns (string memory) {
719         return "";
720     }
721 
722     /**
723      * @dev See {IERC721-approve}.
724      */
725     function approve(address to, uint256 tokenId) public virtual override {
726         address owner = ERC721.ownerOf(tokenId);
727         require(to != owner, "ERC721: approval to current owner");
728 
729         require(
730             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
731             "ERC721: approve caller is not owner nor approved for all"
732         );
733 
734         _approve(to, tokenId);
735     }
736 
737     /**
738      * @dev See {IERC721-getApproved}.
739      */
740     function getApproved(uint256 tokenId) public view virtual override returns (address) {
741         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
742 
743         return _tokenApprovals[tokenId];
744     }
745 
746     /**
747      * @dev See {IERC721-setApprovalForAll}.
748      */
749     function setApprovalForAll(address operator, bool approved) public virtual override {
750         require(operator != _msgSender(), "ERC721: approve to caller");
751 
752         _operatorApprovals[_msgSender()][operator] = approved;
753         emit ApprovalForAll(_msgSender(), operator, approved);
754     }
755 
756     /**
757      * @dev See {IERC721-isApprovedForAll}.
758      */
759     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
760         return _operatorApprovals[owner][operator];
761     }
762 
763     /**
764      * @dev See {IERC721-transferFrom}.
765      */
766     function transferFrom(
767         address from,
768         address to,
769         uint256 tokenId
770     ) public virtual override {
771         //solhint-disable-next-line max-line-length
772         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
773 
774         _transfer(from, to, tokenId);
775     }
776 
777     /**
778      * @dev See {IERC721-safeTransferFrom}.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId
784     ) public virtual override {
785         safeTransferFrom(from, to, tokenId, "");
786     }
787 
788     /**
789      * @dev See {IERC721-safeTransferFrom}.
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId,
795         bytes memory _data
796     ) public virtual override {
797         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
798         _safeTransfer(from, to, tokenId, _data);
799     }
800 
801     /**
802      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
803      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
804      *
805      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
806      *
807      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
808      * implement alternative mechanisms to perform token transfer, such as signature-based.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must exist and be owned by `from`.
815      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
816      *
817      * Emits a {Transfer} event.
818      */
819     function _safeTransfer(
820         address from,
821         address to,
822         uint256 tokenId,
823         bytes memory _data
824     ) internal virtual {
825         _transfer(from, to, tokenId);
826         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
827     }
828 
829     /**
830      * @dev Returns whether `tokenId` exists.
831      *
832      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
833      *
834      * Tokens start existing when they are minted (`_mint`),
835      * and stop existing when they are burned (`_burn`).
836      */
837     function _exists(uint256 tokenId) internal view virtual returns (bool) {
838         return _owners[tokenId] != address(0);
839     }
840 
841     /**
842      * @dev Returns whether `spender` is allowed to manage `tokenId`.
843      *
844      * Requirements:
845      *
846      * - `tokenId` must exist.
847      */
848     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
849         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
850         address owner = ERC721.ownerOf(tokenId);
851         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
852     }
853 
854     /**
855      * @dev Safely mints `tokenId` and transfers it to `to`.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must not exist.
860      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _safeMint(address to, uint256 tokenId) internal virtual {
865         _safeMint(to, tokenId, "");
866     }
867 
868     /**
869      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
870      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
871      */
872     function _safeMint(
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) internal virtual {
877         _mint(to, tokenId);
878         require(
879             _checkOnERC721Received(address(0), to, tokenId, _data),
880             "ERC721: transfer to non ERC721Receiver implementer"
881         );
882     }
883 
884     /**
885      * @dev Mints `tokenId` and transfers it to `to`.
886      *
887      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
888      *
889      * Requirements:
890      *
891      * - `tokenId` must not exist.
892      * - `to` cannot be the zero address.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _mint(address to, uint256 tokenId) internal virtual {
897         require(to != address(0), "ERC721: mint to the zero address");
898         require(!_exists(tokenId), "ERC721: token already minted");
899 
900         _beforeTokenTransfer(address(0), to, tokenId);
901 
902         _balances[to] += 1;
903         _owners[tokenId] = to;
904 
905         emit Transfer(address(0), to, tokenId);
906     }
907 
908     /**
909      * @dev Destroys `tokenId`.
910      * The approval is cleared when the token is burned.
911      *
912      * Requirements:
913      *
914      * - `tokenId` must exist.
915      *
916      * Emits a {Transfer} event.
917      */
918     function _burn(uint256 tokenId) internal virtual {
919         address owner = ERC721.ownerOf(tokenId);
920 
921         _beforeTokenTransfer(owner, address(0), tokenId);
922 
923         // Clear approvals
924         _approve(address(0), tokenId);
925 
926         _balances[owner] -= 1;
927         delete _owners[tokenId];
928 
929         emit Transfer(owner, address(0), tokenId);
930     }
931 
932     /**
933      * @dev Transfers `tokenId` from `from` to `to`.
934      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
935      *
936      * Requirements:
937      *
938      * - `to` cannot be the zero address.
939      * - `tokenId` token must be owned by `from`.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _transfer(
944         address from,
945         address to,
946         uint256 tokenId
947     ) internal virtual {
948         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
949         require(to != address(0), "ERC721: transfer to the zero address");
950 
951         _beforeTokenTransfer(from, to, tokenId);
952 
953         // Clear approvals from the previous owner
954         _approve(address(0), tokenId);
955 
956         _balances[from] -= 1;
957         _balances[to] += 1;
958         _owners[tokenId] = to;
959 
960         emit Transfer(from, to, tokenId);
961     }
962 
963     /**
964      * @dev Approve `to` to operate on `tokenId`
965      *
966      * Emits a {Approval} event.
967      */
968     function _approve(address to, uint256 tokenId) internal virtual {
969         _tokenApprovals[tokenId] = to;
970         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
971     }
972 
973     /**
974      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
975      * The call is not executed if the target address is not a contract.
976      *
977      * @param from address representing the previous owner of the given token ID
978      * @param to target address that will receive the tokens
979      * @param tokenId uint256 ID of the token to be transferred
980      * @param _data bytes optional data to send along with the call
981      * @return bool whether the call correctly returned the expected magic value
982      */
983     function _checkOnERC721Received(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) private returns (bool) {
989         if (to.isContract()) {
990             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
991                 return retval == IERC721Receiver.onERC721Received.selector;
992             } catch (bytes memory reason) {
993                 if (reason.length == 0) {
994                     revert("ERC721: transfer to non ERC721Receiver implementer");
995                 } else {
996                     assembly {
997                         revert(add(32, reason), mload(reason))
998                     }
999                 }
1000             }
1001         } else {
1002             return true;
1003         }
1004     }
1005 
1006     /**
1007      * @dev Hook that is called before any token transfer. This includes minting
1008      * and burning.
1009      *
1010      * Calling conditions:
1011      *
1012      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1013      * transferred to `to`.
1014      * - When `from` is zero, `tokenId` will be minted for `to`.
1015      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1016      * - `from` and `to` are never both zero.
1017      *
1018      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1019      */
1020     function _beforeTokenTransfer(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) internal virtual {}
1025 }
1026 
1027 
1028 
1029 // CAUTION
1030 // This version of SafeMath should only be used with Solidity 0.8 or later,
1031 // because it relies on the compiler's built in overflow checks.
1032 
1033 /**
1034  * @dev Wrappers over Solidity's arithmetic operations.
1035  *
1036  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1037  * now has built in overflow checking.
1038  */
1039 library SafeMath {
1040     /**
1041      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1042      *
1043      * _Available since v3.4._
1044      */
1045     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1046         unchecked {
1047             uint256 c = a + b;
1048             if (c < a) return (false, 0);
1049             return (true, c);
1050         }
1051     }
1052 
1053     /**
1054      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1055      *
1056      * _Available since v3.4._
1057      */
1058     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1059         unchecked {
1060             if (b > a) return (false, 0);
1061             return (true, a - b);
1062         }
1063     }
1064 
1065     /**
1066      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1067      *
1068      * _Available since v3.4._
1069      */
1070     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1071         unchecked {
1072             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1073             // benefit is lost if 'b' is also tested.
1074             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1075             if (a == 0) return (true, 0);
1076             uint256 c = a * b;
1077             if (c / a != b) return (false, 0);
1078             return (true, c);
1079         }
1080     }
1081 
1082     /**
1083      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1084      *
1085      * _Available since v3.4._
1086      */
1087     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1088         unchecked {
1089             if (b == 0) return (false, 0);
1090             return (true, a / b);
1091         }
1092     }
1093 
1094     /**
1095      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1096      *
1097      * _Available since v3.4._
1098      */
1099     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1100         unchecked {
1101             if (b == 0) return (false, 0);
1102             return (true, a % b);
1103         }
1104     }
1105 
1106     /**
1107      * @dev Returns the addition of two unsigned integers, reverting on
1108      * overflow.
1109      *
1110      * Counterpart to Solidity's `+` operator.
1111      *
1112      * Requirements:
1113      *
1114      * - Addition cannot overflow.
1115      */
1116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1117         return a + b;
1118     }
1119 
1120     /**
1121      * @dev Returns the subtraction of two unsigned integers, reverting on
1122      * overflow (when the result is negative).
1123      *
1124      * Counterpart to Solidity's `-` operator.
1125      *
1126      * Requirements:
1127      *
1128      * - Subtraction cannot overflow.
1129      */
1130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1131         return a - b;
1132     }
1133 
1134     /**
1135      * @dev Returns the multiplication of two unsigned integers, reverting on
1136      * overflow.
1137      *
1138      * Counterpart to Solidity's `*` operator.
1139      *
1140      * Requirements:
1141      *
1142      * - Multiplication cannot overflow.
1143      */
1144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1145         return a * b;
1146     }
1147 
1148     /**
1149      * @dev Returns the integer division of two unsigned integers, reverting on
1150      * division by zero. The result is rounded towards zero.
1151      *
1152      * Counterpart to Solidity's `/` operator.
1153      *
1154      * Requirements:
1155      *
1156      * - The divisor cannot be zero.
1157      */
1158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1159         return a / b;
1160     }
1161 
1162     /**
1163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1164      * reverting when dividing by zero.
1165      *
1166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1167      * opcode (which leaves remaining gas untouched) while Solidity uses an
1168      * invalid opcode to revert (consuming all remaining gas).
1169      *
1170      * Requirements:
1171      *
1172      * - The divisor cannot be zero.
1173      */
1174     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1175         return a % b;
1176     }
1177 
1178     /**
1179      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1180      * overflow (when the result is negative).
1181      *
1182      * CAUTION: This function is deprecated because it requires allocating memory for the error
1183      * message unnecessarily. For custom revert reasons use {trySub}.
1184      *
1185      * Counterpart to Solidity's `-` operator.
1186      *
1187      * Requirements:
1188      *
1189      * - Subtraction cannot overflow.
1190      */
1191     function sub(
1192         uint256 a,
1193         uint256 b,
1194         string memory errorMessage
1195     ) internal pure returns (uint256) {
1196         unchecked {
1197             require(b <= a, errorMessage);
1198             return a - b;
1199         }
1200     }
1201 
1202     /**
1203      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1204      * division by zero. The result is rounded towards zero.
1205      *
1206      * Counterpart to Solidity's `/` operator. Note: this function uses a
1207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1208      * uses an invalid opcode to revert (consuming all remaining gas).
1209      *
1210      * Requirements:
1211      *
1212      * - The divisor cannot be zero.
1213      */
1214     function div(
1215         uint256 a,
1216         uint256 b,
1217         string memory errorMessage
1218     ) internal pure returns (uint256) {
1219         unchecked {
1220             require(b > 0, errorMessage);
1221             return a / b;
1222         }
1223     }
1224 
1225     /**
1226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1227      * reverting with custom message when dividing by zero.
1228      *
1229      * CAUTION: This function is deprecated because it requires allocating memory for the error
1230      * message unnecessarily. For custom revert reasons use {tryMod}.
1231      *
1232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1233      * opcode (which leaves remaining gas untouched) while Solidity uses an
1234      * invalid opcode to revert (consuming all remaining gas).
1235      *
1236      * Requirements:
1237      *
1238      * - The divisor cannot be zero.
1239      */
1240     function mod(
1241         uint256 a,
1242         uint256 b,
1243         string memory errorMessage
1244     ) internal pure returns (uint256) {
1245         unchecked {
1246             require(b > 0, errorMessage);
1247             return a % b;
1248         }
1249     }
1250 }
1251 
1252 
1253 
1254 /**
1255  * @title Counters
1256  * @author Matt Condon (@shrugs)
1257  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1258  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1259  *
1260  * Include with `using Counters for Counters.Counter;`
1261  */
1262 library Counters {
1263     struct Counter {
1264         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1265         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1266         // this feature: see https://github.com/ethereum/solidity/issues/4637
1267         uint256 _value; // default: 0
1268     }
1269 
1270     function current(Counter storage counter) internal view returns (uint256) {
1271         return counter._value;
1272     }
1273 
1274     function increment(Counter storage counter) internal {
1275         unchecked {
1276             counter._value += 1;
1277         }
1278     }
1279 
1280     function decrement(Counter storage counter) internal {
1281         uint256 value = counter._value;
1282         require(value > 0, "Counter: decrement overflow");
1283         unchecked {
1284             counter._value = value - 1;
1285         }
1286     }
1287 
1288     function reset(Counter storage counter) internal {
1289         counter._value = 0;
1290     }
1291 }
1292 
1293 
1294 
1295 /**
1296  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1297  *
1298  * These functions can be used to verify that a message was signed by the holder
1299  * of the private keys of a given address.
1300  */
1301 library ECDSA {
1302     enum RecoverError {
1303         NoError,
1304         InvalidSignature,
1305         InvalidSignatureLength,
1306         InvalidSignatureS,
1307         InvalidSignatureV
1308     }
1309 
1310     function _throwError(RecoverError error) private pure {
1311         if (error == RecoverError.NoError) {
1312             return; // no error: do nothing
1313         } else if (error == RecoverError.InvalidSignature) {
1314             revert("ECDSA: invalid signature");
1315         } else if (error == RecoverError.InvalidSignatureLength) {
1316             revert("ECDSA: invalid signature length");
1317         } else if (error == RecoverError.InvalidSignatureS) {
1318             revert("ECDSA: invalid signature 's' value");
1319         } else if (error == RecoverError.InvalidSignatureV) {
1320             revert("ECDSA: invalid signature 'v' value");
1321         }
1322     }
1323 
1324     /**
1325      * @dev Returns the address that signed a hashed message (`hash`) with
1326      * `signature` or error string. This address can then be used for verification purposes.
1327      *
1328      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1329      * this function rejects them by requiring the `s` value to be in the lower
1330      * half order, and the `v` value to be either 27 or 28.
1331      *
1332      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1333      * verification to be secure: it is possible to craft signatures that
1334      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1335      * this is by receiving a hash of the original message (which may otherwise
1336      * be too long), and then calling {toEthSignedMessageHash} on it.
1337      *
1338      * Documentation for signature generation:
1339      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1340      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1341      *
1342      * _Available since v4.3._
1343      */
1344     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1345         // Check the signature length
1346         // - case 65: r,s,v signature (standard)
1347         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1348         if (signature.length == 65) {
1349             bytes32 r;
1350             bytes32 s;
1351             uint8 v;
1352             // ecrecover takes the signature parameters, and the only way to get them
1353             // currently is to use assembly.
1354             assembly {
1355                 r := mload(add(signature, 0x20))
1356                 s := mload(add(signature, 0x40))
1357                 v := byte(0, mload(add(signature, 0x60)))
1358             }
1359             return tryRecover(hash, v, r, s);
1360         } else if (signature.length == 64) {
1361             bytes32 r;
1362             bytes32 vs;
1363             // ecrecover takes the signature parameters, and the only way to get them
1364             // currently is to use assembly.
1365             assembly {
1366                 r := mload(add(signature, 0x20))
1367                 vs := mload(add(signature, 0x40))
1368             }
1369             return tryRecover(hash, r, vs);
1370         } else {
1371             return (address(0), RecoverError.InvalidSignatureLength);
1372         }
1373     }
1374 
1375     /**
1376      * @dev Returns the address that signed a hashed message (`hash`) with
1377      * `signature`. This address can then be used for verification purposes.
1378      *
1379      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1380      * this function rejects them by requiring the `s` value to be in the lower
1381      * half order, and the `v` value to be either 27 or 28.
1382      *
1383      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1384      * verification to be secure: it is possible to craft signatures that
1385      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1386      * this is by receiving a hash of the original message (which may otherwise
1387      * be too long), and then calling {toEthSignedMessageHash} on it.
1388      */
1389     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1390         (address recovered, RecoverError error) = tryRecover(hash, signature);
1391         _throwError(error);
1392         return recovered;
1393     }
1394 
1395     /**
1396      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1397      *
1398      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1399      *
1400      * _Available since v4.3._
1401      */
1402     function tryRecover(
1403         bytes32 hash,
1404         bytes32 r,
1405         bytes32 vs
1406     ) internal pure returns (address, RecoverError) {
1407         bytes32 s;
1408         uint8 v;
1409         assembly {
1410             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1411             v := add(shr(255, vs), 27)
1412         }
1413         return tryRecover(hash, v, r, s);
1414     }
1415 
1416     /**
1417      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1418      *
1419      * _Available since v4.2._
1420      */
1421     function recover(
1422         bytes32 hash,
1423         bytes32 r,
1424         bytes32 vs
1425     ) internal pure returns (address) {
1426         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1427         _throwError(error);
1428         return recovered;
1429     }
1430 
1431     /**
1432      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1433      * `r` and `s` signature fields separately.
1434      *
1435      * _Available since v4.3._
1436      */
1437     function tryRecover(
1438         bytes32 hash,
1439         uint8 v,
1440         bytes32 r,
1441         bytes32 s
1442     ) internal pure returns (address, RecoverError) {
1443         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1444         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1445         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1446         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1447         //
1448         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1449         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1450         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1451         // these malleable signatures as well.
1452         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1453             return (address(0), RecoverError.InvalidSignatureS);
1454         }
1455         if (v != 27 && v != 28) {
1456             return (address(0), RecoverError.InvalidSignatureV);
1457         }
1458 
1459         // If the signature is valid (and not malleable), return the signer address
1460         address signer = ecrecover(hash, v, r, s);
1461         if (signer == address(0)) {
1462             return (address(0), RecoverError.InvalidSignature);
1463         }
1464 
1465         return (signer, RecoverError.NoError);
1466     }
1467 
1468     /**
1469      * @dev Overload of {ECDSA-recover} that receives the `v`,
1470      * `r` and `s` signature fields separately.
1471      */
1472     function recover(
1473         bytes32 hash,
1474         uint8 v,
1475         bytes32 r,
1476         bytes32 s
1477     ) internal pure returns (address) {
1478         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1479         _throwError(error);
1480         return recovered;
1481     }
1482 
1483     /**
1484      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1485      * produces hash corresponding to the one signed with the
1486      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1487      * JSON-RPC method as part of EIP-191.
1488      *
1489      * See {recover}.
1490      */
1491     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1492         // 32 is the length in bytes of hash,
1493         // enforced by the type signature above
1494         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1495     }
1496 
1497     /**
1498      * @dev Returns an Ethereum Signed Typed Data, created from a
1499      * `domainSeparator` and a `structHash`. This produces hash corresponding
1500      * to the one signed with the
1501      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1502      * JSON-RPC method as part of EIP-712.
1503      *
1504      * See {recover}.
1505      */
1506     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1507         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1508     }
1509 }
1510 
1511 
1512 
1513 /**
1514  * @dev These functions deal with verification of Merkle Trees proofs.
1515  *
1516  * The proofs can be generated using the JavaScript library
1517  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1518  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1519  *
1520  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1521  */
1522 library MerkleProof {
1523     /**
1524      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1525      * defined by `root`. For this, a `proof` must be provided, containing
1526      * sibling hashes on the branch from the leaf to the root of the tree. Each
1527      * pair of leaves and each pair of pre-images are assumed to be sorted.
1528      */
1529     function verify(
1530         bytes32[] memory proof,
1531         bytes32 root,
1532         bytes32 leaf
1533     ) internal pure returns (bool) {
1534         bytes32 computedHash = leaf;
1535 
1536         for (uint256 i = 0; i < proof.length; i++) {
1537             bytes32 proofElement = proof[i];
1538 
1539             if (computedHash <= proofElement) {
1540                 // Hash(current computed hash + current element of the proof)
1541                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1542             } else {
1543                 // Hash(current element of the proof + current computed hash)
1544                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1545             }
1546         }
1547 
1548         // Check if the computed hash (root) is equal to the provided root
1549         return computedHash == root;
1550     }
1551 }
1552 
1553 interface IOperatorFilterRegistry {
1554     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1555     function register(address registrant) external;
1556     function registerAndSubscribe(address registrant, address subscription) external;
1557     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1558     function unregister(address addr) external;
1559     function updateOperator(address registrant, address operator, bool filtered) external;
1560     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1561     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1562     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1563     function subscribe(address registrant, address registrantToSubscribe) external;
1564     function unsubscribe(address registrant, bool copyExistingEntries) external;
1565     function subscriptionOf(address addr) external returns (address registrant);
1566     function subscribers(address registrant) external returns (address[] memory);
1567     function subscriberAt(address registrant, uint256 index) external returns (address);
1568     function copyEntriesOf(address registrant, address registrantToCopy) external;
1569     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1570     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1571     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1572     function filteredOperators(address addr) external returns (address[] memory);
1573     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1574     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1575     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1576     function isRegistered(address addr) external returns (bool);
1577     function codeHashOf(address addr) external returns (bytes32);
1578 }
1579 
1580 abstract contract OperatorFilterer {
1581     error OperatorNotAllowed(address operator);
1582 
1583     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1584         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1585 
1586     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1587         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1588         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1589         // order for the modifier to filter addresses.
1590         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1591             if (subscribe) {
1592                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1593             } else {
1594                 if (subscriptionOrRegistrantToCopy != address(0)) {
1595                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1596                 } else {
1597                     OPERATOR_FILTER_REGISTRY.register(address(this));
1598                 }
1599             }
1600         }
1601     }
1602 
1603     modifier onlyAllowedOperator(address from) virtual {
1604         // Allow spending tokens from addresses with balance
1605         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1606         // from an EOA.
1607         if (from != msg.sender) {
1608             _checkFilterOperator(msg.sender);
1609         }
1610         _;
1611     }
1612 
1613     modifier onlyAllowedOperatorApproval(address operator) virtual {
1614         _checkFilterOperator(operator);
1615         _;
1616     }
1617 
1618     function _checkFilterOperator(address operator) internal view virtual {
1619         // Check registry code length to facilitate testing in environments without a deployed registry.
1620         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1621             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1622                 revert OperatorNotAllowed(operator);
1623             }
1624         }
1625     }
1626 }
1627 
1628 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1629     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1630 
1631     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1632 }
1633 
1634 contract CircleOfZav is ERC721, DefaultOperatorFilterer, Ownable {
1635     using ECDSA for bytes32;
1636     using SafeMath for uint256;
1637     using Address for address;
1638     using Counters for Counters.Counter;
1639 
1640     Counters.Counter private Circles;
1641     string private baseURI;
1642 
1643     uint256 constant public maxCircles = 1001;
1644     uint256 public circlesMinted = 0;
1645     uint256 public circlesReserved = 0;
1646 
1647     uint256 public maxReserved = 50;
1648     uint256 public saleState = 0;
1649     uint256 public mintPrice = 0.05 ether;
1650     uint256 public maxPerTxn = 2;
1651     address public merkleAddress;
1652 
1653     // tracks the amount of tokens minted based on address during whitelist stage
1654     mapping(address => uint256) public whitelistMinted;
1655     mapping(address => uint256) public publicMinted;
1656 
1657     modifier contractBlocker() {
1658         require(tx.origin == msg.sender, "No Smart Contracts Allowed");
1659         _;
1660     }
1661 
1662     constructor() ERC721("Circle of Zav", "CoZ") {
1663         Circles.increment();
1664     }
1665 
1666     // reserves the circles for mr artist
1667     function reserve(uint256 amount) public payable onlyOwner {
1668         uint256 currentCircles = Circles.current();
1669 
1670         require(circlesReserved <= maxReserved, "You already reserved the max amount");
1671 
1672         for (uint256 i; i < amount; i++) {
1673             _safeMint(msg.sender, currentCircles + i);
1674             Circles.increment();
1675         }
1676 
1677         circlesReserved += amount;
1678     }
1679 
1680     // whitelist mint is stage 1
1681     function whitelistMint(uint256 amount, bytes calldata proof) public payable contractBlocker {
1682         uint256 currentCircles = Circles.current();
1683 
1684         require(saleState == 1, "Whitelist Mint is not ready");
1685         require(currentCircles <= maxCircles, "Max Supply reached");
1686         require(mintPrice * amount == msg.value, "Invalid Mint Price provided");
1687         require(amount >= 1 && amount <= maxPerTxn, "Invalid Quantity");
1688         require(whitelistMinted[msg.sender] < 3, "You already max minted for whitelist mint");
1689         require(isValidSignature(keccak256(abi.encodePacked(msg.sender, amount)), proof), "Invalid Proof Signature");
1690 
1691         whitelistMinted[msg.sender] += amount;
1692 
1693         for (uint256 i; i < amount; i++) {
1694             _safeMint(msg.sender, currentCircles + i);
1695             Circles.increment();
1696         }
1697     }
1698 
1699     // public mint is stage 2
1700     function publicMint(uint256 amount) public payable contractBlocker {
1701         uint256 currentCircles = Circles.current();
1702 
1703         require(saleState == 2, "Public Mint is not ready");
1704         require(currentCircles <= maxCircles, "Max Supply reached");
1705         require(mintPrice * amount == msg.value, "Invalid Mint Price provided");
1706         require(amount >= 1 && amount <= maxPerTxn, "Invalid Quantity");
1707         require(publicMinted[msg.sender] < 3, "You already max minted for the public mint");
1708 
1709         for (uint256 i; i < amount; i++) {
1710             _safeMint(msg.sender, currentCircles + i);
1711             Circles.increment();
1712         }
1713     }
1714 
1715     // updates the mint price
1716     function setMintPrice(uint256 _mintPrice) public payable onlyOwner {
1717         mintPrice = _mintPrice;
1718     }
1719 
1720     // sets the max mints per transaction
1721     function setMaxPer(uint256 _maxPerTxn) public payable onlyOwner {
1722         maxPerTxn = _maxPerTxn;
1723     }
1724 
1725     // returns the total amount minted
1726     function totalSupply() external view returns(uint256) {
1727         return Circles.current();
1728     }
1729 
1730     // required for the metadata to be visible on OS
1731     function _baseURI() internal view override returns (string memory) {
1732         return baseURI;
1733     }
1734 
1735     // updates the metadata base uri to the new one, used for revealing
1736     function setMetadata(string memory _baseUrl) public payable onlyOwner {
1737         baseURI = _baseUrl;
1738     }
1739 
1740     // withdraws the mint functions to the contract deployer
1741     function withdraw() public onlyOwner {
1742         uint256 balance = address(this).balance;
1743         payable(msg.sender).transfer(balance);
1744     }
1745 
1746     // validates the markle signature for whitelist
1747     function isValidSignature(bytes32 hash, bytes calldata sig) internal view returns (bool) {
1748         bytes32 signed = hash.toEthSignedMessageHash();
1749         
1750         return merkleAddress == signed.recover(sig);
1751     }
1752 
1753     // sets the proof sig address
1754     function setMerkleAddress(address _markleAddress) public onlyOwner {
1755         merkleAddress = _markleAddress;
1756     }
1757 
1758     // sets the sale state
1759     function setSaleState(uint256 _saleState) public onlyOwner {
1760         saleState = _saleState;
1761     }
1762 
1763     // sets the maxReserved incase it needs to be switched
1764     function setMaxReserved(uint256 _maxReserved) public onlyOwner {
1765         maxReserved = _maxReserved;
1766     }
1767 
1768     // helper functions required in order to transfer tokens
1769     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1770         super.setApprovalForAll(operator, approved);
1771     }
1772 
1773     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1774         super.approve(operator, tokenId);
1775     }
1776 
1777     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1778         super.transferFrom(from, to, tokenId);
1779     }
1780 
1781     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1782         safeTransferFrom(from, to, tokenId, "");
1783     }
1784 
1785     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
1786         super.safeTransferFrom(from, to, tokenId, data);
1787     }
1788 }