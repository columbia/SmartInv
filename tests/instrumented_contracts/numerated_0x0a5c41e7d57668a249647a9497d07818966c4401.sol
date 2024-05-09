1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 .%%..%%....%%....%%..%%....%%....%%%%%...........%%%%%...%%%%%...%%%%%%......%%..%%...%%...%%%%..
6 .%%..%%...%%%....%%..%%...%%%....%%..%%..........%%..%%..%%..%%.....%%...%%..%%..%%%.%%%..%%.....
7 .%%..%%....%%....%%..%%....%%....%%..%%..........%%..%%..%%%%%.....%%%...%%%%%%..%%.%.%%...%%%%..
8 ..%%%%.....%%.....%%%%.....%%....%%..%%..........%%..%%..%%..%%......%%......%%..%%...%%......%%.
9 ...%%....%%%%%%....%%....%%%%%%..%%%%%...........%%%%%...%%..%%..%%%%%.......%%..%%...%%...%%%%..
10 .................................................................................................
11 
12 */
13 
14 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
15 
16 
17 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * dev Contract module that helps prevent reentrant calls to a function.
23  *
24  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
25  * available, which can be applied to functions to make sure there are no nested
26  * (reentrant) calls to them.
27  *
28  * Note that because there is a single `nonReentrant` guard, functions marked as
29  * `nonReentrant` may not call one another. This can be worked around by making
30  * those functions `private`, and then adding `external` `nonReentrant` entry
31  * points to them.
32  *
33  * TIP: If you would like to learn more about reentrancy and alternative ways
34  * to protect against it, check out our blog post
35  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
36  */
37 abstract contract ReentrancyGuard {
38     // Booleans are more expensive than uint256 or any type that takes up a full
39     // word because each write operation emits an extra SLOAD to first read the
40     // slot's contents, replace the bits taken up by the boolean, and then write
41     // back. This is the compiler's defense against contract upgrades and
42     // pointer aliasing, and it cannot be disabled.
43 
44     // The values being non-zero value makes deployment a bit more expensive,
45     // but in exchange the refund on every call to nonReentrant will be lower in
46     // amount. Since refunds are capped to a percentage of the total
47     // transaction's gas, it is best to keep them low in cases like this one, to
48     // increase the likelihood of the full refund coming into effect.
49     uint256 private constant _NOT_ENTERED = 1;
50     uint256 private constant _ENTERED = 2;
51 
52     uint256 private _status;
53 
54     constructor() {
55         _status = _NOT_ENTERED;
56     }
57 
58     /**
59      * dev Prevents a contract from calling itself, directly or indirectly.
60      * Calling a `nonReentrant` function from another `nonReentrant`
61      * function is not supported. It is possible to prevent this from happening
62      * by making the `nonReentrant` function external, and making it call a
63      * `private` function that does the actual work.
64      */
65     modifier nonReentrant() {
66         // On the first call to nonReentrant, _notEntered will be true
67         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
68 
69         // Any calls to nonReentrant after this point will fail
70         _status = _ENTERED;
71 
72         _;
73 
74         // By storing the original value once again, a refund is triggered (see
75         // https://eips.ethereum.org/EIPS/eip-2200)
76         _status = _NOT_ENTERED;
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/Strings.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * dev String operations.
89  */
90 library Strings {
91     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
92 
93     /**
94      * dev Converts a `uint256` to its ASCII `string` decimal representation.
95      */
96     function toString(uint256 value) internal pure returns (string memory) {
97         // Inspired by OraclizeAPI's implementation - MIT licence
98         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
99 
100         if (value == 0) {
101             return "0";
102         }
103         uint256 temp = value;
104         uint256 digits;
105         while (temp != 0) {
106             digits++;
107             temp /= 10;
108         }
109         bytes memory buffer = new bytes(digits);
110         while (value != 0) {
111             digits -= 1;
112             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
113             value /= 10;
114         }
115         return string(buffer);
116     }
117 
118     /**
119      * dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
120      */
121     function toHexString(uint256 value) internal pure returns (string memory) {
122         if (value == 0) {
123             return "0x00";
124         }
125         uint256 temp = value;
126         uint256 length = 0;
127         while (temp != 0) {
128             length++;
129             temp >>= 8;
130         }
131         return toHexString(value, length);
132     }
133 
134     /**
135      * dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
136      */
137     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
138         bytes memory buffer = new bytes(2 * length + 2);
139         buffer[0] = "0";
140         buffer[1] = "x";
141         for (uint256 i = 2 * length + 1; i > 1; --i) {
142             buffer[i] = _HEX_SYMBOLS[value & 0xf];
143             value >>= 4;
144         }
145         require(value == 0, "Strings: hex length insufficient");
146         return string(buffer);
147     }
148 }
149 
150 // File: @openzeppelin/contracts/utils/Context.sol
151 
152 
153 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
154 
155 pragma solidity ^0.8.0;
156 
157 /**
158  * dev Provides information about the current execution context, including the
159  * sender of the transaction and its data. While these are generally available
160  * via msg.sender and msg.data, they should not be accessed in such a direct
161  * manner, since when dealing with meta-transactions the account sending and
162  * paying for execution may not be the actual sender (as far as an application
163  * is concerned).
164  *
165  * This contract is only required for intermediate, library-like contracts.
166  */
167 abstract contract Context {
168     function _msgSender() internal view virtual returns (address) {
169         return msg.sender;
170     }
171 
172     function _msgData() internal view virtual returns (bytes calldata) {
173         return msg.data;
174     }
175 }
176 
177 // File: @openzeppelin/contracts/access/Ownable.sol
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 
185 /**
186  * dev Contract module which provides a basic access control mechanism, where
187  * there is an account (an owner) that can be granted exclusive access to
188  * specific functions.
189  *
190  * By default, the owner account will be the one that deploys the contract. This
191  * can later be changed with {transferOwnership}.
192  *
193  * This module is used through inheritance. It will make available the modifier
194  * `onlyOwner`, which can be applied to your functions to restrict their use to
195  * the owner.
196  */
197 abstract contract Ownable is Context {
198     address private _owner;
199 
200     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
201 
202     /**
203      * dev Initializes the contract setting the deployer as the initial owner.
204      */
205     constructor() {
206         _transferOwnership(_msgSender());
207     }
208 
209     /**
210      * dev Returns the address of the current owner.
211      */
212     function owner() public view virtual returns (address) {
213         return _owner;
214     }
215 
216     /**
217      * dev Throws if called by any account other than the owner.
218      */
219     modifier onlyOwner() {
220         require(owner() == _msgSender(), "Ownable: caller is not the owner");
221         _;
222     }
223 
224     /**
225      * dev Leaves the contract without owner. It will not be possible to call
226      * `onlyOwner` functions anymore. Can only be called by the current owner.
227      *
228      * NOTE: Renouncing ownership will leave the contract without an owner,
229      * thereby removing any functionality that is only available to the owner.
230      */
231     function renounceOwnership() public virtual onlyOwner {
232         _transferOwnership(address(0));
233     }
234 
235     /**
236      * dev Transfers ownership of the contract to a new account (`newOwner`).
237      * Can only be called by the current owner.
238      */
239     function transferOwnership(address newOwner) public virtual onlyOwner {
240         require(newOwner != address(0), "Ownable: new owner is the zero address");
241         _transferOwnership(newOwner);
242     }
243 
244     /**
245      * dev Transfers ownership of the contract to a new account (`newOwner`).
246      * Internal function without access restriction.
247      */
248     function _transferOwnership(address newOwner) internal virtual {
249         address oldOwner = _owner;
250         _owner = newOwner;
251         emit OwnershipTransferred(oldOwner, newOwner);
252     }
253 }
254 
255 // File: @openzeppelin/contracts/utils/Address.sol
256 
257 
258 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
259 
260 pragma solidity ^0.8.1;
261 
262 /**
263  * dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      *
283      * [IMPORTANT]
284      * ====
285      * You shouldn't rely on `isContract` to protect against flash loan attacks!
286      *
287      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
288      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
289      * constructor.
290      * ====
291      */
292     function isContract(address account) internal view returns (bool) {
293         // This method relies on extcodesize/address.code.length, which returns 0
294         // for contracts in construction, since the code is only stored at the end
295         // of the constructor execution.
296 
297         return account.code.length > 0;
298     }
299 
300     /**
301      * dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         (bool success, ) = recipient.call{value: amount}("");
320         require(success, "Address: unable to send value, recipient may have reverted");
321     }
322 
323     /**
324      * dev Performs a Solidity function call using a low level `call`. A
325      * plain `call` is an unsafe replacement for a function call: use this
326      * function instead.
327      *
328      * If `target` reverts with a revert reason, it is bubbled up by this
329      * function (like regular Solidity function calls).
330      *
331      * Returns the raw returned data. To convert to the expected return value,
332      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
333      *
334      * Requirements:
335      *
336      * - `target` must be a contract.
337      * - calling `target` with `data` must not revert.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
342         return functionCall(target, data, "Address: low-level call failed");
343     }
344 
345     /**
346      * dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
347      * `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, 0, errorMessage);
357     }
358 
359     /**
360      * dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but also transferring `value` wei to `target`.
362      *
363      * Requirements:
364      *
365      * - the calling contract must have an ETH balance of at least `value`.
366      * - the called Solidity function must be `payable`.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value
374     ) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         require(isContract(target), "Address: call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.call{value: value}(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a static call.
400      *
401      * _Available since v3.3._
402      */
403     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
404         return functionStaticCall(target, data, "Address: low-level static call failed");
405     }
406 
407     /**
408      * dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal view returns (bytes memory) {
418         require(isContract(target), "Address: static call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.staticcall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a delegate call.
427      *
428      * _Available since v3.4._
429      */
430     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
431         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
432     }
433 
434     /**
435      * dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(isContract(target), "Address: delegate call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.delegatecall(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
453      * revert reason using the provided one.
454      *
455      * _Available since v4.3._
456      */
457     function verifyCallResult(
458         bool success,
459         bytes memory returndata,
460         string memory errorMessage
461     ) internal pure returns (bytes memory) {
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468 
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @title ERC721 token receiver interface
489  * dev Interface for any contract that wants to support safeTransfers
490  * from ERC721 asset contracts.
491  */
492 interface IERC721Receiver {
493     /**
494      * dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
495      * by `operator` from `from`, this function is called.
496      *
497      * It must return its Solidity selector to confirm the token transfer.
498      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
499      *
500      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
501      */
502     function onERC721Received(
503         address operator,
504         address from,
505         uint256 tokenId,
506         bytes calldata data
507     ) external returns (bytes4);
508 }
509 
510 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 /**
518  * dev Interface of the ERC165 standard, as defined in the
519  * https://eips.ethereum.org/EIPS/eip-165[EIP].
520  *
521  * Implementers can declare support of contract interfaces, which can then be
522  * queried by others ({ERC165Checker}).
523  *
524  * For an implementation, see {ERC165}.
525  */
526 interface IERC165 {
527     /**
528      * dev Returns true if this contract implements the interface defined by
529      * `interfaceId`. See the corresponding
530      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
531      * to learn more about how these ids are created.
532      *
533      * This function call must use less than 30 000 gas.
534      */
535     function supportsInterface(bytes4 interfaceId) external view returns (bool);
536 }
537 
538 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
539 
540 
541 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * dev Implementation of the {IERC165} interface.
548  *
549  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
550  * for the additional interface id that will be supported. For example:
551  *
552  * ```solidity
553  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
555  * }
556  * ```
557  *
558  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
559  */
560 abstract contract ERC165 is IERC165 {
561     /**
562      * dev See {IERC165-supportsInterface}.
563      */
564     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
565         return interfaceId == type(IERC165).interfaceId;
566     }
567 }
568 
569 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
570 
571 
572 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 
577 /**
578  * dev Required interface of an ERC721 compliant contract.
579  */
580 interface IERC721 is IERC165 {
581     /**
582      * dev Emitted when `tokenId` token is transferred from `from` to `to`.
583      */
584     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
585 
586     /**
587      * dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
588      */
589     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
590 
591     /**
592      * dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
593      */
594     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
595 
596     /**
597      * dev Returns the number of tokens in ``owner``'s account.
598      */
599     function balanceOf(address owner) external view returns (uint256 balance);
600 
601     /**
602      * dev Returns the owner of the `tokenId` token.
603      *
604      * Requirements:
605      *
606      * - `tokenId` must exist.
607      */
608     function ownerOf(uint256 tokenId) external view returns (address owner);
609 
610     /**
611      * dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
612      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must exist and be owned by `from`.
619      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
620      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
621      *
622      * Emits a {Transfer} event.
623      */
624     function safeTransferFrom(
625         address from,
626         address to,
627         uint256 tokenId
628     ) external;
629 
630     /**
631      * dev Transfers `tokenId` token from `from` to `to`.
632      *
633      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
634      *
635      * Requirements:
636      *
637      * - `from` cannot be the zero address.
638      * - `to` cannot be the zero address.
639      * - `tokenId` token must be owned by `from`.
640      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
641      *
642      * Emits a {Transfer} event.
643      */
644     function transferFrom(
645         address from,
646         address to,
647         uint256 tokenId
648     ) external;
649 
650     /**
651      * dev Gives permission to `to` to transfer `tokenId` token to another account.
652      * The approval is cleared when the token is transferred.
653      *
654      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
655      *
656      * Requirements:
657      *
658      * - The caller must own the token or be an approved operator.
659      * - `tokenId` must exist.
660      *
661      * Emits an {Approval} event.
662      */
663     function approve(address to, uint256 tokenId) external;
664 
665     /**
666      * dev Returns the account approved for `tokenId` token.
667      *
668      * Requirements:
669      *
670      * - `tokenId` must exist.
671      */
672     function getApproved(uint256 tokenId) external view returns (address operator);
673 
674     /**
675      * dev Approve or remove `operator` as an operator for the caller.
676      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
677      *
678      * Requirements:
679      *
680      * - The `operator` cannot be the caller.
681      *
682      * Emits an {ApprovalForAll} event.
683      */
684     function setApprovalForAll(address operator, bool _approved) external;
685 
686     /**
687      * dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
688      *
689      * See {setApprovalForAll}
690      */
691     function isApprovedForAll(address owner, address operator) external view returns (bool);
692 
693     /**
694      * dev Safely transfers `tokenId` token from `from` to `to`.
695      *
696      * Requirements:
697      *
698      * - `from` cannot be the zero address.
699      * - `to` cannot be the zero address.
700      * - `tokenId` token must exist and be owned by `from`.
701      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
702      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
703      *
704      * Emits a {Transfer} event.
705      */
706     function safeTransferFrom(
707         address from,
708         address to,
709         uint256 tokenId,
710         bytes calldata data
711     ) external;
712 }
713 
714 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
715 
716 
717 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
718 
719 pragma solidity ^0.8.0;
720 
721 
722 /**
723  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
724  * dev See https://eips.ethereum.org/EIPS/eip-721
725  */
726 interface IERC721Metadata is IERC721 {
727     /**
728      * dev Returns the token collection name.
729      */
730     function name() external view returns (string memory);
731 
732     /**
733      * dev Returns the token collection symbol.
734      */
735     function symbol() external view returns (string memory);
736 
737     /**
738      * dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
739      */
740     function tokenURI(uint256 tokenId) external view returns (string memory);
741 }
742 
743 // File: erc721a/contracts/ERC721A.sol
744 
745 
746 pragma solidity ^0.8.4;
747 
748 
749 error ApprovalCallerNotOwnerNorApproved();
750 error ApprovalQueryForNonexistentToken();
751 error ApproveToCaller();
752 error ApprovalToCurrentOwner();
753 error BalanceQueryForZeroAddress();
754 error MintToZeroAddress();
755 error MintZeroQuantity();
756 error OwnerQueryForNonexistentToken();
757 error TransferCallerNotOwnerNorApproved();
758 error TransferFromIncorrectOwner();
759 error TransferToNonERC721ReceiverImplementer();
760 error TransferToZeroAddress();
761 error URIQueryForNonexistentToken();
762 
763 /**
764  * dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
765  * the Metadata extension. Built to optimize for lower gas during batch mints.
766  *
767  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
768  *
769  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
770  *
771  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
772  */
773 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
774     using Address for address;
775     using Strings for uint256;
776 
777     // Compiler will pack this into a single 256bit word.
778     struct TokenOwnership {
779         // The address of the owner.
780         address addr;
781         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
782         uint64 startTimestamp;
783         // Whether the token has been burned.
784         bool burned;
785     }
786 
787     // Compiler will pack this into a single 256bit word.
788     struct AddressData {
789         // Realistically, 2**64-1 is more than enough.
790         uint64 balance;
791         // Keeps track of mint count with minimal overhead for tokenomics.
792         uint64 numberMinted;
793         // Keeps track of burn count with minimal overhead for tokenomics.
794         uint64 numberBurned;
795         // For miscellaneous variable(s) pertaining to the address
796         // (e.g. number of whitelist mint slots used).
797         // If there are multiple variables, please pack them into a uint64.
798         uint64 aux;
799     }
800 
801     // The tokenId of the next token to be minted.
802     uint256 internal _currentIndex;
803 
804     // The number of tokens burned.
805     uint256 internal _burnCounter;
806 
807     // Token name
808     string private _name;
809 
810     // Token symbol
811     string private _symbol;
812 
813     // Mapping from token ID to ownership details
814     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
815     mapping(uint256 => TokenOwnership) internal _ownerships;
816 
817     // Mapping owner address to address data
818     mapping(address => AddressData) private _addressData;
819 
820     // Mapping from token ID to approved address
821     mapping(uint256 => address) private _tokenApprovals;
822 
823     // Mapping from owner to operator approvals
824     mapping(address => mapping(address => bool)) private _operatorApprovals;
825 
826     constructor(string memory name_, string memory symbol_) {
827         _name = name_;
828         _symbol = symbol_;
829         _currentIndex = _startTokenId();
830     }
831 
832     /**
833      * To change the starting tokenId, please override this function.
834      */
835     function _startTokenId() internal view virtual returns (uint256) {
836         return 0;
837     }
838 
839     /**
840      * dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
841      */
842     function totalSupply() public view returns (uint256) {
843         // Counter underflow is impossible as _burnCounter cannot be incremented
844         // more than _currentIndex - _startTokenId() times
845         unchecked {
846             return _currentIndex - _burnCounter - _startTokenId();
847         }
848     }
849 
850     /**
851      * Returns the total amount of tokens minted in the contract.
852      */
853     function _totalMinted() internal view returns (uint256) {
854         // Counter underflow is impossible as _currentIndex does not decrement,
855         // and it is initialized to _startTokenId()
856         unchecked {
857             return _currentIndex - _startTokenId();
858         }
859     }
860 
861     /**
862      * dev See {IERC165-supportsInterface}.
863      */
864     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
865         return
866             interfaceId == type(IERC721).interfaceId ||
867             interfaceId == type(IERC721Metadata).interfaceId ||
868             super.supportsInterface(interfaceId);
869     }
870 
871     /**
872      * dev See {IERC721-balanceOf}.
873      */
874     function balanceOf(address owner) public view override returns (uint256) {
875         if (owner == address(0)) revert BalanceQueryForZeroAddress();
876         return uint256(_addressData[owner].balance);
877     }
878 
879     /**
880      * Returns the number of tokens minted by `owner`.
881      */
882     function _numberMinted(address owner) internal view returns (uint256) {
883         return uint256(_addressData[owner].numberMinted);
884     }
885 
886     /**
887      * Returns the number of tokens burned by or on behalf of `owner`.
888      */
889     function _numberBurned(address owner) internal view returns (uint256) {
890         return uint256(_addressData[owner].numberBurned);
891     }
892 
893     /**
894      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
895      */
896     function _getAux(address owner) internal view returns (uint64) {
897         return _addressData[owner].aux;
898     }
899 
900     /**
901      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
902      * If there are multiple variables, please pack them into a uint64.
903      */
904     function _setAux(address owner, uint64 aux) internal {
905         _addressData[owner].aux = aux;
906     }
907 
908     /**
909      * Gas spent here starts off proportional to the maximum mint batch size.
910      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
911      */
912     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
913         uint256 curr = tokenId;
914 
915         unchecked {
916             if (_startTokenId() <= curr && curr < _currentIndex) {
917                 TokenOwnership memory ownership = _ownerships[curr];
918                 if (!ownership.burned) {
919                     if (ownership.addr != address(0)) {
920                         return ownership;
921                     }
922                     // Invariant:
923                     // There will always be an ownership that has an address and is not burned
924                     // before an ownership that does not have an address and is not burned.
925                     // Hence, curr will not underflow.
926                     while (true) {
927                         curr--;
928                         ownership = _ownerships[curr];
929                         if (ownership.addr != address(0)) {
930                             return ownership;
931                         }
932                     }
933                 }
934             }
935         }
936         revert OwnerQueryForNonexistentToken();
937     }
938 
939     /**
940      * dev See {IERC721-ownerOf}.
941      */
942     function ownerOf(uint256 tokenId) public view override returns (address) {
943         return _ownershipOf(tokenId).addr;
944     }
945 
946     /**
947      * dev See {IERC721Metadata-name}.
948      */
949     function name() public view virtual override returns (string memory) {
950         return _name;
951     }
952 
953     /**
954      * dev See {IERC721Metadata-symbol}.
955      */
956     function symbol() public view virtual override returns (string memory) {
957         return _symbol;
958     }
959 
960     /**
961      * dev See {IERC721Metadata-tokenURI}.
962      */
963     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
964         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
965 
966         string memory baseURI = _baseURI();
967         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
968     }
969 
970     /**
971      * dev Base URI for computing {tokenURI}. If set, the resulting URI for each
972      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
973      * by default, can be overriden in child contracts.
974      */
975     function _baseURI() internal view virtual returns (string memory) {
976         return '';
977     }
978 
979     /**
980      * dev See {IERC721-approve}.
981      */
982     function approve(address to, uint256 tokenId) public override {
983         address owner = ERC721A.ownerOf(tokenId);
984         if (to == owner) revert ApprovalToCurrentOwner();
985 
986         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
987             revert ApprovalCallerNotOwnerNorApproved();
988         }
989 
990         _approve(to, tokenId, owner);
991     }
992 
993     /**
994      * dev See {IERC721-getApproved}.
995      */
996     function getApproved(uint256 tokenId) public view override returns (address) {
997         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
998 
999         return _tokenApprovals[tokenId];
1000     }
1001 
1002     /**
1003      * dev See {IERC721-setApprovalForAll}.
1004      */
1005     function setApprovalForAll(address operator, bool approved) public virtual override {
1006         if (operator == _msgSender()) revert ApproveToCaller();
1007 
1008         _operatorApprovals[_msgSender()][operator] = approved;
1009         emit ApprovalForAll(_msgSender(), operator, approved);
1010     }
1011 
1012     /**
1013      * dev See {IERC721-isApprovedForAll}.
1014      */
1015     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1016         return _operatorApprovals[owner][operator];
1017     }
1018 
1019     /**
1020      * dev See {IERC721-transferFrom}.
1021      */
1022     function transferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) public virtual override {
1027         _transfer(from, to, tokenId);
1028     }
1029 
1030     /**
1031      * dev See {IERC721-safeTransferFrom}.
1032      */
1033     function safeTransferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) public virtual override {
1038         safeTransferFrom(from, to, tokenId, '');
1039     }
1040 
1041     /**
1042      * dev See {IERC721-safeTransferFrom}.
1043      */
1044     function safeTransferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId,
1048         bytes memory _data
1049     ) public virtual override {
1050         _transfer(from, to, tokenId);
1051         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1052             revert TransferToNonERC721ReceiverImplementer();
1053         }
1054     }
1055 
1056     /**
1057      * dev Returns whether `tokenId` exists.
1058      *
1059      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1060      *
1061      * Tokens start existing when they are minted (`_mint`),
1062      */
1063     function _exists(uint256 tokenId) internal view returns (bool) {
1064         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1065             !_ownerships[tokenId].burned;
1066     }
1067 
1068     function _safeMint(address to, uint256 quantity) internal {
1069         _safeMint(to, quantity, '');
1070     }
1071 
1072     /**
1073      * dev Safely mints `quantity` tokens and transfers them to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1078      * - `quantity` must be greater than 0.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _safeMint(
1083         address to,
1084         uint256 quantity,
1085         bytes memory _data
1086     ) internal {
1087         _mint(to, quantity, _data, true);
1088     }
1089 
1090     /**
1091      * dev Mints `quantity` tokens and transfers them to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `to` cannot be the zero address.
1096      * - `quantity` must be greater than 0.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _mint(
1101         address to,
1102         uint256 quantity,
1103         bytes memory _data,
1104         bool safe
1105     ) internal {
1106         uint256 startTokenId = _currentIndex;
1107         if (to == address(0)) revert MintToZeroAddress();
1108         if (quantity == 0) revert MintZeroQuantity();
1109 
1110         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1111 
1112         // Overflows are incredibly unrealistic.
1113         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1114         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1115         unchecked {
1116             _addressData[to].balance += uint64(quantity);
1117             _addressData[to].numberMinted += uint64(quantity);
1118 
1119             _ownerships[startTokenId].addr = to;
1120             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1121 
1122             uint256 updatedIndex = startTokenId;
1123             uint256 end = updatedIndex + quantity;
1124 
1125             if (safe && to.isContract()) {
1126                 do {
1127                     emit Transfer(address(0), to, updatedIndex);
1128                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1129                         revert TransferToNonERC721ReceiverImplementer();
1130                     }
1131                 } while (updatedIndex != end);
1132                 // Reentrancy protection
1133                 if (_currentIndex != startTokenId) revert();
1134             } else {
1135                 do {
1136                     emit Transfer(address(0), to, updatedIndex++);
1137                 } while (updatedIndex != end);
1138             }
1139             _currentIndex = updatedIndex;
1140         }
1141         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1142     }
1143 
1144     /**
1145      * dev Transfers `tokenId` from `from` to `to`.
1146      *
1147      * Requirements:
1148      *
1149      * - `to` cannot be the zero address.
1150      * - `tokenId` token must be owned by `from`.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _transfer(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) private {
1159         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1160 
1161         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1162 
1163         bool isApprovedOrOwner = (_msgSender() == from ||
1164             isApprovedForAll(from, _msgSender()) ||
1165             getApproved(tokenId) == _msgSender());
1166 
1167         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1168         if (to == address(0)) revert TransferToZeroAddress();
1169 
1170         _beforeTokenTransfers(from, to, tokenId, 1);
1171 
1172         // Clear approvals from the previous owner
1173         _approve(address(0), tokenId, from);
1174 
1175         // Underflow of the sender's balance is impossible because we check for
1176         // ownership above and the recipient's balance can't realistically overflow.
1177         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1178         unchecked {
1179             _addressData[from].balance -= 1;
1180             _addressData[to].balance += 1;
1181 
1182             TokenOwnership storage currSlot = _ownerships[tokenId];
1183             currSlot.addr = to;
1184             currSlot.startTimestamp = uint64(block.timestamp);
1185 
1186             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1187             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1188             uint256 nextTokenId = tokenId + 1;
1189             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1190             if (nextSlot.addr == address(0)) {
1191                 // This will suffice for checking _exists(nextTokenId),
1192                 // as a burned slot cannot contain the zero address.
1193                 if (nextTokenId != _currentIndex) {
1194                     nextSlot.addr = from;
1195                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1196                 }
1197             }
1198         }
1199 
1200         emit Transfer(from, to, tokenId);
1201         _afterTokenTransfers(from, to, tokenId, 1);
1202     }
1203 
1204     /**
1205      * dev This is equivalent to _burn(tokenId, false)
1206      */
1207     function _burn(uint256 tokenId) internal virtual {
1208         _burn(tokenId, false);
1209     }
1210 
1211     /**
1212      * dev Destroys `tokenId`.
1213      * The approval is cleared when the token is burned.
1214      *
1215      * Requirements:
1216      *
1217      * - `tokenId` must exist.
1218      *
1219      * Emits a {Transfer} event.
1220      */
1221     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1222         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1223 
1224         address from = prevOwnership.addr;
1225 
1226         if (approvalCheck) {
1227             bool isApprovedOrOwner = (_msgSender() == from ||
1228                 isApprovedForAll(from, _msgSender()) ||
1229                 getApproved(tokenId) == _msgSender());
1230 
1231             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1232         }
1233 
1234         _beforeTokenTransfers(from, address(0), tokenId, 1);
1235 
1236         // Clear approvals from the previous owner
1237         _approve(address(0), tokenId, from);
1238 
1239         // Underflow of the sender's balance is impossible because we check for
1240         // ownership above and the recipient's balance can't realistically overflow.
1241         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1242         unchecked {
1243             AddressData storage addressData = _addressData[from];
1244             addressData.balance -= 1;
1245             addressData.numberBurned += 1;
1246 
1247             // Keep track of who burned the token, and the timestamp of burning.
1248             TokenOwnership storage currSlot = _ownerships[tokenId];
1249             currSlot.addr = from;
1250             currSlot.startTimestamp = uint64(block.timestamp);
1251             currSlot.burned = true;
1252 
1253             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1254             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1255             uint256 nextTokenId = tokenId + 1;
1256             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1257             if (nextSlot.addr == address(0)) {
1258                 // This will suffice for checking _exists(nextTokenId),
1259                 // as a burned slot cannot contain the zero address.
1260                 if (nextTokenId != _currentIndex) {
1261                     nextSlot.addr = from;
1262                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1263                 }
1264             }
1265         }
1266 
1267         emit Transfer(from, address(0), tokenId);
1268         _afterTokenTransfers(from, address(0), tokenId, 1);
1269 
1270         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1271         unchecked {
1272             _burnCounter++;
1273         }
1274     }
1275 
1276     /**
1277      * dev Approve `to` to operate on `tokenId`
1278      *
1279      * Emits a {Approval} event.
1280      */
1281     function _approve(
1282         address to,
1283         uint256 tokenId,
1284         address owner
1285     ) private {
1286         _tokenApprovals[tokenId] = to;
1287         emit Approval(owner, to, tokenId);
1288     }
1289 
1290     /**
1291      * dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1292      *
1293      * @param from address representing the previous owner of the given token ID
1294      * @param to target address that will receive the tokens
1295      * @param tokenId uint256 ID of the token to be transferred
1296      * @param _data bytes optional data to send along with the call
1297      * @return bool whether the call correctly returned the expected magic value
1298      */
1299     function _checkContractOnERC721Received(
1300         address from,
1301         address to,
1302         uint256 tokenId,
1303         bytes memory _data
1304     ) private returns (bool) {
1305         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1306             return retval == IERC721Receiver(to).onERC721Received.selector;
1307         } catch (bytes memory reason) {
1308             if (reason.length == 0) {
1309                 revert TransferToNonERC721ReceiverImplementer();
1310             } else {
1311                 assembly {
1312                     revert(add(32, reason), mload(reason))
1313                 }
1314             }
1315         }
1316     }
1317 
1318     /**
1319      * dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1320      * And also called before burning one token.
1321      *
1322      * startTokenId - the first token id to be transferred
1323      * quantity - the amount to be transferred
1324      *
1325      * Calling conditions:
1326      *
1327      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1328      * transferred to `to`.
1329      * - When `from` is zero, `tokenId` will be minted for `to`.
1330      * - When `to` is zero, `tokenId` will be burned by `from`.
1331      * - `from` and `to` are never both zero.
1332      */
1333     function _beforeTokenTransfers(
1334         address from,
1335         address to,
1336         uint256 startTokenId,
1337         uint256 quantity
1338     ) internal virtual {}
1339 
1340     /**
1341      * dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1342      * minting.
1343      * And also called after one token has been burned.
1344      *
1345      * startTokenId - the first token id to be transferred
1346      * quantity - the amount to be transferred
1347      *
1348      * Calling conditions:
1349      *
1350      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1351      * transferred to `to`.
1352      * - When `from` is zero, `tokenId` has been minted for `to`.
1353      * - When `to` is zero, `tokenId` has been burned by `from`.
1354      * - `from` and `to` are never both zero.
1355      */
1356     function _afterTokenTransfers(
1357         address from,
1358         address to,
1359         uint256 startTokenId,
1360         uint256 quantity
1361     ) internal virtual {}
1362 }
1363 
1364 
1365 
1366 pragma solidity >=0.8.9 <0.9.0;
1367 
1368 
1369 contract V1V1DDR34MS is ERC721A, Ownable, ReentrancyGuard {
1370 
1371   using Strings for uint256;
1372 
1373   string public uriPrefix = '';
1374   string public uriSuffix = '.json';
1375   
1376   uint256 public cost;
1377   uint256 public freeMintSupply;
1378   uint256 public maxSupply;
1379   uint256 public maxMintAmountPerWallet;
1380 
1381   bool public paused = true;
1382 
1383   mapping(address => uint256) private _walletMints;
1384   mapping(address => uint256) private _freeWalletMints;
1385 
1386   constructor(
1387     string memory _tokenName,
1388     string memory _tokenSymbol,
1389     uint256 _cost,
1390     uint256 _freeMintSupply,
1391     uint256 _maxSupply,
1392     uint256 _maxMintAmountPerWallet,
1393     string memory _uriPrefix
1394   ) ERC721A(_tokenName, _tokenSymbol) {
1395     setCost(_cost);
1396     setFreeMint(_freeMintSupply);
1397     maxSupply = _maxSupply;
1398     setMaxMintAmountPerWallet(_maxMintAmountPerWallet);
1399     setUriPrefix(_uriPrefix);
1400     _safeMint(_msgSender(), 10);
1401   }
1402 
1403   modifier mintCompliance(uint256 _mintAmount) {
1404     require(_mintAmount > 0 && _walletMints[_msgSender()] + _mintAmount < maxMintAmountPerWallet + 1, 'Invalid mint amount!');
1405     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1406     require(totalSupply() >= freeMintSupply, 'Free mint not finished yet!');
1407     _;
1408   }
1409 
1410   modifier freeMintCompliance(uint256 _mintAmount) {
1411     require(_mintAmount > 0 && _mintAmount <= 1, 'You can mint only One!');
1412     require(_freeWalletMints[_msgSender()] + _mintAmount <= 1, 'You have already minted');
1413     require(totalSupply() + _mintAmount <= freeMintSupply, 'Max free mint supply exceeded!');
1414     _;
1415   }
1416 
1417   modifier mintPriceCompliance(uint256 _mintAmount) {
1418     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1419     _;
1420   }
1421 
1422   function freeMint(uint256 _mintAmount) public payable freeMintCompliance(_mintAmount) {
1423     require(!paused, 'The contract is paused!');
1424 
1425     _freeWalletMints[_msgSender()] += _mintAmount;
1426     _safeMint(_msgSender(), _mintAmount);
1427   }
1428 
1429 
1430   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
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
1476   function setCost(uint256 _cost) public onlyOwner {
1477     cost = _cost;
1478   }
1479 
1480   function setFreeMint(uint256 _supply) public onlyOwner {
1481     freeMintSupply = _supply;
1482   }
1483 
1484   function setMaxMintAmountPerWallet(uint256 _maxMintAmountPerWallet) public onlyOwner {
1485     maxMintAmountPerWallet = _maxMintAmountPerWallet;
1486   }
1487 
1488   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1489     uriPrefix = _uriPrefix;
1490   }
1491 
1492   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1493     uriSuffix = _uriSuffix;
1494   }
1495 
1496   function setPaused(bool _state) public onlyOwner {
1497     paused = _state;
1498   }
1499 
1500   function withdraw() public onlyOwner nonReentrant {
1501 
1502     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1503     require(os);
1504   }
1505 
1506   function _baseURI() internal view virtual override returns (string memory) {
1507     return uriPrefix;
1508   }
1509 }