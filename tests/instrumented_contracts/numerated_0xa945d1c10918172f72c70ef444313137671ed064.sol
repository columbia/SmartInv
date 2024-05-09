1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
4 
5 pragma solidity ^0.8.13;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Context.sol
71 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
72 
73 /**
74  * @dev Provides information about the current execution context, including the
75  * sender of the transaction and its data. While these are generally available
76  * via msg.sender and msg.data, they should not be accessed in such a direct
77  * manner, since when dealing with meta-transactions the account sending and
78  * paying for execution may not be the actual sender (as far as an application
79  * is concerned).
80  *
81  * This contract is only required for intermediate, library-like contracts.
82  */
83 abstract contract Context {
84     function _msgSender() internal view virtual returns (address) {
85         return msg.sender;
86     }
87 
88     function _msgData() internal view virtual returns (bytes calldata) {
89         return msg.data;
90     }
91 }
92 
93 // File: @openzeppelin/contracts/access/Ownable.sol
94 
95 
96 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
97 
98 
99 /**
100  * @dev Contract module which provides a basic access control mechanism, where
101  * there is an account (an owner) that can be granted exclusive access to
102  * specific functions.
103  *
104  * By default, the owner account will be the one that deploys the contract. This
105  * can later be changed with {transferOwnership}.
106  *
107  * This module is used through inheritance. It will make available the modifier
108  * `onlyOwner`, which can be applied to your functions to restrict their use to
109  * the owner.
110  */
111 abstract contract Ownable is Context {
112     address private _owner;
113 
114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115 
116     /**
117      * @dev Initializes the contract setting the deployer as the initial owner.
118      */
119     constructor() {
120         _transferOwnership(_msgSender());
121     }
122 
123     /**
124      * @dev Returns the address of the current owner.
125      */
126     function owner() public view virtual returns (address) {
127         return _owner;
128     }
129 
130     /**
131      * @dev Throws if called by any account other than the owner.
132      */
133     modifier onlyOwner() {
134         require(owner() == _msgSender(), "Ownable: caller is not the owner");
135         _;
136     }
137 
138     /**
139      * @dev Leaves the contract without owner. It will not be possible to call
140      * `onlyOwner` functions anymore. Can only be called by the current owner.
141      *
142      * NOTE: Renouncing ownership will leave the contract without an owner,
143      * thereby removing any functionality that is only available to the owner.
144      */
145     function renounceOwnership() public virtual onlyOwner {
146         _transferOwnership(address(0));
147     }
148 
149     /**
150      * @dev Transfers ownership of the contract to a new account (`newOwner`).
151      * Can only be called by the current owner.
152      */
153     function transferOwnership(address newOwner) public virtual onlyOwner {
154         require(newOwner != address(0), "Ownable: new owner is the zero address");
155         _transferOwnership(newOwner);
156     }
157 
158     /**
159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
160      * Internal function without access restriction.
161      */
162     function _transferOwnership(address newOwner) internal virtual {
163         address oldOwner = _owner;
164         _owner = newOwner;
165         emit OwnershipTransferred(oldOwner, newOwner);
166     }
167 }
168 
169 // File: @openzeppelin/contracts/utils/Address.sol
170 
171 
172 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
173 
174 /**
175  * @dev Collection of functions related to the address type
176  */
177 library Address {
178     /**
179      * @dev Returns true if `account` is a contract.
180      *
181      * [IMPORTANT]
182      * ====
183      * It is unsafe to assume that an address for which this function returns
184      * false is an externally-owned account (EOA) and not a contract.
185      *
186      * Among others, `isContract` will return false for the following
187      * types of addresses:
188      *
189      *  - an externally-owned account
190      *  - a contract in construction
191      *  - an address where a contract will be created
192      *  - an address where a contract lived, but was destroyed
193      * ====
194      */
195     function isContract(address account) internal view returns (bool) {
196         // This method relies on extcodesize, which returns 0 for contracts in
197         // construction, since the code is only stored at the end of the
198         // constructor execution.
199 
200         uint256 size;
201         assembly {
202             size := extcodesize(account)
203         }
204         return size > 0;
205     }
206 
207     /**
208      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
209      * `recipient`, forwarding all available gas and reverting on errors.
210      *
211      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
212      * of certain opcodes, possibly making contracts go over the 2300 gas limit
213      * imposed by `transfer`, making them unable to receive funds via
214      * `transfer`. {sendValue} removes this limitation.
215      *
216      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
217      *
218      * IMPORTANT: because control is transferred to `recipient`, care must be
219      * taken to not create reentrancy vulnerabilities. Consider using
220      * {ReentrancyGuard} or the
221      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
222      */
223     function sendValue(address payable recipient, uint256 amount) internal {
224         require(address(this).balance >= amount, "Address: insufficient balance");
225 
226         (bool success, ) = recipient.call{value: amount}("");
227         require(success, "Address: unable to send value, recipient may have reverted");
228     }
229 
230     /**
231      * @dev Performs a Solidity function call using a low level `call`. A
232      * plain `call` is an unsafe replacement for a function call: use this
233      * function instead.
234      *
235      * If `target` reverts with a revert reason, it is bubbled up by this
236      * function (like regular Solidity function calls).
237      *
238      * Returns the raw returned data. To convert to the expected return value,
239      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
240      *
241      * Requirements:
242      *
243      * - `target` must be a contract.
244      * - calling `target` with `data` must not revert.
245      *
246      * _Available since v3.1._
247      */
248     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
249         return functionCall(target, data, "Address: low-level call failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
254      * `errorMessage` as a fallback revert reason when `target` reverts.
255      *
256      * _Available since v3.1._
257      */
258     function functionCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         return functionCallWithValue(target, data, 0, errorMessage);
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
268      * but also transferring `value` wei to `target`.
269      *
270      * Requirements:
271      *
272      * - the calling contract must have an ETH balance of at least `value`.
273      * - the called Solidity function must be `payable`.
274      *
275      * _Available since v3.1._
276      */
277     function functionCallWithValue(
278         address target,
279         bytes memory data,
280         uint256 value
281     ) internal returns (bytes memory) {
282         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
287      * with `errorMessage` as a fallback revert reason when `target` reverts.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value,
295         string memory errorMessage
296     ) internal returns (bytes memory) {
297         require(address(this).balance >= value, "Address: insufficient balance for call");
298         require(isContract(target), "Address: call to non-contract");
299 
300         (bool success, bytes memory returndata) = target.call{value: value}(data);
301         return verifyCallResult(success, returndata, errorMessage);
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306      * but performing a static call.
307      *
308      * _Available since v3.3._
309      */
310     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
311         return functionStaticCall(target, data, "Address: low-level static call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
316      * but performing a static call.
317      *
318      * _Available since v3.3._
319      */
320     function functionStaticCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal view returns (bytes memory) {
325         require(isContract(target), "Address: static call to non-contract");
326 
327         (bool success, bytes memory returndata) = target.staticcall(data);
328         return verifyCallResult(success, returndata, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but performing a delegate call.
334      *
335      * _Available since v3.4._
336      */
337     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
338         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
343      * but performing a delegate call.
344      *
345      * _Available since v3.4._
346      */
347     function functionDelegateCall(
348         address target,
349         bytes memory data,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(isContract(target), "Address: delegate call to non-contract");
353 
354         (bool success, bytes memory returndata) = target.delegatecall(data);
355         return verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     /**
359      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
360      * revert reason using the provided one.
361      *
362      * _Available since v4.3._
363      */
364     function verifyCallResult(
365         bool success,
366         bytes memory returndata,
367         string memory errorMessage
368     ) internal pure returns (bytes memory) {
369         if (success) {
370             return returndata;
371         } else {
372             // Look for revert reason and bubble it up if present
373             if (returndata.length > 0) {
374                 // The easiest way to bubble the revert reason is using memory via assembly
375 
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
388 
389 
390 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
391 
392 /**
393  * @title ERC721 token receiver interface
394  * @dev Interface for any contract that wants to support safeTransfers
395  * from ERC721 asset contracts.
396  */
397 interface IERC721Receiver {
398     /**
399      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
400      * by `operator` from `from`, this function is called.
401      *
402      * It must return its Solidity selector to confirm the token transfer.
403      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
404      *
405      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
406      */
407     function onERC721Received(
408         address operator,
409         address from,
410         uint256 tokenId,
411         bytes calldata data
412     ) external returns (bytes4);
413 }
414 
415 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
416 
417 
418 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
419 
420 /**
421  * @dev Interface of the ERC165 standard, as defined in the
422  * https://eips.ethereum.org/EIPS/eip-165[EIP].
423  *
424  * Implementers can declare support of contract interfaces, which can then be
425  * queried by others ({ERC165Checker}).
426  *
427  * For an implementation, see {ERC165}.
428  */
429 interface IERC165 {
430     /**
431      * @dev Returns true if this contract implements the interface defined by
432      * `interfaceId`. See the corresponding
433      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
434      * to learn more about how these ids are created.
435      *
436      * This function call must use less than 30 000 gas.
437      */
438     function supportsInterface(bytes4 interfaceId) external view returns (bool);
439 }
440 
441 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
442 
443 
444 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
445 
446 
447 /**
448  * @dev Implementation of the {IERC165} interface.
449  *
450  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
451  * for the additional interface id that will be supported. For example:
452  *
453  * ```solidity
454  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
455  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
456  * }
457  * ```
458  *
459  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
460  */
461 abstract contract ERC165 is IERC165 {
462     /**
463      * @dev See {IERC165-supportsInterface}.
464      */
465     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
466         return interfaceId == type(IERC165).interfaceId;
467     }
468 }
469 
470 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
474 
475 
476 /**
477  * @dev Required interface of an ERC721 compliant contract.
478  */
479 interface IERC721 is IERC165 {
480     /**
481      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
482      */
483     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
484 
485     /**
486      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
487      */
488     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
489 
490     /**
491      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
492      */
493     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
494 
495     /**
496      * @dev Returns the number of tokens in ``owner``'s account.
497      */
498     function balanceOf(address owner) external view returns (uint256 balance);
499 
500     /**
501      * @dev Returns the owner of the `tokenId` token.
502      *
503      * Requirements:
504      *
505      * - `tokenId` must exist.
506      */
507     function ownerOf(uint256 tokenId) external view returns (address owner);
508 
509     /**
510      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
511      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
512      *
513      * Requirements:
514      *
515      * - `from` cannot be the zero address.
516      * - `to` cannot be the zero address.
517      * - `tokenId` token must exist and be owned by `from`.
518      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
519      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
520      *
521      * Emits a {Transfer} event.
522      */
523     function safeTransferFrom(
524         address from,
525         address to,
526         uint256 tokenId
527     ) external;
528 
529     /**
530      * @dev Transfers `tokenId` token from `from` to `to`.
531      *
532      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
533      *
534      * Requirements:
535      *
536      * - `from` cannot be the zero address.
537      * - `to` cannot be the zero address.
538      * - `tokenId` token must be owned by `from`.
539      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
540      *
541      * Emits a {Transfer} event.
542      */
543     function transferFrom(
544         address from,
545         address to,
546         uint256 tokenId
547     ) external;
548 
549     /**
550      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
551      * The approval is cleared when the token is transferred.
552      *
553      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
554      *
555      * Requirements:
556      *
557      * - The caller must own the token or be an approved operator.
558      * - `tokenId` must exist.
559      *
560      * Emits an {Approval} event.
561      */
562     function approve(address to, uint256 tokenId) external;
563 
564     /**
565      * @dev Returns the account approved for `tokenId` token.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      */
571     function getApproved(uint256 tokenId) external view returns (address operator);
572 
573     /**
574      * @dev Approve or remove `operator` as an operator for the caller.
575      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
576      *
577      * Requirements:
578      *
579      * - The `operator` cannot be the caller.
580      *
581      * Emits an {ApprovalForAll} event.
582      */
583     function setApprovalForAll(address operator, bool _approved) external;
584 
585     /**
586      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
587      *
588      * See {setApprovalForAll}
589      */
590     function isApprovedForAll(address owner, address operator) external view returns (bool);
591 
592     /**
593      * @dev Safely transfers `tokenId` token from `from` to `to`.
594      *
595      * Requirements:
596      *
597      * - `from` cannot be the zero address.
598      * - `to` cannot be the zero address.
599      * - `tokenId` token must exist and be owned by `from`.
600      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
601      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
602      *
603      * Emits a {Transfer} event.
604      */
605     function safeTransferFrom(
606         address from,
607         address to,
608         uint256 tokenId,
609         bytes calldata data
610     ) external;
611 }
612 
613 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
614 
615 
616 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
617 
618 
619 /**
620  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
621  * @dev See https://eips.ethereum.org/EIPS/eip-721
622  */
623 interface IERC721Enumerable is IERC721 {
624     /**
625      * @dev Returns the total amount of tokens stored by the contract.
626      */
627     function totalSupply() external view returns (uint256);
628 
629     /**
630      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
631      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
632      */
633     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
634 
635     /**
636      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
637      * Use along with {totalSupply} to enumerate all tokens.
638      */
639     function tokenByIndex(uint256 index) external view returns (uint256);
640 }
641 
642 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
643 
644 
645 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
646 
647 /**
648  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
649  * @dev See https://eips.ethereum.org/EIPS/eip-721
650  */
651 interface IERC721Metadata is IERC721 {
652     /**
653      * @dev Returns the token collection name.
654      */
655     function name() external view returns (string memory);
656 
657     /**
658      * @dev Returns the token collection symbol.
659      */
660     function symbol() external view returns (string memory);
661 
662     /**
663      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
664      */
665     function tokenURI(uint256 tokenId) external view returns (string memory);
666 }
667 
668 /**
669  * @title SafeMath
670  * @dev Unsigned math operations with safety checks that revert on error
671  */
672 library SafeMath {
673 
674   /**
675    * @dev Multiplies two unsigned integers, reverts on overflow.
676    */
677   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
678     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
679     // benefit is lost if 'b' is also tested.
680     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
681     if (a == 0) {
682       return 0;
683     }
684 
685     uint256 c = a * b;
686     require(c / a == b, "SafeMath#mul: OVERFLOW");
687 
688     return c;
689   }
690 
691   /**
692    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
693    */
694   function div(uint256 a, uint256 b) internal pure returns (uint256) {
695     // Solidity only automatically asserts when dividing by 0
696     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
697     uint256 c = a / b;
698     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
699 
700     return c;
701   }
702 
703   /**
704    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
705    */
706   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
707     require(b <= a, "SafeMath#sub: UNDERFLOW");
708     uint256 c = a - b;
709 
710     return c;
711   }
712 
713   /**
714    * @dev Adds two unsigned integers, reverts on overflow.
715    */
716   function add(uint256 a, uint256 b) internal pure returns (uint256) {
717     uint256 c = a + b;
718     require(c >= a, "SafeMath#add: OVERFLOW");
719 
720     return c; 
721   }
722 
723   /**
724    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
725    * reverts when dividing by zero.
726    */
727   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
728     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
729     return a % b;
730   }
731 
732 }
733 
734 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
735 
736 
737 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
738 
739 
740 
741 
742 
743 
744 
745 /**
746  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
747  * the Metadata extension, but not including the Enumerable extension, which is available separately as
748  * {ERC721Enumerable}.
749  */
750 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
751     using Address for address;
752     using Strings for uint256;
753 
754     // Token name
755     string private _name;
756 
757     // Token symbol
758     string private _symbol;
759 
760     // Mapping from token ID to owner address
761     mapping(uint256 => address) private _owners;
762 
763     // Mapping owner address to token count
764     mapping(address => uint256) private _balances;
765 
766     // Mapping from token ID to approved address
767     mapping(uint256 => address) private _tokenApprovals;
768 
769     // Mapping from owner to operator approvals
770     mapping(address => mapping(address => bool)) private _operatorApprovals;
771 
772     /**
773      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
774      */
775     constructor(string memory name_, string memory symbol_) {
776         _name = name_;
777         _symbol = symbol_;
778     }
779 
780     /**
781      * @dev See {IERC165-supportsInterface}.
782      */
783     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
784         return
785             interfaceId == type(IERC721).interfaceId ||
786             interfaceId == type(IERC721Metadata).interfaceId ||
787             super.supportsInterface(interfaceId);
788     }
789 
790     /**
791      * @dev See {IERC721-balanceOf}.
792      */
793     function balanceOf(address owner) public view virtual override returns (uint256) {
794         require(owner != address(0), "ERC721: balance query for the zero address");
795         return _balances[owner];
796     }
797 
798     /**
799      * @dev See {IERC721-ownerOf}.
800      */
801     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
802         address owner = _owners[tokenId];
803         require(owner != address(0), "ERC721: owner query for nonexistent token");
804         return owner;
805     }
806 
807     /**
808      * @dev See {IERC721Metadata-name}.
809      */
810     function name() public view virtual override returns (string memory) {
811         return _name;
812     }
813 
814     /**
815      * @dev See {IERC721Metadata-symbol}.
816      */
817     function symbol() public view virtual override returns (string memory) {
818         return _symbol;
819     }
820 
821     /**
822      * @dev See {IERC721Metadata-tokenURI}.
823      */
824     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
825         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
826 
827         string memory baseURI = _baseURI();
828         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
829     }
830 
831     /**
832      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
833      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
834      * by default, can be overriden in child contracts.
835      */
836     function _baseURI() internal view virtual returns (string memory) {
837         return "";
838     }
839 
840     /**
841      * @dev See {IERC721-approve}.
842      */
843     function approve(address to, uint256 tokenId) public virtual override {
844         address owner = ERC721.ownerOf(tokenId);
845         require(to != owner, "ERC721: approval to current owner");
846 
847         require(
848             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
849             "ERC721: approve caller is not owner nor approved for all"
850         );
851 
852         _approve(to, tokenId);
853     }
854 
855     /**
856      * @dev See {IERC721-getApproved}.
857      */
858     function getApproved(uint256 tokenId) public view virtual override returns (address) {
859         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
860 
861         return _tokenApprovals[tokenId];
862     }
863 
864     /**
865      * @dev See {IERC721-setApprovalForAll}.
866      */
867     function setApprovalForAll(address operator, bool approved) public virtual override {
868         _setApprovalForAll(_msgSender(), operator, approved);
869     }
870 
871     /**
872      * @dev See {IERC721-isApprovedForAll}.
873      */
874     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
875         return _operatorApprovals[owner][operator];
876     }
877 
878     /**
879      * @dev See {IERC721-transferFrom}.
880      */
881     function transferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) public virtual override {
886         //solhint-disable-next-line max-line-length
887         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
888 
889         _transfer(from, to, tokenId);
890     }
891 
892     /**
893      * @dev See {IERC721-safeTransferFrom}.
894      */
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId
899     ) public virtual override {
900         safeTransferFrom(from, to, tokenId, "");
901     }
902 
903     /**
904      * @dev See {IERC721-safeTransferFrom}.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) public virtual override {
912         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
913         _safeTransfer(from, to, tokenId, _data);
914     }
915 
916     /**
917      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
918      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
919      *
920      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
921      *
922      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
923      * implement alternative mechanisms to perform token transfer, such as signature-based.
924      *
925      * Requirements:
926      *
927      * - `from` cannot be the zero address.
928      * - `to` cannot be the zero address.
929      * - `tokenId` token must exist and be owned by `from`.
930      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _safeTransfer(
935         address from,
936         address to,
937         uint256 tokenId,
938         bytes memory _data
939     ) internal virtual {
940         _transfer(from, to, tokenId);
941         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
942     }
943 
944     /**
945      * @dev Returns whether `tokenId` exists.
946      *
947      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
948      *
949      * Tokens start existing when they are minted (`_mint`),
950      * and stop existing when they are burned (`_burn`).
951      */
952     function _exists(uint256 tokenId) internal view virtual returns (bool) {
953         return _owners[tokenId] != address(0);
954     }
955 
956     /**
957      * @dev Returns whether `spender` is allowed to manage `tokenId`.
958      *
959      * Requirements:
960      *
961      * - `tokenId` must exist.
962      */
963     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
964         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
965         address owner = ERC721.ownerOf(tokenId);
966         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
967     }
968 
969     /**
970      * @dev Safely mints `tokenId` and transfers it to `to`.
971      *
972      * Requirements:
973      *
974      * - `tokenId` must not exist.
975      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _safeMint(address to, uint256 tokenId) internal virtual {
980         _safeMint(to, tokenId, "");
981     }
982 
983     /**
984      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
985      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
986      */
987     function _safeMint(
988         address to,
989         uint256 tokenId,
990         bytes memory _data
991     ) internal virtual {
992         _mint(to, tokenId);
993         require(
994             _checkOnERC721Received(address(0), to, tokenId, _data),
995             "ERC721: transfer to non ERC721Receiver implementer"
996         );
997     }
998 
999     /**
1000      * @dev Mints `tokenId` and transfers it to `to`.
1001      *
1002      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1003      *
1004      * Requirements:
1005      *
1006      * - `tokenId` must not exist.
1007      * - `to` cannot be the zero address.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _mint(address to, uint256 tokenId) internal virtual {
1012         require(to != address(0), "ERC721: mint to the zero address");
1013         require(!_exists(tokenId), "ERC721: token already minted");
1014 
1015         _beforeTokenTransfer(address(0), to, tokenId);
1016 
1017         _balances[to] += 1;
1018         _owners[tokenId] = to;
1019 
1020         emit Transfer(address(0), to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev Destroys `tokenId`.
1025      * The approval is cleared when the token is burned.
1026      *
1027      * Requirements:
1028      *
1029      * - `tokenId` must exist.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function _burn(uint256 tokenId) internal virtual {
1034         address owner = ERC721.ownerOf(tokenId);
1035 
1036         _beforeTokenTransfer(owner, address(0), tokenId);
1037 
1038         // Clear approvals
1039         _approve(address(0), tokenId);
1040 
1041         _balances[owner] -= 1;
1042         delete _owners[tokenId];
1043 
1044         emit Transfer(owner, address(0), tokenId);
1045     }
1046 
1047     /**
1048      * @dev Transfers `tokenId` from `from` to `to`.
1049      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1050      *
1051      * Requirements:
1052      *
1053      * - `to` cannot be the zero address.
1054      * - `tokenId` token must be owned by `from`.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function _transfer(
1059         address from,
1060         address to,
1061         uint256 tokenId
1062     ) internal virtual {
1063         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1064         require(to != address(0), "ERC721: transfer to the zero address");
1065 
1066         _beforeTokenTransfer(from, to, tokenId);
1067 
1068         // Clear approvals from the previous owner
1069         _approve(address(0), tokenId);
1070 
1071         _balances[from] -= 1;
1072         _balances[to] += 1;
1073         _owners[tokenId] = to;
1074 
1075         emit Transfer(from, to, tokenId);
1076     }
1077 
1078     /**
1079      * @dev Approve `to` to operate on `tokenId`
1080      *
1081      * Emits a {Approval} event.
1082      */
1083     function _approve(address to, uint256 tokenId) internal virtual {
1084         _tokenApprovals[tokenId] = to;
1085         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1086     }
1087 
1088     /**
1089      * @dev Approve `operator` to operate on all of `owner` tokens
1090      *
1091      * Emits a {ApprovalForAll} event.
1092      */
1093     function _setApprovalForAll(
1094         address owner,
1095         address operator,
1096         bool approved
1097     ) internal virtual {
1098         require(owner != operator, "ERC721: approve to caller");
1099         _operatorApprovals[owner][operator] = approved;
1100         emit ApprovalForAll(owner, operator, approved);
1101     }
1102 
1103     /**
1104      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1105      * The call is not executed if the target address is not a contract.
1106      *
1107      * @param from address representing the previous owner of the given token ID
1108      * @param to target address that will receive the tokens
1109      * @param tokenId uint256 ID of the token to be transferred
1110      * @param _data bytes optional data to send along with the call
1111      * @return bool whether the call correctly returned the expected magic value
1112      */
1113     function _checkOnERC721Received(
1114         address from,
1115         address to,
1116         uint256 tokenId,
1117         bytes memory _data
1118     ) private returns (bool) {
1119         if (to.isContract()) {
1120             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1121                 return retval == IERC721Receiver.onERC721Received.selector;
1122             } catch (bytes memory reason) {
1123                 if (reason.length == 0) {
1124                     revert("ERC721: transfer to non ERC721Receiver implementer");
1125                 } else {
1126                     assembly {
1127                         revert(add(32, reason), mload(reason))
1128                     }
1129                 }
1130             }
1131         } else {
1132             return true;
1133         }
1134     }
1135 
1136     /**
1137      * @dev Hook that is called before any token transfer. This includes minting
1138      * and burning.
1139      *
1140      * Calling conditions:
1141      *
1142      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1143      * transferred to `to`.
1144      * - When `from` is zero, `tokenId` will be minted for `to`.
1145      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1146      * - `from` and `to` are never both zero.
1147      *
1148      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1149      */
1150     function _beforeTokenTransfer(
1151         address from,
1152         address to,
1153         uint256 tokenId
1154     ) internal virtual {}
1155 }
1156 
1157 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1158 
1159 
1160 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1161 
1162 
1163 
1164 /**
1165  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1166  * enumerability of all the token ids in the contract as well as all token ids owned by each
1167  * account.
1168  */
1169 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1170     // Mapping from owner to list of owned token IDs
1171     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1172 
1173     // Mapping from token ID to index of the owner tokens list
1174     mapping(uint256 => uint256) private _ownedTokensIndex;
1175 
1176     // Array with all token ids, used for enumeration
1177     uint256[] private _allTokens;
1178 
1179     // Mapping from token id to position in the allTokens array
1180     mapping(uint256 => uint256) private _allTokensIndex;
1181 
1182     /**
1183      * @dev See {IERC165-supportsInterface}.
1184      */
1185     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1186         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1187     }
1188 
1189     /**
1190      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1191      */
1192     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1193         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1194         return _ownedTokens[owner][index];
1195     }
1196 
1197     /**
1198      * @dev See {IERC721Enumerable-totalSupply}.
1199      */
1200     function totalSupply() public view virtual override returns (uint256) {
1201         return _allTokens.length;
1202     }
1203 
1204     /**
1205      * @dev See {IERC721Enumerable-tokenByIndex}.
1206      */
1207     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1208         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1209         return _allTokens[index];
1210     }
1211 
1212     /**
1213      * @dev Hook that is called before any token transfer. This includes minting
1214      * and burning.
1215      *
1216      * Calling conditions:
1217      *
1218      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1219      * transferred to `to`.
1220      * - When `from` is zero, `tokenId` will be minted for `to`.
1221      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1222      * - `from` cannot be the zero address.
1223      * - `to` cannot be the zero address.
1224      *
1225      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1226      */
1227     function _beforeTokenTransfer(
1228         address from,
1229         address to,
1230         uint256 tokenId
1231     ) internal virtual override {
1232         super._beforeTokenTransfer(from, to, tokenId);
1233 
1234         if (from == address(0)) {
1235             _addTokenToAllTokensEnumeration(tokenId);
1236         } else if (from != to) {
1237             _removeTokenFromOwnerEnumeration(from, tokenId);
1238         }
1239         if (to == address(0)) {
1240             _removeTokenFromAllTokensEnumeration(tokenId);
1241         } else if (to != from) {
1242             _addTokenToOwnerEnumeration(to, tokenId);
1243         }
1244     }
1245 
1246     /**
1247      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1248      * @param to address representing the new owner of the given token ID
1249      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1250      */
1251     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1252         uint256 length = ERC721.balanceOf(to);
1253         _ownedTokens[to][length] = tokenId;
1254         _ownedTokensIndex[tokenId] = length;
1255     }
1256 
1257     /**
1258      * @dev Private function to add a token to this extension's token tracking data structures.
1259      * @param tokenId uint256 ID of the token to be added to the tokens list
1260      */
1261     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1262         _allTokensIndex[tokenId] = _allTokens.length;
1263         _allTokens.push(tokenId);
1264     }
1265 
1266     /**
1267      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1268      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1269      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1270      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1271      * @param from address representing the previous owner of the given token ID
1272      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1273      */
1274     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1275         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1276         // then delete the last slot (swap and pop).
1277 
1278         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1279         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1280 
1281         // When the token to delete is the last token, the swap operation is unnecessary
1282         if (tokenIndex != lastTokenIndex) {
1283             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1284 
1285             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1286             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1287         }
1288 
1289         // This also deletes the contents at the last position of the array
1290         delete _ownedTokensIndex[tokenId];
1291         delete _ownedTokens[from][lastTokenIndex];
1292     }
1293 
1294     /**
1295      * @dev Private function to remove a token from this extension's token tracking data structures.
1296      * This has O(1) time complexity, but alters the order of the _allTokens array.
1297      * @param tokenId uint256 ID of the token to be removed from the tokens list
1298      */
1299     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1300         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1301         // then delete the last slot (swap and pop).
1302 
1303         uint256 lastTokenIndex = _allTokens.length - 1;
1304         uint256 tokenIndex = _allTokensIndex[tokenId];
1305 
1306         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1307         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1308         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1309         uint256 lastTokenId = _allTokens[lastTokenIndex];
1310 
1311         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1312         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1313 
1314         // This also deletes the contents at the last position of the array
1315         delete _allTokensIndex[tokenId];
1316         _allTokens.pop();
1317     }
1318 }
1319 
1320 // File: contracts/drcc.sol
1321 
1322 
1323 
1324 contract DurianciClubNFT is ERC721Enumerable, Ownable {
1325     using Strings for uint256;
1326     using SafeMath for uint256;
1327 
1328     string public baseURI;
1329     string public baseExtension = ".json";
1330     string public notRevealedUri;
1331     uint256 public cost = 0.05 ether;
1332     uint256 public maxSupply = 10000;
1333     uint256 public phaseSellingLimit1 = 3300;
1334     uint256 public phaseSellingLimit2 = 3300;
1335     uint256 public phaseSellingLimit3 = 2920;
1336     uint256 public totalmint1 = 0;
1337     uint256 public totalmint2 = 0;
1338     uint256 public totalmint3 = 0;
1339     uint256 public presalesMaxToken = 2;
1340     bool public paused = false;
1341     bool public revealed = false;
1342     uint256 private totalReserve = 480;
1343     uint256 private reserved = 0;
1344     uint256 private sold = 0;
1345     uint16 public salesStage = 1; //1-presales1 , 2-presales2 , 3-presales3 , 4-public
1346     address payable companyWallet;
1347     address private signerAddress = 0xD6321754CdFDd74298F68e79E0c09b93E2dB15d0;
1348     mapping(address => uint256) public addressMintedBalance;
1349     mapping (uint256 => bool) public reserveNo;
1350     mapping(uint256 => uint256) private _presalesPrice;
1351     mapping(address => uint256) public presales1minted; // To check how many tokens an address has minted during presales
1352     mapping(address => uint256) public presales2minted; // To check how many tokens an address has minted during presales
1353     mapping(address => uint256) public presales3minted; // To check how many tokens an address has minted during presales
1354     mapping(address => uint256) public presales4minted; // To check how many tokens an address has minted during presales
1355     mapping(address => uint256) public minted; // To check how many tokens an address has minted
1356     mapping (uint256 => address) public creators;
1357     
1358 
1359     event URI(string _amount, uint256 indexed _id);
1360     event CurrentSalesStage(uint indexed _salesstage, uint256 indexed _id);
1361 
1362     constructor(
1363     ) ERC721("Durianci Club NFT", "DRCC NFT") {
1364         setBaseURI("https://api.durianci.club/nft/");
1365         setNotRevealedURI("https://api.durianci.club/nft/");
1366     }
1367 
1368     // internal
1369     function _baseURI() internal view virtual override returns (string memory) {
1370         return baseURI;
1371     }
1372 
1373     /**
1374     * @dev Creates a new token type and assigns _initialSupply to an address
1375     * NOTE: remove onlyOwner if you want third parties to create new tokens on your contract (which may change your IDs)
1376     * @param _initialOwner address of the first owner of the token
1377     * @param _initialSupply amount to supply the first owner
1378     * @param _uri Optional URI for this token type
1379     * @return The newly created token ID
1380     */
1381     function reserve(
1382         address _initialOwner,
1383         uint256 _initialSupply,
1384         string memory _uri
1385         // bytes memory _data
1386     ) public onlyOwner returns (uint256) {
1387         require(reserved + _initialSupply <= totalReserve, "Reserve Empty");
1388 
1389         sold += _initialSupply;
1390         
1391         for (uint256 i = 0; i < _initialSupply; i++) {
1392             uint256 supply = reserved;
1393             reserved++;
1394             uint256 _id = reserved;
1395 
1396             if (bytes(_uri).length > 0) {
1397                 emit URI(_uri, _id);
1398             }
1399 
1400             creators[_id] = msg.sender;
1401             _safeMint(_initialOwner, supply + 1);
1402         }
1403         return 0;
1404     }
1405 
1406      // Function to receive Ether. msg.data must be empty
1407     receive() external payable {}
1408 
1409     // Fallback function is called when msg.data is not empty
1410     fallback() external payable {}
1411 
1412     function presales(
1413         address _initialOwner,
1414         uint256 _mintAmount,
1415         bytes calldata _sig
1416         // bytes calldata _data
1417     ) external payable returns (uint256) {
1418         
1419         require(salesStage == 1 || salesStage == 2 || salesStage == 3, "Presales is closed");
1420         if(salesStage == 1){
1421             require(presales1minted[_initialOwner] + _mintAmount <= presalesMaxToken, "Max 2 Token Per User");
1422             require(totalmint1 + _mintAmount <= phaseSellingLimit1, "phase NFT limit exceeded");
1423             totalmint1 += _mintAmount;
1424         }else if(salesStage == 2){
1425             require(presales2minted[_initialOwner] + _mintAmount <= presalesMaxToken, "Max 2 Token Per User");
1426             require(totalmint2 + _mintAmount <= phaseSellingLimit2, "phase NFT limit exceeded");
1427             totalmint2 += _mintAmount;
1428         }else if(salesStage == 3){
1429             require(presales3minted[_initialOwner] + _mintAmount <= presalesMaxToken, "Max 2 Token Per User");
1430             require(totalmint3 + _mintAmount <= phaseSellingLimit3, "phase NFT limit exceeded");
1431             totalmint3 += _mintAmount;
1432         }
1433         uint256 supply = totalSupply().add(totalReserve).sub(reserved);
1434         require(_mintAmount > 0, "need to mint at least 1 NFT");
1435         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1436         require(minted[_initialOwner] + _mintAmount <= maxSupply, "Max Token Per User");
1437         require(isValidData(addressToString(_initialOwner), _sig), addressToString(_initialOwner));
1438         
1439         require(msg.value == _mintAmount.mul(cost), "Incorrect msg.value");
1440 
1441         sold += _mintAmount;
1442 
1443         if(salesStage == 1){
1444             presales1minted[_initialOwner] += _mintAmount;
1445         }else if(salesStage == 2){
1446             presales2minted[_initialOwner] += _mintAmount;
1447         }
1448         else if(salesStage == 3){
1449             presales3minted[_initialOwner] += _mintAmount;
1450         }
1451         minted[_initialOwner] += _mintAmount;
1452 
1453         for (uint256 i = 0; i < _mintAmount; i++) {
1454             uint256 _id = totalSupply().add(totalReserve).add(1).sub(reserved);
1455             creators[_id] = _initialOwner;
1456             addressMintedBalance[_initialOwner]++;
1457             _safeMint(_initialOwner, _id);
1458             emit CurrentSalesStage(salesStage, _id);
1459         }
1460 
1461         return 0;
1462     }
1463 
1464     function publicsales(
1465         address _initialOwner,
1466         uint256 _mintAmount,
1467         string calldata _uri
1468         // bytes calldata _data
1469     ) external payable returns (uint256) {
1470         require(salesStage == 4 , "Public Sales Is Closed");
1471         uint256 supply = totalSupply().add(totalReserve).sub(reserved);
1472         require(_mintAmount > 0, "need to mint at least 1 NFT");
1473         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1474         require(presales4minted[_initialOwner] + _mintAmount <= presalesMaxToken, "Max 2 Token Per User");
1475         presales4minted[_initialOwner] += _mintAmount;
1476         require(msg.value == _mintAmount.mul(cost), "Incorrect msg.value");
1477 
1478 
1479         sold += _mintAmount;
1480         minted[_initialOwner] += _mintAmount;
1481 
1482         for (uint256 i = 0; i < _mintAmount; i++) {
1483             uint256 _id = totalSupply().add(totalReserve).add(1).sub(reserved);
1484 
1485             if (bytes(_uri).length > 0) {
1486                 emit URI(_uri, _id);
1487             }
1488 
1489             creators[_id] = _initialOwner;
1490             addressMintedBalance[_initialOwner]++;
1491             _safeMint(_initialOwner, _id);
1492             emit CurrentSalesStage(salesStage, _id);
1493         }
1494         return 0;
1495     }
1496 
1497     function setSalesStage(
1498         uint16 stage
1499     ) public onlyOwner {
1500         salesStage = stage;
1501     }
1502 
1503     function setCompanyWallet(
1504         address payable newWallet
1505     ) public onlyOwner {
1506         companyWallet = newWallet;
1507     }
1508 
1509   
1510     function ownerMint(
1511         address _initialOwner,
1512         uint256 _initialSupply,
1513         string calldata _uri
1514         // bytes calldata _data
1515     ) external onlyOwner returns (uint256) {
1516         require(sold + _initialSupply <= maxSupply, "Max Token Minted");
1517 
1518         sold += _initialSupply;
1519         
1520         for (uint256 i = 0; i < _initialSupply; i++) {
1521             uint256 _id = totalSupply().add(totalReserve).add(1).sub(reserved);
1522 
1523         if (bytes(_uri).length > 0) {
1524             emit URI(_uri, _id);
1525         }
1526 
1527         creators[_id] = msg.sender;
1528         addressMintedBalance[_initialOwner]++;
1529         _safeMint(_initialOwner, _id);
1530         emit CurrentSalesStage(salesStage, _id);
1531         }
1532         return 0;
1533     }
1534     
1535 
1536     function walletOfOwner(address _owner)
1537         public
1538         view
1539         returns (uint256[] memory)
1540     {
1541         uint256 ownerTokenCount = balanceOf(_owner);
1542         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1543         for (uint256 i; i < ownerTokenCount; i++) {
1544         tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1545         }
1546         return tokenIds;
1547     }
1548 
1549 
1550     function tokenURI(uint256 tokenId)
1551         public
1552         view
1553         virtual
1554         override
1555         returns (string memory)
1556     {
1557         require(
1558         _exists(tokenId),
1559         "ERC721Metadata: URI query for nonexistent token"
1560         );
1561         
1562         if(revealed == false) {
1563             return notRevealedUri;
1564         }
1565 
1566         string memory currentBaseURI = _baseURI();
1567         return bytes(currentBaseURI).length > 0
1568             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1569             : "";
1570     }
1571 
1572     //only owner
1573     function reveal() public onlyOwner() {
1574         revealed = true;
1575     }
1576     
1577     function setPhaseSellingLimit1(uint256 _newAmount) public onlyOwner() {
1578         phaseSellingLimit1 = _newAmount;
1579     }
1580 
1581     function setPhaseSellingLimit2(uint256 _newAmount) public onlyOwner() {
1582         phaseSellingLimit2 = _newAmount;
1583     }
1584 
1585     function setPhaseSellingLimit3(uint256 _newAmount) public onlyOwner() {
1586         phaseSellingLimit3 = _newAmount;
1587     }
1588 
1589     function setNFTPrice(uint256 _newAmount) public onlyOwner() {
1590         cost = _newAmount;
1591     }
1592 
1593     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1594         baseURI = _newBaseURI;
1595     }
1596 
1597     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1598         baseExtension = _newBaseExtension;
1599     }
1600     
1601     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1602         notRevealedUri = _notRevealedURI;
1603     }
1604 
1605     function pause(bool _state) public onlyOwner {
1606         paused = _state;
1607     }
1608     
1609     function withdraw() public payable onlyOwner {
1610         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1611         require(success);
1612     }
1613 
1614     function toBytes(address a) public pure returns (bytes memory b){
1615     assembly {
1616         let m := mload(0x40)
1617         a := and(a, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
1618         mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, a))
1619         mstore(0x40, add(m, 52))
1620         b := m
1621         }
1622     }
1623 
1624     function addressToString(address _addr) public pure returns(string memory) {
1625         bytes32 value = bytes32(uint(uint160(_addr)));
1626         bytes memory alphabet = "0123456789abcdef";
1627 
1628         bytes memory str = new bytes(42);
1629         str[0] = "0";
1630         str[1] = "x";
1631         for (uint i = 0; i < 20; i++) {
1632             str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
1633             str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
1634         }
1635         return string(str);
1636     }
1637 
1638     function toAsciiString(address x) public pure returns (string memory) {
1639         bytes memory s = new bytes(40);
1640         for (uint i = 0; i < 20; i++) {
1641             bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
1642             bytes1 hi = bytes1(uint8(b) / 16);
1643             bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
1644             s[2*i] = char(hi);
1645             s[2*i+1] = char(lo);            
1646         }
1647         return string(s);
1648     }
1649 
1650 
1651     function char(
1652         bytes1 b
1653         ) internal pure returns (bytes1 c) {
1654         if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
1655         else return bytes1(uint8(b) + 0x57);
1656     }
1657 
1658     function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
1659         uint8 i = 0;
1660         bytes memory bytesArray = new bytes(64);
1661         for (i = 0; i < bytesArray.length; i++) {
1662 
1663             uint8 _f = uint8(_bytes32[i/2] & 0x0f);
1664             uint8 _l = uint8(_bytes32[i/2] >> 4);
1665 
1666             bytesArray[i] = toByte(_f);
1667             i = i + 1;
1668             bytesArray[i] = toByte(_l);
1669         }
1670         return string(bytesArray);
1671     }
1672 
1673     function stringToBytes32(string memory source) public pure returns (bytes32 result) {
1674         bytes memory tempEmptyStringTest = bytes(source);
1675         if (tempEmptyStringTest.length == 0) {
1676             return 0x0;
1677         }
1678 
1679         assembly {
1680             result := mload(add(source, 32))
1681         }
1682     }
1683 
1684     function splitSignature(bytes memory sig)
1685         public
1686         pure
1687         returns (uint8, bytes32, bytes32)
1688     {
1689         require(sig.length == 65);
1690 
1691         bytes32 r;
1692         bytes32 s;
1693         uint8 v;
1694 
1695         assembly {
1696             // first 32 bytes, after the length prefix
1697             r := mload(add(sig, 32))
1698             // second 32 bytes
1699             s := mload(add(sig, 64))
1700             // final byte (first byte of the next 32 bytes)
1701             v := byte(0, mload(add(sig, 96)))
1702         }
1703         
1704         return (v, r, s);
1705     }
1706 
1707     function recoverSigner(bytes32 message, bytes memory sig)
1708         public
1709         pure
1710         returns (address)
1711         {
1712         uint8 v;
1713         bytes32 r;
1714         bytes32 s;
1715 
1716         (v, r, s) = splitSignature(sig);
1717         return ecrecover(message, v, r, s);
1718     }
1719   
1720     function isValidData(string memory _word, bytes memory sig) public view returns(bool){
1721         bytes32 message = keccak256(abi.encodePacked(_word));
1722         return (recoverSigner(message, sig) == signerAddress);
1723     }
1724 
1725 
1726     function toByte(uint8 _uint8) public pure returns (bytes1) {
1727         if(_uint8 < 10) {
1728             return bytes1(_uint8 + 48);
1729         } else {
1730             return bytes1(_uint8 + 87);
1731         }
1732     }
1733 }