1 // SPDX-License-Identifier: MIT'
2 
3 /**
4  * Adds the following layers onto the existing LOOT system.
5  * - Certain Realms as Origin City for your Token ID (chosen from 5% of existing minted realm names + citizenship status chosen from 5 rarities).
6  * - Origin Story.
7  * - Race (Same as existing  Character races, but with rarities).
8  * - Profession (Ranked between 5 rarities).
9  * - Alignment (Chosen from the 9 alignments).
10  * - Age (18 - 109).
11  * - Pantheon (Chosen from lore-friendly DnD pantheons).
12  * - Gods / Divinity (Ranked between 5 rarities).
13  */
14 
15 pragma solidity ^0.8.0;
16 
17 interface IERC165 {
18     function supportsInterface(bytes4 interfaceId) external view returns (bool);
19 }
20 
21 /**
22  * @dev Required interface of an ERC721 compliant contract.
23  */
24 interface IERC721 is IERC165 {
25     /**
26      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
27      */
28     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
29 
30     /**
31      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
32      */
33     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
34 
35     /**
36      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
37      */
38     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
39 
40     /**
41      * @dev Returns the number of tokens in ``owner``'s account.
42      */
43     function balanceOf(address owner) external view returns (uint256 balance);
44 
45     /**
46      * @dev Returns the owner of the `tokenId` token.
47      *
48      * Requirements:
49      *
50      * - `tokenId` must exist.
51      */
52     function ownerOf(uint256 tokenId) external view returns (address owner);
53 
54     /**
55      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
56      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
57      *
58      * Requirements:
59      *
60      * - `from` cannot be the zero address.
61      * - `to` cannot be the zero address.
62      * - `tokenId` token must exist and be owned by `from`.
63      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
64      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
65      *
66      * Emits a {Transfer} event.
67      */
68     function safeTransferFrom(
69         address from,
70         address to,
71         uint256 tokenId
72     ) external;
73 
74     /**
75      * @dev Transfers `tokenId` token from `from` to `to`.
76      *
77      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
78      *
79      * Requirements:
80      *
81      * - `from` cannot be the zero address.
82      * - `to` cannot be the zero address.
83      * - `tokenId` token must be owned by `from`.
84      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(
89         address from,
90         address to,
91         uint256 tokenId
92     ) external;
93 
94     /**
95      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
96      * The approval is cleared when the token is transferred.
97      *
98      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
99      *
100      * Requirements:
101      *
102      * - The caller must own the token or be an approved operator.
103      * - `tokenId` must exist.
104      *
105      * Emits an {Approval} event.
106      */
107     function approve(address to, uint256 tokenId) external;
108 
109     /**
110      * @dev Returns the account approved for `tokenId` token.
111      *
112      * Requirements:
113      *
114      * - `tokenId` must exist.
115      */
116     function getApproved(uint256 tokenId) external view returns (address operator);
117 
118     /**
119      * @dev Approve or remove `operator` as an operator for the caller.
120      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
121      *
122      * Requirements:
123      *
124      * - The `operator` cannot be the caller.
125      *
126      * Emits an {ApprovalForAll} event.
127      */
128     function setApprovalForAll(address operator, bool _approved) external;
129 
130     /**
131      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
132      *
133      * See {setApprovalForAll}
134      */
135     function isApprovedForAll(address owner, address operator) external view returns (bool);
136 
137     /**
138      * @dev Safely transfers `tokenId` token from `from` to `to`.
139      *
140      * Requirements:
141      *
142      * - `from` cannot be the zero address.
143      * - `to` cannot be the zero address.
144      * - `tokenId` token must exist and be owned by `from`.
145      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
146      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
147      *
148      * Emits a {Transfer} event.
149      */
150     function safeTransferFrom(
151         address from,
152         address to,
153         uint256 tokenId,
154         bytes calldata data
155     ) external;
156 }
157 
158 
159 
160 
161 /**
162  * @dev String operations.
163  */
164 library Strings {
165     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
166 
167     /**
168      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
169      */
170     function toString(uint256 value) internal pure returns (string memory) {
171         // Inspired by OraclizeAPI's implementation - MIT licence
172         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
173 
174         if (value == 0) {
175             return "0";
176         }
177         uint256 temp = value;
178         uint256 digits;
179         while (temp != 0) {
180             digits++;
181             temp /= 10;
182         }
183         bytes memory buffer = new bytes(digits);
184         while (value != 0) {
185             digits -= 1;
186             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
187             value /= 10;
188         }
189         return string(buffer);
190     }
191 
192     /**
193      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
194      */
195     function toHexString(uint256 value) internal pure returns (string memory) {
196         if (value == 0) {
197             return "0x00";
198         }
199         uint256 temp = value;
200         uint256 length = 0;
201         while (temp != 0) {
202             length++;
203             temp >>= 8;
204         }
205         return toHexString(value, length);
206     }
207 
208     /**
209      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
210      */
211     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
212         bytes memory buffer = new bytes(2 * length + 2);
213         buffer[0] = "0";
214         buffer[1] = "x";
215         for (uint256 i = 2 * length + 1; i > 1; --i) {
216             buffer[i] = _HEX_SYMBOLS[value & 0xf];
217             value >>= 4;
218         }
219         require(value == 0, "Strings: hex length insufficient");
220         return string(buffer);
221     }
222 }
223 
224 
225 
226 
227 /*
228  * @dev Provides information about the current execution context, including the
229  * sender of the transaction and its data. While these are generally available
230  * via msg.sender and msg.data, they should not be accessed in such a direct
231  * manner, since when dealing with meta-transactions the account sending and
232  * paying for execution may not be the actual sender (as far as an application
233  * is concerned).
234  *
235  * This contract is only required for intermediate, library-like contracts.
236  */
237 abstract contract Context {
238     function _msgSender() internal view virtual returns (address) {
239         return msg.sender;
240     }
241 
242     function _msgData() internal view virtual returns (bytes calldata) {
243         return msg.data;
244     }
245 }
246 
247 
248 
249 
250 
251 
252 
253 
254 
255 /**
256  * @dev Contract module which provides a basic access control mechanism, where
257  * there is an account (an owner) that can be granted exclusive access to
258  * specific functions.
259  *
260  * By default, the owner account will be the one that deploys the contract. This
261  * can later be changed with {transferOwnership}.
262  *
263  * This module is used through inheritance. It will make available the modifier
264  * `onlyOwner`, which can be applied to your functions to restrict their use to
265  * the owner.
266  */
267 abstract contract Ownable is Context {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor() {
276         _setOwner(_msgSender());
277     }
278 
279     /**
280      * @dev Returns the address of the current owner.
281      */
282     function owner() public view virtual returns (address) {
283         return _owner;
284     }
285 
286     /**
287      * @dev Throws if called by any account other than the owner.
288      */
289     modifier onlyOwner() {
290         require(owner() == _msgSender(), "Ownable: caller is not the owner");
291         _;
292     }
293 
294     /**
295      * @dev Leaves the contract without owner. It will not be possible to call
296      * `onlyOwner` functions anymore. Can only be called by the current owner.
297      *
298      * NOTE: Renouncing ownership will leave the contract without an owner,
299      * thereby removing any functionality that is only available to the owner.
300      */
301     function renounceOwnership() public virtual onlyOwner {
302         _setOwner(address(0));
303     }
304 
305     /**
306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
307      * Can only be called by the current owner.
308      */
309     function transferOwnership(address newOwner) public virtual onlyOwner {
310         require(newOwner != address(0), "Ownable: new owner is the zero address");
311         _setOwner(newOwner);
312     }
313 
314     function _setOwner(address newOwner) private {
315         address oldOwner = _owner;
316         _owner = newOwner;
317         emit OwnershipTransferred(oldOwner, newOwner);
318     }
319 }
320 
321 
322 
323 
324 
325 /**
326  * @dev Contract module that helps prevent reentrant calls to a function.
327  *
328  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
329  * available, which can be applied to functions to make sure there are no nested
330  * (reentrant) calls to them.
331  *
332  * Note that because there is a single `nonReentrant` guard, functions marked as
333  * `nonReentrant` may not call one another. This can be worked around by making
334  * those functions `private`, and then adding `external` `nonReentrant` entry
335  * points to them.
336  *
337  * TIP: If you would like to learn more about reentrancy and alternative ways
338  * to protect against it, check out our blog post
339  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
340  */
341 abstract contract ReentrancyGuard {
342     // Booleans are more expensive than uint256 or any type that takes up a full
343     // word because each write operation emits an extra SLOAD to first read the
344     // slot's contents, replace the bits taken up by the boolean, and then write
345     // back. This is the compiler's defense against contract upgrades and
346     // pointer aliasing, and it cannot be disabled.
347 
348     // The values being non-zero value makes deployment a bit more expensive,
349     // but in exchange the refund on every call to nonReentrant will be lower in
350     // amount. Since refunds are capped to a percentage of the total
351     // transaction's gas, it is best to keep them low in cases like this one, to
352     // increase the likelihood of the full refund coming into effect.
353     uint256 private constant _NOT_ENTERED = 1;
354     uint256 private constant _ENTERED = 2;
355 
356     uint256 private _status;
357 
358     constructor() {
359         _status = _NOT_ENTERED;
360     }
361 
362     /**
363      * @dev Prevents a contract from calling itself, directly or indirectly.
364      * Calling a `nonReentrant` function from another `nonReentrant`
365      * function is not supported. It is possible to prevent this from happening
366      * by making the `nonReentrant` function external, and make it call a
367      * `private` function that does the actual work.
368      */
369     modifier nonReentrant() {
370         // On the first call to nonReentrant, _notEntered will be true
371         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
372 
373         // Any calls to nonReentrant after this point will fail
374         _status = _ENTERED;
375 
376         _;
377 
378         // By storing the original value once again, a refund is triggered (see
379         // https://eips.ethereum.org/EIPS/eip-2200)
380         _status = _NOT_ENTERED;
381     }
382 }
383 
384 
385 
386 
387 
388 
389 
390 
391 
392 
393 
394 
395 
396 
397 /**
398  * @title ERC721 token receiver interface
399  * @dev Interface for any contract that wants to support safeTransfers
400  * from ERC721 asset contracts.
401  */
402 interface IERC721Receiver {
403     /**
404      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
405      * by `operator` from `from`, this function is called.
406      *
407      * It must return its Solidity selector to confirm the token transfer.
408      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
409      *
410      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
411      */
412     function onERC721Received(
413         address operator,
414         address from,
415         uint256 tokenId,
416         bytes calldata data
417     ) external returns (bytes4);
418 }
419 
420 
421 
422 
423 
424 
425 
426 /**
427  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
428  * @dev See https://eips.ethereum.org/EIPS/eip-721
429  */
430 interface IERC721Metadata is IERC721 {
431     /**
432      * @dev Returns the token collection name.
433      */
434     function name() external view returns (string memory);
435 
436     /**
437      * @dev Returns the token collection symbol.
438      */
439     function symbol() external view returns (string memory);
440 
441     /**
442      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
443      */
444     function tokenURI(uint256 tokenId) external view returns (string memory);
445 }
446 
447 
448 
449 
450 
451 /**
452  * @dev Collection of functions related to the address type
453  */
454 library Address {
455     /**
456      * @dev Returns true if `account` is a contract.
457      *
458      * [IMPORTANT]
459      * ====
460      * It is unsafe to assume that an address for which this function returns
461      * false is an externally-owned account (EOA) and not a contract.
462      *
463      * Among others, `isContract` will return false for the following
464      * types of addresses:
465      *
466      *  - an externally-owned account
467      *  - a contract in construction
468      *  - an address where a contract will be created
469      *  - an address where a contract lived, but was destroyed
470      * ====
471      */
472     function isContract(address account) internal view returns (bool) {
473         // This method relies on extcodesize, which returns 0 for contracts in
474         // construction, since the code is only stored at the end of the
475         // constructor execution.
476 
477         uint256 size;
478         assembly {
479             size := extcodesize(account)
480         }
481         return size > 0;
482     }
483 
484     /**
485      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
486      * `recipient`, forwarding all available gas and reverting on errors.
487      *
488      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
489      * of certain opcodes, possibly making contracts go over the 2300 gas limit
490      * imposed by `transfer`, making them unable to receive funds via
491      * `transfer`. {sendValue} removes this limitation.
492      *
493      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
494      *
495      * IMPORTANT: because control is transferred to `recipient`, care must be
496      * taken to not create reentrancy vulnerabilities. Consider using
497      * {ReentrancyGuard} or the
498      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
499      */
500     function sendValue(address payable recipient, uint256 amount) internal {
501         require(address(this).balance >= amount, "Address: insufficient balance");
502 
503         (bool success, ) = recipient.call{value: amount}("");
504         require(success, "Address: unable to send value, recipient may have reverted");
505     }
506 
507     /**
508      * @dev Performs a Solidity function call using a low level `call`. A
509      * plain `call` is an unsafe replacement for a function call: use this
510      * function instead.
511      *
512      * If `target` reverts with a revert reason, it is bubbled up by this
513      * function (like regular Solidity function calls).
514      *
515      * Returns the raw returned data. To convert to the expected return value,
516      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
517      *
518      * Requirements:
519      *
520      * - `target` must be a contract.
521      * - calling `target` with `data` must not revert.
522      *
523      * _Available since v3.1._
524      */
525     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
526         return functionCall(target, data, "Address: low-level call failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
531      * `errorMessage` as a fallback revert reason when `target` reverts.
532      *
533      * _Available since v3.1._
534      */
535     function functionCall(
536         address target,
537         bytes memory data,
538         string memory errorMessage
539     ) internal returns (bytes memory) {
540         return functionCallWithValue(target, data, 0, errorMessage);
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
545      * but also transferring `value` wei to `target`.
546      *
547      * Requirements:
548      *
549      * - the calling contract must have an ETH balance of at least `value`.
550      * - the called Solidity function must be `payable`.
551      *
552      * _Available since v3.1._
553      */
554     function functionCallWithValue(
555         address target,
556         bytes memory data,
557         uint256 value
558     ) internal returns (bytes memory) {
559         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
564      * with `errorMessage` as a fallback revert reason when `target` reverts.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(
569         address target,
570         bytes memory data,
571         uint256 value,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         require(address(this).balance >= value, "Address: insufficient balance for call");
575         require(isContract(target), "Address: call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.call{value: value}(data);
578         return _verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a static call.
584      *
585      * _Available since v3.3._
586      */
587     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
588         return functionStaticCall(target, data, "Address: low-level static call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(
598         address target,
599         bytes memory data,
600         string memory errorMessage
601     ) internal view returns (bytes memory) {
602         require(isContract(target), "Address: static call to non-contract");
603 
604         (bool success, bytes memory returndata) = target.staticcall(data);
605         return _verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
610      * but performing a delegate call.
611      *
612      * _Available since v3.4._
613      */
614     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
615         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
620      * but performing a delegate call.
621      *
622      * _Available since v3.4._
623      */
624     function functionDelegateCall(
625         address target,
626         bytes memory data,
627         string memory errorMessage
628     ) internal returns (bytes memory) {
629         require(isContract(target), "Address: delegate call to non-contract");
630 
631         (bool success, bytes memory returndata) = target.delegatecall(data);
632         return _verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     function _verifyCallResult(
636         bool success,
637         bytes memory returndata,
638         string memory errorMessage
639     ) private pure returns (bytes memory) {
640         if (success) {
641             return returndata;
642         } else {
643             // Look for revert reason and bubble it up if present
644             if (returndata.length > 0) {
645                 // The easiest way to bubble the revert reason is using memory via assembly
646 
647                 assembly {
648                     let returndata_size := mload(returndata)
649                     revert(add(32, returndata), returndata_size)
650                 }
651             } else {
652                 revert(errorMessage);
653             }
654         }
655     }
656 }
657 
658 
659 
660 
661 
662 
663 
664 
665 
666 /**
667  * @dev Implementation of the {IERC165} interface.
668  *
669  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
670  * for the additional interface id that will be supported. For example:
671  *
672  * ```solidity
673  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
674  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
675  * }
676  * ```
677  *
678  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
679  */
680 abstract contract ERC165 is IERC165 {
681     /**
682      * @dev See {IERC165-supportsInterface}.
683      */
684     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
685         return interfaceId == type(IERC165).interfaceId;
686     }
687 }
688 
689 
690 /**
691  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
692  * the Metadata extension, but not including the Enumerable extension, which is available separately as
693  * {ERC721Enumerable}.
694  */
695 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
696     using Address for address;
697     using Strings for uint256;
698 
699     // Token name
700     string private _name;
701 
702     // Token symbol
703     string private _symbol;
704 
705     // Mapping from token ID to owner address
706     mapping(uint256 => address) private _owners;
707 
708     // Mapping owner address to token count
709     mapping(address => uint256) private _balances;
710 
711     // Mapping from token ID to approved address
712     mapping(uint256 => address) private _tokenApprovals;
713 
714     // Mapping from owner to operator approvals
715     mapping(address => mapping(address => bool)) private _operatorApprovals;
716 
717     /**
718      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
719      */
720     constructor(string memory name_, string memory symbol_) {
721         _name = name_;
722         _symbol = symbol_;
723     }
724 
725     /**
726      * @dev See {IERC165-supportsInterface}.
727      */
728     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
729         return
730             interfaceId == type(IERC721).interfaceId ||
731             interfaceId == type(IERC721Metadata).interfaceId ||
732             super.supportsInterface(interfaceId);
733     }
734 
735     /**
736      * @dev See {IERC721-balanceOf}.
737      */
738     function balanceOf(address owner) public view virtual override returns (uint256) {
739         require(owner != address(0), "ERC721: balance query for the zero address");
740         return _balances[owner];
741     }
742 
743     /**
744      * @dev See {IERC721-ownerOf}.
745      */
746     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
747         address owner = _owners[tokenId];
748         require(owner != address(0), "ERC721: owner query for nonexistent token");
749         return owner;
750     }
751 
752     /**
753      * @dev See {IERC721Metadata-name}.
754      */
755     function name() public view virtual override returns (string memory) {
756         return _name;
757     }
758 
759     /**
760      * @dev See {IERC721Metadata-symbol}.
761      */
762     function symbol() public view virtual override returns (string memory) {
763         return _symbol;
764     }
765 
766     /**
767      * @dev See {IERC721Metadata-tokenURI}.
768      */
769     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
770         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
771 
772         string memory baseURI = _baseURI();
773         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
774     }
775 
776     /**
777      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
778      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
779      * by default, can be overriden in child contracts.
780      */
781     function _baseURI() internal view virtual returns (string memory) {
782         return "";
783     }
784 
785     /**
786      * @dev See {IERC721-approve}.
787      */
788     function approve(address to, uint256 tokenId) public virtual override {
789         address owner = ERC721.ownerOf(tokenId);
790         require(to != owner, "ERC721: approval to current owner");
791 
792         require(
793             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
794             "ERC721: approve caller is not owner nor approved for all"
795         );
796 
797         _approve(to, tokenId);
798     }
799 
800     /**
801      * @dev See {IERC721-getApproved}.
802      */
803     function getApproved(uint256 tokenId) public view virtual override returns (address) {
804         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
805 
806         return _tokenApprovals[tokenId];
807     }
808 
809     /**
810      * @dev See {IERC721-setApprovalForAll}.
811      */
812     function setApprovalForAll(address operator, bool approved) public virtual override {
813         require(operator != _msgSender(), "ERC721: approve to caller");
814 
815         _operatorApprovals[_msgSender()][operator] = approved;
816         emit ApprovalForAll(_msgSender(), operator, approved);
817     }
818 
819     /**
820      * @dev See {IERC721-isApprovedForAll}.
821      */
822     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
823         return _operatorApprovals[owner][operator];
824     }
825 
826     /**
827      * @dev See {IERC721-transferFrom}.
828      */
829     function transferFrom(
830         address from,
831         address to,
832         uint256 tokenId
833     ) public virtual override {
834         //solhint-disable-next-line max-line-length
835         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
836 
837         _transfer(from, to, tokenId);
838     }
839 
840     /**
841      * @dev See {IERC721-safeTransferFrom}.
842      */
843     function safeTransferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) public virtual override {
848         safeTransferFrom(from, to, tokenId, "");
849     }
850 
851     /**
852      * @dev See {IERC721-safeTransferFrom}.
853      */
854     function safeTransferFrom(
855         address from,
856         address to,
857         uint256 tokenId,
858         bytes memory _data
859     ) public virtual override {
860         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
861         _safeTransfer(from, to, tokenId, _data);
862     }
863 
864     /**
865      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
866      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
867      *
868      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
869      *
870      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
871      * implement alternative mechanisms to perform token transfer, such as signature-based.
872      *
873      * Requirements:
874      *
875      * - `from` cannot be the zero address.
876      * - `to` cannot be the zero address.
877      * - `tokenId` token must exist and be owned by `from`.
878      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _safeTransfer(
883         address from,
884         address to,
885         uint256 tokenId,
886         bytes memory _data
887     ) internal virtual {
888         _transfer(from, to, tokenId);
889         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
890     }
891 
892     /**
893      * @dev Returns whether `tokenId` exists.
894      *
895      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
896      *
897      * Tokens start existing when they are minted (`_mint`),
898      * and stop existing when they are burned (`_burn`).
899      */
900     function _exists(uint256 tokenId) internal view virtual returns (bool) {
901         return _owners[tokenId] != address(0);
902     }
903 
904     /**
905      * @dev Returns whether `spender` is allowed to manage `tokenId`.
906      *
907      * Requirements:
908      *
909      * - `tokenId` must exist.
910      */
911     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
912         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
913         address owner = ERC721.ownerOf(tokenId);
914         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
915     }
916 
917     /**
918      * @dev Safely mints `tokenId` and transfers it to `to`.
919      *
920      * Requirements:
921      *
922      * - `tokenId` must not exist.
923      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _safeMint(address to, uint256 tokenId) internal virtual {
928         _safeMint(to, tokenId, "");
929     }
930 
931     /**
932      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
933      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
934      */
935     function _safeMint(
936         address to,
937         uint256 tokenId,
938         bytes memory _data
939     ) internal virtual {
940         _mint(to, tokenId);
941         require(
942             _checkOnERC721Received(address(0), to, tokenId, _data),
943             "ERC721: transfer to non ERC721Receiver implementer"
944         );
945     }
946 
947     /**
948      * @dev Mints `tokenId` and transfers it to `to`.
949      *
950      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
951      *
952      * Requirements:
953      *
954      * - `tokenId` must not exist.
955      * - `to` cannot be the zero address.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _mint(address to, uint256 tokenId) internal virtual {
960         require(to != address(0), "ERC721: mint to the zero address");
961         require(!_exists(tokenId), "ERC721: token already minted");
962 
963         _beforeTokenTransfer(address(0), to, tokenId);
964 
965         _balances[to] += 1;
966         _owners[tokenId] = to;
967 
968         emit Transfer(address(0), to, tokenId);
969     }
970 
971     /**
972      * @dev Destroys `tokenId`.
973      * The approval is cleared when the token is burned.
974      *
975      * Requirements:
976      *
977      * - `tokenId` must exist.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _burn(uint256 tokenId) internal virtual {
982         address owner = ERC721.ownerOf(tokenId);
983 
984         _beforeTokenTransfer(owner, address(0), tokenId);
985 
986         // Clear approvals
987         _approve(address(0), tokenId);
988 
989         _balances[owner] -= 1;
990         delete _owners[tokenId];
991 
992         emit Transfer(owner, address(0), tokenId);
993     }
994 
995     /**
996      * @dev Transfers `tokenId` from `from` to `to`.
997      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
998      *
999      * Requirements:
1000      *
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must be owned by `from`.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _transfer(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) internal virtual {
1011         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1012         require(to != address(0), "ERC721: transfer to the zero address");
1013 
1014         _beforeTokenTransfer(from, to, tokenId);
1015 
1016         // Clear approvals from the previous owner
1017         _approve(address(0), tokenId);
1018 
1019         _balances[from] -= 1;
1020         _balances[to] += 1;
1021         _owners[tokenId] = to;
1022 
1023         emit Transfer(from, to, tokenId);
1024     }
1025 
1026     /**
1027      * @dev Approve `to` to operate on `tokenId`
1028      *
1029      * Emits a {Approval} event.
1030      */
1031     function _approve(address to, uint256 tokenId) internal virtual {
1032         _tokenApprovals[tokenId] = to;
1033         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1038      * The call is not executed if the target address is not a contract.
1039      *
1040      * @param from address representing the previous owner of the given token ID
1041      * @param to target address that will receive the tokens
1042      * @param tokenId uint256 ID of the token to be transferred
1043      * @param _data bytes optional data to send along with the call
1044      * @return bool whether the call correctly returned the expected magic value
1045      */
1046     function _checkOnERC721Received(
1047         address from,
1048         address to,
1049         uint256 tokenId,
1050         bytes memory _data
1051     ) private returns (bool) {
1052         if (to.isContract()) {
1053             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1054                 return retval == IERC721Receiver(to).onERC721Received.selector;
1055             } catch (bytes memory reason) {
1056                 if (reason.length == 0) {
1057                     revert("ERC721: transfer to non ERC721Receiver implementer");
1058                 } else {
1059                     assembly {
1060                         revert(add(32, reason), mload(reason))
1061                     }
1062                 }
1063             }
1064         } else {
1065             return true;
1066         }
1067     }
1068 
1069     /**
1070      * @dev Hook that is called before any token transfer. This includes minting
1071      * and burning.
1072      *
1073      * Calling conditions:
1074      *
1075      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1076      * transferred to `to`.
1077      * - When `from` is zero, `tokenId` will be minted for `to`.
1078      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1079      * - `from` and `to` are never both zero.
1080      *
1081      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1082      */
1083     function _beforeTokenTransfer(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) internal virtual {}
1088 }
1089 
1090 
1091 
1092 
1093 
1094 
1095 
1096 /**
1097  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1098  * @dev See https://eips.ethereum.org/EIPS/eip-721
1099  */
1100 interface IERC721Enumerable is IERC721 {
1101     /**
1102      * @dev Returns the total amount of tokens stored by the contract.
1103      */
1104     function totalSupply() external view returns (uint256);
1105 
1106     /**
1107      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1108      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1109      */
1110     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1111 
1112     /**
1113      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1114      * Use along with {totalSupply} to enumerate all tokens.
1115      */
1116     function tokenByIndex(uint256 index) external view returns (uint256);
1117 }
1118 
1119 
1120 /**
1121  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1122  * enumerability of all the token ids in the contract as well as all token ids owned by each
1123  * account.
1124  */
1125 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1126     // Mapping from owner to list of owned token IDs
1127     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1128 
1129     // Mapping from token ID to index of the owner tokens list
1130     mapping(uint256 => uint256) private _ownedTokensIndex;
1131 
1132     // Array with all token ids, used for enumeration
1133     uint256[] private _allTokens;
1134 
1135     // Mapping from token id to position in the allTokens array
1136     mapping(uint256 => uint256) private _allTokensIndex;
1137 
1138     /**
1139      * @dev See {IERC165-supportsInterface}.
1140      */
1141     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1142         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1143     }
1144 
1145     /**
1146      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1147      */
1148     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1149         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1150         return _ownedTokens[owner][index];
1151     }
1152 
1153     /**
1154      * @dev See {IERC721Enumerable-totalSupply}.
1155      */
1156     function totalSupply() public view virtual override returns (uint256) {
1157         return _allTokens.length;
1158     }
1159 
1160     /**
1161      * @dev See {IERC721Enumerable-tokenByIndex}.
1162      */
1163     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1164         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1165         return _allTokens[index];
1166     }
1167 
1168     /**
1169      * @dev Hook that is called before any token transfer. This includes minting
1170      * and burning.
1171      *
1172      * Calling conditions:
1173      *
1174      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1175      * transferred to `to`.
1176      * - When `from` is zero, `tokenId` will be minted for `to`.
1177      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1178      * - `from` cannot be the zero address.
1179      * - `to` cannot be the zero address.
1180      *
1181      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1182      */
1183     function _beforeTokenTransfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) internal virtual override {
1188         super._beforeTokenTransfer(from, to, tokenId);
1189 
1190         if (from == address(0)) {
1191             _addTokenToAllTokensEnumeration(tokenId);
1192         } else if (from != to) {
1193             _removeTokenFromOwnerEnumeration(from, tokenId);
1194         }
1195         if (to == address(0)) {
1196             _removeTokenFromAllTokensEnumeration(tokenId);
1197         } else if (to != from) {
1198             _addTokenToOwnerEnumeration(to, tokenId);
1199         }
1200     }
1201 
1202     /**
1203      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1204      * @param to address representing the new owner of the given token ID
1205      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1206      */
1207     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1208         uint256 length = ERC721.balanceOf(to);
1209         _ownedTokens[to][length] = tokenId;
1210         _ownedTokensIndex[tokenId] = length;
1211     }
1212 
1213     /**
1214      * @dev Private function to add a token to this extension's token tracking data structures.
1215      * @param tokenId uint256 ID of the token to be added to the tokens list
1216      */
1217     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1218         _allTokensIndex[tokenId] = _allTokens.length;
1219         _allTokens.push(tokenId);
1220     }
1221 
1222     /**
1223      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1224      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1225      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1226      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1227      * @param from address representing the previous owner of the given token ID
1228      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1229      */
1230     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1231         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1232         // then delete the last slot (swap and pop).
1233 
1234         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1235         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1236 
1237         // When the token to delete is the last token, the swap operation is unnecessary
1238         if (tokenIndex != lastTokenIndex) {
1239             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1240 
1241             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1242             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1243         }
1244 
1245         // This also deletes the contents at the last position of the array
1246         delete _ownedTokensIndex[tokenId];
1247         delete _ownedTokens[from][lastTokenIndex];
1248     }
1249 
1250     /**
1251      * @dev Private function to remove a token from this extension's token tracking data structures.
1252      * This has O(1) time complexity, but alters the order of the _allTokens array.
1253      * @param tokenId uint256 ID of the token to be removed from the tokens list
1254      */
1255     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1256         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1257         // then delete the last slot (swap and pop).
1258 
1259         uint256 lastTokenIndex = _allTokens.length - 1;
1260         uint256 tokenIndex = _allTokensIndex[tokenId];
1261 
1262         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1263         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1264         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1265         uint256 lastTokenId = _allTokens[lastTokenIndex];
1266 
1267         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1268         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1269 
1270         // This also deletes the contents at the last position of the array
1271         delete _allTokensIndex[tokenId];
1272         _allTokens.pop();
1273     }
1274 }
1275 
1276 
1277 contract Lore is ERC721Enumerable, ReentrancyGuard, Ownable {
1278 
1279     ERC721 loot = ERC721(0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7);
1280 	
1281     string[] private origins = [
1282         "Orphan",
1283         "Slave",
1284         "Royalty",
1285         "Commoner",
1286         "Farmer",
1287         "Landlord",
1288         "Adventurer",
1289         "Cultist",
1290         "Refugee",
1291         "Warrior",
1292         "Vagabond",
1293         "Hermit",
1294         "Beggar",
1295         "Pilgrim",
1296         "Heretic",
1297         "Vagrant",
1298         "Scholar",
1299         "Monk"
1300     ];
1301     
1302     string[] private jobs = [
1303 		"Animal Handler",
1304 		"Arborist",
1305 		"Beekeeper",
1306 		"Birdcatcher",
1307 		"Cowherd",
1308 		"Falconer",
1309 		"Farmer",
1310 		"Fisher",
1311 		"Forager",
1312 		"Gamekeeper",
1313 		"Groom",
1314 		"Herder",
1315 		"Horse Trainer",
1316 		"Hunter",
1317 		"Master-of-Hounds",
1318 		"Miller",
1319 		"Prospector",
1320 		"Ranger",
1321 		"Renderer",
1322 		"Shepherd",
1323 		"Stablehand",
1324 		"Thresher",
1325 		"Trapper",
1326 		"Vintner",
1327 		"Woodcutter",
1328 		"Zookeeper",
1329 		"Architect",
1330 		"Brickmason",
1331 		"Carpenter",
1332 		"Claymason",
1333 		"Plasterer",
1334 		"Roofer",
1335 		"Stonemason",
1336 		"Streetlayer",
1337 		"Acrobat",
1338 		"Actor",
1339 		"Chef",
1340 		"Dancer",
1341 		"Gladiator",
1342 		"Glasspainter",
1343 		"Jester",
1344 		"Illuminator",
1345 		"Minstrel",
1346 		"Musician",
1347 		"Painter",
1348 		"Piper",
1349 		"Playwright",
1350 		"Poet",
1351 		"Sculptor",
1352 		"Singer",
1353 		"Tattooist",
1354 		"Wrestler",
1355 		"Writer",
1356 		"Accountant",
1357 		"Banker",
1358 		"Brothel Owner",
1359 		"Chandler",
1360 		"Collector",
1361 		"Entrepreneur",
1362 		"Fishmonger",
1363 		"Grocer",
1364 		"Guild Master",
1365 		"Innkeeper",
1366 		"Ironmonger",
1367 		"Merchant",
1368 		"Peddler",
1369 		"Speculator",
1370 		"Street Vendor",
1371 		"Thriftdealer",
1372 		"Courier",
1373 		"Herald",
1374 		"Interpreter",
1375 		"Linguist",
1376 		"Messenger",
1377 		"Town Crier",
1378 		"Translator",
1379 		"Armorer",
1380 		"Blacksmith",
1381 		"Rope-maker",
1382 		"Saddler",
1383 		"Tailor",
1384 		"Soaper",
1385 		"Tanner",
1386 		"Taxidermist",
1387 		"Thatcher",
1388 		"Tinker",
1389 		"Toymaker",
1390 		"Watchmaker",
1391 		"Weaponsmith",
1392 		"Weaver",
1393 		"Wheelwright",
1394 		"Whittler",
1395 		"Woodcarver",
1396 		"Assassin",
1397 		"Bandit",
1398 		"Burglar",
1399 		"Conman",
1400 		"Cockfighter",
1401 		"Crime Boss",
1402 		"Cutpurse",
1403 		"Drug Lord",
1404 		"Fence",
1405 		"Kidnapper",
1406 		"Loan Shark",
1407 		"Outlaw",
1408 		"Pirate",
1409 		"Poacher",
1410 		"Smuggler",
1411 		"Rogue",
1412 		"Anthropologist",
1413 		"Apprentice",
1414 		"Archaeologist",
1415 		"Archivist",
1416 		"Artificer",
1417 		"Astrologer",
1418 		"Botanist",
1419 		"Cartographer",
1420 		"Chemist",
1421 		"Dean",
1422 		"Engineer",
1423 		"Historian",
1424 		"Horologist",
1425 		"Librarian",
1426 		"Mathematician",
1427 		"Philosopher",
1428 		"Professor",
1429 		"Scholar",
1430 		"Scribe",
1431 		"Student",
1432 		"Teacher",
1433 		"Theologian",
1434 		"Tutor",
1435 		"Archduke",
1436 		"Aristocrat",
1437 		"Baron",
1438 		"Chancellor",
1439 		"Chief",
1440 		"Constable",
1441 		"Count",
1442 		"Courtier",
1443 		"Diplomat",
1444 		"Duke",
1445 		"Emperor",
1446 		"Judge",
1447 		"Knight",
1448 		"Lady-in-Waiting",
1449 		"Lawyer",
1450 		"Marquess",
1451 		"Minister",
1452 		"Orator",
1453 		"Prince",
1454 		"Steward",
1455 		"Squire",
1456 		"Tax Collector",
1457 		"Ward",
1458 		"Alchemist",
1459 		"Apothecary",
1460 		"Bloodletter",
1461 		"Doctor",
1462 		"Healer",
1463 		"Herbalist",
1464 		"Midwife",
1465 		"Mortician",
1466 		"Nurse",
1467 		"Physician",
1468 		"Surgeon",
1469 		"Veterinarian",
1470 		"Baker",
1471 		"Barber",
1472 		"Barkeep",
1473 		"Barmaid",
1474 		"Butcher",
1475 		"Charcoal Maker",
1476 		"Chatelaine",
1477 		"Chimney Sweeper",
1478 		"Clerk",
1479 		"Cook",
1480 		"Copyist",
1481 		"Croupier",
1482 		"Distiller",
1483 		"Florist",
1484 		"Gardener",
1485 		"Gongfarmer",
1486 		"Gravedigger",
1487 		"Housemaid",
1488 		"Kitchen Drudge",
1489 		"Laborer",
1490 		"Lamplighter",
1491 		"Landscaper",
1492 		"Laundry Worker",
1493 		"Longshoreman",
1494 		"Miner",
1495 		"Orphanage Caretaker",
1496 		"Prostitute",
1497 		"Street Sweeper",
1498 		"Tavern Worker",
1499 		"Vermin Catcher",
1500 		"Abjurer",
1501 		"Archmage",
1502 		"Augurer",
1503 		"Conjuror",
1504 		"Elementalist",
1505 		"Enchanter",
1506 		"Evoker",
1507 		"Hearth-witch",
1508 		"Illusionist",
1509 		"Mage",
1510 		"Necromancer",
1511 		"Ritualist",
1512 		"Runecaster",
1513 		"Sage",
1514 		"Seer",
1515 		"Shaman",
1516 		"Shapeshifter",
1517 		"Summoner",
1518 		"Wizard",
1519 		"Wordsmith",
1520 		"Admiral",
1521 		"Archer",
1522 		"Bailiff",
1523 		"Bodyguard",
1524 		"Bouncer",
1525 		"Captain",
1526 		"Castellan",
1527 		"Cavalier",
1528 		"City Watch",
1529 		"Detective",
1530 		"Duelist",
1531 		"Executioner",
1532 		"Fireman",
1533 		"Guard",
1534 		"General",
1535 		"Jailer",
1536 		"Man-at-Arms",
1537 		"Marshall",
1538 		"Mercenary",
1539 		"Sapper",
1540 		"Sentinel",
1541 		"Sergeant",
1542 		"Sergeant-at-Arms",
1543 		"Scout",
1544 		"Siege Artillerist",
1545 		"Slave Driver",
1546 		"Soldier",
1547 		"Spearman",
1548 		"Spy",
1549 		"Tactician",
1550 		"Torturer",
1551 		"Warden",
1552 		"Warmage",
1553 		"Acolyte",
1554 		"Archbishop",
1555 		"Bishop",
1556 		"Cardinal",
1557 		"Chaplain",
1558 		"Clergy",
1559 		"Cleric",
1560 		"Cultist",
1561 		"Cult Leader",
1562 		"Diviner",
1563 		"Friar",
1564 		"High Priest",
1565 		"Inquisitor",
1566 		"Missionary",
1567 		"Monk",
1568 		"Nun",
1569 		"Paladin",
1570 		"Pardoner",
1571 		"Priest",
1572 		"Prophet",
1573 		"Sexton",
1574 		"Templar",
1575 		"Boatman",
1576 		"Bosun",
1577 		"Wagoner",
1578 		"Caravaneer",
1579 		"Caravan Guard",
1580 		"Charioteer",
1581 		"Ferryman",
1582 		"First Mate",
1583 		"Helmsman",
1584 		"Navigator",
1585 		"Purser",
1586 		"Sailor",
1587 		"Sea Captain",
1588 		"Shipwright",
1589 		"Swab"
1590     ];
1591     
1592 	// The list of realms as of 9/1/2021 - 7AM EST.
1593 	// Realms claimed after this date are not included.
1594 	// Also realms with unparsable names are not included.
1595 	// Filtered using [^\x00-\x7F] to remove all non-ASCII.
1596 	// The realms were then chosen from that list with a 5% chance.
1597 	// The realms listed below are the resulting list of realms.
1598     string[] private realms = [
1599 		"Zarmaln",
1600 		"Syushstes",
1601 		"Shabe",
1602 		"Waswashauk",
1603 		"Onmomoton",
1604 		"Ghieyalb",
1605 		"Lellelnel",
1606 		"Nitog",
1607 		"Sqen nun San",
1608 		"Wawanunu",
1609 		"Nepene Zimdo",
1610 		"Krimsismrap",
1611 		"Tetsnonsgom",
1612 		"Asukunis",
1613 		"Skususskik",
1614 		"Tohhlaheh",
1615 		"Karssir",
1616 		"Dashu",
1617 		"Ulmnel",
1618 		"ku Kubtur",
1619 		"Kuosaupmao",
1620 		"Sekputlukkol",
1621 		"Toattik",
1622 		"Vimmenponpon",
1623 		"Nunata",
1624 		"Lepuukewp",
1625 		"Tipmumteh",
1626 		"Imietietit",
1627 		"Omonmot",
1628 		"Menihem",
1629 		"Ehpankonlun",
1630 		"Hunmud",
1631 		"Zoze Kalkal",
1632 		"Rizhros",
1633 		"Lim Istalkus",
1634 		"Mupeptel",
1635 		"Nasbrok",
1636 		"Urnpel",
1637 		"Tintemtemtun",
1638 		"Ewonepil",
1639 		"Snomeha",
1640 		"Mammanmammas",
1641 		"Tschin",
1642 		"Okkamak Kom",
1643 		"Kelokeluke",
1644 		"Ninlamlam",
1645 		"Wuchukkoh",
1646 		"Winglwiq",
1647 		"Mummon",
1648 		"Pultilnul",
1649 		"Tujtaerjoer",
1650 		"Umnun",
1651 		"Dotnob",
1652 		"Moebnuegrua",
1653 		"Momtonmo",
1654 		"Pipumpaj",
1655 		"Notket",
1656 		"Urgmuldulmur",
1657 		"Kis Kazkoz",
1658 		"Kipkewm",
1659 		"Susen Sessus",
1660 		"Treknlun",
1661 		"Slangpanlang",
1662 		"Atalatat",
1663 		"Shagimda",
1664 		"Pamhunsnim",
1665 		"Snussnek",
1666 		"Tiattupsim",
1667 		"os Umemulet",
1668 		"Panpan",
1669 		"tin Shlonkun",
1670 		"Imiimmionnen",
1671 		"Blambong",
1672 		"Umhin Be",
1673 		"Sviikmorkus",
1674 		"Hrenleppek",
1675 		"Xop-Met",
1676 		"Onwimninon",
1677 		"he Chichu",
1678 		"Aupoopnauls",
1679 		"Kekil",
1680 		"Urongujureg",
1681 		"Mrunvyingtis",
1682 		"Pullelpulem",
1683 		"Nukika",
1684 		"Salninken",
1685 		"Lullul",
1686 		"she Shutiash",
1687 		"Lutkamlaltak",
1688 		"Nrilutok",
1689 		"Ininni",
1690 		"Snamnunu",
1691 		"Kemkesmol",
1692 		"Shnillel",
1693 		"Bisigi",
1694 		"Topseke",
1695 		"Ittardunit",
1696 		"Anip Mirkal",
1697 		"Anbam",
1698 		"Shkukmuk",
1699 		"pat Lignluy",
1700 		"Wunnin",
1701 		"Ruxrugqaqrur",
1702 		"Shnunhum",
1703 		"Umap Amum",
1704 		"Semsem",
1705 		"Kudooklashe",
1706 		"Kuksnot",
1707 		"Neznisnasnis",
1708 		"Ketlelsu",
1709 		"seq Nliq",
1710 		"Musdon",
1711 		"Umootukom Up",
1712 		"Vaenvaenraos",
1713 		"Pitpitmirn", 
1714 		"Lonkun", 
1715 		"Nginjin", 
1716 		"Temi-kem-Ned", 
1717 		"nen-Tuntlin",
1718 		"Ortlermurn",
1719 		"Anotuneh"
1720     ];
1721     
1722     string[] private alignments = [
1723 		"Lawful Good",
1724 		"Neutral Good",
1725 		"Chaotic Good",
1726 		"Lawful Neutral",
1727 		"Neutral",
1728 		"Chaotic Neutral",
1729 		"Lawful Evil",
1730 		"Neutral Evil",
1731 		"Chaotic Evil"
1732     ];
1733     
1734     string[] private pantheons = [
1735 		"Egyptian Mythos",
1736 		"Greek Mythos",
1737 		"Hindu Mythos",
1738 		"Celtic Mythos",
1739 		"Norse Mythos",
1740 		"Finnish Mythos",
1741 		"Chinese Mythos",
1742 		"Japanese Mythos",
1743 		"Aztec Mythos",
1744 		"Mayan Mythos",
1745 		"Hyborea Mythos"
1746     ];
1747     
1748     string[] private deities = [
1749 		"Auril, Goddess of Winter",
1750 		"Azuth, God of Wizards",
1751 		"Bane, God of Tyranny",
1752 		"Beshaba, Goddess of Misfortune",
1753 		"Bhaal, God of Murder",
1754 		"Chauntea, Goddess of Agriculture",
1755 		"Cyric, God of Lies",
1756 		"Deneir, God of Writing",
1757 		"Eldath, Goddess of Peace",
1758 		"Gond, God of Craft",
1759 		"Helm, God of Protection",
1760 		"Ilmater, God of Endurance",
1761 		"Kelemvor, God of the Dead",
1762 		"Lathander, God of Renewal",
1763 		"Leira, Goddess of Illusion",
1764 		"Lliira, Goddess of Joy",
1765 		"Loviatar, Goddess of Pain",
1766 		"Malar, God of the Hunt",
1767 		"Mask, God of Thieves",
1768 		"Mielikki, Goddess of Forests",
1769 		"Milil, God of Poetry and Song",
1770 		"Myrkul, God of Death",
1771 		"Mystra, Goddess of Magic",
1772 		"Oghma, God of Knowledge",
1773 		"Savras, god of Divination",
1774 		"Selune, Goddess of the Moon",
1775 		"Shar, Goddess of Darkness",
1776 		"Silvanus, God of Wild Nature",
1777 		"Sune, Goddess of Love",
1778 		"Talona, Goddess of Disease",
1779 		"Talos, God of Storms",
1780 		"Tempus, God of War",
1781 		"Torm, God of Courage",
1782 		"Tymora, Goddess of Fortune",
1783 		"Tyr, God of Justice",
1784 		"Umberlee, Goddess of the Sea",
1785 		"Waukeen, Goddess of Trade"
1786     ];
1787 	
1788     string[] private races = [
1789         "Human",
1790         "Dwarf",
1791         "Elf",
1792         "Vampire",
1793         "Undead",
1794         "Goblin",
1795         "Demon",
1796         "Troll",
1797         "Ork",
1798         "Catfolk",
1799         "Angel",
1800         "Fairy",
1801         "Halfling",
1802         "Giant",
1803         "Lizardfolk",
1804         "Nymph"
1805     ];
1806     
1807     function random(string memory input) internal pure returns (uint256) {
1808         return uint256(keccak256(abi.encodePacked(input)));
1809     }
1810     
1811     function getOrigin(uint256 tokenId) public view returns (string memory) {
1812         return pluck(tokenId, "ORIGIN", origins);
1813     }
1814     
1815     function getRace(uint256 tokenId) public view returns (string memory) {
1816         return pluckRace(tokenId, "RACE");
1817     }
1818     
1819     function getJob(uint256 tokenId) public view returns (string memory) {
1820         return pluckJob(tokenId, "JOB");
1821     }
1822     
1823     function getRealm(uint256 tokenId) public view returns (string memory) {
1824         return pluckRealm(tokenId, "REALM");
1825     }
1826     
1827     function getAlignment(uint256 tokenId) public view returns (string memory) {
1828         return pluck(tokenId, "ALIGNMENT", alignments);
1829     }
1830 
1831     function getAge(uint256 tokenId) public view returns (string memory) {
1832         return pluckAge(tokenId, "AGE");
1833     }
1834     
1835     function getPantheon(uint256 tokenId) public view returns (string memory) {
1836         return pluck(tokenId, "PANTHEON", pantheons);
1837     }
1838 	
1839     function getDeity(uint256 tokenId) public view returns (string memory) {
1840         return pluckDeity(tokenId, "DEITY");
1841     }
1842     
1843     function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
1844         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1845         string memory output = sourceArray[rand % sourceArray.length];
1846         return output;
1847     }
1848     
1849     function pluckAge(uint256 tokenId, string memory keyPrefix) internal view returns (string memory) {
1850         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1851         string memory output = toString(rand % 99 + 10);
1852         output = string(abi.encodePacked(output, " Years of Age"));
1853         return output;
1854     }
1855     
1856     function pluckRace(uint256 tokenId, string memory keyPrefix) internal view returns (string memory) {
1857         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1858         string memory output = races[rand % races.length];
1859         uint256 greatness = rand % 21;
1860 		if (greatness == 0) {
1861             output = string(abi.encodePacked("Undesirable ", output));
1862         } else if (greatness > 10 && greatness < 14) {
1863             output = string(abi.encodePacked("Respected ", output));
1864         } else if (greatness >= 14 && greatness < 18) {
1865             output = string(abi.encodePacked("Renown ", output));
1866         } else if (greatness >= 18) {
1867             if (greatness < 20) {
1868                 output = string(abi.encodePacked("Noble ", output));
1869             } else {
1870                 output = string(abi.encodePacked("Legendary ", output));
1871             }
1872         }
1873         return output;
1874     }
1875     
1876     function pluckDeity(uint256 tokenId, string memory keyPrefix) internal view returns (string memory) {
1877         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1878         string memory output = deities[rand % deities.length];
1879         uint256 greatness = rand % 21;
1880 		if (greatness == 0) {
1881             output = string(abi.encodePacked("Cursed by ", output));
1882         } else if (greatness < 14) {
1883             output = string(abi.encodePacked("Follower of ", output));
1884         } else if (greatness >= 14 && greatness < 18) {
1885             output = string(abi.encodePacked("Blessed by ", output));
1886         } else if (greatness >= 18) {
1887             if (greatness < 20) {
1888                 output = string(abi.encodePacked("Chosen by ", output));
1889             } else {
1890                 output = string(abi.encodePacked("Right Hand of ", output));
1891             }
1892         }
1893         return output;
1894     }
1895     
1896     function pluckJob(uint256 tokenId, string memory keyPrefix) internal view returns (string memory) {
1897         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1898         string memory output = jobs[rand % jobs.length];
1899         uint256 greatness = rand % 21;
1900 		if (greatness == 0) {
1901             output = string(abi.encodePacked("Unskilled ", output));
1902         } else if (greatness > 10 && greatness < 14) {
1903             output = string(abi.encodePacked("Neophyte ", output));
1904         } else if (greatness >= 14 && greatness < 19) {
1905             output = string(abi.encodePacked("Journeyman ", output));
1906         } else if (greatness >= 19) {
1907             if (greatness == 19) {
1908                 output = string(abi.encodePacked("Expert ", output));
1909             } else {
1910                 output = string(abi.encodePacked("Master ", output));
1911             }
1912         }
1913         return output;
1914     }
1915     
1916     function pluckRealm(uint256 tokenId, string memory keyPrefix) internal view returns (string memory) {
1917         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1918         string memory output = realms[rand % realms.length];
1919         uint256 greatness = rand % 21;
1920 		if (greatness == 0) {
1921             output = string(abi.encodePacked("Outcast of ", output));
1922         } else if (greatness > 0 && greatness <= 10) {
1923             output = string(abi.encodePacked("Refugee of ", output));
1924         } else if (greatness > 10 && greatness < 14) {
1925             output = string(abi.encodePacked("Serf of ", output));
1926         } else if (greatness >= 14 && greatness < 19) {
1927             output = string(abi.encodePacked("Citizen of ", output));
1928         } else if (greatness >= 19) {
1929             if (greatness == 19) {
1930                 output = string(abi.encodePacked("Nobility of ", output));
1931             } else {
1932                 output = string(abi.encodePacked("Royalty of ", output));
1933             }
1934         }
1935         return output;
1936     }
1937 
1938     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1939         string[17] memory parts;
1940         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
1941 
1942         parts[1] = getOrigin(tokenId);
1943 
1944         parts[2] = '</text><text x="10" y="40" class="base">';
1945 
1946         parts[3] = getRace(tokenId);
1947 
1948         parts[4] = '</text><text x="10" y="60" class="base">';
1949 
1950         parts[5] = getJob(tokenId);
1951 
1952         parts[6] = '</text><text x="10" y="80" class="base">';
1953 
1954         parts[7] = getRealm(tokenId);
1955 
1956         parts[8] = '</text><text x="10" y="100" class="base">';
1957 
1958         parts[9] = getAlignment(tokenId);
1959 
1960         parts[10] = '</text><text x="10" y="120" class="base">';
1961 
1962         parts[11] = getAge(tokenId);
1963 
1964         parts[12] = '</text><text x="10" y="140" class="base">';
1965 
1966         parts[13] = getPantheon(tokenId);
1967 
1968         parts[14] = '</text><text x="10" y="160" class="base">';
1969 
1970         parts[15] = getDeity(tokenId);
1971 
1972         parts[16] = '</text></svg>';
1973 
1974         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1975         output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
1976         
1977         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Lore #', toString(tokenId), '", "description": "Lore is randomized adventurer lore generated and stored on chain. Based on the popular loot token metadata, loot owners can claim their lore to match their loot.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1978         output = string(abi.encodePacked('data:application/json;base64,', json));
1979 
1980         return output;
1981     }
1982 
1983 	// Because others need a chance too.
1984     function claim(uint256 tokenId) public nonReentrant {
1985         require(tokenId >= 8001 && tokenId < 9750, "Token ID invalid, public sales for 8001-9749.");
1986         _safeMint(_msgSender(), tokenId);
1987     }
1988 	
1989 	// Because the loot holders come first.
1990     function claimForLoot(uint256 tokenId) public nonReentrant {
1991         require(tokenId > 0 && tokenId < 8001, "Token ID invalid, loot owners can claim 1-8000.");
1992         require(loot.ownerOf(tokenId) == msg.sender, "Not Loot owner");
1993         _safeMint(_msgSender(), tokenId);
1994     }
1995     
1996 	// Because I want to make something too.
1997     function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
1998         require(tokenId > 9750 && tokenId < 10001, "Token ID invalid, owner can claim last 250.");
1999         _safeMint(owner(), tokenId);
2000     }
2001     
2002     function toString(uint256 value) internal pure returns (string memory) {
2003         if (value == 0) {
2004             return "0";
2005         }
2006         uint256 temp = value;
2007         uint256 digits;
2008         while (temp != 0) {
2009             digits++;
2010             temp /= 10;
2011         }
2012         bytes memory buffer = new bytes(digits);
2013         while (value != 0) {
2014             digits -= 1;
2015             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2016             value /= 10;
2017         }
2018         return string(buffer);
2019     }
2020     
2021     constructor() ERC721("Lore", "LORE") Ownable() {}
2022 }
2023 
2024 /// [MIT License]
2025 /// @title Base64
2026 /// @notice Provides a function for encoding some bytes in base64
2027 /// @author Brecht Devos <brecht@loopring.org>
2028 library Base64 {
2029     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
2030 
2031     /// @notice Encodes some bytes to the base64 representation
2032     function encode(bytes memory data) internal pure returns (string memory) {
2033         uint256 len = data.length;
2034         if (len == 0) return "";
2035 
2036         // multiply by 4/3 rounded up
2037         uint256 encodedLen = 4 * ((len + 2) / 3);
2038 
2039         // Add some extra buffer at the end
2040         bytes memory result = new bytes(encodedLen + 32);
2041 
2042         bytes memory table = TABLE;
2043 
2044         assembly {
2045             let tablePtr := add(table, 1)
2046             let resultPtr := add(result, 32)
2047 
2048             for {
2049                 let i := 0
2050             } lt(i, len) {
2051 
2052             } {
2053                 i := add(i, 3)
2054                 let input := and(mload(add(data, i)), 0xffffff)
2055 
2056                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
2057                 out := shl(8, out)
2058                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
2059                 out := shl(8, out)
2060                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
2061                 out := shl(8, out)
2062                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
2063                 out := shl(224, out)
2064 
2065                 mstore(resultPtr, out)
2066 
2067                 resultPtr := add(resultPtr, 4)
2068             }
2069 
2070             switch mod(len, 3)
2071             case 1 {
2072                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
2073             }
2074             case 2 {
2075                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
2076             }
2077 
2078             mstore(result, encodedLen)
2079         }
2080 
2081         return string(result);
2082     }
2083 }