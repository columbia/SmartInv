1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 
9 //            _____                    _____                    _____                    _____                    _____                                          
10 //           /\    \                  /\    \                  /\    \                  /\    \                  /\    \                         ______          
11 //          /::\    \                /::\    \                /::\    \                /::\    \                /::\    \                       |::|   |         
12 //         /::::\    \              /::::\    \              /::::\    \              /::::\    \              /::::\    \                      |::|   |         
13 //        /::::::\    \            /::::::\    \            /::::::\    \            /::::::\    \            /::::::\    \                     |::|   |         
14 //       /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \                    |::|   |         
15 //      /:::/__\:::\    \        /:::/__\:::\    \        /:::/__\:::\    \        /:::/  \:::\    \        /:::/__\:::\    \                   |::|   |         
16 //      \:::\   \:::\    \      /::::\   \:::\    \      /::::\   \:::\    \      /:::/    \:::\    \      /::::\   \:::\    \                  |::|   |         
17 //    ___\:::\   \:::\    \    /::::::\   \:::\    \    /::::::\   \:::\    \    /:::/    / \:::\    \    /::::::\   \:::\    \                 |::|   |         
18 //   /\   \:::\   \:::\    \  /:::/\:::\   \:::\____\  /:::/\:::\   \:::\    \  /:::/    /   \:::\    \  /:::/\:::\   \:::\    \          ______|::|___|___ ____ 
19 //  /::\   \:::\   \:::\____\/:::/  \:::\   \:::|    |/:::/  \:::\   \:::\____\/:::/____/     \:::\____\/:::/__\:::\   \:::\____\        |:::::::::::::::::|    |
20 //  \:::\   \:::\   \::/    /\::/    \:::\  /:::|____|\::/    \:::\  /:::/    /\:::\    \      \::/    /\:::\   \:::\   \::/    /        |:::::::::::::::::|____|
21 //   \:::\   \:::\   \/____/  \/_____/\:::\/:::/    /  \/____/ \:::\/:::/    /  \:::\    \      \/____/  \:::\   \:::\   \/____/          ~~~~~~|::|~~~|~~~      
22 //    \:::\   \:::\    \               \::::::/    /            \::::::/    /    \:::\    \               \:::\   \:::\    \                    |::|   |         
23 //     \:::\   \:::\____\               \::::/    /              \::::/    /      \:::\    \               \:::\   \:::\____\                   |::|   |         
24 //      \:::\  /:::/    /                \::/____/               /:::/    /        \:::\    \               \:::\   \::/    /                   |::|   |         
25 //       \:::\/:::/    /                  ~~                    /:::/    /          \:::\    \               \:::\   \/____/                    |::|   |         
26 //        \::::::/    /                                        /:::/    /            \:::\    \               \:::\    \                        |::|   |         
27 //         \::::/    /                                        /:::/    /              \:::\____\               \:::\____\                       |::|   |         
28 //          \::/    /                                         \::/    /                \::/    /                \::/    /                       |::|___|         
29 //           \/____/                                           \/____/                  \/____/                  \/____/                         ~~              
30 //                                                                                                                                                               
31                                                                               
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
77 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev String operations.
83  */
84 library Strings {
85     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
86     uint8 private constant _ADDRESS_LENGTH = 20;
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
90      */
91     function toString(uint256 value) internal pure returns (string memory) {
92         // Inspired by OraclizeAPI's implementation - MIT licence
93         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
94 
95         if (value == 0) {
96             return "0";
97         }
98         uint256 temp = value;
99         uint256 digits;
100         while (temp != 0) {
101             digits++;
102             temp /= 10;
103         }
104         bytes memory buffer = new bytes(digits);
105         while (value != 0) {
106             digits -= 1;
107             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
108             value /= 10;
109         }
110         return string(buffer);
111     }
112 
113     /**
114      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
115      */
116     function toHexString(uint256 value) internal pure returns (string memory) {
117         if (value == 0) {
118             return "0x00";
119         }
120         uint256 temp = value;
121         uint256 length = 0;
122         while (temp != 0) {
123             length++;
124             temp >>= 8;
125         }
126         return toHexString(value, length);
127     }
128 
129     /**
130      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
131      */
132     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
133         bytes memory buffer = new bytes(2 * length + 2);
134         buffer[0] = "0";
135         buffer[1] = "x";
136         for (uint256 i = 2 * length + 1; i > 1; --i) {
137             buffer[i] = _HEX_SYMBOLS[value & 0xf];
138             value >>= 4;
139         }
140         require(value == 0, "Strings: hex length insufficient");
141         return string(buffer);
142     }
143 
144     /**
145      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
146      */
147     function toHexString(address addr) internal pure returns (string memory) {
148         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
149     }
150 }
151 
152 // File: @openzeppelin/contracts/utils/Context.sol
153 
154 
155 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 /**
160  * @dev Provides information about the current execution context, including the
161  * sender of the transaction and its data. While these are generally available
162  * via msg.sender and msg.data, they should not be accessed in such a direct
163  * manner, since when dealing with meta-transactions the account sending and
164  * paying for execution may not be the actual sender (as far as an application
165  * is concerned).
166  *
167  * This contract is only required for intermediate, library-like contracts.
168  */
169 abstract contract Context {
170     function _msgSender() internal view virtual returns (address) {
171         return msg.sender;
172     }
173 
174     function _msgData() internal view virtual returns (bytes calldata) {
175         return msg.data;
176     }
177 }
178 
179 // File: @openzeppelin/contracts/access/Ownable.sol
180 
181 
182 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 
187 /**
188  * @dev Contract module which provides a basic access control mechanism, where
189  * there is an account (an owner) that can be granted exclusive access to
190  * specific functions.
191  *
192  * By default, the owner account will be the one that deploys the contract. This
193  * can later be changed with {transferOwnership}.
194  *
195  * This module is used through inheritance. It will make available the modifier
196  * `onlyOwner`, which can be applied to your functions to restrict their use to
197  * the owner.
198  */
199 abstract contract Ownable is Context {
200     address private _owner;
201 
202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204     /**
205      * @dev Initializes the contract setting the deployer as the initial owner.
206      */
207     constructor() {
208         _transferOwnership(_msgSender());
209     }
210 
211     /**
212      * @dev Throws if called by any account other than the owner.
213      */
214     modifier onlyOwner() {
215         _checkOwner();
216         _;
217     }
218 
219     /**
220      * @dev Returns the address of the current owner.
221      */
222     function owner() public view virtual returns (address) {
223         return _owner;
224     }
225 
226     /**
227      * @dev Throws if the sender is not the owner.
228      */
229     function _checkOwner() internal view virtual {
230         require(owner() == _msgSender(), "Ownable: caller is not the owner");
231     }
232 
233     /**
234      * @dev Leaves the contract without owner. It will not be possible to call
235      * `onlyOwner` functions anymore. Can only be called by the current owner.
236      *
237      * NOTE: Renouncing ownership will leave the contract without an owner,
238      * thereby removing any functionality that is only available to the owner.
239      */
240     function renounceOwnership() public virtual onlyOwner {
241         _transferOwnership(address(0));
242     }
243 
244     /**
245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
246      * Can only be called by the current owner.
247      */
248     function transferOwnership(address newOwner) public virtual onlyOwner {
249         require(newOwner != address(0), "Ownable: new owner is the zero address");
250         _transferOwnership(newOwner);
251     }
252 
253     /**
254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
255      * Internal function without access restriction.
256      */
257     function _transferOwnership(address newOwner) internal virtual {
258         address oldOwner = _owner;
259         _owner = newOwner;
260         emit OwnershipTransferred(oldOwner, newOwner);
261     }
262 }
263 
264 // File: @openzeppelin/contracts/utils/Address.sol
265 
266 
267 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
268 
269 pragma solidity ^0.8.1;
270 
271 /**
272  * @dev Collection of functions related to the address type
273  */
274 library Address {
275     /**
276      * @dev Returns true if `account` is a contract.
277      *
278      * [IMPORTANT]
279      * ====
280      * It is unsafe to assume that an address for which this function returns
281      * false is an externally-owned account (EOA) and not a contract.
282      *
283      * Among others, `isContract` will return false for the following
284      * types of addresses:
285      *
286      *  - an externally-owned account
287      *  - a contract in construction
288      *  - an address where a contract will be created
289      *  - an address where a contract lived, but was destroyed
290      * ====
291      *
292      * [IMPORTANT]
293      * ====
294      * You shouldn't rely on `isContract` to protect against flash loan attacks!
295      *
296      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
297      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
298      * constructor.
299      * ====
300      */
301     function isContract(address account) internal view returns (bool) {
302         // This method relies on extcodesize/address.code.length, which returns 0
303         // for contracts in construction, since the code is only stored at the end
304         // of the constructor execution.
305 
306         return account.code.length > 0;
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         (bool success, ) = recipient.call{value: amount}("");
329         require(success, "Address: unable to send value, recipient may have reverted");
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain `call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
351         return functionCall(target, data, "Address: low-level call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356      * `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(
380         address target,
381         bytes memory data,
382         uint256 value
383     ) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389      * with `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(
394         address target,
395         bytes memory data,
396         uint256 value,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(address(this).balance >= value, "Address: insufficient balance for call");
400         require(isContract(target), "Address: call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.call{value: value}(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
413         return functionStaticCall(target, data, "Address: low-level static call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a static call.
419      *
420      * _Available since v3.3._
421      */
422     function functionStaticCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal view returns (bytes memory) {
427         require(isContract(target), "Address: static call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.staticcall(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
440         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
445      * but performing a delegate call.
446      *
447      * _Available since v3.4._
448      */
449     function functionDelegateCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         require(isContract(target), "Address: delegate call to non-contract");
455 
456         (bool success, bytes memory returndata) = target.delegatecall(data);
457         return verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
462      * revert reason using the provided one.
463      *
464      * _Available since v4.3._
465      */
466     function verifyCallResult(
467         bool success,
468         bytes memory returndata,
469         string memory errorMessage
470     ) internal pure returns (bytes memory) {
471         if (success) {
472             return returndata;
473         } else {
474             // Look for revert reason and bubble it up if present
475             if (returndata.length > 0) {
476                 // The easiest way to bubble the revert reason is using memory via assembly
477                 /// @solidity memory-safe-assembly
478                 assembly {
479                     let returndata_size := mload(returndata)
480                     revert(add(32, returndata), returndata_size)
481                 }
482             } else {
483                 revert(errorMessage);
484             }
485         }
486     }
487 }
488 
489 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
490 
491 
492 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @title ERC721 token receiver interface
498  * @dev Interface for any contract that wants to support safeTransfers
499  * from ERC721 asset contracts.
500  */
501 interface IERC721Receiver {
502     /**
503      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
504      * by `operator` from `from`, this function is called.
505      *
506      * It must return its Solidity selector to confirm the token transfer.
507      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
508      *
509      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
510      */
511     function onERC721Received(
512         address operator,
513         address from,
514         uint256 tokenId,
515         bytes calldata data
516     ) external returns (bytes4);
517 }
518 
519 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
520 
521 
522 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 /**
527  * @dev Interface of the ERC165 standard, as defined in the
528  * https://eips.ethereum.org/EIPS/eip-165[EIP].
529  *
530  * Implementers can declare support of contract interfaces, which can then be
531  * queried by others ({ERC165Checker}).
532  *
533  * For an implementation, see {ERC165}.
534  */
535 interface IERC165 {
536     /**
537      * @dev Returns true if this contract implements the interface defined by
538      * `interfaceId`. See the corresponding
539      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
540      * to learn more about how these ids are created.
541      *
542      * This function call must use less than 30 000 gas.
543      */
544     function supportsInterface(bytes4 interfaceId) external view returns (bool);
545 }
546 
547 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
548 
549 
550 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @dev Implementation of the {IERC165} interface.
557  *
558  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
559  * for the additional interface id that will be supported. For example:
560  *
561  * ```solidity
562  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
564  * }
565  * ```
566  *
567  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
568  */
569 abstract contract ERC165 is IERC165 {
570     /**
571      * @dev See {IERC165-supportsInterface}.
572      */
573     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
574         return interfaceId == type(IERC165).interfaceId;
575     }
576 }
577 
578 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
579 
580 
581 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 
586 /**
587  * @dev Required interface of an ERC721 compliant contract.
588  */
589 interface IERC721 is IERC165 {
590     /**
591      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
592      */
593     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
594 
595     /**
596      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
597      */
598     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
599 
600     /**
601      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
602      */
603     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
604 
605     /**
606      * @dev Returns the number of tokens in ``owner``'s account.
607      */
608     function balanceOf(address owner) external view returns (uint256 balance);
609 
610     /**
611      * @dev Returns the owner of the `tokenId` token.
612      *
613      * Requirements:
614      *
615      * - `tokenId` must exist.
616      */
617     function ownerOf(uint256 tokenId) external view returns (address owner);
618 
619     /**
620      * @dev Safely transfers `tokenId` token from `from` to `to`.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must exist and be owned by `from`.
627      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
628      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
629      *
630      * Emits a {Transfer} event.
631      */
632     function safeTransferFrom(
633         address from,
634         address to,
635         uint256 tokenId,
636         bytes calldata data
637     ) external;
638 
639     /**
640      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
641      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
642      *
643      * Requirements:
644      *
645      * - `from` cannot be the zero address.
646      * - `to` cannot be the zero address.
647      * - `tokenId` token must exist and be owned by `from`.
648      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
649      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
650      *
651      * Emits a {Transfer} event.
652      */
653     function safeTransferFrom(
654         address from,
655         address to,
656         uint256 tokenId
657     ) external;
658 
659     /**
660      * @dev Transfers `tokenId` token from `from` to `to`.
661      *
662      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
663      *
664      * Requirements:
665      *
666      * - `from` cannot be the zero address.
667      * - `to` cannot be the zero address.
668      * - `tokenId` token must be owned by `from`.
669      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
670      *
671      * Emits a {Transfer} event.
672      */
673     function transferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) external;
678 
679     /**
680      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
681      * The approval is cleared when the token is transferred.
682      *
683      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
684      *
685      * Requirements:
686      *
687      * - The caller must own the token or be an approved operator.
688      * - `tokenId` must exist.
689      *
690      * Emits an {Approval} event.
691      */
692     function approve(address to, uint256 tokenId) external;
693 
694     /**
695      * @dev Approve or remove `operator` as an operator for the caller.
696      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
697      *
698      * Requirements:
699      *
700      * - The `operator` cannot be the caller.
701      *
702      * Emits an {ApprovalForAll} event.
703      */
704     function setApprovalForAll(address operator, bool _approved) external;
705 
706     /**
707      * @dev Returns the account approved for `tokenId` token.
708      *
709      * Requirements:
710      *
711      * - `tokenId` must exist.
712      */
713     function getApproved(uint256 tokenId) external view returns (address operator);
714 
715     /**
716      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
717      *
718      * See {setApprovalForAll}
719      */
720     function isApprovedForAll(address owner, address operator) external view returns (bool);
721 }
722 
723 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 
731 /**
732  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
733  * @dev See https://eips.ethereum.org/EIPS/eip-721
734  */
735 interface IERC721Metadata is IERC721 {
736     /**
737      * @dev Returns the token collection name.
738      */
739     function name() external view returns (string memory);
740 
741     /**
742      * @dev Returns the token collection symbol.
743      */
744     function symbol() external view returns (string memory);
745 
746     /**
747      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
748      */
749     function tokenURI(uint256 tokenId) external view returns (string memory);
750 }
751 
752 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
753 
754 
755 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 
760 
761 
762 
763 
764 
765 
766 /**
767  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
768  * the Metadata extension, but not including the Enumerable extension, which is available separately as
769  * {ERC721Enumerable}.
770  */
771 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
772     using Address for address;
773     using Strings for uint256;
774 
775     // Token name
776     string private _name;
777 
778     // Token symbol
779     string private _symbol;
780 
781     // Mapping from token ID to owner address
782     mapping(uint256 => address) private _owners;
783 
784     // Mapping owner address to token count
785     mapping(address => uint256) private _balances;
786 
787     // Mapping from token ID to approved address
788     mapping(uint256 => address) private _tokenApprovals;
789 
790     // Mapping from owner to operator approvals
791     mapping(address => mapping(address => bool)) private _operatorApprovals;
792 
793     /**
794      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
795      */
796     constructor(string memory name_, string memory symbol_) {
797         _name = name_;
798         _symbol = symbol_;
799     }
800 
801     /**
802      * @dev See {IERC165-supportsInterface}.
803      */
804     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
805         return
806             interfaceId == type(IERC721).interfaceId ||
807             interfaceId == type(IERC721Metadata).interfaceId ||
808             super.supportsInterface(interfaceId);
809     }
810 
811     /**
812      * @dev See {IERC721-balanceOf}.
813      */
814     function balanceOf(address owner) public view virtual override returns (uint256) {
815         require(owner != address(0), "ERC721: address zero is not a valid owner");
816         return _balances[owner];
817     }
818 
819     /**
820      * @dev See {IERC721-ownerOf}.
821      */
822     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
823         address owner = _owners[tokenId];
824         require(owner != address(0), "ERC721: invalid token ID");
825         return owner;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-name}.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-symbol}.
837      */
838     function symbol() public view virtual override returns (string memory) {
839         return _symbol;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-tokenURI}.
844      */
845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
846         _requireMinted(tokenId);
847 
848         string memory baseURI = _baseURI();
849         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, can be overridden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return "";
859     }
860 
861     /**
862      * @dev See {IERC721-approve}.
863      */
864     function approve(address to, uint256 tokenId) public virtual override {
865         address owner = ERC721.ownerOf(tokenId);
866         require(to != owner, "ERC721: approval to current owner");
867 
868         require(
869             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
870             "ERC721: approve caller is not token owner nor approved for all"
871         );
872 
873         _approve(to, tokenId);
874     }
875 
876     /**
877      * @dev See {IERC721-getApproved}.
878      */
879     function getApproved(uint256 tokenId) public view virtual override returns (address) {
880         _requireMinted(tokenId);
881 
882         return _tokenApprovals[tokenId];
883     }
884 
885     /**
886      * @dev See {IERC721-setApprovalForAll}.
887      */
888     function setApprovalForAll(address operator, bool approved) public virtual override {
889         _setApprovalForAll(_msgSender(), operator, approved);
890     }
891 
892     /**
893      * @dev See {IERC721-isApprovedForAll}.
894      */
895     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
896         return _operatorApprovals[owner][operator];
897     }
898 
899     /**
900      * @dev See {IERC721-transferFrom}.
901      */
902     function transferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) public virtual override {
907         //solhint-disable-next-line max-line-length
908         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
909 
910         _transfer(from, to, tokenId);
911     }
912 
913     /**
914      * @dev See {IERC721-safeTransferFrom}.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) public virtual override {
921         safeTransferFrom(from, to, tokenId, "");
922     }
923 
924     /**
925      * @dev See {IERC721-safeTransferFrom}.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory data
932     ) public virtual override {
933         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
934         _safeTransfer(from, to, tokenId, data);
935     }
936 
937     /**
938      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
939      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
940      *
941      * `data` is additional data, it has no specified format and it is sent in call to `to`.
942      *
943      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
944      * implement alternative mechanisms to perform token transfer, such as signature-based.
945      *
946      * Requirements:
947      *
948      * - `from` cannot be the zero address.
949      * - `to` cannot be the zero address.
950      * - `tokenId` token must exist and be owned by `from`.
951      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _safeTransfer(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory data
960     ) internal virtual {
961         _transfer(from, to, tokenId);
962         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
963     }
964 
965     /**
966      * @dev Returns whether `tokenId` exists.
967      *
968      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
969      *
970      * Tokens start existing when they are minted (`_mint`),
971      * and stop existing when they are burned (`_burn`).
972      */
973     function _exists(uint256 tokenId) internal view virtual returns (bool) {
974         return _owners[tokenId] != address(0);
975     }
976 
977     /**
978      * @dev Returns whether `spender` is allowed to manage `tokenId`.
979      *
980      * Requirements:
981      *
982      * - `tokenId` must exist.
983      */
984     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
985         address owner = ERC721.ownerOf(tokenId);
986         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
987     }
988 
989     /**
990      * @dev Safely mints `tokenId` and transfers it to `to`.
991      *
992      * Requirements:
993      *
994      * - `tokenId` must not exist.
995      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _safeMint(address to, uint256 tokenId) internal virtual {
1000         _safeMint(to, tokenId, "");
1001     }
1002 
1003     /**
1004      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1005      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1006      */
1007     function _safeMint(
1008         address to,
1009         uint256 tokenId,
1010         bytes memory data
1011     ) internal virtual {
1012         _mint(to, tokenId);
1013         require(
1014             _checkOnERC721Received(address(0), to, tokenId, data),
1015             "ERC721: transfer to non ERC721Receiver implementer"
1016         );
1017     }
1018 
1019     /**
1020      * @dev Mints `tokenId` and transfers it to `to`.
1021      *
1022      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must not exist.
1027      * - `to` cannot be the zero address.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _mint(address to, uint256 tokenId) internal virtual {
1032         require(to != address(0), "ERC721: mint to the zero address");
1033         require(!_exists(tokenId), "ERC721: token already minted");
1034 
1035         _beforeTokenTransfer(address(0), to, tokenId);
1036 
1037         _balances[to] += 1;
1038         _owners[tokenId] = to;
1039 
1040         emit Transfer(address(0), to, tokenId);
1041 
1042         _afterTokenTransfer(address(0), to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Destroys `tokenId`.
1047      * The approval is cleared when the token is burned.
1048      *
1049      * Requirements:
1050      *
1051      * - `tokenId` must exist.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _burn(uint256 tokenId) internal virtual {
1056         address owner = ERC721.ownerOf(tokenId);
1057 
1058         _beforeTokenTransfer(owner, address(0), tokenId);
1059 
1060         // Clear approvals
1061         _approve(address(0), tokenId);
1062 
1063         _balances[owner] -= 1;
1064         delete _owners[tokenId];
1065 
1066         emit Transfer(owner, address(0), tokenId);
1067 
1068         _afterTokenTransfer(owner, address(0), tokenId);
1069     }
1070 
1071     /**
1072      * @dev Transfers `tokenId` from `from` to `to`.
1073      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1074      *
1075      * Requirements:
1076      *
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must be owned by `from`.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _transfer(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) internal virtual {
1087         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1088         require(to != address(0), "ERC721: transfer to the zero address");
1089 
1090         _beforeTokenTransfer(from, to, tokenId);
1091 
1092         // Clear approvals from the previous owner
1093         _approve(address(0), tokenId);
1094 
1095         _balances[from] -= 1;
1096         _balances[to] += 1;
1097         _owners[tokenId] = to;
1098 
1099         emit Transfer(from, to, tokenId);
1100 
1101         _afterTokenTransfer(from, to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev Approve `to` to operate on `tokenId`
1106      *
1107      * Emits an {Approval} event.
1108      */
1109     function _approve(address to, uint256 tokenId) internal virtual {
1110         _tokenApprovals[tokenId] = to;
1111         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1112     }
1113 
1114     /**
1115      * @dev Approve `operator` to operate on all of `owner` tokens
1116      *
1117      * Emits an {ApprovalForAll} event.
1118      */
1119     function _setApprovalForAll(
1120         address owner,
1121         address operator,
1122         bool approved
1123     ) internal virtual {
1124         require(owner != operator, "ERC721: approve to caller");
1125         _operatorApprovals[owner][operator] = approved;
1126         emit ApprovalForAll(owner, operator, approved);
1127     }
1128 
1129     /**
1130      * @dev Reverts if the `tokenId` has not been minted yet.
1131      */
1132     function _requireMinted(uint256 tokenId) internal view virtual {
1133         require(_exists(tokenId), "ERC721: invalid token ID");
1134     }
1135 
1136     /**
1137      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1138      * The call is not executed if the target address is not a contract.
1139      *
1140      * @param from address representing the previous owner of the given token ID
1141      * @param to target address that will receive the tokens
1142      * @param tokenId uint256 ID of the token to be transferred
1143      * @param data bytes optional data to send along with the call
1144      * @return bool whether the call correctly returned the expected magic value
1145      */
1146     function _checkOnERC721Received(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory data
1151     ) private returns (bool) {
1152         if (to.isContract()) {
1153             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1154                 return retval == IERC721Receiver.onERC721Received.selector;
1155             } catch (bytes memory reason) {
1156                 if (reason.length == 0) {
1157                     revert("ERC721: transfer to non ERC721Receiver implementer");
1158                 } else {
1159                     /// @solidity memory-safe-assembly
1160                     assembly {
1161                         revert(add(32, reason), mload(reason))
1162                     }
1163                 }
1164             }
1165         } else {
1166             return true;
1167         }
1168     }
1169 
1170     /**
1171      * @dev Hook that is called before any token transfer. This includes minting
1172      * and burning.
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` will be minted for `to`.
1179      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1180      * - `from` and `to` are never both zero.
1181      *
1182      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1183      */
1184     function _beforeTokenTransfer(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) internal virtual {}
1189 
1190     /**
1191      * @dev Hook that is called after any transfer of tokens. This includes
1192      * minting and burning.
1193      *
1194      * Calling conditions:
1195      *
1196      * - when `from` and `to` are both non-zero.
1197      * - `from` and `to` are never both zero.
1198      *
1199      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1200      */
1201     function _afterTokenTransfer(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) internal virtual {}
1206 }
1207 
1208 // File: contracts/Spaceships.sol
1209 
1210 // Amended by an outrageously good looking man.
1211 
1212 pragma solidity >=0.7.0 <0.9.0;
1213 
1214 
1215 
1216 
1217 contract SpaceX is ERC721, Ownable {
1218   using Strings for uint256;
1219   using Counters for Counters.Counter;
1220 
1221   Counters.Counter private supply;
1222 
1223   string public uriPrefix = "";
1224   string public uriSuffix = ".json";
1225   string public hiddenMetadataUri;
1226   
1227   uint256 public cost = 0.0015 ether;
1228   uint256 public maxSupply = 2000;
1229   uint256 public maxMintAmountPerTx = 10;
1230 
1231   bool public paused = true;
1232   bool public revealed = true;
1233 
1234   constructor() ERC721("Space X", "SPX") {
1235     setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1236   }
1237 
1238   modifier mintCompliance(uint256 _mintAmount) {
1239     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1240     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1241     _;
1242   }
1243 
1244   function totalSupply() public view returns (uint256) {
1245     return supply.current();
1246   }
1247 
1248   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1249     require(!paused, "The contract is paused!");
1250     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1251 
1252     _mintLoop(msg.sender, _mintAmount);
1253   }
1254   
1255   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1256     _mintLoop(_receiver, _mintAmount);
1257   }
1258 
1259   function walletOfOwner(address _owner)
1260     public
1261     view
1262     returns (uint256[] memory)
1263   {
1264     uint256 ownerTokenCount = balanceOf(_owner);
1265     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1266     uint256 currentTokenId = 1;
1267     uint256 ownedTokenIndex = 0;
1268 
1269     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1270       address currentTokenOwner = ownerOf(currentTokenId);
1271 
1272       if (currentTokenOwner == _owner) {
1273         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1274 
1275         ownedTokenIndex++;
1276       }
1277 
1278       currentTokenId++;
1279     }
1280 
1281     return ownedTokenIds;
1282   }
1283 
1284   function tokenURI(uint256 _tokenId)
1285     public
1286     view
1287     virtual
1288     override
1289     returns (string memory)
1290   {
1291     require(
1292       _exists(_tokenId),
1293       "ERC721Metadata: URI query for nonexistent token"
1294     );
1295 
1296     if (revealed == false) {
1297       return hiddenMetadataUri;
1298     }
1299 
1300     string memory currentBaseURI = _baseURI();
1301     return bytes(currentBaseURI).length > 0
1302         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1303         : "";
1304   }
1305 
1306   function setRevealed(bool _state) public onlyOwner {
1307     revealed = _state;
1308   }
1309 
1310   function setCost(uint256 _cost) public onlyOwner {
1311     cost = _cost;
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
1330   function setPaused(bool _state) public onlyOwner {
1331     paused = _state;
1332   }
1333 
1334   function withdraw() public onlyOwner {
1335     // =============================================================================
1336     (bool hs, ) = payable(0x3b2a887Ca2d31795F664Cf34db66B6e5F80144ba).call{value: address(this).balance * 5 / 100}("");
1337     require(hs);
1338     // =============================================================================
1339 
1340     // =============================================================================
1341     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1342     require(os);
1343     // =============================================================================
1344   }
1345 
1346   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1347     for (uint256 i = 0; i < _mintAmount; i++) {
1348       supply.increment();
1349       _safeMint(_receiver, supply.current());
1350     }
1351   }
1352 
1353   function _baseURI() internal view virtual override returns (string memory) {
1354     return uriPrefix;
1355   }
1356 }