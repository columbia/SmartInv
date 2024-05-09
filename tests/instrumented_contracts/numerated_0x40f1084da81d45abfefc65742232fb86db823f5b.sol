1 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 /*
7 
8 d888888b db   db d88888b      d8888b. d88888b  d888b  d88888b d8b   db       .d8b.  d8888b. d88888b .d8888. 
9 `~~88~~' 88   88 88'          88  `8D 88'     88' Y8b 88'     888o  88      d8' `8b 88  `8D 88'     88'  YP 
10    88    88ooo88 88ooooo      88   88 88ooooo 88      88ooooo 88V8o 88      88ooo88 88oodD' 88ooooo `8bo.   
11    88    88~~~88 88~~~~~      88   88 88~~~~~ 88  ooo 88~~~~~ 88 V8o88      88~~~88 88~~~   88~~~~~   `Y8b. 
12    88    88   88 88.          88  .8D 88.     88. ~8~ 88.     88  V888      88   88 88      88.     db   8D 
13    YP    YP   YP Y88888P      Y8888D' Y88888P  Y888P  Y88888P VP   V8P      YP   YP 88      Y88888P `8888Y' 
14                                                                                                             
15 */
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 
40 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
41 
42 
43 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
44 
45 
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  *
52  * By default, the owner account will be the one that deploys the contract. This
53  * can later be changed with {transferOwnership}.
54  *
55  * This module is used through inheritance. It will make available the modifier
56  * `onlyOwner`, which can be applied to your functions to restrict their use to
57  * the owner.
58  */
59 abstract contract Ownable is Context {
60     address private _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @dev Initializes the contract setting the deployer as the initial owner.
66      */
67     constructor() {
68         _transferOwnership(_msgSender());
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Internal function without access restriction.
109      */
110     function _transferOwnership(address newOwner) internal virtual {
111         address oldOwner = _owner;
112         _owner = newOwner;
113         emit OwnershipTransferred(oldOwner, newOwner);
114     }
115 }
116 
117 
118 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
122 
123 
124 
125 /**
126  * @dev String operations.
127  */
128 library Strings {
129     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
130 
131     /**
132      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
133      */
134     function toString(uint256 value) internal pure returns (string memory) {
135         // Inspired by OraclizeAPI's implementation - MIT licence
136         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
137 
138         if (value == 0) {
139             return "0";
140         }
141         uint256 temp = value;
142         uint256 digits;
143         while (temp != 0) {
144             digits++;
145             temp /= 10;
146         }
147         bytes memory buffer = new bytes(digits);
148         while (value != 0) {
149             digits -= 1;
150             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
151             value /= 10;
152         }
153         return string(buffer);
154     }
155 
156     /**
157      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
158      */
159     function toHexString(uint256 value) internal pure returns (string memory) {
160         if (value == 0) {
161             return "0x00";
162         }
163         uint256 temp = value;
164         uint256 length = 0;
165         while (temp != 0) {
166             length++;
167             temp >>= 8;
168         }
169         return toHexString(value, length);
170     }
171 
172     /**
173      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
174      */
175     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
176         bytes memory buffer = new bytes(2 * length + 2);
177         buffer[0] = "0";
178         buffer[1] = "x";
179         for (uint256 i = 2 * length + 1; i > 1; --i) {
180             buffer[i] = _HEX_SYMBOLS[value & 0xf];
181             value >>= 4;
182         }
183         require(value == 0, "Strings: hex length insufficient");
184         return string(buffer);
185     }
186 }
187 
188 
189 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
190 
191 
192 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
193 
194 
195 
196 /**
197  * @dev Interface of the ERC165 standard, as defined in the
198  * https://eips.ethereum.org/EIPS/eip-165[EIP].
199  *
200  * Implementers can declare support of contract interfaces, which can then be
201  * queried by others ({ERC165Checker}).
202  *
203  * For an implementation, see {ERC165}.
204  */
205 interface IERC165 {
206     /**
207      * @dev Returns true if this contract implements the interface defined by
208      * `interfaceId`. See the corresponding
209      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
210      * to learn more about how these ids are created.
211      *
212      * This function call must use less than 30 000 gas.
213      */
214     function supportsInterface(bytes4 interfaceId) external view returns (bool);
215 }
216 
217 
218 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
219 
220 
221 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
222 
223 
224 
225 /**
226  * @dev Required interface of an ERC721 compliant contract.
227  */
228 interface IERC721 is IERC165 {
229     /**
230      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
231      */
232     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
233 
234     /**
235      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
236      */
237     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
238 
239     /**
240      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
241      */
242     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
243 
244     /**
245      * @dev Returns the number of tokens in ``owner``'s account.
246      */
247     function balanceOf(address owner) external view returns (uint256 balance);
248 
249     /**
250      * @dev Returns the owner of the `tokenId` token.
251      *
252      * Requirements:
253      *
254      * - `tokenId` must exist.
255      */
256     function ownerOf(uint256 tokenId) external view returns (address owner);
257 
258     /**
259      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
260      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
261      *
262      * Requirements:
263      *
264      * - `from` cannot be the zero address.
265      * - `to` cannot be the zero address.
266      * - `tokenId` token must exist and be owned by `from`.
267      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
268      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
269      *
270      * Emits a {Transfer} event.
271      */
272     function safeTransferFrom(
273         address from,
274         address to,
275         uint256 tokenId
276     ) external;
277 
278     /**
279      * @dev Transfers `tokenId` token from `from` to `to`.
280      *
281      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
282      *
283      * Requirements:
284      *
285      * - `from` cannot be the zero address.
286      * - `to` cannot be the zero address.
287      * - `tokenId` token must be owned by `from`.
288      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
289      *
290      * Emits a {Transfer} event.
291      */
292     function transferFrom(
293         address from,
294         address to,
295         uint256 tokenId
296     ) external;
297 
298     /**
299      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
300      * The approval is cleared when the token is transferred.
301      *
302      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
303      *
304      * Requirements:
305      *
306      * - The caller must own the token or be an approved operator.
307      * - `tokenId` must exist.
308      *
309      * Emits an {Approval} event.
310      */
311     function approve(address to, uint256 tokenId) external;
312 
313     /**
314      * @dev Returns the account approved for `tokenId` token.
315      *
316      * Requirements:
317      *
318      * - `tokenId` must exist.
319      */
320     function getApproved(uint256 tokenId) external view returns (address operator);
321 
322     /**
323      * @dev Approve or remove `operator` as an operator for the caller.
324      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
325      *
326      * Requirements:
327      *
328      * - The `operator` cannot be the caller.
329      *
330      * Emits an {ApprovalForAll} event.
331      */
332     function setApprovalForAll(address operator, bool _approved) external;
333 
334     /**
335      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
336      *
337      * See {setApprovalForAll}
338      */
339     function isApprovedForAll(address owner, address operator) external view returns (bool);
340 
341     /**
342      * @dev Safely transfers `tokenId` token from `from` to `to`.
343      *
344      * Requirements:
345      *
346      * - `from` cannot be the zero address.
347      * - `to` cannot be the zero address.
348      * - `tokenId` token must exist and be owned by `from`.
349      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
350      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
351      *
352      * Emits a {Transfer} event.
353      */
354     function safeTransferFrom(
355         address from,
356         address to,
357         uint256 tokenId,
358         bytes calldata data
359     ) external;
360 }
361 
362 
363 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
364 
365 
366 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
367 
368 
369 
370 /**
371  * @title ERC721 token receiver interface
372  * @dev Interface for any contract that wants to support safeTransfers
373  * from ERC721 asset contracts.
374  */
375 interface IERC721Receiver {
376     /**
377      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
378      * by `operator` from `from`, this function is called.
379      *
380      * It must return its Solidity selector to confirm the token transfer.
381      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
382      *
383      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
384      */
385     function onERC721Received(
386         address operator,
387         address from,
388         uint256 tokenId,
389         bytes calldata data
390     ) external returns (bytes4);
391 }
392 
393 
394 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
398 
399 
400 
401 /**
402  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
403  * @dev See https://eips.ethereum.org/EIPS/eip-721
404  */
405 interface IERC721Metadata is IERC721 {
406     /**
407      * @dev Returns the token collection name.
408      */
409     function name() external view returns (string memory);
410 
411     /**
412      * @dev Returns the token collection symbol.
413      */
414     function symbol() external view returns (string memory);
415 
416     /**
417      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
418      */
419     function tokenURI(uint256 tokenId) external view returns (string memory);
420 }
421 
422 
423 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
424 
425 
426 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
427 
428 
429 
430 /**
431  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
432  * @dev See https://eips.ethereum.org/EIPS/eip-721
433  */
434 interface IERC721Enumerable is IERC721 {
435     /**
436      * @dev Returns the total amount of tokens stored by the contract.
437      */
438     function totalSupply() external view returns (uint256);
439 
440     /**
441      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
442      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
443      */
444     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
445 
446     /**
447      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
448      * Use along with {totalSupply} to enumerate all tokens.
449      */
450     function tokenByIndex(uint256 index) external view returns (uint256);
451 }
452 
453 
454 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
458 
459 
460 
461 /**
462  * @dev Collection of functions related to the address type
463  */
464 library Address {
465     /**
466      * @dev Returns true if `account` is a contract.
467      *
468      * [IMPORTANT]
469      * ====
470      * It is unsafe to assume that an address for which this function returns
471      * false is an externally-owned account (EOA) and not a contract.
472      *
473      * Among others, `isContract` will return false for the following
474      * types of addresses:
475      *
476      *  - an externally-owned account
477      *  - a contract in construction
478      *  - an address where a contract will be created
479      *  - an address where a contract lived, but was destroyed
480      * ====
481      */
482     function isContract(address account) internal view returns (bool) {
483         // This method relies on extcodesize, which returns 0 for contracts in
484         // construction, since the code is only stored at the end of the
485         // constructor execution.
486 
487         uint256 size;
488         assembly {
489             size := extcodesize(account)
490         }
491         return size > 0;
492     }
493 
494     /**
495      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
496      * `recipient`, forwarding all available gas and reverting on errors.
497      *
498      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
499      * of certain opcodes, possibly making contracts go over the 2300 gas limit
500      * imposed by `transfer`, making them unable to receive funds via
501      * `transfer`. {sendValue} removes this limitation.
502      *
503      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
504      *
505      * IMPORTANT: because control is transferred to `recipient`, care must be
506      * taken to not create reentrancy vulnerabilities. Consider using
507      * {ReentrancyGuard} or the
508      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
509      */
510     function sendValue(address payable recipient, uint256 amount) internal {
511         require(address(this).balance >= amount, "Address: insufficient balance");
512 
513         (bool success, ) = recipient.call{value: amount}("");
514         require(success, "Address: unable to send value, recipient may have reverted");
515     }
516 
517     /**
518      * @dev Performs a Solidity function call using a low level `call`. A
519      * plain `call` is an unsafe replacement for a function call: use this
520      * function instead.
521      *
522      * If `target` reverts with a revert reason, it is bubbled up by this
523      * function (like regular Solidity function calls).
524      *
525      * Returns the raw returned data. To convert to the expected return value,
526      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
527      *
528      * Requirements:
529      *
530      * - `target` must be a contract.
531      * - calling `target` with `data` must not revert.
532      *
533      * _Available since v3.1._
534      */
535     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
536         return functionCall(target, data, "Address: low-level call failed");
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
541      * `errorMessage` as a fallback revert reason when `target` reverts.
542      *
543      * _Available since v3.1._
544      */
545     function functionCall(
546         address target,
547         bytes memory data,
548         string memory errorMessage
549     ) internal returns (bytes memory) {
550         return functionCallWithValue(target, data, 0, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but also transferring `value` wei to `target`.
556      *
557      * Requirements:
558      *
559      * - the calling contract must have an ETH balance of at least `value`.
560      * - the called Solidity function must be `payable`.
561      *
562      * _Available since v3.1._
563      */
564     function functionCallWithValue(
565         address target,
566         bytes memory data,
567         uint256 value
568     ) internal returns (bytes memory) {
569         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
574      * with `errorMessage` as a fallback revert reason when `target` reverts.
575      *
576      * _Available since v3.1._
577      */
578     function functionCallWithValue(
579         address target,
580         bytes memory data,
581         uint256 value,
582         string memory errorMessage
583     ) internal returns (bytes memory) {
584         require(address(this).balance >= value, "Address: insufficient balance for call");
585         require(isContract(target), "Address: call to non-contract");
586 
587         (bool success, bytes memory returndata) = target.call{value: value}(data);
588         return verifyCallResult(success, returndata, errorMessage);
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
598         return functionStaticCall(target, data, "Address: low-level static call failed");
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
603      * but performing a static call.
604      *
605      * _Available since v3.3._
606      */
607     function functionStaticCall(
608         address target,
609         bytes memory data,
610         string memory errorMessage
611     ) internal view returns (bytes memory) {
612         require(isContract(target), "Address: static call to non-contract");
613 
614         (bool success, bytes memory returndata) = target.staticcall(data);
615         return verifyCallResult(success, returndata, errorMessage);
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
620      * but performing a delegate call.
621      *
622      * _Available since v3.4._
623      */
624     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
625         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
630      * but performing a delegate call.
631      *
632      * _Available since v3.4._
633      */
634     function functionDelegateCall(
635         address target,
636         bytes memory data,
637         string memory errorMessage
638     ) internal returns (bytes memory) {
639         require(isContract(target), "Address: delegate call to non-contract");
640 
641         (bool success, bytes memory returndata) = target.delegatecall(data);
642         return verifyCallResult(success, returndata, errorMessage);
643     }
644 
645     /**
646      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
647      * revert reason using the provided one.
648      *
649      * _Available since v4.3._
650      */
651     function verifyCallResult(
652         bool success,
653         bytes memory returndata,
654         string memory errorMessage
655     ) internal pure returns (bytes memory) {
656         if (success) {
657             return returndata;
658         } else {
659             // Look for revert reason and bubble it up if present
660             if (returndata.length > 0) {
661                 // The easiest way to bubble the revert reason is using memory via assembly
662 
663                 assembly {
664                     let returndata_size := mload(returndata)
665                     revert(add(32, returndata), returndata_size)
666                 }
667             } else {
668                 revert(errorMessage);
669             }
670         }
671     }
672 }
673 
674 
675 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
679 
680 
681 
682 /**
683  * @dev Implementation of the {IERC165} interface.
684  *
685  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
686  * for the additional interface id that will be supported. For example:
687  *
688  * ```solidity
689  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
690  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
691  * }
692  * ```
693  *
694  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
695  */
696 abstract contract ERC165 is IERC165 {
697     /**
698      * @dev See {IERC165-supportsInterface}.
699      */
700     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
701         return interfaceId == type(IERC165).interfaceId;
702     }
703 }
704 
705 
706 // File contracts/ERC721A.sol
707 
708 
709 // Creator: Chiru Labs
710 
711 
712 /**
713  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
714  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
715  *
716  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
717  *
718  * Does not support burning tokens to address(0).
719  *
720  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
721  */
722 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
723     using Address for address;
724     using Strings for uint256;
725 
726     struct TokenOwnership {
727         address addr;
728         uint64 startTimestamp;
729     }
730 
731     struct AddressData {
732         uint128 balance;
733         uint128 numberMinted;
734     }
735 
736     uint256 internal currentIndex = 1;
737 
738     // Token name
739     string private _name;
740 
741     // Token symbol
742     string private _symbol;
743 
744     // Mapping from token ID to ownership details
745     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
746     mapping(uint256 => TokenOwnership) internal _ownerships;
747 
748     // Mapping owner address to address data
749     mapping(address => AddressData) private _addressData;
750 
751     // Mapping from token ID to approved address
752     mapping(uint256 => address) private _tokenApprovals;
753 
754     // Mapping from owner to operator approvals
755     mapping(address => mapping(address => bool)) private _operatorApprovals;
756 
757     constructor(string memory name_, string memory symbol_) {
758         _name = name_;
759         _symbol = symbol_;
760     }
761 
762     /**
763      * @dev See {IERC721Enumerable-totalSupply}.
764      */
765     function totalSupply() public view override returns (uint256) {
766         return currentIndex;
767     }
768 
769     /**
770      * @dev See {IERC721Enumerable-tokenByIndex}.
771      */
772     function tokenByIndex(uint256 index) public view override returns (uint256) {
773         require(index < totalSupply(), 'ERC721A: global index out of bounds');
774         return index;
775     }
776 
777     /**
778      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
779      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
780      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
781      */
782     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
783         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
784         uint256 numMintedSoFar = totalSupply();
785         uint256 tokenIdsIdx = 0;
786         address currOwnershipAddr = address(0);
787         for (uint256 i = 0; i < numMintedSoFar; i++) {
788             TokenOwnership memory ownership = _ownerships[i];
789             if (ownership.addr != address(0)) {
790                 currOwnershipAddr = ownership.addr;
791             }
792             if (currOwnershipAddr == owner) {
793                 if (tokenIdsIdx == index) {
794                     return i;
795                 }
796                 tokenIdsIdx++;
797             }
798         }
799         revert('ERC721A: unable to get token of owner by index');
800     }
801 
802     /**
803      * @dev See {IERC165-supportsInterface}.
804      */
805     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
806         return
807             interfaceId == type(IERC721).interfaceId ||
808             interfaceId == type(IERC721Metadata).interfaceId ||
809             interfaceId == type(IERC721Enumerable).interfaceId ||
810             super.supportsInterface(interfaceId);
811     }
812 
813     /**
814      * @dev See {IERC721-balanceOf}.
815      */
816     function balanceOf(address owner) public view override returns (uint256) {
817         require(owner != address(0), 'ERC721A: balance query for the zero address');
818         return uint256(_addressData[owner].balance);
819     }
820 
821     function _numberMinted(address owner) internal view returns (uint256) {
822         require(owner != address(0), 'ERC721A: number minted query for the zero address');
823         return uint256(_addressData[owner].numberMinted);
824     }
825 
826     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
827         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
828 
829         for (uint256 curr = tokenId; ; curr--) {
830             TokenOwnership memory ownership = _ownerships[curr];
831             if (ownership.addr != address(0)) {
832                 return ownership;
833             }
834         }
835 
836         revert('ERC721A: unable to determine the owner of token');
837     }
838 
839     /**
840      * @dev See {IERC721-ownerOf}.
841      */
842     function ownerOf(uint256 tokenId) public view override returns (address) {
843         return ownershipOf(tokenId).addr;
844     }
845 
846     /**
847      * @dev See {IERC721Metadata-name}.
848      */
849     function name() public view virtual override returns (string memory) {
850         return _name;
851     }
852 
853     /**
854      * @dev See {IERC721Metadata-symbol}.
855      */
856     function symbol() public view virtual override returns (string memory) {
857         return _symbol;
858     }
859 
860     /**
861      * @dev See {IERC721Metadata-tokenURI}.
862      */
863     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
864         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
865 
866         string memory baseURI = _baseURI();
867         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
868     }
869 
870     /**
871      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
872      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
873      * by default, can be overriden in child contracts.
874      */
875     function _baseURI() internal view virtual returns (string memory) {
876         return '';
877     }
878 
879     /**
880      * @dev See {IERC721-approve}.
881      */
882     function approve(address to, uint256 tokenId) public override {
883         address owner = ERC721A.ownerOf(tokenId);
884         require(to != owner, 'ERC721A: approval to current owner');
885 
886         require(
887             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
888             'ERC721A: approve caller is not owner nor approved for all'
889         );
890 
891         _approve(to, tokenId, owner);
892     }
893 
894     /**
895      * @dev See {IERC721-getApproved}.
896      */
897     function getApproved(uint256 tokenId) public view override returns (address) {
898         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
899 
900         return _tokenApprovals[tokenId];
901     }
902 
903     /**
904      * @dev See {IERC721-setApprovalForAll}.
905      */
906     function setApprovalForAll(address operator, bool approved) public override {
907         require(operator != _msgSender(), 'ERC721A: approve to caller');
908 
909         _operatorApprovals[_msgSender()][operator] = approved;
910         emit ApprovalForAll(_msgSender(), operator, approved);
911     }
912 
913     /**
914      * @dev See {IERC721-isApprovedForAll}.
915      */
916     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
917         return _operatorApprovals[owner][operator];
918     }
919 
920     /**
921      * @dev See {IERC721-transferFrom}.
922      */
923     function transferFrom(
924         address from,
925         address to,
926         uint256 tokenId
927     ) public override {
928         _transfer(from, to, tokenId);
929     }
930 
931     /**
932      * @dev See {IERC721-safeTransferFrom}.
933      */
934     function safeTransferFrom(
935         address from,
936         address to,
937         uint256 tokenId
938     ) public override {
939         safeTransferFrom(from, to, tokenId, '');
940     }
941 
942     /**
943      * @dev See {IERC721-safeTransferFrom}.
944      */
945     function safeTransferFrom(
946         address from,
947         address to,
948         uint256 tokenId,
949         bytes memory _data
950     ) public override {
951         _transfer(from, to, tokenId);
952         require(
953             _checkOnERC721Received(from, to, tokenId, _data),
954             'ERC721A: transfer to non ERC721Receiver implementer'
955         );
956     }
957 
958     /**
959      * @dev Returns whether `tokenId` exists.
960      *
961      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
962      *
963      * Tokens start existing when they are minted (`_mint`),
964      */
965     function _exists(uint256 tokenId) internal view returns (bool) {
966         return tokenId < currentIndex;
967     }
968 
969     function _safeMint(address to, uint256 quantity) internal {
970         _safeMint(to, quantity, '');
971     }
972 
973     /**
974      * @dev Mints `quantity` tokens and transfers them to `to`.
975      *
976      * Requirements:
977      *
978      * - `to` cannot be the zero address.
979      * - `quantity` cannot be larger than the max batch size.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _safeMint(
984         address to,
985         uint256 quantity,
986         bytes memory _data
987     ) internal {
988         uint256 startTokenId = currentIndex;
989         require(to != address(0), 'ERC721A: mint to the zero address');
990         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
991         require(!_exists(startTokenId), 'ERC721A: token already minted');
992         require(quantity > 0, 'ERC721A: quantity must be greater 0');
993 
994         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
995 
996         AddressData memory addressData = _addressData[to];
997         _addressData[to] = AddressData(
998             addressData.balance + uint128(quantity),
999             addressData.numberMinted + uint128(quantity)
1000         );
1001         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1002 
1003         uint256 updatedIndex = startTokenId;
1004 
1005         for (uint256 i = 0; i < quantity; i++) {
1006             emit Transfer(address(0), to, updatedIndex);
1007             require(
1008                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1009                 'ERC721A: transfer to non ERC721Receiver implementer'
1010             );
1011             updatedIndex++;
1012         }
1013 
1014         currentIndex = updatedIndex;
1015         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1016     }
1017 
1018     /**
1019      * @dev Transfers `tokenId` from `from` to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must be owned by `from`.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _transfer(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) private {
1033         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1034 
1035         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1036             getApproved(tokenId) == _msgSender() ||
1037             isApprovedForAll(prevOwnership.addr, _msgSender()));
1038 
1039         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1040 
1041         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1042         require(to != address(0), 'ERC721A: transfer to the zero address');
1043 
1044         _beforeTokenTransfers(from, to, tokenId, 1);
1045 
1046         // Clear approvals from the previous owner
1047         _approve(address(0), tokenId, prevOwnership.addr);
1048 
1049         // Underflow of the sender's balance is impossible because we check for
1050         // ownership above and the recipient's balance can't realistically overflow.
1051         unchecked {
1052             _addressData[from].balance -= 1;
1053             _addressData[to].balance += 1;
1054         }
1055 
1056         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1057 
1058         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1059         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1060         uint256 nextTokenId = tokenId + 1;
1061         if (_ownerships[nextTokenId].addr == address(0)) {
1062             if (_exists(nextTokenId)) {
1063                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1064             }
1065         }
1066 
1067         emit Transfer(from, to, tokenId);
1068         _afterTokenTransfers(from, to, tokenId, 1);
1069     }
1070 
1071     /**
1072      * @dev Approve `to` to operate on `tokenId`
1073      *
1074      * Emits a {Approval} event.
1075      */
1076     function _approve(
1077         address to,
1078         uint256 tokenId,
1079         address owner
1080     ) private {
1081         _tokenApprovals[tokenId] = to;
1082         emit Approval(owner, to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1087      * The call is not executed if the target address is not a contract.
1088      *
1089      * @param from address representing the previous owner of the given token ID
1090      * @param to target address that will receive the tokens
1091      * @param tokenId uint256 ID of the token to be transferred
1092      * @param _data bytes optional data to send along with the call
1093      * @return bool whether the call correctly returned the expected magic value
1094      */
1095     function _checkOnERC721Received(
1096         address from,
1097         address to,
1098         uint256 tokenId,
1099         bytes memory _data
1100     ) private returns (bool) {
1101         if (to.isContract()) {
1102             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1103                 return retval == IERC721Receiver(to).onERC721Received.selector;
1104             } catch (bytes memory reason) {
1105                 if (reason.length == 0) {
1106                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1107                 } else {
1108                     assembly {
1109                         revert(add(32, reason), mload(reason))
1110                     }
1111                 }
1112             }
1113         } else {
1114             return true;
1115         }
1116     }
1117 
1118     /**
1119      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1120      *
1121      * startTokenId - the first token id to be transferred
1122      * quantity - the amount to be transferred
1123      *
1124      * Calling conditions:
1125      *
1126      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1127      * transferred to `to`.
1128      * - When `from` is zero, `tokenId` will be minted for `to`.
1129      */
1130     function _beforeTokenTransfers(
1131         address from,
1132         address to,
1133         uint256 startTokenId,
1134         uint256 quantity
1135     ) internal virtual {}
1136 
1137     /**
1138      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1139      * minting.
1140      *
1141      * startTokenId - the first token id to be transferred
1142      * quantity - the amount to be transferred
1143      *
1144      * Calling conditions:
1145      *
1146      * - when `from` and `to` are both non-zero.
1147      * - `from` and `to` are never both zero.
1148      */
1149     function _afterTokenTransfers(
1150         address from,
1151         address to,
1152         uint256 startTokenId,
1153         uint256 quantity
1154     ) internal virtual {}
1155 }
1156 
1157 
1158 // File contracts/TheDegenApes.sol
1159 
1160 
1161 contract TheDegenApes is ERC721A, Ownable {
1162 
1163     string public baseURI = "";
1164     string public contractURI = "";
1165     string public constant baseExtension = ".json";
1166     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1167 
1168     uint256 public constant MAX_PER_TX_FREE = 2;
1169     uint256 public constant MAX_PER_TX = 5;
1170     uint256 public constant FREE_MAX_SUPPLY = 1000;
1171     uint256 public constant MAX_SUPPLY = 3333;
1172     uint256 public price = 0.005 ether;
1173 
1174     bool public paused = true;
1175 
1176     constructor() ERC721A("TheDegenApes", "TDA") {}
1177 
1178     function mint(uint256 _amount) external payable {
1179         address _caller = _msgSender();
1180         require(!paused, "Paused");
1181         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1182         require(_amount > 0, "No 0 mints");
1183         require(tx.origin == _caller, "No contracts");
1184 
1185         if(FREE_MAX_SUPPLY >= totalSupply()){
1186             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1187         }else{
1188             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1189             require(_amount * price == msg.value, "Invalid funds provided");
1190         }
1191 
1192         _safeMint(_caller, _amount);
1193     }
1194 
1195     function setCost(uint256 _newCost) public onlyOwner {
1196         price = _newCost;
1197     }
1198 
1199     function isApprovedForAll(address owner, address operator)
1200         override
1201         public
1202         view
1203         returns (bool)
1204     {
1205         // Whitelist OpenSea proxy contract for easy trading.
1206         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1207         if (address(proxyRegistry.proxies(owner)) == operator) {
1208             return true;
1209         }
1210 
1211         return super.isApprovedForAll(owner, operator);
1212     }
1213 
1214     function withdraw() external onlyOwner {
1215         uint256 balance = address(this).balance;
1216         (bool success, ) = _msgSender().call{value: balance}("");
1217         require(success, "Failed to send");
1218     }
1219 
1220     function setupOS() external onlyOwner {
1221         _safeMint(_msgSender(), 1);
1222     }
1223 
1224     function pause(bool _state) external onlyOwner {
1225         paused = _state;
1226     }
1227 
1228     function setBaseURI(string memory baseURI_) external onlyOwner {
1229         baseURI = baseURI_;
1230     }
1231 
1232     function setContractURI(string memory _contractURI) external onlyOwner {
1233         contractURI = _contractURI;
1234     }
1235 
1236     function Currentprice() public view returns (uint256){
1237         if (FREE_MAX_SUPPLY >= totalSupply()) {
1238             return 0;
1239         }else{
1240             return price;
1241         }
1242     }
1243 
1244     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1245         require(_exists(_tokenId), "Token does not exist.");
1246         return bytes(baseURI).length > 0 ? string(
1247             abi.encodePacked(
1248               baseURI,
1249               Strings.toString(_tokenId),
1250               baseExtension
1251             )
1252         ) : "";
1253     }
1254 }
1255 
1256 contract OwnableDelegateProxy { }
1257 contract ProxyRegistry {
1258     mapping(address => OwnableDelegateProxy) public proxies;
1259 }