1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //    ___           __  ______   ________       ______  __ 
5 //   / _ )___ _____/ /_/_  __/__/_  __/ /  ___ / __/ /_/ / 
6 //  / _  / _ `/ __/  '_// / / _ \/ / / _ \/ -_) _// __/ _ \
7 // /____/\_,_/\__/_/\_\/_/  \___/_/ /_//_/\__/___/\__/_//_/
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
739     function _onlyOwner() private view {
740        require(owner() == _msgSender(), "Ownable: caller is not the owner");
741     }
742 
743     modifier onlyOwner() {
744         _onlyOwner();
745         _;
746     }
747 
748     /**
749      * @dev Leaves the contract without owner. It will not be possible to call
750      * onlyOwner functions anymore. Can only be called by the current owner.
751      *
752      * NOTE: Renouncing ownership will leave the contract without an owner,
753      * thereby removing any functionality that is only available to the owner.
754      */
755     function renounceOwnership() public virtual onlyOwner {
756         _transferOwnership(address(0));
757     }
758 
759     /**
760      * @dev Transfers ownership of the contract to a new account (newOwner).
761      * Can only be called by the current owner.
762      */
763     function transferOwnership(address newOwner) public virtual onlyOwner {
764         require(newOwner != address(0), "Ownable: new owner is the zero address");
765         _transferOwnership(newOwner);
766     }
767 
768     /**
769      * @dev Transfers ownership of the contract to a new account (newOwner).
770      * Internal function without access restriction.
771      */
772     function _transferOwnership(address newOwner) internal virtual {
773         address oldOwner = _owner;
774         _owner = newOwner;
775         emit OwnershipTransferred(oldOwner, newOwner);
776     }
777 }
778 
779 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
780 pragma solidity ^0.8.9;
781 
782 interface IOperatorFilterRegistry {
783     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
784     function register(address registrant) external;
785     function registerAndSubscribe(address registrant, address subscription) external;
786     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
787     function updateOperator(address registrant, address operator, bool filtered) external;
788     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
789     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
790     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
791     function subscribe(address registrant, address registrantToSubscribe) external;
792     function unsubscribe(address registrant, bool copyExistingEntries) external;
793     function subscriptionOf(address addr) external returns (address registrant);
794     function subscribers(address registrant) external returns (address[] memory);
795     function subscriberAt(address registrant, uint256 index) external returns (address);
796     function copyEntriesOf(address registrant, address registrantToCopy) external;
797     function isOperatorFiltered(address registrant, address operator) external returns (bool);
798     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
799     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
800     function filteredOperators(address addr) external returns (address[] memory);
801     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
802     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
803     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
804     function isRegistered(address addr) external returns (bool);
805     function codeHashOf(address addr) external returns (bytes32);
806 }
807 
808 // File contracts/OperatorFilter/OperatorFilterer.sol
809 pragma solidity ^0.8.9;
810 
811 abstract contract OperatorFilterer {
812     error OperatorNotAllowed(address operator);
813 
814     IOperatorFilterRegistry constant operatorFilterRegistry =
815         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
816 
817     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
818         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
819         // will not revert, but the contract will need to be registered with the registry once it is deployed in
820         // order for the modifier to filter addresses.
821         if (address(operatorFilterRegistry).code.length > 0) {
822             if (subscribe) {
823                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
824             } else {
825                 if (subscriptionOrRegistrantToCopy != address(0)) {
826                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
827                 } else {
828                     operatorFilterRegistry.register(address(this));
829                 }
830             }
831         }
832     }
833 
834     function _onlyAllowedOperator(address from) private view {
835       if (
836           !(
837               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
838               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
839           )
840       ) {
841           revert OperatorNotAllowed(msg.sender);
842       }
843     }
844 
845     modifier onlyAllowedOperator(address from) virtual {
846         // Check registry code length to facilitate testing in environments without a deployed registry.
847         if (address(operatorFilterRegistry).code.length > 0) {
848             // Allow spending tokens from addresses with balance
849             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
850             // from an EOA.
851             if (from == msg.sender) {
852                 _;
853                 return;
854             }
855             _onlyAllowedOperator(from);
856         }
857         _;
858     }
859 
860     modifier onlyAllowedOperatorApproval(address operator) virtual {
861         _checkFilterOperator(operator);
862         _;
863     }
864 
865     function _checkFilterOperator(address operator) internal view virtual {
866         // Check registry code length to facilitate testing in environments without a deployed registry.
867         if (address(operatorFilterRegistry).code.length > 0) {
868             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
869                 revert OperatorNotAllowed(operator);
870             }
871         }
872     }
873 }
874 
875 //-------------END DEPENDENCIES------------------------//
876 
877 
878   
879 error TransactionCapExceeded();
880 error PublicMintingClosed();
881 error ExcessiveOwnedMints();
882 error MintZeroQuantity();
883 error InvalidPayment();
884 error CapExceeded();
885 error IsAlreadyUnveiled();
886 error ValueCannotBeZero();
887 error CannotBeNullAddress();
888 error NoStateChange();
889 
890 error PublicMintClosed();
891 error AllowlistMintClosed();
892 
893 error AddressNotAllowlisted();
894 error AllowlistDropTimeHasNotPassed();
895 error PublicDropTimeHasNotPassed();
896 error DropTimeNotInFuture();
897 
898 error OnlyERC20MintingEnabled();
899 error ERC20TokenNotApproved();
900 error ERC20InsufficientBalance();
901 error ERC20InsufficientAllowance();
902 error ERC20TransferFailed();
903 
904 error ClaimModeDisabled();
905 error IneligibleRedemptionContract();
906 error TokenAlreadyRedeemed();
907 error InvalidOwnerForRedemption();
908 error InvalidApprovalForRedemption();
909 
910 error ERC721RestrictedApprovalAddressRestricted();
911 error NotMaintainer();
912   
913   
914 // Rampp Contracts v2.1 (Teams.sol)
915 
916 error InvalidTeamAddress();
917 error DuplicateTeamAddress();
918 pragma solidity ^0.8.0;
919 
920 /**
921 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
922 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
923 * This will easily allow cross-collaboration via Mintplex.xyz.
924 **/
925 abstract contract Teams is Ownable{
926   mapping (address => bool) internal team;
927 
928   /**
929   * @dev Adds an address to the team. Allows them to execute protected functions
930   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
931   **/
932   function addToTeam(address _address) public onlyOwner {
933     if(_address == address(0)) revert InvalidTeamAddress();
934     if(inTeam(_address)) revert DuplicateTeamAddress();
935   
936     team[_address] = true;
937   }
938 
939   /**
940   * @dev Removes an address to the team.
941   * @param _address the ETH address to remove, cannot be 0x and must be in team
942   **/
943   function removeFromTeam(address _address) public onlyOwner {
944     if(_address == address(0)) revert InvalidTeamAddress();
945     if(!inTeam(_address)) revert InvalidTeamAddress();
946   
947     team[_address] = false;
948   }
949 
950   /**
951   * @dev Check if an address is valid and active in the team
952   * @param _address ETH address to check for truthiness
953   **/
954   function inTeam(address _address)
955     public
956     view
957     returns (bool)
958   {
959     if(_address == address(0)) revert InvalidTeamAddress();
960     return team[_address] == true;
961   }
962 
963   /**
964   * @dev Throws if called by any account other than the owner or team member.
965   */
966   function _onlyTeamOrOwner() private view {
967     bool _isOwner = owner() == _msgSender();
968     bool _isTeam = inTeam(_msgSender());
969     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
970   }
971 
972   modifier onlyTeamOrOwner() {
973     _onlyTeamOrOwner();
974     _;
975   }
976 }
977 
978 
979   
980   pragma solidity ^0.8.0;
981 
982   /**
983   * @dev These functions deal with verification of Merkle Trees proofs.
984   *
985   * The proofs can be generated using the JavaScript library
986   * https://github.com/miguelmota/merkletreejs[merkletreejs].
987   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
988   *
989   *
990   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
991   * hashing, or use a hash function other than keccak256 for hashing leaves.
992   * This is because the concatenation of a sorted pair of internal nodes in
993   * the merkle tree could be reinterpreted as a leaf value.
994   */
995   library MerkleProof {
996       /**
997       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
998       * defined by 'root'. For this, a 'proof' must be provided, containing
999       * sibling hashes on the branch from the leaf to the root of the tree. Each
1000       * pair of leaves and each pair of pre-images are assumed to be sorted.
1001       */
1002       function verify(
1003           bytes32[] memory proof,
1004           bytes32 root,
1005           bytes32 leaf
1006       ) internal pure returns (bool) {
1007           return processProof(proof, leaf) == root;
1008       }
1009 
1010       /**
1011       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1012       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1013       * hash matches the root of the tree. When processing the proof, the pairs
1014       * of leafs & pre-images are assumed to be sorted.
1015       *
1016       * _Available since v4.4._
1017       */
1018       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1019           bytes32 computedHash = leaf;
1020           for (uint256 i = 0; i < proof.length; i++) {
1021               bytes32 proofElement = proof[i];
1022               if (computedHash <= proofElement) {
1023                   // Hash(current computed hash + current element of the proof)
1024                   computedHash = _efficientHash(computedHash, proofElement);
1025               } else {
1026                   // Hash(current element of the proof + current computed hash)
1027                   computedHash = _efficientHash(proofElement, computedHash);
1028               }
1029           }
1030           return computedHash;
1031       }
1032 
1033       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1034           assembly {
1035               mstore(0x00, a)
1036               mstore(0x20, b)
1037               value := keccak256(0x00, 0x40)
1038           }
1039       }
1040   }
1041 
1042 
1043   // File: Allowlist.sol
1044 
1045   pragma solidity ^0.8.0;
1046 
1047   abstract contract Allowlist is Teams {
1048     bytes32 public merkleRoot;
1049     bool public onlyAllowlistMode = false;
1050 
1051     /**
1052      * @dev Update merkle root to reflect changes in Allowlist
1053      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1054      */
1055     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1056       if(_newMerkleRoot == merkleRoot) revert NoStateChange();
1057       merkleRoot = _newMerkleRoot;
1058     }
1059 
1060     /**
1061      * @dev Check the proof of an address if valid for merkle root
1062      * @param _to address to check for proof
1063      * @param _merkleProof Proof of the address to validate against root and leaf
1064      */
1065     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1066       if(merkleRoot == 0) revert ValueCannotBeZero();
1067       bytes32 leaf = keccak256(abi.encodePacked(_to));
1068 
1069       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1070     }
1071 
1072     
1073     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1074       onlyAllowlistMode = true;
1075     }
1076 
1077     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1078         onlyAllowlistMode = false;
1079     }
1080   }
1081   
1082   
1083 /**
1084  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1085  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1086  *
1087  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1088  * 
1089  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1090  *
1091  * Does not support burning tokens to address(0).
1092  */
1093 contract ERC721A is
1094   Context,
1095   ERC165,
1096   IERC721,
1097   IERC721Metadata,
1098   IERC721Enumerable,
1099   Teams
1100   , OperatorFilterer
1101 {
1102   using Address for address;
1103   using Strings for uint256;
1104 
1105   struct TokenOwnership {
1106     address addr;
1107     uint64 startTimestamp;
1108   }
1109 
1110   struct AddressData {
1111     uint128 balance;
1112     uint128 numberMinted;
1113   }
1114 
1115   uint256 private currentIndex;
1116 
1117   uint256 public immutable collectionSize;
1118   uint256 public maxBatchSize;
1119 
1120   // Token name
1121   string private _name;
1122 
1123   // Token symbol
1124   string private _symbol;
1125 
1126   // Mapping from token ID to ownership details
1127   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1128   mapping(uint256 => TokenOwnership) private _ownerships;
1129 
1130   // Mapping owner address to address data
1131   mapping(address => AddressData) private _addressData;
1132 
1133   // Mapping from token ID to approved address
1134   mapping(uint256 => address) private _tokenApprovals;
1135 
1136   // Mapping from owner to operator approvals
1137   mapping(address => mapping(address => bool)) private _operatorApprovals;
1138 
1139   /* @dev Mapping of restricted operator approvals set by contract Owner
1140   * This serves as an optional addition to ERC-721 so
1141   * that the contract owner can elect to prevent specific addresses/contracts
1142   * from being marked as the approver for a token. The reason for this
1143   * is that some projects may want to retain control of where their tokens can/can not be listed
1144   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1145   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1146   */
1147   mapping(address => bool) public restrictedApprovalAddresses;
1148 
1149   /**
1150    * @dev
1151    * maxBatchSize refers to how much a minter can mint at a time.
1152    * collectionSize_ refers to how many tokens are in the collection.
1153    */
1154   constructor(
1155     string memory name_,
1156     string memory symbol_,
1157     uint256 maxBatchSize_,
1158     uint256 collectionSize_
1159   ) OperatorFilterer(address(0), false) {
1160     require(
1161       collectionSize_ > 0,
1162       "ERC721A: collection must have a nonzero supply"
1163     );
1164     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1165     _name = name_;
1166     _symbol = symbol_;
1167     maxBatchSize = maxBatchSize_;
1168     collectionSize = collectionSize_;
1169     currentIndex = _startTokenId();
1170   }
1171 
1172   /**
1173   * To change the starting tokenId, please override this function.
1174   */
1175   function _startTokenId() internal view virtual returns (uint256) {
1176     return 1;
1177   }
1178 
1179   /**
1180    * @dev See {IERC721Enumerable-totalSupply}.
1181    */
1182   function totalSupply() public view override returns (uint256) {
1183     return _totalMinted();
1184   }
1185 
1186   function currentTokenId() public view returns (uint256) {
1187     return _totalMinted();
1188   }
1189 
1190   function getNextTokenId() public view returns (uint256) {
1191       return _totalMinted() + 1;
1192   }
1193 
1194   /**
1195   * Returns the total amount of tokens minted in the contract.
1196   */
1197   function _totalMinted() internal view returns (uint256) {
1198     unchecked {
1199       return currentIndex - _startTokenId();
1200     }
1201   }
1202 
1203   /**
1204    * @dev See {IERC721Enumerable-tokenByIndex}.
1205    */
1206   function tokenByIndex(uint256 index) public view override returns (uint256) {
1207     require(index < totalSupply(), "ERC721A: global index out of bounds");
1208     return index;
1209   }
1210 
1211   /**
1212    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1213    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1214    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1215    */
1216   function tokenOfOwnerByIndex(address owner, uint256 index)
1217     public
1218     view
1219     override
1220     returns (uint256)
1221   {
1222     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1223     uint256 numMintedSoFar = totalSupply();
1224     uint256 tokenIdsIdx = 0;
1225     address currOwnershipAddr = address(0);
1226     for (uint256 i = 0; i < numMintedSoFar; i++) {
1227       TokenOwnership memory ownership = _ownerships[i];
1228       if (ownership.addr != address(0)) {
1229         currOwnershipAddr = ownership.addr;
1230       }
1231       if (currOwnershipAddr == owner) {
1232         if (tokenIdsIdx == index) {
1233           return i;
1234         }
1235         tokenIdsIdx++;
1236       }
1237     }
1238     revert("ERC721A: unable to get token of owner by index");
1239   }
1240 
1241   /**
1242    * @dev See {IERC165-supportsInterface}.
1243    */
1244   function supportsInterface(bytes4 interfaceId)
1245     public
1246     view
1247     virtual
1248     override(ERC165, IERC165)
1249     returns (bool)
1250   {
1251     return
1252       interfaceId == type(IERC721).interfaceId ||
1253       interfaceId == type(IERC721Metadata).interfaceId ||
1254       interfaceId == type(IERC721Enumerable).interfaceId ||
1255       super.supportsInterface(interfaceId);
1256   }
1257 
1258   /**
1259    * @dev See {IERC721-balanceOf}.
1260    */
1261   function balanceOf(address owner) public view override returns (uint256) {
1262     require(owner != address(0), "ERC721A: balance query for the zero address");
1263     return uint256(_addressData[owner].balance);
1264   }
1265 
1266   function _numberMinted(address owner) internal view returns (uint256) {
1267     require(
1268       owner != address(0),
1269       "ERC721A: number minted query for the zero address"
1270     );
1271     return uint256(_addressData[owner].numberMinted);
1272   }
1273 
1274   function ownershipOf(uint256 tokenId)
1275     internal
1276     view
1277     returns (TokenOwnership memory)
1278   {
1279     uint256 curr = tokenId;
1280 
1281     unchecked {
1282         if (_startTokenId() <= curr && curr < currentIndex) {
1283             TokenOwnership memory ownership = _ownerships[curr];
1284             if (ownership.addr != address(0)) {
1285                 return ownership;
1286             }
1287 
1288             // Invariant:
1289             // There will always be an ownership that has an address and is not burned
1290             // before an ownership that does not have an address and is not burned.
1291             // Hence, curr will not underflow.
1292             while (true) {
1293                 curr--;
1294                 ownership = _ownerships[curr];
1295                 if (ownership.addr != address(0)) {
1296                     return ownership;
1297                 }
1298             }
1299         }
1300     }
1301 
1302     revert("ERC721A: unable to determine the owner of token");
1303   }
1304 
1305   /**
1306    * @dev See {IERC721-ownerOf}.
1307    */
1308   function ownerOf(uint256 tokenId) public view override returns (address) {
1309     return ownershipOf(tokenId).addr;
1310   }
1311 
1312   /**
1313    * @dev See {IERC721Metadata-name}.
1314    */
1315   function name() public view virtual override returns (string memory) {
1316     return _name;
1317   }
1318 
1319   /**
1320    * @dev See {IERC721Metadata-symbol}.
1321    */
1322   function symbol() public view virtual override returns (string memory) {
1323     return _symbol;
1324   }
1325 
1326   /**
1327    * @dev See {IERC721Metadata-tokenURI}.
1328    */
1329   function tokenURI(uint256 tokenId)
1330     public
1331     view
1332     virtual
1333     override
1334     returns (string memory)
1335   {
1336     string memory baseURI = _baseURI();
1337     string memory extension = _baseURIExtension();
1338     return
1339       bytes(baseURI).length > 0
1340         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1341         : "";
1342   }
1343 
1344   /**
1345    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1346    * token will be the concatenation of the baseURI and the tokenId. Empty
1347    * by default, can be overriden in child contracts.
1348    */
1349   function _baseURI() internal view virtual returns (string memory) {
1350     return "";
1351   }
1352 
1353   /**
1354    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1355    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1356    * by default, can be overriden in child contracts.
1357    */
1358   function _baseURIExtension() internal view virtual returns (string memory) {
1359     return "";
1360   }
1361 
1362   /**
1363    * @dev Sets the value for an address to be in the restricted approval address pool.
1364    * Setting an address to true will disable token owners from being able to mark the address
1365    * for approval for trading. This would be used in theory to prevent token owners from listing
1366    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1367    * @param _address the marketplace/user to modify restriction status of
1368    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1369    */
1370   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1371     restrictedApprovalAddresses[_address] = _isRestricted;
1372   }
1373 
1374   /**
1375    * @dev See {IERC721-approve}.
1376    */
1377   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1378     address owner = ERC721A.ownerOf(tokenId);
1379     require(to != owner, "ERC721A: approval to current owner");
1380     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1381 
1382     require(
1383       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1384       "ERC721A: approve caller is not owner nor approved for all"
1385     );
1386 
1387     _approve(to, tokenId, owner);
1388   }
1389 
1390   /**
1391    * @dev See {IERC721-getApproved}.
1392    */
1393   function getApproved(uint256 tokenId) public view override returns (address) {
1394     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1395 
1396     return _tokenApprovals[tokenId];
1397   }
1398 
1399   /**
1400    * @dev See {IERC721-setApprovalForAll}.
1401    */
1402   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1403     require(operator != _msgSender(), "ERC721A: approve to caller");
1404     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1405 
1406     _operatorApprovals[_msgSender()][operator] = approved;
1407     emit ApprovalForAll(_msgSender(), operator, approved);
1408   }
1409 
1410   /**
1411    * @dev See {IERC721-isApprovedForAll}.
1412    */
1413   function isApprovedForAll(address owner, address operator)
1414     public
1415     view
1416     virtual
1417     override
1418     returns (bool)
1419   {
1420     return _operatorApprovals[owner][operator];
1421   }
1422 
1423   /**
1424    * @dev See {IERC721-transferFrom}.
1425    */
1426   function transferFrom(
1427     address from,
1428     address to,
1429     uint256 tokenId
1430   ) public override onlyAllowedOperator(from) {
1431     _transfer(from, to, tokenId);
1432   }
1433 
1434   /**
1435    * @dev See {IERC721-safeTransferFrom}.
1436    */
1437   function safeTransferFrom(
1438     address from,
1439     address to,
1440     uint256 tokenId
1441   ) public override onlyAllowedOperator(from) {
1442     safeTransferFrom(from, to, tokenId, "");
1443   }
1444 
1445   /**
1446    * @dev See {IERC721-safeTransferFrom}.
1447    */
1448   function safeTransferFrom(
1449     address from,
1450     address to,
1451     uint256 tokenId,
1452     bytes memory _data
1453   ) public override onlyAllowedOperator(from) {
1454     _transfer(from, to, tokenId);
1455     require(
1456       _checkOnERC721Received(from, to, tokenId, _data),
1457       "ERC721A: transfer to non ERC721Receiver implementer"
1458     );
1459   }
1460 
1461   /**
1462    * @dev Returns whether tokenId exists.
1463    *
1464    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1465    *
1466    * Tokens start existing when they are minted (_mint),
1467    */
1468   function _exists(uint256 tokenId) internal view returns (bool) {
1469     return _startTokenId() <= tokenId && tokenId < currentIndex;
1470   }
1471 
1472   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1473     _safeMint(to, quantity, isAdminMint, "");
1474   }
1475 
1476   /**
1477    * @dev Mints quantity tokens and transfers them to to.
1478    *
1479    * Requirements:
1480    *
1481    * - there must be quantity tokens remaining unminted in the total collection.
1482    * - to cannot be the zero address.
1483    * - quantity cannot be larger than the max batch size.
1484    *
1485    * Emits a {Transfer} event.
1486    */
1487   function _safeMint(
1488     address to,
1489     uint256 quantity,
1490     bool isAdminMint,
1491     bytes memory _data
1492   ) internal {
1493     uint256 startTokenId = currentIndex;
1494     require(to != address(0), "ERC721A: mint to the zero address");
1495     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1496     require(!_exists(startTokenId), "ERC721A: token already minted");
1497 
1498     // For admin mints we do not want to enforce the maxBatchSize limit
1499     if (isAdminMint == false) {
1500         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1501     }
1502 
1503     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1504 
1505     AddressData memory addressData = _addressData[to];
1506     _addressData[to] = AddressData(
1507       addressData.balance + uint128(quantity),
1508       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1509     );
1510     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1511 
1512     uint256 updatedIndex = startTokenId;
1513 
1514     for (uint256 i = 0; i < quantity; i++) {
1515       emit Transfer(address(0), to, updatedIndex);
1516       require(
1517         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1518         "ERC721A: transfer to non ERC721Receiver implementer"
1519       );
1520       updatedIndex++;
1521     }
1522 
1523     currentIndex = updatedIndex;
1524     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1525   }
1526 
1527   /**
1528    * @dev Transfers tokenId from from to to.
1529    *
1530    * Requirements:
1531    *
1532    * - to cannot be the zero address.
1533    * - tokenId token must be owned by from.
1534    *
1535    * Emits a {Transfer} event.
1536    */
1537   function _transfer(
1538     address from,
1539     address to,
1540     uint256 tokenId
1541   ) private {
1542     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1543 
1544     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1545       getApproved(tokenId) == _msgSender() ||
1546       isApprovedForAll(prevOwnership.addr, _msgSender()));
1547 
1548     require(
1549       isApprovedOrOwner,
1550       "ERC721A: transfer caller is not owner nor approved"
1551     );
1552 
1553     require(
1554       prevOwnership.addr == from,
1555       "ERC721A: transfer from incorrect owner"
1556     );
1557     require(to != address(0), "ERC721A: transfer to the zero address");
1558 
1559     _beforeTokenTransfers(from, to, tokenId, 1);
1560 
1561     // Clear approvals from the previous owner
1562     _approve(address(0), tokenId, prevOwnership.addr);
1563 
1564     _addressData[from].balance -= 1;
1565     _addressData[to].balance += 1;
1566     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1567 
1568     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1569     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1570     uint256 nextTokenId = tokenId + 1;
1571     if (_ownerships[nextTokenId].addr == address(0)) {
1572       if (_exists(nextTokenId)) {
1573         _ownerships[nextTokenId] = TokenOwnership(
1574           prevOwnership.addr,
1575           prevOwnership.startTimestamp
1576         );
1577       }
1578     }
1579 
1580     emit Transfer(from, to, tokenId);
1581     _afterTokenTransfers(from, to, tokenId, 1);
1582   }
1583 
1584   /**
1585    * @dev Approve to to operate on tokenId
1586    *
1587    * Emits a {Approval} event.
1588    */
1589   function _approve(
1590     address to,
1591     uint256 tokenId,
1592     address owner
1593   ) private {
1594     _tokenApprovals[tokenId] = to;
1595     emit Approval(owner, to, tokenId);
1596   }
1597 
1598   uint256 public nextOwnerToExplicitlySet = 0;
1599 
1600   /**
1601    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1602    */
1603   function _setOwnersExplicit(uint256 quantity) internal {
1604     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1605     require(quantity > 0, "quantity must be nonzero");
1606     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1607 
1608     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1609     if (endIndex > collectionSize - 1) {
1610       endIndex = collectionSize - 1;
1611     }
1612     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1613     require(_exists(endIndex), "not enough minted yet for this cleanup");
1614     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1615       if (_ownerships[i].addr == address(0)) {
1616         TokenOwnership memory ownership = ownershipOf(i);
1617         _ownerships[i] = TokenOwnership(
1618           ownership.addr,
1619           ownership.startTimestamp
1620         );
1621       }
1622     }
1623     nextOwnerToExplicitlySet = endIndex + 1;
1624   }
1625 
1626   /**
1627    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1628    * The call is not executed if the target address is not a contract.
1629    *
1630    * @param from address representing the previous owner of the given token ID
1631    * @param to target address that will receive the tokens
1632    * @param tokenId uint256 ID of the token to be transferred
1633    * @param _data bytes optional data to send along with the call
1634    * @return bool whether the call correctly returned the expected magic value
1635    */
1636   function _checkOnERC721Received(
1637     address from,
1638     address to,
1639     uint256 tokenId,
1640     bytes memory _data
1641   ) private returns (bool) {
1642     if (to.isContract()) {
1643       try
1644         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1645       returns (bytes4 retval) {
1646         return retval == IERC721Receiver(to).onERC721Received.selector;
1647       } catch (bytes memory reason) {
1648         if (reason.length == 0) {
1649           revert("ERC721A: transfer to non ERC721Receiver implementer");
1650         } else {
1651           assembly {
1652             revert(add(32, reason), mload(reason))
1653           }
1654         }
1655       }
1656     } else {
1657       return true;
1658     }
1659   }
1660 
1661   /**
1662    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1663    *
1664    * startTokenId - the first token id to be transferred
1665    * quantity - the amount to be transferred
1666    *
1667    * Calling conditions:
1668    *
1669    * - When from and to are both non-zero, from's tokenId will be
1670    * transferred to to.
1671    * - When from is zero, tokenId will be minted for to.
1672    */
1673   function _beforeTokenTransfers(
1674     address from,
1675     address to,
1676     uint256 startTokenId,
1677     uint256 quantity
1678   ) internal virtual {}
1679 
1680   /**
1681    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1682    * minting.
1683    *
1684    * startTokenId - the first token id to be transferred
1685    * quantity - the amount to be transferred
1686    *
1687    * Calling conditions:
1688    *
1689    * - when from and to are both non-zero.
1690    * - from and to are never both zero.
1691    */
1692   function _afterTokenTransfers(
1693     address from,
1694     address to,
1695     uint256 startTokenId,
1696     uint256 quantity
1697   ) internal virtual {}
1698 }
1699 
1700 abstract contract ProviderFees is Context {
1701   address private constant PROVIDER = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1702   uint256 public PROVIDER_FEE = 0.000777 ether;  
1703 
1704   function sendProviderFee() internal {
1705     payable(PROVIDER).transfer(PROVIDER_FEE);
1706   }
1707 
1708   function setProviderFee(uint256 _fee) public {
1709     if(_msgSender() != PROVIDER) revert NotMaintainer();
1710     PROVIDER_FEE = _fee;
1711   }
1712 }
1713 
1714 
1715 
1716   
1717   
1718 interface IERC20 {
1719   function allowance(address owner, address spender) external view returns (uint256);
1720   function transfer(address _to, uint256 _amount) external returns (bool);
1721   function balanceOf(address account) external view returns (uint256);
1722   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1723 }
1724 
1725 // File: WithdrawableV2
1726 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1727 // ERC-20 Payouts are limited to a single payout address. This feature 
1728 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1729 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1730 abstract contract WithdrawableV2 is Teams {
1731   struct acceptedERC20 {
1732     bool isActive;
1733     uint256 chargeAmount;
1734   }
1735 
1736   
1737   mapping(address => acceptedERC20) private allowedTokenContracts;
1738   address[] public payableAddresses = [0x18f98b6be2D3B8931dbF6Db884Ce2A6AbdE7B9De];
1739   address public erc20Payable = 0x18f98b6be2D3B8931dbF6Db884Ce2A6AbdE7B9De;
1740   uint256[] public payableFees = [100];
1741   uint256 public payableAddressCount = 1;
1742   bool public onlyERC20MintingMode;
1743   
1744 
1745   function withdrawAll() public onlyTeamOrOwner {
1746       if(address(this).balance == 0) revert ValueCannotBeZero();
1747       _withdrawAll(address(this).balance);
1748   }
1749 
1750   function _withdrawAll(uint256 balance) private {
1751       for(uint i=0; i < payableAddressCount; i++ ) {
1752           _widthdraw(
1753               payableAddresses[i],
1754               (balance * payableFees[i]) / 100
1755           );
1756       }
1757   }
1758   
1759   function _widthdraw(address _address, uint256 _amount) private {
1760       (bool success, ) = _address.call{value: _amount}("");
1761       require(success, "Transfer failed.");
1762   }
1763 
1764   /**
1765   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1766   * in the event ERC-20 tokens are paid to the contract for mints.
1767   * @param _tokenContract contract of ERC-20 token to withdraw
1768   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1769   */
1770   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1771     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1772     IERC20 tokenContract = IERC20(_tokenContract);
1773     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1774     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1775   }
1776 
1777   /**
1778   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1779   * @param _erc20TokenContract address of ERC-20 contract in question
1780   */
1781   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1782     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1783   }
1784 
1785   /**
1786   * @dev get the value of tokens to transfer for user of an ERC-20
1787   * @param _erc20TokenContract address of ERC-20 contract in question
1788   */
1789   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1790     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1791     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1792   }
1793 
1794   /**
1795   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1796   * @param _erc20TokenContract address of ERC-20 contract in question
1797   * @param _isActive default status of if contract should be allowed to accept payments
1798   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1799   */
1800   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1801     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1802     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1803   }
1804 
1805   /**
1806   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1807   * it will assume the default value of zero. This should not be used to create new payment tokens.
1808   * @param _erc20TokenContract address of ERC-20 contract in question
1809   */
1810   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1811     allowedTokenContracts[_erc20TokenContract].isActive = true;
1812   }
1813 
1814   /**
1815   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1816   * it will assume the default value of zero. This should not be used to create new payment tokens.
1817   * @param _erc20TokenContract address of ERC-20 contract in question
1818   */
1819   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1820     allowedTokenContracts[_erc20TokenContract].isActive = false;
1821   }
1822 
1823   /**
1824   * @dev Enable only ERC-20 payments for minting on this contract
1825   */
1826   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1827     onlyERC20MintingMode = true;
1828   }
1829 
1830   /**
1831   * @dev Disable only ERC-20 payments for minting on this contract
1832   */
1833   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1834     onlyERC20MintingMode = false;
1835   }
1836 
1837   /**
1838   * @dev Set the payout of the ERC-20 token payout to a specific address
1839   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1840   */
1841   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1842     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1843     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1844     erc20Payable = _newErc20Payable;
1845   }
1846 }
1847 
1848 
1849   
1850   
1851 /* File: Tippable.sol
1852 /* @dev Allows owner to set strict enforcement of payment to mint price.
1853 /* Would then allow buyers to pay _more_ than the mint fee - consider it as a tip
1854 /* when doing a free mint with opt-in pricing.
1855 /* When strict pricing is enabled => msg.value must extactly equal the expected value
1856 /* when strict pricing is disabled => msg.value must be _at least_ the expected value.
1857 /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1858 /* Pros - can take in gratituity payments during a mint. 
1859 /* Cons - However if you decrease pricing during mint txn settlement 
1860 /* it can result in mints landing who technically now have overpaid.
1861 */
1862 abstract contract Tippable is Teams {
1863   bool public strictPricing = true;
1864 
1865   function setStrictPricing(bool _newStatus) public onlyTeamOrOwner {
1866     strictPricing = _newStatus;
1867   }
1868 
1869   // @dev check if msg.value is correct according to pricing enforcement
1870   // @param _msgValue -> passed in msg.value of tx
1871   // @param _expectedPrice -> result of getPrice(...args)
1872   function priceIsRight(uint256 _msgValue, uint256 _expectedPrice) internal view returns (bool) {
1873     return strictPricing ? 
1874       _msgValue == _expectedPrice : 
1875       _msgValue >= _expectedPrice;
1876   }
1877 }
1878 
1879   
1880   
1881 // File: EarlyMintIncentive.sol
1882 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1883 // zero fee that can be calculated on the fly.
1884 abstract contract EarlyMintIncentive is Teams, ERC721A, ProviderFees {
1885   uint256 public PRICE = 0.002 ether;
1886   uint256 public EARLY_MINT_PRICE = 0 ether;
1887   uint256 public earlyMintOwnershipCap = 1;
1888   bool public usingEarlyMintIncentive = true;
1889 
1890   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1891     usingEarlyMintIncentive = true;
1892   }
1893 
1894   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1895     usingEarlyMintIncentive = false;
1896   }
1897 
1898   /**
1899   * @dev Set the max token ID in which the cost incentive will be applied.
1900   * @param _newCap max number of tokens wallet may mint for incentive price
1901   */
1902   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1903     if(_newCap == 0) revert ValueCannotBeZero();
1904     earlyMintOwnershipCap = _newCap;
1905   }
1906 
1907   /**
1908   * @dev Set the incentive mint price
1909   * @param _feeInWei new price per token when in incentive range
1910   */
1911   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1912     EARLY_MINT_PRICE = _feeInWei;
1913   }
1914 
1915   /**
1916   * @dev Set the primary mint price - the base price when not under incentive
1917   * @param _feeInWei new price per token
1918   */
1919   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1920     PRICE = _feeInWei;
1921   }
1922 
1923   /**
1924   * @dev Get the correct price for the mint for qty and person minting
1925   * @param _count amount of tokens to calc for mint
1926   * @param _to the address which will be minting these tokens, passed explicitly
1927   */
1928   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1929     if(_count == 0) revert ValueCannotBeZero();
1930 
1931     // short circuit function if we dont need to even calc incentive pricing
1932     // short circuit if the current wallet mint qty is also already over cap
1933     if(
1934       usingEarlyMintIncentive == false ||
1935       _numberMinted(_to) > earlyMintOwnershipCap
1936     ) {
1937       return (PRICE * _count) + PROVIDER_FEE;
1938     }
1939 
1940     uint256 endingTokenQty = _numberMinted(_to) + _count;
1941     // If qty to mint results in a final qty less than or equal to the cap then
1942     // the entire qty is within incentive mint.
1943     if(endingTokenQty  <= earlyMintOwnershipCap) {
1944       return (EARLY_MINT_PRICE * _count) + PROVIDER_FEE;
1945     }
1946 
1947     // If the current token qty is less than the incentive cap
1948     // and the ending token qty is greater than the incentive cap
1949     // we will be straddling the cap so there will be some amount
1950     // that are incentive and some that are regular fee.
1951     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1952     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1953 
1954     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount) + PROVIDER_FEE;
1955   }
1956 }
1957 
1958   
1959 abstract contract ERC721APlus is 
1960     Ownable,
1961     Teams,
1962     ERC721A,
1963     WithdrawableV2,
1964     ReentrancyGuard 
1965     , EarlyMintIncentive, Tippable 
1966     , Allowlist 
1967     
1968 {
1969   constructor(
1970     string memory tokenName,
1971     string memory tokenSymbol
1972   ) ERC721A(tokenName, tokenSymbol, 10, 7777) { }
1973     uint8 constant public CONTRACT_VERSION = 2;
1974     string public _baseTokenURI = "ipfs://Qmcj6d6q5r8zKuZDhHo9iBFpPV5Fxi1f1QTa1iwrmDAnG4/";
1975     string public _baseTokenExtension = ".json";
1976 
1977     bool public mintingOpen = false;
1978     
1979     
1980     uint256 public MAX_WALLET_MINTS = 20;
1981 
1982   
1983     /////////////// Admin Mint Functions
1984     /**
1985      * @dev Mints a token to an address with a tokenURI.
1986      * This is owner only and allows a fee-free drop
1987      * @param _to address of the future owner of the token
1988      * @param _qty amount of tokens to drop the owner
1989      */
1990      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1991          if(_qty == 0) revert MintZeroQuantity();
1992          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1993          _safeMint(_to, _qty, true);
1994      }
1995 
1996   
1997     /////////////// PUBLIC MINT FUNCTIONS
1998     /**
1999     * @dev Mints tokens to an address in batch.
2000     * fee may or may not be required*
2001     * @param _to address of the future owner of the token
2002     * @param _amount number of tokens to mint
2003     */
2004     function mintToMultiple(address _to, uint256 _amount) public payable {
2005         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2006         if(_amount == 0) revert MintZeroQuantity();
2007         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2008         if(!mintingOpen) revert PublicMintClosed();
2009         if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2010         
2011         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2012         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2013         if(!priceIsRight(msg.value, getPrice(_amount, _to))) revert InvalidPayment();
2014         sendProviderFee();
2015         _safeMint(_to, _amount, false);
2016     }
2017 
2018     /**
2019      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2020      * fee may or may not be required*
2021      * @param _to address of the future owner of the token
2022      * @param _amount number of tokens to mint
2023      * @param _erc20TokenContract erc-20 token contract to mint with
2024      */
2025     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2026       if(_amount == 0) revert MintZeroQuantity();
2027       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2028       if(!mintingOpen) revert PublicMintClosed();
2029       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2030       if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2031       
2032       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2033       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
2034 
2035       // ERC-20 Specific pre-flight checks
2036       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2037       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2038       IERC20 payableToken = IERC20(_erc20TokenContract);
2039 
2040       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2041       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2042 
2043       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2044       if(!transferComplete) revert ERC20TransferFailed();
2045 
2046       sendProviderFee();
2047       _safeMint(_to, _amount, false);
2048     }
2049 
2050     function openMinting() public onlyTeamOrOwner {
2051         mintingOpen = true;
2052     }
2053 
2054     function stopMinting() public onlyTeamOrOwner {
2055         mintingOpen = false;
2056     }
2057 
2058   
2059     ///////////// ALLOWLIST MINTING FUNCTIONS
2060     /**
2061     * @dev Mints tokens to an address using an allowlist.
2062     * fee may or may not be required*
2063     * @param _to address of the future owner of the token
2064     * @param _amount number of tokens to mint
2065     * @param _merkleProof merkle proof array
2066     */
2067     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2068         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2069         if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2070         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2071         if(_amount == 0) revert MintZeroQuantity();
2072         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2073         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2074         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2075         if(!priceIsRight(msg.value, getPrice(_amount, _to))) revert InvalidPayment();
2076         
2077 
2078         sendProviderFee();
2079         _safeMint(_to, _amount, false);
2080     }
2081 
2082     /**
2083     * @dev Mints tokens to an address using an allowlist.
2084     * fee may or may not be required*
2085     * @param _to address of the future owner of the token
2086     * @param _amount number of tokens to mint
2087     * @param _merkleProof merkle proof array
2088     * @param _erc20TokenContract erc-20 token contract to mint with
2089     */
2090     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2091       if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2092       if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2093       if(_amount == 0) revert MintZeroQuantity();
2094       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2095       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2096       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2097       
2098       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
2099 
2100       // ERC-20 Specific pre-flight checks
2101       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2102       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2103       IERC20 payableToken = IERC20(_erc20TokenContract);
2104 
2105       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2106       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2107 
2108       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2109       if(!transferComplete) revert ERC20TransferFailed();
2110       
2111       sendProviderFee();
2112       _safeMint(_to, _amount, false);
2113     }
2114 
2115     /**
2116      * @dev Enable allowlist minting fully by enabling both flags
2117      * This is a convenience function for the Rampp user
2118      */
2119     function openAllowlistMint() public onlyTeamOrOwner {
2120         enableAllowlistOnlyMode();
2121         mintingOpen = true;
2122     }
2123 
2124     /**
2125      * @dev Close allowlist minting fully by disabling both flags
2126      * This is a convenience function for the Rampp user
2127      */
2128     function closeAllowlistMint() public onlyTeamOrOwner {
2129         disableAllowlistOnlyMode();
2130         mintingOpen = false;
2131     }
2132 
2133 
2134   
2135     /**
2136     * @dev Check if wallet over MAX_WALLET_MINTS
2137     * @param _address address in question to check if minted count exceeds max
2138     */
2139     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2140         if(_amount == 0) revert ValueCannotBeZero();
2141         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2142     }
2143 
2144     /**
2145     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2146     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2147     */
2148     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2149         if(_newWalletMax == 0) revert ValueCannotBeZero();
2150         MAX_WALLET_MINTS = _newWalletMax;
2151     }
2152     
2153 
2154   
2155     /**
2156      * @dev Allows owner to set Max mints per tx
2157      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2158      */
2159      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2160          if(_newMaxMint == 0) revert ValueCannotBeZero();
2161          maxBatchSize = _newMaxMint;
2162      }
2163     
2164 
2165   
2166   
2167   
2168   function contractURI() public pure returns (string memory) {
2169     return "https://metadata.mintplex.xyz/OLVZGtLijWCMk5ESOEAw/contract-metadata";
2170   }
2171   
2172 
2173   function _baseURI() internal view virtual override returns(string memory) {
2174     return _baseTokenURI;
2175   }
2176 
2177   function _baseURIExtension() internal view virtual override returns(string memory) {
2178     return _baseTokenExtension;
2179   }
2180 
2181   function baseTokenURI() public view returns(string memory) {
2182     return _baseTokenURI;
2183   }
2184 
2185   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2186     _baseTokenURI = baseURI;
2187   }
2188 
2189   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2190     _baseTokenExtension = baseExtension;
2191   }
2192 }
2193 
2194 
2195   
2196 // File: contracts/BackToTheEthContract.sol
2197 //SPDX-License-Identifier: MIT
2198 
2199 pragma solidity ^0.8.0;
2200 
2201 contract BackToTheEthContract is ERC721APlus {
2202     constructor() ERC721APlus("Back To The ETH", "BTTE"){}
2203 }
2204   