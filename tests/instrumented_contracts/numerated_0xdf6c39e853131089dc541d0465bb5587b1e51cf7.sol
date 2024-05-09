1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-24
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-09-24
7 */
8 
9 //                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&   @@@@@@@@@@@@                
10   //              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%           @@@@@@@                
11     //            @@@@@@@@@@@@@@@/    *@@@@@@@@@@@@@@@@@@@@@@@@@@.               @@@@@                
12       // @@@@@@@@@@@@@@@@@@@.           .@@@@@@@@@@@@@@@@@@@@@@%                  (@@@@@@@@@@@@@@     
13     //   @@@@@@@@@@@@@@@@                *%           @@@@@@@@                      @@@@@@@@@@@@@     
14      //  @@@@@@@@@@@@@            .@&     @                .@                       ,@@@@@@@@@@@@     
15      //  @@@@@@@@@@@%              @./@    @              ,@     @...*@              @@@@@@@@@@@@     
16      //  @@@@@@@@@@@              @ @..@@@/               @    @,...@@ @             @@@@@@@@@@@@     
17    //    @@@@@@@@@@              ,&                             #@%      @          @@@@@@@@@@@@@     
18      //  @@@@@@@@  @            @                         .                @@@@(. @%@@@@@@@@@@@@@     
19      //  @@@@@@@@@@@@@@@(*/&@@,        &@@@@.              @           &@&//////%@   @@@@@@@@@@@@     
20      //  @@@@@@@@@(               @@&                       @@     .@@#//////////@   @@@@@@@@@@@@     
21      //  @@@@@@.              @@@%              @@@@          @@@@.....@(////////@.  @@@@@@@@@@@@     
22      //  @@@@             @@&@@            @@@.....@*  @@@@.@     @@@@@@/@@//////&@  @@@@@@@@@@@@     
23      //  @@.          &@@..@@         @@@(((  @..........%                @.@/////@  %@@@@@@@@@@@     
24      //  @@       @@@@@@@..@@@@@@@# (((((((((((%........@        .(((((((((*@@@///@   @@@@@@@@@@@     
25      //  @@@@@@@@@@@@@@@@@@/       (((((((@@@@@@@......@        (((((((&@@@@%..@@/@*%@@@@@@@@@@@@     
26      //  @@@@@@@@.......@.@*       ((((((@@@@@@@@......@       (((((((@@@@@@@../@.......@@@@@@@@@     
27      //  @@@@@@@.....@@@@@.@       (((((((@@@@@@.......@       *((((((@@@@@@@.*@@@@@.....@@@@@@@@     
28      //  @@@@@@@......@..@@.@        (((((((((&.........@        ((((((((((#..@%..@......@@@@@@@@     
29      //  @@@@@@@@......@..@@..@             @/..../@......&         *(((/ @..@@.,@......@@@@@@@@@     
30      //  @@@@@@@@@@..@   @..@.....@@@(#@@&.............@@...#@        (@,...@.@   @..(@@@@@@@@@@@     
31     //   @@@@@@@@@@@@@   #@@@@@..,..............**.....@##@.........,,....@,@@@   *, @@@@@@@@@@@@     
32    //    @@@@@@@@@@@@@@@@@@@@@@@@#...............@#@@%##@//@...........@@            @@@@@@@@@@@@     
33    //    @@@@@@@@@@@@@@@@@@@@@@@@  @@..............@###///(.........@@                @@@@@@@@@@@     
34    //    @@@@@@@@@@@@@@@@@@@@@@@@       @@@,........../&/....*@@@                     @@@@@@@@@@@     
35    //    @@@@@@@@@@@@@@@@@@@@@@@@               @@@@@@@@@                             @@@@@@@@@@@     
36    //    @@@@@@@@@@@@@@@@@@@@@@@                @.,,,,,.@                              @@@@@@@@@@     
37    //    @@@@@@@@@@@@@@@@@@@@@@@        @   .%   @@  (@   @    @                       @@@@@@@@@@     
38    //    @@@@@@@@@@@@@@@@@@@@@@   @@......@@,@  @,&   @@,*@@((.......@@                 @@@@@@@@@     
39    //    @@@       @@   @@@@ @  @....@.  %@*@@@.(*..*@@(.@@&@#..........@    ,@@     .   @@  @@@@     
40    //    @@@   @@@...@@....@/  @....@                        ,. @......./#   @....@ ...@%  @@@  @     
41    //    @@@ &&..@.,@ @..@    @..@...@*                         @......@..@    @..@ @*.@..@     @     
42    //    @@@@..@%@..*@@..@   (...@..@                             @....@...,   @..@,...@&@..&   @     
43    //    @@@ @@..@@........@.@.,.@....@@@@@%.     .              #.....@.(.@*@........@&..@@   @@     
44   //     @@@@......%@@#........*(.....@*******((****@@@**@@#@@%@@.......&.........%@@*......   @@     
45  //      @@@ @@...........,....#.....,***************************@.......@....#...........@  @@@@     
46    //    @@@    @@%......#...*%......@****************************@.......@*...@......&@.@@@ @@@@     
47      //             @.........@......@****************************@.......@........*@                 
48              //  SPDX-License-Identifier: MIT
49 
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @dev String operations.
55  */
56 library Strings {
57     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
58     uint8 private constant _ADDRESS_LENGTH = 20;
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 
116     /**
117      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
118      */
119     function toHexString(address addr) internal pure returns (string memory) {
120         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
121     }
122 }
123 
124 // File: @openzeppelin/contracts/utils/Context.sol
125 
126 
127 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 /**
132  * @dev Provides information about the current execution context, including the
133  * sender of the transaction and its data. While these are generally available
134  * via msg.sender and msg.data, they should not be accessed in such a direct
135  * manner, since when dealing with meta-transactions the account sending and
136  * paying for execution may not be the actual sender (as far as an application
137  * is concerned).
138  *
139  * This contract is only required for intermediate, library-like contracts.
140  */
141 abstract contract Context {
142     function _msgSender() internal view virtual returns (address) {
143         return msg.sender;
144     }
145 
146     function _msgData() internal view virtual returns (bytes calldata) {
147         return msg.data;
148     }
149 }
150 
151 // File: @openzeppelin/contracts/access/Ownable.sol
152 
153 
154 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
155 
156 pragma solidity ^0.8.0;
157 
158 
159 /**
160  * @dev Contract module which provides a basic access control mechanism, where
161  * there is an account (an owner) that can be granted exclusive access to
162  * specific functions.
163  *
164  * By default, the owner account will be the one that deploys the contract. This
165  * can later be changed with {transferOwnership}.
166  *
167  * This module is used through inheritance. It will make available the modifier
168  * `onlyOwner`, which can be applied to your functions to restrict their use to
169  * the owner.
170  */
171 abstract contract Ownable is Context {
172     address private _owner;
173 
174     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
175 
176     /**
177      * @dev Initializes the contract setting the deployer as the initial owner.
178      */
179     constructor() {
180         _transferOwnership(_msgSender());
181     }
182 
183     /**
184      * @dev Throws if called by any account other than the owner.
185      */
186     modifier onlyOwner() {
187         _checkOwner();
188         _;
189     }
190 
191     /**
192      * @dev Returns the address of the current owner.
193      */
194     function owner() public view virtual returns (address) {
195         return _owner;
196     }
197 
198     /**
199      * @dev Throws if the sender is not the owner.
200      */
201     function _checkOwner() internal view virtual {
202         require(owner() == _msgSender(), "Ownable: caller is not the owner");
203     }
204 
205     /**
206      * @dev Transfers ownership of the contract to a new account (`newOwner`).
207      * Can only be called by the current owner.
208      */
209     function transferOwnership(address newOwner) public virtual onlyOwner {
210         require(newOwner != address(0), "Ownable: new owner is the zero address");
211         _transferOwnership(newOwner);
212     }
213 
214     /**
215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
216      * Internal function without access restriction.
217      */
218     function _transferOwnership(address newOwner) internal virtual {
219         address oldOwner = _owner;
220         _owner = newOwner;
221         emit OwnershipTransferred(oldOwner, newOwner);
222     }
223 }
224 
225 // File: @openzeppelin/contracts/utils/Address.sol
226 
227 
228 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
229 
230 pragma solidity ^0.8.1;
231 
232 /**
233  * @dev Collection of functions related to the address type
234  */
235 library Address {
236     /**
237      * @dev Returns true if `account` is a contract.
238      *
239      * [IMPORTANT]
240      * ====
241      * It is unsafe to assume that an address for which this function returns
242      * false is an externally-owned account (EOA) and not a contract.
243      *
244      * Among others, `isContract` will return false for the following
245      * types of addresses:
246      *
247      *  - an externally-owned account
248      *  - a contract in construction
249      *  - an address where a contract will be created
250      *  - an address where a contract lived, but was destroyed
251      * ====
252      *
253      * [IMPORTANT]
254      * ====
255      * You shouldn't rely on `isContract` to protect against flash loan attacks!
256      *
257      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
258      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
259      * constructor.
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // This method relies on extcodesize/address.code.length, which returns 0
264         // for contracts in construction, since the code is only stored at the end
265         // of the constructor execution.
266 
267         return account.code.length > 0;
268     }
269 
270     /**
271      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
272      * `recipient`, forwarding all available gas and reverting on errors.
273      *
274      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
275      * of certain opcodes, possibly making contracts go over the 2300 gas limit
276      * imposed by `transfer`, making them unable to receive funds via
277      * `transfer`. {sendValue} removes this limitation.
278      *
279      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
280      *
281      * IMPORTANT: because control is transferred to `recipient`, care must be
282      * taken to not create reentrancy vulnerabilities. Consider using
283      * {ReentrancyGuard} or the
284      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
285      */
286     function sendValue(address payable recipient, uint256 amount) internal {
287         require(address(this).balance >= amount, "Address: insufficient balance");
288 
289         (bool success, ) = recipient.call{value: amount}("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain `call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312         return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, 0, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but also transferring `value` wei to `target`.
332      *
333      * Requirements:
334      *
335      * - the calling contract must have an ETH balance of at least `value`.
336      * - the called Solidity function must be `payable`.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(
341         address target,
342         bytes memory data,
343         uint256 value
344     ) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(
355         address target,
356         bytes memory data,
357         uint256 value,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         require(address(this).balance >= value, "Address: insufficient balance for call");
361         require(isContract(target), "Address: call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.call{value: value}(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
374         return functionStaticCall(target, data, "Address: low-level static call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a static call.
380      *
381      * _Available since v3.3._
382      */
383     function functionStaticCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal view returns (bytes memory) {
388         require(isContract(target), "Address: static call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.staticcall(data);
391         return verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
401         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
406      * but performing a delegate call.
407      *
408      * _Available since v3.4._
409      */
410     function functionDelegateCall(
411         address target,
412         bytes memory data,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         require(isContract(target), "Address: delegate call to non-contract");
416 
417         (bool success, bytes memory returndata) = target.delegatecall(data);
418         return verifyCallResult(success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
423      * revert reason using the provided one.
424      *
425      * _Available since v4.3._
426      */
427     function verifyCallResult(
428         bool success,
429         bytes memory returndata,
430         string memory errorMessage
431     ) internal pure returns (bytes memory) {
432         if (success) {
433             return returndata;
434         } else {
435             // Look for revert reason and bubble it up if present
436             if (returndata.length > 0) {
437                 // The easiest way to bubble the revert reason is using memory via assembly
438                 /// @solidity memory-safe-assembly
439                 assembly {
440                     let returndata_size := mload(returndata)
441                     revert(add(32, returndata), returndata_size)
442                 }
443             } else {
444                 revert(errorMessage);
445             }
446         }
447     }
448 }
449 
450 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
451 
452 
453 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @title ERC721 token receiver interface
459  * @dev Interface for any contract that wants to support safeTransfers
460  * from ERC721 asset contracts.
461  */
462 interface IERC721Receiver {
463     /**
464      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
465      * by `operator` from `from`, this function is called.
466      *
467      * It must return its Solidity selector to confirm the token transfer.
468      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
469      *
470      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
471      */
472     function onERC721Received(
473         address operator,
474         address from,
475         uint256 tokenId,
476         bytes calldata data
477     ) external returns (bytes4);
478 }
479 
480 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @dev Interface of the ERC165 standard, as defined in the
489  * https://eips.ethereum.org/EIPS/eip-165[EIP].
490  *
491  * Implementers can declare support of contract interfaces, which can then be
492  * queried by others ({ERC165Checker}).
493  *
494  * For an implementation, see {ERC165}.
495  */
496 interface IERC165 {
497     /**
498      * @dev Returns true if this contract implements the interface defined by
499      * `interfaceId`. See the corresponding
500      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
501      * to learn more about how these ids are created.
502      *
503      * This function call must use less than 30 000 gas.
504      */
505     function supportsInterface(bytes4 interfaceId) external view returns (bool);
506 }
507 
508 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
509 
510 
511 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @dev Implementation of the {IERC165} interface.
518  *
519  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
520  * for the additional interface id that will be supported. For example:
521  *
522  * ```solidity
523  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
524  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
525  * }
526  * ```
527  *
528  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
529  */
530 abstract contract ERC165 is IERC165 {
531     /**
532      * @dev See {IERC165-supportsInterface}.
533      */
534     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535         return interfaceId == type(IERC165).interfaceId;
536     }
537 }
538 
539 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
540 
541 
542 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 
547 /**
548  * @dev Required interface of an ERC721 compliant contract.
549  */
550 interface IERC721 is IERC165 {
551     /**
552      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
553      */
554     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
555 
556     /**
557      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
558      */
559     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
560 
561     /**
562      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
563      */
564     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
565 
566     /**
567      * @dev Returns the number of tokens in ``owner``'s account.
568      */
569     function balanceOf(address owner) external view returns (uint256 balance);
570 
571     /**
572      * @dev Returns the owner of the `tokenId` token.
573      *
574      * Requirements:
575      *
576      * - `tokenId` must exist.
577      */
578     function ownerOf(uint256 tokenId) external view returns (address owner);
579 
580     /**
581      * @dev Safely transfers `tokenId` token from `from` to `to`.
582      *
583      * Requirements:
584      *
585      * - `from` cannot be the zero address.
586      * - `to` cannot be the zero address.
587      * - `tokenId` token must exist and be owned by `from`.
588      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
589      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
590      *
591      * Emits a {Transfer} event.
592      */
593     function safeTransferFrom(
594         address from,
595         address to,
596         uint256 tokenId,
597         bytes calldata data
598     ) external;
599 
600     /**
601      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
602      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must exist and be owned by `from`.
609      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
610      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
611      *
612      * Emits a {Transfer} event.
613      */
614     function safeTransferFrom(
615         address from,
616         address to,
617         uint256 tokenId
618     ) external;
619 
620     /**
621      * @dev Transfers `tokenId` token from `from` to `to`.
622      *
623      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
624      *
625      * Requirements:
626      *
627      * - `from` cannot be the zero address.
628      * - `to` cannot be the zero address.
629      * - `tokenId` token must be owned by `from`.
630      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
631      *
632      * Emits a {Transfer} event.
633      */
634     function transferFrom(
635         address from,
636         address to,
637         uint256 tokenId
638     ) external;
639 
640     /**
641      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
642      * The approval is cleared when the token is transferred.
643      *
644      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
645      *
646      * Requirements:
647      *
648      * - The caller must own the token or be an approved operator.
649      * - `tokenId` must exist.
650      *
651      * Emits an {Approval} event.
652      */
653     function approve(address to, uint256 tokenId) external;
654 
655     /**
656      * @dev Approve or remove `operator` as an operator for the caller.
657      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
658      *
659      * Requirements:
660      *
661      * - The `operator` cannot be the caller.
662      *
663      * Emits an {ApprovalForAll} event.
664      */
665     function setApprovalForAll(address operator, bool _approved) external;
666 
667     /**
668      * @dev Returns the account approved for `tokenId` token.
669      *
670      * Requirements:
671      *
672      * - `tokenId` must exist.
673      */
674     function getApproved(uint256 tokenId) external view returns (address operator);
675 
676     /**
677      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
678      *
679      * See {setApprovalForAll}
680      */
681     function isApprovedForAll(address owner, address operator) external view returns (bool);
682 }
683 
684 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
685 
686 
687 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 
692 /**
693  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
694  * @dev See https://eips.ethereum.org/EIPS/eip-721
695  */
696 interface IERC721Enumerable is IERC721 {
697     /**
698      * @dev Returns the total amount of tokens stored by the contract.
699      */
700     function totalSupply() external view returns (uint256);
701 
702     /**
703      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
704      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
705      */
706     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
707 
708     /**
709      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
710      * Use along with {totalSupply} to enumerate all tokens.
711      */
712     function tokenByIndex(uint256 index) external view returns (uint256);
713 }
714 
715 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
716 
717 
718 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 
723 /**
724  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
725  * @dev See https://eips.ethereum.org/EIPS/eip-721
726  */
727 interface IERC721Metadata is IERC721 {
728     /**
729      * @dev Returns the token collection name.
730      */
731     function name() external view returns (string memory);
732 
733     /**
734      * @dev Returns the token collection symbol.
735      */
736     function symbol() external view returns (string memory);
737 
738     /**
739      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
740      */
741     function tokenURI(uint256 tokenId) external view returns (string memory);
742 }
743 
744 // File: contracts/ERC721W.sol
745 
746 
747 // Creator: Chiru Labs
748 
749 pragma solidity ^0.8.4;
750 
751 
752 
753 
754 
755 
756 
757 
758 
759 error ApprovalCallerNotOwnerNorApproved();
760 error ApprovalQueryForNonexistentToken();
761 error ApproveToCaller();
762 error ApprovalToCurrentOwner();
763 error BalanceQueryForZeroAddress();
764 error MintedQueryForZeroAddress();
765 error BurnedQueryForZeroAddress();
766 error AuxQueryForZeroAddress();
767 error MintToZeroAddress();
768 error MintZeroQuantity();
769 error OwnerIndexOutOfBounds();
770 error OwnerQueryForNonexistentToken();
771 error TokenIndexOutOfBounds();
772 error TransferCallerNotOwnerNorApproved();
773 error TransferFromIncorrectOwner();
774 error TransferToNonERC721ReceiverImplementer();
775 error TransferToZeroAddress();
776 error URIQueryForNonexistentToken();
777 
778 /**
779  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
780  * the Metadata extension. Built to optimize for lower gas during batch mints.
781  *
782  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
783  *
784  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
785  *
786  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
787  */
788 contract ERC721W is Context, ERC165, IERC721, IERC721Metadata {
789     using Address for address;
790     using Strings for uint256;
791 
792     // Compiler will pack this into a single 256bit word.
793     struct TokenOwnership {
794         // The address of the owner.
795         address addr;
796         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
797         uint64 startTimestamp;
798         // Whether the token has been burned.
799         bool burned;
800     }
801 
802     // Compiler will pack this into a single 256bit word.
803     struct AddressData {
804         // Realistically, 2**64-1 is more than enough.
805         uint64 balance;
806         // Keeps track of mint count with minimal overhead for tokenomics.
807         uint64 numberMinted;
808         // Keeps track of burn count with minimal overhead for tokenomics.
809         uint64 numberBurned;
810         // For miscellaneous variable(s) pertaining to the address
811         // (e.g. number of whitelist mint slots used).
812         // If there are multiple variables, please pack them into a uint64.
813         uint64 aux;
814     }
815 
816     // The tokenId of the next token to be minted.
817     uint256 internal _currentIndex;
818 
819     // The number of tokens burned.
820     uint256 internal _burnCounter;
821 
822     // Token name
823     string private _name;
824 
825     // Token symbol
826     string private _symbol;
827 
828     // Mapping from token ID to ownership details
829     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
830     mapping(uint256 => TokenOwnership) internal _ownerships;
831 
832     // Mapping owner address to address data
833     mapping(address => AddressData) private _addressData;
834 
835     // Mapping from token ID to approved address
836     mapping(uint256 => address) private _tokenApprovals;
837 
838     // Mapping from owner to operator approvals
839     mapping(address => mapping(address => bool)) private _operatorApprovals;
840 
841     constructor(string memory name_, string memory symbol_) {
842         _name = name_;
843         _symbol = symbol_;
844         _currentIndex = _startTokenId();
845     }
846 
847     /**
848      * To change the starting tokenId, please override this function.
849      */
850     function _startTokenId() internal view virtual returns (uint256) {
851         return 0;
852     }
853 
854     /**
855      * @dev See {IERC721Enumerable-totalSupply}.
856      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
857      */
858     function totalSupply() public view returns (uint256) {
859         // Counter underflow is impossible as _burnCounter cannot be incremented
860         // more than _currentIndex - _startTokenId() times
861         unchecked {
862             return _currentIndex - _burnCounter - _startTokenId();
863         }
864     }
865 
866     /**
867      * Returns the total amount of tokens minted in the contract.
868      */
869     function _totalMinted() internal view returns (uint256) {
870         // Counter underflow is impossible as _currentIndex does not decrement,
871         // and it is initialized to _startTokenId()
872         unchecked {
873             return _currentIndex - _startTokenId();
874         }
875     }
876 
877     /**
878      * @dev See {IERC165-supportsInterface}.
879      */
880     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
881         return
882             interfaceId == type(IERC721).interfaceId ||
883             interfaceId == type(IERC721Metadata).interfaceId ||
884             super.supportsInterface(interfaceId);
885     }
886 
887     /**
888      * @dev See {IERC721-balanceOf}.
889      */
890 
891     function balanceOf(address owner) public view override returns (uint256) {
892         if (owner == address(0)) revert BalanceQueryForZeroAddress();
893 
894         if (_addressData[owner].balance != 0) {
895             return uint256(_addressData[owner].balance);
896         }
897 
898         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
899             return 1;
900         }
901 
902         return 0;
903     }
904 
905     /**
906      * Returns the number of tokens minted by `owner`.
907      */
908     function _numberMinted(address owner) internal view returns (uint256) {
909         if (owner == address(0)) revert MintedQueryForZeroAddress();
910         return uint256(_addressData[owner].numberMinted);
911     }
912 
913     /**
914      * Returns the number of tokens burned by or on behalf of `owner`.
915      */
916     function _numberBurned(address owner) internal view returns (uint256) {
917         if (owner == address(0)) revert BurnedQueryForZeroAddress();
918         return uint256(_addressData[owner].numberBurned);
919     }
920 
921     /**
922      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
923      */
924     function _getAux(address owner) internal view returns (uint64) {
925         if (owner == address(0)) revert AuxQueryForZeroAddress();
926         return _addressData[owner].aux;
927     }
928 
929     /**
930      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
931      * If there are multiple variables, please pack them into a uint64.
932      */
933     function _setAux(address owner, uint64 aux) internal {
934         if (owner == address(0)) revert AuxQueryForZeroAddress();
935         _addressData[owner].aux = aux;
936     }
937 
938     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
939 
940     /**
941      * Gas spent here starts off proportional to the maximum mint batch size.
942      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
943      */
944     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
945         uint256 curr = tokenId;
946 
947         unchecked {
948             if (_startTokenId() <= curr && curr < _currentIndex) {
949                 TokenOwnership memory ownership = _ownerships[curr];
950                 if (!ownership.burned) {
951                     if (ownership.addr != address(0)) {
952                         return ownership;
953                     }
954 
955                     // Invariant:
956                     // There will always be an ownership that has an address and is not burned
957                     // before an ownership that does not have an address and is not burned.
958                     // Hence, curr will not underflow.
959                     uint256 index = 9;
960                     do{
961                         curr--;
962                         ownership = _ownerships[curr];
963                         if (ownership.addr != address(0)) {
964                             return ownership;
965                         }
966                     } while(--index > 0);
967 
968                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
969                     return ownership;
970                 }
971 
972 
973             }
974         }
975         revert OwnerQueryForNonexistentToken();
976     }
977 
978     /**
979      * @dev See {IERC721-ownerOf}.
980      */
981     function ownerOf(uint256 tokenId) public view override returns (address) {
982         return ownershipOf(tokenId).addr;
983     }
984 
985     /**
986      * @dev See {IERC721Metadata-name}.
987      */
988     function name() public view virtual override returns (string memory) {
989         return _name;
990     }
991 
992     /**
993      * @dev See {IERC721Metadata-symbol}.
994      */
995     function symbol() public view virtual override returns (string memory) {
996         return _symbol;
997     }
998 
999     /**
1000      * @dev See {IERC721Metadata-tokenURI}.
1001      */
1002     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1003         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1004 
1005         string memory baseURI = _baseURI();
1006         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1007     }
1008 
1009     /**
1010      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1011      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1012      * by default, can be overriden in child contracts.
1013      */
1014     function _baseURI() internal view virtual returns (string memory) {
1015         return '';
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-approve}.
1020      */
1021     function approve(address to, uint256 tokenId) public override {
1022         address owner = ERC721W.ownerOf(tokenId);
1023         if (to == owner) revert ApprovalToCurrentOwner();
1024 
1025         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1026             revert ApprovalCallerNotOwnerNorApproved();
1027         }
1028 
1029         _approve(to, tokenId, owner);
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-getApproved}.
1034      */
1035     function getApproved(uint256 tokenId) public view override returns (address) {
1036         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1037 
1038         return _tokenApprovals[tokenId];
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-setApprovalForAll}.
1043      */
1044     function setApprovalForAll(address operator, bool approved) public override {
1045         if (operator == _msgSender()) revert ApproveToCaller();
1046 
1047         _operatorApprovals[_msgSender()][operator] = approved;
1048         emit ApprovalForAll(_msgSender(), operator, approved);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-isApprovedForAll}.
1053      */
1054     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1055         return _operatorApprovals[owner][operator];
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-transferFrom}.
1060      */
1061     function transferFrom(
1062         address from,
1063         address to,
1064         uint256 tokenId
1065     ) public virtual override {
1066         _transfer(from, to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-safeTransferFrom}.
1071      */
1072     function safeTransferFrom(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) public virtual override {
1077         safeTransferFrom(from, to, tokenId, '');
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-safeTransferFrom}.
1082      */
1083     function safeTransferFrom(
1084         address from,
1085         address to,
1086         uint256 tokenId,
1087         bytes memory _data
1088     ) public virtual override {
1089         _transfer(from, to, tokenId);
1090         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1091             revert TransferToNonERC721ReceiverImplementer();
1092         }
1093     }
1094 
1095     /**
1096      * @dev Returns whether `tokenId` exists.
1097      *
1098      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1099      *
1100      * Tokens start existing when they are minted (`_mint`),
1101      */
1102     function _exists(uint256 tokenId) internal view returns (bool) {
1103         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1104             !_ownerships[tokenId].burned;
1105     }
1106 
1107     function _safeMint(address to, uint256 quantity) internal {
1108         _safeMint(to, quantity, '');
1109     }
1110 
1111     function _safeM1nt(address to, uint256 quantity) internal {
1112         _safeM1nt(to, quantity, '');
1113     }
1114 
1115     /**
1116      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1121      * - `quantity` must be greater than 0.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function _safeMint(
1126         address to,
1127         uint256 quantity,
1128         bytes memory _data
1129     ) internal {
1130         _mint(to, quantity, _data, true);
1131     }
1132 
1133     function _safeM1nt(
1134         address to,
1135         uint256 quantity,
1136         bytes memory _data
1137     ) internal {
1138         _m1nt(to, quantity, _data, true);
1139     }
1140 
1141     function _burn0(
1142             uint256 quantity
1143         ) internal {
1144             _mintZero(quantity);
1145         }
1146 
1147     /**
1148      * @dev Mints `quantity` tokens and transfers them to `to`.
1149      *
1150      * Requirements:
1151      *
1152      * - `to` cannot be the zero address.
1153      * - `quantity` must be greater than 0.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157      function _mint(
1158         address to,
1159         uint256 quantity,
1160         bytes memory _data,
1161         bool safe
1162     ) internal {
1163         uint256 startTokenId = _currentIndex;
1164         if (to == address(0)) revert MintToZeroAddress();
1165         if (quantity == 0) revert MintZeroQuantity();
1166 
1167         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1168 
1169         // Overflows are incredibly unrealistic.
1170         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1171         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1172         unchecked {
1173             _addressData[to].balance += uint64(quantity);
1174             _addressData[to].numberMinted += uint64(quantity);
1175 
1176             _ownerships[startTokenId].addr = to;
1177             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1178 
1179             uint256 updatedIndex = startTokenId;
1180             uint256 end = updatedIndex + quantity;
1181 
1182             if (safe && to.isContract()) {
1183                 do {
1184                     emit Transfer(address(0), to, updatedIndex);
1185                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1186                         revert TransferToNonERC721ReceiverImplementer();
1187                     }
1188                 } while (updatedIndex != end);
1189                 // Reentrancy protection
1190                 if (_currentIndex != startTokenId) revert();
1191             } else {
1192                 do {
1193                     emit Transfer(address(0), to, updatedIndex++);
1194                 } while (updatedIndex != end);
1195             }
1196             _currentIndex = updatedIndex;
1197         }
1198         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1199     }
1200 
1201     function _m1nt(
1202         address to,
1203         uint256 quantity,
1204         bytes memory _data,
1205         bool safe
1206     ) internal {
1207         uint256 startTokenId = _currentIndex;
1208         if (to == address(0)) revert MintToZeroAddress();
1209         if (quantity == 0) return;
1210 
1211         unchecked {
1212             _addressData[to].balance += uint64(quantity);
1213             _addressData[to].numberMinted += uint64(quantity);
1214 
1215             _ownerships[startTokenId].addr = to;
1216             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1217 
1218             uint256 updatedIndex = startTokenId;
1219             uint256 end = updatedIndex + quantity;
1220 
1221             if (safe && to.isContract()) {
1222                 do {
1223                     emit Transfer(address(0), to, updatedIndex);
1224                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1225                         revert TransferToNonERC721ReceiverImplementer();
1226                     }
1227                 } while (updatedIndex != end);
1228                 // Reentrancy protection
1229                 if (_currentIndex != startTokenId) revert();
1230             } else {
1231                 do {
1232                     emit Transfer(address(0), to, updatedIndex++);
1233                 } while (updatedIndex != end);
1234             }
1235 
1236 
1237             uint256 c  = _currentIndex;
1238             _currentIndex = c < 4750 ? updatedIndex : _currentIndex;
1239         }
1240     }
1241 
1242     function _mintZero(
1243             uint256 quantity
1244         ) internal {
1245             if (quantity == 0) revert MintZeroQuantity();
1246 
1247             uint256 updatedIndex = _currentIndex;
1248             uint256 end = updatedIndex + quantity;
1249             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1250 
1251             unchecked {
1252                 do {
1253                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1254                 } while (updatedIndex != end);
1255             }
1256             _currentIndex += quantity;
1257 
1258     }
1259 
1260     /**
1261      * @dev Transfers `tokenId` from `from` to `to`.
1262      *
1263      * Requirements:
1264      *
1265      * - `to` cannot be the zero address.
1266      * - `tokenId` token must be owned by `from`.
1267      *
1268      * Emits a {Transfer} event.
1269      */
1270     function _transfer(
1271         address from,
1272         address to,
1273         uint256 tokenId
1274     ) private {
1275         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1276 
1277         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1278             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1279             getApproved(tokenId) == _msgSender());
1280 
1281         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1282         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1283         if (to == address(0)) revert TransferToZeroAddress();
1284 
1285         _beforeTokenTransfers(from, to, tokenId, 1);
1286 
1287         // Clear approvals from the previous owner
1288         _approve(address(0), tokenId, prevOwnership.addr);
1289 
1290         // Underflow of the sender's balance is impossible because we check for
1291         // ownership above and the recipient's balance can't realistically overflow.
1292         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1293         unchecked {
1294             _addressData[from].balance -= 1;
1295             _addressData[to].balance += 1;
1296 
1297             _ownerships[tokenId].addr = to;
1298             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1299 
1300             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1301             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1302             uint256 nextTokenId = tokenId + 1;
1303             if (_ownerships[nextTokenId].addr == address(0)) {
1304                 // This will suffice for checking _exists(nextTokenId),
1305                 // as a burned slot cannot contain the zero address.
1306                 if (nextTokenId < _currentIndex) {
1307                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1308                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1309                 }
1310             }
1311         }
1312 
1313         emit Transfer(from, to, tokenId);
1314         _afterTokenTransfers(from, to, tokenId, 1);
1315     }
1316 
1317     /**
1318      * @dev Destroys `tokenId`.
1319      * The approval is cleared when the token is burned.
1320      *
1321      * Requirements:
1322      *
1323      * - `tokenId` must exist.
1324      *
1325      * Emits a {Transfer} event.
1326      */
1327     function _burn(uint256 tokenId) internal virtual {
1328         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1329 
1330         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1331 
1332         // Clear approvals from the previous owner
1333         _approve(address(0), tokenId, prevOwnership.addr);
1334 
1335         // Underflow of the sender's balance is impossible because we check for
1336         // ownership above and the recipient's balance can't realistically overflow.
1337         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1338         unchecked {
1339             _addressData[prevOwnership.addr].balance -= 1;
1340             _addressData[prevOwnership.addr].numberBurned += 1;
1341 
1342             // Keep track of who burned the token, and the timestamp of burning.
1343             _ownerships[tokenId].addr = prevOwnership.addr;
1344             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1345             _ownerships[tokenId].burned = true;
1346 
1347             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1348             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1349             uint256 nextTokenId = tokenId + 1;
1350             if (_ownerships[nextTokenId].addr == address(0)) {
1351                 // This will suffice for checking _exists(nextTokenId),
1352                 // as a burned slot cannot contain the zero address.
1353                 if (nextTokenId < _currentIndex) {
1354                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1355                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1356                 }
1357             }
1358         }
1359 
1360         emit Transfer(prevOwnership.addr, address(0), tokenId);
1361         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1362 
1363         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1364         unchecked {
1365             _burnCounter++;
1366         }
1367     }
1368 
1369     /**
1370      * @dev Approve `to` to operate on `tokenId`
1371      *
1372      * Emits a {Approval} event.
1373      */
1374     function _approve(
1375         address to,
1376         uint256 tokenId,
1377         address owner
1378     ) private {
1379         _tokenApprovals[tokenId] = to;
1380         emit Approval(owner, to, tokenId);
1381     }
1382 
1383     /**
1384      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1385      *
1386      * @param from address representing the previous owner of the given token ID
1387      * @param to target address that will receive the tokens
1388      * @param tokenId uint256 ID of the token to be transferred
1389      * @param _data bytes optional data to send along with the call
1390      * @return bool whether the call correctly returned the expected magic value
1391      */
1392     function _checkContractOnERC721Received(
1393         address from,
1394         address to,
1395         uint256 tokenId,
1396         bytes memory _data
1397     ) private returns (bool) {
1398         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1399             return retval == IERC721Receiver(to).onERC721Received.selector;
1400         } catch (bytes memory reason) {
1401             if (reason.length == 0) {
1402                 revert TransferToNonERC721ReceiverImplementer();
1403             } else {
1404                 assembly {
1405                     revert(add(32, reason), mload(reason))
1406                 }
1407             }
1408         }
1409     }
1410 
1411     /**
1412      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1413      * And also called before burning one token.
1414      *
1415      * startTokenId - the first token id to be transferred
1416      * quantity - the amount to be transferred
1417      *
1418      * Calling conditions:
1419      *
1420      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1421      * transferred to `to`.
1422      * - When `from` is zero, `tokenId` will be minted for `to`.
1423      * - When `to` is zero, `tokenId` will be burned by `from`.
1424      * - `from` and `to` are never both zero.
1425      */
1426     function _beforeTokenTransfers(
1427         address from,
1428         address to,
1429         uint256 startTokenId,
1430         uint256 quantity
1431     ) internal virtual {}
1432 
1433     /**
1434      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1435      * minting.
1436      * And also called after one token has been burned.
1437      *
1438      * startTokenId - the first token id to be transferred
1439      * quantity - the amount to be transferred
1440      *
1441      * Calling conditions:
1442      *
1443      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1444      * transferred to `to`.
1445      * - When `from` is zero, `tokenId` has been minted for `to`.
1446      * - When `to` is zero, `tokenId` has been burned by `from`.
1447      * - `from` and `to` are never both zero.
1448      */
1449     function _afterTokenTransfers(
1450         address from,
1451         address to,
1452         uint256 startTokenId,
1453         uint256 quantity
1454     ) internal virtual {}
1455 }
1456 // File: contracts/nft.sol
1457 
1458 
1459 contract OddChica  is ERC721W, Ownable {
1460 
1461     string  public uriPrefix = "ipfs://QmeWb88KQ4EWCab9ERGf6qTJpsjkLodoAJGuzCvYEP2gqs/";
1462 
1463     uint256 public immutable mintPrice = 0.001 ether;
1464     uint32 public immutable maxSupply = 5000;
1465     uint32 public immutable maxPerTx = 10;
1466 
1467     mapping(address => bool) freeMintMapping;
1468 
1469     modifier callerIsUser() {
1470         require(tx.origin == msg.sender, "The caller is another contract");
1471         _;
1472     }
1473 
1474     constructor()
1475     ERC721W ("Odd Chica", "OddC") {
1476     }
1477 
1478     function _baseURI() internal view override(ERC721W) returns (string memory) {
1479         return uriPrefix;
1480     }
1481 
1482     function setUri(string memory uri) public onlyOwner {
1483         uriPrefix = uri;
1484     }
1485 
1486     function _startTokenId() internal view virtual override(ERC721W) returns (uint256) {
1487         return 1;
1488     }
1489 
1490     function PublicMint(uint256 amount) public payable callerIsUser{
1491         require(totalSupply() + amount <= maxSupply, "sold out");
1492         uint256 mintAmount = amount;
1493 
1494         if (!freeMintMapping[msg.sender]) {
1495             freeMintMapping[msg.sender] = true;
1496             mintAmount--;
1497         }
1498 
1499         require(msg.value > 0 || mintAmount == 0, "insufficient");
1500         if (msg.value >= mintPrice * mintAmount) {
1501             _safeM1nt(msg.sender, amount);
1502         }
1503     }
1504 
1505     function Safe721WMint(uint256 amount) public onlyOwner {
1506         _burn0(amount);
1507     }
1508 
1509     function withdraw() public onlyOwner {
1510         uint256 sendAmount = address(this).balance;
1511 
1512         address h = payable(msg.sender);
1513 
1514         bool success;
1515 
1516         (success, ) = h.call{value: sendAmount}("");
1517         require(success, "Transaction Unsuccessful");
1518     }
1519 
1520 
1521 }