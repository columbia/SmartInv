1 // File: @openzeppelin/contracts/utils/Counters.sol
2 /*
3 
4 
5                                                                                                                             ╭━━━━╮╱╱╱╱╱╭╮
6                                                                                                                             ┃╭╮╭╮┃╱╱╱╱╱┃┃
7                                                                                                                             ╰╯┃┃┣┫╱╭┳━━┫┃╭┳━━┳━━╮
8                                                                                                                             ╱╱┃┃┃┃╱┃┃━━┫╰╯┫╭╮┃━━┫
9                                                                                                                             ╱╱┃┃┃╰━╯┣━━┃╭╮┫╰╯┣━━┃
10                                                                                                                             ╱╱╰╯╰━╮╭┻━━┻╯╰┻━━┻━━╯
11                                                                                                                             ╱╱╱╱╭━╯┃
12                                                                                                                             ╱╱╱╱╰━━╯
13 
14 */
15 
16 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
17 
18 pragma solidity ^0.8.0;
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
57 }
58 
59 // File: @openzeppelin/contracts/utils/Strings.sol
60 
61 
62 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
63 
64 pragma solidity ^0.8.0;
65 
66 /**
67  * @dev String operations.
68  */
69 library Strings {
70     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
74      */
75     function toString(uint256 value) internal pure returns (string memory) {
76         // Inspired by OraclizeAPI's implementation - MIT licence
77         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
78 
79         if (value == 0) {
80             return "0";
81         }
82         uint256 temp = value;
83         uint256 digits;
84         while (temp != 0) {
85             digits++;
86             temp /= 10;
87         }
88         bytes memory buffer = new bytes(digits);
89         while (value != 0) {
90             digits -= 1;
91             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
92             value /= 10;
93         }
94         return string(buffer);
95     }
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
99      */
100     function toHexString(uint256 value) internal pure returns (string memory) {
101         if (value == 0) {
102             return "0x00";
103         }
104         uint256 temp = value;
105         uint256 length = 0;
106         while (temp != 0) {
107             length++;
108             temp >>= 8;
109         }
110         return toHexString(value, length);
111     }
112 
113     /**
114      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
115      */
116     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
117         bytes memory buffer = new bytes(2 * length + 2);
118         buffer[0] = "0";
119         buffer[1] = "x";
120         for (uint256 i = 2 * length + 1; i > 1; --i) {
121             buffer[i] = _HEX_SYMBOLS[value & 0xf];
122             value >>= 4;
123         }
124         require(value == 0, "Strings: hex length insufficient");
125         return string(buffer);
126     }
127 }
128 
129 // File: @openzeppelin/contracts/utils/Context.sol
130 
131 
132 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
133 
134 pragma solidity ^0.8.0;
135 
136 /**
137  * @dev Provides information about the current execution context, including the
138  * sender of the transaction and its data. While these are generally available
139  * via msg.sender and msg.data, they should not be accessed in such a direct
140  * manner, since when dealing with meta-transactions the account sending and
141  * paying for execution may not be the actual sender (as far as an application
142  * is concerned).
143  *
144  * This contract is only required for intermediate, library-like contracts.
145  */
146 abstract contract Context {
147     function _msgSender() internal view virtual returns (address) {
148         return msg.sender;
149     }
150 
151     function _msgData() internal view virtual returns (bytes calldata) {
152         return msg.data;
153     }
154 }
155 
156 // File: @openzeppelin/contracts/access/Ownable.sol
157 
158 
159 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 
164 /**
165  * @dev Contract module which provides a basic access control mechanism, where
166  * there is an account (an owner) that can be granted exclusive access to
167  * specific functions.
168  *
169  * By default, the owner account will be the one that deploys the contract. This
170  * can later be changed with {transferOwnership}.
171  *
172  * This module is used through inheritance. It will make available the modifier
173  * `onlyOwner`, which can be applied to your functions to restrict their use to
174  * the owner.
175  */
176 abstract contract Ownable is Context {
177     address private _owner;
178 
179     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
180 
181     /**
182      * @dev Initializes the contract setting the deployer as the initial owner.
183      */
184     constructor() {
185         _transferOwnership(_msgSender());
186     }
187 
188     /**
189      * @dev Returns the address of the current owner.
190      */
191     function owner() public view virtual returns (address) {
192         return _owner;
193     }
194 
195     /**
196      * @dev Throws if called by any account other than the owner.
197      */
198     modifier onlyOwner() {
199         require(owner() == _msgSender(), "Ownable: caller is not the owner");
200         _;
201     }
202 
203     /**
204      * @dev Leaves the contract without owner. It will not be possible to call
205      * `onlyOwner` functions anymore. Can only be called by the current owner.
206      *
207      * NOTE: Renouncing ownership will leave the contract without an owner,
208      * thereby removing any functionality that is only available to the owner.
209      */
210     function renounceOwnership() public virtual onlyOwner {
211         _transferOwnership(address(0));
212     }
213 
214     /**
215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
216      * Can only be called by the current owner.
217      */
218     function transferOwnership(address newOwner) public virtual onlyOwner {
219         require(newOwner != address(0), "Ownable: new owner is the zero address");
220         _transferOwnership(newOwner);
221     }
222 
223     /**
224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
225      * Internal function without access restriction.
226      */
227     function _transferOwnership(address newOwner) internal virtual {
228         address oldOwner = _owner;
229         _owner = newOwner;
230         emit OwnershipTransferred(oldOwner, newOwner);
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/Address.sol
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // This method relies on extcodesize, which returns 0 for contracts in
264         // construction, since the code is only stored at the end of the
265         // constructor execution.
266 
267         uint256 size;
268         assembly {
269             size := extcodesize(account)
270         }
271         return size > 0;
272     }
273 
274     /**
275      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276      * `recipient`, forwarding all available gas and reverting on errors.
277      *
278      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279      * of certain opcodes, possibly making contracts go over the 2300 gas limit
280      * imposed by `transfer`, making them unable to receive funds via
281      * `transfer`. {sendValue} removes this limitation.
282      *
283      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284      *
285      * IMPORTANT: because control is transferred to `recipient`, care must be
286      * taken to not create reentrancy vulnerabilities. Consider using
287      * {ReentrancyGuard} or the
288      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289      */
290     function sendValue(address payable recipient, uint256 amount) internal {
291         require(address(this).balance >= amount, "Address: insufficient balance");
292 
293         (bool success, ) = recipient.call{value: amount}("");
294         require(success, "Address: unable to send value, recipient may have reverted");
295     }
296 
297     /**
298      * @dev Performs a Solidity function call using a low level `call`. A
299      * plain `call` is an unsafe replacement for a function call: use this
300      * function instead.
301      *
302      * If `target` reverts with a revert reason, it is bubbled up by this
303      * function (like regular Solidity function calls).
304      *
305      * Returns the raw returned data. To convert to the expected return value,
306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307      *
308      * Requirements:
309      *
310      * - `target` must be a contract.
311      * - calling `target` with `data` must not revert.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
316         return functionCall(target, data, "Address: low-level call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
321      * `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(
326         address target,
327         bytes memory data,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(
345         address target,
346         bytes memory data,
347         uint256 value
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(
359         address target,
360         bytes memory data,
361         uint256 value,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         require(isContract(target), "Address: call to non-contract");
366 
367         (bool success, bytes memory returndata) = target.call{value: value}(data);
368         return verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but performing a static call.
374      *
375      * _Available since v3.3._
376      */
377     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
378         return functionStaticCall(target, data, "Address: low-level static call failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(
388         address target,
389         bytes memory data,
390         string memory errorMessage
391     ) internal view returns (bytes memory) {
392         require(isContract(target), "Address: static call to non-contract");
393 
394         (bool success, bytes memory returndata) = target.staticcall(data);
395         return verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but performing a delegate call.
401      *
402      * _Available since v3.4._
403      */
404     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
405         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
410      * but performing a delegate call.
411      *
412      * _Available since v3.4._
413      */
414     function functionDelegateCall(
415         address target,
416         bytes memory data,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         require(isContract(target), "Address: delegate call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.delegatecall(data);
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
427      * revert reason using the provided one.
428      *
429      * _Available since v4.3._
430      */
431     function verifyCallResult(
432         bool success,
433         bytes memory returndata,
434         string memory errorMessage
435     ) internal pure returns (bytes memory) {
436         if (success) {
437             return returndata;
438         } else {
439             // Look for revert reason and bubble it up if present
440             if (returndata.length > 0) {
441                 // The easiest way to bubble the revert reason is using memory via assembly
442 
443                 assembly {
444                     let returndata_size := mload(returndata)
445                     revert(add(32, returndata), returndata_size)
446                 }
447             } else {
448                 revert(errorMessage);
449             }
450         }
451     }
452 }
453 
454 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 /**
462  * @title ERC721 token receiver interface
463  * @dev Interface for any contract that wants to support safeTransfers
464  * from ERC721 asset contracts.
465  */
466 interface IERC721Receiver {
467     /**
468      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
469      * by `operator` from `from`, this function is called.
470      *
471      * It must return its Solidity selector to confirm the token transfer.
472      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
473      *
474      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
475      */
476     function onERC721Received(
477         address operator,
478         address from,
479         uint256 tokenId,
480         bytes calldata data
481     ) external returns (bytes4);
482 }
483 
484 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @dev Interface of the ERC165 standard, as defined in the
493  * https://eips.ethereum.org/EIPS/eip-165[EIP].
494  *
495  * Implementers can declare support of contract interfaces, which can then be
496  * queried by others ({ERC165Checker}).
497  *
498  * For an implementation, see {ERC165}.
499  */
500 interface IERC165 {
501     /**
502      * @dev Returns true if this contract implements the interface defined by
503      * `interfaceId`. See the corresponding
504      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
505      * to learn more about how these ids are created.
506      *
507      * This function call must use less than 30 000 gas.
508      */
509     function supportsInterface(bytes4 interfaceId) external view returns (bool);
510 }
511 
512 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
513 
514 
515 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
516 
517 pragma solidity ^0.8.0;
518 
519 
520 /**
521  * @dev Implementation of the {IERC165} interface.
522  *
523  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
524  * for the additional interface id that will be supported. For example:
525  *
526  * ```solidity
527  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
529  * }
530  * ```
531  *
532  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
533  */
534 abstract contract ERC165 is IERC165 {
535     /**
536      * @dev See {IERC165-supportsInterface}.
537      */
538     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539         return interfaceId == type(IERC165).interfaceId;
540     }
541 }
542 
543 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
544 
545 
546 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @dev Required interface of an ERC721 compliant contract.
553  */
554 interface IERC721 is IERC165 {
555     /**
556      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
557      */
558     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
559 
560     /**
561      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
562      */
563     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
564 
565     /**
566      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
567      */
568     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
569 
570     /**
571      * @dev Returns the number of tokens in ``owner``'s account.
572      */
573     function balanceOf(address owner) external view returns (uint256 balance);
574 
575     /**
576      * @dev Returns the owner of the `tokenId` token.
577      *
578      * Requirements:
579      *
580      * - `tokenId` must exist.
581      */
582     function ownerOf(uint256 tokenId) external view returns (address owner);
583 
584     /**
585      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
586      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must exist and be owned by `from`.
593      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
594      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
595      *
596      * Emits a {Transfer} event.
597      */
598     function safeTransferFrom(
599         address from,
600         address to,
601         uint256 tokenId
602     ) external;
603 
604     /**
605      * @dev Transfers `tokenId` token from `from` to `to`.
606      *
607      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
608      *
609      * Requirements:
610      *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613      * - `tokenId` token must be owned by `from`.
614      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
615      *
616      * Emits a {Transfer} event.
617      */
618     function transferFrom(
619         address from,
620         address to,
621         uint256 tokenId
622     ) external;
623 
624     /**
625      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
626      * The approval is cleared when the token is transferred.
627      *
628      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
629      *
630      * Requirements:
631      *
632      * - The caller must own the token or be an approved operator.
633      * - `tokenId` must exist.
634      *
635      * Emits an {Approval} event.
636      */
637     function approve(address to, uint256 tokenId) external;
638 
639     /**
640      * @dev Returns the account approved for `tokenId` token.
641      *
642      * Requirements:
643      *
644      * - `tokenId` must exist.
645      */
646     function getApproved(uint256 tokenId) external view returns (address operator);
647 
648     /**
649      * @dev Approve or remove `operator` as an operator for the caller.
650      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
651      *
652      * Requirements:
653      *
654      * - The `operator` cannot be the caller.
655      *
656      * Emits an {ApprovalForAll} event.
657      */
658     function setApprovalForAll(address operator, bool _approved) external;
659 
660     /**
661      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
662      *
663      * See {setApprovalForAll}
664      */
665     function isApprovedForAll(address owner, address operator) external view returns (bool);
666 
667     /**
668      * @dev Safely transfers `tokenId` token from `from` to `to`.
669      *
670      * Requirements:
671      *
672      * - `from` cannot be the zero address.
673      * - `to` cannot be the zero address.
674      * - `tokenId` token must exist and be owned by `from`.
675      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
676      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
677      *
678      * Emits a {Transfer} event.
679      */
680     function safeTransferFrom(
681         address from,
682         address to,
683         uint256 tokenId,
684         bytes calldata data
685     ) external;
686 }
687 
688 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
689 
690 
691 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
692 
693 pragma solidity ^0.8.0;
694 
695 
696 /**
697  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
698  * @dev See https://eips.ethereum.org/EIPS/eip-721
699  */
700 interface IERC721Metadata is IERC721 {
701     /**
702      * @dev Returns the token collection name.
703      */
704     function name() external view returns (string memory);
705 
706     /**
707      * @dev Returns the token collection symbol.
708      */
709     function symbol() external view returns (string memory);
710 
711     /**
712      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
713      */
714     function tokenURI(uint256 tokenId) external view returns (string memory);
715 }
716 
717 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
718 
719 
720 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 
725 
726 
727 
728 
729 
730 
731 /**
732  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
733  * the Metadata extension, but not including the Enumerable extension, which is available separately as
734  * {ERC721Enumerable}.
735  */
736 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
737     using Address for address;
738     using Strings for uint256;
739 
740     // Token name
741     string private _name;
742 
743     // Token symbol
744     string private _symbol;
745 
746     // Mapping from token ID to owner address
747     mapping(uint256 => address) private _owners;
748 
749     // Mapping owner address to token count
750     mapping(address => uint256) private _balances;
751 
752     // Mapping from token ID to approved address
753     mapping(uint256 => address) private _tokenApprovals;
754 
755     // Mapping from owner to operator approvals
756     mapping(address => mapping(address => bool)) private _operatorApprovals;
757 
758     /**
759      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
760      */
761     constructor(string memory name_, string memory symbol_) {
762         _name = name_;
763         _symbol = symbol_;
764     }
765 
766     /**
767      * @dev See {IERC165-supportsInterface}.
768      */
769     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
770         return
771             interfaceId == type(IERC721).interfaceId ||
772             interfaceId == type(IERC721Metadata).interfaceId ||
773             super.supportsInterface(interfaceId);
774     }
775 
776     /**
777      * @dev See {IERC721-balanceOf}.
778      */
779     function balanceOf(address owner) public view virtual override returns (uint256) {
780         require(owner != address(0), "ERC721: balance query for the zero address");
781         return _balances[owner];
782     }
783 
784     /**
785      * @dev See {IERC721-ownerOf}.
786      */
787     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
788         address owner = _owners[tokenId];
789         require(owner != address(0), "ERC721: owner query for nonexistent token");
790         return owner;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-name}.
795      */
796     function name() public view virtual override returns (string memory) {
797         return _name;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-symbol}.
802      */
803     function symbol() public view virtual override returns (string memory) {
804         return _symbol;
805     }
806 
807     /**
808      * @dev See {IERC721Metadata-tokenURI}.
809      */
810     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
811         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
812 
813         string memory baseURI = _baseURI();
814         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
815     }
816 
817     /**
818      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
819      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
820      * by default, can be overriden in child contracts.
821      */
822     function _baseURI() internal view virtual returns (string memory) {
823         return "";
824     }
825 
826     /**
827      * @dev See {IERC721-approve}.
828      */
829     function approve(address to, uint256 tokenId) public virtual override {
830         address owner = ERC721.ownerOf(tokenId);
831         require(to != owner, "ERC721: approval to current owner");
832 
833         require(
834             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
835             "ERC721: approve caller is not owner nor approved for all"
836         );
837 
838         _approve(to, tokenId);
839     }
840 
841     /**
842      * @dev See {IERC721-getApproved}.
843      */
844     function getApproved(uint256 tokenId) public view virtual override returns (address) {
845         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
846 
847         return _tokenApprovals[tokenId];
848     }
849 
850     /**
851      * @dev See {IERC721-setApprovalForAll}.
852      */
853     function setApprovalForAll(address operator, bool approved) public virtual override {
854         _setApprovalForAll(_msgSender(), operator, approved);
855     }
856 
857     /**
858      * @dev See {IERC721-isApprovedForAll}.
859      */
860     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
861         return _operatorApprovals[owner][operator];
862     }
863 
864     /**
865      * @dev See {IERC721-transferFrom}.
866      */
867     function transferFrom(
868         address from,
869         address to,
870         uint256 tokenId
871     ) public virtual override {
872         //solhint-disable-next-line max-line-length
873         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
874 
875         _transfer(from, to, tokenId);
876     }
877 
878     /**
879      * @dev See {IERC721-safeTransferFrom}.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) public virtual override {
886         safeTransferFrom(from, to, tokenId, "");
887     }
888 
889     /**
890      * @dev See {IERC721-safeTransferFrom}.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId,
896         bytes memory _data
897     ) public virtual override {
898         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
899         _safeTransfer(from, to, tokenId, _data);
900     }
901 
902     /**
903      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
904      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
905      *
906      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
907      *
908      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
909      * implement alternative mechanisms to perform token transfer, such as signature-based.
910      *
911      * Requirements:
912      *
913      * - `from` cannot be the zero address.
914      * - `to` cannot be the zero address.
915      * - `tokenId` token must exist and be owned by `from`.
916      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _safeTransfer(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes memory _data
925     ) internal virtual {
926         _transfer(from, to, tokenId);
927         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
928     }
929 
930     /**
931      * @dev Returns whether `tokenId` exists.
932      *
933      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
934      *
935      * Tokens start existing when they are minted (`_mint`),
936      * and stop existing when they are burned (`_burn`).
937      */
938     function _exists(uint256 tokenId) internal view virtual returns (bool) {
939         return _owners[tokenId] != address(0);
940     }
941 
942     /**
943      * @dev Returns whether `spender` is allowed to manage `tokenId`.
944      *
945      * Requirements:
946      *
947      * - `tokenId` must exist.
948      */
949     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
950         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
951         address owner = ERC721.ownerOf(tokenId);
952         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
953     }
954 
955     /**
956      * @dev Safely mints `tokenId` and transfers it to `to`.
957      *
958      * Requirements:
959      *
960      * - `tokenId` must not exist.
961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _safeMint(address to, uint256 tokenId) internal virtual {
966         _safeMint(to, tokenId, "");
967     }
968 
969     /**
970      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
971      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
972      */
973     function _safeMint(
974         address to,
975         uint256 tokenId,
976         bytes memory _data
977     ) internal virtual {
978         _mint(to, tokenId);
979         require(
980             _checkOnERC721Received(address(0), to, tokenId, _data),
981             "ERC721: transfer to non ERC721Receiver implementer"
982         );
983     }
984 
985     /**
986      * @dev Mints `tokenId` and transfers it to `to`.
987      *
988      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
989      *
990      * Requirements:
991      *
992      * - `tokenId` must not exist.
993      * - `to` cannot be the zero address.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _mint(address to, uint256 tokenId) internal virtual {
998         require(to != address(0), "ERC721: mint to the zero address");
999         require(!_exists(tokenId), "ERC721: token already minted");
1000 
1001         _beforeTokenTransfer(address(0), to, tokenId);
1002 
1003         _balances[to] += 1;
1004         _owners[tokenId] = to;
1005 
1006         emit Transfer(address(0), to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev Destroys `tokenId`.
1011      * The approval is cleared when the token is burned.
1012      *
1013      * Requirements:
1014      *
1015      * - `tokenId` must exist.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _burn(uint256 tokenId) internal virtual {
1020         address owner = ERC721.ownerOf(tokenId);
1021 
1022         _beforeTokenTransfer(owner, address(0), tokenId);
1023 
1024         // Clear approvals
1025         _approve(address(0), tokenId);
1026 
1027         _balances[owner] -= 1;
1028         delete _owners[tokenId];
1029 
1030         emit Transfer(owner, address(0), tokenId);
1031     }
1032 
1033     /**
1034      * @dev Transfers `tokenId` from `from` to `to`.
1035      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1036      *
1037      * Requirements:
1038      *
1039      * - `to` cannot be the zero address.
1040      * - `tokenId` token must be owned by `from`.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function _transfer(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) internal virtual {
1049         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1050         require(to != address(0), "ERC721: transfer to the zero address");
1051 
1052         _beforeTokenTransfer(from, to, tokenId);
1053 
1054         // Clear approvals from the previous owner
1055         _approve(address(0), tokenId);
1056 
1057         _balances[from] -= 1;
1058         _balances[to] += 1;
1059         _owners[tokenId] = to;
1060 
1061         emit Transfer(from, to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev Approve `to` to operate on `tokenId`
1066      *
1067      * Emits a {Approval} event.
1068      */
1069     function _approve(address to, uint256 tokenId) internal virtual {
1070         _tokenApprovals[tokenId] = to;
1071         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1072     }
1073 
1074     /**
1075      * @dev Approve `operator` to operate on all of `owner` tokens
1076      *
1077      * Emits a {ApprovalForAll} event.
1078      */
1079     function _setApprovalForAll(
1080         address owner,
1081         address operator,
1082         bool approved
1083     ) internal virtual {
1084         require(owner != operator, "ERC721: approve to caller");
1085         _operatorApprovals[owner][operator] = approved;
1086         emit ApprovalForAll(owner, operator, approved);
1087     }
1088 
1089     /**
1090      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1091      * The call is not executed if the target address is not a contract.
1092      *
1093      * @param from address representing the previous owner of the given token ID
1094      * @param to target address that will receive the tokens
1095      * @param tokenId uint256 ID of the token to be transferred
1096      * @param _data bytes optional data to send along with the call
1097      * @return bool whether the call correctly returned the expected magic value
1098      */
1099     function _checkOnERC721Received(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) private returns (bool) {
1105         if (to.isContract()) {
1106             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1107                 return retval == IERC721Receiver.onERC721Received.selector;
1108             } catch (bytes memory reason) {
1109                 if (reason.length == 0) {
1110                     revert("ERC721: transfer to non ERC721Receiver implementer");
1111                 } else {
1112                     assembly {
1113                         revert(add(32, reason), mload(reason))
1114                     }
1115                 }
1116             }
1117         } else {
1118             return true;
1119         }
1120     }
1121 
1122     /**
1123      * @dev Hook that is called before any token transfer. This includes minting
1124      * and burning.
1125      *
1126      * Calling conditions:
1127      *
1128      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1129      * transferred to `to`.
1130      * - When `from` is zero, `tokenId` will be minted for `to`.
1131      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1132      * - `from` and `to` are never both zero.
1133      *
1134      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1135      */
1136     function _beforeTokenTransfer(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) internal virtual {}
1141 }
1142 
1143 // File: contracts/Tyskos.sol
1144 
1145 
1146 /*
1147 
1148 
1149                                                                                                                             ╭━━━━╮╱╱╱╱╱╭╮
1150                                                                                                                             ┃╭╮╭╮┃╱╱╱╱╱┃┃
1151                                                                                                                             ╰╯┃┃┣┫╱╭┳━━┫┃╭┳━━┳━━╮
1152                                                                                                                             ╱╱┃┃┃┃╱┃┃━━┫╰╯┫╭╮┃━━┫
1153                                                                                                                             ╱╱┃┃┃╰━╯┣━━┃╭╮┫╰╯┣━━┃
1154                                                                                                                             ╱╱╰╯╰━╮╭┻━━┻╯╰┻━━┻━━╯
1155                                                                                                                             ╱╱╱╱╭━╯┃
1156                                                                                                                             ╱╱╱╱╰━━╯
1157 
1158 */
1159 
1160 pragma solidity >=0.7.0 <0.9.0;
1161 
1162 
1163 
1164 
1165 contract Tyskos is ERC721, Ownable {
1166   using Strings for uint256;
1167   using Counters for Counters.Counter;
1168 
1169   Counters.Counter private supply;
1170 
1171   string public uriPrefix = "https://uetar.mypinata.cloud/ipfs/QmQ5z34vwupyrE5r5vW6EVwZ2CxrPSkfniKKZyWUSWGpHU/";
1172   string public uriSuffix = ".json";
1173   string public hiddenMetadataUri;
1174   
1175   uint256 public publicMintCost = 0.055 ether;
1176   uint256 public preMintCost = 0.045 ether;
1177   uint256 public maxSupply = 1777;
1178   uint256 public maxMintAmountPerTx = 100;
1179 
1180   //bool public paused = false;
1181   bool public preMintPaused = true;
1182   bool public publicMintPaused = true;
1183   bool public revealed = false;
1184 
1185   uint256 preMintLimit = 3;
1186   uint256 publicMintLimit = 10;
1187   mapping(address => uint256) public preMintCount;
1188   mapping(address => uint256) public publicMintCount;
1189 
1190   mapping(address => bool) public whitelisted;
1191 
1192   constructor() ERC721("Tyskos", "Tyskos") {
1193     setHiddenMetadataUri("https://uetar.mypinata.cloud/ipfs/QmWaAyjjSP2UKHARbUQWakpCQQ9a7dszwhWfZPfCWmHWZu");
1194     mintForAddress(100, owner());
1195   }
1196 
1197   modifier mintCompliance(uint256 _mintAmount) {
1198     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1199     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1200     _;
1201   }
1202 
1203   
1204   function totalSupply() public view returns (uint256) {
1205     return supply.current();
1206   }
1207 
1208   function publicMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1209     require(!publicMintPaused, "Public mint is paused!");
1210     require(msg.value >= publicMintCost * _mintAmount, "Insufficient funds!");
1211     require(publicMintCount[msg.sender] + _mintAmount <= publicMintLimit, "public mint limit exceeded");
1212 
1213     _mintLoop(msg.sender, _mintAmount);
1214     publicMintCount[msg.sender] += _mintAmount;
1215   }
1216 
1217   function whitelistMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount){
1218     require(!preMintPaused, "Premint paused is paused!");
1219     require(msg.value >= preMintCost * _mintAmount, "Insufficient funds!");
1220     require(whitelisted[msg.sender], "sender is not in whitelist");
1221     require(preMintCount[msg.sender] + _mintAmount <= preMintLimit, "premint limit exceeded");
1222 
1223     _mintLoop(msg.sender, _mintAmount);
1224     preMintCount[msg.sender] += _mintAmount;
1225   }
1226   
1227   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1228     _mintLoop(_receiver, _mintAmount);
1229   }
1230 
1231   function getPreMintCount() public view returns (uint256){
1232     return preMintCount[msg.sender];
1233   }
1234 
1235   function getPublicMintCount() public view returns (uint256){
1236     return publicMintCount[msg.sender];
1237   }
1238 
1239   function walletOfOwner(address _owner)
1240     public
1241     view
1242     returns (uint256[] memory)
1243   {
1244     uint256 ownerTokenCount = balanceOf(_owner);
1245     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1246     uint256 currentTokenId = 1;
1247     uint256 ownedTokenIndex = 0;
1248 
1249     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1250       address currentTokenOwner = ownerOf(currentTokenId);
1251 
1252       if (currentTokenOwner == _owner) {
1253         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1254 
1255         ownedTokenIndex++;
1256       }
1257 
1258       currentTokenId++;
1259     }
1260 
1261     return ownedTokenIds;
1262   }
1263 
1264   function tokenURI(uint256 _tokenId)
1265     public
1266     view
1267     virtual
1268     override
1269     returns (string memory)
1270   {
1271     require(
1272       _exists(_tokenId),
1273       "ERC721Metadata: URI query for nonexistent token"
1274     );
1275 
1276     if (revealed == false) {
1277       return hiddenMetadataUri;
1278     }
1279 
1280     string memory currentBaseURI = _baseURI();
1281     return bytes(currentBaseURI).length > 0
1282         ? string(abi.encodePacked(currentBaseURI, (_tokenId-1).toString(), uriSuffix))
1283         : "";
1284   }
1285 
1286   function setpreMintPaused(bool _state) public onlyOwner {
1287     preMintPaused = _state;
1288   }
1289 
1290   function setPublicMintPaused(bool _state) public onlyOwner {
1291     publicMintPaused = _state;
1292   }
1293 
1294   function setRevealed(bool _state) public onlyOwner {
1295     revealed = _state;
1296   }
1297 
1298   function setPublicCost(uint256 _cost) public onlyOwner {
1299     publicMintCost = _cost;
1300   }
1301 
1302   function setPreCost(uint256 _cost) public onlyOwner {
1303     preMintCost = _cost;
1304   }
1305 
1306   function whitelistUser(address _user) external onlyOwner {
1307     whitelisted[_user] = true;
1308   }
1309  
1310   function removeWhitelistUser(address _user) external onlyOwner {
1311     whitelisted[_user] = false;
1312   }
1313 
1314   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1315     maxMintAmountPerTx = _maxMintAmountPerTx;
1316   }
1317 
1318   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1319     hiddenMetadataUri = _hiddenMetadataUri;
1320   }
1321 
1322   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1323     uriPrefix = _uriPrefix;
1324   }
1325 
1326   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1327     uriSuffix = _uriSuffix;
1328   }
1329 
1330 
1331   function withdraw() public onlyOwner {
1332 
1333 
1334     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1335     require(os);
1336   }
1337 
1338   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1339     for (uint256 i = 0; i < _mintAmount; i++) {
1340       supply.increment();
1341       _safeMint(_receiver, supply.current());
1342     }
1343   }
1344 
1345   function _baseURI() internal view virtual override returns (string memory) {
1346     return uriPrefix;
1347   }
1348 }