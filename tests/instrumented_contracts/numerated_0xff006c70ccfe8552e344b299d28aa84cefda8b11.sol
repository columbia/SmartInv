1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-28
3 */
4 
5 // libraries
6 
7 // Address.sol
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Collection of functions related to the address type
15  */
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]
21      * ====
22      * It is unsafe to assume that an address for which this function returns
23      * false is an externally-owned account (EOA) and not a contract.
24      *
25      * Among others, `isContract` will return false for the following
26      * types of addresses:
27      *
28      *  - an externally-owned account
29      *  - a contract in construction
30      *  - an address where a contract will be created
31      *  - an address where a contract lived, but was destroyed
32      * ====
33      */
34     function isContract(address account) internal view returns (bool) {
35         // This method relies on extcodesize, which returns 0 for contracts in
36         // construction, since the code is only stored at the end of the
37         // constructor execution.
38 
39         uint256 size;
40         // solhint-disable-next-line no-inline-assembly
41         assembly { size := extcodesize(account) }
42         return size > 0;
43     }
44 
45     /**
46      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
47      * `recipient`, forwarding all available gas and reverting on errors.
48      *
49      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
50      * of certain opcodes, possibly making contracts go over the 2300 gas limit
51      * imposed by `transfer`, making them unable to receive funds via
52      * `transfer`. {sendValue} removes this limitation.
53      *
54      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
55      *
56      * IMPORTANT: because control is transferred to `recipient`, care must be
57      * taken to not create reentrancy vulnerabilities. Consider using
58      * {ReentrancyGuard} or the
59      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
60      */
61     function sendValue(address payable recipient, uint256 amount) internal {
62         require(address(this).balance >= amount, "Address: insufficient balance");
63 
64         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
65         (bool success, ) = recipient.call{ value: amount }("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain`call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88       return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but also transferring `value` wei to `target`.
104      *
105      * Requirements:
106      *
107      * - the calling contract must have an ETH balance of at least `value`.
108      * - the called Solidity function must be `payable`.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
113         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
114     }
115 
116     /**
117      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
118      * with `errorMessage` as a fallback revert reason when `target` reverts.
119      *
120      * _Available since v3.1._
121      */
122     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
123         require(address(this).balance >= value, "Address: insufficient balance for call");
124         require(isContract(target), "Address: call to non-contract");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{ value: value }(data);
128         return _verifyCallResult(success, returndata, errorMessage);
129     }
130 
131     /**
132      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
133      * but performing a static call.
134      *
135      * _Available since v3.3._
136      */
137     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
138         return functionStaticCall(target, data, "Address: low-level static call failed");
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
143      * but performing a static call.
144      *
145      * _Available since v3.3._
146      */
147     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
148         require(isContract(target), "Address: static call to non-contract");
149 
150         // solhint-disable-next-line avoid-low-level-calls
151         (bool success, bytes memory returndata) = target.staticcall(data);
152         return _verifyCallResult(success, returndata, errorMessage);
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
157      * but performing a delegate call.
158      *
159      * _Available since v3.4._
160      */
161     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
162         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
167      * but performing a delegate call.
168      *
169      * _Available since v3.4._
170      */
171     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
172         require(isContract(target), "Address: delegate call to non-contract");
173 
174         // solhint-disable-next-line avoid-low-level-calls
175         (bool success, bytes memory returndata) = target.delegatecall(data);
176         return _verifyCallResult(success, returndata, errorMessage);
177     }
178 
179     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
180         if (success) {
181             return returndata;
182         } else {
183             // Look for revert reason and bubble it up if present
184             if (returndata.length > 0) {
185                 // The easiest way to bubble the revert reason is using memory via assembly
186 
187                 // solhint-disable-next-line no-inline-assembly
188                 assembly {
189                     let returndata_size := mload(returndata)
190                     revert(add(32, returndata), returndata_size)
191                 }
192             } else {
193                 revert(errorMessage);
194             }
195         }
196     }
197 }
198 
199 // Strings.sol
200 
201 pragma solidity ^0.8.0;
202 
203 /**
204  * @dev String operations.
205  */
206 library Strings {
207     bytes16 private constant alphabet = "0123456789abcdef";
208 
209     /**
210      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
211      */
212     function toString(uint256 value) internal pure returns (string memory) {
213         // Inspired by OraclizeAPI's implementation - MIT licence
214         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
215 
216         if (value == 0) {
217             return "0";
218         }
219         uint256 temp = value;
220         uint256 digits;
221         while (temp != 0) {
222             digits++;
223             temp /= 10;
224         }
225         bytes memory buffer = new bytes(digits);
226         while (value != 0) {
227             digits -= 1;
228             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
229             value /= 10;
230         }
231         return string(buffer);
232     }
233 
234     /**
235      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
236      */
237     function toHexString(uint256 value) internal pure returns (string memory) {
238         if (value == 0) {
239             return "0x00";
240         }
241         uint256 temp = value;
242         uint256 length = 0;
243         while (temp != 0) {
244             length++;
245             temp >>= 8;
246         }
247         return toHexString(value, length);
248     }
249 
250     /**
251      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
252      */
253     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
254         bytes memory buffer = new bytes(2 * length + 2);
255         buffer[0] = "0";
256         buffer[1] = "x";
257         for (uint256 i = 2 * length + 1; i > 1; --i) {
258             buffer[i] = alphabet[value & 0xf];
259             value >>= 4;
260         }
261         require(value == 0, "Strings: hex length insufficient");
262         return string(buffer);
263     }
264 
265 }
266 
267 // interfaces
268 
269 // IERC165.sol
270 
271 pragma solidity ^0.8.0;
272 
273 /**
274  * @dev Interface of the ERC165 standard, as defined in the
275  * https://eips.ethereum.org/EIPS/eip-165[EIP].
276  *
277  * Implementers can declare support of contract interfaces, which can then be
278  * queried by others ({ERC165Checker}).
279  *
280  * For an implementation, see {ERC165}.
281  */
282 interface IERC165 {
283     /**
284      * @dev Returns true if this contract implements the interface defined by
285      * `interfaceId`. See the corresponding
286      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
287      * to learn more about how these ids are created.
288      *
289      * This function call must use less than 30 000 gas.
290      */
291     function supportsInterface(bytes4 interfaceId) external view returns (bool);
292 }
293 
294 // IERC721.sol
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @dev Required interface of an ERC721 compliant contract.
300  */
301 interface IERC721 is IERC165 {
302     /**
303      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
304      */
305     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
306 
307     /**
308      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
309      */
310     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
311 
312     /**
313      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
314      */
315     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
316 
317     /**
318      * @dev Returns the number of tokens in ``owner``'s account.
319      */
320     function balanceOf(address owner) external view returns (uint256 balance);
321 
322     /**
323      * @dev Returns the owner of the `tokenId` token.
324      *
325      * Requirements:
326      *
327      * - `tokenId` must exist.
328      */
329     function ownerOf(uint256 tokenId) external view returns (address owner);
330 
331     /**
332      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
333      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
334      *
335      * Requirements:
336      *
337      * - `from` cannot be the zero address.
338      * - `to` cannot be the zero address.
339      * - `tokenId` token must exist and be owned by `from`.
340      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
341      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
342      *
343      * Emits a {Transfer} event.
344      */
345     function safeTransferFrom(address from, address to, uint256 tokenId) external;
346 
347     /**
348      * @dev Transfers `tokenId` token from `from` to `to`.
349      *
350      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
351      *
352      * Requirements:
353      *
354      * - `from` cannot be the zero address.
355      * - `to` cannot be the zero address.
356      * - `tokenId` token must be owned by `from`.
357      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
358      *
359      * Emits a {Transfer} event.
360      */
361     function transferFrom(address from, address to, uint256 tokenId) external;
362 
363     /**
364      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
365      * The approval is cleared when the token is transferred.
366      *
367      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
368      *
369      * Requirements:
370      *
371      * - The caller must own the token or be an approved operator.
372      * - `tokenId` must exist.
373      *
374      * Emits an {Approval} event.
375      */
376     function approve(address to, uint256 tokenId) external;
377 
378     /**
379      * @dev Returns the account approved for `tokenId` token.
380      *
381      * Requirements:
382      *
383      * - `tokenId` must exist.
384      */
385     function getApproved(uint256 tokenId) external view returns (address operator);
386 
387     /**
388      * @dev Approve or remove `operator` as an operator for the caller.
389      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
390      *
391      * Requirements:
392      *
393      * - The `operator` cannot be the caller.
394      *
395      * Emits an {ApprovalForAll} event.
396      */
397     function setApprovalForAll(address operator, bool _approved) external;
398 
399     /**
400      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
401      *
402      * See {setApprovalForAll}
403      */
404     function isApprovedForAll(address owner, address operator) external view returns (bool);
405 
406     /**
407       * @dev Safely transfers `tokenId` token from `from` to `to`.
408       *
409       * Requirements:
410       *
411       * - `from` cannot be the zero address.
412       * - `to` cannot be the zero address.
413       * - `tokenId` token must exist and be owned by `from`.
414       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
415       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
416       *
417       * Emits a {Transfer} event.
418       */
419     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
420 }
421 
422 // IERC721Metadata.sol
423 
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
428  * @dev See https://eips.ethereum.org/EIPS/eip-721
429  */
430 interface IERC721Metadata is IERC721 {
431 
432     /**
433      * @dev Returns the token collection name.
434      */
435     function name() external view returns (string memory);
436 
437     /**
438      * @dev Returns the token collection symbol.
439      */
440     function symbol() external view returns (string memory);
441 
442     /**
443      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
444      */
445     function tokenURI(uint256 tokenId) external view returns (string memory);
446 }
447 
448 // IERCEnumerable.sol
449 
450 pragma solidity ^0.8.0;
451 
452 /**
453  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
454  * @dev See https://eips.ethereum.org/EIPS/eip-721
455  */
456 interface IERC721Enumerable is IERC721 {
457 
458     /**
459      * @dev Returns the total amount of tokens stored by the contract.
460      */
461     function totalSupply() external view returns (uint256);
462 
463     /**
464      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
465      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
466      */
467     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
468 
469     /**
470      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
471      * Use along with {totalSupply} to enumerate all tokens.
472      */
473     function tokenByIndex(uint256 index) external view returns (uint256);
474 }
475 
476 // IERCReceiver.sol
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @title ERC721 token receiver interface
482  * @dev Interface for any contract that wants to support safeTransfers
483  * from ERC721 asset contracts.
484  */
485 interface IERC721Receiver {
486     /**
487      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
488      * by `operator` from `from`, this function is called.
489      *
490      * It must return its Solidity selector to confirm the token transfer.
491      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
492      *
493      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
494      */
495     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
496 }
497 
498 // contracts
499 
500 // Context.sol
501 
502 pragma solidity ^0.8.0;
503 
504 /*
505  * @dev Provides information about the current execution context, including the
506  * sender of the transaction and its data. While these are generally available
507  * via msg.sender and msg.data, they should not be accessed in such a direct
508  * manner, since when dealing with meta-transactions the account sending and
509  * paying for execution may not be the actual sender (as far as an application
510  * is concerned).
511  *
512  * This contract is only required for intermediate, library-like contracts.
513  */
514 abstract contract Context {
515     function _msgSender() internal view virtual returns (address) {
516         return msg.sender;
517     }
518 
519     function _msgData() internal view virtual returns (bytes calldata) {
520         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
521         return msg.data;
522     }
523 }
524 
525 // Ownable.sol
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev Contract module which provides a basic access control mechanism, where
531  * there is an account (an owner) that can be granted exclusive access to
532  * specific functions.
533  *
534  * By default, the owner account will be the one that deploys the contract. This
535  * can later be changed with {transferOwnership}.
536  *
537  * This module is used through inheritance. It will make available the modifier
538  * `onlyOwner`, which can be applied to your functions to restrict their use to
539  * the owner.
540  */
541 abstract contract Ownable is Context {
542     address private _owner;
543 
544     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
545 
546     /**
547      * @dev Initializes the contract setting the deployer as the initial owner.
548      */
549     constructor () {
550         address msgSender = _msgSender();
551         _owner = msgSender;
552         emit OwnershipTransferred(address(0), msgSender);
553     }
554 
555     /**
556      * @dev Returns the address of the current owner.
557      */
558     function owner() public view virtual returns (address) {
559         return _owner;
560     }
561 
562     /**
563      * @dev Throws if called by any account other than the owner.
564      */
565     modifier onlyOwner() {
566         require(owner() == _msgSender(), "Ownable: caller is not the owner");
567         _;
568     }
569 
570     /**
571      * @dev Leaves the contract without owner. It will not be possible to call
572      * `onlyOwner` functions anymore. Can only be called by the current owner.
573      *
574      * NOTE: Renouncing ownership will leave the contract without an owner,
575      * thereby removing any functionality that is only available to the owner.
576      */
577     function renounceOwnership() public virtual onlyOwner {
578         emit OwnershipTransferred(_owner, address(0));
579         _owner = address(0);
580     }
581 
582     /**
583      * @dev Transfers ownership of the contract to a new account (`newOwner`).
584      * Can only be called by the current owner.
585      */
586     function transferOwnership(address newOwner) public virtual onlyOwner {
587         require(newOwner != address(0), "Ownable: new owner is the zero address");
588         emit OwnershipTransferred(_owner, newOwner);
589         _owner = newOwner;
590     }
591 }
592 
593 // ERC165.sol
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Implementation of the {IERC165} interface.
599  *
600  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
601  * for the additional interface id that will be supported. For example:
602  *
603  * ```solidity
604  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
605  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
606  * }
607  * ```
608  *
609  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
610  */
611 abstract contract ERC165 is IERC165 {
612     /**
613      * @dev See {IERC165-supportsInterface}.
614      */
615     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
616         return interfaceId == type(IERC165).interfaceId;
617     }
618 }
619 
620 // ERC721.sol
621 
622 pragma solidity ^0.8.0;
623 
624 /**
625  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
626  * the Metadata extension, but not including the Enumerable extension, which is available separately as
627  * {ERC721Enumerable}.
628  */
629 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
630     using Address for address;
631     using Strings for uint256;
632 
633     // Token name
634     string private _name;
635 
636     // Token symbol
637     string private _symbol;
638 
639     // Mapping from token ID to owner address
640     mapping (uint256 => address) private _owners;
641 
642     // Mapping owner address to token count
643     mapping (address => uint256) private _balances;
644 
645     // Mapping from token ID to approved address
646     mapping (uint256 => address) private _tokenApprovals;
647 
648     // Mapping from owner to operator approvals
649     mapping (address => mapping (address => bool)) private _operatorApprovals;
650 
651     /**
652      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
653      */
654     constructor (string memory name_, string memory symbol_) {
655         _name = name_;
656         _symbol = symbol_;
657     }
658 
659     /**
660      * @dev See {IERC165-supportsInterface}.
661      */
662     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
663         return interfaceId == type(IERC721).interfaceId
664             || interfaceId == type(IERC721Metadata).interfaceId
665             || super.supportsInterface(interfaceId);
666     }
667 
668     /**
669      * @dev See {IERC721-balanceOf}.
670      */
671     function balanceOf(address owner) public view virtual override returns (uint256) {
672         require(owner != address(0), "ERC721: balance query for the zero address");
673         return _balances[owner];
674     }
675 
676     /**
677      * @dev See {IERC721-ownerOf}.
678      */
679     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
680         address owner = _owners[tokenId];
681         require(owner != address(0), "ERC721: owner query for nonexistent token");
682         return owner;
683     }
684 
685     /**
686      * @dev See {IERC721Metadata-name}.
687      */
688     function name() public view virtual override returns (string memory) {
689         return _name;
690     }
691 
692     /**
693      * @dev See {IERC721Metadata-symbol}.
694      */
695     function symbol() public view virtual override returns (string memory) {
696         return _symbol;
697     }
698 
699     /**
700      * @dev See {IERC721Metadata-tokenURI}.
701      */
702     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
703         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
704 
705         string memory baseURI = _baseURI();
706         return bytes(baseURI).length > 0
707             ? string(abi.encodePacked(baseURI, tokenId.toString()))
708             : '';
709     }
710 
711     /**
712      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
713      * in child contracts.
714      */
715     function _baseURI() internal view virtual returns (string memory) {
716         return "";
717     }
718 
719     /**
720      * @dev See {IERC721-approve}.
721      */
722     function approve(address to, uint256 tokenId) public virtual override {
723         address owner = ERC721.ownerOf(tokenId);
724         require(to != owner, "ERC721: approval to current owner");
725 
726         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
727             "ERC721: approve caller is not owner nor approved for all"
728         );
729 
730         _approve(to, tokenId);
731     }
732 
733     /**
734      * @dev See {IERC721-getApproved}.
735      */
736     function getApproved(uint256 tokenId) public view virtual override returns (address) {
737         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
738 
739         return _tokenApprovals[tokenId];
740     }
741 
742     /**
743      * @dev See {IERC721-setApprovalForAll}.
744      */
745     function setApprovalForAll(address operator, bool approved) public virtual override {
746         require(operator != _msgSender(), "ERC721: approve to caller");
747 
748         _operatorApprovals[_msgSender()][operator] = approved;
749         emit ApprovalForAll(_msgSender(), operator, approved);
750     }
751 
752     /**
753      * @dev See {IERC721-isApprovedForAll}.
754      */
755     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
756         return _operatorApprovals[owner][operator];
757     }
758 
759     /**
760      * @dev See {IERC721-transferFrom}.
761      */
762     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
763         //solhint-disable-next-line max-line-length
764         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
765 
766         _transfer(from, to, tokenId);
767     }
768 
769     /**
770      * @dev See {IERC721-safeTransferFrom}.
771      */
772     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
773         safeTransferFrom(from, to, tokenId, "");
774     }
775 
776     /**
777      * @dev See {IERC721-safeTransferFrom}.
778      */
779     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
780         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
781         _safeTransfer(from, to, tokenId, _data);
782     }
783 
784     /**
785      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
786      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
787      *
788      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
789      *
790      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
791      * implement alternative mechanisms to perform token transfer, such as signature-based.
792      *
793      * Requirements:
794      *
795      * - `from` cannot be the zero address.
796      * - `to` cannot be the zero address.
797      * - `tokenId` token must exist and be owned by `from`.
798      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
799      *
800      * Emits a {Transfer} event.
801      */
802     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
803         _transfer(from, to, tokenId);
804         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
805     }
806 
807     /**
808      * @dev Returns whether `tokenId` exists.
809      *
810      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
811      *
812      * Tokens start existing when they are minted (`_mint`),
813      * and stop existing when they are burned (`_burn`).
814      */
815     function _exists(uint256 tokenId) internal view virtual returns (bool) {
816         return _owners[tokenId] != address(0);
817     }
818 
819     /**
820      * @dev Returns whether `spender` is allowed to manage `tokenId`.
821      *
822      * Requirements:
823      *
824      * - `tokenId` must exist.
825      */
826     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
827         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
828         address owner = ERC721.ownerOf(tokenId);
829         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
830     }
831 
832     /**
833      * @dev Safely mints `tokenId` and transfers it to `to`.
834      *
835      * Requirements:
836      *
837      * - `tokenId` must not exist.
838      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
839      *
840      * Emits a {Transfer} event.
841      */
842     function _safeMint(address to, uint256 tokenId) internal virtual {
843         _safeMint(to, tokenId, "");
844     }
845 
846     /**
847      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
848      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
849      */
850     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
851         _mint(to, tokenId);
852         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
853     }
854 
855     /**
856      * @dev Mints `tokenId` and transfers it to `to`.
857      *
858      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
859      *
860      * Requirements:
861      *
862      * - `tokenId` must not exist.
863      * - `to` cannot be the zero address.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _mint(address to, uint256 tokenId) internal virtual {
868         require(to != address(0), "ERC721: mint to the zero address");
869         require(!_exists(tokenId), "ERC721: token already minted");
870 
871         _beforeTokenTransfer(address(0), to, tokenId);
872 
873         _balances[to] += 1;
874         _owners[tokenId] = to;
875 
876         emit Transfer(address(0), to, tokenId);
877     }
878 
879     /**
880      * @dev Destroys `tokenId`.
881      * The approval is cleared when the token is burned.
882      *
883      * Requirements:
884      *
885      * - `tokenId` must exist.
886      *
887      * Emits a {Transfer} event.
888      */
889     function _burn(uint256 tokenId) internal virtual {
890         address owner = ERC721.ownerOf(tokenId);
891 
892         _beforeTokenTransfer(owner, address(0), tokenId);
893 
894         // Clear approvals
895         _approve(address(0), tokenId);
896 
897         _balances[owner] -= 1;
898         delete _owners[tokenId];
899 
900         emit Transfer(owner, address(0), tokenId);
901     }
902 
903     /**
904      * @dev Transfers `tokenId` from `from` to `to`.
905      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
906      *
907      * Requirements:
908      *
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must be owned by `from`.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _transfer(address from, address to, uint256 tokenId) internal virtual {
915         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
916         require(to != address(0), "ERC721: transfer to the zero address");
917 
918         _beforeTokenTransfer(from, to, tokenId);
919 
920         // Clear approvals from the previous owner
921         _approve(address(0), tokenId);
922 
923         _balances[from] -= 1;
924         _balances[to] += 1;
925         _owners[tokenId] = to;
926 
927         emit Transfer(from, to, tokenId);
928     }
929 
930     /**
931      * @dev Approve `to` to operate on `tokenId`
932      *
933      * Emits a {Approval} event.
934      */
935     function _approve(address to, uint256 tokenId) internal virtual {
936         _tokenApprovals[tokenId] = to;
937         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
938     }
939 
940     /**
941      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
942      * The call is not executed if the target address is not a contract.
943      *
944      * @param from address representing the previous owner of the given token ID
945      * @param to target address that will receive the tokens
946      * @param tokenId uint256 ID of the token to be transferred
947      * @param _data bytes optional data to send along with the call
948      * @return bool whether the call correctly returned the expected magic value
949      */
950     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
951         private returns (bool)
952     {
953         if (to.isContract()) {
954             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
955                 return retval == IERC721Receiver(to).onERC721Received.selector;
956             } catch (bytes memory reason) {
957                 if (reason.length == 0) {
958                     revert("ERC721: transfer to non ERC721Receiver implementer");
959                 } else {
960                     // solhint-disable-next-line no-inline-assembly
961                     assembly {
962                         revert(add(32, reason), mload(reason))
963                     }
964                 }
965             }
966         } else {
967             return true;
968         }
969     }
970 
971     /**
972      * @dev Hook that is called before any token transfer. This includes minting
973      * and burning.
974      *
975      * Calling conditions:
976      *
977      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
978      * transferred to `to`.
979      * - When `from` is zero, `tokenId` will be minted for `to`.
980      * - When `to` is zero, ``from``'s `tokenId` will be burned.
981      * - `from` cannot be the zero address.
982      * - `to` cannot be the zero address.
983      *
984      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
985      */
986     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
987 }
988 
989 // ERC721Enumerable.sol
990 
991 pragma solidity ^0.8.0;
992 
993 /**
994  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
995  * enumerability of all the token ids in the contract as well as all token ids owned by each
996  * account.
997  */
998 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
999     // Mapping from owner to list of owned token IDs
1000     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1001 
1002     // Mapping from token ID to index of the owner tokens list
1003     mapping(uint256 => uint256) private _ownedTokensIndex;
1004 
1005     // Array with all token ids, used for enumeration
1006     uint256[] private _allTokens;
1007 
1008     // Mapping from token id to position in the allTokens array
1009     mapping(uint256 => uint256) private _allTokensIndex;
1010 
1011     /**
1012      * @dev See {IERC165-supportsInterface}.
1013      */
1014     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1015         return interfaceId == type(IERC721Enumerable).interfaceId
1016             || super.supportsInterface(interfaceId);
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1021      */
1022     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1023         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1024         return _ownedTokens[owner][index];
1025     }
1026 
1027     /**
1028      * @dev See {IERC721Enumerable-totalSupply}.
1029      */
1030     function totalSupply() public view virtual override returns (uint256) {
1031         return _allTokens.length;
1032     }
1033 
1034     /**
1035      * @dev See {IERC721Enumerable-tokenByIndex}.
1036      */
1037     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1038         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1039         return _allTokens[index];
1040     }
1041 
1042     /**
1043      * @dev Hook that is called before any token transfer. This includes minting
1044      * and burning.
1045      *
1046      * Calling conditions:
1047      *
1048      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1049      * transferred to `to`.
1050      * - When `from` is zero, `tokenId` will be minted for `to`.
1051      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1052      * - `from` cannot be the zero address.
1053      * - `to` cannot be the zero address.
1054      *
1055      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1056      */
1057     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1058         super._beforeTokenTransfer(from, to, tokenId);
1059 
1060         if (from == address(0)) {
1061             _addTokenToAllTokensEnumeration(tokenId);
1062         } else if (from != to) {
1063             _removeTokenFromOwnerEnumeration(from, tokenId);
1064         }
1065         if (to == address(0)) {
1066             _removeTokenFromAllTokensEnumeration(tokenId);
1067         } else if (to != from) {
1068             _addTokenToOwnerEnumeration(to, tokenId);
1069         }
1070     }
1071 
1072     /**
1073      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1074      * @param to address representing the new owner of the given token ID
1075      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1076      */
1077     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1078         uint256 length = ERC721.balanceOf(to);
1079         _ownedTokens[to][length] = tokenId;
1080         _ownedTokensIndex[tokenId] = length;
1081     }
1082 
1083     /**
1084      * @dev Private function to add a token to this extension's token tracking data structures.
1085      * @param tokenId uint256 ID of the token to be added to the tokens list
1086      */
1087     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1088         _allTokensIndex[tokenId] = _allTokens.length;
1089         _allTokens.push(tokenId);
1090     }
1091 
1092     /**
1093      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1094      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1095      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1096      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1097      * @param from address representing the previous owner of the given token ID
1098      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1099      */
1100     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1101         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1102         // then delete the last slot (swap and pop).
1103 
1104         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1105         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1106 
1107         // When the token to delete is the last token, the swap operation is unnecessary
1108         if (tokenIndex != lastTokenIndex) {
1109             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1110 
1111             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1112             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1113         }
1114 
1115         // This also deletes the contents at the last position of the array
1116         delete _ownedTokensIndex[tokenId];
1117         delete _ownedTokens[from][lastTokenIndex];
1118     }
1119 
1120     /**
1121      * @dev Private function to remove a token from this extension's token tracking data structures.
1122      * This has O(1) time complexity, but alters the order of the _allTokens array.
1123      * @param tokenId uint256 ID of the token to be removed from the tokens list
1124      */
1125     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1126         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1127         // then delete the last slot (swap and pop).
1128 
1129         uint256 lastTokenIndex = _allTokens.length - 1;
1130         uint256 tokenIndex = _allTokensIndex[tokenId];
1131 
1132         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1133         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1134         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1135         uint256 lastTokenId = _allTokens[lastTokenIndex];
1136 
1137         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1138         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1139 
1140         // This also deletes the contents at the last position of the array
1141         delete _allTokensIndex[tokenId];
1142         _allTokens.pop();
1143     }
1144 }
1145 
1146 // BlootMF.sol
1147 
1148 pragma solidity ^0.8.0;
1149 
1150 contract BlootMF is ERC721Enumerable, Ownable {
1151 
1152     using Strings for uint256;
1153 
1154     uint256 private constant MAX_TOTAL = 3000; 
1155     uint256 private constant MAX_FREE = 2400;
1156     uint256 private constant MAX_DIAMOND = 500;
1157     uint256 private constant MAX_FOUNDER = 100;
1158     uint256 private constant DIAMOND_DONATION = 0.1 ether;
1159     uint256 private constant FOUNDER_DONATION= 0.5 ether;
1160     address private constant WITHDRAWAL_ADDRESS = 0x0A0Da512157d16f456C837a93a91c12f4B703672;
1161     address private constant BLOOT_ADDRESS = 0x4F8730E0b32B04beaa5757e5aea3aeF970E5B613;
1162     
1163     mapping(address => bool) private diamondMap;
1164     mapping(address => bool) private founderMap;
1165     address[] private founderList;
1166     address[] private diamondList;
1167     uint256 private freeMintCounter = 0;
1168     
1169     string _baseTokenURI;
1170     bool public _paused = true;
1171 
1172     ERC721 bloot = ERC721(BLOOT_ADDRESS);
1173 
1174     constructor(string memory baseURI) ERC721("BlootMF", "BLOOTMF")  {
1175         setBaseURI(baseURI);
1176     }
1177 
1178     function mint() public payable {
1179         uint256 supply = totalSupply();
1180         require( !_paused, "Minting is paused" );
1181         require(supply + 1 <= MAX_TOTAL, "Exceeds maximum BlootMF supply");
1182         require(bloot.balanceOf(msg.sender) >= 1, "You need to hold a Bloot to mint");
1183         require(bloot.balanceOf(msg.sender) > balanceOf(msg.sender), "You can mint one BlootMF per Bloot only");
1184         
1185         if (msg.value >= FOUNDER_DONATION) {
1186             require(founderList.length + 1 <= MAX_FOUNDER, "All Founder slots are taken");
1187             founderMap[msg.sender] = true;
1188             founderList.push(msg.sender);
1189         } else if (msg.value >= DIAMOND_DONATION) {
1190             require(diamondList.length + 1 <= MAX_DIAMOND, "All Diamond slots are taken");
1191             diamondMap[msg.sender] = true;
1192             diamondList.push(msg.sender);
1193         } else {
1194             require(freeMintCounter <= MAX_FREE, "No more free mints available");
1195             freeMintCounter++;
1196         }
1197 
1198         _safeMint(msg.sender, supply + 1);
1199     }
1200     
1201     function isDiamond(address owner) public view returns (bool) {
1202         return diamondMap[owner];
1203     }
1204     
1205     function isFounder(address owner) public view returns (bool) {
1206         return founderMap[owner];
1207     }
1208     
1209     function getAllDiamond() public view returns (address[] memory) {
1210         return diamondList;
1211     }
1212     
1213     function getAllFounder() public view returns (address[] memory) {
1214         return founderList;
1215     }
1216     
1217     function getDiamondCount() public view returns (uint) {
1218         return diamondList.length;
1219     }
1220     
1221     function getFounderCount() public view returns (uint) {
1222         return founderList.length;
1223     }
1224     
1225     function getFreeMintCount() public view returns (uint) {
1226         return freeMintCounter;
1227     }
1228 
1229     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1230         uint256 tokenCount = balanceOf(_owner);
1231 
1232         uint256[] memory tokensId = new uint256[](tokenCount);
1233         for(uint256 i; i < tokenCount; i++){
1234             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1235         }
1236         return tokensId;
1237     }
1238 
1239     function _baseURI() internal view virtual override returns (string memory) {
1240         return _baseTokenURI;
1241     }
1242 
1243     function setBaseURI(string memory baseURI) public onlyOwner {
1244         _baseTokenURI = baseURI;
1245     }
1246 
1247     function pause(bool val) public onlyOwner {
1248         _paused = val;
1249     }
1250 
1251     function withdrawAll() public payable onlyOwner {
1252         uint256 bal = address(this).balance;
1253         require(payable(WITHDRAWAL_ADDRESS).send(bal));
1254     }
1255 }