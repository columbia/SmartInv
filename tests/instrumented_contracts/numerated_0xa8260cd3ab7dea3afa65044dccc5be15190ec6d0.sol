1 // SPDX-License-Identifier: MIT
2 
3 /*
4 Mutant Floki by Will Jack
5 */
6 
7 pragma solidity ^0.8.4;
8 
9 /**
10  * This contract is only required for intermediate, library-like contracts.
11  */
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 pragma solidity ^0.8.4;
23 
24 /**
25  * @dev Contract module which provides access control
26  *
27  * the owner account will be the one that deploys the contract. This
28  * can later be changed with {transferOwnership}.
29  *
30  * mapped to 
31  * `onlyOwner`
32  */
33 abstract contract Ownable is Context {
34     address private _owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     /**
39      * @dev Initializes the contract setting the deployer as the initial owner.
40      */
41     constructor() {
42         _setOwner(_msgSender());
43     }
44 
45     /**
46      * @dev Returns the address of the current owner.
47      */
48     function owner() public view virtual returns (address) {
49         return _owner;
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         require(owner() == _msgSender(), "Ownable: caller is not the owner");
57         _;
58     }
59 
60     /**
61      * @dev Leaves the contract without owner. It will not be possible to call
62      * `onlyOwner` functions anymore. Can only be called by the current owner.
63      *
64      * NOTE: Renouncing ownership will leave the contract without an owner,
65      * thereby removing any functionality that is only available to the owner.
66      */
67     function renounceOwnership() public virtual onlyOwner {
68         _setOwner(address(0));
69     }
70 
71     /**
72      * @dev Transfers ownership of the contract to a new account (`newOwner`).
73      * Can only be called by the current owner.
74      */
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         _setOwner(newOwner);
78     }
79 
80     function _setOwner(address newOwner) private {
81         address oldOwner = _owner;
82         _owner = newOwner;
83         emit OwnershipTransferred(oldOwner, newOwner);
84     }
85 }
86 
87 pragma solidity ^0.8.4;
88 
89 /**
90  * @dev String operations.
91  */
92 library Strings {
93     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
94 
95     /**
96      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
97      */
98     function toString(uint256 value) internal pure returns (string memory) {
99         // Inspired by OraclizeAPI's implementation - MIT licence
100         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
101 
102         if (value == 0) {
103             return "0";
104         }
105         uint256 temp = value;
106         uint256 digits;
107         while (temp != 0) {
108             digits++;
109             temp /= 10;
110         }
111         bytes memory buffer = new bytes(digits);
112         while (value != 0) {
113             digits -= 1;
114             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
115             value /= 10;
116         }
117         return string(buffer);
118     }
119 
120     /**
121      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
122      */
123     function toHexString(uint256 value) internal pure returns (string memory) {
124         if (value == 0) {
125             return "0x00";
126         }
127         uint256 temp = value;
128         uint256 length = 0;
129         while (temp != 0) {
130             length++;
131             temp >>= 8;
132         }
133         return toHexString(value, length);
134     }
135 
136     /**
137      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
138      */
139     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
140         bytes memory buffer = new bytes(2 * length + 2);
141         buffer[0] = "0";
142         buffer[1] = "x";
143         for (uint256 i = 2 * length + 1; i > 1; --i) {
144             buffer[i] = _HEX_SYMBOLS[value & 0xf];
145             value >>= 4;
146         }
147         require(value == 0, "Strings: hex length insufficient");
148         return string(buffer);
149     }
150 }
151 
152 pragma solidity ^0.8.4;
153 
154 /**
155  * @dev Contract module that helps prevent reentrant calls to a function.
156  *
157  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
158  * available, which can be applied to functions to make sure there are no nested
159  * (reentrant) calls to them.
160  *
161  * Note that because there is a single `nonReentrant` guard, functions marked as
162  * `nonReentrant` may not call one another. This can be worked around by making
163  * those functions `private`, and then adding `external` `nonReentrant` entry
164  * points to them.
165  *
166  * TIP: If you would like to learn more about reentrancy and alternative ways
167  * to protect against it, check out our blog post
168  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
169  */
170 abstract contract ReentrancyGuard {
171     // Booleans are more expensive than uint256 or any type that takes up a full
172     // word because each write operation emits an extra SLOAD to first read the
173     // slot's contents, replace the bits taken up by the boolean, and then write
174     // back. This is the compiler's defense against contract upgrades and
175     // pointer aliasing, and it cannot be disabled.
176 
177     // The values being non-zero value makes deployment a bit more expensive,
178     // but in exchange the refund on every call to nonReentrant will be lower in
179     // amount. Since refunds are capped to a percentage of the total
180     // transaction's gas, it is best to keep them low in cases like this one, to
181     // increase the likelihood of the full refund coming into effect.
182     uint256 private constant _NOT_ENTERED = 1;
183     uint256 private constant _ENTERED = 2;
184 
185     uint256 private _status;
186 
187     constructor() {
188         _status = _NOT_ENTERED;
189     }
190 
191     /**
192      * @dev Prevents a contract from calling itself, directly or indirectly.
193      * Calling a `nonReentrant` function from another `nonReentrant`
194      * function is not supported. It is possible to prevent this from happening
195      * by making the `nonReentrant` function external, and make it call a
196      * `private` function that does the actual work.
197      */
198     modifier nonReentrant() {
199         // On the first call to nonReentrant, _notEntered will be true
200         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
201 
202         // Any calls to nonReentrant after this point will fail
203         _status = _ENTERED;
204 
205         _;
206 
207         // By storing the original value once again, a refund is triggered (see
208         // https://eips.ethereum.org/EIPS/eip-2200)
209         _status = _NOT_ENTERED;
210     }
211 }
212 
213 pragma solidity ^0.8.4;
214 
215 /**
216  * @dev Interface of the ERC165 standard, as defined in the
217  * https://eips.ethereum.org/EIPS/eip-165[EIP].
218  *
219  * Implementers can declare support of contract interfaces, which can then be
220  * queried by others ({ERC165Checker}).
221  *
222  * For an implementation, see {ERC165}.
223  */
224 interface IERC165 {
225     /**
226      * @dev Returns true if this contract implements the interface defined by
227      * `interfaceId`. See the corresponding
228      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
229      * to learn more about how these ids are created.
230      *
231      * This function call must use less than 30 000 gas.
232      */
233     function supportsInterface(bytes4 interfaceId) external view returns (bool);
234 }
235 
236 pragma solidity ^0.8.4;
237 
238 /**
239  * @dev Required interface of an ERC721 compliant contract.
240  */
241 interface IERC721 is IERC165 {
242     /**
243      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
244      */
245     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
246 
247     /**
248      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
249      */
250     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
251 
252     /**
253      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
254      */
255     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
256 
257     /**
258      * @dev Returns the number of tokens in ``owner``'s account.
259      */
260     function balanceOf(address owner) external view returns (uint256 balance);
261 
262     /**
263      * @dev Returns the owner of the `tokenId` token.
264      *
265      * Requirements:
266      *
267      * - `tokenId` must exist.
268      */
269     function ownerOf(uint256 tokenId) external view returns (address owner);
270 
271     /**
272      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
273      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
274      *
275      * Requirements:
276      *
277      * - `from` cannot be the zero address.
278      * - `to` cannot be the zero address.
279      * - `tokenId` token must exist and be owned by `from`.
280      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
281      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
282      *
283      * Emits a {Transfer} event.
284      */
285     function safeTransferFrom(
286         address from,
287         address to,
288         uint256 tokenId
289     ) external;
290 
291     /**
292      * @dev Transfers `tokenId` token from `from` to `to`.
293      *
294      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
295      *
296      * Requirements:
297      *
298      * - `from` cannot be the zero address.
299      * - `to` cannot be the zero address.
300      * - `tokenId` token must be owned by `from`.
301      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
302      *
303      * Emits a {Transfer} event.
304      */
305     function transferFrom(
306         address from,
307         address to,
308         uint256 tokenId
309     ) external;
310 
311     /**
312      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
313      * The approval is cleared when the token is transferred.
314      *
315      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
316      *
317      * Requirements:
318      *
319      * - The caller must own the token or be an approved operator.
320      * - `tokenId` must exist.
321      *
322      * Emits an {Approval} event.
323      */
324     function approve(address to, uint256 tokenId) external;
325 
326     /**
327      * @dev Returns the account approved for `tokenId` token.
328      *
329      * Requirements:
330      *
331      * - `tokenId` must exist.
332      */
333     function getApproved(uint256 tokenId) external view returns (address operator);
334 
335     /**
336      * @dev Approve or remove `operator` as an operator for the caller.
337      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
338      *
339      * Requirements:
340      *
341      * - The `operator` cannot be the caller.
342      *
343      * Emits an {ApprovalForAll} event.
344      */
345     function setApprovalForAll(address operator, bool _approved) external;
346 
347     /**
348      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
349      *
350      * See {setApprovalForAll}
351      */
352     function isApprovedForAll(address owner, address operator) external view returns (bool);
353 
354     /**
355      * @dev Safely transfers `tokenId` token from `from` to `to`.
356      *
357      * Requirements:
358      *
359      * - `from` cannot be the zero address.
360      * - `to` cannot be the zero address.
361      * - `tokenId` token must exist and be owned by `from`.
362      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
363      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
364      *
365      * Emits a {Transfer} event.
366      */
367     function safeTransferFrom(
368         address from,
369         address to,
370         uint256 tokenId,
371         bytes calldata data
372     ) external;
373 }
374 
375 pragma solidity ^0.8.4;
376 
377 
378 /**
379  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
380  * @dev See https://eips.ethereum.org/EIPS/eip-721
381  */
382 interface IERC721Enumerable is IERC721 {
383     /**
384      * @dev Returns the total amount of tokens stored by the contract.
385      */
386     function totalSupply() external view returns (uint256);
387 
388     /**
389      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
390      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
391      */
392     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
393 
394     /**
395      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
396      * Use along with {totalSupply} to enumerate all tokens.
397      */
398     function tokenByIndex(uint256 index) external view returns (uint256);
399 }
400 
401 pragma solidity ^0.8.4;
402 
403 /**
404  * @title ERC721 token receiver interface
405  * @dev Interface for any contract that wants to support safeTransfers
406  * from ERC721 asset contracts.
407  */
408 interface IERC721Receiver {
409     /**
410      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
411      * by `operator` from `from`, this function is called.
412      *
413      * It must return its Solidity selector to confirm the token transfer.
414      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
415      *
416      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
417      */
418     function onERC721Received(
419         address operator,
420         address from,
421         uint256 tokenId,
422         bytes calldata data
423     ) external returns (bytes4);
424 }
425 
426 pragma solidity ^0.8.4;
427 
428 /**
429  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
430  * @dev See https://eips.ethereum.org/EIPS/eip-721
431  */
432 interface IERC721Metadata is IERC721 {
433     /**
434      * @dev Returns the token collection name.
435      */
436     function name() external view returns (string memory);
437 
438     /**
439      * @dev Returns the token collection symbol.
440      */
441     function symbol() external view returns (string memory);
442 
443     /**
444      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
445      */
446     function tokenURI(uint256 tokenId) external view returns (string memory);
447 }
448 
449 
450 pragma solidity ^0.8.4;
451 
452 /**
453  * @dev Collection of functions related to the address type
454  */
455 library Address {
456     /**
457      * @dev Returns true if `account` is a contract.
458      *
459      * [IMPORTANT]
460      * ====
461      * It is unsafe to assume that an address for which this function returns
462      * false is an externally-owned account (EOA) and not a contract.
463      *
464      * Among others, `isContract` will return false for the following
465      * types of addresses:
466      *
467      *  - an externally-owned account
468      *  - a contract in construction
469      *  - an address where a contract will be created
470      *  - an address where a contract lived, but was destroyed
471      * ====
472      */
473     function isContract(address account) internal view returns (bool) {
474         // This method relies on extcodesize, which returns 0 for contracts in
475         // construction, since the code is only stored at the end of the
476         // constructor execution.
477 
478         uint256 size;
479         assembly {
480             size := extcodesize(account)
481         }
482         return size > 0;
483     }
484 
485     /**
486      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
487      * `recipient`, forwarding all available gas and reverting on errors.
488      *
489      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
490      * of certain opcodes, possibly making contracts go over the 2300 gas limit
491      * imposed by `transfer`, making them unable to receive funds via
492      * `transfer`. {sendValue} removes this limitation.
493      *
494      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
495      *
496      * IMPORTANT: because control is transferred to `recipient`, care must be
497      * taken to not create reentrancy vulnerabilities. Consider using
498      * {ReentrancyGuard} or the
499      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
500      */
501     function sendValue(address payable recipient, uint256 amount) internal {
502         require(address(this).balance >= amount, "Address: insufficient balance");
503 
504         (bool success, ) = recipient.call{value: amount}("");
505         require(success, "Address: unable to send value, recipient may have reverted");
506     }
507 
508     /**
509      * @dev Performs a Solidity function call using a low level `call`. A
510      * plain `call` is an unsafe replacement for a function call: use this
511      * function instead.
512      *
513      * If `target` reverts with a revert reason, it is bubbled up by this
514      * function (like regular Solidity function calls).
515      *
516      * Returns the raw returned data. To convert to the expected return value,
517      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
518      *
519      * Requirements:
520      *
521      * - `target` must be a contract.
522      * - calling `target` with `data` must not revert.
523      *
524      * _Available since v3.1._
525      */
526     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
527         return functionCall(target, data, "Address: low-level call failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
532      * `errorMessage` as a fallback revert reason when `target` reverts.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(
537         address target,
538         bytes memory data,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         return functionCallWithValue(target, data, 0, errorMessage);
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
546      * but also transferring `value` wei to `target`.
547      *
548      * Requirements:
549      *
550      * - the calling contract must have an ETH balance of at least `value`.
551      * - the called Solidity function must be `payable`.
552      *
553      * _Available since v3.1._
554      */
555     function functionCallWithValue(
556         address target,
557         bytes memory data,
558         uint256 value
559     ) internal returns (bytes memory) {
560         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
565      * with `errorMessage` as a fallback revert reason when `target` reverts.
566      *
567      * _Available since v3.1._
568      */
569     function functionCallWithValue(
570         address target,
571         bytes memory data,
572         uint256 value,
573         string memory errorMessage
574     ) internal returns (bytes memory) {
575         require(address(this).balance >= value, "Address: insufficient balance for call");
576         require(isContract(target), "Address: call to non-contract");
577 
578         (bool success, bytes memory returndata) = target.call{value: value}(data);
579         return verifyCallResult(success, returndata, errorMessage);
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
584      * but performing a static call.
585      *
586      * _Available since v3.3._
587      */
588     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
589         return functionStaticCall(target, data, "Address: low-level static call failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
594      * but performing a static call.
595      *
596      * _Available since v3.3._
597      */
598     function functionStaticCall(
599         address target,
600         bytes memory data,
601         string memory errorMessage
602     ) internal view returns (bytes memory) {
603         require(isContract(target), "Address: static call to non-contract");
604 
605         (bool success, bytes memory returndata) = target.staticcall(data);
606         return verifyCallResult(success, returndata, errorMessage);
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
611      * but performing a delegate call.
612      *
613      * _Available since v3.4._
614      */
615     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
616         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
621      * but performing a delegate call.
622      *
623      * _Available since v3.4._
624      */
625     function functionDelegateCall(
626         address target,
627         bytes memory data,
628         string memory errorMessage
629     ) internal returns (bytes memory) {
630         require(isContract(target), "Address: delegate call to non-contract");
631 
632         (bool success, bytes memory returndata) = target.delegatecall(data);
633         return verifyCallResult(success, returndata, errorMessage);
634     }
635 
636     /**
637      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
638      * revert reason using the provided one.
639      *
640      * _Available since v4.3._
641      */
642     function verifyCallResult(
643         bool success,
644         bytes memory returndata,
645         string memory errorMessage
646     ) internal pure returns (bytes memory) {
647         if (success) {
648             return returndata;
649         } else {
650             // Look for revert reason and bubble it up if present
651             if (returndata.length > 0) {
652                 // The easiest way to bubble the revert reason is using memory via assembly
653 
654                 assembly {
655                     let returndata_size := mload(returndata)
656                     revert(add(32, returndata), returndata_size)
657                 }
658             } else {
659                 revert(errorMessage);
660             }
661         }
662     }
663 }
664 
665 
666 pragma solidity ^0.8.4;
667 
668 /**
669  * @dev Implementation of the {IERC165} interface.
670  *
671  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
672  * for the additional interface id that will be supported. For example:
673  *
674  * ```solidity
675  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
676  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
677  * }
678  * ```
679  *
680  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
681  */
682 abstract contract ERC165 is IERC165 {
683     /**
684      * @dev See {IERC165-supportsInterface}.
685      */
686     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
687         return interfaceId == type(IERC165).interfaceId;
688     }
689 }
690 pragma solidity ^0.8.4;
691 
692 abstract contract ERC721P is Context, ERC165, IERC721, IERC721Metadata {
693     using Address for address;
694     string private _name;
695     string private _symbol;
696     address[] internal _owners;
697     mapping(uint256 => address) private _tokenApprovals;
698     mapping(address => mapping(address => bool)) private _operatorApprovals;
699     constructor(string memory name_, string memory symbol_) {
700         _name = name_;
701         _symbol = symbol_;
702     }
703     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
704         return
705         interfaceId == type(IERC721).interfaceId ||
706         interfaceId == type(IERC721Metadata).interfaceId ||
707         super.supportsInterface(interfaceId);
708     }
709     function balanceOf(address owner) public view virtual override returns (uint256) {
710         require(owner != address(0), "ERC721: balance query for the zero address");
711         uint count = 0;
712         uint length = _owners.length;
713         for( uint i = 0; i < length; ++i ){
714             if( owner == _owners[i] ){
715                 ++count;
716             }
717         }
718         delete length;
719         return count;
720     }
721     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
722         address owner = _owners[tokenId];
723         require(owner != address(0), "ERC721: owner query for nonexistent token");
724         return owner;
725     }
726     function name() public view virtual override returns (string memory) {
727         return _name;
728     }
729     function symbol() public view virtual override returns (string memory) {
730         return _symbol;
731     }
732     function approve(address to, uint256 tokenId) public virtual override {
733         address owner = ERC721P.ownerOf(tokenId);
734         require(to != owner, "ERC721: approval to current owner");
735 
736         require(
737             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
738             "ERC721: approve caller is not owner nor approved for all"
739         );
740 
741         _approve(to, tokenId);
742     }
743     function getApproved(uint256 tokenId) public view virtual override returns (address) {
744         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
745 
746         return _tokenApprovals[tokenId];
747     }
748     function setApprovalForAll(address operator, bool approved) public virtual override {
749         require(operator != _msgSender(), "ERC721: approve to caller");
750 
751         _operatorApprovals[_msgSender()][operator] = approved;
752         emit ApprovalForAll(_msgSender(), operator, approved);
753     }
754     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
755         return _operatorApprovals[owner][operator];
756     }
757     function transferFrom(
758         address from,
759         address to,
760         uint256 tokenId
761     ) public virtual override {
762         //solhint-disable-next-line max-line-length
763         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
764 
765         _transfer(from, to, tokenId);
766     }
767     function safeTransferFrom(
768         address from,
769         address to,
770         uint256 tokenId
771     ) public virtual override {
772         safeTransferFrom(from, to, tokenId, "");
773     }
774     function safeTransferFrom(
775         address from,
776         address to,
777         uint256 tokenId,
778         bytes memory _data
779     ) public virtual override {
780         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
781         _safeTransfer(from, to, tokenId, _data);
782     }
783     function _safeTransfer(
784         address from,
785         address to,
786         uint256 tokenId,
787         bytes memory _data
788     ) internal virtual {
789         _transfer(from, to, tokenId);
790         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
791     }
792     function _exists(uint256 tokenId) internal view virtual returns (bool) {
793         return tokenId < _owners.length && _owners[tokenId] != address(0);
794     }
795     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
796         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
797         address owner = ERC721P.ownerOf(tokenId);
798         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
799     }
800     function _safeMint(address to, uint256 tokenId) internal virtual {
801         _safeMint(to, tokenId, "");
802     }
803     function _safeMint(
804         address to,
805         uint256 tokenId,
806         bytes memory _data
807     ) internal virtual {
808         _mint(to, tokenId);
809         require(
810             _checkOnERC721Received(address(0), to, tokenId, _data),
811             "ERC721: transfer to non ERC721Receiver implementer"
812         );
813     }
814     function _mint(address to, uint256 tokenId) internal virtual {
815         require(to != address(0), "ERC721: mint to the zero address");
816         require(!_exists(tokenId), "ERC721: token already minted");
817 
818         _beforeTokenTransfer(address(0), to, tokenId);
819         _owners.push(to);
820 
821         emit Transfer(address(0), to, tokenId);
822     }
823     function _burn(uint256 tokenId) internal virtual {
824         address owner = ERC721P.ownerOf(tokenId);
825 
826         _beforeTokenTransfer(owner, address(0), tokenId);
827 
828         // Clear approvals
829         _approve(address(0), tokenId);
830         _owners[tokenId] = address(0);
831 
832         emit Transfer(owner, address(0), tokenId);
833     }
834     function _transfer(
835         address from,
836         address to,
837         uint256 tokenId
838     ) internal virtual {
839         require(ERC721P.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
840         require(to != address(0), "ERC721: transfer to the zero address");
841 
842         _beforeTokenTransfer(from, to, tokenId);
843 
844         // Clear approvals from the previous owner
845         _approve(address(0), tokenId);
846         _owners[tokenId] = to;
847 
848         emit Transfer(from, to, tokenId);
849     }
850     function _approve(address to, uint256 tokenId) internal virtual {
851         _tokenApprovals[tokenId] = to;
852         emit Approval(ERC721P.ownerOf(tokenId), to, tokenId);
853     }
854     function _checkOnERC721Received(
855         address from,
856         address to,
857         uint256 tokenId,
858         bytes memory _data
859     ) private returns (bool) {
860         if (to.isContract()) {
861             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
862                 return retval == IERC721Receiver.onERC721Received.selector;
863             } catch (bytes memory reason) {
864                 if (reason.length == 0) {
865                     revert("ERC721: transfer to non ERC721Receiver implementer");
866                 } else {
867                     assembly {
868                         revert(add(32, reason), mload(reason))
869                     }
870                 }
871             }
872         } else {
873             return true;
874         }
875     }
876     function _beforeTokenTransfer(
877         address from,
878         address to,
879         uint256 tokenId
880     ) internal virtual {}
881 }
882 
883 pragma solidity ^0.8.4;
884 
885 abstract contract ERC721Enum is ERC721P, IERC721Enumerable {
886     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721P) returns (bool) {
887         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
888     }
889     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
890         require(index < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
891         uint count;
892         for( uint i; i < _owners.length; ++i ){
893             if( owner == _owners[i] ){
894                 if( count == index )
895                     return i;
896                 else
897                     ++count;
898             }
899         }
900         require(false, "ERC721Enum: owner ioob");
901     }
902     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
903         require(0 < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
904         uint256 tokenCount = balanceOf(owner);
905         uint256[] memory tokenIds = new uint256[](tokenCount);
906         for (uint256 i = 0; i < tokenCount; i++) {
907             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
908         }
909         return tokenIds;
910     }
911     function totalSupply() public view virtual override returns (uint256) {
912         return _owners.length;
913     }
914     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
915         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
916         return index;
917     }
918 }
919 
920 pragma solidity ^0.8.4;
921 
922 interface IWatcher {
923     function watchTransfer(address _from, address _to, uint256 _tokenId) external;
924 }
925 
926 contract MutantFloki is ERC721Enum, Ownable, ReentrancyGuard {
927     using Strings for uint256;
928 
929     //sale settings
930     uint256 constant private MAX_SUPPLY = 4200;
931     uint256 constant private MAX_PRESALE_MINT = 2;
932     uint256 private TEAM_RESERVE_AVAILABLE_MINTS = 50;
933     uint256 private COST = 0.069 ether;
934     uint256 private MAX_SALE_MINT = 5;
935     address public _trustedContract = 0x0000000000000000000000000000000000000000;
936 
937     bool public isPresaleActive = false;
938     bool public isSaleActive = false;
939 
940     //presale settings
941     mapping(address => bool) public presaleWhitelist;
942     mapping(address => uint256) public presaleWhitelistMints;
943 
944     string private baseURI;
945 
946     constructor(
947         string memory _name,
948         string memory _symbol
949     ) ERC721P(_name, _symbol) {}
950 
951     // internal
952     function _baseURI() internal view virtual returns (string memory) {
953         return baseURI;
954     }
955 
956     function _publicSupply() internal view virtual returns (uint256) {
957         return MAX_SUPPLY - TEAM_RESERVE_AVAILABLE_MINTS;
958     }
959 
960     function _transferNotice(address _from, address _to, uint256 _tokenId) internal {
961         if (_trustedContract != address(0)) {
962             IWatcher(_trustedContract).watchTransfer(_from, _to, _tokenId);
963         }
964     }
965 
966     // external
967     function isWhitelisted (address _address) external view returns (bool) {
968         return presaleWhitelist[_address];
969     }
970 
971     function setTrustedContract(address _contractAddress) public onlyOwner {
972         _trustedContract = _contractAddress;
973     }
974 
975     function flipPresaleState() external onlyOwner {
976         isPresaleActive = !isPresaleActive;
977     }
978 
979     function flipSaleState() external onlyOwner {
980         isSaleActive = !isSaleActive;
981     }
982 
983     function mint(uint256 _mintAmount) external payable {
984         require(isSaleActive, "Sale is not active");
985         require(_mintAmount > 0, "Minted amount should be positive" );
986         require(_mintAmount <= MAX_SALE_MINT, "Minted amount exceeds sale limit" );
987 
988         uint256 totalSupply = totalSupply();
989 
990         require(totalSupply + _mintAmount <= _publicSupply(), "The requested amount exceeds the remaining supply" );
991         require(msg.value >= COST * _mintAmount);
992 
993         for (uint256 i = 0; i < _mintAmount; i++) {
994             _safeMint(msg.sender, totalSupply + i);
995         }
996     }
997 
998     function mintPresale(uint256 _mintAmount) external payable {
999         require(isPresaleActive, "Presale is not active");
1000         require(presaleWhitelist[msg.sender], "Caller is not whitelisted");
1001 
1002         uint256 totalSupply = totalSupply();
1003         uint256 availableMints = MAX_PRESALE_MINT - presaleWhitelistMints[msg.sender];
1004 
1005         require(_mintAmount <= availableMints, "Too many mints requested");
1006         require(totalSupply + _mintAmount <= _publicSupply(), "The requested amount exceeds the remaining supply");
1007         require(msg.value >= COST * _mintAmount , "Wrong amount provided");
1008 
1009         presaleWhitelistMints[msg.sender] += _mintAmount;
1010 
1011         for(uint256 i = 0; i < _mintAmount; i++){
1012             _safeMint(msg.sender, totalSupply + i);
1013         }
1014     }
1015 
1016     function withdraw() external onlyOwner {
1017         require(payable(msg.sender).send(address(this).balance));
1018     }
1019 
1020     function addToWhitelist(address[] calldata _addresses) external onlyOwner {
1021         for (uint256 i = 0; i < _addresses.length; i++) {
1022             require(_addresses[i] != address(0), "Null address is not allowed");
1023             presaleWhitelist[_addresses[i]] = true;
1024             presaleWhitelistMints[_addresses[i]] > 0 ? presaleWhitelistMints[_addresses[i]] : 0;
1025         }
1026     }
1027 
1028     function setCost(uint256 _newCost) external onlyOwner {
1029         COST = _newCost;
1030     }
1031 
1032     function setMaxMintAmount(uint256 _newMaxMintAmount) external onlyOwner {
1033         MAX_SALE_MINT = _newMaxMintAmount;
1034     }
1035 
1036     function tokenURI(uint256 _tokenId) external view virtual override returns (string memory) {
1037         require(_exists(_tokenId), "ERC721Metadata: Nonexistent token");
1038         string memory currentBaseURI = _baseURI();
1039         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
1040     }
1041 
1042     // admin minting
1043      function reserve(address _to, uint256 _reserveAmount) public onlyOwner {
1044         uint256 supply = totalSupply();
1045         require(
1046             _reserveAmount > 0 && _reserveAmount <= TEAM_RESERVE_AVAILABLE_MINTS,
1047             "Not enough reserve left for team"
1048         );
1049         for (uint256 i = 0; i < _reserveAmount; i++) {
1050             _safeMint(_to, supply + i);
1051         }
1052         TEAM_RESERVE_AVAILABLE_MINTS -= _reserveAmount;
1053     }
1054 
1055     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1056         baseURI = _newBaseURI;
1057     }
1058 
1059     function transferFrom(address _from, address _to, uint256 _tokenId) public override {
1060         ERC721P.transferFrom(_from, _to, _tokenId);
1061         _transferNotice(_from, _to, _tokenId);
1062     }
1063 
1064     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public override {
1065         ERC721P.safeTransferFrom(_from, _to, _tokenId, _data);
1066         _transferNotice(_from, _to, _tokenId);
1067     }
1068 }