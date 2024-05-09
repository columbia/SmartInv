1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _setOwner(_msgSender());
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         _setOwner(address(0));
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Can only be called by the current owner.
80      */
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         _setOwner(newOwner);
84     }
85 
86     function _setOwner(address newOwner) private {
87         address oldOwner = _owner;
88         _owner = newOwner;
89         emit OwnershipTransferred(oldOwner, newOwner);
90     }
91 }
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Interface of the ERC165 standard, as defined in the
97  * https://eips.ethereum.org/EIPS/eip-165[EIP].
98  *
99  * Implementers can declare support of contract interfaces, which can then be
100  * queried by others ({ERC165Checker}).
101  *
102  * For an implementation, see {ERC165}.
103  */
104 interface IERC165 {
105     /**
106      * @dev Returns true if this contract implements the interface defined by
107      * `interfaceId`. See the corresponding
108      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
109      * to learn more about how these ids are created.
110      *
111      * This function call must use less than 30 000 gas.
112      */
113     function supportsInterface(bytes4 interfaceId) external view returns (bool);
114 }
115 
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Required interface of an ERC721 compliant contract.
121  */
122 interface IERC721 is IERC165 {
123     /**
124      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
130      */
131     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
135      */
136     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
137 
138     /**
139      * @dev Returns the number of tokens in ``owner``'s account.
140      */
141     function balanceOf(address owner) external view returns (uint256 balance);
142 
143     /**
144      * @dev Returns the owner of the `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function ownerOf(uint256 tokenId) external view returns (address owner);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
154      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId
170     ) external;
171 
172     /**
173      * @dev Transfers `tokenId` token from `from` to `to`.
174      *
175      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must be owned by `from`.
182      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transferFrom(
187         address from,
188         address to,
189         uint256 tokenId
190     ) external;
191 
192     /**
193      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
194      * The approval is cleared when the token is transferred.
195      *
196      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
197      *
198      * Requirements:
199      *
200      * - The caller must own the token or be an approved operator.
201      * - `tokenId` must exist.
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address to, uint256 tokenId) external;
206 
207     /**
208      * @dev Returns the account approved for `tokenId` token.
209      *
210      * Requirements:
211      *
212      * - `tokenId` must exist.
213      */
214     function getApproved(uint256 tokenId) external view returns (address operator);
215 
216     /**
217      * @dev Approve or remove `operator` as an operator for the caller.
218      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
219      *
220      * Requirements:
221      *
222      * - The `operator` cannot be the caller.
223      *
224      * Emits an {ApprovalForAll} event.
225      */
226     function setApprovalForAll(address operator, bool _approved) external;
227 
228     /**
229      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
230      *
231      * See {setApprovalForAll}
232      */
233     function isApprovedForAll(address owner, address operator) external view returns (bool);
234 
235     /**
236      * @dev Safely transfers `tokenId` token from `from` to `to`.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must exist and be owned by `from`.
243      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
245      *
246      * Emits a {Transfer} event.
247      */
248     function safeTransferFrom(
249         address from,
250         address to,
251         uint256 tokenId,
252         bytes calldata data
253     ) external;
254 }
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @title ERC721 token receiver interface
260  * @dev Interface for any contract that wants to support safeTransfers
261  * from ERC721 asset contracts.
262  */
263 interface IERC721Receiver {
264     /**
265      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
266      * by `operator` from `from`, this function is called.
267      *
268      * It must return its Solidity selector to confirm the token transfer.
269      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
270      *
271      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
272      */
273     function onERC721Received(
274         address operator,
275         address from,
276         uint256 tokenId,
277         bytes calldata data
278     ) external returns (bytes4);
279 }
280 
281 pragma solidity ^0.8.0;
282 
283 /**
284  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
285  * @dev See https://eips.ethereum.org/EIPS/eip-721
286  */
287 interface IERC721Metadata is IERC721 {
288     /**
289      * @dev Returns the token collection name.
290      */
291     function name() external view returns (string memory);
292 
293     /**
294      * @dev Returns the token collection symbol.
295      */
296     function symbol() external view returns (string memory);
297 
298     /**
299      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
300      */
301     function tokenURI(uint256 tokenId) external view returns (string memory);
302 }
303 
304 pragma solidity ^0.8.0;
305 
306 /**
307  * @dev Collection of functions related to the address type
308  */
309 library Address {
310     /**
311      * @dev Returns true if `account` is a contract.
312      *
313      * [IMPORTANT]
314      * ====
315      * It is unsafe to assume that an address for which this function returns
316      * false is an externally-owned account (EOA) and not a contract.
317      *
318      * Among others, `isContract` will return false for the following
319      * types of addresses:
320      *
321      *  - an externally-owned account
322      *  - a contract in construction
323      *  - an address where a contract will be created
324      *  - an address where a contract lived, but was destroyed
325      * ====
326      */
327     function isContract(address account) internal view returns (bool) {
328         // This method relies on extcodesize, which returns 0 for contracts in
329         // construction, since the code is only stored at the end of the
330         // constructor execution.
331 
332         uint256 size;
333         assembly {
334             size := extcodesize(account)
335         }
336         return size > 0;
337     }
338 
339     /**
340      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
341      * `recipient`, forwarding all available gas and reverting on errors.
342      *
343      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
344      * of certain opcodes, possibly making contracts go over the 2300 gas limit
345      * imposed by `transfer`, making them unable to receive funds via
346      * `transfer`. {sendValue} removes this limitation.
347      *
348      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
349      *
350      * IMPORTANT: because control is transferred to `recipient`, care must be
351      * taken to not create reentrancy vulnerabilities. Consider using
352      * {ReentrancyGuard} or the
353      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
354      */
355     function sendValue(address payable recipient, uint256 amount) internal {
356         require(address(this).balance >= amount, "Address: insufficient balance");
357 
358         (bool success, ) = recipient.call{value: amount}("");
359         require(success, "Address: unable to send value, recipient may have reverted");
360     }
361 
362     /**
363      * @dev Performs a Solidity function call using a low level `call`. A
364      * plain `call` is an unsafe replacement for a function call: use this
365      * function instead.
366      *
367      * If `target` reverts with a revert reason, it is bubbled up by this
368      * function (like regular Solidity function calls).
369      *
370      * Returns the raw returned data. To convert to the expected return value,
371      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
372      *
373      * Requirements:
374      *
375      * - `target` must be a contract.
376      * - calling `target` with `data` must not revert.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
381         return functionCall(target, data, "Address: low-level call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
386      * `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         return functionCallWithValue(target, data, 0, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but also transferring `value` wei to `target`.
401      *
402      * Requirements:
403      *
404      * - the calling contract must have an ETH balance of at least `value`.
405      * - the called Solidity function must be `payable`.
406      *
407      * _Available since v3.1._
408      */
409     function functionCallWithValue(
410         address target,
411         bytes memory data,
412         uint256 value
413     ) internal returns (bytes memory) {
414         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
419      * with `errorMessage` as a fallback revert reason when `target` reverts.
420      *
421      * _Available since v3.1._
422      */
423     function functionCallWithValue(
424         address target,
425         bytes memory data,
426         uint256 value,
427         string memory errorMessage
428     ) internal returns (bytes memory) {
429         require(address(this).balance >= value, "Address: insufficient balance for call");
430         require(isContract(target), "Address: call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.call{value: value}(data);
433         return _verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
443         return functionStaticCall(target, data, "Address: low-level static call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal view returns (bytes memory) {
457         require(isContract(target), "Address: static call to non-contract");
458 
459         (bool success, bytes memory returndata) = target.staticcall(data);
460         return _verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465      * but performing a delegate call.
466      *
467      * _Available since v3.4._
468      */
469     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
470         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.4._
478      */
479     function functionDelegateCall(
480         address target,
481         bytes memory data,
482         string memory errorMessage
483     ) internal returns (bytes memory) {
484         require(isContract(target), "Address: delegate call to non-contract");
485 
486         (bool success, bytes memory returndata) = target.delegatecall(data);
487         return _verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     function _verifyCallResult(
491         bool success,
492         bytes memory returndata,
493         string memory errorMessage
494     ) private pure returns (bytes memory) {
495         if (success) {
496             return returndata;
497         } else {
498             // Look for revert reason and bubble it up if present
499             if (returndata.length > 0) {
500                 // The easiest way to bubble the revert reason is using memory via assembly
501 
502                 assembly {
503                     let returndata_size := mload(returndata)
504                     revert(add(32, returndata), returndata_size)
505                 }
506             } else {
507                 revert(errorMessage);
508             }
509         }
510     }
511 }
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev String operations.
517  */
518 library Strings {
519     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
520 
521     /**
522      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
523      */
524     function toString(uint256 value) internal pure returns (string memory) {
525         // Inspired by OraclizeAPI's implementation - MIT licence
526         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
527 
528         if (value == 0) {
529             return "0";
530         }
531         uint256 temp = value;
532         uint256 digits;
533         while (temp != 0) {
534             digits++;
535             temp /= 10;
536         }
537         bytes memory buffer = new bytes(digits);
538         while (value != 0) {
539             digits -= 1;
540             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
541             value /= 10;
542         }
543         return string(buffer);
544     }
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
548      */
549     function toHexString(uint256 value) internal pure returns (string memory) {
550         if (value == 0) {
551             return "0x00";
552         }
553         uint256 temp = value;
554         uint256 length = 0;
555         while (temp != 0) {
556             length++;
557             temp >>= 8;
558         }
559         return toHexString(value, length);
560     }
561 
562     /**
563      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
564      */
565     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
566         bytes memory buffer = new bytes(2 * length + 2);
567         buffer[0] = "0";
568         buffer[1] = "x";
569         for (uint256 i = 2 * length + 1; i > 1; --i) {
570             buffer[i] = _HEX_SYMBOLS[value & 0xf];
571             value >>= 4;
572         }
573         require(value == 0, "Strings: hex length insufficient");
574         return string(buffer);
575     }
576 }
577 
578 pragma solidity ^0.8.0;
579 
580 /**
581  * @dev Implementation of the {IERC165} interface.
582  *
583  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
584  * for the additional interface id that will be supported. For example:
585  *
586  * ```solidity
587  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
588  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
589  * }
590  * ```
591  *
592  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
593  */
594 abstract contract ERC165 is IERC165 {
595     /**
596      * @dev See {IERC165-supportsInterface}.
597      */
598     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
599         return interfaceId == type(IERC165).interfaceId;
600     }
601 }
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
607  * the Metadata extension, but not including the Enumerable extension, which is available separately as
608  * {ERC721Enumerable}.
609  */
610 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
611     using Address for address;
612     using Strings for uint256;
613 
614     // Token name
615     string private _name;
616 
617     // Token symbol
618     string private _symbol;
619 
620     // Mapping from token ID to owner address
621     mapping(uint256 => address) private _owners;
622 
623     // Mapping owner address to token count
624     mapping(address => uint256) private _balances;
625 
626     // Mapping from token ID to approved address
627     mapping(uint256 => address) private _tokenApprovals;
628 
629     // Mapping from owner to operator approvals
630     mapping(address => mapping(address => bool)) private _operatorApprovals;
631 
632     /**
633      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
634      */
635     constructor(string memory name_, string memory symbol_) {
636         _name = name_;
637         _symbol = symbol_;
638     }
639 
640     /**
641      * @dev See {IERC165-supportsInterface}.
642      */
643     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
644         return
645             interfaceId == type(IERC721).interfaceId ||
646             interfaceId == type(IERC721Metadata).interfaceId ||
647             super.supportsInterface(interfaceId);
648     }
649 
650     /**
651      * @dev See {IERC721-balanceOf}.
652      */
653     function balanceOf(address owner) public view virtual override returns (uint256) {
654         require(owner != address(0), "ERC721: balance query for the zero address");
655         return _balances[owner];
656     }
657 
658     /**
659      * @dev See {IERC721-ownerOf}.
660      */
661     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
662         address owner = _owners[tokenId];
663         require(owner != address(0), "ERC721: owner query for nonexistent token");
664         return owner;
665     }
666 
667     /**
668      * @dev See {IERC721Metadata-name}.
669      */
670     function name() public view virtual override returns (string memory) {
671         return _name;
672     }
673 
674     /**
675      * @dev See {IERC721Metadata-symbol}.
676      */
677     function symbol() public view virtual override returns (string memory) {
678         return _symbol;
679     }
680 
681     /**
682      * @dev See {IERC721Metadata-tokenURI}.
683      */
684     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
685         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
686 
687         string memory baseURI = _baseURI();
688         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
689     }
690 
691     /**
692      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
693      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
694      * by default, can be overriden in child contracts.
695      */
696     function _baseURI() internal view virtual returns (string memory) {
697         return "";
698     }
699 
700     /**
701      * @dev See {IERC721-approve}.
702      */
703     function approve(address to, uint256 tokenId) public virtual override {
704         address owner = ERC721.ownerOf(tokenId);
705         require(to != owner, "ERC721: approval to current owner");
706 
707         require(
708             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
709             "ERC721: approve caller is not owner nor approved for all"
710         );
711 
712         _approve(to, tokenId);
713     }
714 
715     /**
716      * @dev See {IERC721-getApproved}.
717      */
718     function getApproved(uint256 tokenId) public view virtual override returns (address) {
719         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
720 
721         return _tokenApprovals[tokenId];
722     }
723 
724     /**
725      * @dev See {IERC721-setApprovalForAll}.
726      */
727     function setApprovalForAll(address operator, bool approved) public virtual override {
728         require(operator != _msgSender(), "ERC721: approve to caller");
729 
730         _operatorApprovals[_msgSender()][operator] = approved;
731         emit ApprovalForAll(_msgSender(), operator, approved);
732     }
733 
734     /**
735      * @dev See {IERC721-isApprovedForAll}.
736      */
737     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
738         return _operatorApprovals[owner][operator];
739     }
740 
741     /**
742      * @dev See {IERC721-transferFrom}.
743      */
744     function transferFrom(
745         address from,
746         address to,
747         uint256 tokenId
748     ) public virtual override {
749         //solhint-disable-next-line max-line-length
750         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
751 
752         _transfer(from, to, tokenId);
753     }
754 
755     /**
756      * @dev See {IERC721-safeTransferFrom}.
757      */
758     function safeTransferFrom(
759         address from,
760         address to,
761         uint256 tokenId
762     ) public virtual override {
763         safeTransferFrom(from, to, tokenId, "");
764     }
765 
766     /**
767      * @dev See {IERC721-safeTransferFrom}.
768      */
769     function safeTransferFrom(
770         address from,
771         address to,
772         uint256 tokenId,
773         bytes memory _data
774     ) public virtual override {
775         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
776         _safeTransfer(from, to, tokenId, _data);
777     }
778 
779     /**
780      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
781      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
782      *
783      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
784      *
785      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
786      * implement alternative mechanisms to perform token transfer, such as signature-based.
787      *
788      * Requirements:
789      *
790      * - `from` cannot be the zero address.
791      * - `to` cannot be the zero address.
792      * - `tokenId` token must exist and be owned by `from`.
793      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
794      *
795      * Emits a {Transfer} event.
796      */
797     function _safeTransfer(
798         address from,
799         address to,
800         uint256 tokenId,
801         bytes memory _data
802     ) internal virtual {
803         _transfer(from, to, tokenId);
804         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
805     }
806 
807     /**
808      * @dev Returns whether `tokenId` exists.
809      *
810      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
811      *
812      * Tokens start existing when they are minted (`_mint`),
813      * and stop existing when they are burned (`_burn`).
814      */
815     function _exists(uint256 tokenId) internal view virtual returns (bool) {
816         return _owners[tokenId] != address(0);
817     }
818 
819     /**
820      * @dev Returns whether `spender` is allowed to manage `tokenId`.
821      *
822      * Requirements:
823      *
824      * - `tokenId` must exist.
825      */
826     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
827         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
828         address owner = ERC721.ownerOf(tokenId);
829         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
830     }
831 
832     /**
833      * @dev Safely mints `tokenId` and transfers it to `to`.
834      *
835      * Requirements:
836      *
837      * - `tokenId` must not exist.
838      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
839      *
840      * Emits a {Transfer} event.
841      */
842     function _safeMint(address to, uint256 tokenId) internal virtual {
843         _safeMint(to, tokenId, "");
844     }
845 
846     /**
847      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
848      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
849      */
850     function _safeMint(
851         address to,
852         uint256 tokenId,
853         bytes memory _data
854     ) internal virtual {
855         _mint(to, tokenId);
856         require(
857             _checkOnERC721Received(address(0), to, tokenId, _data),
858             "ERC721: transfer to non ERC721Receiver implementer"
859         );
860     }
861 
862     /**
863      * @dev Mints `tokenId` and transfers it to `to`.
864      *
865      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
866      *
867      * Requirements:
868      *
869      * - `tokenId` must not exist.
870      * - `to` cannot be the zero address.
871      *
872      * Emits a {Transfer} event.
873      */
874     function _mint(address to, uint256 tokenId) internal virtual {
875         require(to != address(0), "ERC721: mint to the zero address");
876         require(!_exists(tokenId), "ERC721: token already minted");
877 
878         _beforeTokenTransfer(address(0), to, tokenId);
879 
880         _balances[to] += 1;
881         _owners[tokenId] = to;
882 
883         emit Transfer(address(0), to, tokenId);
884     }
885 
886     /**
887      * @dev Destroys `tokenId`.
888      * The approval is cleared when the token is burned.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must exist.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _burn(uint256 tokenId) internal virtual {
897         address owner = ERC721.ownerOf(tokenId);
898 
899         _beforeTokenTransfer(owner, address(0), tokenId);
900 
901         // Clear approvals
902         _approve(address(0), tokenId);
903 
904         _balances[owner] -= 1;
905         delete _owners[tokenId];
906 
907         emit Transfer(owner, address(0), tokenId);
908     }
909 
910     /**
911      * @dev Transfers `tokenId` from `from` to `to`.
912      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
913      *
914      * Requirements:
915      *
916      * - `to` cannot be the zero address.
917      * - `tokenId` token must be owned by `from`.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _transfer(
922         address from,
923         address to,
924         uint256 tokenId
925     ) internal virtual {
926         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
927         require(to != address(0), "ERC721: transfer to the zero address");
928 
929         _beforeTokenTransfer(from, to, tokenId);
930 
931         // Clear approvals from the previous owner
932         _approve(address(0), tokenId);
933 
934         _balances[from] -= 1;
935         _balances[to] += 1;
936         _owners[tokenId] = to;
937 
938         emit Transfer(from, to, tokenId);
939     }
940 
941     /**
942      * @dev Approve `to` to operate on `tokenId`
943      *
944      * Emits a {Approval} event.
945      */
946     function _approve(address to, uint256 tokenId) internal virtual {
947         _tokenApprovals[tokenId] = to;
948         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
949     }
950 
951     /**
952      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
953      * The call is not executed if the target address is not a contract.
954      *
955      * @param from address representing the previous owner of the given token ID
956      * @param to target address that will receive the tokens
957      * @param tokenId uint256 ID of the token to be transferred
958      * @param _data bytes optional data to send along with the call
959      * @return bool whether the call correctly returned the expected magic value
960      */
961     function _checkOnERC721Received(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes memory _data
966     ) private returns (bool) {
967         if (to.isContract()) {
968             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
969                 return retval == IERC721Receiver(to).onERC721Received.selector;
970             } catch (bytes memory reason) {
971                 if (reason.length == 0) {
972                     revert("ERC721: transfer to non ERC721Receiver implementer");
973                 } else {
974                     assembly {
975                         revert(add(32, reason), mload(reason))
976                     }
977                 }
978             }
979         } else {
980             return true;
981         }
982     }
983 
984     /**
985      * @dev Hook that is called before any token transfer. This includes minting
986      * and burning.
987      *
988      * Calling conditions:
989      *
990      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
991      * transferred to `to`.
992      * - When `from` is zero, `tokenId` will be minted for `to`.
993      * - When `to` is zero, ``from``'s `tokenId` will be burned.
994      * - `from` and `to` are never both zero.
995      *
996      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
997      */
998     function _beforeTokenTransfer(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) internal virtual {}
1003 }
1004 
1005 pragma solidity ^0.8.0;
1006 
1007 /**
1008  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1009  * @dev See https://eips.ethereum.org/EIPS/eip-721
1010  */
1011 interface IERC721Enumerable is IERC721 {
1012     /**
1013      * @dev Returns the total amount of tokens stored by the contract.
1014      */
1015     function totalSupply() external view returns (uint256);
1016 
1017     /**
1018      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1019      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1020      */
1021     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1022 
1023     /**
1024      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1025      * Use along with {totalSupply} to enumerate all tokens.
1026      */
1027     function tokenByIndex(uint256 index) external view returns (uint256);
1028 }
1029 
1030 pragma solidity ^0.8.0;
1031 
1032 
1033 /**
1034  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1035  * enumerability of all the token ids in the contract as well as all token ids owned by each
1036  * account.
1037  */
1038 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1039     // Mapping from owner to list of owned token IDs
1040     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1041 
1042     // Mapping from token ID to index of the owner tokens list
1043     mapping(uint256 => uint256) private _ownedTokensIndex;
1044 
1045     // Array with all token ids, used for enumeration
1046     uint256[] private _allTokens;
1047 
1048     // Mapping from token id to position in the allTokens array
1049     mapping(uint256 => uint256) private _allTokensIndex;
1050 
1051     /**
1052      * @dev See {IERC165-supportsInterface}.
1053      */
1054     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1055         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1056     }
1057 
1058     /**
1059      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1060      */
1061     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1062         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1063         return _ownedTokens[owner][index];
1064     }
1065 
1066     /**
1067      * @dev See {IERC721Enumerable-totalSupply}.
1068      */
1069     function totalSupply() public view virtual override returns (uint256) {
1070         return _allTokens.length;
1071     }
1072 
1073     /**
1074      * @dev See {IERC721Enumerable-tokenByIndex}.
1075      */
1076     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1077         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1078         return _allTokens[index];
1079     }
1080 
1081     /**
1082      * @dev Hook that is called before any token transfer. This includes minting
1083      * and burning.
1084      *
1085      * Calling conditions:
1086      *
1087      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1088      * transferred to `to`.
1089      * - When `from` is zero, `tokenId` will be minted for `to`.
1090      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1091      * - `from` cannot be the zero address.
1092      * - `to` cannot be the zero address.
1093      *
1094      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1095      */
1096     function _beforeTokenTransfer(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) internal virtual override {
1101         super._beforeTokenTransfer(from, to, tokenId);
1102 
1103         if (from == address(0)) {
1104             _addTokenToAllTokensEnumeration(tokenId);
1105         } else if (from != to) {
1106             _removeTokenFromOwnerEnumeration(from, tokenId);
1107         }
1108         if (to == address(0)) {
1109             _removeTokenFromAllTokensEnumeration(tokenId);
1110         } else if (to != from) {
1111             _addTokenToOwnerEnumeration(to, tokenId);
1112         }
1113     }
1114 
1115     /**
1116      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1117      * @param to address representing the new owner of the given token ID
1118      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1119      */
1120     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1121         uint256 length = ERC721.balanceOf(to);
1122         _ownedTokens[to][length] = tokenId;
1123         _ownedTokensIndex[tokenId] = length;
1124     }
1125 
1126     /**
1127      * @dev Private function to add a token to this extension's token tracking data structures.
1128      * @param tokenId uint256 ID of the token to be added to the tokens list
1129      */
1130     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1131         _allTokensIndex[tokenId] = _allTokens.length;
1132         _allTokens.push(tokenId);
1133     }
1134 
1135     /**
1136      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1137      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1138      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1139      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1140      * @param from address representing the previous owner of the given token ID
1141      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1142      */
1143     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1144         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1145         // then delete the last slot (swap and pop).
1146 
1147         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1148         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1149 
1150         // When the token to delete is the last token, the swap operation is unnecessary
1151         if (tokenIndex != lastTokenIndex) {
1152             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1153 
1154             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1155             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1156         }
1157 
1158         // This also deletes the contents at the last position of the array
1159         delete _ownedTokensIndex[tokenId];
1160         delete _ownedTokens[from][lastTokenIndex];
1161     }
1162 
1163     /**
1164      * @dev Private function to remove a token from this extension's token tracking data structures.
1165      * This has O(1) time complexity, but alters the order of the _allTokens array.
1166      * @param tokenId uint256 ID of the token to be removed from the tokens list
1167      */
1168     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1169         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1170         // then delete the last slot (swap and pop).
1171 
1172         uint256 lastTokenIndex = _allTokens.length - 1;
1173         uint256 tokenIndex = _allTokensIndex[tokenId];
1174 
1175         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1176         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1177         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1178         uint256 lastTokenId = _allTokens[lastTokenIndex];
1179 
1180         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1181         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1182 
1183         // This also deletes the contents at the last position of the array
1184         delete _allTokensIndex[tokenId];
1185         _allTokens.pop();
1186     }
1187 }
1188 
1189 pragma solidity ^0.8.0;
1190 
1191 /**
1192 $$$$$$$$$$$$$$$$$$$$$$NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN$$$$$$$$$$
1193 $$$$$$$$$$$$$$$$$$$N*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*N$$$$$$$$
1194 $$$$$$$$$$$$$$$$$$M:.*NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNMV*VFFFFFFFFFFFFFFFFFFFFFFFFFFFFV..V$$$$$$$$
1195 $$$$$$$$$$$$$$$$$N*.:N$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$NV:.VFFIFIFFIIIIIIIIIIIIIIIFFFIIFF:.:N$$$$$$$$
1196 $$$$$$$$$$$$$$$$N:.*$$$:.......$$$$$$$$$$NV:.....*$$M*:..*IIFFFFV*::.............:VFIIF:.*N$$$$$$$$$
1197 $$$$$$$$$$$$$$$N*.:N$$N........I$$$$$$$NV:......*NNV:...:FIIFFV:................:VFIIF*.:N$$$$$$$$$$
1198 $$$$$$$$$$$$$$N*.:N$$N:........V$$$$$I*........*I*......******:...:*IIIIIIIIIIIIIIIIF:.:N$$$$$$$$$$$
1199 $$$$$$$$$$$$$$*.:M$$N*.........*$$$I*.........**:.................:VFIIFFFFIFFFFFIIF*.:M$$$$$$$$$$$$
1200 $$$$$$$$$$$$N*.:N$$N:....*.....:NV:....:..................:*.....:FIIIIFIIFFFFFFFIF*.:N$$$$$$$$$$$$$
1201 $$$$$$$$$$$$*.:M$$$*....:N*....*:....*V:....*IMMMMF.....:*V......*VVVVVVVVVVVFFFIF*.:M$$$$$$$$$$$$$$
1202 $$$$$$$$$$$*.:M$$N*....:M$V.......:VMN:....:N$$$$N:...*VFI*.................*FFIF*.:M$$$$$$$$$$$$$$$
1203 $$$$$$$$$$V.:M$$$F*****I$$N******VM$$F*****M$$$$$*..:VIIIFF***::::::::::::**FFFI*.:I$$$$$$$$$$$$$$$$
1204 $$$$$$$$$*.:M$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$V.*VIFFFFFIIIIFIFIIIIIIIIIIIIFI*.:M$$$$$$$$$$$$$$$$$
1205 $$$$$$$$$:.*FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF:*VVVVVVVVVVVVVVVVVVVVVVVVVVVV*..I$$$$$$$$$$$$$$$$$$
1206 $$$$$$$$$MV********************************************************************VM$$$$$$$$$$$$$$$$$$$
1207 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
1208  * @dev MetaChamps contract Extends ERC721 Token
1209  */
1210 
1211 contract MetaChamps is ERC721, ERC721Enumerable, Ownable {
1212 
1213     using Strings for uint256;
1214 
1215     uint256 public salePrice = 0.23 ether;
1216     uint256 public MAX_SUPPLY = 300;
1217     bool public saleIsActive = false;
1218 
1219     constructor() ERC721("MetaChamps", "CHAMPS") {
1220     }
1221 
1222     function toggleSaleState() public onlyOwner {
1223         saleIsActive = !saleIsActive;
1224     }
1225 
1226     function setPrice(uint _salePrice) public onlyOwner {
1227         salePrice = _salePrice;
1228     }
1229 
1230     function mint() public payable {
1231         require(saleIsActive, "Sale must be active!");
1232         require(totalSupply() + 1 <= MAX_SUPPLY, "Mint would exceed max supply");
1233         require(salePrice <= msg.value, "Not enough Ether sent");
1234         require(this.balanceOf(msg.sender) == 0, "Limit 1 per wallet");
1235         uint mintIndex = totalSupply();
1236         if (totalSupply() < MAX_SUPPLY) {
1237             _safeMint(msg.sender, mintIndex);
1238         }
1239     }
1240 
1241     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1242         super._beforeTokenTransfer(from, to, tokenId);
1243     }
1244 
1245     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1246         return super.supportsInterface(interfaceId);
1247     }
1248 
1249     function withdraw() public onlyOwner {
1250         uint balance = address(this).balance;
1251         payable(msg.sender).transfer(balance);
1252     }
1253 
1254     string private _baseURIextension;
1255 
1256     function setBaseURI(string memory baseURI_) external onlyOwner() {
1257         _baseURIextension = baseURI_;
1258     }
1259 
1260     function _baseURI() internal view virtual override returns (string memory) {
1261         return _baseURIextension;
1262     }
1263 
1264     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1265         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1266 
1267         if (tokenURIExternal != address(0)) {
1268             return ERC721(tokenURIExternal).tokenURI(tokenId);
1269         }
1270 
1271         string memory baseURI = _baseURI();
1272         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1273     }
1274 
1275     // Allow metadata to be brought on-chain through another smart contract
1276     address private tokenURIExternal;
1277 
1278     function updateTokenURIExternal(address _tokenURIExternal) public onlyOwner {
1279         tokenURIExternal = _tokenURIExternal;
1280     }
1281 }