1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  _  _    __    _    _    __    ____  ____    _  _  _____  _  _  _____  ____  _____ 
5 // ( )/ )  /__\  ( \/\/ )  /__\  (_  _)(_  _)  ( )/ )(  _  )( )/ )(  _  )(  _ \(  _  )
6 //  )  (  /(__)\  )    (  /(__)\  _)(_  _)(_    )  (  )(_)(  )  (  )(_)(  )   / )(_)( 
7 // (_)\_)(__)(__)(__/\__)(__)(__)(____)(____)  (_)\_)(_____)(_)\_)(_____)(_)\_)(_____)
8 //
9 //*********************************************************************//
10 //*********************************************************************//
11   
12 //-------------DEPENDENCIES--------------------------//
13 
14 // File: @openzeppelin/contracts/utils/Address.sol
15 
16 
17 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
18 
19 pragma solidity ^0.8.1;
20 
21 /**
22  * @dev Collection of functions related to the address type
23  */
24 library Address {
25     /**
26      * @dev Returns true if account is a contract.
27      *
28      * [IMPORTANT]
29      * ====
30      * It is unsafe to assume that an address for which this function returns
31      * false is an externally-owned account (EOA) and not a contract.
32      *
33      * Among others, isContract will return false for the following
34      * types of addresses:
35      *
36      *  - an externally-owned account
37      *  - a contract in construction
38      *  - an address where a contract will be created
39      *  - an address where a contract lived, but was destroyed
40      * ====
41      *
42      * [IMPORTANT]
43      * ====
44      * You shouldn't rely on isContract to protect against flash loan attacks!
45      *
46      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
47      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
48      * constructor.
49      * ====
50      */
51     function isContract(address account) internal view returns (bool) {
52         // This method relies on extcodesize/address.code.length, which returns 0
53         // for contracts in construction, since the code is only stored at the end
54         // of the constructor execution.
55 
56         return account.code.length > 0;
57     }
58 
59     /**
60      * @dev Replacement for Solidity's transfer: sends amount wei to
61      * recipient, forwarding all available gas and reverting on errors.
62      *
63      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
64      * of certain opcodes, possibly making contracts go over the 2300 gas limit
65      * imposed by transfer, making them unable to receive funds via
66      * transfer. {sendValue} removes this limitation.
67      *
68      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
69      *
70      * IMPORTANT: because control is transferred to recipient, care must be
71      * taken to not create reentrancy vulnerabilities. Consider using
72      * {ReentrancyGuard} or the
73      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
74      */
75     function sendValue(address payable recipient, uint256 amount) internal {
76         require(address(this).balance >= amount, "Address: insufficient balance");
77 
78         (bool success, ) = recipient.call{value: amount}("");
79         require(success, "Address: unable to send value, recipient may have reverted");
80     }
81 
82     /**
83      * @dev Performs a Solidity function call using a low level call. A
84      * plain call is an unsafe replacement for a function call: use this
85      * function instead.
86      *
87      * If target reverts with a revert reason, it is bubbled up by this
88      * function (like regular Solidity function calls).
89      *
90      * Returns the raw returned data. To convert to the expected return value,
91      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
92      *
93      * Requirements:
94      *
95      * - target must be a contract.
96      * - calling target with data must not revert.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
101         return functionCall(target, data, "Address: low-level call failed");
102     }
103 
104     /**
105      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
106      * errorMessage as a fallback revert reason when target reverts.
107      *
108      * _Available since v3.1._
109      */
110     function functionCall(
111         address target,
112         bytes memory data,
113         string memory errorMessage
114     ) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
120      * but also transferring value wei to target.
121      *
122      * Requirements:
123      *
124      * - the calling contract must have an ETH balance of at least value.
125      * - the called Solidity function must be payable.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(
130         address target,
131         bytes memory data,
132         uint256 value
133     ) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
139      * with errorMessage as a fallback revert reason when target reverts.
140      *
141      * _Available since v3.1._
142      */
143     function functionCallWithValue(
144         address target,
145         bytes memory data,
146         uint256 value,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         require(address(this).balance >= value, "Address: insufficient balance for call");
150         require(isContract(target), "Address: call to non-contract");
151 
152         (bool success, bytes memory returndata) = target.call{value: value}(data);
153         return verifyCallResult(success, returndata, errorMessage);
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
163         return functionStaticCall(target, data, "Address: low-level static call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
168      * but performing a static call.
169      *
170      * _Available since v3.3._
171      */
172     function functionStaticCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal view returns (bytes memory) {
177         require(isContract(target), "Address: static call to non-contract");
178 
179         (bool success, bytes memory returndata) = target.staticcall(data);
180         return verifyCallResult(success, returndata, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
190         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
195      * but performing a delegate call.
196      *
197      * _Available since v3.4._
198      */
199     function functionDelegateCall(
200         address target,
201         bytes memory data,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         require(isContract(target), "Address: delegate call to non-contract");
205 
206         (bool success, bytes memory returndata) = target.delegatecall(data);
207         return verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
212      * revert reason using the provided one.
213      *
214      * _Available since v4.3._
215      */
216     function verifyCallResult(
217         bool success,
218         bytes memory returndata,
219         string memory errorMessage
220     ) internal pure returns (bytes memory) {
221         if (success) {
222             return returndata;
223         } else {
224             // Look for revert reason and bubble it up if present
225             if (returndata.length > 0) {
226                 // The easiest way to bubble the revert reason is using memory via assembly
227 
228                 assembly {
229                     let returndata_size := mload(returndata)
230                     revert(add(32, returndata), returndata_size)
231                 }
232             } else {
233                 revert(errorMessage);
234             }
235         }
236     }
237 }
238 
239 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
240 
241 
242 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @title ERC721 token receiver interface
248  * @dev Interface for any contract that wants to support safeTransfers
249  * from ERC721 asset contracts.
250  */
251 interface IERC721Receiver {
252     /**
253      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
254      * by operator from from, this function is called.
255      *
256      * It must return its Solidity selector to confirm the token transfer.
257      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
258      *
259      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
260      */
261     function onERC721Received(
262         address operator,
263         address from,
264         uint256 tokenId,
265         bytes calldata data
266     ) external returns (bytes4);
267 }
268 
269 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
270 
271 
272 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @dev Interface of the ERC165 standard, as defined in the
278  * https://eips.ethereum.org/EIPS/eip-165[EIP].
279  *
280  * Implementers can declare support of contract interfaces, which can then be
281  * queried by others ({ERC165Checker}).
282  *
283  * For an implementation, see {ERC165}.
284  */
285 interface IERC165 {
286     /**
287      * @dev Returns true if this contract implements the interface defined by
288      * interfaceId. See the corresponding
289      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
290      * to learn more about how these ids are created.
291      *
292      * This function call must use less than 30 000 gas.
293      */
294     function supportsInterface(bytes4 interfaceId) external view returns (bool);
295 }
296 
297 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 
305 /**
306  * @dev Implementation of the {IERC165} interface.
307  *
308  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
309  * for the additional interface id that will be supported. For example:
310  *
311  * solidity
312  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
314  * }
315  * 
316  *
317  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
318  */
319 abstract contract ERC165 is IERC165 {
320     /**
321      * @dev See {IERC165-supportsInterface}.
322      */
323     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
324         return interfaceId == type(IERC165).interfaceId;
325     }
326 }
327 
328 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
329 
330 
331 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 
336 /**
337  * @dev Required interface of an ERC721 compliant contract.
338  */
339 interface IERC721 is IERC165 {
340     /**
341      * @dev Emitted when tokenId token is transferred from from to to.
342      */
343     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
344 
345     /**
346      * @dev Emitted when owner enables approved to manage the tokenId token.
347      */
348     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
349 
350     /**
351      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
352      */
353     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
354 
355     /**
356      * @dev Returns the number of tokens in owner's account.
357      */
358     function balanceOf(address owner) external view returns (uint256 balance);
359 
360     /**
361      * @dev Returns the owner of the tokenId token.
362      *
363      * Requirements:
364      *
365      * - tokenId must exist.
366      */
367     function ownerOf(uint256 tokenId) external view returns (address owner);
368 
369     /**
370      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
371      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
372      *
373      * Requirements:
374      *
375      * - from cannot be the zero address.
376      * - to cannot be the zero address.
377      * - tokenId token must exist and be owned by from.
378      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
379      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
380      *
381      * Emits a {Transfer} event.
382      */
383     function safeTransferFrom(
384         address from,
385         address to,
386         uint256 tokenId
387     ) external;
388 
389     /**
390      * @dev Transfers tokenId token from from to to.
391      *
392      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
393      *
394      * Requirements:
395      *
396      * - from cannot be the zero address.
397      * - to cannot be the zero address.
398      * - tokenId token must be owned by from.
399      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
400      *
401      * Emits a {Transfer} event.
402      */
403     function transferFrom(
404         address from,
405         address to,
406         uint256 tokenId
407     ) external;
408 
409     /**
410      * @dev Gives permission to to to transfer tokenId token to another account.
411      * The approval is cleared when the token is transferred.
412      *
413      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
414      *
415      * Requirements:
416      *
417      * - The caller must own the token or be an approved operator.
418      * - tokenId must exist.
419      *
420      * Emits an {Approval} event.
421      */
422     function approve(address to, uint256 tokenId) external;
423 
424     /**
425      * @dev Returns the account approved for tokenId token.
426      *
427      * Requirements:
428      *
429      * - tokenId must exist.
430      */
431     function getApproved(uint256 tokenId) external view returns (address operator);
432 
433     /**
434      * @dev Approve or remove operator as an operator for the caller.
435      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
436      *
437      * Requirements:
438      *
439      * - The operator cannot be the caller.
440      *
441      * Emits an {ApprovalForAll} event.
442      */
443     function setApprovalForAll(address operator, bool _approved) external;
444 
445     /**
446      * @dev Returns if the operator is allowed to manage all of the assets of owner.
447      *
448      * See {setApprovalForAll}
449      */
450     function isApprovedForAll(address owner, address operator) external view returns (bool);
451 
452     /**
453      * @dev Safely transfers tokenId token from from to to.
454      *
455      * Requirements:
456      *
457      * - from cannot be the zero address.
458      * - to cannot be the zero address.
459      * - tokenId token must exist and be owned by from.
460      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
461      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
462      *
463      * Emits a {Transfer} event.
464      */
465     function safeTransferFrom(
466         address from,
467         address to,
468         uint256 tokenId,
469         bytes calldata data
470     ) external;
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
474 
475 
476 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 
481 /**
482  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
483  * @dev See https://eips.ethereum.org/EIPS/eip-721
484  */
485 interface IERC721Enumerable is IERC721 {
486     /**
487      * @dev Returns the total amount of tokens stored by the contract.
488      */
489     function totalSupply() external view returns (uint256);
490 
491     /**
492      * @dev Returns a token ID owned by owner at a given index of its token list.
493      * Use along with {balanceOf} to enumerate all of owner's tokens.
494      */
495     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
496 
497     /**
498      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
499      * Use along with {totalSupply} to enumerate all tokens.
500      */
501     function tokenByIndex(uint256 index) external view returns (uint256);
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
514  * @dev See https://eips.ethereum.org/EIPS/eip-721
515  */
516 interface IERC721Metadata is IERC721 {
517     /**
518      * @dev Returns the token collection name.
519      */
520     function name() external view returns (string memory);
521 
522     /**
523      * @dev Returns the token collection symbol.
524      */
525     function symbol() external view returns (string memory);
526 
527     /**
528      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
529      */
530     function tokenURI(uint256 tokenId) external view returns (string memory);
531 }
532 
533 // File: @openzeppelin/contracts/utils/Strings.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @dev String operations.
542  */
543 library Strings {
544     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
545 
546     /**
547      * @dev Converts a uint256 to its ASCII string decimal representation.
548      */
549     function toString(uint256 value) internal pure returns (string memory) {
550         // Inspired by OraclizeAPI's implementation - MIT licence
551         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
552 
553         if (value == 0) {
554             return "0";
555         }
556         uint256 temp = value;
557         uint256 digits;
558         while (temp != 0) {
559             digits++;
560             temp /= 10;
561         }
562         bytes memory buffer = new bytes(digits);
563         while (value != 0) {
564             digits -= 1;
565             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
566             value /= 10;
567         }
568         return string(buffer);
569     }
570 
571     /**
572      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
573      */
574     function toHexString(uint256 value) internal pure returns (string memory) {
575         if (value == 0) {
576             return "0x00";
577         }
578         uint256 temp = value;
579         uint256 length = 0;
580         while (temp != 0) {
581             length++;
582             temp >>= 8;
583         }
584         return toHexString(value, length);
585     }
586 
587     /**
588      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
589      */
590     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
591         bytes memory buffer = new bytes(2 * length + 2);
592         buffer[0] = "0";
593         buffer[1] = "x";
594         for (uint256 i = 2 * length + 1; i > 1; --i) {
595             buffer[i] = _HEX_SYMBOLS[value & 0xf];
596             value >>= 4;
597         }
598         require(value == 0, "Strings: hex length insufficient");
599         return string(buffer);
600     }
601 }
602 
603 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
604 
605 
606 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 /**
611  * @dev Contract module that helps prevent reentrant calls to a function.
612  *
613  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
614  * available, which can be applied to functions to make sure there are no nested
615  * (reentrant) calls to them.
616  *
617  * Note that because there is a single nonReentrant guard, functions marked as
618  * nonReentrant may not call one another. This can be worked around by making
619  * those functions private, and then adding external nonReentrant entry
620  * points to them.
621  *
622  * TIP: If you would like to learn more about reentrancy and alternative ways
623  * to protect against it, check out our blog post
624  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
625  */
626 abstract contract ReentrancyGuard {
627     // Booleans are more expensive than uint256 or any type that takes up a full
628     // word because each write operation emits an extra SLOAD to first read the
629     // slot's contents, replace the bits taken up by the boolean, and then write
630     // back. This is the compiler's defense against contract upgrades and
631     // pointer aliasing, and it cannot be disabled.
632 
633     // The values being non-zero value makes deployment a bit more expensive,
634     // but in exchange the refund on every call to nonReentrant will be lower in
635     // amount. Since refunds are capped to a percentage of the total
636     // transaction's gas, it is best to keep them low in cases like this one, to
637     // increase the likelihood of the full refund coming into effect.
638     uint256 private constant _NOT_ENTERED = 1;
639     uint256 private constant _ENTERED = 2;
640 
641     uint256 private _status;
642 
643     constructor() {
644         _status = _NOT_ENTERED;
645     }
646 
647     /**
648      * @dev Prevents a contract from calling itself, directly or indirectly.
649      * Calling a nonReentrant function from another nonReentrant
650      * function is not supported. It is possible to prevent this from happening
651      * by making the nonReentrant function external, and making it call a
652      * private function that does the actual work.
653      */
654     modifier nonReentrant() {
655         // On the first call to nonReentrant, _notEntered will be true
656         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
657 
658         // Any calls to nonReentrant after this point will fail
659         _status = _ENTERED;
660 
661         _;
662 
663         // By storing the original value once again, a refund is triggered (see
664         // https://eips.ethereum.org/EIPS/eip-2200)
665         _status = _NOT_ENTERED;
666     }
667 }
668 
669 // File: @openzeppelin/contracts/utils/Context.sol
670 
671 
672 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @dev Provides information about the current execution context, including the
678  * sender of the transaction and its data. While these are generally available
679  * via msg.sender and msg.data, they should not be accessed in such a direct
680  * manner, since when dealing with meta-transactions the account sending and
681  * paying for execution may not be the actual sender (as far as an application
682  * is concerned).
683  *
684  * This contract is only required for intermediate, library-like contracts.
685  */
686 abstract contract Context {
687     function _msgSender() internal view virtual returns (address) {
688         return msg.sender;
689     }
690 
691     function _msgData() internal view virtual returns (bytes calldata) {
692         return msg.data;
693     }
694 }
695 
696 // File: @openzeppelin/contracts/access/Ownable.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @dev Contract module which provides a basic access control mechanism, where
706  * there is an account (an owner) that can be granted exclusive access to
707  * specific functions.
708  *
709  * By default, the owner account will be the one that deploys the contract. This
710  * can later be changed with {transferOwnership}.
711  *
712  * This module is used through inheritance. It will make available the modifier
713  * onlyOwner, which can be applied to your functions to restrict their use to
714  * the owner.
715  */
716 abstract contract Ownable is Context {
717     address private _owner;
718 
719     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
720 
721     /**
722      * @dev Initializes the contract setting the deployer as the initial owner.
723      */
724     constructor() {
725         _transferOwnership(_msgSender());
726     }
727 
728     /**
729      * @dev Returns the address of the current owner.
730      */
731     function owner() public view virtual returns (address) {
732         return _owner;
733     }
734 
735     /**
736      * @dev Throws if called by any account other than the owner.
737      */
738     modifier onlyOwner() {
739         require(owner() == _msgSender(), "Ownable: caller is not the owner");
740         _;
741     }
742 
743     /**
744      * @dev Leaves the contract without owner. It will not be possible to call
745      * onlyOwner functions anymore. Can only be called by the current owner.
746      *
747      * NOTE: Renouncing ownership will leave the contract without an owner,
748      * thereby removing any functionality that is only available to the owner.
749      */
750     function renounceOwnership() public virtual onlyOwner {
751         _transferOwnership(address(0));
752     }
753 
754     /**
755      * @dev Transfers ownership of the contract to a new account (newOwner).
756      * Can only be called by the current owner.
757      */
758     function transferOwnership(address newOwner) public virtual onlyOwner {
759         require(newOwner != address(0), "Ownable: new owner is the zero address");
760         _transferOwnership(newOwner);
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (newOwner).
765      * Internal function without access restriction.
766      */
767     function _transferOwnership(address newOwner) internal virtual {
768         address oldOwner = _owner;
769         _owner = newOwner;
770         emit OwnershipTransferred(oldOwner, newOwner);
771     }
772 }
773 //-------------END DEPENDENCIES------------------------//
774 
775 
776   
777 // Rampp Contracts v2.1 (Teams.sol)
778 
779 pragma solidity ^0.8.0;
780 
781 /**
782 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
783 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
784 * This will easily allow cross-collaboration via Mintplex.xyz.
785 **/
786 abstract contract Teams is Ownable{
787   mapping (address => bool) internal team;
788 
789   /**
790   * @dev Adds an address to the team. Allows them to execute protected functions
791   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
792   **/
793   function addToTeam(address _address) public onlyOwner {
794     require(_address != address(0), "Invalid address");
795     require(!inTeam(_address), "This address is already in your team.");
796   
797     team[_address] = true;
798   }
799 
800   /**
801   * @dev Removes an address to the team.
802   * @param _address the ETH address to remove, cannot be 0x and must be in team
803   **/
804   function removeFromTeam(address _address) public onlyOwner {
805     require(_address != address(0), "Invalid address");
806     require(inTeam(_address), "This address is not in your team currently.");
807   
808     team[_address] = false;
809   }
810 
811   /**
812   * @dev Check if an address is valid and active in the team
813   * @param _address ETH address to check for truthiness
814   **/
815   function inTeam(address _address)
816     public
817     view
818     returns (bool)
819   {
820     require(_address != address(0), "Invalid address to check.");
821     return team[_address] == true;
822   }
823 
824   /**
825   * @dev Throws if called by any account other than the owner or team member.
826   */
827   modifier onlyTeamOrOwner() {
828     bool _isOwner = owner() == _msgSender();
829     bool _isTeam = inTeam(_msgSender());
830     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
831     _;
832   }
833 }
834 
835 
836   
837   pragma solidity ^0.8.0;
838 
839   /**
840   * @dev These functions deal with verification of Merkle Trees proofs.
841   *
842   * The proofs can be generated using the JavaScript library
843   * https://github.com/miguelmota/merkletreejs[merkletreejs].
844   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
845   *
846   *
847   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
848   * hashing, or use a hash function other than keccak256 for hashing leaves.
849   * This is because the concatenation of a sorted pair of internal nodes in
850   * the merkle tree could be reinterpreted as a leaf value.
851   */
852   library MerkleProof {
853       /**
854       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
855       * defined by 'root'. For this, a 'proof' must be provided, containing
856       * sibling hashes on the branch from the leaf to the root of the tree. Each
857       * pair of leaves and each pair of pre-images are assumed to be sorted.
858       */
859       function verify(
860           bytes32[] memory proof,
861           bytes32 root,
862           bytes32 leaf
863       ) internal pure returns (bool) {
864           return processProof(proof, leaf) == root;
865       }
866 
867       /**
868       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
869       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
870       * hash matches the root of the tree. When processing the proof, the pairs
871       * of leafs & pre-images are assumed to be sorted.
872       *
873       * _Available since v4.4._
874       */
875       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
876           bytes32 computedHash = leaf;
877           for (uint256 i = 0; i < proof.length; i++) {
878               bytes32 proofElement = proof[i];
879               if (computedHash <= proofElement) {
880                   // Hash(current computed hash + current element of the proof)
881                   computedHash = _efficientHash(computedHash, proofElement);
882               } else {
883                   // Hash(current element of the proof + current computed hash)
884                   computedHash = _efficientHash(proofElement, computedHash);
885               }
886           }
887           return computedHash;
888       }
889 
890       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
891           assembly {
892               mstore(0x00, a)
893               mstore(0x20, b)
894               value := keccak256(0x00, 0x40)
895           }
896       }
897   }
898 
899 
900   // File: Allowlist.sol
901 
902   pragma solidity ^0.8.0;
903 
904   abstract contract Allowlist is Teams {
905     bytes32 public merkleRoot;
906     bool public onlyAllowlistMode = false;
907 
908     /**
909      * @dev Update merkle root to reflect changes in Allowlist
910      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
911      */
912     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
913       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
914       merkleRoot = _newMerkleRoot;
915     }
916 
917     /**
918      * @dev Check the proof of an address if valid for merkle root
919      * @param _to address to check for proof
920      * @param _merkleProof Proof of the address to validate against root and leaf
921      */
922     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
923       require(merkleRoot != 0, "Merkle root is not set!");
924       bytes32 leaf = keccak256(abi.encodePacked(_to));
925 
926       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
927     }
928 
929     
930     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
931       onlyAllowlistMode = true;
932     }
933 
934     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
935         onlyAllowlistMode = false;
936     }
937   }
938   
939   
940 /**
941  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
942  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
943  *
944  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
945  * 
946  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
947  *
948  * Does not support burning tokens to address(0).
949  */
950 contract ERC721A is
951   Context,
952   ERC165,
953   IERC721,
954   IERC721Metadata,
955   IERC721Enumerable,
956   Teams
957 {
958   using Address for address;
959   using Strings for uint256;
960 
961   struct TokenOwnership {
962     address addr;
963     uint64 startTimestamp;
964   }
965 
966   struct AddressData {
967     uint128 balance;
968     uint128 numberMinted;
969   }
970 
971   uint256 private currentIndex;
972 
973   uint256 public immutable collectionSize;
974   uint256 public maxBatchSize;
975 
976   // Token name
977   string private _name;
978 
979   // Token symbol
980   string private _symbol;
981 
982   // Mapping from token ID to ownership details
983   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
984   mapping(uint256 => TokenOwnership) private _ownerships;
985 
986   // Mapping owner address to address data
987   mapping(address => AddressData) private _addressData;
988 
989   // Mapping from token ID to approved address
990   mapping(uint256 => address) private _tokenApprovals;
991 
992   // Mapping from owner to operator approvals
993   mapping(address => mapping(address => bool)) private _operatorApprovals;
994 
995   /* @dev Mapping of restricted operator approvals set by contract Owner
996   * This serves as an optional addition to ERC-721 so
997   * that the contract owner can elect to prevent specific addresses/contracts
998   * from being marked as the approver for a token. The reason for this
999   * is that some projects may want to retain control of where their tokens can/can not be listed
1000   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1001   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1002   */
1003   mapping(address => bool) public restrictedApprovalAddresses;
1004 
1005   /**
1006    * @dev
1007    * maxBatchSize refers to how much a minter can mint at a time.
1008    * collectionSize_ refers to how many tokens are in the collection.
1009    */
1010   constructor(
1011     string memory name_,
1012     string memory symbol_,
1013     uint256 maxBatchSize_,
1014     uint256 collectionSize_
1015   ) {
1016     require(
1017       collectionSize_ > 0,
1018       "ERC721A: collection must have a nonzero supply"
1019     );
1020     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1021     _name = name_;
1022     _symbol = symbol_;
1023     maxBatchSize = maxBatchSize_;
1024     collectionSize = collectionSize_;
1025     currentIndex = _startTokenId();
1026   }
1027 
1028   /**
1029   * To change the starting tokenId, please override this function.
1030   */
1031   function _startTokenId() internal view virtual returns (uint256) {
1032     return 1;
1033   }
1034 
1035   /**
1036    * @dev See {IERC721Enumerable-totalSupply}.
1037    */
1038   function totalSupply() public view override returns (uint256) {
1039     return _totalMinted();
1040   }
1041 
1042   function currentTokenId() public view returns (uint256) {
1043     return _totalMinted();
1044   }
1045 
1046   function getNextTokenId() public view returns (uint256) {
1047       return _totalMinted() + 1;
1048   }
1049 
1050   /**
1051   * Returns the total amount of tokens minted in the contract.
1052   */
1053   function _totalMinted() internal view returns (uint256) {
1054     unchecked {
1055       return currentIndex - _startTokenId();
1056     }
1057   }
1058 
1059   /**
1060    * @dev See {IERC721Enumerable-tokenByIndex}.
1061    */
1062   function tokenByIndex(uint256 index) public view override returns (uint256) {
1063     require(index < totalSupply(), "ERC721A: global index out of bounds");
1064     return index;
1065   }
1066 
1067   /**
1068    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1069    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1070    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1071    */
1072   function tokenOfOwnerByIndex(address owner, uint256 index)
1073     public
1074     view
1075     override
1076     returns (uint256)
1077   {
1078     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1079     uint256 numMintedSoFar = totalSupply();
1080     uint256 tokenIdsIdx = 0;
1081     address currOwnershipAddr = address(0);
1082     for (uint256 i = 0; i < numMintedSoFar; i++) {
1083       TokenOwnership memory ownership = _ownerships[i];
1084       if (ownership.addr != address(0)) {
1085         currOwnershipAddr = ownership.addr;
1086       }
1087       if (currOwnershipAddr == owner) {
1088         if (tokenIdsIdx == index) {
1089           return i;
1090         }
1091         tokenIdsIdx++;
1092       }
1093     }
1094     revert("ERC721A: unable to get token of owner by index");
1095   }
1096 
1097   /**
1098    * @dev See {IERC165-supportsInterface}.
1099    */
1100   function supportsInterface(bytes4 interfaceId)
1101     public
1102     view
1103     virtual
1104     override(ERC165, IERC165)
1105     returns (bool)
1106   {
1107     return
1108       interfaceId == type(IERC721).interfaceId ||
1109       interfaceId == type(IERC721Metadata).interfaceId ||
1110       interfaceId == type(IERC721Enumerable).interfaceId ||
1111       super.supportsInterface(interfaceId);
1112   }
1113 
1114   /**
1115    * @dev See {IERC721-balanceOf}.
1116    */
1117   function balanceOf(address owner) public view override returns (uint256) {
1118     require(owner != address(0), "ERC721A: balance query for the zero address");
1119     return uint256(_addressData[owner].balance);
1120   }
1121 
1122   function _numberMinted(address owner) internal view returns (uint256) {
1123     require(
1124       owner != address(0),
1125       "ERC721A: number minted query for the zero address"
1126     );
1127     return uint256(_addressData[owner].numberMinted);
1128   }
1129 
1130   function ownershipOf(uint256 tokenId)
1131     internal
1132     view
1133     returns (TokenOwnership memory)
1134   {
1135     uint256 curr = tokenId;
1136 
1137     unchecked {
1138         if (_startTokenId() <= curr && curr < currentIndex) {
1139             TokenOwnership memory ownership = _ownerships[curr];
1140             if (ownership.addr != address(0)) {
1141                 return ownership;
1142             }
1143 
1144             // Invariant:
1145             // There will always be an ownership that has an address and is not burned
1146             // before an ownership that does not have an address and is not burned.
1147             // Hence, curr will not underflow.
1148             while (true) {
1149                 curr--;
1150                 ownership = _ownerships[curr];
1151                 if (ownership.addr != address(0)) {
1152                     return ownership;
1153                 }
1154             }
1155         }
1156     }
1157 
1158     revert("ERC721A: unable to determine the owner of token");
1159   }
1160 
1161   /**
1162    * @dev See {IERC721-ownerOf}.
1163    */
1164   function ownerOf(uint256 tokenId) public view override returns (address) {
1165     return ownershipOf(tokenId).addr;
1166   }
1167 
1168   /**
1169    * @dev See {IERC721Metadata-name}.
1170    */
1171   function name() public view virtual override returns (string memory) {
1172     return _name;
1173   }
1174 
1175   /**
1176    * @dev See {IERC721Metadata-symbol}.
1177    */
1178   function symbol() public view virtual override returns (string memory) {
1179     return _symbol;
1180   }
1181 
1182   /**
1183    * @dev See {IERC721Metadata-tokenURI}.
1184    */
1185   function tokenURI(uint256 tokenId)
1186     public
1187     view
1188     virtual
1189     override
1190     returns (string memory)
1191   {
1192     string memory baseURI = _baseURI();
1193     string memory extension = _baseURIExtension();
1194     return
1195       bytes(baseURI).length > 0
1196         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
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
1210    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1211    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1212    * by default, can be overriden in child contracts.
1213    */
1214   function _baseURIExtension() internal view virtual returns (string memory) {
1215     return "";
1216   }
1217 
1218   /**
1219    * @dev Sets the value for an address to be in the restricted approval address pool.
1220    * Setting an address to true will disable token owners from being able to mark the address
1221    * for approval for trading. This would be used in theory to prevent token owners from listing
1222    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1223    * @param _address the marketplace/user to modify restriction status of
1224    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1225    */
1226   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1227     restrictedApprovalAddresses[_address] = _isRestricted;
1228   }
1229 
1230   /**
1231    * @dev See {IERC721-approve}.
1232    */
1233   function approve(address to, uint256 tokenId) public override {
1234     address owner = ERC721A.ownerOf(tokenId);
1235     require(to != owner, "ERC721A: approval to current owner");
1236     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1237 
1238     require(
1239       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1240       "ERC721A: approve caller is not owner nor approved for all"
1241     );
1242 
1243     _approve(to, tokenId, owner);
1244   }
1245 
1246   /**
1247    * @dev See {IERC721-getApproved}.
1248    */
1249   function getApproved(uint256 tokenId) public view override returns (address) {
1250     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1251 
1252     return _tokenApprovals[tokenId];
1253   }
1254 
1255   /**
1256    * @dev See {IERC721-setApprovalForAll}.
1257    */
1258   function setApprovalForAll(address operator, bool approved) public override {
1259     require(operator != _msgSender(), "ERC721A: approve to caller");
1260     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1261 
1262     _operatorApprovals[_msgSender()][operator] = approved;
1263     emit ApprovalForAll(_msgSender(), operator, approved);
1264   }
1265 
1266   /**
1267    * @dev See {IERC721-isApprovedForAll}.
1268    */
1269   function isApprovedForAll(address owner, address operator)
1270     public
1271     view
1272     virtual
1273     override
1274     returns (bool)
1275   {
1276     return _operatorApprovals[owner][operator];
1277   }
1278 
1279   /**
1280    * @dev See {IERC721-transferFrom}.
1281    */
1282   function transferFrom(
1283     address from,
1284     address to,
1285     uint256 tokenId
1286   ) public override {
1287     _transfer(from, to, tokenId);
1288   }
1289 
1290   /**
1291    * @dev See {IERC721-safeTransferFrom}.
1292    */
1293   function safeTransferFrom(
1294     address from,
1295     address to,
1296     uint256 tokenId
1297   ) public override {
1298     safeTransferFrom(from, to, tokenId, "");
1299   }
1300 
1301   /**
1302    * @dev See {IERC721-safeTransferFrom}.
1303    */
1304   function safeTransferFrom(
1305     address from,
1306     address to,
1307     uint256 tokenId,
1308     bytes memory _data
1309   ) public override {
1310     _transfer(from, to, tokenId);
1311     require(
1312       _checkOnERC721Received(from, to, tokenId, _data),
1313       "ERC721A: transfer to non ERC721Receiver implementer"
1314     );
1315   }
1316 
1317   /**
1318    * @dev Returns whether tokenId exists.
1319    *
1320    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1321    *
1322    * Tokens start existing when they are minted (_mint),
1323    */
1324   function _exists(uint256 tokenId) internal view returns (bool) {
1325     return _startTokenId() <= tokenId && tokenId < currentIndex;
1326   }
1327 
1328   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1329     _safeMint(to, quantity, isAdminMint, "");
1330   }
1331 
1332   /**
1333    * @dev Mints quantity tokens and transfers them to to.
1334    *
1335    * Requirements:
1336    *
1337    * - there must be quantity tokens remaining unminted in the total collection.
1338    * - to cannot be the zero address.
1339    * - quantity cannot be larger than the max batch size.
1340    *
1341    * Emits a {Transfer} event.
1342    */
1343   function _safeMint(
1344     address to,
1345     uint256 quantity,
1346     bool isAdminMint,
1347     bytes memory _data
1348   ) internal {
1349     uint256 startTokenId = currentIndex;
1350     require(to != address(0), "ERC721A: mint to the zero address");
1351     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1352     require(!_exists(startTokenId), "ERC721A: token already minted");
1353 
1354     // For admin mints we do not want to enforce the maxBatchSize limit
1355     if (isAdminMint == false) {
1356         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1357     }
1358 
1359     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1360 
1361     AddressData memory addressData = _addressData[to];
1362     _addressData[to] = AddressData(
1363       addressData.balance + uint128(quantity),
1364       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1365     );
1366     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1367 
1368     uint256 updatedIndex = startTokenId;
1369 
1370     for (uint256 i = 0; i < quantity; i++) {
1371       emit Transfer(address(0), to, updatedIndex);
1372       require(
1373         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1374         "ERC721A: transfer to non ERC721Receiver implementer"
1375       );
1376       updatedIndex++;
1377     }
1378 
1379     currentIndex = updatedIndex;
1380     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1381   }
1382 
1383   /**
1384    * @dev Transfers tokenId from from to to.
1385    *
1386    * Requirements:
1387    *
1388    * - to cannot be the zero address.
1389    * - tokenId token must be owned by from.
1390    *
1391    * Emits a {Transfer} event.
1392    */
1393   function _transfer(
1394     address from,
1395     address to,
1396     uint256 tokenId
1397   ) private {
1398     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1399 
1400     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1401       getApproved(tokenId) == _msgSender() ||
1402       isApprovedForAll(prevOwnership.addr, _msgSender()));
1403 
1404     require(
1405       isApprovedOrOwner,
1406       "ERC721A: transfer caller is not owner nor approved"
1407     );
1408 
1409     require(
1410       prevOwnership.addr == from,
1411       "ERC721A: transfer from incorrect owner"
1412     );
1413     require(to != address(0), "ERC721A: transfer to the zero address");
1414 
1415     _beforeTokenTransfers(from, to, tokenId, 1);
1416 
1417     // Clear approvals from the previous owner
1418     _approve(address(0), tokenId, prevOwnership.addr);
1419 
1420     _addressData[from].balance -= 1;
1421     _addressData[to].balance += 1;
1422     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1423 
1424     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1425     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1426     uint256 nextTokenId = tokenId + 1;
1427     if (_ownerships[nextTokenId].addr == address(0)) {
1428       if (_exists(nextTokenId)) {
1429         _ownerships[nextTokenId] = TokenOwnership(
1430           prevOwnership.addr,
1431           prevOwnership.startTimestamp
1432         );
1433       }
1434     }
1435 
1436     emit Transfer(from, to, tokenId);
1437     _afterTokenTransfers(from, to, tokenId, 1);
1438   }
1439 
1440   /**
1441    * @dev Approve to to operate on tokenId
1442    *
1443    * Emits a {Approval} event.
1444    */
1445   function _approve(
1446     address to,
1447     uint256 tokenId,
1448     address owner
1449   ) private {
1450     _tokenApprovals[tokenId] = to;
1451     emit Approval(owner, to, tokenId);
1452   }
1453 
1454   uint256 public nextOwnerToExplicitlySet = 0;
1455 
1456   /**
1457    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1458    */
1459   function _setOwnersExplicit(uint256 quantity) internal {
1460     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1461     require(quantity > 0, "quantity must be nonzero");
1462     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1463 
1464     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1465     if (endIndex > collectionSize - 1) {
1466       endIndex = collectionSize - 1;
1467     }
1468     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1469     require(_exists(endIndex), "not enough minted yet for this cleanup");
1470     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1471       if (_ownerships[i].addr == address(0)) {
1472         TokenOwnership memory ownership = ownershipOf(i);
1473         _ownerships[i] = TokenOwnership(
1474           ownership.addr,
1475           ownership.startTimestamp
1476         );
1477       }
1478     }
1479     nextOwnerToExplicitlySet = endIndex + 1;
1480   }
1481 
1482   /**
1483    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1484    * The call is not executed if the target address is not a contract.
1485    *
1486    * @param from address representing the previous owner of the given token ID
1487    * @param to target address that will receive the tokens
1488    * @param tokenId uint256 ID of the token to be transferred
1489    * @param _data bytes optional data to send along with the call
1490    * @return bool whether the call correctly returned the expected magic value
1491    */
1492   function _checkOnERC721Received(
1493     address from,
1494     address to,
1495     uint256 tokenId,
1496     bytes memory _data
1497   ) private returns (bool) {
1498     if (to.isContract()) {
1499       try
1500         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1501       returns (bytes4 retval) {
1502         return retval == IERC721Receiver(to).onERC721Received.selector;
1503       } catch (bytes memory reason) {
1504         if (reason.length == 0) {
1505           revert("ERC721A: transfer to non ERC721Receiver implementer");
1506         } else {
1507           assembly {
1508             revert(add(32, reason), mload(reason))
1509           }
1510         }
1511       }
1512     } else {
1513       return true;
1514     }
1515   }
1516 
1517   /**
1518    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1519    *
1520    * startTokenId - the first token id to be transferred
1521    * quantity - the amount to be transferred
1522    *
1523    * Calling conditions:
1524    *
1525    * - When from and to are both non-zero, from's tokenId will be
1526    * transferred to to.
1527    * - When from is zero, tokenId will be minted for to.
1528    */
1529   function _beforeTokenTransfers(
1530     address from,
1531     address to,
1532     uint256 startTokenId,
1533     uint256 quantity
1534   ) internal virtual {}
1535 
1536   /**
1537    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1538    * minting.
1539    *
1540    * startTokenId - the first token id to be transferred
1541    * quantity - the amount to be transferred
1542    *
1543    * Calling conditions:
1544    *
1545    * - when from and to are both non-zero.
1546    * - from and to are never both zero.
1547    */
1548   function _afterTokenTransfers(
1549     address from,
1550     address to,
1551     uint256 startTokenId,
1552     uint256 quantity
1553   ) internal virtual {}
1554 }
1555 
1556 
1557 
1558   
1559 abstract contract Ramppable {
1560   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1561 
1562   modifier isRampp() {
1563       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1564       _;
1565   }
1566 }
1567 
1568 
1569   
1570 /** TimedDrop.sol
1571 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1572 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1573 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1574 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1575 */
1576 abstract contract TimedDrop is Teams {
1577   bool public enforcePublicDropTime = true;
1578   uint256 public publicDropTime = 1668304800;
1579   
1580   /**
1581   * @dev Allow the contract owner to set the public time to mint.
1582   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1583   */
1584   function setPublicDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1585     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disablePublicDropTime!");
1586     publicDropTime = _newDropTime;
1587   }
1588 
1589   function usePublicDropTime() public onlyTeamOrOwner {
1590     enforcePublicDropTime = true;
1591   }
1592 
1593   function disablePublicDropTime() public onlyTeamOrOwner {
1594     enforcePublicDropTime = false;
1595   }
1596 
1597   /**
1598   * @dev determine if the public droptime has passed.
1599   * if the feature is disabled then assume the time has passed.
1600   */
1601   function publicDropTimePassed() public view returns(bool) {
1602     if(enforcePublicDropTime == false) {
1603       return true;
1604     }
1605     return block.timestamp >= publicDropTime;
1606   }
1607   
1608   // Allowlist implementation of the Timed Drop feature
1609   bool public enforceAllowlistDropTime = true;
1610   uint256 public allowlistDropTime = 1668218400;
1611 
1612   /**
1613   * @dev Allow the contract owner to set the allowlist time to mint.
1614   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1615   */
1616   function setAllowlistDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1617     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disableAllowlistDropTime!");
1618     allowlistDropTime = _newDropTime;
1619   }
1620 
1621   function useAllowlistDropTime() public onlyTeamOrOwner {
1622     enforceAllowlistDropTime = true;
1623   }
1624 
1625   function disableAllowlistDropTime() public onlyTeamOrOwner {
1626     enforceAllowlistDropTime = false;
1627   }
1628 
1629   function allowlistDropTimePassed() public view returns(bool) {
1630     if(enforceAllowlistDropTime == false) {
1631       return true;
1632     }
1633 
1634     return block.timestamp >= allowlistDropTime;
1635   }
1636 }
1637 
1638   
1639 interface IERC20 {
1640   function allowance(address owner, address spender) external view returns (uint256);
1641   function transfer(address _to, uint256 _amount) external returns (bool);
1642   function balanceOf(address account) external view returns (uint256);
1643   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1644 }
1645 
1646 // File: WithdrawableV2
1647 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1648 // ERC-20 Payouts are limited to a single payout address. This feature 
1649 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1650 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1651 abstract contract WithdrawableV2 is Teams, Ramppable {
1652   struct acceptedERC20 {
1653     bool isActive;
1654     uint256 chargeAmount;
1655   }
1656 
1657   
1658   mapping(address => acceptedERC20) private allowedTokenContracts;
1659   address[] public payableAddresses = [0xA6346fE900b2a3c93C02d18F53324543219C60F7];
1660   address public erc20Payable = 0xA6346fE900b2a3c93C02d18F53324543219C60F7;
1661   uint256[] public payableFees = [100];
1662   uint256 public payableAddressCount = 1;
1663   bool public onlyERC20MintingMode = false;
1664   
1665 
1666   /**
1667   * @dev Calculates the true payable balance of the contract
1668   */
1669   function calcAvailableBalance() public view returns(uint256) {
1670     return address(this).balance;
1671   }
1672 
1673   function withdrawAll() public onlyTeamOrOwner {
1674       require(calcAvailableBalance() > 0);
1675       _withdrawAll();
1676   }
1677   
1678   function withdrawAllRampp() public isRampp {
1679       require(calcAvailableBalance() > 0);
1680       _withdrawAll();
1681   }
1682 
1683   function _withdrawAll() private {
1684       uint256 balance = calcAvailableBalance();
1685       
1686       for(uint i=0; i < payableAddressCount; i++ ) {
1687           _widthdraw(
1688               payableAddresses[i],
1689               (balance * payableFees[i]) / 100
1690           );
1691       }
1692   }
1693   
1694   function _widthdraw(address _address, uint256 _amount) private {
1695       (bool success, ) = _address.call{value: _amount}("");
1696       require(success, "Transfer failed.");
1697   }
1698 
1699   /**
1700   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1701   * in the event ERC-20 tokens are paid to the contract for mints.
1702   * @param _tokenContract contract of ERC-20 token to withdraw
1703   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1704   */
1705   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1706     require(_amountToWithdraw > 0);
1707     IERC20 tokenContract = IERC20(_tokenContract);
1708     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1709     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1710   }
1711 
1712   /**
1713   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1714   * @param _erc20TokenContract address of ERC-20 contract in question
1715   */
1716   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1717     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1718   }
1719 
1720   /**
1721   * @dev get the value of tokens to transfer for user of an ERC-20
1722   * @param _erc20TokenContract address of ERC-20 contract in question
1723   */
1724   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1725     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1726     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1727   }
1728 
1729   /**
1730   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1731   * @param _erc20TokenContract address of ERC-20 contract in question
1732   * @param _isActive default status of if contract should be allowed to accept payments
1733   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1734   */
1735   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1736     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1737     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1738   }
1739 
1740   /**
1741   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1742   * it will assume the default value of zero. This should not be used to create new payment tokens.
1743   * @param _erc20TokenContract address of ERC-20 contract in question
1744   */
1745   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1746     allowedTokenContracts[_erc20TokenContract].isActive = true;
1747   }
1748 
1749   /**
1750   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1751   * it will assume the default value of zero. This should not be used to create new payment tokens.
1752   * @param _erc20TokenContract address of ERC-20 contract in question
1753   */
1754   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1755     allowedTokenContracts[_erc20TokenContract].isActive = false;
1756   }
1757 
1758   /**
1759   * @dev Enable only ERC-20 payments for minting on this contract
1760   */
1761   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1762     onlyERC20MintingMode = true;
1763   }
1764 
1765   /**
1766   * @dev Disable only ERC-20 payments for minting on this contract
1767   */
1768   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1769     onlyERC20MintingMode = false;
1770   }
1771 
1772   /**
1773   * @dev Set the payout of the ERC-20 token payout to a specific address
1774   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1775   */
1776   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1777     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1778     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1779     erc20Payable = _newErc20Payable;
1780   }
1781 
1782   /**
1783   * @dev Allows Rampp wallet to update its own reference.
1784   * @param _newAddress updated Rampp Address
1785   */
1786   function setRamppAddress(address _newAddress) public isRampp {
1787     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1788     RAMPPADDRESS = _newAddress;
1789   }
1790 }
1791 
1792 
1793   
1794   
1795 // File: EarlyMintIncentive.sol
1796 // Allows the contract to have the first x tokens have a discount or
1797 // zero fee that can be calculated on the fly.
1798 abstract contract EarlyMintIncentive is Teams, ERC721A {
1799   uint256 public PRICE = 0.025 ether;
1800   uint256 public EARLY_MINT_PRICE = 0.015 ether;
1801   uint256 public earlyMintTokenIdCap = 777;
1802   bool public usingEarlyMintIncentive = true;
1803 
1804   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1805     usingEarlyMintIncentive = true;
1806   }
1807 
1808   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1809     usingEarlyMintIncentive = false;
1810   }
1811 
1812   /**
1813   * @dev Set the max token ID in which the cost incentive will be applied.
1814   * @param _newTokenIdCap max tokenId in which incentive will be applied
1815   */
1816   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1817     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1818     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1819     earlyMintTokenIdCap = _newTokenIdCap;
1820   }
1821 
1822   /**
1823   * @dev Set the incentive mint price
1824   * @param _feeInWei new price per token when in incentive range
1825   */
1826   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1827     EARLY_MINT_PRICE = _feeInWei;
1828   }
1829 
1830   /**
1831   * @dev Set the primary mint price - the base price when not under incentive
1832   * @param _feeInWei new price per token
1833   */
1834   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1835     PRICE = _feeInWei;
1836   }
1837 
1838   function getPrice(uint256 _count) public view returns (uint256) {
1839     require(_count > 0, "Must be minting at least 1 token.");
1840 
1841     // short circuit function if we dont need to even calc incentive pricing
1842     // short circuit if the current tokenId is also already over cap
1843     if(
1844       usingEarlyMintIncentive == false ||
1845       currentTokenId() > earlyMintTokenIdCap
1846     ) {
1847       return PRICE * _count;
1848     }
1849 
1850     uint256 endingTokenId = currentTokenId() + _count;
1851     // If qty to mint results in a final token ID less than or equal to the cap then
1852     // the entire qty is within free mint.
1853     if(endingTokenId  <= earlyMintTokenIdCap) {
1854       return EARLY_MINT_PRICE * _count;
1855     }
1856 
1857     // If the current token id is less than the incentive cap
1858     // and the ending token ID is greater than the incentive cap
1859     // we will be straddling the cap so there will be some amount
1860     // that are incentive and some that are regular fee.
1861     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1862     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1863 
1864     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1865   }
1866 }
1867 
1868   
1869   
1870 abstract contract RamppERC721A is 
1871     Ownable,
1872     Teams,
1873     ERC721A,
1874     WithdrawableV2,
1875     ReentrancyGuard 
1876     , EarlyMintIncentive 
1877     , Allowlist 
1878     , TimedDrop
1879 {
1880   constructor(
1881     string memory tokenName,
1882     string memory tokenSymbol
1883   ) ERC721A(tokenName, tokenSymbol, 2, 777) { }
1884     uint8 public CONTRACT_VERSION = 2;
1885     string public _baseTokenURI = "ipfs://bafybeid7pb4imoay7ce6yebyw2cgntwgedblhfp4gdtmk5awgjgmu7dtdu/";
1886     string public _baseTokenExtension = ".json";
1887 
1888     bool public mintingOpen = true;
1889     bool public isRevealed = false;
1890     
1891     uint256 public MAX_WALLET_MINTS = 2;
1892 
1893   
1894     /////////////// Admin Mint Functions
1895     /**
1896      * @dev Mints a token to an address with a tokenURI.
1897      * This is owner only and allows a fee-free drop
1898      * @param _to address of the future owner of the token
1899      * @param _qty amount of tokens to drop the owner
1900      */
1901      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1902          require(_qty > 0, "Must mint at least 1 token.");
1903          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 777");
1904          _safeMint(_to, _qty, true);
1905      }
1906 
1907   
1908     /////////////// GENERIC MINT FUNCTIONS
1909     /**
1910     * @dev Mints a single token to an address.
1911     * fee may or may not be required*
1912     * @param _to address of the future owner of the token
1913     */
1914     function mintTo(address _to) public payable {
1915         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1916         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 777");
1917         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1918         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1919         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1920         require(msg.value == getPrice(1), "Value below required mint fee for amount");
1921 
1922         _safeMint(_to, 1, false);
1923     }
1924 
1925     /**
1926     * @dev Mints tokens to an address in batch.
1927     * fee may or may not be required*
1928     * @param _to address of the future owner of the token
1929     * @param _amount number of tokens to mint
1930     */
1931     function mintToMultiple(address _to, uint256 _amount) public payable {
1932         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1933         require(_amount >= 1, "Must mint at least 1 token");
1934         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1935         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1936         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1937         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1938         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 777");
1939         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1940 
1941         _safeMint(_to, _amount, false);
1942     }
1943 
1944     /**
1945      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1946      * fee may or may not be required*
1947      * @param _to address of the future owner of the token
1948      * @param _amount number of tokens to mint
1949      * @param _erc20TokenContract erc-20 token contract to mint with
1950      */
1951     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1952       require(_amount >= 1, "Must mint at least 1 token");
1953       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1954       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 777");
1955       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1956       require(publicDropTimePassed() == true, "Public drop time has not passed!");
1957       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1958 
1959       // ERC-20 Specific pre-flight checks
1960       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1961       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1962       IERC20 payableToken = IERC20(_erc20TokenContract);
1963 
1964       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1965       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1966 
1967       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1968       require(transferComplete, "ERC-20 token was unable to be transferred");
1969       
1970       _safeMint(_to, _amount, false);
1971     }
1972 
1973     function openMinting() public onlyTeamOrOwner {
1974         mintingOpen = true;
1975     }
1976 
1977     function stopMinting() public onlyTeamOrOwner {
1978         mintingOpen = false;
1979     }
1980 
1981   
1982     ///////////// ALLOWLIST MINTING FUNCTIONS
1983 
1984     /**
1985     * @dev Mints tokens to an address using an allowlist.
1986     * fee may or may not be required*
1987     * @param _to address of the future owner of the token
1988     * @param _merkleProof merkle proof array
1989     */
1990     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1991         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1992         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1993         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1994         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 777");
1995         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1996         require(msg.value == getPrice(1), "Value below required mint fee for amount");
1997         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
1998 
1999         _safeMint(_to, 1, false);
2000     }
2001 
2002     /**
2003     * @dev Mints tokens to an address using an allowlist.
2004     * fee may or may not be required*
2005     * @param _to address of the future owner of the token
2006     * @param _amount number of tokens to mint
2007     * @param _merkleProof merkle proof array
2008     */
2009     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2010         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2011         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2012         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2013         require(_amount >= 1, "Must mint at least 1 token");
2014         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2015 
2016         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2017         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 777");
2018         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
2019         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
2020 
2021         _safeMint(_to, _amount, false);
2022     }
2023 
2024     /**
2025     * @dev Mints tokens to an address using an allowlist.
2026     * fee may or may not be required*
2027     * @param _to address of the future owner of the token
2028     * @param _amount number of tokens to mint
2029     * @param _merkleProof merkle proof array
2030     * @param _erc20TokenContract erc-20 token contract to mint with
2031     */
2032     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2033       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2034       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2035       require(_amount >= 1, "Must mint at least 1 token");
2036       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2037       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2038       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 777");
2039       require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
2040     
2041       // ERC-20 Specific pre-flight checks
2042       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2043       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2044       IERC20 payableToken = IERC20(_erc20TokenContract);
2045     
2046       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2047       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2048       
2049       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2050       require(transferComplete, "ERC-20 token was unable to be transferred");
2051       
2052       _safeMint(_to, _amount, false);
2053     }
2054 
2055     /**
2056      * @dev Enable allowlist minting fully by enabling both flags
2057      * This is a convenience function for the Rampp user
2058      */
2059     function openAllowlistMint() public onlyTeamOrOwner {
2060         enableAllowlistOnlyMode();
2061         mintingOpen = true;
2062     }
2063 
2064     /**
2065      * @dev Close allowlist minting fully by disabling both flags
2066      * This is a convenience function for the Rampp user
2067      */
2068     function closeAllowlistMint() public onlyTeamOrOwner {
2069         disableAllowlistOnlyMode();
2070         mintingOpen = false;
2071     }
2072 
2073 
2074   
2075     /**
2076     * @dev Check if wallet over MAX_WALLET_MINTS
2077     * @param _address address in question to check if minted count exceeds max
2078     */
2079     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2080         require(_amount >= 1, "Amount must be greater than or equal to 1");
2081         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2082     }
2083 
2084     /**
2085     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2086     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2087     */
2088     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2089         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2090         MAX_WALLET_MINTS = _newWalletMax;
2091     }
2092     
2093 
2094   
2095     /**
2096      * @dev Allows owner to set Max mints per tx
2097      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2098      */
2099      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2100          require(_newMaxMint >= 1, "Max mint must be at least 1");
2101          maxBatchSize = _newMaxMint;
2102      }
2103     
2104 
2105   
2106     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2107         require(isRevealed == false, "Tokens are already unveiled");
2108         _baseTokenURI = _updatedTokenURI;
2109         isRevealed = true;
2110     }
2111     
2112 
2113   function _baseURI() internal view virtual override returns(string memory) {
2114     return _baseTokenURI;
2115   }
2116 
2117   function _baseURIExtension() internal view virtual override returns(string memory) {
2118     return _baseTokenExtension;
2119   }
2120 
2121   function baseTokenURI() public view returns(string memory) {
2122     return _baseTokenURI;
2123   }
2124 
2125   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2126     _baseTokenURI = baseURI;
2127   }
2128 
2129   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2130     _baseTokenExtension = baseExtension;
2131   }
2132 
2133   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2134     return ownershipOf(tokenId);
2135   }
2136 }
2137 
2138 
2139   
2140 // File: contracts/KawaiiKokoroContract.sol
2141 //SPDX-License-Identifier: MIT
2142 
2143 pragma solidity ^0.8.0;
2144 
2145 contract KawaiiKokoroContract is RamppERC721A {
2146     constructor() RamppERC721A("Kawaii Kokoro", "KK"){}
2147 }
2148   
2149 //*********************************************************************//
2150 //*********************************************************************//  
2151 //                       Mintplex v2.1.0
2152 //
2153 //         This smart contract was generated by mintplex.xyz.
2154 //            Mintplex allows creators like you to launch 
2155 //             large scale NFT communities without code!
2156 //
2157 //    Mintplex is not responsible for the content of this contract and
2158 //        hopes it is being used in a responsible and kind way.  
2159 //       Mintplex is not associated or affiliated with this project.                                                    
2160 //             Twitter: @MintplexNFT ---- mintplex.xyz
2161 //*********************************************************************//                                                     
2162 //*********************************************************************// 
