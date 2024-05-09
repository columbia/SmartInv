1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-26
3 */
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 /**
30  * @dev Implementation of the {IERC165} interface.
31  *
32  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
33  * for the additional interface id that will be supported. For example:
34  *
35  * ```solidity
36  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
37  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
38  * }
39  * ```
40  *
41  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
42  */
43 abstract contract ERC165 is IERC165 {
44     /**
45      * @dev See {IERC165-supportsInterface}.
46      */
47     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
48         return interfaceId == type(IERC165).interfaceId;
49     }
50 }
51 
52 /**
53  * @dev String operations.
54  */
55 library Strings {
56     bytes16 private constant alphabet = "0123456789abcdef";
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
60      */
61     function toString(uint256 value) internal pure returns (string memory) {
62         // Inspired by OraclizeAPI's implementation - MIT licence
63         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
64 
65         if (value == 0) {
66             return "0";
67         }
68         uint256 temp = value;
69         uint256 digits;
70         while (temp != 0) {
71             digits++;
72             temp /= 10;
73         }
74         bytes memory buffer = new bytes(digits);
75         while (value != 0) {
76             digits -= 1;
77             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
78             value /= 10;
79         }
80         return string(buffer);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
85      */
86     function toHexString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0x00";
89         }
90         uint256 temp = value;
91         uint256 length = 0;
92         while (temp != 0) {
93             length++;
94             temp >>= 8;
95         }
96         return toHexString(value, length);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
101      */
102     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
103         bytes memory buffer = new bytes(2 * length + 2);
104         buffer[0] = "0";
105         buffer[1] = "x";
106         for (uint256 i = 2 * length + 1; i > 1; --i) {
107             buffer[i] = alphabet[value & 0xf];
108             value >>= 4;
109         }
110         require(value == 0, "Strings: hex length insufficient");
111         return string(buffer);
112     }
113 
114 }
115 
116 
117 /*
118  * @dev Provides information about the current execution context, including the
119  * sender of the transaction and its data. While these are generally available
120  * via msg.sender and msg.data, they should not be accessed in such a direct
121  * manner, since when dealing with meta-transactions the account sending and
122  * paying for execution may not be the actual sender (as far as an application
123  * is concerned).
124  *
125  * This contract is only required for intermediate, library-like contracts.
126  */
127 abstract contract Context {
128     function _msgSender() internal view virtual returns (address) {
129         return msg.sender;
130     }
131 
132     function _msgData() internal view virtual returns (bytes calldata) {
133         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
134         return msg.data;
135     }
136 }
137 
138 
139 /**
140  * @dev Collection of functions related to the address type
141  */
142 library Address {
143     /**
144      * @dev Returns true if `account` is a contract.
145      *
146      * [IMPORTANT]
147      * ====
148      * It is unsafe to assume that an address for which this function returns
149      * false is an externally-owned account (EOA) and not a contract.
150      *
151      * Among others, `isContract` will return false for the following
152      * types of addresses:
153      *
154      *  - an externally-owned account
155      *  - a contract in construction
156      *  - an address where a contract will be created
157      *  - an address where a contract lived, but was destroyed
158      * ====
159      */
160     function isContract(address account) internal view returns (bool) {
161         // This method relies on extcodesize, which returns 0 for contracts in
162         // construction, since the code is only stored at the end of the
163         // constructor execution.
164 
165         uint256 size;
166         // solhint-disable-next-line no-inline-assembly
167         assembly { size := extcodesize(account) }
168         return size > 0;
169     }
170 
171     /**
172      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
173      * `recipient`, forwarding all available gas and reverting on errors.
174      *
175      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
176      * of certain opcodes, possibly making contracts go over the 2300 gas limit
177      * imposed by `transfer`, making them unable to receive funds via
178      * `transfer`. {sendValue} removes this limitation.
179      *
180      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
181      *
182      * IMPORTANT: because control is transferred to `recipient`, care must be
183      * taken to not create reentrancy vulnerabilities. Consider using
184      * {ReentrancyGuard} or the
185      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
186      */
187     function sendValue(address payable recipient, uint256 amount) internal {
188         require(address(this).balance >= amount, "Address: insufficient balance");
189 
190         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
191         (bool success, ) = recipient.call{ value: amount }("");
192         require(success, "Address: unable to send value, recipient may have reverted");
193     }
194 
195     /**
196      * @dev Performs a Solidity function call using a low level `call`. A
197      * plain`call` is an unsafe replacement for a function call: use this
198      * function instead.
199      *
200      * If `target` reverts with a revert reason, it is bubbled up by this
201      * function (like regular Solidity function calls).
202      *
203      * Returns the raw returned data. To convert to the expected return value,
204      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
205      *
206      * Requirements:
207      *
208      * - `target` must be a contract.
209      * - calling `target` with `data` must not revert.
210      *
211      * _Available since v3.1._
212      */
213     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
214       return functionCall(target, data, "Address: low-level call failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
219      * `errorMessage` as a fallback revert reason when `target` reverts.
220      *
221      * _Available since v3.1._
222      */
223     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
224         return functionCallWithValue(target, data, 0, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
229      * but also transferring `value` wei to `target`.
230      *
231      * Requirements:
232      *
233      * - the calling contract must have an ETH balance of at least `value`.
234      * - the called Solidity function must be `payable`.
235      *
236      * _Available since v3.1._
237      */
238     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
239         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
244      * with `errorMessage` as a fallback revert reason when `target` reverts.
245      *
246      * _Available since v3.1._
247      */
248     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
249         require(address(this).balance >= value, "Address: insufficient balance for call");
250         require(isContract(target), "Address: call to non-contract");
251 
252         // solhint-disable-next-line avoid-low-level-calls
253         (bool success, bytes memory returndata) = target.call{ value: value }(data);
254         return _verifyCallResult(success, returndata, errorMessage);
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
259      * but performing a static call.
260      *
261      * _Available since v3.3._
262      */
263     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
264         return functionStaticCall(target, data, "Address: low-level static call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
269      * but performing a static call.
270      *
271      * _Available since v3.3._
272      */
273     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
274         require(isContract(target), "Address: static call to non-contract");
275 
276         // solhint-disable-next-line avoid-low-level-calls
277         (bool success, bytes memory returndata) = target.staticcall(data);
278         return _verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but performing a delegate call.
284      *
285      * _Available since v3.4._
286      */
287     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
288         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
293      * but performing a delegate call.
294      *
295      * _Available since v3.4._
296      */
297     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
298         require(isContract(target), "Address: delegate call to non-contract");
299 
300         // solhint-disable-next-line avoid-low-level-calls
301         (bool success, bytes memory returndata) = target.delegatecall(data);
302         return _verifyCallResult(success, returndata, errorMessage);
303     }
304 
305     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
306         if (success) {
307             return returndata;
308         } else {
309             // Look for revert reason and bubble it up if present
310             if (returndata.length > 0) {
311                 // The easiest way to bubble the revert reason is using memory via assembly
312 
313                 // solhint-disable-next-line no-inline-assembly
314                 assembly {
315                     let returndata_size := mload(returndata)
316                     revert(add(32, returndata), returndata_size)
317                 }
318             } else {
319                 revert(errorMessage);
320             }
321         }
322     }
323 }
324 
325 /**
326  * @dev Required interface of an ERC721 compliant contract.
327  */
328 interface IERC721 is IERC165 {
329     /**
330      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
331      */
332     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
333 
334     /**
335      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
336      */
337     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
338 
339     /**
340      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
341      */
342     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
343 
344     /**
345      * @dev Returns the number of tokens in ``owner``'s account.
346      */
347     function balanceOf(address owner) external view returns (uint256 balance);
348 
349     /**
350      * @dev Returns the owner of the `tokenId` token.
351      *
352      * Requirements:
353      *
354      * - `tokenId` must exist.
355      */
356     function ownerOf(uint256 tokenId) external view returns (address owner);
357 
358     /**
359      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
360      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
361      *
362      * Requirements:
363      *
364      * - `from` cannot be the zero address.
365      * - `to` cannot be the zero address.
366      * - `tokenId` token must exist and be owned by `from`.
367      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
368      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
369      *
370      * Emits a {Transfer} event.
371      */
372     function safeTransferFrom(address from, address to, uint256 tokenId) external;
373 
374     /**
375      * @dev Transfers `tokenId` token from `from` to `to`.
376      *
377      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
378      *
379      * Requirements:
380      *
381      * - `from` cannot be the zero address.
382      * - `to` cannot be the zero address.
383      * - `tokenId` token must be owned by `from`.
384      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transferFrom(address from, address to, uint256 tokenId) external;
389 
390     /**
391      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
392      * The approval is cleared when the token is transferred.
393      *
394      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
395      *
396      * Requirements:
397      *
398      * - The caller must own the token or be an approved operator.
399      * - `tokenId` must exist.
400      *
401      * Emits an {Approval} event.
402      */
403     function approve(address to, uint256 tokenId) external;
404 
405     /**
406      * @dev Returns the account approved for `tokenId` token.
407      *
408      * Requirements:
409      *
410      * - `tokenId` must exist.
411      */
412     function getApproved(uint256 tokenId) external view returns (address operator);
413 
414     /**
415      * @dev Approve or remove `operator` as an operator for the caller.
416      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
417      *
418      * Requirements:
419      *
420      * - The `operator` cannot be the caller.
421      *
422      * Emits an {ApprovalForAll} event.
423      */
424     function setApprovalForAll(address operator, bool _approved) external;
425 
426     /**
427      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
428      *
429      * See {setApprovalForAll}
430      */
431     function isApprovedForAll(address owner, address operator) external view returns (bool);
432 
433     /**
434       * @dev Safely transfers `tokenId` token from `from` to `to`.
435       *
436       * Requirements:
437       *
438       * - `from` cannot be the zero address.
439       * - `to` cannot be the zero address.
440       * - `tokenId` token must exist and be owned by `from`.
441       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
442       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
443       *
444       * Emits a {Transfer} event.
445       */
446     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
447 }
448 
449 /**
450  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
451  * @dev See https://eips.ethereum.org/EIPS/eip-721
452  */
453 interface IERC721Metadata is IERC721 {
454 
455     /**
456      * @dev Returns the token collection name.
457      */
458     function name() external view returns (string memory);
459 
460     /**
461      * @dev Returns the token collection symbol.
462      */
463     function symbol() external view returns (string memory);
464 
465     /**
466      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
467      */
468     function tokenURI(uint256 tokenId) external view returns (string memory);
469 }
470 
471 /**
472  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
473  * @dev See https://eips.ethereum.org/EIPS/eip-721
474  */
475 interface IERC721Enumerable is IERC721 {
476 
477     /**
478      * @dev Returns the total amount of tokens stored by the contract.
479      */
480     function totalSupply() external view returns (uint256);
481 
482     /**
483      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
484      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
485      */
486     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
487 
488     /**
489      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
490      * Use along with {totalSupply} to enumerate all tokens.
491      */
492     function tokenByIndex(uint256 index) external view returns (uint256);
493 }
494 
495 
496 /**
497  * @title ERC721 token receiver interface
498  * @dev Interface for any contract that wants to support safeTransfers
499  * from ERC721 asset contracts.
500  */
501 interface IERC721Receiver {
502     /**
503      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
504      * by `operator` from `from`, this function is called.
505      *
506      * It must return its Solidity selector to confirm the token transfer.
507      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
508      *
509      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
510      */
511     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
512 }
513 
514 
515 /**
516  * @dev Contract module which provides a basic access control mechanism, where
517  * there is an account (an owner) that can be granted exclusive access to
518  * specific functions.
519  *
520  * By default, the owner account will be the one that deploys the contract. This
521  * can later be changed with {transferOwnership}.
522  *
523  * This module is used through inheritance. It will make available the modifier
524  * `onlyOwner`, which can be applied to your functions to restrict their use to
525  * the owner.
526  */
527 abstract contract Ownable is Context {
528     address private _owner;
529 
530     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
531 
532     /**
533      * @dev Initializes the contract setting the deployer as the initial owner.
534      */
535     constructor () {
536         address msgSender = _msgSender();
537         _owner = msgSender;
538         emit OwnershipTransferred(address(0), msgSender);
539     }
540 
541     /**
542      * @dev Returns the address of the current owner.
543      */
544     function owner() public view virtual returns (address) {
545         return _owner;
546     }
547 
548     /**
549      * @dev Throws if called by any account other than the owner.
550      */
551     modifier onlyOwner() {
552         require(owner() == _msgSender(), "Ownable: caller is not the owner");
553         _;
554     }
555 
556     /**
557      * @dev Leaves the contract without owner. It will not be possible to call
558      * `onlyOwner` functions anymore. Can only be called by the current owner.
559      *
560      * NOTE: Renouncing ownership will leave the contract without an owner,
561      * thereby removing any functionality that is only available to the owner.
562      */
563     function renounceOwnership() public virtual onlyOwner {
564         emit OwnershipTransferred(_owner, address(0));
565         _owner = address(0);
566     }
567 
568     /**
569      * @dev Transfers ownership of the contract to a new account (`newOwner`).
570      * Can only be called by the current owner.
571      */
572     function transferOwnership(address newOwner) public virtual onlyOwner {
573         require(newOwner != address(0), "Ownable: new owner is the zero address");
574         emit OwnershipTransferred(_owner, newOwner);
575         _owner = newOwner;
576     }
577 }
578 
579 
580 /**
581  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
582  * the Metadata extension, but not including the Enumerable extension, which is available separately as
583  * {ERC721Enumerable}.
584  */
585 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, Ownable {
586     using Address for address;
587     using Strings for uint256;
588 
589     // Token name
590     string private _name;
591 
592     // Token symbol
593     string private _symbol;
594 
595     // Mapping from token ID to owner address
596     mapping(uint256 => address) internal _owners;
597 
598     // Mapping owner address to token count
599     mapping(address => uint256) internal _balances;
600 
601     // Mapping from token ID to approved address
602     mapping(uint256 => address) private _tokenApprovals;
603 
604     // Mapping from owner to operator approvals
605     mapping(address => mapping(address => bool)) private _operatorApprovals;
606 
607     /**
608      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
609      */
610     constructor(string memory name_, string memory symbol_) {
611         _name = name_;
612         _symbol = symbol_;
613     }
614 
615     /**
616      * @dev See {IERC165-supportsInterface}.
617      */
618     function supportsInterface(bytes4 interfaceId)
619         public
620         view
621         virtual
622         override(ERC165, IERC165)
623         returns (bool)
624     {
625         return
626             interfaceId == type(IERC721).interfaceId ||
627             interfaceId == type(IERC721Metadata).interfaceId ||
628             super.supportsInterface(interfaceId);
629     }
630 
631     /**
632      * @dev See {IERC721-balanceOf}.
633      */
634     function balanceOf(address owner)
635         public
636         view
637         virtual
638         override
639         returns (uint256)
640     {
641         require(
642             owner != address(0),
643             "ERC721: balance query for the zero address"
644         );
645         return _balances[owner];
646     }
647 
648     /**
649      * @dev See {IERC721-ownerOf}.
650      */
651     function ownerOf(uint256 tokenId)
652         public
653         view
654         virtual
655         override
656         returns (address)
657     {
658         address owner = _owners[tokenId];
659         require(
660             owner != address(0),
661             "ERC721: owner query for nonexistent token"
662         );
663         return owner;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-name}.
668      */
669     function name() public view virtual override returns (string memory) {
670         return _name;
671     }
672 
673     /**
674      * @dev See {IERC721Metadata-symbol}.
675      */
676     function symbol() public view virtual override returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-tokenURI}.
682      */
683     function tokenURI(uint256 tokenId)
684         public
685         view
686         virtual
687         override
688         returns (string memory)
689     {
690         require(
691             _exists(tokenId),
692             "ERC721Metadata: URI query for nonexistent token"
693         );
694 
695         string memory baseURI = _baseURI();
696         return
697             bytes(baseURI).length > 0
698                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
699                 : "";
700     }
701 
702     /**
703      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
704      * in child contracts.
705      */
706     function _baseURI() internal view virtual returns (string memory) {
707         return "";
708     }
709 
710     /**
711      * @dev See {IERC721-approve}.
712      */
713     function approve(address to, uint256 tokenId) public virtual override {
714         address owner = ERC721.ownerOf(tokenId);
715         require(to != owner, "ERC721: approval to current owner");
716 
717         require(
718             _msgSender() == owner ||
719                 ERC721.isApprovedForAll(owner, _msgSender()),
720             "ERC721: approve caller is not owner nor approved for all"
721         );
722 
723         _approve(to, tokenId);
724     }
725 
726     /**
727      * @dev See {IERC721-getApproved}.
728      */
729     function getApproved(uint256 tokenId)
730         public
731         view
732         virtual
733         override
734         returns (address)
735     {
736         require(
737             _exists(tokenId),
738             "ERC721: approved query for nonexistent token"
739         );
740 
741         return _tokenApprovals[tokenId];
742     }
743 
744     /**
745      * @dev See {IERC721-setApprovalForAll}.
746      */
747     function setApprovalForAll(address operator, bool approved)
748         public
749         virtual
750         override
751     {
752         require(operator != _msgSender(), "ERC721: approve to caller");
753 
754         _operatorApprovals[_msgSender()][operator] = approved;
755         emit ApprovalForAll(_msgSender(), operator, approved);
756     }
757 
758     /**
759      * @dev See {IERC721-isApprovedForAll}.
760      */
761     function isApprovedForAll(address owner, address operator)
762         public
763         view
764         virtual
765         override
766         returns (bool)
767     {
768         return _operatorApprovals[owner][operator];
769     }
770 
771     /**
772      * @dev See {IERC721-transferFrom}.
773      */
774     function transferFrom(
775         address from,
776         address to,
777         uint256 tokenId
778     ) public virtual override {
779         //solhint-disable-next-line max-line-length
780         require(
781             _isApprovedOrOwner(_msgSender(), tokenId),
782             "ERC721: transfer caller is not owner nor approved"
783         );
784 
785         _transfer(from, to, tokenId);
786     }
787 
788     /**
789      * @dev See {IERC721-safeTransferFrom}.
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId
795     ) public virtual override {
796         safeTransferFrom(from, to, tokenId, "");
797     }
798 
799     /**
800      * @dev See {IERC721-safeTransferFrom}.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId,
806         bytes memory _data
807     ) public virtual override {
808         require(
809             _isApprovedOrOwner(_msgSender(), tokenId),
810             "ERC721: transfer caller is not owner nor approved"
811         );
812         _safeTransfer(from, to, tokenId, _data);
813     }
814 
815     /**
816      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
817      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
818      *
819      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
820      *
821      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
822      * implement alternative mechanisms to perform token transfer, such as signature-based.
823      *
824      * Requirements:
825      *
826      * - `from` cannot be the zero address.
827      * - `to` cannot be the zero address.
828      * - `tokenId` token must exist and be owned by `from`.
829      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
830      *
831      * Emits a {Transfer} event.
832      */
833     function _safeTransfer(
834         address from,
835         address to,
836         uint256 tokenId,
837         bytes memory _data
838     ) internal virtual {
839         _transfer(from, to, tokenId);
840         require(
841             _checkOnERC721Received(from, to, tokenId, _data),
842             "ERC721: transfer to non ERC721Receiver implementer"
843         );
844     }
845 
846     /**
847      * @dev Returns whether `tokenId` exists.
848      *
849      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
850      *
851      * Tokens start existing when they are minted (`_mint`),
852      * and stop existing when they are burned (`_burn`).
853      */
854     function _exists(uint256 tokenId) internal view virtual returns (bool) {
855         return _owners[tokenId] != address(0);
856     }
857 
858     /**
859      * @dev Returns whether `spender` is allowed to manage `tokenId`.
860      *
861      * Requirements:
862      *
863      * - `tokenId` must exist.
864      */
865     function _isApprovedOrOwner(address spender, uint256 tokenId)
866         internal
867         view
868         virtual
869         returns (bool)
870     {
871         require(
872             _exists(tokenId),
873             "ERC721: operator query for nonexistent token"
874         );
875         address owner = ERC721.ownerOf(tokenId);
876         return (spender == owner ||
877             getApproved(tokenId) == spender ||
878             ERC721.isApprovedForAll(owner, spender));
879     }
880 
881     /**
882      * @dev Safely mints `tokenId` and transfers it to `to`.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must not exist.
887      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _safeMint(address to, uint256 tokenId) internal virtual {
892         _safeMint(to, tokenId, "");
893     }
894 
895     /**
896      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
897      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
898      */
899     function _safeMint(
900         address to,
901         uint256 tokenId,
902         bytes memory _data
903     ) internal virtual {
904         _mint(to, tokenId);
905         require(
906             _checkOnERC721Received(address(0), to, tokenId, _data),
907             "ERC721: transfer to non ERC721Receiver implementer"
908         );
909     }
910 
911     /**
912      * @dev Mints `tokenId` and transfers it to `to`.
913      *
914      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
915      *
916      * Requirements:
917      *
918      * - `tokenId` must not exist.
919      * - `to` cannot be the zero address.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _mint(address to, uint256 tokenId) internal virtual {
924         require(to != address(0), "ERC721: mint to the zero address");
925         require(!_exists(tokenId), "ERC721: token already minted");
926 
927         _beforeTokenTransfer(address(0), to, tokenId);
928 
929         _balances[to] += 1;
930         _owners[tokenId] = to;
931 
932         emit Transfer(address(0), to, tokenId);
933     }
934 
935     function _batchMint(address to, uint256[] memory tokenIds)
936         internal
937         virtual
938     {
939         require(to != address(0), "ERC721: mint to the zero address");
940         _balances[to] += tokenIds.length;
941 
942         for (uint256 i; i < tokenIds.length; i++) {
943             require(!_exists(tokenIds[i]), "ERC721: token already minted");
944 
945             _beforeTokenTransfer(address(0), to, tokenIds[i]);
946 
947             _owners[tokenIds[i]] = to;
948 
949             emit Transfer(address(0), to, tokenIds[i]);
950         }
951     }
952 
953     /**
954      * @dev Destroys `tokenId`.
955      * The approval is cleared when the token is burned.
956      *
957      * Requirements:
958      *
959      * - `tokenId` must exist.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _burn(uint256 tokenId) internal virtual {
964         address owner = ERC721.ownerOf(tokenId);
965 
966         _beforeTokenTransfer(owner, address(0), tokenId);
967 
968         // Clear approvals
969         _approve(address(0), tokenId);
970 
971         _balances[owner] -= 1;
972         delete _owners[tokenId];
973 
974         emit Transfer(owner, address(0), tokenId);
975     }
976 
977     /**
978      * @dev Transfers `tokenId` from `from` to `to`.
979      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
980      *
981      * Requirements:
982      *
983      * - `to` cannot be the zero address.
984      * - `tokenId` token must be owned by `from`.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _transfer(
989         address from,
990         address to,
991         uint256 tokenId
992     ) internal virtual {
993         require(
994             ERC721.ownerOf(tokenId) == from,
995             "ERC721: transfer of token that is not own"
996         );
997         require(to != address(0), "ERC721: transfer to the zero address");
998 
999         _beforeTokenTransfer(from, to, tokenId);
1000 
1001         // Clear approvals from the previous owner
1002         _approve(address(0), tokenId);
1003 
1004         _balances[from] -= 1;
1005         _balances[to] += 1;
1006         _owners[tokenId] = to;
1007 
1008         emit Transfer(from, to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev Approve `to` to operate on `tokenId`
1013      *
1014      * Emits a {Approval} event.
1015      */
1016     function _approve(address to, uint256 tokenId) internal virtual {
1017         _tokenApprovals[tokenId] = to;
1018         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1023      * The call is not executed if the target address is not a contract.
1024      *
1025      * @param from address representing the previous owner of the given token ID
1026      * @param to target address that will receive the tokens
1027      * @param tokenId uint256 ID of the token to be transferred
1028      * @param _data bytes optional data to send along with the call
1029      * @return bool whether the call correctly returned the expected magic value
1030      */
1031     function _checkOnERC721Received(
1032         address from,
1033         address to,
1034         uint256 tokenId,
1035         bytes memory _data
1036     ) private returns (bool) {
1037         if (to.isContract()) {
1038             try
1039                 IERC721Receiver(to).onERC721Received(
1040                     _msgSender(),
1041                     from,
1042                     tokenId,
1043                     _data
1044                 )
1045             returns (bytes4 retval) {
1046                 return retval == IERC721Receiver(to).onERC721Received.selector;
1047             } catch (bytes memory reason) {
1048                 if (reason.length == 0) {
1049                     revert(
1050                         "ERC721: transfer to non ERC721Receiver implementer"
1051                     );
1052                 } else {
1053                     // solhint-disable-next-line no-inline-assembly
1054                     assembly {
1055                         revert(add(32, reason), mload(reason))
1056                     }
1057                 }
1058             }
1059         } else {
1060             return true;
1061         }
1062     }
1063 
1064     /**
1065      * @dev Hook that is called before any token transfer. This includes minting
1066      * and burning.
1067      *
1068      * Calling conditions:
1069      *
1070      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1071      * transferred to `to`.
1072      * - When `from` is zero, `tokenId` will be minted for `to`.
1073      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1074      * - `from` cannot be the zero address.
1075      * - `to` cannot be the zero address.
1076      *
1077      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1078      */
1079     function _beforeTokenTransfer(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) internal virtual {}
1084 }
1085 
1086 abstract contract DJENERATES {
1087   function ownerOf(uint256 tokenId) public virtual view returns (address);
1088   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1089   function balanceOf(address owner) external virtual view returns (uint256 balance);
1090 }
1091 
1092 contract Shaman is ERC721 {
1093 
1094     modifier callerIsUser() {
1095         require(tx.origin == msg.sender, "The caller is another contract");
1096         _;
1097     }
1098 
1099     modifier claimStarted() {
1100         require(
1101             startClaimDate != 0 && startClaimDate <= block.timestamp,
1102             "You are too early"
1103         );
1104 
1105         _;
1106     }
1107 
1108     uint256 private startClaimDate = 1638536400; //3rd Dec 2021 1PM UTC
1109     uint256 private claimPrice =  0.1 ether;
1110     uint256 private totalTokens = 6000;
1111     uint256 private totalMintedTokens = 0;
1112     uint128 private basisPoints = 10000;
1113     string private baseURI =
1114         "https://ipfs.io/ipfs/QmUdhuHfJmN8eFvSEWFpE2LtMXiUtXGHXQUUS8PZPahfSd/";
1115 
1116     DJENERATES private djen = DJENERATES(address(0x7d05c8D8cC1baC936eA09308a9E94823986f8321));
1117     mapping(address => uint256) private claimedTokensPerWallet;
1118 
1119     mapping(uint16 => uint16[]) private availableTokens;
1120 
1121     constructor() ERC721("DJENERATES - SPIRIT ANIMALS", "SA") {}
1122 
1123     /**
1124      * @dev Allows to withdraw the Ether in the contract
1125      */
1126     function withdraw() external onlyOwner {
1127         uint256 totalBalance = address(this).balance;
1128         payable(msg.sender).transfer(totalBalance);
1129     }
1130 
1131     /**
1132      * @dev Sets the base URI for the API that provides the NFT data.
1133      */
1134     function setBaseTokenURI(string memory _uri) external onlyOwner {
1135         baseURI = _uri;
1136     }
1137 
1138     /**
1139      * @dev Sets the claim price for each token
1140      */
1141     function setClaimPrice(uint256 _claimPrice) external onlyOwner {
1142         claimPrice = _claimPrice;
1143     }
1144 
1145     /**
1146      * @dev Populates the available tokens
1147      */
1148     function addAvailableTokens(uint16 num,uint16 from, uint16 to)
1149         external
1150         onlyOwner
1151     {
1152        for (uint16 i = from; i <= to; i++) {
1153             availableTokens[num].push(i);
1154         }
1155     }
1156 
1157     /**
1158      * @dev Sets the date that users can start claiming tokens
1159      */
1160     function setStartClaimDate(uint256 _startClaimDate)
1161         external
1162         onlyOwner
1163     {
1164         startClaimDate = _startClaimDate;
1165     }
1166 
1167     /**
1168      * @dev Claim a single token
1169      */
1170     function claimToken(uint16 animal) external callerIsUser claimStarted {
1171         require(availableTokens[animal].length > 0, "No tokens left to be claimed for this Animal");
1172         uint256 balance= djen.balanceOf(msg.sender);
1173         require(
1174             balance > 0,"You are not holding any DJEN for free claim"
1175         );
1176         require(
1177             balance > claimedTokensPerWallet[msg.sender],"You are not eligible for more free claim"
1178         );
1179 
1180         claimedTokensPerWallet[msg.sender]++;
1181         totalMintedTokens++;
1182 
1183         _mint(msg.sender, getTokenToBeClaimed(animal));
1184     }
1185 
1186     /**
1187      * @dev Claim up to 50 tokens at once
1188      */
1189     function claimTokens(uint16 animal,uint256 amount)
1190         external
1191         payable
1192         callerIsUser
1193         claimStarted
1194     {
1195         require(
1196             msg.value >= claimPrice * amount,
1197             "Not enough Ether to claim the tokens"
1198         );
1199         require(availableTokens[animal].length >= amount, "No tokens left to be claimed for this Animal");
1200 
1201         uint256[] memory tokenIds = new uint256[](amount);
1202 
1203         totalMintedTokens += amount;
1204 
1205         for (uint256 i; i < amount; i++) {
1206             tokenIds[i] = getTokenToBeClaimed(animal);
1207         }
1208 
1209         _batchMint(msg.sender, tokenIds);
1210     }
1211 
1212     /**
1213      * @dev Returns the tokenId by index
1214      */
1215     function tokenByIndex(uint256 tokenId) external view returns (uint256) {
1216         require(
1217             _exists(tokenId),
1218             "ERC721: operator query for nonexistent token"
1219         );
1220 
1221         return tokenId;
1222     }
1223 
1224     /**
1225      * @dev Returns the base URI for the tokens API.
1226      */
1227     function baseTokenURI() external view returns (string memory) {
1228         return baseURI;
1229     }
1230 
1231     /**
1232      * @dev Returns how many tokens are still available to be claimed
1233      */
1234     function getAvailableTokens(uint16 animal) external view returns (uint256) {
1235         return availableTokens[animal].length;
1236     }
1237 
1238     /**
1239      * @dev Returns the claim price
1240      */
1241     function getClaimPrice() external view returns (uint256) {
1242         return claimPrice;
1243     }
1244 
1245     /**
1246      * @dev Returns the total supply
1247      */
1248     function totalSupply() external view virtual returns (uint256) {
1249         return totalMintedTokens;
1250     }
1251 
1252     // Private and Internal functions
1253 
1254     /**
1255      * @dev Returns a random available token to be claimed
1256      */
1257     function getTokenToBeClaimed(uint16 animal) private returns (uint256) {
1258         uint256 random = _getRandomNumber(animal,availableTokens[animal].length);
1259         uint256 tokenId = uint256(availableTokens[animal][random]);
1260 
1261         availableTokens[animal][random] = availableTokens[animal][availableTokens[animal].length - 1];
1262         availableTokens[animal].pop();
1263 
1264         return tokenId;
1265     }
1266 
1267     /**
1268      * @dev Generates a pseudo-random number.
1269      */
1270     function _getRandomNumber(uint16 animal,uint256 _upper) private view returns (uint256) {
1271         uint256 random = uint256(
1272             keccak256(
1273                 abi.encodePacked(
1274                     availableTokens[animal].length,
1275                     blockhash(block.number - 1),
1276                     block.coinbase,
1277                     block.difficulty,
1278                     msg.sender
1279                 )
1280             )
1281         );
1282 
1283         return random % _upper;
1284     }
1285 
1286     /**
1287      * @dev See {ERC721}.
1288      */
1289     function _baseURI() internal view virtual override returns (string memory) {
1290         return baseURI;
1291     }
1292 }