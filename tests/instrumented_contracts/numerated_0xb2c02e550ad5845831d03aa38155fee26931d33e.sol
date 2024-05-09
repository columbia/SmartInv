1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-27
3  */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 /**
31  * @dev Required interface of an ERC721 compliant contract.
32  */
33 interface IERC721 is IERC165 {
34     /**
35      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
36      */
37     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
41      */
42     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
46      */
47     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
48 
49     /**
50      * @dev Returns the number of tokens in ``owner``'s account.
51      */
52     function balanceOf(address owner) external view returns (uint256 balance);
53 
54     /**
55      * @dev Returns the owner of the `tokenId` token.
56      *
57      * Requirements:
58      *
59      * - `tokenId` must exist.
60      */
61     function ownerOf(uint256 tokenId) external view returns (address owner);
62 
63     /**
64      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
65      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
66      *
67      * Requirements:
68      *
69      * - `from` cannot be the zero address.
70      * - `to` cannot be the zero address.
71      * - `tokenId` token must exist and be owned by `from`.
72      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
73      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
74      *
75      * Emits a {Transfer} event.
76      */
77     function safeTransferFrom(
78         address from,
79         address to,
80         uint256 tokenId
81     ) external;
82 
83     /**
84      * @dev Transfers `tokenId` token from `from` to `to`.
85      *
86      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must be owned by `from`.
93      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     /**
104      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
105      * The approval is cleared when the token is transferred.
106      *
107      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
108      *
109      * Requirements:
110      *
111      * - The caller must own the token or be an approved operator.
112      * - `tokenId` must exist.
113      *
114      * Emits an {Approval} event.
115      */
116     function approve(address to, uint256 tokenId) external;
117 
118     /**
119      * @dev Returns the account approved for `tokenId` token.
120      *
121      * Requirements:
122      *
123      * - `tokenId` must exist.
124      */
125     function getApproved(uint256 tokenId) external view returns (address operator);
126 
127     /**
128      * @dev Approve or remove `operator` as an operator for the caller.
129      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
130      *
131      * Requirements:
132      *
133      * - The `operator` cannot be the caller.
134      *
135      * Emits an {ApprovalForAll} event.
136      */
137     function setApprovalForAll(address operator, bool _approved) external;
138 
139     /**
140      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
141      *
142      * See {setApprovalForAll}
143      */
144     function isApprovedForAll(address owner, address operator) external view returns (bool);
145 
146     /**
147      * @dev Safely transfers `tokenId` token from `from` to `to`.
148      *
149      * Requirements:
150      *
151      * - `from` cannot be the zero address.
152      * - `to` cannot be the zero address.
153      * - `tokenId` token must exist and be owned by `from`.
154      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
156      *
157      * Emits a {Transfer} event.
158      */
159     function safeTransferFrom(
160         address from,
161         address to,
162         uint256 tokenId,
163         bytes calldata data
164     ) external;
165 }
166 
167 /**
168  * @dev String operations.
169  */
170 library Strings {
171     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
172 
173     /**
174      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
175      */
176     function toString(uint256 value) internal pure returns (string memory) {
177         // Inspired by OraclizeAPI's implementation - MIT licence
178         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
179 
180         if (value == 0) {
181             return "0";
182         }
183         uint256 temp = value;
184         uint256 digits;
185         while (temp != 0) {
186             digits++;
187             temp /= 10;
188         }
189         bytes memory buffer = new bytes(digits);
190         while (value != 0) {
191             digits -= 1;
192             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
193             value /= 10;
194         }
195         return string(buffer);
196     }
197 
198     /**
199      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
200      */
201     function toHexString(uint256 value) internal pure returns (string memory) {
202         if (value == 0) {
203             return "0x00";
204         }
205         uint256 temp = value;
206         uint256 length = 0;
207         while (temp != 0) {
208             length++;
209             temp >>= 8;
210         }
211         return toHexString(value, length);
212     }
213 
214     /**
215      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
216      */
217     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
218         bytes memory buffer = new bytes(2 * length + 2);
219         buffer[0] = "0";
220         buffer[1] = "x";
221         for (uint256 i = 2 * length + 1; i > 1; --i) {
222             buffer[i] = _HEX_SYMBOLS[value & 0xf];
223             value >>= 4;
224         }
225         require(value == 0, "Strings: hex length insufficient");
226         return string(buffer);
227     }
228 }
229 
230 /*
231  * @dev Provides information about the current execution context, including the
232  * sender of the transaction and its data. While these are generally available
233  * via msg.sender and msg.data, they should not be accessed in such a direct
234  * manner, since when dealing with meta-transactions the account sending and
235  * paying for execution may not be the actual sender (as far as an application
236  * is concerned).
237  *
238  * This contract is only required for intermediate, library-like contracts.
239  */
240 abstract contract Context {
241     function _msgSender() internal view virtual returns (address) {
242         return msg.sender;
243     }
244 
245     function _msgData() internal view virtual returns (bytes calldata) {
246         return msg.data;
247     }
248 }
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
316 /**
317  * @dev Contract module that helps prevent reentrant calls to a function.
318  *
319  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
320  * available, which can be applied to functions to make sure there are no nested
321  * (reentrant) calls to them.
322  *
323  * Note that because there is a single `nonReentrant` guard, functions marked as
324  * `nonReentrant` may not call one another. This can be worked around by making
325  * those functions `private`, and then adding `external` `nonReentrant` entry
326  * points to them.
327  *
328  * TIP: If you would like to learn more about reentrancy and alternative ways
329  * to protect against it, check out our blog post
330  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
331  */
332 abstract contract ReentrancyGuard {
333     // Booleans are more expensive than uint256 or any type that takes up a full
334     // word because each write operation emits an extra SLOAD to first read the
335     // slot's contents, replace the bits taken up by the boolean, and then write
336     // back. This is the compiler's defense against contract upgrades and
337     // pointer aliasing, and it cannot be disabled.
338 
339     // The values being non-zero value makes deployment a bit more expensive,
340     // but in exchange the refund on every call to nonReentrant will be lower in
341     // amount. Since refunds are capped to a percentage of the total
342     // transaction's gas, it is best to keep them low in cases like this one, to
343     // increase the likelihood of the full refund coming into effect.
344     uint256 private constant _NOT_ENTERED = 1;
345     uint256 private constant _ENTERED = 2;
346 
347     uint256 private _status;
348 
349     constructor() {
350         _status = _NOT_ENTERED;
351     }
352 
353     /**
354      * @dev Prevents a contract from calling itself, directly or indirectly.
355      * Calling a `nonReentrant` function from another `nonReentrant`
356      * function is not supported. It is possible to prevent this from happening
357      * by making the `nonReentrant` function external, and make it call a
358      * `private` function that does the actual work.
359      */
360     modifier nonReentrant() {
361         // On the first call to nonReentrant, _notEntered will be true
362         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
363 
364         // Any calls to nonReentrant after this point will fail
365         _status = _ENTERED;
366 
367         _;
368 
369         // By storing the original value once again, a refund is triggered (see
370         // https://eips.ethereum.org/EIPS/eip-2200)
371         _status = _NOT_ENTERED;
372     }
373 }
374 
375 /**
376  * @title ERC721 token receiver interface
377  * @dev Interface for any contract that wants to support safeTransfers
378  * from ERC721 asset contracts.
379  */
380 interface IERC721Receiver {
381     /**
382      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
383      * by `operator` from `from`, this function is called.
384      *
385      * It must return its Solidity selector to confirm the token transfer.
386      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
387      *
388      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
389      */
390     function onERC721Received(
391         address operator,
392         address from,
393         uint256 tokenId,
394         bytes calldata data
395     ) external returns (bytes4);
396 }
397 
398 /**
399  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
400  * @dev See https://eips.ethereum.org/EIPS/eip-721
401  */
402 interface IERC721Metadata is IERC721 {
403     /**
404      * @dev Returns the token collection name.
405      */
406     function name() external view returns (string memory);
407 
408     /**
409      * @dev Returns the token collection symbol.
410      */
411     function symbol() external view returns (string memory);
412 
413     /**
414      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
415      */
416     function tokenURI(uint256 tokenId) external view returns (string memory);
417 }
418 
419 /**
420  * @dev Collection of functions related to the address type
421  */
422 library Address {
423     /**
424      * @dev Returns true if `account` is a contract.
425      *
426      * [IMPORTANT]
427      * ====
428      * It is unsafe to assume that an address for which this function returns
429      * false is an externally-owned account (EOA) and not a contract.
430      *
431      * Among others, `isContract` will return false for the following
432      * types of addresses:
433      *
434      *  - an externally-owned account
435      *  - a contract in construction
436      *  - an address where a contract will be created
437      *  - an address where a contract lived, but was destroyed
438      * ====
439      */
440     function isContract(address account) internal view returns (bool) {
441         // This method relies on extcodesize, which returns 0 for contracts in
442         // construction, since the code is only stored at the end of the
443         // constructor execution.
444 
445         uint256 size;
446         assembly {
447             size := extcodesize(account)
448         }
449         return size > 0;
450     }
451 
452     /**
453      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
454      * `recipient`, forwarding all available gas and reverting on errors.
455      *
456      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
457      * of certain opcodes, possibly making contracts go over the 2300 gas limit
458      * imposed by `transfer`, making them unable to receive funds via
459      * `transfer`. {sendValue} removes this limitation.
460      *
461      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
462      *
463      * IMPORTANT: because control is transferred to `recipient`, care must be
464      * taken to not create reentrancy vulnerabilities. Consider using
465      * {ReentrancyGuard} or the
466      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
467      */
468     function sendValue(address payable recipient, uint256 amount) internal {
469         require(address(this).balance >= amount, "Address: insufficient balance");
470 
471         (bool success, ) = recipient.call{value: amount}("");
472         require(success, "Address: unable to send value, recipient may have reverted");
473     }
474 
475     /**
476      * @dev Performs a Solidity function call using a low level `call`. A
477      * plain `call` is an unsafe replacement for a function call: use this
478      * function instead.
479      *
480      * If `target` reverts with a revert reason, it is bubbled up by this
481      * function (like regular Solidity function calls).
482      *
483      * Returns the raw returned data. To convert to the expected return value,
484      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
485      *
486      * Requirements:
487      *
488      * - `target` must be a contract.
489      * - calling `target` with `data` must not revert.
490      *
491      * _Available since v3.1._
492      */
493     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
494         return functionCall(target, data, "Address: low-level call failed");
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
499      * `errorMessage` as a fallback revert reason when `target` reverts.
500      *
501      * _Available since v3.1._
502      */
503     function functionCall(
504         address target,
505         bytes memory data,
506         string memory errorMessage
507     ) internal returns (bytes memory) {
508         return functionCallWithValue(target, data, 0, errorMessage);
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
513      * but also transferring `value` wei to `target`.
514      *
515      * Requirements:
516      *
517      * - the calling contract must have an ETH balance of at least `value`.
518      * - the called Solidity function must be `payable`.
519      *
520      * _Available since v3.1._
521      */
522     function functionCallWithValue(
523         address target,
524         bytes memory data,
525         uint256 value
526     ) internal returns (bytes memory) {
527         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
532      * with `errorMessage` as a fallback revert reason when `target` reverts.
533      *
534      * _Available since v3.1._
535      */
536     function functionCallWithValue(
537         address target,
538         bytes memory data,
539         uint256 value,
540         string memory errorMessage
541     ) internal returns (bytes memory) {
542         require(address(this).balance >= value, "Address: insufficient balance for call");
543         require(isContract(target), "Address: call to non-contract");
544 
545         (bool success, bytes memory returndata) = target.call{value: value}(data);
546         return _verifyCallResult(success, returndata, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but performing a static call.
552      *
553      * _Available since v3.3._
554      */
555     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
556         return functionStaticCall(target, data, "Address: low-level static call failed");
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
561      * but performing a static call.
562      *
563      * _Available since v3.3._
564      */
565     function functionStaticCall(
566         address target,
567         bytes memory data,
568         string memory errorMessage
569     ) internal view returns (bytes memory) {
570         require(isContract(target), "Address: static call to non-contract");
571 
572         (bool success, bytes memory returndata) = target.staticcall(data);
573         return _verifyCallResult(success, returndata, errorMessage);
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
578      * but performing a delegate call.
579      *
580      * _Available since v3.4._
581      */
582     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
583         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
588      * but performing a delegate call.
589      *
590      * _Available since v3.4._
591      */
592     function functionDelegateCall(
593         address target,
594         bytes memory data,
595         string memory errorMessage
596     ) internal returns (bytes memory) {
597         require(isContract(target), "Address: delegate call to non-contract");
598 
599         (bool success, bytes memory returndata) = target.delegatecall(data);
600         return _verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     function _verifyCallResult(
604         bool success,
605         bytes memory returndata,
606         string memory errorMessage
607     ) private pure returns (bytes memory) {
608         if (success) {
609             return returndata;
610         } else {
611             // Look for revert reason and bubble it up if present
612             if (returndata.length > 0) {
613                 // The easiest way to bubble the revert reason is using memory via assembly
614 
615                 assembly {
616                     let returndata_size := mload(returndata)
617                     revert(add(32, returndata), returndata_size)
618                 }
619             } else {
620                 revert(errorMessage);
621             }
622         }
623     }
624 }
625 
626 /**
627  * @dev Implementation of the {IERC165} interface.
628  *
629  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
630  * for the additional interface id that will be supported. For example:
631  *
632  * ```solidity
633  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
634  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
635  * }
636  * ```
637  *
638  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
639  */
640 abstract contract ERC165 is IERC165 {
641     /**
642      * @dev See {IERC165-supportsInterface}.
643      */
644     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
645         return interfaceId == type(IERC165).interfaceId;
646     }
647 }
648 
649 /**
650  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
651  * the Metadata extension, but not including the Enumerable extension, which is available separately as
652  * {ERC721Enumerable}.
653  */
654 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
655     using Address for address;
656     using Strings for uint256;
657 
658     // Token name
659     string private _name;
660 
661     // Token symbol
662     string private _symbol;
663 
664     // Mapping from token ID to owner address
665     mapping(uint256 => address) private _owners;
666 
667     // Mapping owner address to token count
668     mapping(address => uint256) private _balances;
669 
670     // Mapping from token ID to approved address
671     mapping(uint256 => address) private _tokenApprovals;
672 
673     // Mapping from owner to operator approvals
674     mapping(address => mapping(address => bool)) private _operatorApprovals;
675 
676     /**
677      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
678      */
679     constructor(string memory name_, string memory symbol_) {
680         _name = name_;
681         _symbol = symbol_;
682     }
683 
684     /**
685      * @dev See {IERC165-supportsInterface}.
686      */
687     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
688         return
689             interfaceId == type(IERC721).interfaceId ||
690             interfaceId == type(IERC721Metadata).interfaceId ||
691             super.supportsInterface(interfaceId);
692     }
693 
694     /**
695      * @dev See {IERC721-balanceOf}.
696      */
697     function balanceOf(address owner) public view virtual override returns (uint256) {
698         require(owner != address(0), "ERC721: balance query for the zero address");
699         return _balances[owner];
700     }
701 
702     /**
703      * @dev See {IERC721-ownerOf}.
704      */
705     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
706         address owner = _owners[tokenId];
707         require(owner != address(0), "ERC721: owner query for nonexistent token");
708         return owner;
709     }
710 
711     /**
712      * @dev See {IERC721Metadata-name}.
713      */
714     function name() public view virtual override returns (string memory) {
715         return _name;
716     }
717 
718     /**
719      * @dev See {IERC721Metadata-symbol}.
720      */
721     function symbol() public view virtual override returns (string memory) {
722         return _symbol;
723     }
724 
725     /**
726      * @dev See {IERC721Metadata-tokenURI}.
727      */
728     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
729         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
730 
731         string memory baseURI = _baseURI();
732         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
733     }
734 
735     /**
736      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
737      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
738      * by default, can be overriden in child contracts.
739      */
740     function _baseURI() internal view virtual returns (string memory) {
741         return "";
742     }
743 
744     /**
745      * @dev See {IERC721-approve}.
746      */
747     function approve(address to, uint256 tokenId) public virtual override {
748         address owner = ERC721.ownerOf(tokenId);
749         require(to != owner, "ERC721: approval to current owner");
750 
751         require(
752             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
753             "ERC721: approve caller is not owner nor approved for all"
754         );
755 
756         _approve(to, tokenId);
757     }
758 
759     /**
760      * @dev See {IERC721-getApproved}.
761      */
762     function getApproved(uint256 tokenId) public view virtual override returns (address) {
763         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
764 
765         return _tokenApprovals[tokenId];
766     }
767 
768     /**
769      * @dev See {IERC721-setApprovalForAll}.
770      */
771     function setApprovalForAll(address operator, bool approved) public virtual override {
772         require(operator != _msgSender(), "ERC721: approve to caller");
773 
774         _operatorApprovals[_msgSender()][operator] = approved;
775         emit ApprovalForAll(_msgSender(), operator, approved);
776     }
777 
778     /**
779      * @dev See {IERC721-isApprovedForAll}.
780      */
781     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
782         return _operatorApprovals[owner][operator];
783     }
784 
785     /**
786      * @dev See {IERC721-transferFrom}.
787      */
788     function transferFrom(
789         address from,
790         address to,
791         uint256 tokenId
792     ) public virtual override {
793         //solhint-disable-next-line max-line-length
794         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
795 
796         _transfer(from, to, tokenId);
797     }
798 
799     /**
800      * @dev See {IERC721-safeTransferFrom}.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId
806     ) public virtual override {
807         safeTransferFrom(from, to, tokenId, "");
808     }
809 
810     /**
811      * @dev See {IERC721-safeTransferFrom}.
812      */
813     function safeTransferFrom(
814         address from,
815         address to,
816         uint256 tokenId,
817         bytes memory _data
818     ) public virtual override {
819         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
820         _safeTransfer(from, to, tokenId, _data);
821     }
822 
823     /**
824      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
825      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
826      *
827      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
828      *
829      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
830      * implement alternative mechanisms to perform token transfer, such as signature-based.
831      *
832      * Requirements:
833      *
834      * - `from` cannot be the zero address.
835      * - `to` cannot be the zero address.
836      * - `tokenId` token must exist and be owned by `from`.
837      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _safeTransfer(
842         address from,
843         address to,
844         uint256 tokenId,
845         bytes memory _data
846     ) internal virtual {
847         _transfer(from, to, tokenId);
848         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
849     }
850 
851     /**
852      * @dev Returns whether `tokenId` exists.
853      *
854      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
855      *
856      * Tokens start existing when they are minted (`_mint`),
857      * and stop existing when they are burned (`_burn`).
858      */
859     function _exists(uint256 tokenId) internal view virtual returns (bool) {
860         return _owners[tokenId] != address(0);
861     }
862 
863     /**
864      * @dev Returns whether `spender` is allowed to manage `tokenId`.
865      *
866      * Requirements:
867      *
868      * - `tokenId` must exist.
869      */
870     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
871         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
872         address owner = ERC721.ownerOf(tokenId);
873         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
874     }
875 
876     /**
877      * @dev Safely mints `tokenId` and transfers it to `to`.
878      *
879      * Requirements:
880      *
881      * - `tokenId` must not exist.
882      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _safeMint(address to, uint256 tokenId) internal virtual {
887         _safeMint(to, tokenId, "");
888     }
889 
890     /**
891      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
892      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
893      */
894     function _safeMint(
895         address to,
896         uint256 tokenId,
897         bytes memory _data
898     ) internal virtual {
899         _mint(to, tokenId);
900         require(
901             _checkOnERC721Received(address(0), to, tokenId, _data),
902             "ERC721: transfer to non ERC721Receiver implementer"
903         );
904     }
905 
906     /**
907      * @dev Mints `tokenId` and transfers it to `to`.
908      *
909      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
910      *
911      * Requirements:
912      *
913      * - `tokenId` must not exist.
914      * - `to` cannot be the zero address.
915      *
916      * Emits a {Transfer} event.
917      */
918     function _mint(address to, uint256 tokenId) internal virtual {
919         require(to != address(0), "ERC721: mint to the zero address");
920         require(!_exists(tokenId), "ERC721: token already minted");
921 
922         _beforeTokenTransfer(address(0), to, tokenId);
923 
924         _balances[to] += 1;
925         _owners[tokenId] = to;
926 
927         emit Transfer(address(0), to, tokenId);
928     }
929 
930     /**
931      * @dev Destroys `tokenId`.
932      * The approval is cleared when the token is burned.
933      *
934      * Requirements:
935      *
936      * - `tokenId` must exist.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _burn(uint256 tokenId) internal virtual {
941         address owner = ERC721.ownerOf(tokenId);
942 
943         _beforeTokenTransfer(owner, address(0), tokenId);
944 
945         // Clear approvals
946         _approve(address(0), tokenId);
947 
948         _balances[owner] -= 1;
949         delete _owners[tokenId];
950 
951         emit Transfer(owner, address(0), tokenId);
952     }
953 
954     /**
955      * @dev Transfers `tokenId` from `from` to `to`.
956      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
957      *
958      * Requirements:
959      *
960      * - `to` cannot be the zero address.
961      * - `tokenId` token must be owned by `from`.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _transfer(
966         address from,
967         address to,
968         uint256 tokenId
969     ) internal virtual {
970         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
971         require(to != address(0), "ERC721: transfer to the zero address");
972 
973         _beforeTokenTransfer(from, to, tokenId);
974 
975         // Clear approvals from the previous owner
976         _approve(address(0), tokenId);
977 
978         _balances[from] -= 1;
979         _balances[to] += 1;
980         _owners[tokenId] = to;
981 
982         emit Transfer(from, to, tokenId);
983     }
984 
985     /**
986      * @dev Approve `to` to operate on `tokenId`
987      *
988      * Emits a {Approval} event.
989      */
990     function _approve(address to, uint256 tokenId) internal virtual {
991         _tokenApprovals[tokenId] = to;
992         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
993     }
994 
995     /**
996      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
997      * The call is not executed if the target address is not a contract.
998      *
999      * @param from address representing the previous owner of the given token ID
1000      * @param to target address that will receive the tokens
1001      * @param tokenId uint256 ID of the token to be transferred
1002      * @param _data bytes optional data to send along with the call
1003      * @return bool whether the call correctly returned the expected magic value
1004      */
1005     function _checkOnERC721Received(
1006         address from,
1007         address to,
1008         uint256 tokenId,
1009         bytes memory _data
1010     ) private returns (bool) {
1011         if (to.isContract()) {
1012             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1013                 return retval == IERC721Receiver(to).onERC721Received.selector;
1014             } catch (bytes memory reason) {
1015                 if (reason.length == 0) {
1016                     revert("ERC721: transfer to non ERC721Receiver implementer");
1017                 } else {
1018                     assembly {
1019                         revert(add(32, reason), mload(reason))
1020                     }
1021                 }
1022             }
1023         } else {
1024             return true;
1025         }
1026     }
1027 
1028     /**
1029      * @dev Hook that is called before any token transfer. This includes minting
1030      * and burning.
1031      *
1032      * Calling conditions:
1033      *
1034      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1035      * transferred to `to`.
1036      * - When `from` is zero, `tokenId` will be minted for `to`.
1037      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1038      * - `from` and `to` are never both zero.
1039      *
1040      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1041      */
1042     function _beforeTokenTransfer(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) internal virtual {}
1047 }
1048 
1049 /**
1050  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1051  * @dev See https://eips.ethereum.org/EIPS/eip-721
1052  */
1053 interface IERC721Enumerable is IERC721 {
1054     /**
1055      * @dev Returns the total amount of tokens stored by the contract.
1056      */
1057     function totalSupply() external view returns (uint256);
1058 
1059     /**
1060      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1061      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1062      */
1063     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1064 
1065     /**
1066      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1067      * Use along with {totalSupply} to enumerate all tokens.
1068      */
1069     function tokenByIndex(uint256 index) external view returns (uint256);
1070 }
1071 
1072 /**
1073  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1074  * enumerability of all the token ids in the contract as well as all token ids owned by each
1075  * account.
1076  */
1077 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1078     // Mapping from owner to list of owned token IDs
1079     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1080 
1081     // Mapping from token ID to index of the owner tokens list
1082     mapping(uint256 => uint256) private _ownedTokensIndex;
1083 
1084     // Array with all token ids, used for enumeration
1085     uint256[] private _allTokens;
1086 
1087     // Mapping from token id to position in the allTokens array
1088     mapping(uint256 => uint256) private _allTokensIndex;
1089 
1090     /**
1091      * @dev See {IERC165-supportsInterface}.
1092      */
1093     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1094         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1095     }
1096 
1097     /**
1098      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1099      */
1100     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1101         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1102         return _ownedTokens[owner][index];
1103     }
1104 
1105     /**
1106      * @dev See {IERC721Enumerable-totalSupply}.
1107      */
1108     function totalSupply() public view virtual override returns (uint256) {
1109         return _allTokens.length;
1110     }
1111 
1112     /**
1113      * @dev See {IERC721Enumerable-tokenByIndex}.
1114      */
1115     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1116         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1117         return _allTokens[index];
1118     }
1119 
1120     /**
1121      * @dev Hook that is called before any token transfer. This includes minting
1122      * and burning.
1123      *
1124      * Calling conditions:
1125      *
1126      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1127      * transferred to `to`.
1128      * - When `from` is zero, `tokenId` will be minted for `to`.
1129      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1130      * - `from` cannot be the zero address.
1131      * - `to` cannot be the zero address.
1132      *
1133      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1134      */
1135     function _beforeTokenTransfer(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) internal virtual override {
1140         super._beforeTokenTransfer(from, to, tokenId);
1141 
1142         if (from == address(0)) {
1143             _addTokenToAllTokensEnumeration(tokenId);
1144         } else if (from != to) {
1145             _removeTokenFromOwnerEnumeration(from, tokenId);
1146         }
1147         if (to == address(0)) {
1148             _removeTokenFromAllTokensEnumeration(tokenId);
1149         } else if (to != from) {
1150             _addTokenToOwnerEnumeration(to, tokenId);
1151         }
1152     }
1153 
1154     /**
1155      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1156      * @param to address representing the new owner of the given token ID
1157      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1158      */
1159     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1160         uint256 length = ERC721.balanceOf(to);
1161         _ownedTokens[to][length] = tokenId;
1162         _ownedTokensIndex[tokenId] = length;
1163     }
1164 
1165     /**
1166      * @dev Private function to add a token to this extension's token tracking data structures.
1167      * @param tokenId uint256 ID of the token to be added to the tokens list
1168      */
1169     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1170         _allTokensIndex[tokenId] = _allTokens.length;
1171         _allTokens.push(tokenId);
1172     }
1173 
1174     /**
1175      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1176      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1177      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1178      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1179      * @param from address representing the previous owner of the given token ID
1180      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1181      */
1182     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1183         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1184         // then delete the last slot (swap and pop).
1185 
1186         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1187         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1188 
1189         // When the token to delete is the last token, the swap operation is unnecessary
1190         if (tokenIndex != lastTokenIndex) {
1191             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1192 
1193             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1194             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1195         }
1196 
1197         // This also deletes the contents at the last position of the array
1198         delete _ownedTokensIndex[tokenId];
1199         delete _ownedTokens[from][lastTokenIndex];
1200     }
1201 
1202     /**
1203      * @dev Private function to remove a token from this extension's token tracking data structures.
1204      * This has O(1) time complexity, but alters the order of the _allTokens array.
1205      * @param tokenId uint256 ID of the token to be removed from the tokens list
1206      */
1207     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1208         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1209         // then delete the last slot (swap and pop).
1210 
1211         uint256 lastTokenIndex = _allTokens.length - 1;
1212         uint256 tokenIndex = _allTokensIndex[tokenId];
1213 
1214         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1215         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1216         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1217         uint256 lastTokenId = _allTokens[lastTokenIndex];
1218 
1219         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1220         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1221 
1222         // This also deletes the contents at the last position of the array
1223         delete _allTokensIndex[tokenId];
1224         _allTokens.pop();
1225     }
1226 }
1227 
1228 interface LootInterface {
1229     function ownerOf(uint256 tokenId) external view returns (address owner);
1230 }
1231 
1232 contract BlootDoggs is ERC721Enumerable, ReentrancyGuard, Ownable {
1233     //Loot Contract
1234     address public lootAddress = 0x4F8730E0b32B04beaa5757e5aea3aeF970E5B613;
1235     LootInterface public lootContract = LootInterface(lootAddress);
1236 
1237     string[] private tag = [
1238         "Sushi","Dumpling","Genevive","Pancake","Yuki","Gigi","Happy","Chibi","Lucky","Mochi","Bubba","Yui","Matcha","Jerry","Bunny","Candy","Bubbles","Apricot","Bear","Button","Freckles","Noodle","Muffin","Sprout","Peachy","Wafflestiltskin","Peanut","Teddy","Pebbles","Kabochan","Tadeo","Abby","Abe","Addie","Ace","Alexis","Aero","Alice","Aiden","Amelia","AJ","Angel","Alfie","Annie","Andy","Ariel","Archie","Ava","Artie","Avery","Atlas","Baby","Austin","Bailey","Bailey","Bambi","Baja","Basil","Barkley","Bea","Basil","Bean","Baxter","Bella","Bean","Belle","Bear","Betty","Beau","Birdie","Benji","Biscuit","Benny","Blanche","Billy","Blondie","Bingo","Blossom","Biscuit","Bonnie","Blaze","Brooklyn","Blue","Buffy","Bo","Callie","Bolt","Candy","Boomer","Carly","Boots","Carmen","Brady","Casey","Brownie","Cece","Bubba","Chance","Buck","Chanel","Buddy","Cherry","Buster","Cheyenne","Buttons","Chloe","Buzz","Cinnamon","Cain","Clara","Captain","Cleo","Carter","Clover","Champ","Coco","Chance","Cookie","Charlie","Cora","Chase","Cricket","Chester","Daisy","Chewy","Dakota","Chico","Dallas","Chip","Daphne","CJ","Darla","Clifford","Delia","Clyde","Delilah","Cody","Destiny","Cooper","Diamond","Corky","Diva","Cosmo","Dixie","Darwin","Dolly","Dash","Dora","Davy","Dory","Denver","Dot","Dexter","Dottie","Diesel","Duchess","Dijon","Eden","Donnie","Edie","Dudley","Effie","Duffy","Eliza","Duke","Ella","Dusty","Ellie","Dylan","Eloise","Eddie","Elsa","Eli","Ember","Eliot","Emma","Elton","Emmy","Everett","Etta","Ezra","Eva","Farley","Faith","Felix","Fancy","Finley","Fannie","Finn","Fanny","Fisher","Faye","Flash","Fifi","Forrest","Flo","Frank","Foxy","Frankie","Frida","Franklin","Gabby","Freddy","Georgia","Fritz","Gia","Gage","Gidget","George","Gigi","Ghost","Ginger","Goose","Gloria","Gordy","Goldie","Grady","Grace","Gus","Gracie","Harley","Hadley","Harry","Hailey","Harvey","Hannah","Hayes","Harley","Henry","Harper","Hooch","Hazel","Hoss","Heidi","Huck","Hershey","Hudson","Holly","Hunter","Honey","Ike","Hope","Indy","Ibby","Ira","Ida","Jack","Iris","Jackson","Ivory","Jasper","Ivy","Java","Izzy","Jesse","Jackie","Jethro","Jada","Joey","Jade","Jordan","Jasmine","Jordy","Jazzy","Kane","Jenna","King","Jersey","Knox","Jewel","Koby","Jolene","Koda","Josie","Lance","Juno","Lenny","Karma","Leo","Kayla","Leroy","Kennedy","Levi","Kiki","Lewis","Kinley","Lightning","Kira","Lincoln","Kiwi","Linus","Koda","Logan","Koko","Loki","Lacy","Louie","Lady","Lyle","Laika","Mac","Lassie","Major","Layla","Marley","Leia","Marty","Lena","Mason","Lexi","Max","Lexy","Maximus","Libby","Maxwell","Liberty","Mickey","Lilly","Miles","Lola","Milo","Lottie","Moe","Lucky","Monty","Lucy","Morty","Lulu","Murphy","Luna","Murray","Mabel","Nelson","Macy","Newton","Maddie","Nico","Maisie","Niles","Mavis","Noah","Maya","Norm","Mia","Oakley","Miley","Odin","Millie","Ollie","Mimi","Orson","Minnie","Oscar","Missy","Otis","Mocha","Otto","Molly","Ozzy","Morgan","Paco","Moxie","Pal","Muffin","Parka","Nala","Parker","Nellie","Patch","Nessie","Peanut","Nettie","Pepper","Nikki","Percy","Nola","Perry","Nori","Petey","Odessa","Pip","Olive","Piper","Olivia","Poe","Opal","Pogo","Oreo","Pongo","Paige","Porter","Paris","Prince","Parker","Quincy","Peaches","Randy","Peanut","Ranger","Pearl","Rascal","Pebbles","Red","Peggy","Reggie","Penny","Ricky","Pepper","Ringo","Petra","Ripley","Phoenix","Rocky","Piper","Rudy","Pippa","Rufus","Pixie","Rusty","Polly","Sam","Poppy","Sammy","Precious","Sarge","Princess","Sawyer","Pumpkin","Scooby","Queenie","Scooter","Remy","Scout","Riley","Scrappy","Rosie","Shadow","Roxy","Shiloh","Ruby","Simba","Ruthie","Skip","Sadie","Smoky","Sandy","Snoopy","Sasha","Socks","Sassy","Sparky","Scarlet","Spencer","Shadow","Spike","Sheba","Spot","Shelby","Stanley","Shiloh","Stewie","Sierra","Stitch","Sissy","Taco","Skye","Tank","Skylar","Tanner","Sophie","Taylor","Star","Taz","Starla","Teddy","Stella","Titus","Storm","TJ","Sugar","Tobias","Suki","Toby","Summer","Tot","Sunny","Toto","Suzie","Tripp","Sweetie","Tucker","Sydney","Turbo","Tabby","Turner","Taffy","Tyler","Tasha","Tyson","Tessa","Vernon","Theo","Vince","Tilly","Vinnie","Trixie","Wade","Trudy","Waffles","Violet","Wally","Vixen","Walter","Wiggles","Watson","Willa","Wilbur","Willow","Winston","Winnie","Woody","Xena","Wyatt","Zelda","Wylie","Zoe","Yogi","Zola","Zane","Zuri","Ziggy"
1239     ];
1240 
1241     string[] private breed = [
1242         "Shiba Inu","Bulldog","Dalmatian","Golden Retriever","Shih Tzu","Bernese Mountain Dog","Border Collie","Chow Chow","Bichon Frise","Miniature Schnauzer","Pomeranian ","Maltese Terrier","Goldendoodle","Dachshund","Yorkshire Terrier","Corgi","German Shepherd","Labrador","Beagle","Chihuahua","Great Dane","Greyhound","Frenchie","Pug","Spitz","Husky"
1243     ];
1244 
1245     string[] private health = [
1246         "Health 1","Health 2","Health 3","Health 4","Health 5","Health 6","Health 7","Health 8","Health 9","Health 10","Health 11","Health 12","Health 13","Health 14","Health 15","Health 16","Health 17","Health 18","Health 19","Health 20"
1247     ];
1248 
1249     string[] private attack = [
1250         "Attack 1","Attack 2","Attack 3","Attack 4","Attack 5","Attack 6","Attack 7","Attack 8","Attack 9","Attack 10","Attack 11","Attack 12","Attack 13","Attack 14","Attack 15","Attack 16","Attack 17","Attack 18","Attack 19","Attack 20"
1251     ];
1252 
1253     string[] private defense = [
1254         "Defense 1","Defense 2","Defense 3","Defense 4","Defense 5","Defense 6","Defense 7","Defense 8","Defense 9","Defense 10","Defense 11","Defense 12","Defense 13","Defense 14","Defense 15","Defense 16","Defense 17","Defense 18","Defense 19","Defense 20"
1255     ];
1256 
1257     string[] private speed = [
1258         "Speed 1","Speed 2","Speed 3","Speed 4","Speed 5","Speed 6","Speed 7","Speed 8","Speed 9","Speed 10","Speed 11","Speed 12","Speed 13","Speed 14","Speed 15","Speed 16","Speed 17","Speed 18","Speed 19","Speed 20"
1259     ];
1260 
1261     string[] private accuracy = [
1262         "Accuracy 1","Accuracy 2","Accuracy 3","Accuracy 4","Accuracy 5","Accuracy 6","Accuracy 7","Accuracy 8","Accuracy 9","Accuracy 10","Accuracy 11","Accuracy 12","Accuracy 13","Accuracy 14","Accuracy 15","Accuracy 16","Accuracy 17","Accuracy 18","Accuracy 19","Accuracy 20"
1263     ];
1264 
1265     string[] private luck = [
1266         "Luck 1","Luck 2","Luck 3","Luck 4","Luck 5","Luck 6","Luck 7","Luck 8","Luck 9","Luck 10","Luck 11","Luck 12","Luck 13","Luck 14","Luck 15","Luck 16","Luck 17","Luck 18","Luck 19","Luck 20"
1267     ];
1268 
1269     string[] private suffixes = [
1270         "The Pound Dog","The Peanut Butter Licker","The Runt of the Litter","The Cargo Rider","The Leash Breaker","The Small Rodent Slayer","The Squirrel Hunter","The Gate Protector","The Guardian of the Chickens","The Purebred","The Guidedog","The Hound of Couch Destruction","The Herder of the Sheep","The Sock Thief","Explorer of the Dog Park","The Son of Mongrels","The Pooch of the Purse","The Squeaky Toy Killer","The Bringer of Bark","The Bringer of Shoes","The Lord of Slobber","The Keeper of the Kennel"
1271     ];
1272 
1273     string[] private namePrefixes = [
1274         "The Bull-Headed","The Crate-Trained","The Groomed","The Scruffy","The Brave","The Prissy","The Neutered Stud","The Toothless","The Kingly","The Princely","The Housebroken","The Watchful","The Cowardly","The Moody","The Unleashed","The Begging","The Loyal","The Blue and Brown Eyed","The Stray","The Well Trained","The Husky","The Submissive","The Dominant","The Well Bred","The Ready-to-Please","The Wagging","The Good-Natured","The Nervous","The Rambunctious","The Ancient","The Newbie","The Wise","The Three-Legged","The Trust Worthy","The Noble","The Obedient","The Huffy","The Nippy"
1275     ];
1276 
1277     string[] private nameSuffixes = [
1278         "of Gundog Guild","of Canine Club","of Hound Hall","of Puppy Place","of Mongrel Mountain","of the Mutt Assembly","of the Backyard Hunters","Last of his Breed","of the Spayed Society","of the Cat-Friendly Clique","of the Curious Crew","of the Dog Run","of the Fenced","of the Four-Legged Fraternity","of Housebroken Hill","of the Slobber Society","follower of Cars","follower of Cats","of Hunter Hub"
1279     ];
1280 
1281     function random(string memory input) internal pure returns (uint256) {
1282         return uint256(keccak256(abi.encodePacked(input)));
1283     }
1284 
1285     function getTag(uint256 tokenId) public view returns (string memory) {
1286         return pluck(tokenId, "TAG", tag);
1287     }
1288 
1289     function getBreed(uint256 tokenId) public view returns (string memory) {
1290         return pluck(tokenId, "BREED", breed);
1291     }
1292 
1293     function getHealth(uint256 tokenId) public view returns (string memory) {
1294         return pluck(tokenId, "HEALTH", health);
1295     }
1296 
1297     function getAttack(uint256 tokenId) public view returns (string memory) {
1298         return pluck(tokenId, "ATTACK", attack);
1299     }
1300 
1301     function getDefense(uint256 tokenId) public view returns (string memory) {
1302         return pluck(tokenId, "DEFENSE", defense);
1303     }
1304 
1305     function getSpeed(uint256 tokenId) public view returns (string memory) {
1306         return pluck(tokenId, "SPEED", speed);
1307     }
1308 
1309     function getAccuracy(uint256 tokenId) public view returns (string memory) {
1310         return pluck(tokenId, "ACCURACY", accuracy);
1311     }
1312 
1313     function getLuck(uint256 tokenId) public view returns (string memory) {
1314         return pluck(tokenId, "LUCK", luck);
1315     }
1316 
1317     function pluck(
1318         uint256 tokenId,
1319         string memory keyPrefix,
1320         string[] memory sourceArray
1321     ) internal view returns (string memory) {
1322         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1323         string memory output = sourceArray[rand % sourceArray.length];
1324         uint256 greatness = rand % 21;
1325 
1326         if (keccak256(abi.encodePacked(keyPrefix)) == keccak256("TAG") && greatness > 14) {
1327             string[2] memory name;
1328             name[0] = namePrefixes[rand % namePrefixes.length];
1329             name[1] = nameSuffixes[rand % nameSuffixes.length];
1330             output = string(abi.encodePacked(name[0], " ", output, " ", name[1]));
1331 
1332         }
1333         if (keccak256(abi.encodePacked(keyPrefix)) == keccak256("BREED") && greatness >= 19) {
1334             output = string(abi.encodePacked(output, " ", suffixes[rand % suffixes.length]));
1335         }
1336         return output;
1337     }
1338 
1339     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1340         string[17] memory parts;
1341         parts[
1342             0
1343         ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#01ff01" /><text x="10" y="20" class="base">';
1344 
1345         parts[1] = getTag(tokenId);
1346 
1347         parts[2] = '</text><text x="10" y="40" class="base">';
1348 
1349         parts[3] = getBreed(tokenId);
1350 
1351         parts[4] = '</text><text x="10" y="60" class="base">';
1352 
1353         parts[5] = getHealth(tokenId);
1354 
1355         parts[6] = '</text><text x="10" y="80" class="base">';
1356 
1357         parts[7] = getAttack(tokenId);
1358 
1359         parts[8] = '</text><text x="10" y="100" class="base">';
1360 
1361         parts[9] = getDefense(tokenId);
1362 
1363         parts[10] = '</text><text x="10" y="120" class="base">';
1364 
1365         parts[11] = getSpeed(tokenId);
1366 
1367         parts[12] = '</text><text x="10" y="140" class="base">';
1368 
1369         parts[13] = getAccuracy(tokenId);
1370 
1371         parts[14] = '</text><text x="10" y="160" class="base">';
1372 
1373         parts[15] = getLuck(tokenId);
1374 
1375         parts[16] = "</text></svg>";
1376 
1377         string memory output = string(
1378             abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8])
1379         );
1380         output = string(
1381             abi.encodePacked(
1382                 output,
1383                 parts[9],
1384                 parts[10],
1385                 parts[11],
1386                 parts[12],
1387                 parts[13],
1388                 parts[14],
1389                 parts[15],
1390                 parts[16]
1391             )
1392         );
1393 
1394         string memory json = Base64.encode(
1395             bytes(
1396                 string(
1397                     abi.encodePacked(
1398                         '{"name": "Dogg #',
1399                         toString(tokenId),
1400                         '", "description": "Bloot Doggs are randomized, generated and stored on chain. Images and other functionality are intentionally omitted for others to interpret. Feel free to use Bloot Doggs in any way you want. Inspired by and compatible with Bloot.", "image": "data:image/svg+xml;base64,',
1401                         Base64.encode(bytes(output)),
1402                         '"}'
1403                     )
1404                 )
1405             )
1406         );
1407         output = string(abi.encodePacked("data:application/json;base64,", json));
1408 
1409         return output;
1410     }
1411 
1412     function mint(uint256 tokenId) public nonReentrant {
1413         require(tokenId > 8008 && tokenId <= 20000, "Token ID invalid");
1414         _safeMint(_msgSender(), tokenId);
1415     }
1416 
1417     function multiMint(uint256[] memory tokenIds) public nonReentrant {
1418         for (uint256 i = 0; i < tokenIds.length; i++) {
1419             require(tokenIds[i] > 8008 && tokenIds[i] < 20000, "Token ID invalid");
1420             _safeMint(msg.sender, tokenIds[i]);
1421         }
1422     }
1423 
1424     function mintWithBloot(uint256 lootId) public nonReentrant {
1425         require(lootId > 0 && lootId <= 8008, "Token ID invalid");
1426         require(lootContract.ownerOf(lootId) == msg.sender, "Not the owner of this Bloot");
1427         _safeMint(_msgSender(), lootId);
1428     }
1429 
1430     function multiMintWithBloot(uint256[] memory lootIds) public nonReentrant {
1431         for (uint256 i = 0; i < lootIds.length; i++) {
1432             require(lootContract.ownerOf(lootIds[i]) == msg.sender, "Not the owner of this Bloot");
1433             _safeMint(_msgSender(), lootIds[i]);
1434         }
1435     }
1436 
1437     function toString(uint256 value) internal pure returns (string memory) {
1438         // Inspired by OraclizeAPI's implementation - MIT license
1439         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1440 
1441         if (value == 0) {
1442             return "0";
1443         }
1444         uint256 temp = value;
1445         uint256 digits;
1446         while (temp != 0) {
1447             digits++;
1448             temp /= 10;
1449         }
1450         bytes memory buffer = new bytes(digits);
1451         while (value != 0) {
1452             digits -= 1;
1453             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1454             value /= 10;
1455         }
1456         return string(buffer);
1457     }
1458 
1459     constructor() ERC721("Bloot Dogg", "DOGG") Ownable() {}
1460 }
1461 
1462 /// [MIT License]
1463 /// @title Base64
1464 /// @notice Provides a function for encoding some bytes in base64
1465 /// @author Brecht Devos <brecht@loopring.org>
1466 library Base64 {
1467     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1468 
1469     /// @notice Encodes some bytes to the base64 representation
1470     function encode(bytes memory data) internal pure returns (string memory) {
1471         uint256 len = data.length;
1472         if (len == 0) return "";
1473 
1474         // multiply by 4/3 rounded up
1475         uint256 encodedLen = 4 * ((len + 2) / 3);
1476 
1477         // Add some extra buffer at the end
1478         bytes memory result = new bytes(encodedLen + 32);
1479 
1480         bytes memory table = TABLE;
1481 
1482         assembly {
1483             let tablePtr := add(table, 1)
1484             let resultPtr := add(result, 32)
1485 
1486             for {
1487                 let i := 0
1488             } lt(i, len) {
1489 
1490             } {
1491                 i := add(i, 3)
1492                 let input := and(mload(add(data, i)), 0xffffff)
1493 
1494                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1495                 out := shl(8, out)
1496                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1497                 out := shl(8, out)
1498                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1499                 out := shl(8, out)
1500                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1501                 out := shl(224, out)
1502 
1503                 mstore(resultPtr, out)
1504 
1505                 resultPtr := add(resultPtr, 4)
1506             }
1507 
1508             switch mod(len, 3)
1509             case 1 {
1510                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1511             }
1512             case 2 {
1513                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1514             }
1515 
1516             mstore(result, encodedLen)
1517         }
1518 
1519         return string(result);
1520     }
1521 }