1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 /**
5  * @dev String operations.
6  */
7 library Strings {
8     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
9 
10     /**
11      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12      */
13     function toString(uint256 value) internal pure returns (string memory) {
14         // Inspired by OraclizeAPI's implementation - MIT licence
15         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16 
17         if (value == 0) {
18             return "0";
19         }
20         uint256 temp = value;
21         uint256 digits;
22         while (temp != 0) {
23             digits++;
24             temp /= 10;
25         }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 }
66 
67 /**
68  * @dev Provides information about the current execution context, including the
69  * sender of the transaction and its data. While these are generally available
70  * via msg.sender and msg.data, they should not be accessed in such a direct
71  * manner, since when dealing with meta-transactions the account sending and
72  * paying for execution may not be the actual sender (as far as an application
73  * is concerned).
74  *
75  * This contract is only required for intermediate, library-like contracts.
76  */
77 abstract contract Context {
78     function _msgSender() internal view virtual returns (address) {
79         return msg.sender;
80     }
81 
82     function _msgData() internal view virtual returns (bytes calldata) {
83         return msg.data;
84     }
85 }
86 
87 /**
88  * @dev Contract module which provides a basic access control mechanism, where
89  * there is an account (an owner) that can be granted exclusive access to
90  * specific functions.
91  *
92  * By default, the owner account will be the one that deploys the contract. This
93  * can later be changed with {transferOwnership}.
94  *
95  * This module is used through inheritance. It will make available the modifier
96  * `onlyOwner`, which can be applied to your functions to restrict their use to
97  * the owner.
98  */
99 abstract contract Ownable is Context {
100     address private _owner;
101 
102     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
103 
104     /**
105      * @dev Initializes the contract setting the deployer as the initial owner.
106      */
107     constructor() {
108         _transferOwnership(_msgSender());
109     }
110 
111     /**
112      * @dev Returns the address of the current owner.
113      */
114     function owner() public view virtual returns (address) {
115         return _owner;
116     }
117 
118     /**
119      * @dev Throws if called by any account other than the owner.
120      */
121     modifier onlyOwner() {
122         require(owner() == _msgSender(), "Ownable: caller is not the owner");
123         _;
124     }
125 
126     /**
127      * @dev Leaves the contract without owner. It will not be possible to call
128      * `onlyOwner` functions anymore. Can only be called by the current owner.
129      *
130      * NOTE: Renouncing ownership will leave the contract without an owner,
131      * thereby removing any functionality that is only available to the owner.
132      */
133     function renounceOwnership() public virtual onlyOwner {
134         _transferOwnership(address(0));
135     }
136 
137     /**
138      * @dev Transfers ownership of the contract to a new account (`newOwner`).
139      * Can only be called by the current owner.
140      */
141     function transferOwnership(address newOwner) public virtual onlyOwner {
142         require(newOwner != address(0), "Ownable: new owner is the zero address");
143         _transferOwnership(newOwner);
144     }
145 
146     /**
147      * @dev Transfers ownership of the contract to a new account (`newOwner`).
148      * Internal function without access restriction.
149      */
150     function _transferOwnership(address newOwner) internal virtual {
151         address oldOwner = _owner;
152         _owner = newOwner;
153         emit OwnershipTransferred(oldOwner, newOwner);
154     }
155 }
156 
157 /**
158  * @dev Collection of functions related to the address type
159  */
160 library Address {
161     /**
162      * @dev Returns true if `account` is a contract.
163      *
164      * [IMPORTANT]
165      * ====
166      * It is unsafe to assume that an address for which this function returns
167      * false is an externally-owned account (EOA) and not a contract.
168      *
169      * Among others, `isContract` will return false for the following
170      * types of addresses:
171      *
172      *  - an externally-owned account
173      *  - a contract in construction
174      *  - an address where a contract will be created
175      *  - an address where a contract lived, but was destroyed
176      * ====
177      */
178     function isContract(address account) internal view returns (bool) {
179         // This method relies on extcodesize, which returns 0 for contracts in
180         // construction, since the code is only stored at the end of the
181         // constructor execution.
182 
183         uint256 size;
184         assembly {
185             size := extcodesize(account)
186         }
187         return size > 0;
188     }
189 
190     /**
191      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
192      * `recipient`, forwarding all available gas and reverting on errors.
193      *
194      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
195      * of certain opcodes, possibly making contracts go over the 2300 gas limit
196      * imposed by `transfer`, making them unable to receive funds via
197      * `transfer`. {sendValue} removes this limitation.
198      *
199      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
200      *
201      * IMPORTANT: because control is transferred to `recipient`, care must be
202      * taken to not create reentrancy vulnerabilities. Consider using
203      * {ReentrancyGuard} or the
204      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
205      */
206     function sendValue(address payable recipient, uint256 amount) internal {
207         require(address(this).balance >= amount, "Address: insufficient balance");
208 
209         (bool success, ) = recipient.call{value: amount}("");
210         require(success, "Address: unable to send value, recipient may have reverted");
211     }
212 
213     /**
214      * @dev Performs a Solidity function call using a low level `call`. A
215      * plain `call` is an unsafe replacement for a function call: use this
216      * function instead.
217      *
218      * If `target` reverts with a revert reason, it is bubbled up by this
219      * function (like regular Solidity function calls).
220      *
221      * Returns the raw returned data. To convert to the expected return value,
222      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
223      *
224      * Requirements:
225      *
226      * - `target` must be a contract.
227      * - calling `target` with `data` must not revert.
228      *
229      * _Available since v3.1._
230      */
231     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
232         return functionCall(target, data, "Address: low-level call failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
237      * `errorMessage` as a fallback revert reason when `target` reverts.
238      *
239      * _Available since v3.1._
240      */
241     function functionCall(
242         address target,
243         bytes memory data,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         return functionCallWithValue(target, data, 0, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but also transferring `value` wei to `target`.
252      *
253      * Requirements:
254      *
255      * - the calling contract must have an ETH balance of at least `value`.
256      * - the called Solidity function must be `payable`.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(
261         address target,
262         bytes memory data,
263         uint256 value
264     ) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
270      * with `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCallWithValue(
275         address target,
276         bytes memory data,
277         uint256 value,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         require(address(this).balance >= value, "Address: insufficient balance for call");
281         require(isContract(target), "Address: call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.call{value: value}(data);
284         return verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but performing a static call.
290      *
291      * _Available since v3.3._
292      */
293     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
294         return functionStaticCall(target, data, "Address: low-level static call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
299      * but performing a static call.
300      *
301      * _Available since v3.3._
302      */
303     function functionStaticCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal view returns (bytes memory) {
308         require(isContract(target), "Address: static call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.staticcall(data);
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a delegate call.
317      *
318      * _Available since v3.4._
319      */
320     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a delegate call.
327      *
328      * _Available since v3.4._
329      */
330     function functionDelegateCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         require(isContract(target), "Address: delegate call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.delegatecall(data);
338         return verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
343      * revert reason using the provided one.
344      *
345      * _Available since v4.3._
346      */
347     function verifyCallResult(
348         bool success,
349         bytes memory returndata,
350         string memory errorMessage
351     ) internal pure returns (bytes memory) {
352         if (success) {
353             return returndata;
354         } else {
355             // Look for revert reason and bubble it up if present
356             if (returndata.length > 0) {
357                 // The easiest way to bubble the revert reason is using memory via assembly
358 
359                 assembly {
360                     let returndata_size := mload(returndata)
361                     revert(add(32, returndata), returndata_size)
362                 }
363             } else {
364                 revert(errorMessage);
365             }
366         }
367     }
368 }
369 
370 /**
371  * @title ERC721 token receiver interface
372  * @dev Interface for any contract that wants to support safeTransfers
373  * from ERC721 asset contracts.
374  */
375 interface IERC721Receiver {
376     /**
377      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
378      * by `operator` from `from`, this function is called.
379      *
380      * It must return its Solidity selector to confirm the token transfer.
381      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
382      *
383      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
384      */
385     function onERC721Received(
386         address operator,
387         address from,
388         uint256 tokenId,
389         bytes calldata data
390     ) external returns (bytes4);
391 }
392 
393 /**
394  * @dev Interface of the ERC165 standard, as defined in the
395  * https://eips.ethereum.org/EIPS/eip-165[EIP].
396  *
397  * Implementers can declare support of contract interfaces, which can then be
398  * queried by others ({ERC165Checker}).
399  *
400  * For an implementation, see {ERC165}.
401  */
402 interface IERC165 {
403     /**
404      * @dev Returns true if this contract implements the interface defined by
405      * `interfaceId`. See the corresponding
406      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
407      * to learn more about how these ids are created.
408      *
409      * This function call must use less than 30 000 gas.
410      */
411     function supportsInterface(bytes4 interfaceId) external view returns (bool);
412 }
413 
414 /**
415  * @dev Implementation of the {IERC165} interface.
416  *
417  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
418  * for the additional interface id that will be supported. For example:
419  *
420  * ```solidity
421  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
422  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
423  * }
424  * ```
425  *
426  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
427  */
428 abstract contract ERC165 is IERC165 {
429     /**
430      * @dev See {IERC165-supportsInterface}.
431      */
432     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
433         return interfaceId == type(IERC165).interfaceId;
434     }
435 }
436 
437 /**
438  * @dev Required interface of an ERC721 compliant contract.
439  */
440 interface IERC721 is IERC165 {
441     /**
442      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
443      */
444     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
445 
446     /**
447      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
448      */
449     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
450 
451     /**
452      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
453      */
454     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
455 
456     /**
457      * @dev Returns the number of tokens in ``owner``'s account.
458      */
459     function balanceOf(address owner) external view returns (uint256 balance);
460 
461     /**
462      * @dev Returns the owner of the `tokenId` token.
463      *
464      * Requirements:
465      *
466      * - `tokenId` must exist.
467      */
468     function ownerOf(uint256 tokenId) external view returns (address owner);
469 
470     /**
471      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
472      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must exist and be owned by `from`.
479      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
480      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
481      *
482      * Emits a {Transfer} event.
483      */
484     function safeTransferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external;
489 
490     /**
491      * @dev Transfers `tokenId` token from `from` to `to`.
492      *
493      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
494      *
495      * Requirements:
496      *
497      * - `from` cannot be the zero address.
498      * - `to` cannot be the zero address.
499      * - `tokenId` token must be owned by `from`.
500      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
501      *
502      * Emits a {Transfer} event.
503      */
504     function transferFrom(
505         address from,
506         address to,
507         uint256 tokenId
508     ) external;
509 
510     /**
511      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
512      * The approval is cleared when the token is transferred.
513      *
514      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
515      *
516      * Requirements:
517      *
518      * - The caller must own the token or be an approved operator.
519      * - `tokenId` must exist.
520      *
521      * Emits an {Approval} event.
522      */
523     function approve(address to, uint256 tokenId) external;
524 
525     /**
526      * @dev Returns the account approved for `tokenId` token.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function getApproved(uint256 tokenId) external view returns (address operator);
533 
534     /**
535      * @dev Approve or remove `operator` as an operator for the caller.
536      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
537      *
538      * Requirements:
539      *
540      * - The `operator` cannot be the caller.
541      *
542      * Emits an {ApprovalForAll} event.
543      */
544     function setApprovalForAll(address operator, bool _approved) external;
545 
546     /**
547      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
548      *
549      * See {setApprovalForAll}
550      */
551     function isApprovedForAll(address owner, address operator) external view returns (bool);
552 
553     /**
554      * @dev Safely transfers `tokenId` token from `from` to `to`.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
563      *
564      * Emits a {Transfer} event.
565      */
566     function safeTransferFrom(
567         address from,
568         address to,
569         uint256 tokenId,
570         bytes calldata data
571     ) external;
572 }
573 
574 /**
575  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
576  * @dev See https://eips.ethereum.org/EIPS/eip-721
577  */
578 interface IERC721Metadata is IERC721 {
579     /**
580      * @dev Returns the token collection name.
581      */
582     function name() external view returns (string memory);
583 
584     /**
585      * @dev Returns the token collection symbol.
586      */
587     function symbol() external view returns (string memory);
588 
589     /**
590      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
591      */
592     function tokenURI(uint256 tokenId) external view returns (string memory);
593 }
594 
595 /**
596  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
597  * the Metadata extension, but not including the Enumerable extension, which is available separately as
598  * {ERC721Enumerable}.
599  */
600 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
601     using Address for address;
602     using Strings for uint256;
603 
604     // Token name
605     string private _name;
606 
607     // Token symbol
608     string private _symbol;
609 
610     // Mapping from token ID to owner address
611     mapping(uint256 => address) private _owners;
612 
613     // Mapping owner address to token count
614     mapping(address => uint256) private _balances;
615 
616     // Mapping from token ID to approved address
617     mapping(uint256 => address) private _tokenApprovals;
618 
619     // Mapping from owner to operator approvals
620     mapping(address => mapping(address => bool)) private _operatorApprovals;
621 
622     /**
623      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
624      */
625     constructor(string memory name_, string memory symbol_) {
626         _name = name_;
627         _symbol = symbol_;
628     }
629 
630     /**
631      * @dev See {IERC165-supportsInterface}.
632      */
633     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
634         return
635             interfaceId == type(IERC721).interfaceId ||
636             interfaceId == type(IERC721Metadata).interfaceId ||
637             super.supportsInterface(interfaceId);
638     }
639 
640     /**
641      * @dev See {IERC721-balanceOf}.
642      */
643     function balanceOf(address owner) public view virtual override returns (uint256) {
644         require(owner != address(0), "ERC721: balance query for the zero address");
645         return _balances[owner];
646     }
647 
648     /**
649      * @dev See {IERC721-ownerOf}.
650      */
651     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
652         address owner = _owners[tokenId];
653         require(owner != address(0), "ERC721: owner query for nonexistent token");
654         return owner;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-name}.
659      */
660     function name() public view virtual override returns (string memory) {
661         return _name;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-symbol}.
666      */
667     function symbol() public view virtual override returns (string memory) {
668         return _symbol;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-tokenURI}.
673      */
674     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
675         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
676 
677         string memory baseURI = _baseURI();
678         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
679     }
680 
681     /**
682      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
683      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
684      * by default, can be overriden in child contracts.
685      */
686     function _baseURI() internal view virtual returns (string memory) {
687         return "";
688     }
689 
690     /**
691      * @dev See {IERC721-approve}.
692      */
693     function approve(address to, uint256 tokenId) public virtual override {
694         address owner = ERC721.ownerOf(tokenId);
695         require(to != owner, "ERC721: approval to current owner");
696 
697         require(
698             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
699             "ERC721: approve caller is not owner nor approved for all"
700         );
701 
702         _approve(to, tokenId);
703     }
704 
705     /**
706      * @dev See {IERC721-getApproved}.
707      */
708     function getApproved(uint256 tokenId) public view virtual override returns (address) {
709         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
710 
711         return _tokenApprovals[tokenId];
712     }
713 
714     /**
715      * @dev See {IERC721-setApprovalForAll}.
716      */
717     function setApprovalForAll(address operator, bool approved) public virtual override {
718         _setApprovalForAll(_msgSender(), operator, approved);
719     }
720 
721     /**
722      * @dev See {IERC721-isApprovedForAll}.
723      */
724     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
725         return _operatorApprovals[owner][operator];
726     }
727 
728     /**
729      * @dev See {IERC721-transferFrom}.
730      */
731     function transferFrom(
732         address from,
733         address to,
734         uint256 tokenId
735     ) public virtual override {
736         //solhint-disable-next-line max-line-length
737         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
738 
739         _transfer(from, to, tokenId);
740     }
741 
742     /**
743      * @dev See {IERC721-safeTransferFrom}.
744      */
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 tokenId
749     ) public virtual override {
750         safeTransferFrom(from, to, tokenId, "");
751     }
752 
753     /**
754      * @dev See {IERC721-safeTransferFrom}.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes memory _data
761     ) public virtual override {
762         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
763         _safeTransfer(from, to, tokenId, _data);
764     }
765 
766     /**
767      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
768      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
769      *
770      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
771      *
772      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
773      * implement alternative mechanisms to perform token transfer, such as signature-based.
774      *
775      * Requirements:
776      *
777      * - `from` cannot be the zero address.
778      * - `to` cannot be the zero address.
779      * - `tokenId` token must exist and be owned by `from`.
780      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _safeTransfer(
785         address from,
786         address to,
787         uint256 tokenId,
788         bytes memory _data
789     ) internal virtual {
790         _transfer(from, to, tokenId);
791         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
792     }
793 
794     /**
795      * @dev Returns whether `tokenId` exists.
796      *
797      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
798      *
799      * Tokens start existing when they are minted (`_mint`),
800      * and stop existing when they are burned (`_burn`).
801      */
802     function _exists(uint256 tokenId) internal view virtual returns (bool) {
803         return _owners[tokenId] != address(0);
804     }
805 
806     /**
807      * @dev Returns whether `spender` is allowed to manage `tokenId`.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must exist.
812      */
813     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
814         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
815         address owner = ERC721.ownerOf(tokenId);
816         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
817     }
818 
819     /**
820      * @dev Safely mints `tokenId` and transfers it to `to`.
821      *
822      * Requirements:
823      *
824      * - `tokenId` must not exist.
825      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
826      *
827      * Emits a {Transfer} event.
828      */
829     function _safeMint(address to, uint256 tokenId) internal virtual {
830         _safeMint(to, tokenId, "");
831     }
832 
833     /**
834      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
835      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
836      */
837     function _safeMint(
838         address to,
839         uint256 tokenId,
840         bytes memory _data
841     ) internal virtual {
842         _mint(to, tokenId);
843         require(
844             _checkOnERC721Received(address(0), to, tokenId, _data),
845             "ERC721: transfer to non ERC721Receiver implementer"
846         );
847     }
848 
849     /**
850      * @dev Mints `tokenId` and transfers it to `to`.
851      *
852      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
853      *
854      * Requirements:
855      *
856      * - `tokenId` must not exist.
857      * - `to` cannot be the zero address.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _mint(address to, uint256 tokenId) internal virtual {
862         require(to != address(0), "ERC721: mint to the zero address");
863         require(!_exists(tokenId), "ERC721: token already minted");
864 
865         _beforeTokenTransfer(address(0), to, tokenId);
866 
867         _balances[to] += 1;
868         _owners[tokenId] = to;
869 
870         emit Transfer(address(0), to, tokenId);
871     }
872 
873     /**
874      * @dev Destroys `tokenId`.
875      * The approval is cleared when the token is burned.
876      *
877      * Requirements:
878      *
879      * - `tokenId` must exist.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _burn(uint256 tokenId) internal virtual {
884         address owner = ERC721.ownerOf(tokenId);
885 
886         _beforeTokenTransfer(owner, address(0), tokenId);
887 
888         // Clear approvals
889         _approve(address(0), tokenId);
890 
891         _balances[owner] -= 1;
892         delete _owners[tokenId];
893 
894         emit Transfer(owner, address(0), tokenId);
895     }
896 
897     /**
898      * @dev Transfers `tokenId` from `from` to `to`.
899      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
900      *
901      * Requirements:
902      *
903      * - `to` cannot be the zero address.
904      * - `tokenId` token must be owned by `from`.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _transfer(
909         address from,
910         address to,
911         uint256 tokenId
912     ) internal virtual {
913         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
914         require(to != address(0), "ERC721: transfer to the zero address");
915 
916         _beforeTokenTransfer(from, to, tokenId);
917 
918         // Clear approvals from the previous owner
919         _approve(address(0), tokenId);
920 
921         _balances[from] -= 1;
922         _balances[to] += 1;
923         _owners[tokenId] = to;
924 
925         emit Transfer(from, to, tokenId);
926     }
927 
928     /**
929      * @dev Approve `to` to operate on `tokenId`
930      *
931      * Emits a {Approval} event.
932      */
933     function _approve(address to, uint256 tokenId) internal virtual {
934         _tokenApprovals[tokenId] = to;
935         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
936     }
937 
938     /**
939      * @dev Approve `operator` to operate on all of `owner` tokens
940      *
941      * Emits a {ApprovalForAll} event.
942      */
943     function _setApprovalForAll(
944         address owner,
945         address operator,
946         bool approved
947     ) internal virtual {
948         require(owner != operator, "ERC721: approve to caller");
949         _operatorApprovals[owner][operator] = approved;
950         emit ApprovalForAll(owner, operator, approved);
951     }
952 
953     /**
954      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
955      * The call is not executed if the target address is not a contract.
956      *
957      * @param from address representing the previous owner of the given token ID
958      * @param to target address that will receive the tokens
959      * @param tokenId uint256 ID of the token to be transferred
960      * @param _data bytes optional data to send along with the call
961      * @return bool whether the call correctly returned the expected magic value
962      */
963     function _checkOnERC721Received(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) private returns (bool) {
969         if (to.isContract()) {
970             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
971                 return retval == IERC721Receiver.onERC721Received.selector;
972             } catch (bytes memory reason) {
973                 if (reason.length == 0) {
974                     revert("ERC721: transfer to non ERC721Receiver implementer");
975                 } else {
976                     assembly {
977                         revert(add(32, reason), mload(reason))
978                     }
979                 }
980             }
981         } else {
982             return true;
983         }
984     }
985 
986     /**
987      * @dev Hook that is called before any token transfer. This includes minting
988      * and burning.
989      *
990      * Calling conditions:
991      *
992      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
993      * transferred to `to`.
994      * - When `from` is zero, `tokenId` will be minted for `to`.
995      * - When `to` is zero, ``from``'s `tokenId` will be burned.
996      * - `from` and `to` are never both zero.
997      *
998      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
999      */
1000     function _beforeTokenTransfer(
1001         address from,
1002         address to,
1003         uint256 tokenId
1004     ) internal virtual {}
1005 }
1006 
1007 contract OwnableDelegateProxy {}
1008 
1009 contract ProxyRegistry {
1010     mapping(address => OwnableDelegateProxy) public proxies;
1011 }
1012 
1013 contract Dogdles is Ownable, ERC721 {
1014     uint256 public constant TOTAL_MAX_QTY = 3333;
1015     uint256 public constant FREE_MINT_MAX_QTY = 333;
1016     uint256 public constant GIFT_MAX_QTY = 10;
1017     uint256 public constant TOTAL_MINT_MAX_QTY = TOTAL_MAX_QTY - GIFT_MAX_QTY;
1018     uint256 public constant PRICE = 0.039 ether;
1019     uint256 public constant MAX_QTY_PER_WALLET = 15;
1020     string private _tokenBaseURI;
1021     uint256 public maxFreeQtyPerWallet = 1;
1022     uint256 public mintedQty = 0;
1023     uint256 public giftedQty = 0;
1024     mapping(address => uint256) public minterToTokenQty;
1025     address proxyRegistryAddress;
1026 
1027     constructor() ERC721("Dogdles", "DOGS") {
1028         if(block.chainid == 0) {
1029             proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1030         }
1031         else if(block.chainid == 4) {
1032             proxyRegistryAddress = 0xF57B2c51dED3A29e6891aba85459d600256Cf317;
1033         }
1034     }
1035 
1036     function totalSupply() public view returns (uint256) {
1037         return mintedQty + giftedQty;
1038     }
1039 
1040     function mint(uint256 _mintQty) external payable {
1041         // free
1042         if (mintedQty < FREE_MINT_MAX_QTY) {
1043             require(mintedQty + _mintQty <= FREE_MINT_MAX_QTY, "MAXL");
1044             require(minterToTokenQty[msg.sender] + _mintQty <= maxFreeQtyPerWallet, "MAXF");
1045         }
1046         //paid
1047         else {
1048             require(mintedQty + _mintQty <= TOTAL_MINT_MAX_QTY, "MAXL");
1049             require(minterToTokenQty[msg.sender] + _mintQty <= MAX_QTY_PER_WALLET, "MAXP");
1050             require(msg.value >= PRICE * _mintQty, "SETH");
1051         }
1052         uint256 totalSupplyBefore = totalSupply();
1053         mintedQty += _mintQty;
1054         minterToTokenQty[msg.sender] += _mintQty;
1055         for (uint256 i = 0; i < _mintQty; i++) {
1056             _mint(msg.sender, ++totalSupplyBefore);
1057         }
1058     }
1059 
1060     function gift(address[] calldata receivers) external onlyOwner {
1061         require(giftedQty + receivers.length <= GIFT_MAX_QTY, "MAXG");
1062 
1063         uint256 totalSupplyBefore = totalSupply();
1064         giftedQty += receivers.length;
1065         for (uint256 i = 0; i < receivers.length; i++) {
1066             _mint(receivers[i], ++totalSupplyBefore);
1067         }
1068     }
1069 
1070     function withdrawAll() external onlyOwner {
1071         require(address(this).balance > 0, "ZERO");
1072         payable(msg.sender).transfer(address(this).balance);
1073     }
1074 
1075     function setMaxFreeQtyPerTx(uint256 _maxQtyPerTx) external onlyOwner {
1076         maxFreeQtyPerWallet = _maxQtyPerTx;
1077     }
1078 
1079     function setProxyRegistryAddress(address proxyAddress) external onlyOwner {
1080         proxyRegistryAddress = proxyAddress;
1081     }
1082 
1083     function isApprovedForAll(address owner, address operator)
1084         public
1085         view
1086         override
1087         returns (bool)
1088     {
1089         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1090         if (address(proxyRegistry.proxies(owner)) == operator) {
1091             return true;
1092         }
1093 
1094         return super.isApprovedForAll(owner, operator);
1095     }
1096 
1097     function setBaseURI(string calldata URI) external onlyOwner {
1098         _tokenBaseURI = URI;
1099     }
1100 
1101     function _baseURI() internal view override(ERC721) returns (string memory) {
1102         return _tokenBaseURI;
1103     }
1104 }