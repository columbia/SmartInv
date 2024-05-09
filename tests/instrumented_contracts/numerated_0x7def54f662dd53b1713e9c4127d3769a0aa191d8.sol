1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.0;
3 
4 
5 
6 //    ▄████████    ▄████████    ▄████████  ▄█   ▄████████    ▄████████    ▄████████    ▄████████    ▄████████    ▄████████
7 //   ███    ███   ███    ███   ███    ███ ███  ███    ███   ███    ███   ███    ███   ███    ███   ███    ███   ███    ███
8 //   ███    ███   ███    █▀    ███    ███ ███▌ ███    █▀    ███    ███   ███    ███   ███    ███   ███    ███   ███    █▀
9 //   ███    ███  ▄███▄▄▄      ▄███▄▄▄▄██▀ ███▌ ███          ███    ███  ▄███▄▄▄▄██▀   ███    ███  ▄███▄▄▄▄██▀  ▄███▄▄▄
10 // ▀███████████ ▀▀███▀▀▀     ▀▀███▀▀▀▀▀   ███▌ ███        ▀███████████ ▀▀███▀▀▀▀▀   ▀███████████ ▀▀███▀▀▀▀▀   ▀▀███▀▀▀
11 //   ███    ███   ███        ▀███████████ ███  ███    █▄    ███    ███ ▀███████████   ███    ███ ▀███████████   ███    █▄
12 //   ███    ███   ███          ███    ███ ███  ███    ███   ███    ███   ███    ███   ███    ███   ███    ███   ███    ███
13 //   ███    █▀    ███          ███    ███ █▀   ████████▀    ███    █▀    ███    ███   ███    █▀    ███    ███   ██████████
14 //                             ███    ███                                ███    ███                ███    ███
15 
16 
17 
18 /////////////IMPORTED LIBRARIES///////////
19 
20 /**
21  * @title Counters
22  * @author Matt Condon (@shrugs)
23  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
24  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
25  *
26  * Include with `using Counters for Counters.Counter;`
27  */
28 library Counters {
29     struct Counter {
30         // This variable should never be directly accessed by users of the library: interactions must be restricted to
31         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
32         // this feature: see https://github.com/ethereum/solidity/issues/4637
33         uint256 _value; // default: 0
34     }
35 
36     function current(Counter storage counter) internal view returns (uint256) {
37         return counter._value;
38     }
39 
40     function increment(Counter storage counter) internal {
41         unchecked {
42             counter._value += 1;
43         }
44     }
45 
46     function decrement(Counter storage counter) internal {
47         uint256 value = counter._value;
48         require(value > 0, "Counter: decrement overflow");
49         unchecked {
50             counter._value = value - 1;
51         }
52     }
53 
54     function reset(Counter storage counter) internal {
55         counter._value = 0;
56     }
57 
58     //Not in standard lib. Added by @beauwilliams
59     function set(Counter storage counter, uint256 value) internal {
60         counter._value = value;
61     }
62 }
63 
64 
65 
66 /**
67  * @dev Provides information about the current execution context, including the
68  * sender of the transaction and its data. While these are generally available
69  * via msg.sender and msg.data, they should not be accessed in such a direct
70  * manner, since when dealing with meta-transactions the account sending and
71  * paying for execution may not be the actual sender (as far as an application
72  * is concerned).
73  *
74  * This contract is only required for intermediate, library-like contracts.
75  */
76 abstract contract Context {
77     function _msgSender() internal view virtual returns (address) {
78         return msg.sender;
79     }
80 
81     function _msgData() internal view virtual returns (bytes calldata) {
82         return msg.data;
83     }
84 }
85 
86 
87 
88 /**
89  * @dev Contract module which provides a basic access control mechanism, where
90  * there is an account (an owner) that can be granted exclusive access to
91  * specific functions.
92  *
93  * By default, the owner account will be the one that deploys the contract. This
94  * can later be changed with {transferOwnership}.
95  *
96  * This module is used through inheritance. It will make available the modifier
97  * `onlyOwner`, which can be applied to your functions to restrict their use to
98  * the owner.
99  */
100 abstract contract Ownable is Context {
101     address private _owner;
102 
103     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
104 
105     /**
106      * @dev Initializes the contract setting the deployer as the initial owner.
107      */
108     constructor() {
109         _setOwner(_msgSender());
110     }
111 
112     /**
113      * @dev Returns the address of the current owner.
114      */
115     function owner() public view virtual returns (address) {
116         return _owner;
117     }
118 
119     /**
120      * @dev Throws if called by any account other than the owner.
121      */
122     modifier onlyOwner() {
123         require(owner() == _msgSender(), "Ownable: caller is not the owner");
124         _;
125     }
126 
127     /**
128      * @dev Leaves the contract without owner. It will not be possible to call
129      * `onlyOwner` functions anymore. Can only be called by the current owner.
130      *
131      * NOTE: Renouncing ownership will leave the contract without an owner,
132      * thereby removing any functionality that is only available to the owner.
133      */
134     function renounceOwnership() public virtual onlyOwner {
135         _setOwner(address(0));
136     }
137 
138     /**
139      * @dev Transfers ownership of the contract to a new account (`newOwner`).
140      * Can only be called by the current owner.
141      */
142     function transferOwnership(address newOwner) public virtual onlyOwner {
143         require(newOwner != address(0), "Ownable: new owner is the zero address");
144         _setOwner(newOwner);
145     }
146 
147     function _setOwner(address newOwner) private {
148         address oldOwner = _owner;
149         _owner = newOwner;
150         emit OwnershipTransferred(oldOwner, newOwner);
151     }
152 }
153 
154 
155 /**
156  * @dev Interface of the ERC165 standard, as defined in the
157  * https://eips.ethereum.org/EIPS/eip-165[EIP].
158  *
159  * Implementers can declare support of contract interfaces, which can then be
160  * queried by others ({ERC165Checker}).
161  *
162  * For an implementation, see {ERC165}.
163  */
164 interface IERC165 {
165     /**
166      * @dev Returns true if this contract implements the interface defined by
167      * `interfaceId`. See the corresponding
168      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
169      * to learn more about how these ids are created.
170      *
171      * This function call must use less than 30 000 gas.
172      */
173     function supportsInterface(bytes4 interfaceId) external view returns (bool);
174 }
175 
176 
177 /**
178  * @dev Required interface of an ERC721 compliant contract.
179  */
180 interface IERC721 is IERC165 {
181     /**
182      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
183      */
184     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
185 
186     /**
187      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
188      */
189     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
190 
191     /**
192      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
193      */
194     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
195 
196     /**
197      * @dev Returns the number of tokens in ``owner``'s account.
198      */
199     function balanceOf(address owner) external view returns (uint256 balance);
200 
201     /**
202      * @dev Returns the owner of the `tokenId` token.
203      *
204      * Requirements:
205      *
206      * - `tokenId` must exist.
207      */
208     function ownerOf(uint256 tokenId) external view returns (address owner);
209 
210     /**
211      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
212      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
213      *
214      * Requirements:
215      *
216      * - `from` cannot be the zero address.
217      * - `to` cannot be the zero address.
218      * - `tokenId` token must exist and be owned by `from`.
219      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
220      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
221      *
222      * Emits a {Transfer} event.
223      */
224     function safeTransferFrom(
225         address from,
226         address to,
227         uint256 tokenId
228     ) external;
229 
230     /**
231      * @dev Transfers `tokenId` token from `from` to `to`.
232      *
233      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
234      *
235      * Requirements:
236      *
237      * - `from` cannot be the zero address.
238      * - `to` cannot be the zero address.
239      * - `tokenId` token must be owned by `from`.
240      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
241      *
242      * Emits a {Transfer} event.
243      */
244     function transferFrom(
245         address from,
246         address to,
247         uint256 tokenId
248     ) external;
249 
250     /**
251      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
252      * The approval is cleared when the token is transferred.
253      *
254      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
255      *
256      * Requirements:
257      *
258      * - The caller must own the token or be an approved operator.
259      * - `tokenId` must exist.
260      *
261      * Emits an {Approval} event.
262      */
263     function approve(address to, uint256 tokenId) external;
264 
265     /**
266      * @dev Returns the account approved for `tokenId` token.
267      *
268      * Requirements:
269      *
270      * - `tokenId` must exist.
271      */
272     function getApproved(uint256 tokenId) external view returns (address operator);
273 
274     /**
275      * @dev Approve or remove `operator` as an operator for the caller.
276      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
277      *
278      * Requirements:
279      *
280      * - The `operator` cannot be the caller.
281      *
282      * Emits an {ApprovalForAll} event.
283      */
284     function setApprovalForAll(address operator, bool _approved) external;
285 
286     /**
287      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
288      *
289      * See {setApprovalForAll}
290      */
291     function isApprovedForAll(address owner, address operator) external view returns (bool);
292 
293     /**
294      * @dev Safely transfers `tokenId` token from `from` to `to`.
295      *
296      * Requirements:
297      *
298      * - `from` cannot be the zero address.
299      * - `to` cannot be the zero address.
300      * - `tokenId` token must exist and be owned by `from`.
301      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
302      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
303      *
304      * Emits a {Transfer} event.
305      */
306     function safeTransferFrom(
307         address from,
308         address to,
309         uint256 tokenId,
310         bytes calldata data
311     ) external;
312 }
313 
314 
315 /**
316  * @title ERC721 token receiver interface
317  * @dev Interface for any contract that wants to support safeTransfers
318  * from ERC721 asset contracts.
319  */
320 interface IERC721Receiver {
321     /**
322      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
323      * by `operator` from `from`, this function is called.
324      *
325      * It must return its Solidity selector to confirm the token transfer.
326      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
327      *
328      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
329      */
330     function onERC721Received(
331         address operator,
332         address from,
333         uint256 tokenId,
334         bytes calldata data
335     ) external returns (bytes4);
336 }
337 
338 
339 /**
340  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
341  * @dev See https://eips.ethereum.org/EIPS/eip-721
342  */
343 interface IERC721Metadata is IERC721 {
344     /**
345      * @dev Returns the token collection name.
346      */
347     function name() external view returns (string memory);
348 
349     /**
350      * @dev Returns the token collection symbol.
351      */
352     function symbol() external view returns (string memory);
353 
354     /**
355      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
356      */
357     function tokenURI(uint256 tokenId) external view returns (string memory);
358 }
359 
360 /**
361  * @dev Collection of functions related to the address type
362  */
363 library Address {
364     /**
365      * @dev Returns true if `account` is a contract.
366      *
367      * [IMPORTANT]
368      * ====
369      * It is unsafe to assume that an address for which this function returns
370      * false is an externally-owned account (EOA) and not a contract.
371      *
372      * Among others, `isContract` will return false for the following
373      * types of addresses:
374      *
375      *  - an externally-owned account
376      *  - a contract in construction
377      *  - an address where a contract will be created
378      *  - an address where a contract lived, but was destroyed
379      * ====
380      */
381     function isContract(address account) internal view returns (bool) {
382         // This method relies on extcodesize, which returns 0 for contracts in
383         // construction, since the code is only stored at the end of the
384         // constructor execution.
385 
386         uint256 size;
387         assembly {
388             size := extcodesize(account)
389         }
390         return size > 0;
391     }
392 
393     /**
394      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
395      * `recipient`, forwarding all available gas and reverting on errors.
396      *
397      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
398      * of certain opcodes, possibly making contracts go over the 2300 gas limit
399      * imposed by `transfer`, making them unable to receive funds via
400      * `transfer`. {sendValue} removes this limitation.
401      *
402      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
403      *
404      * IMPORTANT: because control is transferred to `recipient`, care must be
405      * taken to not create reentrancy vulnerabilities. Consider using
406      * {ReentrancyGuard} or the
407      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
408      */
409     function sendValue(address payable recipient, uint256 amount) internal {
410         require(address(this).balance >= amount, "Address: insufficient balance");
411 
412         (bool success, ) = recipient.call{value: amount}("");
413         require(success, "Address: unable to send value, recipient may have reverted");
414     }
415 
416     /**
417      * @dev Performs a Solidity function call using a low level `call`. A
418      * plain `call` is an unsafe replacement for a function call: use this
419      * function instead.
420      *
421      * If `target` reverts with a revert reason, it is bubbled up by this
422      * function (like regular Solidity function calls).
423      *
424      * Returns the raw returned data. To convert to the expected return value,
425      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
426      *
427      * Requirements:
428      *
429      * - `target` must be a contract.
430      * - calling `target` with `data` must not revert.
431      *
432      * _Available since v3.1._
433      */
434     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
435         return functionCall(target, data, "Address: low-level call failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
440      * `errorMessage` as a fallback revert reason when `target` reverts.
441      *
442      * _Available since v3.1._
443      */
444     function functionCall(
445         address target,
446         bytes memory data,
447         string memory errorMessage
448     ) internal returns (bytes memory) {
449         return functionCallWithValue(target, data, 0, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but also transferring `value` wei to `target`.
455      *
456      * Requirements:
457      *
458      * - the calling contract must have an ETH balance of at least `value`.
459      * - the called Solidity function must be `payable`.
460      *
461      * _Available since v3.1._
462      */
463     function functionCallWithValue(
464         address target,
465         bytes memory data,
466         uint256 value
467     ) internal returns (bytes memory) {
468         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
473      * with `errorMessage` as a fallback revert reason when `target` reverts.
474      *
475      * _Available since v3.1._
476      */
477     function functionCallWithValue(
478         address target,
479         bytes memory data,
480         uint256 value,
481         string memory errorMessage
482     ) internal returns (bytes memory) {
483         require(address(this).balance >= value, "Address: insufficient balance for call");
484         require(isContract(target), "Address: call to non-contract");
485 
486         (bool success, bytes memory returndata) = target.call{value: value}(data);
487         return verifyCallResult(success, returndata, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but performing a static call.
493      *
494      * _Available since v3.3._
495      */
496     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
497         return functionStaticCall(target, data, "Address: low-level static call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
502      * but performing a static call.
503      *
504      * _Available since v3.3._
505      */
506     function functionStaticCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal view returns (bytes memory) {
511         require(isContract(target), "Address: static call to non-contract");
512 
513         (bool success, bytes memory returndata) = target.staticcall(data);
514         return verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
519      * but performing a delegate call.
520      *
521      * _Available since v3.4._
522      */
523     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
524         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
529      * but performing a delegate call.
530      *
531      * _Available since v3.4._
532      */
533     function functionDelegateCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         require(isContract(target), "Address: delegate call to non-contract");
539 
540         (bool success, bytes memory returndata) = target.delegatecall(data);
541         return verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
546      * revert reason using the provided one.
547      *
548      * _Available since v4.3._
549      */
550     function verifyCallResult(
551         bool success,
552         bytes memory returndata,
553         string memory errorMessage
554     ) internal pure returns (bytes memory) {
555         if (success) {
556             return returndata;
557         } else {
558             // Look for revert reason and bubble it up if present
559             if (returndata.length > 0) {
560                 // The easiest way to bubble the revert reason is using memory via assembly
561 
562                 assembly {
563                     let returndata_size := mload(returndata)
564                     revert(add(32, returndata), returndata_size)
565                 }
566             } else {
567                 revert(errorMessage);
568             }
569         }
570     }
571 }
572 
573 
574 /**
575  * @dev String operations.
576  */
577 library Strings {
578     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
579 
580     /**
581      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
582      */
583     function toString(uint256 value) internal pure returns (string memory) {
584         // Inspired by OraclizeAPI's implementation - MIT licence
585         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
586 
587         if (value == 0) {
588             return "0";
589         }
590         uint256 temp = value;
591         uint256 digits;
592         while (temp != 0) {
593             digits++;
594             temp /= 10;
595         }
596         bytes memory buffer = new bytes(digits);
597         while (value != 0) {
598             digits -= 1;
599             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
600             value /= 10;
601         }
602         return string(buffer);
603     }
604 
605     /**
606      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
607      */
608     function toHexString(uint256 value) internal pure returns (string memory) {
609         if (value == 0) {
610             return "0x00";
611         }
612         uint256 temp = value;
613         uint256 length = 0;
614         while (temp != 0) {
615             length++;
616             temp >>= 8;
617         }
618         return toHexString(value, length);
619     }
620 
621     /**
622      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
623      */
624     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
625         bytes memory buffer = new bytes(2 * length + 2);
626         buffer[0] = "0";
627         buffer[1] = "x";
628         for (uint256 i = 2 * length + 1; i > 1; --i) {
629             buffer[i] = _HEX_SYMBOLS[value & 0xf];
630             value >>= 4;
631         }
632         require(value == 0, "Strings: hex length insufficient");
633         return string(buffer);
634     }
635 }
636 
637 
638 /**
639  * @dev Implementation of the {IERC165} interface.
640  *
641  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
642  * for the additional interface id that will be supported. For example:
643  *
644  * ```solidity
645  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
646  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
647  * }
648  * ```
649  *
650  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
651  */
652 abstract contract ERC165 is IERC165 {
653     /**
654      * @dev See {IERC165-supportsInterface}.
655      */
656     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
657         return interfaceId == type(IERC165).interfaceId;
658     }
659 }
660 
661 
662 
663 
664 
665 
666 
667 
668 
669 /**
670  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
671  * the Metadata extension, but not including the Enumerable extension, which is available separately as
672  * {ERC721Enumerable}.
673  */
674 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
675     using Address for address;
676     using Strings for uint256;
677 
678     // Token name
679     string private _name;
680 
681     // Token symbol
682     string private _symbol;
683 
684     // Mapping from token ID to owner address
685     mapping(uint256 => address) private _owners;
686 
687     // Mapping owner address to token count
688     mapping(address => uint256) private _balances;
689 
690     // Mapping from token ID to approved address
691     mapping(uint256 => address) private _tokenApprovals;
692 
693     // Mapping from owner to operator approvals
694     mapping(address => mapping(address => bool)) private _operatorApprovals;
695 
696     /**
697      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
698      */
699     constructor(string memory name_, string memory symbol_) {
700         _name = name_;
701         _symbol = symbol_;
702     }
703 
704     /**
705      * @dev See {IERC165-supportsInterface}.
706      */
707     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
708         return
709             interfaceId == type(IERC721).interfaceId ||
710             interfaceId == type(IERC721Metadata).interfaceId ||
711             super.supportsInterface(interfaceId);
712     }
713 
714     /**
715      * @dev See {IERC721-balanceOf}.
716      */
717     function balanceOf(address owner) public view virtual override returns (uint256) {
718         require(owner != address(0), "ERC721: balance query for the zero address");
719         return _balances[owner];
720     }
721 
722     /**
723      * @dev See {IERC721-ownerOf}.
724      */
725     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
726         address owner = _owners[tokenId];
727         require(owner != address(0), "ERC721: owner query for nonexistent token");
728         return owner;
729     }
730 
731     /**
732      * @dev See {IERC721Metadata-name}.
733      */
734     function name() public view virtual override returns (string memory) {
735         return _name;
736     }
737 
738     /**
739      * @dev See {IERC721Metadata-symbol}.
740      */
741     function symbol() public view virtual override returns (string memory) {
742         return _symbol;
743     }
744 
745     /**
746      * @dev See {IERC721Metadata-tokenURI}.
747      */
748     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
749         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
750 
751         string memory baseURI = _baseURI();
752         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
753     }
754 
755     /**
756      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
757      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
758      * by default, can be overriden in child contracts.
759      */
760     function _baseURI() internal view virtual returns (string memory) {
761         return "";
762     }
763 
764     /**
765      * @dev See {IERC721-approve}.
766      */
767     function approve(address to, uint256 tokenId) public virtual override {
768         address owner = ERC721.ownerOf(tokenId);
769         require(to != owner, "ERC721: approval to current owner");
770 
771         require(
772             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
773             "ERC721: approve caller is not owner nor approved for all"
774         );
775 
776         _approve(to, tokenId);
777     }
778 
779     /**
780      * @dev See {IERC721-getApproved}.
781      */
782     function getApproved(uint256 tokenId) public view virtual override returns (address) {
783         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
784 
785         return _tokenApprovals[tokenId];
786     }
787 
788     /**
789      * @dev See {IERC721-setApprovalForAll}.
790      */
791     function setApprovalForAll(address operator, bool approved) public virtual override {
792         require(operator != _msgSender(), "ERC721: approve to caller");
793 
794         _operatorApprovals[_msgSender()][operator] = approved;
795         emit ApprovalForAll(_msgSender(), operator, approved);
796     }
797 
798     /**
799      * @dev See {IERC721-isApprovedForAll}.
800      */
801     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
802         return _operatorApprovals[owner][operator];
803     }
804 
805     /**
806      * @dev See {IERC721-transferFrom}.
807      */
808     function transferFrom(
809         address from,
810         address to,
811         uint256 tokenId
812     ) public virtual override {
813         //solhint-disable-next-line max-line-length
814         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
815 
816         _transfer(from, to, tokenId);
817     }
818 
819     /**
820      * @dev See {IERC721-safeTransferFrom}.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) public virtual override {
827         safeTransferFrom(from, to, tokenId, "");
828     }
829 
830     /**
831      * @dev See {IERC721-safeTransferFrom}.
832      */
833     function safeTransferFrom(
834         address from,
835         address to,
836         uint256 tokenId,
837         bytes memory _data
838     ) public virtual override {
839         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
840         _safeTransfer(from, to, tokenId, _data);
841     }
842 
843     /**
844      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
845      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
846      *
847      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
848      *
849      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
850      * implement alternative mechanisms to perform token transfer, such as signature-based.
851      *
852      * Requirements:
853      *
854      * - `from` cannot be the zero address.
855      * - `to` cannot be the zero address.
856      * - `tokenId` token must exist and be owned by `from`.
857      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _safeTransfer(
862         address from,
863         address to,
864         uint256 tokenId,
865         bytes memory _data
866     ) internal virtual {
867         _transfer(from, to, tokenId);
868         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
869     }
870 
871     /**
872      * @dev Returns whether `tokenId` exists.
873      *
874      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
875      *
876      * Tokens start existing when they are minted (`_mint`),
877      * and stop existing when they are burned (`_burn`).
878      */
879     function _exists(uint256 tokenId) internal view virtual returns (bool) {
880         return _owners[tokenId] != address(0);
881     }
882 
883     /**
884      * @dev Returns whether `spender` is allowed to manage `tokenId`.
885      *
886      * Requirements:
887      *
888      * - `tokenId` must exist.
889      */
890     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
891         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
892         address owner = ERC721.ownerOf(tokenId);
893         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
894     }
895 
896     /**
897      * @dev Safely mints `tokenId` and transfers it to `to`.
898      *
899      * Requirements:
900      *
901      * - `tokenId` must not exist.
902      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _safeMint(address to, uint256 tokenId) internal virtual {
907         _safeMint(to, tokenId, "");
908     }
909 
910     /**
911      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
912      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
913      */
914     function _safeMint(
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) internal virtual {
919         _mint(to, tokenId);
920         require(
921             _checkOnERC721Received(address(0), to, tokenId, _data),
922             "ERC721: transfer to non ERC721Receiver implementer"
923         );
924     }
925 
926     /**
927      * @dev Mints `tokenId` and transfers it to `to`.
928      *
929      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
930      *
931      * Requirements:
932      *
933      * - `tokenId` must not exist.
934      * - `to` cannot be the zero address.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _mint(address to, uint256 tokenId) internal virtual {
939         require(to != address(0), "ERC721: mint to the zero address");
940         require(!_exists(tokenId), "ERC721: token already minted");
941 
942         _beforeTokenTransfer(address(0), to, tokenId);
943 
944         _balances[to] += 1;
945         _owners[tokenId] = to;
946 
947         emit Transfer(address(0), to, tokenId);
948     }
949 
950     /**
951      * @dev Destroys `tokenId`.
952      * The approval is cleared when the token is burned.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _burn(uint256 tokenId) internal virtual {
961         address owner = ERC721.ownerOf(tokenId);
962 
963         _beforeTokenTransfer(owner, address(0), tokenId);
964 
965         // Clear approvals
966         _approve(address(0), tokenId);
967 
968         _balances[owner] -= 1;
969         delete _owners[tokenId];
970 
971         emit Transfer(owner, address(0), tokenId);
972     }
973 
974     /**
975      * @dev Transfers `tokenId` from `from` to `to`.
976      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
977      *
978      * Requirements:
979      *
980      * - `to` cannot be the zero address.
981      * - `tokenId` token must be owned by `from`.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _transfer(
986         address from,
987         address to,
988         uint256 tokenId
989     ) internal virtual {
990         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
991         require(to != address(0), "ERC721: transfer to the zero address");
992 
993         _beforeTokenTransfer(from, to, tokenId);
994 
995         // Clear approvals from the previous owner
996         _approve(address(0), tokenId);
997 
998         _balances[from] -= 1;
999         _balances[to] += 1;
1000         _owners[tokenId] = to;
1001 
1002         emit Transfer(from, to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev Approve `to` to operate on `tokenId`
1007      *
1008      * Emits a {Approval} event.
1009      */
1010     function _approve(address to, uint256 tokenId) internal virtual {
1011         _tokenApprovals[tokenId] = to;
1012         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1017      * The call is not executed if the target address is not a contract.
1018      *
1019      * @param from address representing the previous owner of the given token ID
1020      * @param to target address that will receive the tokens
1021      * @param tokenId uint256 ID of the token to be transferred
1022      * @param _data bytes optional data to send along with the call
1023      * @return bool whether the call correctly returned the expected magic value
1024      */
1025     function _checkOnERC721Received(
1026         address from,
1027         address to,
1028         uint256 tokenId,
1029         bytes memory _data
1030     ) private returns (bool) {
1031         if (to.isContract()) {
1032             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1033                 return retval == IERC721Receiver.onERC721Received.selector;
1034             } catch (bytes memory reason) {
1035                 if (reason.length == 0) {
1036                     revert("ERC721: transfer to non ERC721Receiver implementer");
1037                 } else {
1038                     assembly {
1039                         revert(add(32, reason), mload(reason))
1040                     }
1041                 }
1042             }
1043         } else {
1044             return true;
1045         }
1046     }
1047 
1048     /**
1049      * @dev Hook that is called before any token transfer. This includes minting
1050      * and burning.
1051      *
1052      * Calling conditions:
1053      *
1054      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1055      * transferred to `to`.
1056      * - When `from` is zero, `tokenId` will be minted for `to`.
1057      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1058      * - `from` and `to` are never both zero.
1059      *
1060      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1061      */
1062     function _beforeTokenTransfer(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) internal virtual {}
1067 }
1068 
1069 /**
1070  * @dev Contract module which allows children to implement an emergency stop
1071  * mechanism that can be triggered by an authorized account.
1072  *
1073  * This module is used through inheritance. It will make available the
1074  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1075  * the functions of your contract. Note that they will not be pausable by
1076  * simply including this module, only once the modifiers are put in place.
1077  */
1078 abstract contract Pausable is Context {
1079     /**
1080      * @dev Emitted when the pause is triggered by `account`.
1081      */
1082     event Paused(address account);
1083 
1084     /**
1085      * @dev Emitted when the pause is lifted by `account`.
1086      */
1087     event Unpaused(address account);
1088 
1089     bool private _paused;
1090 
1091     /**
1092      * @dev Initializes the contract in unpaused state.
1093      */
1094     constructor () {
1095         _paused = false;
1096     }
1097 
1098     /**
1099      * @dev Returns true if the contract is paused, and false otherwise.
1100      */
1101     function paused() public view virtual returns (bool) {
1102         return _paused;
1103     }
1104 
1105     /**
1106      * @dev Modifier to make a function callable only when the contract is not paused.
1107      *
1108      * Requirements:
1109      *
1110      * - The contract must not be paused.
1111      */
1112     modifier whenNotPaused() {
1113         require(!paused(), "Pausable: paused");
1114         _;
1115     }
1116 
1117     /**
1118      * @dev Modifier to make a function callable only when the contract is paused.
1119      *
1120      * Requirements:
1121      *
1122      * - The contract must be paused.
1123      */
1124     modifier whenPaused() {
1125         require(paused(), "Pausable: not paused");
1126         _;
1127     }
1128 
1129     /**
1130      * @dev Triggers stopped state.
1131      *
1132      * Requirements:
1133      *
1134      * - The contract must not be paused.
1135      */
1136     function _pause() internal virtual whenNotPaused {
1137         _paused = true;
1138         emit Paused(_msgSender());
1139     }
1140 
1141     /**
1142      * @dev Returns to normal state.
1143      *
1144      * Requirements:
1145      *
1146      * - The contract must be paused.
1147      */
1148     function _unpause() internal virtual whenPaused {
1149         _paused = false;
1150         emit Unpaused(_msgSender());
1151     }
1152 }
1153 
1154 
1155 
1156 /**
1157  * @title AfricaRare Mint Contract
1158  * @author Beau Williams (@beauwilliams)
1159  * @dev Smart contract for Africarare Ubuntuland
1160  */
1161 
1162 contract UBUNTULAND is ERC721, Ownable, Pausable {
1163 
1164     //Tracks num minted
1165     uint256 public numMinted = 0;
1166 
1167     //Sets the URI base and head for where metadata is located on IPFS
1168     string public _baseURIextended = "https://gateway.pinata.cloud/ipfs/QmfS1tJoY1ZpHpa7RJvziV7MoRc6NXrHWARrWt7pdXAXwQ/AfricarareUbuntuland_";
1169     string public _headURIextended = ".json";
1170 
1171     // Mapping for token URIs
1172     mapping (uint256 => string) private _tokenURIs;
1173 
1174     //Constructor
1175     constructor() ERC721("Africarare Ubuntuland", "UBUL") {
1176     }
1177 
1178     /**
1179     * @dev returns base URI
1180     */
1181     function _baseURI() internal view virtual override returns (string memory) {
1182         return _baseURIextended;
1183     }
1184 
1185     /**
1186     * @dev sets base URI
1187     */
1188     function _setBaseURI(string memory baseURI) external onlyOwner {
1189         _baseURIextended = baseURI;
1190     }
1191 
1192     /**
1193     * @dev returns head URI
1194     */
1195     function _headURI() internal view virtual returns (string memory) {
1196         return _headURIextended;
1197     }
1198 
1199     /**
1200     * @dev sets head URI
1201     */
1202     function _setHeadURI(string memory headURI) external onlyOwner {
1203         _headURIextended = headURI;
1204     }
1205 
1206     /**
1207     * @dev sets token URI
1208     */
1209     function _setTokenURI(uint256 tokenId) internal virtual {
1210         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1211         _tokenURIs[tokenId] = Strings.toString(tokenId);
1212     }
1213 
1214     /**
1215     * @dev gets token URI
1216     */
1217     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1218         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1219         return string(abi.encodePacked(_baseURI(), Strings.toString(tokenId), _headURI()));
1220 
1221     }
1222 
1223     /**
1224     * @dev Mints 1 NFT to senders address
1225     */
1226     function mintSingleLandNFT(uint256 tokenId) internal onlyOwner {
1227         require(!_exists(tokenId), "That token ID has already been minted. Please try again.");
1228         ++numMinted;
1229         _safeMint(msg.sender, tokenId);
1230         _setTokenURI(tokenId);
1231 
1232     }
1233 
1234     /**
1235     * @dev Mints 1 NFT to specified address
1236     */
1237     function mintToAddressSingleLandNFT(uint256 tokenId, address receiverAddress) internal onlyOwner {
1238         require(!_exists(tokenId), "That token ID has already been minted. Please try again.");
1239         ++numMinted;
1240         _safeMint(receiverAddress, tokenId);
1241         _setTokenURI(tokenId);
1242 
1243     }
1244 
1245     /**
1246     * @dev Mints batch of n number of NFTs
1247     */
1248     function mintBatchOfLandNFT(uint256[] memory tokenIds) external onlyOwner {
1249         for (uint i=0; i < tokenIds.length; i++) {
1250             mintSingleLandNFT(tokenIds[i]);
1251         }
1252     }
1253 
1254     /**
1255     * @dev Mints batch of n number of NFTs to specified address
1256     */
1257     function mintToAddressBatchOfLandNFT(uint256[] memory tokenIds, address receiverAddress) external onlyOwner {
1258         for (uint i=0; i < tokenIds.length; i++) {
1259             mintToAddressSingleLandNFT(tokenIds[i], receiverAddress);
1260         }
1261     }
1262 
1263     /**
1264     * @dev Withdraw funds from this contract (Callable by owner)
1265     */
1266     function withdraw() external onlyOwner {
1267         uint256 balance = address(this).balance;
1268         address payable ownerAddress = payable(msg.sender);
1269         require(ownerAddress != address(0), "ERC20: transfer to the zero address");
1270         ownerAddress.transfer(balance);
1271     }
1272 
1273     /**
1274     * @dev Pause
1275     */
1276     function pause() external virtual onlyOwner() {
1277         super._pause();
1278     }
1279 
1280     /**
1281     * @dev Unpause
1282     */
1283     function unpause() external virtual onlyOwner() {
1284         super._unpause();
1285     }
1286 }