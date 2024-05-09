1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //     _           _     _       _    __      _____  _  _ ___  ___ ___ ___ _   _ _     __      _____  __  __ ___ _  _ 
5 //    /_\__ ____ _| |_  /_\  _ _| |_  \ \    / / _ \| \| |   \| __| _ \ __| | | | |    \ \    / / _ \|  \/  | __| \| |
6 //   / _ \ V / _` |  _|/ _ \| '_|  _|  \ \/\/ / (_) | .` | |) | _||   / _|| |_| | |__   \ \/\/ / (_) | |\/| | _|| .` |
7 //  /_/ \_\_/\__,_|\__/_/ \_\_|  \__|   \_/\_/ \___/|_|\_|___/|___|_|_\_|  \___/|____|   \_/\_/ \___/|_|  |_|___|_|\_|
8 //                                                                                                                    
9 //
10 //*********************************************************************//
11 //*********************************************************************//
12   
13 //-------------DEPENDENCIES--------------------------//
14 
15 // File: @openzeppelin/contracts/utils/Address.sol
16 
17 
18 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
19 
20 pragma solidity ^0.8.1;
21 
22 /**
23  * @dev Collection of functions related to the address type
24  */
25 library Address {
26     /**
27      * @dev Returns true if account is a contract.
28      *
29      * [IMPORTANT]
30      * ====
31      * It is unsafe to assume that an address for which this function returns
32      * false is an externally-owned account (EOA) and not a contract.
33      *
34      * Among others, isContract will return false for the following
35      * types of addresses:
36      *
37      *  - an externally-owned account
38      *  - a contract in construction
39      *  - an address where a contract will be created
40      *  - an address where a contract lived, but was destroyed
41      * ====
42      *
43      * [IMPORTANT]
44      * ====
45      * You shouldn't rely on isContract to protect against flash loan attacks!
46      *
47      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
48      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
49      * constructor.
50      * ====
51      */
52     function isContract(address account) internal view returns (bool) {
53         // This method relies on extcodesize/address.code.length, which returns 0
54         // for contracts in construction, since the code is only stored at the end
55         // of the constructor execution.
56 
57         return account.code.length > 0;
58     }
59 
60     /**
61      * @dev Replacement for Solidity's transfer: sends amount wei to
62      * recipient, forwarding all available gas and reverting on errors.
63      *
64      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
65      * of certain opcodes, possibly making contracts go over the 2300 gas limit
66      * imposed by transfer, making them unable to receive funds via
67      * transfer. {sendValue} removes this limitation.
68      *
69      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
70      *
71      * IMPORTANT: because control is transferred to recipient, care must be
72      * taken to not create reentrancy vulnerabilities. Consider using
73      * {ReentrancyGuard} or the
74      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
75      */
76     function sendValue(address payable recipient, uint256 amount) internal {
77         require(address(this).balance >= amount, "Address: insufficient balance");
78 
79         (bool success, ) = recipient.call{value: amount}("");
80         require(success, "Address: unable to send value, recipient may have reverted");
81     }
82 
83     /**
84      * @dev Performs a Solidity function call using a low level call. A
85      * plain call is an unsafe replacement for a function call: use this
86      * function instead.
87      *
88      * If target reverts with a revert reason, it is bubbled up by this
89      * function (like regular Solidity function calls).
90      *
91      * Returns the raw returned data. To convert to the expected return value,
92      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
93      *
94      * Requirements:
95      *
96      * - target must be a contract.
97      * - calling target with data must not revert.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
102         return functionCall(target, data, "Address: low-level call failed");
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
107      * errorMessage as a fallback revert reason when target reverts.
108      *
109      * _Available since v3.1._
110      */
111     function functionCall(
112         address target,
113         bytes memory data,
114         string memory errorMessage
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, 0, errorMessage);
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
121      * but also transferring value wei to target.
122      *
123      * Requirements:
124      *
125      * - the calling contract must have an ETH balance of at least value.
126      * - the called Solidity function must be payable.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value
134     ) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
140      * with errorMessage as a fallback revert reason when target reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCallWithValue(
145         address target,
146         bytes memory data,
147         uint256 value,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         require(address(this).balance >= value, "Address: insufficient balance for call");
151         require(isContract(target), "Address: call to non-contract");
152 
153         (bool success, bytes memory returndata) = target.call{value: value}(data);
154         return verifyCallResult(success, returndata, errorMessage);
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
159      * but performing a static call.
160      *
161      * _Available since v3.3._
162      */
163     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
164         return functionStaticCall(target, data, "Address: low-level static call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
169      * but performing a static call.
170      *
171      * _Available since v3.3._
172      */
173     function functionStaticCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal view returns (bytes memory) {
178         require(isContract(target), "Address: static call to non-contract");
179 
180         (bool success, bytes memory returndata) = target.staticcall(data);
181         return verifyCallResult(success, returndata, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
186      * but performing a delegate call.
187      *
188      * _Available since v3.4._
189      */
190     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
191         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
196      * but performing a delegate call.
197      *
198      * _Available since v3.4._
199      */
200     function functionDelegateCall(
201         address target,
202         bytes memory data,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(isContract(target), "Address: delegate call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.delegatecall(data);
208         return verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     /**
212      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
213      * revert reason using the provided one.
214      *
215      * _Available since v4.3._
216      */
217     function verifyCallResult(
218         bool success,
219         bytes memory returndata,
220         string memory errorMessage
221     ) internal pure returns (bytes memory) {
222         if (success) {
223             return returndata;
224         } else {
225             // Look for revert reason and bubble it up if present
226             if (returndata.length > 0) {
227                 // The easiest way to bubble the revert reason is using memory via assembly
228 
229                 assembly {
230                     let returndata_size := mload(returndata)
231                     revert(add(32, returndata), returndata_size)
232                 }
233             } else {
234                 revert(errorMessage);
235             }
236         }
237     }
238 }
239 
240 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
241 
242 
243 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @title ERC721 token receiver interface
249  * @dev Interface for any contract that wants to support safeTransfers
250  * from ERC721 asset contracts.
251  */
252 interface IERC721Receiver {
253     /**
254      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
255      * by operator from from, this function is called.
256      *
257      * It must return its Solidity selector to confirm the token transfer.
258      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
259      *
260      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
261      */
262     function onERC721Received(
263         address operator,
264         address from,
265         uint256 tokenId,
266         bytes calldata data
267     ) external returns (bytes4);
268 }
269 
270 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
271 
272 
273 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @dev Interface of the ERC165 standard, as defined in the
279  * https://eips.ethereum.org/EIPS/eip-165[EIP].
280  *
281  * Implementers can declare support of contract interfaces, which can then be
282  * queried by others ({ERC165Checker}).
283  *
284  * For an implementation, see {ERC165}.
285  */
286 interface IERC165 {
287     /**
288      * @dev Returns true if this contract implements the interface defined by
289      * interfaceId. See the corresponding
290      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
291      * to learn more about how these ids are created.
292      *
293      * This function call must use less than 30 000 gas.
294      */
295     function supportsInterface(bytes4 interfaceId) external view returns (bool);
296 }
297 
298 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
299 
300 
301 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 
306 /**
307  * @dev Implementation of the {IERC165} interface.
308  *
309  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
310  * for the additional interface id that will be supported. For example:
311  *
312  * solidity
313  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
314  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
315  * }
316  * 
317  *
318  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
319  */
320 abstract contract ERC165 is IERC165 {
321     /**
322      * @dev See {IERC165-supportsInterface}.
323      */
324     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
325         return interfaceId == type(IERC165).interfaceId;
326     }
327 }
328 
329 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
330 
331 
332 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 
337 /**
338  * @dev Required interface of an ERC721 compliant contract.
339  */
340 interface IERC721 is IERC165 {
341     /**
342      * @dev Emitted when tokenId token is transferred from from to to.
343      */
344     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
345 
346     /**
347      * @dev Emitted when owner enables approved to manage the tokenId token.
348      */
349     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
350 
351     /**
352      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
353      */
354     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
355 
356     /**
357      * @dev Returns the number of tokens in owner's account.
358      */
359     function balanceOf(address owner) external view returns (uint256 balance);
360 
361     /**
362      * @dev Returns the owner of the tokenId token.
363      *
364      * Requirements:
365      *
366      * - tokenId must exist.
367      */
368     function ownerOf(uint256 tokenId) external view returns (address owner);
369 
370     /**
371      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
372      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
373      *
374      * Requirements:
375      *
376      * - from cannot be the zero address.
377      * - to cannot be the zero address.
378      * - tokenId token must exist and be owned by from.
379      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
380      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
381      *
382      * Emits a {Transfer} event.
383      */
384     function safeTransferFrom(
385         address from,
386         address to,
387         uint256 tokenId
388     ) external;
389 
390     /**
391      * @dev Transfers tokenId token from from to to.
392      *
393      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
394      *
395      * Requirements:
396      *
397      * - from cannot be the zero address.
398      * - to cannot be the zero address.
399      * - tokenId token must be owned by from.
400      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
401      *
402      * Emits a {Transfer} event.
403      */
404     function transferFrom(
405         address from,
406         address to,
407         uint256 tokenId
408     ) external;
409 
410     /**
411      * @dev Gives permission to to to transfer tokenId token to another account.
412      * The approval is cleared when the token is transferred.
413      *
414      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
415      *
416      * Requirements:
417      *
418      * - The caller must own the token or be an approved operator.
419      * - tokenId must exist.
420      *
421      * Emits an {Approval} event.
422      */
423     function approve(address to, uint256 tokenId) external;
424 
425     /**
426      * @dev Returns the account approved for tokenId token.
427      *
428      * Requirements:
429      *
430      * - tokenId must exist.
431      */
432     function getApproved(uint256 tokenId) external view returns (address operator);
433 
434     /**
435      * @dev Approve or remove operator as an operator for the caller.
436      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
437      *
438      * Requirements:
439      *
440      * - The operator cannot be the caller.
441      *
442      * Emits an {ApprovalForAll} event.
443      */
444     function setApprovalForAll(address operator, bool _approved) external;
445 
446     /**
447      * @dev Returns if the operator is allowed to manage all of the assets of owner.
448      *
449      * See {setApprovalForAll}
450      */
451     function isApprovedForAll(address owner, address operator) external view returns (bool);
452 
453     /**
454      * @dev Safely transfers tokenId token from from to to.
455      *
456      * Requirements:
457      *
458      * - from cannot be the zero address.
459      * - to cannot be the zero address.
460      * - tokenId token must exist and be owned by from.
461      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
462      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
463      *
464      * Emits a {Transfer} event.
465      */
466     function safeTransferFrom(
467         address from,
468         address to,
469         uint256 tokenId,
470         bytes calldata data
471     ) external;
472 }
473 
474 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
475 
476 
477 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 
482 /**
483  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
484  * @dev See https://eips.ethereum.org/EIPS/eip-721
485  */
486 interface IERC721Enumerable is IERC721 {
487     /**
488      * @dev Returns the total amount of tokens stored by the contract.
489      */
490     function totalSupply() external view returns (uint256);
491 
492     /**
493      * @dev Returns a token ID owned by owner at a given index of its token list.
494      * Use along with {balanceOf} to enumerate all of owner's tokens.
495      */
496     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
497 
498     /**
499      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
500      * Use along with {totalSupply} to enumerate all tokens.
501      */
502     function tokenByIndex(uint256 index) external view returns (uint256);
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
515  * @dev See https://eips.ethereum.org/EIPS/eip-721
516  */
517 interface IERC721Metadata is IERC721 {
518     /**
519      * @dev Returns the token collection name.
520      */
521     function name() external view returns (string memory);
522 
523     /**
524      * @dev Returns the token collection symbol.
525      */
526     function symbol() external view returns (string memory);
527 
528     /**
529      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
530      */
531     function tokenURI(uint256 tokenId) external view returns (string memory);
532 }
533 
534 // File: @openzeppelin/contracts/utils/Strings.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev String operations.
543  */
544 library Strings {
545     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
546 
547     /**
548      * @dev Converts a uint256 to its ASCII string decimal representation.
549      */
550     function toString(uint256 value) internal pure returns (string memory) {
551         // Inspired by OraclizeAPI's implementation - MIT licence
552         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
553 
554         if (value == 0) {
555             return "0";
556         }
557         uint256 temp = value;
558         uint256 digits;
559         while (temp != 0) {
560             digits++;
561             temp /= 10;
562         }
563         bytes memory buffer = new bytes(digits);
564         while (value != 0) {
565             digits -= 1;
566             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
567             value /= 10;
568         }
569         return string(buffer);
570     }
571 
572     /**
573      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
574      */
575     function toHexString(uint256 value) internal pure returns (string memory) {
576         if (value == 0) {
577             return "0x00";
578         }
579         uint256 temp = value;
580         uint256 length = 0;
581         while (temp != 0) {
582             length++;
583             temp >>= 8;
584         }
585         return toHexString(value, length);
586     }
587 
588     /**
589      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
590      */
591     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
592         bytes memory buffer = new bytes(2 * length + 2);
593         buffer[0] = "0";
594         buffer[1] = "x";
595         for (uint256 i = 2 * length + 1; i > 1; --i) {
596             buffer[i] = _HEX_SYMBOLS[value & 0xf];
597             value >>= 4;
598         }
599         require(value == 0, "Strings: hex length insufficient");
600         return string(buffer);
601     }
602 }
603 
604 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
605 
606 
607 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 /**
612  * @dev Contract module that helps prevent reentrant calls to a function.
613  *
614  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
615  * available, which can be applied to functions to make sure there are no nested
616  * (reentrant) calls to them.
617  *
618  * Note that because there is a single nonReentrant guard, functions marked as
619  * nonReentrant may not call one another. This can be worked around by making
620  * those functions private, and then adding external nonReentrant entry
621  * points to them.
622  *
623  * TIP: If you would like to learn more about reentrancy and alternative ways
624  * to protect against it, check out our blog post
625  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
626  */
627 abstract contract ReentrancyGuard {
628     // Booleans are more expensive than uint256 or any type that takes up a full
629     // word because each write operation emits an extra SLOAD to first read the
630     // slot's contents, replace the bits taken up by the boolean, and then write
631     // back. This is the compiler's defense against contract upgrades and
632     // pointer aliasing, and it cannot be disabled.
633 
634     // The values being non-zero value makes deployment a bit more expensive,
635     // but in exchange the refund on every call to nonReentrant will be lower in
636     // amount. Since refunds are capped to a percentage of the total
637     // transaction's gas, it is best to keep them low in cases like this one, to
638     // increase the likelihood of the full refund coming into effect.
639     uint256 private constant _NOT_ENTERED = 1;
640     uint256 private constant _ENTERED = 2;
641 
642     uint256 private _status;
643 
644     constructor() {
645         _status = _NOT_ENTERED;
646     }
647 
648     /**
649      * @dev Prevents a contract from calling itself, directly or indirectly.
650      * Calling a nonReentrant function from another nonReentrant
651      * function is not supported. It is possible to prevent this from happening
652      * by making the nonReentrant function external, and making it call a
653      * private function that does the actual work.
654      */
655     modifier nonReentrant() {
656         // On the first call to nonReentrant, _notEntered will be true
657         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
658 
659         // Any calls to nonReentrant after this point will fail
660         _status = _ENTERED;
661 
662         _;
663 
664         // By storing the original value once again, a refund is triggered (see
665         // https://eips.ethereum.org/EIPS/eip-2200)
666         _status = _NOT_ENTERED;
667     }
668 }
669 
670 // File: @openzeppelin/contracts/utils/Context.sol
671 
672 
673 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
674 
675 pragma solidity ^0.8.0;
676 
677 /**
678  * @dev Provides information about the current execution context, including the
679  * sender of the transaction and its data. While these are generally available
680  * via msg.sender and msg.data, they should not be accessed in such a direct
681  * manner, since when dealing with meta-transactions the account sending and
682  * paying for execution may not be the actual sender (as far as an application
683  * is concerned).
684  *
685  * This contract is only required for intermediate, library-like contracts.
686  */
687 abstract contract Context {
688     function _msgSender() internal view virtual returns (address) {
689         return msg.sender;
690     }
691 
692     function _msgData() internal view virtual returns (bytes calldata) {
693         return msg.data;
694     }
695 }
696 
697 // File: @openzeppelin/contracts/access/Ownable.sol
698 
699 
700 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @dev Contract module which provides a basic access control mechanism, where
707  * there is an account (an owner) that can be granted exclusive access to
708  * specific functions.
709  *
710  * By default, the owner account will be the one that deploys the contract. This
711  * can later be changed with {transferOwnership}.
712  *
713  * This module is used through inheritance. It will make available the modifier
714  * onlyOwner, which can be applied to your functions to restrict their use to
715  * the owner.
716  */
717 abstract contract Ownable is Context {
718     address private _owner;
719 
720     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
721 
722     /**
723      * @dev Initializes the contract setting the deployer as the initial owner.
724      */
725     constructor() {
726         _transferOwnership(_msgSender());
727     }
728 
729     /**
730      * @dev Returns the address of the current owner.
731      */
732     function owner() public view virtual returns (address) {
733         return _owner;
734     }
735 
736     /**
737      * @dev Throws if called by any account other than the owner.
738      */
739     modifier onlyOwner() {
740         require(owner() == _msgSender(), "Ownable: caller is not the owner");
741         _;
742     }
743 
744     /**
745      * @dev Leaves the contract without owner. It will not be possible to call
746      * onlyOwner functions anymore. Can only be called by the current owner.
747      *
748      * NOTE: Renouncing ownership will leave the contract without an owner,
749      * thereby removing any functionality that is only available to the owner.
750      */
751     function renounceOwnership() public virtual onlyOwner {
752         _transferOwnership(address(0));
753     }
754 
755     /**
756      * @dev Transfers ownership of the contract to a new account (newOwner).
757      * Can only be called by the current owner.
758      */
759     function transferOwnership(address newOwner) public virtual onlyOwner {
760         require(newOwner != address(0), "Ownable: new owner is the zero address");
761         _transferOwnership(newOwner);
762     }
763 
764     /**
765      * @dev Transfers ownership of the contract to a new account (newOwner).
766      * Internal function without access restriction.
767      */
768     function _transferOwnership(address newOwner) internal virtual {
769         address oldOwner = _owner;
770         _owner = newOwner;
771         emit OwnershipTransferred(oldOwner, newOwner);
772     }
773 }
774 
775 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
776 pragma solidity ^0.8.9;
777 
778 interface IOperatorFilterRegistry {
779     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
780     function register(address registrant) external;
781     function registerAndSubscribe(address registrant, address subscription) external;
782     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
783     function updateOperator(address registrant, address operator, bool filtered) external;
784     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
785     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
786     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
787     function subscribe(address registrant, address registrantToSubscribe) external;
788     function unsubscribe(address registrant, bool copyExistingEntries) external;
789     function subscriptionOf(address addr) external returns (address registrant);
790     function subscribers(address registrant) external returns (address[] memory);
791     function subscriberAt(address registrant, uint256 index) external returns (address);
792     function copyEntriesOf(address registrant, address registrantToCopy) external;
793     function isOperatorFiltered(address registrant, address operator) external returns (bool);
794     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
795     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
796     function filteredOperators(address addr) external returns (address[] memory);
797     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
798     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
799     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
800     function isRegistered(address addr) external returns (bool);
801     function codeHashOf(address addr) external returns (bytes32);
802 }
803 
804 // File contracts/OperatorFilter/OperatorFilterer.sol
805 pragma solidity ^0.8.9;
806 
807 abstract contract OperatorFilterer {
808     error OperatorNotAllowed(address operator);
809 
810     IOperatorFilterRegistry constant operatorFilterRegistry =
811         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
812 
813     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
814         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
815         // will not revert, but the contract will need to be registered with the registry once it is deployed in
816         // order for the modifier to filter addresses.
817         if (address(operatorFilterRegistry).code.length > 0) {
818             if (subscribe) {
819                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
820             } else {
821                 if (subscriptionOrRegistrantToCopy != address(0)) {
822                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
823                 } else {
824                     operatorFilterRegistry.register(address(this));
825                 }
826             }
827         }
828     }
829 
830     function _onlyAllowedOperator(address from) private view {
831       if (
832           !(
833               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
834               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
835           )
836       ) {
837           revert OperatorNotAllowed(msg.sender);
838       }
839     }
840 
841     modifier onlyAllowedOperator(address from) virtual {
842         // Check registry code length to facilitate testing in environments without a deployed registry.
843         if (address(operatorFilterRegistry).code.length > 0) {
844             // Allow spending tokens from addresses with balance
845             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
846             // from an EOA.
847             if (from == msg.sender) {
848                 _;
849                 return;
850             }
851             _onlyAllowedOperator(from);
852         }
853         _;
854     }
855 }
856 
857 //-------------END DEPENDENCIES------------------------//
858 
859 
860   
861 // Rampp Contracts v2.1 (Teams.sol)
862 
863 pragma solidity ^0.8.0;
864 
865 /**
866 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
867 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
868 * This will easily allow cross-collaboration via Mintplex.xyz.
869 **/
870 abstract contract Teams is Ownable{
871   mapping (address => bool) internal team;
872 
873   /**
874   * @dev Adds an address to the team. Allows them to execute protected functions
875   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
876   **/
877   function addToTeam(address _address) public onlyOwner {
878     require(_address != address(0), "Invalid address");
879     require(!inTeam(_address), "This address is already in your team.");
880   
881     team[_address] = true;
882   }
883 
884   /**
885   * @dev Removes an address to the team.
886   * @param _address the ETH address to remove, cannot be 0x and must be in team
887   **/
888   function removeFromTeam(address _address) public onlyOwner {
889     require(_address != address(0), "Invalid address");
890     require(inTeam(_address), "This address is not in your team currently.");
891   
892     team[_address] = false;
893   }
894 
895   /**
896   * @dev Check if an address is valid and active in the team
897   * @param _address ETH address to check for truthiness
898   **/
899   function inTeam(address _address)
900     public
901     view
902     returns (bool)
903   {
904     require(_address != address(0), "Invalid address to check.");
905     return team[_address] == true;
906   }
907 
908   /**
909   * @dev Throws if called by any account other than the owner or team member.
910   */
911   function _onlyTeamOrOwner() private view {
912     bool _isOwner = owner() == _msgSender();
913     bool _isTeam = inTeam(_msgSender());
914     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
915   }
916 
917   modifier onlyTeamOrOwner() {
918     _onlyTeamOrOwner();
919     _;
920   }
921 }
922 
923 
924   
925   
926 /**
927  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
928  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
929  *
930  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
931  * 
932  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
933  *
934  * Does not support burning tokens to address(0).
935  */
936 contract ERC721A is
937   Context,
938   ERC165,
939   IERC721,
940   IERC721Metadata,
941   IERC721Enumerable,
942   Teams
943   , OperatorFilterer
944 {
945   using Address for address;
946   using Strings for uint256;
947 
948   struct TokenOwnership {
949     address addr;
950     uint64 startTimestamp;
951   }
952 
953   struct AddressData {
954     uint128 balance;
955     uint128 numberMinted;
956   }
957 
958   uint256 private currentIndex;
959 
960   uint256 public immutable collectionSize;
961   uint256 public maxBatchSize;
962 
963   // Token name
964   string private _name;
965 
966   // Token symbol
967   string private _symbol;
968 
969   // Mapping from token ID to ownership details
970   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
971   mapping(uint256 => TokenOwnership) private _ownerships;
972 
973   // Mapping owner address to address data
974   mapping(address => AddressData) private _addressData;
975 
976   // Mapping from token ID to approved address
977   mapping(uint256 => address) private _tokenApprovals;
978 
979   // Mapping from owner to operator approvals
980   mapping(address => mapping(address => bool)) private _operatorApprovals;
981 
982   /* @dev Mapping of restricted operator approvals set by contract Owner
983   * This serves as an optional addition to ERC-721 so
984   * that the contract owner can elect to prevent specific addresses/contracts
985   * from being marked as the approver for a token. The reason for this
986   * is that some projects may want to retain control of where their tokens can/can not be listed
987   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
988   * By default, there are no restrictions. The contract owner must deliberatly block an address 
989   */
990   mapping(address => bool) public restrictedApprovalAddresses;
991 
992   /**
993    * @dev
994    * maxBatchSize refers to how much a minter can mint at a time.
995    * collectionSize_ refers to how many tokens are in the collection.
996    */
997   constructor(
998     string memory name_,
999     string memory symbol_,
1000     uint256 maxBatchSize_,
1001     uint256 collectionSize_
1002   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1003     require(
1004       collectionSize_ > 0,
1005       "ERC721A: collection must have a nonzero supply"
1006     );
1007     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1008     _name = name_;
1009     _symbol = symbol_;
1010     maxBatchSize = maxBatchSize_;
1011     collectionSize = collectionSize_;
1012     currentIndex = _startTokenId();
1013   }
1014 
1015   /**
1016   * To change the starting tokenId, please override this function.
1017   */
1018   function _startTokenId() internal view virtual returns (uint256) {
1019     return 1;
1020   }
1021 
1022   /**
1023    * @dev See {IERC721Enumerable-totalSupply}.
1024    */
1025   function totalSupply() public view override returns (uint256) {
1026     return _totalMinted();
1027   }
1028 
1029   function currentTokenId() public view returns (uint256) {
1030     return _totalMinted();
1031   }
1032 
1033   function getNextTokenId() public view returns (uint256) {
1034       return _totalMinted() + 1;
1035   }
1036 
1037   /**
1038   * Returns the total amount of tokens minted in the contract.
1039   */
1040   function _totalMinted() internal view returns (uint256) {
1041     unchecked {
1042       return currentIndex - _startTokenId();
1043     }
1044   }
1045 
1046   /**
1047    * @dev See {IERC721Enumerable-tokenByIndex}.
1048    */
1049   function tokenByIndex(uint256 index) public view override returns (uint256) {
1050     require(index < totalSupply(), "ERC721A: global index out of bounds");
1051     return index;
1052   }
1053 
1054   /**
1055    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1056    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1057    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1058    */
1059   function tokenOfOwnerByIndex(address owner, uint256 index)
1060     public
1061     view
1062     override
1063     returns (uint256)
1064   {
1065     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1066     uint256 numMintedSoFar = totalSupply();
1067     uint256 tokenIdsIdx = 0;
1068     address currOwnershipAddr = address(0);
1069     for (uint256 i = 0; i < numMintedSoFar; i++) {
1070       TokenOwnership memory ownership = _ownerships[i];
1071       if (ownership.addr != address(0)) {
1072         currOwnershipAddr = ownership.addr;
1073       }
1074       if (currOwnershipAddr == owner) {
1075         if (tokenIdsIdx == index) {
1076           return i;
1077         }
1078         tokenIdsIdx++;
1079       }
1080     }
1081     revert("ERC721A: unable to get token of owner by index");
1082   }
1083 
1084   /**
1085    * @dev See {IERC165-supportsInterface}.
1086    */
1087   function supportsInterface(bytes4 interfaceId)
1088     public
1089     view
1090     virtual
1091     override(ERC165, IERC165)
1092     returns (bool)
1093   {
1094     return
1095       interfaceId == type(IERC721).interfaceId ||
1096       interfaceId == type(IERC721Metadata).interfaceId ||
1097       interfaceId == type(IERC721Enumerable).interfaceId ||
1098       super.supportsInterface(interfaceId);
1099   }
1100 
1101   /**
1102    * @dev See {IERC721-balanceOf}.
1103    */
1104   function balanceOf(address owner) public view override returns (uint256) {
1105     require(owner != address(0), "ERC721A: balance query for the zero address");
1106     return uint256(_addressData[owner].balance);
1107   }
1108 
1109   function _numberMinted(address owner) internal view returns (uint256) {
1110     require(
1111       owner != address(0),
1112       "ERC721A: number minted query for the zero address"
1113     );
1114     return uint256(_addressData[owner].numberMinted);
1115   }
1116 
1117   function ownershipOf(uint256 tokenId)
1118     internal
1119     view
1120     returns (TokenOwnership memory)
1121   {
1122     uint256 curr = tokenId;
1123 
1124     unchecked {
1125         if (_startTokenId() <= curr && curr < currentIndex) {
1126             TokenOwnership memory ownership = _ownerships[curr];
1127             if (ownership.addr != address(0)) {
1128                 return ownership;
1129             }
1130 
1131             // Invariant:
1132             // There will always be an ownership that has an address and is not burned
1133             // before an ownership that does not have an address and is not burned.
1134             // Hence, curr will not underflow.
1135             while (true) {
1136                 curr--;
1137                 ownership = _ownerships[curr];
1138                 if (ownership.addr != address(0)) {
1139                     return ownership;
1140                 }
1141             }
1142         }
1143     }
1144 
1145     revert("ERC721A: unable to determine the owner of token");
1146   }
1147 
1148   /**
1149    * @dev See {IERC721-ownerOf}.
1150    */
1151   function ownerOf(uint256 tokenId) public view override returns (address) {
1152     return ownershipOf(tokenId).addr;
1153   }
1154 
1155   /**
1156    * @dev See {IERC721Metadata-name}.
1157    */
1158   function name() public view virtual override returns (string memory) {
1159     return _name;
1160   }
1161 
1162   /**
1163    * @dev See {IERC721Metadata-symbol}.
1164    */
1165   function symbol() public view virtual override returns (string memory) {
1166     return _symbol;
1167   }
1168 
1169   /**
1170    * @dev See {IERC721Metadata-tokenURI}.
1171    */
1172   function tokenURI(uint256 tokenId)
1173     public
1174     view
1175     virtual
1176     override
1177     returns (string memory)
1178   {
1179     string memory baseURI = _baseURI();
1180     string memory extension = _baseURIExtension();
1181     return
1182       bytes(baseURI).length > 0
1183         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1184         : "";
1185   }
1186 
1187   /**
1188    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1189    * token will be the concatenation of the baseURI and the tokenId. Empty
1190    * by default, can be overriden in child contracts.
1191    */
1192   function _baseURI() internal view virtual returns (string memory) {
1193     return "";
1194   }
1195 
1196   /**
1197    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1198    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1199    * by default, can be overriden in child contracts.
1200    */
1201   function _baseURIExtension() internal view virtual returns (string memory) {
1202     return "";
1203   }
1204 
1205   /**
1206    * @dev Sets the value for an address to be in the restricted approval address pool.
1207    * Setting an address to true will disable token owners from being able to mark the address
1208    * for approval for trading. This would be used in theory to prevent token owners from listing
1209    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1210    * @param _address the marketplace/user to modify restriction status of
1211    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1212    */
1213   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1214     restrictedApprovalAddresses[_address] = _isRestricted;
1215   }
1216 
1217   /**
1218    * @dev See {IERC721-approve}.
1219    */
1220   function approve(address to, uint256 tokenId) public override {
1221     address owner = ERC721A.ownerOf(tokenId);
1222     require(to != owner, "ERC721A: approval to current owner");
1223     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1224 
1225     require(
1226       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1227       "ERC721A: approve caller is not owner nor approved for all"
1228     );
1229 
1230     _approve(to, tokenId, owner);
1231   }
1232 
1233   /**
1234    * @dev See {IERC721-getApproved}.
1235    */
1236   function getApproved(uint256 tokenId) public view override returns (address) {
1237     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1238 
1239     return _tokenApprovals[tokenId];
1240   }
1241 
1242   /**
1243    * @dev See {IERC721-setApprovalForAll}.
1244    */
1245   function setApprovalForAll(address operator, bool approved) public override {
1246     require(operator != _msgSender(), "ERC721A: approve to caller");
1247     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1248 
1249     _operatorApprovals[_msgSender()][operator] = approved;
1250     emit ApprovalForAll(_msgSender(), operator, approved);
1251   }
1252 
1253   /**
1254    * @dev See {IERC721-isApprovedForAll}.
1255    */
1256   function isApprovedForAll(address owner, address operator)
1257     public
1258     view
1259     virtual
1260     override
1261     returns (bool)
1262   {
1263     return _operatorApprovals[owner][operator];
1264   }
1265 
1266   /**
1267    * @dev See {IERC721-transferFrom}.
1268    */
1269   function transferFrom(
1270     address from,
1271     address to,
1272     uint256 tokenId
1273   ) public override onlyAllowedOperator(from) {
1274     _transfer(from, to, tokenId);
1275   }
1276 
1277   /**
1278    * @dev See {IERC721-safeTransferFrom}.
1279    */
1280   function safeTransferFrom(
1281     address from,
1282     address to,
1283     uint256 tokenId
1284   ) public override onlyAllowedOperator(from) {
1285     safeTransferFrom(from, to, tokenId, "");
1286   }
1287 
1288   /**
1289    * @dev See {IERC721-safeTransferFrom}.
1290    */
1291   function safeTransferFrom(
1292     address from,
1293     address to,
1294     uint256 tokenId,
1295     bytes memory _data
1296   ) public override onlyAllowedOperator(from) {
1297     _transfer(from, to, tokenId);
1298     require(
1299       _checkOnERC721Received(from, to, tokenId, _data),
1300       "ERC721A: transfer to non ERC721Receiver implementer"
1301     );
1302   }
1303 
1304   /**
1305    * @dev Returns whether tokenId exists.
1306    *
1307    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1308    *
1309    * Tokens start existing when they are minted (_mint),
1310    */
1311   function _exists(uint256 tokenId) internal view returns (bool) {
1312     return _startTokenId() <= tokenId && tokenId < currentIndex;
1313   }
1314 
1315   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1316     _safeMint(to, quantity, isAdminMint, "");
1317   }
1318 
1319   /**
1320    * @dev Mints quantity tokens and transfers them to to.
1321    *
1322    * Requirements:
1323    *
1324    * - there must be quantity tokens remaining unminted in the total collection.
1325    * - to cannot be the zero address.
1326    * - quantity cannot be larger than the max batch size.
1327    *
1328    * Emits a {Transfer} event.
1329    */
1330   function _safeMint(
1331     address to,
1332     uint256 quantity,
1333     bool isAdminMint,
1334     bytes memory _data
1335   ) internal {
1336     uint256 startTokenId = currentIndex;
1337     require(to != address(0), "ERC721A: mint to the zero address");
1338     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1339     require(!_exists(startTokenId), "ERC721A: token already minted");
1340 
1341     // For admin mints we do not want to enforce the maxBatchSize limit
1342     if (isAdminMint == false) {
1343         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1344     }
1345 
1346     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1347 
1348     AddressData memory addressData = _addressData[to];
1349     _addressData[to] = AddressData(
1350       addressData.balance + uint128(quantity),
1351       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1352     );
1353     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1354 
1355     uint256 updatedIndex = startTokenId;
1356 
1357     for (uint256 i = 0; i < quantity; i++) {
1358       emit Transfer(address(0), to, updatedIndex);
1359       require(
1360         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1361         "ERC721A: transfer to non ERC721Receiver implementer"
1362       );
1363       updatedIndex++;
1364     }
1365 
1366     currentIndex = updatedIndex;
1367     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1368   }
1369 
1370   /**
1371    * @dev Transfers tokenId from from to to.
1372    *
1373    * Requirements:
1374    *
1375    * - to cannot be the zero address.
1376    * - tokenId token must be owned by from.
1377    *
1378    * Emits a {Transfer} event.
1379    */
1380   function _transfer(
1381     address from,
1382     address to,
1383     uint256 tokenId
1384   ) private {
1385     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1386 
1387     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1388       getApproved(tokenId) == _msgSender() ||
1389       isApprovedForAll(prevOwnership.addr, _msgSender()));
1390 
1391     require(
1392       isApprovedOrOwner,
1393       "ERC721A: transfer caller is not owner nor approved"
1394     );
1395 
1396     require(
1397       prevOwnership.addr == from,
1398       "ERC721A: transfer from incorrect owner"
1399     );
1400     require(to != address(0), "ERC721A: transfer to the zero address");
1401 
1402     _beforeTokenTransfers(from, to, tokenId, 1);
1403 
1404     // Clear approvals from the previous owner
1405     _approve(address(0), tokenId, prevOwnership.addr);
1406 
1407     _addressData[from].balance -= 1;
1408     _addressData[to].balance += 1;
1409     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1410 
1411     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1412     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1413     uint256 nextTokenId = tokenId + 1;
1414     if (_ownerships[nextTokenId].addr == address(0)) {
1415       if (_exists(nextTokenId)) {
1416         _ownerships[nextTokenId] = TokenOwnership(
1417           prevOwnership.addr,
1418           prevOwnership.startTimestamp
1419         );
1420       }
1421     }
1422 
1423     emit Transfer(from, to, tokenId);
1424     _afterTokenTransfers(from, to, tokenId, 1);
1425   }
1426 
1427   /**
1428    * @dev Approve to to operate on tokenId
1429    *
1430    * Emits a {Approval} event.
1431    */
1432   function _approve(
1433     address to,
1434     uint256 tokenId,
1435     address owner
1436   ) private {
1437     _tokenApprovals[tokenId] = to;
1438     emit Approval(owner, to, tokenId);
1439   }
1440 
1441   uint256 public nextOwnerToExplicitlySet = 0;
1442 
1443   /**
1444    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1445    */
1446   function _setOwnersExplicit(uint256 quantity) internal {
1447     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1448     require(quantity > 0, "quantity must be nonzero");
1449     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1450 
1451     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1452     if (endIndex > collectionSize - 1) {
1453       endIndex = collectionSize - 1;
1454     }
1455     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1456     require(_exists(endIndex), "not enough minted yet for this cleanup");
1457     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1458       if (_ownerships[i].addr == address(0)) {
1459         TokenOwnership memory ownership = ownershipOf(i);
1460         _ownerships[i] = TokenOwnership(
1461           ownership.addr,
1462           ownership.startTimestamp
1463         );
1464       }
1465     }
1466     nextOwnerToExplicitlySet = endIndex + 1;
1467   }
1468 
1469   /**
1470    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1471    * The call is not executed if the target address is not a contract.
1472    *
1473    * @param from address representing the previous owner of the given token ID
1474    * @param to target address that will receive the tokens
1475    * @param tokenId uint256 ID of the token to be transferred
1476    * @param _data bytes optional data to send along with the call
1477    * @return bool whether the call correctly returned the expected magic value
1478    */
1479   function _checkOnERC721Received(
1480     address from,
1481     address to,
1482     uint256 tokenId,
1483     bytes memory _data
1484   ) private returns (bool) {
1485     if (to.isContract()) {
1486       try
1487         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1488       returns (bytes4 retval) {
1489         return retval == IERC721Receiver(to).onERC721Received.selector;
1490       } catch (bytes memory reason) {
1491         if (reason.length == 0) {
1492           revert("ERC721A: transfer to non ERC721Receiver implementer");
1493         } else {
1494           assembly {
1495             revert(add(32, reason), mload(reason))
1496           }
1497         }
1498       }
1499     } else {
1500       return true;
1501     }
1502   }
1503 
1504   /**
1505    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1506    *
1507    * startTokenId - the first token id to be transferred
1508    * quantity - the amount to be transferred
1509    *
1510    * Calling conditions:
1511    *
1512    * - When from and to are both non-zero, from's tokenId will be
1513    * transferred to to.
1514    * - When from is zero, tokenId will be minted for to.
1515    */
1516   function _beforeTokenTransfers(
1517     address from,
1518     address to,
1519     uint256 startTokenId,
1520     uint256 quantity
1521   ) internal virtual {}
1522 
1523   /**
1524    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1525    * minting.
1526    *
1527    * startTokenId - the first token id to be transferred
1528    * quantity - the amount to be transferred
1529    *
1530    * Calling conditions:
1531    *
1532    * - when from and to are both non-zero.
1533    * - from and to are never both zero.
1534    */
1535   function _afterTokenTransfers(
1536     address from,
1537     address to,
1538     uint256 startTokenId,
1539     uint256 quantity
1540   ) internal virtual {}
1541 }
1542 
1543 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1544 // @author Mintplex.xyz (Rampp Labs Inc) (Twitter: @MintplexNFT)
1545 // @notice -- See Medium article --
1546 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1547 abstract contract ERC721ARedemption is ERC721A {
1548   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1549   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1550 
1551   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1552   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1553   
1554   uint256 public redemptionSurcharge = 0 ether;
1555   bool public redemptionModeEnabled;
1556   bool public verifiedClaimModeEnabled;
1557   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1558   mapping(address => bool) public redemptionContracts;
1559   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1560 
1561   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1562   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1563     redemptionContracts[_contractAddress] = _status;
1564   }
1565 
1566   // @dev Allow owner/team to determine if contract is accepting redemption mints
1567   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1568     redemptionModeEnabled = _newStatus;
1569   }
1570 
1571   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1572   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1573     verifiedClaimModeEnabled = _newStatus;
1574   }
1575 
1576   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1577   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1578     redemptionSurcharge = _newSurchargeInWei;
1579   }
1580 
1581   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1582   // @notice Must be a wallet address or implement IERC721Receiver.
1583   // Cannot be null address as this will break any ERC-721A implementation without a proper
1584   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1585   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1586     require(_newRedemptionAddress != address(0), "New redemption address cannot be null address.");
1587     redemptionAddress = _newRedemptionAddress;
1588   }
1589 
1590   /**
1591   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1592   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1593   * the contract owner or Team => redemptionAddress. 
1594   * @param tokenId the token to be redeemed.
1595   * Emits a {Redeemed} event.
1596   **/
1597   function redeem(address redemptionContract, uint256 tokenId) public payable {
1598     require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1599     require(redemptionModeEnabled, "ERC721 Redeemable: Redemption mode is not enabled currently");
1600     require(redemptionContract != address(0), "ERC721 Redeemable: Redemption contract cannot be null.");
1601     require(redemptionContracts[redemptionContract], "ERC721 Redeemable: Redemption contract is not eligable for redeeming.");
1602     require(msg.value == redemptionSurcharge, "ERC721 Redeemable: Redemption fee not sent by redeemer.");
1603     require(tokenRedemptions[redemptionContract][tokenId] == false, "ERC721 Redeemable: Token has already been redeemed.");
1604     
1605     IERC721 _targetContract = IERC721(redemptionContract);
1606     require(_targetContract.ownerOf(tokenId) == _msgSender(), "ERC721 Redeemable: Redeemer not owner of token to be claimed against.");
1607     require(_targetContract.getApproved(tokenId) == address(this), "ERC721 Redeemable: This contract is not approved for specific token on redempetion contract.");
1608     
1609     // Warning: Since there is no standarized return value for transfers of ERC-721
1610     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1611     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1612     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1613     // but the NFT may not have been sent to the redemptionAddress.
1614     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1615     tokenRedemptions[redemptionContract][tokenId] = true;
1616 
1617     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1618     _safeMint(_msgSender(), 1, false);
1619   }
1620 
1621   /**
1622   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1623   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1624   * @param tokenId the token to be redeemed.
1625   * Emits a {VerifiedClaim} event.
1626   **/
1627   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1628     require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1629     require(verifiedClaimModeEnabled, "ERC721 Redeemable: Verified claim mode is not enabled currently");
1630     require(redemptionContract != address(0), "ERC721 Redeemable: Redemption contract cannot be null.");
1631     require(redemptionContracts[redemptionContract], "ERC721 Redeemable: Redemption contract is not eligable for redeeming.");
1632     require(msg.value == redemptionSurcharge, "ERC721 Redeemable: Redemption fee not sent by redeemer.");
1633     require(tokenRedemptions[redemptionContract][tokenId] == false, "ERC721 Redeemable: Token has already been redeemed.");
1634     
1635     tokenRedemptions[redemptionContract][tokenId] = true;
1636     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1637     _safeMint(_msgSender(), 1, false);
1638   }
1639 }
1640 
1641 
1642   
1643 /** TimedDrop.sol
1644 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1645 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1646 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1647 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1648 */
1649 abstract contract TimedDrop is Teams {
1650   bool public enforcePublicDropTime = true;
1651   uint256 public publicDropTime = 1669852800;
1652   
1653   /**
1654   * @dev Allow the contract owner to set the public time to mint.
1655   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1656   */
1657   function setPublicDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1658     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disablePublicDropTime!");
1659     publicDropTime = _newDropTime;
1660   }
1661 
1662   function usePublicDropTime() public onlyTeamOrOwner {
1663     enforcePublicDropTime = true;
1664   }
1665 
1666   function disablePublicDropTime() public onlyTeamOrOwner {
1667     enforcePublicDropTime = false;
1668   }
1669 
1670   /**
1671   * @dev determine if the public droptime has passed.
1672   * if the feature is disabled then assume the time has passed.
1673   */
1674   function publicDropTimePassed() public view returns(bool) {
1675     if(enforcePublicDropTime == false) {
1676       return true;
1677     }
1678     return block.timestamp >= publicDropTime;
1679   }
1680   
1681 }
1682 
1683   
1684 interface IERC20 {
1685   function allowance(address owner, address spender) external view returns (uint256);
1686   function transfer(address _to, uint256 _amount) external returns (bool);
1687   function balanceOf(address account) external view returns (uint256);
1688   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1689 }
1690 
1691 // File: WithdrawableV2
1692 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1693 // ERC-20 Payouts are limited to a single payout address. This feature 
1694 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1695 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1696 abstract contract WithdrawableV2 is Teams {
1697   struct acceptedERC20 {
1698     bool isActive;
1699     uint256 chargeAmount;
1700   }
1701 
1702   
1703   mapping(address => acceptedERC20) private allowedTokenContracts;
1704   address[] public payableAddresses = [0xB566C82ba5eb0df25e759afB53384E8249dF6837,0x78f896DBcCa3384966f645ae52628CD2aF519745];
1705   address public erc20Payable = 0xB566C82ba5eb0df25e759afB53384E8249dF6837;
1706   uint256[] public payableFees = [50,50];
1707   uint256 public payableAddressCount = 2;
1708   bool public onlyERC20MintingMode = false;
1709   
1710 
1711   /**
1712   * @dev Calculates the true payable balance of the contract
1713   */
1714   function calcAvailableBalance() public view returns(uint256) {
1715     return address(this).balance;
1716   }
1717 
1718   function withdrawAll() public onlyTeamOrOwner {
1719       require(calcAvailableBalance() > 0);
1720       _withdrawAll();
1721   }
1722 
1723   function _withdrawAll() private {
1724       uint256 balance = calcAvailableBalance();
1725       
1726       for(uint i=0; i < payableAddressCount; i++ ) {
1727           _widthdraw(
1728               payableAddresses[i],
1729               (balance * payableFees[i]) / 100
1730           );
1731       }
1732   }
1733   
1734   function _widthdraw(address _address, uint256 _amount) private {
1735       (bool success, ) = _address.call{value: _amount}("");
1736       require(success, "Transfer failed.");
1737   }
1738 
1739   /**
1740   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1741   * in the event ERC-20 tokens are paid to the contract for mints.
1742   * @param _tokenContract contract of ERC-20 token to withdraw
1743   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1744   */
1745   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1746     require(_amountToWithdraw > 0);
1747     IERC20 tokenContract = IERC20(_tokenContract);
1748     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1749     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1750   }
1751 
1752   /**
1753   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1754   * @param _erc20TokenContract address of ERC-20 contract in question
1755   */
1756   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1757     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1758   }
1759 
1760   /**
1761   * @dev get the value of tokens to transfer for user of an ERC-20
1762   * @param _erc20TokenContract address of ERC-20 contract in question
1763   */
1764   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1765     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1766     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1767   }
1768 
1769   /**
1770   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1771   * @param _erc20TokenContract address of ERC-20 contract in question
1772   * @param _isActive default status of if contract should be allowed to accept payments
1773   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1774   */
1775   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1776     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1777     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1778   }
1779 
1780   /**
1781   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1782   * it will assume the default value of zero. This should not be used to create new payment tokens.
1783   * @param _erc20TokenContract address of ERC-20 contract in question
1784   */
1785   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1786     allowedTokenContracts[_erc20TokenContract].isActive = true;
1787   }
1788 
1789   /**
1790   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1791   * it will assume the default value of zero. This should not be used to create new payment tokens.
1792   * @param _erc20TokenContract address of ERC-20 contract in question
1793   */
1794   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1795     allowedTokenContracts[_erc20TokenContract].isActive = false;
1796   }
1797 
1798   /**
1799   * @dev Enable only ERC-20 payments for minting on this contract
1800   */
1801   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1802     onlyERC20MintingMode = true;
1803   }
1804 
1805   /**
1806   * @dev Disable only ERC-20 payments for minting on this contract
1807   */
1808   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1809     onlyERC20MintingMode = false;
1810   }
1811 
1812   /**
1813   * @dev Set the payout of the ERC-20 token payout to a specific address
1814   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1815   */
1816   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1817     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1818     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1819     erc20Payable = _newErc20Payable;
1820   }
1821 }
1822 
1823 
1824   
1825 // File: isFeeable.sol
1826 abstract contract Feeable is Teams {
1827   uint256 public PRICE = 0 ether;
1828 
1829   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1830     PRICE = _feeInWei;
1831   }
1832 
1833   function getPrice(uint256 _count) public view returns (uint256) {
1834     return PRICE * _count;
1835   }
1836 }
1837 
1838   
1839   
1840   
1841 abstract contract RamppERC721A is 
1842     Ownable,
1843     Teams,
1844     ERC721ARedemption,
1845     WithdrawableV2,
1846     ReentrancyGuard 
1847     , Feeable 
1848      
1849     , TimedDrop
1850 {
1851   constructor(
1852     string memory tokenName,
1853     string memory tokenSymbol
1854   ) ERC721A(tokenName, tokenSymbol, 3, 2500) { }
1855     uint8 public CONTRACT_VERSION = 2;
1856     string public _baseTokenURI = "ipfs://QmcS5S9J5Er9tvSWXNaLkCb5sYt9WsKRXhF6mzSdXFUiTt/";
1857     string public _baseTokenExtension = ".json";
1858 
1859     bool public mintingOpen = false;
1860     
1861     
1862 
1863   
1864     /////////////// Admin Mint Functions
1865     /**
1866      * @dev Mints a token to an address with a tokenURI.
1867      * This is owner only and allows a fee-free drop
1868      * @param _to address of the future owner of the token
1869      * @param _qty amount of tokens to drop the owner
1870      */
1871      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1872          require(_qty > 0, "Must mint at least 1 token.");
1873          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 2500");
1874          _safeMint(_to, _qty, true);
1875      }
1876 
1877   
1878     /////////////// PUBLIC MINT FUNCTIONS
1879     /**
1880     * @dev Mints tokens to an address in batch.
1881     * fee may or may not be required*
1882     * @param _to address of the future owner of the token
1883     * @param _amount number of tokens to mint
1884     */
1885     function mintToMultiple(address _to, uint256 _amount) public payable {
1886         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1887         require(_amount >= 1, "Must mint at least 1 token");
1888         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1889         require(mintingOpen == true, "Minting is not open right now!");
1890         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1891         
1892         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 2500");
1893         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1894 
1895         _safeMint(_to, _amount, false);
1896     }
1897 
1898     /**
1899      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1900      * fee may or may not be required*
1901      * @param _to address of the future owner of the token
1902      * @param _amount number of tokens to mint
1903      * @param _erc20TokenContract erc-20 token contract to mint with
1904      */
1905     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1906       require(_amount >= 1, "Must mint at least 1 token");
1907       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1908       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 2500");
1909       require(mintingOpen == true, "Minting is not open right now!");
1910       require(publicDropTimePassed() == true, "Public drop time has not passed!");
1911       
1912 
1913       // ERC-20 Specific pre-flight checks
1914       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1915       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1916       IERC20 payableToken = IERC20(_erc20TokenContract);
1917 
1918       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1919       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1920 
1921       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1922       require(transferComplete, "ERC-20 token was unable to be transferred");
1923       
1924       _safeMint(_to, _amount, false);
1925     }
1926 
1927     function openMinting() public onlyTeamOrOwner {
1928         mintingOpen = true;
1929     }
1930 
1931     function stopMinting() public onlyTeamOrOwner {
1932         mintingOpen = false;
1933     }
1934 
1935   
1936 
1937   
1938 
1939   
1940     /**
1941      * @dev Allows owner to set Max mints per tx
1942      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1943      */
1944      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1945          require(_newMaxMint >= 1, "Max mint must be at least 1");
1946          maxBatchSize = _newMaxMint;
1947      }
1948     
1949 
1950   
1951 
1952   function _baseURI() internal view virtual override returns(string memory) {
1953     return _baseTokenURI;
1954   }
1955 
1956   function _baseURIExtension() internal view virtual override returns(string memory) {
1957     return _baseTokenExtension;
1958   }
1959 
1960   function baseTokenURI() public view returns(string memory) {
1961     return _baseTokenURI;
1962   }
1963 
1964   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1965     _baseTokenURI = baseURI;
1966   }
1967 
1968   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
1969     _baseTokenExtension = baseExtension;
1970   }
1971 
1972   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1973     return ownershipOf(tokenId);
1974   }
1975 }
1976 
1977 
1978   
1979 // File: contracts/AvatArtWonderfulwomenContract.sol
1980 //SPDX-License-Identifier: MIT
1981 
1982 pragma solidity ^0.8.0;
1983 
1984 contract AvatArtWonderfulwomenContract is RamppERC721A {
1985     constructor() RamppERC721A("AvatArt WONDERFUL WOMEN", "AWW"){}
1986 }
1987   
1988 //*********************************************************************//
1989 //*********************************************************************//  
1990 //                       Mintplex v3.0.0
1991 //
1992 //         This smart contract was generated by mintplex.xyz.
1993 //            Mintplex allows creators like you to launch 
1994 //             large scale NFT communities without code!
1995 //
1996 //    Mintplex is not responsible for the content of this contract and
1997 //        hopes it is being used in a responsible and kind way.  
1998 //       Mintplex is not associated or affiliated with this project.                                                    
1999 //             Twitter: @MintplexNFT ---- mintplex.xyz
2000 //*********************************************************************//                                                     
2001 //*********************************************************************// 
