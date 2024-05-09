1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //    ______      __    ___          __  __                             _       ______________
5 //   / ____/___  / /_  / (_)___     / / / /___  ____ ___  ___  _____   | |     / /_  __/ ____/
6 //  / / __/ __ \/ __ \/ / / __ \   / /_/ / __ \/ __ `__ \/ _ \/ ___/   | | /| / / / / / /_    
7 // / /_/ / /_/ / /_/ / / / / / /  / __  / /_/ / / / / / /  __(__  )    | |/ |/ / / / / __/    
8 // \____/\____/_.___/_/_/_/ /_/  /_/ /_/\____/_/ /_/ /_/\___/____/     |__/|__/ /_/ /_/       
9 //                                                                                            
10 //
11 // These banners represent ownership of asset in the goblin valley of the hidden metaverse.
12 // 1 nft = Home
13 // 4 nfts = Bungalow
14 // 6 nfts = Villa
15 // 9 nfts = Mansion
16 //
17 //
18 //
19 //*********************************************************************//
20 //*********************************************************************//
21   
22 //-------------DEPENDENCIES--------------------------//
23 
24 // File: @openzeppelin/contracts/utils/Address.sol
25 
26 
27 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
28 
29 pragma solidity ^0.8.1;
30 
31 /**
32  * @dev Collection of functions related to the address type
33  */
34 library Address {
35     /**
36      * @dev Returns true if account is a contract.
37      *
38      * [IMPORTANT]
39      * ====
40      * It is unsafe to assume that an address for which this function returns
41      * false is an externally-owned account (EOA) and not a contract.
42      *
43      * Among others, isContract will return false for the following
44      * types of addresses:
45      *
46      *  - an externally-owned account
47      *  - a contract in construction
48      *  - an address where a contract will be created
49      *  - an address where a contract lived, but was destroyed
50      * ====
51      *
52      * [IMPORTANT]
53      * ====
54      * You shouldn't rely on isContract to protect against flash loan attacks!
55      *
56      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
57      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
58      * constructor.
59      * ====
60      */
61     function isContract(address account) internal view returns (bool) {
62         // This method relies on extcodesize/address.code.length, which returns 0
63         // for contracts in construction, since the code is only stored at the end
64         // of the constructor execution.
65 
66         return account.code.length > 0;
67     }
68 
69     /**
70      * @dev Replacement for Solidity's transfer: sends amount wei to
71      * recipient, forwarding all available gas and reverting on errors.
72      *
73      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
74      * of certain opcodes, possibly making contracts go over the 2300 gas limit
75      * imposed by transfer, making them unable to receive funds via
76      * transfer. {sendValue} removes this limitation.
77      *
78      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
79      *
80      * IMPORTANT: because control is transferred to recipient, care must be
81      * taken to not create reentrancy vulnerabilities. Consider using
82      * {ReentrancyGuard} or the
83      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
84      */
85     function sendValue(address payable recipient, uint256 amount) internal {
86         require(address(this).balance >= amount, "Address: insufficient balance");
87 
88         (bool success, ) = recipient.call{value: amount}("");
89         require(success, "Address: unable to send value, recipient may have reverted");
90     }
91 
92     /**
93      * @dev Performs a Solidity function call using a low level call. A
94      * plain call is an unsafe replacement for a function call: use this
95      * function instead.
96      *
97      * If target reverts with a revert reason, it is bubbled up by this
98      * function (like regular Solidity function calls).
99      *
100      * Returns the raw returned data. To convert to the expected return value,
101      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
102      *
103      * Requirements:
104      *
105      * - target must be a contract.
106      * - calling target with data must not revert.
107      *
108      * _Available since v3.1._
109      */
110     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
111         return functionCall(target, data, "Address: low-level call failed");
112     }
113 
114     /**
115      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
116      * errorMessage as a fallback revert reason when target reverts.
117      *
118      * _Available since v3.1._
119      */
120     function functionCall(
121         address target,
122         bytes memory data,
123         string memory errorMessage
124     ) internal returns (bytes memory) {
125         return functionCallWithValue(target, data, 0, errorMessage);
126     }
127 
128     /**
129      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
130      * but also transferring value wei to target.
131      *
132      * Requirements:
133      *
134      * - the calling contract must have an ETH balance of at least value.
135      * - the called Solidity function must be payable.
136      *
137      * _Available since v3.1._
138      */
139     function functionCallWithValue(
140         address target,
141         bytes memory data,
142         uint256 value
143     ) internal returns (bytes memory) {
144         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
149      * with errorMessage as a fallback revert reason when target reverts.
150      *
151      * _Available since v3.1._
152      */
153     function functionCallWithValue(
154         address target,
155         bytes memory data,
156         uint256 value,
157         string memory errorMessage
158     ) internal returns (bytes memory) {
159         require(address(this).balance >= value, "Address: insufficient balance for call");
160         require(isContract(target), "Address: call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.call{value: value}(data);
163         return verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
168      * but performing a static call.
169      *
170      * _Available since v3.3._
171      */
172     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
173         return functionStaticCall(target, data, "Address: low-level static call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
178      * but performing a static call.
179      *
180      * _Available since v3.3._
181      */
182     function functionStaticCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal view returns (bytes memory) {
187         require(isContract(target), "Address: static call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.staticcall(data);
190         return verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
195      * but performing a delegate call.
196      *
197      * _Available since v3.4._
198      */
199     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
200         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
205      * but performing a delegate call.
206      *
207      * _Available since v3.4._
208      */
209     function functionDelegateCall(
210         address target,
211         bytes memory data,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(isContract(target), "Address: delegate call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.delegatecall(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     /**
221      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
222      * revert reason using the provided one.
223      *
224      * _Available since v4.3._
225      */
226     function verifyCallResult(
227         bool success,
228         bytes memory returndata,
229         string memory errorMessage
230     ) internal pure returns (bytes memory) {
231         if (success) {
232             return returndata;
233         } else {
234             // Look for revert reason and bubble it up if present
235             if (returndata.length > 0) {
236                 // The easiest way to bubble the revert reason is using memory via assembly
237 
238                 assembly {
239                     let returndata_size := mload(returndata)
240                     revert(add(32, returndata), returndata_size)
241                 }
242             } else {
243                 revert(errorMessage);
244             }
245         }
246     }
247 }
248 
249 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
250 
251 
252 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @title ERC721 token receiver interface
258  * @dev Interface for any contract that wants to support safeTransfers
259  * from ERC721 asset contracts.
260  */
261 interface IERC721Receiver {
262     /**
263      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
264      * by operator from from, this function is called.
265      *
266      * It must return its Solidity selector to confirm the token transfer.
267      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
268      *
269      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
270      */
271     function onERC721Received(
272         address operator,
273         address from,
274         uint256 tokenId,
275         bytes calldata data
276     ) external returns (bytes4);
277 }
278 
279 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
280 
281 
282 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
283 
284 pragma solidity ^0.8.0;
285 
286 /**
287  * @dev Interface of the ERC165 standard, as defined in the
288  * https://eips.ethereum.org/EIPS/eip-165[EIP].
289  *
290  * Implementers can declare support of contract interfaces, which can then be
291  * queried by others ({ERC165Checker}).
292  *
293  * For an implementation, see {ERC165}.
294  */
295 interface IERC165 {
296     /**
297      * @dev Returns true if this contract implements the interface defined by
298      * interfaceId. See the corresponding
299      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
300      * to learn more about how these ids are created.
301      *
302      * This function call must use less than 30 000 gas.
303      */
304     function supportsInterface(bytes4 interfaceId) external view returns (bool);
305 }
306 
307 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
308 
309 
310 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 
315 /**
316  * @dev Implementation of the {IERC165} interface.
317  *
318  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
319  * for the additional interface id that will be supported. For example:
320  *
321  * solidity
322  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
323  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
324  * }
325  * 
326  *
327  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
328  */
329 abstract contract ERC165 is IERC165 {
330     /**
331      * @dev See {IERC165-supportsInterface}.
332      */
333     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
334         return interfaceId == type(IERC165).interfaceId;
335     }
336 }
337 
338 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
339 
340 
341 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 
346 /**
347  * @dev Required interface of an ERC721 compliant contract.
348  */
349 interface IERC721 is IERC165 {
350     /**
351      * @dev Emitted when tokenId token is transferred from from to to.
352      */
353     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
354 
355     /**
356      * @dev Emitted when owner enables approved to manage the tokenId token.
357      */
358     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
359 
360     /**
361      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
362      */
363     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
364 
365     /**
366      * @dev Returns the number of tokens in owner's account.
367      */
368     function balanceOf(address owner) external view returns (uint256 balance);
369 
370     /**
371      * @dev Returns the owner of the tokenId token.
372      *
373      * Requirements:
374      *
375      * - tokenId must exist.
376      */
377     function ownerOf(uint256 tokenId) external view returns (address owner);
378 
379     /**
380      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
381      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
382      *
383      * Requirements:
384      *
385      * - from cannot be the zero address.
386      * - to cannot be the zero address.
387      * - tokenId token must exist and be owned by from.
388      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
389      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
390      *
391      * Emits a {Transfer} event.
392      */
393     function safeTransferFrom(
394         address from,
395         address to,
396         uint256 tokenId
397     ) external;
398 
399     /**
400      * @dev Transfers tokenId token from from to to.
401      *
402      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
403      *
404      * Requirements:
405      *
406      * - from cannot be the zero address.
407      * - to cannot be the zero address.
408      * - tokenId token must be owned by from.
409      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
410      *
411      * Emits a {Transfer} event.
412      */
413     function transferFrom(
414         address from,
415         address to,
416         uint256 tokenId
417     ) external;
418 
419     /**
420      * @dev Gives permission to to to transfer tokenId token to another account.
421      * The approval is cleared when the token is transferred.
422      *
423      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
424      *
425      * Requirements:
426      *
427      * - The caller must own the token or be an approved operator.
428      * - tokenId must exist.
429      *
430      * Emits an {Approval} event.
431      */
432     function approve(address to, uint256 tokenId) external;
433 
434     /**
435      * @dev Returns the account approved for tokenId token.
436      *
437      * Requirements:
438      *
439      * - tokenId must exist.
440      */
441     function getApproved(uint256 tokenId) external view returns (address operator);
442 
443     /**
444      * @dev Approve or remove operator as an operator for the caller.
445      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
446      *
447      * Requirements:
448      *
449      * - The operator cannot be the caller.
450      *
451      * Emits an {ApprovalForAll} event.
452      */
453     function setApprovalForAll(address operator, bool _approved) external;
454 
455     /**
456      * @dev Returns if the operator is allowed to manage all of the assets of owner.
457      *
458      * See {setApprovalForAll}
459      */
460     function isApprovedForAll(address owner, address operator) external view returns (bool);
461 
462     /**
463      * @dev Safely transfers tokenId token from from to to.
464      *
465      * Requirements:
466      *
467      * - from cannot be the zero address.
468      * - to cannot be the zero address.
469      * - tokenId token must exist and be owned by from.
470      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
471      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
472      *
473      * Emits a {Transfer} event.
474      */
475     function safeTransferFrom(
476         address from,
477         address to,
478         uint256 tokenId,
479         bytes calldata data
480     ) external;
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
484 
485 
486 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 
491 /**
492  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
493  * @dev See https://eips.ethereum.org/EIPS/eip-721
494  */
495 interface IERC721Enumerable is IERC721 {
496     /**
497      * @dev Returns the total amount of tokens stored by the contract.
498      */
499     function totalSupply() external view returns (uint256);
500 
501     /**
502      * @dev Returns a token ID owned by owner at a given index of its token list.
503      * Use along with {balanceOf} to enumerate all of owner's tokens.
504      */
505     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
506 
507     /**
508      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
509      * Use along with {totalSupply} to enumerate all tokens.
510      */
511     function tokenByIndex(uint256 index) external view returns (uint256);
512 }
513 
514 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
515 
516 
517 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 
522 /**
523  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
524  * @dev See https://eips.ethereum.org/EIPS/eip-721
525  */
526 interface IERC721Metadata is IERC721 {
527     /**
528      * @dev Returns the token collection name.
529      */
530     function name() external view returns (string memory);
531 
532     /**
533      * @dev Returns the token collection symbol.
534      */
535     function symbol() external view returns (string memory);
536 
537     /**
538      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
539      */
540     function tokenURI(uint256 tokenId) external view returns (string memory);
541 }
542 
543 // File: @openzeppelin/contracts/utils/Strings.sol
544 
545 
546 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 /**
551  * @dev String operations.
552  */
553 library Strings {
554     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
555 
556     /**
557      * @dev Converts a uint256 to its ASCII string decimal representation.
558      */
559     function toString(uint256 value) internal pure returns (string memory) {
560         // Inspired by OraclizeAPI's implementation - MIT licence
561         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
562 
563         if (value == 0) {
564             return "0";
565         }
566         uint256 temp = value;
567         uint256 digits;
568         while (temp != 0) {
569             digits++;
570             temp /= 10;
571         }
572         bytes memory buffer = new bytes(digits);
573         while (value != 0) {
574             digits -= 1;
575             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
576             value /= 10;
577         }
578         return string(buffer);
579     }
580 
581     /**
582      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
583      */
584     function toHexString(uint256 value) internal pure returns (string memory) {
585         if (value == 0) {
586             return "0x00";
587         }
588         uint256 temp = value;
589         uint256 length = 0;
590         while (temp != 0) {
591             length++;
592             temp >>= 8;
593         }
594         return toHexString(value, length);
595     }
596 
597     /**
598      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
599      */
600     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
601         bytes memory buffer = new bytes(2 * length + 2);
602         buffer[0] = "0";
603         buffer[1] = "x";
604         for (uint256 i = 2 * length + 1; i > 1; --i) {
605             buffer[i] = _HEX_SYMBOLS[value & 0xf];
606             value >>= 4;
607         }
608         require(value == 0, "Strings: hex length insufficient");
609         return string(buffer);
610     }
611 }
612 
613 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
614 
615 
616 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 /**
621  * @dev Contract module that helps prevent reentrant calls to a function.
622  *
623  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
624  * available, which can be applied to functions to make sure there are no nested
625  * (reentrant) calls to them.
626  *
627  * Note that because there is a single nonReentrant guard, functions marked as
628  * nonReentrant may not call one another. This can be worked around by making
629  * those functions private, and then adding external nonReentrant entry
630  * points to them.
631  *
632  * TIP: If you would like to learn more about reentrancy and alternative ways
633  * to protect against it, check out our blog post
634  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
635  */
636 abstract contract ReentrancyGuard {
637     // Booleans are more expensive than uint256 or any type that takes up a full
638     // word because each write operation emits an extra SLOAD to first read the
639     // slot's contents, replace the bits taken up by the boolean, and then write
640     // back. This is the compiler's defense against contract upgrades and
641     // pointer aliasing, and it cannot be disabled.
642 
643     // The values being non-zero value makes deployment a bit more expensive,
644     // but in exchange the refund on every call to nonReentrant will be lower in
645     // amount. Since refunds are capped to a percentage of the total
646     // transaction's gas, it is best to keep them low in cases like this one, to
647     // increase the likelihood of the full refund coming into effect.
648     uint256 private constant _NOT_ENTERED = 1;
649     uint256 private constant _ENTERED = 2;
650 
651     uint256 private _status;
652 
653     constructor() {
654         _status = _NOT_ENTERED;
655     }
656 
657     /**
658      * @dev Prevents a contract from calling itself, directly or indirectly.
659      * Calling a nonReentrant function from another nonReentrant
660      * function is not supported. It is possible to prevent this from happening
661      * by making the nonReentrant function external, and making it call a
662      * private function that does the actual work.
663      */
664     modifier nonReentrant() {
665         // On the first call to nonReentrant, _notEntered will be true
666         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
667 
668         // Any calls to nonReentrant after this point will fail
669         _status = _ENTERED;
670 
671         _;
672 
673         // By storing the original value once again, a refund is triggered (see
674         // https://eips.ethereum.org/EIPS/eip-2200)
675         _status = _NOT_ENTERED;
676     }
677 }
678 
679 // File: @openzeppelin/contracts/utils/Context.sol
680 
681 
682 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 /**
687  * @dev Provides information about the current execution context, including the
688  * sender of the transaction and its data. While these are generally available
689  * via msg.sender and msg.data, they should not be accessed in such a direct
690  * manner, since when dealing with meta-transactions the account sending and
691  * paying for execution may not be the actual sender (as far as an application
692  * is concerned).
693  *
694  * This contract is only required for intermediate, library-like contracts.
695  */
696 abstract contract Context {
697     function _msgSender() internal view virtual returns (address) {
698         return msg.sender;
699     }
700 
701     function _msgData() internal view virtual returns (bytes calldata) {
702         return msg.data;
703     }
704 }
705 
706 // File: @openzeppelin/contracts/access/Ownable.sol
707 
708 
709 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
710 
711 pragma solidity ^0.8.0;
712 
713 
714 /**
715  * @dev Contract module which provides a basic access control mechanism, where
716  * there is an account (an owner) that can be granted exclusive access to
717  * specific functions.
718  *
719  * By default, the owner account will be the one that deploys the contract. This
720  * can later be changed with {transferOwnership}.
721  *
722  * This module is used through inheritance. It will make available the modifier
723  * onlyOwner, which can be applied to your functions to restrict their use to
724  * the owner.
725  */
726 abstract contract Ownable is Context {
727     address private _owner;
728 
729     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
730 
731     /**
732      * @dev Initializes the contract setting the deployer as the initial owner.
733      */
734     constructor() {
735         _transferOwnership(_msgSender());
736     }
737 
738     /**
739      * @dev Returns the address of the current owner.
740      */
741     function owner() public view virtual returns (address) {
742         return _owner;
743     }
744 
745     /**
746      * @dev Throws if called by any account other than the owner.
747      */
748     modifier onlyOwner() {
749         require(owner() == _msgSender(), "Ownable: caller is not the owner");
750         _;
751     }
752 
753     /**
754      * @dev Leaves the contract without owner. It will not be possible to call
755      * onlyOwner functions anymore. Can only be called by the current owner.
756      *
757      * NOTE: Renouncing ownership will leave the contract without an owner,
758      * thereby removing any functionality that is only available to the owner.
759      */
760     function renounceOwnership() public virtual onlyOwner {
761         _transferOwnership(address(0));
762     }
763 
764     /**
765      * @dev Transfers ownership of the contract to a new account (newOwner).
766      * Can only be called by the current owner.
767      */
768     function transferOwnership(address newOwner) public virtual onlyOwner {
769         require(newOwner != address(0), "Ownable: new owner is the zero address");
770         _transferOwnership(newOwner);
771     }
772 
773     /**
774      * @dev Transfers ownership of the contract to a new account (newOwner).
775      * Internal function without access restriction.
776      */
777     function _transferOwnership(address newOwner) internal virtual {
778         address oldOwner = _owner;
779         _owner = newOwner;
780         emit OwnershipTransferred(oldOwner, newOwner);
781     }
782 }
783 //-------------END DEPENDENCIES------------------------//
784 
785 
786   
787 // Rampp Contracts v2.1 (Teams.sol)
788 
789 pragma solidity ^0.8.0;
790 
791 /**
792 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
793 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
794 * This will easily allow cross-collaboration via Rampp.xyz.
795 **/
796 abstract contract Teams is Ownable{
797   mapping (address => bool) internal team;
798 
799   /**
800   * @dev Adds an address to the team. Allows them to execute protected functions
801   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
802   **/
803   function addToTeam(address _address) public onlyOwner {
804     require(_address != address(0), "Invalid address");
805     require(!inTeam(_address), "This address is already in your team.");
806   
807     team[_address] = true;
808   }
809 
810   /**
811   * @dev Removes an address to the team.
812   * @param _address the ETH address to remove, cannot be 0x and must be in team
813   **/
814   function removeFromTeam(address _address) public onlyOwner {
815     require(_address != address(0), "Invalid address");
816     require(inTeam(_address), "This address is not in your team currently.");
817   
818     team[_address] = false;
819   }
820 
821   /**
822   * @dev Check if an address is valid and active in the team
823   * @param _address ETH address to check for truthiness
824   **/
825   function inTeam(address _address)
826     public
827     view
828     returns (bool)
829   {
830     require(_address != address(0), "Invalid address to check.");
831     return team[_address] == true;
832   }
833 
834   /**
835   * @dev Throws if called by any account other than the owner or team member.
836   */
837   modifier onlyTeamOrOwner() {
838     bool _isOwner = owner() == _msgSender();
839     bool _isTeam = inTeam(_msgSender());
840     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
841     _;
842   }
843 }
844 
845 
846   
847   
848 /**
849  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
850  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
851  *
852  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
853  * 
854  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
855  *
856  * Does not support burning tokens to address(0).
857  */
858 contract ERC721A is
859   Context,
860   ERC165,
861   IERC721,
862   IERC721Metadata,
863   IERC721Enumerable
864 {
865   using Address for address;
866   using Strings for uint256;
867 
868   struct TokenOwnership {
869     address addr;
870     uint64 startTimestamp;
871   }
872 
873   struct AddressData {
874     uint128 balance;
875     uint128 numberMinted;
876   }
877 
878   uint256 private currentIndex;
879 
880   uint256 public immutable collectionSize;
881   uint256 public maxBatchSize;
882 
883   // Token name
884   string private _name;
885 
886   // Token symbol
887   string private _symbol;
888 
889   // Mapping from token ID to ownership details
890   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
891   mapping(uint256 => TokenOwnership) private _ownerships;
892 
893   // Mapping owner address to address data
894   mapping(address => AddressData) private _addressData;
895 
896   // Mapping from token ID to approved address
897   mapping(uint256 => address) private _tokenApprovals;
898 
899   // Mapping from owner to operator approvals
900   mapping(address => mapping(address => bool)) private _operatorApprovals;
901 
902   /**
903    * @dev
904    * maxBatchSize refers to how much a minter can mint at a time.
905    * collectionSize_ refers to how many tokens are in the collection.
906    */
907   constructor(
908     string memory name_,
909     string memory symbol_,
910     uint256 maxBatchSize_,
911     uint256 collectionSize_
912   ) {
913     require(
914       collectionSize_ > 0,
915       "ERC721A: collection must have a nonzero supply"
916     );
917     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
918     _name = name_;
919     _symbol = symbol_;
920     maxBatchSize = maxBatchSize_;
921     collectionSize = collectionSize_;
922     currentIndex = _startTokenId();
923   }
924 
925   /**
926   * To change the starting tokenId, please override this function.
927   */
928   function _startTokenId() internal view virtual returns (uint256) {
929     return 1;
930   }
931 
932   /**
933    * @dev See {IERC721Enumerable-totalSupply}.
934    */
935   function totalSupply() public view override returns (uint256) {
936     return _totalMinted();
937   }
938 
939   function currentTokenId() public view returns (uint256) {
940     return _totalMinted();
941   }
942 
943   function getNextTokenId() public view returns (uint256) {
944       return _totalMinted() + 1;
945   }
946 
947   /**
948   * Returns the total amount of tokens minted in the contract.
949   */
950   function _totalMinted() internal view returns (uint256) {
951     unchecked {
952       return currentIndex - _startTokenId();
953     }
954   }
955 
956   /**
957    * @dev See {IERC721Enumerable-tokenByIndex}.
958    */
959   function tokenByIndex(uint256 index) public view override returns (uint256) {
960     require(index < totalSupply(), "ERC721A: global index out of bounds");
961     return index;
962   }
963 
964   /**
965    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
966    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
967    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
968    */
969   function tokenOfOwnerByIndex(address owner, uint256 index)
970     public
971     view
972     override
973     returns (uint256)
974   {
975     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
976     uint256 numMintedSoFar = totalSupply();
977     uint256 tokenIdsIdx = 0;
978     address currOwnershipAddr = address(0);
979     for (uint256 i = 0; i < numMintedSoFar; i++) {
980       TokenOwnership memory ownership = _ownerships[i];
981       if (ownership.addr != address(0)) {
982         currOwnershipAddr = ownership.addr;
983       }
984       if (currOwnershipAddr == owner) {
985         if (tokenIdsIdx == index) {
986           return i;
987         }
988         tokenIdsIdx++;
989       }
990     }
991     revert("ERC721A: unable to get token of owner by index");
992   }
993 
994   /**
995    * @dev See {IERC165-supportsInterface}.
996    */
997   function supportsInterface(bytes4 interfaceId)
998     public
999     view
1000     virtual
1001     override(ERC165, IERC165)
1002     returns (bool)
1003   {
1004     return
1005       interfaceId == type(IERC721).interfaceId ||
1006       interfaceId == type(IERC721Metadata).interfaceId ||
1007       interfaceId == type(IERC721Enumerable).interfaceId ||
1008       super.supportsInterface(interfaceId);
1009   }
1010 
1011   /**
1012    * @dev See {IERC721-balanceOf}.
1013    */
1014   function balanceOf(address owner) public view override returns (uint256) {
1015     require(owner != address(0), "ERC721A: balance query for the zero address");
1016     return uint256(_addressData[owner].balance);
1017   }
1018 
1019   function _numberMinted(address owner) internal view returns (uint256) {
1020     require(
1021       owner != address(0),
1022       "ERC721A: number minted query for the zero address"
1023     );
1024     return uint256(_addressData[owner].numberMinted);
1025   }
1026 
1027   function ownershipOf(uint256 tokenId)
1028     internal
1029     view
1030     returns (TokenOwnership memory)
1031   {
1032     uint256 curr = tokenId;
1033 
1034     unchecked {
1035         if (_startTokenId() <= curr && curr < currentIndex) {
1036             TokenOwnership memory ownership = _ownerships[curr];
1037             if (ownership.addr != address(0)) {
1038                 return ownership;
1039             }
1040 
1041             // Invariant:
1042             // There will always be an ownership that has an address and is not burned
1043             // before an ownership that does not have an address and is not burned.
1044             // Hence, curr will not underflow.
1045             while (true) {
1046                 curr--;
1047                 ownership = _ownerships[curr];
1048                 if (ownership.addr != address(0)) {
1049                     return ownership;
1050                 }
1051             }
1052         }
1053     }
1054 
1055     revert("ERC721A: unable to determine the owner of token");
1056   }
1057 
1058   /**
1059    * @dev See {IERC721-ownerOf}.
1060    */
1061   function ownerOf(uint256 tokenId) public view override returns (address) {
1062     return ownershipOf(tokenId).addr;
1063   }
1064 
1065   /**
1066    * @dev See {IERC721Metadata-name}.
1067    */
1068   function name() public view virtual override returns (string memory) {
1069     return _name;
1070   }
1071 
1072   /**
1073    * @dev See {IERC721Metadata-symbol}.
1074    */
1075   function symbol() public view virtual override returns (string memory) {
1076     return _symbol;
1077   }
1078 
1079   /**
1080    * @dev See {IERC721Metadata-tokenURI}.
1081    */
1082   function tokenURI(uint256 tokenId)
1083     public
1084     view
1085     virtual
1086     override
1087     returns (string memory)
1088   {
1089     string memory baseURI = _baseURI();
1090     return
1091       bytes(baseURI).length > 0
1092         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1093         : "";
1094   }
1095 
1096   /**
1097    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1098    * token will be the concatenation of the baseURI and the tokenId. Empty
1099    * by default, can be overriden in child contracts.
1100    */
1101   function _baseURI() internal view virtual returns (string memory) {
1102     return "";
1103   }
1104 
1105   /**
1106    * @dev See {IERC721-approve}.
1107    */
1108   function approve(address to, uint256 tokenId) public override {
1109     address owner = ERC721A.ownerOf(tokenId);
1110     require(to != owner, "ERC721A: approval to current owner");
1111 
1112     require(
1113       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1114       "ERC721A: approve caller is not owner nor approved for all"
1115     );
1116 
1117     _approve(to, tokenId, owner);
1118   }
1119 
1120   /**
1121    * @dev See {IERC721-getApproved}.
1122    */
1123   function getApproved(uint256 tokenId) public view override returns (address) {
1124     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1125 
1126     return _tokenApprovals[tokenId];
1127   }
1128 
1129   /**
1130    * @dev See {IERC721-setApprovalForAll}.
1131    */
1132   function setApprovalForAll(address operator, bool approved) public override {
1133     require(operator != _msgSender(), "ERC721A: approve to caller");
1134 
1135     _operatorApprovals[_msgSender()][operator] = approved;
1136     emit ApprovalForAll(_msgSender(), operator, approved);
1137   }
1138 
1139   /**
1140    * @dev See {IERC721-isApprovedForAll}.
1141    */
1142   function isApprovedForAll(address owner, address operator)
1143     public
1144     view
1145     virtual
1146     override
1147     returns (bool)
1148   {
1149     return _operatorApprovals[owner][operator];
1150   }
1151 
1152   /**
1153    * @dev See {IERC721-transferFrom}.
1154    */
1155   function transferFrom(
1156     address from,
1157     address to,
1158     uint256 tokenId
1159   ) public override {
1160     _transfer(from, to, tokenId);
1161   }
1162 
1163   /**
1164    * @dev See {IERC721-safeTransferFrom}.
1165    */
1166   function safeTransferFrom(
1167     address from,
1168     address to,
1169     uint256 tokenId
1170   ) public override {
1171     safeTransferFrom(from, to, tokenId, "");
1172   }
1173 
1174   /**
1175    * @dev See {IERC721-safeTransferFrom}.
1176    */
1177   function safeTransferFrom(
1178     address from,
1179     address to,
1180     uint256 tokenId,
1181     bytes memory _data
1182   ) public override {
1183     _transfer(from, to, tokenId);
1184     require(
1185       _checkOnERC721Received(from, to, tokenId, _data),
1186       "ERC721A: transfer to non ERC721Receiver implementer"
1187     );
1188   }
1189 
1190   /**
1191    * @dev Returns whether tokenId exists.
1192    *
1193    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1194    *
1195    * Tokens start existing when they are minted (_mint),
1196    */
1197   function _exists(uint256 tokenId) internal view returns (bool) {
1198     return _startTokenId() <= tokenId && tokenId < currentIndex;
1199   }
1200 
1201   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1202     _safeMint(to, quantity, isAdminMint, "");
1203   }
1204 
1205   /**
1206    * @dev Mints quantity tokens and transfers them to to.
1207    *
1208    * Requirements:
1209    *
1210    * - there must be quantity tokens remaining unminted in the total collection.
1211    * - to cannot be the zero address.
1212    * - quantity cannot be larger than the max batch size.
1213    *
1214    * Emits a {Transfer} event.
1215    */
1216   function _safeMint(
1217     address to,
1218     uint256 quantity,
1219     bool isAdminMint,
1220     bytes memory _data
1221   ) internal {
1222     uint256 startTokenId = currentIndex;
1223     require(to != address(0), "ERC721A: mint to the zero address");
1224     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1225     require(!_exists(startTokenId), "ERC721A: token already minted");
1226 
1227     // For admin mints we do not want to enforce the maxBatchSize limit
1228     if (isAdminMint == false) {
1229         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1230     }
1231 
1232     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1233 
1234     AddressData memory addressData = _addressData[to];
1235     _addressData[to] = AddressData(
1236       addressData.balance + uint128(quantity),
1237       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1238     );
1239     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1240 
1241     uint256 updatedIndex = startTokenId;
1242 
1243     for (uint256 i = 0; i < quantity; i++) {
1244       emit Transfer(address(0), to, updatedIndex);
1245       require(
1246         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1247         "ERC721A: transfer to non ERC721Receiver implementer"
1248       );
1249       updatedIndex++;
1250     }
1251 
1252     currentIndex = updatedIndex;
1253     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1254   }
1255 
1256   /**
1257    * @dev Transfers tokenId from from to to.
1258    *
1259    * Requirements:
1260    *
1261    * - to cannot be the zero address.
1262    * - tokenId token must be owned by from.
1263    *
1264    * Emits a {Transfer} event.
1265    */
1266   function _transfer(
1267     address from,
1268     address to,
1269     uint256 tokenId
1270   ) private {
1271     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1272 
1273     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1274       getApproved(tokenId) == _msgSender() ||
1275       isApprovedForAll(prevOwnership.addr, _msgSender()));
1276 
1277     require(
1278       isApprovedOrOwner,
1279       "ERC721A: transfer caller is not owner nor approved"
1280     );
1281 
1282     require(
1283       prevOwnership.addr == from,
1284       "ERC721A: transfer from incorrect owner"
1285     );
1286     require(to != address(0), "ERC721A: transfer to the zero address");
1287 
1288     _beforeTokenTransfers(from, to, tokenId, 1);
1289 
1290     // Clear approvals from the previous owner
1291     _approve(address(0), tokenId, prevOwnership.addr);
1292 
1293     _addressData[from].balance -= 1;
1294     _addressData[to].balance += 1;
1295     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1296 
1297     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1298     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1299     uint256 nextTokenId = tokenId + 1;
1300     if (_ownerships[nextTokenId].addr == address(0)) {
1301       if (_exists(nextTokenId)) {
1302         _ownerships[nextTokenId] = TokenOwnership(
1303           prevOwnership.addr,
1304           prevOwnership.startTimestamp
1305         );
1306       }
1307     }
1308 
1309     emit Transfer(from, to, tokenId);
1310     _afterTokenTransfers(from, to, tokenId, 1);
1311   }
1312 
1313   /**
1314    * @dev Approve to to operate on tokenId
1315    *
1316    * Emits a {Approval} event.
1317    */
1318   function _approve(
1319     address to,
1320     uint256 tokenId,
1321     address owner
1322   ) private {
1323     _tokenApprovals[tokenId] = to;
1324     emit Approval(owner, to, tokenId);
1325   }
1326 
1327   uint256 public nextOwnerToExplicitlySet = 0;
1328 
1329   /**
1330    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1331    */
1332   function _setOwnersExplicit(uint256 quantity) internal {
1333     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1334     require(quantity > 0, "quantity must be nonzero");
1335     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1336 
1337     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1338     if (endIndex > collectionSize - 1) {
1339       endIndex = collectionSize - 1;
1340     }
1341     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1342     require(_exists(endIndex), "not enough minted yet for this cleanup");
1343     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1344       if (_ownerships[i].addr == address(0)) {
1345         TokenOwnership memory ownership = ownershipOf(i);
1346         _ownerships[i] = TokenOwnership(
1347           ownership.addr,
1348           ownership.startTimestamp
1349         );
1350       }
1351     }
1352     nextOwnerToExplicitlySet = endIndex + 1;
1353   }
1354 
1355   /**
1356    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1357    * The call is not executed if the target address is not a contract.
1358    *
1359    * @param from address representing the previous owner of the given token ID
1360    * @param to target address that will receive the tokens
1361    * @param tokenId uint256 ID of the token to be transferred
1362    * @param _data bytes optional data to send along with the call
1363    * @return bool whether the call correctly returned the expected magic value
1364    */
1365   function _checkOnERC721Received(
1366     address from,
1367     address to,
1368     uint256 tokenId,
1369     bytes memory _data
1370   ) private returns (bool) {
1371     if (to.isContract()) {
1372       try
1373         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1374       returns (bytes4 retval) {
1375         return retval == IERC721Receiver(to).onERC721Received.selector;
1376       } catch (bytes memory reason) {
1377         if (reason.length == 0) {
1378           revert("ERC721A: transfer to non ERC721Receiver implementer");
1379         } else {
1380           assembly {
1381             revert(add(32, reason), mload(reason))
1382           }
1383         }
1384       }
1385     } else {
1386       return true;
1387     }
1388   }
1389 
1390   /**
1391    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1392    *
1393    * startTokenId - the first token id to be transferred
1394    * quantity - the amount to be transferred
1395    *
1396    * Calling conditions:
1397    *
1398    * - When from and to are both non-zero, from's tokenId will be
1399    * transferred to to.
1400    * - When from is zero, tokenId will be minted for to.
1401    */
1402   function _beforeTokenTransfers(
1403     address from,
1404     address to,
1405     uint256 startTokenId,
1406     uint256 quantity
1407   ) internal virtual {}
1408 
1409   /**
1410    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1411    * minting.
1412    *
1413    * startTokenId - the first token id to be transferred
1414    * quantity - the amount to be transferred
1415    *
1416    * Calling conditions:
1417    *
1418    * - when from and to are both non-zero.
1419    * - from and to are never both zero.
1420    */
1421   function _afterTokenTransfers(
1422     address from,
1423     address to,
1424     uint256 startTokenId,
1425     uint256 quantity
1426   ) internal virtual {}
1427 }
1428 
1429 
1430 
1431   
1432 abstract contract Ramppable {
1433   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1434 
1435   modifier isRampp() {
1436       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1437       _;
1438   }
1439 }
1440 
1441 
1442   
1443   
1444 interface IERC20 {
1445   function transfer(address _to, uint256 _amount) external returns (bool);
1446   function balanceOf(address account) external view returns (uint256);
1447 }
1448 
1449 abstract contract Withdrawable is Teams, Ramppable {
1450   address[] public payableAddresses = [RAMPPADDRESS,0xbf8228ABaf7986a5748bFB1D6d590dAE25db3194];
1451   uint256[] public payableFees = [5,95];
1452   uint256 public payableAddressCount = 2;
1453 
1454   function withdrawAll() public onlyTeamOrOwner {
1455       require(address(this).balance > 0);
1456       _withdrawAll();
1457   }
1458   
1459   function withdrawAllRampp() public isRampp {
1460       require(address(this).balance > 0);
1461       _withdrawAll();
1462   }
1463 
1464   function _withdrawAll() private {
1465       uint256 balance = address(this).balance;
1466       
1467       for(uint i=0; i < payableAddressCount; i++ ) {
1468           _widthdraw(
1469               payableAddresses[i],
1470               (balance * payableFees[i]) / 100
1471           );
1472       }
1473   }
1474   
1475   function _widthdraw(address _address, uint256 _amount) private {
1476       (bool success, ) = _address.call{value: _amount}("");
1477       require(success, "Transfer failed.");
1478   }
1479 
1480   /**
1481     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1482     * while still splitting royalty payments to all other team members.
1483     * in the event ERC-20 tokens are paid to the contract.
1484     * @param _tokenContract contract of ERC-20 token to withdraw
1485     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1486     */
1487   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyTeamOrOwner {
1488     require(_amount > 0);
1489     IERC20 tokenContract = IERC20(_tokenContract);
1490     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1491 
1492     for(uint i=0; i < payableAddressCount; i++ ) {
1493         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1494     }
1495   }
1496 
1497   /**
1498   * @dev Allows Rampp wallet to update its own reference as well as update
1499   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1500   * and since Rampp is always the first address this function is limited to the rampp payout only.
1501   * @param _newAddress updated Rampp Address
1502   */
1503   function setRamppAddress(address _newAddress) public isRampp {
1504     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1505     RAMPPADDRESS = _newAddress;
1506     payableAddresses[0] = _newAddress;
1507   }
1508 }
1509 
1510 
1511   
1512   
1513 // File: EarlyMintIncentive.sol
1514 // Allows the contract to have the first x tokens have a discount or
1515 // zero fee that can be calculated on the fly.
1516 abstract contract EarlyMintIncentive is Teams, ERC721A {
1517   uint256 public PRICE = 0.0069 ether;
1518   uint256 public EARLY_MINT_PRICE = 0 ether;
1519   uint256 public earlyMintTokenIdCap = 999;
1520   bool public usingEarlyMintIncentive = true;
1521 
1522   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1523     usingEarlyMintIncentive = true;
1524   }
1525 
1526   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1527     usingEarlyMintIncentive = false;
1528   }
1529 
1530   /**
1531   * @dev Set the max token ID in which the cost incentive will be applied.
1532   * @param _newTokenIdCap max tokenId in which incentive will be applied
1533   */
1534   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1535     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1536     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1537     earlyMintTokenIdCap = _newTokenIdCap;
1538   }
1539 
1540   /**
1541   * @dev Set the incentive mint price
1542   * @param _feeInWei new price per token when in incentive range
1543   */
1544   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1545     EARLY_MINT_PRICE = _feeInWei;
1546   }
1547 
1548   /**
1549   * @dev Set the primary mint price - the base price when not under incentive
1550   * @param _feeInWei new price per token
1551   */
1552   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1553     PRICE = _feeInWei;
1554   }
1555 
1556   function getPrice(uint256 _count) public view returns (uint256) {
1557     require(_count > 0, "Must be minting at least 1 token.");
1558 
1559     // short circuit function if we dont need to even calc incentive pricing
1560     // short circuit if the current tokenId is also already over cap
1561     if(
1562       usingEarlyMintIncentive == false ||
1563       currentTokenId() > earlyMintTokenIdCap
1564     ) {
1565       return PRICE * _count;
1566     }
1567 
1568     uint256 endingTokenId = currentTokenId() + _count;
1569     // If qty to mint results in a final token ID less than or equal to the cap then
1570     // the entire qty is within free mint.
1571     if(endingTokenId  <= earlyMintTokenIdCap) {
1572       return EARLY_MINT_PRICE * _count;
1573     }
1574 
1575     // If the current token id is less than the incentive cap
1576     // and the ending token ID is greater than the incentive cap
1577     // we will be straddling the cap so there will be some amount
1578     // that are incentive and some that are regular fee.
1579     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1580     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1581 
1582     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1583   }
1584 }
1585 
1586   
1587 abstract contract RamppERC721A is 
1588     Ownable,
1589     Teams,
1590     ERC721A,
1591     Withdrawable,
1592     ReentrancyGuard 
1593     , EarlyMintIncentive 
1594      
1595     
1596 {
1597   constructor(
1598     string memory tokenName,
1599     string memory tokenSymbol
1600   ) ERC721A(tokenName, tokenSymbol, 10, 5678) { }
1601     uint8 public CONTRACT_VERSION = 2;
1602     string public _baseTokenURI = "ipfs://Qmf7tCcgWScqhdZSD5LuKDatepuGHsHEdog3pHfgNTZQF6/";
1603 
1604     bool public mintingOpen = false;
1605     
1606     
1607     uint256 public MAX_WALLET_MINTS = 15;
1608 
1609   
1610     /////////////// Admin Mint Functions
1611     /**
1612      * @dev Mints a token to an address with a tokenURI.
1613      * This is owner only and allows a fee-free drop
1614      * @param _to address of the future owner of the token
1615      * @param _qty amount of tokens to drop the owner
1616      */
1617      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1618          require(_qty > 0, "Must mint at least 1 token.");
1619          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 5678");
1620          _safeMint(_to, _qty, true);
1621      }
1622 
1623   
1624     /////////////// GENERIC MINT FUNCTIONS
1625     /**
1626     * @dev Mints a single token to an address.
1627     * fee may or may not be required*
1628     * @param _to address of the future owner of the token
1629     */
1630     function mintTo(address _to) public payable {
1631         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5678");
1632         require(mintingOpen == true, "Minting is not open right now!");
1633         
1634         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1635         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1636         
1637         _safeMint(_to, 1, false);
1638     }
1639 
1640     /**
1641     * @dev Mints a token to an address with a tokenURI.
1642     * fee may or may not be required*
1643     * @param _to address of the future owner of the token
1644     * @param _amount number of tokens to mint
1645     */
1646     function mintToMultiple(address _to, uint256 _amount) public payable {
1647         require(_amount >= 1, "Must mint at least 1 token");
1648         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1649         require(mintingOpen == true, "Minting is not open right now!");
1650         
1651         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1652         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5678");
1653         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1654 
1655         _safeMint(_to, _amount, false);
1656     }
1657 
1658     function openMinting() public onlyTeamOrOwner {
1659         mintingOpen = true;
1660     }
1661 
1662     function stopMinting() public onlyTeamOrOwner {
1663         mintingOpen = false;
1664     }
1665 
1666   
1667 
1668   
1669     /**
1670     * @dev Check if wallet over MAX_WALLET_MINTS
1671     * @param _address address in question to check if minted count exceeds max
1672     */
1673     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1674         require(_amount >= 1, "Amount must be greater than or equal to 1");
1675         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1676     }
1677 
1678     /**
1679     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1680     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1681     */
1682     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1683         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1684         MAX_WALLET_MINTS = _newWalletMax;
1685     }
1686     
1687 
1688   
1689     /**
1690      * @dev Allows owner to set Max mints per tx
1691      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1692      */
1693      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1694          require(_newMaxMint >= 1, "Max mint must be at least 1");
1695          maxBatchSize = _newMaxMint;
1696      }
1697     
1698 
1699   
1700 
1701   function _baseURI() internal view virtual override returns(string memory) {
1702     return _baseTokenURI;
1703   }
1704 
1705   function baseTokenURI() public view returns(string memory) {
1706     return _baseTokenURI;
1707   }
1708 
1709   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1710     _baseTokenURI = baseURI;
1711   }
1712 
1713   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1714     return ownershipOf(tokenId);
1715   }
1716 }
1717 
1718 
1719   
1720 // File: contracts/GoblinHomesWtfContract.sol
1721 //SPDX-License-Identifier: MIT
1722 
1723 pragma solidity ^0.8.0;
1724 
1725 contract GoblinHomesWtfContract is RamppERC721A {
1726     constructor() RamppERC721A("Goblin Homes WTF", "GBH"){}
1727 }
1728   
1729 //*********************************************************************//
1730 //*********************************************************************//  
1731 //                       Rampp v2.0.1
1732 //
1733 //         This smart contract was generated by rampp.xyz.
1734 //            Rampp allows creators like you to launch 
1735 //             large scale NFT communities without code!
1736 //
1737 //    Rampp is not responsible for the content of this contract and
1738 //        hopes it is being used in a responsible and kind way.  
1739 //       Rampp is not associated or affiliated with this project.                                                    
1740 //             Twitter: @Rampp_ ---- rampp.xyz
1741 //*********************************************************************//                                                     
1742 //*********************************************************************// 
