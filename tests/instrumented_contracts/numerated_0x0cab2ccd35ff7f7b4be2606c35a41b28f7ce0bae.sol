1 // SPDX-License-Identifier: MIT
2 
3 // Ad Astra Per Aspera.
4 // Discord: https://discord.gg/7YkrmAMDKA
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
64      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must exist and be owned by `from`.
71      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
72      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
73      *
74      * Emits a {Transfer} event.
75      */
76     function safeTransferFrom(
77         address from,
78         address to,
79         uint256 tokenId
80     ) external;
81 
82     /**
83      * @dev Transfers `tokenId` token from `from` to `to`.
84      *
85      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
104      * The approval is cleared when the token is transferred.
105      *
106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
107      *
108      * Requirements:
109      *
110      * - The caller must own the token or be an approved operator.
111      * - `tokenId` must exist.
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Returns the account approved for `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function getApproved(uint256 tokenId) external view returns (address operator);
125 
126     /**
127      * @dev Approve or remove `operator` as an operator for the caller.
128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
129      *
130      * Requirements:
131      *
132      * - The `operator` cannot be the caller.
133      *
134      * Emits an {ApprovalForAll} event.
135      */
136     function setApprovalForAll(address operator, bool _approved) external;
137 
138     /**
139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
140      *
141      * See {setApprovalForAll}
142      */
143     function isApprovedForAll(address owner, address operator) external view returns (bool);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId,
162         bytes calldata data
163     ) external;
164 }
165 
166 /**
167  * @dev String operations.
168  */
169 library Strings {
170     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
171 
172     /**
173      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
174      */
175     function toString(uint256 value) internal pure returns (string memory) {
176         // Inspired by OraclizeAPI's implementation - MIT licence
177         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
178 
179         if (value == 0) {
180             return "0";
181         }
182         uint256 temp = value;
183         uint256 digits;
184         while (temp != 0) {
185             digits++;
186             temp /= 10;
187         }
188         bytes memory buffer = new bytes(digits);
189         while (value != 0) {
190             digits -= 1;
191             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
192             value /= 10;
193         }
194         return string(buffer);
195     }
196 
197     /**
198      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
199      */
200     function toHexString(uint256 value) internal pure returns (string memory) {
201         if (value == 0) {
202             return "0x00";
203         }
204         uint256 temp = value;
205         uint256 length = 0;
206         while (temp != 0) {
207             length++;
208             temp >>= 8;
209         }
210         return toHexString(value, length);
211     }
212 
213     /**
214      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
215      */
216     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
217         bytes memory buffer = new bytes(2 * length + 2);
218         buffer[0] = "0";
219         buffer[1] = "x";
220         for (uint256 i = 2 * length + 1; i > 1; --i) {
221             buffer[i] = _HEX_SYMBOLS[value & 0xf];
222             value >>= 4;
223         }
224         require(value == 0, "Strings: hex length insufficient");
225         return string(buffer);
226     }
227 }
228 
229 /*
230  * @dev Provides information about the current execution context, including the
231  * sender of the transaction and its data. While these are generally available
232  * via msg.sender and msg.data, they should not be accessed in such a direct
233  * manner, since when dealing with meta-transactions the account sending and
234  * paying for execution may not be the actual sender (as far as an application
235  * is concerned).
236  *
237  * This contract is only required for intermediate, library-like contracts.
238  */
239 abstract contract Context {
240     function _msgSender() internal view virtual returns (address) {
241         return msg.sender;
242     }
243 
244     function _msgData() internal view virtual returns (bytes calldata) {
245         return msg.data;
246     }
247 }
248 
249 /**
250  * @dev Contract module which provides a basic access control mechanism, where
251  * there is an account (an owner) that can be granted exclusive access to
252  * specific functions.
253  *
254  * By default, the owner account will be the one that deploys the contract. This
255  * can later be changed with {transferOwnership}.
256  *
257  * This module is used through inheritance. It will make available the modifier
258  * `onlyOwner`, which can be applied to your functions to restrict their use to
259  * the owner.
260  */
261 abstract contract Ownable is Context {
262     address private _owner;
263 
264     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
265 
266     /**
267      * @dev Initializes the contract setting the deployer as the initial owner.
268      */
269     constructor() {
270         _setOwner(_msgSender());
271     }
272 
273     /**
274      * @dev Returns the address of the current owner.
275      */
276     function owner() public view virtual returns (address) {
277         return _owner;
278     }
279 
280     /**
281      * @dev Throws if called by any account other than the owner.
282      */
283     modifier onlyOwner() {
284         require(owner() == _msgSender(), "Ownable: caller is not the owner");
285         _;
286     }
287 
288     /**
289      * @dev Leaves the contract without owner. It will not be possible to call
290      * `onlyOwner` functions anymore. Can only be called by the current owner.
291      *
292      * NOTE: Renouncing ownership will leave the contract without an owner,
293      * thereby removing any functionality that is only available to the owner.
294      */
295     function renounceOwnership() public virtual onlyOwner {
296         _setOwner(address(0));
297     }
298 
299     /**
300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
301      * Can only be called by the current owner.
302      */
303     function transferOwnership(address newOwner) public virtual onlyOwner {
304         require(newOwner != address(0), "Ownable: new owner is the zero address");
305         _setOwner(newOwner);
306     }
307 
308     function _setOwner(address newOwner) private {
309         address oldOwner = _owner;
310         _owner = newOwner;
311         emit OwnershipTransferred(oldOwner, newOwner);
312     }
313 }
314 
315 /**
316  * @dev Contract module that helps prevent reentrant calls to a function.
317  *
318  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
319  * available, which can be applied to functions to make sure there are no nested
320  * (reentrant) calls to them.
321  *
322  * Note that because there is a single `nonReentrant` guard, functions marked as
323  * `nonReentrant` may not call one another. This can be worked around by making
324  * those functions `private`, and then adding `external` `nonReentrant` entry
325  * points to them.
326  *
327  * TIP: If you would like to learn more about reentrancy and alternative ways
328  * to protect against it, check out our blog post
329  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
330  */
331 abstract contract ReentrancyGuard {
332     // Booleans are more expensive than uint256 or any type that takes up a full
333     // word because each write operation emits an extra SLOAD to first read the
334     // slot's contents, replace the bits taken up by the boolean, and then write
335     // back. This is the compiler's defense against contract upgrades and
336     // pointer aliasing, and it cannot be disabled.
337 
338     // The values being non-zero value makes deployment a bit more expensive,
339     // but in exchange the refund on every call to nonReentrant will be lower in
340     // amount. Since refunds are capped to a percentage of the total
341     // transaction's gas, it is best to keep them low in cases like this one, to
342     // increase the likelihood of the full refund coming into effect.
343     uint256 private constant _NOT_ENTERED = 1;
344     uint256 private constant _ENTERED = 2;
345 
346     uint256 private _status;
347 
348     constructor() {
349         _status = _NOT_ENTERED;
350     }
351 
352     /**
353      * @dev Prevents a contract from calling itself, directly or indirectly.
354      * Calling a `nonReentrant` function from another `nonReentrant`
355      * function is not supported. It is possible to prevent this from happening
356      * by making the `nonReentrant` function external, and make it call a
357      * `private` function that does the actual work.
358      */
359     modifier nonReentrant() {
360         // On the first call to nonReentrant, _notEntered will be true
361         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
362 
363         // Any calls to nonReentrant after this point will fail
364         _status = _ENTERED;
365 
366         _;
367 
368         // By storing the original value once again, a refund is triggered (see
369         // https://eips.ethereum.org/EIPS/eip-2200)
370         _status = _NOT_ENTERED;
371     }
372 }
373 
374 /**
375  * @title ERC721 token receiver interface
376  * @dev Interface for any contract that wants to support safeTransfers
377  * from ERC721 asset contracts.
378  */
379 interface IERC721Receiver {
380     /**
381      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
382      * by `operator` from `from`, this function is called.
383      *
384      * It must return its Solidity selector to confirm the token transfer.
385      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
386      *
387      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
388      */
389     function onERC721Received(
390         address operator,
391         address from,
392         uint256 tokenId,
393         bytes calldata data
394     ) external returns (bytes4);
395 }
396 
397 /**
398  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
399  * @dev See https://eips.ethereum.org/EIPS/eip-721
400  */
401 interface IERC721Metadata is IERC721 {
402     /**
403      * @dev Returns the token collection name.
404      */
405     function name() external view returns (string memory);
406 
407     /**
408      * @dev Returns the token collection symbol.
409      */
410     function symbol() external view returns (string memory);
411 
412     /**
413      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
414      */
415     function tokenURI(uint256 tokenId) external view returns (string memory);
416 }
417 
418 /**
419  * @dev Collection of functions related to the address type
420  */
421 library Address {
422     /**
423      * @dev Returns true if `account` is a contract.
424      *
425      * [IMPORTANT]
426      * ====
427      * It is unsafe to assume that an address for which this function returns
428      * false is an externally-owned account (EOA) and not a contract.
429      *
430      * Among others, `isContract` will return false for the following
431      * types of addresses:
432      *
433      *  - an externally-owned account
434      *  - a contract in construction
435      *  - an address where a contract will be created
436      *  - an address where a contract lived, but was destroyed
437      * ====
438      */
439     function isContract(address account) internal view returns (bool) {
440         // This method relies on extcodesize, which returns 0 for contracts in
441         // construction, since the code is only stored at the end of the
442         // constructor execution.
443 
444         uint256 size;
445         assembly {
446             size := extcodesize(account)
447         }
448         return size > 0;
449     }
450 
451     /**
452      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
453      * `recipient`, forwarding all available gas and reverting on errors.
454      *
455      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
456      * of certain opcodes, possibly making contracts go over the 2300 gas limit
457      * imposed by `transfer`, making them unable to receive funds via
458      * `transfer`. {sendValue} removes this limitation.
459      *
460      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
461      *
462      * IMPORTANT: because control is transferred to `recipient`, care must be
463      * taken to not create reentrancy vulnerabilities. Consider using
464      * {ReentrancyGuard} or the
465      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
466      */
467     function sendValue(address payable recipient, uint256 amount) internal {
468         require(address(this).balance >= amount, "Address: insufficient balance");
469 
470         (bool success, ) = recipient.call{value: amount}("");
471         require(success, "Address: unable to send value, recipient may have reverted");
472     }
473 
474     /**
475      * @dev Performs a Solidity function call using a low level `call`. A
476      * plain `call` is an unsafe replacement for a function call: use this
477      * function instead.
478      *
479      * If `target` reverts with a revert reason, it is bubbled up by this
480      * function (like regular Solidity function calls).
481      *
482      * Returns the raw returned data. To convert to the expected return value,
483      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
484      *
485      * Requirements:
486      *
487      * - `target` must be a contract.
488      * - calling `target` with `data` must not revert.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
493         return functionCall(target, data, "Address: low-level call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
498      * `errorMessage` as a fallback revert reason when `target` reverts.
499      *
500      * _Available since v3.1._
501      */
502     function functionCall(
503         address target,
504         bytes memory data,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         return functionCallWithValue(target, data, 0, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but also transferring `value` wei to `target`.
513      *
514      * Requirements:
515      *
516      * - the calling contract must have an ETH balance of at least `value`.
517      * - the called Solidity function must be `payable`.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(
522         address target,
523         bytes memory data,
524         uint256 value
525     ) internal returns (bytes memory) {
526         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
531      * with `errorMessage` as a fallback revert reason when `target` reverts.
532      *
533      * _Available since v3.1._
534      */
535     function functionCallWithValue(
536         address target,
537         bytes memory data,
538         uint256 value,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         require(address(this).balance >= value, "Address: insufficient balance for call");
542         require(isContract(target), "Address: call to non-contract");
543 
544         (bool success, bytes memory returndata) = target.call{value: value}(data);
545         return _verifyCallResult(success, returndata, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but performing a static call.
551      *
552      * _Available since v3.3._
553      */
554     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
555         return functionStaticCall(target, data, "Address: low-level static call failed");
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
560      * but performing a static call.
561      *
562      * _Available since v3.3._
563      */
564     function functionStaticCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal view returns (bytes memory) {
569         require(isContract(target), "Address: static call to non-contract");
570 
571         (bool success, bytes memory returndata) = target.staticcall(data);
572         return _verifyCallResult(success, returndata, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
582         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
587      * but performing a delegate call.
588      *
589      * _Available since v3.4._
590      */
591     function functionDelegateCall(
592         address target,
593         bytes memory data,
594         string memory errorMessage
595     ) internal returns (bytes memory) {
596         require(isContract(target), "Address: delegate call to non-contract");
597 
598         (bool success, bytes memory returndata) = target.delegatecall(data);
599         return _verifyCallResult(success, returndata, errorMessage);
600     }
601 
602     function _verifyCallResult(
603         bool success,
604         bytes memory returndata,
605         string memory errorMessage
606     ) private pure returns (bytes memory) {
607         if (success) {
608             return returndata;
609         } else {
610             // Look for revert reason and bubble it up if present
611             if (returndata.length > 0) {
612                 // The easiest way to bubble the revert reason is using memory via assembly
613 
614                 assembly {
615                     let returndata_size := mload(returndata)
616                     revert(add(32, returndata), returndata_size)
617                 }
618             } else {
619                 revert(errorMessage);
620             }
621         }
622     }
623 }
624 
625 /**
626  * @dev Implementation of the {IERC165} interface.
627  *
628  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
629  * for the additional interface id that will be supported. For example:
630  *
631  * ```solidity
632  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
633  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
634  * }
635  * ```
636  *
637  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
638  */
639 abstract contract ERC165 is IERC165 {
640     /**
641      * @dev See {IERC165-supportsInterface}.
642      */
643     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
644         return interfaceId == type(IERC165).interfaceId;
645     }
646 }
647 
648 /**
649  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
650  * the Metadata extension, but not including the Enumerable extension, which is available separately as
651  * {ERC721Enumerable}.
652  */
653 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
654     using Address for address;
655     using Strings for uint256;
656 
657     // Token name
658     string private _name;
659 
660     // Token symbol
661     string private _symbol;
662 
663     // Mapping from token ID to owner address
664     mapping(uint256 => address) private _owners;
665 
666     // Mapping owner address to token count
667     mapping(address => uint256) private _balances;
668 
669     // Mapping from token ID to approved address
670     mapping(uint256 => address) private _tokenApprovals;
671 
672     // Mapping from owner to operator approvals
673     mapping(address => mapping(address => bool)) private _operatorApprovals;
674 
675     /**
676      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
677      */
678     constructor(string memory name_, string memory symbol_) {
679         _name = name_;
680         _symbol = symbol_;
681     }
682 
683     /**
684      * @dev See {IERC165-supportsInterface}.
685      */
686     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
687         return
688             interfaceId == type(IERC721).interfaceId ||
689             interfaceId == type(IERC721Metadata).interfaceId ||
690             super.supportsInterface(interfaceId);
691     }
692 
693     /**
694      * @dev See {IERC721-balanceOf}.
695      */
696     function balanceOf(address owner) public view virtual override returns (uint256) {
697         require(owner != address(0), "ERC721: balance query for the zero address");
698         return _balances[owner];
699     }
700 
701     /**
702      * @dev See {IERC721-ownerOf}.
703      */
704     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
705         address owner = _owners[tokenId];
706         require(owner != address(0), "ERC721: owner query for nonexistent token");
707         return owner;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-name}.
712      */
713     function name() public view virtual override returns (string memory) {
714         return _name;
715     }
716 
717     /**
718      * @dev See {IERC721Metadata-symbol}.
719      */
720     function symbol() public view virtual override returns (string memory) {
721         return _symbol;
722     }
723 
724     /**
725      * @dev See {IERC721Metadata-tokenURI}.
726      */
727     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
728         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
729 
730         string memory baseURI = _baseURI();
731         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
732     }
733 
734     /**
735      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
736      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
737      * by default, can be overriden in child contracts.
738      */
739     function _baseURI() internal view virtual returns (string memory) {
740         return "";
741     }
742 
743     /**
744      * @dev See {IERC721-approve}.
745      */
746     function approve(address to, uint256 tokenId) public virtual override {
747         address owner = ERC721.ownerOf(tokenId);
748         require(to != owner, "ERC721: approval to current owner");
749 
750         require(
751             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
752             "ERC721: approve caller is not owner nor approved for all"
753         );
754 
755         _approve(to, tokenId);
756     }
757 
758     /**
759      * @dev See {IERC721-getApproved}.
760      */
761     function getApproved(uint256 tokenId) public view virtual override returns (address) {
762         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
763 
764         return _tokenApprovals[tokenId];
765     }
766 
767     /**
768      * @dev See {IERC721-setApprovalForAll}.
769      */
770     function setApprovalForAll(address operator, bool approved) public virtual override {
771         require(operator != _msgSender(), "ERC721: approve to caller");
772 
773         _operatorApprovals[_msgSender()][operator] = approved;
774         emit ApprovalForAll(_msgSender(), operator, approved);
775     }
776 
777     /**
778      * @dev See {IERC721-isApprovedForAll}.
779      */
780     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
781         return _operatorApprovals[owner][operator];
782     }
783 
784     /**
785      * @dev See {IERC721-transferFrom}.
786      */
787     function transferFrom(
788         address from,
789         address to,
790         uint256 tokenId
791     ) public virtual override {
792         //solhint-disable-next-line max-line-length
793         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
794 
795         _transfer(from, to, tokenId);
796     }
797 
798     /**
799      * @dev See {IERC721-safeTransferFrom}.
800      */
801     function safeTransferFrom(
802         address from,
803         address to,
804         uint256 tokenId
805     ) public virtual override {
806         safeTransferFrom(from, to, tokenId, "");
807     }
808 
809     /**
810      * @dev See {IERC721-safeTransferFrom}.
811      */
812     function safeTransferFrom(
813         address from,
814         address to,
815         uint256 tokenId,
816         bytes memory _data
817     ) public virtual override {
818         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
819         _safeTransfer(from, to, tokenId, _data);
820     }
821 
822     /**
823      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
824      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
825      *
826      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
827      *
828      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
829      * implement alternative mechanisms to perform token transfer, such as signature-based.
830      *
831      * Requirements:
832      *
833      * - `from` cannot be the zero address.
834      * - `to` cannot be the zero address.
835      * - `tokenId` token must exist and be owned by `from`.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _safeTransfer(
841         address from,
842         address to,
843         uint256 tokenId,
844         bytes memory _data
845     ) internal virtual {
846         _transfer(from, to, tokenId);
847         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
848     }
849 
850     /**
851      * @dev Returns whether `tokenId` exists.
852      *
853      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
854      *
855      * Tokens start existing when they are minted (`_mint`),
856      * and stop existing when they are burned (`_burn`).
857      */
858     function _exists(uint256 tokenId) internal view virtual returns (bool) {
859         return _owners[tokenId] != address(0);
860     }
861 
862     /**
863      * @dev Returns whether `spender` is allowed to manage `tokenId`.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must exist.
868      */
869     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
870         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
871         address owner = ERC721.ownerOf(tokenId);
872         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
873     }
874 
875     /**
876      * @dev Safely mints `tokenId` and transfers it to `to`.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must not exist.
881      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _safeMint(address to, uint256 tokenId) internal virtual {
886         _safeMint(to, tokenId, "");
887     }
888 
889     /**
890      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
891      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
892      */
893     function _safeMint(
894         address to,
895         uint256 tokenId,
896         bytes memory _data
897     ) internal virtual {
898         _mint(to, tokenId);
899         require(
900             _checkOnERC721Received(address(0), to, tokenId, _data),
901             "ERC721: transfer to non ERC721Receiver implementer"
902         );
903     }
904 
905     /**
906      * @dev Mints `tokenId` and transfers it to `to`.
907      *
908      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
909      *
910      * Requirements:
911      *
912      * - `tokenId` must not exist.
913      * - `to` cannot be the zero address.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _mint(address to, uint256 tokenId) internal virtual {
918         require(to != address(0), "ERC721: mint to the zero address");
919         require(!_exists(tokenId), "ERC721: token already minted");
920 
921         _beforeTokenTransfer(address(0), to, tokenId);
922 
923         _balances[to] += 1;
924         _owners[tokenId] = to;
925 
926         emit Transfer(address(0), to, tokenId);
927     }
928 
929     /**
930      * @dev Destroys `tokenId`.
931      * The approval is cleared when the token is burned.
932      *
933      * Requirements:
934      *
935      * - `tokenId` must exist.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _burn(uint256 tokenId) internal virtual {
940         address owner = ERC721.ownerOf(tokenId);
941 
942         _beforeTokenTransfer(owner, address(0), tokenId);
943 
944         // Clear approvals
945         _approve(address(0), tokenId);
946 
947         _balances[owner] -= 1;
948         delete _owners[tokenId];
949 
950         emit Transfer(owner, address(0), tokenId);
951     }
952 
953     /**
954      * @dev Transfers `tokenId` from `from` to `to`.
955      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
956      *
957      * Requirements:
958      *
959      * - `to` cannot be the zero address.
960      * - `tokenId` token must be owned by `from`.
961      *
962      * Emits a {Transfer} event.
963      */
964     function _transfer(
965         address from,
966         address to,
967         uint256 tokenId
968     ) internal virtual {
969         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
970         require(to != address(0), "ERC721: transfer to the zero address");
971 
972         _beforeTokenTransfer(from, to, tokenId);
973 
974         // Clear approvals from the previous owner
975         _approve(address(0), tokenId);
976 
977         _balances[from] -= 1;
978         _balances[to] += 1;
979         _owners[tokenId] = to;
980 
981         emit Transfer(from, to, tokenId);
982     }
983 
984     /**
985      * @dev Approve `to` to operate on `tokenId`
986      *
987      * Emits a {Approval} event.
988      */
989     function _approve(address to, uint256 tokenId) internal virtual {
990         _tokenApprovals[tokenId] = to;
991         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
992     }
993 
994     /**
995      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
996      * The call is not executed if the target address is not a contract.
997      *
998      * @param from address representing the previous owner of the given token ID
999      * @param to target address that will receive the tokens
1000      * @param tokenId uint256 ID of the token to be transferred
1001      * @param _data bytes optional data to send along with the call
1002      * @return bool whether the call correctly returned the expected magic value
1003      */
1004     function _checkOnERC721Received(
1005         address from,
1006         address to,
1007         uint256 tokenId,
1008         bytes memory _data
1009     ) private returns (bool) {
1010         if (to.isContract()) {
1011             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1012                 return retval == IERC721Receiver(to).onERC721Received.selector;
1013             } catch (bytes memory reason) {
1014                 if (reason.length == 0) {
1015                     revert("ERC721: transfer to non ERC721Receiver implementer");
1016                 } else {
1017                     assembly {
1018                         revert(add(32, reason), mload(reason))
1019                     }
1020                 }
1021             }
1022         } else {
1023             return true;
1024         }
1025     }
1026 
1027     /**
1028      * @dev Hook that is called before any token transfer. This includes minting
1029      * and burning.
1030      *
1031      * Calling conditions:
1032      *
1033      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1034      * transferred to `to`.
1035      * - When `from` is zero, `tokenId` will be minted for `to`.
1036      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1037      * - `from` and `to` are never both zero.
1038      *
1039      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1040      */
1041     function _beforeTokenTransfer(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) internal virtual {}
1046 }
1047 
1048 /**
1049  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1050  * @dev See https://eips.ethereum.org/EIPS/eip-721
1051  */
1052 interface IERC721Enumerable is IERC721 {
1053     /**
1054      * @dev Returns the total amount of tokens stored by the contract.
1055      */
1056     function totalSupply() external view returns (uint256);
1057 
1058     /**
1059      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1060      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1061      */
1062     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1063 
1064     /**
1065      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1066      * Use along with {totalSupply} to enumerate all tokens.
1067      */
1068     function tokenByIndex(uint256 index) external view returns (uint256);
1069 }
1070 
1071 /**
1072  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1073  * enumerability of all the token ids in the contract as well as all token ids owned by each
1074  * account.
1075  */
1076 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1077     // Mapping from owner to list of owned token IDs
1078     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1079 
1080     // Mapping from token ID to index of the owner tokens list
1081     mapping(uint256 => uint256) private _ownedTokensIndex;
1082 
1083     // Array with all token ids, used for enumeration
1084     uint256[] private _allTokens;
1085 
1086     // Mapping from token id to position in the allTokens array
1087     mapping(uint256 => uint256) private _allTokensIndex;
1088 
1089     /**
1090      * @dev See {IERC165-supportsInterface}.
1091      */
1092     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1093         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1098      */
1099     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1100         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1101         return _ownedTokens[owner][index];
1102     }
1103 
1104     /**
1105      * @dev See {IERC721Enumerable-totalSupply}.
1106      */
1107     function totalSupply() public view virtual override returns (uint256) {
1108         return _allTokens.length;
1109     }
1110 
1111     /**
1112      * @dev See {IERC721Enumerable-tokenByIndex}.
1113      */
1114     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1115         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1116         return _allTokens[index];
1117     }
1118 
1119     /**
1120      * @dev Hook that is called before any token transfer. This includes minting
1121      * and burning.
1122      *
1123      * Calling conditions:
1124      *
1125      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1126      * transferred to `to`.
1127      * - When `from` is zero, `tokenId` will be minted for `to`.
1128      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1129      * - `from` cannot be the zero address.
1130      * - `to` cannot be the zero address.
1131      *
1132      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1133      */
1134     function _beforeTokenTransfer(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) internal virtual override {
1139         super._beforeTokenTransfer(from, to, tokenId);
1140 
1141         if (from == address(0)) {
1142             _addTokenToAllTokensEnumeration(tokenId);
1143         } else if (from != to) {
1144             _removeTokenFromOwnerEnumeration(from, tokenId);
1145         }
1146         if (to == address(0)) {
1147             _removeTokenFromAllTokensEnumeration(tokenId);
1148         } else if (to != from) {
1149             _addTokenToOwnerEnumeration(to, tokenId);
1150         }
1151     }
1152 
1153     /**
1154      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1155      * @param to address representing the new owner of the given token ID
1156      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1157      */
1158     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1159         uint256 length = ERC721.balanceOf(to);
1160         _ownedTokens[to][length] = tokenId;
1161         _ownedTokensIndex[tokenId] = length;
1162     }
1163 
1164     /**
1165      * @dev Private function to add a token to this extension's token tracking data structures.
1166      * @param tokenId uint256 ID of the token to be added to the tokens list
1167      */
1168     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1169         _allTokensIndex[tokenId] = _allTokens.length;
1170         _allTokens.push(tokenId);
1171     }
1172 
1173     /**
1174      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1175      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1176      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1177      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1178      * @param from address representing the previous owner of the given token ID
1179      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1180      */
1181     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1182         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1183         // then delete the last slot (swap and pop).
1184 
1185         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1186         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1187 
1188         // When the token to delete is the last token, the swap operation is unnecessary
1189         if (tokenIndex != lastTokenIndex) {
1190             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1191 
1192             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1193             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1194         }
1195 
1196         // This also deletes the contents at the last position of the array
1197         delete _ownedTokensIndex[tokenId];
1198         delete _ownedTokens[from][lastTokenIndex];
1199     }
1200 
1201     /**
1202      * @dev Private function to remove a token from this extension's token tracking data structures.
1203      * This has O(1) time complexity, but alters the order of the _allTokens array.
1204      * @param tokenId uint256 ID of the token to be removed from the tokens list
1205      */
1206     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1207         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1208         // then delete the last slot (swap and pop).
1209 
1210         uint256 lastTokenIndex = _allTokens.length - 1;
1211         uint256 tokenIndex = _allTokensIndex[tokenId];
1212 
1213         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1214         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1215         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1216         uint256 lastTokenId = _allTokens[lastTokenIndex];
1217 
1218         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1219         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1220 
1221         // This also deletes the contents at the last position of the array
1222         delete _allTokensIndex[tokenId];
1223         _allTokens.pop();
1224     }
1225 }
1226 
1227 contract Aloot is ERC721Enumerable, ReentrancyGuard, Ownable {
1228 
1229     string[] private ships = [
1230         "Executioner - Frigate",
1231         "Inquistor - Destroyer",
1232         "Leviathan - Titan",
1233         "Apostle - Carrier",
1234         "Dragoon - Destroyer",
1235         "Corax - Fighter",
1236         "Revelation - Dreadnought",
1237         "Avatar - Transporter",
1238         "Raven - Fighter",
1239         "Archon - Carrier",
1240         "Reaper - Fighter",
1241         "Omen - Cruiser",
1242         "Celestis - Cruiser",
1243         "Apocalypse - Dreadnought",
1244         "Cyclone - Fighter",
1245         "Providence - Transporter",
1246         "Obelisk - Destroyer",
1247         "Erebus - Transporter",
1248         "Ishtar - Frigate",
1249         "Naga - Frigate",
1250         "Navitas - Fighter",
1251         "Charon - Carrier"
1252     ];
1253 
1254     string[] private weapons = [
1255         "M4 Carbine",
1256         "M8 Avenger",
1257         "M15 Vindicator",
1258         "M76 Revenant",
1259         "M96 Punisher",
1260         "M105 Reapear",
1261         "M666 Armageddon",
1262         "The Widowmaker",
1263         "Vanquisher",
1264         "Javelin Launcher",
1265         "Phaser",
1266         "Plasma Shotgun",
1267         "Katana",
1268         "The Eviscerator",
1269         "Scattershot Shotgun",
1270         "Shock Blade",
1271         "Energy Sword",
1272         "Arc Gun",
1273         "Combat Knife",
1274         "Pulse Rifle",
1275         "Pistol",
1276         "Shotgun",
1277         "Rifle"
1278     ];
1279 
1280     string[] private headArmor = [
1281         "Umbra Visor",
1282         "Archon Visor",
1283         "Tormentor Helmet",
1284         "Kestrel Helmet",
1285         "Death Mask",
1286         "Mnemonic Visor",
1287         "Recon Hood",
1288         "Shadow Visor",
1289         "Vexor Helmet",
1290         "Visor",
1291         "Armored Helmet",
1292         "Armored Mask",
1293         "Reinforced Helmet",
1294         "Harbinger Helmet",
1295         "Armageddon Helmet",
1296         "Basic Helmet"
1297     ];
1298 
1299     string[] private chestArmor = [
1300         "Armored Chestplate",
1301         "Aegis Vest",
1302         "Chestplate",
1303         "Basic Armor",
1304         "Shadow Harness",
1305         "Armored Vest",
1306         "Reinforced Vest",
1307         "Nanotech Suit",
1308         "Armageddon Exoskeleton",
1309         "Umbra Armor",
1310         "Archon Armor",
1311         "Tormentor Armor",
1312         "Death Armor",
1313         "Vexor Vest",
1314         "Vest",
1315         "Harbinger Armor",
1316         "Guardian Armor"
1317     ];
1318 
1319     string[] private footArmor = [
1320         "Armored Boots",
1321         "Aegis Boots",
1322         "Capacitor Boots",
1323         "Basic Boots",
1324         "Reinforced Boots",
1325         "Nanotech Boots",
1326         "Drake Boots",
1327         "Umbra Boots",
1328         "Archon Boots",
1329         "Tormentor Boots",
1330         "Death Boots",
1331         "Vexor Boots",
1332         "Mnenomic Boots",
1333         "Harbinger Boots",
1334         "Guardian Boots"
1335     ];
1336 
1337     string[] private handArmor = [
1338         "Studded Gloves",
1339         "Gloves",
1340         "Capacitor Gloves",
1341         "Basic Gloves",
1342         "Reinforced Gloves",
1343         "Nanotech Gloves",
1344         "Drake Gloves",
1345         "Leather Gloves",
1346         "Archon Gloves",
1347         "Tormentor Gloves",
1348         "Death Gloves",
1349         "Vexor Gloves",
1350         "Armored Gloves",
1351         "Harbinger Gloves",
1352         "Armageddon Gloves",
1353         "Guardian Gloves"
1354     ];
1355 
1356     string[] private necklaces = [
1357         "Steel Chain",
1358         "Holy Rosary",
1359         "Gold Chain",
1360         "Metal Dog Tags",
1361         "Silver Chain"
1362     ];
1363 
1364     string[] private rings = [
1365         "Power Ring",
1366         "Gold Ring",
1367         "Silver Ring",
1368         "Ring",
1369         "Nanotech Ring",
1370         "Tempest Ring",
1371         "Steel Ring",
1372         "Energy Ring",
1373         "Archon Ring",
1374         "Umbra Ring",
1375         "Kestrel Ring",
1376         "Drake Ring"
1377         "Vexor Ring"
1378     ];
1379 
1380     string[] private suffixes = [
1381         "of Valour",
1382         "of Pride",
1383         "of Skill",
1384         "of Perfection",
1385         "of Accuracy",
1386         "of Fury",
1387         "of Stealth",
1388         "of Power",
1389         "of Protection",
1390         "of Englightenment",
1391         "of Leadership",
1392         "of Courage",
1393         "of Bravery",
1394         "of Death",
1395         "of Integrity",
1396         "of Respect",
1397         "of Agility"
1398     ];
1399 
1400     string[] private namePrefixes = [
1401         "Agony",
1402         "Apocalpyse",
1403         "Armageddon",
1404         "Cataclysm",
1405         "Corruption",
1406         "Death",
1407         "Empyrean",
1408         "Doom",
1409         "Dread",
1410         "Hate",
1411         "Havoc",
1412         "Oblivion",
1413         "Onslaught",
1414         "Pain",
1415         "Pandemonium",
1416         "Rapture",
1417         "Torment",
1418         "Soul",
1419         "Tempest",
1420         "Vengeance",
1421         "Storm",
1422         "Light",
1423         "Victory",
1424         "Valour",
1425         "Brave",
1426         "Strength",
1427         "Legend",
1428         "Blood"
1429     ];
1430 
1431     string[] private nameSuffixes = [
1432         "Bane",
1433         "Star",
1434         "Nebula",
1435         "Shadow",
1436         "Moon",
1437         "Death",
1438         "Song",
1439         "King",
1440         "Queen",
1441         "Prince",
1442         "Elite",
1443         "Apex",
1444         "Spirit",
1445         "Dragoon",
1446         "Despair",
1447         "Serpent",
1448         "Reaper",
1449         "Brightsword",
1450         "Destiny",
1451         "Fate",
1452         "Ghost",
1453         "Astra"
1454     ];
1455 
1456     function random(string memory input) internal pure returns (uint256) {
1457         return uint256(keccak256(abi.encodePacked(input)));
1458     }
1459 
1460     function getShip(uint256 tokenId) public view returns (string memory) {
1461         return pluck(tokenId, "SHIP", ships);
1462     }
1463 
1464     function getWeapon(uint256 tokenId) public view returns (string memory) {
1465         return pluck(tokenId, "WEAPON", weapons);
1466     }
1467 
1468     function getHead(uint256 tokenId) public view returns (string memory) {
1469         return pluck(tokenId, "HEAD", headArmor);
1470     }
1471 
1472     function getChest(uint256 tokenId) public view returns (string memory) {
1473         return pluck(tokenId, "CHEST", chestArmor);
1474     }
1475 
1476     function getFoot(uint256 tokenId) public view returns (string memory) {
1477         return pluck(tokenId, "FOOT", footArmor);
1478     }
1479 
1480     function getHand(uint256 tokenId) public view returns (string memory) {
1481         return pluck(tokenId, "HAND", handArmor);
1482     }
1483 
1484     function getNeck(uint256 tokenId) public view returns (string memory) {
1485         return pluck(tokenId, "NECK", necklaces);
1486     }
1487 
1488     function getRing(uint256 tokenId) public view returns (string memory) {
1489         return pluck(tokenId, "RING", rings);
1490     }
1491 
1492     function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
1493         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1494         string memory output = sourceArray[rand % sourceArray.length];
1495         uint256 greatness = rand % 21;
1496         if (greatness > 14) {
1497             output = string(abi.encodePacked(output, " ", suffixes[rand % suffixes.length]));
1498         }
1499         if (greatness >= 19) {
1500             string[2] memory name;
1501             name[0] = namePrefixes[rand % namePrefixes.length];
1502             name[1] = nameSuffixes[rand % nameSuffixes.length];
1503             if (greatness == 19) {
1504                 output = string(abi.encodePacked('"', name[0], ' ', name[1], '" ', output));
1505             } else {
1506                 output = string(abi.encodePacked('"', name[0], ' ', name[1], '" ', output, " +1"));
1507             }
1508         }
1509         return output;
1510     }
1511 
1512     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1513         string[17] memory parts;
1514         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#2e2b89" /><text x="10" y="20" class="base">';
1515 
1516         parts[1] = getShip(tokenId);
1517 
1518         parts[2] = '</text><text x="10" y="40" class="base">';
1519 
1520         parts[3] = getWeapon(tokenId);
1521 
1522         parts[4] = '</text><text x="10" y="60" class="base">';
1523 
1524         parts[5] = getHead(tokenId);
1525 
1526         parts[6] = '</text><text x="10" y="80" class="base">';
1527 
1528         parts[7] = getChest(tokenId);
1529 
1530         parts[8] = '</text><text x="10" y="100" class="base">';
1531 
1532         parts[9] = getFoot(tokenId);
1533 
1534         parts[10] = '</text><text x="10" y="120" class="base">';
1535 
1536         parts[11] = getHand(tokenId);
1537 
1538         parts[12] = '</text><text x="10" y="140" class="base">';
1539 
1540         parts[13] = getNeck(tokenId);
1541 
1542         parts[14] = '</text><text x="10" y="160" class="base">';
1543 
1544         parts[15] = getRing(tokenId);
1545 
1546         parts[16] = '</text></svg>';
1547 
1548         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1549         output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
1550 
1551         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "ALOOT #', toString(tokenId), '", "description": "Ad Astra Per Aspera.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1552         output = string(abi.encodePacked('data:application/json;base64,', json));
1553 
1554         return output;
1555     }
1556 
1557     function claim(uint256 tokenId) public nonReentrant {
1558         require(tokenId > 0 && tokenId < 8009, "Token ID invalid");
1559         _safeMint(_msgSender(), tokenId);
1560     }
1561 
1562     function toString(uint256 value) internal pure returns (string memory) {
1563     // Inspired by OraclizeAPI's implementation - MIT license
1564     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1565 
1566         if (value == 0) {
1567             return "0";
1568         }
1569         uint256 temp = value;
1570         uint256 digits;
1571         while (temp != 0) {
1572             digits++;
1573             temp /= 10;
1574         }
1575         bytes memory buffer = new bytes(digits);
1576         while (value != 0) {
1577             digits -= 1;
1578             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1579             value /= 10;
1580         }
1581         return string(buffer);
1582     }
1583 
1584     constructor() ERC721("ALoot", "ALOOT") Ownable() {}
1585 }
1586 
1587 /// [MIT License]
1588 /// @title Base64
1589 /// @notice Provides a function for encoding some bytes in base64
1590 /// @author Brecht Devos <brecht@loopring.org>
1591 library Base64 {
1592     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1593 
1594     /// @notice Encodes some bytes to the base64 representation
1595     function encode(bytes memory data) internal pure returns (string memory) {
1596         uint256 len = data.length;
1597         if (len == 0) return "";
1598 
1599         // multiply by 4/3 rounded up
1600         uint256 encodedLen = 4 * ((len + 2) / 3);
1601 
1602         // Add some extra buffer at the end
1603         bytes memory result = new bytes(encodedLen + 32);
1604 
1605         bytes memory table = TABLE;
1606 
1607         assembly {
1608             let tablePtr := add(table, 1)
1609             let resultPtr := add(result, 32)
1610 
1611             for {
1612                 let i := 0
1613             } lt(i, len) {
1614 
1615             } {
1616                 i := add(i, 3)
1617                 let input := and(mload(add(data, i)), 0xffffff)
1618 
1619                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1620                 out := shl(8, out)
1621                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1622                 out := shl(8, out)
1623                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1624                 out := shl(8, out)
1625                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1626                 out := shl(224, out)
1627 
1628                 mstore(resultPtr, out)
1629 
1630                 resultPtr := add(resultPtr, 4)
1631             }
1632 
1633             switch mod(len, 3)
1634             case 1 {
1635                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1636             }
1637             case 2 {
1638                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1639             }
1640 
1641             mstore(result, encodedLen)
1642         }
1643 
1644         return string(result);
1645     }
1646 }