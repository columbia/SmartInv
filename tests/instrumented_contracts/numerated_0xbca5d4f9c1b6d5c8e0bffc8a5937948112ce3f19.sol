1 // File: base64-sol/base64.sol
2 
3 
4 
5 pragma solidity >=0.6.0;
6 
7 /// @title Base64
8 /// @author Brecht Devos - <brecht@loopring.org>
9 /// @notice Provides functions for encoding/decoding base64
10 library Base64 {
11     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
12     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
13                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
14                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
15                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
16 
17     function encode(bytes memory data) internal pure returns (string memory) {
18         if (data.length == 0) return '';
19 
20         // load the table into memory
21         string memory table = TABLE_ENCODE;
22 
23         // multiply by 4/3 rounded up
24         uint256 encodedLen = 4 * ((data.length + 2) / 3);
25 
26         // add some extra buffer at the end required for the writing
27         string memory result = new string(encodedLen + 32);
28 
29         assembly {
30             // set the actual output length
31             mstore(result, encodedLen)
32 
33             // prepare the lookup table
34             let tablePtr := add(table, 1)
35 
36             // input ptr
37             let dataPtr := data
38             let endPtr := add(dataPtr, mload(data))
39 
40             // result ptr, jump over length
41             let resultPtr := add(result, 32)
42 
43             // run over the input, 3 bytes at a time
44             for {} lt(dataPtr, endPtr) {}
45             {
46                 // read 3 bytes
47                 dataPtr := add(dataPtr, 3)
48                 let input := mload(dataPtr)
49 
50                 // write 4 characters
51                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
52                 resultPtr := add(resultPtr, 1)
53                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
54                 resultPtr := add(resultPtr, 1)
55                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
56                 resultPtr := add(resultPtr, 1)
57                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
58                 resultPtr := add(resultPtr, 1)
59             }
60 
61             // padding with '='
62             switch mod(mload(data), 3)
63             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
64             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
65         }
66 
67         return result;
68     }
69 
70     function decode(string memory _data) internal pure returns (bytes memory) {
71         bytes memory data = bytes(_data);
72 
73         if (data.length == 0) return new bytes(0);
74         require(data.length % 4 == 0, "invalid base64 decoder input");
75 
76         // load the table into memory
77         bytes memory table = TABLE_DECODE;
78 
79         // every 4 characters represent 3 bytes
80         uint256 decodedLen = (data.length / 4) * 3;
81 
82         // add some extra buffer at the end required for the writing
83         bytes memory result = new bytes(decodedLen + 32);
84 
85         assembly {
86             // padding with '='
87             let lastBytes := mload(add(data, mload(data)))
88             if eq(and(lastBytes, 0xFF), 0x3d) {
89                 decodedLen := sub(decodedLen, 1)
90                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
91                     decodedLen := sub(decodedLen, 1)
92                 }
93             }
94 
95             // set the actual output length
96             mstore(result, decodedLen)
97 
98             // prepare the lookup table
99             let tablePtr := add(table, 1)
100 
101             // input ptr
102             let dataPtr := data
103             let endPtr := add(dataPtr, mload(data))
104 
105             // result ptr, jump over length
106             let resultPtr := add(result, 32)
107 
108             // run over the input, 4 characters at a time
109             for {} lt(dataPtr, endPtr) {}
110             {
111                // read 4 characters
112                dataPtr := add(dataPtr, 4)
113                let input := mload(dataPtr)
114 
115                // write 3 bytes
116                let output := add(
117                    add(
118                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
119                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
120                    add(
121                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
122                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
123                     )
124                 )
125                 mstore(resultPtr, shl(232, output))
126                 resultPtr := add(resultPtr, 3)
127             }
128         }
129 
130         return result;
131     }
132 }
133 
134 // File: @openzeppelin/contracts/utils/Counters.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 /**
142  * @title Counters
143  * @author Matt Condon (@shrugs)
144  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
145  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
146  *
147  * Include with `using Counters for Counters.Counter;`
148  */
149 library Counters {
150     struct Counter {
151         // This variable should never be directly accessed by users of the library: interactions must be restricted to
152         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
153         // this feature: see https://github.com/ethereum/solidity/issues/4637
154         uint256 _value; // default: 0
155     }
156 
157     function current(Counter storage counter) internal view returns (uint256) {
158         return counter._value;
159     }
160 
161     function increment(Counter storage counter) internal {
162         unchecked {
163             counter._value += 1;
164         }
165     }
166 
167     function decrement(Counter storage counter) internal {
168         uint256 value = counter._value;
169         require(value > 0, "Counter: decrement overflow");
170         unchecked {
171             counter._value = value - 1;
172         }
173     }
174 
175     function reset(Counter storage counter) internal {
176         counter._value = 0;
177     }
178 }
179 
180 // File: @openzeppelin/contracts/utils/Strings.sol
181 
182 
183 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 /**
188  * @dev String operations.
189  */
190 library Strings {
191     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
192 
193     /**
194      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
195      */
196     function toString(uint256 value) internal pure returns (string memory) {
197         // Inspired by OraclizeAPI's implementation - MIT licence
198         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
199 
200         if (value == 0) {
201             return "0";
202         }
203         uint256 temp = value;
204         uint256 digits;
205         while (temp != 0) {
206             digits++;
207             temp /= 10;
208         }
209         bytes memory buffer = new bytes(digits);
210         while (value != 0) {
211             digits -= 1;
212             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
213             value /= 10;
214         }
215         return string(buffer);
216     }
217 
218     /**
219      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
220      */
221     function toHexString(uint256 value) internal pure returns (string memory) {
222         if (value == 0) {
223             return "0x00";
224         }
225         uint256 temp = value;
226         uint256 length = 0;
227         while (temp != 0) {
228             length++;
229             temp >>= 8;
230         }
231         return toHexString(value, length);
232     }
233 
234     /**
235      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
236      */
237     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
238         bytes memory buffer = new bytes(2 * length + 2);
239         buffer[0] = "0";
240         buffer[1] = "x";
241         for (uint256 i = 2 * length + 1; i > 1; --i) {
242             buffer[i] = _HEX_SYMBOLS[value & 0xf];
243             value >>= 4;
244         }
245         require(value == 0, "Strings: hex length insufficient");
246         return string(buffer);
247     }
248 }
249 
250 // File: @openzeppelin/contracts/utils/Context.sol
251 
252 
253 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @dev Provides information about the current execution context, including the
259  * sender of the transaction and its data. While these are generally available
260  * via msg.sender and msg.data, they should not be accessed in such a direct
261  * manner, since when dealing with meta-transactions the account sending and
262  * paying for execution may not be the actual sender (as far as an application
263  * is concerned).
264  *
265  * This contract is only required for intermediate, library-like contracts.
266  */
267 abstract contract Context {
268     function _msgSender() internal view virtual returns (address) {
269         return msg.sender;
270     }
271 
272     function _msgData() internal view virtual returns (bytes calldata) {
273         return msg.data;
274     }
275 }
276 
277 // File: @openzeppelin/contracts/access/Ownable.sol
278 
279 
280 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 
285 /**
286  * @dev Contract module which provides a basic access control mechanism, where
287  * there is an account (an owner) that can be granted exclusive access to
288  * specific functions.
289  *
290  * By default, the owner account will be the one that deploys the contract. This
291  * can later be changed with {transferOwnership}.
292  *
293  * This module is used through inheritance. It will make available the modifier
294  * `onlyOwner`, which can be applied to your functions to restrict their use to
295  * the owner.
296  */
297 abstract contract Ownable is Context {
298     address private _owner;
299 
300     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
301 
302     /**
303      * @dev Initializes the contract setting the deployer as the initial owner.
304      */
305     constructor() {
306         _transferOwnership(_msgSender());
307     }
308 
309     /**
310      * @dev Returns the address of the current owner.
311      */
312     function owner() public view virtual returns (address) {
313         return _owner;
314     }
315 
316     /**
317      * @dev Throws if called by any account other than the owner.
318      */
319     modifier onlyOwner() {
320         require(owner() == _msgSender(), "Ownable: caller is not the owner");
321         _;
322     }
323 
324     /**
325      * @dev Leaves the contract without owner. It will not be possible to call
326      * `onlyOwner` functions anymore. Can only be called by the current owner.
327      *
328      * NOTE: Renouncing ownership will leave the contract without an owner,
329      * thereby removing any functionality that is only available to the owner.
330      */
331     function renounceOwnership() public virtual onlyOwner {
332         _transferOwnership(address(0));
333     }
334 
335     /**
336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
337      * Can only be called by the current owner.
338      */
339     function transferOwnership(address newOwner) public virtual onlyOwner {
340         require(newOwner != address(0), "Ownable: new owner is the zero address");
341         _transferOwnership(newOwner);
342     }
343 
344     /**
345      * @dev Transfers ownership of the contract to a new account (`newOwner`).
346      * Internal function without access restriction.
347      */
348     function _transferOwnership(address newOwner) internal virtual {
349         address oldOwner = _owner;
350         _owner = newOwner;
351         emit OwnershipTransferred(oldOwner, newOwner);
352     }
353 }
354 
355 // File: @openzeppelin/contracts/utils/Address.sol
356 
357 
358 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
359 
360 pragma solidity ^0.8.1;
361 
362 /**
363  * @dev Collection of functions related to the address type
364  */
365 library Address {
366     /**
367      * @dev Returns true if `account` is a contract.
368      *
369      * [IMPORTANT]
370      * ====
371      * It is unsafe to assume that an address for which this function returns
372      * false is an externally-owned account (EOA) and not a contract.
373      *
374      * Among others, `isContract` will return false for the following
375      * types of addresses:
376      *
377      *  - an externally-owned account
378      *  - a contract in construction
379      *  - an address where a contract will be created
380      *  - an address where a contract lived, but was destroyed
381      * ====
382      *
383      * [IMPORTANT]
384      * ====
385      * You shouldn't rely on `isContract` to protect against flash loan attacks!
386      *
387      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
388      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
389      * constructor.
390      * ====
391      */
392     function isContract(address account) internal view returns (bool) {
393         // This method relies on extcodesize/address.code.length, which returns 0
394         // for contracts in construction, since the code is only stored at the end
395         // of the constructor execution.
396 
397         return account.code.length > 0;
398     }
399 
400     /**
401      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
402      * `recipient`, forwarding all available gas and reverting on errors.
403      *
404      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
405      * of certain opcodes, possibly making contracts go over the 2300 gas limit
406      * imposed by `transfer`, making them unable to receive funds via
407      * `transfer`. {sendValue} removes this limitation.
408      *
409      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
410      *
411      * IMPORTANT: because control is transferred to `recipient`, care must be
412      * taken to not create reentrancy vulnerabilities. Consider using
413      * {ReentrancyGuard} or the
414      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
415      */
416     function sendValue(address payable recipient, uint256 amount) internal {
417         require(address(this).balance >= amount, "Address: insufficient balance");
418 
419         (bool success, ) = recipient.call{value: amount}("");
420         require(success, "Address: unable to send value, recipient may have reverted");
421     }
422 
423     /**
424      * @dev Performs a Solidity function call using a low level `call`. A
425      * plain `call` is an unsafe replacement for a function call: use this
426      * function instead.
427      *
428      * If `target` reverts with a revert reason, it is bubbled up by this
429      * function (like regular Solidity function calls).
430      *
431      * Returns the raw returned data. To convert to the expected return value,
432      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
433      *
434      * Requirements:
435      *
436      * - `target` must be a contract.
437      * - calling `target` with `data` must not revert.
438      *
439      * _Available since v3.1._
440      */
441     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
442         return functionCall(target, data, "Address: low-level call failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
447      * `errorMessage` as a fallback revert reason when `target` reverts.
448      *
449      * _Available since v3.1._
450      */
451     function functionCall(
452         address target,
453         bytes memory data,
454         string memory errorMessage
455     ) internal returns (bytes memory) {
456         return functionCallWithValue(target, data, 0, errorMessage);
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
461      * but also transferring `value` wei to `target`.
462      *
463      * Requirements:
464      *
465      * - the calling contract must have an ETH balance of at least `value`.
466      * - the called Solidity function must be `payable`.
467      *
468      * _Available since v3.1._
469      */
470     function functionCallWithValue(
471         address target,
472         bytes memory data,
473         uint256 value
474     ) internal returns (bytes memory) {
475         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
480      * with `errorMessage` as a fallback revert reason when `target` reverts.
481      *
482      * _Available since v3.1._
483      */
484     function functionCallWithValue(
485         address target,
486         bytes memory data,
487         uint256 value,
488         string memory errorMessage
489     ) internal returns (bytes memory) {
490         require(address(this).balance >= value, "Address: insufficient balance for call");
491         require(isContract(target), "Address: call to non-contract");
492 
493         (bool success, bytes memory returndata) = target.call{value: value}(data);
494         return verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
499      * but performing a static call.
500      *
501      * _Available since v3.3._
502      */
503     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
504         return functionStaticCall(target, data, "Address: low-level static call failed");
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
509      * but performing a static call.
510      *
511      * _Available since v3.3._
512      */
513     function functionStaticCall(
514         address target,
515         bytes memory data,
516         string memory errorMessage
517     ) internal view returns (bytes memory) {
518         require(isContract(target), "Address: static call to non-contract");
519 
520         (bool success, bytes memory returndata) = target.staticcall(data);
521         return verifyCallResult(success, returndata, errorMessage);
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
526      * but performing a delegate call.
527      *
528      * _Available since v3.4._
529      */
530     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
531         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
536      * but performing a delegate call.
537      *
538      * _Available since v3.4._
539      */
540     function functionDelegateCall(
541         address target,
542         bytes memory data,
543         string memory errorMessage
544     ) internal returns (bytes memory) {
545         require(isContract(target), "Address: delegate call to non-contract");
546 
547         (bool success, bytes memory returndata) = target.delegatecall(data);
548         return verifyCallResult(success, returndata, errorMessage);
549     }
550 
551     /**
552      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
553      * revert reason using the provided one.
554      *
555      * _Available since v4.3._
556      */
557     function verifyCallResult(
558         bool success,
559         bytes memory returndata,
560         string memory errorMessage
561     ) internal pure returns (bytes memory) {
562         if (success) {
563             return returndata;
564         } else {
565             // Look for revert reason and bubble it up if present
566             if (returndata.length > 0) {
567                 // The easiest way to bubble the revert reason is using memory via assembly
568 
569                 assembly {
570                     let returndata_size := mload(returndata)
571                     revert(add(32, returndata), returndata_size)
572                 }
573             } else {
574                 revert(errorMessage);
575             }
576         }
577     }
578 }
579 
580 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
581 
582 
583 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 /**
588  * @title ERC721 token receiver interface
589  * @dev Interface for any contract that wants to support safeTransfers
590  * from ERC721 asset contracts.
591  */
592 interface IERC721Receiver {
593     /**
594      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
595      * by `operator` from `from`, this function is called.
596      *
597      * It must return its Solidity selector to confirm the token transfer.
598      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
599      *
600      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
601      */
602     function onERC721Received(
603         address operator,
604         address from,
605         uint256 tokenId,
606         bytes calldata data
607     ) external returns (bytes4);
608 }
609 
610 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
611 
612 
613 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @dev Interface of the ERC165 standard, as defined in the
619  * https://eips.ethereum.org/EIPS/eip-165[EIP].
620  *
621  * Implementers can declare support of contract interfaces, which can then be
622  * queried by others ({ERC165Checker}).
623  *
624  * For an implementation, see {ERC165}.
625  */
626 interface IERC165 {
627     /**
628      * @dev Returns true if this contract implements the interface defined by
629      * `interfaceId`. See the corresponding
630      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
631      * to learn more about how these ids are created.
632      *
633      * This function call must use less than 30 000 gas.
634      */
635     function supportsInterface(bytes4 interfaceId) external view returns (bool);
636 }
637 
638 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 
646 /**
647  * @dev Implementation of the {IERC165} interface.
648  *
649  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
650  * for the additional interface id that will be supported. For example:
651  *
652  * ```solidity
653  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
654  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
655  * }
656  * ```
657  *
658  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
659  */
660 abstract contract ERC165 is IERC165 {
661     /**
662      * @dev See {IERC165-supportsInterface}.
663      */
664     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
665         return interfaceId == type(IERC165).interfaceId;
666     }
667 }
668 
669 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
670 
671 
672 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 
677 /**
678  * @dev Required interface of an ERC721 compliant contract.
679  */
680 interface IERC721 is IERC165 {
681     /**
682      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
683      */
684     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
685 
686     /**
687      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
688      */
689     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
690 
691     /**
692      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
693      */
694     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
695 
696     /**
697      * @dev Returns the number of tokens in ``owner``'s account.
698      */
699     function balanceOf(address owner) external view returns (uint256 balance);
700 
701     /**
702      * @dev Returns the owner of the `tokenId` token.
703      *
704      * Requirements:
705      *
706      * - `tokenId` must exist.
707      */
708     function ownerOf(uint256 tokenId) external view returns (address owner);
709 
710     /**
711      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
712      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
713      *
714      * Requirements:
715      *
716      * - `from` cannot be the zero address.
717      * - `to` cannot be the zero address.
718      * - `tokenId` token must exist and be owned by `from`.
719      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
720      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
721      *
722      * Emits a {Transfer} event.
723      */
724     function safeTransferFrom(
725         address from,
726         address to,
727         uint256 tokenId
728     ) external;
729 
730     /**
731      * @dev Transfers `tokenId` token from `from` to `to`.
732      *
733      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
734      *
735      * Requirements:
736      *
737      * - `from` cannot be the zero address.
738      * - `to` cannot be the zero address.
739      * - `tokenId` token must be owned by `from`.
740      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
741      *
742      * Emits a {Transfer} event.
743      */
744     function transferFrom(
745         address from,
746         address to,
747         uint256 tokenId
748     ) external;
749 
750     /**
751      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
752      * The approval is cleared when the token is transferred.
753      *
754      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
755      *
756      * Requirements:
757      *
758      * - The caller must own the token or be an approved operator.
759      * - `tokenId` must exist.
760      *
761      * Emits an {Approval} event.
762      */
763     function approve(address to, uint256 tokenId) external;
764 
765     /**
766      * @dev Returns the account approved for `tokenId` token.
767      *
768      * Requirements:
769      *
770      * - `tokenId` must exist.
771      */
772     function getApproved(uint256 tokenId) external view returns (address operator);
773 
774     /**
775      * @dev Approve or remove `operator` as an operator for the caller.
776      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
777      *
778      * Requirements:
779      *
780      * - The `operator` cannot be the caller.
781      *
782      * Emits an {ApprovalForAll} event.
783      */
784     function setApprovalForAll(address operator, bool _approved) external;
785 
786     /**
787      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
788      *
789      * See {setApprovalForAll}
790      */
791     function isApprovedForAll(address owner, address operator) external view returns (bool);
792 
793     /**
794      * @dev Safely transfers `tokenId` token from `from` to `to`.
795      *
796      * Requirements:
797      *
798      * - `from` cannot be the zero address.
799      * - `to` cannot be the zero address.
800      * - `tokenId` token must exist and be owned by `from`.
801      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
802      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
803      *
804      * Emits a {Transfer} event.
805      */
806     function safeTransferFrom(
807         address from,
808         address to,
809         uint256 tokenId,
810         bytes calldata data
811     ) external;
812 }
813 
814 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
815 
816 
817 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
818 
819 pragma solidity ^0.8.0;
820 
821 
822 /**
823  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
824  * @dev See https://eips.ethereum.org/EIPS/eip-721
825  */
826 interface IERC721Metadata is IERC721 {
827     /**
828      * @dev Returns the token collection name.
829      */
830     function name() external view returns (string memory);
831 
832     /**
833      * @dev Returns the token collection symbol.
834      */
835     function symbol() external view returns (string memory);
836 
837     /**
838      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
839      */
840     function tokenURI(uint256 tokenId) external view returns (string memory);
841 }
842 
843 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
844 
845 
846 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
847 
848 pragma solidity ^0.8.0;
849 
850 
851 
852 
853 
854 
855 
856 
857 /**
858  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
859  * the Metadata extension, but not including the Enumerable extension, which is available separately as
860  * {ERC721Enumerable}.
861  */
862 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
863     using Address for address;
864     using Strings for uint256;
865 
866     // Token name
867     string private _name;
868 
869     // Token symbol
870     string private _symbol;
871 
872     // Mapping from token ID to owner address
873     mapping(uint256 => address) private _owners;
874 
875     // Mapping owner address to token count
876     mapping(address => uint256) private _balances;
877 
878     // Mapping from token ID to approved address
879     mapping(uint256 => address) private _tokenApprovals;
880 
881     // Mapping from owner to operator approvals
882     mapping(address => mapping(address => bool)) private _operatorApprovals;
883 
884     /**
885      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
886      */
887     constructor(string memory name_, string memory symbol_) {
888         _name = name_;
889         _symbol = symbol_;
890     }
891 
892     /**
893      * @dev See {IERC165-supportsInterface}.
894      */
895     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
896         return
897             interfaceId == type(IERC721).interfaceId ||
898             interfaceId == type(IERC721Metadata).interfaceId ||
899             super.supportsInterface(interfaceId);
900     }
901 
902     /**
903      * @dev See {IERC721-balanceOf}.
904      */
905     function balanceOf(address owner) public view virtual override returns (uint256) {
906         require(owner != address(0), "ERC721: balance query for the zero address");
907         return _balances[owner];
908     }
909 
910     /**
911      * @dev See {IERC721-ownerOf}.
912      */
913     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
914         address owner = _owners[tokenId];
915         require(owner != address(0), "ERC721: owner query for nonexistent token");
916         return owner;
917     }
918 
919     /**
920      * @dev See {IERC721Metadata-name}.
921      */
922     function name() public view virtual override returns (string memory) {
923         return _name;
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-symbol}.
928      */
929     function symbol() public view virtual override returns (string memory) {
930         return _symbol;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-tokenURI}.
935      */
936     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
937         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
938 
939         string memory baseURI = _baseURI();
940         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
941     }
942 
943     /**
944      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
945      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
946      * by default, can be overriden in child contracts.
947      */
948     function _baseURI() internal view virtual returns (string memory) {
949         return "";
950     }
951 
952     /**
953      * @dev See {IERC721-approve}.
954      */
955     function approve(address to, uint256 tokenId) public virtual override {
956         address owner = ERC721.ownerOf(tokenId);
957         require(to != owner, "ERC721: approval to current owner");
958 
959         require(
960             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
961             "ERC721: approve caller is not owner nor approved for all"
962         );
963 
964         _approve(to, tokenId);
965     }
966 
967     /**
968      * @dev See {IERC721-getApproved}.
969      */
970     function getApproved(uint256 tokenId) public view virtual override returns (address) {
971         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
972 
973         return _tokenApprovals[tokenId];
974     }
975 
976     /**
977      * @dev See {IERC721-setApprovalForAll}.
978      */
979     function setApprovalForAll(address operator, bool approved) public virtual override {
980         _setApprovalForAll(_msgSender(), operator, approved);
981     }
982 
983     /**
984      * @dev See {IERC721-isApprovedForAll}.
985      */
986     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
987         return _operatorApprovals[owner][operator];
988     }
989 
990     /**
991      * @dev See {IERC721-transferFrom}.
992      */
993     function transferFrom(
994         address from,
995         address to,
996         uint256 tokenId
997     ) public virtual override {
998         //solhint-disable-next-line max-line-length
999         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1000 
1001         _transfer(from, to, tokenId);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-safeTransferFrom}.
1006      */
1007     function safeTransferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) public virtual override {
1012         safeTransferFrom(from, to, tokenId, "");
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-safeTransferFrom}.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId,
1022         bytes memory _data
1023     ) public virtual override {
1024         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1025         _safeTransfer(from, to, tokenId, _data);
1026     }
1027 
1028     /**
1029      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1030      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1031      *
1032      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1033      *
1034      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1035      * implement alternative mechanisms to perform token transfer, such as signature-based.
1036      *
1037      * Requirements:
1038      *
1039      * - `from` cannot be the zero address.
1040      * - `to` cannot be the zero address.
1041      * - `tokenId` token must exist and be owned by `from`.
1042      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function _safeTransfer(
1047         address from,
1048         address to,
1049         uint256 tokenId,
1050         bytes memory _data
1051     ) internal virtual {
1052         _transfer(from, to, tokenId);
1053         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1054     }
1055 
1056     /**
1057      * @dev Returns whether `tokenId` exists.
1058      *
1059      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1060      *
1061      * Tokens start existing when they are minted (`_mint`),
1062      * and stop existing when they are burned (`_burn`).
1063      */
1064     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1065         return _owners[tokenId] != address(0);
1066     }
1067 
1068     /**
1069      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1070      *
1071      * Requirements:
1072      *
1073      * - `tokenId` must exist.
1074      */
1075     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1076         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1077         address owner = ERC721.ownerOf(tokenId);
1078         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1079     }
1080 
1081     /**
1082      * @dev Safely mints `tokenId` and transfers it to `to`.
1083      *
1084      * Requirements:
1085      *
1086      * - `tokenId` must not exist.
1087      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _safeMint(address to, uint256 tokenId) internal virtual {
1092         _safeMint(to, tokenId, "");
1093     }
1094 
1095     /**
1096      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1097      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1098      */
1099     function _safeMint(
1100         address to,
1101         uint256 tokenId,
1102         bytes memory _data
1103     ) internal virtual {
1104         _mint(to, tokenId);
1105         require(
1106             _checkOnERC721Received(address(0), to, tokenId, _data),
1107             "ERC721: transfer to non ERC721Receiver implementer"
1108         );
1109     }
1110 
1111     /**
1112      * @dev Mints `tokenId` and transfers it to `to`.
1113      *
1114      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1115      *
1116      * Requirements:
1117      *
1118      * - `tokenId` must not exist.
1119      * - `to` cannot be the zero address.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function _mint(address to, uint256 tokenId) internal virtual {
1124         require(to != address(0), "ERC721: mint to the zero address");
1125         require(!_exists(tokenId), "ERC721: token already minted");
1126 
1127         _beforeTokenTransfer(address(0), to, tokenId);
1128 
1129         _balances[to] += 1;
1130         _owners[tokenId] = to;
1131 
1132         emit Transfer(address(0), to, tokenId);
1133 
1134         _afterTokenTransfer(address(0), to, tokenId);
1135     }
1136 
1137     /**
1138      * @dev Destroys `tokenId`.
1139      * The approval is cleared when the token is burned.
1140      *
1141      * Requirements:
1142      *
1143      * - `tokenId` must exist.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function _burn(uint256 tokenId) internal virtual {
1148         address owner = ERC721.ownerOf(tokenId);
1149 
1150         _beforeTokenTransfer(owner, address(0), tokenId);
1151 
1152         // Clear approvals
1153         _approve(address(0), tokenId);
1154 
1155         _balances[owner] -= 1;
1156         delete _owners[tokenId];
1157 
1158         emit Transfer(owner, address(0), tokenId);
1159 
1160         _afterTokenTransfer(owner, address(0), tokenId);
1161     }
1162 
1163     /**
1164      * @dev Transfers `tokenId` from `from` to `to`.
1165      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1166      *
1167      * Requirements:
1168      *
1169      * - `to` cannot be the zero address.
1170      * - `tokenId` token must be owned by `from`.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function _transfer(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) internal virtual {
1179         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1180         require(to != address(0), "ERC721: transfer to the zero address");
1181 
1182         _beforeTokenTransfer(from, to, tokenId);
1183 
1184         // Clear approvals from the previous owner
1185         _approve(address(0), tokenId);
1186 
1187         _balances[from] -= 1;
1188         _balances[to] += 1;
1189         _owners[tokenId] = to;
1190 
1191         emit Transfer(from, to, tokenId);
1192 
1193         _afterTokenTransfer(from, to, tokenId);
1194     }
1195 
1196     /**
1197      * @dev Approve `to` to operate on `tokenId`
1198      *
1199      * Emits a {Approval} event.
1200      */
1201     function _approve(address to, uint256 tokenId) internal virtual {
1202         _tokenApprovals[tokenId] = to;
1203         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1204     }
1205 
1206     /**
1207      * @dev Approve `operator` to operate on all of `owner` tokens
1208      *
1209      * Emits a {ApprovalForAll} event.
1210      */
1211     function _setApprovalForAll(
1212         address owner,
1213         address operator,
1214         bool approved
1215     ) internal virtual {
1216         require(owner != operator, "ERC721: approve to caller");
1217         _operatorApprovals[owner][operator] = approved;
1218         emit ApprovalForAll(owner, operator, approved);
1219     }
1220 
1221     /**
1222      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1223      * The call is not executed if the target address is not a contract.
1224      *
1225      * @param from address representing the previous owner of the given token ID
1226      * @param to target address that will receive the tokens
1227      * @param tokenId uint256 ID of the token to be transferred
1228      * @param _data bytes optional data to send along with the call
1229      * @return bool whether the call correctly returned the expected magic value
1230      */
1231     function _checkOnERC721Received(
1232         address from,
1233         address to,
1234         uint256 tokenId,
1235         bytes memory _data
1236     ) private returns (bool) {
1237         if (to.isContract()) {
1238             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1239                 return retval == IERC721Receiver.onERC721Received.selector;
1240             } catch (bytes memory reason) {
1241                 if (reason.length == 0) {
1242                     revert("ERC721: transfer to non ERC721Receiver implementer");
1243                 } else {
1244                     assembly {
1245                         revert(add(32, reason), mload(reason))
1246                     }
1247                 }
1248             }
1249         } else {
1250             return true;
1251         }
1252     }
1253 
1254     /**
1255      * @dev Hook that is called before any token transfer. This includes minting
1256      * and burning.
1257      *
1258      * Calling conditions:
1259      *
1260      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1261      * transferred to `to`.
1262      * - When `from` is zero, `tokenId` will be minted for `to`.
1263      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1264      * - `from` and `to` are never both zero.
1265      *
1266      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1267      */
1268     function _beforeTokenTransfer(
1269         address from,
1270         address to,
1271         uint256 tokenId
1272     ) internal virtual {}
1273 
1274     /**
1275      * @dev Hook that is called after any transfer of tokens. This includes
1276      * minting and burning.
1277      *
1278      * Calling conditions:
1279      *
1280      * - when `from` and `to` are both non-zero.
1281      * - `from` and `to` are never both zero.
1282      *
1283      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1284      */
1285     function _afterTokenTransfer(
1286         address from,
1287         address to,
1288         uint256 tokenId
1289     ) internal virtual {}
1290 }
1291 
1292 // File: contracts/SUPERCOOLPEEPS.sol
1293 
1294 
1295 // SUPER COOL PEEPS
1296 // by SuperCoolStyle
1297 
1298 pragma solidity 0.8.1;
1299 
1300 
1301 
1302 
1303 
1304 contract SUPERCOOLPEEPS is ERC721, Ownable {
1305   using Strings for uint256;
1306   using Counters for Counters.Counter;
1307   string public baseExtURI="https://supercoolpeeps.com/";
1308   string public baseImgURI="https://supercoolpeeps.com/img/";
1309   string public baseAniURI = "https://supercoolpeeps.com/app.html";
1310   uint256 public cost = 10 ether;
1311   uint256 public maxSupply = 10000;
1312   uint256 public freeSupply = 500;
1313   uint256 public maxMintPerTx = 10;
1314   bool public paused = true;
1315   mapping(address => uint256) public addressFreeMint;
1316   mapping(uint256 => uint256) public seeds;
1317   Counters.Counter private supply;
1318 
1319   
1320   constructor() ERC721("SUPERCOOLPEEPS", "PEEP") {
1321     privateMint(10,msg.sender);
1322   }
1323 
1324   function freeMint() public{
1325     require(!paused,"Mint Paused");
1326     require(supply.current() + 1 <= freeSupply,"Max Free NFT supply exceeded");
1327     require(addressFreeMint[msg.sender] < 1, "Only 1 Free NFT per wallet allowed");
1328     _mintCore(msg.sender,1);
1329     addressFreeMint[msg.sender]++;
1330   }
1331 
1332   function mint(uint256 _mintAmount) public payable mintMod(_mintAmount){
1333   
1334     require(!paused,"Mint Paused");
1335     require(msg.value >= cost * _mintAmount,"Insufficient fund");
1336     _mintCore(msg.sender,_mintAmount);
1337 
1338   }
1339 
1340   function privateMint(uint256 _mintAmount, address _receiver) public mintMod(_mintAmount) onlyOwner {
1341     _mintCore(_receiver,_mintAmount);
1342   }
1343 
1344   modifier mintMod(uint256 _mintAmount) {
1345     require(_mintAmount > 0 && _mintAmount <= maxMintPerTx, "Invalid mint amount");
1346     require(supply.current()+ _mintAmount <= maxSupply,"Max NFT supply exceeded");
1347     _;
1348   }
1349 
1350   function _mintCore(address _receiver, uint256 _mintAmount) internal {
1351      for (uint256 i = 1; i <= _mintAmount; i++) {
1352       supply.increment();
1353       uint256 tid = supply.current();
1354       _safeMint(_receiver, tid);
1355       seeds[tid] = uint256(keccak256(abi.encodePacked(uint256(bytes32(blockhash(block.number - 1))), tid)));
1356     }
1357   }
1358 
1359   function walletOfOwner(address _owner)
1360     public
1361     view
1362     returns (uint256[] memory)
1363   {
1364     uint256 ownerTokenCount = balanceOf(_owner);
1365     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1366     uint256 currentTokenId = 1;
1367     uint256 ownedTokenIndex = 0;
1368 
1369     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1370       address currentTokenOwner = ownerOf(currentTokenId);
1371 
1372       if (currentTokenOwner == _owner) {
1373         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1374         ownedTokenIndex++;
1375       }
1376       currentTokenId++;
1377     }
1378     return ownedTokenIds;
1379   }
1380   
1381   function contractURI() public pure returns (string memory) {
1382          return "https://supercoolpeeps.com/metadata.json";
1383   }
1384 
1385 
1386   function tokenURI(uint256 tokenId)
1387     public
1388     view
1389     virtual
1390     override
1391     returns (string memory)
1392   {
1393     require(
1394       _exists(tokenId), "Token not found!"
1395     );
1396     return(genMeta(tokenId,seeds[tokenId]));
1397   }
1398 
1399   function totalSupply() public view returns (uint256) {
1400     return supply.current();
1401   }
1402   function setCost(uint256 _new) public onlyOwner() {
1403     cost = _new;
1404   }
1405 
1406   function setFreeSupply(uint256 _new) public onlyOwner() {
1407     require(_new < maxSupply, "Must be smaller than Max Supply");
1408     freeSupply = _new;
1409   }
1410 
1411   function setMaxMintPerTx(uint256 _new) public onlyOwner() {
1412     maxMintPerTx = _new;
1413   }
1414 
1415   function setBaseExtURI(string memory _new) public onlyOwner {
1416     baseExtURI = _new;
1417   }
1418 
1419   function setBaseAniURI(string memory _new) public onlyOwner {
1420     baseAniURI = _new;
1421   }
1422   function setBaseImgURI(string memory _new) public onlyOwner {
1423     baseImgURI = _new;
1424   }
1425   function pause(bool _state) public onlyOwner {
1426     paused = _state;
1427   }
1428 
1429   function withdraw() public payable onlyOwner {
1430     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1431     require(success);
1432   }
1433   
1434   function substring(string memory str, uint startIndex, uint endIndex) private pure returns (string memory) {
1435     bytes memory strBytes = bytes(str);
1436     bytes memory result = new bytes(endIndex-startIndex);
1437     for(uint i = startIndex; i < endIndex; i++) {
1438         result[i-startIndex] = strBytes[i];
1439     }
1440     return string(result);
1441   }
1442     
1443     
1444   function strToUint(string memory _str) private pure returns(uint256 res) {
1445     for (uint256 i = 0; i < bytes(_str).length; i++) {
1446         res += (uint8(bytes(_str)[i]) - 48) * 10**(bytes(_str).length - i - 1);
1447     }
1448     return (res);
1449   }
1450 
1451 
1452   function getRanResult(uint256 num, uint8[12] memory chance) private pure returns(uint256 res) {
1453     for (uint256 i=0; i<chance.length; i++)
1454       if (num<chance[i]) return(i);  
1455     return(0);
1456   } 
1457 
1458   struct Metadata{
1459     string gender;
1460     string body;
1461     string skin;
1462     string hairColor;
1463     string hair;
1464     string beard;
1465     string face;
1466     string head;    
1467 
1468     string extURL;
1469     string aniURL;
1470     string imgURL;
1471     string name;
1472 
1473     string[9] tops;
1474     string[4] goodies;
1475 
1476     string topPacked;
1477   }
1478 
1479   struct CheckData{
1480      uint8[12] chanceBody;
1481      string[6] nameBody;
1482 
1483      uint8[12] chanceSkin;
1484      string[7] nameSkin;
1485 
1486      uint8[12] chanceHairColor;
1487      string[12] nameHairColor;
1488 
1489      uint8[9] chanceShowTop;
1490      uint8[4] chanceShowGoodie;
1491 
1492      uint8[9][2] topsTotal;
1493      uint8[4][2] goodiesTotal;
1494 
1495      string[4] nameGoodie;
1496 
1497      uint256 body;
1498   }
1499   
1500   
1501   function genMeta(uint256 tid, uint256 seed) private view returns (string memory) {
1502         Metadata memory attr;
1503         CheckData memory check;
1504         string memory seedStr = seed.toString();
1505 
1506         
1507         check.chanceBody=[40,72,92,97,99,100,100,100,100,100,100,100];
1508         check.nameBody=["Normal","Skinny","Tattoo","Ape","Zombie","Skeleton"];
1509 
1510         check.chanceSkin=[18,36,54,72,90,95,100,100,100,100,100,100];
1511         check.nameSkin=["Human 1","Human 2","Human 3","Human 4","Human 5","Vampire","Amphibian"];
1512 
1513         check.chanceHairColor=[12,25,37,50,62,76,80,84,88,92,96,100];
1514         check.nameHairColor=["Gray","Amber","Brown","Blonde","Black","Tan","Red","Pink","Blue","Green","Purple","White"];
1515 
1516         check.chanceShowTop=[99,50,30,30,20,20,10,10,5];
1517         check.chanceShowGoodie=[8,30,40,4];
1518 
1519         check.topsTotal=[[12,39,22,35,4, 6, 5,5,3],[8,18,20,18,12,10,9,9,4]];
1520 
1521 
1522         check.goodiesTotal=[[5,25,19,8],[6,21,19,8]];
1523         check.nameGoodie=["Mouth","Hat","Eyewear","Special"];
1524 
1525 
1526         attr.gender = substring(seedStr,1,2);
1527         attr.body = substring(seedStr,2,4);
1528         attr.skin = substring(seedStr,4,6);
1529         attr.hairColor = substring(seedStr,6,8);
1530         attr.hair = substring(seedStr,60,62);
1531         attr.beard = substring(seedStr,62,64);
1532         attr.face = substring(seedStr,64,66);
1533         attr.head = substring(seedStr,66,67);
1534 
1535         attr.extURL = string(abi.encodePacked('"external_url":"',baseExtURI,'?s=',seed.toString(),'",'));
1536         attr.aniURL = string(abi.encodePacked('"animation_url":"',baseAniURI,'?s=',seed.toString(),'",'));
1537         attr.imgURL = string(abi.encodePacked('"image":"',baseImgURI,tid.toString(),'.png"'));
1538         attr.name = string(abi.encodePacked('"name":"PEEP #',tid.toString()));
1539 
1540         uint256 num;
1541         uint256 g;
1542         
1543         num = strToUint(attr.gender); 
1544         g=num%2;
1545         attr.gender = (num%2).toString();
1546         
1547         num = strToUint(attr.body); 
1548         check.body = getRanResult(num,check.chanceBody);
1549         attr.body = check.nameBody[check.body];
1550 
1551         num = strToUint(attr.skin); 
1552         attr.skin = check.nameSkin[getRanResult(num,check.chanceSkin)];
1553 
1554         num = strToUint(attr.hairColor); 
1555         attr.hairColor = check.nameHairColor[getRanResult(num,check.chanceHairColor)];
1556 
1557         num = strToUint(attr.head);
1558         attr.head = (num%5).toString();
1559 
1560         num = strToUint(attr.face);
1561         attr.face = (num%12).toString();
1562 
1563         num = strToUint(attr.hair);
1564         if (g==0) attr.hair = (num%36).toString();
1565         else attr.hair = (num%35).toString();
1566 
1567         num = strToUint(attr.beard);
1568         if (g==0) attr.beard = "0";
1569         else attr.beard = (num%26).toString();
1570 
1571 
1572         ////exceptions for ape/zombie/bone 
1573         if (check.body>2) attr.head=attr.face=attr.beard=attr.skin=attr.body;
1574 
1575         
1576         //tops
1577         uint256 totalTops=0;
1578 
1579         for (uint256 i=0; i<check.chanceShowTop.length; i++){
1580           num = strToUint(substring(seedStr,8+i*4+2,8+i*4+2+2)); //show
1581           if (num<check.chanceShowTop[i]) {
1582             totalTops++;
1583             num = strToUint(substring(seedStr,8+i*4,8+i*4+2)); //ID
1584             attr.tops[i]=string(abi.encodePacked('"T#',attr.gender,'-',(num%check.topsTotal[g][i]).toString(),'"'));
1585           } else attr.tops[i]='"None"';
1586           attr.tops[i]=string(abi.encodePacked('{"trait_type":"Top Layer ',(i+1).toString(),'","value":',attr.tops[i],'},'));
1587         }
1588 
1589 
1590 
1591         //goodies
1592         uint256 totalGoodies=0;
1593         for (uint256 i=0; i<check.chanceShowGoodie.length; i++){
1594           num = strToUint(substring(seedStr,44+i*4+2,44+i*4+2+2)); //show
1595           if (num<check.chanceShowGoodie[i]) {
1596             totalGoodies++;
1597             num = strToUint(substring(seedStr,44+i*4,44+i*4+2)); //ID
1598             attr.goodies[i]=string(abi.encodePacked('"A#',attr.gender,'-',(num%check.goodiesTotal[g][i]).toString(),'"'));
1599           } else attr.goodies[i]='"None"';
1600           attr.goodies[i]=string(abi.encodePacked('{"trait_type":"',check.nameGoodie[i],'","value":',attr.goodies[i],'},'));
1601         }
1602        
1603 
1604         attr.topPacked=string(
1605           abi.encodePacked( 
1606                             attr.tops[0],attr.tops[1],attr.tops[2],attr.tops[3],attr.tops[4],attr.tops[5],
1607                             attr.tops[6],attr.tops[7],attr.tops[8]
1608                            
1609                        
1610             )
1611           );
1612 
1613 
1614          string memory moreAttr=string(
1615           abi.encodePacked( 
1616                             attr.goodies[0],attr.goodies[1],attr.goodies[2],attr.goodies[3],
1617 
1618                             '{"trait_type":"Top Count","value":',totalTops.toString(),
1619                             '},{"trait_type":"Accessory Count","value":',totalGoodies.toString(),
1620                             '},{"trait_type":"Skin","value":"',attr.skin,
1621                             '"},{"trait_type":"ID","value":"ID #',attr.gender,
1622                             '"},{"trait_type":"Face","value":"Type ',attr.face,                        
1623                             '"},'
1624             )
1625           );
1626 
1627         string memory moreLastAttr=string(
1628           abi.encodePacked(
1629                             '{"trait_type":"Type","value":"',attr.body,
1630                             '"},{"trait_type":"Hair","value":"Style ',attr.gender,'-',attr.hair,
1631                             '"},{"trait_type":"Hair Color","value":"',attr.hairColor,
1632                             '"},{"trait_type":"Head","value":"Type ',attr.head,
1633                             '"},{"trait_type":"Facial Hair","value":"Style ',attr.beard,                      
1634                             '"}'
1635             )
1636           );
1637 
1638         return string(
1639                 abi.encodePacked(
1640                     "data:application/json;base64,",
1641                     Base64.encode(
1642                         bytes(
1643                             abi.encodePacked('{',attr.name,
1644                             '","description":"","attributes":[',
1645                             attr.topPacked,
1646                             moreAttr,
1647                             moreLastAttr,
1648                             '],',
1649                             attr.extURL,attr.aniURL,attr.imgURL,
1650                             '}'
1651                             )
1652                         )
1653                     )
1654                 )
1655             );
1656     }
1657 }