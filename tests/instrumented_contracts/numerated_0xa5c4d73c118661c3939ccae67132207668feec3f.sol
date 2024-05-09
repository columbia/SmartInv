1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-13
3 */
4 
5 //*********************************************************************//
6 //*********************************************************************//
7 //
8 //  ________  ________  _________  ________  ________   ________          _______  _________  ___  ___     
9 // |\   __  \|\   __  \|\___   ___\\   __  \|\   ___  \|\   ____\        |\  ___ \|\___   ___\\  \|\  \    
10 // \ \  \|\ /\ \  \|\  \|___ \  \_\ \  \|\  \ \  \\ \  \ \  \___|        \ \   __/\|___ \  \_\ \  \\\  \   
11 //  \ \   __  \ \   __  \   \ \  \ \ \   __  \ \  \\ \  \ \  \  ___       \ \  \_|/__  \ \  \ \ \   __  \  
12 //   \ \  \|\  \ \  \ \  \   \ \  \ \ \  \ \  \ \  \\ \  \ \  \|\  \       \ \  \_|\ \  \ \  \ \ \  \ \  \ 
13 //    \ \_______\ \__\ \__\   \ \__\ \ \__\ \__\ \__\\ \__\ \_______\       \ \_______\  \ \__\ \ \__\ \__\
14 //     \|_______|\|__|\|__|    \|__|  \|__|\|__|\|__| \|__|\|_______|        \|_______|   \|__|  \|__|\|__|
15 //                                                                                                         
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
785   pragma solidity ^0.8.0;
786 
787   /**
788   * @dev These functions deal with verification of Merkle Trees proofs.
789   *
790   * The proofs can be generated using the JavaScript library
791   * https://github.com/miguelmota/merkletreejs[merkletreejs].
792   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
793   *
794   *
795   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
796   * hashing, or use a hash function other than keccak256 for hashing leaves.
797   * This is because the concatenation of a sorted pair of internal nodes in
798   * the merkle tree could be reinterpreted as a leaf value.
799   */
800   library MerkleProof {
801       /**
802       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
803       * defined by 'root'. For this, a 'proof' must be provided, containing
804       * sibling hashes on the branch from the leaf to the root of the tree. Each
805       * pair of leaves and each pair of pre-images are assumed to be sorted.
806       */
807       function verify(
808           bytes32[] memory proof,
809           bytes32 root,
810           bytes32 leaf
811       ) internal pure returns (bool) {
812           return processProof(proof, leaf) == root;
813       }
814 
815       /**
816       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
817       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
818       * hash matches the root of the tree. When processing the proof, the pairs
819       * of leafs & pre-images are assumed to be sorted.
820       *
821       * _Available since v4.4._
822       */
823       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
824           bytes32 computedHash = leaf;
825           for (uint256 i = 0; i < proof.length; i++) {
826               bytes32 proofElement = proof[i];
827               if (computedHash <= proofElement) {
828                   // Hash(current computed hash + current element of the proof)
829                   computedHash = _efficientHash(computedHash, proofElement);
830               } else {
831                   // Hash(current element of the proof + current computed hash)
832                   computedHash = _efficientHash(proofElement, computedHash);
833               }
834           }
835           return computedHash;
836       }
837 
838       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
839           assembly {
840               mstore(0x00, a)
841               mstore(0x20, b)
842               value := keccak256(0x00, 0x40)
843           }
844       }
845   }
846 
847 
848   // File: Allowlist.sol
849 
850   pragma solidity ^0.8.0;
851 
852   abstract contract Allowlist is Ownable {
853     bytes32 public merkleRoot = 0xaee2ffc5034334237b087a54b6abda041a4e6ce5f60eefe670cc8c8873f95ad1;
854     bool public onlyAllowlistMode = true;
855 
856     /**
857      * @dev Update merkle root to reflect changes in Allowlist
858      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
859      */
860     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyOwner {
861       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
862       merkleRoot = _newMerkleRoot;
863     }
864 
865     /**
866      * @dev Check the proof of an address if valid for merkle root
867      * @param _to address to check for proof
868      * @param _merkleProof Proof of the address to validate against root and leaf
869      */
870     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
871       require(merkleRoot != 0, "Merkle root is not set!");
872       bytes32 leaf = keccak256(abi.encodePacked(_to));
873 
874       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
875     }
876 
877     
878     function enableAllowlistOnlyMode() public onlyOwner {
879       onlyAllowlistMode = true;
880     }
881 
882     function disableAllowlistOnlyMode() public onlyOwner {
883         onlyAllowlistMode = false;
884     }
885   }
886   
887   
888 /**
889  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
890  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
891  *
892  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
893  * 
894  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
895  *
896  * Does not support burning tokens to address(0).
897  */
898 contract ERC721A is
899   Context,
900   ERC165,
901   IERC721,
902   IERC721Metadata,
903   IERC721Enumerable
904 {
905   using Address for address;
906   using Strings for uint256;
907 
908   struct TokenOwnership {
909     address addr;
910     uint64 startTimestamp;
911   }
912 
913   struct AddressData {
914     uint128 balance;
915     uint128 numberMinted;
916   }
917 
918   uint256 private currentIndex;
919 
920   uint256 public immutable collectionSize;
921   uint256 public maxBatchSize;
922 
923   // Token name
924   string private _name;
925 
926   // Token symbol
927   string private _symbol;
928 
929   // Mapping from token ID to ownership details
930   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
931   mapping(uint256 => TokenOwnership) private _ownerships;
932 
933   // Mapping owner address to address data
934   mapping(address => AddressData) private _addressData;
935 
936   // Mapping from token ID to approved address
937   mapping(uint256 => address) private _tokenApprovals;
938 
939   // Mapping from owner to operator approvals
940   mapping(address => mapping(address => bool)) private _operatorApprovals;
941 
942   /**
943    * @dev
944    * maxBatchSize refers to how much a minter can mint at a time.
945    * collectionSize_ refers to how many tokens are in the collection.
946    */
947   constructor(
948     string memory name_,
949     string memory symbol_,
950     uint256 maxBatchSize_,
951     uint256 collectionSize_
952   ) {
953     require(
954       collectionSize_ > 0,
955       "ERC721A: collection must have a nonzero supply"
956     );
957     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
958     _name = name_;
959     _symbol = symbol_;
960     maxBatchSize = maxBatchSize_;
961     collectionSize = collectionSize_;
962     currentIndex = _startTokenId();
963   }
964 
965   /**
966   * To change the starting tokenId, please override this function.
967   */
968   function _startTokenId() internal view virtual returns (uint256) {
969     return 1;
970   }
971 
972   /**
973    * @dev See {IERC721Enumerable-totalSupply}.
974    */
975   function totalSupply() public view override returns (uint256) {
976     return _totalMinted();
977   }
978 
979   function currentTokenId() public view returns (uint256) {
980     return _totalMinted();
981   }
982 
983   function getNextTokenId() public view returns (uint256) {
984       return _totalMinted() + 1;
985   }
986 
987   /**
988   * Returns the total amount of tokens minted in the contract.
989   */
990   function _totalMinted() internal view returns (uint256) {
991     unchecked {
992       return currentIndex - _startTokenId();
993     }
994   }
995 
996   /**
997    * @dev See {IERC721Enumerable-tokenByIndex}.
998    */
999   function tokenByIndex(uint256 index) public view override returns (uint256) {
1000     require(index < totalSupply(), "ERC721A: global index out of bounds");
1001     return index;
1002   }
1003 
1004   /**
1005    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1006    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1007    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1008    */
1009   function tokenOfOwnerByIndex(address owner, uint256 index)
1010     public
1011     view
1012     override
1013     returns (uint256)
1014   {
1015     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1016     uint256 numMintedSoFar = totalSupply();
1017     uint256 tokenIdsIdx = 0;
1018     address currOwnershipAddr = address(0);
1019     for (uint256 i = 0; i < numMintedSoFar; i++) {
1020       TokenOwnership memory ownership = _ownerships[i];
1021       if (ownership.addr != address(0)) {
1022         currOwnershipAddr = ownership.addr;
1023       }
1024       if (currOwnershipAddr == owner) {
1025         if (tokenIdsIdx == index) {
1026           return i;
1027         }
1028         tokenIdsIdx++;
1029       }
1030     }
1031     revert("ERC721A: unable to get token of owner by index");
1032   }
1033 
1034   /**
1035    * @dev See {IERC165-supportsInterface}.
1036    */
1037   function supportsInterface(bytes4 interfaceId)
1038     public
1039     view
1040     virtual
1041     override(ERC165, IERC165)
1042     returns (bool)
1043   {
1044     return
1045       interfaceId == type(IERC721).interfaceId ||
1046       interfaceId == type(IERC721Metadata).interfaceId ||
1047       interfaceId == type(IERC721Enumerable).interfaceId ||
1048       super.supportsInterface(interfaceId);
1049   }
1050 
1051   /**
1052    * @dev See {IERC721-balanceOf}.
1053    */
1054   function balanceOf(address owner) public view override returns (uint256) {
1055     require(owner != address(0), "ERC721A: balance query for the zero address");
1056     return uint256(_addressData[owner].balance);
1057   }
1058 
1059   function _numberMinted(address owner) internal view returns (uint256) {
1060     require(
1061       owner != address(0),
1062       "ERC721A: number minted query for the zero address"
1063     );
1064     return uint256(_addressData[owner].numberMinted);
1065   }
1066 
1067   function ownershipOf(uint256 tokenId)
1068     internal
1069     view
1070     returns (TokenOwnership memory)
1071   {
1072     uint256 curr = tokenId;
1073 
1074     unchecked {
1075         if (_startTokenId() <= curr && curr < currentIndex) {
1076             TokenOwnership memory ownership = _ownerships[curr];
1077             if (ownership.addr != address(0)) {
1078                 return ownership;
1079             }
1080 
1081             // Invariant:
1082             // There will always be an ownership that has an address and is not burned
1083             // before an ownership that does not have an address and is not burned.
1084             // Hence, curr will not underflow.
1085             while (true) {
1086                 curr--;
1087                 ownership = _ownerships[curr];
1088                 if (ownership.addr != address(0)) {
1089                     return ownership;
1090                 }
1091             }
1092         }
1093     }
1094 
1095     revert("ERC721A: unable to determine the owner of token");
1096   }
1097 
1098   /**
1099    * @dev See {IERC721-ownerOf}.
1100    */
1101   function ownerOf(uint256 tokenId) public view override returns (address) {
1102     return ownershipOf(tokenId).addr;
1103   }
1104 
1105   /**
1106    * @dev See {IERC721Metadata-name}.
1107    */
1108   function name() public view virtual override returns (string memory) {
1109     return _name;
1110   }
1111 
1112   /**
1113    * @dev See {IERC721Metadata-symbol}.
1114    */
1115   function symbol() public view virtual override returns (string memory) {
1116     return _symbol;
1117   }
1118 
1119   /**
1120    * @dev See {IERC721Metadata-tokenURI}.
1121    */
1122   function tokenURI(uint256 tokenId)
1123     public
1124     view
1125     virtual
1126     override
1127     returns (string memory)
1128   {
1129     string memory baseURI = _baseURI();
1130     return
1131       bytes(baseURI).length > 0
1132         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1133         : "";
1134   }
1135 
1136   /**
1137    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1138    * token will be the concatenation of the baseURI and the tokenId. Empty
1139    * by default, can be overriden in child contracts.
1140    */
1141   function _baseURI() internal view virtual returns (string memory) {
1142     return "";
1143   }
1144 
1145   /**
1146    * @dev See {IERC721-approve}.
1147    */
1148   function approve(address to, uint256 tokenId) public override {
1149     address owner = ERC721A.ownerOf(tokenId);
1150     require(to != owner, "ERC721A: approval to current owner");
1151 
1152     require(
1153       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1154       "ERC721A: approve caller is not owner nor approved for all"
1155     );
1156 
1157     _approve(to, tokenId, owner);
1158   }
1159 
1160   /**
1161    * @dev See {IERC721-getApproved}.
1162    */
1163   function getApproved(uint256 tokenId) public view override returns (address) {
1164     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1165 
1166     return _tokenApprovals[tokenId];
1167   }
1168 
1169   /**
1170    * @dev See {IERC721-setApprovalForAll}.
1171    */
1172   function setApprovalForAll(address operator, bool approved) public override {
1173     require(operator != _msgSender(), "ERC721A: approve to caller");
1174 
1175     _operatorApprovals[_msgSender()][operator] = approved;
1176     emit ApprovalForAll(_msgSender(), operator, approved);
1177   }
1178 
1179   /**
1180    * @dev See {IERC721-isApprovedForAll}.
1181    */
1182   function isApprovedForAll(address owner, address operator)
1183     public
1184     view
1185     virtual
1186     override
1187     returns (bool)
1188   {
1189     return _operatorApprovals[owner][operator];
1190   }
1191 
1192   /**
1193    * @dev See {IERC721-transferFrom}.
1194    */
1195   function transferFrom(
1196     address from,
1197     address to,
1198     uint256 tokenId
1199   ) public override {
1200     _transfer(from, to, tokenId);
1201   }
1202 
1203   /**
1204    * @dev See {IERC721-safeTransferFrom}.
1205    */
1206   function safeTransferFrom(
1207     address from,
1208     address to,
1209     uint256 tokenId
1210   ) public override {
1211     safeTransferFrom(from, to, tokenId, "");
1212   }
1213 
1214   /**
1215    * @dev See {IERC721-safeTransferFrom}.
1216    */
1217   function safeTransferFrom(
1218     address from,
1219     address to,
1220     uint256 tokenId,
1221     bytes memory _data
1222   ) public override {
1223     _transfer(from, to, tokenId);
1224     require(
1225       _checkOnERC721Received(from, to, tokenId, _data),
1226       "ERC721A: transfer to non ERC721Receiver implementer"
1227     );
1228   }
1229 
1230   /**
1231    * @dev Returns whether tokenId exists.
1232    *
1233    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1234    *
1235    * Tokens start existing when they are minted (_mint),
1236    */
1237   function _exists(uint256 tokenId) internal view returns (bool) {
1238     return _startTokenId() <= tokenId && tokenId < currentIndex;
1239   }
1240 
1241   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1242     _safeMint(to, quantity, isAdminMint, "");
1243   }
1244 
1245   /**
1246    * @dev Mints quantity tokens and transfers them to to.
1247    *
1248    * Requirements:
1249    *
1250    * - there must be quantity tokens remaining unminted in the total collection.
1251    * - to cannot be the zero address.
1252    * - quantity cannot be larger than the max batch size.
1253    *
1254    * Emits a {Transfer} event.
1255    */
1256   function _safeMint(
1257     address to,
1258     uint256 quantity,
1259     bool isAdminMint,
1260     bytes memory _data
1261   ) internal {
1262     uint256 startTokenId = currentIndex;
1263     require(to != address(0), "ERC721A: mint to the zero address");
1264     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1265     require(!_exists(startTokenId), "ERC721A: token already minted");
1266 
1267     // For admin mints we do not want to enforce the maxBatchSize limit
1268     if (isAdminMint == false) {
1269         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1270     }
1271 
1272     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1273 
1274     AddressData memory addressData = _addressData[to];
1275     _addressData[to] = AddressData(
1276       addressData.balance + uint128(quantity),
1277       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1278     );
1279     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1280 
1281     uint256 updatedIndex = startTokenId;
1282 
1283     for (uint256 i = 0; i < quantity; i++) {
1284       emit Transfer(address(0), to, updatedIndex);
1285       require(
1286         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1287         "ERC721A: transfer to non ERC721Receiver implementer"
1288       );
1289       updatedIndex++;
1290     }
1291 
1292     currentIndex = updatedIndex;
1293     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1294   }
1295 
1296   /**
1297    * @dev Transfers tokenId from from to to.
1298    *
1299    * Requirements:
1300    *
1301    * - to cannot be the zero address.
1302    * - tokenId token must be owned by from.
1303    *
1304    * Emits a {Transfer} event.
1305    */
1306   function _transfer(
1307     address from,
1308     address to,
1309     uint256 tokenId
1310   ) private {
1311     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1312 
1313     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1314       getApproved(tokenId) == _msgSender() ||
1315       isApprovedForAll(prevOwnership.addr, _msgSender()));
1316 
1317     require(
1318       isApprovedOrOwner,
1319       "ERC721A: transfer caller is not owner nor approved"
1320     );
1321 
1322     require(
1323       prevOwnership.addr == from,
1324       "ERC721A: transfer from incorrect owner"
1325     );
1326     require(to != address(0), "ERC721A: transfer to the zero address");
1327 
1328     _beforeTokenTransfers(from, to, tokenId, 1);
1329 
1330     // Clear approvals from the previous owner
1331     _approve(address(0), tokenId, prevOwnership.addr);
1332 
1333     _addressData[from].balance -= 1;
1334     _addressData[to].balance += 1;
1335     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1336 
1337     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1338     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1339     uint256 nextTokenId = tokenId + 1;
1340     if (_ownerships[nextTokenId].addr == address(0)) {
1341       if (_exists(nextTokenId)) {
1342         _ownerships[nextTokenId] = TokenOwnership(
1343           prevOwnership.addr,
1344           prevOwnership.startTimestamp
1345         );
1346       }
1347     }
1348 
1349     emit Transfer(from, to, tokenId);
1350     _afterTokenTransfers(from, to, tokenId, 1);
1351   }
1352 
1353   /**
1354    * @dev Approve to to operate on tokenId
1355    *
1356    * Emits a {Approval} event.
1357    */
1358   function _approve(
1359     address to,
1360     uint256 tokenId,
1361     address owner
1362   ) private {
1363     _tokenApprovals[tokenId] = to;
1364     emit Approval(owner, to, tokenId);
1365   }
1366 
1367   uint256 public nextOwnerToExplicitlySet = 0;
1368 
1369   /**
1370    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1371    */
1372   function _setOwnersExplicit(uint256 quantity) internal {
1373     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1374     require(quantity > 0, "quantity must be nonzero");
1375     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1376 
1377     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1378     if (endIndex > collectionSize - 1) {
1379       endIndex = collectionSize - 1;
1380     }
1381     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1382     require(_exists(endIndex), "not enough minted yet for this cleanup");
1383     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1384       if (_ownerships[i].addr == address(0)) {
1385         TokenOwnership memory ownership = ownershipOf(i);
1386         _ownerships[i] = TokenOwnership(
1387           ownership.addr,
1388           ownership.startTimestamp
1389         );
1390       }
1391     }
1392     nextOwnerToExplicitlySet = endIndex + 1;
1393   }
1394 
1395   /**
1396    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1397    * The call is not executed if the target address is not a contract.
1398    *
1399    * @param from address representing the previous owner of the given token ID
1400    * @param to target address that will receive the tokens
1401    * @param tokenId uint256 ID of the token to be transferred
1402    * @param _data bytes optional data to send along with the call
1403    * @return bool whether the call correctly returned the expected magic value
1404    */
1405   function _checkOnERC721Received(
1406     address from,
1407     address to,
1408     uint256 tokenId,
1409     bytes memory _data
1410   ) private returns (bool) {
1411     if (to.isContract()) {
1412       try
1413         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1414       returns (bytes4 retval) {
1415         return retval == IERC721Receiver(to).onERC721Received.selector;
1416       } catch (bytes memory reason) {
1417         if (reason.length == 0) {
1418           revert("ERC721A: transfer to non ERC721Receiver implementer");
1419         } else {
1420           assembly {
1421             revert(add(32, reason), mload(reason))
1422           }
1423         }
1424       }
1425     } else {
1426       return true;
1427     }
1428   }
1429 
1430   /**
1431    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1432    *
1433    * startTokenId - the first token id to be transferred
1434    * quantity - the amount to be transferred
1435    *
1436    * Calling conditions:
1437    *
1438    * - When from and to are both non-zero, from's tokenId will be
1439    * transferred to to.
1440    * - When from is zero, tokenId will be minted for to.
1441    */
1442   function _beforeTokenTransfers(
1443     address from,
1444     address to,
1445     uint256 startTokenId,
1446     uint256 quantity
1447   ) internal virtual {}
1448 
1449   /**
1450    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1451    * minting.
1452    *
1453    * startTokenId - the first token id to be transferred
1454    * quantity - the amount to be transferred
1455    *
1456    * Calling conditions:
1457    *
1458    * - when from and to are both non-zero.
1459    * - from and to are never both zero.
1460    */
1461   function _afterTokenTransfers(
1462     address from,
1463     address to,
1464     uint256 startTokenId,
1465     uint256 quantity
1466   ) internal virtual {}
1467 }
1468 
1469 
1470   
1471 /** TimedDrop.sol
1472 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1473 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1474 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1475 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1476 */
1477 abstract contract TimedDrop is Ownable {
1478   bool public enforcePublicDropTime = true;
1479   uint256 public publicDropTime = 1658113200;
1480   
1481   /**
1482   * @dev Allow the contract owner to set the public time to mint.
1483   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1484   */
1485   function setPublicDropTime(uint256 _newDropTime) public onlyOwner {
1486     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disablePublicDropTime!");
1487     publicDropTime = _newDropTime;
1488   }
1489 
1490   function usePublicDropTime() public onlyOwner {
1491     enforcePublicDropTime = true;
1492   }
1493 
1494   function disablePublicDropTime() public onlyOwner {
1495     enforcePublicDropTime = false;
1496   }
1497 
1498   /**
1499   * @dev determine if the public droptime has passed.
1500   * if the feature is disabled then assume the time has passed.
1501   */
1502   function publicDropTimePassed() public view returns(bool) {
1503     if(enforcePublicDropTime == false) {
1504       return true;
1505     }
1506     return block.timestamp >= publicDropTime;
1507   }
1508   
1509   // Allowlist implementation of the Timed Drop feature
1510   bool public enforceAllowlistDropTime = true;
1511   uint256 public allowlistDropTime = 1657854000;
1512 
1513   /**
1514   * @dev Allow the contract owner to set the allowlist time to mint.
1515   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1516   */
1517   function setAllowlistDropTime(uint256 _newDropTime) public onlyOwner {
1518     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disableAllowlistDropTime!");
1519     allowlistDropTime = _newDropTime;
1520   }
1521 
1522   function useAllowlistDropTime() public onlyOwner {
1523     enforceAllowlistDropTime = true;
1524   }
1525 
1526   function disableAllowlistDropTime() public onlyOwner {
1527     enforceAllowlistDropTime = false;
1528   }
1529 
1530   function allowlistDropTimePassed() public view returns(bool) {
1531     if(enforceAllowlistDropTime == false) {
1532       return true;
1533     }
1534 
1535     return block.timestamp >= allowlistDropTime;
1536   }
1537 }
1538 
1539   
1540 interface IERC20 {
1541   function transfer(address _to, uint256 _amount) external returns (bool);
1542   function balanceOf(address account) external view returns (uint256);
1543 }
1544 
1545 abstract contract Withdrawable is Ownable {
1546   address[] public payableAddresses = [0xb4a9391C658bc1d5a4fd7928c5306d16046141f8];
1547   uint256[] public payableFees = [100];
1548   uint256 public payableAddressCount = 1;
1549 
1550   function withdrawAll() public onlyOwner {
1551       require(address(this).balance > 0);
1552       _withdrawAll();
1553   }
1554   
1555   function _withdrawAll() private {
1556       uint256 balance = address(this).balance;
1557       
1558       for(uint i=0; i < payableAddressCount; i++ ) {
1559           _widthdraw(
1560               payableAddresses[i],
1561               (balance * payableFees[i]) / 100
1562           );
1563       }
1564   }
1565   
1566   function _widthdraw(address _address, uint256 _amount) private {
1567       (bool success, ) = _address.call{value: _amount}("");
1568       require(success, "Transfer failed.");
1569   }
1570 
1571   /**
1572     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1573     * while still splitting royalty payments to all other team members.
1574     * in the event ERC-20 tokens are paid to the contract.
1575     * @param _tokenContract contract of ERC-20 token to withdraw
1576     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1577     */
1578   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1579     require(_amount > 0);
1580     IERC20 tokenContract = IERC20(_tokenContract);
1581     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1582 
1583     for(uint i=0; i < payableAddressCount; i++ ) {
1584         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1585     }
1586   }
1587 }
1588 
1589 
1590   
1591   
1592 // File: EarlyMintIncentive.sol
1593 // Allows the contract to have the first x tokens have a discount or
1594 // zero fee that can be calculated on the fly.
1595 abstract contract EarlyMintIncentive is Ownable, ERC721A {
1596   uint256 public PRICE = 0.05 ether;
1597   uint256 public EARLY_MINT_PRICE = 0.045 ether;
1598   uint256 public earlyMintTokenIdCap = 1500;
1599   bool public usingEarlyMintIncentive = true;
1600 
1601   function enableEarlyMintIncentive() public onlyOwner {
1602     usingEarlyMintIncentive = true;
1603   }
1604 
1605   function disableEarlyMintIncentive() public onlyOwner {
1606     usingEarlyMintIncentive = false;
1607   }
1608 
1609   /**
1610   * @dev Set the max token ID in which the cost incentive will be applied.
1611   * @param _newTokenIdCap max tokenId in which incentive will be applied
1612   */
1613   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyOwner {
1614     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1615     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1616     earlyMintTokenIdCap = _newTokenIdCap;
1617   }
1618 
1619   /**
1620   * @dev Set the incentive mint price
1621   * @param _feeInWei new price per token when in incentive range
1622   */
1623   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyOwner {
1624     EARLY_MINT_PRICE = _feeInWei;
1625   }
1626 
1627   /**
1628   * @dev Set the primary mint price - the base price when not under incentive
1629   * @param _feeInWei new price per token
1630   */
1631   function setPrice(uint256 _feeInWei) public onlyOwner {
1632     PRICE = _feeInWei;
1633   }
1634 
1635   function getPrice(uint256 _count) public view returns (uint256) {
1636     require(_count > 0, "Must be minting at least 1 token.");
1637 
1638     // short circuit function if we dont need to even calc incentive pricing
1639     // short circuit if the current tokenId is also already over cap
1640     if(
1641       usingEarlyMintIncentive == false ||
1642       currentTokenId() > earlyMintTokenIdCap
1643     ) {
1644       return PRICE * _count;
1645     }
1646 
1647     uint256 endingTokenId = currentTokenId() + _count;
1648     // If qty to mint results in a final token ID less than or equal to the cap then
1649     // the entire qty is within free mint.
1650     if(endingTokenId  <= earlyMintTokenIdCap) {
1651       return EARLY_MINT_PRICE * _count;
1652     }
1653 
1654     // If the current token id is less than the incentive cap
1655     // and the ending token ID is greater than the incentive cap
1656     // we will be straddling the cap so there will be some amount
1657     // that are incentive and some that are regular fee.
1658     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1659     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1660 
1661     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1662   }
1663 }
1664 
1665   
1666 abstract contract BethERC721A is 
1667     Ownable,
1668     ERC721A,
1669     Withdrawable,
1670     ReentrancyGuard 
1671     , EarlyMintIncentive 
1672     , Allowlist 
1673     , TimedDrop
1674 {
1675   constructor(
1676     string memory tokenName,
1677     string memory tokenSymbol
1678   ) ERC721A(tokenName, tokenSymbol, 2, 4000) { }
1679     uint8 public CONTRACT_VERSION = 2;
1680     string public _baseTokenURI = "ipfs/bafybeib7ivflhuw3ucbmieybglsdq2lkxhpkbmjz7g4hzw6xn3wmrol5e4/";
1681 
1682     bool public mintingOpen = true;
1683     bool public isRevealed = false;
1684     
1685     uint256 public MAX_WALLET_MINTS = 50;
1686 
1687     mapping(address => bool) public OGClaimed;
1688     mapping(address => bool) public whitelistClaimed;
1689     mapping(address => bool) public freeMintClaimed;
1690 
1691   
1692     /////////////// Admin Mint Functions
1693     /**
1694      * @dev Mints a token to an address with a tokenURI.
1695      * This is owner only and allows a fee-free drop
1696      * @param _to address of the future owner of the token
1697      * @param _qty amount of tokens to drop the owner
1698      */
1699      function mintToAdminV2(address _to, uint256 _qty) public onlyOwner{
1700          require(_qty > 0, "Must mint at least 1 token.");
1701          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 5000");
1702          _safeMint(_to, _qty, true);
1703      }
1704 
1705   
1706     /////////////// GENERIC MINT FUNCTIONS
1707     /**
1708     * @dev Mints a single token to an address.
1709     * fee may or may not be required*
1710     * @param _to address of the future owner of the token
1711     */
1712     function mintTo(address _to) public payable {
1713         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1714         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1715         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1716         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1717         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1718         
1719         _safeMint(_to, 1, false);
1720     }
1721 
1722     /**
1723     * @dev Mints a token to an address with a tokenURI.
1724     * fee may or may not be required*
1725     * @param _to address of the future owner of the token
1726     * @param _amount number of tokens to mint
1727     */
1728     function mintToMultiple(address _to, uint256 _amount) public payable {
1729         require(_amount >= 1, "Must mint at least 1 token");
1730         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1731         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1732         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1733         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1734         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5000");
1735         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1736 
1737         _safeMint(_to, _amount, false);
1738     }
1739 
1740     function openMinting() public onlyOwner {
1741         mintingOpen = true;
1742     }
1743 
1744     function stopMinting() public onlyOwner {
1745         mintingOpen = false;
1746     }
1747 
1748   
1749     ///////////// ALLOWLIST MINTING FUNCTIONS
1750 
1751     /**
1752     * @dev Mints a token to an address with a tokenURI for allowlist.
1753     * fee may or may not be required*
1754     * @param _to address of the future owner of the token
1755     */
1756     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1757         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1758         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1759         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1760         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1761         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1762         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
1763 
1764         _safeMint(_to, 1, false);
1765     }
1766 
1767     /**
1768     * @dev Mints a token to an address with a tokenURI for allowlist.
1769     * fee may or may not be required*
1770     * @param _to address of the future owner of the token
1771     * @param _amount number of tokens to mint
1772     */
1773     function mintToMultipleOG(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1774         require(!OGClaimed[msg.sender], "Address already claimed");
1775         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1776         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1777         require(_amount >= 1, "Must mint at least 1 token");
1778         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1779 
1780         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1781         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5000");
1782         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1783         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
1784 
1785         _safeMint(_to, _amount, false);
1786         OGClaimed[msg.sender] = true;
1787     }
1788 
1789     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1790         require(!whitelistClaimed[msg.sender], "Address already claimed");
1791         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1792         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1793         require(_amount >= 1, "Must mint at least 1 token");
1794         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1795 
1796         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1797         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5000");
1798         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1799         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
1800 
1801         _safeMint(_to, _amount, false);
1802         whitelistClaimed[msg.sender] = true;
1803     }
1804 
1805     function mintToMultipleFM(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1806         require(!freeMintClaimed[msg.sender], "Address already claimed");
1807         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1808         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1809         require(_amount >= 1, "Must mint at least 1 token");
1810         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1811 
1812         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1813         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5000");
1814         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1815         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
1816 
1817         _safeMint(_to, _amount, false);
1818         freeMintClaimed[msg.sender] = true;
1819     }
1820 
1821     /**
1822      * @dev Enable allowlist minting fully by enabling both flags
1823      */
1824     function openAllowlistMint() public onlyOwner {
1825         enableAllowlistOnlyMode();
1826         mintingOpen = true;
1827     }
1828 
1829     /**
1830      * @dev Close allowlist minting fully by disabling both flags
1831      */
1832     function closeAllowlistMint() public onlyOwner {
1833         disableAllowlistOnlyMode();
1834         mintingOpen = false;
1835     }
1836 
1837 
1838   
1839     /**
1840     * @dev Check if wallet over MAX_WALLET_MINTS
1841     * @param _address address in question to check if minted count exceeds max
1842     */
1843     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1844         require(_amount >= 1, "Amount must be greater than or equal to 1");
1845         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1846     }
1847 
1848     /**
1849     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1850     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1851     */
1852     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1853         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1854         MAX_WALLET_MINTS = _newWalletMax;
1855     }
1856     
1857 
1858   
1859     /**
1860      * @dev Allows owner to set Max mints per tx
1861      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1862      */
1863      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1864          require(_newMaxMint >= 1, "Max mint must be at least 1");
1865          maxBatchSize = _newMaxMint;
1866      }
1867     
1868 
1869   
1870     function unveil(string memory _updatedTokenURI) public onlyOwner {
1871         require(isRevealed == false, "Tokens are already unveiled");
1872         _baseTokenURI = _updatedTokenURI;
1873         isRevealed = true;
1874     }
1875     
1876 
1877   function _baseURI() internal view virtual override returns(string memory) {
1878     return _baseTokenURI;
1879   }
1880 
1881   function baseTokenURI() public view returns(string memory) {
1882     return _baseTokenURI;
1883   }
1884 
1885   function setBaseURI(string calldata baseURI) external onlyOwner {
1886     _baseTokenURI = baseURI;
1887   }
1888 
1889   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1890     return ownershipOf(tokenId);
1891   }
1892 }
1893 
1894 
1895   
1896 // File: contracts/BatangethereumContract.sol
1897 //SPDX-License-Identifier: MIT
1898 
1899 pragma solidity ^0.8.0;
1900 
1901 contract BatangethereumContract is BethERC721A {
1902     constructor() BethERC721A("BATANG ETHEREUM", "BETH"){}
1903 }