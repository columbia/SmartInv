1 /**
2 
3 __________            ______      __________                        ________                      __________                
4 ___  ____/__   __________  /___  ___  /___(_)____________     _________  __/  ______ _______      ___  ____/______ _______ _
5 __  __/  __ | / /  __ \_  /_  / / /  __/_  /_  __ \_  __ \    _  __ \_  /_    _  __ `/_  __ \     __  __/  __  __ `/_  __ `/
6 _  /___  __ |/ // /_/ /  / / /_/ // /_ _  / / /_/ /  / / /    / /_/ /  __/    / /_/ /_  / / /     _  /___  _  /_/ /_  /_/ / 
7 /_____/  _____/ \____//_/  \__,_/ \__/ /_/  \____//_/ /_/     \____//_/       \__,_/ /_/ /_/      /_____/  _\__, / _\__, /  
8                                                                                                            /____/  /____/   
9 
10 */
11 
12 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
13 
14 // SPDX-License-Identifier: MIT
15 
16 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Contract module that helps prevent reentrant calls to a function.
22  *
23  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
24  * available, which can be applied to functions to make sure there are no nested
25  * (reentrant) calls to them.
26  *
27  * Note that because there is a single `nonReentrant` guard, functions marked as
28  * `nonReentrant` may not call one another. This can be worked around by making
29  * those functions `private`, and then adding `external` `nonReentrant` entry
30  * points to them.
31  *
32  * TIP: If you would like to learn more about reentrancy and alternative ways
33  * to protect against it, check out our blog post
34  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
35  */
36 abstract contract ReentrancyGuard {
37     // Booleans are more expensive than uint256 or any type that takes up a full
38     // word because each write operation emits an extra SLOAD to first read the
39     // slot's contents, replace the bits taken up by the boolean, and then write
40     // back. This is the compiler's defense against contract upgrades and
41     // pointer aliasing, and it cannot be disabled.
42 
43     // The values being non-zero value makes deployment a bit more expensive,
44     // but in exchange the refund on every call to nonReentrant will be lower in
45     // amount. Since refunds are capped to a percentage of the total
46     // transaction's gas, it is best to keep them low in cases like this one, to
47     // increase the likelihood of the full refund coming into effect.
48     uint256 private constant _NOT_ENTERED = 1;
49     uint256 private constant _ENTERED = 2;
50 
51     uint256 private _status;
52 
53     constructor() {
54         _status = _NOT_ENTERED;
55     }
56 
57     /**
58      * @dev Prevents a contract from calling itself, directly or indirectly.
59      * Calling a `nonReentrant` function from another `nonReentrant`
60      * function is not supported. It is possible to prevent this from happening
61      * by making the `nonReentrant` function external, and making it call a
62      * `private` function that does the actual work.
63      */
64     modifier nonReentrant() {
65         // On the first call to nonReentrant, _notEntered will be true
66         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
67 
68         // Any calls to nonReentrant after this point will fail
69         _status = _ENTERED;
70 
71         _;
72 
73         // By storing the original value once again, a refund is triggered (see
74         // https://eips.ethereum.org/EIPS/eip-2200)
75         _status = _NOT_ENTERED;
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Strings.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev String operations.
88  */
89 library Strings {
90     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
147 }
148 
149 // File: @openzeppelin/contracts/utils/Context.sol
150 
151 
152 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 /**
157  * @dev Provides information about the current execution context, including the
158  * sender of the transaction and its data. While these are generally available
159  * via msg.sender and msg.data, they should not be accessed in such a direct
160  * manner, since when dealing with meta-transactions the account sending and
161  * paying for execution may not be the actual sender (as far as an application
162  * is concerned).
163  *
164  * This contract is only required for intermediate, library-like contracts.
165  */
166 abstract contract Context {
167     function _msgSender() internal view virtual returns (address) {
168         return msg.sender;
169     }
170 
171     function _msgData() internal view virtual returns (bytes calldata) {
172         return msg.data;
173     }
174 }
175 
176 // File: @openzeppelin/contracts/access/Ownable.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 
184 /**
185  * @dev Contract module which provides a basic access control mechanism, where
186  * there is an account (an owner) that can be granted exclusive access to
187  * specific functions.
188  *
189  * By default, the owner account will be the one that deploys the contract. This
190  * can later be changed with {transferOwnership}.
191  *
192  * This module is used through inheritance. It will make available the modifier
193  * `onlyOwner`, which can be applied to your functions to restrict their use to
194  * the owner.
195  */
196 abstract contract Ownable is Context {
197     address private _owner;
198 
199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201     /**
202      * @dev Initializes the contract setting the deployer as the initial owner.
203      */
204     constructor() {
205         _transferOwnership(_msgSender());
206     }
207 
208     /**
209      * @dev Returns the address of the current owner.
210      */
211     function owner() public view virtual returns (address) {
212         return _owner;
213     }
214 
215     /**
216      * @dev Throws if called by any account other than the owner.
217      */
218     modifier onlyOwner() {
219         require(owner() == _msgSender(), "Ownable: caller is not the owner");
220         _;
221     }
222 
223     /**
224      * @dev Leaves the contract without owner. It will not be possible to call
225      * `onlyOwner` functions anymore. Can only be called by the current owner.
226      *
227      * NOTE: Renouncing ownership will leave the contract without an owner,
228      * thereby removing any functionality that is only available to the owner.
229      */
230     function renounceOwnership() public virtual onlyOwner {
231         _transferOwnership(address(0));
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Can only be called by the current owner.
237      */
238     function transferOwnership(address newOwner) public virtual onlyOwner {
239         require(newOwner != address(0), "Ownable: new owner is the zero address");
240         _transferOwnership(newOwner);
241     }
242 
243     /**
244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
245      * Internal function without access restriction.
246      */
247     function _transferOwnership(address newOwner) internal virtual {
248         address oldOwner = _owner;
249         _owner = newOwner;
250         emit OwnershipTransferred(oldOwner, newOwner);
251     }
252 }
253 
254 // File: @openzeppelin/contracts/utils/Address.sol
255 
256 
257 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
258 
259 pragma solidity ^0.8.1;
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      *
282      * [IMPORTANT]
283      * ====
284      * You shouldn't rely on `isContract` to protect against flash loan attacks!
285      *
286      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
287      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
288      * constructor.
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies on extcodesize/address.code.length, which returns 0
293         // for contracts in construction, since the code is only stored at the end
294         // of the constructor execution.
295 
296         return account.code.length > 0;
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         (bool success, ) = recipient.call{value: amount}("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain `call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         require(isContract(target), "Address: call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.call{value: value}(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
403         return functionStaticCall(target, data, "Address: low-level static call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal view returns (bytes memory) {
417         require(isContract(target), "Address: static call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.staticcall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
430         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(isContract(target), "Address: delegate call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.delegatecall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
452      * revert reason using the provided one.
453      *
454      * _Available since v4.3._
455      */
456     function verifyCallResult(
457         bool success,
458         bytes memory returndata,
459         string memory errorMessage
460     ) internal pure returns (bytes memory) {
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
480 
481 
482 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @title ERC721 token receiver interface
488  * @dev Interface for any contract that wants to support safeTransfers
489  * from ERC721 asset contracts.
490  */
491 interface IERC721Receiver {
492     /**
493      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
494      * by `operator` from `from`, this function is called.
495      *
496      * It must return its Solidity selector to confirm the token transfer.
497      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
498      *
499      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
500      */
501     function onERC721Received(
502         address operator,
503         address from,
504         uint256 tokenId,
505         bytes calldata data
506     ) external returns (bytes4);
507 }
508 
509 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Interface of the ERC165 standard, as defined in the
518  * https://eips.ethereum.org/EIPS/eip-165[EIP].
519  *
520  * Implementers can declare support of contract interfaces, which can then be
521  * queried by others ({ERC165Checker}).
522  *
523  * For an implementation, see {ERC165}.
524  */
525 interface IERC165 {
526     /**
527      * @dev Returns true if this contract implements the interface defined by
528      * `interfaceId`. See the corresponding
529      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
530      * to learn more about how these ids are created.
531      *
532      * This function call must use less than 30 000 gas.
533      */
534     function supportsInterface(bytes4 interfaceId) external view returns (bool);
535 }
536 
537 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @dev Implementation of the {IERC165} interface.
547  *
548  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
549  * for the additional interface id that will be supported. For example:
550  *
551  * ```solidity
552  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
554  * }
555  * ```
556  *
557  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
558  */
559 abstract contract ERC165 is IERC165 {
560     /**
561      * @dev See {IERC165-supportsInterface}.
562      */
563     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564         return interfaceId == type(IERC165).interfaceId;
565     }
566 }
567 
568 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 /**
577  * @dev Required interface of an ERC721 compliant contract.
578  */
579 interface IERC721 is IERC165 {
580     /**
581      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
582      */
583     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
584 
585     /**
586      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
587      */
588     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
589 
590     /**
591      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
592      */
593     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
594 
595     /**
596      * @dev Returns the number of tokens in ``owner``'s account.
597      */
598     function balanceOf(address owner) external view returns (uint256 balance);
599 
600     /**
601      * @dev Returns the owner of the `tokenId` token.
602      *
603      * Requirements:
604      *
605      * - `tokenId` must exist.
606      */
607     function ownerOf(uint256 tokenId) external view returns (address owner);
608 
609     /**
610      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
611      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
612      *
613      * Requirements:
614      *
615      * - `from` cannot be the zero address.
616      * - `to` cannot be the zero address.
617      * - `tokenId` token must exist and be owned by `from`.
618      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
619      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
620      *
621      * Emits a {Transfer} event.
622      */
623     function safeTransferFrom(
624         address from,
625         address to,
626         uint256 tokenId
627     ) external;
628 
629     /**
630      * @dev Transfers `tokenId` token from `from` to `to`.
631      *
632      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
633      *
634      * Requirements:
635      *
636      * - `from` cannot be the zero address.
637      * - `to` cannot be the zero address.
638      * - `tokenId` token must be owned by `from`.
639      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
640      *
641      * Emits a {Transfer} event.
642      */
643     function transferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) external;
648 
649     /**
650      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
651      * The approval is cleared when the token is transferred.
652      *
653      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
654      *
655      * Requirements:
656      *
657      * - The caller must own the token or be an approved operator.
658      * - `tokenId` must exist.
659      *
660      * Emits an {Approval} event.
661      */
662     function approve(address to, uint256 tokenId) external;
663 
664     /**
665      * @dev Returns the account approved for `tokenId` token.
666      *
667      * Requirements:
668      *
669      * - `tokenId` must exist.
670      */
671     function getApproved(uint256 tokenId) external view returns (address operator);
672 
673     /**
674      * @dev Approve or remove `operator` as an operator for the caller.
675      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
676      *
677      * Requirements:
678      *
679      * - The `operator` cannot be the caller.
680      *
681      * Emits an {ApprovalForAll} event.
682      */
683     function setApprovalForAll(address operator, bool _approved) external;
684 
685     /**
686      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
687      *
688      * See {setApprovalForAll}
689      */
690     function isApprovedForAll(address owner, address operator) external view returns (bool);
691 
692     /**
693      * @dev Safely transfers `tokenId` token from `from` to `to`.
694      *
695      * Requirements:
696      *
697      * - `from` cannot be the zero address.
698      * - `to` cannot be the zero address.
699      * - `tokenId` token must exist and be owned by `from`.
700      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
701      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
702      *
703      * Emits a {Transfer} event.
704      */
705     function safeTransferFrom(
706         address from,
707         address to,
708         uint256 tokenId,
709         bytes calldata data
710     ) external;
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
723  * @dev See https://eips.ethereum.org/EIPS/eip-721
724  */
725 interface IERC721Metadata is IERC721 {
726     /**
727      * @dev Returns the token collection name.
728      */
729     function name() external view returns (string memory);
730 
731     /**
732      * @dev Returns the token collection symbol.
733      */
734     function symbol() external view returns (string memory);
735 
736     /**
737      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
738      */
739     function tokenURI(uint256 tokenId) external view returns (string memory);
740 }
741 
742 // File: contracts/ERC721A.sol
743 
744 
745 // Creator: Chiru Labs
746 
747 pragma solidity ^0.8.4;
748 
749 
750 
751 
752 
753 
754 
755 
756 error ApprovalCallerNotOwnerNorApproved();
757 error ApprovalQueryForNonexistentToken();
758 error ApproveToCaller();
759 error ApprovalToCurrentOwner();
760 error BalanceQueryForZeroAddress();
761 error MintToZeroAddress();
762 error MintZeroQuantity();
763 error OwnerQueryForNonexistentToken();
764 error TransferCallerNotOwnerNorApproved();
765 error TransferFromIncorrectOwner();
766 error TransferToNonERC721ReceiverImplementer();
767 error TransferToZeroAddress();
768 error URIQueryForNonexistentToken();
769 
770 /**
771  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
772  * the Metadata extension. Built to optimize for lower gas during batch mints.
773  *
774  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
775  *
776  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
777  *
778  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
779  */
780 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
781     using Address for address;
782     using Strings for uint256;
783 
784     // Compiler will pack this into a single 256bit word.
785     struct TokenOwnership {
786         // The address of the owner.
787         address addr;
788         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
789         uint64 startTimestamp;
790         // Whether the token has been burned.
791         bool burned;
792     }
793 
794     // Compiler will pack this into a single 256bit word.
795     struct AddressData {
796         // Realistically, 2**64-1 is more than enough.
797         uint64 balance;
798         // Keeps track of mint count with minimal overhead for tokenomics.
799         uint64 numberMinted;
800         // Keeps track of burn count with minimal overhead for tokenomics.
801         uint64 numberBurned;
802         // For miscellaneous variable(s) pertaining to the address
803         // (e.g. number of whitelist mint slots used).
804         // If there are multiple variables, please pack them into a uint64.
805         uint64 aux;
806     }
807 
808     // The tokenId of the next token to be minted.
809     uint256 internal _currentIndex;
810 
811     // The number of tokens burned.
812     uint256 internal _burnCounter;
813 
814     // Token name
815     string private _name;
816 
817     // Token symbol
818     string private _symbol;
819 
820     // Mapping from token ID to ownership details
821     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
822     mapping(uint256 => TokenOwnership) internal _ownerships;
823 
824     // Mapping owner address to address data
825     mapping(address => AddressData) private _addressData;
826 
827     // Mapping from token ID to approved address
828     mapping(uint256 => address) private _tokenApprovals;
829 
830     // Mapping from owner to operator approvals
831     mapping(address => mapping(address => bool)) private _operatorApprovals;
832 
833     constructor(string memory name_, string memory symbol_) {
834         _name = name_;
835         _symbol = symbol_;
836         _currentIndex = _startTokenId();
837     }
838 
839     /**
840      * To change the starting tokenId, please override this function.
841      */
842     function _startTokenId() internal view virtual returns (uint256) {
843         return 1;
844     }
845 
846     /**
847      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
848      */
849     function totalSupply() public view returns (uint256) {
850         // Counter underflow is impossible as _burnCounter cannot be incremented
851         // more than _currentIndex - _startTokenId() times
852         unchecked {
853             return _currentIndex - _burnCounter - _startTokenId();
854         }
855     }
856 
857     /**
858      * Returns the total amount of tokens minted in the contract.
859      */
860     function _totalMinted() internal view returns (uint256) {
861         // Counter underflow is impossible as _currentIndex does not decrement,
862         // and it is initialized to _startTokenId()
863         unchecked {
864             return _currentIndex - _startTokenId();
865         }
866     }
867 
868     /**
869      * @dev See {IERC165-supportsInterface}.
870      */
871     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
872         return
873             interfaceId == type(IERC721).interfaceId ||
874             interfaceId == type(IERC721Metadata).interfaceId ||
875             super.supportsInterface(interfaceId);
876     }
877 
878     /**
879      * @dev See {IERC721-balanceOf}.
880      */
881     function balanceOf(address owner) public view override returns (uint256) {
882         if (owner == address(0)) revert BalanceQueryForZeroAddress();
883         return uint256(_addressData[owner].balance);
884     }
885 
886     /**
887      * Returns the number of tokens minted by `owner`.
888      */
889     function _numberMinted(address owner) internal view returns (uint256) {
890         return uint256(_addressData[owner].numberMinted);
891     }
892 
893     /**
894      * Returns the number of tokens burned by or on behalf of `owner`.
895      */
896     function _numberBurned(address owner) internal view returns (uint256) {
897         return uint256(_addressData[owner].numberBurned);
898     }
899 
900     /**
901      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
902      */
903     function _getAux(address owner) internal view returns (uint64) {
904         return _addressData[owner].aux;
905     }
906 
907     /**
908      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
909      * If there are multiple variables, please pack them into a uint64.
910      */
911     function _setAux(address owner, uint64 aux) internal {
912         _addressData[owner].aux = aux;
913     }
914 
915     /**
916      * Gas spent here starts off proportional to the maximum mint batch size.
917      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
918      */
919     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
920         uint256 curr = tokenId;
921 
922         unchecked {
923             if (_startTokenId() <= curr && curr < _currentIndex) {
924                 TokenOwnership memory ownership = _ownerships[curr];
925                 if (!ownership.burned) {
926                     if (ownership.addr != address(0)) {
927                         return ownership;
928                     }
929                     // Invariant:
930                     // There will always be an ownership that has an address and is not burned
931                     // before an ownership that does not have an address and is not burned.
932                     // Hence, curr will not underflow.
933                     while (true) {
934                         curr--;
935                         ownership = _ownerships[curr];
936                         if (ownership.addr != address(0)) {
937                             return ownership;
938                         }
939                     }
940                 }
941             }
942         }
943         revert OwnerQueryForNonexistentToken();
944     }
945 
946     /**
947      * @dev See {IERC721-ownerOf}.
948      */
949     function ownerOf(uint256 tokenId) public view override returns (address) {
950         return _ownershipOf(tokenId).addr;
951     }
952 
953     /**
954      * @dev See {IERC721Metadata-name}.
955      */
956     function name() public view virtual override returns (string memory) {
957         return _name;
958     }
959 
960     /**
961      * @dev See {IERC721Metadata-symbol}.
962      */
963     function symbol() public view virtual override returns (string memory) {
964         return _symbol;
965     }
966 
967     /**
968      * @dev See {IERC721Metadata-tokenURI}.
969      */
970     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
971         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
972 
973         string memory baseURI = _baseURI();
974         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
975     }
976 
977     /**
978      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
979      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
980      * by default, can be overriden in child contracts.
981      */
982     function _baseURI() internal view virtual returns (string memory) {
983         return '';
984     }
985 
986     /**
987      * @dev See {IERC721-approve}.
988      */
989     function approve(address to, uint256 tokenId) public override {
990         address owner = ERC721A.ownerOf(tokenId);
991         if (to == owner) revert ApprovalToCurrentOwner();
992 
993         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
994             revert ApprovalCallerNotOwnerNorApproved();
995         }
996 
997         _approve(to, tokenId, owner);
998     }
999 
1000     /**
1001      * @dev See {IERC721-getApproved}.
1002      */
1003     function getApproved(uint256 tokenId) public view override returns (address) {
1004         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1005 
1006         return _tokenApprovals[tokenId];
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-setApprovalForAll}.
1011      */
1012     function setApprovalForAll(address operator, bool approved) public virtual override {
1013         if (operator == _msgSender()) revert ApproveToCaller();
1014 
1015         _operatorApprovals[_msgSender()][operator] = approved;
1016         emit ApprovalForAll(_msgSender(), operator, approved);
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-isApprovedForAll}.
1021      */
1022     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1023         return _operatorApprovals[owner][operator];
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-transferFrom}.
1028      */
1029     function transferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) public virtual override {
1034         _transfer(from, to, tokenId);
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-safeTransferFrom}.
1039      */
1040     function safeTransferFrom(
1041         address from,
1042         address to,
1043         uint256 tokenId
1044     ) public virtual override {
1045         safeTransferFrom(from, to, tokenId, '');
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-safeTransferFrom}.
1050      */
1051     function safeTransferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId,
1055         bytes memory _data
1056     ) public virtual override {
1057         _transfer(from, to, tokenId);
1058         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1059             revert TransferToNonERC721ReceiverImplementer();
1060         }
1061     }
1062 
1063     /**
1064      * @dev Returns whether `tokenId` exists.
1065      *
1066      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1067      *
1068      * Tokens start existing when they are minted (`_mint`),
1069      */
1070     function _exists(uint256 tokenId) internal view returns (bool) {
1071         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1072     }
1073 
1074     /**
1075      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1076      */
1077     function _safeMint(address to, uint256 quantity) internal {
1078         _safeMint(to, quantity, '');
1079     }
1080 
1081     /**
1082      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1083      *
1084      * Requirements:
1085      *
1086      * - If `to` refers to a smart contract, it must implement 
1087      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1088      * - `quantity` must be greater than 0.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _safeMint(
1093         address to,
1094         uint256 quantity,
1095         bytes memory _data
1096     ) internal {
1097         uint256 startTokenId = _currentIndex;
1098         if (to == address(0)) revert MintToZeroAddress();
1099         if (quantity == 0) revert MintZeroQuantity();
1100 
1101         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1102 
1103         // Overflows are incredibly unrealistic.
1104         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1105         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1106         unchecked {
1107             _addressData[to].balance += uint64(quantity);
1108             _addressData[to].numberMinted += uint64(quantity);
1109 
1110             _ownerships[startTokenId].addr = to;
1111             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1112 
1113             uint256 updatedIndex = startTokenId;
1114             uint256 end = updatedIndex + quantity;
1115 
1116             if (to.isContract()) {
1117                 do {
1118                     emit Transfer(address(0), to, updatedIndex);
1119                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1120                         revert TransferToNonERC721ReceiverImplementer();
1121                     }
1122                 } while (updatedIndex != end);
1123                 // Reentrancy protection
1124                 if (_currentIndex != startTokenId) revert();
1125             } else {
1126                 do {
1127                     emit Transfer(address(0), to, updatedIndex++);
1128                 } while (updatedIndex != end);
1129             }
1130             _currentIndex = updatedIndex;
1131         }
1132         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1133     }
1134 
1135     /**
1136      * @dev Mints `quantity` tokens and transfers them to `to`.
1137      *
1138      * Requirements:
1139      *
1140      * - `to` cannot be the zero address.
1141      * - `quantity` must be greater than 0.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function _mint(address to, uint256 quantity) internal {
1146         uint256 startTokenId = _currentIndex;
1147         if (to == address(0)) revert MintToZeroAddress();
1148         if (quantity == 0) revert MintZeroQuantity();
1149 
1150         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1151 
1152         // Overflows are incredibly unrealistic.
1153         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1154         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1155         unchecked {
1156             _addressData[to].balance += uint64(quantity);
1157             _addressData[to].numberMinted += uint64(quantity);
1158 
1159             _ownerships[startTokenId].addr = to;
1160             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1161 
1162             uint256 updatedIndex = startTokenId;
1163             uint256 end = updatedIndex + quantity;
1164 
1165             do {
1166                 emit Transfer(address(0), to, updatedIndex++);
1167             } while (updatedIndex != end);
1168 
1169             _currentIndex = updatedIndex;
1170         }
1171         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1172     }
1173 
1174     /**
1175      * @dev Transfers `tokenId` from `from` to `to`.
1176      *
1177      * Requirements:
1178      *
1179      * - `to` cannot be the zero address.
1180      * - `tokenId` token must be owned by `from`.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function _transfer(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) private {
1189         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1190 
1191         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1192 
1193         bool isApprovedOrOwner = (_msgSender() == from ||
1194             isApprovedForAll(from, _msgSender()) ||
1195             getApproved(tokenId) == _msgSender());
1196 
1197         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1198         if (to == address(0)) revert TransferToZeroAddress();
1199 
1200         _beforeTokenTransfers(from, to, tokenId, 1);
1201 
1202         // Clear approvals from the previous owner
1203         _approve(address(0), tokenId, from);
1204 
1205         // Underflow of the sender's balance is impossible because we check for
1206         // ownership above and the recipient's balance can't realistically overflow.
1207         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1208         unchecked {
1209             _addressData[from].balance -= 1;
1210             _addressData[to].balance += 1;
1211 
1212             TokenOwnership storage currSlot = _ownerships[tokenId];
1213             currSlot.addr = to;
1214             currSlot.startTimestamp = uint64(block.timestamp);
1215 
1216             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1217             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1218             uint256 nextTokenId = tokenId + 1;
1219             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1220             if (nextSlot.addr == address(0)) {
1221                 // This will suffice for checking _exists(nextTokenId),
1222                 // as a burned slot cannot contain the zero address.
1223                 if (nextTokenId != _currentIndex) {
1224                     nextSlot.addr = from;
1225                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1226                 }
1227             }
1228         }
1229 
1230         emit Transfer(from, to, tokenId);
1231         _afterTokenTransfers(from, to, tokenId, 1);
1232     }
1233 
1234     /**
1235      * @dev Equivalent to `_burn(tokenId, false)`.
1236      */
1237     function _burn(uint256 tokenId) internal virtual {
1238         _burn(tokenId, false);
1239     }
1240 
1241     /**
1242      * @dev Destroys `tokenId`.
1243      * The approval is cleared when the token is burned.
1244      *
1245      * Requirements:
1246      *
1247      * - `tokenId` must exist.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1252         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1253 
1254         address from = prevOwnership.addr;
1255 
1256         if (approvalCheck) {
1257             bool isApprovedOrOwner = (_msgSender() == from ||
1258                 isApprovedForAll(from, _msgSender()) ||
1259                 getApproved(tokenId) == _msgSender());
1260 
1261             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1262         }
1263 
1264         _beforeTokenTransfers(from, address(0), tokenId, 1);
1265 
1266         // Clear approvals from the previous owner
1267         _approve(address(0), tokenId, from);
1268 
1269         // Underflow of the sender's balance is impossible because we check for
1270         // ownership above and the recipient's balance can't realistically overflow.
1271         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1272         unchecked {
1273             AddressData storage addressData = _addressData[from];
1274             addressData.balance -= 1;
1275             addressData.numberBurned += 1;
1276 
1277             // Keep track of who burned the token, and the timestamp of burning.
1278             TokenOwnership storage currSlot = _ownerships[tokenId];
1279             currSlot.addr = from;
1280             currSlot.startTimestamp = uint64(block.timestamp);
1281             currSlot.burned = true;
1282 
1283             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1284             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1285             uint256 nextTokenId = tokenId + 1;
1286             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1287             if (nextSlot.addr == address(0)) {
1288                 // This will suffice for checking _exists(nextTokenId),
1289                 // as a burned slot cannot contain the zero address.
1290                 if (nextTokenId != _currentIndex) {
1291                     nextSlot.addr = from;
1292                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1293                 }
1294             }
1295         }
1296 
1297         emit Transfer(from, address(0), tokenId);
1298         _afterTokenTransfers(from, address(0), tokenId, 1);
1299 
1300         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1301         unchecked {
1302             _burnCounter++;
1303         }
1304     }
1305 
1306     /**
1307      * @dev Approve `to` to operate on `tokenId`
1308      *
1309      * Emits a {Approval} event.
1310      */
1311     function _approve(
1312         address to,
1313         uint256 tokenId,
1314         address owner
1315     ) private {
1316         _tokenApprovals[tokenId] = to;
1317         emit Approval(owner, to, tokenId);
1318     }
1319 
1320     /**
1321      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1322      *
1323      * @param from address representing the previous owner of the given token ID
1324      * @param to target address that will receive the tokens
1325      * @param tokenId uint256 ID of the token to be transferred
1326      * @param _data bytes optional data to send along with the call
1327      * @return bool whether the call correctly returned the expected magic value
1328      */
1329     function _checkContractOnERC721Received(
1330         address from,
1331         address to,
1332         uint256 tokenId,
1333         bytes memory _data
1334     ) private returns (bool) {
1335         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1336             return retval == IERC721Receiver(to).onERC721Received.selector;
1337         } catch (bytes memory reason) {
1338             if (reason.length == 0) {
1339                 revert TransferToNonERC721ReceiverImplementer();
1340             } else {
1341                 assembly {
1342                     revert(add(32, reason), mload(reason))
1343                 }
1344             }
1345         }
1346     }
1347 
1348     /**
1349      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1350      * And also called before burning one token.
1351      *
1352      * startTokenId - the first token id to be transferred
1353      * quantity - the amount to be transferred
1354      *
1355      * Calling conditions:
1356      *
1357      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1358      * transferred to `to`.
1359      * - When `from` is zero, `tokenId` will be minted for `to`.
1360      * - When `to` is zero, `tokenId` will be burned by `from`.
1361      * - `from` and `to` are never both zero.
1362      */
1363     function _beforeTokenTransfers(
1364         address from,
1365         address to,
1366         uint256 startTokenId,
1367         uint256 quantity
1368     ) internal virtual {}
1369 
1370     /**
1371      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1372      * minting.
1373      * And also called after one token has been burned.
1374      *
1375      * startTokenId - the first token id to be transferred
1376      * quantity - the amount to be transferred
1377      *
1378      * Calling conditions:
1379      *
1380      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1381      * transferred to `to`.
1382      * - When `from` is zero, `tokenId` has been minted for `to`.
1383      * - When `to` is zero, `tokenId` has been burned by `from`.
1384      * - `from` and `to` are never both zero.
1385      */
1386     function _afterTokenTransfers(
1387         address from,
1388         address to,
1389         uint256 startTokenId,
1390         uint256 quantity
1391     ) internal virtual {}
1392 }
1393 // File: contracts/WhatIsInTheEgg.sol
1394 
1395 
1396 
1397 pragma solidity ^0.8.0;
1398 
1399 
1400 
1401 
1402 
1403 contract WhatIsInTheEgg is ERC721A, Ownable, ReentrancyGuard {
1404   using Address for address;
1405   using Strings for uint;
1406 
1407 
1408   string  public  baseTokenURI = "ipfs://QmNYbMG7MvqBipKVGnfFG2HSLDdHbphQxv5GEAHgkmM3mp/";
1409   uint256  public  maxSupply = 999;
1410   uint256 public  MAX_MINTS_PER_TX = 1;
1411   uint256 public  PUBLIC_SALE_PRICE = 0.00 ether;
1412   uint256 public  NUM_FREE_MINTS = 999;
1413   uint256 public  MAX_FREE_PER_WALLET = 3;
1414   uint256 public freeNFTAlreadyMinted = 0;
1415   bool public isPublicSaleActive = false;
1416 
1417   constructor(
1418 
1419   ) ERC721A("WhatIsInTheEgg", "PetEgg") {
1420 
1421   }
1422 
1423 
1424   function mint(uint256 numberOfTokens)
1425       external
1426       payable
1427   {
1428     require(isPublicSaleActive, "Public sale is not open");
1429     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1430 
1431     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1432         require(
1433             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1434             "Incorrect ETH value sent"
1435         );
1436     } else {
1437         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1438         require(
1439             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1440             "Incorrect ETH value sent"
1441         );
1442         require(
1443             numberOfTokens <= MAX_MINTS_PER_TX,
1444             "Max mints per transaction exceeded"
1445         );
1446         } else {
1447             require(
1448                 numberOfTokens <= MAX_FREE_PER_WALLET,
1449                 "Max mints per transaction exceeded"
1450             );
1451             freeNFTAlreadyMinted += numberOfTokens;
1452         }
1453     }
1454     _safeMint(msg.sender, numberOfTokens);
1455   }
1456 
1457   function setBaseURI(string memory baseURI)
1458     public
1459     onlyOwner
1460   {
1461     baseTokenURI = baseURI;
1462   }
1463 
1464   function treasuryMint(uint quantity)
1465     public
1466     onlyOwner
1467   {
1468     require(
1469       quantity > 0,
1470       "Invalid mint amount"
1471     );
1472     require(
1473       totalSupply() + quantity <= maxSupply,
1474       "Maximum supply exceeded"
1475     );
1476     _safeMint(msg.sender, quantity);
1477   }
1478 
1479   function withdraw()
1480     public
1481     onlyOwner
1482     nonReentrant
1483   {
1484     Address.sendValue(payable(msg.sender), address(this).balance);
1485   }
1486 
1487   function tokenURI(uint _tokenId)
1488     public
1489     view
1490     virtual
1491     override
1492     returns (string memory)
1493   {
1494     require(
1495       _exists(_tokenId),
1496       "ERC721Metadata: URI query for nonexistent token"
1497     );
1498     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1499   }
1500 
1501   function _baseURI()
1502     internal
1503     view
1504     virtual
1505     override
1506     returns (string memory)
1507   {
1508     return baseTokenURI;
1509   }
1510 
1511   function setIsPublicSaleActive(bool _isPublicSaleActive)
1512       external
1513       onlyOwner
1514   {
1515       isPublicSaleActive = _isPublicSaleActive;
1516   }
1517 
1518   function setNumFreeMints(uint256 _numfreemints)
1519       external
1520       onlyOwner
1521   {
1522       NUM_FREE_MINTS = _numfreemints;
1523   }
1524 
1525   function setSalePrice(uint256 _price)
1526       external
1527       onlyOwner
1528   {
1529       PUBLIC_SALE_PRICE = _price;
1530   }
1531 
1532   function setMaxLimitPerTransaction(uint256 _limit)
1533       external
1534       onlyOwner
1535   {
1536       MAX_MINTS_PER_TX = _limit;
1537   }
1538 
1539   function setFreeLimitPerWallet(uint256 _limit)
1540       external
1541       onlyOwner
1542   {
1543       MAX_FREE_PER_WALLET = _limit;
1544   }
1545 }