1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev String operations.
75  */
76 library Strings {
77     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
78 
79     /**
80      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
81      */
82     function toString(uint256 value) internal pure returns (string memory) {
83         // Inspired by OraclizeAPI's implementation - MIT licence
84         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
85 
86         if (value == 0) {
87             return "0";
88         }
89         uint256 temp = value;
90         uint256 digits;
91         while (temp != 0) {
92             digits++;
93             temp /= 10;
94         }
95         bytes memory buffer = new bytes(digits);
96         while (value != 0) {
97             digits -= 1;
98             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
99             value /= 10;
100         }
101         return string(buffer);
102     }
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
106      */
107     function toHexString(uint256 value) internal pure returns (string memory) {
108         if (value == 0) {
109             return "0x00";
110         }
111         uint256 temp = value;
112         uint256 length = 0;
113         while (temp != 0) {
114             length++;
115             temp >>= 8;
116         }
117         return toHexString(value, length);
118     }
119 
120     /**
121      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
122      */
123     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
124         bytes memory buffer = new bytes(2 * length + 2);
125         buffer[0] = "0";
126         buffer[1] = "x";
127         for (uint256 i = 2 * length + 1; i > 1; --i) {
128             buffer[i] = _HEX_SYMBOLS[value & 0xf];
129             value >>= 4;
130         }
131         require(value == 0, "Strings: hex length insufficient");
132         return string(buffer);
133     }
134 }
135 
136 // File: @openzeppelin/contracts/utils/Context.sol
137 
138 
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev Provides information about the current execution context, including the
144  * sender of the transaction and its data. While these are generally available
145  * via msg.sender and msg.data, they should not be accessed in such a direct
146  * manner, since when dealing with meta-transactions the account sending and
147  * paying for execution may not be the actual sender (as far as an application
148  * is concerned).
149  *
150  * This contract is only required for intermediate, library-like contracts.
151  */
152 abstract contract Context {
153     function _msgSender() internal view virtual returns (address) {
154         return msg.sender;
155     }
156 
157     function _msgData() internal view virtual returns (bytes calldata) {
158         return msg.data;
159     }
160 }
161 
162 // File: @openzeppelin/contracts/access/Ownable.sol
163 
164 
165 
166 pragma solidity ^0.8.0;
167 
168 
169 /**
170  * @dev Contract module which provides a basic access control mechanism, where
171  * there is an account (an owner) that can be granted exclusive access to
172  * specific functions.
173  *
174  * By default, the owner account will be the one that deploys the contract. This
175  * can later be changed with {transferOwnership}.
176  *
177  * This module is used through inheritance. It will make available the modifier
178  * `onlyOwner`, which can be applied to your functions to restrict their use to
179  * the owner.
180  */
181 abstract contract Ownable is Context {
182     address private _owner;
183 
184     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186     /**
187      * @dev Initializes the contract setting the deployer as the initial owner.
188      */
189     constructor() {
190         _setOwner(_msgSender());
191     }
192 
193     /**
194      * @dev Returns the address of the current owner.
195      */
196     function owner() public view virtual returns (address) {
197         return _owner;
198     }
199 
200     /**
201      * @dev Throws if called by any account other than the owner.
202      */
203     modifier onlyOwner() {
204         require(owner() == _msgSender(), "Ownable: caller is not the owner");
205         _;
206     }
207 
208     /**
209      * @dev Leaves the contract without owner. It will not be possible to call
210      * `onlyOwner` functions anymore. Can only be called by the current owner.
211      *
212      * NOTE: Renouncing ownership will leave the contract without an owner,
213      * thereby removing any functionality that is only available to the owner.
214      */
215     function renounceOwnership() public virtual onlyOwner {
216         _setOwner(address(0));
217     }
218 
219     /**
220      * @dev Transfers ownership of the contract to a new account (`newOwner`).
221      * Can only be called by the current owner.
222      */
223     function transferOwnership(address newOwner) public virtual onlyOwner {
224         require(newOwner != address(0), "Ownable: new owner is the zero address");
225         _setOwner(newOwner);
226     }
227 
228     function _setOwner(address newOwner) private {
229         address oldOwner = _owner;
230         _owner = newOwner;
231         emit OwnershipTransferred(oldOwner, newOwner);
232     }
233 }
234 
235 // File: @openzeppelin/contracts/utils/Address.sol
236 
237 
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // This method relies on extcodesize, which returns 0 for contracts in
264         // construction, since the code is only stored at the end of the
265         // constructor execution.
266 
267         uint256 size;
268         assembly {
269             size := extcodesize(account)
270         }
271         return size > 0;
272     }
273 
274     /**
275      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276      * `recipient`, forwarding all available gas and reverting on errors.
277      *
278      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279      * of certain opcodes, possibly making contracts go over the 2300 gas limit
280      * imposed by `transfer`, making them unable to receive funds via
281      * `transfer`. {sendValue} removes this limitation.
282      *
283      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284      *
285      * IMPORTANT: because control is transferred to `recipient`, care must be
286      * taken to not create reentrancy vulnerabilities. Consider using
287      * {ReentrancyGuard} or the
288      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289      */
290     function sendValue(address payable recipient, uint256 amount) internal {
291         require(address(this).balance >= amount, "Address: insufficient balance");
292 
293         (bool success, ) = recipient.call{value: amount}("");
294         require(success, "Address: unable to send value, recipient may have reverted");
295     }
296 
297     /**
298      * @dev Performs a Solidity function call using a low level `call`. A
299      * plain `call` is an unsafe replacement for a function call: use this
300      * function instead.
301      *
302      * If `target` reverts with a revert reason, it is bubbled up by this
303      * function (like regular Solidity function calls).
304      *
305      * Returns the raw returned data. To convert to the expected return value,
306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307      *
308      * Requirements:
309      *
310      * - `target` must be a contract.
311      * - calling `target` with `data` must not revert.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
316         return functionCall(target, data, "Address: low-level call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
321      * `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(
326         address target,
327         bytes memory data,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(
345         address target,
346         bytes memory data,
347         uint256 value
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(
359         address target,
360         bytes memory data,
361         uint256 value,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         require(isContract(target), "Address: call to non-contract");
366 
367         (bool success, bytes memory returndata) = target.call{value: value}(data);
368         return verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but performing a static call.
374      *
375      * _Available since v3.3._
376      */
377     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
378         return functionStaticCall(target, data, "Address: low-level static call failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(
388         address target,
389         bytes memory data,
390         string memory errorMessage
391     ) internal view returns (bytes memory) {
392         require(isContract(target), "Address: static call to non-contract");
393 
394         (bool success, bytes memory returndata) = target.staticcall(data);
395         return verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but performing a delegate call.
401      *
402      * _Available since v3.4._
403      */
404     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
405         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
410      * but performing a delegate call.
411      *
412      * _Available since v3.4._
413      */
414     function functionDelegateCall(
415         address target,
416         bytes memory data,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         require(isContract(target), "Address: delegate call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.delegatecall(data);
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
427      * revert reason using the provided one.
428      *
429      * _Available since v4.3._
430      */
431     function verifyCallResult(
432         bool success,
433         bytes memory returndata,
434         string memory errorMessage
435     ) internal pure returns (bytes memory) {
436         if (success) {
437             return returndata;
438         } else {
439             // Look for revert reason and bubble it up if present
440             if (returndata.length > 0) {
441                 // The easiest way to bubble the revert reason is using memory via assembly
442 
443                 assembly {
444                     let returndata_size := mload(returndata)
445                     revert(add(32, returndata), returndata_size)
446                 }
447             } else {
448                 revert(errorMessage);
449             }
450         }
451     }
452 }
453 
454 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
455 
456 
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @title ERC721 token receiver interface
462  * @dev Interface for any contract that wants to support safeTransfers
463  * from ERC721 asset contracts.
464  */
465 interface IERC721Receiver {
466     /**
467      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
468      * by `operator` from `from`, this function is called.
469      *
470      * It must return its Solidity selector to confirm the token transfer.
471      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
472      *
473      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
474      */
475     function onERC721Received(
476         address operator,
477         address from,
478         uint256 tokenId,
479         bytes calldata data
480     ) external returns (bytes4);
481 }
482 
483 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
484 
485 
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @dev Interface of the ERC165 standard, as defined in the
491  * https://eips.ethereum.org/EIPS/eip-165[EIP].
492  *
493  * Implementers can declare support of contract interfaces, which can then be
494  * queried by others ({ERC165Checker}).
495  *
496  * For an implementation, see {ERC165}.
497  */
498 interface IERC165 {
499     /**
500      * @dev Returns true if this contract implements the interface defined by
501      * `interfaceId`. See the corresponding
502      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
503      * to learn more about how these ids are created.
504      *
505      * This function call must use less than 30 000 gas.
506      */
507     function supportsInterface(bytes4 interfaceId) external view returns (bool);
508 }
509 
510 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
511 
512 
513 
514 pragma solidity ^0.8.0;
515 
516 
517 /**
518  * @dev Implementation of the {IERC165} interface.
519  *
520  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
521  * for the additional interface id that will be supported. For example:
522  *
523  * ```solidity
524  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
526  * }
527  * ```
528  *
529  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
530  */
531 abstract contract ERC165 is IERC165 {
532     /**
533      * @dev See {IERC165-supportsInterface}.
534      */
535     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536         return interfaceId == type(IERC165).interfaceId;
537     }
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
541 
542 
543 
544 pragma solidity ^0.8.0;
545 
546 
547 /**
548  * @dev Required interface of an ERC721 compliant contract.
549  */
550 interface IERC721 is IERC165 {
551     /**
552      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
553      */
554     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
555 
556     /**
557      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
558      */
559     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
560 
561     /**
562      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
563      */
564     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
565 
566     /**
567      * @dev Returns the number of tokens in ``owner``'s account.
568      */
569     function balanceOf(address owner) external view returns (uint256 balance);
570 
571     /**
572      * @dev Returns the owner of the `tokenId` token.
573      *
574      * Requirements:
575      *
576      * - `tokenId` must exist.
577      */
578     function ownerOf(uint256 tokenId) external view returns (address owner);
579 
580     /**
581      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
582      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
583      *
584      * Requirements:
585      *
586      * - `from` cannot be the zero address.
587      * - `to` cannot be the zero address.
588      * - `tokenId` token must exist and be owned by `from`.
589      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
590      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
591      *
592      * Emits a {Transfer} event.
593      */
594     function safeTransferFrom(
595         address from,
596         address to,
597         uint256 tokenId
598     ) external;
599 
600     /**
601      * @dev Transfers `tokenId` token from `from` to `to`.
602      *
603      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
604      *
605      * Requirements:
606      *
607      * - `from` cannot be the zero address.
608      * - `to` cannot be the zero address.
609      * - `tokenId` token must be owned by `from`.
610      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
611      *
612      * Emits a {Transfer} event.
613      */
614     function transferFrom(
615         address from,
616         address to,
617         uint256 tokenId
618     ) external;
619 
620     /**
621      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
622      * The approval is cleared when the token is transferred.
623      *
624      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
625      *
626      * Requirements:
627      *
628      * - The caller must own the token or be an approved operator.
629      * - `tokenId` must exist.
630      *
631      * Emits an {Approval} event.
632      */
633     function approve(address to, uint256 tokenId) external;
634 
635     /**
636      * @dev Returns the account approved for `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function getApproved(uint256 tokenId) external view returns (address operator);
643 
644     /**
645      * @dev Approve or remove `operator` as an operator for the caller.
646      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
647      *
648      * Requirements:
649      *
650      * - The `operator` cannot be the caller.
651      *
652      * Emits an {ApprovalForAll} event.
653      */
654     function setApprovalForAll(address operator, bool _approved) external;
655 
656     /**
657      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
658      *
659      * See {setApprovalForAll}
660      */
661     function isApprovedForAll(address owner, address operator) external view returns (bool);
662 
663     /**
664      * @dev Safely transfers `tokenId` token from `from` to `to`.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `tokenId` token must exist and be owned by `from`.
671      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
672      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
673      *
674      * Emits a {Transfer} event.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 tokenId,
680         bytes calldata data
681     ) external;
682 }
683 
684 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
685 
686 
687 
688 pragma solidity ^0.8.0;
689 
690 
691 /**
692  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
693  * @dev See https://eips.ethereum.org/EIPS/eip-721
694  */
695 interface IERC721Enumerable is IERC721 {
696     /**
697      * @dev Returns the total amount of tokens stored by the contract.
698      */
699     function totalSupply() external view returns (uint256);
700 
701     /**
702      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
703      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
704      */
705     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
706 
707     /**
708      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
709      * Use along with {totalSupply} to enumerate all tokens.
710      */
711     function tokenByIndex(uint256 index) external view returns (uint256);
712 }
713 
714 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
715 
716 
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
723  * @dev See https://eips.ethereum.org/EIPS/eip-721
724  */
725 interface IERC721Metadata is IERC721 {
726     /**
727      * @dev Returns the token collection name.
728      */
729     function name() external view returns (string memory);
730 
731     /**
732      * @dev Returns the token collection symbol.
733      */
734     function symbol() external view returns (string memory);
735 
736     /**
737      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
738      */
739     function tokenURI(uint256 tokenId) external view returns (string memory);
740 }
741 
742 // File: contracts/ERC721A.sol
743 
744 
745 // Creators: locationtba.eth, 2pmflow.eth
746 
747 pragma solidity ^0.8.0;
748 
749 
750 
751 
752 
753 
754 
755 
756 
757 /**
758  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
759  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
760  *
761  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
762  *
763  * Does not support burning tokens to address(0).
764  */
765 contract ERC721A is
766   Context,
767   ERC165,
768   IERC721,
769   IERC721Metadata,
770   IERC721Enumerable
771 {
772   using Address for address;
773   using Strings for uint256;
774 
775   struct TokenOwnership {
776     address addr;
777     uint64 startTimestamp;
778   }
779 
780   struct AddressData {
781     uint128 balance;
782     uint128 numberMinted;
783   }
784 
785   uint256 private currentIndex = 0;
786 
787   uint256 internal immutable maxBatchSize;
788 
789   // Token name
790   string private _name;
791 
792   // Token symbol
793   string private _symbol;
794 
795   // Mapping from token ID to ownership details
796   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
797   mapping(uint256 => TokenOwnership) private _ownerships;
798 
799   // Mapping owner address to address data
800   mapping(address => AddressData) private _addressData;
801 
802   // Mapping from token ID to approved address
803   mapping(uint256 => address) private _tokenApprovals;
804 
805   // Mapping from owner to operator approvals
806   mapping(address => mapping(address => bool)) private _operatorApprovals;
807 
808   /**
809    * @dev
810    * `maxBatchSize` refers to how much a minter can mint at a time.
811    */
812   constructor(
813     string memory name_,
814     string memory symbol_,
815     uint256 maxBatchSize_
816   ) {
817     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
818     _name = name_;
819     _symbol = symbol_;
820     maxBatchSize = maxBatchSize_;
821   }
822 
823   /**
824    * @dev See {IERC721Enumerable-totalSupply}.
825    */
826   function totalSupply() public view override returns (uint256) {
827     return currentIndex;
828   }
829 
830   /**
831    * @dev See {IERC721Enumerable-tokenByIndex}.
832    */
833   function tokenByIndex(uint256 index) public view override returns (uint256) {
834     require(index < totalSupply(), "ERC721A: global index out of bounds");
835     return index;
836   }
837 
838   /**
839    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
840    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
841    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
842    */
843   function tokenOfOwnerByIndex(address owner, uint256 index)
844     public
845     view
846     override
847     returns (uint256)
848   {
849     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
850     uint256 numMintedSoFar = totalSupply();
851     uint256 tokenIdsIdx = 0;
852     address currOwnershipAddr = address(0);
853     for (uint256 i = 0; i < numMintedSoFar; i++) {
854       TokenOwnership memory ownership = _ownerships[i];
855       if (ownership.addr != address(0)) {
856         currOwnershipAddr = ownership.addr;
857       }
858       if (currOwnershipAddr == owner) {
859         if (tokenIdsIdx == index) {
860           return i;
861         }
862         tokenIdsIdx++;
863       }
864     }
865     revert("ERC721A: unable to get token of owner by index");
866   }
867 
868   /**
869    * @dev See {IERC165-supportsInterface}.
870    */
871   function supportsInterface(bytes4 interfaceId)
872     public
873     view
874     virtual
875     override(ERC165, IERC165)
876     returns (bool)
877   {
878     return
879       interfaceId == type(IERC721).interfaceId ||
880       interfaceId == type(IERC721Metadata).interfaceId ||
881       interfaceId == type(IERC721Enumerable).interfaceId ||
882       super.supportsInterface(interfaceId);
883   }
884 
885   /**
886    * @dev See {IERC721-balanceOf}.
887    */
888   function balanceOf(address owner) public view override returns (uint256) {
889     require(owner != address(0), "ERC721A: balance query for the zero address");
890     return uint256(_addressData[owner].balance);
891   }
892 
893   function _numberMinted(address owner) internal view returns (uint256) {
894     require(
895       owner != address(0),
896       "ERC721A: number minted query for the zero address"
897     );
898     return uint256(_addressData[owner].numberMinted);
899   }
900 
901   function ownershipOf(uint256 tokenId)
902     internal
903     view
904     returns (TokenOwnership memory)
905   {
906     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
907 
908     uint256 lowestTokenToCheck;
909     if (tokenId >= maxBatchSize) {
910       lowestTokenToCheck = tokenId - maxBatchSize + 1;
911     }
912 
913     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
914       TokenOwnership memory ownership = _ownerships[curr];
915       if (ownership.addr != address(0)) {
916         return ownership;
917       }
918     }
919 
920     revert("ERC721A: unable to determine the owner of token");
921   }
922 
923   /**
924    * @dev See {IERC721-ownerOf}.
925    */
926   function ownerOf(uint256 tokenId) public view override returns (address) {
927     return ownershipOf(tokenId).addr;
928   }
929 
930   /**
931    * @dev See {IERC721Metadata-name}.
932    */
933   function name() public view virtual override returns (string memory) {
934     return _name;
935   }
936 
937   /**
938    * @dev See {IERC721Metadata-symbol}.
939    */
940   function symbol() public view virtual override returns (string memory) {
941     return _symbol;
942   }
943 
944   /**
945    * @dev See {IERC721Metadata-tokenURI}.
946    */
947   function tokenURI(uint256 tokenId)
948     public
949     view
950     virtual
951     override
952     returns (string memory)
953   {
954     require(
955       _exists(tokenId),
956       "ERC721Metadata: URI query for nonexistent token"
957     );
958 
959     string memory baseURI = _baseURI();
960     return
961       bytes(baseURI).length > 0
962         ? string(abi.encodePacked(baseURI, tokenId.toString()))
963         : "";
964   }
965 
966   /**
967    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
968    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
969    * by default, can be overriden in child contracts.
970    */
971   function _baseURI() internal view virtual returns (string memory) {
972     return "";
973   }
974 
975   /**
976    * @dev See {IERC721-approve}.
977    */
978   function approve(address to, uint256 tokenId) public override {
979     address owner = ERC721A.ownerOf(tokenId);
980     require(to != owner, "ERC721A: approval to current owner");
981 
982     require(
983       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
984       "ERC721A: approve caller is not owner nor approved for all"
985     );
986 
987     _approve(to, tokenId, owner);
988   }
989 
990   /**
991    * @dev See {IERC721-getApproved}.
992    */
993   function getApproved(uint256 tokenId) public view override returns (address) {
994     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
995 
996     return _tokenApprovals[tokenId];
997   }
998 
999   /**
1000    * @dev See {IERC721-setApprovalForAll}.
1001    */
1002   function setApprovalForAll(address operator, bool approved) public override {
1003     require(operator != _msgSender(), "ERC721A: approve to caller");
1004 
1005     _operatorApprovals[_msgSender()][operator] = approved;
1006     emit ApprovalForAll(_msgSender(), operator, approved);
1007   }
1008 
1009   /**
1010    * @dev See {IERC721-isApprovedForAll}.
1011    */
1012   function isApprovedForAll(address owner, address operator)
1013     public
1014     view
1015     virtual
1016     override
1017     returns (bool)
1018   {
1019     return _operatorApprovals[owner][operator];
1020   }
1021 
1022   /**
1023    * @dev See {IERC721-transferFrom}.
1024    */
1025   function transferFrom(
1026     address from,
1027     address to,
1028     uint256 tokenId
1029   ) public override {
1030     _transfer(from, to, tokenId);
1031   }
1032 
1033   /**
1034    * @dev See {IERC721-safeTransferFrom}.
1035    */
1036   function safeTransferFrom(
1037     address from,
1038     address to,
1039     uint256 tokenId
1040   ) public override {
1041     safeTransferFrom(from, to, tokenId, "");
1042   }
1043 
1044   /**
1045    * @dev See {IERC721-safeTransferFrom}.
1046    */
1047   function safeTransferFrom(
1048     address from,
1049     address to,
1050     uint256 tokenId,
1051     bytes memory _data
1052   ) public override {
1053     _transfer(from, to, tokenId);
1054     require(
1055       _checkOnERC721Received(from, to, tokenId, _data),
1056       "ERC721A: transfer to non ERC721Receiver implementer"
1057     );
1058   }
1059 
1060   /**
1061    * @dev Returns whether `tokenId` exists.
1062    *
1063    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1064    *
1065    * Tokens start existing when they are minted (`_mint`),
1066    */
1067   function _exists(uint256 tokenId) internal view returns (bool) {
1068     return tokenId < currentIndex;
1069   }
1070 
1071   function _safeMint(address to, uint256 quantity) internal {
1072     _safeMint(to, quantity, "");
1073   }
1074 
1075   /**
1076    * @dev Mints `quantity` tokens and transfers them to `to`.
1077    *
1078    * Requirements:
1079    *
1080    * - `to` cannot be the zero address.
1081    * - `quantity` cannot be larger than the max batch size.
1082    *
1083    * Emits a {Transfer} event.
1084    */
1085   function _safeMint(
1086     address to,
1087     uint256 quantity,
1088     bytes memory _data
1089   ) internal {
1090     uint256 startTokenId = currentIndex;
1091     require(to != address(0), "ERC721A: mint to the zero address");
1092     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1093     require(!_exists(startTokenId), "ERC721A: token already minted");
1094     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1095 
1096     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1097 
1098     AddressData memory addressData = _addressData[to];
1099     _addressData[to] = AddressData(
1100       addressData.balance + uint128(quantity),
1101       addressData.numberMinted + uint128(quantity)
1102     );
1103     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1104 
1105     uint256 updatedIndex = startTokenId;
1106 
1107     for (uint256 i = 0; i < quantity; i++) {
1108       emit Transfer(address(0), to, updatedIndex);
1109       require(
1110         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1111         "ERC721A: transfer to non ERC721Receiver implementer"
1112       );
1113       updatedIndex++;
1114     }
1115 
1116     currentIndex = updatedIndex;
1117     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1118   }
1119 
1120   /**
1121    * @dev Transfers `tokenId` from `from` to `to`.
1122    *
1123    * Requirements:
1124    *
1125    * - `to` cannot be the zero address.
1126    * - `tokenId` token must be owned by `from`.
1127    *
1128    * Emits a {Transfer} event.
1129    */
1130   function _transfer(
1131     address from,
1132     address to,
1133     uint256 tokenId
1134   ) private {
1135     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1136 
1137     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1138       getApproved(tokenId) == _msgSender() ||
1139       isApprovedForAll(prevOwnership.addr, _msgSender()));
1140 
1141     require(
1142       isApprovedOrOwner,
1143       "ERC721A: transfer caller is not owner nor approved"
1144     );
1145 
1146     require(
1147       prevOwnership.addr == from,
1148       "ERC721A: transfer from incorrect owner"
1149     );
1150     require(to != address(0), "ERC721A: transfer to the zero address");
1151 
1152     _beforeTokenTransfers(from, to, tokenId, 1);
1153 
1154     // Clear approvals from the previous owner
1155     _approve(address(0), tokenId, prevOwnership.addr);
1156 
1157     _addressData[from].balance -= 1;
1158     _addressData[to].balance += 1;
1159     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1160 
1161     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1162     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1163     uint256 nextTokenId = tokenId + 1;
1164     if (_ownerships[nextTokenId].addr == address(0)) {
1165       if (_exists(nextTokenId)) {
1166         _ownerships[nextTokenId] = TokenOwnership(
1167           prevOwnership.addr,
1168           prevOwnership.startTimestamp
1169         );
1170       }
1171     }
1172 
1173     emit Transfer(from, to, tokenId);
1174     _afterTokenTransfers(from, to, tokenId, 1);
1175   }
1176 
1177   /**
1178    * @dev Approve `to` to operate on `tokenId`
1179    *
1180    * Emits a {Approval} event.
1181    */
1182   function _approve(
1183     address to,
1184     uint256 tokenId,
1185     address owner
1186   ) private {
1187     _tokenApprovals[tokenId] = to;
1188     emit Approval(owner, to, tokenId);
1189   }
1190 
1191   uint256 public nextOwnerToExplicitlySet = 0;
1192 
1193   /**
1194    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1195    */
1196   function _setOwnersExplicit(uint256 quantity) internal {
1197     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1198     require(quantity > 0, "quantity must be nonzero");
1199     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1200     if (endIndex > currentIndex - 1) {
1201       endIndex = currentIndex - 1;
1202     }
1203     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1204     require(_exists(endIndex), "not enough minted yet for this cleanup");
1205     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1206       if (_ownerships[i].addr == address(0)) {
1207         TokenOwnership memory ownership = ownershipOf(i);
1208         _ownerships[i] = TokenOwnership(
1209           ownership.addr,
1210           ownership.startTimestamp
1211         );
1212       }
1213     }
1214     nextOwnerToExplicitlySet = endIndex + 1;
1215   }
1216 
1217   /**
1218    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1219    * The call is not executed if the target address is not a contract.
1220    *
1221    * @param from address representing the previous owner of the given token ID
1222    * @param to target address that will receive the tokens
1223    * @param tokenId uint256 ID of the token to be transferred
1224    * @param _data bytes optional data to send along with the call
1225    * @return bool whether the call correctly returned the expected magic value
1226    */
1227   function _checkOnERC721Received(
1228     address from,
1229     address to,
1230     uint256 tokenId,
1231     bytes memory _data
1232   ) private returns (bool) {
1233     if (to.isContract()) {
1234       try
1235         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1236       returns (bytes4 retval) {
1237         return retval == IERC721Receiver(to).onERC721Received.selector;
1238       } catch (bytes memory reason) {
1239         if (reason.length == 0) {
1240           revert("ERC721A: transfer to non ERC721Receiver implementer");
1241         } else {
1242           assembly {
1243             revert(add(32, reason), mload(reason))
1244           }
1245         }
1246       }
1247     } else {
1248       return true;
1249     }
1250   }
1251 
1252   /**
1253    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1254    *
1255    * startTokenId - the first token id to be transferred
1256    * quantity - the amount to be transferred
1257    *
1258    * Calling conditions:
1259    *
1260    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1261    * transferred to `to`.
1262    * - When `from` is zero, `tokenId` will be minted for `to`.
1263    */
1264   function _beforeTokenTransfers(
1265     address from,
1266     address to,
1267     uint256 startTokenId,
1268     uint256 quantity
1269   ) internal virtual {}
1270 
1271   /**
1272    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1273    * minting.
1274    *
1275    * startTokenId - the first token id to be transferred
1276    * quantity - the amount to be transferred
1277    *
1278    * Calling conditions:
1279    *
1280    * - when `from` and `to` are both non-zero.
1281    * - `from` and `to` are never both zero.
1282    */
1283   function _afterTokenTransfers(
1284     address from,
1285     address to,
1286     uint256 startTokenId,
1287     uint256 quantity
1288   ) internal virtual {}
1289 }
1290 // File: contracts/Seed.sol
1291 
1292 
1293 pragma solidity ^0.8.15;
1294 
1295 
1296 
1297 
1298 contract Seed is ERC721A, Ownable, ReentrancyGuard {
1299 
1300     // constants
1301     uint256 constant MAX_ELEMENTS = 500;
1302     uint256 constant MAX_ELEMENTS_TX = 5;
1303     uint256 constant MAX_FREE_PER_TX = 1;
1304     uint256 constant PUBLIC_PRICE = 0.02 ether;
1305 
1306     string public baseTokenURI = "ipfs://QmNND924QZiG8A2FADs4m5uB58FGEa32xJuFfKsjmkEWXY/";
1307     bool public paused = true;
1308 
1309     constructor(uint256 maxBatchSize_) ERC721A("A Seed Grows", "SEED", maxBatchSize_) {}
1310 
1311     function mint(uint256 _mintAmount) external payable nonReentrant {
1312         uint256 supply = totalSupply();
1313         require(_mintAmount > 0,"No zero mints");
1314         require(_mintAmount <= MAX_ELEMENTS_TX,"Exceeds max per tx");
1315         require(!paused, "Sale has not started!");
1316 
1317         require(supply + _mintAmount <= MAX_ELEMENTS,"Exceeds max supply");
1318         require(msg.value >= (_mintAmount - MAX_FREE_PER_TX)* PUBLIC_PRICE,"Invalid funds provided");
1319         _safeMint(msg.sender,_mintAmount);
1320     }
1321 
1322     function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1323         _safeMint(_receiver, _mintAmount);
1324     }
1325     
1326     function withdraw() external payable onlyOwner {
1327         require(payable(msg.sender).send(address(this).balance));
1328     }
1329 
1330     function pause(bool _state) external onlyOwner {
1331         paused = _state;
1332     }
1333 
1334     function _baseURI() internal view virtual override returns (string memory) {
1335         return baseTokenURI;
1336     }
1337 
1338     function setBaseURI(string calldata baseURI) external onlyOwner {
1339         baseTokenURI = baseURI;
1340     }
1341 }