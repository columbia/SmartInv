1 // File: src/contracts/Context.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: src/contracts/Ownable.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _setOwner(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         _setOwner(address(0));
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         _setOwner(newOwner);
90     }
91 
92     function _setOwner(address newOwner) private {
93         address oldOwner = _owner;
94         _owner = newOwner;
95         emit OwnershipTransferred(oldOwner, newOwner);
96     }
97 }
98 
99 // File: src/contracts/ReentrancyGuard.sol
100 
101 
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Contract module that helps prevent reentrant calls to a function.
107  *
108  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
109  * available, which can be applied to functions to make sure there are no nested
110  * (reentrant) calls to them.
111  *
112  * Note that because there is a single `nonReentrant` guard, functions marked as
113  * `nonReentrant` may not call one another. This can be worked around by making
114  * those functions `private`, and then adding `external` `nonReentrant` entry
115  * points to them.
116  *
117  * TIP: If you would like to learn more about reentrancy and alternative ways
118  * to protect against it, check out our blog post
119  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
120  */
121 abstract contract ReentrancyGuard {
122     // Booleans are more expensive than uint256 or any type that takes up a full
123     // word because each write operation emits an extra SLOAD to first read the
124     // slot's contents, replace the bits taken up by the boolean, and then write
125     // back. This is the compiler's defense against contract upgrades and
126     // pointer aliasing, and it cannot be disabled.
127 
128     // The values being non-zero value makes deployment a bit more expensive,
129     // but in exchange the refund on every call to nonReentrant will be lower in
130     // amount. Since refunds are capped to a percentage of the total
131     // transaction's gas, it is best to keep them low in cases like this one, to
132     // increase the likelihood of the full refund coming into effect.
133     uint256 private constant _NOT_ENTERED = 1;
134     uint256 private constant _ENTERED = 2;
135 
136     uint256 private _status;
137 
138     constructor() {
139         _status = _NOT_ENTERED;
140     }
141 
142     /**
143      * @dev Prevents a contract from calling itself, directly or indirectly.
144      * Calling a `nonReentrant` function from another `nonReentrant`
145      * function is not supported. It is possible to prevent this from happening
146      * by making the `nonReentrant` function external, and make it call a
147      * `private` function that does the actual work.
148      */
149     modifier nonReentrant() {
150         // On the first call to nonReentrant, _notEntered will be true
151         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
152 
153         // Any calls to nonReentrant after this point will fail
154         _status = _ENTERED;
155 
156         _;
157 
158         // By storing the original value once again, a refund is triggered (see
159         // https://eips.ethereum.org/EIPS/eip-2200)
160         _status = _NOT_ENTERED;
161     }
162 }
163 
164 // File: src/contracts/IERC165.sol
165 
166 
167 
168 pragma solidity ^0.8.0;
169 
170 /**
171  * @dev Interface of the ERC165 standard, as defined in the
172  * https://eips.ethereum.org/EIPS/eip-165[EIP].
173  *
174  * Implementers can declare support of contract interfaces, which can then be
175  * queried by others ({ERC165Checker}).
176  *
177  * For an implementation, see {ERC165}.
178  */
179 interface IERC165 {
180     /**
181      * @dev Returns true if this contract implements the interface defined by
182      * `interfaceId`. See the corresponding
183      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
184      * to learn more about how these ids are created.
185      *
186      * This function call must use less than 30 000 gas.
187      */
188     function supportsInterface(bytes4 interfaceId) external view returns (bool);
189 }
190 
191 // File: src/contracts/IERC721.sol
192 
193 
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @dev Required interface of an ERC721 compliant contract.
199  */
200 interface IERC721 is IERC165 {
201     /**
202      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
203      */
204     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
205 
206     /**
207      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
208      */
209     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
210 
211     /**
212      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
213      */
214     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
215 
216     /**
217      * @dev Returns the number of tokens in ``owner``'s account.
218      */
219     function balanceOf(address owner) external view returns (uint256 balance);
220 
221     /**
222      * @dev Returns the owner of the `tokenId` token.
223      *
224      * Requirements:
225      *
226      * - `tokenId` must exist.
227      */
228     function ownerOf(uint256 tokenId) external view returns (address owner);
229 
230     /**
231      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
232      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
233      *
234      * Requirements:
235      *
236      * - `from` cannot be the zero address.
237      * - `to` cannot be the zero address.
238      * - `tokenId` token must exist and be owned by `from`.
239      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
240      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
241      *
242      * Emits a {Transfer} event.
243      */
244     function safeTransferFrom(
245         address from,
246         address to,
247         uint256 tokenId
248     ) external;
249 
250     /**
251      * @dev Transfers `tokenId` token from `from` to `to`.
252      *
253      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
254      *
255      * Requirements:
256      *
257      * - `from` cannot be the zero address.
258      * - `to` cannot be the zero address.
259      * - `tokenId` token must be owned by `from`.
260      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
261      *
262      * Emits a {Transfer} event.
263      */
264     function transferFrom(
265         address from,
266         address to,
267         uint256 tokenId
268     ) external;
269 
270     /**
271      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
272      * The approval is cleared when the token is transferred.
273      *
274      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
275      *
276      * Requirements:
277      *
278      * - The caller must own the token or be an approved operator.
279      * - `tokenId` must exist.
280      *
281      * Emits an {Approval} event.
282      */
283     function approve(address to, uint256 tokenId) external;
284 
285     /**
286      * @dev Returns the account approved for `tokenId` token.
287      *
288      * Requirements:
289      *
290      * - `tokenId` must exist.
291      */
292     function getApproved(uint256 tokenId) external view returns (address operator);
293 
294     /**
295      * @dev Approve or remove `operator` as an operator for the caller.
296      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
297      *
298      * Requirements:
299      *
300      * - The `operator` cannot be the caller.
301      *
302      * Emits an {ApprovalForAll} event.
303      */
304     function setApprovalForAll(address operator, bool _approved) external;
305 
306     /**
307      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
308      *
309      * See {setApprovalForAll}
310      */
311     function isApprovedForAll(address owner, address operator) external view returns (bool);
312 
313     /**
314      * @dev Safely transfers `tokenId` token from `from` to `to`.
315      *
316      * Requirements:
317      *
318      * - `from` cannot be the zero address.
319      * - `to` cannot be the zero address.
320      * - `tokenId` token must exist and be owned by `from`.
321      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
322      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
323      *
324      * Emits a {Transfer} event.
325      */
326     function safeTransferFrom(
327         address from,
328         address to,
329         uint256 tokenId,
330         bytes calldata data
331     ) external;
332 }
333 
334 // File: src/contracts/IERC721Receiver.sol
335 
336 
337 
338 pragma solidity ^0.8.0;
339 
340 /**
341  * @title ERC721 token receiver interface
342  * @dev Interface for any contract that wants to support safeTransfers
343  * from ERC721 asset contracts.
344  */
345 interface IERC721Receiver {
346     /**
347      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
348      * by `operator` from `from`, this function is called.
349      *
350      * It must return its Solidity selector to confirm the token transfer.
351      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
352      *
353      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
354      */
355     function onERC721Received(
356         address operator,
357         address from,
358         uint256 tokenId,
359         bytes calldata data
360     ) external returns (bytes4);
361 }
362 
363 // File: src/contracts/IERC721Metadata.sol
364 
365 
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
371  * @dev See https://eips.ethereum.org/EIPS/eip-721
372  */
373 interface IERC721Metadata is IERC721 {
374     /**
375      * @dev Returns the token collection name.
376      */
377     function name() external view returns (string memory);
378 
379     /**
380      * @dev Returns the token collection symbol.
381      */
382     function symbol() external view returns (string memory);
383 
384     /**
385      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
386      */
387     function tokenURI(uint256 tokenId) external view returns (string memory);
388 }
389 
390 // File: src/contracts/IERC721Enumerable.sol
391 
392 
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
398  * @dev See https://eips.ethereum.org/EIPS/eip-721
399  */
400 interface IERC721Enumerable is IERC721 {
401     /**
402      * @dev Returns the total amount of tokens stored by the contract.
403      */
404     function totalSupply() external view returns (uint256);
405 
406     /**
407      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
408      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
409      */
410     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
411 
412     /**
413      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
414      * Use along with {totalSupply} to enumerate all tokens.
415      */
416     function tokenByIndex(uint256 index) external view returns (uint256);
417 }
418 
419 // File: src/contracts/Address.sol
420 
421 
422 
423 pragma solidity ^0.8.0;
424 
425 /**
426  * @dev Collection of functions related to the address type
427  */
428 library Address {
429     /**
430      * @dev Returns true if `account` is a contract.
431      *
432      * [IMPORTANT]
433      * ====
434      * It is unsafe to assume that an address for which this function returns
435      * false is an externally-owned account (EOA) and not a contract.
436      *
437      * Among others, `isContract` will return false for the following
438      * types of addresses:
439      *
440      *  - an externally-owned account
441      *  - a contract in construction
442      *  - an address where a contract will be created
443      *  - an address where a contract lived, but was destroyed
444      * ====
445      */
446     function isContract(address account) internal view returns (bool) {
447         // This method relies on extcodesize, which returns 0 for contracts in
448         // construction, since the code is only stored at the end of the
449         // constructor execution.
450 
451         uint256 size;
452         assembly {
453             size := extcodesize(account)
454         }
455         return size > 0;
456     }
457 
458     /**
459      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
460      * `recipient`, forwarding all available gas and reverting on errors.
461      *
462      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
463      * of certain opcodes, possibly making contracts go over the 2300 gas limit
464      * imposed by `transfer`, making them unable to receive funds via
465      * `transfer`. {sendValue} removes this limitation.
466      *
467      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
468      *
469      * IMPORTANT: because control is transferred to `recipient`, care must be
470      * taken to not create reentrancy vulnerabilities. Consider using
471      * {ReentrancyGuard} or the
472      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
473      */
474     function sendValue(address payable recipient, uint256 amount) internal {
475         require(address(this).balance >= amount, "Address: insufficient balance");
476 
477         (bool success, ) = recipient.call{value: amount}("");
478         require(success, "Address: unable to send value, recipient may have reverted");
479     }
480 
481     /**
482      * @dev Performs a Solidity function call using a low level `call`. A
483      * plain `call` is an unsafe replacement for a function call: use this
484      * function instead.
485      *
486      * If `target` reverts with a revert reason, it is bubbled up by this
487      * function (like regular Solidity function calls).
488      *
489      * Returns the raw returned data. To convert to the expected return value,
490      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
491      *
492      * Requirements:
493      *
494      * - `target` must be a contract.
495      * - calling `target` with `data` must not revert.
496      *
497      * _Available since v3.1._
498      */
499     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
500         return functionCall(target, data, "Address: low-level call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
505      * `errorMessage` as a fallback revert reason when `target` reverts.
506      *
507      * _Available since v3.1._
508      */
509     function functionCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal returns (bytes memory) {
514         return functionCallWithValue(target, data, 0, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but also transferring `value` wei to `target`.
520      *
521      * Requirements:
522      *
523      * - the calling contract must have an ETH balance of at least `value`.
524      * - the called Solidity function must be `payable`.
525      *
526      * _Available since v3.1._
527      */
528     function functionCallWithValue(
529         address target,
530         bytes memory data,
531         uint256 value
532     ) internal returns (bytes memory) {
533         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
538      * with `errorMessage` as a fallback revert reason when `target` reverts.
539      *
540      * _Available since v3.1._
541      */
542     function functionCallWithValue(
543         address target,
544         bytes memory data,
545         uint256 value,
546         string memory errorMessage
547     ) internal returns (bytes memory) {
548         require(address(this).balance >= value, "Address: insufficient balance for call");
549         require(isContract(target), "Address: call to non-contract");
550 
551         (bool success, bytes memory returndata) = target.call{value: value}(data);
552         return _verifyCallResult(success, returndata, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but performing a static call.
558      *
559      * _Available since v3.3._
560      */
561     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
562         return functionStaticCall(target, data, "Address: low-level static call failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
567      * but performing a static call.
568      *
569      * _Available since v3.3._
570      */
571     function functionStaticCall(
572         address target,
573         bytes memory data,
574         string memory errorMessage
575     ) internal view returns (bytes memory) {
576         require(isContract(target), "Address: static call to non-contract");
577 
578         (bool success, bytes memory returndata) = target.staticcall(data);
579         return _verifyCallResult(success, returndata, errorMessage);
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
584      * but performing a delegate call.
585      *
586      * _Available since v3.4._
587      */
588     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
589         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
594      * but performing a delegate call.
595      *
596      * _Available since v3.4._
597      */
598     function functionDelegateCall(
599         address target,
600         bytes memory data,
601         string memory errorMessage
602     ) internal returns (bytes memory) {
603         require(isContract(target), "Address: delegate call to non-contract");
604 
605         (bool success, bytes memory returndata) = target.delegatecall(data);
606         return _verifyCallResult(success, returndata, errorMessage);
607     }
608 
609     function _verifyCallResult(
610         bool success,
611         bytes memory returndata,
612         string memory errorMessage
613     ) private pure returns (bytes memory) {
614         if (success) {
615             return returndata;
616         } else {
617             // Look for revert reason and bubble it up if present
618             if (returndata.length > 0) {
619                 // The easiest way to bubble the revert reason is using memory via assembly
620 
621                 assembly {
622                     let returndata_size := mload(returndata)
623                     revert(add(32, returndata), returndata_size)
624                 }
625             } else {
626                 revert(errorMessage);
627             }
628         }
629     }
630 }
631 
632 // File: src/contracts/Strings.sol
633 
634 
635 
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @dev String operations.
640  */
641 library Strings {
642     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
643 
644     /**
645      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
646      */
647     function toString(uint256 value) internal pure returns (string memory) {
648         // Inspired by OraclizeAPI's implementation - MIT licence
649         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
650 
651         if (value == 0) {
652             return "0";
653         }
654         uint256 temp = value;
655         uint256 digits;
656         while (temp != 0) {
657             digits++;
658             temp /= 10;
659         }
660         bytes memory buffer = new bytes(digits);
661         while (value != 0) {
662             digits -= 1;
663             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
664             value /= 10;
665         }
666         return string(buffer);
667     }
668 
669     /**
670      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
671      */
672     function toHexString(uint256 value) internal pure returns (string memory) {
673         if (value == 0) {
674             return "0x00";
675         }
676         uint256 temp = value;
677         uint256 length = 0;
678         while (temp != 0) {
679             length++;
680             temp >>= 8;
681         }
682         return toHexString(value, length);
683     }
684 
685     /**
686      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
687      */
688     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
689         bytes memory buffer = new bytes(2 * length + 2);
690         buffer[0] = "0";
691         buffer[1] = "x";
692         for (uint256 i = 2 * length + 1; i > 1; --i) {
693             buffer[i] = _HEX_SYMBOLS[value & 0xf];
694             value >>= 4;
695         }
696         require(value == 0, "Strings: hex length insufficient");
697         return string(buffer);
698     }
699 }
700 
701 // File: src/contracts/ERC165.sol
702 
703 
704 
705 pragma solidity ^0.8.0;
706 
707 /**
708  * @dev Implementation of the {IERC165} interface.
709  *
710  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
711  * for the additional interface id that will be supported. For example:
712  *
713  * ```solidity
714  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
715  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
716  * }
717  * ```
718  *
719  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
720  */
721 abstract contract ERC165 is IERC165 {
722     /**
723      * @dev See {IERC165-supportsInterface}.
724      */
725     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
726         return interfaceId == type(IERC165).interfaceId;
727     }
728 }
729 
730 // File: src/contracts/ERC721A.sol
731 
732 
733 
734 pragma solidity ^0.8.0;
735 
736 
737 
738 
739 
740 
741 
742 
743 /**
744  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
745  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
746  *
747  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
748  *
749  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
750  *
751  * Does not support burning tokens to address(0).
752  */
753 contract ERC721A is
754   Context,
755   ERC165,
756   IERC721,
757   IERC721Metadata,
758   IERC721Enumerable
759 {
760   using Address for address;
761   using Strings for uint256;
762 
763   struct TokenOwnership {
764     address addr;
765     uint64 startTimestamp;
766   }
767 
768   struct AddressData {
769     uint128 balance;
770     uint128 numberMinted;
771   }
772 
773   struct TokenTrackNum {
774     uint trackNum;
775   }
776 
777   uint256 private currentIndex = 0;
778   uint256 internal immutable collectionSize;
779   uint256 internal immutable maxBatchSize;
780 
781   // Token name
782   string private _name;
783 
784   // Token symbol
785   string private _symbol;
786 
787   // Mapping from token ID to ownership details
788   // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
789   mapping(uint256 => TokenOwnership) private _ownerships;
790 
791   // Mapping from token ID to track number
792   mapping(uint256 => TokenTrackNum) private _trackNum;  
793 
794   // Mapping owner address to address data
795   mapping(address => AddressData) private _addressData;
796 
797   // Mapping from token ID to approved address
798   mapping(uint256 => address) private _tokenApprovals;
799 
800   // Mapping from owner to operator approvals
801   mapping(address => mapping(address => bool)) private _operatorApprovals;
802 
803   /**
804    * @dev
805    * `maxBatchSize_` refers to how much a minter can mint at a time.
806    * `collectionSize_` refers to how many tokens are in the collection.
807    */
808   constructor(
809     string memory name_,
810     string memory symbol_,
811     uint256 maxBatchSize_,
812     uint256 collectionSize_
813   ) {
814     require(
815       collectionSize_ > 0,
816       "ERC721A: collection must have a nonzero supply"
817     );
818     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
819     _name = name_;
820     _symbol = symbol_;
821     maxBatchSize = maxBatchSize_;
822     collectionSize = collectionSize_;
823   }
824 
825   /**
826    * @dev See {IERC721Enumerable-totalSupply}.
827    */
828   function totalSupply() public view override returns (uint256) {
829     return currentIndex;
830   }
831 
832   /**
833    * @dev See {IERC721Enumerable-tokenByIndex}.
834    */
835   function tokenByIndex(uint256 index) public view override returns (uint256) {
836     require(index < totalSupply(), "ERC721A: global index out of bounds");
837     return index;
838   }
839 
840   /**
841    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
842    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
843    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
844    */
845   function tokenOfOwnerByIndex(address owner, uint256 index)
846     public
847     view
848     override
849     returns (uint256)
850   {
851     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
852     uint256 numMintedSoFar = totalSupply();
853     uint256 tokenIdsIdx = 0;
854     address currOwnershipAddr = address(0);
855 
856     for (uint256 i = 0; i < numMintedSoFar; i++) {
857       TokenOwnership memory ownership = _ownerships[i];
858       if (ownership.addr != address(0)) {
859         currOwnershipAddr = ownership.addr;
860       }
861       if (currOwnershipAddr == owner) {
862         if (tokenIdsIdx == index) {
863           return i;
864         }
865         tokenIdsIdx++;
866       }
867     }
868     
869     revert("ERC721A: unable to get token of owner by index");
870   }
871 
872   /**
873    * @dev See {IERC165-supportsInterface}.
874    */
875   function supportsInterface(bytes4 interfaceId)
876     public
877     view
878     virtual
879     override(ERC165, IERC165)
880     returns (bool)
881   {
882     return
883       interfaceId == type(IERC721).interfaceId ||
884       interfaceId == type(IERC721Metadata).interfaceId ||
885       interfaceId == type(IERC721Enumerable).interfaceId ||
886       super.supportsInterface(interfaceId);
887   }
888 
889   /**
890    * @dev See {IERC721-balanceOf}.
891    */
892   function balanceOf(address owner) public view override returns (uint256) {
893     require(owner != address(0), "ERC721A: balance query for the zero address");
894     return uint256(_addressData[owner].balance);
895   }
896 
897   function _numberMinted(address owner) internal view returns (uint256) {
898     require(
899       owner != address(0),
900       "ERC721A: number minted query for the zero address"
901     );
902     return uint256(_addressData[owner].numberMinted);
903   }
904 
905   function _ownershipOf(uint256 tokenId)
906     internal
907     view
908     returns (TokenOwnership memory)
909   {
910     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
911 
912     uint256 lowestTokenToCheck;
913     if (tokenId >= maxBatchSize) {
914       lowestTokenToCheck = tokenId - maxBatchSize + 1;
915     }
916 
917     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
918       TokenOwnership memory ownership = _ownerships[curr];
919       if (ownership.addr != address(0)) {
920         return ownership;
921       }
922     }
923 
924     revert("ERC721A: unable to determine the owner of token");
925   }
926 
927   /**
928    * @dev See {IERC721-ownerOf}.
929    */
930   function ownerOf(uint256 tokenId) public view override returns (address) {
931     return _ownershipOf(tokenId).addr;
932   }
933 
934   /**
935    * @dev See {IERC721Metadata-name}.
936    */
937   function name() public view virtual override returns (string memory) {
938     return _name;
939   }
940 
941   /**
942    * @dev See {IERC721Metadata-symbol}.
943    */
944   function symbol() public view virtual override returns (string memory) {
945     return _symbol;
946   }
947 
948   /**
949    * @dev See {IERC721Metadata-tokenURI}.
950    */
951   function tokenURI(uint256 tokenId)
952     public
953     view
954     virtual
955     override
956     returns (string memory)
957   {
958     require(
959       _exists(tokenId),
960       "ERC721Metadata: URI query for nonexistent token"
961     );
962 
963     string memory baseURI = _baseURI();
964     return
965       bytes(baseURI).length > 0
966         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
967         : "";
968 
969   }
970 
971   /**
972    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
973    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
974    * by default, can be overriden in child contracts.
975    */
976   function _baseURI() internal view virtual returns (string memory) {
977     return "";
978   }
979 
980   /**
981    * @dev See {IERC721-approve}.
982    */
983   function approve(address to, uint256 tokenId) public override {
984     address owner = ERC721A.ownerOf(tokenId);
985     require(to != owner, "ERC721A: approval to current owner");
986 
987     require(
988       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
989       "ERC721A: approve caller is not owner nor approved for all"
990     );
991 
992     _approve(to, tokenId, owner);
993   }
994 
995   /**
996    * @dev See {IERC721-getApproved}.
997    */
998   function getApproved(uint256 tokenId) public view override returns (address) {
999     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1000 
1001     return _tokenApprovals[tokenId];
1002   }
1003 
1004   /**
1005    * @dev See {IERC721-setApprovalForAll}.
1006    */
1007   function setApprovalForAll(address operator, bool approved) public override {
1008     require(operator != _msgSender(), "ERC721A: approve to caller");
1009 
1010     _operatorApprovals[_msgSender()][operator] = approved;
1011     emit ApprovalForAll(_msgSender(), operator, approved);
1012   }
1013 
1014   /**
1015    * @dev See {IERC721-isApprovedForAll}.
1016    */
1017   function isApprovedForAll(address owner, address operator)
1018     public
1019     view
1020     virtual
1021     override
1022     returns (bool)
1023   {
1024     return _operatorApprovals[owner][operator];
1025   }
1026 
1027   /**
1028    * @dev See {IERC721-transferFrom}.
1029    */
1030   function transferFrom(
1031     address from,
1032     address to,
1033     uint256 tokenId
1034   ) public override {
1035     _transfer(from, to, tokenId);
1036   }
1037 
1038   /**
1039    * @dev See {IERC721-safeTransferFrom}.
1040    */
1041   function safeTransferFrom(
1042     address from,
1043     address to,
1044     uint256 tokenId
1045   ) public override {
1046     safeTransferFrom(from, to, tokenId, "");
1047   }
1048 
1049   /**
1050    * @dev See {IERC721-safeTransferFrom}.
1051    */
1052   function safeTransferFrom(
1053     address from,
1054     address to,
1055     uint256 tokenId,
1056     bytes memory _data
1057   ) public override {
1058     _transfer(from, to, tokenId);
1059     require(
1060       _checkOnERC721Received(from, to, tokenId, _data),
1061       "ERC721A: transfer to non ERC721Receiver implementer"
1062     );
1063   }
1064 
1065   /**
1066    * @dev Returns whether `tokenId` exists.
1067    *
1068    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1069    *
1070    * Tokens start existing when they are minted (`_mint`),
1071    */
1072   function _exists(uint256 tokenId) internal view returns (bool) {
1073     return tokenId < currentIndex;
1074   }
1075 
1076   function _safeMint(address to, uint256 quantity) internal {
1077     _safeMint(to, quantity, "");
1078   }
1079 
1080   function _safeBatchMint(address to, uint256 quantity) internal {
1081     _safeBatchMint(to, quantity, "");
1082   }
1083 
1084   /**
1085    * @dev Mints `quantity` tokens and transfers them to `to`.
1086    *
1087    * Requirements:
1088    *
1089    * - there must be `quantity` tokens remaining unminted in the total collection.
1090    * - `to` cannot be the zero address.
1091    * - `quantity` cannot be larger than the max batch size.
1092    *
1093    * Emits a {Transfer} event.
1094    */
1095   function _safeMint(
1096     address to,
1097     uint256 quantity,
1098     bytes memory _data
1099   ) internal {
1100     uint256 startTokenId = currentIndex;
1101     require(to != address(0), "ERC721A: mint to the zero address");
1102 
1103     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1104     require(!_exists(startTokenId), "ERC721A: token already minted");
1105 
1106     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1107 
1108     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1109 
1110     AddressData memory addressData = _addressData[to];
1111 
1112     _addressData[to] = AddressData(
1113       addressData.balance + uint128(quantity),
1114       addressData.numberMinted + uint128(quantity)
1115     );
1116     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1117 
1118     uint256 updatedIndex = startTokenId;
1119 
1120     for (uint256 i = 0; i < quantity; i++) {
1121       emit Transfer(address(0), to, updatedIndex);
1122       require(
1123         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1124         "ERC721A: transfer to non ERC721Receiver implementer"
1125       );
1126       updatedIndex++;
1127     }
1128 
1129     currentIndex = updatedIndex;
1130     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1131   }
1132 
1133   function _safeBatchMint(
1134     address to,
1135     uint256 quantity,
1136     bytes memory _data
1137   ) internal {
1138     uint256 startTokenId = currentIndex;
1139     require(to != address(0), "ERC721A: mint to the zero address");
1140 
1141     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1142     require(!_exists(startTokenId), "ERC721A: token already minted");
1143 
1144     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1145 
1146     AddressData memory addressData = _addressData[to];
1147 
1148     _addressData[to] = AddressData(
1149       addressData.balance + uint128(quantity),
1150       addressData.numberMinted + uint128(quantity)
1151     );
1152     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1153 
1154     uint256 updatedIndex = startTokenId;
1155 
1156     for (uint256 i = 0; i < quantity; i++) {
1157       emit Transfer(address(0), to, updatedIndex);
1158       require(
1159         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1160         "ERC721A: transfer to non ERC721Receiver implementer"
1161       );
1162       updatedIndex++;
1163     }
1164 
1165     currentIndex = updatedIndex;
1166     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1167   }
1168 
1169   /**
1170    * @dev random get track numbers by minting quantity
1171    *
1172    * Requirements:
1173    *
1174    * - `quantity` how many ntfs be minted at once
1175    *
1176    */
1177   function _randomGetTrackNums(uint quantity) internal view returns (uint[] memory) {
1178     uint[] memory trackNums = new uint[](quantity);
1179     bytes32[] memory randVar = new bytes32[](quantity);
1180 
1181     // using random block info. to generate track number
1182     // these info. will be difference while every function call
1183     bytes32 randomHex = bytes32(uint256(uint160(tx.origin)) << 96);
1184     
1185     for (uint i = 1; i <= quantity; i++) {
1186       uint offset = i*4;
1187       uint index = i-1;
1188 
1189       randVar[index] = randomHex >> offset;
1190 
1191       uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, randVar[index], msg.sender))) % 5;
1192       trackNums[index] = randomNumber + 1;
1193     }
1194 
1195     return trackNums;
1196   }
1197 
1198   /**
1199    * @dev Transfers `tokenId` from `from` to `to`.
1200    *
1201    * Requirements:
1202    *
1203    * - `to` cannot be the zero address.
1204    * - `tokenId` token must be owned by `from`.
1205    *
1206    * Emits a {Transfer} event.
1207    */
1208   function _transfer(
1209     address from,
1210     address to,
1211     uint256 tokenId
1212   ) private {
1213     TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1214 
1215     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1216       getApproved(tokenId) == _msgSender() ||
1217       isApprovedForAll(prevOwnership.addr, _msgSender()));
1218 
1219     require(
1220       isApprovedOrOwner,
1221       "ERC721A: transfer caller is not owner nor approved"
1222     );
1223 
1224     require(
1225       prevOwnership.addr == from,
1226       "ERC721A: transfer from incorrect owner"
1227     );
1228     require(to != address(0), "ERC721A: transfer to the zero address");
1229 
1230     _beforeTokenTransfers(from, to, tokenId, 1);
1231 
1232     // Clear approvals from the previous owner
1233     _approve(address(0), tokenId, prevOwnership.addr);
1234 
1235     _addressData[from].balance -= 1;
1236     _addressData[to].balance += 1;
1237     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1238 
1239     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1240     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1241     uint256 nextTokenId = tokenId + 1;
1242     if (_ownerships[nextTokenId].addr == address(0)) {
1243       if (_exists(nextTokenId)) {
1244         _ownerships[nextTokenId] = TokenOwnership(
1245           prevOwnership.addr,
1246           prevOwnership.startTimestamp
1247         );
1248       }
1249     }
1250 
1251     emit Transfer(from, to, tokenId);
1252     _afterTokenTransfers(from, to, tokenId, 1);
1253   }
1254 
1255   /**
1256    * @dev Approve `to` to operate on `tokenId`
1257    *
1258    * Emits a {Approval} event.
1259    */
1260   function _approve(
1261     address to,
1262     uint256 tokenId,
1263     address owner
1264   ) private {
1265     _tokenApprovals[tokenId] = to;
1266     emit Approval(owner, to, tokenId);
1267   }
1268 
1269   uint256 public nextOwnerToExplicitlySet = 0;
1270 
1271   /**
1272    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1273    */
1274   function _setOwnersExplicit(uint256 quantity) internal {
1275     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1276     require(quantity > 0, "quantity must be nonzero");
1277     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1278     if (endIndex > collectionSize - 1) {
1279       endIndex = collectionSize - 1;
1280     }
1281     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1282     require(_exists(endIndex), "not enough minted yet for this cleanup");
1283     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1284       if (_ownerships[i].addr == address(0)) {
1285         TokenOwnership memory ownership = _ownershipOf(i);
1286         _ownerships[i] = TokenOwnership(
1287           ownership.addr,
1288           ownership.startTimestamp
1289         );
1290       }
1291     }
1292     nextOwnerToExplicitlySet = endIndex + 1;
1293   }
1294 
1295   /**
1296    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1297    * The call is not executed if the target address is not a contract.
1298    *
1299    * @param from address representing the previous owner of the given token ID
1300    * @param to target address that will receive the tokens
1301    * @param tokenId uint256 ID of the token to be transferred
1302    * @param _data bytes optional data to send along with the call
1303    * @return bool whether the call correctly returned the expected magic value
1304    */
1305   function _checkOnERC721Received(
1306     address from,
1307     address to,
1308     uint256 tokenId,
1309     bytes memory _data
1310   ) private returns (bool) {
1311     if (to.isContract()) {
1312       try
1313         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1314       returns (bytes4 retval) {
1315         return retval == IERC721Receiver(to).onERC721Received.selector;
1316       } catch (bytes memory reason) {
1317         if (reason.length == 0) {
1318           revert("ERC721A: transfer to non ERC721Receiver implementer");
1319         } else {
1320           assembly {
1321             revert(add(32, reason), mload(reason))
1322           }
1323         }
1324       }
1325     } else {
1326       return true;
1327     }
1328   }
1329 
1330   /**
1331    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1332    *
1333    * startTokenId - the first token id to be transferred
1334    * quantity - the amount to be transferred
1335    *
1336    * Calling conditions:
1337    *
1338    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1339    * transferred to `to`.
1340    * - When `from` is zero, `tokenId` will be minted for `to`.
1341    */
1342   function _beforeTokenTransfers(
1343     address from,
1344     address to,
1345     uint256 startTokenId,
1346     uint256 quantity
1347   ) internal virtual {}
1348 
1349   /**
1350    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1351    * minting.
1352    *
1353    * startTokenId - the first token id to be transferred
1354    * quantity - the amount to be transferred
1355    *
1356    * Calling conditions:
1357    *
1358    * - when `from` and `to` are both non-zero.
1359    * - `from` and `to` are never both zero.
1360    */
1361   function _afterTokenTransfers(
1362     address from,
1363     address to,
1364     uint256 startTokenId,
1365     uint256 quantity
1366   ) internal virtual {}
1367 }
1368 
1369 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1370 
1371 
1372 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1373 
1374 pragma solidity ^0.8.0;
1375 
1376 /**
1377  * @dev These functions deal with verification of Merkle Trees proofs.
1378  *
1379  * The proofs can be generated using the JavaScript library
1380  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1381  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1382  *
1383  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1384  */
1385 library MerkleProof {
1386     /**
1387      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1388      * defined by `root`. For this, a `proof` must be provided, containing
1389      * sibling hashes on the branch from the leaf to the root of the tree. Each
1390      * pair of leaves and each pair of pre-images are assumed to be sorted.
1391      */
1392     function verify(
1393         bytes32[] memory proof,
1394         bytes32 root,
1395         bytes32 leaf
1396     ) internal pure returns (bool) {
1397         return processProof(proof, leaf) == root;
1398     }
1399 
1400     /**
1401      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1402      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1403      * hash matches the root of the tree. When processing the proof, the pairs
1404      * of leafs & pre-images are assumed to be sorted.
1405      *
1406      * _Available since v4.4._
1407      */
1408     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1409         bytes32 computedHash = leaf;
1410         for (uint256 i = 0; i < proof.length; i++) {
1411             bytes32 proofElement = proof[i];
1412             if (computedHash <= proofElement) {
1413                 // Hash(current computed hash + current element of the proof)
1414                 computedHash = _efficientHash(computedHash, proofElement);
1415             } else {
1416                 // Hash(current element of the proof + current computed hash)
1417                 computedHash = _efficientHash(proofElement, computedHash);
1418             }
1419         }
1420         return computedHash;
1421     }
1422 
1423     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1424         assembly {
1425             mstore(0x00, a)
1426             mstore(0x20, b)
1427             value := keccak256(0x00, 0x40)
1428         }
1429     }
1430 }
1431 
1432 // File: src/contracts/Broman.sol
1433 
1434 
1435 
1436 pragma solidity ^0.8.0;
1437 
1438 
1439 
1440 
1441 
1442 contract Broman is Ownable, ERC721A, ReentrancyGuard {
1443 
1444   event Log(address indexed user, uint indexed value, uint256 indexed price);
1445 
1446   uint256 public immutable maxPerAddressDuringMint;
1447   uint256 public immutable amountForDevs;
1448   uint256 public immutable amountForSale;
1449   
1450   uint256 public constant MINT_PRICE_WL = 0 ether;
1451   uint256 public constant MINT_PRICE_PS = 0 ether;
1452 
1453   //to provide this as a bytes32 and not a string. 0x should be prepended
1454   bytes32 public merkleRoot = 0x1c5524118da897f3220c07d1185d0abfebb42c7f475b6d55cbe81306176d93d7;
1455 
1456   struct SaleConfig {
1457     uint32 privateSaleStartTimeWL;
1458     uint32 privateSaleEndTimeWL;
1459     uint32 publicSaleStartTime;
1460   }
1461 
1462   SaleConfig public saleConfig;
1463 
1464   constructor(
1465     uint256 maxBatchSize_,
1466     uint256 collectionSize_,
1467     uint256 amountForSale_,
1468     uint256 amountForDevs_
1469   ) ERC721A("Broman NFT", "Broman NFT", maxBatchSize_, collectionSize_) {
1470 
1471     maxPerAddressDuringMint = maxBatchSize_;
1472     amountForSale = amountForSale_;
1473     amountForDevs = amountForDevs_;
1474 
1475     require(
1476       (amountForSale_ + amountForDevs_) <= collectionSize_,
1477       "larger collection size needed"
1478     );
1479   }
1480 
1481   /**
1482    * Private Sale : for whitelist users
1483    *
1484    * Requirements:
1485    * - `hexProof` generated from merkletree 
1486    * - `quantity` how many ntfs be minted at once
1487    *
1488    */
1489   function whitelistMint(bytes32[] calldata hexProof, uint256 quantity) external payable callerIsUser {
1490     uint256 _saleStartTime = uint256(saleConfig.privateSaleStartTimeWL);
1491     uint256 _saleEndTime = uint256(saleConfig.privateSaleEndTimeWL);
1492 
1493     require(
1494       _saleStartTime != 0 && block.timestamp >= _saleStartTime,
1495       "sale for whitelist users has not started yet"
1496     );
1497 
1498     require(
1499       _saleEndTime != 0 && block.timestamp <= _saleEndTime,
1500       "sale for whitelist users has been ended"
1501     );
1502 
1503     require(
1504       isWhitelistUser(hexProof, msg.sender),
1505       "Not in whitelist"
1506     );
1507     
1508     require(
1509       totalSupply() + quantity <= amountForSale,
1510       "WL mint : not enough remaining reserved for minting"
1511     );
1512 
1513     require(
1514       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1515       "can not mint this many"
1516     );
1517 
1518     uint256 totalCost = MINT_PRICE_WL * quantity;
1519 
1520     emit Log(msg.sender, msg.value, totalCost);
1521 
1522     _safeMint(msg.sender, quantity);
1523 
1524     require(msg.value == totalCost, "Total cost is not right");
1525   }
1526 
1527   /**
1528    * Public Sale
1529    *
1530    * Requirements:
1531    * 
1532    * - `quantity` how many ntfs be minted at once
1533    *
1534    */
1535 
1536   function publicSaleMint(uint256 quantity)
1537     external
1538     payable
1539     callerIsUser
1540   {
1541     require(
1542       isPublicSaleOn(),
1543       "public sale has not begun yet"
1544     );
1545 
1546     require(totalSupply() + quantity <= amountForSale, "reached max supply");
1547 
1548     require(
1549       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1550       "can not mint this many"
1551     );
1552 
1553     uint256 totalCost = MINT_PRICE_PS * quantity;
1554 
1555     emit Log(msg.sender, msg.value, totalCost);
1556 
1557     _safeMint(msg.sender, quantity);
1558 
1559     require(msg.value == totalCost, "Total cost is not right");
1560   }
1561 
1562   function isPublicSaleOn() public view returns (bool) {
1563     SaleConfig memory config = saleConfig;
1564 
1565     return
1566       block.timestamp >= uint256(config.publicSaleStartTime);
1567   }
1568 
1569   /**
1570    * setup config
1571    * */
1572   function setupConfig(
1573     uint32 startTimestampWL, 
1574     uint32 endTimestampWL, 
1575     uint32 timestampPS
1576     ) external onlyOwner {
1577 
1578     saleConfig = SaleConfig(
1579       startTimestampWL,
1580       endTimestampWL,
1581       timestampPS
1582     );
1583 
1584   }
1585 
1586   /**
1587    * renew merkleRoot for latest whitelist
1588    * */
1589   function updateMerkleRoot(bytes32 latestMerkleRoot) external onlyOwner {
1590     merkleRoot = latestMerkleRoot;
1591   }
1592 
1593   
1594   function getSaleStartTimeWL() public view returns (uint32){
1595     return saleConfig.privateSaleStartTimeWL;
1596   }
1597 
1598   function getSaleEndTimeWL() public view returns (uint32){
1599     return saleConfig.privateSaleEndTimeWL;
1600   }
1601 
1602   function getSaleStartTimePS() public view returns (uint32){
1603     return saleConfig.publicSaleStartTime;
1604   }
1605 
1606   // For marketing usage
1607   function devMint(uint256 quantity) external onlyOwner {
1608     require(
1609       totalSupply() + quantity <= amountForDevs,
1610       "too many already minted before dev mint"
1611     );
1612     _safeBatchMint(msg.sender, quantity);
1613   }
1614 
1615   function isWhitelistUser(bytes32[] calldata merkleProof, address user) 
1616     public 
1617     view 
1618     returns (bool){
1619 
1620     bytes32 leaf = keccak256(abi.encodePacked(user));
1621 
1622     return MerkleProof.verify(merkleProof, merkleRoot, leaf);
1623   }
1624 
1625   modifier callerIsUser() {
1626     require(tx.origin == msg.sender, "The caller is another contract");
1627     _;
1628   }
1629 
1630   // // metadata URI
1631   string private _baseTokenURI;
1632 
1633   function _baseURI() internal view virtual override returns (string memory) {
1634     return _baseTokenURI;
1635   }
1636 
1637   function setBaseURI(string calldata baseURI) external onlyOwner {
1638     _baseTokenURI = baseURI;
1639   }
1640 
1641   function withdrawMoney() external onlyOwner nonReentrant {
1642     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1643     require(success, "Transfer failed.");
1644   }
1645 
1646   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1647     _setOwnersExplicit(quantity);
1648   }
1649 
1650   function numberMinted(address owner) public view returns (uint256) {
1651     return _numberMinted(owner);
1652   }
1653 
1654   function getOwnershipData(uint256 tokenId)
1655     external
1656     view
1657     returns (TokenOwnership memory)
1658   {
1659     return _ownershipOf(tokenId);
1660   }
1661 }