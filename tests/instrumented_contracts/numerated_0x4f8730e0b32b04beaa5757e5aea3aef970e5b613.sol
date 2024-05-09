1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-03
3 */
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
1228 contract Bloot is ERC721Enumerable, ReentrancyGuard, Ownable {
1229 
1230     string[] private weapons = [
1231         "Shitpost",
1232         "Tweet",
1233         "Mint",
1234         "Ledger",
1235         "Hoodie",
1236         "Baguette",
1237         "Shillpost",
1238         "Pump",
1239         "Blockchain",
1240         "Empty Wallet",
1241         "JPEG",
1242         "Gas War",
1243         "gm Post",
1244         "DM",
1245         "Smart Contract",
1246         "Dumping",
1247         "Twitter Space",
1248         "Ban Hammer"
1249     ];
1250 
1251     string[] private chestArmor = [
1252         "Pleasure Robe",
1253         "Trippy Robe",
1254         "Unkempt Chest Hair",
1255         "Silver Nipple Rings",
1256         "Sweatstained Tank",
1257         "Pimp Coat",
1258         "Spacesuit",
1259         "Black Suit",
1260         "Super Rare Armor",
1261         "Foundational Cape",
1262         "Tattoed Chest",
1263         "Genesis Armor",
1264         "Mint Mink Coat",
1265         "Maxi Skirt",
1266         "Holy Pelt"
1267     ];
1268 
1269     string[] private headArmor = [
1270         "Propeller Cap",
1271         "3D Glasses",
1272         "Meta Mask",
1273         "Captain's Hat",
1274         "Top Hat",
1275         "Stringy Hair",
1276         "Smoking Pipe",
1277         "VR Goggles",
1278         "King's Crown",
1279         "Bald Fuck",
1280         "Holo Eyes",
1281         "Pizza Mouth",
1282         "Party Hat",
1283         "Dildohead"
1284     ];
1285 
1286     string[] private waistArmor = [
1287         "Leather Belt",
1288         "Girthy Root",
1289         "Diamond Sash",
1290         "Band",
1291         "Strap",
1292         "Loading Loop",
1293         "Golden Strap",
1294         "Torn Sash",
1295         "Double Strap",
1296         "Worn Loop",
1297         "Chastity Belt",
1298         "Sash",
1299         "Belt",
1300         "Spaghetti Sash",
1301         "Money Clip"
1302     ];
1303 
1304     string[] private footArmor = [
1305         "Shoes",
1306         "Dotted Kicks",
1307         "Dirty Shitkickers",
1308         "Troll Stompers",
1309         "Steeltoed Boots",
1310         "Floor Shoes",
1311         "Shitty Shoes",
1312         "Soggy Flipflops",
1313         "Rain Boots",
1314         "Moon Shoes",
1315         "Punk Kicks",
1316         "Laces",
1317         "Pumped Up Kicks"
1318     ];
1319 
1320     string[] private handArmor = [
1321         "Studded Gloves",
1322         "Diamond Hands",
1323         "Paper Hands",
1324         "Noodle Hands",
1325         "Weak Hands",
1326         "Twitter Fingers",
1327         "Henchmen Gloves",
1328         "Vitalik's Hands",
1329         "Tickler Hands",
1330         "Brass Knuckles",
1331         "Meta Mittens"
1332     ];
1333 
1334     string[] private necklaces = [
1335         "Pendant",
1336         "Chain",
1337         "Choker",
1338         "Trinket",
1339         "Ball Gag"
1340     ];
1341 
1342     string[] private rings = [
1343         "Cock Ring",
1344         "Lambo Key",
1345         "Gold Ring",
1346         "Ape Fur Ring",
1347         "Pixelated Band",
1348         "GFunk's Wedding Ring",
1349         "Ringer"
1350     ];
1351 
1352     string[] private suffixes = [
1353         "of Cope",
1354         "of FUD",
1355         "of Shit",
1356         "of Rage",
1357         "of Vitriol",
1358         "of Engagement Farming",
1359         "of NGMI",
1360         "of WAGMI",
1361         "of Rugging",
1362         "of HODL",
1363         "of FOMO",
1364         "of Gas",
1365         "of 1000 Troll Tears",
1366         "of Gains",
1367         "of Death",
1368         "of Fuck",
1369         "of Cock"
1370     ];
1371 
1372     string[] private namePrefixes = [
1373         "Pranksy",
1374         "Newfangled",
1375         "Meta",
1376         "Whale",
1377         "Ghxst",
1378         "Bagholder",
1379         "Moon",
1380         "Rekt",
1381         "Ape",
1382         "Yacht Club",
1383         "Punk",
1384         "Airdrop",
1385         "Bag",
1386         "DAO",
1387         "Degen",
1388         "DYOR",
1389         "ERC-721",
1390         "ERC-1155",
1391         "ERC-20",
1392         "NFT",
1393         "Rug Pull",
1394         "Dip",
1395         "Flippening",
1396         "Noob",
1397         "Bear",
1398         "Bull",
1399         "Maxi",
1400         "Art Block",
1401         "Legend",
1402         "Master",
1403         "Zombie",
1404         "Alien",
1405         "Goat",
1406         "XCOPY",
1407         "Cool Cat",
1408         "0N1",
1409         "Penguin",
1410         "VeeFriend",
1411         "MoonCat",
1412         "Autoglyph",
1413         "Skeleton",
1414         "Ass",
1415         "Penis",
1416         "Death",
1417         "Floor",
1418         "Ceiling",
1419         "Beanie",
1420         "Orrell",
1421         "tropoFarmer",
1422         "Boner",
1423         "Yeti",
1424         "Fidenza",
1425         "Chubby",
1426         "Cream",
1427         "Contract",
1428         "Manifold",
1429         "Axie Scholar",
1430         "Derivative",
1431         "King",
1432         "Queen",
1433         "Verification",
1434         "Pain",
1435         "Liquidity",
1436         "DeeZe",
1437         "GFunk"
1438     ];
1439 
1440     string[] private nameSuffixes = [
1441         "Whisper",
1442         "Dump",
1443         "Tear",
1444         "Bitch",
1445         "Moon",
1446         "Clench",
1447         "Jism",
1448         "Whimper",
1449         "Hell",
1450         "Sex",
1451         "Top",
1452         "Winter",
1453         "Capitulation",
1454         "Poor",
1455         "McDonald's"
1456     ];
1457 
1458     function random(string memory input) internal pure returns (uint256) {
1459         return uint256(keccak256(abi.encodePacked(input)));
1460     }
1461 
1462     function getWeapon(uint256 tokenId) public view returns (string memory) {
1463         return pluck(tokenId, "WEAPON", weapons);
1464     }
1465 
1466     function getChest(uint256 tokenId) public view returns (string memory) {
1467         return pluck(tokenId, "CHEST", chestArmor);
1468     }
1469 
1470     function getHead(uint256 tokenId) public view returns (string memory) {
1471         return pluck(tokenId, "HEAD", headArmor);
1472     }
1473 
1474     function getWaist(uint256 tokenId) public view returns (string memory) {
1475         return pluck(tokenId, "WAIST", waistArmor);
1476     }
1477 
1478     function getFoot(uint256 tokenId) public view returns (string memory) {
1479         return pluck(tokenId, "FOOT", footArmor);
1480     }
1481 
1482     function getHand(uint256 tokenId) public view returns (string memory) {
1483         return pluck(tokenId, "HAND", handArmor);
1484     }
1485 
1486     function getNeck(uint256 tokenId) public view returns (string memory) {
1487         return pluck(tokenId, "NECK", necklaces);
1488     }
1489 
1490     function getRing(uint256 tokenId) public view returns (string memory) {
1491         return pluck(tokenId, "RING", rings);
1492     }
1493 
1494     function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
1495         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1496         string memory output = sourceArray[rand % sourceArray.length];
1497         uint256 greatness = rand % 21;
1498         if (greatness > 14) {
1499             output = string(abi.encodePacked(output, " ", suffixes[rand % suffixes.length]));
1500         }
1501         if (greatness >= 19) {
1502             string[2] memory name;
1503             name[0] = namePrefixes[rand % namePrefixes.length];
1504             name[1] = nameSuffixes[rand % nameSuffixes.length];
1505             if (greatness == 19) {
1506                 output = string(abi.encodePacked('"', name[0], ' ', name[1], '" ', output));
1507             } else {
1508                 output = string(abi.encodePacked('"', name[0], ' ', name[1], '" ', output, " +1"));
1509             }
1510         }
1511         return output;
1512     }
1513 
1514     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1515         string[17] memory parts;
1516         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#01ff01" /><text x="10" y="20" class="base">';
1517 
1518         parts[1] = getWeapon(tokenId);
1519 
1520         parts[2] = '</text><text x="10" y="40" class="base">';
1521 
1522         parts[3] = getChest(tokenId);
1523 
1524         parts[4] = '</text><text x="10" y="60" class="base">';
1525 
1526         parts[5] = getHead(tokenId);
1527 
1528         parts[6] = '</text><text x="10" y="80" class="base">';
1529 
1530         parts[7] = getWaist(tokenId);
1531 
1532         parts[8] = '</text><text x="10" y="100" class="base">';
1533 
1534         parts[9] = getFoot(tokenId);
1535 
1536         parts[10] = '</text><text x="10" y="120" class="base">';
1537 
1538         parts[11] = getHand(tokenId);
1539 
1540         parts[12] = '</text><text x="10" y="140" class="base">';
1541 
1542         parts[13] = getNeck(tokenId);
1543 
1544         parts[14] = '</text><text x="10" y="160" class="base">';
1545 
1546         parts[15] = getRing(tokenId);
1547 
1548         parts[16] = '</text></svg>';
1549 
1550         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1551         output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
1552 
1553         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Bloot #', toString(tokenId), '", "description": "Bloot is basically worthless.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1554         output = string(abi.encodePacked('data:application/json;base64,', json));
1555 
1556         return output;
1557     }
1558 
1559     function claim(uint256 tokenId) public nonReentrant {
1560         require(tokenId > 0 && tokenId < 8009, "Token ID invalid");
1561         _safeMint(_msgSender(), tokenId);
1562     }
1563 
1564     function toString(uint256 value) internal pure returns (string memory) {
1565     // Inspired by OraclizeAPI's implementation - MIT license
1566     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1567 
1568         if (value == 0) {
1569             return "0";
1570         }
1571         uint256 temp = value;
1572         uint256 digits;
1573         while (temp != 0) {
1574             digits++;
1575             temp /= 10;
1576         }
1577         bytes memory buffer = new bytes(digits);
1578         while (value != 0) {
1579             digits -= 1;
1580             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1581             value /= 10;
1582         }
1583         return string(buffer);
1584     }
1585 
1586     constructor() ERC721("Bloot", "BLOOT") Ownable() {}
1587 }
1588 
1589 /// [MIT License]
1590 /// @title Base64
1591 /// @notice Provides a function for encoding some bytes in base64
1592 /// @author Brecht Devos <brecht@loopring.org>
1593 library Base64 {
1594     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1595 
1596     /// @notice Encodes some bytes to the base64 representation
1597     function encode(bytes memory data) internal pure returns (string memory) {
1598         uint256 len = data.length;
1599         if (len == 0) return "";
1600 
1601         // multiply by 4/3 rounded up
1602         uint256 encodedLen = 4 * ((len + 2) / 3);
1603 
1604         // Add some extra buffer at the end
1605         bytes memory result = new bytes(encodedLen + 32);
1606 
1607         bytes memory table = TABLE;
1608 
1609         assembly {
1610             let tablePtr := add(table, 1)
1611             let resultPtr := add(result, 32)
1612 
1613             for {
1614                 let i := 0
1615             } lt(i, len) {
1616 
1617             } {
1618                 i := add(i, 3)
1619                 let input := and(mload(add(data, i)), 0xffffff)
1620 
1621                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1622                 out := shl(8, out)
1623                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1624                 out := shl(8, out)
1625                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1626                 out := shl(8, out)
1627                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1628                 out := shl(224, out)
1629 
1630                 mstore(resultPtr, out)
1631 
1632                 resultPtr := add(resultPtr, 4)
1633             }
1634 
1635             switch mod(len, 3)
1636             case 1 {
1637                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1638             }
1639             case 2 {
1640                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1641             }
1642 
1643             mstore(result, encodedLen)
1644         }
1645 
1646         return string(result);
1647     }
1648 }