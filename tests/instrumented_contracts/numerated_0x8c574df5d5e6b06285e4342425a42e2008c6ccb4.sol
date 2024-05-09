1 // File: contracts/bloot-building.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2021-09-05
5  */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity ^0.8.7;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19  
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
168 
169 /**
170  * @dev String operations.
171  */
172 library Strings {
173     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
174 
175     /**
176      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
177      */
178     function toString(uint256 value) internal pure returns (string memory) {
179         // Inspired by OraclizeAPI's implementation - MIT licence
180         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
181 
182         if (value == 0) {
183             return "0";
184         }
185         uint256 temp = value;
186         uint256 digits;
187         while (temp != 0) {
188             digits++;
189             temp /= 10;
190         }
191         bytes memory buffer = new bytes(digits);
192         while (value != 0) {
193             digits -= 1;
194             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
195             value /= 10;
196         }
197         return string(buffer);
198     }
199 
200     /**
201      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
202      */
203     function toHexString(uint256 value) internal pure returns (string memory) {
204         if (value == 0) {
205             return "0x00";
206         }
207         uint256 temp = value;
208         uint256 length = 0;
209         while (temp != 0) {
210             length++;
211             temp >>= 8;
212         }
213         return toHexString(value, length);
214     }
215 
216     /**
217      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
218      */
219     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
220         bytes memory buffer = new bytes(2 * length + 2);
221         buffer[0] = "0";
222         buffer[1] = "x";
223         for (uint256 i = 2 * length + 1; i > 1; --i) {
224             buffer[i] = _HEX_SYMBOLS[value & 0xf];
225             value >>= 4;
226         }
227         require(value == 0, "Strings: hex length insufficient");
228         return string(buffer);
229     }
230 }
231 
232 /*
233  * @dev Provides information about the current execution context, including the
234  * sender of the transaction and its data. While these are generally available
235  * via msg.sender and msg.data, they should not be accessed in such a direct
236  * manner, since when dealing with meta-transactions the account sending and
237  * paying for execution may not be the actual sender (as far as an application
238  * is concerned).
239  *
240  * This contract is only required for intermediate, library-like contracts.
241  */
242 abstract contract Context {
243     function _msgSender() internal view virtual returns (address) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view virtual returns (bytes calldata) {
248         return msg.data;
249     }
250 }
251 
252 /**
253  * @dev Contract module which provides a basic access control mechanism, where
254  * there is an account (an owner) that can be granted exclusive access to
255  * specific functions.
256  *
257  * By default, the owner account will be the one that deploys the contract. This
258  * can later be changed with {transferOwnership}.
259  *
260  * This module is used through inheritance. It will make available the modifier
261  * `onlyOwner`, which can be applied to your functions to restrict their use to
262  * the owner.
263  */
264 abstract contract Ownable is Context {
265     address private _owner;
266 
267     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
268 
269     /**
270      * @dev Initializes the contract setting the deployer as the initial owner.
271      */
272     constructor() {
273         _setOwner(_msgSender());
274     }
275 
276     /**
277      * @dev Returns the address of the current owner.
278      */
279     function owner() public view virtual returns (address) {
280         return _owner;
281     }
282 
283     /**
284      * @dev Throws if called by any account other than the owner.
285      */
286     modifier onlyOwner() {
287         require(owner() == _msgSender(), "Ownable: caller is not the owner");
288         _;
289     }
290 
291     /**
292      * @dev Leaves the contract without owner. It will not be possible to call
293      * `onlyOwner` functions anymore. Can only be called by the current owner.
294      *
295      * NOTE: Renouncing ownership will leave the contract without an owner,
296      * thereby removing any functionality that is only available to the owner.
297      */
298     function renounceOwnership() public virtual onlyOwner {
299         _setOwner(address(0));
300     }
301 
302     /**
303      * @dev Transfers ownership of the contract to a new account (`newOwner`).
304      * Can only be called by the current owner.
305      */
306     function transferOwnership(address newOwner) public virtual onlyOwner {
307         require(newOwner != address(0), "Ownable: new owner is the zero address");
308         _setOwner(newOwner);
309     }
310 
311     function _setOwner(address newOwner) private {
312         address oldOwner = _owner;
313         _owner = newOwner;
314         emit OwnershipTransferred(oldOwner, newOwner);
315     }
316 }
317 
318 /**
319  * @dev Contract module that helps prevent reentrant calls to a function.
320  *
321  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
322  * available, which can be applied to functions to make sure there are no nested
323  * (reentrant) calls to them.
324  *
325  * Note that because there is a single `nonReentrant` guard, functions marked as
326  * `nonReentrant` may not call one another. This can be worked around by making
327  * those functions `private`, and then adding `external` `nonReentrant` entry
328  * points to them.
329  *
330  * TIP: If you would like to learn more about reentrancy and alternative ways
331  * to protect against it, check out our blog post
332  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
333  */
334 abstract contract ReentrancyGuard {
335     // Booleans are more expensive than uint256 or any type that takes up a full
336     // word because each write operation emits an extra SLOAD to first read the
337     // slot's contents, replace the bits taken up by the boolean, and then write
338     // back. This is the compiler's defense against contract upgrades and
339     // pointer aliasing, and it cannot be disabled.
340 
341     // The values being non-zero value makes deployment a bit more expensive,
342     // but in exchange the refund on every call to nonReentrant will be lower in
343     // amount. Since refunds are capped to a percentage of the total
344     // transaction's gas, it is best to keep them low in cases like this one, to
345     // increase the likelihood of the full refund coming into effect.
346     uint256 private constant _NOT_ENTERED = 1;
347     uint256 private constant _ENTERED = 2;
348 
349     uint256 private _status;
350 
351     constructor() {
352         _status = _NOT_ENTERED;
353     }
354 
355     /**
356      * @dev Prevents a contract from calling itself, directly or indirectly.
357      * Calling a `nonReentrant` function from another `nonReentrant`
358      * function is not supported. It is possible to prevent this from happening
359      * by making the `nonReentrant` function external, and make it call a
360      * `private` function that does the actual work.
361      */
362     modifier nonReentrant() {
363         // On the first call to nonReentrant, _notEntered will be true
364         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
365 
366         // Any calls to nonReentrant after this point will fail
367         _status = _ENTERED;
368 
369         _;
370 
371         // By storing the original value once again, a refund is triggered (see
372         // https://eips.ethereum.org/EIPS/eip-2200)
373         _status = _NOT_ENTERED;
374     }
375 }
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
400 /**
401  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
402  * @dev See https://eips.ethereum.org/EIPS/eip-721
403  */
404 interface IERC721Metadata is IERC721 {
405     /**
406      * @dev Returns the token collection name.
407      */
408     function name() external view returns (string memory);
409 
410     /**
411      * @dev Returns the token collection symbol.
412      */
413     function symbol() external view returns (string memory);
414 
415     /**
416      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
417      */
418     function tokenURI(uint256 tokenId) external view returns (string memory);
419 }
420 
421 /**
422  * @dev Collection of functions related to the address type
423  */
424 library Address {
425     /**
426      * @dev Returns true if `account` is a contract.
427      *
428      * [IMPORTANT]
429      * ====
430      * It is unsafe to assume that an address for which this function returns
431      * false is an externally-owned account (EOA) and not a contract.
432      *
433      * Among others, `isContract` will return false for the following
434      * types of addresses:
435      *
436      *  - an externally-owned account
437      *  - a contract in construction
438      *  - an address where a contract will be created
439      *  - an address where a contract lived, but was destroyed
440      * ====
441      */
442     function isContract(address account) internal view returns (bool) {
443         // This method relies on extcodesize, which returns 0 for contracts in
444         // construction, since the code is only stored at the end of the
445         // constructor execution.
446 
447         uint256 size;
448         assembly {
449             size := extcodesize(account)
450         }
451         return size > 0;
452     }
453 
454     /**
455      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
456      * `recipient`, forwarding all available gas and reverting on errors.
457      *
458      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
459      * of certain opcodes, possibly making contracts go over the 2300 gas limit
460      * imposed by `transfer`, making them unable to receive funds via
461      * `transfer`. {sendValue} removes this limitation.
462      *
463      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
464      *
465      * IMPORTANT: because control is transferred to `recipient`, care must be
466      * taken to not create reentrancy vulnerabilities. Consider using
467      * {ReentrancyGuard} or the
468      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
469      */
470     function sendValue(address payable recipient, uint256 amount) internal {
471         require(address(this).balance >= amount, "Address: insufficient balance");
472 
473         (bool success, ) = recipient.call{ value: amount }("");
474         require(success, "Address: unable to send value, recipient may have reverted");
475     }
476 
477     /**
478      * @dev Performs a Solidity function call using a low level `call`. A
479      * plain `call` is an unsafe replacement for a function call: use this
480      * function instead.
481      *
482      * If `target` reverts with a revert reason, it is bubbled up by this
483      * function (like regular Solidity function calls).
484      *
485      * Returns the raw returned data. To convert to the expected return value,
486      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
487      *
488      * Requirements:
489      *
490      * - `target` must be a contract.
491      * - calling `target` with `data` must not revert.
492      *
493      * _Available since v3.1._
494      */
495     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
496         return functionCall(target, data, "Address: low-level call failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
501      * `errorMessage` as a fallback revert reason when `target` reverts.
502      *
503      * _Available since v3.1._
504      */
505     function functionCall(
506         address target,
507         bytes memory data,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         return functionCallWithValue(target, data, 0, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but also transferring `value` wei to `target`.
516      *
517      * Requirements:
518      *
519      * - the calling contract must have an ETH balance of at least `value`.
520      * - the called Solidity function must be `payable`.
521      *
522      * _Available since v3.1._
523      */
524     function functionCallWithValue(
525         address target,
526         bytes memory data,
527         uint256 value
528     ) internal returns (bytes memory) {
529         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
534      * with `errorMessage` as a fallback revert reason when `target` reverts.
535      *
536      * _Available since v3.1._
537      */
538     function functionCallWithValue(
539         address target,
540         bytes memory data,
541         uint256 value,
542         string memory errorMessage
543     ) internal returns (bytes memory) {
544         require(address(this).balance >= value, "Address: insufficient balance for call");
545         require(isContract(target), "Address: call to non-contract");
546 
547         (bool success, bytes memory returndata) = target.call{ value: value }(data);
548         return _verifyCallResult(success, returndata, errorMessage);
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
553      * but performing a static call.
554      *
555      * _Available since v3.3._
556      */
557     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
558         return functionStaticCall(target, data, "Address: low-level static call failed");
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
563      * but performing a static call.
564      *
565      * _Available since v3.3._
566      */
567     function functionStaticCall(
568         address target,
569         bytes memory data,
570         string memory errorMessage
571     ) internal view returns (bytes memory) {
572         require(isContract(target), "Address: static call to non-contract");
573 
574         (bool success, bytes memory returndata) = target.staticcall(data);
575         return _verifyCallResult(success, returndata, errorMessage);
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
580      * but performing a delegate call.
581      *
582      * _Available since v3.4._
583      */
584     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
585         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
590      * but performing a delegate call.
591      *
592      * _Available since v3.4._
593      */
594     function functionDelegateCall(
595         address target,
596         bytes memory data,
597         string memory errorMessage
598     ) internal returns (bytes memory) {
599         require(isContract(target), "Address: delegate call to non-contract");
600 
601         (bool success, bytes memory returndata) = target.delegatecall(data);
602         return _verifyCallResult(success, returndata, errorMessage);
603     }
604 
605     function _verifyCallResult(
606         bool success,
607         bytes memory returndata,
608         string memory errorMessage
609     ) private pure returns (bytes memory) {
610         if (success) {
611             return returndata;
612         } else {
613             // Look for revert reason and bubble it up if present
614             if (returndata.length > 0) {
615                 // The easiest way to bubble the revert reason is using memory via assembly
616 
617                 assembly {
618                     let returndata_size := mload(returndata)
619                     revert(add(32, returndata), returndata_size)
620                 }
621             } else {
622                 revert(errorMessage);
623             }
624         }
625     }
626 }
627 
628 /**
629  * @dev Implementation of the {IERC165} interface.
630  *
631  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
632  * for the additional interface id that will be supported. For example:
633  *
634  * ```solidity
635  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
636  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
637  * }
638  * ```
639  *
640  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
641  */
642 abstract contract ERC165 is IERC165 {
643     /**
644      * @dev See {IERC165-supportsInterface}.
645      */
646     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
647         return interfaceId == type(IERC165).interfaceId;
648     }
649 }
650 
651 /**
652  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
653  * the Metadata extension, but not including the Enumerable extension, which is available separately as
654  * {ERC721Enumerable}.
655  */
656 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
657     using Address for address;
658     using Strings for uint256;
659 
660     // Token name
661     string private _name;
662 
663     // Token symbol
664     string private _symbol;
665 
666     // Mapping from token ID to owner address
667     mapping(uint256 => address) private _owners;
668 
669     // Mapping owner address to token count
670     mapping(address => uint256) private _balances;
671 
672     // Mapping from token ID to approved address
673     mapping(uint256 => address) private _tokenApprovals;
674 
675     // Mapping from owner to operator approvals
676     mapping(address => mapping(address => bool)) private _operatorApprovals;
677 
678     /**
679      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
680      */
681     constructor(string memory name_, string memory symbol_) {
682         _name = name_;
683         _symbol = symbol_;
684     }
685 
686     /**
687      * @dev See {IERC165-supportsInterface}.
688      */
689     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
690         return
691             interfaceId == type(IERC721).interfaceId ||
692             interfaceId == type(IERC721Metadata).interfaceId ||
693             super.supportsInterface(interfaceId);
694     }
695 
696     /**
697      * @dev See {IERC721-balanceOf}.
698      */
699     function balanceOf(address owner) public view virtual override returns (uint256) {
700         require(owner != address(0), "ERC721: balance query for the zero address");
701         return _balances[owner];
702     }
703 
704     /**
705      * @dev See {IERC721-ownerOf}.
706      */
707     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
708         address owner = _owners[tokenId];
709         require(owner != address(0), "ERC721: owner query for nonexistent token");
710         return owner;
711     }
712 
713     /**
714      * @dev See {IERC721Metadata-name}.
715      */
716     function name() public view virtual override returns (string memory) {
717         return _name;
718     }
719 
720     /**
721      * @dev See {IERC721Metadata-symbol}.
722      */
723     function symbol() public view virtual override returns (string memory) {
724         return _symbol;
725     }
726 
727     /**
728      * @dev See {IERC721Metadata-tokenURI}.
729      */
730     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
731         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
732 
733         string memory baseURI = _baseURI();
734         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
735     }
736 
737     /**
738      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
739      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
740      * by default, can be overriden in child contracts.
741      */
742     function _baseURI() internal view virtual returns (string memory) {
743         return "";
744     }
745 
746     /**
747      * @dev See {IERC721-approve}.
748      */
749     function approve(address to, uint256 tokenId) public virtual override {
750         address owner = ERC721.ownerOf(tokenId);
751         require(to != owner, "ERC721: approval to current owner");
752 
753         require(
754             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
755             "ERC721: approve caller is not owner nor approved for all"
756         );
757 
758         _approve(to, tokenId);
759     }
760 
761     /**
762      * @dev See {IERC721-getApproved}.
763      */
764     function getApproved(uint256 tokenId) public view virtual override returns (address) {
765         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
766 
767         return _tokenApprovals[tokenId];
768     }
769 
770     /**
771      * @dev See {IERC721-setApprovalForAll}.
772      */
773     function setApprovalForAll(address operator, bool approved) public virtual override {
774         require(operator != _msgSender(), "ERC721: approve to caller");
775 
776         _operatorApprovals[_msgSender()][operator] = approved;
777         emit ApprovalForAll(_msgSender(), operator, approved);
778     }
779 
780     /**
781      * @dev See {IERC721-isApprovedForAll}.
782      */
783     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
784         return _operatorApprovals[owner][operator];
785     }
786 
787     /**
788      * @dev See {IERC721-transferFrom}.
789      */
790     function transferFrom(
791         address from,
792         address to,
793         uint256 tokenId
794     ) public virtual override {
795         //solhint-disable-next-line max-line-length
796         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
797 
798         _transfer(from, to, tokenId);
799     }
800 
801     /**
802      * @dev See {IERC721-safeTransferFrom}.
803      */
804     function safeTransferFrom(
805         address from,
806         address to,
807         uint256 tokenId
808     ) public virtual override {
809         safeTransferFrom(from, to, tokenId, "");
810     }
811 
812     /**
813      * @dev See {IERC721-safeTransferFrom}.
814      */
815     function safeTransferFrom(
816         address from,
817         address to,
818         uint256 tokenId,
819         bytes memory _data
820     ) public virtual override {
821         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
822         _safeTransfer(from, to, tokenId, _data);
823     }
824 
825     /**
826      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
827      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
828      *
829      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
830      *
831      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
832      * implement alternative mechanisms to perform token transfer, such as signature-based.
833      *
834      * Requirements:
835      *
836      * - `from` cannot be the zero address.
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must exist and be owned by `from`.
839      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
840      *
841      * Emits a {Transfer} event.
842      */
843     function _safeTransfer(
844         address from,
845         address to,
846         uint256 tokenId,
847         bytes memory _data
848     ) internal virtual {
849         _transfer(from, to, tokenId);
850         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
851     }
852 
853     /**
854      * @dev Returns whether `tokenId` exists.
855      *
856      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
857      *
858      * Tokens start existing when they are minted (`_mint`),
859      * and stop existing when they are burned (`_burn`).
860      */
861     function _exists(uint256 tokenId) internal view virtual returns (bool) {
862         return _owners[tokenId] != address(0);
863     }
864 
865     /**
866      * @dev Returns whether `spender` is allowed to manage `tokenId`.
867      *
868      * Requirements:
869      *
870      * - `tokenId` must exist.
871      */
872     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
873         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
874         address owner = ERC721.ownerOf(tokenId);
875         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
876     }
877 
878     /**
879      * @dev Safely mints `tokenId` and transfers it to `to`.
880      *
881      * Requirements:
882      *
883      * - `tokenId` must not exist.
884      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _safeMint(address to, uint256 tokenId) internal virtual {
889         _safeMint(to, tokenId, "");
890     }
891 
892     /**
893      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
894      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
895      */
896     function _safeMint(
897         address to,
898         uint256 tokenId,
899         bytes memory _data
900     ) internal virtual {
901         _mint(to, tokenId);
902         require(
903             _checkOnERC721Received(address(0), to, tokenId, _data),
904             "ERC721: transfer to non ERC721Receiver implementer"
905         );
906     }
907 
908     /**
909      * @dev Mints `tokenId` and transfers it to `to`.
910      *
911      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
912      *
913      * Requirements:
914      *
915      * - `tokenId` must not exist.
916      * - `to` cannot be the zero address.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _mint(address to, uint256 tokenId) internal virtual {
921         require(to != address(0), "ERC721: mint to the zero address");
922         require(!_exists(tokenId), "ERC721: token already minted");
923 
924         _beforeTokenTransfer(address(0), to, tokenId);
925 
926         _balances[to] += 1;
927         _owners[tokenId] = to;
928 
929         emit Transfer(address(0), to, tokenId);
930     }
931 
932     /**
933      * @dev Destroys `tokenId`.
934      * The approval is cleared when the token is burned.
935      *
936      * Requirements:
937      *
938      * - `tokenId` must exist.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _burn(uint256 tokenId) internal virtual {
943         address owner = ERC721.ownerOf(tokenId);
944 
945         _beforeTokenTransfer(owner, address(0), tokenId);
946 
947         // Clear approvals
948         _approve(address(0), tokenId);
949 
950         _balances[owner] -= 1;
951         delete _owners[tokenId];
952 
953         emit Transfer(owner, address(0), tokenId);
954     }
955 
956     /**
957      * @dev Transfers `tokenId` from `from` to `to`.
958      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
959      *
960      * Requirements:
961      *
962      * - `to` cannot be the zero address.
963      * - `tokenId` token must be owned by `from`.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _transfer(
968         address from,
969         address to,
970         uint256 tokenId
971     ) internal virtual {
972         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
973         require(to != address(0), "ERC721: transfer to the zero address");
974 
975         _beforeTokenTransfer(from, to, tokenId);
976 
977         // Clear approvals from the previous owner
978         _approve(address(0), tokenId);
979 
980         _balances[from] -= 1;
981         _balances[to] += 1;
982         _owners[tokenId] = to;
983 
984         emit Transfer(from, to, tokenId);
985     }
986 
987     /**
988      * @dev Approve `to` to operate on `tokenId`
989      *
990      * Emits a {Approval} event.
991      */
992     function _approve(address to, uint256 tokenId) internal virtual {
993         _tokenApprovals[tokenId] = to;
994         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
995     }
996 
997     /**
998      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
999      * The call is not executed if the target address is not a contract.
1000      *
1001      * @param from address representing the previous owner of the given token ID
1002      * @param to target address that will receive the tokens
1003      * @param tokenId uint256 ID of the token to be transferred
1004      * @param _data bytes optional data to send along with the call
1005      * @return bool whether the call correctly returned the expected magic value
1006      */
1007     function _checkOnERC721Received(
1008         address from,
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) private returns (bool) {
1013         if (to.isContract()) {
1014             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1015                 return retval == IERC721Receiver(to).onERC721Received.selector;
1016             } catch (bytes memory reason) {
1017                 if (reason.length == 0) {
1018                     revert("ERC721: transfer to non ERC721Receiver implementer");
1019                 } else {
1020                     assembly {
1021                         revert(add(32, reason), mload(reason))
1022                     }
1023                 }
1024             }
1025         } else {
1026             return true;
1027         }
1028     }
1029 
1030     /**
1031      * @dev Hook that is called before any token transfer. This includes minting
1032      * and burning.
1033      *
1034      * Calling conditions:
1035      *
1036      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1037      * transferred to `to`.
1038      * - When `from` is zero, `tokenId` will be minted for `to`.
1039      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1040      * - `from` and `to` are never both zero.
1041      *
1042      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1043      */
1044     function _beforeTokenTransfer(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) internal virtual {}
1049 }
1050 
1051 /**
1052  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1053  * @dev See https://eips.ethereum.org/EIPS/eip-721
1054  */
1055 interface IERC721Enumerable is IERC721 {
1056     /**
1057      * @dev Returns the total amount of tokens stored by the contract.
1058      */
1059     function totalSupply() external view returns (uint256);
1060 
1061     /**
1062      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1063      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1064      */
1065     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1066 
1067     /**
1068      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1069      * Use along with {totalSupply} to enumerate all tokens.
1070      */
1071     function tokenByIndex(uint256 index) external view returns (uint256);
1072 }
1073 
1074 /**
1075  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1076  * enumerability of all the token ids in the contract as well as all token ids owned by each
1077  * account.
1078  */
1079 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1080     // Mapping from owner to list of owned token IDs
1081     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1082 
1083     // Mapping from token ID to index of the owner tokens list
1084     mapping(uint256 => uint256) private _ownedTokensIndex;
1085 
1086     // Array with all token ids, used for enumeration
1087     uint256[] private _allTokens;
1088 
1089     // Mapping from token id to position in the allTokens array
1090     mapping(uint256 => uint256) private _allTokensIndex;
1091 
1092     /**
1093      * @dev See {IERC165-supportsInterface}.
1094      */
1095     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1096         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1097     }
1098 
1099     /**
1100      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1101      */
1102     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1103         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1104         return _ownedTokens[owner][index];
1105     }
1106 
1107     /**
1108      * @dev See {IERC721Enumerable-totalSupply}.
1109      */
1110     function totalSupply() public view virtual override returns (uint256) {
1111         return _allTokens.length;
1112     }
1113 
1114     /**
1115      * @dev See {IERC721Enumerable-tokenByIndex}.
1116      */
1117     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1118         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1119         return _allTokens[index];
1120     }
1121 
1122     /**
1123      * @dev Hook that is called before any token transfer. This includes minting
1124      * and burning.
1125      *
1126      * Calling conditions:
1127      *
1128      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1129      * transferred to `to`.
1130      * - When `from` is zero, `tokenId` will be minted for `to`.
1131      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1132      * - `from` cannot be the zero address.
1133      * - `to` cannot be the zero address.
1134      *
1135      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1136      */
1137     function _beforeTokenTransfer(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) internal virtual override {
1142         super._beforeTokenTransfer(from, to, tokenId);
1143 
1144         if (from == address(0)) {
1145             _addTokenToAllTokensEnumeration(tokenId);
1146         } else if (from != to) {
1147             _removeTokenFromOwnerEnumeration(from, tokenId);
1148         }
1149         if (to == address(0)) {
1150             _removeTokenFromAllTokensEnumeration(tokenId);
1151         } else if (to != from) {
1152             _addTokenToOwnerEnumeration(to, tokenId);
1153         }
1154     }
1155 
1156     /**
1157      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1158      * @param to address representing the new owner of the given token ID
1159      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1160      */
1161     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1162         uint256 length = ERC721.balanceOf(to);
1163         _ownedTokens[to][length] = tokenId;
1164         _ownedTokensIndex[tokenId] = length;
1165     }
1166 
1167     /**
1168      * @dev Private function to add a token to this extension's token tracking data structures.
1169      * @param tokenId uint256 ID of the token to be added to the tokens list
1170      */
1171     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1172         _allTokensIndex[tokenId] = _allTokens.length;
1173         _allTokens.push(tokenId);
1174     }
1175 
1176     /**
1177      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1178      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1179      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1180      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1181      * @param from address representing the previous owner of the given token ID
1182      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1183      */
1184     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1185         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1186         // then delete the last slot (swap and pop).
1187 
1188         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1189         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1190 
1191         // When the token to delete is the last token, the swap operation is unnecessary
1192         if (tokenIndex != lastTokenIndex) {
1193             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1194 
1195             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1196             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1197         }
1198 
1199         // This also deletes the contents at the last position of the array
1200         delete _ownedTokensIndex[tokenId];
1201         delete _ownedTokens[from][lastTokenIndex];
1202     }
1203 
1204     /**
1205      * @dev Private function to remove a token from this extension's token tracking data structures.
1206      * This has O(1) time complexity, but alters the order of the _allTokens array.
1207      * @param tokenId uint256 ID of the token to be removed from the tokens list
1208      */
1209     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1210         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1211         // then delete the last slot (swap and pop).
1212 
1213         uint256 lastTokenIndex = _allTokens.length - 1;
1214         uint256 tokenIndex = _allTokensIndex[tokenId];
1215 
1216         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1217         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1218         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1219         uint256 lastTokenId = _allTokens[lastTokenIndex];
1220 
1221         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1222         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1223 
1224         // This also deletes the contents at the last position of the array
1225         delete _allTokensIndex[tokenId];
1226         _allTokens.pop();
1227     }
1228 }
1229 
1230 interface BlootInterface {
1231     function ownerOf(uint256 tokenId) external view returns (address owner);
1232 }
1233 
1234 contract BlootBuildings is ERC721Enumerable, ReentrancyGuard, Ownable {
1235     uint256 public price = 15000000000000000; //0.015 ETH
1236 
1237     //Loot Contract
1238     address public blootAddress = 0x4F8730E0b32B04beaa5757e5aea3aeF970E5B613;
1239     BlootInterface public blootContract = BlootInterface(blootAddress);
1240     
1241     mapping(address => uint256) public founders;
1242     address constant public T = 0x5D708A3b3918C3acE4D17851884672076822FFCf;
1243     address constant public V = 0x08fE4CDCFbf4BEc1Ca0b042B5eADd2bA1e2dC4f1;
1244     address constant public E = 0x1524387D4Ba00Dce612521eaa0FE0702c0F9B5ed;
1245 
1246     constructor() ERC721("BlootBuildings", "BLOOTBD") {
1247       founders[T] = 1; 
1248       founders[V] = 2; 
1249       founders[E] = 3; 
1250     }
1251     
1252     function updateFounder(address _oldAddress, address _newAddress) public {
1253       require(_msgSender() == _oldAddress, "not yours");
1254       founders[_oldAddress] = 0;
1255       founders[_newAddress] = founders[_oldAddress];
1256     }
1257 
1258     string[] private building = [
1259         "Apartment",
1260         "Convenience Store",
1261         "Warehouse",
1262         "Mansion",
1263         "Condo",
1264         "Salon",
1265         "Hotel",
1266         "Post office",
1267         "Police Station",
1268         "Gym",
1269         "Drugstore",
1270         "Book Store",
1271         "Farmhouse",
1272         "Antique Shop",
1273         "Furniture Store",
1274         "Laundromat",
1275         "Mansion",
1276         "Bar",
1277         "Bistro",
1278         "Pod House",
1279         "Tree House",
1280         "Beer Can House",
1281         "Cabin",
1282         "hexayurt",
1283         "villa"
1284     ];
1285 
1286     string[] private material = [
1287         "Material: Stone",
1288         "Material: Dirt",
1289         "Material: Planks",
1290         "Material: Cobblestone",
1291         "Material: Stone Bricks",
1292         "Material: Bricks",
1293         "Material: Obsidian",
1294         "Material: Sand",
1295         "Material: Sandstone",
1296         "Material: Terracotta",
1297         "Material: Basalt",
1298         "Material: Blackstone",
1299         "Material: Purpur Block"
1300     ];
1301 
1302     string[] private style = [
1303         "Ancient Greek Style",
1304         "Art Nouveau Style",
1305         "Medieval/Gothic Style",
1306         "Romanesque Style",
1307         "Ancient Rome/Classical Style",
1308         "Romanesque Revival Style",
1309         "French Baroque Style",
1310         "Victorian Style",
1311         "Shabby-Chic Style",
1312         "Tudor Style",
1313         "Shingle Style",
1314         "Modern Style",
1315         "Post-Modern Style"
1316     ];
1317 
1318     string[] private exterior = [
1319         "Common Exterior",
1320         "Red-trim Common Exterior",
1321         "Blue-trim Common Exterior",
1322         "Pink Common Exterior",
1323         "Red Common Exterior",
1324         "Gray-trim Common Exterior",
1325         "Yellow Common Exterior",
1326         "Black Common Exterior",
1327         "Chalet Exterior",
1328         "Orange Chalet Exterior",
1329         "Brown Chalet Exterior",
1330         "Cream Chalet Exterior",
1331         "Chic Cobblestone Exterior",
1332         "Cobblestone Exterior",
1333         "White Stucco Exterior",
1334         "Pink Stucco Exterior",
1335         "Beige Stucco Exterior"
1336     ];
1337 
1338     string[] private door = [
1339         "Wooden Door",
1340         "Windowed Door",
1341         "Common Door",
1342         "Vertical-panes Door",
1343         "Maple Iron Grill Door",
1344         "Simple Door",
1345         "Latticework Door",
1346         "Zen Door",
1347         "Imperial Door",
1348         "Lacquered Zen Door",
1349         "Metal-accent Door",
1350         "Iron Door",
1351         "Rustic Door"
1352     ];
1353 
1354     string[] private sofa = [
1355         "Sectional Sofa",
1356         "Chesterfield Sofa",
1357         "Lawson-style Sofa",
1358         "Mid-century Modern Sofa",
1359         "Settee Sofa",
1360         "Recliner Sofa",
1361         "Tuxedo Sofa",
1362         "Low-Seated Sofa",
1363         "Divan",
1364         "Cabriole Sofa",
1365         "Camelback Sofa",
1366         "Bridgewater Sofa",
1367         "English Rolled Arm Sofa"
1368     ];
1369 
1370     string[] private roof = [
1371         "Tile Roof",
1372         "Brown Curved Shingles",
1373         "Stone Roof",
1374         "Thatch Roof",
1375         "Gable Roof",
1376         "Hip Roof",
1377         "Mansard Roof",
1378         "Gambrel Roof",
1379         "Flat Roof",
1380         "Skillion Roof",
1381         "Jerkinhead Roof",
1382         "Butterfly Roof",
1383         "Bonnet Roof",
1384         "Saltbox Roof",
1385         "Sawtooth Roof",
1386         "Curved Roof",
1387         "Pyramid Roof",
1388         "Dome Roof",
1389         "Combination Roof"
1390     ];
1391 
1392     string[] private car = [
1393         "Chevrolet Corvette",
1394         "Porsche 911",
1395         "Ferrari 250 GTO",
1396         "Aston Martin DB4",
1397         "VW Beetle without mirror",
1398         "Dodge Viper GTS",
1399         "Broken-down Jeep",
1400         "Tesla model S",
1401         "KIA Carnival",
1402         "Honda Odyssey",
1403         "Toyota Sienna",
1404         "The Victory 8-Ball",
1405         "Scout Bobber"
1406     ];
1407 
1408     string[] private feature = [
1409         "The upside-down place",
1410         "Has stairs leading to nowhere",
1411         "Has an underground fortress",
1412         "Has a secret tunnel",
1413         "Has the hidden gold",
1414         "The leaky water place",
1415         "Abandoned",
1416         "Corpse alert!",
1417         "Has radiation pollutionx",
1418         "A partially see-through",
1419         "The Haunted place",
1420         "It's amazing!",
1421         "Has incomparable wavy walls",
1422         "Meow!",
1423         "Near the riverside",
1424         "Has a kind manager",
1425         "With two cute kids",
1426         "Has a broken bathroom",
1427         "Full of fragrance",
1428         "Has a golden gate",
1429         "Slippy floor",
1430         "A winning lottery on the table",
1431         "Has a gold wire christmas tree"
1432     ];
1433 
1434 
1435     function random(string memory input) internal pure returns (uint256) {
1436         return uint256(keccak256(abi.encodePacked(input)));
1437     }
1438 
1439     function getBuilding(uint256 tokenId) public view returns (string memory) {
1440         return pluck(tokenId, "BUILDING", building);
1441     }
1442 
1443     function getMaterial(uint256 tokenId) public view returns (string memory) {
1444         return pluck(tokenId, "MATERIAL", material);
1445     }
1446 
1447     function getStyle(uint256 tokenId) public view returns (string memory) {
1448         return pluck(tokenId, "STYLE", style);
1449     }
1450 
1451     function getExterior(uint256 tokenId) public view returns (string memory) {
1452         return pluck(tokenId, "EXTERIOR", exterior);
1453     }
1454 
1455     function getDoor(uint256 tokenId) public view returns (string memory) {
1456         return pluck(tokenId, "DOOR", door);
1457     }
1458 
1459     function getSofa(uint256 tokenId) public view returns (string memory) {
1460         return pluck(tokenId, "SOFA", sofa);
1461     }
1462 
1463     function getRoof(uint256 tokenId) public view returns (string memory) {
1464         return pluck(tokenId, "ROOF", roof);
1465     }
1466 
1467     function getCar(uint256 tokenId) public view returns (string memory) {
1468         return pluck(tokenId, "CAR", car);
1469     }
1470     
1471     function getFeature(uint256 tokenId) public view returns (string memory) {
1472         return pluck(tokenId, "FEATURE", feature);
1473     }
1474     
1475 
1476     function pluck(
1477         uint256 tokenId,
1478         string memory keyPrefix,
1479         string[] memory sourceArray
1480     ) internal view returns (string memory) {
1481         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1482         string memory output = sourceArray[rand % sourceArray.length];
1483         uint256 greatness = rand % 21;
1484 
1485         if (keccak256(abi.encodePacked(keyPrefix)) == keccak256("BUILDING") && greatness > 9) {
1486             output = string(abi.encodePacked('"', feature[rand % feature.length], '" ', output));
1487         }
1488         
1489         if (keccak256(abi.encodePacked(keyPrefix)) == keccak256("CAR") && greatness < 14) {
1490             output = string(abi.encodePacked('No Car'));
1491         }
1492 
1493         return output;
1494     }
1495 
1496     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1497         string[17] memory parts;
1498         parts[
1499             0
1500         ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#01ff01" /><text x="10" y="20" class="base">';
1501 
1502         parts[1] = getBuilding(tokenId);
1503 
1504         parts[2] = '</text><text x="10" y="40" class="base">';
1505 
1506         parts[3] = getMaterial(tokenId);
1507 
1508         parts[4] = '</text><text x="10" y="60" class="base">';
1509 
1510         parts[5] = getStyle(tokenId);
1511 
1512         parts[6] = '</text><text x="10" y="80" class="base">';
1513 
1514         parts[7] = getExterior(tokenId);
1515 
1516         parts[8] = '</text><text x="10" y="100" class="base">';
1517 
1518         parts[9] = getDoor(tokenId);
1519 
1520         parts[10] = '</text><text x="10" y="120" class="base">';
1521 
1522         parts[11] = getRoof(tokenId);
1523 
1524         parts[12] = '</text><text x="10" y="140" class="base">';
1525 
1526         parts[13] = getSofa(tokenId);
1527 
1528         parts[14] = '</text><text x="10" y="160" class="base">';
1529         
1530         parts[15] = getCar(tokenId);
1531 
1532         parts[16] = "</text></svg>";
1533 
1534         string memory output = string(
1535             abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8])
1536         );
1537         output = string(
1538             abi.encodePacked(
1539                 output,
1540                 parts[9],
1541                 parts[10],
1542                 parts[11],
1543                 parts[12],
1544                 parts[13],
1545                 parts[14],
1546                 parts[15],
1547                 parts[16]
1548             )
1549         );
1550 
1551         string memory json = Base64.encode(
1552             bytes(
1553                 string(
1554                     abi.encodePacked(
1555                         '{"name": "Bloot Building #',
1556                         toString(tokenId),
1557                         '", "description": "It is basically worthless, but it is free for bloot holders to get a building.", "image": "data:image/svg+xml;base64,',
1558                         Base64.encode(bytes(output)),
1559                         '"}'
1560                     )
1561                 )
1562             )
1563         );
1564         output = string(abi.encodePacked("data:application/json;base64,", json));
1565 
1566         return output;
1567     }
1568 
1569     function mint(uint256 tokenId) public payable nonReentrant {
1570         require(tokenId > 8000 && tokenId <= 11950, "Token ID invalid");
1571         require(price <= msg.value, "Ether value sent is not correct");
1572         _safeMint(_msgSender(), tokenId);
1573     }
1574 
1575     function multiMint(uint256[] memory tokenIds) public payable nonReentrant {
1576         require((price * tokenIds.length) <= msg.value, "Ether value sent is not correct");
1577         for (uint256 i = 0; i < tokenIds.length; i++) {
1578             require(tokenIds[i] > 8000 && tokenIds[i] < 11950, "Token ID invalid");
1579             _safeMint(msg.sender, tokenIds[i]);
1580         }
1581     }
1582 
1583     function mintWithBloot(uint256 blootId) public payable nonReentrant {
1584         require(blootId > 0 && blootId <= 8000, "Token ID invalid");
1585         require(blootContract.ownerOf(blootId) == msg.sender, "Not the owner of this bloot");
1586         _safeMint(_msgSender(), blootId);
1587     }
1588 
1589     function multiMintWithBloot(uint256[] memory blootIds) public payable nonReentrant {
1590         for (uint256 i = 0; i < blootIds.length; i++) {
1591             require(blootContract.ownerOf(blootIds[i]) == msg.sender, "Not the owner of this bloot");
1592             _safeMint(_msgSender(), blootIds[i]);
1593         }
1594     }
1595     
1596     function founderClaim(uint256[] memory tokenIds) public nonReentrant {
1597         for(uint256 i = 0; i < tokenIds.length; i++) {
1598               require(tokenIds[i] > 11950 && tokenIds[i] <= 12000, "Token ID invalid");
1599               require(tokenIds[i] % 3 == founders[address(_msgSender())] - 1, "not your's to mint");
1600               _safeMint(_msgSender(), tokenIds[i]);
1601         }
1602     }
1603 
1604     function withdraw() public onlyOwner {
1605         payable(0x5D708A3b3918C3acE4D17851884672076822FFCf).transfer(address(this).balance);
1606     }
1607 
1608     function toString(uint256 value) internal pure returns (string memory) {
1609         // Inspired by OraclizeAPI's implementation - MIT license
1610         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1611 
1612         if (value == 0) {
1613             return "0";
1614         }
1615         uint256 temp = value;
1616         uint256 digits;
1617         while (temp != 0) {
1618             digits++;
1619             temp /= 10;
1620         }
1621         bytes memory buffer = new bytes(digits);
1622         while (value != 0) {
1623             digits -= 1;
1624             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1625             value /= 10;
1626         }
1627         return string(buffer);
1628     }
1629 }
1630 
1631 /// [MIT License]
1632 /// @title Base64
1633 /// @notice Provides a function for encoding some bytes in base64
1634 /// @author Brecht Devos <brecht@loopring.org>
1635 library Base64 {
1636     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1637 
1638     /// @notice Encodes some bytes to the base64 representation
1639     function encode(bytes memory data) internal pure returns (string memory) {
1640         uint256 len = data.length;
1641         if (len == 0) return "";
1642 
1643         // multiply by 4/3 rounded up
1644         uint256 encodedLen = 4 * ((len + 2) / 3);
1645 
1646         // Add some extra buffer at the end
1647         bytes memory result = new bytes(encodedLen + 32);
1648 
1649         bytes memory table = TABLE;
1650 
1651         assembly {
1652             let tablePtr := add(table, 1)
1653             let resultPtr := add(result, 32)
1654 
1655             for {
1656                 let i := 0
1657             } lt(i, len) {
1658 
1659             } {
1660                 i := add(i, 3)
1661                 let input := and(mload(add(data, i)), 0xffffff)
1662 
1663                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1664                 out := shl(8, out)
1665                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1666                 out := shl(8, out)
1667                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1668                 out := shl(8, out)
1669                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1670                 out := shl(224, out)
1671 
1672                 mstore(resultPtr, out)
1673 
1674                 resultPtr := add(resultPtr, 4)
1675             }
1676 
1677             switch mod(len, 3)
1678             case 1 {
1679                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1680             }
1681             case 2 {
1682                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1683             }
1684 
1685             mstore(result, encodedLen)
1686         }
1687 
1688         return string(result);
1689     }
1690 }