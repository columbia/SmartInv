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
42 // File: @openzeppelin/contracts/utils/Context.sol
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
66 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
67 
68 pragma solidity ^0.8.0;
69 
70 /**
71  * @dev Interface of the ERC165 standard, as defined in the
72  * https://eips.ethereum.org/EIPS/eip-165[EIP].
73  *
74  * Implementers can declare support of contract interfaces, which can then be
75  * queried by others ({ERC165Checker}).
76  *
77  * For an implementation, see {ERC165}.
78  */
79 interface IERC165 {
80     /**
81      * @dev Returns true if this contract implements the interface defined by
82      * `interfaceId`. See the corresponding
83      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
84      * to learn more about how these ids are created.
85      *
86      * This function call must use less than 30 000 gas.
87      */
88     function supportsInterface(bytes4 interfaceId) external view returns (bool);
89 }
90 
91 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Required interface of an ERC721 compliant contract.
97  */
98 interface IERC721 is IERC165 {
99     /**
100      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
101      */
102     event Transfer(
103         address indexed from,
104         address indexed to,
105         uint256 indexed tokenId
106     );
107 
108     /**
109      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
110      */
111     event Approval(
112         address indexed owner,
113         address indexed approved,
114         uint256 indexed tokenId
115     );
116 
117     /**
118      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
119      */
120     event ApprovalForAll(
121         address indexed owner,
122         address indexed operator,
123         bool approved
124     );
125 
126     /**
127      * @dev Returns the number of tokens in ``owner``'s account.
128      */
129     function balanceOf(address owner) external view returns (uint256 balance);
130 
131     /**
132      * @dev Returns the owner of the `tokenId` token.
133      *
134      * Requirements:
135      *
136      * - `tokenId` must exist.
137      */
138     function ownerOf(uint256 tokenId) external view returns (address owner);
139 
140     /**
141      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
142      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
143      *
144      * Requirements:
145      *
146      * - `from` cannot be the zero address.
147      * - `to` cannot be the zero address.
148      * - `tokenId` token must exist and be owned by `from`.
149      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151      *
152      * Emits a {Transfer} event.
153      */
154     function safeTransferFrom(
155         address from,
156         address to,
157         uint256 tokenId
158     ) external;
159 
160     /**
161      * @dev Transfers `tokenId` token from `from` to `to`.
162      *
163      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must be owned by `from`.
170      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transferFrom(
175         address from,
176         address to,
177         uint256 tokenId
178     ) external;
179 
180     /**
181      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
182      * The approval is cleared when the token is transferred.
183      *
184      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
185      *
186      * Requirements:
187      *
188      * - The caller must own the token or be an approved operator.
189      * - `tokenId` must exist.
190      *
191      * Emits an {Approval} event.
192      */
193     function approve(address to, uint256 tokenId) external;
194 
195     /**
196      * @dev Returns the account approved for `tokenId` token.
197      *
198      * Requirements:
199      *
200      * - `tokenId` must exist.
201      */
202     function getApproved(uint256 tokenId)
203         external
204         view
205         returns (address operator);
206 
207     /**
208      * @dev Approve or remove `operator` as an operator for the caller.
209      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
210      *
211      * Requirements:
212      *
213      * - The `operator` cannot be the caller.
214      *
215      * Emits an {ApprovalForAll} event.
216      */
217     function setApprovalForAll(address operator, bool _approved) external;
218 
219     /**
220      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
221      *
222      * See {setApprovalForAll}
223      */
224     function isApprovedForAll(address owner, address operator)
225         external
226         view
227         returns (bool);
228 
229     /**
230      * @dev Safely transfers `tokenId` token from `from` to `to`.
231      *
232      * Requirements:
233      *
234      * - `from` cannot be the zero address.
235      * - `to` cannot be the zero address.
236      * - `tokenId` token must exist and be owned by `from`.
237      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
238      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
239      *
240      * Emits a {Transfer} event.
241      */
242     function safeTransferFrom(
243         address from,
244         address to,
245         uint256 tokenId,
246         bytes calldata data
247     ) external;
248 }
249 
250 // File: @openzeppelin/contracts/access/Ownable.sol
251 
252 pragma solidity ^0.8.0;
253 
254 /**
255  * @dev Contract module which provides a basic access control mechanism, where
256  * there is an account (an owner) that can be granted exclusive access to
257  * specific functions.
258  *
259  * By default, the owner account will be the one that deploys the contract. This
260  * can later be changed with {transferOwnership}.
261  *
262  * This module is used through inheritance. It will make available the modifier
263  * `onlyOwner`, which can be applied to your functions to restrict their use to
264  * the owner.
265  */
266 abstract contract Ownable is Context {
267     address private _owner;
268 
269     event OwnershipTransferred(
270         address indexed previousOwner,
271         address indexed newOwner
272     );
273 
274     /**
275      * @dev Initializes the contract setting the deployer as the initial owner.
276      */
277     constructor() {
278         _setOwner(_msgSender());
279     }
280 
281     /**
282      * @dev Returns the address of the current owner.
283      */
284     function owner() public view virtual returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(owner() == _msgSender(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     /**
297      * @dev Leaves the contract without owner. It will not be possible to call
298      * `onlyOwner` functions anymore. Can only be called by the current owner.
299      *
300      * NOTE: Renouncing ownership will leave the contract without an owner,
301      * thereby removing any functionality that is only available to the owner.
302      */
303     function renounceOwnership() public virtual onlyOwner {
304         _setOwner(address(0));
305     }
306 
307     /**
308      * @dev Transfers ownership of the contract to a new account (`newOwner`).
309      * Can only be called by the current owner.
310      */
311     function transferOwnership(address newOwner) public virtual onlyOwner {
312         require(
313             newOwner != address(0),
314             "Ownable: new owner is the zero address"
315         );
316         _setOwner(newOwner);
317     }
318 
319     function _setOwner(address newOwner) private {
320         address oldOwner = _owner;
321         _owner = newOwner;
322         emit OwnershipTransferred(oldOwner, newOwner);
323     }
324 }
325 
326 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
332  * @dev See https://eips.ethereum.org/EIPS/eip-721
333  */
334 interface IERC721Enumerable is IERC721 {
335     /**
336      * @dev Returns the total amount of tokens stored by the contract.
337      */
338     function totalSupply() external view returns (uint256);
339 
340     /**
341      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
342      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
343      */
344     function tokenOfOwnerByIndex(address owner, uint256 index)
345         external
346         view
347         returns (uint256 tokenId);
348 
349     /**
350      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
351      * Use along with {totalSupply} to enumerate all tokens.
352      */
353     function tokenByIndex(uint256 index) external view returns (uint256);
354 }
355 
356 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Implementation of the {IERC165} interface.
362  *
363  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
364  * for the additional interface id that will be supported. For example:
365  *
366  * ```solidity
367  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
368  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
369  * }
370  * ```
371  *
372  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
373  */
374 abstract contract ERC165 is IERC165 {
375     /**
376      * @dev See {IERC165-supportsInterface}.
377      */
378     function supportsInterface(bytes4 interfaceId)
379         public
380         view
381         virtual
382         override
383         returns (bool)
384     {
385         return interfaceId == type(IERC165).interfaceId;
386     }
387 }
388 
389 // File: @openzeppelin/contracts/utils/Strings.sol
390 
391 pragma solidity ^0.8.0;
392 
393 /**
394  * @dev String operations.
395  */
396 library Strings {
397     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
401      */
402     function toString(uint256 value) internal pure returns (string memory) {
403         // Inspired by OraclizeAPI's implementation - MIT licence
404         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
405 
406         if (value == 0) {
407             return "0";
408         }
409         uint256 temp = value;
410         uint256 digits;
411         while (temp != 0) {
412             digits++;
413             temp /= 10;
414         }
415         bytes memory buffer = new bytes(digits);
416         while (value != 0) {
417             digits -= 1;
418             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
419             value /= 10;
420         }
421         return string(buffer);
422     }
423 
424     /**
425      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
426      */
427     function toHexString(uint256 value) internal pure returns (string memory) {
428         if (value == 0) {
429             return "0x00";
430         }
431         uint256 temp = value;
432         uint256 length = 0;
433         while (temp != 0) {
434             length++;
435             temp >>= 8;
436         }
437         return toHexString(value, length);
438     }
439 
440     /**
441      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
442      */
443     function toHexString(uint256 value, uint256 length)
444         internal
445         pure
446         returns (string memory)
447     {
448         bytes memory buffer = new bytes(2 * length + 2);
449         buffer[0] = "0";
450         buffer[1] = "x";
451         for (uint256 i = 2 * length + 1; i > 1; --i) {
452             buffer[i] = _HEX_SYMBOLS[value & 0xf];
453             value >>= 4;
454         }
455         require(value == 0, "Strings: hex length insufficient");
456         return string(buffer);
457     }
458 }
459 
460 // File: @openzeppelin/contracts/utils/Address.sol
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @dev Collection of functions related to the address type
466  */
467 library Address {
468     /**
469      * @dev Returns true if `account` is a contract.
470      *
471      * [IMPORTANT]
472      * ====
473      * It is unsafe to assume that an address for which this function returns
474      * false is an externally-owned account (EOA) and not a contract.
475      *
476      * Among others, `isContract` will return false for the following
477      * types of addresses:
478      *
479      *  - an externally-owned account
480      *  - a contract in construction
481      *  - an address where a contract will be created
482      *  - an address where a contract lived, but was destroyed
483      * ====
484      */
485     function isContract(address account) internal view returns (bool) {
486         // This method relies on extcodesize, which returns 0 for contracts in
487         // construction, since the code is only stored at the end of the
488         // constructor execution.
489 
490         uint256 size;
491         assembly {
492             size := extcodesize(account)
493         }
494         return size > 0;
495     }
496 
497     /**
498      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
499      * `recipient`, forwarding all available gas and reverting on errors.
500      *
501      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
502      * of certain opcodes, possibly making contracts go over the 2300 gas limit
503      * imposed by `transfer`, making them unable to receive funds via
504      * `transfer`. {sendValue} removes this limitation.
505      *
506      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
507      *
508      * IMPORTANT: because control is transferred to `recipient`, care must be
509      * taken to not create reentrancy vulnerabilities. Consider using
510      * {ReentrancyGuard} or the
511      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
512      */
513     function sendValue(address payable recipient, uint256 amount) internal {
514         require(
515             address(this).balance >= amount,
516             "Address: insufficient balance"
517         );
518 
519         (bool success, ) = recipient.call{value: amount}("");
520         require(
521             success,
522             "Address: unable to send value, recipient may have reverted"
523         );
524     }
525 
526     /**
527      * @dev Performs a Solidity function call using a low level `call`. A
528      * plain `call` is an unsafe replacement for a function call: use this
529      * function instead.
530      *
531      * If `target` reverts with a revert reason, it is bubbled up by this
532      * function (like regular Solidity function calls).
533      *
534      * Returns the raw returned data. To convert to the expected return value,
535      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
536      *
537      * Requirements:
538      *
539      * - `target` must be a contract.
540      * - calling `target` with `data` must not revert.
541      *
542      * _Available since v3.1._
543      */
544     function functionCall(address target, bytes memory data)
545         internal
546         returns (bytes memory)
547     {
548         return functionCall(target, data, "Address: low-level call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
553      * `errorMessage` as a fallback revert reason when `target` reverts.
554      *
555      * _Available since v3.1._
556      */
557     function functionCall(
558         address target,
559         bytes memory data,
560         string memory errorMessage
561     ) internal returns (bytes memory) {
562         return functionCallWithValue(target, data, 0, errorMessage);
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
567      * but also transferring `value` wei to `target`.
568      *
569      * Requirements:
570      *
571      * - the calling contract must have an ETH balance of at least `value`.
572      * - the called Solidity function must be `payable`.
573      *
574      * _Available since v3.1._
575      */
576     function functionCallWithValue(
577         address target,
578         bytes memory data,
579         uint256 value
580     ) internal returns (bytes memory) {
581         return
582             functionCallWithValue(
583                 target,
584                 data,
585                 value,
586                 "Address: low-level call with value failed"
587             );
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
592      * with `errorMessage` as a fallback revert reason when `target` reverts.
593      *
594      * _Available since v3.1._
595      */
596     function functionCallWithValue(
597         address target,
598         bytes memory data,
599         uint256 value,
600         string memory errorMessage
601     ) internal returns (bytes memory) {
602         require(
603             address(this).balance >= value,
604             "Address: insufficient balance for call"
605         );
606         require(isContract(target), "Address: call to non-contract");
607 
608         (bool success, bytes memory returndata) = target.call{value: value}(
609             data
610         );
611         return _verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a static call.
617      *
618      * _Available since v3.3._
619      */
620     function functionStaticCall(address target, bytes memory data)
621         internal
622         view
623         returns (bytes memory)
624     {
625         return
626             functionStaticCall(
627                 target,
628                 data,
629                 "Address: low-level static call failed"
630             );
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
635      * but performing a static call.
636      *
637      * _Available since v3.3._
638      */
639     function functionStaticCall(
640         address target,
641         bytes memory data,
642         string memory errorMessage
643     ) internal view returns (bytes memory) {
644         require(isContract(target), "Address: static call to non-contract");
645 
646         (bool success, bytes memory returndata) = target.staticcall(data);
647         return _verifyCallResult(success, returndata, errorMessage);
648     }
649 
650     /**
651      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
652      * but performing a delegate call.
653      *
654      * _Available since v3.4._
655      */
656     function functionDelegateCall(address target, bytes memory data)
657         internal
658         returns (bytes memory)
659     {
660         return
661             functionDelegateCall(
662                 target,
663                 data,
664                 "Address: low-level delegate call failed"
665             );
666     }
667 
668     /**
669      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
670      * but performing a delegate call.
671      *
672      * _Available since v3.4._
673      */
674     function functionDelegateCall(
675         address target,
676         bytes memory data,
677         string memory errorMessage
678     ) internal returns (bytes memory) {
679         require(isContract(target), "Address: delegate call to non-contract");
680 
681         (bool success, bytes memory returndata) = target.delegatecall(data);
682         return _verifyCallResult(success, returndata, errorMessage);
683     }
684 
685     function _verifyCallResult(
686         bool success,
687         bytes memory returndata,
688         string memory errorMessage
689     ) private pure returns (bytes memory) {
690         if (success) {
691             return returndata;
692         } else {
693             // Look for revert reason and bubble it up if present
694             if (returndata.length > 0) {
695                 // The easiest way to bubble the revert reason is using memory via assembly
696 
697                 assembly {
698                     let returndata_size := mload(returndata)
699                     revert(add(32, returndata), returndata_size)
700                 }
701             } else {
702                 revert(errorMessage);
703             }
704         }
705     }
706 }
707 
708 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
709 
710 pragma solidity ^0.8.0;
711 
712 /**
713  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
714  * @dev See https://eips.ethereum.org/EIPS/eip-721
715  */
716 interface IERC721Metadata is IERC721 {
717     /**
718      * @dev Returns the token collection name.
719      */
720     function name() external view returns (string memory);
721 
722     /**
723      * @dev Returns the token collection symbol.
724      */
725     function symbol() external view returns (string memory);
726 
727     /**
728      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
729      */
730     function tokenURI(uint256 tokenId) external view returns (string memory);
731 }
732 
733 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
734 
735 pragma solidity ^0.8.0;
736 
737 /**
738  * @title ERC721 token receiver interface
739  * @dev Interface for any contract that wants to support safeTransfers
740  * from ERC721 asset contracts.
741  */
742 interface IERC721Receiver {
743     /**
744      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
745      * by `operator` from `from`, this function is called.
746      *
747      * It must return its Solidity selector to confirm the token transfer.
748      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
749      *
750      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
751      */
752     function onERC721Received(
753         address operator,
754         address from,
755         uint256 tokenId,
756         bytes calldata data
757     ) external returns (bytes4);
758 }
759 
760 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
761 
762 pragma solidity ^0.8.0;
763 
764 /**
765  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
766  * the Metadata extension, but not including the Enumerable extension, which is available separately as
767  * {ERC721Enumerable}.
768  */
769 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
770     using Address for address;
771     using Strings for uint256;
772 
773     // Token name
774     string private _name;
775 
776     // Token symbol
777     string private _symbol;
778 
779     // Mapping from token ID to owner address
780     mapping(uint256 => address) private _owners;
781 
782     // Mapping owner address to token count
783     mapping(address => uint256) private _balances;
784 
785     // Mapping from token ID to approved address
786     mapping(uint256 => address) private _tokenApprovals;
787 
788     // Mapping from owner to operator approvals
789     mapping(address => mapping(address => bool)) private _operatorApprovals;
790 
791     /**
792      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
793      */
794     constructor(string memory name_, string memory symbol_) {
795         _name = name_;
796         _symbol = symbol_;
797     }
798 
799     /**
800      * @dev See {IERC165-supportsInterface}.
801      */
802     function supportsInterface(bytes4 interfaceId)
803         public
804         view
805         virtual
806         override(ERC165, IERC165)
807         returns (bool)
808     {
809         return
810             interfaceId == type(IERC721).interfaceId ||
811             interfaceId == type(IERC721Metadata).interfaceId ||
812             super.supportsInterface(interfaceId);
813     }
814 
815     /**
816      * @dev See {IERC721-balanceOf}.
817      */
818     function balanceOf(address owner)
819         public
820         view
821         virtual
822         override
823         returns (uint256)
824     {
825         require(
826             owner != address(0),
827             "ERC721: balance query for the zero address"
828         );
829         return _balances[owner];
830     }
831 
832     /**
833      * @dev See {IERC721-ownerOf}.
834      */
835     function ownerOf(uint256 tokenId)
836         public
837         view
838         virtual
839         override
840         returns (address)
841     {
842         address owner = _owners[tokenId];
843         require(
844             owner != address(0),
845             "ERC721: owner query for nonexistent token"
846         );
847         return owner;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-name}.
852      */
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-symbol}.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-tokenURI}.
866      */
867     function tokenURI(uint256 tokenId)
868         public
869         view
870         virtual
871         override
872         returns (string memory)
873     {
874         require(
875             _exists(tokenId),
876             "ERC721Metadata: URI query for nonexistent token"
877         );
878 
879         string memory baseURI = _baseURI();
880         return
881             bytes(baseURI).length > 0
882                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
883                 : "";
884     }
885 
886     /**
887      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
888      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
889      * by default, can be overriden in child contracts.
890      */
891     function _baseURI() internal view virtual returns (string memory) {
892         return "";
893     }
894 
895     /**
896      * @dev See {IERC721-approve}.
897      */
898     function approve(address to, uint256 tokenId) public virtual override {
899         address owner = ERC721.ownerOf(tokenId);
900         require(to != owner, "ERC721: approval to current owner");
901 
902         require(
903             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
904             "ERC721: approve caller is not owner nor approved for all"
905         );
906 
907         _approve(to, tokenId);
908     }
909 
910     /**
911      * @dev See {IERC721-getApproved}.
912      */
913     function getApproved(uint256 tokenId)
914         public
915         view
916         virtual
917         override
918         returns (address)
919     {
920         require(
921             _exists(tokenId),
922             "ERC721: approved query for nonexistent token"
923         );
924 
925         return _tokenApprovals[tokenId];
926     }
927 
928     /**
929      * @dev See {IERC721-setApprovalForAll}.
930      */
931     function setApprovalForAll(address operator, bool approved)
932         public
933         virtual
934         override
935     {
936         require(operator != _msgSender(), "ERC721: approve to caller");
937 
938         _operatorApprovals[_msgSender()][operator] = approved;
939         emit ApprovalForAll(_msgSender(), operator, approved);
940     }
941 
942     /**
943      * @dev See {IERC721-isApprovedForAll}.
944      */
945     function isApprovedForAll(address owner, address operator)
946         public
947         view
948         virtual
949         override
950         returns (bool)
951     {
952         return _operatorApprovals[owner][operator];
953     }
954 
955     /**
956      * @dev See {IERC721-transferFrom}.
957      */
958     function transferFrom(
959         address from,
960         address to,
961         uint256 tokenId
962     ) public virtual override {
963         //solhint-disable-next-line max-line-length
964         require(
965             _isApprovedOrOwner(_msgSender(), tokenId),
966             "ERC721: transfer caller is not owner nor approved"
967         );
968 
969         _transfer(from, to, tokenId);
970     }
971 
972     /**
973      * @dev See {IERC721-safeTransferFrom}.
974      */
975     function safeTransferFrom(
976         address from,
977         address to,
978         uint256 tokenId
979     ) public virtual override {
980         safeTransferFrom(from, to, tokenId, "");
981     }
982 
983     /**
984      * @dev See {IERC721-safeTransferFrom}.
985      */
986     function safeTransferFrom(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes memory _data
991     ) public virtual override {
992         require(
993             _isApprovedOrOwner(_msgSender(), tokenId),
994             "ERC721: transfer caller is not owner nor approved"
995         );
996         _safeTransfer(from, to, tokenId, _data);
997     }
998 
999     /**
1000      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1001      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1002      *
1003      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1004      *
1005      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1006      * implement alternative mechanisms to perform token transfer, such as signature-based.
1007      *
1008      * Requirements:
1009      *
1010      * - `from` cannot be the zero address.
1011      * - `to` cannot be the zero address.
1012      * - `tokenId` token must exist and be owned by `from`.
1013      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _safeTransfer(
1018         address from,
1019         address to,
1020         uint256 tokenId,
1021         bytes memory _data
1022     ) internal virtual {
1023         _transfer(from, to, tokenId);
1024         require(
1025             _checkOnERC721Received(from, to, tokenId, _data),
1026             "ERC721: transfer to non ERC721Receiver implementer"
1027         );
1028     }
1029 
1030     /**
1031      * @dev Returns whether `tokenId` exists.
1032      *
1033      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1034      *
1035      * Tokens start existing when they are minted (`_mint`),
1036      * and stop existing when they are burned (`_burn`).
1037      */
1038     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1039         return _owners[tokenId] != address(0);
1040     }
1041 
1042     /**
1043      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1044      *
1045      * Requirements:
1046      *
1047      * - `tokenId` must exist.
1048      */
1049     function _isApprovedOrOwner(address spender, uint256 tokenId)
1050         internal
1051         view
1052         virtual
1053         returns (bool)
1054     {
1055         require(
1056             _exists(tokenId),
1057             "ERC721: operator query for nonexistent token"
1058         );
1059         address owner = ERC721.ownerOf(tokenId);
1060         return (spender == owner ||
1061             getApproved(tokenId) == spender ||
1062             isApprovedForAll(owner, spender));
1063     }
1064 
1065     /**
1066      * @dev Safely mints `tokenId` and transfers it to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - `tokenId` must not exist.
1071      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _safeMint(address to, uint256 tokenId) internal virtual {
1076         _safeMint(to, tokenId, "");
1077     }
1078 
1079     /**
1080      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1081      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1082      */
1083     function _safeMint(
1084         address to,
1085         uint256 tokenId,
1086         bytes memory _data
1087     ) internal virtual {
1088         _mint(to, tokenId);
1089         require(
1090             _checkOnERC721Received(address(0), to, tokenId, _data),
1091             "ERC721: transfer to non ERC721Receiver implementer"
1092         );
1093     }
1094 
1095     /**
1096      * @dev Mints `tokenId` and transfers it to `to`.
1097      *
1098      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1099      *
1100      * Requirements:
1101      *
1102      * - `tokenId` must not exist.
1103      * - `to` cannot be the zero address.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _mint(address to, uint256 tokenId) internal virtual {
1108         require(to != address(0), "ERC721: mint to the zero address");
1109         require(!_exists(tokenId), "ERC721: token already minted");
1110 
1111         _beforeTokenTransfer(address(0), to, tokenId);
1112 
1113         _balances[to] += 1;
1114         _owners[tokenId] = to;
1115 
1116         emit Transfer(address(0), to, tokenId);
1117     }
1118 
1119     /**
1120      * @dev Destroys `tokenId`.
1121      * The approval is cleared when the token is burned.
1122      *
1123      * Requirements:
1124      *
1125      * - `tokenId` must exist.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _burn(uint256 tokenId) internal virtual {
1130         address owner = ERC721.ownerOf(tokenId);
1131 
1132         _beforeTokenTransfer(owner, address(0), tokenId);
1133 
1134         // Clear approvals
1135         _approve(address(0), tokenId);
1136 
1137         _balances[owner] -= 1;
1138         delete _owners[tokenId];
1139 
1140         emit Transfer(owner, address(0), tokenId);
1141     }
1142 
1143     /**
1144      * @dev Transfers `tokenId` from `from` to `to`.
1145      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1146      *
1147      * Requirements:
1148      *
1149      * - `to` cannot be the zero address.
1150      * - `tokenId` token must be owned by `from`.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _transfer(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) internal virtual {
1159         require(
1160             ERC721.ownerOf(tokenId) == from,
1161             "ERC721: transfer of token that is not own"
1162         );
1163         require(to != address(0), "ERC721: transfer to the zero address");
1164 
1165         _beforeTokenTransfer(from, to, tokenId);
1166 
1167         // Clear approvals from the previous owner
1168         _approve(address(0), tokenId);
1169 
1170         _balances[from] -= 1;
1171         _balances[to] += 1;
1172         _owners[tokenId] = to;
1173 
1174         emit Transfer(from, to, tokenId);
1175     }
1176 
1177     /**
1178      * @dev Approve `to` to operate on `tokenId`
1179      *
1180      * Emits a {Approval} event.
1181      */
1182     function _approve(address to, uint256 tokenId) internal virtual {
1183         _tokenApprovals[tokenId] = to;
1184         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1185     }
1186 
1187     /**
1188      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1189      * The call is not executed if the target address is not a contract.
1190      *
1191      * @param from address representing the previous owner of the given token ID
1192      * @param to target address that will receive the tokens
1193      * @param tokenId uint256 ID of the token to be transferred
1194      * @param _data bytes optional data to send along with the call
1195      * @return bool whether the call correctly returned the expected magic value
1196      */
1197     function _checkOnERC721Received(
1198         address from,
1199         address to,
1200         uint256 tokenId,
1201         bytes memory _data
1202     ) private returns (bool) {
1203         if (to.isContract()) {
1204             try
1205                 IERC721Receiver(to).onERC721Received(
1206                     _msgSender(),
1207                     from,
1208                     tokenId,
1209                     _data
1210                 )
1211             returns (bytes4 retval) {
1212                 return retval == IERC721Receiver(to).onERC721Received.selector;
1213             } catch (bytes memory reason) {
1214                 if (reason.length == 0) {
1215                     revert(
1216                         "ERC721: transfer to non ERC721Receiver implementer"
1217                     );
1218                 } else {
1219                     assembly {
1220                         revert(add(32, reason), mload(reason))
1221                     }
1222                 }
1223             }
1224         } else {
1225             return true;
1226         }
1227     }
1228 
1229     /**
1230      * @dev Hook that is called before any token transfer. This includes minting
1231      * and burning.
1232      *
1233      * Calling conditions:
1234      *
1235      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1236      * transferred to `to`.
1237      * - When `from` is zero, `tokenId` will be minted for `to`.
1238      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1239      * - `from` and `to` are never both zero.
1240      *
1241      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1242      */
1243     function _beforeTokenTransfer(
1244         address from,
1245         address to,
1246         uint256 tokenId
1247     ) internal virtual {}
1248 }
1249 
1250 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1251 
1252 pragma solidity ^0.8.0;
1253 
1254 /**
1255  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1256  * enumerability of all the token ids in the contract as well as all token ids owned by each
1257  * account.
1258  */
1259 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1260     // Mapping from owner to list of owned token IDs
1261     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1262 
1263     // Mapping from token ID to index of the owner tokens list
1264     mapping(uint256 => uint256) private _ownedTokensIndex;
1265 
1266     // Array with all token ids, used for enumeration
1267     uint256[] private _allTokens;
1268 
1269     // Mapping from token id to position in the allTokens array
1270     mapping(uint256 => uint256) private _allTokensIndex;
1271 
1272     /**
1273      * @dev See {IERC165-supportsInterface}.
1274      */
1275     function supportsInterface(bytes4 interfaceId)
1276         public
1277         view
1278         virtual
1279         override(IERC165, ERC721)
1280         returns (bool)
1281     {
1282         return
1283             interfaceId == type(IERC721Enumerable).interfaceId ||
1284             super.supportsInterface(interfaceId);
1285     }
1286 
1287     /**
1288      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1289      */
1290     function tokenOfOwnerByIndex(address owner, uint256 index)
1291         public
1292         view
1293         virtual
1294         override
1295         returns (uint256)
1296     {
1297         require(
1298             index < ERC721.balanceOf(owner),
1299             "ERC721Enumerable: owner index out of bounds"
1300         );
1301         return _ownedTokens[owner][index];
1302     }
1303 
1304     /**
1305      * @dev See {IERC721Enumerable-totalSupply}.
1306      */
1307     function totalSupply() public view virtual override returns (uint256) {
1308         return _allTokens.length;
1309     }
1310 
1311     /**
1312      * @dev See {IERC721Enumerable-tokenByIndex}.
1313      */
1314     function tokenByIndex(uint256 index)
1315         public
1316         view
1317         virtual
1318         override
1319         returns (uint256)
1320     {
1321         require(
1322             index < ERC721Enumerable.totalSupply(),
1323             "ERC721Enumerable: global index out of bounds"
1324         );
1325         return _allTokens[index];
1326     }
1327 
1328     /**
1329      * @dev Hook that is called before any token transfer. This includes minting
1330      * and burning.
1331      *
1332      * Calling conditions:
1333      *
1334      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1335      * transferred to `to`.
1336      * - When `from` is zero, `tokenId` will be minted for `to`.
1337      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1338      * - `from` cannot be the zero address.
1339      * - `to` cannot be the zero address.
1340      *
1341      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1342      */
1343     function _beforeTokenTransfer(
1344         address from,
1345         address to,
1346         uint256 tokenId
1347     ) internal virtual override {
1348         super._beforeTokenTransfer(from, to, tokenId);
1349 
1350         if (from == address(0)) {
1351             _addTokenToAllTokensEnumeration(tokenId);
1352         } else if (from != to) {
1353             _removeTokenFromOwnerEnumeration(from, tokenId);
1354         }
1355         if (to == address(0)) {
1356             _removeTokenFromAllTokensEnumeration(tokenId);
1357         } else if (to != from) {
1358             _addTokenToOwnerEnumeration(to, tokenId);
1359         }
1360     }
1361 
1362     /**
1363      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1364      * @param to address representing the new owner of the given token ID
1365      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1366      */
1367     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1368         uint256 length = ERC721.balanceOf(to);
1369         _ownedTokens[to][length] = tokenId;
1370         _ownedTokensIndex[tokenId] = length;
1371     }
1372 
1373     /**
1374      * @dev Private function to add a token to this extension's token tracking data structures.
1375      * @param tokenId uint256 ID of the token to be added to the tokens list
1376      */
1377     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1378         _allTokensIndex[tokenId] = _allTokens.length;
1379         _allTokens.push(tokenId);
1380     }
1381 
1382     /**
1383      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1384      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1385      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1386      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1387      * @param from address representing the previous owner of the given token ID
1388      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1389      */
1390     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1391         private
1392     {
1393         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1394         // then delete the last slot (swap and pop).
1395 
1396         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1397         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1398 
1399         // When the token to delete is the last token, the swap operation is unnecessary
1400         if (tokenIndex != lastTokenIndex) {
1401             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1402 
1403             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1404             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1405         }
1406 
1407         // This also deletes the contents at the last position of the array
1408         delete _ownedTokensIndex[tokenId];
1409         delete _ownedTokens[from][lastTokenIndex];
1410     }
1411 
1412     /**
1413      * @dev Private function to remove a token from this extension's token tracking data structures.
1414      * This has O(1) time complexity, but alters the order of the _allTokens array.
1415      * @param tokenId uint256 ID of the token to be removed from the tokens list
1416      */
1417     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1418         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1419         // then delete the last slot (swap and pop).
1420 
1421         uint256 lastTokenIndex = _allTokens.length - 1;
1422         uint256 tokenIndex = _allTokensIndex[tokenId];
1423 
1424         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1425         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1426         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1427         uint256 lastTokenId = _allTokens[lastTokenIndex];
1428 
1429         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1430         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1431 
1432         // This also deletes the contents at the last position of the array
1433         delete _allTokensIndex[tokenId];
1434         _allTokens.pop();
1435     }
1436 }
1437 
1438 // SPDX-License-Identifier: MIT
1439 pragma solidity ^0.8.4;
1440 
1441 /*
1442  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄            ▄            ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄ 
1443 ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌          ▐░▌          ▐░░░░░░░░░░░▌▐░▌       ▐░▌
1444 ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░▌          ▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌
1445 ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌
1446 ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌   ▄   ▐░▌
1447 ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌
1448 ▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌ ▐░▌░▌ ▐░▌
1449 ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌▐░▌ ▐░▌▐░▌
1450 ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░▌░▌   ▐░▐░▌
1451 ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌
1452  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀       ▀▀ 
1453                                                                                                       
1454                                By Devko.dev#7286 
1455 */
1456 
1457 
1458 contract Hollow is ERC721Enumerable, Ownable {
1459     using Strings for uint256;
1460 
1461     uint256 public constant HOLO_PRIVATE = 3000;
1462     uint256 public constant HOLO_PUBLIC = 7000;
1463     uint256 public constant HOLO_MAX =  HOLO_PRIVATE + HOLO_PUBLIC;
1464     uint256 public constant HOLO_PRICE = 0.08 ether;
1465     uint256 public constant HOLO_PER_PUBLIC_MINT = 5;
1466     uint256 public constant HOLO_PER_PRIVATE_MINT = 4;
1467     mapping(address => bool) public presalerList;
1468     mapping(address => uint256) public presalerListPurchases;
1469     string private _contractURI = "https://gateway.pinata.cloud/ipfs/QmaC4DXdS5xRULMmQV7nF2Noedbdpnd5Loyzk7RsK6qZZh";
1470     string private _tokenBaseURI = "https://gateway.pinata.cloud/ipfs/QmSK5jJS8AoAMqXY6L6rL9BKQ6WAVgzyNTNpT712F717UK/";
1471     address private member1 = 0x4D61376f414eD7FFcb6Fb698a36BD73fB909E368; // Yatin
1472     address private member2 = 0x0000064a362bDaf19B859b5fC829116DfB13ca30; // Devko
1473     uint256 public privateAmountMinted;
1474     uint256 public presalePurchaseLimit = 4;
1475     bool public presaleLive;
1476     bool public saleLive;
1477     bool public locked;
1478     
1479     constructor() ERC721("Hollow", "HOLO") {}
1480     
1481     modifier notLocked {
1482         require(!locked, "Contract metadata methods are locked");
1483         _;
1484     }
1485     
1486     function addToPresaleList(address[] calldata entries) external onlyOwner {
1487         for(uint256 i = 0; i < entries.length; i++) {
1488             address entry = entries[i];
1489             require(entry != address(0), "NULL_ADDRESS");
1490             require(!presalerList[entry], "DUPLICATE_ENTRY");
1491             presalerList[entry] = true;
1492         }   
1493     }
1494 
1495     function removeFromPresaleList(address[] calldata entries) external onlyOwner {
1496         for(uint256 i = 0; i < entries.length; i++) {
1497             address entry = entries[i];
1498             require(entry != address(0), "NULL_ADDRESS");
1499             
1500             presalerList[entry] = false;
1501         }
1502     }
1503 
1504     function founderMint(uint256 tokenQuantity) external onlyOwner {
1505         require(totalSupply() + tokenQuantity <= HOLO_MAX, "EXCEED_MAX");
1506         
1507         for(uint256 i = 0; i < tokenQuantity; i++) {
1508             _safeMint(msg.sender, totalSupply() + 1);
1509         }
1510     }
1511     function buy(uint256 tokenQuantity) external payable {
1512         require(saleLive, "SALE_CLOSED");
1513         require(!presaleLive, "ONLY_PRESALE");
1514         require(totalSupply() + tokenQuantity <= HOLO_MAX, "EXCEED_MAX");
1515         require(tokenQuantity <= HOLO_PER_PUBLIC_MINT, "EXCEED_HOLO_PER_PUBLIC_MINT");
1516         require(HOLO_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1517         
1518         for(uint256 i = 0; i < tokenQuantity; i++) {
1519             _safeMint(msg.sender, totalSupply() + 1);
1520         }
1521         
1522         
1523     }
1524     
1525     function presaleBuy(uint256 tokenQuantity) external payable {
1526         require(!saleLive && presaleLive, "PRESALE_CLOSED");
1527         require(presalerList[msg.sender], "NOT_QUALIFIED");
1528         require(privateAmountMinted + tokenQuantity <= HOLO_PRIVATE, "EXCEED_PRIVATE");
1529         require(tokenQuantity <= HOLO_PER_PRIVATE_MINT, "EXCEED_HOLO_PER_PRIVATE_MINT");
1530         require(presalerListPurchases[msg.sender] + tokenQuantity <= presalePurchaseLimit, "EXCEED_ALLOC");
1531         require(HOLO_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1532         
1533         for (uint256 i = 0; i < tokenQuantity; i++) {
1534             privateAmountMinted++;
1535             presalerListPurchases[msg.sender]++;
1536             _safeMint(msg.sender, totalSupply() + 1);
1537         }
1538     }
1539 
1540     function withdraw() external {
1541         payable(member2).transfer(address(this).balance / 10);
1542         payable(member1).transfer(address(this).balance);
1543     }
1544     
1545     function isPresaler(address addr) external view returns (bool) {
1546         return presalerList[addr];
1547     }
1548     
1549     function presalePurchasedCount(address addr) external view returns (uint256) {
1550         return presalerListPurchases[addr];
1551     }
1552 
1553     function lockMetadata() external onlyOwner {
1554         locked = true;
1555     }
1556     
1557     function togglePresaleStatus() external onlyOwner {
1558         presaleLive = !presaleLive;
1559     }
1560     
1561     function toggleSaleStatus() external onlyOwner {
1562         saleLive = !saleLive;
1563     }
1564     
1565     function setContractURI(string calldata URI) external onlyOwner notLocked {
1566         _contractURI = URI;
1567     }
1568     
1569     function setBaseURI(string calldata URI) external onlyOwner notLocked {
1570         _tokenBaseURI = URI;
1571     }
1572 
1573     function contractURI() public view returns (string memory) {
1574         return _contractURI;
1575     }
1576     
1577     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1578         require(_exists(tokenId), "Cannot query non-existent token");
1579         
1580         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1581     }
1582 }