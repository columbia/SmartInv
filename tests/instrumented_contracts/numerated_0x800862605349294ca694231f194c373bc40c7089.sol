1 // SPDX-License-Identifier: MIT
2 
3 /***
4  *      ___  ____  _  _  ____  ____  __     ____  ____  __ _  ____  ____  __  ____ 
5  *     / __)(  _ \( \/ )(  _ \(_  _)/  \   / ___)(  __)(  ( \/ ___)(  __)(  )/ ___)
6  *    ( (__  )   / )  /  ) __/  )( (  O )  \___ \ ) _) /    /\___ \ ) _)  )( \___ \
7  *     \___)(__\_)(__/  (__)   (__) \__/   (____/(____)\_)__)(____/(____)(__)(____/
8  */
9 
10 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
11 
12 
13 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Contract module that helps prevent reentrant calls to a function.
19  *
20  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
21  * available, which can be applied to functions to make sure there are no nested
22  * (reentrant) calls to them.
23  *
24  * Note that because there is a single `nonReentrant` guard, functions marked as
25  * `nonReentrant` may not call one another. This can be worked around by making
26  * those functions `private`, and then adding `external` `nonReentrant` entry
27  * points to them.
28  *
29  * TIP: If you would like to learn more about reentrancy and alternative ways
30  * to protect against it, check out our blog post
31  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
32  */
33 abstract contract ReentrancyGuard {
34     // Booleans are more expensive than uint256 or any type that takes up a full
35     // word because each write operation emits an extra SLOAD to first read the
36     // slot's contents, replace the bits taken up by the boolean, and then write
37     // back. This is the compiler's defense against contract upgrades and
38     // pointer aliasing, and it cannot be disabled.
39 
40     // The values being non-zero value makes deployment a bit more expensive,
41     // but in exchange the refund on every call to nonReentrant will be lower in
42     // amount. Since refunds are capped to a percentage of the total
43     // transaction's gas, it is best to keep them low in cases like this one, to
44     // increase the likelihood of the full refund coming into effect.
45     uint256 private constant _NOT_ENTERED = 1;
46     uint256 private constant _ENTERED = 2;
47 
48     uint256 private _status;
49 
50     constructor() {
51         _status = _NOT_ENTERED;
52     }
53 
54     /**
55      * @dev Prevents a contract from calling itself, directly or indirectly.
56      * Calling a `nonReentrant` function from another `nonReentrant`
57      * function is not supported. It is possible to prevent this from happening
58      * by making the `nonReentrant` function external, and making it call a
59      * `private` function that does the actual work.
60      */
61     modifier nonReentrant() {
62         // On the first call to nonReentrant, _notEntered will be true
63         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
64 
65         // Any calls to nonReentrant after this point will fail
66         _status = _ENTERED;
67 
68         _;
69 
70         // By storing the original value once again, a refund is triggered (see
71         // https://eips.ethereum.org/EIPS/eip-2200)
72         _status = _NOT_ENTERED;
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Strings.sol
77 
78 
79 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev String operations.
85  */
86 library Strings {
87     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
88     uint8 private constant _ADDRESS_LENGTH = 20;
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
145 
146     /**
147      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
148      */
149     function toHexString(address addr) internal pure returns (string memory) {
150         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
151     }
152 }
153 
154 // File: @openzeppelin/contracts/utils/Context.sol
155 
156 
157 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 /**
162  * @dev Provides information about the current execution context, including the
163  * sender of the transaction and its data. While these are generally available
164  * via msg.sender and msg.data, they should not be accessed in such a direct
165  * manner, since when dealing with meta-transactions the account sending and
166  * paying for execution may not be the actual sender (as far as an application
167  * is concerned).
168  *
169  * This contract is only required for intermediate, library-like contracts.
170  */
171 abstract contract Context {
172     function _msgSender() internal view virtual returns (address) {
173         return msg.sender;
174     }
175 
176     function _msgData() internal view virtual returns (bytes calldata) {
177         return msg.data;
178     }
179 }
180 
181 // File: @openzeppelin/contracts/access/Ownable.sol
182 
183 
184 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 
189 /**
190  * @dev Contract module which provides a basic access control mechanism, where
191  * there is an account (an owner) that can be granted exclusive access to
192  * specific functions.
193  *
194  * By default, the owner account will be the one that deploys the contract. This
195  * can later be changed with {transferOwnership}.
196  *
197  * This module is used through inheritance. It will make available the modifier
198  * `onlyOwner`, which can be applied to your functions to restrict their use to
199  * the owner.
200  */
201 abstract contract Ownable is Context {
202     address private _owner;
203 
204     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
205 
206     /**
207      * @dev Initializes the contract setting the deployer as the initial owner.
208      */
209     constructor() {
210         _transferOwnership(_msgSender());
211     }
212 
213     /**
214      * @dev Throws if called by any account other than the owner.
215      */
216     modifier onlyOwner() {
217         _checkOwner();
218         _;
219     }
220 
221     /**
222      * @dev Returns the address of the current owner.
223      */
224     function owner() public view virtual returns (address) {
225         return _owner;
226     }
227 
228     /**
229      * @dev Throws if the sender is not the owner.
230      */
231     function _checkOwner() internal view virtual {
232         require(owner() == _msgSender(), "Ownable: caller is not the owner");
233     }
234 
235     /**
236      * @dev Leaves the contract without owner. It will not be possible to call
237      * `onlyOwner` functions anymore. Can only be called by the current owner.
238      *
239      * NOTE: Renouncing ownership will leave the contract without an owner,
240      * thereby removing any functionality that is only available to the owner.
241      */
242     function renounceOwnership() public virtual onlyOwner {
243         _transferOwnership(address(0));
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Can only be called by the current owner.
249      */
250     function transferOwnership(address newOwner) public virtual onlyOwner {
251         require(newOwner != address(0), "Ownable: new owner is the zero address");
252         _transferOwnership(newOwner);
253     }
254 
255     /**
256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
257      * Internal function without access restriction.
258      */
259     function _transferOwnership(address newOwner) internal virtual {
260         address oldOwner = _owner;
261         _owner = newOwner;
262         emit OwnershipTransferred(oldOwner, newOwner);
263     }
264 }
265 
266 // File: @openzeppelin/contracts/utils/Address.sol
267 
268 
269 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
270 
271 pragma solidity ^0.8.1;
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      *
294      * [IMPORTANT]
295      * ====
296      * You shouldn't rely on `isContract` to protect against flash loan attacks!
297      *
298      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
299      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
300      * constructor.
301      * ====
302      */
303     function isContract(address account) internal view returns (bool) {
304         // This method relies on extcodesize/address.code.length, which returns 0
305         // for contracts in construction, since the code is only stored at the end
306         // of the constructor execution.
307 
308         return account.code.length > 0;
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(address(this).balance >= amount, "Address: insufficient balance");
329 
330         (bool success, ) = recipient.call{value: amount}("");
331         require(success, "Address: unable to send value, recipient may have reverted");
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain `call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionCall(target, data, "Address: low-level call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
358      * `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         return functionCallWithValue(target, data, 0, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but also transferring `value` wei to `target`.
373      *
374      * Requirements:
375      *
376      * - the calling contract must have an ETH balance of at least `value`.
377      * - the called Solidity function must be `payable`.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(
382         address target,
383         bytes memory data,
384         uint256 value
385     ) internal returns (bytes memory) {
386         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
391      * with `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(
396         address target,
397         bytes memory data,
398         uint256 value,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         require(address(this).balance >= value, "Address: insufficient balance for call");
402         require(isContract(target), "Address: call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.call{value: value}(data);
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but performing a static call.
411      *
412      * _Available since v3.3._
413      */
414     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
415         return functionStaticCall(target, data, "Address: low-level static call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
420      * but performing a static call.
421      *
422      * _Available since v3.3._
423      */
424     function functionStaticCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal view returns (bytes memory) {
429         require(isContract(target), "Address: static call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.staticcall(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but performing a delegate call.
438      *
439      * _Available since v3.4._
440      */
441     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
442         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
447      * but performing a delegate call.
448      *
449      * _Available since v3.4._
450      */
451     function functionDelegateCall(
452         address target,
453         bytes memory data,
454         string memory errorMessage
455     ) internal returns (bytes memory) {
456         require(isContract(target), "Address: delegate call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.delegatecall(data);
459         return verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
464      * revert reason using the provided one.
465      *
466      * _Available since v4.3._
467      */
468     function verifyCallResult(
469         bool success,
470         bytes memory returndata,
471         string memory errorMessage
472     ) internal pure returns (bytes memory) {
473         if (success) {
474             return returndata;
475         } else {
476             // Look for revert reason and bubble it up if present
477             if (returndata.length > 0) {
478                 // The easiest way to bubble the revert reason is using memory via assembly
479                 /// @solidity memory-safe-assembly
480                 assembly {
481                     let returndata_size := mload(returndata)
482                     revert(add(32, returndata), returndata_size)
483                 }
484             } else {
485                 revert(errorMessage);
486             }
487         }
488     }
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
492 
493 
494 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @title ERC721 token receiver interface
500  * @dev Interface for any contract that wants to support safeTransfers
501  * from ERC721 asset contracts.
502  */
503 interface IERC721Receiver {
504     /**
505      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
506      * by `operator` from `from`, this function is called.
507      *
508      * It must return its Solidity selector to confirm the token transfer.
509      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
510      *
511      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
512      */
513     function onERC721Received(
514         address operator,
515         address from,
516         uint256 tokenId,
517         bytes calldata data
518     ) external returns (bytes4);
519 }
520 
521 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev Interface of the ERC165 standard, as defined in the
530  * https://eips.ethereum.org/EIPS/eip-165[EIP].
531  *
532  * Implementers can declare support of contract interfaces, which can then be
533  * queried by others ({ERC165Checker}).
534  *
535  * For an implementation, see {ERC165}.
536  */
537 interface IERC165 {
538     /**
539      * @dev Returns true if this contract implements the interface defined by
540      * `interfaceId`. See the corresponding
541      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
542      * to learn more about how these ids are created.
543      *
544      * This function call must use less than 30 000 gas.
545      */
546     function supportsInterface(bytes4 interfaceId) external view returns (bool);
547 }
548 
549 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
550 
551 
552 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 
557 /**
558  * @dev Implementation of the {IERC165} interface.
559  *
560  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
561  * for the additional interface id that will be supported. For example:
562  *
563  * ```solidity
564  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
565  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
566  * }
567  * ```
568  *
569  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
570  */
571 abstract contract ERC165 is IERC165 {
572     /**
573      * @dev See {IERC165-supportsInterface}.
574      */
575     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
576         return interfaceId == type(IERC165).interfaceId;
577     }
578 }
579 
580 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
581 
582 
583 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 /**
589  * @dev Required interface of an ERC721 compliant contract.
590  */
591 interface IERC721 is IERC165 {
592     /**
593      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
594      */
595     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
596 
597     /**
598      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
599      */
600     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
601 
602     /**
603      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
604      */
605     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
606 
607     /**
608      * @dev Returns the number of tokens in ``owner``'s account.
609      */
610     function balanceOf(address owner) external view returns (uint256 balance);
611 
612     /**
613      * @dev Returns the owner of the `tokenId` token.
614      *
615      * Requirements:
616      *
617      * - `tokenId` must exist.
618      */
619     function ownerOf(uint256 tokenId) external view returns (address owner);
620 
621     /**
622      * @dev Safely transfers `tokenId` token from `from` to `to`.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must exist and be owned by `from`.
629      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
630      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
631      *
632      * Emits a {Transfer} event.
633      */
634     function safeTransferFrom(
635         address from,
636         address to,
637         uint256 tokenId,
638         bytes calldata data
639     ) external;
640 
641     /**
642      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
643      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
644      *
645      * Requirements:
646      *
647      * - `from` cannot be the zero address.
648      * - `to` cannot be the zero address.
649      * - `tokenId` token must exist and be owned by `from`.
650      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
651      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
652      *
653      * Emits a {Transfer} event.
654      */
655     function safeTransferFrom(
656         address from,
657         address to,
658         uint256 tokenId
659     ) external;
660 
661     /**
662      * @dev Transfers `tokenId` token from `from` to `to`.
663      *
664      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `tokenId` token must be owned by `from`.
671      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
672      *
673      * Emits a {Transfer} event.
674      */
675     function transferFrom(
676         address from,
677         address to,
678         uint256 tokenId
679     ) external;
680 
681     /**
682      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
683      * The approval is cleared when the token is transferred.
684      *
685      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
686      *
687      * Requirements:
688      *
689      * - The caller must own the token or be an approved operator.
690      * - `tokenId` must exist.
691      *
692      * Emits an {Approval} event.
693      */
694     function approve(address to, uint256 tokenId) external;
695 
696     /**
697      * @dev Approve or remove `operator` as an operator for the caller.
698      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
699      *
700      * Requirements:
701      *
702      * - The `operator` cannot be the caller.
703      *
704      * Emits an {ApprovalForAll} event.
705      */
706     function setApprovalForAll(address operator, bool _approved) external;
707 
708     /**
709      * @dev Returns the account approved for `tokenId` token.
710      *
711      * Requirements:
712      *
713      * - `tokenId` must exist.
714      */
715     function getApproved(uint256 tokenId) external view returns (address operator);
716 
717     /**
718      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
719      *
720      * See {setApprovalForAll}
721      */
722     function isApprovedForAll(address owner, address operator) external view returns (bool);
723 }
724 
725 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
726 
727 
728 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
729 
730 pragma solidity ^0.8.0;
731 
732 
733 /**
734  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
735  * @dev See https://eips.ethereum.org/EIPS/eip-721
736  */
737 interface IERC721Metadata is IERC721 {
738     /**
739      * @dev Returns the token collection name.
740      */
741     function name() external view returns (string memory);
742 
743     /**
744      * @dev Returns the token collection symbol.
745      */
746     function symbol() external view returns (string memory);
747 
748     /**
749      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
750      */
751     function tokenURI(uint256 tokenId) external view returns (string memory);
752 }
753 
754 // File: erc721a/contracts/IERC721A.sol
755 
756 
757 // ERC721A Contracts v4.2.3
758 // Creator: Chiru Labs
759 
760 pragma solidity ^0.8.4;
761 
762 /**
763  * @dev Interface of ERC721A.
764  */
765 interface IERC721A {
766     /**
767      * The caller must own the token or be an approved operator.
768      */
769     error ApprovalCallerNotOwnerNorApproved();
770 
771     /**
772      * The token does not exist.
773      */
774     error ApprovalQueryForNonexistentToken();
775 
776     /**
777      * Cannot query the balance for the zero address.
778      */
779     error BalanceQueryForZeroAddress();
780 
781     /**
782      * Cannot mint to the zero address.
783      */
784     error MintToZeroAddress();
785 
786     /**
787      * The quantity of tokens minted must be more than zero.
788      */
789     error MintZeroQuantity();
790 
791     /**
792      * The token does not exist.
793      */
794     error OwnerQueryForNonexistentToken();
795 
796     /**
797      * The caller must own the token or be an approved operator.
798      */
799     error TransferCallerNotOwnerNorApproved();
800 
801     /**
802      * The token must be owned by `from`.
803      */
804     error TransferFromIncorrectOwner();
805 
806     /**
807      * Cannot safely transfer to a contract that does not implement the
808      * ERC721Receiver interface.
809      */
810     error TransferToNonERC721ReceiverImplementer();
811 
812     /**
813      * Cannot transfer to the zero address.
814      */
815     error TransferToZeroAddress();
816 
817     /**
818      * The token does not exist.
819      */
820     error URIQueryForNonexistentToken();
821 
822     /**
823      * The `quantity` minted with ERC2309 exceeds the safety limit.
824      */
825     error MintERC2309QuantityExceedsLimit();
826 
827     /**
828      * The `extraData` cannot be set on an unintialized ownership slot.
829      */
830     error OwnershipNotInitializedForExtraData();
831 
832     // =============================================================
833     //                            STRUCTS
834     // =============================================================
835 
836     struct TokenOwnership {
837         // The address of the owner.
838         address addr;
839         // Stores the start time of ownership with minimal overhead for tokenomics.
840         uint64 startTimestamp;
841         // Whether the token has been burned.
842         bool burned;
843         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
844         uint24 extraData;
845     }
846 
847     // =============================================================
848     //                         TOKEN COUNTERS
849     // =============================================================
850 
851     /**
852      * @dev Returns the total number of tokens in existence.
853      * Burned tokens will reduce the count.
854      * To get the total number of tokens minted, please see {_totalMinted}.
855      */
856     function totalSupply() external view returns (uint256);
857 
858     // =============================================================
859     //                            IERC165
860     // =============================================================
861 
862     /**
863      * @dev Returns true if this contract implements the interface defined by
864      * `interfaceId`. See the corresponding
865      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
866      * to learn more about how these ids are created.
867      *
868      * This function call must use less than 30000 gas.
869      */
870     function supportsInterface(bytes4 interfaceId) external view returns (bool);
871 
872     // =============================================================
873     //                            IERC721
874     // =============================================================
875 
876     /**
877      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
878      */
879     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
880 
881     /**
882      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
883      */
884     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
885 
886     /**
887      * @dev Emitted when `owner` enables or disables
888      * (`approved`) `operator` to manage all of its assets.
889      */
890     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
891 
892     /**
893      * @dev Returns the number of tokens in `owner`'s account.
894      */
895     function balanceOf(address owner) external view returns (uint256 balance);
896 
897     /**
898      * @dev Returns the owner of the `tokenId` token.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must exist.
903      */
904     function ownerOf(uint256 tokenId) external view returns (address owner);
905 
906     /**
907      * @dev Safely transfers `tokenId` token from `from` to `to`,
908      * checking first that contract recipients are aware of the ERC721 protocol
909      * to prevent tokens from being forever locked.
910      *
911      * Requirements:
912      *
913      * - `from` cannot be the zero address.
914      * - `to` cannot be the zero address.
915      * - `tokenId` token must exist and be owned by `from`.
916      * - If the caller is not `from`, it must be have been allowed to move
917      * this token by either {approve} or {setApprovalForAll}.
918      * - If `to` refers to a smart contract, it must implement
919      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
920      *
921      * Emits a {Transfer} event.
922      */
923     function safeTransferFrom(
924         address from,
925         address to,
926         uint256 tokenId,
927         bytes calldata data
928     ) external payable;
929 
930     /**
931      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId
937     ) external payable;
938 
939     /**
940      * @dev Transfers `tokenId` from `from` to `to`.
941      *
942      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
943      * whenever possible.
944      *
945      * Requirements:
946      *
947      * - `from` cannot be the zero address.
948      * - `to` cannot be the zero address.
949      * - `tokenId` token must be owned by `from`.
950      * - If the caller is not `from`, it must be approved to move this token
951      * by either {approve} or {setApprovalForAll}.
952      *
953      * Emits a {Transfer} event.
954      */
955     function transferFrom(
956         address from,
957         address to,
958         uint256 tokenId
959     ) external payable;
960 
961     /**
962      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
963      * The approval is cleared when the token is transferred.
964      *
965      * Only a single account can be approved at a time, so approving the
966      * zero address clears previous approvals.
967      *
968      * Requirements:
969      *
970      * - The caller must own the token or be an approved operator.
971      * - `tokenId` must exist.
972      *
973      * Emits an {Approval} event.
974      */
975     function approve(address to, uint256 tokenId) external payable;
976 
977     /**
978      * @dev Approve or remove `operator` as an operator for the caller.
979      * Operators can call {transferFrom} or {safeTransferFrom}
980      * for any token owned by the caller.
981      *
982      * Requirements:
983      *
984      * - The `operator` cannot be the caller.
985      *
986      * Emits an {ApprovalForAll} event.
987      */
988     function setApprovalForAll(address operator, bool _approved) external;
989 
990     /**
991      * @dev Returns the account approved for `tokenId` token.
992      *
993      * Requirements:
994      *
995      * - `tokenId` must exist.
996      */
997     function getApproved(uint256 tokenId) external view returns (address operator);
998 
999     /**
1000      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1001      *
1002      * See {setApprovalForAll}.
1003      */
1004     function isApprovedForAll(address owner, address operator) external view returns (bool);
1005 
1006     // =============================================================
1007     //                        IERC721Metadata
1008     // =============================================================
1009 
1010     /**
1011      * @dev Returns the token collection name.
1012      */
1013     function name() external view returns (string memory);
1014 
1015     /**
1016      * @dev Returns the token collection symbol.
1017      */
1018     function symbol() external view returns (string memory);
1019 
1020     /**
1021      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1022      */
1023     function tokenURI(uint256 tokenId) external view returns (string memory);
1024 
1025     // =============================================================
1026     //                           IERC2309
1027     // =============================================================
1028 
1029     /**
1030      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1031      * (inclusive) is transferred from `from` to `to`, as defined in the
1032      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1033      *
1034      * See {_mintERC2309} for more details.
1035      */
1036     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1037 }
1038 
1039 // File: erc721a/contracts/ERC721A.sol
1040 
1041 
1042 // ERC721A Contracts v4.2.3
1043 // Creator: Chiru Labs
1044 
1045 pragma solidity ^0.8.4;
1046 
1047 
1048 /**
1049  * @dev Interface of ERC721 token receiver.
1050  */
1051 interface ERC721A__IERC721Receiver {
1052     function onERC721Received(
1053         address operator,
1054         address from,
1055         uint256 tokenId,
1056         bytes calldata data
1057     ) external returns (bytes4);
1058 }
1059 
1060 /**
1061  * @title ERC721A
1062  *
1063  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1064  * Non-Fungible Token Standard, including the Metadata extension.
1065  * Optimized for lower gas during batch mints.
1066  *
1067  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1068  * starting from `_startTokenId()`.
1069  *
1070  * Assumptions:
1071  *
1072  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1073  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1074  */
1075 contract ERC721A is IERC721A {
1076     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1077     struct TokenApprovalRef {
1078         address value;
1079     }
1080 
1081     // =============================================================
1082     //                           CONSTANTS
1083     // =============================================================
1084 
1085     // Mask of an entry in packed address data.
1086     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1087 
1088     // The bit position of `numberMinted` in packed address data.
1089     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1090 
1091     // The bit position of `numberBurned` in packed address data.
1092     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1093 
1094     // The bit position of `aux` in packed address data.
1095     uint256 private constant _BITPOS_AUX = 192;
1096 
1097     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1098     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1099 
1100     // The bit position of `startTimestamp` in packed ownership.
1101     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1102 
1103     // The bit mask of the `burned` bit in packed ownership.
1104     uint256 private constant _BITMASK_BURNED = 1 << 224;
1105 
1106     // The bit position of the `nextInitialized` bit in packed ownership.
1107     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1108 
1109     // The bit mask of the `nextInitialized` bit in packed ownership.
1110     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1111 
1112     // The bit position of `extraData` in packed ownership.
1113     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1114 
1115     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1116     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1117 
1118     // The mask of the lower 160 bits for addresses.
1119     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1120 
1121     // The maximum `quantity` that can be minted with {_mintERC2309}.
1122     // This limit is to prevent overflows on the address data entries.
1123     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1124     // is required to cause an overflow, which is unrealistic.
1125     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1126 
1127     // The `Transfer` event signature is given by:
1128     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1129     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1130         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1131 
1132     // =============================================================
1133     //                            STORAGE
1134     // =============================================================
1135 
1136     // The next token ID to be minted.
1137     uint256 private _currentIndex;
1138 
1139     // The number of tokens burned.
1140     uint256 private _burnCounter;
1141 
1142     // Token name
1143     string private _name;
1144 
1145     // Token symbol
1146     string private _symbol;
1147 
1148     // Mapping from token ID to ownership details
1149     // An empty struct value does not necessarily mean the token is unowned.
1150     // See {_packedOwnershipOf} implementation for details.
1151     //
1152     // Bits Layout:
1153     // - [0..159]   `addr`
1154     // - [160..223] `startTimestamp`
1155     // - [224]      `burned`
1156     // - [225]      `nextInitialized`
1157     // - [232..255] `extraData`
1158     mapping(uint256 => uint256) private _packedOwnerships;
1159 
1160     // Mapping owner address to address data.
1161     //
1162     // Bits Layout:
1163     // - [0..63]    `balance`
1164     // - [64..127]  `numberMinted`
1165     // - [128..191] `numberBurned`
1166     // - [192..255] `aux`
1167     mapping(address => uint256) private _packedAddressData;
1168 
1169     // Mapping from token ID to approved address.
1170     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1171 
1172     // Mapping from owner to operator approvals
1173     mapping(address => mapping(address => bool)) private _operatorApprovals;
1174 
1175     // =============================================================
1176     //                          CONSTRUCTOR
1177     // =============================================================
1178 
1179     constructor(string memory name_, string memory symbol_) {
1180         _name = name_;
1181         _symbol = symbol_;
1182         _currentIndex = _startTokenId();
1183     }
1184 
1185     // =============================================================
1186     //                   TOKEN COUNTING OPERATIONS
1187     // =============================================================
1188 
1189     /**
1190      * @dev Returns the starting token ID.
1191      * To change the starting token ID, please override this function.
1192      */
1193     function _startTokenId() internal view virtual returns (uint256) {
1194         return 0;
1195     }
1196 
1197     /**
1198      * @dev Returns the next token ID to be minted.
1199      */
1200     function _nextTokenId() internal view virtual returns (uint256) {
1201         return _currentIndex;
1202     }
1203 
1204     /**
1205      * @dev Returns the total number of tokens in existence.
1206      * Burned tokens will reduce the count.
1207      * To get the total number of tokens minted, please see {_totalMinted}.
1208      */
1209     function totalSupply() public view virtual override returns (uint256) {
1210         // Counter underflow is impossible as _burnCounter cannot be incremented
1211         // more than `_currentIndex - _startTokenId()` times.
1212         unchecked {
1213             return _currentIndex - _burnCounter - _startTokenId();
1214         }
1215     }
1216 
1217     /**
1218      * @dev Returns the total amount of tokens minted in the contract.
1219      */
1220     function _totalMinted() internal view virtual returns (uint256) {
1221         // Counter underflow is impossible as `_currentIndex` does not decrement,
1222         // and it is initialized to `_startTokenId()`.
1223         unchecked {
1224             return _currentIndex - _startTokenId();
1225         }
1226     }
1227 
1228     /**
1229      * @dev Returns the total number of tokens burned.
1230      */
1231     function _totalBurned() internal view virtual returns (uint256) {
1232         return _burnCounter;
1233     }
1234 
1235     // =============================================================
1236     //                    ADDRESS DATA OPERATIONS
1237     // =============================================================
1238 
1239     /**
1240      * @dev Returns the number of tokens in `owner`'s account.
1241      */
1242     function balanceOf(address owner) public view virtual override returns (uint256) {
1243         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1244         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1245     }
1246 
1247     /**
1248      * Returns the number of tokens minted by `owner`.
1249      */
1250     function _numberMinted(address owner) internal view returns (uint256) {
1251         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1252     }
1253 
1254     /**
1255      * Returns the number of tokens burned by or on behalf of `owner`.
1256      */
1257     function _numberBurned(address owner) internal view returns (uint256) {
1258         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1259     }
1260 
1261     /**
1262      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1263      */
1264     function _getAux(address owner) internal view returns (uint64) {
1265         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1266     }
1267 
1268     /**
1269      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1270      * If there are multiple variables, please pack them into a uint64.
1271      */
1272     function _setAux(address owner, uint64 aux) internal virtual {
1273         uint256 packed = _packedAddressData[owner];
1274         uint256 auxCasted;
1275         // Cast `aux` with assembly to avoid redundant masking.
1276         assembly {
1277             auxCasted := aux
1278         }
1279         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1280         _packedAddressData[owner] = packed;
1281     }
1282 
1283     // =============================================================
1284     //                            IERC165
1285     // =============================================================
1286 
1287     /**
1288      * @dev Returns true if this contract implements the interface defined by
1289      * `interfaceId`. See the corresponding
1290      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1291      * to learn more about how these ids are created.
1292      *
1293      * This function call must use less than 30000 gas.
1294      */
1295     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1296         // The interface IDs are constants representing the first 4 bytes
1297         // of the XOR of all function selectors in the interface.
1298         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1299         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1300         return
1301             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1302             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1303             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1304     }
1305 
1306     // =============================================================
1307     //                        IERC721Metadata
1308     // =============================================================
1309 
1310     /**
1311      * @dev Returns the token collection name.
1312      */
1313     function name() public view virtual override returns (string memory) {
1314         return _name;
1315     }
1316 
1317     /**
1318      * @dev Returns the token collection symbol.
1319      */
1320     function symbol() public view virtual override returns (string memory) {
1321         return _symbol;
1322     }
1323 
1324     /**
1325      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1326      */
1327     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1328         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1329 
1330         string memory baseURI = _baseURI();
1331         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1332     }
1333 
1334     /**
1335      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1336      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1337      * by default, it can be overridden in child contracts.
1338      */
1339     function _baseURI() internal view virtual returns (string memory) {
1340         return '';
1341     }
1342 
1343     // =============================================================
1344     //                     OWNERSHIPS OPERATIONS
1345     // =============================================================
1346 
1347     /**
1348      * @dev Returns the owner of the `tokenId` token.
1349      *
1350      * Requirements:
1351      *
1352      * - `tokenId` must exist.
1353      */
1354     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1355         return address(uint160(_packedOwnershipOf(tokenId)));
1356     }
1357 
1358     /**
1359      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1360      * It gradually moves to O(1) as tokens get transferred around over time.
1361      */
1362     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1363         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1364     }
1365 
1366     /**
1367      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1368      */
1369     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1370         return _unpackedOwnership(_packedOwnerships[index]);
1371     }
1372 
1373     /**
1374      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1375      */
1376     function _initializeOwnershipAt(uint256 index) internal virtual {
1377         if (_packedOwnerships[index] == 0) {
1378             _packedOwnerships[index] = _packedOwnershipOf(index);
1379         }
1380     }
1381 
1382     /**
1383      * Returns the packed ownership data of `tokenId`.
1384      */
1385     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1386         uint256 curr = tokenId;
1387 
1388         unchecked {
1389             if (_startTokenId() <= curr)
1390                 if (curr < _currentIndex) {
1391                     uint256 packed = _packedOwnerships[curr];
1392                     // If not burned.
1393                     if (packed & _BITMASK_BURNED == 0) {
1394                         // Invariant:
1395                         // There will always be an initialized ownership slot
1396                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1397                         // before an unintialized ownership slot
1398                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1399                         // Hence, `curr` will not underflow.
1400                         //
1401                         // We can directly compare the packed value.
1402                         // If the address is zero, packed will be zero.
1403                         while (packed == 0) {
1404                             packed = _packedOwnerships[--curr];
1405                         }
1406                         return packed;
1407                     }
1408                 }
1409         }
1410         revert OwnerQueryForNonexistentToken();
1411     }
1412 
1413     /**
1414      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1415      */
1416     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1417         ownership.addr = address(uint160(packed));
1418         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1419         ownership.burned = packed & _BITMASK_BURNED != 0;
1420         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1421     }
1422 
1423     /**
1424      * @dev Packs ownership data into a single uint256.
1425      */
1426     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1427         assembly {
1428             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1429             owner := and(owner, _BITMASK_ADDRESS)
1430             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1431             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1432         }
1433     }
1434 
1435     /**
1436      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1437      */
1438     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1439         // For branchless setting of the `nextInitialized` flag.
1440         assembly {
1441             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1442             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1443         }
1444     }
1445 
1446     // =============================================================
1447     //                      APPROVAL OPERATIONS
1448     // =============================================================
1449 
1450     /**
1451      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1452      * The approval is cleared when the token is transferred.
1453      *
1454      * Only a single account can be approved at a time, so approving the
1455      * zero address clears previous approvals.
1456      *
1457      * Requirements:
1458      *
1459      * - The caller must own the token or be an approved operator.
1460      * - `tokenId` must exist.
1461      *
1462      * Emits an {Approval} event.
1463      */
1464     function approve(address to, uint256 tokenId) public payable virtual override {
1465         address owner = ownerOf(tokenId);
1466 
1467         if (_msgSenderERC721A() != owner)
1468             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1469                 revert ApprovalCallerNotOwnerNorApproved();
1470             }
1471 
1472         _tokenApprovals[tokenId].value = to;
1473         emit Approval(owner, to, tokenId);
1474     }
1475 
1476     /**
1477      * @dev Returns the account approved for `tokenId` token.
1478      *
1479      * Requirements:
1480      *
1481      * - `tokenId` must exist.
1482      */
1483     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1484         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1485 
1486         return _tokenApprovals[tokenId].value;
1487     }
1488 
1489     /**
1490      * @dev Approve or remove `operator` as an operator for the caller.
1491      * Operators can call {transferFrom} or {safeTransferFrom}
1492      * for any token owned by the caller.
1493      *
1494      * Requirements:
1495      *
1496      * - The `operator` cannot be the caller.
1497      *
1498      * Emits an {ApprovalForAll} event.
1499      */
1500     function setApprovalForAll(address operator, bool approved) public virtual override {
1501         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1502         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1503     }
1504 
1505     /**
1506      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1507      *
1508      * See {setApprovalForAll}.
1509      */
1510     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1511         return _operatorApprovals[owner][operator];
1512     }
1513 
1514     /**
1515      * @dev Returns whether `tokenId` exists.
1516      *
1517      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1518      *
1519      * Tokens start existing when they are minted. See {_mint}.
1520      */
1521     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1522         return
1523             _startTokenId() <= tokenId &&
1524             tokenId < _currentIndex && // If within bounds,
1525             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1526     }
1527 
1528     /**
1529      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1530      */
1531     function _isSenderApprovedOrOwner(
1532         address approvedAddress,
1533         address owner,
1534         address msgSender
1535     ) private pure returns (bool result) {
1536         assembly {
1537             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1538             owner := and(owner, _BITMASK_ADDRESS)
1539             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1540             msgSender := and(msgSender, _BITMASK_ADDRESS)
1541             // `msgSender == owner || msgSender == approvedAddress`.
1542             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1543         }
1544     }
1545 
1546     /**
1547      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1548      */
1549     function _getApprovedSlotAndAddress(uint256 tokenId)
1550         private
1551         view
1552         returns (uint256 approvedAddressSlot, address approvedAddress)
1553     {
1554         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1555         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1556         assembly {
1557             approvedAddressSlot := tokenApproval.slot
1558             approvedAddress := sload(approvedAddressSlot)
1559         }
1560     }
1561 
1562     // =============================================================
1563     //                      TRANSFER OPERATIONS
1564     // =============================================================
1565 
1566     /**
1567      * @dev Transfers `tokenId` from `from` to `to`.
1568      *
1569      * Requirements:
1570      *
1571      * - `from` cannot be the zero address.
1572      * - `to` cannot be the zero address.
1573      * - `tokenId` token must be owned by `from`.
1574      * - If the caller is not `from`, it must be approved to move this token
1575      * by either {approve} or {setApprovalForAll}.
1576      *
1577      * Emits a {Transfer} event.
1578      */
1579     function transferFrom(
1580         address from,
1581         address to,
1582         uint256 tokenId
1583     ) public payable virtual override {
1584         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1585 
1586         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1587 
1588         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1589 
1590         // The nested ifs save around 20+ gas over a compound boolean condition.
1591         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1592             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1593 
1594         if (to == address(0)) revert TransferToZeroAddress();
1595 
1596         _beforeTokenTransfers(from, to, tokenId, 1);
1597 
1598         // Clear approvals from the previous owner.
1599         assembly {
1600             if approvedAddress {
1601                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1602                 sstore(approvedAddressSlot, 0)
1603             }
1604         }
1605 
1606         // Underflow of the sender's balance is impossible because we check for
1607         // ownership above and the recipient's balance can't realistically overflow.
1608         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1609         unchecked {
1610             // We can directly increment and decrement the balances.
1611             --_packedAddressData[from]; // Updates: `balance -= 1`.
1612             ++_packedAddressData[to]; // Updates: `balance += 1`.
1613 
1614             // Updates:
1615             // - `address` to the next owner.
1616             // - `startTimestamp` to the timestamp of transfering.
1617             // - `burned` to `false`.
1618             // - `nextInitialized` to `true`.
1619             _packedOwnerships[tokenId] = _packOwnershipData(
1620                 to,
1621                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1622             );
1623 
1624             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1625             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1626                 uint256 nextTokenId = tokenId + 1;
1627                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1628                 if (_packedOwnerships[nextTokenId] == 0) {
1629                     // If the next slot is within bounds.
1630                     if (nextTokenId != _currentIndex) {
1631                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1632                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1633                     }
1634                 }
1635             }
1636         }
1637 
1638         emit Transfer(from, to, tokenId);
1639         _afterTokenTransfers(from, to, tokenId, 1);
1640     }
1641 
1642     /**
1643      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1644      */
1645     function safeTransferFrom(
1646         address from,
1647         address to,
1648         uint256 tokenId
1649     ) public payable virtual override {
1650         safeTransferFrom(from, to, tokenId, '');
1651     }
1652 
1653     /**
1654      * @dev Safely transfers `tokenId` token from `from` to `to`.
1655      *
1656      * Requirements:
1657      *
1658      * - `from` cannot be the zero address.
1659      * - `to` cannot be the zero address.
1660      * - `tokenId` token must exist and be owned by `from`.
1661      * - If the caller is not `from`, it must be approved to move this token
1662      * by either {approve} or {setApprovalForAll}.
1663      * - If `to` refers to a smart contract, it must implement
1664      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1665      *
1666      * Emits a {Transfer} event.
1667      */
1668     function safeTransferFrom(
1669         address from,
1670         address to,
1671         uint256 tokenId,
1672         bytes memory _data
1673     ) public payable virtual override {
1674         transferFrom(from, to, tokenId);
1675         if (to.code.length != 0)
1676             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1677                 revert TransferToNonERC721ReceiverImplementer();
1678             }
1679     }
1680 
1681     /**
1682      * @dev Hook that is called before a set of serially-ordered token IDs
1683      * are about to be transferred. This includes minting.
1684      * And also called before burning one token.
1685      *
1686      * `startTokenId` - the first token ID to be transferred.
1687      * `quantity` - the amount to be transferred.
1688      *
1689      * Calling conditions:
1690      *
1691      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1692      * transferred to `to`.
1693      * - When `from` is zero, `tokenId` will be minted for `to`.
1694      * - When `to` is zero, `tokenId` will be burned by `from`.
1695      * - `from` and `to` are never both zero.
1696      */
1697     function _beforeTokenTransfers(
1698         address from,
1699         address to,
1700         uint256 startTokenId,
1701         uint256 quantity
1702     ) internal virtual {}
1703 
1704     /**
1705      * @dev Hook that is called after a set of serially-ordered token IDs
1706      * have been transferred. This includes minting.
1707      * And also called after one token has been burned.
1708      *
1709      * `startTokenId` - the first token ID to be transferred.
1710      * `quantity` - the amount to be transferred.
1711      *
1712      * Calling conditions:
1713      *
1714      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1715      * transferred to `to`.
1716      * - When `from` is zero, `tokenId` has been minted for `to`.
1717      * - When `to` is zero, `tokenId` has been burned by `from`.
1718      * - `from` and `to` are never both zero.
1719      */
1720     function _afterTokenTransfers(
1721         address from,
1722         address to,
1723         uint256 startTokenId,
1724         uint256 quantity
1725     ) internal virtual {}
1726 
1727     /**
1728      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1729      *
1730      * `from` - Previous owner of the given token ID.
1731      * `to` - Target address that will receive the token.
1732      * `tokenId` - Token ID to be transferred.
1733      * `_data` - Optional data to send along with the call.
1734      *
1735      * Returns whether the call correctly returned the expected magic value.
1736      */
1737     function _checkContractOnERC721Received(
1738         address from,
1739         address to,
1740         uint256 tokenId,
1741         bytes memory _data
1742     ) private returns (bool) {
1743         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1744             bytes4 retval
1745         ) {
1746             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1747         } catch (bytes memory reason) {
1748             if (reason.length == 0) {
1749                 revert TransferToNonERC721ReceiverImplementer();
1750             } else {
1751                 assembly {
1752                     revert(add(32, reason), mload(reason))
1753                 }
1754             }
1755         }
1756     }
1757 
1758     // =============================================================
1759     //                        MINT OPERATIONS
1760     // =============================================================
1761 
1762     /**
1763      * @dev Mints `quantity` tokens and transfers them to `to`.
1764      *
1765      * Requirements:
1766      *
1767      * - `to` cannot be the zero address.
1768      * - `quantity` must be greater than 0.
1769      *
1770      * Emits a {Transfer} event for each mint.
1771      */
1772     function _mint(address to, uint256 quantity) internal virtual {
1773         uint256 startTokenId = _currentIndex;
1774         if (quantity == 0) revert MintZeroQuantity();
1775 
1776         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1777 
1778         // Overflows are incredibly unrealistic.
1779         // `balance` and `numberMinted` have a maximum limit of 2**64.
1780         // `tokenId` has a maximum limit of 2**256.
1781         unchecked {
1782             // Updates:
1783             // - `balance += quantity`.
1784             // - `numberMinted += quantity`.
1785             //
1786             // We can directly add to the `balance` and `numberMinted`.
1787             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1788 
1789             // Updates:
1790             // - `address` to the owner.
1791             // - `startTimestamp` to the timestamp of minting.
1792             // - `burned` to `false`.
1793             // - `nextInitialized` to `quantity == 1`.
1794             _packedOwnerships[startTokenId] = _packOwnershipData(
1795                 to,
1796                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1797             );
1798 
1799             uint256 toMasked;
1800             uint256 end = startTokenId + quantity;
1801 
1802             // Use assembly to loop and emit the `Transfer` event for gas savings.
1803             // The duplicated `log4` removes an extra check and reduces stack juggling.
1804             // The assembly, together with the surrounding Solidity code, have been
1805             // delicately arranged to nudge the compiler into producing optimized opcodes.
1806             assembly {
1807                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1808                 toMasked := and(to, _BITMASK_ADDRESS)
1809                 // Emit the `Transfer` event.
1810                 log4(
1811                     0, // Start of data (0, since no data).
1812                     0, // End of data (0, since no data).
1813                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1814                     0, // `address(0)`.
1815                     toMasked, // `to`.
1816                     startTokenId // `tokenId`.
1817                 )
1818 
1819                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1820                 // that overflows uint256 will make the loop run out of gas.
1821                 // The compiler will optimize the `iszero` away for performance.
1822                 for {
1823                     let tokenId := add(startTokenId, 1)
1824                 } iszero(eq(tokenId, end)) {
1825                     tokenId := add(tokenId, 1)
1826                 } {
1827                     // Emit the `Transfer` event. Similar to above.
1828                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1829                 }
1830             }
1831             if (toMasked == 0) revert MintToZeroAddress();
1832 
1833             _currentIndex = end;
1834         }
1835         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1836     }
1837 
1838     /**
1839      * @dev Mints `quantity` tokens and transfers them to `to`.
1840      *
1841      * This function is intended for efficient minting only during contract creation.
1842      *
1843      * It emits only one {ConsecutiveTransfer} as defined in
1844      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1845      * instead of a sequence of {Transfer} event(s).
1846      *
1847      * Calling this function outside of contract creation WILL make your contract
1848      * non-compliant with the ERC721 standard.
1849      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1850      * {ConsecutiveTransfer} event is only permissible during contract creation.
1851      *
1852      * Requirements:
1853      *
1854      * - `to` cannot be the zero address.
1855      * - `quantity` must be greater than 0.
1856      *
1857      * Emits a {ConsecutiveTransfer} event.
1858      */
1859     function _mintERC2309(address to, uint256 quantity) internal virtual {
1860         uint256 startTokenId = _currentIndex;
1861         if (to == address(0)) revert MintToZeroAddress();
1862         if (quantity == 0) revert MintZeroQuantity();
1863         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1864 
1865         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1866 
1867         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1868         unchecked {
1869             // Updates:
1870             // - `balance += quantity`.
1871             // - `numberMinted += quantity`.
1872             //
1873             // We can directly add to the `balance` and `numberMinted`.
1874             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1875 
1876             // Updates:
1877             // - `address` to the owner.
1878             // - `startTimestamp` to the timestamp of minting.
1879             // - `burned` to `false`.
1880             // - `nextInitialized` to `quantity == 1`.
1881             _packedOwnerships[startTokenId] = _packOwnershipData(
1882                 to,
1883                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1884             );
1885 
1886             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1887 
1888             _currentIndex = startTokenId + quantity;
1889         }
1890         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1891     }
1892 
1893     /**
1894      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1895      *
1896      * Requirements:
1897      *
1898      * - If `to` refers to a smart contract, it must implement
1899      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1900      * - `quantity` must be greater than 0.
1901      *
1902      * See {_mint}.
1903      *
1904      * Emits a {Transfer} event for each mint.
1905      */
1906     function _safeMint(
1907         address to,
1908         uint256 quantity,
1909         bytes memory _data
1910     ) internal virtual {
1911         _mint(to, quantity);
1912 
1913         unchecked {
1914             if (to.code.length != 0) {
1915                 uint256 end = _currentIndex;
1916                 uint256 index = end - quantity;
1917                 do {
1918                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1919                         revert TransferToNonERC721ReceiverImplementer();
1920                     }
1921                 } while (index < end);
1922                 // Reentrancy protection.
1923                 if (_currentIndex != end) revert();
1924             }
1925         }
1926     }
1927 
1928     /**
1929      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1930      */
1931     function _safeMint(address to, uint256 quantity) internal virtual {
1932         _safeMint(to, quantity, '');
1933     }
1934 
1935     // =============================================================
1936     //                        BURN OPERATIONS
1937     // =============================================================
1938 
1939     /**
1940      * @dev Equivalent to `_burn(tokenId, false)`.
1941      */
1942     function _burn(uint256 tokenId) internal virtual {
1943         _burn(tokenId, false);
1944     }
1945 
1946     /**
1947      * @dev Destroys `tokenId`.
1948      * The approval is cleared when the token is burned.
1949      *
1950      * Requirements:
1951      *
1952      * - `tokenId` must exist.
1953      *
1954      * Emits a {Transfer} event.
1955      */
1956     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1957         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1958 
1959         address from = address(uint160(prevOwnershipPacked));
1960 
1961         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1962 
1963         if (approvalCheck) {
1964             // The nested ifs save around 20+ gas over a compound boolean condition.
1965             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1966                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1967         }
1968 
1969         _beforeTokenTransfers(from, address(0), tokenId, 1);
1970 
1971         // Clear approvals from the previous owner.
1972         assembly {
1973             if approvedAddress {
1974                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1975                 sstore(approvedAddressSlot, 0)
1976             }
1977         }
1978 
1979         // Underflow of the sender's balance is impossible because we check for
1980         // ownership above and the recipient's balance can't realistically overflow.
1981         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1982         unchecked {
1983             // Updates:
1984             // - `balance -= 1`.
1985             // - `numberBurned += 1`.
1986             //
1987             // We can directly decrement the balance, and increment the number burned.
1988             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1989             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1990 
1991             // Updates:
1992             // - `address` to the last owner.
1993             // - `startTimestamp` to the timestamp of burning.
1994             // - `burned` to `true`.
1995             // - `nextInitialized` to `true`.
1996             _packedOwnerships[tokenId] = _packOwnershipData(
1997                 from,
1998                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1999             );
2000 
2001             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2002             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2003                 uint256 nextTokenId = tokenId + 1;
2004                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2005                 if (_packedOwnerships[nextTokenId] == 0) {
2006                     // If the next slot is within bounds.
2007                     if (nextTokenId != _currentIndex) {
2008                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2009                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2010                     }
2011                 }
2012             }
2013         }
2014 
2015         emit Transfer(from, address(0), tokenId);
2016         _afterTokenTransfers(from, address(0), tokenId, 1);
2017 
2018         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2019         unchecked {
2020             _burnCounter++;
2021         }
2022     }
2023 
2024     // =============================================================
2025     //                     EXTRA DATA OPERATIONS
2026     // =============================================================
2027 
2028     /**
2029      * @dev Directly sets the extra data for the ownership data `index`.
2030      */
2031     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2032         uint256 packed = _packedOwnerships[index];
2033         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2034         uint256 extraDataCasted;
2035         // Cast `extraData` with assembly to avoid redundant masking.
2036         assembly {
2037             extraDataCasted := extraData
2038         }
2039         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2040         _packedOwnerships[index] = packed;
2041     }
2042 
2043     /**
2044      * @dev Called during each token transfer to set the 24bit `extraData` field.
2045      * Intended to be overridden by the cosumer contract.
2046      *
2047      * `previousExtraData` - the value of `extraData` before transfer.
2048      *
2049      * Calling conditions:
2050      *
2051      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2052      * transferred to `to`.
2053      * - When `from` is zero, `tokenId` will be minted for `to`.
2054      * - When `to` is zero, `tokenId` will be burned by `from`.
2055      * - `from` and `to` are never both zero.
2056      */
2057     function _extraData(
2058         address from,
2059         address to,
2060         uint24 previousExtraData
2061     ) internal view virtual returns (uint24) {}
2062 
2063     /**
2064      * @dev Returns the next extra data for the packed ownership data.
2065      * The returned result is shifted into position.
2066      */
2067     function _nextExtraData(
2068         address from,
2069         address to,
2070         uint256 prevOwnershipPacked
2071     ) private view returns (uint256) {
2072         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2073         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2074     }
2075 
2076     // =============================================================
2077     //                       OTHER OPERATIONS
2078     // =============================================================
2079 
2080     /**
2081      * @dev Returns the message sender (defaults to `msg.sender`).
2082      *
2083      * If you are writing GSN compatible contracts, you need to override this function.
2084      */
2085     function _msgSenderERC721A() internal view virtual returns (address) {
2086         return msg.sender;
2087     }
2088 
2089     /**
2090      * @dev Converts a uint256 to its ASCII string decimal representation.
2091      */
2092     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2093         assembly {
2094             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2095             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2096             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2097             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2098             let m := add(mload(0x40), 0xa0)
2099             // Update the free memory pointer to allocate.
2100             mstore(0x40, m)
2101             // Assign the `str` to the end.
2102             str := sub(m, 0x20)
2103             // Zeroize the slot after the string.
2104             mstore(str, 0)
2105 
2106             // Cache the end of the memory to calculate the length later.
2107             let end := str
2108 
2109             // We write the string from rightmost digit to leftmost digit.
2110             // The following is essentially a do-while loop that also handles the zero case.
2111             // prettier-ignore
2112             for { let temp := value } 1 {} {
2113                 str := sub(str, 1)
2114                 // Write the character to the pointer.
2115                 // The ASCII index of the '0' character is 48.
2116                 mstore8(str, add(48, mod(temp, 10)))
2117                 // Keep dividing `temp` until zero.
2118                 temp := div(temp, 10)
2119                 // prettier-ignore
2120                 if iszero(temp) { break }
2121             }
2122 
2123             let length := sub(end, str)
2124             // Move the pointer 32 bytes leftwards to make room for the length.
2125             str := sub(str, 0x20)
2126             // Store the length.
2127             mstore(str, length)
2128         }
2129     }
2130 }
2131 
2132 // File: contracts/neonsenseis.sol
2133 
2134 
2135 
2136 pragma solidity ^0.8.0;
2137 
2138 
2139 
2140 
2141 
2142 
2143 
2144 
2145 
2146 
2147 
2148 
2149 /***
2150  *      ___  ____  _  _  ____  ____  __     ____  ____  __ _  ____  ____  __  ____ 
2151  *     / __)(  _ \( \/ )(  _ \(_  _)/  \   / ___)(  __)(  ( \/ ___)(  __)(  )/ ___)
2152  *    ( (__  )   / )  /  ) __/  )( (  O )  \___ \ ) _) /    /\___ \ ) _)  )( \___ \
2153  *     \___)(__\_)(__/  (__)   (__) \__/   (____/(____)\_)__)(____/(____)(__)(____/
2154  */
2155 
2156 
2157 contract cryptosesnseis is ERC721A, Ownable, ReentrancyGuard {
2158   using Address for address;
2159   using Strings for uint;
2160 
2161 
2162   string  public  baseTokenURI = "ipfs://bafybeifmdgzgyk4kxvespngwccxiihsz2xe5vpi6ewefekhdiaueuf5nwm/";
2163   uint256 public  maxSupply = 775;
2164   uint256 public  MAX_MINTS_PER_TX = 20;
2165   uint256 public  PUBLIC_SALE_PRICE = 0.0049 ether; 
2166   uint256 public  NUM_FREE_MINTS = 775;
2167   uint256 public  MAX_FREE_PER_WALLET = 1;
2168   uint256 public freeAlreadyMinted = 0;
2169   bool public isPublicSaleActive = false;
2170   constructor() ERC721A("Crypto Senseis", "SENSEIS") {
2171   }
2172 
2173 
2174   function mint(uint256 numberOfTokens)
2175       external
2176       payable
2177   {
2178     require(isPublicSaleActive, "Nope! Not yet, hold on");
2179     require(totalSupply() + numberOfTokens < maxSupply + 1, "too late mfer");
2180 
2181     if(freeAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
2182         require(
2183             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2184             "Incorrect ETH value sent"
2185         );
2186     } else {
2187         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
2188         require(
2189             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2190             "Incorrect ETH value sent"
2191         );
2192         require(
2193             numberOfTokens <= MAX_MINTS_PER_TX,
2194             "Max mints per transaction exceeded"
2195         );
2196         } else {
2197             require(
2198                 numberOfTokens <= MAX_FREE_PER_WALLET,
2199                 "Max mints per transaction exceeded"
2200             );
2201             freeAlreadyMinted += numberOfTokens;
2202         }
2203     }
2204     _safeMint(msg.sender, numberOfTokens);
2205   }
2206 
2207   function setBaseURI(string memory baseURI)
2208     public
2209     onlyOwner
2210   {
2211     baseTokenURI = baseURI;
2212   }
2213 
2214   function treasuryMint(uint quantity)
2215     public
2216     onlyOwner
2217   {
2218     require(
2219       quantity > 0,
2220       "Invalid mint amount"
2221     );
2222     require(
2223       totalSupply() + quantity <= maxSupply,
2224       "Maximum supply exceeded"
2225     );
2226     _safeMint(msg.sender, quantity);
2227   }
2228 
2229   function withdraw()
2230     public
2231     onlyOwner
2232     nonReentrant
2233   {
2234     Address.sendValue(payable(msg.sender), address(this).balance);
2235   }
2236 
2237   function _baseURI()
2238     internal
2239     view
2240     virtual
2241     override
2242     returns (string memory)
2243   {
2244     return baseTokenURI;
2245   }
2246 
2247   function setIsPublicSaleActive(bool _isPublicSaleActive)
2248       external
2249       onlyOwner
2250   {
2251       isPublicSaleActive = _isPublicSaleActive;
2252   }
2253 
2254   function setNumFreeMints(uint256 _numfreemints)
2255       external
2256       onlyOwner
2257   {
2258       NUM_FREE_MINTS = _numfreemints;
2259   }
2260 
2261   function setSalePrice(uint256 _price)
2262       external
2263       onlyOwner
2264   {
2265       PUBLIC_SALE_PRICE = _price;
2266   }
2267 
2268   function setMaxLimitPerTransaction(uint256 _limit)
2269       external
2270       onlyOwner
2271   {
2272       MAX_MINTS_PER_TX = _limit;
2273   }
2274 
2275   function setFreeLimitPerWallet(uint256 _limit)
2276       external
2277       onlyOwner
2278   {
2279       MAX_FREE_PER_WALLET = _limit;
2280   }
2281 }