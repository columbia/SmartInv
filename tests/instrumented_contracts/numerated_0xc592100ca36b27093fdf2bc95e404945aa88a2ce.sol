1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
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
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45 
46     /**
47      * @dev Returns the number of tokens in ``owner``'s account.
48      */
49     function balanceOf(address owner) external view returns (uint256 balance);
50 
51     /**
52      * @dev Returns the owner of the `tokenId` token.
53      *
54      * Requirements:
55      *
56      * - `tokenId` must exist.
57      */
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59 
60     /**
61      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
62      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
63      *
64      * Requirements:
65      *
66      * - `from` cannot be the zero address.
67      * - `to` cannot be the zero address.
68      * - `tokenId` token must exist and be owned by `from`.
69      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
70      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
71      *
72      * Emits a {Transfer} event.
73      */
74     function safeTransferFrom(
75         address from,
76         address to,
77         uint256 tokenId
78     ) external;
79 
80     /**
81      * @dev Transfers `tokenId` token from `from` to `to`.
82      *
83      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must be owned by `from`.
90      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(
95         address from,
96         address to,
97         uint256 tokenId
98     ) external;
99 
100     /**
101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
102      * The approval is cleared when the token is transferred.
103      *
104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
105      *
106      * Requirements:
107      *
108      * - The caller must own the token or be an approved operator.
109      * - `tokenId` must exist.
110      *
111      * Emits an {Approval} event.
112      */
113     function approve(address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Returns the account approved for `tokenId` token.
117      *
118      * Requirements:
119      *
120      * - `tokenId` must exist.
121      */
122     function getApproved(uint256 tokenId) external view returns (address operator);
123 
124     /**
125      * @dev Approve or remove `operator` as an operator for the caller.
126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
127      *
128      * Requirements:
129      *
130      * - The `operator` cannot be the caller.
131      *
132      * Emits an {ApprovalForAll} event.
133      */
134     function setApprovalForAll(address operator, bool _approved) external;
135 
136     /**
137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
138      *
139      * See {setApprovalForAll}
140      */
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143     /**
144      * @dev Safely transfers `tokenId` token from `from` to `to`.
145      *
146      * Requirements:
147      *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150      * - `tokenId` token must exist and be owned by `from`.
151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153      *
154      * Emits a {Transfer} event.
155      */
156     function safeTransferFrom(
157         address from,
158         address to,
159         uint256 tokenId,
160         bytes calldata data
161     ) external;
162 }
163 
164 
165 /**
166  * @dev String operations.
167  */
168 library Strings {
169     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
170 
171     /**
172      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
173      */
174     function toString(uint256 value) internal pure returns (string memory) {
175         // Inspired by OraclizeAPI's implementation - MIT licence
176         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
177 
178         if (value == 0) {
179             return "0";
180         }
181         uint256 temp = value;
182         uint256 digits;
183         while (temp != 0) {
184             digits++;
185             temp /= 10;
186         }
187         bytes memory buffer = new bytes(digits);
188         while (value != 0) {
189             digits -= 1;
190             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
191             value /= 10;
192         }
193         return string(buffer);
194     }
195 
196     /**
197      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
198      */
199     function toHexString(uint256 value) internal pure returns (string memory) {
200         if (value == 0) {
201             return "0x00";
202         }
203         uint256 temp = value;
204         uint256 length = 0;
205         while (temp != 0) {
206             length++;
207             temp >>= 8;
208         }
209         return toHexString(value, length);
210     }
211 
212     /**
213      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
214      */
215     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
216         bytes memory buffer = new bytes(2 * length + 2);
217         buffer[0] = "0";
218         buffer[1] = "x";
219         for (uint256 i = 2 * length + 1; i > 1; --i) {
220             buffer[i] = _HEX_SYMBOLS[value & 0xf];
221             value >>= 4;
222         }
223         require(value == 0, "Strings: hex length insufficient");
224         return string(buffer);
225     }
226 }
227 
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
249 
250 /**
251  * @dev Contract module which provides a basic access control mechanism, where
252  * there is an account (an owner) that can be granted exclusive access to
253  * specific functions.
254  *
255  * By default, the owner account will be the one that deploys the contract. This
256  * can later be changed with {transferOwnership}.
257  *
258  * This module is used through inheritance. It will make available the modifier
259  * `onlyOwner`, which can be applied to your functions to restrict their use to
260  * the owner.
261  */
262 abstract contract Ownable is Context {
263     address private _owner;
264 
265     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
266 
267     /**
268      * @dev Initializes the contract setting the deployer as the initial owner.
269      */
270     constructor() {
271         _setOwner(_msgSender());
272     }
273 
274     /**
275      * @dev Returns the address of the current owner.
276      */
277     function owner() public view virtual returns (address) {
278         return _owner;
279     }
280 
281     /**
282      * @dev Throws if called by any account other than the owner.
283      */
284     modifier onlyOwner() {
285         require(owner() == _msgSender(), "Ownable: caller is not the owner");
286         _;
287     }
288 
289     /**
290      * @dev Leaves the contract without owner. It will not be possible to call
291      * `onlyOwner` functions anymore. Can only be called by the current owner.
292      *
293      * NOTE: Renouncing ownership will leave the contract without an owner,
294      * thereby removing any functionality that is only available to the owner.
295      */
296     function renounceOwnership() public virtual onlyOwner {
297         _setOwner(address(0));
298     }
299 
300     /**
301      * @dev Transfers ownership of the contract to a new account (`newOwner`).
302      * Can only be called by the current owner.
303      */
304     function transferOwnership(address newOwner) public virtual onlyOwner {
305         require(newOwner != address(0), "Ownable: new owner is the zero address");
306         _setOwner(newOwner);
307     }
308 
309     function _setOwner(address newOwner) private {
310         address oldOwner = _owner;
311         _owner = newOwner;
312         emit OwnershipTransferred(oldOwner, newOwner);
313     }
314 }
315 
316 
317 /**
318  * @dev Contract module that helps prevent reentrant calls to a function.
319  *
320  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
321  * available, which can be applied to functions to make sure there are no nested
322  * (reentrant) calls to them.
323  *
324  * Note that because there is a single `nonReentrant` guard, functions marked as
325  * `nonReentrant` may not call one another. This can be worked around by making
326  * those functions `private`, and then adding `external` `nonReentrant` entry
327  * points to them.
328  *
329  * TIP: If you would like to learn more about reentrancy and alternative ways
330  * to protect against it, check out our blog post
331  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
332  */
333 abstract contract ReentrancyGuard {
334     // Booleans are more expensive than uint256 or any type that takes up a full
335     // word because each write operation emits an extra SLOAD to first read the
336     // slot's contents, replace the bits taken up by the boolean, and then write
337     // back. This is the compiler's defense against contract upgrades and
338     // pointer aliasing, and it cannot be disabled.
339 
340     // The values being non-zero value makes deployment a bit more expensive,
341     // but in exchange the refund on every call to nonReentrant will be lower in
342     // amount. Since refunds are capped to a percentage of the total
343     // transaction's gas, it is best to keep them low in cases like this one, to
344     // increase the likelihood of the full refund coming into effect.
345     uint256 private constant _NOT_ENTERED = 1;
346     uint256 private constant _ENTERED = 2;
347 
348     uint256 private _status;
349 
350     constructor() {
351         _status = _NOT_ENTERED;
352     }
353 
354     /**
355      * @dev Prevents a contract from calling itself, directly or indirectly.
356      * Calling a `nonReentrant` function from another `nonReentrant`
357      * function is not supported. It is possible to prevent this from happening
358      * by making the `nonReentrant` function external, and make it call a
359      * `private` function that does the actual work.
360      */
361     modifier nonReentrant() {
362         // On the first call to nonReentrant, _notEntered will be true
363         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
364 
365         // Any calls to nonReentrant after this point will fail
366         _status = _ENTERED;
367 
368         _;
369 
370         // By storing the original value once again, a refund is triggered (see
371         // https://eips.ethereum.org/EIPS/eip-2200)
372         _status = _NOT_ENTERED;
373     }
374 }
375 
376 
377 /**
378  * @title ERC721 token receiver interface
379  * @dev Interface for any contract that wants to support safeTransfers
380  * from ERC721 asset contracts.
381  */
382 interface IERC721Receiver {
383     /**
384      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
385      * by `operator` from `from`, this function is called.
386      *
387      * It must return its Solidity selector to confirm the token transfer.
388      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
389      *
390      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
391      */
392     function onERC721Received(
393         address operator,
394         address from,
395         uint256 tokenId,
396         bytes calldata data
397     ) external returns (bytes4);
398 }
399 
400 
401 /**
402  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
403  * @dev See https://eips.ethereum.org/EIPS/eip-721
404  */
405 interface IERC721Metadata is IERC721 {
406     /**
407      * @dev Returns the token collection name.
408      */
409     function name() external view returns (string memory);
410 
411     /**
412      * @dev Returns the token collection symbol.
413      */
414     function symbol() external view returns (string memory);
415 
416     /**
417      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
418      */
419     function tokenURI(uint256 tokenId) external view returns (string memory);
420 }
421 
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
630 
631 /**
632  * @dev Implementation of the {IERC165} interface.
633  *
634  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
635  * for the additional interface id that will be supported. For example:
636  *
637  * ```solidity
638  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
639  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
640  * }
641  * ```
642  *
643  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
644  */
645 abstract contract ERC165 is IERC165 {
646     /**
647      * @dev See {IERC165-supportsInterface}.
648      */
649     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
650         return interfaceId == type(IERC165).interfaceId;
651     }
652 }
653 
654 
655 /**
656  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
657  * the Metadata extension, but not including the Enumerable extension, which is available separately as
658  * {ERC721Enumerable}.
659  */
660 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
661     using Address for address;
662     using Strings for uint256;
663 
664     // Token name
665     string private _name;
666 
667     // Token symbol
668     string private _symbol;
669 
670     // Mapping from token ID to owner address
671     mapping(uint256 => address) private _owners;
672 
673     // Mapping owner address to token count
674     mapping(address => uint256) private _balances;
675 
676     // Mapping from token ID to approved address
677     mapping(uint256 => address) private _tokenApprovals;
678 
679     // Mapping from owner to operator approvals
680     mapping(address => mapping(address => bool)) private _operatorApprovals;
681 
682     /**
683      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
684      */
685     constructor(string memory name_, string memory symbol_) {
686         _name = name_;
687         _symbol = symbol_;
688     }
689 
690     /**
691      * @dev See {IERC165-supportsInterface}.
692      */
693     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
694         return
695             interfaceId == type(IERC721).interfaceId ||
696             interfaceId == type(IERC721Metadata).interfaceId ||
697             super.supportsInterface(interfaceId);
698     }
699 
700     /**
701      * @dev See {IERC721-balanceOf}.
702      */
703     function balanceOf(address owner) public view virtual override returns (uint256) {
704         require(owner != address(0), "ERC721: balance query for the zero address");
705         return _balances[owner];
706     }
707 
708     /**
709      * @dev See {IERC721-ownerOf}.
710      */
711     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
712         address owner = _owners[tokenId];
713         require(owner != address(0), "ERC721: owner query for nonexistent token");
714         return owner;
715     }
716 
717     /**
718      * @dev See {IERC721Metadata-name}.
719      */
720     function name() public view virtual override returns (string memory) {
721         return _name;
722     }
723 
724     /**
725      * @dev See {IERC721Metadata-symbol}.
726      */
727     function symbol() public view virtual override returns (string memory) {
728         return _symbol;
729     }
730 
731     /**
732      * @dev See {IERC721Metadata-tokenURI}.
733      */
734     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
735         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
736 
737         string memory baseURI = _baseURI();
738         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
739     }
740 
741     /**
742      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
743      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
744      * by default, can be overriden in child contracts.
745      */
746     function _baseURI() internal view virtual returns (string memory) {
747         return "";
748     }
749 
750     /**
751      * @dev See {IERC721-approve}.
752      */
753     function approve(address to, uint256 tokenId) public virtual override {
754         address owner = ERC721.ownerOf(tokenId);
755         require(to != owner, "ERC721: approval to current owner");
756 
757         require(
758             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
759             "ERC721: approve caller is not owner nor approved for all"
760         );
761 
762         _approve(to, tokenId);
763     }
764 
765     /**
766      * @dev See {IERC721-getApproved}.
767      */
768     function getApproved(uint256 tokenId) public view virtual override returns (address) {
769         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
770 
771         return _tokenApprovals[tokenId];
772     }
773 
774     /**
775      * @dev See {IERC721-setApprovalForAll}.
776      */
777     function setApprovalForAll(address operator, bool approved) public virtual override {
778         require(operator != _msgSender(), "ERC721: approve to caller");
779 
780         _operatorApprovals[_msgSender()][operator] = approved;
781         emit ApprovalForAll(_msgSender(), operator, approved);
782     }
783 
784     /**
785      * @dev See {IERC721-isApprovedForAll}.
786      */
787     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
788         return _operatorApprovals[owner][operator];
789     }
790 
791     /**
792      * @dev See {IERC721-transferFrom}.
793      */
794     function transferFrom(
795         address from,
796         address to,
797         uint256 tokenId
798     ) public virtual override {
799         //solhint-disable-next-line max-line-length
800         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
801 
802         _transfer(from, to, tokenId);
803     }
804 
805     /**
806      * @dev See {IERC721-safeTransferFrom}.
807      */
808     function safeTransferFrom(
809         address from,
810         address to,
811         uint256 tokenId
812     ) public virtual override {
813         safeTransferFrom(from, to, tokenId, "");
814     }
815 
816     /**
817      * @dev See {IERC721-safeTransferFrom}.
818      */
819     function safeTransferFrom(
820         address from,
821         address to,
822         uint256 tokenId,
823         bytes memory _data
824     ) public virtual override {
825         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
826         _safeTransfer(from, to, tokenId, _data);
827     }
828 
829     /**
830      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
831      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
832      *
833      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
834      *
835      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
836      * implement alternative mechanisms to perform token transfer, such as signature-based.
837      *
838      * Requirements:
839      *
840      * - `from` cannot be the zero address.
841      * - `to` cannot be the zero address.
842      * - `tokenId` token must exist and be owned by `from`.
843      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
844      *
845      * Emits a {Transfer} event.
846      */
847     function _safeTransfer(
848         address from,
849         address to,
850         uint256 tokenId,
851         bytes memory _data
852     ) internal virtual {
853         _transfer(from, to, tokenId);
854         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
855     }
856 
857     /**
858      * @dev Returns whether `tokenId` exists.
859      *
860      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
861      *
862      * Tokens start existing when they are minted (`_mint`),
863      * and stop existing when they are burned (`_burn`).
864      */
865     function _exists(uint256 tokenId) internal view virtual returns (bool) {
866         return _owners[tokenId] != address(0);
867     }
868 
869     /**
870      * @dev Returns whether `spender` is allowed to manage `tokenId`.
871      *
872      * Requirements:
873      *
874      * - `tokenId` must exist.
875      */
876     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
877         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
878         address owner = ERC721.ownerOf(tokenId);
879         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
880     }
881 
882     /**
883      * @dev Safely mints `tokenId` and transfers it to `to`.
884      *
885      * Requirements:
886      *
887      * - `tokenId` must not exist.
888      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _safeMint(address to, uint256 tokenId) internal virtual {
893         _safeMint(to, tokenId, "");
894     }
895 
896     /**
897      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
898      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
899      */
900     function _safeMint(
901         address to,
902         uint256 tokenId,
903         bytes memory _data
904     ) internal virtual {
905         _mint(to, tokenId);
906         require(
907             _checkOnERC721Received(address(0), to, tokenId, _data),
908             "ERC721: transfer to non ERC721Receiver implementer"
909         );
910     }
911 
912     /**
913      * @dev Mints `tokenId` and transfers it to `to`.
914      *
915      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
916      *
917      * Requirements:
918      *
919      * - `tokenId` must not exist.
920      * - `to` cannot be the zero address.
921      *
922      * Emits a {Transfer} event.
923      */
924     function _mint(address to, uint256 tokenId) internal virtual {
925         require(to != address(0), "ERC721: mint to the zero address");
926         require(!_exists(tokenId), "ERC721: token already minted");
927 
928         _beforeTokenTransfer(address(0), to, tokenId);
929 
930         _balances[to] += 1;
931         _owners[tokenId] = to;
932 
933         emit Transfer(address(0), to, tokenId);
934     }
935 
936     /**
937      * @dev Destroys `tokenId`.
938      * The approval is cleared when the token is burned.
939      *
940      * Requirements:
941      *
942      * - `tokenId` must exist.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _burn(uint256 tokenId) internal virtual {
947         address owner = ERC721.ownerOf(tokenId);
948 
949         _beforeTokenTransfer(owner, address(0), tokenId);
950 
951         // Clear approvals
952         _approve(address(0), tokenId);
953 
954         _balances[owner] -= 1;
955         delete _owners[tokenId];
956 
957         emit Transfer(owner, address(0), tokenId);
958     }
959 
960     /**
961      * @dev Transfers `tokenId` from `from` to `to`.
962      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
963      *
964      * Requirements:
965      *
966      * - `to` cannot be the zero address.
967      * - `tokenId` token must be owned by `from`.
968      *
969      * Emits a {Transfer} event.
970      */
971     function _transfer(
972         address from,
973         address to,
974         uint256 tokenId
975     ) internal virtual {
976         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
977         require(to != address(0), "ERC721: transfer to the zero address");
978 
979         _beforeTokenTransfer(from, to, tokenId);
980 
981         // Clear approvals from the previous owner
982         _approve(address(0), tokenId);
983 
984         _balances[from] -= 1;
985         _balances[to] += 1;
986         _owners[tokenId] = to;
987 
988         emit Transfer(from, to, tokenId);
989     }
990 
991     /**
992      * @dev Approve `to` to operate on `tokenId`
993      *
994      * Emits a {Approval} event.
995      */
996     function _approve(address to, uint256 tokenId) internal virtual {
997         _tokenApprovals[tokenId] = to;
998         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
999     }
1000 
1001     /**
1002      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1003      * The call is not executed if the target address is not a contract.
1004      *
1005      * @param from address representing the previous owner of the given token ID
1006      * @param to target address that will receive the tokens
1007      * @param tokenId uint256 ID of the token to be transferred
1008      * @param _data bytes optional data to send along with the call
1009      * @return bool whether the call correctly returned the expected magic value
1010      */
1011     function _checkOnERC721Received(
1012         address from,
1013         address to,
1014         uint256 tokenId,
1015         bytes memory _data
1016     ) private returns (bool) {
1017         if (to.isContract()) {
1018             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1019                 return retval == IERC721Receiver(to).onERC721Received.selector;
1020             } catch (bytes memory reason) {
1021                 if (reason.length == 0) {
1022                     revert("ERC721: transfer to non ERC721Receiver implementer");
1023                 } else {
1024                     assembly {
1025                         revert(add(32, reason), mload(reason))
1026                     }
1027                 }
1028             }
1029         } else {
1030             return true;
1031         }
1032     }
1033 
1034     /**
1035      * @dev Hook that is called before any token transfer. This includes minting
1036      * and burning.
1037      *
1038      * Calling conditions:
1039      *
1040      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1041      * transferred to `to`.
1042      * - When `from` is zero, `tokenId` will be minted for `to`.
1043      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1044      * - `from` and `to` are never both zero.
1045      *
1046      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1047      */
1048     function _beforeTokenTransfer(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) internal virtual {}
1053 }
1054 
1055 
1056 contract Initials is ERC721, ReentrancyGuard, Ownable {
1057     
1058     uint256 private totaltokenSupply = 0;
1059     uint256 public MAX_SUPPLY = 10000;
1060     
1061     string[] private firstLetter = [
1062         "W","B","C","D","E","S","G","H","I",
1063         "T","K","L","M","N","O","P","Q","R",
1064         "F","J","U","V","A","X","Y","Z" 
1065     ];
1066     
1067     string[] private midLetter = [
1068         "N","Y","X","W","V","U","H","S","R",
1069         "F","P","O","Z","","M","L","K","J","I",
1070         "T","G","Q","E","D","C","B","A"  
1071     ];
1072     
1073     string[] private lastLetter = [
1074         "O","K","L","S","N","J","P","Q","R",
1075         "M","T","U","V","W","X","Y","Z",
1076         "G","B","C","D","E","F","A","H","I"
1077 
1078     ];
1079     
1080     function random(string memory input) internal pure returns (uint256) {
1081         return uint256(keccak256(abi.encodePacked(input)));
1082     }
1083     
1084     function getfirstLetter (uint256 tokenId) internal view returns (string memory) {
1085         return getChar(tokenId, "N",firstLetter);
1086     }
1087     
1088     function getmidLetter(uint256 tokenId) internal view returns (string memory) {
1089         return getChar(tokenId, "F" , midLetter);
1090     }
1091     
1092     function getlastLetter(uint256 tokenId) internal view returns (string memory) {
1093         return getChar(tokenId, "T", lastLetter);
1094     }
1095     
1096     function getChar(uint256 tokenId, string memory keyPrefix,  string[] memory sourceArray) internal pure returns (string memory) {
1097         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1098         string memory output = sourceArray[rand % sourceArray.length];
1099        
1100         return output;
1101     }
1102 
1103     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1104         
1105         string[5] memory parts;
1106         
1107         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 100px; }</style><rect width="100%" height="100%" fill="black" /><text text-anchor="middle" x="175" y="200" class="base">';
1108 
1109         parts[1] = getfirstLetter(tokenId);
1110 
1111         parts[2] = getmidLetter(tokenId);
1112 
1113         parts[3] = getlastLetter(tokenId);
1114 
1115         parts[4] = '</text></svg>';
1116 
1117         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4]));
1118         
1119         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Initials #', toString(tokenId),'", "description": "Initials is 3 Randomized Characters generated and stored on-chain.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1120        
1121         output = string(abi.encodePacked('data:application/json;base64,', json));
1122 
1123         return output;
1124     }
1125 
1126     function claim(uint256 tokenId) public nonReentrant {
1127         require(tokenId > 0 && tokenId <= MAX_SUPPLY, "Token ID invalid");
1128         _safeMint(_msgSender(), tokenId);
1129         totaltokenSupply += 1;
1130     }
1131     
1132     function toString(uint256 value) internal pure returns (string memory) {
1133 
1134         if (value == 0) {
1135             return "0";
1136         }
1137         uint256 temp = value;
1138         uint256 digits;
1139         while (temp != 0) {
1140             digits++;
1141             temp /= 10;
1142         }
1143         bytes memory buffer = new bytes(digits);
1144         while (value != 0) {
1145             digits -= 1;
1146             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1147             value /= 10;
1148         }
1149         return string(buffer);
1150     }
1151 
1152     constructor() ERC721("Initials", "Initials") {}
1153     
1154     function totalSupply() public view returns (uint256) {
1155         return totaltokenSupply; 
1156     }
1157     
1158     function setSupply(uint256 newSupply) public onlyOwner() {  
1159         MAX_SUPPLY = newSupply;
1160     }
1161 }
1162 
1163 
1164 library Base64 {
1165     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1166 
1167     /// @notice Encodes some bytes to the base64 representation
1168     function encode(bytes memory data) internal pure returns (string memory) {
1169         uint256 len = data.length;
1170         if (len == 0) return "";
1171 
1172         // multiply by 4/3 rounded up
1173         uint256 encodedLen = 4 * ((len + 2) / 3);
1174 
1175         // Add some extra buffer at the end
1176         bytes memory result = new bytes(encodedLen + 32);
1177 
1178         bytes memory table = TABLE;
1179 
1180         assembly {
1181             let tablePtr := add(table, 1)
1182             let resultPtr := add(result, 32)
1183 
1184             for {
1185                 let i := 0
1186             } lt(i, len) {
1187 
1188             } {
1189                 i := add(i, 3)
1190                 let input := and(mload(add(data, i)), 0xffffff)
1191 
1192                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1193                 out := shl(8, out)
1194                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1195                 out := shl(8, out)
1196                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1197                 out := shl(8, out)
1198                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1199                 out := shl(224, out)
1200 
1201                 mstore(resultPtr, out)
1202 
1203                 resultPtr := add(resultPtr, 4)
1204             }
1205 
1206             switch mod(len, 3)
1207             case 1 {
1208                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1209             }
1210             case 2 {
1211                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1212             }
1213 
1214             mstore(result, encodedLen)
1215         }
1216 
1217         return string(result);
1218     }
1219 }