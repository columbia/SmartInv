1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.8.0 <0.9.0;
4 pragma experimental ABIEncoderV2;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 
28 /**
29  * @dev String operations.
30  */
31 library Strings {
32     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
33 
34     /**
35      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
36      */
37     function toString(uint256 value) internal pure returns (string memory) {
38         // Inspired by OraclizeAPI's implementation - MIT licence
39         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
40 
41         if (value == 0) {
42             return "0";
43         }
44         uint256 temp = value;
45         uint256 digits;
46         while (temp != 0) {
47             digits++;
48             temp /= 10;
49         }
50         bytes memory buffer = new bytes(digits);
51         while (value != 0) {
52             digits -= 1;
53             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
54             value /= 10;
55         }
56         return string(buffer);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
61      */
62     function toHexString(uint256 value) internal pure returns (string memory) {
63         if (value == 0) {
64             return "0x00";
65         }
66         uint256 temp = value;
67         uint256 length = 0;
68         while (temp != 0) {
69             length++;
70             temp >>= 8;
71         }
72         return toHexString(value, length);
73     }
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
77      */
78     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
79         bytes memory buffer = new bytes(2 * length + 2);
80         buffer[0] = "0";
81         buffer[1] = "x";
82         for (uint256 i = 2 * length + 1; i > 1; --i) {
83             buffer[i] = _HEX_SYMBOLS[value & 0xf];
84             value >>= 4;
85         }
86         require(value == 0, "Strings: hex length insufficient");
87         return string(buffer);
88     }
89 }
90 
91 
92 library Counters {
93     struct Counter {
94         // This variable should never be directly accessed by users of the library: interactions must be restricted to
95         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
96         // this feature: see https://github.com/ethereum/solidity/issues/4637
97         uint256 _value; // default: 0
98     }
99 
100     function current(Counter storage counter) internal view returns (uint256) {
101         return counter._value;
102     }
103 
104     function increment(Counter storage counter) internal {
105         unchecked {
106             counter._value += 1;
107         }
108     }
109 
110     function decrement(Counter storage counter) internal {
111         uint256 value = counter._value;
112         require(value > 0, "Counter: decrement overflow");
113         unchecked {
114             counter._value = value - 1;
115         }
116     }
117 
118     function reset(Counter storage counter) internal {
119         counter._value = 0;
120     }
121 }
122 
123 
124 
125 /**
126  * @dev Collection of functions related to the address type
127  */
128 library Address {
129     /**
130      * @dev Returns true if `account` is a contract.
131      *
132      * [IMPORTANT]
133      * ====
134      * It is unsafe to assume that an address for which this function returns
135      * false is an externally-owned account (EOA) and not a contract.
136      *
137      * Among others, `isContract` will return false for the following
138      * types of addresses:
139      *
140      *  - an externally-owned account
141      *  - a contract in construction
142      *  - an address where a contract will be created
143      *  - an address where a contract lived, but was destroyed
144      * ====
145      */
146     function isContract(address account) internal view returns (bool) {
147         // This method relies on extcodesize, which returns 0 for contracts in
148         // construction, since the code is only stored at the end of the
149         // constructor execution.
150 
151         uint256 size;
152         assembly {
153             size := extcodesize(account)
154         }
155         return size > 0;
156     }
157 
158     /**
159      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
160      * `recipient`, forwarding all available gas and reverting on errors.
161      *
162      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
163      * of certain opcodes, possibly making contracts go over the 2300 gas limit
164      * imposed by `transfer`, making them unable to receive funds via
165      * `transfer`. {sendValue} removes this limitation.
166      *
167      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
168      *
169      * IMPORTANT: because control is transferred to `recipient`, care must be
170      * taken to not create reentrancy vulnerabilities. Consider using
171      * {ReentrancyGuard} or the
172      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
173      */
174     function sendValue(address payable recipient, uint256 amount) internal {
175         require(address(this).balance >= amount, "Address: insufficient balance");
176 
177         (bool success, ) = recipient.call{value: amount}("");
178         require(success, "Address: unable to send value, recipient may have reverted");
179     }
180 
181     /**
182      * @dev Performs a Solidity function call using a low level `call`. A
183      * plain `call` is an unsafe replacement for a function call: use this
184      * function instead.
185      *
186      * If `target` reverts with a revert reason, it is bubbled up by this
187      * function (like regular Solidity function calls).
188      *
189      * Returns the raw returned data. To convert to the expected return value,
190      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
191      *
192      * Requirements:
193      *
194      * - `target` must be a contract.
195      * - calling `target` with `data` must not revert.
196      *
197      * _Available since v3.1._
198      */
199     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
200         return functionCall(target, data, "Address: low-level call failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
205      * `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCall(
210         address target,
211         bytes memory data,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         return functionCallWithValue(target, data, 0, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but also transferring `value` wei to `target`.
220      *
221      * Requirements:
222      *
223      * - the calling contract must have an ETH balance of at least `value`.
224      * - the called Solidity function must be `payable`.
225      *
226      * _Available since v3.1._
227      */
228     function functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 value
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
238      * with `errorMessage` as a fallback revert reason when `target` reverts.
239      *
240      * _Available since v3.1._
241      */
242     function functionCallWithValue(
243         address target,
244         bytes memory data,
245         uint256 value,
246         string memory errorMessage
247     ) internal returns (bytes memory) {
248         require(address(this).balance >= value, "Address: insufficient balance for call");
249         require(isContract(target), "Address: call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.call{value: value}(data);
252         return verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but performing a static call.
258      *
259      * _Available since v3.3._
260      */
261     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
262         return functionStaticCall(target, data, "Address: low-level static call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
267      * but performing a static call.
268      *
269      * _Available since v3.3._
270      */
271     function functionStaticCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal view returns (bytes memory) {
276         require(isContract(target), "Address: static call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.staticcall(data);
279         return verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but performing a delegate call.
285      *
286      * _Available since v3.4._
287      */
288     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
289         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
294      * but performing a delegate call.
295      *
296      * _Available since v3.4._
297      */
298     function functionDelegateCall(
299         address target,
300         bytes memory data,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         require(isContract(target), "Address: delegate call to non-contract");
304 
305         (bool success, bytes memory returndata) = target.delegatecall(data);
306         return verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
311      * revert reason using the provided one.
312      *
313      * _Available since v4.3._
314      */
315     function verifyCallResult(
316         bool success,
317         bytes memory returndata,
318         string memory errorMessage
319     ) internal pure returns (bytes memory) {
320         if (success) {
321             return returndata;
322         } else {
323             // Look for revert reason and bubble it up if present
324             if (returndata.length > 0) {
325                 // The easiest way to bubble the revert reason is using memory via assembly
326 
327                 assembly {
328                     let returndata_size := mload(returndata)
329                     revert(add(32, returndata), returndata_size)
330                 }
331             } else {
332                 revert(errorMessage);
333             }
334         }
335     }
336 }
337 
338 /**
339  * @dev Required interface of an ERC721 compliant contract.
340  */
341 interface IERC721 is IERC165 {
342     /**
343      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
344      */
345     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
346 
347     /**
348      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
349      */
350     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
351 
352     /**
353      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
354      */
355     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
356 
357     /**
358      * @dev Returns the number of tokens in ``owner``'s account.
359      */
360     function balanceOf(address owner) external view returns (uint256 balance);
361 
362     /**
363      * @dev Returns the owner of the `tokenId` token.
364      *
365      * Requirements:
366      *
367      * - `tokenId` must exist.
368      */
369     function ownerOf(uint256 tokenId) external view returns (address owner);
370 
371     /**
372      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
373      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
374      *
375      * Requirements:
376      *
377      * - `from` cannot be the zero address.
378      * - `to` cannot be the zero address.
379      * - `tokenId` token must exist and be owned by `from`.
380      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
381      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
382      *
383      * Emits a {Transfer} event.
384      */
385     function safeTransferFrom(
386         address from,
387         address to,
388         uint256 tokenId
389     ) external;
390 
391     /**
392      * @dev Transfers `tokenId` token from `from` to `to`.
393      *
394      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
395      *
396      * Requirements:
397      *
398      * - `from` cannot be the zero address.
399      * - `to` cannot be the zero address.
400      * - `tokenId` token must be owned by `from`.
401      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
402      *
403      * Emits a {Transfer} event.
404      */
405     function transferFrom(
406         address from,
407         address to,
408         uint256 tokenId
409     ) external;
410 
411     /**
412      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
413      * The approval is cleared when the token is transferred.
414      *
415      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
416      *
417      * Requirements:
418      *
419      * - The caller must own the token or be an approved operator.
420      * - `tokenId` must exist.
421      *
422      * Emits an {Approval} event.
423      */
424     function approve(address to, uint256 tokenId) external;
425 
426     /**
427      * @dev Returns the account approved for `tokenId` token.
428      *
429      * Requirements:
430      *
431      * - `tokenId` must exist.
432      */
433     function getApproved(uint256 tokenId) external view returns (address operator);
434 
435     /**
436      * @dev Approve or remove `operator` as an operator for the caller.
437      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
438      *
439      * Requirements:
440      *
441      * - The `operator` cannot be the caller.
442      *
443      * Emits an {ApprovalForAll} event.
444      */
445     function setApprovalForAll(address operator, bool _approved) external;
446 
447     /**
448      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
449      *
450      * See {setApprovalForAll}
451      */
452     function isApprovedForAll(address owner, address operator) external view returns (bool);
453 
454     /**
455      * @dev Safely transfers `tokenId` token from `from` to `to`.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `tokenId` token must exist and be owned by `from`.
462      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
463      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
464      *
465      * Emits a {Transfer} event.
466      */
467     function safeTransferFrom(
468         address from,
469         address to,
470         uint256 tokenId,
471         bytes calldata data
472     ) external;
473 }
474 
475 
476 /**
477  * @dev Implementation of the {IERC165} interface.
478  *
479  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
480  * for the additional interface id that will be supported. For example:
481  *
482  * ```solidity
483  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
484  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
485  * }
486  * ```
487  *
488  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
489  */
490 abstract contract ERC165 is IERC165 {
491     /**
492      * @dev See {IERC165-supportsInterface}.
493      */
494     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
495         return interfaceId == type(IERC165).interfaceId;
496     }
497 }
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Metadata is IERC721 {
504     /**
505      * @dev Returns the token collection name.
506      */
507     function name() external view returns (string memory);
508 
509     /**
510      * @dev Returns the token collection symbol.
511      */
512     function symbol() external view returns (string memory);
513 
514     /**
515      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
516      */
517     function tokenURI(uint256 tokenId) external view returns (string memory);
518 }
519 
520 /**
521  * @dev Provides information about the current execution context, including the
522  * sender of the transaction and its data. While these are generally available
523  * via msg.sender and msg.data, they should not be accessed in such a direct
524  * manner, since when dealing with meta-transactions the account sending and
525  * paying for execution may not be the actual sender (as far as an application
526  * is concerned).
527  *
528  * This contract is only required for intermediate, library-like contracts.
529  */
530 abstract contract Context {
531     function _msgSender() internal view virtual returns (address) {
532         return msg.sender;
533     }
534 
535     function _msgData() internal view virtual returns (bytes calldata) {
536         return msg.data;
537     }
538 }
539 
540 
541 /**
542  * @title ERC721 token receiver interface
543  * @dev Interface for any contract that wants to support safeTransfers
544  * from ERC721 asset contracts.
545  */
546 interface IERC721Receiver {
547     /**
548      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
549      * by `operator` from `from`, this function is called.
550      *
551      * It must return its Solidity selector to confirm the token transfer.
552      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
553      *
554      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
555      */
556     function onERC721Received(
557         address operator,
558         address from,
559         uint256 tokenId,
560         bytes calldata data
561     ) external returns (bytes4);
562 }
563 
564 
565 /**
566  * @dev Contract module which provides a basic access control mechanism, where
567  * there is an account (an owner) that can be granted exclusive access to
568  * specific functions.
569  *
570  * By default, the owner account will be the one that deploys the contract. This
571  * can later be changed with {transferOwnership}.
572  *
573  * This module is used through inheritance. It will make available the modifier
574  * `onlyOwner`, which can be applied to your functions to restrict their use to
575  * the owner.
576  */
577 abstract contract Ownable is Context {
578     address private _owner;
579 
580     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
581 
582     /**
583      * @dev Initializes the contract setting the deployer as the initial owner.
584      */
585     constructor() {
586         _setOwner(_msgSender());
587     }
588 
589     /**
590      * @dev Returns the address of the current owner.
591      */
592     function owner() public view virtual returns (address) {
593         return _owner;
594     }
595 
596     /**
597      * @dev Throws if called by any account other than the owner.
598      */
599     modifier onlyOwner() {
600         require(owner() == _msgSender(), "Ownable: caller is not the owner");
601         _;
602     }
603 
604     /**
605      * @dev Leaves the contract without owner. It will not be possible to call
606      * `onlyOwner` functions anymore. Can only be called by the current owner.
607      *
608      * NOTE: Renouncing ownership will leave the contract without an owner,
609      * thereby removing any functionality that is only available to the owner.
610      */
611     function renounceOwnership() public virtual onlyOwner {
612         _setOwner(address(0));
613     }
614 
615     /**
616      * @dev Transfers ownership of the contract to a new account (`newOwner`).
617      * Can only be called by the current owner.
618      */
619     function transferOwnership(address newOwner) public virtual onlyOwner {
620         require(newOwner != address(0), "Ownable: new owner is the zero address");
621         _setOwner(newOwner);
622     }
623 
624     function _setOwner(address newOwner) private {
625         address oldOwner = _owner;
626         _owner = newOwner;
627         emit OwnershipTransferred(oldOwner, newOwner);
628     }
629 }
630 
631 
632 /**
633  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
634  * the Metadata extension, but not including the Enumerable extension, which is available separately as
635  * {ERC721Enumerable}.
636  */
637 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
638     using Address for address;
639     using Strings for uint256;
640 
641     // Token name
642     string private _name;
643 
644     // Token symbol
645     string private _symbol;
646 
647     // Mapping from token ID to owner address
648     mapping(uint256 => address) private _owners;
649 
650     // Mapping owner address to token count
651     mapping(address => uint256) private _balances;
652 
653     // Mapping from token ID to approved address
654     mapping(uint256 => address) private _tokenApprovals;
655 
656     // Mapping from owner to operator approvals
657     mapping(address => mapping(address => bool)) private _operatorApprovals;
658 
659     /**
660      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
661      */
662     constructor(string memory name_, string memory symbol_) {
663         _name = name_;
664         _symbol = symbol_;
665     }
666 
667     /**
668      * @dev See {IERC165-supportsInterface}.
669      */
670     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
671         return
672             interfaceId == type(IERC721).interfaceId ||
673             interfaceId == type(IERC721Metadata).interfaceId ||
674             super.supportsInterface(interfaceId);
675     }
676 
677     /**
678      * @dev See {IERC721-balanceOf}.
679      */
680     function balanceOf(address owner) public view virtual override returns (uint256) {
681         require(owner != address(0), "ERC721: balance query for the zero address");
682         return _balances[owner];
683     }
684 
685     /**
686      * @dev See {IERC721-ownerOf}.
687      */
688     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
689         address owner = _owners[tokenId];
690         require(owner != address(0), "ERC721: owner query for nonexistent token");
691         return owner;
692     }
693 
694     /**
695      * @dev See {IERC721Metadata-name}.
696      */
697     function name() public view virtual override returns (string memory) {
698         return _name;
699     }
700 
701     /**
702      * @dev See {IERC721Metadata-symbol}.
703      */
704     function symbol() public view virtual override returns (string memory) {
705         return _symbol;
706     }
707 
708     /**
709      * @dev See {IERC721Metadata-tokenURI}.
710      */
711     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
712         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
713 
714         string memory baseURI = _baseURI();
715         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
716     }
717 
718     /**
719      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
720      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
721      * by default, can be overriden in child contracts.
722      */
723     function _baseURI() internal view virtual returns (string memory) {
724         return "";
725     }
726 
727     /**
728      * @dev See {IERC721-approve}.
729      */
730     function approve(address to, uint256 tokenId) public virtual override {
731         address owner = ERC721.ownerOf(tokenId);
732         require(to != owner, "ERC721: approval to current owner");
733 
734         require(
735             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
736             "ERC721: approve caller is not owner nor approved for all"
737         );
738 
739         _approve(to, tokenId);
740     }
741 
742     /**
743      * @dev See {IERC721-getApproved}.
744      */
745     function getApproved(uint256 tokenId) public view virtual override returns (address) {
746         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
747 
748         return _tokenApprovals[tokenId];
749     }
750 
751     /**
752      * @dev See {IERC721-setApprovalForAll}.
753      */
754     function setApprovalForAll(address operator, bool approved) public virtual override {
755         require(operator != _msgSender(), "ERC721: approve to caller");
756 
757         _operatorApprovals[_msgSender()][operator] = approved;
758         emit ApprovalForAll(_msgSender(), operator, approved);
759     }
760 
761     /**
762      * @dev See {IERC721-isApprovedForAll}.
763      */
764     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
765         return _operatorApprovals[owner][operator];
766     }
767 
768     /**
769      * @dev See {IERC721-transferFrom}.
770      */
771     function transferFrom(
772         address from,
773         address to,
774         uint256 tokenId
775     ) public virtual override {
776         //solhint-disable-next-line max-line-length
777         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
778 
779         _transfer(from, to, tokenId);
780     }
781 
782     /**
783      * @dev See {IERC721-safeTransferFrom}.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) public virtual override {
790         safeTransferFrom(from, to, tokenId, "");
791     }
792 
793     /**
794      * @dev See {IERC721-safeTransferFrom}.
795      */
796     function safeTransferFrom(
797         address from,
798         address to,
799         uint256 tokenId,
800         bytes memory _data
801     ) public virtual override {
802         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
803         _safeTransfer(from, to, tokenId, _data);
804     }
805 
806     /**
807      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
808      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
809      *
810      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
811      *
812      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
813      * implement alternative mechanisms to perform token transfer, such as signature-based.
814      *
815      * Requirements:
816      *
817      * - `from` cannot be the zero address.
818      * - `to` cannot be the zero address.
819      * - `tokenId` token must exist and be owned by `from`.
820      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _safeTransfer(
825         address from,
826         address to,
827         uint256 tokenId,
828         bytes memory _data
829     ) internal virtual {
830         _transfer(from, to, tokenId);
831         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
832     }
833 
834     /**
835      * @dev Returns whether `tokenId` exists.
836      *
837      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
838      *
839      * Tokens start existing when they are minted (`_mint`),
840      * and stop existing when they are burned (`_burn`).
841      */
842     function _exists(uint256 tokenId) internal view virtual returns (bool) {
843         return _owners[tokenId] != address(0);
844     }
845 
846     /**
847      * @dev Returns whether `spender` is allowed to manage `tokenId`.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must exist.
852      */
853     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
854         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
855         address owner = ERC721.ownerOf(tokenId);
856         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
857     }
858 
859     /**
860      * @dev Safely mints `tokenId` and transfers it to `to`.
861      *
862      * Requirements:
863      *
864      * - `tokenId` must not exist.
865      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _safeMint(address to, uint256 tokenId) internal virtual {
870         _safeMint(to, tokenId, "");
871     }
872 
873     /**
874      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
875      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
876      */
877     function _safeMint(
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) internal virtual {
882         _mint(to, tokenId);
883         require(
884             _checkOnERC721Received(address(0), to, tokenId, _data),
885             "ERC721: transfer to non ERC721Receiver implementer"
886         );
887     }
888 
889     /**
890      * @dev Mints `tokenId` and transfers it to `to`.
891      *
892      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
893      *
894      * Requirements:
895      *
896      * - `tokenId` must not exist.
897      * - `to` cannot be the zero address.
898      *
899      * Emits a {Transfer} event.
900      */
901     function _mint(address to, uint256 tokenId) internal virtual {
902         require(to != address(0), "ERC721: mint to the zero address");
903         require(!_exists(tokenId), "ERC721: token already minted");
904 
905         _beforeTokenTransfer(address(0), to, tokenId);
906 
907         _balances[to] += 1;
908         _owners[tokenId] = to;
909 
910         emit Transfer(address(0), to, tokenId);
911     }
912 
913     /**
914      * @dev Destroys `tokenId`.
915      * The approval is cleared when the token is burned.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _burn(uint256 tokenId) internal virtual {
924         address owner = ERC721.ownerOf(tokenId);
925 
926         _beforeTokenTransfer(owner, address(0), tokenId);
927 
928         // Clear approvals
929         _approve(address(0), tokenId);
930 
931         _balances[owner] -= 1;
932         delete _owners[tokenId];
933 
934         emit Transfer(owner, address(0), tokenId);
935     }
936 
937     /**
938      * @dev Transfers `tokenId` from `from` to `to`.
939      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
940      *
941      * Requirements:
942      *
943      * - `to` cannot be the zero address.
944      * - `tokenId` token must be owned by `from`.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _transfer(
949         address from,
950         address to,
951         uint256 tokenId
952     ) internal virtual {
953         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
954         require(to != address(0), "ERC721: transfer to the zero address");
955 
956         _beforeTokenTransfer(from, to, tokenId);
957 
958         // Clear approvals from the previous owner
959         _approve(address(0), tokenId);
960 
961         _balances[from] -= 1;
962         _balances[to] += 1;
963         _owners[tokenId] = to;
964 
965         emit Transfer(from, to, tokenId);
966     }
967 
968     /**
969      * @dev Approve `to` to operate on `tokenId`
970      *
971      * Emits a {Approval} event.
972      */
973     function _approve(address to, uint256 tokenId) internal virtual {
974         _tokenApprovals[tokenId] = to;
975         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
976     }
977 
978     /**
979      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
980      * The call is not executed if the target address is not a contract.
981      *
982      * @param from address representing the previous owner of the given token ID
983      * @param to target address that will receive the tokens
984      * @param tokenId uint256 ID of the token to be transferred
985      * @param _data bytes optional data to send along with the call
986      * @return bool whether the call correctly returned the expected magic value
987      */
988     function _checkOnERC721Received(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) private returns (bool) {
994         if (to.isContract()) {
995             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
996                 return retval == IERC721Receiver.onERC721Received.selector;
997             } catch (bytes memory reason) {
998                 if (reason.length == 0) {
999                     revert("ERC721: transfer to non ERC721Receiver implementer");
1000                 } else {
1001                     assembly {
1002                         revert(add(32, reason), mload(reason))
1003                     }
1004                 }
1005             }
1006         } else {
1007             return true;
1008         }
1009     }
1010 
1011     /**
1012      * @dev Hook that is called before any token transfer. This includes minting
1013      * and burning.
1014      *
1015      * Calling conditions:
1016      *
1017      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1018      * transferred to `to`.
1019      * - When `from` is zero, `tokenId` will be minted for `to`.
1020      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1021      * - `from` and `to` are never both zero.
1022      *
1023      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1024      */
1025     function _beforeTokenTransfer(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) internal virtual {}
1030 }
1031 
1032 /**
1033  * @dev ERC721 token with storage based token URI management.
1034  */
1035 abstract contract ERC721URIStorage is ERC721 {
1036     using Strings for uint256;
1037 
1038     // Optional mapping for token URIs
1039     mapping(uint256 => string) internal _tokenURIs;
1040 
1041     /**
1042      * @dev See {IERC721Metadata-tokenURI}.
1043      */
1044     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1045         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1046 
1047         string memory _tokenURI = _tokenURIs[tokenId];
1048         string memory base = _baseURI();
1049 
1050         // If there is no base URI, return the token URI.
1051         if (bytes(base).length == 0) {
1052             return _tokenURI;
1053         }
1054         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1055         if (bytes(_tokenURI).length > 0) {
1056             return string(abi.encodePacked(base, _tokenURI));
1057         }
1058 
1059         return super.tokenURI(tokenId);
1060     }
1061 
1062     /**
1063      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1064      *
1065      * Requirements:
1066      *
1067      * - `tokenId` must exist.
1068      */
1069     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1070         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1071         _tokenURIs[tokenId] = _tokenURI;
1072     }
1073 
1074     /**
1075      * @dev Destroys `tokenId`.
1076      * The approval is cleared when the token is burned.
1077      *
1078      * Requirements:
1079      *
1080      * - `tokenId` must exist.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function _burn(uint256 tokenId) internal virtual override {
1085         super._burn(tokenId);
1086 
1087         if (bytes(_tokenURIs[tokenId]).length != 0) {
1088             delete _tokenURIs[tokenId];
1089         }
1090     }
1091 }
1092 
1093 contract BillionaireDoge is ERC721URIStorage, Ownable
1094 {
1095     using Counters for Counters.Counter;
1096     using Strings for uint256;
1097     
1098     event WithdrawEth(address indexed _operator, uint256 _ethWei);
1099     event SetMaxMintingPerTime(uint8 maxMintingPerTime);
1100     event BatchMint(address indexed _whoDone, uint256 _howMany);
1101 
1102     uint256 public immutable totalSupply;
1103     uint8 public maxMintingPerTime;
1104     string private  _baseTokenURI;
1105 
1106     uint public nftCost = 40*10**15;         // unit is 0.001 ETH
1107 
1108     Counters.Counter private _tokenIds;
1109 
1110     constructor() 
1111       ERC721("The Billionaire Doge Club", "BDC")
1112     {
1113         totalSupply = 10000;
1114         setMaxMintingPerTime(10);
1115         setBaseURI("https://cloudflare-ipfs.com/ipns/k2k4r8mbprrc636ix7mslbd8osu3ceqwwggtoi5a7qiid2f71337res0/");
1116     }
1117 
1118     function decimals() public view virtual  returns (uint8) 
1119     {  
1120           return 0;
1121     }
1122 
1123     receive() external virtual payable { } 
1124     fallback() external virtual payable { }
1125     
1126     /* withdraw all eth from owner */
1127     function withdrawAll() public onlyOwner 
1128     {
1129         uint256 _amount = address(this).balance;
1130         payable(_msgSender()).transfer(_amount);
1131 
1132         emit WithdrawEth(_msgSender(), _amount);
1133     }
1134 
1135     modifier canMint(uint8 _number)
1136     {
1137         require(_number <= maxMintingPerTime, "exceed the max minting limit per time");
1138         require (_tokenIds.current() + _number <= totalSupply, "exceed the max supply limit");
1139         _;
1140     }
1141 
1142     function _baseURI() internal view virtual override returns (string memory) 
1143     {
1144         return _baseTokenURI;
1145     }
1146 
1147     function currentMinted() external view returns(uint)
1148     {
1149         return _tokenIds.current();
1150     }
1151 
1152     /* rewrite tokenURI function */
1153     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) 
1154     {
1155         require(_exists(_tokenId), "ERC721URIStorage: URI query for nonexistent token");
1156 
1157         if (bytes(_tokenURIs[_tokenId]).length > 0) {
1158             return string(abi.encodePacked("ipfs://", _tokenURIs[_tokenId]));
1159         }
1160         else if (bytes(_baseTokenURI).length > 0) 
1161         {
1162             return string(abi.encodePacked(_baseTokenURI, _tokenId.toString()));
1163         }
1164         else 
1165         {
1166             return super.tokenURI(_tokenId); 
1167         }
1168     }
1169 
1170     /* Allow the owner set how max minting per time */
1171     function setMaxMintingPerTime(uint8 _maxMintingPerTime) public onlyOwner
1172     {
1173       maxMintingPerTime = _maxMintingPerTime;
1174       emit SetMaxMintingPerTime(maxMintingPerTime);
1175     }
1176 
1177     /* Allow the owner set the base token uri */
1178     function setBaseURI(string memory _baseTokenURI_) public onlyOwner
1179     {
1180         _baseTokenURI = _baseTokenURI_;
1181     }
1182 
1183     /* The owner can set tokenURI if it's error */
1184     function setTokenURI(uint256 _tokenId, string memory _tokenURI) public onlyOwner 
1185     {
1186         super._setTokenURI(_tokenId, _tokenURI);
1187     }
1188 
1189     // when _howManyMEth = 1, it's 0.001 ETH
1190     function setNftCost(uint256 _howManyMEth) external onlyOwner
1191     {
1192         nftCost = _howManyMEth * 10 ** 15;
1193     }
1194 
1195     /* 
1196       Mint to users address, everyone can do,
1197       minting number cannot exceed 255 
1198     */
1199     function mint(uint8 _number) external payable
1200       canMint(_number) returns (bool)
1201     {
1202         require(msg.value >= (nftCost * _number), "Low Price");
1203 
1204         for (uint8 i= 0; i < _number; i++)
1205         {   
1206             uint256 tokenID = _tokenIds.current();
1207             _safeMint(_msgSender(), tokenID);
1208             _tokenIds.increment();
1209         }
1210 
1211         return true;
1212     }
1213 
1214     /* 
1215       Mint to the special address, only the owner can do, 
1216       minting number cannot exceed 255 
1217     */
1218     function mintByOwner(address _addr, uint8 _number) external onlyOwner
1219       returns (bool)
1220     {
1221         require(_number <= 255, "exceed the max minting limit per time");
1222         require (_tokenIds.current() + _number <= totalSupply, "exceed the max supply limit");
1223 
1224         for (uint8 i= 0; i < _number; i++)
1225         {   
1226             uint256 tokenID = _tokenIds.current();
1227             _safeMint(_addr, tokenID);
1228             _tokenIds.increment();
1229         }
1230 
1231         return true;
1232     }
1233 
1234     /* 
1235        Batch Mint to different address in one time,
1236        NOTE: The max address count cannot excced 255,
1237        Only owner can do this
1238     */
1239     function batchMintByOwner(address[] memory _addrs) external onlyOwner 
1240     {
1241         uint8 _number = uint8(_addrs.length);
1242         require(_number <= 255, "exceed the max minting limit per time");
1243         
1244         for (uint8 i = 0; i < _addrs.length; i++)
1245         {
1246             uint256 tokenID = _tokenIds.current();
1247             _safeMint(_addrs[i], tokenID);
1248             _tokenIds.increment();
1249         }
1250         emit BatchMint(_msgSender(), _addrs.length);
1251     }
1252 }