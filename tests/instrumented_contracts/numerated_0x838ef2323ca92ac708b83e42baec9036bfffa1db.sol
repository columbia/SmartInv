1 //SPDX-License-Identifier: UNLICENSED
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
48 
49 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @dev Contract module that helps prevent reentrant calls to a function.
55  *
56  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
57  * available, which can be applied to functions to make sure there are no nested
58  * (reentrant) calls to them.
59  *
60  * Note that because there is a single `nonReentrant` guard, functions marked as
61  * `nonReentrant` may not call one another. This can be worked around by making
62  * those functions `private`, and then adding `external` `nonReentrant` entry
63  * points to them.
64  *
65  * TIP: If you would like to learn more about reentrancy and alternative ways
66  * to protect against it, check out our blog post
67  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
68  */
69 abstract contract ReentrancyGuard {
70     // Booleans are more expensive than uint256 or any type that takes up a full
71     // word because each write operation emits an extra SLOAD to first read the
72     // slot's contents, replace the bits taken up by the boolean, and then write
73     // back. This is the compiler's defense against contract upgrades and
74     // pointer aliasing, and it cannot be disabled.
75 
76     // The values being non-zero value makes deployment a bit more expensive,
77     // but in exchange the refund on every call to nonReentrant will be lower in
78     // amount. Since refunds are capped to a percentage of the total
79     // transaction's gas, it is best to keep them low in cases like this one, to
80     // increase the likelihood of the full refund coming into effect.
81     uint256 private constant _NOT_ENTERED = 1;
82     uint256 private constant _ENTERED = 2;
83 
84     uint256 private _status;
85 
86     constructor() {
87         _status = _NOT_ENTERED;
88     }
89 
90     /**
91      * @dev Prevents a contract from calling itself, directly or indirectly.
92      * Calling a `nonReentrant` function from another `nonReentrant`
93      * function is not supported. It is possible to prevent this from happening
94      * by making the `nonReentrant` function external, and making it call a
95      * `private` function that does the actual work.
96      */
97     modifier nonReentrant() {
98         // On the first call to nonReentrant, _notEntered will be true
99         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
100 
101         // Any calls to nonReentrant after this point will fail
102         _status = _ENTERED;
103 
104         _;
105 
106         // By storing the original value once again, a refund is triggered (see
107         // https://eips.ethereum.org/EIPS/eip-2200)
108         _status = _NOT_ENTERED;
109     }
110 }
111 
112 // File: @openzeppelin/contracts/utils/Strings.sol
113 
114 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev String operations.
120  */
121 library Strings {
122     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
126      */
127     function toString(uint256 value) internal pure returns (string memory) {
128         // Inspired by OraclizeAPI's implementation - MIT licence
129         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
130 
131         if (value == 0) {
132             return "0";
133         }
134         uint256 temp = value;
135         uint256 digits;
136         while (temp != 0) {
137             digits++;
138             temp /= 10;
139         }
140         bytes memory buffer = new bytes(digits);
141         while (value != 0) {
142             digits -= 1;
143             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
144             value /= 10;
145         }
146         return string(buffer);
147     }
148 
149     /**
150      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
151      */
152     function toHexString(uint256 value) internal pure returns (string memory) {
153         if (value == 0) {
154             return "0x00";
155         }
156         uint256 temp = value;
157         uint256 length = 0;
158         while (temp != 0) {
159             length++;
160             temp >>= 8;
161         }
162         return toHexString(value, length);
163     }
164 
165     /**
166      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
167      */
168     function toHexString(uint256 value, uint256 length)
169         internal
170         pure
171         returns (string memory)
172     {
173         bytes memory buffer = new bytes(2 * length + 2);
174         buffer[0] = "0";
175         buffer[1] = "x";
176         for (uint256 i = 2 * length + 1; i > 1; --i) {
177             buffer[i] = _HEX_SYMBOLS[value & 0xf];
178             value >>= 4;
179         }
180         require(value == 0, "Strings: hex length insufficient");
181         return string(buffer);
182     }
183 }
184 
185 // File: @openzeppelin/contracts/utils/Context.sol
186 
187 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @dev Provides information about the current execution context, including the
193  * sender of the transaction and its data. While these are generally available
194  * via msg.sender and msg.data, they should not be accessed in such a direct
195  * manner, since when dealing with meta-transactions the account sending and
196  * paying for execution may not be the actual sender (as far as an application
197  * is concerned).
198  *
199  * This contract is only required for intermediate, library-like contracts.
200  */
201 abstract contract Context {
202     function _msgSender() internal view virtual returns (address) {
203         return msg.sender;
204     }
205 
206     function _msgData() internal view virtual returns (bytes calldata) {
207         return msg.data;
208     }
209 }
210 
211 // File: @openzeppelin/contracts/access/Ownable.sol
212 
213 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
214 
215 pragma solidity ^0.8.0;
216 
217 /**
218  * @dev Contract module which provides a basic access control mechanism, where
219  * there is an account (an owner) that can be granted exclusive access to
220  * specific functions.
221  *
222  * By default, the owner account will be the one that deploys the contract. This
223  * can later be changed with {transferOwnership}.
224  *
225  * This module is used through inheritance. It will make available the modifier
226  * `onlyOwner`, which can be applied to your functions to restrict their use to
227  * the owner.
228  */
229 abstract contract Ownable is Context {
230     address private _owner;
231 
232     event OwnershipTransferred(
233         address indexed previousOwner,
234         address indexed newOwner
235     );
236 
237     /**
238      * @dev Initializes the contract setting the deployer as the initial owner.
239      */
240     constructor() {
241         _transferOwnership(_msgSender());
242     }
243 
244     /**
245      * @dev Returns the address of the current owner.
246      */
247     function owner() public view virtual returns (address) {
248         return _owner;
249     }
250 
251     /**
252      * @dev Throws if called by any account other than the owner.
253      */
254     modifier onlyOwner() {
255         require(owner() == _msgSender(), "Ownable: caller is not the owner");
256         _;
257     }
258 
259     /**
260      * @dev Leaves the contract without owner. It will not be possible to call
261      * `onlyOwner` functions anymore. Can only be called by the current owner.
262      *
263      * NOTE: Renouncing ownership will leave the contract without an owner,
264      * thereby removing any functionality that is only available to the owner.
265      */
266     function renounceOwnership() public virtual onlyOwner {
267         _transferOwnership(address(0));
268     }
269 
270     /**
271      * @dev Transfers ownership of the contract to a new account (`newOwner`).
272      * Can only be called by the current owner.
273      */
274     function transferOwnership(address newOwner) public virtual onlyOwner {
275         require(
276             newOwner != address(0),
277             "Ownable: new owner is the zero address"
278         );
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
293 // File: contracts/common/Whitelist.sol
294 
295 pragma solidity ^0.8.9;
296 
297 contract Whitelist is Ownable {
298     mapping(address => bool) public whitelistedAddress;
299 
300     function isWhitelisted(address _address) public view returns (bool) {
301         return _address == owner() || whitelistedAddress[_address];
302     }
303 
304     function whitelistAddresses(address[] calldata _addresses)
305         public
306         onlyOwner
307     {
308         for (uint256 i = 0; i < _addresses.length; i++) {
309             whitelistedAddress[_addresses[i]] = true;
310         }
311     }
312 
313     function unwhitelistAddresses(address[] calldata _addresses)
314         public
315         onlyOwner
316     {
317         for (uint256 i = 0; i < _addresses.length; i++) {
318             whitelistedAddress[_addresses[i]] = false;
319         }
320     }
321 }
322 
323 // File: @openzeppelin/contracts/utils/Address.sol
324 
325 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Collection of functions related to the address type
331  */
332 library Address {
333     /**
334      * @dev Returns true if `account` is a contract.
335      *
336      * [IMPORTANT]
337      * ====
338      * It is unsafe to assume that an address for which this function returns
339      * false is an externally-owned account (EOA) and not a contract.
340      *
341      * Among others, `isContract` will return false for the following
342      * types of addresses:
343      *
344      *  - an externally-owned account
345      *  - a contract in construction
346      *  - an address where a contract will be created
347      *  - an address where a contract lived, but was destroyed
348      * ====
349      */
350     function isContract(address account) internal view returns (bool) {
351         // This method relies on extcodesize, which returns 0 for contracts in
352         // construction, since the code is only stored at the end of the
353         // constructor execution.
354 
355         uint256 size;
356         assembly {
357             size := extcodesize(account)
358         }
359         return size > 0;
360     }
361 
362     /**
363      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
364      * `recipient`, forwarding all available gas and reverting on errors.
365      *
366      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
367      * of certain opcodes, possibly making contracts go over the 2300 gas limit
368      * imposed by `transfer`, making them unable to receive funds via
369      * `transfer`. {sendValue} removes this limitation.
370      *
371      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
372      *
373      * IMPORTANT: because control is transferred to `recipient`, care must be
374      * taken to not create reentrancy vulnerabilities. Consider using
375      * {ReentrancyGuard} or the
376      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
377      */
378     function sendValue(address payable recipient, uint256 amount) internal {
379         require(
380             address(this).balance >= amount,
381             "Address: insufficient balance"
382         );
383 
384         (bool success, ) = recipient.call{value: amount}("");
385         require(
386             success,
387             "Address: unable to send value, recipient may have reverted"
388         );
389     }
390 
391     /**
392      * @dev Performs a Solidity function call using a low level `call`. A
393      * plain `call` is an unsafe replacement for a function call: use this
394      * function instead.
395      *
396      * If `target` reverts with a revert reason, it is bubbled up by this
397      * function (like regular Solidity function calls).
398      *
399      * Returns the raw returned data. To convert to the expected return value,
400      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
401      *
402      * Requirements:
403      *
404      * - `target` must be a contract.
405      * - calling `target` with `data` must not revert.
406      *
407      * _Available since v3.1._
408      */
409     function functionCall(address target, bytes memory data)
410         internal
411         returns (bytes memory)
412     {
413         return functionCall(target, data, "Address: low-level call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
418      * `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         return functionCallWithValue(target, data, 0, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but also transferring `value` wei to `target`.
433      *
434      * Requirements:
435      *
436      * - the calling contract must have an ETH balance of at least `value`.
437      * - the called Solidity function must be `payable`.
438      *
439      * _Available since v3.1._
440      */
441     function functionCallWithValue(
442         address target,
443         bytes memory data,
444         uint256 value
445     ) internal returns (bytes memory) {
446         return
447             functionCallWithValue(
448                 target,
449                 data,
450                 value,
451                 "Address: low-level call with value failed"
452             );
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
457      * with `errorMessage` as a fallback revert reason when `target` reverts.
458      *
459      * _Available since v3.1._
460      */
461     function functionCallWithValue(
462         address target,
463         bytes memory data,
464         uint256 value,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         require(
468             address(this).balance >= value,
469             "Address: insufficient balance for call"
470         );
471         require(isContract(target), "Address: call to non-contract");
472 
473         (bool success, bytes memory returndata) = target.call{value: value}(
474             data
475         );
476         return verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but performing a static call.
482      *
483      * _Available since v3.3._
484      */
485     function functionStaticCall(address target, bytes memory data)
486         internal
487         view
488         returns (bytes memory)
489     {
490         return
491             functionStaticCall(
492                 target,
493                 data,
494                 "Address: low-level static call failed"
495             );
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
500      * but performing a static call.
501      *
502      * _Available since v3.3._
503      */
504     function functionStaticCall(
505         address target,
506         bytes memory data,
507         string memory errorMessage
508     ) internal view returns (bytes memory) {
509         require(isContract(target), "Address: static call to non-contract");
510 
511         (bool success, bytes memory returndata) = target.staticcall(data);
512         return verifyCallResult(success, returndata, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but performing a delegate call.
518      *
519      * _Available since v3.4._
520      */
521     function functionDelegateCall(address target, bytes memory data)
522         internal
523         returns (bytes memory)
524     {
525         return
526             functionDelegateCall(
527                 target,
528                 data,
529                 "Address: low-level delegate call failed"
530             );
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
535      * but performing a delegate call.
536      *
537      * _Available since v3.4._
538      */
539     function functionDelegateCall(
540         address target,
541         bytes memory data,
542         string memory errorMessage
543     ) internal returns (bytes memory) {
544         require(isContract(target), "Address: delegate call to non-contract");
545 
546         (bool success, bytes memory returndata) = target.delegatecall(data);
547         return verifyCallResult(success, returndata, errorMessage);
548     }
549 
550     /**
551      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
552      * revert reason using the provided one.
553      *
554      * _Available since v4.3._
555      */
556     function verifyCallResult(
557         bool success,
558         bytes memory returndata,
559         string memory errorMessage
560     ) internal pure returns (bytes memory) {
561         if (success) {
562             return returndata;
563         } else {
564             // Look for revert reason and bubble it up if present
565             if (returndata.length > 0) {
566                 // The easiest way to bubble the revert reason is using memory via assembly
567 
568                 assembly {
569                     let returndata_size := mload(returndata)
570                     revert(add(32, returndata), returndata_size)
571                 }
572             } else {
573                 revert(errorMessage);
574             }
575         }
576     }
577 }
578 
579 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
580 
581 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 /**
586  * @title ERC721 token receiver interface
587  * @dev Interface for any contract that wants to support safeTransfers
588  * from ERC721 asset contracts.
589  */
590 interface IERC721Receiver {
591     /**
592      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
593      * by `operator` from `from`, this function is called.
594      *
595      * It must return its Solidity selector to confirm the token transfer.
596      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
597      *
598      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
599      */
600     function onERC721Received(
601         address operator,
602         address from,
603         uint256 tokenId,
604         bytes calldata data
605     ) external returns (bytes4);
606 }
607 
608 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
609 
610 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 /**
615  * @dev Interface of the ERC165 standard, as defined in the
616  * https://eips.ethereum.org/EIPS/eip-165[EIP].
617  *
618  * Implementers can declare support of contract interfaces, which can then be
619  * queried by others ({ERC165Checker}).
620  *
621  * For an implementation, see {ERC165}.
622  */
623 interface IERC165 {
624     /**
625      * @dev Returns true if this contract implements the interface defined by
626      * `interfaceId`. See the corresponding
627      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
628      * to learn more about how these ids are created.
629      *
630      * This function call must use less than 30 000 gas.
631      */
632     function supportsInterface(bytes4 interfaceId) external view returns (bool);
633 }
634 
635 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
636 
637 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 /**
642  * @dev Implementation of the {IERC165} interface.
643  *
644  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
645  * for the additional interface id that will be supported. For example:
646  *
647  * ```solidity
648  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
649  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
650  * }
651  * ```
652  *
653  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
654  */
655 abstract contract ERC165 is IERC165 {
656     /**
657      * @dev See {IERC165-supportsInterface}.
658      */
659     function supportsInterface(bytes4 interfaceId)
660         public
661         view
662         virtual
663         override
664         returns (bool)
665     {
666         return interfaceId == type(IERC165).interfaceId;
667     }
668 }
669 
670 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
671 
672 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @dev Required interface of an ERC721 compliant contract.
678  */
679 interface IERC721 is IERC165 {
680     /**
681      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
682      */
683     event Transfer(
684         address indexed from,
685         address indexed to,
686         uint256 indexed tokenId
687     );
688 
689     /**
690      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
691      */
692     event Approval(
693         address indexed owner,
694         address indexed approved,
695         uint256 indexed tokenId
696     );
697 
698     /**
699      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
700      */
701     event ApprovalForAll(
702         address indexed owner,
703         address indexed operator,
704         bool approved
705     );
706 
707     /**
708      * @dev Returns the number of tokens in ``owner``'s account.
709      */
710     function balanceOf(address owner) external view returns (uint256 balance);
711 
712     /**
713      * @dev Returns the owner of the `tokenId` token.
714      *
715      * Requirements:
716      *
717      * - `tokenId` must exist.
718      */
719     function ownerOf(uint256 tokenId) external view returns (address owner);
720 
721     /**
722      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
723      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
724      *
725      * Requirements:
726      *
727      * - `from` cannot be the zero address.
728      * - `to` cannot be the zero address.
729      * - `tokenId` token must exist and be owned by `from`.
730      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
731      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
732      *
733      * Emits a {Transfer} event.
734      */
735     function safeTransferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) external;
740 
741     /**
742      * @dev Transfers `tokenId` token from `from` to `to`.
743      *
744      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
745      *
746      * Requirements:
747      *
748      * - `from` cannot be the zero address.
749      * - `to` cannot be the zero address.
750      * - `tokenId` token must be owned by `from`.
751      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
752      *
753      * Emits a {Transfer} event.
754      */
755     function transferFrom(
756         address from,
757         address to,
758         uint256 tokenId
759     ) external;
760 
761     /**
762      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
763      * The approval is cleared when the token is transferred.
764      *
765      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
766      *
767      * Requirements:
768      *
769      * - The caller must own the token or be an approved operator.
770      * - `tokenId` must exist.
771      *
772      * Emits an {Approval} event.
773      */
774     function approve(address to, uint256 tokenId) external;
775 
776     /**
777      * @dev Returns the account approved for `tokenId` token.
778      *
779      * Requirements:
780      *
781      * - `tokenId` must exist.
782      */
783     function getApproved(uint256 tokenId)
784         external
785         view
786         returns (address operator);
787 
788     /**
789      * @dev Approve or remove `operator` as an operator for the caller.
790      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
791      *
792      * Requirements:
793      *
794      * - The `operator` cannot be the caller.
795      *
796      * Emits an {ApprovalForAll} event.
797      */
798     function setApprovalForAll(address operator, bool _approved) external;
799 
800     /**
801      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
802      *
803      * See {setApprovalForAll}
804      */
805     function isApprovedForAll(address owner, address operator)
806         external
807         view
808         returns (bool);
809 
810     /**
811      * @dev Safely transfers `tokenId` token from `from` to `to`.
812      *
813      * Requirements:
814      *
815      * - `from` cannot be the zero address.
816      * - `to` cannot be the zero address.
817      * - `tokenId` token must exist and be owned by `from`.
818      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
819      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
820      *
821      * Emits a {Transfer} event.
822      */
823     function safeTransferFrom(
824         address from,
825         address to,
826         uint256 tokenId,
827         bytes calldata data
828     ) external;
829 }
830 
831 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
832 
833 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
834 
835 pragma solidity ^0.8.0;
836 
837 /**
838  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
839  * @dev See https://eips.ethereum.org/EIPS/eip-721
840  */
841 interface IERC721Enumerable is IERC721 {
842     /**
843      * @dev Returns the total amount of tokens stored by the contract.
844      */
845     function totalSupply() external view returns (uint256);
846 
847     /**
848      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
849      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
850      */
851     function tokenOfOwnerByIndex(address owner, uint256 index)
852         external
853         view
854         returns (uint256 tokenId);
855 
856     /**
857      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
858      * Use along with {totalSupply} to enumerate all tokens.
859      */
860     function tokenByIndex(uint256 index) external view returns (uint256);
861 }
862 
863 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
864 
865 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
866 
867 pragma solidity ^0.8.0;
868 
869 /**
870  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
871  * @dev See https://eips.ethereum.org/EIPS/eip-721
872  */
873 interface IERC721Metadata is IERC721 {
874     /**
875      * @dev Returns the token collection name.
876      */
877     function name() external view returns (string memory);
878 
879     /**
880      * @dev Returns the token collection symbol.
881      */
882     function symbol() external view returns (string memory);
883 
884     /**
885      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
886      */
887     function tokenURI(uint256 tokenId) external view returns (string memory);
888 }
889 
890 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
891 
892 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
893 
894 pragma solidity ^0.8.0;
895 
896 /**
897  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
898  * the Metadata extension, but not including the Enumerable extension, which is available separately as
899  * {ERC721Enumerable}.
900  */
901 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
902     using Address for address;
903     using Strings for uint256;
904 
905     // Token name
906     string private _name;
907 
908     // Token symbol
909     string private _symbol;
910 
911     // Mapping from token ID to owner address
912     mapping(uint256 => address) private _owners;
913 
914     // Mapping owner address to token count
915     mapping(address => uint256) private _balances;
916 
917     // Mapping from token ID to approved address
918     mapping(uint256 => address) private _tokenApprovals;
919 
920     // Mapping from owner to operator approvals
921     mapping(address => mapping(address => bool)) private _operatorApprovals;
922 
923     /**
924      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
925      */
926     constructor(string memory name_, string memory symbol_) {
927         _name = name_;
928         _symbol = symbol_;
929     }
930 
931     /**
932      * @dev See {IERC165-supportsInterface}.
933      */
934     function supportsInterface(bytes4 interfaceId)
935         public
936         view
937         virtual
938         override(ERC165, IERC165)
939         returns (bool)
940     {
941         return
942             interfaceId == type(IERC721).interfaceId ||
943             interfaceId == type(IERC721Metadata).interfaceId ||
944             super.supportsInterface(interfaceId);
945     }
946 
947     /**
948      * @dev See {IERC721-balanceOf}.
949      */
950     function balanceOf(address owner)
951         public
952         view
953         virtual
954         override
955         returns (uint256)
956     {
957         require(
958             owner != address(0),
959             "ERC721: balance query for the zero address"
960         );
961         return _balances[owner];
962     }
963 
964     /**
965      * @dev See {IERC721-ownerOf}.
966      */
967     function ownerOf(uint256 tokenId)
968         public
969         view
970         virtual
971         override
972         returns (address)
973     {
974         address owner = _owners[tokenId];
975         require(
976             owner != address(0),
977             "ERC721: owner query for nonexistent token"
978         );
979         return owner;
980     }
981 
982     /**
983      * @dev See {IERC721Metadata-name}.
984      */
985     function name() public view virtual override returns (string memory) {
986         return _name;
987     }
988 
989     /**
990      * @dev See {IERC721Metadata-symbol}.
991      */
992     function symbol() public view virtual override returns (string memory) {
993         return _symbol;
994     }
995 
996     /**
997      * @dev See {IERC721Metadata-tokenURI}.
998      */
999     function tokenURI(uint256 tokenId)
1000         public
1001         view
1002         virtual
1003         override
1004         returns (string memory)
1005     {
1006         require(
1007             _exists(tokenId),
1008             "ERC721Metadata: URI query for nonexistent token"
1009         );
1010 
1011         string memory baseURI = _baseURI();
1012         return
1013             bytes(baseURI).length > 0
1014                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1015                 : "";
1016     }
1017 
1018     /**
1019      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1020      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1021      * by default, can be overriden in child contracts.
1022      */
1023     function _baseURI() internal view virtual returns (string memory) {
1024         return "";
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-approve}.
1029      */
1030     function approve(address to, uint256 tokenId) public virtual override {
1031         address owner = ERC721.ownerOf(tokenId);
1032         require(to != owner, "ERC721: approval to current owner");
1033 
1034         require(
1035             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1036             "ERC721: approve caller is not owner nor approved for all"
1037         );
1038 
1039         _approve(to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-getApproved}.
1044      */
1045     function getApproved(uint256 tokenId)
1046         public
1047         view
1048         virtual
1049         override
1050         returns (address)
1051     {
1052         require(
1053             _exists(tokenId),
1054             "ERC721: approved query for nonexistent token"
1055         );
1056 
1057         return _tokenApprovals[tokenId];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-setApprovalForAll}.
1062      */
1063     function setApprovalForAll(address operator, bool approved)
1064         public
1065         virtual
1066         override
1067     {
1068         _setApprovalForAll(_msgSender(), operator, approved);
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-isApprovedForAll}.
1073      */
1074     function isApprovedForAll(address owner, address operator)
1075         public
1076         view
1077         virtual
1078         override
1079         returns (bool)
1080     {
1081         return _operatorApprovals[owner][operator];
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-transferFrom}.
1086      */
1087     function transferFrom(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) public virtual override {
1092         //solhint-disable-next-line max-line-length
1093         require(
1094             _isApprovedOrOwner(_msgSender(), tokenId),
1095             "ERC721: transfer caller is not owner nor approved"
1096         );
1097 
1098         _transfer(from, to, tokenId);
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-safeTransferFrom}.
1103      */
1104     function safeTransferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) public virtual override {
1109         safeTransferFrom(from, to, tokenId, "");
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-safeTransferFrom}.
1114      */
1115     function safeTransferFrom(
1116         address from,
1117         address to,
1118         uint256 tokenId,
1119         bytes memory _data
1120     ) public virtual override {
1121         require(
1122             _isApprovedOrOwner(_msgSender(), tokenId),
1123             "ERC721: transfer caller is not owner nor approved"
1124         );
1125         _safeTransfer(from, to, tokenId, _data);
1126     }
1127 
1128     /**
1129      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1130      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1131      *
1132      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1133      *
1134      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1135      * implement alternative mechanisms to perform token transfer, such as signature-based.
1136      *
1137      * Requirements:
1138      *
1139      * - `from` cannot be the zero address.
1140      * - `to` cannot be the zero address.
1141      * - `tokenId` token must exist and be owned by `from`.
1142      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _safeTransfer(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory _data
1151     ) internal virtual {
1152         _transfer(from, to, tokenId);
1153         require(
1154             _checkOnERC721Received(from, to, tokenId, _data),
1155             "ERC721: transfer to non ERC721Receiver implementer"
1156         );
1157     }
1158 
1159     /**
1160      * @dev Returns whether `tokenId` exists.
1161      *
1162      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1163      *
1164      * Tokens start existing when they are minted (`_mint`),
1165      * and stop existing when they are burned (`_burn`).
1166      */
1167     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1168         return _owners[tokenId] != address(0);
1169     }
1170 
1171     /**
1172      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1173      *
1174      * Requirements:
1175      *
1176      * - `tokenId` must exist.
1177      */
1178     function _isApprovedOrOwner(address spender, uint256 tokenId)
1179         internal
1180         view
1181         virtual
1182         returns (bool)
1183     {
1184         require(
1185             _exists(tokenId),
1186             "ERC721: operator query for nonexistent token"
1187         );
1188         address owner = ERC721.ownerOf(tokenId);
1189         return (spender == owner ||
1190             getApproved(tokenId) == spender ||
1191             isApprovedForAll(owner, spender));
1192     }
1193 
1194     /**
1195      * @dev Safely mints `tokenId` and transfers it to `to`.
1196      *
1197      * Requirements:
1198      *
1199      * - `tokenId` must not exist.
1200      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function _safeMint(address to, uint256 tokenId) internal virtual {
1205         _safeMint(to, tokenId, "");
1206     }
1207 
1208     /**
1209      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1210      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1211      */
1212     function _safeMint(
1213         address to,
1214         uint256 tokenId,
1215         bytes memory _data
1216     ) internal virtual {
1217         _mint(to, tokenId);
1218         require(
1219             _checkOnERC721Received(address(0), to, tokenId, _data),
1220             "ERC721: transfer to non ERC721Receiver implementer"
1221         );
1222     }
1223 
1224     /**
1225      * @dev Mints `tokenId` and transfers it to `to`.
1226      *
1227      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1228      *
1229      * Requirements:
1230      *
1231      * - `tokenId` must not exist.
1232      * - `to` cannot be the zero address.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _mint(address to, uint256 tokenId) internal virtual {
1237         require(to != address(0), "ERC721: mint to the zero address");
1238         require(!_exists(tokenId), "ERC721: token already minted");
1239 
1240         _beforeTokenTransfer(address(0), to, tokenId);
1241 
1242         _balances[to] += 1;
1243         _owners[tokenId] = to;
1244 
1245         emit Transfer(address(0), to, tokenId);
1246     }
1247 
1248     /**
1249      * @dev Destroys `tokenId`.
1250      * The approval is cleared when the token is burned.
1251      *
1252      * Requirements:
1253      *
1254      * - `tokenId` must exist.
1255      *
1256      * Emits a {Transfer} event.
1257      */
1258     function _burn(uint256 tokenId) internal virtual {
1259         address owner = ERC721.ownerOf(tokenId);
1260 
1261         _beforeTokenTransfer(owner, address(0), tokenId);
1262 
1263         // Clear approvals
1264         _approve(address(0), tokenId);
1265 
1266         _balances[owner] -= 1;
1267         delete _owners[tokenId];
1268 
1269         emit Transfer(owner, address(0), tokenId);
1270     }
1271 
1272     /**
1273      * @dev Transfers `tokenId` from `from` to `to`.
1274      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1275      *
1276      * Requirements:
1277      *
1278      * - `to` cannot be the zero address.
1279      * - `tokenId` token must be owned by `from`.
1280      *
1281      * Emits a {Transfer} event.
1282      */
1283     function _transfer(
1284         address from,
1285         address to,
1286         uint256 tokenId
1287     ) internal virtual {
1288         require(
1289             ERC721.ownerOf(tokenId) == from,
1290             "ERC721: transfer of token that is not own"
1291         );
1292         require(to != address(0), "ERC721: transfer to the zero address");
1293 
1294         _beforeTokenTransfer(from, to, tokenId);
1295 
1296         // Clear approvals from the previous owner
1297         _approve(address(0), tokenId);
1298 
1299         _balances[from] -= 1;
1300         _balances[to] += 1;
1301         _owners[tokenId] = to;
1302 
1303         emit Transfer(from, to, tokenId);
1304     }
1305 
1306     /**
1307      * @dev Approve `to` to operate on `tokenId`
1308      *
1309      * Emits a {Approval} event.
1310      */
1311     function _approve(address to, uint256 tokenId) internal virtual {
1312         _tokenApprovals[tokenId] = to;
1313         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1314     }
1315 
1316     /**
1317      * @dev Approve `operator` to operate on all of `owner` tokens
1318      *
1319      * Emits a {ApprovalForAll} event.
1320      */
1321     function _setApprovalForAll(
1322         address owner,
1323         address operator,
1324         bool approved
1325     ) internal virtual {
1326         require(owner != operator, "ERC721: approve to caller");
1327         _operatorApprovals[owner][operator] = approved;
1328         emit ApprovalForAll(owner, operator, approved);
1329     }
1330 
1331     /**
1332      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1333      * The call is not executed if the target address is not a contract.
1334      *
1335      * @param from address representing the previous owner of the given token ID
1336      * @param to target address that will receive the tokens
1337      * @param tokenId uint256 ID of the token to be transferred
1338      * @param _data bytes optional data to send along with the call
1339      * @return bool whether the call correctly returned the expected magic value
1340      */
1341     function _checkOnERC721Received(
1342         address from,
1343         address to,
1344         uint256 tokenId,
1345         bytes memory _data
1346     ) private returns (bool) {
1347         if (to.isContract()) {
1348             try
1349                 IERC721Receiver(to).onERC721Received(
1350                     _msgSender(),
1351                     from,
1352                     tokenId,
1353                     _data
1354                 )
1355             returns (bytes4 retval) {
1356                 return retval == IERC721Receiver.onERC721Received.selector;
1357             } catch (bytes memory reason) {
1358                 if (reason.length == 0) {
1359                     revert(
1360                         "ERC721: transfer to non ERC721Receiver implementer"
1361                     );
1362                 } else {
1363                     assembly {
1364                         revert(add(32, reason), mload(reason))
1365                     }
1366                 }
1367             }
1368         } else {
1369             return true;
1370         }
1371     }
1372 
1373     /**
1374      * @dev Hook that is called before any token transfer. This includes minting
1375      * and burning.
1376      *
1377      * Calling conditions:
1378      *
1379      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1380      * transferred to `to`.
1381      * - When `from` is zero, `tokenId` will be minted for `to`.
1382      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1383      * - `from` and `to` are never both zero.
1384      *
1385      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1386      */
1387     function _beforeTokenTransfer(
1388         address from,
1389         address to,
1390         uint256 tokenId
1391     ) internal virtual {}
1392 }
1393 
1394 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1395 
1396 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 /**
1401  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1402  * enumerability of all the token ids in the contract as well as all token ids owned by each
1403  * account.
1404  */
1405 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1406     // Mapping from owner to list of owned token IDs
1407     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1408 
1409     // Mapping from token ID to index of the owner tokens list
1410     mapping(uint256 => uint256) private _ownedTokensIndex;
1411 
1412     // Array with all token ids, used for enumeration
1413     uint256[] private _allTokens;
1414 
1415     // Mapping from token id to position in the allTokens array
1416     mapping(uint256 => uint256) private _allTokensIndex;
1417 
1418     /**
1419      * @dev See {IERC165-supportsInterface}.
1420      */
1421     function supportsInterface(bytes4 interfaceId)
1422         public
1423         view
1424         virtual
1425         override(IERC165, ERC721)
1426         returns (bool)
1427     {
1428         return
1429             interfaceId == type(IERC721Enumerable).interfaceId ||
1430             super.supportsInterface(interfaceId);
1431     }
1432 
1433     /**
1434      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1435      */
1436     function tokenOfOwnerByIndex(address owner, uint256 index)
1437         public
1438         view
1439         virtual
1440         override
1441         returns (uint256)
1442     {
1443         require(
1444             index < ERC721.balanceOf(owner),
1445             "ERC721Enumerable: owner index out of bounds"
1446         );
1447         return _ownedTokens[owner][index];
1448     }
1449 
1450     /**
1451      * @dev See {IERC721Enumerable-totalSupply}.
1452      */
1453     function totalSupply() public view virtual override returns (uint256) {
1454         return _allTokens.length;
1455     }
1456 
1457     /**
1458      * @dev See {IERC721Enumerable-tokenByIndex}.
1459      */
1460     function tokenByIndex(uint256 index)
1461         public
1462         view
1463         virtual
1464         override
1465         returns (uint256)
1466     {
1467         require(
1468             index < ERC721Enumerable.totalSupply(),
1469             "ERC721Enumerable: global index out of bounds"
1470         );
1471         return _allTokens[index];
1472     }
1473 
1474     /**
1475      * @dev Hook that is called before any token transfer. This includes minting
1476      * and burning.
1477      *
1478      * Calling conditions:
1479      *
1480      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1481      * transferred to `to`.
1482      * - When `from` is zero, `tokenId` will be minted for `to`.
1483      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1484      * - `from` cannot be the zero address.
1485      * - `to` cannot be the zero address.
1486      *
1487      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1488      */
1489     function _beforeTokenTransfer(
1490         address from,
1491         address to,
1492         uint256 tokenId
1493     ) internal virtual override {
1494         super._beforeTokenTransfer(from, to, tokenId);
1495 
1496         if (from == address(0)) {
1497             _addTokenToAllTokensEnumeration(tokenId);
1498         } else if (from != to) {
1499             _removeTokenFromOwnerEnumeration(from, tokenId);
1500         }
1501         if (to == address(0)) {
1502             _removeTokenFromAllTokensEnumeration(tokenId);
1503         } else if (to != from) {
1504             _addTokenToOwnerEnumeration(to, tokenId);
1505         }
1506     }
1507 
1508     /**
1509      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1510      * @param to address representing the new owner of the given token ID
1511      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1512      */
1513     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1514         uint256 length = ERC721.balanceOf(to);
1515         _ownedTokens[to][length] = tokenId;
1516         _ownedTokensIndex[tokenId] = length;
1517     }
1518 
1519     /**
1520      * @dev Private function to add a token to this extension's token tracking data structures.
1521      * @param tokenId uint256 ID of the token to be added to the tokens list
1522      */
1523     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1524         _allTokensIndex[tokenId] = _allTokens.length;
1525         _allTokens.push(tokenId);
1526     }
1527 
1528     /**
1529      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1530      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1531      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1532      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1533      * @param from address representing the previous owner of the given token ID
1534      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1535      */
1536     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1537         private
1538     {
1539         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1540         // then delete the last slot (swap and pop).
1541 
1542         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1543         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1544 
1545         // When the token to delete is the last token, the swap operation is unnecessary
1546         if (tokenIndex != lastTokenIndex) {
1547             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1548 
1549             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1550             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1551         }
1552 
1553         // This also deletes the contents at the last position of the array
1554         delete _ownedTokensIndex[tokenId];
1555         delete _ownedTokens[from][lastTokenIndex];
1556     }
1557 
1558     /**
1559      * @dev Private function to remove a token from this extension's token tracking data structures.
1560      * This has O(1) time complexity, but alters the order of the _allTokens array.
1561      * @param tokenId uint256 ID of the token to be removed from the tokens list
1562      */
1563     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1564         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1565         // then delete the last slot (swap and pop).
1566 
1567         uint256 lastTokenIndex = _allTokens.length - 1;
1568         uint256 tokenIndex = _allTokensIndex[tokenId];
1569 
1570         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1571         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1572         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1573         uint256 lastTokenId = _allTokens[lastTokenIndex];
1574 
1575         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1576         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1577 
1578         // This also deletes the contents at the last position of the array
1579         delete _allTokensIndex[tokenId];
1580         _allTokens.pop();
1581     }
1582 }
1583 
1584 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1585 
1586 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1587 
1588 pragma solidity ^0.8.0;
1589 
1590 // CAUTION
1591 // This version of SafeMath should only be used with Solidity 0.8 or later,
1592 // because it relies on the compiler's built in overflow checks.
1593 
1594 /**
1595  * @dev Wrappers over Solidity's arithmetic operations.
1596  *
1597  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1598  * now has built in overflow checking.
1599  */
1600 library SafeMath {
1601     /**
1602      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1603      *
1604      * _Available since v3.4._
1605      */
1606     function tryAdd(uint256 a, uint256 b)
1607         internal
1608         pure
1609         returns (bool, uint256)
1610     {
1611         unchecked {
1612             uint256 c = a + b;
1613             if (c < a) return (false, 0);
1614             return (true, c);
1615         }
1616     }
1617 
1618     /**
1619      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1620      *
1621      * _Available since v3.4._
1622      */
1623     function trySub(uint256 a, uint256 b)
1624         internal
1625         pure
1626         returns (bool, uint256)
1627     {
1628         unchecked {
1629             if (b > a) return (false, 0);
1630             return (true, a - b);
1631         }
1632     }
1633 
1634     /**
1635      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1636      *
1637      * _Available since v3.4._
1638      */
1639     function tryMul(uint256 a, uint256 b)
1640         internal
1641         pure
1642         returns (bool, uint256)
1643     {
1644         unchecked {
1645             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1646             // benefit is lost if 'b' is also tested.
1647             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1648             if (a == 0) return (true, 0);
1649             uint256 c = a * b;
1650             if (c / a != b) return (false, 0);
1651             return (true, c);
1652         }
1653     }
1654 
1655     /**
1656      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1657      *
1658      * _Available since v3.4._
1659      */
1660     function tryDiv(uint256 a, uint256 b)
1661         internal
1662         pure
1663         returns (bool, uint256)
1664     {
1665         unchecked {
1666             if (b == 0) return (false, 0);
1667             return (true, a / b);
1668         }
1669     }
1670 
1671     /**
1672      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1673      *
1674      * _Available since v3.4._
1675      */
1676     function tryMod(uint256 a, uint256 b)
1677         internal
1678         pure
1679         returns (bool, uint256)
1680     {
1681         unchecked {
1682             if (b == 0) return (false, 0);
1683             return (true, a % b);
1684         }
1685     }
1686 
1687     /**
1688      * @dev Returns the addition of two unsigned integers, reverting on
1689      * overflow.
1690      *
1691      * Counterpart to Solidity's `+` operator.
1692      *
1693      * Requirements:
1694      *
1695      * - Addition cannot overflow.
1696      */
1697     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1698         return a + b;
1699     }
1700 
1701     /**
1702      * @dev Returns the subtraction of two unsigned integers, reverting on
1703      * overflow (when the result is negative).
1704      *
1705      * Counterpart to Solidity's `-` operator.
1706      *
1707      * Requirements:
1708      *
1709      * - Subtraction cannot overflow.
1710      */
1711     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1712         return a - b;
1713     }
1714 
1715     /**
1716      * @dev Returns the multiplication of two unsigned integers, reverting on
1717      * overflow.
1718      *
1719      * Counterpart to Solidity's `*` operator.
1720      *
1721      * Requirements:
1722      *
1723      * - Multiplication cannot overflow.
1724      */
1725     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1726         return a * b;
1727     }
1728 
1729     /**
1730      * @dev Returns the integer division of two unsigned integers, reverting on
1731      * division by zero. The result is rounded towards zero.
1732      *
1733      * Counterpart to Solidity's `/` operator.
1734      *
1735      * Requirements:
1736      *
1737      * - The divisor cannot be zero.
1738      */
1739     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1740         return a / b;
1741     }
1742 
1743     /**
1744      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1745      * reverting when dividing by zero.
1746      *
1747      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1748      * opcode (which leaves remaining gas untouched) while Solidity uses an
1749      * invalid opcode to revert (consuming all remaining gas).
1750      *
1751      * Requirements:
1752      *
1753      * - The divisor cannot be zero.
1754      */
1755     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1756         return a % b;
1757     }
1758 
1759     /**
1760      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1761      * overflow (when the result is negative).
1762      *
1763      * CAUTION: This function is deprecated because it requires allocating memory for the error
1764      * message unnecessarily. For custom revert reasons use {trySub}.
1765      *
1766      * Counterpart to Solidity's `-` operator.
1767      *
1768      * Requirements:
1769      *
1770      * - Subtraction cannot overflow.
1771      */
1772     function sub(
1773         uint256 a,
1774         uint256 b,
1775         string memory errorMessage
1776     ) internal pure returns (uint256) {
1777         unchecked {
1778             require(b <= a, errorMessage);
1779             return a - b;
1780         }
1781     }
1782 
1783     /**
1784      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1785      * division by zero. The result is rounded towards zero.
1786      *
1787      * Counterpart to Solidity's `/` operator. Note: this function uses a
1788      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1789      * uses an invalid opcode to revert (consuming all remaining gas).
1790      *
1791      * Requirements:
1792      *
1793      * - The divisor cannot be zero.
1794      */
1795     function div(
1796         uint256 a,
1797         uint256 b,
1798         string memory errorMessage
1799     ) internal pure returns (uint256) {
1800         unchecked {
1801             require(b > 0, errorMessage);
1802             return a / b;
1803         }
1804     }
1805 
1806     /**
1807      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1808      * reverting with custom message when dividing by zero.
1809      *
1810      * CAUTION: This function is deprecated because it requires allocating memory for the error
1811      * message unnecessarily. For custom revert reasons use {tryMod}.
1812      *
1813      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1814      * opcode (which leaves remaining gas untouched) while Solidity uses an
1815      * invalid opcode to revert (consuming all remaining gas).
1816      *
1817      * Requirements:
1818      *
1819      * - The divisor cannot be zero.
1820      */
1821     function mod(
1822         uint256 a,
1823         uint256 b,
1824         string memory errorMessage
1825     ) internal pure returns (uint256) {
1826         unchecked {
1827             require(b > 0, errorMessage);
1828             return a % b;
1829         }
1830     }
1831 }
1832 
1833 // File: contracts/common/ERC721Basic.sol
1834 
1835 pragma solidity ^0.8.9;
1836 
1837 contract ERC721Basic is ERC721, Ownable {
1838     using Counters for Counters.Counter;
1839     using SafeMath for uint256;
1840     using Strings for uint256;
1841 
1842     Counters.Counter internal _tokenIdCounter;
1843     Counters.Counter internal _tokenSupplyCounter;
1844     string internal baseURI;
1845     string public baseExtension = ".json";
1846     uint256 public maxSupply;
1847 
1848     constructor(
1849         string memory _name,
1850         string memory _symbol,
1851         string memory _initBaseURI,
1852         uint256 _maxSupply
1853     ) ERC721(_name, _symbol) {
1854         setBaseURI(_initBaseURI);
1855         maxSupply = _maxSupply;
1856     }
1857 
1858     // internal
1859     function _baseURI() internal view virtual override returns (string memory) {
1860         return baseURI;
1861     }
1862 
1863     function _batchMint(uint256 _qty, address _receiver) internal {
1864         for (uint256 i = 0; i < _qty; i++) {
1865             _incrementCounters();
1866             uint256 _tokenId = _tokenIdCounter.current();
1867             _safeMint(_receiver, _tokenId);
1868         }
1869     }
1870 
1871     function _incrementCounters() internal {
1872         _tokenIdCounter.increment();
1873         _tokenSupplyCounter.increment();
1874     }
1875 
1876     function _currentTokenId() internal view returns (uint256) {
1877         return _tokenIdCounter.current();
1878     }
1879 
1880     function totalSupply() external view returns (uint256) {
1881         return _tokenSupplyCounter.current();
1882     }
1883 
1884     function _tokenURI(uint256 tokenId) public view returns (string memory) {
1885         require(
1886             _exists(tokenId),
1887             "ERC721Metadata: URI query for nonexistent token"
1888         );
1889 
1890         string memory currentBaseURI = _baseURI();
1891         return
1892             bytes(currentBaseURI).length > 0
1893                 ? string(
1894                     abi.encodePacked(
1895                         currentBaseURI,
1896                         tokenId.toString(),
1897                         baseExtension
1898                     )
1899                 )
1900                 : "";
1901     }
1902 
1903     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1904         baseURI = _newBaseURI;
1905     }
1906 
1907     function setBaseExtension(string memory _newBaseExtension)
1908         public
1909         onlyOwner
1910     {
1911         baseExtension = _newBaseExtension;
1912     }
1913 
1914     function burn(uint256 tokenId) public {
1915         require(
1916             _isApprovedOrOwner(_msgSender(), tokenId),
1917             "ERC721Burnable: caller is not owner nor approved"
1918         );
1919         _tokenSupplyCounter.decrement();
1920         _burn(tokenId);
1921     }
1922 }
1923 
1924 // File: contracts/projects/Ekta/EktaNft.sol
1925 
1926 pragma solidity 0.8.9;
1927 
1928 contract EktaNFT is ERC721Basic {
1929     using SafeMath for uint256;
1930 
1931     struct QtyRecipient {
1932         uint256 qty;
1933         address[] recipients;
1934     }
1935 
1936     constructor(
1937         string memory _name,
1938         string memory _symbol,
1939         string memory _initBaseURI,
1940         string memory _baseUriExtension,
1941         uint256 _maxSupply
1942     ) ERC721Basic(_name, _symbol, _initBaseURI, _maxSupply) {
1943         baseExtension = _baseUriExtension;
1944     }
1945 
1946     // function mintAndTransferBatch(
1947     //     uint256[] memory _qtys,
1948     //     address[] memory _receivers
1949     // ) public onlyOwner {
1950     //     require(
1951     //         _qtys.length == _receivers.length,
1952     //         "The param length should be the same"
1953     //     );
1954 
1955     //     uint256 totalQtys = 0;
1956     //     for (uint256 i = 0; i < _qtys.length; i++) {
1957     //         totalQtys += _qtys[i];
1958     //     }
1959 
1960     //     require(
1961     //         totalQtys.add(_tokenIdCounter.current()) <= maxSupply,
1962     //         "Exceeds max supply"
1963     //     );
1964     //     for (uint256 i = 0; i < _receivers.length; i++) {
1965     //         _batchMint(_qtys[i], _receivers[i]);
1966     //     }
1967     // }
1968 
1969     // function mintAndTransfer(
1970     //     uint256 _qtyPerAddress,
1971     //     address[] memory _receivers
1972     // ) public onlyOwner {
1973     //     require(
1974     //         _qtyPerAddress.mul(_receivers.length).add(
1975     //             _tokenIdCounter.current()
1976     //         ) <= maxSupply,
1977     //         "Exceeds max supply"
1978     //     );
1979     //     for (uint256 i = 0; i < _receivers.length; i++) {
1980     //         _batchMint(_qtyPerAddress, _receivers[i]);
1981     //     }
1982     // }
1983 
1984     function mintAndTransfer(QtyRecipient[] memory _qtyRecipients)
1985         external
1986         onlyOwner
1987     {
1988         uint256 totalQtys = 0;
1989         for (uint256 i = 0; i < _qtyRecipients.length; i++) {
1990             totalQtys +=
1991                 _qtyRecipients[i].qty *
1992                 _qtyRecipients[i].recipients.length;
1993         }
1994 
1995         require(
1996             totalQtys.add(_currentTokenId()) <= maxSupply,
1997             "Exceeds max supply"
1998         );
1999         for (uint256 i = 0; i < _qtyRecipients.length; i++) {
2000             for (uint256 j = 0; j < _qtyRecipients[i].recipients.length; j++) {
2001                 _batchMint(
2002                     _qtyRecipients[i].qty,
2003                     _qtyRecipients[i].recipients[j]
2004                 );
2005             }
2006         }
2007     }
2008 
2009     function tokenURI(uint256 tokenId)
2010         public
2011         view
2012         virtual
2013         override
2014         returns (string memory)
2015     {
2016         return _tokenURI(tokenId);
2017     }
2018 }
2019 
2020 // File: contracts/common/ERC721BasicWithEnumerable.sol
2021 
2022 pragma solidity ^0.8.9;
2023 
2024 contract ERC721BasicWithEnumerable is ERC721Enumerable, Ownable {
2025     using Counters for Counters.Counter;
2026     using SafeMath for uint256;
2027     using Strings for uint256;
2028 
2029     Counters.Counter internal _tokenIdCounter;
2030     string internal baseURI;
2031     string public baseExtension = ".json";
2032     uint256 public maxSupply;
2033 
2034     constructor(
2035         string memory _name,
2036         string memory _symbol,
2037         string memory _initBaseURI,
2038         uint256 _maxSupply
2039     ) ERC721(_name, _symbol) {
2040         setBaseURI(_initBaseURI);
2041         maxSupply = _maxSupply;
2042     }
2043 
2044     /// @notice Internal function that returns baseUri of the Nft
2045     function _baseURI() internal view virtual override returns (string memory) {
2046         return baseURI;
2047     }
2048 
2049     /// @notice Internal function to execute minting in batch
2050     /// @dev use this function as the base of minting operation
2051     function _batchMint(uint256 _qty, address _receiver) internal {
2052         for (uint256 i = 0; i < _qty; i++) {
2053             _tokenIdCounter.increment();
2054             uint256 _tokenId = _tokenIdCounter.current();
2055             _safeMint(_receiver, _tokenId);
2056         }
2057     }
2058 
2059     /// @notice Internal function that returns the current tokenId count
2060     /// @dev use this to mint the next token Id
2061     /// we are not using maxSupply as the next token to mint because it risks of
2062     /// trying to mint tokenId that already existed when there's a burn executed before
2063     function _currentTokenId() internal view returns (uint256) {
2064         return _tokenIdCounter.current();
2065     }
2066 
2067     /// @notice Internal function that returns the token URI of a given tokenId
2068     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
2069         require(
2070             _exists(tokenId),
2071             "ERC721Metadata: URI query for nonexistent token"
2072         );
2073 
2074         string memory currentBaseURI = _baseURI();
2075         return
2076             bytes(currentBaseURI).length > 0
2077                 ? string(
2078                     abi.encodePacked(
2079                         currentBaseURI,
2080                         tokenId.toString(),
2081                         baseExtension
2082                     )
2083                 )
2084                 : "";
2085     }
2086 
2087     /// @notice Changes the base URI of the NFTs by owner
2088     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2089         baseURI = _newBaseURI;
2090     }
2091 
2092     /// @notice Changes the base extension of the NFTs by owner
2093     function setBaseExtension(string memory _newBaseExtension)
2094         public
2095         onlyOwner
2096     {
2097         baseExtension = _newBaseExtension;
2098     }
2099 
2100     /// @notice Burns a specified tokenId
2101     function burn(uint256 tokenId) public {
2102         require(
2103             _isApprovedOrOwner(_msgSender(), tokenId),
2104             "ERC721Burnable: caller is not owner nor approved"
2105         );
2106         _burn(tokenId);
2107     }
2108 }
2109 
2110 // File: contracts/projects/Ekta/EktaPortalNft.sol
2111 
2112 pragma solidity 0.8.9;
2113 
2114 /// @title EktaPortalNft
2115 /// @notice NFT contract with custom minting logic
2116 /// (claim fre NFT, whitelist, pause and reveal mechanism)
2117 contract EktaPortalNft is
2118     ERC721BasicWithEnumerable,
2119     Whitelist,
2120     ReentrancyGuard
2121 {
2122     event Reveal(string baseURI);
2123     event MintingPaused(bool);
2124 
2125     mapping(address => uint256) private addressMintCount;
2126     mapping(address => uint256) private addressClaimCount;
2127     mapping(uint256 => bool) private freeAccessGranterUsed;
2128     uint256 private reservedFreeAccessMints = 969;
2129 
2130     address public freeAccessGranter;
2131     uint256 public maxMintPerAddress;
2132     uint256 public price;
2133     bool public isMintingPaused = true;
2134     uint256 public publicMintingStartTimestamp;
2135     bool public isRevealed;
2136 
2137     constructor(
2138         string memory _name,
2139         string memory _symbol,
2140         string memory _initBaseURI,
2141         string memory _baseUriExtension,
2142         uint256 _maxSupply,
2143         uint256 _maxMintPerAddress,
2144         uint256 _price,
2145         uint256 _publicMintingStartTimestamp,
2146         address _freeAccessGranter
2147     ) ERC721BasicWithEnumerable(_name, _symbol, _initBaseURI, _maxSupply) {
2148         baseExtension = _baseUriExtension;
2149         maxMintPerAddress = _maxMintPerAddress;
2150         price = _price;
2151         publicMintingStartTimestamp = _publicMintingStartTimestamp;
2152         freeAccessGranter = _freeAccessGranter;
2153     }
2154 
2155     /// @notice internal function returning list of tokenIds of granter NFT
2156     /// that can be used for claiming free NFT
2157     /// @return tokenIdList List of token ids available for claim
2158     function _getGranterTokenIds(address _addr)
2159         internal
2160         view
2161         returns (uint256[] memory)
2162     {
2163         EktaNFT granterNft = EktaNFT(freeAccessGranter);
2164         uint256 userGrantNftBalance = granterNft.balanceOf(_addr);
2165         uint256[] memory availableTokenIds = new uint256[](userGrantNftBalance);
2166         if (userGrantNftBalance == 0) {
2167             return availableTokenIds;
2168         }
2169 
2170         uint256 balanceCounter = 0;
2171         for (uint256 i = 1; i <= granterNft.totalSupply(); i++) {
2172             if (freeAccessGranterUsed[i]) {
2173                 continue;
2174             }
2175 
2176             if (granterNft.ownerOf(i) != _addr) {
2177                 continue;
2178             }
2179 
2180             availableTokenIds[balanceCounter] = i;
2181             balanceCounter++;
2182 
2183             if (balanceCounter == userGrantNftBalance) {
2184                 break;
2185             }
2186         }
2187 
2188         // returning cleaned array if some tokens has already used for claiming
2189         if (availableTokenIds.length != balanceCounter) {
2190             uint256[] memory cleanedTokenIds = new uint256[](balanceCounter);
2191             for (uint256 i = 0; i < balanceCounter; i++) {
2192                 cleanedTokenIds[i] = availableTokenIds[i];
2193             }
2194             return cleanedTokenIds;
2195         }
2196 
2197         return availableTokenIds;
2198     }
2199 
2200     /// @notice Change minting price by owner
2201     function setPrice(uint256 _newPrice) external onlyOwner {
2202         price = _newPrice;
2203     }
2204 
2205     /// @notice Change the starting timestamp of the public minting period by owner
2206     function setPublicMintingStartTimestamp(
2207         uint256 _newPublicMintingStartTimestamp
2208     ) external onlyOwner {
2209         publicMintingStartTimestamp = _newPublicMintingStartTimestamp;
2210     }
2211 
2212     /// @notice Pause / unpause minting by owner
2213     function setIsMintingPaused(bool _isMintingPaused) external onlyOwner {
2214         isMintingPaused = _isMintingPaused;
2215         emit MintingPaused(_isMintingPaused);
2216     }
2217 
2218     /// @notice Reveal the NFTs by supplying a new base URI by owner
2219     /// can only be called once
2220     /// @dev Emits Reveal(string[])
2221     function reveal(string memory _revealedBaseURI) external onlyOwner {
2222         require(!isRevealed, "It is already revealed");
2223         isRevealed = true;
2224         setBaseURI(_revealedBaseURI);
2225         emit Reveal(_revealedBaseURI);
2226     }
2227 
2228     /// @notice Withdraws contract balance by owner to owner's wallet
2229     function withdraw(uint256 amount) external onlyOwner nonReentrant {
2230         require(amount <= address(this).balance, "Amount exceeds balance");
2231         (bool sent, ) = payable(owner()).call{value: amount}("");
2232         require(sent, "Failed to send Bnb");
2233     }
2234 
2235     /// @notice Returns count of NFTs an address has minted by owner
2236     function getAddressMintCount(address _addr)
2237         external
2238         view
2239         onlyOwner
2240         returns (uint256)
2241     {
2242         return addressMintCount[_addr];
2243     }
2244 
2245     /// @notice Returns count of NFTs an address has claimed by owner
2246     function getAddressClaimCount(address _addr)
2247         external
2248         view
2249         onlyOwner
2250         returns (uint256)
2251     {
2252         return addressClaimCount[_addr];
2253     }
2254 
2255     /// @notice Returns list of granter tokenIds that address can use for claiming by owner
2256     /// this method is used for the owner to help check whether an address has free claims or not
2257     /// @param _addr Address of a wallet to check
2258     function getGranterTokenIds(address _addr)
2259         external
2260         view
2261         onlyOwner
2262         returns (uint256[] memory)
2263     {
2264         return _getGranterTokenIds(_addr);
2265     }
2266 
2267     /// @notice Returns token URI for a given tokenId
2268     /// @dev If the NFT is not revealed yet, return a static string
2269     /// if the NFT is revealed, return `baseUri + tokenId + extension`
2270     function tokenURI(uint256 tokenId)
2271         public
2272         view
2273         virtual
2274         override
2275         returns (string memory)
2276     {
2277         if (!isRevealed) {
2278             require(
2279                 _exists(tokenId),
2280                 "ERC721Metadata: URI query for nonexistent token"
2281             );
2282             return _baseURI();
2283         }
2284         return _tokenURI(tokenId);
2285     }
2286 
2287     /// @notice Returns a status whether a tokenId of a granter NFT
2288     /// is already used for claiming
2289     function isGranterTokenIdUsed(uint256 _tokenId)
2290         external
2291         view
2292         returns (bool)
2293     {
2294         return freeAccessGranterUsed[_tokenId];
2295     }
2296 
2297     /// @notice Claims and mints NFT in batch
2298     /// @param _mintQty number of (payable) Nfts to mint
2299     /// @param _granterTokenIds list of granter tokenIds used to claim
2300     function batchMint(uint256 _mintQty, uint256[] calldata _granterTokenIds)
2301         external
2302         payable
2303         nonReentrant
2304     {
2305         require(!isMintingPaused, "Minting is paused");
2306         require(
2307             _mintQty != 0 || _granterTokenIds.length != 0,
2308             "Quantity can not be 0"
2309         );
2310 
2311         bool isPublicMintingPeriod = publicMintingStartTimestamp <=
2312             block.timestamp;
2313 
2314         uint256 totalMint = _mintQty + _granterTokenIds.length;
2315 
2316         // reserving seat for owner of freeAccessGranterNft except when the owner decide to mint them
2317         if (msg.sender == owner()) {
2318             require(isPublicMintingPeriod, "Owner mint on public sale");
2319             require(
2320                 _currentTokenId() + totalMint <= maxSupply,
2321                 "Exceeds max supply"
2322             );
2323         } else {
2324             require(
2325                 _currentTokenId() + _mintQty <=
2326                     maxSupply - reservedFreeAccessMints,
2327                 "Exceeds max supply"
2328             );
2329         }
2330 
2331         if (_granterTokenIds.length > 0) {
2332             reservedFreeAccessMints -= _granterTokenIds.length;
2333             addressClaimCount[msg.sender] += _granterTokenIds.length;
2334             EktaNFT granterNft = EktaNFT(freeAccessGranter);
2335             for (uint256 i; i < _granterTokenIds.length; i++) {
2336                 require(
2337                     !freeAccessGranterUsed[_granterTokenIds[i]],
2338                     "Token ID has been used"
2339                 );
2340                 require(
2341                     granterNft.ownerOf(_granterTokenIds[i]) == msg.sender,
2342                     "You don't own this granter NFT"
2343                 );
2344 
2345                 freeAccessGranterUsed[_granterTokenIds[i]] = true;
2346             }
2347         }
2348 
2349         if (msg.sender != owner()) {
2350             require(
2351                 isPublicMintingPeriod ||
2352                     isWhitelisted(msg.sender) ||
2353                     addressClaimCount[msg.sender] > 0,
2354                 "You are not whitelisted"
2355             );
2356 
2357             require(
2358                 _mintQty + addressMintCount[msg.sender] <= maxMintPerAddress,
2359                 "Too many minted"
2360             );
2361 
2362             require(msg.value == price * _mintQty, "incorrect price");
2363         }
2364 
2365         addressMintCount[msg.sender] += _mintQty;
2366         _batchMint(totalMint, msg.sender);
2367     }
2368 
2369     /// @notice Returns list of granter tokenIds that the sender can use for claiming by caller
2370     /// this method is used for the owner to help check whether an address has free claims or not
2371     function getMyGranterTokenIds() external view returns (uint256[] memory) {
2372         return _getGranterTokenIds(msg.sender);
2373     }
2374 
2375     /// @notice Transfers multiple tokenIds at once
2376     /// @param _tokenIds List of tokenIds to transfers
2377     /// @param _recipient The recipient of the transfer
2378     function batchTransfer(uint256[] calldata _tokenIds, address _recipient)
2379         public
2380     {
2381         for (uint256 i = 0; i < _tokenIds.length; i++) {
2382             transferFrom(msg.sender, _recipient, _tokenIds[i]);
2383         }
2384     }
2385 }