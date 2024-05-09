1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 ████████████████████████████████████████████████████████████████████████████████████████████████
6 █▄─█▀▀▀█─▄█─█─█▄─▄▄─█▄─▀█▄─▄███─▄─▄─█─█─█▄─▄▄─███─▄▄▄─█─▄▄─█▄─▀█▀─▄█▄─▄▄─█─▄─▄─███─█─█▄─▄█─▄─▄─█
7 ██─█─█─█─██─▄─██─▄█▀██─█▄▀─██████─███─▄─██─▄█▀███─███▀█─██─██─█▄█─███─▄█▀███─█████─▄─██─████─███
8 ▀▀▄▄▄▀▄▄▄▀▀▄▀▄▀▄▄▄▄▄▀▄▄▄▀▀▄▄▀▀▀▀▄▄▄▀▀▄▀▄▀▄▄▄▄▄▀▀▀▄▄▄▄▄▀▄▄▄▄▀▄▄▄▀▄▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀▀▀▄▀▄▀▄▄▄▀▀▄▄▄▀▀
9 ██████████████████████████████████████████████████████████████████████████████
10 █─▄─▄─█─█─█▄─▄▄─███▄─▄▄─██▀▄─██▄─▄▄▀█─▄─▄─█─█─███████─▄▄─█▄─▀█▄─▄█▄─▄███▄─█─▄█
11 ███─███─▄─██─▄█▀████─▄█▀██─▀─███─▄─▄███─███─▄─█░░████─██─██─█▄▀─███─██▀██▄─▄██
12 ▀▀▄▄▄▀▀▄▀▄▀▄▄▄▄▄▀▀▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▀▄▄▀▀▄▄▄▀▀▄▀▄▀▀▄▀▀▀▀▄▄▄▄▀▄▄▄▀▀▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀
13 ████████████████████████████████████████████████████████████████████████████████████████████
14 █─▄─▄─█─█─█─▄▄─█─▄▄▄▄█▄─▄▄─███▄─█▀▀▀█─▄█▄─▄█─▄─▄─█─█─███─▄─▄─█▄─▄█─▄─▄─██▀▄─██▄─▀█▄─▄█─▄▄▄▄█
15 ███─███─▄─█─██─█▄▄▄▄─██─▄█▀████─█─█─█─███─████─███─▄─█████─████─████─████─▀─███─█▄▀─██▄▄▄▄─█
16 ▀▀▄▄▄▀▀▄▀▄▀▄▄▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▀▀▀▄▄▄▀▄▄▄▀▀▄▄▄▀▀▄▄▄▀▀▄▀▄▀▀▀▀▄▄▄▀▀▄▄▄▀▀▄▄▄▀▀▄▄▀▄▄▀▄▄▄▀▀▄▄▀▄▄▄▄▄▀
17 ████████████████████████████████████████████████
18 █─▄▄▄▄█▄─██─▄█▄─▄▄▀█▄─█─▄█▄─▄█▄─█─▄█▄─▄▄─█▄─▄▄▀█
19 █▄▄▄▄─██─██─███─▄─▄██▄▀▄███─███▄▀▄███─▄█▀██─██─█
20 ▀▄▄▄▄▄▀▀▄▄▄▄▀▀▄▄▀▄▄▀▀▀▄▀▀▀▄▄▄▀▀▀▄▀▀▀▄▄▄▄▄▀▄▄▄▄▀▀
21 
22 */
23 
24 pragma solidity ^0.8.0;
25 
26 library Counters {
27     struct Counter {
28 
29         uint256 _value; // default: 0
30     }
31 
32     function current(Counter storage counter) internal view returns (uint256) {
33         return counter._value;
34     }
35 
36     function increment(Counter storage counter) internal {
37         unchecked {
38             counter._value += 1;
39         }
40     }
41 
42     function decrement(Counter storage counter) internal {
43         uint256 value = counter._value;
44         require(value > 0, "Counter:decrement overflow");
45         unchecked {
46             counter._value = value - 1;
47         }
48     }
49 
50     function reset(Counter storage counter) internal {
51         counter._value = 0;
52     }
53 }
54 
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev String operations.
60  */
61 library Strings {
62     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
66      */
67     function toString(uint256 value) internal pure returns (string memory) {
68         // Inspired by OraclizeAPI's implementation - MIT licence
69         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
70 
71         if (value == 0) {
72             return "0";
73         }
74         uint256 temp = value;
75         uint256 digits;
76         while (temp != 0) {
77             digits++;
78             temp /= 10;
79         }
80         bytes memory buffer = new bytes(digits);
81         while (value != 0) {
82             digits -= 1;
83             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
84             value /= 10;
85         }
86         return string(buffer);
87     }
88 
89     /**
90      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
91      */
92     function toHexString(uint256 value) internal pure returns (string memory) {
93         if (value == 0) {
94             return "0x00";
95         }
96         uint256 temp = value;
97         uint256 length = 0;
98         while (temp != 0) {
99             length++;
100             temp >>= 8;
101         }
102         return toHexString(value, length);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
107      */
108     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
109         bytes memory buffer = new bytes(2 * length + 2);
110         buffer[0] = "0";
111         buffer[1] = "x";
112         for (uint256 i = 2 * length + 1; i > 1; --i) {
113             buffer[i] = _HEX_SYMBOLS[value & 0xf];
114             value >>= 4;
115         }
116         require(value == 0, "Strings: hex length insufficient");
117         return string(buffer);
118     }
119 }
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 
144 pragma solidity ^0.8.0;
145 
146 abstract contract Ownable is Context {
147     address private _owner;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151     /**
152      * @dev Initializes the contract setting the deployer as the initial owner.
153      */
154     constructor() {
155         _transferOwnership(_msgSender());
156     }
157 
158     /**
159      * @dev Returns the address of the current owner.
160      */
161     function owner() public view virtual returns (address) {
162         return _owner;
163     }
164 
165     /**
166      * @dev Throws if called by any account other than the owner.
167      */
168     modifier onlyOwner() {
169         require(owner() == _msgSender(), "Ownable: caller is not the owner");
170         _;
171     }
172 
173     /**
174      * @dev Leaves the contract without owner. It will not be possible to call
175      * `onlyOwner` functions anymore. Can only be called by the current owner.
176      *
177      * NOTE: Renouncing ownership will leave the contract without an owner,
178      * thereby removing any functionality that is only available to the owner.
179      */
180     function renounceOwnership() public virtual onlyOwner {
181         _transferOwnership(address(0));
182     }
183 
184     /**
185      * @dev Transfers ownership of the contract to a new account (`newOwner`).
186      * Can only be called by the current owner.
187      */
188     function transferOwnership(address newOwner) public virtual onlyOwner {
189         require(newOwner != address(0), "Ownable: new owner is the zero address");
190         _transferOwnership(newOwner);
191     }
192 
193     /**
194      * @dev Transfers ownership of the contract to a new account (`newOwner`).
195      * Internal function without access restriction.
196      */
197     function _transferOwnership(address newOwner) internal virtual {
198         address oldOwner = _owner;
199         _owner = newOwner;
200         emit OwnershipTransferred(oldOwner, newOwner);
201     }
202 }
203 
204 pragma solidity ^0.8.1;
205 
206 /**
207  * @dev Collection of functions related to the address type
208  */
209 library Address {
210     /**
211      * @dev Returns true if `account` is a contract.
212      *
213      * [IMPORTANT]
214      * ====
215      * It is unsafe to assume that an address for which this function returns
216      * false is an externally-owned account (EOA) and not a contract.
217      *
218      * Among others, `isContract` will return false for the following
219      * types of addresses:
220      *
221      *  - an externally-owned account
222      *  - a contract in construction
223      *  - an address where a contract will be created
224      *  - an address where a contract lived, but was destroyed
225      * ====
226      *
227      * [IMPORTANT]
228      * ====
229      * You shouldn't rely on `isContract` to protect against flash loan attacks!
230      *
231      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
232      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
233      * constructor.
234      * ====
235      */
236     function isContract(address account) internal view returns (bool) {
237         // This method relies on extcodesize/address.code.length, which returns 0
238         // for contracts in construction, since the code is only stored at the end
239         // of the constructor execution.
240 
241         return account.code.length > 0;
242     }
243 
244     /**
245      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
246      * `recipient`, forwarding all available gas and reverting on errors.
247      *
248      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
249      * of certain opcodes, possibly making contracts go over the 2300 gas limit
250      * imposed by `transfer`, making them unable to receive funds via
251      * `transfer`. {sendValue} removes this limitation.
252      *
253      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
254      *
255      * IMPORTANT: because control is transferred to `recipient`, care must be
256      * taken to not create reentrancy vulnerabilities. Consider using
257      * {ReentrancyGuard} or the
258      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
259      */
260     function sendValue(address payable recipient, uint256 amount) internal {
261         require(address(this).balance >= amount, "Address: insufficient balance");
262 
263         (bool success, ) = recipient.call{value: amount}("");
264         require(success, "Address: unable to send value, recipient may have reverted");
265     }
266 
267     /**
268      * @dev Performs a Solidity function call using a low level `call`. A
269      * plain `call` is an unsafe replacement for a function call: use this
270      * function instead.
271      *
272      * If `target` reverts with a revert reason, it is bubbled up by this
273      * function (like regular Solidity function calls).
274      *
275      * Returns the raw returned data. To convert to the expected return value,
276      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
277      *
278      * Requirements:
279      *
280      * - `target` must be a contract.
281      * - calling `target` with `data` must not revert.
282      *
283      * _Available since v3.1._
284      */
285     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
286         return functionCall(target, data, "Address: low-level call failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
291      * `errorMessage` as a fallback revert reason when `target` reverts.
292      *
293      * _Available since v3.1._
294      */
295     function functionCall(
296         address target,
297         bytes memory data,
298         string memory errorMessage
299     ) internal returns (bytes memory) {
300         return functionCallWithValue(target, data, 0, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but also transferring `value` wei to `target`.
306      *
307      * Requirements:
308      *
309      * - the calling contract must have an ETH balance of at least `value`.
310      * - the called Solidity function must be `payable`.
311      *
312      * _Available since v3.1._
313      */
314     function functionCallWithValue(
315         address target,
316         bytes memory data,
317         uint256 value
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
324      * with `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCallWithValue(
329         address target,
330         bytes memory data,
331         uint256 value,
332         string memory errorMessage
333     ) internal returns (bytes memory) {
334         require(address(this).balance >= value, "Address: insufficient balance for call");
335         require(isContract(target), "Address: call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.call{value: value}(data);
338         return verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but performing a static call.
344      *
345      * _Available since v3.3._
346      */
347     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
348         return functionStaticCall(target, data, "Address: low-level static call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
353      * but performing a static call.
354      *
355      * _Available since v3.3._
356      */
357     function functionStaticCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal view returns (bytes memory) {
362         require(isContract(target), "Address: static call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.staticcall(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a delegate call.
371      *
372      * _Available since v3.4._
373      */
374     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
375         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a delegate call.
381      *
382      * _Available since v3.4._
383      */
384     function functionDelegateCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(isContract(target), "Address: delegate call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.delegatecall(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
397      * revert reason using the provided one.
398      *
399      * _Available since v4.3._
400      */
401     function verifyCallResult(
402         bool success,
403         bytes memory returndata,
404         string memory errorMessage
405     ) internal pure returns (bytes memory) {
406         if (success) {
407             return returndata;
408         } else {
409             // Look for revert reason and bubble it up if present
410             if (returndata.length > 0) {
411                 // The easiest way to bubble the revert reason is using memory via assembly
412 
413                 assembly {
414                     let returndata_size := mload(returndata)
415                     revert(add(32, returndata), returndata_size)
416                 }
417             } else {
418                 revert(errorMessage);
419             }
420         }
421     }
422 }
423 
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @title ERC721 token receiver interface
428  * @dev Interface for any contract that wants to support safeTransfers
429  * from ERC721 asset contracts.
430  */
431 interface IERC721Receiver {
432     /**
433      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
434      * by `operator` from `from`, this function is called.
435      *
436      * It must return its Solidity selector to confirm the token transfer.
437      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
438      *
439      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
440      */
441     function onERC721Received(
442         address operator,
443         address from,
444         uint256 tokenId,
445         bytes calldata data
446     ) external returns (bytes4);
447 }
448 
449 pragma solidity ^0.8.0;
450 
451 /**
452  * @dev Interface of the ERC165 standard, as defined in the
453  * https://eips.ethereum.org/EIPS/eip-165[EIP].
454  *
455  * Implementers can declare support of contract interfaces, which can then be
456  * queried by others ({ERC165Checker}).
457  *
458  * For an implementation, see {ERC165}.
459  */
460 interface IERC165 {
461     /**
462      * @dev Returns true if this contract implements the interface defined by
463      * `interfaceId`. See the corresponding
464      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
465      * to learn more about how these ids are created.
466      *
467      * This function call must use less than 30 000 gas.
468      */
469     function supportsInterface(bytes4 interfaceId) external view returns (bool);
470 }
471 
472 pragma solidity ^0.8.0;
473 
474 abstract contract ERC165 is IERC165 {
475     /**
476      * @dev See {IERC165-supportsInterface}.
477      */
478     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
479         return interfaceId == type(IERC165).interfaceId;
480     }
481 }
482 
483 pragma solidity ^0.8.0;
484 
485 interface IERC721 is IERC165 {
486     /**
487      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
488      */
489     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
490 
491     /**
492      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
493      */
494     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
495 
496     /**
497      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
498      */
499     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
500 
501     /**
502      * @dev Returns the number of tokens in ``owner``'s account.
503      */
504     function balanceOf(address owner) external view returns (uint256 balance);
505 
506     /**
507      * @dev Returns the owner of the `tokenId` token.
508      *
509      * Requirements:
510      *
511      * - `tokenId` must exist.
512      */
513     function ownerOf(uint256 tokenId) external view returns (address owner);
514 
515     function safeTransferFrom(
516         address from,
517         address to,
518         uint256 tokenId
519     ) external;
520 
521     function transferFrom(
522         address from,
523         address to,
524         uint256 tokenId
525     ) external;
526 
527     function approve(address to, uint256 tokenId) external;
528 
529     /**
530      * @dev Returns the account approved for `tokenId` token.
531      *
532      * Requirements:
533      *
534      * - `tokenId` must exist.
535      */
536     function getApproved(uint256 tokenId) external view returns (address operator);
537 
538     /**
539      * @dev Approve or remove `operator` as an operator for the caller.
540      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
541      *
542      * Requirements:
543      *
544      * - The `operator` cannot be the caller.
545      *
546      * Emits an {ApprovalForAll} event.
547      */
548     function setApprovalForAll(address operator, bool _approved) external;
549 
550     /**
551      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
552      *
553      * See {setApprovalForAll}
554      */
555     function isApprovedForAll(address owner, address operator) external view returns (bool);
556 
557     /**
558      * @dev Safely transfers `tokenId` token from `from` to `to`.
559      *
560      * Requirements:
561      *
562      * - `from` cannot be the zero address.
563      * - `to` cannot be the zero address.
564      * - `tokenId` token must exist and be owned by `from`.
565      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
566      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
567      *
568      * Emits a {Transfer} event.
569      */
570     function safeTransferFrom(
571         address from,
572         address to,
573         uint256 tokenId,
574         bytes calldata data
575     ) external;
576 }
577 
578 
579 pragma solidity ^0.8.0;
580 
581 
582 /**
583  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
584  * @dev See https://eips.ethereum.org/EIPS/eip-721
585  */
586 interface IERC721Enumerable is IERC721 {
587     /**
588      * @dev Returns the total amount of tokens stored by the contract.
589      */
590     function totalSupply() external view returns (uint256);
591 
592     /**
593      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
594      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
595      */
596     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
597 
598     /**
599      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
600      * Use along with {totalSupply} to enumerate all tokens.
601      */
602     function tokenByIndex(uint256 index) external view returns (uint256);
603 }
604 
605 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
606 
607 
608 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
609 
610 pragma solidity ^0.8.0;
611 
612 
613 /**
614  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
615  * @dev See https://eips.ethereum.org/EIPS/eip-721
616  */
617 interface IERC721Metadata is IERC721 {
618     /**
619      * @dev Returns the token collection name.
620      */
621     function name() external view returns (string memory);
622 
623     /**
624      * @dev Returns the token collection symbol.
625      */
626     function symbol() external view returns (string memory);
627 
628     /**
629      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
630      */
631     function tokenURI(uint256 tokenId) external view returns (string memory);
632 }
633 
634 
635 pragma solidity ^0.8.0;
636 
637 /**
638  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
639  * the Metadata extension, but not including the Enumerable extension, which is available separately as
640  * {ERC721Enumerable}.
641  */
642 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
643     using Address for address;
644     using Strings for uint256;
645 
646     // Token name
647     string private _name;
648 
649     // Token symbol
650     string private _symbol;
651 
652     // Mapping from token ID to owner address
653     mapping(uint256 => address) private _owners;
654 
655     // Mapping owner address to token count
656     mapping(address => uint256) private _balances;
657 
658     // Mapping from token ID to approved address
659     mapping(uint256 => address) private _tokenApprovals;
660 
661     // Mapping from owner to operator approvals
662     mapping(address => mapping(address => bool)) private _operatorApprovals;
663 
664     /**
665      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
666      */
667     constructor(string memory name_, string memory symbol_) {
668         _name = name_;
669         _symbol = symbol_;
670     }
671 
672     /**
673      * @dev See {IERC165-supportsInterface}.
674      */
675     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
676         return
677             interfaceId == type(IERC721).interfaceId ||
678             interfaceId == type(IERC721Metadata).interfaceId ||
679             super.supportsInterface(interfaceId);
680     }
681 
682     /**
683      * @dev See {IERC721-balanceOf}.
684      */
685     function balanceOf(address owner) public view virtual override returns (uint256) {
686         require(owner != address(0), "ERC721: balance query for the zero address");
687         return _balances[owner];
688     }
689 
690     /**
691      * @dev See {IERC721-ownerOf}.
692      */
693     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
694         address owner = _owners[tokenId];
695         require(owner != address(0), "ERC721: owner query for nonexistent token");
696         return owner;
697     }
698 
699     /**
700      * @dev See {IERC721Metadata-name}.
701      */
702     function name() public view virtual override returns (string memory) {
703         return _name;
704     }
705 
706     /**
707      * @dev See {IERC721Metadata-symbol}.
708      */
709     function symbol() public view virtual override returns (string memory) {
710         return _symbol;
711     }
712 
713     /**
714      * @dev See {IERC721Metadata-tokenURI}.
715      */
716     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
717         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
718 
719         string memory baseURI = _baseURI();
720         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
721     }
722 
723     /**
724      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
725      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
726      * by default, can be overriden in child contracts.
727      */
728     function _baseURI() internal view virtual returns (string memory) {
729         return "";
730     }
731 
732     /**
733      * @dev See {IERC721-approve}.
734      */
735     function approve(address to, uint256 tokenId) public virtual override {
736         address owner = ERC721.ownerOf(tokenId);
737         require(to != owner, "ERC721: approval to current owner");
738 
739         require(
740             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
741             "ERC721: approve caller is not owner nor approved for all"
742         );
743 
744         _approve(to, tokenId);
745     }
746 
747     /**
748      * @dev See {IERC721-getApproved}.
749      */
750     function getApproved(uint256 tokenId) public view virtual override returns (address) {
751         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
752 
753         return _tokenApprovals[tokenId];
754     }
755 
756     /**
757      * @dev See {IERC721-setApprovalForAll}.
758      */
759     function setApprovalForAll(address operator, bool approved) public virtual override {
760         _setApprovalForAll(_msgSender(), operator, approved);
761     }
762 
763     /**
764      * @dev See {IERC721-isApprovedForAll}.
765      */
766     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
767         return _operatorApprovals[owner][operator];
768     }
769 
770     /**
771      * @dev See {IERC721-transferFrom}.
772      */
773     function transferFrom(
774         address from,
775         address to,
776         uint256 tokenId
777     ) public virtual override {
778         //solhint-disable-next-line max-line-length
779         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
780 
781         _transfer(from, to, tokenId);
782     }
783 
784     /**
785      * @dev See {IERC721-safeTransferFrom}.
786      */
787     function safeTransferFrom(
788         address from,
789         address to,
790         uint256 tokenId
791     ) public virtual override {
792         safeTransferFrom(from, to, tokenId, "");
793     }
794 
795     /**
796      * @dev See {IERC721-safeTransferFrom}.
797      */
798     function safeTransferFrom(
799         address from,
800         address to,
801         uint256 tokenId,
802         bytes memory _data
803     ) public virtual override {
804         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
805         _safeTransfer(from, to, tokenId, _data);
806     }
807 
808     /**
809      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
810      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
811      *
812      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
813      *
814      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
815      * implement alternative mechanisms to perform token transfer, such as signature-based.
816      *
817      * Requirements:
818      *
819      * - `from` cannot be the zero address.
820      * - `to` cannot be the zero address.
821      * - `tokenId` token must exist and be owned by `from`.
822      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _safeTransfer(
827         address from,
828         address to,
829         uint256 tokenId,
830         bytes memory _data
831     ) internal virtual {
832         _transfer(from, to, tokenId);
833         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
834     }
835 
836     /**
837      * @dev Returns whether `tokenId` exists.
838      *
839      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
840      *
841      * Tokens start existing when they are minted (`_mint`),
842      * and stop existing when they are burned (`_burn`).
843      */
844     function _exists(uint256 tokenId) internal view virtual returns (bool) {
845         return _owners[tokenId] != address(0);
846     }
847 
848     /**
849      * @dev Returns whether `spender` is allowed to manage `tokenId`.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      */
855     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
856         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
857         address owner = ERC721.ownerOf(tokenId);
858         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
859     }
860 
861     /**
862      * @dev Safely mints `tokenId` and transfers it to `to`.
863      *
864      * Requirements:
865      *
866      * - `tokenId` must not exist.
867      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
868      *
869      * Emits a {Transfer} event.
870      */
871     function _safeMint(address to, uint256 tokenId) internal virtual {
872         _safeMint(to, tokenId, "");
873     }
874 
875     /**
876      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
877      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
878      */
879     function _safeMint(
880         address to,
881         uint256 tokenId,
882         bytes memory _data
883     ) internal virtual {
884         _mint(to, tokenId);
885         require(
886             _checkOnERC721Received(address(0), to, tokenId, _data),
887             "ERC721: transfer to non ERC721Receiver implementer"
888         );
889     }
890 
891     /**
892      * @dev Mints `tokenId` and transfers it to `to`.
893      *
894      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
895      *
896      * Requirements:
897      *
898      * - `tokenId` must not exist.
899      * - `to` cannot be the zero address.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _mint(address to, uint256 tokenId) internal virtual {
904         require(to != address(0), "ERC721: mint to the zero address");
905         require(!_exists(tokenId), "ERC721: token already minted");
906 
907         _beforeTokenTransfer(address(0), to, tokenId);
908 
909         _balances[to] += 1;
910         _owners[tokenId] = to;
911 
912         emit Transfer(address(0), to, tokenId);
913 
914         _afterTokenTransfer(address(0), to, tokenId);
915     }
916 
917     /**
918      * @dev Destroys `tokenId`.
919      * The approval is cleared when the token is burned.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must exist.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _burn(uint256 tokenId) internal virtual {
928         address owner = ERC721.ownerOf(tokenId);
929 
930         _beforeTokenTransfer(owner, address(0), tokenId);
931 
932         // Clear approvals
933         _approve(address(0), tokenId);
934 
935         _balances[owner] -= 1;
936         delete _owners[tokenId];
937 
938         emit Transfer(owner, address(0), tokenId);
939 
940         _afterTokenTransfer(owner, address(0), tokenId);
941     }
942 
943     /**
944      * @dev Transfers `tokenId` from `from` to `to`.
945      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
946      *
947      * Requirements:
948      *
949      * - `to` cannot be the zero address.
950      * - `tokenId` token must be owned by `from`.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _transfer(
955         address from,
956         address to,
957         uint256 tokenId
958     ) internal virtual {
959         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
960         require(to != address(0), "ERC721: transfer to the zero address");
961 
962         _beforeTokenTransfer(from, to, tokenId);
963 
964         // Clear approvals from the previous owner
965         _approve(address(0), tokenId);
966 
967         _balances[from] -= 1;
968         _balances[to] += 1;
969         _owners[tokenId] = to;
970 
971         emit Transfer(from, to, tokenId);
972 
973         _afterTokenTransfer(from, to, tokenId);
974     }
975 
976     /**
977      * @dev Approve `to` to operate on `tokenId`
978      *
979      * Emits a {Approval} event.
980      */
981     function _approve(address to, uint256 tokenId) internal virtual {
982         _tokenApprovals[tokenId] = to;
983         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
984     }
985 
986     /**
987      * @dev Approve `operator` to operate on all of `owner` tokens
988      *
989      * Emits a {ApprovalForAll} event.
990      */
991     function _setApprovalForAll(
992         address owner,
993         address operator,
994         bool approved
995     ) internal virtual {
996         require(owner != operator, "ERC721: approve to caller");
997         _operatorApprovals[owner][operator] = approved;
998         emit ApprovalForAll(owner, operator, approved);
999     }
1000 
1001     /**
1002      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1003      * The call is not executed if the target address is not a contract.
1004      *
1005      * @param from address representing the previous owner of the given token ID
1006      * @param to target address that will receive the tokens
1007      * @param tokenId uint256 ID of the token to be transferred
1008      * @param _data bytes optional data to send along with the call
1009      * @return bool whether the call correctly returned the expected magic value
1010      */
1011     function _checkOnERC721Received(
1012         address from,
1013         address to,
1014         uint256 tokenId,
1015         bytes memory _data
1016     ) private returns (bool) {
1017         if (to.isContract()) {
1018             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1019                 return retval == IERC721Receiver.onERC721Received.selector;
1020             } catch (bytes memory reason) {
1021                 if (reason.length == 0) {
1022                     revert("ERC721: transfer to non ERC721Receiver implementer");
1023                 } else {
1024                     assembly {
1025                         revert(add(32, reason), mload(reason))
1026                     }
1027                 }
1028             }
1029         } else {
1030             return true;
1031         }
1032     }
1033 
1034     function _beforeTokenTransfer(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) internal virtual {}
1039 
1040     /**
1041      * @dev Hook that is called after any transfer of tokens. This includes
1042      * minting and burning.
1043      *
1044      * Calling conditions:
1045      *
1046      * - when `from` and `to` are both non-zero.
1047      * - `from` and `to` are never both zero.
1048      *
1049      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1050      */
1051     function _afterTokenTransfer(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) internal virtual {}
1056 }
1057 
1058 
1059 pragma solidity ^0.8.0;
1060 
1061 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1062     // Mapping from owner to list of owned token IDs
1063     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1064 
1065     // Mapping from token ID to index of the owner tokens list
1066     mapping(uint256 => uint256) private _ownedTokensIndex;
1067 
1068     // Array with all token ids, used for enumeration
1069     uint256[] private _allTokens;
1070 
1071     // Mapping from token id to position in the allTokens array
1072     mapping(uint256 => uint256) private _allTokensIndex;
1073 
1074     /**
1075      * @dev See {IERC165-supportsInterface}.
1076      */
1077     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1078         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1079     }
1080 
1081     /**
1082      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1083      */
1084     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1085         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1086         return _ownedTokens[owner][index];
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Enumerable-totalSupply}.
1091      */
1092     function totalSupply() public view virtual override returns (uint256) {
1093         return _allTokens.length;
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Enumerable-tokenByIndex}.
1098      */
1099     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1100         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1101         return _allTokens[index];
1102     }
1103 
1104     function _beforeTokenTransfer(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) internal virtual override {
1109         super._beforeTokenTransfer(from, to, tokenId);
1110 
1111         if (from == address(0)) {
1112             _addTokenToAllTokensEnumeration(tokenId);
1113         } else if (from != to) {
1114             _removeTokenFromOwnerEnumeration(from, tokenId);
1115         }
1116         if (to == address(0)) {
1117             _removeTokenFromAllTokensEnumeration(tokenId);
1118         } else if (to != from) {
1119             _addTokenToOwnerEnumeration(to, tokenId);
1120         }
1121     }
1122 
1123     /**
1124      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1125      * @param to address representing the new owner of the given token ID
1126      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1127      */
1128     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1129         uint256 length = ERC721.balanceOf(to);
1130         _ownedTokens[to][length] = tokenId;
1131         _ownedTokensIndex[tokenId] = length;
1132     }
1133 
1134     /**
1135      * @dev Private function to add a token to this extension's token tracking data structures.
1136      * @param tokenId uint256 ID of the token to be added to the tokens list
1137      */
1138     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1139         _allTokensIndex[tokenId] = _allTokens.length;
1140         _allTokens.push(tokenId);
1141     }
1142 
1143     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1144         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1145         // then delete the last slot (swap and pop).
1146 
1147         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1148         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1149 
1150         // When the token to delete is the last token, the swap operation is unnecessary
1151         if (tokenIndex != lastTokenIndex) {
1152             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1153 
1154             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1155             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1156         }
1157 
1158         // This also deletes the contents at the last position of the array
1159         delete _ownedTokensIndex[tokenId];
1160         delete _ownedTokens[from][lastTokenIndex];
1161     }
1162 
1163     /**
1164      * @dev Private function to remove a token from this extension's token tracking data structures.
1165      * This has O(1) time complexity, but alters the order of the _allTokens array.
1166      * @param tokenId uint256 ID of the token to be removed from the tokens list
1167      */
1168     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1169         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1170         // then delete the last slot (swap and pop).
1171 
1172         uint256 lastTokenIndex = _allTokens.length - 1;
1173         uint256 tokenIndex = _allTokensIndex[tokenId];
1174 
1175         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1176         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1177         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1178         uint256 lastTokenId = _allTokens[lastTokenIndex];
1179 
1180         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1181         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1182 
1183         // This also deletes the contents at the last position of the array
1184         delete _allTokensIndex[tokenId];
1185         _allTokens.pop();
1186     }
1187 }
1188 
1189 
1190 pragma solidity ^0.8.4;
1191 
1192 error ApprovalCallerNotOwnerNorApproved();
1193 error ApprovalQueryForNonexistentToken();
1194 error ApproveToCaller();
1195 error ApprovalToCurrentOwner();
1196 error BalanceQueryForZeroAddress();
1197 error MintToZeroAddress();
1198 error MintZeroQuantity();
1199 error OwnerQueryForNonexistentToken();
1200 error TransferCallerNotOwnerNorApproved();
1201 error TransferFromIncorrectOwner();
1202 error TransferToNonERC721ReceiverImplementer();
1203 error TransferToZeroAddress();
1204 error URIQueryForNonexistentToken();
1205 
1206 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1207     using Address for address;
1208     using Strings for uint256;
1209 
1210     // Compiler will pack this into a single 256bit word.
1211     struct TokenOwnership {
1212         // The address of the owner.
1213         address addr;
1214         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1215         uint64 startTimestamp;
1216         // Whether the token has been burned.
1217         bool burned;
1218     }
1219 
1220     // Compiler will pack this into a single 256bit word.
1221     struct AddressData {
1222         // Realistically, 2**64-1 is more than enough.
1223         uint64 balance;
1224         // Keeps track of mint count with minimal overhead for tokenomics.
1225         uint64 numberMinted;
1226         // Keeps track of burn count with minimal overhead for tokenomics.
1227         uint64 numberBurned;
1228         // For miscellaneous variable(s) pertaining to the address
1229         // (e.g. number of whitelist mint slots used).
1230         // If there are multiple variables, please pack them into a uint64.
1231         uint64 aux;
1232     }
1233 
1234     // The tokenId of the next token to be minted.
1235     uint256 internal _currentIndex;
1236 
1237     // The number of tokens burned.
1238     uint256 internal _burnCounter;
1239 
1240     // Token name
1241     string private _name;
1242 
1243     // Token symbol
1244     string private _symbol;
1245 
1246     // Mapping from token ID to ownership details
1247     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1248     mapping(uint256 => TokenOwnership) internal _ownerships;
1249 
1250     // Mapping owner address to address data
1251     mapping(address => AddressData) private _addressData;
1252 
1253     // Mapping from token ID to approved address
1254     mapping(uint256 => address) private _tokenApprovals;
1255 
1256     // Mapping from owner to operator approvals
1257     mapping(address => mapping(address => bool)) private _operatorApprovals;
1258 
1259     constructor(string memory name_, string memory symbol_) {
1260         _name = name_;
1261         _symbol = symbol_;
1262         _currentIndex = _startTokenId();
1263     }
1264 
1265     /**
1266      * To change the starting tokenId, please override this function.
1267      */
1268     function _startTokenId() internal view virtual returns (uint256) {
1269         return 0;
1270     }
1271 
1272     /**
1273      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1274      */
1275     function totalSupply() public view returns (uint256) {
1276         // Counter underflow is impossible as _burnCounter cannot be incremented
1277         // more than _currentIndex - _startTokenId() times
1278         unchecked {
1279             return _currentIndex - _burnCounter - _startTokenId();
1280         }
1281     }
1282 
1283     /**
1284      * Returns the total amount of tokens minted in the contract.
1285      */
1286     function _totalMinted() internal view returns (uint256) {
1287         // Counter underflow is impossible as _currentIndex does not decrement,
1288         // and it is initialized to _startTokenId()
1289         unchecked {
1290             return _currentIndex - _startTokenId();
1291         }
1292     }
1293 
1294     /**
1295      * @dev See {IERC165-supportsInterface}.
1296      */
1297     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1298         return
1299             interfaceId == type(IERC721).interfaceId ||
1300             interfaceId == type(IERC721Metadata).interfaceId ||
1301             super.supportsInterface(interfaceId);
1302     }
1303 
1304     /**
1305      * @dev See {IERC721-balanceOf}.
1306      */
1307     function balanceOf(address owner) public view override returns (uint256) {
1308         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1309         return uint256(_addressData[owner].balance);
1310     }
1311 
1312     /**
1313      * Returns the number of tokens minted by `owner`.
1314      */
1315     function _numberMinted(address owner) internal view returns (uint256) {
1316         return uint256(_addressData[owner].numberMinted);
1317     }
1318 
1319     /**
1320      * Returns the number of tokens burned by or on behalf of `owner`.
1321      */
1322     function _numberBurned(address owner) internal view returns (uint256) {
1323         return uint256(_addressData[owner].numberBurned);
1324     }
1325 
1326     /**
1327      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1328      */
1329     function _getAux(address owner) internal view returns (uint64) {
1330         return _addressData[owner].aux;
1331     }
1332 
1333     /**
1334      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1335      * If there are multiple variables, please pack them into a uint64.
1336      */
1337     function _setAux(address owner, uint64 aux) internal {
1338         _addressData[owner].aux = aux;
1339     }
1340 
1341     /**
1342      * Gas spent here starts off proportional to the maximum mint batch size.
1343      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1344      */
1345     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1346         uint256 curr = tokenId;
1347 
1348         unchecked {
1349             if (_startTokenId() <= curr && curr < _currentIndex) {
1350                 TokenOwnership memory ownership = _ownerships[curr];
1351                 if (!ownership.burned) {
1352                     if (ownership.addr != address(0)) {
1353                         return ownership;
1354                     }
1355                     // Invariant:
1356                     // There will always be an ownership that has an address and is not burned
1357                     // before an ownership that does not have an address and is not burned.
1358                     // Hence, curr will not underflow.
1359                     while (true) {
1360                         curr--;
1361                         ownership = _ownerships[curr];
1362                         if (ownership.addr != address(0)) {
1363                             return ownership;
1364                         }
1365                     }
1366                 }
1367             }
1368         }
1369         revert OwnerQueryForNonexistentToken();
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-ownerOf}.
1374      */
1375     function ownerOf(uint256 tokenId) public view override returns (address) {
1376         return _ownershipOf(tokenId).addr;
1377     }
1378 
1379     /**
1380      * @dev See {IERC721Metadata-name}.
1381      */
1382     function name() public view virtual override returns (string memory) {
1383         return _name;
1384     }
1385 
1386     /**
1387      * @dev See {IERC721Metadata-symbol}.
1388      */
1389     function symbol() public view virtual override returns (string memory) {
1390         return _symbol;
1391     }
1392 
1393     /**
1394      * @dev See {IERC721Metadata-tokenURI}.
1395      */
1396     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1397         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1398 
1399         string memory baseURI = _baseURI();
1400         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1401     }
1402 
1403     /**
1404      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1405      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1406      * by default, can be overriden in child contracts.
1407      */
1408     function _baseURI() internal view virtual returns (string memory) {
1409         return '';
1410     }
1411 
1412     /**
1413      * @dev See {IERC721-approve}.
1414      */
1415     function approve(address to, uint256 tokenId) public override {
1416         address owner = ERC721A.ownerOf(tokenId);
1417         if (to == owner) revert ApprovalToCurrentOwner();
1418 
1419         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1420             revert ApprovalCallerNotOwnerNorApproved();
1421         }
1422 
1423         _approve(to, tokenId, owner);
1424     }
1425 
1426     /**
1427      * @dev See {IERC721-getApproved}.
1428      */
1429     function getApproved(uint256 tokenId) public view override returns (address) {
1430         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1431 
1432         return _tokenApprovals[tokenId];
1433     }
1434 
1435     /**
1436      * @dev See {IERC721-setApprovalForAll}.
1437      */
1438     function setApprovalForAll(address operator, bool approved) public virtual override {
1439         if (operator == _msgSender()) revert ApproveToCaller();
1440 
1441         _operatorApprovals[_msgSender()][operator] = approved;
1442         emit ApprovalForAll(_msgSender(), operator, approved);
1443     }
1444 
1445     /**
1446      * @dev See {IERC721-isApprovedForAll}.
1447      */
1448     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1449         return _operatorApprovals[owner][operator];
1450     }
1451 
1452     /**
1453      * @dev See {IERC721-transferFrom}.
1454      */
1455     function transferFrom(
1456         address from,
1457         address to,
1458         uint256 tokenId
1459     ) public virtual override {
1460         _transfer(from, to, tokenId);
1461     }
1462 
1463     /**
1464      * @dev See {IERC721-safeTransferFrom}.
1465      */
1466     function safeTransferFrom(
1467         address from,
1468         address to,
1469         uint256 tokenId
1470     ) public virtual override {
1471         safeTransferFrom(from, to, tokenId, '');
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-safeTransferFrom}.
1476      */
1477     function safeTransferFrom(
1478         address from,
1479         address to,
1480         uint256 tokenId,
1481         bytes memory _data
1482     ) public virtual override {
1483         _transfer(from, to, tokenId);
1484         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1485             revert TransferToNonERC721ReceiverImplementer();
1486         }
1487     }
1488 
1489     /**
1490      * @dev Returns whether `tokenId` exists.
1491      *
1492      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1493      *
1494      * Tokens start existing when they are minted (`_mint`),
1495      */
1496     function _exists(uint256 tokenId) internal view returns (bool) {
1497         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1498     }
1499 
1500     function _safeMint(address to, uint256 quantity) internal {
1501         _safeMint(to, quantity, '');
1502     }
1503 
1504     /**
1505      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1506      *
1507      * Requirements:
1508      *
1509      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1510      * - `quantity` must be greater than 0.
1511      *
1512      * Emits a {Transfer} event.
1513      */
1514     function _safeMint(
1515         address to,
1516         uint256 quantity,
1517         bytes memory _data
1518     ) internal {
1519         _mint(to, quantity, _data, true);
1520     }
1521 
1522     /**
1523      * @dev Mints `quantity` tokens and transfers them to `to`.
1524      *
1525      * Requirements:
1526      *
1527      * - `to` cannot be the zero address.
1528      * - `quantity` must be greater than 0.
1529      *
1530      * Emits a {Transfer} event.
1531      */
1532     function _mint(
1533         address to,
1534         uint256 quantity,
1535         bytes memory _data,
1536         bool safe
1537     ) internal {
1538         uint256 startTokenId = _currentIndex;
1539         if (to == address(0)) revert MintToZeroAddress();
1540         if (quantity == 0) revert MintZeroQuantity();
1541 
1542         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1543 
1544         // Overflows are incredibly unrealistic.
1545         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1546         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1547         unchecked {
1548             _addressData[to].balance += uint64(quantity);
1549             _addressData[to].numberMinted += uint64(quantity);
1550 
1551             _ownerships[startTokenId].addr = to;
1552             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1553 
1554             uint256 updatedIndex = startTokenId;
1555             uint256 end = updatedIndex + quantity;
1556 
1557             if (safe && to.isContract()) {
1558                 do {
1559                     emit Transfer(address(0), to, updatedIndex);
1560                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1561                         revert TransferToNonERC721ReceiverImplementer();
1562                     }
1563                 } while (updatedIndex != end);
1564                 // Reentrancy protection
1565                 if (_currentIndex != startTokenId) revert();
1566             } else {
1567                 do {
1568                     emit Transfer(address(0), to, updatedIndex++);
1569                 } while (updatedIndex != end);
1570             }
1571             _currentIndex = updatedIndex;
1572         }
1573         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1574     }
1575 
1576     function _transfer(
1577         address from,
1578         address to,
1579         uint256 tokenId
1580     ) private {
1581         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1582 
1583         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1584 
1585         bool isApprovedOrOwner = (_msgSender() == from ||
1586             isApprovedForAll(from, _msgSender()) ||
1587             getApproved(tokenId) == _msgSender());
1588 
1589         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1590         if (to == address(0)) revert TransferToZeroAddress();
1591 
1592         _beforeTokenTransfers(from, to, tokenId, 1);
1593 
1594         // Clear approvals from the previous owner
1595         _approve(address(0), tokenId, from);
1596 
1597         // Underflow of the sender's balance is impossible because we check for
1598         // ownership above and the recipient's balance can't realistically overflow.
1599         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1600         unchecked {
1601             _addressData[from].balance -= 1;
1602             _addressData[to].balance += 1;
1603 
1604             TokenOwnership storage currSlot = _ownerships[tokenId];
1605             currSlot.addr = to;
1606             currSlot.startTimestamp = uint64(block.timestamp);
1607 
1608             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1609             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1610             uint256 nextTokenId = tokenId + 1;
1611             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1612             if (nextSlot.addr == address(0)) {
1613                 // This will suffice for checking _exists(nextTokenId),
1614                 // as a burned slot cannot contain the zero address.
1615                 if (nextTokenId != _currentIndex) {
1616                     nextSlot.addr = from;
1617                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1618                 }
1619             }
1620         }
1621 
1622         emit Transfer(from, to, tokenId);
1623         _afterTokenTransfers(from, to, tokenId, 1);
1624     }
1625 
1626     /**
1627      * @dev This is equivalent to _burn(tokenId, false)
1628      */
1629     function _burn(uint256 tokenId) internal virtual {
1630         _burn(tokenId, false);
1631     }
1632 
1633     /**
1634      * @dev Destroys `tokenId`.
1635      * The approval is cleared when the token is burned.
1636      *
1637      * Requirements:
1638      *
1639      * - `tokenId` must exist.
1640      *
1641      * Emits a {Transfer} event.
1642      */
1643     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1644         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1645 
1646         address from = prevOwnership.addr;
1647 
1648         if (approvalCheck) {
1649             bool isApprovedOrOwner = (_msgSender() == from ||
1650                 isApprovedForAll(from, _msgSender()) ||
1651                 getApproved(tokenId) == _msgSender());
1652 
1653             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1654         }
1655 
1656         _beforeTokenTransfers(from, address(0), tokenId, 1);
1657 
1658         // Clear approvals from the previous owner
1659         _approve(address(0), tokenId, from);
1660 
1661         // Underflow of the sender's balance is impossible because we check for
1662         // ownership above and the recipient's balance can't realistically overflow.
1663         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1664         unchecked {
1665             AddressData storage addressData = _addressData[from];
1666             addressData.balance -= 1;
1667             addressData.numberBurned += 1;
1668 
1669             // Keep track of who burned the token, and the timestamp of burning.
1670             TokenOwnership storage currSlot = _ownerships[tokenId];
1671             currSlot.addr = from;
1672             currSlot.startTimestamp = uint64(block.timestamp);
1673             currSlot.burned = true;
1674 
1675             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1676             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1677             uint256 nextTokenId = tokenId + 1;
1678             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1679             if (nextSlot.addr == address(0)) {
1680                 // This will suffice for checking _exists(nextTokenId),
1681                 // as a burned slot cannot contain the zero address.
1682                 if (nextTokenId != _currentIndex) {
1683                     nextSlot.addr = from;
1684                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1685                 }
1686             }
1687         }
1688 
1689         emit Transfer(from, address(0), tokenId);
1690         _afterTokenTransfers(from, address(0), tokenId, 1);
1691 
1692         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1693         unchecked {
1694             _burnCounter++;
1695         }
1696     }
1697 
1698     /**
1699      * @dev Approve `to` to operate on `tokenId`
1700      *
1701      * Emits a {Approval} event.
1702      */
1703     function _approve(
1704         address to,
1705         uint256 tokenId,
1706         address owner
1707     ) private {
1708         _tokenApprovals[tokenId] = to;
1709         emit Approval(owner, to, tokenId);
1710     }
1711 
1712     /**
1713      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1714      *
1715      * @param from address representing the previous owner of the given token ID
1716      * @param to target address that will receive the tokens
1717      * @param tokenId uint256 ID of the token to be transferred
1718      * @param _data bytes optional data to send along with the call
1719      * @return bool whether the call correctly returned the expected magic value
1720      */
1721     function _checkContractOnERC721Received(
1722         address from,
1723         address to,
1724         uint256 tokenId,
1725         bytes memory _data
1726     ) private returns (bool) {
1727         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1728             return retval == IERC721Receiver(to).onERC721Received.selector;
1729         } catch (bytes memory reason) {
1730             if (reason.length == 0) {
1731                 revert TransferToNonERC721ReceiverImplementer();
1732             } else {
1733                 assembly {
1734                     revert(add(32, reason), mload(reason))
1735                 }
1736             }
1737         }
1738     }
1739 
1740     function _beforeTokenTransfers(
1741         address from,
1742         address to,
1743         uint256 startTokenId,
1744         uint256 quantity
1745     ) internal virtual {}
1746 
1747     function _afterTokenTransfers(
1748         address from,
1749         address to,
1750         uint256 startTokenId,
1751         uint256 quantity
1752     ) internal virtual {}
1753 }
1754 
1755 pragma solidity ^0.8.4;
1756 
1757 contract MoonTitans is ERC721A, Ownable {
1758     using Strings for uint256;
1759     string private baseURI;
1760     string public hiddenMetadataUri;
1761     uint256 public price = 0.005 ether;
1762     uint256 public maxPerTx = 10;
1763     uint256 public maxFreePerWallet = 1;
1764     uint256 public totalFree = 5000;
1765     uint256 public maxSupply = 5000;
1766     uint public nextId = 0;
1767     bool public mintEnabled = false;
1768     bool public revealed = true;
1769     mapping(address => uint256) private _mintedFreeAmount;
1770 
1771     constructor() ERC721A("Moon Titans", "TITAN") {
1772         setHiddenMetadataUri("https://api.moontitans.com/");
1773         setBaseURI("https://api.moontitans.com/");
1774     }
1775 
1776     function mint(uint256 count) external payable {
1777       uint256 cost = price;
1778       bool isFree =
1779       ((totalSupply() + count < totalFree + 1) &&
1780       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1781 
1782       if (isFree) {
1783       cost = 0;
1784      }
1785 
1786      else {
1787       require(msg.value >= count * price, "Please send the exact amount.");
1788       require(totalSupply() + count <= maxSupply, "No more Titans");
1789       require(mintEnabled, "Minting is not live yet");
1790       require(count <= maxPerTx, "Max per TX reached.");
1791      }
1792 
1793       if (isFree) {
1794          _mintedFreeAmount[msg.sender] += count;
1795       }
1796 
1797      _safeMint(msg.sender, count);
1798      nextId += count;
1799     }
1800 
1801     function _baseURI() internal view virtual override returns (string memory) {
1802         return baseURI;
1803     }
1804 
1805     function tokenURI(uint256 tokenId)
1806         public
1807         view
1808         virtual
1809         override
1810         returns (string memory)
1811     {
1812         require(
1813             _exists(tokenId),
1814             "ERC721Metadata: URI query for nonexistent token"
1815         );
1816 
1817         if (revealed == false) {
1818          return string(abi.encodePacked(hiddenMetadataUri));
1819         }
1820     
1821         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1822     }
1823 
1824     function setBaseURI(string memory uri) public onlyOwner {
1825         baseURI = uri;
1826     }
1827 
1828     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1829      hiddenMetadataUri = _hiddenMetadataUri;
1830     }
1831 
1832     function setFreeAmount(uint256 amount) external onlyOwner {
1833         totalFree = amount;
1834     }
1835 
1836     function setPrice(uint256 _newPrice) external onlyOwner {
1837         price = _newPrice;
1838     }
1839 
1840     function setRevealed() external onlyOwner {
1841      revealed = !revealed;
1842     }
1843 
1844     function flipSale() external onlyOwner {
1845         mintEnabled = !mintEnabled;
1846     }
1847 
1848     function getNextId() public view returns(uint){
1849      return nextId;
1850     }
1851 
1852     function _startTokenId() internal pure override returns (uint256) {
1853         return 1;
1854     }
1855 
1856     function withdraw() external onlyOwner {
1857         (bool success, ) = payable(msg.sender).call{
1858             value: address(this).balance
1859         }("");
1860         require(success, "Transfer failed.");
1861     }
1862 
1863     function FreeMintWL(address to, uint256 quantity)public onlyOwner{
1864     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1865     _safeMint(to, quantity);
1866   }
1867 }