1 /**                                                                            
2 
3   ___  _____  ____  __   _  _    ____  __  __  ___ 
4  / __)(  _  )(  _ \(  ) ( \/ )  (  _ \(  )(  )/ __)
5 ( (_-. )(_)(  )(_) ))(__ \  /    )   / )(__)(( (_-.
6  \___/(_____)(____/(____)(__)   (_)\_)(______)\___/
7 
8 */
9 
10 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
11 
12 // SPDX-License-Identifier: MIT
13 
14 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Contract module that helps prevent reentrant calls to a function.
20  *
21  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
22  * available, which can be applied to functions to make sure there are no nested
23  * (reentrant) calls to them.
24  *
25  * Note that because there is a single `nonReentrant` guard, functions marked as
26  * `nonReentrant` may not call one another. This can be worked around by making
27  * those functions `private`, and then adding `external` `nonReentrant` entry
28  * points to them.
29  *
30  * TIP: If you would like to learn more about reentrancy and alternative ways
31  * to protect against it, check out our blog post
32  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
33  */
34 abstract contract ReentrancyGuard {
35     // Booleans are more expensive than uint256 or any type that takes up a full
36     // word because each write operation emits an extra SLOAD to first read the
37     // slot's contents, replace the bits taken up by the boolean, and then write
38     // back. This is the compiler's defense against contract upgrades and
39     // pointer aliasing, and it cannot be disabled.
40 
41     // The values being non-zero value makes deployment a bit more expensive,
42     // but in exchange the refund on every call to nonReentrant will be lower in
43     // amount. Since refunds are capped to a percentage of the total
44     // transaction's gas, it is best to keep them low in cases like this one, to
45     // increase the likelihood of the full refund coming into effect.
46     uint256 private constant _NOT_ENTERED = 1;
47     uint256 private constant _ENTERED = 2;
48 
49     uint256 private _status;
50 
51     constructor() {
52         _status = _NOT_ENTERED;
53     }
54 
55     /**
56      * @dev Prevents a contract from calling itself, directly or indirectly.
57      * Calling a `nonReentrant` function from another `nonReentrant`
58      * function is not supported. It is possible to prevent this from happening
59      * by making the `nonReentrant` function external, and making it call a
60      * `private` function that does the actual work.
61      */
62     modifier nonReentrant() {
63         // On the first call to nonReentrant, _notEntered will be true
64         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
65 
66         // Any calls to nonReentrant after this point will fail
67         _status = _ENTERED;
68 
69         _;
70 
71         // By storing the original value once again, a refund is triggered (see
72         // https://eips.ethereum.org/EIPS/eip-2200)
73         _status = _NOT_ENTERED;
74     }
75 }
76 
77 // File: @openzeppelin/contracts/utils/Strings.sol
78 
79 
80 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
81 
82 pragma solidity ^0.8.0;
83 
84 /**
85  * @dev String operations.
86  */
87 library Strings {
88     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
89 
90     /**
91      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
92      */
93     function toString(uint256 value) internal pure returns (string memory) {
94         // Inspired by OraclizeAPI's implementation - MIT licence
95         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
96 
97         if (value == 0) {
98             return "0";
99         }
100         uint256 temp = value;
101         uint256 digits;
102         while (temp != 0) {
103             digits++;
104             temp /= 10;
105         }
106         bytes memory buffer = new bytes(digits);
107         while (value != 0) {
108             digits -= 1;
109             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
110             value /= 10;
111         }
112         return string(buffer);
113     }
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
117      */
118     function toHexString(uint256 value) internal pure returns (string memory) {
119         if (value == 0) {
120             return "0x00";
121         }
122         uint256 temp = value;
123         uint256 length = 0;
124         while (temp != 0) {
125             length++;
126             temp >>= 8;
127         }
128         return toHexString(value, length);
129     }
130 
131     /**
132      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
133      */
134     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
135         bytes memory buffer = new bytes(2 * length + 2);
136         buffer[0] = "0";
137         buffer[1] = "x";
138         for (uint256 i = 2 * length + 1; i > 1; --i) {
139             buffer[i] = _HEX_SYMBOLS[value & 0xf];
140             value >>= 4;
141         }
142         require(value == 0, "Strings: hex length insufficient");
143         return string(buffer);
144     }
145 }
146 
147 // File: @openzeppelin/contracts/utils/Context.sol
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 /**
155  * @dev Provides information about the current execution context, including the
156  * sender of the transaction and its data. While these are generally available
157  * via msg.sender and msg.data, they should not be accessed in such a direct
158  * manner, since when dealing with meta-transactions the account sending and
159  * paying for execution may not be the actual sender (as far as an application
160  * is concerned).
161  *
162  * This contract is only required for intermediate, library-like contracts.
163  */
164 abstract contract Context {
165     function _msgSender() internal view virtual returns (address) {
166         return msg.sender;
167     }
168 
169     function _msgData() internal view virtual returns (bytes calldata) {
170         return msg.data;
171     }
172 }
173 
174 // File: @openzeppelin/contracts/access/Ownable.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @dev Contract module which provides a basic access control mechanism, where
184  * there is an account (an owner) that can be granted exclusive access to
185  * specific functions.
186  *
187  * By default, the owner account will be the one that deploys the contract. This
188  * can later be changed with {transferOwnership}.
189  *
190  * This module is used through inheritance. It will make available the modifier
191  * `onlyOwner`, which can be applied to your functions to restrict their use to
192  * the owner.
193  */
194 abstract contract Ownable is Context {
195     address private _owner;
196 
197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199     /**
200      * @dev Initializes the contract setting the deployer as the initial owner.
201      */
202     constructor() {
203         _transferOwnership(_msgSender());
204     }
205 
206     /**
207      * @dev Returns the address of the current owner.
208      */
209     function owner() public view virtual returns (address) {
210         return _owner;
211     }
212 
213     /**
214      * @dev Throws if called by any account other than the owner.
215      */
216     modifier onlyOwner() {
217         require(owner() == _msgSender(), "Ownable: caller is not the owner");
218         _;
219     }
220 
221     /**
222      * @dev Leaves the contract without owner. It will not be possible to call
223      * `onlyOwner` functions anymore. Can only be called by the current owner.
224      *
225      * NOTE: Renouncing ownership will leave the contract without an owner,
226      * thereby removing any functionality that is only available to the owner.
227      */
228     function renounceOwnership() public virtual onlyOwner {
229         _transferOwnership(address(0));
230     }
231 
232     /**
233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
234      * Can only be called by the current owner.
235      */
236     function transferOwnership(address newOwner) public virtual onlyOwner {
237         require(newOwner != address(0), "Ownable: new owner is the zero address");
238         _transferOwnership(newOwner);
239     }
240 
241     /**
242      * @dev Transfers ownership of the contract to a new account (`newOwner`).
243      * Internal function without access restriction.
244      */
245     function _transferOwnership(address newOwner) internal virtual {
246         address oldOwner = _owner;
247         _owner = newOwner;
248         emit OwnershipTransferred(oldOwner, newOwner);
249     }
250 }
251 
252 // File: @openzeppelin/contracts/utils/Address.sol
253 
254 
255 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
256 
257 pragma solidity ^0.8.1;
258 
259 /**
260  * @dev Collection of functions related to the address type
261  */
262 library Address {
263     /**
264      * @dev Returns true if `account` is a contract.
265      *
266      * [IMPORTANT]
267      * ====
268      * It is unsafe to assume that an address for which this function returns
269      * false is an externally-owned account (EOA) and not a contract.
270      *
271      * Among others, `isContract` will return false for the following
272      * types of addresses:
273      *
274      *  - an externally-owned account
275      *  - a contract in construction
276      *  - an address where a contract will be created
277      *  - an address where a contract lived, but was destroyed
278      * ====
279      *
280      * [IMPORTANT]
281      * ====
282      * You shouldn't rely on `isContract` to protect against flash loan attacks!
283      *
284      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
285      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
286      * constructor.
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // This method relies on extcodesize/address.code.length, which returns 0
291         // for contracts in construction, since the code is only stored at the end
292         // of the constructor execution.
293 
294         return account.code.length > 0;
295     }
296 
297     /**
298      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
299      * `recipient`, forwarding all available gas and reverting on errors.
300      *
301      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
302      * of certain opcodes, possibly making contracts go over the 2300 gas limit
303      * imposed by `transfer`, making them unable to receive funds via
304      * `transfer`. {sendValue} removes this limitation.
305      *
306      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
307      *
308      * IMPORTANT: because control is transferred to `recipient`, care must be
309      * taken to not create reentrancy vulnerabilities. Consider using
310      * {ReentrancyGuard} or the
311      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
312      */
313     function sendValue(address payable recipient, uint256 amount) internal {
314         require(address(this).balance >= amount, "Address: insufficient balance");
315 
316         (bool success, ) = recipient.call{value: amount}("");
317         require(success, "Address: unable to send value, recipient may have reverted");
318     }
319 
320     /**
321      * @dev Performs a Solidity function call using a low level `call`. A
322      * plain `call` is an unsafe replacement for a function call: use this
323      * function instead.
324      *
325      * If `target` reverts with a revert reason, it is bubbled up by this
326      * function (like regular Solidity function calls).
327      *
328      * Returns the raw returned data. To convert to the expected return value,
329      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
330      *
331      * Requirements:
332      *
333      * - `target` must be a contract.
334      * - calling `target` with `data` must not revert.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
339         return functionCall(target, data, "Address: low-level call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
344      * `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, 0, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but also transferring `value` wei to `target`.
359      *
360      * Requirements:
361      *
362      * - the calling contract must have an ETH balance of at least `value`.
363      * - the called Solidity function must be `payable`.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(
368         address target,
369         bytes memory data,
370         uint256 value
371     ) internal returns (bytes memory) {
372         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
377      * with `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(
382         address target,
383         bytes memory data,
384         uint256 value,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         require(address(this).balance >= value, "Address: insufficient balance for call");
388         require(isContract(target), "Address: call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.call{value: value}(data);
391         return verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
401         return functionStaticCall(target, data, "Address: low-level static call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
406      * but performing a static call.
407      *
408      * _Available since v3.3._
409      */
410     function functionStaticCall(
411         address target,
412         bytes memory data,
413         string memory errorMessage
414     ) internal view returns (bytes memory) {
415         require(isContract(target), "Address: static call to non-contract");
416 
417         (bool success, bytes memory returndata) = target.staticcall(data);
418         return verifyCallResult(success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423      * but performing a delegate call.
424      *
425      * _Available since v3.4._
426      */
427     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
428         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
433      * but performing a delegate call.
434      *
435      * _Available since v3.4._
436      */
437     function functionDelegateCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         require(isContract(target), "Address: delegate call to non-contract");
443 
444         (bool success, bytes memory returndata) = target.delegatecall(data);
445         return verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     /**
449      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
450      * revert reason using the provided one.
451      *
452      * _Available since v4.3._
453      */
454     function verifyCallResult(
455         bool success,
456         bytes memory returndata,
457         string memory errorMessage
458     ) internal pure returns (bytes memory) {
459         if (success) {
460             return returndata;
461         } else {
462             // Look for revert reason and bubble it up if present
463             if (returndata.length > 0) {
464                 // The easiest way to bubble the revert reason is using memory via assembly
465 
466                 assembly {
467                     let returndata_size := mload(returndata)
468                     revert(add(32, returndata), returndata_size)
469                 }
470             } else {
471                 revert(errorMessage);
472             }
473         }
474     }
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
478 
479 
480 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @title ERC721 token receiver interface
486  * @dev Interface for any contract that wants to support safeTransfers
487  * from ERC721 asset contracts.
488  */
489 interface IERC721Receiver {
490     /**
491      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
492      * by `operator` from `from`, this function is called.
493      *
494      * It must return its Solidity selector to confirm the token transfer.
495      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
496      *
497      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
498      */
499     function onERC721Received(
500         address operator,
501         address from,
502         uint256 tokenId,
503         bytes calldata data
504     ) external returns (bytes4);
505 }
506 
507 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
508 
509 
510 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Interface of the ERC165 standard, as defined in the
516  * https://eips.ethereum.org/EIPS/eip-165[EIP].
517  *
518  * Implementers can declare support of contract interfaces, which can then be
519  * queried by others ({ERC165Checker}).
520  *
521  * For an implementation, see {ERC165}.
522  */
523 interface IERC165 {
524     /**
525      * @dev Returns true if this contract implements the interface defined by
526      * `interfaceId`. See the corresponding
527      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
528      * to learn more about how these ids are created.
529      *
530      * This function call must use less than 30 000 gas.
531      */
532     function supportsInterface(bytes4 interfaceId) external view returns (bool);
533 }
534 
535 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
536 
537 
538 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 
543 /**
544  * @dev Implementation of the {IERC165} interface.
545  *
546  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
547  * for the additional interface id that will be supported. For example:
548  *
549  * ```solidity
550  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
552  * }
553  * ```
554  *
555  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
556  */
557 abstract contract ERC165 is IERC165 {
558     /**
559      * @dev See {IERC165-supportsInterface}.
560      */
561     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562         return interfaceId == type(IERC165).interfaceId;
563     }
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
567 
568 
569 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 
574 /**
575  * @dev Required interface of an ERC721 compliant contract.
576  */
577 interface IERC721 is IERC165 {
578     /**
579      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
580      */
581     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
582 
583     /**
584      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
585      */
586     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
587 
588     /**
589      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
590      */
591     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
592 
593     /**
594      * @dev Returns the number of tokens in ``owner``'s account.
595      */
596     function balanceOf(address owner) external view returns (uint256 balance);
597 
598     /**
599      * @dev Returns the owner of the `tokenId` token.
600      *
601      * Requirements:
602      *
603      * - `tokenId` must exist.
604      */
605     function ownerOf(uint256 tokenId) external view returns (address owner);
606 
607     /**
608      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
609      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
610      *
611      * Requirements:
612      *
613      * - `from` cannot be the zero address.
614      * - `to` cannot be the zero address.
615      * - `tokenId` token must exist and be owned by `from`.
616      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
617      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
618      *
619      * Emits a {Transfer} event.
620      */
621     function safeTransferFrom(
622         address from,
623         address to,
624         uint256 tokenId
625     ) external;
626 
627     /**
628      * @dev Transfers `tokenId` token from `from` to `to`.
629      *
630      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
631      *
632      * Requirements:
633      *
634      * - `from` cannot be the zero address.
635      * - `to` cannot be the zero address.
636      * - `tokenId` token must be owned by `from`.
637      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
638      *
639      * Emits a {Transfer} event.
640      */
641     function transferFrom(
642         address from,
643         address to,
644         uint256 tokenId
645     ) external;
646 
647     /**
648      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
649      * The approval is cleared when the token is transferred.
650      *
651      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
652      *
653      * Requirements:
654      *
655      * - The caller must own the token or be an approved operator.
656      * - `tokenId` must exist.
657      *
658      * Emits an {Approval} event.
659      */
660     function approve(address to, uint256 tokenId) external;
661 
662     /**
663      * @dev Returns the account approved for `tokenId` token.
664      *
665      * Requirements:
666      *
667      * - `tokenId` must exist.
668      */
669     function getApproved(uint256 tokenId) external view returns (address operator);
670 
671     /**
672      * @dev Approve or remove `operator` as an operator for the caller.
673      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
674      *
675      * Requirements:
676      *
677      * - The `operator` cannot be the caller.
678      *
679      * Emits an {ApprovalForAll} event.
680      */
681     function setApprovalForAll(address operator, bool _approved) external;
682 
683     /**
684      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
685      *
686      * See {setApprovalForAll}
687      */
688     function isApprovedForAll(address owner, address operator) external view returns (bool);
689 
690     /**
691      * @dev Safely transfers `tokenId` token from `from` to `to`.
692      *
693      * Requirements:
694      *
695      * - `from` cannot be the zero address.
696      * - `to` cannot be the zero address.
697      * - `tokenId` token must exist and be owned by `from`.
698      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
699      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
700      *
701      * Emits a {Transfer} event.
702      */
703     function safeTransferFrom(
704         address from,
705         address to,
706         uint256 tokenId,
707         bytes calldata data
708     ) external;
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
712 
713 
714 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 /**
720  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
721  * @dev See https://eips.ethereum.org/EIPS/eip-721
722  */
723 interface IERC721Metadata is IERC721 {
724     /**
725      * @dev Returns the token collection name.
726      */
727     function name() external view returns (string memory);
728 
729     /**
730      * @dev Returns the token collection symbol.
731      */
732     function symbol() external view returns (string memory);
733 
734     /**
735      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
736      */
737     function tokenURI(uint256 tokenId) external view returns (string memory);
738 }
739 
740 // File: contracts/ERC721A.sol
741 
742 
743 // Creator: Chiru Labs
744 
745 pragma solidity ^0.8.4;
746 
747 
748 
749 
750 
751 
752 
753 
754 error ApprovalCallerNotOwnerNorApproved();
755 error ApprovalQueryForNonexistentToken();
756 error ApproveToCaller();
757 error ApprovalToCurrentOwner();
758 error BalanceQueryForZeroAddress();
759 error MintToZeroAddress();
760 error MintZeroQuantity();
761 error OwnerQueryForNonexistentToken();
762 error TransferCallerNotOwnerNorApproved();
763 error TransferFromIncorrectOwner();
764 error TransferToNonERC721ReceiverImplementer();
765 error TransferToZeroAddress();
766 error URIQueryForNonexistentToken();
767 
768 /**
769  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
770  * the Metadata extension. Built to optimize for lower gas during batch mints.
771  *
772  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
773  *
774  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
775  *
776  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
777  */
778 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
779     using Address for address;
780     using Strings for uint256;
781 
782     // Compiler will pack this into a single 256bit word.
783     struct TokenOwnership {
784         // The address of the owner.
785         address addr;
786         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
787         uint64 startTimestamp;
788         // Whether the token has been burned.
789         bool burned;
790     }
791 
792     // Compiler will pack this into a single 256bit word.
793     struct AddressData {
794         // Realistically, 2**64-1 is more than enough.
795         uint64 balance;
796         // Keeps track of mint count with minimal overhead for tokenomics.
797         uint64 numberMinted;
798         // Keeps track of burn count with minimal overhead for tokenomics.
799         uint64 numberBurned;
800         // For miscellaneous variable(s) pertaining to the address
801         // (e.g. number of whitelist mint slots used).
802         // If there are multiple variables, please pack them into a uint64.
803         uint64 aux;
804     }
805 
806     // The tokenId of the next token to be minted.
807     uint256 internal _currentIndex;
808 
809     // The number of tokens burned.
810     uint256 internal _burnCounter;
811 
812     // Token name
813     string private _name;
814 
815     // Token symbol
816     string private _symbol;
817 
818     // Mapping from token ID to ownership details
819     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
820     mapping(uint256 => TokenOwnership) internal _ownerships;
821 
822     // Mapping owner address to address data
823     mapping(address => AddressData) private _addressData;
824 
825     // Mapping from token ID to approved address
826     mapping(uint256 => address) private _tokenApprovals;
827 
828     // Mapping from owner to operator approvals
829     mapping(address => mapping(address => bool)) private _operatorApprovals;
830 
831     constructor(string memory name_, string memory symbol_) {
832         _name = name_;
833         _symbol = symbol_;
834         _currentIndex = _startTokenId();
835     }
836 
837     /**
838      * To change the starting tokenId, please override this function.
839      */
840     function _startTokenId() internal view virtual returns (uint256) {
841         return 1;
842     }
843 
844     /**
845      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
846      */
847     function totalSupply() public view returns (uint256) {
848         // Counter underflow is impossible as _burnCounter cannot be incremented
849         // more than _currentIndex - _startTokenId() times
850         unchecked {
851             return _currentIndex - _burnCounter - _startTokenId();
852         }
853     }
854 
855     /**
856      * Returns the total amount of tokens minted in the contract.
857      */
858     function _totalMinted() internal view returns (uint256) {
859         // Counter underflow is impossible as _currentIndex does not decrement,
860         // and it is initialized to _startTokenId()
861         unchecked {
862             return _currentIndex - _startTokenId();
863         }
864     }
865 
866     /**
867      * @dev See {IERC165-supportsInterface}.
868      */
869     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
870         return
871             interfaceId == type(IERC721).interfaceId ||
872             interfaceId == type(IERC721Metadata).interfaceId ||
873             super.supportsInterface(interfaceId);
874     }
875 
876     /**
877      * @dev See {IERC721-balanceOf}.
878      */
879     function balanceOf(address owner) public view override returns (uint256) {
880         if (owner == address(0)) revert BalanceQueryForZeroAddress();
881         return uint256(_addressData[owner].balance);
882     }
883 
884     /**
885      * Returns the number of tokens minted by `owner`.
886      */
887     function _numberMinted(address owner) internal view returns (uint256) {
888         return uint256(_addressData[owner].numberMinted);
889     }
890 
891     /**
892      * Returns the number of tokens burned by or on behalf of `owner`.
893      */
894     function _numberBurned(address owner) internal view returns (uint256) {
895         return uint256(_addressData[owner].numberBurned);
896     }
897 
898     /**
899      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
900      */
901     function _getAux(address owner) internal view returns (uint64) {
902         return _addressData[owner].aux;
903     }
904 
905     /**
906      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
907      * If there are multiple variables, please pack them into a uint64.
908      */
909     function _setAux(address owner, uint64 aux) internal {
910         _addressData[owner].aux = aux;
911     }
912 
913     /**
914      * Gas spent here starts off proportional to the maximum mint batch size.
915      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
916      */
917     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
918         uint256 curr = tokenId;
919 
920         unchecked {
921             if (_startTokenId() <= curr && curr < _currentIndex) {
922                 TokenOwnership memory ownership = _ownerships[curr];
923                 if (!ownership.burned) {
924                     if (ownership.addr != address(0)) {
925                         return ownership;
926                     }
927                     // Invariant:
928                     // There will always be an ownership that has an address and is not burned
929                     // before an ownership that does not have an address and is not burned.
930                     // Hence, curr will not underflow.
931                     while (true) {
932                         curr--;
933                         ownership = _ownerships[curr];
934                         if (ownership.addr != address(0)) {
935                             return ownership;
936                         }
937                     }
938                 }
939             }
940         }
941         revert OwnerQueryForNonexistentToken();
942     }
943 
944     /**
945      * @dev See {IERC721-ownerOf}.
946      */
947     function ownerOf(uint256 tokenId) public view override returns (address) {
948         return _ownershipOf(tokenId).addr;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-name}.
953      */
954     function name() public view virtual override returns (string memory) {
955         return _name;
956     }
957 
958     /**
959      * @dev See {IERC721Metadata-symbol}.
960      */
961     function symbol() public view virtual override returns (string memory) {
962         return _symbol;
963     }
964 
965     /**
966      * @dev See {IERC721Metadata-tokenURI}.
967      */
968     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
969         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
970 
971         string memory baseURI = _baseURI();
972         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
973     }
974 
975     /**
976      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
977      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
978      * by default, can be overriden in child contracts.
979      */
980     function _baseURI() internal view virtual returns (string memory) {
981         return '';
982     }
983 
984     /**
985      * @dev See {IERC721-approve}.
986      */
987     function approve(address to, uint256 tokenId) public override {
988         address owner = ERC721A.ownerOf(tokenId);
989         if (to == owner) revert ApprovalToCurrentOwner();
990 
991         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
992             revert ApprovalCallerNotOwnerNorApproved();
993         }
994 
995         _approve(to, tokenId, owner);
996     }
997 
998     /**
999      * @dev See {IERC721-getApproved}.
1000      */
1001     function getApproved(uint256 tokenId) public view override returns (address) {
1002         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1003 
1004         return _tokenApprovals[tokenId];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-setApprovalForAll}.
1009      */
1010     function setApprovalForAll(address operator, bool approved) public virtual override {
1011         if (operator == _msgSender()) revert ApproveToCaller();
1012 
1013         _operatorApprovals[_msgSender()][operator] = approved;
1014         emit ApprovalForAll(_msgSender(), operator, approved);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-isApprovedForAll}.
1019      */
1020     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1021         return _operatorApprovals[owner][operator];
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-transferFrom}.
1026      */
1027     function transferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         _transfer(from, to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) public virtual override {
1043         safeTransferFrom(from, to, tokenId, '');
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-safeTransferFrom}.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) public virtual override {
1055         _transfer(from, to, tokenId);
1056         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1057             revert TransferToNonERC721ReceiverImplementer();
1058         }
1059     }
1060 
1061     /**
1062      * @dev Returns whether `tokenId` exists.
1063      *
1064      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1065      *
1066      * Tokens start existing when they are minted (`_mint`),
1067      */
1068     function _exists(uint256 tokenId) internal view returns (bool) {
1069         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1070     }
1071 
1072     /**
1073      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1074      */
1075     function _safeMint(address to, uint256 quantity) internal {
1076         _safeMint(to, quantity, '');
1077     }
1078 
1079     /**
1080      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1081      *
1082      * Requirements:
1083      *
1084      * - If `to` refers to a smart contract, it must implement 
1085      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1086      * - `quantity` must be greater than 0.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _safeMint(
1091         address to,
1092         uint256 quantity,
1093         bytes memory _data
1094     ) internal {
1095         uint256 startTokenId = _currentIndex;
1096         if (to == address(0)) revert MintToZeroAddress();
1097         if (quantity == 0) revert MintZeroQuantity();
1098 
1099         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1100 
1101         // Overflows are incredibly unrealistic.
1102         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1103         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1104         unchecked {
1105             _addressData[to].balance += uint64(quantity);
1106             _addressData[to].numberMinted += uint64(quantity);
1107 
1108             _ownerships[startTokenId].addr = to;
1109             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1110 
1111             uint256 updatedIndex = startTokenId;
1112             uint256 end = updatedIndex + quantity;
1113 
1114             if (to.isContract()) {
1115                 do {
1116                     emit Transfer(address(0), to, updatedIndex);
1117                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1118                         revert TransferToNonERC721ReceiverImplementer();
1119                     }
1120                 } while (updatedIndex != end);
1121                 // Reentrancy protection
1122                 if (_currentIndex != startTokenId) revert();
1123             } else {
1124                 do {
1125                     emit Transfer(address(0), to, updatedIndex++);
1126                 } while (updatedIndex != end);
1127             }
1128             _currentIndex = updatedIndex;
1129         }
1130         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1131     }
1132 
1133     /**
1134      * @dev Mints `quantity` tokens and transfers them to `to`.
1135      *
1136      * Requirements:
1137      *
1138      * - `to` cannot be the zero address.
1139      * - `quantity` must be greater than 0.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _mint(address to, uint256 quantity) internal {
1144         uint256 startTokenId = _currentIndex;
1145         if (to == address(0)) revert MintToZeroAddress();
1146         if (quantity == 0) revert MintZeroQuantity();
1147 
1148         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1149 
1150         // Overflows are incredibly unrealistic.
1151         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1152         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1153         unchecked {
1154             _addressData[to].balance += uint64(quantity);
1155             _addressData[to].numberMinted += uint64(quantity);
1156 
1157             _ownerships[startTokenId].addr = to;
1158             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1159 
1160             uint256 updatedIndex = startTokenId;
1161             uint256 end = updatedIndex + quantity;
1162 
1163             do {
1164                 emit Transfer(address(0), to, updatedIndex++);
1165             } while (updatedIndex != end);
1166 
1167             _currentIndex = updatedIndex;
1168         }
1169         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1170     }
1171 
1172     /**
1173      * @dev Transfers `tokenId` from `from` to `to`.
1174      *
1175      * Requirements:
1176      *
1177      * - `to` cannot be the zero address.
1178      * - `tokenId` token must be owned by `from`.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function _transfer(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) private {
1187         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1188 
1189         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1190 
1191         bool isApprovedOrOwner = (_msgSender() == from ||
1192             isApprovedForAll(from, _msgSender()) ||
1193             getApproved(tokenId) == _msgSender());
1194 
1195         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1196         if (to == address(0)) revert TransferToZeroAddress();
1197 
1198         _beforeTokenTransfers(from, to, tokenId, 1);
1199 
1200         // Clear approvals from the previous owner
1201         _approve(address(0), tokenId, from);
1202 
1203         // Underflow of the sender's balance is impossible because we check for
1204         // ownership above and the recipient's balance can't realistically overflow.
1205         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1206         unchecked {
1207             _addressData[from].balance -= 1;
1208             _addressData[to].balance += 1;
1209 
1210             TokenOwnership storage currSlot = _ownerships[tokenId];
1211             currSlot.addr = to;
1212             currSlot.startTimestamp = uint64(block.timestamp);
1213 
1214             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1215             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1216             uint256 nextTokenId = tokenId + 1;
1217             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1218             if (nextSlot.addr == address(0)) {
1219                 // This will suffice for checking _exists(nextTokenId),
1220                 // as a burned slot cannot contain the zero address.
1221                 if (nextTokenId != _currentIndex) {
1222                     nextSlot.addr = from;
1223                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1224                 }
1225             }
1226         }
1227 
1228         emit Transfer(from, to, tokenId);
1229         _afterTokenTransfers(from, to, tokenId, 1);
1230     }
1231 
1232     /**
1233      * @dev Equivalent to `_burn(tokenId, false)`.
1234      */
1235     function _burn(uint256 tokenId) internal virtual {
1236         _burn(tokenId, false);
1237     }
1238 
1239     /**
1240      * @dev Destroys `tokenId`.
1241      * The approval is cleared when the token is burned.
1242      *
1243      * Requirements:
1244      *
1245      * - `tokenId` must exist.
1246      *
1247      * Emits a {Transfer} event.
1248      */
1249     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1250         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1251 
1252         address from = prevOwnership.addr;
1253 
1254         if (approvalCheck) {
1255             bool isApprovedOrOwner = (_msgSender() == from ||
1256                 isApprovedForAll(from, _msgSender()) ||
1257                 getApproved(tokenId) == _msgSender());
1258 
1259             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1260         }
1261 
1262         _beforeTokenTransfers(from, address(0), tokenId, 1);
1263 
1264         // Clear approvals from the previous owner
1265         _approve(address(0), tokenId, from);
1266 
1267         // Underflow of the sender's balance is impossible because we check for
1268         // ownership above and the recipient's balance can't realistically overflow.
1269         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1270         unchecked {
1271             AddressData storage addressData = _addressData[from];
1272             addressData.balance -= 1;
1273             addressData.numberBurned += 1;
1274 
1275             // Keep track of who burned the token, and the timestamp of burning.
1276             TokenOwnership storage currSlot = _ownerships[tokenId];
1277             currSlot.addr = from;
1278             currSlot.startTimestamp = uint64(block.timestamp);
1279             currSlot.burned = true;
1280 
1281             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1282             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1283             uint256 nextTokenId = tokenId + 1;
1284             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1285             if (nextSlot.addr == address(0)) {
1286                 // This will suffice for checking _exists(nextTokenId),
1287                 // as a burned slot cannot contain the zero address.
1288                 if (nextTokenId != _currentIndex) {
1289                     nextSlot.addr = from;
1290                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1291                 }
1292             }
1293         }
1294 
1295         emit Transfer(from, address(0), tokenId);
1296         _afterTokenTransfers(from, address(0), tokenId, 1);
1297 
1298         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1299         unchecked {
1300             _burnCounter++;
1301         }
1302     }
1303 
1304     /**
1305      * @dev Approve `to` to operate on `tokenId`
1306      *
1307      * Emits a {Approval} event.
1308      */
1309     function _approve(
1310         address to,
1311         uint256 tokenId,
1312         address owner
1313     ) private {
1314         _tokenApprovals[tokenId] = to;
1315         emit Approval(owner, to, tokenId);
1316     }
1317 
1318     /**
1319      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1320      *
1321      * @param from address representing the previous owner of the given token ID
1322      * @param to target address that will receive the tokens
1323      * @param tokenId uint256 ID of the token to be transferred
1324      * @param _data bytes optional data to send along with the call
1325      * @return bool whether the call correctly returned the expected magic value
1326      */
1327     function _checkContractOnERC721Received(
1328         address from,
1329         address to,
1330         uint256 tokenId,
1331         bytes memory _data
1332     ) private returns (bool) {
1333         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1334             return retval == IERC721Receiver(to).onERC721Received.selector;
1335         } catch (bytes memory reason) {
1336             if (reason.length == 0) {
1337                 revert TransferToNonERC721ReceiverImplementer();
1338             } else {
1339                 assembly {
1340                     revert(add(32, reason), mload(reason))
1341                 }
1342             }
1343         }
1344     }
1345 
1346     /**
1347      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1348      * And also called before burning one token.
1349      *
1350      * startTokenId - the first token id to be transferred
1351      * quantity - the amount to be transferred
1352      *
1353      * Calling conditions:
1354      *
1355      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1356      * transferred to `to`.
1357      * - When `from` is zero, `tokenId` will be minted for `to`.
1358      * - When `to` is zero, `tokenId` will be burned by `from`.
1359      * - `from` and `to` are never both zero.
1360      */
1361     function _beforeTokenTransfers(
1362         address from,
1363         address to,
1364         uint256 startTokenId,
1365         uint256 quantity
1366     ) internal virtual {}
1367 
1368     /**
1369      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1370      * minting.
1371      * And also called after one token has been burned.
1372      *
1373      * startTokenId - the first token id to be transferred
1374      * quantity - the amount to be transferred
1375      *
1376      * Calling conditions:
1377      *
1378      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1379      * transferred to `to`.
1380      * - When `from` is zero, `tokenId` has been minted for `to`.
1381      * - When `to` is zero, `tokenId` has been burned by `from`.
1382      * - `from` and `to` are never both zero.
1383      */
1384     function _afterTokenTransfers(
1385         address from,
1386         address to,
1387         uint256 startTokenId,
1388         uint256 quantity
1389     ) internal virtual {}
1390 }
1391 // File: contracts/GODLYRUG.sol
1392 
1393 
1394 
1395 pragma solidity ^0.8.0;
1396 
1397 
1398 
1399 
1400 
1401 contract GODLYRUG is ERC721A, Ownable, ReentrancyGuard {
1402   using Address for address;
1403   using Strings for uint;
1404 
1405 
1406   string  public  baseTokenURI = "ipfs://QmeQrXbTFsM55Ef2sraGsC5fmfPrTMJwfGEUCzLMBt6c2B/";
1407   uint256  public  maxSupply = 5000;
1408   uint256 public  MAX_MINTS_PER_TX = 20;
1409   uint256 public  PUBLIC_SALE_PRICE = 0.002 ether;
1410   uint256 public  NUM_FREE_MINTS = 5000;
1411   uint256 public  MAX_FREE_PER_WALLET = 1;
1412   uint256 public freeNFTAlreadyMinted = 0;
1413   bool public isPublicSaleActive = false;
1414 
1415   constructor(
1416 
1417   ) ERC721A("GODLYRUG", "GODLYRUG") {
1418 
1419   }
1420 
1421 
1422   function mint(uint256 numberOfTokens)
1423       external
1424       payable
1425   {
1426     require(isPublicSaleActive, "Public sale is not open");
1427     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1428 
1429     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1430         require(
1431             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1432             "Incorrect ETH value sent"
1433         );
1434     } else {
1435         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1436         require(
1437             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1438             "Incorrect ETH value sent"
1439         );
1440         require(
1441             numberOfTokens <= MAX_MINTS_PER_TX,
1442             "Max mints per transaction exceeded"
1443         );
1444         } else {
1445             require(
1446                 numberOfTokens <= MAX_FREE_PER_WALLET,
1447                 "Max mints per transaction exceeded"
1448             );
1449             freeNFTAlreadyMinted += numberOfTokens;
1450         }
1451     }
1452     _safeMint(msg.sender, numberOfTokens);
1453   }
1454 
1455   function setBaseURI(string memory baseURI)
1456     public
1457     onlyOwner
1458   {
1459     baseTokenURI = baseURI;
1460   }
1461 
1462   function treasuryMint(uint quantity)
1463     public
1464     onlyOwner
1465   {
1466     require(
1467       quantity > 0,
1468       "Invalid mint amount"
1469     );
1470     require(
1471       totalSupply() + quantity <= maxSupply,
1472       "Maximum supply exceeded"
1473     );
1474     _safeMint(msg.sender, quantity);
1475   }
1476 
1477   function withdraw()
1478     public
1479     onlyOwner
1480     nonReentrant
1481   {
1482     Address.sendValue(payable(msg.sender), address(this).balance);
1483   }
1484 
1485   function tokenURI(uint _tokenId)
1486     public
1487     view
1488     virtual
1489     override
1490     returns (string memory)
1491   {
1492     require(
1493       _exists(_tokenId),
1494       "ERC721Metadata: URI query for nonexistent token"
1495     );
1496     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1497   }
1498 
1499   function _baseURI()
1500     internal
1501     view
1502     virtual
1503     override
1504     returns (string memory)
1505   {
1506     return baseTokenURI;
1507   }
1508 
1509   function setIsPublicSaleActive(bool _isPublicSaleActive)
1510       external
1511       onlyOwner
1512   {
1513       isPublicSaleActive = _isPublicSaleActive;
1514   }
1515 
1516   function setNumFreeMints(uint256 _numfreemints)
1517       external
1518       onlyOwner
1519   {
1520       NUM_FREE_MINTS = _numfreemints;
1521   }
1522 
1523   function setSalePrice(uint256 _price)
1524       external
1525       onlyOwner
1526   {
1527       PUBLIC_SALE_PRICE = _price;
1528   }
1529 
1530   function setMaxLimitPerTransaction(uint256 _limit)
1531       external
1532       onlyOwner
1533   {
1534       MAX_MINTS_PER_TX = _limit;
1535   }
1536 
1537   function setFreeLimitPerWallet(uint256 _limit)
1538       external
1539       onlyOwner
1540   {
1541       MAX_FREE_PER_WALLET = _limit;
1542   }
1543 }