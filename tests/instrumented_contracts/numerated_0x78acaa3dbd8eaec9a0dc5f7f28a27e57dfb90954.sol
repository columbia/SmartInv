1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-06
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-09-04
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * https://eips.ethereum.org/EIPS/eip-165[EIP].
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others ({ERC165Checker}).
19  *
20  * For an implementation, see {ERC165}.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52 
53     /**
54      * @dev Returns the number of tokens in ``owner``'s account.
55      */
56     function balanceOf(address owner) external view returns (uint256 balance);
57 
58     /**
59      * @dev Returns the owner of the `tokenId` token.
60      *
61      * Requirements:
62      *
63      * - `tokenId` must exist.
64      */
65     function ownerOf(uint256 tokenId) external view returns (address owner);
66 
67     /**
68      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
69      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(
82         address from,
83         address to,
84         uint256 tokenId
85     ) external;
86 
87     /**
88      * @dev Transfers `tokenId` token from `from` to `to`.
89      *
90      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must be owned by `from`.
97      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
109      * The approval is cleared when the token is transferred.
110      *
111      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
112      *
113      * Requirements:
114      *
115      * - The caller must own the token or be an approved operator.
116      * - `tokenId` must exist.
117      *
118      * Emits an {Approval} event.
119      */
120     function approve(address to, uint256 tokenId) external;
121 
122     /**
123      * @dev Returns the account approved for `tokenId` token.
124      *
125      * Requirements:
126      *
127      * - `tokenId` must exist.
128      */
129     function getApproved(uint256 tokenId) external view returns (address operator);
130 
131     /**
132      * @dev Approve or remove `operator` as an operator for the caller.
133      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
134      *
135      * Requirements:
136      *
137      * - The `operator` cannot be the caller.
138      *
139      * Emits an {ApprovalForAll} event.
140      */
141     function setApprovalForAll(address operator, bool _approved) external;
142 
143     /**
144      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
145      *
146      * See {setApprovalForAll}
147      */
148     function isApprovedForAll(address owner, address operator) external view returns (bool);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must exist and be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
160      *
161      * Emits a {Transfer} event.
162      */
163     function safeTransferFrom(
164         address from,
165         address to,
166         uint256 tokenId,
167         bytes calldata data
168     ) external;
169 }
170 
171 /**
172  * @dev String operations.
173  */
174 library Strings {
175     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
176 
177     /**
178      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
179      */
180     function toString(uint256 value) internal pure returns (string memory) {
181         // Inspired by OraclizeAPI's implementation - MIT licence
182         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
183 
184         if (value == 0) {
185             return "0";
186         }
187         uint256 temp = value;
188         uint256 digits;
189         while (temp != 0) {
190             digits++;
191             temp /= 10;
192         }
193         bytes memory buffer = new bytes(digits);
194         while (value != 0) {
195             digits -= 1;
196             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
197             value /= 10;
198         }
199         return string(buffer);
200     }
201 
202     /**
203      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
204      */
205     function toHexString(uint256 value) internal pure returns (string memory) {
206         if (value == 0) {
207             return "0x00";
208         }
209         uint256 temp = value;
210         uint256 length = 0;
211         while (temp != 0) {
212             length++;
213             temp >>= 8;
214         }
215         return toHexString(value, length);
216     }
217 
218     /**
219      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
220      */
221     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
222         bytes memory buffer = new bytes(2 * length + 2);
223         buffer[0] = "0";
224         buffer[1] = "x";
225         for (uint256 i = 2 * length + 1; i > 1; --i) {
226             buffer[i] = _HEX_SYMBOLS[value & 0xf];
227             value >>= 4;
228         }
229         require(value == 0, "Strings: hex length insufficient");
230         return string(buffer);
231     }
232 }
233 
234 /*
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 abstract contract Context {
245     function _msgSender() internal view virtual returns (address) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes calldata) {
250         return msg.data;
251     }
252 }
253 
254 /**
255  * @dev Contract module which provides a basic access control mechanism, where
256  * there is an account (an owner) that can be granted exclusive access to
257  * specific functions.
258  *
259  * By default, the owner account will be the one that deploys the contract. This
260  * can later be changed with {transferOwnership}.
261  *
262  * This module is used through inheritance. It will make available the modifier
263  * `onlyOwner`, which can be applied to your functions to restrict their use to
264  * the owner.
265  */
266 abstract contract Ownable is Context {
267     address private _owner;
268 
269     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
270 
271     /**
272      * @dev Initializes the contract setting the deployer as the initial owner.
273      */
274     constructor() {
275         _setOwner(_msgSender());
276     }
277 
278     /**
279      * @dev Returns the address of the current owner.
280      */
281     function owner() public view virtual returns (address) {
282         return _owner;
283     }
284 
285     /**
286      * @dev Throws if called by any account other than the owner.
287      */
288     modifier onlyOwner() {
289         require(owner() == _msgSender(), "Ownable: caller is not the owner");
290         _;
291     }
292 
293     /**
294      * @dev Leaves the contract without owner. It will not be possible to call
295      * `onlyOwner` functions anymore. Can only be called by the current owner.
296      *
297      * NOTE: Renouncing ownership will leave the contract without an owner,
298      * thereby removing any functionality that is only available to the owner.
299      */
300     function renounceOwnership() public virtual onlyOwner {
301         _setOwner(address(0));
302     }
303 
304     /**
305      * @dev Transfers ownership of the contract to a new account (`newOwner`).
306      * Can only be called by the current owner.
307      */
308     function transferOwnership(address newOwner) public virtual onlyOwner {
309         require(newOwner != address(0), "Ownable: new owner is the zero address");
310         _setOwner(newOwner);
311     }
312 
313     function _setOwner(address newOwner) private {
314         address oldOwner = _owner;
315         _owner = newOwner;
316         emit OwnershipTransferred(oldOwner, newOwner);
317     }
318 }
319 
320 /**
321  * @dev Contract module that helps prevent reentrant calls to a function.
322  *
323  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
324  * available, which can be applied to functions to make sure there are no nested
325  * (reentrant) calls to them.
326  *
327  * Note that because there is a single `nonReentrant` guard, functions marked as
328  * `nonReentrant` may not call one another. This can be worked around by making
329  * those functions `private`, and then adding `external` `nonReentrant` entry
330  * points to them.
331  *
332  * TIP: If you would like to learn more about reentrancy and alternative ways
333  * to protect against it, check out our blog post
334  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
335  */
336 abstract contract ReentrancyGuard {
337     // Booleans are more expensive than uint256 or any type that takes up a full
338     // word because each write operation emits an extra SLOAD to first read the
339     // slot's contents, replace the bits taken up by the boolean, and then write
340     // back. This is the compiler's defense against contract upgrades and
341     // pointer aliasing, and it cannot be disabled.
342 
343     // The values being non-zero value makes deployment a bit more expensive,
344     // but in exchange the refund on every call to nonReentrant will be lower in
345     // amount. Since refunds are capped to a percentage of the total
346     // transaction's gas, it is best to keep them low in cases like this one, to
347     // increase the likelihood of the full refund coming into effect.
348     uint256 private constant _NOT_ENTERED = 1;
349     uint256 private constant _ENTERED = 2;
350 
351     uint256 private _status;
352 
353     constructor() {
354         _status = _NOT_ENTERED;
355     }
356 
357     /**
358      * @dev Prevents a contract from calling itself, directly or indirectly.
359      * Calling a `nonReentrant` function from another `nonReentrant`
360      * function is not supported. It is possible to prevent this from happening
361      * by making the `nonReentrant` function external, and make it call a
362      * `private` function that does the actual work.
363      */
364     modifier nonReentrant() {
365         // On the first call to nonReentrant, _notEntered will be true
366         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
367 
368         // Any calls to nonReentrant after this point will fail
369         _status = _ENTERED;
370 
371         _;
372 
373         // By storing the original value once again, a refund is triggered (see
374         // https://eips.ethereum.org/EIPS/eip-2200)
375         _status = _NOT_ENTERED;
376     }
377 }
378 
379 /**
380  * @title ERC721 token receiver interface
381  * @dev Interface for any contract that wants to support safeTransfers
382  * from ERC721 asset contracts.
383  */
384 interface IERC721Receiver {
385     /**
386      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
387      * by `operator` from `from`, this function is called.
388      *
389      * It must return its Solidity selector to confirm the token transfer.
390      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
391      *
392      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
393      */
394     function onERC721Received(
395         address operator,
396         address from,
397         uint256 tokenId,
398         bytes calldata data
399     ) external returns (bytes4);
400 }
401 
402 /**
403  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
404  * @dev See https://eips.ethereum.org/EIPS/eip-721
405  */
406 interface IERC721Metadata is IERC721 {
407     /**
408      * @dev Returns the token collection name.
409      */
410     function name() external view returns (string memory);
411 
412     /**
413      * @dev Returns the token collection symbol.
414      */
415     function symbol() external view returns (string memory);
416 
417     /**
418      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
419      */
420     function tokenURI(uint256 tokenId) external view returns (string memory);
421 }
422 
423 /**
424  * @dev Collection of functions related to the address type
425  */
426 library Address {
427     /**
428      * @dev Returns true if `account` is a contract.
429      *
430      * [IMPORTANT]
431      * ====
432      * It is unsafe to assume that an address for which this function returns
433      * false is an externally-owned account (EOA) and not a contract.
434      *
435      * Among others, `isContract` will return false for the following
436      * types of addresses:
437      *
438      *  - an externally-owned account
439      *  - a contract in construction
440      *  - an address where a contract will be created
441      *  - an address where a contract lived, but was destroyed
442      * ====
443      */
444     function isContract(address account) internal view returns (bool) {
445         // This method relies on extcodesize, which returns 0 for contracts in
446         // construction, since the code is only stored at the end of the
447         // constructor execution.
448 
449         uint256 size;
450         assembly {
451             size := extcodesize(account)
452         }
453         return size > 0;
454     }
455 
456     /**
457      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
458      * `recipient`, forwarding all available gas and reverting on errors.
459      *
460      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
461      * of certain opcodes, possibly making contracts go over the 2300 gas limit
462      * imposed by `transfer`, making them unable to receive funds via
463      * `transfer`. {sendValue} removes this limitation.
464      *
465      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
466      *
467      * IMPORTANT: because control is transferred to `recipient`, care must be
468      * taken to not create reentrancy vulnerabilities. Consider using
469      * {ReentrancyGuard} or the
470      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
471      */
472     function sendValue(address payable recipient, uint256 amount) internal {
473         require(address(this).balance >= amount, "Address: insufficient balance");
474 
475         (bool success, ) = recipient.call{value: amount}("");
476         require(success, "Address: unable to send value, recipient may have reverted");
477     }
478 
479     /**
480      * @dev Performs a Solidity function call using a low level `call`. A
481      * plain `call` is an unsafe replacement for a function call: use this
482      * function instead.
483      *
484      * If `target` reverts with a revert reason, it is bubbled up by this
485      * function (like regular Solidity function calls).
486      *
487      * Returns the raw returned data. To convert to the expected return value,
488      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
489      *
490      * Requirements:
491      *
492      * - `target` must be a contract.
493      * - calling `target` with `data` must not revert.
494      *
495      * _Available since v3.1._
496      */
497     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
498         return functionCall(target, data, "Address: low-level call failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
503      * `errorMessage` as a fallback revert reason when `target` reverts.
504      *
505      * _Available since v3.1._
506      */
507     function functionCall(
508         address target,
509         bytes memory data,
510         string memory errorMessage
511     ) internal returns (bytes memory) {
512         return functionCallWithValue(target, data, 0, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but also transferring `value` wei to `target`.
518      *
519      * Requirements:
520      *
521      * - the calling contract must have an ETH balance of at least `value`.
522      * - the called Solidity function must be `payable`.
523      *
524      * _Available since v3.1._
525      */
526     function functionCallWithValue(
527         address target,
528         bytes memory data,
529         uint256 value
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
536      * with `errorMessage` as a fallback revert reason when `target` reverts.
537      *
538      * _Available since v3.1._
539      */
540     function functionCallWithValue(
541         address target,
542         bytes memory data,
543         uint256 value,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         require(address(this).balance >= value, "Address: insufficient balance for call");
547         require(isContract(target), "Address: call to non-contract");
548 
549         (bool success, bytes memory returndata) = target.call{value: value}(data);
550         return _verifyCallResult(success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but performing a static call.
556      *
557      * _Available since v3.3._
558      */
559     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
560         return functionStaticCall(target, data, "Address: low-level static call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
565      * but performing a static call.
566      *
567      * _Available since v3.3._
568      */
569     function functionStaticCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal view returns (bytes memory) {
574         require(isContract(target), "Address: static call to non-contract");
575 
576         (bool success, bytes memory returndata) = target.staticcall(data);
577         return _verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but performing a delegate call.
583      *
584      * _Available since v3.4._
585      */
586     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
587         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
592      * but performing a delegate call.
593      *
594      * _Available since v3.4._
595      */
596     function functionDelegateCall(
597         address target,
598         bytes memory data,
599         string memory errorMessage
600     ) internal returns (bytes memory) {
601         require(isContract(target), "Address: delegate call to non-contract");
602 
603         (bool success, bytes memory returndata) = target.delegatecall(data);
604         return _verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     function _verifyCallResult(
608         bool success,
609         bytes memory returndata,
610         string memory errorMessage
611     ) private pure returns (bytes memory) {
612         if (success) {
613             return returndata;
614         } else {
615             // Look for revert reason and bubble it up if present
616             if (returndata.length > 0) {
617                 // The easiest way to bubble the revert reason is using memory via assembly
618 
619                 assembly {
620                     let returndata_size := mload(returndata)
621                     revert(add(32, returndata), returndata_size)
622                 }
623             } else {
624                 revert(errorMessage);
625             }
626         }
627     }
628 }
629 
630 /**
631  * @dev Implementation of the {IERC165} interface.
632  *
633  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
634  * for the additional interface id that will be supported. For example:
635  *
636  * ```solidity
637  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
638  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
639  * }
640  * ```
641  *
642  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
643  */
644 abstract contract ERC165 is IERC165 {
645     /**
646      * @dev See {IERC165-supportsInterface}.
647      */
648     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
649         return interfaceId == type(IERC165).interfaceId;
650     }
651 }
652 
653 /**
654  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
655  * the Metadata extension, but not including the Enumerable extension, which is available separately as
656  * {ERC721Enumerable}.
657  */
658 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
659     using Address for address;
660     using Strings for uint256;
661 
662     // Token name
663     string private _name;
664 
665     // Token symbol
666     string private _symbol;
667 
668     // Mapping from token ID to owner address
669     mapping(uint256 => address) private _owners;
670 
671     // Mapping owner address to token count
672     mapping(address => uint256) private _balances;
673 
674     // Mapping from token ID to approved address
675     mapping(uint256 => address) private _tokenApprovals;
676 
677     // Mapping from owner to operator approvals
678     mapping(address => mapping(address => bool)) private _operatorApprovals;
679 
680     /**
681      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
682      */
683     constructor(string memory name_, string memory symbol_) {
684         _name = name_;
685         _symbol = symbol_;
686     }
687 
688     /**
689      * @dev See {IERC165-supportsInterface}.
690      */
691     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
692         return
693             interfaceId == type(IERC721).interfaceId ||
694             interfaceId == type(IERC721Metadata).interfaceId ||
695             super.supportsInterface(interfaceId);
696     }
697 
698     /**
699      * @dev See {IERC721-balanceOf}.
700      */
701     function balanceOf(address owner) public view virtual override returns (uint256) {
702         require(owner != address(0), "ERC721: balance query for the zero address");
703         return _balances[owner];
704     }
705 
706     /**
707      * @dev See {IERC721-ownerOf}.
708      */
709     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
710         address owner = _owners[tokenId];
711         require(owner != address(0), "ERC721: owner query for nonexistent token");
712         return owner;
713     }
714 
715     /**
716      * @dev See {IERC721Metadata-name}.
717      */
718     function name() public view virtual override returns (string memory) {
719         return _name;
720     }
721 
722     /**
723      * @dev See {IERC721Metadata-symbol}.
724      */
725     function symbol() public view virtual override returns (string memory) {
726         return _symbol;
727     }
728 
729     /**
730      * @dev See {IERC721Metadata-tokenURI}.
731      */
732     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
733         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
734 
735         string memory baseURI = _baseURI();
736         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
737     }
738 
739     /**
740      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
741      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
742      * by default, can be overriden in child contracts.
743      */
744     function _baseURI() internal view virtual returns (string memory) {
745         return "";
746     }
747 
748     /**
749      * @dev See {IERC721-approve}.
750      */
751     function approve(address to, uint256 tokenId) public virtual override {
752         address owner = ERC721.ownerOf(tokenId);
753         require(to != owner, "ERC721: approval to current owner");
754 
755         require(
756             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
757             "ERC721: approve caller is not owner nor approved for all"
758         );
759 
760         _approve(to, tokenId);
761     }
762 
763     /**
764      * @dev See {IERC721-getApproved}.
765      */
766     function getApproved(uint256 tokenId) public view virtual override returns (address) {
767         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
768 
769         return _tokenApprovals[tokenId];
770     }
771 
772     /**
773      * @dev See {IERC721-setApprovalForAll}.
774      */
775     function setApprovalForAll(address operator, bool approved) public virtual override {
776         require(operator != _msgSender(), "ERC721: approve to caller");
777 
778         _operatorApprovals[_msgSender()][operator] = approved;
779         emit ApprovalForAll(_msgSender(), operator, approved);
780     }
781 
782     /**
783      * @dev See {IERC721-isApprovedForAll}.
784      */
785     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
786         return _operatorApprovals[owner][operator];
787     }
788 
789     /**
790      * @dev See {IERC721-transferFrom}.
791      */
792     function transferFrom(
793         address from,
794         address to,
795         uint256 tokenId
796     ) public virtual override {
797         //solhint-disable-next-line max-line-length
798         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
799 
800         _transfer(from, to, tokenId);
801     }
802 
803     /**
804      * @dev See {IERC721-safeTransferFrom}.
805      */
806     function safeTransferFrom(
807         address from,
808         address to,
809         uint256 tokenId
810     ) public virtual override {
811         safeTransferFrom(from, to, tokenId, "");
812     }
813 
814     /**
815      * @dev See {IERC721-safeTransferFrom}.
816      */
817     function safeTransferFrom(
818         address from,
819         address to,
820         uint256 tokenId,
821         bytes memory _data
822     ) public virtual override {
823         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
824         _safeTransfer(from, to, tokenId, _data);
825     }
826 
827     /**
828      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
829      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
830      *
831      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
832      *
833      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
834      * implement alternative mechanisms to perform token transfer, such as signature-based.
835      *
836      * Requirements:
837      *
838      * - `from` cannot be the zero address.
839      * - `to` cannot be the zero address.
840      * - `tokenId` token must exist and be owned by `from`.
841      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _safeTransfer(
846         address from,
847         address to,
848         uint256 tokenId,
849         bytes memory _data
850     ) internal virtual {
851         _transfer(from, to, tokenId);
852         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
853     }
854 
855     /**
856      * @dev Returns whether `tokenId` exists.
857      *
858      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
859      *
860      * Tokens start existing when they are minted (`_mint`),
861      * and stop existing when they are burned (`_burn`).
862      */
863     function _exists(uint256 tokenId) internal view virtual returns (bool) {
864         return _owners[tokenId] != address(0);
865     }
866 
867     /**
868      * @dev Returns whether `spender` is allowed to manage `tokenId`.
869      *
870      * Requirements:
871      *
872      * - `tokenId` must exist.
873      */
874     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
875         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
876         address owner = ERC721.ownerOf(tokenId);
877         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
878     }
879 
880     /**
881      * @dev Safely mints `tokenId` and transfers it to `to`.
882      *
883      * Requirements:
884      *
885      * - `tokenId` must not exist.
886      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _safeMint(address to, uint256 tokenId) internal virtual {
891         _safeMint(to, tokenId, "");
892     }
893 
894     /**
895      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
896      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
897      */
898     function _safeMint(
899         address to,
900         uint256 tokenId,
901         bytes memory _data
902     ) internal virtual {
903         _mint(to, tokenId);
904         require(
905             _checkOnERC721Received(address(0), to, tokenId, _data),
906             "ERC721: transfer to non ERC721Receiver implementer"
907         );
908     }
909 
910     /**
911      * @dev Mints `tokenId` and transfers it to `to`.
912      *
913      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
914      *
915      * Requirements:
916      *
917      * - `tokenId` must not exist.
918      * - `to` cannot be the zero address.
919      *
920      * Emits a {Transfer} event.
921      */
922     function _mint(address to, uint256 tokenId) internal virtual {
923         require(to != address(0), "ERC721: mint to the zero address");
924         require(!_exists(tokenId), "ERC721: token already minted");
925 
926         _beforeTokenTransfer(address(0), to, tokenId);
927 
928         _balances[to] += 1;
929         _owners[tokenId] = to;
930 
931         emit Transfer(address(0), to, tokenId);
932     }
933 
934     /**
935      * @dev Destroys `tokenId`.
936      * The approval is cleared when the token is burned.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must exist.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _burn(uint256 tokenId) internal virtual {
945         address owner = ERC721.ownerOf(tokenId);
946 
947         _beforeTokenTransfer(owner, address(0), tokenId);
948 
949         // Clear approvals
950         _approve(address(0), tokenId);
951 
952         _balances[owner] -= 1;
953         delete _owners[tokenId];
954 
955         emit Transfer(owner, address(0), tokenId);
956     }
957 
958     /**
959      * @dev Transfers `tokenId` from `from` to `to`.
960      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
961      *
962      * Requirements:
963      *
964      * - `to` cannot be the zero address.
965      * - `tokenId` token must be owned by `from`.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _transfer(
970         address from,
971         address to,
972         uint256 tokenId
973     ) internal virtual {
974         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
975         require(to != address(0), "ERC721: transfer to the zero address");
976 
977         _beforeTokenTransfer(from, to, tokenId);
978 
979         // Clear approvals from the previous owner
980         _approve(address(0), tokenId);
981 
982         _balances[from] -= 1;
983         _balances[to] += 1;
984         _owners[tokenId] = to;
985 
986         emit Transfer(from, to, tokenId);
987     }
988 
989     /**
990      * @dev Approve `to` to operate on `tokenId`
991      *
992      * Emits a {Approval} event.
993      */
994     function _approve(address to, uint256 tokenId) internal virtual {
995         _tokenApprovals[tokenId] = to;
996         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
997     }
998 
999     /**
1000      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1001      * The call is not executed if the target address is not a contract.
1002      *
1003      * @param from address representing the previous owner of the given token ID
1004      * @param to target address that will receive the tokens
1005      * @param tokenId uint256 ID of the token to be transferred
1006      * @param _data bytes optional data to send along with the call
1007      * @return bool whether the call correctly returned the expected magic value
1008      */
1009     function _checkOnERC721Received(
1010         address from,
1011         address to,
1012         uint256 tokenId,
1013         bytes memory _data
1014     ) private returns (bool) {
1015         if (to.isContract()) {
1016             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1017                 return retval == IERC721Receiver(to).onERC721Received.selector;
1018             } catch (bytes memory reason) {
1019                 if (reason.length == 0) {
1020                     revert("ERC721: transfer to non ERC721Receiver implementer");
1021                 } else {
1022                     assembly {
1023                         revert(add(32, reason), mload(reason))
1024                     }
1025                 }
1026             }
1027         } else {
1028             return true;
1029         }
1030     }
1031 
1032     /**
1033      * @dev Hook that is called before any token transfer. This includes minting
1034      * and burning.
1035      *
1036      * Calling conditions:
1037      *
1038      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1039      * transferred to `to`.
1040      * - When `from` is zero, `tokenId` will be minted for `to`.
1041      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1042      * - `from` and `to` are never both zero.
1043      *
1044      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1045      */
1046     function _beforeTokenTransfer(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) internal virtual {}
1051 }
1052 
1053 /**
1054  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1055  * @dev See https://eips.ethereum.org/EIPS/eip-721
1056  */
1057 interface IERC721Enumerable is IERC721 {
1058     /**
1059      * @dev Returns the total amount of tokens stored by the contract.
1060      */
1061     function totalSupply() external view returns (uint256);
1062 
1063     /**
1064      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1065      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1066      */
1067     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1068 
1069     /**
1070      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1071      * Use along with {totalSupply} to enumerate all tokens.
1072      */
1073     function tokenByIndex(uint256 index) external view returns (uint256);
1074 }
1075 
1076 /**
1077  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1078  * enumerability of all the token ids in the contract as well as all token ids owned by each
1079  * account.
1080  */
1081 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1082     // Mapping from owner to list of owned token IDs
1083     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1084 
1085     // Mapping from token ID to index of the owner tokens list
1086     mapping(uint256 => uint256) private _ownedTokensIndex;
1087 
1088     // Array with all token ids, used for enumeration
1089     uint256[] private _allTokens;
1090 
1091     // Mapping from token id to position in the allTokens array
1092     mapping(uint256 => uint256) private _allTokensIndex;
1093 
1094     /**
1095      * @dev See {IERC165-supportsInterface}.
1096      */
1097     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1098         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1099     }
1100 
1101     /**
1102      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1103      */
1104     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1105         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1106         return _ownedTokens[owner][index];
1107     }
1108 
1109     /**
1110      * @dev See {IERC721Enumerable-totalSupply}.
1111      */
1112     function totalSupply() public view virtual override returns (uint256) {
1113         return _allTokens.length;
1114     }
1115 
1116     /**
1117      * @dev See {IERC721Enumerable-tokenByIndex}.
1118      */
1119     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1120         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1121         return _allTokens[index];
1122     }
1123 
1124     /**
1125      * @dev Hook that is called before any token transfer. This includes minting
1126      * and burning.
1127      *
1128      * Calling conditions:
1129      *
1130      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1131      * transferred to `to`.
1132      * - When `from` is zero, `tokenId` will be minted for `to`.
1133      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1134      * - `from` cannot be the zero address.
1135      * - `to` cannot be the zero address.
1136      *
1137      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1138      */
1139     function _beforeTokenTransfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) internal virtual override {
1144         super._beforeTokenTransfer(from, to, tokenId);
1145 
1146         if (from == address(0)) {
1147             _addTokenToAllTokensEnumeration(tokenId);
1148         } else if (from != to) {
1149             _removeTokenFromOwnerEnumeration(from, tokenId);
1150         }
1151         if (to == address(0)) {
1152             _removeTokenFromAllTokensEnumeration(tokenId);
1153         } else if (to != from) {
1154             _addTokenToOwnerEnumeration(to, tokenId);
1155         }
1156     }
1157 
1158     /**
1159      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1160      * @param to address representing the new owner of the given token ID
1161      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1162      */
1163     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1164         uint256 length = ERC721.balanceOf(to);
1165         _ownedTokens[to][length] = tokenId;
1166         _ownedTokensIndex[tokenId] = length;
1167     }
1168 
1169     /**
1170      * @dev Private function to add a token to this extension's token tracking data structures.
1171      * @param tokenId uint256 ID of the token to be added to the tokens list
1172      */
1173     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1174         _allTokensIndex[tokenId] = _allTokens.length;
1175         _allTokens.push(tokenId);
1176     }
1177 
1178     /**
1179      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1180      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1181      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1182      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1183      * @param from address representing the previous owner of the given token ID
1184      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1185      */
1186     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1187         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1188         // then delete the last slot (swap and pop).
1189 
1190         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1191         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1192 
1193         // When the token to delete is the last token, the swap operation is unnecessary
1194         if (tokenIndex != lastTokenIndex) {
1195             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1196 
1197             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1198             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1199         }
1200 
1201         // This also deletes the contents at the last position of the array
1202         delete _ownedTokensIndex[tokenId];
1203         delete _ownedTokens[from][lastTokenIndex];
1204     }
1205 
1206     /**
1207      * @dev Private function to remove a token from this extension's token tracking data structures.
1208      * This has O(1) time complexity, but alters the order of the _allTokens array.
1209      * @param tokenId uint256 ID of the token to be removed from the tokens list
1210      */
1211     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1212         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1213         // then delete the last slot (swap and pop).
1214 
1215         uint256 lastTokenIndex = _allTokens.length - 1;
1216         uint256 tokenIndex = _allTokensIndex[tokenId];
1217 
1218         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1219         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1220         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1221         uint256 lastTokenId = _allTokens[lastTokenIndex];
1222 
1223         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1224         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1225 
1226         // This also deletes the contents at the last position of the array
1227         delete _allTokensIndex[tokenId];
1228         _allTokens.pop();
1229     }
1230 }
1231 
1232 contract _69loot is ERC721Enumerable, ReentrancyGuard, Ownable {
1233 
1234     uint256 public constant maxSupply = 6969;
1235 
1236     string[] private memecharacter = ["Troll Face", "Chocolate Rain Guy", "Doge", "Harambe", "The Chad", "the virgin", "Spooderman", "Rick Roll", "Nyan Cat", "Grumpy Cat", "Baby Shark", "Gangnam Style", "Forever Alone", "Numa Numa Dance", "Distracted boyfriend", "Drake Hotline Bling", "Trolololol", "Like a boss", "Drunk Baby", "Keyboard Cat", "Double Rainbow", "Good Guy Greg", "Change My Mind Guy", "David After Dentist", "Poker Face", "Cereal Guy", "It's a trap!", "Shirtless Putin", "Hamster Dance", "Old Gregg", "Me Gusta", "LOOOL", "Leprechaun in a tree", "Disaster Girl", "Overly Attached Girlfriend", "Sneezing Panda", "Star Wars Kid", "U Mad Bro?", "Spanish guy laughing", "Scumbag Steve", "Success kid", "Bad Luck Brian", "Aint nobody got time for that woman", "Charlie Bit My Finger", "Dramatic Chipmunk", "Screaming goat", "Kermit Sipping Tea"];
1237 
1238     string[] private celebrities = ["Satoshi Nakamoto", "Vitalik", "Charles Hoskinson", "Steve Aoki", "GaryVee", "Logan Paul", "David Schwimmer", "Mike Tyson", "Chuck Norris", "KSI", "Kanye West", "ZssBecker", "JRNYCrypto", "Michael Saylor", "Tai Lopez", "Bogdanoff Twins", "Winklevoss Brothers", "FaZe Banks", "EllioTrades", "Spider-Man", "Michael Saylor", "Beanie", "Dwayne 'The Rock' Johnson", "Arnold Schwarzenegger", "WSB Chairman", "Keanu Reeves", "Jason Derulo", "Donald Trump", "Michael Jackson", "Kim Kardashian", "Drake", "Beyonce", "Pitbull", "Selena Gomez", "Robert Downey Jr.", "Oprah", "Nick Cage", "Justin Bieber", "Tory Lanez", "Gary Busey", "Miley Cyrus", "Kevin Hart", "Lady Gaga", "Oprah Winfrey", "Mark Whalberg", "Sylvester Stallone", "Tom Hanks", "6ix9ine"];
1239 
1240     string[] private nfts = ["CryptoPunks", "Bored Ape Yacht Club", "The Doge Pound", "0n1 Force", "Loot (for Adventurers)", "Mutant Ape Yacht Club", "Art Blocks", "Bored Ape Kennel Club", "VeeFriends", "Koala Intelligence Agency", "SpacePunksClub", "Creature World", "World of Women", "dotdotdots", "Pudgy Penguins", "Cool Cats", "Incognito", "CyberKongz", "Hashmasks", "BEEPLE: EVERYDAYS", "Lazy Lions", "Gutter Cat Gang", "FLUF World", "Stoner Cats"];
1241 
1242     string[] private sexpositions = ["Doggy style", "Run a train", "Reverse cowgirl", "Dirty sanchez", "The lotus", "Donkey punch", "Foursome", "Pile Driver", "Threeway", "Cowgirl", "The seated wheelbarrow", "Rimjob", "Pretzel Dip", "Flatiron", "Couch grind", "The corkscrew", "Cowgirl's helper", "The sideways straddle", "Blowjob", "Missionary style"];
1243 
1244     string[] private socialmedia = ["MySpace", "Kik", "8chan", "Tumblr", "Grindr", "LinkedIn", "Chaturbate", "Friendster", "Steam", "WeChat", "Bumble", "Houseparty", "WhatsApp", "Skype", "OnlyFans", "Omegle", "4chan", "Tinder", "iMessage", "FaceTime", "Twitch", "YouTube", "Facebook", "Snapchat", "Instagram", "Reddit", "Telegram", "Discord", "Twitter", "TikTok"];
1245 
1246     string[] private crypto = ["Cumrocket", "Shitcoin", "Dogecoin", "Ethereum", "Cardano", "XRP", "Polkadot", "Chainlink", "Coinbase", "Solana", "Binance", "Bitcoin", "Algorand", "Theta", "Uniswap", "OpenSea", "Litecoin", "rarity.tools", "MetaMask", "USDC", "Tether", "Polygon", "Etherscan"];
1247 
1248     string[] private cryptoslang = ["i CaN jUsT ScReEn ShOt", "Diamond Hands", "FUD", "wen lambo", "wen moon", "im literally shaking rn", "PAMP it", "rug", "Baguette hands", "fuck gas", "NGMI", "wen mint", "WAGMI", "!floor", "to the moon", "PnD", "shitcoins", "gmi", "HODL", "Paper hands", "illiquid"];
1249 
1250     string[] private fuckedupclothing = ["Assless chaps", "Gimp mask", "Fursuit", "Strap-on", "Flavored condom", "Choker", "Corset", "Spandex suit", "Latex suit", "Big Bird costume", "Sketchers", "Boots with the fur", "Short shorts", "Soiled underwear", "Apple bottom jeans", "Onsie", "Speedo", "Jean shorts", "Whitey tightys", "Mom jeans", "Turtle neck"];
1251 
1252     string[] private celebritiesSuffixes = ["from the stripclub", "without pants on", "with your mom", "behind the 7-11", "with your sister", "eating your ass", "with your grandpa", "in the closet", "from the future", "stuck in a well", "in your face", "from hell", "from heaven", "in the desert", "scratching their balls", "in a dumpster", "on a horse", "in bed with you", "giving you head", "on the toilet", "under a bridge", "from the garbage", "in your pocket"];
1253     
1254     string[] private fuckedupclothingSuffixes = ["of the sex pest", "of your mother", "of the gamer", "of the ass eater", "of the fast food cashier", "of the NFT trader", "of the Tinder date", "of the cat lady", "of the crypto trader", "of the nut junkie", "of the Discord user", "of the Twitter user", "of the Reddit user", "of the soldier", "of the politician", "of the average taxpayer", "of the Harvard student", "of the priest", "of the soccer player", "of the janitor", "of the inmate"];
1255 
1256     function random(string memory keyPrefix, uint256 tokenId) internal pure returns (uint256) {
1257         return uint256(keccak256(abi.encodePacked(keyPrefix, Strings.toString(tokenId))));
1258     }
1259 
1260     function getMemecharacter(uint256 tokenId) public view returns (string memory) {
1261         return pluck(tokenId, "MEMECHARACTER", memecharacter, 1);
1262     }
1263 
1264     function getCelebrities(uint256 tokenId) public view returns (string memory) {
1265         return pluck(tokenId, "CELEBRITIES", celebrities, 2);
1266     }
1267 
1268     function getNfts(uint256 tokenId) public view returns (string memory) {
1269         return pluck(tokenId, "NFTS", nfts, 3);
1270     }
1271 
1272     function getSexpositions(uint256 tokenId) public view returns (string memory) {
1273         return pluck(tokenId, "SEXPOSITIONS", sexpositions, 4);
1274     }
1275 
1276     function getSocialmedia(uint256 tokenId) public view returns (string memory) {
1277         return pluck(tokenId, "SOCIALMEDIA", socialmedia, 5);
1278     }
1279 
1280     function getCrypto(uint256 tokenId) public view returns (string memory) {
1281         return pluck(tokenId, "CRYPTO", crypto, 6);
1282     }
1283 
1284     function getCryptoslang(uint256 tokenId) public view returns (string memory) {
1285         return pluck(tokenId, "CRYPTOSLANG", cryptoslang, 7);
1286     }
1287 
1288     function getFuckedupclothing(uint256 tokenId) public view returns (string memory) {
1289         return pluck(tokenId, "FUCKEDUPCLOTHING", fuckedupclothing, 8);
1290     }
1291 
1292     function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray, uint8 keyNum) internal view returns (string memory) {
1293         uint256 rand = random(keyPrefix, tokenId);
1294         string memory output = sourceArray[rand % sourceArray.length];
1295         uint256 greatness = rand % 100;
1296         
1297         if (keyNum == 2 && greatness > 82 && greatness < 98) {
1298             output = string(abi.encodePacked(output, " ", celebritiesSuffixes[rand % celebritiesSuffixes.length]));
1299         }
1300 
1301         if (keyNum == 8 && greatness > 47 && greatness < 98) {
1302             output = string(abi.encodePacked(output, " ", fuckedupclothingSuffixes[rand % fuckedupclothingSuffixes.length]));
1303         }
1304 
1305         if (keyNum == 2 && greatness == 98) {
1306             output = string(abi.encodePacked(output," ", celebritiesSuffixes[rand % celebritiesSuffixes.length], " +69"));
1307         }
1308 
1309         if (keyNum == 8 && greatness == 99) {
1310             output = string(abi.encodePacked(output," ", fuckedupclothingSuffixes[rand % fuckedupclothingSuffixes.length], " +69"));
1311         }
1312         
1313         return output;
1314     }
1315     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1316         string[17] memory parts;
1317         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: "Times New Roman", Times, serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#B00B69" /><text x="10" y="20" class="base">';
1318 
1319         parts[1] = getMemecharacter(tokenId);
1320 
1321         parts[2] = '</text><text x="10" y="40" class="base">';
1322 
1323         parts[3] = getCelebrities(tokenId);
1324 
1325         parts[4] = '</text><text x="10" y="60" class="base">';
1326 
1327         parts[5] = getNfts(tokenId);
1328 
1329         parts[6] = '</text><text x="10" y="80" class="base">';
1330 
1331         parts[7] = getSexpositions(tokenId);
1332 
1333         parts[8] = '</text><text x="10" y="100" class="base">';
1334 
1335         parts[9] = getSocialmedia(tokenId);
1336 
1337         parts[10] = '</text><text x="10" y="120" class="base">';
1338 
1339         parts[11] = getCrypto(tokenId);
1340 
1341         parts[12] = '</text><text x="10" y="140" class="base">';
1342 
1343         parts[13] = getCryptoslang(tokenId);
1344 
1345         parts[14] = '</text><text x="10" y="160" class="base">';
1346 
1347         parts[15] = getFuckedupclothing(tokenId);
1348 
1349         parts[16] = '</text></svg>';
1350 
1351         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1352         output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
1353 
1354         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "69loot #', toString(tokenId), '", "description": "69Loot is an NFT themed Cards Against Humanity spin off. All material is randomized, generated and stored on the Ethereum network. Feel free to use 69Loot in any way that you want. Minting is FREE.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1355         output = string(abi.encodePacked('data:application/json;base64,', json));
1356 
1357         return output;
1358     }
1359 
1360     function claim(uint256 tokenId) public nonReentrant {
1361         require((tokenId > 419 && tokenId < 7389), "Token ID invalid");
1362         require(totalSupply() <= maxSupply, "69loot max supply reached!");
1363         _safeMint(_msgSender(), tokenId);
1364     }
1365 
1366     function toString(uint256 value) internal pure returns (string memory) {
1367     // Inspired by OraclizeAPI's implementation - MIT license
1368     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1369 
1370         if (value == 0) {
1371             return "0";
1372         }
1373         uint256 temp = value;
1374         uint256 digits;
1375         while (temp != 0) {
1376             digits++;
1377             temp /= 10;
1378         }
1379         bytes memory buffer = new bytes(digits);
1380         while (value != 0) {
1381             digits -= 1;
1382             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1383             value /= 10;
1384         }
1385         return string(buffer);
1386     }
1387 
1388     constructor() ERC721("69loot", "69LOOT") Ownable() {}
1389 }
1390 
1391 /// [MIT License]
1392 /// @title Base64
1393 /// @notice Provides a function for encoding some bytes in base64
1394 /// @author Brecht Devos <brecht@loopring.org>
1395 library Base64 {
1396     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1397     /// @notice Encodes some bytes to the base64 representation
1398     function encode(bytes memory data) internal pure returns (string memory) {
1399         uint256 len = data.length;
1400         if (len == 0) return "";
1401         // multiply by 4/3 rounded up
1402         uint256 encodedLen = 4 * ((len + 2) / 3);
1403         // Add some extra buffer at the end
1404         bytes memory result = new bytes(encodedLen + 32);
1405         bytes memory table = TABLE;
1406         assembly {
1407             let tablePtr := add(table, 1)
1408             let resultPtr := add(result, 32)
1409             for {
1410                 let i := 0
1411             } lt(i, len) {
1412             } {
1413                 i := add(i, 3)
1414                 let input := and(mload(add(data, i)), 0xffffff)
1415 
1416                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1417                 out := shl(8, out)
1418                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1419                 out := shl(8, out)
1420                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1421                 out := shl(8, out)
1422                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1423                 out := shl(224, out)
1424                 mstore(resultPtr, out)
1425                 resultPtr := add(resultPtr, 4)
1426             }
1427 
1428             switch mod(len, 3)
1429             case 1 {
1430                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1431             }
1432             case 2 {
1433                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1434             }
1435 
1436             mstore(result, encodedLen)
1437         }
1438 
1439         return string(result);
1440     }
1441 }