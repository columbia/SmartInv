1 // SPDX-License-Identifier: MIT
2 // notBanksy
3 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
4 // 1974 Nfts
5 // Free mint
6 // Max 2 x Transaction
7 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
8 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
9 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
10 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
11 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
12 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
13 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
14 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
15 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
16 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
17 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
18 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
19 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
20 // Freedom - Girl under an umbrella Freedom - Girl under an umbrella Freedom - Girl under an umbrella
21 
22 
23 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev String operations.
29  */
30 library Strings {
31     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
35      */
36     function toString(uint256 value) internal pure returns (string memory) {
37         // Inspired by OraclizeAPI's implementation - MIT licence
38         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
39 
40         if (value == 0) {
41             return "0";
42         }
43         uint256 temp = value;
44         uint256 digits;
45         while (temp != 0) {
46             digits++;
47             temp /= 10;
48         }
49         bytes memory buffer = new bytes(digits);
50         while (value != 0) {
51             digits -= 1;
52             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
53             value /= 10;
54         }
55         return string(buffer);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
60      */
61     function toHexString(uint256 value) internal pure returns (string memory) {
62         if (value == 0) {
63             return "0x00";
64         }
65         uint256 temp = value;
66         uint256 length = 0;
67         while (temp != 0) {
68             length++;
69             temp >>= 8;
70         }
71         return toHexString(value, length);
72     }
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
76      */
77     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
78         bytes memory buffer = new bytes(2 * length + 2);
79         buffer[0] = "0";
80         buffer[1] = "x";
81         for (uint256 i = 2 * length + 1; i > 1; --i) {
82             buffer[i] = _HEX_SYMBOLS[value & 0xf];
83             value >>= 4;
84         }
85         require(value == 0, "Strings: hex length insufficient");
86         return string(buffer);
87     }
88 }
89 
90 // File: @openzeppelin/contracts/utils/Context.sol
91 
92 
93 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Provides information about the current execution context, including the
99  * sender of the transaction and its data. While these are generally available
100  * via msg.sender and msg.data, they should not be accessed in such a direct
101  * manner, since when dealing with meta-transactions the account sending and
102  * paying for execution may not be the actual sender (as far as an application
103  * is concerned).
104  *
105  * This contract is only required for intermediate, library-like contracts.
106  */
107 abstract contract Context {
108     function _msgSender() internal view virtual returns (address) {
109         return msg.sender;
110     }
111 
112     function _msgData() internal view virtual returns (bytes calldata) {
113         return msg.data;
114     }
115 }
116 
117 // File: @openzeppelin/contracts/access/Ownable.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * By default, the owner account will be the one that deploys the contract. This
131  * can later be changed with {transferOwnership}.
132  *
133  * This module is used through inheritance. It will make available the modifier
134  * `onlyOwner`, which can be applied to your functions to restrict their use to
135  * the owner.
136  */
137 abstract contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     /**
143      * @dev Initializes the contract setting the deployer as the initial owner.
144      */
145     constructor() {
146         _transferOwnership(_msgSender());
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view virtual returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if called by any account other than the owner.
158      */
159     modifier onlyOwner() {
160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163 
164     /**
165      * @dev Leaves the contract without owner. It will not be possible to call
166      * `onlyOwner` functions anymore. Can only be called by the current owner.
167      *
168      * NOTE: Renouncing ownership will leave the contract without an owner,
169      * thereby removing any functionality that is only available to the owner.
170      */
171     function renounceOwnership() public virtual onlyOwner {
172         _transferOwnership(address(0));
173     }
174 
175     /**
176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
177      * Can only be called by the current owner.
178      */
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         _transferOwnership(newOwner);
182     }
183 
184     /**
185      * @dev Transfers ownership of the contract to a new account (`newOwner`).
186      * Internal function without access restriction.
187      */
188     function _transferOwnership(address newOwner) internal virtual {
189         address oldOwner = _owner;
190         _owner = newOwner;
191         emit OwnershipTransferred(oldOwner, newOwner);
192     }
193 }
194 
195 // File: @openzeppelin/contracts/utils/Address.sol
196 
197 
198 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
199 
200 pragma solidity ^0.8.0;
201 
202 /**
203  * @dev Collection of functions related to the address type
204  */
205 library Address {
206     /**
207      * @dev Returns true if `account` is a contract.
208      *
209      * [IMPORTANT]
210      * ====
211      * It is unsafe to assume that an address for which this function returns
212      * false is an externally-owned account (EOA) and not a contract.
213      *
214      * Among others, `isContract` will return false for the following
215      * types of addresses:
216      *
217      *  - an externally-owned account
218      *  - a contract in construction
219      *  - an address where a contract will be created
220      *  - an address where a contract lived, but was destroyed
221      * ====
222      */
223     function isContract(address account) internal view returns (bool) {
224         // This method relies on extcodesize, which returns 0 for contracts in
225         // construction, since the code is only stored at the end of the
226         // constructor execution.
227 
228         uint256 size;
229         assembly {
230             size := extcodesize(account)
231         }
232         return size > 0;
233     }
234 
235     /**
236      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
237      * `recipient`, forwarding all available gas and reverting on errors.
238      *
239      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
240      * of certain opcodes, possibly making contracts go over the 2300 gas limit
241      * imposed by `transfer`, making them unable to receive funds via
242      * `transfer`. {sendValue} removes this limitation.
243      *
244      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
245      *
246      * IMPORTANT: because control is transferred to `recipient`, care must be
247      * taken to not create reentrancy vulnerabilities. Consider using
248      * {ReentrancyGuard} or the
249      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
250      */
251     function sendValue(address payable recipient, uint256 amount) internal {
252         require(address(this).balance >= amount, "Address: insufficient balance");
253 
254         (bool success, ) = recipient.call{value: amount}("");
255         require(success, "Address: unable to send value, recipient may have reverted");
256     }
257 
258     /**
259      * @dev Performs a Solidity function call using a low level `call`. A
260      * plain `call` is an unsafe replacement for a function call: use this
261      * function instead.
262      *
263      * If `target` reverts with a revert reason, it is bubbled up by this
264      * function (like regular Solidity function calls).
265      *
266      * Returns the raw returned data. To convert to the expected return value,
267      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
268      *
269      * Requirements:
270      *
271      * - `target` must be a contract.
272      * - calling `target` with `data` must not revert.
273      *
274      * _Available since v3.1._
275      */
276     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
277         return functionCall(target, data, "Address: low-level call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
282      * `errorMessage` as a fallback revert reason when `target` reverts.
283      *
284      * _Available since v3.1._
285      */
286     function functionCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, 0, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but also transferring `value` wei to `target`.
297      *
298      * Requirements:
299      *
300      * - the calling contract must have an ETH balance of at least `value`.
301      * - the called Solidity function must be `payable`.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
315      * with `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCallWithValue(
320         address target,
321         bytes memory data,
322         uint256 value,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         require(address(this).balance >= value, "Address: insufficient balance for call");
326         require(isContract(target), "Address: call to non-contract");
327 
328         (bool success, bytes memory returndata) = target.call{value: value}(data);
329         return verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
339         return functionStaticCall(target, data, "Address: low-level static call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a static call.
345      *
346      * _Available since v3.3._
347      */
348     function functionStaticCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal view returns (bytes memory) {
353         require(isContract(target), "Address: static call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.staticcall(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a delegate call.
362      *
363      * _Available since v3.4._
364      */
365     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
366         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a delegate call.
372      *
373      * _Available since v3.4._
374      */
375     function functionDelegateCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         require(isContract(target), "Address: delegate call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.delegatecall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
388      * revert reason using the provided one.
389      *
390      * _Available since v4.3._
391      */
392     function verifyCallResult(
393         bool success,
394         bytes memory returndata,
395         string memory errorMessage
396     ) internal pure returns (bytes memory) {
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403 
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
416 
417 
418 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @title ERC721 token receiver interface
424  * @dev Interface for any contract that wants to support safeTransfers
425  * from ERC721 asset contracts.
426  */
427 interface IERC721Receiver {
428     /**
429      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
430      * by `operator` from `from`, this function is called.
431      *
432      * It must return its Solidity selector to confirm the token transfer.
433      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
434      *
435      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
436      */
437     function onERC721Received(
438         address operator,
439         address from,
440         uint256 tokenId,
441         bytes calldata data
442     ) external returns (bytes4);
443 }
444 
445 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
446 
447 
448 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
449 
450 pragma solidity ^0.8.0;
451 
452 /**
453  * @dev Interface of the ERC165 standard, as defined in the
454  * https://eips.ethereum.org/EIPS/eip-165[EIP].
455  *
456  * Implementers can declare support of contract interfaces, which can then be
457  * queried by others ({ERC165Checker}).
458  *
459  * For an implementation, see {ERC165}.
460  */
461 interface IERC165 {
462     /**
463      * @dev Returns true if this contract implements the interface defined by
464      * `interfaceId`. See the corresponding
465      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
466      * to learn more about how these ids are created.
467      *
468      * This function call must use less than 30 000 gas.
469      */
470     function supportsInterface(bytes4 interfaceId) external view returns (bool);
471 }
472 
473 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 
481 /**
482  * @dev Implementation of the {IERC165} interface.
483  *
484  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
485  * for the additional interface id that will be supported. For example:
486  *
487  * ```solidity
488  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
490  * }
491  * ```
492  *
493  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
494  */
495 abstract contract ERC165 is IERC165 {
496     /**
497      * @dev See {IERC165-supportsInterface}.
498      */
499     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
500         return interfaceId == type(IERC165).interfaceId;
501     }
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @dev Required interface of an ERC721 compliant contract.
514  */
515 interface IERC721 is IERC165 {
516     /**
517      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
518      */
519     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
520 
521     /**
522      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
523      */
524     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
525 
526     /**
527      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
528      */
529     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
530 
531     /**
532      * @dev Returns the number of tokens in ``owner``'s account.
533      */
534     function balanceOf(address owner) external view returns (uint256 balance);
535 
536     /**
537      * @dev Returns the owner of the `tokenId` token.
538      *
539      * Requirements:
540      *
541      * - `tokenId` must exist.
542      */
543     function ownerOf(uint256 tokenId) external view returns (address owner);
544 
545     /**
546      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
547      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
548      *
549      * Requirements:
550      *
551      * - `from` cannot be the zero address.
552      * - `to` cannot be the zero address.
553      * - `tokenId` token must exist and be owned by `from`.
554      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
555      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
556      *
557      * Emits a {Transfer} event.
558      */
559     function safeTransferFrom(
560         address from,
561         address to,
562         uint256 tokenId
563     ) external;
564 
565     /**
566      * @dev Transfers `tokenId` token from `from` to `to`.
567      *
568      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
569      *
570      * Requirements:
571      *
572      * - `from` cannot be the zero address.
573      * - `to` cannot be the zero address.
574      * - `tokenId` token must be owned by `from`.
575      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
576      *
577      * Emits a {Transfer} event.
578      */
579     function transferFrom(
580         address from,
581         address to,
582         uint256 tokenId
583     ) external;
584 
585     /**
586      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
587      * The approval is cleared when the token is transferred.
588      *
589      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
590      *
591      * Requirements:
592      *
593      * - The caller must own the token or be an approved operator.
594      * - `tokenId` must exist.
595      *
596      * Emits an {Approval} event.
597      */
598     function approve(address to, uint256 tokenId) external;
599 
600     /**
601      * @dev Returns the account approved for `tokenId` token.
602      *
603      * Requirements:
604      *
605      * - `tokenId` must exist.
606      */
607     function getApproved(uint256 tokenId) external view returns (address operator);
608 
609     /**
610      * @dev Approve or remove `operator` as an operator for the caller.
611      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
612      *
613      * Requirements:
614      *
615      * - The `operator` cannot be the caller.
616      *
617      * Emits an {ApprovalForAll} event.
618      */
619     function setApprovalForAll(address operator, bool _approved) external;
620 
621     /**
622      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
623      *
624      * See {setApprovalForAll}
625      */
626     function isApprovedForAll(address owner, address operator) external view returns (bool);
627 
628     /**
629      * @dev Safely transfers `tokenId` token from `from` to `to`.
630      *
631      * Requirements:
632      *
633      * - `from` cannot be the zero address.
634      * - `to` cannot be the zero address.
635      * - `tokenId` token must exist and be owned by `from`.
636      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
637      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
638      *
639      * Emits a {Transfer} event.
640      */
641     function safeTransferFrom(
642         address from,
643         address to,
644         uint256 tokenId,
645         bytes calldata data
646     ) external;
647 }
648 
649 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
650 
651 
652 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
653 
654 pragma solidity ^0.8.0;
655 
656 
657 /**
658  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
659  * @dev See https://eips.ethereum.org/EIPS/eip-721
660  */
661 interface IERC721Enumerable is IERC721 {
662     /**
663      * @dev Returns the total amount of tokens stored by the contract.
664      */
665     function totalSupply() external view returns (uint256);
666 
667     /**
668      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
669      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
670      */
671     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
672 
673     /**
674      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
675      * Use along with {totalSupply} to enumerate all tokens.
676      */
677     function tokenByIndex(uint256 index) external view returns (uint256);
678 }
679 
680 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
681 
682 
683 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 
688 /**
689  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
690  * @dev See https://eips.ethereum.org/EIPS/eip-721
691  */
692 interface IERC721Metadata is IERC721 {
693     /**
694      * @dev Returns the token collection name.
695      */
696     function name() external view returns (string memory);
697 
698     /**
699      * @dev Returns the token collection symbol.
700      */
701     function symbol() external view returns (string memory);
702 
703     /**
704      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
705      */
706     function tokenURI(uint256 tokenId) external view returns (string memory);
707 }
708 
709 
710 pragma solidity ^0.8.0;
711 
712 
713 /**
714  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
715  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
716  *
717  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
718  *
719  * Does not support burning tokens to address(0).
720  *
721  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
722  */
723 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
724     using Address for address;
725     using Strings for uint256;
726 
727     struct TokenOwnership {
728         address addr;
729         uint64 startTimestamp;
730     }
731 
732     struct AddressData {
733         uint128 balance;
734         uint128 numberMinted;
735     }
736 
737     uint256 internal currentIndex = 0;
738 
739     uint256 internal immutable maxBatchSize;
740 
741     // Token name
742     string private _name;
743 
744     // Token symbol
745     string private _symbol;
746 
747     // Mapping from token ID to ownership details
748     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
749     mapping(uint256 => TokenOwnership) internal _ownerships;
750 
751     // Mapping owner address to address data
752     mapping(address => AddressData) private _addressData;
753 
754     // Mapping from token ID to approved address
755     mapping(uint256 => address) private _tokenApprovals;
756 
757     // Mapping from owner to operator approvals
758     mapping(address => mapping(address => bool)) private _operatorApprovals;
759 
760     /**
761      * @dev
762      * `maxBatchSize` refers to how much a minter can mint at a time.
763      */
764     constructor(
765         string memory name_,
766         string memory symbol_,
767         uint256 maxBatchSize_
768     ) {
769         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
770         _name = name_;
771         _symbol = symbol_;
772         maxBatchSize = maxBatchSize_;
773     }
774 
775     /**
776      * @dev See {IERC721Enumerable-totalSupply}.
777      */
778     function totalSupply() public view override returns (uint256) {
779         return currentIndex;
780     }
781 
782     /**
783      * @dev See {IERC721Enumerable-tokenByIndex}.
784      */
785     function tokenByIndex(uint256 index) public view override returns (uint256) {
786         require(index < totalSupply(), 'ERC721A: global index out of bounds');
787         return index;
788     }
789 
790     /**
791      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
792      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
793      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
794      */
795     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
796         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
797         uint256 numMintedSoFar = totalSupply();
798         uint256 tokenIdsIdx = 0;
799         address currOwnershipAddr = address(0);
800         for (uint256 i = 0; i < numMintedSoFar; i++) {
801             TokenOwnership memory ownership = _ownerships[i];
802             if (ownership.addr != address(0)) {
803                 currOwnershipAddr = ownership.addr;
804             }
805             if (currOwnershipAddr == owner) {
806                 if (tokenIdsIdx == index) {
807                     return i;
808                 }
809                 tokenIdsIdx++;
810             }
811         }
812         revert('ERC721A: unable to get token of owner by index');
813     }
814 
815     /**
816      * @dev See {IERC165-supportsInterface}.
817      */
818     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
819         return
820             interfaceId == type(IERC721).interfaceId ||
821             interfaceId == type(IERC721Metadata).interfaceId ||
822             interfaceId == type(IERC721Enumerable).interfaceId ||
823             super.supportsInterface(interfaceId);
824     }
825 
826     /**
827      * @dev See {IERC721-balanceOf}.
828      */
829     function balanceOf(address owner) public view override returns (uint256) {
830         require(owner != address(0), 'ERC721A: balance query for the zero address');
831         return uint256(_addressData[owner].balance);
832     }
833 
834     function _numberMinted(address owner) internal view returns (uint256) {
835         require(owner != address(0), 'ERC721A: number minted query for the zero address');
836         return uint256(_addressData[owner].numberMinted);
837     }
838 
839     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
840         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
841 
842         uint256 lowestTokenToCheck;
843         if (tokenId >= maxBatchSize) {
844             lowestTokenToCheck = tokenId - maxBatchSize + 1;
845         }
846 
847         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
848             TokenOwnership memory ownership = _ownerships[curr];
849             if (ownership.addr != address(0)) {
850                 return ownership;
851             }
852         }
853 
854         revert('ERC721A: unable to determine the owner of token');
855     }
856 
857     /**
858      * @dev See {IERC721-ownerOf}.
859      */
860     function ownerOf(uint256 tokenId) public view override returns (address) {
861         return ownershipOf(tokenId).addr;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-name}.
866      */
867     function name() public view virtual override returns (string memory) {
868         return _name;
869     }
870 
871     /**
872      * @dev See {IERC721Metadata-symbol}.
873      */
874     function symbol() public view virtual override returns (string memory) {
875         return _symbol;
876     }
877 
878     /**
879      * @dev See {IERC721Metadata-tokenURI}.
880      */
881     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
882         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
883 
884         string memory baseURI = _baseURI();
885         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
886     }
887 
888     /**
889      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
890      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
891      * by default, can be overriden in child contracts.
892      */
893     function _baseURI() internal view virtual returns (string memory) {
894         return '';
895     }
896 
897     /**
898      * @dev See {IERC721-approve}.
899      */
900     function approve(address to, uint256 tokenId) public override {
901         address owner = ERC721A.ownerOf(tokenId);
902         require(to != owner, 'ERC721A: approval to current owner');
903 
904         require(
905             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
906             'ERC721A: approve caller is not owner nor approved for all'
907         );
908 
909         _approve(to, tokenId, owner);
910     }
911 
912     /**
913      * @dev See {IERC721-getApproved}.
914      */
915     function getApproved(uint256 tokenId) public view override returns (address) {
916         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
917 
918         return _tokenApprovals[tokenId];
919     }
920 
921     /**
922      * @dev See {IERC721-setApprovalForAll}.
923      */
924     function setApprovalForAll(address operator, bool approved) public override {
925         require(operator != _msgSender(), 'ERC721A: approve to caller');
926 
927         _operatorApprovals[_msgSender()][operator] = approved;
928         emit ApprovalForAll(_msgSender(), operator, approved);
929     }
930 
931     /**
932      * @dev See {IERC721-isApprovedForAll}.
933      */
934     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
935         return _operatorApprovals[owner][operator];
936     }
937 
938     /**
939      * @dev See {IERC721-transferFrom}.
940      */
941     function transferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) public override {
946         _transfer(from, to, tokenId);
947     }
948 
949     /**
950      * @dev See {IERC721-safeTransferFrom}.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) public override {
957         safeTransferFrom(from, to, tokenId, '');
958     }
959 
960     /**
961      * @dev See {IERC721-safeTransferFrom}.
962      */
963     function safeTransferFrom(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) public override {
969         _transfer(from, to, tokenId);
970         require(
971             _checkOnERC721Received(from, to, tokenId, _data),
972             'ERC721A: transfer to non ERC721Receiver implementer'
973         );
974     }
975 
976     /**
977      * @dev Returns whether `tokenId` exists.
978      *
979      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
980      *
981      * Tokens start existing when they are minted (`_mint`),
982      */
983     function _exists(uint256 tokenId) internal view returns (bool) {
984         return tokenId < currentIndex;
985     }
986 
987     function _safeMint(address to, uint256 quantity) internal {
988         _safeMint(to, quantity, '');
989     }
990 
991     /**
992      * @dev Mints `quantity` tokens and transfers them to `to`.
993      *
994      * Requirements:
995      *
996      * - `to` cannot be the zero address.
997      * - `quantity` cannot be larger than the max batch size.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function _safeMint(
1002         address to,
1003         uint256 quantity,
1004         bytes memory _data
1005     ) internal {
1006         uint256 startTokenId = currentIndex;
1007         require(to != address(0), 'ERC721A: mint to the zero address');
1008         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1009         require(!_exists(startTokenId), 'ERC721A: token already minted');
1010         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
1011         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1012 
1013         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1014 
1015         AddressData memory addressData = _addressData[to];
1016         _addressData[to] = AddressData(
1017             addressData.balance + uint128(quantity),
1018             addressData.numberMinted + uint128(quantity)
1019         );
1020         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1021 
1022         uint256 updatedIndex = startTokenId;
1023 
1024         for (uint256 i = 0; i < quantity; i++) {
1025             emit Transfer(address(0), to, updatedIndex);
1026             require(
1027                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1028                 'ERC721A: transfer to non ERC721Receiver implementer'
1029             );
1030             updatedIndex++;
1031         }
1032 
1033         currentIndex = updatedIndex;
1034         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1035     }
1036 
1037     /**
1038      * @dev Transfers `tokenId` from `from` to `to`.
1039      *
1040      * Requirements:
1041      *
1042      * - `to` cannot be the zero address.
1043      * - `tokenId` token must be owned by `from`.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _transfer(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) private {
1052         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1053 
1054         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1055             getApproved(tokenId) == _msgSender() ||
1056             isApprovedForAll(prevOwnership.addr, _msgSender()));
1057 
1058         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1059 
1060         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1061         require(to != address(0), 'ERC721A: transfer to the zero address');
1062 
1063         _beforeTokenTransfers(from, to, tokenId, 1);
1064 
1065         // Clear approvals from the previous owner
1066         _approve(address(0), tokenId, prevOwnership.addr);
1067 
1068         // Underflow of the sender's balance is impossible because we check for
1069         // ownership above and the recipient's balance can't realistically overflow.
1070         unchecked {
1071             _addressData[from].balance -= 1;
1072             _addressData[to].balance += 1;
1073         }
1074 
1075         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1076 
1077         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1078         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1079         uint256 nextTokenId = tokenId + 1;
1080         if (_ownerships[nextTokenId].addr == address(0)) {
1081             if (_exists(nextTokenId)) {
1082                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1083             }
1084         }
1085 
1086         emit Transfer(from, to, tokenId);
1087         _afterTokenTransfers(from, to, tokenId, 1);
1088     }
1089 
1090     /**
1091      * @dev Approve `to` to operate on `tokenId`
1092      *
1093      * Emits a {Approval} event.
1094      */
1095     function _approve(
1096         address to,
1097         uint256 tokenId,
1098         address owner
1099     ) private {
1100         _tokenApprovals[tokenId] = to;
1101         emit Approval(owner, to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1106      * The call is not executed if the target address is not a contract.
1107      *
1108      * @param from address representing the previous owner of the given token ID
1109      * @param to target address that will receive the tokens
1110      * @param tokenId uint256 ID of the token to be transferred
1111      * @param _data bytes optional data to send along with the call
1112      * @return bool whether the call correctly returned the expected magic value
1113      */
1114     function _checkOnERC721Received(
1115         address from,
1116         address to,
1117         uint256 tokenId,
1118         bytes memory _data
1119     ) private returns (bool) {
1120         if (to.isContract()) {
1121             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1122                 return retval == IERC721Receiver(to).onERC721Received.selector;
1123             } catch (bytes memory reason) {
1124                 if (reason.length == 0) {
1125                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1126                 } else {
1127                     assembly {
1128                         revert(add(32, reason), mload(reason))
1129                     }
1130                 }
1131             }
1132         } else {
1133             return true;
1134         }
1135     }
1136 
1137     /**
1138      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1139      *
1140      * startTokenId - the first token id to be transferred
1141      * quantity - the amount to be transferred
1142      *
1143      * Calling conditions:
1144      *
1145      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1146      * transferred to `to`.
1147      * - When `from` is zero, `tokenId` will be minted for `to`.
1148      */
1149     function _beforeTokenTransfers(
1150         address from,
1151         address to,
1152         uint256 startTokenId,
1153         uint256 quantity
1154     ) internal virtual {}
1155 
1156     /**
1157      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1158      * minting.
1159      *
1160      * startTokenId - the first token id to be transferred
1161      * quantity - the amount to be transferred
1162      *
1163      * Calling conditions:
1164      *
1165      * - when `from` and `to` are both non-zero.
1166      * - `from` and `to` are never both zero.
1167      */
1168     function _afterTokenTransfers(
1169         address from,
1170         address to,
1171         uint256 startTokenId,
1172         uint256 quantity
1173     ) internal virtual {}
1174 }
1175 
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 contract notBanksy is ERC721A, Ownable {
1180   using Strings for uint256;
1181 
1182   string private uriPrefix = "ipfs://_______NOTBANKSY____/";
1183   string private uriSuffix = ".json";
1184   string public hiddenMetadataUri;
1185   
1186   uint256 public price = 0 ether; 
1187   uint256 public maxSupply = 1974; 
1188   uint256 public maxMintAmountPerTx = 2; 
1189   
1190   bool public paused = true;
1191   bool public revealed = false;
1192   mapping(address => uint256) public addressMintedBalance;
1193 
1194 
1195   constructor() ERC721A("notBanksy", "NB", maxMintAmountPerTx) {
1196     setHiddenMetadataUri("ipfs://QmZBoRf2D29m5gQ5o95EjJRWP24KPYKb2GPuSJYbHbUQB8");
1197   }
1198 
1199   modifier mintCompliance(uint256 _mintAmount) {
1200     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1201     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1202     _;
1203   }
1204 
1205   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1206    {
1207     require(!paused, "The contract is paused!");
1208     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1209     
1210     
1211     _safeMint(msg.sender, _mintAmount);
1212   }
1213 
1214    
1215   function notBanksytoAddress(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1216     _safeMint(_to, _mintAmount);
1217   }
1218 
1219  
1220   function walletOfOwner(address _owner)
1221     public
1222     view
1223     returns (uint256[] memory)
1224   {
1225     uint256 ownerTokenCount = balanceOf(_owner);
1226     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1227     uint256 currentTokenId = 0;
1228     uint256 ownedTokenIndex = 0;
1229 
1230     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1231       address currentTokenOwner = ownerOf(currentTokenId);
1232 
1233       if (currentTokenOwner == _owner) {
1234         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1235 
1236         ownedTokenIndex++;
1237       }
1238 
1239       currentTokenId++;
1240     }
1241 
1242     return ownedTokenIds;
1243   }
1244 
1245   function tokenURI(uint256 _tokenId)
1246     public
1247     view
1248     virtual
1249     override
1250     returns (string memory)
1251   {
1252     require(
1253       _exists(_tokenId),
1254       "ERC721Metadata: URI query for nonexistent token"
1255     );
1256 
1257     if (revealed == false) {
1258       return hiddenMetadataUri;
1259     }
1260 
1261     string memory currentBaseURI = _baseURI();
1262     return bytes(currentBaseURI).length > 0
1263         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1264         : "";
1265   }
1266 
1267   function setRevealed(bool _state) public onlyOwner {
1268     revealed = _state;
1269   
1270   }
1271 
1272   function setPrice(uint256 _price) public onlyOwner {
1273     price = _price;
1274 
1275   }
1276  
1277   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1278     hiddenMetadataUri = _hiddenMetadataUri;
1279   }
1280 
1281 
1282 
1283   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1284     uriPrefix = _uriPrefix;
1285   }
1286 
1287   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1288     uriSuffix = _uriSuffix;
1289   }
1290 
1291   function setPaused(bool _state) public onlyOwner {
1292     paused = _state;
1293   }
1294 
1295   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1296       _safeMint(_receiver, _mintAmount);
1297   }
1298 
1299   function _baseURI() internal view virtual override returns (string memory) {
1300     return uriPrefix;
1301     
1302   }
1303 
1304     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1305     maxMintAmountPerTx = _maxMintAmountPerTx;
1306 
1307   }
1308 
1309     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1310     maxSupply = _maxSupply;
1311 
1312   }
1313 
1314 
1315   // withdrawall addresses
1316   address t1 = 0xEd3D2D1c23ddf1a6a70b4aFb1459140d63835c0E; 
1317   
1318 
1319   function withdrawall() public onlyOwner {
1320         uint256 _balance = address(this).balance;
1321         
1322         require(payable(t1).send(_balance * 100 / 100 ));
1323         
1324     }
1325 
1326   function withdraw() public onlyOwner {
1327     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1328     require(os);
1329     
1330 
1331  
1332   }
1333   
1334 }