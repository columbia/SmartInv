1 /**
2 
3  ____                            __                 __      __   __               ____                                ____    ___             __        
4 /\  _`\                         /\ \              /'__`\  /'__`\/\ \__           /\  _`\                             /\  _`\ /\_ \           /\ \       
5 \ \ \L\ \    ___   _ __    __   \_\ \      __  __/\ \/\ \/\ \/\ \ \ ,_\   ____   \ \ \/\ \    ___      __      __    \ \ \/\_\//\ \    __  __\ \ \____  
6  \ \  _ <'  / __`\/\`'__\/'__`\ /'_` \    /\ \/\ \ \ \ \ \ \ \ \ \ \ \/  /',__\   \ \ \ \ \  / __`\  /'_ `\  /'__`\   \ \ \/_/_\ \ \  /\ \/\ \\ \ '__`\ 
7   \ \ \L\ \/\ \L\ \ \ \//\  __//\ \L\ \   \ \ \_\ \ \ \_\ \ \ \_\ \ \ \_/\__, `\   \ \ \_\ \/\ \L\ \/\ \L\ \/\  __/    \ \ \L\ \\_\ \_\ \ \_\ \\ \ \L\ \
8    \ \____/\ \____/\ \_\\ \____\ \___,_\   \/`____ \ \____/\ \____/\ \__\/\____/    \ \____/\ \____/\ \____ \ \____\    \ \____//\____\\ \____/ \ \_,__/
9     \/___/  \/___/  \/_/ \/____/\/__,_ /    `/___/> \/___/  \/___/  \/__/\/___/      \/___/  \/___/  \/___L\ \/____/     \/___/ \/____/ \/___/   \/___/ 
10                                                /\___/                                                  /\____/                                          
11                                                \/__/                                                   \_/__/                                           
12 
13 */
14 
15 
16 
17 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
18 
19 // SPDX-License-Identifier: MIT
20 
21 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev Contract module that helps prevent reentrant calls to a function.
27  *
28  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
29  * available, which can be applied to functions to make sure there are no nested
30  * (reentrant) calls to them.
31  *
32  * Note that because there is a single `nonReentrant` guard, functions marked as
33  * `nonReentrant` may not call one another. This can be worked around by making
34  * those functions `private`, and then adding `external` `nonReentrant` entry
35  * points to them.
36  *
37  * TIP: If you would like to learn more about reentrancy and alternative ways
38  * to protect against it, check out our blog post
39  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
40  */
41 abstract contract ReentrancyGuard {
42     // Booleans are more expensive than uint256 or any type that takes up a full
43     // word because each write operation emits an extra SLOAD to first read the
44     // slot's contents, replace the bits taken up by the boolean, and then write
45     // back. This is the compiler's defense against contract upgrades and
46     // pointer aliasing, and it cannot be disabled.
47 
48     // The values being non-zero value makes deployment a bit more expensive,
49     // but in exchange the refund on every call to nonReentrant will be lower in
50     // amount. Since refunds are capped to a percentage of the total
51     // transaction's gas, it is best to keep them low in cases like this one, to
52     // increase the likelihood of the full refund coming into effect.
53     uint256 private constant _NOT_ENTERED = 1;
54     uint256 private constant _ENTERED = 2;
55 
56     uint256 private _status;
57 
58     constructor() {
59         _status = _NOT_ENTERED;
60     }
61 
62     /**
63      * @dev Prevents a contract from calling itself, directly or indirectly.
64      * Calling a `nonReentrant` function from another `nonReentrant`
65      * function is not supported. It is possible to prevent this from happening
66      * by making the `nonReentrant` function external, and making it call a
67      * `private` function that does the actual work.
68      */
69     modifier nonReentrant() {
70         // On the first call to nonReentrant, _notEntered will be true
71         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
72 
73         // Any calls to nonReentrant after this point will fail
74         _status = _ENTERED;
75 
76         _;
77 
78         // By storing the original value once again, a refund is triggered (see
79         // https://eips.ethereum.org/EIPS/eip-2200)
80         _status = _NOT_ENTERED;
81     }
82 }
83 
84 // File: @openzeppelin/contracts/utils/Strings.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev String operations.
93  */
94 library Strings {
95     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
99      */
100     function toString(uint256 value) internal pure returns (string memory) {
101         // Inspired by OraclizeAPI's implementation - MIT licence
102         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
103 
104         if (value == 0) {
105             return "0";
106         }
107         uint256 temp = value;
108         uint256 digits;
109         while (temp != 0) {
110             digits++;
111             temp /= 10;
112         }
113         bytes memory buffer = new bytes(digits);
114         while (value != 0) {
115             digits -= 1;
116             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
117             value /= 10;
118         }
119         return string(buffer);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
124      */
125     function toHexString(uint256 value) internal pure returns (string memory) {
126         if (value == 0) {
127             return "0x00";
128         }
129         uint256 temp = value;
130         uint256 length = 0;
131         while (temp != 0) {
132             length++;
133             temp >>= 8;
134         }
135         return toHexString(value, length);
136     }
137 
138     /**
139      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
140      */
141     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
142         bytes memory buffer = new bytes(2 * length + 2);
143         buffer[0] = "0";
144         buffer[1] = "x";
145         for (uint256 i = 2 * length + 1; i > 1; --i) {
146             buffer[i] = _HEX_SYMBOLS[value & 0xf];
147             value >>= 4;
148         }
149         require(value == 0, "Strings: hex length insufficient");
150         return string(buffer);
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
184 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
214      * @dev Returns the address of the current owner.
215      */
216     function owner() public view virtual returns (address) {
217         return _owner;
218     }
219 
220     /**
221      * @dev Throws if called by any account other than the owner.
222      */
223     modifier onlyOwner() {
224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
225         _;
226     }
227 
228     /**
229      * @dev Leaves the contract without owner. It will not be possible to call
230      * `onlyOwner` functions anymore. Can only be called by the current owner.
231      *
232      * NOTE: Renouncing ownership will leave the contract without an owner,
233      * thereby removing any functionality that is only available to the owner.
234      */
235     function renounceOwnership() public virtual onlyOwner {
236         _transferOwnership(address(0));
237     }
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      * Can only be called by the current owner.
242      */
243     function transferOwnership(address newOwner) public virtual onlyOwner {
244         require(newOwner != address(0), "Ownable: new owner is the zero address");
245         _transferOwnership(newOwner);
246     }
247 
248     /**
249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
250      * Internal function without access restriction.
251      */
252     function _transferOwnership(address newOwner) internal virtual {
253         address oldOwner = _owner;
254         _owner = newOwner;
255         emit OwnershipTransferred(oldOwner, newOwner);
256     }
257 }
258 
259 // File: @openzeppelin/contracts/utils/Address.sol
260 
261 
262 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
263 
264 pragma solidity ^0.8.1;
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      *
287      * [IMPORTANT]
288      * ====
289      * You shouldn't rely on `isContract` to protect against flash loan attacks!
290      *
291      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
292      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
293      * constructor.
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // This method relies on extcodesize/address.code.length, which returns 0
298         // for contracts in construction, since the code is only stored at the end
299         // of the constructor execution.
300 
301         return account.code.length > 0;
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      */
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(address(this).balance >= amount, "Address: insufficient balance");
322 
323         (bool success, ) = recipient.call{value: amount}("");
324         require(success, "Address: unable to send value, recipient may have reverted");
325     }
326 
327     /**
328      * @dev Performs a Solidity function call using a low level `call`. A
329      * plain `call` is an unsafe replacement for a function call: use this
330      * function instead.
331      *
332      * If `target` reverts with a revert reason, it is bubbled up by this
333      * function (like regular Solidity function calls).
334      *
335      * Returns the raw returned data. To convert to the expected return value,
336      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
337      *
338      * Requirements:
339      *
340      * - `target` must be a contract.
341      * - calling `target` with `data` must not revert.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
346         return functionCall(target, data, "Address: low-level call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
351      * `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but also transferring `value` wei to `target`.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least `value`.
370      * - the called Solidity function must be `payable`.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(
375         address target,
376         bytes memory data,
377         uint256 value
378     ) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
384      * with `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(
389         address target,
390         bytes memory data,
391         uint256 value,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         require(address(this).balance >= value, "Address: insufficient balance for call");
395         require(isContract(target), "Address: call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.call{value: value}(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
408         return functionStaticCall(target, data, "Address: low-level static call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal view returns (bytes memory) {
422         require(isContract(target), "Address: static call to non-contract");
423 
424         (bool success, bytes memory returndata) = target.staticcall(data);
425         return verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but performing a delegate call.
431      *
432      * _Available since v3.4._
433      */
434     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
435         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal returns (bytes memory) {
449         require(isContract(target), "Address: delegate call to non-contract");
450 
451         (bool success, bytes memory returndata) = target.delegatecall(data);
452         return verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
457      * revert reason using the provided one.
458      *
459      * _Available since v4.3._
460      */
461     function verifyCallResult(
462         bool success,
463         bytes memory returndata,
464         string memory errorMessage
465     ) internal pure returns (bytes memory) {
466         if (success) {
467             return returndata;
468         } else {
469             // Look for revert reason and bubble it up if present
470             if (returndata.length > 0) {
471                 // The easiest way to bubble the revert reason is using memory via assembly
472 
473                 assembly {
474                     let returndata_size := mload(returndata)
475                     revert(add(32, returndata), returndata_size)
476                 }
477             } else {
478                 revert(errorMessage);
479             }
480         }
481     }
482 }
483 
484 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @title ERC721 token receiver interface
493  * @dev Interface for any contract that wants to support safeTransfers
494  * from ERC721 asset contracts.
495  */
496 interface IERC721Receiver {
497     /**
498      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
499      * by `operator` from `from`, this function is called.
500      *
501      * It must return its Solidity selector to confirm the token transfer.
502      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
503      *
504      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
505      */
506     function onERC721Received(
507         address operator,
508         address from,
509         uint256 tokenId,
510         bytes calldata data
511     ) external returns (bytes4);
512 }
513 
514 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
515 
516 
517 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @dev Interface of the ERC165 standard, as defined in the
523  * https://eips.ethereum.org/EIPS/eip-165[EIP].
524  *
525  * Implementers can declare support of contract interfaces, which can then be
526  * queried by others ({ERC165Checker}).
527  *
528  * For an implementation, see {ERC165}.
529  */
530 interface IERC165 {
531     /**
532      * @dev Returns true if this contract implements the interface defined by
533      * `interfaceId`. See the corresponding
534      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
535      * to learn more about how these ids are created.
536      *
537      * This function call must use less than 30 000 gas.
538      */
539     function supportsInterface(bytes4 interfaceId) external view returns (bool);
540 }
541 
542 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
543 
544 
545 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 
550 /**
551  * @dev Implementation of the {IERC165} interface.
552  *
553  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
554  * for the additional interface id that will be supported. For example:
555  *
556  * ```solidity
557  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
559  * }
560  * ```
561  *
562  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
563  */
564 abstract contract ERC165 is IERC165 {
565     /**
566      * @dev See {IERC165-supportsInterface}.
567      */
568     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569         return interfaceId == type(IERC165).interfaceId;
570     }
571 }
572 
573 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
574 
575 
576 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 
581 /**
582  * @dev Required interface of an ERC721 compliant contract.
583  */
584 interface IERC721 is IERC165 {
585     /**
586      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
587      */
588     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
589 
590     /**
591      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
592      */
593     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
594 
595     /**
596      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
597      */
598     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
599 
600     /**
601      * @dev Returns the number of tokens in ``owner``'s account.
602      */
603     function balanceOf(address owner) external view returns (uint256 balance);
604 
605     /**
606      * @dev Returns the owner of the `tokenId` token.
607      *
608      * Requirements:
609      *
610      * - `tokenId` must exist.
611      */
612     function ownerOf(uint256 tokenId) external view returns (address owner);
613 
614     /**
615      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
616      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
624      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId
632     ) external;
633 
634     /**
635      * @dev Transfers `tokenId` token from `from` to `to`.
636      *
637      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
638      *
639      * Requirements:
640      *
641      * - `from` cannot be the zero address.
642      * - `to` cannot be the zero address.
643      * - `tokenId` token must be owned by `from`.
644      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
645      *
646      * Emits a {Transfer} event.
647      */
648     function transferFrom(
649         address from,
650         address to,
651         uint256 tokenId
652     ) external;
653 
654     /**
655      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
656      * The approval is cleared when the token is transferred.
657      *
658      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
659      *
660      * Requirements:
661      *
662      * - The caller must own the token or be an approved operator.
663      * - `tokenId` must exist.
664      *
665      * Emits an {Approval} event.
666      */
667     function approve(address to, uint256 tokenId) external;
668 
669     /**
670      * @dev Returns the account approved for `tokenId` token.
671      *
672      * Requirements:
673      *
674      * - `tokenId` must exist.
675      */
676     function getApproved(uint256 tokenId) external view returns (address operator);
677 
678     /**
679      * @dev Approve or remove `operator` as an operator for the caller.
680      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
681      *
682      * Requirements:
683      *
684      * - The `operator` cannot be the caller.
685      *
686      * Emits an {ApprovalForAll} event.
687      */
688     function setApprovalForAll(address operator, bool _approved) external;
689 
690     /**
691      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
692      *
693      * See {setApprovalForAll}
694      */
695     function isApprovedForAll(address owner, address operator) external view returns (bool);
696 
697     /**
698      * @dev Safely transfers `tokenId` token from `from` to `to`.
699      *
700      * Requirements:
701      *
702      * - `from` cannot be the zero address.
703      * - `to` cannot be the zero address.
704      * - `tokenId` token must exist and be owned by `from`.
705      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
706      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
707      *
708      * Emits a {Transfer} event.
709      */
710     function safeTransferFrom(
711         address from,
712         address to,
713         uint256 tokenId,
714         bytes calldata data
715     ) external;
716 }
717 
718 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
719 
720 
721 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
722 
723 pragma solidity ^0.8.0;
724 
725 
726 /**
727  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
728  * @dev See https://eips.ethereum.org/EIPS/eip-721
729  */
730 interface IERC721Metadata is IERC721 {
731     /**
732      * @dev Returns the token collection name.
733      */
734     function name() external view returns (string memory);
735 
736     /**
737      * @dev Returns the token collection symbol.
738      */
739     function symbol() external view returns (string memory);
740 
741     /**
742      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
743      */
744     function tokenURI(uint256 tokenId) external view returns (string memory);
745 }
746 
747 // File: contracts/ERC721A.sol
748 
749 
750 pragma solidity ^0.8.4;
751 
752 
753 
754 
755 
756 
757 
758 
759 error ApprovalCallerNotOwnerNorApproved();
760 error ApprovalQueryForNonexistentToken();
761 error ApproveToCaller();
762 error ApprovalToCurrentOwner();
763 error BalanceQueryForZeroAddress();
764 error MintToZeroAddress();
765 error MintZeroQuantity();
766 error OwnerQueryForNonexistentToken();
767 error TransferCallerNotOwnerNorApproved();
768 error TransferFromIncorrectOwner();
769 error TransferToNonERC721ReceiverImplementer();
770 error TransferToZeroAddress();
771 error URIQueryForNonexistentToken();
772 
773 /**
774  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
775  * the Metadata extension. Built to optimize for lower gas during batch mints.
776  *
777  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
778  *
779  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
780  *
781  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
782  */
783 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
784     using Address for address;
785     using Strings for uint256;
786 
787     // Compiler will pack this into a single 256bit word.
788     struct TokenOwnership {
789         // The address of the owner.
790         address addr;
791         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
792         uint64 startTimestamp;
793         // Whether the token has been burned.
794         bool burned;
795     }
796 
797     // Compiler will pack this into a single 256bit word.
798     struct AddressData {
799         // Realistically, 2**64-1 is more than enough.
800         uint64 balance;
801         // Keeps track of mint count with minimal overhead for tokenomics.
802         uint64 numberMinted;
803         // Keeps track of burn count with minimal overhead for tokenomics.
804         uint64 numberBurned;
805         // For miscellaneous variable(s) pertaining to the address
806         // (e.g. number of whitelist mint slots used).
807         // If there are multiple variables, please pack them into a uint64.
808         uint64 aux;
809     }
810 
811     // The tokenId of the next token to be minted.
812     uint256 internal _currentIndex;
813 
814     // The number of tokens burned.
815     uint256 internal _burnCounter;
816 
817     // Token name
818     string private _name;
819 
820     // Token symbol
821     string private _symbol;
822 
823     // Mapping from token ID to ownership details
824     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
825     mapping(uint256 => TokenOwnership) internal _ownerships;
826 
827     // Mapping owner address to address data
828     mapping(address => AddressData) private _addressData;
829 
830     // Mapping from token ID to approved address
831     mapping(uint256 => address) private _tokenApprovals;
832 
833     // Mapping from owner to operator approvals
834     mapping(address => mapping(address => bool)) private _operatorApprovals;
835 
836     constructor(string memory name_, string memory symbol_) {
837         _name = name_;
838         _symbol = symbol_;
839         _currentIndex = _startTokenId();
840     }
841 
842     /**
843      * To change the starting tokenId, please override this function.
844      */
845     function _startTokenId() internal view virtual returns (uint256) {
846         return 1;
847     }
848 
849     /**
850      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
851      */
852     function totalSupply() public view returns (uint256) {
853         // Counter underflow is impossible as _burnCounter cannot be incremented
854         // more than _currentIndex - _startTokenId() times
855         unchecked {
856             return _currentIndex - _burnCounter - _startTokenId();
857         }
858     }
859 
860     /**
861      * Returns the total amount of tokens minted in the contract.
862      */
863     function _totalMinted() internal view returns (uint256) {
864         // Counter underflow is impossible as _currentIndex does not decrement,
865         // and it is initialized to _startTokenId()
866         unchecked {
867             return _currentIndex - _startTokenId();
868         }
869     }
870 
871     /**
872      * @dev See {IERC165-supportsInterface}.
873      */
874     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
875         return
876             interfaceId == type(IERC721).interfaceId ||
877             interfaceId == type(IERC721Metadata).interfaceId ||
878             super.supportsInterface(interfaceId);
879     }
880 
881     /**
882      * @dev See {IERC721-balanceOf}.
883      */
884     function balanceOf(address owner) public view override returns (uint256) {
885         if (owner == address(0)) revert BalanceQueryForZeroAddress();
886         return uint256(_addressData[owner].balance);
887     }
888 
889     /**
890      * Returns the number of tokens minted by `owner`.
891      */
892     function _numberMinted(address owner) internal view returns (uint256) {
893         return uint256(_addressData[owner].numberMinted);
894     }
895 
896     /**
897      * Returns the number of tokens burned by or on behalf of `owner`.
898      */
899     function _numberBurned(address owner) internal view returns (uint256) {
900         return uint256(_addressData[owner].numberBurned);
901     }
902 
903     /**
904      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
905      */
906     function _getAux(address owner) internal view returns (uint64) {
907         return _addressData[owner].aux;
908     }
909 
910     /**
911      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
912      * If there are multiple variables, please pack them into a uint64.
913      */
914     function _setAux(address owner, uint64 aux) internal {
915         _addressData[owner].aux = aux;
916     }
917 
918     /**
919      * Gas spent here starts off proportional to the maximum mint batch size.
920      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
921      */
922     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
923         uint256 curr = tokenId;
924 
925         unchecked {
926             if (_startTokenId() <= curr && curr < _currentIndex) {
927                 TokenOwnership memory ownership = _ownerships[curr];
928                 if (!ownership.burned) {
929                     if (ownership.addr != address(0)) {
930                         return ownership;
931                     }
932                     // Invariant:
933                     // There will always be an ownership that has an address and is not burned
934                     // before an ownership that does not have an address and is not burned.
935                     // Hence, curr will not underflow.
936                     while (true) {
937                         curr--;
938                         ownership = _ownerships[curr];
939                         if (ownership.addr != address(0)) {
940                             return ownership;
941                         }
942                     }
943                 }
944             }
945         }
946         revert OwnerQueryForNonexistentToken();
947     }
948 
949     /**
950      * @dev See {IERC721-ownerOf}.
951      */
952     function ownerOf(uint256 tokenId) public view override returns (address) {
953         return _ownershipOf(tokenId).addr;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-name}.
958      */
959     function name() public view virtual override returns (string memory) {
960         return _name;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-symbol}.
965      */
966     function symbol() public view virtual override returns (string memory) {
967         return _symbol;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-tokenURI}.
972      */
973     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
974         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
975 
976         string memory baseURI = _baseURI();
977         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
978     }
979 
980     /**
981      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
982      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
983      * by default, can be overriden in child contracts.
984      */
985     function _baseURI() internal view virtual returns (string memory) {
986         return '';
987     }
988 
989     /**
990      * @dev See {IERC721-approve}.
991      */
992     function approve(address to, uint256 tokenId) public override {
993         address owner = ERC721A.ownerOf(tokenId);
994         if (to == owner) revert ApprovalToCurrentOwner();
995 
996         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
997             revert ApprovalCallerNotOwnerNorApproved();
998         }
999 
1000         _approve(to, tokenId, owner);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-getApproved}.
1005      */
1006     function getApproved(uint256 tokenId) public view override returns (address) {
1007         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1008 
1009         return _tokenApprovals[tokenId];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-setApprovalForAll}.
1014      */
1015     function setApprovalForAll(address operator, bool approved) public virtual override {
1016         if (operator == _msgSender()) revert ApproveToCaller();
1017 
1018         _operatorApprovals[_msgSender()][operator] = approved;
1019         emit ApprovalForAll(_msgSender(), operator, approved);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-isApprovedForAll}.
1024      */
1025     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1026         return _operatorApprovals[owner][operator];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-transferFrom}.
1031      */
1032     function transferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         _transfer(from, to, tokenId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-safeTransferFrom}.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) public virtual override {
1048         safeTransferFrom(from, to, tokenId, '');
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-safeTransferFrom}.
1053      */
1054     function safeTransferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId,
1058         bytes memory _data
1059     ) public virtual override {
1060         _transfer(from, to, tokenId);
1061         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1062             revert TransferToNonERC721ReceiverImplementer();
1063         }
1064     }
1065 
1066     /**
1067      * @dev Returns whether `tokenId` exists.
1068      *
1069      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1070      *
1071      * Tokens start existing when they are minted (`_mint`),
1072      */
1073     function _exists(uint256 tokenId) internal view returns (bool) {
1074         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1075     }
1076 
1077     /**
1078      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1079      */
1080     function _safeMint(address to, uint256 quantity) internal {
1081         _safeMint(to, quantity, '');
1082     }
1083 
1084     /**
1085      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1086      *
1087      * Requirements:
1088      *
1089      * - If `to` refers to a smart contract, it must implement 
1090      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1091      * - `quantity` must be greater than 0.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _safeMint(
1096         address to,
1097         uint256 quantity,
1098         bytes memory _data
1099     ) internal {
1100         uint256 startTokenId = _currentIndex;
1101         if (to == address(0)) revert MintToZeroAddress();
1102         if (quantity == 0) revert MintZeroQuantity();
1103 
1104         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1105 
1106         // Overflows are incredibly unrealistic.
1107         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1108         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1109         unchecked {
1110             _addressData[to].balance += uint64(quantity);
1111             _addressData[to].numberMinted += uint64(quantity);
1112 
1113             _ownerships[startTokenId].addr = to;
1114             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1115 
1116             uint256 updatedIndex = startTokenId;
1117             uint256 end = updatedIndex + quantity;
1118 
1119             if (to.isContract()) {
1120                 do {
1121                     emit Transfer(address(0), to, updatedIndex);
1122                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1123                         revert TransferToNonERC721ReceiverImplementer();
1124                     }
1125                 } while (updatedIndex != end);
1126                 // Reentrancy protection
1127                 if (_currentIndex != startTokenId) revert();
1128             } else {
1129                 do {
1130                     emit Transfer(address(0), to, updatedIndex++);
1131                 } while (updatedIndex != end);
1132             }
1133             _currentIndex = updatedIndex;
1134         }
1135         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1136     }
1137 
1138     /**
1139      * @dev Mints `quantity` tokens and transfers them to `to`.
1140      *
1141      * Requirements:
1142      *
1143      * - `to` cannot be the zero address.
1144      * - `quantity` must be greater than 0.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function _mint(address to, uint256 quantity) internal {
1149         uint256 startTokenId = _currentIndex;
1150         if (to == address(0)) revert MintToZeroAddress();
1151         if (quantity == 0) revert MintZeroQuantity();
1152 
1153         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1154 
1155         // Overflows are incredibly unrealistic.
1156         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1157         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1158         unchecked {
1159             _addressData[to].balance += uint64(quantity);
1160             _addressData[to].numberMinted += uint64(quantity);
1161 
1162             _ownerships[startTokenId].addr = to;
1163             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1164 
1165             uint256 updatedIndex = startTokenId;
1166             uint256 end = updatedIndex + quantity;
1167 
1168             do {
1169                 emit Transfer(address(0), to, updatedIndex++);
1170             } while (updatedIndex != end);
1171 
1172             _currentIndex = updatedIndex;
1173         }
1174         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1175     }
1176 
1177     /**
1178      * @dev Transfers `tokenId` from `from` to `to`.
1179      *
1180      * Requirements:
1181      *
1182      * - `to` cannot be the zero address.
1183      * - `tokenId` token must be owned by `from`.
1184      *
1185      * Emits a {Transfer} event.
1186      */
1187     function _transfer(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) private {
1192         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1193 
1194         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1195 
1196         bool isApprovedOrOwner = (_msgSender() == from ||
1197             isApprovedForAll(from, _msgSender()) ||
1198             getApproved(tokenId) == _msgSender());
1199 
1200         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1201         if (to == address(0)) revert TransferToZeroAddress();
1202 
1203         _beforeTokenTransfers(from, to, tokenId, 1);
1204 
1205         // Clear approvals from the previous owner
1206         _approve(address(0), tokenId, from);
1207 
1208         // Underflow of the sender's balance is impossible because we check for
1209         // ownership above and the recipient's balance can't realistically overflow.
1210         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1211         unchecked {
1212             _addressData[from].balance -= 1;
1213             _addressData[to].balance += 1;
1214 
1215             TokenOwnership storage currSlot = _ownerships[tokenId];
1216             currSlot.addr = to;
1217             currSlot.startTimestamp = uint64(block.timestamp);
1218 
1219             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1220             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1221             uint256 nextTokenId = tokenId + 1;
1222             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1223             if (nextSlot.addr == address(0)) {
1224                 // This will suffice for checking _exists(nextTokenId),
1225                 // as a burned slot cannot contain the zero address.
1226                 if (nextTokenId != _currentIndex) {
1227                     nextSlot.addr = from;
1228                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1229                 }
1230             }
1231         }
1232 
1233         emit Transfer(from, to, tokenId);
1234         _afterTokenTransfers(from, to, tokenId, 1);
1235     }
1236 
1237     /**
1238      * @dev Equivalent to `_burn(tokenId, false)`.
1239      */
1240     function _burn(uint256 tokenId) internal virtual {
1241         _burn(tokenId, false);
1242     }
1243 
1244     /**
1245      * @dev Destroys `tokenId`.
1246      * The approval is cleared when the token is burned.
1247      *
1248      * Requirements:
1249      *
1250      * - `tokenId` must exist.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1255         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1256 
1257         address from = prevOwnership.addr;
1258 
1259         if (approvalCheck) {
1260             bool isApprovedOrOwner = (_msgSender() == from ||
1261                 isApprovedForAll(from, _msgSender()) ||
1262                 getApproved(tokenId) == _msgSender());
1263 
1264             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1265         }
1266 
1267         _beforeTokenTransfers(from, address(0), tokenId, 1);
1268 
1269         // Clear approvals from the previous owner
1270         _approve(address(0), tokenId, from);
1271 
1272         // Underflow of the sender's balance is impossible because we check for
1273         // ownership above and the recipient's balance can't realistically overflow.
1274         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1275         unchecked {
1276             AddressData storage addressData = _addressData[from];
1277             addressData.balance -= 1;
1278             addressData.numberBurned += 1;
1279 
1280             // Keep track of who burned the token, and the timestamp of burning.
1281             TokenOwnership storage currSlot = _ownerships[tokenId];
1282             currSlot.addr = from;
1283             currSlot.startTimestamp = uint64(block.timestamp);
1284             currSlot.burned = true;
1285 
1286             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1287             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1288             uint256 nextTokenId = tokenId + 1;
1289             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1290             if (nextSlot.addr == address(0)) {
1291                 // This will suffice for checking _exists(nextTokenId),
1292                 // as a burned slot cannot contain the zero address.
1293                 if (nextTokenId != _currentIndex) {
1294                     nextSlot.addr = from;
1295                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1296                 }
1297             }
1298         }
1299 
1300         emit Transfer(from, address(0), tokenId);
1301         _afterTokenTransfers(from, address(0), tokenId, 1);
1302 
1303         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1304         unchecked {
1305             _burnCounter++;
1306         }
1307     }
1308 
1309     /**
1310      * @dev Approve `to` to operate on `tokenId`
1311      *
1312      * Emits a {Approval} event.
1313      */
1314     function _approve(
1315         address to,
1316         uint256 tokenId,
1317         address owner
1318     ) private {
1319         _tokenApprovals[tokenId] = to;
1320         emit Approval(owner, to, tokenId);
1321     }
1322 
1323     /**
1324      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1325      *
1326      * @param from address representing the previous owner of the given token ID
1327      * @param to target address that will receive the tokens
1328      * @param tokenId uint256 ID of the token to be transferred
1329      * @param _data bytes optional data to send along with the call
1330      * @return bool whether the call correctly returned the expected magic value
1331      */
1332     function _checkContractOnERC721Received(
1333         address from,
1334         address to,
1335         uint256 tokenId,
1336         bytes memory _data
1337     ) private returns (bool) {
1338         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1339             return retval == IERC721Receiver(to).onERC721Received.selector;
1340         } catch (bytes memory reason) {
1341             if (reason.length == 0) {
1342                 revert TransferToNonERC721ReceiverImplementer();
1343             } else {
1344                 assembly {
1345                     revert(add(32, reason), mload(reason))
1346                 }
1347             }
1348         }
1349     }
1350 
1351     /**
1352      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1353      * And also called before burning one token.
1354      *
1355      * startTokenId - the first token id to be transferred
1356      * quantity - the amount to be transferred
1357      *
1358      * Calling conditions:
1359      *
1360      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1361      * transferred to `to`.
1362      * - When `from` is zero, `tokenId` will be minted for `to`.
1363      * - When `to` is zero, `tokenId` will be burned by `from`.
1364      * - `from` and `to` are never both zero.
1365      */
1366     function _beforeTokenTransfers(
1367         address from,
1368         address to,
1369         uint256 startTokenId,
1370         uint256 quantity
1371     ) internal virtual {}
1372 
1373     /**
1374      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1375      * minting.
1376      * And also called after one token has been burned.
1377      *
1378      * startTokenId - the first token id to be transferred
1379      * quantity - the amount to be transferred
1380      *
1381      * Calling conditions:
1382      *
1383      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1384      * transferred to `to`.
1385      * - When `from` is zero, `tokenId` has been minted for `to`.
1386      * - When `to` is zero, `tokenId` has been burned by `from`.
1387      * - `from` and `to` are never both zero.
1388      */
1389     function _afterTokenTransfers(
1390         address from,
1391         address to,
1392         uint256 startTokenId,
1393         uint256 quantity
1394     ) internal virtual {}
1395 }
1396 // File: contracts/Boredy00tsdogeclub.sol
1397 
1398 pragma solidity ^0.8.13;
1399 
1400 interface IOperatorFilterRegistry {
1401     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1402     function register(address registrant) external;
1403     function registerAndSubscribe(address registrant, address subscription) external;
1404     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1405     function updateOperator(address registrant, address operator, bool filtered) external;
1406     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1407     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1408     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1409     function subscribe(address registrant, address registrantToSubscribe) external;
1410     function unsubscribe(address registrant, bool copyExistingEntries) external;
1411     function subscriptionOf(address addr) external returns (address registrant);
1412     function subscribers(address registrant) external returns (address[] memory);
1413     function subscriberAt(address registrant, uint256 index) external returns (address);
1414     function copyEntriesOf(address registrant, address registrantToCopy) external;
1415     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1416     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1417     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1418     function filteredOperators(address addr) external returns (address[] memory);
1419     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1420     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1421     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1422     function isRegistered(address addr) external returns (bool);
1423     function codeHashOf(address addr) external returns (bytes32);
1424 }
1425 pragma solidity ^0.8.13;
1426 
1427 
1428 
1429 abstract contract OperatorFilterer {
1430     error OperatorNotAllowed(address operator);
1431 
1432     IOperatorFilterRegistry constant operatorFilterRegistry =
1433         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1434 
1435     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1436         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1437         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1438         // order for the modifier to filter addresses.
1439         if (address(operatorFilterRegistry).code.length > 0) {
1440             if (subscribe) {
1441                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1442             } else {
1443                 if (subscriptionOrRegistrantToCopy != address(0)) {
1444                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1445                 } else {
1446                     operatorFilterRegistry.register(address(this));
1447                 }
1448             }
1449         }
1450     }
1451 
1452     modifier onlyAllowedOperator(address from) virtual {
1453         // Check registry code length to facilitate testing in environments without a deployed registry.
1454         if (address(operatorFilterRegistry).code.length > 0) {
1455             // Allow spending tokens from addresses with balance
1456             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1457             // from an EOA.
1458             if (from == msg.sender) {
1459                 _;
1460                 return;
1461             }
1462             if (
1463                 !(
1464                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1465                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1466                 )
1467             ) {
1468                 revert OperatorNotAllowed(msg.sender);
1469             }
1470         }
1471         _;
1472     }
1473 }
1474 pragma solidity ^0.8.13;
1475 
1476 
1477 
1478 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1479     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1480 
1481     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1482 }
1483     pragma solidity ^0.8.13;
1484         interface IMain {
1485    
1486 function balanceOf( address ) external  view returns (uint);
1487 
1488 }
1489 
1490 
1491 
1492 pragma solidity ^0.8.0;
1493 
1494 
1495 
1496 
1497 
1498 contract Boredy00tsdogeclub is ERC721A,DefaultOperatorFilterer, Ownable, ReentrancyGuard {
1499   using Address for address;
1500   using Strings for uint;
1501 
1502 
1503   string  public  baseTokenURI = "ipfs://bafybeihufu27pso3b2xmu6ntvln4amkfcph3y727wpxeplalxjro723jji/";
1504   uint256  public  maxSupply = 10000;
1505   uint256 public  MAX_MINTS_PER_TX = 20;
1506   uint256 public  PUBLIC_SALE_PRICE = 0.0035 ether;
1507   uint256 public  NUM_FREE_MINTS = 2000;
1508   uint256 public  MAX_FREE_PER_WALLET = 2;
1509   uint256 public freeNFTAlreadyMinted = 0;
1510   bool public isPublicSaleActive = true;
1511 
1512   constructor(
1513 
1514   ) ERC721A("Bored Y00ts Doge Club", "BYDC") {
1515 
1516   }
1517 
1518 
1519   function mint(uint256 numberOfTokens)
1520       external
1521       payable
1522   {
1523     require(isPublicSaleActive, "Public sale is not open");
1524     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1525 
1526     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1527         require(
1528             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1529             "Incorrect ETH value sent"
1530         );
1531     } else {
1532         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1533         require(
1534             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1535             "Incorrect ETH value sent"
1536         );
1537         require(
1538             numberOfTokens <= MAX_MINTS_PER_TX,
1539             "Max mints per transaction exceeded"
1540         );
1541         } else {
1542             require(
1543                 numberOfTokens <= MAX_FREE_PER_WALLET,
1544                 "Max mints per transaction exceeded"
1545             );
1546             freeNFTAlreadyMinted += numberOfTokens;
1547         }
1548     }
1549     _safeMint(msg.sender, numberOfTokens);
1550   }
1551 
1552   function setBaseURI(string memory baseURI)
1553     public
1554     onlyOwner
1555   {
1556     baseTokenURI = baseURI;
1557   }
1558 
1559   function treasuryMint(uint quantity)
1560     public
1561     onlyOwner
1562   {
1563     require(
1564       quantity > 0,
1565       "Invalid mint amount"
1566     );
1567     require(
1568       totalSupply() + quantity <= maxSupply,
1569       "Maximum supply exceeded"
1570     );
1571     _safeMint(msg.sender, quantity);
1572   }
1573 
1574   function withdraw()
1575     public
1576     onlyOwner
1577     nonReentrant
1578   {
1579     Address.sendValue(payable(msg.sender), address(this).balance);
1580   }
1581 
1582   function tokenURI(uint _tokenId)
1583     public
1584     view
1585     virtual
1586     override
1587     returns (string memory)
1588   {
1589     require(
1590       _exists(_tokenId),
1591       "ERC721Metadata: URI query for nonexistent token"
1592     );
1593     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1594   }
1595 
1596   function _baseURI()
1597     internal
1598     view
1599     virtual
1600     override
1601     returns (string memory)
1602   {
1603     return baseTokenURI;
1604   }
1605 
1606   function setIsPublicSaleActive(bool _isPublicSaleActive)
1607       external
1608       onlyOwner
1609   {
1610       isPublicSaleActive = _isPublicSaleActive;
1611   }
1612 
1613   function setNumFreeMints(uint256 _numfreemints)
1614       external
1615       onlyOwner
1616   {
1617       NUM_FREE_MINTS = _numfreemints;
1618   }
1619 
1620   function setSalePrice(uint256 _price)
1621       external
1622       onlyOwner
1623   {
1624       PUBLIC_SALE_PRICE = _price;
1625   }
1626 
1627   function setMaxLimitPerTransaction(uint256 _limit)
1628       external
1629       onlyOwner
1630   {
1631       MAX_MINTS_PER_TX = _limit;
1632   }
1633 
1634   function setFreeLimitPerWallet(uint256 _limit)
1635       external
1636       onlyOwner
1637   {
1638       MAX_FREE_PER_WALLET = _limit;
1639   }
1640   function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1641         super.transferFrom(from, to, tokenId);
1642     }
1643 
1644     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1645         super.safeTransferFrom(from, to, tokenId);
1646     }
1647 
1648     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1649         public
1650         override
1651         onlyAllowedOperator(from)
1652     {
1653         super.safeTransferFrom(from, to, tokenId, data);
1654     }
1655 }