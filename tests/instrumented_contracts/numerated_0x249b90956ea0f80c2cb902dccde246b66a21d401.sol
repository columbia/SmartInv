1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  ▄▄▄ . ▄· ▄▌▄▄▄ . ▌ ▐·▄▄▄ .▄▄▄  .▄▄ · ▄▄▄ .
5 // ▀▄.▀·▐█▪██▌▀▄.▀·▪█·█▌▀▄.▀·▀▄ █·▐█ ▀. ▀▄.▀·
6 // ▐▀▀▪▄▐█▌▐█▪▐▀▀▪▄▐█▐█•▐▀▀▪▄▐▀▀▄ ▄▀▀▀█▄▐▀▀▪▄
7 // ▐█▄▄▌ ▐█▀·.▐█▄▄▌ ███ ▐█▄▄▌▐█•█▌▐█▄▪▐█▐█▄▄▌
8 //  ▀▀▀   ▀ •  ▀▀▀ . ▀   ▀▀▀ .▀  ▀ ▀▀▀▀  ▀▀▀ 
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
778   
779 /**
780  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
781  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
782  *
783  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
784  * 
785  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
786  *
787  * Does not support burning tokens to address(0).
788  */
789 contract ERC721A is
790   Context,
791   ERC165,
792   IERC721,
793   IERC721Metadata,
794   IERC721Enumerable
795 {
796   using Address for address;
797   using Strings for uint256;
798 
799   struct TokenOwnership {
800     address addr;
801     uint64 startTimestamp;
802   }
803 
804   struct AddressData {
805     uint128 balance;
806     uint128 numberMinted;
807   }
808 
809   uint256 private currentIndex;
810 
811   uint256 public immutable collectionSize;
812   uint256 public maxBatchSize;
813 
814   // Token name
815   string private _name;
816 
817   // Token symbol
818   string private _symbol;
819 
820   // Mapping from token ID to ownership details
821   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
822   mapping(uint256 => TokenOwnership) private _ownerships;
823 
824   // Mapping owner address to address data
825   mapping(address => AddressData) private _addressData;
826 
827   // Mapping from token ID to approved address
828   mapping(uint256 => address) private _tokenApprovals;
829 
830   // Mapping from owner to operator approvals
831   mapping(address => mapping(address => bool)) private _operatorApprovals;
832 
833   /**
834    * @dev
835    * maxBatchSize refers to how much a minter can mint at a time.
836    * collectionSize_ refers to how many tokens are in the collection.
837    */
838   constructor(
839     string memory name_,
840     string memory symbol_,
841     uint256 maxBatchSize_,
842     uint256 collectionSize_
843   ) {
844     require(
845       collectionSize_ > 0,
846       "ERC721A: collection must have a nonzero supply"
847     );
848     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
849     _name = name_;
850     _symbol = symbol_;
851     maxBatchSize = maxBatchSize_;
852     collectionSize = collectionSize_;
853     currentIndex = _startTokenId();
854   }
855 
856   /**
857   * To change the starting tokenId, please override this function.
858   */
859   function _startTokenId() internal view virtual returns (uint256) {
860     return 1;
861   }
862 
863   /**
864    * @dev See {IERC721Enumerable-totalSupply}.
865    */
866   function totalSupply() public view override returns (uint256) {
867     return _totalMinted();
868   }
869 
870   function currentTokenId() public view returns (uint256) {
871     return _totalMinted();
872   }
873 
874   function getNextTokenId() public view returns (uint256) {
875       return _totalMinted() + 1;
876   }
877 
878   /**
879   * Returns the total amount of tokens minted in the contract.
880   */
881   function _totalMinted() internal view returns (uint256) {
882     unchecked {
883       return currentIndex - _startTokenId();
884     }
885   }
886 
887   /**
888    * @dev See {IERC721Enumerable-tokenByIndex}.
889    */
890   function tokenByIndex(uint256 index) public view override returns (uint256) {
891     require(index < totalSupply(), "ERC721A: global index out of bounds");
892     return index;
893   }
894 
895   /**
896    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
897    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
898    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
899    */
900   function tokenOfOwnerByIndex(address owner, uint256 index)
901     public
902     view
903     override
904     returns (uint256)
905   {
906     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
907     uint256 numMintedSoFar = totalSupply();
908     uint256 tokenIdsIdx = 0;
909     address currOwnershipAddr = address(0);
910     for (uint256 i = 0; i < numMintedSoFar; i++) {
911       TokenOwnership memory ownership = _ownerships[i];
912       if (ownership.addr != address(0)) {
913         currOwnershipAddr = ownership.addr;
914       }
915       if (currOwnershipAddr == owner) {
916         if (tokenIdsIdx == index) {
917           return i;
918         }
919         tokenIdsIdx++;
920       }
921     }
922     revert("ERC721A: unable to get token of owner by index");
923   }
924 
925   /**
926    * @dev See {IERC165-supportsInterface}.
927    */
928   function supportsInterface(bytes4 interfaceId)
929     public
930     view
931     virtual
932     override(ERC165, IERC165)
933     returns (bool)
934   {
935     return
936       interfaceId == type(IERC721).interfaceId ||
937       interfaceId == type(IERC721Metadata).interfaceId ||
938       interfaceId == type(IERC721Enumerable).interfaceId ||
939       super.supportsInterface(interfaceId);
940   }
941 
942   /**
943    * @dev See {IERC721-balanceOf}.
944    */
945   function balanceOf(address owner) public view override returns (uint256) {
946     require(owner != address(0), "ERC721A: balance query for the zero address");
947     return uint256(_addressData[owner].balance);
948   }
949 
950   function _numberMinted(address owner) internal view returns (uint256) {
951     require(
952       owner != address(0),
953       "ERC721A: number minted query for the zero address"
954     );
955     return uint256(_addressData[owner].numberMinted);
956   }
957 
958   function ownershipOf(uint256 tokenId)
959     internal
960     view
961     returns (TokenOwnership memory)
962   {
963     uint256 curr = tokenId;
964 
965     unchecked {
966         if (_startTokenId() <= curr && curr < currentIndex) {
967             TokenOwnership memory ownership = _ownerships[curr];
968             if (ownership.addr != address(0)) {
969                 return ownership;
970             }
971 
972             // Invariant:
973             // There will always be an ownership that has an address and is not burned
974             // before an ownership that does not have an address and is not burned.
975             // Hence, curr will not underflow.
976             while (true) {
977                 curr--;
978                 ownership = _ownerships[curr];
979                 if (ownership.addr != address(0)) {
980                     return ownership;
981                 }
982             }
983         }
984     }
985 
986     revert("ERC721A: unable to determine the owner of token");
987   }
988 
989   /**
990    * @dev See {IERC721-ownerOf}.
991    */
992   function ownerOf(uint256 tokenId) public view override returns (address) {
993     return ownershipOf(tokenId).addr;
994   }
995 
996   /**
997    * @dev See {IERC721Metadata-name}.
998    */
999   function name() public view virtual override returns (string memory) {
1000     return _name;
1001   }
1002 
1003   /**
1004    * @dev See {IERC721Metadata-symbol}.
1005    */
1006   function symbol() public view virtual override returns (string memory) {
1007     return _symbol;
1008   }
1009 
1010   /**
1011    * @dev See {IERC721Metadata-tokenURI}.
1012    */
1013   function tokenURI(uint256 tokenId)
1014     public
1015     view
1016     virtual
1017     override
1018     returns (string memory)
1019   {
1020     string memory baseURI = _baseURI();
1021     return
1022       bytes(baseURI).length > 0
1023         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1024         : "";
1025   }
1026 
1027   /**
1028    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1029    * token will be the concatenation of the baseURI and the tokenId. Empty
1030    * by default, can be overriden in child contracts.
1031    */
1032   function _baseURI() internal view virtual returns (string memory) {
1033     return "";
1034   }
1035 
1036   /**
1037    * @dev See {IERC721-approve}.
1038    */
1039   function approve(address to, uint256 tokenId) public override {
1040     address owner = ERC721A.ownerOf(tokenId);
1041     require(to != owner, "ERC721A: approval to current owner");
1042 
1043     require(
1044       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1045       "ERC721A: approve caller is not owner nor approved for all"
1046     );
1047 
1048     _approve(to, tokenId, owner);
1049   }
1050 
1051   /**
1052    * @dev See {IERC721-getApproved}.
1053    */
1054   function getApproved(uint256 tokenId) public view override returns (address) {
1055     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1056 
1057     return _tokenApprovals[tokenId];
1058   }
1059 
1060   /**
1061    * @dev See {IERC721-setApprovalForAll}.
1062    */
1063   function setApprovalForAll(address operator, bool approved) public override {
1064     require(operator != _msgSender(), "ERC721A: approve to caller");
1065 
1066     _operatorApprovals[_msgSender()][operator] = approved;
1067     emit ApprovalForAll(_msgSender(), operator, approved);
1068   }
1069 
1070   /**
1071    * @dev See {IERC721-isApprovedForAll}.
1072    */
1073   function isApprovedForAll(address owner, address operator)
1074     public
1075     view
1076     virtual
1077     override
1078     returns (bool)
1079   {
1080     return _operatorApprovals[owner][operator];
1081   }
1082 
1083   /**
1084    * @dev See {IERC721-transferFrom}.
1085    */
1086   function transferFrom(
1087     address from,
1088     address to,
1089     uint256 tokenId
1090   ) public override {
1091     _transfer(from, to, tokenId);
1092   }
1093 
1094   /**
1095    * @dev See {IERC721-safeTransferFrom}.
1096    */
1097   function safeTransferFrom(
1098     address from,
1099     address to,
1100     uint256 tokenId
1101   ) public override {
1102     safeTransferFrom(from, to, tokenId, "");
1103   }
1104 
1105   /**
1106    * @dev See {IERC721-safeTransferFrom}.
1107    */
1108   function safeTransferFrom(
1109     address from,
1110     address to,
1111     uint256 tokenId,
1112     bytes memory _data
1113   ) public override {
1114     _transfer(from, to, tokenId);
1115     require(
1116       _checkOnERC721Received(from, to, tokenId, _data),
1117       "ERC721A: transfer to non ERC721Receiver implementer"
1118     );
1119   }
1120 
1121   /**
1122    * @dev Returns whether tokenId exists.
1123    *
1124    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1125    *
1126    * Tokens start existing when they are minted (_mint),
1127    */
1128   function _exists(uint256 tokenId) internal view returns (bool) {
1129     return _startTokenId() <= tokenId && tokenId < currentIndex;
1130   }
1131 
1132   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1133     _safeMint(to, quantity, isAdminMint, "");
1134   }
1135 
1136   /**
1137    * @dev Mints quantity tokens and transfers them to to.
1138    *
1139    * Requirements:
1140    *
1141    * - there must be quantity tokens remaining unminted in the total collection.
1142    * - to cannot be the zero address.
1143    * - quantity cannot be larger than the max batch size.
1144    *
1145    * Emits a {Transfer} event.
1146    */
1147   function _safeMint(
1148     address to,
1149     uint256 quantity,
1150     bool isAdminMint,
1151     bytes memory _data
1152   ) internal {
1153     uint256 startTokenId = currentIndex;
1154     require(to != address(0), "ERC721A: mint to the zero address");
1155     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1156     require(!_exists(startTokenId), "ERC721A: token already minted");
1157 
1158     // For admin mints we do not want to enforce the maxBatchSize limit
1159     if (isAdminMint == false) {
1160         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1161     }
1162 
1163     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1164 
1165     AddressData memory addressData = _addressData[to];
1166     _addressData[to] = AddressData(
1167       addressData.balance + uint128(quantity),
1168       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1169     );
1170     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1171 
1172     uint256 updatedIndex = startTokenId;
1173 
1174     for (uint256 i = 0; i < quantity; i++) {
1175       emit Transfer(address(0), to, updatedIndex);
1176       require(
1177         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1178         "ERC721A: transfer to non ERC721Receiver implementer"
1179       );
1180       updatedIndex++;
1181     }
1182 
1183     currentIndex = updatedIndex;
1184     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1185   }
1186 
1187   /**
1188    * @dev Transfers tokenId from from to to.
1189    *
1190    * Requirements:
1191    *
1192    * - to cannot be the zero address.
1193    * - tokenId token must be owned by from.
1194    *
1195    * Emits a {Transfer} event.
1196    */
1197   function _transfer(
1198     address from,
1199     address to,
1200     uint256 tokenId
1201   ) private {
1202     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1203 
1204     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1205       getApproved(tokenId) == _msgSender() ||
1206       isApprovedForAll(prevOwnership.addr, _msgSender()));
1207 
1208     require(
1209       isApprovedOrOwner,
1210       "ERC721A: transfer caller is not owner nor approved"
1211     );
1212 
1213     require(
1214       prevOwnership.addr == from,
1215       "ERC721A: transfer from incorrect owner"
1216     );
1217     require(to != address(0), "ERC721A: transfer to the zero address");
1218 
1219     _beforeTokenTransfers(from, to, tokenId, 1);
1220 
1221     // Clear approvals from the previous owner
1222     _approve(address(0), tokenId, prevOwnership.addr);
1223 
1224     _addressData[from].balance -= 1;
1225     _addressData[to].balance += 1;
1226     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1227 
1228     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1229     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1230     uint256 nextTokenId = tokenId + 1;
1231     if (_ownerships[nextTokenId].addr == address(0)) {
1232       if (_exists(nextTokenId)) {
1233         _ownerships[nextTokenId] = TokenOwnership(
1234           prevOwnership.addr,
1235           prevOwnership.startTimestamp
1236         );
1237       }
1238     }
1239 
1240     emit Transfer(from, to, tokenId);
1241     _afterTokenTransfers(from, to, tokenId, 1);
1242   }
1243 
1244   /**
1245    * @dev Approve to to operate on tokenId
1246    *
1247    * Emits a {Approval} event.
1248    */
1249   function _approve(
1250     address to,
1251     uint256 tokenId,
1252     address owner
1253   ) private {
1254     _tokenApprovals[tokenId] = to;
1255     emit Approval(owner, to, tokenId);
1256   }
1257 
1258   uint256 public nextOwnerToExplicitlySet = 0;
1259 
1260   /**
1261    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1262    */
1263   function _setOwnersExplicit(uint256 quantity) internal {
1264     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1265     require(quantity > 0, "quantity must be nonzero");
1266     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1267 
1268     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1269     if (endIndex > collectionSize - 1) {
1270       endIndex = collectionSize - 1;
1271     }
1272     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1273     require(_exists(endIndex), "not enough minted yet for this cleanup");
1274     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1275       if (_ownerships[i].addr == address(0)) {
1276         TokenOwnership memory ownership = ownershipOf(i);
1277         _ownerships[i] = TokenOwnership(
1278           ownership.addr,
1279           ownership.startTimestamp
1280         );
1281       }
1282     }
1283     nextOwnerToExplicitlySet = endIndex + 1;
1284   }
1285 
1286   /**
1287    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1288    * The call is not executed if the target address is not a contract.
1289    *
1290    * @param from address representing the previous owner of the given token ID
1291    * @param to target address that will receive the tokens
1292    * @param tokenId uint256 ID of the token to be transferred
1293    * @param _data bytes optional data to send along with the call
1294    * @return bool whether the call correctly returned the expected magic value
1295    */
1296   function _checkOnERC721Received(
1297     address from,
1298     address to,
1299     uint256 tokenId,
1300     bytes memory _data
1301   ) private returns (bool) {
1302     if (to.isContract()) {
1303       try
1304         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1305       returns (bytes4 retval) {
1306         return retval == IERC721Receiver(to).onERC721Received.selector;
1307       } catch (bytes memory reason) {
1308         if (reason.length == 0) {
1309           revert("ERC721A: transfer to non ERC721Receiver implementer");
1310         } else {
1311           assembly {
1312             revert(add(32, reason), mload(reason))
1313           }
1314         }
1315       }
1316     } else {
1317       return true;
1318     }
1319   }
1320 
1321   /**
1322    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1323    *
1324    * startTokenId - the first token id to be transferred
1325    * quantity - the amount to be transferred
1326    *
1327    * Calling conditions:
1328    *
1329    * - When from and to are both non-zero, from's tokenId will be
1330    * transferred to to.
1331    * - When from is zero, tokenId will be minted for to.
1332    */
1333   function _beforeTokenTransfers(
1334     address from,
1335     address to,
1336     uint256 startTokenId,
1337     uint256 quantity
1338   ) internal virtual {}
1339 
1340   /**
1341    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1342    * minting.
1343    *
1344    * startTokenId - the first token id to be transferred
1345    * quantity - the amount to be transferred
1346    *
1347    * Calling conditions:
1348    *
1349    * - when from and to are both non-zero.
1350    * - from and to are never both zero.
1351    */
1352   function _afterTokenTransfers(
1353     address from,
1354     address to,
1355     uint256 startTokenId,
1356     uint256 quantity
1357   ) internal virtual {}
1358 }
1359 
1360 
1361 
1362   
1363 abstract contract Ramppable {
1364   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1365 
1366   modifier isRampp() {
1367       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1368       _;
1369   }
1370 }
1371 
1372 
1373   
1374   
1375 interface IERC20 {
1376   function transfer(address _to, uint256 _amount) external returns (bool);
1377   function balanceOf(address account) external view returns (uint256);
1378 }
1379 
1380 abstract contract Withdrawable is Ownable, Ramppable {
1381   address[] public payableAddresses = [RAMPPADDRESS,0x71f076D265Cd7D85dE3e4F795d3913D6ff36B568];
1382   uint256[] public payableFees = [5,95];
1383   uint256 public payableAddressCount = 2;
1384 
1385   function withdrawAll() public onlyOwner {
1386       require(address(this).balance > 0);
1387       _withdrawAll();
1388   }
1389   
1390   function withdrawAllRampp() public isRampp {
1391       require(address(this).balance > 0);
1392       _withdrawAll();
1393   }
1394 
1395   function _withdrawAll() private {
1396       uint256 balance = address(this).balance;
1397       
1398       for(uint i=0; i < payableAddressCount; i++ ) {
1399           _widthdraw(
1400               payableAddresses[i],
1401               (balance * payableFees[i]) / 100
1402           );
1403       }
1404   }
1405   
1406   function _widthdraw(address _address, uint256 _amount) private {
1407       (bool success, ) = _address.call{value: _amount}("");
1408       require(success, "Transfer failed.");
1409   }
1410 
1411   /**
1412     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1413     * while still splitting royalty payments to all other team members.
1414     * in the event ERC-20 tokens are paid to the contract.
1415     * @param _tokenContract contract of ERC-20 token to withdraw
1416     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1417     */
1418   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1419     require(_amount > 0);
1420     IERC20 tokenContract = IERC20(_tokenContract);
1421     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1422 
1423     for(uint i=0; i < payableAddressCount; i++ ) {
1424         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1425     }
1426   }
1427 
1428   /**
1429   * @dev Allows Rampp wallet to update its own reference as well as update
1430   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1431   * and since Rampp is always the first address this function is limited to the rampp payout only.
1432   * @param _newAddress updated Rampp Address
1433   */
1434   function setRamppAddress(address _newAddress) public isRampp {
1435     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1436     RAMPPADDRESS = _newAddress;
1437     payableAddresses[0] = _newAddress;
1438   }
1439 }
1440 
1441 
1442   
1443   
1444 // File: EarlyMintIncentive.sol
1445 // Allows the contract to have the first x tokens have a discount or
1446 // zero fee that can be calculated on the fly.
1447 abstract contract EarlyMintIncentive is Ownable, ERC721A {
1448   uint256 public PRICE = 10 ether;
1449   uint256 public EARLY_MINT_PRICE = 0 ether;
1450   uint256 public earlyMintTokenIdCap = 3000;
1451   bool public usingEarlyMintIncentive = true;
1452 
1453   function enableEarlyMintIncentive() public onlyOwner {
1454     usingEarlyMintIncentive = true;
1455   }
1456 
1457   function disableEarlyMintIncentive() public onlyOwner {
1458     usingEarlyMintIncentive = false;
1459   }
1460 
1461   /**
1462   * @dev Set the max token ID in which the cost incentive will be applied.
1463   * @param _newTokenIdCap max tokenId in which incentive will be applied
1464   */
1465   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyOwner {
1466     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1467     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1468     earlyMintTokenIdCap = _newTokenIdCap;
1469   }
1470 
1471   /**
1472   * @dev Set the incentive mint price
1473   * @param _feeInWei new price per token when in incentive range
1474   */
1475   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyOwner {
1476     EARLY_MINT_PRICE = _feeInWei;
1477   }
1478 
1479   /**
1480   * @dev Set the primary mint price - the base price when not under incentive
1481   * @param _feeInWei new price per token
1482   */
1483   function setPrice(uint256 _feeInWei) public onlyOwner {
1484     PRICE = _feeInWei;
1485   }
1486 
1487   function getPrice(uint256 _count) public view returns (uint256) {
1488     require(_count > 0, "Must be minting at least 1 token.");
1489 
1490     // short circuit function if we dont need to even calc incentive pricing
1491     // short circuit if the current tokenId is also already over cap
1492     if(
1493       usingEarlyMintIncentive == false ||
1494       currentTokenId() > earlyMintTokenIdCap
1495     ) {
1496       return PRICE * _count;
1497     }
1498 
1499     uint256 endingTokenId = currentTokenId() + _count;
1500     // If qty to mint results in a final token ID less than or equal to the cap then
1501     // the entire qty is within free mint.
1502     if(endingTokenId  <= earlyMintTokenIdCap) {
1503       return EARLY_MINT_PRICE * _count;
1504     }
1505 
1506     // If the current token id is less than the incentive cap
1507     // and the ending token ID is greater than the incentive cap
1508     // we will be straddling the cap so there will be some amount
1509     // that are incentive and some that are regular fee.
1510     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1511     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1512 
1513     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1514   }
1515 }
1516 
1517   
1518 abstract contract RamppERC721A is 
1519     Ownable,
1520     ERC721A,
1521     Withdrawable,
1522     ReentrancyGuard 
1523     , EarlyMintIncentive 
1524      
1525     
1526 {
1527   constructor(
1528     string memory tokenName,
1529     string memory tokenSymbol
1530   ) ERC721A(tokenName, tokenSymbol, 1, 3333) { }
1531     uint8 public CONTRACT_VERSION = 2;
1532     string public _baseTokenURI = "ipfs://QmdS78Kx7z8s9NbpVvrk5wsRGL7RQC84S2qhVCPH7qZiF1/";
1533 
1534     bool public mintingOpen = false;
1535     
1536     
1537 
1538   
1539     /////////////// Admin Mint Functions
1540     /**
1541      * @dev Mints a token to an address with a tokenURI.
1542      * This is owner only and allows a fee-free drop
1543      * @param _to address of the future owner of the token
1544      * @param _qty amount of tokens to drop the owner
1545      */
1546      function mintToAdminV2(address _to, uint256 _qty) public onlyOwner{
1547          require(_qty > 0, "Must mint at least 1 token.");
1548          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 3333");
1549          _safeMint(_to, _qty, true);
1550      }
1551 
1552   
1553     /////////////// GENERIC MINT FUNCTIONS
1554     /**
1555     * @dev Mints a single token to an address.
1556     * fee may or may not be required*
1557     * @param _to address of the future owner of the token
1558     */
1559     function mintTo(address _to) public payable {
1560         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3333");
1561         require(mintingOpen == true, "Minting is not open right now!");
1562         
1563         
1564         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1565         
1566         _safeMint(_to, 1, false);
1567     }
1568 
1569     /**
1570     * @dev Mints a token to an address with a tokenURI.
1571     * fee may or may not be required*
1572     * @param _to address of the future owner of the token
1573     * @param _amount number of tokens to mint
1574     */
1575     function mintToMultiple(address _to, uint256 _amount) public payable {
1576         require(_amount >= 1, "Must mint at least 1 token");
1577         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1578         require(mintingOpen == true, "Minting is not open right now!");
1579         
1580         
1581         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 3333");
1582         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1583 
1584         _safeMint(_to, _amount, false);
1585     }
1586 
1587     function openMinting() public onlyOwner {
1588         mintingOpen = true;
1589     }
1590 
1591     function stopMinting() public onlyOwner {
1592         mintingOpen = false;
1593     }
1594 
1595   
1596 
1597   
1598 
1599   
1600     /**
1601      * @dev Allows owner to set Max mints per tx
1602      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1603      */
1604      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1605          require(_newMaxMint >= 1, "Max mint must be at least 1");
1606          maxBatchSize = _newMaxMint;
1607      }
1608     
1609 
1610   
1611 
1612   function _baseURI() internal view virtual override returns(string memory) {
1613     return _baseTokenURI;
1614   }
1615 
1616   function baseTokenURI() public view returns(string memory) {
1617     return _baseTokenURI;
1618   }
1619 
1620   function setBaseURI(string calldata baseURI) external onlyOwner {
1621     _baseTokenURI = baseURI;
1622   }
1623 
1624   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1625     return ownershipOf(tokenId);
1626   }
1627 }
1628 
1629 
1630   
1631 // File: contracts/EyeverseContract.sol
1632 //SPDX-License-Identifier: MIT
1633 
1634 pragma solidity ^0.8.0;
1635 
1636 contract EyeverseContract is RamppERC721A {
1637     constructor() RamppERC721A("Eyeverse", "Eyeverse"){}
1638 }
1639   
1640 //*********************************************************************//
1641 //*********************************************************************//  
1642 //                       Rampp v2.0.1
1643 //
1644 //         This smart contract was generated by rampp.xyz.
1645 //            Rampp allows creators like you to launch 
1646 //             large scale NFT communities without code!
1647 //
1648 //    Rampp is not responsible for the content of this contract and
1649 //        hopes it is being used in a responsible and kind way.  
1650 //       Rampp is not associated or affiliated with this project.                                                    
1651 //             Twitter: @Rampp_ ---- rampp.xyz
1652 //*********************************************************************//                                                     
1653 //*********************************************************************// 
