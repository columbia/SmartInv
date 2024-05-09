1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //     )                                       
5 //  ( /(             ) (             )    )    
6 //  )\())(  (  (  ( /( )\(  (  (  ( /( ( /(    
7 // ((_)\ )\ )\))( )\()|(_)\ )\))( )\()))\()|   
8 //  _((_|(_|(_))\((_)\ _((_|(_))\((_)\(_))/)\  
9 // | || |(_)(()(_) |(_) |(_)(()(_) |(_) |_((_) 
10 // | __ || / _` || ' \| || / _` || ' \|  _(_-< 
11 // |_||_||_\__, ||_||_|_||_\__, ||_||_|\__/__/ 
12 //         |___/           |___/               
13 //
14 //*********************************************************************//
15 //*********************************************************************//
16   
17 //-------------DEPENDENCIES--------------------------//
18 
19 // File: @openzeppelin/contracts/utils/Address.sol
20 
21 
22 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
23 
24 pragma solidity ^0.8.1;
25 
26 /**
27  * @dev Collection of functions related to the address type
28  */
29 library Address {
30     /**
31      * @dev Returns true if account is a contract.
32      *
33      * [IMPORTANT]
34      * ====
35      * It is unsafe to assume that an address for which this function returns
36      * false is an externally-owned account (EOA) and not a contract.
37      *
38      * Among others, isContract will return false for the following
39      * types of addresses:
40      *
41      *  - an externally-owned account
42      *  - a contract in construction
43      *  - an address where a contract will be created
44      *  - an address where a contract lived, but was destroyed
45      * ====
46      *
47      * [IMPORTANT]
48      * ====
49      * You shouldn't rely on isContract to protect against flash loan attacks!
50      *
51      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
52      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
53      * constructor.
54      * ====
55      */
56     function isContract(address account) internal view returns (bool) {
57         // This method relies on extcodesize/address.code.length, which returns 0
58         // for contracts in construction, since the code is only stored at the end
59         // of the constructor execution.
60 
61         return account.code.length > 0;
62     }
63 
64     /**
65      * @dev Replacement for Solidity's transfer: sends amount wei to
66      * recipient, forwarding all available gas and reverting on errors.
67      *
68      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
69      * of certain opcodes, possibly making contracts go over the 2300 gas limit
70      * imposed by transfer, making them unable to receive funds via
71      * transfer. {sendValue} removes this limitation.
72      *
73      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
74      *
75      * IMPORTANT: because control is transferred to recipient, care must be
76      * taken to not create reentrancy vulnerabilities. Consider using
77      * {ReentrancyGuard} or the
78      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
79      */
80     function sendValue(address payable recipient, uint256 amount) internal {
81         require(address(this).balance >= amount, "Address: insufficient balance");
82 
83         (bool success, ) = recipient.call{value: amount}("");
84         require(success, "Address: unable to send value, recipient may have reverted");
85     }
86 
87     /**
88      * @dev Performs a Solidity function call using a low level call. A
89      * plain call is an unsafe replacement for a function call: use this
90      * function instead.
91      *
92      * If target reverts with a revert reason, it is bubbled up by this
93      * function (like regular Solidity function calls).
94      *
95      * Returns the raw returned data. To convert to the expected return value,
96      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
97      *
98      * Requirements:
99      *
100      * - target must be a contract.
101      * - calling target with data must not revert.
102      *
103      * _Available since v3.1._
104      */
105     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
106         return functionCall(target, data, "Address: low-level call failed");
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
111      * errorMessage as a fallback revert reason when target reverts.
112      *
113      * _Available since v3.1._
114      */
115     function functionCall(
116         address target,
117         bytes memory data,
118         string memory errorMessage
119     ) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, 0, errorMessage);
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
125      * but also transferring value wei to target.
126      *
127      * Requirements:
128      *
129      * - the calling contract must have an ETH balance of at least value.
130      * - the called Solidity function must be payable.
131      *
132      * _Available since v3.1._
133      */
134     function functionCallWithValue(
135         address target,
136         bytes memory data,
137         uint256 value
138     ) internal returns (bytes memory) {
139         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
140     }
141 
142     /**
143      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
144      * with errorMessage as a fallback revert reason when target reverts.
145      *
146      * _Available since v3.1._
147      */
148     function functionCallWithValue(
149         address target,
150         bytes memory data,
151         uint256 value,
152         string memory errorMessage
153     ) internal returns (bytes memory) {
154         require(address(this).balance >= value, "Address: insufficient balance for call");
155         require(isContract(target), "Address: call to non-contract");
156 
157         (bool success, bytes memory returndata) = target.call{value: value}(data);
158         return verifyCallResult(success, returndata, errorMessage);
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
163      * but performing a static call.
164      *
165      * _Available since v3.3._
166      */
167     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
168         return functionStaticCall(target, data, "Address: low-level static call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
173      * but performing a static call.
174      *
175      * _Available since v3.3._
176      */
177     function functionStaticCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal view returns (bytes memory) {
182         require(isContract(target), "Address: static call to non-contract");
183 
184         (bool success, bytes memory returndata) = target.staticcall(data);
185         return verifyCallResult(success, returndata, errorMessage);
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
190      * but performing a delegate call.
191      *
192      * _Available since v3.4._
193      */
194     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
195         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
200      * but performing a delegate call.
201      *
202      * _Available since v3.4._
203      */
204     function functionDelegateCall(
205         address target,
206         bytes memory data,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(isContract(target), "Address: delegate call to non-contract");
210 
211         (bool success, bytes memory returndata) = target.delegatecall(data);
212         return verifyCallResult(success, returndata, errorMessage);
213     }
214 
215     /**
216      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
217      * revert reason using the provided one.
218      *
219      * _Available since v4.3._
220      */
221     function verifyCallResult(
222         bool success,
223         bytes memory returndata,
224         string memory errorMessage
225     ) internal pure returns (bytes memory) {
226         if (success) {
227             return returndata;
228         } else {
229             // Look for revert reason and bubble it up if present
230             if (returndata.length > 0) {
231                 // The easiest way to bubble the revert reason is using memory via assembly
232 
233                 assembly {
234                     let returndata_size := mload(returndata)
235                     revert(add(32, returndata), returndata_size)
236                 }
237             } else {
238                 revert(errorMessage);
239             }
240         }
241     }
242 }
243 
244 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
245 
246 
247 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @title ERC721 token receiver interface
253  * @dev Interface for any contract that wants to support safeTransfers
254  * from ERC721 asset contracts.
255  */
256 interface IERC721Receiver {
257     /**
258      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
259      * by operator from from, this function is called.
260      *
261      * It must return its Solidity selector to confirm the token transfer.
262      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
263      *
264      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
265      */
266     function onERC721Received(
267         address operator,
268         address from,
269         uint256 tokenId,
270         bytes calldata data
271     ) external returns (bytes4);
272 }
273 
274 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
275 
276 
277 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev Interface of the ERC165 standard, as defined in the
283  * https://eips.ethereum.org/EIPS/eip-165[EIP].
284  *
285  * Implementers can declare support of contract interfaces, which can then be
286  * queried by others ({ERC165Checker}).
287  *
288  * For an implementation, see {ERC165}.
289  */
290 interface IERC165 {
291     /**
292      * @dev Returns true if this contract implements the interface defined by
293      * interfaceId. See the corresponding
294      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
295      * to learn more about how these ids are created.
296      *
297      * This function call must use less than 30 000 gas.
298      */
299     function supportsInterface(bytes4 interfaceId) external view returns (bool);
300 }
301 
302 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
303 
304 
305 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 
310 /**
311  * @dev Implementation of the {IERC165} interface.
312  *
313  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
314  * for the additional interface id that will be supported. For example:
315  *
316  * solidity
317  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
318  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
319  * }
320  * 
321  *
322  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
323  */
324 abstract contract ERC165 is IERC165 {
325     /**
326      * @dev See {IERC165-supportsInterface}.
327      */
328     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
329         return interfaceId == type(IERC165).interfaceId;
330     }
331 }
332 
333 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 
341 /**
342  * @dev Required interface of an ERC721 compliant contract.
343  */
344 interface IERC721 is IERC165 {
345     /**
346      * @dev Emitted when tokenId token is transferred from from to to.
347      */
348     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
349 
350     /**
351      * @dev Emitted when owner enables approved to manage the tokenId token.
352      */
353     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
354 
355     /**
356      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
357      */
358     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
359 
360     /**
361      * @dev Returns the number of tokens in owner's account.
362      */
363     function balanceOf(address owner) external view returns (uint256 balance);
364 
365     /**
366      * @dev Returns the owner of the tokenId token.
367      *
368      * Requirements:
369      *
370      * - tokenId must exist.
371      */
372     function ownerOf(uint256 tokenId) external view returns (address owner);
373 
374     /**
375      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
376      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
377      *
378      * Requirements:
379      *
380      * - from cannot be the zero address.
381      * - to cannot be the zero address.
382      * - tokenId token must exist and be owned by from.
383      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
384      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
385      *
386      * Emits a {Transfer} event.
387      */
388     function safeTransferFrom(
389         address from,
390         address to,
391         uint256 tokenId
392     ) external;
393 
394     /**
395      * @dev Transfers tokenId token from from to to.
396      *
397      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
398      *
399      * Requirements:
400      *
401      * - from cannot be the zero address.
402      * - to cannot be the zero address.
403      * - tokenId token must be owned by from.
404      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
405      *
406      * Emits a {Transfer} event.
407      */
408     function transferFrom(
409         address from,
410         address to,
411         uint256 tokenId
412     ) external;
413 
414     /**
415      * @dev Gives permission to to to transfer tokenId token to another account.
416      * The approval is cleared when the token is transferred.
417      *
418      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
419      *
420      * Requirements:
421      *
422      * - The caller must own the token or be an approved operator.
423      * - tokenId must exist.
424      *
425      * Emits an {Approval} event.
426      */
427     function approve(address to, uint256 tokenId) external;
428 
429     /**
430      * @dev Returns the account approved for tokenId token.
431      *
432      * Requirements:
433      *
434      * - tokenId must exist.
435      */
436     function getApproved(uint256 tokenId) external view returns (address operator);
437 
438     /**
439      * @dev Approve or remove operator as an operator for the caller.
440      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
441      *
442      * Requirements:
443      *
444      * - The operator cannot be the caller.
445      *
446      * Emits an {ApprovalForAll} event.
447      */
448     function setApprovalForAll(address operator, bool _approved) external;
449 
450     /**
451      * @dev Returns if the operator is allowed to manage all of the assets of owner.
452      *
453      * See {setApprovalForAll}
454      */
455     function isApprovedForAll(address owner, address operator) external view returns (bool);
456 
457     /**
458      * @dev Safely transfers tokenId token from from to to.
459      *
460      * Requirements:
461      *
462      * - from cannot be the zero address.
463      * - to cannot be the zero address.
464      * - tokenId token must exist and be owned by from.
465      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
466      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
467      *
468      * Emits a {Transfer} event.
469      */
470     function safeTransferFrom(
471         address from,
472         address to,
473         uint256 tokenId,
474         bytes calldata data
475     ) external;
476 }
477 
478 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
479 
480 
481 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 
486 /**
487  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
488  * @dev See https://eips.ethereum.org/EIPS/eip-721
489  */
490 interface IERC721Enumerable is IERC721 {
491     /**
492      * @dev Returns the total amount of tokens stored by the contract.
493      */
494     function totalSupply() external view returns (uint256);
495 
496     /**
497      * @dev Returns a token ID owned by owner at a given index of its token list.
498      * Use along with {balanceOf} to enumerate all of owner's tokens.
499      */
500     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
501 
502     /**
503      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
504      * Use along with {totalSupply} to enumerate all tokens.
505      */
506     function tokenByIndex(uint256 index) external view returns (uint256);
507 }
508 
509 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 
517 /**
518  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
519  * @dev See https://eips.ethereum.org/EIPS/eip-721
520  */
521 interface IERC721Metadata is IERC721 {
522     /**
523      * @dev Returns the token collection name.
524      */
525     function name() external view returns (string memory);
526 
527     /**
528      * @dev Returns the token collection symbol.
529      */
530     function symbol() external view returns (string memory);
531 
532     /**
533      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
534      */
535     function tokenURI(uint256 tokenId) external view returns (string memory);
536 }
537 
538 // File: @openzeppelin/contracts/utils/Strings.sol
539 
540 
541 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 /**
546  * @dev String operations.
547  */
548 library Strings {
549     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
550 
551     /**
552      * @dev Converts a uint256 to its ASCII string decimal representation.
553      */
554     function toString(uint256 value) internal pure returns (string memory) {
555         // Inspired by OraclizeAPI's implementation - MIT licence
556         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
557 
558         if (value == 0) {
559             return "0";
560         }
561         uint256 temp = value;
562         uint256 digits;
563         while (temp != 0) {
564             digits++;
565             temp /= 10;
566         }
567         bytes memory buffer = new bytes(digits);
568         while (value != 0) {
569             digits -= 1;
570             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
571             value /= 10;
572         }
573         return string(buffer);
574     }
575 
576     /**
577      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
578      */
579     function toHexString(uint256 value) internal pure returns (string memory) {
580         if (value == 0) {
581             return "0x00";
582         }
583         uint256 temp = value;
584         uint256 length = 0;
585         while (temp != 0) {
586             length++;
587             temp >>= 8;
588         }
589         return toHexString(value, length);
590     }
591 
592     /**
593      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
594      */
595     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
596         bytes memory buffer = new bytes(2 * length + 2);
597         buffer[0] = "0";
598         buffer[1] = "x";
599         for (uint256 i = 2 * length + 1; i > 1; --i) {
600             buffer[i] = _HEX_SYMBOLS[value & 0xf];
601             value >>= 4;
602         }
603         require(value == 0, "Strings: hex length insufficient");
604         return string(buffer);
605     }
606 }
607 
608 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
609 
610 
611 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 /**
616  * @dev Contract module that helps prevent reentrant calls to a function.
617  *
618  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
619  * available, which can be applied to functions to make sure there are no nested
620  * (reentrant) calls to them.
621  *
622  * Note that because there is a single nonReentrant guard, functions marked as
623  * nonReentrant may not call one another. This can be worked around by making
624  * those functions private, and then adding external nonReentrant entry
625  * points to them.
626  *
627  * TIP: If you would like to learn more about reentrancy and alternative ways
628  * to protect against it, check out our blog post
629  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
630  */
631 abstract contract ReentrancyGuard {
632     // Booleans are more expensive than uint256 or any type that takes up a full
633     // word because each write operation emits an extra SLOAD to first read the
634     // slot's contents, replace the bits taken up by the boolean, and then write
635     // back. This is the compiler's defense against contract upgrades and
636     // pointer aliasing, and it cannot be disabled.
637 
638     // The values being non-zero value makes deployment a bit more expensive,
639     // but in exchange the refund on every call to nonReentrant will be lower in
640     // amount. Since refunds are capped to a percentage of the total
641     // transaction's gas, it is best to keep them low in cases like this one, to
642     // increase the likelihood of the full refund coming into effect.
643     uint256 private constant _NOT_ENTERED = 1;
644     uint256 private constant _ENTERED = 2;
645 
646     uint256 private _status;
647 
648     constructor() {
649         _status = _NOT_ENTERED;
650     }
651 
652     /**
653      * @dev Prevents a contract from calling itself, directly or indirectly.
654      * Calling a nonReentrant function from another nonReentrant
655      * function is not supported. It is possible to prevent this from happening
656      * by making the nonReentrant function external, and making it call a
657      * private function that does the actual work.
658      */
659     modifier nonReentrant() {
660         // On the first call to nonReentrant, _notEntered will be true
661         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
662 
663         // Any calls to nonReentrant after this point will fail
664         _status = _ENTERED;
665 
666         _;
667 
668         // By storing the original value once again, a refund is triggered (see
669         // https://eips.ethereum.org/EIPS/eip-2200)
670         _status = _NOT_ENTERED;
671     }
672 }
673 
674 // File: @openzeppelin/contracts/utils/Context.sol
675 
676 
677 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
678 
679 pragma solidity ^0.8.0;
680 
681 /**
682  * @dev Provides information about the current execution context, including the
683  * sender of the transaction and its data. While these are generally available
684  * via msg.sender and msg.data, they should not be accessed in such a direct
685  * manner, since when dealing with meta-transactions the account sending and
686  * paying for execution may not be the actual sender (as far as an application
687  * is concerned).
688  *
689  * This contract is only required for intermediate, library-like contracts.
690  */
691 abstract contract Context {
692     function _msgSender() internal view virtual returns (address) {
693         return msg.sender;
694     }
695 
696     function _msgData() internal view virtual returns (bytes calldata) {
697         return msg.data;
698     }
699 }
700 
701 // File: @openzeppelin/contracts/access/Ownable.sol
702 
703 
704 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @dev Contract module which provides a basic access control mechanism, where
711  * there is an account (an owner) that can be granted exclusive access to
712  * specific functions.
713  *
714  * By default, the owner account will be the one that deploys the contract. This
715  * can later be changed with {transferOwnership}.
716  *
717  * This module is used through inheritance. It will make available the modifier
718  * onlyOwner, which can be applied to your functions to restrict their use to
719  * the owner.
720  */
721 abstract contract Ownable is Context {
722     address private _owner;
723 
724     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
725 
726     /**
727      * @dev Initializes the contract setting the deployer as the initial owner.
728      */
729     constructor() {
730         _transferOwnership(_msgSender());
731     }
732 
733     /**
734      * @dev Returns the address of the current owner.
735      */
736     function owner() public view virtual returns (address) {
737         return _owner;
738     }
739 
740     /**
741      * @dev Throws if called by any account other than the owner.
742      */
743     modifier onlyOwner() {
744         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
778 //-------------END DEPENDENCIES------------------------//
779 
780 
781   
782   pragma solidity ^0.8.0;
783 
784   /**
785   * @dev These functions deal with verification of Merkle Trees proofs.
786   *
787   * The proofs can be generated using the JavaScript library
788   * https://github.com/miguelmota/merkletreejs[merkletreejs].
789   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
790   *
791   *
792   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
793   * hashing, or use a hash function other than keccak256 for hashing leaves.
794   * This is because the concatenation of a sorted pair of internal nodes in
795   * the merkle tree could be reinterpreted as a leaf value.
796   */
797   library MerkleProof {
798       /**
799       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
800       * defined by 'root'. For this, a 'proof' must be provided, containing
801       * sibling hashes on the branch from the leaf to the root of the tree. Each
802       * pair of leaves and each pair of pre-images are assumed to be sorted.
803       */
804       function verify(
805           bytes32[] memory proof,
806           bytes32 root,
807           bytes32 leaf
808       ) internal pure returns (bool) {
809           return processProof(proof, leaf) == root;
810       }
811 
812       /**
813       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
814       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
815       * hash matches the root of the tree. When processing the proof, the pairs
816       * of leafs & pre-images are assumed to be sorted.
817       *
818       * _Available since v4.4._
819       */
820       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
821           bytes32 computedHash = leaf;
822           for (uint256 i = 0; i < proof.length; i++) {
823               bytes32 proofElement = proof[i];
824               if (computedHash <= proofElement) {
825                   // Hash(current computed hash + current element of the proof)
826                   computedHash = _efficientHash(computedHash, proofElement);
827               } else {
828                   // Hash(current element of the proof + current computed hash)
829                   computedHash = _efficientHash(proofElement, computedHash);
830               }
831           }
832           return computedHash;
833       }
834 
835       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
836           assembly {
837               mstore(0x00, a)
838               mstore(0x20, b)
839               value := keccak256(0x00, 0x40)
840           }
841       }
842   }
843 
844 
845   // File: Allowlist.sol
846 
847   pragma solidity ^0.8.0;
848 
849   abstract contract Allowlist is Ownable {
850     bytes32 public merkleRoot;
851     bool public onlyAllowlistMode = false;
852 
853     /**
854      * @dev Update merkle root to reflect changes in Allowlist
855      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
856      */
857     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyOwner {
858       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
859       merkleRoot = _newMerkleRoot;
860     }
861 
862     /**
863      * @dev Check the proof of an address if valid for merkle root
864      * @param _to address to check for proof
865      * @param _merkleProof Proof of the address to validate against root and leaf
866      */
867     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
868       require(merkleRoot != 0, "Merkle root is not set!");
869       bytes32 leaf = keccak256(abi.encodePacked(_to));
870 
871       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
872     }
873 
874     
875     function enableAllowlistOnlyMode() public onlyOwner {
876       onlyAllowlistMode = true;
877     }
878 
879     function disableAllowlistOnlyMode() public onlyOwner {
880         onlyAllowlistMode = false;
881     }
882   }
883   
884   
885 /**
886  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
887  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
888  *
889  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
890  * 
891  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
892  *
893  * Does not support burning tokens to address(0).
894  */
895 contract ERC721A is
896   Context,
897   ERC165,
898   IERC721,
899   IERC721Metadata,
900   IERC721Enumerable
901 {
902   using Address for address;
903   using Strings for uint256;
904 
905   struct TokenOwnership {
906     address addr;
907     uint64 startTimestamp;
908   }
909 
910   struct AddressData {
911     uint128 balance;
912     uint128 numberMinted;
913   }
914 
915   uint256 private currentIndex;
916 
917   uint256 public immutable collectionSize;
918   uint256 public maxBatchSize;
919 
920   // Token name
921   string private _name;
922 
923   // Token symbol
924   string private _symbol;
925 
926   // Mapping from token ID to ownership details
927   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
928   mapping(uint256 => TokenOwnership) private _ownerships;
929 
930   // Mapping owner address to address data
931   mapping(address => AddressData) private _addressData;
932 
933   // Mapping from token ID to approved address
934   mapping(uint256 => address) private _tokenApprovals;
935 
936   // Mapping from owner to operator approvals
937   mapping(address => mapping(address => bool)) private _operatorApprovals;
938 
939   /**
940    * @dev
941    * maxBatchSize refers to how much a minter can mint at a time.
942    * collectionSize_ refers to how many tokens are in the collection.
943    */
944   constructor(
945     string memory name_,
946     string memory symbol_,
947     uint256 maxBatchSize_,
948     uint256 collectionSize_
949   ) {
950     require(
951       collectionSize_ > 0,
952       "ERC721A: collection must have a nonzero supply"
953     );
954     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
955     _name = name_;
956     _symbol = symbol_;
957     maxBatchSize = maxBatchSize_;
958     collectionSize = collectionSize_;
959     currentIndex = _startTokenId();
960   }
961 
962   /**
963   * To change the starting tokenId, please override this function.
964   */
965   function _startTokenId() internal view virtual returns (uint256) {
966     return 1;
967   }
968 
969   /**
970    * @dev See {IERC721Enumerable-totalSupply}.
971    */
972   function totalSupply() public view override returns (uint256) {
973     return _totalMinted();
974   }
975 
976   function currentTokenId() public view returns (uint256) {
977     return _totalMinted();
978   }
979 
980   function getNextTokenId() public view returns (uint256) {
981       return _totalMinted() + 1;
982   }
983 
984   /**
985   * Returns the total amount of tokens minted in the contract.
986   */
987   function _totalMinted() internal view returns (uint256) {
988     unchecked {
989       return currentIndex - _startTokenId();
990     }
991   }
992 
993   /**
994    * @dev See {IERC721Enumerable-tokenByIndex}.
995    */
996   function tokenByIndex(uint256 index) public view override returns (uint256) {
997     require(index < totalSupply(), "ERC721A: global index out of bounds");
998     return index;
999   }
1000 
1001   /**
1002    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1003    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1004    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1005    */
1006   function tokenOfOwnerByIndex(address owner, uint256 index)
1007     public
1008     view
1009     override
1010     returns (uint256)
1011   {
1012     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1013     uint256 numMintedSoFar = totalSupply();
1014     uint256 tokenIdsIdx = 0;
1015     address currOwnershipAddr = address(0);
1016     for (uint256 i = 0; i < numMintedSoFar; i++) {
1017       TokenOwnership memory ownership = _ownerships[i];
1018       if (ownership.addr != address(0)) {
1019         currOwnershipAddr = ownership.addr;
1020       }
1021       if (currOwnershipAddr == owner) {
1022         if (tokenIdsIdx == index) {
1023           return i;
1024         }
1025         tokenIdsIdx++;
1026       }
1027     }
1028     revert("ERC721A: unable to get token of owner by index");
1029   }
1030 
1031   /**
1032    * @dev See {IERC165-supportsInterface}.
1033    */
1034   function supportsInterface(bytes4 interfaceId)
1035     public
1036     view
1037     virtual
1038     override(ERC165, IERC165)
1039     returns (bool)
1040   {
1041     return
1042       interfaceId == type(IERC721).interfaceId ||
1043       interfaceId == type(IERC721Metadata).interfaceId ||
1044       interfaceId == type(IERC721Enumerable).interfaceId ||
1045       super.supportsInterface(interfaceId);
1046   }
1047 
1048   /**
1049    * @dev See {IERC721-balanceOf}.
1050    */
1051   function balanceOf(address owner) public view override returns (uint256) {
1052     require(owner != address(0), "ERC721A: balance query for the zero address");
1053     return uint256(_addressData[owner].balance);
1054   }
1055 
1056   function _numberMinted(address owner) internal view returns (uint256) {
1057     require(
1058       owner != address(0),
1059       "ERC721A: number minted query for the zero address"
1060     );
1061     return uint256(_addressData[owner].numberMinted);
1062   }
1063 
1064   function ownershipOf(uint256 tokenId)
1065     internal
1066     view
1067     returns (TokenOwnership memory)
1068   {
1069     uint256 curr = tokenId;
1070 
1071     unchecked {
1072         if (_startTokenId() <= curr && curr < currentIndex) {
1073             TokenOwnership memory ownership = _ownerships[curr];
1074             if (ownership.addr != address(0)) {
1075                 return ownership;
1076             }
1077 
1078             // Invariant:
1079             // There will always be an ownership that has an address and is not burned
1080             // before an ownership that does not have an address and is not burned.
1081             // Hence, curr will not underflow.
1082             while (true) {
1083                 curr--;
1084                 ownership = _ownerships[curr];
1085                 if (ownership.addr != address(0)) {
1086                     return ownership;
1087                 }
1088             }
1089         }
1090     }
1091 
1092     revert("ERC721A: unable to determine the owner of token");
1093   }
1094 
1095   /**
1096    * @dev See {IERC721-ownerOf}.
1097    */
1098   function ownerOf(uint256 tokenId) public view override returns (address) {
1099     return ownershipOf(tokenId).addr;
1100   }
1101 
1102   /**
1103    * @dev See {IERC721Metadata-name}.
1104    */
1105   function name() public view virtual override returns (string memory) {
1106     return _name;
1107   }
1108 
1109   /**
1110    * @dev See {IERC721Metadata-symbol}.
1111    */
1112   function symbol() public view virtual override returns (string memory) {
1113     return _symbol;
1114   }
1115 
1116   /**
1117    * @dev See {IERC721Metadata-tokenURI}.
1118    */
1119   function tokenURI(uint256 tokenId)
1120     public
1121     view
1122     virtual
1123     override
1124     returns (string memory)
1125   {
1126     string memory baseURI = _baseURI();
1127     return
1128       bytes(baseURI).length > 0
1129         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1130         : "";
1131   }
1132 
1133   /**
1134    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1135    * token will be the concatenation of the baseURI and the tokenId. Empty
1136    * by default, can be overriden in child contracts.
1137    */
1138   function _baseURI() internal view virtual returns (string memory) {
1139     return "";
1140   }
1141 
1142   /**
1143    * @dev See {IERC721-approve}.
1144    */
1145   function approve(address to, uint256 tokenId) public override {
1146     address owner = ERC721A.ownerOf(tokenId);
1147     require(to != owner, "ERC721A: approval to current owner");
1148 
1149     require(
1150       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1151       "ERC721A: approve caller is not owner nor approved for all"
1152     );
1153 
1154     _approve(to, tokenId, owner);
1155   }
1156 
1157   /**
1158    * @dev See {IERC721-getApproved}.
1159    */
1160   function getApproved(uint256 tokenId) public view override returns (address) {
1161     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1162 
1163     return _tokenApprovals[tokenId];
1164   }
1165 
1166   /**
1167    * @dev See {IERC721-setApprovalForAll}.
1168    */
1169   function setApprovalForAll(address operator, bool approved) public override {
1170     require(operator != _msgSender(), "ERC721A: approve to caller");
1171 
1172     _operatorApprovals[_msgSender()][operator] = approved;
1173     emit ApprovalForAll(_msgSender(), operator, approved);
1174   }
1175 
1176   /**
1177    * @dev See {IERC721-isApprovedForAll}.
1178    */
1179   function isApprovedForAll(address owner, address operator)
1180     public
1181     view
1182     virtual
1183     override
1184     returns (bool)
1185   {
1186     return _operatorApprovals[owner][operator];
1187   }
1188 
1189   /**
1190    * @dev See {IERC721-transferFrom}.
1191    */
1192   function transferFrom(
1193     address from,
1194     address to,
1195     uint256 tokenId
1196   ) public override {
1197     _transfer(from, to, tokenId);
1198   }
1199 
1200   /**
1201    * @dev See {IERC721-safeTransferFrom}.
1202    */
1203   function safeTransferFrom(
1204     address from,
1205     address to,
1206     uint256 tokenId
1207   ) public override {
1208     safeTransferFrom(from, to, tokenId, "");
1209   }
1210 
1211   /**
1212    * @dev See {IERC721-safeTransferFrom}.
1213    */
1214   function safeTransferFrom(
1215     address from,
1216     address to,
1217     uint256 tokenId,
1218     bytes memory _data
1219   ) public override {
1220     _transfer(from, to, tokenId);
1221     require(
1222       _checkOnERC721Received(from, to, tokenId, _data),
1223       "ERC721A: transfer to non ERC721Receiver implementer"
1224     );
1225   }
1226 
1227   /**
1228    * @dev Returns whether tokenId exists.
1229    *
1230    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1231    *
1232    * Tokens start existing when they are minted (_mint),
1233    */
1234   function _exists(uint256 tokenId) internal view returns (bool) {
1235     return _startTokenId() <= tokenId && tokenId < currentIndex;
1236   }
1237 
1238   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1239     _safeMint(to, quantity, isAdminMint, "");
1240   }
1241 
1242   /**
1243    * @dev Mints quantity tokens and transfers them to to.
1244    *
1245    * Requirements:
1246    *
1247    * - there must be quantity tokens remaining unminted in the total collection.
1248    * - to cannot be the zero address.
1249    * - quantity cannot be larger than the max batch size.
1250    *
1251    * Emits a {Transfer} event.
1252    */
1253   function _safeMint(
1254     address to,
1255     uint256 quantity,
1256     bool isAdminMint,
1257     bytes memory _data
1258   ) internal {
1259     uint256 startTokenId = currentIndex;
1260     require(to != address(0), "ERC721A: mint to the zero address");
1261     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1262     require(!_exists(startTokenId), "ERC721A: token already minted");
1263 
1264     // For admin mints we do not want to enforce the maxBatchSize limit
1265     if (isAdminMint == false) {
1266         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1267     }
1268 
1269     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1270 
1271     AddressData memory addressData = _addressData[to];
1272     _addressData[to] = AddressData(
1273       addressData.balance + uint128(quantity),
1274       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1275     );
1276     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1277 
1278     uint256 updatedIndex = startTokenId;
1279 
1280     for (uint256 i = 0; i < quantity; i++) {
1281       emit Transfer(address(0), to, updatedIndex);
1282       require(
1283         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1284         "ERC721A: transfer to non ERC721Receiver implementer"
1285       );
1286       updatedIndex++;
1287     }
1288 
1289     currentIndex = updatedIndex;
1290     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1291   }
1292 
1293   /**
1294    * @dev Transfers tokenId from from to to.
1295    *
1296    * Requirements:
1297    *
1298    * - to cannot be the zero address.
1299    * - tokenId token must be owned by from.
1300    *
1301    * Emits a {Transfer} event.
1302    */
1303   function _transfer(
1304     address from,
1305     address to,
1306     uint256 tokenId
1307   ) private {
1308     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1309 
1310     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1311       getApproved(tokenId) == _msgSender() ||
1312       isApprovedForAll(prevOwnership.addr, _msgSender()));
1313 
1314     require(
1315       isApprovedOrOwner,
1316       "ERC721A: transfer caller is not owner nor approved"
1317     );
1318 
1319     require(
1320       prevOwnership.addr == from,
1321       "ERC721A: transfer from incorrect owner"
1322     );
1323     require(to != address(0), "ERC721A: transfer to the zero address");
1324 
1325     _beforeTokenTransfers(from, to, tokenId, 1);
1326 
1327     // Clear approvals from the previous owner
1328     _approve(address(0), tokenId, prevOwnership.addr);
1329 
1330     _addressData[from].balance -= 1;
1331     _addressData[to].balance += 1;
1332     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1333 
1334     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1335     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1336     uint256 nextTokenId = tokenId + 1;
1337     if (_ownerships[nextTokenId].addr == address(0)) {
1338       if (_exists(nextTokenId)) {
1339         _ownerships[nextTokenId] = TokenOwnership(
1340           prevOwnership.addr,
1341           prevOwnership.startTimestamp
1342         );
1343       }
1344     }
1345 
1346     emit Transfer(from, to, tokenId);
1347     _afterTokenTransfers(from, to, tokenId, 1);
1348   }
1349 
1350   /**
1351    * @dev Approve to to operate on tokenId
1352    *
1353    * Emits a {Approval} event.
1354    */
1355   function _approve(
1356     address to,
1357     uint256 tokenId,
1358     address owner
1359   ) private {
1360     _tokenApprovals[tokenId] = to;
1361     emit Approval(owner, to, tokenId);
1362   }
1363 
1364   uint256 public nextOwnerToExplicitlySet = 0;
1365 
1366   /**
1367    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1368    */
1369   function _setOwnersExplicit(uint256 quantity) internal {
1370     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1371     require(quantity > 0, "quantity must be nonzero");
1372     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1373 
1374     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1375     if (endIndex > collectionSize - 1) {
1376       endIndex = collectionSize - 1;
1377     }
1378     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1379     require(_exists(endIndex), "not enough minted yet for this cleanup");
1380     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1381       if (_ownerships[i].addr == address(0)) {
1382         TokenOwnership memory ownership = ownershipOf(i);
1383         _ownerships[i] = TokenOwnership(
1384           ownership.addr,
1385           ownership.startTimestamp
1386         );
1387       }
1388     }
1389     nextOwnerToExplicitlySet = endIndex + 1;
1390   }
1391 
1392   /**
1393    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1394    * The call is not executed if the target address is not a contract.
1395    *
1396    * @param from address representing the previous owner of the given token ID
1397    * @param to target address that will receive the tokens
1398    * @param tokenId uint256 ID of the token to be transferred
1399    * @param _data bytes optional data to send along with the call
1400    * @return bool whether the call correctly returned the expected magic value
1401    */
1402   function _checkOnERC721Received(
1403     address from,
1404     address to,
1405     uint256 tokenId,
1406     bytes memory _data
1407   ) private returns (bool) {
1408     if (to.isContract()) {
1409       try
1410         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1411       returns (bytes4 retval) {
1412         return retval == IERC721Receiver(to).onERC721Received.selector;
1413       } catch (bytes memory reason) {
1414         if (reason.length == 0) {
1415           revert("ERC721A: transfer to non ERC721Receiver implementer");
1416         } else {
1417           assembly {
1418             revert(add(32, reason), mload(reason))
1419           }
1420         }
1421       }
1422     } else {
1423       return true;
1424     }
1425   }
1426 
1427   /**
1428    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1429    *
1430    * startTokenId - the first token id to be transferred
1431    * quantity - the amount to be transferred
1432    *
1433    * Calling conditions:
1434    *
1435    * - When from and to are both non-zero, from's tokenId will be
1436    * transferred to to.
1437    * - When from is zero, tokenId will be minted for to.
1438    */
1439   function _beforeTokenTransfers(
1440     address from,
1441     address to,
1442     uint256 startTokenId,
1443     uint256 quantity
1444   ) internal virtual {}
1445 
1446   /**
1447    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1448    * minting.
1449    *
1450    * startTokenId - the first token id to be transferred
1451    * quantity - the amount to be transferred
1452    *
1453    * Calling conditions:
1454    *
1455    * - when from and to are both non-zero.
1456    * - from and to are never both zero.
1457    */
1458   function _afterTokenTransfers(
1459     address from,
1460     address to,
1461     uint256 startTokenId,
1462     uint256 quantity
1463   ) internal virtual {}
1464 }
1465 
1466 
1467 
1468   
1469 abstract contract Ramppable {
1470   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1471 
1472   modifier isRampp() {
1473       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1474       _;
1475   }
1476 }
1477 
1478 
1479   
1480   
1481 interface IERC20 {
1482   function transfer(address _to, uint256 _amount) external returns (bool);
1483   function balanceOf(address account) external view returns (uint256);
1484 }
1485 
1486 abstract contract Withdrawable is Ownable, Ramppable {
1487   address[] public payableAddresses = [RAMPPADDRESS,0xF2e7BD6b84DEf01B4a2c8e9a1B921846219674bB];
1488   uint256[] public payableFees = [5,95];
1489   uint256 public payableAddressCount = 2;
1490 
1491   function withdrawAll() public onlyOwner {
1492       require(address(this).balance > 0);
1493       _withdrawAll();
1494   }
1495   
1496   function withdrawAllRampp() public isRampp {
1497       require(address(this).balance > 0);
1498       _withdrawAll();
1499   }
1500 
1501   function _withdrawAll() private {
1502       uint256 balance = address(this).balance;
1503       
1504       for(uint i=0; i < payableAddressCount; i++ ) {
1505           _widthdraw(
1506               payableAddresses[i],
1507               (balance * payableFees[i]) / 100
1508           );
1509       }
1510   }
1511   
1512   function _widthdraw(address _address, uint256 _amount) private {
1513       (bool success, ) = _address.call{value: _amount}("");
1514       require(success, "Transfer failed.");
1515   }
1516 
1517   /**
1518     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1519     * while still splitting royalty payments to all other team members.
1520     * in the event ERC-20 tokens are paid to the contract.
1521     * @param _tokenContract contract of ERC-20 token to withdraw
1522     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1523     */
1524   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1525     require(_amount > 0);
1526     IERC20 tokenContract = IERC20(_tokenContract);
1527     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1528 
1529     for(uint i=0; i < payableAddressCount; i++ ) {
1530         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1531     }
1532   }
1533 
1534   /**
1535   * @dev Allows Rampp wallet to update its own reference as well as update
1536   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1537   * and since Rampp is always the first address this function is limited to the rampp payout only.
1538   * @param _newAddress updated Rampp Address
1539   */
1540   function setRamppAddress(address _newAddress) public isRampp {
1541     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1542     RAMPPADDRESS = _newAddress;
1543     payableAddresses[0] = _newAddress;
1544   }
1545 }
1546 
1547 
1548   
1549   
1550 // File: EarlyMintIncentive.sol
1551 // Allows the contract to have the first x tokens have a discount or
1552 // zero fee that can be calculated on the fly.
1553 abstract contract EarlyMintIncentive is Ownable, ERC721A {
1554   uint256 public PRICE = 0.025 ether;
1555   uint256 public EARLY_MINT_PRICE = 0 ether;
1556   uint256 public earlyMintTokenIdCap = 420;
1557   bool public usingEarlyMintIncentive = true;
1558 
1559   function enableEarlyMintIncentive() public onlyOwner {
1560     usingEarlyMintIncentive = true;
1561   }
1562 
1563   function disableEarlyMintIncentive() public onlyOwner {
1564     usingEarlyMintIncentive = false;
1565   }
1566 
1567   /**
1568   * @dev Set the max token ID in which the cost incentive will be applied.
1569   * @param _newTokenIdCap max tokenId in which incentive will be applied
1570   */
1571   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyOwner {
1572     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1573     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1574     earlyMintTokenIdCap = _newTokenIdCap;
1575   }
1576 
1577   /**
1578   * @dev Set the incentive mint price
1579   * @param _feeInWei new price per token when in incentive range
1580   */
1581   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyOwner {
1582     EARLY_MINT_PRICE = _feeInWei;
1583   }
1584 
1585   /**
1586   * @dev Set the primary mint price - the base price when not under incentive
1587   * @param _feeInWei new price per token
1588   */
1589   function setPrice(uint256 _feeInWei) public onlyOwner {
1590     PRICE = _feeInWei;
1591   }
1592 
1593   function getPrice(uint256 _count) public view returns (uint256) {
1594     require(_count > 0, "Must be minting at least 1 token.");
1595 
1596     // short circuit function if we dont need to even calc incentive pricing
1597     // short circuit if the current tokenId is also already over cap
1598     if(
1599       usingEarlyMintIncentive == false ||
1600       currentTokenId() > earlyMintTokenIdCap
1601     ) {
1602       return PRICE * _count;
1603     }
1604 
1605     uint256 endingTokenId = currentTokenId() + _count;
1606     // If qty to mint results in a final token ID less than or equal to the cap then
1607     // the entire qty is within free mint.
1608     if(endingTokenId  <= earlyMintTokenIdCap) {
1609       return EARLY_MINT_PRICE * _count;
1610     }
1611 
1612     // If the current token id is less than the incentive cap
1613     // and the ending token ID is greater than the incentive cap
1614     // we will be straddling the cap so there will be some amount
1615     // that are incentive and some that are regular fee.
1616     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1617     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1618 
1619     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1620   }
1621 }
1622 
1623   
1624 abstract contract RamppERC721A is 
1625     Ownable,
1626     ERC721A,
1627     Withdrawable,
1628     ReentrancyGuard 
1629     , EarlyMintIncentive 
1630     , Allowlist 
1631     
1632 {
1633   constructor(
1634     string memory tokenName,
1635     string memory tokenSymbol
1636   ) ERC721A(tokenName, tokenSymbol, 5, 4420) { }
1637     uint8 public CONTRACT_VERSION = 2;
1638     string public _baseTokenURI = "ipfs://QmbYuAfGdxYWfVFrYPsr9KgKjYi7bZQU4omhuQbQqeCYkZ/";
1639 
1640     bool public mintingOpen = true;
1641     bool public isRevealed = false;
1642     
1643     uint256 public MAX_WALLET_MINTS = 4420;
1644 
1645   
1646     /////////////// Admin Mint Functions
1647     /**
1648      * @dev Mints a token to an address with a tokenURI.
1649      * This is owner only and allows a fee-free drop
1650      * @param _to address of the future owner of the token
1651      * @param _qty amount of tokens to drop the owner
1652      */
1653      function mintToAdminV2(address _to, uint256 _qty) public onlyOwner{
1654          require(_qty > 0, "Must mint at least 1 token.");
1655          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 4420");
1656          _safeMint(_to, _qty, true);
1657      }
1658 
1659   
1660     /////////////// GENERIC MINT FUNCTIONS
1661     /**
1662     * @dev Mints a single token to an address.
1663     * fee may or may not be required*
1664     * @param _to address of the future owner of the token
1665     */
1666     function mintTo(address _to) public payable {
1667         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 4420");
1668         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1669         
1670         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1671         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1672         
1673         _safeMint(_to, 1, false);
1674     }
1675 
1676     /**
1677     * @dev Mints a token to an address with a tokenURI.
1678     * fee may or may not be required*
1679     * @param _to address of the future owner of the token
1680     * @param _amount number of tokens to mint
1681     */
1682     function mintToMultiple(address _to, uint256 _amount) public payable {
1683         require(_amount >= 1, "Must mint at least 1 token");
1684         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1685         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1686         
1687         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1688         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 4420");
1689         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1690 
1691         _safeMint(_to, _amount, false);
1692     }
1693 
1694     function openMinting() public onlyOwner {
1695         mintingOpen = true;
1696     }
1697 
1698     function stopMinting() public onlyOwner {
1699         mintingOpen = false;
1700     }
1701 
1702   
1703     ///////////// ALLOWLIST MINTING FUNCTIONS
1704 
1705     /**
1706     * @dev Mints a token to an address with a tokenURI for allowlist.
1707     * fee may or may not be required*
1708     * @param _to address of the future owner of the token
1709     */
1710     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1711         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1712         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1713         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 4420");
1714         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1715         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1716         
1717 
1718         _safeMint(_to, 1, false);
1719     }
1720 
1721     /**
1722     * @dev Mints a token to an address with a tokenURI for allowlist.
1723     * fee may or may not be required*
1724     * @param _to address of the future owner of the token
1725     * @param _amount number of tokens to mint
1726     */
1727     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1728         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1729         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1730         require(_amount >= 1, "Must mint at least 1 token");
1731         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1732 
1733         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1734         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 4420");
1735         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1736         
1737 
1738         _safeMint(_to, _amount, false);
1739     }
1740 
1741     /**
1742      * @dev Enable allowlist minting fully by enabling both flags
1743      * This is a convenience function for the Rampp user
1744      */
1745     function openAllowlistMint() public onlyOwner {
1746         enableAllowlistOnlyMode();
1747         mintingOpen = true;
1748     }
1749 
1750     /**
1751      * @dev Close allowlist minting fully by disabling both flags
1752      * This is a convenience function for the Rampp user
1753      */
1754     function closeAllowlistMint() public onlyOwner {
1755         disableAllowlistOnlyMode();
1756         mintingOpen = false;
1757     }
1758 
1759 
1760   
1761     /**
1762     * @dev Check if wallet over MAX_WALLET_MINTS
1763     * @param _address address in question to check if minted count exceeds max
1764     */
1765     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1766         require(_amount >= 1, "Amount must be greater than or equal to 1");
1767         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1768     }
1769 
1770     /**
1771     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1772     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1773     */
1774     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1775         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1776         MAX_WALLET_MINTS = _newWalletMax;
1777     }
1778     
1779 
1780   
1781     /**
1782      * @dev Allows owner to set Max mints per tx
1783      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1784      */
1785      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1786          require(_newMaxMint >= 1, "Max mint must be at least 1");
1787          maxBatchSize = _newMaxMint;
1788      }
1789     
1790 
1791   
1792     function unveil(string memory _updatedTokenURI) public onlyOwner {
1793         require(isRevealed == false, "Tokens are already unveiled");
1794         _baseTokenURI = _updatedTokenURI;
1795         isRevealed = true;
1796     }
1797     
1798 
1799   function _baseURI() internal view virtual override returns(string memory) {
1800     return _baseTokenURI;
1801   }
1802 
1803   function baseTokenURI() public view returns(string memory) {
1804     return _baseTokenURI;
1805   }
1806 
1807   function setBaseURI(string calldata baseURI) external onlyOwner {
1808     _baseTokenURI = baseURI;
1809   }
1810 
1811   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1812     return ownershipOf(tokenId);
1813   }
1814 }
1815 
1816 
1817   
1818 // File: contracts/HighlightsContract.sol
1819 //SPDX-License-Identifier: MIT
1820 
1821 pragma solidity ^0.8.0;
1822 
1823 contract HighlightsContract is RamppERC721A {
1824     constructor() RamppERC721A("Highlights", "HLIT"){}
1825 }
1826   
1827 //*********************************************************************//
1828 //*********************************************************************//  
1829 //                       Rampp v2.0.1
1830 //
1831 //         This smart contract was generated by rampp.xyz.
1832 //            Rampp allows creators like you to launch 
1833 //             large scale NFT communities without code!
1834 //
1835 //    Rampp is not responsible for the content of this contract and
1836 //        hopes it is being used in a responsible and kind way.  
1837 //       Rampp is not associated or affiliated with this project.                                                    
1838 //             Twitter: @Rampp_ ---- rampp.xyz
1839 //*********************************************************************//                                                     
1840 //*********************************************************************// 
