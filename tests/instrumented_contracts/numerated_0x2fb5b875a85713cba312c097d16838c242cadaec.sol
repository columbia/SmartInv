1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 // File: @openzeppelin/contracts/utils/Context.sol
47 
48 pragma solidity ^0.8.0;
49 
50 /*
51  * @dev Provides information about the current execution context, including the
52  * sender of the transaction and its data. While these are generally available
53  * via msg.sender and msg.data, they should not be accessed in such a direct
54  * manner, since when dealing with meta-transactions the account sending and
55  * paying for execution may not be the actual sender (as far as an application
56  * is concerned).
57  *
58  * This contract is only required for intermediate, library-like contracts.
59  */
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address) {
62         return msg.sender;
63     }
64 
65     function _msgData() internal view virtual returns (bytes calldata) {
66         return msg.data;
67     }
68 }
69 
70 // File: @openzeppelin/contracts/access/Ownable.sol
71 
72 
73 pragma solidity ^0.8.0;
74 
75 
76 /**
77  * @dev Contract module which provides a basic access control mechanism, where
78  * there is an account (an owner) that can be granted exclusive access to
79  * specific functions.
80  *
81  * By default, the owner account will be the one that deploys the contract. This
82  * can later be changed with {transferOwnership}.
83  *
84  * This module is used through inheritance. It will make available the modifier
85  * `onlyOwner`, which can be applied to your functions to restrict their use to
86  * the owner.
87  */
88 abstract contract Ownable is Context {
89     address private _owner;
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     /**
94      * @dev Initializes the contract setting the deployer as the initial owner.
95      */
96     constructor() {
97         _setOwner(_msgSender());
98     }
99 
100     /**
101      * @dev Returns the address of the current owner.
102      */
103     function owner() public view virtual returns (address) {
104         return _owner;
105     }
106 
107     /**
108      * @dev Throws if called by any account other than the owner.
109      */
110     modifier onlyOwner() {
111         require(owner() == _msgSender(), "Ownable: caller is not the owner");
112         _;
113     }
114 
115     /**
116      * @dev Leaves the contract without owner. It will not be possible to call
117      * `onlyOwner` functions anymore. Can only be called by the current owner.
118      *
119      * NOTE: Renouncing ownership will leave the contract without an owner,
120      * thereby removing any functionality that is only available to the owner.
121      */
122     function renounceOwnership() public virtual onlyOwner {
123         _setOwner(address(0));
124     }
125 
126     /**
127      * @dev Transfers ownership of the contract to a new account (`newOwner`).
128      * Can only be called by the current owner.
129      */
130     function transferOwnership(address newOwner) public virtual onlyOwner {
131         require(newOwner != address(0), "Ownable: new owner is the zero address");
132         _setOwner(newOwner);
133     }
134 
135     function _setOwner(address newOwner) private {
136         address oldOwner = _owner;
137         _owner = newOwner;
138         emit OwnershipTransferred(oldOwner, newOwner);
139     }
140 }
141 
142 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Interface of the ERC165 standard, as defined in the
148  * https://eips.ethereum.org/EIPS/eip-165[EIP].
149  *
150  * Implementers can declare support of contract interfaces, which can then be
151  * queried by others ({ERC165Checker}).
152  *
153  * For an implementation, see {ERC165}.
154  */
155 interface IERC165 {
156     /**
157      * @dev Returns true if this contract implements the interface defined by
158      * `interfaceId`. See the corresponding
159      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
160      * to learn more about how these ids are created.
161      *
162      * This function call must use less than 30 000 gas.
163      */
164     function supportsInterface(bytes4 interfaceId) external view returns (bool);
165 }
166 
167 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
168 
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @dev Required interface of an ERC721 compliant contract.
173  */
174 interface IERC721 is IERC165 {
175     /**
176      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
177      */
178     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
179 
180     /**
181      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
182      */
183     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
184 
185     /**
186      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
187      */
188     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
189 
190     /**
191      * @dev Returns the number of tokens in ``owner``'s account.
192      */
193     function balanceOf(address owner) external view returns (uint256 balance);
194 
195     /**
196      * @dev Returns the owner of the `tokenId` token.
197      *
198      * Requirements:
199      *
200      * - `tokenId` must exist.
201      */
202     function ownerOf(uint256 tokenId) external view returns (address owner);
203 
204     /**
205      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
206      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
207      *
208      * Requirements:
209      *
210      * - `from` cannot be the zero address.
211      * - `to` cannot be the zero address.
212      * - `tokenId` token must exist and be owned by `from`.
213      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
214      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
215      *
216      * Emits a {Transfer} event.
217      */
218     function safeTransferFrom(
219         address from,
220         address to,
221         uint256 tokenId
222     ) external;
223 
224     /**
225      * @dev Transfers `tokenId` token from `from` to `to`.
226      *
227      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
228      *
229      * Requirements:
230      *
231      * - `from` cannot be the zero address.
232      * - `to` cannot be the zero address.
233      * - `tokenId` token must be owned by `from`.
234      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
235      *
236      * Emits a {Transfer} event.
237      */
238     function transferFrom(
239         address from,
240         address to,
241         uint256 tokenId
242     ) external;
243 
244     /**
245      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
246      * The approval is cleared when the token is transferred.
247      *
248      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
249      *
250      * Requirements:
251      *
252      * - The caller must own the token or be an approved operator.
253      * - `tokenId` must exist.
254      *
255      * Emits an {Approval} event.
256      */
257     function approve(address to, uint256 tokenId) external;
258 
259     /**
260      * @dev Returns the account approved for `tokenId` token.
261      *
262      * Requirements:
263      *
264      * - `tokenId` must exist.
265      */
266     function getApproved(uint256 tokenId) external view returns (address operator);
267 
268     /**
269      * @dev Approve or remove `operator` as an operator for the caller.
270      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
271      *
272      * Requirements:
273      *
274      * - The `operator` cannot be the caller.
275      *
276      * Emits an {ApprovalForAll} event.
277      */
278     function setApprovalForAll(address operator, bool _approved) external;
279 
280     /**
281      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
282      *
283      * See {setApprovalForAll}
284      */
285     function isApprovedForAll(address owner, address operator) external view returns (bool);
286 
287     /**
288      * @dev Safely transfers `tokenId` token from `from` to `to`.
289      *
290      * Requirements:
291      *
292      * - `from` cannot be the zero address.
293      * - `to` cannot be the zero address.
294      * - `tokenId` token must exist and be owned by `from`.
295      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
296      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
297      *
298      * Emits a {Transfer} event.
299      */
300     function safeTransferFrom(
301         address from,
302         address to,
303         uint256 tokenId,
304         bytes calldata data
305     ) external;
306 }
307 
308 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
309 
310 pragma solidity ^0.8.0;
311 
312 
313 /**
314  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
315  * @dev See https://eips.ethereum.org/EIPS/eip-721
316  */
317 interface IERC721Enumerable is IERC721 {
318     /**
319      * @dev Returns the total amount of tokens stored by the contract.
320      */
321     function totalSupply() external view returns (uint256);
322 
323     /**
324      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
325      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
326      */
327     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
328 
329     /**
330      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
331      * Use along with {totalSupply} to enumerate all tokens.
332      */
333     function tokenByIndex(uint256 index) external view returns (uint256);
334 }
335 
336 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
337 
338 pragma solidity ^0.8.0;
339 
340 
341 /**
342  * @dev Implementation of the {IERC165} interface.
343  *
344  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
345  * for the additional interface id that will be supported. For example:
346  *
347  * ```solidity
348  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
349  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
350  * }
351  * ```
352  *
353  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
354  */
355 abstract contract ERC165 is IERC165 {
356     /**
357      * @dev See {IERC165-supportsInterface}.
358      */
359     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
360         return interfaceId == type(IERC165).interfaceId;
361     }
362 }
363 
364 // File: @openzeppelin/contracts/utils/Strings.sol
365 
366 pragma solidity ^0.8.0;
367 
368 /**
369  * @dev String operations.
370  */
371 library Strings {
372     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
373 
374     /**
375      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
376      */
377     function toString(uint256 value) internal pure returns (string memory) {
378         // Inspired by OraclizeAPI's implementation - MIT licence
379         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
380 
381         if (value == 0) {
382             return "0";
383         }
384         uint256 temp = value;
385         uint256 digits;
386         while (temp != 0) {
387             digits++;
388             temp /= 10;
389         }
390         bytes memory buffer = new bytes(digits);
391         while (value != 0) {
392             digits -= 1;
393             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
394             value /= 10;
395         }
396         return string(buffer);
397     }
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
401      */
402     function toHexString(uint256 value) internal pure returns (string memory) {
403         if (value == 0) {
404             return "0x00";
405         }
406         uint256 temp = value;
407         uint256 length = 0;
408         while (temp != 0) {
409             length++;
410             temp >>= 8;
411         }
412         return toHexString(value, length);
413     }
414 
415     /**
416      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
417      */
418     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
419         bytes memory buffer = new bytes(2 * length + 2);
420         buffer[0] = "0";
421         buffer[1] = "x";
422         for (uint256 i = 2 * length + 1; i > 1; --i) {
423             buffer[i] = _HEX_SYMBOLS[value & 0xf];
424             value >>= 4;
425         }
426         require(value == 0, "Strings: hex length insufficient");
427         return string(buffer);
428     }
429 }
430 
431 // File: @openzeppelin/contracts/utils/Address.sol
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev Collection of functions related to the address type
437  */
438 library Address {
439     /**
440      * @dev Returns true if `account` is a contract.
441      *
442      * [IMPORTANT]
443      * ====
444      * It is unsafe to assume that an address for which this function returns
445      * false is an externally-owned account (EOA) and not a contract.
446      *
447      * Among others, `isContract` will return false for the following
448      * types of addresses:
449      *
450      *  - an externally-owned account
451      *  - a contract in construction
452      *  - an address where a contract will be created
453      *  - an address where a contract lived, but was destroyed
454      * ====
455      */
456     function isContract(address account) internal view returns (bool) {
457         // This method relies on extcodesize, which returns 0 for contracts in
458         // construction, since the code is only stored at the end of the
459         // constructor execution.
460 
461         uint256 size;
462         assembly {
463             size := extcodesize(account)
464         }
465         return size > 0;
466     }
467 
468     /**
469      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
470      * `recipient`, forwarding all available gas and reverting on errors.
471      *
472      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
473      * of certain opcodes, possibly making contracts go over the 2300 gas limit
474      * imposed by `transfer`, making them unable to receive funds via
475      * `transfer`. {sendValue} removes this limitation.
476      *
477      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
478      *
479      * IMPORTANT: because control is transferred to `recipient`, care must be
480      * taken to not create reentrancy vulnerabilities. Consider using
481      * {ReentrancyGuard} or the
482      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
483      */
484     function sendValue(address payable recipient, uint256 amount) internal {
485         require(address(this).balance >= amount, "Address: insufficient balance");
486 
487         (bool success, ) = recipient.call{value: amount}("");
488         require(success, "Address: unable to send value, recipient may have reverted");
489     }
490 
491     /**
492      * @dev Performs a Solidity function call using a low level `call`. A
493      * plain `call` is an unsafe replacement for a function call: use this
494      * function instead.
495      *
496      * If `target` reverts with a revert reason, it is bubbled up by this
497      * function (like regular Solidity function calls).
498      *
499      * Returns the raw returned data. To convert to the expected return value,
500      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
501      *
502      * Requirements:
503      *
504      * - `target` must be a contract.
505      * - calling `target` with `data` must not revert.
506      *
507      * _Available since v3.1._
508      */
509     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
510         return functionCall(target, data, "Address: low-level call failed");
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
515      * `errorMessage` as a fallback revert reason when `target` reverts.
516      *
517      * _Available since v3.1._
518      */
519     function functionCall(
520         address target,
521         bytes memory data,
522         string memory errorMessage
523     ) internal returns (bytes memory) {
524         return functionCallWithValue(target, data, 0, errorMessage);
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
529      * but also transferring `value` wei to `target`.
530      *
531      * Requirements:
532      *
533      * - the calling contract must have an ETH balance of at least `value`.
534      * - the called Solidity function must be `payable`.
535      *
536      * _Available since v3.1._
537      */
538     function functionCallWithValue(
539         address target,
540         bytes memory data,
541         uint256 value
542     ) internal returns (bytes memory) {
543         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
548      * with `errorMessage` as a fallback revert reason when `target` reverts.
549      *
550      * _Available since v3.1._
551      */
552     function functionCallWithValue(
553         address target,
554         bytes memory data,
555         uint256 value,
556         string memory errorMessage
557     ) internal returns (bytes memory) {
558         require(address(this).balance >= value, "Address: insufficient balance for call");
559         require(isContract(target), "Address: call to non-contract");
560 
561         (bool success, bytes memory returndata) = target.call{value: value}(data);
562         return _verifyCallResult(success, returndata, errorMessage);
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
567      * but performing a static call.
568      *
569      * _Available since v3.3._
570      */
571     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
572         return functionStaticCall(target, data, "Address: low-level static call failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
577      * but performing a static call.
578      *
579      * _Available since v3.3._
580      */
581     function functionStaticCall(
582         address target,
583         bytes memory data,
584         string memory errorMessage
585     ) internal view returns (bytes memory) {
586         require(isContract(target), "Address: static call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.staticcall(data);
589         return _verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
594      * but performing a delegate call.
595      *
596      * _Available since v3.4._
597      */
598     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
599         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
604      * but performing a delegate call.
605      *
606      * _Available since v3.4._
607      */
608     function functionDelegateCall(
609         address target,
610         bytes memory data,
611         string memory errorMessage
612     ) internal returns (bytes memory) {
613         require(isContract(target), "Address: delegate call to non-contract");
614 
615         (bool success, bytes memory returndata) = target.delegatecall(data);
616         return _verifyCallResult(success, returndata, errorMessage);
617     }
618 
619     function _verifyCallResult(
620         bool success,
621         bytes memory returndata,
622         string memory errorMessage
623     ) private pure returns (bytes memory) {
624         if (success) {
625             return returndata;
626         } else {
627             // Look for revert reason and bubble it up if present
628             if (returndata.length > 0) {
629                 // The easiest way to bubble the revert reason is using memory via assembly
630 
631                 assembly {
632                     let returndata_size := mload(returndata)
633                     revert(add(32, returndata), returndata_size)
634                 }
635             } else {
636                 revert(errorMessage);
637             }
638         }
639     }
640 }
641 
642 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
643 
644 pragma solidity ^0.8.0;
645 
646 
647 /**
648  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
649  * @dev See https://eips.ethereum.org/EIPS/eip-721
650  */
651 interface IERC721Metadata is IERC721 {
652     /**
653      * @dev Returns the token collection name.
654      */
655     function name() external view returns (string memory);
656 
657     /**
658      * @dev Returns the token collection symbol.
659      */
660     function symbol() external view returns (string memory);
661 
662     /**
663      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
664      */
665     function tokenURI(uint256 tokenId) external view returns (string memory);
666 }
667 
668 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
669 
670 pragma solidity ^0.8.0;
671 
672 /**
673  * @title ERC721 token receiver interface
674  * @dev Interface for any contract that wants to support safeTransfers
675  * from ERC721 asset contracts.
676  */
677 interface IERC721Receiver {
678     /**
679      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
680      * by `operator` from `from`, this function is called.
681      *
682      * It must return its Solidity selector to confirm the token transfer.
683      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
684      *
685      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
686      */
687     function onERC721Received(
688         address operator,
689         address from,
690         uint256 tokenId,
691         bytes calldata data
692     ) external returns (bytes4);
693 }
694 
695 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
701  * the Metadata extension, but not including the Enumerable extension, which is available separately as
702  * {ERC721Enumerable}.
703  */
704 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
705     using Address for address;
706     using Strings for uint256;
707 
708     // Token name
709     string private _name;
710 
711     // Token symbol
712     string private _symbol;
713 
714     // Mapping from token ID to owner address
715     mapping(uint256 => address) private _owners;
716 
717     // Mapping owner address to token count
718     mapping(address => uint256) private _balances;
719 
720     // Mapping from token ID to approved address
721     mapping(uint256 => address) private _tokenApprovals;
722 
723     // Mapping from owner to operator approvals
724     mapping(address => mapping(address => bool)) private _operatorApprovals;
725 
726     /**
727      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
728      */
729     constructor(string memory name_, string memory symbol_) {
730         _name = name_;
731         _symbol = symbol_;
732     }
733 
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
738         return
739             interfaceId == type(IERC721).interfaceId ||
740             interfaceId == type(IERC721Metadata).interfaceId ||
741             super.supportsInterface(interfaceId);
742     }
743 
744     /**
745      * @dev See {IERC721-balanceOf}.
746      */
747     function balanceOf(address owner) public view virtual override returns (uint256) {
748         require(owner != address(0), "ERC721: balance query for the zero address");
749         return _balances[owner];
750     }
751 
752     /**
753      * @dev See {IERC721-ownerOf}.
754      */
755     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
756         address owner = _owners[tokenId];
757         require(owner != address(0), "ERC721: owner query for nonexistent token");
758         return owner;
759     }
760 
761     /**
762      * @dev See {IERC721Metadata-name}.
763      */
764     function name() public view virtual override returns (string memory) {
765         return _name;
766     }
767 
768     /**
769      * @dev See {IERC721Metadata-symbol}.
770      */
771     function symbol() public view virtual override returns (string memory) {
772         return _symbol;
773     }
774 
775     /**
776      * @dev See {IERC721Metadata-tokenURI}.
777      */
778     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
779         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
780 
781         string memory baseURI = _baseURI();
782         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
783     }
784 
785     /**
786      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
787      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
788      * by default, can be overriden in child contracts.
789      */
790     function _baseURI() internal view virtual returns (string memory) {
791         return "";
792     }
793 
794     /**
795      * @dev See {IERC721-approve}.
796      */
797     function approve(address to, uint256 tokenId) public virtual override {
798         address owner = ERC721.ownerOf(tokenId);
799         require(to != owner, "ERC721: approval to current owner");
800 
801         require(
802             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
803             "ERC721: approve caller is not owner nor approved for all"
804         );
805 
806         _approve(to, tokenId);
807     }
808 
809     /**
810      * @dev See {IERC721-getApproved}.
811      */
812     function getApproved(uint256 tokenId) public view virtual override returns (address) {
813         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
814 
815         return _tokenApprovals[tokenId];
816     }
817 
818     /**
819      * @dev See {IERC721-setApprovalForAll}.
820      */
821     function setApprovalForAll(address operator, bool approved) public virtual override {
822         require(operator != _msgSender(), "ERC721: approve to caller");
823 
824         _operatorApprovals[_msgSender()][operator] = approved;
825         emit ApprovalForAll(_msgSender(), operator, approved);
826     }
827 
828     /**
829      * @dev See {IERC721-isApprovedForAll}.
830      */
831     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
832         return _operatorApprovals[owner][operator];
833     }
834 
835     /**
836      * @dev See {IERC721-transferFrom}.
837      */
838     function transferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) public virtual override {
843         //solhint-disable-next-line max-line-length
844         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
845 
846         _transfer(from, to, tokenId);
847     }
848 
849     /**
850      * @dev See {IERC721-safeTransferFrom}.
851      */
852     function safeTransferFrom(
853         address from,
854         address to,
855         uint256 tokenId
856     ) public virtual override {
857         safeTransferFrom(from, to, tokenId, "");
858     }
859 
860     /**
861      * @dev See {IERC721-safeTransferFrom}.
862      */
863     function safeTransferFrom(
864         address from,
865         address to,
866         uint256 tokenId,
867         bytes memory _data
868     ) public virtual override {
869         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
870         _safeTransfer(from, to, tokenId, _data);
871     }
872 
873     /**
874      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
875      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
876      *
877      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
878      *
879      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
880      * implement alternative mechanisms to perform token transfer, such as signature-based.
881      *
882      * Requirements:
883      *
884      * - `from` cannot be the zero address.
885      * - `to` cannot be the zero address.
886      * - `tokenId` token must exist and be owned by `from`.
887      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _safeTransfer(
892         address from,
893         address to,
894         uint256 tokenId,
895         bytes memory _data
896     ) internal virtual {
897         _transfer(from, to, tokenId);
898         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
899     }
900 
901     /**
902      * @dev Returns whether `tokenId` exists.
903      *
904      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
905      *
906      * Tokens start existing when they are minted (`_mint`),
907      * and stop existing when they are burned (`_burn`).
908      */
909     function _exists(uint256 tokenId) internal view virtual returns (bool) {
910         return _owners[tokenId] != address(0);
911     }
912 
913     /**
914      * @dev Returns whether `spender` is allowed to manage `tokenId`.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must exist.
919      */
920     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
921         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
922         address owner = ERC721.ownerOf(tokenId);
923         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
924     }
925 
926     /**
927      * @dev Safely mints `tokenId` and transfers it to `to`.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must not exist.
932      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _safeMint(address to, uint256 tokenId) internal virtual {
937         _safeMint(to, tokenId, "");
938     }
939 
940     /**
941      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
942      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
943      */
944     function _safeMint(
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) internal virtual {
949         _mint(to, tokenId);
950         require(
951             _checkOnERC721Received(address(0), to, tokenId, _data),
952             "ERC721: transfer to non ERC721Receiver implementer"
953         );
954     }
955 
956     /**
957      * @dev Mints `tokenId` and transfers it to `to`.
958      *
959      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
960      *
961      * Requirements:
962      *
963      * - `tokenId` must not exist.
964      * - `to` cannot be the zero address.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _mint(address to, uint256 tokenId) internal virtual {
969         require(to != address(0), "ERC721: mint to the zero address");
970         require(!_exists(tokenId), "ERC721: token already minted");
971 
972         _beforeTokenTransfer(address(0), to, tokenId);
973 
974         _balances[to] += 1;
975         _owners[tokenId] = to;
976 
977         emit Transfer(address(0), to, tokenId);
978     }
979 
980     /**
981      * @dev Destroys `tokenId`.
982      * The approval is cleared when the token is burned.
983      *
984      * Requirements:
985      *
986      * - `tokenId` must exist.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _burn(uint256 tokenId) internal virtual {
991         address owner = ERC721.ownerOf(tokenId);
992 
993         _beforeTokenTransfer(owner, address(0), tokenId);
994 
995         // Clear approvals
996         _approve(address(0), tokenId);
997 
998         _balances[owner] -= 1;
999         delete _owners[tokenId];
1000 
1001         emit Transfer(owner, address(0), tokenId);
1002     }
1003 
1004     /**
1005      * @dev Transfers `tokenId` from `from` to `to`.
1006      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1007      *
1008      * Requirements:
1009      *
1010      * - `to` cannot be the zero address.
1011      * - `tokenId` token must be owned by `from`.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _transfer(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) internal virtual {
1020         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1021         require(to != address(0), "ERC721: transfer to the zero address");
1022 
1023         _beforeTokenTransfer(from, to, tokenId);
1024 
1025         // Clear approvals from the previous owner
1026         _approve(address(0), tokenId);
1027 
1028         _balances[from] -= 1;
1029         _balances[to] += 1;
1030         _owners[tokenId] = to;
1031 
1032         emit Transfer(from, to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev Approve `to` to operate on `tokenId`
1037      *
1038      * Emits a {Approval} event.
1039      */
1040     function _approve(address to, uint256 tokenId) internal virtual {
1041         _tokenApprovals[tokenId] = to;
1042         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1047      * The call is not executed if the target address is not a contract.
1048      *
1049      * @param from address representing the previous owner of the given token ID
1050      * @param to target address that will receive the tokens
1051      * @param tokenId uint256 ID of the token to be transferred
1052      * @param _data bytes optional data to send along with the call
1053      * @return bool whether the call correctly returned the expected magic value
1054      */
1055     function _checkOnERC721Received(
1056         address from,
1057         address to,
1058         uint256 tokenId,
1059         bytes memory _data
1060     ) private returns (bool) {
1061         if (to.isContract()) {
1062             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1063                 return retval == IERC721Receiver(to).onERC721Received.selector;
1064             } catch (bytes memory reason) {
1065                 if (reason.length == 0) {
1066                     revert("ERC721: transfer to non ERC721Receiver implementer");
1067                 } else {
1068                     assembly {
1069                         revert(add(32, reason), mload(reason))
1070                     }
1071                 }
1072             }
1073         } else {
1074             return true;
1075         }
1076     }
1077 
1078     /**
1079      * @dev Hook that is called before any token transfer. This includes minting
1080      * and burning.
1081      *
1082      * Calling conditions:
1083      *
1084      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1085      * transferred to `to`.
1086      * - When `from` is zero, `tokenId` will be minted for `to`.
1087      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1088      * - `from` and `to` are never both zero.
1089      *
1090      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1091      */
1092     function _beforeTokenTransfer(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) internal virtual {}
1097 }
1098 
1099 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1100 
1101 pragma solidity ^0.8.0;
1102 
1103 /**
1104  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1105  * enumerability of all the token ids in the contract as well as all token ids owned by each
1106  * account.
1107  */
1108 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1109     // Mapping from owner to list of owned token IDs
1110     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1111 
1112     // Mapping from token ID to index of the owner tokens list
1113     mapping(uint256 => uint256) private _ownedTokensIndex;
1114 
1115     // Array with all token ids, used for enumeration
1116     uint256[] private _allTokens;
1117 
1118     // Mapping from token id to position in the allTokens array
1119     mapping(uint256 => uint256) private _allTokensIndex;
1120 
1121     /**
1122      * @dev See {IERC165-supportsInterface}.
1123      */
1124     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1125         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1126     }
1127 
1128     /**
1129      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1130      */
1131     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1132         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1133         return _ownedTokens[owner][index];
1134     }
1135 
1136     /**
1137      * @dev See {IERC721Enumerable-totalSupply}.
1138      */
1139     function totalSupply() public view virtual override returns (uint256) {
1140         return _allTokens.length;
1141     }
1142 
1143     /**
1144      * @dev See {IERC721Enumerable-tokenByIndex}.
1145      */
1146     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1147         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1148         return _allTokens[index];
1149     }
1150 
1151     /**
1152      * @dev Hook that is called before any token transfer. This includes minting
1153      * and burning.
1154      *
1155      * Calling conditions:
1156      *
1157      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1158      * transferred to `to`.
1159      * - When `from` is zero, `tokenId` will be minted for `to`.
1160      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1161      * - `from` cannot be the zero address.
1162      * - `to` cannot be the zero address.
1163      *
1164      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1165      */
1166     function _beforeTokenTransfer(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) internal virtual override {
1171         super._beforeTokenTransfer(from, to, tokenId);
1172 
1173         if (from == address(0)) {
1174             _addTokenToAllTokensEnumeration(tokenId);
1175         } else if (from != to) {
1176             _removeTokenFromOwnerEnumeration(from, tokenId);
1177         }
1178         if (to == address(0)) {
1179             _removeTokenFromAllTokensEnumeration(tokenId);
1180         } else if (to != from) {
1181             _addTokenToOwnerEnumeration(to, tokenId);
1182         }
1183     }
1184 
1185     /**
1186      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1187      * @param to address representing the new owner of the given token ID
1188      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1189      */
1190     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1191         uint256 length = ERC721.balanceOf(to);
1192         _ownedTokens[to][length] = tokenId;
1193         _ownedTokensIndex[tokenId] = length;
1194     }
1195 
1196     /**
1197      * @dev Private function to add a token to this extension's token tracking data structures.
1198      * @param tokenId uint256 ID of the token to be added to the tokens list
1199      */
1200     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1201         _allTokensIndex[tokenId] = _allTokens.length;
1202         _allTokens.push(tokenId);
1203     }
1204 
1205     /**
1206      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1207      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1208      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1209      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1210      * @param from address representing the previous owner of the given token ID
1211      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1212      */
1213     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1214         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1215         // then delete the last slot (swap and pop).
1216 
1217         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1218         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1219 
1220         // When the token to delete is the last token, the swap operation is unnecessary
1221         if (tokenIndex != lastTokenIndex) {
1222             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1223 
1224             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1225             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1226         }
1227 
1228         // This also deletes the contents at the last position of the array
1229         delete _ownedTokensIndex[tokenId];
1230         delete _ownedTokens[from][lastTokenIndex];
1231     }
1232 
1233     /**
1234      * @dev Private function to remove a token from this extension's token tracking data structures.
1235      * This has O(1) time complexity, but alters the order of the _allTokens array.
1236      * @param tokenId uint256 ID of the token to be removed from the tokens list
1237      */
1238     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1239         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1240         // then delete the last slot (swap and pop).
1241 
1242         uint256 lastTokenIndex = _allTokens.length - 1;
1243         uint256 tokenIndex = _allTokensIndex[tokenId];
1244 
1245         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1246         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1247         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1248         uint256 lastTokenId = _allTokens[lastTokenIndex];
1249 
1250         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1251         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1252 
1253         // This also deletes the contents at the last position of the array
1254         delete _allTokensIndex[tokenId];
1255         _allTokens.pop();
1256     }
1257 }
1258 
1259 // File: contracts/Vegiemon.sol
1260 
1261 pragma solidity ^0.8.6;
1262 
1263 contract Vegiemon is ERC721Enumerable, Ownable {
1264     using Counters for Counters.Counter;
1265     Counters.Counter private _tokenIds;
1266     
1267     bool public isActive = false;
1268     uint256 public itemPrice;
1269     
1270     uint256 public _reserved = 50; // for giveAway
1271     string private baseURI;
1272 
1273     // withdraw addresses
1274     address t1 = 0xc40C2Db69DF9A7480d7d55E13c8DB55b63805DFd;
1275     address t2 = 0xeFcc0f7892bFe2F70011F422DA65AA431Fe0Be50;
1276     
1277     //vegiemon dont need a lots of complicated code ╮ (. ❛ ᴗ ❛.) ╭
1278     constructor () ERC721("Vegiemon", "VGM") 
1279     {
1280         baseURI = "https://needfreetime.me/vegiemon/tokens/";
1281         itemPrice = 50000000000000000; // 0.05 ETH
1282         giveAway( t1, 10); //community giveaway       
1283         giveAway( t2, 10);
1284     }
1285 
1286 	function getItemPrice() public view returns (uint256) 
1287 	{
1288 		return itemPrice;
1289 	}
1290 	
1291     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1292         uint256 tokenCount = balanceOf(_owner);
1293 
1294         uint256[] memory tokensId = new uint256[](tokenCount);
1295         for(uint256 i; i < tokenCount; i++){
1296             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1297         }
1298         return tokensId;
1299     }
1300     
1301     /*
1302     * Mint
1303     */
1304     function mint(address player, uint numberOfMints)
1305         public payable
1306     {
1307         require(isActive,                                                   "vegiemon sale hasn't started yet");
1308         require(_tokenIds.current() + numberOfMints <= 10000 - _reserved,   "Maximum amount already minted.");
1309         require(msg.value >= itemPrice * numberOfMints,                     "insufficient ETH");
1310         require(numberOfMints <= 20,                                        "You cant mint more than 20 at a time.");
1311         require(numberOfMints > 0,                                          "gas fee for nothing, vegiemon don't accept this request."); //(づ￣ ³￣)づ
1312         
1313         for(uint i = 0; i < numberOfMints; i++)
1314         {
1315             uint256 newItemId = _tokenIds.current();
1316             _safeMint(player, newItemId);
1317             _tokenIds.increment();
1318         }
1319     }
1320 
1321     function _baseURI() internal view override returns (string memory) 
1322     {
1323         return baseURI;
1324     }
1325 
1326     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) 
1327     {
1328         require(tokenId < _tokenIds.current(), "tokenId exceeds upper bound");
1329         string memory _tokenURI = super.tokenURI(tokenId);
1330         return _tokenURI;
1331     }
1332     
1333     /*Owner*/
1334     function setActive(bool val) public onlyOwner 
1335     {
1336         isActive = val;
1337     }
1338     
1339     function giveAway(address _to, uint256 _amount) public onlyOwner
1340     {
1341         require(_amount <= _reserved,   "exceeds reserved supply");
1342         require(_amount > 0,            "giveAway nothing.");
1343         
1344         for(uint256 i; i < _amount; i++)
1345         {
1346             uint256 newItemId = _tokenIds.current();
1347             _safeMint(_to, newItemId);
1348             _tokenIds.increment();
1349         }
1350 
1351         _reserved -= _amount;
1352     }
1353      
1354     function setBaseURI(string memory uri) public onlyOwner 
1355     {
1356         baseURI = uri;
1357     }
1358 
1359     //Just incase something bad happen ʕノ•ᴥ•ʔノ ︵ ┻━┻
1360     function setItemPrice(uint256 _price) public onlyOwner 
1361     {
1362 		itemPrice = _price;
1363 	}
1364     
1365     function cashOut() public onlyOwner 
1366     {
1367         uint256 _each = address(this).balance / 2;
1368         require(payable(t1).send(_each));
1369         require(payable(t2).send(_each));
1370     }
1371 }