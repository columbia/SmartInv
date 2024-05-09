1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
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
68  * @dev Collection of functions related to the address type
69  */
70 library Address {
71     /**
72      * @dev Returns true if `account` is a contract.
73      *
74      * [IMPORTANT]
75      * ====
76      * It is unsafe to assume that an address for which this function returns
77      * false is an externally-owned account (EOA) and not a contract.
78      *
79      * Among others, `isContract` will return false for the following
80      * types of addresses:
81      *
82      *  - an externally-owned account
83      *  - a contract in construction
84      *  - an address where a contract will be created
85      *  - an address where a contract lived, but was destroyed
86      * ====
87      */
88     function isContract(address account) internal view returns (bool) {
89         // This method relies on extcodesize, which returns 0 for contracts in
90         // construction, since the code is only stored at the end of the
91         // constructor execution.
92 
93         uint256 size;
94         assembly {
95             size := extcodesize(account)
96         }
97         return size > 0;
98     }
99 
100     /**
101      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
102      * `recipient`, forwarding all available gas and reverting on errors.
103      *
104      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
105      * of certain opcodes, possibly making contracts go over the 2300 gas limit
106      * imposed by `transfer`, making them unable to receive funds via
107      * `transfer`. {sendValue} removes this limitation.
108      *
109      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
110      *
111      * IMPORTANT: because control is transferred to `recipient`, care must be
112      * taken to not create reentrancy vulnerabilities. Consider using
113      * {ReentrancyGuard} or the
114      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
115      */
116     function sendValue(address payable recipient, uint256 amount) internal {
117         require(address(this).balance >= amount, "Address: insufficient balance");
118 
119         (bool success, ) = recipient.call{value: amount}("");
120         require(success, "Address: unable to send value, recipient may have reverted");
121     }
122 
123     /**
124      * @dev Performs a Solidity function call using a low level `call`. A
125      * plain `call` is an unsafe replacement for a function call: use this
126      * function instead.
127      *
128      * If `target` reverts with a revert reason, it is bubbled up by this
129      * function (like regular Solidity function calls).
130      *
131      * Returns the raw returned data. To convert to the expected return value,
132      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
133      *
134      * Requirements:
135      *
136      * - `target` must be a contract.
137      * - calling `target` with `data` must not revert.
138      *
139      * _Available since v3.1._
140      */
141     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
142         return functionCall(target, data, "Address: low-level call failed");
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
147      * `errorMessage` as a fallback revert reason when `target` reverts.
148      *
149      * _Available since v3.1._
150      */
151     function functionCall(
152         address target,
153         bytes memory data,
154         string memory errorMessage
155     ) internal returns (bytes memory) {
156         return functionCallWithValue(target, data, 0, errorMessage);
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
161      * but also transferring `value` wei to `target`.
162      *
163      * Requirements:
164      *
165      * - the calling contract must have an ETH balance of at least `value`.
166      * - the called Solidity function must be `payable`.
167      *
168      * _Available since v3.1._
169      */
170     function functionCallWithValue(
171         address target,
172         bytes memory data,
173         uint256 value
174     ) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
180      * with `errorMessage` as a fallback revert reason when `target` reverts.
181      *
182      * _Available since v3.1._
183      */
184     function functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 value,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         require(address(this).balance >= value, "Address: insufficient balance for call");
191         require(isContract(target), "Address: call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.call{value: value}(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but performing a static call.
200      *
201      * _Available since v3.3._
202      */
203     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
204         return functionStaticCall(target, data, "Address: low-level static call failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
209      * but performing a static call.
210      *
211      * _Available since v3.3._
212      */
213     function functionStaticCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal view returns (bytes memory) {
218         require(isContract(target), "Address: static call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.staticcall(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a delegate call.
227      *
228      * _Available since v3.4._
229      */
230     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
231         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a delegate call.
237      *
238      * _Available since v3.4._
239      */
240     function functionDelegateCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal returns (bytes memory) {
245         require(isContract(target), "Address: delegate call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.delegatecall(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
253      * revert reason using the provided one.
254      *
255      * _Available since v4.3._
256      */
257     function verifyCallResult(
258         bool success,
259         bytes memory returndata,
260         string memory errorMessage
261     ) internal pure returns (bytes memory) {
262         if (success) {
263             return returndata;
264         } else {
265             // Look for revert reason and bubble it up if present
266             if (returndata.length > 0) {
267                 // The easiest way to bubble the revert reason is using memory via assembly
268 
269                 assembly {
270                     let returndata_size := mload(returndata)
271                     revert(add(32, returndata), returndata_size)
272                 }
273             } else {
274                 revert(errorMessage);
275             }
276         }
277     }
278 }
279 
280 /**
281  * @dev Provides information about the current execution context, including the
282  * sender of the transaction and its data. While these are generally available
283  * via msg.sender and msg.data, they should not be accessed in such a direct
284  * manner, since when dealing with meta-transactions the account sending and
285  * paying for execution may not be the actual sender (as far as an application
286  * is concerned).
287  *
288  * This contract is only required for intermediate, library-like contracts.
289  */
290 abstract contract Context {
291     function _msgSender() internal view virtual returns (address) {
292         return msg.sender;
293     }
294 
295     function _msgData() internal view virtual returns (bytes calldata) {
296         return msg.data;
297     }
298 }
299 
300 /**
301  * @dev Contract module which provides a basic access control mechanism, where
302  * there is an account (an owner) that can be granted exclusive access to
303  * specific functions.
304  *
305  * By default, the owner account will be the one that deploys the contract. This
306  * can later be changed with {transferOwnership}.
307  *
308  * This module is used through inheritance. It will make available the modifier
309  * `onlyOwner`, which can be applied to your functions to restrict their use to
310  * the owner.
311  */
312 abstract contract Ownable is Context {
313     address private _owner;
314 
315     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
316 
317     /**
318      * @dev Initializes the contract setting the deployer as the initial owner.
319      */
320     constructor() {
321         _setOwner(_msgSender());
322     }
323 
324     /**
325      * @dev Returns the address of the current owner.
326      */
327     function owner() public view virtual returns (address) {
328         return _owner;
329     }
330 
331     /**
332      * @dev Throws if called by any account other than the owner.
333      */
334     modifier onlyOwner() {
335         require(owner() == _msgSender(), "Ownable: caller is not the owner");
336         _;
337     }
338 
339     /**
340      * @dev Leaves the contract without owner. It will not be possible to call
341      * `onlyOwner` functions anymore. Can only be called by the current owner.
342      *
343      * NOTE: Renouncing ownership will leave the contract without an owner,
344      * thereby removing any functionality that is only available to the owner.
345      */
346     function renounceOwnership() public virtual onlyOwner {
347         _setOwner(address(0));
348     }
349 
350     /**
351      * @dev Transfers ownership of the contract to a new account (`newOwner`).
352      * Can only be called by the current owner.
353      */
354     function transferOwnership(address newOwner) public virtual onlyOwner {
355         require(newOwner != address(0), "Ownable: new owner is the zero address");
356         _setOwner(newOwner);
357     }
358 
359     function _setOwner(address newOwner) private {
360         address oldOwner = _owner;
361         _owner = newOwner;
362         emit OwnershipTransferred(oldOwner, newOwner);
363     }
364 }
365 
366 /**
367  * @dev Interface of the ERC165 standard, as defined in the
368  * https://eips.ethereum.org/EIPS/eip-165[EIP].
369  *
370  * Implementers can declare support of contract interfaces, which can then be
371  * queried by others ({ERC165Checker}).
372  *
373  * For an implementation, see {ERC165}.
374  */
375 interface IERC165 {
376     /**
377      * @dev Returns true if this contract implements the interface defined by
378      * `interfaceId`. See the corresponding
379      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
380      * to learn more about how these ids are created.
381      *
382      * This function call must use less than 30 000 gas.
383      */
384     function supportsInterface(bytes4 interfaceId) external view returns (bool);
385 }
386 
387 /**
388  * @dev Implementation of the {IERC165} interface.
389  *
390  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
391  * for the additional interface id that will be supported. For example:
392  *
393  * ```solidity
394  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
395  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
396  * }
397  * ```
398  *
399  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
400  */
401 abstract contract ERC165 is IERC165 {
402     /**
403      * @dev See {IERC165-supportsInterface}.
404      */
405     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
406         return interfaceId == type(IERC165).interfaceId;
407     }
408 }
409 
410 /**
411  * @dev Required interface of an ERC721 compliant contract.
412  */
413 interface IERC721 is IERC165 {
414     /**
415      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
416      */
417     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
418 
419     /**
420      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
421      */
422     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
423 
424     /**
425      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
426      */
427     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
428 
429     /**
430      * @dev Returns the number of tokens in ``owner``'s account.
431      */
432     function balanceOf(address owner) external view returns (uint256 balance);
433 
434     /**
435      * @dev Returns the owner of the `tokenId` token.
436      *
437      * Requirements:
438      *
439      * - `tokenId` must exist.
440      */
441     function ownerOf(uint256 tokenId) external view returns (address owner);
442 
443     /**
444      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
445      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `tokenId` token must exist and be owned by `from`.
452      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
453      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
454      *
455      * Emits a {Transfer} event.
456      */
457     function safeTransferFrom(
458         address from,
459         address to,
460         uint256 tokenId
461     ) external;
462 
463     /**
464      * @dev Transfers `tokenId` token from `from` to `to`.
465      *
466      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `tokenId` token must be owned by `from`.
473      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
474      *
475      * Emits a {Transfer} event.
476      */
477     function transferFrom(
478         address from,
479         address to,
480         uint256 tokenId
481     ) external;
482 
483     /**
484      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
485      * The approval is cleared when the token is transferred.
486      *
487      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
488      *
489      * Requirements:
490      *
491      * - The caller must own the token or be an approved operator.
492      * - `tokenId` must exist.
493      *
494      * Emits an {Approval} event.
495      */
496     function approve(address to, uint256 tokenId) external;
497 
498     /**
499      * @dev Returns the account approved for `tokenId` token.
500      *
501      * Requirements:
502      *
503      * - `tokenId` must exist.
504      */
505     function getApproved(uint256 tokenId) external view returns (address operator);
506 
507     /**
508      * @dev Approve or remove `operator` as an operator for the caller.
509      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
510      *
511      * Requirements:
512      *
513      * - The `operator` cannot be the caller.
514      *
515      * Emits an {ApprovalForAll} event.
516      */
517     function setApprovalForAll(address operator, bool _approved) external;
518 
519     /**
520      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
521      *
522      * See {setApprovalForAll}
523      */
524     function isApprovedForAll(address owner, address operator) external view returns (bool);
525 
526     /**
527      * @dev Safely transfers `tokenId` token from `from` to `to`.
528      *
529      * Requirements:
530      *
531      * - `from` cannot be the zero address.
532      * - `to` cannot be the zero address.
533      * - `tokenId` token must exist and be owned by `from`.
534      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
535      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
536      *
537      * Emits a {Transfer} event.
538      */
539     function safeTransferFrom(
540         address from,
541         address to,
542         uint256 tokenId,
543         bytes calldata data
544     ) external;
545 }
546 
547 /**
548  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
549  * @dev See https://eips.ethereum.org/EIPS/eip-721
550  */
551 interface IERC721Enumerable is IERC721 {
552     /**
553      * @dev Returns the total amount of tokens stored by the contract.
554      */
555     function totalSupply() external view returns (uint256);
556 
557     /**
558      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
559      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
560      */
561     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
562 
563     /**
564      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
565      * Use along with {totalSupply} to enumerate all tokens.
566      */
567     function tokenByIndex(uint256 index) external view returns (uint256);
568 }
569 
570 interface IERC2981Royalties {
571     /// @notice Called with the sale price to determine how much royalty
572     //          is owed and to whom.
573     /// @param _tokenId - the NFT asset queried for royalty information
574     /// @param _value - the sale price of the NFT asset specified by _tokenId
575     /// @return _receiver - address of who should be sent the royalty payment
576     /// @return _royaltyAmount - the royalty payment amount for value sale price
577     function royaltyInfo(uint256 _tokenId, uint256 _value)
578         external
579         view
580         returns (address _receiver, uint256 _royaltyAmount);
581 }
582 
583 /**
584  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
585  * @dev See https://eips.ethereum.org/EIPS/eip-721
586  */
587 interface IERC721Metadata is IERC721 {
588     /**
589      * @dev Returns the token collection name.
590      */
591     function name() external view returns (string memory);
592 
593     /**
594      * @dev Returns the token collection symbol.
595      */
596     function symbol() external view returns (string memory);
597 
598     /**
599      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
600      */
601     function tokenURI(uint256 tokenId) external view returns (string memory);
602 }
603 
604 /**
605  * @title ERC721 token receiver interface
606  * @dev Interface for any contract that wants to support safeTransfers
607  * from ERC721 asset contracts.
608  */
609 interface IERC721Receiver {
610     /**
611      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
612      * by `operator` from `from`, this function is called.
613      *
614      * It must return its Solidity selector to confirm the token transfer.
615      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
616      *
617      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
618      */
619     function onERC721Received(
620         address operator,
621         address from,
622         uint256 tokenId,
623         bytes calldata data
624     ) external returns (bytes4);
625 }
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
1027 /**
1028  * @dev ERC721 token with storage based token URI management.
1029  */
1030 abstract contract ERC721URIStorage is ERC721 {
1031     using Strings for uint256;
1032 
1033     // Optional mapping for token URIs
1034     mapping(uint256 => string) private _tokenURIs;
1035 
1036     /**
1037      * @dev See {IERC721Metadata-tokenURI}.
1038      */
1039     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1040         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1041 
1042         string memory _tokenURI = _tokenURIs[tokenId];
1043         string memory base = _baseURI();
1044 
1045         // If there is no base URI, return the token URI.
1046         if (bytes(base).length == 0) {
1047             return _tokenURI;
1048         }
1049         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1050         if (bytes(_tokenURI).length > 0) {
1051             return string(abi.encodePacked(base, _tokenURI));
1052         }
1053 
1054         return super.tokenURI(tokenId);
1055     }
1056 
1057     /**
1058      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1059      *
1060      * Requirements:
1061      *
1062      * - `tokenId` must exist.
1063      */
1064     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1065         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1066         _tokenURIs[tokenId] = _tokenURI;
1067     }
1068 
1069     /**
1070      * @dev Destroys `tokenId`.
1071      * The approval is cleared when the token is burned.
1072      *
1073      * Requirements:
1074      *
1075      * - `tokenId` must exist.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _burn(uint256 tokenId) internal virtual override {
1080         super._burn(tokenId);
1081 
1082         if (bytes(_tokenURIs[tokenId]).length != 0) {
1083             delete _tokenURIs[tokenId];
1084         }
1085     }
1086 }
1087 
1088 /**
1089  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1090  * enumerability of all the token ids in the contract as well as all token ids owned by each
1091  * account.
1092  */
1093 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1094     // Mapping from owner to list of owned token IDs
1095     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1096 
1097     // Mapping from token ID to index of the owner tokens list
1098     mapping(uint256 => uint256) private _ownedTokensIndex;
1099 
1100     // Array with all token ids, used for enumeration
1101     uint256[] private _allTokens;
1102 
1103     // Mapping from token id to position in the allTokens array
1104     mapping(uint256 => uint256) private _allTokensIndex;
1105 
1106     /**
1107      * @dev See {IERC165-supportsInterface}.
1108      */
1109     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1110         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1111     }
1112 
1113     /**
1114      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1115      */
1116     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1117         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1118         return _ownedTokens[owner][index];
1119     }
1120 
1121     /**
1122      * @dev See {IERC721Enumerable-totalSupply}.
1123      */
1124     function totalSupply() public view virtual override returns (uint256) {
1125         return _allTokens.length;
1126     }
1127 
1128     /**
1129      * @dev See {IERC721Enumerable-tokenByIndex}.
1130      */
1131     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1132         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1133         return _allTokens[index];
1134     }
1135 
1136     /**
1137      * @dev Hook that is called before any token transfer. This includes minting
1138      * and burning.
1139      *
1140      * Calling conditions:
1141      *
1142      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1143      * transferred to `to`.
1144      * - When `from` is zero, `tokenId` will be minted for `to`.
1145      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1146      * - `from` cannot be the zero address.
1147      * - `to` cannot be the zero address.
1148      *
1149      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1150      */
1151     function _beforeTokenTransfer(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) internal virtual override {
1156         super._beforeTokenTransfer(from, to, tokenId);
1157 
1158         if (from == address(0)) {
1159             _addTokenToAllTokensEnumeration(tokenId);
1160         } else if (from != to) {
1161             _removeTokenFromOwnerEnumeration(from, tokenId);
1162         }
1163         if (to == address(0)) {
1164             _removeTokenFromAllTokensEnumeration(tokenId);
1165         } else if (to != from) {
1166             _addTokenToOwnerEnumeration(to, tokenId);
1167         }
1168     }
1169 
1170     /**
1171      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1172      * @param to address representing the new owner of the given token ID
1173      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1174      */
1175     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1176         uint256 length = ERC721.balanceOf(to);
1177         _ownedTokens[to][length] = tokenId;
1178         _ownedTokensIndex[tokenId] = length;
1179     }
1180 
1181     /**
1182      * @dev Private function to add a token to this extension's token tracking data structures.
1183      * @param tokenId uint256 ID of the token to be added to the tokens list
1184      */
1185     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1186         _allTokensIndex[tokenId] = _allTokens.length;
1187         _allTokens.push(tokenId);
1188     }
1189 
1190     /**
1191      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1192      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1193      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1194      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1195      * @param from address representing the previous owner of the given token ID
1196      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1197      */
1198     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1199         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1200         // then delete the last slot (swap and pop).
1201 
1202         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1203         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1204 
1205         // When the token to delete is the last token, the swap operation is unnecessary
1206         if (tokenIndex != lastTokenIndex) {
1207             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1208 
1209             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1210             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1211         }
1212 
1213         // This also deletes the contents at the last position of the array
1214         delete _ownedTokensIndex[tokenId];
1215         delete _ownedTokens[from][lastTokenIndex];
1216     }
1217 
1218     /**
1219      * @dev Private function to remove a token from this extension's token tracking data structures.
1220      * This has O(1) time complexity, but alters the order of the _allTokens array.
1221      * @param tokenId uint256 ID of the token to be removed from the tokens list
1222      */
1223     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1224         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1225         // then delete the last slot (swap and pop).
1226 
1227         uint256 lastTokenIndex = _allTokens.length - 1;
1228         uint256 tokenIndex = _allTokensIndex[tokenId];
1229 
1230         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1231         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1232         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1233         uint256 lastTokenId = _allTokens[lastTokenIndex];
1234 
1235         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1236         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1237 
1238         // This also deletes the contents at the last position of the array
1239         delete _allTokensIndex[tokenId];
1240         _allTokens.pop();
1241     }
1242 }
1243 
1244 /**
1245  * @dev Interface of the ERC20 standard as defined in the EIP.
1246  */
1247 interface IERC20 {
1248     /**
1249      * @dev Returns the amount of tokens in existence.
1250      */
1251     function totalSupply() external view returns (uint256);
1252 
1253     /**
1254      * @dev Returns the amount of tokens owned by `account`.
1255      */
1256     function balanceOf(address account) external view returns (uint256);
1257 
1258     /**
1259      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1260      *
1261      * Returns a boolean value indicating whether the operation succeeded.
1262      *
1263      * Emits a {Transfer} event.
1264      */
1265     function transfer(address recipient, uint256 amount) external returns (bool);
1266 
1267     /**
1268      * @dev Returns the remaining number of tokens that `spender` will be
1269      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1270      * zero by default.
1271      *
1272      * This value changes when {approve} or {transferFrom} are called.
1273      */
1274     function allowance(address owner, address spender) external view returns (uint256);
1275 
1276     /**
1277      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1278      *
1279      * Returns a boolean value indicating whether the operation succeeded.
1280      *
1281      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1282      * that someone may use both the old and the new allowance by unfortunate
1283      * transaction ordering. One possible solution to mitigate this race
1284      * condition is to first reduce the spender's allowance to 0 and set the
1285      * desired value afterwards:
1286      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1287      *
1288      * Emits an {Approval} event.
1289      */
1290     function approve(address spender, uint256 amount) external returns (bool);
1291 
1292     /**
1293      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1294      * allowance mechanism. `amount` is then deducted from the caller's
1295      * allowance.
1296      *
1297      * Returns a boolean value indicating whether the operation succeeded.
1298      *
1299      * Emits a {Transfer} event.
1300      */
1301     function transferFrom(
1302         address sender,
1303         address recipient,
1304         uint256 amount
1305     ) external returns (bool);
1306 
1307     /**
1308      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1309      * another (`to`).
1310      *
1311      * Note that `value` may be zero.
1312      */
1313     event Transfer(address indexed from, address indexed to, uint256 value);
1314 
1315     /**
1316      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1317      * a call to {approve}. `value` is the new allowance.
1318      */
1319     event Approval(address indexed owner, address indexed spender, uint256 value);
1320 }
1321 
1322 /**
1323  * @dev Interface for the optional metadata functions from the ERC20 standard.
1324  *
1325  * _Available since v4.1._
1326  */
1327 interface IERC20Metadata is IERC20 {
1328     /**
1329      * @dev Returns the name of the token.
1330      */
1331     function name() external view returns (string memory);
1332 
1333     /**
1334      * @dev Returns the symbol of the token.
1335      */
1336     function symbol() external view returns (string memory);
1337 
1338     /**
1339      * @dev Returns the decimals places of the token.
1340      */
1341     function decimals() external view returns (uint8);
1342 }
1343 
1344 /**
1345  * @dev Implementation of the {IERC20} interface.
1346  *
1347  * This implementation is agnostic to the way tokens are created. This means
1348  * that a supply mechanism has to be added in a derived contract using {_mint}.
1349  * For a generic mechanism see {ERC20PresetMinterPauser}.
1350  *
1351  * TIP: For a detailed writeup see our guide
1352  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1353  * to implement supply mechanisms].
1354  *
1355  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1356  * instead returning `false` on failure. This behavior is nonetheless
1357  * conventional and does not conflict with the expectations of ERC20
1358  * applications.
1359  *
1360  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1361  * This allows applications to reconstruct the allowance for all accounts just
1362  * by listening to said events. Other implementations of the EIP may not emit
1363  * these events, as it isn't required by the specification.
1364  *
1365  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1366  * functions have been added to mitigate the well-known issues around setting
1367  * allowances. See {IERC20-approve}.
1368  */
1369 contract ERC20 is Context, IERC20, IERC20Metadata {
1370     mapping(address => uint256) private _balances;
1371 
1372     mapping(address => mapping(address => uint256)) private _allowances;
1373 
1374     uint256 private _totalSupply;
1375 
1376     string private _name;
1377     string private _symbol;
1378 
1379     /**
1380      * @dev Sets the values for {name} and {symbol}.
1381      *
1382      * The default value of {decimals} is 18. To select a different value for
1383      * {decimals} you should overload it.
1384      *
1385      * All two of these values are immutable: they can only be set once during
1386      * construction.
1387      */
1388     constructor(string memory name_, string memory symbol_) {
1389         _name = name_;
1390         _symbol = symbol_;
1391     }
1392 
1393     /**
1394      * @dev Returns the name of the token.
1395      */
1396     function name() public view virtual override returns (string memory) {
1397         return _name;
1398     }
1399 
1400     /**
1401      * @dev Returns the symbol of the token, usually a shorter version of the
1402      * name.
1403      */
1404     function symbol() public view virtual override returns (string memory) {
1405         return _symbol;
1406     }
1407 
1408     /**
1409      * @dev Returns the number of decimals used to get its user representation.
1410      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1411      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1412      *
1413      * Tokens usually opt for a value of 18, imitating the relationship between
1414      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1415      * overridden;
1416      *
1417      * NOTE: This information is only used for _display_ purposes: it in
1418      * no way affects any of the arithmetic of the contract, including
1419      * {IERC20-balanceOf} and {IERC20-transfer}.
1420      */
1421     function decimals() public view virtual override returns (uint8) {
1422         return 18;
1423     }
1424 
1425     /**
1426      * @dev See {IERC20-totalSupply}.
1427      */
1428     function totalSupply() public view virtual override returns (uint256) {
1429         return _totalSupply;
1430     }
1431 
1432     /**
1433      * @dev See {IERC20-balanceOf}.
1434      */
1435     function balanceOf(address account) public view virtual override returns (uint256) {
1436         return _balances[account];
1437     }
1438 
1439     /**
1440      * @dev See {IERC20-transfer}.
1441      *
1442      * Requirements:
1443      *
1444      * - `recipient` cannot be the zero address.
1445      * - the caller must have a balance of at least `amount`.
1446      */
1447     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1448         _transfer(_msgSender(), recipient, amount);
1449         return true;
1450     }
1451 
1452     /**
1453      * @dev See {IERC20-allowance}.
1454      */
1455     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1456         return _allowances[owner][spender];
1457     }
1458 
1459     /**
1460      * @dev See {IERC20-approve}.
1461      *
1462      * Requirements:
1463      *
1464      * - `spender` cannot be the zero address.
1465      */
1466     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1467         _approve(_msgSender(), spender, amount);
1468         return true;
1469     }
1470 
1471     /**
1472      * @dev See {IERC20-transferFrom}.
1473      *
1474      * Emits an {Approval} event indicating the updated allowance. This is not
1475      * required by the EIP. See the note at the beginning of {ERC20}.
1476      *
1477      * Requirements:
1478      *
1479      * - `sender` and `recipient` cannot be the zero address.
1480      * - `sender` must have a balance of at least `amount`.
1481      * - the caller must have allowance for ``sender``'s tokens of at least
1482      * `amount`.
1483      */
1484     function transferFrom(
1485         address sender,
1486         address recipient,
1487         uint256 amount
1488     ) public virtual override returns (bool) {
1489         _transfer(sender, recipient, amount);
1490 
1491         uint256 currentAllowance = _allowances[sender][_msgSender()];
1492         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1493         unchecked {
1494             _approve(sender, _msgSender(), currentAllowance - amount);
1495         }
1496 
1497         return true;
1498     }
1499 
1500     /**
1501      * @dev Atomically increases the allowance granted to `spender` by the caller.
1502      *
1503      * This is an alternative to {approve} that can be used as a mitigation for
1504      * problems described in {IERC20-approve}.
1505      *
1506      * Emits an {Approval} event indicating the updated allowance.
1507      *
1508      * Requirements:
1509      *
1510      * - `spender` cannot be the zero address.
1511      */
1512     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1513         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1514         return true;
1515     }
1516 
1517     /**
1518      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1519      *
1520      * This is an alternative to {approve} that can be used as a mitigation for
1521      * problems described in {IERC20-approve}.
1522      *
1523      * Emits an {Approval} event indicating the updated allowance.
1524      *
1525      * Requirements:
1526      *
1527      * - `spender` cannot be the zero address.
1528      * - `spender` must have allowance for the caller of at least
1529      * `subtractedValue`.
1530      */
1531     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1532         uint256 currentAllowance = _allowances[_msgSender()][spender];
1533         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1534         unchecked {
1535             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1536         }
1537 
1538         return true;
1539     }
1540 
1541     /**
1542      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1543      *
1544      * This internal function is equivalent to {transfer}, and can be used to
1545      * e.g. implement automatic token fees, slashing mechanisms, etc.
1546      *
1547      * Emits a {Transfer} event.
1548      *
1549      * Requirements:
1550      *
1551      * - `sender` cannot be the zero address.
1552      * - `recipient` cannot be the zero address.
1553      * - `sender` must have a balance of at least `amount`.
1554      */
1555     function _transfer(
1556         address sender,
1557         address recipient,
1558         uint256 amount
1559     ) internal virtual {
1560         require(sender != address(0), "ERC20: transfer from the zero address");
1561         require(recipient != address(0), "ERC20: transfer to the zero address");
1562 
1563         _beforeTokenTransfer(sender, recipient, amount);
1564 
1565         uint256 senderBalance = _balances[sender];
1566         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1567         unchecked {
1568             _balances[sender] = senderBalance - amount;
1569         }
1570         _balances[recipient] += amount;
1571 
1572         emit Transfer(sender, recipient, amount);
1573 
1574         _afterTokenTransfer(sender, recipient, amount);
1575     }
1576 
1577     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1578      * the total supply.
1579      *
1580      * Emits a {Transfer} event with `from` set to the zero address.
1581      *
1582      * Requirements:
1583      *
1584      * - `account` cannot be the zero address.
1585      */
1586     function _mint(address account, uint256 amount) internal virtual {
1587         require(account != address(0), "ERC20: mint to the zero address");
1588 
1589         _beforeTokenTransfer(address(0), account, amount);
1590 
1591         _totalSupply += amount;
1592         _balances[account] += amount;
1593         emit Transfer(address(0), account, amount);
1594 
1595         _afterTokenTransfer(address(0), account, amount);
1596     }
1597 
1598     /**
1599      * @dev Destroys `amount` tokens from `account`, reducing the
1600      * total supply.
1601      *
1602      * Emits a {Transfer} event with `to` set to the zero address.
1603      *
1604      * Requirements:
1605      *
1606      * - `account` cannot be the zero address.
1607      * - `account` must have at least `amount` tokens.
1608      */
1609     function _burn(address account, uint256 amount) internal virtual {
1610         require(account != address(0), "ERC20: burn from the zero address");
1611 
1612         _beforeTokenTransfer(account, address(0), amount);
1613 
1614         uint256 accountBalance = _balances[account];
1615         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1616         unchecked {
1617             _balances[account] = accountBalance - amount;
1618         }
1619         _totalSupply -= amount;
1620 
1621         emit Transfer(account, address(0), amount);
1622 
1623         _afterTokenTransfer(account, address(0), amount);
1624     }
1625 
1626     /**
1627      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1628      *
1629      * This internal function is equivalent to `approve`, and can be used to
1630      * e.g. set automatic allowances for certain subsystems, etc.
1631      *
1632      * Emits an {Approval} event.
1633      *
1634      * Requirements:
1635      *
1636      * - `owner` cannot be the zero address.
1637      * - `spender` cannot be the zero address.
1638      */
1639     function _approve(
1640         address owner,
1641         address spender,
1642         uint256 amount
1643     ) internal virtual {
1644         require(owner != address(0), "ERC20: approve from the zero address");
1645         require(spender != address(0), "ERC20: approve to the zero address");
1646 
1647         _allowances[owner][spender] = amount;
1648         emit Approval(owner, spender, amount);
1649     }
1650 
1651     /**
1652      * @dev Hook that is called before any transfer of tokens. This includes
1653      * minting and burning.
1654      *
1655      * Calling conditions:
1656      *
1657      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1658      * will be transferred to `to`.
1659      * - when `from` is zero, `amount` tokens will be minted for `to`.
1660      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1661      * - `from` and `to` are never both zero.
1662      *
1663      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1664      */
1665     function _beforeTokenTransfer(
1666         address from,
1667         address to,
1668         uint256 amount
1669     ) internal virtual {}
1670 
1671     /**
1672      * @dev Hook that is called after any transfer of tokens. This includes
1673      * minting and burning.
1674      *
1675      * Calling conditions:
1676      *
1677      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1678      * has been transferred to `to`.
1679      * - when `from` is zero, `amount` tokens have been minted for `to`.
1680      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1681      * - `from` and `to` are never both zero.
1682      *
1683      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1684      */
1685     function _afterTokenTransfer(
1686         address from,
1687         address to,
1688         uint256 amount
1689     ) internal virtual {}
1690 }
1691 
1692 contract FeeManager is Ownable {
1693     uint256 private defaultFee;
1694     mapping(address => uint256) private partnerFeeAggreement;
1695 
1696     constructor(uint _defaultFee){
1697         defaultFee = _defaultFee;
1698     }
1699 
1700     event FeeUpdated(address partner, uint256 fee);
1701 
1702     function setPartnerFee(address partner, uint256 fee) public onlyOwner {
1703         require(fee > 0, "Fee must be greater than 0");
1704         require(
1705             partnerFeeAggreement[partner] == 0,
1706             "Edit partner fee require partner approval"
1707         );
1708         partnerFeeAggreement[partner] = fee;
1709     }
1710 
1711     function setDefaultFee(uint256 fee) public onlyOwner {
1712         require(fee > 0, "Fee must be greater than 0");
1713 
1714         defaultFee = fee;
1715     }
1716 
1717     function updatePartnerFee(address partner, uint256 fee) public onlyOwner {
1718         require(fee > 0, "Fee must be greater than 0");
1719         require(partnerFeeAggreement[partner] > 0, "Partner fee is not set. ");
1720         partnerFeeAggreement[partner] = fee;
1721 
1722         emit FeeUpdated(partner, fee);
1723     }
1724 
1725     function getPartnerFee(address partner) public view returns (uint256) {
1726         return
1727             partnerFeeAggreement[partner] > 0
1728                 ? partnerFeeAggreement[partner]
1729                 : defaultFee;
1730     }
1731 }
1732 
1733 contract TokenMover is Ownable {
1734     address[] private _operators;
1735     mapping(address => bool) internal _isOperator;
1736 
1737     modifier onlyOperator() {
1738         require(_isOperator[_msgSender()], "Caller is not the operator");
1739         _;
1740     }
1741 
1742     function isOperator(address _operator) public view returns(bool) {
1743         return _isOperator[_operator];
1744     }
1745 
1746     function getAllOperators() public view returns(address[] memory) {
1747         return _operators;
1748     }
1749 
1750     function addOperator(address _operator) public onlyOwner {
1751         require(!_isOperator[_operator], "Address already added as operator");
1752         _isOperator[_operator] = true;
1753         _operators.push(_operator);
1754     }
1755 
1756     function removeOperator(address _operator) public onlyOwner {
1757         require(_isOperator[_operator], "Address is not added as operator");
1758         _isOperator[_operator] = false;
1759         for (uint256 i = 0; i < _operators.length; i++) {
1760             if (_operators[i] == _operator) {
1761                 _operators[i] = _operators[_operators.length - 1];
1762                 _operators.pop();
1763                 break;
1764             }
1765         }
1766     }
1767 
1768     function transferERC20(address currency, address from, address to, uint amount) public onlyOperator {
1769         ERC20(currency).transferFrom(from, to, amount);
1770     }
1771 
1772     function transferERC721(address currency, address from, address to, uint tokenId) public onlyOperator {
1773         ERC721(currency).safeTransferFrom(from, to, tokenId);
1774     }
1775 }
1776 
1777 contract NFTToken is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, IERC2981Royalties {
1778     struct Royalty {
1779         address recipient;
1780         uint256 value;
1781     }
1782     string internal baseUri;
1783     address[] private _apps;
1784     mapping(uint256 => Royalty) internal _royalties;
1785     mapping(address => bool) internal _isApp;
1786 
1787     constructor(string memory _baseURI_) ERC721("RarePorn", "NFP") {
1788         setBaseURI(_baseURI_);
1789     }
1790 
1791     modifier onlyApp() {
1792         require(_isApp[_msgSender()], "Caller is not the app");
1793         _;
1794     }
1795 
1796     function supportsInterface(bytes4 interfaceId)
1797         public
1798         view
1799         override(ERC721, ERC721Enumerable)
1800         returns (bool)
1801     {
1802         return interfaceId == type(IERC2981Royalties).interfaceId
1803             || super.supportsInterface(interfaceId);
1804     }
1805 
1806     function getAllApps() public view returns(address[] memory) {
1807         return _apps;
1808     }
1809 
1810     function isApp(address _app) public view returns(bool) {
1811         return _isApp[_app];
1812     }
1813 
1814     /// @dev Sets token royalties
1815     /// @param id the token id fir which we register the royalties
1816     /// @param recipient recipient of the royalties
1817     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
1818     function _setTokenRoyalty(
1819         uint id,
1820         address recipient,
1821         uint256 value
1822     ) internal {
1823         require(value <= 10000, 'ERC2981Royalties: Too high');
1824 
1825         _royalties[id] = Royalty(recipient, value);
1826     }
1827 
1828     /// @notice Called with the sale price to determine how much royalty is owed and to whom.
1829     /// @param _tokenId - the NFT asset queried for royalty information
1830     /// @param _value - the sale price of the NFT asset specified by _tokenId
1831     /// @return _receiver - address of who should be sent the royalty payment
1832     /// @return _royaltyAmount - the royalty payment amount for value sale price
1833     function royaltyInfo(uint256 _tokenId, uint256 _value)
1834         external
1835         override
1836         view
1837         returns (address _receiver, uint256 _royaltyAmount)
1838     {
1839         Royalty memory royalty = _royalties[_tokenId];
1840         return (royalty.recipient, (_value * royalty.value) / 10000);
1841     }
1842 
1843     function mint(uint tokenId, address royaltyRecipient, uint royaltyPercentage, string memory _uri) public {
1844         _safeMint(msg.sender, tokenId);
1845         _setTokenURI(tokenId, _uri);
1846         _setTokenRoyalty(tokenId, royaltyRecipient, royaltyPercentage);
1847     }
1848 
1849     function mintForSomeoneAndBuy(uint tokenId, address royaltyRecipient, uint royaltyPercentage, string memory _uri, address buyer) public onlyApp {
1850         _safeMint(royaltyRecipient, tokenId);
1851         _setTokenURI(tokenId, _uri);
1852         _setTokenRoyalty(tokenId, royaltyRecipient, royaltyPercentage);
1853         _safeTransfer(royaltyRecipient, buyer, tokenId, "");
1854     }
1855 
1856     /**
1857      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
1858      * in child contracts.
1859      */
1860     function _baseURI() internal view virtual override returns (string memory) {
1861         return baseUri;
1862     }
1863 
1864     function setBaseURI(string memory _baseUri) public onlyOwner {
1865         require(bytes(_baseUri).length > 0);
1866         baseUri = _baseUri;
1867     }
1868 
1869     function addApp(address _app) public onlyOwner {
1870         require(!_isApp[_app], "Address already added as app");
1871         _apps.push(_app);
1872         _isApp[_app] = true;
1873     }
1874 
1875     function removeApp(address _app) public onlyOwner {
1876         require(_isApp[_app], "Address is not added as app");
1877         _isApp[_app] = false;
1878         for (uint256 i = 0; i < _apps.length; i++) {
1879             if (_apps[i] == _app) {
1880                 _apps[i] = _apps[_apps.length - 1];
1881                 _apps.pop();
1882                 break;
1883             }
1884         }
1885     }
1886 
1887     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable)
1888     {
1889         super._beforeTokenTransfer(from, to, tokenId);
1890     }
1891 
1892     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1893         super._burn(tokenId);
1894     }
1895 
1896     function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory)
1897     {
1898         return super.tokenURI(tokenId);
1899     }
1900 }
1901 
1902 contract Operator is Ownable {
1903     address private feeManager;
1904     address private feeRecipient;
1905     TokenMover public tokenMover;
1906 
1907     address[] private _apps;
1908     mapping(address => bool) internal _isApp;
1909 
1910     event SaleAwarded(address from, address to, uint tokenId);
1911     event ItemGifted(address from, address to, uint tokenId);
1912     event RoyaltyTransferred(address from, address to, uint amount);
1913 
1914     constructor(address _feeManager, address _feeRecipient, address _TokenMover) {
1915         feeManager = _feeManager;
1916         feeRecipient = _feeRecipient;
1917         tokenMover = TokenMover(_TokenMover);
1918     }
1919 
1920     modifier onlyApp() {
1921         require(_isApp[_msgSender()], "Caller is not the app");
1922         _;
1923     }
1924 
1925     function getFeeManager() public view returns(address) {
1926         return feeManager;
1927     }
1928 
1929     function getFeeRecipient() public view returns(address) {
1930         return feeRecipient;
1931     }
1932 
1933     function getAllApps() public view returns(address[] memory) {
1934         return _apps;
1935     }
1936 
1937     function isApp(address _app) public view returns(bool) {
1938         return _isApp[_app];
1939     }
1940 
1941     function mintAndSell(
1942         uint tokenId,
1943         address nftContract,
1944         address owner,
1945         address buyer,
1946         uint price,
1947         uint extraFee,
1948         uint royaltyPercentage,
1949         address currency,
1950         string memory _uri
1951     ) public onlyApp {
1952         require(buyer != address(0), "Buyer cannot be the zero address");
1953         require(owner != address(0), "Owner cannot be the zero address");
1954         require(price > 0, "Price should be greater than zero");
1955 
1956         NFTToken(nftContract).mintForSomeoneAndBuy(tokenId, owner, royaltyPercentage, _uri, buyer);
1957 
1958         _takeFee(tokenId, nftContract, owner, buyer, price, extraFee, currency);
1959         emit SaleAwarded(owner, buyer, tokenId);
1960     }
1961 
1962     function sellItem(
1963         uint tokenId,
1964         address nftContract,
1965         address owner,
1966         address buyer,
1967         uint price,
1968         uint extraFee,
1969         address currency
1970     ) public onlyApp {
1971         require(buyer != address(0), "Buyer cannot be the zero address");
1972         require(owner != address(0), "Owner cannot be the zero address");
1973         require(price > 0, "Price should be greater than zero");
1974 
1975         tokenMover.transferERC721(nftContract, owner, buyer, tokenId);
1976 
1977         _takeFee(tokenId, nftContract, owner, buyer, price, extraFee, currency);
1978         emit SaleAwarded(owner, buyer, tokenId);
1979     }
1980 
1981     function _takeFee(
1982         uint tokenId,
1983         address nftContract,
1984         address owner,
1985         address buyer,
1986         uint price,
1987         uint extraFee,
1988         address currency
1989     ) internal {
1990         uint commission = FeeManager(feeManager).getPartnerFee(owner);
1991         require(commission > 0, "Commission cannot be 0");
1992 
1993         address receiver = address(0);
1994         uint royaltyAmount = 0;
1995 
1996         if(ERC165(nftContract).supportsInterface(type(IERC2981Royalties).interfaceId)){
1997             (address _receiver, uint256 _royaltyAmount) = IERC2981Royalties(nftContract).royaltyInfo(tokenId, price);
1998 
1999             if(owner != _receiver) {
2000                 receiver = _receiver;
2001                 royaltyAmount = _royaltyAmount;
2002             }
2003         }
2004 
2005         uint fee = (price * commission /10000) + extraFee;
2006         uint amount = price - fee - royaltyAmount;
2007 
2008         tokenMover.transferERC20(currency, buyer, owner, amount);
2009         tokenMover.transferERC20(currency, buyer, feeRecipient, fee);
2010         if(receiver != address(0)){
2011             tokenMover.transferERC20(currency, buyer, receiver, royaltyAmount);
2012             emit RoyaltyTransferred(buyer, receiver, royaltyAmount);
2013         }
2014     }
2015 
2016     function changeFeeManager(address _feeManager) public onlyOwner {
2017         feeManager = _feeManager;
2018     }
2019 
2020     function changeFeeRecipient(address _feeRecipient) public onlyOwner {
2021         feeRecipient = _feeRecipient;
2022     }
2023 
2024     function addApp(address _app) public onlyOwner {
2025         require(!_isApp[_app], "Address already added as app");
2026         _apps.push(_app);
2027         _isApp[_app] = true;
2028     }
2029 
2030     function removeApp(address _app) public onlyOwner {
2031         require(_isApp[_app], "Address is not added as app");
2032         _isApp[_app] = false;
2033         for (uint256 i = 0; i < _apps.length; i++) {
2034             if (_apps[i] == _app) {
2035                 _apps[i] = _apps[_apps.length - 1];
2036                 _apps.pop();
2037                 break;
2038             }
2039         }
2040     }
2041 }