1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //   ___  _   _  ___ _  ____  __ ___    ___ ___ _  _ ___ ___ ___ ___ 
5 //  |   \| | | |/ __| |/ /  \/  | __|  / __| __| \| | __/ __|_ _/ __|
6 //  | |) | |_| | (__| ' <| |\/| | _|  | (_ | _|| .` | _|\__ \| |\__ \
7 //  |___/ \___/ \___|_|\_\_|  |_|___|  \___|___|_|\_|___|___/___|___/
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
774 //-------------END DEPENDENCIES------------------------//
775 
776 
777   
778 // Rampp Contracts v2.1 (Teams.sol)
779 
780 pragma solidity ^0.8.0;
781 
782 /**
783 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
784 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
785 * This will easily allow cross-collaboration via Mintplex.xyz.
786 **/
787 abstract contract Teams is Ownable{
788   mapping (address => bool) internal team;
789 
790   /**
791   * @dev Adds an address to the team. Allows them to execute protected functions
792   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
793   **/
794   function addToTeam(address _address) public onlyOwner {
795     require(_address != address(0), "Invalid address");
796     require(!inTeam(_address), "This address is already in your team.");
797   
798     team[_address] = true;
799   }
800 
801   /**
802   * @dev Removes an address to the team.
803   * @param _address the ETH address to remove, cannot be 0x and must be in team
804   **/
805   function removeFromTeam(address _address) public onlyOwner {
806     require(_address != address(0), "Invalid address");
807     require(inTeam(_address), "This address is not in your team currently.");
808   
809     team[_address] = false;
810   }
811 
812   /**
813   * @dev Check if an address is valid and active in the team
814   * @param _address ETH address to check for truthiness
815   **/
816   function inTeam(address _address)
817     public
818     view
819     returns (bool)
820   {
821     require(_address != address(0), "Invalid address to check.");
822     return team[_address] == true;
823   }
824 
825   /**
826   * @dev Throws if called by any account other than the owner or team member.
827   */
828   modifier onlyTeamOrOwner() {
829     bool _isOwner = owner() == _msgSender();
830     bool _isTeam = inTeam(_msgSender());
831     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
832     _;
833   }
834 }
835 
836 
837   
838   pragma solidity ^0.8.0;
839 
840   /**
841   * @dev These functions deal with verification of Merkle Trees proofs.
842   *
843   * The proofs can be generated using the JavaScript library
844   * https://github.com/miguelmota/merkletreejs[merkletreejs].
845   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
846   *
847   *
848   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
849   * hashing, or use a hash function other than keccak256 for hashing leaves.
850   * This is because the concatenation of a sorted pair of internal nodes in
851   * the merkle tree could be reinterpreted as a leaf value.
852   */
853   library MerkleProof {
854       /**
855       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
856       * defined by 'root'. For this, a 'proof' must be provided, containing
857       * sibling hashes on the branch from the leaf to the root of the tree. Each
858       * pair of leaves and each pair of pre-images are assumed to be sorted.
859       */
860       function verify(
861           bytes32[] memory proof,
862           bytes32 root,
863           bytes32 leaf
864       ) internal pure returns (bool) {
865           return processProof(proof, leaf) == root;
866       }
867 
868       /**
869       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
870       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
871       * hash matches the root of the tree. When processing the proof, the pairs
872       * of leafs & pre-images are assumed to be sorted.
873       *
874       * _Available since v4.4._
875       */
876       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
877           bytes32 computedHash = leaf;
878           for (uint256 i = 0; i < proof.length; i++) {
879               bytes32 proofElement = proof[i];
880               if (computedHash <= proofElement) {
881                   // Hash(current computed hash + current element of the proof)
882                   computedHash = _efficientHash(computedHash, proofElement);
883               } else {
884                   // Hash(current element of the proof + current computed hash)
885                   computedHash = _efficientHash(proofElement, computedHash);
886               }
887           }
888           return computedHash;
889       }
890 
891       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
892           assembly {
893               mstore(0x00, a)
894               mstore(0x20, b)
895               value := keccak256(0x00, 0x40)
896           }
897       }
898   }
899 
900 
901   // File: Allowlist.sol
902 
903   pragma solidity ^0.8.0;
904 
905   abstract contract Allowlist is Teams {
906     bytes32 public merkleRoot;
907     bool public onlyAllowlistMode = false;
908 
909     /**
910      * @dev Update merkle root to reflect changes in Allowlist
911      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
912      */
913     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
914       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
915       merkleRoot = _newMerkleRoot;
916     }
917 
918     /**
919      * @dev Check the proof of an address if valid for merkle root
920      * @param _to address to check for proof
921      * @param _merkleProof Proof of the address to validate against root and leaf
922      */
923     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
924       require(merkleRoot != 0, "Merkle root is not set!");
925       bytes32 leaf = keccak256(abi.encodePacked(_to));
926 
927       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
928     }
929 
930     
931     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
932       onlyAllowlistMode = true;
933     }
934 
935     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
936         onlyAllowlistMode = false;
937     }
938   }
939   
940   
941 /**
942  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
943  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
944  *
945  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
946  * 
947  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
948  *
949  * Does not support burning tokens to address(0).
950  */
951 contract ERC721A is
952   Context,
953   ERC165,
954   IERC721,
955   IERC721Metadata,
956   IERC721Enumerable,
957   Teams
958 {
959   using Address for address;
960   using Strings for uint256;
961 
962   struct TokenOwnership {
963     address addr;
964     uint64 startTimestamp;
965   }
966 
967   struct AddressData {
968     uint128 balance;
969     uint128 numberMinted;
970   }
971 
972   uint256 private currentIndex;
973 
974   uint256 public immutable collectionSize;
975   uint256 public maxBatchSize;
976 
977   // Token name
978   string private _name;
979 
980   // Token symbol
981   string private _symbol;
982 
983   // Mapping from token ID to ownership details
984   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
985   mapping(uint256 => TokenOwnership) private _ownerships;
986 
987   // Mapping owner address to address data
988   mapping(address => AddressData) private _addressData;
989 
990   // Mapping from token ID to approved address
991   mapping(uint256 => address) private _tokenApprovals;
992 
993   // Mapping from owner to operator approvals
994   mapping(address => mapping(address => bool)) private _operatorApprovals;
995 
996   /* @dev Mapping of restricted operator approvals set by contract Owner
997   * This serves as an optional addition to ERC-721 so
998   * that the contract owner can elect to prevent specific addresses/contracts
999   * from being marked as the approver for a token. The reason for this
1000   * is that some projects may want to retain control of where their tokens can/can not be listed
1001   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1002   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1003   */
1004   mapping(address => bool) public restrictedApprovalAddresses;
1005 
1006   /**
1007    * @dev
1008    * maxBatchSize refers to how much a minter can mint at a time.
1009    * collectionSize_ refers to how many tokens are in the collection.
1010    */
1011   constructor(
1012     string memory name_,
1013     string memory symbol_,
1014     uint256 maxBatchSize_,
1015     uint256 collectionSize_
1016   ) {
1017     require(
1018       collectionSize_ > 0,
1019       "ERC721A: collection must have a nonzero supply"
1020     );
1021     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1022     _name = name_;
1023     _symbol = symbol_;
1024     maxBatchSize = maxBatchSize_;
1025     collectionSize = collectionSize_;
1026     currentIndex = _startTokenId();
1027   }
1028 
1029   /**
1030   * To change the starting tokenId, please override this function.
1031   */
1032   function _startTokenId() internal view virtual returns (uint256) {
1033     return 1;
1034   }
1035 
1036   /**
1037    * @dev See {IERC721Enumerable-totalSupply}.
1038    */
1039   function totalSupply() public view override returns (uint256) {
1040     return _totalMinted();
1041   }
1042 
1043   function currentTokenId() public view returns (uint256) {
1044     return _totalMinted();
1045   }
1046 
1047   function getNextTokenId() public view returns (uint256) {
1048       return _totalMinted() + 1;
1049   }
1050 
1051   /**
1052   * Returns the total amount of tokens minted in the contract.
1053   */
1054   function _totalMinted() internal view returns (uint256) {
1055     unchecked {
1056       return currentIndex - _startTokenId();
1057     }
1058   }
1059 
1060   /**
1061    * @dev See {IERC721Enumerable-tokenByIndex}.
1062    */
1063   function tokenByIndex(uint256 index) public view override returns (uint256) {
1064     require(index < totalSupply(), "ERC721A: global index out of bounds");
1065     return index;
1066   }
1067 
1068   /**
1069    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1070    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1071    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1072    */
1073   function tokenOfOwnerByIndex(address owner, uint256 index)
1074     public
1075     view
1076     override
1077     returns (uint256)
1078   {
1079     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1080     uint256 numMintedSoFar = totalSupply();
1081     uint256 tokenIdsIdx = 0;
1082     address currOwnershipAddr = address(0);
1083     for (uint256 i = 0; i < numMintedSoFar; i++) {
1084       TokenOwnership memory ownership = _ownerships[i];
1085       if (ownership.addr != address(0)) {
1086         currOwnershipAddr = ownership.addr;
1087       }
1088       if (currOwnershipAddr == owner) {
1089         if (tokenIdsIdx == index) {
1090           return i;
1091         }
1092         tokenIdsIdx++;
1093       }
1094     }
1095     revert("ERC721A: unable to get token of owner by index");
1096   }
1097 
1098   /**
1099    * @dev See {IERC165-supportsInterface}.
1100    */
1101   function supportsInterface(bytes4 interfaceId)
1102     public
1103     view
1104     virtual
1105     override(ERC165, IERC165)
1106     returns (bool)
1107   {
1108     return
1109       interfaceId == type(IERC721).interfaceId ||
1110       interfaceId == type(IERC721Metadata).interfaceId ||
1111       interfaceId == type(IERC721Enumerable).interfaceId ||
1112       super.supportsInterface(interfaceId);
1113   }
1114 
1115   /**
1116    * @dev See {IERC721-balanceOf}.
1117    */
1118   function balanceOf(address owner) public view override returns (uint256) {
1119     require(owner != address(0), "ERC721A: balance query for the zero address");
1120     return uint256(_addressData[owner].balance);
1121   }
1122 
1123   function _numberMinted(address owner) internal view returns (uint256) {
1124     require(
1125       owner != address(0),
1126       "ERC721A: number minted query for the zero address"
1127     );
1128     return uint256(_addressData[owner].numberMinted);
1129   }
1130 
1131   function ownershipOf(uint256 tokenId)
1132     internal
1133     view
1134     returns (TokenOwnership memory)
1135   {
1136     uint256 curr = tokenId;
1137 
1138     unchecked {
1139         if (_startTokenId() <= curr && curr < currentIndex) {
1140             TokenOwnership memory ownership = _ownerships[curr];
1141             if (ownership.addr != address(0)) {
1142                 return ownership;
1143             }
1144 
1145             // Invariant:
1146             // There will always be an ownership that has an address and is not burned
1147             // before an ownership that does not have an address and is not burned.
1148             // Hence, curr will not underflow.
1149             while (true) {
1150                 curr--;
1151                 ownership = _ownerships[curr];
1152                 if (ownership.addr != address(0)) {
1153                     return ownership;
1154                 }
1155             }
1156         }
1157     }
1158 
1159     revert("ERC721A: unable to determine the owner of token");
1160   }
1161 
1162   /**
1163    * @dev See {IERC721-ownerOf}.
1164    */
1165   function ownerOf(uint256 tokenId) public view override returns (address) {
1166     return ownershipOf(tokenId).addr;
1167   }
1168 
1169   /**
1170    * @dev See {IERC721Metadata-name}.
1171    */
1172   function name() public view virtual override returns (string memory) {
1173     return _name;
1174   }
1175 
1176   /**
1177    * @dev See {IERC721Metadata-symbol}.
1178    */
1179   function symbol() public view virtual override returns (string memory) {
1180     return _symbol;
1181   }
1182 
1183   /**
1184    * @dev See {IERC721Metadata-tokenURI}.
1185    */
1186   function tokenURI(uint256 tokenId)
1187     public
1188     view
1189     virtual
1190     override
1191     returns (string memory)
1192   {
1193     string memory baseURI = _baseURI();
1194     return
1195       bytes(baseURI).length > 0
1196         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1197         : "";
1198   }
1199 
1200   /**
1201    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1202    * token will be the concatenation of the baseURI and the tokenId. Empty
1203    * by default, can be overriden in child contracts.
1204    */
1205   function _baseURI() internal view virtual returns (string memory) {
1206     return "";
1207   }
1208 
1209   /**
1210    * @dev Sets the value for an address to be in the restricted approval address pool.
1211    * Setting an address to true will disable token owners from being able to mark the address
1212    * for approval for trading. This would be used in theory to prevent token owners from listing
1213    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1214    * @param _address the marketplace/user to modify restriction status of
1215    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1216    */
1217   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1218     restrictedApprovalAddresses[_address] = _isRestricted;
1219   }
1220 
1221   /**
1222    * @dev See {IERC721-approve}.
1223    */
1224   function approve(address to, uint256 tokenId) public override {
1225     address owner = ERC721A.ownerOf(tokenId);
1226     require(to != owner, "ERC721A: approval to current owner");
1227     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1228 
1229     require(
1230       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1231       "ERC721A: approve caller is not owner nor approved for all"
1232     );
1233 
1234     _approve(to, tokenId, owner);
1235   }
1236 
1237   /**
1238    * @dev See {IERC721-getApproved}.
1239    */
1240   function getApproved(uint256 tokenId) public view override returns (address) {
1241     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1242 
1243     return _tokenApprovals[tokenId];
1244   }
1245 
1246   /**
1247    * @dev See {IERC721-setApprovalForAll}.
1248    */
1249   function setApprovalForAll(address operator, bool approved) public override {
1250     require(operator != _msgSender(), "ERC721A: approve to caller");
1251     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1252 
1253     _operatorApprovals[_msgSender()][operator] = approved;
1254     emit ApprovalForAll(_msgSender(), operator, approved);
1255   }
1256 
1257   /**
1258    * @dev See {IERC721-isApprovedForAll}.
1259    */
1260   function isApprovedForAll(address owner, address operator)
1261     public
1262     view
1263     virtual
1264     override
1265     returns (bool)
1266   {
1267     return _operatorApprovals[owner][operator];
1268   }
1269 
1270   /**
1271    * @dev See {IERC721-transferFrom}.
1272    */
1273   function transferFrom(
1274     address from,
1275     address to,
1276     uint256 tokenId
1277   ) public override {
1278     _transfer(from, to, tokenId);
1279   }
1280 
1281   /**
1282    * @dev See {IERC721-safeTransferFrom}.
1283    */
1284   function safeTransferFrom(
1285     address from,
1286     address to,
1287     uint256 tokenId
1288   ) public override {
1289     safeTransferFrom(from, to, tokenId, "");
1290   }
1291 
1292   /**
1293    * @dev See {IERC721-safeTransferFrom}.
1294    */
1295   function safeTransferFrom(
1296     address from,
1297     address to,
1298     uint256 tokenId,
1299     bytes memory _data
1300   ) public override {
1301     _transfer(from, to, tokenId);
1302     require(
1303       _checkOnERC721Received(from, to, tokenId, _data),
1304       "ERC721A: transfer to non ERC721Receiver implementer"
1305     );
1306   }
1307 
1308   /**
1309    * @dev Returns whether tokenId exists.
1310    *
1311    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1312    *
1313    * Tokens start existing when they are minted (_mint),
1314    */
1315   function _exists(uint256 tokenId) internal view returns (bool) {
1316     return _startTokenId() <= tokenId && tokenId < currentIndex;
1317   }
1318 
1319   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1320     _safeMint(to, quantity, isAdminMint, "");
1321   }
1322 
1323   /**
1324    * @dev Mints quantity tokens and transfers them to to.
1325    *
1326    * Requirements:
1327    *
1328    * - there must be quantity tokens remaining unminted in the total collection.
1329    * - to cannot be the zero address.
1330    * - quantity cannot be larger than the max batch size.
1331    *
1332    * Emits a {Transfer} event.
1333    */
1334   function _safeMint(
1335     address to,
1336     uint256 quantity,
1337     bool isAdminMint,
1338     bytes memory _data
1339   ) internal {
1340     uint256 startTokenId = currentIndex;
1341     require(to != address(0), "ERC721A: mint to the zero address");
1342     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1343     require(!_exists(startTokenId), "ERC721A: token already minted");
1344 
1345     // For admin mints we do not want to enforce the maxBatchSize limit
1346     if (isAdminMint == false) {
1347         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1348     }
1349 
1350     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1351 
1352     AddressData memory addressData = _addressData[to];
1353     _addressData[to] = AddressData(
1354       addressData.balance + uint128(quantity),
1355       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1356     );
1357     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1358 
1359     uint256 updatedIndex = startTokenId;
1360 
1361     for (uint256 i = 0; i < quantity; i++) {
1362       emit Transfer(address(0), to, updatedIndex);
1363       require(
1364         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1365         "ERC721A: transfer to non ERC721Receiver implementer"
1366       );
1367       updatedIndex++;
1368     }
1369 
1370     currentIndex = updatedIndex;
1371     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1372   }
1373 
1374   /**
1375    * @dev Transfers tokenId from from to to.
1376    *
1377    * Requirements:
1378    *
1379    * - to cannot be the zero address.
1380    * - tokenId token must be owned by from.
1381    *
1382    * Emits a {Transfer} event.
1383    */
1384   function _transfer(
1385     address from,
1386     address to,
1387     uint256 tokenId
1388   ) private {
1389     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1390 
1391     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1392       getApproved(tokenId) == _msgSender() ||
1393       isApprovedForAll(prevOwnership.addr, _msgSender()));
1394 
1395     require(
1396       isApprovedOrOwner,
1397       "ERC721A: transfer caller is not owner nor approved"
1398     );
1399 
1400     require(
1401       prevOwnership.addr == from,
1402       "ERC721A: transfer from incorrect owner"
1403     );
1404     require(to != address(0), "ERC721A: transfer to the zero address");
1405 
1406     _beforeTokenTransfers(from, to, tokenId, 1);
1407 
1408     // Clear approvals from the previous owner
1409     _approve(address(0), tokenId, prevOwnership.addr);
1410 
1411     _addressData[from].balance -= 1;
1412     _addressData[to].balance += 1;
1413     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1414 
1415     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1416     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1417     uint256 nextTokenId = tokenId + 1;
1418     if (_ownerships[nextTokenId].addr == address(0)) {
1419       if (_exists(nextTokenId)) {
1420         _ownerships[nextTokenId] = TokenOwnership(
1421           prevOwnership.addr,
1422           prevOwnership.startTimestamp
1423         );
1424       }
1425     }
1426 
1427     emit Transfer(from, to, tokenId);
1428     _afterTokenTransfers(from, to, tokenId, 1);
1429   }
1430 
1431   /**
1432    * @dev Approve to to operate on tokenId
1433    *
1434    * Emits a {Approval} event.
1435    */
1436   function _approve(
1437     address to,
1438     uint256 tokenId,
1439     address owner
1440   ) private {
1441     _tokenApprovals[tokenId] = to;
1442     emit Approval(owner, to, tokenId);
1443   }
1444 
1445   uint256 public nextOwnerToExplicitlySet = 0;
1446 
1447   /**
1448    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1449    */
1450   function _setOwnersExplicit(uint256 quantity) internal {
1451     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1452     require(quantity > 0, "quantity must be nonzero");
1453     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1454 
1455     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1456     if (endIndex > collectionSize - 1) {
1457       endIndex = collectionSize - 1;
1458     }
1459     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1460     require(_exists(endIndex), "not enough minted yet for this cleanup");
1461     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1462       if (_ownerships[i].addr == address(0)) {
1463         TokenOwnership memory ownership = ownershipOf(i);
1464         _ownerships[i] = TokenOwnership(
1465           ownership.addr,
1466           ownership.startTimestamp
1467         );
1468       }
1469     }
1470     nextOwnerToExplicitlySet = endIndex + 1;
1471   }
1472 
1473   /**
1474    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1475    * The call is not executed if the target address is not a contract.
1476    *
1477    * @param from address representing the previous owner of the given token ID
1478    * @param to target address that will receive the tokens
1479    * @param tokenId uint256 ID of the token to be transferred
1480    * @param _data bytes optional data to send along with the call
1481    * @return bool whether the call correctly returned the expected magic value
1482    */
1483   function _checkOnERC721Received(
1484     address from,
1485     address to,
1486     uint256 tokenId,
1487     bytes memory _data
1488   ) private returns (bool) {
1489     if (to.isContract()) {
1490       try
1491         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1492       returns (bytes4 retval) {
1493         return retval == IERC721Receiver(to).onERC721Received.selector;
1494       } catch (bytes memory reason) {
1495         if (reason.length == 0) {
1496           revert("ERC721A: transfer to non ERC721Receiver implementer");
1497         } else {
1498           assembly {
1499             revert(add(32, reason), mload(reason))
1500           }
1501         }
1502       }
1503     } else {
1504       return true;
1505     }
1506   }
1507 
1508   /**
1509    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1510    *
1511    * startTokenId - the first token id to be transferred
1512    * quantity - the amount to be transferred
1513    *
1514    * Calling conditions:
1515    *
1516    * - When from and to are both non-zero, from's tokenId will be
1517    * transferred to to.
1518    * - When from is zero, tokenId will be minted for to.
1519    */
1520   function _beforeTokenTransfers(
1521     address from,
1522     address to,
1523     uint256 startTokenId,
1524     uint256 quantity
1525   ) internal virtual {}
1526 
1527   /**
1528    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1529    * minting.
1530    *
1531    * startTokenId - the first token id to be transferred
1532    * quantity - the amount to be transferred
1533    *
1534    * Calling conditions:
1535    *
1536    * - when from and to are both non-zero.
1537    * - from and to are never both zero.
1538    */
1539   function _afterTokenTransfers(
1540     address from,
1541     address to,
1542     uint256 startTokenId,
1543     uint256 quantity
1544   ) internal virtual {}
1545 }
1546 
1547 
1548 
1549   
1550 abstract contract Ramppable {
1551   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1552 
1553   modifier isRampp() {
1554       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1555       _;
1556   }
1557 }
1558 
1559 
1560   
1561   
1562 interface IERC20 {
1563   function allowance(address owner, address spender) external view returns (uint256);
1564   function transfer(address _to, uint256 _amount) external returns (bool);
1565   function balanceOf(address account) external view returns (uint256);
1566   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1567 }
1568 
1569 // File: WithdrawableV2
1570 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1571 // ERC-20 Payouts are limited to a single payout address. This feature 
1572 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1573 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1574 abstract contract WithdrawableV2 is Teams, Ramppable {
1575   struct acceptedERC20 {
1576     bool isActive;
1577     uint256 chargeAmount;
1578   }
1579 
1580   
1581   mapping(address => acceptedERC20) private allowedTokenContracts;
1582   address[] public payableAddresses = [RAMPPADDRESS,0x28aa9C3653544B6df64e9369bB9AAf7F49F4eBD4];
1583   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1584   address public erc20Payable = 0x28aa9C3653544B6df64e9369bB9AAf7F49F4eBD4;
1585   uint256[] public payableFees = [5,95];
1586   uint256[] public surchargePayableFees = [100];
1587   uint256 public payableAddressCount = 2;
1588   uint256 public surchargePayableAddressCount = 1;
1589   uint256 public ramppSurchargeBalance = 0 ether;
1590   uint256 public ramppSurchargeFee = 0.001 ether;
1591   bool public onlyERC20MintingMode = false;
1592   
1593 
1594   /**
1595   * @dev Calculates the true payable balance of the contract as the
1596   * value on contract may be from ERC-20 mint surcharges and not 
1597   * public mint charges - which are not eligable for rev share & user withdrawl
1598   */
1599   function calcAvailableBalance() public view returns(uint256) {
1600     return address(this).balance - ramppSurchargeBalance;
1601   }
1602 
1603   function withdrawAll() public onlyTeamOrOwner {
1604       require(calcAvailableBalance() > 0);
1605       _withdrawAll();
1606   }
1607   
1608   function withdrawAllRampp() public isRampp {
1609       require(calcAvailableBalance() > 0);
1610       _withdrawAll();
1611   }
1612 
1613   function _withdrawAll() private {
1614       uint256 balance = calcAvailableBalance();
1615       
1616       for(uint i=0; i < payableAddressCount; i++ ) {
1617           _widthdraw(
1618               payableAddresses[i],
1619               (balance * payableFees[i]) / 100
1620           );
1621       }
1622   }
1623   
1624   function _widthdraw(address _address, uint256 _amount) private {
1625       (bool success, ) = _address.call{value: _amount}("");
1626       require(success, "Transfer failed.");
1627   }
1628 
1629   /**
1630   * @dev This function is similiar to the regular withdraw but operates only on the
1631   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1632   **/
1633   function _withdrawAllSurcharges() private {
1634     uint256 balance = ramppSurchargeBalance;
1635     if(balance == 0) { return; }
1636     
1637     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1638         _widthdraw(
1639             surchargePayableAddresses[i],
1640             (balance * surchargePayableFees[i]) / 100
1641         );
1642     }
1643     ramppSurchargeBalance = 0 ether;
1644   }
1645 
1646   /**
1647   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1648   * in the event ERC-20 tokens are paid to the contract for mints. This will
1649   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1650   * @param _tokenContract contract of ERC-20 token to withdraw
1651   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1652   */
1653   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1654     require(_amountToWithdraw > 0);
1655     IERC20 tokenContract = IERC20(_tokenContract);
1656     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1657     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1658     _withdrawAllSurcharges();
1659   }
1660 
1661   /**
1662   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1663   */
1664   function withdrawRamppSurcharges() public isRampp {
1665     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1666     _withdrawAllSurcharges();
1667   }
1668 
1669    /**
1670   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1671   */
1672   function addSurcharge() internal {
1673     ramppSurchargeBalance += ramppSurchargeFee;
1674   }
1675   
1676   /**
1677   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1678   */
1679   function hasSurcharge() internal returns(bool) {
1680     return msg.value == ramppSurchargeFee;
1681   }
1682 
1683   /**
1684   * @dev Set surcharge fee for using ERC-20 payments on contract
1685   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1686   */
1687   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1688     ramppSurchargeFee = _newSurcharge;
1689   }
1690 
1691   /**
1692   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1693   * @param _erc20TokenContract address of ERC-20 contract in question
1694   */
1695   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1696     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1697   }
1698 
1699   /**
1700   * @dev get the value of tokens to transfer for user of an ERC-20
1701   * @param _erc20TokenContract address of ERC-20 contract in question
1702   */
1703   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1704     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1705     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1706   }
1707 
1708   /**
1709   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1710   * @param _erc20TokenContract address of ERC-20 contract in question
1711   * @param _isActive default status of if contract should be allowed to accept payments
1712   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1713   */
1714   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1715     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1716     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1717   }
1718 
1719   /**
1720   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1721   * it will assume the default value of zero. This should not be used to create new payment tokens.
1722   * @param _erc20TokenContract address of ERC-20 contract in question
1723   */
1724   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1725     allowedTokenContracts[_erc20TokenContract].isActive = true;
1726   }
1727 
1728   /**
1729   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1730   * it will assume the default value of zero. This should not be used to create new payment tokens.
1731   * @param _erc20TokenContract address of ERC-20 contract in question
1732   */
1733   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1734     allowedTokenContracts[_erc20TokenContract].isActive = false;
1735   }
1736 
1737   /**
1738   * @dev Enable only ERC-20 payments for minting on this contract
1739   */
1740   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1741     onlyERC20MintingMode = true;
1742   }
1743 
1744   /**
1745   * @dev Disable only ERC-20 payments for minting on this contract
1746   */
1747   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1748     onlyERC20MintingMode = false;
1749   }
1750 
1751   /**
1752   * @dev Set the payout of the ERC-20 token payout to a specific address
1753   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1754   */
1755   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1756     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1757     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1758     erc20Payable = _newErc20Payable;
1759   }
1760 
1761   /**
1762   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1763   */
1764   function resetRamppSurchargeBalance() public isRampp {
1765     ramppSurchargeBalance = 0 ether;
1766   }
1767 
1768   /**
1769   * @dev Allows Rampp wallet to update its own reference as well as update
1770   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1771   * and since Rampp is always the first address this function is limited to the rampp payout only.
1772   * @param _newAddress updated Rampp Address
1773   */
1774   function setRamppAddress(address _newAddress) public isRampp {
1775     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1776     RAMPPADDRESS = _newAddress;
1777     payableAddresses[0] = _newAddress;
1778   }
1779 }
1780 
1781 
1782   
1783 // File: isFeeable.sol
1784 abstract contract Feeable is Teams {
1785   uint256 public PRICE = 0.0099 ether;
1786 
1787   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1788     PRICE = _feeInWei;
1789   }
1790 
1791   function getPrice(uint256 _count) public view returns (uint256) {
1792     return PRICE * _count;
1793   }
1794 }
1795 
1796   
1797   
1798   
1799 abstract contract RamppERC721A is 
1800     Ownable,
1801     Teams,
1802     ERC721A,
1803     WithdrawableV2,
1804     ReentrancyGuard 
1805     , Feeable 
1806     , Allowlist 
1807     
1808 {
1809   constructor(
1810     string memory tokenName,
1811     string memory tokenSymbol
1812   ) ERC721A(tokenName, tokenSymbol, 1, 999) { }
1813     uint8 public CONTRACT_VERSION = 2;
1814     string public _baseTokenURI = "ipfs://bafybeiaarxyttczxcchh25a5cixnra67rxpjw4em7m3nfxb3jdvuulda3q/";
1815 
1816     bool public mintingOpen = false;
1817     bool public isRevealed = false;
1818     
1819     uint256 public MAX_WALLET_MINTS = 1;
1820 
1821   
1822     /////////////// Admin Mint Functions
1823     /**
1824      * @dev Mints a token to an address with a tokenURI.
1825      * This is owner only and allows a fee-free drop
1826      * @param _to address of the future owner of the token
1827      * @param _qty amount of tokens to drop the owner
1828      */
1829      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1830          require(_qty > 0, "Must mint at least 1 token.");
1831          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 999");
1832          _safeMint(_to, _qty, true);
1833      }
1834 
1835   
1836     /////////////// GENERIC MINT FUNCTIONS
1837     /**
1838     * @dev Mints a single token to an address.
1839     * fee may or may not be required*
1840     * @param _to address of the future owner of the token
1841     */
1842     function mintTo(address _to) public payable {
1843         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1844         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 999");
1845         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1846         
1847         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1848         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1849         
1850         _safeMint(_to, 1, false);
1851     }
1852 
1853     /**
1854     * @dev Mints tokens to an address in batch.
1855     * fee may or may not be required*
1856     * @param _to address of the future owner of the token
1857     * @param _amount number of tokens to mint
1858     */
1859     function mintToMultiple(address _to, uint256 _amount) public payable {
1860         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1861         require(_amount >= 1, "Must mint at least 1 token");
1862         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1863         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1864         
1865         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1866         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 999");
1867         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1868 
1869         _safeMint(_to, _amount, false);
1870     }
1871 
1872     /**
1873      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1874      * fee may or may not be required*
1875      * @param _to address of the future owner of the token
1876      * @param _amount number of tokens to mint
1877      * @param _erc20TokenContract erc-20 token contract to mint with
1878      */
1879     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1880       require(_amount >= 1, "Must mint at least 1 token");
1881       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1882       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 999");
1883       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1884       
1885       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1886 
1887       // ERC-20 Specific pre-flight checks
1888       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1889       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1890       IERC20 payableToken = IERC20(_erc20TokenContract);
1891 
1892       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1893       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1894       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1895       
1896       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1897       require(transferComplete, "ERC-20 token was unable to be transferred");
1898       
1899       _safeMint(_to, _amount, false);
1900       addSurcharge();
1901     }
1902 
1903     function openMinting() public onlyTeamOrOwner {
1904         mintingOpen = true;
1905     }
1906 
1907     function stopMinting() public onlyTeamOrOwner {
1908         mintingOpen = false;
1909     }
1910 
1911   
1912     ///////////// ALLOWLIST MINTING FUNCTIONS
1913 
1914     /**
1915     * @dev Mints tokens to an address using an allowlist.
1916     * fee may or may not be required*
1917     * @param _to address of the future owner of the token
1918     * @param _merkleProof merkle proof array
1919     */
1920     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1921         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1922         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1923         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1924         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 999");
1925         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1926         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1927         
1928 
1929         _safeMint(_to, 1, false);
1930     }
1931 
1932     /**
1933     * @dev Mints tokens to an address using an allowlist.
1934     * fee may or may not be required*
1935     * @param _to address of the future owner of the token
1936     * @param _amount number of tokens to mint
1937     * @param _merkleProof merkle proof array
1938     */
1939     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1940         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1941         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1942         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1943         require(_amount >= 1, "Must mint at least 1 token");
1944         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1945 
1946         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1947         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 999");
1948         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1949         
1950 
1951         _safeMint(_to, _amount, false);
1952     }
1953 
1954     /**
1955     * @dev Mints tokens to an address using an allowlist.
1956     * fee may or may not be required*
1957     * @param _to address of the future owner of the token
1958     * @param _amount number of tokens to mint
1959     * @param _merkleProof merkle proof array
1960     * @param _erc20TokenContract erc-20 token contract to mint with
1961     */
1962     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
1963       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1964       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1965       require(_amount >= 1, "Must mint at least 1 token");
1966       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1967       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1968       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 999");
1969       
1970     
1971       // ERC-20 Specific pre-flight checks
1972       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1973       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1974       IERC20 payableToken = IERC20(_erc20TokenContract);
1975     
1976       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1977       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1978       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1979       
1980       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1981       require(transferComplete, "ERC-20 token was unable to be transferred");
1982       
1983       _safeMint(_to, _amount, false);
1984       addSurcharge();
1985     }
1986 
1987     /**
1988      * @dev Enable allowlist minting fully by enabling both flags
1989      * This is a convenience function for the Rampp user
1990      */
1991     function openAllowlistMint() public onlyTeamOrOwner {
1992         enableAllowlistOnlyMode();
1993         mintingOpen = true;
1994     }
1995 
1996     /**
1997      * @dev Close allowlist minting fully by disabling both flags
1998      * This is a convenience function for the Rampp user
1999      */
2000     function closeAllowlistMint() public onlyTeamOrOwner {
2001         disableAllowlistOnlyMode();
2002         mintingOpen = false;
2003     }
2004 
2005 
2006   
2007     /**
2008     * @dev Check if wallet over MAX_WALLET_MINTS
2009     * @param _address address in question to check if minted count exceeds max
2010     */
2011     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2012         require(_amount >= 1, "Amount must be greater than or equal to 1");
2013         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2014     }
2015 
2016     /**
2017     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2018     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2019     */
2020     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2021         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2022         MAX_WALLET_MINTS = _newWalletMax;
2023     }
2024     
2025 
2026   
2027     /**
2028      * @dev Allows owner to set Max mints per tx
2029      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2030      */
2031      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2032          require(_newMaxMint >= 1, "Max mint must be at least 1");
2033          maxBatchSize = _newMaxMint;
2034      }
2035     
2036 
2037   
2038     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2039         require(isRevealed == false, "Tokens are already unveiled");
2040         _baseTokenURI = _updatedTokenURI;
2041         isRevealed = true;
2042     }
2043     
2044 
2045   function _baseURI() internal view virtual override returns(string memory) {
2046     return _baseTokenURI;
2047   }
2048 
2049   function baseTokenURI() public view returns(string memory) {
2050     return _baseTokenURI;
2051   }
2052 
2053   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2054     _baseTokenURI = baseURI;
2055   }
2056 
2057   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2058     return ownershipOf(tokenId);
2059   }
2060 }
2061 
2062 
2063   
2064 // File: contracts/DuckmegenesisContract.sol
2065 //SPDX-License-Identifier: MIT
2066 
2067 pragma solidity ^0.8.0;
2068 
2069 contract DuckmegenesisContract is RamppERC721A {
2070     constructor() RamppERC721A("DUCKME GENESIS", "DMG"){}
2071 }
2072   