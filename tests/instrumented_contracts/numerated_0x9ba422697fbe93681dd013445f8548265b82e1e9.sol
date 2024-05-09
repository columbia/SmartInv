1 /**
2 
3 MMP"""""""MM                                                    dP    MMP"""""""MM                               MM'""""'YMM dP          dP       
4 M' .mmmm  MM                                                    88    M' .mmmm  MM                               M' .mmm. `M 88          88       
5 M         `M 88d888b. 88d888b. .d8888b. dP    dP .d8888b. .d888b88    M         `M 88d888b. .d8888b. .d8888b.    M  MMMMMooM 88 dP    dP 88d888b. 
6 M  MMMMM  MM 88'  `88 88'  `88 88'  `88 88    88 88ooood8 88'  `88    M  MMMMM  MM 88'  `88 88ooood8 Y8ooooo.    M  MMMMMMMM 88 88    88 88'  `88 
7 M  MMMMM  MM 88    88 88    88 88.  .88 88.  .88 88.  ... 88.  .88    M  MMMMM  MM 88.  .88 88.  ...       88    M. `MMM' .M 88 88.  .88 88.  .88 
8 M  MMMMM  MM dP    dP dP    dP `88888P' `8888P88 `88888P' `88888P8    M  MMMMM  MM 88Y888P' `88888P' `88888P'    MM.     .dM dP `88888P' 88Y8888' 
9 MMMMMMMMMMMM                                 .88                      MMMMMMMMMMMM 88                            MMMMMMMMMMM                      
10                                          d8888P                                    dP                                                             
11 
12 */
13 
14 
15 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
16 
17 // SPDX-License-Identifier: MIT
18 
19 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev Contract module that helps prevent reentrant calls to a function.
25  *
26  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
27  * available, which can be applied to functions to make sure there are no nested
28  * (reentrant) calls to them.
29  *
30  * Note that because there is a single `nonReentrant` guard, functions marked as
31  * `nonReentrant` may not call one another. This can be worked around by making
32  * those functions `private`, and then adding `external` `nonReentrant` entry
33  * points to them.
34  *
35  * TIP: If you would like to learn more about reentrancy and alternative ways
36  * to protect against it, check out our blog post
37  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
38  */
39 abstract contract ReentrancyGuard {
40     // Booleans are more expensive than uint256 or any type that takes up a full
41     // word because each write operation emits an extra SLOAD to first read the
42     // slot's contents, replace the bits taken up by the boolean, and then write
43     // back. This is the compiler's defense against contract upgrades and
44     // pointer aliasing, and it cannot be disabled.
45 
46     // The values being non-zero value makes deployment a bit more expensive,
47     // but in exchange the refund on every call to nonReentrant will be lower in
48     // amount. Since refunds are capped to a percentage of the total
49     // transaction's gas, it is best to keep them low in cases like this one, to
50     // increase the likelihood of the full refund coming into effect.
51     uint256 private constant _NOT_ENTERED = 1;
52     uint256 private constant _ENTERED = 2;
53 
54     uint256 private _status;
55 
56     constructor() {
57         _status = _NOT_ENTERED;
58     }
59 
60     /**
61      * @dev Prevents a contract from calling itself, directly or indirectly.
62      * Calling a `nonReentrant` function from another `nonReentrant`
63      * function is not supported. It is possible to prevent this from happening
64      * by making the `nonReentrant` function external, and making it call a
65      * `private` function that does the actual work.
66      */
67     modifier nonReentrant() {
68         // On the first call to nonReentrant, _notEntered will be true
69         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
70 
71         // Any calls to nonReentrant after this point will fail
72         _status = _ENTERED;
73 
74         _;
75 
76         // By storing the original value once again, a refund is triggered (see
77         // https://eips.ethereum.org/EIPS/eip-2200)
78         _status = _NOT_ENTERED;
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/Strings.sol
83 
84 
85 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
86 
87 pragma solidity ^0.8.0;
88 
89 /**
90  * @dev String operations.
91  */
92 library Strings {
93     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
94 
95     /**
96      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
97      */
98     function toString(uint256 value) internal pure returns (string memory) {
99         // Inspired by OraclizeAPI's implementation - MIT licence
100         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
101 
102         if (value == 0) {
103             return "0";
104         }
105         uint256 temp = value;
106         uint256 digits;
107         while (temp != 0) {
108             digits++;
109             temp /= 10;
110         }
111         bytes memory buffer = new bytes(digits);
112         while (value != 0) {
113             digits -= 1;
114             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
115             value /= 10;
116         }
117         return string(buffer);
118     }
119 
120     /**
121      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
122      */
123     function toHexString(uint256 value) internal pure returns (string memory) {
124         if (value == 0) {
125             return "0x00";
126         }
127         uint256 temp = value;
128         uint256 length = 0;
129         while (temp != 0) {
130             length++;
131             temp >>= 8;
132         }
133         return toHexString(value, length);
134     }
135 
136     /**
137      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
138      */
139     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
140         bytes memory buffer = new bytes(2 * length + 2);
141         buffer[0] = "0";
142         buffer[1] = "x";
143         for (uint256 i = 2 * length + 1; i > 1; --i) {
144             buffer[i] = _HEX_SYMBOLS[value & 0xf];
145             value >>= 4;
146         }
147         require(value == 0, "Strings: hex length insufficient");
148         return string(buffer);
149     }
150 }
151 
152 // File: @openzeppelin/contracts/utils/Context.sol
153 
154 
155 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 /**
160  * @dev Provides information about the current execution context, including the
161  * sender of the transaction and its data. While these are generally available
162  * via msg.sender and msg.data, they should not be accessed in such a direct
163  * manner, since when dealing with meta-transactions the account sending and
164  * paying for execution may not be the actual sender (as far as an application
165  * is concerned).
166  *
167  * This contract is only required for intermediate, library-like contracts.
168  */
169 abstract contract Context {
170     function _msgSender() internal view virtual returns (address) {
171         return msg.sender;
172     }
173 
174     function _msgData() internal view virtual returns (bytes calldata) {
175         return msg.data;
176     }
177 }
178 
179 // File: @openzeppelin/contracts/access/Ownable.sol
180 
181 
182 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 
187 /**
188  * @dev Contract module which provides a basic access control mechanism, where
189  * there is an account (an owner) that can be granted exclusive access to
190  * specific functions.
191  *
192  * By default, the owner account will be the one that deploys the contract. This
193  * can later be changed with {transferOwnership}.
194  *
195  * This module is used through inheritance. It will make available the modifier
196  * `onlyOwner`, which can be applied to your functions to restrict their use to
197  * the owner.
198  */
199 abstract contract Ownable is Context {
200     address private _owner;
201 
202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204     /**
205      * @dev Initializes the contract setting the deployer as the initial owner.
206      */
207     constructor() {
208         _transferOwnership(_msgSender());
209     }
210 
211     /**
212      * @dev Returns the address of the current owner.
213      */
214     function owner() public view virtual returns (address) {
215         return _owner;
216     }
217 
218     /**
219      * @dev Throws if called by any account other than the owner.
220      */
221     modifier onlyOwner() {
222         require(owner() == _msgSender(), "Ownable: caller is not the owner");
223         _;
224     }
225 
226     /**
227      * @dev Leaves the contract without owner. It will not be possible to call
228      * `onlyOwner` functions anymore. Can only be called by the current owner.
229      *
230      * NOTE: Renouncing ownership will leave the contract without an owner,
231      * thereby removing any functionality that is only available to the owner.
232      */
233     function renounceOwnership() public virtual onlyOwner {
234         _transferOwnership(address(0));
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
239      * Can only be called by the current owner.
240      */
241     function transferOwnership(address newOwner) public virtual onlyOwner {
242         require(newOwner != address(0), "Ownable: new owner is the zero address");
243         _transferOwnership(newOwner);
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Internal function without access restriction.
249      */
250     function _transferOwnership(address newOwner) internal virtual {
251         address oldOwner = _owner;
252         _owner = newOwner;
253         emit OwnershipTransferred(oldOwner, newOwner);
254     }
255 }
256 
257 // File: @openzeppelin/contracts/utils/Address.sol
258 
259 
260 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
261 
262 pragma solidity ^0.8.1;
263 
264 /**
265  * @dev Collection of functions related to the address type
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * [IMPORTANT]
272      * ====
273      * It is unsafe to assume that an address for which this function returns
274      * false is an externally-owned account (EOA) and not a contract.
275      *
276      * Among others, `isContract` will return false for the following
277      * types of addresses:
278      *
279      *  - an externally-owned account
280      *  - a contract in construction
281      *  - an address where a contract will be created
282      *  - an address where a contract lived, but was destroyed
283      * ====
284      *
285      * [IMPORTANT]
286      * ====
287      * You shouldn't rely on `isContract` to protect against flash loan attacks!
288      *
289      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
290      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
291      * constructor.
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // This method relies on extcodesize/address.code.length, which returns 0
296         // for contracts in construction, since the code is only stored at the end
297         // of the constructor execution.
298 
299         return account.code.length > 0;
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         (bool success, ) = recipient.call{value: amount}("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain `call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, 0, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but also transferring `value` wei to `target`.
364      *
365      * Requirements:
366      *
367      * - the calling contract must have an ETH balance of at least `value`.
368      * - the called Solidity function must be `payable`.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(
373         address target,
374         bytes memory data,
375         uint256 value
376     ) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(
387         address target,
388         bytes memory data,
389         uint256 value,
390         string memory errorMessage
391     ) internal returns (bytes memory) {
392         require(address(this).balance >= value, "Address: insufficient balance for call");
393         require(isContract(target), "Address: call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.call{value: value}(data);
396         return verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but performing a static call.
402      *
403      * _Available since v3.3._
404      */
405     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
406         return functionStaticCall(target, data, "Address: low-level static call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
411      * but performing a static call.
412      *
413      * _Available since v3.3._
414      */
415     function functionStaticCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal view returns (bytes memory) {
420         require(isContract(target), "Address: static call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.staticcall(data);
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a delegate call.
429      *
430      * _Available since v3.4._
431      */
432     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
433         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a delegate call.
439      *
440      * _Available since v3.4._
441      */
442     function functionDelegateCall(
443         address target,
444         bytes memory data,
445         string memory errorMessage
446     ) internal returns (bytes memory) {
447         require(isContract(target), "Address: delegate call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.delegatecall(data);
450         return verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
455      * revert reason using the provided one.
456      *
457      * _Available since v4.3._
458      */
459     function verifyCallResult(
460         bool success,
461         bytes memory returndata,
462         string memory errorMessage
463     ) internal pure returns (bytes memory) {
464         if (success) {
465             return returndata;
466         } else {
467             // Look for revert reason and bubble it up if present
468             if (returndata.length > 0) {
469                 // The easiest way to bubble the revert reason is using memory via assembly
470 
471                 assembly {
472                     let returndata_size := mload(returndata)
473                     revert(add(32, returndata), returndata_size)
474                 }
475             } else {
476                 revert(errorMessage);
477             }
478         }
479     }
480 }
481 
482 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
483 
484 
485 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @title ERC721 token receiver interface
491  * @dev Interface for any contract that wants to support safeTransfers
492  * from ERC721 asset contracts.
493  */
494 interface IERC721Receiver {
495     /**
496      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
497      * by `operator` from `from`, this function is called.
498      *
499      * It must return its Solidity selector to confirm the token transfer.
500      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
501      *
502      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
503      */
504     function onERC721Received(
505         address operator,
506         address from,
507         uint256 tokenId,
508         bytes calldata data
509     ) external returns (bytes4);
510 }
511 
512 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
513 
514 
515 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
516 
517 pragma solidity ^0.8.0;
518 
519 /**
520  * @dev Interface of the ERC165 standard, as defined in the
521  * https://eips.ethereum.org/EIPS/eip-165[EIP].
522  *
523  * Implementers can declare support of contract interfaces, which can then be
524  * queried by others ({ERC165Checker}).
525  *
526  * For an implementation, see {ERC165}.
527  */
528 interface IERC165 {
529     /**
530      * @dev Returns true if this contract implements the interface defined by
531      * `interfaceId`. See the corresponding
532      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
533      * to learn more about how these ids are created.
534      *
535      * This function call must use less than 30 000 gas.
536      */
537     function supportsInterface(bytes4 interfaceId) external view returns (bool);
538 }
539 
540 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @dev Implementation of the {IERC165} interface.
550  *
551  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
552  * for the additional interface id that will be supported. For example:
553  *
554  * ```solidity
555  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
556  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
557  * }
558  * ```
559  *
560  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
561  */
562 abstract contract ERC165 is IERC165 {
563     /**
564      * @dev See {IERC165-supportsInterface}.
565      */
566     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
567         return interfaceId == type(IERC165).interfaceId;
568     }
569 }
570 
571 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
572 
573 
574 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 
579 /**
580  * @dev Required interface of an ERC721 compliant contract.
581  */
582 interface IERC721 is IERC165 {
583     /**
584      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
585      */
586     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
587 
588     /**
589      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
590      */
591     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
592 
593     /**
594      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
595      */
596     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
597 
598     /**
599      * @dev Returns the number of tokens in ``owner``'s account.
600      */
601     function balanceOf(address owner) external view returns (uint256 balance);
602 
603     /**
604      * @dev Returns the owner of the `tokenId` token.
605      *
606      * Requirements:
607      *
608      * - `tokenId` must exist.
609      */
610     function ownerOf(uint256 tokenId) external view returns (address owner);
611 
612     /**
613      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
614      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
615      *
616      * Requirements:
617      *
618      * - `from` cannot be the zero address.
619      * - `to` cannot be the zero address.
620      * - `tokenId` token must exist and be owned by `from`.
621      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
622      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
623      *
624      * Emits a {Transfer} event.
625      */
626     function safeTransferFrom(
627         address from,
628         address to,
629         uint256 tokenId
630     ) external;
631 
632     /**
633      * @dev Transfers `tokenId` token from `from` to `to`.
634      *
635      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
636      *
637      * Requirements:
638      *
639      * - `from` cannot be the zero address.
640      * - `to` cannot be the zero address.
641      * - `tokenId` token must be owned by `from`.
642      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
643      *
644      * Emits a {Transfer} event.
645      */
646     function transferFrom(
647         address from,
648         address to,
649         uint256 tokenId
650     ) external;
651 
652     /**
653      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
654      * The approval is cleared when the token is transferred.
655      *
656      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
657      *
658      * Requirements:
659      *
660      * - The caller must own the token or be an approved operator.
661      * - `tokenId` must exist.
662      *
663      * Emits an {Approval} event.
664      */
665     function approve(address to, uint256 tokenId) external;
666 
667     /**
668      * @dev Returns the account approved for `tokenId` token.
669      *
670      * Requirements:
671      *
672      * - `tokenId` must exist.
673      */
674     function getApproved(uint256 tokenId) external view returns (address operator);
675 
676     /**
677      * @dev Approve or remove `operator` as an operator for the caller.
678      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
679      *
680      * Requirements:
681      *
682      * - The `operator` cannot be the caller.
683      *
684      * Emits an {ApprovalForAll} event.
685      */
686     function setApprovalForAll(address operator, bool _approved) external;
687 
688     /**
689      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
690      *
691      * See {setApprovalForAll}
692      */
693     function isApprovedForAll(address owner, address operator) external view returns (bool);
694 
695     /**
696      * @dev Safely transfers `tokenId` token from `from` to `to`.
697      *
698      * Requirements:
699      *
700      * - `from` cannot be the zero address.
701      * - `to` cannot be the zero address.
702      * - `tokenId` token must exist and be owned by `from`.
703      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
704      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
705      *
706      * Emits a {Transfer} event.
707      */
708     function safeTransferFrom(
709         address from,
710         address to,
711         uint256 tokenId,
712         bytes calldata data
713     ) external;
714 }
715 
716 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
717 
718 
719 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
720 
721 pragma solidity ^0.8.0;
722 
723 
724 /**
725  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
726  * @dev See https://eips.ethereum.org/EIPS/eip-721
727  */
728 interface IERC721Metadata is IERC721 {
729     /**
730      * @dev Returns the token collection name.
731      */
732     function name() external view returns (string memory);
733 
734     /**
735      * @dev Returns the token collection symbol.
736      */
737     function symbol() external view returns (string memory);
738 
739     /**
740      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
741      */
742     function tokenURI(uint256 tokenId) external view returns (string memory);
743 }
744 
745 // File: contracts/ERC721A.sol
746 
747 
748 // Creator: Chiru Labs
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
1396 // File: contracts/AnnoyedApesClub.sol
1397 
1398 
1399 
1400 pragma solidity ^0.8.0;
1401 
1402 
1403 
1404 
1405 
1406 contract AnnoyedApesClub is ERC721A, Ownable, ReentrancyGuard {
1407   using Address for address;
1408   using Strings for uint;
1409 
1410 
1411   string  public  baseTokenURI = "ipfs://bafybeidgpy6zjj2x6axzre2tmwolfnvrw44c5ksi7epbghystqzz5pk2je/";
1412   uint256  public  maxSupply = 5000;
1413   uint256 public  MAX_MINTS_PER_TX = 20;
1414   uint256 public  PUBLIC_SALE_PRICE = 0.003 ether;
1415   uint256 public  NUM_FREE_MINTS = 4000;
1416   uint256 public  MAX_FREE_PER_WALLET = 5;
1417   uint256 public freeNFTAlreadyMinted = 0;
1418   bool public isPublicSaleActive = true;
1419 
1420   constructor(
1421 
1422   ) ERC721A("Annoyed Apes Club", "AAC") {
1423 
1424   }
1425 
1426 
1427   function mint(uint256 numberOfTokens)
1428       external
1429       payable
1430   {
1431     require(isPublicSaleActive, "Public sale is not open");
1432     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1433 
1434     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1435         require(
1436             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1437             "Incorrect ETH value sent"
1438         );
1439     } else {
1440         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1441         require(
1442             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1443             "Incorrect ETH value sent"
1444         );
1445         require(
1446             numberOfTokens <= MAX_MINTS_PER_TX,
1447             "Max mints per transaction exceeded"
1448         );
1449         } else {
1450             require(
1451                 numberOfTokens <= MAX_FREE_PER_WALLET,
1452                 "Max mints per transaction exceeded"
1453             );
1454             freeNFTAlreadyMinted += numberOfTokens;
1455         }
1456     }
1457     _safeMint(msg.sender, numberOfTokens);
1458   }
1459 
1460   function setBaseURI(string memory baseURI)
1461     public
1462     onlyOwner
1463   {
1464     baseTokenURI = baseURI;
1465   }
1466 
1467   function treasuryMint(uint quantity)
1468     public
1469     onlyOwner
1470   {
1471     require(
1472       quantity > 0,
1473       "Invalid mint amount"
1474     );
1475     require(
1476       totalSupply() + quantity <= maxSupply,
1477       "Maximum supply exceeded"
1478     );
1479     _safeMint(msg.sender, quantity);
1480   }
1481 
1482   function withdraw()
1483     public
1484     onlyOwner
1485     nonReentrant
1486   {
1487     Address.sendValue(payable(msg.sender), address(this).balance);
1488   }
1489 
1490   function tokenURI(uint _tokenId)
1491     public
1492     view
1493     virtual
1494     override
1495     returns (string memory)
1496   {
1497     require(
1498       _exists(_tokenId),
1499       "ERC721Metadata: URI query for nonexistent token"
1500     );
1501     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1502   }
1503 
1504   function _baseURI()
1505     internal
1506     view
1507     virtual
1508     override
1509     returns (string memory)
1510   {
1511     return baseTokenURI;
1512   }
1513 
1514   function setIsPublicSaleActive(bool _isPublicSaleActive)
1515       external
1516       onlyOwner
1517   {
1518       isPublicSaleActive = _isPublicSaleActive;
1519   }
1520 
1521   function setNumFreeMints(uint256 _numfreemints)
1522       external
1523       onlyOwner
1524   {
1525       NUM_FREE_MINTS = _numfreemints;
1526   }
1527 
1528   function setSalePrice(uint256 _price)
1529       external
1530       onlyOwner
1531   {
1532       PUBLIC_SALE_PRICE = _price;
1533   }
1534 
1535   function setMaxLimitPerTransaction(uint256 _limit)
1536       external
1537       onlyOwner
1538   {
1539       MAX_MINTS_PER_TX = _limit;
1540   }
1541 
1542   function setFreeLimitPerWallet(uint256 _limit)
1543       external
1544       onlyOwner
1545   {
1546       MAX_FREE_PER_WALLET = _limit;
1547   }
1548 }