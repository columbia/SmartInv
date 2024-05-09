1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-31
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
626 
627 
628 
629 
630 
631 
632 
633 
634 /**
635  * @dev Implementation of the {IERC165} interface.
636  *
637  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
638  * for the additional interface id that will be supported. For example:
639  *
640  * ```solidity
641  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
642  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
643  * }
644  * ```
645  *
646  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
647  */
648 abstract contract ERC165 is IERC165 {
649     /**
650      * @dev See {IERC165-supportsInterface}.
651      */
652     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
653         return interfaceId == type(IERC165).interfaceId;
654     }
655 }
656 
657 
658 /**
659  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
660  * the Metadata extension, but not including the Enumerable extension, which is available separately as
661  * {ERC721Enumerable}.
662  */
663 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
664     using Address for address;
665     using Strings for uint256;
666 
667     // Token name
668     string private _name;
669 
670     // Token symbol
671     string private _symbol;
672 
673     // Mapping from token ID to owner address
674     mapping(uint256 => address) private _owners;
675 
676     // Mapping owner address to token count
677     mapping(address => uint256) private _balances;
678 
679     // Mapping from token ID to approved address
680     mapping(uint256 => address) private _tokenApprovals;
681 
682     // Mapping from owner to operator approvals
683     mapping(address => mapping(address => bool)) private _operatorApprovals;
684 
685     /**
686      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
687      */
688     constructor(string memory name_, string memory symbol_) {
689         _name = name_;
690         _symbol = symbol_;
691     }
692 
693     /**
694      * @dev See {IERC165-supportsInterface}.
695      */
696     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
697         return
698             interfaceId == type(IERC721).interfaceId ||
699             interfaceId == type(IERC721Metadata).interfaceId ||
700             super.supportsInterface(interfaceId);
701     }
702 
703     /**
704      * @dev See {IERC721-balanceOf}.
705      */
706     function balanceOf(address owner) public view virtual override returns (uint256) {
707         require(owner != address(0), "ERC721: balance query for the zero address");
708         return _balances[owner];
709     }
710 
711     /**
712      * @dev See {IERC721-ownerOf}.
713      */
714     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
715         address owner = _owners[tokenId];
716         require(owner != address(0), "ERC721: owner query for nonexistent token");
717         return owner;
718     }
719 
720     /**
721      * @dev See {IERC721Metadata-name}.
722      */
723     function name() public view virtual override returns (string memory) {
724         return _name;
725     }
726 
727     /**
728      * @dev See {IERC721Metadata-symbol}.
729      */
730     function symbol() public view virtual override returns (string memory) {
731         return _symbol;
732     }
733 
734     /**
735      * @dev See {IERC721Metadata-tokenURI}.
736      */
737     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
738         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
739 
740         string memory baseURI = _baseURI();
741         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
742     }
743 
744     /**
745      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
746      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
747      * by default, can be overriden in child contracts.
748      */
749     function _baseURI() internal view virtual returns (string memory) {
750         return "";
751     }
752 
753     /**
754      * @dev See {IERC721-approve}.
755      */
756     function approve(address to, uint256 tokenId) public virtual override {
757         address owner = ERC721.ownerOf(tokenId);
758         require(to != owner, "ERC721: approval to current owner");
759 
760         require(
761             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
762             "ERC721: approve caller is not owner nor approved for all"
763         );
764 
765         _approve(to, tokenId);
766     }
767 
768     /**
769      * @dev See {IERC721-getApproved}.
770      */
771     function getApproved(uint256 tokenId) public view virtual override returns (address) {
772         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
773 
774         return _tokenApprovals[tokenId];
775     }
776 
777     /**
778      * @dev See {IERC721-setApprovalForAll}.
779      */
780     function setApprovalForAll(address operator, bool approved) public virtual override {
781         require(operator != _msgSender(), "ERC721: approve to caller");
782 
783         _operatorApprovals[_msgSender()][operator] = approved;
784         emit ApprovalForAll(_msgSender(), operator, approved);
785     }
786 
787     /**
788      * @dev See {IERC721-isApprovedForAll}.
789      */
790     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
791         return _operatorApprovals[owner][operator];
792     }
793 
794     /**
795      * @dev See {IERC721-transferFrom}.
796      */
797     function transferFrom(
798         address from,
799         address to,
800         uint256 tokenId
801     ) public virtual override {
802         //solhint-disable-next-line max-line-length
803         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
804 
805         _transfer(from, to, tokenId);
806     }
807 
808     /**
809      * @dev See {IERC721-safeTransferFrom}.
810      */
811     function safeTransferFrom(
812         address from,
813         address to,
814         uint256 tokenId
815     ) public virtual override {
816         safeTransferFrom(from, to, tokenId, "");
817     }
818 
819     /**
820      * @dev See {IERC721-safeTransferFrom}.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId,
826         bytes memory _data
827     ) public virtual override {
828         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
829         _safeTransfer(from, to, tokenId, _data);
830     }
831 
832     /**
833      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
834      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
835      *
836      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
837      *
838      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
839      * implement alternative mechanisms to perform token transfer, such as signature-based.
840      *
841      * Requirements:
842      *
843      * - `from` cannot be the zero address.
844      * - `to` cannot be the zero address.
845      * - `tokenId` token must exist and be owned by `from`.
846      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
847      *
848      * Emits a {Transfer} event.
849      */
850     function _safeTransfer(
851         address from,
852         address to,
853         uint256 tokenId,
854         bytes memory _data
855     ) internal virtual {
856         _transfer(from, to, tokenId);
857         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
858     }
859 
860     /**
861      * @dev Returns whether `tokenId` exists.
862      *
863      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
864      *
865      * Tokens start existing when they are minted (`_mint`),
866      * and stop existing when they are burned (`_burn`).
867      */
868     function _exists(uint256 tokenId) internal view virtual returns (bool) {
869         return _owners[tokenId] != address(0);
870     }
871 
872     /**
873      * @dev Returns whether `spender` is allowed to manage `tokenId`.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      */
879     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
880         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
881         address owner = ERC721.ownerOf(tokenId);
882         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
883     }
884 
885     /**
886      * @dev Safely mints `tokenId` and transfers it to `to`.
887      *
888      * Requirements:
889      *
890      * - `tokenId` must not exist.
891      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _safeMint(address to, uint256 tokenId) internal virtual {
896         _safeMint(to, tokenId, "");
897     }
898 
899     /**
900      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
901      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
902      */
903     function _safeMint(
904         address to,
905         uint256 tokenId,
906         bytes memory _data
907     ) internal virtual {
908         _mint(to, tokenId);
909         require(
910             _checkOnERC721Received(address(0), to, tokenId, _data),
911             "ERC721: transfer to non ERC721Receiver implementer"
912         );
913     }
914 
915     /**
916      * @dev Mints `tokenId` and transfers it to `to`.
917      *
918      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
919      *
920      * Requirements:
921      *
922      * - `tokenId` must not exist.
923      * - `to` cannot be the zero address.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _mint(address to, uint256 tokenId) internal virtual {
928         require(to != address(0), "ERC721: mint to the zero address");
929         require(!_exists(tokenId), "ERC721: token already minted");
930 
931         _beforeTokenTransfer(address(0), to, tokenId);
932 
933         _balances[to] += 1;
934         _owners[tokenId] = to;
935 
936         emit Transfer(address(0), to, tokenId);
937     }
938 
939     /**
940      * @dev Destroys `tokenId`.
941      * The approval is cleared when the token is burned.
942      *
943      * Requirements:
944      *
945      * - `tokenId` must exist.
946      *
947      * Emits a {Transfer} event.
948      */
949     function _burn(uint256 tokenId) internal virtual {
950         address owner = ERC721.ownerOf(tokenId);
951 
952         _beforeTokenTransfer(owner, address(0), tokenId);
953 
954         // Clear approvals
955         _approve(address(0), tokenId);
956 
957         _balances[owner] -= 1;
958         delete _owners[tokenId];
959 
960         emit Transfer(owner, address(0), tokenId);
961     }
962 
963     /**
964      * @dev Transfers `tokenId` from `from` to `to`.
965      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
966      *
967      * Requirements:
968      *
969      * - `to` cannot be the zero address.
970      * - `tokenId` token must be owned by `from`.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _transfer(
975         address from,
976         address to,
977         uint256 tokenId
978     ) internal virtual {
979         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
980         require(to != address(0), "ERC721: transfer to the zero address");
981 
982         _beforeTokenTransfer(from, to, tokenId);
983 
984         // Clear approvals from the previous owner
985         _approve(address(0), tokenId);
986 
987         _balances[from] -= 1;
988         _balances[to] += 1;
989         _owners[tokenId] = to;
990 
991         emit Transfer(from, to, tokenId);
992     }
993 
994     /**
995      * @dev Approve `to` to operate on `tokenId`
996      *
997      * Emits a {Approval} event.
998      */
999     function _approve(address to, uint256 tokenId) internal virtual {
1000         _tokenApprovals[tokenId] = to;
1001         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1002     }
1003 
1004     /**
1005      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1006      * The call is not executed if the target address is not a contract.
1007      *
1008      * @param from address representing the previous owner of the given token ID
1009      * @param to target address that will receive the tokens
1010      * @param tokenId uint256 ID of the token to be transferred
1011      * @param _data bytes optional data to send along with the call
1012      * @return bool whether the call correctly returned the expected magic value
1013      */
1014     function _checkOnERC721Received(
1015         address from,
1016         address to,
1017         uint256 tokenId,
1018         bytes memory _data
1019     ) private returns (bool) {
1020         if (to.isContract()) {
1021             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1022                 return retval == IERC721Receiver(to).onERC721Received.selector;
1023             } catch (bytes memory reason) {
1024                 if (reason.length == 0) {
1025                     revert("ERC721: transfer to non ERC721Receiver implementer");
1026                 } else {
1027                     assembly {
1028                         revert(add(32, reason), mload(reason))
1029                     }
1030                 }
1031             }
1032         } else {
1033             return true;
1034         }
1035     }
1036 
1037     /**
1038      * @dev Hook that is called before any token transfer. This includes minting
1039      * and burning.
1040      *
1041      * Calling conditions:
1042      *
1043      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1044      * transferred to `to`.
1045      * - When `from` is zero, `tokenId` will be minted for `to`.
1046      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1047      * - `from` and `to` are never both zero.
1048      *
1049      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1050      */
1051     function _beforeTokenTransfer(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) internal virtual {}
1056 }
1057 
1058 /**
1059  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1060  * @dev See https://eips.ethereum.org/EIPS/eip-721
1061  */
1062 interface IERC721Enumerable is IERC721 {
1063     /**
1064      * @dev Returns the total amount of tokens stored by the contract.
1065      */
1066     function totalSupply() external view returns (uint256);
1067 
1068     /**
1069      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1070      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1071      */
1072     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1073 
1074     /**
1075      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1076      * Use along with {totalSupply} to enumerate all tokens.
1077      */
1078     function tokenByIndex(uint256 index) external view returns (uint256);
1079 }
1080 
1081 
1082 /**
1083  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1084  * enumerability of all the token ids in the contract as well as all token ids owned by each
1085  * account.
1086  */
1087 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1088     // Mapping from owner to list of owned token IDs
1089     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1090 
1091     // Mapping from token ID to index of the owner tokens list
1092     mapping(uint256 => uint256) private _ownedTokensIndex;
1093 
1094     // Array with all token ids, used for enumeration
1095     uint256[] private _allTokens;
1096 
1097     // Mapping from token id to position in the allTokens array
1098     mapping(uint256 => uint256) private _allTokensIndex;
1099 
1100     /**
1101      * @dev See {IERC165-supportsInterface}.
1102      */
1103     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1104         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1105     }
1106 
1107     /**
1108      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1109      */
1110     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1111         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1112         return _ownedTokens[owner][index];
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Enumerable-totalSupply}.
1117      */
1118     function totalSupply() public view virtual override returns (uint256) {
1119         return _allTokens.length;
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Enumerable-tokenByIndex}.
1124      */
1125     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1126         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1127         return _allTokens[index];
1128     }
1129 
1130     /**
1131      * @dev Hook that is called before any token transfer. This includes minting
1132      * and burning.
1133      *
1134      * Calling conditions:
1135      *
1136      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1137      * transferred to `to`.
1138      * - When `from` is zero, `tokenId` will be minted for `to`.
1139      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1140      * - `from` cannot be the zero address.
1141      * - `to` cannot be the zero address.
1142      *
1143      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1144      */
1145     function _beforeTokenTransfer(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) internal virtual override {
1150         super._beforeTokenTransfer(from, to, tokenId);
1151 
1152         if (from == address(0)) {
1153             _addTokenToAllTokensEnumeration(tokenId);
1154         } else if (from != to) {
1155             _removeTokenFromOwnerEnumeration(from, tokenId);
1156         }
1157         if (to == address(0)) {
1158             _removeTokenFromAllTokensEnumeration(tokenId);
1159         } else if (to != from) {
1160             _addTokenToOwnerEnumeration(to, tokenId);
1161         }
1162     }
1163 
1164     /**
1165      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1166      * @param to address representing the new owner of the given token ID
1167      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1168      */
1169     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1170         uint256 length = ERC721.balanceOf(to);
1171         _ownedTokens[to][length] = tokenId;
1172         _ownedTokensIndex[tokenId] = length;
1173     }
1174 
1175     /**
1176      * @dev Private function to add a token to this extension's token tracking data structures.
1177      * @param tokenId uint256 ID of the token to be added to the tokens list
1178      */
1179     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1180         _allTokensIndex[tokenId] = _allTokens.length;
1181         _allTokens.push(tokenId);
1182     }
1183 
1184     /**
1185      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1186      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1187      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1188      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1189      * @param from address representing the previous owner of the given token ID
1190      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1191      */
1192     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1193         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1194         // then delete the last slot (swap and pop).
1195 
1196         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1197         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1198 
1199         // When the token to delete is the last token, the swap operation is unnecessary
1200         if (tokenIndex != lastTokenIndex) {
1201             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1202 
1203             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1204             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1205         }
1206 
1207         // This also deletes the contents at the last position of the array
1208         delete _ownedTokensIndex[tokenId];
1209         delete _ownedTokens[from][lastTokenIndex];
1210     }
1211 
1212     /**
1213      * @dev Private function to remove a token from this extension's token tracking data structures.
1214      * This has O(1) time complexity, but alters the order of the _allTokens array.
1215      * @param tokenId uint256 ID of the token to be removed from the tokens list
1216      */
1217     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1218         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1219         // then delete the last slot (swap and pop).
1220 
1221         uint256 lastTokenIndex = _allTokens.length - 1;
1222         uint256 tokenIndex = _allTokensIndex[tokenId];
1223 
1224         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1225         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1226         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1227         uint256 lastTokenId = _allTokens[lastTokenIndex];
1228 
1229         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1230         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1231 
1232         // This also deletes the contents at the last position of the array
1233         delete _allTokensIndex[tokenId];
1234         _allTokens.pop();
1235     }
1236 }
1237 
1238 contract LootResources is ERC721Enumerable, ReentrancyGuard, Ownable {
1239     string[] private commonItems = [
1240         "planks of Wood",
1241         "bolts of Wool",
1242         "ingots of Iron",
1243         "blocks of Stone"
1244     ];
1245 
1246     string[] private limitedItems = [
1247         "hides of Leather",
1248         "bars of Steel",
1249         "bolts of Linen",
1250         "scrolls of Paper",
1251         "pieces of Bone"
1252     ];
1253 
1254     string[] private moreLimitedItems = [
1255         "bolts of Silk",
1256         "bars of Silver",
1257         "bars of Bronze"
1258     ];
1259 
1260     string[] private rareItems = [
1261         "bars of Platinum",
1262         "slugs of Titanium",
1263         "bolts of Brightsilk",
1264         "sheaths of Dragonskin",
1265         "slabs of Demonhide"
1266     ];
1267 
1268     string[] private moreRareItems = [    
1269         "vials of Divine Essence",
1270         "vials of Demon Blood",
1271         "vials of Solar Essense",
1272         "vials of Lunar Essense",
1273         "vials of Void Essence",
1274         "satchels of Eternal Gemstones",
1275         "vials of Distilled Ghost Vapor"
1276     ];
1277 
1278     ERC721 loot = ERC721(0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7);
1279 
1280     function withdraw() public onlyOwner {
1281         uint256 balance = address(this).balance;
1282         payable(msg.sender).transfer(balance);
1283     }
1284 
1285     function deposit() public payable onlyOwner {}
1286 
1287     function random(string memory input) internal pure returns (uint256) {
1288         return uint256(keccak256(abi.encodePacked(input)));
1289     }
1290 
1291     function getCommon(uint256 tokenId) public view returns (string memory) {
1292         return pluck(tokenId, "COMMON", commonItems, 150, 200);
1293     }
1294 
1295     function getLimited(uint256 tokenId) public view returns (string memory) {
1296         return pluck(tokenId, "LIMITED", limitedItems, 75, 100);
1297     }
1298 
1299     function getMoreLimited(uint256 tokenId) public view returns (string memory) {
1300         return pluck(tokenId, "MORELIMITED", moreLimitedItems, 20, 50);
1301     }
1302 
1303     function getRare(uint256 tokenId) public view returns (string memory) {
1304         return pluck(tokenId, "RARE", rareItems, 10, 25);
1305     }
1306 
1307     function getMoreRare(uint256 tokenId) public view returns (string memory) {
1308         return pluck(tokenId, "MORERARE", moreRareItems, 2, 6);
1309     }
1310 
1311     function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray, uint256 minQuantity, uint256 maxQuantity) internal pure returns (string memory) {
1312         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1313         uint256 quantity = (rand % (maxQuantity-minQuantity)) + minQuantity;
1314 
1315         uint256 luckRand = random(string(abi.encodePacked("LUCKY?", toString(tokenId))));
1316         bool lucky = (luckRand % 100) == 42;
1317         if (lucky) {
1318             quantity = 3*quantity;
1319         }
1320 
1321         string memory resource = sourceArray[rand % sourceArray.length];
1322         string memory output = string(abi.encodePacked(toString(quantity), " ", resource));
1323         return output;
1324     }
1325 
1326     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1327         string[13] memory parts;
1328         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
1329 
1330         parts[1] = getCommon(tokenId);
1331 
1332         parts[2] = '</text><text x="10" y="40" class="base">';
1333 
1334         parts[3] = getLimited(tokenId);
1335 
1336         parts[4] = '</text><text x="10" y="60" class="base">';
1337 
1338         parts[5] = getMoreLimited(tokenId);
1339 
1340         parts[6] = '</text><text x="10" y="80" class="base">';
1341 
1342         parts[7] = getRare(tokenId);
1343 
1344         parts[8] = '</text><text x="10" y="100" class="base">';
1345 
1346         parts[9] = getMoreRare(tokenId);
1347 
1348         parts[10] = '</text></svg>';
1349 
1350         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1351         output = string(abi.encodePacked(output, parts[9], parts[10]));
1352         
1353         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Pack #', toString(tokenId), '", "description": "Randomized collections of resources for adventurers generated and stored on chain. Feel free to use Resources in any way you want.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1354         output = string(abi.encodePacked('data:application/json;base64,', json));
1355 
1356         return output;
1357     }
1358 
1359     function claim(uint256 tokenId) public nonReentrant {
1360         require(tokenId > 8000 && tokenId < 9576, "Token ID invalid");
1361         _safeMint(_msgSender(), tokenId);
1362     }
1363    
1364     function claimForLoot(uint256 tokenId) public nonReentrant {
1365         require(tokenId > 0 && tokenId < 8001, "Token ID invalid");
1366         require(loot.ownerOf(tokenId) == msg.sender, "Not Loot owner");
1367         _safeMint(_msgSender(), tokenId);
1368     }
1369     
1370     function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
1371         require(tokenId > 9575 && tokenId < 10001, "Token ID invalid");
1372         _safeMint(owner(), tokenId);
1373     }
1374     
1375     function toString(uint256 value) internal pure returns (string memory) {
1376     // Inspired by OraclizeAPI's implementation - MIT license
1377     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1378 
1379         if (value == 0) {
1380             return "0";
1381         }
1382         uint256 temp = value;
1383         uint256 digits;
1384         while (temp != 0) {
1385             digits++;
1386             temp /= 10;
1387         }
1388         bytes memory buffer = new bytes(digits);
1389         while (value != 0) {
1390             digits -= 1;
1391             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1392             value /= 10;
1393         }
1394         return string(buffer);
1395     }
1396     
1397     constructor() ERC721("Resources for Adventurers", "RESC") Ownable() {}
1398 }
1399 
1400 /// [MIT License]
1401 /// @title Base64
1402 /// @notice Provides a function for encoding some bytes in base64
1403 /// @author Brecht Devos <brecht@loopring.org>
1404 library Base64 {
1405     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1406 
1407     /// @notice Encodes some bytes to the base64 representation
1408     function encode(bytes memory data) internal pure returns (string memory) {
1409         uint256 len = data.length;
1410         if (len == 0) return "";
1411 
1412         // multiply by 4/3 rounded up
1413         uint256 encodedLen = 4 * ((len + 2) / 3);
1414 
1415         // Add some extra buffer at the end
1416         bytes memory result = new bytes(encodedLen + 32);
1417 
1418         bytes memory table = TABLE;
1419 
1420         assembly {
1421             let tablePtr := add(table, 1)
1422             let resultPtr := add(result, 32)
1423 
1424             for {
1425                 let i := 0
1426             } lt(i, len) {
1427 
1428             } {
1429                 i := add(i, 3)
1430                 let input := and(mload(add(data, i)), 0xffffff)
1431 
1432                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1433                 out := shl(8, out)
1434                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1435                 out := shl(8, out)
1436                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1437                 out := shl(8, out)
1438                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1439                 out := shl(224, out)
1440 
1441                 mstore(resultPtr, out)
1442 
1443                 resultPtr := add(resultPtr, 4)
1444             }
1445 
1446             switch mod(len, 3)
1447             case 1 {
1448                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1449             }
1450             case 2 {
1451                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1452             }
1453 
1454             mstore(result, encodedLen)
1455         }
1456 
1457         return string(result);
1458     }
1459 }