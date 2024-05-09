1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin\contracts\access\Ownable.sol
27 
28 
29 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         _transferOwnership(address(0));
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         _transferOwnership(newOwner);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Internal function without access restriction.
95      */
96     function _transferOwnership(address newOwner) internal virtual {
97         address oldOwner = _owner;
98         _owner = newOwner;
99         emit OwnershipTransferred(oldOwner, newOwner);
100     }
101 }
102 
103 // File: @openzeppelin\contracts\security\ReentrancyGuard.sol
104 
105 
106 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev Contract module that helps prevent reentrant calls to a function.
112  *
113  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
114  * available, which can be applied to functions to make sure there are no nested
115  * (reentrant) calls to them.
116  *
117  * Note that because there is a single `nonReentrant` guard, functions marked as
118  * `nonReentrant` may not call one another. This can be worked around by making
119  * those functions `private`, and then adding `external` `nonReentrant` entry
120  * points to them.
121  *
122  * TIP: If you would like to learn more about reentrancy and alternative ways
123  * to protect against it, check out our blog post
124  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
125  */
126 abstract contract ReentrancyGuard {
127     // Booleans are more expensive than uint256 or any type that takes up a full
128     // word because each write operation emits an extra SLOAD to first read the
129     // slot's contents, replace the bits taken up by the boolean, and then write
130     // back. This is the compiler's defense against contract upgrades and
131     // pointer aliasing, and it cannot be disabled.
132 
133     // The values being non-zero value makes deployment a bit more expensive,
134     // but in exchange the refund on every call to nonReentrant will be lower in
135     // amount. Since refunds are capped to a percentage of the total
136     // transaction's gas, it is best to keep them low in cases like this one, to
137     // increase the likelihood of the full refund coming into effect.
138     uint256 private constant _NOT_ENTERED = 1;
139     uint256 private constant _ENTERED = 2;
140 
141     uint256 private _status;
142 
143     constructor() {
144         _status = _NOT_ENTERED;
145     }
146 
147     /**
148      * @dev Prevents a contract from calling itself, directly or indirectly.
149      * Calling a `nonReentrant` function from another `nonReentrant`
150      * function is not supported. It is possible to prevent this from happening
151      * by making the `nonReentrant` function external, and making it call a
152      * `private` function that does the actual work.
153      */
154     modifier nonReentrant() {
155         // On the first call to nonReentrant, _notEntered will be true
156         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
157 
158         // Any calls to nonReentrant after this point will fail
159         _status = _ENTERED;
160 
161         _;
162 
163         // By storing the original value once again, a refund is triggered (see
164         // https://eips.ethereum.org/EIPS/eip-2200)
165         _status = _NOT_ENTERED;
166     }
167 }
168 
169 // File: ..\..\..\..\node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol
170 
171 
172 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @dev Interface of the ERC165 standard, as defined in the
178  * https://eips.ethereum.org/EIPS/eip-165[EIP].
179  *
180  * Implementers can declare support of contract interfaces, which can then be
181  * queried by others ({ERC165Checker}).
182  *
183  * For an implementation, see {ERC165}.
184  */
185 interface IERC165 {
186     /**
187      * @dev Returns true if this contract implements the interface defined by
188      * `interfaceId`. See the corresponding
189      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
190      * to learn more about how these ids are created.
191      *
192      * This function call must use less than 30 000 gas.
193      */
194     function supportsInterface(bytes4 interfaceId) external view returns (bool);
195 }
196 
197 // File: @openzeppelin\contracts\token\ERC721\IERC721.sol
198 
199 
200 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
201 
202 pragma solidity ^0.8.0;
203 
204 /**
205  * @dev Required interface of an ERC721 compliant contract.
206  */
207 interface IERC721 is IERC165 {
208     /**
209      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
210      */
211     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
212 
213     /**
214      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
215      */
216     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
217 
218     /**
219      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
220      */
221     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
222 
223     /**
224      * @dev Returns the number of tokens in ``owner``'s account.
225      */
226     function balanceOf(address owner) external view returns (uint256 balance);
227 
228     /**
229      * @dev Returns the owner of the `tokenId` token.
230      *
231      * Requirements:
232      *
233      * - `tokenId` must exist.
234      */
235     function ownerOf(uint256 tokenId) external view returns (address owner);
236 
237     /**
238      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
239      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
240      *
241      * Requirements:
242      *
243      * - `from` cannot be the zero address.
244      * - `to` cannot be the zero address.
245      * - `tokenId` token must exist and be owned by `from`.
246      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
247      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
248      *
249      * Emits a {Transfer} event.
250      */
251     function safeTransferFrom(
252         address from,
253         address to,
254         uint256 tokenId
255     ) external;
256 
257     /**
258      * @dev Transfers `tokenId` token from `from` to `to`.
259      *
260      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
261      *
262      * Requirements:
263      *
264      * - `from` cannot be the zero address.
265      * - `to` cannot be the zero address.
266      * - `tokenId` token must be owned by `from`.
267      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
268      *
269      * Emits a {Transfer} event.
270      */
271     function transferFrom(
272         address from,
273         address to,
274         uint256 tokenId
275     ) external;
276 
277     /**
278      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
279      * The approval is cleared when the token is transferred.
280      *
281      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
282      *
283      * Requirements:
284      *
285      * - The caller must own the token or be an approved operator.
286      * - `tokenId` must exist.
287      *
288      * Emits an {Approval} event.
289      */
290     function approve(address to, uint256 tokenId) external;
291 
292     /**
293      * @dev Returns the account approved for `tokenId` token.
294      *
295      * Requirements:
296      *
297      * - `tokenId` must exist.
298      */
299     function getApproved(uint256 tokenId) external view returns (address operator);
300 
301     /**
302      * @dev Approve or remove `operator` as an operator for the caller.
303      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
304      *
305      * Requirements:
306      *
307      * - The `operator` cannot be the caller.
308      *
309      * Emits an {ApprovalForAll} event.
310      */
311     function setApprovalForAll(address operator, bool _approved) external;
312 
313     /**
314      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
315      *
316      * See {setApprovalForAll}
317      */
318     function isApprovedForAll(address owner, address operator) external view returns (bool);
319 
320     /**
321      * @dev Safely transfers `tokenId` token from `from` to `to`.
322      *
323      * Requirements:
324      *
325      * - `from` cannot be the zero address.
326      * - `to` cannot be the zero address.
327      * - `tokenId` token must exist and be owned by `from`.
328      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
329      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
330      *
331      * Emits a {Transfer} event.
332      */
333     function safeTransferFrom(
334         address from,
335         address to,
336         uint256 tokenId,
337         bytes calldata data
338     ) external;
339 }
340 
341 // File: @openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
342 
343 
344 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
345 
346 pragma solidity ^0.8.0;
347 
348 /**
349  * @title ERC721 token receiver interface
350  * @dev Interface for any contract that wants to support safeTransfers
351  * from ERC721 asset contracts.
352  */
353 interface IERC721Receiver {
354     /**
355      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
356      * by `operator` from `from`, this function is called.
357      *
358      * It must return its Solidity selector to confirm the token transfer.
359      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
360      *
361      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
362      */
363     function onERC721Received(
364         address operator,
365         address from,
366         uint256 tokenId,
367         bytes calldata data
368     ) external returns (bytes4);
369 }
370 
371 
372 
373 // File: @openzeppelin\contracts\token\ERC721\extensions\IERC721Metadata.sol
374 
375 
376 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 /**
381  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
382  * @dev See https://eips.ethereum.org/EIPS/eip-721
383  */
384 interface IERC721Metadata is IERC721 {
385     /**
386      * @dev Returns the token collection name.
387      */
388     function name() external view returns (string memory);
389 
390     /**
391      * @dev Returns the token collection symbol.
392      */
393     function symbol() external view returns (string memory);
394 
395     /**
396      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
397      */
398     function tokenURI(uint256 tokenId) external view returns (string memory);
399 }
400 
401 // File: @openzeppelin\contracts\token\ERC721\extensions\IERC721Enumerable.sol
402 
403 
404 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
410  * @dev See https://eips.ethereum.org/EIPS/eip-721
411  */
412 interface IERC721Enumerable is IERC721 {
413     /**
414      * @dev Returns the total amount of tokens stored by the contract.
415      */
416     function totalSupply() external view returns (uint256);
417 
418     /**
419      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
420      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
421      */
422     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
423 
424     /**
425      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
426      * Use along with {totalSupply} to enumerate all tokens.
427      */
428     function tokenByIndex(uint256 index) external view returns (uint256);
429 }
430 
431 // File: @openzeppelin\contracts\utils\Address.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @dev Collection of functions related to the address type
440  */
441 library Address {
442     /**
443      * @dev Returns true if `account` is a contract.
444      *
445      * [IMPORTANT]
446      * ====
447      * It is unsafe to assume that an address for which this function returns
448      * false is an externally-owned account (EOA) and not a contract.
449      *
450      * Among others, `isContract` will return false for the following
451      * types of addresses:
452      *
453      *  - an externally-owned account
454      *  - a contract in construction
455      *  - an address where a contract will be created
456      *  - an address where a contract lived, but was destroyed
457      * ====
458      */
459     function isContract(address account) internal view returns (bool) {
460         // This method relies on extcodesize, which returns 0 for contracts in
461         // construction, since the code is only stored at the end of the
462         // constructor execution.
463 
464         uint256 size;
465         assembly {
466             size := extcodesize(account)
467         }
468         return size > 0;
469     }
470 
471     /**
472      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
473      * `recipient`, forwarding all available gas and reverting on errors.
474      *
475      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
476      * of certain opcodes, possibly making contracts go over the 2300 gas limit
477      * imposed by `transfer`, making them unable to receive funds via
478      * `transfer`. {sendValue} removes this limitation.
479      *
480      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
481      *
482      * IMPORTANT: because control is transferred to `recipient`, care must be
483      * taken to not create reentrancy vulnerabilities. Consider using
484      * {ReentrancyGuard} or the
485      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
486      */
487     function sendValue(address payable recipient, uint256 amount) internal {
488         require(address(this).balance >= amount, "Address: insufficient balance");
489 
490         (bool success, ) = recipient.call{value: amount}("");
491         require(success, "Address: unable to send value, recipient may have reverted");
492     }
493 
494     /**
495      * @dev Performs a Solidity function call using a low level `call`. A
496      * plain `call` is an unsafe replacement for a function call: use this
497      * function instead.
498      *
499      * If `target` reverts with a revert reason, it is bubbled up by this
500      * function (like regular Solidity function calls).
501      *
502      * Returns the raw returned data. To convert to the expected return value,
503      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
504      *
505      * Requirements:
506      *
507      * - `target` must be a contract.
508      * - calling `target` with `data` must not revert.
509      *
510      * _Available since v3.1._
511      */
512     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
513         return functionCall(target, data, "Address: low-level call failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
518      * `errorMessage` as a fallback revert reason when `target` reverts.
519      *
520      * _Available since v3.1._
521      */
522     function functionCall(
523         address target,
524         bytes memory data,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         return functionCallWithValue(target, data, 0, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
532      * but also transferring `value` wei to `target`.
533      *
534      * Requirements:
535      *
536      * - the calling contract must have an ETH balance of at least `value`.
537      * - the called Solidity function must be `payable`.
538      *
539      * _Available since v3.1._
540      */
541     function functionCallWithValue(
542         address target,
543         bytes memory data,
544         uint256 value
545     ) internal returns (bytes memory) {
546         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
551      * with `errorMessage` as a fallback revert reason when `target` reverts.
552      *
553      * _Available since v3.1._
554      */
555     function functionCallWithValue(
556         address target,
557         bytes memory data,
558         uint256 value,
559         string memory errorMessage
560     ) internal returns (bytes memory) {
561         require(address(this).balance >= value, "Address: insufficient balance for call");
562         require(isContract(target), "Address: call to non-contract");
563 
564         (bool success, bytes memory returndata) = target.call{value: value}(data);
565         return verifyCallResult(success, returndata, errorMessage);
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
570      * but performing a static call.
571      *
572      * _Available since v3.3._
573      */
574     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
575         return functionStaticCall(target, data, "Address: low-level static call failed");
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
580      * but performing a static call.
581      *
582      * _Available since v3.3._
583      */
584     function functionStaticCall(
585         address target,
586         bytes memory data,
587         string memory errorMessage
588     ) internal view returns (bytes memory) {
589         require(isContract(target), "Address: static call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.staticcall(data);
592         return verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
597      * but performing a delegate call.
598      *
599      * _Available since v3.4._
600      */
601     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
602         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
607      * but performing a delegate call.
608      *
609      * _Available since v3.4._
610      */
611     function functionDelegateCall(
612         address target,
613         bytes memory data,
614         string memory errorMessage
615     ) internal returns (bytes memory) {
616         require(isContract(target), "Address: delegate call to non-contract");
617 
618         (bool success, bytes memory returndata) = target.delegatecall(data);
619         return verifyCallResult(success, returndata, errorMessage);
620     }
621 
622     /**
623      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
624      * revert reason using the provided one.
625      *
626      * _Available since v4.3._
627      */
628     function verifyCallResult(
629         bool success,
630         bytes memory returndata,
631         string memory errorMessage
632     ) internal pure returns (bytes memory) {
633         if (success) {
634             return returndata;
635         } else {
636             // Look for revert reason and bubble it up if present
637             if (returndata.length > 0) {
638                 // The easiest way to bubble the revert reason is using memory via assembly
639 
640                 assembly {
641                     let returndata_size := mload(returndata)
642                     revert(add(32, returndata), returndata_size)
643                 }
644             } else {
645                 revert(errorMessage);
646             }
647         }
648     }
649 }
650 
651 // File: @openzeppelin\contracts\utils\Strings.sol
652 
653 
654 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @dev String operations.
660  */
661 library Strings {
662     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
663 
664     /**
665      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
666      */
667     function toString(uint256 value) internal pure returns (string memory) {
668         // Inspired by OraclizeAPI's implementation - MIT licence
669         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
670 
671         if (value == 0) {
672             return "0";
673         }
674         uint256 temp = value;
675         uint256 digits;
676         while (temp != 0) {
677             digits++;
678             temp /= 10;
679         }
680         bytes memory buffer = new bytes(digits);
681         while (value != 0) {
682             digits -= 1;
683             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
684             value /= 10;
685         }
686         return string(buffer);
687     }
688 
689     /**
690      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
691      */
692     function toHexString(uint256 value) internal pure returns (string memory) {
693         if (value == 0) {
694             return "0x00";
695         }
696         uint256 temp = value;
697         uint256 length = 0;
698         while (temp != 0) {
699             length++;
700             temp >>= 8;
701         }
702         return toHexString(value, length);
703     }
704 
705     /**
706      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
707      */
708     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
709         bytes memory buffer = new bytes(2 * length + 2);
710         buffer[0] = "0";
711         buffer[1] = "x";
712         for (uint256 i = 2 * length + 1; i > 1; --i) {
713             buffer[i] = _HEX_SYMBOLS[value & 0xf];
714             value >>= 4;
715         }
716         require(value == 0, "Strings: hex length insufficient");
717         return string(buffer);
718     }
719 }
720 
721 // File: @openzeppelin\contracts\utils\introspection\ERC165.sol
722 
723 
724 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 /**
729  * @dev Implementation of the {IERC165} interface.
730  *
731  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
732  * for the additional interface id that will be supported. For example:
733  *
734  * ```solidity
735  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
736  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
737  * }
738  * ```
739  *
740  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
741  */
742 abstract contract ERC165 is IERC165 {
743     /**
744      * @dev See {IERC165-supportsInterface}.
745      */
746     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
747         return interfaceId == type(IERC165).interfaceId;
748     }
749 }
750 
751 // File: contracts\ERC721A.sol
752 
753 
754 
755 pragma solidity ^0.8.0;
756 
757 
758 
759 
760 
761 
762 
763 
764 /**
765  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
766  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
767  *
768  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
769  *
770  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
771  *
772  * Does not support burning tokens to address(0).
773  */
774 contract ERC721A is
775   Context,
776   ERC165,
777   IERC721,
778   IERC721Metadata,
779   IERC721Enumerable
780 {
781   using Address for address;
782   using Strings for uint256;
783 
784   struct TokenOwnership {
785     address addr;
786     uint64 startTimestamp;
787   }
788 
789   struct AddressData {
790     uint128 balance;
791     uint128 numberMinted;
792   }
793 
794   uint256 private currentIndex = 0;
795 
796   uint256 internal immutable collectionSize;
797   uint256 internal immutable maxBatchSize;
798 
799   // Token name
800   string private _name;
801 
802   // Token symbol
803   string private _symbol;
804 
805   // Mapping from token ID to ownership details
806   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
807   mapping(uint256 => TokenOwnership) private _ownerships;
808 
809   // Mapping owner address to address data
810   mapping(address => AddressData) private _addressData;
811 
812   // Mapping from token ID to approved address
813   mapping(uint256 => address) private _tokenApprovals;
814 
815   // Mapping from owner to operator approvals
816   mapping(address => mapping(address => bool)) private _operatorApprovals;
817 
818   /**
819    * @dev
820    * `maxBatchSize` refers to how much a minter can mint at a time.
821    * `collectionSize_` refers to how many tokens are in the collection.
822    */
823   constructor(
824     string memory name_,
825     string memory symbol_,
826     uint256 maxBatchSize_,
827     uint256 collectionSize_
828   ) {
829     require(
830       collectionSize_ > 0,
831       "ERC721A: collection must have a nonzero supply"
832     );
833     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
834     _name = name_;
835     _symbol = symbol_;
836     maxBatchSize = maxBatchSize_;
837     collectionSize = collectionSize_;
838   }
839 
840   /**
841    * @dev See {IERC721Enumerable-totalSupply}.
842    */
843   function totalSupply() public view override returns (uint256) {
844     return currentIndex;
845   }
846 
847   /**
848    * @dev See {IERC721Enumerable-tokenByIndex}.
849    */
850   function tokenByIndex(uint256 index) public view override returns (uint256) {
851     require(index < totalSupply(), "ERC721A: global index out of bounds");
852     return index;
853   }
854 
855   /**
856    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
857    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
858    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
859    */
860   function tokenOfOwnerByIndex(address owner, uint256 index)
861     public
862     view
863     override
864     returns (uint256)
865   {
866     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
867     uint256 numMintedSoFar = totalSupply();
868     uint256 tokenIdsIdx = 0;
869     address currOwnershipAddr = address(0);
870     for (uint256 i = 0; i < numMintedSoFar; i++) {
871       TokenOwnership memory ownership = _ownerships[i];
872       if (ownership.addr != address(0)) {
873         currOwnershipAddr = ownership.addr;
874       }
875       if (currOwnershipAddr == owner) {
876         if (tokenIdsIdx == index) {
877           return i;
878         }
879         tokenIdsIdx++;
880       }
881     }
882     revert("ERC721A: unable to get token of owner by index");
883   }
884 
885   /**
886    * @dev See {IERC165-supportsInterface}.
887    */
888   function supportsInterface(bytes4 interfaceId)
889     public
890     view
891     virtual
892     override(ERC165, IERC165)
893     returns (bool)
894   {
895     return
896       interfaceId == type(IERC721).interfaceId ||
897       interfaceId == type(IERC721Metadata).interfaceId ||
898       interfaceId == type(IERC721Enumerable).interfaceId ||
899       super.supportsInterface(interfaceId);
900   }
901 
902   /**
903    * @dev See {IERC721-balanceOf}.
904    */
905   function balanceOf(address owner) public view override returns (uint256) {
906     require(owner != address(0), "ERC721A: balance query for the zero address");
907     return uint256(_addressData[owner].balance);
908   }
909 
910   function _numberMinted(address owner) internal view returns (uint256) {
911     require(
912       owner != address(0),
913       "ERC721A: number minted query for the zero address"
914     );
915     return uint256(_addressData[owner].numberMinted);
916   }
917 
918   function ownershipOf(uint256 tokenId)
919     internal
920     view
921     returns (TokenOwnership memory)
922   {
923     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
924 
925     uint256 lowestTokenToCheck;
926     if (tokenId >= maxBatchSize) {
927       lowestTokenToCheck = tokenId - maxBatchSize + 1;
928     }
929 
930     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
931       TokenOwnership memory ownership = _ownerships[curr];
932       if (ownership.addr != address(0)) {
933         return ownership;
934       }
935     }
936 
937     revert("ERC721A: unable to determine the owner of token");
938   }
939 
940   /**
941    * @dev See {IERC721-ownerOf}.
942    */
943   function ownerOf(uint256 tokenId) public view override returns (address) {
944     return ownershipOf(tokenId).addr;
945   }
946 
947   /**
948    * @dev See {IERC721Metadata-name}.
949    */
950   function name() public view virtual override returns (string memory) {
951     return _name;
952   }
953 
954   /**
955    * @dev See {IERC721Metadata-symbol}.
956    */
957   function symbol() public view virtual override returns (string memory) {
958     return _symbol;
959   }
960 
961   /**
962    * @dev See {IERC721Metadata-tokenURI}.
963    */
964   function tokenURI(uint256 tokenId)
965     public
966     view
967     virtual
968     override
969     returns (string memory)
970   {
971     require(
972       _exists(tokenId),
973       "ERC721Metadata: URI query for nonexistent token"
974     );
975 
976     string memory baseURI = _baseURI();
977     return
978       bytes(baseURI).length > 0
979         ? string(abi.encodePacked(baseURI, "/",tokenId.toString()))
980         : "";
981   }
982 
983   /**
984    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
985    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
986    * by default, can be overriden in child contracts.
987    */
988   function _baseURI() internal view virtual returns (string memory) {
989     return "";
990   }
991 
992   /**
993    * @dev See {IERC721-approve}.
994    */
995   function approve(address to, uint256 tokenId) public override {
996     address owner = ERC721A.ownerOf(tokenId);
997     require(to != owner, "ERC721A: approval to current owner");
998 
999     require(
1000       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1001       "ERC721A: approve caller is not owner nor approved for all"
1002     );
1003 
1004     _approve(to, tokenId, owner);
1005   }
1006 
1007   /**
1008    * @dev See {IERC721-getApproved}.
1009    */
1010   function getApproved(uint256 tokenId) public view override returns (address) {
1011     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1012 
1013     return _tokenApprovals[tokenId];
1014   }
1015 
1016   /**
1017    * @dev See {IERC721-setApprovalForAll}.
1018    */
1019   function setApprovalForAll(address operator, bool approved) public override {
1020     require(operator != _msgSender(), "ERC721A: approve to caller");
1021 
1022     _operatorApprovals[_msgSender()][operator] = approved;
1023     emit ApprovalForAll(_msgSender(), operator, approved);
1024   }
1025 
1026   /**
1027    * @dev See {IERC721-isApprovedForAll}.
1028    */
1029   function isApprovedForAll(address owner, address operator)
1030     public
1031     view
1032     virtual
1033     override
1034     returns (bool)
1035   {
1036     return _operatorApprovals[owner][operator];
1037   }
1038 
1039   /**
1040    * @dev See {IERC721-transferFrom}.
1041    */
1042   function transferFrom(
1043     address from,
1044     address to,
1045     uint256 tokenId
1046   ) public override {
1047     _transfer(from, to, tokenId);
1048   }
1049 
1050   /**
1051    * @dev See {IERC721-safeTransferFrom}.
1052    */
1053   function safeTransferFrom(
1054     address from,
1055     address to,
1056     uint256 tokenId
1057   ) public override {
1058     safeTransferFrom(from, to, tokenId, "");
1059   }
1060 
1061   /**
1062    * @dev See {IERC721-safeTransferFrom}.
1063    */
1064   function safeTransferFrom(
1065     address from,
1066     address to,
1067     uint256 tokenId,
1068     bytes memory _data
1069   ) public override {
1070     _transfer(from, to, tokenId);
1071     require(
1072       _checkOnERC721Received(from, to, tokenId, _data),
1073       "ERC721A: transfer to non ERC721Receiver implementer"
1074     );
1075   }
1076 
1077   /**
1078    * @dev Returns whether `tokenId` exists.
1079    *
1080    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1081    *
1082    * Tokens start existing when they are minted (`_mint`),
1083    */
1084   function _exists(uint256 tokenId) internal view returns (bool) {
1085     return tokenId < currentIndex;
1086   }
1087 
1088   function _safeMint(address to, uint256 quantity) internal {
1089     _safeMint(to, quantity, "");
1090   }
1091 
1092   /**
1093    * @dev Mints `quantity` tokens and transfers them to `to`.
1094    *
1095    * Requirements:
1096    *
1097    * - there must be `quantity` tokens remaining unminted in the total collection.
1098    * - `to` cannot be the zero address.
1099    * - `quantity` cannot be larger than the max batch size.
1100    *
1101    * Emits a {Transfer} event.
1102    */
1103   function _safeMint(
1104     address to,
1105     uint256 quantity,
1106     bytes memory _data
1107   ) internal {
1108     uint256 startTokenId = currentIndex;
1109     require(to != address(0), "ERC721A: mint to the zero address");
1110     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1111     require(!_exists(startTokenId), "ERC721A: token already minted");
1112     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1113 
1114     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1115 
1116     AddressData memory addressData = _addressData[to];
1117     _addressData[to] = AddressData(
1118       addressData.balance + uint128(quantity),
1119       addressData.numberMinted + uint128(quantity)
1120     );
1121     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1122 
1123     uint256 updatedIndex = startTokenId;
1124 
1125     for (uint256 i = 0; i < quantity; i++) {
1126       emit Transfer(address(0), to, updatedIndex);
1127       require(
1128         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1129         "ERC721A: transfer to non ERC721Receiver implementer"
1130       );
1131       updatedIndex++;
1132     }
1133 
1134     currentIndex = updatedIndex;
1135     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1136   }
1137 
1138   /**
1139    * @dev Transfers `tokenId` from `from` to `to`.
1140    *
1141    * Requirements:
1142    *
1143    * - `to` cannot be the zero address.
1144    * - `tokenId` token must be owned by `from`.
1145    *
1146    * Emits a {Transfer} event.
1147    */
1148   function _transfer(
1149     address from,
1150     address to,
1151     uint256 tokenId
1152   ) private {
1153     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1154 
1155     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1156       getApproved(tokenId) == _msgSender() ||
1157       isApprovedForAll(prevOwnership.addr, _msgSender()));
1158 
1159     require(
1160       isApprovedOrOwner,
1161       "ERC721A: transfer caller is not owner nor approved"
1162     );
1163 
1164     require(
1165       prevOwnership.addr == from,
1166       "ERC721A: transfer from incorrect owner"
1167     );
1168     require(to != address(0), "ERC721A: transfer to the zero address");
1169 
1170     _beforeTokenTransfers(from, to, tokenId, 1);
1171 
1172     // Clear approvals from the previous owner
1173     _approve(address(0), tokenId, prevOwnership.addr);
1174 
1175     _addressData[from].balance -= 1;
1176     _addressData[to].balance += 1;
1177     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1178 
1179     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1180     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1181     uint256 nextTokenId = tokenId + 1;
1182     if (_ownerships[nextTokenId].addr == address(0)) {
1183       if (_exists(nextTokenId)) {
1184         _ownerships[nextTokenId] = TokenOwnership(
1185           prevOwnership.addr,
1186           prevOwnership.startTimestamp
1187         );
1188       }
1189     }
1190 
1191     emit Transfer(from, to, tokenId);
1192     _afterTokenTransfers(from, to, tokenId, 1);
1193   }
1194 
1195   /**
1196    * @dev Approve `to` to operate on `tokenId`
1197    *
1198    * Emits a {Approval} event.
1199    */
1200   function _approve(
1201     address to,
1202     uint256 tokenId,
1203     address owner
1204   ) private {
1205     _tokenApprovals[tokenId] = to;
1206     emit Approval(owner, to, tokenId);
1207   }
1208 
1209   uint256 public nextOwnerToExplicitlySet = 0;
1210 
1211   /**
1212    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1213    */
1214   function _setOwnersExplicit(uint256 quantity) internal {
1215     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1216     require(quantity > 0, "quantity must be nonzero");
1217     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1218     if (endIndex > collectionSize - 1) {
1219       endIndex = collectionSize - 1;
1220     }
1221     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1222     require(_exists(endIndex), "not enough minted yet for this cleanup");
1223     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1224       if (_ownerships[i].addr == address(0)) {
1225         TokenOwnership memory ownership = ownershipOf(i);
1226         _ownerships[i] = TokenOwnership(
1227           ownership.addr,
1228           ownership.startTimestamp
1229         );
1230       }
1231     }
1232     nextOwnerToExplicitlySet = endIndex + 1;
1233   }
1234 
1235   /**
1236    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1237    * The call is not executed if the target address is not a contract.
1238    *
1239    * @param from address representing the previous owner of the given token ID
1240    * @param to target address that will receive the tokens
1241    * @param tokenId uint256 ID of the token to be transferred
1242    * @param _data bytes optional data to send along with the call
1243    * @return bool whether the call correctly returned the expected magic value
1244    */
1245   function _checkOnERC721Received(
1246     address from,
1247     address to,
1248     uint256 tokenId,
1249     bytes memory _data
1250   ) private returns (bool) {
1251     if (to.isContract()) {
1252       try
1253         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1254       returns (bytes4 retval) {
1255         return retval == IERC721Receiver(to).onERC721Received.selector;
1256       } catch (bytes memory reason) {
1257         if (reason.length == 0) {
1258           revert("ERC721A: transfer to non ERC721Receiver implementer");
1259         } else {
1260           assembly {
1261             revert(add(32, reason), mload(reason))
1262           }
1263         }
1264       }
1265     } else {
1266       return true;
1267     }
1268   }
1269 
1270   /**
1271    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1272    *
1273    * startTokenId - the first token id to be transferred
1274    * quantity - the amount to be transferred
1275    *
1276    * Calling conditions:
1277    *
1278    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1279    * transferred to `to`.
1280    * - When `from` is zero, `tokenId` will be minted for `to`.
1281    */
1282   function _beforeTokenTransfers(
1283     address from,
1284     address to,
1285     uint256 startTokenId,
1286     uint256 quantity
1287   ) internal virtual {}
1288 
1289   /**
1290    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1291    * minting.
1292    *
1293    * startTokenId - the first token id to be transferred
1294    * quantity - the amount to be transferred
1295    *
1296    * Calling conditions:
1297    *
1298    * - when `from` and `to` are both non-zero.
1299    * - `from` and `to` are never both zero.
1300    */
1301   function _afterTokenTransfers(
1302     address from,
1303     address to,
1304     uint256 startTokenId,
1305     uint256 quantity
1306   ) internal virtual {}
1307 }
1308 
1309 // File: contracts\RunEd.sol
1310 
1311 
1312 pragma solidity ^0.8.0;
1313 
1314 
1315 
1316 
1317 ////////////////////////////////////////////////////////////////////////////////////////////
1318 //                                                                                        //
1319 //                                                                                        //
1320 //    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.,...,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
1321 //    @@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,..................*@@@@@@@@@@@@@@@@@@@@@@@@@    //
1322 //    @@@@@@@@@@@@@@@@@@@@&,,,,,,,,,,,......*.,...................@@@@@@@@@@@@@@@@@@@@    //
1323 //    @@@@@@@@@@@@@@@@@,,,,,,,,,,,,....,@@@@@@@&@@&@..................@@@@@@@@@@@@@@@@    //
1324 //    @@@@@@@@@@@@@@,,,,,,,,,,,,.../@@%@&@@@@@@@@@&@@@&.#................@@@@@@@@@@@@@    //
1325 //    @@@@@@@@@@@,,,,,,,,,,,.,.&&@@@%@@@@@@@@&&@@&@@@@@@@*..................@@@@@@@@@@    //
1326 //    @@@@@@@@@,,,,,,,,,,,,,...@@@@@%@@@@@@@@@@@@@@@@@@@@@%@..................@@@@@@@@    //
1327 //    @@@@@@@,,,,,,,,,,,,.....@@@@@@@@@@@@@@@@@@@@@@@@@@(*@@....................@@@@@@    //
1328 //    @@@@@&,,,,,,,,,..........@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(....................@@@@@    //
1329 //    @@@@,,,,,,,,,,,,........*@%@@@@@@@@@@@@@@@@@@@@@@@@@@% ...................../@@@    //
1330 //    @@@,,,,,,,,,,,,............@@@@@@@@@@@@@@@@@@@@@@@@@#........................,@@    //
1331 //    @@*,,,,,,,,,,.,............@@*.@@@@@@@@@@@@@@@@@@,/...........................#@    //
1332 //    @&,,,,,,,,,,,,,,...............&@@@@@@@@@@@@@@@&##.......................,,,.,,@    //
1333 //    @***,,,,,,,,,,,,,,,............,#@@@@@@@@@@@@@@...................,,,,,,,,,,,,,,    //
1334 //    @****,,,,,,,,,,,,,,,,,,,.........#@&@@@@@@@%&(................,,,,,,,,,,,,,,,,,,    //
1335 //    ********,,,,,,,,,,,,,,,,,,,,,,,,.@@@@@@@@@%@@%.........,,,,,,,,,,,,,,,,,,,,,,,,,    //
1336 //    **********,,,,,,,,,,,,,,,,,,,,,,.......  ..       ..,,,,,,,,,,,,,,,,,,,,,,,,,,,,    //
1337 //    *************,*,,,,,,,,,,,,.    .                        ,,,,,,,,,,,,,,,,,,,,,,,    //
1338 //    @****************,,,,,       ..... .   .                     ,,,,,,,*,,,,,****,*    //
1339 //    @*****************,,,.   .,.,,...,,.... . .                   ******************    //
1340 //    @@/***************,,.. .,*.,.....,. . .....  ..          ..    ****************@    //
1341 //    @@///*************..... .,,.,,,.   .   .  . .      ...   , .    **************#@    //
1342 //    @@@//////********.,,.,./.(,,,,,........... . .   ....  ,....     .***********/@@    //
1343 //    @@@@//////*/***.*,,,**,..,#.,.. ....... . .    .  ,,.. *,..        *********@@@@    //
1344 //    @@@@@@////////..,..,,,,,#......,...  .    .  ..  .,,.. ,....    .**********@@@@@    //
1345 //    @@@@@@@////////*...,..,,,.,..........      .    ..,,.. ,   ,&@@@@/*******/@@@@@@    //
1346 //    @@@@@@@@@///////@@@@%..,/,........... . ....  .. .,.,..@@@@@@@@%&&/////*@@@@@@@@    //
1347 //    @@@@@@@@@@@////%@@@@@@@@@*............ .. . .  . .,,... @@@@@@@@@&%///@@@@@@@@@@    //
1348 //    @@@@@@@@@@@@@@/@@@@@@@@@@/......... ... .....     ,*..../@@@&@@@@&&@@@@@@@@@@@@@    //
1349 //    @@@@@@@@@@@@@@@@@@@@@@@@@....  . . . ...... ..... ..,..../@@@@@&@@@@@@@@@@@@@@@@    //
1350 //    @@@@@@@@@@@@@@@@@@@@@@@@(.......   ... ......       ..,..//@@@@@@@@@@@@@@@@@@@@@    //
1351 //    @@@@@@@@@@@@@@@@@@@@@@@@@@/....  ..  . ...... .     ..%@@@@@@@@@@@@@@@@@@@@@@@@@    //
1352 //                                                                                        //
1353 //                                                                                        //
1354 ////////////////////////////////////////////////////////////////////////////////////////////
1355 
1356 contract RunEd is Ownable, ERC721A, ReentrancyGuard {
1357   uint256 public immutable maxPerAddressDuringMint;
1358   uint256 public immutable amountForDevs;
1359 
1360   struct SaleConfig {
1361     uint32 publicSaleStartTime;
1362     uint64 mintlistPrice;
1363     uint64 publicPrice;
1364     uint32 publicSaleKey;
1365   }
1366 
1367   SaleConfig public saleConfig;
1368 
1369   mapping(address => uint256) public allowlist;
1370 
1371   constructor(
1372     uint256 maxBatchSize_,
1373     uint256 collectionSize_,
1374     uint256 amountForDevs_
1375   ) ERC721A("Run Ed.", "RUNED", maxBatchSize_, collectionSize_) {
1376     maxPerAddressDuringMint = maxBatchSize_;
1377     amountForDevs = amountForDevs_;
1378     require(
1379       amountForDevs_ <= collectionSize_,
1380       "larger collection size needed"
1381     );
1382   }
1383 
1384   modifier callerIsUser() {
1385     require(tx.origin == msg.sender, "The caller is another contract");
1386     _;
1387   }
1388 
1389   function allowlistMint(uint256 quantity) external payable callerIsUser {
1390     uint256 price = uint256(saleConfig.mintlistPrice);
1391     require(price != 0, "allowlist sale has not begun yet");
1392     require(allowlist[msg.sender] > 0, "not eligible for allowlist mint");
1393     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1394     require(allowlist[msg.sender] >= quantity, "minting quantity exceeded max per wallet");
1395     require(numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,"can not mint this many");
1396     allowlist[msg.sender]-= quantity;
1397     _safeMint(msg.sender, quantity);
1398     refundIfOver(price * quantity);
1399   }
1400 
1401   function publicSaleMint(uint256 quantity, uint256 callerPublicSaleKey)
1402     external
1403     payable
1404     callerIsUser
1405   {
1406     SaleConfig memory config = saleConfig;
1407     uint256 publicSaleKey = uint256(config.publicSaleKey);
1408     uint256 publicPrice = uint256(config.publicPrice);
1409     uint256 publicSaleStartTime = uint256(config.publicSaleStartTime);
1410     require(
1411       publicSaleKey == callerPublicSaleKey,
1412       "called with incorrect public sale key"
1413     );
1414 
1415     require(
1416       isPublicSaleOn(publicPrice, publicSaleKey, publicSaleStartTime),
1417       "public sale has not begun yet"
1418     );
1419     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1420     require(
1421       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1422       "can not mint this many"
1423     );
1424     _safeMint(msg.sender, quantity);
1425     refundIfOver(publicPrice * quantity);
1426   }
1427 
1428   function refundIfOver(uint256 price) private {
1429     require(msg.value >= price, "Need to send more ETH.");
1430     if (msg.value > price) {
1431       payable(msg.sender).transfer(msg.value - price);
1432     }
1433   }
1434 
1435   function isPublicSaleOn(
1436     uint256 publicPriceWei,
1437     uint256 publicSaleKey,
1438     uint256 publicSaleStartTime
1439   ) public view returns (bool) {
1440     return
1441       publicPriceWei != 0 &&
1442       publicSaleKey != 0 &&
1443       block.timestamp >= publicSaleStartTime;
1444   }
1445   
1446   function setupSaleInfo(
1447     uint64 mintlistPriceWei,
1448     uint64 publicPriceWei,
1449     uint32 publicSaleStartTime
1450   ) external onlyOwner {
1451     saleConfig = SaleConfig(
1452       publicSaleStartTime,
1453       mintlistPriceWei,
1454       publicPriceWei,
1455       saleConfig.publicSaleKey
1456     );
1457   }
1458 
1459   function setPublicSaleKey(uint32 key) external onlyOwner {
1460     saleConfig.publicSaleKey = key;
1461   }
1462 
1463   function seedAllowlist(address[] memory addresses, uint256[] memory numSlots)
1464     external
1465     onlyOwner
1466   {
1467     require(
1468       addresses.length == numSlots.length,
1469       "addresses does not match numSlots length"
1470     );
1471     for (uint256 i = 0; i < addresses.length; i++) {
1472       allowlist[addresses[i]] = numSlots[i];
1473     }
1474   }
1475 
1476   // For marketing etc.
1477   function devMint(uint256 quantity) external onlyOwner {
1478     require(
1479       totalSupply() + quantity <= amountForDevs,
1480       "too many already minted before dev mint"
1481     );
1482     require(
1483       quantity % maxBatchSize == 0,
1484       "can only mint a multiple of the maxBatchSize"
1485     );
1486     uint256 numChunks = quantity / maxBatchSize;
1487     for (uint256 i = 0; i < numChunks; i++) {
1488       _safeMint(msg.sender, maxBatchSize);
1489     }
1490   }
1491 
1492   // // metadata URI
1493   string private _baseTokenURI;
1494 
1495   function _baseURI() internal view virtual override returns (string memory) {
1496     return _baseTokenURI;
1497   }
1498 
1499   function setBaseURI(string calldata baseURI) external onlyOwner {
1500     _baseTokenURI = baseURI;
1501   }
1502 
1503   function withdrawMoney() external onlyOwner nonReentrant {
1504     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1505     require(success, "Transfer failed.");
1506   }
1507 
1508   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1509     _setOwnersExplicit(quantity);
1510   }
1511 
1512   function numberMinted(address owner) public view returns (uint256) {
1513     return _numberMinted(owner);
1514   }
1515 
1516   function getOwnershipData(uint256 tokenId)
1517     external
1518     view
1519     returns (TokenOwnership memory)
1520   {
1521     return ownershipOf(tokenId);
1522   }
1523 }