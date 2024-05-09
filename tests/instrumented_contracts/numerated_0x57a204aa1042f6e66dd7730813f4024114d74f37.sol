1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 
28 
29 /**
30  * @dev Collection of functions related to the address type
31  */
32 library Address {
33     /**
34      * @dev Returns true if `account` is a contract.
35      *
36      * [IMPORTANT]
37      * ====
38      * It is unsafe to assume that an address for which this function returns
39      * false is an externally-owned account (EOA) and not a contract.
40      *
41      * Among others, `isContract` will return false for the following
42      * types of addresses:
43      *
44      *  - an externally-owned account
45      *  - a contract in construction
46      *  - an address where a contract will be created
47      *  - an address where a contract lived, but was destroyed
48      * ====
49      */
50     function isContract(address account) internal view returns (bool) {
51         // This method relies in extcodesize, which returns 0 for contracts in
52         // construction, since the code is only stored at the end of the
53         // constructor execution.
54 
55         uint256 size;
56         // solhint-disable-next-line no-inline-assembly
57         assembly { size := extcodesize(account) }
58         return size > 0;
59     }
60 
61     /**
62      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
63      * `recipient`, forwarding all available gas and reverting on errors.
64      *
65      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
66      * of certain opcodes, possibly making contracts go over the 2300 gas limit
67      * imposed by `transfer`, making them unable to receive funds via
68      * `transfer`. {sendValue} removes this limitation.
69      *
70      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
71      *
72      * IMPORTANT: because control is transferred to `recipient`, care must be
73      * taken to not create reentrancy vulnerabilities. Consider using
74      * {ReentrancyGuard} or the
75      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
76      */
77     function sendValue(address payable recipient, uint256 amount) internal {
78         require(address(this).balance >= amount, "Address: insufficient balance");
79 
80         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
81         (bool success, ) = recipient.call{ value: amount }("");
82         require(success, "Address: unable to send value, recipient may have reverted");
83     }
84 
85     /**
86      * @dev Performs a Solidity function call using a low level `call`. A
87      * plain`call` is an unsafe replacement for a function call: use this
88      * function instead.
89      *
90      * If `target` reverts with a revert reason, it is bubbled up by this
91      * function (like regular Solidity function calls).
92      *
93      * Returns the raw returned data. To convert to the expected return value,
94      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
95      *
96      * Requirements:
97      *
98      * - `target` must be a contract.
99      * - calling `target` with `data` must not revert.
100      *
101      * _Available since v3.1._
102      */
103     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
104       return functionCall(target, data, "Address: low-level call failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
109      * `errorMessage` as a fallback revert reason when `target` reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
114         return _functionCallWithValue(target, data, 0, errorMessage);
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
119      * but also transferring `value` wei to `target`.
120      *
121      * Requirements:
122      *
123      * - the calling contract must have an ETH balance of at least `value`.
124      * - the called Solidity function must be `payable`.
125      *
126      * _Available since v3.1._
127      */
128     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
129         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
134      * with `errorMessage` as a fallback revert reason when `target` reverts.
135      *
136      * _Available since v3.1._
137      */
138     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
139         require(address(this).balance >= value, "Address: insufficient balance for call");
140         return _functionCallWithValue(target, data, value, errorMessage);
141     }
142 
143     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
144         require(isContract(target), "Address: call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
148         if (success) {
149             return returndata;
150         } else {
151             // Look for revert reason and bubble it up if present
152             if (returndata.length > 0) {
153                 // The easiest way to bubble the revert reason is using memory via assembly
154 
155                 // solhint-disable-next-line no-inline-assembly
156                 assembly {
157                     let returndata_size := mload(returndata)
158                     revert(add(32, returndata), returndata_size)
159                 }
160             } else {
161                 revert(errorMessage);
162             }
163         }
164     }
165 }
166 
167 
168 
169 
170 /**
171  * @dev Wrappers over Solidity's arithmetic operations with added overflow
172  * checks.
173  *
174  * Arithmetic operations in Solidity wrap on overflow. This can easily result
175  * in bugs, because programmers usually assume that an overflow raises an
176  * error, which is the standard behavior in high level programming languages.
177  * `SafeMath` restores this intuition by reverting the transaction when an
178  * operation overflows.
179  *
180  * Using this library instead of the unchecked operations eliminates an entire
181  * class of bugs, so it's recommended to use it always.
182  */
183 library SafeMath {
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      *
192      * - Addition cannot overflow.
193      */
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         require(c >= a, "SafeMath: addition overflow");
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the subtraction of two unsigned integers, reverting on
203      * overflow (when the result is negative).
204      *
205      * Counterpart to Solidity's `-` operator.
206      *
207      * Requirements:
208      *
209      * - Subtraction cannot overflow.
210      */
211     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
212         return sub(a, b, "SafeMath: subtraction overflow");
213     }
214 
215     /**
216      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
217      * overflow (when the result is negative).
218      *
219      * Counterpart to Solidity's `-` operator.
220      *
221      * Requirements:
222      *
223      * - Subtraction cannot overflow.
224      */
225     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b <= a, errorMessage);
227         uint256 c = a - b;
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the multiplication of two unsigned integers, reverting on
234      * overflow.
235      *
236      * Counterpart to Solidity's `*` operator.
237      *
238      * Requirements:
239      *
240      * - Multiplication cannot overflow.
241      */
242     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
243         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
244         // benefit is lost if 'b' is also tested.
245         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
246         if (a == 0) {
247             return 0;
248         }
249 
250         uint256 c = a * b;
251         require(c / a == b, "SafeMath: multiplication overflow");
252 
253         return c;
254     }
255 
256     /**
257      * @dev Returns the integer division of two unsigned integers. Reverts on
258      * division by zero. The result is rounded towards zero.
259      *
260      * Counterpart to Solidity's `/` operator. Note: this function uses a
261      * `revert` opcode (which leaves remaining gas untouched) while Solidity
262      * uses an invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function div(uint256 a, uint256 b) internal pure returns (uint256) {
269         return div(a, b, "SafeMath: division by zero");
270     }
271 
272     /**
273      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
274      * division by zero. The result is rounded towards zero.
275      *
276      * Counterpart to Solidity's `/` operator. Note: this function uses a
277      * `revert` opcode (which leaves remaining gas untouched) while Solidity
278      * uses an invalid opcode to revert (consuming all remaining gas).
279      *
280      * Requirements:
281      *
282      * - The divisor cannot be zero.
283      */
284     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
285         require(b > 0, errorMessage);
286         uint256 c = a / b;
287         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
288 
289         return c;
290     }
291 
292     /**
293      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
294      * Reverts when dividing by zero.
295      *
296      * Counterpart to Solidity's `%` operator. This function uses a `revert`
297      * opcode (which leaves remaining gas untouched) while Solidity uses an
298      * invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      *
302      * - The divisor cannot be zero.
303      */
304     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
305         return mod(a, b, "SafeMath: modulo by zero");
306     }
307 
308     /**
309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310      * Reverts with custom message when dividing by zero.
311      *
312      * Counterpart to Solidity's `%` operator. This function uses a `revert`
313      * opcode (which leaves remaining gas untouched) while Solidity uses an
314      * invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
321         require(b != 0, errorMessage);
322         return a % b;
323     }
324 }
325 
326 
327 
328 
329 /*
330  * @dev Provides information about the current execution context, including the
331  * sender of the transaction and its data. While these are generally available
332  * via msg.sender and msg.data, they should not be accessed in such a direct
333  * manner, since when dealing with GSN meta-transactions the account sending and
334  * paying for execution may not be the actual sender (as far as an application
335  * is concerned).
336  *
337  * This contract is only required for intermediate, library-like contracts.
338  */
339 abstract contract Context {
340     function _msgSender() internal view virtual returns (address payable) {
341         return msg.sender;
342     }
343 
344     function _msgData() internal view virtual returns (bytes memory) {
345         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
346         return msg.data;
347     }
348 }
349 
350 
351 
352 
353 /**
354  * @dev String operations.
355  */
356 library Strings {
357     /**
358      * @dev Converts a `uint256` to its ASCII `string` representation.
359      */
360     function toString(uint256 value) internal pure returns (string memory) {
361         // Inspired by OraclizeAPI's implementation - MIT licence
362         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
363 
364         if (value == 0) {
365             return "0";
366         }
367         uint256 temp = value;
368         uint256 digits;
369         while (temp != 0) {
370             digits++;
371             temp /= 10;
372         }
373         bytes memory buffer = new bytes(digits);
374         uint256 index = digits - 1;
375         temp = value;
376         while (temp != 0) {
377             buffer[index--] = byte(uint8(48 + temp % 10));
378             temp /= 10;
379         }
380         return string(buffer);
381     }
382 }
383 
384 
385 interface IBreedManager {
386 	function tryBreed(uint256 _sire, uint256 _matron) external returns(bool);
387 	function tryEvolve(uint256 _tokenId) external view returns(uint256);
388 }
389 pragma experimental ABIEncoderV2;
390 
391 
392 
393 
394 
395 
396 
397 /**
398  * @dev Required interface of an ERC1155 compliant contract, as defined in the
399  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
400  *
401  * _Available since v3.1._
402  */
403 interface IERC1155 is IERC165 {
404     /**
405      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
406      */
407     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
408 
409     /**
410      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
411      * transfers.
412      */
413     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
414 
415     /**
416      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
417      * `approved`.
418      */
419     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
420 
421     /**
422      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
423      *
424      * If an {URI} event was emitted for `id`, the standard
425      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
426      * returned by {IERC1155MetadataURI-uri}.
427      */
428     event URI(string value, uint256 indexed id);
429 
430     /**
431      * @dev Returns the amount of tokens of token type `id` owned by `account`.
432      *
433      * Requirements:
434      *
435      * - `account` cannot be the zero address.
436      */
437     function balanceOf(address account, uint256 id) external view returns (uint256);
438 
439     /**
440      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
441      *
442      * Requirements:
443      *
444      * - `accounts` and `ids` must have the same length.
445      */
446     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
447 
448     /**
449      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
450      *
451      * Emits an {ApprovalForAll} event.
452      *
453      * Requirements:
454      *
455      * - `operator` cannot be the caller.
456      */
457     function setApprovalForAll(address operator, bool approved) external;
458 
459     /**
460      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
461      *
462      * See {setApprovalForAll}.
463      */
464     function isApprovedForAll(address account, address operator) external view returns (bool);
465 
466     /**
467      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
468      *
469      * Emits a {TransferSingle} event.
470      *
471      * Requirements:
472      *
473      * - `to` cannot be the zero address.
474      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
475      * - `from` must have a balance of tokens of type `id` of at least `amount`.
476      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
477      * acceptance magic value.
478      */
479     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
480 
481     /**
482      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
483      *
484      * Emits a {TransferBatch} event.
485      *
486      * Requirements:
487      *
488      * - `ids` and `amounts` must have the same length.
489      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
490      * acceptance magic value.
491      */
492     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
493 }
494 
495 
496 
497 
498 
499 /**
500  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
501  *
502  * These functions can be used to verify that a message was signed by the holder
503  * of the private keys of a given address.
504  */
505 library ECDSA {
506     /**
507      * @dev Returns the address that signed a hashed message (`hash`) with
508      * `signature`. This address can then be used for verification purposes.
509      *
510      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
511      * this function rejects them by requiring the `s` value to be in the lower
512      * half order, and the `v` value to be either 27 or 28.
513      *
514      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
515      * verification to be secure: it is possible to craft signatures that
516      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
517      * this is by receiving a hash of the original message (which may otherwise
518      * be too long), and then calling {toEthSignedMessageHash} on it.
519      */
520     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
521         // Check the signature length
522         if (signature.length != 65) {
523             revert("ECDSA: invalid signature length");
524         }
525 
526         // Divide the signature in r, s and v variables
527         bytes32 r;
528         bytes32 s;
529         uint8 v;
530 
531         // ecrecover takes the signature parameters, and the only way to get them
532         // currently is to use assembly.
533         // solhint-disable-next-line no-inline-assembly
534         assembly {
535             r := mload(add(signature, 0x20))
536             s := mload(add(signature, 0x40))
537             v := byte(0, mload(add(signature, 0x60)))
538         }
539 
540         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
541         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
542         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
543         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
544         //
545         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
546         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
547         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
548         // these malleable signatures as well.
549         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
550             revert("ECDSA: invalid signature 's' value");
551         }
552 
553         if (v != 27 && v != 28) {
554             revert("ECDSA: invalid signature 'v' value");
555         }
556 
557         // If the signature is valid (and not malleable), return the signer address
558         address signer = ecrecover(hash, v, r, s);
559         require(signer != address(0), "ECDSA: invalid signature");
560 
561         return signer;
562     }
563 
564     /**
565      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
566      * replicates the behavior of the
567      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
568      * JSON-RPC method.
569      *
570      * See {recover}.
571      */
572     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
573         // 32 is the length in bytes of hash,
574         // enforced by the type signature above
575         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
576     }
577 }
578 
579 
580 
581 
582 
583 
584 /**
585  * @dev Contract module which provides a basic access control mechanism, where
586  * there is an account (an owner) that can be granted exclusive access to
587  * specific functions.
588  *
589  * By default, the owner account will be the one that deploys the contract. This
590  * can later be changed with {transferOwnership}.
591  *
592  * This module is used through inheritance. It will make available the modifier
593  * `onlyOwner`, which can be applied to your functions to restrict their use to
594  * the owner.
595  */
596 contract Ownable is Context {
597     address private _owner;
598 
599     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
600 
601     /**
602      * @dev Initializes the contract setting the deployer as the initial owner.
603      */
604     constructor () internal {
605         address msgSender = _msgSender();
606         _owner = msgSender;
607         emit OwnershipTransferred(address(0), msgSender);
608     }
609 
610     /**
611      * @dev Returns the address of the current owner.
612      */
613     function owner() public view returns (address) {
614         return _owner;
615     }
616 
617     /**
618      * @dev Throws if called by any account other than the owner.
619      */
620     modifier onlyOwner() {
621         require(_owner == _msgSender(), "Ownable: caller is not the owner");
622         _;
623     }
624 
625     /**
626      * @dev Leaves the contract without owner. It will not be possible to call
627      * `onlyOwner` functions anymore. Can only be called by the current owner.
628      *
629      * NOTE: Renouncing ownership will leave the contract without an owner,
630      * thereby removing any functionality that is only available to the owner.
631      */
632     function renounceOwnership() public virtual onlyOwner {
633         emit OwnershipTransferred(_owner, address(0));
634         _owner = address(0);
635     }
636 
637     /**
638      * @dev Transfers ownership of the contract to a new account (`newOwner`).
639      * Can only be called by the current owner.
640      */
641     function transferOwnership(address newOwner) public virtual onlyOwner {
642         require(newOwner != address(0), "Ownable: new owner is the zero address");
643         emit OwnershipTransferred(_owner, newOwner);
644         _owner = newOwner;
645     }
646 }
647 
648 
649 
650 
651 
652 
653 
654 
655 
656 
657 
658 
659 
660 
661 
662 
663 /**
664  * @dev Required interface of an ERC721 compliant contract.
665  */
666 interface IERC721 is IERC165 {
667     /**
668      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
669      */
670     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
671 
672     /**
673      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
674      */
675     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
676 
677     /**
678      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
679      */
680     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
681 
682     /**
683      * @dev Returns the number of tokens in ``owner``'s account.
684      */
685     function balanceOf(address owner) external view returns (uint256 balance);
686 
687     /**
688      * @dev Returns the owner of the `tokenId` token.
689      *
690      * Requirements:
691      *
692      * - `tokenId` must exist.
693      */
694     function ownerOf(uint256 tokenId) external view returns (address owner);
695 
696     /**
697      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
698      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
699      *
700      * Requirements:
701      *
702      * - `from` cannot be the zero address.
703      * - `to` cannot be the zero address.
704      * - `tokenId` token must exist and be owned by `from`.
705      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
706      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
707      *
708      * Emits a {Transfer} event.
709      */
710     function safeTransferFrom(address from, address to, uint256 tokenId) external;
711 
712     /**
713      * @dev Transfers `tokenId` token from `from` to `to`.
714      *
715      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
716      *
717      * Requirements:
718      *
719      * - `from` cannot be the zero address.
720      * - `to` cannot be the zero address.
721      * - `tokenId` token must be owned by `from`.
722      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
723      *
724      * Emits a {Transfer} event.
725      */
726     function transferFrom(address from, address to, uint256 tokenId) external;
727 
728     /**
729      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
730      * The approval is cleared when the token is transferred.
731      *
732      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
733      *
734      * Requirements:
735      *
736      * - The caller must own the token or be an approved operator.
737      * - `tokenId` must exist.
738      *
739      * Emits an {Approval} event.
740      */
741     function approve(address to, uint256 tokenId) external;
742 
743     /**
744      * @dev Returns the account approved for `tokenId` token.
745      *
746      * Requirements:
747      *
748      * - `tokenId` must exist.
749      */
750     function getApproved(uint256 tokenId) external view returns (address operator);
751 
752     /**
753      * @dev Approve or remove `operator` as an operator for the caller.
754      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
755      *
756      * Requirements:
757      *
758      * - The `operator` cannot be the caller.
759      *
760      * Emits an {ApprovalForAll} event.
761      */
762     function setApprovalForAll(address operator, bool _approved) external;
763 
764     /**
765      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
766      *
767      * See {setApprovalForAll}
768      */
769     function isApprovedForAll(address owner, address operator) external view returns (bool);
770 
771     /**
772       * @dev Safely transfers `tokenId` token from `from` to `to`.
773       *
774       * Requirements:
775       *
776      * - `from` cannot be the zero address.
777      * - `to` cannot be the zero address.
778       * - `tokenId` token must exist and be owned by `from`.
779       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
780       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
781       *
782       * Emits a {Transfer} event.
783       */
784     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
785 }
786 
787 
788 
789 
790 
791 
792 
793 /**
794  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
795  * @dev See https://eips.ethereum.org/EIPS/eip-721
796  */
797 interface IERC721Metadata is IERC721 {
798 
799     /**
800      * @dev Returns the token collection name.
801      */
802     function name() external view returns (string memory);
803 
804     /**
805      * @dev Returns the token collection symbol.
806      */
807     function symbol() external view returns (string memory);
808 
809     /**
810      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
811      */
812     function tokenURI(uint256 tokenId) external view returns (string memory);
813 }
814 
815 
816 
817 
818 
819 
820 
821 /**
822  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
823  * @dev See https://eips.ethereum.org/EIPS/eip-721
824  */
825 interface IERC721Enumerable is IERC721 {
826 
827     /**
828      * @dev Returns the total amount of tokens stored by the contract.
829      */
830     function totalSupply() external view returns (uint256);
831 
832     /**
833      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
834      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
835      */
836     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
837 
838     /**
839      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
840      * Use along with {totalSupply} to enumerate all tokens.
841      */
842     function tokenByIndex(uint256 index) external view returns (uint256);
843 }
844 
845 
846 
847 
848 
849 /**
850  * @title ERC721 token receiver interface
851  * @dev Interface for any contract that wants to support safeTransfers
852  * from ERC721 asset contracts.
853  */
854 interface IERC721Receiver {
855     /**
856      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
857      * by `operator` from `from`, this function is called.
858      *
859      * It must return its Solidity selector to confirm the token transfer.
860      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
861      *
862      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
863      */
864     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
865     external returns (bytes4);
866 }
867 
868 
869 
870 
871 
872 
873 
874 /**
875  * @dev Implementation of the {IERC165} interface.
876  *
877  * Contracts may inherit from this and call {_registerInterface} to declare
878  * their support of an interface.
879  */
880 contract ERC165 is IERC165 {
881     /*
882      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
883      */
884     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
885 
886     /**
887      * @dev Mapping of interface ids to whether or not it's supported.
888      */
889     mapping(bytes4 => bool) private _supportedInterfaces;
890 
891     constructor () internal {
892         // Derived contracts need only register support for their own interfaces,
893         // we register support for ERC165 itself here
894         _registerInterface(_INTERFACE_ID_ERC165);
895     }
896 
897     /**
898      * @dev See {IERC165-supportsInterface}.
899      *
900      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
901      */
902     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
903         return _supportedInterfaces[interfaceId];
904     }
905 
906     /**
907      * @dev Registers the contract as an implementer of the interface defined by
908      * `interfaceId`. Support of the actual ERC165 interface is automatic and
909      * registering its interface id is not required.
910      *
911      * See {IERC165-supportsInterface}.
912      *
913      * Requirements:
914      *
915      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
916      */
917     function _registerInterface(bytes4 interfaceId) internal virtual {
918         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
919         _supportedInterfaces[interfaceId] = true;
920     }
921 }
922 
923 
924 
925 
926 
927 
928 
929 /**
930  * @dev Library for managing
931  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
932  * types.
933  *
934  * Sets have the following properties:
935  *
936  * - Elements are added, removed, and checked for existence in constant time
937  * (O(1)).
938  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
939  *
940  * ```
941  * contract Example {
942  *     // Add the library methods
943  *     using EnumerableSet for EnumerableSet.AddressSet;
944  *
945  *     // Declare a set state variable
946  *     EnumerableSet.AddressSet private mySet;
947  * }
948  * ```
949  *
950  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
951  * (`UintSet`) are supported.
952  */
953 library EnumerableSet {
954     // To implement this library for multiple types with as little code
955     // repetition as possible, we write it in terms of a generic Set type with
956     // bytes32 values.
957     // The Set implementation uses private functions, and user-facing
958     // implementations (such as AddressSet) are just wrappers around the
959     // underlying Set.
960     // This means that we can only create new EnumerableSets for types that fit
961     // in bytes32.
962 
963     struct Set {
964         // Storage of set values
965         bytes32[] _values;
966 
967         // Position of the value in the `values` array, plus 1 because index 0
968         // means a value is not in the set.
969         mapping (bytes32 => uint256) _indexes;
970     }
971 
972     /**
973      * @dev Add a value to a set. O(1).
974      *
975      * Returns true if the value was added to the set, that is if it was not
976      * already present.
977      */
978     function _add(Set storage set, bytes32 value) private returns (bool) {
979         if (!_contains(set, value)) {
980             set._values.push(value);
981             // The value is stored at length-1, but we add 1 to all indexes
982             // and use 0 as a sentinel value
983             set._indexes[value] = set._values.length;
984             return true;
985         } else {
986             return false;
987         }
988     }
989 
990     /**
991      * @dev Removes a value from a set. O(1).
992      *
993      * Returns true if the value was removed from the set, that is if it was
994      * present.
995      */
996     function _remove(Set storage set, bytes32 value) private returns (bool) {
997         // We read and store the value's index to prevent multiple reads from the same storage slot
998         uint256 valueIndex = set._indexes[value];
999 
1000         if (valueIndex != 0) { // Equivalent to contains(set, value)
1001             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1002             // the array, and then remove the last element (sometimes called as 'swap and pop').
1003             // This modifies the order of the array, as noted in {at}.
1004 
1005             uint256 toDeleteIndex = valueIndex - 1;
1006             uint256 lastIndex = set._values.length - 1;
1007 
1008             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1009             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1010 
1011             bytes32 lastvalue = set._values[lastIndex];
1012 
1013             // Move the last value to the index where the value to delete is
1014             set._values[toDeleteIndex] = lastvalue;
1015             // Update the index for the moved value
1016             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1017 
1018             // Delete the slot where the moved value was stored
1019             set._values.pop();
1020 
1021             // Delete the index for the deleted slot
1022             delete set._indexes[value];
1023 
1024             return true;
1025         } else {
1026             return false;
1027         }
1028     }
1029 
1030     /**
1031      * @dev Returns true if the value is in the set. O(1).
1032      */
1033     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1034         return set._indexes[value] != 0;
1035     }
1036 
1037     /**
1038      * @dev Returns the number of values on the set. O(1).
1039      */
1040     function _length(Set storage set) private view returns (uint256) {
1041         return set._values.length;
1042     }
1043 
1044    /**
1045     * @dev Returns the value stored at position `index` in the set. O(1).
1046     *
1047     * Note that there are no guarantees on the ordering of values inside the
1048     * array, and it may change when more values are added or removed.
1049     *
1050     * Requirements:
1051     *
1052     * - `index` must be strictly less than {length}.
1053     */
1054     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1055         require(set._values.length > index, "EnumerableSet: index out of bounds");
1056         return set._values[index];
1057     }
1058 
1059     // AddressSet
1060 
1061     struct AddressSet {
1062         Set _inner;
1063     }
1064 
1065     /**
1066      * @dev Add a value to a set. O(1).
1067      *
1068      * Returns true if the value was added to the set, that is if it was not
1069      * already present.
1070      */
1071     function add(AddressSet storage set, address value) internal returns (bool) {
1072         return _add(set._inner, bytes32(uint256(value)));
1073     }
1074 
1075     /**
1076      * @dev Removes a value from a set. O(1).
1077      *
1078      * Returns true if the value was removed from the set, that is if it was
1079      * present.
1080      */
1081     function remove(AddressSet storage set, address value) internal returns (bool) {
1082         return _remove(set._inner, bytes32(uint256(value)));
1083     }
1084 
1085     /**
1086      * @dev Returns true if the value is in the set. O(1).
1087      */
1088     function contains(AddressSet storage set, address value) internal view returns (bool) {
1089         return _contains(set._inner, bytes32(uint256(value)));
1090     }
1091 
1092     /**
1093      * @dev Returns the number of values in the set. O(1).
1094      */
1095     function length(AddressSet storage set) internal view returns (uint256) {
1096         return _length(set._inner);
1097     }
1098 
1099    /**
1100     * @dev Returns the value stored at position `index` in the set. O(1).
1101     *
1102     * Note that there are no guarantees on the ordering of values inside the
1103     * array, and it may change when more values are added or removed.
1104     *
1105     * Requirements:
1106     *
1107     * - `index` must be strictly less than {length}.
1108     */
1109     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1110         return address(uint256(_at(set._inner, index)));
1111     }
1112 
1113 
1114     // UintSet
1115 
1116     struct UintSet {
1117         Set _inner;
1118     }
1119 
1120     /**
1121      * @dev Add a value to a set. O(1).
1122      *
1123      * Returns true if the value was added to the set, that is if it was not
1124      * already present.
1125      */
1126     function add(UintSet storage set, uint256 value) internal returns (bool) {
1127         return _add(set._inner, bytes32(value));
1128     }
1129 
1130     /**
1131      * @dev Removes a value from a set. O(1).
1132      *
1133      * Returns true if the value was removed from the set, that is if it was
1134      * present.
1135      */
1136     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1137         return _remove(set._inner, bytes32(value));
1138     }
1139 
1140     /**
1141      * @dev Returns true if the value is in the set. O(1).
1142      */
1143     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1144         return _contains(set._inner, bytes32(value));
1145     }
1146 
1147     /**
1148      * @dev Returns the number of values on the set. O(1).
1149      */
1150     function length(UintSet storage set) internal view returns (uint256) {
1151         return _length(set._inner);
1152     }
1153 
1154    /**
1155     * @dev Returns the value stored at position `index` in the set. O(1).
1156     *
1157     * Note that there are no guarantees on the ordering of values inside the
1158     * array, and it may change when more values are added or removed.
1159     *
1160     * Requirements:
1161     *
1162     * - `index` must be strictly less than {length}.
1163     */
1164     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1165         return uint256(_at(set._inner, index));
1166     }
1167 }
1168 
1169 
1170 
1171 
1172 
1173 /**
1174  * @dev Library for managing an enumerable variant of Solidity's
1175  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1176  * type.
1177  *
1178  * Maps have the following properties:
1179  *
1180  * - Entries are added, removed, and checked for existence in constant time
1181  * (O(1)).
1182  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1183  *
1184  * ```
1185  * contract Example {
1186  *     // Add the library methods
1187  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1188  *
1189  *     // Declare a set state variable
1190  *     EnumerableMap.UintToAddressMap private myMap;
1191  * }
1192  * ```
1193  *
1194  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1195  * supported.
1196  */
1197 library EnumerableMap {
1198     // To implement this library for multiple types with as little code
1199     // repetition as possible, we write it in terms of a generic Map type with
1200     // bytes32 keys and values.
1201     // The Map implementation uses private functions, and user-facing
1202     // implementations (such as Uint256ToAddressMap) are just wrappers around
1203     // the underlying Map.
1204     // This means that we can only create new EnumerableMaps for types that fit
1205     // in bytes32.
1206 
1207     struct MapEntry {
1208         bytes32 _key;
1209         bytes32 _value;
1210     }
1211 
1212     struct Map {
1213         // Storage of map keys and values
1214         MapEntry[] _entries;
1215 
1216         // Position of the entry defined by a key in the `entries` array, plus 1
1217         // because index 0 means a key is not in the map.
1218         mapping (bytes32 => uint256) _indexes;
1219     }
1220 
1221     /**
1222      * @dev Adds a key-value pair to a map, or updates the value for an existing
1223      * key. O(1).
1224      *
1225      * Returns true if the key was added to the map, that is if it was not
1226      * already present.
1227      */
1228     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1229         // We read and store the key's index to prevent multiple reads from the same storage slot
1230         uint256 keyIndex = map._indexes[key];
1231 
1232         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1233             map._entries.push(MapEntry({ _key: key, _value: value }));
1234             // The entry is stored at length-1, but we add 1 to all indexes
1235             // and use 0 as a sentinel value
1236             map._indexes[key] = map._entries.length;
1237             return true;
1238         } else {
1239             map._entries[keyIndex - 1]._value = value;
1240             return false;
1241         }
1242     }
1243 
1244     /**
1245      * @dev Removes a key-value pair from a map. O(1).
1246      *
1247      * Returns true if the key was removed from the map, that is if it was present.
1248      */
1249     function _remove(Map storage map, bytes32 key) private returns (bool) {
1250         // We read and store the key's index to prevent multiple reads from the same storage slot
1251         uint256 keyIndex = map._indexes[key];
1252 
1253         if (keyIndex != 0) { // Equivalent to contains(map, key)
1254             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1255             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1256             // This modifies the order of the array, as noted in {at}.
1257 
1258             uint256 toDeleteIndex = keyIndex - 1;
1259             uint256 lastIndex = map._entries.length - 1;
1260 
1261             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1262             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1263 
1264             MapEntry storage lastEntry = map._entries[lastIndex];
1265 
1266             // Move the last entry to the index where the entry to delete is
1267             map._entries[toDeleteIndex] = lastEntry;
1268             // Update the index for the moved entry
1269             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1270 
1271             // Delete the slot where the moved entry was stored
1272             map._entries.pop();
1273 
1274             // Delete the index for the deleted slot
1275             delete map._indexes[key];
1276 
1277             return true;
1278         } else {
1279             return false;
1280         }
1281     }
1282 
1283     /**
1284      * @dev Returns true if the key is in the map. O(1).
1285      */
1286     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1287         return map._indexes[key] != 0;
1288     }
1289 
1290     /**
1291      * @dev Returns the number of key-value pairs in the map. O(1).
1292      */
1293     function _length(Map storage map) private view returns (uint256) {
1294         return map._entries.length;
1295     }
1296 
1297    /**
1298     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1299     *
1300     * Note that there are no guarantees on the ordering of entries inside the
1301     * array, and it may change when more entries are added or removed.
1302     *
1303     * Requirements:
1304     *
1305     * - `index` must be strictly less than {length}.
1306     */
1307     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1308         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1309 
1310         MapEntry storage entry = map._entries[index];
1311         return (entry._key, entry._value);
1312     }
1313 
1314     /**
1315      * @dev Returns the value associated with `key`.  O(1).
1316      *
1317      * Requirements:
1318      *
1319      * - `key` must be in the map.
1320      */
1321     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1322         return _get(map, key, "EnumerableMap: nonexistent key");
1323     }
1324 
1325     /**
1326      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1327      */
1328     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1329         uint256 keyIndex = map._indexes[key];
1330         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1331         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1332     }
1333 
1334     // UintToAddressMap
1335 
1336     struct UintToAddressMap {
1337         Map _inner;
1338     }
1339 
1340     /**
1341      * @dev Adds a key-value pair to a map, or updates the value for an existing
1342      * key. O(1).
1343      *
1344      * Returns true if the key was added to the map, that is if it was not
1345      * already present.
1346      */
1347     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1348         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1349     }
1350 
1351     /**
1352      * @dev Removes a value from a set. O(1).
1353      *
1354      * Returns true if the key was removed from the map, that is if it was present.
1355      */
1356     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1357         return _remove(map._inner, bytes32(key));
1358     }
1359 
1360     /**
1361      * @dev Returns true if the key is in the map. O(1).
1362      */
1363     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1364         return _contains(map._inner, bytes32(key));
1365     }
1366 
1367     /**
1368      * @dev Returns the number of elements in the map. O(1).
1369      */
1370     function length(UintToAddressMap storage map) internal view returns (uint256) {
1371         return _length(map._inner);
1372     }
1373 
1374    /**
1375     * @dev Returns the element stored at position `index` in the set. O(1).
1376     * Note that there are no guarantees on the ordering of values inside the
1377     * array, and it may change when more values are added or removed.
1378     *
1379     * Requirements:
1380     *
1381     * - `index` must be strictly less than {length}.
1382     */
1383     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1384         (bytes32 key, bytes32 value) = _at(map._inner, index);
1385         return (uint256(key), address(uint256(value)));
1386     }
1387 
1388     /**
1389      * @dev Returns the value associated with `key`.  O(1).
1390      *
1391      * Requirements:
1392      *
1393      * - `key` must be in the map.
1394      */
1395     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1396         return address(uint256(_get(map._inner, bytes32(key))));
1397     }
1398 
1399     /**
1400      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1401      */
1402     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1403         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1404     }
1405 }
1406 
1407 
1408 
1409 /**
1410  * @title ERC721 Non-Fungible Token Standard basic implementation
1411  * @dev see https://eips.ethereum.org/EIPS/eip-721
1412  */
1413 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1414     using SafeMath for uint256;
1415     using Address for address;
1416     using EnumerableSet for EnumerableSet.UintSet;
1417     using EnumerableMap for EnumerableMap.UintToAddressMap;
1418     using Strings for uint256;
1419 
1420     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1421     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1422     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1423 
1424     // Mapping from holder address to their (enumerable) set of owned tokens
1425     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1426 
1427     // Enumerable mapping from token ids to their owners
1428     EnumerableMap.UintToAddressMap private _tokenOwners;
1429 
1430     // Mapping from token ID to approved address
1431     mapping (uint256 => address) private _tokenApprovals;
1432 
1433     // Mapping from owner to operator approvals
1434     mapping (address => mapping (address => bool)) private _operatorApprovals;
1435 
1436     // Token name
1437     string private _name;
1438 
1439     // Token symbol
1440     string private _symbol;
1441 
1442     // Optional mapping for token URIs
1443     mapping (uint256 => string) private _tokenURIs;
1444 
1445     // Base URI
1446     string private _baseURI;
1447 
1448     /*
1449      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1450      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1451      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1452      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1453      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1454      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1455      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1456      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1457      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1458      *
1459      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1460      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1461      */
1462     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1463 
1464     /*
1465      *     bytes4(keccak256('name()')) == 0x06fdde03
1466      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1467      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1468      *
1469      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1470      */
1471     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1472 
1473     /*
1474      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1475      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1476      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1477      *
1478      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1479      */
1480     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1481 
1482     /**
1483      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1484      */
1485     constructor (string memory name, string memory symbol) public {
1486         _name = name;
1487         _symbol = symbol;
1488 
1489         // register the supported interfaces to conform to ERC721 via ERC165
1490         _registerInterface(_INTERFACE_ID_ERC721);
1491         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1492         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1493     }
1494 
1495     /**
1496      * @dev See {IERC721-balanceOf}.
1497      */
1498     function balanceOf(address owner) public view override returns (uint256) {
1499         require(owner != address(0), "ERC721: balance query for the zero address");
1500 
1501         return _holderTokens[owner].length();
1502     }
1503 
1504     /**
1505      * @dev See {IERC721-ownerOf}.
1506      */
1507     function ownerOf(uint256 tokenId) public view override returns (address) {
1508         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1509     }
1510 
1511     /**
1512      * @dev See {IERC721Metadata-name}.
1513      */
1514     function name() public view override returns (string memory) {
1515         return _name;
1516     }
1517 
1518     /**
1519      * @dev See {IERC721Metadata-symbol}.
1520      */
1521     function symbol() public view override returns (string memory) {
1522         return _symbol;
1523     }
1524 
1525     /**
1526      * @dev See {IERC721Metadata-tokenURI}.
1527      */
1528     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1529         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1530 
1531         string memory _tokenURI = _tokenURIs[tokenId];
1532 
1533         // If there is no base URI, return the token URI.
1534         if (bytes(_baseURI).length == 0) {
1535             return _tokenURI;
1536         }
1537         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1538         if (bytes(_tokenURI).length > 0) {
1539             return string(abi.encodePacked(_baseURI, _tokenURI));
1540         }
1541         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1542         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1543     }
1544 
1545     /**
1546     * @dev Returns the base URI set via {_setBaseURI}. This will be
1547     * automatically added as a prefix in {tokenURI} to each token's URI, or
1548     * to the token ID if no specific URI is set for that token ID.
1549     */
1550     function baseURI() public view returns (string memory) {
1551         return _baseURI;
1552     }
1553 
1554     /**
1555      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1556      */
1557     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1558         return _holderTokens[owner].at(index);
1559     }
1560 
1561     /**
1562      * @dev See {IERC721Enumerable-totalSupply}.
1563      */
1564     function totalSupply() public view override returns (uint256) {
1565         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1566         return _tokenOwners.length();
1567     }
1568 
1569     /**
1570      * @dev See {IERC721Enumerable-tokenByIndex}.
1571      */
1572     function tokenByIndex(uint256 index) public view override returns (uint256) {
1573         (uint256 tokenId, ) = _tokenOwners.at(index);
1574         return tokenId;
1575     }
1576 
1577     /**
1578      * @dev See {IERC721-approve}.
1579      */
1580     function approve(address to, uint256 tokenId) public virtual override {
1581         address owner = ownerOf(tokenId);
1582         require(to != owner, "ERC721: approval to current owner");
1583 
1584         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1585             "ERC721: approve caller is not owner nor approved for all"
1586         );
1587 
1588         _approve(to, tokenId);
1589     }
1590 
1591     /**
1592      * @dev See {IERC721-getApproved}.
1593      */
1594     function getApproved(uint256 tokenId) public view override returns (address) {
1595         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1596 
1597         return _tokenApprovals[tokenId];
1598     }
1599 
1600     /**
1601      * @dev See {IERC721-setApprovalForAll}.
1602      */
1603     function setApprovalForAll(address operator, bool approved) public virtual override {
1604         require(operator != _msgSender(), "ERC721: approve to caller");
1605 
1606         _operatorApprovals[_msgSender()][operator] = approved;
1607         emit ApprovalForAll(_msgSender(), operator, approved);
1608     }
1609 
1610     /**
1611      * @dev See {IERC721-isApprovedForAll}.
1612      */
1613     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1614         return _operatorApprovals[owner][operator];
1615     }
1616 
1617     /**
1618      * @dev See {IERC721-transferFrom}.
1619      */
1620     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1621         //solhint-disable-next-line max-line-length
1622         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1623 
1624         _transfer(from, to, tokenId);
1625     }
1626 
1627     /**
1628      * @dev See {IERC721-safeTransferFrom}.
1629      */
1630     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1631         safeTransferFrom(from, to, tokenId, "");
1632     }
1633 
1634     /**
1635      * @dev See {IERC721-safeTransferFrom}.
1636      */
1637     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1638         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1639         _safeTransfer(from, to, tokenId, _data);
1640     }
1641 
1642     /**
1643      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1644      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1645      *
1646      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1647      *
1648      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1649      * implement alternative mechanisms to perform token transfer, such as signature-based.
1650      *
1651      * Requirements:
1652      *
1653      * - `from` cannot be the zero address.
1654      * - `to` cannot be the zero address.
1655      * - `tokenId` token must exist and be owned by `from`.
1656      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1657      *
1658      * Emits a {Transfer} event.
1659      */
1660     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1661         _transfer(from, to, tokenId);
1662         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1663     }
1664 
1665     /**
1666      * @dev Returns whether `tokenId` exists.
1667      *
1668      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1669      *
1670      * Tokens start existing when they are minted (`_mint`),
1671      * and stop existing when they are burned (`_burn`).
1672      */
1673     function _exists(uint256 tokenId) internal view returns (bool) {
1674         return _tokenOwners.contains(tokenId);
1675     }
1676 
1677     /**
1678      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1679      *
1680      * Requirements:
1681      *
1682      * - `tokenId` must exist.
1683      */
1684     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1685         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1686         address owner = ownerOf(tokenId);
1687         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1688     }
1689 
1690     /**
1691      * @dev Safely mints `tokenId` and transfers it to `to`.
1692      *
1693      * Requirements:
1694      d*
1695      * - `tokenId` must not exist.
1696      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1697      *
1698      * Emits a {Transfer} event.
1699      */
1700     function _safeMint(address to, uint256 tokenId) internal virtual {
1701         _safeMint(to, tokenId, "");
1702     }
1703 
1704     /**
1705      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1706      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1707      */
1708     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1709         _mint(to, tokenId);
1710         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1711     }
1712 
1713     /**
1714      * @dev Mints `tokenId` and transfers it to `to`.
1715      *
1716      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1717      *
1718      * Requirements:
1719      *
1720      * - `tokenId` must not exist.
1721      * - `to` cannot be the zero address.
1722      *
1723      * Emits a {Transfer} event.
1724      */
1725     function _mint(address to, uint256 tokenId) internal virtual {
1726         require(to != address(0), "ERC721: mint to the zero address");
1727         require(!_exists(tokenId), "ERC721: token already minted");
1728 
1729         _beforeTokenTransfer(address(0), to, tokenId);
1730 
1731         _holderTokens[to].add(tokenId);
1732 
1733         _tokenOwners.set(tokenId, to);
1734 
1735         emit Transfer(address(0), to, tokenId);
1736     }
1737 
1738     /**
1739      * @dev Destroys `tokenId`.
1740      * The approval is cleared when the token is burned.
1741      *
1742      * Requirements:
1743      *
1744      * - `tokenId` must exist.
1745      *
1746      * Emits a {Transfer} event.
1747      */
1748     function _burn(uint256 tokenId) internal virtual {
1749         address owner = ownerOf(tokenId);
1750 
1751         _beforeTokenTransfer(owner, address(0), tokenId);
1752 
1753         // Clear approvals
1754         _approve(address(0), tokenId);
1755 
1756         // Clear metadata (if any)
1757         if (bytes(_tokenURIs[tokenId]).length != 0) {
1758             delete _tokenURIs[tokenId];
1759         }
1760 
1761         _holderTokens[owner].remove(tokenId);
1762 
1763         _tokenOwners.remove(tokenId);
1764 
1765         emit Transfer(owner, address(0), tokenId);
1766     }
1767 
1768     /**
1769      * @dev Transfers `tokenId` from `from` to `to`.
1770      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1771      *
1772      * Requirements:
1773      *
1774      * - `to` cannot be the zero address.
1775      * - `tokenId` token must be owned by `from`.
1776      *
1777      * Emits a {Transfer} event.
1778      */
1779     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1780         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1781         require(to != address(0), "ERC721: transfer to the zero address");
1782 
1783         _beforeTokenTransfer(from, to, tokenId);
1784 
1785         // Clear approvals from the previous owner
1786         _approve(address(0), tokenId);
1787 
1788         _holderTokens[from].remove(tokenId);
1789         _holderTokens[to].add(tokenId);
1790 
1791         _tokenOwners.set(tokenId, to);
1792 
1793         emit Transfer(from, to, tokenId);
1794     }
1795 
1796     /**
1797      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1798      *
1799      * Requirements:
1800      *
1801      * - `tokenId` must exist.
1802      */
1803     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1804         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1805         _tokenURIs[tokenId] = _tokenURI;
1806     }
1807 
1808     /**
1809      * @dev Internal function to set the base URI for all token IDs. It is
1810      * automatically added as a prefix to the value returned in {tokenURI},
1811      * or to the token ID if {tokenURI} is empty.
1812      */
1813     function _setBaseURI(string memory baseURI_) internal virtual {
1814         _baseURI = baseURI_;
1815     }
1816 
1817     /**
1818      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1819      * The call is not executed if the target address is not a contract.
1820      *
1821      * @param from address representing the previous owner of the given token ID
1822      * @param to target address that will receive the tokens
1823      * @param tokenId uint256 ID of the token to be transferred
1824      * @param _data bytes optional data to send along with the call
1825      * @return bool whether the call correctly returned the expected magic value
1826      */
1827     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1828         private returns (bool)
1829     {
1830         if (!to.isContract()) {
1831             return true;
1832         }
1833         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1834             IERC721Receiver(to).onERC721Received.selector,
1835             _msgSender(),
1836             from,
1837             tokenId,
1838             _data
1839         ), "ERC721: transfer to non ERC721Receiver implementer");
1840         bytes4 retval = abi.decode(returndata, (bytes4));
1841         return (retval == _ERC721_RECEIVED);
1842     }
1843 
1844     function _approve(address to, uint256 tokenId) private {
1845         _tokenApprovals[tokenId] = to;
1846         emit Approval(ownerOf(tokenId), to, tokenId);
1847     }
1848 
1849     /**
1850      * @dev Hook that is called before any token transfer. This includes minting
1851      * and burning.
1852      *
1853      * Calling conditions:
1854      *
1855      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1856      * transferred to `to`.
1857      * - When `from` is zero, `tokenId` will be minted for `to`.
1858      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1859      * - `from` cannot be the zero address.
1860      * - `to` cannot be the zero address.
1861      *
1862      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1863      */
1864     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1865 }
1866 
1867 
1868 contract ERC721Namable is ERC721 {
1869 
1870 	uint256 public nameChangePrice = 300 ether;
1871 	uint256 constant public BIO_CHANGE_PRICE = 100 ether;
1872 
1873 	mapping(uint256 => string) public bio;
1874 
1875 	// Mapping from token ID to name
1876 	mapping (uint256 => string) private _tokenName;
1877 
1878 	// Mapping if certain name string has already been reserved
1879 	mapping (string => bool) private _nameReserved;
1880 
1881 	event NameChange (uint256 indexed tokenId, string newName);
1882 	event BioChange (uint256 indexed tokenId, string bio);
1883 
1884 	constructor(string memory _name, string memory _symbol, string[] memory _names, uint256[] memory _ids) public ERC721(_name, _symbol) {
1885 		for (uint256 i = 0; i < _ids.length; i++)
1886 		{
1887 			toggleReserveName(_names[i], true);
1888 			_tokenName[_ids[i]] = _names[i];
1889 			emit NameChange(_ids[i], _names[i]);
1890 		}
1891 	}
1892 
1893 	function changeBio(uint256 _tokenId, string memory _bio) public virtual {
1894 		address owner = ownerOf(_tokenId);
1895 		require(_msgSender() == owner, "ERC721: caller is not the owner");
1896 
1897 		bio[_tokenId] = _bio;
1898 		emit BioChange(_tokenId, _bio); 
1899 	}
1900 
1901 	function changeName(uint256 tokenId, string memory newName) public virtual {
1902 		address owner = ownerOf(tokenId);
1903 
1904 		require(_msgSender() == owner, "ERC721: caller is not the owner");
1905 		require(validateName(newName) == true, "Not a valid new name");
1906 		require(sha256(bytes(newName)) != sha256(bytes(_tokenName[tokenId])), "New name is same as the current one");
1907 		require(isNameReserved(newName) == false, "Name already reserved");
1908 
1909 		// If already named, dereserve old name
1910 		if (bytes(_tokenName[tokenId]).length > 0) {
1911 			toggleReserveName(_tokenName[tokenId], false);
1912 		}
1913 		toggleReserveName(newName, true);
1914 		_tokenName[tokenId] = newName;
1915 		emit NameChange(tokenId, newName);
1916 	}
1917 
1918 	/**
1919 	 * @dev Reserves the name if isReserve is set to true, de-reserves if set to false
1920 	 */
1921 	function toggleReserveName(string memory str, bool isReserve) internal {
1922 		_nameReserved[toLower(str)] = isReserve;
1923 	}
1924 
1925 	/**
1926 	 * @dev Returns name of the NFT at index.
1927 	 */
1928 	function tokenNameByIndex(uint256 index) public view returns (string memory) {
1929 		return _tokenName[index];
1930 	}
1931 
1932 	/**
1933 	 * @dev Returns if the name has been reserved.
1934 	 */
1935 	function isNameReserved(string memory nameString) public view returns (bool) {
1936 		return _nameReserved[toLower(nameString)];
1937 	}
1938 
1939 	function validateName(string memory str) public pure returns (bool){
1940 		bytes memory b = bytes(str);
1941 		if(b.length < 1) return false;
1942 		if(b.length > 25) return false; // Cannot be longer than 25 characters
1943 		if(b[0] == 0x20) return false; // Leading space
1944 		if (b[b.length - 1] == 0x20) return false; // Trailing space
1945 
1946 		bytes1 lastChar = b[0];
1947 
1948 		for(uint i; i<b.length; i++){
1949 			bytes1 char = b[i];
1950 
1951 			if (char == 0x20 && lastChar == 0x20) return false; // Cannot contain continous spaces
1952 
1953 			if(
1954 				!(char >= 0x30 && char <= 0x39) && //9-0
1955 				!(char >= 0x41 && char <= 0x5A) && //A-Z
1956 				!(char >= 0x61 && char <= 0x7A) && //a-z
1957 				!(char == 0x20) //space
1958 			)
1959 				return false;
1960 
1961 			lastChar = char;
1962 		}
1963 
1964 		return true;
1965 	}
1966 
1967 	 /**
1968 	 * @dev Converts the string to lowercase
1969 	 */
1970 	function toLower(string memory str) public pure returns (string memory){
1971 		bytes memory bStr = bytes(str);
1972 		bytes memory bLower = new bytes(bStr.length);
1973 		for (uint i = 0; i < bStr.length; i++) {
1974 			// Uppercase character
1975 			if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
1976 				bLower[i] = bytes1(uint8(bStr[i]) + 32);
1977 			} else {
1978 				bLower[i] = bStr[i];
1979 			}
1980 		}
1981 		return string(bLower);
1982 	}
1983 }
1984 
1985 
1986 
1987 
1988 
1989 
1990 
1991 
1992 
1993 
1994 
1995 /**
1996  * @dev Interface of the ERC20 standard as defined in the EIP.
1997  */
1998 interface IERC20 {
1999     /**
2000      * @dev Returns the amount of tokens in existence.
2001      */
2002     function totalSupply() external view returns (uint256);
2003 
2004     /**
2005      * @dev Returns the amount of tokens owned by `account`.
2006      */
2007     function balanceOf(address account) external view returns (uint256);
2008 
2009     /**
2010      * @dev Moves `amount` tokens from the caller's account to `recipient`.
2011      *
2012      * Returns a boolean value indicating whether the operation succeeded.
2013      *
2014      * Emits a {Transfer} event.
2015      */
2016     function transfer(address recipient, uint256 amount) external returns (bool);
2017 
2018     /**
2019      * @dev Returns the remaining number of tokens that `spender` will be
2020      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2021      * zero by default.
2022      *
2023      * This value changes when {approve} or {transferFrom} are called.
2024      */
2025     function allowance(address owner, address spender) external view returns (uint256);
2026 
2027     /**
2028      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2029      *
2030      * Returns a boolean value indicating whether the operation succeeded.
2031      *
2032      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2033      * that someone may use both the old and the new allowance by unfortunate
2034      * transaction ordering. One possible solution to mitigate this race
2035      * condition is to first reduce the spender's allowance to 0 and set the
2036      * desired value afterwards:
2037      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2038      *
2039      * Emits an {Approval} event.
2040      */
2041     function approve(address spender, uint256 amount) external returns (bool);
2042 
2043     /**
2044      * @dev Moves `amount` tokens from `sender` to `recipient` using the
2045      * allowance mechanism. `amount` is then deducted from the caller's
2046      * allowance.
2047      *
2048      * Returns a boolean value indicating whether the operation succeeded.
2049      *
2050      * Emits a {Transfer} event.
2051      */
2052     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
2053 
2054     /**
2055      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2056      * another (`to`).
2057      *
2058      * Note that `value` may be zero.
2059      */
2060     event Transfer(address indexed from, address indexed to, uint256 value);
2061 
2062     /**
2063      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2064      * a call to {approve}. `value` is the new allowance.
2065      */
2066     event Approval(address indexed owner, address indexed spender, uint256 value);
2067 }
2068 
2069 
2070 
2071 
2072 /**
2073  * @dev Implementation of the {IERC20} interface.
2074  *
2075  * This implementation is agnostic to the way tokens are created. This means
2076  * that a supply mechanism has to be added in a derived contract using {_mint}.
2077  * For a generic mechanism see {ERC20PresetMinterPauser}.
2078  *
2079  * TIP: For a detailed writeup see our guide
2080  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2081  * to implement supply mechanisms].
2082  *
2083  * We have followed general OpenZeppelin guidelines: functions revert instead
2084  * of returning `false` on failure. This behavior is nonetheless conventional
2085  * and does not conflict with the expectations of ERC20 applications.
2086  *
2087  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2088  * This allows applications to reconstruct the allowance for all accounts just
2089  * by listening to said events. Other implementations of the EIP may not emit
2090  * these events, as it isn't required by the specification.
2091  *
2092  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2093  * functions have been added to mitigate the well-known issues around setting
2094  * allowances. See {IERC20-approve}.
2095  */
2096 contract ERC20 is Context, IERC20 {
2097     using SafeMath for uint256;
2098     using Address for address;
2099 
2100     mapping (address => uint256) private _balances;
2101 
2102     mapping (address => mapping (address => uint256)) private _allowances;
2103 
2104     uint256 private _totalSupply;
2105 
2106     string private _name;
2107     string private _symbol;
2108     uint8 private _decimals;
2109 
2110     /**
2111      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
2112      * a default value of 18.
2113      *
2114      * To select a different value for {decimals}, use {_setupDecimals}.
2115      *
2116      * All three of these values are immutable: they can only be set once during
2117      * construction.
2118      */
2119     constructor (string memory name, string memory symbol) public {
2120         _name = name;
2121         _symbol = symbol;
2122         _decimals = 18;
2123     }
2124 
2125     /**
2126      * @dev Returns the name of the token.
2127      */
2128     function name() public view returns (string memory) {
2129         return _name;
2130     }
2131 
2132     /**
2133      * @dev Returns the symbol of the token, usually a shorter version of the
2134      * name.
2135      */
2136     function symbol() public view returns (string memory) {
2137         return _symbol;
2138     }
2139 
2140     /**
2141      * @dev Returns the number of decimals used to get its user representation.
2142      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2143      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
2144      *
2145      * Tokens usually opt for a value of 18, imitating the relationship between
2146      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
2147      * called.
2148      *
2149      * NOTE: This information is only used for _display_ purposes: it in
2150      * no way affects any of the arithmetic of the contract, including
2151      * {IERC20-balanceOf} and {IERC20-transfer}.
2152      */
2153     function decimals() public view returns (uint8) {
2154         return _decimals;
2155     }
2156 
2157     /**
2158      * @dev See {IERC20-totalSupply}.
2159      */
2160     function totalSupply() public view override returns (uint256) {
2161         return _totalSupply;
2162     }
2163 
2164     /**
2165      * @dev See {IERC20-balanceOf}.
2166      */
2167     function balanceOf(address account) public view override returns (uint256) {
2168         return _balances[account];
2169     }
2170 
2171     /**
2172      * @dev See {IERC20-transfer}.
2173      *
2174      * Requirements:
2175      *
2176      * - `recipient` cannot be the zero address.
2177      * - the caller must have a balance of at least `amount`.
2178      */
2179     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
2180         _transfer(_msgSender(), recipient, amount);
2181         return true;
2182     }
2183 
2184     /**
2185      * @dev See {IERC20-allowance}.
2186      */
2187     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2188         return _allowances[owner][spender];
2189     }
2190 
2191     /**
2192      * @dev See {IERC20-approve}.
2193      *
2194      * Requirements:
2195      *
2196      * - `spender` cannot be the zero address.
2197      */
2198     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2199         _approve(_msgSender(), spender, amount);
2200         return true;
2201     }
2202 
2203     /**
2204      * @dev See {IERC20-transferFrom}.
2205      *
2206      * Emits an {Approval} event indicating the updated allowance. This is not
2207      * required by the EIP. See the note at the beginning of {ERC20};
2208      *
2209      * Requirements:
2210      * - `sender` and `recipient` cannot be the zero address.
2211      * - `sender` must have a balance of at least `amount`.
2212      * - the caller must have allowance for ``sender``'s tokens of at least
2213      * `amount`.
2214      */
2215     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
2216         _transfer(sender, recipient, amount);
2217         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
2218         return true;
2219     }
2220 
2221     /**
2222      * @dev Atomically increases the allowance granted to `spender` by the caller.
2223      *
2224      * This is an alternative to {approve} that can be used as a mitigation for
2225      * problems described in {IERC20-approve}.
2226      *
2227      * Emits an {Approval} event indicating the updated allowance.
2228      *
2229      * Requirements:
2230      *
2231      * - `spender` cannot be the zero address.
2232      */
2233     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2234         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
2235         return true;
2236     }
2237 
2238     /**
2239      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2240      *
2241      * This is an alternative to {approve} that can be used as a mitigation for
2242      * problems described in {IERC20-approve}.
2243      *
2244      * Emits an {Approval} event indicating the updated allowance.
2245      *
2246      * Requirements:
2247      *
2248      * - `spender` cannot be the zero address.
2249      * - `spender` must have allowance for the caller of at least
2250      * `subtractedValue`.
2251      */
2252     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2253         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
2254         return true;
2255     }
2256 
2257     /**
2258      * @dev Moves tokens `amount` from `sender` to `recipient`.
2259      *
2260      * This is internal function is equivalent to {transfer}, and can be used to
2261      * e.g. implement automatic token fees, slashing mechanisms, etc.
2262      *
2263      * Emits a {Transfer} event.
2264      *
2265      * Requirements:
2266      *
2267      * - `sender` cannot be the zero address.
2268      * - `recipient` cannot be the zero address.
2269      * - `sender` must have a balance of at least `amount`.
2270      */
2271     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
2272         require(sender != address(0), "ERC20: transfer from the zero address");
2273         require(recipient != address(0), "ERC20: transfer to the zero address");
2274 
2275         _beforeTokenTransfer(sender, recipient, amount);
2276 
2277         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
2278         _balances[recipient] = _balances[recipient].add(amount);
2279         emit Transfer(sender, recipient, amount);
2280     }
2281 
2282     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2283      * the total supply.
2284      *
2285      * Emits a {Transfer} event with `from` set to the zero address.
2286      *
2287      * Requirements
2288      *
2289      * - `to` cannot be the zero address.
2290      */
2291     function _mint(address account, uint256 amount) internal virtual {
2292         require(account != address(0), "ERC20: mint to the zero address");
2293 
2294         _beforeTokenTransfer(address(0), account, amount);
2295 
2296         _totalSupply = _totalSupply.add(amount);
2297         _balances[account] = _balances[account].add(amount);
2298         emit Transfer(address(0), account, amount);
2299     }
2300 
2301     /**
2302      * @dev Destroys `amount` tokens from `account`, reducing the
2303      * total supply.
2304      *
2305      * Emits a {Transfer} event with `to` set to the zero address.
2306      *
2307      * Requirements
2308      *
2309      * - `account` cannot be the zero address.
2310      * - `account` must have at least `amount` tokens.
2311      */
2312     function _burn(address account, uint256 amount) internal virtual {
2313         require(account != address(0), "ERC20: burn from the zero address");
2314 
2315         _beforeTokenTransfer(account, address(0), amount);
2316 
2317         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
2318         _totalSupply = _totalSupply.sub(amount);
2319         emit Transfer(account, address(0), amount);
2320     }
2321 
2322     /**
2323      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2324      *
2325      * This internal function is equivalent to `approve`, and can be used to
2326      * e.g. set automatic allowances for certain subsystems, etc.
2327      *
2328      * Emits an {Approval} event.
2329      *
2330      * Requirements:
2331      *
2332      * - `owner` cannot be the zero address.
2333      * - `spender` cannot be the zero address.
2334      */
2335     function _approve(address owner, address spender, uint256 amount) internal virtual {
2336         require(owner != address(0), "ERC20: approve from the zero address");
2337         require(spender != address(0), "ERC20: approve to the zero address");
2338 
2339         _allowances[owner][spender] = amount;
2340         emit Approval(owner, spender, amount);
2341     }
2342 
2343     /**
2344      * @dev Sets {decimals} to a value other than the default one of 18.
2345      *
2346      * WARNING: This function should only be called from the constructor. Most
2347      * applications that interact with token contracts will not expect
2348      * {decimals} to ever change, and may work incorrectly if it does.
2349      */
2350     function _setupDecimals(uint8 decimals_) internal {
2351         _decimals = decimals_;
2352     }
2353 
2354     /**
2355      * @dev Hook that is called before any transfer of tokens. This includes
2356      * minting and burning.
2357      *
2358      * Calling conditions:
2359      *
2360      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2361      * will be to transferred to `to`.
2362      * - when `from` is zero, `amount` tokens will be minted for `to`.
2363      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2364      * - `from` and `to` are never both zero.
2365      *
2366      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2367      */
2368     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
2369 }
2370 
2371 
2372 
2373 
2374 interface IKongz {
2375 	function balanceOG(address _user) external view returns(uint256);
2376 }
2377 
2378 contract YieldToken is ERC20("Banana", "BANANA") {
2379 	using SafeMath for uint256;
2380 
2381 	uint256 constant public BASE_RATE = 10 ether; 
2382 	uint256 constant public INITIAL_ISSUANCE = 300 ether;
2383 	// Tue Mar 18 2031 17:46:47 GMT+0000
2384 	uint256 constant public END = 1931622407;
2385 
2386 	mapping(address => uint256) public rewards;
2387 	mapping(address => uint256) public lastUpdate;
2388 
2389 	IKongz public  kongzContract;
2390 
2391 	event RewardPaid(address indexed user, uint256 reward);
2392 
2393 	constructor(address _kongz) public{
2394 		kongzContract = IKongz(_kongz);
2395 	}
2396 
2397 
2398 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
2399 		return a < b ? a : b;
2400 	}
2401 
2402 	// called when minting many NFTs
2403 	// updated_amount = (balanceOG(user) * base_rate * delta / 86400) + amount * initial rate
2404 	function updateRewardOnMint(address _user, uint256 _amount) external {
2405 		require(msg.sender == address(kongzContract), "Can't call this");
2406 		uint256 time = min(block.timestamp, END);
2407 		uint256 timerUser = lastUpdate[_user];
2408 		if (timerUser > 0)
2409 			rewards[_user] = rewards[_user].add(kongzContract.balanceOG(_user).mul(BASE_RATE.mul((time.sub(timerUser)))).div(86400)
2410 				.add(_amount.mul(INITIAL_ISSUANCE)));
2411 		else 
2412 			rewards[_user] = rewards[_user].add(_amount.mul(INITIAL_ISSUANCE));
2413 		lastUpdate[_user] = time;
2414 	}
2415 
2416 	// called on transfers
2417 	function updateReward(address _from, address _to, uint256 _tokenId) external {
2418 		require(msg.sender == address(kongzContract));
2419 		if (_tokenId < 1001) {
2420 			uint256 time = min(block.timestamp, END);
2421 			uint256 timerFrom = lastUpdate[_from];
2422 			if (timerFrom > 0)
2423 				rewards[_from] += kongzContract.balanceOG(_from).mul(BASE_RATE.mul((time.sub(timerFrom)))).div(86400);
2424 			if (timerFrom != END)
2425 				lastUpdate[_from] = time;
2426 			if (_to != address(0)) {
2427 				uint256 timerTo = lastUpdate[_to];
2428 				if (timerTo > 0)
2429 					rewards[_to] += kongzContract.balanceOG(_to).mul(BASE_RATE.mul((time.sub(timerTo)))).div(86400);
2430 				if (timerTo != END)
2431 					lastUpdate[_to] = time;
2432 			}
2433 		}
2434 	}
2435 
2436 	function getReward(address _to) external {
2437 		require(msg.sender == address(kongzContract));
2438 		uint256 reward = rewards[_to];
2439 		if (reward > 0) {
2440 			rewards[_to] = 0;
2441 			_mint(_to, reward);
2442 			emit RewardPaid(_to, reward);
2443 		}
2444 	}
2445 
2446 	function burn(address _from, uint256 _amount) external {
2447 		require(msg.sender == address(kongzContract));
2448 		_burn(_from, _amount);
2449 	}
2450 
2451 	function getTotalClaimable(address _user) external view returns(uint256) {
2452 		uint256 time = min(block.timestamp, END);
2453 		uint256 pending = kongzContract.balanceOG(_user).mul(BASE_RATE.mul((time.sub(lastUpdate[_user])))).div(86400);
2454 		return rewards[_user] + pending;
2455 	}
2456 }
2457 
2458 
2459 
2460 contract Kongz is ERC721Namable, Ownable {
2461 	using ECDSA for bytes32;
2462 
2463 	struct Kong {
2464 		uint256 genes;
2465 		uint256 bornAt;
2466 	}
2467 
2468 	address public constant burn = address(0x000000000000000000000000000000000000dEaD);
2469 	IERC1155 public constant OPENSEA_STORE = IERC1155(0x495f947276749Ce646f68AC8c248420045cb7b5e);
2470 	address constant public SIGNER = address(0x5E5e683b687f509968D90Acd31ce6b8Cfa3d25E4);
2471 	uint256 constant public BREED_PRICE = 600 ether;
2472 
2473 
2474 	mapping(uint256 => Kong) public kongz;
2475 	mapping(address => uint256) public balanceOG;
2476 	uint256 public bebeCount;
2477 
2478 	YieldToken public yieldToken;
2479 	IBreedManager breedManager;
2480 
2481 	// Events
2482 	event KongIncubated (uint256 tokenId, uint256 matron, uint256 sire);
2483 	event KongBorn(uint256 tokenId, uint256 genes);
2484 	event KongAscended(uint256 tokenId, uint256 genes);
2485 
2486 	constructor(string memory _name, string memory _symbol, string[] memory _names, uint256[] memory _ids) public ERC721Namable(_name, _symbol, _names, _ids) {
2487 		_setBaseURI("https://kongz.herokuapp.com/api/metadata/");
2488 		_mint(msg.sender, 1001);
2489 		_mint(msg.sender, 1002);
2490 		_mint(msg.sender, 1003);
2491 		kongz[1001] = Kong(0, block.timestamp);
2492 		kongz[1002] = Kong(0, block.timestamp);
2493 		kongz[1003] = Kong(0, block.timestamp);
2494 		emit KongIncubated(1001, 0, 0);
2495 		emit KongIncubated(1002, 0, 0);
2496 		emit KongIncubated(1003, 0, 0);
2497 		bebeCount = 3;
2498 	}
2499 
2500 	function updateURI(string memory newURI) public onlyOwner {
2501 		_setBaseURI(newURI);
2502 	}
2503 
2504 	function setBreedingManager(address _manager) external onlyOwner {
2505 		breedManager = IBreedManager(_manager);
2506 	}
2507 
2508 	function setYieldToken(address _yield) external onlyOwner {
2509 		yieldToken = YieldToken(_yield);
2510 	}
2511 
2512 	function changeNamePrice(uint256 _price) external onlyOwner {
2513 		nameChangePrice = _price;
2514 	}
2515 
2516 	function isValidKong(uint256 _id) pure internal returns(bool) {
2517 		// making sure the ID fits the opensea format:
2518 		// first 20 bytes are the maker address
2519 		// next 7 bytes are the nft ID
2520 		// last 5 bytes the value associated to the ID, here will always be equal to 1
2521 		// There will only be 1000 kongz, we can fix boundaries and remove 5 ids that dont match kongz
2522 		if (_id >> 96 != 0x000000000000000000000000a2548e7ad6cee01eeb19d49bedb359aea3d8ad1d)
2523 			return false;
2524 		if (_id & 0x000000000000000000000000000000000000000000000000000000ffffffffff != 1)
2525 			return false;
2526 		uint256 id = (_id & 0x0000000000000000000000000000000000000000ffffffffffffff0000000000) >> 40;
2527 		if (id > 1005 || id == 262 || id == 197 || id == 75 || id == 34 || id == 18 || id == 0)
2528 			return false;
2529 		return true;
2530 	}
2531 
2532 	function returnCorrectId(uint256 _id) pure internal returns(uint256) {
2533 		_id = (_id & 0x0000000000000000000000000000000000000000ffffffffffffff0000000000) >> 40;
2534 		if (_id > 262)
2535 			return _id - 5;
2536 		else if (_id > 197)
2537 			return _id - 4;
2538         else if (_id > 75)
2539             return _id - 3;
2540         else if (_id > 34)
2541             return _id - 2;
2542         else if (_id > 18)
2543             return _id - 1;
2544 		else
2545 			return _id;
2546 	}
2547 
2548 	function ascend(uint256 _tokenId, uint256 _genes, bytes calldata _sig) external {
2549 		require(isValidKong(_tokenId), "Not valid Kong");
2550 		uint256 id = returnCorrectId(_tokenId);
2551 		require(keccak256(abi.encodePacked(id, _genes)).toEthSignedMessageHash().recover(_sig) == SIGNER, "Sig not valid");
2552 	
2553 		kongz[id] = Kong(_genes, block.timestamp);
2554 		_mint(msg.sender, id);
2555 		OPENSEA_STORE.safeTransferFrom(msg.sender, burn, _tokenId, 1, "");
2556 		yieldToken.updateRewardOnMint(msg.sender, 1);
2557 		balanceOG[msg.sender]++;
2558 		emit KongAscended(id, _genes);
2559 	}
2560 
2561 	function breed(uint256 _sire, uint256 _matron) external {
2562 		require(ownerOf(_sire) == msg.sender && ownerOf(_matron) == msg.sender);
2563 		require(breedManager.tryBreed(_sire, _matron));
2564 
2565 		yieldToken.burn(msg.sender, BREED_PRICE);
2566 		bebeCount++;
2567 		uint256 id = 1000 + bebeCount;
2568 		kongz[id] = Kong(0, block.timestamp);
2569 		_mint(msg.sender, id);
2570 		emit KongIncubated(id, _matron, _sire);
2571 	}
2572 
2573 	function evolve(uint256 _tokenId) external {
2574 		require(ownerOf(_tokenId) == msg.sender);
2575 		Kong storage kong = kongz[_tokenId];
2576 		require(kong.genes == 0);
2577 
2578 		uint256 genes = breedManager.tryEvolve(_tokenId);
2579 		kong.genes = genes;
2580 		emit KongBorn(_tokenId, genes);
2581 	}
2582 
2583 	function changeName(uint256 tokenId, string memory newName) public override {
2584 		yieldToken.burn(msg.sender, nameChangePrice);
2585 		super.changeName(tokenId, newName);
2586 	}
2587 
2588 	function changeBio(uint256 tokenId, string memory _bio) public override {
2589 		yieldToken.burn(msg.sender, BIO_CHANGE_PRICE);
2590 		super.changeBio(tokenId, _bio);
2591 	}
2592 
2593 	function getReward() external {
2594 		yieldToken.updateReward(msg.sender, address(0), 0);
2595 		yieldToken.getReward(msg.sender);
2596 	}
2597 
2598 	function transferFrom(address from, address to, uint256 tokenId) public override {
2599 		yieldToken.updateReward(from, to, tokenId);
2600 		if (tokenId < 1001)
2601 		{
2602 			balanceOG[from]--;
2603 			balanceOG[to]++;
2604 		}
2605 		ERC721.transferFrom(from, to, tokenId);
2606 	}
2607 
2608 	function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
2609 		yieldToken.updateReward(from, to, tokenId);
2610 		if (tokenId < 1001)
2611 		{
2612 			balanceOG[from]--;
2613 			balanceOG[to]++;
2614 		}
2615 		ERC721.safeTransferFrom(from, to, tokenId, _data);
2616 	}
2617 
2618 	function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4) {
2619 		require(msg.sender == address(OPENSEA_STORE), "WrappedKongz: not opensea asset");
2620 		return Kongz.onERC1155Received.selector;
2621 	}
2622 }