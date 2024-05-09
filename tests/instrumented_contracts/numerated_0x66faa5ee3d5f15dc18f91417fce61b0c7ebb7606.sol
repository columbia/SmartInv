1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-31
3 */
4 
5 //-------------DEPENDENCIES--------------------------//
6 
7 // File: @openzeppelin/contracts/utils/Address.sol
8 
9 
10 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
11 
12 pragma solidity ^0.8.1;
13 
14 /**
15  * @dev Collection of functions related to the address type
16  */
17 library Address {
18     /**
19      * @dev Returns true if account is a contract.
20      *
21      * [IMPORTANT]
22      * ====
23      * It is unsafe to assume that an address for which this function returns
24      * false is an externally-owned account (EOA) and not a contract.
25      *
26      * Among others, isContract will return false for the following
27      * types of addresses:
28      *
29      *  - an externally-owned account
30      *  - a contract in construction
31      *  - an address where a contract will be created
32      *  - an address where a contract lived, but was destroyed
33      * ====
34      *
35      * [IMPORTANT]
36      * ====
37      * You shouldn't rely on isContract to protect against flash loan attacks!
38      *
39      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
40      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
41      * constructor.
42      * ====
43      */
44     function isContract(address account) internal view returns (bool) {
45         // This method relies on extcodesize/address.code.length, which returns 0
46         // for contracts in construction, since the code is only stored at the end
47         // of the constructor execution.
48 
49         return account.code.length > 0;
50     }
51 
52     /**
53      * @dev Replacement for Solidity's transfer: sends amount wei to
54      * recipient, forwarding all available gas and reverting on errors.
55      *
56      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
57      * of certain opcodes, possibly making contracts go over the 2300 gas limit
58      * imposed by transfer, making them unable to receive funds via
59      * transfer. {sendValue} removes this limitation.
60      *
61      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
62      *
63      * IMPORTANT: because control is transferred to recipient, care must be
64      * taken to not create reentrancy vulnerabilities. Consider using
65      * {ReentrancyGuard} or the
66      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
67      */
68     function sendValue(address payable recipient, uint256 amount) internal {
69         require(address(this).balance >= amount, "Address: insufficient balance");
70 
71         (bool success, ) = recipient.call{value: amount}("");
72         require(success, "Address: unable to send value, recipient may have reverted");
73     }
74 
75     /**
76      * @dev Performs a Solidity function call using a low level call. A
77      * plain call is an unsafe replacement for a function call: use this
78      * function instead.
79      *
80      * If target reverts with a revert reason, it is bubbled up by this
81      * function (like regular Solidity function calls).
82      *
83      * Returns the raw returned data. To convert to the expected return value,
84      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
85      *
86      * Requirements:
87      *
88      * - target must be a contract.
89      * - calling target with data must not revert.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
94         return functionCall(target, data, "Address: low-level call failed");
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
99      * errorMessage as a fallback revert reason when target reverts.
100      *
101      * _Available since v3.1._
102      */
103     function functionCall(
104         address target,
105         bytes memory data,
106         string memory errorMessage
107     ) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, 0, errorMessage);
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
113      * but also transferring value wei to target.
114      *
115      * Requirements:
116      *
117      * - the calling contract must have an ETH balance of at least value.
118      * - the called Solidity function must be payable.
119      *
120      * _Available since v3.1._
121      */
122     function functionCallWithValue(
123         address target,
124         bytes memory data,
125         uint256 value
126     ) internal returns (bytes memory) {
127         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
128     }
129 
130     /**
131      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
132      * with errorMessage as a fallback revert reason when target reverts.
133      *
134      * _Available since v3.1._
135      */
136     function functionCallWithValue(
137         address target,
138         bytes memory data,
139         uint256 value,
140         string memory errorMessage
141     ) internal returns (bytes memory) {
142         require(address(this).balance >= value, "Address: insufficient balance for call");
143         require(isContract(target), "Address: call to non-contract");
144 
145         (bool success, bytes memory returndata) = target.call{value: value}(data);
146         return verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
156         return functionStaticCall(target, data, "Address: low-level static call failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
161      * but performing a static call.
162      *
163      * _Available since v3.3._
164      */
165     function functionStaticCall(
166         address target,
167         bytes memory data,
168         string memory errorMessage
169     ) internal view returns (bytes memory) {
170         require(isContract(target), "Address: static call to non-contract");
171 
172         (bool success, bytes memory returndata) = target.staticcall(data);
173         return verifyCallResult(success, returndata, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
183         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
188      * but performing a delegate call.
189      *
190      * _Available since v3.4._
191      */
192     function functionDelegateCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal returns (bytes memory) {
197         require(isContract(target), "Address: delegate call to non-contract");
198 
199         (bool success, bytes memory returndata) = target.delegatecall(data);
200         return verifyCallResult(success, returndata, errorMessage);
201     }
202 
203     /**
204      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
205      * revert reason using the provided one.
206      *
207      * _Available since v4.3._
208      */
209     function verifyCallResult(
210         bool success,
211         bytes memory returndata,
212         string memory errorMessage
213     ) internal pure returns (bytes memory) {
214         if (success) {
215             return returndata;
216         } else {
217             // Look for revert reason and bubble it up if present
218             if (returndata.length > 0) {
219                 // The easiest way to bubble the revert reason is using memory via assembly
220 
221                 assembly {
222                     let returndata_size := mload(returndata)
223                     revert(add(32, returndata), returndata_size)
224                 }
225             } else {
226                 revert(errorMessage);
227             }
228         }
229     }
230 }
231 
232 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @title ERC721 token receiver interface
241  * @dev Interface for any contract that wants to support safeTransfers
242  * from ERC721 asset contracts.
243  */
244 interface IERC721Receiver {
245     /**
246      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
247      * by operator from from, this function is called.
248      *
249      * It must return its Solidity selector to confirm the token transfer.
250      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
251      *
252      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
253      */
254     function onERC721Received(
255         address operator,
256         address from,
257         uint256 tokenId,
258         bytes calldata data
259     ) external returns (bytes4);
260 }
261 
262 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
263 
264 
265 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
266 
267 pragma solidity ^0.8.0;
268 
269 /**
270  * @dev Interface of the ERC165 standard, as defined in the
271  * https://eips.ethereum.org/EIPS/eip-165[EIP].
272  *
273  * Implementers can declare support of contract interfaces, which can then be
274  * queried by others ({ERC165Checker}).
275  *
276  * For an implementation, see {ERC165}.
277  */
278 interface IERC165 {
279     /**
280      * @dev Returns true if this contract implements the interface defined by
281      * interfaceId. See the corresponding
282      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
283      * to learn more about how these ids are created.
284      *
285      * This function call must use less than 30 000 gas.
286      */
287     function supportsInterface(bytes4 interfaceId) external view returns (bool);
288 }
289 
290 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
291 
292 
293 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
294 
295 pragma solidity ^0.8.0;
296 
297 
298 /**
299  * @dev Implementation of the {IERC165} interface.
300  *
301  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
302  * for the additional interface id that will be supported. For example:
303  *
304  * solidity
305  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
306  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
307  * }
308  * 
309  *
310  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
311  */
312 abstract contract ERC165 is IERC165 {
313     /**
314      * @dev See {IERC165-supportsInterface}.
315      */
316     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
317         return interfaceId == type(IERC165).interfaceId;
318     }
319 }
320 
321 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
322 
323 
324 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 
329 /**
330  * @dev Required interface of an ERC721 compliant contract.
331  */
332 interface IERC721 is IERC165 {
333     /**
334      * @dev Emitted when tokenId token is transferred from from to to.
335      */
336     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
337 
338     /**
339      * @dev Emitted when owner enables approved to manage the tokenId token.
340      */
341     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
342 
343     /**
344      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
345      */
346     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
347 
348     /**
349      * @dev Returns the number of tokens in owner's account.
350      */
351     function balanceOf(address owner) external view returns (uint256 balance);
352 
353     /**
354      * @dev Returns the owner of the tokenId token.
355      *
356      * Requirements:
357      *
358      * - tokenId must exist.
359      */
360     function ownerOf(uint256 tokenId) external view returns (address owner);
361 
362     /**
363      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
364      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
365      *
366      * Requirements:
367      *
368      * - from cannot be the zero address.
369      * - to cannot be the zero address.
370      * - tokenId token must exist and be owned by from.
371      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
372      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
373      *
374      * Emits a {Transfer} event.
375      */
376     function safeTransferFrom(
377         address from,
378         address to,
379         uint256 tokenId
380     ) external;
381 
382     /**
383      * @dev Transfers tokenId token from from to to.
384      *
385      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
386      *
387      * Requirements:
388      *
389      * - from cannot be the zero address.
390      * - to cannot be the zero address.
391      * - tokenId token must be owned by from.
392      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
393      *
394      * Emits a {Transfer} event.
395      */
396     function transferFrom(
397         address from,
398         address to,
399         uint256 tokenId
400     ) external;
401 
402     /**
403      * @dev Gives permission to to to transfer tokenId token to another account.
404      * The approval is cleared when the token is transferred.
405      *
406      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
407      *
408      * Requirements:
409      *
410      * - The caller must own the token or be an approved operator.
411      * - tokenId must exist.
412      *
413      * Emits an {Approval} event.
414      */
415     function approve(address to, uint256 tokenId) external;
416 
417     /**
418      * @dev Returns the account approved for tokenId token.
419      *
420      * Requirements:
421      *
422      * - tokenId must exist.
423      */
424     function getApproved(uint256 tokenId) external view returns (address operator);
425 
426     /**
427      * @dev Approve or remove operator as an operator for the caller.
428      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
429      *
430      * Requirements:
431      *
432      * - The operator cannot be the caller.
433      *
434      * Emits an {ApprovalForAll} event.
435      */
436     function setApprovalForAll(address operator, bool _approved) external;
437 
438     /**
439      * @dev Returns if the operator is allowed to manage all of the assets of owner.
440      *
441      * See {setApprovalForAll}
442      */
443     function isApprovedForAll(address owner, address operator) external view returns (bool);
444 
445     /**
446      * @dev Safely transfers tokenId token from from to to.
447      *
448      * Requirements:
449      *
450      * - from cannot be the zero address.
451      * - to cannot be the zero address.
452      * - tokenId token must exist and be owned by from.
453      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
454      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
455      *
456      * Emits a {Transfer} event.
457      */
458     function safeTransferFrom(
459         address from,
460         address to,
461         uint256 tokenId,
462         bytes calldata data
463     ) external;
464 }
465 
466 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
467 
468 
469 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 
474 /**
475  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
476  * @dev See https://eips.ethereum.org/EIPS/eip-721
477  */
478 interface IERC721Enumerable is IERC721 {
479     /**
480      * @dev Returns the total amount of tokens stored by the contract.
481      */
482     function totalSupply() external view returns (uint256);
483 
484     /**
485      * @dev Returns a token ID owned by owner at a given index of its token list.
486      * Use along with {balanceOf} to enumerate all of owner's tokens.
487      */
488     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
489 
490     /**
491      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
492      * Use along with {totalSupply} to enumerate all tokens.
493      */
494     function tokenByIndex(uint256 index) external view returns (uint256);
495 }
496 
497 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 
505 /**
506  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
507  * @dev See https://eips.ethereum.org/EIPS/eip-721
508  */
509 interface IERC721Metadata is IERC721 {
510     /**
511      * @dev Returns the token collection name.
512      */
513     function name() external view returns (string memory);
514 
515     /**
516      * @dev Returns the token collection symbol.
517      */
518     function symbol() external view returns (string memory);
519 
520     /**
521      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
522      */
523     function tokenURI(uint256 tokenId) external view returns (string memory);
524 }
525 
526 // File: @openzeppelin/contracts/utils/Strings.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @dev String operations.
535  */
536 library Strings {
537     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
538 
539     /**
540      * @dev Converts a uint256 to its ASCII string decimal representation.
541      */
542     function toString(uint256 value) internal pure returns (string memory) {
543         // Inspired by OraclizeAPI's implementation - MIT licence
544         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
545 
546         if (value == 0) {
547             return "0";
548         }
549         uint256 temp = value;
550         uint256 digits;
551         while (temp != 0) {
552             digits++;
553             temp /= 10;
554         }
555         bytes memory buffer = new bytes(digits);
556         while (value != 0) {
557             digits -= 1;
558             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
559             value /= 10;
560         }
561         return string(buffer);
562     }
563 
564     /**
565      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
566      */
567     function toHexString(uint256 value) internal pure returns (string memory) {
568         if (value == 0) {
569             return "0x00";
570         }
571         uint256 temp = value;
572         uint256 length = 0;
573         while (temp != 0) {
574             length++;
575             temp >>= 8;
576         }
577         return toHexString(value, length);
578     }
579 
580     /**
581      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
582      */
583     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
584         bytes memory buffer = new bytes(2 * length + 2);
585         buffer[0] = "0";
586         buffer[1] = "x";
587         for (uint256 i = 2 * length + 1; i > 1; --i) {
588             buffer[i] = _HEX_SYMBOLS[value & 0xf];
589             value >>= 4;
590         }
591         require(value == 0, "Strings: hex length insufficient");
592         return string(buffer);
593     }
594 }
595 
596 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
597 
598 
599 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 /**
604  * @dev Contract module that helps prevent reentrant calls to a function.
605  *
606  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
607  * available, which can be applied to functions to make sure there are no nested
608  * (reentrant) calls to them.
609  *
610  * Note that because there is a single nonReentrant guard, functions marked as
611  * nonReentrant may not call one another. This can be worked around by making
612  * those functions private, and then adding external nonReentrant entry
613  * points to them.
614  *
615  * TIP: If you would like to learn more about reentrancy and alternative ways
616  * to protect against it, check out our blog post
617  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
618  */
619 abstract contract ReentrancyGuard {
620     // Booleans are more expensive than uint256 or any type that takes up a full
621     // word because each write operation emits an extra SLOAD to first read the
622     // slot's contents, replace the bits taken up by the boolean, and then write
623     // back. This is the compiler's defense against contract upgrades and
624     // pointer aliasing, and it cannot be disabled.
625 
626     // The values being non-zero value makes deployment a bit more expensive,
627     // but in exchange the refund on every call to nonReentrant will be lower in
628     // amount. Since refunds are capped to a percentage of the total
629     // transaction's gas, it is best to keep them low in cases like this one, to
630     // increase the likelihood of the full refund coming into effect.
631     uint256 private constant _NOT_ENTERED = 1;
632     uint256 private constant _ENTERED = 2;
633 
634     uint256 private _status;
635 
636     constructor() {
637         _status = _NOT_ENTERED;
638     }
639 
640     /**
641      * @dev Prevents a contract from calling itself, directly or indirectly.
642      * Calling a nonReentrant function from another nonReentrant
643      * function is not supported. It is possible to prevent this from happening
644      * by making the nonReentrant function external, and making it call a
645      * private function that does the actual work.
646      */
647     modifier nonReentrant() {
648         // On the first call to nonReentrant, _notEntered will be true
649         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
650 
651         // Any calls to nonReentrant after this point will fail
652         _status = _ENTERED;
653 
654         _;
655 
656         // By storing the original value once again, a refund is triggered (see
657         // https://eips.ethereum.org/EIPS/eip-2200)
658         _status = _NOT_ENTERED;
659     }
660 }
661 
662 // File: @openzeppelin/contracts/utils/Context.sol
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 /**
670  * @dev Provides information about the current execution context, including the
671  * sender of the transaction and its data. While these are generally available
672  * via msg.sender and msg.data, they should not be accessed in such a direct
673  * manner, since when dealing with meta-transactions the account sending and
674  * paying for execution may not be the actual sender (as far as an application
675  * is concerned).
676  *
677  * This contract is only required for intermediate, library-like contracts.
678  */
679 abstract contract Context {
680     function _msgSender() internal view virtual returns (address) {
681         return msg.sender;
682     }
683 
684     function _msgData() internal view virtual returns (bytes calldata) {
685         return msg.data;
686     }
687 }
688 
689 // File: @openzeppelin/contracts/access/Ownable.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 
697 /**
698  * @dev Contract module which provides a basic access control mechanism, where
699  * there is an account (an owner) that can be granted exclusive access to
700  * specific functions.
701  *
702  * By default, the owner account will be the one that deploys the contract. This
703  * can later be changed with {transferOwnership}.
704  *
705  * This module is used through inheritance. It will make available the modifier
706  * onlyOwner, which can be applied to your functions to restrict their use to
707  * the owner.
708  */
709 abstract contract Ownable is Context {
710     address private _owner;
711 
712     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
713 
714     /**
715      * @dev Initializes the contract setting the deployer as the initial owner.
716      */
717     constructor() {
718         _transferOwnership(_msgSender());
719     }
720 
721     /**
722      * @dev Returns the address of the current owner.
723      */
724     function owner() public view virtual returns (address) {
725         return _owner;
726     }
727 
728     /**
729      * @dev Throws if called by any account other than the owner.
730      */
731     modifier onlyOwner() {
732         require(owner() == _msgSender(), "Ownable: caller is not the owner");
733         _;
734     }
735 
736     /**
737      * @dev Leaves the contract without owner. It will not be possible to call
738      * onlyOwner functions anymore. Can only be called by the current owner.
739      *
740      * NOTE: Renouncing ownership will leave the contract without an owner,
741      * thereby removing any functionality that is only available to the owner.
742      */
743     function renounceOwnership() public virtual onlyOwner {
744         _transferOwnership(address(0));
745     }
746 
747     /**
748      * @dev Transfers ownership of the contract to a new account (newOwner).
749      * Can only be called by the current owner.
750      */
751     function transferOwnership(address newOwner) public virtual onlyOwner {
752         require(newOwner != address(0), "Ownable: new owner is the zero address");
753         _transferOwnership(newOwner);
754     }
755 
756     /**
757      * @dev Transfers ownership of the contract to a new account (newOwner).
758      * Internal function without access restriction.
759      */
760     function _transferOwnership(address newOwner) internal virtual {
761         address oldOwner = _owner;
762         _owner = newOwner;
763         emit OwnershipTransferred(oldOwner, newOwner);
764     }
765 }
766 //-------------END DEPENDENCIES------------------------//
767 
768 
769   
770 // Rampp Contracts v2.1 (Teams.sol)
771 
772 pragma solidity ^0.8.0;
773 
774 /**
775 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
776 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
777 * This will easily allow cross-collaboration via Rampp.xyz.
778 **/
779 abstract contract Teams is Ownable{
780   mapping (address => bool) internal team;
781 
782   /**
783   * @dev Adds an address to the team. Allows them to execute protected functions
784   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
785   **/
786   function addToTeam(address _address) public onlyOwner {
787     require(_address != address(0), "Invalid address");
788     require(!inTeam(_address), "This address is already in your team.");
789   
790     team[_address] = true;
791   }
792 
793   /**
794   * @dev Removes an address to the team.
795   * @param _address the ETH address to remove, cannot be 0x and must be in team
796   **/
797   function removeFromTeam(address _address) public onlyOwner {
798     require(_address != address(0), "Invalid address");
799     require(inTeam(_address), "This address is not in your team currently.");
800   
801     team[_address] = false;
802   }
803 
804   /**
805   * @dev Check if an address is valid and active in the team
806   * @param _address ETH address to check for truthiness
807   **/
808   function inTeam(address _address)
809     public
810     view
811     returns (bool)
812   {
813     require(_address != address(0), "Invalid address to check.");
814     return team[_address] == true;
815   }
816 
817   /**
818   * @dev Throws if called by any account other than the owner or team member.
819   */
820   modifier onlyTeamOrOwner() {
821     bool _isOwner = owner() == _msgSender();
822     bool _isTeam = inTeam(_msgSender());
823     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
824     _;
825   }
826 }
827 
828 
829   
830   pragma solidity ^0.8.0;
831 
832   /**
833   * @dev These functions deal with verification of Merkle Trees proofs.
834   *
835   * The proofs can be generated using the JavaScript library
836   * https://github.com/miguelmota/merkletreejs[merkletreejs].
837   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
838   *
839   *
840   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
841   * hashing, or use a hash function other than keccak256 for hashing leaves.
842   * This is because the concatenation of a sorted pair of internal nodes in
843   * the merkle tree could be reinterpreted as a leaf value.
844   */
845   library MerkleProof {
846       /**
847       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
848       * defined by 'root'. For this, a 'proof' must be provided, containing
849       * sibling hashes on the branch from the leaf to the root of the tree. Each
850       * pair of leaves and each pair of pre-images are assumed to be sorted.
851       */
852       function verify(
853           bytes32[] memory proof,
854           bytes32 root,
855           bytes32 leaf
856       ) internal pure returns (bool) {
857           return processProof(proof, leaf) == root;
858       }
859 
860       /**
861       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
862       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
863       * hash matches the root of the tree. When processing the proof, the pairs
864       * of leafs & pre-images are assumed to be sorted.
865       *
866       * _Available since v4.4._
867       */
868       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
869           bytes32 computedHash = leaf;
870           for (uint256 i = 0; i < proof.length; i++) {
871               bytes32 proofElement = proof[i];
872               if (computedHash <= proofElement) {
873                   // Hash(current computed hash + current element of the proof)
874                   computedHash = _efficientHash(computedHash, proofElement);
875               } else {
876                   // Hash(current element of the proof + current computed hash)
877                   computedHash = _efficientHash(proofElement, computedHash);
878               }
879           }
880           return computedHash;
881       }
882 
883       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
884           assembly {
885               mstore(0x00, a)
886               mstore(0x20, b)
887               value := keccak256(0x00, 0x40)
888           }
889       }
890   }
891 
892 
893   // File: Allowlist.sol
894 
895   pragma solidity ^0.8.0;
896 
897   abstract contract Allowlist is Teams {
898     bytes32 public merkleRoot;
899     bool public onlyAllowlistMode = false;
900 
901     /**
902      * @dev Update merkle root to reflect changes in Allowlist
903      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
904      */
905     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
906       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
907       merkleRoot = _newMerkleRoot;
908     }
909 
910     /**
911      * @dev Check the proof of an address if valid for merkle root
912      * @param _to address to check for proof
913      * @param _merkleProof Proof of the address to validate against root and leaf
914      */
915     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
916       require(merkleRoot != 0, "Merkle root is not set!");
917       bytes32 leaf = keccak256(abi.encodePacked(_to));
918 
919       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
920     }
921 
922     
923     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
924       onlyAllowlistMode = true;
925     }
926 
927     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
928         onlyAllowlistMode = false;
929     }
930   }
931   
932   
933 /**
934  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
935  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
936  *
937  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
938  * 
939  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
940  *
941  * Does not support burning tokens to address(0).
942  */
943 contract ERC721A is
944   Context,
945   ERC165,
946   IERC721,
947   IERC721Metadata,
948   IERC721Enumerable
949 {
950   using Address for address;
951   using Strings for uint256;
952 
953   struct TokenOwnership {
954     address addr;
955     uint64 startTimestamp;
956   }
957 
958   struct AddressData {
959     uint128 balance;
960     uint128 numberMinted;
961   }
962 
963   uint256 private currentIndex;
964 
965   uint256 public immutable collectionSize;
966   uint256 public maxBatchSize;
967 
968   // Token name
969   string private _name;
970 
971   // Token symbol
972   string private _symbol;
973 
974   // Mapping from token ID to ownership details
975   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
976   mapping(uint256 => TokenOwnership) private _ownerships;
977 
978   // Mapping owner address to address data
979   mapping(address => AddressData) private _addressData;
980 
981   // Mapping from token ID to approved address
982   mapping(uint256 => address) private _tokenApprovals;
983 
984   // Mapping from owner to operator approvals
985   mapping(address => mapping(address => bool)) private _operatorApprovals;
986 
987   /**
988    * @dev
989    * maxBatchSize refers to how much a minter can mint at a time.
990    * collectionSize_ refers to how many tokens are in the collection.
991    */
992   constructor(
993     string memory name_,
994     string memory symbol_,
995     uint256 maxBatchSize_,
996     uint256 collectionSize_
997   ) {
998     require(
999       collectionSize_ > 0,
1000       "ERC721A: collection must have a nonzero supply"
1001     );
1002     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1003     _name = name_;
1004     _symbol = symbol_;
1005     maxBatchSize = maxBatchSize_;
1006     collectionSize = collectionSize_;
1007     currentIndex = _startTokenId();
1008   }
1009 
1010   /**
1011   * To change the starting tokenId, please override this function.
1012   */
1013   function _startTokenId() internal view virtual returns (uint256) {
1014     return 1;
1015   }
1016 
1017   /**
1018    * @dev See {IERC721Enumerable-totalSupply}.
1019    */
1020   function totalSupply() public view override returns (uint256) {
1021     return _totalMinted();
1022   }
1023 
1024   function currentTokenId() public view returns (uint256) {
1025     return _totalMinted();
1026   }
1027 
1028   function getNextTokenId() public view returns (uint256) {
1029       return _totalMinted() + 1;
1030   }
1031 
1032   /**
1033   * Returns the total amount of tokens minted in the contract.
1034   */
1035   function _totalMinted() internal view returns (uint256) {
1036     unchecked {
1037       return currentIndex - _startTokenId();
1038     }
1039   }
1040 
1041   /**
1042    * @dev See {IERC721Enumerable-tokenByIndex}.
1043    */
1044   function tokenByIndex(uint256 index) public view override returns (uint256) {
1045     require(index < totalSupply(), "ERC721A: global index out of bounds");
1046     return index;
1047   }
1048 
1049   /**
1050    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1051    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1052    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1053    */
1054   function tokenOfOwnerByIndex(address owner, uint256 index)
1055     public
1056     view
1057     override
1058     returns (uint256)
1059   {
1060     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1061     uint256 numMintedSoFar = totalSupply();
1062     uint256 tokenIdsIdx = 0;
1063     address currOwnershipAddr = address(0);
1064     for (uint256 i = 0; i < numMintedSoFar; i++) {
1065       TokenOwnership memory ownership = _ownerships[i];
1066       if (ownership.addr != address(0)) {
1067         currOwnershipAddr = ownership.addr;
1068       }
1069       if (currOwnershipAddr == owner) {
1070         if (tokenIdsIdx == index) {
1071           return i;
1072         }
1073         tokenIdsIdx++;
1074       }
1075     }
1076     revert("ERC721A: unable to get token of owner by index");
1077   }
1078 
1079   /**
1080    * @dev See {IERC165-supportsInterface}.
1081    */
1082   function supportsInterface(bytes4 interfaceId)
1083     public
1084     view
1085     virtual
1086     override(ERC165, IERC165)
1087     returns (bool)
1088   {
1089     return
1090       interfaceId == type(IERC721).interfaceId ||
1091       interfaceId == type(IERC721Metadata).interfaceId ||
1092       interfaceId == type(IERC721Enumerable).interfaceId ||
1093       super.supportsInterface(interfaceId);
1094   }
1095 
1096   /**
1097    * @dev See {IERC721-balanceOf}.
1098    */
1099   function balanceOf(address owner) public view override returns (uint256) {
1100     require(owner != address(0), "ERC721A: balance query for the zero address");
1101     return uint256(_addressData[owner].balance);
1102   }
1103 
1104   function _numberMinted(address owner) internal view returns (uint256) {
1105     require(
1106       owner != address(0),
1107       "ERC721A: number minted query for the zero address"
1108     );
1109     return uint256(_addressData[owner].numberMinted);
1110   }
1111 
1112   function ownershipOf(uint256 tokenId)
1113     internal
1114     view
1115     returns (TokenOwnership memory)
1116   {
1117     uint256 curr = tokenId;
1118 
1119     unchecked {
1120         if (_startTokenId() <= curr && curr < currentIndex) {
1121             TokenOwnership memory ownership = _ownerships[curr];
1122             if (ownership.addr != address(0)) {
1123                 return ownership;
1124             }
1125 
1126             // Invariant:
1127             // There will always be an ownership that has an address and is not burned
1128             // before an ownership that does not have an address and is not burned.
1129             // Hence, curr will not underflow.
1130             while (true) {
1131                 curr--;
1132                 ownership = _ownerships[curr];
1133                 if (ownership.addr != address(0)) {
1134                     return ownership;
1135                 }
1136             }
1137         }
1138     }
1139 
1140     revert("ERC721A: unable to determine the owner of token");
1141   }
1142 
1143   /**
1144    * @dev See {IERC721-ownerOf}.
1145    */
1146   function ownerOf(uint256 tokenId) public view override returns (address) {
1147     return ownershipOf(tokenId).addr;
1148   }
1149 
1150   /**
1151    * @dev See {IERC721Metadata-name}.
1152    */
1153   function name() public view virtual override returns (string memory) {
1154     return _name;
1155   }
1156 
1157   /**
1158    * @dev See {IERC721Metadata-symbol}.
1159    */
1160   function symbol() public view virtual override returns (string memory) {
1161     return _symbol;
1162   }
1163 
1164   /**
1165    * @dev See {IERC721Metadata-tokenURI}.
1166    */
1167   function tokenURI(uint256 tokenId)
1168     public
1169     view
1170     virtual
1171     override
1172     returns (string memory)
1173   {
1174     string memory baseURI = _baseURI();
1175     return
1176       bytes(baseURI).length > 0
1177         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1178         : "";
1179   }
1180 
1181   /**
1182    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1183    * token will be the concatenation of the baseURI and the tokenId. Empty
1184    * by default, can be overriden in child contracts.
1185    */
1186   function _baseURI() internal view virtual returns (string memory) {
1187     return "";
1188   }
1189 
1190   /**
1191    * @dev See {IERC721-approve}.
1192    */
1193   function approve(address to, uint256 tokenId) public override {
1194     address owner = ERC721A.ownerOf(tokenId);
1195     require(to != owner, "ERC721A: approval to current owner");
1196 
1197     require(
1198       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1199       "ERC721A: approve caller is not owner nor approved for all"
1200     );
1201 
1202     _approve(to, tokenId, owner);
1203   }
1204 
1205   /**
1206    * @dev See {IERC721-getApproved}.
1207    */
1208   function getApproved(uint256 tokenId) public view override returns (address) {
1209     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1210 
1211     return _tokenApprovals[tokenId];
1212   }
1213 
1214   /**
1215    * @dev See {IERC721-setApprovalForAll}.
1216    */
1217   function setApprovalForAll(address operator, bool approved) public override {
1218     require(operator != _msgSender(), "ERC721A: approve to caller");
1219 
1220     _operatorApprovals[_msgSender()][operator] = approved;
1221     emit ApprovalForAll(_msgSender(), operator, approved);
1222   }
1223 
1224   /**
1225    * @dev See {IERC721-isApprovedForAll}.
1226    */
1227   function isApprovedForAll(address owner, address operator)
1228     public
1229     view
1230     virtual
1231     override
1232     returns (bool)
1233   {
1234     return _operatorApprovals[owner][operator];
1235   }
1236 
1237   /**
1238    * @dev See {IERC721-transferFrom}.
1239    */
1240   function transferFrom(
1241     address from,
1242     address to,
1243     uint256 tokenId
1244   ) public override {
1245     _transfer(from, to, tokenId);
1246   }
1247 
1248   /**
1249    * @dev See {IERC721-safeTransferFrom}.
1250    */
1251   function safeTransferFrom(
1252     address from,
1253     address to,
1254     uint256 tokenId
1255   ) public override {
1256     safeTransferFrom(from, to, tokenId, "");
1257   }
1258 
1259   /**
1260    * @dev See {IERC721-safeTransferFrom}.
1261    */
1262   function safeTransferFrom(
1263     address from,
1264     address to,
1265     uint256 tokenId,
1266     bytes memory _data
1267   ) public override {
1268     _transfer(from, to, tokenId);
1269     require(
1270       _checkOnERC721Received(from, to, tokenId, _data),
1271       "ERC721A: transfer to non ERC721Receiver implementer"
1272     );
1273   }
1274 
1275   /**
1276    * @dev Returns whether tokenId exists.
1277    *
1278    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1279    *
1280    * Tokens start existing when they are minted (_mint),
1281    */
1282   function _exists(uint256 tokenId) internal view returns (bool) {
1283     return _startTokenId() <= tokenId && tokenId < currentIndex;
1284   }
1285 
1286   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1287     _safeMint(to, quantity, isAdminMint, "");
1288   }
1289 
1290   /**
1291    * @dev Mints quantity tokens and transfers them to to.
1292    *
1293    * Requirements:
1294    *
1295    * - there must be quantity tokens remaining unminted in the total collection.
1296    * - to cannot be the zero address.
1297    * - quantity cannot be larger than the max batch size.
1298    *
1299    * Emits a {Transfer} event.
1300    */
1301   function _safeMint(
1302     address to,
1303     uint256 quantity,
1304     bool isAdminMint,
1305     bytes memory _data
1306   ) internal {
1307     uint256 startTokenId = currentIndex;
1308     require(to != address(0), "ERC721A: mint to the zero address");
1309     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1310     require(!_exists(startTokenId), "ERC721A: token already minted");
1311 
1312     // For admin mints we do not want to enforce the maxBatchSize limit
1313     if (isAdminMint == false) {
1314         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1315     }
1316 
1317     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1318 
1319     AddressData memory addressData = _addressData[to];
1320     _addressData[to] = AddressData(
1321       addressData.balance + uint128(quantity),
1322       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1323     );
1324     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1325 
1326     uint256 updatedIndex = startTokenId;
1327 
1328     for (uint256 i = 0; i < quantity; i++) {
1329       emit Transfer(address(0), to, updatedIndex);
1330       require(
1331         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1332         "ERC721A: transfer to non ERC721Receiver implementer"
1333       );
1334       updatedIndex++;
1335     }
1336 
1337     currentIndex = updatedIndex;
1338     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1339   }
1340 
1341   /**
1342    * @dev Transfers tokenId from from to to.
1343    *
1344    * Requirements:
1345    *
1346    * - to cannot be the zero address.
1347    * - tokenId token must be owned by from.
1348    *
1349    * Emits a {Transfer} event.
1350    */
1351   function _transfer(
1352     address from,
1353     address to,
1354     uint256 tokenId
1355   ) private {
1356     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1357 
1358     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1359       getApproved(tokenId) == _msgSender() ||
1360       isApprovedForAll(prevOwnership.addr, _msgSender()));
1361 
1362     require(
1363       isApprovedOrOwner,
1364       "ERC721A: transfer caller is not owner nor approved"
1365     );
1366 
1367     require(
1368       prevOwnership.addr == from,
1369       "ERC721A: transfer from incorrect owner"
1370     );
1371     require(to != address(0), "ERC721A: transfer to the zero address");
1372 
1373     _beforeTokenTransfers(from, to, tokenId, 1);
1374 
1375     // Clear approvals from the previous owner
1376     _approve(address(0), tokenId, prevOwnership.addr);
1377 
1378     _addressData[from].balance -= 1;
1379     _addressData[to].balance += 1;
1380     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1381 
1382     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1383     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1384     uint256 nextTokenId = tokenId + 1;
1385     if (_ownerships[nextTokenId].addr == address(0)) {
1386       if (_exists(nextTokenId)) {
1387         _ownerships[nextTokenId] = TokenOwnership(
1388           prevOwnership.addr,
1389           prevOwnership.startTimestamp
1390         );
1391       }
1392     }
1393 
1394     emit Transfer(from, to, tokenId);
1395     _afterTokenTransfers(from, to, tokenId, 1);
1396   }
1397 
1398   /**
1399    * @dev Approve to to operate on tokenId
1400    *
1401    * Emits a {Approval} event.
1402    */
1403   function _approve(
1404     address to,
1405     uint256 tokenId,
1406     address owner
1407   ) private {
1408     _tokenApprovals[tokenId] = to;
1409     emit Approval(owner, to, tokenId);
1410   }
1411 
1412   uint256 public nextOwnerToExplicitlySet = 0;
1413 
1414   /**
1415    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1416    */
1417   function _setOwnersExplicit(uint256 quantity) internal {
1418     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1419     require(quantity > 0, "quantity must be nonzero");
1420     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1421 
1422     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1423     if (endIndex > collectionSize - 1) {
1424       endIndex = collectionSize - 1;
1425     }
1426     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1427     require(_exists(endIndex), "not enough minted yet for this cleanup");
1428     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1429       if (_ownerships[i].addr == address(0)) {
1430         TokenOwnership memory ownership = ownershipOf(i);
1431         _ownerships[i] = TokenOwnership(
1432           ownership.addr,
1433           ownership.startTimestamp
1434         );
1435       }
1436     }
1437     nextOwnerToExplicitlySet = endIndex + 1;
1438   }
1439 
1440   /**
1441    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1442    * The call is not executed if the target address is not a contract.
1443    *
1444    * @param from address representing the previous owner of the given token ID
1445    * @param to target address that will receive the tokens
1446    * @param tokenId uint256 ID of the token to be transferred
1447    * @param _data bytes optional data to send along with the call
1448    * @return bool whether the call correctly returned the expected magic value
1449    */
1450   function _checkOnERC721Received(
1451     address from,
1452     address to,
1453     uint256 tokenId,
1454     bytes memory _data
1455   ) private returns (bool) {
1456     if (to.isContract()) {
1457       try
1458         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1459       returns (bytes4 retval) {
1460         return retval == IERC721Receiver(to).onERC721Received.selector;
1461       } catch (bytes memory reason) {
1462         if (reason.length == 0) {
1463           revert("ERC721A: transfer to non ERC721Receiver implementer");
1464         } else {
1465           assembly {
1466             revert(add(32, reason), mload(reason))
1467           }
1468         }
1469       }
1470     } else {
1471       return true;
1472     }
1473   }
1474 
1475   /**
1476    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1477    *
1478    * startTokenId - the first token id to be transferred
1479    * quantity - the amount to be transferred
1480    *
1481    * Calling conditions:
1482    *
1483    * - When from and to are both non-zero, from's tokenId will be
1484    * transferred to to.
1485    * - When from is zero, tokenId will be minted for to.
1486    */
1487   function _beforeTokenTransfers(
1488     address from,
1489     address to,
1490     uint256 startTokenId,
1491     uint256 quantity
1492   ) internal virtual {}
1493 
1494   /**
1495    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1496    * minting.
1497    *
1498    * startTokenId - the first token id to be transferred
1499    * quantity - the amount to be transferred
1500    *
1501    * Calling conditions:
1502    *
1503    * - when from and to are both non-zero.
1504    * - from and to are never both zero.
1505    */
1506   function _afterTokenTransfers(
1507     address from,
1508     address to,
1509     uint256 startTokenId,
1510     uint256 quantity
1511   ) internal virtual {}
1512 }
1513 
1514 
1515 
1516   
1517 abstract contract Ramppable {
1518   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1519 
1520   modifier isRampp() {
1521       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1522       _;
1523   }
1524 }
1525 
1526 
1527   
1528   
1529 interface IERC20 {
1530   function transfer(address _to, uint256 _amount) external returns (bool);
1531   function balanceOf(address account) external view returns (uint256);
1532 }
1533 
1534 abstract contract Withdrawable is Teams, Ramppable {
1535   address[] public payableAddresses = [RAMPPADDRESS,0x8900a69d2c726051928F9F0f2A27B2CC6432C9a2];
1536   uint256[] public payableFees = [5,95];
1537   uint256 public payableAddressCount = 2;
1538 
1539   function withdrawAll() public onlyTeamOrOwner {
1540       require(address(this).balance > 0);
1541       _withdrawAll();
1542   }
1543   
1544   function withdrawAllRampp() public isRampp {
1545       require(address(this).balance > 0);
1546       _withdrawAll();
1547   }
1548 
1549   function _withdrawAll() private {
1550       uint256 balance = address(this).balance;
1551       
1552       for(uint i=0; i < payableAddressCount; i++ ) {
1553           _widthdraw(
1554               payableAddresses[i],
1555               (balance * payableFees[i]) / 100
1556           );
1557       }
1558   }
1559   
1560   function _widthdraw(address _address, uint256 _amount) private {
1561       (bool success, ) = _address.call{value: _amount}("");
1562       require(success, "Transfer failed.");
1563   }
1564 
1565   /**
1566     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1567     * while still splitting royalty payments to all other team members.
1568     * in the event ERC-20 tokens are paid to the contract.
1569     * @param _tokenContract contract of ERC-20 token to withdraw
1570     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1571     */
1572   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyTeamOrOwner {
1573     require(_amount > 0);
1574     IERC20 tokenContract = IERC20(_tokenContract);
1575     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1576 
1577     for(uint i=0; i < payableAddressCount; i++ ) {
1578         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1579     }
1580   }
1581 
1582   /**
1583   * @dev Allows Rampp wallet to update its own reference as well as update
1584   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1585   * and since Rampp is always the first address this function is limited to the rampp payout only.
1586   * @param _newAddress updated Rampp Address
1587   */
1588   function setRamppAddress(address _newAddress) public isRampp {
1589     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1590     RAMPPADDRESS = _newAddress;
1591     payableAddresses[0] = _newAddress;
1592   }
1593 }
1594 
1595 
1596   
1597 // File: isFeeable.sol
1598 abstract contract Feeable is Teams {
1599   uint256 public PRICE = 0 ether;
1600 
1601   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1602     PRICE = _feeInWei;
1603   }
1604 
1605   function getPrice(uint256 _count) public view returns (uint256) {
1606     return PRICE * _count;
1607   }
1608 }
1609 
1610   
1611   
1612 abstract contract RamppERC721A is 
1613     Ownable,
1614     Teams,
1615     ERC721A,
1616     Withdrawable,
1617     ReentrancyGuard 
1618     , Feeable 
1619     , Allowlist 
1620     
1621 {
1622   constructor(
1623     string memory tokenName,
1624     string memory tokenSymbol
1625   ) ERC721A(tokenName, tokenSymbol, 2, 12500) { }
1626     uint8 public CONTRACT_VERSION = 2;
1627     string public _baseTokenURI = "";
1628 
1629     bool public mintingOpen = true;
1630     
1631     
1632     uint256 public MAX_WALLET_MINTS = 5000;
1633 
1634   
1635     /////////////// Admin Mint Functions
1636     /**
1637      * @dev Mints a token to an address with a tokenURI.
1638      * This is owner only and allows a fee-free drop
1639      * @param _to address of the future owner of the token
1640      * @param _qty amount of tokens to drop the owner
1641      */
1642      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1643          require(_qty > 0, "Must mint at least 1 token.");
1644          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 88888");
1645          _safeMint(_to, _qty, true);
1646      }
1647 
1648   
1649     /////////////// GENERIC MINT FUNCTIONS
1650     /**
1651     * @dev Mints a single token to an address.
1652     * fee may or may not be required*
1653     * @param _to address of the future owner of the token
1654     */
1655     function mintTo(address _to) public payable {
1656         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1657         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1658         
1659         require(canMintAmount(_to, 200), "Wallet address is over the maximum allowed mints");
1660         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1661         
1662         _safeMint(_to, 1, false);
1663     }
1664 
1665     /**
1666     * @dev Mints a token to an address with a tokenURI.
1667     * fee may or may not be required*
1668     * @param _to address of the future owner of the token
1669     * @param _amount number of tokens to mint
1670     */
1671     function mintToMultiple(address _to, uint256 _amount) public payable {
1672         require(_amount >= 1, "Must mint at least 1 token");
1673         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1674         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1675         
1676         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1677         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 88888");
1678         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1679 
1680         _safeMint(_to, _amount, false);
1681     }
1682 
1683     function openMinting() public onlyTeamOrOwner {
1684         mintingOpen = true;
1685     }
1686 
1687     function stopMinting() public onlyTeamOrOwner {
1688         mintingOpen = false;
1689     }
1690 
1691   
1692     ///////////// ALLOWLIST MINTING FUNCTIONS
1693 
1694     /**
1695     * @dev Mints a token to an address with a tokenURI for allowlist.
1696     * fee may or may not be required*
1697     * @param _to address of the future owner of the token
1698     */
1699     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1700         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1701         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1702         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 8888");
1703         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1704         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1705         
1706 
1707         _safeMint(_to, 1, false);
1708     }
1709 
1710     /**
1711     * @dev Mints a token to an address with a tokenURI for allowlist.
1712     * fee may or may not be required*
1713     * @param _to address of the future owner of the token
1714     * @param _amount number of tokens to mint
1715     */
1716     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1717         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1718         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1719         require(_amount >= 1, "Must mint at least 1 token");
1720         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1721 
1722         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1723         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 8888");
1724         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1725         
1726 
1727         _safeMint(_to, _amount, false);
1728     }
1729 
1730     /**
1731      * @dev Enable allowlist minting fully by enabling both flags
1732      * This is a convenience function for the Rampp user
1733      */
1734     function openAllowlistMint() public onlyTeamOrOwner {
1735         enableAllowlistOnlyMode();
1736         mintingOpen = true;
1737     }
1738 
1739     /**
1740      * @dev Close allowlist minting fully by disabling both flags
1741      * This is a convenience function for the Rampp user
1742      */
1743     function closeAllowlistMint() public onlyTeamOrOwner {
1744         disableAllowlistOnlyMode();
1745         mintingOpen = false;
1746     }
1747 
1748 
1749   
1750     /**
1751     * @dev Check if wallet over MAX_WALLET_MINTS
1752     * @param _address address in question to check if minted count exceeds max
1753     */
1754     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1755         require(_amount >= 1, "Amount must be greater than or equal to 1");
1756         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1757     }
1758 
1759     /**
1760     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1761     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1762     */
1763     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1764         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1765         MAX_WALLET_MINTS = _newWalletMax;
1766     }
1767     
1768 
1769   
1770     /**
1771      * @dev Allows owner to set Max mints per tx
1772      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1773      */
1774      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1775          require(_newMaxMint >= 1, "Max mint must be at least 1");
1776          maxBatchSize = _newMaxMint;
1777      }
1778     
1779 
1780   
1781 
1782   function _baseURI() internal view virtual override returns(string memory) {
1783     return _baseTokenURI;
1784   }
1785 
1786   function baseTokenURI() public view returns(string memory) {
1787     return _baseTokenURI;
1788   }
1789 
1790   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1791     _baseTokenURI = baseURI;
1792   }
1793 
1794   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1795     return ownershipOf(tokenId);
1796   }
1797 }
1798 
1799 
1800   
1801 //SPDX-License-Identifier: MIT
1802 
1803 pragma solidity ^0.8.0;
1804 
1805 contract MEMELAND is RamppERC721A {
1806     constructor() RamppERC721A("MEMELAND", "MEMELAND"){}
1807 }