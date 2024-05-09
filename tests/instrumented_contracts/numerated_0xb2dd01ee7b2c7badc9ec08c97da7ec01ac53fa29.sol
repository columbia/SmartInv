1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant alphabet = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = alphabet[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 
69 }
70 
71 
72 // File: @openzeppelin/contracts/utils/Address.sol
73 
74 /**
75  * @dev Collection of functions related to the address type
76  */
77 library Address {
78     /**
79      * @dev Returns true if `account` is a contract.
80      *
81      * [IMPORTANT]
82      * ====
83      * It is unsafe to assume that an address for which this function returns
84      * false is an externally-owned account (EOA) and not a contract.
85      *
86      * Among others, `isContract` will return false for the following
87      * types of addresses:
88      *
89      *  - an externally-owned account
90      *  - a contract in construction
91      *  - an address where a contract will be created
92      *  - an address where a contract lived, but was destroyed
93      * ====
94      */
95     function isContract(address account) internal view returns (bool) {
96         // This method relies on extcodesize, which returns 0 for contracts in
97         // construction, since the code is only stored at the end of the
98         // constructor execution.
99 
100         uint256 size;
101         // solhint-disable-next-line no-inline-assembly
102         assembly { size := extcodesize(account) }
103         return size > 0;
104     }
105 
106     /**
107      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
108      * `recipient`, forwarding all available gas and reverting on errors.
109      *
110      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
111      * of certain opcodes, possibly making contracts go over the 2300 gas limit
112      * imposed by `transfer`, making them unable to receive funds via
113      * `transfer`. {sendValue} removes this limitation.
114      *
115      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
116      *
117      * IMPORTANT: because control is transferred to `recipient`, care must be
118      * taken to not create reentrancy vulnerabilities. Consider using
119      * {ReentrancyGuard} or the
120      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
121      */
122     function sendValue(address payable recipient, uint256 amount) internal {
123         require(address(this).balance >= amount, "Address: insufficient balance");
124 
125         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
126         (bool success, ) = recipient.call{ value: amount }("");
127         require(success, "Address: unable to send value, recipient may have reverted");
128     }
129 
130     /**
131      * @dev Performs a Solidity function call using a low level `call`. A
132      * plain`call` is an unsafe replacement for a function call: use this
133      * function instead.
134      *
135      * If `target` reverts with a revert reason, it is bubbled up by this
136      * function (like regular Solidity function calls).
137      *
138      * Returns the raw returned data. To convert to the expected return value,
139      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
140      *
141      * Requirements:
142      *
143      * - `target` must be a contract.
144      * - calling `target` with `data` must not revert.
145      *
146      * _Available since v3.1._
147      */
148     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
149       return functionCall(target, data, "Address: low-level call failed");
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
154      * `errorMessage` as a fallback revert reason when `target` reverts.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
159         return functionCallWithValue(target, data, 0, errorMessage);
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
164      * but also transferring `value` wei to `target`.
165      *
166      * Requirements:
167      *
168      * - the calling contract must have an ETH balance of at least `value`.
169      * - the called Solidity function must be `payable`.
170      *
171      * _Available since v3.1._
172      */
173     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
179      * with `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
184         require(address(this).balance >= value, "Address: insufficient balance for call");
185         require(isContract(target), "Address: call to non-contract");
186 
187         // solhint-disable-next-line avoid-low-level-calls
188         (bool success, bytes memory returndata) = target.call{ value: value }(data);
189         return _verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
194      * but performing a static call.
195      *
196      * _Available since v3.3._
197      */
198     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
199         return functionStaticCall(target, data, "Address: low-level static call failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
204      * but performing a static call.
205      *
206      * _Available since v3.3._
207      */
208     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
209         require(isContract(target), "Address: static call to non-contract");
210 
211         // solhint-disable-next-line avoid-low-level-calls
212         (bool success, bytes memory returndata) = target.staticcall(data);
213         return _verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
218      * but performing a delegate call.
219      *
220      * _Available since v3.4._
221      */
222     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
223         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
228      * but performing a delegate call.
229      *
230      * _Available since v3.4._
231      */
232     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
233         require(isContract(target), "Address: delegate call to non-contract");
234 
235         // solhint-disable-next-line avoid-low-level-calls
236         (bool success, bytes memory returndata) = target.delegatecall(data);
237         return _verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
241         if (success) {
242             return returndata;
243         } else {
244             // Look for revert reason and bubble it up if present
245             if (returndata.length > 0) {
246                 // The easiest way to bubble the revert reason is using memory via assembly
247 
248                 // solhint-disable-next-line no-inline-assembly
249                 assembly {
250                     let returndata_size := mload(returndata)
251                     revert(add(32, returndata), returndata_size)
252                 }
253             } else {
254                 revert(errorMessage);
255             }
256         }
257     }
258 }
259 
260 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
261 
262 
263 /**
264  * @title ERC721 token receiver interface
265  * @dev Interface for any contract that wants to support safeTransfers
266  * from ERC721 asset contracts.
267  */
268 interface IERC721Receiver {
269     /**
270      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
271      * by `operator` from `from`, this function is called.
272      *
273      * It must return its Solidity selector to confirm the token transfer.
274      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
275      *
276      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
277      */
278     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
279 }
280 
281 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
282 
283 
284 /**
285  * @dev Interface of the ERC165 standard, as defined in the
286  * https://eips.ethereum.org/EIPS/eip-165[EIP].
287  *
288  * Implementers can declare support of contract interfaces, which can then be
289  * queried by others ({ERC165Checker}).
290  *
291  * For an implementation, see {ERC165}.
292  */
293 interface IERC165 {
294     /**
295      * @dev Returns true if this contract implements the interface defined by
296      * `interfaceId`. See the corresponding
297      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
298      * to learn more about how these ids are created.
299      *
300      * This function call must use less than 30 000 gas.
301      */
302     function supportsInterface(bytes4 interfaceId) external view returns (bool);
303 }
304 
305 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
306 
307 
308 
309 /**
310  * @dev Required interface of an ERC721 compliant contract.
311  */
312 interface IERC721 is IERC165 {
313     /**
314      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
315      */
316     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
317 
318     /**
319      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
320      */
321     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
322 
323     /**
324      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
325      */
326     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
327 
328     /**
329      * @dev Returns the number of tokens in ``owner``'s account.
330      */
331     function balanceOf(address owner) external view returns (uint256 balance);
332 
333     /**
334      * @dev Returns the owner of the `tokenId` token.
335      *
336      * Requirements:
337      *
338      * - `tokenId` must exist.
339      */
340     function ownerOf(uint256 tokenId) external view returns (address owner);
341 
342     /**
343      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
344      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
345      *
346      * Requirements:
347      *
348      * - `from` cannot be the zero address.
349      * - `to` cannot be the zero address.
350      * - `tokenId` token must exist and be owned by `from`.
351      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
352      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
353      *
354      * Emits a {Transfer} event.
355      */
356     function safeTransferFrom(address from, address to, uint256 tokenId) external;
357 
358     /**
359      * @dev Transfers `tokenId` token from `from` to `to`.
360      *
361      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
362      *
363      * Requirements:
364      *
365      * - `from` cannot be the zero address.
366      * - `to` cannot be the zero address.
367      * - `tokenId` token must be owned by `from`.
368      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
369      *
370      * Emits a {Transfer} event.
371      */
372     function transferFrom(address from, address to, uint256 tokenId) external;
373 
374     /**
375      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
376      * The approval is cleared when the token is transferred.
377      *
378      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
379      *
380      * Requirements:
381      *
382      * - The caller must own the token or be an approved operator.
383      * - `tokenId` must exist.
384      *
385      * Emits an {Approval} event.
386      */
387     function approve(address to, uint256 tokenId) external;
388 
389     /**
390      * @dev Returns the account approved for `tokenId` token.
391      *
392      * Requirements:
393      *
394      * - `tokenId` must exist.
395      */
396     function getApproved(uint256 tokenId) external view returns (address operator);
397 
398     /**
399      * @dev Approve or remove `operator` as an operator for the caller.
400      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
401      *
402      * Requirements:
403      *
404      * - The `operator` cannot be the caller.
405      *
406      * Emits an {ApprovalForAll} event.
407      */
408     function setApprovalForAll(address operator, bool _approved) external;
409 
410     /**
411      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
412      *
413      * See {setApprovalForAll}
414      */
415     function isApprovedForAll(address owner, address operator) external view returns (bool);
416 
417     /**
418       * @dev Safely transfers `tokenId` token from `from` to `to`.
419       *
420       * Requirements:
421       *
422       * - `from` cannot be the zero address.
423       * - `to` cannot be the zero address.
424       * - `tokenId` token must exist and be owned by `from`.
425       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
426       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
427       *
428       * Emits a {Transfer} event.
429       */
430     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
431 }
432 
433 
434 
435 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
436 
437 
438 
439 /**
440  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
441  * @dev See https://eips.ethereum.org/EIPS/eip-721
442  */
443 interface IERC721Enumerable is IERC721 {
444 
445     /**
446      * @dev Returns the total amount of tokens stored by the contract.
447      */
448     function totalSupply() external view returns (uint256);
449 
450     /**
451      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
452      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
453      */
454     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
455 
456     /**
457      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
458      * Use along with {totalSupply} to enumerate all tokens.
459      */
460     function tokenByIndex(uint256 index) external view returns (uint256);
461 }
462 
463 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
464 
465 
466 
467 /**
468  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
469  * @dev See https://eips.ethereum.org/EIPS/eip-721
470  */
471 interface IERC721Metadata is IERC721 {
472 
473     /**
474      * @dev Returns the token collection name.
475      */
476     function name() external view returns (string memory);
477 
478     /**
479      * @dev Returns the token collection symbol.
480      */
481     function symbol() external view returns (string memory);
482 
483     /**
484      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
485      */
486     function tokenURI(uint256 tokenId) external view returns (string memory);
487 }
488 
489 // File: @openzeppelin/contracts/utils/Context.sol
490 
491 
492 /*
493  * @dev Provides information about the current execution context, including the
494  * sender of the transaction and its data. While these are generally available
495  * via msg.sender and msg.data, they should not be accessed in such a direct
496  * manner, since when dealing with meta-transactions the account sending and
497  * paying for execution may not be the actual sender (as far as an application
498  * is concerned).
499  *
500  * This contract is only required for intermediate, library-like contracts.
501  */
502 abstract contract Context {
503     function _msgSender() internal view virtual returns (address) {
504         return msg.sender;
505     }
506 
507     function _msgData() internal view virtual returns (bytes calldata) {
508         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
509         return msg.data;
510     }
511 }
512 // File: @openzeppelin/contracts/access/Ownable.sol
513 
514 /**
515  * @dev Contract module which provides a basic access control mechanism, where
516  * there is an account (an owner) that can be granted exclusive access to
517  * specific functions.
518  *
519  * By default, the owner account will be the one that deploys the contract. This
520  * can later be changed with {transferOwnership}.
521  *
522  * This module is used through inheritance. It will make available the modifier
523  * `onlyOwner`, which can be applied to your functions to restrict their use to
524  * the owner.
525  */
526 abstract contract Ownable is Context {
527     address private _owner;
528 
529     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
530 
531     /**
532      * @dev Initializes the contract setting the deployer as the initial owner.
533      */
534     constructor () {
535         address msgSender = _msgSender();
536         _owner = msgSender;
537         emit OwnershipTransferred(address(0), msgSender);
538     }
539 
540     /**
541      * @dev Returns the address of the current owner.
542      */
543     function owner() public view virtual returns (address) {
544         return _owner;
545     }
546 
547     /**
548      * @dev Throws if called by any account other than the owner.
549      */
550     modifier onlyOwner() {
551         require(owner() == _msgSender(), "Ownable: caller is not the owner");
552         _;
553     }
554 
555     /**
556      * @dev Leaves the contract without owner. It will not be possible to call
557      * `onlyOwner` functions anymore. Can only be called by the current owner.
558      *
559      * NOTE: Renouncing ownership will leave the contract without an owner,
560      * thereby removing any functionality that is only available to the owner.
561      */
562     function renounceOwnership() public virtual onlyOwner {
563         emit OwnershipTransferred(_owner, address(0));
564         _owner = address(0);
565     }
566 
567     /**
568      * @dev Transfers ownership of the contract to a new account (`newOwner`).
569      * Can only be called by the current owner.
570      */
571     function transferOwnership(address newOwner) public virtual onlyOwner {
572         require(newOwner != address(0), "Ownable: new owner is the zero address");
573         emit OwnershipTransferred(_owner, newOwner);
574         _owner = newOwner;
575     }
576 }
577 
578 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
579 
580 
581 /**
582  * @dev Implementation of the {IERC165} interface.
583  *
584  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
585  * for the additional interface id that will be supported. For example:
586  *
587  * ```solidity
588  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
589  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
590  * }
591  * ```
592  *
593  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
594  */
595 abstract contract ERC165 is IERC165 {
596     /**
597      * @dev See {IERC165-supportsInterface}.
598      */
599     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
600         return interfaceId == type(IERC165).interfaceId;
601     }
602 }
603 
604 
605 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
606 
607 
608 /**
609  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
610  * the Metadata extension, but not including the Enumerable extension, which is available separately as
611  * {ERC721Enumerable}.
612  */
613 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
614     using Address for address;
615     using Strings for uint256;
616 
617     // Token name
618     string private _name;
619 
620     // Token symbol
621     string private _symbol;
622     
623     string private _baseURI;
624 
625     // Mapping from token ID to owner address
626     mapping (uint256 => address) private _owners;
627 
628     // Mapping owner address to token count
629     mapping (address => uint256) private _balances;
630 
631     // Mapping from token ID to approved address
632     mapping (uint256 => address) private _tokenApprovals;
633 
634     // Mapping from owner to operator approvals
635     mapping (address => mapping (address => bool)) private _operatorApprovals;
636 
637     /**
638      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
639      */
640     constructor (string memory name_, string memory symbol_) {
641         _name = name_;
642         _symbol = symbol_;
643     }
644 
645     /**
646      * @dev See {IERC165-supportsInterface}.
647      */
648     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
649         return interfaceId == type(IERC721).interfaceId
650             || interfaceId == type(IERC721Metadata).interfaceId
651             || super.supportsInterface(interfaceId);
652     }
653 
654     /**
655      * @dev See {IERC721-balanceOf}.
656      */
657     function balanceOf(address owner) public view virtual override returns (uint256) {
658         require(owner != address(0), "ERC721: balance query for the zero address");
659         return _balances[owner];
660     }
661 
662     /**
663      * @dev See {IERC721-ownerOf}.
664      */
665     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
666         address owner = _owners[tokenId];
667         require(owner != address(0), "ERC721: owner query for nonexistent token");
668         return owner;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-name}.
673      */
674     function name() public view virtual override returns (string memory) {
675         return _name;
676     }
677 
678     /**
679      * @dev See {IERC721Metadata-symbol}.
680      */
681     function symbol() public view virtual override returns (string memory) {
682         return _symbol;
683     }
684 
685     /**
686      * @dev See {IERC721Metadata-tokenURI}.
687      */
688     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
689         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
690 
691         string memory base = contractURI();
692         return bytes(base).length > 0
693             ? string(abi.encodePacked(base, tokenId.toString()))
694             : '';
695     }
696 
697 
698     /**
699     * @dev Returns the base URI set via {_setBaseURI}. This will be
700     * automatically added as a prefix in {tokenURI} to each token's URI, or
701     * to the token ID if no specific URI is set for that token ID.
702     */
703     function contractURI() public view virtual returns (string memory) {
704         return _baseURI;
705     }
706     
707     
708     /**
709      * @dev Internal function to set the base URI for all token IDs. It is
710      * automatically added as a prefix to the value returned in {tokenURI},
711      * or to the token ID if {tokenURI} is empty.
712      */
713     function _setBaseURI(string memory baseURI_) internal virtual {
714         _baseURI = baseURI_;
715     }
716 
717     /**
718      * @dev See {IERC721-approve}.
719      */
720     function approve(address to, uint256 tokenId) public virtual override {
721         address owner = ERC721.ownerOf(tokenId);
722         require(to != owner, "ERC721: approval to current owner");
723 
724         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
725             "ERC721: approve caller is not owner nor approved for all"
726         );
727 
728         _approve(to, tokenId);
729     }
730 
731     /**
732      * @dev See {IERC721-getApproved}.
733      */
734     function getApproved(uint256 tokenId) public view virtual override returns (address) {
735         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
736 
737         return _tokenApprovals[tokenId];
738     }
739 
740     /**
741      * @dev See {IERC721-setApprovalForAll}.
742      */
743     function setApprovalForAll(address operator, bool approved) public virtual override {
744         require(operator != _msgSender(), "ERC721: approve to caller");
745 
746         _operatorApprovals[_msgSender()][operator] = approved;
747         emit ApprovalForAll(_msgSender(), operator, approved);
748     }
749 
750     /**
751      * @dev See {IERC721-isApprovedForAll}.
752      */
753     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
754         return _operatorApprovals[owner][operator];
755     }
756 
757     /**
758      * @dev See {IERC721-transferFrom}.
759      */
760     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
761         //solhint-disable-next-line max-line-length
762         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
763 
764         _transfer(from, to, tokenId);
765     }
766 
767     /**
768      * @dev See {IERC721-safeTransferFrom}.
769      */
770     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
771         safeTransferFrom(from, to, tokenId, "");
772     }
773 
774     /**
775      * @dev See {IERC721-safeTransferFrom}.
776      */
777     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
778         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
779         _safeTransfer(from, to, tokenId, _data);
780     }
781 
782     /**
783      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
784      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
785      *
786      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
787      *
788      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
789      * implement alternative mechanisms to perform token transfer, such as signature-based.
790      *
791      * Requirements:
792      *
793      * - `from` cannot be the zero address.
794      * - `to` cannot be the zero address.
795      * - `tokenId` token must exist and be owned by `from`.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
801         _transfer(from, to, tokenId);
802         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
803     }
804 
805     /**
806      * @dev Returns whether `tokenId` exists.
807      *
808      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
809      *
810      * Tokens start existing when they are minted (`_mint`),
811      * and stop existing when they are burned (`_burn`).
812      */
813     function _exists(uint256 tokenId) internal view virtual returns (bool) {
814         return _owners[tokenId] != address(0);
815     }
816 
817     /**
818      * @dev Returns whether `spender` is allowed to manage `tokenId`.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must exist.
823      */
824     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
825         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
826         address owner = ERC721.ownerOf(tokenId);
827         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
828     }
829 
830     /**
831      * @dev Safely mints `tokenId` and transfers it to `to`.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must not exist.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _safeMint(address to, uint256 tokenId) internal virtual {
841         _safeMint(to, tokenId, "");
842     }
843 
844     /**
845      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
846      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
847      */
848     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
849         _mint(to, tokenId);
850         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
851     }
852 
853     /**
854      * @dev Mints `tokenId` and transfers it to `to`.
855      *
856      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
857      *
858      * Requirements:
859      *
860      * - `tokenId` must not exist.
861      * - `to` cannot be the zero address.
862      *
863      * Emits a {Transfer} event.
864      */
865     function _mint(address to, uint256 tokenId) internal virtual {
866         require(to != address(0), "ERC721: mint to the zero address");
867         require(!_exists(tokenId), "ERC721: token already minted");
868 
869         _beforeTokenTransfer(address(0), to, tokenId);
870 
871         _balances[to] += 1;
872         _owners[tokenId] = to;
873 
874         emit Transfer(address(0), to, tokenId);
875     }
876 
877     /**
878      * @dev Destroys `tokenId`.
879      * The approval is cleared when the token is burned.
880      *
881      * Requirements:
882      *
883      * - `tokenId` must exist.
884      *
885      * Emits a {Transfer} event.
886      */
887     function _burn(uint256 tokenId) internal virtual {
888         address owner = ERC721.ownerOf(tokenId);
889 
890         _beforeTokenTransfer(owner, address(0), tokenId);
891 
892         // Clear approvals
893         _approve(address(0), tokenId);
894 
895         _balances[owner] -= 1;
896         delete _owners[tokenId];
897 
898         emit Transfer(owner, address(0), tokenId);
899     }
900 
901     /**
902      * @dev Transfers `tokenId` from `from` to `to`.
903      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
904      *
905      * Requirements:
906      *
907      * - `to` cannot be the zero address.
908      * - `tokenId` token must be owned by `from`.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _transfer(address from, address to, uint256 tokenId) internal virtual {
913         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
914         require(to != address(0), "ERC721: transfer to the zero address");
915 
916         _beforeTokenTransfer(from, to, tokenId);
917 
918         // Clear approvals from the previous owner
919         _approve(address(0), tokenId);
920 
921         _balances[from] -= 1;
922         _balances[to] += 1;
923         _owners[tokenId] = to;
924 
925         emit Transfer(from, to, tokenId);
926     }
927 
928     /**
929      * @dev Approve `to` to operate on `tokenId`
930      *
931      * Emits a {Approval} event.
932      */
933     function _approve(address to, uint256 tokenId) internal virtual {
934         _tokenApprovals[tokenId] = to;
935         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
936     }
937 
938     /**
939      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
940      * The call is not executed if the target address is not a contract.
941      *
942      * @param from address representing the previous owner of the given token ID
943      * @param to target address that will receive the tokens
944      * @param tokenId uint256 ID of the token to be transferred
945      * @param _data bytes optional data to send along with the call
946      * @return bool whether the call correctly returned the expected magic value
947      */
948     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
949         private returns (bool)
950     {
951         if (to.isContract()) {
952             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
953                 return retval == IERC721Receiver(to).onERC721Received.selector;
954             } catch (bytes memory reason) {
955                 if (reason.length == 0) {
956                     revert("ERC721: transfer to non ERC721Receiver implementer");
957                 } else {
958                     // solhint-disable-next-line no-inline-assembly
959                     assembly {
960                         revert(add(32, reason), mload(reason))
961                     }
962                 }
963             }
964         } else {
965             return true;
966         }
967     }
968 
969     /**
970      * @dev Hook that is called before any token transfer. This includes minting
971      * and burning.
972      *
973      * Calling conditions:
974      *
975      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
976      * transferred to `to`.
977      * - When `from` is zero, `tokenId` will be minted for `to`.
978      * - When `to` is zero, ``from``'s `tokenId` will be burned.
979      * - `from` cannot be the zero address.
980      * - `to` cannot be the zero address.
981      *
982      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
983      */
984     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
985 }
986 
987 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
988 
989 
990 
991 /**
992  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
993  * enumerability of all the token ids in the contract as well as all token ids owned by each
994  * account.
995  */
996 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
997     // Mapping from owner to list of owned token IDs
998     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
999 
1000     // Mapping from token ID to index of the owner tokens list
1001     mapping(uint256 => uint256) private _ownedTokensIndex;
1002 
1003     // Array with all token ids, used for enumeration
1004     uint256[] private _allTokens;
1005 
1006     // Mapping from token id to position in the allTokens array
1007     mapping(uint256 => uint256) private _allTokensIndex;
1008 
1009     /**
1010      * @dev See {IERC165-supportsInterface}.
1011      */
1012     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1013         return interfaceId == type(IERC721Enumerable).interfaceId
1014             || super.supportsInterface(interfaceId);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1019      */
1020     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1021         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1022         return _ownedTokens[owner][index];
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Enumerable-totalSupply}.
1027      */
1028     function totalSupply() public view virtual override returns (uint256) {
1029         return _allTokens.length;
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Enumerable-tokenByIndex}.
1034      */
1035     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1036         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1037         return _allTokens[index];
1038     }
1039 
1040     /**
1041      * @dev Hook that is called before any token transfer. This includes minting
1042      * and burning.
1043      *
1044      * Calling conditions:
1045      *
1046      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1047      * transferred to `to`.
1048      * - When `from` is zero, `tokenId` will be minted for `to`.
1049      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1050      * - `from` cannot be the zero address.
1051      * - `to` cannot be the zero address.
1052      *
1053      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1054      */
1055     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1056         super._beforeTokenTransfer(from, to, tokenId);
1057 
1058         if (from == address(0)) {
1059             _addTokenToAllTokensEnumeration(tokenId);
1060         } else if (from != to) {
1061             _removeTokenFromOwnerEnumeration(from, tokenId);
1062         }
1063         if (to == address(0)) {
1064             _removeTokenFromAllTokensEnumeration(tokenId);
1065         } else if (to != from) {
1066             _addTokenToOwnerEnumeration(to, tokenId);
1067         }
1068     }
1069 
1070     /**
1071      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1072      * @param to address representing the new owner of the given token ID
1073      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1074      */
1075     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1076         uint256 length = ERC721.balanceOf(to);
1077         _ownedTokens[to][length] = tokenId;
1078         _ownedTokensIndex[tokenId] = length;
1079     }
1080 
1081     /**
1082      * @dev Private function to add a token to this extension's token tracking data structures.
1083      * @param tokenId uint256 ID of the token to be added to the tokens list
1084      */
1085     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1086         _allTokensIndex[tokenId] = _allTokens.length;
1087         _allTokens.push(tokenId);
1088     }
1089 
1090     /**
1091      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1092      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1093      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1094      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1095      * @param from address representing the previous owner of the given token ID
1096      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1097      */
1098     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1099         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1100         // then delete the last slot (swap and pop).
1101 
1102         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1103         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1104 
1105         // When the token to delete is the last token, the swap operation is unnecessary
1106         if (tokenIndex != lastTokenIndex) {
1107             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1108 
1109             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1110             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1111         }
1112 
1113         // This also deletes the contents at the last position of the array
1114         delete _ownedTokensIndex[tokenId];
1115         delete _ownedTokens[from][lastTokenIndex];
1116     }
1117 
1118     /**
1119      * @dev Private function to remove a token from this extension's token tracking data structures.
1120      * This has O(1) time complexity, but alters the order of the _allTokens array.
1121      * @param tokenId uint256 ID of the token to be removed from the tokens list
1122      */
1123     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1124         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1125         // then delete the last slot (swap and pop).
1126 
1127         uint256 lastTokenIndex = _allTokens.length - 1;
1128         uint256 tokenIndex = _allTokensIndex[tokenId];
1129 
1130         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1131         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1132         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1133         uint256 lastTokenId = _allTokens[lastTokenIndex];
1134 
1135         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1136         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1137 
1138         // This also deletes the contents at the last position of the array
1139         delete _allTokensIndex[tokenId];
1140         _allTokens.pop();
1141     }
1142 }
1143 
1144 // File: contract-182924bc6f.sol
1145 
1146 
1147 
1148 contract Dinox is ERC721, ERC721Enumerable, Ownable, IERC721Receiver {
1149     constructor() ERC721("DINOX", "DNX") {}
1150 
1151     mapping (uint256 => uint256) private _parentsA;
1152     mapping (uint256 => uint256) private _parentsB;
1153     mapping (uint256 => bool) private _isParent;
1154     mapping (uint256 => uint16) private _gs;
1155 
1156     mapping (uint16 => uint16) private _gsSupply;    
1157     mapping (uint16 => uint16) private _gsCap;
1158     mapping (uint16 => uint256) private _gsStartTokenId;
1159     mapping (uint16 => uint16) private _gsBracketSizes;
1160     mapping (uint16 => uint16) private _gsBrackets;
1161     mapping (uint16 => uint256) private _gsPrices;
1162     mapping (uint16 => uint) private _gsStartTime;    
1163     mapping (uint16 => uint) private _gsEndTime;
1164     mapping (uint16 => uint256) private _postgsPrice;
1165 
1166     address private _breeder;
1167     bool private _breedingEnabled = false;
1168     bool private _salesEnabled = false;
1169     
1170     function buyDNX(uint16 gid, uint16 count) public payable {
1171         require(_salesEnabled, "E01");
1172         require(block.timestamp > _gsStartTime[gid], "E02");
1173         require(block.timestamp < _gsEndTime[gid], "E03");
1174         require(count > 0 && count <= 10, "E04");
1175         require(_gsSupply[gid] + count <= _gsCap[gid], "E05");
1176         require(msg.value >= calculatePrice(gid,count), "E06");
1177 
1178         for (uint i = 0; i < count; i++) {
1179             uint mintIndex = _gsSupply[gid] + _gsStartTokenId[gid] + i;
1180             _safeMint(msg.sender, mintIndex);
1181             _gs[mintIndex] = gid;
1182         }
1183         _gsSupply[gid] += count;
1184     }
1185     
1186     function lateBuyDNX(uint16 gid, uint16 count) public payable {
1187         require(_salesEnabled, "E01");
1188         require(block.timestamp > _gsEndTime[gid], "E12");
1189         require(count > 0 && count <= 10, "E04");
1190         require(_postgsPrice[gid] > 0, "E07");
1191         require(_gsSupply[gid] + count <= _gsCap[gid], "E05");
1192         require(msg.value >= _postgsPrice[gid]*count, "E06");
1193 
1194         for (uint i = 0; i < count; i++) {
1195             uint mintIndex = _gsSupply[gid] + _gsStartTokenId[gid] + i;
1196             _safeMint(msg.sender, mintIndex);
1197             _gs[mintIndex] = gid;
1198         }
1199         _gsSupply[gid] += count;
1200     }
1201     
1202     function breedDNX(uint256 parentA, uint256 parentB, uint256 tokenId, uint16 resolvedGen, address to) public {
1203         require(_breedingEnabled, "E08");
1204         require(msg.sender == _breeder, "E09");
1205         require(ownerOf(parentA) == to && ownerOf(parentB) == to, "E10");
1206         require(!_isParent[parentA] && !_isParent[parentB], "E11");
1207         _safeMint(to, tokenId);
1208         _parentsA[tokenId] = parentA;
1209         _parentsB[tokenId] = parentB;
1210         _isParent[parentA] = true;        
1211         _isParent[parentB] = true;
1212         _gs[tokenId] = resolvedGen;
1213     }
1214     
1215     function calculatePrice(uint16 gid, uint16 count) public view returns (uint256) {
1216         require(block.timestamp > _gsStartTime[gid], "E02");
1217         require(block.timestamp < _gsEndTime[gid], "E03");
1218         require(_gsSupply[gid] < _gsCap[gid], "E13");
1219 
1220         uint16 sb = 0;
1221         uint16 eb = 0;
1222         uint16 i;
1223         for (i = 0; i <= gid; i++) {
1224             if (i < gid) {
1225                 sb += _gsBracketSizes[i];
1226             }
1227             eb += _gsBracketSizes[i];
1228         }
1229         
1230         uint16 pi = 0;
1231         uint256 sf = 0;
1232         for (i = sb; i < eb; i++) {
1233             sf += _gsBrackets[i];
1234             if (sf > _gsSupply[gid]) {
1235                 pi = i+1;
1236                 break;
1237             }
1238         }
1239         
1240         require(pi > 0, "E14");
1241         
1242         return _gsPrices[pi-1]*count;
1243     }
1244     
1245     function reserveForGiveaway(uint16 gid, uint16 count) public onlyOwner {
1246         for (uint i = 0; i < count; i++) {
1247             uint mintIndex = _gsSupply[gid] + _gsStartTokenId[gid] + i;
1248             _safeMint(msg.sender, mintIndex);
1249             _gs[mintIndex] = gid;
1250         }
1251         _gsSupply[gid] += count;
1252     }
1253     
1254     function changeGSCap(uint16 gid, uint16 supply) public onlyOwner {
1255         _gsCap[gid] = supply;
1256         _gsSupply[gid] = 0;
1257     }
1258     
1259     function changeGSStartToken(uint16 gid, uint256 tokenId) public onlyOwner {
1260         _gsStartTokenId[gid] = tokenId;
1261     }
1262     
1263     function changeGSBracketSizes(uint16 gid, uint16 bracketSize) public onlyOwner {
1264         _gsBracketSizes[gid] = bracketSize;
1265     }
1266     
1267     function changeGSBrackets(uint16 bracketId, uint16 bracketTokenCount) public onlyOwner {
1268         _gsBrackets[bracketId] = bracketTokenCount;
1269     }
1270     
1271     function changeGSBracketPrice(uint16 bid, uint256 p) public onlyOwner {
1272         _gsPrices[bid] = p;
1273     }
1274     
1275     function changeGSPostPrice(uint16 gid, uint256 p) public onlyOwner {
1276         _postgsPrice[gid] = p;
1277     }
1278     
1279     function changeGSTime(uint16 gid, uint st, uint et) public onlyOwner {
1280         _gsStartTime[gid] = st;
1281         _gsEndTime[gid] = et;
1282     }
1283     
1284     function toggleSales() public onlyOwner {
1285         _salesEnabled = !_salesEnabled;
1286     }
1287     
1288     function toggleBreeding() public onlyOwner {
1289         _breedingEnabled = !_breedingEnabled;
1290     }
1291     
1292     function getPA(uint256 tokenId) public view returns (uint256) {
1293         return _parentsA[tokenId];
1294     }
1295     
1296     function getPB(uint256 tokenId) public view returns (uint256) {
1297         return _parentsB[tokenId];
1298     }
1299     
1300     function getIsP(uint256 tokenId) public view returns (bool) {
1301         return _isParent[tokenId];
1302     }
1303     
1304     function getTG(uint256 tokenId) public view returns (uint16) {
1305         return _gs[tokenId];
1306     }
1307     
1308     function getGSSupply(uint16 gid) public view returns (uint16) {
1309         return _gsSupply[gid];
1310     }
1311     
1312     function getGSCap(uint16 gid) public view returns (uint16) {
1313         return _gsCap[gid];
1314     }
1315     
1316     function setBreederAddress(address breeder) public onlyOwner {
1317         _breeder = breeder;
1318     }
1319     
1320     function setBaseURI(string memory baseURI) public onlyOwner {
1321         _setBaseURI(baseURI);
1322     }
1323     
1324     function withdrawAll() public payable onlyOwner {
1325         require(payable(msg.sender).send(address(this).balance));
1326     }
1327 
1328     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1329         uint256 tokenCount = balanceOf(_owner);
1330         if (tokenCount == 0) {
1331             return new uint256[](0);
1332         } else {
1333             uint256[] memory result = new uint256[](tokenCount);
1334             uint256 index;
1335             for (index = 0; index < tokenCount; index++) {
1336                 result[index] = tokenOfOwnerByIndex(_owner, index);
1337             }
1338             return result;
1339         }
1340     }
1341     
1342     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1343         internal
1344         override(ERC721, ERC721Enumerable)
1345     {
1346         super._beforeTokenTransfer(from, to, tokenId);
1347     }
1348 
1349     function supportsInterface(bytes4 interfaceId)
1350         public
1351         view
1352         override(ERC721, ERC721Enumerable)
1353         returns (bool)
1354     {
1355         return super.supportsInterface(interfaceId);
1356     }
1357     
1358     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
1359         return this.onERC721Received.selector;
1360     }
1361 }