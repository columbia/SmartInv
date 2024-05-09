1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity >=0.6.0;
3 
4 /// @title Base64
5 /// @author Brecht Devos - <brecht@loopring.org>
6 /// @notice Provides functions for encoding/decoding base64
7 library Base64 {
8     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
9     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
10                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
11                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
12                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
13 
14     function encode(bytes memory data) internal pure returns (string memory) {
15         if (data.length == 0) return '';
16 
17         // load the table into memory
18         string memory table = TABLE_ENCODE;
19 
20         // multiply by 4/3 rounded up
21         uint256 encodedLen = 4 * ((data.length + 2) / 3);
22 
23         // add some extra buffer at the end required for the writing
24         string memory result = new string(encodedLen + 32);
25 
26         assembly {
27             // set the actual output length
28             mstore(result, encodedLen)
29 
30             // prepare the lookup table
31             let tablePtr := add(table, 1)
32 
33             // input ptr
34             let dataPtr := data
35             let endPtr := add(dataPtr, mload(data))
36 
37             // result ptr, jump over length
38             let resultPtr := add(result, 32)
39 
40             // run over the input, 3 bytes at a time
41             for {} lt(dataPtr, endPtr) {}
42             {
43                 // read 3 bytes
44                 dataPtr := add(dataPtr, 3)
45                 let input := mload(dataPtr)
46 
47                 // write 4 characters
48                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
49                 resultPtr := add(resultPtr, 1)
50                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
51                 resultPtr := add(resultPtr, 1)
52                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
53                 resultPtr := add(resultPtr, 1)
54                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
55                 resultPtr := add(resultPtr, 1)
56             }
57 
58             // padding with '='
59             switch mod(mload(data), 3)
60             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
61             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
62         }
63 
64         return result;
65     }
66 
67     function decode(string memory _data) internal pure returns (bytes memory) {
68         bytes memory data = bytes(_data);
69 
70         if (data.length == 0) return new bytes(0);
71         require(data.length % 4 == 0, "invalid base64 decoder input");
72 
73         // load the table into memory
74         bytes memory table = TABLE_DECODE;
75 
76         // every 4 characters represent 3 bytes
77         uint256 decodedLen = (data.length / 4) * 3;
78 
79         // add some extra buffer at the end required for the writing
80         bytes memory result = new bytes(decodedLen + 32);
81 
82         assembly {
83             // padding with '='
84             let lastBytes := mload(add(data, mload(data)))
85             if eq(and(lastBytes, 0xFF), 0x3d) {
86                 decodedLen := sub(decodedLen, 1)
87                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
88                     decodedLen := sub(decodedLen, 1)
89                 }
90             }
91 
92             // set the actual output length
93             mstore(result, decodedLen)
94 
95             // prepare the lookup table
96             let tablePtr := add(table, 1)
97 
98             // input ptr
99             let dataPtr := data
100             let endPtr := add(dataPtr, mload(data))
101 
102             // result ptr, jump over length
103             let resultPtr := add(result, 32)
104 
105             // run over the input, 4 characters at a time
106             for {} lt(dataPtr, endPtr) {}
107             {
108                // read 4 characters
109                dataPtr := add(dataPtr, 4)
110                let input := mload(dataPtr)
111 
112                // write 3 bytes
113                let output := add(
114                    add(
115                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
116                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
117                    add(
118                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
119                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
120                     )
121                 )
122                 mstore(resultPtr, shl(232, output))
123                 resultPtr := add(resultPtr, 3)
124             }
125         }
126 
127         return result;
128     }
129 }
130 
131 // File: @openzeppelin/contracts/utils/Strings.sol
132 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
133 pragma solidity ^0.8.0;
134 
135 /**
136  * @dev String operations.
137  */
138 library Strings {
139     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
140 
141     /**
142      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
143      */
144     function toString(uint256 value) internal pure returns (string memory) {
145         // Inspired by OraclizeAPI's implementation - MIT licence
146         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
147 
148         if (value == 0) {
149             return "0";
150         }
151         uint256 temp = value;
152         uint256 digits;
153         while (temp != 0) {
154             digits++;
155             temp /= 10;
156         }
157         bytes memory buffer = new bytes(digits);
158         while (value != 0) {
159             digits -= 1;
160             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
161             value /= 10;
162         }
163         return string(buffer);
164     }
165 
166     /**
167      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
168      */
169     function toHexString(uint256 value) internal pure returns (string memory) {
170         if (value == 0) {
171             return "0x00";
172         }
173         uint256 temp = value;
174         uint256 length = 0;
175         while (temp != 0) {
176             length++;
177             temp >>= 8;
178         }
179         return toHexString(value, length);
180     }
181 
182     /**
183      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
184      */
185     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
186         bytes memory buffer = new bytes(2 * length + 2);
187         buffer[0] = "0";
188         buffer[1] = "x";
189         for (uint256 i = 2 * length + 1; i > 1; --i) {
190             buffer[i] = _HEX_SYMBOLS[value & 0xf];
191             value >>= 4;
192         }
193         require(value == 0, "Strings: hex length insufficient");
194         return string(buffer);
195     }
196 }
197 
198 // File: @openzeppelin/contracts/utils/Context.sol
199 
200 
201 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev Provides information about the current execution context, including the
207  * sender of the transaction and its data. While these are generally available
208  * via msg.sender and msg.data, they should not be accessed in such a direct
209  * manner, since when dealing with meta-transactions the account sending and
210  * paying for execution may not be the actual sender (as far as an application
211  * is concerned).
212  *
213  * This contract is only required for intermediate, library-like contracts.
214  */
215 abstract contract Context {
216     function _msgSender() internal view virtual returns (address) {
217         return msg.sender;
218     }
219 
220     function _msgData() internal view virtual returns (bytes calldata) {
221         return msg.data;
222     }
223 }
224 
225 // File: @openzeppelin/contracts/access/Ownable.sol
226 
227 
228 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
229 
230 pragma solidity ^0.8.0;
231 
232 
233 /**
234  * @dev Contract module which provides a basic access control mechanism, where
235  * there is an account (an owner) that can be granted exclusive access to
236  * specific functions.
237  *
238  * By default, the owner account will be the one that deploys the contract. This
239  * can later be changed with {transferOwnership}.
240  *
241  * This module is used through inheritance. It will make available the modifier
242  * `onlyOwner`, which can be applied to your functions to restrict their use to
243  * the owner.
244  */
245 abstract contract Ownable is Context {
246     address private _owner;
247 
248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
249 
250     /**
251      * @dev Initializes the contract setting the deployer as the initial owner.
252      */
253     constructor() {
254         _transferOwnership(_msgSender());
255     }
256 
257     /**
258      * @dev Returns the address of the current owner.
259      */
260     function owner() public view virtual returns (address) {
261         return _owner;
262     }
263 
264     /**
265      * @dev Throws if called by any account other than the owner.
266      */
267     modifier onlyOwner() {
268         require(owner() == _msgSender(), "Ownable: caller is not the owner");
269         _;
270     }
271 
272     /**
273      * @dev Leaves the contract without owner. It will not be possible to call
274      * `onlyOwner` functions anymore. Can only be called by the current owner.
275      *
276      * NOTE: Renouncing ownership will leave the contract without an owner,
277      * thereby removing any functionality that is only available to the owner.
278      */
279     function renounceOwnership() public virtual onlyOwner {
280         _transferOwnership(address(0));
281     }
282 
283     /**
284      * @dev Transfers ownership of the contract to a new account (`newOwner`).
285      * Can only be called by the current owner.
286      */
287     function transferOwnership(address newOwner) public virtual onlyOwner {
288         require(newOwner != address(0), "Ownable: new owner is the zero address");
289         _transferOwnership(newOwner);
290     }
291 
292     /**
293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
294      * Internal function without access restriction.
295      */
296     function _transferOwnership(address newOwner) internal virtual {
297         address oldOwner = _owner;
298         _owner = newOwner;
299         emit OwnershipTransferred(oldOwner, newOwner);
300     }
301 }
302 
303 // File: @openzeppelin/contracts/utils/Address.sol
304 
305 
306 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
307 
308 pragma solidity ^0.8.1;
309 
310 /**
311  * @dev Collection of functions related to the address type
312  */
313 library Address {
314     /**
315      * @dev Returns true if `account` is a contract.
316      *
317      * [IMPORTANT]
318      * ====
319      * It is unsafe to assume that an address for which this function returns
320      * false is an externally-owned account (EOA) and not a contract.
321      *
322      * Among others, `isContract` will return false for the following
323      * types of addresses:
324      *
325      *  - an externally-owned account
326      *  - a contract in construction
327      *  - an address where a contract will be created
328      *  - an address where a contract lived, but was destroyed
329      * ====
330      *
331      * [IMPORTANT]
332      * ====
333      * You shouldn't rely on `isContract` to protect against flash loan attacks!
334      *
335      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
336      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
337      * constructor.
338      * ====
339      */
340     function isContract(address account) internal view returns (bool) {
341         // This method relies on extcodesize/address.code.length, which returns 0
342         // for contracts in construction, since the code is only stored at the end
343         // of the constructor execution.
344 
345         return account.code.length > 0;
346     }
347 
348     /**
349      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
350      * `recipient`, forwarding all available gas and reverting on errors.
351      *
352      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
353      * of certain opcodes, possibly making contracts go over the 2300 gas limit
354      * imposed by `transfer`, making them unable to receive funds via
355      * `transfer`. {sendValue} removes this limitation.
356      *
357      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
358      *
359      * IMPORTANT: because control is transferred to `recipient`, care must be
360      * taken to not create reentrancy vulnerabilities. Consider using
361      * {ReentrancyGuard} or the
362      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
363      */
364     function sendValue(address payable recipient, uint256 amount) internal {
365         require(address(this).balance >= amount, "Address: insufficient balance");
366 
367         (bool success, ) = recipient.call{value: amount}("");
368         require(success, "Address: unable to send value, recipient may have reverted");
369     }
370 
371     /**
372      * @dev Performs a Solidity function call using a low level `call`. A
373      * plain `call` is an unsafe replacement for a function call: use this
374      * function instead.
375      *
376      * If `target` reverts with a revert reason, it is bubbled up by this
377      * function (like regular Solidity function calls).
378      *
379      * Returns the raw returned data. To convert to the expected return value,
380      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
381      *
382      * Requirements:
383      *
384      * - `target` must be a contract.
385      * - calling `target` with `data` must not revert.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
390         return functionCall(target, data, "Address: low-level call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
395      * `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value
422     ) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
428      * with `errorMessage` as a fallback revert reason when `target` reverts.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(
433         address target,
434         bytes memory data,
435         uint256 value,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(address(this).balance >= value, "Address: insufficient balance for call");
439         require(isContract(target), "Address: call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.call{value: value}(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
452         return functionStaticCall(target, data, "Address: low-level static call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal view returns (bytes memory) {
466         require(isContract(target), "Address: static call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.staticcall(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         require(isContract(target), "Address: delegate call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.delegatecall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
501      * revert reason using the provided one.
502      *
503      * _Available since v4.3._
504      */
505     function verifyCallResult(
506         bool success,
507         bytes memory returndata,
508         string memory errorMessage
509     ) internal pure returns (bytes memory) {
510         if (success) {
511             return returndata;
512         } else {
513             // Look for revert reason and bubble it up if present
514             if (returndata.length > 0) {
515                 // The easiest way to bubble the revert reason is using memory via assembly
516 
517                 assembly {
518                     let returndata_size := mload(returndata)
519                     revert(add(32, returndata), returndata_size)
520                 }
521             } else {
522                 revert(errorMessage);
523             }
524         }
525     }
526 }
527 
528 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @title ERC721 token receiver interface
537  * @dev Interface for any contract that wants to support safeTransfers
538  * from ERC721 asset contracts.
539  */
540 interface IERC721Receiver {
541     /**
542      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
543      * by `operator` from `from`, this function is called.
544      *
545      * It must return its Solidity selector to confirm the token transfer.
546      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
547      *
548      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
549      */
550     function onERC721Received(
551         address operator,
552         address from,
553         uint256 tokenId,
554         bytes calldata data
555     ) external returns (bytes4);
556 }
557 
558 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @dev Interface of the ERC165 standard, as defined in the
567  * https://eips.ethereum.org/EIPS/eip-165[EIP].
568  *
569  * Implementers can declare support of contract interfaces, which can then be
570  * queried by others ({ERC165Checker}).
571  *
572  * For an implementation, see {ERC165}.
573  */
574 interface IERC165 {
575     /**
576      * @dev Returns true if this contract implements the interface defined by
577      * `interfaceId`. See the corresponding
578      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
579      * to learn more about how these ids are created.
580      *
581      * This function call must use less than 30 000 gas.
582      */
583     function supportsInterface(bytes4 interfaceId) external view returns (bool);
584 }
585 
586 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @dev Implementation of the {IERC165} interface.
596  *
597  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
598  * for the additional interface id that will be supported. For example:
599  *
600  * ```solidity
601  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
602  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
603  * }
604  * ```
605  *
606  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
607  */
608 abstract contract ERC165 is IERC165 {
609     /**
610      * @dev See {IERC165-supportsInterface}.
611      */
612     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
613         return interfaceId == type(IERC165).interfaceId;
614     }
615 }
616 
617 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
618 
619 
620 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
621 
622 pragma solidity ^0.8.0;
623 
624 
625 /**
626  * @dev Required interface of an ERC721 compliant contract.
627  */
628 interface IERC721 is IERC165 {
629     /**
630      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
631      */
632     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
633 
634     /**
635      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
636      */
637     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
638 
639     /**
640      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
641      */
642     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
643 
644     /**
645      * @dev Returns the number of tokens in ``owner``'s account.
646      */
647     function balanceOf(address owner) external view returns (uint256 balance);
648 
649     /**
650      * @dev Returns the owner of the `tokenId` token.
651      *
652      * Requirements:
653      *
654      * - `tokenId` must exist.
655      */
656     function ownerOf(uint256 tokenId) external view returns (address owner);
657 
658     /**
659      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
660      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
661      *
662      * Requirements:
663      *
664      * - `from` cannot be the zero address.
665      * - `to` cannot be the zero address.
666      * - `tokenId` token must exist and be owned by `from`.
667      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
668      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
669      *
670      * Emits a {Transfer} event.
671      */
672     function safeTransferFrom(
673         address from,
674         address to,
675         uint256 tokenId
676     ) external;
677 
678     /**
679      * @dev Transfers `tokenId` token from `from` to `to`.
680      *
681      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
682      *
683      * Requirements:
684      *
685      * - `from` cannot be the zero address.
686      * - `to` cannot be the zero address.
687      * - `tokenId` token must be owned by `from`.
688      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
689      *
690      * Emits a {Transfer} event.
691      */
692     function transferFrom(
693         address from,
694         address to,
695         uint256 tokenId
696     ) external;
697 
698     /**
699      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
700      * The approval is cleared when the token is transferred.
701      *
702      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
703      *
704      * Requirements:
705      *
706      * - The caller must own the token or be an approved operator.
707      * - `tokenId` must exist.
708      *
709      * Emits an {Approval} event.
710      */
711     function approve(address to, uint256 tokenId) external;
712 
713     /**
714      * @dev Returns the account approved for `tokenId` token.
715      *
716      * Requirements:
717      *
718      * - `tokenId` must exist.
719      */
720     function getApproved(uint256 tokenId) external view returns (address operator);
721 
722     /**
723      * @dev Approve or remove `operator` as an operator for the caller.
724      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
725      *
726      * Requirements:
727      *
728      * - The `operator` cannot be the caller.
729      *
730      * Emits an {ApprovalForAll} event.
731      */
732     function setApprovalForAll(address operator, bool _approved) external;
733 
734     /**
735      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
736      *
737      * See {setApprovalForAll}
738      */
739     function isApprovedForAll(address owner, address operator) external view returns (bool);
740 
741     /**
742      * @dev Safely transfers `tokenId` token from `from` to `to`.
743      *
744      * Requirements:
745      *
746      * - `from` cannot be the zero address.
747      * - `to` cannot be the zero address.
748      * - `tokenId` token must exist and be owned by `from`.
749      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
750      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
751      *
752      * Emits a {Transfer} event.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes calldata data
759     ) external;
760 }
761 
762 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
763 
764 
765 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
766 
767 pragma solidity ^0.8.0;
768 
769 
770 /**
771  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
772  * @dev See https://eips.ethereum.org/EIPS/eip-721
773  */
774 interface IERC721Enumerable is IERC721 {
775     /**
776      * @dev Returns the total amount of tokens stored by the contract.
777      */
778     function totalSupply() external view returns (uint256);
779 
780     /**
781      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
782      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
783      */
784     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
785 
786     /**
787      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
788      * Use along with {totalSupply} to enumerate all tokens.
789      */
790     function tokenByIndex(uint256 index) external view returns (uint256);
791 }
792 
793 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
794 
795 
796 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
797 
798 pragma solidity ^0.8.0;
799 
800 
801 /**
802  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
803  * @dev See https://eips.ethereum.org/EIPS/eip-721
804  */
805 interface IERC721Metadata is IERC721 {
806     /**
807      * @dev Returns the token collection name.
808      */
809     function name() external view returns (string memory);
810 
811     /**
812      * @dev Returns the token collection symbol.
813      */
814     function symbol() external view returns (string memory);
815 
816     /**
817      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
818      */
819     function tokenURI(uint256 tokenId) external view returns (string memory);
820 }
821 
822 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
823 
824 
825 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
826 
827 pragma solidity ^0.8.0;
828 
829 
830 
831 
832 
833 
834 
835 
836 /**
837  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
838  * the Metadata extension, but not including the Enumerable extension, which is available separately as
839  * {ERC721Enumerable}.
840  */
841 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
842     using Address for address;
843     using Strings for uint256;
844 
845     // Token name
846     string private _name;
847 
848     // Token symbol
849     string private _symbol;
850 
851     // Mapping from token ID to owner address
852     mapping(uint256 => address) private _owners;
853 
854     // Mapping owner address to token count
855     mapping(address => uint256) private _balances;
856 
857     // Mapping from token ID to approved address
858     mapping(uint256 => address) private _tokenApprovals;
859 
860     // Mapping from owner to operator approvals
861     mapping(address => mapping(address => bool)) private _operatorApprovals;
862 
863     /**
864      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
865      */
866     constructor(string memory name_, string memory symbol_) {
867         _name = name_;
868         _symbol = symbol_;
869     }
870 
871     /**
872      * @dev See {IERC165-supportsInterface}.
873      */
874     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
875         return
876             interfaceId == type(IERC721).interfaceId ||
877             interfaceId == type(IERC721Metadata).interfaceId ||
878             super.supportsInterface(interfaceId);
879     }
880 
881     /**
882      * @dev See {IERC721-balanceOf}.
883      */
884     function balanceOf(address owner) public view virtual override returns (uint256) {
885         require(owner != address(0), "ERC721: balance query for the zero address");
886         return _balances[owner];
887     }
888 
889     /**
890      * @dev See {IERC721-ownerOf}.
891      */
892     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
893         address owner = _owners[tokenId];
894         require(owner != address(0), "ERC721: owner query for nonexistent token");
895         return owner;
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
916         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
917 
918         return _baseURI();
919     }
920 
921     /**
922      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
923      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
924      * by default, can be overriden in child contracts.
925      */
926     function _baseURI() internal view virtual returns (string memory) {
927         return "";
928     }
929 
930     /**
931      * @dev See {IERC721-approve}.
932      */
933     function approve(address to, uint256 tokenId) public virtual override {
934         address owner = ERC721.ownerOf(tokenId);
935         require(to != owner, "ERC721: approval to current owner");
936 
937         require(
938             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
939             "ERC721: approve caller is not owner nor approved for all"
940         );
941 
942         _approve(to, tokenId);
943     }
944 
945     /**
946      * @dev See {IERC721-getApproved}.
947      */
948     function getApproved(uint256 tokenId) public view virtual override returns (address) {
949         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
950 
951         return _tokenApprovals[tokenId];
952     }
953 
954     /**
955      * @dev See {IERC721-setApprovalForAll}.
956      */
957     function setApprovalForAll(address operator, bool approved) public virtual override {
958         _setApprovalForAll(_msgSender(), operator, approved);
959     }
960 
961     /**
962      * @dev See {IERC721-isApprovedForAll}.
963      */
964     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
965         return _operatorApprovals[owner][operator];
966     }
967 
968     /**
969      * @dev See {IERC721-transferFrom}.
970      */
971     function transferFrom(
972         address from,
973         address to,
974         uint256 tokenId
975     ) public virtual override {
976         //solhint-disable-next-line max-line-length
977         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
978 
979         _transfer(from, to, tokenId);
980     }
981 
982     /**
983      * @dev See {IERC721-safeTransferFrom}.
984      */
985     function safeTransferFrom(
986         address from,
987         address to,
988         uint256 tokenId
989     ) public virtual override {
990         safeTransferFrom(from, to, tokenId, "");
991     }
992 
993     /**
994      * @dev See {IERC721-safeTransferFrom}.
995      */
996     function safeTransferFrom(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) public virtual override {
1002         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1003         _safeTransfer(from, to, tokenId, _data);
1004     }
1005 
1006     /**
1007      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1008      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1009      *
1010      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1011      *
1012      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1013      * implement alternative mechanisms to perform token transfer, such as signature-based.
1014      *
1015      * Requirements:
1016      *
1017      * - `from` cannot be the zero address.
1018      * - `to` cannot be the zero address.
1019      * - `tokenId` token must exist and be owned by `from`.
1020      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _safeTransfer(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) internal virtual {
1030         _transfer(from, to, tokenId);
1031         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1032     }
1033 
1034     /**
1035      * @dev Returns whether `tokenId` exists.
1036      *
1037      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1038      *
1039      * Tokens start existing when they are minted (`_mint`),
1040      * and stop existing when they are burned (`_burn`).
1041      */
1042     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1043         return _owners[tokenId] != address(0);
1044     }
1045 
1046     /**
1047      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1048      *
1049      * Requirements:
1050      *
1051      * - `tokenId` must exist.
1052      */
1053     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1054         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1055         address owner = ERC721.ownerOf(tokenId);
1056         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1057     }
1058 
1059     /**
1060      * @dev Safely mints `tokenId` and transfers it to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must not exist.
1065      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _safeMint(address to, uint256 tokenId) internal virtual {
1070         _safeMint(to, tokenId, "");
1071     }
1072 
1073     /**
1074      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1075      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1076      */
1077     function _safeMint(
1078         address to,
1079         uint256 tokenId,
1080         bytes memory _data
1081     ) internal virtual {
1082         _mint(to, tokenId);
1083         require(
1084             _checkOnERC721Received(address(0), to, tokenId, _data),
1085             "ERC721: transfer to non ERC721Receiver implementer"
1086         );
1087     }
1088 
1089     /**
1090      * @dev Mints `tokenId` and transfers it to `to`.
1091      *
1092      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1093      *
1094      * Requirements:
1095      *
1096      * - `tokenId` must not exist.
1097      * - `to` cannot be the zero address.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101     function _mint(address to, uint256 tokenId) internal virtual {
1102         require(to != address(0), "ERC721: mint to the zero address");
1103         require(!_exists(tokenId), "ERC721: token already minted");
1104 
1105         _beforeTokenTransfer(address(0), to, tokenId);
1106 
1107         _balances[to] += 1;
1108         _owners[tokenId] = to;
1109 
1110         emit Transfer(address(0), to, tokenId);
1111 
1112         _afterTokenTransfer(address(0), to, tokenId);
1113     }
1114 
1115     /**
1116      * @dev Destroys `tokenId`.
1117      * The approval is cleared when the token is burned.
1118      *
1119      * Requirements:
1120      *
1121      * - `tokenId` must exist.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function _burn(uint256 tokenId) internal virtual {
1126         address owner = ERC721.ownerOf(tokenId);
1127 
1128         _beforeTokenTransfer(owner, address(0), tokenId);
1129 
1130         // Clear approvals
1131         _approve(address(0), tokenId);
1132 
1133         _balances[owner] -= 1;
1134         delete _owners[tokenId];
1135 
1136         emit Transfer(owner, address(0), tokenId);
1137 
1138         _afterTokenTransfer(owner, address(0), tokenId);
1139     }
1140 
1141     /**
1142      * @dev Transfers `tokenId` from `from` to `to`.
1143      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1144      *
1145      * Requirements:
1146      *
1147      * - `to` cannot be the zero address.
1148      * - `tokenId` token must be owned by `from`.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _transfer(
1153         address from,
1154         address to,
1155         uint256 tokenId
1156     ) internal virtual {
1157         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1158         require(to != address(0), "ERC721: transfer to the zero address");
1159 
1160         _beforeTokenTransfer(from, to, tokenId);
1161 
1162         // Clear approvals from the previous owner
1163         _approve(address(0), tokenId);
1164 
1165         _balances[from] -= 1;
1166         _balances[to] += 1;
1167         _owners[tokenId] = to;
1168 
1169         emit Transfer(from, to, tokenId);
1170 
1171         _afterTokenTransfer(from, to, tokenId);
1172     }
1173 
1174     /**
1175      * @dev Approve `to` to operate on `tokenId`
1176      *
1177      * Emits a {Approval} event.
1178      */
1179     function _approve(address to, uint256 tokenId) internal virtual {
1180         _tokenApprovals[tokenId] = to;
1181         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1182     }
1183 
1184     /**
1185      * @dev Approve `operator` to operate on all of `owner` tokens
1186      *
1187      * Emits a {ApprovalForAll} event.
1188      */
1189     function _setApprovalForAll(
1190         address owner,
1191         address operator,
1192         bool approved
1193     ) internal virtual {
1194         require(owner != operator, "ERC721: approve to caller");
1195         _operatorApprovals[owner][operator] = approved;
1196         emit ApprovalForAll(owner, operator, approved);
1197     }
1198 
1199     /**
1200      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1201      * The call is not executed if the target address is not a contract.
1202      *
1203      * @param from address representing the previous owner of the given token ID
1204      * @param to target address that will receive the tokens
1205      * @param tokenId uint256 ID of the token to be transferred
1206      * @param _data bytes optional data to send along with the call
1207      * @return bool whether the call correctly returned the expected magic value
1208      */
1209     function _checkOnERC721Received(
1210         address from,
1211         address to,
1212         uint256 tokenId,
1213         bytes memory _data
1214     ) private returns (bool) {
1215         if (to.isContract()) {
1216             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1217                 return retval == IERC721Receiver.onERC721Received.selector;
1218             } catch (bytes memory reason) {
1219                 if (reason.length == 0) {
1220                     revert("ERC721: transfer to non ERC721Receiver implementer");
1221                 } else {
1222                     assembly {
1223                         revert(add(32, reason), mload(reason))
1224                     }
1225                 }
1226             }
1227         } else {
1228             return true;
1229         }
1230     }
1231 
1232     /**
1233      * @dev Hook that is called before any token transfer. This includes minting
1234      * and burning.
1235      *
1236      * Calling conditions:
1237      *
1238      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1239      * transferred to `to`.
1240      * - When `from` is zero, `tokenId` will be minted for `to`.
1241      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1242      * - `from` and `to` are never both zero.
1243      *
1244      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1245      */
1246     function _beforeTokenTransfer(
1247         address from,
1248         address to,
1249         uint256 tokenId
1250     ) internal virtual {}
1251 
1252     /**
1253      * @dev Hook that is called after any transfer of tokens. This includes
1254      * minting and burning.
1255      *
1256      * Calling conditions:
1257      *
1258      * - when `from` and `to` are both non-zero.
1259      * - `from` and `to` are never both zero.
1260      *
1261      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1262      */
1263     function _afterTokenTransfer(
1264         address from,
1265         address to,
1266         uint256 tokenId
1267     ) internal virtual {}
1268 }
1269 
1270 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1271 
1272 
1273 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1274 
1275 pragma solidity ^0.8.0;
1276 
1277 
1278 
1279 /**
1280  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1281  * enumerability of all the token ids in the contract as well as all token ids owned by each
1282  * account.
1283  */
1284 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1285     // Mapping from owner to list of owned token IDs
1286     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1287 
1288     // Mapping from token ID to index of the owner tokens list
1289     mapping(uint256 => uint256) private _ownedTokensIndex;
1290 
1291     // Array with all token ids, used for enumeration
1292     uint256[] private _allTokens;
1293 
1294     // Mapping from token id to position in the allTokens array
1295     mapping(uint256 => uint256) private _allTokensIndex;
1296 
1297     /**
1298      * @dev See {IERC165-supportsInterface}.
1299      */
1300     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1301         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1302     }
1303 
1304     /**
1305      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1306      */
1307     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1308         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1309         return _ownedTokens[owner][index];
1310     }
1311 
1312     /**
1313      * @dev See {IERC721Enumerable-totalSupply}.
1314      */
1315     function totalSupply() public view virtual override returns (uint256) {
1316         return _allTokens.length;
1317     }
1318 
1319     /**
1320      * @dev See {IERC721Enumerable-tokenByIndex}.
1321      */
1322     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1323         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1324         return _allTokens[index];
1325     }
1326 
1327     /**
1328      * @dev Hook that is called before any token transfer. This includes minting
1329      * and burning.
1330      *
1331      * Calling conditions:
1332      *
1333      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1334      * transferred to `to`.
1335      * - When `from` is zero, `tokenId` will be minted for `to`.
1336      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1337      * - `from` cannot be the zero address.
1338      * - `to` cannot be the zero address.
1339      *
1340      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1341      */
1342     function _beforeTokenTransfer(
1343         address from,
1344         address to,
1345         uint256 tokenId
1346     ) internal virtual override {
1347         super._beforeTokenTransfer(from, to, tokenId);
1348 
1349         if (from == address(0)) {
1350             _addTokenToAllTokensEnumeration(tokenId);
1351         } else if (from != to) {
1352             _removeTokenFromOwnerEnumeration(from, tokenId);
1353         }
1354         if (to == address(0)) {
1355             _removeTokenFromAllTokensEnumeration(tokenId);
1356         } else if (to != from) {
1357             _addTokenToOwnerEnumeration(to, tokenId);
1358         }
1359     }
1360 
1361     /**
1362      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1363      * @param to address representing the new owner of the given token ID
1364      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1365      */
1366     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1367         uint256 length = ERC721.balanceOf(to);
1368         _ownedTokens[to][length] = tokenId;
1369         _ownedTokensIndex[tokenId] = length;
1370     }
1371 
1372     /**
1373      * @dev Private function to add a token to this extension's token tracking data structures.
1374      * @param tokenId uint256 ID of the token to be added to the tokens list
1375      */
1376     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1377         _allTokensIndex[tokenId] = _allTokens.length;
1378         _allTokens.push(tokenId);
1379     }
1380 
1381     /**
1382      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1383      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1384      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1385      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1386      * @param from address representing the previous owner of the given token ID
1387      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1388      */
1389     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1390         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1391         // then delete the last slot (swap and pop).
1392 
1393         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1394         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1395 
1396         // When the token to delete is the last token, the swap operation is unnecessary
1397         if (tokenIndex != lastTokenIndex) {
1398             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1399 
1400             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1401             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1402         }
1403 
1404         // This also deletes the contents at the last position of the array
1405         delete _ownedTokensIndex[tokenId];
1406         delete _ownedTokens[from][lastTokenIndex];
1407     }
1408 
1409     /**
1410      * @dev Private function to remove a token from this extension's token tracking data structures.
1411      * This has O(1) time complexity, but alters the order of the _allTokens array.
1412      * @param tokenId uint256 ID of the token to be removed from the tokens list
1413      */
1414     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1415         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1416         // then delete the last slot (swap and pop).
1417 
1418         uint256 lastTokenIndex = _allTokens.length - 1;
1419         uint256 tokenIndex = _allTokensIndex[tokenId];
1420 
1421         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1422         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1423         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1424         uint256 lastTokenId = _allTokens[lastTokenIndex];
1425 
1426         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1427         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1428 
1429         // This also deletes the contents at the last position of the array
1430         delete _allTokensIndex[tokenId];
1431         _allTokens.pop();
1432     }
1433 }
1434 
1435 pragma solidity ^0.8.0;
1436 
1437 /**
1438  * @dev Contract module that helps prevent reentrant calls to a function.
1439  *
1440  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1441  * available, which can be applied to functions to make sure there are no nested
1442  * (reentrant) calls to them.
1443  *
1444  * Note that because there is a single `nonReentrant` guard, functions marked as
1445  * `nonReentrant` may not call one another. This can be worked around by making
1446  * those functions `private`, and then adding `external` `nonReentrant` entry
1447  * points to them.
1448  *
1449  * TIP: If you would like to learn more about reentrancy and alternative ways
1450  * to protect against it, check out our blog post
1451  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1452  */
1453 abstract contract ReentrancyGuard {
1454     // Booleans are more expensive than uint256 or any type that takes up a full
1455     // word because each write operation emits an extra SLOAD to first read the
1456     // slot's contents, replace the bits taken up by the boolean, and then write
1457     // back. This is the compiler's defense against contract upgrades and
1458     // pointer aliasing, and it cannot be disabled.
1459 
1460     // The values being non-zero value makes deployment a bit more expensive,
1461     // but in exchange the refund on every call to nonReentrant will be lower in
1462     // amount. Since refunds are capped to a percentage of the total
1463     // transaction's gas, it is best to keep them low in cases like this one, to
1464     // increase the likelihood of the full refund coming into effect.
1465     uint256 private constant _NOT_ENTERED = 1;
1466     uint256 private constant _ENTERED = 2;
1467 
1468     uint256 private _status;
1469 
1470     constructor() {
1471         _status = _NOT_ENTERED;
1472     }
1473 
1474     /**
1475      * @dev Prevents a contract from calling itself, directly or indirectly.
1476      * Calling a `nonReentrant` function from another `nonReentrant`
1477      * function is not supported. It is possible to prevent this from happening
1478      * by making the `nonReentrant` function external, and make it call a
1479      * `private` function that does the actual work.
1480      */
1481     modifier nonReentrant() {
1482         // On the first call to nonReentrant, _notEntered will be true
1483         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1484 
1485         // Any calls to nonReentrant after this point will fail
1486         _status = _ENTERED;
1487 
1488         _;
1489 
1490         // By storing the original value once again, a refund is triggered (see
1491         // https://eips.ethereum.org/EIPS/eip-2200)
1492         _status = _NOT_ENTERED;
1493     }
1494 }
1495 
1496 contract RelicsPass {
1497     function ownerOf(uint256 relicsPassId) public view virtual returns(address) {}
1498 }
1499 
1500 struct TokenInfo {
1501     uint256 punkId;
1502     string edition;
1503     uint256 punkNumber;
1504 }
1505 
1506 
1507 // File: contracts/RelicPunks.sol
1508 pragma solidity >=0.7.0 <0.9.0;
1509 contract RelicPunks is ERC721Enumerable, Ownable, ReentrancyGuard {
1510 	using Strings for uint256;
1511 
1512 	string baseURI;
1513 	string baseExtension = ".json";
1514 	bool public paused = true;
1515     address public immutable relicsPassContract;
1516     mapping(uint256 => uint256) private claimedPasses;
1517     mapping(uint256 => uint256) punksEditionCounter;
1518     mapping(uint256 => TokenInfo) punkIdToInfo;
1519     string[] punkNames;
1520     string[] punkFileNames;
1521 
1522 	constructor(
1523 		string memory _name,
1524 		string memory _symbol,
1525         string memory _baseUri,
1526         address _relicsPassContract
1527 	) ERC721(_name, _symbol) {
1528         baseURI = _baseUri;
1529         relicsPassContract = _relicsPassContract;
1530         punkNames = ["Pixel Perfect", "Amped Ape", "Teachers Pet", 
1531                      "Broken Record", "Sketched Out", "Tuned Out", 
1532                      "Bundle Of Joy", "Money Talks", "Strange Computer", 
1533                      "Golden Hour", "Ice Cold", "Icing On Top", "Fair and Square", 
1534                      "Class Clown", "Mark 1", "Security Blanket", "Bright Side", 
1535                      "Hot Wallet", "Face The Music", "Cheat Code", "Bite Me", 
1536                      "Dialed In", "Instant Gratification", "Double Toasted", 
1537                      "Keep On Truckin'", "Space Junk", "Speak Up", "Bugged Out", 
1538                      "Loud Mouth", "Surprise", "Game Boy Punk", "Relic Football Punk", "Kevin Punk", "Mag Punk", 
1539                      "Ticked Off", "Patek Punk"];
1540         punkFileNames = ["2140", "2140garyv", "2338", "juke", "6578", "9671", "atari", 
1541                          "atm", "c3po", "casio", "cola", "ezbaked", "gamecube", "hello", 
1542                          "ironman", "ledger", "lite", "mac", "mpc", "n64", "pac", "phone", 
1543                          "polaroid", "pop", "prime", "r2d2", "speakspell", "vw", "walkman", 
1544                          "surprise", "4609", "football", "gameboy", "mag", "ticked", "tiffany"];
1545 	}
1546 
1547     // The given string array of punk names must be in the exact order they are listed on the site.
1548     function setPunkNames(string[] memory _punkNames) public onlyOwner {
1549         punkNames = _punkNames;
1550     }
1551 
1552     function setSinglePunkName(uint256 index, string memory newName) public onlyOwner {
1553         punkNames[index] = newName;
1554     }
1555 
1556     function setPunkFileNames(string[] memory _punkFileNames) public onlyOwner {
1557         punkFileNames = _punkFileNames;
1558     }
1559 
1560     function setSinglePunkFileName(uint256 index, string memory newFileName) public onlyOwner {
1561         punkFileNames[index] = newFileName;
1562     }
1563 
1564 
1565 	// internal
1566 	function _baseURI() internal view virtual override returns (string memory) {
1567 		return baseURI;
1568 	}
1569 
1570     function claimed(uint256 relicPassId) public view returns(uint256) {
1571         return claimedPasses[relicPassId];
1572     }
1573 
1574     function claimable(uint256 relicPassId) public view returns(bool) {
1575         return claimedPasses[relicPassId] == 0;
1576     }
1577 
1578     function arePassIdsClaimable(uint256[] memory passIds) public view returns (bool[] memory) {
1579         bool[] memory claimStates = new bool[](passIds.length);
1580         for (uint i = 0; i < passIds.length; i++) {
1581             claimStates[i] = claimable(passIds[i]);
1582         }
1583 
1584         return claimStates;
1585     }
1586 
1587     function getPunksEditionCounter() public view returns(uint256[] memory) {
1588         uint256[] memory counters = new uint256[](punkNames.length);
1589 
1590         for (uint i = 0; i < punkNames.length; i++) {
1591             counters[i] = punksEditionCounter[i];
1592         }
1593 
1594         return counters;
1595     }
1596 
1597     // allows owner to mint Relic Punks of their choice to distribute.
1598     function ownerMint(uint256 punk) public nonReentrant onlyOwner {
1599         require(punk >= 0 && punk < punkNames.length, "invalid punk ID");
1600         TokenInfo memory info = TokenInfo({
1601             punkId: punk,
1602             edition: Strings.toString(punksEditionCounter[punk]),
1603             punkNumber: punk
1604         });
1605 
1606         uint256 supply = totalSupply(); 
1607         _safeMint(msg.sender, supply + 1);
1608         punkIdToInfo[supply + 1] = info;
1609     }
1610 
1611 	// backup mint function
1612     // edition needs to be kept track of in the contract, not passed in from the frontend
1613     // use msg.sender to verify Relic Pass
1614     // only parameter needed is uint256 punk, which references an image
1615 	function mint(uint256 passId, uint256 punk) 
1616 		public
1617 		payable
1618         nonReentrant
1619 	{
1620         if (msg.sender != owner()) {
1621             require(paused == false, "contract is currently paused");
1622             require(punk >= 0 && punk < 30, "only owner can mint this punk");
1623             RelicsPass relicPass = RelicsPass(relicsPassContract);
1624             require(relicPass.ownerOf(passId) == _msgSender(), "you aren't owner");
1625             require(claimable(passId) == true, "this Relic Pass has already claimed a Relic Punk");
1626             claimedPasses[passId]++;
1627         } else {
1628             require(punk >= 0 && punk < punkNames.length, "invalid punk ID");
1629         }
1630 
1631         punksEditionCounter[punk]++;
1632         TokenInfo memory info = TokenInfo({
1633             punkId: punk,
1634             edition: Strings.toString(punksEditionCounter[punk]),
1635             punkNumber: punk
1636         });
1637 
1638         uint256 supply = totalSupply();
1639 		_safeMint(msg.sender, supply + 1);
1640         punkIdToInfo[supply + 1] = info;
1641 	}
1642 
1643 	function walletOfOwner(address _owner)
1644 		public
1645 		view
1646 		returns (uint256[] memory)
1647 	{
1648 		uint256 ownerTokenCount = balanceOf(_owner);
1649 		uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1650 		for (uint256 i; i < ownerTokenCount; i++) {
1651 			tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1652 		}
1653 		return tokenIds;
1654 	}
1655 
1656 	function tokenURI(uint256 tokenId) public view override returns (string memory) {
1657 		require(_exists(tokenId),"TOKENURI:DOES_NOT_EXIST");
1658 		return _getFinalPackedMetadata(tokenId);
1659 	}
1660 
1661     function _getFinalPackedMetadata(uint256 tokenId) private view returns (string memory) {
1662 		return string(
1663 			abi.encodePacked(
1664 				"data:application/json;base64,",
1665 				Base64.encode(bytes(_getMetadataJSONString(tokenId)))
1666 			)
1667 		);
1668 	}
1669 
1670     function append(string memory a, string memory b) internal pure returns (string memory) {
1671         return string(abi.encodePacked(a, b));
1672     }
1673 
1674     function _getMetadataJSONString(uint256 tokenId) private view returns (string memory) {
1675         TokenInfo memory punkToken = punkIdToInfo[tokenId];
1676 		return string(
1677 			abi.encodePacked(
1678 				"{",
1679 				_jsonKV("name", _jsonStringWrap(string(
1680 					abi.encodePacked(
1681 						punkNames[punkToken.punkId]
1682 					)
1683 				)), true),
1684 				_jsonKV("image", _jsonStringWrap(generateURI(punkToken.punkId)), true),
1685                 _jsonKV("description", generateDescription(), true),
1686                 _jsonKV("edition", _jsonStringWrap(punkToken.edition), true),
1687                 _jsonKV("attributes", generateAttributes(punkToken.punkId), false),
1688 				"}"
1689 			)
1690 		);
1691 	}
1692 
1693     function generateDescription() private pure returns (string memory) {
1694         string memory description = "The Relic Punks are a 36 piece tribute to important cultural technology of the past."
1695                                     " The collection uses nostalgia to bring back the emotional relationship and connections"
1696                                     " we had growing up with consumer devices.";
1697         return _jsonStringWrap(description);
1698     }
1699 
1700     function generateAttributes(uint256 punkIndex) private view returns (string memory) {
1701         string memory attributes = append(" [{", _jsonKV("trait_type", _jsonStringWrap("Relic Punk"), true));
1702         attributes = append(attributes, _jsonKV("value", _jsonStringWrap(punkNames[punkIndex]), false));
1703         return append(attributes, "}]");
1704     }
1705 
1706     function generateURI(uint256 punkId) private view returns (string memory) {
1707         string memory uri = append(baseURI, punkFileNames[punkId]);
1708         return append(uri, ".jpg");
1709     }
1710 
1711     function _jsonStringWrap(string memory value) private pure returns (string memory) {
1712 		return string(
1713 			abi.encodePacked(
1714 				"\"", value, "\""
1715 			)
1716 		);
1717 	}
1718 
1719 	function _jsonKV(
1720 		string memory key,
1721 		string memory value,
1722 		bool hasComma
1723 	) private pure returns (string memory) {
1724 		return string(
1725 			abi.encodePacked(
1726 				"\"", key, "\": ", value, hasComma ? "," : ""
1727 			)
1728 		);
1729 	}
1730 
1731 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
1732 		baseURI = _newBaseURI;
1733 	}
1734 
1735 	function setBaseExtension(string memory _newBaseExtension)
1736 		public
1737 		onlyOwner
1738 	{
1739 		baseExtension = _newBaseExtension;
1740 	}
1741 
1742 	function pause(bool _state) public onlyOwner {
1743 		paused = _state;
1744 	}
1745 
1746     // Withdraws the Ethers in the smart contract to the wallet of the contract's owner.
1747 	function withdraw() public onlyOwner nonReentrant {
1748         uint256 balance = address(this).balance;
1749         payable(owner()).transfer(balance);
1750 	}
1751 }