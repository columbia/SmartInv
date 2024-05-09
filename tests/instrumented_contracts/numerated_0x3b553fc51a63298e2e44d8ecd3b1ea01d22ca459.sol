1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-16
3 */
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 // File: @openzeppelin/contracts/access/Ownable.sol
47 
48 pragma solidity ^0.8.0;
49 
50 /*
51  * @dev Provides information about the current execution context, including the
52  * sender of the transaction and its data. While these are generally available
53  * via msg.sender and msg.data, they should not be accessed in such a direct
54  * manner, since when dealing with meta-transactions the account sending and
55  * paying for execution may not be the actual sender (as far as an application
56  * is concerned).
57  *
58  * This contract is only required for intermediate, library-like contracts.
59  */
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address) {
62         return msg.sender;
63     }
64 
65     function _msgData() internal view virtual returns (bytes calldata) {
66         return msg.data;
67     }
68 }
69 
70 
71 pragma solidity ^0.8.0;
72 
73 
74 /**
75  * @dev Contract module which provides a basic access control mechanism, where
76  * there is an account (an owner) that can be granted exclusive access to
77  * specific functions.
78  *
79  * By default, the owner account will be the one that deploys the contract. This
80  * can later be changed with {transferOwnership}.
81  *
82  * This module is used through inheritance. It will make available the modifier
83  * `onlyOwner`, which can be applied to your functions to restrict their use to
84  * the owner.
85  */
86 abstract contract Ownable is Context {
87     address private _owner;
88 
89     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91     /**
92      * @dev Initializes the contract setting the deployer as the initial owner.
93      */
94     constructor() {
95         _setOwner(_msgSender());
96     }
97 
98     /**
99      * @dev Returns the address of the current owner.
100      */
101     function owner() public view virtual returns (address) {
102         return _owner;
103     }
104 
105     /**
106      * @dev Throws if called by any account other than the owner.
107      */
108     modifier onlyOwner() {
109         require(owner() == _msgSender(), "Ownable: caller is not the owner");
110         _;
111     }
112 
113     /**
114      * @dev Leaves the contract without owner. It will not be possible to call
115      * `onlyOwner` functions anymore. Can only be called by the current owner.
116      *
117      * NOTE: Renouncing ownership will leave the contract without an owner,
118      * thereby removing any functionality that is only available to the owner.
119      */
120     function renounceOwnership() public virtual onlyOwner {
121         _setOwner(address(0));
122     }
123 
124     /**
125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
126      * Can only be called by the current owner.
127      */
128     function transferOwnership(address newOwner) public virtual onlyOwner {
129         require(newOwner != address(0), "Ownable: new owner is the zero address");
130         _setOwner(newOwner);
131     }
132 
133     function _setOwner(address newOwner) private {
134         address oldOwner = _owner;
135         _owner = newOwner;
136         emit OwnershipTransferred(oldOwner, newOwner);
137     }
138 }
139 
140 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
141 
142 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
143 
144 pragma solidity ^0.8.0;
145 
146 
147 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
148 
149 pragma solidity ^0.8.0;
150 
151 /**
152  * @dev Interface of the ERC165 standard, as defined in the
153  * https://eips.ethereum.org/EIPS/eip-165[EIP].
154  *
155  * Implementers can declare support of contract interfaces, which can then be
156  * queried by others ({ERC165Checker}).
157  *
158  * For an implementation, see {ERC165}.
159  */
160 interface IERC165 {
161     /**
162      * @dev Returns true if this contract implements the interface defined by
163      * `interfaceId`. See the corresponding
164      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
165      * to learn more about how these ids are created.
166      *
167      * This function call must use less than 30 000 gas.
168      */
169     function supportsInterface(bytes4 interfaceId) external view returns (bool);
170 }
171 
172 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
173 
174 pragma solidity ^0.8.0;
175 
176 
177 /**
178  * @dev Implementation of the {IERC165} interface.
179  *
180  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
181  * for the additional interface id that will be supported. For example:
182  *
183  * ```solidity
184  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
185  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
186  * }
187  * ```
188  *
189  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
190  */
191 abstract contract ERC165 is IERC165 {
192     /**
193      * @dev See {IERC165-supportsInterface}.
194      */
195     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
196         return interfaceId == type(IERC165).interfaceId;
197     }
198 }
199 
200 // File: @openzeppelin/contracts/utils/Strings.sol
201 
202 pragma solidity ^0.8.0;
203 
204 /**
205  * @dev String operations.
206  */
207 library Strings {
208     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
209 
210     /**
211      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
212      */
213     function toString(uint256 value) internal pure returns (string memory) {
214         // Inspired by OraclizeAPI's implementation - MIT licence
215         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
216 
217         if (value == 0) {
218             return "0";
219         }
220         uint256 temp = value;
221         uint256 digits;
222         while (temp != 0) {
223             digits++;
224             temp /= 10;
225         }
226         bytes memory buffer = new bytes(digits);
227         while (value != 0) {
228             digits -= 1;
229             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
230             value /= 10;
231         }
232         return string(buffer);
233     }
234 
235     /**
236      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
237      */
238     function toHexString(uint256 value) internal pure returns (string memory) {
239         if (value == 0) {
240             return "0x00";
241         }
242         uint256 temp = value;
243         uint256 length = 0;
244         while (temp != 0) {
245             length++;
246             temp >>= 8;
247         }
248         return toHexString(value, length);
249     }
250 
251     /**
252      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
253      */
254     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
255         bytes memory buffer = new bytes(2 * length + 2);
256         buffer[0] = "0";
257         buffer[1] = "x";
258         for (uint256 i = 2 * length + 1; i > 1; --i) {
259             buffer[i] = _HEX_SYMBOLS[value & 0xf];
260             value >>= 4;
261         }
262         require(value == 0, "Strings: hex length insufficient");
263         return string(buffer);
264     }
265 }
266 
267 // File: @openzeppelin/contracts/utils/Context.sol
268 
269 // File: @openzeppelin/contracts/utils/Address.sol
270 
271 pragma solidity ^0.8.0;
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // This method relies on extcodesize, which returns 0 for contracts in
296         // construction, since the code is only stored at the end of the
297         // constructor execution.
298 
299         uint256 size;
300         assembly {
301             size := extcodesize(account)
302         }
303         return size > 0;
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         (bool success, ) = recipient.call{value: amount}("");
326         require(success, "Address: unable to send value, recipient may have reverted");
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain `call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
348         return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(
377         address target,
378         bytes memory data,
379         uint256 value
380     ) internal returns (bytes memory) {
381         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
386      * with `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(
391         address target,
392         bytes memory data,
393         uint256 value,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         require(address(this).balance >= value, "Address: insufficient balance for call");
397         require(isContract(target), "Address: call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.call{value: value}(data);
400         return _verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a static call.
406      *
407      * _Available since v3.3._
408      */
409     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
410         return functionStaticCall(target, data, "Address: low-level static call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a static call.
416      *
417      * _Available since v3.3._
418      */
419     function functionStaticCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal view returns (bytes memory) {
424         require(isContract(target), "Address: static call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.staticcall(data);
427         return _verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a delegate call.
433      *
434      * _Available since v3.4._
435      */
436     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
437         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
442      * but performing a delegate call.
443      *
444      * _Available since v3.4._
445      */
446     function functionDelegateCall(
447         address target,
448         bytes memory data,
449         string memory errorMessage
450     ) internal returns (bytes memory) {
451         require(isContract(target), "Address: delegate call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.delegatecall(data);
454         return _verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     function _verifyCallResult(
458         bool success,
459         bytes memory returndata,
460         string memory errorMessage
461     ) private pure returns (bytes memory) {
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468 
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 
481 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @title ERC721 token receiver interface
487  * @dev Interface for any contract that wants to support safeTransfers
488  * from ERC721 asset contracts.
489  */
490 interface IERC721Receiver {
491     /**
492      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
493      * by `operator` from `from`, this function is called.
494      *
495      * It must return its Solidity selector to confirm the token transfer.
496      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
497      *
498      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
499      */
500     function onERC721Received(
501         address operator,
502         address from,
503         uint256 tokenId,
504         bytes calldata data
505     ) external returns (bytes4);
506 }
507 
508 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @dev Required interface of an ERC721 compliant contract.
515  */
516 interface IERC721 is IERC165 {
517     /**
518      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
519      */
520     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
521 
522     /**
523      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
524      */
525     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
526 
527     /**
528      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
529      */
530     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
531 
532     /**
533      * @dev Returns the number of tokens in ``owner``'s account.
534      */
535     function balanceOf(address owner) external view returns (uint256 balance);
536 
537     /**
538      * @dev Returns the owner of the `tokenId` token.
539      *
540      * Requirements:
541      *
542      * - `tokenId` must exist.
543      */
544     function ownerOf(uint256 tokenId) external view returns (address owner);
545 
546     /**
547      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
548      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
549      *
550      * Requirements:
551      *
552      * - `from` cannot be the zero address.
553      * - `to` cannot be the zero address.
554      * - `tokenId` token must exist and be owned by `from`.
555      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
556      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
557      *
558      * Emits a {Transfer} event.
559      */
560     function safeTransferFrom(
561         address from,
562         address to,
563         uint256 tokenId
564     ) external;
565 
566     /**
567      * @dev Transfers `tokenId` token from `from` to `to`.
568      *
569      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
570      *
571      * Requirements:
572      *
573      * - `from` cannot be the zero address.
574      * - `to` cannot be the zero address.
575      * - `tokenId` token must be owned by `from`.
576      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
577      *
578      * Emits a {Transfer} event.
579      */
580     function transferFrom(
581         address from,
582         address to,
583         uint256 tokenId
584     ) external;
585 
586     /**
587      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
588      * The approval is cleared when the token is transferred.
589      *
590      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
591      *
592      * Requirements:
593      *
594      * - The caller must own the token or be an approved operator.
595      * - `tokenId` must exist.
596      *
597      * Emits an {Approval} event.
598      */
599     function approve(address to, uint256 tokenId) external;
600 
601     /**
602      * @dev Returns the account approved for `tokenId` token.
603      *
604      * Requirements:
605      *
606      * - `tokenId` must exist.
607      */
608     function getApproved(uint256 tokenId) external view returns (address operator);
609 
610     /**
611      * @dev Approve or remove `operator` as an operator for the caller.
612      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
613      *
614      * Requirements:
615      *
616      * - The `operator` cannot be the caller.
617      *
618      * Emits an {ApprovalForAll} event.
619      */
620     function setApprovalForAll(address operator, bool _approved) external;
621 
622     /**
623      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
624      *
625      * See {setApprovalForAll}
626      */
627     function isApprovedForAll(address owner, address operator) external view returns (bool);
628 
629     /**
630      * @dev Safely transfers `tokenId` token from `from` to `to`.
631      *
632      * Requirements:
633      *
634      * - `from` cannot be the zero address.
635      * - `to` cannot be the zero address.
636      * - `tokenId` token must exist and be owned by `from`.
637      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
638      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
639      *
640      * Emits a {Transfer} event.
641      */
642     function safeTransferFrom(
643         address from,
644         address to,
645         uint256 tokenId,
646         bytes calldata data
647     ) external;
648 }
649 
650 
651 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
652 
653 pragma solidity ^0.8.0;
654 
655 
656 /**
657  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
658  * @dev See https://eips.ethereum.org/EIPS/eip-721
659  */
660 interface IERC721Metadata is IERC721 {
661     /**
662      * @dev Returns the token collection name.
663      */
664     function name() external view returns (string memory);
665 
666     /**
667      * @dev Returns the token collection symbol.
668      */
669     function symbol() external view returns (string memory);
670 
671     /**
672      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
673      */
674     function tokenURI(uint256 tokenId) external view returns (string memory);
675 }
676 /**
677  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
678  * @dev See https://eips.ethereum.org/EIPS/eip-721
679  */
680 interface IERC721Enumerable is IERC721 {
681     /**
682      * @dev Returns the total amount of tokens stored by the contract.
683      */
684     function totalSupply() external view returns (uint256);
685 
686     /**
687      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
688      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
689      */
690     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
691 
692     /**
693      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
694      * Use along with {totalSupply} to enumerate all tokens.
695      */
696     function tokenByIndex(uint256 index) external view returns (uint256);
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
700 
701 pragma solidity ^0.8.0;
702 
703 
704 
705 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
706 
707 pragma solidity ^0.8.0;
708 
709 
710 
711 
712 
713 
714 
715 
716 /**
717  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
718  * the Metadata extension, but not including the Enumerable extension, which is available separately as
719  * {ERC721Enumerable}.
720  */
721 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
722     using Address for address;
723     using Strings for uint256;
724 
725     // Token name
726     string private _name;
727 
728     // Token symbol
729     string private _symbol;
730 
731     // Mapping from token ID to owner address
732     mapping(uint256 => address) private _owners;
733 
734     // Mapping owner address to token count
735     mapping(address => uint256) private _balances;
736 
737     // Mapping from token ID to approved address
738     mapping(uint256 => address) private _tokenApprovals;
739 
740     // Mapping from owner to operator approvals
741     mapping(address => mapping(address => bool)) private _operatorApprovals;
742 
743     /**
744      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
745      */
746     constructor(string memory name_, string memory symbol_) {
747         _name = name_;
748         _symbol = symbol_;
749     }
750 
751     /**
752      * @dev See {IERC165-supportsInterface}.
753      */
754     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
755         return
756             interfaceId == type(IERC721).interfaceId ||
757             interfaceId == type(IERC721Metadata).interfaceId ||
758             super.supportsInterface(interfaceId);
759     }
760 
761     /**
762      * @dev See {IERC721-balanceOf}.
763      */
764     function balanceOf(address owner) public view virtual override returns (uint256) {
765         require(owner != address(0), "ERC721: balance query for the zero address");
766         return _balances[owner];
767     }
768 
769     /**
770      * @dev See {IERC721-ownerOf}.
771      */
772     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
773         address owner = _owners[tokenId];
774         require(owner != address(0), "ERC721: owner query for nonexistent token");
775         return owner;
776     }
777 
778     /**
779      * @dev See {IERC721Metadata-name}.
780      */
781     function name() public view virtual override returns (string memory) {
782         return _name;
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-symbol}.
787      */
788     function symbol() public view virtual override returns (string memory) {
789         return _symbol;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-tokenURI}.
794      */
795     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
796         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
797 
798         string memory baseURI = _baseURI();
799         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
800     }
801 
802     /**
803      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
804      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
805      * by default, can be overriden in child contracts.
806      */
807     function _baseURI() internal view virtual returns (string memory) {
808         return "";
809     }
810 
811     /**
812      * @dev See {IERC721-approve}.
813      */
814     function approve(address to, uint256 tokenId) public virtual override {
815         address owner = ERC721.ownerOf(tokenId);
816         require(to != owner, "ERC721: approval to current owner");
817 
818         require(
819             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
820             "ERC721: approve caller is not owner nor approved for all"
821         );
822 
823         _approve(to, tokenId);
824     }
825 
826     /**
827      * @dev See {IERC721-getApproved}.
828      */
829     function getApproved(uint256 tokenId) public view virtual override returns (address) {
830         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
831 
832         return _tokenApprovals[tokenId];
833     }
834 
835     /**
836      * @dev See {IERC721-setApprovalForAll}.
837      */
838     function setApprovalForAll(address operator, bool approved) public virtual override {
839         require(operator != _msgSender(), "ERC721: approve to caller");
840 
841         _operatorApprovals[_msgSender()][operator] = approved;
842         emit ApprovalForAll(_msgSender(), operator, approved);
843     }
844 
845     /**
846      * @dev See {IERC721-isApprovedForAll}.
847      */
848     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
849         return _operatorApprovals[owner][operator];
850     }
851 
852     /**
853      * @dev See {IERC721-transferFrom}.
854      */
855     function transferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) public virtual override {
860         //solhint-disable-next-line max-line-length
861         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
862 
863         _transfer(from, to, tokenId);
864     }
865 
866     /**
867      * @dev See {IERC721-safeTransferFrom}.
868      */
869     function safeTransferFrom(
870         address from,
871         address to,
872         uint256 tokenId
873     ) public virtual override {
874         safeTransferFrom(from, to, tokenId, "");
875     }
876 
877     /**
878      * @dev See {IERC721-safeTransferFrom}.
879      */
880     function safeTransferFrom(
881         address from,
882         address to,
883         uint256 tokenId,
884         bytes memory _data
885     ) public virtual override {
886         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
887         _safeTransfer(from, to, tokenId, _data);
888     }
889 
890     /**
891      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
892      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
893      *
894      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
895      *
896      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
897      * implement alternative mechanisms to perform token transfer, such as signature-based.
898      *
899      * Requirements:
900      *
901      * - `from` cannot be the zero address.
902      * - `to` cannot be the zero address.
903      * - `tokenId` token must exist and be owned by `from`.
904      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _safeTransfer(
909         address from,
910         address to,
911         uint256 tokenId,
912         bytes memory _data
913     ) internal virtual {
914         _transfer(from, to, tokenId);
915         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
916     }
917 
918     /**
919      * @dev Returns whether `tokenId` exists.
920      *
921      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
922      *
923      * Tokens start existing when they are minted (`_mint`),
924      * and stop existing when they are burned (`_burn`).
925      */
926     function _exists(uint256 tokenId) internal view virtual returns (bool) {
927         return _owners[tokenId] != address(0);
928     }
929 
930     /**
931      * @dev Returns whether `spender` is allowed to manage `tokenId`.
932      *
933      * Requirements:
934      *
935      * - `tokenId` must exist.
936      */
937     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
938         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
939         address owner = ERC721.ownerOf(tokenId);
940         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
941     }
942 
943     /**
944      * @dev Safely mints `tokenId` and transfers it to `to`.
945      *
946      * Requirements:
947      *
948      * - `tokenId` must not exist.
949      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _safeMint(address to, uint256 tokenId) internal virtual {
954         _safeMint(to, tokenId, "");
955     }
956 
957     /**
958      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
959      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
960      */
961     function _safeMint(
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) internal virtual {
966         _mint(to, tokenId);
967         require(
968             _checkOnERC721Received(address(0), to, tokenId, _data),
969             "ERC721: transfer to non ERC721Receiver implementer"
970         );
971     }
972 
973     /**
974      * @dev Mints `tokenId` and transfers it to `to`.
975      *
976      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
977      *
978      * Requirements:
979      *
980      * - `tokenId` must not exist.
981      * - `to` cannot be the zero address.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _mint(address to, uint256 tokenId) internal virtual {
986         require(to != address(0), "ERC721: mint to the zero address");
987         require(!_exists(tokenId), "ERC721: token already minted");
988 
989         _beforeTokenTransfer(address(0), to, tokenId);
990 
991         _balances[to] += 1;
992         _owners[tokenId] = to;
993 
994         emit Transfer(address(0), to, tokenId);
995     }
996 
997     /**
998      * @dev Destroys `tokenId`.
999      * The approval is cleared when the token is burned.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must exist.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _burn(uint256 tokenId) internal virtual {
1008         address owner = ERC721.ownerOf(tokenId);
1009 
1010         _beforeTokenTransfer(owner, address(0), tokenId);
1011 
1012         // Clear approvals
1013         _approve(address(0), tokenId);
1014 
1015         _balances[owner] -= 1;
1016         delete _owners[tokenId];
1017 
1018         emit Transfer(owner, address(0), tokenId);
1019     }
1020 
1021     /**
1022      * @dev Transfers `tokenId` from `from` to `to`.
1023      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1024      *
1025      * Requirements:
1026      *
1027      * - `to` cannot be the zero address.
1028      * - `tokenId` token must be owned by `from`.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _transfer(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) internal virtual {
1037         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1038         require(to != address(0), "ERC721: transfer to the zero address");
1039 
1040         _beforeTokenTransfer(from, to, tokenId);
1041 
1042         // Clear approvals from the previous owner
1043         _approve(address(0), tokenId);
1044 
1045         _balances[from] -= 1;
1046         _balances[to] += 1;
1047         _owners[tokenId] = to;
1048 
1049         emit Transfer(from, to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev Approve `to` to operate on `tokenId`
1054      *
1055      * Emits a {Approval} event.
1056      */
1057     function _approve(address to, uint256 tokenId) internal virtual {
1058         _tokenApprovals[tokenId] = to;
1059         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1064      * The call is not executed if the target address is not a contract.
1065      *
1066      * @param from address representing the previous owner of the given token ID
1067      * @param to target address that will receive the tokens
1068      * @param tokenId uint256 ID of the token to be transferred
1069      * @param _data bytes optional data to send along with the call
1070      * @return bool whether the call correctly returned the expected magic value
1071      */
1072     function _checkOnERC721Received(
1073         address from,
1074         address to,
1075         uint256 tokenId,
1076         bytes memory _data
1077     ) private returns (bool) {
1078         if (to.isContract()) {
1079             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1080                 return retval == IERC721Receiver(to).onERC721Received.selector;
1081             } catch (bytes memory reason) {
1082                 if (reason.length == 0) {
1083                     revert("ERC721: transfer to non ERC721Receiver implementer");
1084                 } else {
1085                     assembly {
1086                         revert(add(32, reason), mload(reason))
1087                     }
1088                 }
1089             }
1090         } else {
1091             return true;
1092         }
1093     }
1094 
1095     /**
1096      * @dev Hook that is called before any token transfer. This includes minting
1097      * and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1102      * transferred to `to`.
1103      * - When `from` is zero, `tokenId` will be minted for `to`.
1104      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1105      * - `from` and `to` are never both zero.
1106      *
1107      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108      */
1109     function _beforeTokenTransfer(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) internal virtual {}
1114 }
1115 
1116 
1117 /**
1118  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1119  * enumerability of all the token ids in the contract as well as all token ids owned by each
1120  * account.
1121  */
1122 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1123     // Mapping from owner to list of owned token IDs
1124     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1125 
1126     // Mapping from token ID to index of the owner tokens list
1127     mapping(uint256 => uint256) private _ownedTokensIndex;
1128 
1129     // Array with all token ids, used for enumeration
1130     uint256[] private _allTokens;
1131 
1132     // Mapping from token id to position in the allTokens array
1133     mapping(uint256 => uint256) private _allTokensIndex;
1134 
1135     /**
1136      * @dev See {IERC165-supportsInterface}.
1137      */
1138     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1139         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1140     }
1141 
1142     /**
1143      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1144      */
1145     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1146         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1147         return _ownedTokens[owner][index];
1148     }
1149 
1150     /**
1151      * @dev See {IERC721Enumerable-totalSupply}.
1152      */
1153     function totalSupply() public view virtual override returns (uint256) {
1154         return _allTokens.length;
1155     }
1156 
1157     /**
1158      * @dev See {IERC721Enumerable-tokenByIndex}.
1159      */
1160     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1161         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1162         return _allTokens[index];
1163     }
1164 
1165     /**
1166      * @dev Hook that is called before any token transfer. This includes minting
1167      * and burning.
1168      *
1169      * Calling conditions:
1170      *
1171      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1172      * transferred to `to`.
1173      * - When `from` is zero, `tokenId` will be minted for `to`.
1174      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1175      * - `from` cannot be the zero address.
1176      * - `to` cannot be the zero address.
1177      *
1178      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1179      */
1180     function _beforeTokenTransfer(
1181         address from,
1182         address to,
1183         uint256 tokenId
1184     ) internal virtual override {
1185         super._beforeTokenTransfer(from, to, tokenId);
1186 
1187         if (from == address(0)) {
1188             _addTokenToAllTokensEnumeration(tokenId);
1189         } else if (from != to) {
1190             _removeTokenFromOwnerEnumeration(from, tokenId);
1191         }
1192         if (to == address(0)) {
1193             _removeTokenFromAllTokensEnumeration(tokenId);
1194         } else if (to != from) {
1195             _addTokenToOwnerEnumeration(to, tokenId);
1196         }
1197     }
1198 
1199     /**
1200      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1201      * @param to address representing the new owner of the given token ID
1202      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1203      */
1204     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1205         uint256 length = ERC721.balanceOf(to);
1206         _ownedTokens[to][length] = tokenId;
1207         _ownedTokensIndex[tokenId] = length;
1208     }
1209 
1210     /**
1211      * @dev Private function to add a token to this extension's token tracking data structures.
1212      * @param tokenId uint256 ID of the token to be added to the tokens list
1213      */
1214     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1215         _allTokensIndex[tokenId] = _allTokens.length;
1216         _allTokens.push(tokenId);
1217     }
1218 
1219     /**
1220      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1221      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1222      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1223      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1224      * @param from address representing the previous owner of the given token ID
1225      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1226      */
1227     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1228         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1229         // then delete the last slot (swap and pop).
1230 
1231         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1232         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1233 
1234         // When the token to delete is the last token, the swap operation is unnecessary
1235         if (tokenIndex != lastTokenIndex) {
1236             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1237 
1238             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1239             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1240         }
1241 
1242         // This also deletes the contents at the last position of the array
1243         delete _ownedTokensIndex[tokenId];
1244         delete _ownedTokens[from][lastTokenIndex];
1245     }
1246 
1247     /**
1248      * @dev Private function to remove a token from this extension's token tracking data structures.
1249      * This has O(1) time complexity, but alters the order of the _allTokens array.
1250      * @param tokenId uint256 ID of the token to be removed from the tokens list
1251      */
1252     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1253         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1254         // then delete the last slot (swap and pop).
1255 
1256         uint256 lastTokenIndex = _allTokens.length - 1;
1257         uint256 tokenIndex = _allTokensIndex[tokenId];
1258 
1259         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1260         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1261         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1262         uint256 lastTokenId = _allTokens[lastTokenIndex];
1263 
1264         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1265         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1266 
1267         // This also deletes the contents at the last position of the array
1268         delete _allTokensIndex[tokenId];
1269         _allTokens.pop();
1270     }
1271 }
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 
1276 /**
1277  * @dev ERC721 token with storage based token URI management.
1278  */
1279 abstract contract ERC721URIStorage is ERC721 {
1280     using Strings for uint256;
1281 
1282     // Optional mapping for token URIs
1283     mapping(uint256 => string) private _tokenURIs;
1284 
1285     /**
1286      * @dev See {IERC721Metadata-tokenURI}.
1287      */
1288     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1289         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1290 
1291         string memory _tokenURI = _tokenURIs[tokenId];
1292         string memory base = _baseURI();
1293 
1294         // If there is no base URI, return the token URI.
1295         if (bytes(base).length == 0) {
1296             return _tokenURI;
1297         }
1298         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1299         if (bytes(_tokenURI).length > 0) {
1300             return string(abi.encodePacked(base, _tokenURI));
1301         }
1302 
1303         return super.tokenURI(tokenId);
1304     }
1305 
1306     /**
1307      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1308      *
1309      * Requirements:
1310      *
1311      * - `tokenId` must exist.
1312      */
1313     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1314         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1315         _tokenURIs[tokenId] = _tokenURI;
1316     }
1317 
1318     /**
1319      * @dev Destroys `tokenId`.
1320      * The approval is cleared when the token is burned.
1321      *
1322      * Requirements:
1323      *
1324      * - `tokenId` must exist.
1325      *
1326      * Emits a {Transfer} event.
1327      */
1328     function _burn(uint256 tokenId) internal virtual override {
1329         super._burn(tokenId);
1330 
1331         if (bytes(_tokenURIs[tokenId]).length != 0) {
1332             delete _tokenURIs[tokenId];
1333         }
1334     }
1335 }
1336 
1337 //SPDX-License-Identifier: GPL-3.0-or-later
1338 pragma solidity 0.8.3;
1339 
1340 contract SodaPassNFT is ERC721, ERC721Enumerable,ERC721URIStorage, Ownable {
1341    using Counters for Counters.Counter;
1342     Counters.Counter private _tokenIds;
1343     
1344     uint16 public constant maxSupply = 5100;
1345     string private _baseTokenURI;
1346     
1347     uint256 public _startDate = 1634850000000;
1348     uint256 public _whitelistStartDate = 1634677200000;
1349     
1350     mapping (address => bool) private _whitelisted;
1351 
1352     constructor() ERC721("Soda Pass", "SODA") {
1353          for (uint8 i = 0; i < 100; i++) {
1354             _tokenIds.increment();
1355 
1356             uint256 newItemId = _tokenIds.current();
1357             _mint(msg.sender, newItemId);
1358         }
1359     }
1360     
1361     function setStartDate(uint256 startDate) public onlyOwner {
1362         _startDate = startDate;
1363     }
1364     
1365     function setWhitelistStartDate(uint256 whitelistStartDate) public onlyOwner {
1366         _whitelistStartDate = whitelistStartDate;
1367     }
1368 
1369     function _beforeTokenTransfer(
1370         address from,
1371         address to,
1372         uint256 tokenId
1373     ) internal override(ERC721, ERC721Enumerable) {
1374         super._beforeTokenTransfer(from, to, tokenId);
1375     }
1376     
1377     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1378         super._burn(tokenId);
1379     }
1380 
1381     function supportsInterface(bytes4 interfaceId)
1382         public
1383         view
1384         override(ERC721, ERC721Enumerable)
1385         returns (bool)
1386     {
1387         return super.supportsInterface(interfaceId);
1388     }
1389 
1390 
1391     function setBaseURI(string memory _newbaseTokenURI) public onlyOwner {
1392         _baseTokenURI = _newbaseTokenURI;
1393     }
1394 
1395     function _baseURI() internal view override returns (string memory) {
1396         return _baseTokenURI;
1397     }
1398 
1399     // Get minting limit (for a single transaction) based on current token supply
1400     function getCurrentMintLimit() public view returns (uint8) {
1401         return block.timestamp >= _startDate ? 20 : 4;
1402     }
1403 
1404     // Get ether price based on current token supply
1405     function getCurrentPrice() public pure returns (uint64) {
1406         return 100_000_000_000_000_000;
1407     }
1408     
1409     function addUserToWhitelist(address wallet) public onlyOwner {
1410         _whitelisted[wallet] = true;
1411     }
1412     
1413     function removeUserFromWhitelist(address wallet) public onlyOwner {
1414         _whitelisted[wallet] = false;
1415     }
1416     
1417     // Mint new token(s)
1418     function mint(uint8 _quantityToMint) public payable {
1419         require(_startDate <= block.timestamp || (block.timestamp >= _whitelistStartDate && _whitelisted[msg.sender] == true), block.timestamp <= _whitelistStartDate ? "Sale is not open" : "Not whitelisted");
1420         require(_quantityToMint >= 1, "Must mint at least 1");
1421         require(block.timestamp >= _whitelistStartDate && block.timestamp <= _startDate ? (_quantityToMint + balanceOf(msg.sender) <= 4) : true, "Whitelisted mints are limited to 4 per wallet");
1422         require(
1423             _quantityToMint <= getCurrentMintLimit(),
1424             "Maximum current buy limit for individual transaction exceeded"
1425         );
1426         require(
1427             (_quantityToMint + totalSupply()) <= maxSupply,
1428             "Exceeds maximum supply"
1429         );
1430         require(
1431             msg.value == (getCurrentPrice() * _quantityToMint),
1432             "Ether submitted does not match current price"
1433         );
1434 
1435         for (uint8 i = 0; i < _quantityToMint; i++) {
1436             _tokenIds.increment();
1437 
1438             uint256 newItemId = _tokenIds.current();
1439             _mint(msg.sender, newItemId);
1440         }
1441     }
1442     
1443     function tokenURI(uint256 tokenId)
1444         public
1445         view
1446         override(ERC721, ERC721URIStorage)
1447         returns (string memory)
1448     {
1449         return super.tokenURI(tokenId);
1450     }
1451 
1452     // Withdraw ether from contract
1453     function withdraw() public onlyOwner {
1454         require(address(this).balance > 0, "Balance must be positive");
1455         
1456         uint256 _balance = address(this).balance;
1457         address _coldWallet = 0x9781F65af8324b40Ee9Ca421ea963642Bc8a8C2b;
1458         payable(_coldWallet).transfer((_balance * 9)/10);
1459         
1460         address _devWallet = 0x3097617CbA85A26AdC214A1F87B680bE4b275cD0;
1461         payable(_devWallet).transfer((_balance * 1)/10);
1462     }
1463 }