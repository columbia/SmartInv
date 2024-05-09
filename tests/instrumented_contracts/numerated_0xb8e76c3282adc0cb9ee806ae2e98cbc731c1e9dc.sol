1 // File: @openzeppelin/contracts/utils/math/Math.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     /**
13      * @dev Returns the largest of two numbers.
14      */
15     function max(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a >= b ? a : b;
17     }
18 
19     /**
20      * @dev Returns the smallest of two numbers.
21      */
22     function min(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a < b ? a : b;
24     }
25 
26     /**
27      * @dev Returns the average of two numbers. The result is rounded towards
28      * zero.
29      */
30     function average(uint256 a, uint256 b) internal pure returns (uint256) {
31         // (a + b) / 2 can overflow.
32         return (a & b) + (a ^ b) / 2;
33     }
34 
35     /**
36      * @dev Returns the ceiling of the division of two numbers.
37      *
38      * This differs from standard division with `/` in that it rounds up instead
39      * of rounding down.
40      */
41     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
42         // (a + b - 1) / b can overflow on addition, so we distribute.
43         return a / b + (a % b == 0 ? 0 : 1);
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/Context.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 // File: @openzeppelin/contracts/access/Ownable.sol
145 
146 
147 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 /**
153  * @dev Contract module which provides a basic access control mechanism, where
154  * there is an account (an owner) that can be granted exclusive access to
155  * specific functions.
156  *
157  * By default, the owner account will be the one that deploys the contract. This
158  * can later be changed with {transferOwnership}.
159  *
160  * This module is used through inheritance. It will make available the modifier
161  * `onlyOwner`, which can be applied to your functions to restrict their use to
162  * the owner.
163  */
164 abstract contract Ownable is Context {
165     address private _owner;
166 
167     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
168 
169     /**
170      * @dev Initializes the contract setting the deployer as the initial owner.
171      */
172     constructor() {
173         _transferOwnership(_msgSender());
174     }
175 
176     /**
177      * @dev Returns the address of the current owner.
178      */
179     function owner() public view virtual returns (address) {
180         return _owner;
181     }
182 
183     /**
184      * @dev Throws if called by any account other than the owner.
185      */
186     modifier onlyOwner() {
187         require(owner() == _msgSender(), "Ownable: caller is not the owner");
188         _;
189     }
190 
191     /**
192      * @dev Leaves the contract without owner. It will not be possible to call
193      * `onlyOwner` functions anymore. Can only be called by the current owner.
194      *
195      * NOTE: Renouncing ownership will leave the contract without an owner,
196      * thereby removing any functionality that is only available to the owner.
197      */
198     function renounceOwnership() public virtual onlyOwner {
199         _transferOwnership(address(0));
200     }
201 
202     /**
203      * @dev Transfers ownership of the contract to a new account (`newOwner`).
204      * Can only be called by the current owner.
205      */
206     function transferOwnership(address newOwner) public virtual onlyOwner {
207         require(newOwner != address(0), "Ownable: new owner is the zero address");
208         _transferOwnership(newOwner);
209     }
210 
211     /**
212      * @dev Transfers ownership of the contract to a new account (`newOwner`).
213      * Internal function without access restriction.
214      */
215     function _transferOwnership(address newOwner) internal virtual {
216         address oldOwner = _owner;
217         _owner = newOwner;
218         emit OwnershipTransferred(oldOwner, newOwner);
219     }
220 }
221 
222 // File: @openzeppelin/contracts/utils/Address.sol
223 
224 
225 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
226 
227 pragma solidity ^0.8.1;
228 
229 /**
230  * @dev Collection of functions related to the address type
231  */
232 library Address {
233     /**
234      * @dev Returns true if `account` is a contract.
235      *
236      * [IMPORTANT]
237      * ====
238      * It is unsafe to assume that an address for which this function returns
239      * false is an externally-owned account (EOA) and not a contract.
240      *
241      * Among others, `isContract` will return false for the following
242      * types of addresses:
243      *
244      *  - an externally-owned account
245      *  - a contract in construction
246      *  - an address where a contract will be created
247      *  - an address where a contract lived, but was destroyed
248      * ====
249      *
250      * [IMPORTANT]
251      * ====
252      * You shouldn't rely on `isContract` to protect against flash loan attacks!
253      *
254      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
255      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
256      * constructor.
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         // This method relies on extcodesize/address.code.length, which returns 0
261         // for contracts in construction, since the code is only stored at the end
262         // of the constructor execution.
263 
264         return account.code.length > 0;
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         (bool success, ) = recipient.call{value: amount}("");
287         require(success, "Address: unable to send value, recipient may have reverted");
288     }
289 
290     /**
291      * @dev Performs a Solidity function call using a low level `call`. A
292      * plain `call` is an unsafe replacement for a function call: use this
293      * function instead.
294      *
295      * If `target` reverts with a revert reason, it is bubbled up by this
296      * function (like regular Solidity function calls).
297      *
298      * Returns the raw returned data. To convert to the expected return value,
299      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300      *
301      * Requirements:
302      *
303      * - `target` must be a contract.
304      * - calling `target` with `data` must not revert.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionCall(target, data, "Address: low-level call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314      * `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(
319         address target,
320         bytes memory data,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, 0, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but also transferring `value` wei to `target`.
329      *
330      * Requirements:
331      *
332      * - the calling contract must have an ETH balance of at least `value`.
333      * - the called Solidity function must be `payable`.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.call{value: value}(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
371         return functionStaticCall(target, data, "Address: low-level static call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal view returns (bytes memory) {
385         require(isContract(target), "Address: static call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.staticcall(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a delegate call.
394      *
395      * _Available since v3.4._
396      */
397     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
398         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         require(isContract(target), "Address: delegate call to non-contract");
413 
414         (bool success, bytes memory returndata) = target.delegatecall(data);
415         return verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
420      * revert reason using the provided one.
421      *
422      * _Available since v4.3._
423      */
424     function verifyCallResult(
425         bool success,
426         bytes memory returndata,
427         string memory errorMessage
428     ) internal pure returns (bytes memory) {
429         if (success) {
430             return returndata;
431         } else {
432             // Look for revert reason and bubble it up if present
433             if (returndata.length > 0) {
434                 // The easiest way to bubble the revert reason is using memory via assembly
435 
436                 assembly {
437                     let returndata_size := mload(returndata)
438                     revert(add(32, returndata), returndata_size)
439                 }
440             } else {
441                 revert(errorMessage);
442             }
443         }
444     }
445 }
446 
447 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
448 
449 
450 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
451 
452 pragma solidity ^0.8.0;
453 
454 /**
455  * @title ERC721 token receiver interface
456  * @dev Interface for any contract that wants to support safeTransfers
457  * from ERC721 asset contracts.
458  */
459 interface IERC721Receiver {
460     /**
461      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
462      * by `operator` from `from`, this function is called.
463      *
464      * It must return its Solidity selector to confirm the token transfer.
465      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
466      *
467      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
468      */
469     function onERC721Received(
470         address operator,
471         address from,
472         uint256 tokenId,
473         bytes calldata data
474     ) external returns (bytes4);
475 }
476 
477 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
478 
479 
480 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @dev Interface of the ERC165 standard, as defined in the
486  * https://eips.ethereum.org/EIPS/eip-165[EIP].
487  *
488  * Implementers can declare support of contract interfaces, which can then be
489  * queried by others ({ERC165Checker}).
490  *
491  * For an implementation, see {ERC165}.
492  */
493 interface IERC165 {
494     /**
495      * @dev Returns true if this contract implements the interface defined by
496      * `interfaceId`. See the corresponding
497      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
498      * to learn more about how these ids are created.
499      *
500      * This function call must use less than 30 000 gas.
501      */
502     function supportsInterface(bytes4 interfaceId) external view returns (bool);
503 }
504 
505 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @dev Implementation of the {IERC165} interface.
515  *
516  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
517  * for the additional interface id that will be supported. For example:
518  *
519  * ```solidity
520  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
521  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
522  * }
523  * ```
524  *
525  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
526  */
527 abstract contract ERC165 is IERC165 {
528     /**
529      * @dev See {IERC165-supportsInterface}.
530      */
531     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
532         return interfaceId == type(IERC165).interfaceId;
533     }
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
537 
538 
539 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 
544 /**
545  * @dev Required interface of an ERC721 compliant contract.
546  */
547 interface IERC721 is IERC165 {
548     /**
549      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
550      */
551     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
552 
553     /**
554      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
555      */
556     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
557 
558     /**
559      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
560      */
561     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
562 
563     /**
564      * @dev Returns the number of tokens in ``owner``'s account.
565      */
566     function balanceOf(address owner) external view returns (uint256 balance);
567 
568     /**
569      * @dev Returns the owner of the `tokenId` token.
570      *
571      * Requirements:
572      *
573      * - `tokenId` must exist.
574      */
575     function ownerOf(uint256 tokenId) external view returns (address owner);
576 
577     /**
578      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
579      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
580      *
581      * Requirements:
582      *
583      * - `from` cannot be the zero address.
584      * - `to` cannot be the zero address.
585      * - `tokenId` token must exist and be owned by `from`.
586      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
587      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
588      *
589      * Emits a {Transfer} event.
590      */
591     function safeTransferFrom(
592         address from,
593         address to,
594         uint256 tokenId
595     ) external;
596 
597     /**
598      * @dev Transfers `tokenId` token from `from` to `to`.
599      *
600      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `tokenId` token must be owned by `from`.
607      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
608      *
609      * Emits a {Transfer} event.
610      */
611     function transferFrom(
612         address from,
613         address to,
614         uint256 tokenId
615     ) external;
616 
617     /**
618      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
619      * The approval is cleared when the token is transferred.
620      *
621      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
622      *
623      * Requirements:
624      *
625      * - The caller must own the token or be an approved operator.
626      * - `tokenId` must exist.
627      *
628      * Emits an {Approval} event.
629      */
630     function approve(address to, uint256 tokenId) external;
631 
632     /**
633      * @dev Returns the account approved for `tokenId` token.
634      *
635      * Requirements:
636      *
637      * - `tokenId` must exist.
638      */
639     function getApproved(uint256 tokenId) external view returns (address operator);
640 
641     /**
642      * @dev Approve or remove `operator` as an operator for the caller.
643      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
644      *
645      * Requirements:
646      *
647      * - The `operator` cannot be the caller.
648      *
649      * Emits an {ApprovalForAll} event.
650      */
651     function setApprovalForAll(address operator, bool _approved) external;
652 
653     /**
654      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
655      *
656      * See {setApprovalForAll}
657      */
658     function isApprovedForAll(address owner, address operator) external view returns (bool);
659 
660     /**
661      * @dev Safely transfers `tokenId` token from `from` to `to`.
662      *
663      * Requirements:
664      *
665      * - `from` cannot be the zero address.
666      * - `to` cannot be the zero address.
667      * - `tokenId` token must exist and be owned by `from`.
668      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
669      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
670      *
671      * Emits a {Transfer} event.
672      */
673     function safeTransferFrom(
674         address from,
675         address to,
676         uint256 tokenId,
677         bytes calldata data
678     ) external;
679 }
680 
681 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
682 
683 
684 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 
689 /**
690  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
691  * @dev See https://eips.ethereum.org/EIPS/eip-721
692  */
693 interface IERC721Enumerable is IERC721 {
694     /**
695      * @dev Returns the total amount of tokens stored by the contract.
696      */
697     function totalSupply() external view returns (uint256);
698 
699     /**
700      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
701      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
702      */
703     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
704 
705     /**
706      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
707      * Use along with {totalSupply} to enumerate all tokens.
708      */
709     function tokenByIndex(uint256 index) external view returns (uint256);
710 }
711 
712 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
713 
714 
715 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 
720 /**
721  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
722  * @dev See https://eips.ethereum.org/EIPS/eip-721
723  */
724 interface IERC721Metadata is IERC721 {
725     /**
726      * @dev Returns the token collection name.
727      */
728     function name() external view returns (string memory);
729 
730     /**
731      * @dev Returns the token collection symbol.
732      */
733     function symbol() external view returns (string memory);
734 
735     /**
736      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
737      */
738     function tokenURI(uint256 tokenId) external view returns (string memory);
739 }
740 
741 // File: github/chiru-labs/ERC721A/contracts/ERC721A.sol
742 
743 
744 // Creator: Chiru Labs
745 
746 pragma solidity ^0.8.0;
747 
748 
749 
750 
751 
752 
753 
754 
755 
756 /**
757  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
758  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
759  *
760  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
761  *
762  * Does not support burning tokens to address(0).
763  *
764  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
765  */
766 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
767     using Address for address;
768     using Strings for uint256;
769 
770     struct TokenOwnership {
771         address addr;
772         uint64 startTimestamp;
773     }
774 
775     struct AddressData {
776         uint128 balance;
777         uint128 numberMinted;
778     }
779 
780     uint256 internal currentIndex;
781 
782     // Token name
783     string private _name;
784 
785     // Token symbol
786     string private _symbol;
787 
788     // Mapping from token ID to ownership details
789     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
790     mapping(uint256 => TokenOwnership) internal _ownerships;
791 
792     // Mapping owner address to address data
793     mapping(address => AddressData) private _addressData;
794 
795     // Mapping from token ID to approved address
796     mapping(uint256 => address) private _tokenApprovals;
797 
798     // Mapping from owner to operator approvals
799     mapping(address => mapping(address => bool)) private _operatorApprovals;
800 
801     constructor(string memory name_, string memory symbol_) {
802         _name = name_;
803         _symbol = symbol_;
804     }
805 
806     /**
807      * @dev See {IERC721Enumerable-totalSupply}.
808      */
809     function totalSupply() public view override returns (uint256) {
810         return currentIndex;
811     }
812 
813     /**
814      * @dev See {IERC721Enumerable-tokenByIndex}.
815      */
816     function tokenByIndex(uint256 index) public view override returns (uint256) {
817         require(index < totalSupply(), 'ERC721A: global index out of bounds');
818         return index;
819     }
820 
821     /**
822      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
823      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
824      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
825      */
826     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
827         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
828         uint256 numMintedSoFar = totalSupply();
829         uint256 tokenIdsIdx;
830         address currOwnershipAddr;
831 
832         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
833         unchecked {
834             for (uint256 i; i < numMintedSoFar; i++) {
835                 TokenOwnership memory ownership = _ownerships[i];
836                 if (ownership.addr != address(0)) {
837                     currOwnershipAddr = ownership.addr;
838                 }
839                 if (currOwnershipAddr == owner) {
840                     if (tokenIdsIdx == index) {
841                         return i;
842                     }
843                     tokenIdsIdx++;
844                 }
845             }
846         }
847 
848         revert('ERC721A: unable to get token of owner by index');
849     }
850 
851     /**
852      * @dev See {IERC165-supportsInterface}.
853      */
854     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
855         return
856             interfaceId == type(IERC721).interfaceId ||
857             interfaceId == type(IERC721Metadata).interfaceId ||
858             interfaceId == type(IERC721Enumerable).interfaceId ||
859             super.supportsInterface(interfaceId);
860     }
861 
862     /**
863      * @dev See {IERC721-balanceOf}.
864      */
865     function balanceOf(address owner) public view override returns (uint256) {
866         require(owner != address(0), 'ERC721A: balance query for the zero address');
867         return uint256(_addressData[owner].balance);
868     }
869 
870     function _numberMinted(address owner) internal view returns (uint256) {
871         require(owner != address(0), 'ERC721A: number minted query for the zero address');
872         return uint256(_addressData[owner].numberMinted);
873     }
874 
875     /**
876      * Gas spent here starts off proportional to the maximum mint batch size.
877      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
878      */
879     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
880         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
881 
882         unchecked {
883             for (uint256 curr = tokenId; curr >= 0; curr--) {
884                 TokenOwnership memory ownership = _ownerships[curr];
885                 if (ownership.addr != address(0)) {
886                     return ownership;
887                 }
888             }
889         }
890 
891         revert('ERC721A: unable to determine the owner of token');
892     }
893 
894     /**
895      * @dev See {IERC721-ownerOf}.
896      */
897     function ownerOf(uint256 tokenId) public view override returns (address) {
898         return ownershipOf(tokenId).addr;
899     }
900 
901     /**
902      * @dev See {IERC721Metadata-name}.
903      */
904     function name() public view virtual override returns (string memory) {
905         return _name;
906     }
907 
908     /**
909      * @dev See {IERC721Metadata-symbol}.
910      */
911     function symbol() public view virtual override returns (string memory) {
912         return _symbol;
913     }
914 
915     /**
916      * @dev See {IERC721Metadata-tokenURI}.
917      */
918     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
919         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
920 
921         string memory baseURI = _baseURI();
922         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
923     }
924 
925     /**
926      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
927      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
928      * by default, can be overriden in child contracts.
929      */
930     function _baseURI() internal view virtual returns (string memory) {
931         return '';
932     }
933 
934     /**
935      * @dev See {IERC721-approve}.
936      */
937     function approve(address to, uint256 tokenId) public override {
938         address owner = ERC721A.ownerOf(tokenId);
939         require(to != owner, 'ERC721A: approval to current owner');
940 
941         require(
942             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
943             'ERC721A: approve caller is not owner nor approved for all'
944         );
945 
946         _approve(to, tokenId, owner);
947     }
948 
949     /**
950      * @dev See {IERC721-getApproved}.
951      */
952     function getApproved(uint256 tokenId) public view override returns (address) {
953         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
954 
955         return _tokenApprovals[tokenId];
956     }
957 
958     /**
959      * @dev See {IERC721-setApprovalForAll}.
960      */
961     function setApprovalForAll(address operator, bool approved) public override {
962         require(operator != _msgSender(), 'ERC721A: approve to caller');
963 
964         _operatorApprovals[_msgSender()][operator] = approved;
965         emit ApprovalForAll(_msgSender(), operator, approved);
966     }
967 
968     /**
969      * @dev See {IERC721-isApprovedForAll}.
970      */
971     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
972         return _operatorApprovals[owner][operator];
973     }
974 
975     /**
976      * @dev See {IERC721-transferFrom}.
977      */
978     function transferFrom(
979         address from,
980         address to,
981         uint256 tokenId
982     ) public override {
983         _transfer(from, to, tokenId);
984     }
985 
986     /**
987      * @dev See {IERC721-safeTransferFrom}.
988      */
989     function safeTransferFrom(
990         address from,
991         address to,
992         uint256 tokenId
993     ) public override {
994         safeTransferFrom(from, to, tokenId, '');
995     }
996 
997     /**
998      * @dev See {IERC721-safeTransferFrom}.
999      */
1000     function safeTransferFrom(
1001         address from,
1002         address to,
1003         uint256 tokenId,
1004         bytes memory _data
1005     ) public override {
1006         _transfer(from, to, tokenId);
1007         require(
1008             _checkOnERC721Received(from, to, tokenId, _data),
1009             'ERC721A: transfer to non ERC721Receiver implementer'
1010         );
1011     }
1012 
1013     /**
1014      * @dev Returns whether `tokenId` exists.
1015      *
1016      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1017      *
1018      * Tokens start existing when they are minted (`_mint`),
1019      */
1020     function _exists(uint256 tokenId) internal view returns (bool) {
1021         return tokenId < currentIndex;
1022     }
1023 
1024     function _safeMint(address to, uint256 quantity) internal {
1025         _safeMint(to, quantity, '');
1026     }
1027 
1028     /**
1029      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1030      *
1031      * Requirements:
1032      *
1033      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1034      * - `quantity` must be greater than 0.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _safeMint(
1039         address to,
1040         uint256 quantity,
1041         bytes memory _data
1042     ) internal {
1043         _mint(to, quantity, _data, true);
1044     }
1045 
1046     /**
1047      * @dev Mints `quantity` tokens and transfers them to `to`.
1048      *
1049      * Requirements:
1050      *
1051      * - `to` cannot be the zero address.
1052      * - `quantity` must be greater than 0.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function _mint(
1057         address to,
1058         uint256 quantity,
1059         bytes memory _data,
1060         bool safe
1061     ) internal {
1062         uint256 startTokenId = currentIndex;
1063         require(to != address(0), 'ERC721A: mint to the zero address');
1064         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1065 
1066         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1067 
1068         // Overflows are incredibly unrealistic.
1069         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1070         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1071         unchecked {
1072             _addressData[to].balance += uint128(quantity);
1073             _addressData[to].numberMinted += uint128(quantity);
1074 
1075             _ownerships[startTokenId].addr = to;
1076             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1077 
1078             uint256 updatedIndex = startTokenId;
1079 
1080             for (uint256 i; i < quantity; i++) {
1081                 emit Transfer(address(0), to, updatedIndex);
1082                 if (safe) {
1083                     require(
1084                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1085                         'ERC721A: transfer to non ERC721Receiver implementer'
1086                     );
1087                 }
1088 
1089                 updatedIndex++;
1090             }
1091 
1092             currentIndex = updatedIndex;
1093         }
1094 
1095         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1096     }
1097 
1098     /**
1099      * @dev Transfers `tokenId` from `from` to `to`.
1100      *
1101      * Requirements:
1102      *
1103      * - `to` cannot be the zero address.
1104      * - `tokenId` token must be owned by `from`.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _transfer(
1109         address from,
1110         address to,
1111         uint256 tokenId
1112     ) private {
1113         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1114 
1115         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1116             getApproved(tokenId) == _msgSender() ||
1117             isApprovedForAll(prevOwnership.addr, _msgSender()));
1118 
1119         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1120 
1121         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1122         require(to != address(0), 'ERC721A: transfer to the zero address');
1123 
1124         _beforeTokenTransfers(from, to, tokenId, 1);
1125 
1126         // Clear approvals from the previous owner
1127         _approve(address(0), tokenId, prevOwnership.addr);
1128 
1129         // Underflow of the sender's balance is impossible because we check for
1130         // ownership above and the recipient's balance can't realistically overflow.
1131         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1132         unchecked {
1133             _addressData[from].balance -= 1;
1134             _addressData[to].balance += 1;
1135 
1136             _ownerships[tokenId].addr = to;
1137             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1138 
1139             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1140             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1141             uint256 nextTokenId = tokenId + 1;
1142             if (_ownerships[nextTokenId].addr == address(0)) {
1143                 if (_exists(nextTokenId)) {
1144                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1145                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1146                 }
1147             }
1148         }
1149 
1150         emit Transfer(from, to, tokenId);
1151         _afterTokenTransfers(from, to, tokenId, 1);
1152     }
1153 
1154     /**
1155      * @dev Approve `to` to operate on `tokenId`
1156      *
1157      * Emits a {Approval} event.
1158      */
1159     function _approve(
1160         address to,
1161         uint256 tokenId,
1162         address owner
1163     ) private {
1164         _tokenApprovals[tokenId] = to;
1165         emit Approval(owner, to, tokenId);
1166     }
1167 
1168     /**
1169      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1170      * The call is not executed if the target address is not a contract.
1171      *
1172      * @param from address representing the previous owner of the given token ID
1173      * @param to target address that will receive the tokens
1174      * @param tokenId uint256 ID of the token to be transferred
1175      * @param _data bytes optional data to send along with the call
1176      * @return bool whether the call correctly returned the expected magic value
1177      */
1178     function _checkOnERC721Received(
1179         address from,
1180         address to,
1181         uint256 tokenId,
1182         bytes memory _data
1183     ) private returns (bool) {
1184         if (to.isContract()) {
1185             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1186                 return retval == IERC721Receiver(to).onERC721Received.selector;
1187             } catch (bytes memory reason) {
1188                 if (reason.length == 0) {
1189                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1190                 } else {
1191                     assembly {
1192                         revert(add(32, reason), mload(reason))
1193                     }
1194                 }
1195             }
1196         } else {
1197             return true;
1198         }
1199     }
1200 
1201     /**
1202      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1203      *
1204      * startTokenId - the first token id to be transferred
1205      * quantity - the amount to be transferred
1206      *
1207      * Calling conditions:
1208      *
1209      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1210      * transferred to `to`.
1211      * - When `from` is zero, `tokenId` will be minted for `to`.
1212      */
1213     function _beforeTokenTransfers(
1214         address from,
1215         address to,
1216         uint256 startTokenId,
1217         uint256 quantity
1218     ) internal virtual {}
1219 
1220     /**
1221      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1222      * minting.
1223      *
1224      * startTokenId - the first token id to be transferred
1225      * quantity - the amount to be transferred
1226      *
1227      * Calling conditions:
1228      *
1229      * - when `from` and `to` are both non-zero.
1230      * - `from` and `to` are never both zero.
1231      */
1232     function _afterTokenTransfers(
1233         address from,
1234         address to,
1235         uint256 startTokenId,
1236         uint256 quantity
1237     ) internal virtual {}
1238 }
1239 // File: github/chiru-labs/ERC721A/contracts/MoonbirdsMfers.sol
1240 
1241 // Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
1242 
1243 pragma solidity ^0.8.4;
1244 
1245 
1246 
1247 
1248 contract MoonbirdsMfers is ERC721A, Ownable {
1249     uint256 public constant maxSupply = 9000;
1250     uint256 public constant reservedAmount = 100;
1251     uint256 private constant maxBatchSize = 10;
1252 
1253     constructor() ERC721A("MoonbirdsMfers", "Moonbirds Mfers") {}
1254 
1255     uint256 public mintPrice = 0.005 ether;
1256     uint256 public maxAmountPerMint = 10;
1257     uint256 public maxMintPerWallet = 50;
1258 
1259     function setMintPrice(uint256 newMintPrice) external onlyOwner {
1260         mintPrice = newMintPrice;
1261     }
1262 
1263     function setMaxAmountPerMint(uint256 newMaxAmountPerMint) external onlyOwner {
1264         maxAmountPerMint = newMaxAmountPerMint;
1265     }
1266 
1267     function setMaxMintPerWallet(uint256 newMaxMintPerWallet) external onlyOwner {
1268         maxMintPerWallet = newMaxMintPerWallet;
1269     }
1270 
1271     /**
1272      * metadata URI
1273      */
1274     string private _baseURIExtended = "ipfs://QmYMgwdgAfDuUiZDhca8V4SGRWUswQxHWeooWgFEvozcpz/";
1275 
1276     function setBaseURI(string memory baseURI) external onlyOwner {
1277         _baseURIExtended = baseURI;
1278     }
1279 
1280     function _baseURI() internal view virtual override returns (string memory) {
1281         return _baseURIExtended;
1282     }
1283 
1284     /**
1285      * withdraw proceeds
1286      */
1287     function withdraw() public onlyOwner {
1288         uint256 balance = address(this).balance;
1289         Address.sendValue(payable(msg.sender), balance);
1290     }
1291 
1292     /**
1293      * pre-mint for team
1294      */
1295     function devMint(uint256 amount) public onlyOwner {
1296         require(totalSupply() + amount <= reservedAmount, "too many already minted before dev mint");
1297         require(amount % maxBatchSize == 0, "can only mint a multiple of the maxBatchSize");
1298         
1299         uint256 numChunks = amount / maxBatchSize;
1300         for (uint256 i = 0; i < numChunks; i++) {
1301             _safeMint(msg.sender, maxBatchSize);
1302         }
1303     }
1304 
1305     /**
1306      * Public minting
1307      * _publicSaleCode & publicSaleStartTime will be set to non-zero to enable minting. This helps to slow down bot.
1308      * allowedMintSupply will be used to enable multi-phases minting. Default is equal to maxSupply.
1309      */
1310     uint private _publicSaleCode = 0;
1311 
1312     uint32 public publicSaleStartTime = 0;
1313     uint256 public allowedMintSupply = maxSupply;
1314 
1315     mapping(address => uint256) public minted;
1316 
1317     function setPublicSaleCode(uint newCode) public onlyOwner {
1318         _publicSaleCode = newCode;
1319     }
1320 
1321     function setPublicSaleStartTime(uint32 newTime) public onlyOwner {
1322         publicSaleStartTime = newTime;
1323     }
1324 
1325     function setAllowedMintSupply(uint newLimit) public onlyOwner {
1326         allowedMintSupply = newLimit;
1327     }
1328 
1329     function publicMint(uint amount, uint code) external payable {
1330         require(msg.sender == tx.origin, "User wallet required");
1331         require(code != 0 && code == _publicSaleCode, "code is mismatched");
1332         require(publicSaleStartTime != 0 && publicSaleStartTime <= block.timestamp, "sales is not started");
1333         require(minted[msg.sender] + amount <= maxMintPerWallet, "limit per wallet reached");
1334         require(totalSupply() + amount <= allowedMintSupply, "current phase minting was ended");
1335 
1336         uint256 mintableAmount = amount;
1337         require(mintableAmount <= maxAmountPerMint, "Exceeded max token purchase");
1338 
1339         // check to ensure amount is not exceeded MAX_SUPPLY
1340         uint256 availableSupply = maxSupply - totalSupply();
1341         require(availableSupply > 0, "No more item to mint!"); 
1342         mintableAmount = Math.min(mintableAmount, availableSupply);
1343 
1344         uint256 totalMintCost = mintableAmount * mintPrice;
1345         require(msg.value >= totalMintCost, "Not enough ETH sent; check price!"); 
1346 
1347         minted[msg.sender] += mintableAmount;
1348 
1349         _safeMint(msg.sender, mintableAmount);
1350 
1351         // Refund unused fund
1352         uint256 changes = msg.value - totalMintCost;
1353         if (changes != 0) {
1354             Address.sendValue(payable(msg.sender), changes);
1355         }
1356     }
1357 }