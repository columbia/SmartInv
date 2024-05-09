1 /*
2 Bear Market Ape Yacht Club  Is a collection of 2000 unique apes who have made in through the bear market. 
3 Bear Market Apes are all about creating a strong community to help lead each other through the choppy waters of Open Sea while cruising in our mega yachts. 
4 CC0 collection.
5 price  : 0.002
6 supply : 2000
7 */
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @title Counters
14  * @author Matt Condon (@shrugs)
15  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
16  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
17  *
18  * Include with `using Counters for Counters.Counter;`
19  */
20 library Counters {
21     struct Counter {
22         // This variable should never be directly accessed by users of the library: interactions must be restricted to
23         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
24         // this feature: see https://github.com/ethereum/solidity/issues/4637
25         uint256 _value; // default: 0
26     }
27 
28     function current(Counter storage counter) internal view returns (uint256) {
29         return counter._value;
30     }
31 
32     function increment(Counter storage counter) internal {
33         unchecked {
34             counter._value += 1;
35         }
36     }
37 
38     function decrement(Counter storage counter) internal {
39         uint256 value = counter._value;
40         require(value > 0, "Counter: decrement overflow");
41         unchecked {
42             counter._value = value - 1;
43         }
44     }
45 
46     function reset(Counter storage counter) internal {
47         counter._value = 0;
48     }
49 }
50 
51 // File: @openzeppelin/contracts/utils/Strings.sol
52 
53 
54 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev String operations.
60  */
61 library Strings {
62     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
63     uint8 private constant _ADDRESS_LENGTH = 20;
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
67      */
68     function toString(uint256 value) internal pure returns (string memory) {
69         // Inspired by OraclizeAPI's implementation - MIT licence
70         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
71 
72         if (value == 0) {
73             return "0";
74         }
75         uint256 temp = value;
76         uint256 digits;
77         while (temp != 0) {
78             digits++;
79             temp /= 10;
80         }
81         bytes memory buffer = new bytes(digits);
82         while (value != 0) {
83             digits -= 1;
84             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
85             value /= 10;
86         }
87         return string(buffer);
88     }
89 
90     /**
91      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
92      */
93     function toHexString(uint256 value) internal pure returns (string memory) {
94         if (value == 0) {
95             return "0x00";
96         }
97         uint256 temp = value;
98         uint256 length = 0;
99         while (temp != 0) {
100             length++;
101             temp >>= 8;
102         }
103         return toHexString(value, length);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
108      */
109     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
110         bytes memory buffer = new bytes(2 * length + 2);
111         buffer[0] = "0";
112         buffer[1] = "x";
113         for (uint256 i = 2 * length + 1; i > 1; --i) {
114             buffer[i] = _HEX_SYMBOLS[value & 0xf];
115             value >>= 4;
116         }
117         require(value == 0, "Strings: hex length insufficient");
118         return string(buffer);
119     }
120 
121     /**
122      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
123      */
124     function toHexString(address addr) internal pure returns (string memory) {
125         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
126     }
127 }
128 
129 // File: @openzeppelin/contracts/utils/Context.sol
130 
131 
132 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
133 
134 pragma solidity ^0.8.0;
135 
136 /**
137  * @dev Provides information about the current execution context, including the
138  * sender of the transaction and its data. While these are generally available
139  * via msg.sender and msg.data, they should not be accessed in such a direct
140  * manner, since when dealing with meta-transactions the account sending and
141  * paying for execution may not be the actual sender (as far as an application
142  * is concerned).
143  *
144  * This contract is only required for intermediate, library-like contracts.
145  */
146 abstract contract Context {
147     function _msgSender() internal view virtual returns (address) {
148         return msg.sender;
149     }
150 
151     function _msgData() internal view virtual returns (bytes calldata) {
152         return msg.data;
153     }
154 }
155 
156 // File: @openzeppelin/contracts/access/Ownable.sol
157 
158 
159 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 
164 /**
165  * @dev Contract module which provides a basic access control mechanism, where
166  * there is an account (an owner) that can be granted exclusive access to
167  * specific functions.
168  *
169  * By default, the owner account will be the one that deploys the contract. This
170  * can later be changed with {transferOwnership}.
171  *
172  * This module is used through inheritance. It will make available the modifier
173  * `onlyOwner`, which can be applied to your functions to restrict their use to
174  * the owner.
175  */
176 abstract contract Ownable is Context {
177     address private _owner;
178 
179     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
180 
181     /**
182      * @dev Initializes the contract setting the deployer as the initial owner.
183      */
184     constructor() {
185         _transferOwnership(_msgSender());
186     }
187 
188     /**
189      * @dev Throws if called by any account other than the owner.
190      */
191     modifier onlyOwner() {
192         _checkOwner();
193         _;
194     }
195 
196     /**
197      * @dev Returns the address of the current owner.
198      */
199     function owner() public view virtual returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if the sender is not the owner.
205      */
206     function _checkOwner() internal view virtual {
207         require(owner() == _msgSender(), "Ownable: caller is not the owner");
208     }
209 
210     /**
211      * @dev Leaves the contract without owner. It will not be possible to call
212      * `onlyOwner` functions anymore. Can only be called by the current owner.
213      *
214      * NOTE: Renouncing ownership will leave the contract without an owner,
215      * thereby removing any functionality that is only available to the owner.
216      */
217     function renounceOwnership() public virtual onlyOwner {
218         _transferOwnership(address(0));
219     }
220 
221     /**
222      * @dev Transfers ownership of the contract to a new account (`newOwner`).
223      * Can only be called by the current owner.
224      */
225     function transferOwnership(address newOwner) public virtual onlyOwner {
226         require(newOwner != address(0), "Ownable: new owner is the zero address");
227         _transferOwnership(newOwner);
228     }
229 
230     /**
231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
232      * Internal function without access restriction.
233      */
234     function _transferOwnership(address newOwner) internal virtual {
235         address oldOwner = _owner;
236         _owner = newOwner;
237         emit OwnershipTransferred(oldOwner, newOwner);
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 
244 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
245 
246 pragma solidity ^0.8.1;
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      *
269      * [IMPORTANT]
270      * ====
271      * You shouldn't rely on `isContract` to protect against flash loan attacks!
272      *
273      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
274      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
275      * constructor.
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // This method relies on extcodesize/address.code.length, which returns 0
280         // for contracts in construction, since the code is only stored at the end
281         // of the constructor execution.
282 
283         return account.code.length > 0;
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         (bool success, ) = recipient.call{value: amount}("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain `call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328         return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         require(isContract(target), "Address: call to non-contract");
378 
379         (bool success, bytes memory returndata) = target.call{value: value}(data);
380         return verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
390         return functionStaticCall(target, data, "Address: low-level static call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal view returns (bytes memory) {
404         require(isContract(target), "Address: static call to non-contract");
405 
406         (bool success, bytes memory returndata) = target.staticcall(data);
407         return verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but performing a delegate call.
413      *
414      * _Available since v3.4._
415      */
416     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
417         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
422      * but performing a delegate call.
423      *
424      * _Available since v3.4._
425      */
426     function functionDelegateCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         require(isContract(target), "Address: delegate call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.delegatecall(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
439      * revert reason using the provided one.
440      *
441      * _Available since v4.3._
442      */
443     function verifyCallResult(
444         bool success,
445         bytes memory returndata,
446         string memory errorMessage
447     ) internal pure returns (bytes memory) {
448         if (success) {
449             return returndata;
450         } else {
451             // Look for revert reason and bubble it up if present
452             if (returndata.length > 0) {
453                 // The easiest way to bubble the revert reason is using memory via assembly
454                 /// @solidity memory-safe-assembly
455                 assembly {
456                     let returndata_size := mload(returndata)
457                     revert(add(32, returndata), returndata_size)
458                 }
459             } else {
460                 revert(errorMessage);
461             }
462         }
463     }
464 }
465 
466 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
467 
468 
469 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @title ERC721 token receiver interface
475  * @dev Interface for any contract that wants to support safeTransfers
476  * from ERC721 asset contracts.
477  */
478 interface IERC721Receiver {
479     /**
480      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
481      * by `operator` from `from`, this function is called.
482      *
483      * It must return its Solidity selector to confirm the token transfer.
484      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
485      *
486      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
487      */
488     function onERC721Received(
489         address operator,
490         address from,
491         uint256 tokenId,
492         bytes calldata data
493     ) external returns (bytes4);
494 }
495 
496 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
497 
498 
499 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev Interface of the ERC165 standard, as defined in the
505  * https://eips.ethereum.org/EIPS/eip-165[EIP].
506  *
507  * Implementers can declare support of contract interfaces, which can then be
508  * queried by others ({ERC165Checker}).
509  *
510  * For an implementation, see {ERC165}.
511  */
512 interface IERC165 {
513     /**
514      * @dev Returns true if this contract implements the interface defined by
515      * `interfaceId`. See the corresponding
516      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
517      * to learn more about how these ids are created.
518      *
519      * This function call must use less than 30 000 gas.
520      */
521     function supportsInterface(bytes4 interfaceId) external view returns (bool);
522 }
523 
524 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 
532 /**
533  * @dev Implementation of the {IERC165} interface.
534  *
535  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
536  * for the additional interface id that will be supported. For example:
537  *
538  * ```solidity
539  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
540  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
541  * }
542  * ```
543  *
544  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
545  */
546 abstract contract ERC165 is IERC165 {
547     /**
548      * @dev See {IERC165-supportsInterface}.
549      */
550     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551         return interfaceId == type(IERC165).interfaceId;
552     }
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
556 
557 
558 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 
563 /**
564  * @dev Required interface of an ERC721 compliant contract.
565  */
566 interface IERC721 is IERC165 {
567     /**
568      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
569      */
570     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
571 
572     /**
573      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
574      */
575     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
576 
577     /**
578      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
579      */
580     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
581 
582     /**
583      * @dev Returns the number of tokens in ``owner``'s account.
584      */
585     function balanceOf(address owner) external view returns (uint256 balance);
586 
587     /**
588      * @dev Returns the owner of the `tokenId` token.
589      *
590      * Requirements:
591      *
592      * - `tokenId` must exist.
593      */
594     function ownerOf(uint256 tokenId) external view returns (address owner);
595 
596     /**
597      * @dev Safely transfers `tokenId` token from `from` to `to`.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must exist and be owned by `from`.
604      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
606      *
607      * Emits a {Transfer} event.
608      */
609     function safeTransferFrom(
610         address from,
611         address to,
612         uint256 tokenId,
613         bytes calldata data
614     ) external;
615 
616     /**
617      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
618      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must exist and be owned by `from`.
625      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
626      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
627      *
628      * Emits a {Transfer} event.
629      */
630     function safeTransferFrom(
631         address from,
632         address to,
633         uint256 tokenId
634     ) external;
635 
636     /**
637      * @dev Transfers `tokenId` token from `from` to `to`.
638      *
639      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
640      *
641      * Requirements:
642      *
643      * - `from` cannot be the zero address.
644      * - `to` cannot be the zero address.
645      * - `tokenId` token must be owned by `from`.
646      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
647      *
648      * Emits a {Transfer} event.
649      */
650     function transferFrom(
651         address from,
652         address to,
653         uint256 tokenId
654     ) external;
655 
656     /**
657      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
658      * The approval is cleared when the token is transferred.
659      *
660      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
661      *
662      * Requirements:
663      *
664      * - The caller must own the token or be an approved operator.
665      * - `tokenId` must exist.
666      *
667      * Emits an {Approval} event.
668      */
669     function approve(address to, uint256 tokenId) external;
670 
671     /**
672      * @dev Approve or remove `operator` as an operator for the caller.
673      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
674      *
675      * Requirements:
676      *
677      * - The `operator` cannot be the caller.
678      *
679      * Emits an {ApprovalForAll} event.
680      */
681     function setApprovalForAll(address operator, bool _approved) external;
682 
683     /**
684      * @dev Returns the account approved for `tokenId` token.
685      *
686      * Requirements:
687      *
688      * - `tokenId` must exist.
689      */
690     function getApproved(uint256 tokenId) external view returns (address operator);
691 
692     /**
693      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
694      *
695      * See {setApprovalForAll}
696      */
697     function isApprovedForAll(address owner, address operator) external view returns (bool);
698 }
699 
700 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
701 
702 
703 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 
708 /**
709  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
710  * @dev See https://eips.ethereum.org/EIPS/eip-721
711  */
712 interface IERC721Metadata is IERC721 {
713     /**
714      * @dev Returns the token collection name.
715      */
716     function name() external view returns (string memory);
717 
718     /**
719      * @dev Returns the token collection symbol.
720      */
721     function symbol() external view returns (string memory);
722 
723     /**
724      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
725      */
726     function tokenURI(uint256 tokenId) external view returns (string memory);
727 }
728 
729 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
730 
731 
732 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 
737 
738 
739 
740 
741 
742 
743 /**
744  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
745  * the Metadata extension, but not including the Enumerable extension, which is available separately as
746  * {ERC721Enumerable}.
747  */
748 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
749     using Address for address;
750     using Strings for uint256;
751 
752     // Token name
753     string private _name;
754 
755     // Token symbol
756     string private _symbol;
757 
758     // Mapping from token ID to owner address
759     mapping(uint256 => address) private _owners;
760 
761     // Mapping owner address to token count
762     mapping(address => uint256) private _balances;
763 
764     // Mapping from token ID to approved address
765     mapping(uint256 => address) private _tokenApprovals;
766 
767     // Mapping from owner to operator approvals
768     mapping(address => mapping(address => bool)) private _operatorApprovals;
769 
770     /**
771      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
772      */
773     constructor(string memory name_, string memory symbol_) {
774         _name = name_;
775         _symbol = symbol_;
776     }
777 
778     /**
779      * @dev See {IERC165-supportsInterface}.
780      */
781     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
782         return
783             interfaceId == type(IERC721).interfaceId ||
784             interfaceId == type(IERC721Metadata).interfaceId ||
785             super.supportsInterface(interfaceId);
786     }
787 
788     /**
789      * @dev See {IERC721-balanceOf}.
790      */
791     function balanceOf(address owner) public view virtual override returns (uint256) {
792         require(owner != address(0), "ERC721: address zero is not a valid owner");
793         return _balances[owner];
794     }
795 
796     /**
797      * @dev See {IERC721-ownerOf}.
798      */
799     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
800         address owner = _owners[tokenId];
801         require(owner != address(0), "ERC721: invalid token ID");
802         return owner;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-name}.
807      */
808     function name() public view virtual override returns (string memory) {
809         return _name;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-symbol}.
814      */
815     function symbol() public view virtual override returns (string memory) {
816         return _symbol;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-tokenURI}.
821      */
822     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
823         _requireMinted(tokenId);
824 
825         string memory baseURI = _baseURI();
826         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
827     }
828 
829     /**
830      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
831      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
832      * by default, can be overridden in child contracts.
833      */
834     function _baseURI() internal view virtual returns (string memory) {
835         return "";
836     }
837 
838     /**
839      * @dev See {IERC721-approve}.
840      */
841     function approve(address to, uint256 tokenId) public virtual override {
842         address owner = ERC721.ownerOf(tokenId);
843         require(to != owner, "ERC721: approval to current owner");
844 
845         require(
846             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
847             "ERC721: approve caller is not token owner nor approved for all"
848         );
849 
850         _approve(to, tokenId);
851     }
852 
853     /**
854      * @dev See {IERC721-getApproved}.
855      */
856     function getApproved(uint256 tokenId) public view virtual override returns (address) {
857         _requireMinted(tokenId);
858 
859         return _tokenApprovals[tokenId];
860     }
861 
862     /**
863      * @dev See {IERC721-setApprovalForAll}.
864      */
865     function setApprovalForAll(address operator, bool approved) public virtual override {
866         _setApprovalForAll(_msgSender(), operator, approved);
867     }
868 
869     /**
870      * @dev See {IERC721-isApprovedForAll}.
871      */
872     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
873         return _operatorApprovals[owner][operator];
874     }
875 
876     /**
877      * @dev See {IERC721-transferFrom}.
878      */
879     function transferFrom(
880         address from,
881         address to,
882         uint256 tokenId
883     ) public virtual override {
884         //solhint-disable-next-line max-line-length
885         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
886 
887         _transfer(from, to, tokenId);
888     }
889 
890     /**
891      * @dev See {IERC721-safeTransferFrom}.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public virtual override {
898         safeTransferFrom(from, to, tokenId, "");
899     }
900 
901     /**
902      * @dev See {IERC721-safeTransferFrom}.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes memory data
909     ) public virtual override {
910         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
911         _safeTransfer(from, to, tokenId, data);
912     }
913 
914     /**
915      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
916      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
917      *
918      * `data` is additional data, it has no specified format and it is sent in call to `to`.
919      *
920      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
921      * implement alternative mechanisms to perform token transfer, such as signature-based.
922      *
923      * Requirements:
924      *
925      * - `from` cannot be the zero address.
926      * - `to` cannot be the zero address.
927      * - `tokenId` token must exist and be owned by `from`.
928      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
929      *
930      * Emits a {Transfer} event.
931      */
932     function _safeTransfer(
933         address from,
934         address to,
935         uint256 tokenId,
936         bytes memory data
937     ) internal virtual {
938         _transfer(from, to, tokenId);
939         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
940     }
941 
942     /**
943      * @dev Returns whether `tokenId` exists.
944      *
945      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
946      *
947      * Tokens start existing when they are minted (`_mint`),
948      * and stop existing when they are burned (`_burn`).
949      */
950     function _exists(uint256 tokenId) internal view virtual returns (bool) {
951         return _owners[tokenId] != address(0);
952     }
953 
954     /**
955      * @dev Returns whether `spender` is allowed to manage `tokenId`.
956      *
957      * Requirements:
958      *
959      * - `tokenId` must exist.
960      */
961     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
962         address owner = ERC721.ownerOf(tokenId);
963         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
964     }
965 
966     /**
967      * @dev Safely mints `tokenId` and transfers it to `to`.
968      *
969      * Requirements:
970      *
971      * - `tokenId` must not exist.
972      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _safeMint(address to, uint256 tokenId) internal virtual {
977         _safeMint(to, tokenId, "");
978     }
979 
980     /**
981      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
982      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
983      */
984     function _safeMint(
985         address to,
986         uint256 tokenId,
987         bytes memory data
988     ) internal virtual {
989         _mint(to, tokenId);
990         require(
991             _checkOnERC721Received(address(0), to, tokenId, data),
992             "ERC721: transfer to non ERC721Receiver implementer"
993         );
994     }
995 
996     /**
997      * @dev Mints `tokenId` and transfers it to `to`.
998      *
999      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must not exist.
1004      * - `to` cannot be the zero address.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _mint(address to, uint256 tokenId) internal virtual {
1009         require(to != address(0), "ERC721: mint to the zero address");
1010         require(!_exists(tokenId), "ERC721: token already minted");
1011 
1012         _beforeTokenTransfer(address(0), to, tokenId);
1013 
1014         _balances[to] += 1;
1015         _owners[tokenId] = to;
1016 
1017         emit Transfer(address(0), to, tokenId);
1018 
1019         _afterTokenTransfer(address(0), to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev Destroys `tokenId`.
1024      * The approval is cleared when the token is burned.
1025      *
1026      * Requirements:
1027      *
1028      * - `tokenId` must exist.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _burn(uint256 tokenId) internal virtual {
1033         address owner = ERC721.ownerOf(tokenId);
1034 
1035         _beforeTokenTransfer(owner, address(0), tokenId);
1036 
1037         // Clear approvals
1038         _approve(address(0), tokenId);
1039 
1040         _balances[owner] -= 1;
1041         delete _owners[tokenId];
1042 
1043         emit Transfer(owner, address(0), tokenId);
1044 
1045         _afterTokenTransfer(owner, address(0), tokenId);
1046     }
1047 
1048     /**
1049      * @dev Transfers `tokenId` from `from` to `to`.
1050      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1051      *
1052      * Requirements:
1053      *
1054      * - `to` cannot be the zero address.
1055      * - `tokenId` token must be owned by `from`.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _transfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) internal virtual {
1064         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1065         require(to != address(0), "ERC721: transfer to the zero address");
1066 
1067         _beforeTokenTransfer(from, to, tokenId);
1068 
1069         // Clear approvals from the previous owner
1070         _approve(address(0), tokenId);
1071 
1072         _balances[from] -= 1;
1073         _balances[to] += 1;
1074         _owners[tokenId] = to;
1075 
1076         emit Transfer(from, to, tokenId);
1077 
1078         _afterTokenTransfer(from, to, tokenId);
1079     }
1080 
1081     /**
1082      * @dev Approve `to` to operate on `tokenId`
1083      *
1084      * Emits an {Approval} event.
1085      */
1086     function _approve(address to, uint256 tokenId) internal virtual {
1087         _tokenApprovals[tokenId] = to;
1088         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1089     }
1090 
1091     /**
1092      * @dev Approve `operator` to operate on all of `owner` tokens
1093      *
1094      * Emits an {ApprovalForAll} event.
1095      */
1096     function _setApprovalForAll(
1097         address owner,
1098         address operator,
1099         bool approved
1100     ) internal virtual {
1101         require(owner != operator, "ERC721: approve to caller");
1102         _operatorApprovals[owner][operator] = approved;
1103         emit ApprovalForAll(owner, operator, approved);
1104     }
1105 
1106     /**
1107      * @dev Reverts if the `tokenId` has not been minted yet.
1108      */
1109     function _requireMinted(uint256 tokenId) internal view virtual {
1110         require(_exists(tokenId), "ERC721: invalid token ID");
1111     }
1112 
1113     /**
1114      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1115      * The call is not executed if the target address is not a contract.
1116      *
1117      * @param from address representing the previous owner of the given token ID
1118      * @param to target address that will receive the tokens
1119      * @param tokenId uint256 ID of the token to be transferred
1120      * @param data bytes optional data to send along with the call
1121      * @return bool whether the call correctly returned the expected magic value
1122      */
1123     function _checkOnERC721Received(
1124         address from,
1125         address to,
1126         uint256 tokenId,
1127         bytes memory data
1128     ) private returns (bool) {
1129         if (to.isContract()) {
1130             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1131                 return retval == IERC721Receiver.onERC721Received.selector;
1132             } catch (bytes memory reason) {
1133                 if (reason.length == 0) {
1134                     revert("ERC721: transfer to non ERC721Receiver implementer");
1135                 } else {
1136                     /// @solidity memory-safe-assembly
1137                     assembly {
1138                         revert(add(32, reason), mload(reason))
1139                     }
1140                 }
1141             }
1142         } else {
1143             return true;
1144         }
1145     }
1146 
1147     /**
1148      * @dev Hook that is called before any token transfer. This includes minting
1149      * and burning.
1150      *
1151      * Calling conditions:
1152      *
1153      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1154      * transferred to `to`.
1155      * - When `from` is zero, `tokenId` will be minted for `to`.
1156      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1157      * - `from` and `to` are never both zero.
1158      *
1159      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1160      */
1161     function _beforeTokenTransfer(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) internal virtual {}
1166 
1167     /**
1168      * @dev Hook that is called after any transfer of tokens. This includes
1169      * minting and burning.
1170      *
1171      * Calling conditions:
1172      *
1173      * - when `from` and `to` are both non-zero.
1174      * - `from` and `to` are never both zero.
1175      *
1176      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1177      */
1178     function _afterTokenTransfer(
1179         address from,
1180         address to,
1181         uint256 tokenId
1182     ) internal virtual {}
1183 }
1184 
1185 // File: .deps/anonymousv2.sol
1186 
1187 
1188 
1189 // Amended by HashLips
1190 /**
1191     !Disclaimer!
1192     These contracts have been used to create tutorials,
1193     and was created for the purpose to teach people
1194     how to create smart contracts on the blockchain.
1195     please review this code on your own before using any of
1196     the following code for production.
1197     The developer will not be responsible or liable for all loss or 
1198     damage whatsoever caused by you participating in any way in the 
1199     experimental code, whether putting money into the contract or 
1200     using the code for your own project.
1201 */
1202 
1203 pragma solidity >=0.7.0 <0.9.0;
1204 
1205 
1206 
1207 
1208 contract BearMarketApe is ERC721, Ownable {
1209   using Strings for uint256;
1210   using Counters for Counters.Counter;
1211 
1212   Counters.Counter private supply;
1213 
1214   string public uriPrefix = "ipfs://QmYWwYKTC6cbFRBeQR1CRPaqDQ4RDQFUSn8SzXkzMeTSDQ/";
1215   string public uriSuffix = ".json";
1216   string public hiddenMetadataUri;
1217   
1218   uint256 public cost = 0.002 ether;
1219   uint256 public maxSupply = 2000;
1220   uint256 public maxMintAmountPerTx = 10;
1221 
1222   bool public paused = false;
1223   bool public revealed = true;
1224 
1225   constructor() ERC721("Bear Market Ape Yacht", "BMAY") {
1226     setHiddenMetadataUri("ipfs://___NoHidden___/hidden.json");
1227   }
1228 
1229   modifier mintCompliance(uint256 _mintAmount) {
1230     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1231     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1232     _;
1233   }
1234 
1235   function totalSupply() public view returns (uint256) {
1236     return supply.current();
1237   }
1238 
1239   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1240     require(!paused, "The contract is paused!");
1241     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1242 
1243     _mintLoop(msg.sender, _mintAmount);
1244   }
1245   
1246   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1247     _mintLoop(_receiver, _mintAmount);
1248   }
1249 
1250   function walletOfOwner(address _owner)
1251     public
1252     view
1253     returns (uint256[] memory)
1254   {
1255     uint256 ownerTokenCount = balanceOf(_owner);
1256     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1257     uint256 currentTokenId = 1;
1258     uint256 ownedTokenIndex = 0;
1259 
1260     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1261       address currentTokenOwner = ownerOf(currentTokenId);
1262 
1263       if (currentTokenOwner == _owner) {
1264         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1265 
1266         ownedTokenIndex++;
1267       }
1268 
1269       currentTokenId++;
1270     }
1271 
1272     return ownedTokenIds;
1273   }
1274 
1275   function tokenURI(uint256 _tokenId)
1276     public
1277     view
1278     virtual
1279     override
1280     returns (string memory)
1281   {
1282     require(
1283       _exists(_tokenId),
1284       "ERC721Metadata: URI query for nonexistent token"
1285     );
1286 
1287     if (revealed == false) {
1288       return hiddenMetadataUri;
1289     }
1290 
1291     string memory currentBaseURI = _baseURI();
1292     return bytes(currentBaseURI).length > 0
1293         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1294         : "";
1295   }
1296 
1297   function setRevealed(bool _state) public onlyOwner {
1298     revealed = _state;
1299   }
1300 
1301   function setCost(uint256 _cost) public onlyOwner {
1302     cost = _cost;
1303   }
1304 
1305   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1306     maxMintAmountPerTx = _maxMintAmountPerTx;
1307   }
1308 
1309   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1310     hiddenMetadataUri = _hiddenMetadataUri;
1311   }
1312 
1313   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1314     uriPrefix = _uriPrefix;
1315   }
1316 
1317   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1318     uriSuffix = _uriSuffix;
1319   }
1320 
1321   function setPaused(bool _state) public onlyOwner {
1322     paused = _state;
1323   }
1324 
1325   function withdraw() public onlyOwner {
1326 
1327 
1328     // This will transfer the remaining contract balance to the owner.
1329     // Do not remove this otherwise you will not be able to withdraw the funds.
1330     // =============================================================================
1331     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1332     require(os);
1333     // =============================================================================
1334   }
1335 
1336   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1337     for (uint256 i = 0; i < _mintAmount; i++) {
1338       supply.increment();
1339       _safeMint(_receiver, supply.current());
1340     }
1341   }
1342 
1343   function _baseURI() internal view virtual override returns (string memory) {
1344     return uriPrefix;
1345   }
1346 }