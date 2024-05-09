1 /**
2 
3   _____           _               ____  _         _     
4  |  __ \         | |             |  _ \(_)       | |    
5  | |__) |   _  __| | __ _ _   _  | |_) |_ _ __ __| |___ 
6  |  ___/ | | |/ _` |/ _` | | | | |  _ <| | '__/ _` / __|
7  | |   | |_| | (_| | (_| | |_| | | |_) | | | | (_| \__ \
8  |_|    \__,_|\__,_|\__, |\__, | |____/|_|_|  \__,_|___/
9                      __/ | __/ |                        
10                     |___/ |___/                         
11 
12 */
13 
14 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
15 
16 // SPDX-License-Identifier: MIT
17 
18 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @dev Contract module that helps prevent reentrant calls to a function.
24  *
25  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
26  * available, which can be applied to functions to make sure there are no nested
27  * (reentrant) calls to them.
28  *
29  * Note that because there is a single `nonReentrant` guard, functions marked as
30  * `nonReentrant` may not call one another. This can be worked around by making
31  * those functions `private`, and then adding `external` `nonReentrant` entry
32  * points to them.
33  *
34  * TIP: If you would like to learn more about reentrancy and alternative ways
35  * to protect against it, check out our blog post
36  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
37  */
38 abstract contract ReentrancyGuard {
39     // Booleans are more expensive than uint256 or any type that takes up a full
40     // word because each write operation emits an extra SLOAD to first read the
41     // slot's contents, replace the bits taken up by the boolean, and then write
42     // back. This is the compiler's defense against contract upgrades and
43     // pointer aliasing, and it cannot be disabled.
44 
45     // The values being non-zero value makes deployment a bit more expensive,
46     // but in exchange the refund on every call to nonReentrant will be lower in
47     // amount. Since refunds are capped to a percentage of the total
48     // transaction's gas, it is best to keep them low in cases like this one, to
49     // increase the likelihood of the full refund coming into effect.
50     uint256 private constant _NOT_ENTERED = 1;
51     uint256 private constant _ENTERED = 2;
52 
53     uint256 private _status;
54 
55     constructor() {
56         _status = _NOT_ENTERED;
57     }
58 
59     /**
60      * @dev Prevents a contract from calling itself, directly or indirectly.
61      * Calling a `nonReentrant` function from another `nonReentrant`
62      * function is not supported. It is possible to prevent this from happening
63      * by making the `nonReentrant` function external, and making it call a
64      * `private` function that does the actual work.
65      */
66     modifier nonReentrant() {
67         // On the first call to nonReentrant, _notEntered will be true
68         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
69 
70         // Any calls to nonReentrant after this point will fail
71         _status = _ENTERED;
72 
73         _;
74 
75         // By storing the original value once again, a refund is triggered (see
76         // https://eips.ethereum.org/EIPS/eip-2200)
77         _status = _NOT_ENTERED;
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/Strings.sol
82 
83 
84 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev String operations.
90  */
91 library Strings {
92     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
96      */
97     function toString(uint256 value) internal pure returns (string memory) {
98         // Inspired by OraclizeAPI's implementation - MIT licence
99         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
100 
101         if (value == 0) {
102             return "0";
103         }
104         uint256 temp = value;
105         uint256 digits;
106         while (temp != 0) {
107             digits++;
108             temp /= 10;
109         }
110         bytes memory buffer = new bytes(digits);
111         while (value != 0) {
112             digits -= 1;
113             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
114             value /= 10;
115         }
116         return string(buffer);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
121      */
122     function toHexString(uint256 value) internal pure returns (string memory) {
123         if (value == 0) {
124             return "0x00";
125         }
126         uint256 temp = value;
127         uint256 length = 0;
128         while (temp != 0) {
129             length++;
130             temp >>= 8;
131         }
132         return toHexString(value, length);
133     }
134 
135     /**
136      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
137      */
138     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
139         bytes memory buffer = new bytes(2 * length + 2);
140         buffer[0] = "0";
141         buffer[1] = "x";
142         for (uint256 i = 2 * length + 1; i > 1; --i) {
143             buffer[i] = _HEX_SYMBOLS[value & 0xf];
144             value >>= 4;
145         }
146         require(value == 0, "Strings: hex length insufficient");
147         return string(buffer);
148     }
149 }
150 
151 // File: @openzeppelin/contracts/utils/Context.sol
152 
153 
154 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
155 
156 pragma solidity ^0.8.0;
157 
158 /**
159  * @dev Provides information about the current execution context, including the
160  * sender of the transaction and its data. While these are generally available
161  * via msg.sender and msg.data, they should not be accessed in such a direct
162  * manner, since when dealing with meta-transactions the account sending and
163  * paying for execution may not be the actual sender (as far as an application
164  * is concerned).
165  *
166  * This contract is only required for intermediate, library-like contracts.
167  */
168 abstract contract Context {
169     function _msgSender() internal view virtual returns (address) {
170         return msg.sender;
171     }
172 
173     function _msgData() internal view virtual returns (bytes calldata) {
174         return msg.data;
175     }
176 }
177 
178 // File: @openzeppelin/contracts/access/Ownable.sol
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 
186 /**
187  * @dev Contract module which provides a basic access control mechanism, where
188  * there is an account (an owner) that can be granted exclusive access to
189  * specific functions.
190  *
191  * By default, the owner account will be the one that deploys the contract. This
192  * can later be changed with {transferOwnership}.
193  *
194  * This module is used through inheritance. It will make available the modifier
195  * `onlyOwner`, which can be applied to your functions to restrict their use to
196  * the owner.
197  */
198 abstract contract Ownable is Context {
199     address private _owner;
200 
201     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
202 
203     /**
204      * @dev Initializes the contract setting the deployer as the initial owner.
205      */
206     constructor() {
207         _transferOwnership(_msgSender());
208     }
209 
210     /**
211      * @dev Returns the address of the current owner.
212      */
213     function owner() public view virtual returns (address) {
214         return _owner;
215     }
216 
217     /**
218      * @dev Throws if called by any account other than the owner.
219      */
220     modifier onlyOwner() {
221         require(owner() == _msgSender(), "Ownable: caller is not the owner");
222         _;
223     }
224 
225     /**
226      * @dev Leaves the contract without owner. It will not be possible to call
227      * `onlyOwner` functions anymore. Can only be called by the current owner.
228      *
229      * NOTE: Renouncing ownership will leave the contract without an owner,
230      * thereby removing any functionality that is only available to the owner.
231      */
232     function renounceOwnership() public virtual onlyOwner {
233         _transferOwnership(address(0));
234     }
235 
236     /**
237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
238      * Can only be called by the current owner.
239      */
240     function transferOwnership(address newOwner) public virtual onlyOwner {
241         require(newOwner != address(0), "Ownable: new owner is the zero address");
242         _transferOwnership(newOwner);
243     }
244 
245     /**
246      * @dev Transfers ownership of the contract to a new account (`newOwner`).
247      * Internal function without access restriction.
248      */
249     function _transferOwnership(address newOwner) internal virtual {
250         address oldOwner = _owner;
251         _owner = newOwner;
252         emit OwnershipTransferred(oldOwner, newOwner);
253     }
254 }
255 
256 // File: @openzeppelin/contracts/utils/Address.sol
257 
258 
259 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
260 
261 pragma solidity ^0.8.1;
262 
263 /**
264  * @dev Collection of functions related to the address type
265  */
266 library Address {
267     /**
268      * @dev Returns true if `account` is a contract.
269      *
270      * [IMPORTANT]
271      * ====
272      * It is unsafe to assume that an address for which this function returns
273      * false is an externally-owned account (EOA) and not a contract.
274      *
275      * Among others, `isContract` will return false for the following
276      * types of addresses:
277      *
278      *  - an externally-owned account
279      *  - a contract in construction
280      *  - an address where a contract will be created
281      *  - an address where a contract lived, but was destroyed
282      * ====
283      *
284      * [IMPORTANT]
285      * ====
286      * You shouldn't rely on `isContract` to protect against flash loan attacks!
287      *
288      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
289      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
290      * constructor.
291      * ====
292      */
293     function isContract(address account) internal view returns (bool) {
294         // This method relies on extcodesize/address.code.length, which returns 0
295         // for contracts in construction, since the code is only stored at the end
296         // of the constructor execution.
297 
298         return account.code.length > 0;
299     }
300 
301     /**
302      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303      * `recipient`, forwarding all available gas and reverting on errors.
304      *
305      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306      * of certain opcodes, possibly making contracts go over the 2300 gas limit
307      * imposed by `transfer`, making them unable to receive funds via
308      * `transfer`. {sendValue} removes this limitation.
309      *
310      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311      *
312      * IMPORTANT: because control is transferred to `recipient`, care must be
313      * taken to not create reentrancy vulnerabilities. Consider using
314      * {ReentrancyGuard} or the
315      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316      */
317     function sendValue(address payable recipient, uint256 amount) internal {
318         require(address(this).balance >= amount, "Address: insufficient balance");
319 
320         (bool success, ) = recipient.call{value: amount}("");
321         require(success, "Address: unable to send value, recipient may have reverted");
322     }
323 
324     /**
325      * @dev Performs a Solidity function call using a low level `call`. A
326      * plain `call` is an unsafe replacement for a function call: use this
327      * function instead.
328      *
329      * If `target` reverts with a revert reason, it is bubbled up by this
330      * function (like regular Solidity function calls).
331      *
332      * Returns the raw returned data. To convert to the expected return value,
333      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
334      *
335      * Requirements:
336      *
337      * - `target` must be a contract.
338      * - calling `target` with `data` must not revert.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
343         return functionCall(target, data, "Address: low-level call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
348      * `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, 0, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but also transferring `value` wei to `target`.
363      *
364      * Requirements:
365      *
366      * - the calling contract must have an ETH balance of at least `value`.
367      * - the called Solidity function must be `payable`.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value
375     ) internal returns (bytes memory) {
376         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
381      * with `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(
386         address target,
387         bytes memory data,
388         uint256 value,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(address(this).balance >= value, "Address: insufficient balance for call");
392         require(isContract(target), "Address: call to non-contract");
393 
394         (bool success, bytes memory returndata) = target.call{value: value}(data);
395         return verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
405         return functionStaticCall(target, data, "Address: low-level static call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
410      * but performing a static call.
411      *
412      * _Available since v3.3._
413      */
414     function functionStaticCall(
415         address target,
416         bytes memory data,
417         string memory errorMessage
418     ) internal view returns (bytes memory) {
419         require(isContract(target), "Address: static call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.staticcall(data);
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
432         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437      * but performing a delegate call.
438      *
439      * _Available since v3.4._
440      */
441     function functionDelegateCall(
442         address target,
443         bytes memory data,
444         string memory errorMessage
445     ) internal returns (bytes memory) {
446         require(isContract(target), "Address: delegate call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.delegatecall(data);
449         return verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
454      * revert reason using the provided one.
455      *
456      * _Available since v4.3._
457      */
458     function verifyCallResult(
459         bool success,
460         bytes memory returndata,
461         string memory errorMessage
462     ) internal pure returns (bytes memory) {
463         if (success) {
464             return returndata;
465         } else {
466             // Look for revert reason and bubble it up if present
467             if (returndata.length > 0) {
468                 // The easiest way to bubble the revert reason is using memory via assembly
469 
470                 assembly {
471                     let returndata_size := mload(returndata)
472                     revert(add(32, returndata), returndata_size)
473                 }
474             } else {
475                 revert(errorMessage);
476             }
477         }
478     }
479 }
480 
481 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
482 
483 
484 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 /**
489  * @title ERC721 token receiver interface
490  * @dev Interface for any contract that wants to support safeTransfers
491  * from ERC721 asset contracts.
492  */
493 interface IERC721Receiver {
494     /**
495      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
496      * by `operator` from `from`, this function is called.
497      *
498      * It must return its Solidity selector to confirm the token transfer.
499      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
500      *
501      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
502      */
503     function onERC721Received(
504         address operator,
505         address from,
506         uint256 tokenId,
507         bytes calldata data
508     ) external returns (bytes4);
509 }
510 
511 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
512 
513 
514 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 /**
519  * @dev Interface of the ERC165 standard, as defined in the
520  * https://eips.ethereum.org/EIPS/eip-165[EIP].
521  *
522  * Implementers can declare support of contract interfaces, which can then be
523  * queried by others ({ERC165Checker}).
524  *
525  * For an implementation, see {ERC165}.
526  */
527 interface IERC165 {
528     /**
529      * @dev Returns true if this contract implements the interface defined by
530      * `interfaceId`. See the corresponding
531      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
532      * to learn more about how these ids are created.
533      *
534      * This function call must use less than 30 000 gas.
535      */
536     function supportsInterface(bytes4 interfaceId) external view returns (bool);
537 }
538 
539 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
540 
541 
542 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 
547 /**
548  * @dev Implementation of the {IERC165} interface.
549  *
550  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
551  * for the additional interface id that will be supported. For example:
552  *
553  * ```solidity
554  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
555  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
556  * }
557  * ```
558  *
559  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
560  */
561 abstract contract ERC165 is IERC165 {
562     /**
563      * @dev See {IERC165-supportsInterface}.
564      */
565     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
566         return interfaceId == type(IERC165).interfaceId;
567     }
568 }
569 
570 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
571 
572 
573 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 
578 /**
579  * @dev Required interface of an ERC721 compliant contract.
580  */
581 interface IERC721 is IERC165 {
582     /**
583      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
584      */
585     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
586 
587     /**
588      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
589      */
590     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
591 
592     /**
593      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
594      */
595     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
596 
597     /**
598      * @dev Returns the number of tokens in ``owner``'s account.
599      */
600     function balanceOf(address owner) external view returns (uint256 balance);
601 
602     /**
603      * @dev Returns the owner of the `tokenId` token.
604      *
605      * Requirements:
606      *
607      * - `tokenId` must exist.
608      */
609     function ownerOf(uint256 tokenId) external view returns (address owner);
610 
611     /**
612      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
613      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
614      *
615      * Requirements:
616      *
617      * - `from` cannot be the zero address.
618      * - `to` cannot be the zero address.
619      * - `tokenId` token must exist and be owned by `from`.
620      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
621      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
622      *
623      * Emits a {Transfer} event.
624      */
625     function safeTransferFrom(
626         address from,
627         address to,
628         uint256 tokenId
629     ) external;
630 
631     /**
632      * @dev Transfers `tokenId` token from `from` to `to`.
633      *
634      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
635      *
636      * Requirements:
637      *
638      * - `from` cannot be the zero address.
639      * - `to` cannot be the zero address.
640      * - `tokenId` token must be owned by `from`.
641      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
642      *
643      * Emits a {Transfer} event.
644      */
645     function transferFrom(
646         address from,
647         address to,
648         uint256 tokenId
649     ) external;
650 
651     /**
652      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
653      * The approval is cleared when the token is transferred.
654      *
655      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
656      *
657      * Requirements:
658      *
659      * - The caller must own the token or be an approved operator.
660      * - `tokenId` must exist.
661      *
662      * Emits an {Approval} event.
663      */
664     function approve(address to, uint256 tokenId) external;
665 
666     /**
667      * @dev Returns the account approved for `tokenId` token.
668      *
669      * Requirements:
670      *
671      * - `tokenId` must exist.
672      */
673     function getApproved(uint256 tokenId) external view returns (address operator);
674 
675     /**
676      * @dev Approve or remove `operator` as an operator for the caller.
677      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
678      *
679      * Requirements:
680      *
681      * - The `operator` cannot be the caller.
682      *
683      * Emits an {ApprovalForAll} event.
684      */
685     function setApprovalForAll(address operator, bool _approved) external;
686 
687     /**
688      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
689      *
690      * See {setApprovalForAll}
691      */
692     function isApprovedForAll(address owner, address operator) external view returns (bool);
693 
694     /**
695      * @dev Safely transfers `tokenId` token from `from` to `to`.
696      *
697      * Requirements:
698      *
699      * - `from` cannot be the zero address.
700      * - `to` cannot be the zero address.
701      * - `tokenId` token must exist and be owned by `from`.
702      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
703      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
704      *
705      * Emits a {Transfer} event.
706      */
707     function safeTransferFrom(
708         address from,
709         address to,
710         uint256 tokenId,
711         bytes calldata data
712     ) external;
713 }
714 
715 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
716 
717 
718 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 
723 /**
724  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
725  * @dev See https://eips.ethereum.org/EIPS/eip-721
726  */
727 interface IERC721Metadata is IERC721 {
728     /**
729      * @dev Returns the token collection name.
730      */
731     function name() external view returns (string memory);
732 
733     /**
734      * @dev Returns the token collection symbol.
735      */
736     function symbol() external view returns (string memory);
737 
738     /**
739      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
740      */
741     function tokenURI(uint256 tokenId) external view returns (string memory);
742 }
743 
744 // File: contracts/ERC721A.sol
745 
746 
747 // Creator: Chiru Labs
748 
749 pragma solidity ^0.8.4;
750 
751 
752 
753 
754 
755 
756 
757 
758 error ApprovalCallerNotOwnerNorApproved();
759 error ApprovalQueryForNonexistentToken();
760 error ApproveToCaller();
761 error ApprovalToCurrentOwner();
762 error BalanceQueryForZeroAddress();
763 error MintToZeroAddress();
764 error MintZeroQuantity();
765 error OwnerQueryForNonexistentToken();
766 error TransferCallerNotOwnerNorApproved();
767 error TransferFromIncorrectOwner();
768 error TransferToNonERC721ReceiverImplementer();
769 error TransferToZeroAddress();
770 error URIQueryForNonexistentToken();
771 
772 /**
773  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
774  * the Metadata extension. Built to optimize for lower gas during batch mints.
775  *
776  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
777  *
778  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
779  *
780  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
781  */
782 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
783     using Address for address;
784     using Strings for uint256;
785 
786     // Compiler will pack this into a single 256bit word.
787     struct TokenOwnership {
788         // The address of the owner.
789         address addr;
790         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
791         uint64 startTimestamp;
792         // Whether the token has been burned.
793         bool burned;
794     }
795 
796     // Compiler will pack this into a single 256bit word.
797     struct AddressData {
798         // Realistically, 2**64-1 is more than enough.
799         uint64 balance;
800         // Keeps track of mint count with minimal overhead for tokenomics.
801         uint64 numberMinted;
802         // Keeps track of burn count with minimal overhead for tokenomics.
803         uint64 numberBurned;
804         // For miscellaneous variable(s) pertaining to the address
805         // (e.g. number of whitelist mint slots used).
806         // If there are multiple variables, please pack them into a uint64.
807         uint64 aux;
808     }
809 
810     // The tokenId of the next token to be minted.
811     uint256 internal _currentIndex;
812 
813     // The number of tokens burned.
814     uint256 internal _burnCounter;
815 
816     // Token name
817     string private _name;
818 
819     // Token symbol
820     string private _symbol;
821 
822     // Mapping from token ID to ownership details
823     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
824     mapping(uint256 => TokenOwnership) internal _ownerships;
825 
826     // Mapping owner address to address data
827     mapping(address => AddressData) private _addressData;
828 
829     // Mapping from token ID to approved address
830     mapping(uint256 => address) private _tokenApprovals;
831 
832     // Mapping from owner to operator approvals
833     mapping(address => mapping(address => bool)) private _operatorApprovals;
834 
835     constructor(string memory name_, string memory symbol_) {
836         _name = name_;
837         _symbol = symbol_;
838         _currentIndex = _startTokenId();
839     }
840 
841     /**
842      * To change the starting tokenId, please override this function.
843      */
844     function _startTokenId() internal view virtual returns (uint256) {
845         return 1;
846     }
847 
848     /**
849      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
850      */
851     function totalSupply() public view returns (uint256) {
852         // Counter underflow is impossible as _burnCounter cannot be incremented
853         // more than _currentIndex - _startTokenId() times
854         unchecked {
855             return _currentIndex - _burnCounter - _startTokenId();
856         }
857     }
858 
859     /**
860      * Returns the total amount of tokens minted in the contract.
861      */
862     function _totalMinted() internal view returns (uint256) {
863         // Counter underflow is impossible as _currentIndex does not decrement,
864         // and it is initialized to _startTokenId()
865         unchecked {
866             return _currentIndex - _startTokenId();
867         }
868     }
869 
870     /**
871      * @dev See {IERC165-supportsInterface}.
872      */
873     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
874         return
875             interfaceId == type(IERC721).interfaceId ||
876             interfaceId == type(IERC721Metadata).interfaceId ||
877             super.supportsInterface(interfaceId);
878     }
879 
880     /**
881      * @dev See {IERC721-balanceOf}.
882      */
883     function balanceOf(address owner) public view override returns (uint256) {
884         if (owner == address(0)) revert BalanceQueryForZeroAddress();
885         return uint256(_addressData[owner].balance);
886     }
887 
888     /**
889      * Returns the number of tokens minted by `owner`.
890      */
891     function _numberMinted(address owner) internal view returns (uint256) {
892         return uint256(_addressData[owner].numberMinted);
893     }
894 
895     /**
896      * Returns the number of tokens burned by or on behalf of `owner`.
897      */
898     function _numberBurned(address owner) internal view returns (uint256) {
899         return uint256(_addressData[owner].numberBurned);
900     }
901 
902     /**
903      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
904      */
905     function _getAux(address owner) internal view returns (uint64) {
906         return _addressData[owner].aux;
907     }
908 
909     /**
910      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
911      * If there are multiple variables, please pack them into a uint64.
912      */
913     function _setAux(address owner, uint64 aux) internal {
914         _addressData[owner].aux = aux;
915     }
916 
917     /**
918      * Gas spent here starts off proportional to the maximum mint batch size.
919      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
920      */
921     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
922         uint256 curr = tokenId;
923 
924         unchecked {
925             if (_startTokenId() <= curr && curr < _currentIndex) {
926                 TokenOwnership memory ownership = _ownerships[curr];
927                 if (!ownership.burned) {
928                     if (ownership.addr != address(0)) {
929                         return ownership;
930                     }
931                     // Invariant:
932                     // There will always be an ownership that has an address and is not burned
933                     // before an ownership that does not have an address and is not burned.
934                     // Hence, curr will not underflow.
935                     while (true) {
936                         curr--;
937                         ownership = _ownerships[curr];
938                         if (ownership.addr != address(0)) {
939                             return ownership;
940                         }
941                     }
942                 }
943             }
944         }
945         revert OwnerQueryForNonexistentToken();
946     }
947 
948     /**
949      * @dev See {IERC721-ownerOf}.
950      */
951     function ownerOf(uint256 tokenId) public view override returns (address) {
952         return _ownershipOf(tokenId).addr;
953     }
954 
955     /**
956      * @dev See {IERC721Metadata-name}.
957      */
958     function name() public view virtual override returns (string memory) {
959         return _name;
960     }
961 
962     /**
963      * @dev See {IERC721Metadata-symbol}.
964      */
965     function symbol() public view virtual override returns (string memory) {
966         return _symbol;
967     }
968 
969     /**
970      * @dev See {IERC721Metadata-tokenURI}.
971      */
972     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
973         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
974 
975         string memory baseURI = _baseURI();
976         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
977     }
978 
979     /**
980      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
981      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
982      * by default, can be overriden in child contracts.
983      */
984     function _baseURI() internal view virtual returns (string memory) {
985         return '';
986     }
987 
988     /**
989      * @dev See {IERC721-approve}.
990      */
991     function approve(address to, uint256 tokenId) public override {
992         address owner = ERC721A.ownerOf(tokenId);
993         if (to == owner) revert ApprovalToCurrentOwner();
994 
995         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
996             revert ApprovalCallerNotOwnerNorApproved();
997         }
998 
999         _approve(to, tokenId, owner);
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-getApproved}.
1004      */
1005     function getApproved(uint256 tokenId) public view override returns (address) {
1006         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1007 
1008         return _tokenApprovals[tokenId];
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-setApprovalForAll}.
1013      */
1014     function setApprovalForAll(address operator, bool approved) public virtual override {
1015         if (operator == _msgSender()) revert ApproveToCaller();
1016 
1017         _operatorApprovals[_msgSender()][operator] = approved;
1018         emit ApprovalForAll(_msgSender(), operator, approved);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-isApprovedForAll}.
1023      */
1024     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1025         return _operatorApprovals[owner][operator];
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-transferFrom}.
1030      */
1031     function transferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) public virtual override {
1036         _transfer(from, to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-safeTransferFrom}.
1041      */
1042     function safeTransferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) public virtual override {
1047         safeTransferFrom(from, to, tokenId, '');
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-safeTransferFrom}.
1052      */
1053     function safeTransferFrom(
1054         address from,
1055         address to,
1056         uint256 tokenId,
1057         bytes memory _data
1058     ) public virtual override {
1059         _transfer(from, to, tokenId);
1060         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1061             revert TransferToNonERC721ReceiverImplementer();
1062         }
1063     }
1064 
1065     /**
1066      * @dev Returns whether `tokenId` exists.
1067      *
1068      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1069      *
1070      * Tokens start existing when they are minted (`_mint`),
1071      */
1072     function _exists(uint256 tokenId) internal view returns (bool) {
1073         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1074     }
1075 
1076     /**
1077      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1078      */
1079     function _safeMint(address to, uint256 quantity) internal {
1080         _safeMint(to, quantity, '');
1081     }
1082 
1083     /**
1084      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - If `to` refers to a smart contract, it must implement 
1089      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1090      * - `quantity` must be greater than 0.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _safeMint(
1095         address to,
1096         uint256 quantity,
1097         bytes memory _data
1098     ) internal {
1099         uint256 startTokenId = _currentIndex;
1100         if (to == address(0)) revert MintToZeroAddress();
1101         if (quantity == 0) revert MintZeroQuantity();
1102 
1103         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1104 
1105         // Overflows are incredibly unrealistic.
1106         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1107         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1108         unchecked {
1109             _addressData[to].balance += uint64(quantity);
1110             _addressData[to].numberMinted += uint64(quantity);
1111 
1112             _ownerships[startTokenId].addr = to;
1113             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1114 
1115             uint256 updatedIndex = startTokenId;
1116             uint256 end = updatedIndex + quantity;
1117 
1118             if (to.isContract()) {
1119                 do {
1120                     emit Transfer(address(0), to, updatedIndex);
1121                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1122                         revert TransferToNonERC721ReceiverImplementer();
1123                     }
1124                 } while (updatedIndex != end);
1125                 // Reentrancy protection
1126                 if (_currentIndex != startTokenId) revert();
1127             } else {
1128                 do {
1129                     emit Transfer(address(0), to, updatedIndex++);
1130                 } while (updatedIndex != end);
1131             }
1132             _currentIndex = updatedIndex;
1133         }
1134         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1135     }
1136 
1137     /**
1138      * @dev Mints `quantity` tokens and transfers them to `to`.
1139      *
1140      * Requirements:
1141      *
1142      * - `to` cannot be the zero address.
1143      * - `quantity` must be greater than 0.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function _mint(address to, uint256 quantity) internal {
1148         uint256 startTokenId = _currentIndex;
1149         if (to == address(0)) revert MintToZeroAddress();
1150         if (quantity == 0) revert MintZeroQuantity();
1151 
1152         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1153 
1154         // Overflows are incredibly unrealistic.
1155         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1156         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1157         unchecked {
1158             _addressData[to].balance += uint64(quantity);
1159             _addressData[to].numberMinted += uint64(quantity);
1160 
1161             _ownerships[startTokenId].addr = to;
1162             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1163 
1164             uint256 updatedIndex = startTokenId;
1165             uint256 end = updatedIndex + quantity;
1166 
1167             do {
1168                 emit Transfer(address(0), to, updatedIndex++);
1169             } while (updatedIndex != end);
1170 
1171             _currentIndex = updatedIndex;
1172         }
1173         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1174     }
1175 
1176     /**
1177      * @dev Transfers `tokenId` from `from` to `to`.
1178      *
1179      * Requirements:
1180      *
1181      * - `to` cannot be the zero address.
1182      * - `tokenId` token must be owned by `from`.
1183      *
1184      * Emits a {Transfer} event.
1185      */
1186     function _transfer(
1187         address from,
1188         address to,
1189         uint256 tokenId
1190     ) private {
1191         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1192 
1193         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1194 
1195         bool isApprovedOrOwner = (_msgSender() == from ||
1196             isApprovedForAll(from, _msgSender()) ||
1197             getApproved(tokenId) == _msgSender());
1198 
1199         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1200         if (to == address(0)) revert TransferToZeroAddress();
1201 
1202         _beforeTokenTransfers(from, to, tokenId, 1);
1203 
1204         // Clear approvals from the previous owner
1205         _approve(address(0), tokenId, from);
1206 
1207         // Underflow of the sender's balance is impossible because we check for
1208         // ownership above and the recipient's balance can't realistically overflow.
1209         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1210         unchecked {
1211             _addressData[from].balance -= 1;
1212             _addressData[to].balance += 1;
1213 
1214             TokenOwnership storage currSlot = _ownerships[tokenId];
1215             currSlot.addr = to;
1216             currSlot.startTimestamp = uint64(block.timestamp);
1217 
1218             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1219             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1220             uint256 nextTokenId = tokenId + 1;
1221             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1222             if (nextSlot.addr == address(0)) {
1223                 // This will suffice for checking _exists(nextTokenId),
1224                 // as a burned slot cannot contain the zero address.
1225                 if (nextTokenId != _currentIndex) {
1226                     nextSlot.addr = from;
1227                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1228                 }
1229             }
1230         }
1231 
1232         emit Transfer(from, to, tokenId);
1233         _afterTokenTransfers(from, to, tokenId, 1);
1234     }
1235 
1236     /**
1237      * @dev Equivalent to `_burn(tokenId, false)`.
1238      */
1239     function _burn(uint256 tokenId) internal virtual {
1240         _burn(tokenId, false);
1241     }
1242 
1243     /**
1244      * @dev Destroys `tokenId`.
1245      * The approval is cleared when the token is burned.
1246      *
1247      * Requirements:
1248      *
1249      * - `tokenId` must exist.
1250      *
1251      * Emits a {Transfer} event.
1252      */
1253     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1254         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1255 
1256         address from = prevOwnership.addr;
1257 
1258         if (approvalCheck) {
1259             bool isApprovedOrOwner = (_msgSender() == from ||
1260                 isApprovedForAll(from, _msgSender()) ||
1261                 getApproved(tokenId) == _msgSender());
1262 
1263             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1264         }
1265 
1266         _beforeTokenTransfers(from, address(0), tokenId, 1);
1267 
1268         // Clear approvals from the previous owner
1269         _approve(address(0), tokenId, from);
1270 
1271         // Underflow of the sender's balance is impossible because we check for
1272         // ownership above and the recipient's balance can't realistically overflow.
1273         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1274         unchecked {
1275             AddressData storage addressData = _addressData[from];
1276             addressData.balance -= 1;
1277             addressData.numberBurned += 1;
1278 
1279             // Keep track of who burned the token, and the timestamp of burning.
1280             TokenOwnership storage currSlot = _ownerships[tokenId];
1281             currSlot.addr = from;
1282             currSlot.startTimestamp = uint64(block.timestamp);
1283             currSlot.burned = true;
1284 
1285             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1286             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1287             uint256 nextTokenId = tokenId + 1;
1288             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1289             if (nextSlot.addr == address(0)) {
1290                 // This will suffice for checking _exists(nextTokenId),
1291                 // as a burned slot cannot contain the zero address.
1292                 if (nextTokenId != _currentIndex) {
1293                     nextSlot.addr = from;
1294                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1295                 }
1296             }
1297         }
1298 
1299         emit Transfer(from, address(0), tokenId);
1300         _afterTokenTransfers(from, address(0), tokenId, 1);
1301 
1302         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1303         unchecked {
1304             _burnCounter++;
1305         }
1306     }
1307 
1308     /**
1309      * @dev Approve `to` to operate on `tokenId`
1310      *
1311      * Emits a {Approval} event.
1312      */
1313     function _approve(
1314         address to,
1315         uint256 tokenId,
1316         address owner
1317     ) private {
1318         _tokenApprovals[tokenId] = to;
1319         emit Approval(owner, to, tokenId);
1320     }
1321 
1322     /**
1323      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1324      *
1325      * @param from address representing the previous owner of the given token ID
1326      * @param to target address that will receive the tokens
1327      * @param tokenId uint256 ID of the token to be transferred
1328      * @param _data bytes optional data to send along with the call
1329      * @return bool whether the call correctly returned the expected magic value
1330      */
1331     function _checkContractOnERC721Received(
1332         address from,
1333         address to,
1334         uint256 tokenId,
1335         bytes memory _data
1336     ) private returns (bool) {
1337         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1338             return retval == IERC721Receiver(to).onERC721Received.selector;
1339         } catch (bytes memory reason) {
1340             if (reason.length == 0) {
1341                 revert TransferToNonERC721ReceiverImplementer();
1342             } else {
1343                 assembly {
1344                     revert(add(32, reason), mload(reason))
1345                 }
1346             }
1347         }
1348     }
1349 
1350     /**
1351      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1352      * And also called before burning one token.
1353      *
1354      * startTokenId - the first token id to be transferred
1355      * quantity - the amount to be transferred
1356      *
1357      * Calling conditions:
1358      *
1359      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1360      * transferred to `to`.
1361      * - When `from` is zero, `tokenId` will be minted for `to`.
1362      * - When `to` is zero, `tokenId` will be burned by `from`.
1363      * - `from` and `to` are never both zero.
1364      */
1365     function _beforeTokenTransfers(
1366         address from,
1367         address to,
1368         uint256 startTokenId,
1369         uint256 quantity
1370     ) internal virtual {}
1371 
1372     /**
1373      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1374      * minting.
1375      * And also called after one token has been burned.
1376      *
1377      * startTokenId - the first token id to be transferred
1378      * quantity - the amount to be transferred
1379      *
1380      * Calling conditions:
1381      *
1382      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1383      * transferred to `to`.
1384      * - When `from` is zero, `tokenId` has been minted for `to`.
1385      * - When `to` is zero, `tokenId` has been burned by `from`.
1386      * - `from` and `to` are never both zero.
1387      */
1388     function _afterTokenTransfers(
1389         address from,
1390         address to,
1391         uint256 startTokenId,
1392         uint256 quantity
1393     ) internal virtual {}
1394 }
1395 // File: contracts/PudgyBirds.sol
1396 
1397 
1398 
1399 pragma solidity ^0.8.0;
1400 
1401 
1402 
1403 
1404 
1405 contract PudgyBirds is ERC721A, Ownable, ReentrancyGuard {
1406   using Address for address;
1407   using Strings for uint;
1408 
1409 
1410   string  public  baseTokenURI = "ipfs://QmPJ8fnr11n8GHZL7jF5QYFHGnFi2HEvYYP3gpN2AYt5kV/";
1411   uint256  public  maxSupply = 2700;
1412   uint256 public  MAX_MINTS_PER_TX = 20;
1413   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether;
1414   uint256 public  NUM_FREE_MINTS = 2700;
1415   uint256 public  MAX_FREE_PER_WALLET = 1;
1416   uint256 public freeNFTAlreadyMinted = 0;
1417   bool public isPublicSaleActive = false;
1418 
1419   constructor(
1420 
1421   ) ERC721A("PudgyBirds", "PudgyBirds") {
1422 
1423   }
1424 
1425 
1426   function mint(uint256 numberOfTokens)
1427       external
1428       payable
1429   {
1430     require(isPublicSaleActive, "Public sale is not open");
1431     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1432 
1433     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1434         require(
1435             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1436             "Incorrect ETH value sent"
1437         );
1438     } else {
1439         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1440         require(
1441             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1442             "Incorrect ETH value sent"
1443         );
1444         require(
1445             numberOfTokens <= MAX_MINTS_PER_TX,
1446             "Max mints per transaction exceeded"
1447         );
1448         } else {
1449             require(
1450                 numberOfTokens <= MAX_FREE_PER_WALLET,
1451                 "Max mints per transaction exceeded"
1452             );
1453             freeNFTAlreadyMinted += numberOfTokens;
1454         }
1455     }
1456     _safeMint(msg.sender, numberOfTokens);
1457   }
1458 
1459   function setBaseURI(string memory baseURI)
1460     public
1461     onlyOwner
1462   {
1463     baseTokenURI = baseURI;
1464   }
1465 
1466   function treasuryMint(uint quantity)
1467     public
1468     onlyOwner
1469   {
1470     require(
1471       quantity > 0,
1472       "Invalid mint amount"
1473     );
1474     require(
1475       totalSupply() + quantity <= maxSupply,
1476       "Maximum supply exceeded"
1477     );
1478     _safeMint(msg.sender, quantity);
1479   }
1480 
1481   function withdraw()
1482     public
1483     onlyOwner
1484     nonReentrant
1485   {
1486     Address.sendValue(payable(msg.sender), address(this).balance);
1487   }
1488 
1489   function tokenURI(uint _tokenId)
1490     public
1491     view
1492     virtual
1493     override
1494     returns (string memory)
1495   {
1496     require(
1497       _exists(_tokenId),
1498       "ERC721Metadata: URI query for nonexistent token"
1499     );
1500     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1501   }
1502 
1503   function _baseURI()
1504     internal
1505     view
1506     virtual
1507     override
1508     returns (string memory)
1509   {
1510     return baseTokenURI;
1511   }
1512 
1513   function setIsPublicSaleActive(bool _isPublicSaleActive)
1514       external
1515       onlyOwner
1516   {
1517       isPublicSaleActive = _isPublicSaleActive;
1518   }
1519 
1520   function setNumFreeMints(uint256 _numfreemints)
1521       external
1522       onlyOwner
1523   {
1524       NUM_FREE_MINTS = _numfreemints;
1525   }
1526 
1527   function setSalePrice(uint256 _price)
1528       external
1529       onlyOwner
1530   {
1531       PUBLIC_SALE_PRICE = _price;
1532   }
1533 
1534   function setMaxLimitPerTransaction(uint256 _limit)
1535       external
1536       onlyOwner
1537   {
1538       MAX_MINTS_PER_TX = _limit;
1539   }
1540 
1541   function setFreeLimitPerWallet(uint256 _limit)
1542       external
1543       onlyOwner
1544   {
1545       MAX_FREE_PER_WALLET = _limit;
1546   }
1547 }