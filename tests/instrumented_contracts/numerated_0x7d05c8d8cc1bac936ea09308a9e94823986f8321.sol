1 //  _____         _   ______   _   _   ______   _____               _______   ______    _____ 
2 // |  __ \       | | |  ____| | \ | | |  ____| |  __ \      /\     |__   __| |  ____|  / ____|
3 // | |  | |      | | | |__    |  \| | | |__    | |__) |    /  \       | |    | |__    | (___  
4 // | |  | |  _   | | |  __|   | . ` | |  __|   |  _  /    / /\ \      | |    |  __|    \___ \ 
5 // | |__| | | |__| | | |____  | |\  | | |____  | | \ \   / ____ \     | |    | |____   ____) |
6 // |_____/   \____/  |______| |_| \_| |______| |_|  \_\ /_/    \_\    |_|    |______| |_____/ 
7 // 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Interface of the ERC165 standard, as defined in the
14  * https://eips.ethereum.org/EIPS/eip-165[EIP].
15  *
16  * Implementers can declare support of contract interfaces, which can then be
17  * queried by others ({ERC165Checker}).
18  *
19  * For an implementation, see {ERC165}.
20  */
21 interface IERC165 {
22     /**
23      * @dev Returns true if this contract implements the interface defined by
24      * `interfaceId`. See the corresponding
25      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
26      * to learn more about how these ids are created.
27      *
28      * This function call must use less than 30 000 gas.
29      */
30     function supportsInterface(bytes4 interfaceId) external view returns (bool);
31 }
32 
33 /**
34  * @dev Implementation of the {IERC165} interface.
35  *
36  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
37  * for the additional interface id that will be supported. For example:
38  *
39  * ```solidity
40  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
41  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
42  * }
43  * ```
44  *
45  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
46  */
47 abstract contract ERC165 is IERC165 {
48     /**
49      * @dev See {IERC165-supportsInterface}.
50      */
51     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
52         return interfaceId == type(IERC165).interfaceId;
53     }
54 }
55 
56 /**
57  * @dev String operations.
58  */
59 library Strings {
60     bytes16 private constant alphabet = "0123456789abcdef";
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
64      */
65     function toString(uint256 value) internal pure returns (string memory) {
66         // Inspired by OraclizeAPI's implementation - MIT licence
67         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
68 
69         if (value == 0) {
70             return "0";
71         }
72         uint256 temp = value;
73         uint256 digits;
74         while (temp != 0) {
75             digits++;
76             temp /= 10;
77         }
78         bytes memory buffer = new bytes(digits);
79         while (value != 0) {
80             digits -= 1;
81             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
82             value /= 10;
83         }
84         return string(buffer);
85     }
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
89      */
90     function toHexString(uint256 value) internal pure returns (string memory) {
91         if (value == 0) {
92             return "0x00";
93         }
94         uint256 temp = value;
95         uint256 length = 0;
96         while (temp != 0) {
97             length++;
98             temp >>= 8;
99         }
100         return toHexString(value, length);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
105      */
106     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
107         bytes memory buffer = new bytes(2 * length + 2);
108         buffer[0] = "0";
109         buffer[1] = "x";
110         for (uint256 i = 2 * length + 1; i > 1; --i) {
111             buffer[i] = alphabet[value & 0xf];
112             value >>= 4;
113         }
114         require(value == 0, "Strings: hex length insufficient");
115         return string(buffer);
116     }
117 
118 }
119 
120 
121 /*
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
138         return msg.data;
139     }
140 }
141 
142 
143 /**
144  * @dev Collection of functions related to the address type
145  */
146 library Address {
147     /**
148      * @dev Returns true if `account` is a contract.
149      *
150      * [IMPORTANT]
151      * ====
152      * It is unsafe to assume that an address for which this function returns
153      * false is an externally-owned account (EOA) and not a contract.
154      *
155      * Among others, `isContract` will return false for the following
156      * types of addresses:
157      *
158      *  - an externally-owned account
159      *  - a contract in construction
160      *  - an address where a contract will be created
161      *  - an address where a contract lived, but was destroyed
162      * ====
163      */
164     function isContract(address account) internal view returns (bool) {
165         // This method relies on extcodesize, which returns 0 for contracts in
166         // construction, since the code is only stored at the end of the
167         // constructor execution.
168 
169         uint256 size;
170         // solhint-disable-next-line no-inline-assembly
171         assembly { size := extcodesize(account) }
172         return size > 0;
173     }
174 
175     /**
176      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
177      * `recipient`, forwarding all available gas and reverting on errors.
178      *
179      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
180      * of certain opcodes, possibly making contracts go over the 2300 gas limit
181      * imposed by `transfer`, making them unable to receive funds via
182      * `transfer`. {sendValue} removes this limitation.
183      *
184      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
185      *
186      * IMPORTANT: because control is transferred to `recipient`, care must be
187      * taken to not create reentrancy vulnerabilities. Consider using
188      * {ReentrancyGuard} or the
189      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
190      */
191     function sendValue(address payable recipient, uint256 amount) internal {
192         require(address(this).balance >= amount, "Address: insufficient balance");
193 
194         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
195         (bool success, ) = recipient.call{ value: amount }("");
196         require(success, "Address: unable to send value, recipient may have reverted");
197     }
198 
199     /**
200      * @dev Performs a Solidity function call using a low level `call`. A
201      * plain`call` is an unsafe replacement for a function call: use this
202      * function instead.
203      *
204      * If `target` reverts with a revert reason, it is bubbled up by this
205      * function (like regular Solidity function calls).
206      *
207      * Returns the raw returned data. To convert to the expected return value,
208      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
209      *
210      * Requirements:
211      *
212      * - `target` must be a contract.
213      * - calling `target` with `data` must not revert.
214      *
215      * _Available since v3.1._
216      */
217     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
218       return functionCall(target, data, "Address: low-level call failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
223      * `errorMessage` as a fallback revert reason when `target` reverts.
224      *
225      * _Available since v3.1._
226      */
227     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
228         return functionCallWithValue(target, data, 0, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but also transferring `value` wei to `target`.
234      *
235      * Requirements:
236      *
237      * - the calling contract must have an ETH balance of at least `value`.
238      * - the called Solidity function must be `payable`.
239      *
240      * _Available since v3.1._
241      */
242     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
243         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
248      * with `errorMessage` as a fallback revert reason when `target` reverts.
249      *
250      * _Available since v3.1._
251      */
252     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
253         require(address(this).balance >= value, "Address: insufficient balance for call");
254         require(isContract(target), "Address: call to non-contract");
255 
256         // solhint-disable-next-line avoid-low-level-calls
257         (bool success, bytes memory returndata) = target.call{ value: value }(data);
258         return _verifyCallResult(success, returndata, errorMessage);
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
263      * but performing a static call.
264      *
265      * _Available since v3.3._
266      */
267     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
268         return functionStaticCall(target, data, "Address: low-level static call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
273      * but performing a static call.
274      *
275      * _Available since v3.3._
276      */
277     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
278         require(isContract(target), "Address: static call to non-contract");
279 
280         // solhint-disable-next-line avoid-low-level-calls
281         (bool success, bytes memory returndata) = target.staticcall(data);
282         return _verifyCallResult(success, returndata, errorMessage);
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
287      * but performing a delegate call.
288      *
289      * _Available since v3.4._
290      */
291     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
292         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
297      * but performing a delegate call.
298      *
299      * _Available since v3.4._
300      */
301     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
302         require(isContract(target), "Address: delegate call to non-contract");
303 
304         // solhint-disable-next-line avoid-low-level-calls
305         (bool success, bytes memory returndata) = target.delegatecall(data);
306         return _verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
310         if (success) {
311             return returndata;
312         } else {
313             // Look for revert reason and bubble it up if present
314             if (returndata.length > 0) {
315                 // The easiest way to bubble the revert reason is using memory via assembly
316 
317                 // solhint-disable-next-line no-inline-assembly
318                 assembly {
319                     let returndata_size := mload(returndata)
320                     revert(add(32, returndata), returndata_size)
321                 }
322             } else {
323                 revert(errorMessage);
324             }
325         }
326     }
327 }
328 
329 /**
330  * @dev Required interface of an ERC721 compliant contract.
331  */
332 interface IERC721 is IERC165 {
333     /**
334      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
335      */
336     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
337 
338     /**
339      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
340      */
341     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
342 
343     /**
344      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
345      */
346     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
347 
348     /**
349      * @dev Returns the number of tokens in ``owner``'s account.
350      */
351     function balanceOf(address owner) external view returns (uint256 balance);
352 
353     /**
354      * @dev Returns the owner of the `tokenId` token.
355      *
356      * Requirements:
357      *
358      * - `tokenId` must exist.
359      */
360     function ownerOf(uint256 tokenId) external view returns (address owner);
361 
362     /**
363      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
364      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
365      *
366      * Requirements:
367      *
368      * - `from` cannot be the zero address.
369      * - `to` cannot be the zero address.
370      * - `tokenId` token must exist and be owned by `from`.
371      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
372      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
373      *
374      * Emits a {Transfer} event.
375      */
376     function safeTransferFrom(address from, address to, uint256 tokenId) external;
377 
378     /**
379      * @dev Transfers `tokenId` token from `from` to `to`.
380      *
381      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
382      *
383      * Requirements:
384      *
385      * - `from` cannot be the zero address.
386      * - `to` cannot be the zero address.
387      * - `tokenId` token must be owned by `from`.
388      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transferFrom(address from, address to, uint256 tokenId) external;
393 
394     /**
395      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
396      * The approval is cleared when the token is transferred.
397      *
398      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
399      *
400      * Requirements:
401      *
402      * - The caller must own the token or be an approved operator.
403      * - `tokenId` must exist.
404      *
405      * Emits an {Approval} event.
406      */
407     function approve(address to, uint256 tokenId) external;
408 
409     /**
410      * @dev Returns the account approved for `tokenId` token.
411      *
412      * Requirements:
413      *
414      * - `tokenId` must exist.
415      */
416     function getApproved(uint256 tokenId) external view returns (address operator);
417 
418     /**
419      * @dev Approve or remove `operator` as an operator for the caller.
420      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
421      *
422      * Requirements:
423      *
424      * - The `operator` cannot be the caller.
425      *
426      * Emits an {ApprovalForAll} event.
427      */
428     function setApprovalForAll(address operator, bool _approved) external;
429 
430     /**
431      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
432      *
433      * See {setApprovalForAll}
434      */
435     function isApprovedForAll(address owner, address operator) external view returns (bool);
436 
437     /**
438       * @dev Safely transfers `tokenId` token from `from` to `to`.
439       *
440       * Requirements:
441       *
442       * - `from` cannot be the zero address.
443       * - `to` cannot be the zero address.
444       * - `tokenId` token must exist and be owned by `from`.
445       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
446       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
447       *
448       * Emits a {Transfer} event.
449       */
450     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
451 }
452 
453 /**
454  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
455  * @dev See https://eips.ethereum.org/EIPS/eip-721
456  */
457 interface IERC721Metadata is IERC721 {
458 
459     /**
460      * @dev Returns the token collection name.
461      */
462     function name() external view returns (string memory);
463 
464     /**
465      * @dev Returns the token collection symbol.
466      */
467     function symbol() external view returns (string memory);
468 
469     /**
470      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
471      */
472     function tokenURI(uint256 tokenId) external view returns (string memory);
473 }
474 
475 /**
476  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
477  * @dev See https://eips.ethereum.org/EIPS/eip-721
478  */
479 interface IERC721Enumerable is IERC721 {
480 
481     /**
482      * @dev Returns the total amount of tokens stored by the contract.
483      */
484     function totalSupply() external view returns (uint256);
485 
486     /**
487      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
488      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
489      */
490     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
491 
492     /**
493      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
494      * Use along with {totalSupply} to enumerate all tokens.
495      */
496     function tokenByIndex(uint256 index) external view returns (uint256);
497 }
498 
499 
500 /**
501  * @title ERC721 token receiver interface
502  * @dev Interface for any contract that wants to support safeTransfers
503  * from ERC721 asset contracts.
504  */
505 interface IERC721Receiver {
506     /**
507      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
508      * by `operator` from `from`, this function is called.
509      *
510      * It must return its Solidity selector to confirm the token transfer.
511      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
512      *
513      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
514      */
515     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
516 }
517 
518 
519 /**
520  * @dev Contract module which provides a basic access control mechanism, where
521  * there is an account (an owner) that can be granted exclusive access to
522  * specific functions.
523  *
524  * By default, the owner account will be the one that deploys the contract. This
525  * can later be changed with {transferOwnership}.
526  *
527  * This module is used through inheritance. It will make available the modifier
528  * `onlyOwner`, which can be applied to your functions to restrict their use to
529  * the owner.
530  */
531 abstract contract Ownable is Context {
532     address private _owner;
533 
534     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
535 
536     /**
537      * @dev Initializes the contract setting the deployer as the initial owner.
538      */
539     constructor () {
540         address msgSender = _msgSender();
541         _owner = msgSender;
542         emit OwnershipTransferred(address(0), msgSender);
543     }
544 
545     /**
546      * @dev Returns the address of the current owner.
547      */
548     function owner() public view virtual returns (address) {
549         return _owner;
550     }
551 
552     /**
553      * @dev Throws if called by any account other than the owner.
554      */
555     modifier onlyOwner() {
556         require(owner() == _msgSender(), "Ownable: caller is not the owner");
557         _;
558     }
559 
560     /**
561      * @dev Leaves the contract without owner. It will not be possible to call
562      * `onlyOwner` functions anymore. Can only be called by the current owner.
563      *
564      * NOTE: Renouncing ownership will leave the contract without an owner,
565      * thereby removing any functionality that is only available to the owner.
566      */
567     function renounceOwnership() public virtual onlyOwner {
568         emit OwnershipTransferred(_owner, address(0));
569         _owner = address(0);
570     }
571 
572     /**
573      * @dev Transfers ownership of the contract to a new account (`newOwner`).
574      * Can only be called by the current owner.
575      */
576     function transferOwnership(address newOwner) public virtual onlyOwner {
577         require(newOwner != address(0), "Ownable: new owner is the zero address");
578         emit OwnershipTransferred(_owner, newOwner);
579         _owner = newOwner;
580     }
581 }
582 
583 
584 /**
585  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
586  * the Metadata extension, but not including the Enumerable extension, which is available separately as
587  * {ERC721Enumerable}.
588  */
589 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, Ownable {
590     using Address for address;
591     using Strings for uint256;
592 
593     // Token name
594     string private _name;
595 
596     // Token symbol
597     string private _symbol;
598 
599     // Mapping from token ID to owner address
600     mapping(uint256 => address) internal _owners;
601 
602     // Mapping owner address to token count
603     mapping(address => uint256) internal _balances;
604 
605     // Mapping from token ID to approved address
606     mapping(uint256 => address) private _tokenApprovals;
607 
608     // Mapping from owner to operator approvals
609     mapping(address => mapping(address => bool)) private _operatorApprovals;
610 
611     /**
612      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
613      */
614     constructor(string memory name_, string memory symbol_) {
615         _name = name_;
616         _symbol = symbol_;
617     }
618 
619     /**
620      * @dev See {IERC165-supportsInterface}.
621      */
622     function supportsInterface(bytes4 interfaceId)
623         public
624         view
625         virtual
626         override(ERC165, IERC165)
627         returns (bool)
628     {
629         return
630             interfaceId == type(IERC721).interfaceId ||
631             interfaceId == type(IERC721Metadata).interfaceId ||
632             super.supportsInterface(interfaceId);
633     }
634 
635     /**
636      * @dev See {IERC721-balanceOf}.
637      */
638     function balanceOf(address owner)
639         public
640         view
641         virtual
642         override
643         returns (uint256)
644     {
645         require(
646             owner != address(0),
647             "ERC721: balance query for the zero address"
648         );
649         return _balances[owner];
650     }
651 
652     /**
653      * @dev See {IERC721-ownerOf}.
654      */
655     function ownerOf(uint256 tokenId)
656         public
657         view
658         virtual
659         override
660         returns (address)
661     {
662         address owner = _owners[tokenId];
663         require(
664             owner != address(0),
665             "ERC721: owner query for nonexistent token"
666         );
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
687     function tokenURI(uint256 tokenId)
688         public
689         view
690         virtual
691         override
692         returns (string memory)
693     {
694         require(
695             _exists(tokenId),
696             "ERC721Metadata: URI query for nonexistent token"
697         );
698 
699         string memory baseURI = _baseURI();
700         return
701             bytes(baseURI).length > 0
702                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
703                 : "";
704     }
705 
706     /**
707      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
708      * in child contracts.
709      */
710     function _baseURI() internal view virtual returns (string memory) {
711         return "";
712     }
713 
714     /**
715      * @dev See {IERC721-approve}.
716      */
717     function approve(address to, uint256 tokenId) public virtual override {
718         address owner = ERC721.ownerOf(tokenId);
719         require(to != owner, "ERC721: approval to current owner");
720 
721         require(
722             _msgSender() == owner ||
723                 ERC721.isApprovedForAll(owner, _msgSender()),
724             "ERC721: approve caller is not owner nor approved for all"
725         );
726 
727         _approve(to, tokenId);
728     }
729 
730     /**
731      * @dev See {IERC721-getApproved}.
732      */
733     function getApproved(uint256 tokenId)
734         public
735         view
736         virtual
737         override
738         returns (address)
739     {
740         require(
741             _exists(tokenId),
742             "ERC721: approved query for nonexistent token"
743         );
744 
745         return _tokenApprovals[tokenId];
746     }
747 
748     /**
749      * @dev See {IERC721-setApprovalForAll}.
750      */
751     function setApprovalForAll(address operator, bool approved)
752         public
753         virtual
754         override
755     {
756         require(operator != _msgSender(), "ERC721: approve to caller");
757 
758         _operatorApprovals[_msgSender()][operator] = approved;
759         emit ApprovalForAll(_msgSender(), operator, approved);
760     }
761 
762     /**
763      * @dev See {IERC721-isApprovedForAll}.
764      */
765     function isApprovedForAll(address owner, address operator)
766         public
767         view
768         virtual
769         override
770         returns (bool)
771     {
772         return _operatorApprovals[owner][operator];
773     }
774 
775     /**
776      * @dev See {IERC721-transferFrom}.
777      */
778     function transferFrom(
779         address from,
780         address to,
781         uint256 tokenId
782     ) public virtual override {
783         //solhint-disable-next-line max-line-length
784         require(
785             _isApprovedOrOwner(_msgSender(), tokenId),
786             "ERC721: transfer caller is not owner nor approved"
787         );
788 
789         _transfer(from, to, tokenId);
790     }
791 
792     /**
793      * @dev See {IERC721-safeTransferFrom}.
794      */
795     function safeTransferFrom(
796         address from,
797         address to,
798         uint256 tokenId
799     ) public virtual override {
800         safeTransferFrom(from, to, tokenId, "");
801     }
802 
803     /**
804      * @dev See {IERC721-safeTransferFrom}.
805      */
806     function safeTransferFrom(
807         address from,
808         address to,
809         uint256 tokenId,
810         bytes memory _data
811     ) public virtual override {
812         require(
813             _isApprovedOrOwner(_msgSender(), tokenId),
814             "ERC721: transfer caller is not owner nor approved"
815         );
816         _safeTransfer(from, to, tokenId, _data);
817     }
818 
819     /**
820      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
821      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
822      *
823      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
824      *
825      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
826      * implement alternative mechanisms to perform token transfer, such as signature-based.
827      *
828      * Requirements:
829      *
830      * - `from` cannot be the zero address.
831      * - `to` cannot be the zero address.
832      * - `tokenId` token must exist and be owned by `from`.
833      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _safeTransfer(
838         address from,
839         address to,
840         uint256 tokenId,
841         bytes memory _data
842     ) internal virtual {
843         _transfer(from, to, tokenId);
844         require(
845             _checkOnERC721Received(from, to, tokenId, _data),
846             "ERC721: transfer to non ERC721Receiver implementer"
847         );
848     }
849 
850     /**
851      * @dev Returns whether `tokenId` exists.
852      *
853      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
854      *
855      * Tokens start existing when they are minted (`_mint`),
856      * and stop existing when they are burned (`_burn`).
857      */
858     function _exists(uint256 tokenId) internal view virtual returns (bool) {
859         return _owners[tokenId] != address(0);
860     }
861 
862     /**
863      * @dev Returns whether `spender` is allowed to manage `tokenId`.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must exist.
868      */
869     function _isApprovedOrOwner(address spender, uint256 tokenId)
870         internal
871         view
872         virtual
873         returns (bool)
874     {
875         require(
876             _exists(tokenId),
877             "ERC721: operator query for nonexistent token"
878         );
879         address owner = ERC721.ownerOf(tokenId);
880         return (spender == owner ||
881             getApproved(tokenId) == spender ||
882             ERC721.isApprovedForAll(owner, spender));
883     }
884 
885     /**
886      * @dev Safely mints `tokenId` and transfers it to `to`.
887      *
888      * Requirements:
889      *
890      * - `tokenId` must not exist.
891      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _safeMint(address to, uint256 tokenId) internal virtual {
896         _safeMint(to, tokenId, "");
897     }
898 
899     /**
900      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
901      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
902      */
903     function _safeMint(
904         address to,
905         uint256 tokenId,
906         bytes memory _data
907     ) internal virtual {
908         _mint(to, tokenId);
909         require(
910             _checkOnERC721Received(address(0), to, tokenId, _data),
911             "ERC721: transfer to non ERC721Receiver implementer"
912         );
913     }
914 
915     /**
916      * @dev Mints `tokenId` and transfers it to `to`.
917      *
918      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
919      *
920      * Requirements:
921      *
922      * - `tokenId` must not exist.
923      * - `to` cannot be the zero address.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _mint(address to, uint256 tokenId) internal virtual {
928         require(to != address(0), "ERC721: mint to the zero address");
929         require(!_exists(tokenId), "ERC721: token already minted");
930 
931         _beforeTokenTransfer(address(0), to, tokenId);
932 
933         _balances[to] += 1;
934         _owners[tokenId] = to;
935 
936         emit Transfer(address(0), to, tokenId);
937     }
938 
939     function _batchMint(address to, uint256[] memory tokenIds)
940         internal
941         virtual
942     {
943         require(to != address(0), "ERC721: mint to the zero address");
944         _balances[to] += tokenIds.length;
945 
946         for (uint256 i; i < tokenIds.length; i++) {
947             require(!_exists(tokenIds[i]), "ERC721: token already minted");
948 
949             _beforeTokenTransfer(address(0), to, tokenIds[i]);
950 
951             _owners[tokenIds[i]] = to;
952 
953             emit Transfer(address(0), to, tokenIds[i]);
954         }
955     }
956 
957     /**
958      * @dev Destroys `tokenId`.
959      * The approval is cleared when the token is burned.
960      *
961      * Requirements:
962      *
963      * - `tokenId` must exist.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _burn(uint256 tokenId) internal virtual {
968         address owner = ERC721.ownerOf(tokenId);
969 
970         _beforeTokenTransfer(owner, address(0), tokenId);
971 
972         // Clear approvals
973         _approve(address(0), tokenId);
974 
975         _balances[owner] -= 1;
976         delete _owners[tokenId];
977 
978         emit Transfer(owner, address(0), tokenId);
979     }
980 
981     /**
982      * @dev Transfers `tokenId` from `from` to `to`.
983      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
984      *
985      * Requirements:
986      *
987      * - `to` cannot be the zero address.
988      * - `tokenId` token must be owned by `from`.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _transfer(
993         address from,
994         address to,
995         uint256 tokenId
996     ) internal virtual {
997         require(
998             ERC721.ownerOf(tokenId) == from,
999             "ERC721: transfer of token that is not own"
1000         );
1001         require(to != address(0), "ERC721: transfer to the zero address");
1002 
1003         _beforeTokenTransfer(from, to, tokenId);
1004 
1005         // Clear approvals from the previous owner
1006         _approve(address(0), tokenId);
1007 
1008         _balances[from] -= 1;
1009         _balances[to] += 1;
1010         _owners[tokenId] = to;
1011 
1012         emit Transfer(from, to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev Approve `to` to operate on `tokenId`
1017      *
1018      * Emits a {Approval} event.
1019      */
1020     function _approve(address to, uint256 tokenId) internal virtual {
1021         _tokenApprovals[tokenId] = to;
1022         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1027      * The call is not executed if the target address is not a contract.
1028      *
1029      * @param from address representing the previous owner of the given token ID
1030      * @param to target address that will receive the tokens
1031      * @param tokenId uint256 ID of the token to be transferred
1032      * @param _data bytes optional data to send along with the call
1033      * @return bool whether the call correctly returned the expected magic value
1034      */
1035     function _checkOnERC721Received(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes memory _data
1040     ) private returns (bool) {
1041         if (to.isContract()) {
1042             try
1043                 IERC721Receiver(to).onERC721Received(
1044                     _msgSender(),
1045                     from,
1046                     tokenId,
1047                     _data
1048                 )
1049             returns (bytes4 retval) {
1050                 return retval == IERC721Receiver(to).onERC721Received.selector;
1051             } catch (bytes memory reason) {
1052                 if (reason.length == 0) {
1053                     revert(
1054                         "ERC721: transfer to non ERC721Receiver implementer"
1055                     );
1056                 } else {
1057                     // solhint-disable-next-line no-inline-assembly
1058                     assembly {
1059                         revert(add(32, reason), mload(reason))
1060                     }
1061                 }
1062             }
1063         } else {
1064             return true;
1065         }
1066     }
1067 
1068     /**
1069      * @dev Hook that is called before any token transfer. This includes minting
1070      * and burning.
1071      *
1072      * Calling conditions:
1073      *
1074      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1075      * transferred to `to`.
1076      * - When `from` is zero, `tokenId` will be minted for `to`.
1077      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1078      * - `from` cannot be the zero address.
1079      * - `to` cannot be the zero address.
1080      *
1081      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1082      */
1083     function _beforeTokenTransfer(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) internal virtual {}
1088 }
1089 
1090 
1091 
1092 contract DjEnerates is ERC721 {
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
1108     struct Collaborators {
1109         address addr;
1110         uint256 cut;
1111     }
1112 
1113     uint256 private startClaimDate = 1629990000; //26th August 2021 3PM UTC
1114     uint256 private claimPrice =  0.08 ether;
1115     uint256 private totalTokens = 10000;
1116     uint256 private totalMintedTokens = 0;
1117     uint256 private maxClaimsPerWallet = 50;
1118     uint128 private basisPoints = 10000;
1119     uint128 private resDjens = 240; //total reserved token for rewards and wages
1120     uint256 private totalReserved = 0;
1121     string private baseURI =
1122         "https://ipfs.io/ipfs/QmRPGJWkqdF9hhqrNjwGW7tuFHduSrtoeDA2PtnU65HYjX/";
1123 
1124 
1125     mapping(address => uint256) private claimedTokensPerWallet;
1126 
1127     uint16[] availableTokens;
1128     Collaborators[] private collaborators;
1129 
1130     constructor() ERC721("DJENERATES - CLUBBING EDITION", "DJEN") {}
1131 
1132     // ONLY OWNER
1133 
1134     /**
1135      * Sets the collaborators of the project with their cuts
1136      */
1137     function addCollaborators(Collaborators[] memory _collaborators)
1138         external
1139         onlyOwner
1140     {
1141         require(collaborators.length == 0, "Collaborators were already set");
1142 
1143         uint128 totalCut;
1144         for (uint256 i; i < _collaborators.length; i++) {
1145             collaborators.push(_collaborators[i]);
1146             totalCut += uint128(_collaborators[i].cut);
1147         }
1148 
1149         require(totalCut == basisPoints, "Total cut does not add to 100%");
1150     }
1151 
1152     // ONLY COLLABORATORS
1153 
1154     /**
1155      * @dev Allows to withdraw the Ether in the contract and split it among the collaborators
1156      */
1157     function withdraw() external onlyOwner {
1158         uint256 totalBalance = address(this).balance;
1159 
1160         for (uint256 i; i < collaborators.length; i++) {
1161             payable(collaborators[i].addr).transfer(
1162                 mulScale(totalBalance, collaborators[i].cut, basisPoints)
1163             );
1164         }
1165     }
1166 
1167     /**
1168      * @dev Sets the base URI for the API that provides the NFT data.
1169      */
1170     function setBaseTokenURI(string memory _uri) external onlyOwner {
1171         baseURI = _uri;
1172     }
1173 
1174     /**
1175      * @dev Sets the claim price for each token
1176      */
1177     function setClaimPrice(uint256 _claimPrice) external onlyOwner {
1178         claimPrice = _claimPrice;
1179     }
1180 
1181     /**
1182      * @dev Populates the available tokens
1183      */
1184     function addAvailableTokens(uint16 from, uint16 to)
1185         external
1186         onlyOwner
1187     {
1188        for (uint16 i = from; i <= to; i++) {
1189             availableTokens.push(i);
1190         }
1191     }
1192 
1193     /**
1194      * @dev Sets the date that users can start claiming tokens
1195      */
1196     function setStartClaimDate(uint256 _startClaimDate)
1197         external
1198         onlyOwner
1199     {
1200         startClaimDate = _startClaimDate;
1201     }
1202 
1203      /**
1204      * Set 240 random DJENs aside for rewards and wages
1205      */
1206     function reserveDjens() external onlyOwner {        
1207         require(availableTokens.length >= 80, "No tokens left to reserve");
1208         require(totalReserved < resDjens,"240 DJens have been already reserved, you can not reserve more");
1209         uint256[] memory tokenIds = new uint256[](80);
1210 
1211         totalMintedTokens += 80;
1212 		totalReserved += 80;
1213 
1214         for (uint256 i; i < 80; i++) {
1215             tokenIds[i] = getTokenToBeClaimed();
1216         }
1217         _batchMint(msg.sender, tokenIds);
1218     }
1219 
1220     /**
1221      * @dev Claim a single token
1222      */
1223     function claimToken() external payable callerIsUser claimStarted {
1224         require(msg.value >= claimPrice, "Not enough Ether to claim a token");
1225 
1226         require(
1227             claimedTokensPerWallet[msg.sender] < maxClaimsPerWallet,
1228             "You cannot claim more tokens"
1229         );
1230 
1231         require(availableTokens.length > 0, "No tokens left to be claimed");
1232 
1233         claimedTokensPerWallet[msg.sender]++;
1234         totalMintedTokens++;
1235 
1236         _mint(msg.sender, getTokenToBeClaimed());
1237     }
1238 
1239     /**
1240      * @dev Claim up to 50 tokens at once
1241      */
1242     function claimTokens(uint256 amount)
1243         external
1244         payable
1245         callerIsUser
1246         claimStarted
1247     {
1248         require(
1249             msg.value >= claimPrice * amount,
1250             "Not enough Ether to claim the tokens"
1251         );
1252 
1253         require(
1254             claimedTokensPerWallet[msg.sender] + amount <= maxClaimsPerWallet,
1255             "You cannot claim more tokens"
1256         );
1257 
1258         require(availableTokens.length >= amount, "No tokens left to be claimed");
1259 
1260         uint256[] memory tokenIds = new uint256[](amount);
1261 
1262         claimedTokensPerWallet[msg.sender] += amount;
1263         totalMintedTokens += amount;
1264 
1265         for (uint256 i; i < amount; i++) {
1266             tokenIds[i] = getTokenToBeClaimed();
1267         }
1268 
1269         _batchMint(msg.sender, tokenIds);
1270     }
1271 
1272     /**
1273      * @dev Returns the tokenId by index
1274      */
1275     function tokenByIndex(uint256 tokenId) external view returns (uint256) {
1276         require(
1277             _exists(tokenId),
1278             "ERC721: operator query for nonexistent token"
1279         );
1280 
1281         return tokenId;
1282     }
1283 
1284     /**
1285      * @dev Returns the base URI for the tokens API.
1286      */
1287     function baseTokenURI() external view returns (string memory) {
1288         return baseURI;
1289     }
1290 
1291     /**
1292      * @dev Returns how many tokens are still available to be claimed
1293      */
1294     function getAvailableTokens() external view returns (uint256) {
1295         return availableTokens.length;
1296     }
1297 
1298     /**
1299      * @dev Returns the claim price
1300      */
1301     function getClaimPrice() external view returns (uint256) {
1302         return claimPrice;
1303     }
1304 
1305     /**
1306      * @dev Returns the total supply
1307      */
1308     function totalSupply() external view virtual returns (uint256) {
1309         return totalMintedTokens;
1310     }
1311 
1312     // Private and Internal functions
1313 
1314     /**
1315      * @dev Returns a random available token to be claimed
1316      */
1317     function getTokenToBeClaimed() private returns (uint256) {
1318         uint256 random = _getRandomNumber(availableTokens.length);
1319         uint256 tokenId = uint256(availableTokens[random]);
1320 
1321         availableTokens[random] = availableTokens[availableTokens.length - 1];
1322         availableTokens.pop();
1323 
1324         return tokenId;
1325     }
1326 
1327     /**
1328      * @dev Generates a pseudo-random number.
1329      */
1330     function _getRandomNumber(uint256 _upper) private view returns (uint256) {
1331         uint256 random = uint256(
1332             keccak256(
1333                 abi.encodePacked(
1334                     availableTokens.length,
1335                     blockhash(block.number - 1),
1336                     block.coinbase,
1337                     block.difficulty,
1338                     msg.sender
1339                 )
1340             )
1341         );
1342 
1343         return random % _upper;
1344     }
1345 
1346     /**
1347      * @dev See {ERC721}.
1348      */
1349     function _baseURI() internal view virtual override returns (string memory) {
1350         return baseURI;
1351     }
1352 
1353     function mulScale(
1354         uint256 x,
1355         uint256 y,
1356         uint128 scale
1357     ) internal pure returns (uint256) {
1358         uint256 a = x / scale;
1359         uint256 b = x % scale;
1360         uint256 c = y / scale;
1361         uint256 d = y % scale;
1362 
1363         return a * c * scale + a * d + b * c + (b * d) / scale;
1364     }
1365 }