1 // SPDX-License-Identifier: MIT
2 
3 //CryptoClitLips
4 //4200 Nfts
5 //Firsts 3K Free Mint - Others 0.0069
6 //................................................................................
7 //................................................................................
8 //................................................................................
9 //................................................................................
10 //....................@@@@.........................@@@@@,,,*@@....................
11 //................@(/**,,,,,,,,,@...............@.,,,,,,,,,*,*(@..................
12 //...............@/**,,,,,@%(,,%,,@...........@.,%,.((.@,,,,*,*/@................
13 //.............@(/,*,*,,,@...@...%.@...........%. (@.....@,,,**,*(................
14 //............(/*,,*,,,@.......@( %.@........%  /#........@,,,*,**(@..............
15 //...........@/*,,,,,@...........@@(//.@@@@//*(@.............@*,*,*/@.............
16 //...........@*,,*@..............@*,....@@....*//@.............@@/(/@.............
17 //............@..............@,,....*/...../.....@.. @............................
18 //........................@,..@.@@,,,,.........@@@@... @..........................
19 //......................@,...@,@.@..@......@.  .@..@.... @........................
20 //.....................@,.  @.@@. @  .....@.   .@..@..... ........................
21 //....................,.   ....@.   .@.....,@..@...... @.. @......................
22 //...................@. .,................@....... @.... @. @.....................
23 //...................@..,@..@..@,...  ....@@%#..... @.@.. . @.....................
24 //...................@..,@..@..&&(//& ....@%#@..  ... .@.@@.@.....................
25 //................&(((((((....((//((&......@.....  .. ....*@......................
26 //.................&(#((//////(((#&.........@....  .. ...,@.......................
27 //....................&((#((((&&,,,.........@........ .,/@........................
28 //..........................@@@@,,@,.......@,...... @,@...........................
29 //............................@,....@/.....@/*....*@,.@...........................
30 //.............................@,@...................@.@..........................
31 //.............................@,....................@.@..........................
32 //............................%...***................@@...........................
33 //................************%((((%%@**************@%..(%........................
34 //...........................@@*@@@@@..............@%%%%%%@.......................
35 //................................................................................
36 //................................................................................
37 //................................................................................
38 
39 
40 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
41 
42 pragma solidity ^0.8.0;
43 
44 /**
45  * @dev Contract module that helps prevent reentrant calls to a function.
46  *
47  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
48  * available, which can be applied to functions to make sure there are no nested
49  * (reentrant) calls to them.
50  *
51  * Note that because there is a single `nonReentrant` guard, functions marked as
52  * `nonReentrant` may not call one another. This can be worked around by making
53  * those functions `private`, and then adding `external` `nonReentrant` entry
54  * points to them.
55  *
56  * TIP: If you would like to learn more about reentrancy and alternative ways
57  * to protect against it, check out our blog post
58  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
59  */
60 abstract contract ReentrancyGuard {
61     // Booleans are more expensive than uint256 or any type that takes up a full
62     // word because each write operation emits an extra SLOAD to first read the
63     // slot's contents, replace the bits taken up by the boolean, and then write
64     // back. This is the compiler's defense against contract upgrades and
65     // pointer aliasing, and it cannot be disabled.
66 
67     // The values being non-zero value makes deployment a bit more expensive,
68     // but in exchange the refund on every call to nonReentrant will be lower in
69     // amount. Since refunds are capped to a percentage of the total
70     // transaction's gas, it is best to keep them low in cases like this one, to
71     // increase the likelihood of the full refund coming into effect.
72     uint256 private constant _NOT_ENTERED = 1;
73     uint256 private constant _ENTERED = 2;
74 
75     uint256 private _status;
76 
77     constructor() {
78         _status = _NOT_ENTERED;
79     }
80 
81     /**
82      * @dev Prevents a contract from calling itself, directly or indirectly.
83      * Calling a `nonReentrant` function from another `nonReentrant`
84      * function is not supported. It is possible to prevent this from happening
85      * by making the `nonReentrant` function external, and making it call a
86      * `private` function that does the actual work.
87      */
88     modifier nonReentrant() {
89         // On the first call to nonReentrant, _notEntered will be true
90         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
91 
92         // Any calls to nonReentrant after this point will fail
93         _status = _ENTERED;
94 
95         _;
96 
97         // By storing the original value once again, a refund is triggered (see
98         // https://eips.ethereum.org/EIPS/eip-2200)
99         _status = _NOT_ENTERED;
100     }
101 }
102 
103 // File: @openzeppelin/contracts/utils/Strings.sol
104 
105 
106 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev String operations.
112  */
113 library Strings {
114     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
115     uint8 private constant _ADDRESS_LENGTH = 20;
116 
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
119      */
120     function toString(uint256 value) internal pure returns (string memory) {
121         // Inspired by OraclizeAPI's implementation - MIT licence
122         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
123 
124         if (value == 0) {
125             return "0";
126         }
127         uint256 temp = value;
128         uint256 digits;
129         while (temp != 0) {
130             digits++;
131             temp /= 10;
132         }
133         bytes memory buffer = new bytes(digits);
134         while (value != 0) {
135             digits -= 1;
136             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
137             value /= 10;
138         }
139         return string(buffer);
140     }
141 
142     /**
143      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
144      */
145     function toHexString(uint256 value) internal pure returns (string memory) {
146         if (value == 0) {
147             return "0x00";
148         }
149         uint256 temp = value;
150         uint256 length = 0;
151         while (temp != 0) {
152             length++;
153             temp >>= 8;
154         }
155         return toHexString(value, length);
156     }
157 
158     /**
159      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
160      */
161     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
162         bytes memory buffer = new bytes(2 * length + 2);
163         buffer[0] = "0";
164         buffer[1] = "x";
165         for (uint256 i = 2 * length + 1; i > 1; --i) {
166             buffer[i] = _HEX_SYMBOLS[value & 0xf];
167             value >>= 4;
168         }
169         require(value == 0, "Strings: hex length insufficient");
170         return string(buffer);
171     }
172 
173     /**
174      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
175      */
176     function toHexString(address addr) internal pure returns (string memory) {
177         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
178     }
179 }
180 
181 // File: @openzeppelin/contracts/utils/Context.sol
182 
183 
184 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev Provides information about the current execution context, including the
190  * sender of the transaction and its data. While these are generally available
191  * via msg.sender and msg.data, they should not be accessed in such a direct
192  * manner, since when dealing with meta-transactions the account sending and
193  * paying for execution may not be the actual sender (as far as an application
194  * is concerned).
195  *
196  * This contract is only required for intermediate, library-like contracts.
197  */
198 abstract contract Context {
199     function _msgSender() internal view virtual returns (address) {
200         return msg.sender;
201     }
202 
203     function _msgData() internal view virtual returns (bytes calldata) {
204         return msg.data;
205     }
206 }
207 
208 // File: @openzeppelin/contracts/access/Ownable.sol
209 
210 
211 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 
216 /**
217  * @dev Contract module which provides a basic access control mechanism, where
218  * there is an account (an owner) that can be granted exclusive access to
219  * specific functions.
220  *
221  * By default, the owner account will be the one that deploys the contract. This
222  * can later be changed with {transferOwnership}.
223  *
224  * This module is used through inheritance. It will make available the modifier
225  * `onlyOwner`, which can be applied to your functions to restrict their use to
226  * the owner.
227  */
228 abstract contract Ownable is Context {
229     address private _owner;
230 
231     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
232 
233     /**
234      * @dev Initializes the contract setting the deployer as the initial owner.
235      */
236     constructor() {
237         _transferOwnership(_msgSender());
238     }
239 
240     /**
241      * @dev Throws if called by any account other than the owner.
242      */
243     modifier onlyOwner() {
244         _checkOwner();
245         _;
246     }
247 
248     /**
249      * @dev Returns the address of the current owner.
250      */
251     function owner() public view virtual returns (address) {
252         return _owner;
253     }
254 
255     /**
256      * @dev Throws if the sender is not the owner.
257      */
258     function _checkOwner() internal view virtual {
259         require(owner() == _msgSender(), "Ownable: caller is not the owner");
260     }
261 
262     /**
263      * @dev Leaves the contract without owner. It will not be possible to call
264      * `onlyOwner` functions anymore. Can only be called by the current owner.
265      *
266      * NOTE: Renouncing ownership will leave the contract without an owner,
267      * thereby removing any functionality that is only available to the owner.
268      */
269     function renounceOwnership() public virtual onlyOwner {
270         _transferOwnership(address(0));
271     }
272 
273     /**
274      * @dev Transfers ownership of the contract to a new account (`newOwner`).
275      * Can only be called by the current owner.
276      */
277     function transferOwnership(address newOwner) public virtual onlyOwner {
278         require(newOwner != address(0), "Ownable: new owner is the zero address");
279         _transferOwnership(newOwner);
280     }
281 
282     /**
283      * @dev Transfers ownership of the contract to a new account (`newOwner`).
284      * Internal function without access restriction.
285      */
286     function _transferOwnership(address newOwner) internal virtual {
287         address oldOwner = _owner;
288         _owner = newOwner;
289         emit OwnershipTransferred(oldOwner, newOwner);
290     }
291 }
292 
293 // File: @openzeppelin/contracts/utils/Address.sol
294 
295 
296 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
297 
298 pragma solidity ^0.8.1;
299 
300 /**
301  * @dev Collection of functions related to the address type
302  */
303 library Address {
304     /**
305      * @dev Returns true if `account` is a contract.
306      *
307      * [IMPORTANT]
308      * ====
309      * It is unsafe to assume that an address for which this function returns
310      * false is an externally-owned account (EOA) and not a contract.
311      *
312      * Among others, `isContract` will return false for the following
313      * types of addresses:
314      *
315      *  - an externally-owned account
316      *  - a contract in construction
317      *  - an address where a contract will be created
318      *  - an address where a contract lived, but was destroyed
319      * ====
320      *
321      * [IMPORTANT]
322      * ====
323      * You shouldn't rely on `isContract` to protect against flash loan attacks!
324      *
325      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
326      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
327      * constructor.
328      * ====
329      */
330     function isContract(address account) internal view returns (bool) {
331         // This method relies on extcodesize/address.code.length, which returns 0
332         // for contracts in construction, since the code is only stored at the end
333         // of the constructor execution.
334 
335         return account.code.length > 0;
336     }
337 
338     /**
339      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
340      * `recipient`, forwarding all available gas and reverting on errors.
341      *
342      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
343      * of certain opcodes, possibly making contracts go over the 2300 gas limit
344      * imposed by `transfer`, making them unable to receive funds via
345      * `transfer`. {sendValue} removes this limitation.
346      *
347      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
348      *
349      * IMPORTANT: because control is transferred to `recipient`, care must be
350      * taken to not create reentrancy vulnerabilities. Consider using
351      * {ReentrancyGuard} or the
352      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
353      */
354     function sendValue(address payable recipient, uint256 amount) internal {
355         require(address(this).balance >= amount, "Address: insufficient balance");
356 
357         (bool success, ) = recipient.call{value: amount}("");
358         require(success, "Address: unable to send value, recipient may have reverted");
359     }
360 
361     /**
362      * @dev Performs a Solidity function call using a low level `call`. A
363      * plain `call` is an unsafe replacement for a function call: use this
364      * function instead.
365      *
366      * If `target` reverts with a revert reason, it is bubbled up by this
367      * function (like regular Solidity function calls).
368      *
369      * Returns the raw returned data. To convert to the expected return value,
370      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
371      *
372      * Requirements:
373      *
374      * - `target` must be a contract.
375      * - calling `target` with `data` must not revert.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
380         return functionCall(target, data, "Address: low-level call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
385      * `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         return functionCallWithValue(target, data, 0, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but also transferring `value` wei to `target`.
400      *
401      * Requirements:
402      *
403      * - the calling contract must have an ETH balance of at least `value`.
404      * - the called Solidity function must be `payable`.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value
412     ) internal returns (bytes memory) {
413         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
418      * with `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(
423         address target,
424         bytes memory data,
425         uint256 value,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(address(this).balance >= value, "Address: insufficient balance for call");
429         require(isContract(target), "Address: call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.call{value: value}(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but performing a static call.
438      *
439      * _Available since v3.3._
440      */
441     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
442         return functionStaticCall(target, data, "Address: low-level static call failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(
452         address target,
453         bytes memory data,
454         string memory errorMessage
455     ) internal view returns (bytes memory) {
456         require(isContract(target), "Address: static call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.staticcall(data);
459         return verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
469         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(
479         address target,
480         bytes memory data,
481         string memory errorMessage
482     ) internal returns (bytes memory) {
483         require(isContract(target), "Address: delegate call to non-contract");
484 
485         (bool success, bytes memory returndata) = target.delegatecall(data);
486         return verifyCallResult(success, returndata, errorMessage);
487     }
488 
489     /**
490      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
491      * revert reason using the provided one.
492      *
493      * _Available since v4.3._
494      */
495     function verifyCallResult(
496         bool success,
497         bytes memory returndata,
498         string memory errorMessage
499     ) internal pure returns (bytes memory) {
500         if (success) {
501             return returndata;
502         } else {
503             // Look for revert reason and bubble it up if present
504             if (returndata.length > 0) {
505                 // The easiest way to bubble the revert reason is using memory via assembly
506                 /// @solidity memory-safe-assembly
507                 assembly {
508                     let returndata_size := mload(returndata)
509                     revert(add(32, returndata), returndata_size)
510                 }
511             } else {
512                 revert(errorMessage);
513             }
514         }
515     }
516 }
517 
518 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
519 
520 
521 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
522 
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @title ERC721 token receiver interface
527  * @dev Interface for any contract that wants to support safeTransfers
528  * from ERC721 asset contracts.
529  */
530 interface IERC721Receiver {
531     /**
532      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
533      * by `operator` from `from`, this function is called.
534      *
535      * It must return its Solidity selector to confirm the token transfer.
536      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
537      *
538      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
539      */
540     function onERC721Received(
541         address operator,
542         address from,
543         uint256 tokenId,
544         bytes calldata data
545     ) external returns (bytes4);
546 }
547 
548 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 /**
556  * @dev Interface of the ERC165 standard, as defined in the
557  * https://eips.ethereum.org/EIPS/eip-165[EIP].
558  *
559  * Implementers can declare support of contract interfaces, which can then be
560  * queried by others ({ERC165Checker}).
561  *
562  * For an implementation, see {ERC165}.
563  */
564 interface IERC165 {
565     /**
566      * @dev Returns true if this contract implements the interface defined by
567      * `interfaceId`. See the corresponding
568      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
569      * to learn more about how these ids are created.
570      *
571      * This function call must use less than 30 000 gas.
572      */
573     function supportsInterface(bytes4 interfaceId) external view returns (bool);
574 }
575 
576 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
577 
578 
579 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
580 
581 pragma solidity ^0.8.0;
582 
583 
584 /**
585  * @dev Implementation of the {IERC165} interface.
586  *
587  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
588  * for the additional interface id that will be supported. For example:
589  *
590  * ```solidity
591  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
592  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
593  * }
594  * ```
595  *
596  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
597  */
598 abstract contract ERC165 is IERC165 {
599     /**
600      * @dev See {IERC165-supportsInterface}.
601      */
602     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
603         return interfaceId == type(IERC165).interfaceId;
604     }
605 }
606 
607 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
608 
609 
610 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 
615 /**
616  * @dev Required interface of an ERC721 compliant contract.
617  */
618 interface IERC721 is IERC165 {
619     /**
620      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
621      */
622     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
623 
624     /**
625      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
626      */
627     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
628 
629     /**
630      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
631      */
632     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
633 
634     /**
635      * @dev Returns the number of tokens in ``owner``'s account.
636      */
637     function balanceOf(address owner) external view returns (uint256 balance);
638 
639     /**
640      * @dev Returns the owner of the `tokenId` token.
641      *
642      * Requirements:
643      *
644      * - `tokenId` must exist.
645      */
646     function ownerOf(uint256 tokenId) external view returns (address owner);
647 
648     /**
649      * @dev Safely transfers `tokenId` token from `from` to `to`.
650      *
651      * Requirements:
652      *
653      * - `from` cannot be the zero address.
654      * - `to` cannot be the zero address.
655      * - `tokenId` token must exist and be owned by `from`.
656      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
657      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
658      *
659      * Emits a {Transfer} event.
660      */
661     function safeTransferFrom(
662         address from,
663         address to,
664         uint256 tokenId,
665         bytes calldata data
666     ) external;
667 
668     /**
669      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
670      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
671      *
672      * Requirements:
673      *
674      * - `from` cannot be the zero address.
675      * - `to` cannot be the zero address.
676      * - `tokenId` token must exist and be owned by `from`.
677      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
678      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
679      *
680      * Emits a {Transfer} event.
681      */
682     function safeTransferFrom(
683         address from,
684         address to,
685         uint256 tokenId
686     ) external;
687 
688     /**
689      * @dev Transfers `tokenId` token from `from` to `to`.
690      *
691      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
692      *
693      * Requirements:
694      *
695      * - `from` cannot be the zero address.
696      * - `to` cannot be the zero address.
697      * - `tokenId` token must be owned by `from`.
698      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
699      *
700      * Emits a {Transfer} event.
701      */
702     function transferFrom(
703         address from,
704         address to,
705         uint256 tokenId
706     ) external;
707 
708     /**
709      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
710      * The approval is cleared when the token is transferred.
711      *
712      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
713      *
714      * Requirements:
715      *
716      * - The caller must own the token or be an approved operator.
717      * - `tokenId` must exist.
718      *
719      * Emits an {Approval} event.
720      */
721     function approve(address to, uint256 tokenId) external;
722 
723     /**
724      * @dev Approve or remove `operator` as an operator for the caller.
725      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
726      *
727      * Requirements:
728      *
729      * - The `operator` cannot be the caller.
730      *
731      * Emits an {ApprovalForAll} event.
732      */
733     function setApprovalForAll(address operator, bool _approved) external;
734 
735     /**
736      * @dev Returns the account approved for `tokenId` token.
737      *
738      * Requirements:
739      *
740      * - `tokenId` must exist.
741      */
742     function getApproved(uint256 tokenId) external view returns (address operator);
743 
744     /**
745      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
746      *
747      * See {setApprovalForAll}
748      */
749     function isApprovedForAll(address owner, address operator) external view returns (bool);
750 }
751 
752 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
753 
754 
755 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 
760 /**
761  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
762  * @dev See https://eips.ethereum.org/EIPS/eip-721
763  */
764 interface IERC721Metadata is IERC721 {
765     /**
766      * @dev Returns the token collection name.
767      */
768     function name() external view returns (string memory);
769 
770     /**
771      * @dev Returns the token collection symbol.
772      */
773     function symbol() external view returns (string memory);
774 
775     /**
776      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
777      */
778     function tokenURI(uint256 tokenId) external view returns (string memory);
779 }
780 
781 // File: contracts/ERC721A.sol
782 
783 
784 // Creator: Chiru Labs
785 
786 pragma solidity ^0.8.0;
787 
788 
789 
790 
791 
792 
793 
794 
795 /**
796  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
797  * the Metadata extension. Built to optimize for lower gas during batch mints.
798  *
799  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
800  *
801  * Does not support burning tokens to address(0).
802  *
803  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
804  */
805 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
806     using Address for address;
807     using Strings for uint256;
808 
809     struct TokenOwnership {
810         address addr;
811         uint64 startTimestamp;
812     }
813 
814     struct AddressData {
815         uint128 balance;
816         uint128 numberMinted;
817     }
818 
819     uint256 internal currentIndex;
820 
821     // Token name
822     string private _name;
823 
824     // Token symbol
825     string private _symbol;
826 
827     // Mapping from token ID to ownership details
828     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
829     mapping(uint256 => TokenOwnership) internal _ownerships;
830 
831     // Mapping owner address to address data
832     mapping(address => AddressData) private _addressData;
833 
834     // Mapping from token ID to approved address
835     mapping(uint256 => address) private _tokenApprovals;
836 
837     // Mapping from owner to operator approvals
838     mapping(address => mapping(address => bool)) private _operatorApprovals;
839 
840     constructor(string memory name_, string memory symbol_) {
841         _name = name_;
842         _symbol = symbol_;
843     }
844 
845     function totalSupply() public view returns (uint256) {
846         return currentIndex;
847     }
848 
849     /**
850      * @dev See {IERC165-supportsInterface}.
851      */
852     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
853         return
854         interfaceId == type(IERC721).interfaceId ||
855         interfaceId == type(IERC721Metadata).interfaceId ||
856         super.supportsInterface(interfaceId);
857     }
858 
859     /**
860      * @dev See {IERC721-balanceOf}.
861      */
862     function balanceOf(address owner) public view override returns (uint256) {
863         require(owner != address(0), 'ERC721A: balance query for the zero address');
864         return uint256(_addressData[owner].balance);
865     }
866 
867     function _numberMinted(address owner) internal view returns (uint256) {
868         require(owner != address(0), 'ERC721A: number minted query for the zero address');
869         return uint256(_addressData[owner].numberMinted);
870     }
871 
872     /**
873      * Gas spent here starts off proportional to the maximum mint batch size.
874      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
875      */
876     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
877         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
878 
879     unchecked {
880         for (uint256 curr = tokenId; curr >= 0; curr--) {
881             TokenOwnership memory ownership = _ownerships[curr];
882             if (ownership.addr != address(0)) {
883                 return ownership;
884             }
885         }
886     }
887 
888         revert('ERC721A: unable to determine the owner of token');
889     }
890 
891     /**
892      * @dev See {IERC721-ownerOf}.
893      */
894     function ownerOf(uint256 tokenId) public view override returns (address) {
895         return ownershipOf(tokenId).addr;
896     }
897 
898     /**
899      * @dev See {IERC721Metadata-name}.
900      */
901     function name() public view virtual override returns (string memory) {
902         return _name;
903     }
904 
905     /**
906      * @dev See {IERC721Metadata-symbol}.
907      */
908     function symbol() public view virtual override returns (string memory) {
909         return _symbol;
910     }
911 
912     /**
913      * @dev See {IERC721Metadata-tokenURI}.
914      */
915     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
916         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
917 
918         string memory baseURI = _baseURI();
919         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : '';
920     }
921 
922     /**
923      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
924      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
925      * by default, can be overriden in child contracts.
926      */
927     function _baseURI() internal view virtual returns (string memory) {
928         return '';
929     }
930 
931     /**
932      * @dev See {IERC721-approve}.
933      */
934     function approve(address to, uint256 tokenId) public override {
935         address owner = ERC721A.ownerOf(tokenId);
936         require(to != owner, 'ERC721A: approval to current owner');
937 
938         require(
939             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
940             'ERC721A: approve caller is not owner nor approved for all'
941         );
942 
943         _approve(to, tokenId, owner);
944     }
945 
946     /**
947      * @dev See {IERC721-getApproved}.
948      */
949     function getApproved(uint256 tokenId) public view override returns (address) {
950         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
951 
952         return _tokenApprovals[tokenId];
953     }
954 
955     /**
956      * @dev See {IERC721-setApprovalForAll}.
957      */
958     function setApprovalForAll(address operator, bool approved) public override {
959         require(operator != _msgSender(), 'ERC721A: approve to caller');
960 
961         _operatorApprovals[_msgSender()][operator] = approved;
962         emit ApprovalForAll(_msgSender(), operator, approved);
963     }
964 
965     /**
966      * @dev See {IERC721-isApprovedForAll}.
967      */
968     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
969         return _operatorApprovals[owner][operator];
970     }
971 
972     /**
973      * @dev See {IERC721-transferFrom}.
974      */
975     function transferFrom(
976         address from,
977         address to,
978         uint256 tokenId
979     ) public override {
980         _transfer(from, to, tokenId);
981     }
982 
983     /**
984      * @dev See {IERC721-safeTransferFrom}.
985      */
986     function safeTransferFrom(
987         address from,
988         address to,
989         uint256 tokenId
990     ) public override {
991         safeTransferFrom(from, to, tokenId, '');
992     }
993 
994     /**
995      * @dev See {IERC721-safeTransferFrom}.
996      */
997     function safeTransferFrom(
998         address from,
999         address to,
1000         uint256 tokenId,
1001         bytes memory _data
1002     ) public override {
1003         _transfer(from, to, tokenId);
1004         require(
1005             _checkOnERC721Received(from, to, tokenId, _data),
1006             'ERC721A: transfer to non ERC721Receiver implementer'
1007         );
1008     }
1009 
1010     /**
1011      * @dev Returns whether `tokenId` exists.
1012      *
1013      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1014      *
1015      * Tokens start existing when they are minted (`_mint`),
1016      */
1017     function _exists(uint256 tokenId) internal view returns (bool) {
1018         return tokenId < currentIndex;
1019     }
1020 
1021     function _safeMint(address to, uint256 quantity) internal {
1022         _safeMint(to, quantity, '');
1023     }
1024 
1025     /**
1026      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1031      * - `quantity` must be greater than 0.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _safeMint(
1036         address to,
1037         uint256 quantity,
1038         bytes memory _data
1039     ) internal {
1040         _mint(to, quantity, _data, true);
1041     }
1042 
1043     /**
1044      * @dev Mints `quantity` tokens and transfers them to `to`.
1045      *
1046      * Requirements:
1047      *
1048      * - `to` cannot be the zero address.
1049      * - `quantity` must be greater than 0.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _mint(
1054         address to,
1055         uint256 quantity,
1056         bytes memory _data,
1057         bool safe
1058     ) internal {
1059         uint256 startTokenId = currentIndex;
1060         require(to != address(0), 'ERC721A: mint to the zero address');
1061         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1062 
1063         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1064 
1065         // Overflows are incredibly unrealistic.
1066         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1067         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1068     unchecked {
1069         _addressData[to].balance += uint128(quantity);
1070         _addressData[to].numberMinted += uint128(quantity);
1071 
1072         _ownerships[startTokenId].addr = to;
1073         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1074 
1075         uint256 updatedIndex = startTokenId;
1076 
1077         for (uint256 i; i < quantity; i++) {
1078             emit Transfer(address(0), to, updatedIndex);
1079             if (safe) {
1080                 require(
1081                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
1082                     'ERC721A: transfer to non ERC721Receiver implementer'
1083                 );
1084             }
1085 
1086             updatedIndex++;
1087         }
1088 
1089         currentIndex = updatedIndex;
1090     }
1091 
1092         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1093     }
1094 
1095     /**
1096      * @dev Transfers `tokenId` from `from` to `to`.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `tokenId` token must be owned by `from`.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _transfer(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) private {
1110         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1111 
1112         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1113         getApproved(tokenId) == _msgSender() ||
1114         isApprovedForAll(prevOwnership.addr, _msgSender()));
1115 
1116         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1117 
1118         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1119         require(to != address(0), 'ERC721A: transfer to the zero address');
1120 
1121         _beforeTokenTransfers(from, to, tokenId, 1);
1122 
1123         // Clear approvals from the previous owner
1124         _approve(address(0), tokenId, prevOwnership.addr);
1125 
1126         // Underflow of the sender's balance is impossible because we check for
1127         // ownership above and the recipient's balance can't realistically overflow.
1128         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1129     unchecked {
1130         _addressData[from].balance -= 1;
1131         _addressData[to].balance += 1;
1132 
1133         _ownerships[tokenId].addr = to;
1134         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1135 
1136         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1137         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1138         uint256 nextTokenId = tokenId + 1;
1139         if (_ownerships[nextTokenId].addr == address(0)) {
1140             if (_exists(nextTokenId)) {
1141                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1142                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1143             }
1144         }
1145     }
1146 
1147         emit Transfer(from, to, tokenId);
1148         _afterTokenTransfers(from, to, tokenId, 1);
1149     }
1150 
1151     /**
1152      * @dev Approve `to` to operate on `tokenId`
1153      *
1154      * Emits a {Approval} event.
1155      */
1156     function _approve(
1157         address to,
1158         uint256 tokenId,
1159         address owner
1160     ) private {
1161         _tokenApprovals[tokenId] = to;
1162         emit Approval(owner, to, tokenId);
1163     }
1164 
1165     /**
1166      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1167      * The call is not executed if the target address is not a contract.
1168      *
1169      * @param from address representing the previous owner of the given token ID
1170      * @param to target address that will receive the tokens
1171      * @param tokenId uint256 ID of the token to be transferred
1172      * @param _data bytes optional data to send along with the call
1173      * @return bool whether the call correctly returned the expected magic value
1174      */
1175     function _checkOnERC721Received(
1176         address from,
1177         address to,
1178         uint256 tokenId,
1179         bytes memory _data
1180     ) private returns (bool) {
1181         if (to.isContract()) {
1182             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1183                 return retval == IERC721Receiver(to).onERC721Received.selector;
1184             } catch (bytes memory reason) {
1185                 if (reason.length == 0) {
1186                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1187                 } else {
1188                     assembly {
1189                         revert(add(32, reason), mload(reason))
1190                     }
1191                 }
1192             }
1193         } else {
1194             return true;
1195         }
1196     }
1197 
1198     /**
1199      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1200      *
1201      * startTokenId - the first token id to be transferred
1202      * quantity - the amount to be transferred
1203      *
1204      * Calling conditions:
1205      *
1206      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1207      * transferred to `to`.
1208      * - When `from` is zero, `tokenId` will be minted for `to`.
1209      */
1210     function _beforeTokenTransfers(
1211         address from,
1212         address to,
1213         uint256 startTokenId,
1214         uint256 quantity
1215     ) internal virtual {}
1216 
1217     /**
1218      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1219      * minting.
1220      *
1221      * startTokenId - the first token id to be transferred
1222      * quantity - the amount to be transferred
1223      *
1224      * Calling conditions:
1225      *
1226      * - when `from` and `to` are both non-zero.
1227      * - `from` and `to` are never both zero.
1228      */
1229     function _afterTokenTransfers(
1230         address from,
1231         address to,
1232         uint256 startTokenId,
1233         uint256 quantity
1234     ) internal virtual {}
1235 }
1236 // File: contracts/cryptoclitlips.sol
1237 
1238 
1239 
1240 pragma solidity ^0.8.4;
1241 
1242 
1243 
1244 
1245 contract CryptoClitLips is ERC721A, Ownable, ReentrancyGuard {
1246     using Strings for uint256;
1247 
1248     uint256 public PRICE; // 0.0069 ether - 6900000000000000 wei price
1249     uint256 public MAX_SUPPLY; //4200
1250     string private BASE_URI; // ipfs://QmZdwDrmJuEbyLZd7HcDxRXTXNaiTcZd5dgzY3pS27vnKx/
1251     uint256 public FREE_MINT_LIMIT_PER_WALLET; // 2
1252     uint256 public MAX_MINT_AMOUNT_PER_TX; // 10
1253     bool public IS_SALE_ACTIVE; // false
1254     uint256 public FREE_MINT_IS_ALLOWED_UNTIL; // Free mint is allowed until 3000 mint
1255     bool public METADATA_FROZEN;
1256 
1257     mapping(address => uint256) private freeMintCountMap;
1258 
1259     constructor(uint256 price, uint256 maxSupply, string memory baseUri, uint256 freeMintAllowance, uint256 maxMintPerTx, bool isSaleActive, uint256 freeMintIsAllowedUntil) ERC721A("CryptoClitLips", "CCL$") {
1260         PRICE = price; 
1261         MAX_SUPPLY = maxSupply; 
1262         BASE_URI = baseUri; 
1263         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1264         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1265         IS_SALE_ACTIVE = isSaleActive;
1266         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1267     }
1268 
1269     /** FREE MINT **/
1270 
1271     function updateFreeMintCount(address minter, uint256 count) private {
1272         freeMintCountMap[minter] += count;
1273     }
1274 
1275     function freeMintCount(address addr) public view returns (uint256) {
1276         return freeMintCountMap[addr];
1277     }
1278 
1279     /** GETTERS **/
1280 
1281     function _baseURI() internal view virtual override returns (string memory) {
1282         return BASE_URI;
1283     }
1284 
1285     /** SETTERS **/
1286 
1287     function setPrice(uint256 customPrice) external onlyOwner {
1288         PRICE = customPrice;
1289     }
1290 
1291     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1292         require(newMaxSupply < MAX_SUPPLY, "Invalid new max supply");
1293         require(newMaxSupply >= currentIndex, "Invalid new max supply");
1294         MAX_SUPPLY = newMaxSupply;
1295     }
1296 
1297     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1298         require(!METADATA_FROZEN, "Metadata frozen!");
1299         BASE_URI = customBaseURI_;
1300     }
1301 
1302     function setFreeMintAllowance(uint256 freeMintAllowance) external onlyOwner {
1303         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1304     }
1305 
1306     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1307         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1308     }
1309 
1310     function setSaleActive(bool saleIsActive) external onlyOwner {
1311         IS_SALE_ACTIVE = saleIsActive;
1312     }
1313 
1314     function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil) external onlyOwner {
1315         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1316     }
1317 
1318     function freezeMetadata() external onlyOwner {
1319         METADATA_FROZEN = true;
1320     }
1321 
1322     /** MINT **/
1323 
1324     modifier mintCompliance(uint256 _mintAmount) {
1325         require(_mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX, "Invalid mint amount!");
1326         require(currentIndex + _mintAmount <= MAX_SUPPLY, "Max supply exceeded!");
1327         _;
1328     }
1329 
1330     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1331         require(IS_SALE_ACTIVE, "Sale is not active!");
1332 
1333         uint256 price = PRICE * _mintAmount;
1334 
1335         if (currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
1336             uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET - freeMintCountMap[msg.sender];
1337             if (remainingFreeMint > 0) {
1338                 if (_mintAmount >= remainingFreeMint) {
1339                     price -= remainingFreeMint * PRICE;
1340                     updateFreeMintCount(msg.sender, remainingFreeMint);
1341                 } else {
1342                     price -= _mintAmount * PRICE;
1343                     updateFreeMintCount(msg.sender, _mintAmount);
1344                 }
1345             }
1346         }
1347 
1348         require(msg.value >= price, "Insufficient funds!");
1349 
1350         _safeMint(msg.sender, _mintAmount);
1351     }
1352 
1353     function mintOwner(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1354         _safeMint(_to, _mintAmount);
1355     }
1356 
1357     /** PAYOUT **/
1358 
1359     address private payoutAddress1 =
1360     0x08b55717F3A8b9F228b9129d05a983A8D5118aD3;
1361 
1362    
1363 
1364     function withdraw() public onlyOwner nonReentrant {
1365         uint256 balance = address(this).balance;
1366 
1367         Address.sendValue(payable(payoutAddress1), balance / 1);
1368 
1369        
1370     }
1371 
1372     function withdrawToThisAddress() public onlyOwner {
1373     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1374     require(os);
1375     
1376   }
1377 
1378     function setPayoutAddress(address addy, uint id) external onlyOwner {
1379         if (id == 0) {
1380             payoutAddress1 = addy;
1381         } 
1382     }
1383 }