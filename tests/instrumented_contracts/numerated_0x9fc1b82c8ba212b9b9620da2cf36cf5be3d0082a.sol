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
1228 contract BlootGirls is ERC721Enumerable, ReentrancyGuard, Ownable {
1229 
1230     
1231     string[] private weapons = [
1232         "Shitpost",
1233         "Tweet",
1234         "Mint",
1235         "Ledger",
1236         "BF's Hoodie",
1237         "PMS",
1238         "Shillpost",
1239         "Pump",
1240         "Blockchain",
1241         "Empty Wallet",
1242         "JPEG",
1243         "Catfish"
1244         "Gas War",
1245         "Selfie Stick",
1246         "gm Post",
1247         "HODL Post",
1248         "Mental Health Post",
1249         "DM",
1250         "Botox",
1251         "Lip Filler",
1252         "White Nail Polish",
1253         "Smart Contract",
1254         "Dumping",
1255        "Block Button",
1256         "Lipgloss",
1257         "Lipstick",
1258         "Twitter Space",
1259         "Crocodile Tears",
1260         "Block Button",
1261         "Bathroom Selfie"
1262     ];
1263 
1264     string[] private chestArmor = [
1265         "Pleasure Robe",
1266         "Freakum Dress",
1267         "Unkempt Boob Hair",
1268         "Silver Nipple Rings",
1269         "Sweatstained Bra",
1270         "Pimp Coat",
1271         "Bodysuit",
1272         "LBD",
1273         "Super Rare Armor",
1274         "Foundational Corset",
1275         "Tramp Stamp Tattoo",
1276         "Genesis Armor",
1277         "Mint Mink Coat",
1278         "Nude Nails",
1279         "Mini Skirt",
1280         "Crop Top",
1281         "Tie-Dye T-Shirt"
1282       
1283     ];
1284 
1285     string[] private headArmor = [
1286         "Beanie's Propeller Cap",
1287         "Messy Bun",
1288         "Head Band"
1289         "3D Glasses",
1290         "Meta Mask",
1291         "Nurse's Hat",
1292         "Tiara Crown",
1293         "Stringy Hair",
1294         "Bald Cap",
1295         "Wig",
1296         "VR Goggles",
1297         "Queen's Crown",
1298         "Fedora",
1299         "Holo Eyes",
1300         "Duck Lips",
1301         "Pizza Mouth",
1302         "Floppy Hat",
1303         "Party Hat",
1304         "Bonnet",
1305         "Dildohead"
1306     ];
1307 
1308     string[] private waistArmor = [
1309         "Leather Belt",
1310         "Waist Trainer",
1311         "Swarovski Sash",
1312         "Band",
1313         "Strap",
1314         "Beauty Queen Sash",
1315         "Golden Strap",
1316         "Torn Sash",
1317         "Double Strap",
1318         "Worn Loop",
1319         "Chastity Belt",
1320         "Sash",
1321         "Belt",
1322         "Spaghetti Strap",
1323         "Money Clip",
1324         "Garter Belt"
1325     ];
1326 
1327     string[] private footArmor = [
1328         "Shoes",
1329         "Red Bottoms",
1330         "Dirty Kitten Heels",
1331         "Troll Stompers",
1332         "Knee-High Boots",
1333         "Filthy Feet",
1334         "10-inch Pleasers",
1335         "Soggy Flipflops",
1336         "Rain Boots",
1337         "Moon Shoes",
1338         "Perspex Heels",
1339         "Stilettos",
1340         "Pumped Up Kicks",
1341         "Overgrown Toe Sandals", 
1342         "Princess Ballet Flats"
1343     ];
1344 
1345     string[] private handArmor = [
1346         "Studded Gloves",
1347         "Diamond Hands",
1348         "Paper Hands",
1349         "Noodle Hands",
1350         "Weak Hands",
1351         "Dominatrix Whip",
1352         "Twitter Fingers",
1353         "Kitty Gloves",
1354         "Vitalik's Hands",
1355         "Tickler Hands",
1356         "Bitch Slap",
1357         "Meta Mittens"
1358     ];
1359 
1360     string[] private necklaces = [
1361         "Pendant",
1362         "Chain",
1363         "Choker",
1364         "Trinket",
1365         "Pearl necklace",
1366         "Titty Teaser"
1367     ];
1368 
1369     string[] private rings = [
1370         "Titty Ring",
1371         "Lambo Key",
1372         "Diamond Ring",
1373         "Placenta Ring",
1374         "Pixelated Band",
1375         "tropoFarmer's Wedding Ring",
1376         "Ringer"
1377     ];
1378 
1379     string[] private suffixes = [
1380         "of Cope",
1381         "of FUD",
1382         "of Shit",
1383         "of Rage",
1384         "of Pumpkin Spice",
1385         "of Engagement Farming",
1386         "of NGMI",
1387         "of WAGMI",
1388         "of GNO",
1389         "of Rugging",
1390         "of HODL",
1391         "of FOMO",
1392         "of Gas",
1393         "of Cat Ladies",
1394         "of 1000 Troll Tears",
1395         "of Gains",
1396         "of Death",
1397         "of Tits",
1398         "of Qweef",
1399         "of Cock"
1400         "of Bloot Booty"
1401     ];
1402 
1403     string[] private namePrefixes = [
1404         "Beanie",
1405         "Coffee",
1406         "Meta",
1407         "Whale",
1408         "Ghxst",
1409         "Bagholder",
1410         "Moon",
1411         "Online Shopping"
1412        "Window Shopping"
1413         "Rekt",
1414         "Ape",
1415         "Yacht Club",
1416         "Punk",
1417         "Hot Water Bottle",
1418         "Airdrop",
1419         "Bag",
1420         "DAO",
1421         "Degen",
1422         "Mansplaining",
1423         "DYOR",
1424         "Red Wine",
1425         "Ros%C3%A9",
1426         "NFT",
1427         "Rug Pull",
1428         "Dip",
1429         "ERC-721",
1430         "ERC-1155",
1431         "ERC-20",
1432         "Furbie",
1433         "Flippening",
1434         "Noob",
1435         "Bear",
1436         "Bull",
1437         "Maxi",
1438         "Art Block",
1439         "Legend",
1440         "Master",
1441         "Zombie",
1442         "Alien",
1443         "Goat",
1444         "Boob",
1445         "Doge",
1446         "Sorority",
1447         "Cool Cat",
1448         "0N1",
1449         "Penguin",
1450         "VeeFriend",
1451         "Farokh",
1452         "Hot Cocoa",
1453         "Skeleton",
1454         "Ass",
1455         "Greg",
1456         "Dylan",
1457         "Death",
1458         "Floor",
1459         "Ceiling",
1460         "Hunter",
1461         "Orrell",
1462         "tropoFarmer",
1463         "Boner",
1464         "Yeti",
1465         "Fidenza",
1466         "OhhShiny",
1467         "Cream",
1468         "Contract",
1469         "Scented Candles",
1470         "AxieKing",
1471         "Derivative",
1472         "King",
1473         "Queen",
1474         "Verification",
1475         "Pain",
1476         "Liquidity",
1477         "DeeZe",
1478         "tropoFarmer"
1479     ];
1480 
1481     string[] private nameSuffixes = [
1482         "Whisper",
1483         "Dump",
1484         "Tear",
1485         "Bitch",
1486         "Moon",
1487         "Clench",
1488         "Jism",
1489        "Kegel",
1490         "Whimper",
1491         "Hell",
1492         "Sex",
1493         "Top",
1494         "Winter",
1495         "Capitulation",
1496         "Diet",
1497         "Starbucks",
1498         "McDonald's"
1499     ];
1500 
1501     function random(string memory input) internal pure returns (uint256) {
1502         return uint256(keccak256(abi.encodePacked(input)));
1503     }
1504 
1505     function getWeapon(uint256 tokenId) public view returns (string memory) {
1506         return pluck(tokenId, "WEAPON", weapons);
1507     }
1508 
1509     function getChest(uint256 tokenId) public view returns (string memory) {
1510         return pluck(tokenId, "CHEST", chestArmor);
1511     }
1512 
1513     function getHead(uint256 tokenId) public view returns (string memory) {
1514         return pluck(tokenId, "HEAD", headArmor);
1515     }
1516 
1517     function getWaist(uint256 tokenId) public view returns (string memory) {
1518         return pluck(tokenId, "WAIST", waistArmor);
1519     }
1520 
1521     function getFoot(uint256 tokenId) public view returns (string memory) {
1522         return pluck(tokenId, "FOOT", footArmor);
1523     }
1524 
1525     function getHand(uint256 tokenId) public view returns (string memory) {
1526         return pluck(tokenId, "HAND", handArmor);
1527     }
1528 
1529     function getNeck(uint256 tokenId) public view returns (string memory) {
1530         return pluck(tokenId, "NECK", necklaces);
1531     }
1532 
1533     function getRing(uint256 tokenId) public view returns (string memory) {
1534         return pluck(tokenId, "RING", rings);
1535     }
1536 
1537     function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
1538         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1539         string memory output = sourceArray[rand % sourceArray.length];
1540         uint256 greatness = rand % 21;
1541         if (greatness > 14) {
1542             output = string(abi.encodePacked(output, " ", suffixes[rand % suffixes.length]));
1543         }
1544         if (greatness >= 19) {
1545             string[2] memory name;
1546             name[0] = namePrefixes[rand % namePrefixes.length];
1547             name[1] = nameSuffixes[rand % nameSuffixes.length];
1548             if (greatness == 19) {
1549                 output = string(abi.encodePacked('"', name[0], ' ', name[1], '" ', output));
1550             } else {
1551                 output = string(abi.encodePacked('"', name[0], ' ', name[1], '" ', output, " +1"));
1552             }
1553         }
1554         return output;
1555     }
1556 
1557     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1558         string[17] memory parts;
1559         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#01ff01" /><text x="10" y="20" class="base">';
1560 
1561         parts[1] = getWeapon(tokenId);
1562 
1563         parts[2] = '</text><text x="10" y="40" class="base">';
1564 
1565         parts[3] = getChest(tokenId);
1566 
1567         parts[4] = '</text><text x="10" y="60" class="base">';
1568 
1569         parts[5] = getHead(tokenId);
1570 
1571         parts[6] = '</text><text x="10" y="80" class="base">';
1572 
1573         parts[7] = getWaist(tokenId);
1574 
1575         parts[8] = '</text><text x="10" y="100" class="base">';
1576 
1577         parts[9] = getFoot(tokenId);
1578 
1579         parts[10] = '</text><text x="10" y="120" class="base">';
1580 
1581         parts[11] = getHand(tokenId);
1582 
1583         parts[12] = '</text><text x="10" y="140" class="base">';
1584 
1585         parts[13] = getNeck(tokenId);
1586 
1587         parts[14] = '</text><text x="10" y="160" class="base">';
1588 
1589         parts[15] = getRing(tokenId);
1590 
1591         parts[16] = '</text></svg>';
1592 
1593         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1594         output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
1595 
1596         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Bloot Girl #', toString(tokenId), '", "description": "It\'s basically worthless Bloots of Women. 20% goes to a fund to support NFT creators and help pay their gas fees etc. (Bloot Girls holders get preference).", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1597         output = string(abi.encodePacked('data:application/json;base64,', json));
1598 
1599         return output;
1600     }
1601 
1602     function claim(uint256 tokenId) public nonReentrant {
1603         require(tokenId > 0 && tokenId < 8009, "Token ID invalid");
1604         _safeMint(_msgSender(), tokenId);
1605     }
1606 
1607     function toString(uint256 value) internal pure returns (string memory) {
1608     // Inspired by OraclizeAPI's implementation - MIT license
1609     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1610 
1611         if (value == 0) {
1612             return "0";
1613         }
1614         uint256 temp = value;
1615         uint256 digits;
1616         while (temp != 0) {
1617             digits++;
1618             temp /= 10;
1619         }
1620         bytes memory buffer = new bytes(digits);
1621         while (value != 0) {
1622             digits -= 1;
1623             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1624             value /= 10;
1625         }
1626         return string(buffer);
1627     }
1628 
1629     constructor() ERC721("Bloot Girls", "BGIRLS") Ownable() {}
1630 }
1631 
1632 /// [MIT License]
1633 /// @title Base64
1634 /// @notice Provides a function for encoding some bytes in base64
1635 /// @author Brecht Devos <brecht@loopring.org>
1636 library Base64 {
1637     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1638 
1639     /// @notice Encodes some bytes to the base64 representation
1640     function encode(bytes memory data) internal pure returns (string memory) {
1641         uint256 len = data.length;
1642         if (len == 0) return "";
1643 
1644         // multiply by 4/3 rounded up
1645         uint256 encodedLen = 4 * ((len + 2) / 3);
1646 
1647         // Add some extra buffer at the end
1648         bytes memory result = new bytes(encodedLen + 32);
1649 
1650         bytes memory table = TABLE;
1651 
1652         assembly {
1653             let tablePtr := add(table, 1)
1654             let resultPtr := add(result, 32)
1655 
1656             for {
1657                 let i := 0
1658             } lt(i, len) {
1659 
1660             } {
1661                 i := add(i, 3)
1662                 let input := and(mload(add(data, i)), 0xffffff)
1663 
1664                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1665                 out := shl(8, out)
1666                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1667                 out := shl(8, out)
1668                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1669                 out := shl(8, out)
1670                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1671                 out := shl(224, out)
1672 
1673                 mstore(resultPtr, out)
1674 
1675                 resultPtr := add(resultPtr, 4)
1676             }
1677 
1678             switch mod(len, 3)
1679             case 1 {
1680                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1681             }
1682             case 2 {
1683                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1684             }
1685 
1686             mstore(result, encodedLen)
1687         }
1688 
1689         return string(result);
1690     }
1691 }