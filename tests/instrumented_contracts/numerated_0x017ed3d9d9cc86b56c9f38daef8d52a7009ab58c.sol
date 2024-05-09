1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.9;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Strings.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev String operations.
77  */
78 library Strings {
79     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
83      */
84     function toString(uint256 value) internal pure returns (string memory) {
85         // Inspired by OraclizeAPI's implementation - MIT licence
86         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
87 
88         if (value == 0) {
89             return "0";
90         }
91         uint256 temp = value;
92         uint256 digits;
93         while (temp != 0) {
94             digits++;
95             temp /= 10;
96         }
97         bytes memory buffer = new bytes(digits);
98         while (value != 0) {
99             digits -= 1;
100             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
101             value /= 10;
102         }
103         return string(buffer);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
108      */
109     function toHexString(uint256 value) internal pure returns (string memory) {
110         if (value == 0) {
111             return "0x00";
112         }
113         uint256 temp = value;
114         uint256 length = 0;
115         while (temp != 0) {
116             length++;
117             temp >>= 8;
118         }
119         return toHexString(value, length);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
124      */
125     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
126         bytes memory buffer = new bytes(2 * length + 2);
127         buffer[0] = "0";
128         buffer[1] = "x";
129         for (uint256 i = 2 * length + 1; i > 1; --i) {
130             buffer[i] = _HEX_SYMBOLS[value & 0xf];
131             value >>= 4;
132         }
133         require(value == 0, "Strings: hex length insufficient");
134         return string(buffer);
135     }
136 }
137 
138 // File: @openzeppelin/contracts/utils/Context.sol
139 
140 
141 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
142 
143 pragma solidity ^0.8.0;
144 
145 /**
146  * @dev Provides information about the current execution context, including the
147  * sender of the transaction and its data. While these are generally available
148  * via msg.sender and msg.data, they should not be accessed in such a direct
149  * manner, since when dealing with meta-transactions the account sending and
150  * paying for execution may not be the actual sender (as far as an application
151  * is concerned).
152  *
153  * This contract is only required for intermediate, library-like contracts.
154  */
155 abstract contract Context {
156     function _msgSender() internal view virtual returns (address) {
157         return msg.sender;
158     }
159 
160     function _msgData() internal view virtual returns (bytes calldata) {
161         return msg.data;
162     }
163 }
164 
165 // File: @openzeppelin/contracts/access/Ownable.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 
173 /**
174  * @dev Contract module which provides a basic access control mechanism, where
175  * there is an account (an owner) that can be granted exclusive access to
176  * specific functions.
177  *
178  * By default, the owner account will be the one that deploys the contract. This
179  * can later be changed with {transferOwnership}.
180  *
181  * This module is used through inheritance. It will make available the modifier
182  * `onlyOwner`, which can be applied to your functions to restrict their use to
183  * the owner.
184  */
185 abstract contract Ownable is Context {
186     address private _owner;
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190     /**
191      * @dev Initializes the contract setting the deployer as the initial owner.
192      */
193     constructor() {
194         _transferOwnership(_msgSender());
195     }
196 
197     /**
198      * @dev Returns the address of the current owner.
199      */
200     function owner() public view virtual returns (address) {
201         return _owner;
202     }
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         require(owner() == _msgSender(), "Ownable: caller is not the owner");
209         _;
210     }
211 
212     /**
213      * @dev Leaves the contract without owner. It will not be possible to call
214      * `onlyOwner` functions anymore. Can only be called by the current owner.
215      *
216      * NOTE: Renouncing ownership will leave the contract without an owner,
217      * thereby removing any functionality that is only available to the owner.
218      */
219     function renounceOwnership() public virtual onlyOwner {
220         _transferOwnership(address(0));
221     }
222 
223     /**
224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
225      * Can only be called by the current owner.
226      */
227     function transferOwnership(address newOwner) public virtual onlyOwner {
228         require(newOwner != address(0), "Ownable: new owner is the zero address");
229         _transferOwnership(newOwner);
230     }
231 
232     /**
233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
234      * Internal function without access restriction.
235      */
236     function _transferOwnership(address newOwner) internal virtual {
237         address oldOwner = _owner;
238         _owner = newOwner;
239         emit OwnershipTransferred(oldOwner, newOwner);
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 
246 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // This method relies on extcodesize, which returns 0 for contracts in
273         // construction, since the code is only stored at the end of the
274         // constructor execution.
275 
276         uint256 size;
277         assembly {
278             size := extcodesize(account)
279         }
280         return size > 0;
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         (bool success, ) = recipient.call{value: amount}("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain `call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325         return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(
368         address target,
369         bytes memory data,
370         uint256 value,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         require(isContract(target), "Address: call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.call{value: value}(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
387         return functionStaticCall(target, data, "Address: low-level static call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal view returns (bytes memory) {
401         require(isContract(target), "Address: static call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.staticcall(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(isContract(target), "Address: delegate call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.delegatecall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
436      * revert reason using the provided one.
437      *
438      * _Available since v4.3._
439      */
440     function verifyCallResult(
441         bool success,
442         bytes memory returndata,
443         string memory errorMessage
444     ) internal pure returns (bytes memory) {
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451 
452                 assembly {
453                     let returndata_size := mload(returndata)
454                     revert(add(32, returndata), returndata_size)
455                 }
456             } else {
457                 revert(errorMessage);
458             }
459         }
460     }
461 }
462 
463 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
464 
465 
466 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @title ERC721 token receiver interface
472  * @dev Interface for any contract that wants to support safeTransfers
473  * from ERC721 asset contracts.
474  */
475 interface IERC721Receiver {
476     /**
477      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
478      * by `operator` from `from`, this function is called.
479      *
480      * It must return its Solidity selector to confirm the token transfer.
481      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
482      *
483      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
484      */
485     function onERC721Received(
486         address operator,
487         address from,
488         uint256 tokenId,
489         bytes calldata data
490     ) external returns (bytes4);
491 }
492 
493 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @dev Interface of the ERC165 standard, as defined in the
502  * https://eips.ethereum.org/EIPS/eip-165[EIP].
503  *
504  * Implementers can declare support of contract interfaces, which can then be
505  * queried by others ({ERC165Checker}).
506  *
507  * For an implementation, see {ERC165}.
508  */
509 interface IERC165 {
510     /**
511      * @dev Returns true if this contract implements the interface defined by
512      * `interfaceId`. See the corresponding
513      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
514      * to learn more about how these ids are created.
515      *
516      * This function call must use less than 30 000 gas.
517      */
518     function supportsInterface(bytes4 interfaceId) external view returns (bool);
519 }
520 
521 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 
529 /**
530  * @dev Implementation of the {IERC165} interface.
531  *
532  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
533  * for the additional interface id that will be supported. For example:
534  *
535  * ```solidity
536  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
538  * }
539  * ```
540  *
541  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
542  */
543 abstract contract ERC165 is IERC165 {
544     /**
545      * @dev See {IERC165-supportsInterface}.
546      */
547     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548         return interfaceId == type(IERC165).interfaceId;
549     }
550 }
551 
552 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @dev Required interface of an ERC721 compliant contract.
562  */
563 interface IERC721 is IERC165 {
564     /**
565      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
566      */
567     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
568 
569     /**
570      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
571      */
572     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
573 
574     /**
575      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
576      */
577     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
578 
579     /**
580      * @dev Returns the number of tokens in ``owner``'s account.
581      */
582     function balanceOf(address owner) external view returns (uint256 balance);
583 
584     /**
585      * @dev Returns the owner of the `tokenId` token.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      */
591     function ownerOf(uint256 tokenId) external view returns (address owner);
592 
593     /**
594      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
595      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must exist and be owned by `from`.
602      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604      *
605      * Emits a {Transfer} event.
606      */
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Transfers `tokenId` token from `from` to `to`.
615      *
616      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      *
625      * Emits a {Transfer} event.
626      */
627     function transferFrom(
628         address from,
629         address to,
630         uint256 tokenId
631     ) external;
632 
633     /**
634      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
635      * The approval is cleared when the token is transferred.
636      *
637      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
638      *
639      * Requirements:
640      *
641      * - The caller must own the token or be an approved operator.
642      * - `tokenId` must exist.
643      *
644      * Emits an {Approval} event.
645      */
646     function approve(address to, uint256 tokenId) external;
647 
648     /**
649      * @dev Returns the account approved for `tokenId` token.
650      *
651      * Requirements:
652      *
653      * - `tokenId` must exist.
654      */
655     function getApproved(uint256 tokenId) external view returns (address operator);
656 
657     /**
658      * @dev Approve or remove `operator` as an operator for the caller.
659      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
660      *
661      * Requirements:
662      *
663      * - The `operator` cannot be the caller.
664      *
665      * Emits an {ApprovalForAll} event.
666      */
667     function setApprovalForAll(address operator, bool _approved) external;
668 
669     /**
670      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
671      *
672      * See {setApprovalForAll}
673      */
674     function isApprovedForAll(address owner, address operator) external view returns (bool);
675 
676     /**
677      * @dev Safely transfers `tokenId` token from `from` to `to`.
678      *
679      * Requirements:
680      *
681      * - `from` cannot be the zero address.
682      * - `to` cannot be the zero address.
683      * - `tokenId` token must exist and be owned by `from`.
684      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
685      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
686      *
687      * Emits a {Transfer} event.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId,
693         bytes calldata data
694     ) external;
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
698 
699 
700 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
707  * @dev See https://eips.ethereum.org/EIPS/eip-721
708  */
709 interface IERC721Enumerable is IERC721 {
710     /**
711      * @dev Returns the total amount of tokens stored by the contract.
712      */
713     function totalSupply() external view returns (uint256);
714 
715     /**
716      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
717      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
718      */
719     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
720 
721     /**
722      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
723      * Use along with {totalSupply} to enumerate all tokens.
724      */
725     function tokenByIndex(uint256 index) external view returns (uint256);
726 }
727 
728 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
729 
730 
731 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
732 
733 pragma solidity ^0.8.0;
734 
735 
736 /**
737  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
738  * @dev See https://eips.ethereum.org/EIPS/eip-721
739  */
740 interface IERC721Metadata is IERC721 {
741     /**
742      * @dev Returns the token collection name.
743      */
744     function name() external view returns (string memory);
745 
746     /**
747      * @dev Returns the token collection symbol.
748      */
749     function symbol() external view returns (string memory);
750 
751     /**
752      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
753      */
754     function tokenURI(uint256 tokenId) external view returns (string memory);
755 }
756 
757 // File: contracts/ERC721A.sol
758 
759 
760 // Creator: Chiru Labs
761 
762 pragma solidity ^0.8.4;
763 
764 
765 
766 
767 
768 
769 
770 
771 
772 error ApprovalCallerNotOwnerNorApproved();
773 error ApprovalQueryForNonexistentToken();
774 error ApproveToCaller();
775 error ApprovalToCurrentOwner();
776 error BalanceQueryForZeroAddress();
777 error MintedQueryForZeroAddress();
778 error BurnedQueryForZeroAddress();
779 error AuxQueryForZeroAddress();
780 error MintToZeroAddress();
781 error MintZeroQuantity();
782 error OwnerIndexOutOfBounds();
783 error OwnerQueryForNonexistentToken();
784 error TokenIndexOutOfBounds();
785 error TransferCallerNotOwnerNorApproved();
786 error TransferFromIncorrectOwner();
787 error TransferToNonERC721ReceiverImplementer();
788 error TransferToZeroAddress();
789 error URIQueryForNonexistentToken();
790 
791 /**
792  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
793  * the Metadata extension. Built to optimize for lower gas during batch mints.
794  *
795  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
796  *
797  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
798  *
799  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
800  */
801 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
802     using Address for address;
803     using Strings for uint256;
804 
805     // Compiler will pack this into a single 256bit word.
806     struct TokenOwnership {
807         // The address of the owner.
808         address addr;
809         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
810         uint64 startTimestamp;
811         // Whether the token has been burned.
812         bool burned;
813     }
814 
815     // Compiler will pack this into a single 256bit word.
816     struct AddressData {
817         // Realistically, 2**64-1 is more than enough.
818         uint64 balance;
819         // Keeps track of mint count with minimal overhead for tokenomics.
820         uint64 numberMinted;
821         // Keeps track of burn count with minimal overhead for tokenomics.
822         uint64 numberBurned;
823         // For miscellaneous variable(s) pertaining to the address
824         // (e.g. number of whitelist mint slots used).
825         // If there are multiple variables, please pack them into a uint64.
826         uint64 aux;
827     }
828 
829     // The tokenId of the next token to be minted.
830     uint256 internal _currentIndex;
831 
832     // The number of tokens burned.
833     uint256 internal _burnCounter;
834 
835     // Token name
836     string private _name;
837 
838     // Token symbol
839     string private _symbol;
840 
841     // Mapping from token ID to ownership details
842     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
843     mapping(uint256 => TokenOwnership) internal _ownerships;
844 
845     // Mapping owner address to address data
846     mapping(address => AddressData) private _addressData;
847 
848     // Mapping from token ID to approved address
849     mapping(uint256 => address) private _tokenApprovals;
850 
851     // Mapping from owner to operator approvals
852     mapping(address => mapping(address => bool)) private _operatorApprovals;
853 
854     constructor(string memory name_, string memory symbol_) {
855         _name = name_;
856         _symbol = symbol_;
857         _currentIndex = _startTokenId();
858     }
859 
860     /**
861      * To change the starting tokenId, please override this function.
862      */
863     function _startTokenId() internal view virtual returns (uint256) {
864         return 0;
865     }
866 
867     /**
868      * @dev See {IERC721Enumerable-totalSupply}.
869      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
870      */
871     function totalSupply() public view returns (uint256) {
872         // Counter underflow is impossible as _burnCounter cannot be incremented
873         // more than _currentIndex - _startTokenId() times
874         unchecked {
875             return _currentIndex - _burnCounter - _startTokenId();
876         }
877     }
878 
879     /**
880      * Returns the total amount of tokens minted in the contract.
881      */
882     function _totalMinted() internal view returns (uint256) {
883         // Counter underflow is impossible as _currentIndex does not decrement,
884         // and it is initialized to _startTokenId()
885         unchecked {
886             return _currentIndex - _startTokenId();
887         }
888     }
889 
890     /**
891      * @dev See {IERC165-supportsInterface}.
892      */
893     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
894         return
895             interfaceId == type(IERC721).interfaceId ||
896             interfaceId == type(IERC721Metadata).interfaceId ||
897             super.supportsInterface(interfaceId);
898     }
899 
900     /**
901      * @dev See {IERC721-balanceOf}.
902      */
903     function balanceOf(address owner) public view override returns (uint256) {
904         if (owner == address(0)) revert BalanceQueryForZeroAddress();
905         return uint256(_addressData[owner].balance);
906     }
907 
908     /**
909      * Returns the number of tokens minted by `owner`.
910      */
911     function _numberMinted(address owner) internal view returns (uint256) {
912         if (owner == address(0)) revert MintedQueryForZeroAddress();
913         return uint256(_addressData[owner].numberMinted);
914     }
915 
916     /**
917      * Returns the number of tokens burned by or on behalf of `owner`.
918      */
919     function _numberBurned(address owner) internal view returns (uint256) {
920         if (owner == address(0)) revert BurnedQueryForZeroAddress();
921         return uint256(_addressData[owner].numberBurned);
922     }
923 
924     /**
925      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
926      */
927     function _getAux(address owner) internal view returns (uint64) {
928         if (owner == address(0)) revert AuxQueryForZeroAddress();
929         return _addressData[owner].aux;
930     }
931 
932     /**
933      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
934      * If there are multiple variables, please pack them into a uint64.
935      */
936     function _setAux(address owner, uint64 aux) internal {
937         if (owner == address(0)) revert AuxQueryForZeroAddress();
938         _addressData[owner].aux = aux;
939     }
940 
941     /**
942      * Gas spent here starts off proportional to the maximum mint batch size.
943      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
944      */
945     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
946         uint256 curr = tokenId;
947 
948         unchecked {
949             if (_startTokenId() <= curr && curr < _currentIndex) {
950                 TokenOwnership memory ownership = _ownerships[curr];
951                 if (!ownership.burned) {
952                     if (ownership.addr != address(0)) {
953                         return ownership;
954                     }
955                     // Invariant:
956                     // There will always be an ownership that has an address and is not burned
957                     // before an ownership that does not have an address and is not burned.
958                     // Hence, curr will not underflow.
959                     while (true) {
960                         curr--;
961                         ownership = _ownerships[curr];
962                         if (ownership.addr != address(0)) {
963                             return ownership;
964                         }
965                     }
966                 }
967             }
968         }
969         revert OwnerQueryForNonexistentToken();
970     }
971 
972     /**
973      * @dev See {IERC721-ownerOf}.
974      */
975     function ownerOf(uint256 tokenId) public view override returns (address) {
976         return ownershipOf(tokenId).addr;
977     }
978 
979     /**
980      * @dev See {IERC721Metadata-name}.
981      */
982     function name() public view virtual override returns (string memory) {
983         return _name;
984     }
985 
986     /**
987      * @dev See {IERC721Metadata-symbol}.
988      */
989     function symbol() public view virtual override returns (string memory) {
990         return _symbol;
991     }
992 
993     /**
994      * @dev See {IERC721Metadata-tokenURI}.
995      */
996     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
997         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
998 
999         string memory baseURI = _baseURI();
1000         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1001     }
1002 
1003     /**
1004      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1005      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1006      * by default, can be overriden in child contracts.
1007      */
1008     function _baseURI() internal view virtual returns (string memory) {
1009         return '';
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-approve}.
1014      */
1015     function approve(address to, uint256 tokenId) public virtual override {
1016         address owner = ERC721A.ownerOf(tokenId);
1017         if (to == owner) revert ApprovalToCurrentOwner();
1018 
1019         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1020             revert ApprovalCallerNotOwnerNorApproved();
1021         }
1022 
1023         _approve(to, tokenId, owner);
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-getApproved}.
1028      */
1029     function getApproved(uint256 tokenId) public view override returns (address) {
1030         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1031 
1032         return _tokenApprovals[tokenId];
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-setApprovalForAll}.
1037      */
1038     function setApprovalForAll(address operator, bool approved) public virtual override {
1039         if (operator == _msgSender()) revert ApproveToCaller();
1040 
1041         _operatorApprovals[_msgSender()][operator] = approved;
1042         emit ApprovalForAll(_msgSender(), operator, approved);
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-isApprovedForAll}.
1047      */
1048     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1049         return _operatorApprovals[owner][operator];
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-transferFrom}.
1054      */
1055     function transferFrom(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) public virtual override {
1060         _transfer(from, to, tokenId);
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-safeTransferFrom}.
1065      */
1066     function safeTransferFrom(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) public virtual override {
1071         safeTransferFrom(from, to, tokenId, '');
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-safeTransferFrom}.
1076      */
1077     function safeTransferFrom(
1078         address from,
1079         address to,
1080         uint256 tokenId,
1081         bytes memory _data
1082     ) public virtual override {
1083         _transfer(from, to, tokenId);
1084         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1085             revert TransferToNonERC721ReceiverImplementer();
1086         }
1087     }
1088 
1089     /**
1090      * @dev Returns whether `tokenId` exists.
1091      *
1092      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1093      *
1094      * Tokens start existing when they are minted (`_mint`),
1095      */
1096     function _exists(uint256 tokenId) internal view returns (bool) {
1097         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1098             !_ownerships[tokenId].burned;
1099     }
1100 
1101     function _safeMint(address to, uint256 quantity) internal {
1102         _safeMint(to, quantity, '');
1103     }
1104 
1105     /**
1106      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1107      *
1108      * Requirements:
1109      *
1110      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1111      * - `quantity` must be greater than 0.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function _safeMint(
1116         address to,
1117         uint256 quantity,
1118         bytes memory _data
1119     ) internal {
1120         _mint(to, quantity, _data, true);
1121     }
1122 
1123     /**
1124      * @dev Mints `quantity` tokens and transfers them to `to`.
1125      *
1126      * Requirements:
1127      *
1128      * - `to` cannot be the zero address.
1129      * - `quantity` must be greater than 0.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _mint(
1134         address to,
1135         uint256 quantity,
1136         bytes memory _data,
1137         bool safe
1138     ) internal {
1139         uint256 startTokenId = _currentIndex;
1140         if (to == address(0)) revert MintToZeroAddress();
1141         if (quantity == 0) revert MintZeroQuantity();
1142 
1143         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1144 
1145         // Overflows are incredibly unrealistic.
1146         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1147         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1148         unchecked {
1149             _addressData[to].balance += uint64(quantity);
1150             _addressData[to].numberMinted += uint64(quantity);
1151 
1152             _ownerships[startTokenId].addr = to;
1153             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1154 
1155             uint256 updatedIndex = startTokenId;
1156             uint256 end = updatedIndex + quantity;
1157 
1158             if (safe && to.isContract()) {
1159                 do {
1160                     emit Transfer(address(0), to, updatedIndex);
1161                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1162                         revert TransferToNonERC721ReceiverImplementer();
1163                     }
1164                 } while (updatedIndex != end);
1165                 // Reentrancy protection
1166                 if (_currentIndex != startTokenId) revert();
1167             } else {
1168                 do {
1169                     emit Transfer(address(0), to, updatedIndex++);
1170                 } while (updatedIndex != end);
1171             }
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
1192         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1193 
1194         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1195             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1196             getApproved(tokenId) == _msgSender());
1197 
1198         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1199         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1200         if (to == address(0)) revert TransferToZeroAddress();
1201 
1202         _beforeTokenTransfers(from, to, tokenId, 1);
1203 
1204         // Clear approvals from the previous owner
1205         _approve(address(0), tokenId, prevOwnership.addr);
1206 
1207         // Underflow of the sender's balance is impossible because we check for
1208         // ownership above and the recipient's balance can't realistically overflow.
1209         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1210         unchecked {
1211             _addressData[from].balance -= 1;
1212             _addressData[to].balance += 1;
1213 
1214             _ownerships[tokenId].addr = to;
1215             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1216 
1217             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1218             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1219             uint256 nextTokenId = tokenId + 1;
1220             if (_ownerships[nextTokenId].addr == address(0)) {
1221                 // This will suffice for checking _exists(nextTokenId),
1222                 // as a burned slot cannot contain the zero address.
1223                 if (nextTokenId < _currentIndex) {
1224                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1225                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1226                 }
1227             }
1228         }
1229 
1230         emit Transfer(from, to, tokenId);
1231         _afterTokenTransfers(from, to, tokenId, 1);
1232     }
1233 
1234     /**
1235      * @dev Destroys `tokenId`.
1236      * The approval is cleared when the token is burned.
1237      *
1238      * Requirements:
1239      *
1240      * - `tokenId` must exist.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _burn(uint256 tokenId) internal virtual {
1245         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1246 
1247         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1248 
1249         // Clear approvals from the previous owner
1250         _approve(address(0), tokenId, prevOwnership.addr);
1251 
1252         // Underflow of the sender's balance is impossible because we check for
1253         // ownership above and the recipient's balance can't realistically overflow.
1254         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1255         unchecked {
1256             _addressData[prevOwnership.addr].balance -= 1;
1257             _addressData[prevOwnership.addr].numberBurned += 1;
1258 
1259             // Keep track of who burned the token, and the timestamp of burning.
1260             _ownerships[tokenId].addr = prevOwnership.addr;
1261             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1262             _ownerships[tokenId].burned = true;
1263 
1264             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1265             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1266             uint256 nextTokenId = tokenId + 1;
1267             if (_ownerships[nextTokenId].addr == address(0)) {
1268                 // This will suffice for checking _exists(nextTokenId),
1269                 // as a burned slot cannot contain the zero address.
1270                 if (nextTokenId < _currentIndex) {
1271                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1272                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1273                 }
1274             }
1275         }
1276 
1277         emit Transfer(prevOwnership.addr, address(0), tokenId);
1278         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1279 
1280         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1281         unchecked {
1282             _burnCounter++;
1283         }
1284     }
1285 
1286     /**
1287      * @dev Approve `to` to operate on `tokenId`
1288      *
1289      * Emits a {Approval} event.
1290      */
1291     function _approve(
1292         address to,
1293         uint256 tokenId,
1294         address owner
1295     ) private {
1296         _tokenApprovals[tokenId] = to;
1297         emit Approval(owner, to, tokenId);
1298     }
1299 
1300     /**
1301      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1302      *
1303      * @param from address representing the previous owner of the given token ID
1304      * @param to target address that will receive the tokens
1305      * @param tokenId uint256 ID of the token to be transferred
1306      * @param _data bytes optional data to send along with the call
1307      * @return bool whether the call correctly returned the expected magic value
1308      */
1309     function _checkContractOnERC721Received(
1310         address from,
1311         address to,
1312         uint256 tokenId,
1313         bytes memory _data
1314     ) private returns (bool) {
1315         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1316             return retval == IERC721Receiver(to).onERC721Received.selector;
1317         } catch (bytes memory reason) {
1318             if (reason.length == 0) {
1319                 revert TransferToNonERC721ReceiverImplementer();
1320             } else {
1321                 assembly {
1322                     revert(add(32, reason), mload(reason))
1323                 }
1324             }
1325         }
1326     }
1327 
1328     /**
1329      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1330      * And also called before burning one token.
1331      *
1332      * startTokenId - the first token id to be transferred
1333      * quantity - the amount to be transferred
1334      *
1335      * Calling conditions:
1336      *
1337      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1338      * transferred to `to`.
1339      * - When `from` is zero, `tokenId` will be minted for `to`.
1340      * - When `to` is zero, `tokenId` will be burned by `from`.
1341      * - `from` and `to` are never both zero.
1342      */
1343     function _beforeTokenTransfers(
1344         address from,
1345         address to,
1346         uint256 startTokenId,
1347         uint256 quantity
1348     ) internal virtual {}
1349 
1350     /**
1351      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1352      * minting.
1353      * And also called after one token has been burned.
1354      *
1355      * startTokenId - the first token id to be transferred
1356      * quantity - the amount to be transferred
1357      *
1358      * Calling conditions:
1359      *
1360      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1361      * transferred to `to`.
1362      * - When `from` is zero, `tokenId` has been minted for `to`.
1363      * - When `to` is zero, `tokenId` has been burned by `from`.
1364      * - `from` and `to` are never both zero.
1365      */
1366     function _afterTokenTransfers(
1367         address from,
1368         address to,
1369         uint256 startTokenId,
1370         uint256 quantity
1371     ) internal virtual {}
1372 }
1373 // File: contracts/AzukiNext.sol
1374 
1375 
1376 
1377 pragma solidity >=0.8.9 <0.9.0;
1378 
1379 
1380 
1381 
1382 contract Metaflexer is ERC721A, Ownable, ReentrancyGuard {
1383 
1384   using Strings for uint256;
1385 
1386   string public uriSuffix = '.json';
1387   string public hiddenMetadataUri;
1388 
1389   address public t1=0xfB92b565BbE89e6bd0A15fE24Fb4CA43BC023973;
1390   address public t2=0x8bcC6329cA83c3104829847eF96720948D9Fad7E;
1391   address public t3=0xd1DB75786B5581bAf2974a949247fbf41D1dAa99;
1392   
1393   uint256 public cost;
1394   uint256 public maxSupply; 
1395   uint256 public maxMintAmount;
1396   uint256 public saleStatus;
1397 
1398   bool public revealed;
1399   bool public upgradeEnabled;
1400 
1401   address public signerAddress;
1402 
1403   mapping(uint256 => address) public collectionIDaddress; 
1404   mapping(uint256 => uint256) public tokenIDbaseID;
1405   mapping(uint256 => string)  public baseIDbaseURI;
1406 
1407 
1408   constructor() ERC721A("Metaflexer", "MTFLXR") {
1409     cost = 0.08 ether;
1410     maxSupply = 10000;
1411     maxMintAmount = 5;  
1412     signerAddress = 0xDFd3eB6Cb999D4fB2c5a19dE889208216BCc06A4;  
1413     setHiddenMetadataUri("https://ipfs.filebase.io/ipfs/QmQBjenMLZKrccwkaf4rGVgGjqJY3U2hNkqA7pgSZB8tKC");
1414     _safeMint(_msgSender(), 1);
1415   }
1416 
1417   modifier mintCompliance(uint256 _mintAmount) {
1418     require(tx.origin == msg.sender, "The caller is another contract");
1419     require(_mintAmount > 0 && _mintAmount <= maxMintAmount, 'Invalid mint amount!');
1420     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1421     _;
1422   }
1423 
1424   modifier mintPriceCompliance(uint256 _mintAmount) {
1425     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1426     _;
1427   }
1428 
1429   function whitelistMint(uint256 _mintAmount, bytes memory sig) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1430     require(saleStatus==1, "The whitelist sale is not enabled!");
1431     require(verify(sig, _msgSender()), "Sorry, but you are not in WL");
1432     require(_numberMinted(_msgSender()) + _mintAmount <= maxMintAmount,"Exceeded max available to purchase");
1433     _safeMint(_msgSender(), _mintAmount);
1434   }
1435 
1436   function publicMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1437     require(saleStatus==2, "Public mint disabled");
1438     require(_numberMinted(_msgSender()) + _mintAmount <= maxMintAmount,"exceeds max per address");
1439     _safeMint(_msgSender(), _mintAmount);
1440   }
1441   
1442   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1443     _safeMint(_receiver, _mintAmount);
1444   }
1445 
1446   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1447     uint256 ownerTokenCount = balanceOf(_owner);
1448     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1449     uint256 currentTokenId = _startTokenId();
1450     uint256 ownedTokenIndex = 0;
1451 
1452     while (ownedTokenIndex < ownerTokenCount && currentTokenId < maxSupply) {
1453       address currentTokenOwner = ownerOf(currentTokenId);
1454 
1455       if (currentTokenOwner == _owner) {
1456         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1457 
1458         ownedTokenIndex++;
1459       }
1460       currentTokenId++;
1461     }
1462     return ownedTokenIds;
1463   }
1464 
1465 
1466   function _startTokenId() internal view virtual override returns (uint256) {
1467         return 1;
1468     }
1469 
1470 
1471   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1472     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1473     if (revealed == false) {
1474       return hiddenMetadataUri;
1475     }
1476     uint256 tokenBase = tokenIDbaseID[_tokenId];
1477     return  string(abi.encodePacked(baseIDbaseURI[tokenBase], _tokenId.toString(), uriSuffix));
1478         
1479   }
1480 
1481 
1482 
1483 function getMintPrice() public view returns (uint256) {
1484         return cost;    
1485 }
1486 
1487 
1488 //*******************ADMIN AREA********************
1489 
1490   function setSignerAddress(address newSigner) public onlyOwner {
1491       signerAddress = newSigner;
1492   }
1493 
1494   function setRevealed(bool _state) public onlyOwner {
1495     revealed = _state;
1496   }
1497 
1498   function setCost(uint256 _cost) public onlyOwner {
1499     cost = _cost;
1500   }
1501 
1502   function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
1503     maxMintAmount = _maxMintAmount;
1504   }
1505 
1506   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1507     hiddenMetadataUri = _hiddenMetadataUri;
1508   }
1509 
1510   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1511     uriSuffix = _uriSuffix;
1512   }
1513 
1514 
1515     function setSaleStatus(uint256 _status) public onlyOwner {
1516     saleStatus = _status;
1517   }
1518 
1519     function DynamicSupply(uint256 _newSupply) public onlyOwner {
1520         require(_newSupply < maxSupply, "Max supply 10 000");
1521         require(_newSupply > totalSupply(), "New supply must be higher than total supply");
1522         maxSupply = _newSupply;
1523     }
1524 
1525     function setUpgradeEnabled(bool _upgradeEnabled) public onlyOwner {
1526         upgradeEnabled = _upgradeEnabled;
1527     }
1528 
1529   function withdraw() public onlyOwner nonReentrant {
1530 
1531     (bool hs, ) = payable(t1).call{value: address(this).balance * 10 / 100}('');
1532     require(hs);
1533 
1534     (bool vs, ) = payable(t2).call{value: address(this).balance * 50 / 100}('');
1535     require(vs);
1536 
1537     (bool os, ) = payable(t3).call{value: address(this).balance}('');
1538     require(os);
1539   }
1540 
1541   function _baseURI() internal view virtual override returns (string memory) {
1542     uint256 tokenBase = tokenIDbaseID[0];
1543     return  string(abi.encodePacked(baseIDbaseURI[tokenBase]));
1544   }
1545 
1546 
1547 //*****************************SIGNATURE*********************************
1548 
1549 function getMessageHash(address _message) public pure returns(bytes32) 
1550 { 
1551     return keccak256(abi.encodePacked(_message)); 
1552 } 
1553  
1554 function getMessageHashEth(bytes32 _sender) public pure returns(bytes32) 
1555 { 
1556     bytes memory prefix = "\x19Ethereum Signed Message:\n32"; 
1557     return keccak256(abi.encodePacked(prefix,_sender)); 
1558 } 
1559  
1560 function verify(bytes memory _signature, address sender) public view returns(bool) 
1561 { 
1562     bytes32 messageHas = getMessageHash(sender); 
1563     bytes32 messageHashEth = getMessageHashEth(messageHas);     
1564     return recoverSigner(messageHashEth, _signature) == signerAddress; 
1565  
1566 } 
1567  
1568 function recoverSigner(bytes32 _messageHash, bytes memory _signature) public pure returns (address) 
1569 { 
1570     (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature); 
1571     return ecrecover(_messageHash, v ,r, s); 
1572 } 
1573  
1574 function splitSignature(bytes memory _sig) public pure returns (bytes32 r, bytes32 s, uint8 v) 
1575 { 
1576     require(_sig.length == 65, "invalid signature length"); 
1577      
1578     assembly { 
1579         r := mload(add(_sig, 32)) 
1580         s := mload(add(_sig, 64)) 
1581         v := byte(0, mload(add(_sig, 96))) 
1582     } 
1583 } 
1584 
1585 function upgrade(uint256 _tokenID, uint256 _collectionID) public {
1586     require(upgradeEnabled == true, "Upgrade is not enabled yet");
1587     require(ownerOf(_tokenID) == msg.sender, "You are not the owner of NFT");
1588     uint256 tokenOwns = IERC721(collectionIDaddress[_collectionID]).balanceOf(msg.sender); 
1589     require(tokenOwns > 0, 'Only owner...');
1590     tokenIDbaseID[_tokenID] = _collectionID;
1591 }
1592 
1593 function setCollectionID(uint256 _collectionID, address _contractAddress, string memory _baseURL) public onlyOwner {
1594    collectionIDaddress[_collectionID] = _contractAddress;
1595    baseIDbaseURI[_collectionID] = _baseURL;
1596 }
1597 
1598 
1599 }