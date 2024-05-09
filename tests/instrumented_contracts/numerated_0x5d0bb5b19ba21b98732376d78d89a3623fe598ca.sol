1 // SPDX-License-Identifier: MIT
2 
3 /*
4  
5 (O))  ((O)                  ))                    W  W   W  W       
6  ||    ||  wWw         /)  (Oo)-. wWw         /) (O)(O) (O)(O)      
7  || /\ ||  (O)_      (o)(O) | (_))(O)_      (o)(O) ||     ||        
8  ||//\\|| .' __)      //\\  |  .'.' __)      //\\  | \    | \       
9  / /  \ \(  _)       |(__)| )|\\(  _)       |(__)| |  `.  |  `.     
10 ( /    \ )`.__)      /,-. |(/  \)`.__)      /,-. |(.-.__)(.-.__)    
11  )      (           -'   '' )              -'   '' `-'    `-'       
12 
13      \/       .-.    wW  Ww\\\  ///   \/       (o)__(o)  .-.        \\\    ///wWw  wWw(o)__(o)  (o)__(o)      
14     (OO)    c(O_O)c  (O)(O)((O)(O))  (OO)      (__  __)c(O_O)c      ((O)  (O))(O)  (O)(__  __)/)(__  __)wWw   
15   ,'.--.)  ,'.---.`,  (..)  | \ || ,'.--.)       (  ) ,'.---.`,      | \  / | / )  ( \  (  )(o)(O)(  )  (O)_  
16  / /|_|_\ / /|_|_|\ \  ||   ||\\||/ /|_|_\        )( / /|_|_|\ \     ||\\//||/ /    \ \  )(  //\\  )(  .' __) 
17  | \_.--. | \_____/ | _||_  || \ || \_.--.       (  )| \_____/ |     || \/ ||| \____/ | (  )|(__)|(  )(  _)   
18  '.   \) \'. `---' .`(_/\_) ||  ||'.   \) \       )/ '. `---' .`     ||    ||'. `--' .`  )/ /,-. | )/  `.__)  
19    `-.(_.'  `-...-'        (_/  \_) `-.(_.'      (     `-...-'      (_/    \_) `-..-'   (  -'   ''(          
20 
21 */
22 
23 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
24 
25 
26 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Contract module that helps prevent reentrant calls to a function.
32  *
33  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
34  * available, which can be applied to functions to make sure there are no nested
35  * (reentrant) calls to them.
36  *
37  * Note that because there is a single `nonReentrant` guard, functions marked as
38  * `nonReentrant` may not call one another. This can be worked around by making
39  * those functions `private`, and then adding `external` `nonReentrant` entry
40  * points to them.
41  *
42  * TIP: If you would like to learn more about reentrancy and alternative ways
43  * to protect against it, check out our blog post
44  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
45  */
46 abstract contract ReentrancyGuard {
47     // Booleans are more expensive than uint256 or any type that takes up a full
48     // word because each write operation emits an extra SLOAD to first read the
49     // slot's contents, replace the bits taken up by the boolean, and then write
50     // back. This is the compiler's defense against contract upgrades and
51     // pointer aliasing, and it cannot be disabled.
52 
53     // The values being non-zero value makes deployment a bit more expensive,
54     // but in exchange the refund on every call to nonReentrant will be lower in
55     // amount. Since refunds are capped to a percentage of the total
56     // transaction's gas, it is best to keep them low in cases like this one, to
57     // increase the likelihood of the full refund coming into effect.
58     uint256 private constant _NOT_ENTERED = 1;
59     uint256 private constant _ENTERED = 2;
60 
61     uint256 private _status;
62 
63     constructor() {
64         _status = _NOT_ENTERED;
65     }
66 
67     /**
68      * @dev Prevents a contract from calling itself, directly or indirectly.
69      * Calling a `nonReentrant` function from another `nonReentrant`
70      * function is not supported. It is possible to prevent this from happening
71      * by making the `nonReentrant` function external, and making it call a
72      * `private` function that does the actual work.
73      */
74     modifier nonReentrant() {
75         // On the first call to nonReentrant, _notEntered will be true
76         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
77 
78         // Any calls to nonReentrant after this point will fail
79         _status = _ENTERED;
80 
81         _;
82 
83         // By storing the original value once again, a refund is triggered (see
84         // https://eips.ethereum.org/EIPS/eip-2200)
85         _status = _NOT_ENTERED;
86     }
87 }
88 
89 // File: @openzeppelin/contracts/utils/Strings.sol
90 
91 
92 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev String operations.
98  */
99 library Strings {
100     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
104      */
105     function toString(uint256 value) internal pure returns (string memory) {
106         // Inspired by OraclizeAPI's implementation - MIT licence
107         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
108 
109         if (value == 0) {
110             return "0";
111         }
112         uint256 temp = value;
113         uint256 digits;
114         while (temp != 0) {
115             digits++;
116             temp /= 10;
117         }
118         bytes memory buffer = new bytes(digits);
119         while (value != 0) {
120             digits -= 1;
121             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
122             value /= 10;
123         }
124         return string(buffer);
125     }
126 
127     /**
128      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
129      */
130     function toHexString(uint256 value) internal pure returns (string memory) {
131         if (value == 0) {
132             return "0x00";
133         }
134         uint256 temp = value;
135         uint256 length = 0;
136         while (temp != 0) {
137             length++;
138             temp >>= 8;
139         }
140         return toHexString(value, length);
141     }
142 
143     /**
144      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
145      */
146     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
147         bytes memory buffer = new bytes(2 * length + 2);
148         buffer[0] = "0";
149         buffer[1] = "x";
150         for (uint256 i = 2 * length + 1; i > 1; --i) {
151             buffer[i] = _HEX_SYMBOLS[value & 0xf];
152             value >>= 4;
153         }
154         require(value == 0, "Strings: hex length insufficient");
155         return string(buffer);
156     }
157 }
158 
159 // File: @openzeppelin/contracts/utils/Context.sol
160 
161 
162 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 /**
167  * @dev Provides information about the current execution context, including the
168  * sender of the transaction and its data. While these are generally available
169  * via msg.sender and msg.data, they should not be accessed in such a direct
170  * manner, since when dealing with meta-transactions the account sending and
171  * paying for execution may not be the actual sender (as far as an application
172  * is concerned).
173  *
174  * This contract is only required for intermediate, library-like contracts.
175  */
176 abstract contract Context {
177     function _msgSender() internal view virtual returns (address) {
178         return msg.sender;
179     }
180 
181     function _msgData() internal view virtual returns (bytes calldata) {
182         return msg.data;
183     }
184 }
185 
186 // File: @openzeppelin/contracts/access/Ownable.sol
187 
188 
189 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
190 
191 pragma solidity ^0.8.0;
192 
193 
194 /**
195  * @dev Contract module which provides a basic access control mechanism, where
196  * there is an account (an owner) that can be granted exclusive access to
197  * specific functions.
198  *
199  * By default, the owner account will be the one that deploys the contract. This
200  * can later be changed with {transferOwnership}.
201  *
202  * This module is used through inheritance. It will make available the modifier
203  * `onlyOwner`, which can be applied to your functions to restrict their use to
204  * the owner.
205  */
206 abstract contract Ownable is Context {
207     address private _owner;
208 
209     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
210 
211     /**
212      * @dev Initializes the contract setting the deployer as the initial owner.
213      */
214     constructor() {
215         _transferOwnership(_msgSender());
216     }
217 
218     /**
219      * @dev Returns the address of the current owner.
220      */
221     function owner() public view virtual returns (address) {
222         return _owner;
223     }
224 
225     /**
226      * @dev Throws if called by any account other than the owner.
227      */
228     modifier onlyOwner() {
229         require(owner() == _msgSender(), "Ownable: caller is not the owner");
230         _;
231     }
232 
233     /**
234      * @dev Leaves the contract without owner. It will not be possible to call
235      * `onlyOwner` functions anymore. Can only be called by the current owner.
236      *
237      * NOTE: Renouncing ownership will leave the contract without an owner,
238      * thereby removing any functionality that is only available to the owner.
239      */
240     function renounceOwnership() public virtual onlyOwner {
241         _transferOwnership(address(0));
242     }
243 
244     /**
245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
246      * Can only be called by the current owner.
247      */
248     function transferOwnership(address newOwner) public virtual onlyOwner {
249         require(newOwner != address(0), "Ownable: new owner is the zero address");
250         _transferOwnership(newOwner);
251     }
252 
253     /**
254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
255      * Internal function without access restriction.
256      */
257     function _transferOwnership(address newOwner) internal virtual {
258         address oldOwner = _owner;
259         _owner = newOwner;
260         emit OwnershipTransferred(oldOwner, newOwner);
261     }
262 }
263 
264 // File: @openzeppelin/contracts/utils/Address.sol
265 
266 
267 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
268 
269 pragma solidity ^0.8.1;
270 
271 /**
272  * @dev Collection of functions related to the address type
273  */
274 library Address {
275     /**
276      * @dev Returns true if `account` is a contract.
277      *
278      * [IMPORTANT]
279      * ====
280      * It is unsafe to assume that an address for which this function returns
281      * false is an externally-owned account (EOA) and not a contract.
282      *
283      * Among others, `isContract` will return false for the following
284      * types of addresses:
285      *
286      *  - an externally-owned account
287      *  - a contract in construction
288      *  - an address where a contract will be created
289      *  - an address where a contract lived, but was destroyed
290      * ====
291      *
292      * [IMPORTANT]
293      * ====
294      * You shouldn't rely on `isContract` to protect against flash loan attacks!
295      *
296      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
297      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
298      * constructor.
299      * ====
300      */
301     function isContract(address account) internal view returns (bool) {
302         // This method relies on extcodesize/address.code.length, which returns 0
303         // for contracts in construction, since the code is only stored at the end
304         // of the constructor execution.
305 
306         return account.code.length > 0;
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         (bool success, ) = recipient.call{value: amount}("");
329         require(success, "Address: unable to send value, recipient may have reverted");
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain `call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
351         return functionCall(target, data, "Address: low-level call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356      * `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(
380         address target,
381         bytes memory data,
382         uint256 value
383     ) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389      * with `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(
394         address target,
395         bytes memory data,
396         uint256 value,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(address(this).balance >= value, "Address: insufficient balance for call");
400         require(isContract(target), "Address: call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.call{value: value}(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
413         return functionStaticCall(target, data, "Address: low-level static call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a static call.
419      *
420      * _Available since v3.3._
421      */
422     function functionStaticCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal view returns (bytes memory) {
427         require(isContract(target), "Address: static call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.staticcall(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
440         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
445      * but performing a delegate call.
446      *
447      * _Available since v3.4._
448      */
449     function functionDelegateCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         require(isContract(target), "Address: delegate call to non-contract");
455 
456         (bool success, bytes memory returndata) = target.delegatecall(data);
457         return verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
462      * revert reason using the provided one.
463      *
464      * _Available since v4.3._
465      */
466     function verifyCallResult(
467         bool success,
468         bytes memory returndata,
469         string memory errorMessage
470     ) internal pure returns (bytes memory) {
471         if (success) {
472             return returndata;
473         } else {
474             // Look for revert reason and bubble it up if present
475             if (returndata.length > 0) {
476                 // The easiest way to bubble the revert reason is using memory via assembly
477 
478                 assembly {
479                     let returndata_size := mload(returndata)
480                     revert(add(32, returndata), returndata_size)
481                 }
482             } else {
483                 revert(errorMessage);
484             }
485         }
486     }
487 }
488 
489 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @title ERC721 token receiver interface
498  * @dev Interface for any contract that wants to support safeTransfers
499  * from ERC721 asset contracts.
500  */
501 interface IERC721Receiver {
502     /**
503      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
504      * by `operator` from `from`, this function is called.
505      *
506      * It must return its Solidity selector to confirm the token transfer.
507      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
508      *
509      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
510      */
511     function onERC721Received(
512         address operator,
513         address from,
514         uint256 tokenId,
515         bytes calldata data
516     ) external returns (bytes4);
517 }
518 
519 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
520 
521 
522 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 /**
527  * @dev Interface of the ERC165 standard, as defined in the
528  * https://eips.ethereum.org/EIPS/eip-165[EIP].
529  *
530  * Implementers can declare support of contract interfaces, which can then be
531  * queried by others ({ERC165Checker}).
532  *
533  * For an implementation, see {ERC165}.
534  */
535 interface IERC165 {
536     /**
537      * @dev Returns true if this contract implements the interface defined by
538      * `interfaceId`. See the corresponding
539      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
540      * to learn more about how these ids are created.
541      *
542      * This function call must use less than 30 000 gas.
543      */
544     function supportsInterface(bytes4 interfaceId) external view returns (bool);
545 }
546 
547 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
548 
549 
550 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @dev Implementation of the {IERC165} interface.
557  *
558  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
559  * for the additional interface id that will be supported. For example:
560  *
561  * ```solidity
562  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
564  * }
565  * ```
566  *
567  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
568  */
569 abstract contract ERC165 is IERC165 {
570     /**
571      * @dev See {IERC165-supportsInterface}.
572      */
573     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
574         return interfaceId == type(IERC165).interfaceId;
575     }
576 }
577 
578 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
579 
580 
581 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 
586 /**
587  * @dev Required interface of an ERC721 compliant contract.
588  */
589 interface IERC721 is IERC165 {
590     /**
591      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
592      */
593     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
594 
595     /**
596      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
597      */
598     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
599 
600     /**
601      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
602      */
603     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
604 
605     /**
606      * @dev Returns the number of tokens in ``owner``'s account.
607      */
608     function balanceOf(address owner) external view returns (uint256 balance);
609 
610     /**
611      * @dev Returns the owner of the `tokenId` token.
612      *
613      * Requirements:
614      *
615      * - `tokenId` must exist.
616      */
617     function ownerOf(uint256 tokenId) external view returns (address owner);
618 
619     /**
620      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
621      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
622      *
623      * Requirements:
624      *
625      * - `from` cannot be the zero address.
626      * - `to` cannot be the zero address.
627      * - `tokenId` token must exist and be owned by `from`.
628      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
629      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
630      *
631      * Emits a {Transfer} event.
632      */
633     function safeTransferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) external;
638 
639     /**
640      * @dev Transfers `tokenId` token from `from` to `to`.
641      *
642      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must be owned by `from`.
649      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
650      *
651      * Emits a {Transfer} event.
652      */
653     function transferFrom(
654         address from,
655         address to,
656         uint256 tokenId
657     ) external;
658 
659     /**
660      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
661      * The approval is cleared when the token is transferred.
662      *
663      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
664      *
665      * Requirements:
666      *
667      * - The caller must own the token or be an approved operator.
668      * - `tokenId` must exist.
669      *
670      * Emits an {Approval} event.
671      */
672     function approve(address to, uint256 tokenId) external;
673 
674     /**
675      * @dev Returns the account approved for `tokenId` token.
676      *
677      * Requirements:
678      *
679      * - `tokenId` must exist.
680      */
681     function getApproved(uint256 tokenId) external view returns (address operator);
682 
683     /**
684      * @dev Approve or remove `operator` as an operator for the caller.
685      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
686      *
687      * Requirements:
688      *
689      * - The `operator` cannot be the caller.
690      *
691      * Emits an {ApprovalForAll} event.
692      */
693     function setApprovalForAll(address operator, bool _approved) external;
694 
695     /**
696      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
697      *
698      * See {setApprovalForAll}
699      */
700     function isApprovedForAll(address owner, address operator) external view returns (bool);
701 
702     /**
703      * @dev Safely transfers `tokenId` token from `from` to `to`.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must exist and be owned by `from`.
710      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
711      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
712      *
713      * Emits a {Transfer} event.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId,
719         bytes calldata data
720     ) external;
721 }
722 
723 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 
731 /**
732  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
733  * @dev See https://eips.ethereum.org/EIPS/eip-721
734  */
735 interface IERC721Metadata is IERC721 {
736     /**
737      * @dev Returns the token collection name.
738      */
739     function name() external view returns (string memory);
740 
741     /**
742      * @dev Returns the token collection symbol.
743      */
744     function symbol() external view returns (string memory);
745 
746     /**
747      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
748      */
749     function tokenURI(uint256 tokenId) external view returns (string memory);
750 }
751 
752 // File: erc721a/contracts/ERC721A.sol
753 
754 
755 // Creator: Chiru Labs
756 
757 pragma solidity ^0.8.4;
758 
759 
760 
761 
762 
763 
764 
765 
766 error ApprovalCallerNotOwnerNorApproved();
767 error ApprovalQueryForNonexistentToken();
768 error ApproveToCaller();
769 error ApprovalToCurrentOwner();
770 error BalanceQueryForZeroAddress();
771 error MintToZeroAddress();
772 error MintZeroQuantity();
773 error OwnerQueryForNonexistentToken();
774 error TransferCallerNotOwnerNorApproved();
775 error TransferFromIncorrectOwner();
776 error TransferToNonERC721ReceiverImplementer();
777 error TransferToZeroAddress();
778 error URIQueryForNonexistentToken();
779 
780 /**
781  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
782  * the Metadata extension. Built to optimize for lower gas during batch mints.
783  *
784  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
785  *
786  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
787  *
788  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
789  */
790 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
791     using Address for address;
792     using Strings for uint256;
793 
794     // Compiler will pack this into a single 256bit word.
795     struct TokenOwnership {
796         // The address of the owner.
797         address addr;
798         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
799         uint64 startTimestamp;
800         // Whether the token has been burned.
801         bool burned;
802     }
803 
804     // Compiler will pack this into a single 256bit word.
805     struct AddressData {
806         // Realistically, 2**64-1 is more than enough.
807         uint64 balance;
808         // Keeps track of mint count with minimal overhead for tokenomics.
809         uint64 numberMinted;
810         // Keeps track of burn count with minimal overhead for tokenomics.
811         uint64 numberBurned;
812         // For miscellaneous variable(s) pertaining to the address
813         // (e.g. number of whitelist mint slots used).
814         // If there are multiple variables, please pack them into a uint64.
815         uint64 aux;
816     }
817 
818     // The tokenId of the next token to be minted.
819     uint256 internal _currentIndex;
820 
821     // The number of tokens burned.
822     uint256 internal _burnCounter;
823 
824     // Token name
825     string private _name;
826 
827     // Token symbol
828     string private _symbol;
829 
830     // Mapping from token ID to ownership details
831     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
832     mapping(uint256 => TokenOwnership) internal _ownerships;
833 
834     // Mapping owner address to address data
835     mapping(address => AddressData) private _addressData;
836 
837     // Mapping from token ID to approved address
838     mapping(uint256 => address) private _tokenApprovals;
839 
840     // Mapping from owner to operator approvals
841     mapping(address => mapping(address => bool)) private _operatorApprovals;
842 
843     constructor(string memory name_, string memory symbol_) {
844         _name = name_;
845         _symbol = symbol_;
846         _currentIndex = _startTokenId();
847     }
848 
849     /**
850      * To change the starting tokenId, please override this function.
851      */
852     function _startTokenId() internal view virtual returns (uint256) {
853         return 0;
854     }
855 
856     /**
857      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
858      */
859     function totalSupply() public view returns (uint256) {
860         // Counter underflow is impossible as _burnCounter cannot be incremented
861         // more than _currentIndex - _startTokenId() times
862         unchecked {
863             return _currentIndex - _burnCounter - _startTokenId();
864         }
865     }
866 
867     /**
868      * Returns the total amount of tokens minted in the contract.
869      */
870     function _totalMinted() internal view returns (uint256) {
871         // Counter underflow is impossible as _currentIndex does not decrement,
872         // and it is initialized to _startTokenId()
873         unchecked {
874             return _currentIndex - _startTokenId();
875         }
876     }
877 
878     /**
879      * @dev See {IERC165-supportsInterface}.
880      */
881     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
882         return
883             interfaceId == type(IERC721).interfaceId ||
884             interfaceId == type(IERC721Metadata).interfaceId ||
885             super.supportsInterface(interfaceId);
886     }
887 
888     /**
889      * @dev See {IERC721-balanceOf}.
890      */
891     function balanceOf(address owner) public view override returns (uint256) {
892         if (owner == address(0)) revert BalanceQueryForZeroAddress();
893         return uint256(_addressData[owner].balance);
894     }
895 
896     /**
897      * Returns the number of tokens minted by `owner`.
898      */
899     function _numberMinted(address owner) internal view returns (uint256) {
900         return uint256(_addressData[owner].numberMinted);
901     }
902 
903     /**
904      * Returns the number of tokens burned by or on behalf of `owner`.
905      */
906     function _numberBurned(address owner) internal view returns (uint256) {
907         return uint256(_addressData[owner].numberBurned);
908     }
909 
910     /**
911      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
912      */
913     function _getAux(address owner) internal view returns (uint64) {
914         return _addressData[owner].aux;
915     }
916 
917     /**
918      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
919      * If there are multiple variables, please pack them into a uint64.
920      */
921     function _setAux(address owner, uint64 aux) internal {
922         _addressData[owner].aux = aux;
923     }
924 
925     /**
926      * Gas spent here starts off proportional to the maximum mint batch size.
927      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
928      */
929     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
930         uint256 curr = tokenId;
931 
932         unchecked {
933             if (_startTokenId() <= curr && curr < _currentIndex) {
934                 TokenOwnership memory ownership = _ownerships[curr];
935                 if (!ownership.burned) {
936                     if (ownership.addr != address(0)) {
937                         return ownership;
938                     }
939                     // Invariant:
940                     // There will always be an ownership that has an address and is not burned
941                     // before an ownership that does not have an address and is not burned.
942                     // Hence, curr will not underflow.
943                     while (true) {
944                         curr--;
945                         ownership = _ownerships[curr];
946                         if (ownership.addr != address(0)) {
947                             return ownership;
948                         }
949                     }
950                 }
951             }
952         }
953         revert OwnerQueryForNonexistentToken();
954     }
955 
956     /**
957      * @dev See {IERC721-ownerOf}.
958      */
959     function ownerOf(uint256 tokenId) public view override returns (address) {
960         return _ownershipOf(tokenId).addr;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-name}.
965      */
966     function name() public view virtual override returns (string memory) {
967         return _name;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-symbol}.
972      */
973     function symbol() public view virtual override returns (string memory) {
974         return _symbol;
975     }
976 
977     /**
978      * @dev See {IERC721Metadata-tokenURI}.
979      */
980     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
981         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
982 
983         string memory baseURI = _baseURI();
984         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
985     }
986 
987     /**
988      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
989      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
990      * by default, can be overriden in child contracts.
991      */
992     function _baseURI() internal view virtual returns (string memory) {
993         return '';
994     }
995 
996     /**
997      * @dev See {IERC721-approve}.
998      */
999     function approve(address to, uint256 tokenId) public override {
1000         address owner = ERC721A.ownerOf(tokenId);
1001         if (to == owner) revert ApprovalToCurrentOwner();
1002 
1003         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1004             revert ApprovalCallerNotOwnerNorApproved();
1005         }
1006 
1007         _approve(to, tokenId, owner);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-getApproved}.
1012      */
1013     function getApproved(uint256 tokenId) public view override returns (address) {
1014         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1015 
1016         return _tokenApprovals[tokenId];
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-setApprovalForAll}.
1021      */
1022     function setApprovalForAll(address operator, bool approved) public virtual override {
1023         if (operator == _msgSender()) revert ApproveToCaller();
1024 
1025         _operatorApprovals[_msgSender()][operator] = approved;
1026         emit ApprovalForAll(_msgSender(), operator, approved);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-isApprovedForAll}.
1031      */
1032     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1033         return _operatorApprovals[owner][operator];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-transferFrom}.
1038      */
1039     function transferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) public virtual override {
1044         _transfer(from, to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-safeTransferFrom}.
1049      */
1050     function safeTransferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) public virtual override {
1055         safeTransferFrom(from, to, tokenId, '');
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-safeTransferFrom}.
1060      */
1061     function safeTransferFrom(
1062         address from,
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) public virtual override {
1067         _transfer(from, to, tokenId);
1068         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1069             revert TransferToNonERC721ReceiverImplementer();
1070         }
1071     }
1072 
1073     /**
1074      * @dev Returns whether `tokenId` exists.
1075      *
1076      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1077      *
1078      * Tokens start existing when they are minted (`_mint`),
1079      */
1080     function _exists(uint256 tokenId) internal view returns (bool) {
1081         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1082             !_ownerships[tokenId].burned;
1083     }
1084 
1085     function _safeMint(address to, uint256 quantity) internal {
1086         _safeMint(to, quantity, '');
1087     }
1088 
1089     /**
1090      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1095      * - `quantity` must be greater than 0.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _safeMint(
1100         address to,
1101         uint256 quantity,
1102         bytes memory _data
1103     ) internal {
1104         _mint(to, quantity, _data, true);
1105     }
1106 
1107     /**
1108      * @dev Mints `quantity` tokens and transfers them to `to`.
1109      *
1110      * Requirements:
1111      *
1112      * - `to` cannot be the zero address.
1113      * - `quantity` must be greater than 0.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _mint(
1118         address to,
1119         uint256 quantity,
1120         bytes memory _data,
1121         bool safe
1122     ) internal {
1123         uint256 startTokenId = _currentIndex;
1124         if (to == address(0)) revert MintToZeroAddress();
1125         if (quantity == 0) revert MintZeroQuantity();
1126 
1127         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1128 
1129         // Overflows are incredibly unrealistic.
1130         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1131         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1132         unchecked {
1133             _addressData[to].balance += uint64(quantity);
1134             _addressData[to].numberMinted += uint64(quantity);
1135 
1136             _ownerships[startTokenId].addr = to;
1137             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1138 
1139             uint256 updatedIndex = startTokenId;
1140             uint256 end = updatedIndex + quantity;
1141 
1142             if (safe && to.isContract()) {
1143                 do {
1144                     emit Transfer(address(0), to, updatedIndex);
1145                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1146                         revert TransferToNonERC721ReceiverImplementer();
1147                     }
1148                 } while (updatedIndex != end);
1149                 // Reentrancy protection
1150                 if (_currentIndex != startTokenId) revert();
1151             } else {
1152                 do {
1153                     emit Transfer(address(0), to, updatedIndex++);
1154                 } while (updatedIndex != end);
1155             }
1156             _currentIndex = updatedIndex;
1157         }
1158         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1159     }
1160 
1161     /**
1162      * @dev Transfers `tokenId` from `from` to `to`.
1163      *
1164      * Requirements:
1165      *
1166      * - `to` cannot be the zero address.
1167      * - `tokenId` token must be owned by `from`.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function _transfer(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) private {
1176         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1177 
1178         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1179 
1180         bool isApprovedOrOwner = (_msgSender() == from ||
1181             isApprovedForAll(from, _msgSender()) ||
1182             getApproved(tokenId) == _msgSender());
1183 
1184         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1185         if (to == address(0)) revert TransferToZeroAddress();
1186 
1187         _beforeTokenTransfers(from, to, tokenId, 1);
1188 
1189         // Clear approvals from the previous owner
1190         _approve(address(0), tokenId, from);
1191 
1192         // Underflow of the sender's balance is impossible because we check for
1193         // ownership above and the recipient's balance can't realistically overflow.
1194         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1195         unchecked {
1196             _addressData[from].balance -= 1;
1197             _addressData[to].balance += 1;
1198 
1199             TokenOwnership storage currSlot = _ownerships[tokenId];
1200             currSlot.addr = to;
1201             currSlot.startTimestamp = uint64(block.timestamp);
1202 
1203             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1204             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1205             uint256 nextTokenId = tokenId + 1;
1206             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1207             if (nextSlot.addr == address(0)) {
1208                 // This will suffice for checking _exists(nextTokenId),
1209                 // as a burned slot cannot contain the zero address.
1210                 if (nextTokenId != _currentIndex) {
1211                     nextSlot.addr = from;
1212                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1213                 }
1214             }
1215         }
1216 
1217         emit Transfer(from, to, tokenId);
1218         _afterTokenTransfers(from, to, tokenId, 1);
1219     }
1220 
1221     /**
1222      * @dev This is equivalent to _burn(tokenId, false)
1223      */
1224     function _burn(uint256 tokenId) internal virtual {
1225         _burn(tokenId, false);
1226     }
1227 
1228     /**
1229      * @dev Destroys `tokenId`.
1230      * The approval is cleared when the token is burned.
1231      *
1232      * Requirements:
1233      *
1234      * - `tokenId` must exist.
1235      *
1236      * Emits a {Transfer} event.
1237      */
1238     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1239         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1240 
1241         address from = prevOwnership.addr;
1242 
1243         if (approvalCheck) {
1244             bool isApprovedOrOwner = (_msgSender() == from ||
1245                 isApprovedForAll(from, _msgSender()) ||
1246                 getApproved(tokenId) == _msgSender());
1247 
1248             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1249         }
1250 
1251         _beforeTokenTransfers(from, address(0), tokenId, 1);
1252 
1253         // Clear approvals from the previous owner
1254         _approve(address(0), tokenId, from);
1255 
1256         // Underflow of the sender's balance is impossible because we check for
1257         // ownership above and the recipient's balance can't realistically overflow.
1258         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1259         unchecked {
1260             AddressData storage addressData = _addressData[from];
1261             addressData.balance -= 1;
1262             addressData.numberBurned += 1;
1263 
1264             // Keep track of who burned the token, and the timestamp of burning.
1265             TokenOwnership storage currSlot = _ownerships[tokenId];
1266             currSlot.addr = from;
1267             currSlot.startTimestamp = uint64(block.timestamp);
1268             currSlot.burned = true;
1269 
1270             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1271             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1272             uint256 nextTokenId = tokenId + 1;
1273             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1274             if (nextSlot.addr == address(0)) {
1275                 // This will suffice for checking _exists(nextTokenId),
1276                 // as a burned slot cannot contain the zero address.
1277                 if (nextTokenId != _currentIndex) {
1278                     nextSlot.addr = from;
1279                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1280                 }
1281             }
1282         }
1283 
1284         emit Transfer(from, address(0), tokenId);
1285         _afterTokenTransfers(from, address(0), tokenId, 1);
1286 
1287         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1288         unchecked {
1289             _burnCounter++;
1290         }
1291     }
1292 
1293     /**
1294      * @dev Approve `to` to operate on `tokenId`
1295      *
1296      * Emits a {Approval} event.
1297      */
1298     function _approve(
1299         address to,
1300         uint256 tokenId,
1301         address owner
1302     ) private {
1303         _tokenApprovals[tokenId] = to;
1304         emit Approval(owner, to, tokenId);
1305     }
1306 
1307     /**
1308      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1309      *
1310      * @param from address representing the previous owner of the given token ID
1311      * @param to target address that will receive the tokens
1312      * @param tokenId uint256 ID of the token to be transferred
1313      * @param _data bytes optional data to send along with the call
1314      * @return bool whether the call correctly returned the expected magic value
1315      */
1316     function _checkContractOnERC721Received(
1317         address from,
1318         address to,
1319         uint256 tokenId,
1320         bytes memory _data
1321     ) private returns (bool) {
1322         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1323             return retval == IERC721Receiver(to).onERC721Received.selector;
1324         } catch (bytes memory reason) {
1325             if (reason.length == 0) {
1326                 revert TransferToNonERC721ReceiverImplementer();
1327             } else {
1328                 assembly {
1329                     revert(add(32, reason), mload(reason))
1330                 }
1331             }
1332         }
1333     }
1334 
1335     /**
1336      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1337      * And also called before burning one token.
1338      *
1339      * startTokenId - the first token id to be transferred
1340      * quantity - the amount to be transferred
1341      *
1342      * Calling conditions:
1343      *
1344      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1345      * transferred to `to`.
1346      * - When `from` is zero, `tokenId` will be minted for `to`.
1347      * - When `to` is zero, `tokenId` will be burned by `from`.
1348      * - `from` and `to` are never both zero.
1349      */
1350     function _beforeTokenTransfers(
1351         address from,
1352         address to,
1353         uint256 startTokenId,
1354         uint256 quantity
1355     ) internal virtual {}
1356 
1357     /**
1358      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1359      * minting.
1360      * And also called after one token has been burned.
1361      *
1362      * startTokenId - the first token id to be transferred
1363      * quantity - the amount to be transferred
1364      *
1365      * Calling conditions:
1366      *
1367      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1368      * transferred to `to`.
1369      * - When `from` is zero, `tokenId` has been minted for `to`.
1370      * - When `to` is zero, `tokenId` has been burned by `from`.
1371      * - `from` and `to` are never both zero.
1372      */
1373     function _afterTokenTransfers(
1374         address from,
1375         address to,
1376         uint256 startTokenId,
1377         uint256 quantity
1378     ) internal virtual {}
1379 }
1380 
1381 
1382 
1383 pragma solidity >=0.8.9 <0.9.0;
1384 
1385 
1386 contract WAGMUTATE is ERC721A, Ownable, ReentrancyGuard {
1387 
1388   using Strings for uint256;
1389 
1390   string public uriPrefix = '';
1391   string public uriSuffix = '.json';
1392   
1393   uint256 public maxSupply;
1394   uint256 public maxMintAmountPerWallet;
1395   uint256 public teamClaimAmount = 100;
1396 
1397   bool public paused = true;
1398   bool public teamClaimed = false;
1399 
1400   mapping(address => uint256) private _walletMints;
1401 
1402   constructor(
1403     string memory _tokenName,
1404     string memory _tokenSymbol,
1405     uint256 _maxSupply,
1406     uint256 _maxMintAmountPerWallet,
1407     string memory _uriPrefix
1408   ) ERC721A(_tokenName, _tokenSymbol) {
1409     maxSupply = _maxSupply;
1410     setMaxMintAmountPerWallet(_maxMintAmountPerWallet);
1411     setUriPrefix(_uriPrefix);
1412     _safeMint(_msgSender(), 1);
1413   }
1414 
1415   modifier mintCompliance(uint256 _mintAmount) {
1416     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerWallet, 'Invalid mint amount!');
1417     require(_walletMints[_msgSender()] + _mintAmount < maxMintAmountPerWallet + 1, 'You have already minted');
1418     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1419     _;
1420   }
1421 
1422   function teamClaim() public payable onlyOwner {
1423     require(!teamClaimed, "Team already claimed");
1424     
1425     _safeMint(_msgSender(), teamClaimAmount);
1426     teamClaimed = true;
1427   }
1428 
1429 
1430   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount){
1431     require(!paused, 'The contract is paused!');
1432 
1433     _walletMints[_msgSender()] += _mintAmount;
1434     _safeMint(_msgSender(), _mintAmount);
1435   }
1436 
1437   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1438     uint256 ownerTokenCount = balanceOf(_owner);
1439     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1440     uint256 currentTokenId = _startTokenId();
1441     uint256 ownedTokenIndex = 0;
1442     address latestOwnerAddress;
1443 
1444     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1445       TokenOwnership memory ownership = _ownerships[currentTokenId];
1446 
1447       if (!ownership.burned && ownership.addr != address(0)) {
1448         latestOwnerAddress = ownership.addr;
1449       }
1450 
1451       if (latestOwnerAddress == _owner) {
1452         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1453 
1454         ownedTokenIndex++;
1455       }
1456 
1457       currentTokenId++;
1458     }
1459 
1460     return ownedTokenIds;
1461   }
1462 
1463   function _startTokenId() internal view virtual override returns (uint256) {
1464     return 1;
1465   }
1466 
1467   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1468     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1469 
1470     string memory currentBaseURI = _baseURI();
1471     return bytes(currentBaseURI).length > 0
1472         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1473         : '';
1474   }
1475 
1476   function setMaxMintAmountPerWallet(uint256 _maxMintAmountPerWallet) public onlyOwner {
1477     maxMintAmountPerWallet = _maxMintAmountPerWallet;
1478   }
1479 
1480   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1481     uriPrefix = _uriPrefix;
1482   }
1483 
1484   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1485     uriSuffix = _uriSuffix;
1486   }
1487 
1488   function setPaused(bool _state) public onlyOwner {
1489     paused = _state;
1490   }
1491 
1492   function withdraw() public onlyOwner nonReentrant {
1493 
1494     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1495     require(os);
1496   }
1497 
1498   function _baseURI() internal view virtual override returns (string memory) {
1499     return uriPrefix;
1500   }
1501 }