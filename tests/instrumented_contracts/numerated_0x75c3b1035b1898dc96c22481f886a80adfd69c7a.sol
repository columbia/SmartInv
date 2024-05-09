1 // SPDX-License-Identifier: Unlicense
2 
3 /*                                                                                          
4 PPPPPPPPPPPPPPPPP   FFFFFFFFFFFFFFFFFFFFFFPPPPPPPPPPPPPPPPP                   
5 P::::::::::::::::P  F::::::::::::::::::::FP::::::::::::::::P                  
6 P::::::PPPPPP:::::P F::::::::::::::::::::FP::::::PPPPPP:::::P                 
7 PP:::::P     P:::::PFF::::::FFFFFFFFF::::FPP:::::P     P:::::P                
8   P::::P     P:::::P  F:::::F       FFFFFF  P::::P     P:::::P   ssssssssss   
9   P::::P     P:::::P  F:::::F               P::::P     P:::::P ss::::::::::s  
10   P::::PPPPPP:::::P   F::::::FFFFFFFFFF     P::::PPPPPP:::::Pss:::::::::::::s 
11   P:::::::::::::PP    F:::::::::::::::F     P:::::::::::::PP s::::::ssss:::::s
12   P::::PPPPPPPPP      F:::::::::::::::F     P::::PPPPPPPPP    s:::::s  ssssss 
13   P::::P              F::::::FFFFFFFFFF     P::::P              s::::::s      
14   P::::P              F:::::F               P::::P                 s::::::s   
15   P::::P              F:::::F               P::::P           ssssss   s:::::s 
16 PP::::::PP          FF:::::::FF           PP::::::PP         s:::::ssss::::::s
17 P::::::::P          F::::::::FF           P::::::::P         s::::::::::::::s 
18 P::::::::P          F::::::::FF           P::::::::P          s:::::::::::ss  
19 PPPPPPPPPP          FFFFFFFFFFF           PPPPPPPPPP           sssssssssss by dom
20 */  
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev Interface of the ERC165 standard, as defined in the
26  * https://eips.ethereum.org/EIPS/eip-165[EIP].
27  *
28  * Implementers can declare support of contract interfaces, which can then be
29  * queried by others ({ERC165Checker}).
30  *
31  * For an implementation, see {ERC165}.
32  */
33 interface IERC165 {
34     /**
35      * @dev Returns true if this contract implements the interface defined by
36      * `interfaceId`. See the corresponding
37      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
38      * to learn more about how these ids are created.
39      *
40      * This function call must use less than 30 000 gas.
41      */
42     function supportsInterface(bytes4 interfaceId) external view returns (bool);
43 }
44 
45 /**
46  * @dev Required interface of an ERC721 compliant contract.
47  */
48 interface IERC721 is IERC165 {
49     /**
50      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
51      */
52     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
53 
54     /**
55      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
56      */
57     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
58 
59     /**
60      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
61      */
62     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
63 
64     /**
65      * @dev Returns the number of tokens in ``owner``'s account.
66      */
67     function balanceOf(address owner) external view returns (uint256 balance);
68 
69     /**
70      * @dev Returns the owner of the `tokenId` token.
71      *
72      * Requirements:
73      *
74      * - `tokenId` must exist.
75      */
76     function ownerOf(uint256 tokenId) external view returns (address owner);
77 
78     /**
79      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
80      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must exist and be owned by `from`.
87      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
88      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
89      *
90      * Emits a {Transfer} event.
91      */
92     function safeTransferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Transfers `tokenId` token from `from` to `to`.
100      *
101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(
113         address from,
114         address to,
115         uint256 tokenId
116     ) external;
117 
118     /**
119      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
120      * The approval is cleared when the token is transferred.
121      *
122      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
123      *
124      * Requirements:
125      *
126      * - The caller must own the token or be an approved operator.
127      * - `tokenId` must exist.
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address to, uint256 tokenId) external;
132 
133     /**
134      * @dev Returns the account approved for `tokenId` token.
135      *
136      * Requirements:
137      *
138      * - `tokenId` must exist.
139      */
140     function getApproved(uint256 tokenId) external view returns (address operator);
141 
142     /**
143      * @dev Approve or remove `operator` as an operator for the caller.
144      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145      *
146      * Requirements:
147      *
148      * - The `operator` cannot be the caller.
149      *
150      * Emits an {ApprovalForAll} event.
151      */
152     function setApprovalForAll(address operator, bool _approved) external;
153 
154     /**
155      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
156      *
157      * See {setApprovalForAll}
158      */
159     function isApprovedForAll(address owner, address operator) external view returns (bool);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId,
178         bytes calldata data
179     ) external;
180 }
181 
182 
183 
184 
185 /**
186  * @dev String operations.
187  */
188 library Strings {
189     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
190 
191     /**
192      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
193      */
194     function toString(uint256 value) internal pure returns (string memory) {
195         // Inspired by OraclizeAPI's implementation - MIT licence
196         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
197 
198         if (value == 0) {
199             return "0";
200         }
201         uint256 temp = value;
202         uint256 digits;
203         while (temp != 0) {
204             digits++;
205             temp /= 10;
206         }
207         bytes memory buffer = new bytes(digits);
208         while (value != 0) {
209             digits -= 1;
210             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
211             value /= 10;
212         }
213         return string(buffer);
214     }
215 
216     /**
217      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
218      */
219     function toHexString(uint256 value) internal pure returns (string memory) {
220         if (value == 0) {
221             return "0x00";
222         }
223         uint256 temp = value;
224         uint256 length = 0;
225         while (temp != 0) {
226             length++;
227             temp >>= 8;
228         }
229         return toHexString(value, length);
230     }
231 
232     /**
233      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
234      */
235     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
236         bytes memory buffer = new bytes(2 * length + 2);
237         buffer[0] = "0";
238         buffer[1] = "x";
239         for (uint256 i = 2 * length + 1; i > 1; --i) {
240             buffer[i] = _HEX_SYMBOLS[value & 0xf];
241             value >>= 4;
242         }
243         require(value == 0, "Strings: hex length insufficient");
244         return string(buffer);
245     }
246 }
247 
248 
249 
250 
251 /*
252  * @dev Provides information about the current execution context, including the
253  * sender of the transaction and its data. While these are generally available
254  * via msg.sender and msg.data, they should not be accessed in such a direct
255  * manner, since when dealing with meta-transactions the account sending and
256  * paying for execution may not be the actual sender (as far as an application
257  * is concerned).
258  *
259  * This contract is only required for intermediate, library-like contracts.
260  */
261 abstract contract Context {
262     function _msgSender() internal view virtual returns (address) {
263         return msg.sender;
264     }
265 
266     function _msgData() internal view virtual returns (bytes calldata) {
267         return msg.data;
268     }
269 }
270 
271 
272 
273 
274 
275 
276 
277 
278 
279 /**
280  * @dev Contract module which provides a basic access control mechanism, where
281  * there is an account (an owner) that can be granted exclusive access to
282  * specific functions.
283  *
284  * By default, the owner account will be the one that deploys the contract. This
285  * can later be changed with {transferOwnership}.
286  *
287  * This module is used through inheritance. It will make available the modifier
288  * `onlyOwner`, which can be applied to your functions to restrict their use to
289  * the owner.
290  */
291 abstract contract Ownable is Context {
292     address private _owner;
293 
294     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
295 
296     /**
297      * @dev Initializes the contract setting the deployer as the initial owner.
298      */
299     constructor() {
300         _setOwner(_msgSender());
301     }
302 
303     /**
304      * @dev Returns the address of the current owner.
305      */
306     function owner() public view virtual returns (address) {
307         return _owner;
308     }
309 
310     /**
311      * @dev Throws if called by any account other than the owner.
312      */
313     modifier onlyOwner() {
314         require(owner() == _msgSender(), "Ownable: caller is not the owner");
315         _;
316     }
317 
318     /**
319      * @dev Leaves the contract without owner. It will not be possible to call
320      * `onlyOwner` functions anymore. Can only be called by the current owner.
321      *
322      * NOTE: Renouncing ownership will leave the contract without an owner,
323      * thereby removing any functionality that is only available to the owner.
324      */
325     function renounceOwnership() public virtual onlyOwner {
326         _setOwner(address(0));
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Can only be called by the current owner.
332      */
333     function transferOwnership(address newOwner) public virtual onlyOwner {
334         require(newOwner != address(0), "Ownable: new owner is the zero address");
335         _setOwner(newOwner);
336     }
337 
338     function _setOwner(address newOwner) private {
339         address oldOwner = _owner;
340         _owner = newOwner;
341         emit OwnershipTransferred(oldOwner, newOwner);
342     }
343 }
344 
345 
346 
347 
348 
349 /**
350  * @dev Contract module that helps prevent reentrant calls to a function.
351  *
352  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
353  * available, which can be applied to functions to make sure there are no nested
354  * (reentrant) calls to them.
355  *
356  * Note that because there is a single `nonReentrant` guard, functions marked as
357  * `nonReentrant` may not call one another. This can be worked around by making
358  * those functions `private`, and then adding `external` `nonReentrant` entry
359  * points to them.
360  *
361  * TIP: If you would like to learn more about reentrancy and alternative ways
362  * to protect against it, check out our blog post
363  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
364  */
365 abstract contract ReentrancyGuard {
366     // Booleans are more expensive than uint256 or any type that takes up a full
367     // word because each write operation emits an extra SLOAD to first read the
368     // slot's contents, replace the bits taken up by the boolean, and then write
369     // back. This is the compiler's defense against contract upgrades and
370     // pointer aliasing, and it cannot be disabled.
371 
372     // The values being non-zero value makes deployment a bit more expensive,
373     // but in exchange the refund on every call to nonReentrant will be lower in
374     // amount. Since refunds are capped to a percentage of the total
375     // transaction's gas, it is best to keep them low in cases like this one, to
376     // increase the likelihood of the full refund coming into effect.
377     uint256 private constant _NOT_ENTERED = 1;
378     uint256 private constant _ENTERED = 2;
379 
380     uint256 private _status;
381 
382     constructor() {
383         _status = _NOT_ENTERED;
384     }
385 
386     /**
387      * @dev Prevents a contract from calling itself, directly or indirectly.
388      * Calling a `nonReentrant` function from another `nonReentrant`
389      * function is not supported. It is possible to prevent this from happening
390      * by making the `nonReentrant` function external, and make it call a
391      * `private` function that does the actual work.
392      */
393     modifier nonReentrant() {
394         // On the first call to nonReentrant, _notEntered will be true
395         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
396 
397         // Any calls to nonReentrant after this point will fail
398         _status = _ENTERED;
399 
400         _;
401 
402         // By storing the original value once again, a refund is triggered (see
403         // https://eips.ethereum.org/EIPS/eip-2200)
404         _status = _NOT_ENTERED;
405     }
406 }
407 
408 
409 
410 
411 
412 
413 
414 
415 
416 
417 
418 
419 
420 
421 /**
422  * @title ERC721 token receiver interface
423  * @dev Interface for any contract that wants to support safeTransfers
424  * from ERC721 asset contracts.
425  */
426 interface IERC721Receiver {
427     /**
428      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
429      * by `operator` from `from`, this function is called.
430      *
431      * It must return its Solidity selector to confirm the token transfer.
432      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
433      *
434      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
435      */
436     function onERC721Received(
437         address operator,
438         address from,
439         uint256 tokenId,
440         bytes calldata data
441     ) external returns (bytes4);
442 }
443 
444 
445 
446 
447 
448 
449 
450 /**
451  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
452  * @dev See https://eips.ethereum.org/EIPS/eip-721
453  */
454 interface IERC721Metadata is IERC721 {
455     /**
456      * @dev Returns the token collection name.
457      */
458     function name() external view returns (string memory);
459 
460     /**
461      * @dev Returns the token collection symbol.
462      */
463     function symbol() external view returns (string memory);
464 
465     /**
466      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
467      */
468     function tokenURI(uint256 tokenId) external view returns (string memory);
469 }
470 
471 
472 
473 
474 
475 /**
476  * @dev Collection of functions related to the address type
477  */
478 library Address {
479     /**
480      * @dev Returns true if `account` is a contract.
481      *
482      * [IMPORTANT]
483      * ====
484      * It is unsafe to assume that an address for which this function returns
485      * false is an externally-owned account (EOA) and not a contract.
486      *
487      * Among others, `isContract` will return false for the following
488      * types of addresses:
489      *
490      *  - an externally-owned account
491      *  - a contract in construction
492      *  - an address where a contract will be created
493      *  - an address where a contract lived, but was destroyed
494      * ====
495      */
496     function isContract(address account) internal view returns (bool) {
497         // This method relies on extcodesize, which returns 0 for contracts in
498         // construction, since the code is only stored at the end of the
499         // constructor execution.
500 
501         uint256 size;
502         assembly {
503             size := extcodesize(account)
504         }
505         return size > 0;
506     }
507 
508     /**
509      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
510      * `recipient`, forwarding all available gas and reverting on errors.
511      *
512      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
513      * of certain opcodes, possibly making contracts go over the 2300 gas limit
514      * imposed by `transfer`, making them unable to receive funds via
515      * `transfer`. {sendValue} removes this limitation.
516      *
517      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
518      *
519      * IMPORTANT: because control is transferred to `recipient`, care must be
520      * taken to not create reentrancy vulnerabilities. Consider using
521      * {ReentrancyGuard} or the
522      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
523      */
524     function sendValue(address payable recipient, uint256 amount) internal {
525         require(address(this).balance >= amount, "Address: insufficient balance");
526 
527         (bool success, ) = recipient.call{value: amount}("");
528         require(success, "Address: unable to send value, recipient may have reverted");
529     }
530 
531     /**
532      * @dev Performs a Solidity function call using a low level `call`. A
533      * plain `call` is an unsafe replacement for a function call: use this
534      * function instead.
535      *
536      * If `target` reverts with a revert reason, it is bubbled up by this
537      * function (like regular Solidity function calls).
538      *
539      * Returns the raw returned data. To convert to the expected return value,
540      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
541      *
542      * Requirements:
543      *
544      * - `target` must be a contract.
545      * - calling `target` with `data` must not revert.
546      *
547      * _Available since v3.1._
548      */
549     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
550         return functionCall(target, data, "Address: low-level call failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
555      * `errorMessage` as a fallback revert reason when `target` reverts.
556      *
557      * _Available since v3.1._
558      */
559     function functionCall(
560         address target,
561         bytes memory data,
562         string memory errorMessage
563     ) internal returns (bytes memory) {
564         return functionCallWithValue(target, data, 0, errorMessage);
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
569      * but also transferring `value` wei to `target`.
570      *
571      * Requirements:
572      *
573      * - the calling contract must have an ETH balance of at least `value`.
574      * - the called Solidity function must be `payable`.
575      *
576      * _Available since v3.1._
577      */
578     function functionCallWithValue(
579         address target,
580         bytes memory data,
581         uint256 value
582     ) internal returns (bytes memory) {
583         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
588      * with `errorMessage` as a fallback revert reason when `target` reverts.
589      *
590      * _Available since v3.1._
591      */
592     function functionCallWithValue(
593         address target,
594         bytes memory data,
595         uint256 value,
596         string memory errorMessage
597     ) internal returns (bytes memory) {
598         require(address(this).balance >= value, "Address: insufficient balance for call");
599         require(isContract(target), "Address: call to non-contract");
600 
601         (bool success, bytes memory returndata) = target.call{value: value}(data);
602         return _verifyCallResult(success, returndata, errorMessage);
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
607      * but performing a static call.
608      *
609      * _Available since v3.3._
610      */
611     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
612         return functionStaticCall(target, data, "Address: low-level static call failed");
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
617      * but performing a static call.
618      *
619      * _Available since v3.3._
620      */
621     function functionStaticCall(
622         address target,
623         bytes memory data,
624         string memory errorMessage
625     ) internal view returns (bytes memory) {
626         require(isContract(target), "Address: static call to non-contract");
627 
628         (bool success, bytes memory returndata) = target.staticcall(data);
629         return _verifyCallResult(success, returndata, errorMessage);
630     }
631 
632     /**
633      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
634      * but performing a delegate call.
635      *
636      * _Available since v3.4._
637      */
638     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
639         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
644      * but performing a delegate call.
645      *
646      * _Available since v3.4._
647      */
648     function functionDelegateCall(
649         address target,
650         bytes memory data,
651         string memory errorMessage
652     ) internal returns (bytes memory) {
653         require(isContract(target), "Address: delegate call to non-contract");
654 
655         (bool success, bytes memory returndata) = target.delegatecall(data);
656         return _verifyCallResult(success, returndata, errorMessage);
657     }
658 
659     function _verifyCallResult(
660         bool success,
661         bytes memory returndata,
662         string memory errorMessage
663     ) private pure returns (bytes memory) {
664         if (success) {
665             return returndata;
666         } else {
667             // Look for revert reason and bubble it up if present
668             if (returndata.length > 0) {
669                 // The easiest way to bubble the revert reason is using memory via assembly
670 
671                 assembly {
672                     let returndata_size := mload(returndata)
673                     revert(add(32, returndata), returndata_size)
674                 }
675             } else {
676                 revert(errorMessage);
677             }
678         }
679     }
680 }
681 
682 
683 
684 
685 
686 
687 
688 
689 
690 /**
691  * @dev Implementation of the {IERC165} interface.
692  *
693  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
694  * for the additional interface id that will be supported. For example:
695  *
696  * ```solidity
697  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
698  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
699  * }
700  * ```
701  *
702  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
703  */
704 abstract contract ERC165 is IERC165 {
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
709         return interfaceId == type(IERC165).interfaceId;
710     }
711 }
712 
713 
714 /**
715  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
716  * the Metadata extension, but not including the Enumerable extension, which is available separately as
717  * {ERC721Enumerable}.
718  */
719 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
720     using Address for address;
721     using Strings for uint256;
722 
723     // Token name
724     string private _name;
725 
726     // Token symbol
727     string private _symbol;
728 
729     // Mapping from token ID to owner address
730     mapping(uint256 => address) private _owners;
731 
732     // Mapping owner address to token count
733     mapping(address => uint256) private _balances;
734 
735     // Mapping from token ID to approved address
736     mapping(uint256 => address) private _tokenApprovals;
737 
738     // Mapping from owner to operator approvals
739     mapping(address => mapping(address => bool)) private _operatorApprovals;
740 
741     /**
742      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
743      */
744     constructor(string memory name_, string memory symbol_) {
745         _name = name_;
746         _symbol = symbol_;
747     }
748 
749     /**
750      * @dev See {IERC165-supportsInterface}.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
753         return
754             interfaceId == type(IERC721).interfaceId ||
755             interfaceId == type(IERC721Metadata).interfaceId ||
756             super.supportsInterface(interfaceId);
757     }
758 
759     /**
760      * @dev See {IERC721-balanceOf}.
761      */
762     function balanceOf(address owner) public view virtual override returns (uint256) {
763         require(owner != address(0), "ERC721: balance query for the zero address");
764         return _balances[owner];
765     }
766 
767     /**
768      * @dev See {IERC721-ownerOf}.
769      */
770     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
771         address owner = _owners[tokenId];
772         require(owner != address(0), "ERC721: owner query for nonexistent token");
773         return owner;
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-name}.
778      */
779     function name() public view virtual override returns (string memory) {
780         return _name;
781     }
782 
783     /**
784      * @dev See {IERC721Metadata-symbol}.
785      */
786     function symbol() public view virtual override returns (string memory) {
787         return _symbol;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-tokenURI}.
792      */
793     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
794         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
795 
796         string memory baseURI = _baseURI();
797         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
798     }
799 
800     /**
801      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
802      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
803      * by default, can be overriden in child contracts.
804      */
805     function _baseURI() internal view virtual returns (string memory) {
806         return "";
807     }
808 
809     /**
810      * @dev See {IERC721-approve}.
811      */
812     function approve(address to, uint256 tokenId) public virtual override {
813         address owner = ERC721.ownerOf(tokenId);
814         require(to != owner, "ERC721: approval to current owner");
815 
816         require(
817             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
818             "ERC721: approve caller is not owner nor approved for all"
819         );
820 
821         _approve(to, tokenId);
822     }
823 
824     /**
825      * @dev See {IERC721-getApproved}.
826      */
827     function getApproved(uint256 tokenId) public view virtual override returns (address) {
828         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
829 
830         return _tokenApprovals[tokenId];
831     }
832 
833     /**
834      * @dev See {IERC721-setApprovalForAll}.
835      */
836     function setApprovalForAll(address operator, bool approved) public virtual override {
837         require(operator != _msgSender(), "ERC721: approve to caller");
838 
839         _operatorApprovals[_msgSender()][operator] = approved;
840         emit ApprovalForAll(_msgSender(), operator, approved);
841     }
842 
843     /**
844      * @dev See {IERC721-isApprovedForAll}.
845      */
846     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
847         return _operatorApprovals[owner][operator];
848     }
849 
850     /**
851      * @dev See {IERC721-transferFrom}.
852      */
853     function transferFrom(
854         address from,
855         address to,
856         uint256 tokenId
857     ) public virtual override {
858         //solhint-disable-next-line max-line-length
859         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
860 
861         _transfer(from, to, tokenId);
862     }
863 
864     /**
865      * @dev See {IERC721-safeTransferFrom}.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId
871     ) public virtual override {
872         safeTransferFrom(from, to, tokenId, "");
873     }
874 
875     /**
876      * @dev See {IERC721-safeTransferFrom}.
877      */
878     function safeTransferFrom(
879         address from,
880         address to,
881         uint256 tokenId,
882         bytes memory _data
883     ) public virtual override {
884         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
885         _safeTransfer(from, to, tokenId, _data);
886     }
887 
888     /**
889      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
890      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
891      *
892      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
893      *
894      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
895      * implement alternative mechanisms to perform token transfer, such as signature-based.
896      *
897      * Requirements:
898      *
899      * - `from` cannot be the zero address.
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must exist and be owned by `from`.
902      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _safeTransfer(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) internal virtual {
912         _transfer(from, to, tokenId);
913         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
914     }
915 
916     /**
917      * @dev Returns whether `tokenId` exists.
918      *
919      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
920      *
921      * Tokens start existing when they are minted (`_mint`),
922      * and stop existing when they are burned (`_burn`).
923      */
924     function _exists(uint256 tokenId) internal view virtual returns (bool) {
925         return _owners[tokenId] != address(0);
926     }
927 
928     /**
929      * @dev Returns whether `spender` is allowed to manage `tokenId`.
930      *
931      * Requirements:
932      *
933      * - `tokenId` must exist.
934      */
935     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
936         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
937         address owner = ERC721.ownerOf(tokenId);
938         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
939     }
940 
941     /**
942      * @dev Safely mints `tokenId` and transfers it to `to`.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must not exist.
947      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
948      *
949      * Emits a {Transfer} event.
950      */
951     function _safeMint(address to, uint256 tokenId) internal virtual {
952         _safeMint(to, tokenId, "");
953     }
954 
955     /**
956      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
957      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
958      */
959     function _safeMint(
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) internal virtual {
964         _mint(to, tokenId);
965         require(
966             _checkOnERC721Received(address(0), to, tokenId, _data),
967             "ERC721: transfer to non ERC721Receiver implementer"
968         );
969     }
970 
971     /**
972      * @dev Mints `tokenId` and transfers it to `to`.
973      *
974      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
975      *
976      * Requirements:
977      *
978      * - `tokenId` must not exist.
979      * - `to` cannot be the zero address.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _mint(address to, uint256 tokenId) internal virtual {
984         require(to != address(0), "ERC721: mint to the zero address");
985         require(!_exists(tokenId), "ERC721: token already minted");
986 
987         _beforeTokenTransfer(address(0), to, tokenId);
988 
989         _balances[to] += 1;
990         _owners[tokenId] = to;
991 
992         emit Transfer(address(0), to, tokenId);
993     }
994 
995     /**
996      * @dev Destroys `tokenId`.
997      * The approval is cleared when the token is burned.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must exist.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _burn(uint256 tokenId) internal virtual {
1006         address owner = ERC721.ownerOf(tokenId);
1007 
1008         _beforeTokenTransfer(owner, address(0), tokenId);
1009 
1010         // Clear approvals
1011         _approve(address(0), tokenId);
1012 
1013         _balances[owner] -= 1;
1014         delete _owners[tokenId];
1015 
1016         emit Transfer(owner, address(0), tokenId);
1017     }
1018 
1019     /**
1020      * @dev Transfers `tokenId` from `from` to `to`.
1021      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must be owned by `from`.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _transfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) internal virtual {
1035         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1036         require(to != address(0), "ERC721: transfer to the zero address");
1037 
1038         _beforeTokenTransfer(from, to, tokenId);
1039 
1040         // Clear approvals from the previous owner
1041         _approve(address(0), tokenId);
1042 
1043         _balances[from] -= 1;
1044         _balances[to] += 1;
1045         _owners[tokenId] = to;
1046 
1047         emit Transfer(from, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Approve `to` to operate on `tokenId`
1052      *
1053      * Emits a {Approval} event.
1054      */
1055     function _approve(address to, uint256 tokenId) internal virtual {
1056         _tokenApprovals[tokenId] = to;
1057         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1062      * The call is not executed if the target address is not a contract.
1063      *
1064      * @param from address representing the previous owner of the given token ID
1065      * @param to target address that will receive the tokens
1066      * @param tokenId uint256 ID of the token to be transferred
1067      * @param _data bytes optional data to send along with the call
1068      * @return bool whether the call correctly returned the expected magic value
1069      */
1070     function _checkOnERC721Received(
1071         address from,
1072         address to,
1073         uint256 tokenId,
1074         bytes memory _data
1075     ) private returns (bool) {
1076         if (to.isContract()) {
1077             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1078                 return retval == IERC721Receiver(to).onERC721Received.selector;
1079             } catch (bytes memory reason) {
1080                 if (reason.length == 0) {
1081                     revert("ERC721: transfer to non ERC721Receiver implementer");
1082                 } else {
1083                     assembly {
1084                         revert(add(32, reason), mload(reason))
1085                     }
1086                 }
1087             }
1088         } else {
1089             return true;
1090         }
1091     }
1092 
1093     /**
1094      * @dev Hook that is called before any token transfer. This includes minting
1095      * and burning.
1096      *
1097      * Calling conditions:
1098      *
1099      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1100      * transferred to `to`.
1101      * - When `from` is zero, `tokenId` will be minted for `to`.
1102      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1103      * - `from` and `to` are never both zero.
1104      *
1105      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1106      */
1107     function _beforeTokenTransfer(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) internal virtual {}
1112 }
1113 
1114 
1115 
1116 
1117 
1118 
1119 
1120 /**
1121  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1122  * @dev See https://eips.ethereum.org/EIPS/eip-721
1123  */
1124 interface IERC721Enumerable is IERC721 {
1125     /**
1126      * @dev Returns the total amount of tokens stored by the contract.
1127      */
1128     function totalSupply() external view returns (uint256);
1129 
1130     /**
1131      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1132      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1133      */
1134     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1135 
1136     /**
1137      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1138      * Use along with {totalSupply} to enumerate all tokens.
1139      */
1140     function tokenByIndex(uint256 index) external view returns (uint256);
1141 }
1142 
1143 
1144 /**
1145  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1146  * enumerability of all the token ids in the contract as well as all token ids owned by each
1147  * account.
1148  */
1149 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1150     // Mapping from owner to list of owned token IDs
1151     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1152 
1153     // Mapping from token ID to index of the owner tokens list
1154     mapping(uint256 => uint256) private _ownedTokensIndex;
1155 
1156     // Array with all token ids, used for enumeration
1157     uint256[] private _allTokens;
1158 
1159     // Mapping from token id to position in the allTokens array
1160     mapping(uint256 => uint256) private _allTokensIndex;
1161 
1162     /**
1163      * @dev See {IERC165-supportsInterface}.
1164      */
1165     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1166         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1167     }
1168 
1169     /**
1170      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1171      */
1172     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1173         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1174         return _ownedTokens[owner][index];
1175     }
1176 
1177     /**
1178      * @dev See {IERC721Enumerable-totalSupply}.
1179      */
1180     function totalSupply() public view virtual override returns (uint256) {
1181         return _allTokens.length;
1182     }
1183 
1184     /**
1185      * @dev See {IERC721Enumerable-tokenByIndex}.
1186      */
1187     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1188         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1189         return _allTokens[index];
1190     }
1191 
1192     /**
1193      * @dev Hook that is called before any token transfer. This includes minting
1194      * and burning.
1195      *
1196      * Calling conditions:
1197      *
1198      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1199      * transferred to `to`.
1200      * - When `from` is zero, `tokenId` will be minted for `to`.
1201      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1202      * - `from` cannot be the zero address.
1203      * - `to` cannot be the zero address.
1204      *
1205      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1206      */
1207     function _beforeTokenTransfer(
1208         address from,
1209         address to,
1210         uint256 tokenId
1211     ) internal virtual override {
1212         super._beforeTokenTransfer(from, to, tokenId);
1213 
1214         if (from == address(0)) {
1215             _addTokenToAllTokensEnumeration(tokenId);
1216         } else if (from != to) {
1217             _removeTokenFromOwnerEnumeration(from, tokenId);
1218         }
1219         if (to == address(0)) {
1220             _removeTokenFromAllTokensEnumeration(tokenId);
1221         } else if (to != from) {
1222             _addTokenToOwnerEnumeration(to, tokenId);
1223         }
1224     }
1225 
1226     /**
1227      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1228      * @param to address representing the new owner of the given token ID
1229      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1230      */
1231     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1232         uint256 length = ERC721.balanceOf(to);
1233         _ownedTokens[to][length] = tokenId;
1234         _ownedTokensIndex[tokenId] = length;
1235     }
1236 
1237     /**
1238      * @dev Private function to add a token to this extension's token tracking data structures.
1239      * @param tokenId uint256 ID of the token to be added to the tokens list
1240      */
1241     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1242         _allTokensIndex[tokenId] = _allTokens.length;
1243         _allTokens.push(tokenId);
1244     }
1245 
1246     /**
1247      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1248      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1249      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1250      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1251      * @param from address representing the previous owner of the given token ID
1252      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1253      */
1254     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1255         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1256         // then delete the last slot (swap and pop).
1257 
1258         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1259         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1260 
1261         // When the token to delete is the last token, the swap operation is unnecessary
1262         if (tokenIndex != lastTokenIndex) {
1263             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1264 
1265             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1266             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1267         }
1268 
1269         // This also deletes the contents at the last position of the array
1270         delete _ownedTokensIndex[tokenId];
1271         delete _ownedTokens[from][lastTokenIndex];
1272     }
1273 
1274     /**
1275      * @dev Private function to remove a token from this extension's token tracking data structures.
1276      * This has O(1) time complexity, but alters the order of the _allTokens array.
1277      * @param tokenId uint256 ID of the token to be removed from the tokens list
1278      */
1279     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1280         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1281         // then delete the last slot (swap and pop).
1282 
1283         uint256 lastTokenIndex = _allTokens.length - 1;
1284         uint256 tokenIndex = _allTokensIndex[tokenId];
1285 
1286         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1287         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1288         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1289         uint256 lastTokenId = _allTokens[lastTokenIndex];
1290 
1291         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1292         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1293 
1294         // This also deletes the contents at the last position of the array
1295         delete _allTokensIndex[tokenId];
1296         _allTokens.pop();
1297     }
1298 }
1299 
1300 interface Wagmigotchi {
1301     function love(address) external view returns (uint256);
1302 }
1303 
1304 contract PFP is ERC721Enumerable, ReentrancyGuard, Ownable {
1305     Wagmigotchi wagmi = Wagmigotchi(address(0xeCB504D39723b0be0e3a9Aa33D646642D1051EE1));
1306     Wagmigotchi wagmiOne = Wagmigotchi(address(0x57268ec83C8983D6907553A36072f737Eab67475));
1307 
1308     bool enabled = false;
1309 
1310     string constant header = '<svg width="400" height="400" viewBox="50 50 300 300" fill="none" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="gradient-fill" x1="0" y1="0" x2="800" y2="0" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="#1f005c" /><stop offset="0.14285714285714285" stop-color="#5b0060" /><stop offset="0.2857142857142857" stop-color="#870160" /><stop offset="0.42857142857142855" stop-color="#ac255e" /><stop offset="0.5714285714285714" stop-color="#ca485c" /><stop offset="0.7142857142857142" stop-color="#e16b5c" /><stop offset="0.8571428571428571" stop-color="#f39060" /><stop offset="1" stop-color="#ffb56b" /></linearGradient></defs>';
1311 
1312     string constant footer = '<g transform="translate(160 150)"><path d="M2 37C5.33333 42.3333 16.9 52.2 36.5 49C56.1 45.8 64 39.6667 65.5 37" stroke="black" stroke-width="5"/><path d="M3 12C3.73491 7.77554 6.28504 -0.0397118 10.6063 2.49496C14.9276 5.02964 16.6693 9.88777 17 12" stroke="black" stroke-width="5"/><path d="M42 12C42.7349 7.77554 45.285 -0.0397118 49.6063 2.49496C53.9276 5.02964 55.6693 9.88777 56 12" stroke="black" stroke-width="5"/></g></svg>';
1313 
1314     string constant halo = '<g transform="translate(161 76)"><path d="M36.7717 25.35C17.0173 28.6787 5.35958 18.4151 2 12.8671C2 8.78797 8.4 0.928144 34 2.12204C59.6 3.31594 66 9.78289 66 12.8671C64.4882 15.6411 56.526 22.0212 36.7717 25.35Z" stroke="black" stroke-width="10"/><path d="M36.7717 25.35C17.0173 28.6787 5.35958 18.4151 2 12.8671C2 8.78797 8.4 0.928144 34 2.12204C59.6 3.31594 66 9.78289 66 12.8671C64.4882 15.6411 56.526 22.0212 36.7717 25.35Z" stroke="#FFE600" stroke-width="5"/></g>';
1315     
1316     mapping (uint256 => address) internal _mints;
1317     mapping (address => bool) internal _claims;
1318     mapping (address => uint256) internal _love;
1319 
1320     function toggle() public onlyOwner nonReentrant {
1321         enabled = !enabled;
1322     }
1323     
1324     function random(bytes memory input, uint256 range) internal pure returns (uint256) {
1325         return uint256(keccak256(abi.encodePacked(input))) % range;
1326     }
1327 
1328     function draw(string memory color, string memory ox, string memory oy, string memory r, string memory scale, string memory opacity, bool stroke) internal pure returns (string memory) {
1329         string[17] memory parts;
1330         if (!stroke) {
1331             parts[0] = '<g opacity="';
1332         } else {
1333             parts[0] = '<g stroke-width="5" stroke="black" opacity="';
1334         }
1335         parts[1] = opacity;
1336         parts[2] = '" fill="';
1337         parts[3] = color;
1338         parts[4] = '" transform="translate(';
1339         parts[5] = ox;
1340         parts[6] = ' ';
1341         parts[7] = oy;
1342         parts[8] = ') rotate(';
1343         parts[9] = r;
1344         parts[10] = ' 81.5 110) scale(';
1345         parts[11] = scale;
1346         parts[12] = ')"><path d="M52.2262 2.0318C20.6262 9.2318 5.39287 69.0318 1.72621 98.0318C-3.77379 133.365 0.726208 206.932 62.7262 218.532C140.226 233.032 162.726 112.032 162.726 63.0318C162.726 14.0318 91.7262 -6.9682 52.2262 2.0318Z"/></g>';
1347 
1348         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7]));
1349         output = string(abi.encodePacked(output, parts[8], parts[9], parts[10], parts[11], parts[12]));
1350         return output;
1351     }
1352 
1353     function getLove(uint256 tokenId) public view returns (uint256) {
1354         address creator = _mints[tokenId];
1355         return _love[creator];
1356     }
1357 
1358     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1359         address creator = _mints[tokenId];
1360 
1361         string memory output;
1362 
1363         string[7] memory colors = [
1364             "#59B9FF",
1365             "#51FFD5",
1366             "#FFD159",
1367             "#FFA3A3",
1368             "#CA59FF",
1369             "#597EFF",
1370             "#FFDBDB"
1371         ];
1372 
1373         output = header;
1374         
1375         output = string(abi.encodePacked(output,
1376             '<rect width="400" height="400" fill="',
1377             colors[random(abi.encodePacked("BACKGROUND", creator), colors.length)],
1378             '" opacity="0.2" />'
1379         ));
1380 
1381         uint256 love = _love[creator];
1382         uint256 count = random(abi.encodePacked("BASECOUNT", creator), 3) + love;
1383 
1384         if (count >= 5) {
1385             count = 5;
1386         }
1387   
1388         for (uint256 i = 0; i < count; ++i) {
1389             string memory color = colors[random(abi.encodePacked("COLOR", creator, i), colors.length)];
1390             uint256 ox = uint256(random(abi.encodePacked("ox", creator, i), 80)) + 119 - 40;
1391             uint256 oy = uint256(random(abi.encodePacked("oy", creator, i), 80)) + 90 - 40;
1392             uint256 r = uint256(random(abi.encodePacked("r", creator, i), 360));
1393             string memory opacity = "0.3";
1394             string memory scale = string(abi.encodePacked(
1395                 "0.", 
1396                 toString(79 + random(abi.encodePacked("SCALE", creator, i), 20))
1397             ));
1398             if (i == count - 1) {
1399                 ox = 119;
1400                 oy = 90;
1401                 r = uint256(random(abi.encodePacked("r", creator, i), 14));
1402                 scale = "1";
1403                 opacity = "1";
1404                 if (love < 7) color = "clear";
1405             }
1406             bool stroke = i == count - 1;
1407             string memory ds = draw(color, toString(ox), toString(oy), maybeNegateString(r), scale, opacity, stroke);
1408             output = string(abi.encodePacked(output, ds));
1409         }
1410 
1411         if (love >= 14) {
1412             output = string(abi.encodePacked(output, halo));
1413         }
1414 
1415         output = string(abi.encodePacked(output, footer));
1416         
1417         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "pfp #', toString(tokenId), '", "description": "dear caretaker, thank u for a great time in ur world! miss u lots and hope to see u soon", "attributes": [{"trait_type": "LOVE", "value":', toString(love), '}], "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1418         output = string(abi.encodePacked('data:application/json;base64,', json));
1419 
1420         return output;
1421     }
1422 
1423     function mint() public nonReentrant {
1424         require(enabled || _msgSender() == owner(), "Not allowed");
1425         require(wagmi.love(_msgSender()) > 0, "Not enough love");
1426         require(_claims[_msgSender()] == false, "Already minted from this address");
1427         _mints[totalSupply()] = _msgSender();
1428         _claims[_msgSender()] = true;
1429         _love[_msgSender()] = wagmi.love(_msgSender());
1430         _safeMint(_msgSender(), totalSupply());
1431     }
1432 
1433     function mintForWagmiOne() public nonReentrant {
1434         require(enabled || _msgSender() == owner(), "Not allowed");
1435         require(wagmiOne.love(_msgSender()) > 0, "Not enough love");
1436         require(_claims[_msgSender()] == false, "Already minted from this address");
1437         _mints[totalSupply()] = _msgSender();
1438         _claims[_msgSender()] = true;
1439         _love[_msgSender()] = wagmiOne.love(_msgSender());
1440         _safeMint(_msgSender(), totalSupply());
1441     }
1442 
1443     function maybeNegateString(uint256 value) internal pure returns (string memory) {
1444         if (value % 2 == 0) {
1445             return string(abi.encodePacked('-', toString(value)));
1446         }
1447         return toString(value);
1448     }
1449     
1450     function toString(uint256 value) internal pure returns (string memory) {
1451     // Inspired by OraclizeAPI's implementation - MIT license
1452     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1453 
1454         if (value == 0) {
1455             return "0";
1456         }
1457         uint256 temp = value;
1458         uint256 digits;
1459         while (temp != 0) {
1460             digits++;
1461             temp /= 10;
1462         }
1463         bytes memory buffer = new bytes(digits);
1464         while (value != 0) {
1465             digits -= 1;
1466             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1467             value /= 10;
1468         }
1469         return string(buffer);
1470     }
1471     
1472     constructor() ERC721("postcards from paradise", "PFP") Ownable() {}
1473 }
1474 
1475 /// [MIT License]
1476 /// @title Base64
1477 /// @notice Provides a function for encoding some bytes in base64
1478 /// @author Brecht Devos <brecht@loopring.org>
1479 library Base64 {
1480     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1481 
1482     /// @notice Encodes some bytes to the base64 representation
1483     function encode(bytes memory data) internal pure returns (string memory) {
1484         uint256 len = data.length;
1485         if (len == 0) return "";
1486 
1487         // multiply by 4/3 rounded up
1488         uint256 encodedLen = 4 * ((len + 2) / 3);
1489 
1490         // Add some extra buffer at the end
1491         bytes memory result = new bytes(encodedLen + 32);
1492 
1493         bytes memory table = TABLE;
1494 
1495         assembly {
1496             let tablePtr := add(table, 1)
1497             let resultPtr := add(result, 32)
1498 
1499             for {
1500                 let i := 0
1501             } lt(i, len) {
1502 
1503             } {
1504                 i := add(i, 3)
1505                 let input := and(mload(add(data, i)), 0xffffff)
1506 
1507                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1508                 out := shl(8, out)
1509                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1510                 out := shl(8, out)
1511                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1512                 out := shl(8, out)
1513                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1514                 out := shl(224, out)
1515 
1516                 mstore(resultPtr, out)
1517 
1518                 resultPtr := add(resultPtr, 4)
1519             }
1520 
1521             switch mod(len, 3)
1522             case 1 {
1523                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1524             }
1525             case 2 {
1526                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1527             }
1528 
1529             mstore(result, encodedLen)
1530         }
1531 
1532         return string(result);
1533     }
1534 }