1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Address.sol
177 
178 
179 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
180 
181 pragma solidity ^0.8.1;
182 
183 /**
184  * @dev Collection of functions related to the address type
185  */
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * [IMPORTANT]
191      * ====
192      * It is unsafe to assume that an address for which this function returns
193      * false is an externally-owned account (EOA) and not a contract.
194      *
195      * Among others, `isContract` will return false for the following
196      * types of addresses:
197      *
198      *  - an externally-owned account
199      *  - a contract in construction
200      *  - an address where a contract will be created
201      *  - an address where a contract lived, but was destroyed
202      * ====
203      *
204      * [IMPORTANT]
205      * ====
206      * You shouldn't rely on `isContract` to protect against flash loan attacks!
207      *
208      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
209      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
210      * constructor.
211      * ====
212      */
213     function isContract(address account) internal view returns (bool) {
214         // This method relies on extcodesize/address.code.length, which returns 0
215         // for contracts in construction, since the code is only stored at the end
216         // of the constructor execution.
217 
218         return account.code.length > 0;
219     }
220 
221     /**
222      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
223      * `recipient`, forwarding all available gas and reverting on errors.
224      *
225      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
226      * of certain opcodes, possibly making contracts go over the 2300 gas limit
227      * imposed by `transfer`, making them unable to receive funds via
228      * `transfer`. {sendValue} removes this limitation.
229      *
230      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
231      *
232      * IMPORTANT: because control is transferred to `recipient`, care must be
233      * taken to not create reentrancy vulnerabilities. Consider using
234      * {ReentrancyGuard} or the
235      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
236      */
237     function sendValue(address payable recipient, uint256 amount) internal {
238         require(address(this).balance >= amount, "Address: insufficient balance");
239 
240         (bool success, ) = recipient.call{value: amount}("");
241         require(success, "Address: unable to send value, recipient may have reverted");
242     }
243 
244     /**
245      * @dev Performs a Solidity function call using a low level `call`. A
246      * plain `call` is an unsafe replacement for a function call: use this
247      * function instead.
248      *
249      * If `target` reverts with a revert reason, it is bubbled up by this
250      * function (like regular Solidity function calls).
251      *
252      * Returns the raw returned data. To convert to the expected return value,
253      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
254      *
255      * Requirements:
256      *
257      * - `target` must be a contract.
258      * - calling `target` with `data` must not revert.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionCall(target, data, "Address: low-level call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
268      * `errorMessage` as a fallback revert reason when `target` reverts.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, 0, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but also transferring `value` wei to `target`.
283      *
284      * Requirements:
285      *
286      * - the calling contract must have an ETH balance of at least `value`.
287      * - the called Solidity function must be `payable`.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
301      * with `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         require(address(this).balance >= value, "Address: insufficient balance for call");
312         require(isContract(target), "Address: call to non-contract");
313 
314         (bool success, bytes memory returndata) = target.call{value: value}(data);
315         return verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but performing a static call.
321      *
322      * _Available since v3.3._
323      */
324     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
325         return functionStaticCall(target, data, "Address: low-level static call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal view returns (bytes memory) {
339         require(isContract(target), "Address: static call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.staticcall(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(isContract(target), "Address: delegate call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.delegatecall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
374      * revert reason using the provided one.
375      *
376      * _Available since v4.3._
377      */
378     function verifyCallResult(
379         bool success,
380         bytes memory returndata,
381         string memory errorMessage
382     ) internal pure returns (bytes memory) {
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
402 
403 
404 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @title ERC721 token receiver interface
410  * @dev Interface for any contract that wants to support safeTransfers
411  * from ERC721 asset contracts.
412  */
413 interface IERC721Receiver {
414     /**
415      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
416      * by `operator` from `from`, this function is called.
417      *
418      * It must return its Solidity selector to confirm the token transfer.
419      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
420      *
421      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
422      */
423     function onERC721Received(
424         address operator,
425         address from,
426         uint256 tokenId,
427         bytes calldata data
428     ) external returns (bytes4);
429 }
430 
431 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @dev Interface of the ERC165 standard, as defined in the
440  * https://eips.ethereum.org/EIPS/eip-165[EIP].
441  *
442  * Implementers can declare support of contract interfaces, which can then be
443  * queried by others ({ERC165Checker}).
444  *
445  * For an implementation, see {ERC165}.
446  */
447 interface IERC165 {
448     /**
449      * @dev Returns true if this contract implements the interface defined by
450      * `interfaceId`. See the corresponding
451      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
452      * to learn more about how these ids are created.
453      *
454      * This function call must use less than 30 000 gas.
455      */
456     function supportsInterface(bytes4 interfaceId) external view returns (bool);
457 }
458 
459 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @dev Implementation of the {IERC165} interface.
469  *
470  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
471  * for the additional interface id that will be supported. For example:
472  *
473  * ```solidity
474  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
475  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
476  * }
477  * ```
478  *
479  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
480  */
481 abstract contract ERC165 is IERC165 {
482     /**
483      * @dev See {IERC165-supportsInterface}.
484      */
485     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486         return interfaceId == type(IERC165).interfaceId;
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 
498 /**
499  * @dev Required interface of an ERC721 compliant contract.
500  */
501 interface IERC721 is IERC165 {
502     /**
503      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
504      */
505     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
506 
507     /**
508      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
509      */
510     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
511 
512     /**
513      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
514      */
515     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
516 
517     /**
518      * @dev Returns the number of tokens in ``owner``'s account.
519      */
520     function balanceOf(address owner) external view returns (uint256 balance);
521 
522     /**
523      * @dev Returns the owner of the `tokenId` token.
524      *
525      * Requirements:
526      *
527      * - `tokenId` must exist.
528      */
529     function ownerOf(uint256 tokenId) external view returns (address owner);
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
533      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must exist and be owned by `from`.
540      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
542      *
543      * Emits a {Transfer} event.
544      */
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 tokenId
549     ) external;
550 
551     /**
552      * @dev Transfers `tokenId` token from `from` to `to`.
553      *
554      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      *
563      * Emits a {Transfer} event.
564      */
565     function transferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external;
570 
571     /**
572      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
573      * The approval is cleared when the token is transferred.
574      *
575      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
576      *
577      * Requirements:
578      *
579      * - The caller must own the token or be an approved operator.
580      * - `tokenId` must exist.
581      *
582      * Emits an {Approval} event.
583      */
584     function approve(address to, uint256 tokenId) external;
585 
586     /**
587      * @dev Returns the account approved for `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function getApproved(uint256 tokenId) external view returns (address operator);
594 
595     /**
596      * @dev Approve or remove `operator` as an operator for the caller.
597      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
598      *
599      * Requirements:
600      *
601      * - The `operator` cannot be the caller.
602      *
603      * Emits an {ApprovalForAll} event.
604      */
605     function setApprovalForAll(address operator, bool _approved) external;
606 
607     /**
608      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
609      *
610      * See {setApprovalForAll}
611      */
612     function isApprovedForAll(address owner, address operator) external view returns (bool);
613 
614     /**
615      * @dev Safely transfers `tokenId` token from `from` to `to`.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must exist and be owned by `from`.
622      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
624      *
625      * Emits a {Transfer} event.
626      */
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId,
631         bytes calldata data
632     ) external;
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
645  * @dev See https://eips.ethereum.org/EIPS/eip-721
646  */
647 interface IERC721Metadata is IERC721 {
648     /**
649      * @dev Returns the token collection name.
650      */
651     function name() external view returns (string memory);
652 
653     /**
654      * @dev Returns the token collection symbol.
655      */
656     function symbol() external view returns (string memory);
657 
658     /**
659      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
660      */
661     function tokenURI(uint256 tokenId) external view returns (string memory);
662 }
663 
664 // File: workspaces/default_workspace/samuraisanta.sol
665 
666 /**
667  * SPDX-License-Identifier: MIT
668  *
669  * Copyright (c) 2022 WYE Company
670  *
671  * Permission is hereby granted, free of charge, to any person obtaining a copy
672  * of this software and associated documentation files (the "Software"), to deal
673  * in the Software without restriction, including without limitation the rights
674  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
675  * copies of the Software, and to permit persons to whom the Software is
676  * furnished to do so, subject to the following conditions:
677  *
678  * The above copyright notice and this permission notice shall be included in
679  * copies or substantial portions of the Software.
680  *
681  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
682  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
683  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
684  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
685  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
686  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
687  * SOFTWARE.
688  *
689  */
690 
691 pragma solidity 0.8.13;
692 
693 
694 
695 
696 
697 
698 
699 
700 
701 error ApprovalCallerNotOwnerNorApproved();
702 error ApprovalQueryForNonexistentToken();
703 error ApproveToCaller();
704 error ApprovalToCurrentOwner();
705 error BalanceQueryForZeroAddress();
706 error MintToZeroAddress();
707 error MintZeroQuantity();
708 error OwnerQueryForNonexistentToken();
709 error TransferCallerNotOwnerNorApproved();
710 error TransferFromIncorrectOwner();
711 error TransferToNonERC721ReceiverImplementer();
712 error TransferToZeroAddress();
713 error URIQueryForNonexistentToken();
714 
715 /**
716  * @dev Chiru Labs Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
717  * the Metadata extension. Built to optimize for lower gas during batch mints.
718  *
719  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
720  *
721  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
722  *
723  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
724  */
725 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
726     using Address for address;
727     using Strings for uint256;
728 
729     // Compiler will pack this into a single 256bit word.
730     struct TokenOwnership {
731         // The address of the owner.
732         address addr;
733         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
734         uint64 startTimestamp;
735         // Whether the token has been burned.
736         bool burned;
737     }
738 
739     // Compiler will pack this into a single 256bit word.
740     struct AddressData {
741         // Realistically, 2**64-1 is more than enough.
742         uint64 balance;
743         // Keeps track of mint count with minimal overhead for tokenomics.
744         uint64 numberMinted;
745         // Keeps track of burn count with minimal overhead for tokenomics.
746         uint64 numberBurned;
747         // For miscellaneous variable(s) pertaining to the address
748         // (e.g. number of whitelist mint slots used).
749         // If there are multiple variables, please pack them into a uint64.
750         uint64 aux;
751     }
752 
753     // The tokenId of the next token to be minted.
754     uint256 internal _currentIndex;
755 
756     // The number of tokens burned.
757     uint256 internal _burnCounter;
758 
759     // Token name
760     string private _name;
761 
762     // Token symbol
763     string private _symbol;
764 
765     /**
766      * @dev See {IERC721Metadata-tokenURI}.
767      */
768     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
769         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
770 
771         string memory baseURI = _baseURI();
772         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
773     }
774 
775     /**
776      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
777      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
778      * by default, can be overriden in child contracts.
779      */
780     function _baseURI() internal view virtual returns (string memory) {
781         return '';
782     }
783 
784     // Mapping from token ID to ownership details
785     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
786     mapping(uint256 => TokenOwnership) internal _ownerships;
787 
788     // Mapping owner address to address data
789     mapping(address => AddressData) private _addressData;
790 
791     // Mapping from token ID to approved address
792     mapping(uint256 => address) private _tokenApprovals;
793 
794     // Mapping from owner to operator approvals
795     mapping(address => mapping(address => bool)) private _operatorApprovals;
796 
797     constructor(string memory name_, string memory symbol_) {
798         _name = name_;
799         _symbol = symbol_;
800         _currentIndex = _startTokenId();
801     }
802 
803     /**
804      * To change the starting tokenId, please override this function.
805      */
806     function _startTokenId() internal view virtual returns (uint256) {
807         return 0;
808     }
809 
810     /**
811      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
812      */
813     function totalSupply() public view returns (uint256) {
814         // Counter underflow is impossible as _burnCounter cannot be incremented
815         // more than _currentIndex - _startTokenId() times
816         unchecked {
817             return _currentIndex - _burnCounter - _startTokenId();
818         }
819     }
820 
821     /**
822      * Returns the total amount of tokens minted in the contract.
823      */
824     function _totalMinted() internal view returns (uint256) {
825         // Counter underflow is impossible as _currentIndex does not decrement,
826         // and it is initialized to _startTokenId()
827         unchecked {
828             return _currentIndex - _startTokenId();
829         }
830     }
831 
832     /**
833      * @dev See {IERC165-supportsInterface}.
834      */
835     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
836         return
837             interfaceId == type(IERC721).interfaceId ||
838             interfaceId == type(IERC721Metadata).interfaceId ||
839             super.supportsInterface(interfaceId);
840     }
841 
842     /**
843      * @dev See {IERC721-balanceOf}.
844      */
845     function balanceOf(address owner) public view override returns (uint256) {
846         if (owner == address(0)) revert BalanceQueryForZeroAddress();
847         return uint256(_addressData[owner].balance);
848     }
849 
850     /**
851      * Returns the number of tokens minted by `owner`.
852      */
853     function _numberMinted(address owner) internal view returns (uint256) {
854         return uint256(_addressData[owner].numberMinted);
855     }
856 
857     /**
858      * Returns the number of tokens burned by or on behalf of `owner`.
859      */
860     function _numberBurned(address owner) internal view returns (uint256) {
861         return uint256(_addressData[owner].numberBurned);
862     }
863 
864     /**
865      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
866      */
867     function _getAux(address owner) internal view returns (uint64) {
868         return _addressData[owner].aux;
869     }
870 
871     /**
872      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
873      * If there are multiple variables, please pack them into a uint64.
874      */
875     function _setAux(address owner, uint64 aux) internal {
876         _addressData[owner].aux = aux;
877     }
878 
879     /**
880      * Gas spent here starts off proportional to the maximum mint batch size.
881      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
882      */
883     function _ownershipOf(uint256 tokenId) internal virtual view returns (TokenOwnership memory) {
884         uint256 curr = tokenId;
885 
886         unchecked {
887             if (_startTokenId() <= curr && curr < _currentIndex) {
888                 TokenOwnership memory ownership = _ownerships[curr];
889                 if (!ownership.burned) {
890                     if (ownership.addr != address(0)) {
891                         return ownership;
892                     }
893                     // Invariant:
894                     // There will always be an ownership that has an address and is not burned
895                     // before an ownership that does not have an address and is not burned.
896                     // Hence, curr will not underflow.
897                     while (true) {
898                         curr--;
899                         ownership = _ownerships[curr];
900                         if (ownership.addr != address(0)) {
901                             return ownership;
902                         }
903                     }
904                 }
905             }
906         }
907         revert OwnerQueryForNonexistentToken();
908     }
909 
910     /**
911      * @dev See {IERC721-ownerOf}.
912      */
913     function ownerOf(uint256 tokenId) public view override returns (address) {
914         return _ownershipOf(tokenId).addr;
915     }
916 
917     /**
918      * @dev See {IERC721Metadata-name}.
919      */
920     function name() public view virtual override returns (string memory) {
921         return _name;
922     }
923 
924     /**
925      * @dev See {IERC721Metadata-symbol}.
926      */
927     function symbol() public view virtual override returns (string memory) {
928         return _symbol;
929     }
930 
931     /**
932      * @dev See {IERC721-approve}.
933      */
934     function approve(address to, uint256 tokenId) public override {
935         address owner = ERC721A.ownerOf(tokenId);
936         if (to == owner) revert ApprovalToCurrentOwner();
937 
938         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
939             revert ApprovalCallerNotOwnerNorApproved();
940         }
941 
942         _approve(to, tokenId, owner);
943     }
944 
945     /**
946      * @dev See {IERC721-getApproved}.
947      */
948     function getApproved(uint256 tokenId) public view override returns (address) {
949         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
950 
951         return _tokenApprovals[tokenId];
952     }
953 
954     /**
955      * @dev See {IERC721-setApprovalForAll}.
956      */
957     function setApprovalForAll(address operator, bool approved) public virtual override {
958         if (operator == _msgSender()) revert ApproveToCaller();
959 
960         _operatorApprovals[_msgSender()][operator] = approved;
961         emit ApprovalForAll(_msgSender(), operator, approved);
962     }
963 
964     /**
965      * @dev See {IERC721-isApprovedForAll}.
966      */
967     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
968         return _operatorApprovals[owner][operator];
969     }
970 
971     /**
972      * @dev See {IERC721-transferFrom}.
973      */
974     function transferFrom(
975         address from,
976         address to,
977         uint256 tokenId
978     ) public virtual override {
979         _transfer(from, to, tokenId);
980     }
981 
982     /**
983      * @dev See {IERC721-safeTransferFrom}.
984      */
985     function safeTransferFrom(
986         address from,
987         address to,
988         uint256 tokenId
989     ) public virtual override {
990         safeTransferFrom(from, to, tokenId, '');
991     }
992 
993     /**
994      * @dev See {IERC721-safeTransferFrom}.
995      */
996     function safeTransferFrom(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) public virtual override {
1002         _transfer(from, to, tokenId);
1003         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1004             revert TransferToNonERC721ReceiverImplementer();
1005         }
1006     }
1007 
1008     /**
1009      * @dev Returns whether `tokenId` exists.
1010      *
1011      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1012      *
1013      * Tokens start existing when they are minted (`_mint`),
1014      */
1015     function _exists(uint256 tokenId) internal view returns (bool) {
1016         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1017     }
1018 
1019     function _safeMint(address to, uint256 quantity) internal {
1020         _safeMint(to, quantity, '');
1021     }
1022 
1023     /**
1024      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1029      * - `quantity` must be greater than 0.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function _safeMint(
1034         address to,
1035         uint256 quantity,
1036         bytes memory _data
1037     ) internal {
1038         _mint(to, quantity, _data, true);
1039     }
1040 
1041     /**
1042      * @dev Mints `quantity` tokens and transfers them to `to`.
1043      *
1044      * Requirements:
1045      *
1046      * - `to` cannot be the zero address.
1047      * - `quantity` must be greater than 0.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _mint(
1052         address to,
1053         uint256 quantity,
1054         bytes memory _data,
1055         bool safe
1056     ) internal {
1057         uint256 startTokenId = _currentIndex;
1058         if (to == address(0)) revert MintToZeroAddress();
1059         if (quantity == 0) revert MintZeroQuantity();
1060 
1061         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1062 
1063         // Overflows are incredibly unrealistic.
1064         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1065         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1066         unchecked {
1067             _addressData[to].balance += uint64(quantity);
1068             _addressData[to].numberMinted += uint64(quantity);
1069 
1070             _ownerships[startTokenId].addr = to;
1071             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1072 
1073             uint256 updatedIndex = startTokenId;
1074             uint256 end = updatedIndex + quantity;
1075 
1076             if (safe && to.isContract()) {
1077                 do {
1078                     emit Transfer(address(0), to, updatedIndex);
1079                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1080                         revert TransferToNonERC721ReceiverImplementer();
1081                     }
1082                 } while (updatedIndex != end);
1083                 // Reentrancy protection
1084                 if (_currentIndex != startTokenId) revert();
1085             } else {
1086                 do {
1087                     emit Transfer(address(0), to, updatedIndex++);
1088                 } while (updatedIndex != end);
1089             }
1090             _currentIndex = updatedIndex;
1091         }
1092         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1093     }
1094 
1095     /**
1096      * @dev Transfers `tokenId` from `from` to `to`.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `tokenId` token must be owned by `from`.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _transfer(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) private {
1110         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1111 
1112         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1113 
1114         bool isApprovedOrOwner = (_msgSender() == from ||
1115             isApprovedForAll(from, _msgSender()) ||
1116             getApproved(tokenId) == _msgSender());
1117 
1118         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1119         if (to == address(0)) revert TransferToZeroAddress();
1120 
1121         _beforeTokenTransfers(from, to, tokenId, 1);
1122 
1123         // Clear approvals from the previous owner
1124         _approve(address(0), tokenId, from);
1125 
1126         // Underflow of the sender's balance is impossible because we check for
1127         // ownership above and the recipient's balance can't realistically overflow.
1128         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1129         unchecked {
1130             _addressData[from].balance -= 1;
1131             _addressData[to].balance += 1;
1132 
1133             TokenOwnership storage currSlot = _ownerships[tokenId];
1134             currSlot.addr = to;
1135             currSlot.startTimestamp = uint64(block.timestamp);
1136 
1137             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1138             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1139             uint256 nextTokenId = tokenId + 1;
1140             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1141             if (nextSlot.addr == address(0)) {
1142                 // This will suffice for checking _exists(nextTokenId),
1143                 // as a burned slot cannot contain the zero address.
1144                 if (nextTokenId != _currentIndex) {
1145                     nextSlot.addr = from;
1146                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1147                 }
1148             }
1149         }
1150 
1151         emit Transfer(from, to, tokenId);
1152         _afterTokenTransfers(from, to, tokenId, 1);
1153     }
1154 
1155     /**
1156      * @dev This is equivalent to _burn(tokenId, false)
1157      */
1158     function _burn(uint256 tokenId) internal virtual {
1159         _burn(tokenId, false);
1160     }
1161 
1162     /**
1163      * @dev Destroys `tokenId`.
1164      * The approval is cleared when the token is burned.
1165      *
1166      * Requirements:
1167      *
1168      * - `tokenId` must exist.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1173         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1174 
1175         address from = prevOwnership.addr;
1176 
1177         if (approvalCheck) {
1178             bool isApprovedOrOwner = (_msgSender() == from ||
1179                 isApprovedForAll(from, _msgSender()) ||
1180                 getApproved(tokenId) == _msgSender());
1181 
1182             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1183         }
1184 
1185         _beforeTokenTransfers(from, address(0), tokenId, 1);
1186 
1187         // Clear approvals from the previous owner
1188         _approve(address(0), tokenId, from);
1189 
1190         // Underflow of the sender's balance is impossible because we check for
1191         // ownership above and the recipient's balance can't realistically overflow.
1192         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1193         unchecked {
1194             AddressData storage addressData = _addressData[from];
1195             addressData.balance -= 1;
1196             addressData.numberBurned += 1;
1197 
1198             // Keep track of who burned the token, and the timestamp of burning.
1199             TokenOwnership storage currSlot = _ownerships[tokenId];
1200             currSlot.addr = from;
1201             currSlot.startTimestamp = uint64(block.timestamp);
1202             currSlot.burned = true;
1203 
1204             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1205             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1206             uint256 nextTokenId = tokenId + 1;
1207             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1208             if (nextSlot.addr == address(0)) {
1209                 // This will suffice for checking _exists(nextTokenId),
1210                 // as a burned slot cannot contain the zero address.
1211                 if (nextTokenId != _currentIndex) {
1212                     nextSlot.addr = from;
1213                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1214                 }
1215             }
1216         }
1217 
1218         emit Transfer(from, address(0), tokenId);
1219         _afterTokenTransfers(from, address(0), tokenId, 1);
1220 
1221         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1222         unchecked {
1223             _burnCounter++;
1224         }
1225     }
1226 
1227     /**
1228      * @dev Approve `to` to operate on `tokenId`
1229      *
1230      * Emits a {Approval} event.
1231      */
1232     function _approve(
1233         address to,
1234         uint256 tokenId,
1235         address owner
1236     ) private {
1237         _tokenApprovals[tokenId] = to;
1238         emit Approval(owner, to, tokenId);
1239     }
1240 
1241     /**
1242      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1243      *
1244      * @param from address representing the previous owner of the given token ID
1245      * @param to target address that will receive the tokens
1246      * @param tokenId uint256 ID of the token to be transferred
1247      * @param _data bytes optional data to send along with the call
1248      * @return bool whether the call correctly returned the expected magic value
1249      */
1250     function _checkContractOnERC721Received(
1251         address from,
1252         address to,
1253         uint256 tokenId,
1254         bytes memory _data
1255     ) private returns (bool) {
1256         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1257             return retval == IERC721Receiver(to).onERC721Received.selector;
1258         } catch (bytes memory reason) {
1259             if (reason.length == 0) {
1260                 revert TransferToNonERC721ReceiverImplementer();
1261             } else {
1262                 assembly {
1263                     revert(add(32, reason), mload(reason))
1264                 }
1265             }
1266         }
1267     }
1268 
1269     /**
1270      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1271      * And also called before burning one token.
1272      *
1273      * startTokenId - the first token id to be transferred
1274      * quantity - the amount to be transferred
1275      *
1276      * Calling conditions:
1277      *
1278      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1279      * transferred to `to`.
1280      * - When `from` is zero, `tokenId` will be minted for `to`.
1281      * - When `to` is zero, `tokenId` will be burned by `from`.
1282      * - `from` and `to` are never both zero.
1283      */
1284     function _beforeTokenTransfers(
1285         address from,
1286         address to,
1287         uint256 startTokenId,
1288         uint256 quantity
1289     ) internal virtual {}
1290 
1291     /**
1292      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1293      * minting.
1294      * And also called after one token has been burned.
1295      *
1296      * startTokenId - the first token id to be transferred
1297      * quantity - the amount to be transferred
1298      *
1299      * Calling conditions:
1300      *
1301      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1302      * transferred to `to`.
1303      * - When `from` is zero, `tokenId` has been minted for `to`.
1304      * - When `to` is zero, `tokenId` has been burned by `from`.
1305      * - `from` and `to` are never both zero.
1306      */
1307     function _afterTokenTransfers(
1308         address from,
1309         address to,
1310         uint256 startTokenId,
1311         uint256 quantity
1312     ) internal virtual {}
1313 }
1314 
1315 contract AkutarMintPass is ERC721A, Ownable {
1316 
1317     string baseURI = "ipfs://QmcKU4czhrgRPMgE7P6C6JhV51wciJtL41AQS9QCLsjary/";
1318     bytes32 constant baseExtension = ".json";
1319 
1320     uint256 constant akuMegaOGEnd = 529;
1321     uint256 constant akuOGEnd = 3032;
1322     uint256 constant akuEnd = 9341;
1323 
1324     uint256 constant niftyAkuMegaOGEnd = 290;
1325     uint256 constant niftyAkuOGEnd = 2074;
1326     uint256 constant niftyAkuEnd = 5962;
1327 
1328     address immutable niftyOmnibus;
1329 
1330     constructor(address _nifty) ERC721A("Akutar Mint Pass", "AKUTARMP") {
1331         niftyOmnibus = _nifty;
1332     }
1333 
1334     function mint(address[] calldata to, uint256[] calldata quantity) external onlyOwner {
1335         require(to.length == quantity.length, "Array size mismatch");
1336         uint256 _airdrops = to.length;
1337         for (uint256 i = 0; i < _airdrops; i++){
1338             uint256 currentSupply = totalSupply();
1339             if(currentSupply < akuMegaOGEnd)
1340                 require(currentSupply + quantity[i] <= akuMegaOGEnd, "Can't mint across mint pass sections");
1341             else if(currentSupply < akuOGEnd)
1342                 require(currentSupply + quantity[i] <= akuOGEnd, "Can't mint across mint pass sections");
1343             
1344             _safeMint(to[i], quantity[i]);
1345         }
1346         require(totalSupply() <= akuEnd);
1347     }
1348 
1349     function _startTokenId() internal view virtual override returns (uint256) {
1350         return 1;
1351     }
1352 
1353     function setBaseURI(string calldata _base) external onlyOwner {
1354         baseURI = _base;
1355     }
1356 
1357     function _baseURI() internal view override returns (string memory) {
1358         return baseURI;
1359     }
1360 
1361     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1362         if (!_exists(_tokenId)) revert URIQueryForNonexistentToken();
1363         string memory base = _baseURI();
1364 
1365         if (bytes(base).length > 0) {
1366             if(_tokenId <= akuMegaOGEnd)
1367                 return string(abi.encodePacked(base, "MegaOGAkutarMintPass", baseExtension));
1368             else if(_tokenId <= akuOGEnd)
1369                 return string(abi.encodePacked(base, "OGAkutarMintPass", baseExtension));
1370             else if(_tokenId <= akuEnd)
1371                 return string(abi.encodePacked(base, "RandomAkutarMintPass", baseExtension));
1372         }
1373 
1374         return super.tokenURI(_tokenId);
1375     }
1376 
1377     function _ownershipOf(uint256 tokenId) internal view override returns (TokenOwnership memory) {
1378         uint256 curr = tokenId;
1379 
1380         unchecked {
1381             if (_startTokenId() <= curr && curr < _currentIndex) {          
1382                 TokenOwnership memory ownership = _ownerships[curr];
1383                 if (!ownership.burned) {
1384                     if (ownership.addr == address(0)) {
1385                         if(curr <= niftyAkuMegaOGEnd || (curr > akuMegaOGEnd && curr <= niftyAkuOGEnd) || (curr > akuOGEnd && curr <= niftyAkuEnd))
1386                             return TokenOwnership(niftyOmnibus, 0, false);
1387                     }
1388                 }
1389             }
1390         }
1391 
1392         return super._ownershipOf(tokenId);
1393     }
1394 
1395     function _beforeTokenTransfers(
1396         address from,
1397         address to,
1398         uint256 startTokenId,
1399         uint256 quantity
1400     ) internal override {
1401         super._beforeTokenTransfers(from, to, startTokenId, quantity);
1402     }
1403 }