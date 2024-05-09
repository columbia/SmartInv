1 pragma solidity ^0.8.0;
2 // SPDX-License-Identifier: GPL-3.0
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 // Developed By Crypto Sodi. 
5 // Twitter https://twitter.com/cryptosodi
6 // Property of Women Rise http://womenrise.art
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12     /**
13      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
14      */
15     function toString(uint256 value) internal pure returns (string memory) {
16         // Inspired by OraclizeAPI's implementation - MIT licence
17         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
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
66 // File: @openzeppelin/contracts/utils/Context.sol
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
86 // File: @openzeppelin/contracts/access/Ownable.sol
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
108         _setOwner(_msgSender());
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
125     /**
126      * @dev Transfers ownership of the contract to a new account (`newOwner`).
127      * Can only be called by the current owner.
128      */
129     function transferOwnership(address newOwner) public virtual onlyOwner {
130         require(newOwner != address(0), "Ownable: new owner is the zero address");
131         _setOwner(newOwner);
132     }
133 
134     function _setOwner(address newOwner) private {
135         address oldOwner = _owner;
136         _owner = newOwner;
137         emit OwnershipTransferred(oldOwner, newOwner);
138     }
139 }
140 // File: @openzeppelin/contracts/utils/Address.sol
141 /**
142  * @dev Collection of functions related to the address type
143  */
144 library Address {
145     /**
146      * @dev Returns true if `account` is a contract.
147      *
148      * [IMPORTANT]
149      * ====
150      * It is unsafe to assume that an address for which this function returns
151      * false is an externally-owned account (EOA) and not a contract.
152      *
153      * Among others, `isContract` will return false for the following
154      * types of addresses:
155      *
156      *  - an externally-owned account
157      *  - a contract in construction
158      *  - an address where a contract will be created
159      *  - an address where a contract lived, but was destroyed
160      * ====
161      */
162     function isContract(address account) internal view returns (bool) {
163         // This method relies on extcodesize, which returns 0 for contracts in
164         // construction, since the code is only stored at the end of the
165         // constructor execution.
166 
167         uint256 size;
168         assembly {
169             size := extcodesize(account)
170         }
171         return size > 0;
172     }
173 
174     /**
175      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
176      * `recipient`, forwarding all available gas and reverting on errors.
177      *
178      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
179      * of certain opcodes, possibly making contracts go over the 2300 gas limit
180      * imposed by `transfer`, making them unable to receive funds via
181      * `transfer`. {sendValue} removes this limitation.
182      *
183      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
184      *
185      * IMPORTANT: because control is transferred to `recipient`, care must be
186      * taken to not create reentrancy vulnerabilities. Consider using
187      * {ReentrancyGuard} or the
188      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
189      */
190     function sendValue(address payable recipient, uint256 amount) internal {
191         require(address(this).balance >= amount, "Address: insufficient balance");
192 
193         (bool success, ) = recipient.call{value: amount}("");
194         require(success, "Address: unable to send value, recipient may have reverted");
195     }
196 
197     /**
198      * @dev Performs a Solidity function call using a low level `call`. A
199      * plain `call` is an unsafe replacement for a function call: use this
200      * function instead.
201      *
202      * If `target` reverts with a revert reason, it is bubbled up by this
203      * function (like regular Solidity function calls).
204      *
205      * Returns the raw returned data. To convert to the expected return value,
206      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
207      *
208      * Requirements:
209      *
210      * - `target` must be a contract.
211      * - calling `target` with `data` must not revert.
212      *
213      * _Available since v3.1._
214      */
215     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
216         return functionCall(target, data, "Address: low-level call failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
221      * `errorMessage` as a fallback revert reason when `target` reverts.
222      *
223      * _Available since v3.1._
224      */
225     function functionCall(
226         address target,
227         bytes memory data,
228         string memory errorMessage
229     ) internal returns (bytes memory) {
230         return functionCallWithValue(target, data, 0, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but also transferring `value` wei to `target`.
236      *
237      * Requirements:
238      *
239      * - the calling contract must have an ETH balance of at least `value`.
240      * - the called Solidity function must be `payable`.
241      *
242      * _Available since v3.1._
243      */
244     function functionCallWithValue(
245         address target,
246         bytes memory data,
247         uint256 value
248     ) internal returns (bytes memory) {
249         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
254      * with `errorMessage` as a fallback revert reason when `target` reverts.
255      *
256      * _Available since v3.1._
257      */
258     function functionCallWithValue(
259         address target,
260         bytes memory data,
261         uint256 value,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         require(address(this).balance >= value, "Address: insufficient balance for call");
265         require(isContract(target), "Address: call to non-contract");
266 
267         (bool success, bytes memory returndata) = target.call{value: value}(data);
268         return verifyCallResult(success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but performing a static call.
274      *
275      * _Available since v3.3._
276      */
277     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
278         return functionStaticCall(target, data, "Address: low-level static call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
283      * but performing a static call.
284      *
285      * _Available since v3.3._
286      */
287     function functionStaticCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal view returns (bytes memory) {
292         require(isContract(target), "Address: static call to non-contract");
293 
294         (bool success, bytes memory returndata) = target.staticcall(data);
295         return verifyCallResult(success, returndata, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but performing a delegate call.
301      *
302      * _Available since v3.4._
303      */
304     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
310      * but performing a delegate call.
311      *
312      * _Available since v3.4._
313      */
314     function functionDelegateCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         require(isContract(target), "Address: delegate call to non-contract");
320 
321         (bool success, bytes memory returndata) = target.delegatecall(data);
322         return verifyCallResult(success, returndata, errorMessage);
323     }
324 
325     /**
326      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
327      * revert reason using the provided one.
328      *
329      * _Available since v4.3._
330      */
331     function verifyCallResult(
332         bool success,
333         bytes memory returndata,
334         string memory errorMessage
335     ) internal pure returns (bytes memory) {
336         if (success) {
337             return returndata;
338         } else {
339             // Look for revert reason and bubble it up if present
340             if (returndata.length > 0) {
341                 // The easiest way to bubble the revert reason is using memory via assembly
342 
343                 assembly {
344                     let returndata_size := mload(returndata)
345                     revert(add(32, returndata), returndata_size)
346                 }
347             } else {
348                 revert(errorMessage);
349             }
350         }
351     }
352 }
353 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
354 
355 /**
356  * @title ERC721 token receiver interface
357  * @dev Interface for any contract that wants to support safeTransfers
358  * from ERC721 asset contracts.
359  */
360 interface IERC721Receiver {
361     /**
362      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
363      * by `operator` from `from`, this function is called.
364      *
365      * It must return its Solidity selector to confirm the token transfer.
366      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
367      *
368      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
369      */
370     function onERC721Received(
371         address operator,
372         address from,
373         uint256 tokenId,
374         bytes calldata data
375     ) external returns (bytes4);
376 }
377 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
378 
379 /**
380  * @dev Interface of the ERC165 standard, as defined in the
381  * https://eips.ethereum.org/EIPS/eip-165[EIP].
382  *
383  * Implementers can declare support of contract interfaces, which can then be
384  * queried by others ({ERC165Checker}).
385  *
386  * For an implementation, see {ERC165}.
387  */
388 interface IERC165 {
389     /**
390      * @dev Returns true if this contract implements the interface defined by
391      * `interfaceId`. See the corresponding
392      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
393      * to learn more about how these ids are created.
394      *
395      * This function call must use less than 30 000 gas.
396      */
397     function supportsInterface(bytes4 interfaceId) external view returns (bool);
398 }
399 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
400 /**
401  * @dev Implementation of the {IERC165} interface.
402  *
403  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
404  * for the additional interface id that will be supported. For example:
405  *
406  * ```solidity
407  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
408  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
409  * }
410  * ```
411  *
412  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
413  */
414 abstract contract ERC165 is IERC165 {
415     /**
416      * @dev See {IERC165-supportsInterface}.
417      */
418     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
419         return interfaceId == type(IERC165).interfaceId;
420     }
421 }
422 // File @openzeppelin/contracts/interfaces/IERC2981.sol
423 
424 /**
425  * @dev Interface for the NFT Royalty Standard
426  */
427 interface IERC2981 is IERC165 {
428     /**
429      * @dev Called with the sale price to determine how much royalty is owed and to whom.
430      * @param tokenId - the NFT asset queried for royalty information
431      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
432      * @return receiver - address of who should be sent the royalty payment
433      * @return royaltyAmount - the royalty payment amount for `salePrice`
434      */
435     function royaltyInfo(uint256 tokenId, uint256 salePrice)
436         external
437         view
438         returns (address receiver, uint256 royaltyAmount);
439 }
440 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
441 /**
442  * @dev Required interface of an ERC721 compliant contract.
443  */
444 interface IERC721 is IERC165 {
445     /**
446      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
447      */
448     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
449 
450     /**
451      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
452      */
453     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
454 
455     /**
456      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
457      */
458     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
459 
460     /**
461      * @dev Returns the number of tokens in ``owner``'s account.
462      */
463     function balanceOf(address owner) external view returns (uint256 balance);
464 
465     /**
466      * @dev Returns the owner of the `tokenId` token.
467      *
468      * Requirements:
469      *
470      * - `tokenId` must exist.
471      */
472     function ownerOf(uint256 tokenId) external view returns (address owner);
473 
474     /**
475      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
476      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
477      *
478      * Requirements:
479      *
480      * - `from` cannot be the zero address.
481      * - `to` cannot be the zero address.
482      * - `tokenId` token must exist and be owned by `from`.
483      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
484      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
485      *
486      * Emits a {Transfer} event.
487      */
488     function safeTransferFrom(
489         address from,
490         address to,
491         uint256 tokenId
492     ) external;
493 
494     /**
495      * @dev Transfers `tokenId` token from `from` to `to`.
496      *
497      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must be owned by `from`.
504      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
505      *
506      * Emits a {Transfer} event.
507      */
508     function transferFrom(
509         address from,
510         address to,
511         uint256 tokenId
512     ) external;
513 
514     /**
515      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
516      * The approval is cleared when the token is transferred.
517      *
518      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
519      *
520      * Requirements:
521      *
522      * - The caller must own the token or be an approved operator.
523      * - `tokenId` must exist.
524      *
525      * Emits an {Approval} event.
526      */
527     function approve(address to, uint256 tokenId) external;
528 
529     /**
530      * @dev Returns the account approved for `tokenId` token.
531      *
532      * Requirements:
533      *
534      * - `tokenId` must exist.
535      */
536     function getApproved(uint256 tokenId) external view returns (address operator);
537 
538     /**
539      * @dev Approve or remove `operator` as an operator for the caller.
540      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
541      *
542      * Requirements:
543      *
544      * - The `operator` cannot be the caller.
545      *
546      * Emits an {ApprovalForAll} event.
547      */
548     function setApprovalForAll(address operator, bool _approved) external;
549 
550     /**
551      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
552      *
553      * See {setApprovalForAll}
554      */
555     function isApprovedForAll(address owner, address operator) external view returns (bool);
556 
557     /**
558      * @dev Safely transfers `tokenId` token from `from` to `to`.
559      *
560      * Requirements:
561      *
562      * - `from` cannot be the zero address.
563      * - `to` cannot be the zero address.
564      * - `tokenId` token must exist and be owned by `from`.
565      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
566      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
567      *
568      * Emits a {Transfer} event.
569      */
570     function safeTransferFrom(
571         address from,
572         address to,
573         uint256 tokenId,
574         bytes calldata data
575     ) external;
576 }
577 
578 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
579 
580 
581 /**
582  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
583  * @dev See https://eips.ethereum.org/EIPS/eip-721
584  */
585 interface IERC721Enumerable is IERC721 {
586     /**
587      * @dev Returns the total amount of tokens stored by the contract.
588      */
589     function totalSupply() external view returns (uint256);
590 
591     /**
592      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
593      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
594      */
595     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
596 
597     /**
598      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
599      * Use along with {totalSupply} to enumerate all tokens.
600      */
601     function tokenByIndex(uint256 index) external view returns (uint256);
602 }
603 
604 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
605 
606 
607 /**
608  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
609  * @dev See https://eips.ethereum.org/EIPS/eip-721
610  */
611 interface IERC721Metadata is IERC721 {
612     /**
613      * @dev Returns the token collection name.
614      */
615     function name() external view returns (string memory);
616 
617     /**
618      * @dev Returns the token collection symbol.
619      */
620     function symbol() external view returns (string memory);
621 
622     /**
623      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
624      */
625     function tokenURI(uint256 tokenId) external view returns (string memory);
626 }
627 
628 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
629 
630 /**
631  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
632  * the Metadata extension, but not including the Enumerable extension, which is available separately as
633  * {ERC721Enumerable}.
634  */
635 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
636     using Address for address;
637     using Strings for uint256;
638 
639     // Token name
640     string private _name;
641 
642     // Token symbol
643     string private _symbol;
644 
645     // Mapping from token ID to owner address
646     mapping(uint256 => address) private _owners;
647 
648     // Mapping owner address to token count
649     mapping(address => uint256) private _balances;
650 
651     // Mapping from token ID to approved address
652     mapping(uint256 => address) private _tokenApprovals;
653 
654     // Mapping from owner to operator approvals
655     mapping(address => mapping(address => bool)) private _operatorApprovals;
656 
657     /**
658      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
659      */
660     constructor(string memory name_, string memory symbol_) {
661         _name = name_;
662         _symbol = symbol_;
663     }
664 
665     /**
666      * @dev See {IERC165-supportsInterface}.
667      */
668     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
669         return
670             interfaceId == type(IERC721).interfaceId ||
671             interfaceId == type(IERC721Metadata).interfaceId ||
672             super.supportsInterface(interfaceId);
673     }
674 
675     /**
676      * @dev See {IERC721-balanceOf}.
677      */
678     function balanceOf(address owner) public view virtual override returns (uint256) {
679         require(owner != address(0), "ERC721: balance query for the zero address");
680         return _balances[owner];
681     }
682 
683     /**
684      * @dev See {IERC721-ownerOf}.
685      */
686     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
687         address owner = _owners[tokenId];
688         require(owner != address(0), "ERC721: owner query for nonexistent token");
689         return owner;
690     }
691 
692     /**
693      * @dev See {IERC721Metadata-name}.
694      */
695     function name() public view virtual override returns (string memory) {
696         return _name;
697     }
698 
699     /**
700      * @dev See {IERC721Metadata-symbol}.
701      */
702     function symbol() public view virtual override returns (string memory) {
703         return _symbol;
704     }
705 
706     /**
707      * @dev See {IERC721Metadata-tokenURI}.
708      */
709     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
710         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
711 
712         string memory baseURI = _baseURI();
713         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
714     }
715 
716     /**
717      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
718      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
719      * by default, can be overriden in child contracts.
720      */
721     function _baseURI() internal view virtual returns (string memory) {
722         return "";
723     }
724 
725     /**
726      * @dev See {IERC721-approve}.
727      */
728     function approve(address to, uint256 tokenId) public virtual override {
729         address owner = ERC721.ownerOf(tokenId);
730         require(to != owner, "ERC721: approval to current owner");
731 
732         require(
733             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
734             "ERC721: approve caller is not owner nor approved for all"
735         );
736 
737         _approve(to, tokenId);
738     }
739 
740     /**
741      * @dev See {IERC721-getApproved}.
742      */
743     function getApproved(uint256 tokenId) public view virtual override returns (address) {
744         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
745 
746         return _tokenApprovals[tokenId];
747     }
748 
749     /**
750      * @dev See {IERC721-setApprovalForAll}.
751      */
752     function setApprovalForAll(address operator, bool approved) public virtual override {
753         require(operator != _msgSender(), "ERC721: approve to caller");
754 
755         _operatorApprovals[_msgSender()][operator] = approved;
756         emit ApprovalForAll(_msgSender(), operator, approved);
757     }
758 
759     /**
760      * @dev See {IERC721-isApprovedForAll}.
761      */
762     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
763         return _operatorApprovals[owner][operator];
764     }
765 
766     /**
767      * @dev See {IERC721-transferFrom}.
768      */
769     function transferFrom(
770         address from,
771         address to,
772         uint256 tokenId
773     ) public virtual override {
774         //solhint-disable-next-line max-line-length
775         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
776 
777         _transfer(from, to, tokenId);
778     }
779 
780     /**
781      * @dev See {IERC721-safeTransferFrom}.
782      */
783     function safeTransferFrom(
784         address from,
785         address to,
786         uint256 tokenId
787     ) public virtual override {
788         safeTransferFrom(from, to, tokenId, "");
789     }
790 
791     /**
792      * @dev See {IERC721-safeTransferFrom}.
793      */
794     function safeTransferFrom(
795         address from,
796         address to,
797         uint256 tokenId,
798         bytes memory _data
799     ) public virtual override {
800         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
801         _safeTransfer(from, to, tokenId, _data);
802     }
803 
804     /**
805      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
806      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
807      *
808      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
809      *
810      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
811      * implement alternative mechanisms to perform token transfer, such as signature-based.
812      *
813      * Requirements:
814      *
815      * - `from` cannot be the zero address.
816      * - `to` cannot be the zero address.
817      * - `tokenId` token must exist and be owned by `from`.
818      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
819      *
820      * Emits a {Transfer} event.
821      */
822     function _safeTransfer(
823         address from,
824         address to,
825         uint256 tokenId,
826         bytes memory _data
827     ) internal virtual {
828         _transfer(from, to, tokenId);
829         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
830     }
831 
832     /**
833      * @dev Returns whether `tokenId` exists.
834      *
835      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
836      *
837      * Tokens start existing when they are minted (`_mint`),
838      * and stop existing when they are burned (`_burn`).
839      */
840     function _exists(uint256 tokenId) internal view virtual returns (bool) {
841         return _owners[tokenId] != address(0);
842     }
843 
844     /**
845      * @dev Returns whether `spender` is allowed to manage `tokenId`.
846      *
847      * Requirements:
848      *
849      * - `tokenId` must exist.
850      */
851     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
852         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
853         address owner = ERC721.ownerOf(tokenId);
854         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
855     }
856 
857     /**
858      * @dev Safely mints `tokenId` and transfers it to `to`.
859      *
860      * Requirements:
861      *
862      * - `tokenId` must not exist.
863      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _safeMint(address to, uint256 tokenId) internal virtual {
868         _safeMint(to, tokenId, "");
869     }
870 
871     /**
872      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
873      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
874      */
875     function _safeMint(
876         address to,
877         uint256 tokenId,
878         bytes memory _data
879     ) internal virtual {
880         _mint(to, tokenId);
881         require(
882             _checkOnERC721Received(address(0), to, tokenId, _data),
883             "ERC721: transfer to non ERC721Receiver implementer"
884         );
885     }
886 
887     /**
888      * @dev Mints `tokenId` and transfers it to `to`.
889      *
890      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
891      *
892      * Requirements:
893      *
894      * - `tokenId` must not exist.
895      * - `to` cannot be the zero address.
896      *
897      * Emits a {Transfer} event.
898      */
899     function _mint(address to, uint256 tokenId) internal virtual {
900         require(to != address(0), "ERC721: mint to the zero address");
901         require(!_exists(tokenId), "ERC721: token already minted");
902 
903         _beforeTokenTransfer(address(0), to, tokenId);
904 
905         _balances[to] += 1;
906         _owners[tokenId] = to;
907 
908         emit Transfer(address(0), to, tokenId);
909     }
910 
911     /**
912      * @dev Destroys `tokenId`.
913      * The approval is cleared when the token is burned.
914      *
915      * Requirements:
916      *
917      * - `tokenId` must exist.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _burn(uint256 tokenId) internal virtual {
922         address owner = ERC721.ownerOf(tokenId);
923 
924         _beforeTokenTransfer(owner, address(0), tokenId);
925 
926         // Clear approvals
927         _approve(address(0), tokenId);
928 
929         _balances[owner] -= 1;
930         delete _owners[tokenId];
931 
932         emit Transfer(owner, address(0), tokenId);
933     }
934 
935     /**
936      * @dev Transfers `tokenId` from `from` to `to`.
937      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
938      *
939      * Requirements:
940      *
941      * - `to` cannot be the zero address.
942      * - `tokenId` token must be owned by `from`.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _transfer(
947         address from,
948         address to,
949         uint256 tokenId
950     ) internal virtual {
951         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
952         require(to != address(0), "ERC721: transfer to the zero address");
953 
954         _beforeTokenTransfer(from, to, tokenId);
955 
956         // Clear approvals from the previous owner
957         _approve(address(0), tokenId);
958 
959         _balances[from] -= 1;
960         _balances[to] += 1;
961         _owners[tokenId] = to;
962 
963         emit Transfer(from, to, tokenId);
964     }
965 
966     /**
967      * @dev Approve `to` to operate on `tokenId`
968      *
969      * Emits a {Approval} event.
970      */
971     function _approve(address to, uint256 tokenId) internal virtual {
972         _tokenApprovals[tokenId] = to;
973         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
974     }
975 
976     /**
977      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
978      * The call is not executed if the target address is not a contract.
979      *
980      * @param from address representing the previous owner of the given token ID
981      * @param to target address that will receive the tokens
982      * @param tokenId uint256 ID of the token to be transferred
983      * @param _data bytes optional data to send along with the call
984      * @return bool whether the call correctly returned the expected magic value
985      */
986     function _checkOnERC721Received(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes memory _data
991     ) private returns (bool) {
992         if (to.isContract()) {
993             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
994                 return retval == IERC721Receiver.onERC721Received.selector;
995             } catch (bytes memory reason) {
996                 if (reason.length == 0) {
997                     revert("ERC721: transfer to non ERC721Receiver implementer");
998                 } else {
999                     assembly {
1000                         revert(add(32, reason), mload(reason))
1001                     }
1002                 }
1003             }
1004         } else {
1005             return true;
1006         }
1007     }
1008 
1009     /**
1010      * @dev Hook that is called before any token transfer. This includes minting
1011      * and burning.
1012      *
1013      * Calling conditions:
1014      *
1015      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1016      * transferred to `to`.
1017      * - When `from` is zero, `tokenId` will be minted for `to`.
1018      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1019      * - `from` and `to` are never both zero.
1020      *
1021      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1022      */
1023     function _beforeTokenTransfer(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) internal virtual {}
1028 }
1029 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1030 /**
1031  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1032  * enumerability of all the token ids in the contract as well as all token ids owned by each
1033  * account.
1034  */
1035 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1036     // Mapping from owner to list of owned token IDs
1037     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1038 
1039     // Mapping from token ID to index of the owner tokens list
1040     mapping(uint256 => uint256) private _ownedTokensIndex;
1041 
1042     // Array with all token ids, used for enumeration
1043     uint256[] private _allTokens;
1044 
1045     // Mapping from token id to position in the allTokens array
1046     mapping(uint256 => uint256) private _allTokensIndex;
1047 
1048     /**
1049      * @dev See {IERC165-supportsInterface}.
1050      */
1051     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1052         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1057      */
1058     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1059         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1060         return _ownedTokens[owner][index];
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Enumerable-totalSupply}.
1065      */
1066     function totalSupply() public view virtual override returns (uint256) {
1067         return _allTokens.length;
1068     }
1069 
1070     /**
1071      * @dev See {IERC721Enumerable-tokenByIndex}.
1072      */
1073     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1074         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1075         return _allTokens[index];
1076     }
1077 
1078     /**
1079      * @dev Hook that is called before any token transfer. This includes minting
1080      * and burning.
1081      *
1082      * Calling conditions:
1083      *
1084      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1085      * transferred to `to`.
1086      * - When `from` is zero, `tokenId` will be minted for `to`.
1087      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1088      * - `from` cannot be the zero address.
1089      * - `to` cannot be the zero address.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual override {
1098         super._beforeTokenTransfer(from, to, tokenId);
1099 
1100         if (from == address(0)) {
1101             _addTokenToAllTokensEnumeration(tokenId);
1102         } else if (from != to) {
1103             _removeTokenFromOwnerEnumeration(from, tokenId);
1104         }
1105         if (to == address(0)) {
1106             _removeTokenFromAllTokensEnumeration(tokenId);
1107         } else if (to != from) {
1108             _addTokenToOwnerEnumeration(to, tokenId);
1109         }
1110     }
1111 
1112     /**
1113      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1114      * @param to address representing the new owner of the given token ID
1115      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1116      */
1117     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1118         uint256 length = ERC721.balanceOf(to);
1119         _ownedTokens[to][length] = tokenId;
1120         _ownedTokensIndex[tokenId] = length;
1121     }
1122 
1123     /**
1124      * @dev Private function to add a token to this extension's token tracking data structures.
1125      * @param tokenId uint256 ID of the token to be added to the tokens list
1126      */
1127     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1128         _allTokensIndex[tokenId] = _allTokens.length;
1129         _allTokens.push(tokenId);
1130     }
1131 
1132     /**
1133      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1134      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1135      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1136      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1137      * @param from address representing the previous owner of the given token ID
1138      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1139      */
1140     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1141         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1142         // then delete the last slot (swap and pop).
1143 
1144         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1145         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1146 
1147         // When the token to delete is the last token, the swap operation is unnecessary
1148         if (tokenIndex != lastTokenIndex) {
1149             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1150 
1151             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1152             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1153         }
1154 
1155         // This also deletes the contents at the last position of the array
1156         delete _ownedTokensIndex[tokenId];
1157         delete _ownedTokens[from][lastTokenIndex];
1158     }
1159 
1160     /**
1161      * @dev Private function to remove a token from this extension's token tracking data structures.
1162      * This has O(1) time complexity, but alters the order of the _allTokens array.
1163      * @param tokenId uint256 ID of the token to be removed from the tokens list
1164      */
1165     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1166         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1167         // then delete the last slot (swap and pop).
1168 
1169         uint256 lastTokenIndex = _allTokens.length - 1;
1170         uint256 tokenIndex = _allTokensIndex[tokenId];
1171 
1172         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1173         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1174         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1175         uint256 lastTokenId = _allTokens[lastTokenIndex];
1176 
1177         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1178         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1179 
1180         // This also deletes the contents at the last position of the array
1181         delete _allTokensIndex[tokenId];
1182         _allTokens.pop();
1183     }
1184 }
1185 // File @opnezeppelin/contracts/utils/cryptography/ECDSA.sol)
1186 /**
1187  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1188  *
1189  * These functions can be used to verify that a message was signed by the holder
1190  * of the private keys of a given address.
1191  */
1192 library ECDSA {
1193     enum RecoverError {
1194         NoError,
1195         InvalidSignature,
1196         InvalidSignatureLength,
1197         InvalidSignatureS,
1198         InvalidSignatureV
1199     }
1200 
1201     function _throwError(RecoverError error) private pure {
1202         if (error == RecoverError.NoError) {
1203             return; // no error: do nothing
1204         } else if (error == RecoverError.InvalidSignature) {
1205             revert("ECDSA: invalid signature");
1206         } else if (error == RecoverError.InvalidSignatureLength) {
1207             revert("ECDSA: invalid signature length");
1208         } else if (error == RecoverError.InvalidSignatureS) {
1209             revert("ECDSA: invalid signature 's' value");
1210         } else if (error == RecoverError.InvalidSignatureV) {
1211             revert("ECDSA: invalid signature 'v' value");
1212         }
1213     }
1214 
1215     /**
1216      * @dev Returns the address that signed a hashed message (`hash`) with
1217      * `signature` or error string. This address can then be used for verification purposes.
1218      *
1219      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1220      * this function rejects them by requiring the `s` value to be in the lower
1221      * half order, and the `v` value to be either 27 or 28.
1222      *
1223      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1224      * verification to be secure: it is possible to craft signatures that
1225      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1226      * this is by receiving a hash of the original message (which may otherwise
1227      * be too long), and then calling {toEthSignedMessageHash} on it.
1228      *
1229      * Documentation for signature generation:
1230      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1231      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1232      *
1233      * _Available since v4.3._
1234      */
1235     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1236         // Check the signature length
1237         // - case 65: r,s,v signature (standard)
1238         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1239         if (signature.length == 65) {
1240             bytes32 r;
1241             bytes32 s;
1242             uint8 v;
1243             // ecrecover takes the signature parameters, and the only way to get them
1244             // currently is to use assembly.
1245             assembly {
1246                 r := mload(add(signature, 0x20))
1247                 s := mload(add(signature, 0x40))
1248                 v := byte(0, mload(add(signature, 0x60)))
1249             }
1250             return tryRecover(hash, v, r, s);
1251         } else if (signature.length == 64) {
1252             bytes32 r;
1253             bytes32 vs;
1254             // ecrecover takes the signature parameters, and the only way to get them
1255             // currently is to use assembly.
1256             assembly {
1257                 r := mload(add(signature, 0x20))
1258                 vs := mload(add(signature, 0x40))
1259             }
1260             return tryRecover(hash, r, vs);
1261         } else {
1262             return (address(0), RecoverError.InvalidSignatureLength);
1263         }
1264     }
1265 
1266     /**
1267      * @dev Returns the address that signed a hashed message (`hash`) with
1268      * `signature`. This address can then be used for verification purposes.
1269      *
1270      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1271      * this function rejects them by requiring the `s` value to be in the lower
1272      * half order, and the `v` value to be either 27 or 28.
1273      *
1274      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1275      * verification to be secure: it is possible to craft signatures that
1276      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1277      * this is by receiving a hash of the original message (which may otherwise
1278      * be too long), and then calling {toEthSignedMessageHash} on it.
1279      */
1280     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1281         (address recovered, RecoverError error) = tryRecover(hash, signature);
1282         _throwError(error);
1283         return recovered;
1284     }
1285 
1286     /**
1287      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1288      *
1289      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1290      *
1291      * _Available since v4.3._
1292      */
1293     function tryRecover(
1294         bytes32 hash,
1295         bytes32 r,
1296         bytes32 vs
1297     ) internal pure returns (address, RecoverError) {
1298         bytes32 s;
1299         uint8 v;
1300         assembly {
1301             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1302             v := add(shr(255, vs), 27)
1303         }
1304         return tryRecover(hash, v, r, s);
1305     }
1306 
1307     /**
1308      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1309      *
1310      * _Available since v4.2._
1311      */
1312     function recover(
1313         bytes32 hash,
1314         bytes32 r,
1315         bytes32 vs
1316     ) internal pure returns (address) {
1317         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1318         _throwError(error);
1319         return recovered;
1320     }
1321 
1322     /**
1323      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1324      * `r` and `s` signature fields separately.
1325      *
1326      * _Available since v4.3._
1327      */
1328     function tryRecover(
1329         bytes32 hash,
1330         uint8 v,
1331         bytes32 r,
1332         bytes32 s
1333     ) internal pure returns (address, RecoverError) {
1334         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1335         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1336         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1337         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1338         //
1339         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1340         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1341         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1342         // these malleable signatures as well.
1343         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1344             return (address(0), RecoverError.InvalidSignatureS);
1345         }
1346         if (v != 27 && v != 28) {
1347             return (address(0), RecoverError.InvalidSignatureV);
1348         }
1349 
1350         // If the signature is valid (and not malleable), return the signer address
1351         address signer = ecrecover(hash, v, r, s);
1352         if (signer == address(0)) {
1353             return (address(0), RecoverError.InvalidSignature);
1354         }
1355 
1356         return (signer, RecoverError.NoError);
1357     }
1358 
1359     /**
1360      * @dev Overload of {ECDSA-recover} that receives the `v`,
1361      * `r` and `s` signature fields separately.
1362      */
1363     function recover(
1364         bytes32 hash,
1365         uint8 v,
1366         bytes32 r,
1367         bytes32 s
1368     ) internal pure returns (address) {
1369         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1370         _throwError(error);
1371         return recovered;
1372     }
1373 
1374     /**
1375      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1376      * produces hash corresponding to the one signed with the
1377      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1378      * JSON-RPC method as part of EIP-191.
1379      *
1380      * See {recover}.
1381      */
1382     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1383         // 32 is the length in bytes of hash,
1384         // enforced by the type signature above
1385         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1386     }
1387 
1388     /**
1389      * @dev Returns an Ethereum Signed Message, created from `s`. This
1390      * produces hash corresponding to the one signed with the
1391      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1392      * JSON-RPC method as part of EIP-191.
1393      *
1394      * See {recover}.
1395      */
1396     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1397         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1398     }
1399 
1400     /**
1401      * @dev Returns an Ethereum Signed Typed Data, created from a
1402      * `domainSeparator` and a `structHash`. This produces hash corresponding
1403      * to the one signed with the
1404      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1405      * JSON-RPC method as part of EIP-712.
1406      *
1407      * See {recover}.
1408      */
1409     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1410         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1411     }
1412 }
1413 // File @openzeppelin/contracts/utils/Counters.sol
1414 /**
1415  * @title Counters
1416  * @author Matt Condon (@shrugs)
1417  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1418  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1419  *
1420  * Include with `using Counters for Counters.Counter;`
1421  */
1422 library Counters {
1423     struct Counter {
1424         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1425         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1426         // this feature: see https://github.com/ethereum/solidity/issues/4637
1427         uint256 _value; // default: 0
1428     }
1429 
1430     function current(Counter storage counter) internal view returns (uint256) {
1431         return counter._value;
1432     }
1433 
1434     function increment(Counter storage counter) internal {
1435         unchecked {
1436             counter._value += 1;
1437         }
1438     }
1439 
1440     function decrement(Counter storage counter) internal {
1441         uint256 value = counter._value;
1442         require(value > 0, "Counter: decrement overflow");
1443         unchecked {
1444             counter._value = value - 1;
1445         }
1446     }
1447 
1448     function reset(Counter storage counter) internal {
1449         counter._value = 0;
1450     }
1451 }
1452 // File: contracts/WomenRise.sol
1453 contract WomenRise is IERC2981, ERC721Enumerable, Ownable {
1454     using Strings for uint256;
1455     using Counters for Counters.Counter;
1456 
1457     Counters.Counter _tokenIdTracker;
1458 
1459     string public baseURI;
1460     uint8 public reserve = 200;
1461     bool public mintingEnabled;
1462     bool public onlyWhitelisted;
1463   
1464     mapping(address => uint32) public addressMintedBalance;
1465     mapping(bytes => bool) public claimSigUsed;
1466 
1467     constructor() ERC721("Women Rise", "WRNFT") { }
1468 
1469     function supportsInterface(bytes4 _interfaceId) public view virtual override(IERC165, ERC721Enumerable) returns (bool) {
1470         return _interfaceId == type(IERC2981).interfaceId || super.supportsInterface(_interfaceId);
1471     }
1472 
1473     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view override returns (address receiver, uint256 royaltyAmount) {
1474         require(_exists(_tokenId), "ERC2981RoyaltyStandard: Royalty info for nonexistent token");
1475         return (owner(), _salePrice / 10); // 10 percent
1476     }
1477 
1478     function mint(uint32 _mintAmount) public payable {
1479         mint(_mintAmount, "");
1480     }
1481 
1482     // public
1483     function mint(uint32 _mintAmount, bytes memory _signature) public payable {
1484         require(msg.value == 7e16 * uint(_mintAmount), "Ethereum amount sent is not correct!");
1485         require(addressMintedBalance[msg.sender] + _mintAmount <= 10 && _mintAmount != 0,"Invalid can not mint more than 10!");
1486         
1487         if (!mintingEnabled) {            
1488             require(onlyWhitelisted, "Minting is not enabled!");
1489             require(isWhitelisted(msg.sender, _signature), "User is not whitelisted!");            
1490             _mintLoop(msg.sender, _mintAmount);
1491             return;
1492         }
1493         require(totalSupply() + _mintAmount < 9_800, "Request will exceed max supply!");
1494         _mintLoop(msg.sender, _mintAmount);
1495     }
1496 
1497     function _mintLoop(address to, uint32 amount) private {
1498         addressMintedBalance[to] += amount;
1499         for (uint i; i < amount; i++ ) {
1500             _safeMint(to, _tokenIdTracker.current());
1501             _tokenIdTracker.increment();
1502         }
1503     }
1504 
1505     function claimAirdrop(bytes calldata _signature, uint _addressAirDropNumber) public {
1506         require(reserve > 0, "No more tokens left in reserve!");
1507         require(!claimSigUsed[_signature], "Can only use a claim signature once!");
1508         require(canClaimAirdrop(msg.sender, _signature, _addressAirDropNumber), "User not eligable to claim an airdrop!");
1509         claimSigUsed[_signature] = true;
1510         _safeMint(msg.sender, _tokenIdTracker.current());
1511         _tokenIdTracker.increment();
1512         addressMintedBalance[msg.sender]++;
1513         reserve--;
1514     }
1515 
1516     function isWhitelisted(address _wallet, bytes memory _signature) private view returns(bool) {
1517         return ECDSA.recover(
1518             ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(_wallet, "whitelist"))),
1519             _signature
1520         ) == owner();
1521     }
1522 
1523     function canClaimAirdrop(address _wallet,bytes calldata _signature,uint256 _addressAirDropNumber) private view returns(bool) {
1524         return ECDSA.recover(
1525             // if it's the address's 3rd airdrop so _addressAirDropNumber = 3
1526             ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(_wallet, "airdrop", _addressAirDropNumber.toString()))),
1527             _signature
1528         ) == owner();
1529     }
1530 
1531     function walletOfOwner(address _owner) public view returns (uint256[] memory)
1532     {
1533         uint256 ownerTokenCount = balanceOf(_owner);
1534         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1535         for (uint256 i; i < ownerTokenCount; i++) {
1536             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1537         }
1538         return tokenIds;
1539     }
1540 
1541     function tokenURI(uint256 tokenId) public view override returns (string memory)
1542     {
1543         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1544         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1545     }
1546 
1547     //only owner
1548     function ownerMintFromReserve(uint8 amount) public onlyOwner {
1549         require(reserve >= amount, "Not enough tokens left in reserve!");
1550         _mintLoop(msg.sender, amount);
1551         reserve -= amount;
1552     }
1553 
1554     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1555         baseURI = _newBaseURI;
1556     } 
1557 
1558     function toggleMinting() external onlyOwner {
1559         mintingEnabled = !mintingEnabled;
1560     }
1561 
1562     function toggleOnlyWhitelisted() external onlyOwner {
1563         onlyWhitelisted = !onlyWhitelisted;
1564     }
1565 
1566     function withdraw() external onlyOwner 
1567     {
1568         bool success = payable(msg.sender).send(address(this).balance);
1569         require(success, "Payment did not go through!");
1570     }
1571 }