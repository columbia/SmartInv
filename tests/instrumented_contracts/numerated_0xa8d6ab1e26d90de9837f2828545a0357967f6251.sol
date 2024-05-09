1 // hevm: flattened sources of src/SeriesOne.sol
2 // SPDX-License-Identifier: MIT
3 pragma solidity >=0.8.0 <0.9.0;
4 
5 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
6 
7 /* pragma solidity ^0.8.0; */
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
30 
31 /* pragma solidity ^0.8.0; */
32 
33 /* import "../utils/Context.sol"; */
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _setOwner(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _setOwner(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _setOwner(newOwner);
92     }
93 
94     function _setOwner(address newOwner) private {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 ////// lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol
102 
103 /* pragma solidity ^0.8.0; */
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
146      * by making the `nonReentrant` function external, and making it call a
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
164 ////// lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
165 
166 /* pragma solidity ^0.8.0; */
167 
168 /**
169  * @dev Interface of the ERC165 standard, as defined in the
170  * https://eips.ethereum.org/EIPS/eip-165[EIP].
171  *
172  * Implementers can declare support of contract interfaces, which can then be
173  * queried by others ({ERC165Checker}).
174  *
175  * For an implementation, see {ERC165}.
176  */
177 interface IERC165 {
178     /**
179      * @dev Returns true if this contract implements the interface defined by
180      * `interfaceId`. See the corresponding
181      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
182      * to learn more about how these ids are created.
183      *
184      * This function call must use less than 30 000 gas.
185      */
186     function supportsInterface(bytes4 interfaceId) external view returns (bool);
187 }
188 
189 ////// lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
190 
191 /* pragma solidity ^0.8.0; */
192 
193 /* import "../../utils/introspection/IERC165.sol"; */
194 
195 /**
196  * @dev Required interface of an ERC721 compliant contract.
197  */
198 interface IERC721 is IERC165 {
199     /**
200      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
201      */
202     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
203 
204     /**
205      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
206      */
207     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
208 
209     /**
210      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
211      */
212     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
213 
214     /**
215      * @dev Returns the number of tokens in ``owner``'s account.
216      */
217     function balanceOf(address owner) external view returns (uint256 balance);
218 
219     /**
220      * @dev Returns the owner of the `tokenId` token.
221      *
222      * Requirements:
223      *
224      * - `tokenId` must exist.
225      */
226     function ownerOf(uint256 tokenId) external view returns (address owner);
227 
228     /**
229      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
230      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
231      *
232      * Requirements:
233      *
234      * - `from` cannot be the zero address.
235      * - `to` cannot be the zero address.
236      * - `tokenId` token must exist and be owned by `from`.
237      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
238      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
239      *
240      * Emits a {Transfer} event.
241      */
242     function safeTransferFrom(
243         address from,
244         address to,
245         uint256 tokenId
246     ) external;
247 
248     /**
249      * @dev Transfers `tokenId` token from `from` to `to`.
250      *
251      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
252      *
253      * Requirements:
254      *
255      * - `from` cannot be the zero address.
256      * - `to` cannot be the zero address.
257      * - `tokenId` token must be owned by `from`.
258      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
259      *
260      * Emits a {Transfer} event.
261      */
262     function transferFrom(
263         address from,
264         address to,
265         uint256 tokenId
266     ) external;
267 
268     /**
269      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
270      * The approval is cleared when the token is transferred.
271      *
272      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
273      *
274      * Requirements:
275      *
276      * - The caller must own the token or be an approved operator.
277      * - `tokenId` must exist.
278      *
279      * Emits an {Approval} event.
280      */
281     function approve(address to, uint256 tokenId) external;
282 
283     /**
284      * @dev Returns the account approved for `tokenId` token.
285      *
286      * Requirements:
287      *
288      * - `tokenId` must exist.
289      */
290     function getApproved(uint256 tokenId) external view returns (address operator);
291 
292     /**
293      * @dev Approve or remove `operator` as an operator for the caller.
294      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
295      *
296      * Requirements:
297      *
298      * - The `operator` cannot be the caller.
299      *
300      * Emits an {ApprovalForAll} event.
301      */
302     function setApprovalForAll(address operator, bool _approved) external;
303 
304     /**
305      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
306      *
307      * See {setApprovalForAll}
308      */
309     function isApprovedForAll(address owner, address operator) external view returns (bool);
310 
311     /**
312      * @dev Safely transfers `tokenId` token from `from` to `to`.
313      *
314      * Requirements:
315      *
316      * - `from` cannot be the zero address.
317      * - `to` cannot be the zero address.
318      * - `tokenId` token must exist and be owned by `from`.
319      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
320      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
321      *
322      * Emits a {Transfer} event.
323      */
324     function safeTransferFrom(
325         address from,
326         address to,
327         uint256 tokenId,
328         bytes calldata data
329     ) external;
330 }
331 
332 ////// lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
333 
334 /* pragma solidity ^0.8.0; */
335 
336 /**
337  * @title ERC721 token receiver interface
338  * @dev Interface for any contract that wants to support safeTransfers
339  * from ERC721 asset contracts.
340  */
341 interface IERC721Receiver {
342     /**
343      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
344      * by `operator` from `from`, this function is called.
345      *
346      * It must return its Solidity selector to confirm the token transfer.
347      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
348      *
349      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
350      */
351     function onERC721Received(
352         address operator,
353         address from,
354         uint256 tokenId,
355         bytes calldata data
356     ) external returns (bytes4);
357 }
358 
359 ////// lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol
360 
361 /* pragma solidity ^0.8.0; */
362 
363 /* import "../IERC721.sol"; */
364 
365 /**
366  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
367  * @dev See https://eips.ethereum.org/EIPS/eip-721
368  */
369 interface IERC721Metadata is IERC721 {
370     /**
371      * @dev Returns the token collection name.
372      */
373     function name() external view returns (string memory);
374 
375     /**
376      * @dev Returns the token collection symbol.
377      */
378     function symbol() external view returns (string memory);
379 
380     /**
381      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
382      */
383     function tokenURI(uint256 tokenId) external view returns (string memory);
384 }
385 
386 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
387 
388 /* pragma solidity ^0.8.0; */
389 
390 /**
391  * @dev Collection of functions related to the address type
392  */
393 library Address {
394     /**
395      * @dev Returns true if `account` is a contract.
396      *
397      * [IMPORTANT]
398      * ====
399      * It is unsafe to assume that an address for which this function returns
400      * false is an externally-owned account (EOA) and not a contract.
401      *
402      * Among others, `isContract` will return false for the following
403      * types of addresses:
404      *
405      *  - an externally-owned account
406      *  - a contract in construction
407      *  - an address where a contract will be created
408      *  - an address where a contract lived, but was destroyed
409      * ====
410      */
411     function isContract(address account) internal view returns (bool) {
412         // This method relies on extcodesize, which returns 0 for contracts in
413         // construction, since the code is only stored at the end of the
414         // constructor execution.
415 
416         uint256 size;
417         assembly {
418             size := extcodesize(account)
419         }
420         return size > 0;
421     }
422 
423     /**
424      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
425      * `recipient`, forwarding all available gas and reverting on errors.
426      *
427      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
428      * of certain opcodes, possibly making contracts go over the 2300 gas limit
429      * imposed by `transfer`, making them unable to receive funds via
430      * `transfer`. {sendValue} removes this limitation.
431      *
432      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
433      *
434      * IMPORTANT: because control is transferred to `recipient`, care must be
435      * taken to not create reentrancy vulnerabilities. Consider using
436      * {ReentrancyGuard} or the
437      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
438      */
439     function sendValue(address payable recipient, uint256 amount) internal {
440         require(address(this).balance >= amount, "Address: insufficient balance");
441 
442         (bool success, ) = recipient.call{value: amount}("");
443         require(success, "Address: unable to send value, recipient may have reverted");
444     }
445 
446     /**
447      * @dev Performs a Solidity function call using a low level `call`. A
448      * plain `call` is an unsafe replacement for a function call: use this
449      * function instead.
450      *
451      * If `target` reverts with a revert reason, it is bubbled up by this
452      * function (like regular Solidity function calls).
453      *
454      * Returns the raw returned data. To convert to the expected return value,
455      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
456      *
457      * Requirements:
458      *
459      * - `target` must be a contract.
460      * - calling `target` with `data` must not revert.
461      *
462      * _Available since v3.1._
463      */
464     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
465         return functionCall(target, data, "Address: low-level call failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
470      * `errorMessage` as a fallback revert reason when `target` reverts.
471      *
472      * _Available since v3.1._
473      */
474     function functionCall(
475         address target,
476         bytes memory data,
477         string memory errorMessage
478     ) internal returns (bytes memory) {
479         return functionCallWithValue(target, data, 0, errorMessage);
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
484      * but also transferring `value` wei to `target`.
485      *
486      * Requirements:
487      *
488      * - the calling contract must have an ETH balance of at least `value`.
489      * - the called Solidity function must be `payable`.
490      *
491      * _Available since v3.1._
492      */
493     function functionCallWithValue(
494         address target,
495         bytes memory data,
496         uint256 value
497     ) internal returns (bytes memory) {
498         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
503      * with `errorMessage` as a fallback revert reason when `target` reverts.
504      *
505      * _Available since v3.1._
506      */
507     function functionCallWithValue(
508         address target,
509         bytes memory data,
510         uint256 value,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         require(address(this).balance >= value, "Address: insufficient balance for call");
514         require(isContract(target), "Address: call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.call{value: value}(data);
517         return verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but performing a static call.
523      *
524      * _Available since v3.3._
525      */
526     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
527         return functionStaticCall(target, data, "Address: low-level static call failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
532      * but performing a static call.
533      *
534      * _Available since v3.3._
535      */
536     function functionStaticCall(
537         address target,
538         bytes memory data,
539         string memory errorMessage
540     ) internal view returns (bytes memory) {
541         require(isContract(target), "Address: static call to non-contract");
542 
543         (bool success, bytes memory returndata) = target.staticcall(data);
544         return verifyCallResult(success, returndata, errorMessage);
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
549      * but performing a delegate call.
550      *
551      * _Available since v3.4._
552      */
553     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
554         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
559      * but performing a delegate call.
560      *
561      * _Available since v3.4._
562      */
563     function functionDelegateCall(
564         address target,
565         bytes memory data,
566         string memory errorMessage
567     ) internal returns (bytes memory) {
568         require(isContract(target), "Address: delegate call to non-contract");
569 
570         (bool success, bytes memory returndata) = target.delegatecall(data);
571         return verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     /**
575      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
576      * revert reason using the provided one.
577      *
578      * _Available since v4.3._
579      */
580     function verifyCallResult(
581         bool success,
582         bytes memory returndata,
583         string memory errorMessage
584     ) internal pure returns (bytes memory) {
585         if (success) {
586             return returndata;
587         } else {
588             // Look for revert reason and bubble it up if present
589             if (returndata.length > 0) {
590                 // The easiest way to bubble the revert reason is using memory via assembly
591 
592                 assembly {
593                     let returndata_size := mload(returndata)
594                     revert(add(32, returndata), returndata_size)
595                 }
596             } else {
597                 revert(errorMessage);
598             }
599         }
600     }
601 }
602 
603 ////// lib/openzeppelin-contracts/contracts/utils/Strings.sol
604 
605 /* pragma solidity ^0.8.0; */
606 
607 /**
608  * @dev String operations.
609  */
610 library Strings {
611     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
612 
613     /**
614      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
615      */
616     function toString(uint256 value) internal pure returns (string memory) {
617         // Inspired by OraclizeAPI's implementation - MIT licence
618         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
619 
620         if (value == 0) {
621             return "0";
622         }
623         uint256 temp = value;
624         uint256 digits;
625         while (temp != 0) {
626             digits++;
627             temp /= 10;
628         }
629         bytes memory buffer = new bytes(digits);
630         while (value != 0) {
631             digits -= 1;
632             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
633             value /= 10;
634         }
635         return string(buffer);
636     }
637 
638     /**
639      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
640      */
641     function toHexString(uint256 value) internal pure returns (string memory) {
642         if (value == 0) {
643             return "0x00";
644         }
645         uint256 temp = value;
646         uint256 length = 0;
647         while (temp != 0) {
648             length++;
649             temp >>= 8;
650         }
651         return toHexString(value, length);
652     }
653 
654     /**
655      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
656      */
657     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
658         bytes memory buffer = new bytes(2 * length + 2);
659         buffer[0] = "0";
660         buffer[1] = "x";
661         for (uint256 i = 2 * length + 1; i > 1; --i) {
662             buffer[i] = _HEX_SYMBOLS[value & 0xf];
663             value >>= 4;
664         }
665         require(value == 0, "Strings: hex length insufficient");
666         return string(buffer);
667     }
668 }
669 
670 ////// lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol
671 
672 /* pragma solidity ^0.8.0; */
673 
674 /* import "./IERC165.sol"; */
675 
676 /**
677  * @dev Implementation of the {IERC165} interface.
678  *
679  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
680  * for the additional interface id that will be supported. For example:
681  *
682  * ```solidity
683  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
684  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
685  * }
686  * ```
687  *
688  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
689  */
690 abstract contract ERC165 is IERC165 {
691     /**
692      * @dev See {IERC165-supportsInterface}.
693      */
694     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
695         return interfaceId == type(IERC165).interfaceId;
696     }
697 }
698 
699 ////// lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
700 
701 /* pragma solidity ^0.8.0; */
702 
703 /* import "./IERC721.sol"; */
704 /* import "./IERC721Receiver.sol"; */
705 /* import "./extensions/IERC721Metadata.sol"; */
706 /* import "../../utils/Address.sol"; */
707 /* import "../../utils/Context.sol"; */
708 /* import "../../utils/Strings.sol"; */
709 /* import "../../utils/introspection/ERC165.sol"; */
710 
711 /**
712  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
713  * the Metadata extension, but not including the Enumerable extension, which is available separately as
714  * {ERC721Enumerable}.
715  */
716 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
717     using Address for address;
718     using Strings for uint256;
719 
720     // Token name
721     string private _name;
722 
723     // Token symbol
724     string private _symbol;
725 
726     // Mapping from token ID to owner address
727     mapping(uint256 => address) private _owners;
728 
729     // Mapping owner address to token count
730     mapping(address => uint256) private _balances;
731 
732     // Mapping from token ID to approved address
733     mapping(uint256 => address) private _tokenApprovals;
734 
735     // Mapping from owner to operator approvals
736     mapping(address => mapping(address => bool)) private _operatorApprovals;
737 
738     /**
739      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
740      */
741     constructor(string memory name_, string memory symbol_) {
742         _name = name_;
743         _symbol = symbol_;
744     }
745 
746     /**
747      * @dev See {IERC165-supportsInterface}.
748      */
749     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
750         return
751             interfaceId == type(IERC721).interfaceId ||
752             interfaceId == type(IERC721Metadata).interfaceId ||
753             super.supportsInterface(interfaceId);
754     }
755 
756     /**
757      * @dev See {IERC721-balanceOf}.
758      */
759     function balanceOf(address owner) public view virtual override returns (uint256) {
760         require(owner != address(0), "ERC721: balance query for the zero address");
761         return _balances[owner];
762     }
763 
764     /**
765      * @dev See {IERC721-ownerOf}.
766      */
767     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
768         address owner = _owners[tokenId];
769         require(owner != address(0), "ERC721: owner query for nonexistent token");
770         return owner;
771     }
772 
773     /**
774      * @dev See {IERC721Metadata-name}.
775      */
776     function name() public view virtual override returns (string memory) {
777         return _name;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-symbol}.
782      */
783     function symbol() public view virtual override returns (string memory) {
784         return _symbol;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-tokenURI}.
789      */
790     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
791         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
792 
793         string memory baseURI = _baseURI();
794         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
795     }
796 
797     /**
798      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
799      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
800      * by default, can be overriden in child contracts.
801      */
802     function _baseURI() internal view virtual returns (string memory) {
803         return "";
804     }
805 
806     /**
807      * @dev See {IERC721-approve}.
808      */
809     function approve(address to, uint256 tokenId) public virtual override {
810         address owner = ERC721.ownerOf(tokenId);
811         require(to != owner, "ERC721: approval to current owner");
812 
813         require(
814             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
815             "ERC721: approve caller is not owner nor approved for all"
816         );
817 
818         _approve(to, tokenId);
819     }
820 
821     /**
822      * @dev See {IERC721-getApproved}.
823      */
824     function getApproved(uint256 tokenId) public view virtual override returns (address) {
825         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
826 
827         return _tokenApprovals[tokenId];
828     }
829 
830     /**
831      * @dev See {IERC721-setApprovalForAll}.
832      */
833     function setApprovalForAll(address operator, bool approved) public virtual override {
834         require(operator != _msgSender(), "ERC721: approve to caller");
835 
836         _operatorApprovals[_msgSender()][operator] = approved;
837         emit ApprovalForAll(_msgSender(), operator, approved);
838     }
839 
840     /**
841      * @dev See {IERC721-isApprovedForAll}.
842      */
843     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
844         return _operatorApprovals[owner][operator];
845     }
846 
847     /**
848      * @dev See {IERC721-transferFrom}.
849      */
850     function transferFrom(
851         address from,
852         address to,
853         uint256 tokenId
854     ) public virtual override {
855         //solhint-disable-next-line max-line-length
856         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
857 
858         _transfer(from, to, tokenId);
859     }
860 
861     /**
862      * @dev See {IERC721-safeTransferFrom}.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public virtual override {
869         safeTransferFrom(from, to, tokenId, "");
870     }
871 
872     /**
873      * @dev See {IERC721-safeTransferFrom}.
874      */
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId,
879         bytes memory _data
880     ) public virtual override {
881         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
882         _safeTransfer(from, to, tokenId, _data);
883     }
884 
885     /**
886      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
887      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
888      *
889      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
890      *
891      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
892      * implement alternative mechanisms to perform token transfer, such as signature-based.
893      *
894      * Requirements:
895      *
896      * - `from` cannot be the zero address.
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must exist and be owned by `from`.
899      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _safeTransfer(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) internal virtual {
909         _transfer(from, to, tokenId);
910         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
911     }
912 
913     /**
914      * @dev Returns whether `tokenId` exists.
915      *
916      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
917      *
918      * Tokens start existing when they are minted (`_mint`),
919      * and stop existing when they are burned (`_burn`).
920      */
921     function _exists(uint256 tokenId) internal view virtual returns (bool) {
922         return _owners[tokenId] != address(0);
923     }
924 
925     /**
926      * @dev Returns whether `spender` is allowed to manage `tokenId`.
927      *
928      * Requirements:
929      *
930      * - `tokenId` must exist.
931      */
932     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
933         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
934         address owner = ERC721.ownerOf(tokenId);
935         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
936     }
937 
938     /**
939      * @dev Safely mints `tokenId` and transfers it to `to`.
940      *
941      * Requirements:
942      *
943      * - `tokenId` must not exist.
944      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _safeMint(address to, uint256 tokenId) internal virtual {
949         _safeMint(to, tokenId, "");
950     }
951 
952     /**
953      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
954      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
955      */
956     function _safeMint(
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) internal virtual {
961         _mint(to, tokenId);
962         require(
963             _checkOnERC721Received(address(0), to, tokenId, _data),
964             "ERC721: transfer to non ERC721Receiver implementer"
965         );
966     }
967 
968     /**
969      * @dev Mints `tokenId` and transfers it to `to`.
970      *
971      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
972      *
973      * Requirements:
974      *
975      * - `tokenId` must not exist.
976      * - `to` cannot be the zero address.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _mint(address to, uint256 tokenId) internal virtual {
981         require(to != address(0), "ERC721: mint to the zero address");
982         require(!_exists(tokenId), "ERC721: token already minted");
983 
984         _beforeTokenTransfer(address(0), to, tokenId);
985 
986         _balances[to] += 1;
987         _owners[tokenId] = to;
988 
989         emit Transfer(address(0), to, tokenId);
990     }
991 
992     /**
993      * @dev Destroys `tokenId`.
994      * The approval is cleared when the token is burned.
995      *
996      * Requirements:
997      *
998      * - `tokenId` must exist.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _burn(uint256 tokenId) internal virtual {
1003         address owner = ERC721.ownerOf(tokenId);
1004 
1005         _beforeTokenTransfer(owner, address(0), tokenId);
1006 
1007         // Clear approvals
1008         _approve(address(0), tokenId);
1009 
1010         _balances[owner] -= 1;
1011         delete _owners[tokenId];
1012 
1013         emit Transfer(owner, address(0), tokenId);
1014     }
1015 
1016     /**
1017      * @dev Transfers `tokenId` from `from` to `to`.
1018      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1019      *
1020      * Requirements:
1021      *
1022      * - `to` cannot be the zero address.
1023      * - `tokenId` token must be owned by `from`.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function _transfer(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) internal virtual {
1032         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1033         require(to != address(0), "ERC721: transfer to the zero address");
1034 
1035         _beforeTokenTransfer(from, to, tokenId);
1036 
1037         // Clear approvals from the previous owner
1038         _approve(address(0), tokenId);
1039 
1040         _balances[from] -= 1;
1041         _balances[to] += 1;
1042         _owners[tokenId] = to;
1043 
1044         emit Transfer(from, to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev Approve `to` to operate on `tokenId`
1049      *
1050      * Emits a {Approval} event.
1051      */
1052     function _approve(address to, uint256 tokenId) internal virtual {
1053         _tokenApprovals[tokenId] = to;
1054         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1055     }
1056 
1057     /**
1058      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1059      * The call is not executed if the target address is not a contract.
1060      *
1061      * @param from address representing the previous owner of the given token ID
1062      * @param to target address that will receive the tokens
1063      * @param tokenId uint256 ID of the token to be transferred
1064      * @param _data bytes optional data to send along with the call
1065      * @return bool whether the call correctly returned the expected magic value
1066      */
1067     function _checkOnERC721Received(
1068         address from,
1069         address to,
1070         uint256 tokenId,
1071         bytes memory _data
1072     ) private returns (bool) {
1073         if (to.isContract()) {
1074             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1075                 return retval == IERC721Receiver.onERC721Received.selector;
1076             } catch (bytes memory reason) {
1077                 if (reason.length == 0) {
1078                     revert("ERC721: transfer to non ERC721Receiver implementer");
1079                 } else {
1080                     assembly {
1081                         revert(add(32, reason), mload(reason))
1082                     }
1083                 }
1084             }
1085         } else {
1086             return true;
1087         }
1088     }
1089 
1090     /**
1091      * @dev Hook that is called before any token transfer. This includes minting
1092      * and burning.
1093      *
1094      * Calling conditions:
1095      *
1096      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1097      * transferred to `to`.
1098      * - When `from` is zero, `tokenId` will be minted for `to`.
1099      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1100      * - `from` and `to` are never both zero.
1101      *
1102      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1103      */
1104     function _beforeTokenTransfer(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) internal virtual {}
1109 }
1110 
1111 ////// src/SeriesOne.sol
1112 /* pragma solidity ^0.8.0; */
1113 
1114 /* import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; */
1115 /* import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; */
1116 /* import "@openzeppelin/contracts/access/Ownable.sol"; */
1117 
1118 interface IERC1155 {
1119     function burn(
1120         address,
1121         uint256,
1122         uint256
1123     ) external;
1124 }
1125 
1126 contract SeriesOne is ERC721, Ownable, ReentrancyGuard {
1127     using Strings for uint256;
1128 
1129     address public constant PASS = 0x819cE9C4e15258735F441000cD005643D4479A1E;
1130     uint256 public constant PASSID = 1;
1131 
1132     uint256 public constant MAX_SUPPLY = 2949;
1133     uint256 public totalSupply;
1134     uint256 internal nonce = 0;
1135     uint256[MAX_SUPPLY] private indices;
1136 
1137     string internal baseURISpecial;
1138 
1139     constructor() ERC721("Ethnology: Series 1", "ETHNOS S1") {
1140         _mint(msg.sender, 11111);
1141         _mint(msg.sender, 22222);
1142         _mint(msg.sender, 33333);
1143         _mint(msg.sender, 44444);
1144         _mint(msg.sender, 55555);
1145         totalSupply = 5;
1146     }
1147 
1148     function _baseURI() internal pure override returns (string memory) {
1149         return "ipfs://QmSeaZmmX1SLP7LquqTCombPwwWVaLFNK3Q2nnmmhicbR5/";
1150     }
1151 
1152     function setSpecialURI(string calldata _uri) external onlyOwner {
1153         baseURISpecial = _uri;
1154     }
1155 
1156     function _baseURISecial() internal view returns (string memory) {
1157         return baseURISpecial;
1158     }
1159 
1160     function tokenURI(uint256 tokenId)
1161         public
1162         view
1163         override
1164         returns (string memory)
1165     {
1166         require(
1167             _exists(tokenId),
1168             "ERC721Metadata: URI query for nonexistent token"
1169         );
1170 
1171         string memory baseURI;
1172         tokenId < 2950 ? baseURI = _baseURI() : baseURI = _baseURISecial();
1173         return
1174             bytes(baseURI).length > 0
1175                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
1176                 : "";
1177     }
1178 
1179     /// Minter Function ///
1180 
1181     function mint(uint256 amount) external nonReentrant {
1182         require(amount <= 25, "too many");
1183         IERC1155(PASS).burn(msg.sender, PASSID, amount);
1184         for (uint256 x = 0; x < amount; x++) {
1185             _mint(msg.sender, _getRandomId());
1186             totalSupply++;
1187         }
1188     }
1189 
1190     function _getRandomId() internal returns (uint256) {
1191         uint256 totalSize = MAX_SUPPLY - totalSupply - 5;
1192         uint256 index = uint256(
1193             keccak256(
1194                 abi.encodePacked(
1195                     nonce,
1196                     "EthnologySeries1Salt",
1197                     blockhash(block.number),
1198                     msg.sender,
1199                     block.difficulty,
1200                     block.timestamp,
1201                     gasleft()
1202                 )
1203             )
1204         ) % totalSize;
1205 
1206         uint256 value = 0;
1207         if (indices[index] != 0) {
1208             value = indices[index];
1209         } else {
1210             value = index;
1211         }
1212 
1213         if (indices[totalSize - 1] == 0) {
1214             indices[index] = totalSize - 1;
1215         } else {
1216             indices[index] = indices[totalSize - 1];
1217         }
1218         nonce++;
1219         return value;
1220     }
1221 }