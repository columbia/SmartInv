1 // File: contracts/Base64.sol
2 
3 
4 pragma solidity ^0.8.2;
5 
6 /// @title Base64
7 /// @author Brecht Devos - <brecht@loopring.org>
8 /// @notice Provides a function for encoding some bytes in base64
9 library Base64 {
10     string internal constant TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
11 
12     function encode(bytes memory data) internal pure returns (string memory) {
13         if (data.length == 0) return '';
14         
15         // load the table into memory
16         string memory table = TABLE;
17 
18         // multiply by 4/3 rounded up
19         uint256 encodedLen = 4 * ((data.length + 2) / 3);
20 
21         // add some extra buffer at the end required for the writing
22         string memory result = new string(encodedLen + 32);
23 
24         assembly {
25             // set the actual output length
26             mstore(result, encodedLen)
27             
28             // prepare the lookup table
29             let tablePtr := add(table, 1)
30             
31             // input ptr
32             let dataPtr := data
33             let endPtr := add(dataPtr, mload(data))
34             
35             // result ptr, jump over length
36             let resultPtr := add(result, 32)
37             
38             // run over the input, 3 bytes at a time
39             for {} lt(dataPtr, endPtr) {}
40             {
41                dataPtr := add(dataPtr, 3)
42                
43                // read 3 bytes
44                let input := mload(dataPtr)
45                
46                // write 4 characters
47                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
48                resultPtr := add(resultPtr, 1)
49                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
50                resultPtr := add(resultPtr, 1)
51                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr( 6, input), 0x3F)))))
52                resultPtr := add(resultPtr, 1)
53                mstore(resultPtr, shl(248, mload(add(tablePtr, and(        input,  0x3F)))))
54                resultPtr := add(resultPtr, 1)
55             }
56             
57             // padding with '='
58             switch mod(mload(data), 3)
59             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
60             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
61         }
62         
63         return result;
64     }
65 }
66 
67 // File: contracts/Bytes.sol
68 
69 
70 /*
71  * @title Solidity Bytes Arrays Utils
72  * @author Gonçalo Sá <goncalo.sa@consensys.net>
73  *
74  * @dev Bytes tightly packed arrays utility library for ethereum contracts written in Solidity.
75  *      The library lets you concatenate, slice and type cast bytes arrays both in memory and storage.
76  */
77 pragma solidity ^0.8.2;
78 
79 
80 library BytesLib {
81     
82     function concat(
83         bytes memory _preBytes,
84         bytes memory _postBytes
85     )
86         internal
87         pure
88         returns (bytes memory)
89     {
90         bytes memory tempBytes;
91 
92         assembly {
93             // Get a location of some free memory and store it in tempBytes as
94             // Solidity does for memory variables.
95             tempBytes := mload(0x40)
96 
97             // Store the length of the first bytes array at the beginning of
98             // the memory for tempBytes.
99             let length := mload(_preBytes)
100             mstore(tempBytes, length)
101 
102             // Maintain a memory counter for the current write location in the
103             // temp bytes array by adding the 32 bytes for the array length to
104             // the starting location.
105             let mc := add(tempBytes, 0x20)
106             // Stop copying when the memory counter reaches the length of the
107             // first bytes array.
108             let end := add(mc, length)
109 
110             for {
111                 // Initialize a copy counter to the start of the _preBytes data,
112                 // 32 bytes into its memory.
113                 let cc := add(_preBytes, 0x20)
114             } lt(mc, end) {
115                 // Increase both counters by 32 bytes each iteration.
116                 mc := add(mc, 0x20)
117                 cc := add(cc, 0x20)
118             } {
119                 // Write the _preBytes data into the tempBytes memory 32 bytes
120                 // at a time.
121                 mstore(mc, mload(cc))
122             }
123 
124             // Add the length of _postBytes to the current length of tempBytes
125             // and store it as the new length in the first 32 bytes of the
126             // tempBytes memory.
127             length := mload(_postBytes)
128             mstore(tempBytes, add(length, mload(tempBytes)))
129 
130             // Move the memory counter back from a multiple of 0x20 to the
131             // actual end of the _preBytes data.
132             mc := end
133             // Stop copying when the memory counter reaches the new combined
134             // length of the arrays.
135             end := add(mc, length)
136 
137             for {
138                 let cc := add(_postBytes, 0x20)
139             } lt(mc, end) {
140                 mc := add(mc, 0x20)
141                 cc := add(cc, 0x20)
142             } {
143                 mstore(mc, mload(cc))
144             }
145 
146             // Update the free-memory pointer by padding our last write location
147             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
148             // next 32 byte block, then round down to the nearest multiple of
149             // 32. If the sum of the length of the two arrays is zero then add
150             // one before rounding down to leave a blank 32 bytes (the length block with 0).
151             mstore(0x40, and(
152               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
153               not(31) // Round down to the nearest 32 bytes.
154             ))
155         }
156 
157         return tempBytes;
158     }
159 
160 }
161 // File: @openzeppelin/contracts@4.3.2/utils/Strings.sol
162 
163 
164 
165 pragma solidity ^0.8.0;
166 
167 /**
168  * @dev String operations.
169  */
170 library Strings {
171     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
172 
173     /**
174      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
175      */
176     function toString(uint256 value) internal pure returns (string memory) {
177         // Inspired by OraclizeAPI's implementation - MIT licence
178         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
179 
180         if (value == 0) {
181             return "0";
182         }
183         uint256 temp = value;
184         uint256 digits;
185         while (temp != 0) {
186             digits++;
187             temp /= 10;
188         }
189         bytes memory buffer = new bytes(digits);
190         while (value != 0) {
191             digits -= 1;
192             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
193             value /= 10;
194         }
195         return string(buffer);
196     }
197 
198     /**
199      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
200      */
201     function toHexString(uint256 value) internal pure returns (string memory) {
202         if (value == 0) {
203             return "0x00";
204         }
205         uint256 temp = value;
206         uint256 length = 0;
207         while (temp != 0) {
208             length++;
209             temp >>= 8;
210         }
211         return toHexString(value, length);
212     }
213 
214     /**
215      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
216      */
217     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
218         bytes memory buffer = new bytes(2 * length + 2);
219         buffer[0] = "0";
220         buffer[1] = "x";
221         for (uint256 i = 2 * length + 1; i > 1; --i) {
222             buffer[i] = _HEX_SYMBOLS[value & 0xf];
223             value >>= 4;
224         }
225         require(value == 0, "Strings: hex length insufficient");
226         return string(buffer);
227     }
228 }
229 
230 // File: @openzeppelin/contracts@4.3.2/utils/Context.sol
231 
232 
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Provides information about the current execution context, including the
238  * sender of the transaction and its data. While these are generally available
239  * via msg.sender and msg.data, they should not be accessed in such a direct
240  * manner, since when dealing with meta-transactions the account sending and
241  * paying for execution may not be the actual sender (as far as an application
242  * is concerned).
243  *
244  * This contract is only required for intermediate, library-like contracts.
245  */
246 abstract contract Context {
247     function _msgSender() internal view virtual returns (address) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view virtual returns (bytes calldata) {
252         return msg.data;
253     }
254 }
255 
256 // File: @openzeppelin/contracts@4.3.2/access/Ownable.sol
257 
258 
259 
260 pragma solidity ^0.8.0;
261 
262 
263 /**
264  * @dev Contract module which provides a basic access control mechanism, where
265  * there is an account (an owner) that can be granted exclusive access to
266  * specific functions.
267  *
268  * By default, the owner account will be the one that deploys the contract. This
269  * can later be changed with {transferOwnership}.
270  *
271  * This module is used through inheritance. It will make available the modifier
272  * `onlyOwner`, which can be applied to your functions to restrict their use to
273  * the owner.
274  */
275 abstract contract Ownable is Context {
276     address private _owner;
277 
278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279 
280     /**
281      * @dev Initializes the contract setting the deployer as the initial owner.
282      */
283     constructor() {
284         _setOwner(_msgSender());
285     }
286 
287     /**
288      * @dev Returns the address of the current owner.
289      */
290     function owner() public view virtual returns (address) {
291         return _owner;
292     }
293 
294     /**
295      * @dev Throws if called by any account other than the owner.
296      */
297     modifier onlyOwner() {
298         require(owner() == _msgSender(), "Ownable: caller is not the owner");
299         _;
300     }
301 
302     /**
303      * @dev Leaves the contract without owner. It will not be possible to call
304      * `onlyOwner` functions anymore. Can only be called by the current owner.
305      *
306      * NOTE: Renouncing ownership will leave the contract without an owner,
307      * thereby removing any functionality that is only available to the owner.
308      */
309     function renounceOwnership() public virtual onlyOwner {
310         _setOwner(address(0));
311     }
312 
313     /**
314      * @dev Transfers ownership of the contract to a new account (`newOwner`).
315      * Can only be called by the current owner.
316      */
317     function transferOwnership(address newOwner) public virtual onlyOwner {
318         require(newOwner != address(0), "Ownable: new owner is the zero address");
319         _setOwner(newOwner);
320     }
321 
322     function _setOwner(address newOwner) private {
323         address oldOwner = _owner;
324         _owner = newOwner;
325         emit OwnershipTransferred(oldOwner, newOwner);
326     }
327 }
328 
329 // File: @openzeppelin/contracts@4.3.2/utils/Address.sol
330 
331 
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @dev Collection of functions related to the address type
337  */
338 library Address {
339     /**
340      * @dev Returns true if `account` is a contract.
341      *
342      * [IMPORTANT]
343      * ====
344      * It is unsafe to assume that an address for which this function returns
345      * false is an externally-owned account (EOA) and not a contract.
346      *
347      * Among others, `isContract` will return false for the following
348      * types of addresses:
349      *
350      *  - an externally-owned account
351      *  - a contract in construction
352      *  - an address where a contract will be created
353      *  - an address where a contract lived, but was destroyed
354      * ====
355      */
356     function isContract(address account) internal view returns (bool) {
357         // This method relies on extcodesize, which returns 0 for contracts in
358         // construction, since the code is only stored at the end of the
359         // constructor execution.
360 
361         uint256 size;
362         assembly {
363             size := extcodesize(account)
364         }
365         return size > 0;
366     }
367 
368     /**
369      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
370      * `recipient`, forwarding all available gas and reverting on errors.
371      *
372      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
373      * of certain opcodes, possibly making contracts go over the 2300 gas limit
374      * imposed by `transfer`, making them unable to receive funds via
375      * `transfer`. {sendValue} removes this limitation.
376      *
377      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
378      *
379      * IMPORTANT: because control is transferred to `recipient`, care must be
380      * taken to not create reentrancy vulnerabilities. Consider using
381      * {ReentrancyGuard} or the
382      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
383      */
384     function sendValue(address payable recipient, uint256 amount) internal {
385         require(address(this).balance >= amount, "Address: insufficient balance");
386 
387         (bool success, ) = recipient.call{value: amount}("");
388         require(success, "Address: unable to send value, recipient may have reverted");
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
409     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
410         return functionCall(target, data, "Address: low-level call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
415      * `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, 0, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but also transferring `value` wei to `target`.
430      *
431      * Requirements:
432      *
433      * - the calling contract must have an ETH balance of at least `value`.
434      * - the called Solidity function must be `payable`.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(
439         address target,
440         bytes memory data,
441         uint256 value
442     ) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
448      * with `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCallWithValue(
453         address target,
454         bytes memory data,
455         uint256 value,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         require(address(this).balance >= value, "Address: insufficient balance for call");
459         require(isContract(target), "Address: call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.call{value: value}(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
467      * but performing a static call.
468      *
469      * _Available since v3.3._
470      */
471     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
472         return functionStaticCall(target, data, "Address: low-level static call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal view returns (bytes memory) {
486         require(isContract(target), "Address: static call to non-contract");
487 
488         (bool success, bytes memory returndata) = target.staticcall(data);
489         return verifyCallResult(success, returndata, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but performing a delegate call.
495      *
496      * _Available since v3.4._
497      */
498     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
499         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         require(isContract(target), "Address: delegate call to non-contract");
514 
515         (bool success, bytes memory returndata) = target.delegatecall(data);
516         return verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     /**
520      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
521      * revert reason using the provided one.
522      *
523      * _Available since v4.3._
524      */
525     function verifyCallResult(
526         bool success,
527         bytes memory returndata,
528         string memory errorMessage
529     ) internal pure returns (bytes memory) {
530         if (success) {
531             return returndata;
532         } else {
533             // Look for revert reason and bubble it up if present
534             if (returndata.length > 0) {
535                 // The easiest way to bubble the revert reason is using memory via assembly
536 
537                 assembly {
538                     let returndata_size := mload(returndata)
539                     revert(add(32, returndata), returndata_size)
540                 }
541             } else {
542                 revert(errorMessage);
543             }
544         }
545     }
546 }
547 
548 // File: @openzeppelin/contracts@4.3.2/token/ERC721/IERC721Receiver.sol
549 
550 
551 
552 pragma solidity ^0.8.0;
553 
554 /**
555  * @title ERC721 token receiver interface
556  * @dev Interface for any contract that wants to support safeTransfers
557  * from ERC721 asset contracts.
558  */
559 interface IERC721Receiver {
560     /**
561      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
562      * by `operator` from `from`, this function is called.
563      *
564      * It must return its Solidity selector to confirm the token transfer.
565      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
566      *
567      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
568      */
569     function onERC721Received(
570         address operator,
571         address from,
572         uint256 tokenId,
573         bytes calldata data
574     ) external returns (bytes4);
575 }
576 
577 // File: @openzeppelin/contracts@4.3.2/utils/introspection/IERC165.sol
578 
579 
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @dev Interface of the ERC165 standard, as defined in the
585  * https://eips.ethereum.org/EIPS/eip-165[EIP].
586  *
587  * Implementers can declare support of contract interfaces, which can then be
588  * queried by others ({ERC165Checker}).
589  *
590  * For an implementation, see {ERC165}.
591  */
592 interface IERC165 {
593     /**
594      * @dev Returns true if this contract implements the interface defined by
595      * `interfaceId`. See the corresponding
596      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
597      * to learn more about how these ids are created.
598      *
599      * This function call must use less than 30 000 gas.
600      */
601     function supportsInterface(bytes4 interfaceId) external view returns (bool);
602 }
603 
604 // File: @openzeppelin/contracts@4.3.2/utils/introspection/ERC165.sol
605 
606 
607 
608 pragma solidity ^0.8.0;
609 
610 
611 /**
612  * @dev Implementation of the {IERC165} interface.
613  *
614  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
615  * for the additional interface id that will be supported. For example:
616  *
617  * ```solidity
618  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
619  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
620  * }
621  * ```
622  *
623  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
624  */
625 abstract contract ERC165 is IERC165 {
626     /**
627      * @dev See {IERC165-supportsInterface}.
628      */
629     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
630         return interfaceId == type(IERC165).interfaceId;
631     }
632 }
633 
634 // File: @openzeppelin/contracts@4.3.2/token/ERC721/IERC721.sol
635 
636 
637 
638 pragma solidity ^0.8.0;
639 
640 
641 /**
642  * @dev Required interface of an ERC721 compliant contract.
643  */
644 interface IERC721 is IERC165 {
645     /**
646      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
647      */
648     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
649 
650     /**
651      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
652      */
653     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
654 
655     /**
656      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
657      */
658     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
659 
660     /**
661      * @dev Returns the number of tokens in ``owner``'s account.
662      */
663     function balanceOf(address owner) external view returns (uint256 balance);
664 
665     /**
666      * @dev Returns the owner of the `tokenId` token.
667      *
668      * Requirements:
669      *
670      * - `tokenId` must exist.
671      */
672     function ownerOf(uint256 tokenId) external view returns (address owner);
673 
674     /**
675      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
676      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
677      *
678      * Requirements:
679      *
680      * - `from` cannot be the zero address.
681      * - `to` cannot be the zero address.
682      * - `tokenId` token must exist and be owned by `from`.
683      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
684      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
685      *
686      * Emits a {Transfer} event.
687      */
688     function safeTransferFrom(
689         address from,
690         address to,
691         uint256 tokenId
692     ) external;
693 
694     /**
695      * @dev Transfers `tokenId` token from `from` to `to`.
696      *
697      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
698      *
699      * Requirements:
700      *
701      * - `from` cannot be the zero address.
702      * - `to` cannot be the zero address.
703      * - `tokenId` token must be owned by `from`.
704      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
705      *
706      * Emits a {Transfer} event.
707      */
708     function transferFrom(
709         address from,
710         address to,
711         uint256 tokenId
712     ) external;
713 
714     /**
715      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
716      * The approval is cleared when the token is transferred.
717      *
718      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
719      *
720      * Requirements:
721      *
722      * - The caller must own the token or be an approved operator.
723      * - `tokenId` must exist.
724      *
725      * Emits an {Approval} event.
726      */
727     function approve(address to, uint256 tokenId) external;
728 
729     /**
730      * @dev Returns the account approved for `tokenId` token.
731      *
732      * Requirements:
733      *
734      * - `tokenId` must exist.
735      */
736     function getApproved(uint256 tokenId) external view returns (address operator);
737 
738     /**
739      * @dev Approve or remove `operator` as an operator for the caller.
740      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
741      *
742      * Requirements:
743      *
744      * - The `operator` cannot be the caller.
745      *
746      * Emits an {ApprovalForAll} event.
747      */
748     function setApprovalForAll(address operator, bool _approved) external;
749 
750     /**
751      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
752      *
753      * See {setApprovalForAll}
754      */
755     function isApprovedForAll(address owner, address operator) external view returns (bool);
756 
757     /**
758      * @dev Safely transfers `tokenId` token from `from` to `to`.
759      *
760      * Requirements:
761      *
762      * - `from` cannot be the zero address.
763      * - `to` cannot be the zero address.
764      * - `tokenId` token must exist and be owned by `from`.
765      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
766      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
767      *
768      * Emits a {Transfer} event.
769      */
770     function safeTransferFrom(
771         address from,
772         address to,
773         uint256 tokenId,
774         bytes calldata data
775     ) external;
776 }
777 
778 // File: @openzeppelin/contracts@4.3.2/token/ERC721/extensions/IERC721Metadata.sol
779 
780 
781 
782 pragma solidity ^0.8.0;
783 
784 
785 /**
786  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
787  * @dev See https://eips.ethereum.org/EIPS/eip-721
788  */
789 interface IERC721Metadata is IERC721 {
790     /**
791      * @dev Returns the token collection name.
792      */
793     function name() external view returns (string memory);
794 
795     /**
796      * @dev Returns the token collection symbol.
797      */
798     function symbol() external view returns (string memory);
799 
800     /**
801      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
802      */
803     function tokenURI(uint256 tokenId) external view returns (string memory);
804 }
805 
806 // File: @openzeppelin/contracts@4.3.2/token/ERC721/ERC721.sol
807 
808 
809 
810 pragma solidity ^0.8.0;
811 
812 
813 
814 
815 
816 
817 
818 
819 /**
820  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
821  * the Metadata extension, but not including the Enumerable extension, which is available separately as
822  * {ERC721Enumerable}.
823  */
824 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
825     using Address for address;
826     using Strings for uint256;
827 
828     // Token name
829     string private _name;
830 
831     // Token symbol
832     string private _symbol;
833 
834     // Mapping from token ID to owner address
835     mapping(uint256 => address) private _owners;
836 
837     // Mapping owner address to token count
838     mapping(address => uint256) private _balances;
839 
840     // Mapping from token ID to approved address
841     mapping(uint256 => address) private _tokenApprovals;
842 
843     // Mapping from owner to operator approvals
844     mapping(address => mapping(address => bool)) private _operatorApprovals;
845 
846     /**
847      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
848      */
849     constructor(string memory name_, string memory symbol_) {
850         _name = name_;
851         _symbol = symbol_;
852     }
853 
854     /**
855      * @dev See {IERC165-supportsInterface}.
856      */
857     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
858         return
859             interfaceId == type(IERC721).interfaceId ||
860             interfaceId == type(IERC721Metadata).interfaceId ||
861             super.supportsInterface(interfaceId);
862     }
863 
864     /**
865      * @dev See {IERC721-balanceOf}.
866      */
867     function balanceOf(address owner) public view virtual override returns (uint256) {
868         require(owner != address(0), "ERC721: balance query for the zero address");
869         return _balances[owner];
870     }
871 
872     /**
873      * @dev See {IERC721-ownerOf}.
874      */
875     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
876         address owner = _owners[tokenId];
877         require(owner != address(0), "ERC721: owner query for nonexistent token");
878         return owner;
879     }
880 
881     /**
882      * @dev See {IERC721Metadata-name}.
883      */
884     function name() public view virtual override returns (string memory) {
885         return _name;
886     }
887 
888     /**
889      * @dev See {IERC721Metadata-symbol}.
890      */
891     function symbol() public view virtual override returns (string memory) {
892         return _symbol;
893     }
894 
895     /**
896      * @dev See {IERC721Metadata-tokenURI}.
897      */
898     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
899         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
900 
901         string memory baseURI = _baseURI();
902         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
903     }
904 
905     /**
906      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
907      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
908      * by default, can be overriden in child contracts.
909      */
910     function _baseURI() internal view virtual returns (string memory) {
911         return "";
912     }
913 
914     /**
915      * @dev See {IERC721-approve}.
916      */
917     function approve(address to, uint256 tokenId) public virtual override {
918         address owner = ERC721.ownerOf(tokenId);
919         require(to != owner, "ERC721: approval to current owner");
920 
921         require(
922             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
923             "ERC721: approve caller is not owner nor approved for all"
924         );
925 
926         _approve(to, tokenId);
927     }
928 
929     /**
930      * @dev See {IERC721-getApproved}.
931      */
932     function getApproved(uint256 tokenId) public view virtual override returns (address) {
933         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
934 
935         return _tokenApprovals[tokenId];
936     }
937 
938     /**
939      * @dev See {IERC721-setApprovalForAll}.
940      */
941     function setApprovalForAll(address operator, bool approved) public virtual override {
942         require(operator != _msgSender(), "ERC721: approve to caller");
943 
944         _operatorApprovals[_msgSender()][operator] = approved;
945         emit ApprovalForAll(_msgSender(), operator, approved);
946     }
947 
948     /**
949      * @dev See {IERC721-isApprovedForAll}.
950      */
951     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
952         return _operatorApprovals[owner][operator];
953     }
954 
955     /**
956      * @dev See {IERC721-transferFrom}.
957      */
958     function transferFrom(
959         address from,
960         address to,
961         uint256 tokenId
962     ) public virtual override {
963         //solhint-disable-next-line max-line-length
964         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
965 
966         _transfer(from, to, tokenId);
967     }
968 
969     /**
970      * @dev See {IERC721-safeTransferFrom}.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) public virtual override {
977         safeTransferFrom(from, to, tokenId, "");
978     }
979 
980     /**
981      * @dev See {IERC721-safeTransferFrom}.
982      */
983     function safeTransferFrom(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) public virtual override {
989         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
990         _safeTransfer(from, to, tokenId, _data);
991     }
992 
993     /**
994      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
995      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
996      *
997      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
998      *
999      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1000      * implement alternative mechanisms to perform token transfer, such as signature-based.
1001      *
1002      * Requirements:
1003      *
1004      * - `from` cannot be the zero address.
1005      * - `to` cannot be the zero address.
1006      * - `tokenId` token must exist and be owned by `from`.
1007      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _safeTransfer(
1012         address from,
1013         address to,
1014         uint256 tokenId,
1015         bytes memory _data
1016     ) internal virtual {
1017         _transfer(from, to, tokenId);
1018         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1019     }
1020 
1021     /**
1022      * @dev Returns whether `tokenId` exists.
1023      *
1024      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1025      *
1026      * Tokens start existing when they are minted (`_mint`),
1027      * and stop existing when they are burned (`_burn`).
1028      */
1029     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1030         return _owners[tokenId] != address(0);
1031     }
1032 
1033     /**
1034      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1035      *
1036      * Requirements:
1037      *
1038      * - `tokenId` must exist.
1039      */
1040     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1041         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1042         address owner = ERC721.ownerOf(tokenId);
1043         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1044     }
1045 
1046     /**
1047      * @dev Safely mints `tokenId` and transfers it to `to`.
1048      *
1049      * Requirements:
1050      *
1051      * - `tokenId` must not exist.
1052      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function _safeMint(address to, uint256 tokenId) internal virtual {
1057         _safeMint(to, tokenId, "");
1058     }
1059 
1060     /**
1061      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1062      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1063      */
1064     function _safeMint(
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) internal virtual {
1069         _mint(to, tokenId);
1070         require(
1071             _checkOnERC721Received(address(0), to, tokenId, _data),
1072             "ERC721: transfer to non ERC721Receiver implementer"
1073         );
1074     }
1075 
1076     /**
1077      * @dev Mints `tokenId` and transfers it to `to`.
1078      *
1079      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1080      *
1081      * Requirements:
1082      *
1083      * - `tokenId` must not exist.
1084      * - `to` cannot be the zero address.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _mint(address to, uint256 tokenId) internal virtual {
1089         require(to != address(0), "ERC721: mint to the zero address");
1090         require(!_exists(tokenId), "ERC721: token already minted");
1091 
1092         _beforeTokenTransfer(address(0), to, tokenId);
1093 
1094         _balances[to] += 1;
1095         _owners[tokenId] = to;
1096 
1097         emit Transfer(address(0), to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev Destroys `tokenId`.
1102      * The approval is cleared when the token is burned.
1103      *
1104      * Requirements:
1105      *
1106      * - `tokenId` must exist.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _burn(uint256 tokenId) internal virtual {
1111         address owner = ERC721.ownerOf(tokenId);
1112 
1113         _beforeTokenTransfer(owner, address(0), tokenId);
1114 
1115         // Clear approvals
1116         _approve(address(0), tokenId);
1117 
1118         _balances[owner] -= 1;
1119         delete _owners[tokenId];
1120 
1121         emit Transfer(owner, address(0), tokenId);
1122     }
1123 
1124     /**
1125      * @dev Transfers `tokenId` from `from` to `to`.
1126      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1127      *
1128      * Requirements:
1129      *
1130      * - `to` cannot be the zero address.
1131      * - `tokenId` token must be owned by `from`.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _transfer(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) internal virtual {
1140         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1141         require(to != address(0), "ERC721: transfer to the zero address");
1142 
1143         _beforeTokenTransfer(from, to, tokenId);
1144 
1145         // Clear approvals from the previous owner
1146         _approve(address(0), tokenId);
1147 
1148         _balances[from] -= 1;
1149         _balances[to] += 1;
1150         _owners[tokenId] = to;
1151 
1152         emit Transfer(from, to, tokenId);
1153     }
1154 
1155     /**
1156      * @dev Approve `to` to operate on `tokenId`
1157      *
1158      * Emits a {Approval} event.
1159      */
1160     function _approve(address to, uint256 tokenId) internal virtual {
1161         _tokenApprovals[tokenId] = to;
1162         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
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
1183                 return retval == IERC721Receiver.onERC721Received.selector;
1184             } catch (bytes memory reason) {
1185                 if (reason.length == 0) {
1186                     revert("ERC721: transfer to non ERC721Receiver implementer");
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
1199      * @dev Hook that is called before any token transfer. This includes minting
1200      * and burning.
1201      *
1202      * Calling conditions:
1203      *
1204      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1205      * transferred to `to`.
1206      * - When `from` is zero, `tokenId` will be minted for `to`.
1207      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1208      * - `from` and `to` are never both zero.
1209      *
1210      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1211      */
1212     function _beforeTokenTransfer(
1213         address from,
1214         address to,
1215         uint256 tokenId
1216     ) internal virtual {}
1217 }
1218 
1219 // File: contracts/ordinalSignOnChain.sol
1220 
1221 
1222 pragma solidity ^0.8.2;
1223 
1224 
1225 
1226 
1227 
1228 contract OrdinalSignOnChain is ERC721, Ownable {
1229     
1230     /* Members */
1231     using Strings   for uint256;
1232     using BytesLib  for bytes;
1233     
1234     struct Particle { uint x; uint y; uint r; }
1235     struct Owner    { address _address; uint _tokenId; uint _paletteIndex;}
1236 
1237     mapping(uint => Owner)  _owners;
1238 
1239     uint        private _signPrice      = .01 ether;
1240     uint        private _saleIsOpen     = 1;
1241     uint        private _counter        = 0;
1242     uint[27]    private _consumed       = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
1243 
1244     /* Members */
1245 
1246     /* Constructors */
1247     constructor() ERC721("OrdinalSignOnChain", "OSOC") {}
1248     /* Constructors */
1249     
1250     /* Private methods */
1251     function getIterations(bytes memory _data) private pure returns (uint) {
1252         
1253         uint[9] memory _iterations = [uint(35),uint(40),uint(45),uint(50),uint(55),uint(60),uint(65),uint(70),uint(75)];
1254 
1255         uint _its = _iterations[((uint(uint8(_data[0])) + uint(uint8(_data[_data.length-1]))) / 2) % _iterations.length];
1256         
1257         return _its;
1258         
1259     }
1260     
1261     function getPalette(uint _pIdx) public pure returns (string[8] memory) {
1262         string[8][27] memory _palette        = [
1263     		["Pantone's Glowing Gone*",         "#FFFFFF","#000000","#0f28f0","#dc609f","#fefe55","#841bf0","#841bf0"],
1264     		["Autumn",          				"#f5efdd","#411d13","#753422","#B05B3B","#D79771","#d6c28c","#d6ad9b"],
1265             ["Winter",          				"#ffffff","#08022a","#0F044C","#141E61","#787A91","#bfd4ee","#dadada"],
1266             ["Summer",          				"#edf3ff","#214e4b","#236e96","#15b2d3","#ffd700","#f3872f","#ff598f"],
1267             ["Spring",          				"#f6fff4","#14403b","#134a1b","#96bb7c","#bcef96","#eece4d","#d58be5"],
1268             ["Happy",           				"#fff5fc","#2e2269","#845EC2","#ec873a","#ebe300","#FF5E78","#32b9ff"],
1269             ["CyberPunk v1",   	 				"#270446","#a26df9","#0e2ea8","#e716dd","#f9143a","#0cffe1","#f7ff13"],
1270             ["Neon",            				"#000000","#c8ff07","#b31fc6","#f21170","#04daf6","#ff5200","#fcff00"],
1271             ["Blossom",        					"#fff6fc","#736a64","#f1d1d6","#ffabe1","#a685e2","#6155a6","#40274f"],
1272             ["Oriental",        				"#f5efdd","#000000","#9f0c28","#1A90D9","#f0a612","#f08808","#F23E16"],
1273             ["ViceCity",        				"#1c1241","#ffffff","#ecc720","#74aae8","#8f6cbf","#c05b85","#ca1481"],
1274             ["Volcano",         				"#f9f7ef","#000000","#38001C","#b92200","#f57e00","#fac30c","#86806b"],
1275             ["God of War",      				"#f9f7ef","#730215","#443737","#400909","#FF0000","#000000","#960c33"],
1276             ["Rainbow",         				"#FFFFFF","#8d5a00","#970ff2","#0597f2","#49d907","#f2e404","#c60835"],
1277             ["Halloween",       				"#f9f7ef","#000000","#000000","#150050","#3F0071","#610094","#ef8c29"],
1278             ["Red",             				"#FFFFFF","#C50000","#C50000","#D43434","#E26767","#F19B9B","#FFCECE"],
1279             ["Pink",            				"#f8f0fd","#b300b0","#EB00E7","#ED30E5","#EF60E3","#F08FE1","#F2BFDF"],
1280             ["Pantone's Glowing Purple*", 		"#FFFFFF","#5912a3","#5912a3","#831bf1","#8b47d0","#af7fe1","#cba3f3"],
1281             ["Pantone's Glowing Blue*",   		"#FFFFFF","#091998","#0a1ba7","#0e28f0","#0D0D98","#120DC3","#180DED"],
1282             ["SkyBlue",        				 	"#FFFFFF","#188BFF","#188BFF","#4AA2FF","#7CBAFF","#AED1FF","#abb9d2"],
1283             ["Turquise",        				"#FFFFFF","#0CC69E","#0CC69E","#37CFAF","#61D8C1","#8CE0D2","#B6E9E3"],
1284             ["Green",           				"#FFFFFF","#0A7105","#0A7105","#2C952B","#4EB852","#6FDC78","#91FF9E"],
1285             ["Grass Green",     				"#FFFFFF","#658505","#A1D408","#B0DC37","#BFE367","#CDEB96","#DCF2C5"],
1286             ["Pantone's Glowing Yellow*", 		"#000000","#fff000","#fff000","#fefe55","#FFF56F","#FFF9A7","#fffcce"],
1287             ["Orange",          				"#FFFFFF","#a14600","#cb5800","#FF6F00","#F87F21","#F18E42","#EA9E63"],
1288             ["Black",           				"#ffffff","#000000","#000000","#282828","#505050","#777777","#9F9F9F"],
1289             ["Rome Purple",     				"#FFFFFF","#483659","#603d7c","#644b7c","#644b7c","#80609f","#ac7ad3"] 
1290         ];
1291         
1292         return _palette[_pIdx];
1293     }
1294 
1295     function getPaletteIndex(uint _tokenId) private view returns (uint) {
1296         
1297         uint _r = uint(keccak256(abi.encodePacked(_tokenId))) % 27;
1298         
1299         uint _s = _r;
1300         
1301         uint[27] memory __consumed  = _consumed;
1302         uint[27] memory _limits     = [uint(8),uint(51),uint(51),uint(39),uint(40),uint(42),uint(18),uint(42),uint(30),uint(48),uint(32),uint(24),uint(18),uint(44),uint(52),uint(76),uint(65),uint(8),uint(8),uint(66),uint(60),uint(65),uint(55),uint(8),uint(65),uint(81),uint(15)];
1303 
1304         while (__consumed[_r] + 1 > _limits[_r])
1305         {
1306             _r++;
1307             
1308             if (_r >= 27)
1309             {
1310                 _r = 0;
1311             }
1312             
1313             if (_r == _s)
1314             {
1315                 revert("Can not produce random from palette id!");
1316             }
1317         }
1318         
1319         return _r;
1320 
1321     }
1322 
1323     function sqrt(uint x) private pure returns (uint y) {
1324         
1325         uint z = (x + 1) / 2;
1326         y = x;
1327         while (z < y) 
1328         {
1329             y = z;
1330             z = (x / z + z) / 2;
1331         }
1332         
1333     }
1334 
1335     function distance(uint x1, uint y1, uint x2, uint y2) private pure returns (uint) {
1336         
1337         uint x = x1 > x2 ? x1 - x2 : x2 - x1;
1338         uint y = y1 > y2 ? y1 - y2 : y2 - y1;
1339         return sqrt(x * x + y * y);
1340         
1341     }
1342     
1343     function betweenUInt(uint _v, uint _min, uint _max) private pure returns (uint) {
1344         
1345         return (_v < _min) ? _min : (_v > _max ? _max : _v);
1346         
1347     }
1348     
1349     function inRect(uint _v, uint _r) private pure returns (uint) {
1350         
1351         return _r > _v ? _r : (_v + _r > 500 ? 500 - _r : _v);
1352         
1353     }
1354 
1355     function intersect(Particle[] memory _particles, Particle memory _p, uint _its) private pure returns (bool) {
1356         
1357         if (_particles.length == 0)
1358         {
1359             return false;
1360         }
1361         
1362         for (uint _index = 0; _index < _its; _index++)
1363         {
1364             if (distance(_p.x, _p.y, _particles[_index].x, _particles[_index].y) < _p.r + _particles[_index].r)
1365             {
1366                 return true;
1367             }
1368         }
1369         
1370         return false;
1371     }
1372     
1373     function createParticles(bytes memory _data, uint _its) private pure returns (Particle[] memory) {
1374         
1375         uint[42] memory _radius = [uint(2),uint(3),uint(4),uint(5),uint(5),uint(5),uint(5),uint(5),uint(6),uint(6),uint(6),uint(6),uint(6),uint(7),uint(7),uint(7),uint(7),uint(7),uint(8),uint(8),uint(8),uint(8),uint(8),uint(9),uint(9),uint(9),uint(9),uint(9),uint(9),uint(9),uint(9),uint(9),uint(12),uint(14),uint(14),uint(14),uint(15),uint(16),uint(18),uint(19),uint(22),uint(32)];
1376         uint _di = 0;
1377         uint _r;
1378         uint _x;
1379         uint _y;
1380         uint _t; 
1381         
1382         Particle memory _p;
1383 
1384         Particle[] memory _particles = new Particle[](_its);
1385 
1386         for (uint _i = 0; _i < _its; _i++)
1387         {
1388             _t = 0;
1389                   
1390             do
1391             {
1392                 _x = uint(uint8(_data[_di % _data.length]));
1393                 
1394                 _r = _radius[_x % 42];
1395                 
1396                 _y = uint(uint8(_data[(_di+1) % _data.length]));
1397 
1398                 _p = Particle(inRect((_x * (_i+1)) % 500, _r), inRect((_y * (_i+1)) % 500, _r), _r);
1399                 
1400                 _di += 2;
1401                 
1402                 _t++;
1403                 
1404                 if (_t > 20)
1405                 {
1406                     break;
1407                 }
1408             
1409             } while (intersect(_particles, _p, _its));
1410             
1411             _particles[_i] = _p;
1412         }
1413 
1414         return _particles;
1415     }
1416     
1417     function drawLines(Particle[] memory _p, string memory _c, uint _a, uint _its, bytes memory _l, uint _e, string[4] memory _o) private pure returns (bytes memory, uint) {
1418         
1419         uint _d;
1420 
1421         for (uint _b = 0; _b < _its; _b++)
1422         {
1423             if (_a != _b)
1424             {
1425                 _d = distance(_p[_a].x, _p[_a].y, _p[_b].x, _p[_b].y);
1426                 if (_d > 0 && _d < 71)
1427                 {
1428                     _e++;
1429                     _l = _l.concat(
1430                         abi.encodePacked(
1431                             '<line x1="',_p[_a].x.toString(),'" y1="',_p[_a].y.toString(),'" x2="',_p[_b].x.toString(),'" y2="',_p[_b].y.toString(),'" stroke="', _c, '" stroke-opacity="',_o[_d % _o.length],'"/>'
1432                         )
1433                     );
1434                     
1435                 }
1436             }
1437         }
1438         
1439         return (_l, _e);
1440     }
1441     
1442     function draw(string[8] memory _palette, Particle[] memory _p, uint _its) private pure returns (bytes memory _r, uint _e){
1443  
1444         bytes memory _n;
1445         bytes memory _l;
1446         
1447         string[4] memory _o  = ["0.09","0.11","0.18","0.30"];
1448         string[4] memory _d  = ["0.5","0.9","1","1.2"];
1449 
1450         _e = 0;
1451         
1452         for (uint _a = 0; _a < _its; _a++)
1453         {
1454             _n = _n.concat(
1455                 abi.encodePacked(
1456                     '<circle cx="',_p[_a].x.toString(),'" cy="',_p[_a].y.toString(),'" r="',_p[_a].r.toString(),'" fill="', _palette[(_a % 5)+3], '" opacity="0"><animate attributeName="opacity" dur="0.8s" keyTimes="0;0.25;0.5;0.75;1" values="0;0.25;0.5;0.75;1" repeatCount="1" begin="',_d[_a % 4],'s" fill="freeze"/></circle>'
1457                 )
1458             );
1459             
1460             (_l, _e) = drawLines(_p, _palette[2], _a, _its, _l, _e, _o);
1461         }
1462         
1463         _r = _r.concat(abi.encodePacked('<svg width="500" height="500" viewBox="0 0 500 500" xmlns="http://www.w3.org/2000/svg"><path d="M 0 0 H 500 V 500 H 0 V 0" fill="', _palette[1], '"/><g opacity="0"><animate attributeName="opacity" dur="0.8s" keyTimes="0;0.25;0.5;0.75;1" values="0;0.25;0.5;0.75;1" repeatCount="1" begin="2s" fill="freeze"/>'));
1464         _r = _r.concat(_l);
1465         _r = _r.concat(abi.encodePacked("</g>"));
1466         _r = _r.concat(_n);
1467         _r = _r.concat(abi.encodePacked('</svg>'));
1468     }
1469 
1470     function plot(address _address, uint _tokenId, uint _pIdx) private pure returns (bytes memory)  {
1471         
1472         bytes memory _data = abi.encodePacked(keccak256(abi.encodePacked(_tokenId))).concat(abi.encodePacked(_address));
1473         
1474         string[8] memory _palette = getPalette(_pIdx);
1475 
1476         uint _its = getIterations(_data);
1477 
1478         (bytes memory _s, uint _e) = draw(_palette, createParticles(_data, _its), _its);
1479 
1480         return abi.encodePacked(
1481             '", "attributes": [{"trait_type": "Name","value": "', _palette[0],
1482             '"},{"trait_type": "Complexity","value": "', (_its * _e).toString(),
1483             '"},{"trait_type": "NodeCount","value": "', _its.toString(),
1484             '"},{"trait_type": "EdgeCount","value": "', _e.toString(),
1485             '"}],"image": "data:image/svg+xml;base64,', Base64.encode(_s)
1486         );
1487 
1488     }
1489     /* Private methods */
1490 
1491     /* Public methods */
1492     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1493         
1494         Owner memory _owner = _owners[tokenId];
1495         
1496         require(_owner._address != address(0x0), "Invalid token id!");
1497 
1498         return string(
1499             abi.encodePacked(
1500                 'data:application/json;base64,', 
1501                 Base64.encode(
1502                     abi.encodePacked(
1503                         '{"name": "Your Sign OnChain #',
1504                         tokenId.toString(),
1505                         string(plot(_owner._address, tokenId, _owner._paletteIndex)),
1506                         '"}'
1507                     )
1508                 )
1509             )
1510         );
1511         
1512     }
1513     
1514     function freeMint() public {
1515         
1516         require(_saleIsOpen == 1, "Sales not open at the moment!");
1517         
1518         uint __counter = _counter;
1519         
1520         require(__counter + 1 < 1091, "Too many sign minting request!");
1521 
1522         require(this.balanceOf(msg.sender) + 1 <= 1, "Per wallet limit reached! Per wallet limit is 1 tokens.");
1523 
1524         uint _pIdx;
1525 
1526         _pIdx = getPaletteIndex(_counter + 1);
1527         
1528         _safeMint(msg.sender, _counter + 1);
1529         
1530         _counter++;
1531         
1532         __counter = _counter;
1533         
1534         _consumed[_pIdx]++;
1535         
1536         _owners[_counter] = Owner(msg.sender, __counter, _pIdx);
1537     }
1538 
1539     function buy(uint numberOfTokens) public payable {
1540         
1541         require(_saleIsOpen == 1, "Sales not open at the moment!");
1542         
1543         require(_signPrice > 0, "No sign price set at the moment!");
1544         
1545         require(numberOfTokens > 0 && numberOfTokens <= 10, "Too many sign minting request!");
1546         
1547         uint __counter = _counter;
1548         
1549         require(__counter + numberOfTokens < 1091, "Too many sign minting request!");
1550 
1551         require(_signPrice * numberOfTokens <= msg.value, "Insufficient funds!");
1552 
1553         uint _pIdx;
1554 
1555         for (uint _index = 0; _index < numberOfTokens; _index++)
1556         {
1557             _pIdx = getPaletteIndex(_counter + 1);
1558             
1559             _safeMint(msg.sender, _counter + 1);
1560             
1561             _counter++;
1562             
1563             __counter = _counter;
1564             
1565             _consumed[_pIdx]++;
1566             
1567             _owners[_counter] = Owner(msg.sender, __counter, _pIdx);
1568         }
1569 
1570     }
1571 
1572     function ownerMint() public onlyOwner {
1573         for (uint _index = 1092; _index <= 1111; _index++)
1574         {
1575             uint _pIdx = getPaletteIndex(_index);
1576         
1577             _safeMint(owner(), _index);
1578 
1579             _owners[_index] = Owner(owner(), _index, _pIdx);
1580         }
1581     }
1582     
1583     function withdraw() public onlyOwner {
1584         uint256 balance = address(this).balance;
1585         payable(msg.sender).transfer(balance);
1586     }
1587 
1588     /* Public methods */
1589  
1590 
1591 }