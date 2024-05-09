1 /*
2 + + + - - - - - - - - - - - - - - - - - - - - - - - - - - - ++ - - - - - - - - - - - - - - - - - - - - - - - - - - + + +
3 +                                                                                                                      +
4 +                                                                                                                      +
5 .                                                                                                                      .
6 .                                                                                                                      .
7 .                                                                                                                      .
8 .                                                                                                                      .
9 .                               ███╗░░░███╗██╗░░░██╗████████╗░█████╗░███╗░░██╗████████╗                                .
10 .                               ████╗░████║██║░░░██║╚══██╔══╝██╔══██╗████╗░██║╚══██╔══╝                                .
11 .                               ██╔████╔██║██║░░░██║░░░██║░░░███████║██╔██╗██║░░░██║░░░                                .
12 .                               ██║╚██╔╝██║██║░░░██║░░░██║░░░██╔══██║██║╚████║░░░██║░░░                                .
13 .                               ██║░╚═╝░██║╚██████╔╝░░░██║░░░██║░░██║██║░╚███║░░░██║░░░                                .
14 .                               ╚═╝░░░░░╚═╝░╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚══╝░░░╚═╝░░░                                .
15 .                                                                                                                      .
16 .                               ██████╗░░█████╗░░█████╗░██████╗░██╗░░░░░███████╗░██████╗                               .
17 .                               ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║░░░░░██╔════╝██╔════╝                               .
18 .                               ██║░░██║██║░░██║██║░░██║██║░░██║██║░░░░░█████╗░░╚█████╗░                               .
19 .                               ██║░░██║██║░░██║██║░░██║██║░░██║██║░░░░░██╔══╝░░░╚═══██╗                               .
20 .                               ██████╔╝╚█████╔╝╚█████╔╝██████╔╝███████╗███████╗██████╔╝                               .
21 .                               ╚═════╝░░╚════╝░░╚════╝░╚═════╝░╚══════╝╚══════╝╚═════╝░                               .
22 .                                                                                                                      .
23 .                                                                                                                      .
24 .                                                                                                                      .
25 .                                                                                                                      .
26 +                                                                                                                      +
27 +                                                                                                                      +
28 + + + - - - - - - - - - - - - - - - - - - - - - - - - - - - ++ - - - - - - - - - - - - - - - - - - - - - - - - - - + + +
29 */
30 
31 // SPDX-License-Identifier: MIT
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @title Counters
37  * @author Matt Condon (@shrugs)
38  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
39  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
40  *
41  * Include with `using Counters for Counters.Counter;`
42  */
43 library Counters {
44     struct Counter {
45         // This variable should never be directly accessed by users of the library: interactions must be restricted to
46         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
47         // this feature: see https://github.com/ethereum/solidity/issues/4637
48         uint256 _value; // default: 0
49     }
50 
51     function current(Counter storage counter) internal view returns (uint256) {
52         return counter._value;
53     }
54 
55     function increment(Counter storage counter) internal {
56         unchecked {
57             counter._value += 1;
58         }
59     }
60 
61     function decrement(Counter storage counter) internal {
62         uint256 value = counter._value;
63         require(value > 0, "Counter: decrement overflow");
64         unchecked {
65             counter._value = value - 1;
66         }
67     }
68 
69     function reset(Counter storage counter) internal {
70         counter._value = 0;
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Strings.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev String operations.
83  */
84 library Strings {
85     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
89      */
90     function toString(uint256 value) internal pure returns (string memory) {
91         // Inspired by OraclizeAPI's implementation - MIT licence
92         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
93 
94         if (value == 0) {
95             return "0";
96         }
97         uint256 temp = value;
98         uint256 digits;
99         while (temp != 0) {
100             digits++;
101             temp /= 10;
102         }
103         bytes memory buffer = new bytes(digits);
104         while (value != 0) {
105             digits -= 1;
106             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
107             value /= 10;
108         }
109         return string(buffer);
110     }
111 
112     /**
113      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
114      */
115     function toHexString(uint256 value) internal pure returns (string memory) {
116         if (value == 0) {
117             return "0x00";
118         }
119         uint256 temp = value;
120         uint256 length = 0;
121         while (temp != 0) {
122             length++;
123             temp >>= 8;
124         }
125         return toHexString(value, length);
126     }
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
130      */
131     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
132         bytes memory buffer = new bytes(2 * length + 2);
133         buffer[0] = "0";
134         buffer[1] = "x";
135         for (uint256 i = 2 * length + 1; i > 1; --i) {
136             buffer[i] = _HEX_SYMBOLS[value & 0xf];
137             value >>= 4;
138         }
139         require(value == 0, "Strings: hex length insufficient");
140         return string(buffer);
141     }
142 }
143 
144 /**
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 abstract contract Context {
155     function _msgSender() internal view virtual returns (address) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view virtual returns (bytes calldata) {
160         return msg.data;
161     }
162 }
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
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies on extcodesize, which returns 0 for contracts in
257         // construction, since the code is only stored at the end of the
258         // constructor execution.
259 
260         uint256 size;
261         assembly {
262             size := extcodesize(account)
263         }
264         return size > 0;
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         (bool success, ) = recipient.call{value: amount}("");
287         require(success, "Address: unable to send value, recipient may have reverted");
288     }
289 
290     /**
291      * @dev Performs a Solidity function call using a low level `call`. A
292      * plain `call` is an unsafe replacement for a function call: use this
293      * function instead.
294      *
295      * If `target` reverts with a revert reason, it is bubbled up by this
296      * function (like regular Solidity function calls).
297      *
298      * Returns the raw returned data. To convert to the expected return value,
299      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300      *
301      * Requirements:
302      *
303      * - `target` must be a contract.
304      * - calling `target` with `data` must not revert.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionCall(target, data, "Address: low-level call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314      * `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(
319         address target,
320         bytes memory data,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, 0, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but also transferring `value` wei to `target`.
329      *
330      * Requirements:
331      *
332      * - the calling contract must have an ETH balance of at least `value`.
333      * - the called Solidity function must be `payable`.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.call{value: value}(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
371         return functionStaticCall(target, data, "Address: low-level static call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal view returns (bytes memory) {
385         require(isContract(target), "Address: static call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.staticcall(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a delegate call.
394      *
395      * _Available since v3.4._
396      */
397     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
398         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         require(isContract(target), "Address: delegate call to non-contract");
413 
414         (bool success, bytes memory returndata) = target.delegatecall(data);
415         return verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
420      * revert reason using the provided one.
421      *
422      * _Available since v4.3._
423      */
424     function verifyCallResult(
425         bool success,
426         bytes memory returndata,
427         string memory errorMessage
428     ) internal pure returns (bytes memory) {
429         if (success) {
430             return returndata;
431         } else {
432             // Look for revert reason and bubble it up if present
433             if (returndata.length > 0) {
434                 // The easiest way to bubble the revert reason is using memory via assembly
435 
436                 assembly {
437                     let returndata_size := mload(returndata)
438                     revert(add(32, returndata), returndata_size)
439                 }
440             } else {
441                 revert(errorMessage);
442             }
443         }
444     }
445 }
446 
447 /**
448  * @title ERC721 token receiver interface
449  * @dev Interface for any contract that wants to support safeTransfers
450  * from ERC721 asset contracts.
451  */
452 interface IERC721Receiver {
453     /**
454      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
455      * by `operator` from `from`, this function is called.
456      *
457      * It must return its Solidity selector to confirm the token transfer.
458      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
459      *
460      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
461      */
462     function onERC721Received(
463         address operator,
464         address from,
465         uint256 tokenId,
466         bytes calldata data
467     ) external returns (bytes4);
468 }
469 
470 /**
471  * @dev Interface of the ERC165 standard, as defined in the
472  * https://eips.ethereum.org/EIPS/eip-165[EIP].
473  *
474  * Implementers can declare support of contract interfaces, which can then be
475  * queried by others ({ERC165Checker}).
476  *
477  * For an implementation, see {ERC165}.
478  */
479 interface IERC165 {
480     /**
481      * @dev Returns true if this contract implements the interface defined by
482      * `interfaceId`. See the corresponding
483      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
484      * to learn more about how these ids are created.
485      *
486      * This function call must use less than 30 000 gas.
487      */
488     function supportsInterface(bytes4 interfaceId) external view returns (bool);
489 }
490 
491 /**
492  * @dev Implementation of the {IERC165} interface.
493  *
494  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
495  * for the additional interface id that will be supported. For example:
496  *
497  * ```solidity
498  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
499  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
500  * }
501  * ```
502  *
503  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
504  */
505 abstract contract ERC165 is IERC165 {
506     /**
507      * @dev See {IERC165-supportsInterface}.
508      */
509     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
510         return interfaceId == type(IERC165).interfaceId;
511     }
512 }
513 
514 /**
515  * @dev Required interface of an ERC721 compliant contract.
516  */
517 interface IERC721 is IERC165 {
518     /**
519      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
520      */
521     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
522 
523     /**
524      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
525      */
526     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
527 
528     /**
529      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
530      */
531     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
532 
533     /**
534      * @dev Returns the number of tokens in ``owner``'s account.
535      */
536     function balanceOf(address owner) external view returns (uint256 balance);
537 
538     /**
539      * @dev Returns the owner of the `tokenId` token.
540      *
541      * Requirements:
542      *
543      * - `tokenId` must exist.
544      */
545     function ownerOf(uint256 tokenId) external view returns (address owner);
546 
547     /**
548      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
549      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
550      *
551      * Requirements:
552      *
553      * - `from` cannot be the zero address.
554      * - `to` cannot be the zero address.
555      * - `tokenId` token must exist and be owned by `from`.
556      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
557      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
558      *
559      * Emits a {Transfer} event.
560      */
561     function safeTransferFrom(
562         address from,
563         address to,
564         uint256 tokenId
565     ) external;
566 
567     /**
568      * @dev Transfers `tokenId` token from `from` to `to`.
569      *
570      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
571      *
572      * Requirements:
573      *
574      * - `from` cannot be the zero address.
575      * - `to` cannot be the zero address.
576      * - `tokenId` token must be owned by `from`.
577      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
578      *
579      * Emits a {Transfer} event.
580      */
581     function transferFrom(
582         address from,
583         address to,
584         uint256 tokenId
585     ) external;
586 
587     /**
588      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
589      * The approval is cleared when the token is transferred.
590      *
591      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
592      *
593      * Requirements:
594      *
595      * - The caller must own the token or be an approved operator.
596      * - `tokenId` must exist.
597      *
598      * Emits an {Approval} event.
599      */
600     function approve(address to, uint256 tokenId) external;
601 
602     /**
603      * @dev Returns the account approved for `tokenId` token.
604      *
605      * Requirements:
606      *
607      * - `tokenId` must exist.
608      */
609     function getApproved(uint256 tokenId) external view returns (address operator);
610 
611     /**
612      * @dev Approve or remove `operator` as an operator for the caller.
613      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
614      *
615      * Requirements:
616      *
617      * - The `operator` cannot be the caller.
618      *
619      * Emits an {ApprovalForAll} event.
620      */
621     function setApprovalForAll(address operator, bool _approved) external;
622 
623     /**
624      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
625      *
626      * See {setApprovalForAll}
627      */
628     function isApprovedForAll(address owner, address operator) external view returns (bool);
629 
630     /**
631      * @dev Safely transfers `tokenId` token from `from` to `to`.
632      *
633      * Requirements:
634      *
635      * - `from` cannot be the zero address.
636      * - `to` cannot be the zero address.
637      * - `tokenId` token must exist and be owned by `from`.
638      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
639      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
640      *
641      * Emits a {Transfer} event.
642      */
643     function safeTransferFrom(
644         address from,
645         address to,
646         uint256 tokenId,
647         bytes calldata data
648     ) external;
649 }
650 
651 /**
652  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
653  * @dev See https://eips.ethereum.org/EIPS/eip-721
654  */
655 interface IERC721Metadata is IERC721 {
656     /**
657      * @dev Returns the token collection name.
658      */
659     function name() external view returns (string memory);
660 
661     /**
662      * @dev Returns the token collection symbol.
663      */
664     function symbol() external view returns (string memory);
665 
666     /**
667      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
668      */
669     function tokenURI(uint256 tokenId) external view returns (string memory);
670 }
671 
672 /**
673  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
674  * the Metadata extension, but not including the Enumerable extension, which is available separately as
675  * {ERC721Enumerable}.
676  */
677 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
678     using Address for address;
679     using Strings for uint256;
680 
681     // Token name
682     string private _name;
683 
684     // Token symbol
685     string private _symbol;
686 
687     // Mapping from token ID to owner address
688     mapping(uint256 => address) private _owners;
689 
690     // Mapping owner address to token count
691     mapping(address => uint256) private _balances;
692 
693     // Mapping from token ID to approved address
694     mapping(uint256 => address) private _tokenApprovals;
695 
696     // Mapping from owner to operator approvals
697     mapping(address => mapping(address => bool)) private _operatorApprovals;
698 
699     /**
700      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
701      */
702     constructor(string memory name_, string memory symbol_) {
703         _name = name_;
704         _symbol = symbol_;
705     }
706 
707     /**
708      * @dev See {IERC165-supportsInterface}.
709      */
710     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
711         return
712             interfaceId == type(IERC721).interfaceId ||
713             interfaceId == type(IERC721Metadata).interfaceId ||
714             super.supportsInterface(interfaceId);
715     }
716 
717     /**
718      * @dev See {IERC721-balanceOf}.
719      */
720     function balanceOf(address owner) public view virtual override returns (uint256) {
721         require(owner != address(0), "ERC721: balance query for the zero address");
722         return _balances[owner];
723     }
724 
725     /**
726      * @dev See {IERC721-ownerOf}.
727      */
728     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
729         address owner = _owners[tokenId];
730         require(owner != address(0), "ERC721: owner query for nonexistent token");
731         return owner;
732     }
733 
734     /**
735      * @dev See {IERC721Metadata-name}.
736      */
737     function name() public view virtual override returns (string memory) {
738         return _name;
739     }
740 
741     /**
742      * @dev See {IERC721Metadata-symbol}.
743      */
744     function symbol() public view virtual override returns (string memory) {
745         return _symbol;
746     }
747 
748     /**
749      * @dev See {IERC721Metadata-tokenURI}.
750      */
751     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
752         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
753 
754         string memory baseURI = _baseURI();
755         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
756     }
757 
758     /**
759      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
760      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
761      * by default, can be overriden in child contracts.
762      */
763     function _baseURI() internal view virtual returns (string memory) {
764         return "";
765     }
766 
767     /**
768      * @dev See {IERC721-approve}.
769      */
770     function approve(address to, uint256 tokenId) public virtual override {
771         address owner = ERC721.ownerOf(tokenId);
772         require(to != owner, "ERC721: approval to current owner");
773 
774         require(
775             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
776             "ERC721: approve caller is not owner nor approved for all"
777         );
778 
779         _approve(to, tokenId);
780     }
781 
782     /**
783      * @dev See {IERC721-getApproved}.
784      */
785     function getApproved(uint256 tokenId) public view virtual override returns (address) {
786         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
787 
788         return _tokenApprovals[tokenId];
789     }
790 
791     /**
792      * @dev See {IERC721-setApprovalForAll}.
793      */
794     function setApprovalForAll(address operator, bool approved) public virtual override {
795         _setApprovalForAll(_msgSender(), operator, approved);
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
1016      * @dev Approve `operator` to operate on all of `owner` tokens
1017      *
1018      * Emits a {ApprovalForAll} event.
1019      */
1020     function _setApprovalForAll(
1021         address owner,
1022         address operator,
1023         bool approved
1024     ) internal virtual {
1025         require(owner != operator, "ERC721: approve to caller");
1026         _operatorApprovals[owner][operator] = approved;
1027         emit ApprovalForAll(owner, operator, approved);
1028     }
1029 
1030     /**
1031      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1032      * The call is not executed if the target address is not a contract.
1033      *
1034      * @param from address representing the previous owner of the given token ID
1035      * @param to target address that will receive the tokens
1036      * @param tokenId uint256 ID of the token to be transferred
1037      * @param _data bytes optional data to send along with the call
1038      * @return bool whether the call correctly returned the expected magic value
1039      */
1040     function _checkOnERC721Received(
1041         address from,
1042         address to,
1043         uint256 tokenId,
1044         bytes memory _data
1045     ) private returns (bool) {
1046         if (to.isContract()) {
1047             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1048                 return retval == IERC721Receiver.onERC721Received.selector;
1049             } catch (bytes memory reason) {
1050                 if (reason.length == 0) {
1051                     revert("ERC721: transfer to non ERC721Receiver implementer");
1052                 } else {
1053                     assembly {
1054                         revert(add(32, reason), mload(reason))
1055                     }
1056                 }
1057             }
1058         } else {
1059             return true;
1060         }
1061     }
1062 
1063     /**
1064      * @dev Hook that is called before any token transfer. This includes minting
1065      * and burning.
1066      *
1067      * Calling conditions:
1068      *
1069      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1070      * transferred to `to`.
1071      * - When `from` is zero, `tokenId` will be minted for `to`.
1072      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1073      * - `from` and `to` are never both zero.
1074      *
1075      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1076      */
1077     function _beforeTokenTransfer(
1078         address from,
1079         address to,
1080         uint256 tokenId
1081     ) internal virtual {}
1082 }
1083 
1084 interface IERC721Enumerable is IERC721 {
1085     /**
1086      * @dev Returns the total amount of tokens stored by the contract.
1087      */
1088     function totalSupply() external view returns (uint256);
1089 }
1090 
1091 contract Mutant_Doodles is ERC721, Ownable, IERC721Enumerable {
1092 
1093 
1094     uint16 public counter = 1;
1095     uint public salePrice;
1096     uint public AllowListPrice;
1097     uint16 public maxSupply = 10000;
1098     uint8 public maxTokensPerWallet;
1099     uint8 public maxAllowListTokensPerWallet;
1100 
1101     bool public AllowListStatus;
1102     bool public saleStatus;
1103 
1104     string public baseURI;
1105 
1106     address public tokenForAllowList;
1107 
1108     mapping(address => uint8) public _maxTokensPerWallet;
1109     mapping(address => bool) public _allowListed;
1110     mapping(address => uint8) public _maxAllowListTokensPerWallet;
1111 
1112     constructor() ERC721("Mutant Doodles", "MDOODLE") {}
1113 
1114     function _baseURI() internal view override returns (string memory) {
1115         return baseURI;
1116     }
1117 
1118     function setBaseURI(string memory _newURI) external onlyOwner {
1119         baseURI = _newURI;
1120     }
1121 
1122     function addToAllowList(address[] memory wallets) external onlyOwner {
1123         for(uint8 i = 0; i<wallets.length; i++){
1124             _allowListed[wallets[i]] = !_allowListed[wallets[i]];
1125         }    
1126     }
1127 
1128     function setTokenForAllowList(address _token) external onlyOwner {
1129         tokenForAllowList = _token;
1130     }
1131 
1132     function setSalePrice(uint price) external onlyOwner {
1133         salePrice = price;
1134     }
1135 
1136     function setAllowListPrice(uint price) external onlyOwner {
1137         AllowListPrice = price;
1138     }
1139 
1140     function setMaxTokensPerWallet(uint8 max) external onlyOwner {
1141         maxTokensPerWallet = max;
1142     }
1143 
1144     function setMaxAllowListTokensPerWallet(uint8 max) external onlyOwner {
1145         maxAllowListTokensPerWallet = max;
1146     }
1147 
1148     function setAllowListSaleState() external onlyOwner {
1149         AllowListStatus = !AllowListStatus;
1150     }
1151 
1152     function setSaleStatus() external onlyOwner {
1153         saleStatus = !saleStatus;
1154     }
1155 
1156     function checkIfOwner(address owner) internal view returns(uint) {
1157         return IERC721(tokenForAllowList).balanceOf(owner);
1158     }
1159 
1160     function withdraw() external onlyOwner {
1161         payable(msg.sender).transfer(address(this).balance);
1162     }
1163 
1164     function totalSupply() public view virtual override returns (uint256) {
1165         return counter - 1;
1166     }
1167 
1168     function mintAllowList(uint8 amount) external payable {
1169         require(msg.value == AllowListPrice * amount, "Incorrect value!");
1170         require(AllowListStatus, "AllowList not active!");
1171         require(_maxAllowListTokensPerWallet[msg.sender] + amount <= maxAllowListTokensPerWallet, "Max tokens per wallet on AllowList!");
1172         require(checkIfOwner(msg.sender) > 0 || _allowListed[msg.sender], "Token from other contract not owned!");
1173         for(uint8 i = 0; i < amount; i++){
1174             _safeMint(msg.sender, counter);
1175             counter++;
1176             _maxAllowListTokensPerWallet[msg.sender]++;
1177         }
1178     }
1179 
1180     function mint(uint8 amount) external payable {
1181         require(msg.value == salePrice * amount, "Incorrect value!");
1182         require(counter + amount <= 10000, "Not enough tokens to sell!");
1183         require(saleStatus, "Sale not active!");
1184         require(_maxTokensPerWallet[msg.sender] + amount <= maxTokensPerWallet, "Max tokens per wallet on AllowList!");
1185         for(uint8 i = 0; i < amount; i++){
1186             _safeMint(msg.sender, counter);
1187             counter++;
1188             _maxTokensPerWallet[msg.sender]++;
1189         }
1190     }
1191 }