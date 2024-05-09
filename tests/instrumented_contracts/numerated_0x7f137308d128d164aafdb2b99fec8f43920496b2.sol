1 // ╔═══╦╗─╔╦═══╦═══╦╗──╔╗╔═══╦═══╦╗╔╗╔╦═══╦═══╗
2 // ║╔═╗║║─║╠╗╔╗║╔═╗║╚╗╔╝║║╔═╗║╔═╗║║║║║║╔══╣╔═╗║
3 // ║╚═╝║║─║║║║║║╚══╬╗╚╝╔╝║╚═╝║║─║║║║║║║╚══╣╚═╝║
4 // ║╔══╣║─║║║║║╠══╗║╚╗╔╝─║╔══╣║─║║╚╝╚╝║╔══╣╔╗╔╝
5 // ║║──║╚═╝╠╝╚╝║╚═╝║─║║──║║──║╚═╝╠╗╔╗╔╣╚══╣║║╚╗
6 // ╚╝──╚═══╩═══╩═══╝─╚╝──╚╝──╚═══╝╚╝╚╝╚═══╩╝╚═╝
7 
8 // SPDX-License-Identifier: MIT
9 
10 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
11 
12 
13 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Contract module that helps prevent reentrant calls to a function.
19  *
20  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
21  * available, which can be applied to functions to make sure there are no nested
22  * (reentrant) calls to them.
23  *
24  * Note that because there is a single `nonReentrant` guard, functions marked as
25  * `nonReentrant` may not call one another. This can be worked around by making
26  * those functions `private`, and then adding `external` `nonReentrant` entry
27  * points to them.
28  *
29  * TIP: If you would like to learn more about reentrancy and alternative ways
30  * to protect against it, check out our blog post
31  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
32  */
33 abstract contract ReentrancyGuard {
34     // Booleans are more expensive than uint256 or any type that takes up a full
35     // word because each write operation emits an extra SLOAD to first read the
36     // slot's contents, replace the bits taken up by the boolean, and then write
37     // back. This is the compiler's defense against contract upgrades and
38     // pointer aliasing, and it cannot be disabled.
39 
40     // The values being non-zero value makes deployment a bit more expensive,
41     // but in exchange the refund on every call to nonReentrant will be lower in
42     // amount. Since refunds are capped to a percentage of the total
43     // transaction's gas, it is best to keep them low in cases like this one, to
44     // increase the likelihood of the full refund coming into effect.
45     uint256 private constant _NOT_ENTERED = 1;
46     uint256 private constant _ENTERED = 2;
47 
48     uint256 private _status;
49 
50     constructor() {
51         _status = _NOT_ENTERED;
52     }
53 
54     /**
55      * @dev Prevents a contract from calling itself, directly or indirectly.
56      * Calling a `nonReentrant` function from another `nonReentrant`
57      * function is not supported. It is possible to prevent this from happening
58      * by making the `nonReentrant` function external, and making it call a
59      * `private` function that does the actual work.
60      */
61     modifier nonReentrant() {
62         // On the first call to nonReentrant, _notEntered will be true
63         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
64 
65         // Any calls to nonReentrant after this point will fail
66         _status = _ENTERED;
67 
68         _;
69 
70         // By storing the original value once again, a refund is triggered (see
71         // https://eips.ethereum.org/EIPS/eip-2200)
72         _status = _NOT_ENTERED;
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Counters.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @title Counters
85  * @author Matt Condon (@shrugs)
86  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
87  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
88  *
89  * Include with `using Counters for Counters.Counter;`
90  */
91 library Counters {
92     struct Counter {
93         // This variable should never be directly accessed by users of the library: interactions must be restricted to
94         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
95         // this feature: see https://github.com/ethereum/solidity/issues/4637
96         uint256 _value; // default: 0
97     }
98 
99     function current(Counter storage counter) internal view returns (uint256) {
100         return counter._value;
101     }
102 
103     function increment(Counter storage counter) internal {
104         unchecked {
105             counter._value += 1;
106         }
107     }
108 
109     function decrement(Counter storage counter) internal {
110         uint256 value = counter._value;
111         require(value > 0, "Counter: decrement overflow");
112         unchecked {
113             counter._value = value - 1;
114         }
115     }
116 
117     function reset(Counter storage counter) internal {
118         counter._value = 0;
119     }
120 }
121 
122 // File: @openzeppelin/contracts/utils/Strings.sol
123 
124 
125 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev String operations.
131  */
132 library Strings {
133     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
134 
135     /**
136      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
137      */
138     function toString(uint256 value) internal pure returns (string memory) {
139         // Inspired by OraclizeAPI's implementation - MIT licence
140         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
141 
142         if (value == 0) {
143             return "0";
144         }
145         uint256 temp = value;
146         uint256 digits;
147         while (temp != 0) {
148             digits++;
149             temp /= 10;
150         }
151         bytes memory buffer = new bytes(digits);
152         while (value != 0) {
153             digits -= 1;
154             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
155             value /= 10;
156         }
157         return string(buffer);
158     }
159 
160     /**
161      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
162      */
163     function toHexString(uint256 value) internal pure returns (string memory) {
164         if (value == 0) {
165             return "0x00";
166         }
167         uint256 temp = value;
168         uint256 length = 0;
169         while (temp != 0) {
170             length++;
171             temp >>= 8;
172         }
173         return toHexString(value, length);
174     }
175 
176     /**
177      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
178      */
179     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
180         bytes memory buffer = new bytes(2 * length + 2);
181         buffer[0] = "0";
182         buffer[1] = "x";
183         for (uint256 i = 2 * length + 1; i > 1; --i) {
184             buffer[i] = _HEX_SYMBOLS[value & 0xf];
185             value >>= 4;
186         }
187         require(value == 0, "Strings: hex length insufficient");
188         return string(buffer);
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Context.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Provides information about the current execution context, including the
201  * sender of the transaction and its data. While these are generally available
202  * via msg.sender and msg.data, they should not be accessed in such a direct
203  * manner, since when dealing with meta-transactions the account sending and
204  * paying for execution may not be the actual sender (as far as an application
205  * is concerned).
206  *
207  * This contract is only required for intermediate, library-like contracts.
208  */
209 abstract contract Context {
210     function _msgSender() internal view virtual returns (address) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view virtual returns (bytes calldata) {
215         return msg.data;
216     }
217 }
218 
219 // File: @openzeppelin/contracts/access/Ownable.sol
220 
221 
222 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 
227 /**
228  * @dev Contract module which provides a basic access control mechanism, where
229  * there is an account (an owner) that can be granted exclusive access to
230  * specific functions.
231  *
232  * By default, the owner account will be the one that deploys the contract. This
233  * can later be changed with {transferOwnership}.
234  *
235  * This module is used through inheritance. It will make available the modifier
236  * `onlyOwner`, which can be applied to your functions to restrict their use to
237  * the owner.
238  */
239 abstract contract Ownable is Context {
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244     /**
245      * @dev Initializes the contract setting the deployer as the initial owner.
246      */
247     constructor() {
248         _transferOwnership(_msgSender());
249     }
250 
251     /**
252      * @dev Returns the address of the current owner.
253      */
254     function owner() public view virtual returns (address) {
255         return _owner;
256     }
257 
258     /**
259      * @dev Throws if called by any account other than the owner.
260      */
261     modifier onlyOwner() {
262         require(owner() == _msgSender(), "Ownable: caller is not the owner");
263         _;
264     }
265 
266     /**
267      * @dev Leaves the contract without owner. It will not be possible to call
268      * `onlyOwner` functions anymore. Can only be called by the current owner.
269      *
270      * NOTE: Renouncing ownership will leave the contract without an owner,
271      * thereby removing any functionality that is only available to the owner.
272      */
273     function renounceOwnership() public virtual onlyOwner {
274         _transferOwnership(address(0));
275     }
276 
277     /**
278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
279      * Can only be called by the current owner.
280      */
281     function transferOwnership(address newOwner) public virtual onlyOwner {
282         require(newOwner != address(0), "Ownable: new owner is the zero address");
283         _transferOwnership(newOwner);
284     }
285 
286     /**
287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
288      * Internal function without access restriction.
289      */
290     function _transferOwnership(address newOwner) internal virtual {
291         address oldOwner = _owner;
292         _owner = newOwner;
293         emit OwnershipTransferred(oldOwner, newOwner);
294     }
295 }
296 
297 // File: @openzeppelin/contracts/utils/Address.sol
298 
299 
300 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
301 
302 pragma solidity ^0.8.1;
303 
304 /**
305  * @dev Collection of functions related to the address type
306  */
307 library Address {
308     /**
309      * @dev Returns true if `account` is a contract.
310      *
311      * [IMPORTANT]
312      * ====
313      * It is unsafe to assume that an address for which this function returns
314      * false is an externally-owned account (EOA) and not a contract.
315      *
316      * Among others, `isContract` will return false for the following
317      * types of addresses:
318      *
319      *  - an externally-owned account
320      *  - a contract in construction
321      *  - an address where a contract will be created
322      *  - an address where a contract lived, but was destroyed
323      * ====
324      *
325      * [IMPORTANT]
326      * ====
327      * You shouldn't rely on `isContract` to protect against flash loan attacks!
328      *
329      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
330      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
331      * constructor.
332      * ====
333      */
334     function isContract(address account) internal view returns (bool) {
335         // This method relies on extcodesize/address.code.length, which returns 0
336         // for contracts in construction, since the code is only stored at the end
337         // of the constructor execution.
338 
339         return account.code.length > 0;
340     }
341 
342     /**
343      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
344      * `recipient`, forwarding all available gas and reverting on errors.
345      *
346      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
347      * of certain opcodes, possibly making contracts go over the 2300 gas limit
348      * imposed by `transfer`, making them unable to receive funds via
349      * `transfer`. {sendValue} removes this limitation.
350      *
351      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
352      *
353      * IMPORTANT: because control is transferred to `recipient`, care must be
354      * taken to not create reentrancy vulnerabilities. Consider using
355      * {ReentrancyGuard} or the
356      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
357      */
358     function sendValue(address payable recipient, uint256 amount) internal {
359         require(address(this).balance >= amount, "Address: insufficient balance");
360 
361         (bool success, ) = recipient.call{value: amount}("");
362         require(success, "Address: unable to send value, recipient may have reverted");
363     }
364 
365     /**
366      * @dev Performs a Solidity function call using a low level `call`. A
367      * plain `call` is an unsafe replacement for a function call: use this
368      * function instead.
369      *
370      * If `target` reverts with a revert reason, it is bubbled up by this
371      * function (like regular Solidity function calls).
372      *
373      * Returns the raw returned data. To convert to the expected return value,
374      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
375      *
376      * Requirements:
377      *
378      * - `target` must be a contract.
379      * - calling `target` with `data` must not revert.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
384         return functionCall(target, data, "Address: low-level call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
389      * `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(
394         address target,
395         bytes memory data,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         return functionCallWithValue(target, data, 0, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but also transferring `value` wei to `target`.
404      *
405      * Requirements:
406      *
407      * - the calling contract must have an ETH balance of at least `value`.
408      * - the called Solidity function must be `payable`.
409      *
410      * _Available since v3.1._
411      */
412     function functionCallWithValue(
413         address target,
414         bytes memory data,
415         uint256 value
416     ) internal returns (bytes memory) {
417         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
422      * with `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCallWithValue(
427         address target,
428         bytes memory data,
429         uint256 value,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         require(address(this).balance >= value, "Address: insufficient balance for call");
433         require(isContract(target), "Address: call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.call{value: value}(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a static call.
442      *
443      * _Available since v3.3._
444      */
445     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
446         return functionStaticCall(target, data, "Address: low-level static call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal view returns (bytes memory) {
460         require(isContract(target), "Address: static call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.staticcall(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but performing a delegate call.
469      *
470      * _Available since v3.4._
471      */
472     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
473         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478      * but performing a delegate call.
479      *
480      * _Available since v3.4._
481      */
482     function functionDelegateCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal returns (bytes memory) {
487         require(isContract(target), "Address: delegate call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.delegatecall(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
495      * revert reason using the provided one.
496      *
497      * _Available since v4.3._
498      */
499     function verifyCallResult(
500         bool success,
501         bytes memory returndata,
502         string memory errorMessage
503     ) internal pure returns (bytes memory) {
504         if (success) {
505             return returndata;
506         } else {
507             // Look for revert reason and bubble it up if present
508             if (returndata.length > 0) {
509                 // The easiest way to bubble the revert reason is using memory via assembly
510 
511                 assembly {
512                     let returndata_size := mload(returndata)
513                     revert(add(32, returndata), returndata_size)
514                 }
515             } else {
516                 revert(errorMessage);
517             }
518         }
519     }
520 }
521 
522 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
523 
524 
525 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @title ERC721 token receiver interface
531  * @dev Interface for any contract that wants to support safeTransfers
532  * from ERC721 asset contracts.
533  */
534 interface IERC721Receiver {
535     /**
536      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
537      * by `operator` from `from`, this function is called.
538      *
539      * It must return its Solidity selector to confirm the token transfer.
540      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
541      *
542      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
543      */
544     function onERC721Received(
545         address operator,
546         address from,
547         uint256 tokenId,
548         bytes calldata data
549     ) external returns (bytes4);
550 }
551 
552 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @dev Interface of the ERC165 standard, as defined in the
561  * https://eips.ethereum.org/EIPS/eip-165[EIP].
562  *
563  * Implementers can declare support of contract interfaces, which can then be
564  * queried by others ({ERC165Checker}).
565  *
566  * For an implementation, see {ERC165}.
567  */
568 interface IERC165 {
569     /**
570      * @dev Returns true if this contract implements the interface defined by
571      * `interfaceId`. See the corresponding
572      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
573      * to learn more about how these ids are created.
574      *
575      * This function call must use less than 30 000 gas.
576      */
577     function supportsInterface(bytes4 interfaceId) external view returns (bool);
578 }
579 
580 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
581 
582 
583 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 /**
589  * @dev Implementation of the {IERC165} interface.
590  *
591  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
592  * for the additional interface id that will be supported. For example:
593  *
594  * ```solidity
595  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
596  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
597  * }
598  * ```
599  *
600  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
601  */
602 abstract contract ERC165 is IERC165 {
603     /**
604      * @dev See {IERC165-supportsInterface}.
605      */
606     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
607         return interfaceId == type(IERC165).interfaceId;
608     }
609 }
610 
611 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
612 
613 
614 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
615 
616 pragma solidity ^0.8.0;
617 
618 
619 /**
620  * @dev Required interface of an ERC721 compliant contract.
621  */
622 interface IERC721 is IERC165 {
623     /**
624      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
625      */
626     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
627 
628     /**
629      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
630      */
631     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
632 
633     /**
634      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
635      */
636     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
637 
638     /**
639      * @dev Returns the number of tokens in ``owner``'s account.
640      */
641     function balanceOf(address owner) external view returns (uint256 balance);
642 
643     /**
644      * @dev Returns the owner of the `tokenId` token.
645      *
646      * Requirements:
647      *
648      * - `tokenId` must exist.
649      */
650     function ownerOf(uint256 tokenId) external view returns (address owner);
651 
652     /**
653      * @dev Safely transfers `tokenId` token from `from` to `to`.
654      *
655      * Requirements:
656      *
657      * - `from` cannot be the zero address.
658      * - `to` cannot be the zero address.
659      * - `tokenId` token must exist and be owned by `from`.
660      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
661      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
662      *
663      * Emits a {Transfer} event.
664      */
665     function safeTransferFrom(
666         address from,
667         address to,
668         uint256 tokenId,
669         bytes calldata data
670     ) external;
671 
672     /**
673      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
674      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
675      *
676      * Requirements:
677      *
678      * - `from` cannot be the zero address.
679      * - `to` cannot be the zero address.
680      * - `tokenId` token must exist and be owned by `from`.
681      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
682      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
683      *
684      * Emits a {Transfer} event.
685      */
686     function safeTransferFrom(
687         address from,
688         address to,
689         uint256 tokenId
690     ) external;
691 
692     /**
693      * @dev Transfers `tokenId` token from `from` to `to`.
694      *
695      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
696      *
697      * Requirements:
698      *
699      * - `from` cannot be the zero address.
700      * - `to` cannot be the zero address.
701      * - `tokenId` token must be owned by `from`.
702      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
703      *
704      * Emits a {Transfer} event.
705      */
706     function transferFrom(
707         address from,
708         address to,
709         uint256 tokenId
710     ) external;
711 
712     /**
713      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
714      * The approval is cleared when the token is transferred.
715      *
716      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
717      *
718      * Requirements:
719      *
720      * - The caller must own the token or be an approved operator.
721      * - `tokenId` must exist.
722      *
723      * Emits an {Approval} event.
724      */
725     function approve(address to, uint256 tokenId) external;
726 
727     /**
728      * @dev Approve or remove `operator` as an operator for the caller.
729      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
730      *
731      * Requirements:
732      *
733      * - The `operator` cannot be the caller.
734      *
735      * Emits an {ApprovalForAll} event.
736      */
737     function setApprovalForAll(address operator, bool _approved) external;
738 
739     /**
740      * @dev Returns the account approved for `tokenId` token.
741      *
742      * Requirements:
743      *
744      * - `tokenId` must exist.
745      */
746     function getApproved(uint256 tokenId) external view returns (address operator);
747 
748     /**
749      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
750      *
751      * See {setApprovalForAll}
752      */
753     function isApprovedForAll(address owner, address operator) external view returns (bool);
754 }
755 
756 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
757 
758 
759 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
760 
761 pragma solidity ^0.8.0;
762 
763 
764 /**
765  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
766  * @dev See https://eips.ethereum.org/EIPS/eip-721
767  */
768 interface IERC721Metadata is IERC721 {
769     /**
770      * @dev Returns the token collection name.
771      */
772     function name() external view returns (string memory);
773 
774     /**
775      * @dev Returns the token collection symbol.
776      */
777     function symbol() external view returns (string memory);
778 
779     /**
780      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
781      */
782     function tokenURI(uint256 tokenId) external view returns (string memory);
783 }
784 
785 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
786 
787 
788 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
789 
790 pragma solidity ^0.8.0;
791 
792 
793 
794 
795 
796 
797 
798 
799 /**
800  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
801  * the Metadata extension, but not including the Enumerable extension, which is available separately as
802  * {ERC721Enumerable}.
803  */
804 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
805     using Address for address;
806     using Strings for uint256;
807 
808     // Token name
809     string private _name;
810 
811     // Token symbol
812     string private _symbol;
813 
814     // Mapping from token ID to owner address
815     mapping(uint256 => address) private _owners;
816 
817     // Mapping owner address to token count
818     mapping(address => uint256) private _balances;
819 
820     // Mapping from token ID to approved address
821     mapping(uint256 => address) private _tokenApprovals;
822 
823     // Mapping from owner to operator approvals
824     mapping(address => mapping(address => bool)) private _operatorApprovals;
825 
826     /**
827      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
828      */
829     constructor(string memory name_, string memory symbol_) {
830         _name = name_;
831         _symbol = symbol_;
832     }
833 
834     /**
835      * @dev See {IERC165-supportsInterface}.
836      */
837     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
838         return
839             interfaceId == type(IERC721).interfaceId ||
840             interfaceId == type(IERC721Metadata).interfaceId ||
841             super.supportsInterface(interfaceId);
842     }
843 
844     /**
845      * @dev See {IERC721-balanceOf}.
846      */
847     function balanceOf(address owner) public view virtual override returns (uint256) {
848         require(owner != address(0), "ERC721: balance query for the zero address");
849         return _balances[owner];
850     }
851 
852     /**
853      * @dev See {IERC721-ownerOf}.
854      */
855     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
856         address owner = _owners[tokenId];
857         require(owner != address(0), "ERC721: owner query for nonexistent token");
858         return owner;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-name}.
863      */
864     function name() public view virtual override returns (string memory) {
865         return _name;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-symbol}.
870      */
871     function symbol() public view virtual override returns (string memory) {
872         return _symbol;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-tokenURI}.
877      */
878     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
879         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
880 
881         string memory baseURI = _baseURI();
882         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
883     }
884 
885     /**
886      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
887      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
888      * by default, can be overridden in child contracts.
889      */
890     function _baseURI() internal view virtual returns (string memory) {
891         return "";
892     }
893 
894     /**
895      * @dev See {IERC721-approve}.
896      */
897     function approve(address to, uint256 tokenId) public virtual override {
898         address owner = ERC721.ownerOf(tokenId);
899         require(to != owner, "ERC721: approval to current owner");
900 
901         require(
902             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
903             "ERC721: approve caller is not owner nor approved for all"
904         );
905 
906         _approve(to, tokenId);
907     }
908 
909     /**
910      * @dev See {IERC721-getApproved}.
911      */
912     function getApproved(uint256 tokenId) public view virtual override returns (address) {
913         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
914 
915         return _tokenApprovals[tokenId];
916     }
917 
918     /**
919      * @dev See {IERC721-setApprovalForAll}.
920      */
921     function setApprovalForAll(address operator, bool approved) public virtual override {
922         _setApprovalForAll(_msgSender(), operator, approved);
923     }
924 
925     /**
926      * @dev See {IERC721-isApprovedForAll}.
927      */
928     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
929         return _operatorApprovals[owner][operator];
930     }
931 
932     /**
933      * @dev See {IERC721-transferFrom}.
934      */
935     function transferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) public virtual override {
940         //solhint-disable-next-line max-line-length
941         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
942 
943         _transfer(from, to, tokenId);
944     }
945 
946     /**
947      * @dev See {IERC721-safeTransferFrom}.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId
953     ) public virtual override {
954         safeTransferFrom(from, to, tokenId, "");
955     }
956 
957     /**
958      * @dev See {IERC721-safeTransferFrom}.
959      */
960     function safeTransferFrom(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) public virtual override {
966         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
967         _safeTransfer(from, to, tokenId, _data);
968     }
969 
970     /**
971      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
972      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
973      *
974      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
975      *
976      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
977      * implement alternative mechanisms to perform token transfer, such as signature-based.
978      *
979      * Requirements:
980      *
981      * - `from` cannot be the zero address.
982      * - `to` cannot be the zero address.
983      * - `tokenId` token must exist and be owned by `from`.
984      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _safeTransfer(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) internal virtual {
994         _transfer(from, to, tokenId);
995         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
996     }
997 
998     /**
999      * @dev Returns whether `tokenId` exists.
1000      *
1001      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1002      *
1003      * Tokens start existing when they are minted (`_mint`),
1004      * and stop existing when they are burned (`_burn`).
1005      */
1006     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1007         return _owners[tokenId] != address(0);
1008     }
1009 
1010     /**
1011      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1012      *
1013      * Requirements:
1014      *
1015      * - `tokenId` must exist.
1016      */
1017     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1018         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1019         address owner = ERC721.ownerOf(tokenId);
1020         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1021     }
1022 
1023     /**
1024      * @dev Safely mints `tokenId` and transfers it to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `tokenId` must not exist.
1029      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function _safeMint(address to, uint256 tokenId) internal virtual {
1034         _safeMint(to, tokenId, "");
1035     }
1036 
1037     /**
1038      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1039      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1040      */
1041     function _safeMint(
1042         address to,
1043         uint256 tokenId,
1044         bytes memory _data
1045     ) internal virtual {
1046         _mint(to, tokenId);
1047         require(
1048             _checkOnERC721Received(address(0), to, tokenId, _data),
1049             "ERC721: transfer to non ERC721Receiver implementer"
1050         );
1051     }
1052 
1053     /**
1054      * @dev Mints `tokenId` and transfers it to `to`.
1055      *
1056      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must not exist.
1061      * - `to` cannot be the zero address.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _mint(address to, uint256 tokenId) internal virtual {
1066         require(to != address(0), "ERC721: mint to the zero address");
1067         require(!_exists(tokenId), "ERC721: token already minted");
1068 
1069         _beforeTokenTransfer(address(0), to, tokenId);
1070 
1071         _balances[to] += 1;
1072         _owners[tokenId] = to;
1073 
1074         emit Transfer(address(0), to, tokenId);
1075 
1076         _afterTokenTransfer(address(0), to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Destroys `tokenId`.
1081      * The approval is cleared when the token is burned.
1082      *
1083      * Requirements:
1084      *
1085      * - `tokenId` must exist.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _burn(uint256 tokenId) internal virtual {
1090         address owner = ERC721.ownerOf(tokenId);
1091 
1092         _beforeTokenTransfer(owner, address(0), tokenId);
1093 
1094         // Clear approvals
1095         _approve(address(0), tokenId);
1096 
1097         _balances[owner] -= 1;
1098         delete _owners[tokenId];
1099 
1100         emit Transfer(owner, address(0), tokenId);
1101 
1102         _afterTokenTransfer(owner, address(0), tokenId);
1103     }
1104 
1105     /**
1106      * @dev Transfers `tokenId` from `from` to `to`.
1107      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      * - `tokenId` token must be owned by `from`.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _transfer(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) internal virtual {
1121         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1122         require(to != address(0), "ERC721: transfer to the zero address");
1123 
1124         _beforeTokenTransfer(from, to, tokenId);
1125 
1126         // Clear approvals from the previous owner
1127         _approve(address(0), tokenId);
1128 
1129         _balances[from] -= 1;
1130         _balances[to] += 1;
1131         _owners[tokenId] = to;
1132 
1133         emit Transfer(from, to, tokenId);
1134 
1135         _afterTokenTransfer(from, to, tokenId);
1136     }
1137 
1138     /**
1139      * @dev Approve `to` to operate on `tokenId`
1140      *
1141      * Emits a {Approval} event.
1142      */
1143     function _approve(address to, uint256 tokenId) internal virtual {
1144         _tokenApprovals[tokenId] = to;
1145         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev Approve `operator` to operate on all of `owner` tokens
1150      *
1151      * Emits a {ApprovalForAll} event.
1152      */
1153     function _setApprovalForAll(
1154         address owner,
1155         address operator,
1156         bool approved
1157     ) internal virtual {
1158         require(owner != operator, "ERC721: approve to caller");
1159         _operatorApprovals[owner][operator] = approved;
1160         emit ApprovalForAll(owner, operator, approved);
1161     }
1162 
1163     /**
1164      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1165      * The call is not executed if the target address is not a contract.
1166      *
1167      * @param from address representing the previous owner of the given token ID
1168      * @param to target address that will receive the tokens
1169      * @param tokenId uint256 ID of the token to be transferred
1170      * @param _data bytes optional data to send along with the call
1171      * @return bool whether the call correctly returned the expected magic value
1172      */
1173     function _checkOnERC721Received(
1174         address from,
1175         address to,
1176         uint256 tokenId,
1177         bytes memory _data
1178     ) private returns (bool) {
1179         if (to.isContract()) {
1180             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1181                 return retval == IERC721Receiver.onERC721Received.selector;
1182             } catch (bytes memory reason) {
1183                 if (reason.length == 0) {
1184                     revert("ERC721: transfer to non ERC721Receiver implementer");
1185                 } else {
1186                     assembly {
1187                         revert(add(32, reason), mload(reason))
1188                     }
1189                 }
1190             }
1191         } else {
1192             return true;
1193         }
1194     }
1195 
1196     /**
1197      * @dev Hook that is called before any token transfer. This includes minting
1198      * and burning.
1199      *
1200      * Calling conditions:
1201      *
1202      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1203      * transferred to `to`.
1204      * - When `from` is zero, `tokenId` will be minted for `to`.
1205      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1206      * - `from` and `to` are never both zero.
1207      *
1208      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1209      */
1210     function _beforeTokenTransfer(
1211         address from,
1212         address to,
1213         uint256 tokenId
1214     ) internal virtual {}
1215 
1216     /**
1217      * @dev Hook that is called after any transfer of tokens. This includes
1218      * minting and burning.
1219      *
1220      * Calling conditions:
1221      *
1222      * - when `from` and `to` are both non-zero.
1223      * - `from` and `to` are never both zero.
1224      *
1225      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1226      */
1227     function _afterTokenTransfer(
1228         address from,
1229         address to,
1230         uint256 tokenId
1231     ) internal virtual {}
1232 }
1233 
1234 
1235 pragma solidity >=0.7.0 <0.9.0;
1236 
1237 contract PudsyPower is ERC721, Ownable, ReentrancyGuard {
1238   using Strings for uint256;
1239   using Counters for Counters.Counter;
1240 
1241   Counters.Counter private supply;
1242   Counters.Counter private freeSupply;
1243 
1244   string public uriPrefix = "";
1245   string public uriSuffix = ".json";
1246   string public notRevealedUri;
1247 
1248   uint256 public cost = 0.1 ether;
1249   uint256 public maxSupply = 9999;
1250   uint256 public maxMintAmount = 1;
1251   uint256 public maxFreeSupply = 1111;
1252   bool public paused = false;
1253   bool public revealed = true;
1254 
1255 constructor( string memory _initUriPrefix) ERC721("PudsyPower", "PARROT") {
1256      setUriPrefix(_initUriPrefix);
1257   }
1258 
1259    modifier mintCompliance() {
1260     require(supply.current() + maxMintAmount <= maxSupply, "Max supply exceeded!");
1261     _;
1262   }
1263 
1264   //mint
1265   function mintParrot() external nonReentrant payable mintCompliance(){
1266     require(!paused, "The contract is paused!");
1267     if (msg.sender != owner()) {
1268       require(msg.value >= cost, "Insufficient funds!");
1269     }
1270     _mintLoop(msg.sender);
1271     }
1272 
1273    function freeMintParrot() external nonReentrant mintCompliance(){
1274     require(!paused, "The contract is paused!");
1275     require(freeSupply.current() + maxMintAmount <= maxFreeSupply, "Max free supply exceeded!");
1276      freeSupply.increment();
1277     _mintLoop(msg.sender);
1278     }
1279 
1280   function mintForAddress(address _receiver) external nonReentrant mintCompliance() onlyOwner {
1281     _mintLoop(_receiver);
1282   }
1283 
1284 // public
1285   function totalSupply() public view returns (uint256) {
1286     return supply.current();
1287   }
1288 
1289  function remainingFreeSupply() public view returns (uint256) {
1290       return maxFreeSupply - freeSupply.current();
1291   }
1292 
1293 
1294   function walletOfOwner(address _owner)
1295     public
1296     view
1297     returns (uint256[] memory)
1298   {
1299 
1300     uint256 ownerTokenCount = balanceOf(_owner);
1301     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1302     uint256 currentTokenId = 1;
1303     uint256 ownedTokenIndex = 0;
1304 
1305     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1306       address currentTokenOwner = ownerOf(currentTokenId);
1307 
1308       if (currentTokenOwner == _owner) {
1309         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1310 
1311         ownedTokenIndex++;
1312       }
1313 
1314       currentTokenId++;
1315     }
1316 
1317     return ownedTokenIds;
1318   }
1319 
1320   function tokenURI(uint256 tokenId)
1321     public
1322     view
1323     virtual
1324     override
1325     returns (string memory)
1326   {
1327     require(
1328       _exists(tokenId),
1329       "ERC721Metadata: URI query for nonexistent token"
1330     );
1331 
1332    if(revealed == false) {
1333         return notRevealedUri;
1334     }
1335 
1336     string memory currentBaseURI = _baseURI();
1337     return bytes(currentBaseURI).length > 0
1338         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), uriSuffix))
1339         : "";
1340   }
1341 
1342 
1343 
1344 // internal
1345   function _baseURI() internal view virtual override returns (string memory) {
1346     return uriPrefix;
1347   }
1348 
1349   function _mintLoop(address _receiver) internal {
1350       supply.increment();
1351       _safeMint(_receiver, supply.current());
1352   }
1353 
1354   //only owner
1355   function reveal() public onlyOwner {
1356       revealed = true;
1357   }
1358 
1359   function setRevealed(bool _state) public onlyOwner {
1360     revealed = _state;
1361   }
1362 
1363   function setCost(uint256 _newCost) public onlyOwner {
1364     cost = _newCost;
1365   }
1366 
1367   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1368     uriPrefix = _uriPrefix;
1369   }
1370 
1371   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1372     uriSuffix = _uriSuffix;
1373   }
1374 
1375   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1376     notRevealedUri = _notRevealedURI;
1377   }
1378 
1379   function pause(bool _state) public onlyOwner {
1380     paused = _state;
1381   }
1382 
1383   function withdraw() public payable onlyOwner {
1384     (bool os, ) = payable(msg.sender).call{value: address(this).balance}("");
1385     require(os);
1386   }
1387 }