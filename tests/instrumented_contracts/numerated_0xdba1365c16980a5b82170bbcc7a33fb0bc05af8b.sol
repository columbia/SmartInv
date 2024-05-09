1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 abstract contract ERC165 is IERC165 {
28     /**
29      * @dev See {IERC165-supportsInterface}.
30      */
31     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
32         return interfaceId == type(IERC165).interfaceId;
33     }
34 }
35 
36 
37 /**
38  * @dev String operations.
39  */
40 library Strings {
41     bytes16 private constant alphabet = "0123456789abcdef";
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
45      */
46     function toString(uint256 value) internal pure returns (string memory) {
47         // Inspired by OraclizeAPI's implementation - MIT licence
48         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
49 
50         if (value == 0) {
51             return "0";
52         }
53         uint256 temp = value;
54         uint256 digits;
55         while (temp != 0) {
56             digits++;
57             temp /= 10;
58         }
59         bytes memory buffer = new bytes(digits);
60         while (value != 0) {
61             digits -= 1;
62             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
63             value /= 10;
64         }
65         return string(buffer);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
70      */
71     function toHexString(uint256 value) internal pure returns (string memory) {
72         if (value == 0) {
73             return "0x00";
74         }
75         uint256 temp = value;
76         uint256 length = 0;
77         while (temp != 0) {
78             length++;
79             temp >>= 8;
80         }
81         return toHexString(value, length);
82     }
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
86      */
87     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
88         bytes memory buffer = new bytes(2 * length + 2);
89         buffer[0] = "0";
90         buffer[1] = "x";
91         for (uint256 i = 2 * length + 1; i > 1; --i) {
92             buffer[i] = alphabet[value & 0xf];
93             value >>= 4;
94         }
95         require(value == 0, "Strings: hex length insufficient");
96         return string(buffer);
97     }
98 
99 }
100 
101 
102 /*
103  * @dev Provides information about the current execution context, including the
104  * sender of the transaction and its data. While these are generally available
105  * via msg.sender and msg.data, they should not be accessed in such a direct
106  * manner, since when dealing with meta-transactions the account sending and
107  * paying for execution may not be the actual sender (as far as an application
108  * is concerned).
109  *
110  * This contract is only required for intermediate, library-like contracts.
111  */
112 abstract contract Context {
113     function _msgSender() internal view virtual returns (address) {
114         return msg.sender;
115     }
116 
117     function _msgData() internal view virtual returns (bytes calldata) {
118         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
119         return msg.data;
120     }
121 }
122 
123 
124 /**
125  * @dev Collection of functions related to the address type
126  */
127 library Address {
128     /**
129      * @dev Returns true if `account` is a contract.
130      *
131      * [IMPORTANT]
132      * ====
133      * It is unsafe to assume that an address for which this function returns
134      * false is an externally-owned account (EOA) and not a contract.
135      *
136      * Among others, `isContract` will return false for the following
137      * types of addresses:
138      *
139      *  - an externally-owned account
140      *  - a contract in construction
141      *  - an address where a contract will be created
142      *  - an address where a contract lived, but was destroyed
143      * ====
144      */
145     function isContract(address account) internal view returns (bool) {
146         // This method relies on extcodesize, which returns 0 for contracts in
147         // construction, since the code is only stored at the end of the
148         // constructor execution.
149 
150         uint256 size;
151         // solhint-disable-next-line no-inline-assembly
152         assembly { size := extcodesize(account) }
153         return size > 0;
154     }
155 
156     /**
157      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
158      * `recipient`, forwarding all available gas and reverting on errors.
159      *
160      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
161      * of certain opcodes, possibly making contracts go over the 2300 gas limit
162      * imposed by `transfer`, making them unable to receive funds via
163      * `transfer`. {sendValue} removes this limitation.
164      *
165      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
166      *
167      * IMPORTANT: because control is transferred to `recipient`, care must be
168      * taken to not create reentrancy vulnerabilities. Consider using
169      * {ReentrancyGuard} or the
170      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
171      */
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(address(this).balance >= amount, "Address: insufficient balance");
174 
175         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
176         (bool success, ) = recipient.call{ value: amount }("");
177         require(success, "Address: unable to send value, recipient may have reverted");
178     }
179 
180     /**
181      * @dev Performs a Solidity function call using a low level `call`. A
182      * plain`call` is an unsafe replacement for a function call: use this
183      * function instead.
184      *
185      * If `target` reverts with a revert reason, it is bubbled up by this
186      * function (like regular Solidity function calls).
187      *
188      * Returns the raw returned data. To convert to the expected return value,
189      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
190      *
191      * Requirements:
192      *
193      * - `target` must be a contract.
194      * - calling `target` with `data` must not revert.
195      *
196      * _Available since v3.1._
197      */
198     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
199       return functionCall(target, data, "Address: low-level call failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
204      * `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
209         return functionCallWithValue(target, data, 0, errorMessage);
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
214      * but also transferring `value` wei to `target`.
215      *
216      * Requirements:
217      *
218      * - the calling contract must have an ETH balance of at least `value`.
219      * - the called Solidity function must be `payable`.
220      *
221      * _Available since v3.1._
222      */
223     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
224         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
229      * with `errorMessage` as a fallback revert reason when `target` reverts.
230      *
231      * _Available since v3.1._
232      */
233     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
234         require(address(this).balance >= value, "Address: insufficient balance for call");
235         require(isContract(target), "Address: call to non-contract");
236 
237         // solhint-disable-next-line avoid-low-level-calls
238         (bool success, bytes memory returndata) = target.call{ value: value }(data);
239         return _verifyCallResult(success, returndata, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but performing a static call.
245      *
246      * _Available since v3.3._
247      */
248     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
249         return functionStaticCall(target, data, "Address: low-level static call failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
254      * but performing a static call.
255      *
256      * _Available since v3.3._
257      */
258     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
259         require(isContract(target), "Address: static call to non-contract");
260 
261         // solhint-disable-next-line avoid-low-level-calls
262         (bool success, bytes memory returndata) = target.staticcall(data);
263         return _verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
268      * but performing a delegate call.
269      *
270      * _Available since v3.4._
271      */
272     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
273         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
278      * but performing a delegate call.
279      *
280      * _Available since v3.4._
281      */
282     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
283         require(isContract(target), "Address: delegate call to non-contract");
284 
285         // solhint-disable-next-line avoid-low-level-calls
286         (bool success, bytes memory returndata) = target.delegatecall(data);
287         return _verifyCallResult(success, returndata, errorMessage);
288     }
289 
290     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
291         if (success) {
292             return returndata;
293         } else {
294             // Look for revert reason and bubble it up if present
295             if (returndata.length > 0) {
296                 // The easiest way to bubble the revert reason is using memory via assembly
297 
298                 // solhint-disable-next-line no-inline-assembly
299                 assembly {
300                     let returndata_size := mload(returndata)
301                     revert(add(32, returndata), returndata_size)
302                 }
303             } else {
304                 revert(errorMessage);
305             }
306         }
307     }
308 }
309 
310 /**
311  * @title ERC721 token receiver interface
312  * @dev Interface for any contract that wants to support safeTransfers
313  * from ERC721 asset contracts.
314  */
315 interface IERC721Receiver {
316     /**
317      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
318      * by `operator` from `from`, this function is called.
319      *
320      * It must return its Solidity selector to confirm the token transfer.
321      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
322      *
323      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
324      */
325     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
326 }
327 
328 
329 
330 /**
331  * @dev Required interface of an ERC721 compliant contract.
332  */
333 interface IERC721 is IERC165 {
334     /**
335      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
336      */
337     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
338 
339     /**
340      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
341      */
342     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
343 
344     /**
345      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
346      */
347     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
348 
349     /**
350      * @dev Returns the number of tokens in ``owner``'s account.
351      */
352     function balanceOf(address owner) external view returns (uint256 balance);
353 
354     /**
355      * @dev Returns the owner of the `tokenId` token.
356      *
357      * Requirements:
358      *
359      * - `tokenId` must exist.
360      */
361     function ownerOf(uint256 tokenId) external view returns (address owner);
362 
363     /**
364      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
365      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
366      *
367      * Requirements:
368      *
369      * - `from` cannot be the zero address.
370      * - `to` cannot be the zero address.
371      * - `tokenId` token must exist and be owned by `from`.
372      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
373      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
374      *
375      * Emits a {Transfer} event.
376      */
377     function safeTransferFrom(address from, address to, uint256 tokenId) external;
378 
379     /**
380      * @dev Transfers `tokenId` token from `from` to `to`.
381      *
382      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
383      *
384      * Requirements:
385      *
386      * - `from` cannot be the zero address.
387      * - `to` cannot be the zero address.
388      * - `tokenId` token must be owned by `from`.
389      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
390      *
391      * Emits a {Transfer} event.
392      */
393     function transferFrom(address from, address to, uint256 tokenId) external;
394 
395     /**
396      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
397      * The approval is cleared when the token is transferred.
398      *
399      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
400      *
401      * Requirements:
402      *
403      * - The caller must own the token or be an approved operator.
404      * - `tokenId` must exist.
405      *
406      * Emits an {Approval} event.
407      */
408     function approve(address to, uint256 tokenId) external;
409 
410     /**
411      * @dev Returns the account approved for `tokenId` token.
412      *
413      * Requirements:
414      *
415      * - `tokenId` must exist.
416      */
417     function getApproved(uint256 tokenId) external view returns (address operator);
418 
419     /**
420      * @dev Approve or remove `operator` as an operator for the caller.
421      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
422      *
423      * Requirements:
424      *
425      * - The `operator` cannot be the caller.
426      *
427      * Emits an {ApprovalForAll} event.
428      */
429     function setApprovalForAll(address operator, bool _approved) external;
430 
431     /**
432      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
433      *
434      * See {setApprovalForAll}
435      */
436     function isApprovedForAll(address owner, address operator) external view returns (bool);
437 
438     /**
439       * @dev Safely transfers `tokenId` token from `from` to `to`.
440       *
441       * Requirements:
442       *
443       * - `from` cannot be the zero address.
444       * - `to` cannot be the zero address.
445       * - `tokenId` token must exist and be owned by `from`.
446       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
447       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
448       *
449       * Emits a {Transfer} event.
450       */
451     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
452 }
453 
454 /**
455  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
456  * @dev See https://eips.ethereum.org/EIPS/eip-721
457  */
458 interface IERC721Metadata is IERC721 {
459 
460     /**
461      * @dev Returns the token collection name.
462      */
463     function name() external view returns (string memory);
464 
465     /**
466      * @dev Returns the token collection symbol.
467      */
468     function symbol() external view returns (string memory);
469 
470     /**
471      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
472      */
473     function tokenURI(uint256 tokenId) external view returns (string memory);
474 }
475 
476 /**
477  * @dev Contract module which provides a basic access control mechanism, where
478  * there is an account (an owner) that can be granted exclusive access to
479  * specific functions.
480  *
481  * By default, the owner account will be the one that deploys the contract. This
482  * can later be changed with {transferOwnership}.
483  *
484  * This module is used through inheritance. It will make available the modifier
485  * `onlyOwner`, which can be applied to your functions to restrict their use to
486  * the owner.
487  */
488 abstract contract Ownable is Context {
489     address private _owner;
490 
491     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
492 
493     /**
494      * @dev Initializes the contract setting the deployer as the initial owner.
495      */
496     constructor () {
497         address msgSender = _msgSender();
498         _owner = msgSender;
499         emit OwnershipTransferred(address(0), msgSender);
500     }
501 
502     /**
503      * @dev Returns the address of the current owner.
504      */
505     function owner() public view virtual returns (address) {
506         return _owner;
507     }
508 
509     /**
510      * @dev Throws if called by any account other than the owner.
511      */
512     modifier onlyOwner() {
513         require(owner() == _msgSender(), "Ownable: caller is not the owner");
514         _;
515     }
516 
517     /**
518      * @dev Leaves the contract without owner. It will not be possible to call
519      * `onlyOwner` functions anymore. Can only be called by the current owner.
520      *
521      * NOTE: Renouncing ownership will leave the contract without an owner,
522      * thereby removing any functionality that is only available to the owner.
523      */
524     function renounceOwnership() public virtual onlyOwner {
525         emit OwnershipTransferred(_owner, address(0));
526         _owner = address(0);
527     }
528 
529     /**
530      * @dev Transfers ownership of the contract to a new account (`newOwner`).
531      * Can only be called by the current owner.
532      */
533     function transferOwnership(address newOwner) public virtual onlyOwner {
534         require(newOwner != address(0), "Ownable: new owner is the zero address");
535         emit OwnershipTransferred(_owner, newOwner);
536         _owner = newOwner;
537     }
538 }
539 
540 /**
541  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
542  * @dev See https://eips.ethereum.org/EIPS/eip-721
543  */
544 interface IERC721Enumerable is IERC721 {
545 
546     /**
547      * @dev Returns the total amount of tokens stored by the contract.
548      */
549     function totalSupply() external view returns (uint256);
550 
551     /**
552      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
553      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
554      */
555     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
556 
557     /**
558      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
559      * Use along with {totalSupply} to enumerate all tokens.
560      */
561     function tokenByIndex(uint256 index) external view returns (uint256);
562 }
563 
564 
565 /**
566  * @dev Interface of the ERC20 standard as defined in the EIP.
567  */
568 interface IERC20 {
569     /**
570      * @dev Returns the amount of tokens in existence.
571      */
572     function totalSupply() external view returns (uint256);
573 
574     /**
575      * @dev Returns the amount of tokens owned by `account`.
576      */
577     function balanceOf(address account) external view returns (uint256);
578 
579     /**
580      * @dev Moves `amount` tokens from the caller's account to `recipient`.
581      *
582      * Returns a boolean value indicating whether the operation succeeded.
583      *
584      * Emits a {Transfer} event.
585      */
586     function transfer(address recipient, uint256 amount) external returns (bool);
587 
588     /**
589      * @dev Returns the remaining number of tokens that `spender` will be
590      * allowed to spend on behalf of `owner` through {transferFrom}. This is
591      * zero by default.
592      *
593      * This value changes when {approve} or {transferFrom} are called.
594      */
595     function allowance(address owner, address spender) external view returns (uint256);
596 
597     /**
598      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
599      *
600      * Returns a boolean value indicating whether the operation succeeded.
601      *
602      * IMPORTANT: Beware that changing an allowance with this method brings the risk
603      * that someone may use both the old and the new allowance by unfortunate
604      * transaction ordering. One possible solution to mitigate this race
605      * condition is to first reduce the spender's allowance to 0 and set the
606      * desired value afterwards:
607      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
608      *
609      * Emits an {Approval} event.
610      */
611     function approve(address spender, uint256 amount) external returns (bool);
612 
613     /**
614      * @dev Moves `amount` tokens from `sender` to `recipient` using the
615      * allowance mechanism. `amount` is then deducted from the caller's
616      * allowance.
617      *
618      * Returns a boolean value indicating whether the operation succeeded.
619      *
620      * Emits a {Transfer} event.
621      */
622     function transferFrom(
623         address sender,
624         address recipient,
625         uint256 amount
626     ) external returns (bool);
627 
628     /**
629      * @dev Emitted when `value` tokens are moved from one account (`from`) to
630      * another (`to`).
631      *
632      * Note that `value` may be zero.
633      */
634     event Transfer(address indexed from, address indexed to, uint256 value);
635 
636     /**
637      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
638      * a call to {approve}. `value` is the new allowance.
639      */
640     event Approval(address indexed owner, address indexed spender, uint256 value);
641 }
642 
643 
644 /**
645  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
646  * the Metadata extension, but not including the Enumerable extension, which is available separately as
647  * {ERC721Enumerable}.
648  */
649 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
650     using Address for address;
651     using Strings for uint256;
652 
653     // Token name
654     string private _name;
655 
656     // Token symbol
657     string private _symbol;
658 
659     // Mapping from token ID to owner address
660     mapping (uint256 => address) private _owners;
661 
662     // Mapping owner address to token count
663     mapping (address => uint256) private _balances;
664 
665     // Mapping from token ID to approved address
666     mapping (uint256 => address) private _tokenApprovals;
667 
668     // Mapping from owner to operator approvals
669     mapping (address => mapping (address => bool)) private _operatorApprovals;
670 
671     /**
672      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
673      */
674     constructor (string memory name_, string memory symbol_) {
675         _name = name_;
676         _symbol = symbol_;
677     }
678 
679     /**
680      * @dev See {IERC165-supportsInterface}.
681      */
682     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
683         return interfaceId == type(IERC721).interfaceId
684             || interfaceId == type(IERC721Metadata).interfaceId
685             || super.supportsInterface(interfaceId);
686     }
687 
688     /**
689      * @dev See {IERC721-balanceOf}.
690      */
691     function balanceOf(address owner) public view virtual override returns (uint256) {
692         require(owner != address(0), "ERC721: balance query for the zero address");
693         return _balances[owner];
694     }
695 
696     /**
697      * @dev See {IERC721-ownerOf}.
698      */
699     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
700         address owner = _owners[tokenId];
701         require(owner != address(0), "ERC721: owner query for nonexistent token");
702         return owner;
703     }
704 
705     /**
706      * @dev See {IERC721Metadata-name}.
707      */
708     function name() public view virtual override returns (string memory) {
709         return _name;
710     }
711 
712     /**
713      * @dev See {IERC721Metadata-symbol}.
714      */
715     function symbol() public view virtual override returns (string memory) {
716         return _symbol;
717     }
718 
719     /**
720      * @dev See {IERC721Metadata-tokenURI}.
721      */
722     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
723         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
724 
725         string memory baseURI = _baseURI();
726         return bytes(baseURI).length > 0
727             ? string(abi.encodePacked(baseURI, tokenId.toString()))
728             : '';
729     }
730 
731     /**
732      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
733      * in child contracts.
734      */
735     function _baseURI() internal view virtual returns (string memory) {
736         return "";
737     }
738 
739     /**
740      * @dev See {IERC721-approve}.
741      */
742     function approve(address to, uint256 tokenId) public virtual override {
743         address owner = ERC721.ownerOf(tokenId);
744         require(to != owner, "ERC721: approval to current owner");
745 
746         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
747             "ERC721: approve caller is not owner nor approved for all"
748         );
749 
750         _approve(to, tokenId);
751     }
752 
753     /**
754      * @dev See {IERC721-getApproved}.
755      */
756     function getApproved(uint256 tokenId) public view virtual override returns (address) {
757         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
758 
759         return _tokenApprovals[tokenId];
760     }
761 
762     /**
763      * @dev See {IERC721-setApprovalForAll}.
764      */
765     function setApprovalForAll(address operator, bool approved) public virtual override {
766         require(operator != _msgSender(), "ERC721: approve to caller");
767 
768         _operatorApprovals[_msgSender()][operator] = approved;
769         emit ApprovalForAll(_msgSender(), operator, approved);
770     }
771 
772     /**
773      * @dev See {IERC721-isApprovedForAll}.
774      */
775     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
776         return _operatorApprovals[owner][operator];
777     }
778 
779     /**
780      * @dev See {IERC721-transferFrom}.
781      */
782     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
783         //solhint-disable-next-line max-line-length
784         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
785 
786         _transfer(from, to, tokenId);
787     }
788 
789     /**
790      * @dev See {IERC721-safeTransferFrom}.
791      */
792     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
793         safeTransferFrom(from, to, tokenId, "");
794     }
795 
796     /**
797      * @dev See {IERC721-safeTransferFrom}.
798      */
799     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
800         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
801         _safeTransfer(from, to, tokenId, _data);
802     }
803 
804     /**
805      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
806      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
807      *
808      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
809      *
810      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
811      * implement alternative mechanisms to perform token transfer, such as signature-based.
812      *
813      * Requirements:
814      *
815      * - `from` cannot be the zero address.
816      * - `to` cannot be the zero address.
817      * - `tokenId` token must exist and be owned by `from`.
818      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
819      *
820      * Emits a {Transfer} event.
821      */
822     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
823         _transfer(from, to, tokenId);
824         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
825     }
826 
827     /**
828      * @dev Returns whether `tokenId` exists.
829      *
830      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
831      *
832      * Tokens start existing when they are minted (`_mint`),
833      * and stop existing when they are burned (`_burn`).
834      */
835     function _exists(uint256 tokenId) internal view virtual returns (bool) {
836         return _owners[tokenId] != address(0);
837     }
838 
839     /**
840      * @dev Returns whether `spender` is allowed to manage `tokenId`.
841      *
842      * Requirements:
843      *
844      * - `tokenId` must exist.
845      */
846     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
847         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
848         address owner = ERC721.ownerOf(tokenId);
849         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
850     }
851 
852     /**
853      * @dev Safely mints `tokenId` and transfers it to `to`.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must not exist.
858      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _safeMint(address to, uint256 tokenId) internal virtual {
863         _safeMint(to, tokenId, "");
864     }
865 
866     /**
867      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
868      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
869      */
870     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
871         _mint(to, tokenId);
872         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
873     }
874 
875     /**
876      * @dev Mints `tokenId` and transfers it to `to`.
877      *
878      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
879      *
880      * Requirements:
881      *
882      * - `tokenId` must not exist.
883      * - `to` cannot be the zero address.
884      *
885      * Emits a {Transfer} event.
886      */
887     function _mint(address to, uint256 tokenId) internal virtual {
888         require(to != address(0), "ERC721: mint to the zero address");
889         require(!_exists(tokenId), "ERC721: token already minted");
890 
891         _beforeTokenTransfer(address(0), to, tokenId);
892 
893         _balances[to] += 1;
894         _owners[tokenId] = to;
895 
896         emit Transfer(address(0), to, tokenId);
897     }
898 
899     /**
900      * @dev Destroys `tokenId`.
901      * The approval is cleared when the token is burned.
902      *
903      * Requirements:
904      *
905      * - `tokenId` must exist.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _burn(uint256 tokenId) internal virtual {
910         address owner = ERC721.ownerOf(tokenId);
911 
912         _beforeTokenTransfer(owner, address(0), tokenId);
913 
914         // Clear approvals
915         _approve(address(0), tokenId);
916 
917         _balances[owner] -= 1;
918         delete _owners[tokenId];
919 
920         emit Transfer(owner, address(0), tokenId);
921     }
922 
923     /**
924      * @dev Transfers `tokenId` from `from` to `to`.
925      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
926      *
927      * Requirements:
928      *
929      * - `to` cannot be the zero address.
930      * - `tokenId` token must be owned by `from`.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _transfer(address from, address to, uint256 tokenId) internal virtual {
935         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
936         require(to != address(0), "ERC721: transfer to the zero address");
937 
938         _beforeTokenTransfer(from, to, tokenId);
939 
940         // Clear approvals from the previous owner
941         _approve(address(0), tokenId);
942 
943         _balances[from] -= 1;
944         _balances[to] += 1;
945         _owners[tokenId] = to;
946 
947         emit Transfer(from, to, tokenId);
948     }
949 
950     /**
951      * @dev Approve `to` to operate on `tokenId`
952      *
953      * Emits a {Approval} event.
954      */
955     function _approve(address to, uint256 tokenId) internal virtual {
956         _tokenApprovals[tokenId] = to;
957         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
958     }
959 
960     /**
961      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
962      * The call is not executed if the target address is not a contract.
963      *
964      * @param from address representing the previous owner of the given token ID
965      * @param to target address that will receive the tokens
966      * @param tokenId uint256 ID of the token to be transferred
967      * @param _data bytes optional data to send along with the call
968      * @return bool whether the call correctly returned the expected magic value
969      */
970     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
971         private returns (bool)
972     {
973         if (to.isContract()) {
974             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
975                 return retval == IERC721Receiver(to).onERC721Received.selector;
976             } catch (bytes memory reason) {
977                 if (reason.length == 0) {
978                     revert("ERC721: transfer to non ERC721Receiver implementer");
979                 } else {
980                     // solhint-disable-next-line no-inline-assembly
981                     assembly {
982                         revert(add(32, reason), mload(reason))
983                     }
984                 }
985             }
986         } else {
987             return true;
988         }
989     }
990 
991     /**
992      * @dev Hook that is called before any token transfer. This includes minting
993      * and burning.
994      *
995      * Calling conditions:
996      *
997      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
998      * transferred to `to`.
999      * - When `from` is zero, `tokenId` will be minted for `to`.
1000      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1001      * - `from` cannot be the zero address.
1002      * - `to` cannot be the zero address.
1003      *
1004      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1005      */
1006     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1007 }
1008 
1009 
1010 /**
1011  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1012  * enumerability of all the token ids in the contract as well as all token ids owned by each
1013  * account.
1014  */
1015 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1016     // Mapping from owner to list of owned token IDs
1017     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1018 
1019     // Mapping from token ID to index of the owner tokens list
1020     mapping(uint256 => uint256) private _ownedTokensIndex;
1021 
1022     // Array with all token ids, used for enumeration
1023     uint256[] private _allTokens;
1024 
1025     // Mapping from token id to position in the allTokens array
1026     mapping(uint256 => uint256) private _allTokensIndex;
1027 
1028     /**
1029      * @dev See {IERC165-supportsInterface}.
1030      */
1031     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1032         return interfaceId == type(IERC721Enumerable).interfaceId
1033             || super.supportsInterface(interfaceId);
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1038      */
1039     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1040         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1041         return _ownedTokens[owner][index];
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Enumerable-totalSupply}.
1046      */
1047     function totalSupply() public view virtual override returns (uint256) {
1048         return _allTokens.length;
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Enumerable-tokenByIndex}.
1053      */
1054     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1055         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1056         return _allTokens[index];
1057     }
1058 
1059     /**
1060      * @dev Hook that is called before any token transfer. This includes minting
1061      * and burning.
1062      *
1063      * Calling conditions:
1064      *
1065      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1066      * transferred to `to`.
1067      * - When `from` is zero, `tokenId` will be minted for `to`.
1068      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1069      * - `from` cannot be the zero address.
1070      * - `to` cannot be the zero address.
1071      *
1072      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1073      */
1074     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1075         super._beforeTokenTransfer(from, to, tokenId);
1076 
1077         if (from == address(0)) {
1078             _addTokenToAllTokensEnumeration(tokenId);
1079         } else if (from != to) {
1080             _removeTokenFromOwnerEnumeration(from, tokenId);
1081         }
1082         if (to == address(0)) {
1083             _removeTokenFromAllTokensEnumeration(tokenId);
1084         } else if (to != from) {
1085             _addTokenToOwnerEnumeration(to, tokenId);
1086         }
1087     }
1088 
1089     /**
1090      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1091      * @param to address representing the new owner of the given token ID
1092      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1093      */
1094     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1095         uint256 length = ERC721.balanceOf(to);
1096         _ownedTokens[to][length] = tokenId;
1097         _ownedTokensIndex[tokenId] = length;
1098     }
1099 
1100     /**
1101      * @dev Private function to add a token to this extension's token tracking data structures.
1102      * @param tokenId uint256 ID of the token to be added to the tokens list
1103      */
1104     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1105         _allTokensIndex[tokenId] = _allTokens.length;
1106         _allTokens.push(tokenId);
1107     }
1108 
1109     /**
1110      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1111      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1112      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1113      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1114      * @param from address representing the previous owner of the given token ID
1115      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1116      */
1117     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1118         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1119         // then delete the last slot (swap and pop).
1120 
1121         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1122         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1123 
1124         // When the token to delete is the last token, the swap operation is unnecessary
1125         if (tokenIndex != lastTokenIndex) {
1126             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1127 
1128             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1129             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1130         }
1131 
1132         // This also deletes the contents at the last position of the array
1133         delete _ownedTokensIndex[tokenId];
1134         delete _ownedTokens[from][lastTokenIndex];
1135     }
1136 
1137     /**
1138      * @dev Private function to remove a token from this extension's token tracking data structures.
1139      * This has O(1) time complexity, but alters the order of the _allTokens array.
1140      * @param tokenId uint256 ID of the token to be removed from the tokens list
1141      */
1142     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1143         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1144         // then delete the last slot (swap and pop).
1145 
1146         uint256 lastTokenIndex = _allTokens.length - 1;
1147         uint256 tokenIndex = _allTokensIndex[tokenId];
1148 
1149         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1150         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1151         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1152         uint256 lastTokenId = _allTokens[lastTokenIndex];
1153 
1154         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1155         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1156 
1157         // This also deletes the contents at the last position of the array
1158         delete _allTokensIndex[tokenId];
1159         _allTokens.pop();
1160     }
1161 }
1162 
1163 
1164 
1165 
1166 
1167 
1168 contract Noone is ERC721Enumerable, Ownable {
1169 
1170     using Strings for uint256;
1171 
1172     string _baseTokenURI = "";
1173     uint256 private _price = 0.03 ether;
1174     bool public _paused = true;
1175     uint256 public _minAmount = 250 * 10e6 * 10e9;
1176     IERC20 private _noone;
1177     uint256 private _reserved = 1;
1178     
1179     // withdraw addresses
1180     address t1 = 0x3f955CdA88ab1de002451766138857C123867bff;
1181     
1182     modifier canWithdraw(){
1183         require(address(this).balance > 0.2 ether);
1184         _;
1185     }
1186 
1187     struct ContractOwners {
1188         address payable addr;
1189         uint percent;
1190     }
1191 
1192     ContractOwners[] contractOnwers;
1193 
1194     constructor() ERC721("NooneNFT", "NOONENFT")  {
1195         _safeMint( t1, 0);
1196         contractOnwers.push(ContractOwners(payable(address(t1)), 100));
1197         _noone = IERC20(0xf657D69c62C39be9da87D0Fb7625b2f730B5AF8f);
1198     }
1199 
1200     function buyNoone(uint256 num) public payable {
1201         uint256 supply = totalSupply();
1202         require( !_paused,                              "Sale paused" );
1203         require( num < 2,                               "You can buy a maximum of 1 NOONENFT" );
1204         require(_noone.balanceOf(_msgSender()) >= _minAmount, "Not enough NOONE tokens");
1205         require( supply + num < 501 - _reserved,                    "Exceeds maximum NOONENFT supply" );
1206         require( msg.value >= _price * num,             "Ether sent is not correct" );
1207 
1208         for(uint256 i; i < num; i++){
1209             _safeMint( msg.sender, supply + i );
1210         }
1211     }
1212 
1213 
1214     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1215         uint256 tokenCount = balanceOf(_owner);
1216 
1217         uint256[] memory tokensId = new uint256[](tokenCount);
1218         for(uint256 i; i < tokenCount; i++){
1219             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1220         }
1221         return tokensId;
1222     }
1223 
1224     function setPrice(uint256 _newPrice) public onlyOwner() {
1225         _price = _newPrice;
1226     }
1227     
1228     function setMinAmount(uint256 _newMinAmount) public onlyOwner() {
1229         _minAmount = _newMinAmount;
1230     }
1231     
1232     
1233     function getMinAmount() public view returns (uint256){
1234         return _minAmount;
1235     }
1236 
1237     function _baseURI() internal view virtual override returns (string memory) {
1238         return _baseTokenURI;
1239     }
1240 
1241     function setBaseURI(string memory baseURI) public onlyOwner {
1242         _baseTokenURI = baseURI;
1243     }
1244 
1245     function getPrice() public view returns (uint256){
1246         return _price;
1247     }
1248 
1249 
1250     function pause(bool val) public onlyOwner {
1251         _paused = val;
1252     }
1253 
1254     function withdraw() external payable onlyOwner() canWithdraw() {
1255         uint nbalance = address(this).balance - 0.1 ether;
1256         for(uint i = 0; i < contractOnwers.length; i++){
1257             ContractOwners storage o = contractOnwers[i];
1258             o.addr.transfer((nbalance * o.percent) / 100);
1259         }
1260     }
1261 }