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
1327 // File: contracts/words final.sol
1328 
1329 
1330 
1331 pragma solidity >=0.7.0 <0.9.0;
1332 
1333 
1334 
1335 
1336 contract WORDFACES is ERC721Enumerable, Ownable {
1337   using Strings for uint256;
1338 
1339   string baseURI;
1340   string public baseExtension = ".json";
1341   
1342   uint256 public costWhitelisted = 0.04 ether; //presale price
1343   uint256 public cost = 0.06 ether; //public sale price
1344 
1345   uint256 public maxSupply = 2222; //max supply
1346   uint256 public maxSupplyPresale = 750; //presale max supply
1347 
1348   uint256 public maxMintAmount = 10; //max nfts per trx
1349   uint256 public nftPerAddressLimit = 3; //max nfts per wallet on presale
1350 
1351   bool public paused = false;
1352   bool public revealed = false;
1353 
1354   string public notRevealedUri;
1355   
1356   address[] public whitelistedAddresses;
1357  
1358   uint public presaleStartTimestamp = 1640008800; //DEC 20 2PM UTC Presale
1359   uint public mintingStartTimestamp = 1640095200; //DEC 21 2PM UTC Public Sale
1360   
1361   uint public moneyProportionForReward = 15; 
1362 
1363   uint256 public moneyOwner; 
1364   uint256 public moneyReward; 
1365 
1366   uint256 public moneyReward_Init; 
1367   uint256 public moneyReward_Payed;
1368   
1369   uint public money_Calculate;
1370  
1371   //Payout dates
1372   uint[] public rewardsTimestamp = 
1373   [
1374     1640995200, //JAN 1 2022
1375     1643673600, //FEB 1 2022
1376     1646092800, //Mar 1 2022
1377     1648771200, //Apr 1 2022
1378     1651363200, //May 1 2022
1379     1654041600, //June 1 2022
1380     1656633600, //July 1 2022
1381     1659312000, //Aug 1 2022
1382     1661990400, //Sept 1 2022
1383     1664582400, //Oct 1 2022
1384     1667260800, //Nov 1 2022
1385     1669852800  //Dec 1 2022
1386   ];
1387 
1388   uint[] public moneyReward_AddedPerMonth = [0,0,0, 0,0,0, 0,0,0, 0,0,0];
1389 
1390   TokenWithReward[] public tokensReward;
1391   struct TokenWithReward 
1392   {
1393     uint id;
1394     uint256 reward;//Payout share
1395     uint256 timestamp; //Last payout date
1396   }
1397   
1398   mapping(address => uint256) public addressMintedBalance;
1399    
1400   using Counters for Counters.Counter;
1401   Counters.Counter private _tokenCount;
1402   uint256 private startFrom = 1;
1403   mapping(uint256 => uint256) private tokenMatrix_Presale;
1404   mapping(uint256 => uint256) private tokenMatrix;
1405   using Strings for uint256;
1406   
1407 
1408   constructor(string memory _initNotRevealedUri) 
1409   ERC721("The WordFaces NFTs", "WordFace") 
1410   {
1411     setNotRevealedURI(_initNotRevealedUri);
1412     
1413     //Diamond WordFaces
1414     addTokenWithReward(1, 19);
1415     addTokenWithReward(2222, 19);
1416 
1417     //Gold WordFaces
1418     addTokenWithReward(111, 6);
1419     addTokenWithReward(555, 6);
1420     addTokenWithReward(1111, 6);
1421     addTokenWithReward(1999, 6);
1422 
1423     //Silver WordFaces
1424     addTokenWithReward(7, 3);
1425     addTokenWithReward(70, 3);
1426     addTokenWithReward(700, 3);
1427     addTokenWithReward(1000, 3);
1428     addTokenWithReward(1500, 3);
1429     addTokenWithReward(2000, 3);
1430 
1431     //Bronze WordFaces
1432     addTokenWithReward(100, 2);
1433     addTokenWithReward(200, 2);
1434     addTokenWithReward(300, 2);
1435     addTokenWithReward(400, 2);
1436     addTokenWithReward(500, 2);
1437     addTokenWithReward(808, 2);
1438     addTokenWithReward(909, 2);
1439     addTokenWithReward(1001, 2);
1440     addTokenWithReward(2002, 2);
1441     addTokenWithReward(2200, 2);  
1442   }
1443 
1444   function addTokenWithReward(uint id_, uint reward_) public onlyOwner()
1445   {
1446     TokenWithReward memory tokenWithReward = TokenWithReward(id_, reward_, 0);
1447     tokensReward.push(tokenWithReward);
1448   }
1449 
1450   function setPause(bool _state) public onlyOwner 
1451   {
1452     paused = _state;
1453   }
1454 
1455   function mint(uint256 _mintAmount) public payable 
1456   {
1457     uint256 timestampNow = block.timestamp;
1458 
1459     uint256 supply = totalSupply();
1460     require(_mintAmount > 0, "Need amount is > 0");
1461     require(_mintAmount <= maxMintAmount, "Too much");
1462     require(supply + _mintAmount <= maxSupply, "You are trying to buy more than the limit");
1463 
1464     require(!paused, "Smart Contract is paused");
1465     require(timestampNow > presaleStartTimestamp, "Minting is not available");
1466   
1467     //presale  
1468     if(timestampNow <= mintingStartTimestamp) {
1469         require(isWhitelisted(msg.sender), "user is not whitelisted");
1470         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1471         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1472         require(msg.value >= costWhitelisted * _mintAmount, "Wrong mint price");
1473     }
1474     //main sale
1475     else if(timestampNow > mintingStartTimestamp){
1476         require(msg.value >= cost * _mintAmount, "Wrong mint price");
1477     }
1478 
1479     for (uint256 i = 1; i <= _mintAmount; i++) {
1480       addressMintedBalance[msg.sender]++;
1481       uint256 id = nextToken();
1482       _safeMint(msg.sender, id);
1483     }
1484     
1485     uint money = msg.value;
1486     uint reward = moneyProportionForReward * money / 100;
1487     
1488     moneyOwner += (money-reward);
1489     moneyReward += reward;
1490     
1491     for (uint i; i < rewardsTimestamp.length; i++)
1492     {
1493       if(i+1 < rewardsTimestamp.length && timestampNow > rewardsTimestamp[i] && timestampNow < rewardsTimestamp[i+1])
1494       {
1495         moneyReward_AddedPerMonth[i] += reward;
1496       }
1497     }
1498   }
1499 
1500   function mintToAddress(address _address, uint256 _mintAmount) public onlyOwner() 
1501   {
1502     uint256 supply = totalSupply();
1503     require(_mintAmount > 0);
1504     require(_mintAmount <= maxMintAmount);
1505     require(supply + _mintAmount <= maxSupply);
1506     
1507     for (uint256 i = 1; i <= _mintAmount; i++) {
1508       addressMintedBalance[_address]++;
1509       uint256 id = nextToken();
1510       _safeMint(_address, id);
1511     }
1512   }
1513 
1514   function setMintingStartTimestamp(uint _newMintingStartTimestamp) public onlyOwner 
1515   {
1516     mintingStartTimestamp = _newMintingStartTimestamp;
1517   }
1518   
1519   function setPresaleStartTimestamp(uint _newPresaleStartTimestamp) public onlyOwner 
1520   {
1521     presaleStartTimestamp = _newPresaleStartTimestamp;
1522   }
1523   
1524   function setBaseURI(string memory _newBaseURI) public onlyOwner 
1525   {
1526     baseURI = _newBaseURI;
1527   }
1528 
1529   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner 
1530   {
1531     notRevealedUri = _notRevealedURI;
1532   }
1533   
1534   function setReveal(bool _reveal) public onlyOwner() 
1535   {
1536       revealed = _reveal;
1537   }
1538 
1539   // Payout. The function should be called by the owners of the NFT
1540   // tokenID_ = 0 - Receive payments from all deposits
1541   // tokenID_ = ID - Receive payments from a specific NFT
1542   function TryPayToWinner_Token(uint256 tokenID_) public payable
1543   {    
1544         uint256 timestampNow = block.timestamp;
1545 
1546         require(timestampNow >= rewardsTimestamp[0], "Payments have not started yet!");
1547         
1548         if(moneyReward_Init == 0)
1549         {
1550             moneyReward_Init = moneyReward;
1551         }
1552         
1553         uint money = 0;
1554         
1555         uint256[] memory tokensUser = walletOfOwner(msg.sender);
1556 
1557         money_Calculate = 0;
1558 
1559         uint isHasRewards = 0;
1560 
1561         for (uint i; i < tokensReward.length; i++) 
1562         {
1563             for (uint ii; ii < tokensUser.length; ii++)
1564             {
1565                 if(tokensReward[i].id == tokensUser[ii] && (tokenID_ == 0 || tokensReward[i].id == tokenID_))
1566                 {
1567                     isHasRewards = 1;
1568                     for (uint iii; iii < rewardsTimestamp.length; iii++)
1569                     {
1570                         if(tokensReward[i].timestamp < rewardsTimestamp[iii] && timestampNow > rewardsTimestamp[iii])
1571                         {
1572                             if(iii > 0)
1573                             {
1574                                 money_Calculate = (moneyReward_Init/12) * tokensReward[i].reward / 100 + (moneyReward_AddedPerMonth[iii-1]/(rewardsTimestamp.length-iii)) * tokensReward[i].reward / 100;
1575                             }
1576                             else
1577                             {
1578                                 money_Calculate = (moneyReward_Init/12) * tokensReward[i].reward / 100;
1579                             }
1580                             
1581                             money += money_Calculate;
1582                         }
1583                     }
1584                     tokensReward[i].timestamp = timestampNow; 
1585                     break;
1586                 }
1587             }
1588         }
1589         moneyReward -= money;
1590         moneyReward_Payed += money;
1591         
1592         require(isHasRewards > 0, "You do not have NTF with payouts!");
1593         require(money > 0, "No payouts yet, come back later");
1594         
1595         payable(msg.sender).transfer(money);
1596   }
1597 
1598   function _baseURI() internal view virtual override returns (string memory) 
1599   {
1600     return baseURI;
1601   }
1602 
1603   function nextToken() internal ensureAvailability returns (uint256) 
1604   {
1605     uint256 timestampNow = block.timestamp;
1606 
1607       uint256 maxIndex = 1;
1608         
1609       if (totalSupply() < maxSupplyPresale)
1610       {
1611         maxIndex = maxSupplyPresale - totalSupply();
1612             
1613         uint256 random = uint256(keccak256(
1614         abi.encodePacked(
1615           msg.sender,
1616           block.coinbase,
1617           block.difficulty,
1618           block.gaslimit,
1619           timestampNow
1620           )
1621         )) % maxIndex;
1622 
1623         uint256 value = 0;
1624         if (tokenMatrix_Presale[random] == 0) {
1625           value = random;
1626         } else {
1627           value = tokenMatrix_Presale[random];
1628         }
1629 
1630         if (tokenMatrix_Presale[maxIndex - 1] == 0) {
1631           tokenMatrix_Presale[random] = maxIndex - 1;
1632         } else {
1633           tokenMatrix_Presale[random] = tokenMatrix_Presale[maxIndex - 1];
1634         }
1635 
1636         incrementToken();
1637 
1638         return value + startFrom;
1639       }
1640       else 
1641       {
1642         maxIndex = maxSupply - totalSupply();
1643             
1644         uint256 random = uint256(keccak256(
1645           abi.encodePacked(
1646             msg.sender,
1647             block.coinbase,
1648             block.difficulty,
1649             block.gaslimit,
1650             timestampNow
1651           )
1652         )) % maxIndex;
1653     
1654         uint256 value = 0;
1655         if (tokenMatrix[random] == 0) 
1656         {
1657           value = random;
1658         } else 
1659         {
1660           value = tokenMatrix[random];
1661         }
1662 
1663         if (tokenMatrix[maxIndex - 1] == 0) {
1664           tokenMatrix[random] = maxIndex - 1;
1665         } else 
1666         {
1667           tokenMatrix[random] = tokenMatrix[maxIndex - 1];
1668         }
1669         incrementToken();
1670         return value + (startFrom + maxSupplyPresale);
1671       }    
1672   }
1673 
1674   function isWhitelisted(address _user) public view returns (bool) 
1675   {
1676     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1677       if (whitelistedAddresses[i] == _user) {
1678           return true;
1679       }
1680     }
1681     return false;
1682   }
1683   
1684   //Request which NTF me own
1685   function walletOfOwner(address _owner)
1686     public
1687     view
1688     returns (uint256[] memory)
1689   {
1690     uint256 ownerTokenCount = balanceOf(_owner);
1691     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1692     for (uint256 i; i < ownerTokenCount; i++) {
1693       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1694     }
1695     return tokenIds;
1696   }
1697 
1698   function tokenURI(uint256 tokenId)
1699     public
1700     view
1701     virtual
1702     override
1703     returns (string memory)
1704   {
1705     require(
1706       _exists(tokenId),
1707       "ERC721Metadata: URI query for nonexistent token"
1708     );
1709     
1710     if(revealed == false) {
1711         return notRevealedUri;
1712     }
1713 
1714     string memory currentBaseURI = _baseURI();
1715     return bytes(currentBaseURI).length > 0
1716         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1717         : "";
1718   }
1719 
1720   function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() 
1721   {
1722     maxMintAmount = _newmaxMintAmount;
1723   }
1724 
1725   function setCost(uint256 _newCost) public onlyOwner() 
1726   {
1727     cost = _newCost;
1728   }
1729   
1730   function setCostWhitelisted(uint256 _newCostWhitelisted) public onlyOwner() 
1731   {
1732     costWhitelisted = _newCostWhitelisted;
1733   }
1734   
1735   function setNftPerAddressLimit(uint256 _limit) public onlyOwner() 
1736   {
1737     nftPerAddressLimit = _limit;
1738   }
1739 
1740   function setBaseExtension(string memory _newBaseExtension) public onlyOwner 
1741   {
1742     baseExtension = _newBaseExtension;
1743   }
1744 
1745   function setMoneyProportionForReward(uint _newMoneyProportionForReward) public onlyOwner 
1746   {
1747     moneyProportionForReward = _newMoneyProportionForReward;
1748   }
1749 
1750   function getNftPerAddressLimit() public view returns (uint256) 
1751   {
1752     return maxMintAmount;
1753   }
1754 
1755   function getPaused() public view returns (bool)
1756   {
1757     return paused;
1758   }
1759 
1760   function getCost() public view returns (uint256) 
1761   {
1762     return cost;
1763   }
1764 
1765   function getCostWhitelisted() public view returns (uint256) 
1766   {
1767     return costWhitelisted;
1768   }
1769 
1770   function getMaxMintAmount() public view returns (uint256) 
1771   {
1772     return maxMintAmount;
1773   }
1774 
1775     function getMoneyOwner() external view returns (uint256) 
1776   {
1777     return moneyOwner;
1778   }
1779 
1780   function getMoneyReward() external view returns (uint256) 
1781   {
1782     return moneyReward;
1783   }
1784 
1785   function getBalance() external view returns (uint256) 
1786   {
1787     return address(this).balance;
1788   }
1789    
1790   function getMintingStartTimestamp() external view returns (uint256)
1791   {
1792     return mintingStartTimestamp;
1793   }
1794 
1795   function getPresaleStartTimestamp() external view returns (uint256)
1796   {
1797     return presaleStartTimestamp;
1798   }
1799   
1800   function whitelistUsers(address[] calldata _users) public onlyOwner 
1801   {
1802     delete whitelistedAddresses;
1803     whitelistedAddresses = _users;
1804   }
1805 
1806   function withdraw() public payable onlyOwner {
1807     (bool success, ) = payable(msg.sender).call{value: moneyOwner}("");
1808     require(success);
1809   }
1810 
1811   //For application 
1812 
1813   function getRewardsTimestamp() public view returns (uint[] memory)
1814   {
1815     return rewardsTimestamp;
1816   }
1817   
1818   function getTokensReward() public view returns (TokenWithReward[] memory)
1819   {
1820     return tokensReward;
1821   }
1822   
1823   function getBlockTimestamp() public view returns (uint256)
1824   {
1825     uint256 timestampNow = block.timestamp;
1826     return timestampNow;
1827   }
1828   
1829   function getMoneyRewardInit() public view returns (uint256)
1830   {
1831     if(moneyReward_Init == 0)
1832     {
1833       return moneyReward;
1834     }
1835     return moneyReward_Init;
1836   }
1837   
1838   function getMoneyRewardAddedPerMonth() public view returns (uint[] memory)
1839   {
1840     return moneyReward_AddedPerMonth;
1841   }
1842     
1843   /// @dev Get the current token count
1844   /// @return the created token count
1845   function tokenCount() public view returns (uint256) {
1846     return _tokenCount.current();
1847   }
1848 
1849   /// @dev Check whether tokens are still available
1850   /// @return the available token count
1851   function availableTokenCount() public view returns (uint256) {
1852     return maxSupply - totalSupply();
1853   }
1854 
1855   /// @dev Increment the token count and fetch the latest count
1856   /// @return the next token id
1857   function incrementToken() internal virtual ensureAvailability returns (uint256) {
1858     uint256 token = _tokenCount.current();
1859     _tokenCount.increment();
1860     return token;
1861   }
1862 
1863   /// @dev Check whether another token is still available
1864   modifier ensureAvailability() {
1865     require(availableTokenCount() > 0, "No more tokens available");
1866     _;
1867   }
1868 }