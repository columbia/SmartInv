1 pragma solidity ^0.8.0;
2 
3 /**
4  * @title Counters
5  * @author Matt Condon (@shrugs)
6  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
7  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
8  *
9  * Include with `using Counters for Counters.Counter;`
10  */
11 library Counters {
12     struct Counter {
13         // This variable should never be directly accessed by users of the library: interactions must be restricted to
14         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
15         // this feature: see https://github.com/ethereum/solidity/issues/4637
16         uint256 _value; // default: 0
17     }
18 
19     function current(Counter storage counter) internal view returns (uint256) {
20         return counter._value;
21     }
22 
23     function increment(Counter storage counter) internal {
24         unchecked {
25             counter._value += 1;
26         }
27     }
28 
29     function decrement(Counter storage counter) internal {
30         uint256 value = counter._value;
31         require(value > 0, "Counter: decrement overflow");
32         unchecked {
33             counter._value = value - 1;
34         }
35     }
36 
37     function reset(Counter storage counter) internal {
38         counter._value = 0;
39     }
40 }
41 
42 // File: @openzeppelin/contracts/access/Ownable.sol
43 
44 pragma solidity ^0.8.0;
45 
46 /*
47  * @dev Provides information about the current execution context, including the
48  * sender of the transaction and its data. While these are generally available
49  * via msg.sender and msg.data, they should not be accessed in such a direct
50  * manner, since when dealing with meta-transactions the account sending and
51  * paying for execution may not be the actual sender (as far as an application
52  * is concerned).
53  *
54  * This contract is only required for intermediate, library-like contracts.
55  */
56 abstract contract Context {
57     function _msgSender() internal view virtual returns (address) {
58         return msg.sender;
59     }
60 
61     function _msgData() internal view virtual returns (bytes calldata) {
62         return msg.data;
63     }
64 }
65 
66 
67 pragma solidity ^0.8.0;
68 
69 
70 /**
71  * @dev Contract module which provides a basic access control mechanism, where
72  * there is an account (an owner) that can be granted exclusive access to
73  * specific functions.
74  *
75  * By default, the owner account will be the one that deploys the contract. This
76  * can later be changed with {transferOwnership}.
77  *
78  * This module is used through inheritance. It will make available the modifier
79  * `onlyOwner`, which can be applied to your functions to restrict their use to
80  * the owner.
81  */
82 abstract contract Ownable is Context {
83     address private _owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     /**
88      * @dev Initializes the contract setting the deployer as the initial owner.
89      */
90     constructor() {
91         _setOwner(_msgSender());
92     }
93 
94     /**
95      * @dev Returns the address of the current owner.
96      */
97     function owner() public view virtual returns (address) {
98         return _owner;
99     }
100 
101     /**
102      * @dev Throws if called by any account other than the owner.
103      */
104     modifier onlyOwner() {
105         require(owner() == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     /**
110      * @dev Leaves the contract without owner. It will not be possible to call
111      * `onlyOwner` functions anymore. Can only be called by the current owner.
112      *
113      * NOTE: Renouncing ownership will leave the contract without an owner,
114      * thereby removing any functionality that is only available to the owner.
115      */
116     function renounceOwnership() public virtual onlyOwner {
117         _setOwner(address(0));
118     }
119 
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Can only be called by the current owner.
123      */
124     function transferOwnership(address newOwner) public virtual onlyOwner {
125         require(newOwner != address(0), "Ownable: new owner is the zero address");
126         _setOwner(newOwner);
127     }
128 
129     function _setOwner(address newOwner) private {
130         address oldOwner = _owner;
131         _owner = newOwner;
132         emit OwnershipTransferred(oldOwner, newOwner);
133     }
134 }
135 
136 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
137 
138 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
139 
140 pragma solidity ^0.8.0;
141 
142 
143 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
144 
145 pragma solidity ^0.8.0;
146 
147 /**
148  * @dev Interface of the ERC165 standard, as defined in the
149  * https://eips.ethereum.org/EIPS/eip-165[EIP].
150  *
151  * Implementers can declare support of contract interfaces, which can then be
152  * queried by others ({ERC165Checker}).
153  *
154  * For an implementation, see {ERC165}.
155  */
156 interface IERC165 {
157     /**
158      * @dev Returns true if this contract implements the interface defined by
159      * `interfaceId`. See the corresponding
160      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
161      * to learn more about how these ids are created.
162      *
163      * This function call must use less than 30 000 gas.
164      */
165     function supportsInterface(bytes4 interfaceId) external view returns (bool);
166 }
167 
168 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
169 
170 pragma solidity ^0.8.0;
171 
172 
173 /**
174  * @dev Implementation of the {IERC165} interface.
175  *
176  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
177  * for the additional interface id that will be supported. For example:
178  *
179  * ```solidity
180  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
181  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
182  * }
183  * ```
184  *
185  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
186  */
187 abstract contract ERC165 is IERC165 {
188     /**
189      * @dev See {IERC165-supportsInterface}.
190      */
191     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
192         return interfaceId == type(IERC165).interfaceId;
193     }
194 }
195 
196 // File: @openzeppelin/contracts/utils/Strings.sol
197 
198 pragma solidity ^0.8.0;
199 
200 /**
201  * @dev String operations.
202  */
203 library Strings {
204     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
205 
206     /**
207      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
208      */
209     function toString(uint256 value) internal pure returns (string memory) {
210         // Inspired by OraclizeAPI's implementation - MIT licence
211         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
212 
213         if (value == 0) {
214             return "0";
215         }
216         uint256 temp = value;
217         uint256 digits;
218         while (temp != 0) {
219             digits++;
220             temp /= 10;
221         }
222         bytes memory buffer = new bytes(digits);
223         while (value != 0) {
224             digits -= 1;
225             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
226             value /= 10;
227         }
228         return string(buffer);
229     }
230 
231     /**
232      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
233      */
234     function toHexString(uint256 value) internal pure returns (string memory) {
235         if (value == 0) {
236             return "0x00";
237         }
238         uint256 temp = value;
239         uint256 length = 0;
240         while (temp != 0) {
241             length++;
242             temp >>= 8;
243         }
244         return toHexString(value, length);
245     }
246 
247     /**
248      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
249      */
250     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
251         bytes memory buffer = new bytes(2 * length + 2);
252         buffer[0] = "0";
253         buffer[1] = "x";
254         for (uint256 i = 2 * length + 1; i > 1; --i) {
255             buffer[i] = _HEX_SYMBOLS[value & 0xf];
256             value >>= 4;
257         }
258         require(value == 0, "Strings: hex length insufficient");
259         return string(buffer);
260     }
261 }
262 
263 // File: @openzeppelin/contracts/utils/Context.sol
264 
265 // File: @openzeppelin/contracts/utils/Address.sol
266 
267 pragma solidity ^0.8.0;
268 
269 /**
270  * @dev Collection of functions related to the address type
271  */
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // This method relies on extcodesize, which returns 0 for contracts in
292         // construction, since the code is only stored at the end of the
293         // constructor execution.
294 
295         uint256 size;
296         assembly {
297             size := extcodesize(account)
298         }
299         return size > 0;
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         (bool success, ) = recipient.call{value: amount}("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain `call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, 0, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but also transferring `value` wei to `target`.
364      *
365      * Requirements:
366      *
367      * - the calling contract must have an ETH balance of at least `value`.
368      * - the called Solidity function must be `payable`.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(
373         address target,
374         bytes memory data,
375         uint256 value
376     ) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(
387         address target,
388         bytes memory data,
389         uint256 value,
390         string memory errorMessage
391     ) internal returns (bytes memory) {
392         require(address(this).balance >= value, "Address: insufficient balance for call");
393         require(isContract(target), "Address: call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.call{value: value}(data);
396         return _verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but performing a static call.
402      *
403      * _Available since v3.3._
404      */
405     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
406         return functionStaticCall(target, data, "Address: low-level static call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
411      * but performing a static call.
412      *
413      * _Available since v3.3._
414      */
415     function functionStaticCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal view returns (bytes memory) {
420         require(isContract(target), "Address: static call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.staticcall(data);
423         return _verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a delegate call.
429      *
430      * _Available since v3.4._
431      */
432     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
433         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a delegate call.
439      *
440      * _Available since v3.4._
441      */
442     function functionDelegateCall(
443         address target,
444         bytes memory data,
445         string memory errorMessage
446     ) internal returns (bytes memory) {
447         require(isContract(target), "Address: delegate call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.delegatecall(data);
450         return _verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     function _verifyCallResult(
454         bool success,
455         bytes memory returndata,
456         string memory errorMessage
457     ) private pure returns (bytes memory) {
458         if (success) {
459             return returndata;
460         } else {
461             // Look for revert reason and bubble it up if present
462             if (returndata.length > 0) {
463                 // The easiest way to bubble the revert reason is using memory via assembly
464 
465                 assembly {
466                     let returndata_size := mload(returndata)
467                     revert(add(32, returndata), returndata_size)
468                 }
469             } else {
470                 revert(errorMessage);
471             }
472         }
473     }
474 }
475 
476 
477 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
478 
479 pragma solidity ^0.8.0;
480 
481 /**
482  * @title ERC721 token receiver interface
483  * @dev Interface for any contract that wants to support safeTransfers
484  * from ERC721 asset contracts.
485  */
486 interface IERC721Receiver {
487     /**
488      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
489      * by `operator` from `from`, this function is called.
490      *
491      * It must return its Solidity selector to confirm the token transfer.
492      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
493      *
494      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
495      */
496     function onERC721Received(
497         address operator,
498         address from,
499         uint256 tokenId,
500         bytes calldata data
501     ) external returns (bytes4);
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @dev Required interface of an ERC721 compliant contract.
511  */
512 interface IERC721 is IERC165 {
513     /**
514      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
515      */
516     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
517 
518     /**
519      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
520      */
521     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
522 
523     /**
524      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
525      */
526     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
527 
528     /**
529      * @dev Returns the number of tokens in ``owner``'s account.
530      */
531     function balanceOf(address owner) external view returns (uint256 balance);
532 
533     /**
534      * @dev Returns the owner of the `tokenId` token.
535      *
536      * Requirements:
537      *
538      * - `tokenId` must exist.
539      */
540     function ownerOf(uint256 tokenId) external view returns (address owner);
541 
542     /**
543      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
544      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
545      *
546      * Requirements:
547      *
548      * - `from` cannot be the zero address.
549      * - `to` cannot be the zero address.
550      * - `tokenId` token must exist and be owned by `from`.
551      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
552      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
553      *
554      * Emits a {Transfer} event.
555      */
556     function safeTransferFrom(
557         address from,
558         address to,
559         uint256 tokenId
560     ) external;
561 
562     /**
563      * @dev Transfers `tokenId` token from `from` to `to`.
564      *
565      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must be owned by `from`.
572      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
573      *
574      * Emits a {Transfer} event.
575      */
576     function transferFrom(
577         address from,
578         address to,
579         uint256 tokenId
580     ) external;
581 
582     /**
583      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
584      * The approval is cleared when the token is transferred.
585      *
586      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
587      *
588      * Requirements:
589      *
590      * - The caller must own the token or be an approved operator.
591      * - `tokenId` must exist.
592      *
593      * Emits an {Approval} event.
594      */
595     function approve(address to, uint256 tokenId) external;
596 
597     /**
598      * @dev Returns the account approved for `tokenId` token.
599      *
600      * Requirements:
601      *
602      * - `tokenId` must exist.
603      */
604     function getApproved(uint256 tokenId) external view returns (address operator);
605 
606     /**
607      * @dev Approve or remove `operator` as an operator for the caller.
608      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
609      *
610      * Requirements:
611      *
612      * - The `operator` cannot be the caller.
613      *
614      * Emits an {ApprovalForAll} event.
615      */
616     function setApprovalForAll(address operator, bool _approved) external;
617 
618     /**
619      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
620      *
621      * See {setApprovalForAll}
622      */
623     function isApprovedForAll(address owner, address operator) external view returns (bool);
624 
625     /**
626      * @dev Safely transfers `tokenId` token from `from` to `to`.
627      *
628      * Requirements:
629      *
630      * - `from` cannot be the zero address.
631      * - `to` cannot be the zero address.
632      * - `tokenId` token must exist and be owned by `from`.
633      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
634      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
635      *
636      * Emits a {Transfer} event.
637      */
638     function safeTransferFrom(
639         address from,
640         address to,
641         uint256 tokenId,
642         bytes calldata data
643     ) external;
644 }
645 
646 
647 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
648 
649 pragma solidity ^0.8.0;
650 
651 
652 /**
653  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
654  * @dev See https://eips.ethereum.org/EIPS/eip-721
655  */
656 interface IERC721Metadata is IERC721 {
657     /**
658      * @dev Returns the token collection name.
659      */
660     function name() external view returns (string memory);
661 
662     /**
663      * @dev Returns the token collection symbol.
664      */
665     function symbol() external view returns (string memory);
666 
667     /**
668      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
669      */
670     function tokenURI(uint256 tokenId) external view returns (string memory);
671 }
672 /**
673  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
674  * @dev See https://eips.ethereum.org/EIPS/eip-721
675  */
676 interface IERC721Enumerable is IERC721 {
677     /**
678      * @dev Returns the total amount of tokens stored by the contract.
679      */
680     function totalSupply() external view returns (uint256);
681 
682     /**
683      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
684      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
685      */
686     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
687 
688     /**
689      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
690      * Use along with {totalSupply} to enumerate all tokens.
691      */
692     function tokenByIndex(uint256 index) external view returns (uint256);
693 }
694 
695 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
696 
697 pragma solidity ^0.8.0;
698 
699 
700 
701 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
702 
703 pragma solidity ^0.8.0;
704 
705 
706 
707 
708 
709 
710 
711 
712 /**
713  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
714  * the Metadata extension, but not including the Enumerable extension, which is available separately as
715  * {ERC721Enumerable}.
716  */
717 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
718     using Address for address;
719     using Strings for uint256;
720 
721     // Token name
722     string private _name;
723 
724     // Token symbol
725     string private _symbol;
726 
727     // Mapping from token ID to owner address
728     mapping(uint256 => address) private _owners;
729 
730     // Mapping owner address to token count
731     mapping(address => uint256) private _balances;
732 
733     // Mapping from token ID to approved address
734     mapping(uint256 => address) private _tokenApprovals;
735 
736     // Mapping from owner to operator approvals
737     mapping(address => mapping(address => bool)) private _operatorApprovals;
738 
739     /**
740      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
741      */
742     constructor(string memory name_, string memory symbol_) {
743         _name = name_;
744         _symbol = symbol_;
745     }
746 
747     /**
748      * @dev See {IERC165-supportsInterface}.
749      */
750     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
751         return
752             interfaceId == type(IERC721).interfaceId ||
753             interfaceId == type(IERC721Metadata).interfaceId ||
754             super.supportsInterface(interfaceId);
755     }
756 
757     /**
758      * @dev See {IERC721-balanceOf}.
759      */
760     function balanceOf(address owner) public view virtual override returns (uint256) {
761         require(owner != address(0), "ERC721: balance query for the zero address");
762         return _balances[owner];
763     }
764 
765     /**
766      * @dev See {IERC721-ownerOf}.
767      */
768     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
769         address owner = _owners[tokenId];
770         require(owner != address(0), "ERC721: owner query for nonexistent token");
771         return owner;
772     }
773 
774     /**
775      * @dev See {IERC721Metadata-name}.
776      */
777     function name() public view virtual override returns (string memory) {
778         return _name;
779     }
780 
781     /**
782      * @dev See {IERC721Metadata-symbol}.
783      */
784     function symbol() public view virtual override returns (string memory) {
785         return _symbol;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-tokenURI}.
790      */
791     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
792         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
793 
794         string memory baseURI = _baseURI();
795         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
796     }
797 
798     /**
799      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
800      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
801      * by default, can be overriden in child contracts.
802      */
803     function _baseURI() internal view virtual returns (string memory) {
804         return "";
805     }
806 
807     /**
808      * @dev See {IERC721-approve}.
809      */
810     function approve(address to, uint256 tokenId) public virtual override {
811         address owner = ERC721.ownerOf(tokenId);
812         require(to != owner, "ERC721: approval to current owner");
813 
814         require(
815             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
816             "ERC721: approve caller is not owner nor approved for all"
817         );
818 
819         _approve(to, tokenId);
820     }
821 
822     /**
823      * @dev See {IERC721-getApproved}.
824      */
825     function getApproved(uint256 tokenId) public view virtual override returns (address) {
826         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
827 
828         return _tokenApprovals[tokenId];
829     }
830 
831     /**
832      * @dev See {IERC721-setApprovalForAll}.
833      */
834     function setApprovalForAll(address operator, bool approved) public virtual override {
835         require(operator != _msgSender(), "ERC721: approve to caller");
836 
837         _operatorApprovals[_msgSender()][operator] = approved;
838         emit ApprovalForAll(_msgSender(), operator, approved);
839     }
840 
841     /**
842      * @dev See {IERC721-isApprovedForAll}.
843      */
844     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
845         return _operatorApprovals[owner][operator];
846     }
847 
848     /**
849      * @dev See {IERC721-transferFrom}.
850      */
851     function transferFrom(
852         address from,
853         address to,
854         uint256 tokenId
855     ) public virtual override {
856         //solhint-disable-next-line max-line-length
857         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
858 
859         _transfer(from, to, tokenId);
860     }
861 
862     /**
863      * @dev See {IERC721-safeTransferFrom}.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) public virtual override {
870         safeTransferFrom(from, to, tokenId, "");
871     }
872 
873     /**
874      * @dev See {IERC721-safeTransferFrom}.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) public virtual override {
882         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
883         _safeTransfer(from, to, tokenId, _data);
884     }
885 
886     /**
887      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
888      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
889      *
890      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
891      *
892      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
893      * implement alternative mechanisms to perform token transfer, such as signature-based.
894      *
895      * Requirements:
896      *
897      * - `from` cannot be the zero address.
898      * - `to` cannot be the zero address.
899      * - `tokenId` token must exist and be owned by `from`.
900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _safeTransfer(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes memory _data
909     ) internal virtual {
910         _transfer(from, to, tokenId);
911         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
912     }
913 
914     /**
915      * @dev Returns whether `tokenId` exists.
916      *
917      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
918      *
919      * Tokens start existing when they are minted (`_mint`),
920      * and stop existing when they are burned (`_burn`).
921      */
922     function _exists(uint256 tokenId) internal view virtual returns (bool) {
923         return _owners[tokenId] != address(0);
924     }
925 
926     /**
927      * @dev Returns whether `spender` is allowed to manage `tokenId`.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must exist.
932      */
933     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
934         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
935         address owner = ERC721.ownerOf(tokenId);
936         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
937     }
938 
939     /**
940      * @dev Safely mints `tokenId` and transfers it to `to`.
941      *
942      * Requirements:
943      *
944      * - `tokenId` must not exist.
945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
946      *
947      * Emits a {Transfer} event.
948      */
949     function _safeMint(address to, uint256 tokenId) internal virtual {
950         _safeMint(to, tokenId, "");
951     }
952 
953     /**
954      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
955      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
956      */
957     function _safeMint(
958         address to,
959         uint256 tokenId,
960         bytes memory _data
961     ) internal virtual {
962         _mint(to, tokenId);
963         require(
964             _checkOnERC721Received(address(0), to, tokenId, _data),
965             "ERC721: transfer to non ERC721Receiver implementer"
966         );
967     }
968 
969     /**
970      * @dev Mints `tokenId` and transfers it to `to`.
971      *
972      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
973      *
974      * Requirements:
975      *
976      * - `tokenId` must not exist.
977      * - `to` cannot be the zero address.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _mint(address to, uint256 tokenId) internal virtual {
982         require(to != address(0), "ERC721: mint to the zero address");
983         require(!_exists(tokenId), "ERC721: token already minted");
984 
985         _beforeTokenTransfer(address(0), to, tokenId);
986 
987         _balances[to] += 1;
988         _owners[tokenId] = to;
989 
990         emit Transfer(address(0), to, tokenId);
991     }
992 
993     /**
994      * @dev Destroys `tokenId`.
995      * The approval is cleared when the token is burned.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must exist.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _burn(uint256 tokenId) internal virtual {
1004         address owner = ERC721.ownerOf(tokenId);
1005 
1006         _beforeTokenTransfer(owner, address(0), tokenId);
1007 
1008         // Clear approvals
1009         _approve(address(0), tokenId);
1010 
1011         _balances[owner] -= 1;
1012         delete _owners[tokenId];
1013 
1014         emit Transfer(owner, address(0), tokenId);
1015     }
1016 
1017     /**
1018      * @dev Transfers `tokenId` from `from` to `to`.
1019      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
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
1032     ) internal virtual {
1033         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1034         require(to != address(0), "ERC721: transfer to the zero address");
1035 
1036         _beforeTokenTransfer(from, to, tokenId);
1037 
1038         // Clear approvals from the previous owner
1039         _approve(address(0), tokenId);
1040 
1041         _balances[from] -= 1;
1042         _balances[to] += 1;
1043         _owners[tokenId] = to;
1044 
1045         emit Transfer(from, to, tokenId);
1046     }
1047 
1048     /**
1049      * @dev Approve `to` to operate on `tokenId`
1050      *
1051      * Emits a {Approval} event.
1052      */
1053     function _approve(address to, uint256 tokenId) internal virtual {
1054         _tokenApprovals[tokenId] = to;
1055         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1056     }
1057 
1058     /**
1059      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1060      * The call is not executed if the target address is not a contract.
1061      *
1062      * @param from address representing the previous owner of the given token ID
1063      * @param to target address that will receive the tokens
1064      * @param tokenId uint256 ID of the token to be transferred
1065      * @param _data bytes optional data to send along with the call
1066      * @return bool whether the call correctly returned the expected magic value
1067      */
1068     function _checkOnERC721Received(
1069         address from,
1070         address to,
1071         uint256 tokenId,
1072         bytes memory _data
1073     ) private returns (bool) {
1074         if (to.isContract()) {
1075             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1076                 return retval == IERC721Receiver(to).onERC721Received.selector;
1077             } catch (bytes memory reason) {
1078                 if (reason.length == 0) {
1079                     revert("ERC721: transfer to non ERC721Receiver implementer");
1080                 } else {
1081                     assembly {
1082                         revert(add(32, reason), mload(reason))
1083                     }
1084                 }
1085             }
1086         } else {
1087             return true;
1088         }
1089     }
1090 
1091     /**
1092      * @dev Hook that is called before any token transfer. This includes minting
1093      * and burning.
1094      *
1095      * Calling conditions:
1096      *
1097      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1098      * transferred to `to`.
1099      * - When `from` is zero, `tokenId` will be minted for `to`.
1100      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1101      * - `from` and `to` are never both zero.
1102      *
1103      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1104      */
1105     function _beforeTokenTransfer(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) internal virtual {}
1110 }
1111 
1112 
1113 /**
1114  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1115  * enumerability of all the token ids in the contract as well as all token ids owned by each
1116  * account.
1117  */
1118 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1119     // Mapping from owner to list of owned token IDs
1120     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1121 
1122     // Mapping from token ID to index of the owner tokens list
1123     mapping(uint256 => uint256) private _ownedTokensIndex;
1124 
1125     // Array with all token ids, used for enumeration
1126     uint256[] private _allTokens;
1127 
1128     // Mapping from token id to position in the allTokens array
1129     mapping(uint256 => uint256) private _allTokensIndex;
1130 
1131     /**
1132      * @dev See {IERC165-supportsInterface}.
1133      */
1134     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1135         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1136     }
1137 
1138     /**
1139      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1140      */
1141     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1142         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1143         return _ownedTokens[owner][index];
1144     }
1145 
1146     /**
1147      * @dev See {IERC721Enumerable-totalSupply}.
1148      */
1149     function totalSupply() public view virtual override returns (uint256) {
1150         return _allTokens.length;
1151     }
1152 
1153     /**
1154      * @dev See {IERC721Enumerable-tokenByIndex}.
1155      */
1156     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1157         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1158         return _allTokens[index];
1159     }
1160 
1161     /**
1162      * @dev Hook that is called before any token transfer. This includes minting
1163      * and burning.
1164      *
1165      * Calling conditions:
1166      *
1167      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1168      * transferred to `to`.
1169      * - When `from` is zero, `tokenId` will be minted for `to`.
1170      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1171      * - `from` cannot be the zero address.
1172      * - `to` cannot be the zero address.
1173      *
1174      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1175      */
1176     function _beforeTokenTransfer(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) internal virtual override {
1181         super._beforeTokenTransfer(from, to, tokenId);
1182 
1183         if (from == address(0)) {
1184             _addTokenToAllTokensEnumeration(tokenId);
1185         } else if (from != to) {
1186             _removeTokenFromOwnerEnumeration(from, tokenId);
1187         }
1188         if (to == address(0)) {
1189             _removeTokenFromAllTokensEnumeration(tokenId);
1190         } else if (to != from) {
1191             _addTokenToOwnerEnumeration(to, tokenId);
1192         }
1193     }
1194 
1195     /**
1196      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1197      * @param to address representing the new owner of the given token ID
1198      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1199      */
1200     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1201         uint256 length = ERC721.balanceOf(to);
1202         _ownedTokens[to][length] = tokenId;
1203         _ownedTokensIndex[tokenId] = length;
1204     }
1205 
1206     /**
1207      * @dev Private function to add a token to this extension's token tracking data structures.
1208      * @param tokenId uint256 ID of the token to be added to the tokens list
1209      */
1210     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1211         _allTokensIndex[tokenId] = _allTokens.length;
1212         _allTokens.push(tokenId);
1213     }
1214 
1215     /**
1216      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1217      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1218      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1219      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1220      * @param from address representing the previous owner of the given token ID
1221      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1222      */
1223     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1224         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1225         // then delete the last slot (swap and pop).
1226 
1227         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1228         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1229 
1230         // When the token to delete is the last token, the swap operation is unnecessary
1231         if (tokenIndex != lastTokenIndex) {
1232             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1233 
1234             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1235             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1236         }
1237 
1238         // This also deletes the contents at the last position of the array
1239         delete _ownedTokensIndex[tokenId];
1240         delete _ownedTokens[from][lastTokenIndex];
1241     }
1242 
1243     /**
1244      * @dev Private function to remove a token from this extension's token tracking data structures.
1245      * This has O(1) time complexity, but alters the order of the _allTokens array.
1246      * @param tokenId uint256 ID of the token to be removed from the tokens list
1247      */
1248     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1249         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1250         // then delete the last slot (swap and pop).
1251 
1252         uint256 lastTokenIndex = _allTokens.length - 1;
1253         uint256 tokenIndex = _allTokensIndex[tokenId];
1254 
1255         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1256         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1257         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1258         uint256 lastTokenId = _allTokens[lastTokenIndex];
1259 
1260         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1261         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1262 
1263         // This also deletes the contents at the last position of the array
1264         delete _allTokensIndex[tokenId];
1265         _allTokens.pop();
1266     }
1267 }
1268 
1269 pragma solidity ^0.8.0;
1270 
1271 
1272 /**
1273  * @dev ERC721 token with storage based token URI management.
1274  */
1275 abstract contract ERC721URIStorage is ERC721 {
1276     using Strings for uint256;
1277 
1278     // Optional mapping for token URIs
1279     mapping(uint256 => string) private _tokenURIs;
1280 
1281     /**
1282      * @dev See {IERC721Metadata-tokenURI}.
1283      */
1284     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1285         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1286 
1287         string memory _tokenURI = _tokenURIs[tokenId];
1288         string memory base = _baseURI();
1289 
1290         // If there is no base URI, return the token URI.
1291         if (bytes(base).length == 0) {
1292             return _tokenURI;
1293         }
1294         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1295         if (bytes(_tokenURI).length > 0) {
1296             return string(abi.encodePacked(base, _tokenURI));
1297         }
1298 
1299         return super.tokenURI(tokenId);
1300     }
1301 
1302     /**
1303      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1304      *
1305      * Requirements:
1306      *
1307      * - `tokenId` must exist.
1308      */
1309     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1310         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1311         _tokenURIs[tokenId] = _tokenURI;
1312     }
1313 
1314     /**
1315      * @dev Destroys `tokenId`.
1316      * The approval is cleared when the token is burned.
1317      *
1318      * Requirements:
1319      *
1320      * - `tokenId` must exist.
1321      *
1322      * Emits a {Transfer} event.
1323      */
1324     function _burn(uint256 tokenId) internal virtual override {
1325         super._burn(tokenId);
1326 
1327         if (bytes(_tokenURIs[tokenId]).length != 0) {
1328             delete _tokenURIs[tokenId];
1329         }
1330     }
1331 }
1332 
1333 //SPDX-License-Identifier: GPL-3.0-or-later
1334 pragma solidity 0.8.3;
1335 
1336 contract SodaPassNFT is ERC721, ERC721Enumerable,ERC721URIStorage, Ownable {
1337    using Counters for Counters.Counter;
1338     Counters.Counter private _tokenIds;
1339     
1340     uint16 public constant maxSupply = 5100;
1341     string private _baseTokenURI;
1342     
1343     uint256 public _startDate = 1634850000000;
1344     uint256 public _whitelistStartDate = 1634677200000;
1345     
1346     mapping (address => bool) private _whitelisted;
1347 
1348     constructor() ERC721("Soda Pass", "SODA") {
1349          for (uint8 i = 0; i < 100; i++) {
1350             _tokenIds.increment();
1351 
1352             uint256 newItemId = _tokenIds.current();
1353             _mint(msg.sender, newItemId);
1354         }
1355     }
1356     
1357     function setStartDate(uint256 startDate) public onlyOwner {
1358         _startDate = startDate;
1359     }
1360     
1361     function setWhitelistStartDate(uint256 whitelistStartDate) public onlyOwner {
1362         _whitelistStartDate = whitelistStartDate;
1363     }
1364 
1365     function _beforeTokenTransfer(
1366         address from,
1367         address to,
1368         uint256 tokenId
1369     ) internal override(ERC721, ERC721Enumerable) {
1370         super._beforeTokenTransfer(from, to, tokenId);
1371     }
1372     
1373     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1374         super._burn(tokenId);
1375     }
1376 
1377     function supportsInterface(bytes4 interfaceId)
1378         public
1379         view
1380         override(ERC721, ERC721Enumerable)
1381         returns (bool)
1382     {
1383         return super.supportsInterface(interfaceId);
1384     }
1385 
1386 
1387     function setBaseURI(string memory _newbaseTokenURI) public onlyOwner {
1388         _baseTokenURI = _newbaseTokenURI;
1389     }
1390 
1391     function _baseURI() internal view override returns (string memory) {
1392         return _baseTokenURI;
1393     }
1394 
1395     // Get minting limit (for a single transaction) based on current token supply
1396     function getCurrentMintLimit() public view returns (uint8) {
1397         return block.timestamp >= _startDate ? 20 : 4;
1398     }
1399 
1400     // Get ether price based on current token supply
1401     function getCurrentPrice() public pure returns (uint64) {
1402         return 100_000_000_000_000_000;
1403     }
1404     
1405     function addUserToWhitelist(address wallet) public onlyOwner {
1406         _whitelisted[wallet] = true;
1407     }
1408     
1409     function removeUserFromWhitelist(address wallet) public onlyOwner {
1410         _whitelisted[wallet] = false;
1411     }
1412     
1413     // Mint new token(s)
1414     function mint(uint8 _quantityToMint) public payable {
1415         require(_startDate <= block.timestamp || (block.timestamp >= _whitelistStartDate && _whitelisted[msg.sender] == true), block.timestamp <= _whitelistStartDate ? "Sale is not open" : "Not whitelisted");
1416         require(_quantityToMint >= 1, "Must mint at least 1");
1417         require(block.timestamp >= _whitelistStartDate && block.timestamp <= _startDate ? (_quantityToMint + balanceOf(msg.sender) <= 4) : true, "Whitelisted mints are limited to 4 per wallet");
1418         require(
1419             _quantityToMint <= getCurrentMintLimit(),
1420             "Maximum current buy limit for individual transaction exceeded"
1421         );
1422         require(
1423             (_quantityToMint + totalSupply()) <= maxSupply,
1424             "Exceeds maximum supply"
1425         );
1426         require(
1427             msg.value == (getCurrentPrice() * _quantityToMint),
1428             "Ether submitted does not match current price"
1429         );
1430 
1431         for (uint8 i = 0; i < _quantityToMint; i++) {
1432             _tokenIds.increment();
1433 
1434             uint256 newItemId = _tokenIds.current();
1435             _mint(msg.sender, newItemId);
1436         }
1437     }
1438     
1439     function tokenURI(uint256 tokenId)
1440         public
1441         view
1442         override(ERC721, ERC721URIStorage)
1443         returns (string memory)
1444     {
1445         return super.tokenURI(tokenId);
1446     }
1447 
1448     // Withdraw ether from contract
1449     function withdraw() public onlyOwner {
1450         require(address(this).balance > 0, "Balance must be positive");
1451         
1452         uint256 _balance = address(this).balance;
1453         address _coldWallet = 0x9781F65af8324b40Ee9Ca421ea963642Bc8a8C2b;
1454         payable(_coldWallet).transfer((_balance * 9)/10);
1455         
1456         address _devWallet = 0x3097617CbA85A26AdC214A1F87B680bE4b275cD0;
1457         payable(_devWallet).transfer((_balance * 1)/10);
1458     }
1459 }
1460 
1461 pragma solidity 0.8.3;
1462 
1463 contract MrEverybody is ERC721, ERC721Enumerable,ERC721URIStorage, Ownable {
1464    using Counters for Counters.Counter;
1465     Counters.Counter public _tokenIds;
1466     
1467     uint16 public constant maxSupply = 1052;
1468     string private _baseTokenURI;
1469     
1470     uint256 public _startDate; // start 
1471     uint256 public _next48hour = 172800;           // 172800 48 hours
1472     uint256 public _next24hour = 86400;           // 86400 24 hour
1473     
1474     uint256 public _privateSalePrice =  6E16;   // 6E16 0.06 ETH per NFT
1475     uint256 public _publicSalePrice =  7E16;   //7E16 0.07 ETH per NFT
1476     bool public sale_started = false;
1477     event ReturnEvent(uint _amount);
1478     
1479     SodaPassNFT  soda_contract;
1480     
1481     address sodaContract = 0x3b553Fc51A63298E2E44d8ecd3b1ea01d22cA459;
1482     
1483     mapping(address => uint256) public countForAddress;
1484 
1485 
1486     constructor() ERC721("Mr. Everybody", "MEB") {
1487         soda_contract = SodaPassNFT(sodaContract);
1488         
1489         // 30 for team
1490         for (uint8 i = 0; i < 30; i++) {
1491             _tokenIds.increment();
1492 
1493             uint256 newItemId = _tokenIds.current();
1494             _mint(msg.sender, newItemId);
1495         }
1496 
1497     }
1498     
1499     function StartSale() public onlyOwner{
1500         _startDate = block.timestamp;
1501         sale_started = true;
1502     }
1503     
1504     function StopSale() public onlyOwner{
1505         sale_started = false;
1506     }
1507     
1508     function getSodaPassBalance(address _zz) public view returns (uint256 balance) {
1509        return soda_contract.balanceOf(_zz);
1510     }
1511     
1512      function getnow() public view returns (uint256) {
1513        return block.timestamp;
1514     }
1515     
1516     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1517         super._burn(tokenId);
1518     }
1519     
1520     function setStartDate(uint256 startDate) public onlyOwner {
1521         _startDate = startDate;
1522     }
1523     
1524     function setPrivateSalePrice(uint256 privateSalePrice) public onlyOwner {
1525         _privateSalePrice = privateSalePrice;
1526     }
1527     
1528     function setPublicSalePrice(uint256 publicSalePrice) public onlyOwner {
1529         _publicSalePrice = publicSalePrice;
1530     }
1531 
1532     function _beforeTokenTransfer(
1533         address from,
1534         address to,
1535         uint256 tokenId
1536     ) internal override(ERC721, ERC721Enumerable) {
1537         super._beforeTokenTransfer(from, to, tokenId);
1538     }
1539 
1540     function supportsInterface(bytes4 interfaceId)
1541         public
1542         view
1543         override(ERC721, ERC721Enumerable)
1544         returns (bool)
1545     {
1546         return super.supportsInterface(interfaceId);
1547     }
1548 
1549 
1550     function setBaseURI(string memory _newbaseTokenURI) public onlyOwner {
1551         _baseTokenURI = _newbaseTokenURI;
1552     }
1553 
1554     function _baseURI() internal view override returns (string memory) {
1555         return _baseTokenURI;
1556     }
1557 
1558     
1559     
1560      // Mint new token(s)
1561     function mint(uint8 _quantityToMint) public payable {
1562         
1563        require(_quantityToMint <= 10, 'can mint only 10 max at a time');
1564        require((_quantityToMint + totalSupply()) <= maxSupply,"Exceeds maximum supply");
1565        require(sale_started == true,"Sale Not Started");
1566        
1567               // for next 24 hours after presale started by owner
1568         if(block.timestamp <= (_startDate + _next48hour))
1569         {
1570             require(getSodaPassBalance(msg.sender) > 0 , "Needs to have SodaPass");
1571             require((countForAddress[msg.sender] + _quantityToMint) <= getSodaPassBalance(msg.sender),"cannot mint over the balance of SodaPass ");
1572             require(msg.value == (_privateSalePrice * _quantityToMint),"Ether submitted does not match current price 0.06 ETH per token");
1573             for (uint8 i = 0; i < _quantityToMint; i++) {
1574                 _tokenIds.increment();
1575                 uint256 newItemId = _tokenIds.current();
1576                 countForAddress[msg.sender] = countForAddress[msg.sender] + 1;
1577                 emit ReturnEvent(newItemId);
1578                 _mint(msg.sender, newItemId);
1579                 
1580              }
1581         }
1582         if(block.timestamp > (_startDate + _next48hour) && block.timestamp <= (_startDate + _next48hour + _next24hour)){
1583             require(getSodaPassBalance(msg.sender) > 0 , "Needs to have SodaPass");
1584             require(msg.value == (_privateSalePrice * _quantityToMint),"Ether submitted does not match current price 0.06 ETH per token");
1585              for (uint8 i = 0; i < _quantityToMint; i++) {
1586               _tokenIds.increment();
1587               uint256 newItemId = _tokenIds.current();
1588               emit ReturnEvent(newItemId);
1589               _mint(msg.sender, newItemId);
1590           }
1591          }
1592         if(block.timestamp > (_startDate + _next48hour + _next24hour)) {
1593              require(msg.value == (_publicSalePrice * _quantityToMint),"Ether submitted does not match current price 0.07 ETH per token");
1594              for (uint8 i = 0; i < _quantityToMint; i++) {
1595              _tokenIds.increment();
1596              uint256 newItemId = _tokenIds.current();
1597              emit ReturnEvent(newItemId);
1598              _mint(msg.sender, newItemId);
1599              }
1600          }
1601     }
1602 
1603     
1604     function tokenURI(uint256 tokenId)
1605         public
1606         view
1607         override(ERC721, ERC721URIStorage)
1608         returns (string memory)
1609     {
1610         return super.tokenURI(tokenId);
1611     }
1612 
1613     // Withdraw ether from contract
1614     function withdraw() public onlyOwner {
1615         require(address(this).balance > 0, "Balance must be positive");
1616         
1617         uint256 _balance = address(this).balance;
1618         address _coldWallet = 0x0aFEe0A7b9389f9Cf8866F866a93C17CaC29BddA;
1619         payable(_coldWallet).transfer((_balance * 6)/10);
1620         
1621         address _devWallet = 0x7d3d95ac0Bacde573860F75d3cd07369E0CE86F4;
1622         payable(_devWallet).transfer((_balance * 3)/10);
1623         
1624         address _devWallet2 = 0x3097617CbA85A26AdC214A1F87B680bE4b275cD0;
1625         payable(_devWallet2).transfer((_balance * 1)/10);
1626 
1627     }
1628 }