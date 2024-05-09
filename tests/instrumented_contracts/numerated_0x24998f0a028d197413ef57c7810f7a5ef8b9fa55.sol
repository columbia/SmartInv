1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.8.9;
4 
5 
6 
7 // Part: Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a delegate call.
154      *
155      * _Available since v3.4._
156      */
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.4._
166      */
167     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176         if (success) {
177             return returndata;
178         } else {
179             // Look for revert reason and bubble it up if present
180             if (returndata.length > 0) {
181                 // The easiest way to bubble the revert reason is using memory via assembly
182 
183                 // solhint-disable-next-line no-inline-assembly
184                 assembly {
185                     let returndata_size := mload(returndata)
186                     revert(add(32, returndata), returndata_size)
187                 }
188             } else {
189                 revert(errorMessage);
190             }
191         }
192     }
193 }
194 
195 // Part: Context
196 
197 /*
198  * @dev Provides information about the current execution context, including the
199  * sender of the transaction and its data. While these are generally available
200  * via msg.sender and msg.data, they should not be accessed in such a direct
201  * manner, since when dealing with meta-transactions the account sending and
202  * paying for execution may not be the actual sender (as far as an application
203  * is concerned).
204  *
205  * This contract is only required for intermediate, library-like contracts.
206  */
207 abstract contract Context {
208     function _msgSender() internal view virtual returns (address) {
209         return msg.sender;
210     }
211 
212     function _msgData() internal view virtual returns (bytes calldata) {
213         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
214         return msg.data;
215     }
216 }
217 
218 // Part: IERC165
219 
220 /**
221  * @dev Interface of the ERC165 standard, as defined in the
222  * https://eips.ethereum.org/EIPS/eip-165[EIP].
223  *
224  * Implementers can declare support of contract interfaces, which can then be
225  * queried by others ({ERC165Checker}).
226  *
227  * For an implementation, see {ERC165}.
228  */
229 interface IERC165 {
230     /**
231      * @dev Returns true if this contract implements the interface defined by
232      * `interfaceId`. See the corresponding
233      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
234      * to learn more about how these ids are created.
235      *
236      * This function call must use less than 30 000 gas.
237      */
238     function supportsInterface(bytes4 interfaceId) external view returns (bool);
239 }
240 
241 // Part: IERC721Receiver
242 
243 /**
244  * @title ERC721 token receiver interface
245  * @dev Interface for any contract that wants to support safeTransfers
246  * from ERC721 asset contracts.
247  */
248 interface IERC721Receiver {
249     /**
250      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
251      * by `operator` from `from`, this function is called.
252      *
253      * It must return its Solidity selector to confirm the token transfer.
254      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
255      *
256      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
257      */
258     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
259 }
260 
261 // Part: Strings
262 
263 /**
264  * @dev String operations.
265  */
266 library Strings {
267     bytes16 private constant alphabet = "0123456789abcdef";
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
271      */
272     function toString(uint256 value) internal pure returns (string memory) {
273         // Inspired by OraclizeAPI's implementation - MIT licence
274         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
275 
276         if (value == 0) {
277             return "0";
278         }
279         uint256 temp = value;
280         uint256 digits;
281         while (temp != 0) {
282             digits++;
283             temp /= 10;
284         }
285         bytes memory buffer = new bytes(digits);
286         while (value != 0) {
287             digits -= 1;
288             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
289             value /= 10;
290         }
291         return string(buffer);
292     }
293 
294     /**
295      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
296      */
297     function toHexString(uint256 value) internal pure returns (string memory) {
298         if (value == 0) {
299             return "0x00";
300         }
301         uint256 temp = value;
302         uint256 length = 0;
303         while (temp != 0) {
304             length++;
305             temp >>= 8;
306         }
307         return toHexString(value, length);
308     }
309 
310     /**
311      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
312      */
313     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
314         bytes memory buffer = new bytes(2 * length + 2);
315         buffer[0] = "0";
316         buffer[1] = "x";
317         for (uint256 i = 2 * length + 1; i > 1; --i) {
318             buffer[i] = alphabet[value & 0xf];
319             value >>= 4;
320         }
321         require(value == 0, "Strings: hex length insufficient");
322         return string(buffer);
323     }
324 
325 }
326 
327 // Part: ERC165
328 
329 /**
330  * @dev Implementation of the {IERC165} interface.
331  *
332  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
333  * for the additional interface id that will be supported. For example:
334  *
335  * ```solidity
336  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
337  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
338  * }
339  * ```
340  *
341  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
342  */
343 abstract contract ERC165 is IERC165 {
344     /**
345      * @dev See {IERC165-supportsInterface}.
346      */
347     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
348         return interfaceId == type(IERC165).interfaceId;
349     }
350 }
351 
352 // Part: IERC721
353 
354 /**
355  * @dev Required interface of an ERC721 compliant contract.
356  */
357 interface IERC721 is IERC165 {
358     /**
359      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
360      */
361     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
362 
363     /**
364      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
365      */
366     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
367 
368     /**
369      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
370      */
371     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
372 
373     /**
374      * @dev Returns the number of tokens in ``owner``'s account.
375      */
376     function balanceOf(address owner) external view returns (uint256 balance);
377 
378     /**
379      * @dev Returns the owner of the `tokenId` token.
380      *
381      * Requirements:
382      *
383      * - `tokenId` must exist.
384      */
385     function ownerOf(uint256 tokenId) external view returns (address owner);
386 
387     /**
388      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
389      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
390      *
391      * Requirements:
392      *
393      * - `from` cannot be the zero address.
394      * - `to` cannot be the zero address.
395      * - `tokenId` token must exist and be owned by `from`.
396      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
397      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
398      *
399      * Emits a {Transfer} event.
400      */
401     function safeTransferFrom(
402         address from,
403         address to,
404         uint256 tokenId
405     ) external;
406 
407     /**
408      * @dev Transfers `tokenId` token from `from` to `to`.
409      *
410      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
411      *
412      * Requirements:
413      *
414      * - `from` cannot be the zero address.
415      * - `to` cannot be the zero address.
416      * - `tokenId` token must be owned by `from`.
417      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transferFrom(
422         address from,
423         address to,
424         uint256 tokenId
425     ) external;
426 
427     /**
428      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
429      * The approval is cleared when the token is transferred.
430      *
431      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
432      *
433      * Requirements:
434      *
435      * - The caller must own the token or be an approved operator.
436      * - `tokenId` must exist.
437      *
438      * Emits an {Approval} event.
439      */
440     function approve(address to, uint256 tokenId) external;
441 
442     /**
443      * @dev Returns the account approved for `tokenId` token.
444      *
445      * Requirements:
446      *
447      * - `tokenId` must exist.
448      */
449     function getApproved(uint256 tokenId) external view returns (address operator);
450 
451     /**
452      * @dev Approve or remove `operator` as an operator for the caller.
453      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
454      *
455      * Requirements:
456      *
457      * - The `operator` cannot be the caller.
458      *
459      * Emits an {ApprovalForAll} event.
460      */
461     function setApprovalForAll(address operator, bool _approved) external;
462 
463     /**
464      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
465      *
466      * See {setApprovalForAll}
467      */
468     function isApprovedForAll(address owner, address operator) external view returns (bool);
469 
470     /**
471      * @dev Safely transfers `tokenId` token from `from` to `to`.
472      *
473      * Requirements:
474      *
475      * - `from` cannot be the zero address.
476      * - `to` cannot be the zero address.
477      * - `tokenId` token must exist and be owned by `from`.
478      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
479      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
480      *
481      * Emits a {Transfer} event.
482      */
483     function safeTransferFrom(
484         address from,
485         address to,
486         uint256 tokenId,
487         bytes calldata data
488     ) external;
489 }
490 
491 // Part: Ownable
492 
493 /**
494  * @dev Contract module which provides a basic access control mechanism, where
495  * there is an account (an owner) that can be granted exclusive access to
496  * specific functions.
497  *
498  * By default, the owner account will be the one that deploys the contract. This
499  * can later be changed with {transferOwnership}.
500  *
501  * This module is used through inheritance. It will make available the modifier
502  * `onlyOwner`, which can be applied to your functions to restrict their use to
503  * the owner.
504  */
505 abstract contract Ownable is Context {
506     address private _owner;
507 
508     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
509 
510     /**
511      * @dev Initializes the contract setting the deployer as the initial owner.
512      */
513     constructor () {
514         address msgSender = _msgSender();
515         _owner = msgSender;
516         emit OwnershipTransferred(address(0), msgSender);
517     }
518 
519     /**
520      * @dev Returns the address of the current owner.
521      */
522     function owner() public view virtual returns (address) {
523         return _owner;
524     }
525 
526     /**
527      * @dev Throws if called by any account other than the owner.
528      */
529     modifier onlyOwner() {
530         require(owner() == _msgSender(), "Ownable: caller is not the owner");
531         _;
532     }
533 
534     /**
535      * @dev Leaves the contract without owner. It will not be possible to call
536      * `onlyOwner` functions anymore. Can only be called by the current owner.
537      *
538      * NOTE: Renouncing ownership will leave the contract without an owner,
539      * thereby removing any functionality that is only available to the owner.
540      */
541     function renounceOwnership() public virtual onlyOwner {
542         emit OwnershipTransferred(_owner, address(0));
543         _owner = address(0);
544     }
545 
546     /**
547      * @dev Transfers ownership of the contract to a new account (`newOwner`).
548      * Can only be called by the current owner.
549      */
550     function transferOwnership(address newOwner) public virtual onlyOwner {
551         require(newOwner != address(0), "Ownable: new owner is the zero address");
552         emit OwnershipTransferred(_owner, newOwner);
553         _owner = newOwner;
554     }
555 }
556 
557 // Part: IERC721Enumerable
558 
559 /**
560  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
561  * @dev See https://eips.ethereum.org/EIPS/eip-721
562  */
563 interface IERC721Enumerable is IERC721 {
564 
565     /**
566      * @dev Returns the total amount of tokens stored by the contract.
567      */
568     function totalSupply() external view returns (uint256);
569 
570     /**
571      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
572      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
573      */
574     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
575 
576     /**
577      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
578      * Use along with {totalSupply} to enumerate all tokens.
579      */
580     function tokenByIndex(uint256 index) external view returns (uint256);
581 }
582 
583 // Part: IERC721Metadata
584 
585 /**
586  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
587  * @dev See https://eips.ethereum.org/EIPS/eip-721
588  */
589 interface IERC721Metadata is IERC721 {
590 
591     /**
592      * @dev Returns the token collection name.
593      */
594     function name() external view returns (string memory);
595 
596     /**
597      * @dev Returns the token collection symbol.
598      */
599     function symbol() external view returns (string memory);
600 
601     /**
602      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
603      */
604     function tokenURI(uint256 tokenId) external view returns (string memory);
605 }
606 
607 // Part: ERC721
608 
609 /**
610  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
611  * the Metadata extension, but not including the Enumerable extension, which is available separately as
612  * {ERC721Enumerable}.
613  */
614 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
615     using Address for address;
616     using Strings for uint256;
617 
618     // Token name
619     string private _name;
620 
621     // Token symbol
622     string private _symbol;
623 
624     // Mapping from token ID to owner address
625     mapping (uint256 => address) private _owners;
626 
627     // Mapping owner address to token count
628     mapping (address => uint256) private _balances;
629 
630     // Mapping from token ID to approved address
631     mapping (uint256 => address) private _tokenApprovals;
632 
633     // Mapping from owner to operator approvals
634     mapping (address => mapping (address => bool)) private _operatorApprovals;
635 
636     /**
637      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
638      */
639     constructor (string memory name_, string memory symbol_) {
640         _name = name_;
641         _symbol = symbol_;
642     }
643 
644     /**
645      * @dev See {IERC165-supportsInterface}.
646      */
647     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
648         return interfaceId == type(IERC721).interfaceId
649             || interfaceId == type(IERC721Metadata).interfaceId
650             || super.supportsInterface(interfaceId);
651     }
652 
653     /**
654      * @dev See {IERC721-balanceOf}.
655      */
656     function balanceOf(address owner) public view virtual override returns (uint256) {
657         require(owner != address(0), "ERC721: balance query for the zero address");
658         return _balances[owner];
659     }
660 
661     /**
662      * @dev See {IERC721-ownerOf}.
663      */
664     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
665         address owner = _owners[tokenId];
666         require(owner != address(0), "ERC721: owner query for nonexistent token");
667         return owner;
668     }
669 
670     /**
671      * @dev See {IERC721Metadata-name}.
672      */
673     function name() public view virtual override returns (string memory) {
674         return _name;
675     }
676 
677     /**
678      * @dev See {IERC721Metadata-symbol}.
679      */
680     function symbol() public view virtual override returns (string memory) {
681         return _symbol;
682     }
683 
684     /**
685      * @dev See {IERC721Metadata-tokenURI}.
686      */
687     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
688         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
689 
690         string memory baseURI = _baseURI();
691         string memory json = ".json";
692         return bytes(baseURI).length > 0
693             ? string(abi.encodePacked(baseURI, tokenId.toString(), json))
694             : '';
695     }
696 
697     /**
698      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
699      * in child contracts.
700      */
701     function _baseURI() internal view virtual returns (string memory) {
702         return "";
703     }
704 
705     /**
706      * @dev See {IERC721-approve}.
707      */
708     function approve(address to, uint256 tokenId) public virtual override {
709         address owner = ERC721.ownerOf(tokenId);
710         require(to != owner, "ERC721: approval to current owner");
711 
712         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
713             "ERC721: approve caller is not owner nor approved for all"
714         );
715 
716         _approve(to, tokenId);
717     }
718 
719     /**
720      * @dev See {IERC721-getApproved}.
721      */
722     function getApproved(uint256 tokenId) public view virtual override returns (address) {
723         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
724 
725         return _tokenApprovals[tokenId];
726     }
727 
728     /**
729      * @dev See {IERC721-setApprovalForAll}.
730      */
731     function setApprovalForAll(address operator, bool approved) public virtual override {
732         require(operator != _msgSender(), "ERC721: approve to caller");
733 
734         _operatorApprovals[_msgSender()][operator] = approved;
735         emit ApprovalForAll(_msgSender(), operator, approved);
736     }
737 
738     /**
739      * @dev See {IERC721-isApprovedForAll}.
740      */
741     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
742         return _operatorApprovals[owner][operator];
743     }
744 
745     /**
746      * @dev See {IERC721-transferFrom}.
747      */
748     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
749         //solhint-disable-next-line max-line-length
750         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
751 
752         _transfer(from, to, tokenId);
753     }
754 
755     /**
756      * @dev See {IERC721-safeTransferFrom}.
757      */
758     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
759         safeTransferFrom(from, to, tokenId, "");
760     }
761 
762     /**
763      * @dev See {IERC721-safeTransferFrom}.
764      */
765     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
766         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
767         _safeTransfer(from, to, tokenId, _data);
768     }
769 
770     /**
771      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
772      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
773      *
774      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
775      *
776      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
777      * implement alternative mechanisms to perform token transfer, such as signature-based.
778      *
779      * Requirements:
780      *
781      * - `from` cannot be the zero address.
782      * - `to` cannot be the zero address.
783      * - `tokenId` token must exist and be owned by `from`.
784      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
785      *
786      * Emits a {Transfer} event.
787      */
788     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
789         _transfer(from, to, tokenId);
790         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
791     }
792 
793     /**
794      * @dev Returns whether `tokenId` exists.
795      *
796      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
797      *
798      * Tokens start existing when they are minted (`_mint`),
799      * and stop existing when they are burned (`_burn`).
800      */
801     function _exists(uint256 tokenId) internal view virtual returns (bool) {
802         return _owners[tokenId] != address(0);
803     }
804 
805     /**
806      * @dev Returns whether `spender` is allowed to manage `tokenId`.
807      *
808      * Requirements:
809      *
810      * - `tokenId` must exist.
811      */
812     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
813         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
814         address owner = ERC721.ownerOf(tokenId);
815         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
816     }
817 
818     /**
819      * @dev Safely mints `tokenId` and transfers it to `to`.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must not exist.
824      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
825      *
826      * Emits a {Transfer} event.
827      */
828     function _safeMint(address to, uint256 tokenId) internal virtual {
829         _safeMint(to, tokenId, "");
830     }
831 
832     /**
833      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
834      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
835      */
836     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
837         _mint(to, tokenId);
838         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
839     }
840 
841     /**
842      * @dev Mints `tokenId` and transfers it to `to`.
843      *
844      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
845      *
846      * Requirements:
847      *
848      * - `tokenId` must not exist.
849      * - `to` cannot be the zero address.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _mint(address to, uint256 tokenId) internal virtual {
854         require(to != address(0), "ERC721: mint to the zero address");
855         require(!_exists(tokenId), "ERC721: token already minted");
856 
857         _beforeTokenTransfer(address(0), to, tokenId);
858 
859         _balances[to] += 1;
860         _owners[tokenId] = to;
861 
862         emit Transfer(address(0), to, tokenId);
863     }
864 
865     /**
866      * @dev Destroys `tokenId`.
867      * The approval is cleared when the token is burned.
868      *
869      * Requirements:
870      *
871      * - `tokenId` must exist.
872      *
873      * Emits a {Transfer} event.
874      */
875     function _burn(uint256 tokenId) internal virtual {
876         address owner = ERC721.ownerOf(tokenId);
877 
878         _beforeTokenTransfer(owner, address(0), tokenId);
879 
880         // Clear approvals
881         _approve(address(0), tokenId);
882 
883         _balances[owner] -= 1;
884         delete _owners[tokenId];
885 
886         emit Transfer(owner, address(0), tokenId);
887     }
888 
889     /**
890      * @dev Transfers `tokenId` from `from` to `to`.
891      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
892      *
893      * Requirements:
894      *
895      * - `to` cannot be the zero address.
896      * - `tokenId` token must be owned by `from`.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _transfer(address from, address to, uint256 tokenId) internal virtual {
901         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
902         require(to != address(0), "ERC721: transfer to the zero address");
903 
904         _beforeTokenTransfer(from, to, tokenId);
905 
906         // Clear approvals from the previous owner
907         _approve(address(0), tokenId);
908 
909         _balances[from] -= 1;
910         _balances[to] += 1;
911         _owners[tokenId] = to;
912 
913         emit Transfer(from, to, tokenId);
914     }
915 
916     /**
917      * @dev Approve `to` to operate on `tokenId`
918      *
919      * Emits a {Approval} event.
920      */
921     function _approve(address to, uint256 tokenId) internal virtual {
922         _tokenApprovals[tokenId] = to;
923         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
924     }
925 
926     /**
927      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
928      * The call is not executed if the target address is not a contract.
929      *
930      * @param from address representing the previous owner of the given token ID
931      * @param to target address that will receive the tokens
932      * @param tokenId uint256 ID of the token to be transferred
933      * @param _data bytes optional data to send along with the call
934      * @return bool whether the call correctly returned the expected magic value
935      */
936     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
937         private returns (bool)
938     {
939         if (to.isContract()) {
940             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
941                 return retval == IERC721Receiver(to).onERC721Received.selector;
942             } catch (bytes memory reason) {
943                 if (reason.length == 0) {
944                     revert("ERC721: transfer to non ERC721Receiver implementer");
945                 } else {
946                     // solhint-disable-next-line no-inline-assembly
947                     assembly {
948                         revert(add(32, reason), mload(reason))
949                     }
950                 }
951             }
952         } else {
953             return true;
954         }
955     }
956 
957     /**
958      * @dev Hook that is called before any token transfer. This includes minting
959      * and burning.
960      *
961      * Calling conditions:
962      *
963      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
964      * transferred to `to`.
965      * - When `from` is zero, `tokenId` will be minted for `to`.
966      * - When `to` is zero, ``from``'s `tokenId` will be burned.
967      * - `from` cannot be the zero address.
968      * - `to` cannot be the zero address.
969      *
970      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
971      */
972     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
973 }
974 
975 // Part: ERC721Enumerable
976 
977 /**
978  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
979  * enumerability of all the token ids in the contract as well as all token ids owned by each
980  * account.
981  */
982 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
983     // Mapping from owner to list of owned token IDs
984     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
985 
986     // Mapping from token ID to index of the owner tokens list
987     mapping(uint256 => uint256) private _ownedTokensIndex;
988 
989     // Array with all token ids, used for enumeration
990     uint256[] private _allTokens;
991 
992     // Mapping from token id to position in the allTokens array
993     mapping(uint256 => uint256) private _allTokensIndex;
994 
995     /**
996      * @dev See {IERC165-supportsInterface}.
997      */
998     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
999         return interfaceId == type(IERC721Enumerable).interfaceId
1000             || super.supportsInterface(interfaceId);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1005      */
1006     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1007         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1008         return _ownedTokens[owner][index];
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Enumerable-totalSupply}.
1013      */
1014     function totalSupply() public view virtual override returns (uint256) {
1015         return _allTokens.length;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Enumerable-tokenByIndex}.
1020      */
1021     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1022         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1023         return _allTokens[index];
1024     }
1025 
1026     /**
1027      * @dev Hook that is called before any token transfer. This includes minting
1028      * and burning.
1029      *
1030      * Calling conditions:
1031      *
1032      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1033      * transferred to `to`.
1034      * - When `from` is zero, `tokenId` will be minted for `to`.
1035      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1036      * - `from` cannot be the zero address.
1037      * - `to` cannot be the zero address.
1038      *
1039      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1040      */
1041     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1042         super._beforeTokenTransfer(from, to, tokenId);
1043 
1044         if (from == address(0)) {
1045             _addTokenToAllTokensEnumeration(tokenId);
1046         } else if (from != to) {
1047             _removeTokenFromOwnerEnumeration(from, tokenId);
1048         }
1049         if (to == address(0)) {
1050             _removeTokenFromAllTokensEnumeration(tokenId);
1051         } else if (to != from) {
1052             _addTokenToOwnerEnumeration(to, tokenId);
1053         }
1054     }
1055 
1056     /**
1057      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1058      * @param to address representing the new owner of the given token ID
1059      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1060      */
1061     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1062         uint256 length = ERC721.balanceOf(to);
1063         _ownedTokens[to][length] = tokenId;
1064         _ownedTokensIndex[tokenId] = length;
1065     }
1066 
1067     /**
1068      * @dev Private function to add a token to this extension's token tracking data structures.
1069      * @param tokenId uint256 ID of the token to be added to the tokens list
1070      */
1071     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1072         _allTokensIndex[tokenId] = _allTokens.length;
1073         _allTokens.push(tokenId);
1074     }
1075 
1076     /**
1077      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1078      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1079      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1080      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1081      * @param from address representing the previous owner of the given token ID
1082      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1083      */
1084     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1085         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1086         // then delete the last slot (swap and pop).
1087 
1088         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1089         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1090 
1091         // When the token to delete is the last token, the swap operation is unnecessary
1092         if (tokenIndex != lastTokenIndex) {
1093             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1094 
1095             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1096             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1097         }
1098 
1099         // This also deletes the contents at the last position of the array
1100         delete _ownedTokensIndex[tokenId];
1101         delete _ownedTokens[from][lastTokenIndex];
1102     }
1103 
1104     /**
1105      * @dev Private function to remove a token from this extension's token tracking data structures.
1106      * This has O(1) time complexity, but alters the order of the _allTokens array.
1107      * @param tokenId uint256 ID of the token to be removed from the tokens list
1108      */
1109     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1110         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1111         // then delete the last slot (swap and pop).
1112 
1113         uint256 lastTokenIndex = _allTokens.length - 1;
1114         uint256 tokenIndex = _allTokensIndex[tokenId];
1115 
1116         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1117         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1118         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1119         uint256 lastTokenId = _allTokens[lastTokenIndex];
1120 
1121         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1122         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1123 
1124         // This also deletes the contents at the last position of the array
1125         delete _allTokensIndex[tokenId];
1126         _allTokens.pop();
1127     }
1128 }
1129 
1130 // File: PandaParadise.sol
1131 
1132 contract PandaParadise is ERC721Enumerable, Ownable {
1133 
1134     using Strings for uint256;
1135 
1136     string _baseTokenURI;
1137     uint256 private _reserved = 88;
1138     uint256 private _price = 0.08 ether;
1139     bool public _paused = true;
1140     bool public _pausedPrivate = true;
1141     bool public sealedTokenURI;
1142     mapping(address => bool) private _privateSaleWhitelist;
1143 
1144 
1145 
1146     // withdraw addresses
1147     address t1 = 0xe8E8561d8a4965633af42B1A99F60ED81411A9B4;
1148     address t2 = 0x92B66F71ffC366b15a37Bd9C5D9aEFd753624a52;
1149 
1150     // 8888 Pandas in total
1151     constructor(string memory baseURI) ERC721("PandaParadise", "PPA")  {
1152         sealedTokenURI = false;
1153         setBaseURI(baseURI);
1154 
1155         // team gets the first Panda
1156         _safeMint( t1, 0);
1157     }
1158     
1159     function sealTokenURI() external onlyOwner {
1160         sealedTokenURI = true;
1161     }
1162 
1163     function mint(uint256 num) public payable {
1164         uint256 supply = totalSupply();
1165         require( !_paused,                              "Sale paused" );
1166         require( num < 19,                              "You can mint a maximum of 18 Paradise Pandas" );
1167         require( supply + num < 8889 - _reserved,       "Exceeds maximum Paradise Panda supply" );
1168         require( msg.value >= _price * num,             "Ether sent is not correct" );
1169 
1170         for(uint256 i; i < num; i++){
1171             _safeMint( msg.sender, supply + i );
1172         }
1173     }
1174 
1175     function privateMint(uint256 num) public payable {
1176         uint256 supply = totalSupply();
1177         require( !_pausedPrivate,                     "Private Sale paused" );
1178         require( num < 19,                            "You can mint a maximum of 18 Paradise Pandas" );
1179         require( supply + num < 8889 - _reserved,     "Exceeds maximum Paradise Panda supply" );
1180         require( msg.value >= _price * num,           "Ether sent is not correct" );
1181         require( isWhitelisted(msg.sender) == true,   "Not Whitelisted for private sale" );
1182         _privateSaleWhitelist[_msgSender()] = false;
1183 
1184         for(uint256 i; i < num; i++){
1185             _safeMint( msg.sender, supply + i );
1186         }
1187     }
1188 
1189     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1190         uint256 tokenCount = balanceOf(_owner);
1191 
1192         uint256[] memory tokensId = new uint256[](tokenCount);
1193         for(uint256 i; i < tokenCount; i++){
1194             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1195         }
1196         return tokensId;
1197     }
1198 
1199     // In case Eth fluctuates too much
1200     function setPrice(uint256 _newPrice) public onlyOwner() {
1201         _price = _newPrice;
1202     }
1203 
1204     function _baseURI() internal view virtual override returns (string memory) {
1205         return _baseTokenURI;
1206     }
1207 
1208     function setBaseURI(string memory baseURI) public onlyOwner {
1209         require(!sealedTokenURI, "baseURI is sealed");
1210         _baseTokenURI = baseURI;
1211     }
1212 
1213     function getPrice() public view returns (uint256){
1214         return _price;
1215     }
1216 
1217     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1218         require( _amount <= _reserved, "Exceeds reserved Panda Paradise supply" );
1219 
1220         uint256 supply = totalSupply();
1221         for(uint256 i; i < _amount; i++){
1222             _safeMint( _to, supply + i );
1223         }
1224 
1225         _reserved -= _amount;
1226     }
1227 
1228     function pause(bool val) public onlyOwner {
1229         _paused = val;
1230     }
1231 
1232     function pausePrivate(bool val) public onlyOwner {
1233         _pausedPrivate = val;
1234     }
1235 
1236     function withdrawAll() public payable onlyOwner {
1237         uint256 _amount1 = (address(this).balance * 99) / 100;
1238         require(payable(t1).send(_amount1));
1239 
1240         uint256 _amount2 = address(this).balance;
1241         require(payable(t2).send(_amount2));
1242     }
1243 
1244     function isWhitelisted(address _from) public view returns (bool) {
1245         return _privateSaleWhitelist[_from];
1246     }
1247     
1248     function updateWhitelist(address[] calldata whitelist) public onlyOwner {
1249         for (uint256 i = 0; i < whitelist.length; i++) {
1250             _privateSaleWhitelist[whitelist[i]] = true;
1251         }
1252     }
1253 
1254     fallback() external payable { }
1255     
1256     receive() external payable { }
1257 }
