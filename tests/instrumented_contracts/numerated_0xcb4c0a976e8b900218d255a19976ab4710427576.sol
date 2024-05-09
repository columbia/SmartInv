1 // SPDX-License-Identifier: MIT
2 /*
3 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
4 @@@   @@@@   @@@@@@  @@@@@@@        @@@@@        @@   @@@@@@@  @@          @@@@@@@@@@@@@@@
5 @@@   @@@   @@@@@@  @  @@@@@  @@@@@@  @@@  @@@@@@@@  @  @@@@@  @@  @@@@@@@@@@@@@@@@@@@@@@@
6 @@@   @@   @@@@@@  @@@  @@@@  @@@@@@@  @@  @@@@@@@@  @@  @@@@  @@  @@@@@@@@@@@@@@@@@@@@@@@
7 @@@   @   @@@@@@  @@@@@  @@@  @@@@@@@  @@  @@@@@@@@  @@@  @@@  @@  @@@@@@@@@@@@@@@@@@@@@@@
8 @@@     @@@@@@@  @@@@@@@  @@  @@@@@@  @@@      @@@@  @@@@  @@  @@          @@@@@@@@@@@@@@@
9 @@@   @   @@@@@           @@         @@@@  @@@@@@@@  @@@@@  @  @@@@@@@@@@  @@@@@@@@@@@@@@@
10 @@@   @@   @@@@  @@@@@@@  @@  @@@@  @@@@@  @@@@@@@@  @@@@@@    @@@@@@@@@@  @@@@@@@@@@@@@@@
11 @@@   @@@   @@@  @@@@@@@  @@  @@@@@  @@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@@@  @@@@@@@@@@@@@@@
12 @@@   @@@@   @@  @@@@@@@  @@  @@@@@@  @@@  @@@@@@@@  @@@@@@@@  @@@@@@@@@@  @@@@@@@@@@@@@@@
13 @@@   @@@@@   @  @@@@@@@  @@  @@@@@@@  @@        @@  @@@@@@@@  @@          @@@@@@@@@@@@@@@
14 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 */
16 //Smart contract by ScecarelloGuy
17 
18 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @dev String operations.
24  */
25 library Strings {
26     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
27 
28     /**
29      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
30      */
31     function toString(uint256 value) internal pure returns (string memory) {
32         // Inspired by OraclizeAPI's implementation - MIT licence
33         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
34 
35         if (value == 0) {
36             return "0";
37         }
38         uint256 temp = value;
39         uint256 digits;
40         while (temp != 0) {
41             digits++;
42             temp /= 10;
43         }
44         bytes memory buffer = new bytes(digits);
45         while (value != 0) {
46             digits -= 1;
47             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
48             value /= 10;
49         }
50         return string(buffer);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
55      */
56     function toHexString(uint256 value) internal pure returns (string memory) {
57         if (value == 0) {
58             return "0x00";
59         }
60         uint256 temp = value;
61         uint256 length = 0;
62         while (temp != 0) {
63             length++;
64             temp >>= 8;
65         }
66         return toHexString(value, length);
67     }
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
71      */
72     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
73         bytes memory buffer = new bytes(2 * length + 2);
74         buffer[0] = "0";
75         buffer[1] = "x";
76         for (uint256 i = 2 * length + 1; i > 1; --i) {
77             buffer[i] = _HEX_SYMBOLS[value & 0xf];
78             value >>= 4;
79         }
80         require(value == 0, "Strings: hex length insufficient");
81         return string(buffer);
82     }
83 }
84 
85 // File: @openzeppelin/contracts/utils/Context.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Provides information about the current execution context, including the
94  * sender of the transaction and its data. While these are generally available
95  * via msg.sender and msg.data, they should not be accessed in such a direct
96  * manner, since when dealing with meta-transactions the account sending and
97  * paying for execution may not be the actual sender (as far as an application
98  * is concerned).
99  *
100  * This contract is only required for intermediate, library-like contracts.
101  */
102 abstract contract Context {
103     function _msgSender() internal view virtual returns (address) {
104         return msg.sender;
105     }
106 
107     function _msgData() internal view virtual returns (bytes calldata) {
108         return msg.data;
109     }
110 }
111 
112 // File: @openzeppelin/contracts/access/Ownable.sol
113 
114 
115 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 
120 /**
121  * @dev Contract module which provides a basic access control mechanism, where
122  * there is an account (an owner) that can be granted exclusive access to
123  * specific functions.
124  *
125  * By default, the owner account will be the one that deploys the contract. This
126  * can later be changed with {transferOwnership}.
127  *
128  * This module is used through inheritance. It will make available the modifier
129  * `onlyOwner`, which can be applied to your functions to restrict their use to
130  * the owner.
131  */
132 abstract contract Ownable is Context {
133     address private _owner;
134 
135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
136 
137     /**
138      * @dev Initializes the contract setting the deployer as the initial owner.
139      */
140     constructor() {
141         _transferOwnership(_msgSender());
142     }
143 
144     /**
145      * @dev Returns the address of the current owner.
146      */
147     function owner() public view virtual returns (address) {
148         return _owner;
149     }
150 
151     /**
152      * @dev Throws if called by any account other than the owner.
153      */
154     modifier onlyOwner() {
155         require(owner() == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * NOTE: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public virtual onlyOwner {
167         _transferOwnership(address(0));
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Can only be called by the current owner.
173      */
174     function transferOwnership(address newOwner) public virtual onlyOwner {
175         require(newOwner != address(0), "Ownable: new owner is the zero address");
176         _transferOwnership(newOwner);
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Internal function without access restriction.
182      */
183     function _transferOwnership(address newOwner) internal virtual {
184         address oldOwner = _owner;
185         _owner = newOwner;
186         emit OwnershipTransferred(oldOwner, newOwner);
187     }
188 }
189 
190 // File: @openzeppelin/contracts/utils/Address.sol
191 
192 
193 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @dev Collection of functions related to the address type
199  */
200 library Address {
201     /**
202      * @dev Returns true if `account` is a contract.
203      *
204      * [IMPORTANT]
205      * ====
206      * It is unsafe to assume that an address for which this function returns
207      * false is an externally-owned account (EOA) and not a contract.
208      *
209      * Among others, `isContract` will return false for the following
210      * types of addresses:
211      *
212      *  - an externally-owned account
213      *  - a contract in construction
214      *  - an address where a contract will be created
215      *  - an address where a contract lived, but was destroyed
216      * ====
217      */
218     function isContract(address account) internal view returns (bool) {
219         // This method relies on extcodesize, which returns 0 for contracts in
220         // construction, since the code is only stored at the end of the
221         // constructor execution.
222 
223         uint256 size;
224         assembly {
225             size := extcodesize(account)
226         }
227         return size > 0;
228     }
229 
230     /**
231      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
232      * `recipient`, forwarding all available gas and reverting on errors.
233      *
234      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
235      * of certain opcodes, possibly making contracts go over the 2300 gas limit
236      * imposed by `transfer`, making them unable to receive funds via
237      * `transfer`. {sendValue} removes this limitation.
238      *
239      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
240      *
241      * IMPORTANT: because control is transferred to `recipient`, care must be
242      * taken to not create reentrancy vulnerabilities. Consider using
243      * {ReentrancyGuard} or the
244      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
245      */
246     function sendValue(address payable recipient, uint256 amount) internal {
247         require(address(this).balance >= amount, "Address: insufficient balance");
248 
249         (bool success, ) = recipient.call{value: amount}("");
250         require(success, "Address: unable to send value, recipient may have reverted");
251     }
252 
253     /**
254      * @dev Performs a Solidity function call using a low level `call`. A
255      * plain `call` is an unsafe replacement for a function call: use this
256      * function instead.
257      *
258      * If `target` reverts with a revert reason, it is bubbled up by this
259      * function (like regular Solidity function calls).
260      *
261      * Returns the raw returned data. To convert to the expected return value,
262      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
263      *
264      * Requirements:
265      *
266      * - `target` must be a contract.
267      * - calling `target` with `data` must not revert.
268      *
269      * _Available since v3.1._
270      */
271     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
272         return functionCall(target, data, "Address: low-level call failed");
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
277      * `errorMessage` as a fallback revert reason when `target` reverts.
278      *
279      * _Available since v3.1._
280      */
281     function functionCall(
282         address target,
283         bytes memory data,
284         string memory errorMessage
285     ) internal returns (bytes memory) {
286         return functionCallWithValue(target, data, 0, errorMessage);
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
291      * but also transferring `value` wei to `target`.
292      *
293      * Requirements:
294      *
295      * - the calling contract must have an ETH balance of at least `value`.
296      * - the called Solidity function must be `payable`.
297      *
298      * _Available since v3.1._
299      */
300     function functionCallWithValue(
301         address target,
302         bytes memory data,
303         uint256 value
304     ) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
310      * with `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCallWithValue(
315         address target,
316         bytes memory data,
317         uint256 value,
318         string memory errorMessage
319     ) internal returns (bytes memory) {
320         require(address(this).balance >= value, "Address: insufficient balance for call");
321         require(isContract(target), "Address: call to non-contract");
322 
323         (bool success, bytes memory returndata) = target.call{value: value}(data);
324         return verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but performing a static call.
330      *
331      * _Available since v3.3._
332      */
333     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
334         return functionStaticCall(target, data, "Address: low-level static call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
339      * but performing a static call.
340      *
341      * _Available since v3.3._
342      */
343     function functionStaticCall(
344         address target,
345         bytes memory data,
346         string memory errorMessage
347     ) internal view returns (bytes memory) {
348         require(isContract(target), "Address: static call to non-contract");
349 
350         (bool success, bytes memory returndata) = target.staticcall(data);
351         return verifyCallResult(success, returndata, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but performing a delegate call.
357      *
358      * _Available since v3.4._
359      */
360     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
361         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
366      * but performing a delegate call.
367      *
368      * _Available since v3.4._
369      */
370     function functionDelegateCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(isContract(target), "Address: delegate call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.delegatecall(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
383      * revert reason using the provided one.
384      *
385      * _Available since v4.3._
386      */
387     function verifyCallResult(
388         bool success,
389         bytes memory returndata,
390         string memory errorMessage
391     ) internal pure returns (bytes memory) {
392         if (success) {
393             return returndata;
394         } else {
395             // Look for revert reason and bubble it up if present
396             if (returndata.length > 0) {
397                 // The easiest way to bubble the revert reason is using memory via assembly
398 
399                 assembly {
400                     let returndata_size := mload(returndata)
401                     revert(add(32, returndata), returndata_size)
402                 }
403             } else {
404                 revert(errorMessage);
405             }
406         }
407     }
408 }
409 
410 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
411 
412 
413 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
414 
415 pragma solidity ^0.8.0;
416 
417 /**
418  * @title ERC721 token receiver interface
419  * @dev Interface for any contract that wants to support safeTransfers
420  * from ERC721 asset contracts.
421  */
422 interface IERC721Receiver {
423     /**
424      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
425      * by `operator` from `from`, this function is called.
426      *
427      * It must return its Solidity selector to confirm the token transfer.
428      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
429      *
430      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
431      */
432     function onERC721Received(
433         address operator,
434         address from,
435         uint256 tokenId,
436         bytes calldata data
437     ) external returns (bytes4);
438 }
439 
440 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
441 
442 
443 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
444 
445 pragma solidity ^0.8.0;
446 
447 /**
448  * @dev Interface of the ERC165 standard, as defined in the
449  * https://eips.ethereum.org/EIPS/eip-165[EIP].
450  *
451  * Implementers can declare support of contract interfaces, which can then be
452  * queried by others ({ERC165Checker}).
453  *
454  * For an implementation, see {ERC165}.
455  */
456 interface IERC165 {
457     /**
458      * @dev Returns true if this contract implements the interface defined by
459      * `interfaceId`. See the corresponding
460      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
461      * to learn more about how these ids are created.
462      *
463      * This function call must use less than 30 000 gas.
464      */
465     function supportsInterface(bytes4 interfaceId) external view returns (bool);
466 }
467 
468 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
469 
470 
471 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
472 
473 pragma solidity ^0.8.0;
474 
475 
476 /**
477  * @dev Implementation of the {IERC165} interface.
478  *
479  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
480  * for the additional interface id that will be supported. For example:
481  *
482  * ```solidity
483  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
484  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
485  * }
486  * ```
487  *
488  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
489  */
490 abstract contract ERC165 is IERC165 {
491     /**
492      * @dev See {IERC165-supportsInterface}.
493      */
494     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
495         return interfaceId == type(IERC165).interfaceId;
496     }
497 }
498 
499 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
500 
501 
502 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 
507 /**
508  * @dev Required interface of an ERC721 compliant contract.
509  */
510 interface IERC721 is IERC165 {
511     /**
512      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
513      */
514     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
515 
516     /**
517      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
518      */
519     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
520 
521     /**
522      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
523      */
524     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
525 
526     /**
527      * @dev Returns the number of tokens in ``owner``'s account.
528      */
529     function balanceOf(address owner) external view returns (uint256 balance);
530 
531     /**
532      * @dev Returns the owner of the `tokenId` token.
533      *
534      * Requirements:
535      *
536      * - `tokenId` must exist.
537      */
538     function ownerOf(uint256 tokenId) external view returns (address owner);
539 
540     /**
541      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
542      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
543      *
544      * Requirements:
545      *
546      * - `from` cannot be the zero address.
547      * - `to` cannot be the zero address.
548      * - `tokenId` token must exist and be owned by `from`.
549      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
550      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
551      *
552      * Emits a {Transfer} event.
553      */
554     function safeTransferFrom(
555         address from,
556         address to,
557         uint256 tokenId
558     ) external;
559 
560     /**
561      * @dev Transfers `tokenId` token from `from` to `to`.
562      *
563      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
564      *
565      * Requirements:
566      *
567      * - `from` cannot be the zero address.
568      * - `to` cannot be the zero address.
569      * - `tokenId` token must be owned by `from`.
570      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
571      *
572      * Emits a {Transfer} event.
573      */
574     function transferFrom(
575         address from,
576         address to,
577         uint256 tokenId
578     ) external;
579 
580     /**
581      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
582      * The approval is cleared when the token is transferred.
583      *
584      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
585      *
586      * Requirements:
587      *
588      * - The caller must own the token or be an approved operator.
589      * - `tokenId` must exist.
590      *
591      * Emits an {Approval} event.
592      */
593     function approve(address to, uint256 tokenId) external;
594 
595     /**
596      * @dev Returns the account approved for `tokenId` token.
597      *
598      * Requirements:
599      *
600      * - `tokenId` must exist.
601      */
602     function getApproved(uint256 tokenId) external view returns (address operator);
603 
604     /**
605      * @dev Approve or remove `operator` as an operator for the caller.
606      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
607      *
608      * Requirements:
609      *
610      * - The `operator` cannot be the caller.
611      *
612      * Emits an {ApprovalForAll} event.
613      */
614     function setApprovalForAll(address operator, bool _approved) external;
615 
616     /**
617      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
618      *
619      * See {setApprovalForAll}
620      */
621     function isApprovedForAll(address owner, address operator) external view returns (bool);
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
642 }
643 
644 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
645 
646 
647 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
648 
649 pragma solidity ^0.8.0;
650 
651 
652 /**
653  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
654  * @dev See https://eips.ethereum.org/EIPS/eip-721
655  */
656 interface IERC721Enumerable is IERC721 {
657     /**
658      * @dev Returns the total amount of tokens stored by the contract.
659      */
660     function totalSupply() external view returns (uint256);
661 
662     /**
663      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
664      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
665      */
666     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
667 
668     /**
669      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
670      * Use along with {totalSupply} to enumerate all tokens.
671      */
672     function tokenByIndex(uint256 index) external view returns (uint256);
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 
683 /**
684  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
685  * @dev See https://eips.ethereum.org/EIPS/eip-721
686  */
687 interface IERC721Metadata is IERC721 {
688     /**
689      * @dev Returns the token collection name.
690      */
691     function name() external view returns (string memory);
692 
693     /**
694      * @dev Returns the token collection symbol.
695      */
696     function symbol() external view returns (string memory);
697 
698     /**
699      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
700      */
701     function tokenURI(uint256 tokenId) external view returns (string memory);
702 }
703 
704 // File: contracts/LowerGas.sol
705 
706 
707 // Creator: Chiru Labs
708 
709 
710 pragma solidity ^0.8.0;
711 
712 /**
713  * @dev These functions deal with verification of Merkle Trees proofs.
714  *
715  * The proofs can be generated using the JavaScript library
716  * https://github.com/miguelmota/merkletreejs[merkletreejs].
717  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
718  *
719  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
720  */
721 library MerkleProof {
722     /**
723      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
724      * defined by `root`. For this, a `proof` must be provided, containing
725      * sibling hashes on the branch from the leaf to the root of the tree. Each
726      * pair of leaves and each pair of pre-images are assumed to be sorted.
727      */
728     function verify(
729         bytes32[] memory proof,
730         bytes32 root,
731         bytes32 leaf
732     ) internal pure returns (bool) {
733         return processProof(proof, leaf) == root;
734     }
735 
736     /**
737      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
738      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
739      * hash matches the root of the tree. When processing the proof, the pairs
740      * of leafs & pre-images are assumed to be sorted.
741      *
742      * _Available since v4.4._
743      */
744     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
745         bytes32 computedHash = leaf;
746         for (uint256 i = 0; i < proof.length; i++) {
747             bytes32 proofElement = proof[i];
748             if (computedHash <= proofElement) {
749                 // Hash(current computed hash + current element of the proof)
750                 computedHash = _efficientHash(computedHash, proofElement);
751             } else {
752                 // Hash(current element of the proof + current computed hash)
753                 computedHash = _efficientHash(proofElement, computedHash);
754             }
755         }
756         return computedHash;
757     }
758 
759     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
760         assembly {
761             mstore(0x00, a)
762             mstore(0x20, b)
763             value := keccak256(0x00, 0x40)
764         }
765     }
766 }
767 
768 pragma solidity ^0.8.0;
769 
770 
771 
772 
773 
774 
775 
776 
777 
778 
779 /**
780  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
781  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
782  *
783  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
784  *
785  * Does not support burning tokens to address(0).
786  *
787  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
788  */
789 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
790     using Address for address;
791     using Strings for uint256;
792 
793     struct TokenOwnership {
794         address addr;
795         uint64 startTimestamp;
796     }
797 
798     struct AddressData {
799         uint128 balance;
800         uint128 numberMinted;
801     }
802 
803     uint256 internal currentIndex = 0;
804 
805     uint256 internal immutable maxBatchSize;
806 
807     // Token name
808     string private _name;
809 
810     // Token symbol
811     string private _symbol;
812 
813     // Mapping from token ID to ownership details
814     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
815     mapping(uint256 => TokenOwnership) internal _ownerships;
816 
817     // Mapping owner address to address data
818     mapping(address => AddressData) private _addressData;
819 
820     // Mapping from token ID to approved address
821     mapping(uint256 => address) private _tokenApprovals;
822 
823     // Mapping from owner to operator approvals
824     mapping(address => mapping(address => bool)) private _operatorApprovals;
825 
826     /**
827      * @dev
828      * `maxBatchSize` refers to how much a minter can mint at a time.
829      */
830     constructor(
831         string memory name_,
832         string memory symbol_,
833         uint256 maxBatchSize_
834     ) {
835         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
836         _name = name_;
837         _symbol = symbol_;
838         maxBatchSize = maxBatchSize_;
839     }
840 
841     /**
842      * @dev See {IERC721Enumerable-totalSupply}.
843      */
844     function totalSupply() public view override returns (uint256) {
845         return currentIndex;
846     }
847 
848     /**
849      * @dev See {IERC721Enumerable-tokenByIndex}.
850      */
851     function tokenByIndex(uint256 index) public view override returns (uint256) {
852         require(index < totalSupply(), 'ERC721A: global index out of bounds');
853         return index;
854     }
855 
856     /**
857      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
858      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
859      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
860      */
861     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
862         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
863         uint256 numMintedSoFar = totalSupply();
864         uint256 tokenIdsIdx = 0;
865         address currOwnershipAddr = address(0);
866         for (uint256 i = 0; i < numMintedSoFar; i++) {
867             TokenOwnership memory ownership = _ownerships[i];
868             if (ownership.addr != address(0)) {
869                 currOwnershipAddr = ownership.addr;
870             }
871             if (currOwnershipAddr == owner) {
872                 if (tokenIdsIdx == index) {
873                     return i;
874                 }
875                 tokenIdsIdx++;
876             }
877         }
878         revert('ERC721A: unable to get token of owner by index');
879     }
880 
881     /**
882      * @dev See {IERC165-supportsInterface}.
883      */
884     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
885         return
886             interfaceId == type(IERC721).interfaceId ||
887             interfaceId == type(IERC721Metadata).interfaceId ||
888             interfaceId == type(IERC721Enumerable).interfaceId ||
889             super.supportsInterface(interfaceId);
890     }
891 
892     /**
893      * @dev See {IERC721-balanceOf}.
894      */
895     function balanceOf(address owner) public view override returns (uint256) {
896         require(owner != address(0), 'ERC721A: balance query for the zero address');
897         return uint256(_addressData[owner].balance);
898     }
899 
900     function _numberMinted(address owner) internal view returns (uint256) {
901         require(owner != address(0), 'ERC721A: number minted query for the zero address');
902         return uint256(_addressData[owner].numberMinted);
903     }
904 
905     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
906         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
907 
908         uint256 lowestTokenToCheck;
909         if (tokenId >= maxBatchSize) {
910             lowestTokenToCheck = tokenId - maxBatchSize + 1;
911         }
912 
913         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
914             TokenOwnership memory ownership = _ownerships[curr];
915             if (ownership.addr != address(0)) {
916                 return ownership;
917             }
918         }
919 
920         revert('ERC721A: unable to determine the owner of token');
921     }
922 
923     /**
924      * @dev See {IERC721-ownerOf}.
925      */
926     function ownerOf(uint256 tokenId) public view override returns (address) {
927         return ownershipOf(tokenId).addr;
928     }
929 
930     /**
931      * @dev See {IERC721Metadata-name}.
932      */
933     function name() public view virtual override returns (string memory) {
934         return _name;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-symbol}.
939      */
940     function symbol() public view virtual override returns (string memory) {
941         return _symbol;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-tokenURI}.
946      */
947     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
948         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
949 
950         string memory baseURI = _baseURI();
951         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
952     }
953 
954     /**
955      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
956      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
957      * by default, can be overriden in child contracts.
958      */
959     function _baseURI() internal view virtual returns (string memory) {
960         return '';
961     }
962 
963     /**
964      * @dev See {IERC721-approve}.
965      */
966     function approve(address to, uint256 tokenId) public override {
967         address owner = ERC721A.ownerOf(tokenId);
968         require(to != owner, 'ERC721A: approval to current owner');
969 
970         require(
971             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
972             'ERC721A: approve caller is not owner nor approved for all'
973         );
974 
975         _approve(to, tokenId, owner);
976     }
977 
978     /**
979      * @dev See {IERC721-getApproved}.
980      */
981     function getApproved(uint256 tokenId) public view override returns (address) {
982         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
983 
984         return _tokenApprovals[tokenId];
985     }
986 
987     /**
988      * @dev See {IERC721-setApprovalForAll}.
989      */
990     function setApprovalForAll(address operator, bool approved) public override {
991         require(operator != _msgSender(), 'ERC721A: approve to caller');
992 
993         _operatorApprovals[_msgSender()][operator] = approved;
994         emit ApprovalForAll(_msgSender(), operator, approved);
995     }
996 
997     /**
998      * @dev See {IERC721-isApprovedForAll}.
999      */
1000     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1001         return _operatorApprovals[owner][operator];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-transferFrom}.
1006      */
1007     function transferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) public override {
1012         _transfer(from, to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-safeTransferFrom}.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) public override {
1023         safeTransferFrom(from, to, tokenId, '');
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-safeTransferFrom}.
1028      */
1029     function safeTransferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId,
1033         bytes memory _data
1034     ) public override {
1035         _transfer(from, to, tokenId);
1036         require(
1037             _checkOnERC721Received(from, to, tokenId, _data),
1038             'ERC721A: transfer to non ERC721Receiver implementer'
1039         );
1040     }
1041 
1042     /**
1043      * @dev Returns whether `tokenId` exists.
1044      *
1045      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1046      *
1047      * Tokens start existing when they are minted (`_mint`),
1048      */
1049     function _exists(uint256 tokenId) internal view returns (bool) {
1050         return tokenId < currentIndex;
1051     }
1052 
1053     function _safeMint(address to, uint256 quantity) internal {
1054         _safeMint(to, quantity, '');
1055     }
1056 
1057     /**
1058      * @dev Mints `quantity` tokens and transfers them to `to`.
1059      *
1060      * Requirements:
1061      *
1062      * - `to` cannot be the zero address.
1063      * - `quantity` cannot be larger than the max batch size.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _safeMint(
1068         address to,
1069         uint256 quantity,
1070         bytes memory _data
1071     ) internal {
1072         uint256 startTokenId = currentIndex;
1073         require(to != address(0), 'ERC721A: mint to the zero address');
1074         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1075         require(!_exists(startTokenId), 'ERC721A: token already minted');
1076         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
1077         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1078 
1079         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1080 
1081         AddressData memory addressData = _addressData[to];
1082         _addressData[to] = AddressData(
1083             addressData.balance + uint128(quantity),
1084             addressData.numberMinted + uint128(quantity)
1085         );
1086         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1087 
1088         uint256 updatedIndex = startTokenId;
1089 
1090         for (uint256 i = 0; i < quantity; i++) {
1091             emit Transfer(address(0), to, updatedIndex);
1092             require(
1093                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1094                 'ERC721A: transfer to non ERC721Receiver implementer'
1095             );
1096             updatedIndex++;
1097         }
1098 
1099         currentIndex = updatedIndex;
1100         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1101     }
1102 
1103     /**
1104      * @dev Transfers `tokenId` from `from` to `to`.
1105      *
1106      * Requirements:
1107      *
1108      * - `to` cannot be the zero address.
1109      * - `tokenId` token must be owned by `from`.
1110      *
1111      * Emits a {Transfer} event.
1112      */
1113     function _transfer(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) private {
1118         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1119 
1120         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1121             getApproved(tokenId) == _msgSender() ||
1122             isApprovedForAll(prevOwnership.addr, _msgSender()));
1123 
1124         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1125 
1126         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1127         require(to != address(0), 'ERC721A: transfer to the zero address');
1128 
1129         _beforeTokenTransfers(from, to, tokenId, 1);
1130 
1131         // Clear approvals from the previous owner
1132         _approve(address(0), tokenId, prevOwnership.addr);
1133 
1134         // Underflow of the sender's balance is impossible because we check for
1135         // ownership above and the recipient's balance can't realistically overflow.
1136         unchecked {
1137             _addressData[from].balance -= 1;
1138             _addressData[to].balance += 1;
1139         }
1140 
1141         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1142 
1143         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1144         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1145         uint256 nextTokenId = tokenId + 1;
1146         if (_ownerships[nextTokenId].addr == address(0)) {
1147             if (_exists(nextTokenId)) {
1148                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1149             }
1150         }
1151 
1152         emit Transfer(from, to, tokenId);
1153         _afterTokenTransfers(from, to, tokenId, 1);
1154     }
1155 
1156     /**
1157      * @dev Approve `to` to operate on `tokenId`
1158      *
1159      * Emits a {Approval} event.
1160      */
1161     function _approve(
1162         address to,
1163         uint256 tokenId,
1164         address owner
1165     ) private {
1166         _tokenApprovals[tokenId] = to;
1167         emit Approval(owner, to, tokenId);
1168     }
1169 
1170     /**
1171      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1172      * The call is not executed if the target address is not a contract.
1173      *
1174      * @param from address representing the previous owner of the given token ID
1175      * @param to target address that will receive the tokens
1176      * @param tokenId uint256 ID of the token to be transferred
1177      * @param _data bytes optional data to send along with the call
1178      * @return bool whether the call correctly returned the expected magic value
1179      */
1180     function _checkOnERC721Received(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) private returns (bool) {
1186         if (to.isContract()) {
1187             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1188                 return retval == IERC721Receiver(to).onERC721Received.selector;
1189             } catch (bytes memory reason) {
1190                 if (reason.length == 0) {
1191                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1192                 } else {
1193                     assembly {
1194                         revert(add(32, reason), mload(reason))
1195                     }
1196                 }
1197             }
1198         } else {
1199             return true;
1200         }
1201     }
1202 
1203     /**
1204      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1205      *
1206      * startTokenId - the first token id to be transferred
1207      * quantity - the amount to be transferred
1208      *
1209      * Calling conditions:
1210      *
1211      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1212      * transferred to `to`.
1213      * - When `from` is zero, `tokenId` will be minted for `to`.
1214      */
1215     function _beforeTokenTransfers(
1216         address from,
1217         address to,
1218         uint256 startTokenId,
1219         uint256 quantity
1220     ) internal virtual {}
1221 
1222     /**
1223      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1224      * minting.
1225      *
1226      * startTokenId - the first token id to be transferred
1227      * quantity - the amount to be transferred
1228      *
1229      * Calling conditions:
1230      *
1231      * - when `from` and `to` are both non-zero.
1232      * - `from` and `to` are never both zero.
1233      */
1234     function _afterTokenTransfers(
1235         address from,
1236         address to,
1237         uint256 startTokenId,
1238         uint256 quantity
1239     ) internal virtual {}
1240 }
1241 
1242 interface HolderC {
1243     
1244     function balanceOf(address owner) external view returns (uint256 balance);
1245 }
1246 
1247 pragma solidity ^0.8.0;
1248 
1249 contract LarvaKarens is ERC721A, Ownable {
1250   using Strings for uint256;
1251 
1252   string private uriPrefix = "";
1253   string private uriSuffix = ".json";
1254   string public hiddenMetadataUri;
1255   
1256   uint256 public price = 0.0169 ether; 
1257   uint256 public maxSupply = 5001; 
1258   uint256 public maxMintAmountPerTx = 50; 
1259   uint256 public nftPerAddressLimitWl = 20; 
1260   
1261 
1262   bool public paused = true;
1263   bool public revealed = true;
1264   bool public onlyWhitelisted = false;
1265 
1266   bytes32 public whitelistMerkleRoot;
1267   mapping(address => uint256) public addressMintedBalance;
1268 
1269   HolderC public holderc;
1270 
1271   constructor() ERC721A("LarvaKarens", "KAREN", maxMintAmountPerTx) {
1272     setHiddenMetadataUri("");
1273   }
1274 
1275   /**
1276     * @dev validates merkleProof
1277     */
1278   modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1279     require(
1280         MerkleProof.verify(
1281             merkleProof,
1282             root,
1283             keccak256(abi.encodePacked(msg.sender))
1284         ),
1285         "Address does not exist in list"
1286     );
1287     _;
1288   }
1289 
1290   modifier mintCompliance(uint256 _mintAmount) {
1291     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1292     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1293     _;
1294   }
1295 
1296 
1297   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1298    {
1299     require(!paused, "The contract is paused!");
1300     require(!onlyWhitelisted, "Presale is on");
1301     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1302 
1303     _safeMint(msg.sender, _mintAmount);
1304   }
1305 
1306   function mintHolder(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1307     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1308     require(!paused, "The contract is paused!");
1309     require(onlyWhitelisted, "Presale has ended");
1310     require(holderc.balanceOf(msg.sender) > 0 , "you are not a holder");
1311     require(ownerMintedCount + _mintAmount <= nftPerAddressLimitWl, "max NFT per address exceeded");
1312     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1313 
1314     addressMintedBalance[msg.sender]+=_mintAmount;
1315     _safeMint(msg.sender, _mintAmount);
1316   }
1317 
1318   function mintWhitelist(bytes32[] calldata merkleProof, uint256 _mintAmount) public payable isValidMerkleProof(merkleProof, whitelistMerkleRoot){
1319     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1320     
1321     require(!paused, "The contract is paused!");
1322     require(onlyWhitelisted, "Presale has ended");
1323     require(ownerMintedCount + _mintAmount <= nftPerAddressLimitWl, "max NFT per address exceeded");
1324     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1325     
1326     addressMintedBalance[msg.sender]+=_mintAmount;
1327     
1328     _safeMint(msg.sender, _mintAmount);
1329   }
1330   
1331   function NftToAddress(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1332     _safeMint(_to, _mintAmount);
1333   }
1334 
1335  
1336   function walletOfOwner(address _owner)
1337     public
1338     view
1339     returns (uint256[] memory)
1340   {
1341     uint256 ownerTokenCount = balanceOf(_owner);
1342     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1343     uint256 currentTokenId = 0;
1344     uint256 ownedTokenIndex = 0;
1345 
1346     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1347       address currentTokenOwner = ownerOf(currentTokenId);
1348 
1349       if (currentTokenOwner == _owner) {
1350         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1351 
1352         ownedTokenIndex++;
1353       }
1354 
1355       currentTokenId++;
1356     }
1357 
1358     return ownedTokenIds;
1359   }
1360 
1361   function tokenURI(uint256 _tokenId)
1362     public
1363     view
1364     virtual
1365     override
1366     returns (string memory)
1367   {
1368     require(
1369       _exists(_tokenId),
1370       "ERC721Metadata: URI query for nonexistent token"
1371     );
1372 
1373     if (revealed == false) {
1374       return hiddenMetadataUri;
1375     }
1376 
1377     string memory currentBaseURI = _baseURI();
1378     return bytes(currentBaseURI).length > 0
1379         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1380         : "";
1381   }
1382 
1383   function setRevealed(bool _state) public onlyOwner {
1384     revealed = _state;
1385   }
1386 
1387   function setWhitelistMerkleRoot(bytes32 merkleRoot) external onlyOwner {
1388     whitelistMerkleRoot = merkleRoot;
1389   }
1390 
1391   function setOnlyWhitelisted(bool _state) public onlyOwner {
1392     onlyWhitelisted = _state;
1393   }
1394 
1395   function setPrice(uint256 _price) public onlyOwner {
1396     price = _price;
1397 
1398   }
1399 
1400   function setHolderC(address _address) public {
1401     holderc = HolderC(_address);
1402   }
1403 
1404   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1405     hiddenMetadataUri = _hiddenMetadataUri;
1406   }
1407 
1408   function setNftPerAddressLimitWl(uint256 _limit) public onlyOwner {
1409     nftPerAddressLimitWl = _limit;
1410   }
1411 
1412   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1413     uriPrefix = _uriPrefix;
1414   }
1415 
1416   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1417     uriSuffix = _uriSuffix;
1418   }
1419 
1420   function setPaused(bool _state) public onlyOwner {
1421     paused = _state;
1422   }
1423 
1424   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1425       _safeMint(_receiver, _mintAmount);
1426   }
1427 
1428   function _baseURI() internal view virtual override returns (string memory) {
1429     return uriPrefix;
1430     
1431   }
1432 
1433     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1434     maxMintAmountPerTx = _maxMintAmountPerTx;
1435 
1436   }
1437 
1438     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1439     maxSupply = _maxSupply;
1440 
1441   }
1442 
1443   // withdrawall addresses
1444   address t1 = 0x9191c1F39Be40bbA3B4d57c023da85A500a02DDb; //SheepLedger
1445   address t2 = 0x9e9E6D6aC9E59410E4AbAbB13475C5d54e5356ad; //VitoLedger
1446   address t3 = 0x251216Dd3473EA5fCdBaFFd0dD0826017F8E1B24; //Banana
1447   address t4 = 0xed124a7fAf7a6B54741EDADc6BE7D1E60C76787d; //Rice
1448   address t5 = 0xA05e5B6B5199735e157bCCa08f3CA680cACC4764; //Tuna
1449   address t6 = 0x1B65a9816EF95229ACC3384E67956A7dFaB2b87c; //Chads Treasury
1450   address t7 = 0x422605D2f4Ac07b2e8Ee9E09045B64947cDEC17D; //DBDAO
1451 
1452   function withdrawall() public onlyOwner {
1453         uint256 _balance = address(this).balance;
1454         
1455 
1456         require(payable(t1).send(_balance * 22 / 100 ));
1457         require(payable(t2).send(_balance * 22 / 100 ));
1458         require(payable(t3).send(_balance * 22 / 100 ));
1459         require(payable(t4).send(_balance * 11 / 100 ));
1460         require(payable(t5).send(_balance * 11 / 100 ));
1461         require(payable(t6).send(_balance * 7 / 100 ));
1462         require(payable(t7).send(_balance * 5 / 100 ));
1463   }
1464 }