1 /**
2 
3  ______   _______           _        ______  _________ _______  ______   _______ 
4 (  __  \ (  ___  )|\     /|( (    /|(  ___ \ \__   __/(  ____ )(  __  \ (  ____ \
5 | (  \  )| (   ) || )   ( ||  \  ( || (   ) )   ) (   | (    )|| (  \  )| (    \/
6 | |   ) || |   | || | _ | ||   \ | || (__/ /    | |   | (____)|| |   ) || (_____ 
7 | |   | || |   | || |( )| || (\ \) ||  __ (     | |   |     __)| |   | |(_____  )
8 | |   ) || |   | || || || || | \   || (  \ \    | |   | (\ (   | |   ) |      ) |
9 | (__/  )| (___) || () () || )  \  || )___) )___) (___| ) \ \__| (__/  )/\____) |
10 (______/ (_______)(_______)|/    )_)|/ \___/ \_______/|/   \__/(______/ \_______)
11                                                                                  
12                               
13 
14 */
15 
16 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
17 
18 // SPDX-License-Identifier: MIT
19 
20 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev Contract module that helps prevent reentrant calls to a function.
26  *
27  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
28  * available, which can be applied to functions to make sure there are no nested
29  * (reentrant) calls to them.
30  *
31  * Note that because there is a single `nonReentrant` guard, functions marked as
32  * `nonReentrant` may not call one another. This can be worked around by making
33  * those functions `private`, and then adding `external` `nonReentrant` entry
34  * points to them.
35  *
36  * TIP: If you would like to learn more about reentrancy and alternative ways
37  * to protect against it, check out our blog post
38  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
39  */
40 abstract contract ReentrancyGuard {
41     // Booleans are more expensive than uint256 or any type that takes up a full
42     // word because each write operation emits an extra SLOAD to first read the
43     // slot's contents, replace the bits taken up by the boolean, and then write
44     // back. This is the compiler's defense against contract upgrades and
45     // pointer aliasing, and it cannot be disabled.
46 
47     // The values being non-zero value makes deployment a bit more expensive,
48     // but in exchange the refund on every call to nonReentrant will be lower in
49     // amount. Since refunds are capped to a percentage of the total
50     // transaction's gas, it is best to keep them low in cases like this one, to
51     // increase the likelihood of the full refund coming into effect.
52     uint256 private constant _NOT_ENTERED = 1;
53     uint256 private constant _ENTERED = 2;
54 
55     uint256 private _status;
56 
57     constructor() {
58         _status = _NOT_ENTERED;
59     }
60 
61     /**
62      * @dev Prevents a contract from calling itself, directly or indirectly.
63      * Calling a `nonReentrant` function from another `nonReentrant`
64      * function is not supported. It is possible to prevent this from happening
65      * by making the `nonReentrant` function external, and making it call a
66      * `private` function that does the actual work.
67      */
68     modifier nonReentrant() {
69         // On the first call to nonReentrant, _notEntered will be true
70         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
71 
72         // Any calls to nonReentrant after this point will fail
73         _status = _ENTERED;
74 
75         _;
76 
77         // By storing the original value once again, a refund is triggered (see
78         // https://eips.ethereum.org/EIPS/eip-2200)
79         _status = _NOT_ENTERED;
80     }
81 }
82 
83 // File: @openzeppelin/contracts/utils/Strings.sol
84 
85 
86 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev String operations.
92  */
93 library Strings {
94     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
95 
96     /**
97      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
98      */
99     function toString(uint256 value) internal pure returns (string memory) {
100         // Inspired by OraclizeAPI's implementation - MIT licence
101         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
102 
103         if (value == 0) {
104             return "0";
105         }
106         uint256 temp = value;
107         uint256 digits;
108         while (temp != 0) {
109             digits++;
110             temp /= 10;
111         }
112         bytes memory buffer = new bytes(digits);
113         while (value != 0) {
114             digits -= 1;
115             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
116             value /= 10;
117         }
118         return string(buffer);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
123      */
124     function toHexString(uint256 value) internal pure returns (string memory) {
125         if (value == 0) {
126             return "0x00";
127         }
128         uint256 temp = value;
129         uint256 length = 0;
130         while (temp != 0) {
131             length++;
132             temp >>= 8;
133         }
134         return toHexString(value, length);
135     }
136 
137     /**
138      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
139      */
140     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
141         bytes memory buffer = new bytes(2 * length + 2);
142         buffer[0] = "0";
143         buffer[1] = "x";
144         for (uint256 i = 2 * length + 1; i > 1; --i) {
145             buffer[i] = _HEX_SYMBOLS[value & 0xf];
146             value >>= 4;
147         }
148         require(value == 0, "Strings: hex length insufficient");
149         return string(buffer);
150     }
151 }
152 
153 // File: @openzeppelin/contracts/utils/Context.sol
154 
155 
156 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 /**
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 abstract contract Context {
171     function _msgSender() internal view virtual returns (address) {
172         return msg.sender;
173     }
174 
175     function _msgData() internal view virtual returns (bytes calldata) {
176         return msg.data;
177     }
178 }
179 
180 // File: @openzeppelin/contracts/access/Ownable.sol
181 
182 
183 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 
188 /**
189  * @dev Contract module which provides a basic access control mechanism, where
190  * there is an account (an owner) that can be granted exclusive access to
191  * specific functions.
192  *
193  * By default, the owner account will be the one that deploys the contract. This
194  * can later be changed with {transferOwnership}.
195  *
196  * This module is used through inheritance. It will make available the modifier
197  * `onlyOwner`, which can be applied to your functions to restrict their use to
198  * the owner.
199  */
200 abstract contract Ownable is Context {
201     address private _owner;
202 
203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
204 
205     /**
206      * @dev Initializes the contract setting the deployer as the initial owner.
207      */
208     constructor() {
209         _transferOwnership(_msgSender());
210     }
211 
212     /**
213      * @dev Returns the address of the current owner.
214      */
215     function owner() public view virtual returns (address) {
216         return _owner;
217     }
218 
219     /**
220      * @dev Throws if called by any account other than the owner.
221      */
222     modifier onlyOwner() {
223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
224         _;
225     }
226 
227     /**
228      * @dev Leaves the contract without owner. It will not be possible to call
229      * `onlyOwner` functions anymore. Can only be called by the current owner.
230      *
231      * NOTE: Renouncing ownership will leave the contract without an owner,
232      * thereby removing any functionality that is only available to the owner.
233      */
234     function renounceOwnership() public virtual onlyOwner {
235         _transferOwnership(address(0));
236     }
237 
238     /**
239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
240      * Can only be called by the current owner.
241      */
242     function transferOwnership(address newOwner) public virtual onlyOwner {
243         require(newOwner != address(0), "Ownable: new owner is the zero address");
244         _transferOwnership(newOwner);
245     }
246 
247     /**
248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
249      * Internal function without access restriction.
250      */
251     function _transferOwnership(address newOwner) internal virtual {
252         address oldOwner = _owner;
253         _owner = newOwner;
254         emit OwnershipTransferred(oldOwner, newOwner);
255     }
256 }
257 
258 // File: @openzeppelin/contracts/utils/Address.sol
259 
260 
261 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
262 
263 pragma solidity ^0.8.1;
264 
265 /**
266  * @dev Collection of functions related to the address type
267  */
268 library Address {
269     /**
270      * @dev Returns true if `account` is a contract.
271      *
272      * [IMPORTANT]
273      * ====
274      * It is unsafe to assume that an address for which this function returns
275      * false is an externally-owned account (EOA) and not a contract.
276      *
277      * Among others, `isContract` will return false for the following
278      * types of addresses:
279      *
280      *  - an externally-owned account
281      *  - a contract in construction
282      *  - an address where a contract will be created
283      *  - an address where a contract lived, but was destroyed
284      * ====
285      *
286      * [IMPORTANT]
287      * ====
288      * You shouldn't rely on `isContract` to protect against flash loan attacks!
289      *
290      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
291      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
292      * constructor.
293      * ====
294      */
295     function isContract(address account) internal view returns (bool) {
296         // This method relies on extcodesize/address.code.length, which returns 0
297         // for contracts in construction, since the code is only stored at the end
298         // of the constructor execution.
299 
300         return account.code.length > 0;
301     }
302 
303     /**
304      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
305      * `recipient`, forwarding all available gas and reverting on errors.
306      *
307      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
308      * of certain opcodes, possibly making contracts go over the 2300 gas limit
309      * imposed by `transfer`, making them unable to receive funds via
310      * `transfer`. {sendValue} removes this limitation.
311      *
312      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
313      *
314      * IMPORTANT: because control is transferred to `recipient`, care must be
315      * taken to not create reentrancy vulnerabilities. Consider using
316      * {ReentrancyGuard} or the
317      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
318      */
319     function sendValue(address payable recipient, uint256 amount) internal {
320         require(address(this).balance >= amount, "Address: insufficient balance");
321 
322         (bool success, ) = recipient.call{value: amount}("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      * @dev Performs a Solidity function call using a low level `call`. A
328      * plain `call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345         return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, 0, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but also transferring `value` wei to `target`.
365      *
366      * Requirements:
367      *
368      * - the calling contract must have an ETH balance of at least `value`.
369      * - the called Solidity function must be `payable`.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(
374         address target,
375         bytes memory data,
376         uint256 value
377     ) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(
388         address target,
389         bytes memory data,
390         uint256 value,
391         string memory errorMessage
392     ) internal returns (bytes memory) {
393         require(address(this).balance >= value, "Address: insufficient balance for call");
394         require(isContract(target), "Address: call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.call{value: value}(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
407         return functionStaticCall(target, data, "Address: low-level static call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal view returns (bytes memory) {
421         require(isContract(target), "Address: static call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.staticcall(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but performing a delegate call.
430      *
431      * _Available since v3.4._
432      */
433     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
434         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(
444         address target,
445         bytes memory data,
446         string memory errorMessage
447     ) internal returns (bytes memory) {
448         require(isContract(target), "Address: delegate call to non-contract");
449 
450         (bool success, bytes memory returndata) = target.delegatecall(data);
451         return verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     /**
455      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
456      * revert reason using the provided one.
457      *
458      * _Available since v4.3._
459      */
460     function verifyCallResult(
461         bool success,
462         bytes memory returndata,
463         string memory errorMessage
464     ) internal pure returns (bytes memory) {
465         if (success) {
466             return returndata;
467         } else {
468             // Look for revert reason and bubble it up if present
469             if (returndata.length > 0) {
470                 // The easiest way to bubble the revert reason is using memory via assembly
471 
472                 assembly {
473                     let returndata_size := mload(returndata)
474                     revert(add(32, returndata), returndata_size)
475                 }
476             } else {
477                 revert(errorMessage);
478             }
479         }
480     }
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
484 
485 
486 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @title ERC721 token receiver interface
492  * @dev Interface for any contract that wants to support safeTransfers
493  * from ERC721 asset contracts.
494  */
495 interface IERC721Receiver {
496     /**
497      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
498      * by `operator` from `from`, this function is called.
499      *
500      * It must return its Solidity selector to confirm the token transfer.
501      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
502      *
503      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
504      */
505     function onERC721Received(
506         address operator,
507         address from,
508         uint256 tokenId,
509         bytes calldata data
510     ) external returns (bytes4);
511 }
512 
513 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
514 
515 
516 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev Interface of the ERC165 standard, as defined in the
522  * https://eips.ethereum.org/EIPS/eip-165[EIP].
523  *
524  * Implementers can declare support of contract interfaces, which can then be
525  * queried by others ({ERC165Checker}).
526  *
527  * For an implementation, see {ERC165}.
528  */
529 interface IERC165 {
530     /**
531      * @dev Returns true if this contract implements the interface defined by
532      * `interfaceId`. See the corresponding
533      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
534      * to learn more about how these ids are created.
535      *
536      * This function call must use less than 30 000 gas.
537      */
538     function supportsInterface(bytes4 interfaceId) external view returns (bool);
539 }
540 
541 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 /**
550  * @dev Implementation of the {IERC165} interface.
551  *
552  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
553  * for the additional interface id that will be supported. For example:
554  *
555  * ```solidity
556  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
558  * }
559  * ```
560  *
561  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
562  */
563 abstract contract ERC165 is IERC165 {
564     /**
565      * @dev See {IERC165-supportsInterface}.
566      */
567     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568         return interfaceId == type(IERC165).interfaceId;
569     }
570 }
571 
572 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
573 
574 
575 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 /**
581  * @dev Required interface of an ERC721 compliant contract.
582  */
583 interface IERC721 is IERC165 {
584     /**
585      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
586      */
587     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
588 
589     /**
590      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
591      */
592     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
593 
594     /**
595      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
596      */
597     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
598 
599     /**
600      * @dev Returns the number of tokens in ``owner``'s account.
601      */
602     function balanceOf(address owner) external view returns (uint256 balance);
603 
604     /**
605      * @dev Returns the owner of the `tokenId` token.
606      *
607      * Requirements:
608      *
609      * - `tokenId` must exist.
610      */
611     function ownerOf(uint256 tokenId) external view returns (address owner);
612 
613     /**
614      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
615      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must exist and be owned by `from`.
622      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
624      *
625      * Emits a {Transfer} event.
626      */
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId
631     ) external;
632 
633     /**
634      * @dev Transfers `tokenId` token from `from` to `to`.
635      *
636      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must be owned by `from`.
643      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
644      *
645      * Emits a {Transfer} event.
646      */
647     function transferFrom(
648         address from,
649         address to,
650         uint256 tokenId
651     ) external;
652 
653     /**
654      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
655      * The approval is cleared when the token is transferred.
656      *
657      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
658      *
659      * Requirements:
660      *
661      * - The caller must own the token or be an approved operator.
662      * - `tokenId` must exist.
663      *
664      * Emits an {Approval} event.
665      */
666     function approve(address to, uint256 tokenId) external;
667 
668     /**
669      * @dev Returns the account approved for `tokenId` token.
670      *
671      * Requirements:
672      *
673      * - `tokenId` must exist.
674      */
675     function getApproved(uint256 tokenId) external view returns (address operator);
676 
677     /**
678      * @dev Approve or remove `operator` as an operator for the caller.
679      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
680      *
681      * Requirements:
682      *
683      * - The `operator` cannot be the caller.
684      *
685      * Emits an {ApprovalForAll} event.
686      */
687     function setApprovalForAll(address operator, bool _approved) external;
688 
689     /**
690      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
691      *
692      * See {setApprovalForAll}
693      */
694     function isApprovedForAll(address owner, address operator) external view returns (bool);
695 
696     /**
697      * @dev Safely transfers `tokenId` token from `from` to `to`.
698      *
699      * Requirements:
700      *
701      * - `from` cannot be the zero address.
702      * - `to` cannot be the zero address.
703      * - `tokenId` token must exist and be owned by `from`.
704      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
705      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
706      *
707      * Emits a {Transfer} event.
708      */
709     function safeTransferFrom(
710         address from,
711         address to,
712         uint256 tokenId,
713         bytes calldata data
714     ) external;
715 }
716 
717 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
718 
719 
720 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 
725 /**
726  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
727  * @dev See https://eips.ethereum.org/EIPS/eip-721
728  */
729 interface IERC721Metadata is IERC721 {
730     /**
731      * @dev Returns the token collection name.
732      */
733     function name() external view returns (string memory);
734 
735     /**
736      * @dev Returns the token collection symbol.
737      */
738     function symbol() external view returns (string memory);
739 
740     /**
741      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
742      */
743     function tokenURI(uint256 tokenId) external view returns (string memory);
744 }
745 
746 // File: contracts/ERC721A.sol
747 
748 
749 // Creator: Chiru Labs
750 
751 pragma solidity ^0.8.4;
752 
753 
754 
755 
756 
757 
758 
759 
760 error ApprovalCallerNotOwnerNorApproved();
761 error ApprovalQueryForNonexistentToken();
762 error ApproveToCaller();
763 error ApprovalToCurrentOwner();
764 error BalanceQueryForZeroAddress();
765 error MintToZeroAddress();
766 error MintZeroQuantity();
767 error OwnerQueryForNonexistentToken();
768 error TransferCallerNotOwnerNorApproved();
769 error TransferFromIncorrectOwner();
770 error TransferToNonERC721ReceiverImplementer();
771 error TransferToZeroAddress();
772 error URIQueryForNonexistentToken();
773 
774 /**
775  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
776  * the Metadata extension. Built to optimize for lower gas during batch mints.
777  *
778  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
779  *
780  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
781  *
782  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
783  */
784 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
785     using Address for address;
786     using Strings for uint256;
787 
788     // Compiler will pack this into a single 256bit word.
789     struct TokenOwnership {
790         // The address of the owner.
791         address addr;
792         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
793         uint64 startTimestamp;
794         // Whether the token has been burned.
795         bool burned;
796     }
797 
798     // Compiler will pack this into a single 256bit word.
799     struct AddressData {
800         // Realistically, 2**64-1 is more than enough.
801         uint64 balance;
802         // Keeps track of mint count with minimal overhead for tokenomics.
803         uint64 numberMinted;
804         // Keeps track of burn count with minimal overhead for tokenomics.
805         uint64 numberBurned;
806         // For miscellaneous variable(s) pertaining to the address
807         // (e.g. number of whitelist mint slots used).
808         // If there are multiple variables, please pack them into a uint64.
809         uint64 aux;
810     }
811 
812     // The tokenId of the next token to be minted.
813     uint256 internal _currentIndex;
814 
815     // The number of tokens burned.
816     uint256 internal _burnCounter;
817 
818     // Token name
819     string private _name;
820 
821     // Token symbol
822     string private _symbol;
823 
824     // Mapping from token ID to ownership details
825     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
826     mapping(uint256 => TokenOwnership) internal _ownerships;
827 
828     // Mapping owner address to address data
829     mapping(address => AddressData) private _addressData;
830 
831     // Mapping from token ID to approved address
832     mapping(uint256 => address) private _tokenApprovals;
833 
834     // Mapping from owner to operator approvals
835     mapping(address => mapping(address => bool)) private _operatorApprovals;
836 
837     constructor(string memory name_, string memory symbol_) {
838         _name = name_;
839         _symbol = symbol_;
840         _currentIndex = _startTokenId();
841     }
842 
843     /**
844      * To change the starting tokenId, please override this function.
845      */
846     function _startTokenId() internal view virtual returns (uint256) {
847         return 1;
848     }
849 
850     /**
851      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
852      */
853     function totalSupply() public view returns (uint256) {
854         // Counter underflow is impossible as _burnCounter cannot be incremented
855         // more than _currentIndex - _startTokenId() times
856         unchecked {
857             return _currentIndex - _burnCounter - _startTokenId();
858         }
859     }
860 
861     /**
862      * Returns the total amount of tokens minted in the contract.
863      */
864     function _totalMinted() internal view returns (uint256) {
865         // Counter underflow is impossible as _currentIndex does not decrement,
866         // and it is initialized to _startTokenId()
867         unchecked {
868             return _currentIndex - _startTokenId();
869         }
870     }
871 
872     /**
873      * @dev See {IERC165-supportsInterface}.
874      */
875     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
876         return
877             interfaceId == type(IERC721).interfaceId ||
878             interfaceId == type(IERC721Metadata).interfaceId ||
879             super.supportsInterface(interfaceId);
880     }
881 
882     /**
883      * @dev See {IERC721-balanceOf}.
884      */
885     function balanceOf(address owner) public view override returns (uint256) {
886         if (owner == address(0)) revert BalanceQueryForZeroAddress();
887         return uint256(_addressData[owner].balance);
888     }
889 
890     /**
891      * Returns the number of tokens minted by `owner`.
892      */
893     function _numberMinted(address owner) internal view returns (uint256) {
894         return uint256(_addressData[owner].numberMinted);
895     }
896 
897     /**
898      * Returns the number of tokens burned by or on behalf of `owner`.
899      */
900     function _numberBurned(address owner) internal view returns (uint256) {
901         return uint256(_addressData[owner].numberBurned);
902     }
903 
904     /**
905      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
906      */
907     function _getAux(address owner) internal view returns (uint64) {
908         return _addressData[owner].aux;
909     }
910 
911     /**
912      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
913      * If there are multiple variables, please pack them into a uint64.
914      */
915     function _setAux(address owner, uint64 aux) internal {
916         _addressData[owner].aux = aux;
917     }
918 
919     /**
920      * Gas spent here starts off proportional to the maximum mint batch size.
921      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
922      */
923     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
924         uint256 curr = tokenId;
925 
926         unchecked {
927             if (_startTokenId() <= curr && curr < _currentIndex) {
928                 TokenOwnership memory ownership = _ownerships[curr];
929                 if (!ownership.burned) {
930                     if (ownership.addr != address(0)) {
931                         return ownership;
932                     }
933                     // Invariant:
934                     // There will always be an ownership that has an address and is not burned
935                     // before an ownership that does not have an address and is not burned.
936                     // Hence, curr will not underflow.
937                     while (true) {
938                         curr--;
939                         ownership = _ownerships[curr];
940                         if (ownership.addr != address(0)) {
941                             return ownership;
942                         }
943                     }
944                 }
945             }
946         }
947         revert OwnerQueryForNonexistentToken();
948     }
949 
950     /**
951      * @dev See {IERC721-ownerOf}.
952      */
953     function ownerOf(uint256 tokenId) public view override returns (address) {
954         return _ownershipOf(tokenId).addr;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-name}.
959      */
960     function name() public view virtual override returns (string memory) {
961         return _name;
962     }
963 
964     /**
965      * @dev See {IERC721Metadata-symbol}.
966      */
967     function symbol() public view virtual override returns (string memory) {
968         return _symbol;
969     }
970 
971     /**
972      * @dev See {IERC721Metadata-tokenURI}.
973      */
974     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
975         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
976 
977         string memory baseURI = _baseURI();
978         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
979     }
980 
981     /**
982      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
983      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
984      * by default, can be overriden in child contracts.
985      */
986     function _baseURI() internal view virtual returns (string memory) {
987         return '';
988     }
989 
990     /**
991      * @dev See {IERC721-approve}.
992      */
993     function approve(address to, uint256 tokenId) public override {
994         address owner = ERC721A.ownerOf(tokenId);
995         if (to == owner) revert ApprovalToCurrentOwner();
996 
997         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
998             revert ApprovalCallerNotOwnerNorApproved();
999         }
1000 
1001         _approve(to, tokenId, owner);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-getApproved}.
1006      */
1007     function getApproved(uint256 tokenId) public view override returns (address) {
1008         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1009 
1010         return _tokenApprovals[tokenId];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-setApprovalForAll}.
1015      */
1016     function setApprovalForAll(address operator, bool approved) public virtual override {
1017         if (operator == _msgSender()) revert ApproveToCaller();
1018 
1019         _operatorApprovals[_msgSender()][operator] = approved;
1020         emit ApprovalForAll(_msgSender(), operator, approved);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-isApprovedForAll}.
1025      */
1026     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1027         return _operatorApprovals[owner][operator];
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-transferFrom}.
1032      */
1033     function transferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) public virtual override {
1038         _transfer(from, to, tokenId);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-safeTransferFrom}.
1043      */
1044     function safeTransferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) public virtual override {
1049         safeTransferFrom(from, to, tokenId, '');
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-safeTransferFrom}.
1054      */
1055     function safeTransferFrom(
1056         address from,
1057         address to,
1058         uint256 tokenId,
1059         bytes memory _data
1060     ) public virtual override {
1061         _transfer(from, to, tokenId);
1062         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1063             revert TransferToNonERC721ReceiverImplementer();
1064         }
1065     }
1066 
1067     /**
1068      * @dev Returns whether `tokenId` exists.
1069      *
1070      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1071      *
1072      * Tokens start existing when they are minted (`_mint`),
1073      */
1074     function _exists(uint256 tokenId) internal view returns (bool) {
1075         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1076     }
1077 
1078     /**
1079      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1080      */
1081     function _safeMint(address to, uint256 quantity) internal {
1082         _safeMint(to, quantity, '');
1083     }
1084 
1085     /**
1086      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1087      *
1088      * Requirements:
1089      *
1090      * - If `to` refers to a smart contract, it must implement 
1091      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1092      * - `quantity` must be greater than 0.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _safeMint(
1097         address to,
1098         uint256 quantity,
1099         bytes memory _data
1100     ) internal {
1101         uint256 startTokenId = _currentIndex;
1102         if (to == address(0)) revert MintToZeroAddress();
1103         if (quantity == 0) revert MintZeroQuantity();
1104 
1105         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1106 
1107         // Overflows are incredibly unrealistic.
1108         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1109         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1110         unchecked {
1111             _addressData[to].balance += uint64(quantity);
1112             _addressData[to].numberMinted += uint64(quantity);
1113 
1114             _ownerships[startTokenId].addr = to;
1115             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1116 
1117             uint256 updatedIndex = startTokenId;
1118             uint256 end = updatedIndex + quantity;
1119 
1120             if (to.isContract()) {
1121                 do {
1122                     emit Transfer(address(0), to, updatedIndex);
1123                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1124                         revert TransferToNonERC721ReceiverImplementer();
1125                     }
1126                 } while (updatedIndex != end);
1127                 // Reentrancy protection
1128                 if (_currentIndex != startTokenId) revert();
1129             } else {
1130                 do {
1131                     emit Transfer(address(0), to, updatedIndex++);
1132                 } while (updatedIndex != end);
1133             }
1134             _currentIndex = updatedIndex;
1135         }
1136         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1137     }
1138 
1139     /**
1140      * @dev Mints `quantity` tokens and transfers them to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - `to` cannot be the zero address.
1145      * - `quantity` must be greater than 0.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _mint(address to, uint256 quantity) internal {
1150         uint256 startTokenId = _currentIndex;
1151         if (to == address(0)) revert MintToZeroAddress();
1152         if (quantity == 0) revert MintZeroQuantity();
1153 
1154         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1155 
1156         // Overflows are incredibly unrealistic.
1157         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1158         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1159         unchecked {
1160             _addressData[to].balance += uint64(quantity);
1161             _addressData[to].numberMinted += uint64(quantity);
1162 
1163             _ownerships[startTokenId].addr = to;
1164             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1165 
1166             uint256 updatedIndex = startTokenId;
1167             uint256 end = updatedIndex + quantity;
1168 
1169             do {
1170                 emit Transfer(address(0), to, updatedIndex++);
1171             } while (updatedIndex != end);
1172 
1173             _currentIndex = updatedIndex;
1174         }
1175         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1176     }
1177 
1178     /**
1179      * @dev Transfers `tokenId` from `from` to `to`.
1180      *
1181      * Requirements:
1182      *
1183      * - `to` cannot be the zero address.
1184      * - `tokenId` token must be owned by `from`.
1185      *
1186      * Emits a {Transfer} event.
1187      */
1188     function _transfer(
1189         address from,
1190         address to,
1191         uint256 tokenId
1192     ) private {
1193         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1194 
1195         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1196 
1197         bool isApprovedOrOwner = (_msgSender() == from ||
1198             isApprovedForAll(from, _msgSender()) ||
1199             getApproved(tokenId) == _msgSender());
1200 
1201         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1202         if (to == address(0)) revert TransferToZeroAddress();
1203 
1204         _beforeTokenTransfers(from, to, tokenId, 1);
1205 
1206         // Clear approvals from the previous owner
1207         _approve(address(0), tokenId, from);
1208 
1209         // Underflow of the sender's balance is impossible because we check for
1210         // ownership above and the recipient's balance can't realistically overflow.
1211         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1212         unchecked {
1213             _addressData[from].balance -= 1;
1214             _addressData[to].balance += 1;
1215 
1216             TokenOwnership storage currSlot = _ownerships[tokenId];
1217             currSlot.addr = to;
1218             currSlot.startTimestamp = uint64(block.timestamp);
1219 
1220             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1221             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1222             uint256 nextTokenId = tokenId + 1;
1223             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1224             if (nextSlot.addr == address(0)) {
1225                 // This will suffice for checking _exists(nextTokenId),
1226                 // as a burned slot cannot contain the zero address.
1227                 if (nextTokenId != _currentIndex) {
1228                     nextSlot.addr = from;
1229                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1230                 }
1231             }
1232         }
1233 
1234         emit Transfer(from, to, tokenId);
1235         _afterTokenTransfers(from, to, tokenId, 1);
1236     }
1237 
1238     /**
1239      * @dev Equivalent to `_burn(tokenId, false)`.
1240      */
1241     function _burn(uint256 tokenId) internal virtual {
1242         _burn(tokenId, false);
1243     }
1244 
1245     /**
1246      * @dev Destroys `tokenId`.
1247      * The approval is cleared when the token is burned.
1248      *
1249      * Requirements:
1250      *
1251      * - `tokenId` must exist.
1252      *
1253      * Emits a {Transfer} event.
1254      */
1255     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1256         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1257 
1258         address from = prevOwnership.addr;
1259 
1260         if (approvalCheck) {
1261             bool isApprovedOrOwner = (_msgSender() == from ||
1262                 isApprovedForAll(from, _msgSender()) ||
1263                 getApproved(tokenId) == _msgSender());
1264 
1265             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1266         }
1267 
1268         _beforeTokenTransfers(from, address(0), tokenId, 1);
1269 
1270         // Clear approvals from the previous owner
1271         _approve(address(0), tokenId, from);
1272 
1273         // Underflow of the sender's balance is impossible because we check for
1274         // ownership above and the recipient's balance can't realistically overflow.
1275         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1276         unchecked {
1277             AddressData storage addressData = _addressData[from];
1278             addressData.balance -= 1;
1279             addressData.numberBurned += 1;
1280 
1281             // Keep track of who burned the token, and the timestamp of burning.
1282             TokenOwnership storage currSlot = _ownerships[tokenId];
1283             currSlot.addr = from;
1284             currSlot.startTimestamp = uint64(block.timestamp);
1285             currSlot.burned = true;
1286 
1287             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1288             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1289             uint256 nextTokenId = tokenId + 1;
1290             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1291             if (nextSlot.addr == address(0)) {
1292                 // This will suffice for checking _exists(nextTokenId),
1293                 // as a burned slot cannot contain the zero address.
1294                 if (nextTokenId != _currentIndex) {
1295                     nextSlot.addr = from;
1296                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1297                 }
1298             }
1299         }
1300 
1301         emit Transfer(from, address(0), tokenId);
1302         _afterTokenTransfers(from, address(0), tokenId, 1);
1303 
1304         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1305         unchecked {
1306             _burnCounter++;
1307         }
1308     }
1309 
1310     /**
1311      * @dev Approve `to` to operate on `tokenId`
1312      *
1313      * Emits a {Approval} event.
1314      */
1315     function _approve(
1316         address to,
1317         uint256 tokenId,
1318         address owner
1319     ) private {
1320         _tokenApprovals[tokenId] = to;
1321         emit Approval(owner, to, tokenId);
1322     }
1323 
1324     /**
1325      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1326      *
1327      * @param from address representing the previous owner of the given token ID
1328      * @param to target address that will receive the tokens
1329      * @param tokenId uint256 ID of the token to be transferred
1330      * @param _data bytes optional data to send along with the call
1331      * @return bool whether the call correctly returned the expected magic value
1332      */
1333     function _checkContractOnERC721Received(
1334         address from,
1335         address to,
1336         uint256 tokenId,
1337         bytes memory _data
1338     ) private returns (bool) {
1339         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1340             return retval == IERC721Receiver(to).onERC721Received.selector;
1341         } catch (bytes memory reason) {
1342             if (reason.length == 0) {
1343                 revert TransferToNonERC721ReceiverImplementer();
1344             } else {
1345                 assembly {
1346                     revert(add(32, reason), mload(reason))
1347                 }
1348             }
1349         }
1350     }
1351 
1352     /**
1353      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1354      * And also called before burning one token.
1355      *
1356      * startTokenId - the first token id to be transferred
1357      * quantity - the amount to be transferred
1358      *
1359      * Calling conditions:
1360      *
1361      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1362      * transferred to `to`.
1363      * - When `from` is zero, `tokenId` will be minted for `to`.
1364      * - When `to` is zero, `tokenId` will be burned by `from`.
1365      * - `from` and `to` are never both zero.
1366      */
1367     function _beforeTokenTransfers(
1368         address from,
1369         address to,
1370         uint256 startTokenId,
1371         uint256 quantity
1372     ) internal virtual {}
1373 
1374     /**
1375      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1376      * minting.
1377      * And also called after one token has been burned.
1378      *
1379      * startTokenId - the first token id to be transferred
1380      * quantity - the amount to be transferred
1381      *
1382      * Calling conditions:
1383      *
1384      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1385      * transferred to `to`.
1386      * - When `from` is zero, `tokenId` has been minted for `to`.
1387      * - When `to` is zero, `tokenId` has been burned by `from`.
1388      * - `from` and `to` are never both zero.
1389      */
1390     function _afterTokenTransfers(
1391         address from,
1392         address to,
1393         uint256 startTokenId,
1394         uint256 quantity
1395     ) internal virtual {}
1396 }
1397 // File: contracts/DownbirdsNFT.sol
1398 
1399 
1400 
1401 pragma solidity ^0.8.0;
1402 
1403 
1404 
1405 
1406 
1407 contract DownbirdsNFT is ERC721A, Ownable, ReentrancyGuard {
1408   using Address for address;
1409   using Strings for uint;
1410 
1411 
1412   string  public  baseTokenURI = "ipfs://QmWYUzjejSGiJwqUjaUEUexdsMHjRgGf9eu2N5Pz8jokrY/";
1413   uint256  public  maxSupply = 4444;
1414   uint256 public  MAX_MINTS_PER_TX = 10;
1415   uint256 public  PUBLIC_SALE_PRICE = 0.002 ether;
1416   uint256 public  NUM_FREE_MINTS = 4444;
1417   uint256 public  MAX_FREE_PER_WALLET = 1;
1418   uint256 public freeNFTAlreadyMinted = 0;
1419   bool public isPublicSaleActive = false;
1420 
1421   constructor(
1422 
1423   ) ERC721A("DownbirdsNFT", "DOWN") {
1424 
1425   }
1426 
1427 
1428   function mint(uint256 numberOfTokens)
1429       external
1430       payable
1431   {
1432     require(isPublicSaleActive, "Public sale is not open");
1433     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1434 
1435     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1436         require(
1437             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1438             "Incorrect ETH value sent"
1439         );
1440     } else {
1441         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1442         require(
1443             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1444             "Incorrect ETH value sent"
1445         );
1446         require(
1447             numberOfTokens <= MAX_MINTS_PER_TX,
1448             "Max mints per transaction exceeded"
1449         );
1450         } else {
1451             require(
1452                 numberOfTokens <= MAX_FREE_PER_WALLET,
1453                 "Max mints per transaction exceeded"
1454             );
1455             freeNFTAlreadyMinted += numberOfTokens;
1456         }
1457     }
1458     _safeMint(msg.sender, numberOfTokens);
1459   }
1460 
1461   function setBaseURI(string memory baseURI)
1462     public
1463     onlyOwner
1464   {
1465     baseTokenURI = baseURI;
1466   }
1467 
1468   function treasuryMint(uint quantity)
1469     public
1470     onlyOwner
1471   {
1472     require(
1473       quantity > 0,
1474       "Invalid mint amount"
1475     );
1476     require(
1477       totalSupply() + quantity <= maxSupply,
1478       "Maximum supply exceeded"
1479     );
1480     _safeMint(msg.sender, quantity);
1481   }
1482 
1483   function withdraw()
1484     public
1485     onlyOwner
1486     nonReentrant
1487   {
1488     Address.sendValue(payable(msg.sender), address(this).balance);
1489   }
1490 
1491   function tokenURI(uint _tokenId)
1492     public
1493     view
1494     virtual
1495     override
1496     returns (string memory)
1497   {
1498     require(
1499       _exists(_tokenId),
1500       "ERC721Metadata: URI query for nonexistent token"
1501     );
1502     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1503   }
1504 
1505   function _baseURI()
1506     internal
1507     view
1508     virtual
1509     override
1510     returns (string memory)
1511   {
1512     return baseTokenURI;
1513   }
1514 
1515   function setIsPublicSaleActive(bool _isPublicSaleActive)
1516       external
1517       onlyOwner
1518   {
1519       isPublicSaleActive = _isPublicSaleActive;
1520   }
1521 
1522   function setNumFreeMints(uint256 _numfreemints)
1523       external
1524       onlyOwner
1525   {
1526       NUM_FREE_MINTS = _numfreemints;
1527   }
1528 
1529   function setSalePrice(uint256 _price)
1530       external
1531       onlyOwner
1532   {
1533       PUBLIC_SALE_PRICE = _price;
1534   }
1535 
1536   function setMaxLimitPerTransaction(uint256 _limit)
1537       external
1538       onlyOwner
1539   {
1540       MAX_MINTS_PER_TX = _limit;
1541   }
1542 
1543   function setFreeLimitPerWallet(uint256 _limit)
1544       external
1545       onlyOwner
1546   {
1547       MAX_FREE_PER_WALLET = _limit;
1548   }
1549 }