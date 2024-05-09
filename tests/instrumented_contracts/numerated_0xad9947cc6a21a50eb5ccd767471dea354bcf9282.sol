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
66 pragma solidity ^0.8.0;
67 
68 /**
69  * @dev Contract module which provides a basic access control mechanism, where
70  * there is an account (an owner) that can be granted exclusive access to
71  * specific functions.
72  *
73  * By default, the owner account will be the one that deploys the contract. This
74  * can later be changed with {transferOwnership}.
75  *
76  * This module is used through inheritance. It will make available the modifier
77  * `onlyOwner`, which can be applied to your functions to restrict their use to
78  * the owner.
79  */
80 abstract contract Ownable is Context {
81     address private _owner;
82 
83     event OwnershipTransferred(
84         address indexed previousOwner,
85         address indexed newOwner
86     );
87 
88     /**
89      * @dev Initializes the contract setting the deployer as the initial owner.
90      */
91     constructor() {
92         _setOwner(_msgSender());
93     }
94 
95     /**
96      * @dev Returns the address of the current owner.
97      */
98     function owner() public view virtual returns (address) {
99         return _owner;
100     }
101 
102     /**
103      * @dev Throws if called by any account other than the owner.
104      */
105     modifier onlyOwner() {
106         require(owner() == _msgSender(), "Ownable: caller is not the owner");
107         _;
108     }
109 
110     /**
111      * @dev Leaves the contract without owner. It will not be possible to call
112      * `onlyOwner` functions anymore. Can only be called by the current owner.
113      *
114      * NOTE: Renouncing ownership will leave the contract without an owner,
115      * thereby removing any functionality that is only available to the owner.
116      */
117     function renounceOwnership() public virtual onlyOwner {
118         _setOwner(address(0));
119     }
120 
121     /**
122      * @dev Transfers ownership of the contract to a new account (`newOwner`).
123      * Can only be called by the current owner.
124      */
125     function transferOwnership(address newOwner) public virtual onlyOwner {
126         require(
127             newOwner != address(0),
128             "Ownable: new owner is the zero address"
129         );
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
146 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Interface of the ERC165 standard, as defined in the
152  * https://eips.ethereum.org/EIPS/eip-165[EIP].
153  *
154  * Implementers can declare support of contract interfaces, which can then be
155  * queried by others ({ERC165Checker}).
156  *
157  * For an implementation, see {ERC165}.
158  */
159 interface IERC165 {
160     /**
161      * @dev Returns true if this contract implements the interface defined by
162      * `interfaceId`. See the corresponding
163      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
164      * to learn more about how these ids are created.
165      *
166      * This function call must use less than 30 000 gas.
167      */
168     function supportsInterface(bytes4 interfaceId) external view returns (bool);
169 }
170 
171 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev Implementation of the {IERC165} interface.
177  *
178  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
179  * for the additional interface id that will be supported. For example:
180  *
181  * ```solidity
182  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
183  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
184  * }
185  * ```
186  *
187  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
188  */
189 abstract contract ERC165 is IERC165 {
190     /**
191      * @dev See {IERC165-supportsInterface}.
192      */
193     function supportsInterface(bytes4 interfaceId)
194         public
195         view
196         virtual
197         override
198         returns (bool)
199     {
200         return interfaceId == type(IERC165).interfaceId;
201     }
202 }
203 
204 // File: @openzeppelin/contracts/utils/Strings.sol
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev String operations.
210  */
211 library Strings {
212     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
213 
214     /**
215      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
216      */
217     function toString(uint256 value) internal pure returns (string memory) {
218         // Inspired by OraclizeAPI's implementation - MIT licence
219         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
220 
221         if (value == 0) {
222             return "0";
223         }
224         uint256 temp = value;
225         uint256 digits;
226         while (temp != 0) {
227             digits++;
228             temp /= 10;
229         }
230         bytes memory buffer = new bytes(digits);
231         while (value != 0) {
232             digits -= 1;
233             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
234             value /= 10;
235         }
236         return string(buffer);
237     }
238 
239     /**
240      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
241      */
242     function toHexString(uint256 value) internal pure returns (string memory) {
243         if (value == 0) {
244             return "0x00";
245         }
246         uint256 temp = value;
247         uint256 length = 0;
248         while (temp != 0) {
249             length++;
250             temp >>= 8;
251         }
252         return toHexString(value, length);
253     }
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
257      */
258     function toHexString(uint256 value, uint256 length)
259         internal
260         pure
261         returns (string memory)
262     {
263         bytes memory buffer = new bytes(2 * length + 2);
264         buffer[0] = "0";
265         buffer[1] = "x";
266         for (uint256 i = 2 * length + 1; i > 1; --i) {
267             buffer[i] = _HEX_SYMBOLS[value & 0xf];
268             value >>= 4;
269         }
270         require(value == 0, "Strings: hex length insufficient");
271         return string(buffer);
272     }
273 }
274 
275 // File: @openzeppelin/contracts/utils/Context.sol
276 
277 // File: @openzeppelin/contracts/utils/Address.sol
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // This method relies on extcodesize, which returns 0 for contracts in
304         // construction, since the code is only stored at the end of the
305         // constructor execution.
306 
307         uint256 size;
308         assembly {
309             size := extcodesize(account)
310         }
311         return size > 0;
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(
332             address(this).balance >= amount,
333             "Address: insufficient balance"
334         );
335 
336         (bool success, ) = recipient.call{value: amount}("");
337         require(
338             success,
339             "Address: unable to send value, recipient may have reverted"
340         );
341     }
342 
343     /**
344      * @dev Performs a Solidity function call using a low level `call`. A
345      * plain `call` is an unsafe replacement for a function call: use this
346      * function instead.
347      *
348      * If `target` reverts with a revert reason, it is bubbled up by this
349      * function (like regular Solidity function calls).
350      *
351      * Returns the raw returned data. To convert to the expected return value,
352      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
353      *
354      * Requirements:
355      *
356      * - `target` must be a contract.
357      * - calling `target` with `data` must not revert.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data)
362         internal
363         returns (bytes memory)
364     {
365         return functionCall(target, data, "Address: low-level call failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
370      * `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(
375         address target,
376         bytes memory data,
377         string memory errorMessage
378     ) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, 0, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but also transferring `value` wei to `target`.
385      *
386      * Requirements:
387      *
388      * - the calling contract must have an ETH balance of at least `value`.
389      * - the called Solidity function must be `payable`.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(
394         address target,
395         bytes memory data,
396         uint256 value
397     ) internal returns (bytes memory) {
398         return
399             functionCallWithValue(
400                 target,
401                 data,
402                 value,
403                 "Address: low-level call with value failed"
404             );
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
409      * with `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         require(
420             address(this).balance >= value,
421             "Address: insufficient balance for call"
422         );
423         require(isContract(target), "Address: call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.call{value: value}(
426             data
427         );
428         return _verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a static call.
434      *
435      * _Available since v3.3._
436      */
437     function functionStaticCall(address target, bytes memory data)
438         internal
439         view
440         returns (bytes memory)
441     {
442         return
443             functionStaticCall(
444                 target,
445                 data,
446                 "Address: low-level static call failed"
447             );
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
452      * but performing a static call.
453      *
454      * _Available since v3.3._
455      */
456     function functionStaticCall(
457         address target,
458         bytes memory data,
459         string memory errorMessage
460     ) internal view returns (bytes memory) {
461         require(isContract(target), "Address: static call to non-contract");
462 
463         (bool success, bytes memory returndata) = target.staticcall(data);
464         return _verifyCallResult(success, returndata, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.4._
472      */
473     function functionDelegateCall(address target, bytes memory data)
474         internal
475         returns (bytes memory)
476     {
477         return
478             functionDelegateCall(
479                 target,
480                 data,
481                 "Address: low-level delegate call failed"
482             );
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.4._
490      */
491     function functionDelegateCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal returns (bytes memory) {
496         require(isContract(target), "Address: delegate call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.delegatecall(data);
499         return _verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     function _verifyCallResult(
503         bool success,
504         bytes memory returndata,
505         string memory errorMessage
506     ) private pure returns (bytes memory) {
507         if (success) {
508             return returndata;
509         } else {
510             // Look for revert reason and bubble it up if present
511             if (returndata.length > 0) {
512                 // The easiest way to bubble the revert reason is using memory via assembly
513 
514                 assembly {
515                     let returndata_size := mload(returndata)
516                     revert(add(32, returndata), returndata_size)
517                 }
518             } else {
519                 revert(errorMessage);
520             }
521         }
522     }
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @title ERC721 token receiver interface
531  * @dev Interface for any contract that wants to support safeTransfers
532  * from ERC721 asset contracts.
533  */
534 interface IERC721Receiver {
535     /**
536      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
537      * by `operator` from `from`, this function is called.
538      *
539      * It must return its Solidity selector to confirm the token transfer.
540      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
541      *
542      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
543      */
544     function onERC721Received(
545         address operator,
546         address from,
547         uint256 tokenId,
548         bytes calldata data
549     ) external returns (bytes4);
550 }
551 
552 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
553 
554 pragma solidity ^0.8.0;
555 
556 /**
557  * @dev Required interface of an ERC721 compliant contract.
558  */
559 interface IERC721 is IERC165 {
560     /**
561      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
562      */
563     event Transfer(
564         address indexed from,
565         address indexed to,
566         uint256 indexed tokenId
567     );
568 
569     /**
570      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
571      */
572     event Approval(
573         address indexed owner,
574         address indexed approved,
575         uint256 indexed tokenId
576     );
577 
578     /**
579      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
580      */
581     event ApprovalForAll(
582         address indexed owner,
583         address indexed operator,
584         bool approved
585     );
586 
587     /**
588      * @dev Returns the number of tokens in ``owner``'s account.
589      */
590     function balanceOf(address owner) external view returns (uint256 balance);
591 
592     /**
593      * @dev Returns the owner of the `tokenId` token.
594      *
595      * Requirements:
596      *
597      * - `tokenId` must exist.
598      */
599     function ownerOf(uint256 tokenId) external view returns (address owner);
600 
601     /**
602      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
603      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
604      *
605      * Requirements:
606      *
607      * - `from` cannot be the zero address.
608      * - `to` cannot be the zero address.
609      * - `tokenId` token must exist and be owned by `from`.
610      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
611      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
612      *
613      * Emits a {Transfer} event.
614      */
615     function safeTransferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) external;
620 
621     /**
622      * @dev Transfers `tokenId` token from `from` to `to`.
623      *
624      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
625      *
626      * Requirements:
627      *
628      * - `from` cannot be the zero address.
629      * - `to` cannot be the zero address.
630      * - `tokenId` token must be owned by `from`.
631      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
632      *
633      * Emits a {Transfer} event.
634      */
635     function transferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) external;
640 
641     /**
642      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
643      * The approval is cleared when the token is transferred.
644      *
645      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
646      *
647      * Requirements:
648      *
649      * - The caller must own the token or be an approved operator.
650      * - `tokenId` must exist.
651      *
652      * Emits an {Approval} event.
653      */
654     function approve(address to, uint256 tokenId) external;
655 
656     /**
657      * @dev Returns the account approved for `tokenId` token.
658      *
659      * Requirements:
660      *
661      * - `tokenId` must exist.
662      */
663     function getApproved(uint256 tokenId)
664         external
665         view
666         returns (address operator);
667 
668     /**
669      * @dev Approve or remove `operator` as an operator for the caller.
670      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
671      *
672      * Requirements:
673      *
674      * - The `operator` cannot be the caller.
675      *
676      * Emits an {ApprovalForAll} event.
677      */
678     function setApprovalForAll(address operator, bool _approved) external;
679 
680     /**
681      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
682      *
683      * See {setApprovalForAll}
684      */
685     function isApprovedForAll(address owner, address operator)
686         external
687         view
688         returns (bool);
689 
690     /**
691      * @dev Safely transfers `tokenId` token from `from` to `to`.
692      *
693      * Requirements:
694      *
695      * - `from` cannot be the zero address.
696      * - `to` cannot be the zero address.
697      * - `tokenId` token must exist and be owned by `from`.
698      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
699      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
700      *
701      * Emits a {Transfer} event.
702      */
703     function safeTransferFrom(
704         address from,
705         address to,
706         uint256 tokenId,
707         bytes calldata data
708     ) external;
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
712 
713 pragma solidity ^0.8.0;
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
736 /**
737  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
738  * @dev See https://eips.ethereum.org/EIPS/eip-721
739  */
740 interface IERC721Enumerable is IERC721 {
741     /**
742      * @dev Returns the total amount of tokens stored by the contract.
743      */
744     function totalSupply() external view returns (uint256);
745 
746     /**
747      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
748      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
749      */
750     function tokenOfOwnerByIndex(address owner, uint256 index)
751         external
752         view
753         returns (uint256 tokenId);
754 
755     /**
756      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
757      * Use along with {totalSupply} to enumerate all tokens.
758      */
759     function tokenByIndex(uint256 index) external view returns (uint256);
760 }
761 
762 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
763 
764 pragma solidity ^0.8.0;
765 
766 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
767 
768 pragma solidity ^0.8.0;
769 
770 /**
771  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
772  * the Metadata extension, but not including the Enumerable extension, which is available separately as
773  * {ERC721Enumerable}.
774  */
775 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
776     using Address for address;
777     using Strings for uint256;
778 
779     // Token name
780     string private _name;
781 
782     // Token symbol
783     string private _symbol;
784 
785     // Mapping from token ID to owner address
786     mapping(uint256 => address) private _owners;
787 
788     // Mapping owner address to token count
789     mapping(address => uint256) private _balances;
790 
791     // Mapping from token ID to approved address
792     mapping(uint256 => address) private _tokenApprovals;
793 
794     // Mapping from owner to operator approvals
795     mapping(address => mapping(address => bool)) private _operatorApprovals;
796 
797     /**
798      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
799      */
800     constructor(string memory name_, string memory symbol_) {
801         _name = name_;
802         _symbol = symbol_;
803     }
804 
805     /**
806      * @dev See {IERC165-supportsInterface}.
807      */
808     function supportsInterface(bytes4 interfaceId)
809         public
810         view
811         virtual
812         override(ERC165, IERC165)
813         returns (bool)
814     {
815         return
816             interfaceId == type(IERC721).interfaceId ||
817             interfaceId == type(IERC721Metadata).interfaceId ||
818             super.supportsInterface(interfaceId);
819     }
820 
821     /**
822      * @dev See {IERC721-balanceOf}.
823      */
824     function balanceOf(address owner)
825         public
826         view
827         virtual
828         override
829         returns (uint256)
830     {
831         require(
832             owner != address(0),
833             "ERC721: balance query for the zero address"
834         );
835         return _balances[owner];
836     }
837 
838     /**
839      * @dev See {IERC721-ownerOf}.
840      */
841     function ownerOf(uint256 tokenId)
842         public
843         view
844         virtual
845         override
846         returns (address)
847     {
848         address owner = _owners[tokenId];
849         require(
850             owner != address(0),
851             "ERC721: owner query for nonexistent token"
852         );
853         return owner;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-name}.
858      */
859     function name() public view virtual override returns (string memory) {
860         return _name;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-symbol}.
865      */
866     function symbol() public view virtual override returns (string memory) {
867         return _symbol;
868     }
869 
870     /**
871      * @dev See {IERC721Metadata-tokenURI}.
872      */
873     function tokenURI(uint256 tokenId)
874         public
875         view
876         virtual
877         override
878         returns (string memory)
879     {
880         require(
881             _exists(tokenId),
882             "ERC721Metadata: URI query for nonexistent token"
883         );
884 
885         string memory baseURI = _baseURI();
886         return
887             bytes(baseURI).length > 0
888                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
889                 : "";
890     }
891 
892     /**
893      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
894      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
895      * by default, can be overriden in child contracts.
896      */
897     function _baseURI() internal view virtual returns (string memory) {
898         return "";
899     }
900 
901     /**
902      * @dev See {IERC721-approve}.
903      */
904     function approve(address to, uint256 tokenId) public virtual override {
905         address owner = ERC721.ownerOf(tokenId);
906         require(to != owner, "ERC721: approval to current owner");
907 
908         require(
909             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
910             "ERC721: approve caller is not owner nor approved for all"
911         );
912 
913         _approve(to, tokenId);
914     }
915 
916     /**
917      * @dev See {IERC721-getApproved}.
918      */
919     function getApproved(uint256 tokenId)
920         public
921         view
922         virtual
923         override
924         returns (address)
925     {
926         require(
927             _exists(tokenId),
928             "ERC721: approved query for nonexistent token"
929         );
930 
931         return _tokenApprovals[tokenId];
932     }
933 
934     /**
935      * @dev See {IERC721-setApprovalForAll}.
936      */
937     function setApprovalForAll(address operator, bool approved)
938         public
939         virtual
940         override
941     {
942         require(operator != _msgSender(), "ERC721: approve to caller");
943 
944         _operatorApprovals[_msgSender()][operator] = approved;
945         emit ApprovalForAll(_msgSender(), operator, approved);
946     }
947 
948     /**
949      * @dev See {IERC721-isApprovedForAll}.
950      */
951     function isApprovedForAll(address owner, address operator)
952         public
953         view
954         virtual
955         override
956         returns (bool)
957     {
958         return _operatorApprovals[owner][operator];
959     }
960 
961     /**
962      * @dev See {IERC721-transferFrom}.
963      */
964     function transferFrom(
965         address from,
966         address to,
967         uint256 tokenId
968     ) public virtual override {
969         //solhint-disable-next-line max-line-length
970         require(
971             _isApprovedOrOwner(_msgSender(), tokenId),
972             "ERC721: transfer caller is not owner nor approved"
973         );
974 
975         _transfer(from, to, tokenId);
976     }
977 
978     /**
979      * @dev See {IERC721-safeTransferFrom}.
980      */
981     function safeTransferFrom(
982         address from,
983         address to,
984         uint256 tokenId
985     ) public virtual override {
986         safeTransferFrom(from, to, tokenId, "");
987     }
988 
989     /**
990      * @dev See {IERC721-safeTransferFrom}.
991      */
992     function safeTransferFrom(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes memory _data
997     ) public virtual override {
998         require(
999             _isApprovedOrOwner(_msgSender(), tokenId),
1000             "ERC721: transfer caller is not owner nor approved"
1001         );
1002         _safeTransfer(from, to, tokenId, _data);
1003     }
1004 
1005     /**
1006      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1007      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1008      *
1009      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1010      *
1011      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1012      * implement alternative mechanisms to perform token transfer, such as signature-based.
1013      *
1014      * Requirements:
1015      *
1016      * - `from` cannot be the zero address.
1017      * - `to` cannot be the zero address.
1018      * - `tokenId` token must exist and be owned by `from`.
1019      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function _safeTransfer(
1024         address from,
1025         address to,
1026         uint256 tokenId,
1027         bytes memory _data
1028     ) internal virtual {
1029         _transfer(from, to, tokenId);
1030         require(
1031             _checkOnERC721Received(from, to, tokenId, _data),
1032             "ERC721: transfer to non ERC721Receiver implementer"
1033         );
1034     }
1035 
1036     /**
1037      * @dev Returns whether `tokenId` exists.
1038      *
1039      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1040      *
1041      * Tokens start existing when they are minted (`_mint`),
1042      * and stop existing when they are burned (`_burn`).
1043      */
1044     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1045         return _owners[tokenId] != address(0);
1046     }
1047 
1048     /**
1049      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must exist.
1054      */
1055     function _isApprovedOrOwner(address spender, uint256 tokenId)
1056         internal
1057         view
1058         virtual
1059         returns (bool)
1060     {
1061         require(
1062             _exists(tokenId),
1063             "ERC721: operator query for nonexistent token"
1064         );
1065         address owner = ERC721.ownerOf(tokenId);
1066         return (spender == owner ||
1067             getApproved(tokenId) == spender ||
1068             isApprovedForAll(owner, spender));
1069     }
1070 
1071     /**
1072      * @dev Safely mints `tokenId` and transfers it to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - `tokenId` must not exist.
1077      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _safeMint(address to, uint256 tokenId) internal virtual {
1082         _safeMint(to, tokenId, "");
1083     }
1084 
1085     /**
1086      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1087      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1088      */
1089     function _safeMint(
1090         address to,
1091         uint256 tokenId,
1092         bytes memory _data
1093     ) internal virtual {
1094         _mint(to, tokenId);
1095         require(
1096             _checkOnERC721Received(address(0), to, tokenId, _data),
1097             "ERC721: transfer to non ERC721Receiver implementer"
1098         );
1099     }
1100 
1101     /**
1102      * @dev Mints `tokenId` and transfers it to `to`.
1103      *
1104      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1105      *
1106      * Requirements:
1107      *
1108      * - `tokenId` must not exist.
1109      * - `to` cannot be the zero address.
1110      *
1111      * Emits a {Transfer} event.
1112      */
1113     function _mint(address to, uint256 tokenId) internal virtual {
1114         require(to != address(0), "ERC721: mint to the zero address");
1115         require(!_exists(tokenId), "ERC721: token already minted");
1116 
1117         _beforeTokenTransfer(address(0), to, tokenId);
1118 
1119         _balances[to] += 1;
1120         _owners[tokenId] = to;
1121 
1122         emit Transfer(address(0), to, tokenId);
1123     }
1124 
1125     /**
1126      * @dev Destroys `tokenId`.
1127      * The approval is cleared when the token is burned.
1128      *
1129      * Requirements:
1130      *
1131      * - `tokenId` must exist.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _burn(uint256 tokenId) internal virtual {
1136         address owner = ERC721.ownerOf(tokenId);
1137 
1138         _beforeTokenTransfer(owner, address(0), tokenId);
1139 
1140         // Clear approvals
1141         _approve(address(0), tokenId);
1142 
1143         _balances[owner] -= 1;
1144         delete _owners[tokenId];
1145 
1146         emit Transfer(owner, address(0), tokenId);
1147     }
1148 
1149     /**
1150      * @dev Transfers `tokenId` from `from` to `to`.
1151      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1152      *
1153      * Requirements:
1154      *
1155      * - `to` cannot be the zero address.
1156      * - `tokenId` token must be owned by `from`.
1157      *
1158      * Emits a {Transfer} event.
1159      */
1160     function _transfer(
1161         address from,
1162         address to,
1163         uint256 tokenId
1164     ) internal virtual {
1165         require(
1166             ERC721.ownerOf(tokenId) == from,
1167             "ERC721: transfer of token that is not own"
1168         );
1169         require(to != address(0), "ERC721: transfer to the zero address");
1170 
1171         _beforeTokenTransfer(from, to, tokenId);
1172 
1173         // Clear approvals from the previous owner
1174         _approve(address(0), tokenId);
1175 
1176         _balances[from] -= 1;
1177         _balances[to] += 1;
1178         _owners[tokenId] = to;
1179 
1180         emit Transfer(from, to, tokenId);
1181     }
1182 
1183     /**
1184      * @dev Approve `to` to operate on `tokenId`
1185      *
1186      * Emits a {Approval} event.
1187      */
1188     function _approve(address to, uint256 tokenId) internal virtual {
1189         _tokenApprovals[tokenId] = to;
1190         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1191     }
1192 
1193     /**
1194      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1195      * The call is not executed if the target address is not a contract.
1196      *
1197      * @param from address representing the previous owner of the given token ID
1198      * @param to target address that will receive the tokens
1199      * @param tokenId uint256 ID of the token to be transferred
1200      * @param _data bytes optional data to send along with the call
1201      * @return bool whether the call correctly returned the expected magic value
1202      */
1203     function _checkOnERC721Received(
1204         address from,
1205         address to,
1206         uint256 tokenId,
1207         bytes memory _data
1208     ) private returns (bool) {
1209         if (to.isContract()) {
1210             try
1211                 IERC721Receiver(to).onERC721Received(
1212                     _msgSender(),
1213                     from,
1214                     tokenId,
1215                     _data
1216                 )
1217             returns (bytes4 retval) {
1218                 return retval == IERC721Receiver(to).onERC721Received.selector;
1219             } catch (bytes memory reason) {
1220                 if (reason.length == 0) {
1221                     revert(
1222                         "ERC721: transfer to non ERC721Receiver implementer"
1223                     );
1224                 } else {
1225                     assembly {
1226                         revert(add(32, reason), mload(reason))
1227                     }
1228                 }
1229             }
1230         } else {
1231             return true;
1232         }
1233     }
1234 
1235     /**
1236      * @dev Hook that is called before any token transfer. This includes minting
1237      * and burning.
1238      *
1239      * Calling conditions:
1240      *
1241      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1242      * transferred to `to`.
1243      * - When `from` is zero, `tokenId` will be minted for `to`.
1244      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1245      * - `from` and `to` are never both zero.
1246      *
1247      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1248      */
1249     function _beforeTokenTransfer(
1250         address from,
1251         address to,
1252         uint256 tokenId
1253     ) internal virtual {}
1254 }
1255 
1256 /**
1257  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1258  * enumerability of all the token ids in the contract as well as all token ids owned by each
1259  * account.
1260  */
1261 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1262     // Mapping from owner to list of owned token IDs
1263     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1264 
1265     // Mapping from token ID to index of the owner tokens list
1266     mapping(uint256 => uint256) private _ownedTokensIndex;
1267 
1268     // Array with all token ids, used for enumeration
1269     uint256[] private _allTokens;
1270 
1271     // Mapping from token id to position in the allTokens array
1272     mapping(uint256 => uint256) private _allTokensIndex;
1273 
1274     /**
1275      * @dev See {IERC165-supportsInterface}.
1276      */
1277     function supportsInterface(bytes4 interfaceId)
1278         public
1279         view
1280         virtual
1281         override(IERC165, ERC721)
1282         returns (bool)
1283     {
1284         return
1285             interfaceId == type(IERC721Enumerable).interfaceId ||
1286             super.supportsInterface(interfaceId);
1287     }
1288 
1289     /**
1290      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1291      */
1292     function tokenOfOwnerByIndex(address owner, uint256 index)
1293         public
1294         view
1295         virtual
1296         override
1297         returns (uint256)
1298     {
1299         require(
1300             index < ERC721.balanceOf(owner),
1301             "ERC721Enumerable: owner index out of bounds"
1302         );
1303         return _ownedTokens[owner][index];
1304     }
1305 
1306     /**
1307      * @dev See {IERC721Enumerable-totalSupply}.
1308      */
1309     function totalSupply() public view virtual override returns (uint256) {
1310         return _allTokens.length;
1311     }
1312 
1313     /**
1314      * @dev See {IERC721Enumerable-tokenByIndex}.
1315      */
1316     function tokenByIndex(uint256 index)
1317         public
1318         view
1319         virtual
1320         override
1321         returns (uint256)
1322     {
1323         require(
1324             index < ERC721Enumerable.totalSupply(),
1325             "ERC721Enumerable: global index out of bounds"
1326         );
1327         return _allTokens[index];
1328     }
1329 
1330     /**
1331      * @dev Hook that is called before any token transfer. This includes minting
1332      * and burning.
1333      *
1334      * Calling conditions:
1335      *
1336      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1337      * transferred to `to`.
1338      * - When `from` is zero, `tokenId` will be minted for `to`.
1339      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1340      * - `from` cannot be the zero address.
1341      * - `to` cannot be the zero address.
1342      *
1343      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1344      */
1345     function _beforeTokenTransfer(
1346         address from,
1347         address to,
1348         uint256 tokenId
1349     ) internal virtual override {
1350         super._beforeTokenTransfer(from, to, tokenId);
1351 
1352         if (from == address(0)) {
1353             _addTokenToAllTokensEnumeration(tokenId);
1354         } else if (from != to) {
1355             _removeTokenFromOwnerEnumeration(from, tokenId);
1356         }
1357         if (to == address(0)) {
1358             _removeTokenFromAllTokensEnumeration(tokenId);
1359         } else if (to != from) {
1360             _addTokenToOwnerEnumeration(to, tokenId);
1361         }
1362     }
1363 
1364     /**
1365      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1366      * @param to address representing the new owner of the given token ID
1367      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1368      */
1369     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1370         uint256 length = ERC721.balanceOf(to);
1371         _ownedTokens[to][length] = tokenId;
1372         _ownedTokensIndex[tokenId] = length;
1373     }
1374 
1375     /**
1376      * @dev Private function to add a token to this extension's token tracking data structures.
1377      * @param tokenId uint256 ID of the token to be added to the tokens list
1378      */
1379     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1380         _allTokensIndex[tokenId] = _allTokens.length;
1381         _allTokens.push(tokenId);
1382     }
1383 
1384     /**
1385      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1386      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1387      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1388      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1389      * @param from address representing the previous owner of the given token ID
1390      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1391      */
1392     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1393         private
1394     {
1395         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1396         // then delete the last slot (swap and pop).
1397 
1398         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1399         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1400 
1401         // When the token to delete is the last token, the swap operation is unnecessary
1402         if (tokenIndex != lastTokenIndex) {
1403             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1404 
1405             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1406             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1407         }
1408 
1409         // This also deletes the contents at the last position of the array
1410         delete _ownedTokensIndex[tokenId];
1411         delete _ownedTokens[from][lastTokenIndex];
1412     }
1413 
1414     /**
1415      * @dev Private function to remove a token from this extension's token tracking data structures.
1416      * This has O(1) time complexity, but alters the order of the _allTokens array.
1417      * @param tokenId uint256 ID of the token to be removed from the tokens list
1418      */
1419     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1420         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1421         // then delete the last slot (swap and pop).
1422 
1423         uint256 lastTokenIndex = _allTokens.length - 1;
1424         uint256 tokenIndex = _allTokensIndex[tokenId];
1425 
1426         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1427         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1428         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1429         uint256 lastTokenId = _allTokens[lastTokenIndex];
1430 
1431         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1432         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1433 
1434         // This also deletes the contents at the last position of the array
1435         delete _allTokensIndex[tokenId];
1436         _allTokens.pop();
1437     }
1438 }
1439 
1440 pragma solidity ^0.8.0;
1441 
1442 /**
1443  * @dev ERC721 token with storage based token URI management.
1444  */
1445 abstract contract ERC721URIStorage is ERC721 {
1446     using Strings for uint256;
1447 
1448     // Optional mapping for token URIs
1449     mapping(uint256 => string) private _tokenURIs;
1450 
1451     /**
1452      * @dev See {IERC721Metadata-tokenURI}.
1453      */
1454     function tokenURI(uint256 tokenId)
1455         public
1456         view
1457         virtual
1458         override
1459         returns (string memory)
1460     {
1461         require(
1462             _exists(tokenId),
1463             "ERC721URIStorage: URI query for nonexistent token"
1464         );
1465 
1466         string memory _tokenURI = _tokenURIs[tokenId];
1467         string memory base = _baseURI();
1468 
1469         // If there is no base URI, return the token URI.
1470         if (bytes(base).length == 0) {
1471             return _tokenURI;
1472         }
1473         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1474         if (bytes(_tokenURI).length > 0) {
1475             return string(abi.encodePacked(base, _tokenURI));
1476         }
1477 
1478         return super.tokenURI(tokenId);
1479     }
1480 
1481     /**
1482      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1483      *
1484      * Requirements:
1485      *
1486      * - `tokenId` must exist.
1487      */
1488     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
1489         internal
1490         virtual
1491     {
1492         require(
1493             _exists(tokenId),
1494             "ERC721URIStorage: URI set of nonexistent token"
1495         );
1496         _tokenURIs[tokenId] = _tokenURI;
1497     }
1498 
1499     /**
1500      * @dev Destroys `tokenId`.
1501      * The approval is cleared when the token is burned.
1502      *
1503      * Requirements:
1504      *
1505      * - `tokenId` must exist.
1506      *
1507      * Emits a {Transfer} event.
1508      */
1509     function _burn(uint256 tokenId) internal virtual override {
1510         super._burn(tokenId);
1511 
1512         if (bytes(_tokenURIs[tokenId]).length != 0) {
1513             delete _tokenURIs[tokenId];
1514         }
1515     }
1516 }
1517 
1518 //SPDX-License-Identifier: GPL-3.0-or-later
1519 // pragma solidity 0.8.0;
1520 
1521 contract UnimpressedGeisha is
1522     ERC721,
1523     ERC721Enumerable,
1524     ERC721URIStorage,
1525     Ownable
1526 {
1527     using Counters for Counters.Counter;
1528     Counters.Counter private _tokenIds;
1529     Counters.Counter private _freeSupply;
1530 
1531     uint16 public constant maxSupply = 3333;
1532     uint16 public constant freeSupplyLimit = 500;
1533     uint256 internal constant matchaWhitelistBonus = 50;
1534     uint256 internal constant baseMatchaUGRewardValuePA = 1000;
1535     uint256 internal constant baseMatchaRewardApr = 100;
1536     string private _baseTokenURI;
1537     uint256 public _whitelistStartDate;
1538     uint256 public _whitelistSaleStartDate;
1539     uint256 public _startDate;
1540     address public _teamWallet;
1541     address public _secondTeamWallet;
1542 
1543     mapping(address => bool) private _whitelisted;
1544     mapping(address => bool) public _oneFreeClaimed;
1545     mapping(address => uint256) public _matchaAPRRewardPeriod;
1546     mapping(address => uint256) public _earnedFutureMatcha;
1547 
1548     constructor() ERC721("Unimpressed Geisha", "UG") {}
1549 
1550     function setBaseURI(string memory _newbaseTokenURI) public onlyOwner {
1551         _baseTokenURI = _newbaseTokenURI;
1552     }
1553 
1554     function setWhitelistStartDate(uint256 whitelistStartDate)
1555         public
1556         onlyOwner
1557     {
1558         _whitelistStartDate = whitelistStartDate;
1559     }
1560 
1561     function setWhitelistSaleStartDate(uint256 whitelistSaleStartDate)
1562         public
1563         onlyOwner
1564     {
1565         _whitelistSaleStartDate = whitelistSaleStartDate;
1566     }
1567 
1568     function setStartDate(uint256 startDate) public onlyOwner {
1569         _startDate = startDate;
1570     }
1571 
1572     function _baseURI() internal view override returns (string memory) {
1573         return _baseTokenURI;
1574     }
1575 
1576     function getMintPrice() public pure returns (uint64) {
1577         return 40_000_000_000_000_000;
1578     }
1579 
1580     function getDiscountedPrice() public pure returns (uint64) {
1581         return 20_000_000_000_000_000;
1582     }
1583 
1584     function getWhitelisted() public {
1585         require(
1586             whitelistingOpen(),
1587             "Whitelisting did not start yet or it's already over"
1588         );
1589         _whitelisted[msg.sender] = true;
1590         _matchaAPRRewardPeriod[msg.sender] = block.timestamp;
1591         _earnedFutureMatcha[msg.sender] = matchaWhitelistBonus * (10 ** uint256(18));
1592     }
1593 
1594     function removeUserFromWhitelist(address wallet) public onlyOwner {
1595         _whitelisted[wallet] = false;
1596     }
1597 
1598     function isWhitelisted(address wallet) public view returns (bool) {
1599         return _whitelisted[wallet];
1600     }
1601 
1602     function oneFreeClaimed(address wallet) public view returns (bool) {
1603         return _oneFreeClaimed[wallet];
1604     }
1605 
1606     function whitelistingOpen() public view returns (bool) {
1607         return
1608             block.timestamp >= _whitelistStartDate &&
1609             block.timestamp <= _whitelistSaleStartDate;
1610     }
1611 
1612     function whitelistedSaleStarted() public view returns (bool) {
1613         return _whitelistSaleStartDate <= block.timestamp;
1614     }
1615 
1616     function saleStarted() public view returns (bool) {
1617         return _startDate <= block.timestamp;
1618     }
1619 
1620     function whitelistedMint(uint8 _quantityToMint) public payable {
1621         require(
1622             _startDate <= block.timestamp ||
1623                 (block.timestamp >= _whitelistSaleStartDate &&
1624                     _whitelisted[msg.sender] == true),
1625             block.timestamp <= _whitelistSaleStartDate
1626                 ? "Whitelist sale is not open"
1627                 : "Not whitelisted"
1628         );
1629         require(_quantityToMint >= 1, "Must mint at least 1");
1630         require(_quantityToMint <= 5, "Can mint max 5");
1631 
1632         require(
1633             (_quantityToMint + totalSupply()) <= maxSupply,
1634             "Exceeds maximum supply"
1635         );
1636         require(
1637             (_quantityToMint + _freeSupply.current()) <= freeSupplyLimit,
1638             "Exceeds free supply"
1639         );
1640 
1641         if (_oneFreeClaimed[msg.sender]) {
1642             require(
1643                 msg.value == (getDiscountedPrice() * _quantityToMint),
1644                 "Ether submitted does not match discounted price"
1645             );
1646             calcMint(msg.sender, _quantityToMint);
1647         } else {
1648             if (_quantityToMint > 1) {
1649                 require(
1650                     msg.value == (getDiscountedPrice() * (_quantityToMint - 1)),
1651                     "Ether submitted does not match discounted price"
1652                 );
1653             }
1654             _oneFreeClaimed[msg.sender] = true;
1655             _freeSupply.increment();
1656             calcMint(msg.sender, _quantityToMint);
1657         }
1658     }
1659 
1660     function mint(address _wallet, uint8 _quantityToMint) public payable {
1661         require(_startDate <= block.timestamp, "Sale is not open");
1662         require(_quantityToMint >= 1, "Must mint at least 1");
1663         require(_quantityToMint <= 5, "Can mint max 5");
1664         require(
1665             (_quantityToMint + totalSupply()) <= maxSupply,
1666             "Exceeds maximum supply"
1667         );
1668         require(
1669             msg.value == (getMintPrice() * _quantityToMint),
1670             "Ether submitted does not match current price"
1671         );
1672         calcMint(_wallet, _quantityToMint);
1673     }
1674 
1675     function calcMint(address _wallet, uint8 _quantityToMint) internal {
1676         for (uint8 i = 0; i < _quantityToMint; i++) {
1677             _tokenIds.increment();
1678             uint256 newItemId = _tokenIds.current();
1679             _mint(_wallet, newItemId);
1680         }
1681     }
1682 
1683     function reserveMint(uint8 _quantityToMint) public onlyOwner {
1684         require(_quantityToMint >= 1, "Must mint at least 1");
1685         require(_quantityToMint <= 10, "Can mint max 10");
1686         require(
1687             (_quantityToMint + totalSupply()) <= maxSupply,
1688             "Exceeds maximum supply"
1689         );
1690 
1691         for (uint8 i = 0; i < _quantityToMint; i++) {
1692             _tokenIds.increment();
1693             uint256 newItemId = _tokenIds.current();
1694             _mint(msg.sender, newItemId);
1695         }
1696     }
1697 
1698     function tokenURI(uint256 tokenId)
1699         public
1700         view
1701         override(ERC721, ERC721URIStorage)
1702         returns (string memory)
1703     {
1704         return super.tokenURI(tokenId);
1705     }
1706 
1707     function setWithdrawAddress(address _wallet) public onlyOwner {
1708         _teamWallet = _wallet;
1709     }
1710 
1711     function setSecondWithdrawAddress(address _wallet) public onlyOwner {
1712         _secondTeamWallet = _wallet;
1713     }
1714 
1715     function withdraw() public onlyOwner {
1716         require(address(this).balance > 0, "Balance must be positive");
1717         require(
1718             _teamWallet != address(0) && _secondTeamWallet != address(0),
1719             "Wallets must be set"
1720         );
1721         uint256 _balance = address(this).balance;
1722         uint256 _split = _balance / 2;
1723         payable(_teamWallet).transfer(_split);
1724         payable(_secondTeamWallet).transfer(_split);
1725     }
1726 
1727     function balanceOfMatchaReward(address owner)
1728         public
1729         view
1730         virtual
1731         returns (uint256)
1732     {
1733         require(
1734             owner != address(0),
1735             "Balance query for the zero address"
1736         );
1737         return _earnedFutureMatcha[owner];
1738     }
1739 
1740     function joinMatchaReward() public {
1741         require(block.timestamp >= _whitelistStartDate, "Whitelisting or sale not started");
1742         require(
1743             isJoinedInMatchaReward(msg.sender) == uint256(0),
1744             "You already joined"
1745         );
1746         _matchaAPRRewardPeriod[msg.sender] = block.timestamp;
1747     }
1748 
1749     function isJoinedInMatchaReward(address wallet) public view returns (uint256) {
1750         return _matchaAPRRewardPeriod[wallet];
1751     }
1752 
1753     function claimMatchaReward() public {
1754         uint256 userBalance = balanceOf(msg.sender);
1755         require(userBalance >= 1, "Only holders are able to claim");
1756         uint256 reward = calculateMatchaReward(msg.sender, userBalance);
1757         _matchaAPRRewardPeriod[msg.sender] = block.timestamp;
1758         _earnedFutureMatcha[msg.sender] = _earnedFutureMatcha[msg.sender] + reward;
1759     }
1760 
1761     function calculateMatchaRewardAPRSingle() public view returns (uint256) {
1762         uint256 coef = ((maxSupply - totalSupply()) * (10**18)) / baseMatchaUGRewardValuePA;
1763         uint256 baseMAPR = baseMatchaRewardApr * (10**18);
1764         return baseMAPR + (baseMatchaRewardApr * coef);
1765     }
1766 
1767     function calculateMatchaRewardAPR() public view returns (uint256) {
1768         uint256 coef = ((maxSupply - totalSupply()) * (10**18)) / baseMatchaUGRewardValuePA;
1769         uint256 baseMAPR = baseMatchaRewardApr * (10**18);
1770         uint256 calcAPR = baseMAPR + (baseMatchaRewardApr * coef);
1771         return calcAPR * balanceOf(msg.sender);
1772     }
1773 
1774     function calculateMatchaReward(address _wallet, uint256 _userbalace)
1775         public
1776         view
1777         returns (uint256)
1778     {
1779         uint256 matchaPA = (_userbalace * baseMatchaUGRewardValuePA) / (100) * calculateMatchaRewardAPR();
1780         uint256 matchaPerSecond = matchaPA / uint256(31556926);
1781         uint256 initialPeriod = _matchaAPRRewardPeriod[_wallet];
1782         uint256 diffPeriod = block.timestamp - initialPeriod;
1783         return (diffPeriod * matchaPerSecond);
1784     }
1785 
1786     function _beforeTokenTransfer(
1787         address from,
1788         address to,
1789         uint256 tokenId
1790     ) internal override(ERC721, ERC721Enumerable) {
1791         super._beforeTokenTransfer(from, to, tokenId);
1792     }
1793 
1794     function _burn(uint256 tokenId)
1795         internal
1796         override(ERC721, ERC721URIStorage)
1797     {
1798         super._burn(tokenId);
1799     }
1800 
1801     function supportsInterface(bytes4 interfaceId)
1802         public
1803         view
1804         override(ERC721, ERC721Enumerable)
1805         returns (bool)
1806     {
1807         return super.supportsInterface(interfaceId);
1808     }
1809 
1810     fallback() external payable {}
1811 
1812     receive() external payable {}
1813 }