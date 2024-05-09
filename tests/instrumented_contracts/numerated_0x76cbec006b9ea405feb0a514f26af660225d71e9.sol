1 // Sources flattened with hardhat v2.8.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 
107 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
108 
109 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Contract module that helps prevent reentrant calls to a function.
115  *
116  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
117  * available, which can be applied to functions to make sure there are no nested
118  * (reentrant) calls to them.
119  *
120  * Note that because there is a single `nonReentrant` guard, functions marked as
121  * `nonReentrant` may not call one another. This can be worked around by making
122  * those functions `private`, and then adding `external` `nonReentrant` entry
123  * points to them.
124  *
125  * TIP: If you would like to learn more about reentrancy and alternative ways
126  * to protect against it, check out our blog post
127  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
128  */
129 abstract contract ReentrancyGuard {
130     // Booleans are more expensive than uint256 or any type that takes up a full
131     // word because each write operation emits an extra SLOAD to first read the
132     // slot's contents, replace the bits taken up by the boolean, and then write
133     // back. This is the compiler's defense against contract upgrades and
134     // pointer aliasing, and it cannot be disabled.
135 
136     // The values being non-zero value makes deployment a bit more expensive,
137     // but in exchange the refund on every call to nonReentrant will be lower in
138     // amount. Since refunds are capped to a percentage of the total
139     // transaction's gas, it is best to keep them low in cases like this one, to
140     // increase the likelihood of the full refund coming into effect.
141     uint256 private constant _NOT_ENTERED = 1;
142     uint256 private constant _ENTERED = 2;
143 
144     uint256 private _status;
145 
146     constructor() {
147         _status = _NOT_ENTERED;
148     }
149 
150     /**
151      * @dev Prevents a contract from calling itself, directly or indirectly.
152      * Calling a `nonReentrant` function from another `nonReentrant`
153      * function is not supported. It is possible to prevent this from happening
154      * by making the `nonReentrant` function external, and making it call a
155      * `private` function that does the actual work.
156      */
157     modifier nonReentrant() {
158         // On the first call to nonReentrant, _notEntered will be true
159         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
160 
161         // Any calls to nonReentrant after this point will fail
162         _status = _ENTERED;
163 
164         _;
165 
166         // By storing the original value once again, a refund is triggered (see
167         // https://eips.ethereum.org/EIPS/eip-2200)
168         _status = _NOT_ENTERED;
169     }
170 }
171 
172 
173 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
174 
175 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev Interface of the ERC165 standard, as defined in the
181  * https://eips.ethereum.org/EIPS/eip-165[EIP].
182  *
183  * Implementers can declare support of contract interfaces, which can then be
184  * queried by others ({ERC165Checker}).
185  *
186  * For an implementation, see {ERC165}.
187  */
188 interface IERC165 {
189     /**
190      * @dev Returns true if this contract implements the interface defined by
191      * `interfaceId`. See the corresponding
192      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
193      * to learn more about how these ids are created.
194      *
195      * This function call must use less than 30 000 gas.
196      */
197     function supportsInterface(bytes4 interfaceId) external view returns (bool);
198 }
199 
200 
201 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
202 
203 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev Required interface of an ERC721 compliant contract.
209  */
210 interface IERC721 is IERC165 {
211     /**
212      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
213      */
214     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
215 
216     /**
217      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
218      */
219     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
220 
221     /**
222      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
223      */
224     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
225 
226     /**
227      * @dev Returns the number of tokens in ``owner``'s account.
228      */
229     function balanceOf(address owner) external view returns (uint256 balance);
230 
231     /**
232      * @dev Returns the owner of the `tokenId` token.
233      *
234      * Requirements:
235      *
236      * - `tokenId` must exist.
237      */
238     function ownerOf(uint256 tokenId) external view returns (address owner);
239 
240     /**
241      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
242      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
243      *
244      * Requirements:
245      *
246      * - `from` cannot be the zero address.
247      * - `to` cannot be the zero address.
248      * - `tokenId` token must exist and be owned by `from`.
249      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
250      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
251      *
252      * Emits a {Transfer} event.
253      */
254     function safeTransferFrom(
255         address from,
256         address to,
257         uint256 tokenId
258     ) external;
259 
260     /**
261      * @dev Transfers `tokenId` token from `from` to `to`.
262      *
263      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
264      *
265      * Requirements:
266      *
267      * - `from` cannot be the zero address.
268      * - `to` cannot be the zero address.
269      * - `tokenId` token must be owned by `from`.
270      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
271      *
272      * Emits a {Transfer} event.
273      */
274     function transferFrom(
275         address from,
276         address to,
277         uint256 tokenId
278     ) external;
279 
280     /**
281      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
282      * The approval is cleared when the token is transferred.
283      *
284      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
285      *
286      * Requirements:
287      *
288      * - The caller must own the token or be an approved operator.
289      * - `tokenId` must exist.
290      *
291      * Emits an {Approval} event.
292      */
293     function approve(address to, uint256 tokenId) external;
294 
295     /**
296      * @dev Returns the account approved for `tokenId` token.
297      *
298      * Requirements:
299      *
300      * - `tokenId` must exist.
301      */
302     function getApproved(uint256 tokenId) external view returns (address operator);
303 
304     /**
305      * @dev Approve or remove `operator` as an operator for the caller.
306      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
307      *
308      * Requirements:
309      *
310      * - The `operator` cannot be the caller.
311      *
312      * Emits an {ApprovalForAll} event.
313      */
314     function setApprovalForAll(address operator, bool _approved) external;
315 
316     /**
317      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
318      *
319      * See {setApprovalForAll}
320      */
321     function isApprovedForAll(address owner, address operator) external view returns (bool);
322 
323     /**
324      * @dev Safely transfers `tokenId` token from `from` to `to`.
325      *
326      * Requirements:
327      *
328      * - `from` cannot be the zero address.
329      * - `to` cannot be the zero address.
330      * - `tokenId` token must exist and be owned by `from`.
331      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
332      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
333      *
334      * Emits a {Transfer} event.
335      */
336     function safeTransferFrom(
337         address from,
338         address to,
339         uint256 tokenId,
340         bytes calldata data
341     ) external;
342 }
343 
344 
345 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
346 
347 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @title ERC721 token receiver interface
353  * @dev Interface for any contract that wants to support safeTransfers
354  * from ERC721 asset contracts.
355  */
356 interface IERC721Receiver {
357     /**
358      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
359      * by `operator` from `from`, this function is called.
360      *
361      * It must return its Solidity selector to confirm the token transfer.
362      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
363      *
364      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
365      */
366     function onERC721Received(
367         address operator,
368         address from,
369         uint256 tokenId,
370         bytes calldata data
371     ) external returns (bytes4);
372 }
373 
374 
375 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
376 
377 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 /**
382  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
383  * @dev See https://eips.ethereum.org/EIPS/eip-721
384  */
385 interface IERC721Metadata is IERC721 {
386     /**
387      * @dev Returns the token collection name.
388      */
389     function name() external view returns (string memory);
390 
391     /**
392      * @dev Returns the token collection symbol.
393      */
394     function symbol() external view returns (string memory);
395 
396     /**
397      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
398      */
399     function tokenURI(uint256 tokenId) external view returns (string memory);
400 }
401 
402 
403 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
404 
405 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
411  * @dev See https://eips.ethereum.org/EIPS/eip-721
412  */
413 interface IERC721Enumerable is IERC721 {
414     /**
415      * @dev Returns the total amount of tokens stored by the contract.
416      */
417     function totalSupply() external view returns (uint256);
418 
419     /**
420      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
421      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
422      */
423     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
424 
425     /**
426      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
427      * Use along with {totalSupply} to enumerate all tokens.
428      */
429     function tokenByIndex(uint256 index) external view returns (uint256);
430 }
431 
432 
433 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
434 
435 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev Collection of functions related to the address type
441  */
442 library Address {
443     /**
444      * @dev Returns true if `account` is a contract.
445      *
446      * [IMPORTANT]
447      * ====
448      * It is unsafe to assume that an address for which this function returns
449      * false is an externally-owned account (EOA) and not a contract.
450      *
451      * Among others, `isContract` will return false for the following
452      * types of addresses:
453      *
454      *  - an externally-owned account
455      *  - a contract in construction
456      *  - an address where a contract will be created
457      *  - an address where a contract lived, but was destroyed
458      * ====
459      *
460      * [IMPORTANT]
461      * ====
462      * You shouldn't rely on `isContract` to protect against flash loan attacks!
463      *
464      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
465      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
466      * constructor.
467      * ====
468      */
469     function isContract(address account) internal view returns (bool) {
470         // This method relies on extcodesize/address.code.length, which returns 0
471         // for contracts in construction, since the code is only stored at the end
472         // of the constructor execution.
473 
474         return account.code.length > 0;
475     }
476 
477     /**
478      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
479      * `recipient`, forwarding all available gas and reverting on errors.
480      *
481      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
482      * of certain opcodes, possibly making contracts go over the 2300 gas limit
483      * imposed by `transfer`, making them unable to receive funds via
484      * `transfer`. {sendValue} removes this limitation.
485      *
486      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
487      *
488      * IMPORTANT: because control is transferred to `recipient`, care must be
489      * taken to not create reentrancy vulnerabilities. Consider using
490      * {ReentrancyGuard} or the
491      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
492      */
493     function sendValue(address payable recipient, uint256 amount) internal {
494         require(address(this).balance >= amount, "Address: insufficient balance");
495 
496         (bool success, ) = recipient.call{value: amount}("");
497         require(success, "Address: unable to send value, recipient may have reverted");
498     }
499 
500     /**
501      * @dev Performs a Solidity function call using a low level `call`. A
502      * plain `call` is an unsafe replacement for a function call: use this
503      * function instead.
504      *
505      * If `target` reverts with a revert reason, it is bubbled up by this
506      * function (like regular Solidity function calls).
507      *
508      * Returns the raw returned data. To convert to the expected return value,
509      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
510      *
511      * Requirements:
512      *
513      * - `target` must be a contract.
514      * - calling `target` with `data` must not revert.
515      *
516      * _Available since v3.1._
517      */
518     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
519         return functionCall(target, data, "Address: low-level call failed");
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
524      * `errorMessage` as a fallback revert reason when `target` reverts.
525      *
526      * _Available since v3.1._
527      */
528     function functionCall(
529         address target,
530         bytes memory data,
531         string memory errorMessage
532     ) internal returns (bytes memory) {
533         return functionCallWithValue(target, data, 0, errorMessage);
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
538      * but also transferring `value` wei to `target`.
539      *
540      * Requirements:
541      *
542      * - the calling contract must have an ETH balance of at least `value`.
543      * - the called Solidity function must be `payable`.
544      *
545      * _Available since v3.1._
546      */
547     function functionCallWithValue(
548         address target,
549         bytes memory data,
550         uint256 value
551     ) internal returns (bytes memory) {
552         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
557      * with `errorMessage` as a fallback revert reason when `target` reverts.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(
562         address target,
563         bytes memory data,
564         uint256 value,
565         string memory errorMessage
566     ) internal returns (bytes memory) {
567         require(address(this).balance >= value, "Address: insufficient balance for call");
568         require(isContract(target), "Address: call to non-contract");
569 
570         (bool success, bytes memory returndata) = target.call{value: value}(data);
571         return verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
576      * but performing a static call.
577      *
578      * _Available since v3.3._
579      */
580     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
581         return functionStaticCall(target, data, "Address: low-level static call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
586      * but performing a static call.
587      *
588      * _Available since v3.3._
589      */
590     function functionStaticCall(
591         address target,
592         bytes memory data,
593         string memory errorMessage
594     ) internal view returns (bytes memory) {
595         require(isContract(target), "Address: static call to non-contract");
596 
597         (bool success, bytes memory returndata) = target.staticcall(data);
598         return verifyCallResult(success, returndata, errorMessage);
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
603      * but performing a delegate call.
604      *
605      * _Available since v3.4._
606      */
607     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
608         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
613      * but performing a delegate call.
614      *
615      * _Available since v3.4._
616      */
617     function functionDelegateCall(
618         address target,
619         bytes memory data,
620         string memory errorMessage
621     ) internal returns (bytes memory) {
622         require(isContract(target), "Address: delegate call to non-contract");
623 
624         (bool success, bytes memory returndata) = target.delegatecall(data);
625         return verifyCallResult(success, returndata, errorMessage);
626     }
627 
628     /**
629      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
630      * revert reason using the provided one.
631      *
632      * _Available since v4.3._
633      */
634     function verifyCallResult(
635         bool success,
636         bytes memory returndata,
637         string memory errorMessage
638     ) internal pure returns (bytes memory) {
639         if (success) {
640             return returndata;
641         } else {
642             // Look for revert reason and bubble it up if present
643             if (returndata.length > 0) {
644                 // The easiest way to bubble the revert reason is using memory via assembly
645 
646                 assembly {
647                     let returndata_size := mload(returndata)
648                     revert(add(32, returndata), returndata_size)
649                 }
650             } else {
651                 revert(errorMessage);
652             }
653         }
654     }
655 }
656 
657 
658 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
659 
660 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
661 
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @dev String operations.
666  */
667 library Strings {
668     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
669 
670     /**
671      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
672      */
673     function toString(uint256 value) internal pure returns (string memory) {
674         // Inspired by OraclizeAPI's implementation - MIT licence
675         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
676 
677         if (value == 0) {
678             return "0";
679         }
680         uint256 temp = value;
681         uint256 digits;
682         while (temp != 0) {
683             digits++;
684             temp /= 10;
685         }
686         bytes memory buffer = new bytes(digits);
687         while (value != 0) {
688             digits -= 1;
689             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
690             value /= 10;
691         }
692         return string(buffer);
693     }
694 
695     /**
696      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
697      */
698     function toHexString(uint256 value) internal pure returns (string memory) {
699         if (value == 0) {
700             return "0x00";
701         }
702         uint256 temp = value;
703         uint256 length = 0;
704         while (temp != 0) {
705             length++;
706             temp >>= 8;
707         }
708         return toHexString(value, length);
709     }
710 
711     /**
712      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
713      */
714     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
715         bytes memory buffer = new bytes(2 * length + 2);
716         buffer[0] = "0";
717         buffer[1] = "x";
718         for (uint256 i = 2 * length + 1; i > 1; --i) {
719             buffer[i] = _HEX_SYMBOLS[value & 0xf];
720             value >>= 4;
721         }
722         require(value == 0, "Strings: hex length insufficient");
723         return string(buffer);
724     }
725 }
726 
727 
728 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
729 
730 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 /**
735  * @dev Implementation of the {IERC165} interface.
736  *
737  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
738  * for the additional interface id that will be supported. For example:
739  *
740  * ```solidity
741  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
742  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
743  * }
744  * ```
745  *
746  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
747  */
748 abstract contract ERC165 is IERC165 {
749     /**
750      * @dev See {IERC165-supportsInterface}.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
753         return interfaceId == type(IERC165).interfaceId;
754     }
755 }
756 
757 
758 // File contracts/ERC721A.sol
759 
760 
761 pragma solidity ^0.8.0;
762 
763 
764 
765 
766 
767 
768 
769 
770 /**
771  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
772  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
773  *
774  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
775  *
776  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
777  *
778  * Does not support burning tokens to address(0).
779  */
780 contract ERC721A is
781   Context,
782   ERC165,
783   IERC721,
784   IERC721Metadata,
785   IERC721Enumerable
786 {
787   using Address for address;
788   using Strings for uint256;
789 
790   struct TokenOwnership {
791     address addr;
792     uint64 startTimestamp;
793   }
794 
795   struct AddressData {
796     uint128 balance;
797     uint128 numberMinted;
798   }
799 
800   uint256 private currentIndex = 0;
801 
802   uint256 internal immutable collectionSize;
803   uint256 internal immutable maxBatchSize;
804 
805   // Token name
806   string private _name;
807 
808   // Token symbol
809   string private _symbol;
810 
811   // Mapping from token ID to ownership details
812   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
813   mapping(uint256 => TokenOwnership) private _ownerships;
814 
815   // Mapping owner address to address data
816   mapping(address => AddressData) private _addressData;
817 
818   // Mapping from token ID to approved address
819   mapping(uint256 => address) private _tokenApprovals;
820 
821   // Mapping from owner to operator approvals
822   mapping(address => mapping(address => bool)) private _operatorApprovals;
823 
824   /**
825    * @dev
826    * `maxBatchSize` refers to how much a minter can mint at a time.
827    * `collectionSize_` refers to how many tokens are in the collection.
828    */
829   constructor(
830     string memory name_,
831     string memory symbol_,
832     uint256 maxBatchSize_,
833     uint256 collectionSize_
834   ) {
835     require(
836       collectionSize_ > 0,
837       "ERC721A: collection must have a nonzero supply"
838     );
839     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
840     _name = name_;
841     _symbol = symbol_;
842     maxBatchSize = maxBatchSize_;
843     collectionSize = collectionSize_;
844   }
845 
846   /**
847    * @dev See {IERC721Enumerable-totalSupply}.
848    */
849   function totalSupply() public view override returns (uint256) {
850     return currentIndex;
851   }
852 
853   /**
854    * @dev See {IERC721Enumerable-tokenByIndex}.
855    */
856   function tokenByIndex(uint256 index) public view override returns (uint256) {
857     require(index < totalSupply(), "ERC721A: global index out of bounds");
858     return index;
859   }
860 
861   /**
862    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
863    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
864    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
865    */
866   function tokenOfOwnerByIndex(address owner, uint256 index)
867     public
868     view
869     override
870     returns (uint256)
871   {
872     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
873     uint256 numMintedSoFar = totalSupply();
874     uint256 tokenIdsIdx = 0;
875     address currOwnershipAddr = address(0);
876     for (uint256 i = 0; i < numMintedSoFar; i++) {
877       TokenOwnership memory ownership = _ownerships[i];
878       if (ownership.addr != address(0)) {
879         currOwnershipAddr = ownership.addr;
880       }
881       if (currOwnershipAddr == owner) {
882         if (tokenIdsIdx == index) {
883           return i;
884         }
885         tokenIdsIdx++;
886       }
887     }
888     revert("ERC721A: unable to get token of owner by index");
889   }
890 
891   /**
892    * @dev See {IERC165-supportsInterface}.
893    */
894   function supportsInterface(bytes4 interfaceId)
895     public
896     view
897     virtual
898     override(ERC165, IERC165)
899     returns (bool)
900   {
901     return
902       interfaceId == type(IERC721).interfaceId ||
903       interfaceId == type(IERC721Metadata).interfaceId ||
904       interfaceId == type(IERC721Enumerable).interfaceId ||
905       super.supportsInterface(interfaceId);
906   }
907 
908   /**
909    * @dev See {IERC721-balanceOf}.
910    */
911   function balanceOf(address owner) public view override returns (uint256) {
912     require(owner != address(0), "ERC721A: balance query for the zero address");
913     return uint256(_addressData[owner].balance);
914   }
915 
916   function _numberMinted(address owner) internal view returns (uint256) {
917     require(
918       owner != address(0),
919       "ERC721A: number minted query for the zero address"
920     );
921     return uint256(_addressData[owner].numberMinted);
922   }
923 
924   function ownershipOf(uint256 tokenId)
925     internal
926     view
927     returns (TokenOwnership memory)
928   {
929     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
930 
931     uint256 lowestTokenToCheck;
932     if (tokenId >= maxBatchSize) {
933       lowestTokenToCheck = tokenId - maxBatchSize + 1;
934     }
935 
936     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
937       TokenOwnership memory ownership = _ownerships[curr];
938       if (ownership.addr != address(0)) {
939         return ownership;
940       }
941     }
942 
943     revert("ERC721A: unable to determine the owner of token");
944   }
945 
946   /**
947    * @dev See {IERC721-ownerOf}.
948    */
949   function ownerOf(uint256 tokenId) public view override returns (address) {
950     return ownershipOf(tokenId).addr;
951   }
952 
953   /**
954    * @dev See {IERC721Metadata-name}.
955    */
956   function name() public view virtual override returns (string memory) {
957     return _name;
958   }
959 
960   /**
961    * @dev See {IERC721Metadata-symbol}.
962    */
963   function symbol() public view virtual override returns (string memory) {
964     return _symbol;
965   }
966 
967   /**
968    * @dev See {IERC721Metadata-tokenURI}.
969    */
970   function tokenURI(uint256 tokenId)
971     public
972     view
973     virtual
974     override
975     returns (string memory)
976   {
977     require(
978       _exists(tokenId),
979       "ERC721Metadata: URI query for nonexistent token"
980     );
981 
982     string memory baseURI = _baseURI();
983     return
984       bytes(baseURI).length > 0
985         ? string(abi.encodePacked(baseURI, tokenId.toString()))
986         : "";
987   }
988 
989   /**
990    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
991    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
992    * by default, can be overriden in child contracts.
993    */
994   function _baseURI() internal view virtual returns (string memory) {
995     return "";
996   }
997 
998   /**
999    * @dev See {IERC721-approve}.
1000    */
1001   function approve(address to, uint256 tokenId) public override {
1002     address owner = ERC721A.ownerOf(tokenId);
1003     require(to != owner, "ERC721A: approval to current owner");
1004 
1005     require(
1006       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1007       "ERC721A: approve caller is not owner nor approved for all"
1008     );
1009 
1010     _approve(to, tokenId, owner);
1011   }
1012 
1013   /**
1014    * @dev See {IERC721-getApproved}.
1015    */
1016   function getApproved(uint256 tokenId) public view override returns (address) {
1017     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1018 
1019     return _tokenApprovals[tokenId];
1020   }
1021 
1022   /**
1023    * @dev See {IERC721-setApprovalForAll}.
1024    */
1025   function setApprovalForAll(address operator, bool approved) public override {
1026     require(operator != _msgSender(), "ERC721A: approve to caller");
1027 
1028     _operatorApprovals[_msgSender()][operator] = approved;
1029     emit ApprovalForAll(_msgSender(), operator, approved);
1030   }
1031 
1032   /**
1033    * @dev See {IERC721-isApprovedForAll}.
1034    */
1035   function isApprovedForAll(address owner, address operator)
1036     public
1037     view
1038     virtual
1039     override
1040     returns (bool)
1041   {
1042     return _operatorApprovals[owner][operator];
1043   }
1044 
1045   /**
1046    * @dev See {IERC721-transferFrom}.
1047    */
1048   function transferFrom(
1049     address from,
1050     address to,
1051     uint256 tokenId
1052   ) public override {
1053     _transfer(from, to, tokenId);
1054   }
1055 
1056   /**
1057    * @dev See {IERC721-safeTransferFrom}.
1058    */
1059   function safeTransferFrom(
1060     address from,
1061     address to,
1062     uint256 tokenId
1063   ) public override {
1064     safeTransferFrom(from, to, tokenId, "");
1065   }
1066 
1067   /**
1068    * @dev See {IERC721-safeTransferFrom}.
1069    */
1070   function safeTransferFrom(
1071     address from,
1072     address to,
1073     uint256 tokenId,
1074     bytes memory _data
1075   ) public override {
1076     _transfer(from, to, tokenId);
1077     require(
1078       _checkOnERC721Received(from, to, tokenId, _data),
1079       "ERC721A: transfer to non ERC721Receiver implementer"
1080     );
1081   }
1082 
1083   /**
1084    * @dev Returns whether `tokenId` exists.
1085    *
1086    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1087    *
1088    * Tokens start existing when they are minted (`_mint`),
1089    */
1090   function _exists(uint256 tokenId) internal view returns (bool) {
1091     return tokenId < currentIndex;
1092   }
1093 
1094   function _safeMint(address to, uint256 quantity) internal {
1095     _safeMint(to, quantity, "");
1096   }
1097 
1098   /**
1099    * @dev Mints `quantity` tokens and transfers them to `to`.
1100    *
1101    * Requirements:
1102    *
1103    * - there must be `quantity` tokens remaining unminted in the total collection.
1104    * - `to` cannot be the zero address.
1105    * - `quantity` cannot be larger than the max batch size.
1106    *
1107    * Emits a {Transfer} event.
1108    */
1109   function _safeMint(
1110     address to,
1111     uint256 quantity,
1112     bytes memory _data
1113   ) internal {
1114     uint256 startTokenId = currentIndex;
1115     require(to != address(0), "ERC721A: mint to the zero address");
1116     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1117     require(!_exists(startTokenId), "ERC721A: token already minted");
1118     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1119 
1120     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1121 
1122     AddressData memory addressData = _addressData[to];
1123     _addressData[to] = AddressData(
1124       addressData.balance + uint128(quantity),
1125       addressData.numberMinted + uint128(quantity)
1126     );
1127     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1128 
1129     uint256 updatedIndex = startTokenId;
1130 
1131     for (uint256 i = 0; i < quantity; i++) {
1132       emit Transfer(address(0), to, updatedIndex);
1133       require(
1134         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1135         "ERC721A: transfer to non ERC721Receiver implementer"
1136       );
1137       updatedIndex++;
1138     }
1139 
1140     currentIndex = updatedIndex;
1141     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1142   }
1143 
1144   /**
1145    * @dev Transfers `tokenId` from `from` to `to`.
1146    *
1147    * Requirements:
1148    *
1149    * - `to` cannot be the zero address.
1150    * - `tokenId` token must be owned by `from`.
1151    *
1152    * Emits a {Transfer} event.
1153    */
1154   function _transfer(
1155     address from,
1156     address to,
1157     uint256 tokenId
1158   ) private {
1159     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1160 
1161     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1162       getApproved(tokenId) == _msgSender() ||
1163       isApprovedForAll(prevOwnership.addr, _msgSender()));
1164 
1165     require(
1166       isApprovedOrOwner,
1167       "ERC721A: transfer caller is not owner nor approved"
1168     );
1169 
1170     require(
1171       prevOwnership.addr == from,
1172       "ERC721A: transfer from incorrect owner"
1173     );
1174     require(to != address(0), "ERC721A: transfer to the zero address");
1175 
1176     _beforeTokenTransfers(from, to, tokenId, 1);
1177 
1178     // Clear approvals from the previous owner
1179     _approve(address(0), tokenId, prevOwnership.addr);
1180 
1181     _addressData[from].balance -= 1;
1182     _addressData[to].balance += 1;
1183     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1184 
1185     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1186     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1187     uint256 nextTokenId = tokenId + 1;
1188     if (_ownerships[nextTokenId].addr == address(0)) {
1189       if (_exists(nextTokenId)) {
1190         _ownerships[nextTokenId] = TokenOwnership(
1191           prevOwnership.addr,
1192           prevOwnership.startTimestamp
1193         );
1194       }
1195     }
1196 
1197     emit Transfer(from, to, tokenId);
1198     _afterTokenTransfers(from, to, tokenId, 1);
1199   }
1200 
1201   /**
1202    * @dev Approve `to` to operate on `tokenId`
1203    *
1204    * Emits a {Approval} event.
1205    */
1206   function _approve(
1207     address to,
1208     uint256 tokenId,
1209     address owner
1210   ) private {
1211     _tokenApprovals[tokenId] = to;
1212     emit Approval(owner, to, tokenId);
1213   }
1214 
1215   uint256 public nextOwnerToExplicitlySet = 0;
1216 
1217   /**
1218    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1219    */
1220   function _setOwnersExplicit(uint256 quantity) internal {
1221     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1222     require(quantity > 0, "quantity must be nonzero");
1223     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1224     if (endIndex > collectionSize - 1) {
1225       endIndex = collectionSize - 1;
1226     }
1227     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1228     require(_exists(endIndex), "not enough minted yet for this cleanup");
1229     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1230       if (_ownerships[i].addr == address(0)) {
1231         TokenOwnership memory ownership = ownershipOf(i);
1232         _ownerships[i] = TokenOwnership(
1233           ownership.addr,
1234           ownership.startTimestamp
1235         );
1236       }
1237     }
1238     nextOwnerToExplicitlySet = endIndex + 1;
1239   }
1240 
1241   /**
1242    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1243    * The call is not executed if the target address is not a contract.
1244    *
1245    * @param from address representing the previous owner of the given token ID
1246    * @param to target address that will receive the tokens
1247    * @param tokenId uint256 ID of the token to be transferred
1248    * @param _data bytes optional data to send along with the call
1249    * @return bool whether the call correctly returned the expected magic value
1250    */
1251   function _checkOnERC721Received(
1252     address from,
1253     address to,
1254     uint256 tokenId,
1255     bytes memory _data
1256   ) private returns (bool) {
1257     if (to.isContract()) {
1258       try
1259         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1260       returns (bytes4 retval) {
1261         return retval == IERC721Receiver(to).onERC721Received.selector;
1262       } catch (bytes memory reason) {
1263         if (reason.length == 0) {
1264           revert("ERC721A: transfer to non ERC721Receiver implementer");
1265         } else {
1266           assembly {
1267             revert(add(32, reason), mload(reason))
1268           }
1269         }
1270       }
1271     } else {
1272       return true;
1273     }
1274   }
1275 
1276   /**
1277    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1278    *
1279    * startTokenId - the first token id to be transferred
1280    * quantity - the amount to be transferred
1281    *
1282    * Calling conditions:
1283    *
1284    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1285    * transferred to `to`.
1286    * - When `from` is zero, `tokenId` will be minted for `to`.
1287    */
1288   function _beforeTokenTransfers(
1289     address from,
1290     address to,
1291     uint256 startTokenId,
1292     uint256 quantity
1293   ) internal virtual {}
1294 
1295   /**
1296    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1297    * minting.
1298    *
1299    * startTokenId - the first token id to be transferred
1300    * quantity - the amount to be transferred
1301    *
1302    * Calling conditions:
1303    *
1304    * - when `from` and `to` are both non-zero.
1305    * - `from` and `to` are never both zero.
1306    */
1307   function _afterTokenTransfers(
1308     address from,
1309     address to,
1310     uint256 startTokenId,
1311     uint256 quantity
1312   ) internal virtual {}
1313 }
1314 
1315 
1316 // File contracts/DoodMfers.sol
1317 
1318 
1319 pragma solidity ^0.8.0;
1320 
1321 
1322 
1323 
1324 contract DoodMfers is Ownable, ERC721A, ReentrancyGuard {
1325   uint256 public immutable maxPerAddressDuringMint;
1326   uint256 public constant publicPrice = 0.01 ether;
1327   uint256 public constant publicSaleStartTime = 1647620400;
1328 
1329   mapping(address => uint256) public allowlist;
1330 
1331   constructor(
1332     uint256 maxBatchSize_,
1333     uint256 collectionSize_
1334   ) ERC721A("DoodMfers", "DoodMfers", maxBatchSize_, collectionSize_) {
1335     maxPerAddressDuringMint = maxBatchSize_;
1336   }
1337 
1338   modifier callerIsUser() {
1339     require(tx.origin == msg.sender, "The caller is another contract");
1340     _;
1341   }
1342 
1343   function allowlistMint() external payable callerIsUser {
1344     require(allowlist[msg.sender] > 0, "not eligible for allowlist mint");
1345     require(totalSupply() + 1 <= collectionSize, "reached max supply");
1346     _safeMint(msg.sender, allowlist[msg.sender]);
1347     allowlist[msg.sender] = 0;
1348   }
1349 
1350   function publicSaleMint(uint256 quantity)
1351     external
1352     payable
1353     callerIsUser
1354   {
1355     require(
1356       isPublicSaleOn(publicSaleStartTime),
1357       "public sale has not begun yet"
1358     );
1359     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1360     require(
1361       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1362       "can not mint this many"
1363     );
1364     _safeMint(msg.sender, quantity);
1365     refundIfOver(publicPrice * quantity);
1366   }
1367 
1368   function refundIfOver(uint256 price) private {
1369     require(msg.value >= price, "Need to send more ETH.");
1370     if (msg.value > price) {
1371       payable(msg.sender).transfer(msg.value - price);
1372     }
1373   }
1374 
1375   function isPublicSaleOn(
1376     uint256 publicSaleStartTime_
1377   ) public view returns (bool) {
1378     return block.timestamp >= publicSaleStartTime_;
1379   }
1380 
1381   function seedAllowlist(address[] memory addresses, uint256[] memory numSlots)
1382     external
1383     onlyOwner
1384   {
1385     require(
1386       addresses.length == numSlots.length,
1387       "addresses does not match numSlots length"
1388     );
1389     for (uint256 i = 0; i < addresses.length; i++) {
1390       allowlist[addresses[i]] = numSlots[i];
1391     }
1392   }
1393 
1394   // // metadata URI
1395   string private _baseTokenURI;
1396 
1397   function _baseURI() internal view virtual override returns (string memory) {
1398     return _baseTokenURI;
1399   }
1400 
1401   function setBaseURI(string calldata baseURI) external onlyOwner {
1402     _baseTokenURI = baseURI;
1403   }
1404 
1405   function withdrawMoney() external onlyOwner nonReentrant {
1406     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1407     require(success, "Transfer failed.");
1408   }
1409 
1410   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1411     _setOwnersExplicit(quantity);
1412   }
1413 
1414   function numberMinted(address owner) public view returns (uint256) {
1415     return _numberMinted(owner);
1416   }
1417 
1418   function getOwnershipData(uint256 tokenId)
1419     external
1420     view
1421     returns (TokenOwnership memory)
1422   {
1423     return ownershipOf(tokenId);
1424   }
1425 }