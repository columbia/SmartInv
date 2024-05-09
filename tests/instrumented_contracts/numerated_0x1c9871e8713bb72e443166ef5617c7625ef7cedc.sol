1 /**
2 */
3 
4 /**
5 
6 
7  ____  _ ___  _ _____ _       ____  _____ _     _____ ____  ____  _  _____ ___  _   ____  _     _     ____ 
8 /  __\/ \\  \///  __// \     /   _\/  __// \   /  __//  _ \/  __\/ \/__ __\\  \//  /   _\/ \   / \ /\/  _ \
9 |  \/|| | \  / |  \  | |     |  /  |  \  | |   |  \  | | //|  \/|| |  / \   \  /   |  /  | |   | | ||| | //
10 |  __/| | /  \ |  /_ | |_/\  |  \__|  /_ | |_/\|  /_ | |_\\|    /| |  | |   / /    |  \__| |_/\| \_/|| |_\\
11 \_/   \_//__/\\\____\\____/  \____/\____\\____/\____\\____/\_/\_\\_/  \_/  /_/     \____/\____/\____/\____/                                                                                                                                                            
12                                                                                                                                                                                                               
13                                                                                                                                                                                                               
14 
15                                                                                                                            
16 
17 */
18 
19 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
20 
21 // SPDX-License-Identifier: MIT
22 
23 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Contract module that helps prevent reentrant calls to a function.
29  *
30  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
31  * available, which can be applied to functions to make sure there are no nested
32  * (reentrant) calls to them.
33  *
34  * Note that because there is a single `nonReentrant` guard, functions marked as
35  * `nonReentrant` may not call one another. This can be worked around by making
36  * those functions `private`, and then adding `external` `nonReentrant` entry
37  * points to them.
38  *
39  * TIP: If you would like to learn more about reentrancy and alternative ways
40  * to protect against it, check out our blog post
41  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
42  */
43 abstract contract ReentrancyGuard {
44     // Booleans are more expensive than uint256 or any type that takes up a full
45     // word because each write operation emits an extra SLOAD to first read the
46     // slot's contents, replace the bits taken up by the boolean, and then write
47     // back. This is the compiler's defense against contract upgrades and
48     // pointer aliasing, and it cannot be disabled.
49 
50     // The values being non-zero value makes deployment a bit more expensive,
51     // but in exchange the refund on every call to nonReentrant will be lower in
52     // amount. Since refunds are capped to a percentage of the total
53     // transaction's gas, it is best to keep them low in cases like this one, to
54     // increase the likelihood of the full refund coming into effect.
55     uint256 private constant _NOT_ENTERED = 1;
56     uint256 private constant _ENTERED = 2;
57 
58     uint256 private _status;
59 
60     constructor() {
61         _status = _NOT_ENTERED;
62     }
63 
64     /**
65      * @dev Prevents a contract from calling itself, directly or indirectly.
66      * Calling a `nonReentrant` function from another `nonReentrant`
67      * function is not supported. It is possible to prevent this from happening
68      * by making the `nonReentrant` function external, and making it call a
69      * `private` function that does the actual work.
70      */
71     modifier nonReentrant() {
72         // On the first call to nonReentrant, _notEntered will be true
73         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
74 
75         // Any calls to nonReentrant after this point will fail
76         _status = _ENTERED;
77 
78         _;
79 
80         // By storing the original value once again, a refund is triggered (see
81         // https://eips.ethereum.org/EIPS/eip-2200)
82         _status = _NOT_ENTERED;
83     }
84 }
85 
86 // File: @openzeppelin/contracts/utils/Strings.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev String operations.
95  */
96 library Strings {
97     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
101      */
102     function toString(uint256 value) internal pure returns (string memory) {
103         // Inspired by OraclizeAPI's implementation - MIT licence
104         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
105 
106         if (value == 0) {
107             return "0";
108         }
109         uint256 temp = value;
110         uint256 digits;
111         while (temp != 0) {
112             digits++;
113             temp /= 10;
114         }
115         bytes memory buffer = new bytes(digits);
116         while (value != 0) {
117             digits -= 1;
118             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
119             value /= 10;
120         }
121         return string(buffer);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
126      */
127     function toHexString(uint256 value) internal pure returns (string memory) {
128         if (value == 0) {
129             return "0x00";
130         }
131         uint256 temp = value;
132         uint256 length = 0;
133         while (temp != 0) {
134             length++;
135             temp >>= 8;
136         }
137         return toHexString(value, length);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
142      */
143     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
144         bytes memory buffer = new bytes(2 * length + 2);
145         buffer[0] = "0";
146         buffer[1] = "x";
147         for (uint256 i = 2 * length + 1; i > 1; --i) {
148             buffer[i] = _HEX_SYMBOLS[value & 0xf];
149             value >>= 4;
150         }
151         require(value == 0, "Strings: hex length insufficient");
152         return string(buffer);
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
186 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
216      * @dev Returns the address of the current owner.
217      */
218     function owner() public view virtual returns (address) {
219         return _owner;
220     }
221 
222     /**
223      * @dev Throws if called by any account other than the owner.
224      */
225     modifier onlyOwner() {
226         require(owner() == _msgSender(), "Ownable: caller is not the owner");
227         _;
228     }
229 
230     /**
231      * @dev Leaves the contract without owner. It will not be possible to call
232      * `onlyOwner` functions anymore. Can only be called by the current owner.
233      *
234      * NOTE: Renouncing ownership will leave the contract without an owner,
235      * thereby removing any functionality that is only available to the owner.
236      */
237     function renounceOwnership() public virtual onlyOwner {
238         _transferOwnership(address(0));
239     }
240 
241     /**
242      * @dev Transfers ownership of the contract to a new account (`newOwner`).
243      * Can only be called by the current owner.
244      */
245     function transferOwnership(address newOwner) public virtual onlyOwner {
246         require(newOwner != address(0), "Ownable: new owner is the zero address");
247         _transferOwnership(newOwner);
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Internal function without access restriction.
253      */
254     function _transferOwnership(address newOwner) internal virtual {
255         address oldOwner = _owner;
256         _owner = newOwner;
257         emit OwnershipTransferred(oldOwner, newOwner);
258     }
259 }
260 
261 // File: @openzeppelin/contracts/utils/Address.sol
262 
263 
264 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
265 
266 pragma solidity ^0.8.1;
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      *
289      * [IMPORTANT]
290      * ====
291      * You shouldn't rely on `isContract` to protect against flash loan attacks!
292      *
293      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
294      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
295      * constructor.
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies on extcodesize/address.code.length, which returns 0
300         // for contracts in construction, since the code is only stored at the end
301         // of the constructor execution.
302 
303         return account.code.length > 0;
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         (bool success, ) = recipient.call{value: amount}("");
326         require(success, "Address: unable to send value, recipient may have reverted");
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain `call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
348         return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(
377         address target,
378         bytes memory data,
379         uint256 value
380     ) internal returns (bytes memory) {
381         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
386      * with `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(
391         address target,
392         bytes memory data,
393         uint256 value,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         require(address(this).balance >= value, "Address: insufficient balance for call");
397         require(isContract(target), "Address: call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.call{value: value}(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a static call.
406      *
407      * _Available since v3.3._
408      */
409     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
410         return functionStaticCall(target, data, "Address: low-level static call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a static call.
416      *
417      * _Available since v3.3._
418      */
419     function functionStaticCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal view returns (bytes memory) {
424         require(isContract(target), "Address: static call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.staticcall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a delegate call.
433      *
434      * _Available since v3.4._
435      */
436     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
437         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
442      * but performing a delegate call.
443      *
444      * _Available since v3.4._
445      */
446     function functionDelegateCall(
447         address target,
448         bytes memory data,
449         string memory errorMessage
450     ) internal returns (bytes memory) {
451         require(isContract(target), "Address: delegate call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.delegatecall(data);
454         return verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
459      * revert reason using the provided one.
460      *
461      * _Available since v4.3._
462      */
463     function verifyCallResult(
464         bool success,
465         bytes memory returndata,
466         string memory errorMessage
467     ) internal pure returns (bytes memory) {
468         if (success) {
469             return returndata;
470         } else {
471             // Look for revert reason and bubble it up if present
472             if (returndata.length > 0) {
473                 // The easiest way to bubble the revert reason is using memory via assembly
474 
475                 assembly {
476                     let returndata_size := mload(returndata)
477                     revert(add(32, returndata), returndata_size)
478                 }
479             } else {
480                 revert(errorMessage);
481             }
482         }
483     }
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @title ERC721 token receiver interface
495  * @dev Interface for any contract that wants to support safeTransfers
496  * from ERC721 asset contracts.
497  */
498 interface IERC721Receiver {
499     /**
500      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
501      * by `operator` from `from`, this function is called.
502      *
503      * It must return its Solidity selector to confirm the token transfer.
504      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
505      *
506      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
507      */
508     function onERC721Received(
509         address operator,
510         address from,
511         uint256 tokenId,
512         bytes calldata data
513     ) external returns (bytes4);
514 }
515 
516 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
517 
518 
519 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @dev Interface of the ERC165 standard, as defined in the
525  * https://eips.ethereum.org/EIPS/eip-165[EIP].
526  *
527  * Implementers can declare support of contract interfaces, which can then be
528  * queried by others ({ERC165Checker}).
529  *
530  * For an implementation, see {ERC165}.
531  */
532 interface IERC165 {
533     /**
534      * @dev Returns true if this contract implements the interface defined by
535      * `interfaceId`. See the corresponding
536      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
537      * to learn more about how these ids are created.
538      *
539      * This function call must use less than 30 000 gas.
540      */
541     function supportsInterface(bytes4 interfaceId) external view returns (bool);
542 }
543 
544 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 
552 /**
553  * @dev Implementation of the {IERC165} interface.
554  *
555  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
556  * for the additional interface id that will be supported. For example:
557  *
558  * ```solidity
559  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
560  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
561  * }
562  * ```
563  *
564  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
565  */
566 abstract contract ERC165 is IERC165 {
567     /**
568      * @dev See {IERC165-supportsInterface}.
569      */
570     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
571         return interfaceId == type(IERC165).interfaceId;
572     }
573 }
574 
575 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
576 
577 
578 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
579 
580 pragma solidity ^0.8.0;
581 
582 
583 /**
584  * @dev Required interface of an ERC721 compliant contract.
585  */
586 interface IERC721 is IERC165 {
587     /**
588      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
589      */
590     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
591 
592     /**
593      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
594      */
595     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
596 
597     /**
598      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
599      */
600     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
601 
602     /**
603      * @dev Returns the number of tokens in ``owner``'s account.
604      */
605     function balanceOf(address owner) external view returns (uint256 balance);
606 
607     /**
608      * @dev Returns the owner of the `tokenId` token.
609      *
610      * Requirements:
611      *
612      * - `tokenId` must exist.
613      */
614     function ownerOf(uint256 tokenId) external view returns (address owner);
615 
616     /**
617      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
618      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must exist and be owned by `from`.
625      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
626      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
627      *
628      * Emits a {Transfer} event.
629      */
630     function safeTransferFrom(
631         address from,
632         address to,
633         uint256 tokenId
634     ) external;
635 
636     /**
637      * @dev Transfers `tokenId` token from `from` to `to`.
638      *
639      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
640      *
641      * Requirements:
642      *
643      * - `from` cannot be the zero address.
644      * - `to` cannot be the zero address.
645      * - `tokenId` token must be owned by `from`.
646      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
647      *
648      * Emits a {Transfer} event.
649      */
650     function transferFrom(
651         address from,
652         address to,
653         uint256 tokenId
654     ) external;
655 
656     /**
657      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
658      * The approval is cleared when the token is transferred.
659      *
660      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
661      *
662      * Requirements:
663      *
664      * - The caller must own the token or be an approved operator.
665      * - `tokenId` must exist.
666      *
667      * Emits an {Approval} event.
668      */
669     function approve(address to, uint256 tokenId) external;
670 
671     /**
672      * @dev Returns the account approved for `tokenId` token.
673      *
674      * Requirements:
675      *
676      * - `tokenId` must exist.
677      */
678     function getApproved(uint256 tokenId) external view returns (address operator);
679 
680     /**
681      * @dev Approve or remove `operator` as an operator for the caller.
682      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
683      *
684      * Requirements:
685      *
686      * - The `operator` cannot be the caller.
687      *
688      * Emits an {ApprovalForAll} event.
689      */
690     function setApprovalForAll(address operator, bool _approved) external;
691 
692     /**
693      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
694      *
695      * See {setApprovalForAll}
696      */
697     function isApprovedForAll(address owner, address operator) external view returns (bool);
698 
699     /**
700      * @dev Safely transfers `tokenId` token from `from` to `to`.
701      *
702      * Requirements:
703      *
704      * - `from` cannot be the zero address.
705      * - `to` cannot be the zero address.
706      * - `tokenId` token must exist and be owned by `from`.
707      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
708      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
709      *
710      * Emits a {Transfer} event.
711      */
712     function safeTransferFrom(
713         address from,
714         address to,
715         uint256 tokenId,
716         bytes calldata data
717     ) external;
718 }
719 
720 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
721 
722 
723 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
724 
725 pragma solidity ^0.8.0;
726 
727 
728 /**
729  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
730  * @dev See https://eips.ethereum.org/EIPS/eip-721
731  */
732 interface IERC721Metadata is IERC721 {
733     /**
734      * @dev Returns the token collection name.
735      */
736     function name() external view returns (string memory);
737 
738     /**
739      * @dev Returns the token collection symbol.
740      */
741     function symbol() external view returns (string memory);
742 
743     /**
744      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
745      */
746     function tokenURI(uint256 tokenId) external view returns (string memory);
747 }
748 
749 // File: contracts/ERC721A.sol
750 
751 
752 // Creator: Chiru Labs
753 
754 pragma solidity ^0.8.4;
755 
756 
757 
758 
759 
760 
761 
762 
763 error ApprovalCallerNotOwnerNorApproved();
764 error ApprovalQueryForNonexistentToken();
765 error ApproveToCaller();
766 error ApprovalToCurrentOwner();
767 error BalanceQueryForZeroAddress();
768 error MintToZeroAddress();
769 error MintZeroQuantity();
770 error OwnerQueryForNonexistentToken();
771 error TransferCallerNotOwnerNorApproved();
772 error TransferFromIncorrectOwner();
773 error TransferToNonERC721ReceiverImplementer();
774 error TransferToZeroAddress();
775 error URIQueryForNonexistentToken();
776 
777 /**
778  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
779  * the Metadata extension. Built to optimize for lower gas during batch mints.
780  *
781  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
782  *
783  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
784  *
785  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
786  */
787 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
788     using Address for address;
789     using Strings for uint256;
790 
791     // Compiler will pack this into a single 256bit word.
792     struct TokenOwnership {
793         // The address of the owner.
794         address addr;
795         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
796         uint64 startTimestamp;
797         // Whether the token has been burned.
798         bool burned;
799     }
800 
801     // Compiler will pack this into a single 256bit word.
802     struct AddressData {
803         // Realistically, 2**64-1 is more than enough.
804         uint64 balance;
805         // Keeps track of mint count with minimal overhead for tokenomics.
806         uint64 numberMinted;
807         // Keeps track of burn count with minimal overhead for tokenomics.
808         uint64 numberBurned;
809         // For miscellaneous variable(s) pertaining to the address
810         // (e.g. number of whitelist mint slots used).
811         // If there are multiple variables, please pack them into a uint64.
812         uint64 aux;
813     }
814 
815     // The tokenId of the next token to be minted.
816     uint256 internal _currentIndex;
817 
818     // The number of tokens burned.
819     uint256 internal _burnCounter;
820 
821     // Token name
822     string private _name;
823 
824     // Token symbol
825     string private _symbol;
826 
827     // Mapping from token ID to ownership details
828     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
829     mapping(uint256 => TokenOwnership) internal _ownerships;
830 
831     // Mapping owner address to address data
832     mapping(address => AddressData) private _addressData;
833 
834     // Mapping from token ID to approved address
835     mapping(uint256 => address) private _tokenApprovals;
836 
837     // Mapping from owner to operator approvals
838     mapping(address => mapping(address => bool)) private _operatorApprovals;
839 
840     constructor(string memory name_, string memory symbol_) {
841         _name = name_;
842         _symbol = symbol_;
843         _currentIndex = _startTokenId();
844     }
845 
846     /**
847      * To change the starting tokenId, please override this function.
848      */
849     function _startTokenId() internal view virtual returns (uint256) {
850         return 1;
851     }
852 
853     /**
854      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
855      */
856     function totalSupply() public view returns (uint256) {
857         // Counter underflow is impossible as _burnCounter cannot be incremented
858         // more than _currentIndex - _startTokenId() times
859         unchecked {
860             return _currentIndex - _burnCounter - _startTokenId();
861         }
862     }
863 
864     /**
865      * Returns the total amount of tokens minted in the contract.
866      */
867     function _totalMinted() internal view returns (uint256) {
868         // Counter underflow is impossible as _currentIndex does not decrement,
869         // and it is initialized to _startTokenId()
870         unchecked {
871             return _currentIndex - _startTokenId();
872         }
873     }
874 
875     /**
876      * @dev See {IERC165-supportsInterface}.
877      */
878     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
879         return
880             interfaceId == type(IERC721).interfaceId ||
881             interfaceId == type(IERC721Metadata).interfaceId ||
882             super.supportsInterface(interfaceId);
883     }
884 
885     /**
886      * @dev See {IERC721-balanceOf}.
887      */
888     function balanceOf(address owner) public view override returns (uint256) {
889         if (owner == address(0)) revert BalanceQueryForZeroAddress();
890         return uint256(_addressData[owner].balance);
891     }
892 
893     /**
894      * Returns the number of tokens minted by `owner`.
895      */
896     function _numberMinted(address owner) internal view returns (uint256) {
897         return uint256(_addressData[owner].numberMinted);
898     }
899 
900     /**
901      * Returns the number of tokens burned by or on behalf of `owner`.
902      */
903     function _numberBurned(address owner) internal view returns (uint256) {
904         return uint256(_addressData[owner].numberBurned);
905     }
906 
907     /**
908      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
909      */
910     function _getAux(address owner) internal view returns (uint64) {
911         return _addressData[owner].aux;
912     }
913 
914     /**
915      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
916      * If there are multiple variables, please pack them into a uint64.
917      */
918     function _setAux(address owner, uint64 aux) internal {
919         _addressData[owner].aux = aux;
920     }
921 
922     /**
923      * Gas spent here starts off proportional to the maximum mint batch size.
924      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
925      */
926     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
927         uint256 curr = tokenId;
928 
929         unchecked {
930             if (_startTokenId() <= curr && curr < _currentIndex) {
931                 TokenOwnership memory ownership = _ownerships[curr];
932                 if (!ownership.burned) {
933                     if (ownership.addr != address(0)) {
934                         return ownership;
935                     }
936                     // Invariant:
937                     // There will always be an ownership that has an address and is not burned
938                     // before an ownership that does not have an address and is not burned.
939                     // Hence, curr will not underflow.
940                     while (true) {
941                         curr--;
942                         ownership = _ownerships[curr];
943                         if (ownership.addr != address(0)) {
944                             return ownership;
945                         }
946                     }
947                 }
948             }
949         }
950         revert OwnerQueryForNonexistentToken();
951     }
952 
953     /**
954      * @dev See {IERC721-ownerOf}.
955      */
956     function ownerOf(uint256 tokenId) public view override returns (address) {
957         return _ownershipOf(tokenId).addr;
958     }
959 
960     /**
961      * @dev See {IERC721Metadata-name}.
962      */
963     function name() public view virtual override returns (string memory) {
964         return _name;
965     }
966 
967     /**
968      * @dev See {IERC721Metadata-symbol}.
969      */
970     function symbol() public view virtual override returns (string memory) {
971         return _symbol;
972     }
973 
974     /**
975      * @dev See {IERC721Metadata-tokenURI}.
976      */
977     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
978         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
979 
980         string memory baseURI = _baseURI();
981         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
982     }
983 
984     /**
985      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
986      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
987      * by default, can be overriden in child contracts.
988      */
989     function _baseURI() internal view virtual returns (string memory) {
990         return '';
991     }
992 
993     /**
994      * @dev See {IERC721-approve}.
995      */
996     function approve(address to, uint256 tokenId) public override {
997         address owner = ERC721A.ownerOf(tokenId);
998         if (to == owner) revert ApprovalToCurrentOwner();
999 
1000         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1001             revert ApprovalCallerNotOwnerNorApproved();
1002         }
1003 
1004         _approve(to, tokenId, owner);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-getApproved}.
1009      */
1010     function getApproved(uint256 tokenId) public view override returns (address) {
1011         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1012 
1013         return _tokenApprovals[tokenId];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-setApprovalForAll}.
1018      */
1019     function setApprovalForAll(address operator, bool approved) public virtual override {
1020         if (operator == _msgSender()) revert ApproveToCaller();
1021 
1022         _operatorApprovals[_msgSender()][operator] = approved;
1023         emit ApprovalForAll(_msgSender(), operator, approved);
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-isApprovedForAll}.
1028      */
1029     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1030         return _operatorApprovals[owner][operator];
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-transferFrom}.
1035      */
1036     function transferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public virtual override {
1041         _transfer(from, to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-safeTransferFrom}.
1046      */
1047     function safeTransferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) public virtual override {
1052         safeTransferFrom(from, to, tokenId, '');
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-safeTransferFrom}.
1057      */
1058     function safeTransferFrom(
1059         address from,
1060         address to,
1061         uint256 tokenId,
1062         bytes memory _data
1063     ) public virtual override {
1064         _transfer(from, to, tokenId);
1065         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1066             revert TransferToNonERC721ReceiverImplementer();
1067         }
1068     }
1069 
1070     /**
1071      * @dev Returns whether `tokenId` exists.
1072      *
1073      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1074      *
1075      * Tokens start existing when they are minted (`_mint`),
1076      */
1077     function _exists(uint256 tokenId) internal view returns (bool) {
1078         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1079     }
1080 
1081     /**
1082      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1083      */
1084     function _safeMint(address to, uint256 quantity) internal {
1085         _safeMint(to, quantity, '');
1086     }
1087 
1088     /**
1089      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - If `to` refers to a smart contract, it must implement 
1094      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1095      * - `quantity` must be greater than 0.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _safeMint(
1100         address to,
1101         uint256 quantity,
1102         bytes memory _data
1103     ) internal {
1104         uint256 startTokenId = _currentIndex;
1105         if (to == address(0)) revert MintToZeroAddress();
1106         if (quantity == 0) revert MintZeroQuantity();
1107 
1108         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1109 
1110         // Overflows are incredibly unrealistic.
1111         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1112         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1113         unchecked {
1114             _addressData[to].balance += uint64(quantity);
1115             _addressData[to].numberMinted += uint64(quantity);
1116 
1117             _ownerships[startTokenId].addr = to;
1118             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1119 
1120             uint256 updatedIndex = startTokenId;
1121             uint256 end = updatedIndex + quantity;
1122 
1123             if (to.isContract()) {
1124                 do {
1125                     emit Transfer(address(0), to, updatedIndex);
1126                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1127                         revert TransferToNonERC721ReceiverImplementer();
1128                     }
1129                 } while (updatedIndex != end);
1130                 // Reentrancy protection
1131                 if (_currentIndex != startTokenId) revert();
1132             } else {
1133                 do {
1134                     emit Transfer(address(0), to, updatedIndex++);
1135                 } while (updatedIndex != end);
1136             }
1137             _currentIndex = updatedIndex;
1138         }
1139         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1140     }
1141 
1142     /**
1143      * @dev Mints `quantity` tokens and transfers them to `to`.
1144      *
1145      * Requirements:
1146      *
1147      * - `to` cannot be the zero address.
1148      * - `quantity` must be greater than 0.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _mint(address to, uint256 quantity) internal {
1153         uint256 startTokenId = _currentIndex;
1154         if (to == address(0)) revert MintToZeroAddress();
1155         if (quantity == 0) revert MintZeroQuantity();
1156 
1157         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1158 
1159         // Overflows are incredibly unrealistic.
1160         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1161         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1162         unchecked {
1163             _addressData[to].balance += uint64(quantity);
1164             _addressData[to].numberMinted += uint64(quantity);
1165 
1166             _ownerships[startTokenId].addr = to;
1167             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1168 
1169             uint256 updatedIndex = startTokenId;
1170             uint256 end = updatedIndex + quantity;
1171 
1172             do {
1173                 emit Transfer(address(0), to, updatedIndex++);
1174             } while (updatedIndex != end);
1175 
1176             _currentIndex = updatedIndex;
1177         }
1178         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1179     }
1180 
1181     /**
1182      * @dev Transfers `tokenId` from `from` to `to`.
1183      *
1184      * Requirements:
1185      *
1186      * - `to` cannot be the zero address.
1187      * - `tokenId` token must be owned by `from`.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _transfer(
1192         address from,
1193         address to,
1194         uint256 tokenId
1195     ) private {
1196         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1197 
1198         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1199 
1200         bool isApprovedOrOwner = (_msgSender() == from ||
1201             isApprovedForAll(from, _msgSender()) ||
1202             getApproved(tokenId) == _msgSender());
1203 
1204         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1205         if (to == address(0)) revert TransferToZeroAddress();
1206 
1207         _beforeTokenTransfers(from, to, tokenId, 1);
1208 
1209         // Clear approvals from the previous owner
1210         _approve(address(0), tokenId, from);
1211 
1212         // Underflow of the sender's balance is impossible because we check for
1213         // ownership above and the recipient's balance can't realistically overflow.
1214         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1215         unchecked {
1216             _addressData[from].balance -= 1;
1217             _addressData[to].balance += 1;
1218 
1219             TokenOwnership storage currSlot = _ownerships[tokenId];
1220             currSlot.addr = to;
1221             currSlot.startTimestamp = uint64(block.timestamp);
1222 
1223             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1224             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1225             uint256 nextTokenId = tokenId + 1;
1226             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1227             if (nextSlot.addr == address(0)) {
1228                 // This will suffice for checking _exists(nextTokenId),
1229                 // as a burned slot cannot contain the zero address.
1230                 if (nextTokenId != _currentIndex) {
1231                     nextSlot.addr = from;
1232                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1233                 }
1234             }
1235         }
1236 
1237         emit Transfer(from, to, tokenId);
1238         _afterTokenTransfers(from, to, tokenId, 1);
1239     }
1240 
1241     /**
1242      * @dev Equivalent to `_burn(tokenId, false)`.
1243      */
1244     function _burn(uint256 tokenId) internal virtual {
1245         _burn(tokenId, false);
1246     }
1247 
1248     /**
1249      * @dev Destroys `tokenId`.
1250      * The approval is cleared when the token is burned.
1251      *
1252      * Requirements:
1253      *
1254      * - `tokenId` must exist.
1255      *
1256      * Emits a {Transfer} event.
1257      */
1258     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1259         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1260 
1261         address from = prevOwnership.addr;
1262 
1263         if (approvalCheck) {
1264             bool isApprovedOrOwner = (_msgSender() == from ||
1265                 isApprovedForAll(from, _msgSender()) ||
1266                 getApproved(tokenId) == _msgSender());
1267 
1268             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1269         }
1270 
1271         _beforeTokenTransfers(from, address(0), tokenId, 1);
1272 
1273         // Clear approvals from the previous owner
1274         _approve(address(0), tokenId, from);
1275 
1276         // Underflow of the sender's balance is impossible because we check for
1277         // ownership above and the recipient's balance can't realistically overflow.
1278         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1279         unchecked {
1280             AddressData storage addressData = _addressData[from];
1281             addressData.balance -= 1;
1282             addressData.numberBurned += 1;
1283 
1284             // Keep track of who burned the token, and the timestamp of burning.
1285             TokenOwnership storage currSlot = _ownerships[tokenId];
1286             currSlot.addr = from;
1287             currSlot.startTimestamp = uint64(block.timestamp);
1288             currSlot.burned = true;
1289 
1290             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1291             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1292             uint256 nextTokenId = tokenId + 1;
1293             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1294             if (nextSlot.addr == address(0)) {
1295                 // This will suffice for checking _exists(nextTokenId),
1296                 // as a burned slot cannot contain the zero address.
1297                 if (nextTokenId != _currentIndex) {
1298                     nextSlot.addr = from;
1299                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1300                 }
1301             }
1302         }
1303 
1304         emit Transfer(from, address(0), tokenId);
1305         _afterTokenTransfers(from, address(0), tokenId, 1);
1306 
1307         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1308         unchecked {
1309             _burnCounter++;
1310         }
1311     }
1312 
1313     /**
1314      * @dev Approve `to` to operate on `tokenId`
1315      *
1316      * Emits a {Approval} event.
1317      */
1318     function _approve(
1319         address to,
1320         uint256 tokenId,
1321         address owner
1322     ) private {
1323         _tokenApprovals[tokenId] = to;
1324         emit Approval(owner, to, tokenId);
1325     }
1326 
1327     /**
1328      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1329      *
1330      * @param from address representing the previous owner of the given token ID
1331      * @param to target address that will receive the tokens
1332      * @param tokenId uint256 ID of the token to be transferred
1333      * @param _data bytes optional data to send along with the call
1334      * @return bool whether the call correctly returned the expected magic value
1335      */
1336     function _checkContractOnERC721Received(
1337         address from,
1338         address to,
1339         uint256 tokenId,
1340         bytes memory _data
1341     ) private returns (bool) {
1342         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1343             return retval == IERC721Receiver(to).onERC721Received.selector;
1344         } catch (bytes memory reason) {
1345             if (reason.length == 0) {
1346                 revert TransferToNonERC721ReceiverImplementer();
1347             } else {
1348                 assembly {
1349                     revert(add(32, reason), mload(reason))
1350                 }
1351             }
1352         }
1353     }
1354 
1355     /**
1356      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1357      * And also called before burning one token.
1358      *
1359      * startTokenId - the first token id to be transferred
1360      * quantity - the amount to be transferred
1361      *
1362      * Calling conditions:
1363      *
1364      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1365      * transferred to `to`.
1366      * - When `from` is zero, `tokenId` will be minted for `to`.
1367      * - When `to` is zero, `tokenId` will be burned by `from`.
1368      * - `from` and `to` are never both zero.
1369      */
1370     function _beforeTokenTransfers(
1371         address from,
1372         address to,
1373         uint256 startTokenId,
1374         uint256 quantity
1375     ) internal virtual {}
1376 
1377     /**
1378      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1379      * minting.
1380      * And also called after one token has been burned.
1381      *
1382      * startTokenId - the first token id to be transferred
1383      * quantity - the amount to be transferred
1384      *
1385      * Calling conditions:
1386      *
1387      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1388      * transferred to `to`.
1389      * - When `from` is zero, `tokenId` has been minted for `to`.
1390      * - When `to` is zero, `tokenId` has been burned by `from`.
1391      * - `from` and `to` are never both zero.
1392      */
1393     function _afterTokenTransfers(
1394         address from,
1395         address to,
1396         uint256 startTokenId,
1397         uint256 quantity
1398     ) internal virtual {}
1399 }
1400 // File: contracts/DokeV.sol
1401 
1402 
1403 
1404 pragma solidity ^0.8.0;
1405 
1406 
1407 
1408 
1409 
1410 contract PixelCelebrityClub is ERC721A, Ownable, ReentrancyGuard {
1411   using Address for address;
1412   using Strings for uint;
1413 
1414 
1415   string  public  baseTokenURI = "ipfs://QmYxYXWHhWWgysZYcTDQiRpkDTaVWFFtNTRWCjQvqCEm4h/";
1416   uint256  public  maxSupply = 1000;
1417   uint256 public  MAX_MINTS_PER_TX = 10;
1418   uint256 public  PUBLIC_SALE_PRICE = 0.003 ether;
1419   uint256 public  NUM_FREE_MINTS = 150;
1420   uint256 public  MAX_FREE_PER_WALLET = 1;
1421   uint256 public freeNFTAlreadyMinted = 0;
1422   bool public isPublicSaleActive = false ;
1423 
1424   constructor(
1425 
1426   ) ERC721A("Pixel Celebrity Club", "PCC") {
1427 
1428   }
1429 
1430 
1431   function mint(uint256 numberOfTokens)
1432       external
1433       payable
1434   {
1435     require(isPublicSaleActive, "Public sale is not open");
1436     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1437 
1438     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1439         require(
1440             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1441             "Incorrect ETH value sent"
1442         );
1443     } else {
1444         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1445         require(
1446             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1447             "Incorrect ETH value sent"
1448         );
1449         require(
1450             numberOfTokens <= MAX_MINTS_PER_TX,
1451             "Max mints per transaction exceeded"
1452         );
1453         } else {
1454             require(
1455                 numberOfTokens <= MAX_FREE_PER_WALLET,
1456                 "Max mints per transaction exceeded"
1457             );
1458             freeNFTAlreadyMinted += numberOfTokens;
1459         }
1460     }
1461     _safeMint(msg.sender, numberOfTokens);
1462   }
1463 
1464   function setBaseURI(string memory baseURI)
1465     public
1466     onlyOwner
1467   {
1468     baseTokenURI = baseURI;
1469   }
1470 
1471   function treasuryMint(uint quantity)
1472     public
1473     onlyOwner
1474   {
1475     require(
1476       quantity > 0,
1477       "Invalid mint amount"
1478     );
1479     require(
1480       totalSupply() + quantity <= maxSupply,
1481       "Maximum supply exceeded"
1482     );
1483     _safeMint(msg.sender, quantity);
1484   }
1485 
1486   function withdraw()
1487     public
1488     onlyOwner
1489     nonReentrant
1490   {
1491     Address.sendValue(payable(msg.sender), address(this).balance);
1492   }
1493 
1494   function tokenURI(uint _tokenId)
1495     public
1496     view
1497     virtual
1498     override
1499     returns (string memory)
1500   {
1501     require(
1502       _exists(_tokenId),
1503       "ERC721Metadata: URI query for nonexistent token"
1504     );
1505     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1506   }
1507 
1508   function _baseURI()
1509     internal
1510     view
1511     virtual
1512     override
1513     returns (string memory)
1514   {
1515     return baseTokenURI;
1516   }
1517 
1518   function setIsPublicSaleActive(bool _isPublicSaleActive)
1519       external
1520       onlyOwner
1521   {
1522       isPublicSaleActive = _isPublicSaleActive;
1523   }
1524 
1525   function setNumFreeMints(uint256 _numfreemints)
1526       external
1527       onlyOwner
1528   {
1529       NUM_FREE_MINTS = _numfreemints;
1530   }
1531 
1532   function setSalePrice(uint256 _price)
1533       external
1534       onlyOwner
1535   {
1536       PUBLIC_SALE_PRICE = _price;
1537   }
1538   function cutMaxSupply(uint256 _amount) public onlyOwner {
1539         require(
1540             maxSupply +_amount >= 1, 
1541             "Supply cannot fall below minted tokens."
1542         );
1543         maxSupply += _amount;
1544     }
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