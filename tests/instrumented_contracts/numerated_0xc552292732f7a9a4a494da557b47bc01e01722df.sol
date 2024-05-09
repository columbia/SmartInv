1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
2 
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
47 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Contract module that helps prevent reentrant calls to a function.
56  *
57  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
58  * available, which can be applied to functions to make sure there are no nested
59  * (reentrant) calls to them.
60  *
61  * Note that because there is a single `nonReentrant` guard, functions marked as
62  * `nonReentrant` may not call one another. This can be worked around by making
63  * those functions `private`, and then adding `external` `nonReentrant` entry
64  * points to them.
65  *
66  * TIP: If you would like to learn more about reentrancy and alternative ways
67  * to protect against it, check out our blog post
68  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
69  */
70 abstract contract ReentrancyGuard {
71     // Booleans are more expensive than uint256 or any type that takes up a full
72     // word because each write operation emits an extra SLOAD to first read the
73     // slot's contents, replace the bits taken up by the boolean, and then write
74     // back. This is the compiler's defense against contract upgrades and
75     // pointer aliasing, and it cannot be disabled.
76 
77     // The values being non-zero value makes deployment a bit more expensive,
78     // but in exchange the refund on every call to nonReentrant will be lower in
79     // amount. Since refunds are capped to a percentage of the total
80     // transaction's gas, it is best to keep them low in cases like this one, to
81     // increase the likelihood of the full refund coming into effect.
82     uint256 private constant _NOT_ENTERED = 1;
83     uint256 private constant _ENTERED = 2;
84 
85     uint256 private _status;
86 
87     constructor() {
88         _status = _NOT_ENTERED;
89     }
90 
91     /**
92      * @dev Prevents a contract from calling itself, directly or indirectly.
93      * Calling a `nonReentrant` function from another `nonReentrant`
94      * function is not supported. It is possible to prevent this from happening
95      * by making the `nonReentrant` function external, and making it call a
96      * `private` function that does the actual work.
97      */
98     modifier nonReentrant() {
99         // On the first call to nonReentrant, _notEntered will be true
100         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
101 
102         // Any calls to nonReentrant after this point will fail
103         _status = _ENTERED;
104 
105         _;
106 
107         // By storing the original value once again, a refund is triggered (see
108         // https://eips.ethereum.org/EIPS/eip-2200)
109         _status = _NOT_ENTERED;
110     }
111 }
112 
113 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev String operations.
122  */
123 library Strings {
124     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
125 
126     /**
127      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
128      */
129     function toString(uint256 value) internal pure returns (string memory) {
130         // Inspired by OraclizeAPI's implementation - MIT licence
131         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
132 
133         if (value == 0) {
134             return "0";
135         }
136         uint256 temp = value;
137         uint256 digits;
138         while (temp != 0) {
139             digits++;
140             temp /= 10;
141         }
142         bytes memory buffer = new bytes(digits);
143         while (value != 0) {
144             digits -= 1;
145             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
146             value /= 10;
147         }
148         return string(buffer);
149     }
150 
151     /**
152      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
153      */
154     function toHexString(uint256 value) internal pure returns (string memory) {
155         if (value == 0) {
156             return "0x00";
157         }
158         uint256 temp = value;
159         uint256 length = 0;
160         while (temp != 0) {
161             length++;
162             temp >>= 8;
163         }
164         return toHexString(value, length);
165     }
166 
167     /**
168      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
169      */
170     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
171         bytes memory buffer = new bytes(2 * length + 2);
172         buffer[0] = "0";
173         buffer[1] = "x";
174         for (uint256 i = 2 * length + 1; i > 1; --i) {
175             buffer[i] = _HEX_SYMBOLS[value & 0xf];
176             value >>= 4;
177         }
178         require(value == 0, "Strings: hex length insufficient");
179         return string(buffer);
180     }
181 }
182 
183 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
184 
185 
186 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @dev Provides information about the current execution context, including the
192  * sender of the transaction and its data. While these are generally available
193  * via msg.sender and msg.data, they should not be accessed in such a direct
194  * manner, since when dealing with meta-transactions the account sending and
195  * paying for execution may not be the actual sender (as far as an application
196  * is concerned).
197  *
198  * This contract is only required for intermediate, library-like contracts.
199  */
200 abstract contract Context {
201     function _msgSender() internal view virtual returns (address) {
202         return msg.sender;
203     }
204 
205     function _msgData() internal view virtual returns (bytes calldata) {
206         return msg.data;
207     }
208 }
209 
210 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
211 
212 
213 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
214 
215 pragma solidity ^0.8.0;
216 
217 
218 /**
219  * @dev Contract module which provides a basic access control mechanism, where
220  * there is an account (an owner) that can be granted exclusive access to
221  * specific functions.
222  *
223  * By default, the owner account will be the one that deploys the contract. This
224  * can later be changed with {transferOwnership}.
225  *
226  * This module is used through inheritance. It will make available the modifier
227  * `onlyOwner`, which can be applied to your functions to restrict their use to
228  * the owner.
229  */
230 abstract contract Ownable is Context {
231     address private _owner;
232 
233     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
234 
235     /**
236      * @dev Initializes the contract setting the deployer as the initial owner.
237      */
238     constructor() {
239         _transferOwnership(_msgSender());
240     }
241 
242     /**
243      * @dev Returns the address of the current owner.
244      */
245     function owner() public view virtual returns (address) {
246         return _owner;
247     }
248 
249     /**
250      * @dev Throws if called by any account other than the owner.
251      */
252     modifier onlyOwner() {
253         require(owner() == _msgSender(), "Ownable: caller is not the owner");
254         _;
255     }
256 
257     /**
258      * @dev Leaves the contract without owner. It will not be possible to call
259      * `onlyOwner` functions anymore. Can only be called by the current owner.
260      *
261      * NOTE: Renouncing ownership will leave the contract without an owner,
262      * thereby removing any functionality that is only available to the owner.
263      */
264     function renounceOwnership() public virtual onlyOwner {
265         _transferOwnership(address(0));
266     }
267 
268     /**
269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
270      * Can only be called by the current owner.
271      */
272     function transferOwnership(address newOwner) public virtual onlyOwner {
273         require(newOwner != address(0), "Ownable: new owner is the zero address");
274         _transferOwnership(newOwner);
275     }
276 
277     /**
278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
279      * Internal function without access restriction.
280      */
281     function _transferOwnership(address newOwner) internal virtual {
282         address oldOwner = _owner;
283         _owner = newOwner;
284         emit OwnershipTransferred(oldOwner, newOwner);
285     }
286 }
287 
288 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
289 
290 
291 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
292 
293 pragma solidity ^0.8.1;
294 
295 /**
296  * @dev Collection of functions related to the address type
297  */
298 library Address {
299     /**
300      * @dev Returns true if `account` is a contract.
301      *
302      * [IMPORTANT]
303      * ====
304      * It is unsafe to assume that an address for which this function returns
305      * false is an externally-owned account (EOA) and not a contract.
306      *
307      * Among others, `isContract` will return false for the following
308      * types of addresses:
309      *
310      *  - an externally-owned account
311      *  - a contract in construction
312      *  - an address where a contract will be created
313      *  - an address where a contract lived, but was destroyed
314      * ====
315      *
316      * [IMPORTANT]
317      * ====
318      * You shouldn't rely on `isContract` to protect against flash loan attacks!
319      *
320      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
321      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
322      * constructor.
323      * ====
324      */
325     function isContract(address account) internal view returns (bool) {
326         // This method relies on extcodesize/address.code.length, which returns 0
327         // for contracts in construction, since the code is only stored at the end
328         // of the constructor execution.
329 
330         return account.code.length > 0;
331     }
332 
333     /**
334      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
335      * `recipient`, forwarding all available gas and reverting on errors.
336      *
337      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
338      * of certain opcodes, possibly making contracts go over the 2300 gas limit
339      * imposed by `transfer`, making them unable to receive funds via
340      * `transfer`. {sendValue} removes this limitation.
341      *
342      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
343      *
344      * IMPORTANT: because control is transferred to `recipient`, care must be
345      * taken to not create reentrancy vulnerabilities. Consider using
346      * {ReentrancyGuard} or the
347      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
348      */
349     function sendValue(address payable recipient, uint256 amount) internal {
350         require(address(this).balance >= amount, "Address: insufficient balance");
351 
352         (bool success, ) = recipient.call{value: amount}("");
353         require(success, "Address: unable to send value, recipient may have reverted");
354     }
355 
356     /**
357      * @dev Performs a Solidity function call using a low level `call`. A
358      * plain `call` is an unsafe replacement for a function call: use this
359      * function instead.
360      *
361      * If `target` reverts with a revert reason, it is bubbled up by this
362      * function (like regular Solidity function calls).
363      *
364      * Returns the raw returned data. To convert to the expected return value,
365      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
366      *
367      * Requirements:
368      *
369      * - `target` must be a contract.
370      * - calling `target` with `data` must not revert.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
375         return functionCall(target, data, "Address: low-level call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
380      * `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, 0, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but also transferring `value` wei to `target`.
395      *
396      * Requirements:
397      *
398      * - the calling contract must have an ETH balance of at least `value`.
399      * - the called Solidity function must be `payable`.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(
404         address target,
405         bytes memory data,
406         uint256 value
407     ) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
413      * with `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         require(address(this).balance >= value, "Address: insufficient balance for call");
424         require(isContract(target), "Address: call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.call{value: value}(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a static call.
433      *
434      * _Available since v3.3._
435      */
436     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
437         return functionStaticCall(target, data, "Address: low-level static call failed");
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
442      * but performing a static call.
443      *
444      * _Available since v3.3._
445      */
446     function functionStaticCall(
447         address target,
448         bytes memory data,
449         string memory errorMessage
450     ) internal view returns (bytes memory) {
451         require(isContract(target), "Address: static call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.staticcall(data);
454         return verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but performing a delegate call.
460      *
461      * _Available since v3.4._
462      */
463     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
464         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.4._
472      */
473     function functionDelegateCall(
474         address target,
475         bytes memory data,
476         string memory errorMessage
477     ) internal returns (bytes memory) {
478         require(isContract(target), "Address: delegate call to non-contract");
479 
480         (bool success, bytes memory returndata) = target.delegatecall(data);
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
486      * revert reason using the provided one.
487      *
488      * _Available since v4.3._
489      */
490     function verifyCallResult(
491         bool success,
492         bytes memory returndata,
493         string memory errorMessage
494     ) internal pure returns (bytes memory) {
495         if (success) {
496             return returndata;
497         } else {
498             // Look for revert reason and bubble it up if present
499             if (returndata.length > 0) {
500                 // The easiest way to bubble the revert reason is using memory via assembly
501 
502                 assembly {
503                     let returndata_size := mload(returndata)
504                     revert(add(32, returndata), returndata_size)
505                 }
506             } else {
507                 revert(errorMessage);
508             }
509         }
510     }
511 }
512 
513 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
514 
515 
516 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @title ERC721 token receiver interface
522  * @dev Interface for any contract that wants to support safeTransfers
523  * from ERC721 asset contracts.
524  */
525 interface IERC721Receiver {
526     /**
527      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
528      * by `operator` from `from`, this function is called.
529      *
530      * It must return its Solidity selector to confirm the token transfer.
531      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
532      *
533      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
534      */
535     function onERC721Received(
536         address operator,
537         address from,
538         uint256 tokenId,
539         bytes calldata data
540     ) external returns (bytes4);
541 }
542 
543 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
544 
545 
546 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 /**
551  * @dev Interface of the ERC165 standard, as defined in the
552  * https://eips.ethereum.org/EIPS/eip-165[EIP].
553  *
554  * Implementers can declare support of contract interfaces, which can then be
555  * queried by others ({ERC165Checker}).
556  *
557  * For an implementation, see {ERC165}.
558  */
559 interface IERC165 {
560     /**
561      * @dev Returns true if this contract implements the interface defined by
562      * `interfaceId`. See the corresponding
563      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
564      * to learn more about how these ids are created.
565      *
566      * This function call must use less than 30 000 gas.
567      */
568     function supportsInterface(bytes4 interfaceId) external view returns (bool);
569 }
570 
571 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155Receiver.sol
572 
573 
574 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 
579 /**
580  * @dev _Available since v3.1._
581  */
582 interface IERC1155Receiver is IERC165 {
583     /**
584      * @dev Handles the receipt of a single ERC1155 token type. This function is
585      * called at the end of a `safeTransferFrom` after the balance has been updated.
586      *
587      * NOTE: To accept the transfer, this must return
588      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
589      * (i.e. 0xf23a6e61, or its own function selector).
590      *
591      * @param operator The address which initiated the transfer (i.e. msg.sender)
592      * @param from The address which previously owned the token
593      * @param id The ID of the token being transferred
594      * @param value The amount of tokens being transferred
595      * @param data Additional data with no specified format
596      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
597      */
598     function onERC1155Received(
599         address operator,
600         address from,
601         uint256 id,
602         uint256 value,
603         bytes calldata data
604     ) external returns (bytes4);
605 
606     /**
607      * @dev Handles the receipt of a multiple ERC1155 token types. This function
608      * is called at the end of a `safeBatchTransferFrom` after the balances have
609      * been updated.
610      *
611      * NOTE: To accept the transfer(s), this must return
612      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
613      * (i.e. 0xbc197c81, or its own function selector).
614      *
615      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
616      * @param from The address which previously owned the token
617      * @param ids An array containing ids of each token being transferred (order and length must match values array)
618      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
619      * @param data Additional data with no specified format
620      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
621      */
622     function onERC1155BatchReceived(
623         address operator,
624         address from,
625         uint256[] calldata ids,
626         uint256[] calldata values,
627         bytes calldata data
628     ) external returns (bytes4);
629 }
630 
631 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155.sol
632 
633 
634 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 
639 /**
640  * @dev Required interface of an ERC1155 compliant contract, as defined in the
641  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
642  *
643  * _Available since v3.1._
644  */
645 interface IERC1155 is IERC165 {
646     /**
647      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
648      */
649     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
650 
651     /**
652      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
653      * transfers.
654      */
655     event TransferBatch(
656         address indexed operator,
657         address indexed from,
658         address indexed to,
659         uint256[] ids,
660         uint256[] values
661     );
662 
663     /**
664      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
665      * `approved`.
666      */
667     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
668 
669     /**
670      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
671      *
672      * If an {URI} event was emitted for `id`, the standard
673      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
674      * returned by {IERC1155MetadataURI-uri}.
675      */
676     event URI(string value, uint256 indexed id);
677 
678     /**
679      * @dev Returns the amount of tokens of token type `id` owned by `account`.
680      *
681      * Requirements:
682      *
683      * - `account` cannot be the zero address.
684      */
685     function balanceOf(address account, uint256 id) external view returns (uint256);
686 
687     /**
688      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
689      *
690      * Requirements:
691      *
692      * - `accounts` and `ids` must have the same length.
693      */
694     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
695         external
696         view
697         returns (uint256[] memory);
698 
699     /**
700      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
701      *
702      * Emits an {ApprovalForAll} event.
703      *
704      * Requirements:
705      *
706      * - `operator` cannot be the caller.
707      */
708     function setApprovalForAll(address operator, bool approved) external;
709 
710     /**
711      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
712      *
713      * See {setApprovalForAll}.
714      */
715     function isApprovedForAll(address account, address operator) external view returns (bool);
716 
717     /**
718      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
719      *
720      * Emits a {TransferSingle} event.
721      *
722      * Requirements:
723      *
724      * - `to` cannot be the zero address.
725      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
726      * - `from` must have a balance of tokens of type `id` of at least `amount`.
727      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
728      * acceptance magic value.
729      */
730     function safeTransferFrom(
731         address from,
732         address to,
733         uint256 id,
734         uint256 amount,
735         bytes calldata data
736     ) external;
737 
738     /**
739      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
740      *
741      * Emits a {TransferBatch} event.
742      *
743      * Requirements:
744      *
745      * - `ids` and `amounts` must have the same length.
746      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
747      * acceptance magic value.
748      */
749     function safeBatchTransferFrom(
750         address from,
751         address to,
752         uint256[] calldata ids,
753         uint256[] calldata amounts,
754         bytes calldata data
755     ) external;
756 }
757 
758 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
759 
760 
761 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
762 
763 pragma solidity ^0.8.0;
764 
765 
766 /**
767  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
768  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
769  *
770  * _Available since v3.1._
771  */
772 interface IERC1155MetadataURI is IERC1155 {
773     /**
774      * @dev Returns the URI for token type `id`.
775      *
776      * If the `\{id\}` substring is present in the URI, it must be replaced by
777      * clients with the actual token type ID.
778      */
779     function uri(uint256 id) external view returns (string memory);
780 }
781 
782 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
783 
784 
785 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
786 
787 pragma solidity ^0.8.0;
788 
789 
790 /**
791  * @dev Implementation of the {IERC165} interface.
792  *
793  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
794  * for the additional interface id that will be supported. For example:
795  *
796  * ```solidity
797  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
798  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
799  * }
800  * ```
801  *
802  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
803  */
804 abstract contract ERC165 is IERC165 {
805     /**
806      * @dev See {IERC165-supportsInterface}.
807      */
808     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
809         return interfaceId == type(IERC165).interfaceId;
810     }
811 }
812 
813 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
814 
815 
816 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
817 
818 pragma solidity ^0.8.0;
819 
820 
821 
822 
823 
824 
825 
826 /**
827  * @dev Implementation of the basic standard multi-token.
828  * See https://eips.ethereum.org/EIPS/eip-1155
829  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
830  *
831  * _Available since v3.1._
832  */
833 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
834     using Address for address;
835 
836     // Mapping from token ID to account balances
837     mapping(uint256 => mapping(address => uint256)) private _balances;
838 
839     // Mapping from account to operator approvals
840     mapping(address => mapping(address => bool)) private _operatorApprovals;
841 
842     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
843     string private _uri;
844 
845     /**
846      * @dev See {_setURI}.
847      */
848     constructor(string memory uri_) {
849         _setURI(uri_);
850     }
851 
852     /**
853      * @dev See {IERC165-supportsInterface}.
854      */
855     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
856         return
857             interfaceId == type(IERC1155).interfaceId ||
858             interfaceId == type(IERC1155MetadataURI).interfaceId ||
859             super.supportsInterface(interfaceId);
860     }
861 
862     /**
863      * @dev See {IERC1155MetadataURI-uri}.
864      *
865      * This implementation returns the same URI for *all* token types. It relies
866      * on the token type ID substitution mechanism
867      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
868      *
869      * Clients calling this function must replace the `\{id\}` substring with the
870      * actual token type ID.
871      */
872     function uri(uint256) public view virtual override returns (string memory) {
873         return _uri;
874     }
875 
876     /**
877      * @dev See {IERC1155-balanceOf}.
878      *
879      * Requirements:
880      *
881      * - `account` cannot be the zero address.
882      */
883     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
884         require(account != address(0), "ERC1155: balance query for the zero address");
885         return _balances[id][account];
886     }
887 
888     /**
889      * @dev See {IERC1155-balanceOfBatch}.
890      *
891      * Requirements:
892      *
893      * - `accounts` and `ids` must have the same length.
894      */
895     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
896         public
897         view
898         virtual
899         override
900         returns (uint256[] memory)
901     {
902         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
903 
904         uint256[] memory batchBalances = new uint256[](accounts.length);
905 
906         for (uint256 i = 0; i < accounts.length; ++i) {
907             batchBalances[i] = balanceOf(accounts[i], ids[i]);
908         }
909 
910         return batchBalances;
911     }
912 
913     /**
914      * @dev See {IERC1155-setApprovalForAll}.
915      */
916     function setApprovalForAll(address operator, bool approved) public virtual override {
917         _setApprovalForAll(_msgSender(), operator, approved);
918     }
919 
920     /**
921      * @dev See {IERC1155-isApprovedForAll}.
922      */
923     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
924         return _operatorApprovals[account][operator];
925     }
926 
927     /**
928      * @dev See {IERC1155-safeTransferFrom}.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 id,
934         uint256 amount,
935         bytes memory data
936     ) public virtual override {
937         require(
938             from == _msgSender() || isApprovedForAll(from, _msgSender()),
939             "ERC1155: caller is not owner nor approved"
940         );
941         _safeTransferFrom(from, to, id, amount, data);
942     }
943 
944     /**
945      * @dev See {IERC1155-safeBatchTransferFrom}.
946      */
947     function safeBatchTransferFrom(
948         address from,
949         address to,
950         uint256[] memory ids,
951         uint256[] memory amounts,
952         bytes memory data
953     ) public virtual override {
954         require(
955             from == _msgSender() || isApprovedForAll(from, _msgSender()),
956             "ERC1155: transfer caller is not owner nor approved"
957         );
958         _safeBatchTransferFrom(from, to, ids, amounts, data);
959     }
960 
961     /**
962      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
963      *
964      * Emits a {TransferSingle} event.
965      *
966      * Requirements:
967      *
968      * - `to` cannot be the zero address.
969      * - `from` must have a balance of tokens of type `id` of at least `amount`.
970      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
971      * acceptance magic value.
972      */
973     function _safeTransferFrom(
974         address from,
975         address to,
976         uint256 id,
977         uint256 amount,
978         bytes memory data
979     ) internal virtual {
980         require(to != address(0), "ERC1155: transfer to the zero address");
981 
982         address operator = _msgSender();
983         uint256[] memory ids = _asSingletonArray(id);
984         uint256[] memory amounts = _asSingletonArray(amount);
985 
986         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
987 
988         uint256 fromBalance = _balances[id][from];
989         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
990         unchecked {
991             _balances[id][from] = fromBalance - amount;
992         }
993         _balances[id][to] += amount;
994 
995         emit TransferSingle(operator, from, to, id, amount);
996 
997         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
998 
999         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1000     }
1001 
1002     /**
1003      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1004      *
1005      * Emits a {TransferBatch} event.
1006      *
1007      * Requirements:
1008      *
1009      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1010      * acceptance magic value.
1011      */
1012     function _safeBatchTransferFrom(
1013         address from,
1014         address to,
1015         uint256[] memory ids,
1016         uint256[] memory amounts,
1017         bytes memory data
1018     ) internal virtual {
1019         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1020         require(to != address(0), "ERC1155: transfer to the zero address");
1021 
1022         address operator = _msgSender();
1023 
1024         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1025 
1026         for (uint256 i = 0; i < ids.length; ++i) {
1027             uint256 id = ids[i];
1028             uint256 amount = amounts[i];
1029 
1030             uint256 fromBalance = _balances[id][from];
1031             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1032             unchecked {
1033                 _balances[id][from] = fromBalance - amount;
1034             }
1035             _balances[id][to] += amount;
1036         }
1037 
1038         emit TransferBatch(operator, from, to, ids, amounts);
1039 
1040         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1041 
1042         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1043     }
1044 
1045     /**
1046      * @dev Sets a new URI for all token types, by relying on the token type ID
1047      * substitution mechanism
1048      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1049      *
1050      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1051      * URI or any of the amounts in the JSON file at said URI will be replaced by
1052      * clients with the token type ID.
1053      *
1054      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1055      * interpreted by clients as
1056      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1057      * for token type ID 0x4cce0.
1058      *
1059      * See {uri}.
1060      *
1061      * Because these URIs cannot be meaningfully represented by the {URI} event,
1062      * this function emits no events.
1063      */
1064     function _setURI(string memory newuri) internal virtual {
1065         _uri = newuri;
1066     }
1067 
1068     /**
1069      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1070      *
1071      * Emits a {TransferSingle} event.
1072      *
1073      * Requirements:
1074      *
1075      * - `to` cannot be the zero address.
1076      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1077      * acceptance magic value.
1078      */
1079     function _mint(
1080         address to,
1081         uint256 id,
1082         uint256 amount,
1083         bytes memory data
1084     ) internal virtual {
1085         require(to != address(0), "ERC1155: mint to the zero address");
1086 
1087         address operator = _msgSender();
1088         uint256[] memory ids = _asSingletonArray(id);
1089         uint256[] memory amounts = _asSingletonArray(amount);
1090 
1091         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1092 
1093         _balances[id][to] += amount;
1094         emit TransferSingle(operator, address(0), to, id, amount);
1095 
1096         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1097 
1098         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1099     }
1100 
1101     /**
1102      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1103      *
1104      * Requirements:
1105      *
1106      * - `ids` and `amounts` must have the same length.
1107      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1108      * acceptance magic value.
1109      */
1110     function _mintBatch(
1111         address to,
1112         uint256[] memory ids,
1113         uint256[] memory amounts,
1114         bytes memory data
1115     ) internal virtual {
1116         require(to != address(0), "ERC1155: mint to the zero address");
1117         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1118 
1119         address operator = _msgSender();
1120 
1121         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1122 
1123         for (uint256 i = 0; i < ids.length; i++) {
1124             _balances[ids[i]][to] += amounts[i];
1125         }
1126 
1127         emit TransferBatch(operator, address(0), to, ids, amounts);
1128 
1129         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1130 
1131         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1132     }
1133 
1134     /**
1135      * @dev Destroys `amount` tokens of token type `id` from `from`
1136      *
1137      * Requirements:
1138      *
1139      * - `from` cannot be the zero address.
1140      * - `from` must have at least `amount` tokens of token type `id`.
1141      */
1142     function _burn(
1143         address from,
1144         uint256 id,
1145         uint256 amount
1146     ) internal virtual {
1147         require(from != address(0), "ERC1155: burn from the zero address");
1148 
1149         address operator = _msgSender();
1150         uint256[] memory ids = _asSingletonArray(id);
1151         uint256[] memory amounts = _asSingletonArray(amount);
1152 
1153         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1154 
1155         uint256 fromBalance = _balances[id][from];
1156         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1157         unchecked {
1158             _balances[id][from] = fromBalance - amount;
1159         }
1160 
1161         emit TransferSingle(operator, from, address(0), id, amount);
1162 
1163         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1164     }
1165 
1166     /**
1167      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1168      *
1169      * Requirements:
1170      *
1171      * - `ids` and `amounts` must have the same length.
1172      */
1173     function _burnBatch(
1174         address from,
1175         uint256[] memory ids,
1176         uint256[] memory amounts
1177     ) internal virtual {
1178         require(from != address(0), "ERC1155: burn from the zero address");
1179         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1180 
1181         address operator = _msgSender();
1182 
1183         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1184 
1185         for (uint256 i = 0; i < ids.length; i++) {
1186             uint256 id = ids[i];
1187             uint256 amount = amounts[i];
1188 
1189             uint256 fromBalance = _balances[id][from];
1190             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1191             unchecked {
1192                 _balances[id][from] = fromBalance - amount;
1193             }
1194         }
1195 
1196         emit TransferBatch(operator, from, address(0), ids, amounts);
1197 
1198         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1199     }
1200 
1201     /**
1202      * @dev Approve `operator` to operate on all of `owner` tokens
1203      *
1204      * Emits a {ApprovalForAll} event.
1205      */
1206     function _setApprovalForAll(
1207         address owner,
1208         address operator,
1209         bool approved
1210     ) internal virtual {
1211         require(owner != operator, "ERC1155: setting approval status for self");
1212         _operatorApprovals[owner][operator] = approved;
1213         emit ApprovalForAll(owner, operator, approved);
1214     }
1215 
1216     /**
1217      * @dev Hook that is called before any token transfer. This includes minting
1218      * and burning, as well as batched variants.
1219      *
1220      * The same hook is called on both single and batched variants. For single
1221      * transfers, the length of the `id` and `amount` arrays will be 1.
1222      *
1223      * Calling conditions (for each `id` and `amount` pair):
1224      *
1225      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1226      * of token type `id` will be  transferred to `to`.
1227      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1228      * for `to`.
1229      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1230      * will be burned.
1231      * - `from` and `to` are never both zero.
1232      * - `ids` and `amounts` have the same, non-zero length.
1233      *
1234      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1235      */
1236     function _beforeTokenTransfer(
1237         address operator,
1238         address from,
1239         address to,
1240         uint256[] memory ids,
1241         uint256[] memory amounts,
1242         bytes memory data
1243     ) internal virtual {}
1244 
1245     /**
1246      * @dev Hook that is called after any token transfer. This includes minting
1247      * and burning, as well as batched variants.
1248      *
1249      * The same hook is called on both single and batched variants. For single
1250      * transfers, the length of the `id` and `amount` arrays will be 1.
1251      *
1252      * Calling conditions (for each `id` and `amount` pair):
1253      *
1254      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1255      * of token type `id` will be  transferred to `to`.
1256      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1257      * for `to`.
1258      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1259      * will be burned.
1260      * - `from` and `to` are never both zero.
1261      * - `ids` and `amounts` have the same, non-zero length.
1262      *
1263      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1264      */
1265     function _afterTokenTransfer(
1266         address operator,
1267         address from,
1268         address to,
1269         uint256[] memory ids,
1270         uint256[] memory amounts,
1271         bytes memory data
1272     ) internal virtual {}
1273 
1274     function _doSafeTransferAcceptanceCheck(
1275         address operator,
1276         address from,
1277         address to,
1278         uint256 id,
1279         uint256 amount,
1280         bytes memory data
1281     ) private {
1282         if (to.isContract()) {
1283             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1284                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1285                     revert("ERC1155: ERC1155Receiver rejected tokens");
1286                 }
1287             } catch Error(string memory reason) {
1288                 revert(reason);
1289             } catch {
1290                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1291             }
1292         }
1293     }
1294 
1295     function _doSafeBatchTransferAcceptanceCheck(
1296         address operator,
1297         address from,
1298         address to,
1299         uint256[] memory ids,
1300         uint256[] memory amounts,
1301         bytes memory data
1302     ) private {
1303         if (to.isContract()) {
1304             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1305                 bytes4 response
1306             ) {
1307                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1308                     revert("ERC1155: ERC1155Receiver rejected tokens");
1309                 }
1310             } catch Error(string memory reason) {
1311                 revert(reason);
1312             } catch {
1313                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1314             }
1315         }
1316     }
1317 
1318     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1319         uint256[] memory array = new uint256[](1);
1320         array[0] = element;
1321 
1322         return array;
1323     }
1324 }
1325 
1326 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1327 
1328 
1329 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Burnable.sol)
1330 
1331 pragma solidity ^0.8.0;
1332 
1333 
1334 /**
1335  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1336  * own tokens and those that they have been approved to use.
1337  *
1338  * _Available since v3.1._
1339  */
1340 abstract contract ERC1155Burnable is ERC1155 {
1341     function burn(
1342         address account,
1343         uint256 id,
1344         uint256 value
1345     ) public virtual {
1346         require(
1347             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1348             "ERC1155: caller is not owner nor approved"
1349         );
1350 
1351         _burn(account, id, value);
1352     }
1353 
1354     function burnBatch(
1355         address account,
1356         uint256[] memory ids,
1357         uint256[] memory values
1358     ) public virtual {
1359         require(
1360             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1361             "ERC1155: caller is not owner nor approved"
1362         );
1363 
1364         _burnBatch(account, ids, values);
1365     }
1366 }
1367 
1368 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1369 
1370 
1371 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1372 
1373 pragma solidity ^0.8.0;
1374 
1375 
1376 /**
1377  * @dev Required interface of an ERC721 compliant contract.
1378  */
1379 interface IERC721 is IERC165 {
1380     /**
1381      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1382      */
1383     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1384 
1385     /**
1386      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1387      */
1388     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1389 
1390     /**
1391      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1392      */
1393     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1394 
1395     /**
1396      * @dev Returns the number of tokens in ``owner``'s account.
1397      */
1398     function balanceOf(address owner) external view returns (uint256 balance);
1399 
1400     /**
1401      * @dev Returns the owner of the `tokenId` token.
1402      *
1403      * Requirements:
1404      *
1405      * - `tokenId` must exist.
1406      */
1407     function ownerOf(uint256 tokenId) external view returns (address owner);
1408 
1409     /**
1410      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1411      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1412      *
1413      * Requirements:
1414      *
1415      * - `from` cannot be the zero address.
1416      * - `to` cannot be the zero address.
1417      * - `tokenId` token must exist and be owned by `from`.
1418      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1419      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1420      *
1421      * Emits a {Transfer} event.
1422      */
1423     function safeTransferFrom(
1424         address from,
1425         address to,
1426         uint256 tokenId
1427     ) external;
1428 
1429     /**
1430      * @dev Transfers `tokenId` token from `from` to `to`.
1431      *
1432      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1433      *
1434      * Requirements:
1435      *
1436      * - `from` cannot be the zero address.
1437      * - `to` cannot be the zero address.
1438      * - `tokenId` token must be owned by `from`.
1439      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1440      *
1441      * Emits a {Transfer} event.
1442      */
1443     function transferFrom(
1444         address from,
1445         address to,
1446         uint256 tokenId
1447     ) external;
1448 
1449     /**
1450      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1451      * The approval is cleared when the token is transferred.
1452      *
1453      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1454      *
1455      * Requirements:
1456      *
1457      * - The caller must own the token or be an approved operator.
1458      * - `tokenId` must exist.
1459      *
1460      * Emits an {Approval} event.
1461      */
1462     function approve(address to, uint256 tokenId) external;
1463 
1464     /**
1465      * @dev Returns the account approved for `tokenId` token.
1466      *
1467      * Requirements:
1468      *
1469      * - `tokenId` must exist.
1470      */
1471     function getApproved(uint256 tokenId) external view returns (address operator);
1472 
1473     /**
1474      * @dev Approve or remove `operator` as an operator for the caller.
1475      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1476      *
1477      * Requirements:
1478      *
1479      * - The `operator` cannot be the caller.
1480      *
1481      * Emits an {ApprovalForAll} event.
1482      */
1483     function setApprovalForAll(address operator, bool _approved) external;
1484 
1485     /**
1486      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1487      *
1488      * See {setApprovalForAll}
1489      */
1490     function isApprovedForAll(address owner, address operator) external view returns (bool);
1491 
1492     /**
1493      * @dev Safely transfers `tokenId` token from `from` to `to`.
1494      *
1495      * Requirements:
1496      *
1497      * - `from` cannot be the zero address.
1498      * - `to` cannot be the zero address.
1499      * - `tokenId` token must exist and be owned by `from`.
1500      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1501      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1502      *
1503      * Emits a {Transfer} event.
1504      */
1505     function safeTransferFrom(
1506         address from,
1507         address to,
1508         uint256 tokenId,
1509         bytes calldata data
1510     ) external;
1511 }
1512 
1513 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1514 
1515 
1516 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1517 
1518 pragma solidity ^0.8.0;
1519 
1520 
1521 /**
1522  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1523  * @dev See https://eips.ethereum.org/EIPS/eip-721
1524  */
1525 interface IERC721Metadata is IERC721 {
1526     /**
1527      * @dev Returns the token collection name.
1528      */
1529     function name() external view returns (string memory);
1530 
1531     /**
1532      * @dev Returns the token collection symbol.
1533      */
1534     function symbol() external view returns (string memory);
1535 
1536     /**
1537      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1538      */
1539     function tokenURI(uint256 tokenId) external view returns (string memory);
1540 }
1541 
1542 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1543 
1544 
1545 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1546 
1547 pragma solidity ^0.8.0;
1548 
1549 
1550 
1551 
1552 
1553 
1554 
1555 
1556 /**
1557  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1558  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1559  * {ERC721Enumerable}.
1560  */
1561 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1562     using Address for address;
1563     using Strings for uint256;
1564 
1565     // Token name
1566     string private _name;
1567 
1568     // Token symbol
1569     string private _symbol;
1570 
1571     // Mapping from token ID to owner address
1572     mapping(uint256 => address) private _owners;
1573 
1574     // Mapping owner address to token count
1575     mapping(address => uint256) private _balances;
1576 
1577     // Mapping from token ID to approved address
1578     mapping(uint256 => address) private _tokenApprovals;
1579 
1580     // Mapping from owner to operator approvals
1581     mapping(address => mapping(address => bool)) private _operatorApprovals;
1582 
1583     /**
1584      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1585      */
1586     constructor(string memory name_, string memory symbol_) {
1587         _name = name_;
1588         _symbol = symbol_;
1589     }
1590 
1591     /**
1592      * @dev See {IERC165-supportsInterface}.
1593      */
1594     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1595         return
1596             interfaceId == type(IERC721).interfaceId ||
1597             interfaceId == type(IERC721Metadata).interfaceId ||
1598             super.supportsInterface(interfaceId);
1599     }
1600 
1601     /**
1602      * @dev See {IERC721-balanceOf}.
1603      */
1604     function balanceOf(address owner) public view virtual override returns (uint256) {
1605         require(owner != address(0), "ERC721: balance query for the zero address");
1606         return _balances[owner];
1607     }
1608 
1609     /**
1610      * @dev See {IERC721-ownerOf}.
1611      */
1612     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1613         address owner = _owners[tokenId];
1614         require(owner != address(0), "ERC721: owner query for nonexistent token");
1615         return owner;
1616     }
1617 
1618     /**
1619      * @dev See {IERC721Metadata-name}.
1620      */
1621     function name() public view virtual override returns (string memory) {
1622         return _name;
1623     }
1624 
1625     /**
1626      * @dev See {IERC721Metadata-symbol}.
1627      */
1628     function symbol() public view virtual override returns (string memory) {
1629         return _symbol;
1630     }
1631 
1632     /**
1633      * @dev See {IERC721Metadata-tokenURI}.
1634      */
1635     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1636         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1637 
1638         string memory baseURI = _baseURI();
1639         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1640     }
1641 
1642     /**
1643      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1644      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1645      * by default, can be overridden in child contracts.
1646      */
1647     function _baseURI() internal view virtual returns (string memory) {
1648         return "";
1649     }
1650 
1651     /**
1652      * @dev See {IERC721-approve}.
1653      */
1654     function approve(address to, uint256 tokenId) public virtual override {
1655         address owner = ERC721.ownerOf(tokenId);
1656         require(to != owner, "ERC721: approval to current owner");
1657 
1658         require(
1659             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1660             "ERC721: approve caller is not owner nor approved for all"
1661         );
1662 
1663         _approve(to, tokenId);
1664     }
1665 
1666     /**
1667      * @dev See {IERC721-getApproved}.
1668      */
1669     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1670         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1671 
1672         return _tokenApprovals[tokenId];
1673     }
1674 
1675     /**
1676      * @dev See {IERC721-setApprovalForAll}.
1677      */
1678     function setApprovalForAll(address operator, bool approved) public virtual override {
1679         _setApprovalForAll(_msgSender(), operator, approved);
1680     }
1681 
1682     /**
1683      * @dev See {IERC721-isApprovedForAll}.
1684      */
1685     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1686         return _operatorApprovals[owner][operator];
1687     }
1688 
1689     /**
1690      * @dev See {IERC721-transferFrom}.
1691      */
1692     function transferFrom(
1693         address from,
1694         address to,
1695         uint256 tokenId
1696     ) public virtual override {
1697         //solhint-disable-next-line max-line-length
1698         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1699 
1700         _transfer(from, to, tokenId);
1701     }
1702 
1703     /**
1704      * @dev See {IERC721-safeTransferFrom}.
1705      */
1706     function safeTransferFrom(
1707         address from,
1708         address to,
1709         uint256 tokenId
1710     ) public virtual override {
1711         safeTransferFrom(from, to, tokenId, "");
1712     }
1713 
1714     /**
1715      * @dev See {IERC721-safeTransferFrom}.
1716      */
1717     function safeTransferFrom(
1718         address from,
1719         address to,
1720         uint256 tokenId,
1721         bytes memory _data
1722     ) public virtual override {
1723         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1724         _safeTransfer(from, to, tokenId, _data);
1725     }
1726 
1727     /**
1728      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1729      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1730      *
1731      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1732      *
1733      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1734      * implement alternative mechanisms to perform token transfer, such as signature-based.
1735      *
1736      * Requirements:
1737      *
1738      * - `from` cannot be the zero address.
1739      * - `to` cannot be the zero address.
1740      * - `tokenId` token must exist and be owned by `from`.
1741      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1742      *
1743      * Emits a {Transfer} event.
1744      */
1745     function _safeTransfer(
1746         address from,
1747         address to,
1748         uint256 tokenId,
1749         bytes memory _data
1750     ) internal virtual {
1751         _transfer(from, to, tokenId);
1752         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1753     }
1754 
1755     /**
1756      * @dev Returns whether `tokenId` exists.
1757      *
1758      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1759      *
1760      * Tokens start existing when they are minted (`_mint`),
1761      * and stop existing when they are burned (`_burn`).
1762      */
1763     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1764         return _owners[tokenId] != address(0);
1765     }
1766 
1767     /**
1768      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1769      *
1770      * Requirements:
1771      *
1772      * - `tokenId` must exist.
1773      */
1774     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1775         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1776         address owner = ERC721.ownerOf(tokenId);
1777         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1778     }
1779 
1780     /**
1781      * @dev Safely mints `tokenId` and transfers it to `to`.
1782      *
1783      * Requirements:
1784      *
1785      * - `tokenId` must not exist.
1786      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1787      *
1788      * Emits a {Transfer} event.
1789      */
1790     function _safeMint(address to, uint256 tokenId) internal virtual {
1791         _safeMint(to, tokenId, "");
1792     }
1793 
1794     /**
1795      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1796      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1797      */
1798     function _safeMint(
1799         address to,
1800         uint256 tokenId,
1801         bytes memory _data
1802     ) internal virtual {
1803         _mint(to, tokenId);
1804         require(
1805             _checkOnERC721Received(address(0), to, tokenId, _data),
1806             "ERC721: transfer to non ERC721Receiver implementer"
1807         );
1808     }
1809 
1810     /**
1811      * @dev Mints `tokenId` and transfers it to `to`.
1812      *
1813      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1814      *
1815      * Requirements:
1816      *
1817      * - `tokenId` must not exist.
1818      * - `to` cannot be the zero address.
1819      *
1820      * Emits a {Transfer} event.
1821      */
1822     function _mint(address to, uint256 tokenId) internal virtual {
1823         require(to != address(0), "ERC721: mint to the zero address");
1824         require(!_exists(tokenId), "ERC721: token already minted");
1825 
1826         _beforeTokenTransfer(address(0), to, tokenId);
1827 
1828         _balances[to] += 1;
1829         _owners[tokenId] = to;
1830 
1831         emit Transfer(address(0), to, tokenId);
1832 
1833         _afterTokenTransfer(address(0), to, tokenId);
1834     }
1835 
1836     /**
1837      * @dev Destroys `tokenId`.
1838      * The approval is cleared when the token is burned.
1839      *
1840      * Requirements:
1841      *
1842      * - `tokenId` must exist.
1843      *
1844      * Emits a {Transfer} event.
1845      */
1846     function _burn(uint256 tokenId) internal virtual {
1847         address owner = ERC721.ownerOf(tokenId);
1848 
1849         _beforeTokenTransfer(owner, address(0), tokenId);
1850 
1851         // Clear approvals
1852         _approve(address(0), tokenId);
1853 
1854         _balances[owner] -= 1;
1855         delete _owners[tokenId];
1856 
1857         emit Transfer(owner, address(0), tokenId);
1858 
1859         _afterTokenTransfer(owner, address(0), tokenId);
1860     }
1861 
1862     /**
1863      * @dev Transfers `tokenId` from `from` to `to`.
1864      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1865      *
1866      * Requirements:
1867      *
1868      * - `to` cannot be the zero address.
1869      * - `tokenId` token must be owned by `from`.
1870      *
1871      * Emits a {Transfer} event.
1872      */
1873     function _transfer(
1874         address from,
1875         address to,
1876         uint256 tokenId
1877     ) internal virtual {
1878         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1879         require(to != address(0), "ERC721: transfer to the zero address");
1880 
1881         _beforeTokenTransfer(from, to, tokenId);
1882 
1883         // Clear approvals from the previous owner
1884         _approve(address(0), tokenId);
1885 
1886         _balances[from] -= 1;
1887         _balances[to] += 1;
1888         _owners[tokenId] = to;
1889 
1890         emit Transfer(from, to, tokenId);
1891 
1892         _afterTokenTransfer(from, to, tokenId);
1893     }
1894 
1895     /**
1896      * @dev Approve `to` to operate on `tokenId`
1897      *
1898      * Emits a {Approval} event.
1899      */
1900     function _approve(address to, uint256 tokenId) internal virtual {
1901         _tokenApprovals[tokenId] = to;
1902         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1903     }
1904 
1905     /**
1906      * @dev Approve `operator` to operate on all of `owner` tokens
1907      *
1908      * Emits a {ApprovalForAll} event.
1909      */
1910     function _setApprovalForAll(
1911         address owner,
1912         address operator,
1913         bool approved
1914     ) internal virtual {
1915         require(owner != operator, "ERC721: approve to caller");
1916         _operatorApprovals[owner][operator] = approved;
1917         emit ApprovalForAll(owner, operator, approved);
1918     }
1919 
1920     /**
1921      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1922      * The call is not executed if the target address is not a contract.
1923      *
1924      * @param from address representing the previous owner of the given token ID
1925      * @param to target address that will receive the tokens
1926      * @param tokenId uint256 ID of the token to be transferred
1927      * @param _data bytes optional data to send along with the call
1928      * @return bool whether the call correctly returned the expected magic value
1929      */
1930     function _checkOnERC721Received(
1931         address from,
1932         address to,
1933         uint256 tokenId,
1934         bytes memory _data
1935     ) private returns (bool) {
1936         if (to.isContract()) {
1937             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1938                 return retval == IERC721Receiver.onERC721Received.selector;
1939             } catch (bytes memory reason) {
1940                 if (reason.length == 0) {
1941                     revert("ERC721: transfer to non ERC721Receiver implementer");
1942                 } else {
1943                     assembly {
1944                         revert(add(32, reason), mload(reason))
1945                     }
1946                 }
1947             }
1948         } else {
1949             return true;
1950         }
1951     }
1952 
1953     /**
1954      * @dev Hook that is called before any token transfer. This includes minting
1955      * and burning.
1956      *
1957      * Calling conditions:
1958      *
1959      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1960      * transferred to `to`.
1961      * - When `from` is zero, `tokenId` will be minted for `to`.
1962      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1963      * - `from` and `to` are never both zero.
1964      *
1965      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1966      */
1967     function _beforeTokenTransfer(
1968         address from,
1969         address to,
1970         uint256 tokenId
1971     ) internal virtual {}
1972 
1973     /**
1974      * @dev Hook that is called after any transfer of tokens. This includes
1975      * minting and burning.
1976      *
1977      * Calling conditions:
1978      *
1979      * - when `from` and `to` are both non-zero.
1980      * - `from` and `to` are never both zero.
1981      *
1982      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1983      */
1984     function _afterTokenTransfer(
1985         address from,
1986         address to,
1987         uint256 tokenId
1988     ) internal virtual {}
1989 }
1990 
1991 // File: slape.sol
1992 
1993 pragma solidity ^0.8.0;
1994 
1995 
1996 
1997 
1998 /*
1999   ______                                 __          _    _                       _                             
2000 .' ____ \                               [  |        / |_ (_)                     / \                            
2001 | (___ \_|__   _  _ .--.   .---.  _ .--. | |  ,--. `| |-'__  _   __  .---.      / _ \    _ .--.   .---.  .--.   
2002  _.____`.[  | | |[ '/'`\ \/ /__\\[ `/'`\]| | `'_\ : | | [  |[ \ [  ]/ /__\\    / ___ \  [ '/'`\ \/ /__\\( (`\]  
2003 | \____) || \_/ |,| \__/ || \__., | |    | | // | |,| |, | | \ \/ / | \__.,  _/ /   \ \_ | \__/ || \__., `'.'.  
2004  \______.''.__.'_/| ;.__/  '.__.'[___]  [___]\'-;__/\__/[___] \__/   '.__.' |____| |____|| ;.__/  '.__.'[\__) ) 
2005                  [__|                                                                   [__|                        
2006 */
2007 
2008 
2009 contract SUPERLATIVEAPES is ERC721, Ownable {
2010    
2011     using Strings for uint256;
2012     using Counters for Counters.Counter;
2013 
2014     string public baseURI;
2015     string public baseExtension = ".json";
2016 
2017 
2018     uint256 public maxTx = 5;
2019     uint256 public maxPreTx = 2;
2020     uint256 public maxSupply = 4444;
2021     uint256 public presaleSupply = 2400;
2022     uint256 public price = 0.069 ether;
2023    
2024    
2025     //December 16th 3AM GMT
2026     uint256 public presaleTime = 1639623600;
2027     //December 16th 11PM GMT 
2028     uint256 public presaleClose = 1639695600;
2029 
2030     //December 17th 3AM GMT
2031     uint256 public mainsaleTime = 1639710000;
2032    
2033     Counters.Counter private _tokenIdTracker;
2034 
2035     mapping (address => bool) public presaleWallets;
2036     mapping (address => uint256) public presaleWalletLimits;
2037     mapping (address => uint256) public mainsaleWalletLimits;
2038 
2039 
2040     modifier isMainsaleOpen
2041     {
2042          require(block.timestamp >= mainsaleTime);
2043          _;
2044     }
2045     modifier isPresaleOpen
2046     {
2047          require(block.timestamp >= presaleTime && block.timestamp <= presaleClose, "Presale closed!");
2048          _;
2049     }
2050    
2051     constructor(string memory _initBaseURI) ERC721("Superlative Apes", "SLAPE")
2052     {
2053         setBaseURI(_initBaseURI);
2054         for(uint256 i=0; i<80; i++)
2055         {
2056             _tokenIdTracker.increment();
2057             _safeMint(msg.sender, totalToken());
2058         }
2059         
2060     }
2061    
2062     function setPrice(uint256 newPrice) external onlyOwner  {
2063         price = newPrice;
2064     }
2065    
2066     function setMaxTx(uint newMax) external onlyOwner {
2067         maxTx = newMax;
2068     }
2069 
2070     function totalToken() public view returns (uint256) {
2071             return _tokenIdTracker.current();
2072     }
2073 
2074     function mainSale(uint8 mintTotal) public payable isMainsaleOpen
2075     {
2076         uint256 totalMinted = mintTotal + mainsaleWalletLimits[msg.sender];
2077         
2078         require(mintTotal >= 1 && mintTotal <= maxTx, "Mint Amount Incorrect");
2079         require(msg.value >= price * mintTotal, "Minting a SLAPE APE Costs 0.069 Ether Each!");
2080         require(totalToken() <= maxSupply, "SOLD OUT!");
2081         require(totalMinted <= maxTx, "You'll pass mint limit!");
2082        
2083         for(uint i=0;i<mintTotal;i++)
2084         {
2085             mainsaleWalletLimits[msg.sender]++;
2086             _tokenIdTracker.increment();
2087             require(totalToken() <= maxSupply, "SOLD OUT!");
2088             _safeMint(msg.sender, totalToken());
2089         }
2090     }
2091    
2092     function preSale(uint8 mintTotal) public payable isPresaleOpen
2093     {
2094         uint256 totalMinted = mintTotal + presaleWalletLimits[msg.sender];
2095 
2096         require(presaleWallets[msg.sender] == true, "You aren't whitelisted!");
2097         require(mintTotal >= 1 && mintTotal <= maxTx, "Mint Amount Incorrect");
2098         require(msg.value >= price * mintTotal, "Minting a SLAPE APE Costs 0.069 Ether Each!");
2099         require(totalToken() <= presaleSupply, "SOLD OUT!");
2100         require(totalMinted <= maxPreTx, "You'll pass mint limit!");
2101        
2102         for(uint i=0; i<mintTotal; i++)
2103         {
2104             presaleWalletLimits[msg.sender]++;
2105             _tokenIdTracker.increment();
2106             require(totalToken() <= presaleSupply, "SOLD OUT!");
2107             _safeMint(msg.sender, totalToken());
2108         }
2109        
2110     }
2111    
2112     function airdrop(address airdropPatricipent, uint8 tokenID) public payable onlyOwner
2113     {
2114         _transfer(address(this), airdropPatricipent, tokenID);
2115     }
2116    
2117     function addWhiteList(address[] memory whiteListedAddresses) public onlyOwner
2118     {
2119         for(uint256 i=0; i<whiteListedAddresses.length;i++)
2120         {
2121             presaleWallets[whiteListedAddresses[i]] = true;
2122         }
2123     }
2124     function isAddressWhitelisted(address whitelist) public view returns(bool)
2125     {
2126         return presaleWallets[whitelist];
2127     }
2128        
2129     function withdrawContractEther(address payable recipient) external onlyOwner
2130     {
2131         recipient.transfer(getBalance());
2132     }
2133    
2134     function _baseURI() internal view virtual override returns (string memory) {
2135         return baseURI;
2136     }
2137    
2138     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2139         baseURI = _newBaseURI;
2140     }
2141    
2142     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
2143     {
2144         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2145 
2146         string memory currentBaseURI = _baseURI();
2147         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
2148     }
2149     function getBalance() public view returns(uint)
2150     {
2151         return address(this).balance;
2152     }
2153    
2154 
2155 }
2156 // File: serum.sol
2157 
2158 pragma solidity 0.8.7;
2159 
2160 /// SPDX-License-Identifier: UNLICENSED
2161 
2162 contract SuperlativeMagicLaboratory is ERC1155Burnable, Ownable, ReentrancyGuard {
2163 
2164     using Strings for uint256;
2165     SUPERLATIVEAPES public slapeContract;
2166 
2167     string public baseURI;
2168     string public baseExtension = ".json";
2169 
2170 
2171     uint256 constant public MagicVialMaxReserve = 3333;
2172     uint256 constant public MagicHerbsMaxReserve = 1106;
2173     uint256 constant public MagicPotsMaxReserve = 5;
2174 
2175     uint256 public vialMinted;
2176     uint256 public herbsMinted;
2177     uint256 public potsMinted;
2178 
2179 
2180     bool public WhitelistOpen = false;
2181 
2182     mapping (address => uint256) public totalPresaleMinted;
2183 
2184     mapping (address => bool) public whitelistClaim;
2185 
2186     constructor(string memory _initBaseURI, address slapesAddress) ERC1155(_initBaseURI)
2187     {
2188         setBaseURI(_initBaseURI);
2189         slapeContract = SUPERLATIVEAPES(slapesAddress);
2190 
2191         vialMinted++;
2192         _mint(msg.sender, 1, 1, ""); 
2193     }
2194 
2195     function randomNum(uint256 _mod, uint256 _seed, uint256 _salt) internal view returns(uint256)
2196     {
2197         return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, _seed, _salt))) % _mod;
2198     }
2199 
2200     modifier onlySender {
2201         require(msg.sender == tx.origin);
2202         _;
2203     }
2204 
2205     modifier isClaimOpen
2206     {
2207          require(WhitelistOpen == true);
2208          _;
2209     }
2210 
2211     function setClaimOpen() public onlyOwner
2212     {
2213         WhitelistOpen = !WhitelistOpen;
2214     }
2215 
2216     function Whitelist() public nonReentrant onlySender isClaimOpen
2217     {
2218         bool skipHerbs = false;
2219         bool skipPots = false;
2220 
2221         require(whitelistClaim[msg.sender] == false, "You have claimed already!");
2222         require(slapeContract.balanceOf(msg.sender) >= 1, "You dont have anything to claim");
2223         require((vialMinted < MagicVialMaxReserve || herbsMinted < MagicHerbsMaxReserve || potsMinted < MagicPotsMaxReserve) , "No serums left!");
2224 
2225         if(potsMinted >= MagicPotsMaxReserve)
2226         {
2227             skipPots = true;
2228         }
2229         else if(herbsMinted >= MagicHerbsMaxReserve)
2230         {
2231             skipHerbs = true;
2232         }
2233 
2234         for(uint256 i=0; i<slapeContract.balanceOf(msg.sender);i++)
2235         {      
2236             bool notMintedYet = false;
2237             while(!notMintedYet)
2238             {
2239                 uint256 selectedSerum = randomNum(12, (block.timestamp * randomNum(1000, block.timestamp, block.timestamp) * i), (block.timestamp * randomNum(1000, block.timestamp, block.timestamp) * i));
2240                 
2241                 if(selectedSerum == 0 && !skipPots)
2242                 {
2243                     notMintedYet = true;
2244                     potsMinted++;
2245                     _mint(msg.sender, 3, 1, "");                   
2246                 }
2247                 else if(selectedSerum >= 1 && selectedSerum <= 3 && !skipHerbs)
2248                 {
2249                     notMintedYet = true;
2250                     herbsMinted++;
2251                     _mint(msg.sender, 2, 1, "");                   
2252                 }
2253                 else
2254                 {
2255                     notMintedYet = true;
2256                     vialMinted++;
2257                     _mint(msg.sender, 1, 1, "");                  
2258                 }
2259             }
2260         }
2261 
2262         whitelistClaim[msg.sender] = true;
2263 
2264     }
2265 
2266     function _withdraw(address payable address_, uint256 amount_) internal {
2267         (bool success, ) = payable(address_).call{value: amount_}("");
2268         require(success, "Transfer failed");
2269     }
2270 
2271     function withdrawEther() external onlyOwner {
2272         _withdraw(payable(msg.sender), address(this).balance);
2273     }
2274 
2275     function withdrawEtherTo(address payable to_) external onlyOwner {
2276         _withdraw(to_, address(this).balance);
2277     }
2278 
2279     function _baseURI() internal view virtual returns (string memory) {
2280         return baseURI;
2281     }
2282    
2283     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2284         baseURI = _newBaseURI;
2285     }
2286    
2287     function uri(uint256 tokenId) public view override virtual returns (string memory)
2288     {
2289         string memory currentBaseURI = _baseURI();
2290         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
2291     }
2292 }