1 // SPDX-License-Identifier: MIT
2 
3 /***
4  *                                 _________                           .__        
5  *      ____   ____  ____   ____  /   _____/ ____   ____   ______ ____ |__| ______
6  *     /    \_/ __ \/  _ \ /    \ \_____  \_/ __ \ /    \ /  ___// __ \|  |/  ___/
7  *    |   |  \  ___(  <_> )   |  \/        \  ___/|   |  \\___ \\  ___/|  |\___ \ 
8  *    |___|  /\___  >____/|___|  /_______  /\___  >___|  /____  >\___  >__/____  >
9  *         \/     \/           \/        \/     \/     \/     \/     \/        \/ 
10  */
11  
12 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
13 
14 
15 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Contract module that helps prevent reentrant calls to a function.
21  *
22  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
23  * available, which can be applied to functions to make sure there are no nested
24  * (reentrant) calls to them.
25  *
26  * Note that because there is a single `nonReentrant` guard, functions marked as
27  * `nonReentrant` may not call one another. This can be worked around by making
28  * those functions `private`, and then adding `external` `nonReentrant` entry
29  * points to them.
30  *
31  * TIP: If you would like to learn more about reentrancy and alternative ways
32  * to protect against it, check out our blog post
33  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
34  */
35 abstract contract ReentrancyGuard {
36     // Booleans are more expensive than uint256 or any type that takes up a full
37     // word because each write operation emits an extra SLOAD to first read the
38     // slot's contents, replace the bits taken up by the boolean, and then write
39     // back. This is the compiler's defense against contract upgrades and
40     // pointer aliasing, and it cannot be disabled.
41 
42     // The values being non-zero value makes deployment a bit more expensive,
43     // but in exchange the refund on every call to nonReentrant will be lower in
44     // amount. Since refunds are capped to a percentage of the total
45     // transaction's gas, it is best to keep them low in cases like this one, to
46     // increase the likelihood of the full refund coming into effect.
47     uint256 private constant _NOT_ENTERED = 1;
48     uint256 private constant _ENTERED = 2;
49 
50     uint256 private _status;
51 
52     constructor() {
53         _status = _NOT_ENTERED;
54     }
55 
56     /**
57      * @dev Prevents a contract from calling itself, directly or indirectly.
58      * Calling a `nonReentrant` function from another `nonReentrant`
59      * function is not supported. It is possible to prevent this from happening
60      * by making the `nonReentrant` function external, and making it call a
61      * `private` function that does the actual work.
62      */
63     modifier nonReentrant() {
64         // On the first call to nonReentrant, _notEntered will be true
65         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
66 
67         // Any calls to nonReentrant after this point will fail
68         _status = _ENTERED;
69 
70         _;
71 
72         // By storing the original value once again, a refund is triggered (see
73         // https://eips.ethereum.org/EIPS/eip-2200)
74         _status = _NOT_ENTERED;
75     }
76 }
77 
78 // File: @openzeppelin/contracts/utils/Strings.sol
79 
80 
81 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 /**
86  * @dev String operations.
87  */
88 library Strings {
89     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
90     uint8 private constant _ADDRESS_LENGTH = 20;
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
94      */
95     function toString(uint256 value) internal pure returns (string memory) {
96         // Inspired by OraclizeAPI's implementation - MIT licence
97         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
98 
99         if (value == 0) {
100             return "0";
101         }
102         uint256 temp = value;
103         uint256 digits;
104         while (temp != 0) {
105             digits++;
106             temp /= 10;
107         }
108         bytes memory buffer = new bytes(digits);
109         while (value != 0) {
110             digits -= 1;
111             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
112             value /= 10;
113         }
114         return string(buffer);
115     }
116 
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
119      */
120     function toHexString(uint256 value) internal pure returns (string memory) {
121         if (value == 0) {
122             return "0x00";
123         }
124         uint256 temp = value;
125         uint256 length = 0;
126         while (temp != 0) {
127             length++;
128             temp >>= 8;
129         }
130         return toHexString(value, length);
131     }
132 
133     /**
134      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
135      */
136     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
137         bytes memory buffer = new bytes(2 * length + 2);
138         buffer[0] = "0";
139         buffer[1] = "x";
140         for (uint256 i = 2 * length + 1; i > 1; --i) {
141             buffer[i] = _HEX_SYMBOLS[value & 0xf];
142             value >>= 4;
143         }
144         require(value == 0, "Strings: hex length insufficient");
145         return string(buffer);
146     }
147 
148     /**
149      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
150      */
151     function toHexString(address addr) internal pure returns (string memory) {
152         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
153     }
154 }
155 
156 // File: @openzeppelin/contracts/utils/Context.sol
157 
158 
159 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 /**
164  * @dev Provides information about the current execution context, including the
165  * sender of the transaction and its data. While these are generally available
166  * via msg.sender and msg.data, they should not be accessed in such a direct
167  * manner, since when dealing with meta-transactions the account sending and
168  * paying for execution may not be the actual sender (as far as an application
169  * is concerned).
170  *
171  * This contract is only required for intermediate, library-like contracts.
172  */
173 abstract contract Context {
174     function _msgSender() internal view virtual returns (address) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view virtual returns (bytes calldata) {
179         return msg.data;
180     }
181 }
182 
183 // File: @openzeppelin/contracts/access/Ownable.sol
184 
185 
186 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 
191 /**
192  * @dev Contract module which provides a basic access control mechanism, where
193  * there is an account (an owner) that can be granted exclusive access to
194  * specific functions.
195  *
196  * By default, the owner account will be the one that deploys the contract. This
197  * can later be changed with {transferOwnership}.
198  *
199  * This module is used through inheritance. It will make available the modifier
200  * `onlyOwner`, which can be applied to your functions to restrict their use to
201  * the owner.
202  */
203 abstract contract Ownable is Context {
204     address private _owner;
205 
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207 
208     /**
209      * @dev Initializes the contract setting the deployer as the initial owner.
210      */
211     constructor() {
212         _transferOwnership(_msgSender());
213     }
214 
215     /**
216      * @dev Throws if called by any account other than the owner.
217      */
218     modifier onlyOwner() {
219         _checkOwner();
220         _;
221     }
222 
223     /**
224      * @dev Returns the address of the current owner.
225      */
226     function owner() public view virtual returns (address) {
227         return _owner;
228     }
229 
230     /**
231      * @dev Throws if the sender is not the owner.
232      */
233     function _checkOwner() internal view virtual {
234         require(owner() == _msgSender(), "Ownable: caller is not the owner");
235     }
236 
237     /**
238      * @dev Leaves the contract without owner. It will not be possible to call
239      * `onlyOwner` functions anymore. Can only be called by the current owner.
240      *
241      * NOTE: Renouncing ownership will leave the contract without an owner,
242      * thereby removing any functionality that is only available to the owner.
243      */
244     function renounceOwnership() public virtual onlyOwner {
245         _transferOwnership(address(0));
246     }
247 
248     /**
249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
250      * Can only be called by the current owner.
251      */
252     function transferOwnership(address newOwner) public virtual onlyOwner {
253         require(newOwner != address(0), "Ownable: new owner is the zero address");
254         _transferOwnership(newOwner);
255     }
256 
257     /**
258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
259      * Internal function without access restriction.
260      */
261     function _transferOwnership(address newOwner) internal virtual {
262         address oldOwner = _owner;
263         _owner = newOwner;
264         emit OwnershipTransferred(oldOwner, newOwner);
265     }
266 }
267 
268 // File: @openzeppelin/contracts/utils/Address.sol
269 
270 
271 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
272 
273 pragma solidity ^0.8.1;
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      *
296      * [IMPORTANT]
297      * ====
298      * You shouldn't rely on `isContract` to protect against flash loan attacks!
299      *
300      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
301      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
302      * constructor.
303      * ====
304      */
305     function isContract(address account) internal view returns (bool) {
306         // This method relies on extcodesize/address.code.length, which returns 0
307         // for contracts in construction, since the code is only stored at the end
308         // of the constructor execution.
309 
310         return account.code.length > 0;
311     }
312 
313     /**
314      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
315      * `recipient`, forwarding all available gas and reverting on errors.
316      *
317      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
318      * of certain opcodes, possibly making contracts go over the 2300 gas limit
319      * imposed by `transfer`, making them unable to receive funds via
320      * `transfer`. {sendValue} removes this limitation.
321      *
322      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
323      *
324      * IMPORTANT: because control is transferred to `recipient`, care must be
325      * taken to not create reentrancy vulnerabilities. Consider using
326      * {ReentrancyGuard} or the
327      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
328      */
329     function sendValue(address payable recipient, uint256 amount) internal {
330         require(address(this).balance >= amount, "Address: insufficient balance");
331 
332         (bool success, ) = recipient.call{value: amount}("");
333         require(success, "Address: unable to send value, recipient may have reverted");
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain `call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
355         return functionCall(target, data, "Address: low-level call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
360      * `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, 0, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but also transferring `value` wei to `target`.
375      *
376      * Requirements:
377      *
378      * - the calling contract must have an ETH balance of at least `value`.
379      * - the called Solidity function must be `payable`.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value
387     ) internal returns (bytes memory) {
388         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
393      * with `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCallWithValue(
398         address target,
399         bytes memory data,
400         uint256 value,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         require(address(this).balance >= value, "Address: insufficient balance for call");
404         require(isContract(target), "Address: call to non-contract");
405 
406         (bool success, bytes memory returndata) = target.call{value: value}(data);
407         return verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
417         return functionStaticCall(target, data, "Address: low-level static call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal view returns (bytes memory) {
431         require(isContract(target), "Address: static call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.staticcall(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
444         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         require(isContract(target), "Address: delegate call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.delegatecall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
466      * revert reason using the provided one.
467      *
468      * _Available since v4.3._
469      */
470     function verifyCallResult(
471         bool success,
472         bytes memory returndata,
473         string memory errorMessage
474     ) internal pure returns (bytes memory) {
475         if (success) {
476             return returndata;
477         } else {
478             // Look for revert reason and bubble it up if present
479             if (returndata.length > 0) {
480                 // The easiest way to bubble the revert reason is using memory via assembly
481                 /// @solidity memory-safe-assembly
482                 assembly {
483                     let returndata_size := mload(returndata)
484                     revert(add(32, returndata), returndata_size)
485                 }
486             } else {
487                 revert(errorMessage);
488             }
489         }
490     }
491 }
492 
493 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
494 
495 
496 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @title ERC721 token receiver interface
502  * @dev Interface for any contract that wants to support safeTransfers
503  * from ERC721 asset contracts.
504  */
505 interface IERC721Receiver {
506     /**
507      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
508      * by `operator` from `from`, this function is called.
509      *
510      * It must return its Solidity selector to confirm the token transfer.
511      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
512      *
513      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
514      */
515     function onERC721Received(
516         address operator,
517         address from,
518         uint256 tokenId,
519         bytes calldata data
520     ) external returns (bytes4);
521 }
522 
523 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
524 
525 
526 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @dev Interface of the ERC165 standard, as defined in the
532  * https://eips.ethereum.org/EIPS/eip-165[EIP].
533  *
534  * Implementers can declare support of contract interfaces, which can then be
535  * queried by others ({ERC165Checker}).
536  *
537  * For an implementation, see {ERC165}.
538  */
539 interface IERC165 {
540     /**
541      * @dev Returns true if this contract implements the interface defined by
542      * `interfaceId`. See the corresponding
543      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
544      * to learn more about how these ids are created.
545      *
546      * This function call must use less than 30 000 gas.
547      */
548     function supportsInterface(bytes4 interfaceId) external view returns (bool);
549 }
550 
551 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
552 
553 
554 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 
559 /**
560  * @dev Implementation of the {IERC165} interface.
561  *
562  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
563  * for the additional interface id that will be supported. For example:
564  *
565  * ```solidity
566  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
567  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
568  * }
569  * ```
570  *
571  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
572  */
573 abstract contract ERC165 is IERC165 {
574     /**
575      * @dev See {IERC165-supportsInterface}.
576      */
577     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
578         return interfaceId == type(IERC165).interfaceId;
579     }
580 }
581 
582 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
583 
584 
585 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 
590 /**
591  * @dev Required interface of an ERC721 compliant contract.
592  */
593 interface IERC721 is IERC165 {
594     /**
595      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
596      */
597     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
598 
599     /**
600      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
601      */
602     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
603 
604     /**
605      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
606      */
607     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
608 
609     /**
610      * @dev Returns the number of tokens in ``owner``'s account.
611      */
612     function balanceOf(address owner) external view returns (uint256 balance);
613 
614     /**
615      * @dev Returns the owner of the `tokenId` token.
616      *
617      * Requirements:
618      *
619      * - `tokenId` must exist.
620      */
621     function ownerOf(uint256 tokenId) external view returns (address owner);
622 
623     /**
624      * @dev Safely transfers `tokenId` token from `from` to `to`.
625      *
626      * Requirements:
627      *
628      * - `from` cannot be the zero address.
629      * - `to` cannot be the zero address.
630      * - `tokenId` token must exist and be owned by `from`.
631      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
632      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
633      *
634      * Emits a {Transfer} event.
635      */
636     function safeTransferFrom(
637         address from,
638         address to,
639         uint256 tokenId,
640         bytes calldata data
641     ) external;
642 
643     /**
644      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
645      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
646      *
647      * Requirements:
648      *
649      * - `from` cannot be the zero address.
650      * - `to` cannot be the zero address.
651      * - `tokenId` token must exist and be owned by `from`.
652      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
653      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
654      *
655      * Emits a {Transfer} event.
656      */
657     function safeTransferFrom(
658         address from,
659         address to,
660         uint256 tokenId
661     ) external;
662 
663     /**
664      * @dev Transfers `tokenId` token from `from` to `to`.
665      *
666      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
667      *
668      * Requirements:
669      *
670      * - `from` cannot be the zero address.
671      * - `to` cannot be the zero address.
672      * - `tokenId` token must be owned by `from`.
673      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
674      *
675      * Emits a {Transfer} event.
676      */
677     function transferFrom(
678         address from,
679         address to,
680         uint256 tokenId
681     ) external;
682 
683     /**
684      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
685      * The approval is cleared when the token is transferred.
686      *
687      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
688      *
689      * Requirements:
690      *
691      * - The caller must own the token or be an approved operator.
692      * - `tokenId` must exist.
693      *
694      * Emits an {Approval} event.
695      */
696     function approve(address to, uint256 tokenId) external;
697 
698     /**
699      * @dev Approve or remove `operator` as an operator for the caller.
700      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
701      *
702      * Requirements:
703      *
704      * - The `operator` cannot be the caller.
705      *
706      * Emits an {ApprovalForAll} event.
707      */
708     function setApprovalForAll(address operator, bool _approved) external;
709 
710     /**
711      * @dev Returns the account approved for `tokenId` token.
712      *
713      * Requirements:
714      *
715      * - `tokenId` must exist.
716      */
717     function getApproved(uint256 tokenId) external view returns (address operator);
718 
719     /**
720      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
721      *
722      * See {setApprovalForAll}
723      */
724     function isApprovedForAll(address owner, address operator) external view returns (bool);
725 }
726 
727 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
728 
729 
730 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 
735 /**
736  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
737  * @dev See https://eips.ethereum.org/EIPS/eip-721
738  */
739 interface IERC721Metadata is IERC721 {
740     /**
741      * @dev Returns the token collection name.
742      */
743     function name() external view returns (string memory);
744 
745     /**
746      * @dev Returns the token collection symbol.
747      */
748     function symbol() external view returns (string memory);
749 
750     /**
751      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
752      */
753     function tokenURI(uint256 tokenId) external view returns (string memory);
754 }
755 
756 // File: erc721a/contracts/IERC721A.sol
757 
758 
759 // ERC721A Contracts v4.2.3
760 // Creator: Chiru Labs
761 
762 pragma solidity ^0.8.4;
763 
764 /**
765  * @dev Interface of ERC721A.
766  */
767 interface IERC721A {
768     /**
769      * The caller must own the token or be an approved operator.
770      */
771     error ApprovalCallerNotOwnerNorApproved();
772 
773     /**
774      * The token does not exist.
775      */
776     error ApprovalQueryForNonexistentToken();
777 
778     /**
779      * Cannot query the balance for the zero address.
780      */
781     error BalanceQueryForZeroAddress();
782 
783     /**
784      * Cannot mint to the zero address.
785      */
786     error MintToZeroAddress();
787 
788     /**
789      * The quantity of tokens minted must be more than zero.
790      */
791     error MintZeroQuantity();
792 
793     /**
794      * The token does not exist.
795      */
796     error OwnerQueryForNonexistentToken();
797 
798     /**
799      * The caller must own the token or be an approved operator.
800      */
801     error TransferCallerNotOwnerNorApproved();
802 
803     /**
804      * The token must be owned by `from`.
805      */
806     error TransferFromIncorrectOwner();
807 
808     /**
809      * Cannot safely transfer to a contract that does not implement the
810      * ERC721Receiver interface.
811      */
812     error TransferToNonERC721ReceiverImplementer();
813 
814     /**
815      * Cannot transfer to the zero address.
816      */
817     error TransferToZeroAddress();
818 
819     /**
820      * The token does not exist.
821      */
822     error URIQueryForNonexistentToken();
823 
824     /**
825      * The `quantity` minted with ERC2309 exceeds the safety limit.
826      */
827     error MintERC2309QuantityExceedsLimit();
828 
829     /**
830      * The `extraData` cannot be set on an unintialized ownership slot.
831      */
832     error OwnershipNotInitializedForExtraData();
833 
834     // =============================================================
835     //                            STRUCTS
836     // =============================================================
837 
838     struct TokenOwnership {
839         // The address of the owner.
840         address addr;
841         // Stores the start time of ownership with minimal overhead for tokenomics.
842         uint64 startTimestamp;
843         // Whether the token has been burned.
844         bool burned;
845         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
846         uint24 extraData;
847     }
848 
849     // =============================================================
850     //                         TOKEN COUNTERS
851     // =============================================================
852 
853     /**
854      * @dev Returns the total number of tokens in existence.
855      * Burned tokens will reduce the count.
856      * To get the total number of tokens minted, please see {_totalMinted}.
857      */
858     function totalSupply() external view returns (uint256);
859 
860     // =============================================================
861     //                            IERC165
862     // =============================================================
863 
864     /**
865      * @dev Returns true if this contract implements the interface defined by
866      * `interfaceId`. See the corresponding
867      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
868      * to learn more about how these ids are created.
869      *
870      * This function call must use less than 30000 gas.
871      */
872     function supportsInterface(bytes4 interfaceId) external view returns (bool);
873 
874     // =============================================================
875     //                            IERC721
876     // =============================================================
877 
878     /**
879      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
880      */
881     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
882 
883     /**
884      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
885      */
886     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
887 
888     /**
889      * @dev Emitted when `owner` enables or disables
890      * (`approved`) `operator` to manage all of its assets.
891      */
892     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
893 
894     /**
895      * @dev Returns the number of tokens in `owner`'s account.
896      */
897     function balanceOf(address owner) external view returns (uint256 balance);
898 
899     /**
900      * @dev Returns the owner of the `tokenId` token.
901      *
902      * Requirements:
903      *
904      * - `tokenId` must exist.
905      */
906     function ownerOf(uint256 tokenId) external view returns (address owner);
907 
908     /**
909      * @dev Safely transfers `tokenId` token from `from` to `to`,
910      * checking first that contract recipients are aware of the ERC721 protocol
911      * to prevent tokens from being forever locked.
912      *
913      * Requirements:
914      *
915      * - `from` cannot be the zero address.
916      * - `to` cannot be the zero address.
917      * - `tokenId` token must exist and be owned by `from`.
918      * - If the caller is not `from`, it must be have been allowed to move
919      * this token by either {approve} or {setApprovalForAll}.
920      * - If `to` refers to a smart contract, it must implement
921      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
922      *
923      * Emits a {Transfer} event.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes calldata data
930     ) external payable;
931 
932     /**
933      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) external payable;
940 
941     /**
942      * @dev Transfers `tokenId` from `from` to `to`.
943      *
944      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
945      * whenever possible.
946      *
947      * Requirements:
948      *
949      * - `from` cannot be the zero address.
950      * - `to` cannot be the zero address.
951      * - `tokenId` token must be owned by `from`.
952      * - If the caller is not `from`, it must be approved to move this token
953      * by either {approve} or {setApprovalForAll}.
954      *
955      * Emits a {Transfer} event.
956      */
957     function transferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) external payable;
962 
963     /**
964      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
965      * The approval is cleared when the token is transferred.
966      *
967      * Only a single account can be approved at a time, so approving the
968      * zero address clears previous approvals.
969      *
970      * Requirements:
971      *
972      * - The caller must own the token or be an approved operator.
973      * - `tokenId` must exist.
974      *
975      * Emits an {Approval} event.
976      */
977     function approve(address to, uint256 tokenId) external payable;
978 
979     /**
980      * @dev Approve or remove `operator` as an operator for the caller.
981      * Operators can call {transferFrom} or {safeTransferFrom}
982      * for any token owned by the caller.
983      *
984      * Requirements:
985      *
986      * - The `operator` cannot be the caller.
987      *
988      * Emits an {ApprovalForAll} event.
989      */
990     function setApprovalForAll(address operator, bool _approved) external;
991 
992     /**
993      * @dev Returns the account approved for `tokenId` token.
994      *
995      * Requirements:
996      *
997      * - `tokenId` must exist.
998      */
999     function getApproved(uint256 tokenId) external view returns (address operator);
1000 
1001     /**
1002      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1003      *
1004      * See {setApprovalForAll}.
1005      */
1006     function isApprovedForAll(address owner, address operator) external view returns (bool);
1007 
1008     // =============================================================
1009     //                        IERC721Metadata
1010     // =============================================================
1011 
1012     /**
1013      * @dev Returns the token collection name.
1014      */
1015     function name() external view returns (string memory);
1016 
1017     /**
1018      * @dev Returns the token collection symbol.
1019      */
1020     function symbol() external view returns (string memory);
1021 
1022     /**
1023      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1024      */
1025     function tokenURI(uint256 tokenId) external view returns (string memory);
1026 
1027     // =============================================================
1028     //                           IERC2309
1029     // =============================================================
1030 
1031     /**
1032      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1033      * (inclusive) is transferred from `from` to `to`, as defined in the
1034      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1035      *
1036      * See {_mintERC2309} for more details.
1037      */
1038     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1039 }
1040 
1041 // File: erc721a/contracts/ERC721A.sol
1042 
1043 
1044 // ERC721A Contracts v4.2.3
1045 // Creator: Chiru Labs
1046 
1047 pragma solidity ^0.8.4;
1048 
1049 
1050 /**
1051  * @dev Interface of ERC721 token receiver.
1052  */
1053 interface ERC721A__IERC721Receiver {
1054     function onERC721Received(
1055         address operator,
1056         address from,
1057         uint256 tokenId,
1058         bytes calldata data
1059     ) external returns (bytes4);
1060 }
1061 
1062 /**
1063  * @title ERC721A
1064  *
1065  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1066  * Non-Fungible Token Standard, including the Metadata extension.
1067  * Optimized for lower gas during batch mints.
1068  *
1069  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1070  * starting from `_startTokenId()`.
1071  *
1072  * Assumptions:
1073  *
1074  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1075  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1076  */
1077 contract ERC721A is IERC721A {
1078     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1079     struct TokenApprovalRef {
1080         address value;
1081     }
1082 
1083     // =============================================================
1084     //                           CONSTANTS
1085     // =============================================================
1086 
1087     // Mask of an entry in packed address data.
1088     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1089 
1090     // The bit position of `numberMinted` in packed address data.
1091     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1092 
1093     // The bit position of `numberBurned` in packed address data.
1094     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1095 
1096     // The bit position of `aux` in packed address data.
1097     uint256 private constant _BITPOS_AUX = 192;
1098 
1099     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1100     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1101 
1102     // The bit position of `startTimestamp` in packed ownership.
1103     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1104 
1105     // The bit mask of the `burned` bit in packed ownership.
1106     uint256 private constant _BITMASK_BURNED = 1 << 224;
1107 
1108     // The bit position of the `nextInitialized` bit in packed ownership.
1109     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1110 
1111     // The bit mask of the `nextInitialized` bit in packed ownership.
1112     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1113 
1114     // The bit position of `extraData` in packed ownership.
1115     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1116 
1117     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1118     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1119 
1120     // The mask of the lower 160 bits for addresses.
1121     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1122 
1123     // The maximum `quantity` that can be minted with {_mintERC2309}.
1124     // This limit is to prevent overflows on the address data entries.
1125     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1126     // is required to cause an overflow, which is unrealistic.
1127     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1128 
1129     // The `Transfer` event signature is given by:
1130     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1131     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1132         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1133 
1134     // =============================================================
1135     //                            STORAGE
1136     // =============================================================
1137 
1138     // The next token ID to be minted.
1139     uint256 private _currentIndex;
1140 
1141     // The number of tokens burned.
1142     uint256 private _burnCounter;
1143 
1144     // Token name
1145     string private _name;
1146 
1147     // Token symbol
1148     string private _symbol;
1149 
1150     // Mapping from token ID to ownership details
1151     // An empty struct value does not necessarily mean the token is unowned.
1152     // See {_packedOwnershipOf} implementation for details.
1153     //
1154     // Bits Layout:
1155     // - [0..159]   `addr`
1156     // - [160..223] `startTimestamp`
1157     // - [224]      `burned`
1158     // - [225]      `nextInitialized`
1159     // - [232..255] `extraData`
1160     mapping(uint256 => uint256) private _packedOwnerships;
1161 
1162     // Mapping owner address to address data.
1163     //
1164     // Bits Layout:
1165     // - [0..63]    `balance`
1166     // - [64..127]  `numberMinted`
1167     // - [128..191] `numberBurned`
1168     // - [192..255] `aux`
1169     mapping(address => uint256) private _packedAddressData;
1170 
1171     // Mapping from token ID to approved address.
1172     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1173 
1174     // Mapping from owner to operator approvals
1175     mapping(address => mapping(address => bool)) private _operatorApprovals;
1176 
1177     // =============================================================
1178     //                          CONSTRUCTOR
1179     // =============================================================
1180 
1181     constructor(string memory name_, string memory symbol_) {
1182         _name = name_;
1183         _symbol = symbol_;
1184         _currentIndex = _startTokenId();
1185     }
1186 
1187     // =============================================================
1188     //                   TOKEN COUNTING OPERATIONS
1189     // =============================================================
1190 
1191     /**
1192      * @dev Returns the starting token ID.
1193      * To change the starting token ID, please override this function.
1194      */
1195     function _startTokenId() internal view virtual returns (uint256) {
1196         return 0;
1197     }
1198 
1199     /**
1200      * @dev Returns the next token ID to be minted.
1201      */
1202     function _nextTokenId() internal view virtual returns (uint256) {
1203         return _currentIndex;
1204     }
1205 
1206     /**
1207      * @dev Returns the total number of tokens in existence.
1208      * Burned tokens will reduce the count.
1209      * To get the total number of tokens minted, please see {_totalMinted}.
1210      */
1211     function totalSupply() public view virtual override returns (uint256) {
1212         // Counter underflow is impossible as _burnCounter cannot be incremented
1213         // more than `_currentIndex - _startTokenId()` times.
1214         unchecked {
1215             return _currentIndex - _burnCounter - _startTokenId();
1216         }
1217     }
1218 
1219     /**
1220      * @dev Returns the total amount of tokens minted in the contract.
1221      */
1222     function _totalMinted() internal view virtual returns (uint256) {
1223         // Counter underflow is impossible as `_currentIndex` does not decrement,
1224         // and it is initialized to `_startTokenId()`.
1225         unchecked {
1226             return _currentIndex - _startTokenId();
1227         }
1228     }
1229 
1230     /**
1231      * @dev Returns the total number of tokens burned.
1232      */
1233     function _totalBurned() internal view virtual returns (uint256) {
1234         return _burnCounter;
1235     }
1236 
1237     // =============================================================
1238     //                    ADDRESS DATA OPERATIONS
1239     // =============================================================
1240 
1241     /**
1242      * @dev Returns the number of tokens in `owner`'s account.
1243      */
1244     function balanceOf(address owner) public view virtual override returns (uint256) {
1245         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1246         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1247     }
1248 
1249     /**
1250      * Returns the number of tokens minted by `owner`.
1251      */
1252     function _numberMinted(address owner) internal view returns (uint256) {
1253         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1254     }
1255 
1256     /**
1257      * Returns the number of tokens burned by or on behalf of `owner`.
1258      */
1259     function _numberBurned(address owner) internal view returns (uint256) {
1260         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1261     }
1262 
1263     /**
1264      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1265      */
1266     function _getAux(address owner) internal view returns (uint64) {
1267         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1268     }
1269 
1270     /**
1271      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1272      * If there are multiple variables, please pack them into a uint64.
1273      */
1274     function _setAux(address owner, uint64 aux) internal virtual {
1275         uint256 packed = _packedAddressData[owner];
1276         uint256 auxCasted;
1277         // Cast `aux` with assembly to avoid redundant masking.
1278         assembly {
1279             auxCasted := aux
1280         }
1281         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1282         _packedAddressData[owner] = packed;
1283     }
1284 
1285     // =============================================================
1286     //                            IERC165
1287     // =============================================================
1288 
1289     /**
1290      * @dev Returns true if this contract implements the interface defined by
1291      * `interfaceId`. See the corresponding
1292      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1293      * to learn more about how these ids are created.
1294      *
1295      * This function call must use less than 30000 gas.
1296      */
1297     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1298         // The interface IDs are constants representing the first 4 bytes
1299         // of the XOR of all function selectors in the interface.
1300         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1301         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1302         return
1303             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1304             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1305             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1306     }
1307 
1308     // =============================================================
1309     //                        IERC721Metadata
1310     // =============================================================
1311 
1312     /**
1313      * @dev Returns the token collection name.
1314      */
1315     function name() public view virtual override returns (string memory) {
1316         return _name;
1317     }
1318 
1319     /**
1320      * @dev Returns the token collection symbol.
1321      */
1322     function symbol() public view virtual override returns (string memory) {
1323         return _symbol;
1324     }
1325 
1326     /**
1327      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1328      */
1329     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1330         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1331 
1332         string memory baseURI = _baseURI();
1333         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1334     }
1335 
1336     /**
1337      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1338      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1339      * by default, it can be overridden in child contracts.
1340      */
1341     function _baseURI() internal view virtual returns (string memory) {
1342         return '';
1343     }
1344 
1345     // =============================================================
1346     //                     OWNERSHIPS OPERATIONS
1347     // =============================================================
1348 
1349     /**
1350      * @dev Returns the owner of the `tokenId` token.
1351      *
1352      * Requirements:
1353      *
1354      * - `tokenId` must exist.
1355      */
1356     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1357         return address(uint160(_packedOwnershipOf(tokenId)));
1358     }
1359 
1360     /**
1361      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1362      * It gradually moves to O(1) as tokens get transferred around over time.
1363      */
1364     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1365         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1366     }
1367 
1368     /**
1369      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1370      */
1371     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1372         return _unpackedOwnership(_packedOwnerships[index]);
1373     }
1374 
1375     /**
1376      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1377      */
1378     function _initializeOwnershipAt(uint256 index) internal virtual {
1379         if (_packedOwnerships[index] == 0) {
1380             _packedOwnerships[index] = _packedOwnershipOf(index);
1381         }
1382     }
1383 
1384     /**
1385      * Returns the packed ownership data of `tokenId`.
1386      */
1387     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1388         uint256 curr = tokenId;
1389 
1390         unchecked {
1391             if (_startTokenId() <= curr)
1392                 if (curr < _currentIndex) {
1393                     uint256 packed = _packedOwnerships[curr];
1394                     // If not burned.
1395                     if (packed & _BITMASK_BURNED == 0) {
1396                         // Invariant:
1397                         // There will always be an initialized ownership slot
1398                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1399                         // before an unintialized ownership slot
1400                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1401                         // Hence, `curr` will not underflow.
1402                         //
1403                         // We can directly compare the packed value.
1404                         // If the address is zero, packed will be zero.
1405                         while (packed == 0) {
1406                             packed = _packedOwnerships[--curr];
1407                         }
1408                         return packed;
1409                     }
1410                 }
1411         }
1412         revert OwnerQueryForNonexistentToken();
1413     }
1414 
1415     /**
1416      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1417      */
1418     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1419         ownership.addr = address(uint160(packed));
1420         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1421         ownership.burned = packed & _BITMASK_BURNED != 0;
1422         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1423     }
1424 
1425     /**
1426      * @dev Packs ownership data into a single uint256.
1427      */
1428     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1429         assembly {
1430             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1431             owner := and(owner, _BITMASK_ADDRESS)
1432             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1433             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1434         }
1435     }
1436 
1437     /**
1438      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1439      */
1440     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1441         // For branchless setting of the `nextInitialized` flag.
1442         assembly {
1443             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1444             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1445         }
1446     }
1447 
1448     // =============================================================
1449     //                      APPROVAL OPERATIONS
1450     // =============================================================
1451 
1452     /**
1453      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1454      * The approval is cleared when the token is transferred.
1455      *
1456      * Only a single account can be approved at a time, so approving the
1457      * zero address clears previous approvals.
1458      *
1459      * Requirements:
1460      *
1461      * - The caller must own the token or be an approved operator.
1462      * - `tokenId` must exist.
1463      *
1464      * Emits an {Approval} event.
1465      */
1466     function approve(address to, uint256 tokenId) public payable virtual override {
1467         address owner = ownerOf(tokenId);
1468 
1469         if (_msgSenderERC721A() != owner)
1470             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1471                 revert ApprovalCallerNotOwnerNorApproved();
1472             }
1473 
1474         _tokenApprovals[tokenId].value = to;
1475         emit Approval(owner, to, tokenId);
1476     }
1477 
1478     /**
1479      * @dev Returns the account approved for `tokenId` token.
1480      *
1481      * Requirements:
1482      *
1483      * - `tokenId` must exist.
1484      */
1485     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1486         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1487 
1488         return _tokenApprovals[tokenId].value;
1489     }
1490 
1491     /**
1492      * @dev Approve or remove `operator` as an operator for the caller.
1493      * Operators can call {transferFrom} or {safeTransferFrom}
1494      * for any token owned by the caller.
1495      *
1496      * Requirements:
1497      *
1498      * - The `operator` cannot be the caller.
1499      *
1500      * Emits an {ApprovalForAll} event.
1501      */
1502     function setApprovalForAll(address operator, bool approved) public virtual override {
1503         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1504         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1505     }
1506 
1507     /**
1508      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1509      *
1510      * See {setApprovalForAll}.
1511      */
1512     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1513         return _operatorApprovals[owner][operator];
1514     }
1515 
1516     /**
1517      * @dev Returns whether `tokenId` exists.
1518      *
1519      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1520      *
1521      * Tokens start existing when they are minted. See {_mint}.
1522      */
1523     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1524         return
1525             _startTokenId() <= tokenId &&
1526             tokenId < _currentIndex && // If within bounds,
1527             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1528     }
1529 
1530     /**
1531      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1532      */
1533     function _isSenderApprovedOrOwner(
1534         address approvedAddress,
1535         address owner,
1536         address msgSender
1537     ) private pure returns (bool result) {
1538         assembly {
1539             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1540             owner := and(owner, _BITMASK_ADDRESS)
1541             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1542             msgSender := and(msgSender, _BITMASK_ADDRESS)
1543             // `msgSender == owner || msgSender == approvedAddress`.
1544             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1545         }
1546     }
1547 
1548     /**
1549      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1550      */
1551     function _getApprovedSlotAndAddress(uint256 tokenId)
1552         private
1553         view
1554         returns (uint256 approvedAddressSlot, address approvedAddress)
1555     {
1556         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1557         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1558         assembly {
1559             approvedAddressSlot := tokenApproval.slot
1560             approvedAddress := sload(approvedAddressSlot)
1561         }
1562     }
1563 
1564     // =============================================================
1565     //                      TRANSFER OPERATIONS
1566     // =============================================================
1567 
1568     /**
1569      * @dev Transfers `tokenId` from `from` to `to`.
1570      *
1571      * Requirements:
1572      *
1573      * - `from` cannot be the zero address.
1574      * - `to` cannot be the zero address.
1575      * - `tokenId` token must be owned by `from`.
1576      * - If the caller is not `from`, it must be approved to move this token
1577      * by either {approve} or {setApprovalForAll}.
1578      *
1579      * Emits a {Transfer} event.
1580      */
1581     function transferFrom(
1582         address from,
1583         address to,
1584         uint256 tokenId
1585     ) public payable virtual override {
1586         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1587 
1588         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1589 
1590         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1591 
1592         // The nested ifs save around 20+ gas over a compound boolean condition.
1593         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1594             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1595 
1596         if (to == address(0)) revert TransferToZeroAddress();
1597 
1598         _beforeTokenTransfers(from, to, tokenId, 1);
1599 
1600         // Clear approvals from the previous owner.
1601         assembly {
1602             if approvedAddress {
1603                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1604                 sstore(approvedAddressSlot, 0)
1605             }
1606         }
1607 
1608         // Underflow of the sender's balance is impossible because we check for
1609         // ownership above and the recipient's balance can't realistically overflow.
1610         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1611         unchecked {
1612             // We can directly increment and decrement the balances.
1613             --_packedAddressData[from]; // Updates: `balance -= 1`.
1614             ++_packedAddressData[to]; // Updates: `balance += 1`.
1615 
1616             // Updates:
1617             // - `address` to the next owner.
1618             // - `startTimestamp` to the timestamp of transfering.
1619             // - `burned` to `false`.
1620             // - `nextInitialized` to `true`.
1621             _packedOwnerships[tokenId] = _packOwnershipData(
1622                 to,
1623                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1624             );
1625 
1626             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1627             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1628                 uint256 nextTokenId = tokenId + 1;
1629                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1630                 if (_packedOwnerships[nextTokenId] == 0) {
1631                     // If the next slot is within bounds.
1632                     if (nextTokenId != _currentIndex) {
1633                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1634                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1635                     }
1636                 }
1637             }
1638         }
1639 
1640         emit Transfer(from, to, tokenId);
1641         _afterTokenTransfers(from, to, tokenId, 1);
1642     }
1643 
1644     /**
1645      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1646      */
1647     function safeTransferFrom(
1648         address from,
1649         address to,
1650         uint256 tokenId
1651     ) public payable virtual override {
1652         safeTransferFrom(from, to, tokenId, '');
1653     }
1654 
1655     /**
1656      * @dev Safely transfers `tokenId` token from `from` to `to`.
1657      *
1658      * Requirements:
1659      *
1660      * - `from` cannot be the zero address.
1661      * - `to` cannot be the zero address.
1662      * - `tokenId` token must exist and be owned by `from`.
1663      * - If the caller is not `from`, it must be approved to move this token
1664      * by either {approve} or {setApprovalForAll}.
1665      * - If `to` refers to a smart contract, it must implement
1666      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1667      *
1668      * Emits a {Transfer} event.
1669      */
1670     function safeTransferFrom(
1671         address from,
1672         address to,
1673         uint256 tokenId,
1674         bytes memory _data
1675     ) public payable virtual override {
1676         transferFrom(from, to, tokenId);
1677         if (to.code.length != 0)
1678             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1679                 revert TransferToNonERC721ReceiverImplementer();
1680             }
1681     }
1682 
1683     /**
1684      * @dev Hook that is called before a set of serially-ordered token IDs
1685      * are about to be transferred. This includes minting.
1686      * And also called before burning one token.
1687      *
1688      * `startTokenId` - the first token ID to be transferred.
1689      * `quantity` - the amount to be transferred.
1690      *
1691      * Calling conditions:
1692      *
1693      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1694      * transferred to `to`.
1695      * - When `from` is zero, `tokenId` will be minted for `to`.
1696      * - When `to` is zero, `tokenId` will be burned by `from`.
1697      * - `from` and `to` are never both zero.
1698      */
1699     function _beforeTokenTransfers(
1700         address from,
1701         address to,
1702         uint256 startTokenId,
1703         uint256 quantity
1704     ) internal virtual {}
1705 
1706     /**
1707      * @dev Hook that is called after a set of serially-ordered token IDs
1708      * have been transferred. This includes minting.
1709      * And also called after one token has been burned.
1710      *
1711      * `startTokenId` - the first token ID to be transferred.
1712      * `quantity` - the amount to be transferred.
1713      *
1714      * Calling conditions:
1715      *
1716      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1717      * transferred to `to`.
1718      * - When `from` is zero, `tokenId` has been minted for `to`.
1719      * - When `to` is zero, `tokenId` has been burned by `from`.
1720      * - `from` and `to` are never both zero.
1721      */
1722     function _afterTokenTransfers(
1723         address from,
1724         address to,
1725         uint256 startTokenId,
1726         uint256 quantity
1727     ) internal virtual {}
1728 
1729     /**
1730      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1731      *
1732      * `from` - Previous owner of the given token ID.
1733      * `to` - Target address that will receive the token.
1734      * `tokenId` - Token ID to be transferred.
1735      * `_data` - Optional data to send along with the call.
1736      *
1737      * Returns whether the call correctly returned the expected magic value.
1738      */
1739     function _checkContractOnERC721Received(
1740         address from,
1741         address to,
1742         uint256 tokenId,
1743         bytes memory _data
1744     ) private returns (bool) {
1745         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1746             bytes4 retval
1747         ) {
1748             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1749         } catch (bytes memory reason) {
1750             if (reason.length == 0) {
1751                 revert TransferToNonERC721ReceiverImplementer();
1752             } else {
1753                 assembly {
1754                     revert(add(32, reason), mload(reason))
1755                 }
1756             }
1757         }
1758     }
1759 
1760     // =============================================================
1761     //                        MINT OPERATIONS
1762     // =============================================================
1763 
1764     /**
1765      * @dev Mints `quantity` tokens and transfers them to `to`.
1766      *
1767      * Requirements:
1768      *
1769      * - `to` cannot be the zero address.
1770      * - `quantity` must be greater than 0.
1771      *
1772      * Emits a {Transfer} event for each mint.
1773      */
1774     function _mint(address to, uint256 quantity) internal virtual {
1775         uint256 startTokenId = _currentIndex;
1776         if (quantity == 0) revert MintZeroQuantity();
1777 
1778         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1779 
1780         // Overflows are incredibly unrealistic.
1781         // `balance` and `numberMinted` have a maximum limit of 2**64.
1782         // `tokenId` has a maximum limit of 2**256.
1783         unchecked {
1784             // Updates:
1785             // - `balance += quantity`.
1786             // - `numberMinted += quantity`.
1787             //
1788             // We can directly add to the `balance` and `numberMinted`.
1789             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1790 
1791             // Updates:
1792             // - `address` to the owner.
1793             // - `startTimestamp` to the timestamp of minting.
1794             // - `burned` to `false`.
1795             // - `nextInitialized` to `quantity == 1`.
1796             _packedOwnerships[startTokenId] = _packOwnershipData(
1797                 to,
1798                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1799             );
1800 
1801             uint256 toMasked;
1802             uint256 end = startTokenId + quantity;
1803 
1804             // Use assembly to loop and emit the `Transfer` event for gas savings.
1805             // The duplicated `log4` removes an extra check and reduces stack juggling.
1806             // The assembly, together with the surrounding Solidity code, have been
1807             // delicately arranged to nudge the compiler into producing optimized opcodes.
1808             assembly {
1809                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1810                 toMasked := and(to, _BITMASK_ADDRESS)
1811                 // Emit the `Transfer` event.
1812                 log4(
1813                     0, // Start of data (0, since no data).
1814                     0, // End of data (0, since no data).
1815                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1816                     0, // `address(0)`.
1817                     toMasked, // `to`.
1818                     startTokenId // `tokenId`.
1819                 )
1820 
1821                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1822                 // that overflows uint256 will make the loop run out of gas.
1823                 // The compiler will optimize the `iszero` away for performance.
1824                 for {
1825                     let tokenId := add(startTokenId, 1)
1826                 } iszero(eq(tokenId, end)) {
1827                     tokenId := add(tokenId, 1)
1828                 } {
1829                     // Emit the `Transfer` event. Similar to above.
1830                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1831                 }
1832             }
1833             if (toMasked == 0) revert MintToZeroAddress();
1834 
1835             _currentIndex = end;
1836         }
1837         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1838     }
1839 
1840     /**
1841      * @dev Mints `quantity` tokens and transfers them to `to`.
1842      *
1843      * This function is intended for efficient minting only during contract creation.
1844      *
1845      * It emits only one {ConsecutiveTransfer} as defined in
1846      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1847      * instead of a sequence of {Transfer} event(s).
1848      *
1849      * Calling this function outside of contract creation WILL make your contract
1850      * non-compliant with the ERC721 standard.
1851      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1852      * {ConsecutiveTransfer} event is only permissible during contract creation.
1853      *
1854      * Requirements:
1855      *
1856      * - `to` cannot be the zero address.
1857      * - `quantity` must be greater than 0.
1858      *
1859      * Emits a {ConsecutiveTransfer} event.
1860      */
1861     function _mintERC2309(address to, uint256 quantity) internal virtual {
1862         uint256 startTokenId = _currentIndex;
1863         if (to == address(0)) revert MintToZeroAddress();
1864         if (quantity == 0) revert MintZeroQuantity();
1865         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1866 
1867         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1868 
1869         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1870         unchecked {
1871             // Updates:
1872             // - `balance += quantity`.
1873             // - `numberMinted += quantity`.
1874             //
1875             // We can directly add to the `balance` and `numberMinted`.
1876             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1877 
1878             // Updates:
1879             // - `address` to the owner.
1880             // - `startTimestamp` to the timestamp of minting.
1881             // - `burned` to `false`.
1882             // - `nextInitialized` to `quantity == 1`.
1883             _packedOwnerships[startTokenId] = _packOwnershipData(
1884                 to,
1885                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1886             );
1887 
1888             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1889 
1890             _currentIndex = startTokenId + quantity;
1891         }
1892         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1893     }
1894 
1895     /**
1896      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1897      *
1898      * Requirements:
1899      *
1900      * - If `to` refers to a smart contract, it must implement
1901      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1902      * - `quantity` must be greater than 0.
1903      *
1904      * See {_mint}.
1905      *
1906      * Emits a {Transfer} event for each mint.
1907      */
1908     function _safeMint(
1909         address to,
1910         uint256 quantity,
1911         bytes memory _data
1912     ) internal virtual {
1913         _mint(to, quantity);
1914 
1915         unchecked {
1916             if (to.code.length != 0) {
1917                 uint256 end = _currentIndex;
1918                 uint256 index = end - quantity;
1919                 do {
1920                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1921                         revert TransferToNonERC721ReceiverImplementer();
1922                     }
1923                 } while (index < end);
1924                 // Reentrancy protection.
1925                 if (_currentIndex != end) revert();
1926             }
1927         }
1928     }
1929 
1930     /**
1931      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1932      */
1933     function _safeMint(address to, uint256 quantity) internal virtual {
1934         _safeMint(to, quantity, '');
1935     }
1936 
1937     // =============================================================
1938     //                        BURN OPERATIONS
1939     // =============================================================
1940 
1941     /**
1942      * @dev Equivalent to `_burn(tokenId, false)`.
1943      */
1944     function _burn(uint256 tokenId) internal virtual {
1945         _burn(tokenId, false);
1946     }
1947 
1948     /**
1949      * @dev Destroys `tokenId`.
1950      * The approval is cleared when the token is burned.
1951      *
1952      * Requirements:
1953      *
1954      * - `tokenId` must exist.
1955      *
1956      * Emits a {Transfer} event.
1957      */
1958     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1959         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1960 
1961         address from = address(uint160(prevOwnershipPacked));
1962 
1963         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1964 
1965         if (approvalCheck) {
1966             // The nested ifs save around 20+ gas over a compound boolean condition.
1967             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1968                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1969         }
1970 
1971         _beforeTokenTransfers(from, address(0), tokenId, 1);
1972 
1973         // Clear approvals from the previous owner.
1974         assembly {
1975             if approvedAddress {
1976                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1977                 sstore(approvedAddressSlot, 0)
1978             }
1979         }
1980 
1981         // Underflow of the sender's balance is impossible because we check for
1982         // ownership above and the recipient's balance can't realistically overflow.
1983         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1984         unchecked {
1985             // Updates:
1986             // - `balance -= 1`.
1987             // - `numberBurned += 1`.
1988             //
1989             // We can directly decrement the balance, and increment the number burned.
1990             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1991             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1992 
1993             // Updates:
1994             // - `address` to the last owner.
1995             // - `startTimestamp` to the timestamp of burning.
1996             // - `burned` to `true`.
1997             // - `nextInitialized` to `true`.
1998             _packedOwnerships[tokenId] = _packOwnershipData(
1999                 from,
2000                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2001             );
2002 
2003             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2004             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2005                 uint256 nextTokenId = tokenId + 1;
2006                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2007                 if (_packedOwnerships[nextTokenId] == 0) {
2008                     // If the next slot is within bounds.
2009                     if (nextTokenId != _currentIndex) {
2010                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2011                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2012                     }
2013                 }
2014             }
2015         }
2016 
2017         emit Transfer(from, address(0), tokenId);
2018         _afterTokenTransfers(from, address(0), tokenId, 1);
2019 
2020         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2021         unchecked {
2022             _burnCounter++;
2023         }
2024     }
2025 
2026     // =============================================================
2027     //                     EXTRA DATA OPERATIONS
2028     // =============================================================
2029 
2030     /**
2031      * @dev Directly sets the extra data for the ownership data `index`.
2032      */
2033     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2034         uint256 packed = _packedOwnerships[index];
2035         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2036         uint256 extraDataCasted;
2037         // Cast `extraData` with assembly to avoid redundant masking.
2038         assembly {
2039             extraDataCasted := extraData
2040         }
2041         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2042         _packedOwnerships[index] = packed;
2043     }
2044 
2045     /**
2046      * @dev Called during each token transfer to set the 24bit `extraData` field.
2047      * Intended to be overridden by the cosumer contract.
2048      *
2049      * `previousExtraData` - the value of `extraData` before transfer.
2050      *
2051      * Calling conditions:
2052      *
2053      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2054      * transferred to `to`.
2055      * - When `from` is zero, `tokenId` will be minted for `to`.
2056      * - When `to` is zero, `tokenId` will be burned by `from`.
2057      * - `from` and `to` are never both zero.
2058      */
2059     function _extraData(
2060         address from,
2061         address to,
2062         uint24 previousExtraData
2063     ) internal view virtual returns (uint24) {}
2064 
2065     /**
2066      * @dev Returns the next extra data for the packed ownership data.
2067      * The returned result is shifted into position.
2068      */
2069     function _nextExtraData(
2070         address from,
2071         address to,
2072         uint256 prevOwnershipPacked
2073     ) private view returns (uint256) {
2074         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2075         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2076     }
2077 
2078     // =============================================================
2079     //                       OTHER OPERATIONS
2080     // =============================================================
2081 
2082     /**
2083      * @dev Returns the message sender (defaults to `msg.sender`).
2084      *
2085      * If you are writing GSN compatible contracts, you need to override this function.
2086      */
2087     function _msgSenderERC721A() internal view virtual returns (address) {
2088         return msg.sender;
2089     }
2090 
2091     /**
2092      * @dev Converts a uint256 to its ASCII string decimal representation.
2093      */
2094     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2095         assembly {
2096             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2097             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2098             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2099             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2100             let m := add(mload(0x40), 0xa0)
2101             // Update the free memory pointer to allocate.
2102             mstore(0x40, m)
2103             // Assign the `str` to the end.
2104             str := sub(m, 0x20)
2105             // Zeroize the slot after the string.
2106             mstore(str, 0)
2107 
2108             // Cache the end of the memory to calculate the length later.
2109             let end := str
2110 
2111             // We write the string from rightmost digit to leftmost digit.
2112             // The following is essentially a do-while loop that also handles the zero case.
2113             // prettier-ignore
2114             for { let temp := value } 1 {} {
2115                 str := sub(str, 1)
2116                 // Write the character to the pointer.
2117                 // The ASCII index of the '0' character is 48.
2118                 mstore8(str, add(48, mod(temp, 10)))
2119                 // Keep dividing `temp` until zero.
2120                 temp := div(temp, 10)
2121                 // prettier-ignore
2122                 if iszero(temp) { break }
2123             }
2124 
2125             let length := sub(end, str)
2126             // Move the pointer 32 bytes leftwards to make room for the length.
2127             str := sub(str, 0x20)
2128             // Store the length.
2129             mstore(str, length)
2130         }
2131     }
2132 }
2133 
2134 // File: contracts/neonsenseis.sol
2135 
2136 
2137 
2138 pragma solidity ^0.8.0;
2139 
2140 contract neonsenseis is ERC721A, Ownable, ReentrancyGuard {
2141   using Address for address;
2142   using Strings for uint;
2143 
2144 
2145   string  public  baseTokenURI = "ipfs://bafybeifmdgzgyk4kxvespngwccxiihsz2xe5vpi6ewefekhdiaueuf5nwm/";
2146   uint256 public  maxSupply = 775;
2147   uint256 public  MAX_MINTS_PER_TX = 10;
2148   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether; //do not be stingy on real projects
2149   uint256 public  NUM_FREE_MINTS = 775;
2150   uint256 public  MAX_FREE_PER_WALLET = 1;
2151   uint256 public freeAlreadyMinted = 0;
2152   bool public isPublicSaleActive = false;
2153   constructor() ERC721A("neonsenseis", "NEOSEN") {
2154   }
2155 
2156 
2157   function mint(uint256 numberOfTokens)
2158       external
2159       payable
2160   {
2161     require(isPublicSaleActive, "Nope! Not yet, hold on");
2162     require(totalSupply() + numberOfTokens < maxSupply + 1, "too late mfer");
2163 
2164     if(freeAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
2165         require(
2166             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2167             "Incorrect ETH value sent"
2168         );
2169     } else {
2170         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
2171         require(
2172             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2173             "Incorrect ETH value sent"
2174         );
2175         require(
2176             numberOfTokens <= MAX_MINTS_PER_TX,
2177             "Max mints per transaction exceeded"
2178         );
2179         } else {
2180             require(
2181                 numberOfTokens <= MAX_FREE_PER_WALLET,
2182                 "Max mints per transaction exceeded"
2183             );
2184             freeAlreadyMinted += numberOfTokens;
2185         }
2186     }
2187     _safeMint(msg.sender, numberOfTokens);
2188   }
2189 
2190   function setBaseURI(string memory baseURI)
2191     public
2192     onlyOwner
2193   {
2194     baseTokenURI = baseURI;
2195   }
2196 
2197   function treasuryMint(uint quantity)
2198     public
2199     onlyOwner
2200   {
2201     require(
2202       quantity > 0,
2203       "Invalid mint amount"
2204     );
2205     require(
2206       totalSupply() + quantity <= maxSupply,
2207       "Maximum supply exceeded"
2208     );
2209     _safeMint(msg.sender, quantity);
2210   }
2211 
2212   function withdraw()
2213     public
2214     onlyOwner
2215     nonReentrant
2216   {
2217     Address.sendValue(payable(msg.sender), address(this).balance);
2218   }
2219 
2220   function _baseURI()
2221     internal
2222     view
2223     virtual
2224     override
2225     returns (string memory)
2226   {
2227     return baseTokenURI;
2228   }
2229 
2230   function setIsPublicSaleActive(bool _isPublicSaleActive)
2231       external
2232       onlyOwner
2233   {
2234       isPublicSaleActive = _isPublicSaleActive;
2235   }
2236 
2237   function setNumFreeMints(uint256 _numfreemints)
2238       external
2239       onlyOwner
2240   {
2241       NUM_FREE_MINTS = _numfreemints;
2242   }
2243 
2244   function setSalePrice(uint256 _price)
2245       external
2246       onlyOwner
2247   {
2248       PUBLIC_SALE_PRICE = _price;
2249   }
2250 
2251   function setMaxLimitPerTransaction(uint256 _limit)
2252       external
2253       onlyOwner
2254   {
2255       MAX_MINTS_PER_TX = _limit;
2256   }
2257 
2258   function setFreeLimitPerWallet(uint256 _limit)
2259       external
2260       onlyOwner
2261   {
2262       MAX_FREE_PER_WALLET = _limit;
2263   }
2264 }