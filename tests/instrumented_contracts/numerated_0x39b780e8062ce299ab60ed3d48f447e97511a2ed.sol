1 // File: GenesisRocks10000_flat.sol
2 
3 
4 // File: base64-sol/base64.sol
5 
6 
7 
8 pragma solidity >=0.6.0;
9 
10 /// @title Base64
11 /// @author Brecht Devos - <brecht@loopring.org>
12 /// @notice Provides functions for encoding/decoding base64
13 library Base64 {
14     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
15     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
16                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
17                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
18                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
19 
20     function encode(bytes memory data) internal pure returns (string memory) {
21         if (data.length == 0) return '';
22 
23         // load the table into memory
24         string memory table = TABLE_ENCODE;
25 
26         // multiply by 4/3 rounded up
27         uint256 encodedLen = 4 * ((data.length + 2) / 3);
28 
29         // add some extra buffer at the end required for the writing
30         string memory result = new string(encodedLen + 32);
31 
32         assembly {
33             // set the actual output length
34             mstore(result, encodedLen)
35 
36             // prepare the lookup table
37             let tablePtr := add(table, 1)
38 
39             // input ptr
40             let dataPtr := data
41             let endPtr := add(dataPtr, mload(data))
42 
43             // result ptr, jump over length
44             let resultPtr := add(result, 32)
45 
46             // run over the input, 3 bytes at a time
47             for {} lt(dataPtr, endPtr) {}
48             {
49                 // read 3 bytes
50                 dataPtr := add(dataPtr, 3)
51                 let input := mload(dataPtr)
52 
53                 // write 4 characters
54                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
55                 resultPtr := add(resultPtr, 1)
56                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
57                 resultPtr := add(resultPtr, 1)
58                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
59                 resultPtr := add(resultPtr, 1)
60                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
61                 resultPtr := add(resultPtr, 1)
62             }
63 
64             // padding with '='
65             switch mod(mload(data), 3)
66             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
67             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
68         }
69 
70         return result;
71     }
72 
73     function decode(string memory _data) internal pure returns (bytes memory) {
74         bytes memory data = bytes(_data);
75 
76         if (data.length == 0) return new bytes(0);
77         require(data.length % 4 == 0, "invalid base64 decoder input");
78 
79         // load the table into memory
80         bytes memory table = TABLE_DECODE;
81 
82         // every 4 characters represent 3 bytes
83         uint256 decodedLen = (data.length / 4) * 3;
84 
85         // add some extra buffer at the end required for the writing
86         bytes memory result = new bytes(decodedLen + 32);
87 
88         assembly {
89             // padding with '='
90             let lastBytes := mload(add(data, mload(data)))
91             if eq(and(lastBytes, 0xFF), 0x3d) {
92                 decodedLen := sub(decodedLen, 1)
93                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
94                     decodedLen := sub(decodedLen, 1)
95                 }
96             }
97 
98             // set the actual output length
99             mstore(result, decodedLen)
100 
101             // prepare the lookup table
102             let tablePtr := add(table, 1)
103 
104             // input ptr
105             let dataPtr := data
106             let endPtr := add(dataPtr, mload(data))
107 
108             // result ptr, jump over length
109             let resultPtr := add(result, 32)
110 
111             // run over the input, 4 characters at a time
112             for {} lt(dataPtr, endPtr) {}
113             {
114                // read 4 characters
115                dataPtr := add(dataPtr, 4)
116                let input := mload(dataPtr)
117 
118                // write 3 bytes
119                let output := add(
120                    add(
121                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
122                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
123                    add(
124                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
125                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
126                     )
127                 )
128                 mstore(resultPtr, shl(232, output))
129                 resultPtr := add(resultPtr, 3)
130             }
131         }
132 
133         return result;
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Strings.sol
138 
139 
140 
141 pragma solidity ^0.8.0;
142 
143 /**
144  * @dev String operations.
145  */
146 library Strings {
147     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
148 
149     /**
150      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
151      */
152     function toString(uint256 value) internal pure returns (string memory) {
153         // Inspired by OraclizeAPI's implementation - MIT licence
154         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
155 
156         if (value == 0) {
157             return "0";
158         }
159         uint256 temp = value;
160         uint256 digits;
161         while (temp != 0) {
162             digits++;
163             temp /= 10;
164         }
165         bytes memory buffer = new bytes(digits);
166         while (value != 0) {
167             digits -= 1;
168             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
169             value /= 10;
170         }
171         return string(buffer);
172     }
173 
174     /**
175      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
176      */
177     function toHexString(uint256 value) internal pure returns (string memory) {
178         if (value == 0) {
179             return "0x00";
180         }
181         uint256 temp = value;
182         uint256 length = 0;
183         while (temp != 0) {
184             length++;
185             temp >>= 8;
186         }
187         return toHexString(value, length);
188     }
189 
190     /**
191      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
192      */
193     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
194         bytes memory buffer = new bytes(2 * length + 2);
195         buffer[0] = "0";
196         buffer[1] = "x";
197         for (uint256 i = 2 * length + 1; i > 1; --i) {
198             buffer[i] = _HEX_SYMBOLS[value & 0xf];
199             value >>= 4;
200         }
201         require(value == 0, "Strings: hex length insufficient");
202         return string(buffer);
203     }
204 }
205 
206 // File: @openzeppelin/contracts/utils/Context.sol
207 
208 
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @dev Provides information about the current execution context, including the
214  * sender of the transaction and its data. While these are generally available
215  * via msg.sender and msg.data, they should not be accessed in such a direct
216  * manner, since when dealing with meta-transactions the account sending and
217  * paying for execution may not be the actual sender (as far as an application
218  * is concerned).
219  *
220  * This contract is only required for intermediate, library-like contracts.
221  */
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes calldata) {
228         return msg.data;
229     }
230 }
231 
232 // File: @openzeppelin/contracts/access/Ownable.sol
233 
234 
235 
236 pragma solidity ^0.8.0;
237 
238 
239 /**
240  * @dev Contract module which provides a basic access control mechanism, where
241  * there is an account (an owner) that can be granted exclusive access to
242  * specific functions.
243  *
244  * By default, the owner account will be the one that deploys the contract. This
245  * can later be changed with {transferOwnership}.
246  *
247  * This module is used through inheritance. It will make available the modifier
248  * `onlyOwner`, which can be applied to your functions to restrict their use to
249  * the owner.
250  */
251 abstract contract Ownable is Context {
252     address private _owner;
253 
254     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
255 
256     /**
257      * @dev Initializes the contract setting the deployer as the initial owner.
258      */
259     constructor() {
260         _setOwner(_msgSender());
261     }
262 
263     /**
264      * @dev Returns the address of the current owner.
265      */
266     function owner() public view virtual returns (address) {
267         return _owner;
268     }
269 
270     /**
271      * @dev Throws if called by any account other than the owner.
272      */
273     modifier onlyOwner() {
274         require(owner() == _msgSender(), "Ownable: caller is not the owner");
275         _;
276     }
277 
278     /**
279      * @dev Leaves the contract without owner. It will not be possible to call
280      * `onlyOwner` functions anymore. Can only be called by the current owner.
281      *
282      * NOTE: Renouncing ownership will leave the contract without an owner,
283      * thereby removing any functionality that is only available to the owner.
284      */
285     function renounceOwnership() public virtual onlyOwner {
286         _setOwner(address(0));
287     }
288 
289     /**
290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
291      * Can only be called by the current owner.
292      */
293     function transferOwnership(address newOwner) public virtual onlyOwner {
294         require(newOwner != address(0), "Ownable: new owner is the zero address");
295         _setOwner(newOwner);
296     }
297 
298     function _setOwner(address newOwner) private {
299         address oldOwner = _owner;
300         _owner = newOwner;
301         emit OwnershipTransferred(oldOwner, newOwner);
302     }
303 }
304 
305 // File: @openzeppelin/contracts/utils/Address.sol
306 
307 
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @dev Collection of functions related to the address type
313  */
314 library Address {
315     /**
316      * @dev Returns true if `account` is a contract.
317      *
318      * [IMPORTANT]
319      * ====
320      * It is unsafe to assume that an address for which this function returns
321      * false is an externally-owned account (EOA) and not a contract.
322      *
323      * Among others, `isContract` will return false for the following
324      * types of addresses:
325      *
326      *  - an externally-owned account
327      *  - a contract in construction
328      *  - an address where a contract will be created
329      *  - an address where a contract lived, but was destroyed
330      * ====
331      */
332     function isContract(address account) internal view returns (bool) {
333         // This method relies on extcodesize, which returns 0 for contracts in
334         // construction, since the code is only stored at the end of the
335         // constructor execution.
336 
337         uint256 size;
338         assembly {
339             size := extcodesize(account)
340         }
341         return size > 0;
342     }
343 
344     /**
345      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
346      * `recipient`, forwarding all available gas and reverting on errors.
347      *
348      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
349      * of certain opcodes, possibly making contracts go over the 2300 gas limit
350      * imposed by `transfer`, making them unable to receive funds via
351      * `transfer`. {sendValue} removes this limitation.
352      *
353      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
354      *
355      * IMPORTANT: because control is transferred to `recipient`, care must be
356      * taken to not create reentrancy vulnerabilities. Consider using
357      * {ReentrancyGuard} or the
358      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
359      */
360     function sendValue(address payable recipient, uint256 amount) internal {
361         require(address(this).balance >= amount, "Address: insufficient balance");
362 
363         (bool success, ) = recipient.call{value: amount}("");
364         require(success, "Address: unable to send value, recipient may have reverted");
365     }
366 
367     /**
368      * @dev Performs a Solidity function call using a low level `call`. A
369      * plain `call` is an unsafe replacement for a function call: use this
370      * function instead.
371      *
372      * If `target` reverts with a revert reason, it is bubbled up by this
373      * function (like regular Solidity function calls).
374      *
375      * Returns the raw returned data. To convert to the expected return value,
376      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
377      *
378      * Requirements:
379      *
380      * - `target` must be a contract.
381      * - calling `target` with `data` must not revert.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
386         return functionCall(target, data, "Address: low-level call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
391      * `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         return functionCallWithValue(target, data, 0, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but also transferring `value` wei to `target`.
406      *
407      * Requirements:
408      *
409      * - the calling contract must have an ETH balance of at least `value`.
410      * - the called Solidity function must be `payable`.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value
418     ) internal returns (bytes memory) {
419         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
424      * with `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(
429         address target,
430         bytes memory data,
431         uint256 value,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         require(address(this).balance >= value, "Address: insufficient balance for call");
435         require(isContract(target), "Address: call to non-contract");
436 
437         (bool success, bytes memory returndata) = target.call{value: value}(data);
438         return verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
448         return functionStaticCall(target, data, "Address: low-level static call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(
458         address target,
459         bytes memory data,
460         string memory errorMessage
461     ) internal view returns (bytes memory) {
462         require(isContract(target), "Address: static call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.staticcall(data);
465         return verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but performing a delegate call.
471      *
472      * _Available since v3.4._
473      */
474     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
475         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
480      * but performing a delegate call.
481      *
482      * _Available since v3.4._
483      */
484     function functionDelegateCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         require(isContract(target), "Address: delegate call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.delegatecall(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
497      * revert reason using the provided one.
498      *
499      * _Available since v4.3._
500      */
501     function verifyCallResult(
502         bool success,
503         bytes memory returndata,
504         string memory errorMessage
505     ) internal pure returns (bytes memory) {
506         if (success) {
507             return returndata;
508         } else {
509             // Look for revert reason and bubble it up if present
510             if (returndata.length > 0) {
511                 // The easiest way to bubble the revert reason is using memory via assembly
512 
513                 assembly {
514                     let returndata_size := mload(returndata)
515                     revert(add(32, returndata), returndata_size)
516                 }
517             } else {
518                 revert(errorMessage);
519             }
520         }
521     }
522 }
523 
524 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
525 
526 
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @title ERC721 token receiver interface
532  * @dev Interface for any contract that wants to support safeTransfers
533  * from ERC721 asset contracts.
534  */
535 interface IERC721Receiver {
536     /**
537      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
538      * by `operator` from `from`, this function is called.
539      *
540      * It must return its Solidity selector to confirm the token transfer.
541      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
542      *
543      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
544      */
545     function onERC721Received(
546         address operator,
547         address from,
548         uint256 tokenId,
549         bytes calldata data
550     ) external returns (bytes4);
551 }
552 
553 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
554 
555 
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
583 
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @dev Implementation of the {IERC165} interface.
589  *
590  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
591  * for the additional interface id that will be supported. For example:
592  *
593  * ```solidity
594  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
595  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
596  * }
597  * ```
598  *
599  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
600  */
601 abstract contract ERC165 is IERC165 {
602     /**
603      * @dev See {IERC165-supportsInterface}.
604      */
605     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
606         return interfaceId == type(IERC165).interfaceId;
607     }
608 }
609 
610 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
611 
612 
613 
614 pragma solidity ^0.8.0;
615 
616 
617 /**
618  * @dev Required interface of an ERC721 compliant contract.
619  */
620 interface IERC721 is IERC165 {
621     /**
622      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
623      */
624     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
625 
626     /**
627      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
628      */
629     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
630 
631     /**
632      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
633      */
634     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
635 
636     /**
637      * @dev Returns the number of tokens in ``owner``'s account.
638      */
639     function balanceOf(address owner) external view returns (uint256 balance);
640 
641     /**
642      * @dev Returns the owner of the `tokenId` token.
643      *
644      * Requirements:
645      *
646      * - `tokenId` must exist.
647      */
648     function ownerOf(uint256 tokenId) external view returns (address owner);
649 
650     /**
651      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
652      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
653      *
654      * Requirements:
655      *
656      * - `from` cannot be the zero address.
657      * - `to` cannot be the zero address.
658      * - `tokenId` token must exist and be owned by `from`.
659      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
660      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
661      *
662      * Emits a {Transfer} event.
663      */
664     function safeTransferFrom(
665         address from,
666         address to,
667         uint256 tokenId
668     ) external;
669 
670     /**
671      * @dev Transfers `tokenId` token from `from` to `to`.
672      *
673      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
674      *
675      * Requirements:
676      *
677      * - `from` cannot be the zero address.
678      * - `to` cannot be the zero address.
679      * - `tokenId` token must be owned by `from`.
680      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
681      *
682      * Emits a {Transfer} event.
683      */
684     function transferFrom(
685         address from,
686         address to,
687         uint256 tokenId
688     ) external;
689 
690     /**
691      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
692      * The approval is cleared when the token is transferred.
693      *
694      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
695      *
696      * Requirements:
697      *
698      * - The caller must own the token or be an approved operator.
699      * - `tokenId` must exist.
700      *
701      * Emits an {Approval} event.
702      */
703     function approve(address to, uint256 tokenId) external;
704 
705     /**
706      * @dev Returns the account approved for `tokenId` token.
707      *
708      * Requirements:
709      *
710      * - `tokenId` must exist.
711      */
712     function getApproved(uint256 tokenId) external view returns (address operator);
713 
714     /**
715      * @dev Approve or remove `operator` as an operator for the caller.
716      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
717      *
718      * Requirements:
719      *
720      * - The `operator` cannot be the caller.
721      *
722      * Emits an {ApprovalForAll} event.
723      */
724     function setApprovalForAll(address operator, bool _approved) external;
725 
726     /**
727      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
728      *
729      * See {setApprovalForAll}
730      */
731     function isApprovedForAll(address owner, address operator) external view returns (bool);
732 
733     /**
734      * @dev Safely transfers `tokenId` token from `from` to `to`.
735      *
736      * Requirements:
737      *
738      * - `from` cannot be the zero address.
739      * - `to` cannot be the zero address.
740      * - `tokenId` token must exist and be owned by `from`.
741      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
742      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743      *
744      * Emits a {Transfer} event.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes calldata data
751     ) external;
752 }
753 
754 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
755 
756 
757 
758 pragma solidity ^0.8.0;
759 
760 
761 /**
762  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
763  * @dev See https://eips.ethereum.org/EIPS/eip-721
764  */
765 interface IERC721Metadata is IERC721 {
766     /**
767      * @dev Returns the token collection name.
768      */
769     function name() external view returns (string memory);
770 
771     /**
772      * @dev Returns the token collection symbol.
773      */
774     function symbol() external view returns (string memory);
775 
776     /**
777      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
778      */
779     function tokenURI(uint256 tokenId) external view returns (string memory);
780 }
781 
782 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
783 
784 
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
797  * the Metadata extension, but not including the Enumerable extension, which is available separately as
798  * {ERC721Enumerable}.
799  */
800 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
801     using Address for address;
802     using Strings for uint256;
803 
804     // Token name
805     string private _name;
806 
807     // Token symbol
808     string private _symbol;
809 
810     // Mapping from token ID to owner address
811     mapping(uint256 => address) private _owners;
812 
813     // Mapping owner address to token count
814     mapping(address => uint256) private _balances;
815 
816     // Mapping from token ID to approved address
817     mapping(uint256 => address) private _tokenApprovals;
818 
819     // Mapping from owner to operator approvals
820     mapping(address => mapping(address => bool)) private _operatorApprovals;
821 
822     /**
823      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
824      */
825     constructor(string memory name_, string memory symbol_) {
826         _name = name_;
827         _symbol = symbol_;
828     }
829 
830     /**
831      * @dev See {IERC165-supportsInterface}.
832      */
833     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
834         return
835             interfaceId == type(IERC721).interfaceId ||
836             interfaceId == type(IERC721Metadata).interfaceId ||
837             super.supportsInterface(interfaceId);
838     }
839 
840     /**
841      * @dev See {IERC721-balanceOf}.
842      */
843     function balanceOf(address owner) public view virtual override returns (uint256) {
844         require(owner != address(0), "ERC721: balance query for the zero address");
845         return _balances[owner];
846     }
847 
848     /**
849      * @dev See {IERC721-ownerOf}.
850      */
851     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
852         address owner = _owners[tokenId];
853         require(owner != address(0), "ERC721: owner query for nonexistent token");
854         return owner;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-name}.
859      */
860     function name() public view virtual override returns (string memory) {
861         return _name;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-symbol}.
866      */
867     function symbol() public view virtual override returns (string memory) {
868         return _symbol;
869     }
870 
871     /**
872      * @dev See {IERC721Metadata-tokenURI}.
873      */
874     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
875         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
876 
877         string memory baseURI = _baseURI();
878         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
879     }
880 
881     /**
882      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
883      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
884      * by default, can be overriden in child contracts.
885      */
886     function _baseURI() internal view virtual returns (string memory) {
887         return "";
888     }
889 
890     /**
891      * @dev See {IERC721-approve}.
892      */
893     function approve(address to, uint256 tokenId) public virtual override {
894         address owner = ERC721.ownerOf(tokenId);
895         require(to != owner, "ERC721: approval to current owner");
896 
897         require(
898             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
899             "ERC721: approve caller is not owner nor approved for all"
900         );
901 
902         _approve(to, tokenId);
903     }
904 
905     /**
906      * @dev See {IERC721-getApproved}.
907      */
908     function getApproved(uint256 tokenId) public view virtual override returns (address) {
909         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
910 
911         return _tokenApprovals[tokenId];
912     }
913 
914     /**
915      * @dev See {IERC721-setApprovalForAll}.
916      */
917     function setApprovalForAll(address operator, bool approved) public virtual override {
918         require(operator != _msgSender(), "ERC721: approve to caller");
919 
920         _operatorApprovals[_msgSender()][operator] = approved;
921         emit ApprovalForAll(_msgSender(), operator, approved);
922     }
923 
924     /**
925      * @dev See {IERC721-isApprovedForAll}.
926      */
927     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
928         return _operatorApprovals[owner][operator];
929     }
930 
931     /**
932      * @dev See {IERC721-transferFrom}.
933      */
934     function transferFrom(
935         address from,
936         address to,
937         uint256 tokenId
938     ) public virtual override {
939         //solhint-disable-next-line max-line-length
940         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
941 
942         _transfer(from, to, tokenId);
943     }
944 
945     /**
946      * @dev See {IERC721-safeTransferFrom}.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId
952     ) public virtual override {
953         safeTransferFrom(from, to, tokenId, "");
954     }
955 
956     /**
957      * @dev See {IERC721-safeTransferFrom}.
958      */
959     function safeTransferFrom(
960         address from,
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) public virtual override {
965         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
966         _safeTransfer(from, to, tokenId, _data);
967     }
968 
969     /**
970      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
971      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
972      *
973      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
974      *
975      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
976      * implement alternative mechanisms to perform token transfer, such as signature-based.
977      *
978      * Requirements:
979      *
980      * - `from` cannot be the zero address.
981      * - `to` cannot be the zero address.
982      * - `tokenId` token must exist and be owned by `from`.
983      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _safeTransfer(
988         address from,
989         address to,
990         uint256 tokenId,
991         bytes memory _data
992     ) internal virtual {
993         _transfer(from, to, tokenId);
994         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
995     }
996 
997     /**
998      * @dev Returns whether `tokenId` exists.
999      *
1000      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1001      *
1002      * Tokens start existing when they are minted (`_mint`),
1003      * and stop existing when they are burned (`_burn`).
1004      */
1005     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1006         return _owners[tokenId] != address(0);
1007     }
1008 
1009     /**
1010      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1011      *
1012      * Requirements:
1013      *
1014      * - `tokenId` must exist.
1015      */
1016     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1017         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1018         address owner = ERC721.ownerOf(tokenId);
1019         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1020     }
1021 
1022     /**
1023      * @dev Safely mints `tokenId` and transfers it to `to`.
1024      *
1025      * Requirements:
1026      *
1027      * - `tokenId` must not exist.
1028      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _safeMint(address to, uint256 tokenId) internal virtual {
1033         _safeMint(to, tokenId, "");
1034     }
1035 
1036     /**
1037      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1038      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1039      */
1040     function _safeMint(
1041         address to,
1042         uint256 tokenId,
1043         bytes memory _data
1044     ) internal virtual {
1045         _mint(to, tokenId);
1046         require(
1047             _checkOnERC721Received(address(0), to, tokenId, _data),
1048             "ERC721: transfer to non ERC721Receiver implementer"
1049         );
1050     }
1051 
1052     /**
1053      * @dev Mints `tokenId` and transfers it to `to`.
1054      *
1055      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must not exist.
1060      * - `to` cannot be the zero address.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _mint(address to, uint256 tokenId) internal virtual {
1065         require(to != address(0), "ERC721: mint to the zero address");
1066         require(!_exists(tokenId), "ERC721: token already minted");
1067 
1068         _beforeTokenTransfer(address(0), to, tokenId);
1069 
1070         _balances[to] += 1;
1071         _owners[tokenId] = to;
1072 
1073         emit Transfer(address(0), to, tokenId);
1074     }
1075 
1076     /**
1077      * @dev Destroys `tokenId`.
1078      * The approval is cleared when the token is burned.
1079      *
1080      * Requirements:
1081      *
1082      * - `tokenId` must exist.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _burn(uint256 tokenId) internal virtual {
1087         address owner = ERC721.ownerOf(tokenId);
1088 
1089         _beforeTokenTransfer(owner, address(0), tokenId);
1090 
1091         // Clear approvals
1092         _approve(address(0), tokenId);
1093 
1094         _balances[owner] -= 1;
1095         delete _owners[tokenId];
1096 
1097         emit Transfer(owner, address(0), tokenId);
1098     }
1099 
1100     /**
1101      * @dev Transfers `tokenId` from `from` to `to`.
1102      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1103      *
1104      * Requirements:
1105      *
1106      * - `to` cannot be the zero address.
1107      * - `tokenId` token must be owned by `from`.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _transfer(
1112         address from,
1113         address to,
1114         uint256 tokenId
1115     ) internal virtual {
1116         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1117         require(to != address(0), "ERC721: transfer to the zero address");
1118 
1119         _beforeTokenTransfer(from, to, tokenId);
1120 
1121         // Clear approvals from the previous owner
1122         _approve(address(0), tokenId);
1123 
1124         _balances[from] -= 1;
1125         _balances[to] += 1;
1126         _owners[tokenId] = to;
1127 
1128         emit Transfer(from, to, tokenId);
1129     }
1130 
1131     /**
1132      * @dev Approve `to` to operate on `tokenId`
1133      *
1134      * Emits a {Approval} event.
1135      */
1136     function _approve(address to, uint256 tokenId) internal virtual {
1137         _tokenApprovals[tokenId] = to;
1138         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1139     }
1140 
1141     /**
1142      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1143      * The call is not executed if the target address is not a contract.
1144      *
1145      * @param from address representing the previous owner of the given token ID
1146      * @param to target address that will receive the tokens
1147      * @param tokenId uint256 ID of the token to be transferred
1148      * @param _data bytes optional data to send along with the call
1149      * @return bool whether the call correctly returned the expected magic value
1150      */
1151     function _checkOnERC721Received(
1152         address from,
1153         address to,
1154         uint256 tokenId,
1155         bytes memory _data
1156     ) private returns (bool) {
1157         if (to.isContract()) {
1158             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1159                 return retval == IERC721Receiver.onERC721Received.selector;
1160             } catch (bytes memory reason) {
1161                 if (reason.length == 0) {
1162                     revert("ERC721: transfer to non ERC721Receiver implementer");
1163                 } else {
1164                     assembly {
1165                         revert(add(32, reason), mload(reason))
1166                     }
1167                 }
1168             }
1169         } else {
1170             return true;
1171         }
1172     }
1173 
1174     /**
1175      * @dev Hook that is called before any token transfer. This includes minting
1176      * and burning.
1177      *
1178      * Calling conditions:
1179      *
1180      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1181      * transferred to `to`.
1182      * - When `from` is zero, `tokenId` will be minted for `to`.
1183      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1184      * - `from` and `to` are never both zero.
1185      *
1186      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1187      */
1188     function _beforeTokenTransfer(
1189         address from,
1190         address to,
1191         uint256 tokenId
1192     ) internal virtual {}
1193 }
1194 
1195 // File: GenesisRocks10000.sol
1196 
1197 
1198 
1199 pragma solidity ^0.8.0;
1200 
1201 
1202 
1203 
1204 
1205 
1206 interface EtherRock {
1207   function sellRock (uint rockNumber, uint price) external;
1208   function giftRock (uint rockNumber, address receiver) external;
1209 }
1210 
1211 contract RockWarden is Ownable {
1212   function claim(uint256 id, EtherRock rocks) public onlyOwner {
1213     rocks.sellRock(id, type(uint256).max);
1214     rocks.giftRock(id, owner());
1215   }
1216   
1217   function withdraw(uint256 id, EtherRock rocks, address recipient) public onlyOwner {
1218     rocks.giftRock(id, recipient);
1219   }
1220 }
1221 
1222 contract GenesisRocks10000 is ERC721, Ownable {
1223   EtherRock public rocks = EtherRock(0x37504AE0282f5f334ED29b4548646f887977b7cC);
1224 
1225   using Address for address;
1226   using Strings for uint256;
1227 
1228   string private _baseTokenURI;
1229   uint256 private _totalSupply;
1230 
1231   mapping(address => address) public wardens;
1232   
1233   string[] hashes = [
1234     "bafybeibkx5swmemvqkc6n3umzuaplcssrq6bp2uyh3n2vhdywzv6lszv3q/0.png",
1235     "bafybeid6g2ue77ioxviruwhbz77nz7fyyomf7c24c2ya7i725uto7plpxe/1.png",
1236     "bafybeigwsvacvsu7puct5p2wyenietreui6yealsshmc4w3cnlx2vtwgai/2.png",
1237     "bafybeihaszjogt4ksjzcx5abvqsfcxc4ow35nb33idqrzelbwget7sxtzi/3.png",
1238     "bafybeicll7pdbhxfsnejqjgsgjfspnxpv5g6rmkqrkty7mnfbgztlhnnxe/4.png",
1239     "bafybeiazo5mjnq5ot6l3msgbrwsqo3qc43czdzyc7goe4vxjlk4ciwan34/5.png",
1240     "bafybeie62no5b4pwobhcs2ritotdf2baiiw65sjraxyeabxr4ewtqu5534/6.png",
1241     "bafybeibrtcuqfuredutyvezpx4jixl34zps5tx54j4x23b56bhre4l4bmq/7.png",
1242     "bafybeihjtbnrkbsks4xjqyqniginmhxi4miwwq7cfderohicec3tsjnojq/8.png",
1243     "bafybeifjmbzw4623nkbrji5vmahgygtkeikl2id23fddym4fovspeargle/9.png",
1244     "bafybeibljith3s2p7bhewtfjabpssvsxchhr7peuok3ovksedai24steca/10.png",
1245     "bafybeihyg4rr22joidsj3iabhakrtzccfw7yu4e4jivi5k2g6dxzx37cji/11.png",
1246     "bafybeidl4vfgozexxpnd2f6jlrvzukg57w6rx7hsp4mqyhonfe2jqsofk4/12.png",
1247     "bafybeiegqsp5fhjfxjlxn4pz7mjyqrfufujl7q5b7tc4m6c54qwiui56dq/13.png",
1248     "bafybeibnfylvb5wt52snk4ysjpjva375qrsfuefmpazjips57vqh7qotue/14.png",
1249     "bafybeienhpn3mmhz6thd4fsompabimm5nrckkdmee5dmbttwoenscvq35a/15.png",
1250     "bafybeih2nzl4whby3boqyhmxduurcpxc42swsnrdclvlnkymm3e5sazb3q/16.png",
1251     "bafybeiefla4dqvtitzc5gcxzkfjsyqeglrmgiqf7otvb3fyfulycg6slbi/17.png",
1252     "bafybeicmbsfmms2uou2j2bnkk4zclwoame4g3gfrtf3uqldc7wynvjixdy/18.png",
1253     "bafybeid55k5gcprfldsm6up4gn2zit2yxkiulub2dj4ch2u3cvyyvi5spm/19.png",
1254     "bafybeieyvsycayibpt6ba2sheynybvwspdp4hmpd5korwan62d7xh4ifoi/20.png",
1255     "bafybeidgyyy7uyjdszhjmjdxydjvv2ml4yubkkoszhw7jqk5cnq4q5p5ku/21.png",
1256     "bafybeiabef6qwjur72567ontn2enb6q6a6y2nmrxe22dptvkjmekboqxbq/22.png",
1257     "bafybeiaky5urvqxfbqgw7cdnz3y2jfgmmn5etkdiyststppncjt4obmsem/23.png",
1258     "bafybeihzdaz2zdybzruzaylgodrc5wnc4ovdgxecd5vr6cnmxiwa6bsznu/24.png",
1259     "bafybeid4k5owwkp2iwpwysx2fkrm22cw3uocpibiayefbyq3djndckehky/25.png",
1260     "bafybeidisyhllcubgt7fonj75wba5pd5fav5ouyp2pfobknj65ddt77gtu/26.png",
1261     "bafybeihy5ebpxx66nrit6ab37di4o4fnudxuo6uynyfyw6usqeomty53yi/27.png",
1262     "bafybeie7p3vv2mife23ny32sryybfvkthvtkhhr3odaz6ez3yxkztchylq/28.png",
1263     "bafybeidi7fynufmcpf62icnl353cpthyvlccvzmiagb347wjpkaeszm2uy/29.png",
1264     "bafybeiggt4qctt4zc4ok2xrabbbdiftod2mk2keaq3fedtvlfomjqwvsri/30.png",
1265     "bafybeihp7dluwbvde5xhcsde4n7tfhjkumpk7fkowslrhgwjsciykyxv2e/31.png",
1266     "bafybeiepuyb3muwc4cktrehvy7evqh2b742gshrukvvpas33kxvsubmihy/32.png",
1267     "bafybeicmdrbgecx74o4a6vxqa46xdiw3skhtkgi45c5wu2psj6posdqcii/33.png",
1268     "bafybeigcfno3crdjkorj4zrmb7ljqzjmeazycvyk7xxigufmdtabrnzlqi/34.png",
1269     "bafybeibqhj4w7vpeylpbmsoea2tfcxhnc64vwirdzrede2qoi4aj2h55om/35.png",
1270     "bafybeib2hmg65ee3vu7wz27sb42lknkv3olu23qhemqticymqnfzmkn54e/36.png",
1271     "bafybeifs2ebu6abo735ju7j4md6t3hkadxz645k57ucdizvqgciy4ps62i/37.png",
1272     "bafybeif35al6hft2zxiclyht4o67q6ikyky7h3mhfo5hutbyfzynolne4m/38.png",
1273     "bafybeibq6vhh3ow6ttibcbv4aepdl4m4rptf5zjsss2fhtjedecskzkhpy/39.png",
1274     "bafybeihtdemergxlzro3gqbnw6lnrwsv5egk5c4byhgg53645hbyztnifu/40.png",
1275     "bafybeigsv55x7wl3ylvxgsocjlbuacl6msd25uivlgnvnan5imosxs72ue/41.png",
1276     "bafybeidmjlrgqnw5jbyaugdnqoznfd5nhbmideuzisc3pihevofanvcf7m/42.png",
1277     "bafybeiaho2ryguxp4kikrx6l4qqnmioilvlxtzukdzazl2e2sjanjg3j5i/43.png",
1278     "bafybeigyxtw4sflpjzhqojrceazskx7r7di2pzm6lmm5574pkjvlu5wprq/44.png",
1279     "bafybeibhstjoxjpb3ifqg2pkjbjt2begv7o6yyqv2nvq6mytmpyx63pu2q/45.png",
1280     "bafybeibd2a22uu5nwogbnbcd2j63jhoxzebx7jiw2mz4of5eipimp3vlfm/46.png",
1281     "bafybeihej5csmxgut63guxwpcmjlpcqydeswac3ml3daxsxyaool5ubqrm/47.png",
1282     "bafybeifv25l3j7vuio4fpibldnz6pnc7ulcpjpkm56uiy34ix4xhayhrea/48.png",
1283     "bafybeidavpbhl5kmw2tw5m77wdadvyii4cn3kj2qa774kzqxt5hhlfk6de/49.png",
1284     "bafybeih3myim7cot6qgkufpf4qax4jwfosb3ay2j7ngnp23nlndbak7gbu/50.png",
1285     "bafybeibjr4isxcym3br4dw3qyhg2lqfxs7swnej6leovld7o6j4caiv2eq/51.png",
1286     "bafybeifbctyqcaw7omczjuhtusrqj6inph7duxrummkjwu54aeljenjyea/52.png",
1287     "bafybeihtrcyp5dvmtlrumyarinhkplroynd2mhqprbpkml6pjrhjh5jqby/53.png",
1288     "bafybeie3bjbnkrzz6qxm6prwkzbqson6mioo2sugkb3x5yrihad34s3jyy/54.png",
1289     "bafybeib7sv5z7imkhpaooyrczhpblbupqlt3gqbcwq2qxpqikbdruhj7h4/55.png",
1290     "bafybeifmlm6mrnyulltqnteod7gte5gjazpqcgfwwpkakrz3wfy3jdogsu/56.png",
1291     "bafybeidfio3epkf6fpqyz2phkfvljakcezwilnfnkuuiywm5temfcaotiu/57.png",
1292     "bafybeifz6omzulksux26v6edmnbzlgibbypzubrkyx6ldlygocnniemchu/58.png",
1293     "bafybeigg5b7ekwbhscgpfcbkvlyvbfchwlgzfap7fijsq2ukpzz2em7sja/59.png",
1294     "bafybeia2bjfwpgonkj7vhhwg77uclpkw6yqollcvaxjxwwriqt76idow4a/60.png",
1295     "bafybeiag2qrodx2ccswb3i2s6y6bk7rtvh7tisrk4xijyl66sb6vuwelru/61.png",
1296     "bafybeibu3mvhofxxm5lsvzuhidepfcxlimdbzz3khisp3irqe66w53hnri/62.png",
1297     "bafybeidlrjyyrhyxibd72ckqptuejqx2kddbcqcpwydtz3vajun2yo4j3a/63.png",
1298     "bafybeibnfwgnv5yiapnx6fhorzhtsbrxyzoheexwmlmr2a2xkxy24keh3q/64.png",
1299     "bafybeiaywoattfnnyzoqdrovfvyulnj44ypkwqxsjz6knsrsr5omooklja/65.png",
1300     "bafybeifiyzfn5og6gr74v6oe4ytwoztszn6sjjzqprehjdew4xge35fyte/66.png",
1301     "bafybeigj57sqg6lwnt2hffigvvvwhpt6ir2hgujmgnqzm6l23rmsqdanei/67.png",
1302     "bafybeiel246xxkwgtz3li7iitx5ujjshjdip7su2zzongk63zgxzhzxuoe/68.png",
1303     "bafybeihj7grfgvonzjcvd2enc3kovwmwcwhhysddb2txb5x2updha4r7qm/69.png",
1304     "bafybeicob7xlej5qdwotmejiizt4dhuvoq3fcdso3fsfcfabokx7hjva2u/70.png",
1305     "bafybeigpzytgwmpdpig3s4l7fdg2w7627c4tz7gxqa742xo6uakmyze7qa/71.png",
1306     "bafybeihze2fkvmli5dm73ymiqztgdni27j3ztffmn2j4syr5wx4naejqiu/72.png",
1307     "bafybeia5falyzlwyt5zhhrkj5xkidjplz4yuaq5ppzs3mmml4tbgvgbcgq/73.png",
1308     "bafybeiexu6gltckfabwhvjmrrq6dokxnfdxydgzuzc4pwehp4asyji7dsi/74.png",
1309     "bafybeihiyvsc4isfvziwo5lg2bqnsoeyx545awvqvyk3afyireviercg2i/75.png",
1310     "bafybeiewjw2bmvclvewxpish4b3h3gokqbvp2rxkuklmroys73s2casno4/76.png",
1311     "bafybeifiyhndowzs5ohsbu6oo3jp2efdyg5r7koiyagbecnc3l3jxtgt4i/77.png",
1312     "bafybeibruwz6z4v2qodbuovpgctiu6qq4xpjgdyvrp5fqih3v33hba2tgi/78.png",
1313     "bafybeiatcunvjtmdhgiz5gaqnc63jvoe4ch5tf3gc2nc63jgdbjnsfnrce/79.png",
1314     "bafybeiekjthxvazasrv2i2fav55xnqcrww23k6z5xa7vbq6ygpj5d4y7nu/80.png",
1315     "bafybeia7x66ub5ninxssddqqhcjg7lhkpajucgjen62haljbtpo2jcl35y/81.png",
1316     "bafybeibgthwxybiyai3i3tismoujkogh4xtipobm6ez2j6kjpdgtbx5rie/82.png",
1317     "bafybeifg5blbog3h7knabnprws7lrt3e3owjc7zqhg5e442hdnmzhpmraq/83.png",
1318     "bafybeihssuwji6vdi6sxaqjifso4o7cdsyxaexfpsbxswqcljgi2k4fcna/84.png",
1319     "bafybeidwih3zspn6r6hnvrihwhggq7mifq6p5keitcmsuucwu2be3yiygu/85.png",
1320     "bafybeibwh7gmwgjwjw3siysytkhyiik3rx5zml5mtqzr4dah65mojlid2q/86.png",
1321     "bafybeiagfudwfwbc52kbxjvfngkdmy3dgj3dd3rptvtjxmw63tgnfrgtja/87.png",
1322     "bafybeifl2wrn3ewx4oh5iw3kh2uctbm2wdw4c75g2ekxxnvif3u3x22vru/88.png",
1323     "bafybeibmxm32pspx2bmpbvf32dh67qg5z4kmqqpuierdo5sbiwdfhz76uy/89.png",
1324     "bafybeihouhmonqdr4scfsgazyenulsl4krvif2l4v2xrhpwi454yh7zsfa/90.png",
1325     "bafybeia47xlh5g4s3b5wf2um5hixjrwvk2njnpzdmizr5ayxylvmrh256y/91.png",
1326     "bafybeifyltspgtm32zn6v5w3jasqkv5nkyugvk6s7btvjyehmllybers7m/92.png",
1327     "bafybeibch2274okimr24j27n7xpxl46iq63f5ros43rp4mzvihuz6hdtzi/93.png",
1328     "bafybeiefji3z6v3aqemjf4cyeqkb2r4cbr4hzqabkgwc5gbm2isv2kjqxq/94.png",
1329     "bafybeigzqm4h3mvmulviqo2sao33dncd4xmnrmemt7jk4luhsl34pmputu/95.png",
1330     "bafybeiaskeyvdkkp2hnpiaww3zhiewhxiq57zha6wshktyjdl6ivvijoia/96.png",
1331     "bafybeic2arp2fuuocdqdcx7tzjgl6m4jfozty7mjt4mvyffjqh2y3oz33y/97.png",
1332     "bafybeidej2nunivmxwsrpqyxmurnflproqobzv3pm7sx3uudpb64cawcxu/98.png",
1333     "bafybeidqpcfb6vg3xevz3n4jyfcl5s2nftftgdqhrnuclcwrsc6wgb2g6u/99.png"
1334   ];
1335     
1336   constructor() ERC721("Genesis Rocks: 10,000", "ROCKS10") {}
1337 
1338   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1339     require(tokenId > 99 && tokenId < 10000);
1340    
1341     string memory image = string(abi.encodePacked(_baseURI(), _hash(tokenId % 100)));
1342 
1343     return string(
1344       abi.encodePacked(
1345         'data:application/json;base64,',
1346         Base64.encode(
1347           bytes(
1348             abi.encodePacked(
1349               '{"name":"',
1350                 string(abi.encodePacked("Rock #", tokenId.toString())),
1351               '", "description":"',
1352                 string(abi.encodePacked("Rock #", tokenId.toString(), " from a contract deployed on the 25th of December, 2017")),
1353               '", "attributes": [{ "trait_type:": "Number", "value": ', tokenId.toString(), ' }], "image": "',
1354                 image,
1355               '"}'
1356             )
1357           )
1358         )
1359       )
1360     );
1361   }
1362   
1363   function _baseURI() internal view virtual override returns (string memory) {
1364     return "ipfs://";
1365   }
1366   
1367   function _hash(uint256 id) internal view virtual returns (string memory) {
1368     return hashes[id];
1369   }
1370   
1371   function totalSupply() public view virtual returns (uint256) {
1372     return _totalSupply;
1373   }
1374     
1375   function wrap(uint256 id) public {
1376     // get warden address
1377     address warden = wardens[_msgSender()];
1378     require(warden != address(0), "Warden not registered");
1379     require(id > 99 && id < 10000);
1380     
1381     // claim rock
1382     RockWarden(warden).claim(id, rocks);
1383     
1384     // mint wrapped rock
1385     _mint(_msgSender(), id);
1386     
1387     // increment supply
1388     _totalSupply += 1;
1389   }
1390   
1391   function unwrap(uint256 id) public {
1392     require(_msgSender() == ownerOf(id));
1393     
1394     // burn wrapped rock
1395     _burn(id);
1396     
1397     // decrement supply
1398     _totalSupply -= 1;
1399     
1400     // send rock to user
1401     rocks.giftRock(id, _msgSender());
1402   }
1403   
1404   function rescue(uint256 id) public {
1405     // get warden address
1406     address warden = wardens[_msgSender()];
1407     require(warden != address(0), "Warden not registered");
1408 
1409     // withdraw rock
1410     RockWarden(warden).withdraw(id, rocks, _msgSender());
1411   }
1412   
1413   function createWarden() public {
1414     address warden = address(new RockWarden());
1415     require(warden != address(0), "Warden address incorrect");
1416     require(wardens[_msgSender()] == address(0), "Warden already created");
1417     wardens[_msgSender()] = warden;
1418   }
1419 }