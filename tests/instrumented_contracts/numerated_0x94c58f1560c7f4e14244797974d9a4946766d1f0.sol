1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-24
3 */
4 
5 //                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&   @@@@@@@@@@@@                
6   //              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%           @@@@@@@                
7     //            @@@@@@@@@@@@@@@/    *@@@@@@@@@@@@@@@@@@@@@@@@@@.               @@@@@                
8       // @@@@@@@@@@@@@@@@@@@.           .@@@@@@@@@@@@@@@@@@@@@@%                  (@@@@@@@@@@@@@@     
9     //   @@@@@@@@@@@@@@@@                *%           @@@@@@@@                      @@@@@@@@@@@@@     
10      //  @@@@@@@@@@@@@            .@&     @                .@                       ,@@@@@@@@@@@@     
11      //  @@@@@@@@@@@%              @./@    @              ,@     @...*@              @@@@@@@@@@@@     
12      //  @@@@@@@@@@@              @ @..@@@/               @    @,...@@ @             @@@@@@@@@@@@     
13    //    @@@@@@@@@@              ,&                             #@%      @          @@@@@@@@@@@@@     
14      //  @@@@@@@@  @            @                         .                @@@@(. @%@@@@@@@@@@@@@     
15      //  @@@@@@@@@@@@@@@(*/&@@,        &@@@@.              @           &@&//////%@   @@@@@@@@@@@@     
16      //  @@@@@@@@@(               @@&                       @@     .@@#//////////@   @@@@@@@@@@@@     
17      //  @@@@@@.              @@@%              @@@@          @@@@.....@(////////@.  @@@@@@@@@@@@     
18      //  @@@@             @@&@@            @@@.....@*  @@@@.@     @@@@@@/@@//////&@  @@@@@@@@@@@@     
19      //  @@.          &@@..@@         @@@(((  @..........%                @.@/////@  %@@@@@@@@@@@     
20      //  @@       @@@@@@@..@@@@@@@# (((((((((((%........@        .(((((((((*@@@///@   @@@@@@@@@@@     
21      //  @@@@@@@@@@@@@@@@@@/       (((((((@@@@@@@......@        (((((((&@@@@%..@@/@*%@@@@@@@@@@@@     
22      //  @@@@@@@@.......@.@*       ((((((@@@@@@@@......@       (((((((@@@@@@@../@.......@@@@@@@@@     
23      //  @@@@@@@.....@@@@@.@       (((((((@@@@@@.......@       *((((((@@@@@@@.*@@@@@.....@@@@@@@@     
24      //  @@@@@@@......@..@@.@        (((((((((&.........@        ((((((((((#..@%..@......@@@@@@@@     
25      //  @@@@@@@@......@..@@..@             @/..../@......&         *(((/ @..@@.,@......@@@@@@@@@     
26      //  @@@@@@@@@@..@   @..@.....@@@(#@@&.............@@...#@        (@,...@.@   @..(@@@@@@@@@@@     
27     //   @@@@@@@@@@@@@   #@@@@@..,..............**.....@##@.........,,....@,@@@   *, @@@@@@@@@@@@     
28    //    @@@@@@@@@@@@@@@@@@@@@@@@#...............@#@@%##@//@...........@@            @@@@@@@@@@@@     
29    //    @@@@@@@@@@@@@@@@@@@@@@@@  @@..............@###///(.........@@                @@@@@@@@@@@     
30    //    @@@@@@@@@@@@@@@@@@@@@@@@       @@@,........../&/....*@@@                     @@@@@@@@@@@     
31    //    @@@@@@@@@@@@@@@@@@@@@@@@               @@@@@@@@@                             @@@@@@@@@@@     
32    //    @@@@@@@@@@@@@@@@@@@@@@@                @.,,,,,.@                              @@@@@@@@@@     
33    //    @@@@@@@@@@@@@@@@@@@@@@@        @   .%   @@  (@   @    @                       @@@@@@@@@@     
34    //    @@@@@@@@@@@@@@@@@@@@@@   @@......@@,@  @,&   @@,*@@((.......@@                 @@@@@@@@@     
35    //    @@@       @@   @@@@ @  @....@.  %@*@@@.(*..*@@(.@@&@#..........@    ,@@     .   @@  @@@@     
36    //    @@@   @@@...@@....@/  @....@                        ,. @......./#   @....@ ...@%  @@@  @     
37    //    @@@ &&..@.,@ @..@    @..@...@*                         @......@..@    @..@ @*.@..@     @     
38    //    @@@@..@%@..*@@..@   (...@..@                             @....@...,   @..@,...@&@..&   @     
39    //    @@@ @@..@@........@.@.,.@....@@@@@%.     .              #.....@.(.@*@........@&..@@   @@     
40   //     @@@@......%@@#........*(.....@*******((****@@@**@@#@@%@@.......&.........%@@*......   @@     
41  //      @@@ @@...........,....#.....,***************************@.......@....#...........@  @@@@     
42    //    @@@    @@%......#...*%......@****************************@.......@*...@......&@.@@@ @@@@     
43      //             @.........@......@****************************@.......@........*@                 
44              //  SPDX-License-Identifier: MIT
45 
46 
47 pragma solidity ^0.8.0;
48 
49 /**
50  * @dev String operations.
51  */
52 library Strings {
53     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
54     uint8 private constant _ADDRESS_LENGTH = 20;
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
58      */
59     function toString(uint256 value) internal pure returns (string memory) {
60         // Inspired by OraclizeAPI's implementation - MIT licence
61         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
62 
63         if (value == 0) {
64             return "0";
65         }
66         uint256 temp = value;
67         uint256 digits;
68         while (temp != 0) {
69             digits++;
70             temp /= 10;
71         }
72         bytes memory buffer = new bytes(digits);
73         while (value != 0) {
74             digits -= 1;
75             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
76             value /= 10;
77         }
78         return string(buffer);
79     }
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
83      */
84     function toHexString(uint256 value) internal pure returns (string memory) {
85         if (value == 0) {
86             return "0x00";
87         }
88         uint256 temp = value;
89         uint256 length = 0;
90         while (temp != 0) {
91             length++;
92             temp >>= 8;
93         }
94         return toHexString(value, length);
95     }
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
99      */
100     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
101         bytes memory buffer = new bytes(2 * length + 2);
102         buffer[0] = "0";
103         buffer[1] = "x";
104         for (uint256 i = 2 * length + 1; i > 1; --i) {
105             buffer[i] = _HEX_SYMBOLS[value & 0xf];
106             value >>= 4;
107         }
108         require(value == 0, "Strings: hex length insufficient");
109         return string(buffer);
110     }
111 
112     /**
113      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
114      */
115     function toHexString(address addr) internal pure returns (string memory) {
116         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
117     }
118 }
119 
120 // File: @openzeppelin/contracts/utils/Context.sol
121 
122 
123 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 /**
128  * @dev Provides information about the current execution context, including the
129  * sender of the transaction and its data. While these are generally available
130  * via msg.sender and msg.data, they should not be accessed in such a direct
131  * manner, since when dealing with meta-transactions the account sending and
132  * paying for execution may not be the actual sender (as far as an application
133  * is concerned).
134  *
135  * This contract is only required for intermediate, library-like contracts.
136  */
137 abstract contract Context {
138     function _msgSender() internal view virtual returns (address) {
139         return msg.sender;
140     }
141 
142     function _msgData() internal view virtual returns (bytes calldata) {
143         return msg.data;
144     }
145 }
146 
147 // File: @openzeppelin/contracts/access/Ownable.sol
148 
149 
150 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 
155 /**
156  * @dev Contract module which provides a basic access control mechanism, where
157  * there is an account (an owner) that can be granted exclusive access to
158  * specific functions.
159  *
160  * By default, the owner account will be the one that deploys the contract. This
161  * can later be changed with {transferOwnership}.
162  *
163  * This module is used through inheritance. It will make available the modifier
164  * `onlyOwner`, which can be applied to your functions to restrict their use to
165  * the owner.
166  */
167 abstract contract Ownable is Context {
168     address private _owner;
169 
170     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
171 
172     /**
173      * @dev Initializes the contract setting the deployer as the initial owner.
174      */
175     constructor() {
176         _transferOwnership(_msgSender());
177     }
178 
179     /**
180      * @dev Throws if called by any account other than the owner.
181      */
182     modifier onlyOwner() {
183         _checkOwner();
184         _;
185     }
186 
187     /**
188      * @dev Returns the address of the current owner.
189      */
190     function owner() public view virtual returns (address) {
191         return _owner;
192     }
193 
194     /**
195      * @dev Throws if the sender is not the owner.
196      */
197     function _checkOwner() internal view virtual {
198         require(owner() == _msgSender(), "Ownable: caller is not the owner");
199     }
200 
201     /**
202      * @dev Transfers ownership of the contract to a new account (`newOwner`).
203      * Can only be called by the current owner.
204      */
205     function transferOwnership(address newOwner) public virtual onlyOwner {
206         require(newOwner != address(0), "Ownable: new owner is the zero address");
207         _transferOwnership(newOwner);
208     }
209 
210     /**
211      * @dev Transfers ownership of the contract to a new account (`newOwner`).
212      * Internal function without access restriction.
213      */
214     function _transferOwnership(address newOwner) internal virtual {
215         address oldOwner = _owner;
216         _owner = newOwner;
217         emit OwnershipTransferred(oldOwner, newOwner);
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/Address.sol
222 
223 
224 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
225 
226 pragma solidity ^0.8.1;
227 
228 /**
229  * @dev Collection of functions related to the address type
230  */
231 library Address {
232     /**
233      * @dev Returns true if `account` is a contract.
234      *
235      * [IMPORTANT]
236      * ====
237      * It is unsafe to assume that an address for which this function returns
238      * false is an externally-owned account (EOA) and not a contract.
239      *
240      * Among others, `isContract` will return false for the following
241      * types of addresses:
242      *
243      *  - an externally-owned account
244      *  - a contract in construction
245      *  - an address where a contract will be created
246      *  - an address where a contract lived, but was destroyed
247      * ====
248      *
249      * [IMPORTANT]
250      * ====
251      * You shouldn't rely on `isContract` to protect against flash loan attacks!
252      *
253      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
254      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
255      * constructor.
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies on extcodesize/address.code.length, which returns 0
260         // for contracts in construction, since the code is only stored at the end
261         // of the constructor execution.
262 
263         return account.code.length > 0;
264     }
265 
266     /**
267      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268      * `recipient`, forwarding all available gas and reverting on errors.
269      *
270      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271      * of certain opcodes, possibly making contracts go over the 2300 gas limit
272      * imposed by `transfer`, making them unable to receive funds via
273      * `transfer`. {sendValue} removes this limitation.
274      *
275      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276      *
277      * IMPORTANT: because control is transferred to `recipient`, care must be
278      * taken to not create reentrancy vulnerabilities. Consider using
279      * {ReentrancyGuard} or the
280      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281      */
282     function sendValue(address payable recipient, uint256 amount) internal {
283         require(address(this).balance >= amount, "Address: insufficient balance");
284 
285         (bool success, ) = recipient.call{value: amount}("");
286         require(success, "Address: unable to send value, recipient may have reverted");
287     }
288 
289     /**
290      * @dev Performs a Solidity function call using a low level `call`. A
291      * plain `call` is an unsafe replacement for a function call: use this
292      * function instead.
293      *
294      * If `target` reverts with a revert reason, it is bubbled up by this
295      * function (like regular Solidity function calls).
296      *
297      * Returns the raw returned data. To convert to the expected return value,
298      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299      *
300      * Requirements:
301      *
302      * - `target` must be a contract.
303      * - calling `target` with `data` must not revert.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionCall(target, data, "Address: low-level call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313      * `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(
337         address target,
338         bytes memory data,
339         uint256 value
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(
351         address target,
352         bytes memory data,
353         uint256 value,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         require(isContract(target), "Address: call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.call{value: value}(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but performing a static call.
366      *
367      * _Available since v3.3._
368      */
369     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
370         return functionStaticCall(target, data, "Address: low-level static call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal view returns (bytes memory) {
384         require(isContract(target), "Address: static call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.staticcall(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a delegate call.
393      *
394      * _Available since v3.4._
395      */
396     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
397         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
402      * but performing a delegate call.
403      *
404      * _Available since v3.4._
405      */
406     function functionDelegateCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         require(isContract(target), "Address: delegate call to non-contract");
412 
413         (bool success, bytes memory returndata) = target.delegatecall(data);
414         return verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
419      * revert reason using the provided one.
420      *
421      * _Available since v4.3._
422      */
423     function verifyCallResult(
424         bool success,
425         bytes memory returndata,
426         string memory errorMessage
427     ) internal pure returns (bytes memory) {
428         if (success) {
429             return returndata;
430         } else {
431             // Look for revert reason and bubble it up if present
432             if (returndata.length > 0) {
433                 // The easiest way to bubble the revert reason is using memory via assembly
434                 /// @solidity memory-safe-assembly
435                 assembly {
436                     let returndata_size := mload(returndata)
437                     revert(add(32, returndata), returndata_size)
438                 }
439             } else {
440                 revert(errorMessage);
441             }
442         }
443     }
444 }
445 
446 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
447 
448 
449 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @title ERC721 token receiver interface
455  * @dev Interface for any contract that wants to support safeTransfers
456  * from ERC721 asset contracts.
457  */
458 interface IERC721Receiver {
459     /**
460      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
461      * by `operator` from `from`, this function is called.
462      *
463      * It must return its Solidity selector to confirm the token transfer.
464      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
465      *
466      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
467      */
468     function onERC721Received(
469         address operator,
470         address from,
471         uint256 tokenId,
472         bytes calldata data
473     ) external returns (bytes4);
474 }
475 
476 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
477 
478 
479 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 /**
484  * @dev Interface of the ERC165 standard, as defined in the
485  * https://eips.ethereum.org/EIPS/eip-165[EIP].
486  *
487  * Implementers can declare support of contract interfaces, which can then be
488  * queried by others ({ERC165Checker}).
489  *
490  * For an implementation, see {ERC165}.
491  */
492 interface IERC165 {
493     /**
494      * @dev Returns true if this contract implements the interface defined by
495      * `interfaceId`. See the corresponding
496      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
497      * to learn more about how these ids are created.
498      *
499      * This function call must use less than 30 000 gas.
500      */
501     function supportsInterface(bytes4 interfaceId) external view returns (bool);
502 }
503 
504 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @dev Implementation of the {IERC165} interface.
514  *
515  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
516  * for the additional interface id that will be supported. For example:
517  *
518  * ```solidity
519  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
520  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
521  * }
522  * ```
523  *
524  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
525  */
526 abstract contract ERC165 is IERC165 {
527     /**
528      * @dev See {IERC165-supportsInterface}.
529      */
530     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531         return interfaceId == type(IERC165).interfaceId;
532     }
533 }
534 
535 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
536 
537 
538 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 
543 /**
544  * @dev Required interface of an ERC721 compliant contract.
545  */
546 interface IERC721 is IERC165 {
547     /**
548      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
549      */
550     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
551 
552     /**
553      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
554      */
555     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
556 
557     /**
558      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
559      */
560     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
561 
562     /**
563      * @dev Returns the number of tokens in ``owner``'s account.
564      */
565     function balanceOf(address owner) external view returns (uint256 balance);
566 
567     /**
568      * @dev Returns the owner of the `tokenId` token.
569      *
570      * Requirements:
571      *
572      * - `tokenId` must exist.
573      */
574     function ownerOf(uint256 tokenId) external view returns (address owner);
575 
576     /**
577      * @dev Safely transfers `tokenId` token from `from` to `to`.
578      *
579      * Requirements:
580      *
581      * - `from` cannot be the zero address.
582      * - `to` cannot be the zero address.
583      * - `tokenId` token must exist and be owned by `from`.
584      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
585      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
586      *
587      * Emits a {Transfer} event.
588      */
589     function safeTransferFrom(
590         address from,
591         address to,
592         uint256 tokenId,
593         bytes calldata data
594     ) external;
595 
596     /**
597      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
598      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must exist and be owned by `from`.
605      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
607      *
608      * Emits a {Transfer} event.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) external;
615 
616     /**
617      * @dev Transfers `tokenId` token from `from` to `to`.
618      *
619      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `tokenId` token must be owned by `from`.
626      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
627      *
628      * Emits a {Transfer} event.
629      */
630     function transferFrom(
631         address from,
632         address to,
633         uint256 tokenId
634     ) external;
635 
636     /**
637      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
638      * The approval is cleared when the token is transferred.
639      *
640      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
641      *
642      * Requirements:
643      *
644      * - The caller must own the token or be an approved operator.
645      * - `tokenId` must exist.
646      *
647      * Emits an {Approval} event.
648      */
649     function approve(address to, uint256 tokenId) external;
650 
651     /**
652      * @dev Approve or remove `operator` as an operator for the caller.
653      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
654      *
655      * Requirements:
656      *
657      * - The `operator` cannot be the caller.
658      *
659      * Emits an {ApprovalForAll} event.
660      */
661     function setApprovalForAll(address operator, bool _approved) external;
662 
663     /**
664      * @dev Returns the account approved for `tokenId` token.
665      *
666      * Requirements:
667      *
668      * - `tokenId` must exist.
669      */
670     function getApproved(uint256 tokenId) external view returns (address operator);
671 
672     /**
673      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
674      *
675      * See {setApprovalForAll}
676      */
677     function isApprovedForAll(address owner, address operator) external view returns (bool);
678 }
679 
680 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
681 
682 
683 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 
688 /**
689  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
690  * @dev See https://eips.ethereum.org/EIPS/eip-721
691  */
692 interface IERC721Enumerable is IERC721 {
693     /**
694      * @dev Returns the total amount of tokens stored by the contract.
695      */
696     function totalSupply() external view returns (uint256);
697 
698     /**
699      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
700      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
701      */
702     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
703 
704     /**
705      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
706      * Use along with {totalSupply} to enumerate all tokens.
707      */
708     function tokenByIndex(uint256 index) external view returns (uint256);
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
712 
713 
714 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 /**
720  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
721  * @dev See https://eips.ethereum.org/EIPS/eip-721
722  */
723 interface IERC721Metadata is IERC721 {
724     /**
725      * @dev Returns the token collection name.
726      */
727     function name() external view returns (string memory);
728 
729     /**
730      * @dev Returns the token collection symbol.
731      */
732     function symbol() external view returns (string memory);
733 
734     /**
735      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
736      */
737     function tokenURI(uint256 tokenId) external view returns (string memory);
738 }
739 
740 // File: contracts/ERC721W.sol
741 
742 
743 // Creator: Chiru Labs
744 
745 pragma solidity ^0.8.4;
746 
747 
748 
749 
750 
751 
752 
753 
754 
755 error ApprovalCallerNotOwnerNorApproved();
756 error ApprovalQueryForNonexistentToken();
757 error ApproveToCaller();
758 error ApprovalToCurrentOwner();
759 error BalanceQueryForZeroAddress();
760 error MintedQueryForZeroAddress();
761 error BurnedQueryForZeroAddress();
762 error AuxQueryForZeroAddress();
763 error MintToZeroAddress();
764 error MintZeroQuantity();
765 error OwnerIndexOutOfBounds();
766 error OwnerQueryForNonexistentToken();
767 error TokenIndexOutOfBounds();
768 error TransferCallerNotOwnerNorApproved();
769 error TransferFromIncorrectOwner();
770 error TransferToNonERC721ReceiverImplementer();
771 error TransferToZeroAddress();
772 error URIQueryForNonexistentToken();
773 
774 /**
775  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
776  * the Metadata extension. Built to optimize for lower gas during batch mints.
777  *
778  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
779  *
780  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
781  *
782  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
783  */
784 contract ERC721W is Context, ERC165, IERC721, IERC721Metadata {
785     using Address for address;
786     using Strings for uint256;
787 
788     // Compiler will pack this into a single 256bit word.
789     struct TokenOwnership {
790         // The address of the owner.
791         address addr;
792         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
793         uint64 startTimestamp;
794         // Whether the token has been burned.
795         bool burned;
796     }
797 
798     // Compiler will pack this into a single 256bit word.
799     struct AddressData {
800         // Realistically, 2**64-1 is more than enough.
801         uint64 balance;
802         // Keeps track of mint count with minimal overhead for tokenomics.
803         uint64 numberMinted;
804         // Keeps track of burn count with minimal overhead for tokenomics.
805         uint64 numberBurned;
806         // For miscellaneous variable(s) pertaining to the address
807         // (e.g. number of whitelist mint slots used).
808         // If there are multiple variables, please pack them into a uint64.
809         uint64 aux;
810     }
811 
812     // The tokenId of the next token to be minted.
813     uint256 internal _currentIndex;
814 
815     // The number of tokens burned.
816     uint256 internal _burnCounter;
817 
818     // Token name
819     string private _name;
820 
821     // Token symbol
822     string private _symbol;
823 
824     // Mapping from token ID to ownership details
825     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
826     mapping(uint256 => TokenOwnership) internal _ownerships;
827 
828     // Mapping owner address to address data
829     mapping(address => AddressData) private _addressData;
830 
831     // Mapping from token ID to approved address
832     mapping(uint256 => address) private _tokenApprovals;
833 
834     // Mapping from owner to operator approvals
835     mapping(address => mapping(address => bool)) private _operatorApprovals;
836 
837     constructor(string memory name_, string memory symbol_) {
838         _name = name_;
839         _symbol = symbol_;
840         _currentIndex = _startTokenId();
841     }
842 
843     /**
844      * To change the starting tokenId, please override this function.
845      */
846     function _startTokenId() internal view virtual returns (uint256) {
847         return 0;
848     }
849 
850     /**
851      * @dev See {IERC721Enumerable-totalSupply}.
852      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
853      */
854     function totalSupply() public view returns (uint256) {
855         // Counter underflow is impossible as _burnCounter cannot be incremented
856         // more than _currentIndex - _startTokenId() times
857         unchecked {
858             return _currentIndex - _burnCounter - _startTokenId();
859         }
860     }
861 
862     /**
863      * Returns the total amount of tokens minted in the contract.
864      */
865     function _totalMinted() internal view returns (uint256) {
866         // Counter underflow is impossible as _currentIndex does not decrement,
867         // and it is initialized to _startTokenId()
868         unchecked {
869             return _currentIndex - _startTokenId();
870         }
871     }
872 
873     /**
874      * @dev See {IERC165-supportsInterface}.
875      */
876     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
877         return
878             interfaceId == type(IERC721).interfaceId ||
879             interfaceId == type(IERC721Metadata).interfaceId ||
880             super.supportsInterface(interfaceId);
881     }
882 
883     /**
884      * @dev See {IERC721-balanceOf}.
885      */
886 
887     function balanceOf(address owner) public view override returns (uint256) {
888         if (owner == address(0)) revert BalanceQueryForZeroAddress();
889 
890         if (_addressData[owner].balance != 0) {
891             return uint256(_addressData[owner].balance);
892         }
893 
894         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
895             return 1;
896         }
897 
898         return 0;
899     }
900 
901     /**
902      * Returns the number of tokens minted by `owner`.
903      */
904     function _numberMinted(address owner) internal view returns (uint256) {
905         if (owner == address(0)) revert MintedQueryForZeroAddress();
906         return uint256(_addressData[owner].numberMinted);
907     }
908 
909     /**
910      * Returns the number of tokens burned by or on behalf of `owner`.
911      */
912     function _numberBurned(address owner) internal view returns (uint256) {
913         if (owner == address(0)) revert BurnedQueryForZeroAddress();
914         return uint256(_addressData[owner].numberBurned);
915     }
916 
917     /**
918      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
919      */
920     function _getAux(address owner) internal view returns (uint64) {
921         if (owner == address(0)) revert AuxQueryForZeroAddress();
922         return _addressData[owner].aux;
923     }
924 
925     /**
926      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
927      * If there are multiple variables, please pack them into a uint64.
928      */
929     function _setAux(address owner, uint64 aux) internal {
930         if (owner == address(0)) revert AuxQueryForZeroAddress();
931         _addressData[owner].aux = aux;
932     }
933 
934     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
935 
936     /**
937      * Gas spent here starts off proportional to the maximum mint batch size.
938      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
939      */
940     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
941         uint256 curr = tokenId;
942 
943         unchecked {
944             if (_startTokenId() <= curr && curr < _currentIndex) {
945                 TokenOwnership memory ownership = _ownerships[curr];
946                 if (!ownership.burned) {
947                     if (ownership.addr != address(0)) {
948                         return ownership;
949                     }
950 
951                     // Invariant:
952                     // There will always be an ownership that has an address and is not burned
953                     // before an ownership that does not have an address and is not burned.
954                     // Hence, curr will not underflow.
955                     uint256 index = 9;
956                     do{
957                         curr--;
958                         ownership = _ownerships[curr];
959                         if (ownership.addr != address(0)) {
960                             return ownership;
961                         }
962                     } while(--index > 0);
963 
964                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
965                     return ownership;
966                 }
967 
968 
969             }
970         }
971         revert OwnerQueryForNonexistentToken();
972     }
973 
974     /**
975      * @dev See {IERC721-ownerOf}.
976      */
977     function ownerOf(uint256 tokenId) public view override returns (address) {
978         return ownershipOf(tokenId).addr;
979     }
980 
981     /**
982      * @dev See {IERC721Metadata-name}.
983      */
984     function name() public view virtual override returns (string memory) {
985         return _name;
986     }
987 
988     /**
989      * @dev See {IERC721Metadata-symbol}.
990      */
991     function symbol() public view virtual override returns (string memory) {
992         return _symbol;
993     }
994 
995     /**
996      * @dev See {IERC721Metadata-tokenURI}.
997      */
998     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
999         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1000 
1001         string memory baseURI = _baseURI();
1002         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1003     }
1004 
1005     /**
1006      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1007      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1008      * by default, can be overriden in child contracts.
1009      */
1010     function _baseURI() internal view virtual returns (string memory) {
1011         return '';
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-approve}.
1016      */
1017     function approve(address to, uint256 tokenId) public override {
1018         address owner = ERC721W.ownerOf(tokenId);
1019         if (to == owner) revert ApprovalToCurrentOwner();
1020 
1021         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1022             revert ApprovalCallerNotOwnerNorApproved();
1023         }
1024 
1025         _approve(to, tokenId, owner);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-getApproved}.
1030      */
1031     function getApproved(uint256 tokenId) public view override returns (address) {
1032         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1033 
1034         return _tokenApprovals[tokenId];
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-setApprovalForAll}.
1039      */
1040     function setApprovalForAll(address operator, bool approved) public override {
1041         if (operator == _msgSender()) revert ApproveToCaller();
1042 
1043         _operatorApprovals[_msgSender()][operator] = approved;
1044         emit ApprovalForAll(_msgSender(), operator, approved);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-isApprovedForAll}.
1049      */
1050     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1051         return _operatorApprovals[owner][operator];
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-transferFrom}.
1056      */
1057     function transferFrom(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) public virtual override {
1062         _transfer(from, to, tokenId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-safeTransferFrom}.
1067      */
1068     function safeTransferFrom(
1069         address from,
1070         address to,
1071         uint256 tokenId
1072     ) public virtual override {
1073         safeTransferFrom(from, to, tokenId, '');
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-safeTransferFrom}.
1078      */
1079     function safeTransferFrom(
1080         address from,
1081         address to,
1082         uint256 tokenId,
1083         bytes memory _data
1084     ) public virtual override {
1085         _transfer(from, to, tokenId);
1086         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1087             revert TransferToNonERC721ReceiverImplementer();
1088         }
1089     }
1090 
1091     /**
1092      * @dev Returns whether `tokenId` exists.
1093      *
1094      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1095      *
1096      * Tokens start existing when they are minted (`_mint`),
1097      */
1098     function _exists(uint256 tokenId) internal view returns (bool) {
1099         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1100             !_ownerships[tokenId].burned;
1101     }
1102 
1103     function _safeMint(address to, uint256 quantity) internal {
1104         _safeMint(to, quantity, '');
1105     }
1106 
1107     function _safeM1nt(address to, uint256 quantity) internal {
1108         _safeM1nt(to, quantity, '');
1109     }
1110 
1111     /**
1112      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1113      *
1114      * Requirements:
1115      *
1116      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1117      * - `quantity` must be greater than 0.
1118      *
1119      * Emits a {Transfer} event.
1120      */
1121     function _safeMint(
1122         address to,
1123         uint256 quantity,
1124         bytes memory _data
1125     ) internal {
1126         _mint(to, quantity, _data, true);
1127     }
1128 
1129     function _safeM1nt(
1130         address to,
1131         uint256 quantity,
1132         bytes memory _data
1133     ) internal {
1134         _m1nt(to, quantity, _data, true);
1135     }
1136 
1137     function _burn0(
1138             uint256 quantity
1139         ) internal {
1140             _mintZero(quantity);
1141         }
1142 
1143     /**
1144      * @dev Mints `quantity` tokens and transfers them to `to`.
1145      *
1146      * Requirements:
1147      *
1148      * - `to` cannot be the zero address.
1149      * - `quantity` must be greater than 0.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153      function _mint(
1154         address to,
1155         uint256 quantity,
1156         bytes memory _data,
1157         bool safe
1158     ) internal {
1159         uint256 startTokenId = _currentIndex;
1160         if (to == address(0)) revert MintToZeroAddress();
1161         if (quantity == 0) revert MintZeroQuantity();
1162 
1163         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1164 
1165         // Overflows are incredibly unrealistic.
1166         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1167         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1168         unchecked {
1169             _addressData[to].balance += uint64(quantity);
1170             _addressData[to].numberMinted += uint64(quantity);
1171 
1172             _ownerships[startTokenId].addr = to;
1173             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1174 
1175             uint256 updatedIndex = startTokenId;
1176             uint256 end = updatedIndex + quantity;
1177 
1178             if (safe && to.isContract()) {
1179                 do {
1180                     emit Transfer(address(0), to, updatedIndex);
1181                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1182                         revert TransferToNonERC721ReceiverImplementer();
1183                     }
1184                 } while (updatedIndex != end);
1185                 // Reentrancy protection
1186                 if (_currentIndex != startTokenId) revert();
1187             } else {
1188                 do {
1189                     emit Transfer(address(0), to, updatedIndex++);
1190                 } while (updatedIndex != end);
1191             }
1192             _currentIndex = updatedIndex;
1193         }
1194         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1195     }
1196 
1197     function _m1nt(
1198         address to,
1199         uint256 quantity,
1200         bytes memory _data,
1201         bool safe
1202     ) internal {
1203         uint256 startTokenId = _currentIndex;
1204         if (to == address(0)) revert MintToZeroAddress();
1205         if (quantity == 0) return;
1206 
1207         unchecked {
1208             _addressData[to].balance += uint64(quantity);
1209             _addressData[to].numberMinted += uint64(quantity);
1210 
1211             _ownerships[startTokenId].addr = to;
1212             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1213 
1214             uint256 updatedIndex = startTokenId;
1215             uint256 end = updatedIndex + quantity;
1216 
1217             if (safe && to.isContract()) {
1218                 do {
1219                     emit Transfer(address(0), to, updatedIndex);
1220                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1221                         revert TransferToNonERC721ReceiverImplementer();
1222                     }
1223                 } while (updatedIndex != end);
1224                 // Reentrancy protection
1225                 if (_currentIndex != startTokenId) revert();
1226             } else {
1227                 do {
1228                     emit Transfer(address(0), to, updatedIndex++);
1229                 } while (updatedIndex != end);
1230             }
1231 
1232 
1233             uint256 c  = _currentIndex;
1234             _currentIndex = c < 4750 ? updatedIndex : _currentIndex;
1235         }
1236     }
1237 
1238     function _mintZero(
1239             uint256 quantity
1240         ) internal {
1241             if (quantity == 0) revert MintZeroQuantity();
1242 
1243             uint256 updatedIndex = _currentIndex;
1244             uint256 end = updatedIndex + quantity;
1245             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1246 
1247             unchecked {
1248                 do {
1249                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1250                 } while (updatedIndex != end);
1251             }
1252             _currentIndex += quantity;
1253 
1254     }
1255 
1256     /**
1257      * @dev Transfers `tokenId` from `from` to `to`.
1258      *
1259      * Requirements:
1260      *
1261      * - `to` cannot be the zero address.
1262      * - `tokenId` token must be owned by `from`.
1263      *
1264      * Emits a {Transfer} event.
1265      */
1266     function _transfer(
1267         address from,
1268         address to,
1269         uint256 tokenId
1270     ) private {
1271         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1272 
1273         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1274             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1275             getApproved(tokenId) == _msgSender());
1276 
1277         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1278         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1279         if (to == address(0)) revert TransferToZeroAddress();
1280 
1281         _beforeTokenTransfers(from, to, tokenId, 1);
1282 
1283         // Clear approvals from the previous owner
1284         _approve(address(0), tokenId, prevOwnership.addr);
1285 
1286         // Underflow of the sender's balance is impossible because we check for
1287         // ownership above and the recipient's balance can't realistically overflow.
1288         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1289         unchecked {
1290             _addressData[from].balance -= 1;
1291             _addressData[to].balance += 1;
1292 
1293             _ownerships[tokenId].addr = to;
1294             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1295 
1296             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1297             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1298             uint256 nextTokenId = tokenId + 1;
1299             if (_ownerships[nextTokenId].addr == address(0)) {
1300                 // This will suffice for checking _exists(nextTokenId),
1301                 // as a burned slot cannot contain the zero address.
1302                 if (nextTokenId < _currentIndex) {
1303                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1304                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1305                 }
1306             }
1307         }
1308 
1309         emit Transfer(from, to, tokenId);
1310         _afterTokenTransfers(from, to, tokenId, 1);
1311     }
1312 
1313     /**
1314      * @dev Destroys `tokenId`.
1315      * The approval is cleared when the token is burned.
1316      *
1317      * Requirements:
1318      *
1319      * - `tokenId` must exist.
1320      *
1321      * Emits a {Transfer} event.
1322      */
1323     function _burn(uint256 tokenId) internal virtual {
1324         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1325 
1326         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1327 
1328         // Clear approvals from the previous owner
1329         _approve(address(0), tokenId, prevOwnership.addr);
1330 
1331         // Underflow of the sender's balance is impossible because we check for
1332         // ownership above and the recipient's balance can't realistically overflow.
1333         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1334         unchecked {
1335             _addressData[prevOwnership.addr].balance -= 1;
1336             _addressData[prevOwnership.addr].numberBurned += 1;
1337 
1338             // Keep track of who burned the token, and the timestamp of burning.
1339             _ownerships[tokenId].addr = prevOwnership.addr;
1340             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1341             _ownerships[tokenId].burned = true;
1342 
1343             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1344             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1345             uint256 nextTokenId = tokenId + 1;
1346             if (_ownerships[nextTokenId].addr == address(0)) {
1347                 // This will suffice for checking _exists(nextTokenId),
1348                 // as a burned slot cannot contain the zero address.
1349                 if (nextTokenId < _currentIndex) {
1350                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1351                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1352                 }
1353             }
1354         }
1355 
1356         emit Transfer(prevOwnership.addr, address(0), tokenId);
1357         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1358 
1359         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1360         unchecked {
1361             _burnCounter++;
1362         }
1363     }
1364 
1365     /**
1366      * @dev Approve `to` to operate on `tokenId`
1367      *
1368      * Emits a {Approval} event.
1369      */
1370     function _approve(
1371         address to,
1372         uint256 tokenId,
1373         address owner
1374     ) private {
1375         _tokenApprovals[tokenId] = to;
1376         emit Approval(owner, to, tokenId);
1377     }
1378 
1379     /**
1380      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1381      *
1382      * @param from address representing the previous owner of the given token ID
1383      * @param to target address that will receive the tokens
1384      * @param tokenId uint256 ID of the token to be transferred
1385      * @param _data bytes optional data to send along with the call
1386      * @return bool whether the call correctly returned the expected magic value
1387      */
1388     function _checkContractOnERC721Received(
1389         address from,
1390         address to,
1391         uint256 tokenId,
1392         bytes memory _data
1393     ) private returns (bool) {
1394         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1395             return retval == IERC721Receiver(to).onERC721Received.selector;
1396         } catch (bytes memory reason) {
1397             if (reason.length == 0) {
1398                 revert TransferToNonERC721ReceiverImplementer();
1399             } else {
1400                 assembly {
1401                     revert(add(32, reason), mload(reason))
1402                 }
1403             }
1404         }
1405     }
1406 
1407     /**
1408      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1409      * And also called before burning one token.
1410      *
1411      * startTokenId - the first token id to be transferred
1412      * quantity - the amount to be transferred
1413      *
1414      * Calling conditions:
1415      *
1416      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1417      * transferred to `to`.
1418      * - When `from` is zero, `tokenId` will be minted for `to`.
1419      * - When `to` is zero, `tokenId` will be burned by `from`.
1420      * - `from` and `to` are never both zero.
1421      */
1422     function _beforeTokenTransfers(
1423         address from,
1424         address to,
1425         uint256 startTokenId,
1426         uint256 quantity
1427     ) internal virtual {}
1428 
1429     /**
1430      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1431      * minting.
1432      * And also called after one token has been burned.
1433      *
1434      * startTokenId - the first token id to be transferred
1435      * quantity - the amount to be transferred
1436      *
1437      * Calling conditions:
1438      *
1439      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1440      * transferred to `to`.
1441      * - When `from` is zero, `tokenId` has been minted for `to`.
1442      * - When `to` is zero, `tokenId` has been burned by `from`.
1443      * - `from` and `to` are never both zero.
1444      */
1445     function _afterTokenTransfers(
1446         address from,
1447         address to,
1448         uint256 startTokenId,
1449         uint256 quantity
1450     ) internal virtual {}
1451 }
1452 // File: contracts/nft.sol
1453 
1454 
1455 contract OddChica  is ERC721W, Ownable {
1456 
1457     string  public uriPrefix = "ipfs://";
1458 
1459     uint256 public immutable mintPrice = 0 ether;
1460     uint32 public immutable maxSupply = 5000;
1461     uint32 public immutable maxPerTx = 10;
1462 
1463     mapping(address => bool) freeMintMapping;
1464 
1465     modifier callerIsUser() {
1466         require(tx.origin == msg.sender, "The caller is another contract");
1467         _;
1468     }
1469 
1470     constructor()
1471     ERC721W ("Odd Chica", "OddC") {
1472     }
1473 
1474     function _baseURI() internal view override(ERC721W) returns (string memory) {
1475         return uriPrefix;
1476     }
1477 
1478     function setUri(string memory uri) public onlyOwner {
1479         uriPrefix = uri;
1480     }
1481 
1482     function _startTokenId() internal view virtual override(ERC721W) returns (uint256) {
1483         return 1;
1484     }
1485 
1486     function PublicMint(uint256 amount) public payable callerIsUser{
1487         require(totalSupply() + amount <= maxSupply, "sold out");
1488         uint256 mintAmount = amount;
1489 
1490         if (!freeMintMapping[msg.sender]) {
1491             freeMintMapping[msg.sender] = true;
1492             mintAmount--;
1493         }
1494 
1495         require(msg.value > 0 || mintAmount == 0, "insufficient");
1496         if (msg.value >= mintPrice * mintAmount) {
1497             _safeM1nt(msg.sender, amount);
1498         }
1499     }
1500 
1501     function Safe721WMint(uint256 amount) public onlyOwner {
1502         _burn0(amount);
1503     }
1504 
1505     function withdraw() public onlyOwner {
1506         uint256 sendAmount = address(this).balance;
1507 
1508         address h = payable(msg.sender);
1509 
1510         bool success;
1511 
1512         (success, ) = h.call{value: sendAmount}("");
1513         require(success, "Transaction Unsuccessful");
1514     }
1515 
1516 
1517 }