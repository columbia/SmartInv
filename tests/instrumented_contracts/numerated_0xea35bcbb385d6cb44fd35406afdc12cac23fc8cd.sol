1 /*
2                     ____ 
3                   .'* *.'
4                __/_*_*(_
5               / _______ \
6              _\_)/___\(_/_ 
7             / _((\- -/))_ \
8             \ \())(-)(()/ /
9              ' \(((()))/ '
10             / ' \)).))/ ' \
11            / _ \ - | - /_  \
12           (   ( .;''';. .'  )
13           _\"__ /    )\ __"/_
14             \/  \   ' /  \/
15              .'  '...' ' )
16               / /  |  \ \
17              / .   .   . \
18             /   .     .   \
19            /   /   |   \   \
20          .'   /    b    '.  '.
21      _.-'    /     Bb     '-. '-._ 
22  _.-'       |      BBb       '-.  '-. 
23 (________mrf\____.dBBBb.________)____)
24 */
25 
26 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
27 
28 // SPDX-License-Identifier: MIT
29 
30 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module that helps prevent reentrant calls to a function.
36  *
37  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
38  * available, which can be applied to functions to make sure there are no nested
39  * (reentrant) calls to them.
40  *
41  * Note that because there is a single `nonReentrant` guard, functions marked as
42  * `nonReentrant` may not call one another. This can be worked around by making
43  * those functions `private`, and then adding `external` `nonReentrant` entry
44  * points to them.
45  *
46  * TIP: If you would like to learn more about reentrancy and alternative ways
47  * to protect against it, check out our blog post
48  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
49  */
50 abstract contract ReentrancyGuard {
51     // Booleans are more expensive than uint256 or any type that takes up a full
52     // word because each write operation emits an extra SLOAD to first read the
53     // slot's contents, replace the bits taken up by the boolean, and then write
54     // back. This is the compiler's defense against contract upgrades and
55     // pointer aliasing, and it cannot be disabled.
56 
57     // The values being non-zero value makes deployment a bit more expensive,
58     // but in exchange the refund on every call to nonReentrant will be lower in
59     // amount. Since refunds are capped to a percentage of the total
60     // transaction's gas, it is best to keep them low in cases like this one, to
61     // increase the likelihood of the full refund coming into effect.
62     uint256 private constant _NOT_ENTERED = 1;
63     uint256 private constant _ENTERED = 2;
64 
65     uint256 private _status;
66 
67     constructor() {
68         _status = _NOT_ENTERED;
69     }
70 
71     /**
72      * @dev Prevents a contract from calling itself, directly or indirectly.
73      * Calling a `nonReentrant` function from another `nonReentrant`
74      * function is not supported. It is possible to prevent this from happening
75      * by making the `nonReentrant` function external, and making it call a
76      * `private` function that does the actual work.
77      */
78     modifier nonReentrant() {
79         // On the first call to nonReentrant, _notEntered will be true
80         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
81 
82         // Any calls to nonReentrant after this point will fail
83         _status = _ENTERED;
84 
85         _;
86 
87         // By storing the original value once again, a refund is triggered (see
88         // https://eips.ethereum.org/EIPS/eip-2200)
89         _status = _NOT_ENTERED;
90     }
91 }
92 
93 // File: @openzeppelin/contracts/utils/Strings.sol
94 
95 
96 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev String operations.
102  */
103 library Strings {
104     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
108      */
109     function toString(uint256 value) internal pure returns (string memory) {
110         // Inspired by OraclizeAPI's implementation - MIT licence
111         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
112 
113         if (value == 0) {
114             return "0";
115         }
116         uint256 temp = value;
117         uint256 digits;
118         while (temp != 0) {
119             digits++;
120             temp /= 10;
121         }
122         bytes memory buffer = new bytes(digits);
123         while (value != 0) {
124             digits -= 1;
125             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
126             value /= 10;
127         }
128         return string(buffer);
129     }
130 
131     /**
132      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
133      */
134     function toHexString(uint256 value) internal pure returns (string memory) {
135         if (value == 0) {
136             return "0x00";
137         }
138         uint256 temp = value;
139         uint256 length = 0;
140         while (temp != 0) {
141             length++;
142             temp >>= 8;
143         }
144         return toHexString(value, length);
145     }
146 
147     /**
148      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
149      */
150     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
151         bytes memory buffer = new bytes(2 * length + 2);
152         buffer[0] = "0";
153         buffer[1] = "x";
154         for (uint256 i = 2 * length + 1; i > 1; --i) {
155             buffer[i] = _HEX_SYMBOLS[value & 0xf];
156             value >>= 4;
157         }
158         require(value == 0, "Strings: hex length insufficient");
159         return string(buffer);
160     }
161 }
162 
163 // File: @openzeppelin/contracts/utils/Context.sol
164 
165 
166 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
167 
168 pragma solidity ^0.8.0;
169 
170 /**
171  * @dev Provides information about the current execution context, including the
172  * sender of the transaction and its data. While these are generally available
173  * via msg.sender and msg.data, they should not be accessed in such a direct
174  * manner, since when dealing with meta-transactions the account sending and
175  * paying for execution may not be the actual sender (as far as an application
176  * is concerned).
177  *
178  * This contract is only required for intermediate, library-like contracts.
179  */
180 abstract contract Context {
181     function _msgSender() internal view virtual returns (address) {
182         return msg.sender;
183     }
184 
185     function _msgData() internal view virtual returns (bytes calldata) {
186         return msg.data;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/access/Ownable.sol
191 
192 
193 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
194 
195 pragma solidity ^0.8.0;
196 
197 
198 /**
199  * @dev Contract module which provides a basic access control mechanism, where
200  * there is an account (an owner) that can be granted exclusive access to
201  * specific functions.
202  *
203  * By default, the owner account will be the one that deploys the contract. This
204  * can later be changed with {transferOwnership}.
205  *
206  * This module is used through inheritance. It will make available the modifier
207  * `onlyOwner`, which can be applied to your functions to restrict their use to
208  * the owner.
209  */
210 abstract contract Ownable is Context {
211     address private _owner;
212 
213     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
214 
215     /**
216      * @dev Initializes the contract setting the deployer as the initial owner.
217      */
218     constructor() {
219         _transferOwnership(_msgSender());
220     }
221 
222     /**
223      * @dev Returns the address of the current owner.
224      */
225     function owner() public view virtual returns (address) {
226         return _owner;
227     }
228 
229     /**
230      * @dev Throws if called by any account other than the owner.
231      */
232     modifier onlyOwner() {
233         require(owner() == _msgSender(), "Ownable: caller is not the owner");
234         _;
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
271 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
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
481 
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
496 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
513      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
585 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
624      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
625      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
626      *
627      * Requirements:
628      *
629      * - `from` cannot be the zero address.
630      * - `to` cannot be the zero address.
631      * - `tokenId` token must exist and be owned by `from`.
632      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
633      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
634      *
635      * Emits a {Transfer} event.
636      */
637     function safeTransferFrom(
638         address from,
639         address to,
640         uint256 tokenId
641     ) external;
642 
643     /**
644      * @dev Transfers `tokenId` token from `from` to `to`.
645      *
646      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must be owned by `from`.
653      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
654      *
655      * Emits a {Transfer} event.
656      */
657     function transferFrom(
658         address from,
659         address to,
660         uint256 tokenId
661     ) external;
662 
663     /**
664      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
665      * The approval is cleared when the token is transferred.
666      *
667      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
668      *
669      * Requirements:
670      *
671      * - The caller must own the token or be an approved operator.
672      * - `tokenId` must exist.
673      *
674      * Emits an {Approval} event.
675      */
676     function approve(address to, uint256 tokenId) external;
677 
678     /**
679      * @dev Returns the account approved for `tokenId` token.
680      *
681      * Requirements:
682      *
683      * - `tokenId` must exist.
684      */
685     function getApproved(uint256 tokenId) external view returns (address operator);
686 
687     /**
688      * @dev Approve or remove `operator` as an operator for the caller.
689      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
690      *
691      * Requirements:
692      *
693      * - The `operator` cannot be the caller.
694      *
695      * Emits an {ApprovalForAll} event.
696      */
697     function setApprovalForAll(address operator, bool _approved) external;
698 
699     /**
700      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
701      *
702      * See {setApprovalForAll}
703      */
704     function isApprovedForAll(address owner, address operator) external view returns (bool);
705 
706     /**
707      * @dev Safely transfers `tokenId` token from `from` to `to`.
708      *
709      * Requirements:
710      *
711      * - `from` cannot be the zero address.
712      * - `to` cannot be the zero address.
713      * - `tokenId` token must exist and be owned by `from`.
714      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
715      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
716      *
717      * Emits a {Transfer} event.
718      */
719     function safeTransferFrom(
720         address from,
721         address to,
722         uint256 tokenId,
723         bytes calldata data
724     ) external;
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
756 // File: contracts/ERC721A.sol
757 
758 
759 // Creator: Chiru Labs
760 
761 pragma solidity ^0.8.4;
762 
763 
764 
765 
766 
767 
768 
769 
770 error ApprovalCallerNotOwnerNorApproved();
771 error ApprovalQueryForNonexistentToken();
772 error ApproveToCaller();
773 error ApprovalToCurrentOwner();
774 error BalanceQueryForZeroAddress();
775 error MintToZeroAddress();
776 error MintZeroQuantity();
777 error OwnerQueryForNonexistentToken();
778 error TransferCallerNotOwnerNorApproved();
779 error TransferFromIncorrectOwner();
780 error TransferToNonERC721ReceiverImplementer();
781 error TransferToZeroAddress();
782 error URIQueryForNonexistentToken();
783 
784 /**
785  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
786  * the Metadata extension. Built to optimize for lower gas during batch mints.
787  *
788  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
789  *
790  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
791  *
792  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
793  */
794 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
795     using Address for address;
796     using Strings for uint256;
797 
798     // Compiler will pack this into a single 256bit word.
799     struct TokenOwnership {
800         // The address of the owner.
801         address addr;
802         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
803         uint64 startTimestamp;
804         // Whether the token has been burned.
805         bool burned;
806     }
807 
808     // Compiler will pack this into a single 256bit word.
809     struct AddressData {
810         // Realistically, 2**64-1 is more than enough.
811         uint64 balance;
812         // Keeps track of mint count with minimal overhead for tokenomics.
813         uint64 numberMinted;
814         // Keeps track of burn count with minimal overhead for tokenomics.
815         uint64 numberBurned;
816         // For miscellaneous variable(s) pertaining to the address
817         // (e.g. number of whitelist mint slots used).
818         // If there are multiple variables, please pack them into a uint64.
819         uint64 aux;
820     }
821 
822     // The tokenId of the next token to be minted.
823     uint256 internal _currentIndex;
824 
825     // The number of tokens burned.
826     uint256 internal _burnCounter;
827 
828     // Token name
829     string private _name;
830 
831     // Token symbol
832     string private _symbol;
833 
834     // Mapping from token ID to ownership details
835     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
836     mapping(uint256 => TokenOwnership) internal _ownerships;
837 
838     // Mapping owner address to address data
839     mapping(address => AddressData) private _addressData;
840 
841     // Mapping from token ID to approved address
842     mapping(uint256 => address) private _tokenApprovals;
843 
844     // Mapping from owner to operator approvals
845     mapping(address => mapping(address => bool)) private _operatorApprovals;
846 
847     constructor(string memory name_, string memory symbol_) {
848         _name = name_;
849         _symbol = symbol_;
850         _currentIndex = _startTokenId();
851     }
852 
853     /**
854      * To change the starting tokenId, please override this function.
855      */
856     function _startTokenId() internal view virtual returns (uint256) {
857         return 1;
858     }
859 
860     /**
861      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
862      */
863     function totalSupply() public view returns (uint256) {
864         // Counter underflow is impossible as _burnCounter cannot be incremented
865         // more than _currentIndex - _startTokenId() times
866         unchecked {
867             return _currentIndex - _burnCounter - _startTokenId();
868         }
869     }
870 
871     /**
872      * Returns the total amount of tokens minted in the contract.
873      */
874     function _totalMinted() internal view returns (uint256) {
875         // Counter underflow is impossible as _currentIndex does not decrement,
876         // and it is initialized to _startTokenId()
877         unchecked {
878             return _currentIndex - _startTokenId();
879         }
880     }
881 
882     /**
883      * @dev See {IERC165-supportsInterface}.
884      */
885     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
886         return
887             interfaceId == type(IERC721).interfaceId ||
888             interfaceId == type(IERC721Metadata).interfaceId ||
889             super.supportsInterface(interfaceId);
890     }
891 
892     /**
893      * @dev See {IERC721-balanceOf}.
894      */
895     function balanceOf(address owner) public view override returns (uint256) {
896         if (owner == address(0)) revert BalanceQueryForZeroAddress();
897         return uint256(_addressData[owner].balance);
898     }
899 
900     /**
901      * Returns the number of tokens minted by `owner`.
902      */
903     function _numberMinted(address owner) internal view returns (uint256) {
904         return uint256(_addressData[owner].numberMinted);
905     }
906 
907     /**
908      * Returns the number of tokens burned by or on behalf of `owner`.
909      */
910     function _numberBurned(address owner) internal view returns (uint256) {
911         return uint256(_addressData[owner].numberBurned);
912     }
913 
914     /**
915      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
916      */
917     function _getAux(address owner) internal view returns (uint64) {
918         return _addressData[owner].aux;
919     }
920 
921     /**
922      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
923      * If there are multiple variables, please pack them into a uint64.
924      */
925     function _setAux(address owner, uint64 aux) internal {
926         _addressData[owner].aux = aux;
927     }
928 
929     /**
930      * Gas spent here starts off proportional to the maximum mint batch size.
931      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
932      */
933     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
934         uint256 curr = tokenId;
935 
936         unchecked {
937             if (_startTokenId() <= curr && curr < _currentIndex) {
938                 TokenOwnership memory ownership = _ownerships[curr];
939                 if (!ownership.burned) {
940                     if (ownership.addr != address(0)) {
941                         return ownership;
942                     }
943                     // Invariant:
944                     // There will always be an ownership that has an address and is not burned
945                     // before an ownership that does not have an address and is not burned.
946                     // Hence, curr will not underflow.
947                     while (true) {
948                         curr--;
949                         ownership = _ownerships[curr];
950                         if (ownership.addr != address(0)) {
951                             return ownership;
952                         }
953                     }
954                 }
955             }
956         }
957         revert OwnerQueryForNonexistentToken();
958     }
959 
960     /**
961      * @dev See {IERC721-ownerOf}.
962      */
963     function ownerOf(uint256 tokenId) public view override returns (address) {
964         return _ownershipOf(tokenId).addr;
965     }
966 
967     /**
968      * @dev See {IERC721Metadata-name}.
969      */
970     function name() public view virtual override returns (string memory) {
971         return _name;
972     }
973 
974     /**
975      * @dev See {IERC721Metadata-symbol}.
976      */
977     function symbol() public view virtual override returns (string memory) {
978         return _symbol;
979     }
980 
981     /**
982      * @dev See {IERC721Metadata-tokenURI}.
983      */
984     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
985         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
986 
987         string memory baseURI = _baseURI();
988         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
989     }
990 
991     /**
992      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
993      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
994      * by default, can be overriden in child contracts.
995      */
996     function _baseURI() internal view virtual returns (string memory) {
997         return '';
998     }
999 
1000     /**
1001      * @dev See {IERC721-approve}.
1002      */
1003     function approve(address to, uint256 tokenId) public override {
1004         address owner = ERC721A.ownerOf(tokenId);
1005         if (to == owner) revert ApprovalToCurrentOwner();
1006 
1007         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1008             revert ApprovalCallerNotOwnerNorApproved();
1009         }
1010 
1011         _approve(to, tokenId, owner);
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-getApproved}.
1016      */
1017     function getApproved(uint256 tokenId) public view override returns (address) {
1018         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1019 
1020         return _tokenApprovals[tokenId];
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-setApprovalForAll}.
1025      */
1026     function setApprovalForAll(address operator, bool approved) public virtual override {
1027         if (operator == _msgSender()) revert ApproveToCaller();
1028 
1029         _operatorApprovals[_msgSender()][operator] = approved;
1030         emit ApprovalForAll(_msgSender(), operator, approved);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-isApprovedForAll}.
1035      */
1036     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1037         return _operatorApprovals[owner][operator];
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-transferFrom}.
1042      */
1043     function transferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) public virtual override {
1048         _transfer(from, to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-safeTransferFrom}.
1053      */
1054     function safeTransferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) public virtual override {
1059         safeTransferFrom(from, to, tokenId, '');
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-safeTransferFrom}.
1064      */
1065     function safeTransferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes memory _data
1070     ) public virtual override {
1071         _transfer(from, to, tokenId);
1072         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1073             revert TransferToNonERC721ReceiverImplementer();
1074         }
1075     }
1076 
1077     /**
1078      * @dev Returns whether `tokenId` exists.
1079      *
1080      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1081      *
1082      * Tokens start existing when they are minted (`_mint`),
1083      */
1084     function _exists(uint256 tokenId) internal view returns (bool) {
1085         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1086     }
1087 
1088     /**
1089      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1090      */
1091     function _safeMint(address to, uint256 quantity) internal {
1092         _safeMint(to, quantity, '');
1093     }
1094 
1095     /**
1096      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1097      *
1098      * Requirements:
1099      *
1100      * - If `to` refers to a smart contract, it must implement 
1101      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1102      * - `quantity` must be greater than 0.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function _safeMint(
1107         address to,
1108         uint256 quantity,
1109         bytes memory _data
1110     ) internal {
1111         uint256 startTokenId = _currentIndex;
1112         if (to == address(0)) revert MintToZeroAddress();
1113         if (quantity == 0) revert MintZeroQuantity();
1114 
1115         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1116 
1117         // Overflows are incredibly unrealistic.
1118         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1119         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1120         unchecked {
1121             _addressData[to].balance += uint64(quantity);
1122             _addressData[to].numberMinted += uint64(quantity);
1123 
1124             _ownerships[startTokenId].addr = to;
1125             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1126 
1127             uint256 updatedIndex = startTokenId;
1128             uint256 end = updatedIndex + quantity;
1129 
1130             if (to.isContract()) {
1131                 do {
1132                     emit Transfer(address(0), to, updatedIndex);
1133                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1134                         revert TransferToNonERC721ReceiverImplementer();
1135                     }
1136                 } while (updatedIndex != end);
1137                 // Reentrancy protection
1138                 if (_currentIndex != startTokenId) revert();
1139             } else {
1140                 do {
1141                     emit Transfer(address(0), to, updatedIndex++);
1142                 } while (updatedIndex != end);
1143             }
1144             _currentIndex = updatedIndex;
1145         }
1146         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1147     }
1148 
1149     /**
1150      * @dev Mints `quantity` tokens and transfers them to `to`.
1151      *
1152      * Requirements:
1153      *
1154      * - `to` cannot be the zero address.
1155      * - `quantity` must be greater than 0.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _mint(address to, uint256 quantity) internal {
1160         uint256 startTokenId = _currentIndex;
1161         if (to == address(0)) revert MintToZeroAddress();
1162         if (quantity == 0) revert MintZeroQuantity();
1163 
1164         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1165 
1166         // Overflows are incredibly unrealistic.
1167         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1168         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1169         unchecked {
1170             _addressData[to].balance += uint64(quantity);
1171             _addressData[to].numberMinted += uint64(quantity);
1172 
1173             _ownerships[startTokenId].addr = to;
1174             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1175 
1176             uint256 updatedIndex = startTokenId;
1177             uint256 end = updatedIndex + quantity;
1178 
1179             do {
1180                 emit Transfer(address(0), to, updatedIndex++);
1181             } while (updatedIndex != end);
1182 
1183             _currentIndex = updatedIndex;
1184         }
1185         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1186     }
1187 
1188     /**
1189      * @dev Transfers `tokenId` from `from` to `to`.
1190      *
1191      * Requirements:
1192      *
1193      * - `to` cannot be the zero address.
1194      * - `tokenId` token must be owned by `from`.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function _transfer(
1199         address from,
1200         address to,
1201         uint256 tokenId
1202     ) private {
1203         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1204 
1205         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1206 
1207         bool isApprovedOrOwner = (_msgSender() == from ||
1208             isApprovedForAll(from, _msgSender()) ||
1209             getApproved(tokenId) == _msgSender());
1210 
1211         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1212         if (to == address(0)) revert TransferToZeroAddress();
1213 
1214         _beforeTokenTransfers(from, to, tokenId, 1);
1215 
1216         // Clear approvals from the previous owner
1217         _approve(address(0), tokenId, from);
1218 
1219         // Underflow of the sender's balance is impossible because we check for
1220         // ownership above and the recipient's balance can't realistically overflow.
1221         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1222         unchecked {
1223             _addressData[from].balance -= 1;
1224             _addressData[to].balance += 1;
1225 
1226             TokenOwnership storage currSlot = _ownerships[tokenId];
1227             currSlot.addr = to;
1228             currSlot.startTimestamp = uint64(block.timestamp);
1229 
1230             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1231             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1232             uint256 nextTokenId = tokenId + 1;
1233             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1234             if (nextSlot.addr == address(0)) {
1235                 // This will suffice for checking _exists(nextTokenId),
1236                 // as a burned slot cannot contain the zero address.
1237                 if (nextTokenId != _currentIndex) {
1238                     nextSlot.addr = from;
1239                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1240                 }
1241             }
1242         }
1243 
1244         emit Transfer(from, to, tokenId);
1245         _afterTokenTransfers(from, to, tokenId, 1);
1246     }
1247 
1248     /**
1249      * @dev Equivalent to `_burn(tokenId, false)`.
1250      */
1251     function _burn(uint256 tokenId) internal virtual {
1252         _burn(tokenId, false);
1253     }
1254 
1255     /**
1256      * @dev Destroys `tokenId`.
1257      * The approval is cleared when the token is burned.
1258      *
1259      * Requirements:
1260      *
1261      * - `tokenId` must exist.
1262      *
1263      * Emits a {Transfer} event.
1264      */
1265     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1266         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1267 
1268         address from = prevOwnership.addr;
1269 
1270         if (approvalCheck) {
1271             bool isApprovedOrOwner = (_msgSender() == from ||
1272                 isApprovedForAll(from, _msgSender()) ||
1273                 getApproved(tokenId) == _msgSender());
1274 
1275             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1276         }
1277 
1278         _beforeTokenTransfers(from, address(0), tokenId, 1);
1279 
1280         // Clear approvals from the previous owner
1281         _approve(address(0), tokenId, from);
1282 
1283         // Underflow of the sender's balance is impossible because we check for
1284         // ownership above and the recipient's balance can't realistically overflow.
1285         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1286         unchecked {
1287             AddressData storage addressData = _addressData[from];
1288             addressData.balance -= 1;
1289             addressData.numberBurned += 1;
1290 
1291             // Keep track of who burned the token, and the timestamp of burning.
1292             TokenOwnership storage currSlot = _ownerships[tokenId];
1293             currSlot.addr = from;
1294             currSlot.startTimestamp = uint64(block.timestamp);
1295             currSlot.burned = true;
1296 
1297             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1298             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1299             uint256 nextTokenId = tokenId + 1;
1300             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1301             if (nextSlot.addr == address(0)) {
1302                 // This will suffice for checking _exists(nextTokenId),
1303                 // as a burned slot cannot contain the zero address.
1304                 if (nextTokenId != _currentIndex) {
1305                     nextSlot.addr = from;
1306                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1307                 }
1308             }
1309         }
1310 
1311         emit Transfer(from, address(0), tokenId);
1312         _afterTokenTransfers(from, address(0), tokenId, 1);
1313 
1314         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1315         unchecked {
1316             _burnCounter++;
1317         }
1318     }
1319 
1320     /**
1321      * @dev Approve `to` to operate on `tokenId`
1322      *
1323      * Emits a {Approval} event.
1324      */
1325     function _approve(
1326         address to,
1327         uint256 tokenId,
1328         address owner
1329     ) private {
1330         _tokenApprovals[tokenId] = to;
1331         emit Approval(owner, to, tokenId);
1332     }
1333 
1334     /**
1335      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1336      *
1337      * @param from address representing the previous owner of the given token ID
1338      * @param to target address that will receive the tokens
1339      * @param tokenId uint256 ID of the token to be transferred
1340      * @param _data bytes optional data to send along with the call
1341      * @return bool whether the call correctly returned the expected magic value
1342      */
1343     function _checkContractOnERC721Received(
1344         address from,
1345         address to,
1346         uint256 tokenId,
1347         bytes memory _data
1348     ) private returns (bool) {
1349         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1350             return retval == IERC721Receiver(to).onERC721Received.selector;
1351         } catch (bytes memory reason) {
1352             if (reason.length == 0) {
1353                 revert TransferToNonERC721ReceiverImplementer();
1354             } else {
1355                 assembly {
1356                     revert(add(32, reason), mload(reason))
1357                 }
1358             }
1359         }
1360     }
1361 
1362     /**
1363      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1364      * And also called before burning one token.
1365      *
1366      * startTokenId - the first token id to be transferred
1367      * quantity - the amount to be transferred
1368      *
1369      * Calling conditions:
1370      *
1371      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1372      * transferred to `to`.
1373      * - When `from` is zero, `tokenId` will be minted for `to`.
1374      * - When `to` is zero, `tokenId` will be burned by `from`.
1375      * - `from` and `to` are never both zero.
1376      */
1377     function _beforeTokenTransfers(
1378         address from,
1379         address to,
1380         uint256 startTokenId,
1381         uint256 quantity
1382     ) internal virtual {}
1383 
1384     /**
1385      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1386      * minting.
1387      * And also called after one token has been burned.
1388      *
1389      * startTokenId - the first token id to be transferred
1390      * quantity - the amount to be transferred
1391      *
1392      * Calling conditions:
1393      *
1394      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1395      * transferred to `to`.
1396      * - When `from` is zero, `tokenId` has been minted for `to`.
1397      * - When `to` is zero, `tokenId` has been burned by `from`.
1398      * - `from` and `to` are never both zero.
1399      */
1400     function _afterTokenTransfers(
1401         address from,
1402         address to,
1403         uint256 startTokenId,
1404         uint256 quantity
1405     ) internal virtual {}
1406 }
1407 
1408 
1409 
1410 pragma solidity ^0.8.0;
1411 
1412 
1413 
1414 
1415 
1416 contract eternalwitches is ERC721A, Ownable, ReentrancyGuard {
1417   using Address for address;
1418   using Strings for uint;
1419 
1420 
1421   string  public  baseTokenURI = "";
1422   uint256 public  maxSupply = 3333;
1423   uint256 public  MAX_MINTS_PER_TX = 10;
1424   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether;
1425   uint256 public  NUM_FREE_MINTS = 3333;
1426   uint256 public  MAX_FREE_PER_WALLET = 10;
1427   uint256 public freeNFTAlreadyMinted = 0;
1428   bool public isPublicSaleActive = false;
1429 
1430   constructor(
1431 
1432   ) ERC721A("eternalwitches", "ETERNALWITCH") {
1433 
1434   }
1435 
1436 
1437   function mint(uint256 numberOfTokens)
1438       external
1439       payable
1440   {
1441     require(isPublicSaleActive, "Public sale is not open");
1442     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1443 
1444     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1445         require(
1446             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1447             "Incorrect ETH value sent"
1448         );
1449     } else {
1450         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1451         require(
1452             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1453             "Incorrect ETH value sent"
1454         );
1455         require(
1456             numberOfTokens <= MAX_MINTS_PER_TX,
1457             "Max mints per transaction exceeded"
1458         );
1459         } else {
1460             require(
1461                 numberOfTokens <= MAX_FREE_PER_WALLET,
1462                 "Max mints per transaction exceeded"
1463             );
1464             freeNFTAlreadyMinted += numberOfTokens;
1465         }
1466     }
1467     _safeMint(msg.sender, numberOfTokens);
1468   }
1469 
1470   function setBaseURI(string memory baseURI)
1471     public
1472     onlyOwner
1473   {
1474     baseTokenURI = baseURI;
1475   }
1476 
1477   function treasuryMint(uint quantity)
1478     public
1479     onlyOwner
1480   {
1481     require(
1482       quantity > 0,
1483       "Invalid mint amount"
1484     );
1485     require(
1486       totalSupply() + quantity <= maxSupply,
1487       "Maximum supply exceeded"
1488     );
1489     _safeMint(msg.sender, quantity);
1490   }
1491 
1492   function withdraw()
1493     public
1494     onlyOwner
1495     nonReentrant
1496   {
1497     Address.sendValue(payable(msg.sender), address(this).balance);
1498   }
1499 
1500   function tokenURI(uint _tokenId)
1501     public
1502     view
1503     virtual
1504     override
1505     returns (string memory)
1506   {
1507     require(
1508       _exists(_tokenId),
1509       "ERC721Metadata: URI query for nonexistent token"
1510     );
1511     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1512   }
1513 
1514   function _baseURI()
1515     internal
1516     view
1517     virtual
1518     override
1519     returns (string memory)
1520   {
1521     return baseTokenURI;
1522   }
1523 
1524   function setIsPublicSaleActive(bool _isPublicSaleActive)
1525       external
1526       onlyOwner
1527   {
1528       isPublicSaleActive = _isPublicSaleActive;
1529   }
1530 
1531   function setNumFreeMints(uint256 _numfreemints)
1532       external
1533       onlyOwner
1534   {
1535       NUM_FREE_MINTS = _numfreemints;
1536   }
1537 
1538   function setSalePrice(uint256 _price)
1539       external
1540       onlyOwner
1541   {
1542       PUBLIC_SALE_PRICE = _price;
1543   }
1544 
1545   function setMaxLimitPerTransaction(uint256 _limit)
1546       external
1547       onlyOwner
1548   {
1549       MAX_MINTS_PER_TX = _limit;
1550   }
1551 
1552   function setFreeLimitPerWallet(uint256 _limit)
1553       external
1554       onlyOwner
1555   {
1556       MAX_FREE_PER_WALLET = _limit;
1557   }
1558 }