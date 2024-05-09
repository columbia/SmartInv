1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
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
120 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
147 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
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
225 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
226 
227 pragma solidity ^0.8.0;
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
249      */
250     function isContract(address account) internal view returns (bool) {
251         // This method relies on extcodesize, which returns 0 for contracts in
252         // construction, since the code is only stored at the end of the
253         // constructor execution.
254 
255         uint256 size;
256         assembly {
257             size := extcodesize(account)
258         }
259         return size > 0;
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         (bool success, ) = recipient.call{value: amount}("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain `call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionCall(target, data, "Address: low-level call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
309      * `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         require(isContract(target), "Address: call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.call{value: value}(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
366         return functionStaticCall(target, data, "Address: low-level static call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal view returns (bytes memory) {
380         require(isContract(target), "Address: static call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.staticcall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(isContract(target), "Address: delegate call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
415      * revert reason using the provided one.
416      *
417      * _Available since v4.3._
418      */
419     function verifyCallResult(
420         bool success,
421         bytes memory returndata,
422         string memory errorMessage
423     ) internal pure returns (bytes memory) {
424         if (success) {
425             return returndata;
426         } else {
427             // Look for revert reason and bubble it up if present
428             if (returndata.length > 0) {
429                 // The easiest way to bubble the revert reason is using memory via assembly
430 
431                 assembly {
432                     let returndata_size := mload(returndata)
433                     revert(add(32, returndata), returndata_size)
434                 }
435             } else {
436                 revert(errorMessage);
437             }
438         }
439     }
440 }
441 
442 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
443 
444 
445 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @title ERC721 token receiver interface
451  * @dev Interface for any contract that wants to support safeTransfers
452  * from ERC721 asset contracts.
453  */
454 interface IERC721Receiver {
455     /**
456      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
457      * by `operator` from `from`, this function is called.
458      *
459      * It must return its Solidity selector to confirm the token transfer.
460      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
461      *
462      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
463      */
464     function onERC721Received(
465         address operator,
466         address from,
467         uint256 tokenId,
468         bytes calldata data
469     ) external returns (bytes4);
470 }
471 
472 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
473 
474 
475 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @dev Interface of the ERC165 standard, as defined in the
481  * https://eips.ethereum.org/EIPS/eip-165[EIP].
482  *
483  * Implementers can declare support of contract interfaces, which can then be
484  * queried by others ({ERC165Checker}).
485  *
486  * For an implementation, see {ERC165}.
487  */
488 interface IERC165 {
489     /**
490      * @dev Returns true if this contract implements the interface defined by
491      * `interfaceId`. See the corresponding
492      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
493      * to learn more about how these ids are created.
494      *
495      * This function call must use less than 30 000 gas.
496      */
497     function supportsInterface(bytes4 interfaceId) external view returns (bool);
498 }
499 
500 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
501 
502 
503 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 
508 /**
509  * @dev Implementation of the {IERC165} interface.
510  *
511  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
512  * for the additional interface id that will be supported. For example:
513  *
514  * ```solidity
515  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
516  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
517  * }
518  * ```
519  *
520  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
521  */
522 abstract contract ERC165 is IERC165 {
523     /**
524      * @dev See {IERC165-supportsInterface}.
525      */
526     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527         return interfaceId == type(IERC165).interfaceId;
528     }
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @dev Required interface of an ERC721 compliant contract.
541  */
542 interface IERC721 is IERC165 {
543     /**
544      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
545      */
546     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
547 
548     /**
549      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
550      */
551     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
552 
553     /**
554      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
555      */
556     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
557 
558     /**
559      * @dev Returns the number of tokens in ``owner``'s account.
560      */
561     function balanceOf(address owner) external view returns (uint256 balance);
562 
563     /**
564      * @dev Returns the owner of the `tokenId` token.
565      *
566      * Requirements:
567      *
568      * - `tokenId` must exist.
569      */
570     function ownerOf(uint256 tokenId) external view returns (address owner);
571 
572     /**
573      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
574      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
575      *
576      * Requirements:
577      *
578      * - `from` cannot be the zero address.
579      * - `to` cannot be the zero address.
580      * - `tokenId` token must exist and be owned by `from`.
581      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
582      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
583      *
584      * Emits a {Transfer} event.
585      */
586     function safeTransferFrom(
587         address from,
588         address to,
589         uint256 tokenId
590     ) external;
591 
592     /**
593      * @dev Transfers `tokenId` token from `from` to `to`.
594      *
595      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must be owned by `from`.
602      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
603      *
604      * Emits a {Transfer} event.
605      */
606     function transferFrom(
607         address from,
608         address to,
609         uint256 tokenId
610     ) external;
611 
612     /**
613      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
614      * The approval is cleared when the token is transferred.
615      *
616      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
617      *
618      * Requirements:
619      *
620      * - The caller must own the token or be an approved operator.
621      * - `tokenId` must exist.
622      *
623      * Emits an {Approval} event.
624      */
625     function approve(address to, uint256 tokenId) external;
626 
627     /**
628      * @dev Returns the account approved for `tokenId` token.
629      *
630      * Requirements:
631      *
632      * - `tokenId` must exist.
633      */
634     function getApproved(uint256 tokenId) external view returns (address operator);
635 
636     /**
637      * @dev Approve or remove `operator` as an operator for the caller.
638      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
639      *
640      * Requirements:
641      *
642      * - The `operator` cannot be the caller.
643      *
644      * Emits an {ApprovalForAll} event.
645      */
646     function setApprovalForAll(address operator, bool _approved) external;
647 
648     /**
649      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
650      *
651      * See {setApprovalForAll}
652      */
653     function isApprovedForAll(address owner, address operator) external view returns (bool);
654 
655     /**
656      * @dev Safely transfers `tokenId` token from `from` to `to`.
657      *
658      * Requirements:
659      *
660      * - `from` cannot be the zero address.
661      * - `to` cannot be the zero address.
662      * - `tokenId` token must exist and be owned by `from`.
663      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
664      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
665      *
666      * Emits a {Transfer} event.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId,
672         bytes calldata data
673     ) external;
674 }
675 
676 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
677 
678 
679 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 
684 /**
685  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
686  * @dev See https://eips.ethereum.org/EIPS/eip-721
687  */
688 interface IERC721Enumerable is IERC721 {
689     /**
690      * @dev Returns the total amount of tokens stored by the contract.
691      */
692     function totalSupply() external view returns (uint256);
693 
694     /**
695      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
696      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
697      */
698     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
699 
700     /**
701      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
702      * Use along with {totalSupply} to enumerate all tokens.
703      */
704     function tokenByIndex(uint256 index) external view returns (uint256);
705 }
706 
707 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
708 
709 
710 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 
715 /**
716  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
717  * @dev See https://eips.ethereum.org/EIPS/eip-721
718  */
719 interface IERC721Metadata is IERC721 {
720     /**
721      * @dev Returns the token collection name.
722      */
723     function name() external view returns (string memory);
724 
725     /**
726      * @dev Returns the token collection symbol.
727      */
728     function symbol() external view returns (string memory);
729 
730     /**
731      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
732      */
733     function tokenURI(uint256 tokenId) external view returns (string memory);
734 }
735 
736 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
737 
738 
739 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 
744 
745 
746 
747 
748 
749 
750 /**
751  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
752  * the Metadata extension, but not including the Enumerable extension, which is available separately as
753  * {ERC721Enumerable}.
754  */
755 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
756     using Address for address;
757     using Strings for uint256;
758 
759     // Token name
760     string private _name;
761 
762     // Token symbol
763     string private _symbol;
764 
765     // Mapping from token ID to owner address
766     mapping(uint256 => address) private _owners;
767 
768     // Mapping owner address to token count
769     mapping(address => uint256) private _balances;
770 
771     // Mapping from token ID to approved address
772     mapping(uint256 => address) private _tokenApprovals;
773 
774     // Mapping from owner to operator approvals
775     mapping(address => mapping(address => bool)) private _operatorApprovals;
776 
777     /**
778      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
779      */
780     constructor(string memory name_, string memory symbol_) {
781         _name = name_;
782         _symbol = symbol_;
783     }
784 
785     /**
786      * @dev See {IERC165-supportsInterface}.
787      */
788     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
789         return
790             interfaceId == type(IERC721).interfaceId ||
791             interfaceId == type(IERC721Metadata).interfaceId ||
792             super.supportsInterface(interfaceId);
793     }
794 
795     /**
796      * @dev See {IERC721-balanceOf}.
797      */
798     function balanceOf(address owner) public view virtual override returns (uint256) {
799         require(owner != address(0), "ERC721: balance query for the zero address");
800         return _balances[owner];
801     }
802 
803     /**
804      * @dev See {IERC721-ownerOf}.
805      */
806     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
807         address owner = _owners[tokenId];
808         require(owner != address(0), "ERC721: owner query for nonexistent token");
809         return owner;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-name}.
814      */
815     function name() public view virtual override returns (string memory) {
816         return _name;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-symbol}.
821      */
822     function symbol() public view virtual override returns (string memory) {
823         return _symbol;
824     }
825 
826     /**
827      * @dev See {IERC721Metadata-tokenURI}.
828      */
829     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
830         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
831 
832         string memory baseURI = _baseURI();
833         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
834     }
835 
836     /**
837      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
838      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
839      * by default, can be overriden in child contracts.
840      */
841     function _baseURI() internal view virtual returns (string memory) {
842         return "";
843     }
844 
845     /**
846      * @dev See {IERC721-approve}.
847      */
848     function approve(address to, uint256 tokenId) public virtual override {
849         address owner = ERC721.ownerOf(tokenId);
850         require(to != owner, "ERC721: approval to current owner");
851 
852         require(
853             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
854             "ERC721: approve caller is not owner nor approved for all"
855         );
856 
857         _approve(to, tokenId);
858     }
859 
860     /**
861      * @dev See {IERC721-getApproved}.
862      */
863     function getApproved(uint256 tokenId) public view virtual override returns (address) {
864         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
865 
866         return _tokenApprovals[tokenId];
867     }
868 
869     /**
870      * @dev See {IERC721-setApprovalForAll}.
871      */
872     function setApprovalForAll(address operator, bool approved) public virtual override {
873         _setApprovalForAll(_msgSender(), operator, approved);
874     }
875 
876     /**
877      * @dev See {IERC721-isApprovedForAll}.
878      */
879     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
880         return _operatorApprovals[owner][operator];
881     }
882 
883     /**
884      * @dev See {IERC721-transferFrom}.
885      */
886     function transferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         //solhint-disable-next-line max-line-length
892         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
893 
894         _transfer(from, to, tokenId);
895     }
896 
897     /**
898      * @dev See {IERC721-safeTransferFrom}.
899      */
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public virtual override {
905         safeTransferFrom(from, to, tokenId, "");
906     }
907 
908     /**
909      * @dev See {IERC721-safeTransferFrom}.
910      */
911     function safeTransferFrom(
912         address from,
913         address to,
914         uint256 tokenId,
915         bytes memory _data
916     ) public virtual override {
917         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
918         _safeTransfer(from, to, tokenId, _data);
919     }
920 
921     /**
922      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
923      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
924      *
925      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
926      *
927      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
928      * implement alternative mechanisms to perform token transfer, such as signature-based.
929      *
930      * Requirements:
931      *
932      * - `from` cannot be the zero address.
933      * - `to` cannot be the zero address.
934      * - `tokenId` token must exist and be owned by `from`.
935      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _safeTransfer(
940         address from,
941         address to,
942         uint256 tokenId,
943         bytes memory _data
944     ) internal virtual {
945         _transfer(from, to, tokenId);
946         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
947     }
948 
949     /**
950      * @dev Returns whether `tokenId` exists.
951      *
952      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
953      *
954      * Tokens start existing when they are minted (`_mint`),
955      * and stop existing when they are burned (`_burn`).
956      */
957     function _exists(uint256 tokenId) internal view virtual returns (bool) {
958         return _owners[tokenId] != address(0);
959     }
960 
961     /**
962      * @dev Returns whether `spender` is allowed to manage `tokenId`.
963      *
964      * Requirements:
965      *
966      * - `tokenId` must exist.
967      */
968     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
969         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
970         address owner = ERC721.ownerOf(tokenId);
971         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
972     }
973 
974     /**
975      * @dev Safely mints `tokenId` and transfers it to `to`.
976      *
977      * Requirements:
978      *
979      * - `tokenId` must not exist.
980      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _safeMint(address to, uint256 tokenId) internal virtual {
985         _safeMint(to, tokenId, "");
986     }
987 
988     /**
989      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
990      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
991      */
992     function _safeMint(
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) internal virtual {
997         _mint(to, tokenId);
998         require(
999             _checkOnERC721Received(address(0), to, tokenId, _data),
1000             "ERC721: transfer to non ERC721Receiver implementer"
1001         );
1002     }
1003 
1004     /**
1005      * @dev Mints `tokenId` and transfers it to `to`.
1006      *
1007      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1008      *
1009      * Requirements:
1010      *
1011      * - `tokenId` must not exist.
1012      * - `to` cannot be the zero address.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _mint(address to, uint256 tokenId) internal virtual {
1017         require(to != address(0), "ERC721: mint to the zero address");
1018         require(!_exists(tokenId), "ERC721: token already minted");
1019 
1020         _beforeTokenTransfer(address(0), to, tokenId);
1021 
1022         _balances[to] += 1;
1023         _owners[tokenId] = to;
1024 
1025         emit Transfer(address(0), to, tokenId);
1026     }
1027 
1028     /**
1029      * @dev Destroys `tokenId`.
1030      * The approval is cleared when the token is burned.
1031      *
1032      * Requirements:
1033      *
1034      * - `tokenId` must exist.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _burn(uint256 tokenId) internal virtual {
1039         address owner = ERC721.ownerOf(tokenId);
1040 
1041         _beforeTokenTransfer(owner, address(0), tokenId);
1042 
1043         // Clear approvals
1044         _approve(address(0), tokenId);
1045 
1046         _balances[owner] -= 1;
1047         delete _owners[tokenId];
1048 
1049         emit Transfer(owner, address(0), tokenId);
1050     }
1051 
1052     /**
1053      * @dev Transfers `tokenId` from `from` to `to`.
1054      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1055      *
1056      * Requirements:
1057      *
1058      * - `to` cannot be the zero address.
1059      * - `tokenId` token must be owned by `from`.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _transfer(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) internal virtual {
1068         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1069         require(to != address(0), "ERC721: transfer to the zero address");
1070 
1071         _beforeTokenTransfer(from, to, tokenId);
1072 
1073         // Clear approvals from the previous owner
1074         _approve(address(0), tokenId);
1075 
1076         _balances[from] -= 1;
1077         _balances[to] += 1;
1078         _owners[tokenId] = to;
1079 
1080         emit Transfer(from, to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev Approve `to` to operate on `tokenId`
1085      *
1086      * Emits a {Approval} event.
1087      */
1088     function _approve(address to, uint256 tokenId) internal virtual {
1089         _tokenApprovals[tokenId] = to;
1090         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1091     }
1092 
1093     /**
1094      * @dev Approve `operator` to operate on all of `owner` tokens
1095      *
1096      * Emits a {ApprovalForAll} event.
1097      */
1098     function _setApprovalForAll(
1099         address owner,
1100         address operator,
1101         bool approved
1102     ) internal virtual {
1103         require(owner != operator, "ERC721: approve to caller");
1104         _operatorApprovals[owner][operator] = approved;
1105         emit ApprovalForAll(owner, operator, approved);
1106     }
1107 
1108     /**
1109      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1110      * The call is not executed if the target address is not a contract.
1111      *
1112      * @param from address representing the previous owner of the given token ID
1113      * @param to target address that will receive the tokens
1114      * @param tokenId uint256 ID of the token to be transferred
1115      * @param _data bytes optional data to send along with the call
1116      * @return bool whether the call correctly returned the expected magic value
1117      */
1118     function _checkOnERC721Received(
1119         address from,
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) private returns (bool) {
1124         if (to.isContract()) {
1125             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1126                 return retval == IERC721Receiver.onERC721Received.selector;
1127             } catch (bytes memory reason) {
1128                 if (reason.length == 0) {
1129                     revert("ERC721: transfer to non ERC721Receiver implementer");
1130                 } else {
1131                     assembly {
1132                         revert(add(32, reason), mload(reason))
1133                     }
1134                 }
1135             }
1136         } else {
1137             return true;
1138         }
1139     }
1140 
1141     /**
1142      * @dev Hook that is called before any token transfer. This includes minting
1143      * and burning.
1144      *
1145      * Calling conditions:
1146      *
1147      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1148      * transferred to `to`.
1149      * - When `from` is zero, `tokenId` will be minted for `to`.
1150      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1151      * - `from` and `to` are never both zero.
1152      *
1153      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1154      */
1155     function _beforeTokenTransfer(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) internal virtual {}
1160 }
1161 
1162 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1163 
1164 
1165 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1166 
1167 pragma solidity ^0.8.0;
1168 
1169 
1170 
1171 /**
1172  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1173  * enumerability of all the token ids in the contract as well as all token ids owned by each
1174  * account.
1175  */
1176 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1177     // Mapping from owner to list of owned token IDs
1178     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1179 
1180     // Mapping from token ID to index of the owner tokens list
1181     mapping(uint256 => uint256) private _ownedTokensIndex;
1182 
1183     // Array with all token ids, used for enumeration
1184     uint256[] private _allTokens;
1185 
1186     // Mapping from token id to position in the allTokens array
1187     mapping(uint256 => uint256) private _allTokensIndex;
1188 
1189     /**
1190      * @dev See {IERC165-supportsInterface}.
1191      */
1192     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1193         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1194     }
1195 
1196     /**
1197      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1198      */
1199     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1200         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1201         return _ownedTokens[owner][index];
1202     }
1203 
1204     /**
1205      * @dev See {IERC721Enumerable-totalSupply}.
1206      */
1207     function totalSupply() public view virtual override returns (uint256) {
1208         return _allTokens.length;
1209     }
1210 
1211     /**
1212      * @dev See {IERC721Enumerable-tokenByIndex}.
1213      */
1214     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1215         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1216         return _allTokens[index];
1217     }
1218 
1219     /**
1220      * @dev Hook that is called before any token transfer. This includes minting
1221      * and burning.
1222      *
1223      * Calling conditions:
1224      *
1225      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1226      * transferred to `to`.
1227      * - When `from` is zero, `tokenId` will be minted for `to`.
1228      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1229      * - `from` cannot be the zero address.
1230      * - `to` cannot be the zero address.
1231      *
1232      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1233      */
1234     function _beforeTokenTransfer(
1235         address from,
1236         address to,
1237         uint256 tokenId
1238     ) internal virtual override {
1239         super._beforeTokenTransfer(from, to, tokenId);
1240 
1241         if (from == address(0)) {
1242             _addTokenToAllTokensEnumeration(tokenId);
1243         } else if (from != to) {
1244             _removeTokenFromOwnerEnumeration(from, tokenId);
1245         }
1246         if (to == address(0)) {
1247             _removeTokenFromAllTokensEnumeration(tokenId);
1248         } else if (to != from) {
1249             _addTokenToOwnerEnumeration(to, tokenId);
1250         }
1251     }
1252 
1253     /**
1254      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1255      * @param to address representing the new owner of the given token ID
1256      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1257      */
1258     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1259         uint256 length = ERC721.balanceOf(to);
1260         _ownedTokens[to][length] = tokenId;
1261         _ownedTokensIndex[tokenId] = length;
1262     }
1263 
1264     /**
1265      * @dev Private function to add a token to this extension's token tracking data structures.
1266      * @param tokenId uint256 ID of the token to be added to the tokens list
1267      */
1268     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1269         _allTokensIndex[tokenId] = _allTokens.length;
1270         _allTokens.push(tokenId);
1271     }
1272 
1273     /**
1274      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1275      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1276      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1277      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1278      * @param from address representing the previous owner of the given token ID
1279      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1280      */
1281     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1282         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1283         // then delete the last slot (swap and pop).
1284 
1285         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1286         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1287 
1288         // When the token to delete is the last token, the swap operation is unnecessary
1289         if (tokenIndex != lastTokenIndex) {
1290             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1291 
1292             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1293             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1294         }
1295 
1296         // This also deletes the contents at the last position of the array
1297         delete _ownedTokensIndex[tokenId];
1298         delete _ownedTokens[from][lastTokenIndex];
1299     }
1300 
1301     /**
1302      * @dev Private function to remove a token from this extension's token tracking data structures.
1303      * This has O(1) time complexity, but alters the order of the _allTokens array.
1304      * @param tokenId uint256 ID of the token to be removed from the tokens list
1305      */
1306     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1307         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1308         // then delete the last slot (swap and pop).
1309 
1310         uint256 lastTokenIndex = _allTokens.length - 1;
1311         uint256 tokenIndex = _allTokensIndex[tokenId];
1312 
1313         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1314         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1315         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1316         uint256 lastTokenId = _allTokens[lastTokenIndex];
1317 
1318         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1319         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1320 
1321         // This also deletes the contents at the last position of the array
1322         delete _allTokensIndex[tokenId];
1323         _allTokens.pop();
1324     }
1325 }
1326 
1327 // File: contracts/NoundleTheory.sol
1328 
1329 pragma solidity ^0.8.0;
1330 
1331 
1332 
1333 
1334 
1335 
1336 interface InterfaceRainbows {
1337     function transferTokens(address _from, address _to) external;
1338     function burn(address user, uint256 amount) external;
1339 }
1340 
1341 interface InterfaceOriginals {
1342     function ownerOf(uint256 tokenId) external view returns (address);
1343     function getNoundlesFromWallet(address _noundles) external view returns (uint256[] memory);
1344 }
1345 
1346 interface InterfaceRandomNumber {
1347     function getRandomNumber(uint256 arg) external returns (uint);
1348 }
1349 
1350 /*
1351     :)
1352 */
1353 contract NoundleTheory is ERC721, ERC721Enumerable, Ownable {
1354 
1355     // Interfaces to interact with the other contracts
1356     InterfaceRainbows public Rainbows;
1357     InterfaceOriginals public Originals;
1358     InterfaceRandomNumber public RandomNumber;
1359 
1360     /*
1361      * Constants
1362      * MAX_EVIL_NOUNDLES        = Maximum Supply for Evil Noundles that could be minted
1363      * MAX_COMPANION_NOUNDLES   = Maximum Supply for public mint with eth or rainbows (with 100% chance at companion).
1364      * MAX_FREE_COMPANION_MINTS = Maximum Supply for every Noundle holder to mint one companion
1365      * MAX_FREE_LAND_MINTS      = Maximum Supply for every Genesis Noundle Holder to mint some land (you deserve it kings)
1366      * MAX_RESERVED_EVIL        = Evil Reserved noundles for the team for giveaways, advisors, etc.
1367      * MAX_RESERVED_LAND        = Land Reserved noundles for the team for giveaways, advisors, etc.
1368      * MAX_RESERVED_COMP        = Companions Reserved noundles for the team for giveaways, advisors, etc.
1369      */
1370     uint256 public constant MAX_EVIL_NOUNDLES        = 40000;
1371     uint256 public constant MAX_COMPANION_NOUNDLES   = 7000;
1372     uint256 public constant MAX_FREE_COMPANION_MINTS = 8888;
1373     uint256 public constant MAX_FREE_LAND_MINTS      = 8888;
1374     uint256 public constant MAX_RESERVED_EVIL        = 250;
1375     uint256 public constant MAX_RESERVED_LAND        = 250;
1376     uint256 public constant MAX_RESERVED_COMP        = 250;
1377 
1378     // Track all the mintable tokens.
1379     uint256[] public companionList;
1380     uint256[] public evilList;
1381     uint256[] public lowLandList;
1382     uint256[] public midLandList;
1383     uint256[] public highLandList;
1384 
1385     // Each number is based on a %
1386     uint256 public percentEvil      = 10;
1387     uint256 public percentSteal     = 10;
1388     uint256 public percentJail      = 10;
1389     uint256 public percentLowLand   = 75;
1390     uint256 public percentMidLand   = 20;
1391     uint256 public percentHighLand  = 5;
1392 
1393     // Total minted of each kind.
1394     uint256 public mintCountCompanions = 0;
1395     uint256 public mintCountEvil       = 0;
1396     uint256 public mintCountLandLow    = 0;
1397     uint256 public mintCountLandMid    = 0;
1398     uint256 public mintCountLandHigh   = 0;
1399 
1400     // Public minting costs - these will most likely change when contract is deployed, so don't look to deep into them
1401     uint256 public publicMintCompanionPriceEth     = 0.1 ether;
1402     uint256 public publicMintCompanionPriceRainbow = 20 ether;
1403     uint256 public evilMintPriceRainbow            = 20 ether;
1404     uint256 public landMintPriceRainbow            = 50 ether;
1405 
1406     // Track the free mints for companions and evil noundle mints
1407     uint256 public freeCompanionMint = 0;
1408     uint256 public evilNoundleMint   = 0;
1409 
1410     // Tracks the reserved mints to make sure we don't go over it
1411     uint256 public reservedEvil = 0;
1412     uint256 public reservedLand = 0;
1413     uint256 public reservedComp = 0;
1414 
1415     // Track the whitelisted evil noundles
1416     mapping(address => bool) evilNoundleAllowed;
1417     mapping(address => bool) evilNoundleMinted;
1418     mapping(address => bool) freeCompanionAllowed;
1419     mapping(address => bool) freeCompanionMinted;
1420     mapping(address => bool) alreadyPublicMinted;
1421     bool public overrideAlreadyPublicMinted = false;
1422 
1423     // Track the whitelisted land owners
1424     mapping(address => bool) landAllowed;
1425     mapping(address => bool) landMinted;
1426 
1427     // Tracks the tokens that were already used to mint companions - prevents people from transfering their token to new wallets and claiming again :)
1428     mapping(uint256 => bool) alreadyMintedNoundles;
1429 
1430     // Tracks the tokens that were already used to mint land
1431     mapping(uint256 => bool) alreadyMintedLandNoundles;
1432 
1433     // Minting Settings
1434     bool    public saleEnabled = false;
1435     uint256 public saleOneTime = 0;
1436     uint256 public saleTwoTime = 0; // lands + more :)
1437 
1438     // $RAINBOW Minting costs
1439     bool    public rainbowMintingEnabled = false;
1440     uint256 public rBaseMintPriceTier1   = 40.0 ether;
1441     uint256 public rBaseMintPriceTier2   = 80.0 ether;
1442     uint256 public rBaseMintPriceTier3   = 120.0 ether;
1443     uint256 public tier2Start            = 10000;
1444     uint256 public tier3Start            = 17500;
1445 
1446     // Jail Settings
1447     uint256 public jailLength    = 10800;
1448     uint256 public getOutOfJail  = 2.0 ether;
1449     mapping (uint256 => uint256) public jailHouse;
1450 
1451     // Counters.
1452     uint256 public counterStolenAttempted = 0;
1453     uint256 public counterStolen          = 0;
1454     uint256 public counterBail            = 0;
1455     uint256 public counterJailed          = 0;
1456 
1457     // Most Wanted
1458     mapping (address => uint256) public mostWantedValues;
1459     address [] public mostWantedMembers;
1460 
1461     // Tracks the amount of tokens for Noundle Theory
1462     mapping (address => uint256) public companionBalance;
1463     mapping (address => uint256) public evilBalance;
1464 
1465     // different tiers give different protection bonuses when being robbed
1466     mapping (address => uint256) public lowLandBalance;
1467     mapping (address => uint256) public midLandBalance;
1468     mapping (address => uint256) public highLandBalance;
1469 
1470     /*
1471      * The types of Noundles in the Noundle Theory Game
1472      * 0 - companions
1473      * 1 - evil noundles
1474      * 2 - low tier land (phase 2)
1475      * 3 - mid tier land (phase 3)
1476      * 4 - high tier land (phase 4)
1477      **/
1478     mapping (uint256 => uint8) public noundleType;
1479     mapping (uint256 => uint256) public noundleOffsetCount;
1480 
1481     // Rest of the contract settings
1482     string  private baseURI;
1483     address public founder1;
1484     address public founder2;
1485 
1486     // Modifiers
1487     modifier isSaleEnabled() {
1488         require(saleEnabled, "Cannot be sold yet.");
1489         _;
1490     }
1491 
1492     modifier isPhaseOneStarted() {
1493         require(block.timestamp >= saleOneTime && saleOneTime > 0, "Phase One hasn't started");
1494         _;
1495     }
1496 
1497     modifier isPhaseTwoStarted() {
1498         require(block.timestamp >= saleTwoTime && saleTwoTime > 0, "Phase Two hasn't started");
1499         _;
1500     }
1501 
1502     modifier isRainbowMintingEnabled() {
1503         require(rainbowMintingEnabled, "Cannot mint with $RAINBOWS yet.");
1504         _;
1505     }
1506 
1507     constructor(string memory _uri) ERC721("NOUNDLETHEORY", "NOUNDLETHEORY") {
1508         baseURI = _uri;
1509     }
1510 
1511     // Adds a user to the claimable evil noundle mint
1512     function addEvilNoundlers(address[] memory _noundles) public onlyOwner {
1513         for (uint256 __noundles;__noundles < _noundles.length;__noundles++) {
1514             evilNoundleAllowed[_noundles[__noundles]] = true;
1515         }
1516     }
1517 
1518     // Check if a address is on the free mint.
1519     function checkEvilNoundlers(address _noundles) public view returns (bool) {
1520         return evilNoundleAllowed[_noundles];
1521     }
1522 
1523     // Adds a user to the claimable free noundle mint
1524     function addFreeNoundlers(address[] memory _noundles) public onlyOwner {
1525         for (uint256 __noundles;__noundles < _noundles.length;__noundles++) {
1526             freeCompanionAllowed[_noundles[__noundles]] = true;
1527         }
1528     }
1529 
1530     // Check if a address is on the free mint.
1531     function checkFreeNoundlers(address _noundles) public view returns (bool) {
1532         return freeCompanionAllowed[_noundles];
1533     }
1534 
1535 
1536     // generic minting function :)
1537     function _handleMinting(address _to, uint256 _index, uint8 _type) private {
1538 
1539         // Attempt to mint.
1540         _safeMint(_to, _index);
1541 
1542         // Set it's type in place.
1543         noundleType[_index] = _type;
1544 
1545         if (_type == 0) {
1546             companionBalance[msg.sender]++;
1547             companionList.push(_index);
1548             noundleOffsetCount[_index] = mintCountCompanions;
1549             mintCountCompanions++;
1550         } else if (_type == 1) {
1551             evilBalance[msg.sender]++;
1552             evilList.push(_index);
1553             noundleOffsetCount[_index] = mintCountEvil;
1554             mintCountEvil++;
1555         } else if (_type == 2) {
1556             lowLandBalance[msg.sender]++;
1557             lowLandList.push(_index);
1558             noundleOffsetCount[_index] = mintCountLandLow;
1559             mintCountLandLow++;
1560         } else if (_type == 3) {
1561             midLandBalance[msg.sender]++;
1562             midLandList.push(_index);
1563             noundleOffsetCount[_index] = mintCountLandMid;
1564             mintCountLandMid++;
1565         } else {
1566             highLandBalance[msg.sender]++;
1567             highLandList.push(_index);
1568             noundleOffsetCount[_index] = mintCountLandHigh;
1569             mintCountLandHigh++;
1570         }
1571     }
1572 
1573     // Reserves some of the supply of the noundles for giveaways & the community
1574     function reserveNoundles(uint256 _amount, uint8 _type) public onlyOwner {
1575         // enforce reserve limits based on type claimed
1576         if (_type == 0) {
1577             require(reservedComp + _amount <= MAX_RESERVED_COMP, "Cannot reserve more companions!");
1578         } else if (_type == 1) {
1579             require(reservedEvil + _amount <= MAX_RESERVED_EVIL, "Cannot reserve more evil noundles!");
1580         } else {
1581             require(reservedLand + _amount <= MAX_RESERVED_LAND, "Cannot reserve more land!");
1582         }
1583 
1584         uint256 _ts = totalSupply();
1585 
1586         // Mint the reserves.
1587         for (uint256 i; i < _amount; i++) {
1588             _handleMinting(msg.sender, _ts + i, _type);
1589 
1590             if (_type == 0) {
1591                 reservedComp++;
1592             } else if (_type == 1) {
1593                 reservedEvil++;
1594             } else {
1595                 reservedLand++;
1596             }
1597         }
1598     }
1599 
1600     // Mint your evil noundle.
1601     function claimEvilNoundle() public payable isPhaseOneStarted {
1602         uint256 __noundles = totalSupply();
1603 
1604         // Verify request.
1605         require(freeCompanionMint + 1 <= MAX_FREE_COMPANION_MINTS,   "We ran out of evil noundles :(");
1606         require(evilNoundleAllowed[msg.sender],         "You are not on whitelist");
1607         require(evilNoundleMinted[msg.sender] == false, "You already minted your free noundle.");
1608 
1609         // Make sure that the wallet is holding at least 1 noundle.
1610         require(Originals.getNoundlesFromWallet(msg.sender).length > 0, "You must hold at least one Noundle to mint");
1611 
1612         // Burn the rainbows.
1613         Rainbows.burn(msg.sender, evilMintPriceRainbow);
1614 
1615         // Mark it as they already got theirs.
1616         evilNoundleMinted[msg.sender] = true;
1617 
1618         // Add to our free mint count.
1619         freeCompanionMint += 1;
1620 
1621         // Mint it.
1622         _handleMinting(msg.sender, __noundles, 1);
1623     }
1624 
1625     // Mint your free companion.
1626     function mintHolderNoundles() public payable isPhaseOneStarted {
1627         uint256 __noundles = totalSupply();
1628 
1629         // Verify request.
1630         require(freeCompanionMint + 1 <= MAX_FREE_COMPANION_MINTS,   "We ran out of evil noundles :(");
1631         require(freeCompanionAllowed[msg.sender],                    "You are not on whitelist");
1632         require(freeCompanionMinted[msg.sender] == false,            "You already minted your free companion.");
1633 
1634         // Make sure that the wallet is holding at least 1 noundle.
1635         require(Originals.getNoundlesFromWallet(msg.sender).length > 0, "You must hold at least one Noundle to mint");
1636 
1637         // Mark it as they already got theirs.
1638         freeCompanionMinted[msg.sender] = true;
1639 
1640         // Add to our free mint count.
1641         freeCompanionMint += 1;
1642 
1643         // Mint it.
1644         _handleMinting(msg.sender, __noundles, 0);
1645     }
1646 
1647     // Mint your companion (with Eth).
1648     function mintNoundles(uint256 _noundles) public payable isPhaseOneStarted {
1649         uint256 __noundles = totalSupply();
1650 
1651         // Make sure to Do you even read these
1652         require(_noundles > 0 && _noundles <= 5,               "Your amount needs to be greater then 0 and can't exceed 5");
1653         require(_noundles * publicMintCompanionPriceEth <= msg.value,   "Ser we need more money for your noundles");
1654         require(_noundles + __noundles <= MAX_COMPANION_NOUNDLES, "We ran out of noundles! Try minting with less!");
1655         require(alreadyPublicMinted[msg.sender] == false || overrideAlreadyPublicMinted, "You cannot mint twice");
1656 
1657         alreadyPublicMinted[msg.sender] = true;
1658 
1659         for (uint256 ___noundles; ___noundles < _noundles; ___noundles++) {
1660             _handleMinting(msg.sender,  __noundles + ___noundles, 0);
1661         }
1662     }
1663 
1664     // Mint your companion (with $RAINBOWS).
1665     function mintNoundlesWithRainbows(uint256 _noundles) public payable isPhaseOneStarted {
1666         uint256 __noundles = totalSupply();
1667 
1668         // Make sure to Do you even read these
1669         require(_noundles > 0 && _noundles <= 5,              "Your amount needs to be greater then 0 and can't exceed 5");
1670         require(_noundles + __noundles <= MAX_COMPANION_NOUNDLES, "We ran out of noundles! Try minting with less!");
1671         require(alreadyPublicMinted[msg.sender] == false || overrideAlreadyPublicMinted, "You cannot mint twice");
1672 
1673         // Burn the rainbows.
1674         Rainbows.burn(msg.sender, publicMintCompanionPriceRainbow * _noundles);
1675 
1676         alreadyPublicMinted[msg.sender] = true;
1677 
1678         // Mint it.
1679         for (uint256 ___noundles; ___noundles < _noundles; ___noundles++) {
1680             _handleMinting(msg.sender, __noundles + ___noundles, 0);
1681         }
1682     }
1683 
1684     /*
1685         Rainbow Minting.
1686     */
1687     function _handleRainbowMinting(address _to, uint256 index) private {
1688 
1689         // make a copy of who is getting it.
1690         address to = _to;
1691 
1692         // Determine what kind of mint it should be.
1693         uint8 _type = 0;
1694 
1695         // If we determine it's evil.
1696         if(percentChance(index, 100, percentEvil)){
1697             _type = 1;
1698         }
1699 
1700         // Determine if it was stolen, give it to the evil noundle owner.
1701         if(percentChance(index, 100, percentSteal)){
1702             uint256 evilTokenId = getRandomEvilNoundle(index, 0);
1703 
1704             // If it's 0 then we don't have a evil noundle to give it to.
1705             if(evilTokenId != 0){
1706 
1707                 counterStolenAttempted += 1;
1708 
1709                 // Check if it failed to steal and needs to go to jail.
1710                 if(percentChance(index, 100, percentJail)){
1711                     jailHouse[evilTokenId] = block.timestamp;
1712 
1713                     counterJailed += 1;
1714                 }else{
1715                     // The evil noundle stole the nft.
1716                     to = ownerOf(evilTokenId);
1717                     counterStolen += 1;
1718 
1719                     // Add to the most wanted.
1720                     if(mostWantedValues[to] == 0){
1721                         mostWantedMembers.push(to);
1722                     }
1723 
1724                     mostWantedValues[to] += 1;
1725                 }
1726             }
1727         }
1728 
1729         // Burn the rainbows.
1730         Rainbows.burn(msg.sender, costToMintWithRainbows());
1731 
1732         // Mint it.
1733         _handleMinting(to, index, _type);
1734     }
1735 
1736     // Handle consuming rainbow to mint a new NFT with random chance.
1737     function mintWithRainbows(uint256 _noundles) public payable isRainbowMintingEnabled {
1738         uint256 __noundles = totalSupply();
1739 
1740         require(_noundles > 0 && _noundles <= 10,              "Your amount needs to be greater then 0 and can't exceed 10");
1741         require(_noundles + (mintCountCompanions + mintCountEvil) <= MAX_EVIL_NOUNDLES, "We ran out of noundles! Try minting with less!");
1742 
1743         for (uint256 ___noundles; ___noundles < _noundles; ___noundles++) {
1744             _handleRainbowMinting(msg.sender,  __noundles + ___noundles);
1745         }
1746     }
1747 
1748     // Mint your free lkand.
1749     function mintHolderLandNoundles(uint256 _noundles) public payable isPhaseTwoStarted {
1750         uint256 __noundles = totalSupply();
1751 
1752         require(_noundles > 0 && _noundles <= 10, "Your amount needs to be greater then 0 and can't exceed 10");
1753         require(_noundles + __noundles <= MAX_FREE_LAND_MINTS, "We ran out of land! Try minting with less!");
1754 
1755         // The noundles that the sender is holding.
1756         uint256[] memory holdingNoundles = Originals.getNoundlesFromWallet(msg.sender);
1757 
1758         uint256 offset = 0;
1759 
1760         // Mint as many as they are holding.
1761         for (uint256 index; (index < holdingNoundles.length) && index < _noundles; index += 1){
1762 
1763             // Check if it has been minted before.
1764             if(alreadyMintedLandNoundles[holdingNoundles[index]]){
1765                 continue;
1766             }
1767 
1768             uint8 _type = 2;
1769 
1770             // Pick a random type of land.
1771             if(percentChance(__noundles + offset, (percentLowLand + percentMidLand + percentHighLand), percentHighLand)){
1772                 _type = 4;
1773             }else if(percentChance(__noundles + offset, (percentLowLand + percentMidLand + percentHighLand), percentMidLand)){
1774                 _type = 3;
1775             }
1776 
1777             // Burn the rainbows.
1778             Rainbows.burn(msg.sender, landMintPriceRainbow);
1779 
1780             // Mark it as minted.
1781             alreadyMintedLandNoundles[holdingNoundles[index]] = true;
1782 
1783             // Mint it.
1784             _handleMinting(msg.sender,  __noundles + offset, _type);
1785 
1786             // Go to the next offset.
1787             offset += 1;
1788         }
1789     }
1790 
1791 
1792     /*
1793         Jail Related
1794     */
1795     // Get a evil out of jail.
1796     function getOutOfJailByTokenId(uint256 _tokenId) public payable isRainbowMintingEnabled {
1797 
1798         // Check that it is a evil noundle.
1799         require(noundleType[_tokenId] == 1, "Only evil noundles can go to jail.");
1800 
1801         // Burn the rainbows to get out of jail.
1802         Rainbows.burn(msg.sender, getOutOfJail);
1803 
1804         // Reset the jail time.
1805         jailHouse[_tokenId] = 1;
1806 
1807         // Stat track.
1808         counterBail += 1;
1809     }
1810 
1811 
1812     /*
1813         Helpers
1814     */
1815     function setPayoutAddresses(address[] memory _noundles) public onlyOwner {
1816         founder1 = _noundles[0];
1817         founder2 = _noundles[1];
1818     }
1819 
1820     function withdrawFunds(uint256 _noundles) public payable onlyOwner {
1821         uint256 percentle = _noundles / 100;
1822 
1823         require(payable(founder1).send(percentle * 50));
1824         require(payable(founder2).send(percentle * 50));
1825     }
1826 
1827     // Pick a evil noundle randomly from our list.
1828     function getRandomEvilNoundle(uint256 index, uint256 depth) internal returns(uint256) {
1829         uint256 selectedIndex = RandomNumber.getRandomNumber(index) % evilList.length;
1830 
1831         // If it's not in jail.
1832         if(jailHouse[evilList[selectedIndex]] + jailLength < block.timestamp){
1833             return evilList[selectedIndex];
1834         }
1835 
1836         // If we can't find one in 100 attempts, select none.
1837         if(depth > 99){
1838             return 0;
1839         }
1840 
1841         // If it's in jail, it can't steal so try again.
1842         return getRandomEvilNoundle(index, depth + 1);
1843     }
1844 
1845     // Pick a evil noundle randomly from our list.
1846     function percentChance(uint256 index, uint256 total, uint256 chance) internal returns(bool) {
1847         if((RandomNumber.getRandomNumber(index) % total) < chance){
1848             return true;
1849         }else{
1850             return false;
1851         }
1852     }
1853 
1854     // Determine how much to mint a one with rainbows.
1855     function costToMintWithRainbows() public view returns(uint256) {
1856 
1857         uint256 total = mintCountCompanions + mintCountEvil;
1858 
1859         if(total >= tier2Start){
1860             return rBaseMintPriceTier2;
1861         }
1862         if(total >= tier3Start){
1863             return rBaseMintPriceTier3;
1864         }
1865 
1866         return rBaseMintPriceTier1;
1867     }
1868 
1869     // Gets the noundle theory tokens and returns a array with all the tokens owned
1870     function getNoundlesFromWallet(address _noundles) external view returns (uint256[] memory) {
1871         uint256 __noundles = balanceOf(_noundles);
1872 
1873         uint256[] memory ___noundles = new uint256[](__noundles);
1874         for (uint256 i;i < __noundles;i++) {
1875             ___noundles[i] = tokenOfOwnerByIndex(_noundles, i);
1876         }
1877 
1878         return ___noundles;
1879     }
1880 
1881     // Returns the addresses that own any evil noundle - seems rare :eyes:
1882     function getEvilNoundleOwners() external view returns (address[] memory) {
1883         address[] memory result = new address[](evilList.length);
1884 
1885         for(uint256 index; index < evilList.length; index += 1){
1886             if(jailHouse[evilList[index]] + jailLength <= block.timestamp){
1887                 result[index] = ownerOf(evilList[index]);
1888             }
1889         }
1890 
1891         return result;
1892     }
1893 
1894     // Helper to convert int to string (thanks stack overflow).
1895     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1896         if (_i == 0) {
1897             return "0";
1898         }
1899         uint j = _i;
1900         uint len;
1901         while (j != 0) {
1902             len++;
1903             j /= 10;
1904         }
1905         bytes memory bstr = new bytes(len);
1906         uint k = len;
1907         while (_i != 0) {
1908             k = k-1;
1909             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1910             bytes1 b1 = bytes1(temp);
1911             bstr[k] = b1;
1912             _i /= 10;
1913         }
1914         return string(bstr);
1915     }
1916 
1917     // Most wanted.
1918     function getMostWanted() external view returns(address[] memory) {return mostWantedMembers;}
1919     function getMostWantedValue(address _arg) external view returns(uint256) {return mostWantedValues[_arg];}
1920     function resetMostWanted() public onlyOwner {
1921 
1922         // Reset the value for each.
1923         for(uint256 i = 0; i < mostWantedMembers.length; i += 1){
1924             mostWantedValues[mostWantedMembers[i]] = 0;
1925         }
1926 
1927         // Clear most wanted.
1928         delete mostWantedMembers;
1929     }
1930 
1931     // Contract Getters
1932     function _baseURI() internal view override returns (string memory) { return baseURI; }
1933     function getTypeByTokenId(uint256 _tokenId) external view returns (uint8) { return noundleType[_tokenId]; }
1934     function getTypeByTokenIds(uint256[] memory _tokenId) external view returns(uint8[] memory) {
1935         uint8[] memory result = new uint8[](_tokenId.length);
1936 
1937         for (uint256 index; index < _tokenId.length; index += 1) {
1938             result[index] = noundleType[_tokenId[index]];
1939         }
1940 
1941         return result;
1942     }
1943     function getFreeMintUsedByTokenId(uint256 _tokenId) external view returns (bool){ return alreadyMintedNoundles[_tokenId]; }
1944     function getFreeLandMintUsedByTokenId(uint256 _tokenId) external view returns (bool){ return alreadyMintedLandNoundles[_tokenId]; }
1945     function getJailStatus(uint256 _tokenId) external view returns (uint256){ return jailHouse[_tokenId]; }
1946     function getJailStatusBool(uint256 _tokenId) public view returns (bool){ return (jailHouse[_tokenId] + jailLength > block.timestamp); }
1947 
1948     // Contract Setters (pretty standard :))
1949     function setBaseURI(string memory arg) public onlyOwner { baseURI = arg; }
1950     function setSaleEnabled() public onlyOwner { saleEnabled = true; }
1951     function setRandomNumberGenerator(address _arg) public onlyOwner { RandomNumber = InterfaceRandomNumber(_arg); }
1952     function setPhaseOneSaleTime(uint256 _arg) public onlyOwner { saleOneTime = _arg; }
1953     function setPhaseTwoSaleTime(uint256 _arg) public onlyOwner { saleTwoTime = _arg; }
1954     function setMintPriceEth(uint256 _arg) public onlyOwner { publicMintCompanionPriceEth = _arg; }
1955     function setMintPriceRain(uint256 _arg) public onlyOwner { publicMintCompanionPriceRainbow = _arg; }
1956     function setEvilMintCostRainbows(uint256 _arg) external onlyOwner { evilMintPriceRainbow = _arg; }
1957     function setLandMintCostRainbows(uint256 _arg) external onlyOwner { landMintPriceRainbow = _arg; }
1958     function setOverrideAlreadyPublicMinted(bool _arg) external onlyOwner { overrideAlreadyPublicMinted = _arg; }
1959 
1960     // Noundle Theory Setters (incase we need to balance some things out)
1961     function setLowLandPercent(uint256 _amount) public onlyOwner { percentLowLand = _amount; }
1962     function setMidLandPercent(uint256 _amount) public onlyOwner { percentMidLand = _amount; }
1963     function setHighLandPercent(uint256 _amount) public onlyOwner { percentHighLand = _amount; }
1964     function setEvilPercent(uint256 _amount) public onlyOwner { percentEvil = _amount; }
1965     function setJailPercent(uint256 _amount) public onlyOwner { percentJail = _amount; }
1966     function setStealPercent(uint256 _amount) public onlyOwner { percentSteal = _amount; }
1967     function setJailTime(uint256 _amount) external onlyOwner { jailLength = _amount; }
1968     function setGetOutOfJailCost(uint256 _amount) external onlyOwner { getOutOfJail = _amount; }
1969     function setJailTimeForEvil(uint256 _tokenId, uint256 _amount) external onlyOwner { jailHouse[_tokenId] = _amount; }
1970 
1971     // Contract Setters for the Genesis Contract
1972     function setGenesisAddress(address _genesis) external onlyOwner { Originals = InterfaceOriginals(_genesis); }
1973 
1974     // Contract Setters for the Rainbows Contract
1975     function setRainbowMintStatus(bool _arg) public onlyOwner { rainbowMintingEnabled = _arg; }
1976     function setBaseMintPriceTier1(uint256 _arg) public onlyOwner { rBaseMintPriceTier1 = _arg; }
1977     function setBaseMintPriceTier2(uint256 _arg) public onlyOwner { rBaseMintPriceTier2 = _arg; }
1978     function setBaseMintPriceTier3(uint256 _arg) public onlyOwner { rBaseMintPriceTier3 = _arg; }
1979     function setTier2Start(uint256 _arg) public onlyOwner { tier2Start = _arg; }
1980     function setTier3Start(uint256 _arg) public onlyOwner { tier3Start = _arg; }
1981     function setRainbowAddress(address _rainbow) external onlyOwner { Rainbows = InterfaceRainbows(_rainbow); }
1982 
1983     // opensea / ERC721 functions
1984     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1985         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1986 
1987         string memory base = _baseURI();
1988 
1989         return string(abi.encodePacked(base, uint2str(noundleType[tokenId]), "/", uint2str(noundleOffsetCount[tokenId])));
1990     }
1991 
1992     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1993         super._beforeTokenTransfer(from, to, tokenId);
1994     }
1995 
1996     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1997         return super.supportsInterface(interfaceId);
1998     }
1999 
2000     function transferFrom(address from, address to, uint256 tokenId) public override isSaleEnabled {
2001         Rainbows.transferTokens(from, to);
2002 
2003         if (noundleType[tokenId] == 0) {
2004             companionBalance[from]++;
2005             companionBalance[to]--;
2006         } else if (noundleType[tokenId] == 2) {
2007             evilBalance[from]++;
2008             evilBalance[to]--;
2009         } else if (noundleType[tokenId] == 3) {
2010             lowLandBalance[from]++;
2011             lowLandBalance[to]--;
2012         } else if (noundleType[tokenId] == 4) {
2013             midLandBalance[from]++;
2014             midLandBalance[to]--;
2015         } else {
2016             highLandBalance[from]++;
2017             highLandBalance[to]--;
2018         }
2019 
2020         ERC721.transferFrom(from, to, tokenId);
2021     }
2022 
2023     function safeTransferFrom(address from, address to, uint256 tokenId) public override isSaleEnabled {
2024         Rainbows.transferTokens(from, to);
2025 
2026         if (noundleType[tokenId] == 0) {
2027             companionBalance[from]++;
2028             companionBalance[to]--;
2029         } else if (noundleType[tokenId] == 2) {
2030             evilBalance[from]++;
2031             evilBalance[to]--;
2032         } else if (noundleType[tokenId] == 3) {
2033             lowLandBalance[from]++;
2034             lowLandBalance[to]--;
2035         } else if (noundleType[tokenId] == 4) {
2036             midLandBalance[from]++;
2037             midLandBalance[to]--;
2038         } else {
2039             highLandBalance[from]++;
2040             highLandBalance[to]--;
2041         }
2042 
2043         ERC721.safeTransferFrom(from, to, tokenId);
2044     }
2045 
2046     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override isSaleEnabled {
2047         Rainbows.transferTokens(from, to);
2048 
2049         if (noundleType[tokenId] == 0) {
2050             companionBalance[from]++;
2051             companionBalance[to]--;
2052         } else if (noundleType[tokenId] == 2) {
2053             evilBalance[from]++;
2054             evilBalance[to]--;
2055         } else if (noundleType[tokenId] == 3) {
2056             lowLandBalance[from]++;
2057             lowLandBalance[to]--;
2058         } else if (noundleType[tokenId] == 4) {
2059             midLandBalance[from]++;
2060             midLandBalance[to]--;
2061         } else {
2062             highLandBalance[from]++;
2063             highLandBalance[to]--;
2064         }
2065 
2066         ERC721.safeTransferFrom(from, to, tokenId, data);
2067     }
2068 }